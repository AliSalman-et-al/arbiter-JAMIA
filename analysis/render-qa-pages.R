qa <- normalizePath('output/manuscript/qa',winslash='/')
stopifnot(endsWith(qa,'/analysis/output/manuscript/qa'))
# Only this script's prior previews are removed, avoiding stale pages after repagination.
unlink(list.files(qa,pattern='(-word-[0-9]+[.]png|Supplement-contact-[0-9]+[.]png)$',full.names=TRUE))
for(p in list.files(qa,pattern='word[.]pdf$',full.names=TRUE)) {
  cat(basename(p),pdftools::pdf_info(p)$pages,'pages\n')
  pdftools::pdf_convert(p,format='png',dpi=110,filenames=sub('[.]pdf$','-%02d.%s',p),verbose=FALSE)
}
pages <- list.files(qa,pattern='Supplement-word-[0-9]+[.]png$',full.names=TRUE)
for(i in seq(1,length(pages),by=4)) {
  imgs <- magick::image_read(pages[i:min(i+3,length(pages))]) |> magick::image_resize('650x')
  magick::image_write(magick::image_montage(imgs,tile='2x2',geometry='+4+4'),
    file.path(qa,sprintf('Supplement-contact-%02d.png',i)),format='png')
}
