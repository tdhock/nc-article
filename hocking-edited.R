### R code from vignette source '/home/tdhock/projects/nc-article/hocking-edited.Rnw'

###################################################
### code chunk number 1: capture-iris-cols
###################################################
nc::capture_first_vec(
  names(iris), part=".*", "[.]", dim=".*", engine="ICU", nomatch.error=FALSE)


###################################################
### code chunk number 2: see
###################################################
str(compiled <- nc::var_args_list(part=".*", "[.]", dim=".*"))


###################################################
### code chunk number 3: icu
###################################################
m <- stringi::stri_match_first_regex(names(iris), compiled$pattern)
colnames(m) <- c("match", names(compiled$fun.list))
m


###################################################
### code chunk number 4: sweedReport
###################################################
report.txt.gz <- system.file("extdata", "SweeD_Report.txt.gz", package="nc")
report.vec <- readLines(report.txt.gz)
cat(report.vec[1:5], sep="\n")
cat(report.vec[1003:1008], sep="\n")


###################################################
### code chunk number 5: parseReport
###################################################
report.alignments <- nc::capture_all_str(
  report.vec,
  "//",
  Alignment="[0-9]+",
  TSV="[^/]+")
class(report.alignments)
dim(report.alignments)
nchar(report.alignments$TSV)
substr(as.matrix(report.alignments[1:2]), 1, 50)


###################################################
### code chunk number 6: freadby
###################################################
(report.positions <- report.alignments[, data.table::fread(text=TSV), by=Alignment])


###################################################
### code chunk number 7: info
###################################################
info.txt.gz <- system.file("extdata", "SweeD_Info.txt.gz", package="nc")
info.vec <- readLines(info.txt.gz)
info.vec[24:40]


###################################################
### code chunk number 8: infoparsed
###################################################
nc::capture_all_str(
  info.vec,
  " ",
  "Alignment", " ", Alignment="[0-9]+",
  "\n\n\t\t",
  "Chromosome", ":\t\t", Chromosome=".*")


###################################################
### code chunk number 9: infoparsedfield
###################################################
(info.alignments <- nc::capture_all_str(
  info.vec,
  " ",
  nc::field("Alignment", " ", "[0-9]+"),
  "\n\n\t\t",
  nc::field("Chromosome", ":\t\t", ".*")))


###################################################
### code chunk number 10: join
###################################################
info.alignments[report.positions, on="Alignment"]


###################################################
### code chunk number 11: irisSingle
###################################################
(iris.tall.single <- nc::capture_melt_single(
  iris, part=".*", "[.]", dim=".*", value.name="cm"))


###################################################
### code chunk number 12: hist
###################################################
library(ggplot2)
ggplot(iris.tall.single)+facet_grid(part~dim)+
  theme_bw()+theme(panel.spacing=grid::unit(0, "lines"))+
  geom_histogram(aes(cm, fill=Species), color="black", bins=40)


###################################################
### code chunk number 13: irisMultiple
###################################################
(iris.parts <- nc::capture_melt_multiple(
  iris, column=".*", "[.]", dim=".*"))


###################################################
### code chunk number 14: scatter
###################################################
ggplot(iris.parts)+facet_grid(.~dim)+
  theme_bw()+theme(panel.spacing=grid::unit(0, "lines"))+
  coord_equal()+geom_abline(slope=1, intercept=0, color="grey")+
  geom_point(aes(Petal, Sepal, color=Species), shape=1)


###################################################
### code chunk number 15: who
###################################################
data(who, package="tidyr")
set.seed(1);sample(names(who), 10)


###################################################
### code chunk number 16: whoreshape
###################################################
new.diag.gender <- list("new_?", diagnosis=".*", "_", gender=".")
nc::capture_melt_single(who, new.diag.gender, ages=".*")


###################################################
### code chunk number 17: who2
###################################################
who.typed <- nc::capture_melt_single(
  who, new.diag.gender, ages=list(
    min.years="0|[0-9]{2}", as.numeric,
    max.years="[0-9]{0,2}", function(x)ifelse(x=="", Inf, as.numeric(x))),
  value.name="count")
str(who.typed)


