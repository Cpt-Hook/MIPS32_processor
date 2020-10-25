.phony: clean, compile, simulate

simulate: test  # will start gtkwave with simulation of the processor
	gtkwave test

assemble_processor: processor.v

test: testbench.out
	./testbench.out

testbench.out: processor.v testbench.v
	iverilog processor.v testbench.v -o testbench.out

processor.v: components/alu.v components/control_unit.v components/register_block.v components/processor.v
	cat components/* > processor.v

clean:
	rm -f processor.v testbench.out test
