
TOPDIR = /home/ico/prjs/fpga
XDIR = /opt/Xilinx/10.1/ISE

############################################################################
# Some nice targets
############################################################################

COLORIZE = $(TOPDIR)/bin/colorize

default:
	make install | $(COLORIZE)

install: $(PROJECT).bit
	ljp $< /dev/parport0

floorplan: $(PROJECT).ngd $(PROJECT).par.ncd
	$(FLOORPLAN) $^

report:
	cat *.srp | $(TOPDIR)/bin/colorize 1

clean:
	rm -f *.bld *.lso *.map *.ngc *.xrpt *.ptwx *.unroutes
	rm -f *.srp *.work *.xml *.xst *.ise
	rm -f *.par *.pad *.ncd *.csv *.ngd *.txt 
	rm -f *.pcf *.bit *.xpi *.ngm *.bgn *.drc *.mrp
	rm -rf xst xlnx_auto_0_xdb _ngo


############################################################################
# Simulation using cver and gtkwave
############################################################################

CVER       = cver
GTKWAVE    = ~/bin/gtkwave
CVERFLAGS  = $(XDIR)/verilog/src/glbl.v
#CVERFLAGS += -y $(XDIR)/verilog/src/unisims 
CVERFLAGS += -y $(TOPDIR)/Unisims
CVERFLAGS += +libext+.v+ -q
CVERFLAGS += +define+SIMULATION

.PRECIOUS: %.vcd

sim_%:	%.vcd 
	$(GTKWAVE) $^ $@.save
	
%.vcd: sim_%.v $(SOURCES) 
	rm -f $@
	$(CVER) $^ $(CVERFLAGS)
	@rm -f verilog.log


############################################################################
# Xilinx tools and wine
############################################################################

XST_DEFAULT_OPT_MODE = Speed
XST_DEFAULT_OPT_LEVEL = 1
DEFAULT_ARCH = spartan3
DEFAULT_PART = xc3s200-ft256-4


XBIN = $(XDIR)/bin/lin
XENV = XILINX=$(XDIR) LD_LIBRARY_PATH=$(XBIN)



XST 	  = $(XENV) $(XBIN)/xst
NGDBUILD  = $(XENV) $(XBIN)/ngdbuild
MAP       = $(XENV) $(XBIN)/map
PAR       = $(XENV) $(XBIN)/par
BITGEN    = $(XENV) $(XBIN)/bitgen
PROMGEN   = $(XENV) $(XBIN)/promgen
FLOORPLAN = $(XENV) $(XBIN)/floorplanner

XSTWORK   = $(PROJECT).work
XSTSCRIPT = $(PROJECT).xst

.PRECIOUS: %.ngc %.ngc %.ngd %.map.ncd %.bit %.par.ncd

ifndef XST_OPT_MODE
XST_OPT_MODE = $(XST_DEFAULT_OPT_MODE)
endif
ifndef XST_OPT_LEVEL
XST_OPT_LEVEL = $(XST_DEFAULT_OPT_LEVEL)
endif
ifndef ARCH
ARCH = $(DEFAULT_ARCH)
endif
ifndef PART
PART = $(DEFAULT_PART)
endif
	
$(XSTWORK): $(SOURCES)
	> $@
	for a in $(SOURCES); do echo "verilog work $$a" >> $@; done

$(XSTSCRIPT): $(XSTWORK)
	> $@
	echo -n "run -ifn $(XSTWORK) -ifmt mixed -top $(TOP) -ofn $(PROJECT).ngc" >> $@
	echo " -ofmt NGC -p $(PART) -opt_mode $(XST_OPT_MODE) -opt_level $(XST_OPT_LEVEL)" >> $@

%.ngc: $(XSTSCRIPT)
	$(XST) -ifn $<
	
%.ngd: %.ngc $(PROJECT).ucf
	$(NGDBUILD) -intstyle ise -dd _ngo -uc $(PROJECT).ucf -p $(PART) $*.ngc $*.ngd
	
%.map.ncd: %.ngd
	$(MAP) -o $@ $< $*.pcf

%.par.ncd: %.map.ncd
	$(PAR) -w -ol high $< $@ $*.pcf

%.bit: %.par.ncd
	$(BITGEN) -w -g UnusedPin:PullNone $< $@ $*.pcf

%.prm: %.bit
	$(PROMGEN) -o $@ -w -u 0  $<

############################################################################
# End
############################################################################
	
