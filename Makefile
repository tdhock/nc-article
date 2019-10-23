submission.zip: RJwrapper.pdf
	mkdir -p submission
	cp hocking.bib hocking-edited.R hocking-edited.tex Makefile RJwrapper.pdf RJwrapper.tex submission
	zip submission submission/* 
RJwrapper.pdf: hocking-edited.tex hocking.bib figure-1-iris.pdf figure-who-rows.png figure-who-cols.png
	R -e "tools::texi2pdf('RJwrapper.tex')"
hocking-edited.Rnw: hocking-remove-space.R hocking.Rnw 
	R --vanilla < $<
hocking-edited.tex: hocking-edited.Rnw
	R CMD Stangle $<
	R CMD Sweave $<
figure-who-rows-data.rds: figure-who-rows-data.R
	R --vanilla < $<
figure-who-rows.png: figure-who-rows.R figure-who-rows-data.rds
	R --vanilla < $<
figure-who-cols-data.rds: figure-who-cols-data.R
	R --vanilla < $<
figure-who-cols.png: figure-who-cols.R figure-who-cols-data.rds
	R --vanilla < $<
