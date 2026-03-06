-- Modulo para definição do shell
local M = {}

local wezterm = require 'wezterm'

-- Função auxiliar para detectar o melhor shell disponível
function M.get_best_shell()
    local shells = {'pwsh.exe', 'powershell.exe'}

    for _, shell in ipairs(shells) do
        local success, stdout, stderr = wezterm.run_child_process {'where.exe', shell}
        if success then
            return {shell, '-NoLogo'}
        end
    end

    return {'cmd.exe'}
end

return M
