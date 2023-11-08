-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
-- Date        : Thu Sep 28 10:35:42 2023
-- Host        : DESKTOP-MEDKETV running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/work/shangjian/vivado2021/RCI_Yu_0913_add_inter/design/bd/design_0/ip/design_0_xbar_1/design_0_xbar_1_stub.vhdl
-- Design      : design_0_xbar_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu15eg-ffvb1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_0_xbar_1 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awuser : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 39 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_aruser : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_awid : out STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 439 downto 0 );
    m_axi_awlen : out STD_LOGIC_VECTOR ( 87 downto 0 );
    m_axi_awsize : out STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_awburst : out STD_LOGIC_VECTOR ( 21 downto 0 );
    m_axi_awlock : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_awcache : out STD_LOGIC_VECTOR ( 43 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_awregion : out STD_LOGIC_VECTOR ( 43 downto 0 );
    m_axi_awqos : out STD_LOGIC_VECTOR ( 43 downto 0 );
    m_axi_awuser : out STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_awready : in STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_wdata : out STD_LOGIC_VECTOR ( 1407 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_wlast : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_bid : in STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_bresp : in STD_LOGIC_VECTOR ( 21 downto 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_bready : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_arid : out STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_araddr : out STD_LOGIC_VECTOR ( 439 downto 0 );
    m_axi_arlen : out STD_LOGIC_VECTOR ( 87 downto 0 );
    m_axi_arsize : out STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_arburst : out STD_LOGIC_VECTOR ( 21 downto 0 );
    m_axi_arlock : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_arcache : out STD_LOGIC_VECTOR ( 43 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 32 downto 0 );
    m_axi_arregion : out STD_LOGIC_VECTOR ( 43 downto 0 );
    m_axi_arqos : out STD_LOGIC_VECTOR ( 43 downto 0 );
    m_axi_aruser : out STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_arready : in STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_rid : in STD_LOGIC_VECTOR ( 175 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 1407 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 21 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 10 downto 0 );
    m_axi_rready : out STD_LOGIC_VECTOR ( 10 downto 0 )
  );

end design_0_xbar_1;

architecture stub of design_0_xbar_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axi_awid[15:0],s_axi_awaddr[39:0],s_axi_awlen[7:0],s_axi_awsize[2:0],s_axi_awburst[1:0],s_axi_awlock[0:0],s_axi_awcache[3:0],s_axi_awprot[2:0],s_axi_awqos[3:0],s_axi_awuser[15:0],s_axi_awvalid[0:0],s_axi_awready[0:0],s_axi_wdata[127:0],s_axi_wstrb[15:0],s_axi_wlast[0:0],s_axi_wvalid[0:0],s_axi_wready[0:0],s_axi_bid[15:0],s_axi_bresp[1:0],s_axi_bvalid[0:0],s_axi_bready[0:0],s_axi_arid[15:0],s_axi_araddr[39:0],s_axi_arlen[7:0],s_axi_arsize[2:0],s_axi_arburst[1:0],s_axi_arlock[0:0],s_axi_arcache[3:0],s_axi_arprot[2:0],s_axi_arqos[3:0],s_axi_aruser[15:0],s_axi_arvalid[0:0],s_axi_arready[0:0],s_axi_rid[15:0],s_axi_rdata[127:0],s_axi_rresp[1:0],s_axi_rlast[0:0],s_axi_rvalid[0:0],s_axi_rready[0:0],m_axi_awid[175:0],m_axi_awaddr[439:0],m_axi_awlen[87:0],m_axi_awsize[32:0],m_axi_awburst[21:0],m_axi_awlock[10:0],m_axi_awcache[43:0],m_axi_awprot[32:0],m_axi_awregion[43:0],m_axi_awqos[43:0],m_axi_awuser[175:0],m_axi_awvalid[10:0],m_axi_awready[10:0],m_axi_wdata[1407:0],m_axi_wstrb[175:0],m_axi_wlast[10:0],m_axi_wvalid[10:0],m_axi_wready[10:0],m_axi_bid[175:0],m_axi_bresp[21:0],m_axi_bvalid[10:0],m_axi_bready[10:0],m_axi_arid[175:0],m_axi_araddr[439:0],m_axi_arlen[87:0],m_axi_arsize[32:0],m_axi_arburst[21:0],m_axi_arlock[10:0],m_axi_arcache[43:0],m_axi_arprot[32:0],m_axi_arregion[43:0],m_axi_arqos[43:0],m_axi_aruser[175:0],m_axi_arvalid[10:0],m_axi_arready[10:0],m_axi_rid[175:0],m_axi_rdata[1407:0],m_axi_rresp[21:0],m_axi_rlast[10:0],m_axi_rvalid[10:0],m_axi_rready[10:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "axi_crossbar_v2_1_25_axi_crossbar,Vivado 2021.1";
begin
end;
