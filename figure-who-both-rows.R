source("packages.R")

pkg.color <- c(
  "data.table::melt"="#1B9E77",
  "reshape2::melt"="#D95F02",
  "tidyr::gather"="#7570B3",
  "tidyr::pivot_longer"="#7570B3",
  "cdata::unpivot_to_blocks"="#E7298A",
  "cdata::rowrecs_to_blocks"="#E7298A",
  "nc::capture_melt_single"="#66A61E",
  "stats::reshape"="#E6AB02", 
  "#A6761D", "#666666")

who.timings <- rbind(
  data.table(groups=3, conversion=FALSE, readRDS("figure-who-rows-data.rds")),
  data.table(
    groups=5, conversion=TRUE, readRDS("figure-who-complex-rows-data.rds"))
)[!grepl("[+]", expr)]
who.timings[, seconds := time/1e9]
stats.timings <- who.timings[, .(
  median=median(seconds),
  q25=quantile(seconds, 0.25),
  q75=quantile(seconds, 0.75)
), by=.(groups, conversion, N.rows, expr)]

gg <- ggplot()+
  theme_bw()+
  theme(panel.spacing=grid::unit(0, "lines"))+
  scale_color_manual(values=pkg.color)+
  scale_fill_manual(values=pkg.color)+
  facet_grid(groups + conversion ~ ., labeller=label_both)+
  geom_line(aes(
    N.rows, median, color=expr),
    data=stats.timings)+
  geom_ribbon(aes(
    N.rows, ymin=q25, ymax=q75, fill=expr),
    alpha=0.2,
    data=stats.timings)+
  scale_x_log10(
    "Number of rows in wide input data table",
    breaks=10^seq(1, 5, by=1),
    limits=c(NA, max(stats.timings$N.rows)*20))+
  scale_y_log10("Computation time (seconds)")
dl <- directlabels::direct.label(gg, list(cex=0.8, "last.polygons"))

pdf("figure-who-both-rows.pdf", 7, 2.7)
print(dl)
dev.off()

png("figure-who-both-rows.png", 7, 2.7, units="in", res=100)
print(dl)
dev.off()
