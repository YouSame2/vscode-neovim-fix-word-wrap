local utils = require("vscode.word_wrap.utils")

M = {
  {
    -- ignore "o" that gets complex usally u want to 3yj acordding to relative lines not screen lines
    { "n" },
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
  {
    { "v" },
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
    { expr = true, remap = true, desc = "cursor N lines downward (include 'wrap')" },
  },
  {
    { "n" },
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
  {
    { "v" },
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
  {
    { "n", "v", "o" },
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
  {
    { "n", "v", "o" },
    "^",
    function()
      if utils.is_macro_executing() or not vim.wo.wrap then
        return "^"
      end
      return "g^"
    end,
    { expr = true, desc = "first non-blank character of the line (include 'wrap')" },
  },
  {
    { "n", "v", "o" },
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
  {
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
  {
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
  ---------------
  -- NOTE: below changes behavior of Y,D,C to respect line wrap. comment out to have normal behavior. keep in mind you can still achive the same normal behavior just by double tapping. i.e. 'yy' or 'dd'
  {
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
  {
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
  {
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
  -- all keymaps needed to for proper word wrap behavior
  {
    { "n", "v" },
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, remap = true, desc = "cursor N lines downward (include 'wrap')" },
  },
  {
    { "n", "v" },
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, remap = true, desc = "cursor N lines up (include 'wrap')" },
  },
  {
    { "n", "v", "o" },
    "0",
    "g0",
    { remap = true, desc = "first char of the line (include 'wrap')" },
  },
  {
    { "n", "v", "o" },
    "^",
    "g^",
    { remap = true, desc = "first non-blank character of the line (include 'wrap')" },
  },
  {
    { "n", "v", "o" },
    "$",
    "g$",
    { remap = true, desc = "end of the line (include 'wrap')" },
  },
}

return M
