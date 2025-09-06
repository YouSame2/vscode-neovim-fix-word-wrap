local M = {}

--- Register a list of keymaps.
-- @param config table The plugin's configuration table.
function M.set_wrap_keymaps(config)
    -- Set mappings
    for _, mode_maps in pairs(config.mappings) do
        for _, keymap_config in pairs(mode_maps) do
            if keymap_config.enabled and keymap_config.map then
                local map = keymap_config.map
                vim.keymap.set(map[1], map[2], map[3], map[4])
            end
        end
    end

    -- Set remappings
    for _, keymap_config in pairs(config.remappings) do
        if keymap_config.enabled and keymap_config.map then
            local map = keymap_config.map
            vim.keymap.set(map[1], map[2], map[3], map[4])
        end
    end
end

--- Remove a list of keymaps.
-- @param config table The plugin's configuration table.
function M.unset_wrap_keymaps(config)
    local function del_keymap(keymap_config)
        if not (keymap_config and keymap_config.enabled and keymap_config.map) then
            return
        end
        local map = keymap_config.map
        local mode, lhs = map[1], map[2]
        if type(mode) == "table" then
            for _, m in ipairs(mode) do
                pcall(vim.keymap.del, m, lhs)
            end
        else
            pcall(vim.keymap.del, mode, lhs)
        end
    end

    -- Unset mappings
    for _, mode_maps in pairs(config.mappings) do
        for _, keymap_config in pairs(mode_maps) do
            del_keymap(keymap_config)
        end
    end

    -- Unset remappings
    for _, keymap_config in pairs(config.remappings) do
        del_keymap(keymap_config)
    end
end

---Word wrap modes.
---@alias WordWrapMode '"off"'|'"on"'|'"bounded"'|'"wordWrapColumn"'

---Get VSCode word wrap setting with info on whether wrapping is active.
---@return { mode: WordWrapMode|nil, enabled: boolean }
function M.get_vscode_wrap()
    if not vim.g.vscode then
        return { mode = nil, enabled = false }
    end
    local vscode = require("vscode")
    local mode = vscode.get_config("editor.wordWrap")
    local enabled = mode == "on" or mode == "bounded" or mode == "wordWrapColumn"
    return { mode = mode, enabled = enabled }
end

--- Return true when a macro is currently executing.
function M.is_macro_executing()
    return vim.fn.reg_executing() ~= ""
end

function M.is_macro_recording()
    return vim.fn.reg_recording() ~= ""
end

return M

