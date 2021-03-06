df <- data.frame(
    Title = sprintf("DMAP RNA-seq %s", c("logcounts", "colData")), # This can be the exact file name (if self-describing) or a more complete description.
    Description = sprintf("%s 114 RNA-seq samples of immune cells from GSE107011", 
        c("Matrix of log-normalized expression values from", "Per-sample metadata containing cell type labels of")),
    RDataPath = file.path("SingleR", "monaco_immune","1.0.0", c("logcounts.rds", "coldata.rds")),
    BiocVersion="3.10", # The first Bioconductor version the resource was made available for.
    Genome=NA, # Can be NA.
    SourceType="RDA", #  Format of original data, e.g., FASTA, BAM, BigWig, etc. ‘getValidSourceTypes()’ for currently acceptable values
    SourceUrl="https://www.dropbox.com/sh/z6uig95fm37whus/AAAGMA7VtNh_BblJppmakZ98a?dl=0",
    SourceVersion="monaco_immune.rda",
    Species="Homo sapiens", # getSpeciesList, validSpecies, or suggestSpecies(); can be NA
    TaxonomyId="9606",
    Coordinate_1_based=NA, #TRUE, FALSE, NA
    DataProvider="GEO",
    Maintainer="Jared Andrews <jared.andrews@wustl.edu>",
    RDataClass="character", # R / Bioconductor class the data are stored in, e.g., GRanges, SummarizedExperiment, ExpressionSet etc.
    DispatchClass="Rds", # Determines how data are loaded into R.
    stringsAsFactors = FALSE
)

write.csv(file="../extdata/metadata-monaco_immune.csv", df, row.names=FALSE)
