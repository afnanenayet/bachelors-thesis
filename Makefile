# Makefile
# author: Afnan Enayet
#
# Makefile to generate a pdf from latex files. Also offers a convenient script
# to delete generated files
#
# Usage is simple: `make` generates the PDF, `make clean` cleans up any files
# that were generated

# The "root" input file that generates the rest of the report
root_input=thesis.latex

# define input files so the makefile knows when to regenerate the PDF
input_files=$(wildcard chapters/*.latex) macros.tex thesis.latex
output_file=thesis.pdf
bib=$(wildcard references/*.bib)

.PHONY: all clean

$(output_file): $(input_files) $(bib)
	xelatex -shell-escape $(root_input)
	bibtex thesis
	# Need to compile PDF again to sync references and TOC/LOF
	xelatex -shell-escape $(root_input)

clean:
	rm -rf *.log *.aux *.toc *.pdf *.bbl *.bcf *.out *.xml *.lof *.upa *.upb
	rm -rf chapter/*.aux
