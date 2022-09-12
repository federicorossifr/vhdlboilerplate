BUILD_DIR=$(shell pwd)/build
SRC_DIR=$(shell pwd)/src
INC_DIR=$(shell pwd)/include

TEST_DIR=$(shell pwd)/tests
INC_DIR=$(shell pwd)/include
OUT=wave.vcd
GHDL_FLAGS=--std=08


definitions: $(INC_DIR)/definitions.vhd
	cd $(BUILD_DIR); ghdl  -a $(GHDL_FLAGS) $< 

full_adder: $(SRC_DIR)/full_adder.vhd
	cd $(BUILD_DIR); ghdl  -a $(GHDL_FLAGS) $< 

nregister: $(SRC_DIR)/nregister.vhd
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $< 


register_file: $(SRC_DIR)/register_file.vhd nregister definitions
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $< 

stage: $(SRC_DIR)/stage.vhd nregister
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $< 

full_adder.e: full_adder
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS)  $<

nregister.e: nregister
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS) $<

register_file.e: register_file nregister.e
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS)  $<

stage.e: stage nregister.e
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS)  $<

full_adder_tb: $(TEST_DIR)/full_adder_tb.vhd
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $<

nregister_tb: $(TEST_DIR)/nregister_tb.vhd
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $<

stage_tb: $(TEST_DIR)/stage_tb.vhd
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $<

register_file_tb: $(TEST_DIR)/register_file_tb.vhd
	cd $(BUILD_DIR); ghdl -a $(GHDL_FLAGS) $<

full_adder_tb.e: full_adder_tb
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS) $<

nregister_tb.e: nregister_tb
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS) $<

register_file_tb.e: register_file_tb register_file
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS) $<

stage_tb.e: stage_tb stage
	cd $(BUILD_DIR); ghdl -e $(GHDL_FLAGS) $<


workdir:
	mkdir -p $(BUILD_DIR)

all: workdir full_adder.e full_adder_tb.e  nregister.e nregister_tb.e register_file_tb.e stage_tb.e

run: all
	cd $(BUILD_DIR); ghdl run $(GHDL_FLAGS)  $(TOP) $(FLAGS)

wave: all
	cd $(BUILD_DIR); ghdl run $(GHDL_FLAGS) $(TOP)  $(FLAGS) --vcd=$(OUT)

clean:
	rm -rf $(BUILD_DIR)


