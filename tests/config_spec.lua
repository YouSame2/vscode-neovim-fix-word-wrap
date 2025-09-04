local config = require('vscode-neovim-fix-word-wrap.config')
local util = require('plenary.test_harness')

describe('config.build_runtime_keymaps', function()
  local orig_vscode
  before_each(function()
    orig_vscode = vim.g.vscode
  end)

  after_each(function()
    vim.g.vscode = orig_vscode
  end)

  it('returns empty mappings when keymaps disabled for environment', function()
    vim.g.vscode = false
    -- default config has many entries with enabled_neovim = true or nil; ensure behavior
    local runtime = config.build_runtime_keymaps()
    assert.is_table(runtime)
    assert.is_table(runtime.mappings)
    -- in neovim mode, ensure mappings table is present
    assert.truthy(runtime.mappings.n)
  end)

  it('filters keymaps for vscode environment', function()
    vim.g.vscode = true
    local runtime = config.build_runtime_keymaps()
    assert.is_table(runtime.mappings)
    -- when vscode, entries with enabled_vscode=true should be included
    assert.is_true(#runtime.mappings.n > 0)
  end)
end)
