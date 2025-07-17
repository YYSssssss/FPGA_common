-- =================================================================================================
-- File Name      : ser_rx_24b.vhd
-- Module         : ser_rx_24b
-- Function       : ser_rx_24b Control
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

entity ser_rx_24b is
		generic(
		C_BIT_CNT					: std_logic_vector( 11 downto 0) := X"00D" ); 		-- UART 1085 clk Receiving 1 Bit
		port (
 		-- Global Signal
 		CLK_100M					: in  	std_logic ;                         -- System Clock 120MHz
		IO_RESET					: in 	std_logic ;  						-- ASY System Reset

		SER_RXD						: in  	std_logic ;  						-- UART Iutput Data
		SER_RX_COMPLETE				: out 	std_logic ;							-- UART RX 1 Byte Data Complete
		SER_RX_DATA					: out	std_logic_vector(23 downto 0)		-- UART Receiving Data

        ) ;

end ser_rx_24b ;

architecture rtl of ser_rx_24b is

--	--==============================================================
--	-- CONSTANT
--	--==============================================================
--	constant	C_BIT_CNT			: std_logic_vector( 11 downto 0) := X"364" ; 	-- UART 868 clk Receiving 1 Bit

	--==============================================================
	-- INSIDE SINGLE DEFINE
	--==============================================================

	type FSM_RX 	 is(		RX_IDLE				, -- idle
        						RX_START			, -- start
        						RX_DATA				, -- rx data
        						RX_END 				  -- end
    	) ;

	signal	r_RX_FSM			: FSM_RX			; -- state_fsm

	-- RXD
 	signal	r_RXD_1D				: std_logic							; -- SER_RXD Input Register
    signal	r_RXD_2D 	    		: std_logic							; -- SER_RXD Input Register
	signal	r_RXD_3D 	    		: std_logic							; -- SER_RXD Input Register
	signal	r_RXD 	    			: std_logic							; -- SER_RXD Input Register
	signal	r_RX_CNT 	 			: std_logic_vector( 11 downto 0) 	; -- SER_RXD RX Count
	signal	s_HALF_BIT_CNT 	   		: std_logic_vector( 10 downto 0)	; -- SER_RXD RX 1/2 Bit Clk Count
	signal	s_HALF_BIT_END 	  		: std_logic							; -- SER_RXD RX 1/2 Bit Clk end
	signal	s_RX_BIT_END 	    	: std_logic							; -- SER_RXD RX 1 Bit End
	signal	s_RX_FSM_IDLE			: std_logic							; -- RXD FSM IDLE Status
	signal	s_RX_FSM_RX_START		: std_logic							; -- RXD FSM START Status
	signal	s_RX_FSM_RX_DATA		: std_logic							; -- RXD FSM DATA Status
	signal	s_RX_FSM_RX_END			: std_logic							; -- RXD FSM END Status
	signal	r_RX_BIT_CNT			: std_logic_vector( 7 downto 0) 	; -- UART Receive Data Count
	signal	r_RX_DATA				: std_logic_vector(23 downto 0) 	; -- UART Receive Data
	signal	r_RX_COMPLETE			: std_logic							; -- UART 8Bit Data Receive Complete
	signal	r_SER_RX_DATA			: std_logic_vector(23 downto 0) 	; -- UART Receive Data
	signal	r_SER_RX_COMPLETE		: std_logic							; -- UART 8Bit Data Receive Complete


begin
	-- =====================================================
	-- UART Receive Control
	-- =====================================================
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RXD_1D <= '1' ;
            r_RXD_2D <= '1' ;
			r_RXD_3D <= '1' ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			r_RXD_1D <= SER_RXD ;
            r_RXD_2D <= r_RXD_1D ;
            r_RXD_3D <= r_RXD_2D ;
		end if  ;
	end process ;

	-- Filter Noise
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RXD <= '1';
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( r_RXD_2D = r_RXD_3D ) then
				r_RXD <= r_RXD_2D ;
			else
				r_RXD <= r_RXD ;
			end if ;
		end if ;
	end process ;

	s_HALF_BIT_CNT	<=  C_BIT_CNT(11 downto 1) ;
	s_RX_BIT_END 	<=  '1' when ( r_RX_CNT = C_BIT_CNT	) else '0' ;
	s_HALF_BIT_END	<=  '1' when ( r_RX_CNT = s_HALF_BIT_CNT ) else '0' ;

	-- RXD Main FSM
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RX_FSM <= RX_IDLE ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			case ( r_RX_FSM ) is

				when RX_IDLE 	=>
					if( r_RXD = '0' ) then
						r_RX_FSM <= RX_START ;
					else
						r_RX_FSM <= RX_IDLE ;
					end if ;

				when RX_START =>
					if( s_HALF_BIT_END ='1' ) then
						if( r_RXD = '1' ) then
							r_RX_FSM <= RX_IDLE ;
						else
							r_RX_FSM <= RX_START ;
						end if ;
					elsif( s_RX_BIT_END = '1' ) then
						r_RX_FSM <=RX_DATA ;
					else
						r_RX_FSM <= RX_START ;
					end if ;

				when RX_DATA =>
					if( s_RX_BIT_END = '1' and r_RX_BIT_CNT = X"17" ) then
						r_RX_FSM <= RX_END ;
					else
						r_RX_FSM <= RX_DATA ;
					end if ;

				when RX_END  =>
		--			if( s_RX_BIT_END = '1' ) then
		--				if( r_RXD = '0') then
		--					r_RX_FSM <= RX_START ;
		--				else
		--					r_RX_FSM <= RX_IDLE ;
		--				end if ;
		--			else
		--				r_RX_FSM <= RX_END ;
		--			end if ;
					if( s_HALF_BIT_END = '1' ) then
						r_RX_FSM <= RX_IDLE ;
					else
						r_RX_FSM <= RX_END ;
					end if ;

          		when others    =>
					r_RX_FSM  <= RX_IDLE ;
			end case ;
		end if ;
	end process ;

	-- FSM Decode
	s_RX_FSM_IDLE		<= '1' when ( r_RX_FSM = RX_IDLE  ) else '0' ;
	s_RX_FSM_RX_START	<= '1' when ( r_RX_FSM = RX_START ) else '0' ;
	s_RX_FSM_RX_DATA	<= '1' when ( r_RX_FSM = RX_DATA  ) else '0' ;
	s_RX_FSM_RX_END		<= '1' when ( r_RX_FSM = RX_END	  ) else '0' ;

	-- RX_CNT
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RX_CNT <= X"000" ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_RX_FSM_IDLE = '1' ) then
				if( r_RXD = '0' ) then
					r_RX_CNT <= X"000" ;
				end if ;
			elsif((	s_RX_FSM_RX_START = '1' or
				   	s_RX_FSM_RX_DATA  = '1' ) and
					s_RX_BIT_END = '1'	) then
				r_RX_CNT <= X"000" ;
			elsif( 	s_RX_FSM_RX_END   = '1' and 		-- Rx End
					s_HALF_BIT_END = '1' ) then
				r_RX_CNT <= X"000" ;
			else
				r_RX_CNT <= r_RX_CNT + 1 ;
			end if ;
		end if ;
	end process ;

	-- RX_BIT_CNT
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RX_BIT_CNT <= X"00" ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_RX_FSM_RX_DATA = '1' ) then
				if( s_RX_BIT_END = '1' ) then
					if( r_RX_BIT_CNT = X"17" ) then
						r_RX_BIT_CNT <= X"00" ;
					else
						r_RX_BIT_CNT <= r_RX_BIT_CNT + 1;
					end if ;
				else
					r_RX_BIT_CNT <= r_RX_BIT_CNT ;
				end if ;
			else
				r_RX_BIT_CNT <= X"00" ;
			end if ;
		end if ;
	end process ;

	-- UART Receive DATA
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RX_DATA <= (others => '0') ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_RX_FSM_RX_DATA = '1' ) then
				if( s_HALF_BIT_END = '1' ) then
					r_RX_DATA <= ( r_RXD & r_RX_DATA(23 downto 1) ) ;
				else
					r_RX_DATA <= r_RX_DATA ;
				end if ;
			else
				r_RX_DATA <= r_RX_DATA ;
			end if ;
		end if ;
	end process ;

	-- 8Bit Data Receive Complete
	-- RX_DATA is not VALID
	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_RX_COMPLETE <= '0' ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( s_RX_FSM_RX_END = '1' and s_HALF_BIT_END = '1' ) then
				r_RX_COMPLETE <= '1' ;
			else
				r_RX_COMPLETE <= '0' ;
			end if ;
		end if ;
	end process ;

	process(CLK_100M,IO_RESET)begin
		if( IO_RESET = '1') then
			r_SER_RX_DATA <= (others => '0') ;
			r_SER_RX_COMPLETE <= '0' ;
		elsif (CLK_100M'event and CLK_100M = '1') then
			if( r_RX_COMPLETE = '1' ) then
				r_SER_RX_DATA <= r_RX_DATA ;
			end if ;
			r_SER_RX_COMPLETE <= r_RX_COMPLETE ;
		end if ; 
	end process ;

	SER_RX_DATA <= r_SER_RX_DATA ;
	SER_RX_COMPLETE <= r_SER_RX_COMPLETE ;

end rtl ;

