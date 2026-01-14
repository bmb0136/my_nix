
package main

import (
    "flag"
    "fmt"
    "html/template"
    "io"
    "log"
    "mime/multipart"
    "net/http"
    "os"
    "path/filepath"
    "slices"
    "strings"
)

var uploadTpl = template.Must(template.New("upload").Parse(`
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Upload a File</title>
	<style>
		input[type=file]::file-selector-button {
			display: none;
		}
		input[type=file] {
			border: 1px solid black;
			width: 30%;
			padding: 5%;
			font-size: 1.75em;
		}
	</style>
</head>
<body style="text-align: center">
  <h1>Upload a File</h1>
	<form method="POST" enctype="multipart/form-data" action="/upload">
	<p style="width: 40%; margin: auto;">
			<label>
	<span style="font-size: 2em">Folder:</span>
	<input style="font-size: 2em" name="folder" list="folders" placeholder="Base Folder" />
			</label>
		</p>
		<datalist id="folders">
			{{range .Folders}}
			<option value="{{.}}"></option>
			{{end}}
		</datalist>
	<p>
		<input type="file" name="file" required />
	</p>
	<p>
		<button style="font-size: 2em; width: 40%; height: 2em;" type="submit">Upload</button>
	</p>
	</form>
  {{ if .Message }}
	<p style="font-size: 1.75em">{{ .Message }}</p>
  {{ end }}
	<button onclick="window.location = '/'" style="font-size: 1.75em; width: 40%; height: 3em;">Go Back</button>
	<script>
		document.addEventListener("DOMContentLoaded", function() {
			if (window.history.replaceState) {
				window.history.replaceState(null, null, window.location.href);
			}
		});
	</script>
</body>
</html>
`))

func main() {
    addr := flag.String("addr", ":8080", "address to bind (e.g., :8080, 127.0.0.1:9000)")
    uploadDir := flag.String("upload-dir", "uploads", "directory where uploaded files are saved and served from")
    flag.Parse()

    // Ensure upload directory exists
    info, err := os.Stat(*uploadDir)
    if err != nil {
        log.Fatalf("upload directory error: %v", err)
    }
    if !info.IsDir() {
        log.Fatalf("upload path is not a directory: %s", *uploadDir)
    }

    http.HandleFunc("/upload", func(w http.ResponseWriter, r *http.Request) {
        uploadHandler(w, r, *uploadDir)
    })

    http.Handle("/files/", http.StripPrefix("/files/", http.FileServer(http.Dir(*uploadDir))))

    log.Printf("Upload dir: %s", *uploadDir)
    log.Printf("Server listening on %s", *addr)
    log.Fatal(http.ListenAndServe(*addr, nil))
}

// Recursively list all subfolders under root, returning relative paths
func listSubfolders(root string) ([]string, error) {
    var folders []string
    folders = append(folders, "") // root
    err := filepath.WalkDir(root, func(path string, d os.DirEntry, err error) error {
        if err != nil {
            return err
        }
        if d.IsDir() && path != root {
            rel, _ := filepath.Rel(root, path)
            folders = append(folders, filepath.ToSlash(rel))
        }
        return nil
    })
    if err != nil {
        return nil, err
    }
    slices.SortFunc(folders, func(a, b string) int {
        return strings.Compare(a, b)
    })
    return folders, nil
}

func uploadHandler(w http.ResponseWriter, r *http.Request, uploadDir string) {
    switch r.Method {
    case http.MethodGet:
        folders, err := listSubfolders(uploadDir)
        if err != nil {
            http.Error(w, "cannot list folders", http.StatusInternalServerError)
            return
        }
        w.Header().Set("Content-Type", "text/html; charset=utf-8")
        _ = uploadTpl.Execute(w, map[string]any{
            "Folders": folders,
        })

    case http.MethodPost:
        const huge = 1 << 40 // ~1TB
        if err := r.ParseMultipartForm(huge); err != nil {
            http.Error(w, fmt.Sprintf("cannot parse form: %v", err), http.StatusBadRequest)
            return
        }

        chosen := strings.TrimSpace(r.FormValue("folder"))
        if chosen == "(root)" {
            chosen = ""
        }

        file, header, err := r.FormFile("file")
        if err != nil {
            http.Error(w, fmt.Sprintf("cannot get file: %v", err), http.StatusBadRequest)
            return
        }
        defer file.Close()

        filename := sanitizeFilename(header)
        if filename == "" {
            http.Error(w, "invalid filename", http.StatusBadRequest)
            return
        }

        destDir := uploadDir
        if chosen != "" {
            destDir = filepath.Join(uploadDir, chosen)
            // Create folder if it doesn't exist (mkdir -p)
            if err := os.MkdirAll(destDir, 0o755); err != nil {
                http.Error(w, fmt.Sprintf("cannot create folder: %v", err), http.StatusInternalServerError)
                return
            }
        }

        dstPath := filepath.Join(destDir, filename)
        dstPath = ensureUniquePath(dstPath)

        dst, err := os.Create(dstPath)
        if err != nil {
            http.Error(w, fmt.Sprintf("cannot create file: %v", err), http.StatusInternalServerError)
            return
        }
        defer dst.Close()

        if _, err = io.Copy(dst, file); err != nil {
            http.Error(w, fmt.Sprintf("cannot save file: %v", err), http.StatusInternalServerError)
            return
        }

        folders, _ := listSubfolders(uploadDir)
        w.Header().Set("Content-Type", "text/html; charset=utf-8")
        _ = uploadTpl.Execute(w, map[string]any{
            "Message": fmt.Sprintf("Uploaded: %s", filepath.Base(dstPath)),
            "Folders": folders,
        })

    default:
        w.Header().Set("Allow", "GET, POST")
        http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
    }
}

func sanitizeFilename(h *multipart.FileHeader) string {
    return filepath.Base(h.Filename)
}

func ensureUniquePath(path string) string {
    if _, err := os.Stat(path); os.IsNotExist(err) {
        return path
    }
    dir := filepath.Dir(path)
    base := filepath.Base(path)
    ext := filepath.Ext(base)
    name := base[:len(base)-len(ext)]

    for i := 1; ; i++ {
        alt := filepath.Join(dir, fmt.Sprintf("%s (%d)%s", name, i, ext))
        if _, err := os.Stat(alt); os.IsNotExist(err) {
            return alt
        }
    }
}
