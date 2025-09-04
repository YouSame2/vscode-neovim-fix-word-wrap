-- Minimal plugin entry: load the plugin and run setup with defaults.
-- Users can call require('vscode-neovim-fix-word-wrap').setup({...}) themselves to override.
pcall(function()
	require("vscode-neovim-fix-word-wrap").setup()
end)
