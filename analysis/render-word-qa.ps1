# Dedicated hidden Word instance; read-only opens; never saves source documents.
$ErrorActionPreference = 'Stop'
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
  Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'output/manuscript') -Filter '*.docx' | ForEach-Object {
    $source = $_.FullName
    $target = Join-Path $_.DirectoryName ('qa/' + $_.BaseName + '-word.pdf')
    $doc = $word.Documents.Open($source,$false,$true)
    try { $doc.ExportAsFixedFormat($target,17); Write-Output $target }
    finally { $doc.Close(0); [void][Runtime.InteropServices.Marshal]::ReleaseComObject($doc) }
  }
}
finally { $word.Quit(); [void][Runtime.InteropServices.Marshal]::ReleaseComObject($word) }
