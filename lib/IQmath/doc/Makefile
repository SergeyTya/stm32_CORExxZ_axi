#******************************************************************************
#
# Makefile - Rules for building the DriverLib documentation.
#
# Copyright (c) 2005 Texas Instruments Incorporated.  All rights reserved.
# TI Information - Selective Disclosure
#
#******************************************************************************

#
# Skip the definitions of the following variables if we are only
# attempting to clean the folder up.  These variables are not needed
# for the "clean" and "spellclean" targets.
#
ifneq (${MAKECMDGOALS},clean)
ifneq (${MAKECMDGOALS},spellclean)

#
# The title of this document.
#
TITLE:=TivaWare{\\\\texttrademark} IQmath Library

#
# The document number for this document.
#
DOCNUM:=SW-TM4x-IQMATH-UG

#
# Get the repository revision number.
#
VERSION:=${shell svnversion ..}

#
# Convert the reposition revision number into a string that Winders is happy
# with in a file name.
#
FILEVERSION:=${shell echo ${VERSION} | sed 's/:/_/g'}
FILEVERSION:=${shell echo ${FILEVERSION} | sed 's/ /_/g'}

#
# Get the modification date of the repository.
#
DATE:=${shell date -d `svn info .. | grep "Last Changed Date" | \
                      cut -d\  -f4 | gawk -F- '{print $1$2$3}'` "+%B %d, %G"}

endif	#ifneq (${MAKECMDGOALS},spellclean)
endif	#ifneq (${MAKECMDGOALS},clean)

#
# The default rule, which causes the document to be built.
#
all: ${DOCNUM}-${FILEVERSION}-d.pdf

#
# Rule to run spell checking
#
spell: spell-check.txt

#
# The rule to clean out all the build products.
#
clean: spellclean
	@rm -rf ${wildcard *.pdf} latex xml ${wildcard *~}
	@rm -rf ${wildcard code_*.dox} board_chapters.dox

spellclean:
	@rm -f spell-check.txt combined-tex combined-dict.rws
	@rm -f latex.txt suspicious.txt

#
# The rule for building the document.
#
${DOCNUM}-${FILEVERSION}-d.pdf: Doxyfile
${DOCNUM}-${FILEVERSION}-d.pdf: Makefile
${DOCNUM}-${FILEVERSION}-d.pdf: ${wildcard *.dox}
${DOCNUM}-${FILEVERSION}-d.pdf: ${wildcard ../*.c}
${DOCNUM}-${FILEVERSION}-d.pdf: ${wildcard ../../doc/custom_latex/*}
	@set -e;                                                        \
	 echo "  doxygen";                                              \
	 doxygen;                                                       \
	 sed -i -e "s/\\\\-//g" latex/*.tex;                            \
	 cp ../../doc/custom_latex/* latex;                             \
	 TITLE=`echo ${TITLE} | sed 's/{.*}//g'`;                       \
	 sed -i "s/DOCTITLE/$${TITLE} User's Guide/g" latex/refman.tex; \
	 sed -i "s/COVERTITLE1/${TITLE}/g" latex/refman.tex;            \
	 sed -i "s/COVERTITLE2/USER'S GUIDE/g" latex/refman.tex;        \
	 sed -i "s/DOCNUM/${DOCNUM}/g" latex/refman.tex;                \
	 sed -i "s/__REVISION__/${VERSION}-d/g" latex/refman.tex;       \
	 sed -i "s/DATE/${DATE}/g" latex/refman.tex;                    \
	 sed -i "s/COPYRIGHT/2010/g" latex/refman.tex;                  \
	 perl -w -i.orig ../../doc/verbatim.pl latex/*.tex;             \
	 rm -f latex/*.tex.orig;                                        \
	 rm -f latex/refman.pdf;                                        \
	 echo "  pdflatex ${@:.pdf=.tex}";                              \
	 make -C latex refman.pdf >> /dev/null 2>&1;                    \
	 cp latex/refman.pdf ${DOCNUM}-${FILEVERSION}-d.pdf;            \
	 grep -i "warning[/]" latex/refman.log || true

#
# Rule for creating the spell check files
#
# The output file spell-check.txt will contain a list of suspicious words it
# found in the documentation.  If a word in the list is okay, you can add it to
# words.wl.
#
spell-check.txt: ${DOCNUM}-${FILEVERSION}-d.pdf
	@echo "  spell checking with aspell (if aspell is installed)"
	@echo "    see file spell-check.txt for suspicious words"
	@aspell --lang=en --variety=US create master ./combined-dict.rws < words.wl
	@grep -hv ^% ${wildcard latex/*.tex} > ./combined-tex
	@aspell -t --add-extra-dicts=./combined-dict.rws list <combined-tex \
	     | sort | uniq >spell-check.txt
	@rm -f ./combined-tex ./combined-dict.rws
	@grep -E ^[a-g]*$$ spell-check.txt > latex.txt || true
	@grep -vE ^[a-g]*$$ spell-check.txt > suspicious.txt || true

foobar:
	@sed -n '/\\code/,/\\endcode/p' interrupt.dox | grep -v ^\\\\.\*code$
