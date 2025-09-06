local M = {}

local keymaps
if vim.g.vscode then
    keymaps = require("vscode-neovim-fix-word-wrap.keymaps-vscode")
else
    keymaps = require("vscode-neovim-fix-word-wrap.keymaps-neovim")
end

M.config = {
    togglewrap_keymap = "<leader>uw",
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

function M.configure(user_config)
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

--- Compute the runtime keymap spec filtered by environment and enable flags.
-- Returns a table compatible with utils.set_wrap_keymaps / unset_wrap_keymaps.
-- Shape: { mappings = { n = { { enabled=true, map={...} }, ... }, v = {...}, o = {...} }, remappings = {} }
function M.build_runtime_keymaps()
    local is_vscode = not not vim.g.vscode
    local runtime = { mappings = { n = {}, v = {}, o = {} }, remappings = {} }

    local function is_enabled(entry)
        if is_vscode then
            return entry.enabled_vscode == true
        else
            return entry.enabled_neovim == true
        end
    end

    for mode, entries in pairs(M.config.keymaps or {}) do
        for _, entry in pairs(entries) do
            if entry and entry.keymap and is_enabled(entry) then
                table.insert(runtime.mappings[mode], { enabled = true, map = entry.keymap })
            end
        end
    end

    return runtime
end

return M
