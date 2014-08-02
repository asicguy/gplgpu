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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY oper_add IS
	GENERIC 
	(
		sgate_representation	: NATURAL :=1;
		width_a	:	NATURAL:=8;
		width_b	:	NATURAL:=8;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		cout	:	OUT STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_add;

ARCHITECTURE sim_arch OF oper_add IS

SIGNAL 	a_ext	: STD_LOGIC_VECTOR(width_a+1 DOWNTO 0);
SIGNAL 	b_ext	: STD_LOGIC_VECTOR(width_a+1 DOWNTO 0);
SIGNAL 	o_ext	: STD_LOGIC_VECTOR(width_a+1 DOWNTO 0);

BEGIN

   MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        if (width_o <= 0) then
            ASSERT FALSE
            REPORT "Value of width_o parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        if (width_a /= width_b) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to value of width_b parameter!"
            SEVERITY ERROR;
        end if;   
        if (width_a /= width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to value of width_o parameter!"
            SEVERITY ERROR;
        end if; 
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1(SIGNED) or 0(UNSIGNED)!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

g1: IF (width_a=width_b) AND (width_b=width_o) GENERATE

	a_ext(width_a-1 DOWNTO 0) 	<= a(width_a-1 DOWNTO 0);
	b_ext(width_a-1 DOWNTO 0) 	<= b(width_a-1 DOWNTO 0);
	
	g2: IF (sgate_representation>0) GENERATE
		a_ext(width_a) 		<= a_ext(width_a-1);
		a_ext(width_a+1) 	<= a_ext(width_a-1);
		b_ext(width_a) 		<= b_ext(width_a-1);
		b_ext(width_a+1) 	<= b_ext(width_a-1);
	END GENERATE g2;

	g3: IF (sgate_representation=0) GENERATE
		a_ext(width_a) 		<= '0';
		a_ext(width_a+1) 	<= '0';
		b_ext(width_a) 		<= '0';
		b_ext(width_a+1) 	<= '0';		
	END GENERATE g3;	
		
	o_ext <= cin+a_ext+b_ext;
	cout	<= o_ext(width_a);
	o(width_o-1 DOWNTO 0) 		<= o_ext(width_a-1 DOWNTO 0);
		
END GENERATE g1;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY  oper_addsub IS
	GENERIC 
	(
		sgate_representation	: NATURAL :=1;
		width_a	:	NATURAL	:=8;
		width_b	:	NATURAL	:=8;
		width_o	:	NATURAL	:=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		addnsub	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_addsub;

ARCHITECTURE sim_arch OF oper_addsub IS

SIGNAL 	a_ext	: STD_LOGIC_VECTOR(width_a DOWNTO 0);
SIGNAL 	b_ext	: STD_LOGIC_VECTOR(width_a DOWNTO 0);
SIGNAL 	o_ext	: STD_LOGIC_VECTOR(width_a DOWNTO 0);

BEGIN
	
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_o <= 0) then
            ASSERT FALSE
            REPORT "Value of width_o parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_a /= width_b) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to value of width_b parameter!"
            SEVERITY ERROR;
        end if;   
        
        if (width_a /= width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to value of width_o parameter!"
            SEVERITY ERROR;
        end if; 
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

g1: IF (width_a=width_b) AND (width_b=width_o) GENERATE

	a_ext(width_a-1 DOWNTO 0) 	<= a(width_a-1 DOWNTO 0);
	b_ext(width_a-1 DOWNTO 0) 	<= b(width_a-1 DOWNTO 0);
	
	g2: IF (sgate_representation>0) GENERATE
		a_ext(width_a) 		<= a_ext(width_a-1);
		b_ext(width_a) 		<= b_ext(width_a-1);
	END GENERATE g2;

	g3: IF (sgate_representation=0) GENERATE
		a_ext(width_a) 		<= '0';
		b_ext(width_a) 		<= '0';
	END GENERATE g3;	
		
	o_ext <= a_ext+b_ext when (addnsub='1') ELSE a_ext-b_ext;

	o(width_o-1 DOWNTO 0) 		<= o_ext(width_a-1 DOWNTO 0);
		
END GENERATE g1;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  mux21 IS
	PORT
	( 
		dataa	:	IN STD_LOGIC;
		datab	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		outputselect	:	IN STD_LOGIC
	); 
END mux21;

ARCHITECTURE sim_arch OF mux21 IS

BEGIN

	dataout <= dataa WHEN outputselect='0' ELSE datab;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  io_buf_tri IS
	PORT
	( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		oe	:	IN STD_LOGIC
	); 
END io_buf_tri;

ARCHITECTURE sim_arch OF io_buf_tri IS
BEGIN

	dataout <= datain WHEN oe='1' ELSE 'Z';

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  io_buf_opdrn IS
	PORT
	( 
		datain	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC
	); 
END io_buf_opdrn;

ARCHITECTURE sim_arch OF io_buf_opdrn IS
BEGIN

	dataout <= '0' when datain='0' else 'Z';

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------





library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  tri_bus IS
	 GENERIC
	 (
		width_datain	: NATURAL:=2; 	
		width_dataout	: NATURAL:=1 	
	 );
	 PORT
	 ( 
		datain	:	IN STD_LOGIC_VECTOR(width_datain-1 downto 0);
		dataout	:	OUT STD_LOGIC_VECTOR(width_dataout-1 downto 0)
	 ); 
END tri_bus;


ARCHITECTURE sim_arch OF tri_bus IS

BEGIN
	MSG: process
    begin
        if (width_datain <= 0) then
            ASSERT FALSE
            REPORT "Value of width_datain parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_dataout /= 1) then
            ASSERT FALSE
            REPORT "Value of width_dataout parameter must be equal to 1!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

g:for i in 0 to width_datain-1 generate
	dataout(0) <= '1' when (datain(i)='1' or datain(i)='H') ELSE '0' when (datain(i)='0' or datain(i)='L') ELSE 'Z';
end generate g;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY  oper_mult IS
	GENERIC 
	(
		sgate_representation : NATURAL :=1;
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=6;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_mult;

ARCHITECTURE sim_arch OF oper_mult IS

SIGNAL a_ext : STD_LOGIC_VECTOR(width_a downto 0);
SIGNAL b_ext : STD_LOGIC_VECTOR(width_b downto 0);
SIGNAL o_ext : STD_LOGIC_VECTOR(width_a+width_b+1 downto 0);

BEGIN

	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_o <= 0) then
            ASSERT FALSE
            REPORT "Value of width_o parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	g1: IF (sgate_representation>0) GENERATE
		a_ext(width_a) 		<= a_ext(width_a-1);
		b_ext(width_b) 		<= b_ext(width_b-1);
	END GENERATE g1;
	
	g2: IF (sgate_representation=0) GENERATE
		a_ext(width_a) 		<= '0';
		b_ext(width_b) 		<= '0';
	END GENERATE g2;
	
	a_ext(width_a-1 DOWNTO 0) <= a(width_a-1 DOWNTO 0);
	b_ext(width_b-1 DOWNTO 0) <= b(width_b-1 DOWNTO 0);
	
	o_ext 					<= a_ext*b_ext;
	o(width_o-1 DOWNTO 0) 	<= o_ext(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library LPM;
use LPM.LPM_COMPONENTS.all;


ENTITY  oper_div IS
	GENERIC 
	(
		sgate_representation : NATURAL :=1;
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=8;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_div;

ARCHITECTURE sim_arch OF oper_div IS

FUNCTION STR_REPRESENTATION( i : NATURAL ) RETURN STRING IS
BEGIN
	IF (i>0) THEN 
		RETURN "SIGNED";
	ELSE
		RETURN "UNSIGNED";
	END IF;
END;

SIGNAL quotient : STD_LOGIC_VECTOR(width_a-1 DOWNTO 0); 

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_o <= 0) then
            ASSERT FALSE
            REPORT "Value of width_o parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	u0 : lpm_divide	GENERIC MAP (
								lpm_widthn => width_a,
								lpm_widthd => width_b,
								lpm_type => "LPM_DIVIDE",
								lpm_nrepresentation => STR_REPRESENTATION(sgate_representation),
								lpm_hint => "LPM_REMAINDERPOSITIVE=FALSE",
								lpm_drepresentation => STR_REPRESENTATION(sgate_representation)
								)
						PORT MAP (
								denom => b,
								numer => a,
								quotient => quotient,
								remain => open
								);
														
	o(width_o-1 DOWNTO 0) <= quotient(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_mod IS
	GENERIC 
	(
		sgate_representation : NATURAL;
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
END oper_mod;

ARCHITECTURE sim_arch OF oper_mod IS

FUNCTION STR_REPRESENTATION( i : NATURAL ) RETURN STRING IS
BEGIN
	IF (i>0) THEN 
		RETURN "SIGNED";
	ELSE
		RETURN "UNSIGNED";
	END IF;
END;

SIGNAL remain : STD_LOGIC_VECTOR(width_b-1 DOWNTO 0); 

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_o <= 0) then
            ASSERT FALSE
            REPORT "Value of width_o parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	u0 : lpm_divide	GENERIC MAP (
								lpm_widthn => width_a,
								lpm_widthd => width_b,
								lpm_type => "LPM_DIVIDE",
								lpm_nrepresentation => STR_REPRESENTATION(sgate_representation),
								lpm_hint => "LPM_REMAINDERPOSITIVE=FALSE",
								lpm_drepresentation => STR_REPRESENTATION(sgate_representation)
								)
						PORT MAP (
								denom => b,
								numer => a,
								quotient => open ,
								remain => remain
								);													
	o(width_o-1 DOWNTO 0) <= remain(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY  oper_left_shift IS
	GENERIC 
	(
        sgate_representation : NATURAL := 0;
		width_a	:	NATURAL :=8;
		width_amount	:	NATURAL :=2;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_left_shift;

ARCHITECTURE sim_arch OF oper_left_shift IS

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
SIGNAL resx		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0); --need to add cin xor functionality
SIGNAL wire_gnd		: STD_LOGIC;

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_amount <= 0) then
            ASSERT FALSE
            REPORT "Value of width_amount parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_a < width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than or equal to width_o!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	PROCESS (a, amount, cin)
    variable tmpdata : std_logic_vector(width_a-1 downto 0);
    variable tmpdist : integer;
	BEGIN
            tmpdata := conv_std_logic_vector(unsigned(a), width_a);
            tmpdist := conv_integer(unsigned(amount));
            for i in width_a-1 downto 0 loop
                if (i >= tmpdist) then
                    res(i) <= tmpdata(i-tmpdist);
                else
                    res(i) <= cin;
                end if;
            end loop;	
	END PROCESS;
	
	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY  oper_right_shift IS
	GENERIC 
	(
		sgate_representation : NATURAL :=1;
		width_a	:	NATURAL :=8;
		width_amount	:	NATURAL :=3;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_right_shift;

ARCHITECTURE sim_arch OF oper_right_shift IS

FUNCTION STR_REPRESENTATION( i : NATURAL ) RETURN STRING IS
BEGIN
	IF (i>0) THEN 
		RETURN "ARITHMETIC";
	ELSE
		RETURN "LOGICAL";
	END IF;
END;

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
SIGNAL wire_vcc		: STD_LOGIC;

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_amount <= 0) then
            ASSERT FALSE
            REPORT "Value of width_amount parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_a < width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than or equal to width_o!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	PROCESS (a, amount, cin)
    variable tmpdata : std_logic_vector(width_a-1 downto 0);
    variable tmpdist : integer;
	BEGIN
            tmpdata := conv_std_logic_vector(unsigned(a), width_a);
            tmpdist := conv_integer(unsigned(amount));
            for i in width_a-1 downto 0 loop
                if ((i+tmpdist) < width_a) then
                    res(i) <= tmpdata(i+tmpdist);
                else
                    res(i) <= cin;
                end if;
            end loop;	
	END PROCESS;
	
	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_rotate_left IS
	GENERIC 
	(
		sgate_representation :  NATURAL := 0;
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
END oper_rotate_left;

ARCHITECTURE sim_arch OF oper_rotate_left IS

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
SIGNAL wire_gnd		: STD_LOGIC;

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_amount <= 0) then
            ASSERT FALSE
            REPORT "Value of width_amount parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_a /= width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to width_o!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	wire_gnd <= '0';
	U0 : lpm_clshift
		GENERIC MAP (
			lpm_type => "LPM_CLSHIFT",
			lpm_shifttype => "ROTATE",
			lpm_width => width_a,
			lpm_widthdist => width_amount
		)
		PORT MAP (
			distance => amount,
			direction => wire_gnd,
			data => a,
			result => res
		);
	
	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


LIBRARY LPM;
USE LPM.LPM_COMPONENTS.all;

ENTITY  oper_rotate_right IS
	GENERIC 
	(
		sgate_representation :  NATURAL := 0;
		width_a	:	NATURAL :=8;
		width_amount	:	NATURAL :=4;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		amount	:	IN STD_LOGIC_VECTOR(width_amount-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_rotate_right;

ARCHITECTURE sim_arch OF oper_rotate_right IS

SIGNAL res		: STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
SIGNAL wire_vcc		: STD_LOGIC;

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_amount <= 0) then
            ASSERT FALSE
            REPORT "Value of width_amount parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (width_a /= width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to width_o!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

	wire_vcc <= '1';
	U0 : lpm_clshift
		GENERIC MAP (
			lpm_type => "LPM_CLSHIFT",
			lpm_shifttype => "ROTATE",
			lpm_width => width_a,
			lpm_widthdist => width_amount
		)
		PORT MAP (
			distance => amount,
			direction => wire_vcc,
			data => a,
			result => res
		);

	o(width_o-1 DOWNTO 0) <= res(width_o-1 DOWNTO 0);

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


ENTITY  oper_less_than IS
	GENERIC 
	(
		sgate_representation : NATURAL :=0;
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=5
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		cin	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC
	); 
END oper_less_than;

ARCHITECTURE sim_arch OF oper_less_than IS

BEGIN
MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (sgate_representation /= 1 AND sgate_representation /= 0) then
            ASSERT FALSE
            REPORT "Value of sgate_representation parameter must be equal to 1 or 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

g1:IF sgate_representation>0 GENERATE
	PROCESS(a,b,cin)
		VARIABLE va		: SIGNED(width_a-1 DOWNTO 0); 
		VARIABLE vb		: SIGNED(width_b-1 DOWNTO 0); 
		BEGIN
			va := SIGNED(a);
			vb := SIGNED(b);
			IF (va<vb) THEN
				o <= '1';
			ELSIF (va=vb) AND (cin='1') THEN
				o <= '1';
			ELSE 	
				o <= '0';
			END IF;	 	
	END PROCESS;
END GENERATE g1;

g2:IF sgate_representation=0 GENERATE
	PROCESS(a,b,cin)
		VARIABLE va		: UNSIGNED(width_a-1 DOWNTO 0); 
		VARIABLE vb		: UNSIGNED(width_b-1 DOWNTO 0); 
		BEGIN
			va := UNSIGNED(a);
			vb := UNSIGNED(b);
			IF (va<vb) THEN
				o <= '1';
			ELSIF (va=vb) AND (cin='1') THEN
				o <= '1';
			ELSE
				o <= '0';
			END IF;
	END PROCESS;
END GENERATE g2;

END sim_arch;
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library sgate;
use sgate.sgate_pack.all;

ENTITY  oper_mux IS
	GENERIC 
	(
		width_sel	:	NATURAL :=3;
		width_data	:	NATURAL :=8
	);
	PORT
	( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	); 
END oper_mux;


ARCHITECTURE sim_arch OF oper_mux IS


BEGIN
MSG: process
    begin
        if (width_data <= 0) then
            ASSERT FALSE
            REPORT "Value of width_data parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_sel <= 0) then
            ASSERT FALSE
            REPORT "Value of width_sel parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
      
        wait;
    end process MSG;

o <= data(sgate_conv_integer(sel));

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  oper_selector IS
	GENERIC 
	(
		width_sel	:	NATURAL :=8;
		width_data	:	NATURAL :=8
	);
	PORT
	( 
		sel	:	IN STD_LOGIC_VECTOR(width_sel-1 DOWNTO 0);
		data	:	IN STD_LOGIC_VECTOR(width_data-1 DOWNTO 0);
		o	:	OUT STD_LOGIC
	); 
END oper_selector;

ARCHITECTURE sim_arch OF oper_selector IS
BEGIN
	MSG: process
    begin
        if (width_data <= 0) then
            ASSERT FALSE
            REPORT "Value of width_data parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_sel /= width_data) then
            ASSERT FALSE
            REPORT "Value of width_sel parameter must be equal to width_data!"
            SEVERITY ERROR;
        end if;
      
        wait;
    end process MSG;

	PROCESS (data, sel)
		variable temp_result : STD_LOGIC := '0';
	BEGIN
		FOR k IN 0 TO width_data-1 LOOP
			IF (sel(k) = '1') THEN
				temp_result := data(k);
			END IF;
		END LOOP;
		o <= temp_result;
	END PROCESS;
	

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


ENTITY  oper_prio_selector IS
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
END oper_prio_selector;

ARCHITECTURE sim_arch OF oper_prio_selector IS
BEGIN

	g1:FOR k IN 0 TO width_sel-1 GENERATE
		o <= data(k) WHEN (sel(k)='1') ELSE 'Z';
	END GENERATE;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


ENTITY oper_decoder IS
	GENERIC 
	(
		width_i	:	NATURAL :=1;
		width_o	:	NATURAL :=2
	);
	PORT
	( 
		i	:	IN STD_LOGIC_VECTOR(width_i-1 DOWNTO 0);
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_decoder;

ARCHITECTURE sim_arch OF oper_decoder IS

FUNCTION int2ustd(value : integer; width : integer) RETURN std_logic_vector IS 
-- convert integer to unsigned std_logicvector 
BEGIN
	RETURN conv_std_logic_vector(CONV_UNSIGNED(value, width ), width);
END int2ustd;

BEGIN
MSG: process
    begin
        if (width_i <= 0) then
            ASSERT FALSE
            REPORT "Value of width_i parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_o <= 0) then
            ASSERT FALSE
            REPORT "Value of width_o parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
      
        wait;
    end process MSG;
	G1:FOR k IN 0 TO width_o-1 GENERATE
		o(k) <= '1' WHEN (i=int2ustd(k,width_i)) ELSE '0';
	END GENERATE;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


ENTITY  oper_bus_mux IS
	GENERIC 
	(
		width_a	:	NATURAL :=8;
		width_b	:	NATURAL :=8;
		width_o	:	NATURAL :=8
	);
	PORT
	( 
		a	:	IN STD_LOGIC_VECTOR(width_a-1 DOWNTO 0);
		b	:	IN STD_LOGIC_VECTOR(width_b-1 DOWNTO 0);
		sel	:	IN STD_LOGIC;
		o	:	OUT STD_LOGIC_VECTOR(width_o-1 DOWNTO 0)
	); 
END oper_bus_mux;


ARCHITECTURE sim_arch OF oper_bus_mux IS

BEGIN
	MSG: process
    begin
        if (width_a <= 0) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
       
	    if (width_b <= 0) then
            ASSERT FALSE
            REPORT "Value of width_b parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
      
        if (width_a /= width_b) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to width_b!"
            SEVERITY ERROR;
        end if;

        if (width_a /= width_o) then
            ASSERT FALSE
            REPORT "Value of width_a parameter must be equal to width_o!"
            SEVERITY ERROR;
        end if;
        
        wait;
    end process MSG;

	o <= a WHEN sel='0' ELSE b;

END sim_arch;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
ENTITY oper_latch IS
	PORT
	(
		datain	:	IN STD_LOGIC;
		aclr	:	IN STD_LOGIC;
		preset	:	IN STD_LOGIC;
		dataout	:	OUT STD_LOGIC;
		latch_enable	:	IN STD_LOGIC
	);
END oper_latch;

ARCHITECTURE sim_arch OF oper_latch IS

BEGIN
	PROCESS(datain, latch_enable, aclr, preset)
	BEGIN
		if (aclr = '1') then
			dataout <= '0';
		elsif (preset = '1') then
			dataout <= '1';
		elsif (latch_enable = '1') then
			dataout <= datain;
		end if;
	END PROCESS;

END sim_arch;

