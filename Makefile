# Makefile
# author: Afnan Enayet
#
# Makefile to generate a pdf from latex files. Also offers a convenient script
# to delete generated files

# input_file is the file that actually gets used to generate the PDF
input_file=thesis.latex

# define the actual input files so the makefile knows when to regenerate the PDF
input_files=$(wildcard chapters/*.latex)
output_file=thesis.pdf
bib=bibliography.bib

.PHONY: all clean

$(output_file): $(input_file) $(input_files) $(bib)
	biber thesis
	xelatex -shell-escape $(input_file)

clean:
	rm -rf *.log *.aux *.toc *.pdf
	rm -rf chapter/*.aux
