
PROJECT = main
TOP = main
SOURCES = kcpsm3.v code.v main.v

all:	install

code.v: code.psm
	ln -fs  dist/Assembler/ROM_form.* .
	wine dist/Assembler/KCPSM3.EXE code.psm
	mv CODE.V code.v
	rm -f ROM_form.* CODE.* CONSTANT.TXT LABELS.TXT PASS*

include ../../Makefile

clean::
	rm -f *.DAT