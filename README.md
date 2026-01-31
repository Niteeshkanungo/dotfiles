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

Run `fsel` to see an interactive dropdown of all available functions:

- `randpassw` - Generate random passwords
- `extract` - Universal archive extractor
- `weather` - Get weather for any location
- `mcd` - Make directory and cd into it
- `ii` - System information overview
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