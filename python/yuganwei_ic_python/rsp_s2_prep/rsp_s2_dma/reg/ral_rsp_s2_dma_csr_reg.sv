`ifndef RAL_RSP_S2_DMA_CSR_REG
`define RAL_RSP_S2_DMA_CSR_REG

import uvm_pkg::*;

class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM0 extends uvm_reg;
	rand uvm_reg_field SLEN;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SLEN = uvm_reg_field::type_id::create("SLEN",,get_full_name());
      this.SLEN.configure(this, 16, 0, "RW", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM0)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM0


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM1 extends uvm_reg;
	rand uvm_reg_field SCNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SCNT = uvm_reg_field::type_id::create("SCNT",,get_full_name());
      this.SCNT.configure(this, 14, 0, "RW", 0, 14'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM1)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM1


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM2 extends uvm_reg;
	rand uvm_reg_field FCNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM2");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FCNT = uvm_reg_field::type_id::create("FCNT",,get_full_name());
      this.FCNT.configure(this, 14, 0, "RW", 0, 14'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM2)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM2


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM3 extends uvm_reg;
	rand uvm_reg_field PCNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM3");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.PCNT = uvm_reg_field::type_id::create("PCNT",,get_full_name());
      this.PCNT.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM3)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM3


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM4 extends uvm_reg;
	rand uvm_reg_field OUTS_MAX;
	rand uvm_reg_field BURST_LEN;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM4");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.OUTS_MAX = uvm_reg_field::type_id::create("OUTS_MAX",,get_full_name());
      this.OUTS_MAX.configure(this, 8, 8, "RW", 0, 8'h0, 1, 0, 1);
      this.BURST_LEN = uvm_reg_field::type_id::create("BURST_LEN",,get_full_name());
      this.BURST_LEN.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM4)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM4


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM5 extends uvm_reg;
	rand uvm_reg_field GM5;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM5");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.GM5 = uvm_reg_field::type_id::create("GM5",,get_full_name());
      this.GM5.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM5)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM5


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM6 extends uvm_reg;
	rand uvm_reg_field GM6;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM6");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.GM6 = uvm_reg_field::type_id::create("GM6",,get_full_name());
      this.GM6.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM6)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM6


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM7 extends uvm_reg;
	rand uvm_reg_field GM7;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM7");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.GM7 = uvm_reg_field::type_id::create("GM7",,get_full_name());
      this.GM7.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM7)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM7


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM8 extends uvm_reg;
	rand uvm_reg_field TIMEOUT_CNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM8");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TIMEOUT_CNT = uvm_reg_field::type_id::create("TIMEOUT_CNT",,get_full_name());
      this.TIMEOUT_CNT.configure(this, 12, 0, "RW", 0, 12'h7ff, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM8)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM8


class ral_reg_m_map0_rsp_s2_dma_csr_reg_GM9 extends uvm_reg;
	rand uvm_reg_field AXI_ID;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_GM9");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.AXI_ID = uvm_reg_field::type_id::create("AXI_ID",,get_full_name());
      this.AXI_ID.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_GM9)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_GM9


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM0 extends uvm_reg;
	rand uvm_reg_field SLEN;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SLEN = uvm_reg_field::type_id::create("SLEN",,get_full_name());
      this.SLEN.configure(this, 16, 0, "RW", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM0)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM0


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM1 extends uvm_reg;
	rand uvm_reg_field SCNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SCNT = uvm_reg_field::type_id::create("SCNT",,get_full_name());
      this.SCNT.configure(this, 14, 0, "RW", 0, 14'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM1)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM1


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM2 extends uvm_reg;
	rand uvm_reg_field FCNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM2");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FCNT = uvm_reg_field::type_id::create("FCNT",,get_full_name());
      this.FCNT.configure(this, 14, 0, "RW", 0, 14'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM2)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM2


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM3 extends uvm_reg;
	rand uvm_reg_field PCNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM3");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.PCNT = uvm_reg_field::type_id::create("PCNT",,get_full_name());
      this.PCNT.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM3)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM3


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM4 extends uvm_reg;
	rand uvm_reg_field OUTS_MAX;
	rand uvm_reg_field BURST_LEN;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM4");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.OUTS_MAX = uvm_reg_field::type_id::create("OUTS_MAX",,get_full_name());
      this.OUTS_MAX.configure(this, 8, 8, "RW", 0, 8'h0, 1, 0, 1);
      this.BURST_LEN = uvm_reg_field::type_id::create("BURST_LEN",,get_full_name());
      this.BURST_LEN.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM4)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM4


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM5 extends uvm_reg;
	rand uvm_reg_field BASE_ADDR;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM5");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.BASE_ADDR = uvm_reg_field::type_id::create("BASE_ADDR",,get_full_name());
      this.BASE_ADDR.configure(this, 28, 0, "RW", 0, 28'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM5)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM5


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM6 extends uvm_reg;
	rand uvm_reg_field SIDX;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM6");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.SIDX = uvm_reg_field::type_id::create("SIDX",,get_full_name());
      this.SIDX.configure(this, 28, 0, "RW", 0, 28'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM6)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM6


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM7 extends uvm_reg;
	rand uvm_reg_field FIDX;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM7");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FIDX = uvm_reg_field::type_id::create("FIDX",,get_full_name());
      this.FIDX.configure(this, 28, 0, "RW", 0, 28'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM7)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM7


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM8 extends uvm_reg;
	rand uvm_reg_field TIMEOUT_CNT;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM8");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TIMEOUT_CNT = uvm_reg_field::type_id::create("TIMEOUT_CNT",,get_full_name());
      this.TIMEOUT_CNT.configure(this, 12, 0, "RW", 0, 12'h7ff, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM8)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM8


class ral_reg_m_map0_rsp_s2_dma_csr_reg_LM9 extends uvm_reg;
	rand uvm_reg_field AXI_ID;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_LM9");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.AXI_ID = uvm_reg_field::type_id::create("AXI_ID",,get_full_name());
      this.AXI_ID.configure(this, 8, 0, "RW", 0, 8'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_LM9)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_LM9


class ral_reg_m_map0_rsp_s2_dma_csr_reg_EN extends uvm_reg;
	rand uvm_reg_field DECOMP;
	rand uvm_reg_field INDEX;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_EN");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DECOMP = uvm_reg_field::type_id::create("DECOMP",,get_full_name());
      this.DECOMP.configure(this, 1, 8, "RW", 0, 1'h0, 1, 0, 1);
      this.INDEX = uvm_reg_field::type_id::create("INDEX",,get_full_name());
      this.INDEX.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_EN)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_EN


class ral_reg_m_map0_rsp_s2_dma_csr_reg_INDEX extends uvm_reg;
	rand uvm_reg_field BASE_ADDR;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_INDEX");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.BASE_ADDR = uvm_reg_field::type_id::create("BASE_ADDR",,get_full_name());
      this.BASE_ADDR.configure(this, 28, 0, "RW", 0, 28'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_INDEX)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_INDEX


class ral_reg_m_map0_rsp_s2_dma_csr_reg_FSM extends uvm_reg;
	rand uvm_reg_field MEM_CLAIM;
	rand uvm_reg_field MEM_PIPO_NUM_WR;
	rand uvm_reg_field MEM_PIPO_NUM_RD;
	rand uvm_reg_field MEM_BASE_IDX_WR;
	rand uvm_reg_field MEM_BASE_IDX_RD;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg_FSM");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.MEM_CLAIM = uvm_reg_field::type_id::create("MEM_CLAIM",,get_full_name());
      this.MEM_CLAIM.configure(this, 1, 16, "RW", 0, 1'h0, 1, 0, 1);
      this.MEM_PIPO_NUM_WR = uvm_reg_field::type_id::create("MEM_PIPO_NUM_WR",,get_full_name());
      this.MEM_PIPO_NUM_WR.configure(this, 3, 13, "RW", 0, 3'h0, 1, 0, 0);
      this.MEM_PIPO_NUM_RD = uvm_reg_field::type_id::create("MEM_PIPO_NUM_RD",,get_full_name());
      this.MEM_PIPO_NUM_RD.configure(this, 3, 10, "RW", 0, 3'h0, 1, 0, 0);
      this.MEM_BASE_IDX_WR = uvm_reg_field::type_id::create("MEM_BASE_IDX_WR",,get_full_name());
      this.MEM_BASE_IDX_WR.configure(this, 5, 5, "RW", 0, 5'h0, 1, 0, 0);
      this.MEM_BASE_IDX_RD = uvm_reg_field::type_id::create("MEM_BASE_IDX_RD",,get_full_name());
      this.MEM_BASE_IDX_RD.configure(this, 5, 0, "RW", 0, 5'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_csr_reg_FSM)

endclass : ral_reg_m_map0_rsp_s2_dma_csr_reg_FSM


class ral_block_m_map0_rsp_s2_dma_csr_reg extends uvm_reg_block;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM0 GM0;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM1 GM1;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM2 GM2;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM3 GM3;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM4 GM4;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM5 GM5;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM6 GM6;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM7 GM7;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM8 GM8;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_GM9 GM9;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM0 LM0;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM1 LM1;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM2 LM2;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM3 LM3;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM4 LM4;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM5 LM5;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM6 LM6;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM7 LM7;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM8 LM8;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_LM9 LM9;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_EN EN;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_INDEX INDEX;
	rand ral_reg_m_map0_rsp_s2_dma_csr_reg_FSM FSM;
	rand uvm_reg_field GM0_SLEN;
	rand uvm_reg_field GM1_SCNT;
	rand uvm_reg_field GM2_FCNT;
	rand uvm_reg_field GM3_PCNT;
	rand uvm_reg_field GM4_OUTS_MAX;
	rand uvm_reg_field GM4_BURST_LEN;
	rand uvm_reg_field GM5_GM5;
	rand uvm_reg_field GM6_GM6;
	rand uvm_reg_field GM7_GM7;
	rand uvm_reg_field GM8_TIMEOUT_CNT;
	rand uvm_reg_field GM9_AXI_ID;
	rand uvm_reg_field LM0_SLEN;
	rand uvm_reg_field LM1_SCNT;
	rand uvm_reg_field LM2_FCNT;
	rand uvm_reg_field LM3_PCNT;
	rand uvm_reg_field LM4_OUTS_MAX;
	rand uvm_reg_field LM4_BURST_LEN;
	rand uvm_reg_field LM5_BASE_ADDR;
	rand uvm_reg_field LM6_SIDX;
	rand uvm_reg_field SIDX;
	rand uvm_reg_field LM7_FIDX;
	rand uvm_reg_field FIDX;
	rand uvm_reg_field LM8_TIMEOUT_CNT;
	rand uvm_reg_field LM9_AXI_ID;
	rand uvm_reg_field EN_DECOMP;
	rand uvm_reg_field DECOMP;
	rand uvm_reg_field EN_INDEX;
	rand uvm_reg_field INDEX_BASE_ADDR;
	rand uvm_reg_field FSM_MEM_CLAIM;
	rand uvm_reg_field MEM_CLAIM;
	rand uvm_reg_field FSM_MEM_PIPO_NUM_WR;
	rand uvm_reg_field MEM_PIPO_NUM_WR;
	rand uvm_reg_field FSM_MEM_PIPO_NUM_RD;
	rand uvm_reg_field MEM_PIPO_NUM_RD;
	rand uvm_reg_field FSM_MEM_BASE_IDX_WR;
	rand uvm_reg_field MEM_BASE_IDX_WR;
	rand uvm_reg_field FSM_MEM_BASE_IDX_RD;
	rand uvm_reg_field MEM_BASE_IDX_RD;

	function new(string name = "m_map0_rsp_s2_dma_csr_reg");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.GM0 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM0::type_id::create("GM0",,get_full_name());
      this.GM0.configure(this, null, "");
      this.GM0.build();
      this.default_map.add_reg(this.GM0, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.GM0_SLEN = this.GM0.SLEN;
      this.GM1 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM1::type_id::create("GM1",,get_full_name());
      this.GM1.configure(this, null, "");
      this.GM1.build();
      this.default_map.add_reg(this.GM1, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.GM1_SCNT = this.GM1.SCNT;
      this.GM2 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM2::type_id::create("GM2",,get_full_name());
      this.GM2.configure(this, null, "");
      this.GM2.build();
      this.default_map.add_reg(this.GM2, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.GM2_FCNT = this.GM2.FCNT;
      this.GM3 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM3::type_id::create("GM3",,get_full_name());
      this.GM3.configure(this, null, "");
      this.GM3.build();
      this.default_map.add_reg(this.GM3, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.GM3_PCNT = this.GM3.PCNT;
      this.GM4 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM4::type_id::create("GM4",,get_full_name());
      this.GM4.configure(this, null, "");
      this.GM4.build();
      this.default_map.add_reg(this.GM4, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.GM4_OUTS_MAX = this.GM4.OUTS_MAX;
		this.GM4_BURST_LEN = this.GM4.BURST_LEN;
      this.GM5 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM5::type_id::create("GM5",,get_full_name());
      this.GM5.configure(this, null, "");
      this.GM5.build();
      this.default_map.add_reg(this.GM5, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.GM5_GM5 = this.GM5.GM5;
      this.GM6 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM6::type_id::create("GM6",,get_full_name());
      this.GM6.configure(this, null, "");
      this.GM6.build();
      this.default_map.add_reg(this.GM6, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.GM6_GM6 = this.GM6.GM6;
      this.GM7 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM7::type_id::create("GM7",,get_full_name());
      this.GM7.configure(this, null, "");
      this.GM7.build();
      this.default_map.add_reg(this.GM7, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
		this.GM7_GM7 = this.GM7.GM7;
      this.GM8 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM8::type_id::create("GM8",,get_full_name());
      this.GM8.configure(this, null, "");
      this.GM8.build();
      this.default_map.add_reg(this.GM8, `UVM_REG_ADDR_WIDTH'h20, "RW", 0);
		this.GM8_TIMEOUT_CNT = this.GM8.TIMEOUT_CNT;
      this.GM9 = ral_reg_m_map0_rsp_s2_dma_csr_reg_GM9::type_id::create("GM9",,get_full_name());
      this.GM9.configure(this, null, "");
      this.GM9.build();
      this.default_map.add_reg(this.GM9, `UVM_REG_ADDR_WIDTH'h24, "RW", 0);
		this.GM9_AXI_ID = this.GM9.AXI_ID;
      this.LM0 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM0::type_id::create("LM0",,get_full_name());
      this.LM0.configure(this, null, "");
      this.LM0.build();
      this.default_map.add_reg(this.LM0, `UVM_REG_ADDR_WIDTH'h30, "RW", 0);
		this.LM0_SLEN = this.LM0.SLEN;
      this.LM1 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM1::type_id::create("LM1",,get_full_name());
      this.LM1.configure(this, null, "");
      this.LM1.build();
      this.default_map.add_reg(this.LM1, `UVM_REG_ADDR_WIDTH'h34, "RW", 0);
		this.LM1_SCNT = this.LM1.SCNT;
      this.LM2 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM2::type_id::create("LM2",,get_full_name());
      this.LM2.configure(this, null, "");
      this.LM2.build();
      this.default_map.add_reg(this.LM2, `UVM_REG_ADDR_WIDTH'h38, "RW", 0);
		this.LM2_FCNT = this.LM2.FCNT;
      this.LM3 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM3::type_id::create("LM3",,get_full_name());
      this.LM3.configure(this, null, "");
      this.LM3.build();
      this.default_map.add_reg(this.LM3, `UVM_REG_ADDR_WIDTH'h3C, "RW", 0);
		this.LM3_PCNT = this.LM3.PCNT;
      this.LM4 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM4::type_id::create("LM4",,get_full_name());
      this.LM4.configure(this, null, "");
      this.LM4.build();
      this.default_map.add_reg(this.LM4, `UVM_REG_ADDR_WIDTH'h40, "RW", 0);
		this.LM4_OUTS_MAX = this.LM4.OUTS_MAX;
		this.LM4_BURST_LEN = this.LM4.BURST_LEN;
      this.LM5 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM5::type_id::create("LM5",,get_full_name());
      this.LM5.configure(this, null, "");
      this.LM5.build();
      this.default_map.add_reg(this.LM5, `UVM_REG_ADDR_WIDTH'h44, "RW", 0);
		this.LM5_BASE_ADDR = this.LM5.BASE_ADDR;
      this.LM6 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM6::type_id::create("LM6",,get_full_name());
      this.LM6.configure(this, null, "");
      this.LM6.build();
      this.default_map.add_reg(this.LM6, `UVM_REG_ADDR_WIDTH'h48, "RW", 0);
		this.LM6_SIDX = this.LM6.SIDX;
		this.SIDX = this.LM6.SIDX;
      this.LM7 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM7::type_id::create("LM7",,get_full_name());
      this.LM7.configure(this, null, "");
      this.LM7.build();
      this.default_map.add_reg(this.LM7, `UVM_REG_ADDR_WIDTH'h4C, "RW", 0);
		this.LM7_FIDX = this.LM7.FIDX;
		this.FIDX = this.LM7.FIDX;
      this.LM8 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM8::type_id::create("LM8",,get_full_name());
      this.LM8.configure(this, null, "");
      this.LM8.build();
      this.default_map.add_reg(this.LM8, `UVM_REG_ADDR_WIDTH'h50, "RW", 0);
		this.LM8_TIMEOUT_CNT = this.LM8.TIMEOUT_CNT;
      this.LM9 = ral_reg_m_map0_rsp_s2_dma_csr_reg_LM9::type_id::create("LM9",,get_full_name());
      this.LM9.configure(this, null, "");
      this.LM9.build();
      this.default_map.add_reg(this.LM9, `UVM_REG_ADDR_WIDTH'h54, "RW", 0);
		this.LM9_AXI_ID = this.LM9.AXI_ID;
      this.EN = ral_reg_m_map0_rsp_s2_dma_csr_reg_EN::type_id::create("EN",,get_full_name());
      this.EN.configure(this, null, "");
      this.EN.build();
      this.default_map.add_reg(this.EN, `UVM_REG_ADDR_WIDTH'h58, "RW", 0);
		this.EN_DECOMP = this.EN.DECOMP;
		this.DECOMP = this.EN.DECOMP;
		this.EN_INDEX = this.EN.INDEX;
      this.INDEX = ral_reg_m_map0_rsp_s2_dma_csr_reg_INDEX::type_id::create("INDEX",,get_full_name());
      this.INDEX.configure(this, null, "");
      this.INDEX.build();
      this.default_map.add_reg(this.INDEX, `UVM_REG_ADDR_WIDTH'h5C, "RW", 0);
		this.INDEX_BASE_ADDR = this.INDEX.BASE_ADDR;
      this.FSM = ral_reg_m_map0_rsp_s2_dma_csr_reg_FSM::type_id::create("FSM",,get_full_name());
      this.FSM.configure(this, null, "");
      this.FSM.build();
      this.default_map.add_reg(this.FSM, `UVM_REG_ADDR_WIDTH'h60, "RW", 0);
		this.FSM_MEM_CLAIM = this.FSM.MEM_CLAIM;
		this.MEM_CLAIM = this.FSM.MEM_CLAIM;
		this.FSM_MEM_PIPO_NUM_WR = this.FSM.MEM_PIPO_NUM_WR;
		this.MEM_PIPO_NUM_WR = this.FSM.MEM_PIPO_NUM_WR;
		this.FSM_MEM_PIPO_NUM_RD = this.FSM.MEM_PIPO_NUM_RD;
		this.MEM_PIPO_NUM_RD = this.FSM.MEM_PIPO_NUM_RD;
		this.FSM_MEM_BASE_IDX_WR = this.FSM.MEM_BASE_IDX_WR;
		this.MEM_BASE_IDX_WR = this.FSM.MEM_BASE_IDX_WR;
		this.FSM_MEM_BASE_IDX_RD = this.FSM.MEM_BASE_IDX_RD;
		this.MEM_BASE_IDX_RD = this.FSM.MEM_BASE_IDX_RD;
	  uvm_config_db #(uvm_reg_block)::set(null,"","RegisterModel_Debug",this);
   endfunction : build

	`uvm_object_utils(ral_block_m_map0_rsp_s2_dma_csr_reg)

endclass : ral_block_m_map0_rsp_s2_dma_csr_reg



`endif
