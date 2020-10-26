.phony: clean, compile, simulate

simulate: test  # starts gtkwave with simulation of the processor
	gtkwave test

assemble_processor: processor.v # assembles processor.v ready for submission (or compilation)

test: testbench.out memfile_inst.hex memfile_data.hex
	./testbench.out

testbench.out: processor.v testbench.v
	iverilog processor.v testbench.v -o testbench.out

processor.v: components/processor.v components/alu.v components/control_unit.v components/register_block.v components/sign_extender_16_32.v components/multiplier4.v components/adder.v components/register.v components/pc_multiplexor.v components/multiplexer2_1.v
	cat $^ > processor.v

clean:
	rm -f processor.v testbench.out test
