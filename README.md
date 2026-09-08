# Dotfiles

macOS zsh configuration.

## Features

- 🎨 Clean, monochrome zsh prompt with git status
- 🔍 Function dropdown with `fzf` (`fsel` command)
- 🚀 Curated aliases and functions for macOS
- 🧠 Optional adaptive command learning (`~/.zsh_learning.zsh`)
- 🔐 Secrets kept out of the repo in `~/.private` (see `.private.example`)
- 📦 Guided installation with backup

## Quick Install (macOS)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Niteeshkanungo/dotfiles/master/install.sh)
```

### Manual Install

```bash
git clone git@github.com:Niteeshkanungo/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

Existing files are backed up to `~/.dotfiles-backup-<timestamp>/` before symlinking.

## What's Included

- **`.zshrc`** - Interactive shell setup (completion, history, prompt, plugins)
- **`.zprofile`** - Login-shell environment (Homebrew, `LANG`, `EDITOR`, `PATH`)
- **`.aliases`** - Aliases (loaded for every interactive shell)
- **`.functions`** - Shell functions (loaded for every interactive shell)
- **`.zprompt`** / **`.shared_prompt`** - Minimal monochrome prompt with git status
- **`.zsh_learning.zsh`** - Optional adaptive command tracking (local only)
- **`.private.example`** - Template for local-only secrets (`~/.private`, never committed)

## Key Functions

Type `fsel` in your terminal to see an interactive dropdown of all available functions:

```bash
fsel
```

**How it works:**
- 🔍 **Search** - Start typing to filter functions (fuzzy search)
- ⬆️⬇️ **Navigate** - Use arrow keys to move up/down
- ✅ **Select** - Press Enter to select a function
- ❌ **Cancel** - Press Esc or Ctrl+C to exit

When you select a function, it will be placed in your command line ready for you to add arguments and run.

### Available Functions

- `randpassw` - Generate random passwords
- `extract` - Archive extractor (zip, tar, gz, bz2, xz, rar, 7z, pkg)
- `weather` - Get weather for any location
- `mcd` - Make directory and cd into it
- `ii` - System information overview
- `mans` - Search man pages
- `cdf` / `finderpath` - Finder integration
- `httpHeaders` / `httpDebug` - Web debugging
- `trash` - Move files to Trash
- `ql` - Quick Look preview
- `zipf` - Create ZIP archive
- And many more...

## Requirements

- macOS with zsh (default shell)
- Xcode Command Line Tools (`xcode-select --install`)
- Homebrew (https://brew.sh)

The installer adds the packages `.zshrc` depends on:

- `zsh-completions`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`

## Secrets

Never commit tokens or keys. Copy the template and keep it local-only:

```bash
cp .private.example ~/.private && chmod 600 ~/.private
```

`~/.zshrc` sources `~/.private` automatically when present.

## Layout Standard

- Environment (`export`, `PATH`) → `.zprofile`
- Interactive behavior, history, completion, prompt wiring → `.zshrc`
- Aliases (no arguments) → `.aliases`
- Everything taking arguments → `.functions`
