function log_error {
  echo -e "\e[1;91merror\e[0;97m: $*"
}
function search {
  if [[ $# -gt 0 ]]; then
    fzf -i --height=10 --reverse --cycle --select-1 -q "$@"
  else
    fzf -i --height=10 --reverse --cycle --select-1
  fi
}
function join_by {
  local IFS="$1"
  shift
  echo "$*"
}

if [[ $# -eq 0 ]]; then
  log_error "Usage: q <command> [args]"
  exit 1
else
  command=$1
fi

if [[ -z $command ]]; then
  exit 0
fi

case $command in
  # Git status
  st)
    git status
    ;;
  # Rebuild
  rb)
    sudo nixos-rebuild switch --flake .
    ;;
  # Add ssh key
  ak)
    keys=()
    for f in "$HOME"/.ssh/id_*; do
      if [[ $f != *pub ]]; then
        keys+=("$f")
      fi
    done

    if [[ ${#keys[@]} -eq 0 ]]; then
      exit 0
    fi

    key_name=$(join_by $'\n' "${keys[@]}" | search "$@")
    if [[ -z "$key_name" ]]; then
      exit 0
    fi

    ssh-add "$key_name"
    ;;
  *)
    log_error "Unknown command '$command'"
    ;;
esac
