OUTDIR = out

PROJECT = nebula
TOP = core_tb

TEST_NAME ?= nop.S
TEST_PATH := $(CURDIR)/test/input/$(TEST_NAME).hex
TEST_SIZE := $(shell wc -l < "$(TEST_PATH)")

# NOTE: Order is important. Packages that are imported must come first.
RTL =                  \
	rtl/types.sv   \
	rtl/pc.sv      \
	rtl/fetch.sv   \
	rtl/regfile.sv \
	rtl/core.sv

TEST =                   \
	test/clockgen.sv \
	test/core_tb.sv

SOURCES :=      \
	$(RTL)  \
	$(TEST)

ICARUSFLAGS =          \
	-g2012         \
	-gassertions   \
	-Wall          \
	-Wno-timescale

ICARUSDEFINES :=                     \
	-DTEST_PATH=\"$(TEST_PATH)\" \
	-DTEST_SIZE=$(TEST_SIZE)

all: $(OUTDIR)/$(PROJECT).vcd

debug: $(OUTDIR)/$(PROJECT)
	vvp -i -s -l $(OUTDIR)/icarus.log $^
	mv $(PROJECT).vcd $(OUTDIR)

$(OUTDIR)/$(PROJECT).vcd: $(OUTDIR)/$(PROJECT)
	vvp -n -l $(OUTDIR)/icarus.log $^ -fst
	mv $(PROJECT).vcd $(OUTDIR)

$(OUTDIR)/$(PROJECT): $(SOURCES) | $(OUTDIR)
	iverilog $(ICARUSFLAGS) $(ICARUSDEFINES) -s$(TOP) $^ -o $@

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)

.PHONY: all clean debug
