% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\name{BlueprintEncodeData}
\alias{BlueprintEncodeData}
\title{Obtain human bulk RNA-seq data from Blueprint and ENCODE}
\usage{
BlueprintEncodeData(rm.NA = c("rows", "cols", "both", "none"))
}
\arguments{
\item{rm.NA}{String specifying how missing values should be handled.
\code{"rows"} will remove genes with at least one missing value, 
\code{"cols"} will remove samples with at least one missing value,
\code{"both"} will remove any gene or sample with at least one missing value,
and \code{"none"} will not perform any removal.}
}
\value{
A \linkS4class{SummarizedExperiment} object with a \code{"logcounts"} assay
containing the log-normalized expression values, along with cell type labels in the 
\code{\link{colData}}.
}
\description{
Download and cache the normalized expression values of 259 RNA-seq samples of
pure stroma and immune cells as generated and supplied by Blueprint and ENCODE.
}
\details{
This function provides normalized expression values of 259 bulk RNA-seq samples
generated by Blueprint and ENCODE from pure populations of stroma and immune 
cells (Martens and Stunnenberg, 2013; The ENCODE Consortium, 2012).

 Blueprint Epigenomics: 144 RNA-seq pure immune samples annotated to 28 cell types.
 ENCODE: 115 RNA-seq pure stroma and immune samples annotated to 17 cell types.
 Altogether, 259 samples with 43 cell types.

The samples were processed and normalized as described in Aran, Looney and
Liu et al. (2019); i.e. the raw RNA-seq counts were downloaded from Blueprint
and ENCODE in 2016 and normalized via edgeR (TPMs).

The data will be downloaded from ExperimentHub,
returning a \linkS4class{SummarizedExperiment} object for further use.
}
\examples{
ref.se <- BlueprintEncodeData(rm.NA = "rows")

}
\references{
The ENCODE Project Consortium (2012).
An integrated encyclopedia of DNA elements in the human genome.
\emph{Nature} 489, pages 57–74.

Martens JHA and Stunnenberg HG (2013). 
BLUEPRINT: mapping human blood cell epigenomes.
\emph{Haematologica} 98, 1487–1489.

Aran D, Looney AP, Liu L et al. (2019). 
Reference-based analysis of lung single-cell sequencing reveals a transitional profibrotic macrophage.
\emph{Nat. Immunol.} 20, 163–172.
}
\author{
Friederike Dündar
}
