# Install asar 1.91 (prebuilt release) into tools\bin and check prerequisites. Windows PowerShell 5+ / pwsh.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$bin = Join-Path $root 'tools\bin'; New-Item -ItemType Directory -Force -Path $bin | Out-Null
$exe = Join-Path $bin 'asar.exe'
$ok = (Test-Path $exe) -and ((& $exe --version 2>$null | Select-Object -First 1) -match 'Asar 1\.91')
if (-not $ok) {
  $zip = Join-Path $env:TEMP 'asar191.zip'; $dir = Join-Path $env:TEMP 'asar191'
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -UseBasicParsing 'https://github.com/RPGHacker/asar/releases/download/v1.91/asar191.zip' -OutFile $zip
  if (Test-Path $dir) { Remove-Item -Recurse -Force $dir }
  Expand-Archive $zip -DestinationPath $dir
  Copy-Item (Get-ChildItem -Recurse $dir -Filter asar.exe | Select-Object -First 1).FullName $exe
}
$v = & $exe --version | Select-Object -First 1
if ($v -notmatch 'Asar 1\.91') { throw "asar version check FAILED: $v" }
Write-Host "asar: $v"
if (Get-Command python -ErrorAction SilentlyContinue) { Write-Host "python: $(python --version)" } else { Write-Host 'WARNING: python not found (only needed for tools/disasm65816.py)' }
Write-Host 'setup OK. Next: .\build.ps1'
