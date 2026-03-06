# Requires -RunAsAdministrator
<#
.SYNOPSIS
    Instala todos os pacotes necessários para a configuração centralizada do terminal.
.DESCRIPTION
    - Instala/atualiza: WezTerm, Neovim, Oh My Posh
    - Instala fontes Nerd Font
    - Instala módulos PowerShell (posh-git, PSReadLine, etc.)
    - Configura variáveis de ambiente (XDG_CONFIG_HOME)
    - Exibe instruções manuais ao final
#>

param(
    [switch]$SkipFonts,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Forçar UTF-8 no console
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$configPath = "$env:USERPROFILE\.config"

# Cores para output
function Write-Step { param($msg) Write-Host "`n[*] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[+] $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[x] $msg" -ForegroundColor Red }
function Write-Info { param($msg) Write-Host "    $msg" -ForegroundColor Gray }

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "   Terminal Config - Init Packages" -ForegroundColor Magenta
Write-Host "========================================`n" -ForegroundColor Magenta

# ==========================================
# 1. VERIFICAR PRÉ-REQUISITOS
# ==========================================
Write-Step "Verificando pré-requisitos..."

# Verificar Scoop
$hasScoop = Get-Command scoop -ErrorAction SilentlyContinue
if (-not $hasScoop) {
    Write-Warning "Scoop não encontrado. Instalando..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    $env:PATH = "$env:USERPROFILE\scoop\shims;$env:PATH"
}
Write-Success "Scoop OK"

# Verificar Winget
$hasWinget = Get-Command winget -ErrorAction SilentlyContinue
if (-not $hasWinget) {
    Write-Error "Winget não encontrado! Instale o App Installer da Microsoft Store."
    Write-Info "URL: https://apps.microsoft.com/detail/9NBLGGH4NNS1"
    exit 1
}
Write-Success "Winget OK"

# Adicionar buckets do Scoop
Write-Step "Configurando buckets do Scoop..."
scoop bucket add extras 2>$null
scoop bucket add nerd-fonts 2>$null
Write-Success "Buckets configurados"

# ==========================================
# 2. INSTALAR/ATUALIZAR PACOTES PRINCIPAIS
# ==========================================
Write-Step "Instalando pacotes principais..."

# @{ Name = "WezTerm"; Id = "wez.wezterm" },
# @{ Name = "Neovim"; Id = "Neovim.Neovim" },
# @{ Name = "Git"; Id = "Git.Git" }
$wingetPackages = @(
    @{ Name = "Oh My Posh"; Id = "JanDeDobbeleer.OhMyPosh" }
)

foreach ($pkg in $wingetPackages) {
    Write-Info "Verificando $($pkg.Name)..."
    $installed = winget list --id $pkg.Id 2>$null | Select-String $pkg.Id
    if ($installed) {
        Write-Info "Atualizando $($pkg.Name)..."
        winget upgrade --id $pkg.Id --silent --accept-package-agreements --accept-source-agreements 2>$null
    } else {
        Write-Info "Instalando $($pkg.Name)..."
        winget install --id $pkg.Id --silent --accept-package-agreements --accept-source-agreements
    }
    Write-Success "$($pkg.Name) OK"
}

# Pacotes adicionais via Scoop (úteis para dev)
$scoopPackages = @("ripgrep", "fd", "fzf", "lazygit")
foreach ($pkg in $scoopPackages) {
    Write-Info "Verificando $pkg..."
    $installed = scoop list $pkg 2>$null | Select-String $pkg
    if (-not $installed) {
        scoop install $pkg 2>$null
    }
    Write-Success "$pkg OK"
}

# ==========================================
# 3. INSTALAR FONTES NERD FONT
# ==========================================
if (-not $SkipFonts) {
    Write-Step "Instalando fontes Nerd Font..."

    # Via Oh My Posh (método preferido)
    Write-Info "Instalando JetBrainsMono Nerd Font..."
    oh-my-posh font install JetBrainsMono 2>$null

    # Fallback via Scoop
    $fontInstalled = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "*JetBrainsMono*" }

    if (-not $fontInstalled) {
        Write-Info "Tentando via Scoop..."
        scoop install JetBrainsMono-NF 2>$null
    }

    Write-Success "Fontes instaladas"
}

# ==========================================
# 4. INSTALAR MÓDULOS POWERSHELL
# ==========================================
Write-Step "Instalando módulos PowerShell..."

$psModules = @(
    "PSReadLine",
    "posh-git",
    "TabExpansionPlusPlus",
    "Terminal-Icons"
)

foreach ($module in $psModules) {
    Write-Info "Verificando $module..."
    $installed = Get-Module -ListAvailable -Name $module -ErrorAction SilentlyContinue
    if (-not $installed) {
        Write-Info "Instalando $module..."
        Install-Module -Name $module -Force -Scope CurrentUser -AllowClobber
    }
    Write-Success "$module OK"
}

# ==========================================
# 5. CONFIGURAR VARIÁVEIS DE AMBIENTE
# ==========================================
Write-Step "Configurando variáveis de ambiente..."

# XDG_CONFIG_HOME para Neovim e outros apps
$currentXdg = [Environment]::GetEnvironmentVariable("XDG_CONFIG_HOME", "User")
if ($currentXdg -ne $configPath) {
    [Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $configPath, "User")
    $env:XDG_CONFIG_HOME = $configPath
    Write-Success "XDG_CONFIG_HOME definido para $configPath"
} else {
    Write-Success "XDG_CONFIG_HOME já configurado"
}

# ==========================================
# 6. CRIAR ESTRUTURA DE PASTAS
# ==========================================
Write-Step "Criando estrutura de pastas..."

$folders = @(
    "$configPath\nvim",
    "$configPath\powershell",
    "$configPath\oh-my-posh"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Success "Criado: $folder"
    } else {
        Write-Info "Já existe: $folder"
    }
}

# ==========================================
# 7. CONFIGURAR POWERSHELL PROFILE
# ==========================================
Write-Step "Configurando PowerShell Profile..."

$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$profileRedirect = @"
# Redirect to centralized config
if (Test-Path "`$HOME\.config\powershell\profile.ps1") {
    . "`$HOME\.config\powershell\profile.ps1"
}
"@

$currentProfile = ""
if (Test-Path $PROFILE) {
    $currentProfile = Get-Content $PROFILE -Raw
}

if ($currentProfile -notlike "*\.config\powershell\profile.ps1*") {
    Add-Content -Path $PROFILE -Value "`n$profileRedirect"
    Write-Success "Profile atualizado para redirecionar para ~/.config/powershell/"
} else {
    Write-Info "Profile já configurado"
}

# ==========================================
# 8. RESUMO E INSTRUÇÕES MANUAIS
# ==========================================
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "   INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Pacotes instalados:" -ForegroundColor Cyan
Write-Host "  + WezTerm (terminal)" -ForegroundColor Gray
Write-Host "  + Neovim (editor)" -ForegroundColor Gray
Write-Host "  + Oh My Posh (prompt)" -ForegroundColor Gray
Write-Host "  + Git" -ForegroundColor Gray
Write-Host "  + ripgrep, fd, fzf, lazygit (dev tools)" -ForegroundColor Gray
Write-Host "  + JetBrainsMono Nerd Font" -ForegroundColor Gray
Write-Host "  + Módulos PS: PSReadLine, posh-git, TabExpansionPlusPlus, Terminal-Icons" -ForegroundColor Gray

Write-Host "`nVariáveis de ambiente:" -ForegroundColor Cyan
Write-Host "  + XDG_CONFIG_HOME = $configPath" -ForegroundColor Gray

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "   AÇÕES MANUAIS NECESSÁRIAS" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Yellow

Write-Host "1. REINICIAR O TERMINAL" -ForegroundColor White
Write-Host "   Feche e abra o WezTerm para aplicar todas as configs`n" -ForegroundColor Gray

Write-Host "2. VERIFICAR FONTE NO WEZTERM" -ForegroundColor White
Write-Host "   Se os ícones não aparecerem, selecione manualmente:" -ForegroundColor Gray
Write-Host "   WezTerm > Settings > Appearance > Font: 'JetBrainsMono Nerd Font'`n" -ForegroundColor Gray

Write-Host "3. CONFIGURAÇÃO DO NEOVIM" -ForegroundColor White
Write-Host "   Sua config deve estar em: $configPath\nvim\init.lua" -ForegroundColor Gray
Write-Host "   Verifique com :echo stdpath('config') dentro do Neovim`n" -ForegroundColor Gray

Write-Host "4. PLUGINS NEOVIM (se usar)" -ForegroundColor White
Write-Host "   Se usar LazyVim ou similar, execute :Lazy sync`n" -ForegroundColor Gray

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "   REFERÊNCIAS ÚTEIS" -ForegroundColor Magenta
Write-Host "========================================`n" -ForegroundColor Magenta

Write-Host "WezTerm Docs:      https://wezterm.org/config/appearance.html" -ForegroundColor Gray
Write-Host "Oh My Posh Themes: https://ohmyposh.dev/docs/themes" -ForegroundColor Gray
Write-Host "Nerd Fonts:        https://www.nerdfonts.com/" -ForegroundColor Gray
Write-Host "Neovim Docs:       https://neovim.io/doc/" -ForegroundColor Gray
Write-Host "posh-git:          https://github.com/dahlbyk/posh-git" -ForegroundColor Gray

Write-Host "`n"
