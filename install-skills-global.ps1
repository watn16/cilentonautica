# Copies the skills in .claude\skills into ~\.claude\skills so every project can use them.
# Existing skills with the same name are skipped unless you pass -Force.
param([switch]$Force)

$src = Join-Path $PSScriptRoot ".claude\skills"
$dest = Join-Path $HOME ".claude\skills"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$installed = 0
$skipped = 0
foreach ($dir in Get-ChildItem -Directory $src) {
    $target = Join-Path $dest $dir.Name
    if ((Test-Path $target) -and -not $Force) {
        Write-Host "skip   $($dir.Name) (already exists, use -Force to overwrite)"
        $skipped++
        continue
    }
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item -Recurse $dir.FullName $target
    $installed++
}
Write-Host "Installed $installed skills, skipped $skipped. Restart Claude Code to load them."
