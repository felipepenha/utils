#!/usr/bin/env bash
# ==============================================================================
# system/fif.sh - Find In Files (fif)
#
# A bash utility function that searches for keywords in file body text
# (rather than filenames, as fzf typically does) and displays interactive
# matches using ripgrep (rg) and fuzzy finder (fzf).
#
# Dependencies:
#   - rg (ripgrep)
#   - fzf (fuzzy finder)
#   - bat (optional, for syntax-highlighted full-file previews)
#
# Installation (standalone command):
#   mkdir -p ~/.local/bin && ln -sf "$(pwd)/system/fif.sh" ~/.local/bin/fif
#
# Usage:
#   fif [options] <search_query> [search_path]
#
# Examples:
#   fif "function_name"
#   fif "TODO" src/
#   fif -e "error_code"      # Open selection directly in $EDITOR
#   fif --help
# ==============================================================================

fif() {
  # Help display
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    cat <<'EOF'
Usage: fif [options] <search_query> [search_path]

Find in Files: Search for keywords inside file contents (body text)
leveraging ripgrep and fzf with context preview.

Arguments:
  <search_query>       The keyword or regex pattern to search for
  [search_path]        Target directory or file to search (default: .)

Options:
  -e, --edit           Open selected file directly in $EDITOR upon selection
  -c, --context <NUM>  Number of context lines to display (default: 5 or $FIF_CONTEXT)
  -h, --help           Show this help message

Interactive Keybindings (inside fzf):
  Enter                Select and print file path (or open in editor if -e is used)
  Ctrl-O / Ctrl-E      Open highlighted file immediately in $EDITOR
  Ctrl-B               View full file with syntax highlighting (via bat)
  Ctrl-R               View matching context lines (via ripgrep)
  Ctrl-/               Toggle preview window on/off

Environment Variables:
  FIF_CONTEXT          Default number of context lines (default: 5)
  FIF_OPEN_IN_EDITOR   If set to 1, always open selection in $EDITOR
  EDITOR               Editor command to use (default: vim)
EOF
    return 0
  fi

  # Dependency checks
  if ! command -v rg >/dev/null 2>&1; then
    echo "Error: 'rg' (ripgrep) is required but not installed or not in PATH." >&2
    return 1
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: 'fzf' is required but not installed or not in PATH." >&2
    return 1
  fi

  local open_in_editor=0
  if [[ -n "${FIF_OPEN_IN_EDITOR:-}" ]]; then
    open_in_editor=1
  fi

  local context_lines="${FIF_CONTEXT:-5}"

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -e|--edit)
        open_in_editor=1
        shift
        ;;
      -c|--context)
        if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
          context_lines="$2"
          shift 2
        else
          echo "Error: --context requires a positive integer." >&2
          return 1
        fi
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "Error: Unknown option '$1'. Use --help for usage." >&2
        return 1
        ;;
      *)
        break
        ;;
    esac
  done

  # Validate required search query argument
  if [[ $# -eq 0 ]]; then
    echo "Need a string to search for!" >&2
    echo "Usage: fif [options] <search_query> [search_path]" >&2
    return 1
  fi

  local query="$1"
  local target_path="${2:-.}"

  # Escape single quotes in query for safe inclusion in preview subshell command
  local escaped_query
  escaped_query="${query//\'/\'\\\'\'}"

  # Default directory and file patterns to ignore (Python envs/caches, AI caches/histories, etc.)
  local rg_globs=(
    --glob '!**/.git/**'
    --glob '!**/__pycache__/**'
    --glob '!**/.venv/**'
    --glob '!**/venv/**'
    --glob '!**/.env/**'
    --glob '!**/.pytest_cache/**'
    --glob '!**/.mypy_cache/**'
    --glob '!**/.ruff_cache/**'
    --glob '!**/.ipynb_checkpoints/**'
    --glob '!**/node_modules/**'
    --glob '!**/.claude/cache/**'
    --glob '!**/.claude/history/**'
    --glob '!**/.claude/sessions/**'
    --glob '!**/.claude/projects/**'
    --glob '!**/.codex/cache/**'
    --glob '!**/.codex/history/**'
    --glob '!**/.codex/sessions/**'
    --glob '!**/.codex/logs/**'
  )

  # Primary preview command leveraging rg with the requested flags:
  # --ignore-case --text --hidden --pretty --context
  local preview_cmd
  preview_cmd="rg --ignore-case --text --hidden --pretty --context ${context_lines} -- '${escaped_query}' {}"

  # Construct fzf options and keybindings
  local fzf_header="Enter: select | Ctrl-O: edit | Ctrl-/: toggle preview"
  local fzf_binds="ctrl-/:toggle-preview,ctrl-o:execute(${EDITOR:-vim} {})+abort,ctrl-e:execute(${EDITOR:-vim} {})+abort"

  if command -v bat >/dev/null 2>&1; then
    fzf_header="Enter: select | Ctrl-O: edit | Ctrl-B: bat full file | Ctrl-R: rg context | Ctrl-/: toggle preview"
    fzf_binds="${fzf_binds},ctrl-b:change-preview(bat --style=numbers --color=always {}),ctrl-r:change-preview(${preview_cmd})"
  fi

  local selected_file
  selected_file="$(
    rg --files-with-matches --no-messages --hidden --text --ignore-case "${rg_globs[@]}" -- "$query" "$target_path" 2>/dev/null | \
    fzf --preview "$preview_cmd" \
        --preview-window="right:60%:wrap" \
        --header="$fzf_header" \
        --bind="$fzf_binds"
  )"

  if [[ -n "$selected_file" ]]; then
    if [[ "$open_in_editor" -eq 1 ]]; then
      "${EDITOR:-vim}" "$selected_file"
    else
      echo "$selected_file"
    fi
  fi
}

# If executed directly as a script (rather than sourced), run fif with all arguments
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  fif "$@"
fi
