$ErrorActionPreference='Stop'
$rootPath=(Resolve-Path "$PSScriptRoot/../../../..").Path
$proofPath=Join-Path $PSScriptRoot 'proof'
$word=New-Object -ComObject Word.Application
$word.Visible=$false
$word.DisplayAlerts=0
$bookmarks=@()
try {
 foreach($name in @('Table1','Table2','Table3','Manuscript','Supplement','TRIPOD-LLM')) {
  $path=Join-Path $rootPath "analysis/output/manuscript/$name.docx"
  $doc=$word.Documents.Open($path,$false,$false)
  $doc.Fields.Update() | Out-Null
  foreach($toc in $doc.TablesOfContents) {$toc.Update()}
  $doc.Repaginate()
  foreach($toc in $doc.TablesOfContents) {$toc.UpdatePageNumbers()}
  $doc.Save()
  $doc.ExportAsFixedFormat((Join-Path $proofPath "$name.pdf"),17)
  foreach($mark in $doc.Bookmarks) {
   $bookmarks += [pscustomobject]@{document=$name;bookmark=$mark.Name;page=$mark.Range.Information(3);text=$mark.Range.Text.Trim()}
  }
  Write-Output "$name rendered: $($doc.ComputeStatistics(2)) pages"
  $doc.Close(0)
  Copy-Item -LiteralPath $path -Destination (Join-Path $proofPath "$name.docx")
 }
 $bookmarks | Export-Csv -NoTypeInformation -Encoding utf8 (Join-Path $proofPath 'bookmarks.csv')
} finally {$word.Quit()}
