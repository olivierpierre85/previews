<#
    update.ps1 - publish preview changes.

    Exported HTML files never carry a noindex tag, and any tag added by hand is
    lost the next time the file is re-exported. This script re-injects it across
    every page, then commits and pushes.

    Run it from an interactive PowerShell prompt so git can reach the credential
    manager if it needs to re-authenticate.

    Usage:  .\update.ps1
            .\update.ps1 -Message "Elevate Electric: darker header"

    Keep this file ASCII-only. Windows PowerShell 5.1 reads .ps1 as ANSI unless
    there is a BOM, so a stray typographic dash becomes mojibake and the script
    fails to parse.
#>

[CmdletBinding()]
param(
    [string]$Message = "Update previews"
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$tag = '<meta name="robots" content="noindex, nofollow, noarchive, nosnippet">'

# --- inject noindex into any page missing it -------------------------------

$patched = @()
Get-ChildItem -Path $root -Filter *.html -Recurse -File | ForEach-Object {
    $text = [IO.File]::ReadAllText($_.FullName)
    if ($text -match 'name="robots"') { return }

    $rx = [regex]'(?i)<head[^>]*>'
    if (-not $rx.IsMatch($text)) {
        Write-Warning "no head element in $($_.Name), cannot add noindex"
        return
    }

    # Only the first head element; exports contain exactly one.
    $text = $rx.Replace($text, { param($m) "$($m.Value)`n  $tag" }, 1)

    # UTF8 without BOM. A BOM ahead of the doctype can upset some parsers.
    [IO.File]::WriteAllText($_.FullName, $text, (New-Object Text.UTF8Encoding $false))
    $patched += $_.FullName.Substring($root.Length + 1)
}

if ($patched.Count -gt 0) {
    "Added noindex to:"
    $patched | ForEach-Object { "  $_" }
} else {
    "All pages already carry a noindex tag."
}

# --- commit and push -------------------------------------------------------

Push-Location $root
try {
    if (-not (git status --porcelain)) { "Nothing to publish."; return }

    git add -A
    git commit -q -m $Message
    if (-not $?) { throw "commit failed" }

    git push origin main
    if (-not $?) { throw "push failed" }
    ""
    "Pushed. GitHub Pages redeploys in about a minute."
    "Watch it at: https://github.com/olivierpierre85/previews/actions"
}
finally { Pop-Location }
