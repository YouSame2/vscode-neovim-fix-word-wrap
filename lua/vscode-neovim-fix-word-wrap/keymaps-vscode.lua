local utils = require("vscode-neovim-fix-word-wrap.utils")
local vscode = require("vscode")

return {
    n_gj = {
        "n",
        "gj",
        function()
            if utils.is_macro_executing() then
                return "j"
            end
            vscode.call("cursorMove", {
                args = { to = "down", by = "wrappedLine", value = vim.v.count },
            })
            return ""
        end,
        { expr = true, silent = true, desc = "cursor N lines downward (include 'wrap')" },
    },
    v_gj = {
        "v",
        "gj",
        function()
            if utils.is_macro_executing() or vim.fn.mode() ~= "v" then
                return "j"
            end
            vscode.call("cursorMove", {
                args = { to = "down", by = "wrappedLine", select = true, value = vim.v.count },
            })
            return ""
        end,
        { expr = true, silent = true, desc = "cursor N lines downward (include 'wrap')" },
    },
    n_gk = {
        "n",
        "gk",
        function()
            if utils.is_macro_executing() then
                return "k"
            end
            vscode.call("cursorMove", {
                args = { to = "up", by = "wrappedLine", value = vim.v.count },
            })
            return ""
        end,
        { expr = true, silent = true, desc = "cursor N lines up (include 'wrap')" },
    },
    v_gk = {
        "v",
        "gk",
        function()
            if utils.is_macro_executing() or vim.fn.mode() ~= "v" then
                return "k"
            end
            vscode.call("cursorMove", {
                args = { to = "up", by = "wrappedLine", select = true, value = vim.v.count },
            })
            return ""
        end,
        { expr = true, silent = true, desc = "cursor N lines up (include 'wrap')" },
    },
    n_g0 = {
        "n",
        "g0",
        function()
            if utils.is_macro_executing() then
                return "0"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineStart" },
            })
            return ""
        end,
        { expr = true, silent = true, desc = "first char of wrapped line (wrap-aware)" },
    },
    v_g0 = {
        "v",
        "g0",
        function()
            if utils.is_macro_executing() or vim.fn.mode() ~= "v" then
                return "0"
            end
            vscode.call("cursorRight") -- vscode doesnt include char under cursor in visual selection, neovim does. Move right to compensate. neither includes char under crsor in operator pending mode, so undo in "o" mapping below
            vscode.call("cursorMove", { args = { to = "wrappedLineStart", select = true } })
            vscode.call("cursorRight", { args = { select = true } }) -- HACK: ya idk without this operator pending doesnt work. spent days figuring this out. fml.
            return ""
        end,
        { expr = true, silent = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    o_g0 = {
        "o",
        "g0",
        function()
            if utils.is_macro_executing() then
                return "0"
            end
            vscode.call("cursorLeft") -- undoing the conpensating right from visual mode
            return ":<C-U>normal hvg0<CR>"
        end,
        { expr = true, silent = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    n_g_caret = {
        "n",
        "g^",
        function()
            if utils.is_macro_executing() then
                return "^"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineFirstNonWhitespaceCharacter" },
            })
            return ""
        end,
        { expr = true, silent = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    v_g_caret = {
        "v",
        "g^",
        function()
            if utils.is_macro_executing() or vim.fn.mode() ~= "v" then
                return "^"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineFirstNonWhitespaceCharacter", select = true },
            })
            -- VSCode selections don’t include char under cursor, Neovim does
            vscode.call("cursorRight", { args = { select = true } })
            return ""
        end,
        { expr = true, silent = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    o_g_caret = {
        "o",
        "g^",
        function()
            if utils.is_macro_executing() then
                return "^"
            end
            return ":<C-U>normal vg^<CR>"
        end,
        { expr = true, silent = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    n_g_dollar = {
        "n",
        "g$",
        function()
            if utils.is_macro_executing() then
                return "$"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineLastNonWhitespaceCharacter" },
            })
            if not (vim.o.virtualedit:find("all") or vim.o.virtualedit:find("onemore")) then
                vscode.call("cursorLeft")
            end
            return vim.api.nvim_replace_termcodes("<Ignore>", true, true, true) -- without this cursor is desynced after motion,
        end,
        { expr = true, silent = true, desc = "end of the line (include 'wrap')" },
    },
    v_g_dollar = {
        "v",
        "g$",
        function()
            if utils.is_macro_executing() or vim.fn.mode() ~= "v" then
                return "$"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineEnd", select = true },
            })
            vscode.call("cursorLeft") -- adjust like Neovim’s visual mode
            return ""
        end,
        { expr = true, silent = true, desc = "end of the line (include 'wrap')" },
    },
    o_g_dollar = {
        "o",
        "g$",
        function()
            if utils.is_macro_executing() then
                return "$"
            end
            return ":<C-U>normal vg$<CR>"
        end,
        { expr = true, silent = true, desc = "end of the line (include 'wrap')" },
    },
    n_I = {
        "n",
        "I",
        function()
            if utils.is_macro_executing() then
                return "I"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineFirstNonWhitespaceCharacter" },
            })
            return "i"
        end,
        { expr = true, silent = true, desc = "I (include 'wrap')" },
    },
    n_A = {
        "n",
        "A",
        function()
            if utils.is_macro_executing() then
                return "A"
            end
            vscode.call("cursorMove", {
                args = { to = "wrappedLineLastNonWhitespaceCharacter" },
            })
            return "i" -- 'i' because cursor is already past the end (virtualedit)
        end,
        { expr = true, silent = true, desc = "A (include 'wrap')" },
    },
    n_D = {
        "n",
        "D",
        function()
            if utils.is_macro_executing() then
                return "D"
            else
                return "dg$"
            end
        end,
        { expr = true, remap = true, desc = "[D]elete to end of line (include 'wrap')" },
    },
    n_C = {
        "n",
        "C",
        function()
            if utils.is_macro_executing() then
                return "C"
            else
                return "cg$"
            end
        end,
        { expr = true, remap = true, desc = "[C]hange to end of line (include 'wrap')" },
    },
    n_Y = {
        "n",
        "Y",
        function()
            if utils.is_macro_executing() then
                return "Y"
            else
                return "yg$"
            end
        end,
        { expr = true, remap = true, desc = "[Y]ank to end of line (include 'wrap')" },
    },
    n_j = {
        "n",
        "j",
        "v:count == 0 ? 'gj' : 'j'",
        { expr = true, remap = true, desc = "cursor N lines downward (include 'wrap')" },
    },
    v_j = {
        "v",
        "j",
        "v:count == 0 ? 'gj' : 'j'",
        { expr = true, remap = true, desc = "cursor N lines downward (include 'wrap')" },
    },
    n_k = {
        "n",
        "k",
        "v:count == 0 ? 'gk' : 'k'",
        { expr = true, remap = true, desc = "cursor N lines up (include 'wrap')" },
    },
    v_k = {
        "v",
        "k",
        "v:count == 0 ? 'gk' : 'k'",
        { expr = true, remap = true, desc = "cursor N lines up (include 'wrap')" },
    },
    n_0 = {
        "n",
        "0",
        "g0",
        { remap = true, desc = "first char of the line (include 'wrap')" },
    },
    v_0 = {
        "v",
        "0",
        "g0",
        { remap = true, desc = "first char of the line (include 'wrap')" },
    },
    o_0 = {
        "o",
        "0",
        "g0",
        { remap = true, desc = "first char of the line (include 'wrap')" },
    },
    n_caret = {
        "n",
        "^",
        "g^",
        { remap = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    v_caret = {
        "v",
        "^",
        "g^",
        { remap = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    o_caret = {
        "o",
        "^",
        "g^",
        { remap = true, desc = "first non-blank character of the line (include 'wrap')" },
    },
    n_dollar = {
        "n",
        "$",
        "g$",
        { remap = true, desc = "end of the line (include 'wrap')" },
    },
    v_dollar = {
        "v",
        "$",
        "g$",
        { remap = true, desc = "end of the line (include 'wrap')" },
    },
    o_dollar = {
        "o",
        "$",
        "g$",
        { remap = true, desc = "end of the line (include 'wrap')" },
    },
}
