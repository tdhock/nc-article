### R code from vignette source '/home/tdhock/projects/nc-article/hocking-edited.Rnw'

###################################################
### code chunk number 1: capture-iris-cols
###################################################
nc::capture_first_vec(
  names(iris), part=".*", "[.]", dim=".*", engine="RE2", nomatch.error=FALSE)


###################################################
### code chunk number 2: see
###################################################
nc::var_args_list(part=".*", "[.]", dim=".*")$pattern


