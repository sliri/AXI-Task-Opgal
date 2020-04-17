## AXI Task Opgal ##
This GitHub project includes the solution for the OPGAL AXI tranlator home task 

## Files and Directories ##
1.AXI Docs- This dirctory with the AXI relevant documents form Xilinx and ARM.

2.FIFO_AXI/FIFO_AXI.srcs - this directory inclues the source files (*.vhd) of the implementation of the reading FSM.

**Source files included:**

  1. consts_pack.vhd - consts package
  2. types_pack.vhd - types package
  3. data_read_translator.vhd - the FSM
  4. double_sampler.vhd - a component that simply samples inputs.
  5. global_signals_translator.vhd - generates reset signals for the design
  6. data_rd_translator_tb.vhd - a small testbench that was used in simulation

3. FIFO_AXI.xpr.zip. - The VIVADO project archive, may be used for simulation. (I used VIAVADO simulator since I can't install modelsim trial version on my Linux machine). The archive may contain some redundant source files. 

4.RDD.pdf - A requirements and design document. The design document, contains all the info regarding to the logic design.

5.README.md -This readme



