# Local Terminal

A local IDE-like terminal setup using **WezTerm** + **Neovim** + **lazy.nvim** on Windows.

## Prerequisites

- [Scoop](https://scoop.sh/) package manager

## Installation

### 1. Install WezTerm and Neovim

```powershell
scoop install wezterm
scoop install neovim
```

### 2. Install lazy.nvim (LazyVim starter)

Clone the LazyVim starter configuration:

```powershell
git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim
```

### 3. Copy Neovim configuration

Copy the Neovim config files from this repository into the Neovim configuration folder:

```powershell
Copy-Item -Path .\nvim\* -Destination $env:LOCALAPPDATA\nvim -Recurse -Force
```

### 4. Launch Neovim

Open WezTerm and run:

```
nvim
```

On first launch, lazy.nvim will automatically install all configured plugins.
