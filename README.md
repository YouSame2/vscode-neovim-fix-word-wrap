# vscode-neovim-fix-word-wrap

Basically title...

A Neovim plugin to fix word wrap issues in BOTH the VSCode-neovim extension and Neovim. By default, keymaps to move and operate over **_visual_** lines (e.g. `g$`, `vg$`, `yg$`) in VSCode are either broken or incomplete in the VSCode Neovim extension. This plugin aims to replicate Neovim word wrap keymap behavior as closely as possible, including macro support and fixes.

Put simply: word wrap keymaps should work the same in VSCode Neovim as they do in Neovim. Default Neovim keys should work out of the box for everyone, but as seen in [this PR](https://github.com/vscode-neovim/vscode-neovim/pull/2539), that's not the case—so I made this plugin.

## Works in Neovim Too

This plugin also improves the word wrap experience in regular Neovim. Motions like `gj`, `gk`, and `g0` always work as expected with wrap, and macros won't break due to wrap keymaps. If you use word wrap in Neovim or edit a LOT of markdown file, try it out.

## What it Does
https://github.com/user-attachments/assets/d91fac08-dd6c-4460-b75d-92c2493130c2

https://github.com/user-attachments/assets/03fded94-a4fe-4889-a9e2-c5bf755f8eca

https://github.com/user-attachments/assets/f7604671-3f62-4f69-b1ca-e10f653a5184

https://github.com/user-attachments/assets/48a45b81-5991-4749-82f4-b1e293652da6

https://github.com/user-attachments/assets/94d93dc9-9788-4501-a268-6d77258a5fdf

## Installation

Install the plugin with your favorite plugin manager.

```lua
{
  "YouSame2/vscode-neovim-fix-word-wrap",
  event = "VeryLazy",
  opts = {},
}
```

<details>
<summary>Default config</summary>

```lua
{
  togglewrap_keymap = "<leader>uw",
  -- autocmd toggles
  enable_recording_enter_autocmd = true,
  enable_vscode_sync_autocmd = true,
  keymaps = {
    n = {
      gj = { enabled_vscode = true, keymap = keymaps.n_gj },
      gk = { enabled_vscode = true, keymap = keymaps.n_gk },
      g0 = { enabled_vscode = true, keymap = keymaps.n_g0 },
      ["g^"] = { enabled_vscode = true, keymap = keymaps.n_g_caret },
      ["g$"] = { enabled_vscode = true, keymap = keymaps.n_g_dollar },
      I = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_I },
      A = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_A },
      D = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_D },
      C = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_C },
      Y = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_Y },
      j = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_j },
      k = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_k },
      ["0"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_0 },
      ["^"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_caret },
      ["$"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.n_dollar },
    },
    v = {
      gj = { enabled_vscode = true, keymap = keymaps.v_gj },
      gk = { enabled_vscode = true, keymap = keymaps.v_gk },
      g0 = { enabled_vscode = true, keymap = keymaps.v_g0 },
      ["g^"] = { enabled_vscode = true, keymap = keymaps.v_g_caret },
      ["g$"] = { enabled_vscode = true, keymap = keymaps.v_g_dollar },
      j = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.v_j },
      k = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.v_k },
      ["0"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.v_0 },
      ["^"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.v_caret },
      ["$"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.v_dollar },
    },
    o = {
      g0 = { enabled_vscode = true, keymap = keymaps.o_g0 },
      ["g^"] = { enabled_vscode = true, keymap = keymaps.o_g_caret },
      ["g$"] = { enabled_vscode = true, keymap = keymaps.o_g_dollar },
      ["0"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.o_0 },
      ["^"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.o_caret },
      ["$"] = { enabled_vscode = true, enabled_neovim = true, keymap = keymaps.o_dollar },
    },
  },
}
```

</details>

## Options

- `togglewrap_keymap`: Keymap to toggle word wrap (default: `<leader>uw`). Set to `""` to disable.
- `enable_recording_enter_autocmd`: If `true`, disables wrap and keymaps before entering a macro recording to avoid breaking macro behavior. This is a fix and is recommended to keep enabled.
- `enable_vscode_sync_autocmd`: If `true`, keeps Neovim and VSCode word wrap state in sync automatically. It uses `CursorHold` autocmd to check and set wrap settings & keymaps. Unless you constantly change word wrap in vscode i'd recommend disabling this to min/max your performance. Just remember to use the keymap instead.
- `keymaps`: Table of keymaps for normal/visual/operator modes. Format matches the default config. Some keymaps are only available in Neovim or VSCode—refer to the default config for details. You can disable a specific key in a specific mode, or provide your own keymap table for the plugin to use.

## Usage

Use `:ToggleWrap` to toggle word wrap in both Neovim and VSCode. You can also use the configured keymap (default: `<leader>uw`).

## Known Issues / Limitations

- VSCode word wrap keymaps don't function in the `:norm` command when used inside of it. No fix is known—if you find one, please open an issue or PR. As a workaround, use `:norm!` or disable wrap keymaps (`:ToggleWrap` off) before running `:norm`.
