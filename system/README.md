# System Utilities

A collection of system configurations and CLI tools for a fast, productive terminal workflow.

---

## 1. `fif` (Find In Files)

An interactive CLI tool that searches for keywords inside **file body text** (rather than just filenames, as `fzf` typically does), leveraging `ripgrep` (`rg`), `fzf`, and `bat` for rich context previews.

Automatically ignores noisy directories even with `--hidden` enabled:
- **Python caches & environments**: `__pycache__/`, `.venv/`, `venv/`, `.env/`, `.pytest_cache/`, `.mypy_cache/`, `.ruff_cache/`, `.ipynb_checkpoints/`
- **AI caches & histories**: `.claude/cache/`, `.claude/history/`, `.claude/sessions/`, `.codex/cache/`, `.codex/.tmp/`, etc. *(skills, prompts, and configs in `.claude/` and `.codex/` remain fully searchable!)*
- **General**: `.git/`, `node_modules/`, `.tmp/`

### Dependencies
```bash
brew install ripgrep fzf bat
```

### Installation

1. **Ensure `~/.local/bin` is in your `$PATH`** (run once):
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
   ```
   *(For `bash`, replace `.zshrc` with `.bashrc`)*

2. **Link the executable**:
   ```bash
   mkdir -p ~/.local/bin
   ln -sf "$(pwd)/system/fif.sh" ~/.local/bin/fif
   ```

### Usage
```bash
fif [options] <search_query> [search_path]
```

#### Examples
```bash
fif "database_connection"       # Search across current directory
fif "TODO" src/                 # Search within a specific path
fif -e "error_handler"          # Open selected file directly in $EDITOR
fif -c 10 "function_name"       # Show 10 context lines (default: 5)
fif --help                      # Show all options and keybindings
```

### Interactive Keybindings (inside `fzf`)
| Keybinding | Action |
| --- | --- |
| `Enter` | Select and print file path (or open in editor if `-e` or `FIF_OPEN_IN_EDITOR=1` was set) |
| `Ctrl-O` / `Ctrl-E` | Open highlighted file immediately in `$EDITOR` |
| `Ctrl-B` | View full file with syntax highlighting (via `bat`) |
| `Ctrl-R` | View matching lines with context (via `rg`) |
| `Ctrl-/` | Toggle preview window |

### Editor Integration (e.g., VS Code)
To open matching files in VS Code without using the mouse:

1. **Set VS Code as your default editor**:
   - For `zsh` (macOS default):
     ```bash
     echo 'export EDITOR="code"' >> ~/.zshrc && source ~/.zshrc
     ```
   - For `bash`:
     ```bash
     echo 'export EDITOR="code"' >> ~/.bashrc && source ~/.bashrc
     ```

2. **Open on selection**:
   - Run with `-e` to have `Enter` open the selected file in VS Code:
     ```bash
     fif -e "database_connection"
     ```
   - Or press `Ctrl-O` inside `fzf` at any time to immediately open the highlighted file.

> **Tip**: If you want `fif` to **always** open files in your editor upon pressing `Enter` without needing to pass `-e`, run:
> ```bash
> echo 'export FIF_OPEN_IN_EDITOR=1' >> ~/.zshrc && source ~/.zshrc
> ```

### Updating `fif`
Whenever there is an update in the remote repository, simply pull:
```bash
cd /path/to/utils && git pull
```
Because `~/.local/bin/fif` is a symlink pointing directly to `system/fif.sh`, your command is **updated instantly** without needing to re-link or reinstall!

---

## 2. Starship Prompt

A fast, customized, and informative shell prompt powered by [Starship](https://starship.rs/).

### Features Included in `starship.toml`
- **Directory**: Colored in **bold blue** (shows 🔒 when read-only).
- **Git Branch & Status**: Branch in **bold purple** with `` symbol; status in **bold red** showing modified (`!`), staged (`+`), untracked (`?`), ahead (`⇡`), or behind (`⇣`).
- **Prompt Character**: Green `➜` for success, red `✗` on failure.
- **Python / Conda**: Displays active conda environment (e.g. `(base)`) and python version.
- **Command Duration & Time**: Shows execution time for long-running commands (`took 2s`) and timestamp (`06:22:35 PM`).

### Dependencies
```bash
# Install Starship prompt engine
brew install starship

# Install a Nerd Font (required for symbols/icons like , , , 🐍, 🔒)
brew install --cask font-fira-code-nerd-font
```

### Configuring iTerm2 for Nerd Fonts
Installing the font file alone is not enough; iTerm2 must be explicitly told to use it for symbols to render properly:

1. **Restart iTerm2**: Fully quit (`Cmd + Q`) and re-open iTerm2 so it detects the newly installed font.
2. **Open Settings**: Press `Cmd + ,`.
3. **Select Profile Text Settings**: Navigate to **Profiles** → select your profile (e.g., **Default**) → click the **Text** tab.
4. **Set Font**: Under **Font**, click the dropdown and select **FiraCode Nerd Font** (or **FiraCode NF**).
   > **Tip**: If you prefer keeping another font for regular code/text, leave the main font as-is, check **"Use a different font for non-ASCII text"**, and select **FiraCode Nerd Font** there.
5. **Verify icon rendering**:
   ```bash
   echo -e "Branch: \ue0a0  Stash: \uf01c"
   ```
   *(Both `` and `` should render cleanly without empty boxes or question marks).*


### Installation

1. **Link the configuration file**:
   ```bash
   mkdir -p ~/.config
   ln -sf "$(pwd)/system/starship.toml" ~/.config/starship.toml
   ```

2. **Enable in your shell**:
   - For `zsh` (macOS default):
     ```bash
     echo 'eval "$(starship init zsh)"' >> ~/.zshrc && source ~/.zshrc
     ```
   - For `bash`:
     ```bash
     echo 'eval "$(starship init bash)"' >> ~/.bashrc && source ~/.bashrc
     ```

### Updating Starship Configuration
Since `~/.config/starship.toml` is symlinked to `system/starship.toml`, any updates pulled from git are applied immediately:
```bash
cd /path/to/utils && git pull
```

### Optional: Terminal Extras (Autocompletion & Colored `ls`)
To replicate the full terminal experience:

```bash
# 1. Autocompletion suggestions as you type
brew install zsh-autosuggestions
echo 'source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc

# 2. Colored file listing and grep
cat <<'EOF' >> ~/.zshrc
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -G'
alias grep='grep --color=auto'
EOF

source ~/.zshrc
```
