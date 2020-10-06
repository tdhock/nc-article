### Write down what package versions work with your R code, and
### attempt to download and load those packages. The first argument is
### the version of R that you used, e.g. "3.0.2" and then the rest of
### the arguments are package versions. For
### CRAN/Bioconductor/R-Forge/etc packages, write
### e.g. RColorBrewer="1.0.5" and if RColorBrewer is not installed
### then we use install.packages to get the most recent version, and
### warn if the installed version is not the indicated version. For
### GitHub packages, write "user/repo@commit"
### e.g. "tdhock/animint@f877163cd181f390de3ef9a38bb8bdd0396d08a4" and
### we use install_github to get it, if necessary.
works_with_R <- function(Rvers,...){
  local.lib <- file.path(getwd(), "library-new")
  old.path.vec <- .libPaths()
  if(is.null(getOption("repos"))){
    options(repos="http://cloud.r-project.org")
  }
  if(! local.lib %in% old.path.vec){
    dir.create(local.lib, showWarnings=FALSE, recursive=TRUE)
    .libPaths(local.lib)
  }
  pkg_ok_have <- function(pkg,ok,have){
    stopifnot(is.character(ok))
    if(!as.character(have) %in% ok){
      warning("works with ",pkg," version ",
              paste(ok,collapse=" or "),
              ", have ",have)
    }
  }
  pkg_ok_have("R",Rvers,getRversion())
  pkg.vers <- list(...)
  for(pkg.i in seq_along(pkg.vers)){
    vers <- pkg.vers[[pkg.i]]
    pkg <- if(is.null(names(pkg.vers))){
      ""
    }else{
      names(pkg.vers)[[pkg.i]]
    }
    if(pkg == ""){# Then it is from GitHub.
      ## suppressWarnings is quieter than quiet.
      if(!suppressWarnings(require(requireGitHub))){
        ## If requireGitHub is not available, then install it using
        ## devtools.
        if(!suppressWarnings(require(devtools))){
          install.packages("devtools")
          require(devtools)
        }
        install_github("tdhock/requireGitHub")
        require(requireGitHub)
      }
      requireGitHub(vers)
    }else{# it is from a CRAN-like repos.
      if(!suppressWarnings(require(pkg, character.only=TRUE))){
        install.packages(pkg)
      }
      pkg_ok_have(pkg, vers, packageVersion(pkg))
      library(pkg, character.only=TRUE)
    }
  }
}

options(repos=c(
          "http://www.bioconductor.org/packages/release/bioc",
          "http://r-forge.r-project.org",
          "http://cloud.r-project.org"))
works_with_R(
  "3.6.1",
  wrapr="1.9.2",
  rquery="1.3.9",
  "Rdatatable/data.table@c02fa9e8e6016986bbad3113c149d68104d70bff",
  rqdatatable="1.2.3",
  ## below updated
  ## "r-lib/vctrs@ce4aa0f37b02cf4484d5e5a585f5c4326676fc58",
  ## "tidyverse/tidyselect@b450588248bb30a3305d691fa213d875f451ab01",
  ## "WinVector/cdata@7208011c5566be399694ccefbece0cf203ed7d39",#1.1.3
  cdata="1.0",
  ## packages above have been updated based on the issues I posted.
  "tdhock/directlabels@f690edf6db2790960aa00ca388b7e11da74bf783",
  ##data.table="1.12.6",
  bit64="0.9.8",
  microbenchmark="1.4.7",
  ggplot2="3.2.1",
  nc="2019.10.19",
  tidyr="1.0.0",
  reshape2="1.4.3")
