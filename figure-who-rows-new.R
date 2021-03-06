source("packages-new.R")

pkg.color <- c(
  "data.table::melt"="#1B9E77",
  "reshape2::melt"="#D95F02",
  "tidyr::gather"="#7570B3",
  "tidyr::pivot_longer"="#7570B3",
  "cdata::unpivot_to_blocks"="#E7298A",
  "cdata::rowrecs_to_blocks"="#E7298A",
  "nc::capture_melt_single"="#66A61E",
  "stats::reshape"="#E6AB02",
  "utils::stack"="#E6AB02",
  "tidyfast::dt_pivot_longer"="#A6761D")
##, "#666666")

who.timings <- fread("figure-who-rows-new-data.csv")
who.info <- nc::capture_first_df(who.timings, expr=list(
  pkg.fun=list(
    pkg=".*?",
    "::",
    fun="[a-z._]+"),
  "-",
  capture.columns=".*", as.integer))
who.info[, seconds := time/1e9]
who.info[!pkg.fun %in% names(pkg.color), unique(pkg.fun)]
stats.timings <- who.info[pkg.fun %in% names(pkg.color), .(
  median=median(seconds),
  q25=quantile(seconds, 0.25),
  q75=quantile(seconds, 0.75)
), by=.(N.rows, pkg.fun, capture.columns)]
ref.dt <- data.table(
  seconds=c(60*60, 60, 1),
  unit=c("hour", "minute", "second"))[unit!="hour"]
cex.poly <- 0.75
right.side <- list(cex=cex.poly, "last.qp")
left.side <- list(cex=cex.poly, rot=40, "last.qp")
stats.max <- stats.timings[
, .SD[which.max(N.rows)],
  by=.(capture.columns, pkg.fun)]
dl <- ggplot()+
  ggtitle("Single reshape output column, variable number of input rows")+
  facet_grid(. ~ capture.columns, labeller=label_both)+
  geom_hline(aes(
    yintercept=seconds),
    color="grey",
    data=ref.dt)+
  geom_text(aes(
    100, seconds, label=paste(1, unit)),
    data=ref.dt,
    color="grey",
    hjust=0,
    size=3,
    vjust=1.2)+
  theme_bw()+
  theme(
    legend.position="none",
    panel.spacing=grid::unit(0, "lines"))+
  scale_color_manual(values=pkg.color)+
  scale_fill_manual(values=pkg.color)+
  geom_dl(aes(
    N.rows, median, color=pkg.fun, label=pkg.fun),
    data=stats.timings[N.rows==max(N.rows)],
    method="right.side")+
  geom_dl(aes(
    N.rows, median, color=pkg.fun, label=pkg.fun),
    data=stats.max[N.rows!=max(N.rows)],
    method="left.side")+
  geom_line(aes(
    N.rows, median, group=pkg.fun),
    color="white",
    size=2,
    alpha=0.5,
    data=stats.timings)+
  geom_line(aes(
    N.rows, median, color=pkg.fun),
    data=stats.timings)+
  geom_ribbon(aes(
    N.rows, ymin=q25, ymax=q75, fill=pkg.fun),
    alpha=0.5,
    data=stats.timings)+
  scale_x_log10(
    "Number of rows in wide input data table",
    breaks=10^seq(2, 5),
    limits=stats.timings[, c(min(N.rows), max(N.rows)*100)])+
  scale_y_log10(
    "Computation time (seconds)",
    limits=c(NA, 1e2))
pdf("figure-who-rows-new.pdf", 9, 4)
print(dl)
dev.off()
png("figure-who-rows-new.png", 9, 4, units="in", res=100)
print(dl)
dev.off()

