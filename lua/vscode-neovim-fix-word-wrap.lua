local M = {}

function M.setup(user_config)
  local togglewrap = require("vscode-neovim-fix-word-wrap.togglewrap")
  togglewrap.setup(user_config)
end

return M