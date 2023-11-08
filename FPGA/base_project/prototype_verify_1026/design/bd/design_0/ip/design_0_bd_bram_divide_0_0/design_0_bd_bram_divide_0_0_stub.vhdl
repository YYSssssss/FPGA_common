-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
-- Date        : Mon Sep 11 12:02:59 2023
-- Host        : DESKTOP-1U5KA9Q running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/work/debug_2021/RCI_Yu_0907_rst_test/design/bd/design_0/ip/design_0_bd_bram_divide_0_0/design_0_bd_bram_divide_0_0_stub.vhdl
-- Design      : design_0_bd_bram_divide_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu15eg-ffvb1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_0_bd_bram_divide_0_0 is
  Port ( 
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

end design_0_bd_bram_divide_0_0;

architecture stub of design_0_bd_bram_divide_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "bram_addr_a[12:0],bram_clk_a,bram_wrdata_a[31:0],bram_rddata_a[31:0],bram_en_a,bram_rst_a,bram_we_a[3:0],bram_addr_0[12:0],bram_clk_0,bram_wrdata_0[31:0],bram_en_0,bram_rst_0,bram_we_0[3:0],bram_addr_1[12:0],bram_clk_1,bram_wrdata_1[31:0],bram_rddata_1[31:0],bram_en_1,bram_rst_1,bram_we_1[3:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "bd_bram_divide,Vivado 2021.1";
begin
end;
