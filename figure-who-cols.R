source("packages.R")

who.timings <- readRDS("figure-who-cols-data.rds")

who.timings[, seconds := time/1e9]
stats.timings <- who.timings[, .(
  mean=mean(seconds),
  sd=sd(seconds)
), by=.(N.rows, expr)]

gg <- ggplot()+
  theme_bw()+
  geom_ribbon(aes(
    N.rows, ymin=mean-sd, ymax=mean+sd, fill=expr),
    alpha=0.5,
    data=stats.timings)+
  geom_line(aes(
    N.rows, mean, color=expr),
    data=stats.timings)+
  scale_x_log10(limits=c(NA, max(stats.timings$N.rows)*10))+
  scale_y_log10("Computation time (seconds)")
dl <- directlabels::direct.label(gg, "last.polygons")

pdf("figure-who-cols.pdf", 3, 3)
print(dl)
dev.off()

png("figure-who-cols.png", 3, 3, units="in", res=100)
print(dl)
dev.off()
