context("tests based on ex1")

test_that("identfiability", {
  data("ex1")
  expect_true(isIdentified(ex1$amat.cpdag, 6, 10))
  expect_true(isIdentified(ex1$amat.cpdag, c(6,7), 10))
  expect_true(isIdentified(ex1$amat.cpdag, 7, 9))
  expect_false(isIdentified(ex1$amat.cpdag, 5, 10))
  expect_false(isIdentified(ex1$amat.cpdag, c(1,3), 9))
})

test_that("estimation", {
  data("ex1")
  pairs <- list(
    list(x=6, y=10),
    list(x=c(6,7), y=10),
    list(x=7, y=9),
    list(x=c(3,4,5), y=8),
    list(x=c(3,4,5), y=7),
    list(x=c(3,4,5,6), y=8)
  )
  for (i in 1:length(pairs)) {
    .x <- pairs[[i]]$x
    .y <- pairs[[i]]$y
    truth <- getEffectsFromSEM(ex1$B, .x, .y)
    est <- estimateEffect(ex1$data, .x, .y, ex1$amat.cpdag, bootstrap=FALSE)
    err <- sqrt(mean((est - truth)^2))
    expect_lt(err, 0.03)
  }
})
