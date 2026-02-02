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
  ALL_COMMANDS=(
    st
    rb
    ak
    op
    nf
  )
  command=$(join_by $'\n' "${ALL_COMMANDS[@]}" | search)
else
  command=$1
  shift
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
      log_error "No SSH keys found in $HOME/.ssh/id_*"
      exit 1
    fi

    key_name=$(join_by $'\n' "${keys[@]}" | search "$@")
    if [[ -z "$key_name" ]]; then
      exit 0
    fi

    ssh-add "$key_name"
    ;;
  
  # Open project (folder in ~/src)
  op)
    declare -A projects
    keys=()
    for dir in "$HOME"/src/*/; do
      key="$(basename "$dir")"
      keys+=("$key")
      projects["$key"]="$dir"
    done

    if [[ ${#keys[@]} -eq 0 ]]; then
      log_error "No projects found in ~/src"
      exit 1
    fi

    name=$(join_by $'\n' "${keys[@]}" | search "$@")
    if [[ -z "$name" ]]; then
      exit 0
    fi

    tmux new-session -s "$name" -c "${projects["$name"]}"
    ;;

  # New flake (using flake-parts)
  nf)
    nix flake init -t github:hercules-ci/flake-parts
    ;;

  *)
    log_error "Unknown command '$command'"
    ;;
esac
