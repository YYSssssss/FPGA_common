-- =================================================================================================
-- Phine Design (Japan) Co., Ltd.
-- https://www.phinedesign.co.jp
-- =================================================================================================

-- =================================================================================================
-- File Name      : PULSE_GEN.vhd
-- Module         : PULSE_GEN
-- Function       : Synchronous pulse from CLK_I to CLK_O
-- Type           : RTL
-- -------------------------------------------------------------------------------------------------
-- Update History :
-- -------------------------------------------------------------------------------------------------
-- Rev.Level  Date         Coded by         Contents
-- 1.0.0      2022/08/02   PDJP   			PDJP(K)-02-001(01)
--
-- =================================================================================================
-- End Revision
-- =================================================================================================

library IEEE ;
use IEEE.STD_LOGIC_1164.ALL ;
use IEEE.STD_LOGIC_UNSIGNED.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL ;


-- =================================================================================================
-- RTL Header
-- =================================================================================================
entity PULSE_GEN is
    port (
        XRST        		: in    std_logic               					; -- Reset Input ( Asynchronous )
        CLK_I       		: in    std_logic               					; -- Clock at input side
        CLK_O       		: in    std_logic               					; -- Clock at output side
        PULSE_I     		: in    std_logic               					; -- Pulse input
        PULSE_O     		: out   std_logic               					  -- Pulse output
        ) ;
end PULSE_GEN ;

architecture RTL of PULSE_GEN is

	-- -------------------------------------------------------------------------
	-- Internal Signal Definition
	-- -------------------------------------------------------------------------
    signal  r_pulse_i   	: std_logic                     					; -- PULSE_I Toogle
    signal  r_pulse_o   	: std_logic_vector(2 downto 0)  					; -- Sync of r_pulse_i

begin

-- =================================================================================================
-- RTL Body
-- =================================================================================================

	-- -------------------------------------------------------------------------
	--      Input pulse keep                            ( CLK_I domain )
	-- -------------------------------------------------------------------------
	process ( CLK_I, XRST ) begin
	    if( XRST = '0' ) then
	        r_pulse_i       <=  '0' ;
	    elsif ( CLK_I'Event and CLK_I = '1' ) then
	        if ( PULSE_I = '1' ) then
	            r_pulse_i   <= not r_pulse_i ;
	        end if ;
	    end if ;
	end process ;
	
	-- -------------------------------------------------------------------------
	--      Output pulse sync. and generate             ( CLK_O domain )
	-- -------------------------------------------------------------------------
	process ( CLK_O, XRST ) begin
	    if(  XRST = '0' ) then
	        r_pulse_o   <= ( others => '0' ) ;
	    elsif ( CLK_O'Event and CLK_O = '1' ) then
	        r_pulse_o   <= r_pulse_o(1 downto 0) & r_pulse_i ;
	    end if ;
	end process ;
	
	PULSE_O <=  '1' when ( r_pulse_o(2) /= r_pulse_o(1) ) else '0' ;   -- 0 -> 1

end RTL ;
