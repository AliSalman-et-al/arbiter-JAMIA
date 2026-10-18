# Run after clean Quarto render; includes the merged Figure 1.
source('R/presentation.R')
dir.create('output/manuscript/qa',recursive=TRUE,showWarnings=FALSE)
for(name in c(paste0('Figure',3:6),'eFigure1','eFigure2')) {
  src <- magick::image_read(paste0('output/manuscript/',name,'.png'))
  magick::image_write(magick::image_convert(src,colorspace='gray'),
    paste0('output/manuscript/qa/',name,'-greyscale.png'))
  # Quantise before CVD mapping; text and positional encodings remain unchanged.
  src <- magick::image_quantize(src,max=256)
  pixels <- as.raster(src)
  flat <- as.vector(unclass(pixels))
  colors <- unique(flat)
  for(kind in c('protan','deutan','tritan')) {
    sim <- getExportedValue('colorspace',kind)(colors,severity=1)
    simulated <- matrix(sim[match(flat,colors)],nrow=nrow(pixels),ncol=ncol(pixels))
    class(simulated) <- 'raster' # raster storage order must not be transposed by as.raster.matrix
    magick::image_write(magick::image_read(simulated),
      paste0('output/manuscript/qa/',name,'-',kind,'.png'),format='png')
  }
  # Inspect the actual PDF rendition, not just the original plotting device.
  pdftools::pdf_convert(paste0('output/manuscript/',name,'.pdf'),format='png',dpi=160,
    filenames=paste0('output/manuscript/qa/',name,'-pdf-%d.%s'),verbose=FALSE)
  sims <- magick::image_read(paste0('output/manuscript/qa/',name,
    c('-greyscale','-protan','-deutan','-tritan'),'.png'))
  sims <- magick::image_resize(sims,'600x')
  magick::image_write(magick::image_montage(sims,tile='2x2',geometry='+4+4'),
    paste0('output/manuscript/qa/',name,'-accessibility.png'),format='png')
}
writeLines(trimws(capture.output(sessionInfo()),which='right'),'output/manuscript/qa/session-info.txt')
