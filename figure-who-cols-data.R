source("packages.R")

data(who, package="tidyr")
who.pattern.nc <- list(
  before=".*",
  "new_?",
  diagnosis=".*",
  "_",
  gender=".",
  ages="[0-9]+")
who.pattern.args <- nc::var_args_list(who.pattern.nc)
who.pattern.string <- who.pattern.args$pattern
who.reshape.names <- grep(who.pattern.string, names(who), value=TRUE)
who.reshape.cols <- who[, who.reshape.names]

N.rep.vec <- as.integer(10^seq(0, 2, by=0.5))
timing.dt.list <- list()
for(N.rep in N.rep.vec){
  print(N.rep)
  i.vec <- 1:N.rep
  L <- lapply(i.vec, function(i)who.reshape.cols)
  names(L) <- i.vec
  some.who <- do.call(data.frame, L)
  N.col <- ncol(some.who)
  result.list <- list()
  timing.dt.list[[paste(N.rep)]] <- data.table(N.rep, N.col, microbenchmark(
    control=list(order="block"),
    "nc::capture_melt_single"={
      result.list[["nc"]] <- nc::capture_melt_single(
        some.who, who.pattern.nc,
        na.rm=FALSE)
    },
    "tidyr::pivot_longer"={
      result.list[["pivot"]] <- tidyr::pivot_longer(
        some.who,
        grep(who.pattern.string, names(some.who)),
        names_to=names(who.pattern.args$fun.list),
        names_pattern=who.pattern.string)
    },
    "tidyr::gather"={
      result.list[["gather"]] <- tidyr::gather(
        some.who,
        "variable",
        "value",
        grep(who.pattern.string, names(some.who)))
    },
    "reshape2::melt"={
      result.list$reshape2 <- reshape2:::melt.data.frame(
        some.who,
        measure.vars=grep(who.pattern.string, names(some.who)))
    },
    "data.table::melt"={
      result.list$dt <- data.table::melt.data.table(
        data.table(some.who),
        measure.vars=patterns(who.pattern.string))
    },
    "stats::reshape"={
      times <- grep(who.pattern.string, names(some.who), value=TRUE)
      result.list$stats <- stats::reshape(
        some.who,
        direction="long",
        v.names="value",
        times=times,
        timevar="variable",
        varying=times)
    },
    "cdata::unpivot_to_blocks"={
      result.list$cdata <- cdata::unpivot_to_blocks(
        some.who, "variable", "value",
        grep(who.pattern.string, names(some.who), value=TRUE))
    },
    times=10))
  result.row.vec <- sapply(result.list, nrow)
  stopifnot(result.row.vec[1] == result.row.vec)
}

timing.dt <- do.call(rbind, timing.dt.list)
saveRDS(timing.dt, "figure-who-cols-data.rds")
