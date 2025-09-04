local M = {}

local config = require("vscode-neovim-fix-word-wrap.config")
local utils = require("vscode-neovim-fix-word-wrap.utils")

function M.setup(user_config)
    config.configure(user_config)
    local conf = config.config
    local km_spec = config.build_runtime_keymaps()

    local is_vscode = not not vim.g.vscode
    local ok_vscode, vscode_mod = false, nil
    if is_vscode then
        ok_vscode, vscode_mod = pcall(require, "vscode")
    end
    local vscode = ok_vscode and vscode_mod or nil
    local notify = (vscode and vscode.notify) or vim.notify

    local togglewrap = require("vscode-neovim-fix-word-wrap.togglewrap")

    if conf.togglewrap_keymap and conf.togglewrap_keymap ~= "" then
        vim.keymap.set("n", conf.togglewrap_keymap, function()
            if utils.is_macro_recording() or utils.is_macro_executing() then
                notify("ToggleWrap disabled during macro execution", vim.log.levels.WARN)
                return
            end

            if is_vscode then
                local new_wrap = not utils.get_vscode_wrap().enabled
                togglewrap.toggle_wrap(new_wrap)
                return
            end

            togglewrap.toggle_wrap()
        end, { desc = "[u]i toggle line [w]rap and movement" })
    end

    vim.api.nvim_create_user_command("ToggleWrap", function(ctx)
        local arg = ctx.args
        if arg == nil or arg == "" then
            togglewrap.toggle_wrap(nil, ctx.smods.silent)
            return
        end

        local s = arg:lower()
        local bool
        if s == "true" or s == "on" or s == "1" then
            bool = true
        elseif s == "false" or s == "off" or s == "0" then
            bool = false
        else
            if not ctx.smods.silent then
                notify("ToggleWrap: invalid argument. Use 'on'/'off' or no arg to toggle.", vim.log.levels.WARN)
            end
            return
        end

        togglewrap.toggle_wrap(bool, ctx.smods.silent)
    end, {
        complete = function()
            return { "on", "off" }
        end,
        nargs = "?",
        desc = "Toggle or set wrap (use 'on'/'off' or no arg to toggle)",
    })

    local my_group = vim.api.nvim_create_augroup("ToggleWrap", { clear = true })

    if conf.enable_recording_enter_autocmd then
        vim.api.nvim_create_autocmd({ "RecordingEnter" }, {
            group = my_group,
            callback = function()
                local ok, err = pcall(function()
                    togglewrap.toggle_wrap(false)
                end)
                if not ok then
                    notify("Error disabling wrap: " .. err, vim.log.levels.ERROR)
                    return
                end
                notify("Macro detected, wordWrap & keymaps disabled...", vim.log.levels.INFO)
            end,
        })
    end

    if conf.enable_vscode_sync_autocmd and is_vscode then
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            group = my_group,
            callback = function()
                local enabled = utils.get_vscode_wrap().enabled
                local cmd = enabled and "ToggleWrap on" or "ToggleWrap off"
                -- use a delay to avoid startup errors
                vim.defer_fn(function()
                    pcall(vim.cmd, "silent " .. cmd)
                end, 300)
            end,
        })
    end

    local function init_on_startup()
        -- use defer to prevent errors on vscode-neovim load
        vim.defer_fn(function()
            local enabled
            if is_vscode then
                enabled = utils.get_vscode_wrap().enabled
            else
                enabled = vim.wo.wrap
            end
            local cmd = enabled and "ToggleWrap on" or "ToggleWrap off"
            pcall(vim.cmd, "silent " .. cmd)
        end, 300)
    end

    init_on_startup()
end

return M

