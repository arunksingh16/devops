#!/usr/bin/env zsh
# ─────────────────────────────────────────────
#  repo — folder bookmark manager for your shell
#  Uses ONLY zsh builtins — safe even with a broken PATH
#
#  Install:
#    echo 'source ~/repo.sh' >> ~/.zshrc && source ~/.zshrc
# ─────────────────────────────────────────────

REPO_BOOKMARKS_FILE="${HOME}/.repo_bookmarks"

[[ -f "$REPO_BOOKMARKS_FILE" ]] || print -n "" > "$REPO_BOOKMARKS_FILE"

# ── Colours ────────────────────────────────────
_repo_bold="\033[1m"
_repo_dim="\033[2m"
_repo_reset="\033[0m"
_repo_green="\033[32m"
_repo_yellow="\033[33m"
_repo_red="\033[31m"
_repo_cyan="\033[36m"

# ── Pure-zsh helpers (no external commands) ────

# Find a bookmark by name; sets _repo_entry="name|path" if found
_repo_find() {
  local target="$1"
  _repo_entry=""
  while IFS='|' read -r n p; do
    [[ -z "$n" ]] && continue
    if [[ "$n" == "$target" ]]; then
      _repo_entry="${n}|${p}"
      return 0
    fi
  done < "$REPO_BOOKMARKS_FILE"
  return 1
}

# Rewrite bookmarks file skipping one name (no grep/sed/mktemp)
_repo_write_except() {
  local skip="$1"
  local lines=()
  while IFS='|' read -r n p; do
    [[ -z "$n" ]] && continue
    [[ "$n" == "$skip" ]] && continue
    lines+=("${n}|${p}")
  done < "$REPO_BOOKMARKS_FILE"
  print -n "" > "$REPO_BOOKMARKS_FILE"
  for line in "${lines[@]}"; do
    print "$line" >> "$REPO_BOOKMARKS_FILE"
  done
}

repo() {
  local cmd="$1"

  case "$cmd" in

    # ── ADD ──────────────────────────────────────
    add)
      local name="${2:-}"
      local path="${3:-$(pwd)}"

      # If single extra arg looks like a path, treat it as path
      if [[ -n "$2" && -z "$3" && ("$2" == /* || "$2" == ~*) ]]; then
        path="$2"
        name=""
      fi

      # Expand ~
      path="${path/#\~/$HOME}"

      if [[ ! -d "$path" ]]; then
        echo -e "${_repo_red}✗ Directory not found:${_repo_reset} $path"
        return 1
      fi

      # Auto-name from folder basename — pure shell, no external commands
      if [[ -z "$name" ]]; then
        local stripped="${path%/}"
        name="${stripped##*/}"
      fi
      [[ -z "$name" ]] && name="root"

      # Sanitise
      name="${name//[^a-zA-Z0-9_-]/-}"

      if _repo_find "$name"; then
        echo -e "${_repo_yellow}⚠ Bookmark '${name}' already exists. Use 'repo remove ${name}' first.${_repo_reset}"
        return 1
      fi

      print "${name}|${path}" >> "$REPO_BOOKMARKS_FILE"
      echo -e "${_repo_green}✓ Bookmarked${_repo_reset} ${_repo_bold}${name}${_repo_reset} ${_repo_dim}→ ${path}${_repo_reset}"
      ;;

    # ── GO ───────────────────────────────────────
    go)
      local name="${2:-}"
      if [[ -z "$name" ]]; then
        echo -e "${_repo_yellow}Usage: repo go <n>${_repo_reset}"
        return 1
      fi

      if ! _repo_find "$name"; then
        echo -e "${_repo_red}✗ No bookmark named '${name}'${_repo_reset}"
        echo -e "  Run ${_repo_cyan}repo list${_repo_reset} to see available bookmarks."
        return 1
      fi

      local path="${_repo_entry#*|}"

      if [[ ! -d "$path" ]]; then
        echo -e "${_repo_red}✗ Directory no longer exists:${_repo_reset} $path"
        return 1
      fi

      cd "$path" || return 1
      echo -e "${_repo_green}→${_repo_reset} ${_repo_bold}${name}${_repo_reset} ${_repo_dim}(${path})${_repo_reset}"
      ;;

    # ── LIST ─────────────────────────────────────
    list)
      local has_entries=0
      while IFS='|' read -r n p; do
        [[ -z "$n" ]] && continue
        has_entries=1; break
      done < "$REPO_BOOKMARKS_FILE"

      if [[ $has_entries -eq 0 ]]; then
        echo -e "${_repo_dim}No bookmarks yet. Use 'repo add' to save a folder.${_repo_reset}"
        return 0
      fi

      echo ""
      echo -e "  ${_repo_bold}Repo Bookmarks${_repo_reset}"
      echo -e "  ${_repo_dim}──────────────────────────────────────────${_repo_reset}"

      while IFS='|' read -r n p; do
        [[ -z "$n" ]] && continue
        local icon="${_repo_green}●${_repo_reset}"
        [[ ! -d "$p" ]] && icon="${_repo_red}✗${_repo_reset}"
        printf "  %b  ${_repo_bold}%-20s${_repo_reset} ${_repo_dim}%s${_repo_reset}\n" "$icon" "$n" "$p"
      done < "$REPO_BOOKMARKS_FILE"

      echo ""
      echo -e "  ${_repo_dim}repo go <n>  •  repo remove <n>  •  repo open <n>${_repo_reset}"
      echo ""
      ;;

    # ── REMOVE ───────────────────────────────────
    remove|rm|delete)
      local name="${2:-}"
      if [[ -z "$name" ]]; then
        echo -e "${_repo_yellow}Usage: repo remove <n>${_repo_reset}"
        return 1
      fi

      if ! _repo_find "$name"; then
        echo -e "${_repo_red}✗ No bookmark named '${name}'${_repo_reset}"
        return 1
      fi

      _repo_write_except "$name"
      echo -e "${_repo_green}✓ Removed${_repo_reset} bookmark ${_repo_bold}${name}${_repo_reset}"
      ;;

    # ── RENAME ───────────────────────────────────
    rename|mv)
      local old="${2:-}"
      local new="${3:-}"
      if [[ -z "$old" || -z "$new" ]]; then
        echo -e "${_repo_yellow}Usage: repo rename <old> <new>${_repo_reset}"
        return 1
      fi

      if ! _repo_find "$old"; then
        echo -e "${_repo_red}✗ No bookmark named '${old}'${_repo_reset}"
        return 1
      fi

      new="${new//[^a-zA-Z0-9_-]/-}"

      local lines=()
      while IFS='|' read -r n p; do
        [[ -z "$n" ]] && continue
        [[ "$n" == "$old" ]] && lines+=("${new}|${p}") || lines+=("${n}|${p}")
      done < "$REPO_BOOKMARKS_FILE"

      print -n "" > "$REPO_BOOKMARKS_FILE"
      for line in "${lines[@]}"; do
        print "$line" >> "$REPO_BOOKMARKS_FILE"
      done

      echo -e "${_repo_green}✓ Renamed${_repo_reset} ${_repo_bold}${old}${_repo_reset} → ${_repo_bold}${new}${_repo_reset}"
      ;;

    # ── OPEN in Finder ────────────────────────────
    open)
      local name="${2:-}"
      if [[ -z "$name" ]]; then
        echo -e "${_repo_yellow}Usage: repo open <n>${_repo_reset}"
        return 1
      fi

      if ! _repo_find "$name"; then
        echo -e "${_repo_red}✗ No bookmark named '${name}'${_repo_reset}"
        return 1
      fi

      /usr/bin/open "${_repo_entry#*|}" && \
        echo -e "${_repo_green}✓ Opened${_repo_reset} ${_repo_bold}${name}${_repo_reset} in Finder"
      ;;

    # ── CODE (open in VS Code) ────────────────────
    code)
      local name="${2:-}"
      if [[ -z "$name" ]]; then
        echo -e "${_repo_yellow}Usage: repo code <n>${_repo_reset}"
        return 1
      fi

      if ! _repo_find "$name"; then
        echo -e "${_repo_red}✗ No bookmark named '${name}'${_repo_reset}"
        return 1
      fi

      local path="${_repo_entry#*|}"
      local code_bin="/usr/local/bin/code"
      [[ ! -x "$code_bin" ]] && code_bin="/opt/homebrew/bin/code"
      [[ ! -x "$code_bin" ]] && code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

      if [[ ! -x "$code_bin" ]]; then
        echo -e "${_repo_yellow}⚠ VS Code 'code' binary not found.${_repo_reset}"
        return 1
      fi

      "$code_bin" "$path" && \
        echo -e "${_repo_green}✓ Opened${_repo_reset} ${_repo_bold}${name}${_repo_reset} in VS Code"
      ;;

    # ── HELP ─────────────────────────────────────
    help|--help|-h|"")
      echo ""
      echo -e "  ${_repo_bold}repo${_repo_reset} — folder bookmark manager"
      echo ""
      echo -e "  ${_repo_cyan}repo add${_repo_reset} [name] [path]      Bookmark a folder (defaults to current dir)"
      echo -e "  ${_repo_cyan}repo go${_repo_reset} <n>              cd into bookmarked folder"
      echo -e "  ${_repo_cyan}repo list${_repo_reset}                   Show all bookmarks"
      echo -e "  ${_repo_cyan}repo remove${_repo_reset} <n>          Delete a bookmark"
      echo -e "  ${_repo_cyan}repo rename${_repo_reset} <old> <new>     Rename a bookmark"
      echo -e "  ${_repo_cyan}repo open${_repo_reset} <n>            Open in Finder"
      echo -e "  ${_repo_cyan}repo code${_repo_reset} <n>            Open in VS Code"
      echo ""
      echo -e "  ${_repo_dim}Bookmarks stored in: ${REPO_BOOKMARKS_FILE}${_repo_reset}"
      echo ""
      ;;

    *)
      echo -e "${_repo_red}✗ Unknown command:${_repo_reset} $cmd"
      echo -e "  Run ${_repo_cyan}repo help${_repo_reset} for usage."
      return 1
      ;;
  esac
}

# ── Tab completion ────────────────────────────────────────────────────────────
_repo_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=($(compgen -W "add go list remove rename open code help" -- "$cur"))
    return
  fi

  case "$prev" in
    go|remove|rm|delete|open|code|rename|mv)
      local names=()
      while IFS='|' read -r n p; do
        [[ -n "$n" ]] && names+=("$n")
      done < "$REPO_BOOKMARKS_FILE"
      COMPREPLY=($(compgen -W "${names[*]}" -- "$cur"))
      ;;
  esac
}

complete -F _repo_complete repo
