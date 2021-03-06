#' Plot SingleR scores on a per-label or per-cell basis.
#'
#' @param results A \linkS4class{DataFrame} containing the output from \code{\link{SingleR}} or \code{\link{classifySingleR}}.
#' @param cell.id Integer specifying which cell to show for \code{plotScoresSingleCell}
#' @param labels.use String vector indicating what labels to show in \code{plotScoresSingleCell} and \code{plotScoresMultiLabel}
#' If \code{labels.use} is left \code{NULL}, all labels available in \code{results} are presented.
#' @param label String indicating which individual label to plot in \code{plotScoresSingleLabel}
#' This input will be unnecessary once \code{\link{pruneScores}}'s output is added to the results DataFrame
#' @param dots.on.top Logical which sets whether cell dots are plotted on top of, versus behind, the violin plots in \code{plotScoresSingleLabel} and \code{plotScoresMultiLabel}
#' @param colors String vector that sets the colors.
#' Order of colors should be: `this label`, `this label - pruned`, `other label`/`any label`.
#' Name differently to update the legend.
#' @param size Scalar, the size of the dots
#' @param ncol Integer number of labels to display per row
#' @name plotScoresByCellOrLabel
#' 
#' @return Each function returns a \link[ggplot2]{ggplot} object showing SingleR scores in a dot and/or violin plot representation.
#' 
#' @details
#' The \code{plotScoresSingleCell} function creates a dot plot showing the scores of a single cell across many labels.
#' The score for the final label of an individual cell is marked in yellow, with a dotted line indicating the median score across all labels.
#' This function may be useful for visualizing and tuning the \code{min.diff.med} per-cell cutoff of the \code{\link{pruneScores}} function.
#' 
#' The \code{plotScoresSingleLabel} and \code{plotScoresMultiLabel} functions create jitter and violin plots showing
#' the scores of all cells across a single label or multiple labels, respectively.
#' For a given label X, cells in several categories are shown:
#' \itemize{
#' \item Was assigned to label X, and the label was not pruned away.
#' \item Was assigned to label X, and the label was pruned away.
#' \item Was assigned as any label (including label X).
#' }
#' Each category is grouped and colored separately.
#' These functions can be used to assess the distribution of scores of all cells for individual labels,
#' and may be useful for visualizing and tuning the \code{nmads} per-label cutoff of the \code{\link{pruneScores}} function.
#' 
#' Note that these functions show initial scores only, i.e., prior to fine tuning.
#' However, the labels may be defined after fine-tuning in \code{\link{SingleR}} or \code{\link{classifySingleR}}.
#' Thus, the best score for an individual cell may not be its final label.
#'
#' @seealso
#' \code{\link{SingleR}}, to generate scores.
#'
#' \code{\link{pruneScores}}, to remove low-quality labels based on the scores.
#' 
#' @author Daniel Bunis
#' @examples
#' example(SingleR, echo=FALSE)
#' 
#' plotScoresSingleCell(results = pred, cell.id = 1)
#' plotScoresSingleLabel(results = pred, label = "B",
#'     dots.on.top = TRUE)
#' plotScoresMultiLabels(results = pred,
#'     dots.on.top = TRUE, size = 0.5)
#' 
NULL

#' @export
#' @rdname plotScoresByCellOrLabel 
#' @importFrom stats median
plotScoresSingleCell <- function(results, cell.id,
    labels.use = levels(as.factor(results$labels)), size = 2,
    colors = c("#F0E442", "#56B4E9", "gray30")){

    if (length(colors)<3) {
        stop("3 colors are expected.")
    }
    if (is.null(names(colors))) {
        names(colors) <- 
            c('this label', 'this label - pruned',
            'other label')
    }

    # Add rownames to the results, which will be used for trimming scores data
    #   to the target cell later on
    if (is.null(rownames(results))) {
        rownames(results) <- seq_len(nrow(results))
    }

    # Gather the scores data for all cells and labels
    df <- .scores_data_gather(results, dup.this.label = FALSE)
    # Trim to just the data for the target cell
    df <- df[df$id == rownames(results)[cell.id],]
    # Calculate the cell's median score based on all labels
    scores.median <- median(df$score)
    # Trim to just the data for the target labels
    df <- df[df$label %in% labels.use,]
  
    #Change "any label" to be "other label"
    df$cell.calls[df$cell.calls == "any label"] <- "other label"

    ggplot2::ggplot(
            data = df,
            ggplot2::aes_string(x = "label", y = "score", fill = "cell.calls")) +
        ggplot2::theme_classic() +
        ggplot2::theme(axis.text.x= ggplot2::element_text(
            angle=60, hjust = 1, vjust = 1, size=12)) +
        ggplot2::xlab(NULL) +
        ggplot2::geom_hline(yintercept = scores.median, color = "gray",
            linetype = "dashed") +
        ggplot2::geom_point(color = "black", shape = 21, size = size, alpha = 1) +
        ggplot2::scale_fill_manual(name = "Cell Calls", values = colors)
}

#' @export
#' @rdname plotScoresByCellOrLabel 
plotScoresSingleLabel <- function(results, label, size = 0.5, dots.on.top = FALSE,
    colors = c("#F0E442", "#56B4E9", "gray30")){

    if (length(colors)<3) {
        stop("3 colors are expected.")
    }
    if (is.null(names(colors))) {
        names(colors) <- 
            c('this label', 'this label - pruned',
            'any label')
    }

    # Get the scores data for all cells for the target label
    df <- .scores_data_gather(results, label)

    p <- ggplot2::ggplot(
            data = df,
            ggplot2::aes_string(x = "cell.calls", y = "score", fill = "cell.calls")) + 
        ggplot2::theme_classic() +
        ggplot2::scale_fill_manual(name = "Cell Calls", values = colors) + 
        # Remove x-axis labels for the groupings (already in the legend),
        #   but do show the name of the target `label` as the axis title.
        ggplot2::scale_x_discrete(name = label, labels = NULL)

    if (dots.on.top) {
        p <- p+ ggplot2::geom_violin()
    }
    p <- p + ggplot2::geom_jitter(
        height = 0, width = 0.3, color = "black", shape = 16,size = size)
    if (!dots.on.top) {
        p <- p + ggplot2::geom_violin()
    }
    
    p
}

#' @export
#' @rdname plotScoresByCellOrLabel 
plotScoresMultiLabels <- function(results, size = 0.2, dots.on.top = FALSE,
    labels.use = levels(as.factor(results$labels)), ncol = 5,
    colors = c("#F0E442", "#56B4E9", "gray30")){

    if (length(colors)<3) {
        stop("3 colors are expected.")
    }
    if (is.null(names(colors))) {
        names(colors) <- 
            c('this label', 'this label - pruned',
            'any label')
    }

    # Gathere the scores data in a dataframe
    df <- .scores_data_gather(results, labels.use)
    
    # Make the plot
    p <- ggplot2::ggplot(
            data = df,
            ggplot2::aes_string(x = "cell.calls", y = "score", fill = "cell.calls")) + 
        ggplot2::theme_classic() +
        ggplot2::scale_fill_manual(name = "Cell Calls", values = colors) + 
        ggplot2::scale_x_discrete(name = "Labels", labels = NULL) +
        # Separate data by labels, with `ncol` # of columns.
        ggplot2::facet_wrap(facets = ~label, ncol = ncol)
    if (dots.on.top) {
        p <- p+ ggplot2::geom_violin()
    }
    p <- p + ggplot2::geom_jitter(
        height = 0, width = 0.3, color = "black", shape = 16,size = size)
    if (!dots.on.top) {
        p <- p + ggplot2::geom_violin()
    }
    
    p
}

.scores_data_gather <- function(
    results, labels.use = levels(as.factor(results$labels)), dup.this.label = TRUE)
{
    if (is.null(rownames(results))) {
        rownames(results) <- seq_len(nrow(results))
    }
    #Ensure labels.use are subsets of the labels in results.
    labels.use <- labels.use[labels.use %in% colnames(results$scores)]
    
    scores <- results$scores[,colnames(results$scores) %in% labels.use]
    
    # Create a dataframe with separate rows for each score in scores.
    df <- data.frame(
        #cell id of the cell
        id = rep(rownames(results), each=length(labels.use)),
        #final call of the cell
        called = rep(results$labels, each=length(labels.use)),
        #label of the current score
        label = rep(
            colnames(results$scores)[colnames(results$scores) %in% labels.use],
            nrow(results)),
        score = as.numeric(t(scores)),
        stringsAsFactors = FALSE)
    
    # Add whether this label is the final label given to each cell.
    df$cell.calls <- "any label"
    df$cell.calls[df$label == df$called] <- "this label"
    
    if (!is.null(results$pruned.labels)){
        # Retrieve if cells' calls were scored as to be prunes versus not,
        #  then add this to df$cell.calls, but only when =="this label"
        prune.calls <- is.na(results$pruned.labels)
        prune.string <- as.character(factor(
            prune.calls,
            labels = c(""," - pruned")))
        df$cell.calls[df$cell.calls=="this label"] <- paste0(
            df$cell.calls[df$cell.calls=="this label"],
            rep(prune.string, each=length(labels.use))[df$cell.calls=="this label"])
        # Reorder levels of cell.calls (for proper coloring in plot functions).
        df$cell.calls <- factor(
            df$cell.calls,
            levels = c(
                'this label', 'this label - pruned',
                'any label'))
    }
    
    #Duplicate the "this label" data, but changed df.cell.calls to "any label"
    dup.me <- df[df$cell.calls %in% c("this label", "this label - pruned"),,drop=FALSE]
    dup.me$cell.calls <- 'any label'
    df <- rbind(dup.me, df)
    
    df
}
