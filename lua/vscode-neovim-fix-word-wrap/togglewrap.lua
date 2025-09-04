local M = {}

local config = require("vscode-neovim-fix-word-wrap.config")
local utils = require("vscode-neovim-fix-word-wrap.utils")

--- Toggle or explicitly set word wrap and related editor options.
---@param enabled boolean? If true, enable wrap; if false, disable wrap; if nil, toggle current state.
---@param silent boolean? If true, suppress notifications.
---@return boolean The resulting state of wrap (true = enabled, false = disabled)
local function ToggleWrap(enabled, silent)
  local conf = config.config
  local km_spec = config.build_runtime_keymaps()

  local vscode = vim.g.vscode and require("vscode") or nil
  local notify = (vscode and vscode.notify) or vim.notify

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

-- expose the toggle function as the module's primary responsibility
M.toggle_wrap = ToggleWrap

return M
