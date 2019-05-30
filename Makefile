# Makefile
# author: Afnan Enayet
#
# Makefile to generate a pdf from latex files. Also offers a convenient script
# to delete generated files
#
# Usage is simple: `make` generates the PDF, `make clean` cleans up any files
# that were generated

# define input files so the makefile knows when to regenerate the PDF
input_files=$(wildcard chapters/*.latex) macros.tex thesis.latex
output_file=thesis.pdf
bib=$(wildcard refernces/*.latex)

.PHONY: all clean

$(output_file): $(input_files) $(bib)
	xelatex -shell-escape $(input_file)
	bibtex thesis
	# Need to compile PDF again to sync new reference info and sync TOC/LOF
	xelatex -shell-escape $(input_file)

clean:
	rm -rf *.log *.aux *.toc *.pdf *.bbl *.bcf *.out *.xml *.lof *.upa *.upb
	rm -rf chapter/*.aux
