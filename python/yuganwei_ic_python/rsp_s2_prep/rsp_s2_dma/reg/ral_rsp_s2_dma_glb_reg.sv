`ifndef RAL_RSP_S2_DMA_GLB_REG
`define RAL_RSP_S2_DMA_GLB_REG

import uvm_pkg::*;

class ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_STATUS extends uvm_reg;
	rand uvm_reg_field FCNT_FINISH;
	rand uvm_reg_field PCNT_FINISH;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_IRQ_STATUS");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FCNT_FINISH = uvm_reg_field::type_id::create("FCNT_FINISH",,get_full_name());
      this.FCNT_FINISH.configure(this, 1, 1, "RW", 0, 1'h0, 1, 0, 0);
      this.PCNT_FINISH = uvm_reg_field::type_id::create("PCNT_FINISH",,get_full_name());
      this.PCNT_FINISH.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_STATUS)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_STATUS


class ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_MASK extends uvm_reg;
	rand uvm_reg_field FCNT_FINISH;
	rand uvm_reg_field PCNT_FINISH;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_IRQ_MASK");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FCNT_FINISH = uvm_reg_field::type_id::create("FCNT_FINISH",,get_full_name());
      this.FCNT_FINISH.configure(this, 1, 1, "RW", 0, 1'h0, 1, 0, 0);
      this.PCNT_FINISH = uvm_reg_field::type_id::create("PCNT_FINISH",,get_full_name());
      this.PCNT_FINISH.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_MASK)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_MASK


class ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_ENABLE extends uvm_reg;
	rand uvm_reg_field FCNT_FINISH;
	rand uvm_reg_field PCNT_FINISH;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_IRQ_ENABLE");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FCNT_FINISH = uvm_reg_field::type_id::create("FCNT_FINISH",,get_full_name());
      this.FCNT_FINISH.configure(this, 1, 1, "RW", 0, 1'h0, 1, 0, 0);
      this.PCNT_FINISH = uvm_reg_field::type_id::create("PCNT_FINISH",,get_full_name());
      this.PCNT_FINISH.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_ENABLE)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_ENABLE


class ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD0 extends uvm_reg;
	uvm_reg_field CS;
	uvm_reg_field TRIG_CS;
	uvm_reg_field TRIG_WORD_COUNTER;
	uvm_reg_field TTL;
	uvm_reg_field OP_ID;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_CMD0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CS = uvm_reg_field::type_id::create("CS",,get_full_name());
      this.CS.configure(this, 4, 24, "RO", 0, 4'h0, 1, 0, 1);
      this.TRIG_CS = uvm_reg_field::type_id::create("TRIG_CS",,get_full_name());
      this.TRIG_CS.configure(this, 3, 21, "RO", 0, 3'h0, 1, 0, 0);
      this.TRIG_WORD_COUNTER = uvm_reg_field::type_id::create("TRIG_WORD_COUNTER",,get_full_name());
      this.TRIG_WORD_COUNTER.configure(this, 4, 17, "RO", 0, 4'h0, 1, 0, 0);
      this.TTL = uvm_reg_field::type_id::create("TTL",,get_full_name());
      this.TTL.configure(this, 12, 5, "RO", 0, 12'h0, 1, 0, 0);
      this.OP_ID = uvm_reg_field::type_id::create("OP_ID",,get_full_name());
      this.OP_ID.configure(this, 5, 0, "RO", 0, 5'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD0)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD0


class ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD1 extends uvm_reg;
	uvm_reg_field TRIG_IN;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_CMD1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TRIG_IN = uvm_reg_field::type_id::create("TRIG_IN",,get_full_name());
      this.TRIG_IN.configure(this, 24, 0, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD1)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD1


class ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD2 extends uvm_reg;
	uvm_reg_field TRIG_OUT;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_CMD2");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TRIG_OUT = uvm_reg_field::type_id::create("TRIG_OUT",,get_full_name());
      this.TRIG_OUT.configure(this, 24, 0, "RO", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD2)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD2


class ral_reg_m_map0_rsp_s2_dma_glb_reg_SW0 extends uvm_reg;
	rand uvm_reg_field CMD_TTL;
	rand uvm_reg_field CMD_OP_ID;
	rand uvm_reg_field CMD_REQ;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_SW0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CMD_TTL = uvm_reg_field::type_id::create("CMD_TTL",,get_full_name());
      this.CMD_TTL.configure(this, 12, 6, "RW", 0, 12'h0, 1, 0, 0);
      this.CMD_OP_ID = uvm_reg_field::type_id::create("CMD_OP_ID",,get_full_name());
      this.CMD_OP_ID.configure(this, 5, 1, "RW", 0, 5'h0, 1, 0, 0);
      this.CMD_REQ = uvm_reg_field::type_id::create("CMD_REQ",,get_full_name());
      this.CMD_REQ.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_SW0)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_SW0


class ral_reg_m_map0_rsp_s2_dma_glb_reg_SW1 extends uvm_reg;
	rand uvm_reg_field CMD_TRIG_IN;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_SW1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CMD_TRIG_IN = uvm_reg_field::type_id::create("CMD_TRIG_IN",,get_full_name());
      this.CMD_TRIG_IN.configure(this, 24, 0, "RW", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_SW1)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_SW1


class ral_reg_m_map0_rsp_s2_dma_glb_reg_SW2 extends uvm_reg;
	rand uvm_reg_field CMD_TRIG_OUT;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_SW2");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.CMD_TRIG_OUT = uvm_reg_field::type_id::create("CMD_TRIG_OUT",,get_full_name());
      this.CMD_TRIG_OUT.configure(this, 24, 0, "RW", 0, 24'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_SW2)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_SW2


class ral_reg_m_map0_rsp_s2_dma_glb_reg_SW3 extends uvm_reg;
	rand uvm_reg_field MEM_ALLOC;
	rand uvm_reg_field FINISH_ACK;
	rand uvm_reg_field FINISH_REQ_MASK;
	rand uvm_reg_field START_FID;
	rand uvm_reg_field START_PIPO;
	rand uvm_reg_field START;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_SW3");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.MEM_ALLOC = uvm_reg_field::type_id::create("MEM_ALLOC",,get_full_name());
      this.MEM_ALLOC.configure(this, 1, 8, "RW", 0, 1'h0, 1, 0, 1);
      this.FINISH_ACK = uvm_reg_field::type_id::create("FINISH_ACK",,get_full_name());
      this.FINISH_ACK.configure(this, 1, 7, "RW", 0, 1'h0, 1, 0, 0);
      this.FINISH_REQ_MASK = uvm_reg_field::type_id::create("FINISH_REQ_MASK",,get_full_name());
      this.FINISH_REQ_MASK.configure(this, 1, 6, "RW", 0, 1'h0, 1, 0, 0);
      this.START_FID = uvm_reg_field::type_id::create("START_FID",,get_full_name());
      this.START_FID.configure(this, 2, 4, "RW", 0, 2'h0, 1, 0, 0);
      this.START_PIPO = uvm_reg_field::type_id::create("START_PIPO",,get_full_name());
      this.START_PIPO.configure(this, 3, 1, "RW", 0, 3'h0, 1, 0, 0);
      this.START = uvm_reg_field::type_id::create("START",,get_full_name());
      this.START.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_SW3)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_SW3


class ral_reg_m_map0_rsp_s2_dma_glb_reg_FIDX extends uvm_reg;
	rand uvm_reg_field DATA;
	rand uvm_reg_field EN;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_FIDX");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.DATA = uvm_reg_field::type_id::create("DATA",,get_full_name());
      this.DATA.configure(this, 8, 8, "RW", 0, 8'h0, 1, 0, 1);
      this.EN = uvm_reg_field::type_id::create("EN",,get_full_name());
      this.EN.configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_FIDX)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_FIDX


class ral_reg_m_map0_rsp_s2_dma_glb_reg_STS0 extends uvm_reg;
	uvm_reg_field TTL_COUNTER;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_STS0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.TTL_COUNTER = uvm_reg_field::type_id::create("TTL_COUNTER",,get_full_name());
      this.TTL_COUNTER.configure(this, 12, 0, "RO", 0, 12'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_STS0)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_STS0


class ral_reg_m_map0_rsp_s2_dma_glb_reg_STS1 extends uvm_reg;
	uvm_reg_field RC_UPDATE;
	uvm_reg_field RC_RESUME;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_STS1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.RC_UPDATE = uvm_reg_field::type_id::create("RC_UPDATE",,get_full_name());
      this.RC_UPDATE.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
      this.RC_RESUME = uvm_reg_field::type_id::create("RC_RESUME",,get_full_name());
      this.RC_RESUME.configure(this, 16, 0, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_STS1)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_STS1


class ral_reg_m_map0_rsp_s2_dma_glb_reg_STS2 extends uvm_reg;
	uvm_reg_field WC_UPDATE;
	uvm_reg_field WC_RESUME;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg_STS2");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.WC_UPDATE = uvm_reg_field::type_id::create("WC_UPDATE",,get_full_name());
      this.WC_UPDATE.configure(this, 16, 16, "RO", 0, 16'h0, 1, 0, 1);
      this.WC_RESUME = uvm_reg_field::type_id::create("WC_RESUME",,get_full_name());
      this.WC_RESUME.configure(this, 16, 0, "RO", 0, 16'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_dma_glb_reg_STS2)

endclass : ral_reg_m_map0_rsp_s2_dma_glb_reg_STS2


class ral_block_m_map0_rsp_s2_dma_glb_reg extends uvm_reg_block;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_STATUS IRQ_STATUS;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_MASK IRQ_MASK;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_ENABLE IRQ_ENABLE;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD0 CMD0;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD1 CMD1;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD2 CMD2;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_SW0 SW0;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_SW1 SW1;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_SW2 SW2;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_SW3 SW3;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_FIDX FIDX;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_STS0 STS0;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_STS1 STS1;
	rand ral_reg_m_map0_rsp_s2_dma_glb_reg_STS2 STS2;
	rand uvm_reg_field IRQ_STATUS_FCNT_FINISH;
	rand uvm_reg_field IRQ_STATUS_PCNT_FINISH;
	rand uvm_reg_field IRQ_MASK_FCNT_FINISH;
	rand uvm_reg_field IRQ_MASK_PCNT_FINISH;
	rand uvm_reg_field IRQ_ENABLE_FCNT_FINISH;
	rand uvm_reg_field IRQ_ENABLE_PCNT_FINISH;
	uvm_reg_field CMD0_CS;
	uvm_reg_field CS;
	uvm_reg_field CMD0_TRIG_CS;
	uvm_reg_field TRIG_CS;
	uvm_reg_field CMD0_TRIG_WORD_COUNTER;
	uvm_reg_field TRIG_WORD_COUNTER;
	uvm_reg_field CMD0_TTL;
	uvm_reg_field TTL;
	uvm_reg_field CMD0_OP_ID;
	uvm_reg_field OP_ID;
	uvm_reg_field CMD1_TRIG_IN;
	uvm_reg_field TRIG_IN;
	uvm_reg_field CMD2_TRIG_OUT;
	uvm_reg_field TRIG_OUT;
	rand uvm_reg_field SW0_CMD_TTL;
	rand uvm_reg_field CMD_TTL;
	rand uvm_reg_field SW0_CMD_OP_ID;
	rand uvm_reg_field CMD_OP_ID;
	rand uvm_reg_field SW0_CMD_REQ;
	rand uvm_reg_field CMD_REQ;
	rand uvm_reg_field SW1_CMD_TRIG_IN;
	rand uvm_reg_field CMD_TRIG_IN;
	rand uvm_reg_field SW2_CMD_TRIG_OUT;
	rand uvm_reg_field CMD_TRIG_OUT;
	rand uvm_reg_field SW3_MEM_ALLOC;
	rand uvm_reg_field MEM_ALLOC;
	rand uvm_reg_field SW3_FINISH_ACK;
	rand uvm_reg_field FINISH_ACK;
	rand uvm_reg_field SW3_FINISH_REQ_MASK;
	rand uvm_reg_field FINISH_REQ_MASK;
	rand uvm_reg_field SW3_START_FID;
	rand uvm_reg_field START_FID;
	rand uvm_reg_field SW3_START_PIPO;
	rand uvm_reg_field START_PIPO;
	rand uvm_reg_field SW3_START;
	rand uvm_reg_field START;
	rand uvm_reg_field FIDX_DATA;
	rand uvm_reg_field DATA;
	rand uvm_reg_field FIDX_EN;
	rand uvm_reg_field EN;
	uvm_reg_field STS0_TTL_COUNTER;
	uvm_reg_field TTL_COUNTER;
	uvm_reg_field STS1_RC_UPDATE;
	uvm_reg_field RC_UPDATE;
	uvm_reg_field STS1_RC_RESUME;
	uvm_reg_field RC_RESUME;
	uvm_reg_field STS2_WC_UPDATE;
	uvm_reg_field WC_UPDATE;
	uvm_reg_field STS2_WC_RESUME;
	uvm_reg_field WC_RESUME;

	function new(string name = "m_map0_rsp_s2_dma_glb_reg");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.IRQ_STATUS = ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_STATUS::type_id::create("IRQ_STATUS",,get_full_name());
      this.IRQ_STATUS.configure(this, null, "");
      this.IRQ_STATUS.build();
      this.default_map.add_reg(this.IRQ_STATUS, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.IRQ_STATUS_FCNT_FINISH = this.IRQ_STATUS.FCNT_FINISH;
		this.IRQ_STATUS_PCNT_FINISH = this.IRQ_STATUS.PCNT_FINISH;
      this.IRQ_MASK = ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_MASK::type_id::create("IRQ_MASK",,get_full_name());
      this.IRQ_MASK.configure(this, null, "");
      this.IRQ_MASK.build();
      this.default_map.add_reg(this.IRQ_MASK, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.IRQ_MASK_FCNT_FINISH = this.IRQ_MASK.FCNT_FINISH;
		this.IRQ_MASK_PCNT_FINISH = this.IRQ_MASK.PCNT_FINISH;
      this.IRQ_ENABLE = ral_reg_m_map0_rsp_s2_dma_glb_reg_IRQ_ENABLE::type_id::create("IRQ_ENABLE",,get_full_name());
      this.IRQ_ENABLE.configure(this, null, "");
      this.IRQ_ENABLE.build();
      this.default_map.add_reg(this.IRQ_ENABLE, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.IRQ_ENABLE_FCNT_FINISH = this.IRQ_ENABLE.FCNT_FINISH;
		this.IRQ_ENABLE_PCNT_FINISH = this.IRQ_ENABLE.PCNT_FINISH;
      this.CMD0 = ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD0::type_id::create("CMD0",,get_full_name());
      this.CMD0.configure(this, null, "");
      this.CMD0.build();
      this.default_map.add_reg(this.CMD0, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.CMD0_CS = this.CMD0.CS;
		this.CS = this.CMD0.CS;
		this.CMD0_TRIG_CS = this.CMD0.TRIG_CS;
		this.TRIG_CS = this.CMD0.TRIG_CS;
		this.CMD0_TRIG_WORD_COUNTER = this.CMD0.TRIG_WORD_COUNTER;
		this.TRIG_WORD_COUNTER = this.CMD0.TRIG_WORD_COUNTER;
		this.CMD0_TTL = this.CMD0.TTL;
		this.TTL = this.CMD0.TTL;
		this.CMD0_OP_ID = this.CMD0.OP_ID;
		this.OP_ID = this.CMD0.OP_ID;
      this.CMD1 = ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD1::type_id::create("CMD1",,get_full_name());
      this.CMD1.configure(this, null, "");
      this.CMD1.build();
      this.default_map.add_reg(this.CMD1, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.CMD1_TRIG_IN = this.CMD1.TRIG_IN;
		this.TRIG_IN = this.CMD1.TRIG_IN;
      this.CMD2 = ral_reg_m_map0_rsp_s2_dma_glb_reg_CMD2::type_id::create("CMD2",,get_full_name());
      this.CMD2.configure(this, null, "");
      this.CMD2.build();
      this.default_map.add_reg(this.CMD2, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.CMD2_TRIG_OUT = this.CMD2.TRIG_OUT;
		this.TRIG_OUT = this.CMD2.TRIG_OUT;
      this.SW0 = ral_reg_m_map0_rsp_s2_dma_glb_reg_SW0::type_id::create("SW0",,get_full_name());
      this.SW0.configure(this, null, "");
      this.SW0.build();
      this.default_map.add_reg(this.SW0, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.SW0_CMD_TTL = this.SW0.CMD_TTL;
		this.CMD_TTL = this.SW0.CMD_TTL;
		this.SW0_CMD_OP_ID = this.SW0.CMD_OP_ID;
		this.CMD_OP_ID = this.SW0.CMD_OP_ID;
		this.SW0_CMD_REQ = this.SW0.CMD_REQ;
		this.CMD_REQ = this.SW0.CMD_REQ;
      this.SW1 = ral_reg_m_map0_rsp_s2_dma_glb_reg_SW1::type_id::create("SW1",,get_full_name());
      this.SW1.configure(this, null, "");
      this.SW1.build();
      this.default_map.add_reg(this.SW1, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
		this.SW1_CMD_TRIG_IN = this.SW1.CMD_TRIG_IN;
		this.CMD_TRIG_IN = this.SW1.CMD_TRIG_IN;
      this.SW2 = ral_reg_m_map0_rsp_s2_dma_glb_reg_SW2::type_id::create("SW2",,get_full_name());
      this.SW2.configure(this, null, "");
      this.SW2.build();
      this.default_map.add_reg(this.SW2, `UVM_REG_ADDR_WIDTH'h20, "RW", 0);
		this.SW2_CMD_TRIG_OUT = this.SW2.CMD_TRIG_OUT;
		this.CMD_TRIG_OUT = this.SW2.CMD_TRIG_OUT;
      this.SW3 = ral_reg_m_map0_rsp_s2_dma_glb_reg_SW3::type_id::create("SW3",,get_full_name());
      this.SW3.configure(this, null, "");
      this.SW3.build();
      this.default_map.add_reg(this.SW3, `UVM_REG_ADDR_WIDTH'h24, "RW", 0);
		this.SW3_MEM_ALLOC = this.SW3.MEM_ALLOC;
		this.MEM_ALLOC = this.SW3.MEM_ALLOC;
		this.SW3_FINISH_ACK = this.SW3.FINISH_ACK;
		this.FINISH_ACK = this.SW3.FINISH_ACK;
		this.SW3_FINISH_REQ_MASK = this.SW3.FINISH_REQ_MASK;
		this.FINISH_REQ_MASK = this.SW3.FINISH_REQ_MASK;
		this.SW3_START_FID = this.SW3.START_FID;
		this.START_FID = this.SW3.START_FID;
		this.SW3_START_PIPO = this.SW3.START_PIPO;
		this.START_PIPO = this.SW3.START_PIPO;
		this.SW3_START = this.SW3.START;
		this.START = this.SW3.START;
      this.FIDX = ral_reg_m_map0_rsp_s2_dma_glb_reg_FIDX::type_id::create("FIDX",,get_full_name());
      this.FIDX.configure(this, null, "");
      this.FIDX.build();
      this.default_map.add_reg(this.FIDX, `UVM_REG_ADDR_WIDTH'h28, "RW", 0);
		this.FIDX_DATA = this.FIDX.DATA;
		this.DATA = this.FIDX.DATA;
		this.FIDX_EN = this.FIDX.EN;
		this.EN = this.FIDX.EN;
      this.STS0 = ral_reg_m_map0_rsp_s2_dma_glb_reg_STS0::type_id::create("STS0",,get_full_name());
      this.STS0.configure(this, null, "");
      this.STS0.build();
      this.default_map.add_reg(this.STS0, `UVM_REG_ADDR_WIDTH'h2C, "RW", 0);
		this.STS0_TTL_COUNTER = this.STS0.TTL_COUNTER;
		this.TTL_COUNTER = this.STS0.TTL_COUNTER;
      this.STS1 = ral_reg_m_map0_rsp_s2_dma_glb_reg_STS1::type_id::create("STS1",,get_full_name());
      this.STS1.configure(this, null, "");
      this.STS1.build();
      this.default_map.add_reg(this.STS1, `UVM_REG_ADDR_WIDTH'h30, "RO", 0);
		this.STS1_RC_UPDATE = this.STS1.RC_UPDATE;
		this.RC_UPDATE = this.STS1.RC_UPDATE;
		this.STS1_RC_RESUME = this.STS1.RC_RESUME;
		this.RC_RESUME = this.STS1.RC_RESUME;
      this.STS2 = ral_reg_m_map0_rsp_s2_dma_glb_reg_STS2::type_id::create("STS2",,get_full_name());
      this.STS2.configure(this, null, "");
      this.STS2.build();
      this.default_map.add_reg(this.STS2, `UVM_REG_ADDR_WIDTH'h34, "RO", 0);
		this.STS2_WC_UPDATE = this.STS2.WC_UPDATE;
		this.WC_UPDATE = this.STS2.WC_UPDATE;
		this.STS2_WC_RESUME = this.STS2.WC_RESUME;
		this.WC_RESUME = this.STS2.WC_RESUME;
	  uvm_config_db #(uvm_reg_block)::set(null,"","RegisterModel_Debug",this);
   endfunction : build

	`uvm_object_utils(ral_block_m_map0_rsp_s2_dma_glb_reg)

endclass : ral_block_m_map0_rsp_s2_dma_glb_reg



`endif
