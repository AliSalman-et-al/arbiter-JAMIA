$ErrorActionPreference = 'Stop'
$workspacePath = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$qaPath = Join-Path $PSScriptRoot 'rendered'
New-Item -ItemType Directory -Force -Path $qaPath | Out-Null
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
    foreach ($name in @('Table1','Table2','Table3','Manuscript','Supplement','TRIPOD-LLM')) {
        $sourcePath = (Resolve-Path (Join-Path $workspacePath "analysis/output/manuscript/$name.docx")).Path
        $doc = $word.Documents.Open($sourcePath,$false,$true)
        $doc.ExportAsFixedFormat((Join-Path $qaPath "$name.pdf"),17)
        Write-Output "$name rendered: $($doc.ComputeStatistics(2)) pages"
        $doc.Close(0)
    }
} finally {
    $word.Quit()
}
