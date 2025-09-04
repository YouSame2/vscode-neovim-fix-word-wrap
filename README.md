# vscode-neovim-fix-word-wrap

A Neovim plugin to fix word wrap issues when using VSCode Neovim extension.

## Installation

Install the plugin with your favorite plugin manager.

## Usage

Run the command `:ToggleWrap` to toggle word wrap.

## Configuration

You can configure the plugin by calling the `setup` function.

```lua
require('vscode-neovim-fix-word-wrap').setup({
  keymaps = true, -- or false
})
```

### Options

- `keymaps`: (default: `true`) - If set to `true`, the plugin will create keymaps for toggling word wrap.

### TODOS

- add silent toggle keymap option

