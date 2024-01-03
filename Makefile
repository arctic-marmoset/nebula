OUTDIR = out

PROJECT = nebula

RTLDIR = rtl
SIMDIR = sim
TOP = core_tb

SRC = $(wildcard rtl/*.sv)

TEST_NAME ?= add.S
TEST_PATH := $(CURDIR)/test/$(TEST_NAME).hex
TEST_SIZE := $(shell wc -l < "$(TEST_PATH)")

MODULE_DIRS = \
	$(RTLDIR) \
	$(SIMDIR)

# TODO: Remove -Wno-fatal.
VERILATORFLAGS = \
	--binary \
	-Wall \
	-Wpedantic \
	-Wno-fatal \
	--trace-fst \
	--timescale 1ns/1ns \
	--Mdir $(OUTDIR) \
	$(addprefix -y , ${MODULE_DIRS})

VERILATORDEFINES := \
	-DTEST_PATH=\"$(TEST_PATH)\" \
	-DTEST_SIZE=$(TEST_SIZE)

ifdef SYNTEHSIS
VERILATORFLAGS += -DSYNTHESIS
endif

BINARY = V$(TOP)

all: $(OUTDIR)/$(PROJECT).fst

$(OUTDIR)/$(PROJECT).fst: $(OUTDIR)/$(BINARY)
	$(info TEST_NAME = ${TEST_NAME})
	$(info TEST_PATH = ${TEST_PATH})
	$(info TEST_SIZE = ${TEST_SIZE} Bytes)
	$(OUTDIR)/$(BINARY)
	mv $(PROJECT).fst $(OUTDIR)

$(OUTDIR)/$(BINARY): $(SRC)
	verilator $(VERILATORFLAGS) $(VERILATORDEFINES) $(TOP).sv

clean:
	rm -rf $(OUTDIR)

.PHONY: all clean debug
