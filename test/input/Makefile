CC = riscv64-elf-gcc
OBJCOPY = riscv64-elf-objcopy
OBJDUMP = riscv64-elf-objdump
OD = od

SOURCES = $(filter-out startup.S,$(wildcard *.S)) $(wildcard *.cpp)
OBJECTS := $(addsuffix .o,$(SOURCES))
BINARIES := $(addsuffix .bin,$(SOURCES))
HEXFILES := $(addsuffix .hex,$(SOURCES))
DISASSEMBLIES := $(addsuffix .ds,$(SOURCES))

LDSCRIPT = nebula.ld

CFLAGS :=           \
	-Wall           \
	-Wextra         \
	-Wpedantic      \
	-march=rv32i    \
	-mabi=ilp32     \
	-mcmodel=medany \
	-static         \
	-nostartfiles   \
	-nostdlib       \
	-g              \
	-Os             \
	-T$(LDSCRIPT)

all: $(OBJECTS) $(BINARIES) $(HEXFILES) $(DISASSEMBLIES)

%.S.o: %.S
	$(CC) $(CFLAGS) $^ -o $@

%.cpp.o: %.cpp
	$(CC) $(CFLAGS) startup.S $^ -o $@

%.S.bin: %.S.o
	$(OBJCOPY) -O binary --only-section=.text $^ $@

%.cpp.bin: %.cpp.o
	$(OBJCOPY) -O binary --only-section=.text $^ $@

%.S.hex: %.S.bin
	$(OD) -An -v -w1 -tx1 $^ | tr -d ' ' > $@

%.cpp.hex: %.cpp.bin
	$(OD) -An -v -w1 -tx1 $^ | tr -d ' ' > $@

%.S.ds: %.S.o
	$(OBJDUMP) -rDC $^ > $@

%.cpp.ds: %.cpp.o
	$(OBJDUMP) -rDC $^ > $@

clean:
	rm -rf $(OBJECTS) $(BINARIES) $(HEXFILES) $(DISASSEMBLIES)

.PHONY: all clean
