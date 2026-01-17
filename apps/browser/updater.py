
#!/usr/bin/env python3
"""
Download Chrome extensions defined in extensions.json into the crx/ folder and
write versions to versions.json as { "<id>": "<version>" }.

Requirements:
- Python 3.8+
- requests (pip install requests)

Behavior:
- Checks that ./extensions.json and ./crx/ exist; errors out if not.
- Reads a JSON array with objects: [{ "id": "<extension_id>", "name": "<output_filename>" }, ...]
- For each item:
  - Uses CHROME_VERSION environment variable as the Chrome version (required).
  - Calls the Chrome update service to fetch XML (fallbacks if it gets a redirect).
  - Extracts the CRX download URL (codebase) and version from the <updatecheck> element.
  - Downloads the CRX and saves to ./crx/{name}
  - Prints the version downloaded.
- Writes/updates versions.json mapping { "id": "version" } for successful items (atomic write).
- Does NOT modify extensions.json.

Exit code:
- 0 if all downloads succeeded.
- 1 if any item failed.
"""

import json
import os
import sys
import tempfile
from pathlib import Path
from xml.etree import ElementTree as ET

import requests


BASE_URL = "https://clients2.google.com/service/update2/crx"


def die(msg: str, code: int = 1) -> None:
    print(f"Error: {msg}", file=sys.stderr)
    sys.exit(code)


def safe_filename(name: str) -> str:
    """
    Make a conservative, filesystem-safe filename. If the resulting name is empty,
    return a placeholder.
    """
    invalid = '<>:"/\\|?*\n\r\t'
    cleaned = "".join(ch for ch in name if ch not in invalid).strip()
    return cleaned or "extension.crx"


def fetch_update_xml(session: requests.Session, chrome_version: str, ext_id: str) -> str:
    """
    Attempt to fetch XML update info for a given extension ID.
    Some responses may redirect to the CRX; if so, retry with 'response=updatecheck'
    to force an XML payload.
    Returns the XML text, or raises on error.
    """
    headers = {
        "Accept": "application/xml,text/xml;q=0.9,*/*;q=0.8",
        "User-Agent": f"Chrome/{chrome_version}",
    }

    # First attempt: redirect-style request (per the given URL).
    params = {
        "response": "redirect",
        "acceptformat": "crx2,crx3",
        "prodversion": chrome_version,
        "x": f"id={ext_id}&uc",
    }
    try:
        r = session.get(BASE_URL, params=params, headers=headers, timeout=30, allow_redirects=False)
    except requests.RequestException as e:
        raise RuntimeError(f"Network error getting update info: {e}") from e

    # If we got XML directly, return it.
    if r.status_code == 200 and "<gupdate" in r.text:
        return r.text

    # Fallback: explicitly ask for XML update check.
    params["response"] = "updatecheck"
    try:
        r2 = session.get(BASE_URL, params=params, headers=headers, timeout=30)
        r2.raise_for_status()
        return r2.text
    except requests.RequestException as e:
        raise RuntimeError(f"Failed to fetch XML update info (fallback): {e}") from e


def find_updatecheck(node: ET.Element):
    """
    Find the <updatecheck> element without relying on namespaces.
    Returns the first element whose tag endswith 'updatecheck', or None.
    """
    for elem in node.iter():
        if isinstance(elem.tag, str) and elem.tag.endswith("updatecheck"):
            return elem
    return None


def parse_update_xml(xml_text: str) -> tuple[str, str]:
    """
    Parse the XML update payload and return (codebase_url, version).
    No namespace validation; XML declaration is fine.
    """
    try:
        root = ET.fromstring(xml_text)
    except ET.ParseError as e:
        raise ValueError(f"Invalid XML received: {e}") from e

    node = find_updatecheck(root)
    if node is None:
        raise ValueError("No <updatecheck> element found in response")

    status = node.get("status")
    if status and status != "ok":
        raise ValueError(f"Update status is '{status}'")

    codebase = node.get("codebase")
    version = node.get("version") or "unknown"

    if not codebase:
        raise ValueError("Missing 'codebase' attribute in <updatecheck>")

    # Normalize to https:// if scheme is missing (e.g., 'clients2.googleusercontent.com/...').
    if not codebase.startswith(("http://", "https://")):
        codebase = "https://" + codebase.lstrip("/")

    return codebase, version


def download_file(session: requests.Session, url: str, dest: Path) -> None:
    """
    Stream-download a URL to dest.
    """
    dest.parent.mkdir(parents=True, exist_ok=True)
    try:
        with session.get(url, timeout=120, stream=True) as r:
            r.raise_for_status()
            with open(dest, "wb") as f:
                for chunk in r.iter_content(chunk_size=256 * 1024):
                    if chunk:
                        f.write(chunk)
    except requests.RequestException as e:
        raise RuntimeError(f"Failed to download {url}: {e}") from e


def atomic_write_json(path: Path, obj) -> None:
    """
    Atomically write JSON to 'path' by writing to a temp file in the same directory
    and then replacing it. Ensures UTF-8 encoding with pretty indenting.
    """
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp_fd, tmp_name = tempfile.mkstemp(prefix=path.name, suffix=".tmp", dir=str(path.parent))
    try:
        with os.fdopen(tmp_fd, "w", encoding="utf-8", newline="\n") as tmp:
            json.dump(obj, tmp, ensure_ascii=False, indent=2)
            tmp.write("\n")
        os.replace(tmp_name, path)  # atomic on most platforms
    except Exception:
        try:
            os.remove(tmp_name)
        except Exception:
            pass
        raise


def main() -> None:
    cwd = Path.cwd()
    extensions_json = cwd / "extensions.json"
    versions_json = cwd / "versions.json"
    crx_dir = cwd / "crx"

    missing = []
    if not extensions_json.is_file():
        missing.append("extensions.json")
    if not crx_dir.is_dir():
        missing.append("crx/")

    if missing:
        die(f"Missing required path(s): {', '.join(missing)}")

    chrome_version = os.environ.get("CHROME_VERSION")
    if not chrome_version:
        die('Environment variable "CHROME_VERSION" is not set.')

    try:
        data = json.loads(extensions_json.read_text(encoding="utf-8"))
    except Exception as e:
        die(f"Failed to read/parse extensions.json: {e}")

    if not isinstance(data, list):
        die('extensions.json must be a JSON array of objects: [{"id": string, "name": string}, ...]')

    # Start with existing versions (if any), then update only successful ones.
    try:
        existing_versions = json.loads(versions_json.read_text(encoding="utf-8")) if versions_json.is_file() else {}
        if not isinstance(existing_versions, dict):
            existing_versions = {}
    except Exception:
        existing_versions = {}

    session = requests.Session()
    any_fail = False
    updated_versions = dict(existing_versions)  # copy

    for i, item in enumerate(data, start=1):
        if not isinstance(item, dict):
            print(f"[{i}] Skipping invalid item (not an object): {item}", file=sys.stderr)
            any_fail = True
            continue

        ext_id = str(item.get("id", "")).strip()
        name = str(item.get("name", "")).strip()

        if not ext_id or not name:
            print(f"[{i}] Skipping item with missing 'id' or 'name': {item}", file=sys.stderr)
            any_fail = True
            continue

        out_path = crx_dir / safe_filename(name)

        try:
            xml_text = fetch_update_xml(session, chrome_version, ext_id)
            codebase_url, version = parse_update_xml(xml_text)
            download_file(session, codebase_url, out_path)
            updated_versions[ext_id] = version
            print(f"[{name}] Downloaded version {version} → {out_path}")
        except Exception as e:
            print(f"[{name}] Failed: {e}", file=sys.stderr)
            any_fail = True
            continue

    # Write versions.json even if some failed, to persist successful ones.
    try:
        atomic_write_json(versions_json, updated_versions)
        print(f"Versions written to {versions_json}")
    except Exception as e:
        print(f"Failed to write versions.json: {e}", file=sys.stderr)
        any_fail = True

    if any_fail:
        sys.exit(1)


if __name__ == "__main__":
    main()

