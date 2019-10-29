source("packages-new.R")

pkg.color <- c(
  "data.table::melt"="#1B9E77",
  "reshape2::melt"="#D95F02",
  "tidyr::gather"="#7570B3",
  "tidyr::pivot_longer"="#7570B3",
  "cdata::unpivot_to_blocks"="#E7298A",
  "cdata::rowrecs_to_blocks"="#E7298A",
  "nc::capture_melt_multiple"="#66A61E",
  "stats::reshape"="#E6AB02",
  "utils::stack"="#E6AB02",
  "#A6761D", "#666666")

iris.timings <- readRDS("figure-iris-cols-new-data.rds")
fwrite(iris.timings, "figure-iris-cols-new-data.csv")
iris.timings <- fread("figure-iris-cols-new-data.csv")

iris.timings[, seconds := time/1e9]
stats.timings <- iris.timings[, .(
  median=median(seconds),
  q25=quantile(seconds, 0.25),
  q75=quantile(seconds, 0.75)
), by=.(N.col, expr)]
stats.timings[, minutes := median/60]
stats.timings[
, .SD[N.col==max(N.col), .(
  N.col, pkg=sub("::.*", "", expr), median, minutes)][order(-minutes)],
]


stats.timings[N.col>4000, {
  fit <- lm(log10(median) ~ log10(N.col))
  w <- coef(fit)
  data.table(intercept=w[1], slope=w[2])
}, by=.(expr)][order(slope)]

ref.dt <- data.table(
  seconds=c(60*60, 60, 1),
  unit=c("hour", "minute", "second"))

gg <- ggplot()+
  ggtitle("Multiple reshape output columns, variable number of input columns")+
  geom_hline(aes(
    yintercept=seconds),
    color="grey",
    data=ref.dt)+
  geom_text(aes(
    10, seconds, label=paste(1, unit)),
    data=ref.dt,
    color="grey",
    hjust=0,
    size=3,
    vjust=1.2)+
  theme_bw()+
  theme(panel.spacing=grid::unit(0, "lines"))+
  scale_color_manual(values=pkg.color)+
  scale_fill_manual(values=pkg.color)+
  geom_line(aes(
    N.col, median, color=expr),
    data=stats.timings)+
  geom_ribbon(aes(
    N.col, ymin=q25, ymax=q75, fill=expr),
    alpha=0.2,
    data=stats.timings)+
  scale_x_log10(
    "Number of cols in wide input data table",
    limits=c(NA, max(stats.timings$N.col)*20))+
  scale_y_log10(
    "Computation time (seconds)")
dl <- directlabels::direct.label(gg, list(cex=0.75, "last.polygons"))

pdf("figure-iris-cols-new.pdf", 7, 3)
print(dl)
dev.off()

png("figure-iris-cols-new.png", 7, 3, units="in", res=100)
print(dl)
dev.off()
