# Makefile
# author: Afnan Enayet
#
# Makefile to generate a pdf from latex files. Also offers a convenient script
# to delete generated files

# input_file is the file that actually gets used to generate the PDF
input_file=thesis.latex

# define the actual input files so the makefile knows when to regenerate the PDF
input_files=$(wildcard chapters/*.latex) macros.tex
output_file=thesis.pdf
bib=references/rendering-bibtex.bib references/strings-full.bib references/strings-full.bib

.PHONY: all clean

$(output_file): $(input_file) $(input_files) $(bib)
	bibtex thesis
	xelatex -shell-escape $(input_file)
	# Need to run it again to sync the bibliography
	bibtex thesis
	xelatex -shell-escape $(input_file)

clean:
	rm -rf *.log *.aux *.toc *.pdf *.bbl *.bcf *.out *.xml *.lof *.upa *.upb
	rm -rf chapter/*.aux
