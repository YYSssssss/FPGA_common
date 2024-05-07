`ifndef RAL_RSP_S2_PREP_REG
`define RAL_RSP_S2_PREP_REG

import uvm_pkg::*;

class ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_cmp_cnt extends uvm_reg;
	rand uvm_reg_field i_dc_est_cmp_cnt;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_dc_est_cmp_cnt");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_dc_est_cmp_cnt = uvm_reg_field::type_id::create("i_dc_est_cmp_cnt",,get_full_name());
      this.i_dc_est_cmp_cnt.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_cmp_cnt)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_cmp_cnt


class ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_chp_cnt extends uvm_reg;
	rand uvm_reg_field i_dc_est_chp_cnt;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_dc_est_chp_cnt");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_dc_est_chp_cnt = uvm_reg_field::type_id::create("i_dc_est_chp_cnt",,get_full_name());
      this.i_dc_est_chp_cnt.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_chp_cnt)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_chp_cnt


class ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_frm_cnt extends uvm_reg;
	rand uvm_reg_field i_dc_est_frm_cnt;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_dc_est_frm_cnt");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_dc_est_frm_cnt = uvm_reg_field::type_id::create("i_dc_est_frm_cnt",,get_full_name());
      this.i_dc_est_frm_cnt.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_frm_cnt)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_frm_cnt


class ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_scale extends uvm_reg;
	rand uvm_reg_field i_dc_est_scale;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_dc_est_scale");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_dc_est_scale = uvm_reg_field::type_id::create("i_dc_est_scale",,get_full_name());
      this.i_dc_est_scale.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_scale)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_scale


class ral_reg_m_map0_rsp_s2_prep_reg_i_dc_config_mode extends uvm_reg;
	rand uvm_reg_field i_dc_config_mode;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_dc_config_mode");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_dc_config_mode = uvm_reg_field::type_id::create("i_dc_config_mode",,get_full_name());
      this.i_dc_config_mode.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_dc_config_mode)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_dc_config_mode


class ral_reg_m_map0_rsp_s2_prep_reg_i_dc_u extends uvm_reg;
	rand uvm_reg_field i_dc_u;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_dc_u");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_dc_u = uvm_reg_field::type_id::create("i_dc_u",,get_full_name());
      this.i_dc_u.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_dc_u)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_dc_u


class ral_reg_m_map0_rsp_s2_prep_reg_o_dc_u extends uvm_reg;
	rand uvm_reg_field o_dc_u;

	function new(string name = "m_map0_rsp_s2_prep_reg_o_dc_u");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.o_dc_u = uvm_reg_field::type_id::create("o_dc_u",,get_full_name());
      this.o_dc_u.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_o_dc_u)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_o_dc_u


class ral_reg_m_map0_rsp_s2_prep_reg_i_intf_est_scale extends uvm_reg;
	rand uvm_reg_field i_intf_est_scale;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_intf_est_scale");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_intf_est_scale = uvm_reg_field::type_id::create("i_intf_est_scale",,get_full_name());
      this.i_intf_est_scale.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_intf_est_scale)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_intf_est_scale


class ral_reg_m_map0_rsp_s2_prep_reg_i_intf_config_mode extends uvm_reg;
	rand uvm_reg_field i_intf_config_mode;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_intf_config_mode");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_intf_config_mode = uvm_reg_field::type_id::create("i_intf_config_mode",,get_full_name());
      this.i_intf_config_mode.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_intf_config_mode)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_intf_config_mode


class ral_reg_m_map0_rsp_s2_prep_reg_i_intf_cmp extends uvm_reg;
	rand uvm_reg_field i_intf_cmp;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_intf_cmp");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_intf_cmp = uvm_reg_field::type_id::create("i_intf_cmp",,get_full_name());
      this.i_intf_cmp.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_intf_cmp)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_intf_cmp


class ral_reg_m_map0_rsp_s2_prep_reg_o_intf_cmp extends uvm_reg;
	rand uvm_reg_field o_intf_cmp;

	function new(string name = "m_map0_rsp_s2_prep_reg_o_intf_cmp");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.o_intf_cmp = uvm_reg_field::type_id::create("o_intf_cmp",,get_full_name());
      this.o_intf_cmp.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_o_intf_cmp)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_o_intf_cmp


class ral_reg_m_map0_rsp_s2_prep_reg_i_combination_config_mode extends uvm_reg;
	rand uvm_reg_field i_combination_config_mode;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_combination_config_mode");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_combination_config_mode = uvm_reg_field::type_id::create("i_combination_config_mode",,get_full_name());
      this.i_combination_config_mode.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_combination_config_mode)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_combination_config_mode


class ral_reg_m_map0_rsp_s2_prep_reg_i_phase_config_mode extends uvm_reg;
	rand uvm_reg_field i_phase_config_mode;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_phase_config_mode");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_phase_config_mode = uvm_reg_field::type_id::create("i_phase_config_mode",,get_full_name());
      this.i_phase_config_mode.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_phase_config_mode)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_phase_config_mode


class ral_reg_m_map0_rsp_s2_prep_reg_i_phase_w extends uvm_reg;
	rand uvm_reg_field i_phase_w;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_phase_w");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_phase_w = uvm_reg_field::type_id::create("i_phase_w",,get_full_name());
      this.i_phase_w.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_phase_w)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_phase_w


class ral_reg_m_map0_rsp_s2_prep_reg_i_phase_coe extends uvm_reg;
	rand uvm_reg_field i_phase_coe;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_phase_coe");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_phase_coe = uvm_reg_field::type_id::create("i_phase_coe",,get_full_name());
      this.i_phase_coe.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_phase_coe)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_phase_coe


class ral_reg_m_map0_rsp_s2_prep_reg_i_data_formatter extends uvm_reg;
	rand uvm_reg_field i_data_formatter;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_data_formatter");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_data_formatter = uvm_reg_field::type_id::create("i_data_formatter",,get_full_name());
      this.i_data_formatter.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_data_formatter)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_data_formatter


class ral_reg_m_map0_rsp_s2_prep_reg_i_frame_num_format extends uvm_reg;
	rand uvm_reg_field i_frame_num_format;

	function new(string name = "m_map0_rsp_s2_prep_reg_i_frame_num_format");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.i_frame_num_format = uvm_reg_field::type_id::create("i_frame_num_format",,get_full_name());
      this.i_frame_num_format.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_i_frame_num_format)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_i_frame_num_format


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_0 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_0;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_0");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_0 = uvm_reg_field::type_id::create("s1_prep_debug_0",,get_full_name());
      this.s1_prep_debug_0.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_0)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_0


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_1 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_1;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_1");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_1 = uvm_reg_field::type_id::create("s1_prep_debug_1",,get_full_name());
      this.s1_prep_debug_1.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_1)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_1


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_2 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_2;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_2");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_2 = uvm_reg_field::type_id::create("s1_prep_debug_2",,get_full_name());
      this.s1_prep_debug_2.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_2)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_2


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_3 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_3;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_3");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_3 = uvm_reg_field::type_id::create("s1_prep_debug_3",,get_full_name());
      this.s1_prep_debug_3.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_3)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_3


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_4 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_4;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_4");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_4 = uvm_reg_field::type_id::create("s1_prep_debug_4",,get_full_name());
      this.s1_prep_debug_4.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_4)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_4


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_5 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_5;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_5");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_5 = uvm_reg_field::type_id::create("s1_prep_debug_5",,get_full_name());
      this.s1_prep_debug_5.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_5)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_5


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_6 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_6;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_6");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_6 = uvm_reg_field::type_id::create("s1_prep_debug_6",,get_full_name());
      this.s1_prep_debug_6.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_6)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_6


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_7 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_7;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_7");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_7 = uvm_reg_field::type_id::create("s1_prep_debug_7",,get_full_name());
      this.s1_prep_debug_7.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_7)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_7


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_8 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_8;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_8");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_8 = uvm_reg_field::type_id::create("s1_prep_debug_8",,get_full_name());
      this.s1_prep_debug_8.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_8)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_8


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_9 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_9;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_9");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_9 = uvm_reg_field::type_id::create("s1_prep_debug_9",,get_full_name());
      this.s1_prep_debug_9.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_9)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_9


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_10 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_10;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_10");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_10 = uvm_reg_field::type_id::create("s1_prep_debug_10",,get_full_name());
      this.s1_prep_debug_10.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_10)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_10


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_11 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_11;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_11");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_11 = uvm_reg_field::type_id::create("s1_prep_debug_11",,get_full_name());
      this.s1_prep_debug_11.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_11)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_11


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_12 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_12;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_12");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_12 = uvm_reg_field::type_id::create("s1_prep_debug_12",,get_full_name());
      this.s1_prep_debug_12.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_12)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_12


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_13 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_13;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_13");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_13 = uvm_reg_field::type_id::create("s1_prep_debug_13",,get_full_name());
      this.s1_prep_debug_13.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_13)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_13


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_14 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_14;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_14");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_14 = uvm_reg_field::type_id::create("s1_prep_debug_14",,get_full_name());
      this.s1_prep_debug_14.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_14)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_14


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_15 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_15;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_15");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_15 = uvm_reg_field::type_id::create("s1_prep_debug_15",,get_full_name());
      this.s1_prep_debug_15.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_15)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_15


class ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_16 extends uvm_reg;
	rand uvm_reg_field s1_prep_debug_16;

	function new(string name = "m_map0_rsp_s2_prep_reg_s1_prep_debug_16");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.s1_prep_debug_16 = uvm_reg_field::type_id::create("s1_prep_debug_16",,get_full_name());
      this.s1_prep_debug_16.configure(this, 32, 0, "RW", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_16)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_16


class ral_reg_m_map0_rsp_s2_prep_reg_last_register extends uvm_reg;
	uvm_reg_field last_register;

	function new(string name = "m_map0_rsp_s2_prep_reg_last_register");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.last_register = uvm_reg_field::type_id::create("last_register",,get_full_name());
      this.last_register.configure(this, 32, 0, "RO", 0, 32'h0, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_m_map0_rsp_s2_prep_reg_last_register)

endclass : ral_reg_m_map0_rsp_s2_prep_reg_last_register


class ral_block_m_map0_rsp_s2_prep_reg extends uvm_reg_block;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_cmp_cnt i_dc_est_cmp_cnt;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_chp_cnt i_dc_est_chp_cnt;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_frm_cnt i_dc_est_frm_cnt;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_scale i_dc_est_scale;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_dc_config_mode i_dc_config_mode;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_dc_u i_dc_u;
	rand ral_reg_m_map0_rsp_s2_prep_reg_o_dc_u o_dc_u;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_intf_est_scale i_intf_est_scale;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_intf_config_mode i_intf_config_mode;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_intf_cmp i_intf_cmp;
	rand ral_reg_m_map0_rsp_s2_prep_reg_o_intf_cmp o_intf_cmp;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_combination_config_mode i_combination_config_mode;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_phase_config_mode i_phase_config_mode;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_phase_w i_phase_w;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_phase_coe i_phase_coe;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_data_formatter i_data_formatter;
	rand ral_reg_m_map0_rsp_s2_prep_reg_i_frame_num_format i_frame_num_format;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_0 s1_prep_debug_0;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_1 s1_prep_debug_1;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_2 s1_prep_debug_2;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_3 s1_prep_debug_3;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_4 s1_prep_debug_4;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_5 s1_prep_debug_5;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_6 s1_prep_debug_6;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_7 s1_prep_debug_7;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_8 s1_prep_debug_8;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_9 s1_prep_debug_9;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_10 s1_prep_debug_10;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_11 s1_prep_debug_11;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_12 s1_prep_debug_12;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_13 s1_prep_debug_13;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_14 s1_prep_debug_14;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_15 s1_prep_debug_15;
	rand ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_16 s1_prep_debug_16;
	rand ral_reg_m_map0_rsp_s2_prep_reg_last_register last_register;
	rand uvm_reg_field i_dc_est_cmp_cnt_i_dc_est_cmp_cnt;
	rand uvm_reg_field i_dc_est_chp_cnt_i_dc_est_chp_cnt;
	rand uvm_reg_field i_dc_est_frm_cnt_i_dc_est_frm_cnt;
	rand uvm_reg_field i_dc_est_scale_i_dc_est_scale;
	rand uvm_reg_field i_dc_config_mode_i_dc_config_mode;
	rand uvm_reg_field i_dc_u_i_dc_u;
	rand uvm_reg_field o_dc_u_o_dc_u;
	rand uvm_reg_field i_intf_est_scale_i_intf_est_scale;
	rand uvm_reg_field i_intf_config_mode_i_intf_config_mode;
	rand uvm_reg_field i_intf_cmp_i_intf_cmp;
	rand uvm_reg_field o_intf_cmp_o_intf_cmp;
	rand uvm_reg_field i_combination_config_mode_i_combination_config_mode;
	rand uvm_reg_field i_phase_config_mode_i_phase_config_mode;
	rand uvm_reg_field i_phase_w_i_phase_w;
	rand uvm_reg_field i_phase_coe_i_phase_coe;
	rand uvm_reg_field i_data_formatter_i_data_formatter;
	rand uvm_reg_field i_frame_num_format_i_frame_num_format;
	rand uvm_reg_field s1_prep_debug_0_s1_prep_debug_0;
	rand uvm_reg_field s1_prep_debug_1_s1_prep_debug_1;
	rand uvm_reg_field s1_prep_debug_2_s1_prep_debug_2;
	rand uvm_reg_field s1_prep_debug_3_s1_prep_debug_3;
	rand uvm_reg_field s1_prep_debug_4_s1_prep_debug_4;
	rand uvm_reg_field s1_prep_debug_5_s1_prep_debug_5;
	rand uvm_reg_field s1_prep_debug_6_s1_prep_debug_6;
	rand uvm_reg_field s1_prep_debug_7_s1_prep_debug_7;
	rand uvm_reg_field s1_prep_debug_8_s1_prep_debug_8;
	rand uvm_reg_field s1_prep_debug_9_s1_prep_debug_9;
	rand uvm_reg_field s1_prep_debug_10_s1_prep_debug_10;
	rand uvm_reg_field s1_prep_debug_11_s1_prep_debug_11;
	rand uvm_reg_field s1_prep_debug_12_s1_prep_debug_12;
	rand uvm_reg_field s1_prep_debug_13_s1_prep_debug_13;
	rand uvm_reg_field s1_prep_debug_14_s1_prep_debug_14;
	rand uvm_reg_field s1_prep_debug_15_s1_prep_debug_15;
	rand uvm_reg_field s1_prep_debug_16_s1_prep_debug_16;
	uvm_reg_field last_register_last_register;

	function new(string name = "m_map0_rsp_s2_prep_reg");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.i_dc_est_cmp_cnt = ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_cmp_cnt::type_id::create("i_dc_est_cmp_cnt",,get_full_name());
      this.i_dc_est_cmp_cnt.configure(this, null, "");
      this.i_dc_est_cmp_cnt.build();
      this.default_map.add_reg(this.i_dc_est_cmp_cnt, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.i_dc_est_cmp_cnt_i_dc_est_cmp_cnt = this.i_dc_est_cmp_cnt.i_dc_est_cmp_cnt;
      this.i_dc_est_chp_cnt = ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_chp_cnt::type_id::create("i_dc_est_chp_cnt",,get_full_name());
      this.i_dc_est_chp_cnt.configure(this, null, "");
      this.i_dc_est_chp_cnt.build();
      this.default_map.add_reg(this.i_dc_est_chp_cnt, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.i_dc_est_chp_cnt_i_dc_est_chp_cnt = this.i_dc_est_chp_cnt.i_dc_est_chp_cnt;
      this.i_dc_est_frm_cnt = ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_frm_cnt::type_id::create("i_dc_est_frm_cnt",,get_full_name());
      this.i_dc_est_frm_cnt.configure(this, null, "");
      this.i_dc_est_frm_cnt.build();
      this.default_map.add_reg(this.i_dc_est_frm_cnt, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.i_dc_est_frm_cnt_i_dc_est_frm_cnt = this.i_dc_est_frm_cnt.i_dc_est_frm_cnt;
      this.i_dc_est_scale = ral_reg_m_map0_rsp_s2_prep_reg_i_dc_est_scale::type_id::create("i_dc_est_scale",,get_full_name());
      this.i_dc_est_scale.configure(this, null, "");
      this.i_dc_est_scale.build();
      this.default_map.add_reg(this.i_dc_est_scale, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.i_dc_est_scale_i_dc_est_scale = this.i_dc_est_scale.i_dc_est_scale;
      this.i_dc_config_mode = ral_reg_m_map0_rsp_s2_prep_reg_i_dc_config_mode::type_id::create("i_dc_config_mode",,get_full_name());
      this.i_dc_config_mode.configure(this, null, "");
      this.i_dc_config_mode.build();
      this.default_map.add_reg(this.i_dc_config_mode, `UVM_REG_ADDR_WIDTH'h10, "RW", 0);
		this.i_dc_config_mode_i_dc_config_mode = this.i_dc_config_mode.i_dc_config_mode;
      this.i_dc_u = ral_reg_m_map0_rsp_s2_prep_reg_i_dc_u::type_id::create("i_dc_u",,get_full_name());
      this.i_dc_u.configure(this, null, "");
      this.i_dc_u.build();
      this.default_map.add_reg(this.i_dc_u, `UVM_REG_ADDR_WIDTH'h14, "RW", 0);
		this.i_dc_u_i_dc_u = this.i_dc_u.i_dc_u;
      this.o_dc_u = ral_reg_m_map0_rsp_s2_prep_reg_o_dc_u::type_id::create("o_dc_u",,get_full_name());
      this.o_dc_u.configure(this, null, "");
      this.o_dc_u.build();
      this.default_map.add_reg(this.o_dc_u, `UVM_REG_ADDR_WIDTH'h18, "RW", 0);
		this.o_dc_u_o_dc_u = this.o_dc_u.o_dc_u;
      this.i_intf_est_scale = ral_reg_m_map0_rsp_s2_prep_reg_i_intf_est_scale::type_id::create("i_intf_est_scale",,get_full_name());
      this.i_intf_est_scale.configure(this, null, "");
      this.i_intf_est_scale.build();
      this.default_map.add_reg(this.i_intf_est_scale, `UVM_REG_ADDR_WIDTH'h1C, "RW", 0);
		this.i_intf_est_scale_i_intf_est_scale = this.i_intf_est_scale.i_intf_est_scale;
      this.i_intf_config_mode = ral_reg_m_map0_rsp_s2_prep_reg_i_intf_config_mode::type_id::create("i_intf_config_mode",,get_full_name());
      this.i_intf_config_mode.configure(this, null, "");
      this.i_intf_config_mode.build();
      this.default_map.add_reg(this.i_intf_config_mode, `UVM_REG_ADDR_WIDTH'h20, "RW", 0);
		this.i_intf_config_mode_i_intf_config_mode = this.i_intf_config_mode.i_intf_config_mode;
      this.i_intf_cmp = ral_reg_m_map0_rsp_s2_prep_reg_i_intf_cmp::type_id::create("i_intf_cmp",,get_full_name());
      this.i_intf_cmp.configure(this, null, "");
      this.i_intf_cmp.build();
      this.default_map.add_reg(this.i_intf_cmp, `UVM_REG_ADDR_WIDTH'h24, "RW", 0);
		this.i_intf_cmp_i_intf_cmp = this.i_intf_cmp.i_intf_cmp;
      this.o_intf_cmp = ral_reg_m_map0_rsp_s2_prep_reg_o_intf_cmp::type_id::create("o_intf_cmp",,get_full_name());
      this.o_intf_cmp.configure(this, null, "");
      this.o_intf_cmp.build();
      this.default_map.add_reg(this.o_intf_cmp, `UVM_REG_ADDR_WIDTH'h28, "RW", 0);
		this.o_intf_cmp_o_intf_cmp = this.o_intf_cmp.o_intf_cmp;
      this.i_combination_config_mode = ral_reg_m_map0_rsp_s2_prep_reg_i_combination_config_mode::type_id::create("i_combination_config_mode",,get_full_name());
      this.i_combination_config_mode.configure(this, null, "");
      this.i_combination_config_mode.build();
      this.default_map.add_reg(this.i_combination_config_mode, `UVM_REG_ADDR_WIDTH'h2C, "RW", 0);
		this.i_combination_config_mode_i_combination_config_mode = this.i_combination_config_mode.i_combination_config_mode;
      this.i_phase_config_mode = ral_reg_m_map0_rsp_s2_prep_reg_i_phase_config_mode::type_id::create("i_phase_config_mode",,get_full_name());
      this.i_phase_config_mode.configure(this, null, "");
      this.i_phase_config_mode.build();
      this.default_map.add_reg(this.i_phase_config_mode, `UVM_REG_ADDR_WIDTH'h30, "RW", 0);
		this.i_phase_config_mode_i_phase_config_mode = this.i_phase_config_mode.i_phase_config_mode;
      this.i_phase_w = ral_reg_m_map0_rsp_s2_prep_reg_i_phase_w::type_id::create("i_phase_w",,get_full_name());
      this.i_phase_w.configure(this, null, "");
      this.i_phase_w.build();
      this.default_map.add_reg(this.i_phase_w, `UVM_REG_ADDR_WIDTH'h34, "RW", 0);
		this.i_phase_w_i_phase_w = this.i_phase_w.i_phase_w;
      this.i_phase_coe = ral_reg_m_map0_rsp_s2_prep_reg_i_phase_coe::type_id::create("i_phase_coe",,get_full_name());
      this.i_phase_coe.configure(this, null, "");
      this.i_phase_coe.build();
      this.default_map.add_reg(this.i_phase_coe, `UVM_REG_ADDR_WIDTH'h38, "RW", 0);
		this.i_phase_coe_i_phase_coe = this.i_phase_coe.i_phase_coe;
      this.i_data_formatter = ral_reg_m_map0_rsp_s2_prep_reg_i_data_formatter::type_id::create("i_data_formatter",,get_full_name());
      this.i_data_formatter.configure(this, null, "");
      this.i_data_formatter.build();
      this.default_map.add_reg(this.i_data_formatter, `UVM_REG_ADDR_WIDTH'h3C, "RW", 0);
		this.i_data_formatter_i_data_formatter = this.i_data_formatter.i_data_formatter;
      this.i_frame_num_format = ral_reg_m_map0_rsp_s2_prep_reg_i_frame_num_format::type_id::create("i_frame_num_format",,get_full_name());
      this.i_frame_num_format.configure(this, null, "");
      this.i_frame_num_format.build();
      this.default_map.add_reg(this.i_frame_num_format, `UVM_REG_ADDR_WIDTH'h40, "RW", 0);
		this.i_frame_num_format_i_frame_num_format = this.i_frame_num_format.i_frame_num_format;
      this.s1_prep_debug_0 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_0::type_id::create("s1_prep_debug_0",,get_full_name());
      this.s1_prep_debug_0.configure(this, null, "");
      this.s1_prep_debug_0.build();
      this.default_map.add_reg(this.s1_prep_debug_0, `UVM_REG_ADDR_WIDTH'h44, "RW", 0);
		this.s1_prep_debug_0_s1_prep_debug_0 = this.s1_prep_debug_0.s1_prep_debug_0;
      this.s1_prep_debug_1 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_1::type_id::create("s1_prep_debug_1",,get_full_name());
      this.s1_prep_debug_1.configure(this, null, "");
      this.s1_prep_debug_1.build();
      this.default_map.add_reg(this.s1_prep_debug_1, `UVM_REG_ADDR_WIDTH'h48, "RW", 0);
		this.s1_prep_debug_1_s1_prep_debug_1 = this.s1_prep_debug_1.s1_prep_debug_1;
      this.s1_prep_debug_2 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_2::type_id::create("s1_prep_debug_2",,get_full_name());
      this.s1_prep_debug_2.configure(this, null, "");
      this.s1_prep_debug_2.build();
      this.default_map.add_reg(this.s1_prep_debug_2, `UVM_REG_ADDR_WIDTH'h4C, "RW", 0);
		this.s1_prep_debug_2_s1_prep_debug_2 = this.s1_prep_debug_2.s1_prep_debug_2;
      this.s1_prep_debug_3 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_3::type_id::create("s1_prep_debug_3",,get_full_name());
      this.s1_prep_debug_3.configure(this, null, "");
      this.s1_prep_debug_3.build();
      this.default_map.add_reg(this.s1_prep_debug_3, `UVM_REG_ADDR_WIDTH'h50, "RW", 0);
		this.s1_prep_debug_3_s1_prep_debug_3 = this.s1_prep_debug_3.s1_prep_debug_3;
      this.s1_prep_debug_4 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_4::type_id::create("s1_prep_debug_4",,get_full_name());
      this.s1_prep_debug_4.configure(this, null, "");
      this.s1_prep_debug_4.build();
      this.default_map.add_reg(this.s1_prep_debug_4, `UVM_REG_ADDR_WIDTH'h54, "RW", 0);
		this.s1_prep_debug_4_s1_prep_debug_4 = this.s1_prep_debug_4.s1_prep_debug_4;
      this.s1_prep_debug_5 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_5::type_id::create("s1_prep_debug_5",,get_full_name());
      this.s1_prep_debug_5.configure(this, null, "");
      this.s1_prep_debug_5.build();
      this.default_map.add_reg(this.s1_prep_debug_5, `UVM_REG_ADDR_WIDTH'h58, "RW", 0);
		this.s1_prep_debug_5_s1_prep_debug_5 = this.s1_prep_debug_5.s1_prep_debug_5;
      this.s1_prep_debug_6 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_6::type_id::create("s1_prep_debug_6",,get_full_name());
      this.s1_prep_debug_6.configure(this, null, "");
      this.s1_prep_debug_6.build();
      this.default_map.add_reg(this.s1_prep_debug_6, `UVM_REG_ADDR_WIDTH'h5C, "RW", 0);
		this.s1_prep_debug_6_s1_prep_debug_6 = this.s1_prep_debug_6.s1_prep_debug_6;
      this.s1_prep_debug_7 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_7::type_id::create("s1_prep_debug_7",,get_full_name());
      this.s1_prep_debug_7.configure(this, null, "");
      this.s1_prep_debug_7.build();
      this.default_map.add_reg(this.s1_prep_debug_7, `UVM_REG_ADDR_WIDTH'h60, "RW", 0);
		this.s1_prep_debug_7_s1_prep_debug_7 = this.s1_prep_debug_7.s1_prep_debug_7;
      this.s1_prep_debug_8 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_8::type_id::create("s1_prep_debug_8",,get_full_name());
      this.s1_prep_debug_8.configure(this, null, "");
      this.s1_prep_debug_8.build();
      this.default_map.add_reg(this.s1_prep_debug_8, `UVM_REG_ADDR_WIDTH'h64, "RW", 0);
		this.s1_prep_debug_8_s1_prep_debug_8 = this.s1_prep_debug_8.s1_prep_debug_8;
      this.s1_prep_debug_9 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_9::type_id::create("s1_prep_debug_9",,get_full_name());
      this.s1_prep_debug_9.configure(this, null, "");
      this.s1_prep_debug_9.build();
      this.default_map.add_reg(this.s1_prep_debug_9, `UVM_REG_ADDR_WIDTH'h68, "RW", 0);
		this.s1_prep_debug_9_s1_prep_debug_9 = this.s1_prep_debug_9.s1_prep_debug_9;
      this.s1_prep_debug_10 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_10::type_id::create("s1_prep_debug_10",,get_full_name());
      this.s1_prep_debug_10.configure(this, null, "");
      this.s1_prep_debug_10.build();
      this.default_map.add_reg(this.s1_prep_debug_10, `UVM_REG_ADDR_WIDTH'h6C, "RW", 0);
		this.s1_prep_debug_10_s1_prep_debug_10 = this.s1_prep_debug_10.s1_prep_debug_10;
      this.s1_prep_debug_11 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_11::type_id::create("s1_prep_debug_11",,get_full_name());
      this.s1_prep_debug_11.configure(this, null, "");
      this.s1_prep_debug_11.build();
      this.default_map.add_reg(this.s1_prep_debug_11, `UVM_REG_ADDR_WIDTH'h70, "RW", 0);
		this.s1_prep_debug_11_s1_prep_debug_11 = this.s1_prep_debug_11.s1_prep_debug_11;
      this.s1_prep_debug_12 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_12::type_id::create("s1_prep_debug_12",,get_full_name());
      this.s1_prep_debug_12.configure(this, null, "");
      this.s1_prep_debug_12.build();
      this.default_map.add_reg(this.s1_prep_debug_12, `UVM_REG_ADDR_WIDTH'h74, "RW", 0);
		this.s1_prep_debug_12_s1_prep_debug_12 = this.s1_prep_debug_12.s1_prep_debug_12;
      this.s1_prep_debug_13 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_13::type_id::create("s1_prep_debug_13",,get_full_name());
      this.s1_prep_debug_13.configure(this, null, "");
      this.s1_prep_debug_13.build();
      this.default_map.add_reg(this.s1_prep_debug_13, `UVM_REG_ADDR_WIDTH'h78, "RW", 0);
		this.s1_prep_debug_13_s1_prep_debug_13 = this.s1_prep_debug_13.s1_prep_debug_13;
      this.s1_prep_debug_14 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_14::type_id::create("s1_prep_debug_14",,get_full_name());
      this.s1_prep_debug_14.configure(this, null, "");
      this.s1_prep_debug_14.build();
      this.default_map.add_reg(this.s1_prep_debug_14, `UVM_REG_ADDR_WIDTH'h7C, "RW", 0);
		this.s1_prep_debug_14_s1_prep_debug_14 = this.s1_prep_debug_14.s1_prep_debug_14;
      this.s1_prep_debug_15 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_15::type_id::create("s1_prep_debug_15",,get_full_name());
      this.s1_prep_debug_15.configure(this, null, "");
      this.s1_prep_debug_15.build();
      this.default_map.add_reg(this.s1_prep_debug_15, `UVM_REG_ADDR_WIDTH'h80, "RW", 0);
		this.s1_prep_debug_15_s1_prep_debug_15 = this.s1_prep_debug_15.s1_prep_debug_15;
      this.s1_prep_debug_16 = ral_reg_m_map0_rsp_s2_prep_reg_s1_prep_debug_16::type_id::create("s1_prep_debug_16",,get_full_name());
      this.s1_prep_debug_16.configure(this, null, "");
      this.s1_prep_debug_16.build();
      this.default_map.add_reg(this.s1_prep_debug_16, `UVM_REG_ADDR_WIDTH'h84, "RW", 0);
		this.s1_prep_debug_16_s1_prep_debug_16 = this.s1_prep_debug_16.s1_prep_debug_16;
      this.last_register = ral_reg_m_map0_rsp_s2_prep_reg_last_register::type_id::create("last_register",,get_full_name());
      this.last_register.configure(this, null, "");
      this.last_register.build();
      this.default_map.add_reg(this.last_register, `UVM_REG_ADDR_WIDTH'h88, "RO", 0);
		this.last_register_last_register = this.last_register.last_register;
	  uvm_config_db #(uvm_reg_block)::set(null,"","RegisterModel_Debug",this);
   endfunction : build

	`uvm_object_utils(ral_block_m_map0_rsp_s2_prep_reg)

endclass : ral_block_m_map0_rsp_s2_prep_reg



`endif
