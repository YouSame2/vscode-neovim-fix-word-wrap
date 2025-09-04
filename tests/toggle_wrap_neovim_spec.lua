local teardown = require('plenary.async').teardown

describe('togglewrap.toggle_wrap (neovim mode)', function()
  local orig_utils, orig_config

  before_each(function()
    -- stub utils
    orig_utils = package.loaded['vscode-neovim-fix-word-wrap.utils']
    package.loaded['vscode-neovim-fix-word-wrap.utils'] = {
      set_wrap_keymaps = function(_) called_set = true end,
      unset_wrap_keymaps = function(_) called_unset = true end,
      get_vscode_wrap = function() return { enabled = false } end,
      is_macro_executing = function() return false end,
      is_macro_recording = function() return false end,
    }

    -- stub config
    orig_config = package.loaded['vscode-neovim-fix-word-wrap.config']
    package.loaded['vscode-neovim-fix-word-wrap.config'] = {
      config = { togglewrap_keymap = '<leader>uw' },
      build_runtime_keymaps = function() return { mappings = { n = {}, v = {}, o = {} }, remappings = {} } end,
    }

    -- reset flags
    called_set = false
    called_unset = false

    -- minimal vim opt shim
    vim.opt_global = { wrap = false, linebreak = false, formatoptions = { remove = function() end, append = function() end } }

    -- minimal api stubs used by ToggleWrap
    vim.api = vim.api or {}
    vim.api.nvim_list_tabpages = function() return {} end
    vim.api.nvim_tabpage_list_wins = function() return {} end
    vim.api.nvim_win_call = function(_, fn) return fn() end
    vim.api.nvim_get_current_tabpage = function() return 1 end
    vim.api.nvim_get_current_win = function() return 1 end
    vim.api.nvim_set_current_tabpage = function() end
    vim.api.nvim_set_current_win = function() end
  end)

  after_each(function()
    package.loaded['vscode-neovim-fix-word-wrap.utils'] = orig_utils
    package.loaded['vscode-neovim-fix-word-wrap.config'] = orig_config
    vim.g.vscode = nil
  end)

  it('enables wrap and calls set_wrap_keymaps when enabling', function()
    vim.g.vscode = false
    package.loaded['vscode-neovim-fix-word-wrap.togglewrap'] = nil
    local toggle = require('vscode-neovim-fix-word-wrap.togglewrap')
    local res = toggle.toggle_wrap(true, true)
    assert.is_true(res)
    assert.is_true(vim.opt_global.wrap)
    assert.is_true(called_set)
  end)

  it('disables wrap and calls unset_wrap_keymaps when disabling', function()
    vim.g.vscode = false
    package.loaded['vscode-neovim-fix-word-wrap.togglewrap'] = nil
    local toggle = require('vscode-neovim-fix-word-wrap.togglewrap')
    local res = toggle.toggle_wrap(false, true)
    assert.is_false(res)
    assert.is_false(vim.opt_global.wrap)
    assert.is_true(called_unset)
  end)
end)
