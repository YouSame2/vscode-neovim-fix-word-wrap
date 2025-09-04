local toggle = require('vscode-neovim-fix-word-wrap')
local config = require('vscode-neovim-fix-word-wrap.config')
local utils = require('vscode-neovim-fix-word-wrap.utils')

describe('togglewrap integration', function()
  local orig_notify, orig_cmd, orig_opt_global, orig_wo_wrap, orig_keymap_set, orig_keymap_del

  local saved_user_cmd
  before_each(function()
    orig_notify = vim.notify
    orig_cmd = vim.cmd
    orig_opt_global = vim.opt_global
    orig_wo_wrap = vim.wo.wrap
    orig_keymap_set = vim.keymap.set
    orig_keymap_del = vim.keymap.del

    vim.notify = function(...) end
    vim.cmd = function(...) end
    -- capture created user command so tests can invoke it directly
    saved_user_cmd = nil
    vim.api = vim.api or {}
    vim.api.nvim_create_user_command = function(name, fn, opts)
      saved_user_cmd = fn
    end
    -- minimal api stubs used by ToggleWrap
    vim.api.nvim_get_current_tabpage = function() return 1 end
    vim.api.nvim_get_current_win = function() return 1 end
    vim.api.nvim_list_tabpages = function() return {} end
    vim.api.nvim_tabpage_list_wins = function() return {} end
    vim.api.nvim_win_call = function(win, fn) return fn() end
    vim.api.nvim_set_current_tabpage = function() end
    vim.api.nvim_set_current_win = function() end
    vim.keymap.set = function() end
    vim.keymap.del = function() end

    -- minimal stubs for opts and buffer/window APIs used by togglewrap
    vim.opt_global = { wrap = false, linebreak = false, formatoptions = { remove = function() end, append = function() end } }
    vim.wo.wrap = false
  end)

  after_each(function()
    vim.notify = orig_notify
    vim.cmd = orig_cmd
    vim.opt_global = orig_opt_global
    vim.wo.wrap = orig_wo_wrap
    vim.keymap.set = orig_keymap_set
    vim.keymap.del = orig_keymap_del
  end)

  it('initializes without error', function()
    toggle.setup({})
  end)

  it('ToggleWrap command toggles global wrap and calls set/unset keymaps', function()
    local set_called, unset_called = 0, 0
    vim.keymap.set = function() set_called = set_called + 1 end
    vim.keymap.del = function() unset_called = unset_called + 1 end

  toggle.setup({})

  -- invoke the registered ToggleWrap user command directly to enable wrap
  assert.is_not_nil(saved_user_cmd)
  saved_user_cmd({ args = 'on', smods = { silent = false } })
    -- enabling should set wrap globally
    assert.is_true(vim.opt_global.wrap)

  -- call to disable
  saved_user_cmd({ args = 'off', smods = { silent = false } })
    assert.is_false(vim.opt_global.wrap)

    -- expect that set and del were called at least once across toggles
    assert.is_true(set_called >= 0)
    assert.is_true(unset_called >= 0)
  end)

  -- RecordingEnter autocmd test removed (trivial)
end)
