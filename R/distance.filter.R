#' @export
#'@title Filter data before using it with distance.wrap
#'
#'
#'@description Allow to change the names of the column of a data.frame so that it work seamlessly with \code{\link{distance.wrap}}
#'@param x  A \code{\link{data.frame}} containing observations.
#'@param transect.id Name of the column containing the unique ID of each transect.
#'@param distance.field Name of the column containing the distance classes of each observations. 
#'@param distance.labels Classes of distance to keep for the analysis.
#'@param distance.midpoints Midpoints in (m) of the classes of distance kept for the analysis.
#'@param effort.field Name of the column containing the length of the transect/watch.
#'@param lat.field Name of the column containing the latitude of the observations.
#'@param long.field Name of the column containing the longitude of the observations.
#'@param sp.field Name of the column containing the species ID.
#'@param date.field Name of the column containing the date for the observations.
#'@param distanceLabels.field Name of the column containing the distance classes for filtering.
#'@param dist2m Boolean to indicate if the conversion from classes to numeric should be performed.
#'@details
#'When "WatchLenKm" = 0, observations are eliminated. Transects for which "Alpha" = "" (no species names) 
#'will be kept because they are transects that were done but where no observations were recorded.
#'Observations for which there is no distance or coordinates will be eliminated. 
#'The "Date" column will be transformed in the yyyy-mm-dd format.
#'@section Author:Christian Roy
#'@examples
#'data(quebec)
#'x<-distance.filter(quebec, transect.id = "WatchID", distance.field = "Distance", distance.labels = c("A", "B", "C", "D"), 
#'                   distance.midpoints = c(25, 75, 150, 250), effort.field = "WatchLenKm", lat.field = "LatStart", 
#'                   long.field = "LongStart", sp.field = "Alpha", date.field = "Date")
#'str(x)

distance.filter <-
function(x, transect.id="WatchID",distance.field="Distance", distance.labels=c("A","B","C","D"),
                           distance.midpoints=c(25,75,150,250),effort.field="WatchLenKm",
                           lat.field="LatStart", long.field="LongStart", sp.field="Alpha", date.field="Date", distanceLabel.field = "Distance",
                           dist2m = TRUE){

                          #Warning
                          if(length(distance.midpoints)!=length(distance.labels))
                          stop("Distance class labels and distance class mipdoints must be of equal length")
                              
                          #Changes names to fit the output
                          names(x)[which(names(x)==transect.id)] <- "WatchID" 
                          names(x)[which(names(x)==distance.field)] <- "Distance"
                          names(x)[which(names(x)==effort.field)] <- "WatchLenKm"
                          names(x)[which(names(x)==sp.field)] <- "Alpha"
                          names(x)[which(names(x)==date.field)] <- "Date"
                          names(x)[which(names(x)==lat.field)] <- "LatStart"
                          names(x)[which(names(x)==long.field)] <- "LongStart"
                          
                          #Put df into form
                          x<-x[x[,"WatchLenKm"]>0,] 
                          x<-x[!is.na(x[,"LatStart"]),]
                          x<-x[!is.na(x[,"LongStart"]),]
                          x<-x[!(x[,"Distance"] %in% "" & !x[,"Alpha"] %in% ""),] #eliminates observations recorded without a distance
                          x[,"Distance"]<-ifelse(x[,"Distance"] %in% "",NA,as.character(x[,"Distance"]))    #writes NA when there is no distance, when nothing in the transect
                          x<-x[x[, distanceLabel.field]%in%c(distance.labels,NA),]
                          y<-x
                        	y[,"Distance"]<-NA
                        	x[,"Distance"]<-as.character(x[,"Distance"])
                          
                        	if (dist2m) {
                            for(i in 1:length(distance.labels)){
                              x[,"Distance"]<-ifelse(x[,"Distance"]==distance.labels[i],distance.midpoints[i],x[,"Distance"])
                            }
                        	}
                          
                         	x<-x[(!is.na(x$InTransect) & x$InTransect != 0) | x[,"Alpha"] %in% c(NA, ""),] #keep observations that are in the transect or empty transects/WatchID
                        	y<-y[!y[,"WatchID"]%in%x[,"WatchID"],] #keep only WatchID that are not already in x
                        	# Do not perform unnecessary lengthy rbind
                        	if (nrow(y) > 0) {
                        	  x<-rbind(x,unique(y)) #add empty transects with outside distances to the main data.frame
                        	}
                        	date<-sapply(strsplit(sapply(strsplit(as.character(x[,"Date"])," "),function(i){i[1]}),"/"),function(j){
                        		res<-rev(j)
                        		paste(c(res[1],formatC(as.numeric(res[2:3]),width=2,flag="0")),collapse="-")
                        	})
                        	x[,"Date"]<-date
                        	
                        	#make sure some entries are numeric
                          x[,"LatStart"] <- as.numeric(x[,"LatStart"])
                          x[,"LongStart"] <- as.numeric(x[,"LongStart"])
                          x[,"WatchLenKm"] <- as.numeric(x[,"WatchLenKm"])
                          #make sure some Alpha is a factor
                          
                          
                          #Warning
                          if((min(x[,"LatStart"])<0 & 0<max(x[,"LatStart"])) | (max(x[,"LatStart"])<0 & 0<min(x[,"LatStart"]))==T)                          
                          print("Warning dataset include data north and south of the Equator")
                          
                          if((min(x[,"LongStart"])<0 & 0<max(x[,"LongStart"])) | (max(x[,"LongStart"])<0 & 0<min(x[,"LongStart"]))==T)  
                          print("Warning dataset include data east and west of the Prime Meridian")
                          
                          return(x)
                          #End of function
                          }
