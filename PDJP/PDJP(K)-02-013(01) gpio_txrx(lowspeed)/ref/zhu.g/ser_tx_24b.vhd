-- =================================================================================================
-- File Name      : ser_tx_24b.vhd
-- Module         : FPGA1 SW LED
-- Function       : uart_tx Control
-- Type           : RTL
-- -------------------------------------------------------------------------------------------------
-- Update History :
-- -------------------------------------------------------------------------------------------------
-- Rev.Level  Date         Coded by        Contents
-- 0.0.1      2016/01/18   TEDWX)tang.wl   create new
--
-- =================================================================================================
-- End Revision
-- =================================================================================================

library IEEE						;
	use IEEE.STD_LOGIC_1164.ALL		;
	use IEEE.STD_LOGIC_UNSIGNED.ALL	;
	use IEEE.STD_LOGIC_ARITH.ALL	;

library UNISIM;
--use UNISIM.VCOMPONENTS.ALL;

entity ser_tx_24b is
		generic(
		C_BIT_CNT					: std_logic_vector( 11 downto 0) := X"00D" ); 		-- UART 1085 clk Receiving 1 Bit
		port (
 		-- Global Signal
 		CLK_100M					: in  	std_logic ;                         -- System Clock 100MHz
		IO_RESET					: in 	std_logic ;  						-- ASY System Reset

		SER_TXD						: out	std_logic ;  						-- UART Output Data
		SER_TX_EN					: in	std_logic ;  						-- UART TX Data Enable
		SER_TX_DATA					: in 	std_logic_vector(23 downto 0);		-- UART TX Data
		SER_TX_COMPLETE				: out  	std_logic   						-- UART 8Bit Data TX Complete
        ) ;

end ser_tx_24b ;

architecture rtl of ser_tx_24b is

--	--==============================================================
--	-- CONSTANT
--	--==============================================================
--	constant	C_BIT_CNT		: std_logic_vector( 11 downto 0) := X"364" ; 	-- UART 868 clk Receiving 1 Bit

	--==============================================================
	-- INSIDE SINGLE DEFINE
	--==============================================================
	type FSM_TX 	 is(		TX_IDLE				, -- idle
        						TX_START			, -- start
        						TX_DATA				, -- tx data
        						TX_END 				  -- end
    	) ;

	signal	r_TX_FSM			: FSM_TX			; -- state_fsm
	-- TXD
	signal	r_SER_TX_DATA			: std_logic_vector(23 downto 0) 	; -- UART_TXD TX Data Count
	signal	s_TX_BIT_END			: std_logic							; -- UART_TXD TX 1 Bit Clk End
	signal	r_TX_BIT_CNT			: std_logic_vector( 7 downto 0) 	; -- UART_TXD TX Data Count
	signal	s_TX_FSM_IDLE			: std_logic							; -- TXD FSM IDLE Status
	signal	s_TX_FSM_TX_START		: std_logic							; -- TXD FSM START Status
	signal	s_TX_FSM_TX_DATA		: std_logic							; -- TXD FSM DATA Status
	signal	s_TX_FSM_TX_END			: std_logic							; -- TXD FSM END Status
	signal	r_TX_CNT				: std_logic_vector(11 downto 0) 	; -- UART_TXD TX Count
	signal	r_TXD					: std_logic_vector(23 downto 0) 	; -- UART_TXD Onput
	signal	r_TX_COMPLETE			: std_logic							; -- UART_TXD 8Bit Data Transmit Complete
	signal	r_UART_TX_EN_1D			: std_logic							; -- UART_TX_EN Delay 1Clk

begin
	-- =====================================================
	-- UART Transmit Control
	-- =====================================================
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_SER_TX_DATA <= (others => '0') ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if ( SER_TX_EN = '1' ) then
				r_SER_TX_DATA <= SER_TX_DATA ;
			end if ;
		end if ;
	end process ;


	s_TX_BIT_END 	<=  '1' when ( r_TX_CNT = C_BIT_CNT	) else '0' ;

	-- TXD Main FSM
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_TX_FSM <= TX_IDLE ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			case ( r_TX_FSM ) is

				when TX_IDLE	=>
					if( SER_TX_EN = '1' ) then
						r_TX_FSM <= TX_START ;
					else
						r_TX_FSM <= TX_IDLE ;
					end if ;

				when TX_START	=>
					if( s_TX_BIT_END = '1' ) then
						r_TX_FSM <= TX_DATA ;
					else
						r_TX_FSM <= TX_START ;
					end if ;


				when TX_DATA	=>
					if( s_TX_BIT_END = '1' and r_TX_BIT_CNT = X"17" ) then	-- 24 bit
						r_TX_FSM <= TX_END ;
					else
						r_TX_FSM <= TX_DATA ;
					end if ;

				when TX_END		=>
					if( s_TX_BIT_END = '1' ) then
						r_TX_FSM <= TX_IDLE ;
					else
						r_TX_FSM <= TX_END ;
					end if ;

				when others    =>
					r_TX_FSM  <= TX_IDLE ;
			end case ;
		end if ;
	end process ;

	-- FSM Decode
	s_TX_FSM_IDLE		<= '1' when ( r_TX_FSM = TX_IDLE  ) else '0' ;
	s_TX_FSM_TX_START	<= '1' when ( r_TX_FSM = TX_START ) else '0' ;
	s_TX_FSM_TX_DATA	<= '1' when ( r_TX_FSM = TX_DATA  ) else '0' ;
	s_TX_FSM_TX_END		<= '1' when ( r_TX_FSM = TX_END	  ) else '0' ;

	-- TX_CNT
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_UART_TX_EN_1D <= '0' ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			r_UART_TX_EN_1D <= SER_TX_EN ;
		end if ;
	end process ;

	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_TX_CNT <= X"000" ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_TX_FSM_IDLE = '1' ) then
				if( r_UART_TX_EN_1D = '1' ) then
					r_TX_CNT <= r_TX_CNT + 1 ;
				else
					r_TX_CNT <= X"000" ;
				end if ;
			elsif( s_TX_FSM_TX_START = '1' or
				   s_TX_FSM_TX_DATA  = '1' or
				   s_TX_FSM_TX_END   = '1' ) then
				if( s_TX_BIT_END = '1' ) then
					r_TX_CNT <= X"000" ;
				else
					r_TX_CNT <= r_TX_CNT + 1 ;
				end if ;
			end if ;
		end if ;
	end process ;

	-- TX_BIT_CNT
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_TX_BIT_CNT <= X"00" ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_TX_FSM_TX_DATA = '1' ) then
				if( s_TX_BIT_END = '1' ) then
					if( r_TX_BIT_CNT = X"17" ) then
						r_TX_BIT_CNT <= X"00" ;
					else
						r_TX_BIT_CNT <= r_TX_BIT_CNT + 1;
					end if ;
				else
					r_TX_BIT_CNT <= r_TX_BIT_CNT ;
				end if ;
			else
				r_TX_BIT_CNT <= X"00" ;
			end if ;
		end if ;
	end process ;

	-- TXD Control
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_TXD <= X"FFFFFF" ;
		elsif (CLK_100M'event and CLK_100M = '1') then

			case ( r_TX_FSM ) is

				when TX_IDLE	=>
					if( SER_TX_EN = '1' ) then
						r_TXD <= X"FFFFFE" ;
					else
						r_TXD <= X"FFFFFF" ;
					end if ;

				when TX_START	=>
					if( s_TX_BIT_END = '1' ) then
						r_TXD <= r_SER_TX_DATA ;
					else
						r_TXD <= X"FFFFFE" ;
					end if ;

				when TX_DATA	=>
					if( s_TX_BIT_END = '1' ) then
						if( r_TX_BIT_CNT = X"17" ) then
							r_TXD <= X"FFFFFF" ;
						else
							r_TXD <= ( '1' & r_TXD( 23 downto 1 ) ) ;
						end if ;
					else
						r_TXD <= r_TXD ;
					end if ;

				when TX_END		=>
					if( s_TX_BIT_END = '1' ) then
						r_TXD <= X"FFFFFF" ;
					else
						r_TXD <= r_TXD ;
					end if ;

				when others    =>
					r_TXD  <= r_TXD ;
			end case ;
		end if ;
	end process ;

	SER_TXD	<= r_TXD(0) ;

	-- TX_COMPLETE
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_TX_COMPLETE <= '0' ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_TX_BIT_END = '1' ) then
				if( s_TX_FSM_TX_END = '1' ) then
					r_TX_COMPLETE <= '1' ;
				else
					r_TX_COMPLETE <= '0' ;
				end if ;
			else
				r_TX_COMPLETE <= '0' ;
			end if ;
		end if ;
	end process ;

	SER_TX_COMPLETE	<= r_TX_COMPLETE ;

end rtl ;

