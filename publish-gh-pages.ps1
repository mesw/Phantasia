#Requires -Version 5.1
<#
.SYNOPSIS
    Publishes the local WebAssembly build of Phantasia directly to the
    'gh-pages' branch on GitHub Pages without requiring CI build minutes.

.PARAMETER RemoteUrl
    Git remote URL for pushing the gh-pages branch. Defaults to origin remote if configured,
    or https://github.com/mesw/phantasia.git.

.PARAMETER Branch
    Target deployment branch name (default: gh-pages).

.PARAMETER BuildDir
    Explicit path to the WebAssembly build directory. If omitted, candidate paths
    (QtAphantasie\build_wasm, build_wasm, docs, etc.) are automatically scanned.

.PARAMETER NoPush
    If specified, prepares and commits the staging folder locally without executing git push.
#>

[CmdletBinding()]
param(
    [string]$RemoteUrl = "",
    [string]$Branch = "gh-pages",
    [string]$BuildDir = "",
    [switch]$NoPush
)

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot

# 0. Locate WebAssembly build directory
$candidateBuildDirs = @()
if (-not [string]::IsNullOrWhiteSpace($BuildDir)) {
    $candidateBuildDirs += $BuildDir
}

$candidateBuildDirs += @(
    (Join-Path $repoRoot "QtAphantasie\build_wasm"),
    (Join-Path $repoRoot "build_wasm"),
    (Join-Path $repoRoot "docs"),
    (Join-Path $repoRoot "QtAphantasie\build\WebAssembly_Qt_6_8_3_single_threaded-Release"),
    (Join-Path $repoRoot "QtAphantasie\build\WebAssembly_Qt_6_8_3_single_threaded-Debug")
)

$wasmBuild = $null
foreach ($dir in $candidateBuildDirs) {
    if (Test-Path (Join-Path $dir "appQtAphantasie.wasm")) {
        $wasmBuild = $dir
        break
    }
}

if (-not $wasmBuild) {
    Write-Error "WebAssembly build directory not found. Looked in:`n$($candidateBuildDirs -join "`n")`nPlease build the WebAssembly target first."
    exit 1
}

# 1. Determine remote git URL
if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
    try {
        $gitRemote = (git -C $repoRoot config --get remote.origin.url 2>$null)
        if ($gitRemote) {
            $RemoteUrl = $gitRemote.Trim()
        }
    } catch {
        # ignore git error
    }
}

if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
    $RemoteUrl = "https://github.com/mesw/phantasia.git"
}

$stageDir = Join-Path $env:TEMP "phantasia-gh-pages"

# 2. Verify all required WebAssembly build artifacts exist
$requiredFiles = @(
    "appQtAphantasie.js",
    "appQtAphantasie.wasm"
)

foreach ($file in $requiredFiles) {
    $fullPath = Join-Path $wasmBuild $file
    if (-not (Test-Path $fullPath)) {
        Write-Error "Missing build artifact: $fullPath`nPlease rebuild the WebAssembly target first."
        exit 1
    }
}

Write-Host "==> Preparing clean staging directory: $stageDir" -ForegroundColor Cyan
if (Test-Path $stageDir) {
    Remove-Item -Recurse -Force $stageDir
}
New-Item -ItemType Directory -Path $stageDir | Out-Null

# 3. Copy WebAssembly build artifacts
Write-Host "==> Copying WebAssembly artifacts from: $wasmBuild" -ForegroundColor Cyan
foreach ($file in $requiredFiles) {
    Copy-Item (Join-Path $wasmBuild $file) (Join-Path $stageDir $file)
    Write-Host "    + $file" -ForegroundColor Gray
}

# Companion runtime loader (qtloader.js)
$loaderSource = $null
if (Test-Path (Join-Path $wasmBuild "qtloader.js")) {
    $loaderSource = Join-Path $wasmBuild "qtloader.js"
} elseif (Test-Path (Join-Path $repoRoot "docs\qtloader.js")) {
    $loaderSource = Join-Path $repoRoot "docs\qtloader.js"
}

if ($loaderSource) {
    Copy-Item $loaderSource (Join-Path $stageDir "qtloader.js")
    Write-Host "    + qtloader.js" -ForegroundColor Gray
} else {
    Write-Warning "qtloader.js not found in build directory or docs/. App may fail to launch in browser."
}

# 4. Copy landing page as pure UTF-8 (without BOM)
# Prefer docs/index.html (the customized serene dark theme runner)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$indexSourcePath = $null
if (Test-Path (Join-Path $repoRoot "docs\index.html")) {
    $indexSourcePath = Join-Path $repoRoot "docs\index.html"
} elseif (Test-Path (Join-Path $wasmBuild "appQtAphantasie.html")) {
    $indexSourcePath = Join-Path $wasmBuild "appQtAphantasie.html"
} elseif (Test-Path (Join-Path $repoRoot "index.html")) {
    $indexSourcePath = Join-Path $repoRoot "index.html"
}

if ($indexSourcePath) {
    $htmlContent = [System.IO.File]::ReadAllText($indexSourcePath, $utf8NoBom)
    $indexDestPath = Join-Path $stageDir "index.html"
    $appHtmlDestPath = Join-Path $stageDir "appQtAphantasie.html"

    [System.IO.File]::WriteAllText($indexDestPath, $htmlContent, $utf8NoBom)
    [System.IO.File]::WriteAllText($appHtmlDestPath, $htmlContent, $utf8NoBom)
    Write-Host "    + index.html & appQtAphantasie.html (from $indexSourcePath)" -ForegroundColor Gray
} else {
    # Generate minimal redirect index if not found
    $fallbackHtml = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="0; url=appQtAphantasie.html">
    <title>Redirecting to Phantasia...</title>
</head>
<body>
    <p>Redirecting to <a href="appQtAphantasie.html">Phantasia</a>...</p>
</body>
</html>
"@
    [System.IO.File]::WriteAllText((Join-Path $stageDir "index.html"), $fallbackHtml, $utf8NoBom)
}

# Optional companion docs (e.g. AUDIO_GUIDANCE_TTS.md)
$ttsPath = Join-Path $repoRoot "docs\AUDIO_GUIDANCE_TTS.md"
if (Test-Path $ttsPath) {
    Copy-Item $ttsPath (Join-Path $stageDir "AUDIO_GUIDANCE_TTS.md")
    Write-Host "    + AUDIO_GUIDANCE_TTS.md (Audio Guidance Scripts)" -ForegroundColor Gray
}

# 5. Create .nojekyll so GitHub Pages does not ignore underscore files or binary .wasm
New-Item -ItemType File -Path (Join-Path $stageDir ".nojekyll") | Out-Null
Write-Host "    + .nojekyll" -ForegroundColor Gray

# 6. Commit and force-push ONLY the staging folder to the gh-pages branch
Write-Host "==> Initializing Git deployment branch: $Branch" -ForegroundColor Cyan
Push-Location $stageDir
try {
    git init -q
    git checkout -b $Branch -q
    git add .
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Deploy Phantasia WebAssembly build ($timestamp)" -q

    if ($NoPush) {
        Write-Host "`n==> [-NoPush specified] Staging verified and committed locally at: $stageDir" -ForegroundColor Yellow
        Write-Host "    To push manually: git -C `"$stageDir`" push -f $RemoteUrl $Branch" -ForegroundColor Gray
    } else {
        Write-Host "==> Deploying to $RemoteUrl (branch: $Branch)..." -ForegroundColor Cyan
        git push -f $RemoteUrl $Branch
        
        # Extract username & repo for GitHub Pages URL display
        $pagesUrl = "https://mesw.github.io/phantasia/"
        if ($RemoteUrl -match "github\.com[/:]([^/]+)/([^/.]+)") {
            $pagesUrl = "https://$($Matches[1]).github.io/$($Matches[2])/"
        }
        Write-Host "`n==> Successfully published to $pagesUrl" -ForegroundColor Green
    }
} finally {
    Pop-Location
}
