# This tests that pruneScores works as expected.
# library(testthat); library(SingleR); source("test-prune.R")

test_that("validating per-cell check without finetuning", {
    scores <- rbind(
        c(0,0,0,0,1),
        c(0,0,0,1,1),
        c(0,0,1,1,1),
        c(0,1,1,1,1),
        c(1,1,1,1,1)
    )
    colnames(scores) <- LETTERS[1:5]
    
    results <- DataFrame(scores=I(scores))
    expect_identical(pruneScores(results), c(FALSE, FALSE, TRUE, TRUE, TRUE))
    expect_identical(pruneScores(results, min.diff.med=2), !logical(5))
})

test_that("validating per-cell check with finetuning", {
    scores <- diag(5)
    colnames(scores) <- LETTERS[1:5]

    fine.tune <- DataFrame(
        first=1:5/5,
        second=1:5/10
    )
    results <- DataFrame(scores=I(scores), tuning.scores=I(fine.tune))

    expect_identical(pruneScores(results, min.diff.next=0.2), fine.tune$first < fine.tune$second + 0.2)
    expect_identical(pruneScores(results, min.diff.next=0.5), fine.tune$first < fine.tune$second + 0.5)
})

test_that("validating per-label check", {
    scores <- diag(5)
    colnames(scores) <- LETTERS[1:5]
    copies <- rbind(scores, scores*0.9, scores*0.8, scores/10)

    results <- DataFrame(scores=I(copies))
    expect_identical(pruneScores(results, nmads=3), rowSums(copies) < 0.5)
    expect_identical(pruneScores(results, nmads=10000), logical(nrow(copies)))
})
