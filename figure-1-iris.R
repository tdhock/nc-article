library(data.table)
(some.iris <- data.table(iris, flower=1:nrow(iris))[c(1, 51)])
nc::capture_melt_single(
  some.iris,
  part=".*",
  "[.]",
  dim=".*", 
  value.name="cm")[order(flower, variable)]

nc::capture_melt_multiple(
  some.iris,
  column=".*",
  "[.]",
  dim=".*")[order(flower, dim)]

nc::capture_melt_multiple(
  some.iris,
  part=".*",
  "[.]",
  column=".*")[order(flower, part)]
