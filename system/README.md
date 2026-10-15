# System

## Installation

### Install as a standalone command (Recommended)

Make `fif` available system-wide as a command by linking it into your `$PATH` (e.g., `~/.local/bin`):

#### Option A: If cloning the repository
```bash
# Ensure ~/.local/bin exists and is on your PATH
mkdir -p ~/.local/bin
ln -sf "$(pwd)/system/fif.sh" ~/.local/bin/fif
```

#### Option B: Standalone download (no clone needed)
```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/felipepenha/utils/main/system/fif.sh -o ~/.local/bin/fif
chmod +x ~/.local/bin/fif
```

> **Note**: If `~/.local/bin` is not yet in your `$PATH`, add it to your `~/.zshrc` (macOS default) or `~/.bashrc`:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

---

## Utilities

### `fif` (Find In Files)
Searches for keywords inside file contents (body text, rather than filenames) leveraging `ripgrep` (`rg`), `fzf`, and optionally `bat` for interactive syntax-highlighted previews.

#### Dependencies
- [`rg`](https://github.com/BurntSushi/ripgrep): `brew install ripgrep`
- [`fzf`](https://github.com/junegunn/fzf): `brew install fzf`
- [`bat`](https://github.com/sharkdp/bat) *(optional)*: `brew install bat`

#### Usage
```bash
fif [options] <search_query> [search_path]
```

#### Examples
```bash
fif "database_connection"       # Search across current directory
fif "TODO" src/                 # Search in a specific path
fif -e "error_handler"          # Open selected file directly in $EDITOR
fif -c 10 "function_name"       # Show 10 context lines (default: 5)
fif --help                      # Show all options and keybindings
```

#### Interactive Keybindings (inside `fzf`)
| Keybinding | Action |
| --- | --- |
| `Enter` | Select and print file path (or open in editor if `-e` was passed) |
| `Ctrl-O` / `Ctrl-E` | Open highlighted file immediately in `$EDITOR` |
| `Ctrl-B` | View full file with syntax highlighting (via `bat`) |
| `Ctrl-R` | View matching lines with context (via `rg`) |
| `Ctrl-/` | Toggle preview window |
