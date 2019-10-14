submission.zip: RJwrapper.pdf
	cp hocking.bib hocking-edited.R hocking-edited.tex Makefile RJwrapper.pdf RJwrapper.tex submission
	zip submission submission/* 
RJwrapper.pdf: hocking-edited.tex hocking.bib 
	R -e 'tools::texi2pdf("RJwrapper.tex")'
hocking-edited.Rnw: hocking-remove-space.R hocking.Rnw 
	R --vanilla < $<
hocking-edited.tex: hocking-edited.Rnw
	R CMD Stangle $<
	R CMD Sweave $<
