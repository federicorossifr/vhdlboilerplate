BUILD_DIR=$(shell pwd)/build
SRC_DIR=$(shell pwd)/src
TEST_DIR=$(shell pwd)/tests
INC_DIR=$(shell pwd)/include
OUT=wave.vcd

full_adder: $(SRC_DIR)/full_adder.vhd
	cd $(BUILD_DIR); ghdl -a $<

full_adder.e: full_adder
	cd $(BUILD_DIR); ghdl -e $<

full_adder_tb: $(TEST_DIR)/full_adder_tb.vhd
	cd $(BUILD_DIR); ghdl -a $<

full_adder_tb.e: full_adder_tb
	cd $(BUILD_DIR); ghdl -e $<

workdir:
	mkdir -p $(BUILD_DIR)

all: workdir full_adder.e full_adder_tb.e 

run: all
	cd $(BUILD_DIR); ghdl run $(TOP)

wave: all
	cd $(BUILD_DIR); ghdl run $(TOP) --vcd=$(OUT)

clean:
	rm -rf $(BUILD_DIR)


