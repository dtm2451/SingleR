#' @importFrom SummarizedExperiment assay
#' @importFrom DelayedMatrixStats rowAnyNAs
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @importFrom DelayedArray DelayedArray
.to_clean_matrix <- function(x, assay.type, check.missing, msg="x") {
    if (is.null(rownames(x))) {
        stop(sprintf("'%s' must have row names", msg))
    }
    if (is(x, "SummarizedExperiment")) {
        x <- assay(x, i=assay.type)
    }

    # Stripping out genes with NA's from 'x'.
    if (check.missing) {
        discard <- rowAnyNAs(DelayedArray(x))
        if (any(discard)) {
            warning(sprintf("'%s' contains rows with missing values", msg))
            x <- x[!discard,,drop=FALSE]
        }
    }

    x
}
