#'
#' @title Get POWER data for an APSIM met file
#' @name get_power_apsim_met
#' @param lonlat Longitude and latitude vector
#' @param dates date ranges
#' @param wrt.dir write directory
#' @param filename file name for writing out to disk
#' @details This requires the nasapower package
#' @export
#' @examples 
#' \dontrun{
#' require(nasapower)
#' ## This will not write a file to disk
#' pwr <- get_power_apsim_met(lonlat = c(-93,42), dates = c("2017-01-01","2017-12-31"))
#' }
#' 
#'
#'

get_power_apsim_met <- function(lonlat, dates, wrt.dir=".", filename=NULL){
  
  if(!requireNamespace("nasapower",quietly = TRUE)){
    warning("nasapower is required for this function")
    return(NULL)
  }
  
  if(missing(filename)) filename <- "noname.met"
   
  if(!grepl(".met", filename, fixed=TRUE)) stop("filename should end in .met")
  
  pwr <- get_power(community = "AG",
                    pars = c("T2M_MAX",
                             "T2M_MIN",
                             "ALLSKY_SFC_SW_DWN",
                             "PRECTOT",
                             "RH2M",
                             "WS2M"),
                    dates = dates,
                    lonlat = lonlat,
                    temporal_average = "DAILY")
  
  pwr <- subset(as.data.frame(pwr), select = c("YEAR","DOY","T2M_MAX","T2M_MIN",
                                                "ALLSKY_SFC_SW_DWN","PRECTOT",
                                                "RH2M","WS2M"))
  
  names(pwr) <- c("year","day","maxt","mint","radn","rain","rh","wind_speed")
  units <- c("()","()","(oC)","(oC)","(MJ/m2/day)","(mm)","(%)","(m/s)")
  
  comments <- paste("!data from nasapower R pacakge. retrieved: ",Sys.time())
    
  attr(pwr, "filename") <- filename
  attr(pwr, "site") <- sub(".met","", filename, fixed = TRUE)
  attr(pwr, "latitude") <- paste("latitude =",lonlat[2])
  attr(pwr, "longitude") <- paste("longitude =",lonlat[1])
  attr(pwr, "tav") <- paste("tav =",mean(colMeans(pwr[,c("maxt","mint")],na.rm=TRUE),na.rm=TRUE))
  attr(pwr, "amp") <- paste("amp =",mean(pwr$maxt, na.rm=TRUE) - mean(pwr$mint, na.rm = TRUE))
  attr(pwr, "colnames") <- names(pwr)
  attr(pwr, "units") <- units
  attr(pwr, "comments") <- comments
  ## No constants
  class(pwr) <- c("met","data.frame")
  
  if(filename != "noname.met"){
    write_apsim_met(pwr, wrt.dir = wrt.dir, filename = filename, overwrite = TRUE)
  }
  return(invisible(pwr))
}