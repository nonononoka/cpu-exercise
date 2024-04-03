H3_CYGWIN_MODELSIM_PATH = /home/nonoka/intelFPGA/20.1/modelsim_ase/bin
VLOG = $(H3_CYGWIN_MODELSIM_PATH)/vlog
VLIB = $(H3_CYGWIN_MODELSIM_PATH)/vlib
VSIM = $(H3_CYGWIN_MODELSIM_PATH)/vsim -c
MODELSIM = $(H3_CYGWIN_MODELSIM_PATH)/qhsim

PROJECT_WORK = ModelSim
LIBRARY_WORK = $(PROJECT_WORK)/$(LIBRARY_NAME)


# Library name and top-level module to be simulated
LIBRARY_NAME    = H3_Modules
TOPLEVEL_MODULE = H3_MainSim

# Specify source files
SOURCES = \
	CPU.v \
	DMem.v \
	IMem.v \
	Main.v \
	IOCtrl.v \
	LEDDrv.v \
	MainSim.v \
	Decoder.v \
	ALU.v \
	RegisterFile.v \
	PC.v \
	Stage1_IFID.v \
	Stage2_IDEX.v \
	Stage3_EXMEM.v \
	Stage4_MEMWB.v \

DEPS = \
	$(SOURCES) \

#	+incdir+../../Src 

OPTIONS = \
	-lint \
	-pedanticerrors \
	+librescan \
	-sv -nocovercells \
	-work $(LIBRARY_WORK) \
	#-incr \

all: $(DEPS) $(LIBRARY_WORK)
	$(VLOG) $(OPTIONS) $(SOURCES)


# vlib LIBRARY
clean:
	mkdir $(PROJECT_WORK) -p
	rm -f -r $(LIBRARY_WORK)
	( cd $(PROJECT_WORK); $(VLIB) $(LIBRARY_NAME); )

lib: clean

$(LIBRARY_WORK): Makefile
	make clean

# simulation
# vsim LIBRARY -do "run -all"
sim: 
	( cd $(PROJECT_WORK); $(VSIM) $(LIBRARY_NAME).$(TOPLEVEL_MODULE) -do "run -all"; )

# GUI simulation
sim-gui: 
	( cd $(PROJECT_WORK); $(MODELSIM) $(LIBRARY_NAME).$(TOPLEVEL_MODULE) -do "do wave.do;"; )


#	( cd $(WORK); $(VLOG) $(OPTIONS) $(DEPS); )


