TOP=..
##############################################################################
# Variables
##############################################################################
TARGET=lib

SRC=cairo_helpers.ml \
    flag_visual.ml \
    style2.ml \
    parsing2.ml \
    editor_connection.ml \
    model2.ml \
    custom_list_generic.ml \
    completion2.ml \
    draw2.ml \
    view2.ml

#experimental:  future.ml \    ancient2.ml \      completion.ml \

SYSLIBS=str.cma unix.cma dbm.cma threads.cma  lablgtk.cma

LIBS=$(TOP)/commons/commons.cma $(TOP)/commons/commons_gui.cma \
     $(TOP)/commons/commons_features.cma \
     $(TOP)/globals/globals.cma \

INCLUDEDIRS=$(TOP)/commons $(TOP)/globals \
	$(TOP)/h_program-lang \
	$(TOP)/h_visualization \
	$(TOP)/h_program-visual \
	$(TOP)/lang_php/parsing \
        $(TOP)/lang_php/analyze \
         $(TOP)/lang_php/analyze/basic $(TOP)/lang_php/analyze/foundation \
         $(TOP)/lang_php/analyze/finder \
         $(TOP)/lang_php/analyze/checker \
         $(TOP)/lang_php/analyze/database \
        $(TOP)/lang_php/matcher \
        $(TOP)/lang_ml/parsing \
         $(TOP)/lang_ml/analyze \
        $(TOP)/lang_nw/parsing \
         $(TOP)/lang_nw/analyze \
        $(TOP)/lang_cpp/parsing \
         $(TOP)/lang_cpp/analyze \
        $(TOP)/lang_js/parsing \
         $(TOP)/lang_js/analyze \


SYSINCLUDES=\
  -I $(TOP)/external/ocamlgtk/src \
  -I $(TOP)/external/ocamlcairo/src \

##############################################################################
# Generic variables
##############################################################################

-include $(TOP)/Makefile.common

##############################################################################
# Top rules
##############################################################################
all:: $(TARGET).cma 
all.opt:: $(TARGET).cmxa
opt: all.opt


$(TARGET).cma: $(OBJS) $(LIBS)
	$(OCAMLC) -a -o $(TARGET).cma $(OBJS)

$(TARGET).cmxa: $(OPTOBJS) $(LIBS:.cma=.cmxa)
	$(OCAMLOPT) -a -o $(TARGET).cmxa $(OPTOBJS)


clean::
	rm -f $(TARGET).top


##############################################################################
# Generic rules
##############################################################################

##############################################################################
# Literate Programming rules
##############################################################################

TEXMAIN=Visual.tex.nw
TEX=Visual.tex

# set of noweb (.nw) files

# must be in the same order of the #include for syncweb multi files support
# to work
SRC_ORIG=Visual.tex.nw

# set of ml files, the views. Also used by make lpclean.
SRC_NOT_SYNCED=custom_list_generic.ml
SRC_ML= $(filter-out $(SRC_NOT_SYNCED), $(SRC))
SRC_NO_MLI=flag_visual.mli
SRC_MLI=$(filter-out $(SRC_NO_MLI), $(SRC_ML:ml=mli))

SRC_VIEWS=$(SRC_MLI) $(SRC_ML) ../main_visual.ml

#------------------------------------------------------------------------------
sync:
	for i in $(SRC_VIEWS); do $(SYNCWEB) $(SRC_ORIG) $$i || exit 1; done 


pdf:
	$(NOWEB) $(TEXMAIN) > $(TEX)
	pdflatex $(TEX)
#	pdflatex $(TEX)

lpclean::
	rm -f $(TEX)

lpdistclean::
	rm -f $(SRC_VIEWS) .md5sum_* $(TEX)

clean::
	rm -f *.aux *.toc *.log *.brf *.out

