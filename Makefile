submission.zip: RJwrapper.pdf
	mkdir -p submission
	cp hocking.bib letter-to-editor.pdf hocking-edited.R hocking-edited.tex Makefile RJwrapper.pdf RJwrapper.tex figure-*.R figure-*.rds submission 
	zip submission submission/* 
RJwrapper.pdf: hocking-edited.tex hocking.bib figure-1-iris.pdf figure-who-both-cols.png figure-who-both-rows.png figure-iris-cols.png figure-iris-rows.png
	R -e "tools::texi2pdf('RJwrapper.tex')"
hocking-edited.Rnw: hocking-remove-space.R hocking.Rnw 
	R --vanilla < $<
hocking-edited.tex: hocking-edited.Rnw
	R CMD Stangle $<
	R CMD Sweave $<

figure-iris-cols.png: figure-iris-cols.R figure-iris-cols-data.rds figure-iris-cols-convert-data.rds
	R --vanilla < $<
figure-iris-cols-data.rds: figure-iris-cols-data.R
	R --vanilla < $<
figure-iris-cols-convert-data.rds: figure-iris-cols-convert-data.R
	R --vanilla < $<

figure-who-both-rows.png: figure-who-both-rows.R figure-who-complex-rows-data.rds figure-who-rows-data.rds
	R --vanilla < $<
figure-who-complex-rows-data.rds: figure-who-complex-rows-data.R
	R --vanilla < $<
figure-who-complex-rows.png: figure-who-complex-rows.R figure-who-complex-rows-data.rds
	R --vanilla < $<
figure-who-rows-data.rds: figure-who-rows-data.R
	R --vanilla < $<
figure-who-rows.png: figure-who-rows.R figure-who-rows-data.rds
	R --vanilla < $<


figure-who-both-cols.png: figure-who-both-cols.R figure-who-complex-cols-data.rds figure-who-cols-data.rds
	R --vanilla < $<
figure-who-complex-cols-data.rds: figure-who-complex-cols-data.R
	R --vanilla < $<
figure-who-cols-data.rds: figure-who-cols-data.R
	R --vanilla < $<
figure-who-cols.png: figure-who-cols.R figure-who-cols-data.rds
	R --vanilla < $<

figure-iris-rows.png: figure-iris-rows.R figure-iris-rows-data.rds figure-iris-rows-convert-data.rds
	R --vanilla < $<
figure-iris-rows-data.rds: figure-iris-rows-data.R
	R --vanilla < $<
figure-iris-rows-convert-data.rds: figure-iris-rows-convert-data.R
	R --vanilla < $<
