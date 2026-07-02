param(
    [Parameter(Mandatory = $true)]
    [string]$KoLMafiaRoot,

    [Parameter(Mandatory = $true)]
    [string]$Character,

    [string]$Label = "manual"
)

$ErrorActionPreference = "Stop"

function New-SafeName([string]$value) {
    if ([string]::IsNullOrWhiteSpace($value)) { return "manual" }
    return ($value -replace '[^A-Za-z0-9_.-]', '_')
}

function Test-EscapedNullPrefix([string]$path) {
    if (!(Test-Path -LiteralPath $path)) { return $false }
    $bytes = [System.IO.File]::ReadAllBytes($path)
    if ($bytes.Length -lt 24) { return $false }

    $prefix = [System.Text.Encoding]::ASCII.GetString($bytes, 0, [Math]::Min(120, $bytes.Length))
    return $prefix.StartsWith("\u0000\u0000\u0000\u0000")
}

if (!(Test-Path -LiteralPath $KoLMafiaRoot)) {
    throw "KoLmafia root not found: $KoLMafiaRoot"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$safeLabel = New-SafeName $Label
$backupRoot = Join-Path $KoLMafiaRoot "prefs-backups"
$backupDir = Join-Path $backupRoot "$stamp-$safeLabel"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

$settings = Join-Path $KoLMafiaRoot "settings"
$data = Join-Path $KoLMafiaRoot "data"
$ccs = Join-Path $KoLMafiaRoot "ccs"

if (Test-Path -LiteralPath $settings) {
    Copy-Item -LiteralPath $settings -Destination (Join-Path $backupDir "settings") -Recurse -Force
}

if (Test-Path -LiteralPath $ccs) {
    Copy-Item -LiteralPath $ccs -Destination (Join-Path $backupDir "ccs") -Recurse -Force
}

$dataDir = Join-Path $backupDir "data"
New-Item -ItemType Directory -Force -Path $dataDir | Out-Null
foreach ($name in @("${Character}_turns.ser", "${Character}_queue.ser")) {
    $source = Join-Path $data $name
    if (Test-Path -LiteralPath $source) {
        Copy-Item -LiteralPath $source -Destination $dataDir -Force
    }
}

$prefsPath = Join-Path $settings "${Character}_prefs.txt"
$prefsBakPath = Join-Path $settings "${Character}_prefs.bak"
$globalPrefsPath = Join-Path $settings "GLOBAL_prefs.txt"

$manifest = @()
$manifest += "KoLmafia prefs backup"
$manifest += "Stamp: $stamp"
$manifest += "Label: $Label"
$manifest += "Root: $KoLMafiaRoot"
$manifest += "Character: $Character"
$manifest += ""
foreach ($path in @($prefsPath, $prefsBakPath, $globalPrefsPath)) {
    if (Test-Path -LiteralPath $path) {
        $item = Get-Item -LiteralPath $path
        $manifest += "$($item.Name): $($item.Length) bytes, modified $($item.LastWriteTime)"
        if (Test-EscapedNullPrefix $path) {
            $manifest += "WARNING: $($item.Name) begins with repeated literal \u0000 text."
        }
    } else {
        $manifest += "MISSING: $path"
    }
}

$manifestPath = Join-Path $backupDir "manifest.txt"
$manifest | Set-Content -LiteralPath $manifestPath -Encoding UTF8

Write-Output "Backup written to: $backupDir"
Write-Output "Manifest: $manifestPath"
