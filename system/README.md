# System

## Installation

### Step 1: Ensure `~/.local/bin` is in your `$PATH`

On macOS, `~/.local/bin` is usually not in `$PATH` by default. Add it once to your `~/.zshrc` (or `~/.bashrc`):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Step 2: Install as a standalone command

Link `fif` into your `$PATH` (e.g., `~/.local/bin`):

```bash
mkdir -p ~/.local/bin
ln -sf "$(pwd)/system/fif.sh" ~/.local/bin/fif
```

---

## Updating

Whenever there is an update in the remote repository, simply pull the latest changes:

```bash
cd /path/to/utils
git pull
```

Because `~/.local/bin/fif` is a symlink pointing directly to `system/fif.sh`, your command is **updated instantly** without needing to re-link or reinstall!

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
