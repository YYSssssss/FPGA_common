-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Wed Sep  8 14:23:04 2021
-- Host        : DESKTOP-67QOBKQ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/work/fei/TDD/lphy_project/dl_lphy/xci/gain_block_1/gain_block_1_stub.vhdl
-- Design      : gain_block_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu47dr-fsve1156-2-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gain_block_1 is
  Port ( 
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 19 downto 0 );
    B : in STD_LOGIC_VECTOR ( 15 downto 0 );
    CE : in STD_LOGIC;
    P : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );

end gain_block_1;

architecture stub of gain_block_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,A[19:0],B[15:0],CE,P[19:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "mult_gen_v12_0_16,Vivado 2020.2";
begin
end;
