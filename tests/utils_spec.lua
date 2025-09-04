local utils = require("vscode-neovim-fix-word-wrap.utils")

describe("utils.set_wrap_keymaps and unset_wrap_keymaps", function()
    local orig_keymap_set, orig_keymap_del

    before_each(function()
        orig_keymap_set = vim.keymap.set
        orig_keymap_del = vim.keymap.del
    end)

    after_each(function()
        vim.keymap.set = orig_keymap_set
        vim.keymap.del = orig_keymap_del
    end)

    it("calls vim.keymap.set for mappings and remappings", function()
        local called = {}
        vim.keymap.set = function(mode, lhs, rhs, opts)
            table.insert(called, { mode = mode, lhs = lhs, rhs = rhs, opts = opts })
        end

        local cfg = {
            mappings = { n = { { enabled = true, map = { "n", "gj", "<cmd>echo gj<cr>", { silent = true } } } } },
            remappings = {},
        }
        utils.set_wrap_keymaps(cfg)
        assert.are.equal(1, #called)
        assert.are.same("gj", called[1].lhs)
    end)

    it("calls vim.keymap.del for mappings with table modes", function()
        local dels = {}
        vim.keymap.del = function(mode, lhs)
            table.insert(dels, { mode = mode, lhs = lhs })
        end

        local cfg = {
            mappings = { n = { { enabled = true, map = { { "n", "v" }, "gj", "<cmd>echo gj<cr>", { silent = true } } } } },
            remappings = {},
        }
        utils.unset_wrap_keymaps(cfg)
        -- expect two deletes for 'n' and 'v'
        assert.are.equal(2, #dels)
    end)

    it("get_vscode_wrap returns disabled when not in vscode", function()
        local orig = vim.g.vscode
        vim.g.vscode = nil
        local res = utils.get_vscode_wrap()
        assert.is_false(res.enabled)
        vim.g.vscode = orig
    end)

    it("macro helpers reflect vim.fn", function()
        local orig_reg_executing = vim.fn.reg_executing
        local orig_reg_recording = vim.fn.reg_recording
        vim.fn.reg_executing = function()
            return "a"
        end
        vim.fn.reg_recording = function()
            return ""
        end
        assert.is_true(utils.is_macro_executing())
        assert.is_false(utils.is_macro_recording())
        vim.fn.reg_executing = orig_reg_executing
        vim.fn.reg_recording = orig_reg_recording
    end)
end)
