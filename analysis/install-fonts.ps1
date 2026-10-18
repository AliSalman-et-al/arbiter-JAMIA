# The repository vendors OFL fonts, so reruns do not depend on a mutable download.
$ErrorActionPreference = 'Stop'
$fontRoot = Join-Path $env:LOCALAPPDATA 'Microsoft/Windows/Fonts'
New-Item -ItemType Directory -Force -Path $fontRoot | Out-Null
$fontKey = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
New-Item -Path $fontKey -Force | Out-Null
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class ArbiterFonts {
 [DllImport("gdi32.dll", CharSet=CharSet.Unicode)] public static extern int AddFontResourceEx(string path, uint flags, IntPtr reserved);
}
'@
Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'assets/fonts') -Filter '*.ttf' | ForEach-Object {
  $fontTarget = Join-Path $fontRoot $_.Name
  Copy-Item -LiteralPath $_.FullName -Destination $fontTarget -Force
  New-ItemProperty -Path $fontKey -Name ($_.BaseName + ' (TrueType)') -Value $fontTarget -PropertyType String -Force | Out-Null
  [ArbiterFonts]::AddFontResourceEx($fontTarget,0,[IntPtr]::Zero) | Out-Null
}
# Fontconfig (Cairo) discovers per-user fonts in a fresh R process.
Write-Output 'Installed the vendored Fira Sans fonts for this user.'
