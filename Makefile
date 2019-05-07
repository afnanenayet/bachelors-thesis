# Makefile
# author: Afnan Enayet
#
# Makefile to generate a pdf from latex files. Also offers a convenient script
# to delete generated files

input_file=thesis.latex
output_file=thesis.pdf

.PHONY: all clean

$(output_file): $(input_file)
	xelatex $(input_file)

clean:
	rm -rf *.log *.aux *.toc *.pdf
	rm -rf chapter/*.aux
