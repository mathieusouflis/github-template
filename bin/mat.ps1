# mat.ps1 — native Windows entrypoint. Nix/direnv/devenv only run inside
# WSL2, so this script's real job is: get you into WSL2 (where bin/mat gives
# you the full reproducible dev shell), or — if you decline — fall back to a
# Terraform-only path that skips the reproducible shell entirely.
#
# This is a separate, smaller reimplementation of bin/mat's repo-config
# mechanics, not a wrapper around it — bin/mat is bash and won't run natively
# on Windows. Keep the two in sync by hand if the terraform flow changes.

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Confirm-Action {
    param([string]$Prompt)
    $reply = Read-Host "$Prompt [y/N]"
    return $reply -match '^[Yy]$'
}

function Test-Wsl2 {
    try {
        wsl.exe -l -v *> $null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Enter-Wsl2Path {
    Write-Host "-> WSL2"
    if (Test-Wsl2) {
        Write-Host "   WSL2 is already installed. Open a WSL2 terminal (e.g. Ubuntu) in this repo and run: ./bin/mat setup"
        return $true
    }
    if (Confirm-Action "WSL2 is not installed. Install it now (requires a restart)?") {
        wsl --install
        Write-Host "!! Restart your computer, then open a WSL2 terminal (e.g. Ubuntu) in this repo and run: ./bin/mat setup"
        exit 0
    }
    return $false
}

function Set-GitHooksAndEnv {
    Push-Location $RepoRoot
    try {
        $hooksPath = git config --local --get core.hooksPath 2>$null
        if ($hooksPath -eq ".githooks") {
            Write-Host "   Git hooks already activated."
        } else {
            git config core.hooksPath .githooks
            Write-Host "   Activated Git hooks (core.hooksPath = .githooks)."
        }

        if (Test-Path ".env") {
            Write-Host "   .env already exists, leaving it alone."
        } else {
            Copy-Item ".env.example" ".env"
            Write-Host "   Created .env from .env.example — fill in the values before running the project."
        }
    } finally {
        Pop-Location
    }
}

function Install-TerraformWinget {
    if (Get-Command terraform -ErrorAction SilentlyContinue) {
        Write-Host "   Terraform already installed."
        return $true
    }
    if (-not (Confirm-Action "Terraform is not installed. Install it now via winget?")) {
        Write-Host "!! Skipping Terraform install. Re-run bin/mat.ps1 once it's available, or install it yourself."
        return $false
    }
    winget install --id Hashicorp.Terraform -e --accept-source-agreements --accept-package-agreements
    return $true
}

function Get-OriginSlug {
    $url = git -C $RepoRoot remote get-url origin 2>$null
    if (-not $url) { return $null }
    if ($url -match '[:/]([^/]+)/([^/.]+?)(\.git)?$') {
        return "$($Matches[1])/$($Matches[2])"
    }
    return $null
}

function Get-GitHubToken {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $token = gh auth token 2>$null
        if ($token) {
            Write-Host "   Using GitHub token from 'gh auth token'."
            return $token
        }
    }
    $secure = Read-Host "GitHub token (repo admin scope)" -AsSecureString
    return [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
}

function Invoke-RepoApply {
    $slug = Get-OriginSlug
    if (-not $slug) {
        Write-Host "!! Couldn't determine owner/repo from 'git remote get-url origin'."
        return
    }
    $owner, $repo = $slug -split '/', 2

    Write-Host "-> Configuring GitHub repository: $slug"
    $tfvarsPath = Join-Path $RepoRoot "terraform\terraform.tfvars"
    @"
repository_owner = "$owner"
repository_name  = "$repo"
"@ | Set-Content -Path $tfvarsPath
    Write-Host "   Wrote terraform/terraform.tfvars"

    $env:GITHUB_TOKEN = Get-GitHubToken

    Push-Location (Join-Path $RepoRoot "terraform")
    try {
        terraform init | Out-Host

        $state = terraform state list 2>$null
        if (-not ($state -contains "module.github_repository.github_repository.this")) {
            Write-Host "-> Importing the existing repository into terraform state..."
            terraform import "module.github_repository.github_repository.this" $repo | Out-Host
        }

        terraform plan | Out-Host

        if (Confirm-Action "Apply these changes to $slug now?") {
            terraform apply | Out-Host
        } else {
            Write-Host "!! Skipped apply. Re-run bin/mat.ps1, or 'terraform apply' from terraform/, when ready."
        }
    } finally {
        Pop-Location
    }
}

##### MAIN #####
Write-Host "-> Git hooks and .env (no Nix required for these)"
Set-GitHooksAndEnv

Write-Host ""
if (-not (Enter-Wsl2Path)) {
    Write-Host ""
    Write-Host "-> Falling back to a direct Terraform install (no reproducible dev shell)"
    if (Install-TerraformWinget) {
        Invoke-RepoApply
    }
}

Write-Host ""
Write-Host "-> Setup complete. Full guide: docs/product-code/tutorials/getting-started.md"
