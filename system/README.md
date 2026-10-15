# System

## Installation

### Step 1: Ensure `~/.local/bin` is in your `$PATH`

On macOS, `~/.local/bin` is usually not in `$PATH` by default. Add it once to your `~/.zshrc` (or `~/.bashrc`):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Step 2: Install as a standalone command

#### Option A: If cloning the repository (Recommended)
Creating a symlink ensures that future `git pull` updates are immediately reflected without needing to reinstall:
```bash
mkdir -p ~/.local/bin
ln -sf "$(pwd)/system/fif.sh" ~/.local/bin/fif
```

#### Option B: Standalone download (no clone needed)
```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/felipepenha/utils/main/system/fif.sh -o ~/.local/bin/fif
chmod +x ~/.local/bin/fif
```

---

## Updating

How you update depends on which installation option you chose:

### If you used Option A (Symlink from clone)
Just pull the latest changes from the repository:
```bash
cd /path/to/utils
git pull
```
Because `~/.local/bin/fif` is a symlink pointing directly to `system/fif.sh`, your command is **updated instantly** without any reinstall steps!

### If you used Option B (Standalone curl download)
Re-download the latest version:
```bash
curl -fsSL https://raw.githubusercontent.com/felipepenha/utils/main/system/fif.sh -o ~/.local/bin/fif
chmod +x ~/.local/bin/fif
```

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
