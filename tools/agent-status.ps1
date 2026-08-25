<#
.SYNOPSIS
    GPT / Codex / Qwen / GitHub four-way working-state checker.

.DESCRIPTION
    Read-only observer. Reports the current state of the four parts of the
    upstream-sync pipeline WITHOUT modifying any system state:
      1. GPT / ChatGPT  - upstream spec provider (best-effort, no local state)
      2. Codex          - local agent runtime (config, model provider, CLI)
      3. Qwen / Ollama  - local model inference (process + HTTP endpoint)
      4. GitHub         - remote repository (git + ls-remote, read-only)

    This script ONLY reads. It never writes files, never commits, never
    pushes, never changes config, and never mutates the repository.

.PARAMETER RepoPath
    Path to the AI-Agent-Test git repository. Defaults to the parent of the
    tools/ directory (i.e. the repo root next to this script).

.PARAMETER Branch
    Branch to report on. Defaults to the currently checked-out branch.

.PARAMETER OllamaUrl
    Ollama base URL. Defaults to http://127.0.0.1:11434

.PARAMETER NoNetwork
    Skip network calls (Ollama HTTP + GitHub ls-remote). Offline mode.

.EXAMPLE
    pwsh ./tools/agent-status.ps1
    pwsh ./tools/agent-status.ps1 -Branch main -NoNetwork
#>
[CmdletBinding()]
param(
    [string]$RepoPath = (Split-Path -Parent $PSScriptRoot),
    [string]$Branch   = "",
    [string]$OllamaUrl = "http://127.0.0.1:11434",
    [switch]$NoNetwork
)

$ErrorActionPreference = "Continue"

function Write-Section([string]$title) {
    "`n" + ("=" * 64)
    "  $title"
    ("=" * 64)
}

function Write-Row([string]$label, [string]$value) {
    "{0,-28} {1}" -f $label, $value
}

# ---------------------------------------------------------------------------
# 0. Header / environment
# ---------------------------------------------------------------------------
Write-Section "0. ENVIRONMENT"
Write-Row "Host"          $env:COMPUTERNAME
Write-Row "Timestamp"     (Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz")
Write-Row "PSVersion"     $PSVersionTable.PSVersion.ToString()
Write-Row "RepoPath"      $RepoPath
Write-Row "Repo exists?"  $(if (Test-Path $RepoPath) { "yes" } else { "NO" })
Write-Row "Network mode"  $(if ($NoNetwork) { "OFFLINE (-NoNetwork)" } else { "ONLINE" })

if (-not (Test-Path $RepoPath)) {
    Write-Error "RepoPath does not exist: $RepoPath"
    exit 1
}

# ---------------------------------------------------------------------------
# 1. GPT / ChatGPT (upstream spec provider)
# ---------------------------------------------------------------------------
Write-Section "1. GPT / CHATGPT (upstream spec provider)"
Write-Row "Role"          "Provides upstream specs read from GitHub"
Write-Row "Local state"   "none (cloud service; no local observable state)"
Write-Row "Observable"    "Only via GitHub repo content (see section 4)"
Write-Row "Status"        "OK (no local dependency)"

# ---------------------------------------------------------------------------
# 2. Codex (local agent runtime)
# ---------------------------------------------------------------------------
Write-Section "2. CODEX (local agent runtime)"
$codexHome = Join-Path $env:USERPROFILE ".codex"
$configToml = Join-Path $codexHome "config.toml"
Write-Row "CODEX_HOME"    $codexHome
Write-Row "config.toml"   $(if (Test-Path $configToml) { "present" } else { "MISSING" })

$codexCmd = Get-Command codex -ErrorAction SilentlyContinue
Write-Row "codex CLI"     $(if ($codexCmd) { "in PATH ($($codexCmd.Source))" } else { "not in PATH" })

# Parse model / provider / stream settings from config.toml (read-only).
$codexModel = ""; $codexProvider = ""; $idleTimeout = ""; $maxRetries = ""
if (Test-Path $configToml) {
    $cfgText = Get-Content -LiteralPath $configToml -Raw
    if ($cfgText -match '(?m)^\s*model\s*=\s*"([^"]+)"') { $codexModel = $Matches[1] }
    if ($cfgText -match '(?m)^\s*model_provider\s*=\s*"([^"]+)"')         { $codexProvider = $Matches[1] }
    if ($cfgText -match 'stream_idle_timeout_ms\s*=\s*(\d+)')         { $idleTimeout = $Matches[1] }
    if ($cfgText -match 'stream_max_retries\s*=\s*(\d+)')             { $maxRetries = $Matches[1] }
}
Write-Row "model"         $(if ($codexModel)    { $codexModel }    else { "(not set)" })
Write-Row "model_provider"$(if ($codexProvider) { $codexProvider } else { "(not set)" })
Write-Row "stream_idle_timeout_ms" $(if ($idleTimeout) { "$idleTimeout ms" } else { "(not set)" })
Write-Row "stream_max_retries"     $(if ($maxRetries)  { $maxRetries }        else { "(not set)" })
Write-Row "Status"        "OK"

# ---------------------------------------------------------------------------
# 3. Qwen / Ollama (local model inference)
# ---------------------------------------------------------------------------
Write-Section "3. QWEN / OLLAMA (local model inference)"
$ollamaProc = Get-Process -Name "ollama" -ErrorAction SilentlyContinue
$procRunning = ($null -ne $ollamaProc)
Write-Row "process"       $(if ($procRunning) { "running" } else { "NOT running" })

$ollamaReachable = $false
$modelAvailable = ""
if (-not $NoNetwork) {
    try {
        $tags = Invoke-RestMethod -Uri "$OllamaUrl/api/tags" -TimeoutSec 5 -ErrorAction Stop
        $ollamaReachable = $true
        $names = @($tags.models | ForEach-Object { $_.name })
        Write-Row "endpoint"      "$OllamaUrl  (reachable)"
        Write-Row "model_count"   $names.Count
        # Highlight the configured Codex model if present.
        $match = $names | Where-Object { $_ -eq $codexModel } | Select-Object -First 1
        if ($match) {
            $modelAvailable = $match
            Write-Row "codex_model" "available ($match)"
        } else {
            Write-Row "codex_model" "NOT in list ($codexModel)"
        }
    } catch {
        Write-Row "endpoint"      "$OllamaUrl  (unreachable: $($_.Exception.Message))"
    }
} else {
    Write-Row "endpoint"      "skipped (-NoNetwork)"
}

$ollamaStatus = "OK"
if ($ollamaReachable) { $ollamaStatus = "OK (reachable)" }
elseif ($procRunning) { $ollamaStatus = "WARN (process up, endpoint unreachable)" }
else                  { $ollamaStatus = "DOWN (no process)" }
Write-Row "Status"        $ollamaStatus

# ---------------------------------------------------------------------------
# 4. GitHub (remote repository)
# ---------------------------------------------------------------------------
Write-Section "4. GITHUB (remote repository)"
Push-Location $RepoPath
try {
    $isGit = ($null -ne (git rev-parse --is-inside-work-tree 2>$null))
    Write-Row "is git repo"   $(if ($isGit) { "yes" } else { "NO" })

    if ($isGit) {
        $curBranch = (git branch --show-current 2>$null)
        $reportBranch = if ($Branch) { $Branch } else { $curBranch }
        $headSha = (git rev-parse HEAD 2>$null)
        $remote = (git remote get-url origin 2>$null)
        $statusShort = (git status -s 2>$null)
        $clean = [string]::IsNullOrWhiteSpace($statusShort)

        Write-Row "current branch" $curBranch
        Write-Row "report branch"  $reportBranch
        Write-Row "HEAD SHA"       $headSha
        Write-Row "remote origin"  $(if ($remote) { $remote } else { "(none)" })
        Write-Row "working tree"   $(if ($clean) { "clean" } else { "dirty" })
        if (-not $clean) {
            ($statusShort | ForEach-Object { "    $_" }) | ForEach-Object { $_ }
        }

        # Upstream tracking + divergence (read-only).
        $upstream = (git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null)
        Write-Row "upstream"     $(if ($upstream) { $upstream } else { "(none)" })

        if ($remote -and $upstream -and -not $NoNetwork) {
            $aheadBehind = (git rev-list --left-right --count "$upstream...HEAD" 2>$null)
            if ($aheadBehind) {
                $parts = $aheadBehind -split "\s+"
                Write-Row "behind/ahead" "behind=$($parts[0]) ahead=$($parts[1]) (vs $upstream)"
            }
            $remoteHead = (git rev-parse "$upstream" 2>$null)
            Write-Row "remote HEAD"  $remoteHead
        } elseif ($NoNetwork) {
            Write-Row "remote sync"  "skipped (-NoNetwork)"
        }

        $gitStatus = "OK"
        if (-not $isGit) { $gitStatus = "NOT a repo" }
        elseif (-not $clean) { $gitStatus = "OK (dirty working tree)" }
        else { $gitStatus = "OK (clean)" }
        Write-Row "Status"        $gitStatus
    }
} finally {
    Pop-Location
}

# ---------------------------------------------------------------------------
# 5. Summary
# ---------------------------------------------------------------------------
Write-Section "5. SUMMARY"
$summary = @(
    @("GPT/ChatGPT", "OK (upstream spec via GitHub)"),
    @("Codex",       "OK"),
    @("Qwen/Ollama", $ollamaStatus),
    @("GitHub",      $gitStatus)
)
$allOk = $true
foreach ($s in $summary) {
    $mark = if ($s[1] -match "^OK") { "PASS" } else { "CHECK" }
    if ($mark -eq "CHECK") { $allOk = $false }
    $row = "{0,-14} {1}" -f $s[0], $s[1]
    Write-Row "[$mark]" $row
}
"`nOverall: " + $(if ($allOk) { "ALL PASS" } else { "SOME CHECKS NEED ATTENTION" })
"`n(read-only observer; no system state was modified)"

exit 0


