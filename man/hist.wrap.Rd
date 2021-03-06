% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hist.wrap.R
\name{hist.wrap}
\alias{hist.wrap}
\title{Plot a detection histogram of apparent density.}
\usage{
\method{hist}{wrap}(Dataset, Count, Dist.class, Keep.class, Breaks,
  color = "white", rescale = 1)
}
\arguments{
\item{Dataset}{A \code{\link{data.frame}} containing observations.}

\item{Count}{which column in the data.frame hold the information for the cluster size.}

\item{Dist.class}{which column in the data.frame hold the information for the distance class.}

\item{Keep.class}{which class of observations should be used for the analysis.}

\item{Breaks}{what are the intervals for the distance analysis.}

\item{color}{fill color for the bars}

\item{rescale}{set the height of the first bin}
}
\description{
This function will allow the user to visualise the histogram of observations in function of distance class and re-bin his observations if necessary before the analysis.
}
\details{
Make a histogram of the observations in function of the distance class
}
\section{Author}{
Christian Roy
}
\examples{
###Import the data
data(alcidae)

###Check the naïve detection histogram
hist.wrap(alcidae, Count="Count", Dist.class="Distance", Keep.class=c("A", "B", "C", "D"), Breaks=c(0,50,100,200,300), color="white")
#END
}

