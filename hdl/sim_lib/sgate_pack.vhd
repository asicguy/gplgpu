-- Copyright (C) 1991-2011 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.
-- Quartus II 11.0 Build 157 04/27/2011

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

PACKAGE sgate_pack IS

	 function sgate_conv_integer(arg : in std_logic_vector)
             return integer;
	
	 COMPONENT  oper_add
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		cout	:	OUT STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_addsub
	 GENERIC 
	 (
		sgate_representation	: NATURAL ;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		addnsub	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  mux21
	 PORT
	 ( 
		dataa	:	IN STD_LOGIC;
		datab	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		outputselect	:	IN STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  io_buf_tri
	 PORT
	 ( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		oe	:	IN STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  io_buf_opdrn
	 PORT
	 ( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;


	 COMPONENT  tri_bus
	 GENERIC
	 (
		width_datain	: NATURAL; 	
		width_dataout	: NATURAL 	
	 );
	 PORT
	 ( 
		datain	:	IN STD_LOGIC_VECTOR(width_datain-1 downto 0);
		dataout	:	OUT STD_LOGIC_VECTOR(width_dataout-1 downto 0)
	 ); 
	 END COMPONENT;


	 COMPONENT  oper_mult
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_div
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_mod
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_left_shift
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_right_shift
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_rotate_left
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_rotate_right
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_amount	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_less_than
	 GENERIC 
	 (
		sgate_representation	: NATURAL;
		width_a	:	NATURAL;
		width_b	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_mux
	 GENERIC 
	 (
		width_sel	:	NATURAL;
		width_data	:	NATURAL
	 );
	 PORT
	 ( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;


	 COMPONENT  oper_selector
	 GENERIC 
	 (
		width_sel	:	NATURAL;
		width_data	:	NATURAL
	 );
	 PORT
	 ( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_prio_selector
	 GENERIC 
	 (
		width_sel	:	NATURAL;
		width_data	:	NATURAL
	 );
	 PORT
	 ( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;

	 COMPONENT  oper_decoder
	 GENERIC 
	 (
		width_i	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		i	:	IN STD_LOGIC_VECTOR(width_i-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;


	 COMPONENT  oper_bus_mux
	 GENERIC 
	 (
		width_a	:	NATURAL;
		width_b	:	NATURAL;
		width_o	:	NATURAL
	 );
	 PORT
	 ( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		sel	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	 ); 
	 END COMPONENT;

	COMPONENT oper_latch
	PORT
	(
		datain	:	IN STD_LOGIC;
		aclr	:	IN STD_LOGIC;
		preset	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		latch_enable	:	IN STD_LOGIC
	);
	END COMPONENT;


END sgate_pack;	

package body sgate_pack is

-- convert std_logic_vector to integer
function sgate_conv_integer(arg : in std_logic_vector) return integer is
variable result : integer := 0;
begin
    result := 0;
    for i in arg'range loop
        if arg(i) = '1' then
            result := result + 2**i;
        end if;
    end loop;
    return result;
end sgate_conv_integer;

end sgate_pack;

