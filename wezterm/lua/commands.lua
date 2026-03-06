local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- 1. Defina pastas de projetos específicas para evitar escanear AppData e caches.
-- Exemplo: { wezterm.home_dir .. "\\Projects", wezterm.home_dir .. "\\Documents\\Dev" }

local sub_project_dir = wezterm.home_dir .. "\\OneDrive - mirante.net.br\\Documentos"

M.project_dirs = {
	wezterm.home_dir .. "\\Documents",
	sub_project_dir .. "\\Projects",
	sub_project_dir .. "\\Temp",
	sub_project_dir .. "\\Research",
	"C:\\projetos\\mirante\\modernizacao",
}

local function scan_projects()
	local projects = {}

	for _, base_dir in ipairs(M.project_dirs) do
		-- Utilizamos o PowerShell em modo não-interativo para buscar os diretórios.
		-- O -LiteralPath evita qualquer problema com caracteres especiais ou espaços no wezterm.home_dir.
		local success, stdout, stderr = wezterm.run_child_process({
			"powershell.exe",
			"-NoProfile",
			"-NonInteractive",
			"-Command",
			"(Get-ChildItem -LiteralPath '" .. base_dir .. "' -Directory).Name",
		})

		if success and stdout then
			-- O PowerShell retorna os nomes separados por quebra de linha.
			-- Iteramos de forma segura extraindo apenas o texto.
			for line in stdout:gmatch("[^\r\n]+") do
				table.insert(projects, {
					label = "dir> " .. line .. "  (" .. base_dir .. ")",
					id = base_dir .. "\\" .. line,
				})
			end
		else
			-- Log opcional: Útil para debugar no console do WezTerm (Ctrl+Shift+L) caso falhe.
			wezterm.log_error("Falha ao ler diretório: " .. tostring(stderr))
		end
	end

	if #projects == 0 then
		-- Agora mostramos em qual diretório ele tentou buscar para facilitar o debug visual.
		table.insert(projects, {
			label = "Nenhum projeto em: " .. tostring(M.project_dirs[1]),
			id = "none",
		})
	end

	return projects
end

local function create_env_layout(window, pane, id, label)
	if not id or id == "none" then
		return
	end

	local project_path = id

	local tab, nvim_pane, win = window:mux_window():spawn_tab({
		cwd = project_path,
	})

	local dir = project_path:match("[^\\]+$")
	tab:set_title(dir)

	-- Delays entre splits para evitar colisão do Oh My Posh no cache de init
	wezterm.sleep_ms(500)

	local claude_pane = nvim_pane:split({
		direction = "Right",
		size = 0.5,
		cwd = project_path,
	})

	wezterm.sleep_ms(500)

	local terminal_pane = claude_pane:split({
		direction = "Bottom",
		size = 0.3,
		cwd = project_path,
	})

	wezterm.sleep_ms(300)

	nvim_pane:send_text("nvim .\r\n")
	claude_pane:send_text("claude\r\n")
	terminal_pane:send_text("git status\r\n")
end

function M.setup()
	wezterm.on("augment-command-palette", function(window, pane)
		return {
			{
				brief = "Setup Env Project",
				icon = "cod_layout",
				-- PONTO CRÍTICO CORRIGIDO: Arquitetura Eager alterada para Lazy.
				-- A ação agora engatilha um processo isolado, garantindo a performance da paleta principal.
				action = wezterm.action_callback(function(win, pn)
					-- O carregamento (I/O) acontece apenas após o usuário decidir iniciar um projeto.
					local project_choices = scan_projects()

					-- Dispara nativamente a interface do InputSelector sobre a janela aberta.
					win:perform_action(
						act.InputSelector({
							title = "Selecione o projeto:",
							choices = project_choices,
							fuzzy = true,
							fuzzy_description = "Buscar projeto...",
							action = wezterm.action_callback(create_env_layout),
						}),
						pn
					)
				end),
			},
		}
	end)
end

return M
