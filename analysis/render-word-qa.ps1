# Dedicated hidden Word instance; read-only opens; never saves source documents.
$ErrorActionPreference = 'Stop'
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
  # A native foreach loop avoids COM calls from a pipeline callback.
  $documentsQa = Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'output/manuscript') -Filter '*.docx' | Sort-Object { if ($_.BaseName -eq 'Supplement') { 1 } else { 0 } }, Name
  foreach ($fileQa in $documentsQa) {
    $sourceQa = $fileQa.FullName
    $targetQa = Join-Path $fileQa.DirectoryName ('qa/' + $fileQa.BaseName + '-word.pdf')
    Write-Output ('Opening ' + $fileQa.Name)
    $docQa = $word.Documents.Open($sourceQa,$false,$true)
    try { Write-Output ('Exporting ' + $fileQa.Name); $docQa.ExportAsFixedFormat($targetQa,17); Write-Output $targetQa }
    finally { $docQa.Close(0); [void][Runtime.InteropServices.Marshal]::ReleaseComObject($docQa) }
  }
}
finally { $word.Quit(); [void][Runtime.InteropServices.Marshal]::ReleaseComObject($word) }
