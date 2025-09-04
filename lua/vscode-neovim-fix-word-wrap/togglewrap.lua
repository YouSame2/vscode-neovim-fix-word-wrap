local M = {}

local config = require("vscode-neovim-fix-word-wrap.config")
local utils = require("vscode-neovim-fix-word-wrap.utils")

function M.setup(user_config)
  config.setup(user_config)
  local conf = config.config
  local km_spec = config.build_runtime_keymaps()

  local vscode = vim.g.vscode and require("vscode") or nil
  local notify = (vscode and vscode.notify) or vim.notify

  if conf.togglewrap_keymap and conf.togglewrap_keymap ~= "" then
    vim.keymap.set("n", conf.togglewrap_keymap, function()
      if utils.is_macro_recording() or utils.is_macro_executing() then
        notify("ToggleWrap disabled during macro execution", vim.log.levels.WARN)
        return
      end

      if vim.g.vscode then
        local new_wrap = not utils.get_vscode_wrap().enabled
        vim.cmd("ToggleWrap " .. tostring(new_wrap))
        return
      end

      vim.cmd("ToggleWrap")
    end, { desc = "[u]i toggle line [w]rap and movement" })
  end

  ---Toggle or explicitly set word wrap and related editor options.
  ---@param enabled boolean? If true, enable wrap; if false, disable wrap; if nil, toggle current state.
  ---@param silent boolean? If true, suppress notifications.
  ---@return boolean The resulting state of wrap (true = enabled, false = disabled)
  local function ToggleWrap(enabled, silent)
    ---@type boolean
    if enabled == nil then
      local current = vim.g.vscode and utils.get_vscode_wrap().enabled or vim.wo.wrap
      enabled = not current
    end

    if vim.g.vscode then
      local new_wrap_mode = enabled and "bounded" or "off"
      vscode.update_config("editor.wordWrap", new_wrap_mode, "global")
      if not enabled then
        utils.unset_wrap_keymaps(km_spec)
        return enabled
      end
      utils.set_wrap_keymaps(km_spec)
      return enabled
    end

    -- capture exact current location
    local cur_tab = vim.api.nvim_get_current_tabpage()
    local cur_win = vim.api.nvim_get_current_win()

    -- set global defaults so future windows/buffers inherit
    vim.opt_global.wrap = enabled
    vim.opt_global.linebreak = enabled
    if enabled then
      vim.opt_global.formatoptions:remove("l")
      utils.set_wrap_keymaps(km_spec)
    else
      vim.opt_global.formatoptions:append("l")
      utils.unset_wrap_keymaps(km_spec)
    end

    -- apply to all existing windows in all tabs without stealing focus
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        pcall(vim.api.nvim_win_call, win, function()
          vim.opt_local.wrap = enabled
          vim.opt_local.linebreak = enabled
          if enabled then
            vim.opt_local.formatoptions:remove("l")
          else
            vim.opt_local.formatoptions:append("l")
          end
        end)
      end
    end

    -- restore exact original tab and window
    pcall(vim.api.nvim_set_current_tabpage, cur_tab)
    pcall(vim.api.nvim_set_current_win, cur_win)

    if not silent then
      notify(enabled and "✅ Wrap enabled" or "❌ Wrap disabled")
    end

    return enabled
  end

  vim.api.nvim_create_user_command("ToggleWrap", function(ctx)
    local arg = ctx.args
    if arg == nil or arg == "" then
      ToggleWrap(nil, ctx.smods.silent)
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

    ToggleWrap(bool, ctx.smods.silent)
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
        local ok, err = pcall(vim.cmd, "ToggleWrap off")
        if not ok then
          notify("Error disabling wrap: " .. err, vim.log.levels.ERROR)
          return
        end
        notify("Macro detected, wordWrap & keymaps disabled...", vim.log.levels.INFO)
      end,
    })
  end

  if conf.enable_vscode_sync_autocmd and vim.g.vscode then
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
      if vim.g.vscode then
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
