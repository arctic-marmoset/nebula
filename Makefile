OUTDIR = out

PROJECT = nebula
TOP = core_tb

TEST_NAME ?= add.S
TEST_PATH := $(CURDIR)/test/input/$(TEST_NAME).hex
TEST_SIZE := $(shell wc -l < "$(TEST_PATH)")

$(info "TEST_NAME = ${TEST_NAME}")
$(info "TEST_PATH = ${TEST_PATH}")
$(info "TEST_SIZE = ${TEST_SIZE}")

# NOTE: Order is important. Packages that are imported must come first.
RTL =                     \
	rtl/types.sv      \
	rtl/opcodes.sv    \
	rtl/assembly.sv   \
	rtl/addressing.sv \
	rtl/pc.sv         \
	rtl/fetch.sv      \
	rtl/decode.sv     \
	rtl/imm_gen.sv    \
	rtl/regfile.sv    \
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

ifdef NDEBUG
ICARUSFLAGS += -DNDEBUG
endif

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
