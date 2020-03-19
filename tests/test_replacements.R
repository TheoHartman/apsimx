## Testing replacements examples with APSIM-X
## Run a few tests for the examples
require(apsimx)
apsimx_options(warn.versions = FALSE)

run.replacements.tests <- TRUE

extd.dir <- system.file("extdata", package = "apsimx")

replacements <- c("MaizeSoybean.apsimx","WheatRye.apsimx","Soybean.apsimx")

if(run.replacements.tests){
  start <- Sys.time()
  for(i in replacements){
    rep.tst <- apsimx(i, src.dir = extd.dir, cleanup = TRUE)
    cat("Ran: ", i, "\n")
  }
  end <- Sys.time()
  cat("Total time:", end - start, "\n")
  cat("APSIM-X version:", apsim_version(which = "inuse"),"\n")
}