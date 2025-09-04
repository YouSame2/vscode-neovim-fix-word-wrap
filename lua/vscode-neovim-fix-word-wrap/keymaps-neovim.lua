local utils = require("vscode-neovim-fix-word-wrap.utils")

return {
  n_I = {
    "n",
    "I",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "I"
      else
        return "g^i"
      end
    end,
    { expr = true, desc = "I (include 'wrap')" },
  },
  n_A = {
    "n",
    "A",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "A"
      else
        return "g$a"
      end
    end,
    { expr = true, desc = "A (include 'wrap')" },
  },
  n_D = {
    "n",
    "D",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "d$"
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
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "c$"
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
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "y$"
      else
        return "yg$"
      end
    end,
    { expr = true, remap = true, desc = "[Y]ank to end of line (include 'wrap')" },
  },
  n_j = {
    "n",
    "j",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "j"
      end
      if vim.v.count == 0 then
        return "gj"
      else
        return "j"
      end
    end,
    { expr = true, desc = "cursor N lines downward (include 'wrap')" },
  },
  v_j = {
    "v",
    "j",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap or vim.fn.mode() ~= "v" then -- mode check to avoid issues with visual block mode
        return "j"
      end
      if vim.v.count == 0 then
        return "gj"
      else
        return "j"
      end
    end,
    { expr = true, desc = "cursor N lines downward (include 'wrap')" },
  },
  n_k = {
    "n",
    "k",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "k"
      end
      if vim.v.count == 0 then
        return "gk"
      else
        return "k"
      end
    end,
    { expr = true, desc = "cursor N lines up (include 'wrap')" },
  },
  v_k = {
    "v",
    "k",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap or vim.fn.mode() ~= "v" then -- mode check to avoid issues with visual block mode
        return "k"
      end
      if vim.v.count == 0 then
        return "gk"
      else
        return "k"
      end
    end,
    { expr = true, desc = "cursor N lines up (include 'wrap')" },
  },
  n_0 = {
    "n",
    "0",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "0"
      end
      if vim.v.count == 0 then
        return "g0"
      else
        return "0"
      end
    end,
    { expr = true, desc = "first char of the line (include 'wrap')" },
  },
  v_0 = {
    "v",
    "0",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap or vim.fn.mode() ~= "v" then
        return "0"
      end
      if vim.v.count == 0 then
        return "g0"
      else
        return "0"
      end
    end,
    { expr = true, desc = "first char of the line (include 'wrap')" },
  },
  o_0 = {
    "o",
    "0",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "0"
      end
      if vim.v.count == 0 then
        return "g0"
      else
        return "0"
      end
    end,
    { expr = true, desc = "first char of the line (include 'wrap')" },
  },

  n_caret = {
    "n",
    "^",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "^"
      end
      return "g^"
    end,
    { expr = true, desc = "first non-blank character of the line (include 'wrap')" },
  },
  v_caret = {
    "v",
    "^",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap or vim.fn.mode() ~= "v" then
        return "^"
      end
      return "g^"
    end,
    { expr = true, desc = "first non-blank character of the line (include 'wrap')" },
  },
  o_caret = {
    "o",
    "^",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "^"
      end
      return "g^"
    end,
    { expr = true, desc = "first non-blank character of the line (include 'wrap')" },
  },

  n_dollar = {
    "n",
    "$",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "$"
      else
        return "g$"
      end
    end,
    { expr = true, desc = "end of the line (include 'wrap')" },
  },
  v_dollar = {
    "v",
    "$",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap or vim.fn.mode() ~= "v" then
        return "$"
      end
      return "g$"
    end,
    { expr = true, desc = "end of the line (include 'wrap')" },
  },
  o_dollar = {
    "o",
    "$",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "$"
      end
      return "g$"
    end,
    { expr = true, desc = "end of the line (include 'wrap')" },
  },
}
