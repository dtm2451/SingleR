write.csv(file="../extdata/metadata-mouse.rnaseq.csv", 
          data.frame(
              Title = sprintf("Mouse bulk RNA-seq %s", c("normcounts", "colData")), # This can be the exact file name (if self-describing) or a more complete description.
              Description = sprintf("%s 358 bulk RNA-seq samples of sorted cell types collected from GEO", 
                                    c("Matrix of normalized expression values from", "Per-sample metadata containing the cell type labels of")),
              RDataPath = file.path("SingleR", "mouse.rnaseq","1.0.0"), 
              c("normcounts.rds", "coldata.rds"),
              BiocVersion="3.10", # The first Bioconductor version the resource was made available for.
              Genome=NA, # Can be NA.
              SourceType="RDA", #  Format of original data, e.g., FASTA, BAM, BigWig, etc. ‘getValidSourceTypes()’ for currently acceptable values
              SourceUrl=c(
                  "https://github.com/dviraran/SingleR/tree/master/data",
                  "https://github.com/dviraran/SingleR/tree/master/data"
              ),
              SourceVersion=c(
                  "mouse.rnaseq.rda",
                  "mouse.rnaseq.rda"),
              Species="Mus musculus", # getSpeciesList, validSpecies, or suggestSpecies(); can be NA
              TaxonomyId="10090",
              Coordinate_1_based=NA, #TRUE, FALSE, NA
              DataProvider="Benayoun Lab",
              Maintainer="Friederike Duendar <frd2007@med.cornell.edu>",
              RDataClass="character", # R / Bioconductor class the data are stored in, e.g., GRanges, SummarizedExperiment, ExpressionSet etc.
              DispatchClass="Rds", # Determines how data are loaded into R.
              stringsAsFactors = FALSE
          ),
          row.names=FALSE)