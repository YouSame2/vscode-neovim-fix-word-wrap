# vscode-neovim-fix-word-wrap

Basically title... word wrap drove me mad in neovim & vscode-neovim, so I fixed it.

#### THE WHAT:

By default, keymaps to move and operate over **_visual_** lines (e.g. `g$`, `vg$`, `yg$`) in [ VSCode-neovim extension ](https://github.com/vscode-neovim/vscode-neovim) are either broken or incomplete. This plugin aims to replicate Neovim word wrap keymap behavior (i.e. vg$ should select to end of **_visual_** line) as closely as possible, including macro support and fixes.

Put simply, word wrap keymaps should work the same in VSCode Neovim as they do in Neovim. I believe default Neovim keys should work out of the box for everyone, but as seen in [this PR](https://github.com/vscode-neovim/vscode-neovim/pull/2539), that's not the case—so I made this plugin.

#### THE WHY:

Trust me — in the VSCode extension, it's not as simple as in Neovim to just set the `g0` or `g$` keymaps. There are a lot of "hacky" ways to replicate the proper behavior (for example, `y0` shouldn't include the character under the cursor, but `y$` should). Things break down very quickly if you change just **_ONE_** thing. See `keymaps-vscode.lua` for yourself.

## Works in Neovim Too

This plugin also improves the word wrap experience in regular Neovim. Motions like `gj`, `gk`, and `g0` always work as expected with wrap enabled, and macros won't break because of wrap keymaps. If you use word wrap in Neovim or edit many Markdown files, give it a try.

## What it Does

Here's a quick list of features — videos demonstrating them appear below:

- Create mappings that respect visual lines for: `gj`, `gk`, `g0`, `g$`, `g^`, `j`, `k`, `0`, `$`, `^`.
- `j`/`k` motions respect relative line numbers: `j` alone moves down one visual line, while `4j` moves down four relative lines.
- Mappings are provided for normal, visual, and operator-pending modes. That means `vg0`/`v0` or `yg$`/`y$` apply their respective operations to the visual line.
- Additional useful mappings: `I`, `A`, `Y`, `C`, `D` — each applies its operation to the visual line.
- One-to-one implementation of text operations: backward operations (e.g., `yg0`/`y0`) do not include the character under the cursor, while forward operations do.
- `g$` and `$` respect the user's `virtualedit` setting.
- The plugin automatically falls back to non-wrap keymaps in visual-block mode, while recording macros, and during macro execution (even with wrap enabled!). This prevents unintended behavior when recording or replaying macros.
- Provides the `:ToggleWrap` user command and a keymap to quickly toggle global word wrap for all open buffers/windows/tabs (yes even in Neovim :D).

#### Demo: Improve Macros

https://github.com/user-attachments/assets/f7604671-3f62-4f69-b1ca-e10f653a5184

#### Demo: Respecting Relative Line Numbers

https://github.com/user-attachments/assets/d91fac08-dd6c-4460-b75d-92c2493130c2

#### Demo: Selecting to End of Visual Line

https://github.com/user-attachments/assets/03fded94-a4fe-4889-a9e2-c5bf755f8eca

#### Demo: Deleting to Beginning of Visual Line

https://github.com/user-attachments/assets/48a45b81-5991-4749-82f4-b1e293652da6

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
