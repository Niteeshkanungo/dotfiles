# Dotfiles

Cross-platform shell configuration for macOS and Linux.

## Features

- 🎨 Clean, monochrome zsh prompt
- 🔍 Function dropdown with `fzf` (`fsel` command)
- 🚀 Custom aliases and functions
- 🌐 Works on both macOS and Linux
- 📦 One-line installation

## Quick Install

### One-Liner (Mac & Linux)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Niteeshkanungo/dotfiles/main/install.sh)
```

### Manual Install

```bash
git clone https://github.com/Niteeshkanungo/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What's Included

- **`.zshrc`** - Main zsh configuration
- **`.zprofile`** - Environment variables and PATH
- **`.functions`** - Custom shell functions
- **`.aliases`** - Useful aliases
- **`.zprompt`** - Minimal prompt configuration
- **`.shared_prompt`** - Shared prompt settings

## Key Functions

### Using the Function Dropdown

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
- `extract` - Universal archive extractor
- `weather` - Get weather for any location
- `mcd` - Make directory and cd into it
- `ii` - System information overview
- `mans` - Search man pages
- `cdf` - Change to Finder directory (Mac only)
- `httpHeaders` - View HTTP headers
- `trash` - Move files to trash
- `ql` - Quick Look preview (Mac only)
- `zipf` - Create ZIP archive
- And many more...

## Requirements

- zsh (auto-installed by script)
- fzf (auto-installed by script)
- git

## Platform Support

- ✅ macOS (Intel & Apple Silicon)
- ✅ Ubuntu/Debian Linux
- ✅ RHEL/CentOS/Fedora Linux

Mac-specific features (like Finder integration) are automatically disabled on Linux.