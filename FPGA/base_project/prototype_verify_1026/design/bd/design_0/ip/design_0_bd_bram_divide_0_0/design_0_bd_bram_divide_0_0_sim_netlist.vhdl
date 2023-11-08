-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
-- Date        : Mon Sep 11 12:02:59 2023
-- Host        : DESKTOP-1U5KA9Q running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/work/debug_2021/RCI_Yu_0907_rst_test/design/bd/design_0/ip/design_0_bd_bram_divide_0_0/design_0_bd_bram_divide_0_0_sim_netlist.vhdl
-- Design      : design_0_bd_bram_divide_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu15eg-ffvb1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_0_bd_bram_divide_0_0 is
  port (
    bram_addr_a : in STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_clk_a : in STD_LOGIC;
    bram_wrdata_a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_a : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_en_a : in STD_LOGIC;
    bram_rst_a : in STD_LOGIC;
    bram_we_a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_addr_0 : out STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_clk_0 : out STD_LOGIC;
    bram_wrdata_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_en_0 : out STD_LOGIC;
    bram_rst_0 : out STD_LOGIC;
    bram_we_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_addr_1 : out STD_LOGIC_VECTOR ( 12 downto 0 );
    bram_clk_1 : out STD_LOGIC;
    bram_wrdata_1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_rddata_1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    bram_en_1 : out STD_LOGIC;
    bram_rst_1 : out STD_LOGIC;
    bram_we_1 : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_0_bd_bram_divide_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_0_bd_bram_divide_0_0 : entity is "design_0_bd_bram_divide_0_0,bd_bram_divide,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_0_bd_bram_divide_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_0_bd_bram_divide_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_0_bd_bram_divide_0_0 : entity is "bd_bram_divide,Vivado 2021.1";
end design_0_bd_bram_divide_0_0;

architecture STRUCTURE of design_0_bd_bram_divide_0_0 is
  signal \^bram_addr_a\ : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal \^bram_clk_a\ : STD_LOGIC;
  signal \^bram_en_a\ : STD_LOGIC;
  signal \^bram_rddata_1\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^bram_rst_a\ : STD_LOGIC;
  signal \^bram_we_a\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^bram_wrdata_a\ : STD_LOGIC_VECTOR ( 31 downto 0 );
begin
  \^bram_addr_a\(12 downto 0) <= bram_addr_a(12 downto 0);
  \^bram_clk_a\ <= bram_clk_a;
  \^bram_en_a\ <= bram_en_a;
  \^bram_rddata_1\(31 downto 0) <= bram_rddata_1(31 downto 0);
  \^bram_rst_a\ <= bram_rst_a;
  \^bram_we_a\(3 downto 0) <= bram_we_a(3 downto 0);
  \^bram_wrdata_a\(31 downto 0) <= bram_wrdata_a(31 downto 0);
  bram_addr_0(12 downto 0) <= \^bram_addr_a\(12 downto 0);
  bram_addr_1(12 downto 0) <= \^bram_addr_a\(12 downto 0);
  bram_clk_0 <= \^bram_clk_a\;
  bram_clk_1 <= \^bram_clk_a\;
  bram_en_0 <= \^bram_en_a\;
  bram_en_1 <= \^bram_en_a\;
  bram_rddata_a(31 downto 0) <= \^bram_rddata_1\(31 downto 0);
  bram_rst_0 <= \^bram_rst_a\;
  bram_rst_1 <= \^bram_rst_a\;
  bram_we_0(3 downto 0) <= \^bram_we_a\(3 downto 0);
  bram_we_1(3 downto 0) <= \^bram_we_a\(3 downto 0);
  bram_wrdata_0(31 downto 0) <= \^bram_wrdata_a\(31 downto 0);
  bram_wrdata_1(31 downto 0) <= \^bram_wrdata_a\(31 downto 0);
end STRUCTURE;
