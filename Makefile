.phony: clean, compile, simulate

simulate: test  # starts gtkwave with simulation of the processor
	gtkwave test

assemble_processor: processor.v # assembles processor.v ready for submission (or compilation)

test: testbench.out
	./testbench.out

testbench.out: processor.v testbench.v
	iverilog processor.v testbench.v -o testbench.out

processor.v: components/processor.v components/alu.v components/control_unit.v components/register_block.v
	cat $^ > processor.v

clean:
	rm -f processor.v testbench.out test
