local config = require('vscode-neovim-fix-word-wrap.config')

describe('config.build_runtime_keymaps env handling', function()
  local orig_vscode

  before_each(function()
    orig_vscode = vim.g.vscode
  end)

  after_each(function()
    vim.g.vscode = orig_vscode
  package.loaded['vscode-neovim-fix-word-wrap.config'] = nil
  package.loaded['vscode'] = nil
  end)

  it('returns vscode-filtered mappings when vim.g.vscode = true', function()
  vim.g.vscode = true
  -- provide a minimal vscode shim so keymaps-vscode can require it safely
  package.loaded['vscode'] = { call = function() end, get_config = function() return 'bounded' end }
  package.loaded['vscode-neovim-fix-word-wrap.config'] = nil
    local cfg = require('vscode-neovim-fix-word-wrap.config')
    local runtime = cfg.build_runtime_keymaps()
    assert.is_table(runtime)
    assert.is_table(runtime.mappings)
    -- expect at least one mapping in 'n' mode for the default keymaps
    assert.is_true(#runtime.mappings.n >= 1)
  end)

  it('returns neovim-filtered mappings when vim.g.vscode = false', function()
    vim.g.vscode = false
    package.loaded['vscode-neovim-fix-word-wrap.config'] = nil
    local cfg = require('vscode-neovim-fix-word-wrap.config')
    local runtime = cfg.build_runtime_keymaps()
    assert.is_table(runtime)
    assert.is_table(runtime.mappings)
    -- shape checks: mapping tables exist for n,v,o
    assert.is_table(runtime.mappings.n)
    assert.is_table(runtime.mappings.v)
    assert.is_table(runtime.mappings.o)
  end)
end)
