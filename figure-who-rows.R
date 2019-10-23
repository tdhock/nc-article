source("packages.R")

who.timings <- readRDS("figure-who-rows-data.rds")

who.timings[, seconds := time/1e9]
stats.timings <- who.timings[, .(
  median=median(seconds),
  q25=quantile(seconds, 0.25),
  q75=quantile(seconds, 0.75)
), by=.(N.rows, expr)]

gg <- ggplot()+
  theme_bw()+
  geom_ribbon(aes(
    N.rows, ymin=q25, ymax=q75, fill=expr),
    alpha=0.2,
    data=stats.timings)+
  geom_line(aes(
    N.rows, median, color=expr),
    data=stats.timings)+
  scale_x_log10(limits=c(NA, max(stats.timings$N.rows)*10))+
  scale_y_log10("Computation time (seconds)")
dl <- directlabels::direct.label(gg, "last.polygons")

pdf("figure-who-rows.pdf", 3, 3)
print(dl)
dev.off()

png("figure-who-rows.png", 3, 3, units="in", res=100)
print(dl)
dev.off()
