RJwrapper.pdf: hocking.tex hocking.bib figure-1-iris.pdf figure-who-both-cols.png figure-who-both-rows.png figure-iris-cols.png figure-iris-rows.png
	R -e "tools::texi2pdf('RJwrapper.tex')"
RJwrapper-reproduced.pdf: RJwrapper.pdf
	mkdir -p submission
	cp hocking.bib hocking.Rnw hocking.tex letter-to-editor.pdf Makefile RJwrapper.pdf RJwrapper.tex *.R figure-*.rds figure-*.pdf submission
	rm -f submission.zip
	zip submission submission/*
	rm -rf /tmp/submission* && cp submission.zip RJournal.sty /tmp
	cd /tmp && unzip submission.zip && cp RJournal.sty submission && cd submission && touch hocking.Rnw && make RJwrapper.pdf
	cp /tmp/submission/RJwrapper.pdf RJwrapper-reproduced.pdf
hocking-edited.Rnw: hocking-remove-space.R hocking.Rnw
	R --vanilla < hocking-remove-space.R
hocking.tex: hocking-edited.Rnw 
	R CMD Stangle hocking-edited.Rnw
	R CMD Sweave hocking-edited.Rnw
	mv hocking-edited.R hocking.R
	mv hocking-edited.tex hocking.tex
figure-iris-cols.png: figure-iris-cols.R figure-iris-cols-data.rds figure-iris-cols-convert-data.rds
	R --vanilla < $<
figure-iris-cols-data.rds: figure-iris-cols-data.R
	R --vanilla < $<
figure-iris-cols-minimal.png: figure-iris-cols-minimal.R figure-iris-cols-minimal-data.rds figure-iris-cols-minimal-convert-data.rds
	R --vanilla < $<
figure-iris-cols-minimal-data.rds: figure-iris-cols-minimal-data.R
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
