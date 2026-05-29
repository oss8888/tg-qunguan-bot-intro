# Publish feature intro to GitHub Pages
param(
    [string]$GitHubUser = "",
    [string]$RepoName = "tg-qunguan-bot-intro",
    [switch]$SkipPagesEnable
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here

Copy-Item -Force (Join-Path $root "index.html") (Join-Path $here "index.html")
Set-Location $here

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "gh not found. Install: https://cli.github.com/"
}

gh auth status | Out-Null
if ($LASTEXITCODE -ne 0) {
    gh auth login -h github.com -p https -w
}

if (-not $GitHubUser) {
    $GitHubUser = (gh api user -q .login)
}

$remoteUrl = "https://github.com/$GitHubUser/$RepoName.git"
$repoExists = $false
gh repo view "$GitHubUser/$RepoName" 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) { $repoExists = $true }

if (-not $repoExists) {
    Write-Host "Creating public repo $GitHubUser/$RepoName ..."
    gh repo create $RepoName --public --source=. --remote=origin --push --description "TG bot feature intro (GitHub Pages)"
} else {
    if (-not (git remote get-url origin 2>$null)) {
        git remote add origin $remoteUrl
    }
    git add index.html README.md .nojekyll publish.ps1 2>$null
    $status = git status --porcelain
    if ($status) { git commit -m "Update feature intro page" }
    git push -u origin main
}

if (-not $SkipPagesEnable) {
    Write-Host "Enabling GitHub Pages (main / root) ..."
    gh api -X POST "repos/$GitHubUser/$RepoName/pages" -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/" 2>$null
    if ($LASTEXITCODE -ne 0) {
        gh api -X PUT "repos/$GitHubUser/$RepoName/pages" -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/" 2>$null
    }
}

$pagesUrl = "https://$GitHubUser.github.io/$RepoName/"
Write-Host ""
Write-Host "Done. Site URL (may take 1-3 min to deploy):"
Write-Host $pagesUrl
