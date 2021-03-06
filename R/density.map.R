#' @export
#'@title Map the density estimates for a given dataset and grid or from a model stratified by region.
#'
#'
#'@description 'This function plots densities using the output of the
#'\code{\link{species.grid}} function or the predicted densities from a \code{"distanceFit"} model
#'stratified by regions using a shapefile. 
#'@param x A model of class \code{"distanceFit"} or a \code{"list"} given by the \code{\link{distance.wrap}} function or output of the \code{\link{species.grid}} function.
#'@param shp A \code{\link{SpatialPolygonsDataFrame}} that contains an id attribute that matches the stratification in the model. 
#'@param shp.lab Name of the column in the attribute table of the shapefile that fits with the stratification in the model.
#'@param by.stratum Is the model stratified by region (\code{TRUE}) or are regions splitted in different models (\code{FALSE}).
#'@param subset Name of a subset to be used to restrict predictions, either for a splitted model or for a selected stratum.
#'@param background.shp A \code{\link{SpatialPolygonsDataFrame}} to be used as a background.
#'@param background.shp.lab Name of a column in the attribute table of the shapefile to group polygons. Optional.
#'@param observations Which column of the \code{"SpatialPolygonsDataFrame"} should be used to plot abundance.
#'@param only.visits \env{TRUE} if the user want only the cells of the grid that have been visited. \env{FALSE} will plot all the cells of the grid.
#'@param Title Title for the figure. Must be a \code{\link{character}} vector.
#'@details
#'For objects of class \code{"distanceFit"} or \code{"list"}, the function return 
#'a ggplot output of predicted densities. When no information is available
#'from the model for a given stratum, the background color is pale blue. In
#'certain cases, the function will return a table of densities when no map can be
#'plotted.
#'
#'For objects of class \code{"SpatialPolygonsDataFrame"},this function will return
#'a plot with the numbers of observations per cell and a scale to help
#'visualisation. The upper limit for the scale is 19.
#'
#'See help files for \code{\link{distance.wrap}} for more examples.
#'@return
#'A plot, a ggplot or a table.
#'@examples
#'###Import a dataset
#'data(alcidae)
#'
#'###Create  a grid
#'new.grid<-create.grid(Latitude=c(45, 54), Longitude=c(-70, -56), Grid.size=c(25000, 25000), Clip=FALSE, projection=NULL)
#'
#'###Calculate the density of alcidae for the grid
#'alcidae.grid<-species.grid(alcidae, Grid.shp=new.grid, Selection="Alpha",
#'                      Code=c("ALCI"), Density="Count",Latitude="LatStart",Longitude="LongStart",
#'                      Cell.id="CELL.NUM", Factors=F)
#'
#'###Plot a map with only the cells that have been visited
#'density.map(x=alcidae.grid, observations="Count", only.visits=TRUE, background.shp=NULL)
#'
#'###Plot a map with all the cells
#'density.map(x=alcidae.grid, observations="Count", only.visits=FALSE, background.shp=NULL)
#'
#'###Add a background with gulf zones
#'require(plyr)
#'require(sp)
#'data(zonegulf)
#'x<-dlply(zonegulf,.(group),function(i){Polygon(i[c(nrow(i),1:nrow(i)),1:2],hole=i$hole[1])})
#'x<-sapply(unique(zonegulf$id),function(i){
#'	temp<-x[names(x)%in%zonegulf$group[which(zonegulf$id==i)]]
#'	Polygons(temp,ID=i)
#'})
#'x<-SpatialPolygons(x,proj4string=CRS("+proj=longlat +datum=NAD83 +ellps=GRS80"))
#'zonegulf<-SpatialPolygonsDataFrame(x,data=data.frame(id=zonegulf$id[match(names(x),zonegulf$id)]),match.ID=FALSE)
#'density.map(x=alcidae.grid, observations="Count", only.visits=FALSE, background.shp=zonegulf)
#'
#'###Use the density.map function to visualize effort in each grid cell.
#'density.map(x=alcidae.grid, observations="EFFORT", only.visits=FALSE, background.shp=NULL, Title="Number of time a cell has been visited")
#'
#'###See examples for the distance.wrap function for other examples
#'
#'###END

density.map <-
function (x, ...) {
	UseMethod("density.map", x)
}
