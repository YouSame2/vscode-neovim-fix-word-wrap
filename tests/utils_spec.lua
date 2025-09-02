local utils = require("vscode-neovim-fix-word-wrap.utils")

describe("utils", function()
  it("is_macro_executing should return boolean", function()
    assert(type(utils.is_macro_executing()) == "boolean")
  end)

  it("is_macro_recording should return boolean", function()
    assert(type(utils.is_macro_recording()) == "boolean")
  end)
end)
