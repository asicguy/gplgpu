
-- package for Boolean vector
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package hssi_pack is

   TYPE boolean_vec IS ARRAY (0 to 3) of BOOLEAN;

-- default generic values
   CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
   CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
   CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
-- default control options
--   CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
-- change default delay type to Transport : for spr 68748
   CONSTANT DefGlitchMode       : VitalGlitchKindType   := VitalTransport;
   CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
   CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
   CONSTANT DefMsgOnChecks      : BOOLEAN       := TRUE;
   CONSTANT DefXOnChecks        : BOOLEAN       := TRUE;
-- output strength mapping
                                                --  UX01ZWHL-
   CONSTANT PullUp      : VitalOutputMapType    := "UX01HX01X";
   CONSTANT NoPullUpZ   : VitalOutputMapType    := "UX01ZX01X";
   CONSTANT PullDown    : VitalOutputMapType    := "UX01LX01X";
-- primitive result strength mapping
   CONSTANT wiredOR     : VitalResultMapType    := ( 'U', 'X', 'L', '1' );
   CONSTANT wiredAND    : VitalResultMapType    := ( 'U', 'X', '0', 'H' );
   CONSTANT L : VitalTableSymbolType := '0';
   CONSTANT H : VitalTableSymbolType := '1';
   CONSTANT x : VitalTableSymbolType := '-';
   CONSTANT S : VitalTableSymbolType := 'S';
   CONSTANT R : VitalTableSymbolType := '/';
   CONSTANT U : VitalTableSymbolType := 'X';
   CONSTANT V : VitalTableSymbolType := 'B'; -- valid clock signal (non-rising)

	-- function to convert align_pattern to binary
	function pattern_conversion (align_pattern : string) return std_logic_vector;
 
end hssi_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body hssi_pack is
	function pattern_conversion 
		( 	
			align_pattern			: string
		)
		return std_logic_vector is
		variable i : integer;
		variable j : integer := 15;
		variable bin_pat : std_logic_vector(15 downto 0) := (OTHERS => '0');
	begin

		for i in 1 to align_pattern'length loop
			case align_pattern(i) is
				when '0' => bin_pat(j) := '0';
				when '1' => bin_pat(j) := '1';
				when others => bin_pat(j) := '0';
			end case;
			j := j - 1;
		end loop;

		return (bin_pat);

	end pattern_conversion;

end hssi_pack;

--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

--synthesis_resources = lut 81 mux21 43 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_8b10b_decoder IS 
	 PORT 
	 ( 
		 clk	:	IN  STD_LOGIC;
		 datain	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 datainvalid	:	IN  STD_LOGIC;
		 dataout	:	OUT  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 decdatavalid	:	OUT  STD_LOGIC;
		 disperr	:	OUT  STD_LOGIC;
		 disperrin	:	IN  STD_LOGIC;
		 errdetect	:	OUT  STD_LOGIC;
		 errdetectin	:	IN  STD_LOGIC;
		 kout	:	OUT  STD_LOGIC;
		 patterndetect	:	OUT  STD_LOGIC;
		 patterndetectin	:	IN  STD_LOGIC;
		 rderr	:	OUT  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 syncstatus	:	OUT  STD_LOGIC;
		 syncstatusin	:	IN  STD_LOGIC;
		 tenBdata	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 valid	:	OUT  STD_LOGIC;
		 xgmctrldet	:	OUT  STD_LOGIC;
		 xgmdataout	:	OUT  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 xgmdatavalid	:	OUT  STD_LOGIC;
		 xgmrunningdisp	:	OUT  STD_LOGIC
	 ); 
 END stratixgx_8b10b_decoder;

 ARCHITECTURE RTL OF stratixgx_8b10b_decoder IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 n0iOl43	:	STD_LOGIC := '0';
	 SIGNAL	 n0iOl44	:	STD_LOGIC := '0';
	 SIGNAL	 n0l0l39	:	STD_LOGIC := '0';
	 SIGNAL	 n0l0l40	:	STD_LOGIC := '0';
	 SIGNAL	 n0l1l41	:	STD_LOGIC := '0';
	 SIGNAL	 n0l1l42	:	STD_LOGIC := '0';
	 SIGNAL	 n0lii37	:	STD_LOGIC := '0';
	 SIGNAL	 n0lii38	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0lii38_w_lg_q151w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n0liO35	:	STD_LOGIC := '0';
	 SIGNAL	 n0liO36	:	STD_LOGIC := '0';
	 SIGNAL	 n0lll33	:	STD_LOGIC := '0';
	 SIGNAL	 n0lll34	:	STD_LOGIC := '0';
	 SIGNAL	 n0lOi31	:	STD_LOGIC := '0';
	 SIGNAL	 n0lOi32	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0lOi32_w_lg_q136w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n0lOO29	:	STD_LOGIC := '0';
	 SIGNAL	 n0lOO30	:	STD_LOGIC := '0';
	 SIGNAL	 n0O0l25	:	STD_LOGIC := '0';
	 SIGNAL	 n0O0l26	:	STD_LOGIC := '0';
	 SIGNAL	 n0O1l27	:	STD_LOGIC := '0';
	 SIGNAL	 n0O1l28	:	STD_LOGIC := '0';
	 SIGNAL	 n0Oil23	:	STD_LOGIC := '0';
	 SIGNAL	 n0Oil24	:	STD_LOGIC := '0';
	 SIGNAL	 n0Oli21	:	STD_LOGIC := '0';
	 SIGNAL	 n0Oli22	:	STD_LOGIC := '0';
	 SIGNAL	 n0OOi19	:	STD_LOGIC := '0';
	 SIGNAL	 n0OOi20	:	STD_LOGIC := '0';
	 SIGNAL	 n0OOO17	:	STD_LOGIC := '0';
	 SIGNAL	 n0OOO18	:	STD_LOGIC := '0';
	 SIGNAL	 ni00i5	:	STD_LOGIC := '0';
	 SIGNAL	 ni00i6	:	STD_LOGIC := '0';
	 SIGNAL	 ni0il3	:	STD_LOGIC := '0';
	 SIGNAL	 ni0il4	:	STD_LOGIC := '0';
	 SIGNAL	 ni0ll1	:	STD_LOGIC := '0';
	 SIGNAL	 ni0ll2	:	STD_LOGIC := '0';
	 SIGNAL	 ni10l13	:	STD_LOGIC := '0';
	 SIGNAL	 ni10l14	:	STD_LOGIC := '0';
	 SIGNAL	 ni11O15	:	STD_LOGIC := '0';
	 SIGNAL	 ni11O16	:	STD_LOGIC := '0';
	 SIGNAL	 ni1ii11	:	STD_LOGIC := '0';
	 SIGNAL	 ni1ii12	:	STD_LOGIC := '0';
	 SIGNAL	 ni1iO10	:	STD_LOGIC := '0';
	 SIGNAL	 ni1iO9	:	STD_LOGIC := '0';
	 SIGNAL	 ni1ll7	:	STD_LOGIC := '0';
	 SIGNAL	 ni1ll8	:	STD_LOGIC := '0';
	 SIGNAL	n0O	:	STD_LOGIC := '0';
	 SIGNAL	nii	:	STD_LOGIC := '0';
	 SIGNAL	niO	:	STD_LOGIC := '0';
	 SIGNAL	nlll	:	STD_LOGIC := '0';
	 SIGNAL	nllO	:	STD_LOGIC := '0';
	 SIGNAL	nlOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nil_CLRN	:	STD_LOGIC;
	 SIGNAL	n0i	:	STD_LOGIC := '0';
	 SIGNAL	n0l	:	STD_LOGIC := '0';
	 SIGNAL	n1i	:	STD_LOGIC := '0';
	 SIGNAL	n1l	:	STD_LOGIC := '0';
	 SIGNAL	n1O	:	STD_LOGIC := '0';
	 SIGNAL	ni	:	STD_LOGIC := '0';
	 SIGNAL	niii	:	STD_LOGIC := '0';
	 SIGNAL	niil	:	STD_LOGIC := '0';
	 SIGNAL	niiO	:	STD_LOGIC := '0';
	 SIGNAL	nili	:	STD_LOGIC := '0';
	 SIGNAL	nill	:	STD_LOGIC := '0';
	 SIGNAL	nilO	:	STD_LOGIC := '0';
	 SIGNAL	niOi	:	STD_LOGIC := '0';
	 SIGNAL	niOl	:	STD_LOGIC := '0';
	 SIGNAL	niOO	:	STD_LOGIC := '0';
	 SIGNAL	nl0i	:	STD_LOGIC := '0';
	 SIGNAL	nl0l	:	STD_LOGIC := '0';
	 SIGNAL	nl0O	:	STD_LOGIC := '0';
	 SIGNAL	nl1i	:	STD_LOGIC := '0';
	 SIGNAL	nl1l	:	STD_LOGIC := '0';
	 SIGNAL	nl1O	:	STD_LOGIC := '0';
	 SIGNAL	nli	:	STD_LOGIC := '0';
	 SIGNAL	nlii	:	STD_LOGIC := '0';
	 SIGNAL	nlil	:	STD_LOGIC := '0';
	 SIGNAL	nliO	:	STD_LOGIC := '0';
	 SIGNAL	nll	:	STD_LOGIC := '0';
	 SIGNAL	nlli	:	STD_LOGIC := '0';
	 SIGNAL	nlO	:	STD_LOGIC := '0';
	 SIGNAL	nO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli0i_w_lg_w_lg_w_lg_dataout89w134w137w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_w_lg_dataout82w152w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_w_lg_dataout89w186w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_w_lg_dataout89w144w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_w_lg_dataout89w134w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_dataout82w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_dataout89w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_dataout165w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli0l_w_lg_dataout80w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout79w81w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_w_lg_dataout79w177w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout176w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout79w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0O_w_lg_dataout164w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli1l_w_lg_dataout109w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nli1O_w_lg_dataout138w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_dataout153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_dataout187w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_dataout145w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_dataout88w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllli_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nllli_w_lg_dataout63w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nllll_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nllll_w_lg_dataout68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlllO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlllO_w_lg_w_lg_dataout61w62w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlllO_w_lg_dataout69w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlllO_w_lg_dataout61w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ni1Oi55w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n0ilO174w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ni01O54w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset2w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ni01l56w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n0ill :	STD_LOGIC;
	 SIGNAL  n0ilO :	STD_LOGIC;
	 SIGNAL  n0iOi :	STD_LOGIC;
	 SIGNAL  n0l0i :	STD_LOGIC;
	 SIGNAL  n0l1i :	STD_LOGIC;
	 SIGNAL  n0O0i :	STD_LOGIC;
	 SIGNAL  n0Oii :	STD_LOGIC;
	 SIGNAL  n0OlO :	STD_LOGIC;
	 SIGNAL  ni01i :	STD_LOGIC;
	 SIGNAL  ni01l :	STD_LOGIC;
	 SIGNAL  ni01O :	STD_LOGIC;
	 SIGNAL  ni0ii :	STD_LOGIC;
	 SIGNAL  ni0iO :	STD_LOGIC;
	 SIGNAL  ni11l :	STD_LOGIC;
	 SIGNAL  ni1Oi :	STD_LOGIC;
	 SIGNAL  ni1Ol :	STD_LOGIC;
	 SIGNAL  ni1OO :	STD_LOGIC;
 BEGIN

	wire_w_lg_ni1Oi55w(0) <= ni1Oi AND ni1OO;
	wire_w_lg_n0ilO174w(0) <= NOT n0ilO;
	wire_w_lg_ni01O54w(0) <= NOT ni01O;
	wire_w_lg_reset2w(0) <= NOT reset;
	wire_w_lg_ni01l56w(0) <= ni01l OR wire_w_lg_ni1Oi55w(0);
	dataout <= ( nO & ni & nlO & nll & nli & niO & nii & n0O);
	decdatavalid <= nl0i;
	disperr <= nl0l;
	errdetect <= nliO;
	kout <= nllO;
	n0ill <= wire_nli0O_w_lg_w_lg_dataout79w81w(0);
	n0ilO <= (wire_nli0l_dataout AND wire_nli0i_dataout);
	n0iOi <= ((wire_nli0l_w_lg_dataout80w(0) AND wire_nli0i_w_lg_dataout89w(0)) AND (n0iOl44 XOR n0iOl43));
	n0l0i <= ((((wire_nli1O_w_lg_dataout88w(0) AND (wire_nli0i_w_lg_dataout89w(0) AND wire_nli0O_w_lg_dataout176w(0))) OR (wire_nli1O_w_lg_dataout88w(0) AND (wire_nli0i_w_lg_dataout89w(0) AND wire_nli0O_w_lg_w_lg_dataout79w177w(0)))) OR (wire_nli1O_w_lg_dataout88w(0) AND (wire_nli0i_dataout AND n0ill))) OR wire_nli1O_w_lg_dataout187w(0));
	n0l1i <= ((((wire_nli1l_w_lg_dataout109w(0) AND ((((((((((wire_nli1O_w_lg_dataout88w(0) AND ((wire_nli0i_w_lg_dataout89w(0) AND (wire_nli0O_dataout AND wire_nli0l_dataout)) AND (n0Oli22 XOR n0Oli21))) AND (n0Oil24 XOR n0Oil23)) OR (wire_nli1O_w_lg_dataout88w(0) AND (wire_nli0i_dataout AND n0Oii))) OR (NOT (n0O0l26 XOR n0O0l25))) OR ((wire_nli1O_w_lg_dataout88w(0) AND (wire_nli0i_dataout AND n0O0i)) AND (n0O1l28 XOR n0O1l27))) OR (NOT (n0lOO30 XOR n0lOO29))) OR wire_nli1O_w_lg_dataout138w(0)) OR (NOT (n0lll34 XOR n0lll33))) OR (wire_nli1O_w_lg_dataout145w(0) AND (n0liO36 XOR n0liO35))) OR wire_nli1O_w_lg_dataout153w(0))) AND (n0l0l40 XOR n0l0l39)) OR ((wire_nli1l_dataout AND n0l0i) AND (n0l1l42 XOR n0l1l41))) AND wire_nli0i_w_lg_dataout165w(0));
	n0O0i <= wire_nli0O_w_lg_w_lg_dataout79w177w(0);
	n0Oii <= wire_nli0O_w_lg_dataout176w(0);
	n0OlO <= (wire_nli1l_dataout AND (((wire_nli0O_dataout XOR wire_nli0l_dataout) XOR (NOT (n0OOO18 XOR n0OOO17))) AND ((wire_nli0i_dataout XOR wire_nli1O_dataout) XOR (NOT (n0OOi20 XOR n0OOi19)))));
	ni01i <= ((NOT datain(5)) AND ni01l);
	ni01l <= (wire_nli1l_dataout AND (wire_nli1O_dataout AND (wire_nli0i_w_lg_dataout82w(0) AND (ni10l14 XOR ni10l13))));
	ni01O <= ((datain(6) XOR datain(7)) XOR (NOT (ni00i6 XOR ni00i5)));
	ni0ii <= (wire_w_lg_ni01l56w(0) OR (NOT (ni1ll8 XOR ni1ll7)));
	ni0iO <= '1';
	ni11l <= (wire_nli1l_dataout AND (wire_nli1O_w_lg_dataout88w(0) AND ((wire_nli0i_w_lg_dataout89w(0) AND (wire_nli0O_dataout AND wire_nli0l_dataout)) AND (ni11O16 XOR ni11O15))));
	ni1Oi <= (wire_nli1l_w_lg_dataout109w(0) AND n0l0i);
	ni1Ol <= ((wire_nlllO_w_lg_w_lg_dataout61w62w(0) AND wire_nllli_w_lg_dataout63w(0)) AND (ni1iO10 XOR ni1iO9));
	ni1OO <= ((wire_nlllO_w_lg_dataout69w(0) AND wire_nllli_w_lg_dataout63w(0)) AND (ni1ii12 XOR ni1ii11));
	patterndetect <= nl0O;
	rderr <= nlil;
	syncstatus <= nlii;
	tenBdata <= ( nl1i & niOO & niOl & niOi & nilO & nill & nili & niiO & niil & niii);
	valid <= nlli;
	xgmctrldet <= nlll;
	xgmdataout <= ( n0l & n0i & n1O & n1l & n1i & nlOO & nlOl & nlOi);
	xgmdatavalid <= nl1O;
	xgmrunningdisp <= nl1l;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0iOl43 <= n0iOl44;
		END IF;
		if (now = 0 ns) then
			n0iOl43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0iOl44 <= n0iOl43;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0l0l39 <= n0l0l40;
		END IF;
		if (now = 0 ns) then
			n0l0l39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0l0l40 <= n0l0l39;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0l1l41 <= n0l1l42;
		END IF;
		if (now = 0 ns) then
			n0l1l41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0l1l42 <= n0l1l41;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lii37 <= n0lii38;
		END IF;
		if (now = 0 ns) then
			n0lii37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lii38 <= n0lii37;
		END IF;
	END PROCESS;
	wire_n0lii38_w_lg_q151w(0) <= n0lii38 XOR n0lii37;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0liO35 <= n0liO36;
		END IF;
		if (now = 0 ns) then
			n0liO35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0liO36 <= n0liO35;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lll33 <= n0lll34;
		END IF;
		if (now = 0 ns) then
			n0lll33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lll34 <= n0lll33;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lOi31 <= n0lOi32;
		END IF;
		if (now = 0 ns) then
			n0lOi31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lOi32 <= n0lOi31;
		END IF;
	END PROCESS;
	wire_n0lOi32_w_lg_q136w(0) <= n0lOi32 XOR n0lOi31;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lOO29 <= n0lOO30;
		END IF;
		if (now = 0 ns) then
			n0lOO29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0lOO30 <= n0lOO29;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0O0l25 <= n0O0l26;
		END IF;
		if (now = 0 ns) then
			n0O0l25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0O0l26 <= n0O0l25;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0O1l27 <= n0O1l28;
		END IF;
		if (now = 0 ns) then
			n0O1l27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0O1l28 <= n0O1l27;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0Oil23 <= n0Oil24;
		END IF;
		if (now = 0 ns) then
			n0Oil23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0Oil24 <= n0Oil23;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0Oli21 <= n0Oli22;
		END IF;
		if (now = 0 ns) then
			n0Oli21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0Oli22 <= n0Oli21;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0OOi19 <= n0OOi20;
		END IF;
		if (now = 0 ns) then
			n0OOi19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0OOi20 <= n0OOi19;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0OOO17 <= n0OOO18;
		END IF;
		if (now = 0 ns) then
			n0OOO17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN n0OOO18 <= n0OOO17;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni00i5 <= ni00i6;
		END IF;
		if (now = 0 ns) then
			ni00i5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni00i6 <= ni00i5;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni0il3 <= ni0il4;
		END IF;
		if (now = 0 ns) then
			ni0il3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni0il4 <= ni0il3;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni0ll1 <= ni0ll2;
		END IF;
		if (now = 0 ns) then
			ni0ll1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni0ll2 <= ni0ll1;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni10l13 <= ni10l14;
		END IF;
		if (now = 0 ns) then
			ni10l13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni10l14 <= ni10l13;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni11O15 <= ni11O16;
		END IF;
		if (now = 0 ns) then
			ni11O15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni11O16 <= ni11O15;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni1ii11 <= ni1ii12;
		END IF;
		if (now = 0 ns) then
			ni1ii11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni1ii12 <= ni1ii11;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni1iO10 <= ni1iO9;
		END IF;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni1iO9 <= ni1iO10;
		END IF;
		if (now = 0 ns) then
			ni1iO9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni1ll7 <= ni1ll8;
		END IF;
		if (now = 0 ns) then
			ni1ll7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN ni1ll8 <= ni1ll7;
		END IF;
	END PROCESS;
	PROCESS (clk, reset, wire_nil_CLRN)
	BEGIN
		IF (reset = '1') THEN
				n0O <= '1';
				nii <= '1';
				niO <= '1';
				nlll <= '1';
				nllO <= '1';
				nlOi <= '1';
				nlOl <= '1';
				nlOO <= '1';
		ELSIF (wire_nil_CLRN = '0') THEN
				n0O <= '0';
				nii <= '0';
				niO <= '0';
				nlll <= '0';
				nllO <= '0';
				nlOi <= '0';
				nlOl <= '0';
				nlOO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN
				n0O <= wire_niO0O_dataout;
				nii <= wire_niO0l_dataout;
				niO <= wire_niO0i_dataout;
				nlll <= ni0ii;
				nllO <= ni0ii;
				nlOi <= wire_niO0O_dataout;
				nlOl <= wire_niO0l_dataout;
				nlOO <= wire_niO0i_dataout;
		END IF;
		if (now = 0 ns) then
			n0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nil_CLRN <= (ni0il4 XOR ni0il3);
	PROCESS (clk, wire_nl_CLRN)
	BEGIN
		IF (wire_nl_CLRN = '0') THEN
				n0i <= '0';
				n0l <= '0';
				n1i <= '0';
				n1l <= '0';
				n1O <= '0';
				ni <= '0';
				niii <= '0';
				niil <= '0';
				niiO <= '0';
				nili <= '0';
				nill <= '0';
				nilO <= '0';
				niOi <= '0';
				niOl <= '0';
				niOO <= '0';
				nl0i <= '0';
				nl0l <= '0';
				nl0O <= '0';
				nl1i <= '0';
				nl1l <= '0';
				nl1O <= '0';
				nli <= '0';
				nlii <= '0';
				nlil <= '0';
				nliO <= '0';
				nll <= '0';
				nlli <= '0';
				nlO <= '0';
				nO <= '0';
		ELSIF (clk = '1' AND clk'event) THEN
				n0i <= wire_nlilO_dataout;
				n0l <= wire_nlill_dataout;
				n1i <= wire_niO1O_dataout;
				n1l <= wire_niO1l_dataout;
				n1O <= wire_nliOi_dataout;
				ni <= wire_nlilO_dataout;
				niii <= datain(0);
				niil <= datain(1);
				niiO <= datain(2);
				nili <= datain(3);
				nill <= datain(4);
				nilO <= datain(5);
				niOi <= datain(6);
				niOl <= datain(7);
				niOO <= datain(8);
				nl0i <= datainvalid;
				nl0l <= disperrin;
				nl0O <= patterndetectin;
				nl1i <= datain(9);
				nl1l <= disperrin;
				nl1O <= datainvalid;
				nli <= wire_niO1O_dataout;
				nlii <= syncstatusin;
				nlil <= disperrin;
				nliO <= errdetectin;
				nll <= wire_niO1l_dataout;
				nlli <= datainvalid;
				nlO <= wire_nliOi_dataout;
				nO <= wire_nlill_dataout;
		END IF;
	END PROCESS;
	wire_nl_CLRN <= ((ni0ll2 XOR ni0ll1) AND wire_w_lg_reset2w(0));
	wire_niO0i_dataout <= wire_niOiO_dataout OR ni01l;
	wire_niO0l_dataout <= wire_niOli_dataout AND NOT(ni01l);
	wire_niO0O_dataout <= wire_niOll_dataout AND NOT(ni01l);
	wire_niO1l_dataout <= wire_niOii_dataout OR ni01l;
	wire_niO1O_dataout <= wire_niOil_dataout OR ni01l;
	wire_niOii_dataout <= wire_niOlO_dataout OR ni11l;
	wire_niOil_dataout <= wire_niOOi_dataout OR ni11l;
	wire_niOiO_dataout <= wire_niOOl_dataout AND NOT(ni11l);
	wire_niOli_dataout <= wire_niOOO_dataout AND NOT(ni11l);
	wire_niOll_dataout <= wire_nl11i_dataout AND NOT(ni11l);
	wire_niOlO_dataout <= wire_nl1il_dataout WHEN n0OlO = '1'  ELSE wire_nl11l_dataout;
	wire_niOOi_dataout <= wire_nl1iO_dataout WHEN n0OlO = '1'  ELSE wire_nl11O_dataout;
	wire_niOOl_dataout <= wire_nl1iO_dataout WHEN n0OlO = '1'  ELSE wire_nl10i_dataout;
	wire_niOOO_dataout <= wire_nl1iO_dataout WHEN n0OlO = '1'  ELSE wire_nl10l_dataout;
	wire_nl10i_dataout <= datain(2) WHEN n0l1i = '1'  ELSE wire_nli0i_w_lg_dataout89w(0);
	wire_nl10l_dataout <= datain(1) WHEN n0l1i = '1'  ELSE wire_nli0l_w_lg_dataout80w(0);
	wire_nl10O_dataout <= datain(0) WHEN n0l1i = '1'  ELSE wire_nli0O_w_lg_dataout79w(0);
	wire_nl11i_dataout <= wire_nl1iO_dataout WHEN n0OlO = '1'  ELSE wire_nl10O_dataout;
	wire_nl11l_dataout <= datain(4) WHEN n0l1i = '1'  ELSE ni1Oi;
	wire_nl11O_dataout <= datain(3) WHEN n0l1i = '1'  ELSE wire_nli1O_w_lg_dataout88w(0);
	wire_nl1il_dataout <= wire_nl1li_dataout AND NOT(n0iOi);
	wire_nl1iO_dataout <= wire_w_lg_n0ilO174w(0) AND NOT(n0iOi);
	wire_nl1li_dataout <= (NOT (wire_nli0l_dataout AND wire_nli0i_w_lg_dataout89w(0))) OR n0ilO;
	wire_nli0i_dataout <= datain(2) WHEN datain(5) = '1'  ELSE (NOT datain(2));
	wire_nli0i_w_lg_w_lg_w_lg_dataout89w134w137w(0) <= wire_nli0i_w_lg_w_lg_dataout89w134w(0) AND wire_n0lOi32_w_lg_q136w(0);
	wire_nli0i_w_lg_w_lg_dataout82w152w(0) <= wire_nli0i_w_lg_dataout82w(0) AND wire_n0lii38_w_lg_q151w(0);
	wire_nli0i_w_lg_w_lg_dataout89w186w(0) <= wire_nli0i_w_lg_dataout89w(0) AND n0ill;
	wire_nli0i_w_lg_w_lg_dataout89w144w(0) <= wire_nli0i_w_lg_dataout89w(0) AND n0O0i;
	wire_nli0i_w_lg_w_lg_dataout89w134w(0) <= wire_nli0i_w_lg_dataout89w(0) AND n0Oii;
	wire_nli0i_w_lg_dataout82w(0) <= wire_nli0i_dataout AND wire_nli0O_w_lg_w_lg_dataout79w81w(0);
	wire_nli0i_w_lg_dataout89w(0) <= NOT wire_nli0i_dataout;
	wire_nli0i_w_lg_dataout165w(0) <= wire_nli0i_dataout OR wire_nli0O_w_lg_dataout164w(0);
	wire_nli0l_dataout <= datain(1) WHEN datain(5) = '1'  ELSE (NOT datain(1));
	wire_nli0l_w_lg_dataout80w(0) <= NOT wire_nli0l_dataout;
	wire_nli0O_dataout <= datain(0) WHEN datain(5) = '1'  ELSE (NOT datain(0));
	wire_nli0O_w_lg_w_lg_dataout79w81w(0) <= wire_nli0O_w_lg_dataout79w(0) AND wire_nli0l_w_lg_dataout80w(0);
	wire_nli0O_w_lg_w_lg_dataout79w177w(0) <= wire_nli0O_w_lg_dataout79w(0) AND wire_nli0l_dataout;
	wire_nli0O_w_lg_dataout176w(0) <= wire_nli0O_dataout AND wire_nli0l_w_lg_dataout80w(0);
	wire_nli0O_w_lg_dataout79w(0) <= NOT wire_nli0O_dataout;
	wire_nli0O_w_lg_dataout164w(0) <= wire_nli0O_dataout OR wire_nli0l_dataout;
	wire_nli1l_dataout <= datain(4) WHEN datain(5) = '1'  ELSE (NOT datain(4));
	wire_nli1l_w_lg_dataout109w(0) <= NOT wire_nli1l_dataout;
	wire_nli1O_dataout <= datain(3) WHEN datain(5) = '1'  ELSE (NOT datain(3));
	wire_nli1O_w_lg_dataout138w(0) <= wire_nli1O_dataout AND wire_nli0i_w_lg_w_lg_w_lg_dataout89w134w137w(0);
	wire_nli1O_w_lg_dataout153w(0) <= wire_nli1O_dataout AND wire_nli0i_w_lg_w_lg_dataout82w152w(0);
	wire_nli1O_w_lg_dataout187w(0) <= wire_nli1O_dataout AND wire_nli0i_w_lg_w_lg_dataout89w186w(0);
	wire_nli1O_w_lg_dataout145w(0) <= wire_nli1O_dataout AND wire_nli0i_w_lg_w_lg_dataout89w144w(0);
	wire_nli1O_w_lg_dataout88w(0) <= NOT wire_nli1O_dataout;
	wire_nlill_dataout <= wire_nliOl_dataout AND NOT(ni1Ol);
	wire_nlilO_dataout <= wire_nliOO_dataout AND NOT(ni1Ol);
	wire_nliOi_dataout <= wire_nll1i_dataout AND NOT(ni1Ol);
	wire_nliOl_dataout <= wire_nll1l_dataout OR ni1OO;
	wire_nliOO_dataout <= wire_nll1O_dataout OR ni1OO;
	wire_nll0i_dataout <= wire_nlllO_dataout WHEN wire_w_lg_ni01O54w(0) = '1'  ELSE wire_nllii_dataout;
	wire_nll0l_dataout <= (NOT datain(8)) WHEN ni01i = '1'  ELSE datain(8);
	wire_nll0O_dataout <= (NOT datain(7)) WHEN ni01i = '1'  ELSE datain(7);
	wire_nll1i_dataout <= wire_nll0i_dataout OR ni1OO;
	wire_nll1l_dataout <= wire_nllli_dataout WHEN wire_w_lg_ni01O54w(0) = '1'  ELSE wire_nll0l_dataout;
	wire_nll1O_dataout <= wire_nllll_dataout WHEN wire_w_lg_ni01O54w(0) = '1'  ELSE wire_nll0O_dataout;
	wire_nllii_dataout <= (NOT datain(6)) WHEN ni01i = '1'  ELSE datain(6);
	wire_nllli_dataout <= (NOT datain(8)) WHEN datain(9) = '1'  ELSE datain(8);
	wire_nllli_w_lg_dataout63w(0) <= NOT wire_nllli_dataout;
	wire_nllll_dataout <= (NOT datain(7)) WHEN datain(9) = '1'  ELSE datain(7);
	wire_nllll_w_lg_dataout68w(0) <= NOT wire_nllll_dataout;
	wire_nlllO_dataout <= (NOT datain(6)) WHEN datain(9) = '1'  ELSE datain(6);
	wire_nlllO_w_lg_w_lg_dataout61w62w(0) <= wire_nlllO_w_lg_dataout61w(0) AND wire_nllll_dataout;
	wire_nlllO_w_lg_dataout69w(0) <= wire_nlllO_dataout AND wire_nllll_w_lg_dataout68w(0);
	wire_nlllO_w_lg_dataout61w(0) <= NOT wire_nlllO_dataout;

 END RTL; --stratixgx_8b10b_decoder
--synopsys translate_on
--VALID FILE
--/////////////////////////////////////////////////////////////////////////////
--
--                            STRATIXGX_COMP_FIFO_CORE
--
--/////////////////////////////////////////////////////////////////////////////
 
LIBRARY ieee, stratixgx_gxb,std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
 
ENTITY stratixgx_comp_fifo_core IS
  GENERIC (
    use_rate_match_fifo     : string  := "true";
    rate_matching_fifo_mode : string  := "xaui";
    use_channel_align       : string  := "true";
    for_engineering_sample_device : string := "true";    
    channel_num             : integer := 0
    );
  PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      underflow               : IN std_logic;   
      overflow                : IN std_logic;   
      errdetectin             : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      disablefifowrin         : IN std_logic;   
      disablefifordin         : IN std_logic;   
      re                      : IN std_logic;   
      we                      : IN std_logic;   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      datainpre               : IN std_logic_vector(9 DOWNTO 0);   
      syncstatusin            : IN std_logic;   
      disperr                 : OUT std_logic;   
      alignstatus             : IN std_logic;   
      fifordin                : IN std_logic;   
      fifordout               : OUT std_logic;   
      decsync                 : OUT std_logic;   
      fifocntlt5                  : OUT std_logic;   
      fifocntgt9                : OUT std_logic;   
      done                    : OUT std_logic;   
      fifoalmostful           : OUT std_logic;   
      fifofull                : OUT std_logic;   
      fifoalmostempty         : OUT std_logic;   
      fifoempty               : OUT std_logic;   
      alignsyncstatus         : OUT std_logic;   
      smenable                : OUT std_logic;   
      disablefifordout        : OUT std_logic;   
      disablefifowrout        : OUT std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      codevalid               : OUT std_logic;   
      errdetectout            : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      syncstatus              : OUT std_logic);
END stratixgx_comp_fifo_core;
 
ARCHITECTURE arch_stratixgx_comp_fifo_core OF stratixgx_comp_fifo_core IS
 
   SIGNAL ge_xaui_sel              :  std_logic;   
   SIGNAL decsync_1                :  std_logic;   
   SIGNAL fifo_cnt_lt_8                   :  std_logic;   
   SIGNAL fifo_cnt_lt_9                   :  std_logic;   
   SIGNAL fifo_cnt_lt_7                   :  std_logic;   
   SIGNAL fifo_cnt_lt_12                  :  std_logic;   
   SIGNAL fifo_cnt_lt_4                   :  std_logic;   
   SIGNAL fifo_cnt_gt_10                  :  std_logic;   
   SIGNAL fifo_cnt_gt_8                   :  std_logic;   
   SIGNAL fifo_cnt_gt_13                  :  std_logic;   
   SIGNAL fifo_cnt_gt_5                 :  std_logic;   
   SIGNAL fifo_cnt_gt_6                 :  std_logic;   
   SIGNAL almostfull_1             :  std_logic;   
   SIGNAL almostfull_sync          :  std_logic;   
   SIGNAL almostempty_1            :  std_logic;   
   SIGNAL almostempty_sync         :  std_logic;   
   SIGNAL full_1                   :  std_logic;   
   SIGNAL full_sync                :  std_logic;   
   SIGNAL empty_1                  :  std_logic;   
   SIGNAL empty_sync               :  std_logic;   
   SIGNAL rdenable_sync_1          :  std_logic;   
   SIGNAL rdenable_sync            :  std_logic;   
   SIGNAL write_enable_sync        :  std_logic;   
   SIGNAL write_enable_sync_1      :  std_logic;   
   SIGNAL fifo_dec_dly             :  std_logic;   
   SIGNAL count                    :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL count_read               :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL comp_write_d             :  std_logic;   
   SIGNAL comp_write_pre           :  std_logic;   
   SIGNAL comp_write               :  std_logic;   
   SIGNAL write_detect_d           :  std_logic;   
   SIGNAL write_detect_pre         :  std_logic;   
   SIGNAL write_detect             :  std_logic;   
   SIGNAL comp_read_d              :  std_logic;   
   SIGNAL comp_read                :  std_logic;   
   SIGNAL detect_read_d            :  std_logic;   
   SIGNAL detect_read              :  std_logic;   
   SIGNAL comp_read_ext            :  std_logic;   
   SIGNAL read_eco                 :  std_logic;   
   SIGNAL read_eco_dly             :  std_logic;
   SIGNAL reset_fifo_dec           :  std_logic;   
   SIGNAL read_sync_int_1          :  std_logic;   
   SIGNAL read_sync_int            :  std_logic;   
   SIGNAL read_sync                :  std_logic;   
   SIGNAL fifo_dec                 :  std_logic;   
   SIGNAL done_write               :  std_logic;   
   SIGNAL done_read                :  std_logic;   
   SIGNAL underflow_sync_1         :  std_logic;   
   SIGNAL underflow_sync           :  std_logic;   
   SIGNAL done_read_sync_1         :  std_logic;   
   SIGNAL done_read_sync           :  std_logic;   
   SIGNAL alignsyncstatus_sync     :  std_logic;   
   SIGNAL alignstatus_sync_1       :  std_logic;   
   SIGNAL alignstatus_sync         :  std_logic;   
   SIGNAL alignstatus_dly          :  std_logic;   
   SIGNAL re_dly                   :  std_logic;   
   SIGNAL syncstatus_sync_1        :  std_logic;   
   SIGNAL syncstatus_sync          :  std_logic;   
   SIGNAL write_ptr                :  integer := 0 ;   
   SIGNAL read_ptr1                :  integer := 0 ;   
   SIGNAL read_ptr2                :  integer := 0 ;   
   SIGNAL i                        :  integer;   
   SIGNAL j                        :  integer;   
   SIGNAL k                        :  integer;   
   SIGNAL fifo                     :  std_logic_vector(14 * 12 - 1 DOWNTO 0);   
   SIGNAL fifo_errdetectin         :  std_logic;   
   SIGNAL fifo_errdetectin_dly     :  std_logic;   
   SIGNAL fifo_disperrin           :  std_logic;   
   SIGNAL fifo_disperrin_dly       :  std_logic;   
   SIGNAL fifo_patterndetectin     :  std_logic;   
   SIGNAL fifo_patterndetectin_dly :  std_logic;   
   SIGNAL fifo_syncstatusin         :  std_logic;   
   SIGNAL fifo_syncstatusin_dly     :  std_logic;   
   SIGNAL fifo_data_in             :  std_logic_vector(10 DOWNTO 0);   
   SIGNAL fifo_data_in_dly         :  std_logic_vector(10 DOWNTO 0);
   SIGNAL comp_pat1                :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL comp_pat2                :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_data_in_pre         :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL fifo_data_out1_sync      :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out1_sync_dly  :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out1_sync_valid:  std_logic;   
   SIGNAL fifo_data_out2_sync      :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out1_tmp       :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out2_tmp       :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL fifo_data_out1           :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL fifo_data_out2           :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL genericfifo_sync_clk2_1  :  std_logic;   
   SIGNAL genericfifo_sync_clk2    :  std_logic;   
   SIGNAL genericfifo_sync_clk1_1  :  std_logic;   
   SIGNAL genericfifo_sync_clk1    :  std_logic;   
   SIGNAL onechannel               :  std_logic;   
   SIGNAL deskewenable             :  std_logic;   
   SIGNAL matchenable              :  std_logic;   
   SIGNAL menable                  :  std_logic;   
   SIGNAL genericfifo              :  std_logic;   
   SIGNAL globalenable             :  std_logic;   
   SIGNAL fifordout_tmp1          :  std_logic;   
   SIGNAL fifoalmostful_tmp2      :  std_logic;   
   SIGNAL fifofull_tmp3           :  std_logic;   
   SIGNAL fifoalmostempty_tmp4    :  std_logic;   
   SIGNAL fifoempty_tmp5          :  std_logic;   
   SIGNAL decsync_tmp6            :  std_logic;   
   SIGNAL fifocntlt5_tmp7             :  std_logic;   
   SIGNAL fifocntgt9_tmp8           :  std_logic;   
   SIGNAL done_tmp9               :  std_logic;   
   SIGNAL alignsyncstatus_tmp10   :  std_logic;   
   SIGNAL smenable_tmp11          :  std_logic;   
   SIGNAL disablefifordout_tmp12  :  std_logic;   
   SIGNAL disablefifowrout_tmp13  :  std_logic;   
   SIGNAL dataout_tmp14           :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL codevalid_tmp15         :  std_logic;   
   SIGNAL errdetectout_tmp16      :  std_logic;   
   SIGNAL syncstatus_tmp17        :  std_logic;   
   SIGNAL patterndetect_tmp18     :  std_logic;   
   SIGNAL disperr_tmp19           :  std_logic;   
   SIGNAL count_less3_tmp         :  std_logic;
   SIGNAL count_2_tmp             :  std_logic;
   SIGNAL count_read_tmp          :  std_logic;
   SIGNAL writeclk_dly            :  std_logic;
   SIGNAL write_done              :  std_logic := '0';
  
BEGIN
   fifordout <= fifordout_tmp1;
   fifoalmostful <= fifoalmostful_tmp2;
   fifofull <= fifofull_tmp3;
   fifoalmostempty <= fifoalmostempty_tmp4;
   fifoempty <= fifoempty_tmp5;
   decsync <= decsync_tmp6;
   fifocntlt5 <= fifocntlt5_tmp7;
   fifocntgt9 <= fifocntgt9_tmp8;
   done <= done_tmp9;
   alignsyncstatus <= alignsyncstatus_tmp10;
   smenable <= smenable_tmp11;
   disablefifordout <= disablefifordout_tmp12;
   disablefifowrout <= disablefifowrout_tmp13;
   dataout <= dataout_tmp14;
   codevalid <= codevalid_tmp15;
   errdetectout <= errdetectout_tmp16;
   syncstatus <= syncstatus_tmp17;
   patterndetect <= patterndetect_tmp18;
   disperr <= disperr_tmp19;
   onechannel <= '1' WHEN (channel_num = 0) ELSE '0' ;
   deskewenable <= '1' WHEN (use_channel_align = "true") ELSE '0' ;
   matchenable <= '1' WHEN (use_rate_match_fifo = "true") ELSE '0' ;
   menable <= matchenable AND NOT deskewenable ;
   genericfifo <= '1' WHEN (rate_matching_fifo_mode = "none") ELSE '0' ;
   globalenable <= matchenable AND deskewenable ;
   ge_xaui_sel <= '1' WHEN (rate_matching_fifo_mode = "gige") ELSE '0' ;

   PROCESS (writeclk)
   BEGIN
     writeclk_dly <= writeclk;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         comp_write_pre <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((alignsyncstatus_tmp10 AND (write_detect OR NOT ge_xaui_sel)) = '1') THEN
            comp_write_pre <= comp_write_d;    
         ELSE
            comp_write_pre <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         write_detect_pre <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((alignsyncstatus_tmp10 AND ge_xaui_sel) = '1') THEN
            write_detect_pre <= write_detect_d;    
         ELSE
            write_detect_pre <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         comp_read <= '0';    
         comp_read_ext <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         comp_read_ext <= (underflow_sync AND comp_read) AND ge_xaui_sel;    
         IF ((alignsyncstatus_sync AND (detect_read OR NOT ge_xaui_sel)) = '1') THEN
            comp_read <= (comp_read_d AND NOT fifo_data_out2_sync(10)) AND NOT fifo_data_out2_sync(12);    
         ELSE
            comp_read <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         detect_read <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((alignsyncstatus_sync AND ge_xaui_sel) = '1') THEN
            detect_read <= (detect_read_d AND NOT fifo_data_out2_sync(10)) AND NOT fifo_data_out2_sync(12);    
         ELSE
            detect_read <= '0';    
         END IF;
      END IF;
   END PROCESS;
   fifo_cnt_lt_4 <= '1' when (count <4) else '0';
   fifocntlt5_tmp7 <= '1' when (count < 5) else '0';
   fifo_cnt_lt_7 <= '1' when (count < 7) else '0';
   fifo_cnt_lt_8 <= '1' when (count < 8) else '0';  -- added in REV-C
   fifo_cnt_lt_9 <= '1' when (count < 9) else '0';
   fifo_cnt_lt_12 <= '1' when (count < 12) else '0';
   fifo_cnt_gt_5 <= '1' when (count > 5) else '0';
   fifo_cnt_gt_6 <= '1' when (count > 6) else '0';  -- added in REV-C
   fifo_cnt_gt_8 <= '1' when (count > 8) else '0';
   fifocntgt9_tmp8 <= '1' when (count > 9) else '0';
   fifo_cnt_gt_10 <= '1' when (count > 10) else '0';
   fifo_cnt_gt_13 <= '1' when (count > 13) else '0';
   disablefifowrout_tmp13 <= disablefifowrin WHEN (globalenable AND NOT onechannel) = '1' ELSE ((overflow AND comp_write) AND NOT done_write) ;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         count <= "0000";    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (genericfifo_sync_clk1 = '1') THEN
            IF ((write_enable_sync AND NOT decsync_tmp6) = '1') THEN
               count <= count + "0001";    
            ELSE
               IF ((write_enable_sync AND decsync_tmp6) = '1') THEN
                  count <= count - "0010";    
               ELSE
                  IF ((NOT write_enable_sync AND decsync_tmp6) = '1') THEN
                     count <= count - "0011";    
                  ELSE
                     count <= count;    
                  END IF;
               END IF;
            END IF;
         ELSE
            IF (NOT alignsyncstatus_tmp10 = '1') THEN
               count <= "0000";    
            ELSE
               IF ((NOT decsync_tmp6 AND NOT disablefifowrout_tmp13) = '1') THEN
                  count <= count + "0001";    
               ELSE
                  IF ((decsync_tmp6 AND NOT disablefifowrout_tmp13) = '1') THEN
                     count <= count - "0010";    
                  ELSE
                     IF (((NOT ge_xaui_sel AND decsync_tmp6) AND disablefifowrout_tmp13) = '1') THEN
                        count <= count - "0011";    
                     ELSE
                        IF (((ge_xaui_sel AND decsync_tmp6) AND disablefifowrout_tmp13) = '1') THEN
                           count <= count - "0100";    
                        ELSE
                           IF (((ge_xaui_sel AND NOT decsync_tmp6) AND disablefifowrout_tmp13) = '1') THEN
                              count <= count - "0001";    
                           ELSE
                              count <= count;    
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         done_write <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         done_write <= overflow AND comp_write;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         almostfull_1 <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (almostfull_1 = '1') THEN
            almostfull_1 <= NOT fifo_cnt_lt_8;    
         ELSE
            almostfull_1 <= fifocntgt9_tmp8;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         almostempty_1 <= '1';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (almostempty_1 = '1') THEN
            almostempty_1 <= NOT fifo_cnt_gt_6;    
         ELSE
            almostempty_1 <= fifocntlt5_tmp7;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         full_1 <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (full_1 = '1') THEN
            full_1 <= NOT fifo_cnt_lt_12;    
         ELSE
            full_1 <= fifo_cnt_gt_13;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         empty_1 <= '1';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF (empty_1 = '1') THEN
            empty_1 <= NOT fifo_cnt_gt_5;    
         ELSE
            empty_1 <= fifo_cnt_lt_4;    
         END IF;
      END IF;
   END PROCESS;
   read_sync <= fifordin WHEN (globalenable AND NOT onechannel) = '1' ELSE fifordout_tmp1 ;
   fifordout_tmp1 <= read_sync_int ;

   count_less3_tmp <= '1' when (count <= 2) else '0';
   count_2_tmp <= '1' when (count = 2) else '0';

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         read_eco <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((read_eco AND count_less3_tmp) = '1') THEN
            read_eco <= '0';    
         ELSE
            IF ((NOT read_eco AND count_2_tmp) = '1') THEN
               read_eco <= '1';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   alignstatus_dly <= alignstatus after 1 ps;
   read_eco_dly <= read_eco after 1 ps;
   re_dly <= re after 1 ps;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         read_sync_int_1 <= '0';    
         read_sync_int <= '0';    
         underflow_sync_1 <= '0';    
         underflow_sync <= '0';    
         alignstatus_sync_1 <= '0';    
         alignstatus_sync <= '0';    
         syncstatus_sync_1 <= '0';    
         syncstatus_sync <= '0';    
         rdenable_sync_1 <= '0';    
         rdenable_sync <= '0';    
         fifo_data_out1_sync_valid <= '0';    
         fifo_dec_dly <= '0';    
         almostfull_sync <= '0';    
         almostempty_sync <= '1';    
         full_sync <= '0';    
         empty_sync <= '1';    
         fifoalmostful_tmp2 <= '0';    
         fifoalmostempty_tmp4 <= '1';    
         fifofull_tmp3 <= '0';    
         fifoempty_tmp5 <= '1';    
         genericfifo_sync_clk2_1 <= '0';    
         genericfifo_sync_clk2 <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         read_sync_int_1 <= read_eco_dly AND NOT genericfifo_sync_clk2;    
         read_sync_int <= read_sync_int_1;    
         underflow_sync_1 <= underflow;    
         underflow_sync <= underflow_sync_1;    
         alignstatus_sync_1 <= alignstatus_dly;    
         alignstatus_sync <= alignstatus_sync_1;    
         syncstatus_sync_1 <= syncstatusin;    
         syncstatus_sync <= syncstatus_sync_1;    
         rdenable_sync_1 <= re_dly AND genericfifo;    
         rdenable_sync <= rdenable_sync_1;    
         fifo_data_out1_sync_valid <= ((NOT genericfifo_sync_clk2 AND alignsyncstatus_sync) AND read_sync) OR (genericfifo_sync_clk2 AND rdenable_sync);    
         fifo_dec_dly <= fifo_dec;    
         almostfull_sync <= almostfull_1;    
         almostempty_sync <= almostempty_1;    
         full_sync <= full_1;    
         empty_sync <= empty_1;    
         fifoalmostful_tmp2 <= almostfull_sync;    
         fifoalmostempty_tmp4 <= almostempty_sync;    
         fifofull_tmp3 <= full_sync;    
         fifoempty_tmp5 <= empty_sync;    
         genericfifo_sync_clk2_1 <= genericfifo;    
         genericfifo_sync_clk2 <= genericfifo_sync_clk2_1;    
      END IF;
   END PROCESS;
   disablefifordout_tmp12 <= disablefifordin WHEN (globalenable AND NOT onechannel) = '1' ELSE ((underflow_sync AND (comp_read OR comp_read_ext)) AND NOT done_read) ;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         count_read <= "00";    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((NOT alignsyncstatus_sync AND NOT genericfifo_sync_clk2) = '1') THEN
            count_read <= "00";    
         ELSE
            IF (((read_sync AND NOT disablefifordout_tmp12) OR rdenable_sync) = '1') THEN
               IF (count_read = 2) THEN
                  count_read <= "00";    
               ELSE
                  count_read <= count_read + "01";    
               END IF;
            ELSE
               count_read <= count_read;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         done_read <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((underflow_sync AND ((comp_read AND NOT ge_xaui_sel) OR (comp_read_ext AND ge_xaui_sel))) = '1') THEN
            done_read <= '1';    
         ELSE
            IF (NOT underflow_sync = '1') THEN
               done_read <= '0';    
            ELSE
               done_read <= done_read;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   reset_fifo_dec <= reset OR NOT (NOT fifo_dec_dly OR readclk) ;

   -- count_read_tmp <= '1' when (count_read = 2) else '0';
   count_read_tmp <= '1' when (count_read = 1) else '0';

   PROCESS (reset_fifo_dec, readclk)
   BEGIN
      IF (reset_fifo_dec = '1') THEN
         fifo_dec <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((count_read_tmp AND ((NOT disablefifordout_tmp12 AND NOT genericfifo_sync_clk2) OR (rdenable_sync AND genericfifo_sync_clk2))) = '1') THEN
            fifo_dec <= '1';    
         ELSE
            fifo_dec <= fifo_dec;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         decsync_1 <= '0';    
         decsync_tmp6 <= '0';    
         done_read_sync_1 <= '0';    
         done_read_sync <= '0';    
         write_enable_sync_1 <= '0';    
         write_enable_sync <= '0';    
         genericfifo_sync_clk1_1 <= '0';    
         genericfifo_sync_clk1 <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         decsync_1 <= fifo_dec;    
         decsync_tmp6 <= decsync_1 AND NOT decsync_tmp6;    
         done_read_sync_1 <= done_read;    
         done_read_sync <= done_read_sync_1;    
         write_enable_sync_1 <= we AND genericfifo;    
         write_enable_sync <= write_enable_sync_1;    
         genericfifo_sync_clk1_1 <= genericfifo;    
         genericfifo_sync_clk1 <= genericfifo_sync_clk1_1;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') then 
         write_ptr <= 0;
         write_done <= '0';
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         IF ((NOT alignsyncstatus_tmp10 AND NOT genericfifo_sync_clk1) = '1') THEN
            write_ptr <= 0;    
         ELSE
            IF (((write_enable_sync AND genericfifo_sync_clk1) OR (NOT disablefifowrout_tmp13 AND NOT genericfifo_sync_clk1)) = '1') THEN
               IF (write_ptr /= 11) THEN
                  write_ptr <= write_ptr + 1;    
               ELSE
                  write_ptr <= 0;    
               END IF;
            ELSE
               IF (((disablefifowrout_tmp13 AND ge_xaui_sel) AND NOT genericfifo_sync_clk1) = '1') THEN
                  IF (write_ptr /= 0) THEN
                     write_ptr <= write_ptr - 1;    
                  ELSE
                     write_ptr <= 11;    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         read_ptr1 <= 0;    
         read_ptr2 <= 1;    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF ((NOT alignsyncstatus_sync AND NOT genericfifo_sync_clk2) = '1') THEN
            read_ptr1 <= 0;    
            read_ptr2 <= 1;    
         ELSE
            IF ((((read_sync AND NOT disablefifordout_tmp12) AND NOT genericfifo_sync_clk2) OR (rdenable_sync AND genericfifo_sync_clk2)) = '1') THEN
               IF (read_ptr1 /= 11) THEN
                  read_ptr1 <= read_ptr1 + 1;    
               ELSE
                  read_ptr1 <= 0;    
               END IF;
               IF (read_ptr2 /= 11) THEN
                  read_ptr2 <= read_ptr2 + 1;    
               ELSE
                  read_ptr2 <= 0;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(fifo_data_in)
   BEGIN
       fifo_data_in_dly <= fifo_data_in;
   END PROCESS;

   PROCESS(fifo_errdetectin, fifo_disperrin, fifo_patterndetectin, fifo_syncstatusin)
   BEGIN
       fifo_errdetectin_dly <= fifo_errdetectin;
       fifo_disperrin_dly <= fifo_disperrin;
       fifo_patterndetectin_dly <= fifo_patterndetectin;
       fifo_syncstatusin_dly <= fifo_syncstatusin;
   END PROCESS;

   PROCESS(write_ptr, fifo_data_in_dly, fifo_errdetectin_dly, fifo_syncstatusin_dly, fifo_disperrin_dly, fifo_patterndetectin_dly, reset)
     VARIABLE fifo_tmp  : std_logic_vector(14 * 12 - 1 DOWNTO 0);
   BEGIN
      IF (reset = '1') THEN
          FOR i IN 0 TO (168 - 1) LOOP
             fifo_tmp(i) := '0';    
          END LOOP;
      ELSE
          FOR i IN 0 TO (10 - 1) LOOP
             fifo_tmp(write_ptr * 14 + i) := fifo_data_in_dly(i);    
          END LOOP;
          fifo_tmp(write_ptr * 14 + 10) := fifo_errdetectin_dly;    
          fifo_tmp(write_ptr * 14 + 11) := fifo_syncstatusin_dly;    
          fifo_tmp(write_ptr * 14 + 12) := fifo_disperrin_dly;    
          fifo_tmp(write_ptr * 14 + 13) := fifo_patterndetectin_dly;
      END IF;
      fifo <= fifo_tmp;
   END PROCESS;

   PROCESS (writeclk_dly, reset, read_ptr1, read_ptr2)
      VARIABLE fifo_data_out1_tmp_tmp21  : std_logic_vector(13 DOWNTO 0);
      VARIABLE fifo_data_out2_tmp_tmp22  : std_logic_vector(12 DOWNTO 0);
   BEGIN
      IF ((writeclk_dly = '1') OR read_ptr1'event OR read_ptr2'event) THEN
         FOR j IN 0 TO (14 - 1) LOOP
            fifo_data_out1_tmp_tmp21(j) := fifo(read_ptr1 * 14 + j);    
         END LOOP;
         FOR k IN 0 TO (13 - 1) LOOP
            fifo_data_out2_tmp_tmp22(k) := fifo(read_ptr2 * 14 + k);    
         END LOOP;
      END IF;
      fifo_data_out1_tmp <= fifo_data_out1_tmp_tmp21;
      fifo_data_out2_tmp <= fifo_data_out2_tmp_tmp22;
   END PROCESS;

   fifo_data_out1 <= fifo_data_out1_tmp after 1 ps;
   fifo_data_out2 <= '0' & fifo_data_out2_tmp after 1 ps;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         fifo_data_out1_sync <= "00000000000000";    
         fifo_data_out1_sync_dly <= "00000000000000";    
         fifo_data_out2_sync <= "00000000000000";    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF (ge_xaui_sel = '1') THEN
            fifo_data_out1_sync_dly <= fifo_data_out1_sync;    
         ELSE
            fifo_data_out1_sync_dly <= "00000000000000";    
         END IF;
         IF (NOT disablefifordout_tmp12 = '1') THEN
            fifo_data_out1_sync <= fifo_data_out1;    
            fifo_data_out2_sync <= fifo_data_out2;    
         ELSE
            IF (ge_xaui_sel = '1') THEN
               fifo_data_out1_sync <= fifo_data_out1_sync_dly;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   done_tmp9 <= done_write OR done_read_sync ;
   smenable_tmp11 <= '1' WHEN ((menable OR (globalenable AND onechannel)) AND NOT genericfifo_sync_clk1) = '1' ELSE '0' ;
   comp_pat1 <= "001010110110" WHEN (ge_xaui_sel) = '1' ELSE "000010111100" ;
   comp_pat2 <= "001101000011" WHEN (ge_xaui_sel) = '0' ELSE "001010001010" WHEN (for_engineering_sample_device) = "true" ELSE "001010001001";
   comp_write_d <= '1' WHEN (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER(comp_pat1)) OR (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER(comp_pat2)) ELSE '0' ;
   comp_read_d <= '1' WHEN (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER(comp_pat1)) OR (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER(comp_pat2)) ELSE '0' ;
   write_detect_d <= '1' WHEN (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER("0101111100")) OR (fifo_data_in_pre(9 DOWNTO 0) = CONV_INTEGER("1010000011")) ELSE '0' ;
   detect_read_d <= '1' WHEN (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER("0101111100")) OR (fifo_data_out2_sync(9 DOWNTO 0) = CONV_INTEGER("1010000011")) ELSE '0' ;
   dataout_tmp14 <= fifo_data_out1_sync(9 DOWNTO 0) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE datain ;
   errdetectout_tmp16 <= fifo_data_out1_sync(10) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE errdetectin ;
   syncstatus_tmp17 <= fifo_data_out1_sync(11) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE syncstatusin ;
   disperr_tmp19 <= fifo_data_out1_sync(12) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE disperrin ;
   patterndetect_tmp18 <= fifo_data_out1_sync(13) WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE patterndetectin ;
   codevalid_tmp15 <= fifo_data_out1_sync_valid WHEN (matchenable OR genericfifo_sync_clk2) = '1' ELSE alignstatus_dly WHEN (deskewenable) = '1' ELSE syncstatusin ;
   alignsyncstatus_tmp10 <= '0' WHEN (NOT matchenable OR genericfifo_sync_clk1) = '1' ELSE alignstatus_dly WHEN (deskewenable) = '1' ELSE syncstatusin ;
   alignsyncstatus_sync <= '0' WHEN (NOT matchenable OR genericfifo_sync_clk2) = '1' ELSE alignstatus_sync WHEN (deskewenable) = '1' ELSE syncstatus_sync ;
   fifo_data_in <= '0' & datain ;
   fifo_data_in_pre <= "000" & datainpre ;
   fifo_errdetectin <= errdetectin ;
   fifo_disperrin <= disperrin ;
   fifo_patterndetectin <= patterndetectin ;
   fifo_syncstatusin <= syncstatusin ;
   comp_write <= (comp_write_pre AND NOT errdetectin) AND NOT disperrin ;
   write_detect <= (write_detect_pre AND NOT errdetectin) AND NOT disperrin ;
 
END arch_stratixgx_comp_fifo_core;
 
--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 30 mux21 14 oper_selector 6 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_comp_fifo_sm IS 
	 PORT 
	 ( 
		 alignsyncstatus	:	IN  STD_LOGIC;
		 decsync	:	IN  STD_LOGIC;
		 done	:	IN  STD_LOGIC;
		 fifocntgt9	:	IN  STD_LOGIC;
		 fifocntlt5	:	IN  STD_LOGIC;
		 overflow	:	OUT  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 smenable	:	IN  STD_LOGIC;
		 underflow	:	OUT  STD_LOGIC;
		 writeclk	:	IN  STD_LOGIC
	 ); 
 END stratixgx_comp_fifo_sm;

 ARCHITECTURE RTL OF stratixgx_comp_fifo_sm IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 n00i15	:	STD_LOGIC := '0';
	 SIGNAL	 n00i16	:	STD_LOGIC := '0';
	 SIGNAL  wire_n00i16_w_lg_w_lg_q47w48w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00i16_w_lg_q47w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n00O13	:	STD_LOGIC := '0';
	 SIGNAL	 n00O14	:	STD_LOGIC := '0';
	 SIGNAL  wire_n00O14_w_lg_w_lg_q39w40w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n00O14_w_lg_q39w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n01i19	:	STD_LOGIC := '0';
	 SIGNAL	 n01i20	:	STD_LOGIC := '0';
	 SIGNAL  wire_n01i20_w_lg_w_lg_q60w61w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01i20_w_lg_q60w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n01l17	:	STD_LOGIC := '0';
	 SIGNAL	 n01l18	:	STD_LOGIC := '0';
	 SIGNAL  wire_n01l18_w_lg_w_lg_q57w58w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01l18_w_lg_q57w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n0ii11	:	STD_LOGIC := '0';
	 SIGNAL	 n0ii12	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0ii12_w_lg_w_lg_q28w29w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0ii12_w_lg_q28w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n0il10	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0il10_w_lg_w_lg_q22w24w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0il10_w_lg_q22w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n0il9	:	STD_LOGIC := '0';
	 SIGNAL	 n0iO7	:	STD_LOGIC := '0';
	 SIGNAL	 n0iO8	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0iO8_w_lg_w_lg_q18w19w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iO8_w_lg_q18w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n0lO5	:	STD_LOGIC := '0';
	 SIGNAL	 n0lO6	:	STD_LOGIC := '0';
	 SIGNAL	 n0OO3	:	STD_LOGIC := '0';
	 SIGNAL	 n0OO4	:	STD_LOGIC := '0';
	 SIGNAL	 n1Ol23	:	STD_LOGIC := '0';
	 SIGNAL	 n1Ol24	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1Ol24_w_lg_w_lg_q77w78w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Ol24_w_lg_q77w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1OO21	:	STD_LOGIC := '0';
	 SIGNAL	 n1OO22	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1OO22_w_lg_w_lg_q63w64w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OO22_w_lg_q63w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 ni1O1	:	STD_LOGIC := '0';
	 SIGNAL	 ni1O2	:	STD_LOGIC := '0';
	 SIGNAL	nO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nl_w_lg_nO14w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl_w_lg_w_lg_nO55w59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl_w_lg_nO55w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	ni	:	STD_LOGIC := '0';
	 SIGNAL	nil	:	STD_LOGIC := '0';
	 SIGNAL	niO	:	STD_LOGIC := '0';
	 SIGNAL	nli	:	STD_LOGIC := '0';
	 SIGNAL	nll	:	STD_LOGIC := '0';
	 SIGNAL	wire_nlO_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niOl_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_niOl_o	:	STD_LOGIC;
	 SIGNAL  wire_niOl_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_niOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_niOO_o	:	STD_LOGIC;
	 SIGNAL  wire_niOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0l_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0O_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nl0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0O_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nl1l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nl1l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_alignsyncstatus10w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_decsync9w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_done13w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n0li12w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n0ll23w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset2w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n00l :	STD_LOGIC;
	 SIGNAL  n0li :	STD_LOGIC;
	 SIGNAL  n0ll :	STD_LOGIC;
	 SIGNAL  ni1i :	STD_LOGIC;
 BEGIN

	wire_w_lg_alignsyncstatus10w(0) <= NOT alignsyncstatus;
	wire_w_lg_decsync9w(0) <= NOT decsync;
	wire_w_lg_done13w(0) <= NOT done;
	wire_w_lg_n0li12w(0) <= NOT n0li;
	wire_w_lg_n0ll23w(0) <= NOT n0ll;
	wire_w_lg_reset2w(0) <= NOT reset;
	n00l <= (nO OR ni);
	n0li <= (fifocntlt5 OR fifocntgt9);
	n0ll <= ((alignsyncstatus AND smenable) AND (n0lO6 XOR n0lO5));
	ni1i <= '1';
	overflow <= nil;
	underflow <= niO;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n00i15 <= n00i16;
		END IF;
		if (now = 0 ns) then
			n00i15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n00i16 <= n00i15;
		END IF;
	END PROCESS;
	wire_n00i16_w_lg_w_lg_q47w48w(0) <= wire_n00i16_w_lg_q47w(0) AND wire_n1i_dataout;
	wire_n00i16_w_lg_q47w(0) <= n00i16 XOR n00i15;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n00O13 <= n00O14;
		END IF;
		if (now = 0 ns) then
			n00O13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n00O14 <= n00O13;
		END IF;
	END PROCESS;
	wire_n00O14_w_lg_w_lg_q39w40w(0) <= wire_n00O14_w_lg_q39w(0) AND nll;
	wire_n00O14_w_lg_q39w(0) <= n00O14 XOR n00O13;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n01i19 <= n01i20;
		END IF;
		if (now = 0 ns) then
			n01i19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n01i20 <= n01i19;
		END IF;
	END PROCESS;
	wire_n01i20_w_lg_w_lg_q60w61w(0) <= wire_n01i20_w_lg_q60w(0) AND wire_nl_w_lg_w_lg_nO55w59w(0);
	wire_n01i20_w_lg_q60w(0) <= n01i20 XOR n01i19;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n01l17 <= n01l18;
		END IF;
		if (now = 0 ns) then
			n01l17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n01l18 <= n01l17;
		END IF;
	END PROCESS;
	wire_n01l18_w_lg_w_lg_q57w58w(0) <= NOT wire_n01l18_w_lg_q57w(0);
	wire_n01l18_w_lg_q57w(0) <= n01l18 XOR n01l17;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0ii11 <= n0ii12;
		END IF;
		if (now = 0 ns) then
			n0ii11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0ii12 <= n0ii11;
		END IF;
	END PROCESS;
	wire_n0ii12_w_lg_w_lg_q28w29w(0) <= wire_n0ii12_w_lg_q28w(0) AND nli;
	wire_n0ii12_w_lg_q28w(0) <= n0ii12 XOR n0ii11;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0il10 <= n0il9;
		END IF;
	END PROCESS;
	wire_n0il10_w_lg_w_lg_q22w24w(0) <= wire_n0il10_w_lg_q22w(0) AND wire_w_lg_n0ll23w(0);
	wire_n0il10_w_lg_q22w(0) <= n0il10 XOR n0il9;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0il9 <= n0il10;
		END IF;
		if (now = 0 ns) then
			n0il9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0iO7 <= n0iO8;
		END IF;
		if (now = 0 ns) then
			n0iO7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0iO8 <= n0iO7;
		END IF;
	END PROCESS;
	wire_n0iO8_w_lg_w_lg_q18w19w(0) <= wire_n0iO8_w_lg_q18w(0) AND wire_w_lg_alignsyncstatus10w(0);
	wire_n0iO8_w_lg_q18w(0) <= n0iO8 XOR n0iO7;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0lO5 <= n0lO6;
		END IF;
		if (now = 0 ns) then
			n0lO5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0lO6 <= n0lO5;
		END IF;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0OO3 <= n0OO4;
		END IF;
		if (now = 0 ns) then
			n0OO3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n0OO4 <= n0OO3;
		END IF;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n1Ol23 <= n1Ol24;
		END IF;
		if (now = 0 ns) then
			n1Ol23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n1Ol24 <= n1Ol23;
		END IF;
	END PROCESS;
	wire_n1Ol24_w_lg_w_lg_q77w78w(0) <= wire_n1Ol24_w_lg_q77w(0) AND wire_nlOl_dataout;
	wire_n1Ol24_w_lg_q77w(0) <= n1Ol24 XOR n1Ol23;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n1OO21 <= n1OO22;
		END IF;
		if (now = 0 ns) then
			n1OO21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN n1OO22 <= n1OO21;
		END IF;
	END PROCESS;
	wire_n1OO22_w_lg_w_lg_q63w64w(0) <= wire_n1OO22_w_lg_q63w(0) AND wire_nlOO_dataout;
	wire_n1OO22_w_lg_q63w(0) <= n1OO22 XOR n1OO21;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN ni1O1 <= ni1O2;
		END IF;
		if (now = 0 ns) then
			ni1O1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (writeclk)
	BEGIN
		IF (writeclk = '1' AND writeclk'event) THEN ni1O2 <= ni1O1;
		END IF;
	END PROCESS;
	PROCESS (writeclk, reset, wire_nl_CLRN)
	BEGIN
		IF (reset = '1') THEN
				nO <= '1';
		ELSIF (wire_nl_CLRN = '0') THEN
				nO <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN
				nO <= wire_nl0O_o;
		END IF;
		if (now = 0 ns) then
			nO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nl_CLRN <= (ni1O2 XOR ni1O1);
	wire_nl_w_lg_nO14w(0) <= NOT nO;
	wire_nl_w_lg_w_lg_nO55w59w(0) <= wire_nl_w_lg_nO55w(0) OR wire_n01l18_w_lg_w_lg_q57w58w(0);
	wire_nl_w_lg_nO55w(0) <= nO OR nll;
	PROCESS (writeclk, wire_nlO_CLRN)
	BEGIN
		IF (wire_nlO_CLRN = '0') THEN
				ni <= '0';
				nil <= '0';
				niO <= '0';
				nli <= '0';
				nll <= '0';
		ELSIF (writeclk = '1' AND writeclk'event) THEN
				ni <= wire_nl0l_o;
				nil <= wire_niOl_o;
				niO <= wire_niOO_o;
				nli <= wire_nl1l_o;
				nll <= wire_nl0i_o;
		END IF;
	END PROCESS;
	wire_nlO_CLRN <= ((n0OO4 XOR n0OO3) AND wire_w_lg_reset2w(0));
	wire_n0l_dataout <= decsync AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_n0O_dataout <= wire_w_lg_decsync9w(0) AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_n1i_dataout <= n0li AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_n1l_dataout <= fifocntgt9 WHEN n0li = '1'  ELSE nil;
	wire_n1O_dataout <= fifocntlt5 WHEN n0li = '1'  ELSE niO;
	wire_nlii_dataout <= wire_w_lg_done13w(0) AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_nlil_dataout <= done AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_nliO_dataout <= wire_nlll_dataout AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_nlli_dataout <= wire_nllO_dataout AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_nlll_dataout <= niO AND NOT(done);
	wire_nllO_dataout <= nil AND NOT(done);
	wire_nlOi_dataout <= nil WHEN wire_w_lg_alignsyncstatus10w(0) = '1'  ELSE wire_n1l_dataout;
	wire_nlOl_dataout <= niO WHEN wire_w_lg_alignsyncstatus10w(0) = '1'  ELSE wire_n1O_dataout;
	wire_nlOO_dataout <= wire_w_lg_n0li12w(0) AND NOT(wire_w_lg_alignsyncstatus10w(0));
	wire_niOl_data <= ( nil & wire_nlOi_dataout & wire_nlli_dataout);
	wire_niOl_sel <= ( n00l & nli & nll);
	niOl :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_niOl_data,
		o => wire_niOl_o,
		sel => wire_niOl_sel
	  );
	wire_niOO_data <= ( niO & wire_n1Ol24_w_lg_w_lg_q77w78w & wire_nliO_dataout);
	wire_niOO_sel <= ( n00l & nli & nll);
	niOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_niOO_data,
		o => wire_niOO_o,
		sel => wire_niOO_sel
	  );
	wire_nl0i_data <= ( "0" & wire_n00i16_w_lg_w_lg_q47w48w & wire_nlii_dataout);
	wire_nl0i_sel <= ( n00l & nli & wire_n00O14_w_lg_w_lg_q39w40w);
	nl0i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl0i_data,
		o => wire_nl0i_o,
		sel => wire_nl0i_sel
	  );
	wire_nl0l_data <= ( n0ll & wire_n0O_dataout & "0" & wire_nlil_dataout);
	wire_nl0l_sel <= ( nO & ni & wire_n0ii12_w_lg_w_lg_q28w29w & nll);
	nl0l :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nl0l_data,
		o => wire_nl0l_o,
		sel => wire_nl0l_sel
	  );
	wire_nl0O_data <= ( wire_n0il10_w_lg_w_lg_q22w24w & wire_n0iO8_w_lg_w_lg_q18w19w);
	wire_nl0O_sel <= ( nO & wire_nl_w_lg_nO14w);
	nl0O :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_nl0O_data,
		o => wire_nl0O_o,
		sel => wire_nl0O_sel
	  );
	wire_nl1l_data <= ( "0" & wire_n0l_dataout & wire_n1OO22_w_lg_w_lg_q63w64w);
	wire_nl1l_sel <= ( wire_n01i20_w_lg_w_lg_q60w61w & ni & nli);
	nl1l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl1l_data,
		o => wire_nl1l_o,
		sel => wire_nl1l_sel
	  );

 END RTL; --stratixgx_comp_fifo_sm
--synopsys translate_on
--VALID FILE
--/////////////////////////////////////////////////////////////////////////////
--
--                            STRATIXGX_COMP_FIFO
--
--/////////////////////////////////////////////////////////////////////////////
 
LIBRARY ieee, stratixgx_gxb,std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
 
ENTITY stratixgx_comp_fifo IS
  GENERIC (
    use_rate_match_fifo     : string  := "true";
    rate_matching_fifo_mode : string  := "xaui";
    use_channel_align       : string  := "true";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    channel_num             : integer := 0
    );
   PORT (
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      datainpre               : IN std_logic_vector(9 DOWNTO 0);   
      reset                   : IN std_logic;   
      errdetectin             : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      errdetectinpre          : IN std_logic;   
      syncstatusinpre         : IN std_logic;   
      disperrinpre            : IN std_logic;   
      patterndetectinpre      : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      re                      : IN std_logic;   
      we                      : IN std_logic;   
      fifordin                : IN std_logic;   
      disablefifordin         : IN std_logic;   
      disablefifowrin         : IN std_logic;   
      alignstatus             : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      errdetectout            : OUT std_logic;   
      syncstatus              : OUT std_logic;   
      disperr                 : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      codevalid               : OUT std_logic;   
      fifofull                : OUT std_logic;   
      fifoalmostful           : OUT std_logic;   
      fifoempty               : OUT std_logic;   
      fifoalmostempty         : OUT std_logic;   
      disablefifordout        : OUT std_logic;   
      disablefifowrout        : OUT std_logic;   
      fifordout               : OUT std_logic);   
end stratixgx_comp_fifo;
 
ARCHITECTURE arch_stratixgx_comp_fifo OF stratixgx_comp_fifo IS

   COMPONENT stratixgx_comp_fifo_core
      GENERIC (
          channel_num                    :  integer := 0;    
          rate_matching_fifo_mode        :  string := "xaui";    
          use_channel_align              :  string := "true";    
          for_engineering_sample_device  :  string := "true"; -- new in 3.0 SP2 
          use_rate_match_fifo            :  string := "true");
      PORT (
         reset                   : IN  std_logic;
         writeclk                : IN  std_logic;
         readclk                 : IN  std_logic;
         underflow               : IN  std_logic;
         overflow                : IN  std_logic;
         errdetectin             : IN  std_logic;
         disperrin               : IN  std_logic;
         patterndetectin         : IN  std_logic;
         disablefifowrin         : IN  std_logic;
         disablefifordin         : IN  std_logic;
         re                      : IN  std_logic;
         we                      : IN  std_logic;
         datain                  : IN  std_logic_vector(9 DOWNTO 0);
         datainpre               : IN  std_logic_vector(9 DOWNTO 0);
         syncstatusin            : IN  std_logic;
         disperr                 : OUT std_logic;
         alignstatus             : IN  std_logic;
         fifordin                : IN  std_logic;
         fifordout               : OUT std_logic;
         decsync                 : OUT std_logic;
         fifocntlt5                  : OUT std_logic;
         fifocntgt9                : OUT std_logic;
         done                    : OUT std_logic;
         fifoalmostful           : OUT std_logic;
         fifofull                : OUT std_logic;
         fifoalmostempty         : OUT std_logic;
         fifoempty               : OUT std_logic;
         alignsyncstatus         : OUT std_logic;
         smenable                : OUT std_logic;
         disablefifordout        : OUT std_logic;
         disablefifowrout        : OUT std_logic;
         dataout                 : OUT std_logic_vector(9 DOWNTO 0);
         codevalid               : OUT std_logic;
         errdetectout            : OUT std_logic;
         patterndetect           : OUT std_logic;
         syncstatus              : OUT std_logic);
   END COMPONENT;

   COMPONENT stratixgx_comp_fifo_sm
      PORT (
         writeclk                : IN  std_logic;
         alignsyncstatus         : IN  std_logic;
         reset                   : IN  std_logic;
         smenable                : IN  std_logic;
         done                    : IN  std_logic;
         decsync                 : IN  std_logic;
         fifocntlt5                  : IN  std_logic;
         fifocntgt9                : IN  std_logic;
         underflow               : OUT std_logic;
         overflow                : OUT std_logic);
   END COMPONENT;


   SIGNAL done                     :  std_logic;   
   SIGNAL fifocntgt9                 :  std_logic;   
   SIGNAL fifocntlt5                   :  std_logic;   
   SIGNAL decsync                  :  std_logic;   
   SIGNAL alignsyncstatus          :  std_logic;   
   SIGNAL smenable                 :  std_logic;   
   SIGNAL overflow                 :  std_logic;   
   SIGNAL underflow                :  std_logic;   
   SIGNAL dataout_tmp1            :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL errdetectout_tmp2       :  std_logic;   
   SIGNAL syncstatus_tmp3         :  std_logic;   
   SIGNAL disperr_tmp4            :  std_logic;   
   SIGNAL patterndetect_tmp5      :  std_logic;   
   SIGNAL codevalid_tmp6          :  std_logic;   
   SIGNAL fifofull_tmp7           :  std_logic;   
   SIGNAL fifoalmostful_tmp8      :  std_logic;   
   SIGNAL fifoempty_tmp9          :  std_logic;   
   SIGNAL fifoalmostempty_tmp10   :  std_logic;   
   SIGNAL disablefifordout_tmp11  :  std_logic;   
   SIGNAL disablefifowrout_tmp12  :  std_logic;   
   SIGNAL fifordout_tmp13         :  std_logic;   

BEGIN
   dataout <= dataout_tmp1;
   errdetectout <= errdetectout_tmp2;
   syncstatus <= syncstatus_tmp3;
   disperr <= disperr_tmp4;
   patterndetect <= patterndetect_tmp5;
   codevalid <= codevalid_tmp6;
   fifofull <= fifofull_tmp7;
   fifoalmostful <= fifoalmostful_tmp8;
   fifoempty <= fifoempty_tmp9;
   fifoalmostempty <= fifoalmostempty_tmp10;
   disablefifordout <= disablefifordout_tmp11;
   disablefifowrout <= disablefifowrout_tmp12;
   fifordout <= fifordout_tmp13;
 
   comp_fifo_core : stratixgx_comp_fifo_core 
      GENERIC MAP (
         channel_num => channel_num,
         rate_matching_fifo_mode => rate_matching_fifo_mode,
         use_channel_align => use_channel_align,
         for_engineering_sample_device => for_engineering_sample_device, -- new in 3.0 SP2 
         use_rate_match_fifo => use_rate_match_fifo)
      PORT MAP (
         reset => reset,
         writeclk => writeclk,
         readclk => readclk,
         underflow => underflow,
         overflow => overflow,
         errdetectin => errdetectin,
         disperrin => disperrin,
         patterndetectin => patterndetectin,
         disablefifordin => disablefifordin,
         disablefifowrin => disablefifowrin,
         re => re,
         we => we,
         datain => datain,
         datainpre => datainpre,
         syncstatusin => syncstatusin,
         disperr => disperr_tmp4,
         alignstatus => alignstatus,
         fifordin => fifordin,
         fifordout => fifordout_tmp13,
         fifoalmostful => fifoalmostful_tmp8,
         fifofull => fifofull_tmp7,
         fifoalmostempty => fifoalmostempty_tmp10,
         fifoempty => fifoempty_tmp9,
         decsync => decsync,
         fifocntlt5 => fifocntlt5,
         fifocntgt9 => fifocntgt9,
         done => done,
         alignsyncstatus => alignsyncstatus,
         smenable => smenable,
         disablefifordout => disablefifordout_tmp11,
         disablefifowrout => disablefifowrout_tmp12,
         dataout => dataout_tmp1,
         codevalid => codevalid_tmp6,
         errdetectout => errdetectout_tmp2,
         patterndetect => patterndetect_tmp5,
         syncstatus => syncstatus_tmp3);   
   
   comp_fifo_sm : stratixgx_comp_fifo_sm 
      PORT MAP (
         writeclk => writeclk,
         alignsyncstatus => alignsyncstatus,
         reset => reset,
         smenable => smenable,
         done => done,
         decsync => decsync,
         fifocntlt5 => fifocntlt5,
         fifocntgt9 => fifocntgt9,
         underflow => underflow,
         overflow => overflow);   
   
END arch_stratixgx_comp_fifo;
 

--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 283 mux21 302 oper_add 5 oper_less_than 1 oper_mux 18 oper_selector 42 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_hssi_rx_wal_rtl IS 
	 PORT 
	 ( 
		 A1A2_SIZE	:	IN  STD_LOGIC;
		 AUTOBYTEALIGN_DIS	:	IN  STD_LOGIC;
		 BITSLIP	:	IN  STD_LOGIC;
		 cg_comma	:	OUT  STD_LOGIC;
		 DISABLE_RX_DISP	:	IN  STD_LOGIC;
		 DWIDTH	:	IN  STD_LOGIC;
		 encdet_prbs	:	IN  STD_LOGIC;
		 ENCDT	:	IN  STD_LOGIC;
		 GE_XAUI_SEL	:	IN  STD_LOGIC;
		 IB_INVALID_CODE	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 LP10BEN	:	IN  STD_LOGIC;
		 PMADATAWIDTH	:	IN  STD_LOGIC;
		 prbs_en	:	IN  STD_LOGIC;
		 PUDI	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 PUDR	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 rcvd_clk	:	IN  STD_LOGIC;
		 RLV	:	OUT  STD_LOGIC;
		 RLV_EN	:	IN  STD_LOGIC;
		 RLV_lt	:	OUT  STD_LOGIC;
		 RUNDISP_SEL	:	IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 signal_detect	:	IN  STD_LOGIC;
		 signal_detect_sync	:	OUT  STD_LOGIC;
		 soft_reset	:	IN  STD_LOGIC;
		 SUDI	:	OUT  STD_LOGIC_VECTOR (12 DOWNTO 0);
		 SUDI_pre	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 SYNC_COMP_PAT	:	IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 SYNC_COMP_SIZE	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 sync_curr_st	:	OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 SYNC_SM_DIS	:	IN  STD_LOGIC;
		 sync_status	:	OUT  STD_LOGIC
	 ); 
 END stratixgx_hssi_rx_wal_rtl;

 ARCHITECTURE RTL OF stratixgx_hssi_rx_wal_rtl IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 n1l0OO53	:	STD_LOGIC := '0';
	 SIGNAL	 n1l0OO54	:	STD_LOGIC := '0';
	 SIGNAL	 n1li0l49	:	STD_LOGIC := '0';
	 SIGNAL	 n1li0l50	:	STD_LOGIC := '0';
	 SIGNAL	 n1li1i51	:	STD_LOGIC := '0';
	 SIGNAL	 n1li1i52	:	STD_LOGIC := '0';
	 SIGNAL	 n1llOl47	:	STD_LOGIC := '0';
	 SIGNAL	 n1llOl48	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1llOl48_w_lg_q221w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1lO0l43	:	STD_LOGIC := '0';
	 SIGNAL	 n1lO0l44	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1lO0l44_w_lg_q208w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1lO1i45	:	STD_LOGIC := '0';
	 SIGNAL	 n1lO1i46	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOii41	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOii42	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOiO39	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOiO40	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOOi37	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOOi38	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOOO35	:	STD_LOGIC := '0';
	 SIGNAL	 n1lOOO36	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1lOOO36_w_lg_q186w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1O00i17	:	STD_LOGIC := '0';
	 SIGNAL	 n1O00i18	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O00i18_w_lg_w_lg_q79w80w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O00i18_w_lg_q79w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1O00l15	:	STD_LOGIC := '0';
	 SIGNAL	 n1O00l16	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O00l16_w_lg_w_lg_q68w69w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O00l16_w_lg_q68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1O01i23	:	STD_LOGIC := '0';
	 SIGNAL	 n1O01i24	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O01i24_w_lg_w_lg_q99w100w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O01i24_w_lg_q99w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1O01l21	:	STD_LOGIC := '0';
	 SIGNAL	 n1O01l22	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O01l22_w_lg_w_lg_q96w97w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O01l22_w_lg_q96w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1O01O19	:	STD_LOGIC := '0';
	 SIGNAL	 n1O01O20	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O01O20_w_lg_w_lg_q88w89w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O01O20_w_lg_q88w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1O0ii13	:	STD_LOGIC := '0';
	 SIGNAL	 n1O0ii14	:	STD_LOGIC := '0';
	 SIGNAL	 n1O0iO11	:	STD_LOGIC := '0';
	 SIGNAL	 n1O0iO12	:	STD_LOGIC := '0';
	 SIGNAL	 n1O10i33	:	STD_LOGIC := '0';
	 SIGNAL	 n1O10i34	:	STD_LOGIC := '0';
	 SIGNAL	 n1O10O31	:	STD_LOGIC := '0';
	 SIGNAL	 n1O10O32	:	STD_LOGIC := '0';
	 SIGNAL	 n1O1il29	:	STD_LOGIC := '0';
	 SIGNAL	 n1O1il30	:	STD_LOGIC := '0';
	 SIGNAL	 n1O1Ol27	:	STD_LOGIC := '0';
	 SIGNAL	 n1O1Ol28	:	STD_LOGIC := '0';
	 SIGNAL	 n1O1OO25	:	STD_LOGIC := '0';
	 SIGNAL	 n1O1OO26	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oi0l7	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oi0l8	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oi0O5	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oi0O6	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oi1i10	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oi1i9	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oill3	:	STD_LOGIC := '0';
	 SIGNAL	 n1Oill4	:	STD_LOGIC := '0';
	 SIGNAL	 n1OiOi1	:	STD_LOGIC := '0';
	 SIGNAL	 n1OiOi2	:	STD_LOGIC := '0';
	 SIGNAL	n10li	:	STD_LOGIC := '0';
	 SIGNAL	n10lO	:	STD_LOGIC := '0';
	 SIGNAL	n10Oi	:	STD_LOGIC := '0';
	 SIGNAL	n10OO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n10Ol_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n10Ol_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n10Ol_w_lg_n10li1496w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10Ol_w_lg_n10lO1494w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10Ol_w_lg_n10Oi1492w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10Ol_w_lg_n10OO1491w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1lOi	:	STD_LOGIC := '0';
	 SIGNAL	n1lOl	:	STD_LOGIC := '0';
	 SIGNAL	n1lOO	:	STD_LOGIC := '0';
	 SIGNAL	n1O1l	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1O1i_CLRN	:	STD_LOGIC;
	 SIGNAL	n0001i	:	STD_LOGIC := '0';
	 SIGNAL	n0010i	:	STD_LOGIC := '0';
	 SIGNAL	n0010l	:	STD_LOGIC := '0';
	 SIGNAL	n0010O	:	STD_LOGIC := '0';
	 SIGNAL	n0011O	:	STD_LOGIC := '0';
	 SIGNAL	n001ii	:	STD_LOGIC := '0';
	 SIGNAL	n001il	:	STD_LOGIC := '0';
	 SIGNAL	n001iO	:	STD_LOGIC := '0';
	 SIGNAL	n001li	:	STD_LOGIC := '0';
	 SIGNAL	n001ll	:	STD_LOGIC := '0';
	 SIGNAL	n001lO	:	STD_LOGIC := '0';
	 SIGNAL	n001Oi	:	STD_LOGIC := '0';
	 SIGNAL	n001OO	:	STD_LOGIC := '0';
	 SIGNAL	n0101l	:	STD_LOGIC := '0';
	 SIGNAL	n1lli	:	STD_LOGIC := '0';
	 SIGNAL	n1lll	:	STD_LOGIC := '0';
	 SIGNAL	n1O1O	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol0i	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol0O	:	STD_LOGIC := '0';
	 SIGNAL	n1Olli	:	STD_LOGIC := '0';
	 SIGNAL	n1Olll	:	STD_LOGIC := '0';
	 SIGNAL	ni0iOl	:	STD_LOGIC := '0';
	 SIGNAL	ni0iOO	:	STD_LOGIC := '0';
	 SIGNAL	ni0l0i	:	STD_LOGIC := '0';
	 SIGNAL	ni0l0O	:	STD_LOGIC := '0';
	 SIGNAL	ni0l1i	:	STD_LOGIC := '0';
	 SIGNAL	ni0l1l	:	STD_LOGIC := '0';
	 SIGNAL	ni0l1O	:	STD_LOGIC := '0';
	 SIGNAL	ni0O0O	:	STD_LOGIC := '0';
	 SIGNAL	ni0Oii	:	STD_LOGIC := '0';
	 SIGNAL	ni0Oil	:	STD_LOGIC := '0';
	 SIGNAL	ni0OiO	:	STD_LOGIC := '0';
	 SIGNAL	ni0OOO	:	STD_LOGIC := '0';
	 SIGNAL	ni1liO	:	STD_LOGIC := '0';
	 SIGNAL	ni1lli	:	STD_LOGIC := '0';
	 SIGNAL	ni1lll	:	STD_LOGIC := '0';
	 SIGNAL	ni1llO	:	STD_LOGIC := '0';
	 SIGNAL	ni1lOi	:	STD_LOGIC := '0';
	 SIGNAL	ni1lOl	:	STD_LOGIC := '0';
	 SIGNAL	ni1lOO	:	STD_LOGIC := '0';
	 SIGNAL	ni1O1i	:	STD_LOGIC := '0';
	 SIGNAL	ni1Oli	:	STD_LOGIC := '0';
	 SIGNAL	nii11i	:	STD_LOGIC := '0';
	 SIGNAL	nii11l	:	STD_LOGIC := '0';
	 SIGNAL	nii11O	:	STD_LOGIC := '0';
	 SIGNAL	niii0i	:	STD_LOGIC := '0';
	 SIGNAL	niii0l	:	STD_LOGIC := '0';
	 SIGNAL	niii0O	:	STD_LOGIC := '0';
	 SIGNAL	niii1l	:	STD_LOGIC := '0';
	 SIGNAL	niii1O	:	STD_LOGIC := '0';
	 SIGNAL	niiiii	:	STD_LOGIC := '0';
	 SIGNAL	niiiil	:	STD_LOGIC := '0';
	 SIGNAL	niiiiO	:	STD_LOGIC := '0';
	 SIGNAL	niiili	:	STD_LOGIC := '0';
	 SIGNAL	niiill	:	STD_LOGIC := '0';
	 SIGNAL	niiilO	:	STD_LOGIC := '0';
	 SIGNAL	niiiOi	:	STD_LOGIC := '0';
	 SIGNAL	niiiOl	:	STD_LOGIC := '0';
	 SIGNAL	niiiOO	:	STD_LOGIC := '0';
	 SIGNAL	niil1i	:	STD_LOGIC := '0';
	 SIGNAL	niiO0i	:	STD_LOGIC := '0';
	 SIGNAL	niiO0l	:	STD_LOGIC := '0';
	 SIGNAL	niiO0O	:	STD_LOGIC := '0';
	 SIGNAL	niiO1l	:	STD_LOGIC := '0';
	 SIGNAL	niiO1O	:	STD_LOGIC := '0';
	 SIGNAL	niiOii	:	STD_LOGIC := '0';
	 SIGNAL	niiOil	:	STD_LOGIC := '0';
	 SIGNAL	niiOiO	:	STD_LOGIC := '0';
	 SIGNAL	niiOli	:	STD_LOGIC := '0';
	 SIGNAL	niiOll	:	STD_LOGIC := '0';
	 SIGNAL	niiOlO	:	STD_LOGIC := '0';
	 SIGNAL	niiOOi	:	STD_LOGIC := '0';
	 SIGNAL	niiOOl	:	STD_LOGIC := '0';
	 SIGNAL	nil0i	:	STD_LOGIC := '0';
	 SIGNAL	nil0l	:	STD_LOGIC := '0';
	 SIGNAL	nil0O	:	STD_LOGIC := '0';
	 SIGNAL	nilii	:	STD_LOGIC := '0';
	 SIGNAL	nilil	:	STD_LOGIC := '0';
	 SIGNAL	niliO	:	STD_LOGIC := '0';
	 SIGNAL	nilli	:	STD_LOGIC := '0';
	 SIGNAL	nilll	:	STD_LOGIC := '0';
	 SIGNAL	nilOi	:	STD_LOGIC := '0';
	 SIGNAL	nlll0l	:	STD_LOGIC := '0';
	 SIGNAL	nlll0O	:	STD_LOGIC := '0';
	 SIGNAL	nlllll	:	STD_LOGIC := '0';
	 SIGNAL	nllllO	:	STD_LOGIC := '0';
	 SIGNAL	nlllOi	:	STD_LOGIC := '0';
	 SIGNAL	nlllOl	:	STD_LOGIC := '0';
	 SIGNAL	nlllOO	:	STD_LOGIC := '0';
	 SIGNAL	nllO0i	:	STD_LOGIC := '0';
	 SIGNAL	nllO0l	:	STD_LOGIC := '0';
	 SIGNAL	nllO0O	:	STD_LOGIC := '0';
	 SIGNAL	nllO1i	:	STD_LOGIC := '0';
	 SIGNAL	nllO1l	:	STD_LOGIC := '0';
	 SIGNAL	nllO1O	:	STD_LOGIC := '0';
	 SIGNAL	nllOii	:	STD_LOGIC := '0';
	 SIGNAL	nllOil	:	STD_LOGIC := '0';
	 SIGNAL	nllOiO	:	STD_LOGIC := '0';
	 SIGNAL	nllOli	:	STD_LOGIC := '0';
	 SIGNAL	nllOll	:	STD_LOGIC := '0';
	 SIGNAL	nllOlO	:	STD_LOGIC := '0';
	 SIGNAL	nllOOi	:	STD_LOGIC := '0';
	 SIGNAL	nllOOl	:	STD_LOGIC := '0';
	 SIGNAL	nllOOO	:	STD_LOGIC := '0';
	 SIGNAL	nlO00i	:	STD_LOGIC := '0';
	 SIGNAL	nlO00l	:	STD_LOGIC := '0';
	 SIGNAL	nlO00O	:	STD_LOGIC := '0';
	 SIGNAL	nlO01i	:	STD_LOGIC := '0';
	 SIGNAL	nlO01l	:	STD_LOGIC := '0';
	 SIGNAL	nlO01O	:	STD_LOGIC := '0';
	 SIGNAL	nlO0ii	:	STD_LOGIC := '0';
	 SIGNAL	nlO0il	:	STD_LOGIC := '0';
	 SIGNAL	nlO0iO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0li	:	STD_LOGIC := '0';
	 SIGNAL	nlO10i	:	STD_LOGIC := '0';
	 SIGNAL	nlO10l	:	STD_LOGIC := '0';
	 SIGNAL	nlO10O	:	STD_LOGIC := '0';
	 SIGNAL	nlO11i	:	STD_LOGIC := '0';
	 SIGNAL	nlO11l	:	STD_LOGIC := '0';
	 SIGNAL	nlO11O	:	STD_LOGIC := '0';
	 SIGNAL	nlO1ii	:	STD_LOGIC := '0';
	 SIGNAL	nlO1il	:	STD_LOGIC := '0';
	 SIGNAL	nlO1iO	:	STD_LOGIC := '0';
	 SIGNAL	nlO1li	:	STD_LOGIC := '0';
	 SIGNAL	nlO1ll	:	STD_LOGIC := '0';
	 SIGNAL	nlO1lO	:	STD_LOGIC := '0';
	 SIGNAL	nlO1Oi	:	STD_LOGIC := '0';
	 SIGNAL	nlO1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nlO1OO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nillO_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_w2399w2400w2401w2402w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w2399w2400w2401w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w2399w2400w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w2399w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_w_lg_n1O1O2083w2396w2397w2398w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_n1O1O2083w2396w2397w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_nlO0il883w2447w2448w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nilli1648w1653w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nilOi1646w1651w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0il2449w2450w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_n1O1O2083w2396w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO00i855w2583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO00i855w856w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO00O2567w2588w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO01l2560w2562w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO01l2560w2597w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO01O2569w2625w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO01O2569w2620w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO01O2569w2608w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO01O2569w2605w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0ii2442w2476w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0ii2442w2443w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0il883w2458w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0il883w2512w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0il883w2447w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0il883w884w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0il883w2495w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0iO882w2459w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0iO882w2506w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0iO882w2533w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0iO882w2528w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0iO882w2509w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0li881w2482w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_n1O1O2416w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilli1648w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilOi1646w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlll0l858w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2626w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2621w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2609w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2606w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2564w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2629w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i2632w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00O2589w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01l2598w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01O2563w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01O2628w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01O2631w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0ii865w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0il2455w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0il866w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0il2496w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0il2449w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0il888w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0iO2513w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0iO2536w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0iO2456w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0iO2539w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0iO889w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2507w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2534w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2529w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2510w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2514w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2537w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li2540w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li890w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_w_lg_nilli1561w1568w1575w1576w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1569w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nilli1561w1562w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_n0001i2740w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_n1lli1498w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_n1O1O2083w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_n1Ol0i2743w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nii11i2011w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_niii1l2179w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_niii1O2185w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_niiO1l2180w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nil0i2075w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nil0l2067w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nil0O2065w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilii2063w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilil2061w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_niliO2059w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilli2089w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilll2087w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilOi2382w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlll0l845w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlll0O2741w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlllll2714w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00i855w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00l2568w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO00O2567w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01i2561w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01l2560w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO01O2569w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0ii2442w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0il883w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0iO882w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nlO0li881w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_w_lg_nlO0il883w2447w2448w2451w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nlO0iO2456w2460w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_w_lg_nilli1561w1568w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nillO_w_lg_nilli1561w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nilOl	:	STD_LOGIC := '0';
	 SIGNAL	nilOO	:	STD_LOGIC := '0';
	 SIGNAL	niO1i	:	STD_LOGIC := '0';
	 SIGNAL	nl1ll	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oi	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl1lO_PRN	:	STD_LOGIC;
	 SIGNAL	n0000i	:	STD_LOGIC := '0';
	 SIGNAL	n0000l	:	STD_LOGIC := '0';
	 SIGNAL	n0000O	:	STD_LOGIC := '0';
	 SIGNAL	n0001O	:	STD_LOGIC := '0';
	 SIGNAL	n00OlO	:	STD_LOGIC := '0';
	 SIGNAL	n00OOi	:	STD_LOGIC := '0';
	 SIGNAL	n00OOl	:	STD_LOGIC := '0';
	 SIGNAL	n00OOO	:	STD_LOGIC := '0';
	 SIGNAL	n0i0OO	:	STD_LOGIC := '0';
	 SIGNAL	n0i10i	:	STD_LOGIC := '0';
	 SIGNAL	n0i10l	:	STD_LOGIC := '0';
	 SIGNAL	n0i10O	:	STD_LOGIC := '0';
	 SIGNAL	n0i11i	:	STD_LOGIC := '0';
	 SIGNAL	n0i11l	:	STD_LOGIC := '0';
	 SIGNAL	n0i11O	:	STD_LOGIC := '0';
	 SIGNAL	n0i1ii	:	STD_LOGIC := '0';
	 SIGNAL	n0i1il	:	STD_LOGIC := '0';
	 SIGNAL	n0i1iO	:	STD_LOGIC := '0';
	 SIGNAL	n0i1li	:	STD_LOGIC := '0';
	 SIGNAL	n0i1ll	:	STD_LOGIC := '0';
	 SIGNAL	n0i1lO	:	STD_LOGIC := '0';
	 SIGNAL	n0i1Oi	:	STD_LOGIC := '0';
	 SIGNAL	n0ii0i	:	STD_LOGIC := '0';
	 SIGNAL	n0ii0l	:	STD_LOGIC := '0';
	 SIGNAL	n0ii0O	:	STD_LOGIC := '0';
	 SIGNAL	n0ii1i	:	STD_LOGIC := '0';
	 SIGNAL	n0ii1l	:	STD_LOGIC := '0';
	 SIGNAL	n0ii1O	:	STD_LOGIC := '0';
	 SIGNAL	n10ii	:	STD_LOGIC := '0';
	 SIGNAL	n10il	:	STD_LOGIC := '0';
	 SIGNAL	n10iO	:	STD_LOGIC := '0';
	 SIGNAL	n110i	:	STD_LOGIC := '0';
	 SIGNAL	n110l	:	STD_LOGIC := '0';
	 SIGNAL	n110O	:	STD_LOGIC := '0';
	 SIGNAL	n111l	:	STD_LOGIC := '0';
	 SIGNAL	n111O	:	STD_LOGIC := '0';
	 SIGNAL	n11ii	:	STD_LOGIC := '0';
	 SIGNAL	n11il	:	STD_LOGIC := '0';
	 SIGNAL	n11iO	:	STD_LOGIC := '0';
	 SIGNAL	n11li	:	STD_LOGIC := '0';
	 SIGNAL	n11ll	:	STD_LOGIC := '0';
	 SIGNAL	n1i1i	:	STD_LOGIC := '0';
	 SIGNAL	n1iOi	:	STD_LOGIC := '0';
	 SIGNAL	n1iOO	:	STD_LOGIC := '0';
	 SIGNAL	n1l0i	:	STD_LOGIC := '0';
	 SIGNAL	n1l0l	:	STD_LOGIC := '0';
	 SIGNAL	n1l1i	:	STD_LOGIC := '0';
	 SIGNAL	n1l1l	:	STD_LOGIC := '0';
	 SIGNAL	n1l1O	:	STD_LOGIC := '0';
	 SIGNAL	n1llO	:	STD_LOGIC := '0';
	 SIGNAL	niO0i	:	STD_LOGIC := '0';
	 SIGNAL	niO0l	:	STD_LOGIC := '0';
	 SIGNAL	niO0O	:	STD_LOGIC := '0';
	 SIGNAL	niO1l	:	STD_LOGIC := '0';
	 SIGNAL	niO1O	:	STD_LOGIC := '0';
	 SIGNAL	niOii	:	STD_LOGIC := '0';
	 SIGNAL	niOil	:	STD_LOGIC := '0';
	 SIGNAL	niOiO	:	STD_LOGIC := '0';
	 SIGNAL	niOli	:	STD_LOGIC := '0';
	 SIGNAL	niOll	:	STD_LOGIC := '0';
	 SIGNAL	niOlO	:	STD_LOGIC := '0';
	 SIGNAL	niOOi	:	STD_LOGIC := '0';
	 SIGNAL	niOOl	:	STD_LOGIC := '0';
	 SIGNAL	niOOO	:	STD_LOGIC := '0';
	 SIGNAL	nl10i	:	STD_LOGIC := '0';
	 SIGNAL	nl10l	:	STD_LOGIC := '0';
	 SIGNAL	nl10O	:	STD_LOGIC := '0';
	 SIGNAL	nl11i	:	STD_LOGIC := '0';
	 SIGNAL	nl11l	:	STD_LOGIC := '0';
	 SIGNAL	nl11O	:	STD_LOGIC := '0';
	 SIGNAL	nl1ii	:	STD_LOGIC := '0';
	 SIGNAL	nl1il	:	STD_LOGIC := '0';
	 SIGNAL	nl1iO	:	STD_LOGIC := '0';
	 SIGNAL	nl1li	:	STD_LOGIC := '0';
	 SIGNAL	nllil	:	STD_LOGIC := '0';
	 SIGNAL	nllli	:	STD_LOGIC := '0';
	 SIGNAL	nlO0ll	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlliO_w_lg_w_lg_n0i10O219w222w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0000l60w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n00OOi254w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n00OOO246w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i10i230w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i10O219w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i11l238w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i1il205w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i1li183w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i1lO168w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO210w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO188w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO256w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO248w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO240w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO232w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO224w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO170w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0000l72w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n00OlO253w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n00OOl245w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i10l218w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i11i237w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i11O229w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i1ii204w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i1iO182w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n0i1ll167w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n10ii771w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlliO_w_lg_n1iOO161w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n001Ol	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol0l	:	STD_LOGIC := '0';
	 SIGNAL	ni0l0l	:	STD_LOGIC := '0';
	 SIGNAL	nlllil	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlllii_w_lg_nlllil2715w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0001l	:	STD_LOGIC := '0';
	 SIGNAL	n1l0O	:	STD_LOGIC := '0';
	 SIGNAL	n1lii	:	STD_LOGIC := '0';
	 SIGNAL	n1lil	:	STD_LOGIC := '0';
	 SIGNAL	n1liO	:	STD_LOGIC := '0';
	 SIGNAL	nlllO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nllll_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nllll_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nllll_w_lg_w_lg_w_lg_n1liO362w363w364w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllll_w_lg_w_lg_n1liO362w363w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllll_w_lg_n1liO362w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n000O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n000O_w_lg_dataout274w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n001O_w_lg_dataout269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n00i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00iO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n00iO_w_lg_dataout280w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n00l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n00lO_w_lg_dataout287w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n00O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00OO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n00OO_w_lg_dataout295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0100l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01il_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n01il_w_lg_dataout1489w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01il_w_lg_dataout305w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n01ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01li_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n01li_w_lg_dataout260w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n01lO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n01lO_w_lg_dataout262w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n01lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n01OO_w_lg_dataout265w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n01OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0i1O_w_lg_dataout1481w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0ii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0l0ii_w_lg_w_lg_dataout862w2579w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l0ii_w_lg_dataout862w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Olii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Olil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni000i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni000l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni000O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni001l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni001O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0lii_w_lg_dataout2438w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0lil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0lil_w_lg_dataout2436w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lli_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0lli_w_lg_dataout2433w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0lll_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0lll_w_lg_dataout2431w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0llO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0llO_w_lg_dataout2429w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lOi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0lOi_w_lg_dataout2427w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0lOl_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0lOl_w_lg_w2434w2435w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0lOl_w2434w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0lOl_w_lg_w_lg_w_lg_w_lg_dataout2426w2428w2430w2432w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0lOl_w_lg_w_lg_w_lg_dataout2426w2428w2430w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0lOl_w_lg_w_lg_dataout2426w2428w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0lOl_w_lg_dataout2426w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niii1i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niii1i_w_lg_dataout2009w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n01iiO_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n01iiO_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_n01iiO_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n1ili_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n1ili_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n1ili_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni0lOO_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_ni0lOO_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_ni0lOO_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_ni1O0O_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1O0O_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1O0O_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1Oii_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni1Oii_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni1Oii_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni0OOl_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_ni0OOl_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_ni0OOl_o	:	STD_LOGIC;
	 SIGNAL  wire_n00i0l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00i0l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00i0l_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00ili_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00ili_o	:	STD_LOGIC;
	 SIGNAL  wire_n00ili_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00iOO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00iOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n00iOO_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00l0l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00l0l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00l0l_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00lli_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00lli_o	:	STD_LOGIC;
	 SIGNAL  wire_n00lli_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00lOO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00lOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n00lOO_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00O0l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00O0l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00O0l_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n00Oli_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00Oli_o	:	STD_LOGIC;
	 SIGNAL  wire_n00Oli_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n100i_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n100i_o	:	STD_LOGIC;
	 SIGNAL  wire_n100i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n100l_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n100l_o	:	STD_LOGIC;
	 SIGNAL  wire_n100l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n100O_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n100O_o	:	STD_LOGIC;
	 SIGNAL  wire_n100O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n101i_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n101i_o	:	STD_LOGIC;
	 SIGNAL  wire_n101i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n101l_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n101l_o	:	STD_LOGIC;
	 SIGNAL  wire_n101l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n101O_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n101O_o	:	STD_LOGIC;
	 SIGNAL  wire_n101O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n11lO_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n11lO_o	:	STD_LOGIC;
	 SIGNAL  wire_n11lO_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n11Oi_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n11Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_n11Oi_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n11Ol_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n11Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_n11Ol_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n11OO_data	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n11OO_o	:	STD_LOGIC;
	 SIGNAL  wire_n11OO_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0110i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0110i_o	:	STD_LOGIC;
	 SIGNAL  wire_n0110i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0110O_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0110O_o	:	STD_LOGIC;
	 SIGNAL  wire_n0110O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0111l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0111l_o	:	STD_LOGIC;
	 SIGNAL  wire_n0111l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011il_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n011il_o	:	STD_LOGIC;
	 SIGNAL  wire_n011il_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n011li_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011li_o	:	STD_LOGIC;
	 SIGNAL  wire_n011li_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n011lO_data	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n011lO_o	:	STD_LOGIC;
	 SIGNAL  wire_n011lO_sel	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OllO_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OllO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OllO_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OlOi_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OlOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OlOi_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1OlOO_data	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1OlOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OlOO_sel	:	STD_LOGIC_VECTOR (8 DOWNTO 0);
	 SIGNAL  wire_n1OO0i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OO0i_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO0i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OO0O_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n1OO0O_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO0O_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n1OO1l_data	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO1l_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO1l_sel	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO1O_data	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OO1O_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OO1O_sel	:	STD_LOGIC_VECTOR (12 DOWNTO 0);
	 SIGNAL  wire_n1OOii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOii_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOiO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOiO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOiO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOll_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1OOOO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOOO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOOO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni010i_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni010i_o	:	STD_LOGIC;
	 SIGNAL  wire_ni010i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni010l_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni010l_o	:	STD_LOGIC;
	 SIGNAL  wire_ni010l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni010O_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni010O_o	:	STD_LOGIC;
	 SIGNAL  wire_ni010O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni011i_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni011i_o	:	STD_LOGIC;
	 SIGNAL  wire_ni011i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni011O_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni011O_o	:	STD_LOGIC;
	 SIGNAL  wire_ni011O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_ni01iO_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_ni01iO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01iO_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_ni01ll_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni01ll_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01ll_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni01Oi_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_ni01Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01Oi_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_ni01OO_data	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni01OO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01OO_sel	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_ni1OOi_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1OOi_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1OOi_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1OOl_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1OOl_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1OOl_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1OOO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1OOO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1OOO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlili_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlili_o	:	STD_LOGIC;
	 SIGNAL  wire_nlili_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlill_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlill_o	:	STD_LOGIC;
	 SIGNAL  wire_nlill_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlilO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlilO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlilO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nliOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nliOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nliOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOil_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOil_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOil_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOiO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOiO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOiO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOli_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOli_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOli_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOlO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOlO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOlO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOOl_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOOl_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOOl_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOOOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOOOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1lOll206w209w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1O0Ol52w53w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1O11l184w187w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_GE_XAUI_SEL2752w2753w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1011l2772w2773w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w1988w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w1673w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w1678w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w1668w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w1663w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w1953w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_SYNC_SM_DIS876w877w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1l1iO867w868w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL2751w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l00l2548w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l00l848w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l01O850w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l10i2457w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l10l2454w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll0O255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llil247w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1llli239w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lllO231w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lO1O223w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lOll206w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O0Ol52w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O11l184w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O1li169w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1659w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1654w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1649w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH874w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1577w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1570w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1563w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1598w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1605w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1591w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH1584w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2384w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_SYNC_SM_DIS873w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_IB_INVALID_CODE_range2446w2452w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_IB_INVALID_CODE_range2453w2461w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_SIZE_range895w900w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_DISABLE_RX_DISP844w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_GE_XAUI_SEL2752w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1001l2475w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100lO2238w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100Oi2210w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n100OO2188w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1011i2824w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1011l2772w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1011O2750w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i0l2156w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10i1O2183w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iil1997w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iiO1996w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10ili1995w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10ill1994w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10ilO1993w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iOi1992w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iOl1991w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iOO1961w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l0i1957w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l0l1956w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l0O1955w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l1i1960w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l1l1959w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10l1O1958w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lli1926w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lll1924w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10llO1986w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lOi1930w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lOl1922w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10lOO1920w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O0l1871w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O0O1869w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10O1i1928w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10Oii1976w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10Oil1875w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OiO1867w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10Oli1865w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10Oll1873w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10OOO1816w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11lli2976w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11O0l2776w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11O0O2761w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oii2759w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11OiO2992w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oli2749w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oll2746w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i00l1881w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i00O1885w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01i1764w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01l2424w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01O1879w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0ii1890w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0il1896w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0iO1903w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0li1911w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0ll2414w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0Oi1824w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0OO1969w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i10i1812w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i10l1810w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i10O1818w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i11i1814w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i11l1951w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i11O1820w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1li1762w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1ll1760w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1lO1942w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1Oi1766w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1Ol1758w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i1OO1756w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ii0O1830w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ii1i1979w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ii1O1826w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiiO1835w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iilO1841w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiOi1848w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iiOl1856w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0i1642w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0l1776w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il0O1781w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1l2404w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1O1770w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilii1787w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilil1794w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iliO1802w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illl2394w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illO1611w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilOi1715w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilOl1608w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ilOO1935w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO0i1597w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO0l1595w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO0O1721w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO1i1604w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO1l1602w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iO1O1717w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOii1590w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOil1588w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOiO1726w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOli1583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOll1581w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOlO1732w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOOi1739w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1iOOl1747w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0ll842w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0lO774w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l10O879w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liii321w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liiO318w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lili316w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lill314w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1lilO312w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liOi310w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liOl308w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1liOO306w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1ll1i304w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O00O64w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O0ll54w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1O0OO65w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1Oi1O59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1OiiO39w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH131w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rcvd_clk43w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_soft_reset46w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_SYNC_SM_DIS876w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_SYNC_COMP_SIZE_range897w898w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1iO1i1604w1775w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1iO1i1604w1780w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1iO1i1604w1786w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1iO1i1604w1793w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1iO1i1604w1801w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w2020w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w2013w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH131w2004w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2020w2021w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2013w2014w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2004w2005w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2022w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2015w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2006w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2022w2023w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2015w2016w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2006w2007w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2022w2023w2024w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2015w2016w2017w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2006w2007w2008w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w852w853w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2054w2055w2056w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2046w2047w2048w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2038w2039w2040w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w2030w2031w2032w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w852w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2054w2055w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2046w2047w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2038w2039w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w2030w2031w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1l0il846w847w849w851w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2054w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2046w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2038w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w2030w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1l0il846w847w849w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH2051w2052w2053w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH2043w2044w2045w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH2035w2036w2037w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_PMADATAWIDTH2027w2028w2029w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1l0il846w847w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH2051w2052w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH2043w2044w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH2035w2036w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_PMADATAWIDTH2027w2028w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1000i2549w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1000i2464w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1000l2465w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01l1921w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i01l1978w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0ll1866w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1i0ll1968w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1l1811w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1il1l1944w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illl1934w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1illl1757w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l01i2468w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0ii2467w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0il2466w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0il846w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l10i2486w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l10l2485w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1iO867w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1ll860w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1lO861w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l1Ol857w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2113w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2105w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2097w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2088w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2051w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2043w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2035w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_PMADATAWIDTH2027w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n1000i :	STD_LOGIC;
	 SIGNAL  n1000l :	STD_LOGIC;
	 SIGNAL  n1000O :	STD_LOGIC;
	 SIGNAL  n1001i :	STD_LOGIC;
	 SIGNAL  n1001l :	STD_LOGIC;
	 SIGNAL  n1001O :	STD_LOGIC;
	 SIGNAL  n100ii :	STD_LOGIC;
	 SIGNAL  n100il :	STD_LOGIC;
	 SIGNAL  n100iO :	STD_LOGIC;
	 SIGNAL  n100li :	STD_LOGIC;
	 SIGNAL  n100ll :	STD_LOGIC;
	 SIGNAL  n100lO :	STD_LOGIC;
	 SIGNAL  n100Oi :	STD_LOGIC;
	 SIGNAL  n100Ol :	STD_LOGIC;
	 SIGNAL  n100OO :	STD_LOGIC;
	 SIGNAL  n1010i :	STD_LOGIC;
	 SIGNAL  n1010l :	STD_LOGIC;
	 SIGNAL  n1010O :	STD_LOGIC;
	 SIGNAL  n1011i :	STD_LOGIC;
	 SIGNAL  n1011l :	STD_LOGIC;
	 SIGNAL  n1011O :	STD_LOGIC;
	 SIGNAL  n101ii :	STD_LOGIC;
	 SIGNAL  n101il :	STD_LOGIC;
	 SIGNAL  n101iO :	STD_LOGIC;
	 SIGNAL  n101li :	STD_LOGIC;
	 SIGNAL  n101ll :	STD_LOGIC;
	 SIGNAL  n101lO :	STD_LOGIC;
	 SIGNAL  n101Oi :	STD_LOGIC;
	 SIGNAL  n101Ol :	STD_LOGIC;
	 SIGNAL  n101OO :	STD_LOGIC;
	 SIGNAL  n10i0i :	STD_LOGIC;
	 SIGNAL  n10i0l :	STD_LOGIC;
	 SIGNAL  n10i0O :	STD_LOGIC;
	 SIGNAL  n10i1i :	STD_LOGIC;
	 SIGNAL  n10i1l :	STD_LOGIC;
	 SIGNAL  n10i1O :	STD_LOGIC;
	 SIGNAL  n10iii :	STD_LOGIC;
	 SIGNAL  n10iil :	STD_LOGIC;
	 SIGNAL  n10iiO :	STD_LOGIC;
	 SIGNAL  n10ili :	STD_LOGIC;
	 SIGNAL  n10ill :	STD_LOGIC;
	 SIGNAL  n10ilO :	STD_LOGIC;
	 SIGNAL  n10iOi :	STD_LOGIC;
	 SIGNAL  n10iOl :	STD_LOGIC;
	 SIGNAL  n10iOO :	STD_LOGIC;
	 SIGNAL  n10l0i :	STD_LOGIC;
	 SIGNAL  n10l0l :	STD_LOGIC;
	 SIGNAL  n10l0O :	STD_LOGIC;
	 SIGNAL  n10l1i :	STD_LOGIC;
	 SIGNAL  n10l1l :	STD_LOGIC;
	 SIGNAL  n10l1O :	STD_LOGIC;
	 SIGNAL  n10lii :	STD_LOGIC;
	 SIGNAL  n10lil :	STD_LOGIC;
	 SIGNAL  n10liO :	STD_LOGIC;
	 SIGNAL  n10lli :	STD_LOGIC;
	 SIGNAL  n10lll :	STD_LOGIC;
	 SIGNAL  n10llO :	STD_LOGIC;
	 SIGNAL  n10lOi :	STD_LOGIC;
	 SIGNAL  n10lOl :	STD_LOGIC;
	 SIGNAL  n10lOO :	STD_LOGIC;
	 SIGNAL  n10O0i :	STD_LOGIC;
	 SIGNAL  n10O0l :	STD_LOGIC;
	 SIGNAL  n10O0O :	STD_LOGIC;
	 SIGNAL  n10O1i :	STD_LOGIC;
	 SIGNAL  n10O1l :	STD_LOGIC;
	 SIGNAL  n10O1O :	STD_LOGIC;
	 SIGNAL  n10Oii :	STD_LOGIC;
	 SIGNAL  n10Oil :	STD_LOGIC;
	 SIGNAL  n10OiO :	STD_LOGIC;
	 SIGNAL  n10Oli :	STD_LOGIC;
	 SIGNAL  n10Oll :	STD_LOGIC;
	 SIGNAL  n10OlO :	STD_LOGIC;
	 SIGNAL  n10OOi :	STD_LOGIC;
	 SIGNAL  n10OOl :	STD_LOGIC;
	 SIGNAL  n10OOO :	STD_LOGIC;
	 SIGNAL  n11lii :	STD_LOGIC;
	 SIGNAL  n11lil :	STD_LOGIC;
	 SIGNAL  n11liO :	STD_LOGIC;
	 SIGNAL  n11lli :	STD_LOGIC;
	 SIGNAL  n11lll :	STD_LOGIC;
	 SIGNAL  n11llO :	STD_LOGIC;
	 SIGNAL  n11lOi :	STD_LOGIC;
	 SIGNAL  n11lOl :	STD_LOGIC;
	 SIGNAL  n11lOO :	STD_LOGIC;
	 SIGNAL  n11O0i :	STD_LOGIC;
	 SIGNAL  n11O0l :	STD_LOGIC;
	 SIGNAL  n11O0O :	STD_LOGIC;
	 SIGNAL  n11O1i :	STD_LOGIC;
	 SIGNAL  n11O1l :	STD_LOGIC;
	 SIGNAL  n11O1O :	STD_LOGIC;
	 SIGNAL  n11Oii :	STD_LOGIC;
	 SIGNAL  n11Oil :	STD_LOGIC;
	 SIGNAL  n11OiO :	STD_LOGIC;
	 SIGNAL  n11Oli :	STD_LOGIC;
	 SIGNAL  n11Oll :	STD_LOGIC;
	 SIGNAL  n11OlO :	STD_LOGIC;
	 SIGNAL  n11OOi :	STD_LOGIC;
	 SIGNAL  n11OOl :	STD_LOGIC;
	 SIGNAL  n11OOO :	STD_LOGIC;
	 SIGNAL  n1i00i :	STD_LOGIC;
	 SIGNAL  n1i00l :	STD_LOGIC;
	 SIGNAL  n1i00O :	STD_LOGIC;
	 SIGNAL  n1i01i :	STD_LOGIC;
	 SIGNAL  n1i01l :	STD_LOGIC;
	 SIGNAL  n1i01O :	STD_LOGIC;
	 SIGNAL  n1i0ii :	STD_LOGIC;
	 SIGNAL  n1i0il :	STD_LOGIC;
	 SIGNAL  n1i0iO :	STD_LOGIC;
	 SIGNAL  n1i0li :	STD_LOGIC;
	 SIGNAL  n1i0ll :	STD_LOGIC;
	 SIGNAL  n1i0lO :	STD_LOGIC;
	 SIGNAL  n1i0Oi :	STD_LOGIC;
	 SIGNAL  n1i0Ol :	STD_LOGIC;
	 SIGNAL  n1i0OO :	STD_LOGIC;
	 SIGNAL  n1i10i :	STD_LOGIC;
	 SIGNAL  n1i10l :	STD_LOGIC;
	 SIGNAL  n1i10O :	STD_LOGIC;
	 SIGNAL  n1i11i :	STD_LOGIC;
	 SIGNAL  n1i11l :	STD_LOGIC;
	 SIGNAL  n1i11O :	STD_LOGIC;
	 SIGNAL  n1i1ii :	STD_LOGIC;
	 SIGNAL  n1i1il :	STD_LOGIC;
	 SIGNAL  n1i1iO :	STD_LOGIC;
	 SIGNAL  n1i1li :	STD_LOGIC;
	 SIGNAL  n1i1ll :	STD_LOGIC;
	 SIGNAL  n1i1lO :	STD_LOGIC;
	 SIGNAL  n1i1Oi :	STD_LOGIC;
	 SIGNAL  n1i1Ol :	STD_LOGIC;
	 SIGNAL  n1i1OO :	STD_LOGIC;
	 SIGNAL  n1ii0i :	STD_LOGIC;
	 SIGNAL  n1ii0l :	STD_LOGIC;
	 SIGNAL  n1ii0O :	STD_LOGIC;
	 SIGNAL  n1ii1i :	STD_LOGIC;
	 SIGNAL  n1ii1l :	STD_LOGIC;
	 SIGNAL  n1ii1O :	STD_LOGIC;
	 SIGNAL  n1iiii :	STD_LOGIC;
	 SIGNAL  n1iiil :	STD_LOGIC;
	 SIGNAL  n1iiiO :	STD_LOGIC;
	 SIGNAL  n1iili :	STD_LOGIC;
	 SIGNAL  n1iill :	STD_LOGIC;
	 SIGNAL  n1iilO :	STD_LOGIC;
	 SIGNAL  n1iiOi :	STD_LOGIC;
	 SIGNAL  n1iiOl :	STD_LOGIC;
	 SIGNAL  n1iiOO :	STD_LOGIC;
	 SIGNAL  n1il0i :	STD_LOGIC;
	 SIGNAL  n1il0l :	STD_LOGIC;
	 SIGNAL  n1il0O :	STD_LOGIC;
	 SIGNAL  n1il1i :	STD_LOGIC;
	 SIGNAL  n1il1l :	STD_LOGIC;
	 SIGNAL  n1il1O :	STD_LOGIC;
	 SIGNAL  n1ilii :	STD_LOGIC;
	 SIGNAL  n1ilil :	STD_LOGIC;
	 SIGNAL  n1iliO :	STD_LOGIC;
	 SIGNAL  n1illi :	STD_LOGIC;
	 SIGNAL  n1illl :	STD_LOGIC;
	 SIGNAL  n1illO :	STD_LOGIC;
	 SIGNAL  n1ilOi :	STD_LOGIC;
	 SIGNAL  n1ilOl :	STD_LOGIC;
	 SIGNAL  n1ilOO :	STD_LOGIC;
	 SIGNAL  n1iO0i :	STD_LOGIC;
	 SIGNAL  n1iO0l :	STD_LOGIC;
	 SIGNAL  n1iO0O :	STD_LOGIC;
	 SIGNAL  n1iO1i :	STD_LOGIC;
	 SIGNAL  n1iO1l :	STD_LOGIC;
	 SIGNAL  n1iO1O :	STD_LOGIC;
	 SIGNAL  n1iOii :	STD_LOGIC;
	 SIGNAL  n1iOil :	STD_LOGIC;
	 SIGNAL  n1iOiO :	STD_LOGIC;
	 SIGNAL  n1iOli :	STD_LOGIC;
	 SIGNAL  n1iOll :	STD_LOGIC;
	 SIGNAL  n1iOlO :	STD_LOGIC;
	 SIGNAL  n1iOOi :	STD_LOGIC;
	 SIGNAL  n1iOOl :	STD_LOGIC;
	 SIGNAL  n1iOOO :	STD_LOGIC;
	 SIGNAL  n1l00i :	STD_LOGIC;
	 SIGNAL  n1l00l :	STD_LOGIC;
	 SIGNAL  n1l00O :	STD_LOGIC;
	 SIGNAL  n1l01i :	STD_LOGIC;
	 SIGNAL  n1l01l :	STD_LOGIC;
	 SIGNAL  n1l01O :	STD_LOGIC;
	 SIGNAL  n1l0ii :	STD_LOGIC;
	 SIGNAL  n1l0il :	STD_LOGIC;
	 SIGNAL  n1l0iO :	STD_LOGIC;
	 SIGNAL  n1l0li :	STD_LOGIC;
	 SIGNAL  n1l0ll :	STD_LOGIC;
	 SIGNAL  n1l0lO :	STD_LOGIC;
	 SIGNAL  n1l0Oi :	STD_LOGIC;
	 SIGNAL  n1l0Ol :	STD_LOGIC;
	 SIGNAL  n1l10i :	STD_LOGIC;
	 SIGNAL  n1l10l :	STD_LOGIC;
	 SIGNAL  n1l10O :	STD_LOGIC;
	 SIGNAL  n1l11i :	STD_LOGIC;
	 SIGNAL  n1l11l :	STD_LOGIC;
	 SIGNAL  n1l11O :	STD_LOGIC;
	 SIGNAL  n1l1ii :	STD_LOGIC;
	 SIGNAL  n1l1il :	STD_LOGIC;
	 SIGNAL  n1l1iO :	STD_LOGIC;
	 SIGNAL  n1l1li :	STD_LOGIC;
	 SIGNAL  n1l1ll :	STD_LOGIC;
	 SIGNAL  n1l1lO :	STD_LOGIC;
	 SIGNAL  n1l1Oi :	STD_LOGIC;
	 SIGNAL  n1l1Ol :	STD_LOGIC;
	 SIGNAL  n1l1OO :	STD_LOGIC;
	 SIGNAL  n1li0i :	STD_LOGIC;
	 SIGNAL  n1li0O :	STD_LOGIC;
	 SIGNAL  n1li1l :	STD_LOGIC;
	 SIGNAL  n1li1O :	STD_LOGIC;
	 SIGNAL  n1liii :	STD_LOGIC;
	 SIGNAL  n1liil :	STD_LOGIC;
	 SIGNAL  n1liiO :	STD_LOGIC;
	 SIGNAL  n1lili :	STD_LOGIC;
	 SIGNAL  n1lill :	STD_LOGIC;
	 SIGNAL  n1lilO :	STD_LOGIC;
	 SIGNAL  n1liOi :	STD_LOGIC;
	 SIGNAL  n1liOl :	STD_LOGIC;
	 SIGNAL  n1liOO :	STD_LOGIC;
	 SIGNAL  n1ll0i :	STD_LOGIC;
	 SIGNAL  n1ll0l :	STD_LOGIC;
	 SIGNAL  n1ll0O :	STD_LOGIC;
	 SIGNAL  n1ll1i :	STD_LOGIC;
	 SIGNAL  n1ll1l :	STD_LOGIC;
	 SIGNAL  n1ll1O :	STD_LOGIC;
	 SIGNAL  n1llii :	STD_LOGIC;
	 SIGNAL  n1llil :	STD_LOGIC;
	 SIGNAL  n1lliO :	STD_LOGIC;
	 SIGNAL  n1llli :	STD_LOGIC;
	 SIGNAL  n1llll :	STD_LOGIC;
	 SIGNAL  n1lllO :	STD_LOGIC;
	 SIGNAL  n1llOi :	STD_LOGIC;
	 SIGNAL  n1lO0i :	STD_LOGIC;
	 SIGNAL  n1lO1O :	STD_LOGIC;
	 SIGNAL  n1lOll :	STD_LOGIC;
	 SIGNAL  n1lOlO :	STD_LOGIC;
	 SIGNAL  n1O00O :	STD_LOGIC;
	 SIGNAL  n1O0ll :	STD_LOGIC;
	 SIGNAL  n1O0lO :	STD_LOGIC;
	 SIGNAL  n1O0Oi :	STD_LOGIC;
	 SIGNAL  n1O0Ol :	STD_LOGIC;
	 SIGNAL  n1O0OO :	STD_LOGIC;
	 SIGNAL  n1O11l :	STD_LOGIC;
	 SIGNAL  n1O11O :	STD_LOGIC;
	 SIGNAL  n1O1li :	STD_LOGIC;
	 SIGNAL  n1O1ll :	STD_LOGIC;
	 SIGNAL  n1O1lO :	STD_LOGIC;
	 SIGNAL  n1O1Oi :	STD_LOGIC;
	 SIGNAL  n1Oi0i :	STD_LOGIC;
	 SIGNAL  n1Oi1O :	STD_LOGIC;
	 SIGNAL  n1Oiii :	STD_LOGIC;
	 SIGNAL  n1Oiil :	STD_LOGIC;
	 SIGNAL  n1OiiO :	STD_LOGIC;
	 SIGNAL  n1Oili :	STD_LOGIC;
	 SIGNAL  n1Ol1l :	STD_LOGIC;
	 SIGNAL  wire_w_IB_INVALID_CODE_range2446w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_IB_INVALID_CODE_range2453w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_SIZE_range895w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_SYNC_COMP_SIZE_range897w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_gnd <= '0';
	wire_w_lg_w_lg_n1lOll206w209w(0) <= wire_w_lg_n1lOll206w(0) AND wire_n1lO0l44_w_lg_q208w(0);
	wire_w_lg_w_lg_n1O0Ol52w53w(0) <= wire_w_lg_n1O0Ol52w(0) AND n1O0lO;
	wire_w_lg_w_lg_n1O11l184w187w(0) <= wire_w_lg_n1O11l184w(0) AND wire_n1lOOO36_w_lg_q186w(0);
	wire_w_lg_w_lg_GE_XAUI_SEL2752w2753w(0) <= wire_w_lg_GE_XAUI_SEL2752w(0) AND nlllil;
	wire_w_lg_w_lg_n1011l2772w2773w(0) <= wire_w_lg_n1011l2772w(0) AND n0001i;
	wire_w_lg_w_lg_PMADATAWIDTH131w1988w(0) <= wire_w_lg_PMADATAWIDTH131w(0) AND n1i01l;
	wire_w_lg_w_lg_PMADATAWIDTH131w1673w(0) <= wire_w_lg_PMADATAWIDTH131w(0) AND n1ii0l;
	wire_w_lg_w_lg_PMADATAWIDTH131w1678w(0) <= wire_w_lg_PMADATAWIDTH131w(0) AND n1ii1l;
	wire_w_lg_w_lg_PMADATAWIDTH131w1668w(0) <= wire_w_lg_PMADATAWIDTH131w(0) AND n1iiil;
	wire_w_lg_w_lg_PMADATAWIDTH131w1663w(0) <= wire_w_lg_PMADATAWIDTH131w(0) AND n1iill;
	wire_w_lg_w_lg_PMADATAWIDTH131w1953w(0) <= wire_w_lg_PMADATAWIDTH131w(0) AND n1il1l;
	wire_w_lg_w_lg_SYNC_SM_DIS876w877w(0) <= wire_w_lg_SYNC_SM_DIS876w(0) AND n0101l;
	wire_w_lg_w_lg_n1l1iO867w868w(0) <= wire_w_lg_n1l1iO867w(0) AND wire_n0l0ii_dataout;
	wire_w_lg_GE_XAUI_SEL2751w(0) <= GE_XAUI_SEL AND wire_w_lg_n1011O2750w(0);
	wire_w_lg_n1l00l2548w(0) <= n1l00l AND n101li;
	wire_w_lg_n1l00l848w(0) <= n1l00l AND n1l00i;
	wire_w_lg_n1l01O850w(0) <= n1l01O AND n1l01l;
	wire_w_lg_n1l10i2457w(0) <= n1l10i AND n1l1il;
	wire_w_lg_n1l10l2454w(0) <= n1l10l AND n1l1il;
	wire_w_lg_n1ll0O255w(0) <= n1ll0O AND wire_nlliO_w_lg_n00OOi254w(0);
	wire_w_lg_n1llil247w(0) <= n1llil AND wire_nlliO_w_lg_n00OOO246w(0);
	wire_w_lg_n1llli239w(0) <= n1llli AND wire_nlliO_w_lg_n0i11l238w(0);
	wire_w_lg_n1lllO231w(0) <= n1lllO AND wire_nlliO_w_lg_n0i10i230w(0);
	wire_w_lg_n1lO1O223w(0) <= n1lO1O AND wire_nlliO_w_lg_w_lg_n0i10O219w222w(0);
	wire_w_lg_n1lOll206w(0) <= n1lOll AND wire_nlliO_w_lg_n0i1il205w(0);
	wire_w_lg_n1O0Ol52w(0) <= n1O0Ol AND n1O0Oi;
	wire_w_lg_n1O11l184w(0) <= n1O11l AND wire_nlliO_w_lg_n0i1li183w(0);
	wire_w_lg_n1O1li169w(0) <= n1O1li AND wire_nlliO_w_lg_n0i1lO168w(0);
	wire_w_lg_PMADATAWIDTH1659w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w(0);
	wire_w_lg_PMADATAWIDTH1654w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_w_lg_nilli1648w1653w(0);
	wire_w_lg_PMADATAWIDTH1649w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_nilli1648w(0);
	wire_w_lg_PMADATAWIDTH874w(0) <= PMADATAWIDTH AND wire_w_lg_SYNC_SM_DIS873w(0);
	wire_w_lg_PMADATAWIDTH1577w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_w_lg_w_lg_w_lg_nilli1561w1568w1575w1576w(0);
	wire_w_lg_PMADATAWIDTH1570w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1569w(0);
	wire_w_lg_PMADATAWIDTH1563w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_w_lg_nilli1561w1562w(0);
	wire_w_lg_PMADATAWIDTH1598w(0) <= PMADATAWIDTH AND wire_w_lg_n1iO0i1597w(0);
	wire_w_lg_PMADATAWIDTH1605w(0) <= PMADATAWIDTH AND wire_w_lg_n1iO1i1604w(0);
	wire_w_lg_PMADATAWIDTH1591w(0) <= PMADATAWIDTH AND wire_w_lg_n1iOii1590w(0);
	wire_w_lg_PMADATAWIDTH1584w(0) <= PMADATAWIDTH AND wire_w_lg_n1iOli1583w(0);
	wire_w_lg_PMADATAWIDTH2384w(0) <= PMADATAWIDTH AND wire_nillO_w_lg_nilli2089w(0);
	wire_w_lg_SYNC_SM_DIS873w(0) <= SYNC_SM_DIS AND nllllO;
	wire_w_lg_w_IB_INVALID_CODE_range2446w2452w(0) <= wire_w_IB_INVALID_CODE_range2446w(0) AND wire_nillO_w_lg_w_lg_w_lg_w_lg_nlO0il883w2447w2448w2451w(0);
	wire_w_lg_w_IB_INVALID_CODE_range2453w2461w(0) <= wire_w_IB_INVALID_CODE_range2453w(0) AND wire_nillO_w_lg_w_lg_nlO0iO2456w2460w(0);
	wire_w_lg_w_SYNC_COMP_SIZE_range895w900w(0) <= wire_w_SYNC_COMP_SIZE_range895w(0) AND wire_w_lg_w_SYNC_COMP_SIZE_range897w898w(0);
	wire_w_lg_DISABLE_RX_DISP844w(0) <= NOT DISABLE_RX_DISP;
	wire_w_lg_GE_XAUI_SEL2752w(0) <= NOT GE_XAUI_SEL;
	wire_w_lg_n1001l2475w(0) <= NOT n1001l;
	wire_w_lg_n100lO2238w(0) <= NOT n100lO;
	wire_w_lg_n100Oi2210w(0) <= NOT n100Oi;
	wire_w_lg_n100OO2188w(0) <= NOT n100OO;
	wire_w_lg_n1011i2824w(0) <= NOT n1011i;
	wire_w_lg_n1011l2772w(0) <= NOT n1011l;
	wire_w_lg_n1011O2750w(0) <= NOT n1011O;
	wire_w_lg_n10i0l2156w(0) <= NOT n10i0l;
	wire_w_lg_n10i1O2183w(0) <= NOT n10i1O;
	wire_w_lg_n10iil1997w(0) <= NOT n10iil;
	wire_w_lg_n10iiO1996w(0) <= NOT n10iiO;
	wire_w_lg_n10ili1995w(0) <= NOT n10ili;
	wire_w_lg_n10ill1994w(0) <= NOT n10ill;
	wire_w_lg_n10ilO1993w(0) <= NOT n10ilO;
	wire_w_lg_n10iOi1992w(0) <= NOT n10iOi;
	wire_w_lg_n10iOl1991w(0) <= NOT n10iOl;
	wire_w_lg_n10iOO1961w(0) <= NOT n10iOO;
	wire_w_lg_n10l0i1957w(0) <= NOT n10l0i;
	wire_w_lg_n10l0l1956w(0) <= NOT n10l0l;
	wire_w_lg_n10l0O1955w(0) <= NOT n10l0O;
	wire_w_lg_n10l1i1960w(0) <= NOT n10l1i;
	wire_w_lg_n10l1l1959w(0) <= NOT n10l1l;
	wire_w_lg_n10l1O1958w(0) <= NOT n10l1O;
	wire_w_lg_n10lli1926w(0) <= NOT n10lli;
	wire_w_lg_n10lll1924w(0) <= NOT n10lll;
	wire_w_lg_n10llO1986w(0) <= NOT n10llO;
	wire_w_lg_n10lOi1930w(0) <= NOT n10lOi;
	wire_w_lg_n10lOl1922w(0) <= NOT n10lOl;
	wire_w_lg_n10lOO1920w(0) <= NOT n10lOO;
	wire_w_lg_n10O0l1871w(0) <= NOT n10O0l;
	wire_w_lg_n10O0O1869w(0) <= NOT n10O0O;
	wire_w_lg_n10O1i1928w(0) <= NOT n10O1i;
	wire_w_lg_n10Oii1976w(0) <= NOT n10Oii;
	wire_w_lg_n10Oil1875w(0) <= NOT n10Oil;
	wire_w_lg_n10OiO1867w(0) <= NOT n10OiO;
	wire_w_lg_n10Oli1865w(0) <= NOT n10Oli;
	wire_w_lg_n10Oll1873w(0) <= NOT n10Oll;
	wire_w_lg_n10OOO1816w(0) <= NOT n10OOO;
	wire_w_lg_n11lli2976w(0) <= NOT n11lli;
	wire_w_lg_n11O0l2776w(0) <= NOT n11O0l;
	wire_w_lg_n11O0O2761w(0) <= NOT n11O0O;
	wire_w_lg_n11Oii2759w(0) <= NOT n11Oii;
	wire_w_lg_n11OiO2992w(0) <= NOT n11OiO;
	wire_w_lg_n11Oli2749w(0) <= NOT n11Oli;
	wire_w_lg_n11Oll2746w(0) <= NOT n11Oll;
	wire_w_lg_n1i00l1881w(0) <= NOT n1i00l;
	wire_w_lg_n1i00O1885w(0) <= NOT n1i00O;
	wire_w_lg_n1i01i1764w(0) <= NOT n1i01i;
	wire_w_lg_n1i01l2424w(0) <= NOT n1i01l;
	wire_w_lg_n1i01O1879w(0) <= NOT n1i01O;
	wire_w_lg_n1i0ii1890w(0) <= NOT n1i0ii;
	wire_w_lg_n1i0il1896w(0) <= NOT n1i0il;
	wire_w_lg_n1i0iO1903w(0) <= NOT n1i0iO;
	wire_w_lg_n1i0li1911w(0) <= NOT n1i0li;
	wire_w_lg_n1i0ll2414w(0) <= NOT n1i0ll;
	wire_w_lg_n1i0Oi1824w(0) <= NOT n1i0Oi;
	wire_w_lg_n1i0OO1969w(0) <= NOT n1i0OO;
	wire_w_lg_n1i10i1812w(0) <= NOT n1i10i;
	wire_w_lg_n1i10l1810w(0) <= NOT n1i10l;
	wire_w_lg_n1i10O1818w(0) <= NOT n1i10O;
	wire_w_lg_n1i11i1814w(0) <= NOT n1i11i;
	wire_w_lg_n1i11l1951w(0) <= NOT n1i11l;
	wire_w_lg_n1i11O1820w(0) <= NOT n1i11O;
	wire_w_lg_n1i1li1762w(0) <= NOT n1i1li;
	wire_w_lg_n1i1ll1760w(0) <= NOT n1i1ll;
	wire_w_lg_n1i1lO1942w(0) <= NOT n1i1lO;
	wire_w_lg_n1i1Oi1766w(0) <= NOT n1i1Oi;
	wire_w_lg_n1i1Ol1758w(0) <= NOT n1i1Ol;
	wire_w_lg_n1i1OO1756w(0) <= NOT n1i1OO;
	wire_w_lg_n1ii0O1830w(0) <= NOT n1ii0O;
	wire_w_lg_n1ii1i1979w(0) <= NOT n1ii1i;
	wire_w_lg_n1ii1O1826w(0) <= NOT n1ii1O;
	wire_w_lg_n1iiiO1835w(0) <= NOT n1iiiO;
	wire_w_lg_n1iilO1841w(0) <= NOT n1iilO;
	wire_w_lg_n1iiOi1848w(0) <= NOT n1iiOi;
	wire_w_lg_n1iiOl1856w(0) <= NOT n1iiOl;
	wire_w_lg_n1il0i1642w(0) <= NOT n1il0i;
	wire_w_lg_n1il0l1776w(0) <= NOT n1il0l;
	wire_w_lg_n1il0O1781w(0) <= NOT n1il0O;
	wire_w_lg_n1il1l2404w(0) <= NOT n1il1l;
	wire_w_lg_n1il1O1770w(0) <= NOT n1il1O;
	wire_w_lg_n1ilii1787w(0) <= NOT n1ilii;
	wire_w_lg_n1ilil1794w(0) <= NOT n1ilil;
	wire_w_lg_n1iliO1802w(0) <= NOT n1iliO;
	wire_w_lg_n1illl2394w(0) <= NOT n1illl;
	wire_w_lg_n1illO1611w(0) <= NOT n1illO;
	wire_w_lg_n1ilOi1715w(0) <= NOT n1ilOi;
	wire_w_lg_n1ilOl1608w(0) <= NOT n1ilOl;
	wire_w_lg_n1ilOO1935w(0) <= NOT n1ilOO;
	wire_w_lg_n1iO0i1597w(0) <= NOT n1iO0i;
	wire_w_lg_n1iO0l1595w(0) <= NOT n1iO0l;
	wire_w_lg_n1iO0O1721w(0) <= NOT n1iO0O;
	wire_w_lg_n1iO1i1604w(0) <= NOT n1iO1i;
	wire_w_lg_n1iO1l1602w(0) <= NOT n1iO1l;
	wire_w_lg_n1iO1O1717w(0) <= NOT n1iO1O;
	wire_w_lg_n1iOii1590w(0) <= NOT n1iOii;
	wire_w_lg_n1iOil1588w(0) <= NOT n1iOil;
	wire_w_lg_n1iOiO1726w(0) <= NOT n1iOiO;
	wire_w_lg_n1iOli1583w(0) <= NOT n1iOli;
	wire_w_lg_n1iOll1581w(0) <= NOT n1iOll;
	wire_w_lg_n1iOlO1732w(0) <= NOT n1iOlO;
	wire_w_lg_n1iOOi1739w(0) <= NOT n1iOOi;
	wire_w_lg_n1iOOl1747w(0) <= NOT n1iOOl;
	wire_w_lg_n1l0ll842w(0) <= NOT n1l0ll;
	wire_w_lg_n1l0lO774w(0) <= NOT n1l0lO;
	wire_w_lg_n1l10O879w(0) <= NOT n1l10O;
	wire_w_lg_n1liii321w(0) <= NOT n1liii;
	wire_w_lg_n1liiO318w(0) <= NOT n1liiO;
	wire_w_lg_n1lili316w(0) <= NOT n1lili;
	wire_w_lg_n1lill314w(0) <= NOT n1lill;
	wire_w_lg_n1lilO312w(0) <= NOT n1lilO;
	wire_w_lg_n1liOi310w(0) <= NOT n1liOi;
	wire_w_lg_n1liOl308w(0) <= NOT n1liOl;
	wire_w_lg_n1liOO306w(0) <= NOT n1liOO;
	wire_w_lg_n1ll1i304w(0) <= NOT n1ll1i;
	wire_w_lg_n1O00O64w(0) <= NOT n1O00O;
	wire_w_lg_n1O0ll54w(0) <= NOT n1O0ll;
	wire_w_lg_n1O0OO65w(0) <= NOT n1O0OO;
	wire_w_lg_n1Oi1O59w(0) <= NOT n1Oi1O;
	wire_w_lg_n1OiiO39w(0) <= NOT n1OiiO;
	wire_w_lg_PMADATAWIDTH131w(0) <= NOT PMADATAWIDTH;
	wire_w_lg_rcvd_clk43w(0) <= NOT rcvd_clk;
	wire_w_lg_soft_reset46w(0) <= NOT soft_reset;
	wire_w_lg_SYNC_SM_DIS876w(0) <= NOT SYNC_SM_DIS;
	wire_w_lg_w_SYNC_COMP_SIZE_range897w898w(0) <= NOT wire_w_SYNC_COMP_SIZE_range897w(0);
	wire_w_lg_w_lg_n1iO1i1604w1775w(0) <= wire_w_lg_n1iO1i1604w(0) OR n1il0O;
	wire_w_lg_w_lg_n1iO1i1604w1780w(0) <= wire_w_lg_n1iO1i1604w(0) OR n1ilii;
	wire_w_lg_w_lg_n1iO1i1604w1786w(0) <= wire_w_lg_n1iO1i1604w(0) OR n1ilil;
	wire_w_lg_w_lg_n1iO1i1604w1793w(0) <= wire_w_lg_n1iO1i1604w(0) OR n1iliO;
	wire_w_lg_w_lg_n1iO1i1604w1801w(0) <= wire_w_lg_n1iO1i1604w(0) OR n1illi;
	wire_w_lg_w_lg_PMADATAWIDTH131w2020w(0) <= wire_w_lg_PMADATAWIDTH131w(0) OR nilii;
	wire_w_lg_w_lg_PMADATAWIDTH131w2013w(0) <= wire_w_lg_PMADATAWIDTH131w(0) OR nilil;
	wire_w_lg_w_lg_PMADATAWIDTH131w2004w(0) <= wire_w_lg_PMADATAWIDTH131w(0) OR niliO;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2020w2021w(0) <= wire_w_lg_w_lg_PMADATAWIDTH131w2020w(0) OR nil0O;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2013w2014w(0) <= wire_w_lg_w_lg_PMADATAWIDTH131w2013w(0) OR nilii;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2004w2005w(0) <= wire_w_lg_w_lg_PMADATAWIDTH131w2004w(0) OR nilil;
	wire_w2022w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2020w2021w(0) OR nil0l;
	wire_w2015w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2013w2014w(0) OR nil0O;
	wire_w2006w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH131w2004w2005w(0) OR nilii;
	wire_w_lg_w2022w2023w(0) <= wire_w2022w(0) OR nil0i;
	wire_w_lg_w2015w2016w(0) <= wire_w2015w(0) OR nil0l;
	wire_w_lg_w2006w2007w(0) <= wire_w2006w(0) OR nil0O;
	wire_w_lg_w_lg_w2022w2023w2024w(0) <= wire_w_lg_w2022w2023w(0) OR n1O1O;
	wire_w_lg_w_lg_w2015w2016w2017w(0) <= wire_w_lg_w2015w2016w(0) OR nil0i;
	wire_w_lg_w_lg_w2006w2007w2008w(0) <= wire_w_lg_w2006w2007w(0) OR nil0l;
	wire_w_lg_w852w853w(0) <= wire_w852w(0) OR n1l1OO;
	wire_w_lg_w_lg_w2054w2055w2056w(0) <= wire_w_lg_w2054w2055w(0) OR n1O1O;
	wire_w_lg_w_lg_w2046w2047w2048w(0) <= wire_w_lg_w2046w2047w(0) OR nil0i;
	wire_w_lg_w_lg_w2038w2039w2040w(0) <= wire_w_lg_w2038w2039w(0) OR nil0l;
	wire_w_lg_w_lg_w2030w2031w2032w(0) <= wire_w_lg_w2030w2031w(0) OR nil0O;
	wire_w852w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1l0il846w847w849w851w(0) OR n1l01i;
	wire_w_lg_w2054w2055w(0) <= wire_w2054w(0) OR nil0i;
	wire_w_lg_w2046w2047w(0) <= wire_w2046w(0) OR nil0l;
	wire_w_lg_w2038w2039w(0) <= wire_w2038w(0) OR nil0O;
	wire_w_lg_w2030w2031w(0) <= wire_w2030w(0) OR nilii;
	wire_w_lg_w_lg_w_lg_w_lg_n1l0il846w847w849w851w(0) <= wire_w_lg_w_lg_w_lg_n1l0il846w847w849w(0) OR wire_w_lg_n1l01O850w(0);
	wire_w2054w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH2051w2052w2053w(0) OR nil0l;
	wire_w2046w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH2043w2044w2045w(0) OR nil0O;
	wire_w2038w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH2035w2036w2037w(0) OR nilii;
	wire_w2030w(0) <= wire_w_lg_w_lg_w_lg_PMADATAWIDTH2027w2028w2029w(0) OR nilil;
	wire_w_lg_w_lg_w_lg_n1l0il846w847w849w(0) <= wire_w_lg_w_lg_n1l0il846w847w(0) OR wire_w_lg_n1l00l848w(0);
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH2051w2052w2053w(0) <= wire_w_lg_w_lg_PMADATAWIDTH2051w2052w(0) OR nil0O;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH2043w2044w2045w(0) <= wire_w_lg_w_lg_PMADATAWIDTH2043w2044w(0) OR nilii;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH2035w2036w2037w(0) <= wire_w_lg_w_lg_PMADATAWIDTH2035w2036w(0) OR nilil;
	wire_w_lg_w_lg_w_lg_PMADATAWIDTH2027w2028w2029w(0) <= wire_w_lg_w_lg_PMADATAWIDTH2027w2028w(0) OR niliO;
	wire_w_lg_w_lg_n1l0il846w847w(0) <= wire_w_lg_n1l0il846w(0) OR n1l00O;
	wire_w_lg_w_lg_PMADATAWIDTH2051w2052w(0) <= wire_w_lg_PMADATAWIDTH2051w(0) OR nilii;
	wire_w_lg_w_lg_PMADATAWIDTH2043w2044w(0) <= wire_w_lg_PMADATAWIDTH2043w(0) OR nilil;
	wire_w_lg_w_lg_PMADATAWIDTH2035w2036w(0) <= wire_w_lg_PMADATAWIDTH2035w(0) OR niliO;
	wire_w_lg_w_lg_PMADATAWIDTH2027w2028w(0) <= wire_w_lg_PMADATAWIDTH2027w(0) OR nilli;
	wire_w_lg_n1000i2549w(0) <= n1000i OR wire_w_lg_n1l00l2548w(0);
	wire_w_lg_n1000i2464w(0) <= n1000i OR n1001O;
	wire_w_lg_n1000l2465w(0) <= n1000l OR wire_w_lg_n1000i2464w(0);
	wire_w_lg_n1i01l1921w(0) <= n1i01l OR wire_w_lg_n10lOO1920w(0);
	wire_w_lg_n1i01l1978w(0) <= n1i01l OR wire_w_lg_n10O1i1928w(0);
	wire_w_lg_n1i0ll1866w(0) <= n1i0ll OR wire_w_lg_n10Oli1865w(0);
	wire_w_lg_n1i0ll1968w(0) <= n1i0ll OR wire_w_lg_n10Oll1873w(0);
	wire_w_lg_n1il1l1811w(0) <= n1il1l OR wire_w_lg_n1i10l1810w(0);
	wire_w_lg_n1il1l1944w(0) <= n1il1l OR wire_w_lg_n1i10O1818w(0);
	wire_w_lg_n1illl1934w(0) <= n1illl OR wire_w_lg_n1i01i1764w(0);
	wire_w_lg_n1illl1757w(0) <= n1illl OR wire_w_lg_n1i1OO1756w(0);
	wire_w_lg_n1l01i2468w(0) <= n1l01i OR wire_w_lg_n1l0ii2467w(0);
	wire_w_lg_n1l0ii2467w(0) <= n1l0ii OR wire_w_lg_n1l0il2466w(0);
	wire_w_lg_n1l0il2466w(0) <= n1l0il OR n1l00O;
	wire_w_lg_n1l0il846w(0) <= n1l0il OR n1l0ii;
	wire_w_lg_n1l10i2486w(0) <= n1l10i OR wire_w_lg_n1l10l2485w(0);
	wire_w_lg_n1l10l2485w(0) <= n1l10l OR n1001l;
	wire_w_lg_n1l1iO867w(0) <= n1l1iO OR wire_nillO_w_lg_nlO0il866w(0);
	wire_w_lg_n1l1ll860w(0) <= n1l1ll OR n1l1li;
	wire_w_lg_n1l1lO861w(0) <= n1l1lO OR wire_w_lg_n1l1ll860w(0);
	wire_w_lg_n1l1Ol857w(0) <= n1l1Ol OR wire_nillO_w_lg_w_lg_nlO00i855w856w(0);
	wire_w_lg_PMADATAWIDTH2113w(0) <= PMADATAWIDTH OR wire_nillO_w_lg_nilil2061w(0);
	wire_w_lg_PMADATAWIDTH2105w(0) <= PMADATAWIDTH OR wire_nillO_w_lg_niliO2059w(0);
	wire_w_lg_PMADATAWIDTH2097w(0) <= PMADATAWIDTH OR wire_nillO_w_lg_nilli2089w(0);
	wire_w_lg_PMADATAWIDTH2088w(0) <= PMADATAWIDTH OR wire_nillO_w_lg_nilll2087w(0);
	wire_w_lg_PMADATAWIDTH2051w(0) <= PMADATAWIDTH OR nilil;
	wire_w_lg_PMADATAWIDTH2043w(0) <= PMADATAWIDTH OR niliO;
	wire_w_lg_PMADATAWIDTH2035w(0) <= PMADATAWIDTH OR nilli;
	wire_w_lg_PMADATAWIDTH2027w(0) <= PMADATAWIDTH OR nilll;
	cg_comma <= nlll0O;
	n1000i <= ((n101ll AND n101li) OR (n101lO AND n101li));
	n1000l <= (n101ll AND n1l00i);
	n1000O <= (nlO0iO XOR nlO0ii);
	n1001i <= wire_nillO_w_lg_w_lg_nlO0il883w2495w(0);
	n1001l <= (wire_n0l0ii_w_lg_w_lg_dataout862w2579w(0) OR (wire_n0l0ii_dataout AND n1l00i));
	n1001O <= (n101ll AND n1l01l);
	n100ii <= (nlO0li AND (nlO0iO AND (nlO0il AND nlO0ii)));
	n100il <= ((((wire_nillO_w_lg_nlO0li881w(0) AND (nlO0iO AND n101Oi)) OR wire_nillO_w_lg_nlO0li2534w(0)) OR wire_nillO_w_lg_nlO0li2537w(0)) OR wire_nillO_w_lg_nlO0li2540w(0));
	n100iO <= (ni0l1i OR ni1O1i);
	n100li <= (ni0iOO OR ni0iOl);
	n100ll <= (ni0l1O OR ni0l1l);
	n100lO <= ((((ni0l0l OR ni0l0i) OR ni0l1O) OR ni0l1l) OR ni0l1i);
	n100Oi <= ((((ni0l0l OR ni0l0i) OR ni0iOO) OR ni0iOl) OR ni1O1i);
	n100Ol <= (ni0l0l OR ni0l0i);
	n100OO <= (wire_nillO_w_lg_niii1O2185w(0) AND wire_nillO_w_lg_niii1l2179w(0));
	n1010i <= (nlO01l AND nlO01i);
	n1010l <= wire_nillO_w_lg_w_lg_nlO01l2560w2562w(0);
	n1010O <= wire_nillO_w_lg_nlO01l2598w(0);
	n1011i <= (wire_nillO_w_lg_n0001i2740w(0) OR wire_nillO_w_lg_nlll0O2741w(0));
	n1011l <= (((GE_XAUI_SEL AND nlll0O) AND n1Ol0i) OR nlllil);
	n1011O <= (wire_nillO_w_lg_nlllll2714w(0) AND wire_nlllii_w_lg_nlllil2715w(0));
	n101ii <= wire_nillO_w_lg_w_lg_nlO01l2560w2597w(0);
	n101il <= (n1l01O AND n101li);
	n101iO <= (wire_nillO_w_lg_nlO00i855w(0) AND (wire_nillO_w_lg_nlO01O2569w(0) AND wire_nillO_w_lg_w_lg_nlO01l2560w2562w(0)));
	n101li <= (nlO00O AND nlO00l);
	n101ll <= (nlO00i AND (nlO01O AND (nlO01l AND nlO01i)));
	n101lO <= ((((wire_nillO_w_lg_nlO00i855w(0) AND (nlO01O AND n1010i)) OR wire_nillO_w_lg_nlO00i2626w(0)) OR wire_nillO_w_lg_nlO00i2629w(0)) OR wire_nillO_w_lg_nlO00i2632w(0));
	n101Oi <= (nlO0il AND nlO0ii);
	n101Ol <= wire_nillO_w_lg_w_lg_nlO0il883w2512w(0);
	n101OO <= wire_nillO_w_lg_nlO0il2496w(0);
	n10i0i <= (wire_nillO_w_lg_niiO1l2180w(0) AND niii1l);
	n10i0l <= ((((RUNDISP_SEL(0) OR RUNDISP_SEL(1)) OR RUNDISP_SEL(2)) OR RUNDISP_SEL(3)) OR RUNDISP_SEL(4));
	n10i0O <= ((wire_ni0lOl_w_lg_w2434w2435w(0) AND wire_ni0lil_w_lg_dataout2436w(0)) AND wire_ni0lii_w_lg_dataout2438w(0));
	n10i1i <= (wire_nillO_w_lg_niii1O2185w(0) AND niii1l);
	n10i1l <= (ni1lOO AND ni1lOl);
	n10i1O <= (wire_nillO_w_lg_niiO1l2180w(0) AND wire_nillO_w_lg_niii1l2179w(0));
	n10iii <= ((wire_ni0lOl_w_lg_w2434w2435w(0) AND wire_ni0lil_w_lg_dataout2436w(0)) AND wire_ni0lii_dataout);
	n10iil <= (((((((wire_w_lg_PMADATAWIDTH131w(0) OR wire_nillO_w_lg_nilil2061w(0)) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_nillO_w_lg_nil0l2067w(0)) OR wire_nillO_w_lg_nil0i2075w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10iiO <= (((((((wire_w_lg_PMADATAWIDTH131w(0) OR wire_nillO_w_lg_niliO2059w(0)) OR wire_nillO_w_lg_nilil2061w(0)) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_nillO_w_lg_nil0l2067w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10ili <= (((((((wire_w_lg_PMADATAWIDTH131w(0) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_nillO_w_lg_nil0l2067w(0)) OR wire_nillO_w_lg_nil0i2075w(0)) OR wire_nillO_w_lg_n1O1O2083w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10ill <= (((((((wire_w_lg_PMADATAWIDTH2088w(0) OR wire_nillO_w_lg_nilli2089w(0)) OR wire_nillO_w_lg_niliO2059w(0)) OR wire_nillO_w_lg_nilil2061w(0)) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10ilO <= (((((((wire_w_lg_PMADATAWIDTH2097w(0) OR wire_nillO_w_lg_niliO2059w(0)) OR wire_nillO_w_lg_nilil2061w(0)) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_nillO_w_lg_nil0l2067w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10iOi <= (((((((wire_w_lg_PMADATAWIDTH2105w(0) OR wire_nillO_w_lg_nilil2061w(0)) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_nillO_w_lg_nil0l2067w(0)) OR wire_nillO_w_lg_nil0i2075w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10iOl <= (((((((wire_w_lg_PMADATAWIDTH2113w(0) OR wire_nillO_w_lg_nilii2063w(0)) OR wire_nillO_w_lg_nil0O2065w(0)) OR wire_nillO_w_lg_nil0l2067w(0)) OR wire_nillO_w_lg_nil0i2075w(0)) OR wire_nillO_w_lg_n1O1O2083w(0)) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10iOO <= ((wire_w_lg_w_lg_w2015w2016w2017w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10l0i <= ((wire_w_lg_w_lg_w2038w2039w2040w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10l0l <= ((wire_w_lg_w_lg_w2046w2047w2048w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10l0O <= ((wire_w_lg_w_lg_w2054w2055w2056w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10l1i <= ((wire_w_lg_w_lg_w2006w2007w2008w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10l1l <= ((wire_w_lg_w_lg_w2022w2023w2024w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10l1O <= ((wire_w_lg_w_lg_w2030w2031w2032w(0) OR wire_niii1i_w_lg_dataout2009w(0)) OR wire_nillO_w_lg_nii11i2011w(0));
	n10lii <= ((((wire_w_lg_n10O1i1928w(0) OR wire_w_lg_n10lOO1920w(0)) OR wire_w_lg_n10lOi1930w(0)) OR wire_w_lg_n10lll1924w(0)) OR n10lil);
	n10lil <= ((((((((wire_nillO_w_lg_n1O1O2416w(0) AND wire_w_lg_n1i0li1911w(0)) AND wire_w_lg_n1i0iO1903w(0)) AND wire_w_lg_n1i0il1896w(0)) AND wire_w_lg_n1i0ii1890w(0)) AND wire_w_lg_n1i00O1885w(0)) AND wire_w_lg_n1i00l1881w(0)) AND wire_w_lg_n1i01O1879w(0)) AND wire_w_lg_n1i01l2424w(0));
	n10liO <= (((wire_w_lg_n1i01l1921w(0) OR wire_w_lg_n10lOl1922w(0)) OR wire_w_lg_n10lll1924w(0)) OR wire_w_lg_n10lli1926w(0));
	n10lli <= ((((((((n1ii1i OR wire_w_lg_n1i0li1911w(0)) OR n1i0iO) OR n1i0il) OR n1i0ii) OR n1i00O) OR n1i00l) OR n1i01O) OR n1i01l);
	n10lll <= (((((((n1ii1i OR wire_w_lg_n1i0iO1903w(0)) OR n1i0il) OR n1i0ii) OR n1i00O) OR n1i00l) OR n1i01O) OR n1i01l);
	n10llO <= ((((((n1ii1i OR wire_w_lg_n1i0il1896w(0)) OR n1i0ii) OR n1i00O) OR n1i00l) OR n1i01O) OR n1i01l);
	n10lOi <= (((((n1ii1i OR wire_w_lg_n1i0ii1890w(0)) OR n1i00O) OR n1i00l) OR n1i01O) OR n1i01l);
	n10lOl <= ((((n1ii1i OR wire_w_lg_n1i00O1885w(0)) OR n1i00l) OR n1i01O) OR n1i01l);
	n10lOO <= (((n1ii1i OR wire_w_lg_n1i00l1881w(0)) OR n1i01O) OR n1i01l);
	n10O0i <= (((wire_w_lg_n1i0ll1866w(0) OR wire_w_lg_n10OiO1867w(0)) OR wire_w_lg_n10O0O1869w(0)) OR wire_w_lg_n10O0l1871w(0));
	n10O0l <= ((((((((wire_w_lg_n1iiOl1856w(0) OR n1iiOi) OR n1iilO) OR n1iiiO) OR n1ii0O) OR n1ii1O) OR n1i0OO) OR n1i0Oi) OR n1i0ll);
	n10O0O <= (((((((wire_w_lg_n1iiOi1848w(0) OR n1iilO) OR n1iiiO) OR n1ii0O) OR n1ii1O) OR n1i0OO) OR n1i0Oi) OR n1i0ll);
	n10O1i <= (wire_w_lg_n1i01O1879w(0) OR n1i01l);
	n10O1l <= ((((wire_w_lg_n10Oll1873w(0) OR wire_w_lg_n10Oli1865w(0)) OR wire_w_lg_n10Oil1875w(0)) OR wire_w_lg_n10O0O1869w(0)) OR n10O1O);
	n10O1O <= ((((((((((n1il1i OR n1iiOO) AND wire_w_lg_n1iiOl1856w(0)) AND wire_w_lg_n1iiOi1848w(0)) AND wire_w_lg_n1iilO1841w(0)) AND wire_w_lg_n1iiiO1835w(0)) AND wire_w_lg_n1ii0O1830w(0)) AND wire_w_lg_n1ii1O1826w(0)) AND wire_w_lg_n1i0OO1969w(0)) AND wire_w_lg_n1i0Oi1824w(0)) AND wire_w_lg_n1i0ll2414w(0));
	n10Oii <= ((((((wire_w_lg_n1iilO1841w(0) OR n1iiiO) OR n1ii0O) OR n1ii1O) OR n1i0OO) OR n1i0Oi) OR n1i0ll);
	n10Oil <= (((((wire_w_lg_n1iiiO1835w(0) OR n1ii0O) OR n1ii1O) OR n1i0OO) OR n1i0Oi) OR n1i0ll);
	n10OiO <= ((((wire_w_lg_n1ii0O1830w(0) OR n1ii1O) OR n1i0OO) OR n1i0Oi) OR n1i0ll);
	n10Oli <= (((wire_w_lg_n1ii1O1826w(0) OR n1i0OO) OR n1i0Oi) OR n1i0ll);
	n10Oll <= (wire_w_lg_n1i0Oi1824w(0) OR n1i0ll);
	n10OlO <= ((((wire_w_lg_n1i10O1818w(0) OR wire_w_lg_n1i10l1810w(0)) OR wire_w_lg_n1i11O1820w(0)) OR wire_w_lg_n1i11i1814w(0)) OR n10OOi);
	n10OOi <= ((wire_nillO_w_lg_w_lg_w_lg_w2399w2400w2401w2402w(0) AND wire_w_lg_n1il1O1770w(0)) AND wire_w_lg_n1il1l2404w(0));
	n10OOl <= (((wire_w_lg_n1il1l1811w(0) OR wire_w_lg_n1i10i1812w(0)) OR wire_w_lg_n1i11i1814w(0)) OR wire_w_lg_n10OOO1816w(0));
	n10OOO <= (((((((wire_w_lg_w_lg_n1iO1i1604w1801w(0) OR wire_w_lg_n1iliO1802w(0)) OR wire_w_lg_n1ilil1794w(0)) OR wire_w_lg_n1ilii1787w(0)) OR wire_w_lg_n1il0O1781w(0)) OR wire_w_lg_n1il0l1776w(0)) OR n1il1O) OR n1il1l);
	n11lii <= ((((((n001Ol OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001iO) OR n001il);
	n11lil <= ((((n001Ol OR n001Oi) OR n001lO) OR n001li) OR n001iO);
	n11liO <= ((((((((((n001Ol OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001iO) OR n001il) OR n001ii) OR n0010O) OR n0010l) OR n0010i);
	n11lli <= ((((((((((n001Ol OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001iO) OR n001il) OR n001ii) OR n0010O) OR n0011O) OR n1Olll);
	n11lll <= (((((((((n001Ol OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001iO) OR n001il) OR n0010l) OR n0010i) OR n0011O);
	n11llO <= ((((((((((n001Ol OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001iO) OR n001il) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11lOi <= ((((((((((n001Ol OR n001Oi) OR n001lO) OR n001ll) OR n001li) OR n001iO) OR n001ii) OR n0010O) OR n0010l) OR n0011O) OR n1Olll);
	n11lOl <= (((((((((n001Ol OR n001Oi) OR n001lO) OR n001li) OR n001iO) OR n001ii) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11lOO <= ((((((((((n001Ol OR n001Oi) OR n001ll) OR n001li) OR n001il) OR n001ii) OR n0010O) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11O0i <= ((((((((((n001lO OR n001ll) OR n001li) OR n001iO) OR n001il) OR n001ii) OR n0010O) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11O0l <= (wire_w_lg_w_lg_n1011l2772w2773w(0) AND (n1Olli AND n1Ol0O));
	n11O0O <= (n1011l AND n0001i);
	n11O1i <= ((((((((((n001Ol OR n001lO) OR n001ll) OR n001iO) OR n001il) OR n001ii) OR n0010O) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11O1l <= (((((((((n001Ol OR n001Oi) OR n001li) OR n001il) OR n001ii) OR n0010O) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11O1O <= (((((((((n001Ol OR n001ll) OR n001iO) OR n001il) OR n001ii) OR n0010O) OR n0010l) OR n0010i) OR n0011O) OR n1Olll);
	n11Oii <= (n11OOi OR n11Oll);
	n11Oil <= (wire_nillO_w_lg_n0001i2740w(0) OR n11OOO);
	n11OiO <= (n1011l OR wire_nillO_w_lg_n0001i2740w(0));
	n11Oli <= (n0001i AND (wire_nillO_w_lg_n1Ol0i2743w(0) AND nlll0O));
	n11Oll <= (n0001i AND (wire_w_lg_GE_XAUI_SEL2752w(0) AND nlll0O));
	n11OlO <= (n0001i AND n11OOi);
	n11OOi <= (GE_XAUI_SEL AND n1011O);
	n11OOl <= (wire_nillO_w_lg_n0001i2740w(0) OR n11OOO);
	n11OOO <= (wire_w_lg_GE_XAUI_SEL2751w(0) OR wire_w_lg_w_lg_GE_XAUI_SEL2752w2753w(0));
	n1i00i <= ((((((((nilll AND nilli) AND niliO) AND nilil) AND nilii) AND nil0O) AND nil0l) AND nil0i) AND n1O1O);
	n1i00l <= ((((((niliO AND nilil) AND nilii) AND nil0O) AND nil0l) AND nil0i) AND n1O1O);
	n1i00O <= (((((nilil AND nilii) AND nil0O) AND nil0l) AND nil0i) AND n1O1O);
	n1i01i <= (wire_w_lg_n1ilOi1715w(0) OR n1illl);
	n1i01l <= (wire_w_lg_PMADATAWIDTH131w(0) AND n1i0lO);
	n1i01O <= (wire_w_lg_PMADATAWIDTH131w(0) AND n1i00i);
	n1i0ii <= ((((nilii AND nil0O) AND nil0l) AND nil0i) AND n1O1O);
	n1i0il <= (((nil0O AND nil0l) AND nil0i) AND n1O1O);
	n1i0iO <= ((nil0l AND nil0i) AND n1O1O);
	n1i0li <= (nil0i AND n1O1O);
	n1i0ll <= (wire_w_lg_PMADATAWIDTH131w(0) AND n1i0lO);
	n1i0lO <= ((((((wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) AND nilil) AND nilii) AND nil0O) AND nil0l) AND nil0i) AND n1O1O);
	n1i0Oi <= (wire_w_lg_PMADATAWIDTH131w(0) AND n1i0Ol);
	n1i0Ol <= (((((wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) AND nilil) AND nilii) AND nil0O) AND nil0l) AND nil0i);
	n1i0OO <= (wire_w_lg_w_lg_PMADATAWIDTH131w1678w(0) OR (PMADATAWIDTH AND n1ii1i));
	n1i10i <= (((wire_w_lg_w_lg_n1iO1i1604w1775w(0) OR wire_w_lg_n1il0l1776w(0)) OR n1il1O) OR n1il1l);
	n1i10l <= (((wire_w_lg_n1iO1i1604w(0) OR n1il0l) OR n1il1O) OR n1il1l);
	n1i10O <= (wire_w_lg_n1il1O1770w(0) OR n1il1l);
	n1i11i <= ((((((wire_w_lg_w_lg_n1iO1i1604w1793w(0) OR wire_w_lg_n1ilil1794w(0)) OR wire_w_lg_n1ilii1787w(0)) OR wire_w_lg_n1il0O1781w(0)) OR wire_w_lg_n1il0l1776w(0)) OR n1il1O) OR n1il1l);
	n1i11l <= (((((wire_w_lg_w_lg_n1iO1i1604w1786w(0) OR wire_w_lg_n1ilii1787w(0)) OR wire_w_lg_n1il0O1781w(0)) OR wire_w_lg_n1il0l1776w(0)) OR n1il1O) OR n1il1l);
	n1i11O <= ((((wire_w_lg_w_lg_n1iO1i1604w1780w(0) OR wire_w_lg_n1il0O1781w(0)) OR wire_w_lg_n1il0l1776w(0)) OR n1il1O) OR n1il1l);
	n1i1ii <= ((((wire_w_lg_n1i01i1764w(0) OR wire_w_lg_n1i1OO1756w(0)) OR wire_w_lg_n1i1Oi1766w(0)) OR wire_w_lg_n1i1ll1760w(0)) OR n1i1il);
	n1i1il <= (((((((((((wire_w_lg_PMADATAWIDTH131w(0) AND wire_nillO_w_lg_nilOi2382w(0)) OR wire_w_lg_PMADATAWIDTH2384w(0)) AND wire_w_lg_n1iOOl1747w(0)) AND wire_w_lg_n1iOOi1739w(0)) AND wire_w_lg_n1iOlO1732w(0)) AND wire_w_lg_n1iOiO1726w(0)) AND wire_w_lg_n1iO0O1721w(0)) AND wire_w_lg_n1iO1O1717w(0)) AND wire_w_lg_n1ilOO1935w(0)) AND wire_w_lg_n1ilOi1715w(0)) AND wire_w_lg_n1illl2394w(0));
	n1i1iO <= (((wire_w_lg_n1illl1757w(0) OR wire_w_lg_n1i1Ol1758w(0)) OR wire_w_lg_n1i1ll1760w(0)) OR wire_w_lg_n1i1li1762w(0));
	n1i1li <= ((((((((wire_w_lg_n1iOOl1747w(0) OR n1iOOi) OR n1iOlO) OR n1iOiO) OR n1iO0O) OR n1iO1O) OR n1ilOO) OR n1ilOi) OR n1illl);
	n1i1ll <= (((((((wire_w_lg_n1iOOi1739w(0) OR n1iOlO) OR n1iOiO) OR n1iO0O) OR n1iO1O) OR n1ilOO) OR n1ilOi) OR n1illl);
	n1i1lO <= ((((((wire_w_lg_n1iOlO1732w(0) OR n1iOiO) OR n1iO0O) OR n1iO1O) OR n1ilOO) OR n1ilOi) OR n1illl);
	n1i1Oi <= (((((wire_w_lg_n1iOiO1726w(0) OR n1iO0O) OR n1iO1O) OR n1ilOO) OR n1ilOi) OR n1illl);
	n1i1Ol <= ((((wire_w_lg_n1iO0O1721w(0) OR n1iO1O) OR n1ilOO) OR n1ilOi) OR n1illl);
	n1i1OO <= (((wire_w_lg_n1iO1O1717w(0) OR n1ilOO) OR n1ilOi) OR n1illl);
	n1ii0i <= (((wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w(0) AND nil0O) AND nil0l) AND nil0i);
	n1ii0l <= (((wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) AND nilil) AND nilii) AND nil0O);
	n1ii0O <= (wire_w_lg_w_lg_PMADATAWIDTH131w1668w(0) OR (PMADATAWIDTH AND n1iiii));
	n1ii1i <= ((((wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w(0) AND nil0O) AND nil0l) AND nil0i) AND n1O1O);
	n1ii1l <= ((((wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) AND nilil) AND nilii) AND nil0O) AND nil0l);
	n1ii1O <= (wire_w_lg_w_lg_PMADATAWIDTH131w1673w(0) OR (PMADATAWIDTH AND n1ii0i));
	n1iiii <= ((wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w(0) AND nil0O) AND nil0l);
	n1iiil <= ((wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) AND nilil) AND nilii);
	n1iiiO <= (wire_w_lg_w_lg_PMADATAWIDTH131w1663w(0) OR (PMADATAWIDTH AND n1iili));
	n1iili <= (wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w(0) AND nil0O);
	n1iill <= (wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) AND nilil);
	n1iilO <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0)) OR wire_w_lg_PMADATAWIDTH1659w(0));
	n1iiOi <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_nillO_w_lg_w_lg_nilOi1646w1651w(0)) OR wire_w_lg_PMADATAWIDTH1654w(0));
	n1iiOl <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_nillO_w_lg_nilOi1646w(0)) OR wire_w_lg_PMADATAWIDTH1649w(0));
	n1iiOO <= (PMADATAWIDTH AND nilli);
	n1il0i <= ((((((((nilll OR nilli) OR niliO) OR nilil) OR nilii) OR nil0O) OR nil0l) OR nil0i) OR n1O1O);
	n1il0l <= ((((((niliO OR nilil) OR nilii) OR nil0O) OR nil0l) OR nil0i) OR n1O1O);
	n1il0O <= (((((nilil OR nilii) OR nil0O) OR nil0l) OR nil0i) OR n1O1O);
	n1il1i <= (wire_w_lg_PMADATAWIDTH131w(0) AND nilOi);
	n1il1l <= (wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1illO1611w(0));
	n1il1O <= (wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1il0i1642w(0));
	n1ilii <= ((((nilii OR nil0O) OR nil0l) OR nil0i) OR n1O1O);
	n1ilil <= (((nil0O OR nil0l) OR nil0i) OR n1O1O);
	n1iliO <= ((nil0l OR nil0i) OR n1O1O);
	n1illi <= (nil0i OR n1O1O);
	n1illl <= (wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1illO1611w(0));
	n1illO <= (((((((((nilOi OR nilll) OR nilli) OR niliO) OR nilil) OR nilii) OR nil0O) OR nil0l) OR nil0i) OR n1O1O);
	n1ilOi <= (wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1ilOl1608w(0));
	n1ilOl <= ((((((((nilOi OR nilll) OR nilli) OR niliO) OR nilil) OR nilii) OR nil0O) OR nil0l) OR nil0i);
	n1ilOO <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1iO1l1602w(0)) OR wire_w_lg_PMADATAWIDTH1605w(0));
	n1iO0i <= (((wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w(0) OR nil0O) OR nil0l) OR nil0i);
	n1iO0l <= ((((((nilOi OR nilll) OR nilli) OR niliO) OR nilil) OR nilii) OR nil0O);
	n1iO0O <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1iOil1588w(0)) OR wire_w_lg_PMADATAWIDTH1591w(0));
	n1iO1i <= ((((wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w(0) OR nil0O) OR nil0l) OR nil0i) OR n1O1O);
	n1iO1l <= (((((((nilOi OR nilll) OR nilli) OR niliO) OR nilil) OR nilii) OR nil0O) OR nil0l);
	n1iO1O <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1iO0l1595w(0)) OR wire_w_lg_PMADATAWIDTH1598w(0));
	n1iOii <= ((wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w(0) OR nil0O) OR nil0l);
	n1iOil <= (((((nilOi OR nilll) OR nilli) OR niliO) OR nilil) OR nilii);
	n1iOiO <= ((wire_w_lg_PMADATAWIDTH131w(0) AND wire_w_lg_n1iOll1581w(0)) OR wire_w_lg_PMADATAWIDTH1584w(0));
	n1iOli <= (wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w(0) OR nil0O);
	n1iOll <= ((((nilOi OR nilll) OR nilli) OR niliO) OR nilil);
	n1iOlO <= ((wire_w_lg_PMADATAWIDTH131w(0) AND (NOT (((nilOi OR nilll) OR nilli) OR niliO))) OR wire_w_lg_PMADATAWIDTH1577w(0));
	n1iOOi <= ((wire_w_lg_PMADATAWIDTH131w(0) AND (NOT ((nilOi OR nilll) OR nilli))) OR wire_w_lg_PMADATAWIDTH1570w(0));
	n1iOOl <= ((wire_w_lg_PMADATAWIDTH131w(0) AND (NOT (nilOi OR nilll))) OR wire_w_lg_PMADATAWIDTH1563w(0));
	n1iOOO <= ((((((((((NOT ((NOT SYNC_COMP_PAT(0)) XOR nlO01i)) AND (NOT ((NOT SYNC_COMP_PAT(1)) XOR nlO01l))) AND (NOT ((NOT SYNC_COMP_PAT(2)) XOR nlO01O))) AND (NOT ((NOT SYNC_COMP_PAT(3)) XOR nlO00i))) AND (NOT ((NOT SYNC_COMP_PAT(4)) XOR nlO00l))) AND (NOT ((NOT SYNC_COMP_PAT(5)) XOR nlO00O))) AND (NOT ((NOT SYNC_COMP_PAT(6)) XOR nlO0ii))) AND (NOT ((NOT SYNC_COMP_PAT(7)) XOR nlO0il))) AND (NOT ((NOT SYNC_COMP_PAT(8)) XOR nlO0iO))) AND (NOT ((NOT SYNC_COMP_PAT(9)) XOR nlO0li)));
	n1l00i <= (wire_nillO_w_lg_nlO00O2567w(0) AND wire_nillO_w_lg_nlO00l2568w(0));
	n1l00l <= ((((((wire_nillO_w_lg_nlO00i855w(0) AND (wire_nillO_w_lg_nlO01O2569w(0) AND (nlO01l AND nlO01i))) OR (wire_nillO_w_lg_nlO00i855w(0) AND (nlO01O AND n101ii))) OR (wire_nillO_w_lg_nlO00i855w(0) AND (nlO01O AND n1010O))) OR wire_nillO_w_lg_nlO00i2606w(0)) OR wire_nillO_w_lg_nlO00i2609w(0)) OR wire_nillO_w_lg_nlO00i2564w(0));
	n1l00O <= (n1l01O AND n1l00i);
	n1l01i <= (n101iO AND n101li);
	n1l01l <= (wire_nillO_w_lg_w_lg_nlO00O2567w2588w(0) OR wire_nillO_w_lg_nlO00O2589w(0));
	n1l01O <= ((((wire_nillO_w_lg_nlO00i855w(0) AND (wire_nillO_w_lg_nlO01O2569w(0) AND wire_nillO_w_lg_w_lg_nlO01l2560w2597w(0))) OR (wire_nillO_w_lg_nlO00i855w(0) AND (wire_nillO_w_lg_nlO01O2569w(0) AND wire_nillO_w_lg_nlO01l2598w(0)))) OR (wire_nillO_w_lg_nlO00i855w(0) AND (nlO01O AND n1010l))) OR wire_nillO_w_lg_nlO00i2621w(0));
	n1l0ii <= (n101iO AND n1l01l);
	n1l0il <= (n101iO AND n1l00i);
	n1l0iO <= (PMADATAWIDTH AND wire_w_lg_n1l0ll842w(0));
	n1l0li <= (n1lli AND (PMADATAWIDTH AND n1lll));
	n1l0ll <= (n1lll AND n1lli);
	n1l0lO <= (n1l0Ol OR n1l0Oi);
	n1l0Oi <= (n1lll AND wire_nillO_w_lg_n1lli1498w(0));
	n1l0Ol <= (n1lll AND n1lli);
	n1l10i <= (wire_nillO_w_lg_nlO00O2567w(0) AND (wire_nillO_w_lg_nlO00l2568w(0) AND (wire_nillO_w_lg_nlO00i855w(0) AND (wire_nillO_w_lg_nlO01O2569w(0) AND (nlO01l AND nlO01i)))));
	n1l10l <= (nlO00O AND (nlO00l AND wire_nillO_w_lg_nlO00i2564w(0)));
	n1l10O <= ((NOT (wire_w_lg_w_IB_INVALID_CODE_range2446w2452w(0) OR wire_w_lg_w_IB_INVALID_CODE_range2453w2461w(0))) AND ((NOT (wire_w_lg_n1000l2465w(0) OR wire_w_lg_n1l01i2468w(0))) AND (NOT (((n100ii OR n1l1li) OR ((NOT (((n1l10l OR n1l10i) OR n1l11l) OR n1l11O)) AND (wire_w_lg_n1001l2475w(0) AND (wire_nillO_w_lg_w_lg_nlO0ii2442w2476w(0) OR (nlO0ii AND n1l1ll))))) OR ((wire_nillO_w_lg_w_lg_nlO0li881w2482w(0) OR (nlO0li AND n1l1ll)) AND wire_w_lg_n1l10i2486w(0))))));
	n1l11i <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR nlO01i)) AND (NOT (SYNC_COMP_PAT(1) XOR nlO01l))) AND (NOT (SYNC_COMP_PAT(2) XOR nlO01O))) AND (NOT (SYNC_COMP_PAT(3) XOR nlO00i))) AND (NOT (SYNC_COMP_PAT(4) XOR nlO00l))) AND (NOT (SYNC_COMP_PAT(5) XOR nlO00O))) AND (NOT (SYNC_COMP_PAT(6) XOR nlO0ii))) AND (NOT (SYNC_COMP_PAT(7) XOR nlO0il))) AND (NOT (SYNC_COMP_PAT(8) XOR nlO0iO))) AND (NOT (SYNC_COMP_PAT(9) XOR nlO0li)));
	n1l11l <= (nlO00O AND (wire_nillO_w_lg_nlO00l2568w(0) AND n1l01O));
	n1l11O <= (wire_nillO_w_lg_nlO00O2567w(0) AND (nlO00l AND n101lO));
	n1l1ii <= (wire_w_lg_DISABLE_RX_DISP844w(0) AND ((((wire_nillO_w_lg_nlll0l845w(0) AND wire_w_lg_w852w853w(0)) OR wire_nillO_w_lg_nlll0l858w(0)) OR (wire_w_lg_n1l1lO861w(0) AND wire_n0l0ii_w_lg_dataout862w(0))) OR wire_w_lg_w_lg_n1l1iO867w868w(0)));
	n1l1il <= ((((((wire_nillO_w_lg_nlO0li881w(0) AND (wire_nillO_w_lg_nlO0iO882w(0) AND (nlO0il AND nlO0ii))) OR (wire_nillO_w_lg_nlO0li881w(0) AND (nlO0iO AND n1001i))) OR (wire_nillO_w_lg_nlO0li881w(0) AND (nlO0iO AND n101OO))) OR wire_nillO_w_lg_nlO0li2507w(0)) OR wire_nillO_w_lg_nlO0li2510w(0)) OR wire_nillO_w_lg_nlO0li2514w(0));
	n1l1iO <= (n100il OR n100ii);
	n1l1li <= (wire_nillO_w_lg_nlO0li881w(0) AND (wire_nillO_w_lg_nlO0iO882w(0) AND wire_nillO_w_lg_w_lg_nlO0il883w2512w(0)));
	n1l1ll <= ((((wire_nillO_w_lg_nlO0li881w(0) AND (wire_nillO_w_lg_nlO0iO882w(0) AND wire_nillO_w_lg_w_lg_nlO0il883w2495w(0))) OR (wire_nillO_w_lg_nlO0li881w(0) AND (wire_nillO_w_lg_nlO0iO882w(0) AND wire_nillO_w_lg_nlO0il2496w(0)))) OR (wire_nillO_w_lg_nlO0li881w(0) AND (nlO0iO AND n101Ol))) OR wire_nillO_w_lg_nlO0li2529w(0));
	n1l1lO <= (wire_nillO_w_lg_nlO0il883w(0) AND wire_nillO_w_lg_w_lg_nlO0ii2442w2443w(0));
	n1l1Oi <= (n101lO AND n1l00i);
	n1l1Ol <= (((wire_w_lg_n1000i2549w(0) OR (n101lO AND n1l01l)) OR n1001O) OR n1000l);
	n1l1OO <= (nlO00i AND n101il);
	n1li0i <= (((wire_n10Ol_w_lg_n10OO1491w(0) AND wire_n10Ol_w_lg_n10Oi1492w(0)) AND wire_n10Ol_w_lg_n10lO1494w(0)) AND wire_n10Ol_w_lg_n10li1496w(0));
	n1li0O <= (wire_n1Olii_dataout AND (NOT (wire_w_lg_w_lg_n1O0Ol52w53w(0) AND wire_w_lg_n1O0ll54w(0))));
	n1li1l <= (PMADATAWIDTH AND n1li0i);
	n1li1O <= (wire_w_lg_PMADATAWIDTH131w(0) AND n1li0i);
	n1liii <= ((((((((wire_n01il_w_lg_dataout305w(0) OR wire_w_lg_n1liOO306w(0)) OR wire_w_lg_n1liOl308w(0)) OR wire_w_lg_n1liOi310w(0)) OR wire_w_lg_n1lilO312w(0)) OR wire_w_lg_n1lill314w(0)) OR wire_w_lg_n1lili316w(0)) OR wire_w_lg_n1liiO318w(0)) OR n1liil);
	n1liil <= ((((((((wire_n0i1O_w_lg_dataout1481w(0) AND wire_n00lO_w_lg_dataout287w(0)) AND wire_n00iO_w_lg_dataout280w(0)) AND wire_n000O_w_lg_dataout274w(0)) AND wire_n001O_w_lg_dataout269w(0)) AND wire_n01OO_w_lg_dataout265w(0)) AND wire_n01lO_w_lg_dataout262w(0)) AND wire_n01li_w_lg_dataout260w(0)) AND wire_n01il_w_lg_dataout1489w(0));
	n1liiO <= ((((((((wire_n00OO_w_lg_dataout295w(0) OR wire_n00lO_dataout) OR wire_n00iO_dataout) OR wire_n000O_dataout) OR wire_n001O_dataout) OR wire_n01OO_dataout) OR wire_n01lO_dataout) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1lili <= (((((((wire_n00lO_w_lg_dataout287w(0) OR wire_n00iO_dataout) OR wire_n000O_dataout) OR wire_n001O_dataout) OR wire_n01OO_dataout) OR wire_n01lO_dataout) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1lill <= ((((((wire_n00iO_w_lg_dataout280w(0) OR wire_n000O_dataout) OR wire_n001O_dataout) OR wire_n01OO_dataout) OR wire_n01lO_dataout) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1lilO <= (((((wire_n000O_w_lg_dataout274w(0) OR wire_n001O_dataout) OR wire_n01OO_dataout) OR wire_n01lO_dataout) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1liOi <= ((((wire_n001O_w_lg_dataout269w(0) OR wire_n01OO_dataout) OR wire_n01lO_dataout) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1liOl <= (((wire_n01OO_w_lg_dataout265w(0) OR wire_n01lO_dataout) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1liOO <= ((wire_n01lO_w_lg_dataout262w(0) OR wire_n01li_dataout) OR wire_n01il_dataout);
	n1ll0i <= ((((((((((NOT (wire_ni0iO_dataout XOR wire_n0lll_dataout)) AND (NOT (wire_ni0li_dataout XOR wire_n0llO_dataout))) AND (NOT (wire_ni0ll_dataout XOR wire_n0lOi_dataout))) AND (NOT (wire_ni0lO_dataout XOR wire_n0lOl_dataout))) AND (NOT (wire_ni0Oi_dataout XOR wire_n0lOO_dataout))) AND (NOT (wire_ni0Ol_dataout XOR wire_n0O1i_dataout))) AND (NOT (wire_ni0OO_dataout XOR wire_n0O1l_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_n0O1O_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_n0O0i_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_n0O0l_dataout)));
	n1ll0l <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR wire_n0lll_dataout)) AND (NOT (SYNC_COMP_PAT(1) XOR wire_n0llO_dataout))) AND (NOT (SYNC_COMP_PAT(2) XOR wire_n0lOi_dataout))) AND (NOT (SYNC_COMP_PAT(3) XOR wire_n0lOl_dataout))) AND (NOT (SYNC_COMP_PAT(4) XOR wire_n0lOO_dataout))) AND (NOT (SYNC_COMP_PAT(5) XOR wire_n0O1i_dataout))) AND (NOT (SYNC_COMP_PAT(6) XOR wire_n0O1l_dataout))) AND (NOT (wire_niiOl_dataout XOR wire_n0O1O_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_n0O0i_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_n0O0l_dataout)));
	n1ll0O <= ((((((((((NOT (niOll XOR wire_ni0iO_dataout)) AND (NOT (niOlO XOR wire_ni0li_dataout))) AND (NOT (niOOi XOR wire_ni0ll_dataout))) AND (NOT (niOOl XOR wire_ni0lO_dataout))) AND (NOT (niOOO XOR wire_ni0Oi_dataout))) AND (NOT (nl11i XOR wire_ni0Ol_dataout))) AND (NOT (nl11l XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_n0Oii_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_n0Oil_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_n0OiO_dataout)));
	n1ll1i <= (wire_n01li_w_lg_dataout260w(0) OR wire_n01il_dataout);
	n1ll1l <= ((((((((((NOT (wire_ni0iO_dataout XOR wire_n0i0O_dataout)) AND (NOT (wire_ni0li_dataout XOR wire_n0iii_dataout))) AND (NOT (wire_ni0ll_dataout XOR wire_n0iil_dataout))) AND (NOT (wire_ni0lO_dataout XOR wire_n0iiO_dataout))) AND (NOT (wire_ni0Oi_dataout XOR wire_n0ili_dataout))) AND (NOT (wire_ni0Ol_dataout XOR wire_n0ill_dataout))) AND (NOT (wire_ni0OO_dataout XOR wire_n0ilO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_n0iOi_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_n0iOl_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_n0iOO_dataout)));
	n1ll1O <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR wire_n0i0O_dataout)) AND (NOT (SYNC_COMP_PAT(1) XOR wire_n0iii_dataout))) AND (NOT (SYNC_COMP_PAT(2) XOR wire_n0iil_dataout))) AND (NOT (SYNC_COMP_PAT(3) XOR wire_n0iiO_dataout))) AND (NOT (SYNC_COMP_PAT(4) XOR wire_n0ili_dataout))) AND (NOT (SYNC_COMP_PAT(5) XOR wire_n0ill_dataout))) AND (NOT (SYNC_COMP_PAT(6) XOR wire_n0ilO_dataout))) AND (NOT (wire_niiOl_dataout XOR wire_n0iOi_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_n0iOl_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_n0iOO_dataout)));
	n1llii <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR niOll)) AND (NOT (SYNC_COMP_PAT(1) XOR niOlO))) AND (NOT (SYNC_COMP_PAT(2) XOR niOOi))) AND (NOT (SYNC_COMP_PAT(3) XOR niOOl))) AND (NOT (SYNC_COMP_PAT(4) XOR niOOO))) AND (NOT (SYNC_COMP_PAT(5) XOR nl11i))) AND (NOT (SYNC_COMP_PAT(6) XOR nl11l))) AND (NOT (wire_niiOl_dataout XOR wire_n0Oii_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_n0Oil_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_n0OiO_dataout)));
	n1llil <= ((((((((((NOT (niOlO XOR wire_ni0iO_dataout)) AND (NOT (niOOi XOR wire_ni0li_dataout))) AND (NOT (niOOl XOR wire_ni0ll_dataout))) AND (NOT (niOOO XOR wire_ni0lO_dataout))) AND (NOT (nl11i XOR wire_ni0Oi_dataout))) AND (NOT (nl11l XOR wire_ni0Ol_dataout))) AND (NOT (nl11O XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_n0Oll_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_n0OlO_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_n0OOi_dataout)));
	n1lliO <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR niOlO)) AND (NOT (SYNC_COMP_PAT(1) XOR niOOi))) AND (NOT (SYNC_COMP_PAT(2) XOR niOOl))) AND (NOT (SYNC_COMP_PAT(3) XOR niOOO))) AND (NOT (SYNC_COMP_PAT(4) XOR nl11i))) AND (NOT (SYNC_COMP_PAT(5) XOR nl11l))) AND (NOT (SYNC_COMP_PAT(6) XOR nl11O))) AND (NOT (wire_niiOl_dataout XOR wire_n0Oll_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_n0OlO_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_n0OOi_dataout)));
	n1llli <= ((((((((((NOT (niOOi XOR wire_ni0iO_dataout)) AND (NOT (niOOl XOR wire_ni0li_dataout))) AND (NOT (niOOO XOR wire_ni0ll_dataout))) AND (NOT (nl11i XOR wire_ni0lO_dataout))) AND (NOT (nl11l XOR wire_ni0Oi_dataout))) AND (NOT (nl11O XOR wire_ni0Ol_dataout))) AND (NOT (nl10i XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_n0OOO_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_ni11i_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_ni11l_dataout)));
	n1llll <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR niOOi)) AND (NOT (SYNC_COMP_PAT(1) XOR niOOl))) AND (NOT (SYNC_COMP_PAT(2) XOR niOOO))) AND (NOT (SYNC_COMP_PAT(3) XOR nl11i))) AND (NOT (SYNC_COMP_PAT(4) XOR nl11l))) AND (NOT (SYNC_COMP_PAT(5) XOR nl11O))) AND (NOT (SYNC_COMP_PAT(6) XOR nl10i))) AND (NOT (wire_niiOl_dataout XOR wire_n0OOO_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_ni11i_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_ni11l_dataout)));
	n1lllO <= ((((((((((NOT (niOOl XOR wire_ni0iO_dataout)) AND (NOT (niOOO XOR wire_ni0li_dataout))) AND (NOT (nl11i XOR wire_ni0ll_dataout))) AND (NOT (nl11l XOR wire_ni0lO_dataout))) AND (NOT (nl11O XOR wire_ni0Oi_dataout))) AND (NOT (nl10i XOR wire_ni0Ol_dataout))) AND (NOT (nl10l XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_ni10i_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_ni10l_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_ni10O_dataout)));
	n1llOi <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR niOOl)) AND (NOT (SYNC_COMP_PAT(1) XOR niOOO))) AND (NOT (SYNC_COMP_PAT(2) XOR nl11i))) AND (NOT (SYNC_COMP_PAT(3) XOR nl11l))) AND (NOT (SYNC_COMP_PAT(4) XOR nl11O))) AND (NOT (SYNC_COMP_PAT(5) XOR nl10i))) AND (NOT (SYNC_COMP_PAT(6) XOR nl10l))) AND (NOT (wire_niiOl_dataout XOR wire_ni10i_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_ni10l_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_ni10O_dataout)));
	n1lO0i <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR niOOO)) AND (NOT (SYNC_COMP_PAT(1) XOR nl11i))) AND (NOT (SYNC_COMP_PAT(2) XOR nl11l))) AND (NOT (SYNC_COMP_PAT(3) XOR nl11O))) AND (NOT (SYNC_COMP_PAT(4) XOR nl10i))) AND (NOT (SYNC_COMP_PAT(5) XOR nl10l))) AND (NOT (SYNC_COMP_PAT(6) XOR nl10O))) AND (NOT (wire_niiOl_dataout XOR wire_ni1il_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_ni1iO_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_ni1li_dataout)));
	n1lO1O <= ((((((((((NOT (niOOO XOR wire_ni0iO_dataout)) AND (NOT (nl11i XOR wire_ni0li_dataout))) AND (NOT (nl11l XOR wire_ni0ll_dataout))) AND (NOT (nl11O XOR wire_ni0lO_dataout))) AND (NOT (nl10i XOR wire_ni0Oi_dataout))) AND (NOT (nl10l XOR wire_ni0Ol_dataout))) AND (NOT (nl10O XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_ni1il_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_ni1iO_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_ni1li_dataout)));
	n1lOll <= ((((((((((NOT (nl11i XOR wire_ni0iO_dataout)) AND (NOT (nl11l XOR wire_ni0li_dataout))) AND (NOT (nl11O XOR wire_ni0ll_dataout))) AND (NOT (nl10i XOR wire_ni0lO_dataout))) AND (NOT (nl10l XOR wire_ni0Oi_dataout))) AND (NOT (nl10O XOR wire_ni0Ol_dataout))) AND (NOT (nl1ii XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_ni1lO_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_ni1Oi_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_ni1Ol_dataout)));
	n1lOlO <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR nl11i)) AND (NOT (SYNC_COMP_PAT(1) XOR nl11l))) AND (NOT (SYNC_COMP_PAT(2) XOR nl11O))) AND (NOT (SYNC_COMP_PAT(3) XOR nl10i))) AND (NOT (SYNC_COMP_PAT(4) XOR nl10l))) AND (NOT (SYNC_COMP_PAT(5) XOR nl10O))) AND (NOT (SYNC_COMP_PAT(6) XOR nl1ii))) AND (NOT (wire_niiOl_dataout XOR wire_ni1lO_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_ni1Oi_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_ni1Ol_dataout)));
	n1O00O <= (wire_nlliO_w_lg_n0000l60w(0) AND (n1O0ii14 XOR n1O0ii13));
	n1O0ll <= ((((wire_w_lg_n1ll1i304w(0) OR wire_w_lg_n1liOl308w(0)) OR wire_w_lg_n1lilO312w(0)) OR wire_w_lg_n1lili316w(0)) OR n1liil);
	n1O0lO <= ((((wire_w_lg_n1liOO306w(0) OR wire_w_lg_n1liOl308w(0)) OR wire_w_lg_n1lill314w(0)) OR wire_w_lg_n1lili316w(0)) OR wire_w_lg_n1liii321w(0));
	n1O0Oi <= ((((wire_w_lg_n1liOO306w(0) OR wire_w_lg_n1liOl308w(0)) OR wire_w_lg_n1liOi310w(0)) OR wire_w_lg_n1lilO312w(0)) OR wire_w_lg_n1liii321w(0));
	n1O0Ol <= (wire_n01il_w_lg_dataout305w(0) OR wire_w_lg_n1liii321w(0));
	n1O0OO <= ((n0000l AND n1Oi1O) AND (n1Oi1i10 XOR n1Oi1i9));
	n1O11l <= ((((((((((NOT (nl11l XOR wire_ni0iO_dataout)) AND (NOT (nl11O XOR wire_ni0li_dataout))) AND (NOT (nl10i XOR wire_ni0ll_dataout))) AND (NOT (nl10l XOR wire_ni0lO_dataout))) AND (NOT (nl10O XOR wire_ni0Oi_dataout))) AND (NOT (nl1ii XOR wire_ni0Ol_dataout))) AND (NOT (nl1il XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_ni01i_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_ni01l_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_ni01O_dataout)));
	n1O11O <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR nl11l)) AND (NOT (SYNC_COMP_PAT(1) XOR nl11O))) AND (NOT (SYNC_COMP_PAT(2) XOR nl10i))) AND (NOT (SYNC_COMP_PAT(3) XOR nl10l))) AND (NOT (SYNC_COMP_PAT(4) XOR nl10O))) AND (NOT (SYNC_COMP_PAT(5) XOR nl1ii))) AND (NOT (SYNC_COMP_PAT(6) XOR nl1il))) AND (NOT (wire_niiOl_dataout XOR wire_ni01i_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_ni01l_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_ni01O_dataout)));
	n1O1li <= ((((((((((NOT (nl11O XOR wire_ni0iO_dataout)) AND (NOT (nl10i XOR wire_ni0li_dataout))) AND (NOT (nl10l XOR wire_ni0ll_dataout))) AND (NOT (nl10O XOR wire_ni0lO_dataout))) AND (NOT (nl1ii XOR wire_ni0Oi_dataout))) AND (NOT (nl1il XOR wire_ni0Ol_dataout))) AND (NOT (nl1iO XOR wire_ni0OO_dataout))) AND (NOT (wire_nii1i_dataout XOR wire_ni00l_dataout))) AND (NOT (wire_nii1l_dataout XOR wire_ni00O_dataout))) AND (NOT (wire_nii1O_dataout XOR wire_ni0ii_dataout)));
	n1O1ll <= ((((((((((NOT (SYNC_COMP_PAT(0) XOR nl11O)) AND (NOT (SYNC_COMP_PAT(1) XOR nl10i))) AND (NOT (SYNC_COMP_PAT(2) XOR nl10l))) AND (NOT (SYNC_COMP_PAT(3) XOR nl10O))) AND (NOT (SYNC_COMP_PAT(4) XOR nl1ii))) AND (NOT (SYNC_COMP_PAT(5) XOR nl1il))) AND (NOT (SYNC_COMP_PAT(6) XOR nl1iO))) AND (NOT (wire_niiOl_dataout XOR wire_ni00l_dataout))) AND (NOT (wire_niiOO_dataout XOR wire_ni00O_dataout))) AND (NOT (wire_nil1i_dataout XOR wire_ni0ii_dataout)));
	n1O1lO <= ((NOT SYNC_COMP_SIZE(0)) AND wire_w_lg_w_SYNC_COMP_SIZE_range897w898w(0));
	n1O1Oi <= wire_w_lg_w_SYNC_COMP_SIZE_range895w900w(0);
	n1Oi0i <= '1';
	n1Oi1O <= ((wire_w_lg_w_lg_n1O0Ol52w53w(0) AND wire_w_lg_n1O0ll54w(0)) AND (n1O0iO12 XOR n1O0iO11));
	n1Oiii <= ((((n001li OR n001iO) OR n0010i) OR n0011O) OR n1Olll);
	n1Oiil <= ((((n001iO OR n001il) OR n001ii) OR n0010O) OR n0010l);
	n1OiiO <= (((((n001Ol OR n001Oi) OR n001il) OR n001ii) OR n0010i) OR n0011O);
	n1Oili <= (((((n001Oi OR n001ll) OR n001li) OR n001ii) OR n0010l) OR n0011O);
	n1Ol1l <= (ni0OiO OR ni0Oil);
	RLV <= n1Ol1l;
	RLV_lt <= ((((ni0Oii OR ni0O0O) OR (NOT (n1OiOi2 XOR n1OiOi1))) OR (DWIDTH AND ni0l0O)) OR (NOT (n1Oill4 XOR n1Oill3)));
	signal_detect_sync <= n0001i;
	SUDI <= ( nllOlO & nllOll & nllOli & nllOiO & nllOil & nllOii & nllO0O & nllO0l & nllO0i & nllO1O & nllO1l & nllO1i & nlllOO);
	SUDI_pre <= ( nlO0li & nlO0iO & nlO0il & nlO0ii & nlO00O & nlO00l & nlO00i & nlO01O & nlO01l & nlO01i);
	sync_curr_st <= ( n1Oiii & n1Oiil & wire_w_lg_n1OiiO39w & n1Oili);
	sync_status <= n0101l;
	wire_w_IB_INVALID_CODE_range2446w(0) <= IB_INVALID_CODE(0);
	wire_w_IB_INVALID_CODE_range2453w(0) <= IB_INVALID_CODE(1);
	wire_w_SYNC_COMP_SIZE_range895w(0) <= SYNC_COMP_SIZE(0);
	wire_w_SYNC_COMP_SIZE_range897w(0) <= SYNC_COMP_SIZE(1);
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1l0OO53 <= n1l0OO54;
		END IF;
		if (now = 0 ns) then
			n1l0OO53 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1l0OO54 <= n1l0OO53;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1li0l49 <= n1li0l50;
		END IF;
		if (now = 0 ns) then
			n1li0l49 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1li0l50 <= n1li0l49;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1li1i51 <= n1li1i52;
		END IF;
		if (now = 0 ns) then
			n1li1i51 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1li1i52 <= n1li1i51;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1llOl47 <= n1llOl48;
		END IF;
		if (now = 0 ns) then
			n1llOl47 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1llOl48 <= n1llOl47;
		END IF;
	END PROCESS;
	wire_n1llOl48_w_lg_q221w(0) <= n1llOl48 XOR n1llOl47;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lO0l43 <= n1lO0l44;
		END IF;
		if (now = 0 ns) then
			n1lO0l43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lO0l44 <= n1lO0l43;
		END IF;
	END PROCESS;
	wire_n1lO0l44_w_lg_q208w(0) <= n1lO0l44 XOR n1lO0l43;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lO1i45 <= n1lO1i46;
		END IF;
		if (now = 0 ns) then
			n1lO1i45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lO1i46 <= n1lO1i45;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOii41 <= n1lOii42;
		END IF;
		if (now = 0 ns) then
			n1lOii41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOii42 <= n1lOii41;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOiO39 <= n1lOiO40;
		END IF;
		if (now = 0 ns) then
			n1lOiO39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOiO40 <= n1lOiO39;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOOi37 <= n1lOOi38;
		END IF;
		if (now = 0 ns) then
			n1lOOi37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOOi38 <= n1lOOi37;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOOO35 <= n1lOOO36;
		END IF;
		if (now = 0 ns) then
			n1lOOO35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1lOOO36 <= n1lOOO35;
		END IF;
	END PROCESS;
	wire_n1lOOO36_w_lg_q186w(0) <= n1lOOO36 XOR n1lOOO35;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O00i17 <= n1O00i18;
		END IF;
		if (now = 0 ns) then
			n1O00i17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O00i18 <= n1O00i17;
		END IF;
	END PROCESS;
	wire_n1O00i18_w_lg_w_lg_q79w80w(0) <= wire_n1O00i18_w_lg_q79w(0) AND nllli;
	wire_n1O00i18_w_lg_q79w(0) <= n1O00i18 XOR n1O00i17;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O00l15 <= n1O00l16;
		END IF;
		if (now = 0 ns) then
			n1O00l15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O00l16 <= n1O00l15;
		END IF;
	END PROCESS;
	wire_n1O00l16_w_lg_w_lg_q68w69w(0) <= wire_n1O00l16_w_lg_q68w(0) AND nllli;
	wire_n1O00l16_w_lg_q68w(0) <= n1O00l16 XOR n1O00l15;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O01i23 <= n1O01i24;
		END IF;
		if (now = 0 ns) then
			n1O01i23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O01i24 <= n1O01i23;
		END IF;
	END PROCESS;
	wire_n1O01i24_w_lg_w_lg_q99w100w(0) <= wire_n1O01i24_w_lg_q99w(0) AND wire_nll1O_dataout;
	wire_n1O01i24_w_lg_q99w(0) <= n1O01i24 XOR n1O01i23;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O01l21 <= n1O01l22;
		END IF;
		if (now = 0 ns) then
			n1O01l21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O01l22 <= n1O01l21;
		END IF;
	END PROCESS;
	wire_n1O01l22_w_lg_w_lg_q96w97w(0) <= wire_n1O01l22_w_lg_q96w(0) AND n1O00O;
	wire_n1O01l22_w_lg_q96w(0) <= n1O01l22 XOR n1O01l21;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O01O19 <= n1O01O20;
		END IF;
		if (now = 0 ns) then
			n1O01O19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O01O20 <= n1O01O19;
		END IF;
	END PROCESS;
	wire_n1O01O20_w_lg_w_lg_q88w89w(0) <= wire_n1O01O20_w_lg_q88w(0) AND nllil;
	wire_n1O01O20_w_lg_q88w(0) <= n1O01O20 XOR n1O01O19;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O0ii13 <= n1O0ii14;
		END IF;
		if (now = 0 ns) then
			n1O0ii13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O0ii14 <= n1O0ii13;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O0iO11 <= n1O0iO12;
		END IF;
		if (now = 0 ns) then
			n1O0iO11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O0iO12 <= n1O0iO11;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O10i33 <= n1O10i34;
		END IF;
		if (now = 0 ns) then
			n1O10i33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O10i34 <= n1O10i33;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O10O31 <= n1O10O32;
		END IF;
		if (now = 0 ns) then
			n1O10O31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O10O32 <= n1O10O31;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O1il29 <= n1O1il30;
		END IF;
		if (now = 0 ns) then
			n1O1il29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O1il30 <= n1O1il29;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O1Ol27 <= n1O1Ol28;
		END IF;
		if (now = 0 ns) then
			n1O1Ol27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O1Ol28 <= n1O1Ol27;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O1OO25 <= n1O1OO26;
		END IF;
		if (now = 0 ns) then
			n1O1OO25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1O1OO26 <= n1O1OO25;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oi0l7 <= n1Oi0l8;
		END IF;
		if (now = 0 ns) then
			n1Oi0l7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oi0l8 <= n1Oi0l7;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oi0O5 <= n1Oi0O6;
		END IF;
		if (now = 0 ns) then
			n1Oi0O5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oi0O6 <= n1Oi0O5;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oi1i10 <= n1Oi1i9;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oi1i9 <= n1Oi1i10;
		END IF;
		if (now = 0 ns) then
			n1Oi1i9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oill3 <= n1Oill4;
		END IF;
		if (now = 0 ns) then
			n1Oill3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1Oill4 <= n1Oill3;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1OiOi1 <= n1OiOi2;
		END IF;
		if (now = 0 ns) then
			n1OiOi1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rcvd_clk)
	BEGIN
		IF (rcvd_clk = '1' AND rcvd_clk'event) THEN n1OiOi2 <= n1OiOi1;
		END IF;
	END PROCESS;
	PROCESS (rcvd_clk, wire_n10Ol_PRN, wire_n10Ol_CLRN)
	BEGIN
		IF (wire_n10Ol_PRN = '0') THEN
				n10li <= '1';
				n10lO <= '1';
				n10Oi <= '1';
				n10OO <= '1';
		ELSIF (wire_n10Ol_CLRN = '0') THEN
				n10li <= '0';
				n10lO <= '0';
				n10Oi <= '0';
				n10OO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN
			IF (n11ll = '1') THEN
				n10li <= wire_n1i1l_dataout;
				n10lO <= wire_n1i1O_dataout;
				n10Oi <= wire_n1i0i_dataout;
				n10OO <= wire_n1i0l_dataout;
			END IF;
		END IF;
	END PROCESS;
	wire_n10Ol_CLRN <= ((n1li1i52 XOR n1li1i51) AND wire_w_lg_soft_reset46w(0));
	wire_n10Ol_PRN <= (n1l0OO54 XOR n1l0OO53);
	wire_n10Ol_w_lg_n10li1496w(0) <= NOT n10li;
	wire_n10Ol_w_lg_n10lO1494w(0) <= NOT n10lO;
	wire_n10Ol_w_lg_n10Oi1492w(0) <= NOT n10Oi;
	wire_n10Ol_w_lg_n10OO1491w(0) <= NOT n10OO;
	PROCESS (rcvd_clk, wire_n1O1i_CLRN)
	BEGIN
		IF (wire_n1O1i_CLRN = '0') THEN
				n1lOi <= '0';
				n1lOl <= '0';
				n1lOO <= '0';
				n1O1l <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN
			IF (n1li0O = '1') THEN
				n1lOi <= wire_w_lg_n1O0ll54w(0);
				n1lOl <= n1O0lO;
				n1lOO <= n1O0Oi;
				n1O1l <= n1O0Ol;
			END IF;
		END IF;
	END PROCESS;
	wire_n1O1i_CLRN <= ((n1li0l50 XOR n1li0l49) AND wire_w_lg_soft_reset46w(0));
	PROCESS (rcvd_clk, wire_nillO_PRN, soft_reset)
	BEGIN
		IF (wire_nillO_PRN = '0') THEN
				n0001i <= '1';
				n0010i <= '1';
				n0010l <= '1';
				n0010O <= '1';
				n0011O <= '1';
				n001ii <= '1';
				n001il <= '1';
				n001iO <= '1';
				n001li <= '1';
				n001ll <= '1';
				n001lO <= '1';
				n001Oi <= '1';
				n001OO <= '1';
				n0101l <= '1';
				n1lli <= '1';
				n1lll <= '1';
				n1O1O <= '1';
				n1Ol0i <= '1';
				n1Ol0O <= '1';
				n1Olli <= '1';
				n1Olll <= '1';
				ni0iOl <= '1';
				ni0iOO <= '1';
				ni0l0i <= '1';
				ni0l0O <= '1';
				ni0l1i <= '1';
				ni0l1l <= '1';
				ni0l1O <= '1';
				ni0O0O <= '1';
				ni0Oii <= '1';
				ni0Oil <= '1';
				ni0OiO <= '1';
				ni0OOO <= '1';
				ni1liO <= '1';
				ni1lli <= '1';
				ni1lll <= '1';
				ni1llO <= '1';
				ni1lOi <= '1';
				ni1lOl <= '1';
				ni1lOO <= '1';
				ni1O1i <= '1';
				ni1Oli <= '1';
				nii11i <= '1';
				nii11l <= '1';
				nii11O <= '1';
				niii0i <= '1';
				niii0l <= '1';
				niii0O <= '1';
				niii1l <= '1';
				niii1O <= '1';
				niiiii <= '1';
				niiiil <= '1';
				niiiiO <= '1';
				niiili <= '1';
				niiill <= '1';
				niiilO <= '1';
				niiiOi <= '1';
				niiiOl <= '1';
				niiiOO <= '1';
				niil1i <= '1';
				niiO0i <= '1';
				niiO0l <= '1';
				niiO0O <= '1';
				niiO1l <= '1';
				niiO1O <= '1';
				niiOii <= '1';
				niiOil <= '1';
				niiOiO <= '1';
				niiOli <= '1';
				niiOll <= '1';
				niiOlO <= '1';
				niiOOi <= '1';
				niiOOl <= '1';
				nil0i <= '1';
				nil0l <= '1';
				nil0O <= '1';
				nilii <= '1';
				nilil <= '1';
				niliO <= '1';
				nilli <= '1';
				nilll <= '1';
				nilOi <= '1';
				nlll0l <= '1';
				nlll0O <= '1';
				nlllll <= '1';
				nllllO <= '1';
				nlllOi <= '1';
				nlllOl <= '1';
				nlllOO <= '1';
				nllO0i <= '1';
				nllO0l <= '1';
				nllO0O <= '1';
				nllO1i <= '1';
				nllO1l <= '1';
				nllO1O <= '1';
				nllOii <= '1';
				nllOil <= '1';
				nllOiO <= '1';
				nllOli <= '1';
				nllOll <= '1';
				nllOlO <= '1';
				nllOOi <= '1';
				nllOOl <= '1';
				nllOOO <= '1';
				nlO00i <= '1';
				nlO00l <= '1';
				nlO00O <= '1';
				nlO01i <= '1';
				nlO01l <= '1';
				nlO01O <= '1';
				nlO0ii <= '1';
				nlO0il <= '1';
				nlO0iO <= '1';
				nlO0li <= '1';
				nlO10i <= '1';
				nlO10l <= '1';
				nlO10O <= '1';
				nlO11i <= '1';
				nlO11l <= '1';
				nlO11O <= '1';
				nlO1ii <= '1';
				nlO1il <= '1';
				nlO1iO <= '1';
				nlO1li <= '1';
				nlO1ll <= '1';
				nlO1lO <= '1';
				nlO1Oi <= '1';
				nlO1Ol <= '1';
				nlO1OO <= '1';
		ELSIF (soft_reset = '1') THEN
				n0001i <= '0';
				n0010i <= '0';
				n0010l <= '0';
				n0010O <= '0';
				n0011O <= '0';
				n001ii <= '0';
				n001il <= '0';
				n001iO <= '0';
				n001li <= '0';
				n001ll <= '0';
				n001lO <= '0';
				n001Oi <= '0';
				n001OO <= '0';
				n0101l <= '0';
				n1lli <= '0';
				n1lll <= '0';
				n1O1O <= '0';
				n1Ol0i <= '0';
				n1Ol0O <= '0';
				n1Olli <= '0';
				n1Olll <= '0';
				ni0iOl <= '0';
				ni0iOO <= '0';
				ni0l0i <= '0';
				ni0l0O <= '0';
				ni0l1i <= '0';
				ni0l1l <= '0';
				ni0l1O <= '0';
				ni0O0O <= '0';
				ni0Oii <= '0';
				ni0Oil <= '0';
				ni0OiO <= '0';
				ni0OOO <= '0';
				ni1liO <= '0';
				ni1lli <= '0';
				ni1lll <= '0';
				ni1llO <= '0';
				ni1lOi <= '0';
				ni1lOl <= '0';
				ni1lOO <= '0';
				ni1O1i <= '0';
				ni1Oli <= '0';
				nii11i <= '0';
				nii11l <= '0';
				nii11O <= '0';
				niii0i <= '0';
				niii0l <= '0';
				niii0O <= '0';
				niii1l <= '0';
				niii1O <= '0';
				niiiii <= '0';
				niiiil <= '0';
				niiiiO <= '0';
				niiili <= '0';
				niiill <= '0';
				niiilO <= '0';
				niiiOi <= '0';
				niiiOl <= '0';
				niiiOO <= '0';
				niil1i <= '0';
				niiO0i <= '0';
				niiO0l <= '0';
				niiO0O <= '0';
				niiO1l <= '0';
				niiO1O <= '0';
				niiOii <= '0';
				niiOil <= '0';
				niiOiO <= '0';
				niiOli <= '0';
				niiOll <= '0';
				niiOlO <= '0';
				niiOOi <= '0';
				niiOOl <= '0';
				nil0i <= '0';
				nil0l <= '0';
				nil0O <= '0';
				nilii <= '0';
				nilil <= '0';
				niliO <= '0';
				nilli <= '0';
				nilll <= '0';
				nilOi <= '0';
				nlll0l <= '0';
				nlll0O <= '0';
				nlllll <= '0';
				nllllO <= '0';
				nlllOi <= '0';
				nlllOl <= '0';
				nlllOO <= '0';
				nllO0i <= '0';
				nllO0l <= '0';
				nllO0O <= '0';
				nllO1i <= '0';
				nllO1l <= '0';
				nllO1O <= '0';
				nllOii <= '0';
				nllOil <= '0';
				nllOiO <= '0';
				nllOli <= '0';
				nllOll <= '0';
				nllOlO <= '0';
				nllOOi <= '0';
				nllOOl <= '0';
				nllOOO <= '0';
				nlO00i <= '0';
				nlO00l <= '0';
				nlO00O <= '0';
				nlO01i <= '0';
				nlO01l <= '0';
				nlO01O <= '0';
				nlO0ii <= '0';
				nlO0il <= '0';
				nlO0iO <= '0';
				nlO0li <= '0';
				nlO10i <= '0';
				nlO10l <= '0';
				nlO10O <= '0';
				nlO11i <= '0';
				nlO11l <= '0';
				nlO11O <= '0';
				nlO1ii <= '0';
				nlO1il <= '0';
				nlO1iO <= '0';
				nlO1li <= '0';
				nlO1ll <= '0';
				nlO1lO <= '0';
				nlO1Oi <= '0';
				nlO1Ol <= '0';
				nlO1OO <= '0';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN
				n0001i <= n001OO;
				n0010i <= wire_n1OOii_o;
				n0010l <= wire_n1OOiO_o;
				n0010O <= wire_n1OOll_o;
				n0011O <= wire_n1OO0O_o;
				n001ii <= wire_n1OOOi_o;
				n001il <= wire_n1OOOO_o;
				n001iO <= wire_n0111l_o;
				n001li <= wire_n0110i_o;
				n001ll <= wire_n0110O_o;
				n001lO <= wire_n011il_o;
				n001Oi <= wire_n011li_o;
				n001OO <= (wire_w_lg_SYNC_SM_DIS876w(0) AND (LP10BEN OR signal_detect));
				n0101l <= wire_n1OlOO_o;
				n1lli <= n1iOi;
				n1lll <= n1llO;
				n1O1O <= nl11O;
				n1Ol0i <= wire_n1OO1O_o;
				n1Ol0O <= wire_n1OllO_o;
				n1Olli <= wire_n1OlOi_o;
				n1Olll <= wire_n1OO0i_o;
				ni0iOl <= wire_ni01ll_o;
				ni0iOO <= wire_ni01lO_dataout;
				ni0l0i <= wire_ni001O_dataout;
				ni0l0O <= wire_ni0Oli_dataout;
				ni0l1i <= wire_ni01Oi_o;
				ni0l1l <= wire_ni01OO_o;
				ni0l1O <= wire_ni001l_dataout;
				ni0O0O <= wire_ni0Oll_dataout;
				ni0Oii <= wire_ni0OlO_dataout;
				ni0Oil <= wire_ni0OOi_dataout;
				ni0OiO <= ni0OOO;
				ni0OOO <= (niil1i OR nii11O);
				ni1liO <= wire_ni1Oii_o(1);
				ni1lli <= wire_ni1Oii_o(2);
				ni1lll <= wire_ni1Oii_o(3);
				ni1llO <= wire_ni1O1l_dataout;
				ni1lOi <= wire_ni1O1O_dataout;
				ni1lOl <= wire_ni1O0i_dataout;
				ni1lOO <= wire_ni1O0l_dataout;
				ni1O1i <= wire_ni01iO_o;
				ni1Oli <= wire_ni1Oii_o(0);
				nii11i <= nii11l;
				nii11l <= RLV_EN;
				nii11O <= wire_niil1l_dataout;
				niii0i <= wire_niil0l_dataout;
				niii0l <= wire_niil0O_dataout;
				niii0O <= wire_niilii_dataout;
				niii1l <= wire_niil1O_dataout;
				niii1O <= wire_niil0i_dataout;
				niiiii <= wire_niilil_dataout;
				niiiil <= wire_niiliO_dataout;
				niiiiO <= wire_niilli_dataout;
				niiili <= wire_niilll_dataout;
				niiill <= wire_niillO_dataout;
				niiilO <= wire_niilOi_dataout;
				niiiOi <= wire_niilOl_dataout;
				niiiOl <= wire_niilOO_dataout;
				niiiOO <= wire_niiO1i_dataout;
				niil1i <= wire_niiOOO_dataout;
				niiO0i <= wire_nil11O_dataout;
				niiO0l <= wire_nil10i_dataout;
				niiO0O <= wire_nil10l_dataout;
				niiO1l <= wire_nil11i_dataout;
				niiO1O <= wire_nil11l_dataout;
				niiOii <= wire_nil10O_dataout;
				niiOil <= wire_nil1ii_dataout;
				niiOiO <= wire_nil1il_dataout;
				niiOli <= wire_nil1iO_dataout;
				niiOll <= wire_nil1li_dataout;
				niiOlO <= wire_nil1ll_dataout;
				niiOOi <= wire_nil1lO_dataout;
				niiOOl <= wire_nil1Oi_dataout;
				nil0i <= nl10i;
				nil0l <= nl10l;
				nil0O <= nl10O;
				nilii <= nl1ii;
				nilil <= nl1il;
				niliO <= nl1iO;
				nilli <= nl1li;
				nilll <= nl1ll;
				nilOi <= nl1Oi;
				nlll0l <= wire_n0OOlO_dataout;
				nlll0O <= (wire_w_lg_PMADATAWIDTH131w(0) AND (n1l11i OR n1iOOO));
				nlllll <= (((n1l10l OR n1l10i) OR (wire_nillO_w_lg_nlO0li881w(0) AND (wire_nillO_w_lg_nlO0iO882w(0) AND wire_nillO_w_lg_w_lg_nlO0il883w884w(0)))) OR wire_nillO_w_lg_nlO0li890w(0));
				nllllO <= nlllOi;
				nlllOi <= nlllOl;
				nlllOl <= n1i1i;
				nlllOO <= wire_nlOi0O_dataout;
				nllO0i <= wire_nlOili_dataout;
				nllO0l <= wire_nlOill_dataout;
				nllO0O <= wire_nlOilO_dataout;
				nllO1i <= wire_nlOiii_dataout;
				nllO1l <= wire_nlOiil_dataout;
				nllO1O <= wire_nlOiiO_dataout;
				nllOii <= wire_nlOiOi_dataout;
				nllOil <= wire_nlOiOl_dataout;
				nllOiO <= wire_nlOiOO_dataout;
				nllOli <= wire_w_lg_n1l10O879w(0);
				nllOll <= (((wire_w_lg_PMADATAWIDTH131w(0) AND (SYNC_SM_DIS AND nlllOl)) OR wire_w_lg_PMADATAWIDTH874w(0)) OR wire_w_lg_w_lg_SYNC_SM_DIS876w877w(0));
				nllOlO <= n1l1ii;
				nllOOi <= wire_nlOlOO_dataout;
				nllOOl <= wire_nlOO1i_dataout;
				nllOOO <= wire_nlOO1l_dataout;
				nlO00i <= n110i;
				nlO00l <= n110l;
				nlO00O <= n110O;
				nlO01i <= nlO0ll;
				nlO01l <= n111l;
				nlO01O <= n111O;
				nlO0ii <= n11ii;
				nlO0il <= n11il;
				nlO0iO <= n11iO;
				nlO0li <= n11li;
				nlO10i <= wire_nlOO0O_dataout;
				nlO10l <= wire_nlOOii_dataout;
				nlO10O <= nlO1OO;
				nlO11i <= wire_nlOO1O_dataout;
				nlO11l <= wire_nlOO0i_dataout;
				nlO11O <= wire_nlOO0l_dataout;
				nlO1ii <= wire_nlOOil_o;
				nlO1il <= wire_nlOOiO_o;
				nlO1iO <= wire_nlOOli_o;
				nlO1li <= wire_nlOOll_o;
				nlO1ll <= wire_nlOOlO_o;
				nlO1lO <= wire_nlOOOi_o;
				nlO1Oi <= wire_nlOOOl_o;
				nlO1Ol <= wire_nlOOOO_o;
				nlO1OO <= n1lli;
		END IF;
	END PROCESS;
	wire_nillO_PRN <= (n1O1Ol28 XOR n1O1Ol27);
	wire_nillO_w_lg_w_lg_w_lg_w2399w2400w2401w2402w(0) <= wire_nillO_w_lg_w_lg_w2399w2400w2401w(0) AND n1il0l;
	wire_nillO_w_lg_w_lg_w2399w2400w2401w(0) <= wire_nillO_w_lg_w2399w2400w(0) AND n1il0O;
	wire_nillO_w_lg_w2399w2400w(0) <= wire_nillO_w2399w(0) AND n1ilii;
	wire_nillO_w2399w(0) <= wire_nillO_w_lg_w_lg_w_lg_w_lg_n1O1O2083w2396w2397w2398w(0) AND n1ilil;
	wire_nillO_w_lg_w_lg_w_lg_w_lg_n1O1O2083w2396w2397w2398w(0) <= wire_nillO_w_lg_w_lg_w_lg_n1O1O2083w2396w2397w(0) AND n1iliO;
	wire_nillO_w_lg_w_lg_w_lg_nilli1648w1653w1658w(0) <= wire_nillO_w_lg_w_lg_nilli1648w1653w(0) AND nilii;
	wire_nillO_w_lg_w_lg_w_lg_nilOi1646w1651w1656w(0) <= wire_nillO_w_lg_w_lg_nilOi1646w1651w(0) AND niliO;
	wire_nillO_w_lg_w_lg_w_lg_n1O1O2083w2396w2397w(0) <= wire_nillO_w_lg_w_lg_n1O1O2083w2396w(0) AND n1illi;
	wire_nillO_w_lg_w_lg_w_lg_nlO0il883w2447w2448w(0) <= wire_nillO_w_lg_w_lg_nlO0il883w2447w(0) AND n1000O;
	wire_nillO_w_lg_w_lg_nilli1648w1653w(0) <= wire_nillO_w_lg_nilli1648w(0) AND nilil;
	wire_nillO_w_lg_w_lg_nilOi1646w1651w(0) <= wire_nillO_w_lg_nilOi1646w(0) AND nilli;
	wire_nillO_w_lg_w_lg_nlO0il2449w2450w(0) <= wire_nillO_w_lg_nlO0il2449w(0) AND n1000O;
	wire_nillO_w_lg_w_lg_n1O1O2083w2396w(0) <= wire_nillO_w_lg_n1O1O2083w(0) AND n1iO1i;
	wire_nillO_w_lg_w_lg_nlO00i855w2583w(0) <= wire_nillO_w_lg_nlO00i855w(0) AND n101il;
	wire_nillO_w_lg_w_lg_nlO00i855w856w(0) <= wire_nillO_w_lg_nlO00i855w(0) AND n1l1Oi;
	wire_nillO_w_lg_w_lg_nlO00O2567w2588w(0) <= wire_nillO_w_lg_nlO00O2567w(0) AND nlO00l;
	wire_nillO_w_lg_w_lg_nlO01l2560w2562w(0) <= wire_nillO_w_lg_nlO01l2560w(0) AND wire_nillO_w_lg_nlO01i2561w(0);
	wire_nillO_w_lg_w_lg_nlO01l2560w2597w(0) <= wire_nillO_w_lg_nlO01l2560w(0) AND nlO01i;
	wire_nillO_w_lg_w_lg_nlO01O2569w2625w(0) <= wire_nillO_w_lg_nlO01O2569w(0) AND n1010i;
	wire_nillO_w_lg_w_lg_nlO01O2569w2620w(0) <= wire_nillO_w_lg_nlO01O2569w(0) AND n1010l;
	wire_nillO_w_lg_w_lg_nlO01O2569w2608w(0) <= wire_nillO_w_lg_nlO01O2569w(0) AND n1010O;
	wire_nillO_w_lg_w_lg_nlO01O2569w2605w(0) <= wire_nillO_w_lg_nlO01O2569w(0) AND n101ii;
	wire_nillO_w_lg_w_lg_nlO0ii2442w2476w(0) <= wire_nillO_w_lg_nlO0ii2442w(0) AND n100il;
	wire_nillO_w_lg_w_lg_nlO0ii2442w2443w(0) <= wire_nillO_w_lg_nlO0ii2442w(0) AND n1l1il;
	wire_nillO_w_lg_w_lg_nlO0il883w2458w(0) <= wire_nillO_w_lg_nlO0il883w(0) AND wire_w_lg_n1l10i2457w(0);
	wire_nillO_w_lg_w_lg_nlO0il883w2512w(0) <= wire_nillO_w_lg_nlO0il883w(0) AND wire_nillO_w_lg_nlO0ii2442w(0);
	wire_nillO_w_lg_w_lg_nlO0il883w2447w(0) <= wire_nillO_w_lg_nlO0il883w(0) AND n1l10l;
	wire_nillO_w_lg_w_lg_nlO0il883w884w(0) <= wire_nillO_w_lg_nlO0il883w(0) AND n1l11O;
	wire_nillO_w_lg_w_lg_nlO0il883w2495w(0) <= wire_nillO_w_lg_nlO0il883w(0) AND nlO0ii;
	wire_nillO_w_lg_w_lg_nlO0iO882w2459w(0) <= wire_nillO_w_lg_nlO0iO882w(0) AND wire_nillO_w_lg_w_lg_nlO0il883w2458w(0);
	wire_nillO_w_lg_w_lg_nlO0iO882w2506w(0) <= wire_nillO_w_lg_nlO0iO882w(0) AND n1001i;
	wire_nillO_w_lg_w_lg_nlO0iO882w2533w(0) <= wire_nillO_w_lg_nlO0iO882w(0) AND n101Oi;
	wire_nillO_w_lg_w_lg_nlO0iO882w2528w(0) <= wire_nillO_w_lg_nlO0iO882w(0) AND n101Ol;
	wire_nillO_w_lg_w_lg_nlO0iO882w2509w(0) <= wire_nillO_w_lg_nlO0iO882w(0) AND n101OO;
	wire_nillO_w_lg_w_lg_nlO0li881w2482w(0) <= wire_nillO_w_lg_nlO0li881w(0) AND n100il;
	wire_nillO_w_lg_n1O1O2416w(0) <= n1O1O AND wire_w_lg_n1ii1i1979w(0);
	wire_nillO_w_lg_nilli1648w(0) <= nilli AND niliO;
	wire_nillO_w_lg_nilOi1646w(0) <= nilOi AND nilll;
	wire_nillO_w_lg_nlll0l858w(0) <= nlll0l AND wire_w_lg_n1l1Ol857w(0);
	wire_nillO_w_lg_nlO00i2626w(0) <= nlO00i AND wire_nillO_w_lg_w_lg_nlO01O2569w2625w(0);
	wire_nillO_w_lg_nlO00i2621w(0) <= nlO00i AND wire_nillO_w_lg_w_lg_nlO01O2569w2620w(0);
	wire_nillO_w_lg_nlO00i2609w(0) <= nlO00i AND wire_nillO_w_lg_w_lg_nlO01O2569w2608w(0);
	wire_nillO_w_lg_nlO00i2606w(0) <= nlO00i AND wire_nillO_w_lg_w_lg_nlO01O2569w2605w(0);
	wire_nillO_w_lg_nlO00i2564w(0) <= nlO00i AND wire_nillO_w_lg_nlO01O2563w(0);
	wire_nillO_w_lg_nlO00i2629w(0) <= nlO00i AND wire_nillO_w_lg_nlO01O2628w(0);
	wire_nillO_w_lg_nlO00i2632w(0) <= nlO00i AND wire_nillO_w_lg_nlO01O2631w(0);
	wire_nillO_w_lg_nlO00O2589w(0) <= nlO00O AND wire_nillO_w_lg_nlO00l2568w(0);
	wire_nillO_w_lg_nlO01l2598w(0) <= nlO01l AND wire_nillO_w_lg_nlO01i2561w(0);
	wire_nillO_w_lg_nlO01O2563w(0) <= nlO01O AND wire_nillO_w_lg_w_lg_nlO01l2560w2562w(0);
	wire_nillO_w_lg_nlO01O2628w(0) <= nlO01O AND wire_nillO_w_lg_w_lg_nlO01l2560w2597w(0);
	wire_nillO_w_lg_nlO01O2631w(0) <= nlO01O AND wire_nillO_w_lg_nlO01l2598w(0);
	wire_nillO_w_lg_nlO0ii865w(0) <= nlO0ii AND n1l1il;
	wire_nillO_w_lg_nlO0il2455w(0) <= nlO0il AND wire_w_lg_n1l10l2454w(0);
	wire_nillO_w_lg_nlO0il866w(0) <= nlO0il AND wire_nillO_w_lg_nlO0ii865w(0);
	wire_nillO_w_lg_nlO0il2496w(0) <= nlO0il AND wire_nillO_w_lg_nlO0ii2442w(0);
	wire_nillO_w_lg_nlO0il2449w(0) <= nlO0il AND n1l10i;
	wire_nillO_w_lg_nlO0il888w(0) <= nlO0il AND n1l11l;
	wire_nillO_w_lg_nlO0iO2513w(0) <= nlO0iO AND wire_nillO_w_lg_w_lg_nlO0il883w2512w(0);
	wire_nillO_w_lg_nlO0iO2536w(0) <= nlO0iO AND wire_nillO_w_lg_w_lg_nlO0il883w2495w(0);
	wire_nillO_w_lg_nlO0iO2456w(0) <= nlO0iO AND wire_nillO_w_lg_nlO0il2455w(0);
	wire_nillO_w_lg_nlO0iO2539w(0) <= nlO0iO AND wire_nillO_w_lg_nlO0il2496w(0);
	wire_nillO_w_lg_nlO0iO889w(0) <= nlO0iO AND wire_nillO_w_lg_nlO0il888w(0);
	wire_nillO_w_lg_nlO0li2507w(0) <= nlO0li AND wire_nillO_w_lg_w_lg_nlO0iO882w2506w(0);
	wire_nillO_w_lg_nlO0li2534w(0) <= nlO0li AND wire_nillO_w_lg_w_lg_nlO0iO882w2533w(0);
	wire_nillO_w_lg_nlO0li2529w(0) <= nlO0li AND wire_nillO_w_lg_w_lg_nlO0iO882w2528w(0);
	wire_nillO_w_lg_nlO0li2510w(0) <= nlO0li AND wire_nillO_w_lg_w_lg_nlO0iO882w2509w(0);
	wire_nillO_w_lg_nlO0li2514w(0) <= nlO0li AND wire_nillO_w_lg_nlO0iO2513w(0);
	wire_nillO_w_lg_nlO0li2537w(0) <= nlO0li AND wire_nillO_w_lg_nlO0iO2536w(0);
	wire_nillO_w_lg_nlO0li2540w(0) <= nlO0li AND wire_nillO_w_lg_nlO0iO2539w(0);
	wire_nillO_w_lg_nlO0li890w(0) <= nlO0li AND wire_nillO_w_lg_nlO0iO889w(0);
	wire_nillO_w_lg_w_lg_w_lg_w_lg_nilli1561w1568w1575w1576w(0) <= NOT wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w(0);
	wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1569w(0) <= NOT wire_nillO_w_lg_w_lg_nilli1561w1568w(0);
	wire_nillO_w_lg_w_lg_nilli1561w1562w(0) <= NOT wire_nillO_w_lg_nilli1561w(0);
	wire_nillO_w_lg_n0001i2740w(0) <= NOT n0001i;
	wire_nillO_w_lg_n1lli1498w(0) <= NOT n1lli;
	wire_nillO_w_lg_n1O1O2083w(0) <= NOT n1O1O;
	wire_nillO_w_lg_n1Ol0i2743w(0) <= NOT n1Ol0i;
	wire_nillO_w_lg_nii11i2011w(0) <= NOT nii11i;
	wire_nillO_w_lg_niii1l2179w(0) <= NOT niii1l;
	wire_nillO_w_lg_niii1O2185w(0) <= NOT niii1O;
	wire_nillO_w_lg_niiO1l2180w(0) <= NOT niiO1l;
	wire_nillO_w_lg_nil0i2075w(0) <= NOT nil0i;
	wire_nillO_w_lg_nil0l2067w(0) <= NOT nil0l;
	wire_nillO_w_lg_nil0O2065w(0) <= NOT nil0O;
	wire_nillO_w_lg_nilii2063w(0) <= NOT nilii;
	wire_nillO_w_lg_nilil2061w(0) <= NOT nilil;
	wire_nillO_w_lg_niliO2059w(0) <= NOT niliO;
	wire_nillO_w_lg_nilli2089w(0) <= NOT nilli;
	wire_nillO_w_lg_nilll2087w(0) <= NOT nilll;
	wire_nillO_w_lg_nilOi2382w(0) <= NOT nilOi;
	wire_nillO_w_lg_nlll0l845w(0) <= NOT nlll0l;
	wire_nillO_w_lg_nlll0O2741w(0) <= NOT nlll0O;
	wire_nillO_w_lg_nlllll2714w(0) <= NOT nlllll;
	wire_nillO_w_lg_nlO00i855w(0) <= NOT nlO00i;
	wire_nillO_w_lg_nlO00l2568w(0) <= NOT nlO00l;
	wire_nillO_w_lg_nlO00O2567w(0) <= NOT nlO00O;
	wire_nillO_w_lg_nlO01i2561w(0) <= NOT nlO01i;
	wire_nillO_w_lg_nlO01l2560w(0) <= NOT nlO01l;
	wire_nillO_w_lg_nlO01O2569w(0) <= NOT nlO01O;
	wire_nillO_w_lg_nlO0ii2442w(0) <= NOT nlO0ii;
	wire_nillO_w_lg_nlO0il883w(0) <= NOT nlO0il;
	wire_nillO_w_lg_nlO0iO882w(0) <= NOT nlO0iO;
	wire_nillO_w_lg_nlO0li881w(0) <= NOT nlO0li;
	wire_nillO_w_lg_w_lg_w_lg_w_lg_nlO0il883w2447w2448w2451w(0) <= wire_nillO_w_lg_w_lg_w_lg_nlO0il883w2447w2448w(0) OR wire_nillO_w_lg_w_lg_nlO0il2449w2450w(0);
	wire_nillO_w_lg_w_lg_nlO0iO2456w2460w(0) <= wire_nillO_w_lg_nlO0iO2456w(0) OR wire_nillO_w_lg_w_lg_nlO0iO882w2459w(0);
	wire_nillO_w_lg_w_lg_w_lg_nilli1561w1568w1575w(0) <= wire_nillO_w_lg_w_lg_nilli1561w1568w(0) OR nilii;
	wire_nillO_w_lg_w_lg_nilli1561w1568w(0) <= wire_nillO_w_lg_nilli1561w(0) OR nilil;
	wire_nillO_w_lg_nilli1561w(0) <= nilli OR niliO;
	PROCESS (rcvd_clk, wire_nl1lO_PRN, soft_reset)
	BEGIN
		IF (wire_nl1lO_PRN = '0') THEN
				nilOl <= '1';
				nilOO <= '1';
				niO1i <= '1';
				nl1ll <= '1';
				nl1Oi <= '1';
		ELSIF (soft_reset = '1') THEN
				nilOl <= '0';
				nilOO <= '0';
				niO1i <= '0';
				nl1ll <= '0';
				nl1Oi <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN
			IF (PMADATAWIDTH = '0') THEN
				nilOl <= niOiO;
				nilOO <= niOli;
				niO1i <= niOll;
				nl1ll <= wire_nliil_dataout;
				nl1Oi <= wire_nliiO_dataout;
			END IF;
		END IF;
	END PROCESS;
	wire_nl1lO_PRN <= (n1O1OO26 XOR n1O1OO25);
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN
				n0000i <= '0';
				n0000l <= '0';
				n0000O <= '0';
				n0001O <= '0';
				n00OlO <= '0';
				n00OOi <= '0';
				n00OOl <= '0';
				n00OOO <= '0';
				n0i0OO <= '0';
				n0i10i <= '0';
				n0i10l <= '0';
				n0i10O <= '0';
				n0i11i <= '0';
				n0i11l <= '0';
				n0i11O <= '0';
				n0i1ii <= '0';
				n0i1il <= '0';
				n0i1iO <= '0';
				n0i1li <= '0';
				n0i1ll <= '0';
				n0i1lO <= '0';
				n0i1Oi <= '0';
				n0ii0i <= '0';
				n0ii0l <= '0';
				n0ii0O <= '0';
				n0ii1i <= '0';
				n0ii1l <= '0';
				n0ii1O <= '0';
				n10ii <= '0';
				n10il <= '0';
				n10iO <= '0';
				n110i <= '0';
				n110l <= '0';
				n110O <= '0';
				n111l <= '0';
				n111O <= '0';
				n11ii <= '0';
				n11il <= '0';
				n11iO <= '0';
				n11li <= '0';
				n11ll <= '0';
				n1i1i <= '0';
				n1iOi <= '0';
				n1iOO <= '0';
				n1l0i <= '0';
				n1l0l <= '0';
				n1l1i <= '0';
				n1l1l <= '0';
				n1l1O <= '0';
				n1llO <= '0';
				niO0i <= '0';
				niO0l <= '0';
				niO0O <= '0';
				niO1l <= '0';
				niO1O <= '0';
				niOii <= '0';
				niOil <= '0';
				niOiO <= '0';
				niOli <= '0';
				niOll <= '0';
				niOlO <= '0';
				niOOi <= '0';
				niOOl <= '0';
				niOOO <= '0';
				nl10i <= '0';
				nl10l <= '0';
				nl10O <= '0';
				nl11i <= '0';
				nl11l <= '0';
				nl11O <= '0';
				nl1ii <= '0';
				nl1il <= '0';
				nl1iO <= '0';
				nl1li <= '0';
				nllil <= '0';
				nllli <= '0';
				nlO0ll <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN
				n0000i <= prbs_en;
				n0000l <= n0000O;
				n0000O <= ENCDT;
				n0001O <= n0000i;
				n00OlO <= n1llii;
				n00OOi <= wire_n00Oli_o;
				n00OOl <= n1lliO;
				n00OOO <= wire_n00O0l_o;
				n0i0OO <= n1O11O;
				n0i10i <= wire_n00lli_o;
				n0i10l <= n1lO0i;
				n0i10O <= wire_n00l0l_o;
				n0i11i <= n1llll;
				n0i11l <= wire_n00lOO_o;
				n0i11O <= n1llOi;
				n0i1ii <= n1lOlO;
				n0i1il <= wire_n00iOO_o;
				n0i1iO <= n1O11O;
				n0i1li <= wire_n00ili_o;
				n0i1ll <= n1O1ll;
				n0i1lO <= wire_n00i0l_o;
				n0i1Oi <= n1O1ll;
				n0ii0i <= n1llll;
				n0ii0l <= n1lliO;
				n0ii0O <= n1llii;
				n0ii1i <= n1lOlO;
				n0ii1l <= n1lO0i;
				n0ii1O <= n1llOi;
				n10ii <= n10il;
				n10il <= n10iO;
				n10iO <= BITSLIP;
				n110i <= wire_n11OO_o;
				n110l <= wire_n101i_o;
				n110O <= wire_n101l_o;
				n111l <= wire_n11Oi_o;
				n111O <= wire_n11Ol_o;
				n11ii <= wire_n101O_o;
				n11il <= wire_n100i_o;
				n11iO <= wire_n100l_o;
				n11li <= wire_n100O_o;
				n11ll <= (n10il AND wire_nlliO_w_lg_n10ii771w(0));
				n1i1i <= (NOT (wire_nllll_w_lg_w_lg_w_lg_n1liO362w363w364w(0) OR ((((NOT (n1l0O XOR n1l1l)) AND (NOT (n1lii XOR n1l1O))) AND (NOT (n1lil XOR n1l0i))) AND (NOT (n1liO XOR n1l0l)))));
				n1iOi <= n1iOO;
				n1iOO <= n1l1i;
				n1l0i <= n1lOO;
				n1l0l <= n1O1l;
				n1l1i <= A1A2_SIZE;
				n1l1l <= n1lOi;
				n1l1O <= n1lOl;
				n1llO <= n1li0O;
				niO0i <= wire_nl01i_dataout;
				niO0l <= wire_nl01l_dataout;
				niO0O <= wire_nl01O_dataout;
				niO1l <= wire_nl1Ol_dataout;
				niO1O <= wire_nl1OO_dataout;
				niOii <= wire_nl00i_dataout;
				niOil <= wire_nl00l_dataout;
				niOiO <= wire_nl00O_dataout;
				niOli <= wire_nl0ii_dataout;
				niOll <= wire_nl0il_dataout;
				niOlO <= wire_nl0iO_dataout;
				niOOi <= wire_nl0li_dataout;
				niOOl <= wire_nl0ll_dataout;
				niOOO <= wire_nl0lO_dataout;
				nl10i <= wire_nli1i_dataout;
				nl10l <= wire_nli1l_dataout;
				nl10O <= wire_nli1O_dataout;
				nl11i <= wire_nl0Oi_dataout;
				nl11l <= wire_nl0Ol_dataout;
				nl11O <= wire_nl0OO_dataout;
				nl1ii <= wire_nli0i_dataout;
				nl1il <= wire_nli0l_dataout;
				nl1iO <= wire_nli0O_dataout;
				nl1li <= wire_nliii_dataout;
				nllil <= wire_nlill_o;
				nllli <= wire_nlilO_o;
				nlO0ll <= wire_n11lO_o;
		END IF;
	END PROCESS;
	wire_nlliO_w_lg_w_lg_n0i10O219w222w(0) <= wire_nlliO_w_lg_n0i10O219w(0) AND wire_n1llOl48_w_lg_q221w(0);
	wire_nlliO_w_lg_n0000l60w(0) <= n0000l AND wire_w_lg_n1Oi1O59w(0);
	wire_nlliO_w_lg_n00OOi254w(0) <= n00OOi AND wire_nlliO_w_lg_n00OlO253w(0);
	wire_nlliO_w_lg_n00OOO246w(0) <= n00OOO AND wire_nlliO_w_lg_n00OOl245w(0);
	wire_nlliO_w_lg_n0i10i230w(0) <= n0i10i AND wire_nlliO_w_lg_n0i11O229w(0);
	wire_nlliO_w_lg_n0i10O219w(0) <= n0i10O AND wire_nlliO_w_lg_n0i10l218w(0);
	wire_nlliO_w_lg_n0i11l238w(0) <= n0i11l AND wire_nlliO_w_lg_n0i11i237w(0);
	wire_nlliO_w_lg_n0i1il205w(0) <= n0i1il AND wire_nlliO_w_lg_n0i1ii204w(0);
	wire_nlliO_w_lg_n0i1li183w(0) <= n0i1li AND wire_nlliO_w_lg_n0i1iO182w(0);
	wire_nlliO_w_lg_n0i1lO168w(0) <= n0i1lO AND wire_nlliO_w_lg_n0i1ll167w(0);
	wire_nlliO_w_lg_n1iOO210w(0) <= n1iOO AND wire_w_lg_w_lg_n1lOll206w209w(0);
	wire_nlliO_w_lg_n1iOO188w(0) <= n1iOO AND wire_w_lg_w_lg_n1O11l184w187w(0);
	wire_nlliO_w_lg_n1iOO256w(0) <= n1iOO AND wire_w_lg_n1ll0O255w(0);
	wire_nlliO_w_lg_n1iOO248w(0) <= n1iOO AND wire_w_lg_n1llil247w(0);
	wire_nlliO_w_lg_n1iOO240w(0) <= n1iOO AND wire_w_lg_n1llli239w(0);
	wire_nlliO_w_lg_n1iOO232w(0) <= n1iOO AND wire_w_lg_n1lllO231w(0);
	wire_nlliO_w_lg_n1iOO224w(0) <= n1iOO AND wire_w_lg_n1lO1O223w(0);
	wire_nlliO_w_lg_n1iOO170w(0) <= n1iOO AND wire_w_lg_n1O1li169w(0);
	wire_nlliO_w_lg_n0000l72w(0) <= NOT n0000l;
	wire_nlliO_w_lg_n00OlO253w(0) <= NOT n00OlO;
	wire_nlliO_w_lg_n00OOl245w(0) <= NOT n00OOl;
	wire_nlliO_w_lg_n0i10l218w(0) <= NOT n0i10l;
	wire_nlliO_w_lg_n0i11i237w(0) <= NOT n0i11i;
	wire_nlliO_w_lg_n0i11O229w(0) <= NOT n0i11O;
	wire_nlliO_w_lg_n0i1ii204w(0) <= NOT n0i1ii;
	wire_nlliO_w_lg_n0i1iO182w(0) <= NOT n0i1iO;
	wire_nlliO_w_lg_n0i1ll167w(0) <= NOT n0i1ll;
	wire_nlliO_w_lg_n10ii771w(0) <= NOT n10ii;
	wire_nlliO_w_lg_n1iOO161w(0) <= NOT n1iOO;
	PROCESS (rcvd_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN
				n001Ol <= '1';
				n1Ol0l <= '1';
				ni0l0l <= '1';
				nlllil <= '1';
		ELSIF (rcvd_clk = '1' AND rcvd_clk'event) THEN
				n001Ol <= wire_n011lO_o;
				n1Ol0l <= wire_n1OO1l_o;
				ni0l0l <= wire_nillO_w_lg_nii11i2011w(0);
				nlllil <= (n1l1ii OR wire_w_lg_n1l10O879w(0));
		END IF;
		if (now = 0 ns) then
			n001Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1Ol0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0l0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlllil <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nlllii_w_lg_nlllil2715w(0) <= NOT nlllil;
	PROCESS (rcvd_clk, wire_nllll_PRN, wire_nllll_CLRN)
	BEGIN
		IF (wire_nllll_PRN = '0') THEN
				n0001l <= '1';
				n1l0O <= '1';
				n1lii <= '1';
				n1lil <= '1';
				n1liO <= '1';
				nlllO <= '1';
		ELSIF (wire_nllll_CLRN = '0') THEN
				n0001l <= '0';
				n1l0O <= '0';
				n1lii <= '0';
				n1lil <= '0';
				n1liO <= '0';
				nlllO <= '0';
		ELSIF (rcvd_clk = '0' AND rcvd_clk'event) THEN
				n0001l <= n1Ol0l;
				n1l0O <= wire_w_lg_n1O0ll54w(0);
				n1lii <= n1O0lO;
				n1lil <= n1O0Oi;
				n1liO <= n1O0Ol;
				nlllO <= wire_nliOi_o;
		END IF;
		if (now = 0 ns) then
			n0001l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1l0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1liO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlllO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nllll_CLRN <= (n1Oi0O6 XOR n1Oi0O5);
	wire_nllll_PRN <= ((n1Oi0l8 XOR n1Oi0l7) AND wire_w_lg_soft_reset46w(0));
	wire_nllll_w_lg_w_lg_w_lg_n1liO362w363w364w(0) <= wire_nllll_w_lg_w_lg_n1liO362w363w(0) AND n1l0O;
	wire_nllll_w_lg_w_lg_n1liO362w363w(0) <= wire_nllll_w_lg_n1liO362w(0) AND n1lii;
	wire_nllll_w_lg_n1liO362w(0) <= n1liO AND n1lil;
	wire_n000O_dataout <= ((wire_nlliO_w_lg_n1iOO161w(0) AND (n1lllO AND n0ii1O)) OR wire_nlliO_w_lg_n1iOO232w(0)) WHEN PMADATAWIDTH = '1'  ELSE (n1llOi OR n1lllO);
	wire_n000O_w_lg_dataout274w(0) <= NOT wire_n000O_dataout;
	wire_n0011i_dataout <= wire_nillO_w_lg_n1Ol0i2743w(0) OR NOT(n1011i);
	wire_n001O_dataout <= ((wire_nlliO_w_lg_n1iOO161w(0) AND (n1llli AND n0ii0i)) OR wire_nlliO_w_lg_n1iOO240w(0)) WHEN PMADATAWIDTH = '1'  ELSE (n1llll OR n1llli);
	wire_n001O_w_lg_dataout269w(0) <= NOT wire_n001O_dataout;
	wire_n00i0O_dataout <= n1O1li OR n1O1ll;
	wire_n00ill_dataout <= n1O11l OR n1O11O;
	wire_n00iO_dataout <= (((wire_nlliO_w_lg_n1iOO161w(0) AND (n1lO1O AND n0ii1l)) AND (n1lO1i46 XOR n1lO1i45)) OR wire_nlliO_w_lg_n1iOO224w(0)) WHEN PMADATAWIDTH = '1'  ELSE (n1lO0i OR n1lO1O);
	wire_n00iO_w_lg_dataout280w(0) <= NOT wire_n00iO_dataout;
	wire_n00l0O_dataout <= n1lO1O OR n1lO0i;
	wire_n00l1i_dataout <= n1lOll OR n1lOlO;
	wire_n00lll_dataout <= n1lllO OR n1llOi;
	wire_n00lO_dataout <= ((wire_nlliO_w_lg_n1iOO161w(0) AND ((n1lOll AND n0ii1i) AND (n1lOii42 XOR n1lOii41))) OR wire_nlliO_w_lg_n1iOO210w(0)) WHEN PMADATAWIDTH = '1'  ELSE ((n1lOlO OR n1lOll) OR (NOT (n1lOiO40 XOR n1lOiO39)));
	wire_n00lO_w_lg_dataout287w(0) <= NOT wire_n00lO_dataout;
	wire_n00O0O_dataout <= n1llil OR n1lliO;
	wire_n00O1i_dataout <= n1llli OR n1llll;
	wire_n00Oll_dataout <= n1ll0O OR n1llii;
	wire_n00OO_dataout <= (((wire_nlliO_w_lg_n1iOO161w(0) AND (n1O11l AND n0i0OO)) OR wire_nlliO_w_lg_n1iOO188w(0)) OR (NOT (n1lOOi38 XOR n1lOOi37))) WHEN PMADATAWIDTH = '1'  ELSE (n1O11O OR n1O11l);
	wire_n00OO_w_lg_dataout295w(0) <= NOT wire_n00OO_dataout;
	wire_n0100i_dataout <= wire_n01iiO_o(1) AND NOT(n11OiO);
	wire_n0100l_dataout <= n0101l AND NOT(n11OiO);
	wire_n0101i_dataout <= n11O0l AND NOT(n11OiO);
	wire_n0101O_dataout <= wire_n01iiO_o(0) AND NOT(n11OiO);
	wire_n010i_dataout <= n10li WHEN AUTOBYTEALIGN_DIS = '1'  ELSE n1lOi;
	wire_n010ii_dataout <= wire_n010ll_dataout AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n010il_dataout <= wire_n010lO_dataout AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n010iO_dataout <= wire_n010Oi_dataout AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n010l_dataout <= n10lO WHEN AUTOBYTEALIGN_DIS = '1'  ELSE n1lOl;
	wire_n010li_dataout <= wire_n010Ol_dataout AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n010ll_dataout <= wire_n010OO_dataout AND NOT(n11O0O);
	wire_n010lO_dataout <= wire_n01i1i_dataout AND NOT(n11O0O);
	wire_n010O_dataout <= n10Oi WHEN AUTOBYTEALIGN_DIS = '1'  ELSE n1lOO;
	wire_n010Oi_dataout <= wire_w_lg_n11O0l2776w(0) AND NOT(n11O0O);
	wire_n010Ol_dataout <= n11O0l AND NOT(n11O0O);
	wire_n010OO_dataout <= wire_n01iiO_o(0) AND NOT(n11O0l);
	wire_n011Oi_dataout <= wire_n010OO_dataout AND NOT(n11OiO);
	wire_n011Ol_dataout <= wire_n01i1i_dataout AND NOT(n11OiO);
	wire_n011OO_dataout <= wire_w_lg_n11O0l2776w(0) AND NOT(n11OiO);
	wire_n01i0i_dataout <= wire_n01iii_dataout AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n01i0l_dataout <= wire_n01iil_dataout AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n01i0O_dataout <= wire_w_lg_n11O0O2761w(0) AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n01i1i_dataout <= wire_n01iiO_o(1) AND NOT(n11O0l);
	wire_n01ii_dataout <= n10OO WHEN AUTOBYTEALIGN_DIS = '1'  ELSE n1O1l;
	wire_n01iii_dataout <= wire_n01iiO_o(0) AND NOT(n11O0O);
	wire_n01iil_dataout <= wire_n01iiO_o(1) AND NOT(n11O0O);
	wire_n01il_dataout <= (n1ll1O OR n1ll1l) AND NOT(PMADATAWIDTH);
	wire_n01il_w_lg_dataout1489w(0) <= NOT wire_n01il_dataout;
	wire_n01il_w_lg_dataout305w(0) <= wire_n01il_dataout OR wire_w_lg_n1ll1i304w(0);
	wire_n01ili_dataout <= n1Ol0l OR wire_nillO_w_lg_n0001i2740w(0);
	wire_n01ill_dataout <= n0101l AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n01ilO_dataout <= n11O0O AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n01iOi_dataout <= wire_w_lg_n11O0O2761w(0) AND NOT(wire_nillO_w_lg_n0001i2740w(0));
	wire_n01iOO_dataout <= n0101l WHEN n11Oil = '1'  ELSE wire_n01l0i_dataout;
	wire_n01l0i_dataout <= n0101l OR n11Oii;
	wire_n01l1i_dataout <= n1Ol0l OR n11Oil;
	wire_n01l1l_dataout <= n11Oii AND NOT(n11Oil);
	wire_n01l1O_dataout <= wire_w_lg_n11Oii2759w(0) AND NOT(n11Oil);
	wire_n01li_dataout <= (n1ll0l OR n1ll0i) AND NOT(PMADATAWIDTH);
	wire_n01li_w_lg_dataout260w(0) <= NOT wire_n01li_dataout;
	wire_n01lO_dataout <= ((wire_nlliO_w_lg_n1iOO161w(0) AND (n1ll0O AND n0ii0O)) OR wire_nlliO_w_lg_n1iOO256w(0)) WHEN PMADATAWIDTH = '1'  ELSE (n1llii OR n1ll0O);
	wire_n01lO_w_lg_dataout262w(0) <= NOT wire_n01lO_dataout;
	wire_n01lOi_dataout <= wire_nillO_w_lg_n1Ol0i2743w(0) WHEN n11OiO = '1'  ELSE wire_n01O1l_dataout;
	wire_n01lOl_dataout <= n1Ol0l OR n11OiO;
	wire_n01lOO_dataout <= wire_w_lg_n11Oli2749w(0) AND NOT(n11OiO);
	wire_n01O0l_dataout <= wire_nillO_w_lg_n1Ol0i2743w(0) WHEN n11OOl = '1'  ELSE wire_n01Oli_dataout;
	wire_n01O0O_dataout <= n1Ol0l OR n11OOl;
	wire_n01O1i_dataout <= n11Oli AND NOT(n11OiO);
	wire_n01O1l_dataout <= wire_nillO_w_lg_n1Ol0i2743w(0) OR n11Oli;
	wire_n01Oii_dataout <= n11OlO AND NOT(n11OOl);
	wire_n01Oil_dataout <= wire_n01Oll_dataout AND NOT(n11OOl);
	wire_n01OiO_dataout <= wire_n01OlO_dataout AND NOT(n11OOl);
	wire_n01Oli_dataout <= wire_nillO_w_lg_n1Ol0i2743w(0) WHEN n11OlO = '1'  ELSE n1Ol0i;
	wire_n01Oll_dataout <= n11Oll AND NOT(n11OlO);
	wire_n01OlO_dataout <= wire_w_lg_n11Oll2746w(0) AND NOT(n11OlO);
	wire_n01OO_dataout <= ((wire_nlliO_w_lg_n1iOO161w(0) AND (n1llil AND n0ii0l)) OR wire_nlliO_w_lg_n1iOO248w(0)) WHEN PMADATAWIDTH = '1'  ELSE (n1lliO OR n1llil);
	wire_n01OO_w_lg_dataout265w(0) <= NOT wire_n01OO_dataout;
	wire_n01OOO_dataout <= n1Ol0l AND n1011i;
	wire_n0i0O_dataout <= niOiO WHEN n1O1lO = '1'  ELSE wire_n0l1i_dataout;
	wire_n0i1O_dataout <= ((((wire_nlliO_w_lg_n1iOO161w(0) AND (n1O1li AND n0i1Oi)) AND (n1O1il30 XOR n1O1il29)) OR (wire_nlliO_w_lg_n1iOO170w(0) AND (n1O10O32 XOR n1O10O31))) OR (NOT (n1O10i34 XOR n1O10i33))) WHEN PMADATAWIDTH = '1'  ELSE (n1O1ll OR n1O1li);
	wire_n0i1O_w_lg_dataout1481w(0) <= wire_n0i1O_dataout AND wire_n00OO_w_lg_dataout295w(0);
	wire_n0iii_dataout <= niOli WHEN n1O1lO = '1'  ELSE wire_n0l1l_dataout;
	wire_n0iil_dataout <= niOll WHEN n1O1lO = '1'  ELSE wire_n0l1O_dataout;
	wire_n0iiO_dataout <= niOlO WHEN n1O1lO = '1'  ELSE wire_n0l0i_dataout;
	wire_n0ili_dataout <= niOOi WHEN n1O1lO = '1'  ELSE wire_n0l0l_dataout;
	wire_n0ill_dataout <= niOOl WHEN n1O1lO = '1'  ELSE wire_n0l0O_dataout;
	wire_n0ilO_dataout <= niOOO WHEN n1O1lO = '1'  ELSE wire_n0lii_dataout;
	wire_n0iOi_dataout <= wire_n0lil_dataout AND NOT(n1O1lO);
	wire_n0iOl_dataout <= wire_n0liO_dataout AND NOT(n1O1lO);
	wire_n0iOO_dataout <= wire_n0lli_dataout AND NOT(n1O1lO);
	wire_n0l0i_dataout <= niOlO AND NOT(n1O1Oi);
	wire_n0l0ii_dataout <= nlll0l WHEN ((wire_nillO_w_lg_w_lg_nlO00i855w2583w(0) OR (nlO00i AND n1l1Oi)) OR (n1l00l AND n1l01l)) = '1'  ELSE (n1l1Ol OR n1l1OO);
	wire_n0l0ii_w_lg_w_lg_dataout862w2579w(0) <= wire_n0l0ii_w_lg_dataout862w(0) AND n101li;
	wire_n0l0ii_w_lg_dataout862w(0) <= NOT wire_n0l0ii_dataout;
	wire_n0l0l_dataout <= niOOi AND NOT(n1O1Oi);
	wire_n0l0O_dataout <= niOOl AND NOT(n1O1Oi);
	wire_n0l1i_dataout <= niOiO AND NOT(n1O1Oi);
	wire_n0l1l_dataout <= niOli AND NOT(n1O1Oi);
	wire_n0l1O_dataout <= niOll AND NOT(n1O1Oi);
	wire_n0lii_dataout <= niOOO AND NOT(n1O1Oi);
	wire_n0lil_dataout <= nl11i AND NOT(n1O1Oi);
	wire_n0liO_dataout <= nl11l AND NOT(n1O1Oi);
	wire_n0lli_dataout <= nl11O AND NOT(n1O1Oi);
	wire_n0lll_dataout <= niOli WHEN n1O1lO = '1'  ELSE wire_n0l1l_dataout;
	wire_n0llO_dataout <= niOll WHEN n1O1lO = '1'  ELSE wire_n0l1O_dataout;
	wire_n0lOi_dataout <= niOlO WHEN n1O1lO = '1'  ELSE wire_n0l0i_dataout;
	wire_n0lOl_dataout <= niOOi WHEN n1O1lO = '1'  ELSE wire_n0l0l_dataout;
	wire_n0lOO_dataout <= niOOl WHEN n1O1lO = '1'  ELSE wire_n0l0O_dataout;
	wire_n0O0i_dataout <= wire_n0lli_dataout AND NOT(n1O1lO);
	wire_n0O0l_dataout <= wire_n0O0O_dataout AND NOT(n1O1lO);
	wire_n0O0O_dataout <= nl10i AND NOT(n1O1Oi);
	wire_n0O1i_dataout <= niOOO WHEN n1O1lO = '1'  ELSE wire_n0lii_dataout;
	wire_n0O1l_dataout <= nl11i WHEN n1O1lO = '1'  ELSE wire_n0lil_dataout;
	wire_n0O1O_dataout <= wire_n0liO_dataout AND NOT(n1O1lO);
	wire_n0Oii_dataout <= nl11O AND NOT(n1O1lO);
	wire_n0Oil_dataout <= wire_n0O0O_dataout AND NOT(n1O1lO);
	wire_n0OiO_dataout <= wire_n0Oli_dataout AND NOT(n1O1lO);
	wire_n0Oli_dataout <= nl10l AND NOT(n1O1Oi);
	wire_n0Oll_dataout <= nl10i AND NOT(n1O1lO);
	wire_n0OlO_dataout <= wire_n0Oli_dataout AND NOT(n1O1lO);
	wire_n0OOi_dataout <= wire_n0OOl_dataout AND NOT(n1O1lO);
	wire_n0OOl_dataout <= nl10O AND NOT(n1O1Oi);
	wire_n0OOlO_dataout <= wire_n0l0ii_dataout WHEN ((nlO0il XOR nlO0ii) AND n1l1il) = '1'  ELSE (n1l1iO OR n1l1lO);
	wire_n0OOO_dataout <= nl10l AND NOT(n1O1lO);
	wire_n1i0i_dataout <= wire_n1iil_dataout AND NOT(n1li1O);
	wire_n1i0l_dataout <= wire_n1iiO_dataout OR n1li1O;
	wire_n1i0O_dataout <= wire_n1ili_o(1) OR n1li1l;
	wire_n1i1l_dataout <= wire_n1i0O_dataout OR n1li1O;
	wire_n1i1O_dataout <= wire_n1iii_dataout AND NOT(n1li1O);
	wire_n1iii_dataout <= wire_n1ili_o(2) OR n1li1l;
	wire_n1iil_dataout <= wire_n1ili_o(3) OR n1li1l;
	wire_n1iiO_dataout <= wire_n1ili_o(4) AND NOT(n1li1l);
	wire_n1Olii_dataout <= encdet_prbs WHEN n0001O = '1'  ELSE wire_n1Olil_dataout;
	wire_n1Olil_dataout <= wire_n1OliO_dataout WHEN SYNC_SM_DIS = '1'  ELSE n0001l;
	wire_n1OliO_dataout <= wire_nlili_o WHEN PMADATAWIDTH = '1'  ELSE n0000l;
	wire_ni000i_dataout <= niii0i AND NOT(n10i1l);
	wire_ni000l_dataout <= niii0l AND NOT(n10i1l);
	wire_ni000O_dataout <= niii0O AND NOT(n10i1l);
	wire_ni001l_dataout <= wire_ni0iOi_dataout AND ni0l0i;
	wire_ni001O_dataout <= nii11i AND ni0l0l;
	wire_ni00i_dataout <= nl1ll AND NOT(n1O1Oi);
	wire_ni00ii_dataout <= niiiii AND NOT(n10i1l);
	wire_ni00il_dataout <= wire_ni00ll_dataout AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni00iO_dataout <= n10i1i AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni00l_dataout <= nl1li AND NOT(n1O1lO);
	wire_ni00li_dataout <= wire_ni00lO_dataout AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni00ll_dataout <= wire_w_lg_n100OO2188w(0) AND NOT(n10i1i);
	wire_ni00lO_dataout <= n100OO AND NOT(n10i1i);
	wire_ni00O_dataout <= wire_ni00i_dataout AND NOT(n1O1lO);
	wire_ni00OO_dataout <= niiO1O AND NOT(n10i1l);
	wire_ni01i_dataout <= nl1iO AND NOT(n1O1lO);
	wire_ni01l_dataout <= wire_ni1OO_dataout AND NOT(n1O1lO);
	wire_ni01lO_dataout <= wire_ni0ilO_dataout AND ni0l0i;
	wire_ni01O_dataout <= wire_ni00i_dataout AND NOT(n1O1lO);
	wire_ni0i0l_dataout <= n10i0i AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni0i0O_dataout <= wire_ni0iil_dataout AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni0i1i_dataout <= niiO0i AND NOT(n10i1l);
	wire_ni0i1l_dataout <= niiO0l AND NOT(n10i1l);
	wire_ni0i1O_dataout <= niiO0O AND NOT(n10i1l);
	wire_ni0ii_dataout <= wire_ni0il_dataout AND NOT(n1O1lO);
	wire_ni0iii_dataout <= wire_ni0iiO_dataout AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni0iil_dataout <= wire_w_lg_n10i1O2183w(0) AND NOT(n10i0i);
	wire_ni0iiO_dataout <= n10i1O AND NOT(n10i0i);
	wire_ni0il_dataout <= nl1Oi AND NOT(n1O1Oi);
	wire_ni0ilO_dataout <= niii1l AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni0iO_dataout <= (NOT SYNC_COMP_PAT(0)) WHEN n1O1lO = '1'  ELSE wire_nii0i_dataout;
	wire_ni0iOi_dataout <= wire_nillO_w_lg_niii1l2179w(0) AND NOT(wire_nillO_w_lg_nii11i2011w(0));
	wire_ni0li_dataout <= (NOT SYNC_COMP_PAT(1)) WHEN n1O1lO = '1'  ELSE wire_nii0l_dataout;
	wire_ni0lii_dataout <= RUNDISP_SEL(0) AND NOT(PMADATAWIDTH);
	wire_ni0lii_w_lg_dataout2438w(0) <= NOT wire_ni0lii_dataout;
	wire_ni0lil_dataout <= RUNDISP_SEL(1) AND NOT(PMADATAWIDTH);
	wire_ni0lil_w_lg_dataout2436w(0) <= NOT wire_ni0lil_dataout;
	wire_ni0liO_dataout <= RUNDISP_SEL(0) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0lOO_o(0);
	wire_ni0ll_dataout <= (NOT SYNC_COMP_PAT(2)) WHEN n1O1lO = '1'  ELSE wire_nii0O_dataout;
	wire_ni0lli_dataout <= RUNDISP_SEL(1) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0lOO_o(1);
	wire_ni0lli_w_lg_dataout2433w(0) <= NOT wire_ni0lli_dataout;
	wire_ni0lll_dataout <= RUNDISP_SEL(2) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0lOO_o(2);
	wire_ni0lll_w_lg_dataout2431w(0) <= NOT wire_ni0lll_dataout;
	wire_ni0llO_dataout <= RUNDISP_SEL(3) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0lOO_o(3);
	wire_ni0llO_w_lg_dataout2429w(0) <= NOT wire_ni0llO_dataout;
	wire_ni0lO_dataout <= (NOT SYNC_COMP_PAT(3)) WHEN n1O1lO = '1'  ELSE wire_niiii_dataout;
	wire_ni0lOi_dataout <= RUNDISP_SEL(4) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0lOO_o(4);
	wire_ni0lOi_w_lg_dataout2427w(0) <= NOT wire_ni0lOi_dataout;
	wire_ni0lOl_dataout <= wire_w_lg_n10i0l2156w(0) WHEN PMADATAWIDTH = '1'  ELSE wire_ni0lOO_o(5);
	wire_ni0lOl_w_lg_w2434w2435w(0) <= wire_ni0lOl_w2434w(0) AND wire_ni0liO_dataout;
	wire_ni0lOl_w2434w(0) <= wire_ni0lOl_w_lg_w_lg_w_lg_w_lg_dataout2426w2428w2430w2432w(0) AND wire_ni0lli_w_lg_dataout2433w(0);
	wire_ni0lOl_w_lg_w_lg_w_lg_w_lg_dataout2426w2428w2430w2432w(0) <= wire_ni0lOl_w_lg_w_lg_w_lg_dataout2426w2428w2430w(0) AND wire_ni0lll_w_lg_dataout2431w(0);
	wire_ni0lOl_w_lg_w_lg_w_lg_dataout2426w2428w2430w(0) <= wire_ni0lOl_w_lg_w_lg_dataout2426w2428w(0) AND wire_ni0llO_w_lg_dataout2429w(0);
	wire_ni0lOl_w_lg_w_lg_dataout2426w2428w(0) <= wire_ni0lOl_w_lg_dataout2426w(0) AND wire_ni0lOi_w_lg_dataout2427w(0);
	wire_ni0lOl_w_lg_dataout2426w(0) <= NOT wire_ni0lOl_dataout;
	wire_ni0Oi_dataout <= (NOT SYNC_COMP_PAT(4)) WHEN n1O1lO = '1'  ELSE wire_niiil_dataout;
	wire_ni0Ol_dataout <= (NOT SYNC_COMP_PAT(5)) WHEN n1O1lO = '1'  ELSE wire_niiiO_dataout;
	wire_ni0Oli_dataout <= ni0O0O AND nii11i;
	wire_ni0Oll_dataout <= ni0Oii AND nii11i;
	wire_ni0OlO_dataout <= n1Ol1l AND nii11i;
	wire_ni0OO_dataout <= (NOT SYNC_COMP_PAT(6)) WHEN n1O1lO = '1'  ELSE wire_niili_dataout;
	wire_ni0OOi_dataout <= wire_ni0OOl_o AND nii11i;
	wire_ni10i_dataout <= nl10O AND NOT(n1O1lO);
	wire_ni10l_dataout <= wire_ni11O_dataout AND NOT(n1O1lO);
	wire_ni10O_dataout <= wire_ni1ii_dataout AND NOT(n1O1lO);
	wire_ni11i_dataout <= wire_n0OOl_dataout AND NOT(n1O1lO);
	wire_ni11l_dataout <= wire_ni11O_dataout AND NOT(n1O1lO);
	wire_ni11O_dataout <= nl1ii AND NOT(n1O1Oi);
	wire_ni1ii_dataout <= nl1il AND NOT(n1O1Oi);
	wire_ni1il_dataout <= nl1ii AND NOT(n1O1lO);
	wire_ni1iO_dataout <= wire_ni1ii_dataout AND NOT(n1O1lO);
	wire_ni1li_dataout <= wire_ni1ll_dataout AND NOT(n1O1lO);
	wire_ni1ll_dataout <= nl1iO AND NOT(n1O1Oi);
	wire_ni1lO_dataout <= nl1il AND NOT(n1O1lO);
	wire_ni1O0i_dataout <= wire_ni1O0O_o(2) WHEN wire_ni1Oii_o(4) = '1'  ELSE wire_ni1Oll_dataout;
	wire_ni1O0l_dataout <= wire_ni1O0O_o(3) WHEN wire_ni1Oii_o(4) = '1'  ELSE wire_ni1OlO_dataout;
	wire_ni1O1l_dataout <= wire_ni1O0O_o(0) WHEN wire_ni1Oii_o(4) = '1'  ELSE wire_ni1Oil_dataout;
	wire_ni1O1O_dataout <= wire_ni1O0O_o(1) WHEN wire_ni1Oii_o(4) = '1'  ELSE wire_ni1OiO_dataout;
	wire_ni1Oi_dataout <= wire_ni1ll_dataout AND NOT(n1O1lO);
	wire_ni1Oil_dataout <= ni1llO AND n100iO;
	wire_ni1OiO_dataout <= ni1lOi AND n100iO;
	wire_ni1Ol_dataout <= wire_ni1OO_dataout AND NOT(n1O1lO);
	wire_ni1Oll_dataout <= ni1lOl AND n100iO;
	wire_ni1OlO_dataout <= ni1lOO AND n100iO;
	wire_ni1OO_dataout <= nl1li AND NOT(n1O1Oi);
	wire_nii0i_dataout <= SYNC_COMP_PAT(8) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(0));
	wire_nii0l_dataout <= SYNC_COMP_PAT(9) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(1));
	wire_nii0O_dataout <= SYNC_COMP_PAT(10) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(2));
	wire_nii1i_dataout <= wire_niill_dataout AND NOT(n1O1lO);
	wire_nii1l_dataout <= wire_niilO_dataout AND NOT(n1O1lO);
	wire_nii1O_dataout <= wire_niiOi_dataout AND NOT(n1O1lO);
	wire_niii1i_dataout <= n10i0O WHEN PMADATAWIDTH = '1'  ELSE n10iii;
	wire_niii1i_w_lg_dataout2009w(0) <= NOT wire_niii1i_dataout;
	wire_niiii_dataout <= SYNC_COMP_PAT(11) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(3));
	wire_niiil_dataout <= SYNC_COMP_PAT(12) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(4));
	wire_niiiO_dataout <= SYNC_COMP_PAT(13) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(5));
	wire_niil0i_dataout <= (wire_w_lg_w_lg_PMADATAWIDTH131w1988w(0) OR (PMADATAWIDTH AND n1ii1i)) AND nii11i;
	wire_niil0l_dataout <= n10lii AND nii11i;
	wire_niil0O_dataout <= n10liO AND nii11i;
	wire_niil1l_dataout <= (wire_w_lg_n10iOl1991w(0) OR (wire_w_lg_n10iOi1992w(0) OR (wire_w_lg_n10ilO1993w(0) OR (wire_w_lg_n10ill1994w(0) OR (wire_w_lg_n10ili1995w(0) OR (wire_w_lg_n10iiO1996w(0) OR wire_w_lg_n10iil1997w(0))))))) AND nii11i;
	wire_niil1O_dataout <= (n1il1i OR n1iiOO) AND nii11i;
	wire_niili_dataout <= SYNC_COMP_PAT(14) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(6));
	wire_niilii_dataout <= (((wire_w_lg_n10lOO1920w(0) OR wire_w_lg_n10lOl1922w(0)) OR wire_w_lg_n10lOi1930w(0)) OR wire_w_lg_n10llO1986w(0)) AND nii11i;
	wire_niilil_dataout <= (wire_w_lg_n1i01l1978w(0) OR (NOT ((wire_w_lg_n1ii1i1979w(0) OR n1i01O) OR n1i01l))) AND nii11i;
	wire_niiliO_dataout <= niiilO AND nii11i;
	wire_niill_dataout <= SYNC_COMP_PAT(15) WHEN n1O1Oi = '1'  ELSE (NOT SYNC_COMP_PAT(7));
	wire_niilli_dataout <= niiiOi AND nii11i;
	wire_niilll_dataout <= niiiOl AND nii11i;
	wire_niillO_dataout <= niiiOO AND nii11i;
	wire_niilO_dataout <= (NOT SYNC_COMP_PAT(8)) AND NOT(n1O1Oi);
	wire_niilOi_dataout <= n10O1l AND nii11i;
	wire_niilOl_dataout <= n10O0i AND nii11i;
	wire_niilOO_dataout <= (((wire_w_lg_n10Oli1865w(0) OR wire_w_lg_n10OiO1867w(0)) OR wire_w_lg_n10Oil1875w(0)) OR wire_w_lg_n10Oii1976w(0)) AND nii11i;
	wire_niiO1i_dataout <= (wire_w_lg_n1i0ll1968w(0) OR (NOT ((wire_w_lg_n1i0OO1969w(0) OR n1i0Oi) OR n1i0ll))) AND nii11i;
	wire_niiOi_dataout <= (NOT SYNC_COMP_PAT(9)) AND NOT(n1O1Oi);
	wire_niiOl_dataout <= SYNC_COMP_PAT(7) AND NOT(n1O1lO);
	wire_niiOO_dataout <= wire_nil1l_dataout AND NOT(n1O1lO);
	wire_niiOOO_dataout <= (wire_w_lg_n10l0O1955w(0) OR (wire_w_lg_n10l0l1956w(0) OR (wire_w_lg_n10l0i1957w(0) OR (wire_w_lg_n10l1O1958w(0) OR (wire_w_lg_n10l1l1959w(0) OR (wire_w_lg_n10l1i1960w(0) OR wire_w_lg_n10iOO1961w(0))))))) AND nii11i;
	wire_nil10i_dataout <= (((wire_w_lg_n1i10l1810w(0) OR wire_w_lg_n1i10i1812w(0)) OR wire_w_lg_n1i11O1820w(0)) OR wire_w_lg_n1i11l1951w(0)) AND nii11i;
	wire_nil10l_dataout <= (wire_w_lg_n1il1l1944w(0) OR (NOT ((n1iO1i OR n1il1O) OR n1il1l))) AND nii11i;
	wire_nil10O_dataout <= niiOll AND nii11i;
	wire_nil11i_dataout <= (wire_w_lg_w_lg_PMADATAWIDTH131w1953w(0) OR wire_w_lg_PMADATAWIDTH1605w(0)) AND nii11i;
	wire_nil11l_dataout <= n10OlO AND nii11i;
	wire_nil11O_dataout <= n10OOl AND nii11i;
	wire_nil1i_dataout <= wire_nil1O_dataout AND NOT(n1O1lO);
	wire_nil1ii_dataout <= niiOlO AND nii11i;
	wire_nil1il_dataout <= niiOOi AND nii11i;
	wire_nil1iO_dataout <= niiOOl AND nii11i;
	wire_nil1l_dataout <= SYNC_COMP_PAT(8) AND NOT(n1O1Oi);
	wire_nil1li_dataout <= n1i1ii AND nii11i;
	wire_nil1ll_dataout <= n1i1iO AND nii11i;
	wire_nil1lO_dataout <= (((wire_w_lg_n1i1OO1756w(0) OR wire_w_lg_n1i1Ol1758w(0)) OR wire_w_lg_n1i1Oi1766w(0)) OR wire_w_lg_n1i1lO1942w(0)) AND nii11i;
	wire_nil1O_dataout <= SYNC_COMP_PAT(9) AND NOT(n1O1Oi);
	wire_nil1Oi_dataout <= (wire_w_lg_n1illl1934w(0) OR (NOT ((wire_w_lg_n1ilOO1935w(0) OR n1ilOi) OR n1illl))) AND nii11i;
	wire_nl00i_dataout <= nl11l WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE niOOO;
	wire_nl00l_dataout <= nl11O WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl11i;
	wire_nl00O_dataout <= nl10i WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl11l;
	wire_nl01i_dataout <= niOOl WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE niOlO;
	wire_nl01l_dataout <= niOOO WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE niOOi;
	wire_nl01O_dataout <= nl11i WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE niOOl;
	wire_nl0ii_dataout <= nl10l WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl11O;
	wire_nl0il_dataout <= nl10O WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl10i;
	wire_nl0iO_dataout <= nl1ii WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl10l;
	wire_nl0li_dataout <= nl1il WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl10O;
	wire_nl0ll_dataout <= nl1iO WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl1ii;
	wire_nl0lO_dataout <= nl1li WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl1il;
	wire_nl0Oi_dataout <= nl1ll WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl1iO;
	wire_nl0Ol_dataout <= nl1Oi WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE nl1li;
	wire_nl0OO_dataout <= PUDR(0) WHEN LP10BEN = '1'  ELSE PUDI(0);
	wire_nl1Ol_dataout <= niOlO WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE niOli;
	wire_nl1OO_dataout <= niOOi WHEN wire_w_lg_PMADATAWIDTH131w(0) = '1'  ELSE niOll;
	wire_nli0i_dataout <= PUDR(4) WHEN LP10BEN = '1'  ELSE PUDI(4);
	wire_nli0l_dataout <= PUDR(5) WHEN LP10BEN = '1'  ELSE PUDI(5);
	wire_nli0O_dataout <= PUDR(6) WHEN LP10BEN = '1'  ELSE PUDI(6);
	wire_nli1i_dataout <= PUDR(1) WHEN LP10BEN = '1'  ELSE PUDI(1);
	wire_nli1l_dataout <= PUDR(2) WHEN LP10BEN = '1'  ELSE PUDI(2);
	wire_nli1O_dataout <= PUDR(3) WHEN LP10BEN = '1'  ELSE PUDI(3);
	wire_nliii_dataout <= PUDR(7) WHEN LP10BEN = '1'  ELSE PUDI(7);
	wire_nliil_dataout <= PUDR(8) WHEN LP10BEN = '1'  ELSE PUDI(8);
	wire_nliiO_dataout <= PUDR(9) WHEN LP10BEN = '1'  ELSE PUDI(9);
	wire_nliOl_dataout <= n1O0OO OR n1O00O;
	wire_nliOO_dataout <= n1O0OO AND NOT(n1O00O);
	wire_nll0i_dataout <= wire_w_lg_n1O00O64w(0) AND NOT(n1O0OO);
	wire_nll1i_dataout <= wire_w_lg_n1O0OO65w(0) AND NOT(n1O00O);
	wire_nll1l_dataout <= n1O00O OR n1O0OO;
	wire_nll1O_dataout <= n1O00O AND NOT(n1O0OO);
	wire_nlOi0O_dataout <= SYNC_COMP_PAT(0) WHEN n1l0li = '1'  ELSE wire_nlOl1i_dataout;
	wire_nlOiii_dataout <= SYNC_COMP_PAT(1) WHEN n1l0li = '1'  ELSE wire_nlOl1l_dataout;
	wire_nlOiil_dataout <= SYNC_COMP_PAT(2) WHEN n1l0li = '1'  ELSE wire_nlOl1O_dataout;
	wire_nlOiiO_dataout <= SYNC_COMP_PAT(3) WHEN n1l0li = '1'  ELSE wire_nlOl0i_dataout;
	wire_nlOili_dataout <= SYNC_COMP_PAT(4) WHEN n1l0li = '1'  ELSE wire_nlOl0l_dataout;
	wire_nlOill_dataout <= SYNC_COMP_PAT(5) WHEN n1l0li = '1'  ELSE wire_nlOl0O_dataout;
	wire_nlOilO_dataout <= SYNC_COMP_PAT(6) WHEN n1l0li = '1'  ELSE wire_nlOlii_dataout;
	wire_nlOiOi_dataout <= SYNC_COMP_PAT(7) WHEN n1l0li = '1'  ELSE wire_nlOlil_dataout;
	wire_nlOiOl_dataout <= nlO10O WHEN n1l0li = '1'  ELSE wire_nlOliO_dataout;
	wire_nlOiOO_dataout <= wire_nlOlli_dataout AND NOT(n1l0li);
	wire_nlOl0i_dataout <= nlO11i WHEN n1l0iO = '1'  ELSE nlO00i;
	wire_nlOl0l_dataout <= nlO11l WHEN n1l0iO = '1'  ELSE nlO00l;
	wire_nlOl0O_dataout <= nlO11O WHEN n1l0iO = '1'  ELSE nlO00O;
	wire_nlOl1i_dataout <= nllOOi WHEN n1l0iO = '1'  ELSE nlO01i;
	wire_nlOl1l_dataout <= nllOOl WHEN n1l0iO = '1'  ELSE nlO01l;
	wire_nlOl1O_dataout <= nllOOO WHEN n1l0iO = '1'  ELSE nlO01O;
	wire_nlOlii_dataout <= nlO10i WHEN n1l0iO = '1'  ELSE nlO0ii;
	wire_nlOlil_dataout <= nlO10l WHEN n1l0iO = '1'  ELSE nlO0il;
	wire_nlOliO_dataout <= nlO10O WHEN n1l0iO = '1'  ELSE nlO0iO;
	wire_nlOlli_dataout <= nlO0li AND NOT(n1l0iO);
	wire_nlOlOO_dataout <= SYNC_COMP_PAT(0) WHEN n1l0ll = '1'  ELSE nlO1ii;
	wire_nlOO0i_dataout <= SYNC_COMP_PAT(4) WHEN n1l0ll = '1'  ELSE nlO1ll;
	wire_nlOO0l_dataout <= SYNC_COMP_PAT(5) WHEN n1l0ll = '1'  ELSE nlO1lO;
	wire_nlOO0O_dataout <= SYNC_COMP_PAT(6) WHEN n1l0ll = '1'  ELSE nlO1Oi;
	wire_nlOO1i_dataout <= SYNC_COMP_PAT(1) WHEN n1l0ll = '1'  ELSE nlO1il;
	wire_nlOO1l_dataout <= SYNC_COMP_PAT(2) WHEN n1l0ll = '1'  ELSE nlO1iO;
	wire_nlOO1O_dataout <= SYNC_COMP_PAT(3) WHEN n1l0ll = '1'  ELSE nlO1li;
	wire_nlOOii_dataout <= SYNC_COMP_PAT(7) WHEN n1l0ll = '1'  ELSE nlO1Ol;
	wire_n01iiO_a <= ( n1Olli & n1Ol0O);
	wire_n01iiO_b <= ( "0" & "1");
	n01iiO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_n01iiO_a,
		b => wire_n01iiO_b,
		cin => wire_gnd,
		o => wire_n01iiO_o
	  );
	wire_n1ili_a <= ( n10OO & n10Oi & n10lO & n10li & "1");
	wire_n1ili_b <= ( "1" & "1" & "1" & "0" & "1");
	n1ili :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_n1ili_a,
		b => wire_n1ili_b,
		cin => wire_gnd,
		o => wire_n1ili_o
	  );
	wire_ni0lOO_a <= ( "0" & "0" & wire_w_lg_n10i0l2156w & RUNDISP_SEL(4 DOWNTO 2));
	wire_ni0lOO_b <= ( wire_w_lg_n10i0l2156w & RUNDISP_SEL(4 DOWNTO 0));
	ni0lOO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_ni0lOO_a,
		b => wire_ni0lOO_b,
		cin => wire_gnd,
		o => wire_ni0lOO_o
	  );
	wire_ni1O0O_a <= ( wire_ni1OlO_dataout & wire_ni1Oll_dataout & wire_ni1OiO_dataout & wire_ni1Oil_dataout);
	wire_ni1O0O_b <= ( "0" & "0" & "0" & "1");
	ni1O0O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_ni1O0O_a,
		b => wire_ni1O0O_b,
		cin => wire_gnd,
		o => wire_ni1O0O_o
	  );
	wire_ni1Oii_a <= ( "0" & wire_ni010O_o & wire_ni010l_o & wire_ni010i_o & wire_ni011O_o);
	wire_ni1Oii_b <= ( "0" & wire_ni011i_o & wire_ni1OOO_o & wire_ni1OOl_o & wire_ni1OOi_o);
	ni1Oii :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_ni1Oii_a,
		b => wire_ni1Oii_b,
		cin => wire_gnd,
		o => wire_ni1Oii_o
	  );
	wire_ni0OOl_a <= ( wire_ni0lOl_dataout & wire_ni0lOi_dataout & wire_ni0llO_dataout & wire_ni0lll_dataout & wire_ni0lli_dataout & wire_ni0liO_dataout & wire_ni0lil_dataout & wire_ni0lii_dataout);
	wire_ni0OOl_b <= ( ni1lOO & ni1lOl & ni1lOi & ni1llO & ni1lll & ni1lli & ni1liO & ni1Oli);
	ni0OOl :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8
	  )
	  PORT MAP ( 
		a => wire_ni0OOl_a,
		b => wire_ni0OOl_b,
		cin => wire_gnd,
		o => wire_ni0OOl_o
	  );
	wire_n00i0l_data <= ( wire_n00i0O_dataout & "0" & n1O1ll & "0");
	wire_n00i0l_sel <= ( n0i1lO & n0i1ll);
	n00i0l :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00i0l_data,
		o => wire_n00i0l_o,
		sel => wire_n00i0l_sel
	  );
	wire_n00ili_data <= ( wire_n00ill_dataout & "0" & n1O11O & "0");
	wire_n00ili_sel <= ( n0i1li & n0i1iO);
	n00ili :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00ili_data,
		o => wire_n00ili_o,
		sel => wire_n00ili_sel
	  );
	wire_n00iOO_data <= ( wire_n00l1i_dataout & "0" & n1lOlO & "0");
	wire_n00iOO_sel <= ( n0i1il & n0i1ii);
	n00iOO :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00iOO_data,
		o => wire_n00iOO_o,
		sel => wire_n00iOO_sel
	  );
	wire_n00l0l_data <= ( wire_n00l0O_dataout & "0" & n1lO0i & "0");
	wire_n00l0l_sel <= ( n0i10O & n0i10l);
	n00l0l :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00l0l_data,
		o => wire_n00l0l_o,
		sel => wire_n00l0l_sel
	  );
	wire_n00lli_data <= ( wire_n00lll_dataout & "0" & n1llOi & "0");
	wire_n00lli_sel <= ( n0i10i & n0i11O);
	n00lli :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00lli_data,
		o => wire_n00lli_o,
		sel => wire_n00lli_sel
	  );
	wire_n00lOO_data <= ( wire_n00O1i_dataout & "0" & n1llll & "0");
	wire_n00lOO_sel <= ( n0i11l & n0i11i);
	n00lOO :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00lOO_data,
		o => wire_n00lOO_o,
		sel => wire_n00lOO_sel
	  );
	wire_n00O0l_data <= ( wire_n00O0O_dataout & "0" & n1lliO & "0");
	wire_n00O0l_sel <= ( n00OOO & n00OOl);
	n00O0l :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00O0l_data,
		o => wire_n00O0l_o,
		sel => wire_n00O0l_sel
	  );
	wire_n00Oli_data <= ( wire_n00Oll_dataout & "0" & n1llii & "0");
	wire_n00Oli_sel <= ( n00OOi & n00OlO);
	n00Oli :  oper_mux
	  GENERIC MAP (
		width_data => 4,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n00Oli_data,
		o => wire_n00Oli_o,
		sel => wire_n00Oli_sel
	  );
	wire_n100i_data <= ( niOOO & niOOO & niOOO & niOOO & niOOO & niOOO & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO & nl11i & nl11l & niOOO & niOOO & niOOO & niOOO & niOOO & niOOO & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO);
	wire_n100i_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n100i :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n100i_data,
		o => wire_n100i_o,
		sel => wire_n100i_sel
	  );
	wire_n100l_data <= ( nl11i & nl11i & nl11i & nl11i & nl11i & nl11i & n11iO & n11iO & n11iO & n11iO & n11iO & n11iO & n11iO & n11iO & n11iO & n11iO & nl11i & nl11i & nl11i & nl11i & nl11i & nl11i & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO & nl11i);
	wire_n100l_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n100l :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n100l_data,
		o => wire_n100l_o,
		sel => wire_n100l_sel
	  );
	wire_n100O_data <= ( nl11l & nl11l & nl11l & nl11l & nl11l & nl11l & n11li & n11li & n11li & n11li & n11li & n11li & n11li & n11li & n11li & n11li & nl11l & nl11l & nl11l & nl11l & nl11l & nl11l & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO & nl11i & nl11l);
	wire_n100O_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n100O :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n100O_data,
		o => wire_n100O_o,
		sel => wire_n100O_sel
	  );
	wire_n101i_data <= ( niOlO & niOlO & niOlO & niOlO & niOlO & niOlO & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOlO & niOlO & niOlO & niOlO & niOlO & niOlO & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO);
	wire_n101i_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n101i :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n101i_data,
		o => wire_n101i_o,
		sel => wire_n101i_sel
	  );
	wire_n101l_data <= ( niOOi & niOOi & niOOi & niOOi & niOOi & niOOi & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO & niOOi & niOOi & niOOi & niOOi & niOOi & niOOi & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi);
	wire_n101l_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n101l :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n101l_data,
		o => wire_n101l_o,
		sel => wire_n101l_sel
	  );
	wire_n101O_data <= ( niOOl & niOOl & niOOl & niOOl & niOOl & niOOl & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl & niOOO & nl11i & niOOl & niOOl & niOOl & niOOl & niOOl & niOOl & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOOl);
	wire_n101O_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n101O :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n101O_data,
		o => wire_n101O_o,
		sel => wire_n101O_sel
	  );
	wire_n11lO_data <= ( niOil & niOil & niOil & niOil & niOil & niOil & niO1i & niO1l & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOil & niOil & niOil & niOil & niOil & niOil & nilOl & nilOO & niO1i & niO1l & niO1O & niO0i & niO0l & niO0O & niOii & niOil);
	wire_n11lO_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n11lO :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n11lO_data,
		o => wire_n11lO_o,
		sel => wire_n11lO_sel
	  );
	wire_n11Oi_data <= ( niOiO & niOiO & niOiO & niOiO & niOiO & niOiO & niO1l & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOiO & niOiO & niOiO & niOiO & niOiO & niOiO & nilOO & niO1i & niO1l & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO);
	wire_n11Oi_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n11Oi :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n11Oi_data,
		o => wire_n11Oi_o,
		sel => wire_n11Oi_sel
	  );
	wire_n11Ol_data <= ( niOli & niOli & niOli & niOli & niOli & niOli & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOli & niOli & niOli & niOli & niOli & niOli & niO1i & niO1l & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli);
	wire_n11Ol_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n11Ol :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n11Ol_data,
		o => wire_n11Ol_o,
		sel => wire_n11Ol_sel
	  );
	wire_n11OO_data <= ( niOll & niOll & niOll & niOll & niOll & niOll & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll & niOlO & niOOi & niOll & niOll & niOll & niOll & niOll & niOll & niO1l & niO1O & niO0i & niO0l & niO0O & niOii & niOil & niOiO & niOli & niOll);
	wire_n11OO_sel <= ( PMADATAWIDTH & wire_n01ii_dataout & wire_n010O_dataout & wire_n010l_dataout & wire_n010i_dataout);
	n11OO :  oper_mux
	  GENERIC MAP (
		width_data => 32,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_n11OO_data,
		o => wire_n11OO_o,
		sel => wire_n11OO_sel
	  );
	wire_n0110i_data <= ( "0" & wire_n01Oii_dataout & wire_n01lOO_dataout);
	wire_n0110i_sel <= ( n11O1i & n001Oi & n001li);
	n0110i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0110i_data,
		o => wire_n0110i_o,
		sel => wire_n0110i_sel
	  );
	wire_n0110O_data <= ( "0" & wire_n01Oil_dataout & wire_n01O1i_dataout & wire_n01l1O_dataout);
	wire_n0110O_sel <= ( n11O1l & n001lO & n001iO & n001ll);
	n0110O :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n0110O_data,
		o => wire_n0110O_o,
		sel => wire_n0110O_sel
	  );
	wire_n0111l_data <= ( "0" & wire_n01Oii_dataout & wire_n01lOO_dataout);
	wire_n0111l_sel <= ( n11lOO & n001lO & n001iO);
	n0111l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0111l_data,
		o => wire_n0111l_o,
		sel => wire_n0111l_sel
	  );
	wire_n011il_data <= ( "0" & wire_n01Oil_dataout & wire_n01O1i_dataout & wire_n01OiO_dataout);
	wire_n011il_sel <= ( n11O1O & n001Oi & n001li & n001lO);
	n011il :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n011il_data,
		o => wire_n011il_o,
		sel => wire_n011il_sel
	  );
	wire_n011li_data <= ( wire_w_lg_n1011i2824w & wire_n01OiO_dataout & "0");
	wire_n011li_sel <= ( n001Ol & n001Oi & n11O0i);
	n011li :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n011li_data,
		o => wire_n011li_o,
		sel => wire_n011li_sel
	  );
	wire_n011lO_data <= ( n1011i & n11OOl & n11OiO & n11OOl & n11OiO & n11Oil & wire_nillO_w_lg_n0001i2740w & wire_nillO_w_lg_n0001i2740w & wire_nillO_w_lg_n0001i2740w & wire_nillO_w_lg_n0001i2740w & wire_nillO_w_lg_n0001i2740w & n11OiO & n11OiO);
	wire_n011lO_sel <= ( n001Ol & n001Oi & n001li & n001lO & n001iO & n001ll & n001il & n001ii & n0010O & n0010l & n0010i & n0011O & n1Olll);
	n011lO :  oper_selector
	  GENERIC MAP (
		width_data => 13,
		width_sel => 13
	  )
	  PORT MAP ( 
		data => wire_n011lO_data,
		o => wire_n011lO_o,
		sel => wire_n011lO_sel
	  );
	wire_n1OllO_data <= ( "0" & wire_n01i0i_dataout & wire_n010ii_dataout & wire_n01i0i_dataout & wire_n010ii_dataout & wire_n0101O_dataout & wire_n011Oi_dataout);
	wire_n1OllO_sel <= ( n11lii & n001ii & n0010O & n0010l & n0010i & n0011O & n1Olll);
	n1OllO :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_n1OllO_data,
		o => wire_n1OllO_o,
		sel => wire_n1OllO_sel
	  );
	wire_n1OlOi_data <= ( "0" & wire_n01i0l_dataout & wire_n010il_dataout & wire_n01i0l_dataout & wire_n010il_dataout & wire_n0100i_dataout & wire_n011Ol_dataout);
	wire_n1OlOi_sel <= ( n11lii & n001ii & n0010O & n0010l & n0010i & n0011O & n1Olll);
	n1OlOi :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_n1OlOi_data,
		o => wire_n1OlOi_o,
		sel => wire_n1OlOi_sel
	  );
	wire_n1OlOO_data <= ( n0101l & wire_n01iOO_dataout & wire_n01ill_dataout & wire_n01ill_dataout & wire_n01ill_dataout & wire_n01ill_dataout & wire_n01ill_dataout & wire_n0100l_dataout & wire_n0100l_dataout);
	wire_n1OlOO_sel <= ( n11lil & n001ll & n001il & n001ii & n0010O & n0010l & n0010i & n0011O & n1Olll);
	n1OlOO :  oper_selector
	  GENERIC MAP (
		width_data => 9,
		width_sel => 9
	  )
	  PORT MAP ( 
		data => wire_n1OlOO_data,
		o => wire_n1OlOO_o,
		sel => wire_n1OlOO_sel
	  );
	wire_n1OO0i_data <= ( "0" & wire_w_lg_n11OiO2992w & wire_n011OO_dataout);
	wire_n1OO0i_sel <= ( n11liO & n0011O & n1Olll);
	n1OO0i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OO0i_data,
		o => wire_n1OO0i_o,
		sel => wire_n1OO0i_sel
	  );
	wire_n1OO0O_data <= ( "0" & wire_n01ilO_dataout);
	wire_n1OO0O_sel <= ( n11lli & wire_w_lg_n11lli2976w);
	n1OO0O :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_n1OO0O_data,
		o => wire_n1OO0O_o,
		sel => wire_n1OO0O_sel
	  );
	wire_n1OO1l_data <= ( wire_n01OOO_dataout & wire_n01O0O_dataout & wire_n01lOl_dataout & wire_n01O0O_dataout & wire_n01lOl_dataout & wire_n01l1i_dataout & wire_n01ili_dataout & wire_n01ili_dataout & wire_n01ili_dataout & wire_n01ili_dataout & wire_n01ili_dataout & wire_n01lOl_dataout & wire_n01lOl_dataout);
	wire_n1OO1l_sel <= ( n001Ol & n001Oi & n001li & n001lO & n001iO & n001ll & n001il & n001ii & n0010O & n0010l & n0010i & n0011O & n1Olll);
	n1OO1l :  oper_selector
	  GENERIC MAP (
		width_data => 13,
		width_sel => 13
	  )
	  PORT MAP ( 
		data => wire_n1OO1l_data,
		o => wire_n1OO1l_o,
		sel => wire_n1OO1l_sel
	  );
	wire_n1OO1O_data <= ( wire_n0011i_dataout & wire_n01O0l_dataout & wire_n01lOi_dataout & wire_n01O0l_dataout & wire_n01lOi_dataout & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w & wire_nillO_w_lg_n1Ol0i2743w);
	wire_n1OO1O_sel <= ( n001Ol & n001Oi & n001li & n001lO & n001iO & n001ll & n001il & n001ii & n0010O & n0010l & n0010i & n0011O & n1Olll);
	n1OO1O :  oper_selector
	  GENERIC MAP (
		width_data => 13,
		width_sel => 13
	  )
	  PORT MAP ( 
		data => wire_n1OO1O_data,
		o => wire_n1OO1O_o,
		sel => wire_n1OO1O_sel
	  );
	wire_n1OOii_data <= ( "0" & wire_n01i0O_dataout & wire_n010iO_dataout);
	wire_n1OOii_sel <= ( n11lli & n0010l & n0010i);
	n1OOii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OOii_data,
		o => wire_n1OOii_o,
		sel => wire_n1OOii_sel
	  );
	wire_n1OOiO_data <= ( "0" & wire_n01ilO_dataout & wire_n01ilO_dataout & wire_n0101i_dataout);
	wire_n1OOiO_sel <= ( n11lll & n001ii & n0010O & n1Olll);
	n1OOiO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OOiO_data,
		o => wire_n1OOiO_o,
		sel => wire_n1OOiO_sel
	  );
	wire_n1OOll_data <= ( "0" & wire_n01i0O_dataout & wire_n010iO_dataout);
	wire_n1OOll_sel <= ( n11llO & n001ii & n0010O);
	n1OOll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OOll_data,
		o => wire_n1OOll_o,
		sel => wire_n1OOll_sel
	  );
	wire_n1OOOi_data <= ( "0" & wire_n01ilO_dataout & wire_n010li_dataout);
	wire_n1OOOi_sel <= ( n11lOi & n001il & n0010i);
	n1OOOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1OOOi_data,
		o => wire_n1OOOi_o,
		sel => wire_n1OOOi_sel
	  );
	wire_n1OOOO_data <= ( "0" & wire_n01l1l_dataout & wire_n01iOi_dataout & wire_n010li_dataout);
	wire_n1OOOO_sel <= ( n11lOl & n001ll & n001il & n0010O);
	n1OOOO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OOOO_data,
		o => wire_n1OOOO_o,
		sel => wire_n1OOOO_sel
	  );
	wire_ni010i_data <= ( "0" & niiO0i & wire_ni0i1i_dataout & niii0l & wire_ni000l_dataout);
	wire_ni010i_sel <= ( n100Ol & n100ll & ni0l1i & n100li & ni1O1i);
	ni010i :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni010i_data,
		o => wire_ni010i_o,
		sel => wire_ni010i_sel
	  );
	wire_ni010l_data <= ( "0" & niiO0l & wire_ni0i1l_dataout & niii0O & wire_ni000O_dataout);
	wire_ni010l_sel <= ( n100Ol & n100ll & ni0l1i & n100li & ni1O1i);
	ni010l :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni010l_data,
		o => wire_ni010l_o,
		sel => wire_ni010l_sel
	  );
	wire_ni010O_data <= ( "0" & niiO0O & wire_ni0i1O_dataout & niiiii & wire_ni00ii_dataout);
	wire_ni010O_sel <= ( n100Ol & n100ll & ni0l1i & n100li & ni1O1i);
	ni010O :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni010O_data,
		o => wire_ni010O_o,
		sel => wire_ni010O_sel
	  );
	wire_ni011i_data <= ( "0" & niiOli & ni1lll & niiill);
	wire_ni011i_sel <= ( n100Ol & n100ll & n100iO & n100li);
	ni011i :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni011i_data,
		o => wire_ni011i_o,
		sel => wire_ni011i_sel
	  );
	wire_ni011O_data <= ( "0" & niiO1O & wire_ni00OO_dataout & niii0i & wire_ni000i_dataout);
	wire_ni011O_sel <= ( n100Ol & n100ll & ni0l1i & n100li & ni1O1i);
	ni011O :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_ni011O_data,
		o => wire_ni011O_o,
		sel => wire_ni011O_sel
	  );
	wire_ni01iO_data <= ( "0" & wire_ni00il_dataout);
	wire_ni01iO_sel <= ( n100lO & wire_w_lg_n100lO2238w);
	ni01iO :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_ni01iO_data,
		o => wire_ni01iO_o,
		sel => wire_ni01iO_sel
	  );
	wire_ni01ll_data <= ( "0" & wire_ni0i0l_dataout & wire_ni0i0l_dataout & wire_ni0i0l_dataout & wire_ni00iO_dataout & wire_ni00iO_dataout & wire_ni00iO_dataout);
	wire_ni01ll_sel <= ( n100Ol & ni0l1O & ni0l1l & ni0l1i & ni0iOO & ni0iOl & ni1O1i);
	ni01ll :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_ni01ll_data,
		o => wire_ni01ll_o,
		sel => wire_ni01ll_sel
	  );
	wire_ni01Oi_data <= ( "0" & wire_ni0i0O_dataout);
	wire_ni01Oi_sel <= ( n100Oi & wire_w_lg_n100Oi2210w);
	ni01Oi :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_ni01Oi_data,
		o => wire_ni01Oi_o,
		sel => wire_ni01Oi_sel
	  );
	wire_ni01OO_data <= ( "0" & wire_ni0iii_dataout & wire_ni0iii_dataout & wire_ni0iii_dataout & wire_ni00li_dataout & wire_ni00li_dataout & wire_ni00li_dataout);
	wire_ni01OO_sel <= ( n100Ol & ni0l1O & ni0l1l & ni0l1i & ni0iOO & ni0iOl & ni1O1i);
	ni01OO :  oper_selector
	  GENERIC MAP (
		width_data => 7,
		width_sel => 7
	  )
	  PORT MAP ( 
		data => wire_ni01OO_data,
		o => wire_ni01OO_o,
		sel => wire_ni01OO_sel
	  );
	wire_ni1OOi_data <= ( "0" & niiOii & ni1Oli & niiiil);
	wire_ni1OOi_sel <= ( n100Ol & n100ll & n100iO & n100li);
	ni1OOi :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1OOi_data,
		o => wire_ni1OOi_o,
		sel => wire_ni1OOi_sel
	  );
	wire_ni1OOl_data <= ( "0" & niiOil & ni1liO & niiiiO);
	wire_ni1OOl_sel <= ( n100Ol & n100ll & n100iO & n100li);
	ni1OOl :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1OOl_data,
		o => wire_ni1OOl_o,
		sel => wire_ni1OOl_sel
	  );
	wire_ni1OOO_data <= ( "0" & niiOiO & ni1lli & niiili);
	wire_ni1OOO_sel <= ( n100Ol & n100ll & n100iO & n100li);
	ni1OOO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1OOO_data,
		o => wire_ni1OOO_o,
		sel => wire_ni1OOO_sel
	  );
	wire_nlili_data <= ( wire_nll1l_dataout & wire_nliOl_dataout & "0");
	wire_nlili_sel <= ( nlllO & nllli & nllil);
	nlili :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlili_data,
		o => wire_nlili_o,
		sel => wire_nlili_sel
	  );
	wire_nlill_data <= ( wire_n1O01i24_w_lg_w_lg_q99w100w & wire_n1O01l22_w_lg_w_lg_q96w97w & n0000l);
	wire_nlill_sel <= ( nlllO & nllli & wire_n1O01O20_w_lg_w_lg_q88w89w);
	nlill :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlill_data,
		o => wire_nlill_o,
		sel => wire_nlill_sel
	  );
	wire_nlilO_data <= ( n1O0OO & wire_nliOO_dataout & "0");
	wire_nlilO_sel <= ( nlllO & wire_n1O00i18_w_lg_w_lg_q79w80w & nllil);
	nlilO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlilO_data,
		o => wire_nlilO_o,
		sel => wire_nlilO_sel
	  );
	wire_nliOi_data <= ( wire_nll0i_dataout & wire_nll1i_dataout & wire_nlliO_w_lg_n0000l72w);
	wire_nliOi_sel <= ( nlllO & wire_n1O00l16_w_lg_w_lg_q68w69w & nllil);
	nliOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nliOi_data,
		o => wire_nliOi_o,
		sel => wire_nliOi_sel
	  );
	wire_nlOOil_data <= ( SYNC_COMP_PAT(8) & SYNC_COMP_PAT(0) & nlO01i);
	wire_nlOOil_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOil :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOil_data,
		o => wire_nlOOil_o,
		sel => wire_nlOOil_sel
	  );
	wire_nlOOiO_data <= ( SYNC_COMP_PAT(9) & SYNC_COMP_PAT(1) & nlO01l);
	wire_nlOOiO_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOiO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOiO_data,
		o => wire_nlOOiO_o,
		sel => wire_nlOOiO_sel
	  );
	wire_nlOOli_data <= ( SYNC_COMP_PAT(10) & SYNC_COMP_PAT(2) & nlO01O);
	wire_nlOOli_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOli :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOli_data,
		o => wire_nlOOli_o,
		sel => wire_nlOOli_sel
	  );
	wire_nlOOll_data <= ( SYNC_COMP_PAT(11) & SYNC_COMP_PAT(3) & nlO00i);
	wire_nlOOll_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOll_data,
		o => wire_nlOOll_o,
		sel => wire_nlOOll_sel
	  );
	wire_nlOOlO_data <= ( SYNC_COMP_PAT(12) & SYNC_COMP_PAT(4) & nlO00l);
	wire_nlOOlO_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOlO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOlO_data,
		o => wire_nlOOlO_o,
		sel => wire_nlOOlO_sel
	  );
	wire_nlOOOi_data <= ( SYNC_COMP_PAT(13) & SYNC_COMP_PAT(5) & nlO00O);
	wire_nlOOOi_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOOi_data,
		o => wire_nlOOOi_o,
		sel => wire_nlOOOi_sel
	  );
	wire_nlOOOl_data <= ( SYNC_COMP_PAT(14) & SYNC_COMP_PAT(6) & nlO0ii);
	wire_nlOOOl_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOOl :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOOl_data,
		o => wire_nlOOOl_o,
		sel => wire_nlOOOl_sel
	  );
	wire_nlOOOO_data <= ( SYNC_COMP_PAT(15) & SYNC_COMP_PAT(7) & nlO0il);
	wire_nlOOOO_sel <= ( n1l0Ol & n1l0Oi & wire_w_lg_n1l0lO774w);
	nlOOOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOOOO_data,
		o => wire_nlOOOO_o,
		sel => wire_nlOOOO_sel
	  );

 END RTL; --stratixgx_hssi_rx_wal_rtl
--synopsys translate_on
--VALID FILE
--
-- STRATIXGX_HSSI_WORD_ALIGNER
--

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_hssi_word_aligner IS
    generic (
        channel_width       : integer := 10;
        align_pattern_length: integer := 10;
        infiniband_invalid_code: integer := 0;
        align_pattern   : string := "0000000101111100";
        synchronization_mode: string := "XAUI";
        use_8b_10b_mode : string := "true";
        use_auto_bit_slip   : string := "true");
    PORT (
        datain                  : IN std_logic_vector(9 DOWNTO 0);   
        clk                     : IN std_logic;   
        softreset               : IN std_logic;   
        enacdet                 : IN std_logic;   
        bitslip                 : IN std_logic;   
        a1a2size                : IN std_logic;   
        aligneddata             : OUT std_logic_vector(9 DOWNTO 0);   
        aligneddatapre          : OUT std_logic_vector(9 DOWNTO 0);   
        invalidcode             : OUT std_logic;   
        invalidcodepre          : OUT std_logic;   
        syncstatus              : OUT std_logic;   
        syncstatusdeskew        : OUT std_logic;   
        disperr                 : OUT std_logic;   
        disperrpre              : OUT std_logic;   
        patterndetectpre        : OUT std_logic;   
        patterndetect           : OUT std_logic);   
END stratixgx_hssi_word_aligner;

ARCHITECTURE auto_translated OF stratixgx_hssi_word_aligner IS

    COMPONENT stratixgx_hssi_rx_wal_rtl
        PORT (
            rcvd_clk                : IN  std_logic;
            soft_reset              : IN  std_logic;
            LP10BEN                 : IN  std_logic;
            RLV_EN                  : IN  std_logic;
            RUNDISP_SEL             : IN  std_logic_vector(4 DOWNTO 0);
            PMADATAWIDTH            : IN  std_logic;
            SYNC_COMP_PAT           : IN  std_logic_vector(15 DOWNTO 0);
            SYNC_COMP_SIZE          : IN  std_logic_vector(1 DOWNTO 0);
            IB_INVALID_CODE         : IN  std_logic_vector(1 DOWNTO 0);
            AUTOBYTEALIGN_DIS       : IN  std_logic;
            BITSLIP                 : IN  std_logic;
            DISABLE_RX_DISP         : IN  std_logic;
            ENCDT                   : IN  std_logic;
            SYNC_SM_DIS             : IN  std_logic;
            prbs_en                 : IN  std_logic;
            encdet_prbs             : IN  std_logic;
            GE_XAUI_SEL             : IN  std_logic;
            signal_detect           : IN  std_logic;
            PUDI                    : IN  std_logic_vector(9 DOWNTO 0);
            PUDR                    : IN  std_logic_vector(9 DOWNTO 0);
            A1A2_SIZE               : IN  std_logic;
            DWIDTH                  : IN  std_logic;
            cg_comma                : OUT std_logic;
            sync_status             : OUT std_logic;
            signal_detect_sync      : OUT std_logic;
            SUDI                    : OUT std_logic_vector(12 DOWNTO 0);
            SUDI_pre                : OUT std_logic_vector(9 DOWNTO 0);
            RLV                     : OUT std_logic;
            RLV_lt                  : OUT std_logic;
            sync_curr_st            : OUT std_logic_vector(3 DOWNTO 0));
    END COMPONENT;


    -- input interface
    SIGNAL rcvd_clk                 :  std_logic;   
    SIGNAL soft_reset               :  std_logic;   
    SIGNAL LP10BEN                  :  std_logic;   
    SIGNAL RLV_EN                   :  std_logic;   
    SIGNAL RUNDISP_SEL              :  std_logic_vector(4 DOWNTO 0);   
    SIGNAL PMADATAWIDTH             :  std_logic;   
    SIGNAL SYNC_COMP_PAT            :  std_logic_vector(15 DOWNTO 0);   
    SIGNAL SYNC_COMP_SIZE           :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL IB_INVALID_CODE          :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL AUTOBYTEALIGN_DIS        :  std_logic;   
    SIGNAL SYNC_SM_DIS              :  std_logic;   
    SIGNAL GE_XAUI_SEL              :  std_logic;   
    SIGNAL encdet_prbs              :  std_logic;   
    SIGNAL BITSLIP_xhdl11           :  std_logic;   
    SIGNAL ENCDT                    :  std_logic;   
    SIGNAL prbs_en                  :  std_logic;   
    SIGNAL DISABLE_RX_DISP          :  std_logic;   
    SIGNAL signal_detect            :  std_logic;   
    SIGNAL PUDI                     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL PUDR                     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL A1A2_SIZE                :  std_logic;  
     
    -- A1A2 and A1A1A2A2 pattern detection
    SIGNAL DWIDTH                   :  std_logic;   

    -- output interface
    SIGNAL cg_comma                 :  std_logic;   
    SIGNAL sync_status              :  std_logic;   
    SIGNAL signal_detect_sync       :  std_logic;   
    SIGNAL SUDI                     :  std_logic_vector(12 DOWNTO 0);   
    SIGNAL SUDI_pre                 :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL RLV                      :  std_logic;   
    SIGNAL RLV_lt                   :  std_logic;   
    SIGNAL sync_curr_st             :  std_logic_vector(3 DOWNTO 0);   
    SIGNAL temp_xhdl12              :  std_logic;   
    SIGNAL temp_xhdl13              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl14              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl15              :  std_logic;   
    SIGNAL temp_xhdl16              :  std_logic;   
    SIGNAL temp_xhdl17              :  std_logic;   
    SIGNAL temp_xhdl18              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl19              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL temp_xhdl20              :  std_logic_vector(1 DOWNTO 0);   
    SIGNAL aligneddata_xhdl1        :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL aligneddatapre_xhdl2     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL invalidcode_xhdl3        :  std_logic;   
    SIGNAL invalidcodepre_xhdl4     :  std_logic;   
    SIGNAL syncstatus_xhdl5         :  std_logic;   
    SIGNAL syncstatusdeskew_xhdl6   :  std_logic;   
    SIGNAL disperr_xhdl7            :  std_logic;   
    SIGNAL disperrpre_xhdl8         :  std_logic;   
    SIGNAL patterndetect_xhdl9      :  std_logic;   
    SIGNAL patterndetectpre_xhdl10  :  std_logic;   

BEGIN
    aligneddata <= aligneddata_xhdl1;
    aligneddatapre <= aligneddatapre_xhdl2;
    invalidcode <= invalidcode_xhdl3;
    invalidcodepre <= invalidcodepre_xhdl4;
    syncstatus <= syncstatus_xhdl5;
    syncstatusdeskew <= syncstatusdeskew_xhdl6;
    disperr <= disperr_xhdl7;
    disperrpre <= disperrpre_xhdl8;
    patterndetect <= patterndetect_xhdl9;
    patterndetectpre <= patterndetectpre_xhdl10;
    RLV_EN <= '0' ;
    RUNDISP_SEL <= "01000" ;
    DWIDTH <= '0' ;
    LP10BEN <= '0' ;
    DISABLE_RX_DISP <= '0' ;
    temp_xhdl12 <= '1' WHEN (align_pattern_length = 16 OR align_pattern_length = 8) ELSE '0';
    PMADATAWIDTH <= temp_xhdl12 ;
    SYNC_COMP_PAT <= pattern_conversion(align_pattern) ;
    temp_xhdl13 <= "01" WHEN (align_pattern_length = 16 OR align_pattern_length = 8) ELSE "10";
    temp_xhdl14 <= "00" WHEN (align_pattern_length = 7) ELSE temp_xhdl13;
    SYNC_COMP_SIZE <= temp_xhdl14 ;
    temp_xhdl15 <= '1' WHEN (synchronization_mode = "none" OR synchronization_mode = "NONE") ELSE '0';
    SYNC_SM_DIS <= temp_xhdl15 ;
    temp_xhdl16 <= '1' WHEN (synchronization_mode = "gige" OR synchronization_mode = "GIGE") ELSE '0';
    GE_XAUI_SEL <= temp_xhdl16 ;
    temp_xhdl17 <= '0' WHEN (use_auto_bit_slip = "true" OR use_auto_bit_slip = "ON") ELSE '1';
    AUTOBYTEALIGN_DIS <= temp_xhdl17 ;
    temp_xhdl18 <= "10" WHEN (infiniband_invalid_code = 2) ELSE "11";
    temp_xhdl19 <= "01" WHEN (infiniband_invalid_code = 1) ELSE temp_xhdl18;
    temp_xhdl20 <= "00" WHEN (infiniband_invalid_code = 0) ELSE temp_xhdl19;
    IB_INVALID_CODE <= temp_xhdl20 ;
    prbs_en <= '0' ;
    encdet_prbs <= '0' ;
    signal_detect <= '1' ;
    rcvd_clk <= clk ;
    soft_reset <= softreset ;
    BITSLIP_xhdl11 <= bitslip ;
    ENCDT <= enacdet ;

    -- filtering X valus
    PUDI(0) <= datain(0) WHEN (datain(0) = '0' OR datain(0) = '1') ELSE '0';
    PUDI(1) <= datain(1) WHEN (datain(1) = '0' OR datain(1) = '1') ELSE '0';
    PUDI(2) <= datain(2) WHEN (datain(2) = '0' OR datain(2) = '1') ELSE '0';
    PUDI(3) <= datain(3) WHEN (datain(3) = '0' OR datain(3) = '1') ELSE '0';
    PUDI(4) <= datain(4) WHEN (datain(4) = '0' OR datain(4) = '1') ELSE '0';
    PUDI(5) <= datain(5) WHEN (datain(5) = '0' OR datain(5) = '1') ELSE '0';
    PUDI(6) <= datain(6) WHEN (datain(6) = '0' OR datain(6) = '1') ELSE '0';
    PUDI(7) <= datain(7) WHEN (datain(7) = '0' OR datain(7) = '1') ELSE '0';
    PUDI(8) <= datain(8) WHEN (datain(8) = '0' OR datain(8) = '1') ELSE '0';
    PUDI(9) <= datain(9) WHEN (datain(9) = '0' OR datain(9) = '1') ELSE '0';

    A1A2_SIZE <= a1a2size ;
    PUDR <= "XXXXXXXXXX" ;
    aligneddata_xhdl1 <= SUDI(9 DOWNTO 0) ;
    invalidcode_xhdl3 <= SUDI(10) ;
    syncstatus_xhdl5 <= SUDI(11) ;
    disperr_xhdl7 <= SUDI(12) ;
    syncstatusdeskew_xhdl6 <= sync_status ;
    patterndetect_xhdl9 <= cg_comma ;
    aligneddatapre_xhdl2 <= SUDI_pre ;
    invalidcodepre_xhdl4 <= '0' ;
    disperrpre_xhdl8 <= '0' ;
    patterndetectpre_xhdl10 <= '0' ;
    m_wal_rtl : stratixgx_hssi_rx_wal_rtl 
        PORT MAP (
            rcvd_clk => rcvd_clk,
            soft_reset => soft_reset,
            LP10BEN => LP10BEN,
            RLV_EN => RLV_EN,
            RUNDISP_SEL => RUNDISP_SEL,
            PMADATAWIDTH => PMADATAWIDTH,
            SYNC_COMP_PAT => SYNC_COMP_PAT,
            SYNC_COMP_SIZE => SYNC_COMP_SIZE,
            IB_INVALID_CODE => IB_INVALID_CODE,
            AUTOBYTEALIGN_DIS => AUTOBYTEALIGN_DIS,
            BITSLIP => BITSLIP_xhdl11,
            DISABLE_RX_DISP => DISABLE_RX_DISP,
            ENCDT => ENCDT,
            SYNC_SM_DIS => SYNC_SM_DIS,
            prbs_en => prbs_en,
            encdet_prbs => encdet_prbs,
            GE_XAUI_SEL => GE_XAUI_SEL,
            signal_detect => signal_detect,
            PUDI => PUDI,
            PUDR => PUDR,
            cg_comma => cg_comma,
            sync_status => sync_status,
            signal_detect_sync => signal_detect_sync,
            SUDI => SUDI,
            SUDI_pre => SUDI_pre,
            RLV => RLV,
            RLV_lt => RLV_lt,
            sync_curr_st => sync_curr_st,
            A1A2_SIZE => A1A2_SIZE,
            DWIDTH => DWIDTH);   
    

END auto_translated;

--
-- STRATIXGX_HSSI_RX_SERDES
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;
use std.textio.all;

entity stratixgx_hssi_rx_serdes is
    generic (
                    channel_width           : integer := 10;
                    rlv_length              : integer := 1;
                    run_length_enable       : String := "false";
                    cruclk_period           : integer :=5000; 
                    cruclk_multiplier       : integer :=4; 
                    use_cruclk_divider  : String := "false";
               use_double_data_mode :  string  := "false"    
                );

    port (
                datain      : in std_logic := '0';
                cruclk      : in std_logic := '0';
                areset      : in std_logic := '0';
                feedback        : in std_logic := '0';
                fbkcntl     : in std_logic := '0';
                ltr         : in std_logic := '0';  -- q3.0ll
                ltd         : in std_logic := '0';  -- q3.0ll
                dataout     : out std_logic_vector(9 downto 0);
                clkout      : out std_logic;
                rlv         : out std_logic;
                lock            : out std_logic;
                freqlock        : out std_logic;
                signaldetect: out std_logic
            );

end stratixgx_hssi_rx_serdes;

architecture vital_rx_serdes_atom of stratixgx_hssi_rx_serdes is

   constant channel_width_max       : integer := 10;

    constant    init_lock_latency       : integer := 9; -- q3.0ll
    signal ltr_ipd            :  std_logic;
    signal ltd_ipd            :  std_logic;
    signal lock_tmp           :  std_logic;
    signal freqlock_tmp       :  std_logic;
    signal freqlock_tmp_dly   :  std_logic;             
    signal freqlock_tmp_dly1  :  std_logic;           
    signal freqlock_tmp_dly2  :  std_logic;         
    signal freqlock_tmp_dly3  :  std_logic;        
    signal freqlock_tmp_dly4  :  std_logic;        

    signal databuf_ipd : std_logic;
    signal cruclk_ipd  : std_logic;
    signal areset_ipd : std_logic;
    signal fbin_ipd : std_logic;
    signal fbena_ipd : std_logic;

    -- add 2 deltas to balance new fastclk_gen - always read prev data
    -- The 1st fastclk has: in_delta + 1(ipd) + 1 (fastclk <= after 0)
    -- remaining fastclk has 0 delta
    -- in summary: fastclk_delta = x(from top) + 1(ipd) + 1 or    0 (no delta)
    --             data          = x(from top) + 1(ipd) + 2 (new)
    signal databuf_tmp1, databuf_tmp2 : std_logic;
    signal areset_tmp1, areset_tmp2   : std_logic;
    signal fbin_tmp1,  fbin_tmp2      : std_logic;
    signal fbena_tmp1, fbena_tmp2     : std_logic;
    signal ltr_tmp1, ltr_tmp2         : std_logic;
    signal ltd_tmp1, ltd_tmp2         : std_logic;

    -- clock gen
    signal fastclk  : std_logic;
    signal cruclk_ipd_last_value : std_logic := 'X';

    signal rlv_flag : std_logic := '0';
    signal rlv_flag_tmp : std_logic := '0';
    signal rlv_set : std_logic := '0';
    signal clkout_int : std_logic := '0';
   signal deser_data_arr : std_logic_vector(channel_width_max-1 downto 0);
    signal deser_data_arr_int : std_logic_vector(channel_width_max-1 downto 0);
    signal deser_data_arr_tmp : std_logic_vector(channel_width_max-1 downto 0);
   signal min_length : integer := 0;
    signal rlv_tmp1 : std_logic := '0';
    signal rlv_tmp2 : std_logic := '0';
    signal rlv_tmp3 : std_logic := '0';
    signal dataout_tmp : std_logic_vector(channel_width_max-1 downto 0);

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
   -- for now assuming all delays on top level

    WireDelay : block
    begin
        cruclk_ipd   <= cruclk;

        databuf_tmp1 <= datain;
        fbin_tmp1    <= feedback;
        fbena_tmp1   <= fbkcntl;
        areset_tmp1  <= areset;
        ltr_tmp1     <= ltr;
        ltd_tmp1     <= ltd;

        databuf_tmp2 <= databuf_tmp1;
        fbin_tmp2    <= fbin_tmp1;
        fbena_tmp2   <= fbena_tmp1;
        areset_tmp2  <= areset_tmp1;
        ltr_tmp2     <= ltr_tmp1;
        ltd_tmp2     <= ltd_tmp1;
         
        databuf_ipd <= databuf_tmp2;
        fbin_ipd    <= fbin_tmp2;
        fbena_ipd   <= fbena_tmp2;
        areset_ipd  <= areset_tmp2;
        ltr_ipd     <= ltr_tmp2;
        ltd_ipd     <= ltd_tmp2;

    end block;

    min_length <= 4 WHEN (channel_width = 8) ELSE 5;

process (cruclk_ipd)
    variable init                  : boolean   := true;
    variable n_fastclk             : integer   := 5;
    variable fastclk_period        : integer   := 320;
    variable cru_rem               : integer   := 0;
    variable my_rem                : integer   := 0;
    variable tmp_fastclk_period    : integer   := 320;
    variable cycle_to_adjust       : integer   := 0;
    variable k                     : integer   := 1;
    variable high_time             : integer   := 160;
    variable low_time              : integer   := 160;
    variable sched_time            : time      := 0 ps;
    variable sched_val             : std_logic := '0';
begin
    if (init) then
        if (use_cruclk_divider = "false") then
            n_fastclk := cruclk_multiplier;
        else
            n_fastclk := cruclk_multiplier / 2;
        end if;        
        fastclk_period := cruclk_period / n_fastclk;
        cru_rem := cruclk_period rem n_fastclk;
                      
        init := false;
    end if;

    if ((cruclk_ipd = '1') and (cruclk_ipd_last_value = '0')) then     
        -- schedule n_fastclk of clk with period fastclk_period
        sched_time := 0 ps;
        sched_val  := '1';  -- start with rising to match cruclk
        
        k := 1; -- used to distribute rem ps to n_fastclk internals
        for i in 1 to n_fastclk loop
            fastclk <= transport sched_val after sched_time; -- rising
             
            -- wether it needs to add extra ps to the period
            tmp_fastclk_period := fastclk_period;
            if (cru_rem /= 0 and k <= cru_rem) then
               cycle_to_adjust := (n_fastclk * k) / cru_rem;
               my_rem := (n_fastclk * k) rem cru_rem;
               if (my_rem /= 0) then
                   cycle_to_adjust := cycle_to_adjust + 1;
               end if;
                     
               if (cycle_to_adjust = i) then
                   tmp_fastclk_period := tmp_fastclk_period + 1;
                   k := k + 1;
               end if;
            end if;
                     
            high_time := tmp_fastclk_period / 2;
            low_time  := tmp_fastclk_period - high_time; 
            sched_val := not sched_val;
            sched_time := sched_time + (high_time * 1 ps);
            fastclk <= transport sched_val after sched_time; -- falling
            sched_time := sched_time + (low_time * 1 ps);
            sched_val  := not sched_val;
        end loop;          
    end if; -- rising cruclk
    
    cruclk_ipd_last_value <= cruclk_ipd;
end process;

process (fastclk, areset_ipd, fbena_ipd)

variable clk_count : integer := channel_width; --follow the 1st edge
variable signaldetect_tmp : std_logic := '0';
variable clkout_last_value : std_logic;
variable    clkout_tmp : std_logic;
variable datain_ipd : std_logic;
variable last_datain : std_logic;
variable rlv_count : integer := 0; 
variable data_changed : std_logic := '0';

begin

    if (now = 0 ns) then
        data_changed :=  '0';
        clk_count := channel_width;
        clkout_tmp := '0';
        signaldetect_tmp := '1';
      for i in channel_width_max-1 downto 0 loop
            deser_data_arr(i) <= '0';
            deser_data_arr_int(i) <= '0';
        end loop;
        last_datain := 'X';
    end if;

    ------------------------
    --  Timing Check Section
    ------------------------

    -- for now assuming all delays on top level module

    if (areset_ipd = '1') then
        clkout_tmp :=  '0';
        clkout_last_value := fastclk;
        clk_count := channel_width;
        signaldetect_tmp := '1';
      for i in channel_width_max-1 downto 0 loop
            deser_data_arr(i) <= '0';
            deser_data_arr_int(i) <= '0';
      end loop;
        rlv_count := 0;
        rlv_flag <= '0';
        rlv_set <= '0';
        last_datain := 'X';
        data_changed := '0';
    else
        if (fbena_ipd = '1') then
            datain_ipd := fbin_ipd;
        else
            datain_ipd := databuf_ipd;
        end if;
       if (fastclk'event and fastclk /= 'X' and fastclk /= 'U') then
            if (clkout_last_value = 'U') then
                clkout_last_value := fastclk;
                clkout_tmp := fastclk;
            elsif (clk_count = channel_width) then
                clkout_tmp := NOT (clkout_last_value);
            elsif (clk_count = channel_width/2) then
                clkout_tmp := NOT (clkout_last_value);
            elsif (clk_count < channel_width) then
                clkout_tmp := clkout_last_value;
            end if;

            if (clk_count = channel_width) then
                clk_count := 0;
            end if;

            clk_count := clk_count + 1;

            if (run_length_enable = "true") then
                if (last_datain /= datain_ipd) then
                    data_changed := '1';
                    last_datain := datain_ipd;
                    rlv_count := 1;
                    rlv_set <= '0';
                else
                    rlv_count := rlv_count + 1;
                    data_changed := '0';
                end if;
                if (rlv_count > rlv_length AND rlv_count > min_length) then
                    rlv_set <= '1';
                    rlv_flag <= '1';
                else
                    rlv_flag <= rlv_flag_tmp;
                end if;
            end if;
       end if;

       if (fastclk'event and fastclk /= 'X'and fastclk /= 'U') then
          for i in 1 to channel_width_max-1 loop
                deser_data_arr(i - 1) <= deser_data_arr(i);
          end loop;
          deser_data_arr(channel_width_max - 1) <= datain_ipd;

            deser_data_arr_int <= deser_data_arr;
       end if;

        if (clkout_tmp /= 'U') then
            clkout_last_value := clkout_tmp;
        end if;
    end if;

    ----------------------
    --  Path Delay Section
    ----------------------
    
    -- for now assuming all delays on top level module

    clkout_int <= clkout_tmp;
    signaldetect <= signaldetect_tmp;
    
end process;

process (clkout_int, areset_ipd)
begin

    if (now = 0 ns) then
        dataout_tmp <= (OTHERS => '0');
      for i in channel_width_max-1 downto 0 loop
            deser_data_arr_tmp(i) <= '0';
        end loop;
        rlv_tmp1 <=  '0';
        rlv_tmp2 <=  '0';
        rlv_tmp3 <=  '0';
        rlv_flag_tmp <= '0';
    end if;

    if (areset_ipd = '1') then
        dataout_tmp <= (OTHERS => '0');
      for i in channel_width_max-1 downto 0 loop
            deser_data_arr_tmp(i) <= '0';
        end loop;
        rlv_tmp1 <=  '0';
        rlv_tmp2 <=  '0';
        rlv_tmp3 <=  '0';
    elsif (clkout_int'event and clkout_int = '1') then

        deser_data_arr_tmp <= deser_data_arr_int;

        dataout_tmp(channel_width_max-1 downto 0) <= deser_data_arr_tmp;

        if (run_length_enable = "true") then
         rlv_tmp2 <= rlv_tmp1;
         rlv_tmp3 <= rlv_tmp2;

            if (rlv_flag = '1') then
                if (rlv_set = '0') then
                    rlv_flag_tmp <= '0';
                   rlv_tmp1 <= '0';
                else
                   rlv_tmp1 <= '1';
                    rlv_flag_tmp <= '1';
                end if;
            else
                rlv_tmp1 <= '0';
                rlv_flag_tmp <= '0';
            end if;
        end if;
   end if;

end process;

-- q3.0ll lock and freqlock based on LTR and LTD
process (cruclk_ipd, areset_ipd)
variable cruclk_cnt : integer := 0;
begin

    if (now = 0 ns) then
        cruclk_cnt := 0;
        lock_tmp <= '1';
        freqlock_tmp <= '0';
        freqlock_tmp_dly <= '0';
        freqlock_tmp_dly1 <= '0';     
        freqlock_tmp_dly2 <= '0';     
        freqlock_tmp_dly3 <= '0';     
        freqlock_tmp_dly4 <= '0';
    end if;

    if (areset_ipd = '1') then
        cruclk_cnt := 0;
        lock_tmp <= '1';
        freqlock_tmp <= '0';
        freqlock_tmp_dly <= '0';
        freqlock_tmp_dly1 <= '0';     
        freqlock_tmp_dly2 <= '0';     
        freqlock_tmp_dly3 <= '0';     
        freqlock_tmp_dly4 <= '0';
    elsif (cruclk_ipd'event and cruclk_ipd = '1' and cruclk_ipd_last_value = '0') then
        freqlock_tmp_dly <= freqlock_tmp_dly4;
        freqlock_tmp_dly4 <= freqlock_tmp_dly3;
        freqlock_tmp_dly3 <= freqlock_tmp_dly2;
        freqlock_tmp_dly2 <= freqlock_tmp_dly1;
        freqlock_tmp_dly1 <= freqlock_tmp;

        if (cruclk_cnt = init_lock_latency) then
            if (ltd_ipd = '1') then
                freqlock_tmp <= '1';
            elsif (ltr_ipd = '1') then
                lock_tmp <= '0';
                freqlock_tmp <= '0';
            else                      -- auto switch
                lock_tmp <= '0';
                freqlock_tmp <= '1';
            end if;
        end if;             

        -- initial latency
        if (cruclk_cnt < init_lock_latency) then
            cruclk_cnt := cruclk_cnt + 1;
        end if;
    end if;
                
end process;

rlv <= '0' WHEN (run_length_enable = "false") ELSE (rlv_tmp1 OR rlv_tmp2) WHEN (use_double_data_mode = "false") ELSE  (rlv_tmp1 OR rlv_tmp2 OR rlv_tmp3);

lock <= lock_tmp;
freqlock <= freqlock_tmp_dly;
clkout <= clkout_int;
dataout <= dataout_tmp;

end vital_rx_serdes_atom;

--
-- stratixgx_hssi_tx_serdes
--

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

entity stratixgx_hssi_tx_serdes is
    generic (
                channel_width           : integer := 10
                );

        port (
                clk             : in std_logic := '0';
                clk1            : in std_logic := '0';
                datain          : in std_logic_vector(9 downto 0) := "0000000000";
                     serialdatain     : in std_logic := '0';
                     srlpbk               : in std_logic := '0';
                areset          : in std_logic := '0';
                dataout         : out std_logic
                );

end stratixgx_hssi_tx_serdes;

architecture vital_tx_serdes_atom of stratixgx_hssi_tx_serdes is
   constant shift_edge : integer := channel_width / 2;
    signal indata : std_logic_vector(channel_width-1 downto 0);
    signal regdata : std_logic_vector(9 downto 0);
   signal clk_dly : std_logic;

begin
    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    
    -- for now assuming all timing done at top level

VITAL_clk0_dly: process (clk)  
begin
   clk_dly <= clk;
end process;

VITAL_clk0: process (clk_dly, clk1, areset)  

variable i : integer := 0;
variable dataout_tmp : std_logic;
variable pclk_count : integer := 0;
variable shiftdata : std_logic_vector(9 downto 0);
begin

    if (now = 0 ns) then
        dataout_tmp := '0';
      for i in 9 downto 0 loop --reset register
            regdata(i) <= '0';
            shiftdata(i) := '0';
        end loop;
   end if;

   ------------------------
   --  Timing Check Section
   ------------------------
    
    -- for now assuming all timing done at top level

   if (areset = '1') then
        dataout_tmp := 'Z';
      for i in 9 downto 0 loop --reset register
            regdata(i) <= 'Z';
            shiftdata(i) := 'Z';
        end loop;
   else
      if (clk_dly'event and clk_dly = '1') then
         pclk_count := pclk_count + 1;

         if (pclk_count = shift_edge) then
             shiftdata := regdata;  
         end if;
      end if;

      if (clk_dly'event) then
         -- loading parallel data
         if (pclk_count = 1) then
           for i in 9 downto 0 loop 
                regdata(i) <= datain(9 - i);
               end loop;
         end if;

         if (srlpbk = '1') then
            dataout_tmp := serialdatain;
         else
            dataout_tmp := shiftdata(9);
         end if;

         for i in 9 downto (10 - channel_width + 1) loop
                shiftdata(i) := shiftdata(i-1);
            end loop;
      end if;

      if (clk1'event and clk1 = '1') then  -- rising edge
         pclk_count := 0;
      end if;
   end if;

   ----------------------
   --  Path Delay Section
   ----------------------

    -- for now assuming all delays on top level module

    dataout <= dataout_tmp;
    
end process;

end vital_tx_serdes_atom;

--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

--synthesis_resources = lut 123 mux21 348 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_xgm_rx_sm IS 
	 PORT 
	 ( 
		 resetall	:	IN  STD_LOGIC;
		 rxclk	:	IN  STD_LOGIC;
		 rxctrl	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 rxctrlout	:	OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 rxdatain	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 rxdataout	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 rxdatavalid	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 rxrunningdisp	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0)
	 ); 
 END stratixgx_xgm_rx_sm;

 ARCHITECTURE RTL OF stratixgx_xgm_rx_sm IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 nl000l45	:	STD_LOGIC := '0';
	 SIGNAL	 nl000l46	:	STD_LOGIC := '0';
	 SIGNAL	 nl00iO43	:	STD_LOGIC := '0';
	 SIGNAL	 nl00iO44	:	STD_LOGIC := '0';
	 SIGNAL	 nl00OO41	:	STD_LOGIC := '0';
	 SIGNAL	 nl00OO42	:	STD_LOGIC := '0';
	 SIGNAL	 nl0i0O37	:	STD_LOGIC := '0';
	 SIGNAL	 nl0i0O38	:	STD_LOGIC := '0';
	 SIGNAL	 nl0i1l39	:	STD_LOGIC := '0';
	 SIGNAL	 nl0i1l40	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0i1l40_w_lg_q180w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iil35	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iil36	:	STD_LOGIC := '0';
	 SIGNAL	 nl0ill33	:	STD_LOGIC := '0';
	 SIGNAL	 nl0ill34	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iOO31	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iOO32	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l0l27	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l0l28	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l1O29	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l1O30	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lil25	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lil26	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lll23	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lll24	:	STD_LOGIC := '0';
	 SIGNAL	 nl0llO21	:	STD_LOGIC := '0';
	 SIGNAL	 nl0llO22	:	STD_LOGIC := '0';
	 SIGNAL	 nl0O0O17	:	STD_LOGIC := '0';
	 SIGNAL	 nl0O0O18	:	STD_LOGIC := '0';
	 SIGNAL	 nl0O1l19	:	STD_LOGIC := '0';
	 SIGNAL	 nl0O1l20	:	STD_LOGIC := '0';
	 SIGNAL	 nl0Oli15	:	STD_LOGIC := '0';
	 SIGNAL	 nl0Oli16	:	STD_LOGIC := '0';
	 SIGNAL	 nl0OOO13	:	STD_LOGIC := '0';
	 SIGNAL	 nl0OOO14	:	STD_LOGIC := '0';
	 SIGNAL	 nli00O3	:	STD_LOGIC := '0';
	 SIGNAL	 nli00O4	:	STD_LOGIC := '0';
	 SIGNAL	 nli0lO1	:	STD_LOGIC := '0';
	 SIGNAL	 nli0lO2	:	STD_LOGIC := '0';
	 SIGNAL	 nli10l10	:	STD_LOGIC := '0';
	 SIGNAL	 nli10l9	:	STD_LOGIC := '0';
	 SIGNAL	 nli11O11	:	STD_LOGIC := '0';
	 SIGNAL	 nli11O12	:	STD_LOGIC := '0';
	 SIGNAL	 nli1ii7	:	STD_LOGIC := '0';
	 SIGNAL	 nli1ii8	:	STD_LOGIC := '0';
	 SIGNAL	 nli1OO5	:	STD_LOGIC := '0';
	 SIGNAL	 nli1OO6	:	STD_LOGIC := '0';
	 SIGNAL	n11iO	:	STD_LOGIC := '0';
	 SIGNAL	n1O1i	:	STD_LOGIC := '0';
	 SIGNAL	n1O1l	:	STD_LOGIC := '0';
	 SIGNAL	n1O1O	:	STD_LOGIC := '0';
	 SIGNAL	n1Oii	:	STD_LOGIC := '0';
	 SIGNAL	nlllli	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1O0O_PRN	:	STD_LOGIC;
	 SIGNAL	n00ll	:	STD_LOGIC := '0';
	 SIGNAL	n00lO	:	STD_LOGIC := '0';
	 SIGNAL	n00Oi	:	STD_LOGIC := '0';
	 SIGNAL	n00Ol	:	STD_LOGIC := '0';
	 SIGNAL	n00OO	:	STD_LOGIC := '0';
	 SIGNAL	n0i1i	:	STD_LOGIC := '0';
	 SIGNAL	n0i1l	:	STD_LOGIC := '0';
	 SIGNAL	n0i1O	:	STD_LOGIC := '0';
	 SIGNAL	n110i	:	STD_LOGIC := '0';
	 SIGNAL	n110l	:	STD_LOGIC := '0';
	 SIGNAL	n110O	:	STD_LOGIC := '0';
	 SIGNAL	n111i	:	STD_LOGIC := '0';
	 SIGNAL	n111l	:	STD_LOGIC := '0';
	 SIGNAL	n111O	:	STD_LOGIC := '0';
	 SIGNAL	n11ii	:	STD_LOGIC := '0';
	 SIGNAL	n11il	:	STD_LOGIC := '0';
	 SIGNAL	n1lOl	:	STD_LOGIC := '0';
	 SIGNAL	n1lOO	:	STD_LOGIC := '0';
	 SIGNAL	n1O0i	:	STD_LOGIC := '0';
	 SIGNAL	n1O0l	:	STD_LOGIC := '0';
	 SIGNAL	n1Oil	:	STD_LOGIC := '0';
	 SIGNAL	ni00i	:	STD_LOGIC := '0';
	 SIGNAL	ni00l	:	STD_LOGIC := '0';
	 SIGNAL	ni00O	:	STD_LOGIC := '0';
	 SIGNAL	ni01i	:	STD_LOGIC := '0';
	 SIGNAL	ni01l	:	STD_LOGIC := '0';
	 SIGNAL	ni01O	:	STD_LOGIC := '0';
	 SIGNAL	ni0ii	:	STD_LOGIC := '0';
	 SIGNAL	ni1Ol	:	STD_LOGIC := '0';
	 SIGNAL	ni1OO	:	STD_LOGIC := '0';
	 SIGNAL	niii	:	STD_LOGIC := '0';
	 SIGNAL	niil	:	STD_LOGIC := '0';
	 SIGNAL	niiO	:	STD_LOGIC := '0';
	 SIGNAL	niOl	:	STD_LOGIC := '0';
	 SIGNAL	nl10i	:	STD_LOGIC := '0';
	 SIGNAL	nl10l	:	STD_LOGIC := '0';
	 SIGNAL	nl10O	:	STD_LOGIC := '0';
	 SIGNAL	nl11O	:	STD_LOGIC := '0';
	 SIGNAL	nl1ii	:	STD_LOGIC := '0';
	 SIGNAL	nl1il	:	STD_LOGIC := '0';
	 SIGNAL	nl1iO	:	STD_LOGIC := '0';
	 SIGNAL	nl1li	:	STD_LOGIC := '0';
	 SIGNAL	nlllll	:	STD_LOGIC := '0';
	 SIGNAL	nllllO	:	STD_LOGIC := '0';
	 SIGNAL	nlllOi	:	STD_LOGIC := '0';
	 SIGNAL	nlllOl	:	STD_LOGIC := '0';
	 SIGNAL	nlllOO	:	STD_LOGIC := '0';
	 SIGNAL	nllO1i	:	STD_LOGIC := '0';
	 SIGNAL	nllO1l	:	STD_LOGIC := '0';
	 SIGNAL	nllO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlO00i	:	STD_LOGIC := '0';
	 SIGNAL	nlO00l	:	STD_LOGIC := '0';
	 SIGNAL	nlO00O	:	STD_LOGIC := '0';
	 SIGNAL	nlO0ii	:	STD_LOGIC := '0';
	 SIGNAL	nlO0il	:	STD_LOGIC := '0';
	 SIGNAL	nlO0iO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0li	:	STD_LOGIC := '0';
	 SIGNAL	nlO0ll	:	STD_LOGIC := '0';
	 SIGNAL	nlO0lO	:	STD_LOGIC := '0';
	 SIGNAL	nlOii	:	STD_LOGIC := '0';
	 SIGNAL	nlOil	:	STD_LOGIC := '0';
	 SIGNAL	nlOlO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOOO	:	STD_LOGIC := '0';
	 SIGNAL	n00li	:	STD_LOGIC := '0';
	 SIGNAL	nl1i	:	STD_LOGIC := '0';
	 SIGNAL	nl1ll	:	STD_LOGIC := '0';
	 SIGNAL	nlOiO	:	STD_LOGIC := '0';
	 SIGNAL	nlOli	:	STD_LOGIC := '0';
	 SIGNAL	nlOll	:	STD_LOGIC := '0';
	 SIGNAL	nlOOl	:	STD_LOGIC := '0';
	 SIGNAL	wire_niOO_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_niOO_PRN	:	STD_LOGIC;
	 SIGNAL	wire_n000i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n000l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl0i_w_lg_dataout92w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl0l_w_lg_dataout123w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1l_w_lg_dataout80w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1O_w_lg_dataout89w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1O_w_lg_dataout182w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOl_dataout	:	STD_LOGIC;
	 SIGNAL  wire_w_lg_w_lg_nli0iO178w181w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli0iO178w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range1w79w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range9w85w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range13w91w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxctrl_range21w122w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range121w306w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range153w320w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range162w327w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range140w313w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0lOi98w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0OiO113w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0OlO70w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0OOi67w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0OOl64w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli00i23w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli01l25w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli0il15w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli0li11w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli11l58w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli1iO37w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli1ll33w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli1Oi31w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlii1i3w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_resetall101w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range152w259w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range120w236w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range161w269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rxdatain_range139w249w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_nli0ll49w50w51w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nli0ll49w50w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nli1Ol35w36w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli0ll49w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nli1Ol35w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nl00ii :	STD_LOGIC;
	 SIGNAL  nl00il :	STD_LOGIC;
	 SIGNAL  nl00ll :	STD_LOGIC;
	 SIGNAL  nl00lO :	STD_LOGIC;
	 SIGNAL  nl00Oi :	STD_LOGIC;
	 SIGNAL  nl00Ol :	STD_LOGIC;
	 SIGNAL  nl0i0i :	STD_LOGIC;
	 SIGNAL  nl0i0l :	STD_LOGIC;
	 SIGNAL  nl0iii :	STD_LOGIC;
	 SIGNAL  nl0ili :	STD_LOGIC;
	 SIGNAL  nl0iOi :	STD_LOGIC;
	 SIGNAL  nl0iOl :	STD_LOGIC;
	 SIGNAL  nl0l1l :	STD_LOGIC;
	 SIGNAL  nl0lii :	STD_LOGIC;
	 SIGNAL  nl0lli :	STD_LOGIC;
	 SIGNAL  nl0lOi :	STD_LOGIC;
	 SIGNAL  nl0lOl :	STD_LOGIC;
	 SIGNAL  nl0lOO :	STD_LOGIC;
	 SIGNAL  nl0O0i :	STD_LOGIC;
	 SIGNAL  nl0O0l :	STD_LOGIC;
	 SIGNAL  nl0O1i :	STD_LOGIC;
	 SIGNAL  nl0Oil :	STD_LOGIC;
	 SIGNAL  nl0OiO :	STD_LOGIC;
	 SIGNAL  nl0OlO :	STD_LOGIC;
	 SIGNAL  nl0OOi :	STD_LOGIC;
	 SIGNAL  nl0OOl :	STD_LOGIC;
	 SIGNAL  nli00i :	STD_LOGIC;
	 SIGNAL  nli00l :	STD_LOGIC;
	 SIGNAL  nli01l :	STD_LOGIC;
	 SIGNAL  nli01O :	STD_LOGIC;
	 SIGNAL  nli0il :	STD_LOGIC;
	 SIGNAL  nli0iO :	STD_LOGIC;
	 SIGNAL  nli0li :	STD_LOGIC;
	 SIGNAL  nli0ll :	STD_LOGIC;
	 SIGNAL  nli11l :	STD_LOGIC;
	 SIGNAL  nli1iO :	STD_LOGIC;
	 SIGNAL  nli1li :	STD_LOGIC;
	 SIGNAL  nli1ll :	STD_LOGIC;
	 SIGNAL  nli1lO :	STD_LOGIC;
	 SIGNAL  nli1Oi :	STD_LOGIC;
	 SIGNAL  nli1Ol :	STD_LOGIC;
	 SIGNAL  nlii1i :	STD_LOGIC;
	 SIGNAL  wire_w_rxctrl_range1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxctrl_range9w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxctrl_range13w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxctrl_range21w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range121w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range152w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range120w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range162w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range161w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rxdatain_range139w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_lg_nli0iO178w181w(0) <= wire_w_lg_nli0iO178w(0) AND wire_nl0i1l40_w_lg_q180w(0);
	wire_w_lg_nli0iO178w(0) <= nli0iO AND nli1lO;
	wire_w_lg_w_rxctrl_range1w79w(0) <= wire_w_rxctrl_range1w(0) AND nl0Oil;
	wire_w_lg_w_rxctrl_range9w85w(0) <= wire_w_rxctrl_range9w(0) AND nl0O0i;
	wire_w_lg_w_rxctrl_range13w91w(0) <= wire_w_rxctrl_range13w(0) AND nl0lOO;
	wire_w_lg_w_rxctrl_range21w122w(0) <= wire_w_rxctrl_range21w(0) AND nl0lii;
	wire_w_lg_w_rxdatain_range121w306w(0) <= wire_w_rxdatain_range121w(0) AND wire_w_lg_w_rxdatain_range120w236w(0);
	wire_w_lg_w_rxdatain_range153w320w(0) <= wire_w_rxdatain_range153w(0) AND wire_w_lg_w_rxdatain_range152w259w(0);
	wire_w_lg_w_rxdatain_range162w327w(0) <= wire_w_rxdatain_range162w(0) AND wire_w_lg_w_rxdatain_range161w269w(0);
	wire_w_lg_w_rxdatain_range140w313w(0) <= wire_w_rxdatain_range140w(0) AND wire_w_lg_w_rxdatain_range139w249w(0);
	wire_w_lg_nl0lOi98w(0) <= NOT nl0lOi;
	wire_w_lg_nl0OiO113w(0) <= NOT nl0OiO;
	wire_w_lg_nl0OlO70w(0) <= NOT nl0OlO;
	wire_w_lg_nl0OOi67w(0) <= NOT nl0OOi;
	wire_w_lg_nl0OOl64w(0) <= NOT nl0OOl;
	wire_w_lg_nli00i23w(0) <= NOT nli00i;
	wire_w_lg_nli01l25w(0) <= NOT nli01l;
	wire_w_lg_nli0il15w(0) <= NOT nli0il;
	wire_w_lg_nli0li11w(0) <= NOT nli0li;
	wire_w_lg_nli11l58w(0) <= NOT nli11l;
	wire_w_lg_nli1iO37w(0) <= NOT nli1iO;
	wire_w_lg_nli1ll33w(0) <= NOT nli1ll;
	wire_w_lg_nli1Oi31w(0) <= NOT nli1Oi;
	wire_w_lg_nlii1i3w(0) <= NOT nlii1i;
	wire_w_lg_resetall101w(0) <= NOT resetall;
	wire_w_lg_w_rxdatain_range152w259w(0) <= NOT wire_w_rxdatain_range152w(0);
	wire_w_lg_w_rxdatain_range120w236w(0) <= NOT wire_w_rxdatain_range120w(0);
	wire_w_lg_w_rxdatain_range161w269w(0) <= NOT wire_w_rxdatain_range161w(0);
	wire_w_lg_w_rxdatain_range139w249w(0) <= NOT wire_w_rxdatain_range139w(0);
	wire_w_lg_w_lg_w_lg_nli0ll49w50w51w(0) <= wire_w_lg_w_lg_nli0ll49w50w(0) OR nli01O;
	wire_w_lg_w_lg_nli0ll49w50w(0) <= wire_w_lg_nli0ll49w(0) OR nli00l;
	wire_w_lg_w_lg_nli1Ol35w36w(0) <= wire_w_lg_nli1Ol35w(0) OR nli1li;
	wire_w_lg_nli0ll49w(0) <= nli0ll OR nli0iO;
	wire_w_lg_nli1Ol35w(0) <= nli1Ol OR nli1lO;
	nl00ii <= (nli01O OR wire_nl0l_dataout);
	nl00il <= ((nl0lOl OR nl00ll) OR (NOT (nl00iO44 XOR nl00iO43)));
	nl00ll <= (nl0O0l OR nl0O1i);
	nl00lO <= (wire_nl0i_dataout OR (nli00l AND nli1li));
	nl00Oi <= (nli00l OR wire_nl0i_dataout);
	nl00Ol <= (wire_nl1O_w_lg_dataout182w(0) OR (NOT (nl00OO42 XOR nl00OO41)));
	nl0i0i <= (niii OR nlOOO);
	nl0i0l <= (nli0iO OR wire_nl1O_dataout);
	nl0iii <= (wire_nl1l_dataout OR ((nli0ll AND nli1Ol) AND (nl0iil36 XOR nl0iil35)));
	nl0ili <= (nlOOO OR ((niil OR niii) OR (NOT (nl0ill34 XOR nl0ill33))));
	nl0iOi <= (nl0lOl OR nl0iOl);
	nl0iOl <= ((nl0O1i OR nl0l1l) OR (NOT (nl0iOO32 XOR nl0iOO31)));
	nl0l1l <= ((nl0OiO OR nl0O0l) OR (NOT (nl0l1O30 XOR nl0l1O29)));
	nl0lii <= ((((((wire_w_lg_w_rxdatain_range162w327w(0) AND rxdatain(26)) AND rxdatain(27)) AND rxdatain(28)) AND rxdatain(29)) AND rxdatain(30)) AND rxdatain(31));
	nl0lli <= '1';
	nl0lOi <= ((((rxdatavalid(0) AND rxdatavalid(1)) AND rxdatavalid(2)) AND rxdatavalid(3)) AND (nl0lil26 XOR nl0lil25));
	nl0lOl <= (wire_w_lg_w_rxctrl_range13w91w(0) AND wire_nl0i_w_lg_dataout92w(0));
	nl0lOO <= ((((((wire_w_lg_w_rxdatain_range153w320w(0) AND rxdatain(18)) AND rxdatain(19)) AND rxdatain(20)) AND rxdatain(21)) AND rxdatain(22)) AND rxdatain(23));
	nl0O0i <= ((((((wire_w_lg_w_rxdatain_range140w313w(0) AND rxdatain(10)) AND rxdatain(11)) AND rxdatain(12)) AND rxdatain(13)) AND rxdatain(14)) AND rxdatain(15));
	nl0O0l <= ((wire_w_lg_w_rxctrl_range1w79w(0) AND wire_nl1l_w_lg_dataout80w(0)) AND (nl0O0O18 XOR nl0O0O17));
	nl0O1i <= ((wire_w_lg_w_rxctrl_range9w85w(0) AND (nl0O1l20 XOR nl0O1l19)) AND wire_nl1O_w_lg_dataout89w(0));
	nl0Oil <= ((((((wire_w_lg_w_rxdatain_range121w306w(0) AND rxdatain(2)) AND rxdatain(3)) AND rxdatain(4)) AND rxdatain(5)) AND rxdatain(6)) AND rxdatain(7));
	nl0OiO <= (((NOT ((wire_w_lg_w_lg_nli1Ol35w36w(0) OR (((NOT rxctrl(3)) OR wire_w_lg_nli1iO37w(0)) OR (NOT (nli1ii8 XOR nli1ii7)))) OR (NOT (nli10l10 XOR nli10l9)))) OR (NOT (wire_w_lg_w_lg_w_lg_nli0ll49w50w51w(0) OR (NOT (nli11O12 XOR nli11O11))))) OR (NOT (((((((NOT rxctrl(0)) OR wire_w_lg_nli11l58w(0)) OR (NOT (nl0OOO14 XOR nl0OOO13))) OR ((NOT rxctrl(1)) OR wire_w_lg_nl0OOl64w(0))) OR ((NOT rxctrl(2)) OR wire_w_lg_nl0OOi67w(0))) OR ((NOT rxctrl(3)) OR wire_w_lg_nl0OlO70w(0))) OR (NOT (nl0Oli16 XOR nl0Oli15)))));
	nl0OlO <= ((((((((NOT rxdatain(24)) AND wire_w_lg_w_rxdatain_range161w269w(0)) AND rxdatain(26)) AND rxdatain(27)) AND rxdatain(28)) AND (NOT rxdatain(29))) AND (NOT rxdatain(30))) AND (NOT rxdatain(31)));
	nl0OOi <= ((((((((NOT rxdatain(16)) AND wire_w_lg_w_rxdatain_range152w259w(0)) AND rxdatain(18)) AND rxdatain(19)) AND rxdatain(20)) AND (NOT rxdatain(21))) AND (NOT rxdatain(22))) AND (NOT rxdatain(23)));
	nl0OOl <= ((((((((NOT rxdatain(8)) AND wire_w_lg_w_rxdatain_range139w249w(0)) AND rxdatain(10)) AND rxdatain(11)) AND rxdatain(12)) AND (NOT rxdatain(13))) AND (NOT rxdatain(14))) AND (NOT rxdatain(15)));
	nli00i <= ((((((((NOT rxdatain(24)) AND wire_w_lg_w_rxdatain_range161w269w(0)) AND rxdatain(26)) AND rxdatain(27)) AND rxdatain(28)) AND rxdatain(29)) AND (NOT rxdatain(30))) AND rxdatain(31));
	nli00l <= (((NOT rxctrl(2)) OR wire_w_lg_nli0il15w(0)) OR (NOT (nli00O4 XOR nli00O3)));
	nli01l <= ((((((((NOT rxdatain(0)) AND wire_w_lg_w_rxdatain_range120w236w(0)) AND rxdatain(2)) AND rxdatain(3)) AND rxdatain(4)) AND rxdatain(5)) AND rxdatain(6)) AND (NOT rxdatain(7)));
	nli01O <= ((NOT rxctrl(3)) OR wire_w_lg_nli00i23w(0));
	nli0il <= ((((((((NOT rxdatain(16)) AND wire_w_lg_w_rxdatain_range152w259w(0)) AND rxdatain(18)) AND rxdatain(19)) AND rxdatain(20)) AND rxdatain(21)) AND (NOT rxdatain(22))) AND rxdatain(23));
	nli0iO <= ((NOT rxctrl(1)) OR wire_w_lg_nli0li11w(0));
	nli0li <= ((((((((NOT rxdatain(8)) AND wire_w_lg_w_rxdatain_range139w249w(0)) AND rxdatain(10)) AND rxdatain(11)) AND rxdatain(12)) AND rxdatain(13)) AND (NOT rxdatain(14))) AND rxdatain(15));
	nli0ll <= (((NOT rxctrl(0)) OR wire_w_lg_nlii1i3w(0)) OR (NOT (nli0lO2 XOR nli0lO1)));
	nli11l <= ((((((((NOT rxdatain(0)) AND wire_w_lg_w_rxdatain_range120w236w(0)) AND rxdatain(2)) AND rxdatain(3)) AND rxdatain(4)) AND (NOT rxdatain(5))) AND (NOT rxdatain(6))) AND (NOT rxdatain(7)));
	nli1iO <= ((((((((NOT rxdatain(24)) AND wire_w_lg_w_rxdatain_range161w269w(0)) AND rxdatain(26)) AND rxdatain(27)) AND rxdatain(28)) AND rxdatain(29)) AND rxdatain(30)) AND (NOT rxdatain(31)));
	nli1li <= ((NOT rxctrl(2)) OR wire_w_lg_nli1ll33w(0));
	nli1ll <= ((((((((NOT rxdatain(16)) AND wire_w_lg_w_rxdatain_range152w259w(0)) AND rxdatain(18)) AND rxdatain(19)) AND rxdatain(20)) AND rxdatain(21)) AND rxdatain(22)) AND (NOT rxdatain(23)));
	nli1lO <= ((NOT rxctrl(1)) OR wire_w_lg_nli1Oi31w(0));
	nli1Oi <= ((((((((NOT rxdatain(8)) AND wire_w_lg_w_rxdatain_range139w249w(0)) AND rxdatain(10)) AND rxdatain(11)) AND rxdatain(12)) AND rxdatain(13)) AND rxdatain(14)) AND (NOT rxdatain(15)));
	nli1Ol <= (((NOT rxctrl(0)) OR wire_w_lg_nli01l25w(0)) OR (NOT (nli1OO6 XOR nli1OO5)));
	nlii1i <= (((((((((NOT rxdatain(0)) AND wire_w_lg_w_rxdatain_range120w236w(0)) AND rxdatain(2)) AND rxdatain(3)) AND rxdatain(4)) AND rxdatain(5)) AND (NOT rxdatain(6))) AND rxdatain(7)) AND (nl000l46 XOR nl000l45));
	rxctrlout <= ( niOl & nllO1O & nlO0lO & n11iO);
	rxdataout <= ( nllO1l & nllO1i & nlllOO & nlllOl & nlllOi & nllllO & nlllll & nlllli & nlO0ll & nlO0li & nlO0iO & nlO0il & nlO0ii & nlO00O & nlO00l & nlO00i & n11il & n11ii & n110O & n110l & n110i & n111O & n111l & n111i & n1Oii & n1O0l & n1O0i & n1O1O & n1O1l & n1O1i & n1lOO & n1lOl);
	wire_w_rxctrl_range1w(0) <= rxctrl(0);
	wire_w_rxctrl_range9w(0) <= rxctrl(1);
	wire_w_rxctrl_range13w(0) <= rxctrl(2);
	wire_w_rxctrl_range21w(0) <= rxctrl(3);
	wire_w_rxdatain_range121w(0) <= rxdatain(0);
	wire_w_rxdatain_range153w(0) <= rxdatain(16);
	wire_w_rxdatain_range152w(0) <= rxdatain(17);
	wire_w_rxdatain_range120w(0) <= rxdatain(1);
	wire_w_rxdatain_range162w(0) <= rxdatain(24);
	wire_w_rxdatain_range161w(0) <= rxdatain(25);
	wire_w_rxdatain_range140w(0) <= rxdatain(8);
	wire_w_rxdatain_range139w(0) <= rxdatain(9);
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl000l45 <= nl000l46;
		END IF;
		if (now = 0 ns) then
			nl000l45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl000l46 <= nl000l45;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl00iO43 <= nl00iO44;
		END IF;
		if (now = 0 ns) then
			nl00iO43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl00iO44 <= nl00iO43;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl00OO41 <= nl00OO42;
		END IF;
		if (now = 0 ns) then
			nl00OO41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl00OO42 <= nl00OO41;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0i0O37 <= nl0i0O38;
		END IF;
		if (now = 0 ns) then
			nl0i0O37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0i0O38 <= nl0i0O37;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0i1l39 <= nl0i1l40;
		END IF;
		if (now = 0 ns) then
			nl0i1l39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0i1l40 <= nl0i1l39;
		END IF;
	END PROCESS;
	wire_nl0i1l40_w_lg_q180w(0) <= nl0i1l40 XOR nl0i1l39;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0iil35 <= nl0iil36;
		END IF;
		if (now = 0 ns) then
			nl0iil35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0iil36 <= nl0iil35;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0ill33 <= nl0ill34;
		END IF;
		if (now = 0 ns) then
			nl0ill33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0ill34 <= nl0ill33;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0iOO31 <= nl0iOO32;
		END IF;
		if (now = 0 ns) then
			nl0iOO31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0iOO32 <= nl0iOO31;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0l0l27 <= nl0l0l28;
		END IF;
		if (now = 0 ns) then
			nl0l0l27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0l0l28 <= nl0l0l27;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0l1O29 <= nl0l1O30;
		END IF;
		if (now = 0 ns) then
			nl0l1O29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0l1O30 <= nl0l1O29;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0lil25 <= nl0lil26;
		END IF;
		if (now = 0 ns) then
			nl0lil25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0lil26 <= nl0lil25;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0lll23 <= nl0lll24;
		END IF;
		if (now = 0 ns) then
			nl0lll23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0lll24 <= nl0lll23;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0llO21 <= nl0llO22;
		END IF;
		if (now = 0 ns) then
			nl0llO21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0llO22 <= nl0llO21;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0O0O17 <= nl0O0O18;
		END IF;
		if (now = 0 ns) then
			nl0O0O17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0O0O18 <= nl0O0O17;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0O1l19 <= nl0O1l20;
		END IF;
		if (now = 0 ns) then
			nl0O1l19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0O1l20 <= nl0O1l19;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0Oli15 <= nl0Oli16;
		END IF;
		if (now = 0 ns) then
			nl0Oli15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0Oli16 <= nl0Oli15;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0OOO13 <= nl0OOO14;
		END IF;
		if (now = 0 ns) then
			nl0OOO13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nl0OOO14 <= nl0OOO13;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli00O3 <= nli00O4;
		END IF;
		if (now = 0 ns) then
			nli00O3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli00O4 <= nli00O3;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli0lO1 <= nli0lO2;
		END IF;
		if (now = 0 ns) then
			nli0lO1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli0lO2 <= nli0lO1;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli10l10 <= nli10l9;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli10l9 <= nli10l10;
		END IF;
		if (now = 0 ns) then
			nli10l9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli11O11 <= nli11O12;
		END IF;
		if (now = 0 ns) then
			nli11O11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli11O12 <= nli11O11;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli1ii7 <= nli1ii8;
		END IF;
		if (now = 0 ns) then
			nli1ii7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli1ii8 <= nli1ii7;
		END IF;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli1OO5 <= nli1OO6;
		END IF;
		if (now = 0 ns) then
			nli1OO5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rxclk)
	BEGIN
		IF (rxclk = '1' AND rxclk'event) THEN nli1OO6 <= nli1OO5;
		END IF;
	END PROCESS;
	PROCESS (rxclk, wire_n1O0O_PRN)
	BEGIN
		IF (wire_n1O0O_PRN = '0') THEN
				n11iO <= '1';
				n1O1i <= '1';
				n1O1l <= '1';
				n1O1O <= '1';
				n1Oii <= '1';
				nlllli <= '1';
		ELSIF (rxclk = '1' AND rxclk'event) THEN
				n11iO <= wire_n1OiO_dataout;
				n1O1i <= wire_n1OlO_dataout;
				n1O1l <= wire_n1OOi_dataout;
				n1O1O <= wire_n1OOl_dataout;
				n1Oii <= wire_n011l_dataout;
				nlllli <= wire_nllO0l_dataout;
		END IF;
	END PROCESS;
	wire_n1O0O_PRN <= ((nl0i0O38 XOR nl0i0O37) AND wire_w_lg_resetall101w(0));
	PROCESS (rxclk, resetall)
	BEGIN
		IF (resetall = '1') THEN
				n00ll <= '0';
				n00lO <= '0';
				n00Oi <= '0';
				n00Ol <= '0';
				n00OO <= '0';
				n0i1i <= '0';
				n0i1l <= '0';
				n0i1O <= '0';
				n110i <= '0';
				n110l <= '0';
				n110O <= '0';
				n111i <= '0';
				n111l <= '0';
				n111O <= '0';
				n11ii <= '0';
				n11il <= '0';
				n1lOl <= '0';
				n1lOO <= '0';
				n1O0i <= '0';
				n1O0l <= '0';
				n1Oil <= '0';
				ni00i <= '0';
				ni00l <= '0';
				ni00O <= '0';
				ni01i <= '0';
				ni01l <= '0';
				ni01O <= '0';
				ni0ii <= '0';
				ni1Ol <= '0';
				ni1OO <= '0';
				niii <= '0';
				niil <= '0';
				niiO <= '0';
				niOl <= '0';
				nl10i <= '0';
				nl10l <= '0';
				nl10O <= '0';
				nl11O <= '0';
				nl1ii <= '0';
				nl1il <= '0';
				nl1iO <= '0';
				nl1li <= '0';
				nlllll <= '0';
				nllllO <= '0';
				nlllOi <= '0';
				nlllOl <= '0';
				nlllOO <= '0';
				nllO1i <= '0';
				nllO1l <= '0';
				nllO1O <= '0';
				nlO00i <= '0';
				nlO00l <= '0';
				nlO00O <= '0';
				nlO0ii <= '0';
				nlO0il <= '0';
				nlO0iO <= '0';
				nlO0li <= '0';
				nlO0ll <= '0';
				nlO0lO <= '0';
				nlOii <= '0';
				nlOil <= '0';
				nlOlO <= '0';
				nlOOi <= '0';
				nlOOO <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN
				n00ll <= wire_n0i0O_dataout;
				n00lO <= wire_n0iii_dataout;
				n00Oi <= wire_n0iil_dataout;
				n00Ol <= wire_n0iiO_dataout;
				n00OO <= wire_n0ili_dataout;
				n0i1i <= wire_n0ill_dataout;
				n0i1l <= wire_n0ilO_dataout;
				n0i1O <= wire_ni0il_dataout;
				n110i <= wire_n11Ol_dataout;
				n110l <= wire_n11OO_dataout;
				n110O <= wire_n101i_dataout;
				n111i <= wire_n11ll_dataout;
				n111l <= wire_n11lO_dataout;
				n111O <= wire_n11Oi_dataout;
				n11ii <= wire_n101l_dataout;
				n11il <= wire_n101O_dataout;
				n1lOl <= wire_n1Oli_dataout;
				n1lOO <= wire_n1Oll_dataout;
				n1O0i <= wire_n1OOO_dataout;
				n1O0l <= wire_n011i_dataout;
				n1Oil <= wire_n0i0i_dataout;
				ni00i <= wire_ni0Ol_dataout;
				ni00l <= wire_ni0OO_dataout;
				ni00O <= wire_nii1i_dataout;
				ni01i <= wire_ni0ll_dataout;
				ni01l <= wire_ni0lO_dataout;
				ni01O <= wire_ni0Oi_dataout;
				ni0ii <= wire_nl1lO_dataout;
				ni1Ol <= wire_ni0iO_dataout;
				ni1OO <= wire_ni0li_dataout;
				niii <= nl0lOl;
				niil <= nl0O1i;
				niiO <= wire_nili_dataout;
				niOl <= wire_nllO0i_dataout;
				nl10i <= wire_nl1Ol_dataout;
				nl10l <= wire_nl1OO_dataout;
				nl10O <= wire_nl01i_dataout;
				nl11O <= wire_nl1Oi_dataout;
				nl1ii <= wire_nl01l_dataout;
				nl1il <= wire_nl01O_dataout;
				nl1iO <= wire_nl00i_dataout;
				nl1li <= wire_nl00l_dataout;
				nlllll <= wire_nllO0O_dataout;
				nllllO <= wire_nllOii_dataout;
				nlllOi <= wire_nllOil_dataout;
				nlllOl <= wire_nllOiO_dataout;
				nlllOO <= wire_nllOli_dataout;
				nllO1i <= wire_nllOll_dataout;
				nllO1l <= wire_nllOlO_dataout;
				nllO1O <= wire_nlO0Oi_dataout;
				nlO00i <= wire_nlO0Ol_dataout;
				nlO00l <= wire_nlO0OO_dataout;
				nlO00O <= wire_nlOi1i_dataout;
				nlO0ii <= wire_nlOi1l_dataout;
				nlO0il <= wire_nlOi1O_dataout;
				nlO0iO <= wire_nlOi0i_dataout;
				nlO0li <= wire_nlOi0l_dataout;
				nlO0ll <= wire_nlOi0O_dataout;
				nlO0lO <= wire_n11li_dataout;
				nlOii <= wire_n11l_dataout;
				nlOil <= wire_n11O_dataout;
				nlOlO <= wire_n1ii_dataout;
				nlOOi <= wire_n1il_dataout;
				nlOOO <= ((wire_w_lg_w_rxctrl_range21w122w(0) AND wire_nl0l_w_lg_dataout123w(0)) AND (nl0l0l28 XOR nl0l0l27));
		END IF;
	END PROCESS;
	PROCESS (rxclk, wire_niOO_PRN, wire_niOO_CLRN)
	BEGIN
		IF (wire_niOO_PRN = '0') THEN
				n00li <= '1';
				nl1i <= '1';
				nl1ll <= '1';
				nlOiO <= '1';
				nlOli <= '1';
				nlOll <= '1';
				nlOOl <= '1';
		ELSIF (wire_niOO_CLRN = '0') THEN
				n00li <= '0';
				nl1i <= '0';
				nl1ll <= '0';
				nlOiO <= '0';
				nlOli <= '0';
				nlOll <= '0';
				nlOOl <= '0';
		ELSIF (rxclk = '1' AND rxclk'event) THEN
				n00li <= wire_n0i0l_dataout;
				nl1i <= wire_w_lg_nl0lOi98w(0);
				nl1ll <= wire_n11i_dataout;
				nlOiO <= wire_n10i_dataout;
				nlOli <= wire_n10l_dataout;
				nlOll <= wire_n10O_dataout;
				nlOOl <= wire_n1iO_dataout;
		END IF;
		if (now = 0 ns) then
			n00li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOl <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_niOO_CLRN <= (nl0llO22 XOR nl0llO21);
	wire_niOO_PRN <= ((nl0lll24 XOR nl0lll23) AND wire_w_lg_resetall101w(0));
	wire_n000i_dataout <= nlOOi OR nl0iii;
	wire_n000l_dataout <= nlOOl OR nl0iii;
	wire_n001i_dataout <= nlOli OR nl0iii;
	wire_n001l_dataout <= nlOll OR nl0iii;
	wire_n001O_dataout <= nlOlO OR nl0iii;
	wire_n00i_dataout <= rxctrl(0) WHEN nl0O0l = '1'  ELSE wire_n0Oi_dataout;
	wire_n00l_dataout <= rxdatain(0) WHEN nl0O0l = '1'  ELSE wire_n0Ol_dataout;
	wire_n00O_dataout <= rxdatain(1) WHEN nl0O0l = '1'  ELSE wire_n0OO_dataout;
	wire_n010i_dataout <= wire_n01Oi_dataout WHEN nl0ili = '1'  ELSE nlOii;
	wire_n010l_dataout <= wire_n01Ol_dataout WHEN nl0ili = '1'  ELSE nlOil;
	wire_n010O_dataout <= wire_n01OO_dataout WHEN nl0ili = '1'  ELSE nlOiO;
	wire_n011i_dataout <= wire_n01li_dataout AND NOT(nl1i);
	wire_n011l_dataout <= wire_n01ll_dataout OR nl1i;
	wire_n011O_dataout <= wire_n01lO_dataout WHEN nl0ili = '1'  ELSE nl1ll;
	wire_n01i_dataout <= wire_n0li_dataout AND NOT(wire_nill_dataout);
	wire_n01ii_dataout <= wire_n001i_dataout WHEN nl0ili = '1'  ELSE nlOli;
	wire_n01il_dataout <= wire_n001l_dataout WHEN nl0ili = '1'  ELSE nlOll;
	wire_n01iO_dataout <= wire_n001O_dataout WHEN nl0ili = '1'  ELSE nlOlO;
	wire_n01l_dataout <= wire_n0ll_dataout AND NOT(wire_nill_dataout);
	wire_n01li_dataout <= wire_n000i_dataout WHEN nl0ili = '1'  ELSE nlOOi;
	wire_n01ll_dataout <= wire_n000l_dataout WHEN nl0ili = '1'  ELSE nlOOl;
	wire_n01lO_dataout <= nl1ll OR nl0iii;
	wire_n01O_dataout <= wire_n0lO_dataout AND NOT(wire_nill_dataout);
	wire_n01Oi_dataout <= nlOii AND NOT(nl0iii);
	wire_n01Ol_dataout <= nlOil OR nl0iii;
	wire_n01OO_dataout <= nlOiO OR nl0iii;
	wire_n0i0i_dataout <= wire_n0Oli_dataout WHEN niiO = '1'  ELSE wire_n0l0O_dataout;
	wire_n0i0l_dataout <= wire_n0Oll_dataout WHEN niiO = '1'  ELSE wire_n0iOi_dataout;
	wire_n0i0O_dataout <= wire_n0OlO_dataout WHEN niiO = '1'  ELSE wire_n0iOl_dataout;
	wire_n0ii_dataout <= rxdatain(2) WHEN nl0O0l = '1'  ELSE wire_ni1i_dataout;
	wire_n0iii_dataout <= wire_n0OOi_dataout WHEN niiO = '1'  ELSE wire_n0iOO_dataout;
	wire_n0iil_dataout <= wire_n0OOl_dataout WHEN niiO = '1'  ELSE wire_n0l1i_dataout;
	wire_n0iiO_dataout <= wire_n0OOO_dataout WHEN niiO = '1'  ELSE wire_n0l1l_dataout;
	wire_n0il_dataout <= rxdatain(3) WHEN nl0O0l = '1'  ELSE wire_ni1l_dataout;
	wire_n0ili_dataout <= wire_ni11i_dataout WHEN niiO = '1'  ELSE wire_n0l1O_dataout;
	wire_n0ill_dataout <= wire_ni11l_dataout WHEN niiO = '1'  ELSE wire_n0l0i_dataout;
	wire_n0ilO_dataout <= wire_ni11O_dataout WHEN niiO = '1'  ELSE wire_n0l0l_dataout;
	wire_n0iO_dataout <= rxdatain(4) WHEN nl0O0l = '1'  ELSE wire_ni1O_dataout;
	wire_n0iOi_dataout <= wire_n0lil_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n0iOl_dataout <= wire_n0liO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0iOO_dataout <= wire_n0lli_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0l0i_dataout <= wire_n0lOl_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0l0l_dataout <= wire_n0lOO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0l0O_dataout <= wire_n0lii_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0l1i_dataout <= wire_n0lll_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0l1l_dataout <= wire_n0llO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0l1O_dataout <= wire_n0lOi_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0li_dataout <= rxdatain(5) WHEN nl0O0l = '1'  ELSE wire_ni0i_dataout;
	wire_n0lii_dataout <= wire_n0O1i_dataout OR nl0OiO;
	wire_n0lil_dataout <= wire_n0O1l_dataout OR nl0OiO;
	wire_n0liO_dataout <= wire_n0O1O_dataout OR nl0OiO;
	wire_n0ll_dataout <= rxdatain(6) WHEN nl0O0l = '1'  ELSE wire_ni0l_dataout;
	wire_n0lli_dataout <= wire_n0O0i_dataout OR nl0OiO;
	wire_n0lll_dataout <= wire_n0O0l_dataout AND NOT(nl0OiO);
	wire_n0llO_dataout <= wire_n0O0O_dataout AND NOT(nl0OiO);
	wire_n0lO_dataout <= rxdatain(7) WHEN nl0O0l = '1'  ELSE wire_ni0O_dataout;
	wire_n0lOi_dataout <= wire_n0Oii_dataout AND NOT(nl0OiO);
	wire_n0lOl_dataout <= wire_n0Oil_dataout AND NOT(nl0OiO);
	wire_n0lOO_dataout <= wire_n0OiO_dataout AND NOT(nl0OiO);
	wire_n0O0i_dataout <= rxdatain(26) OR wire_nl0l_dataout;
	wire_n0O0l_dataout <= rxdatain(27) OR wire_nl0l_dataout;
	wire_n0O0O_dataout <= rxdatain(28) OR wire_nl0l_dataout;
	wire_n0O1i_dataout <= rxctrl(3) OR wire_nl0l_dataout;
	wire_n0O1l_dataout <= rxdatain(24) AND NOT(wire_nl0l_dataout);
	wire_n0O1O_dataout <= rxdatain(25) OR wire_nl0l_dataout;
	wire_n0Oi_dataout <= rxctrl(0) OR wire_nl1l_dataout;
	wire_n0Oii_dataout <= rxdatain(29) OR wire_nl0l_dataout;
	wire_n0Oil_dataout <= rxdatain(30) OR wire_nl0l_dataout;
	wire_n0OiO_dataout <= rxdatain(31) OR wire_nl0l_dataout;
	wire_n0Ol_dataout <= rxdatain(0) AND NOT(wire_nl1l_dataout);
	wire_n0Oli_dataout <= wire_ni10i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0Oll_dataout <= wire_ni10l_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n0OlO_dataout <= wire_ni10O_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0OO_dataout <= rxdatain(1) OR wire_nl1l_dataout;
	wire_n0OOi_dataout <= wire_ni1ii_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0OOl_dataout <= wire_ni1il_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n0OOO_dataout <= wire_ni1iO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n100i_dataout <= wire_n1l0i_dataout WHEN nl0O0l = '1'  ELSE wire_n10Oi_dataout;
	wire_n100l_dataout <= wire_n1l0l_dataout WHEN nl0O0l = '1'  ELSE wire_n10Ol_dataout;
	wire_n100O_dataout <= wire_n1l0O_dataout WHEN nl0O0l = '1'  ELSE wire_n10OO_dataout;
	wire_n101i_dataout <= wire_n10li_dataout AND NOT(nl1i);
	wire_n101l_dataout <= wire_n10ll_dataout AND NOT(nl1i);
	wire_n101O_dataout <= wire_n10lO_dataout AND NOT(nl1i);
	wire_n10i_dataout <= wire_n1Oi_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n10ii_dataout <= wire_n1lii_dataout WHEN nl0O0l = '1'  ELSE wire_n1i1i_dataout;
	wire_n10il_dataout <= wire_n1lil_dataout WHEN nl0O0l = '1'  ELSE wire_n1i1l_dataout;
	wire_n10iO_dataout <= wire_n1liO_dataout WHEN nl0O0l = '1'  ELSE wire_n1i1O_dataout;
	wire_n10l_dataout <= wire_n1Ol_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n10li_dataout <= wire_n1lli_dataout WHEN nl0O0l = '1'  ELSE wire_n1i0i_dataout;
	wire_n10ll_dataout <= wire_n1lll_dataout WHEN nl0O0l = '1'  ELSE wire_n1i0l_dataout;
	wire_n10lO_dataout <= wire_n1llO_dataout WHEN nl0O0l = '1'  ELSE wire_n1i0O_dataout;
	wire_n10O_dataout <= wire_n1OO_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n10Oi_dataout <= wire_n1iii_dataout WHEN nl0i0i = '1'  ELSE ni0ii;
	wire_n10Ol_dataout <= wire_n1iil_dataout WHEN nl0i0i = '1'  ELSE nl11O;
	wire_n10OO_dataout <= wire_n1iiO_dataout WHEN nl0i0i = '1'  ELSE nl10i;
	wire_n11i_dataout <= wire_n1li_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n11l_dataout <= wire_n1ll_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n11li_dataout <= wire_n100i_dataout AND NOT(nl1i);
	wire_n11ll_dataout <= wire_n100l_dataout AND NOT(nl1i);
	wire_n11lO_dataout <= wire_n100O_dataout AND NOT(nl1i);
	wire_n11O_dataout <= wire_n1lO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n11Oi_dataout <= wire_n10ii_dataout AND NOT(nl1i);
	wire_n11Ol_dataout <= wire_n10il_dataout AND NOT(nl1i);
	wire_n11OO_dataout <= wire_n10iO_dataout AND NOT(nl1i);
	wire_n1i0i_dataout <= wire_n1iOi_dataout WHEN nl0i0i = '1'  ELSE nl1il;
	wire_n1i0l_dataout <= wire_n1iOl_dataout WHEN nl0i0i = '1'  ELSE nl1iO;
	wire_n1i0O_dataout <= wire_n1iOO_dataout WHEN nl0i0i = '1'  ELSE nl1li;
	wire_n1i1i_dataout <= wire_n1ili_dataout WHEN nl0i0i = '1'  ELSE nl10l;
	wire_n1i1l_dataout <= wire_n1ill_dataout WHEN nl0i0i = '1'  ELSE nl10O;
	wire_n1i1O_dataout <= wire_n1ilO_dataout WHEN nl0i0i = '1'  ELSE nl1ii;
	wire_n1ii_dataout <= wire_n01i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n1iii_dataout <= ni0ii OR nl00Ol;
	wire_n1iil_dataout <= nl11O AND NOT(nl00Ol);
	wire_n1iiO_dataout <= nl10i OR nl00Ol;
	wire_n1il_dataout <= wire_n01l_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_n1ili_dataout <= nl10l OR nl00Ol;
	wire_n1ill_dataout <= nl10O OR nl00Ol;
	wire_n1ilO_dataout <= nl1ii OR nl00Ol;
	wire_n1iO_dataout <= wire_n01O_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_n1iOi_dataout <= nl1il OR nl00Ol;
	wire_n1iOl_dataout <= nl1iO OR nl00Ol;
	wire_n1iOO_dataout <= nl1li OR nl00Ol;
	wire_n1l0i_dataout <= ni0ii OR nl0i0l;
	wire_n1l0l_dataout <= nl11O AND NOT(nl0i0l);
	wire_n1l0O_dataout <= nl10i OR nl0i0l;
	wire_n1li_dataout <= wire_n00i_dataout OR wire_nill_dataout;
	wire_n1lii_dataout <= nl10l OR nl0i0l;
	wire_n1lil_dataout <= nl10O OR nl0i0l;
	wire_n1liO_dataout <= nl1ii OR nl0i0l;
	wire_n1ll_dataout <= wire_n00l_dataout OR wire_nill_dataout;
	wire_n1lli_dataout <= nl1il OR nl0i0l;
	wire_n1lll_dataout <= nl1iO OR nl0i0l;
	wire_n1llO_dataout <= nl1li OR nl0i0l;
	wire_n1lO_dataout <= wire_n00O_dataout OR wire_nill_dataout;
	wire_n1Oi_dataout <= wire_n0ii_dataout OR wire_nill_dataout;
	wire_n1OiO_dataout <= wire_n011O_dataout OR nl1i;
	wire_n1Ol_dataout <= wire_n0il_dataout AND NOT(wire_nill_dataout);
	wire_n1Oli_dataout <= wire_n010i_dataout AND NOT(nl1i);
	wire_n1Oll_dataout <= wire_n010l_dataout AND NOT(nl1i);
	wire_n1OlO_dataout <= wire_n010O_dataout OR nl1i;
	wire_n1OO_dataout <= wire_n0iO_dataout AND NOT(wire_nill_dataout);
	wire_n1OOi_dataout <= wire_n01ii_dataout OR nl1i;
	wire_n1OOl_dataout <= wire_n01il_dataout OR nl1i;
	wire_n1OOO_dataout <= wire_n01iO_dataout AND NOT(nl1i);
	wire_ni0i_dataout <= rxdatain(5) OR wire_nl1l_dataout;
	wire_ni0il_dataout <= wire_nilOl_dataout WHEN niiO = '1'  ELSE wire_nii1l_dataout;
	wire_ni0iO_dataout <= wire_nilOO_dataout WHEN niiO = '1'  ELSE wire_nii1O_dataout;
	wire_ni0l_dataout <= rxdatain(6) OR wire_nl1l_dataout;
	wire_ni0li_dataout <= wire_niO1i_dataout WHEN niiO = '1'  ELSE wire_nii0i_dataout;
	wire_ni0ll_dataout <= wire_niO1l_dataout WHEN niiO = '1'  ELSE wire_nii0l_dataout;
	wire_ni0lO_dataout <= wire_niO1O_dataout WHEN niiO = '1'  ELSE wire_nii0O_dataout;
	wire_ni0O_dataout <= rxdatain(7) OR wire_nl1l_dataout;
	wire_ni0Oi_dataout <= wire_niO0i_dataout WHEN niiO = '1'  ELSE wire_niiii_dataout;
	wire_ni0Ol_dataout <= wire_niO0l_dataout WHEN niiO = '1'  ELSE wire_niiil_dataout;
	wire_ni0OO_dataout <= wire_niO0O_dataout WHEN niiO = '1'  ELSE wire_niiiO_dataout;
	wire_ni10i_dataout <= wire_n0O1i_dataout OR nl0iOi;
	wire_ni10l_dataout <= wire_n0O1l_dataout OR nl0iOi;
	wire_ni10O_dataout <= wire_n0O1O_dataout OR nl0iOi;
	wire_ni11i_dataout <= wire_ni1li_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_ni11l_dataout <= wire_ni1ll_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_ni11O_dataout <= wire_ni1lO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_ni1i_dataout <= rxdatain(2) OR wire_nl1l_dataout;
	wire_ni1ii_dataout <= wire_n0O0i_dataout OR nl0iOi;
	wire_ni1il_dataout <= wire_n0O0l_dataout AND NOT(nl0iOi);
	wire_ni1iO_dataout <= wire_n0O0O_dataout AND NOT(nl0iOi);
	wire_ni1l_dataout <= rxdatain(3) OR wire_nl1l_dataout;
	wire_ni1li_dataout <= wire_n0Oii_dataout AND NOT(nl0iOi);
	wire_ni1ll_dataout <= wire_n0Oil_dataout AND NOT(nl0iOi);
	wire_ni1lO_dataout <= wire_n0OiO_dataout AND NOT(nl0iOi);
	wire_ni1O_dataout <= rxdatain(4) OR wire_nl1l_dataout;
	wire_nii0i_dataout <= wire_niiOi_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nii0l_dataout <= wire_niiOl_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nii0O_dataout <= wire_niiOO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nii1i_dataout <= wire_niOii_dataout WHEN niiO = '1'  ELSE wire_niili_dataout;
	wire_nii1l_dataout <= wire_niill_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nii1O_dataout <= wire_niilO_dataout OR wire_w_lg_nl0lOi98w(0);
	wire_niiii_dataout <= wire_nil1i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niiil_dataout <= wire_nil1l_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niiiO_dataout <= wire_nil1O_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niili_dataout <= wire_nil0i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niill_dataout <= wire_nil0l_dataout OR nl0OiO;
	wire_niilO_dataout <= wire_nil0O_dataout OR nl0OiO;
	wire_niiOi_dataout <= wire_nilii_dataout OR nl0OiO;
	wire_niiOl_dataout <= wire_nilil_dataout OR nl0OiO;
	wire_niiOO_dataout <= wire_niliO_dataout AND NOT(nl0OiO);
	wire_nil0i_dataout <= wire_nilOi_dataout AND NOT(nl0OiO);
	wire_nil0l_dataout <= rxctrl(2) OR wire_nl0i_dataout;
	wire_nil0O_dataout <= rxdatain(16) AND NOT(wire_nl0i_dataout);
	wire_nil1i_dataout <= wire_nilli_dataout AND NOT(nl0OiO);
	wire_nil1l_dataout <= wire_nilll_dataout AND NOT(nl0OiO);
	wire_nil1O_dataout <= wire_nillO_dataout AND NOT(nl0OiO);
	wire_nili_dataout <= wire_w_lg_nl0OiO113w(0) AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nilii_dataout <= rxdatain(17) OR wire_nl0i_dataout;
	wire_nilil_dataout <= rxdatain(18) OR wire_nl0i_dataout;
	wire_niliO_dataout <= rxdatain(19) OR wire_nl0i_dataout;
	wire_nill_dataout <= nl0OiO AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nilli_dataout <= rxdatain(20) OR wire_nl0i_dataout;
	wire_nilll_dataout <= rxdatain(21) OR wire_nl0i_dataout;
	wire_nillO_dataout <= rxdatain(22) OR wire_nl0i_dataout;
	wire_nilOi_dataout <= rxdatain(23) OR wire_nl0i_dataout;
	wire_nilOl_dataout <= wire_niOil_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nilOO_dataout <= wire_niOiO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niO0i_dataout <= wire_niOOi_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niO0l_dataout <= wire_niOOl_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niO0O_dataout <= wire_niOOO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niO1i_dataout <= wire_niOli_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niO1l_dataout <= wire_niOll_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niO1O_dataout <= wire_niOlO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niOii_dataout <= wire_nl11i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_niOil_dataout <= wire_nil0l_dataout OR nl0iOl;
	wire_niOiO_dataout <= wire_nil0O_dataout OR nl0iOl;
	wire_niOli_dataout <= wire_nilii_dataout OR nl0iOl;
	wire_niOll_dataout <= wire_nilil_dataout OR nl0iOl;
	wire_niOlO_dataout <= wire_niliO_dataout AND NOT(nl0iOl);
	wire_niOOi_dataout <= wire_nilli_dataout AND NOT(nl0iOl);
	wire_niOOl_dataout <= wire_nilll_dataout AND NOT(nl0iOl);
	wire_niOOO_dataout <= wire_nillO_dataout AND NOT(nl0iOl);
	wire_nl00i_dataout <= wire_nllli_dataout WHEN niiO = '1'  ELSE wire_nl0Oi_dataout;
	wire_nl00l_dataout <= wire_nllll_dataout WHEN niiO = '1'  ELSE wire_nl0Ol_dataout;
	wire_nl00O_dataout <= wire_nl0OO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl01i_dataout <= wire_nllii_dataout WHEN niiO = '1'  ELSE wire_nl0li_dataout;
	wire_nl01l_dataout <= wire_nllil_dataout WHEN niiO = '1'  ELSE wire_nl0ll_dataout;
	wire_nl01O_dataout <= wire_nlliO_dataout WHEN niiO = '1'  ELSE wire_nl0lO_dataout;
	wire_nl0i_dataout <= rxrunningdisp(2) AND NOT(nl1i);
	wire_nl0i_w_lg_dataout92w(0) <= NOT wire_nl0i_dataout;
	wire_nl0ii_dataout <= wire_nli1i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0il_dataout <= wire_nli1l_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0iO_dataout <= wire_nli1O_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0l_dataout <= rxrunningdisp(3) AND NOT(nl1i);
	wire_nl0l_w_lg_dataout123w(0) <= NOT wire_nl0l_dataout;
	wire_nl0li_dataout <= wire_nli0i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0ll_dataout <= wire_nli0l_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0lO_dataout <= wire_nli0O_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0Oi_dataout <= wire_nliii_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0Ol_dataout <= wire_nliil_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nl0OO_dataout <= wire_nliiO_dataout OR nl0OiO;
	wire_nl11i_dataout <= wire_nilOi_dataout AND NOT(nl0iOl);
	wire_nl1l_dataout <= rxrunningdisp(0) AND NOT(nl1i);
	wire_nl1l_w_lg_dataout80w(0) <= NOT wire_nl1l_dataout;
	wire_nl1lO_dataout <= wire_nll1O_dataout WHEN niiO = '1'  ELSE wire_nl00O_dataout;
	wire_nl1O_dataout <= rxrunningdisp(1) AND NOT(nl1i);
	wire_nl1O_w_lg_dataout89w(0) <= NOT wire_nl1O_dataout;
	wire_nl1O_w_lg_dataout182w(0) <= wire_nl1O_dataout OR wire_w_lg_w_lg_nli0iO178w181w(0);
	wire_nl1Oi_dataout <= wire_nll0i_dataout WHEN niiO = '1'  ELSE wire_nl0ii_dataout;
	wire_nl1Ol_dataout <= wire_nll0l_dataout WHEN niiO = '1'  ELSE wire_nl0il_dataout;
	wire_nl1OO_dataout <= wire_nll0O_dataout WHEN niiO = '1'  ELSE wire_nl0iO_dataout;
	wire_nli0i_dataout <= wire_nliOi_dataout AND NOT(nl0OiO);
	wire_nli0l_dataout <= wire_nliOl_dataout AND NOT(nl0OiO);
	wire_nli0O_dataout <= wire_nliOO_dataout AND NOT(nl0OiO);
	wire_nli1i_dataout <= wire_nlili_dataout OR nl0OiO;
	wire_nli1l_dataout <= wire_nlill_dataout OR nl0OiO;
	wire_nli1O_dataout <= wire_nlilO_dataout OR nl0OiO;
	wire_nliii_dataout <= wire_nll1i_dataout AND NOT(nl0OiO);
	wire_nliil_dataout <= wire_nll1l_dataout AND NOT(nl0OiO);
	wire_nliiO_dataout <= rxctrl(1) OR wire_nl1O_dataout;
	wire_nlili_dataout <= rxdatain(8) AND NOT(wire_nl1O_dataout);
	wire_nlill_dataout <= rxdatain(9) OR wire_nl1O_dataout;
	wire_nlilO_dataout <= rxdatain(10) OR wire_nl1O_dataout;
	wire_nliOi_dataout <= rxdatain(11) OR wire_nl1O_dataout;
	wire_nliOl_dataout <= rxdatain(12) OR wire_nl1O_dataout;
	wire_nliOO_dataout <= rxdatain(13) OR wire_nl1O_dataout;
	wire_nll0i_dataout <= wire_nllOi_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nll0l_dataout <= wire_nllOl_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nll0O_dataout <= wire_nllOO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nll1i_dataout <= rxdatain(14) OR wire_nl1O_dataout;
	wire_nll1l_dataout <= rxdatain(15) OR wire_nl1O_dataout;
	wire_nll1O_dataout <= wire_nlllO_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nllii_dataout <= wire_nlO1i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nllil_dataout <= wire_nlO1l_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nlliO_dataout <= wire_nlO1O_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nllli_dataout <= wire_nlO0i_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nllll_dataout <= wire_nlO0l_dataout AND NOT(wire_w_lg_nl0lOi98w(0));
	wire_nlllO_dataout <= wire_nliiO_dataout OR nl0l1l;
	wire_nllO0i_dataout <= wire_nlO10O_dataout AND NOT(nl1i);
	wire_nllO0l_dataout <= wire_nllOOi_dataout OR nl1i;
	wire_nllO0O_dataout <= wire_nllOOl_dataout AND NOT(nl1i);
	wire_nllOi_dataout <= wire_nlili_dataout OR nl0l1l;
	wire_nllOii_dataout <= wire_nllOOO_dataout AND NOT(nl1i);
	wire_nllOil_dataout <= wire_nlO11i_dataout AND NOT(nl1i);
	wire_nllOiO_dataout <= wire_nlO11l_dataout AND NOT(nl1i);
	wire_nllOl_dataout <= wire_nlill_dataout OR nl0l1l;
	wire_nllOli_dataout <= wire_nlO11O_dataout AND NOT(nl1i);
	wire_nllOll_dataout <= wire_nlO10i_dataout AND NOT(nl1i);
	wire_nllOlO_dataout <= wire_nlO10l_dataout AND NOT(nl1i);
	wire_nllOO_dataout <= wire_nlilO_dataout OR nl0l1l;
	wire_nllOOi_dataout <= wire_nlO1ii_dataout WHEN nl00il = '1'  ELSE n00li;
	wire_nllOOl_dataout <= wire_nlO1il_dataout WHEN nl00il = '1'  ELSE n00ll;
	wire_nllOOO_dataout <= wire_nlO1iO_dataout WHEN nl00il = '1'  ELSE n00lO;
	wire_nlO0i_dataout <= wire_nll1i_dataout AND NOT(nl0l1l);
	wire_nlO0l_dataout <= wire_nll1l_dataout AND NOT(nl0l1l);
	wire_nlO0Oi_dataout <= wire_nlOiii_dataout AND NOT(nl1i);
	wire_nlO0Ol_dataout <= wire_nlOiil_dataout AND NOT(nl1i);
	wire_nlO0OO_dataout <= wire_nlOiiO_dataout AND NOT(nl1i);
	wire_nlO10i_dataout <= wire_nlO1Oi_dataout WHEN nl00il = '1'  ELSE n0i1i;
	wire_nlO10l_dataout <= wire_nlO1Ol_dataout WHEN nl00il = '1'  ELSE n0i1l;
	wire_nlO10O_dataout <= wire_nlO1OO_dataout WHEN nl00il = '1'  ELSE n1Oil;
	wire_nlO11i_dataout <= wire_nlO1li_dataout WHEN nl00il = '1'  ELSE n00Oi;
	wire_nlO11l_dataout <= wire_nlO1ll_dataout WHEN nl00il = '1'  ELSE n00Ol;
	wire_nlO11O_dataout <= wire_nlO1lO_dataout WHEN nl00il = '1'  ELSE n00OO;
	wire_nlO1i_dataout <= wire_nliOi_dataout AND NOT(nl0l1l);
	wire_nlO1ii_dataout <= n00li AND NOT(nl00ii);
	wire_nlO1il_dataout <= n00ll OR nl00ii;
	wire_nlO1iO_dataout <= n00lO OR nl00ii;
	wire_nlO1l_dataout <= wire_nliOl_dataout AND NOT(nl0l1l);
	wire_nlO1li_dataout <= n00Oi OR nl00ii;
	wire_nlO1ll_dataout <= n00Ol OR nl00ii;
	wire_nlO1lO_dataout <= n00OO OR nl00ii;
	wire_nlO1O_dataout <= wire_nliOO_dataout AND NOT(nl0l1l);
	wire_nlO1Oi_dataout <= n0i1i OR nl00ii;
	wire_nlO1Ol_dataout <= n0i1l OR nl00ii;
	wire_nlO1OO_dataout <= n1Oil OR nl00ii;
	wire_nlOi0i_dataout <= wire_nlOiOi_dataout AND NOT(nl1i);
	wire_nlOi0l_dataout <= wire_nlOiOl_dataout AND NOT(nl1i);
	wire_nlOi0O_dataout <= wire_nlOiOO_dataout AND NOT(nl1i);
	wire_nlOi1i_dataout <= wire_nlOili_dataout AND NOT(nl1i);
	wire_nlOi1l_dataout <= wire_nlOill_dataout AND NOT(nl1i);
	wire_nlOi1O_dataout <= wire_nlOilO_dataout AND NOT(nl1i);
	wire_nlOiii_dataout <= wire_nlOO0O_dataout WHEN nl00ll = '1'  ELSE wire_nlOl1i_dataout;
	wire_nlOiil_dataout <= wire_nlOOii_dataout WHEN nl00ll = '1'  ELSE wire_nlOl1l_dataout;
	wire_nlOiiO_dataout <= wire_nlOOil_dataout WHEN nl00ll = '1'  ELSE wire_nlOl1O_dataout;
	wire_nlOili_dataout <= wire_nlOOiO_dataout WHEN nl00ll = '1'  ELSE wire_nlOl0i_dataout;
	wire_nlOill_dataout <= wire_nlOOli_dataout WHEN nl00ll = '1'  ELSE wire_nlOl0l_dataout;
	wire_nlOilO_dataout <= wire_nlOOll_dataout WHEN nl00ll = '1'  ELSE wire_nlOl0O_dataout;
	wire_nlOiOi_dataout <= wire_nlOOlO_dataout WHEN nl00ll = '1'  ELSE wire_nlOlii_dataout;
	wire_nlOiOl_dataout <= wire_nlOOOi_dataout WHEN nl00ll = '1'  ELSE wire_nlOlil_dataout;
	wire_nlOiOO_dataout <= wire_nlOOOl_dataout WHEN nl00ll = '1'  ELSE wire_nlOliO_dataout;
	wire_nlOl0i_dataout <= wire_nlOlOi_dataout WHEN nlOOO = '1'  ELSE ni01i;
	wire_nlOl0l_dataout <= wire_nlOlOl_dataout WHEN nlOOO = '1'  ELSE ni01l;
	wire_nlOl0O_dataout <= wire_nlOlOO_dataout WHEN nlOOO = '1'  ELSE ni01O;
	wire_nlOl1i_dataout <= wire_nlOlli_dataout WHEN nlOOO = '1'  ELSE n0i1O;
	wire_nlOl1l_dataout <= wire_nlOlll_dataout WHEN nlOOO = '1'  ELSE ni1Ol;
	wire_nlOl1O_dataout <= wire_nlOllO_dataout WHEN nlOOO = '1'  ELSE ni1OO;
	wire_nlOlii_dataout <= wire_nlOO1i_dataout WHEN nlOOO = '1'  ELSE ni00i;
	wire_nlOlil_dataout <= wire_nlOO1l_dataout WHEN nlOOO = '1'  ELSE ni00l;
	wire_nlOliO_dataout <= wire_nlOO1O_dataout WHEN nlOOO = '1'  ELSE ni00O;
	wire_nlOlli_dataout <= n0i1O OR nl00lO;
	wire_nlOlll_dataout <= ni1Ol AND NOT(nl00lO);
	wire_nlOllO_dataout <= ni1OO OR nl00lO;
	wire_nlOlOi_dataout <= ni01i OR nl00lO;
	wire_nlOlOl_dataout <= ni01l OR nl00lO;
	wire_nlOlOO_dataout <= ni01O OR nl00lO;
	wire_nlOO0O_dataout <= n0i1O OR nl00Oi;
	wire_nlOO1i_dataout <= ni00i OR nl00lO;
	wire_nlOO1l_dataout <= ni00l OR nl00lO;
	wire_nlOO1O_dataout <= ni00O OR nl00lO;
	wire_nlOOii_dataout <= ni1Ol AND NOT(nl00Oi);
	wire_nlOOil_dataout <= ni1OO OR nl00Oi;
	wire_nlOOiO_dataout <= ni01i OR nl00Oi;
	wire_nlOOli_dataout <= ni01l OR nl00Oi;
	wire_nlOOll_dataout <= ni01O OR nl00Oi;
	wire_nlOOlO_dataout <= ni00i OR nl00Oi;
	wire_nlOOOi_dataout <= ni00l OR nl00Oi;
	wire_nlOOOl_dataout <= ni00O OR nl00Oi;

 END RTL; --stratixgx_xgm_rx_sm
--synopsys translate_on
--VALID FILE
--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 140 mux21 317 oper_add 1 oper_decoder 1 oper_less_than 1 oper_mux 39 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_xgm_tx_sm IS 
	 PORT 
	 ( 
		 rdenablesync	:	IN  STD_LOGIC;
		 resetall	:	IN  STD_LOGIC;
		 txclk	:	IN  STD_LOGIC;
		 txctrl	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 txctrlout	:	OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 txdatain	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 txdataout	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)
	 ); 
 END stratixgx_xgm_tx_sm;

 ARCHITECTURE RTL OF stratixgx_xgm_tx_sm IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 niOOOO53	:	STD_LOGIC := '0';
	 SIGNAL	 niOOOO54	:	STD_LOGIC := '0';
	 SIGNAL	 nl000l5	:	STD_LOGIC := '0';
	 SIGNAL	 nl000l6	:	STD_LOGIC := '0';
	 SIGNAL	 nl00iO3	:	STD_LOGIC := '0';
	 SIGNAL	 nl00iO4	:	STD_LOGIC := '0';
	 SIGNAL	 nl00Oi1	:	STD_LOGIC := '0';
	 SIGNAL	 nl00Oi2	:	STD_LOGIC := '0';
	 SIGNAL	 nl010i13	:	STD_LOGIC := '0';
	 SIGNAL	 nl010i14	:	STD_LOGIC := '0';
	 SIGNAL	 nl01il11	:	STD_LOGIC := '0';
	 SIGNAL	 nl01il12	:	STD_LOGIC := '0';
	 SIGNAL	 nl01lO10	:	STD_LOGIC := '0';
	 SIGNAL	 nl01lO9	:	STD_LOGIC := '0';
	 SIGNAL	 nl01OO7	:	STD_LOGIC := '0';
	 SIGNAL	 nl01OO8	:	STD_LOGIC := '0';
	 SIGNAL	 nl100O39	:	STD_LOGIC := '0';
	 SIGNAL	 nl100O40	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ll37	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ll38	:	STD_LOGIC := '0';
	 SIGNAL	 nl111i51	:	STD_LOGIC := '0';
	 SIGNAL	 nl111i52	:	STD_LOGIC := '0';
	 SIGNAL	 nl11iO49	:	STD_LOGIC := '0';
	 SIGNAL	 nl11iO50	:	STD_LOGIC := '0';
	 SIGNAL	 nl11li47	:	STD_LOGIC := '0';
	 SIGNAL	 nl11li48	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO45	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO46	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Oi43	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Oi44	:	STD_LOGIC := '0';
	 SIGNAL	 nl11OO41	:	STD_LOGIC := '0';
	 SIGNAL	 nl11OO42	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i0l33	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i0l34	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i1i35	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i1i36	:	STD_LOGIC := '0';
	 SIGNAL	 nl1iiO31	:	STD_LOGIC := '0';
	 SIGNAL	 nl1iiO32	:	STD_LOGIC := '0';
	 SIGNAL	 nl1ilO29	:	STD_LOGIC := '0';
	 SIGNAL	 nl1ilO30	:	STD_LOGIC := '0';
	 SIGNAL	 nl1iOO27	:	STD_LOGIC := '0';
	 SIGNAL	 nl1iOO28	:	STD_LOGIC := '0';
	 SIGNAL	 nl1l0i25	:	STD_LOGIC := '0';
	 SIGNAL	 nl1l0i26	:	STD_LOGIC := '0';
	 SIGNAL	 nl1lli23	:	STD_LOGIC := '0';
	 SIGNAL	 nl1lli24	:	STD_LOGIC := '0';
	 SIGNAL	 nl1lOi21	:	STD_LOGIC := '0';
	 SIGNAL	 nl1lOi22	:	STD_LOGIC := '0';
	 SIGNAL	 nl1O0i19	:	STD_LOGIC := '0';
	 SIGNAL	 nl1O0i20	:	STD_LOGIC := '0';
	 SIGNAL	 nl1Oii17	:	STD_LOGIC := '0';
	 SIGNAL	 nl1Oii18	:	STD_LOGIC := '0';
	 SIGNAL	 nl1OOi15	:	STD_LOGIC := '0';
	 SIGNAL	 nl1OOi16	:	STD_LOGIC := '0';
	 SIGNAL	n00i	:	STD_LOGIC := '0';
	 SIGNAL	n01i	:	STD_LOGIC := '0';
	 SIGNAL	n01l	:	STD_LOGIC := '0';
	 SIGNAL	n10i	:	STD_LOGIC := '0';
	 SIGNAL	n10l	:	STD_LOGIC := '0';
	 SIGNAL	n10O	:	STD_LOGIC := '0';
	 SIGNAL	n11i	:	STD_LOGIC := '0';
	 SIGNAL	n11l	:	STD_LOGIC := '0';
	 SIGNAL	n11O	:	STD_LOGIC := '0';
	 SIGNAL	n1ii	:	STD_LOGIC := '0';
	 SIGNAL	n1il	:	STD_LOGIC := '0';
	 SIGNAL	n1iO	:	STD_LOGIC := '0';
	 SIGNAL	n1li	:	STD_LOGIC := '0';
	 SIGNAL	n1Oi	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol	:	STD_LOGIC := '0';
	 SIGNAL	n1OO	:	STD_LOGIC := '0';
	 SIGNAL	nllOO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0O	:	STD_LOGIC := '0';
	 SIGNAL	nlO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOii	:	STD_LOGIC := '0';
	 SIGNAL	nlOiO	:	STD_LOGIC := '0';
	 SIGNAL	nlOli	:	STD_LOGIC := '0';
	 SIGNAL	nlOll	:	STD_LOGIC := '0';
	 SIGNAL	nlOlO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOOO	:	STD_LOGIC := '0';
	 SIGNAL	n00O	:	STD_LOGIC := '0';
	 SIGNAL	n0Ol	:	STD_LOGIC := '0';
	 SIGNAL	n0OOO	:	STD_LOGIC := '0';
	 SIGNAL	nli0O	:	STD_LOGIC := '0';
	 SIGNAL	nliii	:	STD_LOGIC := '0';
	 SIGNAL	nlliO	:	STD_LOGIC := '0';
	 SIGNAL	nllli	:	STD_LOGIC := '0';
	 SIGNAL	nllll	:	STD_LOGIC := '0';
	 SIGNAL	nlllO	:	STD_LOGIC := '0';
	 SIGNAL	nllOi	:	STD_LOGIC := '0';
	 SIGNAL	nllOl	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0Oi_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n0Oi_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n0Oi_w_lg_n00O166w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0Oi_w_lg_n0Ol212w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0Oi_w_lg_n0OOO272w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0Oi_w_lg_nliii279w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0Oil	:	STD_LOGIC := '0';
	 SIGNAL	n0OiO	:	STD_LOGIC := '0';
	 SIGNAL	n0Oli	:	STD_LOGIC := '0';
	 SIGNAL	n0Oll	:	STD_LOGIC := '0';
	 SIGNAL	n0OOl	:	STD_LOGIC := '0';
	 SIGNAL	n1l0l	:	STD_LOGIC := '0';
	 SIGNAL	n1l0O	:	STD_LOGIC := '0';
	 SIGNAL	n1lii	:	STD_LOGIC := '0';
	 SIGNAL	n1lil	:	STD_LOGIC := '0';
	 SIGNAL	n1lli	:	STD_LOGIC := '0';
	 SIGNAL	n1lll	:	STD_LOGIC := '0';
	 SIGNAL	n1OOO	:	STD_LOGIC := '0';
	 SIGNAL	nll01i	:	STD_LOGIC := '0';
	 SIGNAL	nll1li	:	STD_LOGIC := '0';
	 SIGNAL	nll1ll	:	STD_LOGIC := '0';
	 SIGNAL	nll1lO	:	STD_LOGIC := '0';
	 SIGNAL	nll1Oi	:	STD_LOGIC := '0';
	 SIGNAL	nll1OO	:	STD_LOGIC := '0';
	 SIGNAL	nlOi0i	:	STD_LOGIC := '0';
	 SIGNAL	nlOi0l	:	STD_LOGIC := '0';
	 SIGNAL	nlOi0O	:	STD_LOGIC := '0';
	 SIGNAL	nlOi1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOiil	:	STD_LOGIC := '0';
	 SIGNAL	nlOiiO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0OOi_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_PRN	:	STD_LOGIC;
	 SIGNAL	n1lO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0i	:	STD_LOGIC := '0';
	 SIGNAL	nlO0l	:	STD_LOGIC := '0';
	 SIGNAL	nlO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOil	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1ll_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n1ll_PRN	:	STD_LOGIC;
	 SIGNAL	n00l	:	STD_LOGIC := '0';
	 SIGNAL	n0O0O	:	STD_LOGIC := '0';
	 SIGNAL	n0Oii	:	STD_LOGIC := '0';
	 SIGNAL	n0OlO	:	STD_LOGIC := '0';
	 SIGNAL	n0OO	:	STD_LOGIC := '0';
	 SIGNAL	n1l0i	:	STD_LOGIC := '0';
	 SIGNAL	n1l1O	:	STD_LOGIC := '0';
	 SIGNAL	n1liO	:	STD_LOGIC := '0';
	 SIGNAL	ni1l	:	STD_LOGIC := '0';
	 SIGNAL	nl01O	:	STD_LOGIC := '0';
	 SIGNAL	nli0i	:	STD_LOGIC := '0';
	 SIGNAL	nli0l	:	STD_LOGIC := '0';
	 SIGNAL	nli1O	:	STD_LOGIC := '0';
	 SIGNAL	nll1il	:	STD_LOGIC := '0';
	 SIGNAL	nll1iO	:	STD_LOGIC := '0';
	 SIGNAL	nll1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nlOi1i	:	STD_LOGIC := '0';
	 SIGNAL	nlOi1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOiii	:	STD_LOGIC := '0';
	 SIGNAL	wire_ni1i_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_ni1i_w_lg_w_lg_w_lg_w_lg_ni1l162w168w213w214w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_w_lg_w_lg_w_lg_ni1l162w168w169w170w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_w_lg_w_lg_ni1l162w164w165w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w213w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w169w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_w_lg_ni1l162w164w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_w_lg_ni1l162w168w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_n00l278w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_n0OO163w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni1i_w_lg_ni1l162w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n000i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n000l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n000O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n001O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n00OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n010O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n011O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n01OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nll1O_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nll1O_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_nll1O_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl11O_i	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl11O_o	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0OO_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0OO_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0OO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1O0O_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1O0O_o	:	STD_LOGIC;
	 SIGNAL  wire_n1O0O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1Oii_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1Oii_o	:	STD_LOGIC;
	 SIGNAL  wire_n1Oii_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1Oil_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1Oil_o	:	STD_LOGIC;
	 SIGNAL  wire_n1Oil_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OiO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1OiO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OiO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1Oli_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1Oli_o	:	STD_LOGIC;
	 SIGNAL  wire_n1Oli_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1Oll_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1Oll_o	:	STD_LOGIC;
	 SIGNAL  wire_n1Oll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OlO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1OlO_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OlO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOi_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1OOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOi_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n1OOl_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n1OOl_o	:	STD_LOGIC;
	 SIGNAL  wire_n1OOl_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01i_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni01i_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01l_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni01l_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni01O_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni01O_o	:	STD_LOGIC;
	 SIGNAL  wire_ni01O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1li_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni1li_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1li_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1ll_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni1ll_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1ll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1lO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni1lO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1lO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1Oi_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni1Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1Oi_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1Ol_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni1Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1Ol_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_ni1OO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_ni1OO_o	:	STD_LOGIC;
	 SIGNAL  wire_ni1OO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_niOOl_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_niOOl_o	:	STD_LOGIC;
	 SIGNAL  wire_niOOl_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_niOOO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_niOOO_o	:	STD_LOGIC;
	 SIGNAL  wire_niOOO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl11i_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl11i_o	:	STD_LOGIC;
	 SIGNAL  wire_nl11i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0ll_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nll0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0ll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0lO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nll0lO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0lO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0Oi_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nll0Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0Oi_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0Ol_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nll0Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0Ol_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0OO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nll0OO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0OO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlli0i_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlli0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli0i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlli1i_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlli1i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli1i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlli1l_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlli1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli1l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlli1O_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlli1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli1O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOl0i_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOl0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOl0i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOl0l_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOl0l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOl0l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOl0O_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOl0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOl0O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOlii_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOlii_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOlii_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOlil_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOlil_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOlil_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOliO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOliO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOliO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOlli_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOlli_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOlli_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOlll_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOlll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOlll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOllO_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlOllO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOllO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_txctrl_range35w139w140w141w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_txctrl_range35w139w140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_rdenablesync266w267w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nl11il273w274w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11ll270w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11ll210w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rdenablesync269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range1w3w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range1w149w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range35w37w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range35w139w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range63w65w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range94w96w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range208w1612w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range192w1626w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range184w1759w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range200w1619w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl000i21w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl001l25w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl001O23w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl00ii16w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl00il14w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl00ll9w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl00lO7w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl010O43w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl011i52w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl011l50w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl011O48w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl01ii41w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl01li36w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl01Ol30w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0i1l2w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl101i1196w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl10Oi1195w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl110i277w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl111l276w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11il209w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1i0i124w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1i1O126w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1iii119w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1iil117w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1ill112w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1iOl107w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1l0O95w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1l1l102w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1l1O100w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1lil92w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1liO90w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1llO85w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1lOO80w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1O0O69w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1O1i78w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1O1l76w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1O1O74w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1OiO64w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1Oll61w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1OlO59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl1OOO54w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rdenablesync266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_resetall156w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txctrl_range35w148w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range191w1566w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range207w1611w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range180w1575w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_txdatain_range199w1557w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_rdenablesync266w267w268w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11il273w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  niOOOi :	STD_LOGIC;
	 SIGNAL  niOOOl :	STD_LOGIC;
	 SIGNAL  nl000i :	STD_LOGIC;
	 SIGNAL  nl001l :	STD_LOGIC;
	 SIGNAL  nl001O :	STD_LOGIC;
	 SIGNAL  nl00ii :	STD_LOGIC;
	 SIGNAL  nl00il :	STD_LOGIC;
	 SIGNAL  nl00ll :	STD_LOGIC;
	 SIGNAL  nl00lO :	STD_LOGIC;
	 SIGNAL  nl010O :	STD_LOGIC;
	 SIGNAL  nl011i :	STD_LOGIC;
	 SIGNAL  nl011l :	STD_LOGIC;
	 SIGNAL  nl011O :	STD_LOGIC;
	 SIGNAL  nl01ii :	STD_LOGIC;
	 SIGNAL  nl01li :	STD_LOGIC;
	 SIGNAL  nl01ll :	STD_LOGIC;
	 SIGNAL  nl01Ol :	STD_LOGIC;
	 SIGNAL  nl0i1l :	STD_LOGIC;
	 SIGNAL  nl100i :	STD_LOGIC;
	 SIGNAL  nl100l :	STD_LOGIC;
	 SIGNAL  nl101i :	STD_LOGIC;
	 SIGNAL  nl101l :	STD_LOGIC;
	 SIGNAL  nl101O :	STD_LOGIC;
	 SIGNAL  nl10il :	STD_LOGIC;
	 SIGNAL  nl10iO :	STD_LOGIC;
	 SIGNAL  nl10li :	STD_LOGIC;
	 SIGNAL  nl10Oi :	STD_LOGIC;
	 SIGNAL  nl10Ol :	STD_LOGIC;
	 SIGNAL  nl10OO :	STD_LOGIC;
	 SIGNAL  nl110i :	STD_LOGIC;
	 SIGNAL  nl110l :	STD_LOGIC;
	 SIGNAL  nl110O :	STD_LOGIC;
	 SIGNAL  nl111l :	STD_LOGIC;
	 SIGNAL  nl111O :	STD_LOGIC;
	 SIGNAL  nl11ii :	STD_LOGIC;
	 SIGNAL  nl11il :	STD_LOGIC;
	 SIGNAL  nl11ll :	STD_LOGIC;
	 SIGNAL  nl11Ol :	STD_LOGIC;
	 SIGNAL  nl1i0i :	STD_LOGIC;
	 SIGNAL  nl1i1O :	STD_LOGIC;
	 SIGNAL  nl1iii :	STD_LOGIC;
	 SIGNAL  nl1iil :	STD_LOGIC;
	 SIGNAL  nl1ill :	STD_LOGIC;
	 SIGNAL  nl1iOl :	STD_LOGIC;
	 SIGNAL  nl1l0O :	STD_LOGIC;
	 SIGNAL  nl1l1l :	STD_LOGIC;
	 SIGNAL  nl1l1O :	STD_LOGIC;
	 SIGNAL  nl1lii :	STD_LOGIC;
	 SIGNAL  nl1lil :	STD_LOGIC;
	 SIGNAL  nl1liO :	STD_LOGIC;
	 SIGNAL  nl1llO :	STD_LOGIC;
	 SIGNAL  nl1lOO :	STD_LOGIC;
	 SIGNAL  nl1O0O :	STD_LOGIC;
	 SIGNAL  nl1O1i :	STD_LOGIC;
	 SIGNAL  nl1O1l :	STD_LOGIC;
	 SIGNAL  nl1O1O :	STD_LOGIC;
	 SIGNAL  nl1OiO :	STD_LOGIC;
	 SIGNAL  nl1Oli :	STD_LOGIC;
	 SIGNAL  nl1Oll :	STD_LOGIC;
	 SIGNAL  nl1OlO :	STD_LOGIC;
	 SIGNAL  nl1OOO :	STD_LOGIC;
	 SIGNAL  wire_w_txctrl_range1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txctrl_range35w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txctrl_range63w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txctrl_range94w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range208w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range192w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range191w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range207w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range184w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range180w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range200w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_txdatain_range199w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_gnd <= '0';
	wire_w_lg_w_lg_w_lg_w_txctrl_range35w139w140w141w(0) <= wire_w_lg_w_lg_w_txctrl_range35w139w140w(0) AND nl10il;
	wire_w_lg_w_lg_w_txctrl_range35w139w140w(0) <= wire_w_lg_w_txctrl_range35w139w(0) AND wire_w_txctrl_range94w(0);
	wire_w_lg_w_lg_rdenablesync266w267w(0) <= wire_w_lg_rdenablesync266w(0) AND nl111O;
	wire_w_lg_w_lg_nl11il273w274w(0) <= wire_w_lg_nl11il273w(0) AND nl110l;
	wire_w_lg_nl11ll270w(0) <= nl11ll AND wire_w_lg_rdenablesync269w(0);
	wire_w_lg_nl11ll210w(0) <= nl11ll AND wire_w_lg_nl11il209w(0);
	wire_w_lg_rdenablesync269w(0) <= rdenablesync AND nl111O;
	wire_w_lg_w_txctrl_range1w3w(0) <= wire_w_txctrl_range1w(0) AND wire_w_lg_nl0i1l2w(0);
	wire_w_lg_w_txctrl_range1w149w(0) <= wire_w_txctrl_range1w(0) AND wire_w_lg_w_txctrl_range35w148w(0);
	wire_w_lg_w_txctrl_range35w37w(0) <= wire_w_txctrl_range35w(0) AND wire_w_lg_nl01li36w(0);
	wire_w_lg_w_txctrl_range35w139w(0) <= wire_w_txctrl_range35w(0) AND wire_w_txctrl_range63w(0);
	wire_w_lg_w_txctrl_range63w65w(0) <= wire_w_txctrl_range63w(0) AND wire_w_lg_nl1OiO64w(0);
	wire_w_lg_w_txctrl_range94w96w(0) <= wire_w_txctrl_range94w(0) AND wire_w_lg_nl1l0O95w(0);
	wire_w_lg_w_txdatain_range208w1612w(0) <= wire_w_txdatain_range208w(0) AND wire_w_lg_w_txdatain_range207w1611w(0);
	wire_w_lg_w_txdatain_range192w1626w(0) <= wire_w_txdatain_range192w(0) AND wire_w_lg_w_txdatain_range191w1566w(0);
	wire_w_lg_w_txdatain_range184w1759w(0) <= wire_w_txdatain_range184w(0) AND wire_w_lg_w_txdatain_range180w1575w(0);
	wire_w_lg_w_txdatain_range200w1619w(0) <= wire_w_txdatain_range200w(0) AND wire_w_lg_w_txdatain_range199w1557w(0);
	wire_w_lg_nl000i21w(0) <= NOT nl000i;
	wire_w_lg_nl001l25w(0) <= NOT nl001l;
	wire_w_lg_nl001O23w(0) <= NOT nl001O;
	wire_w_lg_nl00ii16w(0) <= NOT nl00ii;
	wire_w_lg_nl00il14w(0) <= NOT nl00il;
	wire_w_lg_nl00ll9w(0) <= NOT nl00ll;
	wire_w_lg_nl00lO7w(0) <= NOT nl00lO;
	wire_w_lg_nl010O43w(0) <= NOT nl010O;
	wire_w_lg_nl011i52w(0) <= NOT nl011i;
	wire_w_lg_nl011l50w(0) <= NOT nl011l;
	wire_w_lg_nl011O48w(0) <= NOT nl011O;
	wire_w_lg_nl01ii41w(0) <= NOT nl01ii;
	wire_w_lg_nl01li36w(0) <= NOT nl01li;
	wire_w_lg_nl01Ol30w(0) <= NOT nl01Ol;
	wire_w_lg_nl0i1l2w(0) <= NOT nl0i1l;
	wire_w_lg_nl101i1196w(0) <= NOT nl101i;
	wire_w_lg_nl10Oi1195w(0) <= NOT nl10Oi;
	wire_w_lg_nl110i277w(0) <= NOT nl110i;
	wire_w_lg_nl111l276w(0) <= NOT nl111l;
	wire_w_lg_nl11il209w(0) <= NOT nl11il;
	wire_w_lg_nl1i0i124w(0) <= NOT nl1i0i;
	wire_w_lg_nl1i1O126w(0) <= NOT nl1i1O;
	wire_w_lg_nl1iii119w(0) <= NOT nl1iii;
	wire_w_lg_nl1iil117w(0) <= NOT nl1iil;
	wire_w_lg_nl1ill112w(0) <= NOT nl1ill;
	wire_w_lg_nl1iOl107w(0) <= NOT nl1iOl;
	wire_w_lg_nl1l0O95w(0) <= NOT nl1l0O;
	wire_w_lg_nl1l1l102w(0) <= NOT nl1l1l;
	wire_w_lg_nl1l1O100w(0) <= NOT nl1l1O;
	wire_w_lg_nl1lil92w(0) <= NOT nl1lil;
	wire_w_lg_nl1liO90w(0) <= NOT nl1liO;
	wire_w_lg_nl1llO85w(0) <= NOT nl1llO;
	wire_w_lg_nl1lOO80w(0) <= NOT nl1lOO;
	wire_w_lg_nl1O0O69w(0) <= NOT nl1O0O;
	wire_w_lg_nl1O1i78w(0) <= NOT nl1O1i;
	wire_w_lg_nl1O1l76w(0) <= NOT nl1O1l;
	wire_w_lg_nl1O1O74w(0) <= NOT nl1O1O;
	wire_w_lg_nl1OiO64w(0) <= NOT nl1OiO;
	wire_w_lg_nl1Oll61w(0) <= NOT nl1Oll;
	wire_w_lg_nl1OlO59w(0) <= NOT nl1OlO;
	wire_w_lg_nl1OOO54w(0) <= NOT nl1OOO;
	wire_w_lg_rdenablesync266w(0) <= NOT rdenablesync;
	wire_w_lg_resetall156w(0) <= NOT resetall;
	wire_w_lg_w_txctrl_range35w148w(0) <= NOT wire_w_txctrl_range35w(0);
	wire_w_lg_w_txdatain_range191w1566w(0) <= NOT wire_w_txdatain_range191w(0);
	wire_w_lg_w_txdatain_range207w1611w(0) <= NOT wire_w_txdatain_range207w(0);
	wire_w_lg_w_txdatain_range180w1575w(0) <= NOT wire_w_txdatain_range180w(0);
	wire_w_lg_w_txdatain_range199w1557w(0) <= NOT wire_w_txdatain_range199w(0);
	wire_w_lg_w_lg_w_lg_rdenablesync266w267w268w(0) <= wire_w_lg_w_lg_rdenablesync266w267w(0) OR wire_nl0OO_o;
	wire_w_lg_nl11il273w(0) <= nl11il OR wire_n0Oi_w_lg_n0OOO272w(0);
	niOOOi <= (nl101O OR niOOOl);
	niOOOl <= (nl10iO OR nl100l);
	nl000i <= ((((((((NOT txdatain(0)) AND wire_w_lg_w_txdatain_range207w1611w(0)) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND (NOT txdatain(5))) AND txdatain(6)) AND (NOT txdatain(7)));
	nl001l <= ((((((((NOT txdatain(0)) AND wire_w_lg_w_txdatain_range207w1611w(0)) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND txdatain(5)) AND txdatain(6)) AND txdatain(7));
	nl001O <= ((((((((NOT txdatain(0)) AND wire_w_lg_w_txdatain_range207w1611w(0)) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND (NOT txdatain(5))) AND txdatain(6)) AND txdatain(7));
	nl00ii <= ((((((((NOT txdatain(0)) AND wire_w_lg_w_txdatain_range207w1611w(0)) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND txdatain(5)) AND (NOT txdatain(6))) AND (NOT txdatain(7)));
	nl00il <= ((((((wire_w_lg_w_txdatain_range208w1612w(0) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND txdatain(5)) AND txdatain(6)) AND txdatain(7));
	nl00ll <= (((((((txdatain(0) AND txdatain(1)) AND (NOT txdatain(2))) AND txdatain(3)) AND txdatain(4)) AND txdatain(5)) AND txdatain(6)) AND txdatain(7));
	nl00lO <= ((((((((NOT txdatain(0)) AND wire_w_lg_w_txdatain_range207w1611w(0)) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND (NOT txdatain(5))) AND (NOT txdatain(6))) AND txdatain(7));
	nl010O <= (((((((txdatain(8) AND txdatain(9)) AND (NOT txdatain(10))) AND txdatain(11)) AND txdatain(12)) AND txdatain(13)) AND txdatain(14)) AND txdatain(15));
	nl011i <= ((((((((NOT txdatain(8)) AND wire_w_lg_w_txdatain_range199w1557w(0)) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND (NOT txdatain(13))) AND txdatain(14)) AND (NOT txdatain(15)));
	nl011l <= ((((((((NOT txdatain(8)) AND wire_w_lg_w_txdatain_range199w1557w(0)) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND txdatain(13)) AND (NOT txdatain(14))) AND (NOT txdatain(15)));
	nl011O <= ((((((wire_w_lg_w_txdatain_range200w1619w(0) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND txdatain(13)) AND txdatain(14)) AND txdatain(15));
	nl01ii <= ((((((((NOT txdatain(8)) AND wire_w_lg_w_txdatain_range199w1557w(0)) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND (NOT txdatain(13))) AND (NOT txdatain(14))) AND txdatain(15));
	nl01li <= (((((((txdatain(8) AND txdatain(9)) AND txdatain(10)) AND (NOT txdatain(11))) AND (NOT txdatain(12))) AND (NOT txdatain(13))) AND (NOT txdatain(14))) AND (NOT txdatain(15)));
	nl01ll <= (((((((((((((wire_w_lg_w_txctrl_range1w3w(0) AND (nl00Oi2 XOR nl00Oi1)) AND wire_w_lg_nl00lO7w(0)) AND wire_w_lg_nl00ll9w(0)) AND (nl00iO4 XOR nl00iO3)) AND wire_w_lg_nl00il14w(0)) AND wire_w_lg_nl00ii16w(0)) AND (nl000l6 XOR nl000l5)) AND wire_w_lg_nl000i21w(0)) AND wire_w_lg_nl001O23w(0)) AND wire_w_lg_nl001l25w(0)) AND (nl01OO8 XOR nl01OO7)) AND wire_w_lg_nl01Ol30w(0)) AND (nl01lO10 XOR nl01lO9));
	nl01Ol <= (((((((txdatain(0) AND txdatain(1)) AND txdatain(2)) AND (NOT txdatain(3))) AND txdatain(4)) AND txdatain(5)) AND txdatain(6)) AND txdatain(7));
	nl0i1l <= (((((((txdatain(0) AND txdatain(1)) AND txdatain(2)) AND (NOT txdatain(3))) AND (NOT txdatain(4))) AND (NOT txdatain(5))) AND (NOT txdatain(6))) AND (NOT txdatain(7)));
	nl100i <= ((((((((((((((wire_w_lg_w_txdatain_range192w1626w(0) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND txdatain(21)) AND txdatain(22)) AND txdatain(23)) AND txdatain(24)) AND txdatain(25)) AND txdatain(26)) AND (NOT txdatain(27))) AND (NOT txdatain(28))) AND (NOT txdatain(29))) AND (NOT txdatain(30))) AND (NOT txdatain(31)));
	nl100l <= (wire_w_lg_w_lg_w_lg_w_txctrl_range35w139w140w141w(0) AND (nl100O40 XOR nl100O39));
	nl101i <= (((wire_w_lg_w_txctrl_range1w149w(0) AND (NOT txctrl(2))) AND (NOT txctrl(3))) AND nl00lO);
	nl101l <= (txctrl(3) AND nl1iOl);
	nl101O <= ((txctrl(2) AND txctrl(3)) AND nl100i);
	nl10il <= ((((((((((((((((((((((wire_w_lg_w_txdatain_range200w1619w(0) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND txdatain(13)) AND txdatain(14)) AND txdatain(15)) AND txdatain(16)) AND txdatain(17)) AND txdatain(18)) AND (NOT txdatain(19))) AND (NOT txdatain(20))) AND (NOT txdatain(21))) AND (NOT txdatain(22))) AND (NOT txdatain(23))) AND txdatain(24)) AND txdatain(25)) AND txdatain(26)) AND (NOT txdatain(27))) AND (NOT txdatain(28))) AND (NOT txdatain(29))) AND (NOT txdatain(30))) AND (NOT txdatain(31)));
	nl10iO <= (((((txctrl(0) AND txctrl(1)) AND txctrl(2)) AND txctrl(3)) AND (nl10ll38 XOR nl10ll37)) AND nl10li);
	nl10li <= ((((((((((((((((((((((((((((((wire_w_lg_w_txdatain_range208w1612w(0) AND txdatain(2)) AND txdatain(3)) AND txdatain(4)) AND txdatain(5)) AND txdatain(6)) AND txdatain(7)) AND txdatain(8)) AND txdatain(9)) AND txdatain(10)) AND (NOT txdatain(11))) AND (NOT txdatain(12))) AND (NOT txdatain(13))) AND (NOT txdatain(14))) AND (NOT txdatain(15))) AND txdatain(16)) AND txdatain(17)) AND txdatain(18)) AND (NOT txdatain(19))) AND (NOT txdatain(20))) AND (NOT txdatain(21))) AND (NOT txdatain(22))) AND (NOT txdatain(23))) AND txdatain(24)) AND txdatain(25)) AND txdatain(26)) AND (NOT txdatain(27))) AND (NOT txdatain(28))) AND (NOT txdatain(29))) AND (NOT txdatain(30))) AND (NOT txdatain(31)));
	nl10Oi <= ((((txctrl(0) AND txctrl(1)) AND txctrl(2)) AND txctrl(3)) AND nl10Ol);
	nl10Ol <= (((((((((((((((((((((((((((((((txdatain(0) AND txdatain(1)) AND txdatain(2)) AND (NOT txdatain(3))) AND (NOT txdatain(4))) AND (NOT txdatain(5))) AND (NOT txdatain(6))) AND (NOT txdatain(7))) AND txdatain(8)) AND txdatain(9)) AND txdatain(10)) AND (NOT txdatain(11))) AND (NOT txdatain(12))) AND (NOT txdatain(13))) AND (NOT txdatain(14))) AND (NOT txdatain(15))) AND txdatain(16)) AND txdatain(17)) AND txdatain(18)) AND (NOT txdatain(19))) AND (NOT txdatain(20))) AND (NOT txdatain(21))) AND (NOT txdatain(22))) AND (NOT txdatain(23))) AND txdatain(24)) AND txdatain(25)) AND txdatain(26)) AND (NOT txdatain(27))) AND (NOT txdatain(28))) AND (NOT txdatain(29))) AND (NOT txdatain(30))) AND (NOT txdatain(31)));
	nl10OO <= ((((((((((((((wire_w_lg_w_txctrl_range94w96w(0) AND (nl1l0i26 XOR nl1l0i25)) AND wire_w_lg_nl1l1O100w(0)) AND wire_w_lg_nl1l1l102w(0)) AND (nl1iOO28 XOR nl1iOO27)) AND wire_w_lg_nl1iOl107w(0)) AND (nl1ilO30 XOR nl1ilO29)) AND wire_w_lg_nl1ill112w(0)) AND (nl1iiO32 XOR nl1iiO31)) AND wire_w_lg_nl1iil117w(0)) AND wire_w_lg_nl1iii119w(0)) AND (nl1i0l34 XOR nl1i0l33)) AND wire_w_lg_nl1i0i124w(0)) AND wire_w_lg_nl1i1O126w(0)) AND (nl1i1i36 XOR nl1i1i35));
	nl110i <= (wire_w_lg_nl11il209w(0) AND n0OOO);
	nl110l <= (nl11ll AND nl11ii);
	nl110O <= (wire_w_lg_nl11ll210w(0) AND (((wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w169w(0) AND wire_n0Oi_w_lg_n00O166w(0)) OR wire_ni1i_w_lg_w_lg_w_lg_w_lg_ni1l162w168w213w214w(0)) OR (n0OOO AND nl11ii)));
	nl111l <= (wire_w_lg_nl10Oi1195w(0) AND wire_w_lg_nl101i1196w(0));
	nl111O <= (wire_ni1i_w_lg_w_lg_w_lg_ni1l162w164w165w(0) AND n00O);
	nl11ii <= ((wire_ni1i_w_lg_w_lg_ni1l162w164w(0) AND wire_n0Oi_w_lg_n0Ol212w(0)) AND n00O);
	nl11il <= ((((nli0O OR nli0l) OR nli0i) OR nli1O) OR nl01O);
	nl11ll <= (nl10Oi OR nl101i);
	nl11Ol <= '1';
	nl1i0i <= ((((((((NOT txdatain(24)) AND wire_w_lg_w_txdatain_range180w1575w(0)) AND txdatain(26)) AND txdatain(27)) AND txdatain(28)) AND txdatain(29)) AND txdatain(30)) AND txdatain(31));
	nl1i1O <= (((((((txdatain(24) AND txdatain(25)) AND txdatain(26)) AND (NOT txdatain(27))) AND txdatain(28)) AND txdatain(29)) AND txdatain(30)) AND txdatain(31));
	nl1iii <= ((((((((NOT txdatain(24)) AND wire_w_lg_w_txdatain_range180w1575w(0)) AND txdatain(26)) AND txdatain(27)) AND txdatain(28)) AND (NOT txdatain(29))) AND txdatain(30)) AND txdatain(31));
	nl1iil <= ((((((((NOT txdatain(24)) AND wire_w_lg_w_txdatain_range180w1575w(0)) AND txdatain(26)) AND txdatain(27)) AND txdatain(28)) AND (NOT txdatain(29))) AND txdatain(30)) AND (NOT txdatain(31)));
	nl1ill <= ((((((((NOT txdatain(24)) AND wire_w_lg_w_txdatain_range180w1575w(0)) AND txdatain(26)) AND txdatain(27)) AND txdatain(28)) AND txdatain(29)) AND (NOT txdatain(30))) AND (NOT txdatain(31)));
	nl1iOl <= ((((((wire_w_lg_w_txdatain_range184w1759w(0) AND txdatain(26)) AND txdatain(27)) AND txdatain(28)) AND txdatain(29)) AND txdatain(30)) AND txdatain(31));
	nl1l0O <= (((((((txdatain(24) AND txdatain(25)) AND txdatain(26)) AND (NOT txdatain(27))) AND (NOT txdatain(28))) AND (NOT txdatain(29))) AND (NOT txdatain(30))) AND (NOT txdatain(31)));
	nl1l1l <= (((((((txdatain(24) AND txdatain(25)) AND (NOT txdatain(26))) AND txdatain(27)) AND txdatain(28)) AND txdatain(29)) AND txdatain(30)) AND txdatain(31));
	nl1l1O <= ((((((((NOT txdatain(24)) AND wire_w_lg_w_txdatain_range180w1575w(0)) AND txdatain(26)) AND txdatain(27)) AND txdatain(28)) AND (NOT txdatain(29))) AND (NOT txdatain(30))) AND txdatain(31));
	nl1lii <= ((((((((((((wire_w_lg_w_txctrl_range63w65w(0) AND (nl1Oii18 XOR nl1Oii17)) AND wire_w_lg_nl1O0O69w(0)) AND (nl1O0i20 XOR nl1O0i19)) AND wire_w_lg_nl1O1O74w(0)) AND wire_w_lg_nl1O1l76w(0)) AND wire_w_lg_nl1O1i78w(0)) AND wire_w_lg_nl1lOO80w(0)) AND (nl1lOi22 XOR nl1lOi21)) AND wire_w_lg_nl1llO85w(0)) AND (nl1lli24 XOR nl1lli23)) AND wire_w_lg_nl1liO90w(0)) AND wire_w_lg_nl1lil92w(0));
	nl1lil <= (((((((txdatain(16) AND txdatain(17)) AND txdatain(18)) AND (NOT txdatain(19))) AND txdatain(20)) AND txdatain(21)) AND txdatain(22)) AND txdatain(23));
	nl1liO <= ((((((((NOT txdatain(16)) AND wire_w_lg_w_txdatain_range191w1566w(0)) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND txdatain(21)) AND txdatain(22)) AND txdatain(23));
	nl1llO <= ((((((((NOT txdatain(16)) AND wire_w_lg_w_txdatain_range191w1566w(0)) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND (NOT txdatain(21))) AND txdatain(22)) AND txdatain(23));
	nl1lOO <= ((((((((NOT txdatain(16)) AND wire_w_lg_w_txdatain_range191w1566w(0)) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND (NOT txdatain(21))) AND txdatain(22)) AND (NOT txdatain(23)));
	nl1O0O <= ((((((((NOT txdatain(16)) AND wire_w_lg_w_txdatain_range191w1566w(0)) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND (NOT txdatain(21))) AND (NOT txdatain(22))) AND txdatain(23));
	nl1O1i <= ((((((((NOT txdatain(16)) AND wire_w_lg_w_txdatain_range191w1566w(0)) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND txdatain(21)) AND (NOT txdatain(22))) AND (NOT txdatain(23)));
	nl1O1l <= ((((((wire_w_lg_w_txdatain_range192w1626w(0) AND txdatain(18)) AND txdatain(19)) AND txdatain(20)) AND txdatain(21)) AND txdatain(22)) AND txdatain(23));
	nl1O1O <= (((((((txdatain(16) AND txdatain(17)) AND (NOT txdatain(18))) AND txdatain(19)) AND txdatain(20)) AND txdatain(21)) AND txdatain(22)) AND txdatain(23));
	nl1OiO <= (((((((txdatain(16) AND txdatain(17)) AND txdatain(18)) AND (NOT txdatain(19))) AND (NOT txdatain(20))) AND (NOT txdatain(21))) AND (NOT txdatain(22))) AND (NOT txdatain(23)));
	nl1Oli <= (((((((((((wire_w_lg_w_txctrl_range35w37w(0) AND (nl01il12 XOR nl01il11)) AND wire_w_lg_nl01ii41w(0)) AND wire_w_lg_nl010O43w(0)) AND (nl010i14 XOR nl010i13)) AND wire_w_lg_nl011O48w(0)) AND wire_w_lg_nl011l50w(0)) AND wire_w_lg_nl011i52w(0)) AND wire_w_lg_nl1OOO54w(0)) AND (nl1OOi16 XOR nl1OOi15)) AND wire_w_lg_nl1OlO59w(0)) AND wire_w_lg_nl1Oll61w(0));
	nl1Oll <= (((((((txdatain(8) AND txdatain(9)) AND txdatain(10)) AND (NOT txdatain(11))) AND txdatain(12)) AND txdatain(13)) AND txdatain(14)) AND txdatain(15));
	nl1OlO <= ((((((((NOT txdatain(8)) AND wire_w_lg_w_txdatain_range199w1557w(0)) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND txdatain(13)) AND txdatain(14)) AND txdatain(15));
	nl1OOO <= ((((((((NOT txdatain(8)) AND wire_w_lg_w_txdatain_range199w1557w(0)) AND txdatain(10)) AND txdatain(11)) AND txdatain(12)) AND (NOT txdatain(13))) AND txdatain(14)) AND txdatain(15));
	txctrlout <= ( n1OOO & nll01i & nlOiiO & n1lll);
	txdataout <= ( nll1OO & nll1Ol & nll1Oi & nll1lO & nll1ll & nll1li & nll1iO & nll1il & nlOiil & nlOiii & nlOi0O & nlOi0l & nlOi0i & nlOi1O & nlOi1l & nlOi1i & n1lli & n1liO & n1lil & n1lii & n1l0O & n1l0l & n1l0i & n1l1O & n0OOl & n0OlO & n0Oll & n0Oli & n0OiO & n0Oil & n0Oii & n0O0O);
	wire_w_txctrl_range1w(0) <= txctrl(0);
	wire_w_txctrl_range35w(0) <= txctrl(1);
	wire_w_txctrl_range63w(0) <= txctrl(2);
	wire_w_txctrl_range94w(0) <= txctrl(3);
	wire_w_txdatain_range208w(0) <= txdatain(0);
	wire_w_txdatain_range192w(0) <= txdatain(16);
	wire_w_txdatain_range191w(0) <= txdatain(17);
	wire_w_txdatain_range207w(0) <= txdatain(1);
	wire_w_txdatain_range184w(0) <= txdatain(24);
	wire_w_txdatain_range180w(0) <= txdatain(25);
	wire_w_txdatain_range200w(0) <= txdatain(8);
	wire_w_txdatain_range199w(0) <= txdatain(9);
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN niOOOO53 <= niOOOO54;
		END IF;
		if (now = 0 ns) then
			niOOOO53 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN niOOOO54 <= niOOOO53;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl000l5 <= nl000l6;
		END IF;
		if (now = 0 ns) then
			nl000l5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl000l6 <= nl000l5;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl00iO3 <= nl00iO4;
		END IF;
		if (now = 0 ns) then
			nl00iO3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl00iO4 <= nl00iO3;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl00Oi1 <= nl00Oi2;
		END IF;
		if (now = 0 ns) then
			nl00Oi1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl00Oi2 <= nl00Oi1;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl010i13 <= nl010i14;
		END IF;
		if (now = 0 ns) then
			nl010i13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl010i14 <= nl010i13;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl01il11 <= nl01il12;
		END IF;
		if (now = 0 ns) then
			nl01il11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl01il12 <= nl01il11;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl01lO10 <= nl01lO9;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl01lO9 <= nl01lO10;
		END IF;
		if (now = 0 ns) then
			nl01lO9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl01OO7 <= nl01OO8;
		END IF;
		if (now = 0 ns) then
			nl01OO7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl01OO8 <= nl01OO7;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl100O39 <= nl100O40;
		END IF;
		if (now = 0 ns) then
			nl100O39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl100O40 <= nl100O39;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl10ll37 <= nl10ll38;
		END IF;
		if (now = 0 ns) then
			nl10ll37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl10ll38 <= nl10ll37;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl111i51 <= nl111i52;
		END IF;
		if (now = 0 ns) then
			nl111i51 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl111i52 <= nl111i51;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11iO49 <= nl11iO50;
		END IF;
		if (now = 0 ns) then
			nl11iO49 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11iO50 <= nl11iO49;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11li47 <= nl11li48;
		END IF;
		if (now = 0 ns) then
			nl11li47 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11li48 <= nl11li47;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11lO45 <= nl11lO46;
		END IF;
		if (now = 0 ns) then
			nl11lO45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11lO46 <= nl11lO45;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11Oi43 <= nl11Oi44;
		END IF;
		if (now = 0 ns) then
			nl11Oi43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11Oi44 <= nl11Oi43;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11OO41 <= nl11OO42;
		END IF;
		if (now = 0 ns) then
			nl11OO41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl11OO42 <= nl11OO41;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1i0l33 <= nl1i0l34;
		END IF;
		if (now = 0 ns) then
			nl1i0l33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1i0l34 <= nl1i0l33;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1i1i35 <= nl1i1i36;
		END IF;
		if (now = 0 ns) then
			nl1i1i35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1i1i36 <= nl1i1i35;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1iiO31 <= nl1iiO32;
		END IF;
		if (now = 0 ns) then
			nl1iiO31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1iiO32 <= nl1iiO31;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1ilO29 <= nl1ilO30;
		END IF;
		if (now = 0 ns) then
			nl1ilO29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1ilO30 <= nl1ilO29;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1iOO27 <= nl1iOO28;
		END IF;
		if (now = 0 ns) then
			nl1iOO27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1iOO28 <= nl1iOO27;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1l0i25 <= nl1l0i26;
		END IF;
		if (now = 0 ns) then
			nl1l0i25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1l0i26 <= nl1l0i25;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1lli23 <= nl1lli24;
		END IF;
		if (now = 0 ns) then
			nl1lli23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1lli24 <= nl1lli23;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1lOi21 <= nl1lOi22;
		END IF;
		if (now = 0 ns) then
			nl1lOi21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1lOi22 <= nl1lOi21;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1O0i19 <= nl1O0i20;
		END IF;
		if (now = 0 ns) then
			nl1O0i19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1O0i20 <= nl1O0i19;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1Oii17 <= nl1Oii18;
		END IF;
		if (now = 0 ns) then
			nl1Oii17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1Oii18 <= nl1Oii17;
		END IF;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1OOi15 <= nl1OOi16;
		END IF;
		if (now = 0 ns) then
			nl1OOi15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (txclk)
	BEGIN
		IF (txclk = '1' AND txclk'event) THEN nl1OOi16 <= nl1OOi15;
		END IF;
	END PROCESS;
	PROCESS (txclk, resetall)
	BEGIN
		IF (resetall = '1') THEN
				n00i <= '0';
				n01i <= '0';
				n01l <= '0';
				n10i <= '0';
				n10l <= '0';
				n10O <= '0';
				n11i <= '0';
				n11l <= '0';
				n11O <= '0';
				n1ii <= '0';
				n1il <= '0';
				n1iO <= '0';
				n1li <= '0';
				n1Oi <= '0';
				n1Ol <= '0';
				n1OO <= '0';
				nllOO <= '0';
				nlO0O <= '0';
				nlO1l <= '0';
				nlOii <= '0';
				nlOiO <= '0';
				nlOli <= '0';
				nlOll <= '0';
				nlOlO <= '0';
				nlOOi <= '0';
				nlOOl <= '0';
				nlOOO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN
			IF (nl101i = '1') THEN
				n00i <= txdatain(31);
				n01i <= txdatain(29);
				n01l <= txdatain(30);
				n10i <= txdatain(18);
				n10l <= txdatain(19);
				n10O <= txdatain(20);
				n11i <= txdatain(15);
				n11l <= txdatain(16);
				n11O <= txdatain(17);
				n1ii <= txdatain(21);
				n1il <= txdatain(22);
				n1iO <= txdatain(23);
				n1li <= txdatain(24);
				n1Oi <= txdatain(26);
				n1Ol <= txdatain(27);
				n1OO <= txdatain(28);
				nllOO <= txdatain(0);
				nlO0O <= txdatain(5);
				nlO1l <= txdatain(1);
				nlOii <= txdatain(6);
				nlOiO <= txdatain(8);
				nlOli <= txdatain(9);
				nlOll <= txdatain(10);
				nlOlO <= txdatain(11);
				nlOOi <= txdatain(12);
				nlOOl <= txdatain(13);
				nlOOO <= txdatain(14);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (txclk, wire_n0Oi_PRN, wire_n0Oi_CLRN)
	BEGIN
		IF (wire_n0Oi_PRN = '0') THEN
				n00O <= '1';
				n0Ol <= '1';
				n0OOO <= '1';
				nli0O <= '1';
				nliii <= '1';
				nlliO <= '1';
				nllli <= '1';
				nllll <= '1';
				nlllO <= '1';
				nllOi <= '1';
				nllOl <= '1';
		ELSIF (wire_n0Oi_CLRN = '0') THEN
				n00O <= '0';
				n0Ol <= '0';
				n0OOO <= '0';
				nli0O <= '0';
				nliii <= '0';
				nlliO <= '0';
				nllli <= '0';
				nllll <= '0';
				nlllO <= '0';
				nllOi <= '0';
				nllOl <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN
				n00O <= wire_niOOl_o;
				n0Ol <= wire_niOOO_o;
				n0OOO <= wire_nl00i_dataout;
				nli0O <= wire_nlilO_dataout;
				nliii <= (nllOl XOR nllOi);
				nlliO <= nliii;
				nllli <= nlliO;
				nllll <= nllli;
				nlllO <= nllll;
				nllOi <= nlllO;
				nllOl <= nllOi;
		END IF;
		if (now = 0 ns) then
			n00O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0OOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlliO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlllO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllOl <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n0Oi_CLRN <= (nl11Oi44 XOR nl11Oi43);
	wire_n0Oi_PRN <= ((nl11lO46 XOR nl11lO45) AND wire_w_lg_resetall156w(0));
	wire_n0Oi_w_lg_n00O166w(0) <= NOT n00O;
	wire_n0Oi_w_lg_n0Ol212w(0) <= NOT n0Ol;
	wire_n0Oi_w_lg_n0OOO272w(0) <= NOT n0OOO;
	wire_n0Oi_w_lg_nliii279w(0) <= NOT nliii;
	PROCESS (txclk, wire_n0OOi_PRN, wire_n0OOi_CLRN)
	BEGIN
		IF (wire_n0OOi_PRN = '0') THEN
				n0Oil <= '1';
				n0OiO <= '1';
				n0Oli <= '1';
				n0Oll <= '1';
				n0OOl <= '1';
				n1l0l <= '1';
				n1l0O <= '1';
				n1lii <= '1';
				n1lil <= '1';
				n1lli <= '1';
				n1lll <= '1';
				n1OOO <= '1';
				nll01i <= '1';
				nll1li <= '1';
				nll1ll <= '1';
				nll1lO <= '1';
				nll1Oi <= '1';
				nll1OO <= '1';
				nlOi0i <= '1';
				nlOi0l <= '1';
				nlOi0O <= '1';
				nlOi1O <= '1';
				nlOiil <= '1';
				nlOiiO <= '1';
		ELSIF (wire_n0OOi_CLRN = '0') THEN
				n0Oil <= '0';
				n0OiO <= '0';
				n0Oli <= '0';
				n0Oll <= '0';
				n0OOl <= '0';
				n1l0l <= '0';
				n1l0O <= '0';
				n1lii <= '0';
				n1lil <= '0';
				n1lli <= '0';
				n1lll <= '0';
				n1OOO <= '0';
				nll01i <= '0';
				nll1li <= '0';
				nll1ll <= '0';
				nll1lO <= '0';
				nll1Oi <= '0';
				nll1OO <= '0';
				nlOi0i <= '0';
				nlOi0l <= '0';
				nlOi0O <= '0';
				nlOi1O <= '0';
				nlOiil <= '0';
				nlOiiO <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN
				n0Oil <= wire_ni10i_dataout;
				n0OiO <= wire_ni10l_dataout;
				n0Oli <= wire_ni10O_dataout;
				n0Oll <= wire_ni1ii_dataout;
				n0OOl <= wire_ni1iO_dataout;
				n1l0l <= wire_n1lOO_dataout;
				n1l0O <= wire_n1O1i_dataout;
				n1lii <= wire_n1O1l_dataout;
				n1lil <= wire_n1O1O_dataout;
				n1lli <= wire_n1O0l_dataout;
				n1lll <= wire_ni11i_dataout;
				n1OOO <= wire_nll01l_dataout;
				nll01i <= wire_nlOili_dataout;
				nll1li <= wire_nll00l_dataout;
				nll1ll <= wire_nll00O_dataout;
				nll1lO <= wire_nll0ii_dataout;
				nll1Oi <= wire_nll0il_dataout;
				nll1OO <= wire_nll0li_dataout;
				nlOi0i <= wire_nlOiOl_dataout;
				nlOi0l <= wire_nlOiOO_dataout;
				nlOi0O <= wire_nlOl1i_dataout;
				nlOi1O <= wire_nlOiOi_dataout;
				nlOiil <= wire_nlOl1O_dataout;
				nlOiiO <= wire_n1llO_dataout;
		END IF;
	END PROCESS;
	wire_n0OOi_CLRN <= (nl111i52 XOR nl111i51);
	wire_n0OOi_PRN <= ((niOOOO54 XOR niOOOO53) AND wire_w_lg_resetall156w(0));
	PROCESS (txclk, wire_n1ll_PRN, wire_n1ll_CLRN)
	BEGIN
		IF (wire_n1ll_PRN = '0') THEN
				n1lO <= '1';
				nlO0i <= '1';
				nlO0l <= '1';
				nlO1O <= '1';
				nlOil <= '1';
		ELSIF (wire_n1ll_CLRN = '0') THEN
				n1lO <= '0';
				nlO0i <= '0';
				nlO0l <= '0';
				nlO1O <= '0';
				nlOil <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN
			IF (nl101i = '1') THEN
				n1lO <= txdatain(25);
				nlO0i <= txdatain(3);
				nlO0l <= txdatain(4);
				nlO1O <= txdatain(2);
				nlOil <= txdatain(7);
			END IF;
		END IF;
		if (now = 0 ns) then
			n1lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOil <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n1ll_CLRN <= (nl11li48 XOR nl11li47);
	wire_n1ll_PRN <= ((nl11iO50 XOR nl11iO49) AND wire_w_lg_resetall156w(0));
	PROCESS (txclk, wire_ni1i_CLRN)
	BEGIN
		IF (wire_ni1i_CLRN = '0') THEN
				n00l <= '0';
				n0O0O <= '0';
				n0Oii <= '0';
				n0OlO <= '0';
				n0OO <= '0';
				n1l0i <= '0';
				n1l1O <= '0';
				n1liO <= '0';
				ni1l <= '0';
				nl01O <= '0';
				nli0i <= '0';
				nli0l <= '0';
				nli1O <= '0';
				nll1il <= '0';
				nll1iO <= '0';
				nll1Ol <= '0';
				nlOi1i <= '0';
				nlOi1l <= '0';
				nlOiii <= '0';
		ELSIF (txclk = '1' AND txclk'event) THEN
				n00l <= wire_n0ii_dataout;
				n0O0O <= wire_ni11l_dataout;
				n0Oii <= wire_ni11O_dataout;
				n0OlO <= wire_ni1il_dataout;
				n0OO <= wire_nl11i_o;
				n1l0i <= wire_n1lOl_dataout;
				n1l1O <= wire_n1lOi_dataout;
				n1liO <= wire_n1O0i_dataout;
				ni1l <= wire_nl11l_dataout;
				nl01O <= wire_nliil_dataout;
				nli0i <= wire_nlili_dataout;
				nli0l <= wire_nlill_dataout;
				nli1O <= wire_nliiO_dataout;
				nll1il <= wire_nll01O_dataout;
				nll1iO <= wire_nll00i_dataout;
				nll1Ol <= wire_nll0iO_dataout;
				nlOi1i <= wire_nlOill_dataout;
				nlOi1l <= wire_nlOilO_dataout;
				nlOiii <= wire_nlOl1l_dataout;
		END IF;
	END PROCESS;
	wire_ni1i_CLRN <= ((nl11OO42 XOR nl11OO41) AND wire_w_lg_resetall156w(0));
	wire_ni1i_w_lg_w_lg_w_lg_w_lg_ni1l162w168w213w214w(0) <= wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w213w(0) AND n00O;
	wire_ni1i_w_lg_w_lg_w_lg_w_lg_ni1l162w168w169w170w(0) <= wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w169w(0) AND n00O;
	wire_ni1i_w_lg_w_lg_w_lg_ni1l162w164w165w(0) <= wire_ni1i_w_lg_w_lg_ni1l162w164w(0) AND n0Ol;
	wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w213w(0) <= wire_ni1i_w_lg_w_lg_ni1l162w168w(0) AND wire_n0Oi_w_lg_n0Ol212w(0);
	wire_ni1i_w_lg_w_lg_w_lg_ni1l162w168w169w(0) <= wire_ni1i_w_lg_w_lg_ni1l162w168w(0) AND n0Ol;
	wire_ni1i_w_lg_w_lg_ni1l162w164w(0) <= wire_ni1i_w_lg_ni1l162w(0) AND wire_ni1i_w_lg_n0OO163w(0);
	wire_ni1i_w_lg_w_lg_ni1l162w168w(0) <= wire_ni1i_w_lg_ni1l162w(0) AND n0OO;
	wire_ni1i_w_lg_n00l278w(0) <= NOT n00l;
	wire_ni1i_w_lg_n0OO163w(0) <= NOT n0OO;
	wire_ni1i_w_lg_ni1l162w(0) <= NOT ni1l;
	wire_n000i_dataout <= txctrl(1) OR nl100l;
	wire_n000l_dataout <= txdatain(8) OR nl100l;
	wire_n000O_dataout <= txdatain(9) AND NOT(nl100l);
	wire_n001i_dataout <= wire_n00li_dataout OR nl10iO;
	wire_n001l_dataout <= wire_n00ll_dataout AND NOT(nl10iO);
	wire_n001O_dataout <= wire_n00lO_dataout OR nl10iO;
	wire_n00ii_dataout <= txdatain(10) OR nl100l;
	wire_n00il_dataout <= txdatain(11) OR nl100l;
	wire_n00iO_dataout <= txdatain(12) OR nl100l;
	wire_n00li_dataout <= txdatain(13) OR nl100l;
	wire_n00ll_dataout <= txdatain(14) OR nl100l;
	wire_n00lO_dataout <= txdatain(15) OR nl100l;
	wire_n00Oi_dataout <= wire_n01li_dataout WHEN nl111l = '1'  ELSE wire_ni1i_w_lg_n00l278w(0);
	wire_n00Ol_dataout <= wire_n01ll_dataout WHEN nl111l = '1'  ELSE wire_n0iii_dataout;
	wire_n00OO_dataout <= wire_n01lO_dataout WHEN nl111l = '1'  ELSE wire_n0iil_dataout;
	wire_n010i_dataout <= wire_n01Oi_dataout OR NOT(nl111l);
	wire_n010l_dataout <= wire_n01Ol_dataout OR NOT(nl111l);
	wire_n010O_dataout <= wire_n01OO_dataout OR NOT(nl111l);
	wire_n011i_dataout <= wire_n01li_dataout OR NOT(nl111l);
	wire_n011l_dataout <= wire_n01ll_dataout AND nl111l;
	wire_n011O_dataout <= wire_n01lO_dataout AND nl111l;
	wire_n01ii_dataout <= wire_n001i_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_n01il_dataout <= wire_n001l_dataout AND nl111l;
	wire_n01iO_dataout <= wire_n001O_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_n01li_dataout <= wire_n000i_dataout OR nl10iO;
	wire_n01ll_dataout <= wire_n000l_dataout AND NOT(nl10iO);
	wire_n01lO_dataout <= wire_n000O_dataout AND NOT(nl10iO);
	wire_n01Oi_dataout <= wire_n00ii_dataout OR nl10iO;
	wire_n01Ol_dataout <= wire_n00il_dataout OR nl10iO;
	wire_n01OO_dataout <= wire_n00iO_dataout OR nl10iO;
	wire_n0i0i_dataout <= wire_n001i_dataout WHEN nl111l = '1'  ELSE wire_n0ilO_dataout;
	wire_n0i0l_dataout <= wire_n001l_dataout WHEN nl111l = '1'  ELSE wire_n0iOi_dataout;
	wire_n0i0O_dataout <= wire_n001O_dataout WHEN nl111l = '1'  ELSE wire_n0iOl_dataout;
	wire_n0i1i_dataout <= wire_n01Oi_dataout WHEN nl111l = '1'  ELSE wire_n0iiO_dataout;
	wire_n0i1l_dataout <= wire_n01Ol_dataout WHEN nl111l = '1'  ELSE wire_n0ili_dataout;
	wire_n0i1O_dataout <= wire_n01OO_dataout WHEN nl111l = '1'  ELSE wire_n0ill_dataout;
	wire_n0ii_dataout <= wire_n0il_dataout OR nl101i;
	wire_n0iii_dataout <= nlOiO AND n00l;
	wire_n0iil_dataout <= nlOli AND n00l;
	wire_n0iiO_dataout <= nlOll OR NOT(n00l);
	wire_n0il_dataout <= n00l AND NOT(((((wire_ni1i_w_lg_w_lg_w_lg_ni1l162w164w165w(0) AND wire_n0Oi_w_lg_n00O166w(0)) OR wire_ni1i_w_lg_w_lg_w_lg_w_lg_ni1l162w168w169w170w(0)) AND nl11ll) AND n00l));
	wire_n0ili_dataout <= nlOlO OR NOT(n00l);
	wire_n0ill_dataout <= nlOOi OR NOT(n00l);
	wire_n0ilO_dataout <= nlOOl WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_n0iOi_dataout <= nlOOO AND n00l;
	wire_n0iOl_dataout <= n11i WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_n0iOO_dataout <= wire_n001i_dataout WHEN nl111l = '1'  ELSE wire_nlO1li_dataout;
	wire_n0l0i_dataout <= wire_n001O_dataout AND nl111l;
	wire_n0l0l_dataout <= wire_n001i_dataout WHEN nl111l = '1'  ELSE wire_n0lii_dataout;
	wire_n0l0O_dataout <= wire_n001O_dataout WHEN nl111l = '1'  ELSE wire_n0lil_dataout;
	wire_n0l1i_dataout <= wire_n001l_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl11il209w(0);
	wire_n0l1l_dataout <= wire_n001O_dataout WHEN nl111l = '1'  ELSE wire_nlO1ll_dataout;
	wire_n0l1O_dataout <= wire_n001i_dataout AND nl111l;
	wire_n0lii_dataout <= nlOOl AND n00l;
	wire_n0lil_dataout <= n11i AND n00l;
	wire_n0liO_dataout <= wire_n001i_dataout OR NOT(nl111l);
	wire_n0lli_dataout <= wire_n001l_dataout WHEN nl111l = '1'  ELSE nl110i;
	wire_n0lll_dataout <= wire_n001O_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl110i277w(0);
	wire_n0llO_dataout <= wire_n011i_dataout OR NOT(rdenablesync);
	wire_n0lOi_dataout <= wire_n011l_dataout AND rdenablesync;
	wire_n0lOl_dataout <= wire_n011O_dataout AND rdenablesync;
	wire_n0lOO_dataout <= wire_n010i_dataout OR NOT(rdenablesync);
	wire_n0O0i_dataout <= wire_n01il_dataout AND rdenablesync;
	wire_n0O0l_dataout <= wire_n0l0i_dataout OR NOT(rdenablesync);
	wire_n0O1i_dataout <= wire_n010l_dataout OR NOT(rdenablesync);
	wire_n0O1l_dataout <= wire_n010O_dataout OR NOT(rdenablesync);
	wire_n0O1O_dataout <= wire_n0l1O_dataout OR NOT(rdenablesync);
	wire_n100i_dataout <= n11l AND n00l;
	wire_n100l_dataout <= n11O AND n00l;
	wire_n100O_dataout <= n10i OR NOT(n00l);
	wire_n101i_dataout <= wire_nlOOOi_dataout WHEN nl111l = '1'  ELSE wire_n10iO_dataout;
	wire_n101l_dataout <= wire_nlOOOl_dataout WHEN nl111l = '1'  ELSE wire_n10li_dataout;
	wire_n101O_dataout <= wire_nlOOOO_dataout WHEN nl111l = '1'  ELSE wire_n10ll_dataout;
	wire_n10ii_dataout <= n10l OR NOT(n00l);
	wire_n10il_dataout <= n10O OR NOT(n00l);
	wire_n10iO_dataout <= n1ii WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_n10li_dataout <= n1il AND n00l;
	wire_n10ll_dataout <= n1iO WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_n10lO_dataout <= wire_nlOOOi_dataout WHEN nl111l = '1'  ELSE wire_nlO1li_dataout;
	wire_n10Oi_dataout <= wire_nlOOOl_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl11il209w(0);
	wire_n10Ol_dataout <= wire_nlOOOO_dataout WHEN nl111l = '1'  ELSE wire_nlO1ll_dataout;
	wire_n10OO_dataout <= wire_nlOOOi_dataout AND nl111l;
	wire_n110i_dataout <= txdatain(18) OR nl101O;
	wire_n110l_dataout <= txdatain(19) OR nl101O;
	wire_n110O_dataout <= txdatain(20) OR nl101O;
	wire_n111i_dataout <= txctrl(2) OR nl101O;
	wire_n111l_dataout <= txdatain(16) OR nl101O;
	wire_n111O_dataout <= txdatain(17) AND NOT(nl101O);
	wire_n11ii_dataout <= txdatain(21) OR nl101O;
	wire_n11il_dataout <= txdatain(22) OR nl101O;
	wire_n11iO_dataout <= txdatain(23) OR nl101O;
	wire_n11li_dataout <= wire_nlOOii_dataout WHEN nl111l = '1'  ELSE wire_ni1i_w_lg_n00l278w(0);
	wire_n11ll_dataout <= wire_nlOOil_dataout WHEN nl111l = '1'  ELSE wire_n100i_dataout;
	wire_n11lO_dataout <= wire_nlOOiO_dataout WHEN nl111l = '1'  ELSE wire_n100l_dataout;
	wire_n11Oi_dataout <= wire_nlOOli_dataout WHEN nl111l = '1'  ELSE wire_n100O_dataout;
	wire_n11Ol_dataout <= wire_nlOOll_dataout WHEN nl111l = '1'  ELSE wire_n10ii_dataout;
	wire_n11OO_dataout <= wire_nlOOlO_dataout WHEN nl111l = '1'  ELSE wire_n10il_dataout;
	wire_n1i0i_dataout <= n1ii AND n00l;
	wire_n1i0l_dataout <= n1iO AND n00l;
	wire_n1i0O_dataout <= wire_nlOOOi_dataout OR NOT(nl111l);
	wire_n1i1i_dataout <= wire_nlOOOO_dataout AND nl111l;
	wire_n1i1l_dataout <= wire_nlOOOi_dataout WHEN nl111l = '1'  ELSE wire_n1i0i_dataout;
	wire_n1i1O_dataout <= wire_nlOOOO_dataout WHEN nl111l = '1'  ELSE wire_n1i0l_dataout;
	wire_n1iii_dataout <= wire_nlOOOl_dataout WHEN nl111l = '1'  ELSE nl110i;
	wire_n1iil_dataout <= wire_nlOOOO_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl110i277w(0);
	wire_n1iiO_dataout <= wire_nlOlOi_dataout OR NOT(rdenablesync);
	wire_n1ili_dataout <= wire_nlOlOl_dataout AND rdenablesync;
	wire_n1ill_dataout <= wire_nlOlOO_dataout AND rdenablesync;
	wire_n1ilO_dataout <= wire_nlOO1i_dataout OR NOT(rdenablesync);
	wire_n1iOi_dataout <= wire_nlOO1l_dataout OR NOT(rdenablesync);
	wire_n1iOl_dataout <= wire_nlOO1O_dataout OR NOT(rdenablesync);
	wire_n1iOO_dataout <= wire_n10OO_dataout OR NOT(rdenablesync);
	wire_n1l1i_dataout <= wire_nlOO0l_dataout AND rdenablesync;
	wire_n1l1l_dataout <= wire_n1i1i_dataout OR NOT(rdenablesync);
	wire_n1llO_dataout <= wire_n1O0O_o OR nl1Oli;
	wire_n1lOi_dataout <= wire_n1Oii_o AND NOT(nl1Oli);
	wire_n1lOl_dataout <= wire_n1Oil_o OR nl1Oli;
	wire_n1lOO_dataout <= wire_n1OiO_o OR nl1Oli;
	wire_n1O0i_dataout <= wire_n1OOi_o OR nl1Oli;
	wire_n1O0l_dataout <= wire_n1OOl_o OR nl1Oli;
	wire_n1O1i_dataout <= wire_n1Oli_o OR nl1Oli;
	wire_n1O1l_dataout <= wire_n1Oll_o OR nl1Oli;
	wire_n1O1O_dataout <= wire_n1OlO_o OR nl1Oli;
	wire_ni00i_dataout <= wire_ni0Oi_dataout OR NOT(nl111l);
	wire_ni00l_dataout <= wire_ni0Ol_dataout AND nl111l;
	wire_ni00O_dataout <= wire_ni0OO_dataout AND nl111l;
	wire_ni0ii_dataout <= wire_nii1i_dataout OR NOT(nl111l);
	wire_ni0il_dataout <= wire_nii1l_dataout OR NOT(nl111l);
	wire_ni0iO_dataout <= wire_nii1O_dataout OR NOT(nl111l);
	wire_ni0li_dataout <= wire_nii0i_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_ni0ll_dataout <= wire_nii0l_dataout AND nl111l;
	wire_ni0lO_dataout <= wire_nii0O_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_ni0Oi_dataout <= txctrl(0) OR nl10iO;
	wire_ni0Ol_dataout <= txdatain(0) OR nl10iO;
	wire_ni0OO_dataout <= txdatain(1) AND NOT(nl10iO);
	wire_ni10i_dataout <= wire_ni1Oi_o OR nl01ll;
	wire_ni10l_dataout <= wire_ni1Ol_o OR nl01ll;
	wire_ni10O_dataout <= wire_ni1OO_o OR nl01ll;
	wire_ni11i_dataout <= wire_ni1li_o OR nl01ll;
	wire_ni11l_dataout <= wire_ni1ll_o AND NOT(nl01ll);
	wire_ni11O_dataout <= wire_ni1lO_o OR nl01ll;
	wire_ni1ii_dataout <= wire_ni01i_o OR nl01ll;
	wire_ni1il_dataout <= wire_ni01l_o OR nl01ll;
	wire_ni1iO_dataout <= wire_ni01O_o OR nl01ll;
	wire_nii0i_dataout <= txdatain(5) OR nl10iO;
	wire_nii0l_dataout <= txdatain(6) OR nl10iO;
	wire_nii0O_dataout <= txdatain(7) OR nl10iO;
	wire_nii1i_dataout <= txdatain(2) OR nl10iO;
	wire_nii1l_dataout <= txdatain(3) OR nl10iO;
	wire_nii1O_dataout <= txdatain(4) OR nl10iO;
	wire_niiii_dataout <= wire_ni0Ol_dataout WHEN nl111l = '1'  ELSE wire_niiOO_dataout;
	wire_niiil_dataout <= wire_ni0OO_dataout WHEN nl111l = '1'  ELSE wire_nil1i_dataout;
	wire_niiiO_dataout <= wire_nii1i_dataout WHEN nl111l = '1'  ELSE wire_nil1l_dataout;
	wire_niili_dataout <= wire_nii1l_dataout WHEN nl111l = '1'  ELSE wire_nil1O_dataout;
	wire_niill_dataout <= wire_nii1O_dataout WHEN nl111l = '1'  ELSE wire_nil0i_dataout;
	wire_niilO_dataout <= wire_nii0i_dataout WHEN nl111l = '1'  ELSE wire_nil0l_dataout;
	wire_niiOi_dataout <= wire_nii0l_dataout WHEN nl111l = '1'  ELSE wire_nil0O_dataout;
	wire_niiOl_dataout <= wire_nii0O_dataout WHEN nl111l = '1'  ELSE wire_nilii_dataout;
	wire_niiOO_dataout <= nllOO AND n00l;
	wire_nil0i_dataout <= nlO0l OR NOT(n00l);
	wire_nil0l_dataout <= nlO0O WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nil0O_dataout <= nlOii AND n00l;
	wire_nil1i_dataout <= nlO1l AND n00l;
	wire_nil1l_dataout <= nlO1O OR NOT(n00l);
	wire_nil1O_dataout <= nlO0i OR NOT(n00l);
	wire_nilii_dataout <= nlOil WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nilil_dataout <= wire_nii0i_dataout WHEN nl111l = '1'  ELSE wire_nlO1li_dataout;
	wire_niliO_dataout <= wire_nii0l_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl11il209w(0);
	wire_nilli_dataout <= wire_nii0O_dataout WHEN nl111l = '1'  ELSE wire_nlO1ll_dataout;
	wire_nilll_dataout <= wire_nii0i_dataout AND nl111l;
	wire_nillO_dataout <= wire_nii0O_dataout AND nl111l;
	wire_nilOi_dataout <= wire_nii0i_dataout WHEN nl111l = '1'  ELSE wire_nilOO_dataout;
	wire_nilOl_dataout <= wire_nii0O_dataout WHEN nl111l = '1'  ELSE wire_niO1i_dataout;
	wire_nilOO_dataout <= nlO0O AND n00l;
	wire_niO0i_dataout <= wire_nii0O_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl110i277w(0);
	wire_niO0l_dataout <= wire_ni00i_dataout OR NOT(rdenablesync);
	wire_niO0O_dataout <= wire_ni00l_dataout AND rdenablesync;
	wire_niO1i_dataout <= nlOil AND n00l;
	wire_niO1l_dataout <= wire_nii0i_dataout OR NOT(nl111l);
	wire_niO1O_dataout <= wire_nii0l_dataout WHEN nl111l = '1'  ELSE nl110i;
	wire_niOii_dataout <= wire_ni00O_dataout AND rdenablesync;
	wire_niOil_dataout <= wire_ni0ii_dataout OR NOT(rdenablesync);
	wire_niOiO_dataout <= wire_ni0il_dataout OR NOT(rdenablesync);
	wire_niOli_dataout <= wire_ni0iO_dataout OR NOT(rdenablesync);
	wire_niOll_dataout <= wire_nilll_dataout OR NOT(rdenablesync);
	wire_niOlO_dataout <= wire_ni0ll_dataout AND rdenablesync;
	wire_niOOi_dataout <= wire_nillO_dataout OR NOT(rdenablesync);
	wire_nl00i_dataout <= wire_nl00l_dataout OR ((wire_w_lg_w_lg_w_lg_rdenablesync266w267w268w(0) OR wire_w_lg_nl11ll270w(0)) OR wire_w_lg_w_lg_nl11il273w274w(0));
	wire_nl00l_dataout <= n0OOO AND NOT((nl110l AND nl110i));
	wire_nl01i_dataout <= wire_w_lg_nl110i277w(0) OR nl111l;
	wire_nl01l_dataout <= wire_w_lg_nl111l276w(0) AND rdenablesync;
	wire_nl10i_dataout <= nliii OR nl111l;
	wire_nl10l_dataout <= wire_n0Oi_w_lg_nliii279w(0) AND NOT(nl111l);
	wire_nl10O_dataout <= wire_nl1li_dataout OR nl111l;
	wire_nl11l_dataout <= wire_nl1iO_dataout AND wire_nl11O_o(7);
	wire_nl1ii_dataout <= wire_nl1ll_dataout AND NOT(nl111l);
	wire_nl1il_dataout <= wire_ni1i_w_lg_n00l278w(0) AND NOT(nl111l);
	wire_nl1iO_dataout <= n00l AND NOT(nl111l);
	wire_nl1li_dataout <= nliii AND NOT(n00l);
	wire_nl1ll_dataout <= wire_n0Oi_w_lg_nliii279w(0) AND NOT(n00l);
	wire_nl1lO_dataout <= wire_nl1Ol_dataout OR nl111l;
	wire_nl1Oi_dataout <= wire_nlO1li_dataout AND NOT(nl111l);
	wire_nl1Ol_dataout <= nliii OR wire_w_lg_nl11il209w(0);
	wire_nl1OO_dataout <= wire_ni1i_w_lg_n00l278w(0) OR nl111l;
	wire_nliil_dataout <= nliii WHEN nl110O = '1'  ELSE wire_nliOi_dataout;
	wire_nliiO_dataout <= nlliO WHEN nl110O = '1'  ELSE wire_nliOl_dataout;
	wire_nlili_dataout <= nllli WHEN nl110O = '1'  ELSE wire_nliOO_dataout;
	wire_nlill_dataout <= nllll WHEN nl110O = '1'  ELSE wire_nll1i_dataout;
	wire_nlilO_dataout <= wire_nll1l_dataout OR nl110O;
	wire_nliOi_dataout <= wire_nll1O_o(1) WHEN nl11il = '1'  ELSE nl01O;
	wire_nliOl_dataout <= wire_nll1O_o(2) WHEN nl11il = '1'  ELSE nli1O;
	wire_nliOO_dataout <= wire_nll1O_o(3) WHEN nl11il = '1'  ELSE nli0i;
	wire_nll00i_dataout <= wire_nll0Oi_o OR nl10OO;
	wire_nll00l_dataout <= wire_nll0Ol_o OR nl10OO;
	wire_nll00O_dataout <= wire_nll0OO_o OR nl10OO;
	wire_nll01l_dataout <= wire_nll0ll_o OR nl10OO;
	wire_nll01O_dataout <= wire_nll0lO_o AND NOT(nl10OO);
	wire_nll0ii_dataout <= wire_nlli1i_o OR nl10OO;
	wire_nll0il_dataout <= wire_nlli1l_o OR nl10OO;
	wire_nll0iO_dataout <= wire_nlli1O_o OR nl10OO;
	wire_nll0li_dataout <= wire_nlli0i_o OR nl10OO;
	wire_nll1i_dataout <= wire_nll1O_o(4) WHEN nl11il = '1'  ELSE nli0l;
	wire_nll1l_dataout <= wire_nll1O_o(5) WHEN nl11il = '1'  ELSE nli0O;
	wire_nlli0l_dataout <= wire_nlliOl_dataout OR NOT(nl111l);
	wire_nlli0O_dataout <= wire_nlliOO_dataout AND nl111l;
	wire_nlliii_dataout <= wire_nlll1i_dataout AND nl111l;
	wire_nlliil_dataout <= wire_nlll1l_dataout OR NOT(nl111l);
	wire_nlliiO_dataout <= wire_nlll1O_dataout OR NOT(nl111l);
	wire_nllili_dataout <= wire_nlll0i_dataout OR NOT(nl111l);
	wire_nllill_dataout <= wire_nlll0l_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nllilO_dataout <= wire_nlll0O_dataout AND nl111l;
	wire_nlliOi_dataout <= wire_nlllii_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nlliOl_dataout <= wire_nlllil_dataout OR niOOOi;
	wire_nlliOO_dataout <= wire_nllliO_dataout AND NOT(niOOOi);
	wire_nlll0i_dataout <= wire_nlllOi_dataout OR niOOOi;
	wire_nlll0l_dataout <= wire_nlllOl_dataout OR niOOOi;
	wire_nlll0O_dataout <= wire_nlllOO_dataout AND NOT(niOOOi);
	wire_nlll1i_dataout <= wire_nlllli_dataout AND NOT(niOOOi);
	wire_nlll1l_dataout <= wire_nlllll_dataout OR niOOOi;
	wire_nlll1O_dataout <= wire_nllllO_dataout OR niOOOi;
	wire_nlllii_dataout <= wire_nllO1i_dataout OR niOOOi;
	wire_nlllil_dataout <= txctrl(3) OR nl101l;
	wire_nllliO_dataout <= txdatain(24) OR nl101l;
	wire_nlllli_dataout <= txdatain(25) AND NOT(nl101l);
	wire_nlllll_dataout <= txdatain(26) OR nl101l;
	wire_nllllO_dataout <= txdatain(27) OR nl101l;
	wire_nlllOi_dataout <= txdatain(28) OR nl101l;
	wire_nlllOl_dataout <= txdatain(29) OR nl101l;
	wire_nlllOO_dataout <= txdatain(30) OR nl101l;
	wire_nllO0l_dataout <= wire_nlliOl_dataout WHEN nl111l = '1'  ELSE wire_ni1i_w_lg_n00l278w(0);
	wire_nllO0O_dataout <= wire_nlliOO_dataout WHEN nl111l = '1'  ELSE wire_nllOOl_dataout;
	wire_nllO1i_dataout <= txdatain(31) OR nl101l;
	wire_nllOii_dataout <= wire_nlll1i_dataout WHEN nl111l = '1'  ELSE wire_nllOOO_dataout;
	wire_nllOil_dataout <= wire_nlll1l_dataout WHEN nl111l = '1'  ELSE wire_nlO11i_dataout;
	wire_nllOiO_dataout <= wire_nlll1O_dataout WHEN nl111l = '1'  ELSE wire_nlO11l_dataout;
	wire_nllOli_dataout <= wire_nlll0i_dataout WHEN nl111l = '1'  ELSE wire_nlO11O_dataout;
	wire_nllOll_dataout <= wire_nlll0l_dataout WHEN nl111l = '1'  ELSE wire_nlO10i_dataout;
	wire_nllOlO_dataout <= wire_nlll0O_dataout WHEN nl111l = '1'  ELSE wire_nlO10l_dataout;
	wire_nllOOi_dataout <= wire_nlllii_dataout WHEN nl111l = '1'  ELSE wire_nlO10O_dataout;
	wire_nllOOl_dataout <= n1li AND n00l;
	wire_nllOOO_dataout <= n1lO AND n00l;
	wire_nlO00i_dataout <= wire_nlll0O_dataout WHEN nl111l = '1'  ELSE nl110i;
	wire_nlO00l_dataout <= wire_nlllii_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl110i277w(0);
	wire_nlO01i_dataout <= n01i AND n00l;
	wire_nlO01l_dataout <= n00i AND n00l;
	wire_nlO01O_dataout <= wire_nlll0l_dataout OR NOT(nl111l);
	wire_nlO0ii_dataout <= wire_nlli0l_dataout OR NOT(rdenablesync);
	wire_nlO0il_dataout <= wire_nlli0O_dataout AND rdenablesync;
	wire_nlO0iO_dataout <= wire_nlliii_dataout AND rdenablesync;
	wire_nlO0li_dataout <= wire_nlliil_dataout OR NOT(rdenablesync);
	wire_nlO0ll_dataout <= wire_nlliiO_dataout OR NOT(rdenablesync);
	wire_nlO0lO_dataout <= wire_nllili_dataout OR NOT(rdenablesync);
	wire_nlO0Oi_dataout <= wire_nlO1lO_dataout OR NOT(rdenablesync);
	wire_nlO0Ol_dataout <= wire_nllilO_dataout AND rdenablesync;
	wire_nlO0OO_dataout <= wire_nlO1Oi_dataout OR NOT(rdenablesync);
	wire_nlO10i_dataout <= n01i WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nlO10l_dataout <= n01l AND n00l;
	wire_nlO10O_dataout <= n00i WHEN n00l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nlO11i_dataout <= n1Oi OR NOT(n00l);
	wire_nlO11l_dataout <= n1Ol OR NOT(n00l);
	wire_nlO11O_dataout <= n1OO OR NOT(n00l);
	wire_nlO1ii_dataout <= wire_nlll0l_dataout WHEN nl111l = '1'  ELSE wire_nlO1li_dataout;
	wire_nlO1il_dataout <= wire_nlll0O_dataout WHEN nl111l = '1'  ELSE wire_w_lg_nl11il209w(0);
	wire_nlO1iO_dataout <= wire_nlllii_dataout WHEN nl111l = '1'  ELSE wire_nlO1ll_dataout;
	wire_nlO1li_dataout <= wire_n0Oi_w_lg_nliii279w(0) OR wire_w_lg_nl11il209w(0);
	wire_nlO1ll_dataout <= wire_n0Oi_w_lg_nliii279w(0) AND NOT(wire_w_lg_nl11il209w(0));
	wire_nlO1lO_dataout <= wire_nlll0l_dataout AND nl111l;
	wire_nlO1Oi_dataout <= wire_nlllii_dataout AND nl111l;
	wire_nlO1Ol_dataout <= wire_nlll0l_dataout WHEN nl111l = '1'  ELSE wire_nlO01i_dataout;
	wire_nlO1OO_dataout <= wire_nlllii_dataout WHEN nl111l = '1'  ELSE wire_nlO01l_dataout;
	wire_nlOili_dataout <= wire_nlOl0i_o OR nl1lii;
	wire_nlOill_dataout <= wire_nlOl0l_o AND NOT(nl1lii);
	wire_nlOilO_dataout <= wire_nlOl0O_o OR nl1lii;
	wire_nlOiOi_dataout <= wire_nlOlii_o OR nl1lii;
	wire_nlOiOl_dataout <= wire_nlOlil_o OR nl1lii;
	wire_nlOiOO_dataout <= wire_nlOliO_o OR nl1lii;
	wire_nlOl1i_dataout <= wire_nlOlli_o OR nl1lii;
	wire_nlOl1l_dataout <= wire_nlOlll_o OR nl1lii;
	wire_nlOl1O_dataout <= wire_nlOllO_o OR nl1lii;
	wire_nlOlOi_dataout <= wire_nlOOii_dataout OR NOT(nl111l);
	wire_nlOlOl_dataout <= wire_nlOOil_dataout AND nl111l;
	wire_nlOlOO_dataout <= wire_nlOOiO_dataout AND nl111l;
	wire_nlOO0i_dataout <= wire_nlOOOi_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nlOO0l_dataout <= wire_nlOOOl_dataout AND nl111l;
	wire_nlOO0O_dataout <= wire_nlOOOO_dataout WHEN nl111l = '1'  ELSE wire_n0Oi_w_lg_nliii279w(0);
	wire_nlOO1i_dataout <= wire_nlOOli_dataout OR NOT(nl111l);
	wire_nlOO1l_dataout <= wire_nlOOll_dataout OR NOT(nl111l);
	wire_nlOO1O_dataout <= wire_nlOOlO_dataout OR NOT(nl111l);
	wire_nlOOii_dataout <= wire_n111i_dataout OR niOOOl;
	wire_nlOOil_dataout <= wire_n111l_dataout AND NOT(niOOOl);
	wire_nlOOiO_dataout <= wire_n111O_dataout AND NOT(niOOOl);
	wire_nlOOli_dataout <= wire_n110i_dataout OR niOOOl;
	wire_nlOOll_dataout <= wire_n110l_dataout OR niOOOl;
	wire_nlOOlO_dataout <= wire_n110O_dataout OR niOOOl;
	wire_nlOOOi_dataout <= wire_n11ii_dataout OR niOOOl;
	wire_nlOOOl_dataout <= wire_n11il_dataout AND NOT(niOOOl);
	wire_nlOOOO_dataout <= wire_n11iO_dataout OR niOOOl;
	wire_nll1O_a <= ( nli0O & nli0l & nli0i & nli1O & nl01O & "1");
	wire_nll1O_b <= ( "1" & "1" & "1" & "1" & "0" & "1");
	nll1O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_nll1O_a,
		b => wire_nll1O_b,
		cin => wire_gnd,
		o => wire_nll1O_o
	  );
	wire_nl11O_i <= ( ni1l & n0OO & n0Ol & n00O);
	nl11O :  oper_decoder
	  GENERIC MAP (
		width_i => 4,
		width_o => 16
	  )
	  PORT MAP ( 
		i => wire_nl11O_i,
		o => wire_nl11O_o
	  );
	wire_nl0OO_a <= ( "1" & "0" & "0" & "0");
	wire_nl0OO_b <= ( ni1l & n0OO & n0Ol & n00O);
	nl0OO :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4
	  )
	  PORT MAP ( 
		a => wire_nl0OO_a,
		b => wire_nl0OO_b,
		cin => wire_gnd,
		o => wire_nl0OO_o
	  );
	wire_n1O0O_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_n011i_dataout & wire_n00Oi_dataout & wire_n011i_dataout & wire_n011i_dataout & wire_n011i_dataout & wire_n0llO_dataout & wire_n00Oi_dataout & wire_n011i_dataout & "1");
	wire_n1O0O_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1O0O :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1O0O_data,
		o => wire_n1O0O_o,
		sel => wire_n1O0O_sel
	  );
	wire_n1Oii_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_n011l_dataout & wire_n00Ol_dataout & wire_n011l_dataout & wire_n011l_dataout & wire_n011l_dataout & wire_n0lOi_dataout & wire_n00Ol_dataout & wire_n011l_dataout & "0");
	wire_n1Oii_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1Oii :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1Oii_data,
		o => wire_n1Oii_o,
		sel => wire_n1Oii_sel
	  );
	wire_n1Oil_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_n011O_dataout & wire_n00OO_dataout & wire_n011O_dataout & wire_n011O_dataout & wire_n011O_dataout & wire_n0lOl_dataout & wire_n00OO_dataout & wire_n011O_dataout & "0");
	wire_n1Oil_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1Oil :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1Oil_data,
		o => wire_n1Oil_o,
		sel => wire_n1Oil_sel
	  );
	wire_n1OiO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_n010i_dataout & wire_n0i1i_dataout & wire_n010i_dataout & wire_n010i_dataout & wire_n010i_dataout & wire_n0lOO_dataout & wire_n0i1i_dataout & wire_n010i_dataout & "1");
	wire_n1OiO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1OiO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OiO_data,
		o => wire_n1OiO_o,
		sel => wire_n1OiO_sel
	  );
	wire_n1Oli_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_n010l_dataout & wire_n0i1l_dataout & wire_n010l_dataout & wire_n010l_dataout & wire_n010l_dataout & wire_n0O1i_dataout & wire_n0i1l_dataout & wire_n010l_dataout & "1");
	wire_n1Oli_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1Oli :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1Oli_data,
		o => wire_n1Oli_o,
		sel => wire_n1Oli_sel
	  );
	wire_n1Oll_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_n010O_dataout & wire_n0i1O_dataout & wire_n010O_dataout & wire_n010O_dataout & wire_n010O_dataout & wire_n0O1l_dataout & wire_n0i1O_dataout & wire_n010O_dataout & "1");
	wire_n1Oll_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1Oll :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1Oll_data,
		o => wire_n1Oll_o,
		sel => wire_n1Oll_sel
	  );
	wire_n1OlO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_n01ii_dataout & wire_n0i0i_dataout & wire_n0iOO_dataout & wire_n0iOO_dataout & wire_n0l1O_dataout & wire_n0O1O_dataout & wire_n0l0l_dataout & wire_n0liO_dataout & "1");
	wire_n1OlO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1OlO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OlO_data,
		o => wire_n1OlO_o,
		sel => wire_n1OlO_sel
	  );
	wire_n1OOi_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_n01il_dataout & wire_n0i0l_dataout & wire_n0l1i_dataout & wire_n0l1i_dataout & wire_n01il_dataout & wire_n0O0i_dataout & wire_n0i0l_dataout & wire_n0lli_dataout & "0");
	wire_n1OOi_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1OOi :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OOi_data,
		o => wire_n1OOi_o,
		sel => wire_n1OOi_sel
	  );
	wire_n1OOl_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_n01iO_dataout & wire_n0i0O_dataout & wire_n0l1l_dataout & wire_n0l1l_dataout & wire_n0l0i_dataout & wire_n0O0l_dataout & wire_n0l0O_dataout & wire_n0lll_dataout & "1");
	wire_n1OOl_sel <= ( ni1l & n0OO & n0Ol & n00O);
	n1OOl :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n1OOl_data,
		o => wire_n1OOl_o,
		sel => wire_n1OOl_sel
	  );
	wire_ni01i_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_ni0li_dataout & wire_niilO_dataout & wire_nilil_dataout & wire_nilil_dataout & wire_nilll_dataout & wire_niOll_dataout & wire_nilOi_dataout & wire_niO1l_dataout & "1");
	wire_ni01i_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni01i :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01i_data,
		o => wire_ni01i_o,
		sel => wire_ni01i_sel
	  );
	wire_ni01l_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_ni0ll_dataout & wire_niiOi_dataout & wire_niliO_dataout & wire_niliO_dataout & wire_ni0ll_dataout & wire_niOlO_dataout & wire_niiOi_dataout & wire_niO1O_dataout & "0");
	wire_ni01l_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni01l :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01l_data,
		o => wire_ni01l_o,
		sel => wire_ni01l_sel
	  );
	wire_ni01O_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_ni0lO_dataout & wire_niiOl_dataout & wire_nilli_dataout & wire_nilli_dataout & wire_nillO_dataout & wire_niOOi_dataout & wire_nilOl_dataout & wire_niO0i_dataout & "1");
	wire_ni01O_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni01O :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni01O_data,
		o => wire_ni01O_o,
		sel => wire_ni01O_sel
	  );
	wire_ni1li_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_ni00i_dataout & wire_ni00i_dataout & wire_ni00i_dataout & wire_ni00i_dataout & wire_ni00i_dataout & wire_niO0l_dataout & wire_ni00i_dataout & wire_ni00i_dataout & "1");
	wire_ni1li_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni1li :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1li_data,
		o => wire_ni1li_o,
		sel => wire_ni1li_sel
	  );
	wire_ni1ll_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_ni00l_dataout & wire_niiii_dataout & wire_ni00l_dataout & wire_ni00l_dataout & wire_ni00l_dataout & wire_niO0O_dataout & wire_niiii_dataout & wire_ni00l_dataout & "0");
	wire_ni1ll_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni1ll :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1ll_data,
		o => wire_ni1ll_o,
		sel => wire_ni1ll_sel
	  );
	wire_ni1lO_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_ni00O_dataout & wire_niiil_dataout & wire_ni00O_dataout & wire_ni00O_dataout & wire_ni00O_dataout & wire_niOii_dataout & wire_niiil_dataout & wire_ni00O_dataout & "0");
	wire_ni1lO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni1lO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1lO_data,
		o => wire_ni1lO_o,
		sel => wire_ni1lO_sel
	  );
	wire_ni1Oi_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_ni0ii_dataout & wire_niiiO_dataout & wire_ni0ii_dataout & wire_ni0ii_dataout & wire_ni0ii_dataout & wire_niOil_dataout & wire_niiiO_dataout & wire_ni0ii_dataout & "1");
	wire_ni1Oi_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni1Oi :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1Oi_data,
		o => wire_ni1Oi_o,
		sel => wire_ni1Oi_sel
	  );
	wire_ni1Ol_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_ni0il_dataout & wire_niili_dataout & wire_ni0il_dataout & wire_ni0il_dataout & wire_ni0il_dataout & wire_niOiO_dataout & wire_niili_dataout & wire_ni0il_dataout & "1");
	wire_ni1Ol_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni1Ol :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1Ol_data,
		o => wire_ni1Ol_o,
		sel => wire_ni1Ol_sel
	  );
	wire_ni1OO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_ni0iO_dataout & wire_niill_dataout & wire_ni0iO_dataout & wire_ni0iO_dataout & wire_ni0iO_dataout & wire_niOli_dataout & wire_niill_dataout & wire_ni0iO_dataout & "1");
	wire_ni1OO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	ni1OO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_ni1OO_data,
		o => wire_ni1OO_o,
		sel => wire_ni1OO_sel
	  );
	wire_niOOl_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nl10i_dataout & wire_nl10O_dataout & wire_nl1lO_dataout & wire_nl1lO_dataout & "1" & "1" & wire_nl1OO_dataout & wire_nl01i_dataout & "1");
	wire_niOOl_sel <= ( ni1l & n0OO & n0Ol & n00O);
	niOOl :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_niOOl_data,
		o => wire_niOOl_o,
		sel => wire_niOOl_sel
	  );
	wire_niOOO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nl10l_dataout & wire_nl1ii_dataout & wire_nl1Oi_dataout & wire_nl1Oi_dataout & "0" & wire_w_lg_rdenablesync266w & "0" & wire_w_lg_nl111l276w & "1");
	wire_niOOO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	niOOO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_niOOO_data,
		o => wire_niOOO_o,
		sel => wire_niOOO_sel
	  );
	wire_nl11i_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_w_lg_nl111l276w & wire_nl1il_dataout & wire_w_lg_nl111l276w & wire_w_lg_nl111l276w & wire_w_lg_nl111l276w & wire_nl01l_dataout & wire_w_lg_nl111l276w & "0" & "0");
	wire_nl11i_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nl11i :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nl11i_data,
		o => wire_nl11i_o,
		sel => wire_nl11i_sel
	  );
	wire_nll0ll_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlli0l_dataout & wire_nllO0l_dataout & wire_nlli0l_dataout & wire_nlli0l_dataout & wire_nlli0l_dataout & wire_nlO0ii_dataout & wire_nllO0l_dataout & wire_nlli0l_dataout & "1");
	wire_nll0ll_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nll0ll :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0ll_data,
		o => wire_nll0ll_o,
		sel => wire_nll0ll_sel
	  );
	wire_nll0lO_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nlli0O_dataout & wire_nllO0O_dataout & wire_nlli0O_dataout & wire_nlli0O_dataout & wire_nlli0O_dataout & wire_nlO0il_dataout & wire_nllO0O_dataout & wire_nlli0O_dataout & "0");
	wire_nll0lO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nll0lO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0lO_data,
		o => wire_nll0lO_o,
		sel => wire_nll0lO_sel
	  );
	wire_nll0Oi_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nlliii_dataout & wire_nllOii_dataout & wire_nlliii_dataout & wire_nlliii_dataout & wire_nlliii_dataout & wire_nlO0iO_dataout & wire_nllOii_dataout & wire_nlliii_dataout & "0");
	wire_nll0Oi_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nll0Oi :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0Oi_data,
		o => wire_nll0Oi_o,
		sel => wire_nll0Oi_sel
	  );
	wire_nll0Ol_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlliil_dataout & wire_nllOil_dataout & wire_nlliil_dataout & wire_nlliil_dataout & wire_nlliil_dataout & wire_nlO0li_dataout & wire_nllOil_dataout & wire_nlliil_dataout & "1");
	wire_nll0Ol_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nll0Ol :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0Ol_data,
		o => wire_nll0Ol_o,
		sel => wire_nll0Ol_sel
	  );
	wire_nll0OO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlliiO_dataout & wire_nllOiO_dataout & wire_nlliiO_dataout & wire_nlliiO_dataout & wire_nlliiO_dataout & wire_nlO0ll_dataout & wire_nllOiO_dataout & wire_nlliiO_dataout & "1");
	wire_nll0OO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nll0OO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0OO_data,
		o => wire_nll0OO_o,
		sel => wire_nll0OO_sel
	  );
	wire_nlli0i_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlliOi_dataout & wire_nllOOi_dataout & wire_nlO1iO_dataout & wire_nlO1iO_dataout & wire_nlO1Oi_dataout & wire_nlO0OO_dataout & wire_nlO1OO_dataout & wire_nlO00l_dataout & "1");
	wire_nlli0i_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlli0i :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlli0i_data,
		o => wire_nlli0i_o,
		sel => wire_nlli0i_sel
	  );
	wire_nlli1i_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nllili_dataout & wire_nllOli_dataout & wire_nllili_dataout & wire_nllili_dataout & wire_nllili_dataout & wire_nlO0lO_dataout & wire_nllOli_dataout & wire_nllili_dataout & "1");
	wire_nlli1i_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlli1i :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlli1i_data,
		o => wire_nlli1i_o,
		sel => wire_nlli1i_sel
	  );
	wire_nlli1l_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nllill_dataout & wire_nllOll_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout & wire_nlO1lO_dataout & wire_nlO0Oi_dataout & wire_nlO1Ol_dataout & wire_nlO01O_dataout & "1");
	wire_nlli1l_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlli1l :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlli1l_data,
		o => wire_nlli1l_o,
		sel => wire_nlli1l_sel
	  );
	wire_nlli1O_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nllilO_dataout & wire_nllOlO_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout & wire_nllilO_dataout & wire_nlO0Ol_dataout & wire_nllOlO_dataout & wire_nlO00i_dataout & "0");
	wire_nlli1O_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlli1O :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlli1O_data,
		o => wire_nlli1O_o,
		sel => wire_nlli1O_sel
	  );
	wire_nlOl0i_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlOlOi_dataout & wire_n11li_dataout & wire_nlOlOi_dataout & wire_nlOlOi_dataout & wire_nlOlOi_dataout & wire_n1iiO_dataout & wire_n11li_dataout & wire_nlOlOi_dataout & "1");
	wire_nlOl0i_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOl0i :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOl0i_data,
		o => wire_nlOl0i_o,
		sel => wire_nlOl0i_sel
	  );
	wire_nlOl0l_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nlOlOl_dataout & wire_n11ll_dataout & wire_nlOlOl_dataout & wire_nlOlOl_dataout & wire_nlOlOl_dataout & wire_n1ili_dataout & wire_n11ll_dataout & wire_nlOlOl_dataout & "0");
	wire_nlOl0l_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOl0l :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOl0l_data,
		o => wire_nlOl0l_o,
		sel => wire_nlOl0l_sel
	  );
	wire_nlOl0O_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nlOlOO_dataout & wire_n11lO_dataout & wire_nlOlOO_dataout & wire_nlOlOO_dataout & wire_nlOlOO_dataout & wire_n1ill_dataout & wire_n11lO_dataout & wire_nlOlOO_dataout & "0");
	wire_nlOl0O_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOl0O :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOl0O_data,
		o => wire_nlOl0O_o,
		sel => wire_nlOl0O_sel
	  );
	wire_nlOlii_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlOO1i_dataout & wire_n11Oi_dataout & wire_nlOO1i_dataout & wire_nlOO1i_dataout & wire_nlOO1i_dataout & wire_n1ilO_dataout & wire_n11Oi_dataout & wire_nlOO1i_dataout & "1");
	wire_nlOlii_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOlii :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOlii_data,
		o => wire_nlOlii_o,
		sel => wire_nlOlii_sel
	  );
	wire_nlOlil_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlOO1l_dataout & wire_n11Ol_dataout & wire_nlOO1l_dataout & wire_nlOO1l_dataout & wire_nlOO1l_dataout & wire_n1iOi_dataout & wire_n11Ol_dataout & wire_nlOO1l_dataout & "1");
	wire_nlOlil_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOlil :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOlil_data,
		o => wire_nlOlil_o,
		sel => wire_nlOlil_sel
	  );
	wire_nlOliO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlOO1O_dataout & wire_n11OO_dataout & wire_nlOO1O_dataout & wire_nlOO1O_dataout & wire_nlOO1O_dataout & wire_n1iOl_dataout & wire_n11OO_dataout & wire_nlOO1O_dataout & "1");
	wire_nlOliO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOliO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOliO_data,
		o => wire_nlOliO_o,
		sel => wire_nlOliO_sel
	  );
	wire_nlOlli_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlOO0i_dataout & wire_n101i_dataout & wire_n10lO_dataout & wire_n10lO_dataout & wire_n10OO_dataout & wire_n1iOO_dataout & wire_n1i1l_dataout & wire_n1i0O_dataout & "1");
	wire_nlOlli_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOlli :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOlli_data,
		o => wire_nlOlli_o,
		sel => wire_nlOlli_sel
	  );
	wire_nlOlll_data <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nlOO0l_dataout & wire_n101l_dataout & wire_n10Oi_dataout & wire_n10Oi_dataout & wire_nlOO0l_dataout & wire_n1l1i_dataout & wire_n101l_dataout & wire_n1iii_dataout & "0");
	wire_nlOlll_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOlll :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOlll_data,
		o => wire_nlOlll_o,
		sel => wire_nlOlll_sel
	  );
	wire_nlOllO_data <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & wire_nlOO0O_dataout & wire_n101O_dataout & wire_n10Ol_dataout & wire_n10Ol_dataout & wire_n1i1i_dataout & wire_n1l1l_dataout & wire_n1i1O_dataout & wire_n1iil_dataout & "1");
	wire_nlOllO_sel <= ( ni1l & n0OO & n0Ol & n00O);
	nlOllO :  oper_mux
	  GENERIC MAP (
		width_data => 16,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlOllO_data,
		o => wire_nlOllO_o,
		sel => wire_nlOllO_sel
	  );

 END RTL; --stratixgx_xgm_tx_sm
--synopsys translate_on
--VALID FILE
--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 59 mux21 20 oper_selector 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_xgm_dskw_sm IS 
	 PORT 
	 ( 
		 adet	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 alignstatus	:	OUT  STD_LOGIC;
		 enabledeskew	:	OUT  STD_LOGIC;
		 fiforesetrd	:	OUT  STD_LOGIC;
		 rdalign	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		 recovclk	:	IN  STD_LOGIC;
		 resetall	:	IN  STD_LOGIC;
		 syncstatus	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0)
	 ); 
 END stratixgx_xgm_dskw_sm;

 ARCHITECTURE RTL OF stratixgx_xgm_dskw_sm IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 nl00O43	:	STD_LOGIC := '0';
	 SIGNAL	 nl00O44	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl00O44_w_lg_w_lg_q210w211w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl00O44_w_lg_q210w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0il41	:	STD_LOGIC := '0';
	 SIGNAL	 nl0il42	:	STD_LOGIC := '0';
	 SIGNAL	 nl0li39	:	STD_LOGIC := '0';
	 SIGNAL	 nl0li40	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0li40_w_lg_w_lg_q178w179w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0li40_w_lg_q178w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0Oi37	:	STD_LOGIC := '0';
	 SIGNAL	 nl0Oi38	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0Oi38_w_lg_w_lg_q153w154w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0Oi38_w_lg_q153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0Ol35	:	STD_LOGIC := '0';
	 SIGNAL	 nl0Ol36	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0Ol36_w_lg_w_lg_q148w149w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0Ol36_w_lg_q148w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nli0l29	:	STD_LOGIC := '0';
	 SIGNAL	 nli0l30	:	STD_LOGIC := '0';
	 SIGNAL	 nli1i33	:	STD_LOGIC := '0';
	 SIGNAL	 nli1i34	:	STD_LOGIC := '0';
	 SIGNAL	 nli1O31	:	STD_LOGIC := '0';
	 SIGNAL	 nli1O32	:	STD_LOGIC := '0';
	 SIGNAL  wire_nli1O32_w_lg_w_lg_q128w129w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O32_w_lg_q128w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nliil27	:	STD_LOGIC := '0';
	 SIGNAL	 nliil28	:	STD_LOGIC := '0';
	 SIGNAL	 nlili25	:	STD_LOGIC := '0';
	 SIGNAL	 nlili26	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlili26_w_lg_w_lg_q97w98w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlili26_w_lg_q97w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlilO23	:	STD_LOGIC := '0';
	 SIGNAL	 nlilO24	:	STD_LOGIC := '0';
	 SIGNAL	 nliOl21	:	STD_LOGIC := '0';
	 SIGNAL	 nliOl22	:	STD_LOGIC := '0';
	 SIGNAL  wire_nliOl22_w_lg_w_lg_q75w76w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl22_w_lg_q75w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nliOO19	:	STD_LOGIC := '0';
	 SIGNAL	 nliOO20	:	STD_LOGIC := '0';
	 SIGNAL  wire_nliOO20_w_lg_w_lg_q72w73w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO20_w_lg_q72w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nll0l13	:	STD_LOGIC := '0';
	 SIGNAL	 nll0l14	:	STD_LOGIC := '0';
	 SIGNAL	 nll1i17	:	STD_LOGIC := '0';
	 SIGNAL	 nll1i18	:	STD_LOGIC := '0';
	 SIGNAL  wire_nll1i18_w_lg_w_lg_q65w66w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll1i18_w_lg_q65w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nll1l15	:	STD_LOGIC := '0';
	 SIGNAL	 nll1l16	:	STD_LOGIC := '0';
	 SIGNAL  wire_nll1l16_w_lg_w_lg_q59w60w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll1l16_w_lg_q59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlliO11	:	STD_LOGIC := '0';
	 SIGNAL	 nlliO12	:	STD_LOGIC := '0';
	 SIGNAL	 nllll10	:	STD_LOGIC := '0';
	 SIGNAL  wire_nllll10_w_lg_q39w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nllll9	:	STD_LOGIC := '0';
	 SIGNAL	 nllOi7	:	STD_LOGIC := '0';
	 SIGNAL	 nllOi8	:	STD_LOGIC := '0';
	 SIGNAL	 nllOO5	:	STD_LOGIC := '0';
	 SIGNAL	 nllOO6	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0l1	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0l2	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1l3	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1l4	:	STD_LOGIC := '0';
	 SIGNAL	n0i	:	STD_LOGIC := '0';
	 SIGNAL	n1i	:	STD_LOGIC := '0';
	 SIGNAL	n1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1O_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n1O_w_lg_n1i47w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_n1l236w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO101w102w103w104w105w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO119w120w121w122w123w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w188w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO101w102w103w104w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w120w121w122w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w140w141w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_nlOO101w102w103w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_nlOO119w120w121w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w161w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_nlOO101w102w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_nlOO119w120w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_w_lg_nlOO119w139w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_nlOO101w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O_w_lg_nlOO119w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0l	:	STD_LOGIC := '0';
	 SIGNAL	nii	:	STD_LOGIC := '0';
	 SIGNAL	nil	:	STD_LOGIC := '0';
	 SIGNAL	nli	:	STD_LOGIC := '0';
	 SIGNAL	nlil	:	STD_LOGIC := '0';
	 SIGNAL	nliO	:	STD_LOGIC := '0';
	 SIGNAL	nlli	:	STD_LOGIC := '0';
	 SIGNAL	nlll	:	STD_LOGIC := '0';
	 SIGNAL	nllO	:	STD_LOGIC := '0';
	 SIGNAL	nlOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOl	:	STD_LOGIC := '0';
	 SIGNAL	wire_niO_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_niO_w_lg_nil45w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO_w_lg_w_lg_w_lg_w_lg_w_lg_nlOi81w82w83w84w85w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO_w_lg_w_lg_w_lg_w_lg_nlOi81w82w83w84w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO_w_lg_w_lg_w_lg_nlOi81w82w83w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO_w_lg_w_lg_nlOi81w82w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO_w_lg_nlOi81w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n00l_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n00l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00l_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n01i_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n01i_o	:	STD_LOGIC;
	 SIGNAL  wire_n01i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n01O_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n01O_o	:	STD_LOGIC;
	 SIGNAL  wire_n01O_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0ii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ii_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0iO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0iO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0iO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0Oi_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_n0Oi_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n1ll_data	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n1ll_o	:	STD_LOGIC;
	 SIGNAL  wire_n1ll_sel	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n1Oi_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n1Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_n1Oi_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n1Ol_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_n1Ol_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w41w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_adet_range31w33w35w37w40w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_adet_range31w33w35w37w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_adet_range31w33w35w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlO0i48w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_adet_range31w33w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nll0i52w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllil79w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlO0i11w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlO1i53w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_resetall27w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nl0ii :	STD_LOGIC;
	 SIGNAL  nl0ll :	STD_LOGIC;
	 SIGNAL  nl0lO :	STD_LOGIC;
	 SIGNAL  nl0OO :	STD_LOGIC;
	 SIGNAL  nli0i :	STD_LOGIC;
	 SIGNAL  nliii :	STD_LOGIC;
	 SIGNAL  nlill :	STD_LOGIC;
	 SIGNAL  nll0i :	STD_LOGIC;
	 SIGNAL  nll1O :	STD_LOGIC;
	 SIGNAL  nllii :	STD_LOGIC;
	 SIGNAL  nllil :	STD_LOGIC;
	 SIGNAL  nllOl :	STD_LOGIC;
	 SIGNAL  nlO0i :	STD_LOGIC;
	 SIGNAL  nlO1i :	STD_LOGIC;
	 SIGNAL  wire_w_adet_range31w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_adet_range32w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_adet_range34w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_adet_range36w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w41w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_adet_range31w33w35w37w40w(0) AND nil;
	wire_w_lg_w_lg_w_lg_w_lg_w_adet_range31w33w35w37w40w(0) <= wire_w_lg_w_lg_w_lg_w_adet_range31w33w35w37w(0) AND wire_nllll10_w_lg_q39w(0);
	wire_w_lg_w_lg_w_lg_w_adet_range31w33w35w37w(0) <= wire_w_lg_w_lg_w_adet_range31w33w35w(0) AND wire_w_adet_range36w(0);
	wire_w_lg_w_lg_w_adet_range31w33w35w(0) <= wire_w_lg_w_adet_range31w33w(0) AND wire_w_adet_range34w(0);
	wire_w_lg_nlO0i48w(0) <= nlO0i AND wire_n1O_w_lg_n1i47w(0);
	wire_w_lg_w_adet_range31w33w(0) <= wire_w_adet_range31w(0) AND wire_w_adet_range32w(0);
	wire_w_lg_nll0i52w(0) <= NOT nll0i;
	wire_w_lg_nllil79w(0) <= NOT nllil;
	wire_w_lg_nlO0i11w(0) <= NOT nlO0i;
	wire_w_lg_nlO1i53w(0) <= NOT nlO1i;
	wire_w_lg_resetall27w(0) <= NOT resetall;
	alignstatus <= n0l;
	enabledeskew <= n0i;
	fiforesetrd <= (n0i AND wire_n1O_w_lg_n1l236w(0));
	nl0ii <= (wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w188w(0) OR (NOT (nl0il42 XOR nl0il41)));
	nl0ll <= wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w(0);
	nl0lO <= (wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w161w(0) OR nlil);
	nl0OO <= (wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w140w141w(0) OR (NOT (nli1i34 XOR nli1i33)));
	nli0i <= (wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO119w120w121w122w123w(0) OR (NOT (nli0l30 XOR nli0l29)));
	nliii <= (wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO101w102w103w104w105w(0) OR (NOT (nliil28 XOR nliil27)));
	nlill <= (wire_niO_w_lg_w_lg_w_lg_w_lg_w_lg_nlOi81w82w83w84w85w(0) OR (NOT (nlilO24 XOR nlilO23)));
	nll0i <= (wire_w_lg_nlO0i48w(0) AND (nll0l14 XOR nll0l13));
	nll1O <= (nlO1i OR wire_niO_w_lg_nil45w(0));
	nllii <= (nlO1i OR wire_niO_w_lg_nil45w(0));
	nllil <= (wire_w41w(0) AND (nlliO12 XOR nlliO11));
	nllOl <= '1';
	nlO0i <= ((((rdalign(0) AND rdalign(1)) AND rdalign(2)) AND rdalign(3)) AND (nlO0l2 XOR nlO0l1));
	nlO1i <= ((wire_w_lg_nlO0i11w(0) AND (((rdalign(0) OR rdalign(1)) OR rdalign(2)) OR rdalign(3))) AND (nlO1l4 XOR nlO1l3));
	wire_w_adet_range31w(0) <= adet(0);
	wire_w_adet_range32w(0) <= adet(1);
	wire_w_adet_range34w(0) <= adet(2);
	wire_w_adet_range36w(0) <= adet(3);
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl00O43 <= nl00O44;
		END IF;
		if (now = 0 ns) then
			nl00O43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl00O44 <= nl00O43;
		END IF;
	END PROCESS;
	wire_nl00O44_w_lg_w_lg_q210w211w(0) <= wire_nl00O44_w_lg_q210w(0) AND nlOO;
	wire_nl00O44_w_lg_q210w(0) <= nl00O44 XOR nl00O43;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0il41 <= nl0il42;
		END IF;
		if (now = 0 ns) then
			nl0il41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0il42 <= nl0il41;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0li39 <= nl0li40;
		END IF;
		if (now = 0 ns) then
			nl0li39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0li40 <= nl0li39;
		END IF;
	END PROCESS;
	wire_nl0li40_w_lg_w_lg_q178w179w(0) <= wire_nl0li40_w_lg_q178w(0) AND nlli;
	wire_nl0li40_w_lg_q178w(0) <= nl0li40 XOR nl0li39;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0Oi37 <= nl0Oi38;
		END IF;
		if (now = 0 ns) then
			nl0Oi37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0Oi38 <= nl0Oi37;
		END IF;
	END PROCESS;
	wire_nl0Oi38_w_lg_w_lg_q153w154w(0) <= wire_nl0Oi38_w_lg_q153w(0) AND wire_ni0l_dataout;
	wire_nl0Oi38_w_lg_q153w(0) <= nl0Oi38 XOR nl0Oi37;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0Ol35 <= nl0Ol36;
		END IF;
		if (now = 0 ns) then
			nl0Ol35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nl0Ol36 <= nl0Ol35;
		END IF;
	END PROCESS;
	wire_nl0Ol36_w_lg_w_lg_q148w149w(0) <= wire_nl0Ol36_w_lg_q148w(0) AND nlll;
	wire_nl0Ol36_w_lg_q148w(0) <= nl0Ol36 XOR nl0Ol35;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nli0l29 <= nli0l30;
		END IF;
		if (now = 0 ns) then
			nli0l29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nli0l30 <= nli0l29;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nli1i33 <= nli1i34;
		END IF;
		if (now = 0 ns) then
			nli1i33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nli1i34 <= nli1i33;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nli1O31 <= nli1O32;
		END IF;
		if (now = 0 ns) then
			nli1O31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nli1O32 <= nli1O31;
		END IF;
	END PROCESS;
	wire_nli1O32_w_lg_w_lg_q128w129w(0) <= wire_nli1O32_w_lg_q128w(0) AND nllO;
	wire_nli1O32_w_lg_q128w(0) <= nli1O32 XOR nli1O31;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nliil27 <= nliil28;
		END IF;
		if (now = 0 ns) then
			nliil27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nliil28 <= nliil27;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlili25 <= nlili26;
		END IF;
		if (now = 0 ns) then
			nlili25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlili26 <= nlili25;
		END IF;
	END PROCESS;
	wire_nlili26_w_lg_w_lg_q97w98w(0) <= wire_nlili26_w_lg_q97w(0) AND wire_nl1O_dataout;
	wire_nlili26_w_lg_q97w(0) <= nlili26 XOR nlili25;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlilO23 <= nlilO24;
		END IF;
		if (now = 0 ns) then
			nlilO23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlilO24 <= nlilO23;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nliOl21 <= nliOl22;
		END IF;
		if (now = 0 ns) then
			nliOl21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nliOl22 <= nliOl21;
		END IF;
	END PROCESS;
	wire_nliOl22_w_lg_w_lg_q75w76w(0) <= wire_nliOl22_w_lg_q75w(0) AND nllii;
	wire_nliOl22_w_lg_q75w(0) <= nliOl22 XOR nliOl21;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nliOO19 <= nliOO20;
		END IF;
		if (now = 0 ns) then
			nliOO19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nliOO20 <= nliOO19;
		END IF;
	END PROCESS;
	wire_nliOO20_w_lg_w_lg_q72w73w(0) <= wire_nliOO20_w_lg_q72w(0) AND nllii;
	wire_nliOO20_w_lg_q72w(0) <= nliOO20 XOR nliOO19;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nll0l13 <= nll0l14;
		END IF;
		if (now = 0 ns) then
			nll0l13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nll0l14 <= nll0l13;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nll1i17 <= nll1i18;
		END IF;
		if (now = 0 ns) then
			nll1i17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nll1i18 <= nll1i17;
		END IF;
	END PROCESS;
	wire_nll1i18_w_lg_w_lg_q65w66w(0) <= wire_nll1i18_w_lg_q65w(0) AND nll1O;
	wire_nll1i18_w_lg_q65w(0) <= nll1i18 XOR nll1i17;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nll1l15 <= nll1l16;
		END IF;
		if (now = 0 ns) then
			nll1l15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nll1l16 <= nll1l15;
		END IF;
	END PROCESS;
	wire_nll1l16_w_lg_w_lg_q59w60w(0) <= wire_nll1l16_w_lg_q59w(0) AND nllO;
	wire_nll1l16_w_lg_q59w(0) <= nll1l16 XOR nll1l15;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlliO11 <= nlliO12;
		END IF;
		if (now = 0 ns) then
			nlliO11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlliO12 <= nlliO11;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nllll10 <= nllll9;
		END IF;
	END PROCESS;
	wire_nllll10_w_lg_q39w(0) <= nllll10 XOR nllll9;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nllll9 <= nllll10;
		END IF;
		if (now = 0 ns) then
			nllll9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nllOi7 <= nllOi8;
		END IF;
		if (now = 0 ns) then
			nllOi7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nllOi8 <= nllOi7;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nllOO5 <= nllOO6;
		END IF;
		if (now = 0 ns) then
			nllOO5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nllOO6 <= nllOO5;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlO0l1 <= nlO0l2;
		END IF;
		if (now = 0 ns) then
			nlO0l1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlO0l2 <= nlO0l1;
		END IF;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlO1l3 <= nlO1l4;
		END IF;
		if (now = 0 ns) then
			nlO1l3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (recovclk)
	BEGIN
		IF (recovclk = '1' AND recovclk'event) THEN nlO1l4 <= nlO1l3;
		END IF;
	END PROCESS;
	PROCESS (recovclk, wire_n1O_PRN)
	BEGIN
		IF (wire_n1O_PRN = '0') THEN
				n0i <= '1';
				n1i <= '1';
				n1l <= '1';
				nlOO <= '1';
		ELSIF (recovclk = '1' AND recovclk'event) THEN
				n0i <= wire_n1Oi_o;
				n1i <= n1l;
				n1l <= n0i;
				nlOO <= wire_n0Oi_o;
		END IF;
		if (now = 0 ns) then
			n0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n1O_PRN <= ((nllOi8 XOR nllOi7) AND wire_w_lg_resetall27w(0));
	wire_n1O_w_lg_n1i47w(0) <= NOT n1i;
	wire_n1O_w_lg_n1l236w(0) <= NOT n1l;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO101w102w103w104w105w(0) <= wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO101w102w103w104w(0) OR nlil;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO119w120w121w122w123w(0) <= wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w120w121w122w(0) OR nlil;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w188w(0) <= wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w(0) OR nlli;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO101w102w103w104w(0) <= wire_n1O_w_lg_w_lg_w_lg_nlOO101w102w103w(0) OR nliO;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w120w121w122w(0) <= wire_n1O_w_lg_w_lg_w_lg_nlOO119w120w121w(0) OR nliO;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w140w141w(0) <= wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w140w(0) OR nlil;
	wire_n1O_w_lg_w_lg_w_lg_w_lg_nlOO119w139w161w174w(0) <= wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w161w(0) OR nlll;
	wire_n1O_w_lg_w_lg_w_lg_nlOO101w102w103w(0) <= wire_n1O_w_lg_w_lg_nlOO101w102w(0) OR nlli;
	wire_n1O_w_lg_w_lg_w_lg_nlOO119w120w121w(0) <= wire_n1O_w_lg_w_lg_nlOO119w120w(0) OR nlli;
	wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w140w(0) <= wire_n1O_w_lg_w_lg_nlOO119w139w(0) OR nliO;
	wire_n1O_w_lg_w_lg_w_lg_nlOO119w139w161w(0) <= wire_n1O_w_lg_w_lg_nlOO119w139w(0) OR nllO;
	wire_n1O_w_lg_w_lg_nlOO101w102w(0) <= wire_n1O_w_lg_nlOO101w(0) OR nlll;
	wire_n1O_w_lg_w_lg_nlOO119w120w(0) <= wire_n1O_w_lg_nlOO119w(0) OR nlll;
	wire_n1O_w_lg_w_lg_nlOO119w139w(0) <= wire_n1O_w_lg_nlOO119w(0) OR nlOi;
	wire_n1O_w_lg_nlOO101w(0) <= nlOO OR nllO;
	wire_n1O_w_lg_nlOO119w(0) <= nlOO OR nlOl;
	PROCESS (recovclk, wire_niO_CLRN)
	BEGIN
		IF (wire_niO_CLRN = '0') THEN
				n0l <= '0';
				nii <= '0';
				nil <= '0';
				nli <= '0';
				nlil <= '0';
				nliO <= '0';
				nlli <= '0';
				nlll <= '0';
				nllO <= '0';
				nlOi <= '0';
				nlOl <= '0';
		ELSIF (recovclk = '1' AND recovclk'event) THEN
				n0l <= nii;
				nii <= wire_n1ll_o;
				nil <= nli;
				nli <= (((syncstatus(0) AND syncstatus(1)) AND syncstatus(2)) AND syncstatus(3));
				nlil <= wire_n1Ol_o;
				nliO <= wire_n01i_o;
				nlli <= wire_n01O_o;
				nlll <= wire_n00l_o;
				nllO <= wire_n0ii_o;
				nlOi <= wire_n0iO_o;
				nlOl <= wire_n0ll_o;
		END IF;
	END PROCESS;
	wire_niO_CLRN <= ((nllOO6 XOR nllOO5) AND wire_w_lg_resetall27w(0));
	wire_niO_w_lg_nil45w(0) <= NOT nil;
	wire_niO_w_lg_w_lg_w_lg_w_lg_w_lg_nlOi81w82w83w84w85w(0) <= wire_niO_w_lg_w_lg_w_lg_w_lg_nlOi81w82w83w84w(0) OR nlil;
	wire_niO_w_lg_w_lg_w_lg_w_lg_nlOi81w82w83w84w(0) <= wire_niO_w_lg_w_lg_w_lg_nlOi81w82w83w(0) OR nliO;
	wire_niO_w_lg_w_lg_w_lg_nlOi81w82w83w(0) <= wire_niO_w_lg_w_lg_nlOi81w82w(0) OR nlli;
	wire_niO_w_lg_w_lg_nlOi81w82w(0) <= wire_niO_w_lg_nlOi81w(0) OR nlll;
	wire_niO_w_lg_nlOi81w(0) <= nlOi OR nllO;
	wire_n0Ol_dataout <= n0i OR nll1O;
	wire_n0OO_dataout <= nii AND NOT(nll1O);
	wire_ni0i_dataout <= wire_ni0O_dataout AND NOT(wire_niO_w_lg_nil45w(0));
	wire_ni0l_dataout <= wire_niii_dataout AND NOT(wire_niO_w_lg_nil45w(0));
	wire_ni0O_dataout <= wire_w_lg_nlO0i11w(0) AND NOT(nlO1i);
	wire_ni1i_dataout <= wire_w_lg_nlO0i11w(0) AND NOT(nll1O);
	wire_ni1l_dataout <= nlO0i AND NOT(nll1O);
	wire_niii_dataout <= nlO0i AND NOT(nlO1i);
	wire_niil_dataout <= n0i OR wire_niO_w_lg_nil45w(0);
	wire_niiO_dataout <= nii AND NOT(wire_niO_w_lg_nil45w(0));
	wire_nili_dataout <= nlO1i AND NOT(wire_niO_w_lg_nil45w(0));
	wire_nill_dataout <= wire_w_lg_nlO1i53w(0) AND NOT(wire_niO_w_lg_nil45w(0));
	wire_nilO_dataout <= nii WHEN nllii = '1'  ELSE wire_niOi_dataout;
	wire_niOi_dataout <= nii OR nlO0i;
	wire_niOl_dataout <= nlO0i AND NOT(nllii);
	wire_niOO_dataout <= wire_w_lg_nlO0i11w(0) AND NOT(nllii);
	wire_nl0O_dataout <= n0i AND NOT(nllil);
	wire_nl1i_dataout <= n0i OR nllii;
	wire_nl1l_dataout <= nll0i AND NOT(nllii);
	wire_nl1O_dataout <= wire_w_lg_nll0i52w(0) AND NOT(nllii);
	wire_n00l_data <= ( "0" & wire_niOl_dataout & wire_nill_dataout & wire_nl0Oi38_w_lg_w_lg_q153w154w);
	wire_n00l_sel <= ( nl0OO & nllO & wire_nl0Ol36_w_lg_w_lg_q148w149w & nlli);
	n00l :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n00l_data,
		o => wire_n00l_o,
		sel => wire_n00l_sel
	  );
	wire_n01i_data <= ( "0" & wire_nili_dataout & wire_ni0i_dataout & wire_ni1l_dataout);
	wire_n01i_sel <= ( nl0ll & wire_nl0li40_w_lg_w_lg_q178w179w & nliO & nlil);
	n01i :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n01i_data,
		o => wire_n01i_o,
		sel => wire_n01i_sel
	  );
	wire_n01O_data <= ( "0" & wire_nili_dataout & wire_ni0i_dataout & wire_ni0l_dataout);
	wire_n01O_sel <= ( nl0lO & nlll & nlli & nliO);
	n01O :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_n01O_data,
		o => wire_n01O_o,
		sel => wire_n01O_sel
	  );
	wire_n0ii_data <= ( "0" & wire_niOl_dataout & wire_niOO_dataout);
	wire_n0ii_sel <= ( nli0i & nlOi & wire_nli1O32_w_lg_w_lg_q128w129w);
	n0ii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ii_data,
		o => wire_n0ii_o,
		sel => wire_n0ii_sel
	  );
	wire_n0iO_data <= ( "0" & wire_nl1l_dataout & wire_niOO_dataout);
	wire_n0iO_sel <= ( nliii & nlOl & nlOi);
	n0iO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0iO_data,
		o => wire_n0iO_o,
		sel => wire_n0iO_sel
	  );
	wire_n0ll_data <= ( nllil & wire_nlili26_w_lg_w_lg_q97w98w & "0");
	wire_n0ll_sel <= ( nlOO & nlOl & nlill);
	n0ll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ll_data,
		o => wire_n0ll_o,
		sel => wire_n0ll_sel
	  );
	wire_n0Oi_data <= ( wire_w_lg_nllil79w & nllii & wire_nliOl22_w_lg_w_lg_q75w76w & wire_nliOO20_w_lg_w_lg_q72w73w & wire_niO_w_lg_nil45w & wire_niO_w_lg_nil45w & wire_niO_w_lg_nil45w & wire_nll1i18_w_lg_w_lg_q65w66w);
	wire_n0Oi_sel <= ( nlOO & nlOl & nlOi & wire_nll1l16_w_lg_w_lg_q59w60w & nlll & nlli & nliO & nlil);
	n0Oi :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_n0Oi_data,
		o => wire_n0Oi_o,
		sel => wire_n0Oi_sel
	  );
	wire_n1ll_data <= ( nii & wire_nilO_dataout & wire_niiO_dataout & wire_niiO_dataout & wire_niiO_dataout & wire_n0OO_dataout);
	wire_n1ll_sel <= ( wire_n1O_w_lg_w_lg_nlOO119w139w & nllO & nlll & nlli & nliO & nlil);
	n1ll :  oper_selector
	  GENERIC MAP (
		width_data => 6,
		width_sel => 6
	  )
	  PORT MAP ( 
		data => wire_n1ll_data,
		o => wire_n1ll_o,
		sel => wire_n1ll_sel
	  );
	wire_n1Oi_data <= ( wire_nl0O_dataout & wire_nl1i_dataout & wire_nl1i_dataout & wire_nl1i_dataout & wire_niil_dataout & wire_niil_dataout & wire_niil_dataout & wire_n0Ol_dataout);
	wire_n1Oi_sel <= ( wire_nl00O44_w_lg_w_lg_q210w211w & nlOl & nlOi & nllO & nlll & nlli & nliO & nlil);
	n1Oi :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_n1Oi_data,
		o => wire_n1Oi_o,
		sel => wire_n1Oi_sel
	  );
	wire_n1Ol_data <= ( "0" & wire_nili_dataout & wire_ni1i_dataout);
	wire_n1Ol_sel <= ( nl0ii & nliO & nlil);
	n1Ol :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n1Ol_data,
		o => wire_n1Ol_o,
		sel => wire_n1Ol_sel
	  );

 END RTL; --stratixgx_xgm_dskw_sm
--synopsys translate_on
--VALID FILE
--
-- stratixgx_reset_block
-- 

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_reset_block IS
   PORT (
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0);   
      pllreset                : IN std_logic;   
      pllenable               : IN std_logic;   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic);   
END stratixgx_reset_block;

ARCHITECTURE stratixgx_reset_arch OF stratixgx_reset_block IS
   -- WIREs:
   signal HARD_RESET              :  std_logic;   
   signal txdigitalresetout_tmp   :  std_logic_vector(3 DOWNTO 0);   
   signal rxdigitalresetout_tmp   :  std_logic_vector(3 DOWNTO 0);   
   signal txanalogresetout_tmp    :  std_logic_vector(3 DOWNTO 0);   
   signal rxanalogresetout_tmp    :  std_logic_vector(3 DOWNTO 0);   
   signal pllresetout_tmp         :  std_logic;   

BEGIN

  txdigitalresetout <= txdigitalresetout_tmp;
   
  rxdigitalresetout <= rxdigitalresetout_tmp;

  txanalogresetout <= txanalogresetout_tmp;

  rxanalogresetout <= rxanalogresetout_tmp;

  pllresetout <= pllresetout_tmp;

  HARD_RESET <= pllreset OR NOT pllenable ;

  rxanalogresetout_tmp <= (HARD_RESET OR rxanalogreset(3)) &
                          (HARD_RESET OR rxanalogreset(2)) &
                          (HARD_RESET OR rxanalogreset(1)) &
                          (HARD_RESET OR rxanalogreset(0)) ;
   
  txanalogresetout_tmp <= (HARD_RESET & HARD_RESET &
                           HARD_RESET & HARD_RESET);
   
  pllresetout_tmp <= ((((((rxanalogresetout_tmp(0) AND rxanalogresetout_tmp(1)) AND
                          rxanalogresetout_tmp(2)) AND rxanalogresetout_tmp(3)) AND
                        txanalogresetout_tmp(0)) AND txanalogresetout_tmp(1)) AND
                      txanalogresetout_tmp(2)) AND txanalogresetout_tmp(3) ;

  rxdigitalresetout_tmp <= (HARD_RESET OR rxdigitalreset(3)) &
                           (HARD_RESET OR rxdigitalreset(2)) &
                           (HARD_RESET OR rxdigitalreset(1)) &
                           (HARD_RESET OR rxdigitalreset(0)) ;
   
  txdigitalresetout_tmp <= (HARD_RESET OR txdigitalreset(3)) &
                           (HARD_RESET OR txdigitalreset(2)) &
                           (HARD_RESET OR txdigitalreset(1)) &
                           (HARD_RESET OR txdigitalreset(0)) ;

END stratixgx_reset_arch;


--IP Functional Simulation Model
--VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END


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

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = lut 67 mux21 46 oper_selector 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  stratixgx_hssi_tx_enc_rtl IS 
	 PORT 
	 ( 
		 ENDEC	:	IN  STD_LOGIC;
		 GE_XAUI_SEL	:	IN  STD_LOGIC;
		 IB_FORCE_DISPARITY	:	IN  STD_LOGIC;
		 INDV	:	IN  STD_LOGIC;
		 prbs_en	:	IN  STD_LOGIC;
		 PUDR	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 soft_reset	:	IN  STD_LOGIC;
		 tx_clk	:	IN  STD_LOGIC;
		 tx_ctl_tc	:	IN  STD_LOGIC;
		 tx_ctl_ts	:	IN  STD_LOGIC;
		 tx_data_9_tc	:	IN  STD_LOGIC;
		 tx_data_pg	:	IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		 tx_data_tc	:	IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 tx_data_ts	:	IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
		 TXLP10B	:	OUT  STD_LOGIC_VECTOR (9 DOWNTO 0)
	 ); 
 END stratixgx_hssi_tx_enc_rtl;

 ARCHITECTURE RTL OF stratixgx_hssi_tx_enc_rtl IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	 n100l27	:	STD_LOGIC := '0';
	 SIGNAL	 n100l28	:	STD_LOGIC := '0';
	 SIGNAL	 n101O29	:	STD_LOGIC := '0';
	 SIGNAL	 n101O30	:	STD_LOGIC := '0';
	 SIGNAL	 n10ii25	:	STD_LOGIC := '0';
	 SIGNAL	 n10ii26	:	STD_LOGIC := '0';
	 SIGNAL	 n10li23	:	STD_LOGIC := '0';
	 SIGNAL	 n10li24	:	STD_LOGIC := '0';
	 SIGNAL	 n10lO21	:	STD_LOGIC := '0';
	 SIGNAL	 n10lO22	:	STD_LOGIC := '0';
	 SIGNAL  wire_n10lO22_w_lg_q71w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n10OO19	:	STD_LOGIC := '0';
	 SIGNAL	 n10OO20	:	STD_LOGIC := '0';
	 SIGNAL  wire_n10OO20_w_lg_q47w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11ii43	:	STD_LOGIC := '0';
	 SIGNAL	 n11ii44	:	STD_LOGIC := '0';
	 SIGNAL  wire_n11ii44_w_lg_w_lg_q155w156w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11ii44_w_lg_q155w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11il41	:	STD_LOGIC := '0';
	 SIGNAL	 n11il42	:	STD_LOGIC := '0';
	 SIGNAL  wire_n11il42_w_lg_w_lg_q131w132w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11il42_w_lg_q131w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11iO39	:	STD_LOGIC := '0';
	 SIGNAL	 n11iO40	:	STD_LOGIC := '0';
	 SIGNAL  wire_n11iO40_w_lg_w_lg_q125w126w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11iO40_w_lg_q125w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11li37	:	STD_LOGIC := '0';
	 SIGNAL	 n11li38	:	STD_LOGIC := '0';
	 SIGNAL  wire_n11li38_w_lg_w_lg_q113w114w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11li38_w_lg_q113w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11ll35	:	STD_LOGIC := '0';
	 SIGNAL	 n11ll36	:	STD_LOGIC := '0';
	 SIGNAL  wire_n11ll36_w_lg_w_lg_q109w110w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11ll36_w_lg_q109w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11lO33	:	STD_LOGIC := '0';
	 SIGNAL	 n11lO34	:	STD_LOGIC := '0';
	 SIGNAL  wire_n11lO34_w_lg_w_lg_q95w96w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11lO34_w_lg_q95w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n11Ol31	:	STD_LOGIC := '0';
	 SIGNAL	 n11Ol32	:	STD_LOGIC := '0';
	 SIGNAL	 n1i0l15	:	STD_LOGIC := '0';
	 SIGNAL	 n1i0l16	:	STD_LOGIC := '0';
	 SIGNAL	 n1i1l17	:	STD_LOGIC := '0';
	 SIGNAL	 n1i1l18	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1i1l18_w_lg_q43w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1iii13	:	STD_LOGIC := '0';
	 SIGNAL	 n1iii14	:	STD_LOGIC := '0';
	 SIGNAL	 n1iiO11	:	STD_LOGIC := '0';
	 SIGNAL	 n1iiO12	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1iiO12_w_lg_q28w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1ill10	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1ill10_w_lg_q24w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1ill9	:	STD_LOGIC := '0';
	 SIGNAL	 n1iOi7	:	STD_LOGIC := '0';
	 SIGNAL	 n1iOi8	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1iOi8_w_lg_q20w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1iOO5	:	STD_LOGIC := '0';
	 SIGNAL	 n1iOO6	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1iOO6_w_lg_q15w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1l1l3	:	STD_LOGIC := '0';
	 SIGNAL	 n1l1l4	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1l1l4_w_lg_q9w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 n1liO1	:	STD_LOGIC := '0';
	 SIGNAL	 n1liO2	:	STD_LOGIC := '0';
	 SIGNAL	n10i	:	STD_LOGIC := '0';
	 SIGNAL	n10l	:	STD_LOGIC := '0';
	 SIGNAL	n10O	:	STD_LOGIC := '0';
	 SIGNAL	n11O	:	STD_LOGIC := '0';
	 SIGNAL	n1ii	:	STD_LOGIC := '0';
	 SIGNAL	n1li	:	STD_LOGIC := '0';
	 SIGNAL	n00i	:	STD_LOGIC := '0';
	 SIGNAL	n00l	:	STD_LOGIC := '0';
	 SIGNAL	n00O	:	STD_LOGIC := '0';
	 SIGNAL	n01i	:	STD_LOGIC := '0';
	 SIGNAL	n01l	:	STD_LOGIC := '0';
	 SIGNAL	n01O	:	STD_LOGIC := '0';
	 SIGNAL	n0ii	:	STD_LOGIC := '0';
	 SIGNAL	n0il	:	STD_LOGIC := '0';
	 SIGNAL	n11i	:	STD_LOGIC := '0';
	 SIGNAL	n11l	:	STD_LOGIC := '0';
	 SIGNAL	n1il	:	STD_LOGIC := '0';
	 SIGNAL	n1ll	:	STD_LOGIC := '0';
	 SIGNAL	n1lO	:	STD_LOGIC := '0';
	 SIGNAL	n1OO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOO	:	STD_LOGIC := '0';
	 SIGNAL	nO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nl_w_lg_nO31w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl_w_lg_nO4w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl_w_lg_nO73w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nlOOl	:	STD_LOGIC := '0';
	 SIGNAL	wire_nlOOi_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nlOOi_ENA	:	STD_LOGIC;
	 SIGNAL  wire_nlOOi_w_lg_nlOOl68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0i0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0i0l_w_lg_w_lg_dataout253w256w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0l_w_lg_w_lg_dataout253w258w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0l_w_lg_dataout300w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0l_w_lg_dataout253w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0i0l_w_lg_w_lg_w_lg_dataout253w256w257w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n1l_w_lg_w_lg_dataout327w328w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l_w_lg_dataout255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l_w_lg_dataout302w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l_w_lg_dataout327w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0l_w_lg_dataout273w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni0O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout269w315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_w_lg_dataout269w270w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout274w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout316w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0O_w_lg_dataout324w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni10O_w_lg_dataout356w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1ii_w_lg_dataout357w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_ni1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_ni1Oi_w_lg_dataout358w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niii_w_lg_w_lg_dataout268w394w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout268w389w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout268w380w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout268w377w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout268w290w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_w_lg_dataout268w281w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout383w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout293w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout296w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout336w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout288w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout268w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niii_w_lg_dataout325w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niil_w_lg_w_lg_dataout266w337w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_dataout266w289w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_dataout266w346w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout395w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout390w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout381w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout378w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout291w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout282w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout384w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout294w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout297w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_dataout266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_w_lg_dataout266w337w339w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_w_lg_dataout266w289w292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_w_lg_dataout266w346w347w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_w_lg_w_lg_dataout266w337w339w341w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w_lg_w_lg_w_lg_dataout266w289w292w295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w343w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w298w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niil_w_lg_w343w344w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niiO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niiO_w_lg_w_lg_w_lg_dataout286w287w299w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_w_lg_dataout286w348w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_w_lg_dataout286w287w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout333w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout267w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout342w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout340w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout338w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niiO_w_lg_dataout286w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nili_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nili_w_lg_dataout312w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nill_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nill_w_lg_dataout303w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nill_w_lg_dataout265w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nilO_w_lg_dataout304w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilO_w_lg_dataout261w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nilOl_w_lg_dataout260w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niO0i_w_lg_dataout262w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_niO0O_w_lg_dataout263w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_niOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlO0i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO0l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO0l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO0O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO0O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO1l_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO1l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO1O_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO1O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOii_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOil_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOil_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOil_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOiO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOiO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOiO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOli_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOli_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOli_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w26w29w30w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w26w29w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w16w17w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w48w49w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w26w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w16w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w48w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w21w22w25w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w10w11w13w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w36w37w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w44w45w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w21w22w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w10w11w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w36w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w44w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_IB_FORCE_DISPARITY67w69w72w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1l0l5w7w21w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1l0l5w7w10w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_n1l0l5w7w35w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_w_lg_nlOO0l329w331w332w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_IB_FORCE_DISPARITY67w69w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_n1l0l5w7w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nlOO0l329w331w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_IB_FORCE_DISPARITY67w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_tx_ctl_tc241w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_ENDEC251w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n10iO345w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n110O254w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n11Oi92w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0i6w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_n1l0l5w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO0i354w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO0l329w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO0O330w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOii355w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_prbs_en249w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_soft_reset2w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_tx_ctl_tc12w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_tx_data_tc_range66w228w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nlOOOi349w350w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOO1O351w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOOOi349w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  n101i :	STD_LOGIC;
	 SIGNAL  n101l :	STD_LOGIC;
	 SIGNAL  n10il :	STD_LOGIC;
	 SIGNAL  n10iO :	STD_LOGIC;
	 SIGNAL  n10Ol :	STD_LOGIC;
	 SIGNAL  n110i :	STD_LOGIC;
	 SIGNAL  n110l :	STD_LOGIC;
	 SIGNAL  n110O :	STD_LOGIC;
	 SIGNAL  n111i :	STD_LOGIC;
	 SIGNAL  n111l :	STD_LOGIC;
	 SIGNAL  n111O :	STD_LOGIC;
	 SIGNAL  n11Oi :	STD_LOGIC;
	 SIGNAL  n1i0i :	STD_LOGIC;
	 SIGNAL  n1l0i :	STD_LOGIC;
	 SIGNAL  n1l0l :	STD_LOGIC;
	 SIGNAL  n1lii :	STD_LOGIC;
	 SIGNAL  nlOllO :	STD_LOGIC;
	 SIGNAL  nlOlOi :	STD_LOGIC;
	 SIGNAL  nlOlOl :	STD_LOGIC;
	 SIGNAL  nlOlOO :	STD_LOGIC;
	 SIGNAL  nlOO0i :	STD_LOGIC;
	 SIGNAL  nlOO0l :	STD_LOGIC;
	 SIGNAL  nlOO0O :	STD_LOGIC;
	 SIGNAL  nlOO1i :	STD_LOGIC;
	 SIGNAL  nlOO1l :	STD_LOGIC;
	 SIGNAL  nlOO1O :	STD_LOGIC;
	 SIGNAL  nlOOii :	STD_LOGIC;
	 SIGNAL  nlOOil :	STD_LOGIC;
	 SIGNAL  nlOOiO :	STD_LOGIC;
	 SIGNAL  nlOOli :	STD_LOGIC;
	 SIGNAL  nlOOll :	STD_LOGIC;
	 SIGNAL  nlOOlO :	STD_LOGIC;
	 SIGNAL  nlOOOi :	STD_LOGIC;
	 SIGNAL  nlOOOl :	STD_LOGIC;
	 SIGNAL  nlOOOO :	STD_LOGIC;
	 SIGNAL  wire_w_tx_data_pg_range108w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_tx_data_tc_range66w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_tx_data_tc_range58w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_lg_w26w29w30w(0) <= wire_w_lg_w26w29w(0) AND nlOOO;
	wire_w_lg_w26w29w(0) <= wire_w26w(0) AND wire_n1iiO12_w_lg_q28w(0);
	wire_w_lg_w16w17w(0) <= wire_w16w(0) AND nlOOO;
	wire_w_lg_w48w49w(0) <= wire_w48w(0) AND nlOOO;
	wire_w26w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w21w22w25w(0) AND wire_w_lg_tx_ctl_tc12w(0);
	wire_w16w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w10w11w13w(0) AND wire_n1iOO6_w_lg_q15w(0);
	wire_w48w(0) <= wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w44w45w(0) AND wire_n10OO20_w_lg_q47w(0);
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w21w22w25w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w21w22w(0) AND wire_n1ill10_w_lg_q24w(0);
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w10w11w13w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w10w11w(0) AND wire_w_lg_tx_ctl_tc12w(0);
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w36w37w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w36w(0) AND nlOOO;
	wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w44w45w(0) <= wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w44w(0) AND wire_w_lg_tx_ctl_tc12w(0);
	wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w21w22w(0) <= wire_w_lg_w_lg_w_lg_n1l0l5w7w21w(0) AND GE_XAUI_SEL;
	wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w10w11w(0) <= wire_w_lg_w_lg_w_lg_n1l0l5w7w10w(0) AND GE_XAUI_SEL;
	wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w36w(0) <= wire_w_lg_w_lg_w_lg_n1l0l5w7w35w(0) AND wire_w_lg_tx_ctl_tc12w(0);
	wire_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w44w(0) <= wire_w_lg_w_lg_w_lg_n1l0l5w7w35w(0) AND wire_n1i1l18_w_lg_q43w(0);
	wire_w_lg_w_lg_w_lg_IB_FORCE_DISPARITY67w69w72w(0) <= wire_w_lg_w_lg_IB_FORCE_DISPARITY67w69w(0) AND wire_n10lO22_w_lg_q71w(0);
	wire_w_lg_w_lg_w_lg_n1l0l5w7w21w(0) <= wire_w_lg_w_lg_n1l0l5w7w(0) AND wire_n1iOi8_w_lg_q20w(0);
	wire_w_lg_w_lg_w_lg_n1l0l5w7w10w(0) <= wire_w_lg_w_lg_n1l0l5w7w(0) AND wire_n1l1l4_w_lg_q9w(0);
	wire_w_lg_w_lg_w_lg_n1l0l5w7w35w(0) <= wire_w_lg_w_lg_n1l0l5w7w(0) AND GE_XAUI_SEL;
	wire_w_lg_w_lg_w_lg_nlOO0l329w331w332w(0) <= wire_w_lg_w_lg_nlOO0l329w331w(0) AND nlOOil;
	wire_w_lg_w_lg_IB_FORCE_DISPARITY67w69w(0) <= wire_w_lg_IB_FORCE_DISPARITY67w(0) AND wire_nlOOi_w_lg_nlOOl68w(0);
	wire_w_lg_w_lg_n1l0l5w7w(0) <= wire_w_lg_n1l0l5w(0) AND wire_w_lg_n1l0i6w(0);
	wire_w_lg_w_lg_nlOO0l329w331w(0) <= wire_w_lg_nlOO0l329w(0) AND wire_w_lg_nlOO0O330w(0);
	wire_w_lg_IB_FORCE_DISPARITY67w(0) <= IB_FORCE_DISPARITY AND tx_data_9_tc;
	wire_w_lg_tx_ctl_tc241w(0) <= tx_ctl_tc AND wire_w_lg_w_tx_data_tc_range66w228w(0);
	wire_w_lg_ENDEC251w(0) <= NOT ENDEC;
	wire_w_lg_n10iO345w(0) <= NOT n10iO;
	wire_w_lg_n110O254w(0) <= NOT n110O;
	wire_w_lg_n11Oi92w(0) <= NOT n11Oi;
	wire_w_lg_n1l0i6w(0) <= NOT n1l0i;
	wire_w_lg_n1l0l5w(0) <= NOT n1l0l;
	wire_w_lg_nlOO0i354w(0) <= NOT nlOO0i;
	wire_w_lg_nlOO0l329w(0) <= NOT nlOO0l;
	wire_w_lg_nlOO0O330w(0) <= NOT nlOO0O;
	wire_w_lg_nlOOii355w(0) <= NOT nlOOii;
	wire_w_lg_prbs_en249w(0) <= NOT prbs_en;
	wire_w_lg_soft_reset2w(0) <= NOT soft_reset;
	wire_w_lg_tx_ctl_tc12w(0) <= NOT tx_ctl_tc;
	wire_w_lg_w_tx_data_tc_range66w228w(0) <= NOT wire_w_tx_data_tc_range66w(0);
	wire_w_lg_w_lg_nlOOOi349w350w(0) <= wire_w_lg_nlOOOi349w(0) OR nlOO1l;
	wire_w_lg_nlOO1O351w(0) <= nlOO1O OR wire_w_lg_w_lg_nlOOOi349w350w(0);
	wire_w_lg_nlOOOi349w(0) <= nlOOOi OR wire_niiO_w_lg_w_lg_dataout286w348w(0);
	n101i <= (wire_w_lg_ENDEC251w(0) AND wire_w_lg_prbs_en249w(0));
	n101l <= (ENDEC AND wire_w_lg_prbs_en249w(0));
	n10il <= (((((((wire_w_lg_tx_ctl_tc241w(0) AND (NOT tx_data_tc(1))) AND tx_data_tc(2)) AND tx_data_tc(3)) AND tx_data_tc(4)) AND tx_data_tc(5)) AND (NOT tx_data_tc(6))) AND tx_data_tc(7));
	n10iO <= (wire_nl_w_lg_nO73w(0) OR (NOT (n10li24 XOR n10li23)));
	n10Ol <= (wire_nl_w_lg_nO4w(0) AND wire_w_lg_w48w49w(0));
	n110i <= (wire_n0i0l_w_lg_w_lg_w_lg_dataout253w256w257w(0) XOR wire_n0i0l_w_lg_w_lg_dataout253w258w(0));
	n110l <= (wire_nill_dataout AND wire_nili_dataout);
	n110O <= (n110l OR n111l);
	n111i <= (wire_nilO_w_lg_dataout261w(0) AND n111l);
	n111l <= (wire_nill_w_lg_dataout265w(0) AND wire_nili_w_lg_dataout312w(0));
	n111O <= (wire_nilO_dataout AND (wire_nill_dataout AND (wire_nili_dataout AND (((wire_n0i0l_w_lg_dataout253w(0) AND (wire_niiO_w_lg_dataout267w(0) AND ((((wire_niil_w_lg_dataout266w(0) AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_w_lg_dataout269w270w(0))) OR (wire_niil_w_lg_dataout266w(0) AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_dataout274w(0)))) OR (wire_niil_w_lg_dataout266w(0) AND (wire_niii_dataout AND nlOOOO))) OR wire_niil_w_lg_dataout282w(0)))) OR wire_n0i0l_w_lg_dataout300w(0)) OR wire_nilO_w_lg_dataout304w(0)))));
	n11Oi <= ((n101l OR n101i) OR (NOT (n11Ol32 XOR n11Ol31)));
	n1i0i <= (nO AND (wire_w_lg_w_lg_w_lg_w_lg_w_lg_n1l0l5w7w35w36w37w(0) AND (n1i0l16 XOR n1i0l15)));
	n1l0i <= ((((((((wire_w_lg_tx_ctl_tc12w(0) AND wire_w_lg_w_tx_data_tc_range66w228w(0)) AND tx_data_tc(1)) AND (NOT tx_data_tc(2))) AND (NOT tx_data_tc(3))) AND (NOT tx_data_tc(4))) AND (NOT tx_data_tc(5))) AND tx_data_tc(6)) AND (NOT tx_data_tc(7)));
	n1l0l <= ((((((((wire_w_lg_tx_ctl_tc12w(0) AND tx_data_tc(0)) AND (NOT tx_data_tc(1))) AND tx_data_tc(2)) AND (NOT tx_data_tc(3))) AND tx_data_tc(4)) AND tx_data_tc(5)) AND (NOT tx_data_tc(6))) AND tx_data_tc(7));
	n1lii <= '1';
	nlOllO <= wire_ni0O_w_lg_dataout316w(0);
	nlOlOi <= wire_ni0O_w_lg_w_lg_dataout269w315w(0);
	nlOlOl <= wire_ni0O_w_lg_dataout274w(0);
	nlOlOO <= wire_ni0O_w_lg_w_lg_dataout269w270w(0);
	nlOO0i <= (wire_n1l_w_lg_w_lg_dataout327w328w(0) OR wire_niiO_w_lg_dataout333w(0));
	nlOO0l <= ((((wire_niil_w_lg_dataout266w(0) AND (wire_niii_dataout AND nlOllO)) OR wire_niil_w_lg_dataout395w(0)) OR wire_niil_w_lg_dataout294w(0)) OR wire_niil_w_lg_dataout297w(0));
	nlOO0O <= ((((((wire_niil_w_lg_dataout266w(0) AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_dataout316w(0))) OR (wire_niil_w_lg_dataout266w(0) AND (wire_niii_dataout AND nlOlOO))) OR (wire_niil_w_lg_dataout266w(0) AND (wire_niii_dataout AND nlOlOl))) OR wire_niil_w_lg_dataout378w(0)) OR wire_niil_w_lg_dataout381w(0)) OR wire_niil_w_lg_dataout384w(0));
	nlOO1i <= (wire_niil_w_lg_w343w344w(0) XOR (wire_w_lg_n10iO345w(0) AND wire_w_lg_nlOO1O351w(0)));
	nlOO1l <= (wire_niiO_dataout AND ((wire_niil_dataout AND nlOOli) OR nlOO0l));
	nlOO1O <= (wire_n1l_dataout AND nlOO0O);
	nlOOii <= (nlOOiO OR (wire_niiO_dataout AND nlOOil));
	nlOOil <= (wire_niil_w_lg_dataout266w(0) OR wire_niii_w_lg_dataout325w(0));
	nlOOiO <= (wire_niiO_w_lg_dataout286w(0) AND nlOOli);
	nlOOli <= ((((wire_niil_w_lg_dataout266w(0) AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_w_lg_dataout269w270w(0))) OR (wire_niil_w_lg_dataout266w(0) AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_dataout274w(0)))) OR (wire_niil_w_lg_dataout266w(0) AND (wire_niii_dataout AND nlOlOi))) OR wire_niil_w_lg_dataout390w(0));
	nlOOll <= (wire_niil_dataout AND wire_niii_w_lg_dataout336w(0));
	nlOOlO <= (wire_niil_w_lg_dataout266w(0) AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_w_lg_dataout269w315w(0)));
	nlOOOi <= (nlOOll OR nlOOlO);
	nlOOOl <= wire_ni0O_w_lg_dataout316w(0);
	nlOOOO <= wire_ni0O_w_lg_w_lg_dataout269w315w(0);
	PUDR <= ( wire_nlOll_o & wire_nlOli_o & wire_nlOiO_o & wire_nlOil_o & wire_nlOii_o & wire_nlO0O_o & wire_nlO0l_o & wire_nlO0i_o & wire_nlO1O_o & wire_nlO1l_o);
	TXLP10B <= ( n0il & n0ii & n00O & n00l & n00i & n01O & n01l & n01i & n1OO & n1lO);
	wire_w_tx_data_pg_range108w(0) <= tx_data_pg(8);
	wire_w_tx_data_tc_range66w(0) <= tx_data_tc(0);
	wire_w_tx_data_tc_range58w(0) <= tx_data_tc(4);
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n100l27 <= n100l28;
		END IF;
		if (now = 0 ns) then
			n100l27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n100l28 <= n100l27;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n101O29 <= n101O30;
		END IF;
		if (now = 0 ns) then
			n101O29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n101O30 <= n101O29;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10ii25 <= n10ii26;
		END IF;
		if (now = 0 ns) then
			n10ii25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10ii26 <= n10ii25;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10li23 <= n10li24;
		END IF;
		if (now = 0 ns) then
			n10li23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10li24 <= n10li23;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10lO21 <= n10lO22;
		END IF;
		if (now = 0 ns) then
			n10lO21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10lO22 <= n10lO21;
		END IF;
	END PROCESS;
	wire_n10lO22_w_lg_q71w(0) <= n10lO22 XOR n10lO21;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10OO19 <= n10OO20;
		END IF;
		if (now = 0 ns) then
			n10OO19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n10OO20 <= n10OO19;
		END IF;
	END PROCESS;
	wire_n10OO20_w_lg_q47w(0) <= n10OO20 XOR n10OO19;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11ii43 <= n11ii44;
		END IF;
		if (now = 0 ns) then
			n11ii43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11ii44 <= n11ii43;
		END IF;
	END PROCESS;
	wire_n11ii44_w_lg_w_lg_q155w156w(0) <= wire_n11ii44_w_lg_q155w(0) AND wire_w_tx_data_tc_range58w(0);
	wire_n11ii44_w_lg_q155w(0) <= n11ii44 XOR n11ii43;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11il41 <= n11il42;
		END IF;
		if (now = 0 ns) then
			n11il41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11il42 <= n11il41;
		END IF;
	END PROCESS;
	wire_n11il42_w_lg_w_lg_q131w132w(0) <= wire_n11il42_w_lg_q131w(0) AND n101l;
	wire_n11il42_w_lg_q131w(0) <= n11il42 XOR n11il41;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11iO39 <= n11iO40;
		END IF;
		if (now = 0 ns) then
			n11iO39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11iO40 <= n11iO39;
		END IF;
	END PROCESS;
	wire_n11iO40_w_lg_w_lg_q125w126w(0) <= wire_n11iO40_w_lg_q125w(0) AND n1il;
	wire_n11iO40_w_lg_q125w(0) <= n11iO40 XOR n11iO39;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11li37 <= n11li38;
		END IF;
		if (now = 0 ns) then
			n11li37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11li38 <= n11li37;
		END IF;
	END PROCESS;
	wire_n11li38_w_lg_w_lg_q113w114w(0) <= wire_n11li38_w_lg_q113w(0) AND tx_ctl_tc;
	wire_n11li38_w_lg_q113w(0) <= n11li38 XOR n11li37;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11ll35 <= n11ll36;
		END IF;
		if (now = 0 ns) then
			n11ll35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11ll36 <= n11ll35;
		END IF;
	END PROCESS;
	wire_n11ll36_w_lg_w_lg_q109w110w(0) <= wire_n11ll36_w_lg_q109w(0) AND wire_w_tx_data_pg_range108w(0);
	wire_n11ll36_w_lg_q109w(0) <= n11ll36 XOR n11ll35;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11lO33 <= n11lO34;
		END IF;
		if (now = 0 ns) then
			n11lO33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11lO34 <= n11lO33;
		END IF;
	END PROCESS;
	wire_n11lO34_w_lg_w_lg_q95w96w(0) <= wire_n11lO34_w_lg_q95w(0) AND n101i;
	wire_n11lO34_w_lg_q95w(0) <= n11lO34 XOR n11lO33;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11Ol31 <= n11Ol32;
		END IF;
		if (now = 0 ns) then
			n11Ol31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n11Ol32 <= n11Ol31;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1i0l15 <= n1i0l16;
		END IF;
		if (now = 0 ns) then
			n1i0l15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1i0l16 <= n1i0l15;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1i1l17 <= n1i1l18;
		END IF;
		if (now = 0 ns) then
			n1i1l17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1i1l18 <= n1i1l17;
		END IF;
	END PROCESS;
	wire_n1i1l18_w_lg_q43w(0) <= n1i1l18 XOR n1i1l17;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iii13 <= n1iii14;
		END IF;
		if (now = 0 ns) then
			n1iii13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iii14 <= n1iii13;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iiO11 <= n1iiO12;
		END IF;
		if (now = 0 ns) then
			n1iiO11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iiO12 <= n1iiO11;
		END IF;
	END PROCESS;
	wire_n1iiO12_w_lg_q28w(0) <= n1iiO12 XOR n1iiO11;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1ill10 <= n1ill9;
		END IF;
	END PROCESS;
	wire_n1ill10_w_lg_q24w(0) <= n1ill10 XOR n1ill9;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1ill9 <= n1ill10;
		END IF;
		if (now = 0 ns) then
			n1ill9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iOi7 <= n1iOi8;
		END IF;
		if (now = 0 ns) then
			n1iOi7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iOi8 <= n1iOi7;
		END IF;
	END PROCESS;
	wire_n1iOi8_w_lg_q20w(0) <= n1iOi8 XOR n1iOi7;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iOO5 <= n1iOO6;
		END IF;
		if (now = 0 ns) then
			n1iOO5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1iOO6 <= n1iOO5;
		END IF;
	END PROCESS;
	wire_n1iOO6_w_lg_q15w(0) <= n1iOO6 XOR n1iOO5;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1l1l3 <= n1l1l4;
		END IF;
		if (now = 0 ns) then
			n1l1l3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1l1l4 <= n1l1l3;
		END IF;
	END PROCESS;
	wire_n1l1l4_w_lg_q9w(0) <= n1l1l4 XOR n1l1l3;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1liO1 <= n1liO2;
		END IF;
		if (now = 0 ns) then
			n1liO1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN n1liO2 <= n1liO1;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, soft_reset)
	BEGIN
		IF (soft_reset = '1') THEN
				n10i <= '1';
				n10l <= '1';
				n10O <= '1';
				n11O <= '1';
				n1ii <= '1';
				n1li <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
				n10i <= wire_n0lil_dataout;
				n10l <= wire_n0liO_dataout;
				n10O <= wire_n0lli_dataout;
				n11O <= wire_n0lii_dataout;
				n1ii <= wire_niOii_dataout;
				n1li <= wire_niOiO_dataout;
		END IF;
		if (now = 0 ns) then
			n10i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1li <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk, wire_nl_CLRN)
	BEGIN
		IF (wire_nl_CLRN = '0') THEN
				n00i <= '0';
				n00l <= '0';
				n00O <= '0';
				n01i <= '0';
				n01l <= '0';
				n01O <= '0';
				n0ii <= '0';
				n0il <= '0';
				n11i <= '0';
				n11l <= '0';
				n1il <= '0';
				n1ll <= '0';
				n1lO <= '0';
				n1OO <= '0';
				nlOOO <= '0';
				nO <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
				n00i <= wire_nlOii_o;
				n00l <= wire_nlOil_o;
				n00O <= wire_nlOiO_o;
				n01i <= wire_nlO0i_o;
				n01l <= wire_nlO0l_o;
				n01O <= wire_nlO0O_o;
				n0ii <= wire_nlOli_o;
				n0il <= wire_nlOll_o;
				n11i <= wire_n0l0l_dataout;
				n11l <= wire_n0l0O_dataout;
				n1il <= wire_niOil_dataout;
				n1ll <= wire_niOli_dataout;
				n1lO <= wire_nlO1l_o;
				n1OO <= wire_nlO1O_o;
				nlOOO <= n10il;
				nO <= wire_nilll_dataout;
		END IF;
	END PROCESS;
	wire_nl_CLRN <= ((n1liO2 XOR n1liO1) AND wire_w_lg_soft_reset2w(0));
	wire_nl_w_lg_nO31w(0) <= nO AND wire_w_lg_w_lg_w26w29w30w(0);
	wire_nl_w_lg_nO4w(0) <= NOT nO;
	wire_nl_w_lg_nO73w(0) <= nO OR wire_w_lg_w_lg_w_lg_IB_FORCE_DISPARITY67w69w72w(0);
	PROCESS (tx_clk, wire_nlOOi_CLRN)
	BEGIN
		IF (wire_nlOOi_CLRN = '0') THEN
				nlOOl <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
			IF (wire_nlOOi_ENA = '1') THEN
				nlOOl <= n1lii;
			END IF;
		END IF;
	END PROCESS;
	wire_nlOOi_CLRN <= ((n10ii26 XOR n10ii25) AND wire_w_lg_soft_reset2w(0));
	wire_nlOOi_ENA <= (((wire_w_lg_IB_FORCE_DISPARITY67w(0) AND (n100l28 XOR n100l27)) AND wire_nlOOi_w_lg_nlOOl68w(0)) AND (n101O30 XOR n101O29));
	wire_nlOOi_w_lg_nlOOl68w(0) <= NOT nlOOl;
	wire_n0i0l_dataout <= wire_w_lg_n10iO345w(0) WHEN ((nlOOiO OR ((wire_n1l_dataout OR nlOOlO) OR nlOOll)) OR nlOO1l) = '1'  ELSE n10iO;
	wire_n0i0l_w_lg_w_lg_dataout253w256w(0) <= wire_n0i0l_w_lg_dataout253w(0) AND wire_n1l_w_lg_dataout255w(0);
	wire_n0i0l_w_lg_w_lg_dataout253w258w(0) <= wire_n0i0l_w_lg_dataout253w(0) AND n110O;
	wire_n0i0l_w_lg_dataout300w(0) <= wire_n0i0l_dataout AND wire_niiO_w_lg_w_lg_w_lg_dataout286w287w299w(0);
	wire_n0i0l_w_lg_dataout253w(0) <= NOT wire_n0i0l_dataout;
	wire_n0i0l_w_lg_w_lg_w_lg_dataout253w256w257w(0) <= wire_n0i0l_w_lg_w_lg_dataout253w256w(0) OR n110l;
	wire_n0l0l_dataout <= wire_ni0l_w_lg_dataout273w(0) WHEN nlOO1i = '1'  ELSE wire_ni0l_dataout;
	wire_n0l0O_dataout <= wire_ni1Oi_w_lg_dataout358w(0) WHEN nlOO1i = '1'  ELSE wire_ni1Oi_dataout;
	wire_n0lii_dataout <= wire_ni1ii_w_lg_dataout357w(0) WHEN nlOO1i = '1'  ELSE wire_ni1ii_dataout;
	wire_n0lil_dataout <= wire_ni10O_w_lg_dataout356w(0) WHEN nlOO1i = '1'  ELSE wire_ni10O_dataout;
	wire_n0liO_dataout <= wire_w_lg_nlOOii355w(0) WHEN nlOO1i = '1'  ELSE nlOOii;
	wire_n0lli_dataout <= wire_w_lg_nlOO0i354w(0) WHEN nlOO1i = '1'  ELSE nlOO0i;
	wire_n0lO_dataout <= tx_data_tc(0) WHEN INDV = '1'  ELSE tx_data_ts(0);
	wire_n0Oi_dataout <= tx_data_tc(1) WHEN INDV = '1'  ELSE tx_data_ts(1);
	wire_n0Ol_dataout <= tx_data_tc(2) WHEN INDV = '1'  ELSE tx_data_ts(2);
	wire_n0OO_dataout <= tx_data_tc(3) WHEN INDV = '1'  ELSE tx_data_ts(3);
	wire_n1i_dataout <= tx_ctl_tc WHEN INDV = '1'  ELSE tx_ctl_ts;
	wire_n1l_dataout <= wire_n1O_dataout AND NOT((wire_nl_w_lg_nO31w(0) AND (n1iii14 XOR n1iii13)));
	wire_n1l_w_lg_w_lg_dataout327w328w(0) <= wire_n1l_w_lg_dataout327w(0) AND nlOO0O;
	wire_n1l_w_lg_dataout255w(0) <= wire_n1l_dataout AND wire_w_lg_n110O254w(0);
	wire_n1l_w_lg_dataout302w(0) <= wire_n1l_dataout AND wire_nili_dataout;
	wire_n1l_w_lg_dataout327w(0) <= wire_n1l_dataout OR wire_niiO_w_lg_dataout286w(0);
	wire_n1O_dataout <= wire_n1i_dataout AND NOT((wire_nl_w_lg_nO4w(0) AND wire_w_lg_w16w17w(0)));
	wire_ni0i_dataout <= tx_data_tc(7) WHEN INDV = '1'  ELSE tx_data_ts(7);
	wire_ni0l_dataout <= wire_niOi_dataout AND NOT(n1i0i);
	wire_ni0l_w_lg_dataout273w(0) <= NOT wire_ni0l_dataout;
	wire_ni0O_dataout <= wire_niOl_dataout AND NOT(n1i0i);
	wire_ni0O_w_lg_w_lg_dataout269w315w(0) <= wire_ni0O_w_lg_dataout269w(0) AND wire_ni0l_w_lg_dataout273w(0);
	wire_ni0O_w_lg_w_lg_dataout269w270w(0) <= wire_ni0O_w_lg_dataout269w(0) AND wire_ni0l_dataout;
	wire_ni0O_w_lg_dataout274w(0) <= wire_ni0O_dataout AND wire_ni0l_w_lg_dataout273w(0);
	wire_ni0O_w_lg_dataout316w(0) <= wire_ni0O_dataout AND wire_ni0l_dataout;
	wire_ni0O_w_lg_dataout269w(0) <= NOT wire_ni0O_dataout;
	wire_ni0O_w_lg_dataout324w(0) <= wire_ni0O_dataout OR wire_ni0l_dataout;
	wire_ni10O_dataout <= wire_niil_w_lg_dataout266w(0) WHEN nlOOll = '1'  ELSE wire_niil_dataout;
	wire_ni10O_w_lg_dataout356w(0) <= NOT wire_ni10O_dataout;
	wire_ni1i_dataout <= tx_data_tc(4) WHEN INDV = '1'  ELSE tx_data_ts(4);
	wire_ni1ii_dataout <= wire_niii_w_lg_dataout268w(0) WHEN ((wire_niiO_dataout AND (wire_niil_dataout AND (wire_niii_w_lg_dataout268w(0) AND wire_ni0O_w_lg_w_lg_dataout269w315w(0)))) OR nlOOlO) = '1'  ELSE wire_niii_dataout;
	wire_ni1ii_w_lg_dataout357w(0) <= NOT wire_ni1ii_dataout;
	wire_ni1l_dataout <= tx_data_tc(5) WHEN INDV = '1'  ELSE tx_data_ts(5);
	wire_ni1O_dataout <= tx_data_tc(6) WHEN INDV = '1'  ELSE tx_data_ts(6);
	wire_ni1Oi_dataout <= wire_ni0O_w_lg_dataout269w(0) WHEN nlOOOi = '1'  ELSE wire_ni0O_dataout;
	wire_ni1Oi_w_lg_dataout358w(0) <= NOT wire_ni1Oi_dataout;
	wire_niii_dataout <= wire_niOO_dataout AND NOT(n1i0i);
	wire_niii_w_lg_w_lg_dataout268w394w(0) <= wire_niii_w_lg_dataout268w(0) AND nlOllO;
	wire_niii_w_lg_w_lg_dataout268w389w(0) <= wire_niii_w_lg_dataout268w(0) AND nlOlOi;
	wire_niii_w_lg_w_lg_dataout268w380w(0) <= wire_niii_w_lg_dataout268w(0) AND nlOlOl;
	wire_niii_w_lg_w_lg_dataout268w377w(0) <= wire_niii_w_lg_dataout268w(0) AND nlOlOO;
	wire_niii_w_lg_w_lg_dataout268w290w(0) <= wire_niii_w_lg_dataout268w(0) AND nlOOOl;
	wire_niii_w_lg_w_lg_dataout268w281w(0) <= wire_niii_w_lg_dataout268w(0) AND nlOOOO;
	wire_niii_w_lg_dataout383w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout269w315w(0);
	wire_niii_w_lg_dataout293w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_w_lg_dataout269w270w(0);
	wire_niii_w_lg_dataout296w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_dataout274w(0);
	wire_niii_w_lg_dataout336w(0) <= wire_niii_dataout AND wire_ni0O_w_lg_dataout316w(0);
	wire_niii_w_lg_dataout288w(0) <= wire_niii_dataout AND nlOOOl;
	wire_niii_w_lg_dataout268w(0) <= NOT wire_niii_dataout;
	wire_niii_w_lg_dataout325w(0) <= wire_niii_dataout OR wire_ni0O_w_lg_dataout324w(0);
	wire_niil_dataout <= wire_nl1i_dataout AND NOT(n1i0i);
	wire_niil_w_lg_w_lg_dataout266w337w(0) <= wire_niil_w_lg_dataout266w(0) AND wire_niii_w_lg_dataout336w(0);
	wire_niil_w_lg_w_lg_dataout266w289w(0) <= wire_niil_w_lg_dataout266w(0) AND wire_niii_w_lg_dataout288w(0);
	wire_niil_w_lg_w_lg_dataout266w346w(0) <= wire_niil_w_lg_dataout266w(0) AND nlOO0l;
	wire_niil_w_lg_dataout395w(0) <= wire_niil_dataout AND wire_niii_w_lg_w_lg_dataout268w394w(0);
	wire_niil_w_lg_dataout390w(0) <= wire_niil_dataout AND wire_niii_w_lg_w_lg_dataout268w389w(0);
	wire_niil_w_lg_dataout381w(0) <= wire_niil_dataout AND wire_niii_w_lg_w_lg_dataout268w380w(0);
	wire_niil_w_lg_dataout378w(0) <= wire_niil_dataout AND wire_niii_w_lg_w_lg_dataout268w377w(0);
	wire_niil_w_lg_dataout291w(0) <= wire_niil_dataout AND wire_niii_w_lg_w_lg_dataout268w290w(0);
	wire_niil_w_lg_dataout282w(0) <= wire_niil_dataout AND wire_niii_w_lg_w_lg_dataout268w281w(0);
	wire_niil_w_lg_dataout384w(0) <= wire_niil_dataout AND wire_niii_w_lg_dataout383w(0);
	wire_niil_w_lg_dataout294w(0) <= wire_niil_dataout AND wire_niii_w_lg_dataout293w(0);
	wire_niil_w_lg_dataout297w(0) <= wire_niil_dataout AND wire_niii_w_lg_dataout296w(0);
	wire_niil_w_lg_dataout266w(0) <= NOT wire_niil_dataout;
	wire_niil_w_lg_w_lg_w_lg_dataout266w337w339w(0) <= wire_niil_w_lg_w_lg_dataout266w337w(0) OR wire_niiO_w_lg_dataout338w(0);
	wire_niil_w_lg_w_lg_w_lg_dataout266w289w292w(0) <= wire_niil_w_lg_w_lg_dataout266w289w(0) OR wire_niil_w_lg_dataout291w(0);
	wire_niil_w_lg_w_lg_w_lg_dataout266w346w347w(0) <= wire_niil_w_lg_w_lg_dataout266w346w(0) OR nlOOli;
	wire_niil_w_lg_w_lg_w_lg_w_lg_dataout266w337w339w341w(0) <= wire_niil_w_lg_w_lg_w_lg_dataout266w337w339w(0) OR wire_niiO_w_lg_dataout340w(0);
	wire_niil_w_lg_w_lg_w_lg_w_lg_dataout266w289w292w295w(0) <= wire_niil_w_lg_w_lg_w_lg_dataout266w289w292w(0) OR wire_niil_w_lg_dataout294w(0);
	wire_niil_w343w(0) <= wire_niil_w_lg_w_lg_w_lg_w_lg_dataout266w337w339w341w(0) OR wire_niiO_w_lg_dataout342w(0);
	wire_niil_w298w(0) <= wire_niil_w_lg_w_lg_w_lg_w_lg_dataout266w289w292w295w(0) OR wire_niil_w_lg_dataout297w(0);
	wire_niil_w_lg_w343w344w(0) <= wire_niil_w343w(0) OR nlOO1O;
	wire_niiO_dataout <= wire_nl1l_dataout OR n1i0i;
	wire_niiO_w_lg_w_lg_w_lg_dataout286w287w299w(0) <= wire_niiO_w_lg_w_lg_dataout286w287w(0) AND wire_niil_w298w(0);
	wire_niiO_w_lg_w_lg_dataout286w348w(0) <= wire_niiO_w_lg_dataout286w(0) AND wire_niil_w_lg_w_lg_w_lg_dataout266w346w347w(0);
	wire_niiO_w_lg_w_lg_dataout286w287w(0) <= wire_niiO_w_lg_dataout286w(0) AND wire_niil_dataout;
	wire_niiO_w_lg_dataout333w(0) <= wire_niiO_dataout AND wire_w_lg_w_lg_w_lg_nlOO0l329w331w332w(0);
	wire_niiO_w_lg_dataout267w(0) <= wire_niiO_dataout AND wire_niil_w_lg_dataout266w(0);
	wire_niiO_w_lg_dataout342w(0) <= wire_niiO_dataout AND nlOO0l;
	wire_niiO_w_lg_dataout340w(0) <= wire_niiO_dataout AND nlOOll;
	wire_niiO_w_lg_dataout338w(0) <= wire_niiO_dataout AND nlOOlO;
	wire_niiO_w_lg_dataout286w(0) <= NOT wire_niiO_dataout;
	wire_nili_dataout <= wire_nl1O_dataout AND NOT(n1i0i);
	wire_nili_w_lg_dataout312w(0) <= NOT wire_nili_dataout;
	wire_nill_dataout <= wire_nl0i_dataout OR n1i0i;
	wire_nill_w_lg_dataout303w(0) <= wire_nill_dataout AND wire_n1l_w_lg_dataout302w(0);
	wire_nill_w_lg_dataout265w(0) <= NOT wire_nill_dataout;
	wire_nilll_dataout <= wire_n0i0l_w_lg_dataout253w(0) WHEN (n111i OR (wire_nilO_dataout AND n110O)) = '1'  ELSE wire_n0i0l_dataout;
	wire_nilO_dataout <= wire_nl0l_dataout AND NOT(n1i0i);
	wire_nilO_w_lg_dataout304w(0) <= wire_nilO_dataout AND wire_nill_w_lg_dataout303w(0);
	wire_nilO_w_lg_dataout261w(0) <= NOT wire_nilO_dataout;
	wire_nilOl_dataout <= wire_nilOO_dataout OR n111O;
	wire_nilOl_w_lg_dataout260w(0) <= NOT wire_nilOl_dataout;
	wire_nilOO_dataout <= wire_w_lg_n110O254w(0) AND NOT(wire_nilO_dataout);
	wire_niO0i_dataout <= wire_nill_w_lg_dataout265w(0) WHEN n111i = '1'  ELSE wire_nill_dataout;
	wire_niO0i_w_lg_dataout262w(0) <= NOT wire_niO0i_dataout;
	wire_niO0O_dataout <= wire_nili_dataout AND NOT(n111O);
	wire_niO0O_w_lg_dataout263w(0) <= NOT wire_niO0O_dataout;
	wire_niOi_dataout <= wire_n0lO_dataout OR n10Ol;
	wire_niOii_dataout <= wire_niO0O_w_lg_dataout263w(0) WHEN n110i = '1'  ELSE wire_niO0O_dataout;
	wire_niOil_dataout <= wire_niO0i_w_lg_dataout262w(0) WHEN n110i = '1'  ELSE wire_niO0i_dataout;
	wire_niOiO_dataout <= wire_nilO_w_lg_dataout261w(0) WHEN n110i = '1'  ELSE wire_nilO_dataout;
	wire_niOl_dataout <= wire_n0Oi_dataout AND NOT(n10Ol);
	wire_niOli_dataout <= wire_nilOl_w_lg_dataout260w(0) WHEN n110i = '1'  ELSE wire_nilOl_dataout;
	wire_niOO_dataout <= wire_n0Ol_dataout OR n10Ol;
	wire_nl0i_dataout <= wire_ni1O_dataout OR n10Ol;
	wire_nl0l_dataout <= wire_ni0i_dataout OR n10Ol;
	wire_nl1i_dataout <= wire_n0OO_dataout AND NOT(n10Ol);
	wire_nl1l_dataout <= wire_ni1i_dataout AND NOT(n10Ol);
	wire_nl1O_dataout <= wire_ni1l_dataout AND NOT(n10Ol);
	wire_nlO0i_data <= ( n11O & tx_data_tc(2) & tx_data_pg(2));
	wire_nlO0i_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlO0i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlO0i_data,
		o => wire_nlO0i_o,
		sel => wire_nlO0i_sel
	  );
	wire_nlO0l_data <= ( n10i & tx_data_tc(3) & tx_data_pg(3));
	wire_nlO0l_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlO0l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlO0l_data,
		o => wire_nlO0l_o,
		sel => wire_nlO0l_sel
	  );
	wire_nlO0O_data <= ( n10l & wire_n11ii44_w_lg_w_lg_q155w156w & tx_data_pg(4));
	wire_nlO0O_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlO0O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlO0O_data,
		o => wire_nlO0O_o,
		sel => wire_nlO0O_sel
	  );
	wire_nlO1l_data <= ( n11i & tx_data_tc(0) & tx_data_pg(0));
	wire_nlO1l_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlO1l :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlO1l_data,
		o => wire_nlO1l_o,
		sel => wire_nlO1l_sel
	  );
	wire_nlO1O_data <= ( n11l & tx_data_tc(1) & tx_data_pg(1));
	wire_nlO1O_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlO1O :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlO1O_data,
		o => wire_nlO1O_o,
		sel => wire_nlO1O_sel
	  );
	wire_nlOii_data <= ( n10O & tx_data_tc(5) & tx_data_pg(5));
	wire_nlOii_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlOii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOii_data,
		o => wire_nlOii_o,
		sel => wire_nlOii_sel
	  );
	wire_nlOil_data <= ( n1ii & tx_data_tc(6) & tx_data_pg(6));
	wire_nlOil_sel <= ( wire_n11il42_w_lg_w_lg_q131w132w & n101i & wire_w_lg_n11Oi92w);
	nlOil :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOil_data,
		o => wire_nlOil_o,
		sel => wire_nlOil_sel
	  );
	wire_nlOiO_data <= ( wire_n11iO40_w_lg_w_lg_q125w126w & tx_data_tc(7) & tx_data_pg(7));
	wire_nlOiO_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlOiO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOiO_data,
		o => wire_nlOiO_o,
		sel => wire_nlOiO_sel
	  );
	wire_nlOli_data <= ( n1li & wire_n11li38_w_lg_w_lg_q113w114w & wire_n11ll36_w_lg_w_lg_q109w110w);
	wire_nlOli_sel <= ( n101l & n101i & wire_w_lg_n11Oi92w);
	nlOli :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOli_data,
		o => wire_nlOli_o,
		sel => wire_nlOli_sel
	  );
	wire_nlOll_data <= ( n1ll & tx_data_9_tc & tx_data_pg(9));
	wire_nlOll_sel <= ( n101l & wire_n11lO34_w_lg_w_lg_q95w96w & wire_w_lg_n11Oi92w);
	nlOll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlOll_data,
		o => wire_nlOll_o,
		sel => wire_nlOll_sel
	  );

 END RTL; --stratixgx_hssi_tx_enc_rtl
--synopsys translate_on
--VALID FILE
--/////////////////////////////////////////////////////////////////////////////
--
--                           STRATIXGX_8b10b_ENCODER
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;

ENTITY stratixgx_8b10b_encoder IS
    GENERIC (
        transmit_protocol              :  string := "none";    
        use_8b_10b_mode                :  string := "true";    
        force_disparity_mode           :  string := "false");    
    PORT (
        clk                     : IN std_logic;   
        reset                   : IN std_logic;   
        xgmctrl                 : IN std_logic;   
        kin                     : IN std_logic;   
        xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
        datain                  : IN std_logic_vector(7 DOWNTO 0);   
        forcedisparity          : IN std_logic;   
        dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
        parafbkdataout          : OUT std_logic_vector(9 DOWNTO 0));   
END stratixgx_8b10b_encoder;

ARCHITECTURE auto_translated OF stratixgx_8b10b_encoder IS

    COMPONENT stratixgx_hssi_tx_enc_rtl
        PORT (
            tx_clk                  : IN  std_logic;
            soft_reset              : IN  std_logic;
            INDV                    : IN  std_logic;
            ENDEC                   : IN  std_logic;
            GE_XAUI_SEL             : IN  std_logic;
            IB_FORCE_DISPARITY      : IN  std_logic;
            prbs_en                 : IN  std_logic;
            tx_ctl_ts               : IN  std_logic;
            tx_ctl_tc               : IN  std_logic;
            tx_data_ts              : IN  std_logic_vector(7 DOWNTO 0);
            tx_data_tc              : IN  std_logic_vector(7 DOWNTO 0);
            tx_data_9_tc            : IN  std_logic;
            tx_data_pg              : IN  std_logic_vector(9 DOWNTO 0);
            PUDR                    : OUT std_logic_vector(9 DOWNTO 0);
            TXLP10B                 : OUT std_logic_vector(9 DOWNTO 0));
    END COMPONENT;


    -- CORE MODULE INPUTs
    SIGNAL tx_clk                   :  std_logic;   
    SIGNAL soft_reset               :  std_logic;   
    SIGNAL INDV                     :  std_logic;   
    SIGNAL ENDEC                    :  std_logic;   
    SIGNAL GE_XAUI_SEL              :  std_logic;   
    SIGNAL IB_FORCE_DISPARITY       :  std_logic;   
    SIGNAL prbs_en                  :  std_logic;   
    SIGNAL tx_ctl_ts                :  std_logic;   
    SIGNAL tx_ctl_tc                :  std_logic;   
    SIGNAL tx_data_ts               :  std_logic_vector(7 DOWNTO 0);   
    SIGNAL tx_data_tc               :  std_logic_vector(7 DOWNTO 0);   
    SIGNAL tx_data_9_tc             :  std_logic;   
    SIGNAL tx_data_pg               :  std_logic_vector(9 DOWNTO 0);   
    -- CORE MODULE OUTPUTs
    SIGNAL TXLP10B                  :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL PUDR                     :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL temp_xhdl3               :  std_logic;   
    SIGNAL temp_xhdl4               :  std_logic;   
    SIGNAL temp_xhdl5               :  std_logic;   
    SIGNAL temp_xhdl6               :  std_logic;   
    SIGNAL dataout_xhdl1            :  std_logic_vector(9 DOWNTO 0);   
    SIGNAL parafbkdataout_xhdl2     :  std_logic_vector(9 DOWNTO 0);   

BEGIN
    dataout <= dataout_xhdl1;
    parafbkdataout <= parafbkdataout_xhdl2;
    tx_clk <= clk ;
    soft_reset <= reset ;
    temp_xhdl3 <= '1' WHEN (transmit_protocol /= "xaui") ELSE '0';
    INDV <= temp_xhdl3 ;
    temp_xhdl4 <= '1' WHEN (use_8b_10b_mode = "true") ELSE '0';
    ENDEC <= temp_xhdl4 ;
    temp_xhdl5 <= '1' WHEN (transmit_protocol = "gige") ELSE '0';
    GE_XAUI_SEL <= temp_xhdl5 ;
    temp_xhdl6 <= '1' WHEN (force_disparity_mode = "true") ELSE '0';
    IB_FORCE_DISPARITY <= temp_xhdl6 ;
    prbs_en <= '0' ;
    tx_ctl_ts <= xgmctrl ;
    tx_ctl_tc <= kin ;
    tx_data_ts <= xgmdatain ;
    tx_data_tc <= datain ;
    tx_data_9_tc <= forcedisparity ;
    tx_data_pg <= "0000000000" ;
    dataout_xhdl1 <= PUDR ;
    parafbkdataout_xhdl2 <= TXLP10B ;
    m_enc_core : stratixgx_hssi_tx_enc_rtl 
        PORT MAP (
            tx_clk => tx_clk,
            soft_reset => soft_reset,
            INDV => INDV,
            ENDEC => ENDEC,
            GE_XAUI_SEL => GE_XAUI_SEL,
            IB_FORCE_DISPARITY => IB_FORCE_DISPARITY,
            prbs_en => prbs_en,
            tx_ctl_ts => tx_ctl_ts,
            tx_ctl_tc => tx_ctl_tc,
            tx_data_ts => tx_data_ts,
            tx_data_tc => tx_data_tc,
            tx_data_9_tc => tx_data_9_tc,
            tx_data_pg => tx_data_pg,
            PUDR => PUDR,
            TXLP10B => TXLP10B);   
    

END auto_translated;
--/////////////////////////////////////////////////////////////////////////////
--
--                            DESKEW FIFO RAM MODULE
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratixgx_gxb, std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.std_logic_arith.all; 

ENTITY deskew_ram_block IS
   PORT (
      clk                     : IN std_logic;   
      reset                   : IN std_logic;   
      addrwr                  : IN std_logic_vector(15 DOWNTO 0);   
      addrrd1                 : IN std_logic_vector(15 DOWNTO 0);   
      addrrd2                 : IN std_logic_vector(15 DOWNTO 0);   
      datain                  : IN std_logic_vector(13 DOWNTO 0);   
      we                      : IN std_logic;   
      re                      : IN std_logic;   
      dataout1                : OUT std_logic_vector(13 DOWNTO 0);   
      dataout2                : OUT std_logic_vector(13 DOWNTO 0));   
END deskew_ram_block;

ARCHITECTURE arch_deskew_ram_block OF deskew_ram_block IS

   CONSTANT  read_access_time      :  integer := 0;    
   CONSTANT  write_access_time     :  integer := 0;    
   CONSTANT  ram_width             :  integer := 14;    
   SIGNAL dataout1_i               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL dataout2_i               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_0            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_1            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_2            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_3            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_4            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_5            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_6            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_7            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_8            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_9            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_10           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_11           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_12           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_13           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_14           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_d_15           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_0            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_1            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_2            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_3            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_4            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_5            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_6            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_7            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_8            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_9            :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_10           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_11           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_12           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_13           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_14           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL ram_array_q_15           :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_0               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_1               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_2               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_3               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_4               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_5               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_6               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_7               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_8               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_9               :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_10              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_11              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_12              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_13              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_14              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL data_reg_15              :  std_logic_vector(ram_width - 1 DOWNTO 0);   
   SIGNAL dataout1_tmp1           :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL dataout2_tmp2           :  std_logic_vector(13 DOWNTO 0);   

BEGIN
   dataout1 <= dataout1_tmp1;
   dataout2 <= dataout2_tmp2;
   data_reg_0 <= datain WHEN (addrwr(0) = '1') ELSE ram_array_q_0 ;
   data_reg_1 <= datain WHEN (addrwr(1) = '1') ELSE ram_array_q_1 ;
   data_reg_2 <= datain WHEN (addrwr(2) = '1') ELSE ram_array_q_2 ;
   data_reg_3 <= datain WHEN (addrwr(3) = '1') ELSE ram_array_q_3 ;
   data_reg_4 <= datain WHEN (addrwr(4) = '1') ELSE ram_array_q_4 ;
   data_reg_5 <= datain WHEN (addrwr(5) = '1') ELSE ram_array_q_5 ;
   data_reg_6 <= datain WHEN (addrwr(6) = '1') ELSE ram_array_q_6 ;
   data_reg_7 <= datain WHEN (addrwr(7) = '1') ELSE ram_array_q_7 ;
   data_reg_8 <= datain WHEN (addrwr(8) = '1') ELSE ram_array_q_8 ;
   data_reg_9 <= datain WHEN (addrwr(9) = '1') ELSE ram_array_q_9 ;
   data_reg_10 <= datain WHEN (addrwr(10) = '1') ELSE ram_array_q_10 ;
   data_reg_11 <= datain WHEN (addrwr(11) = '1') ELSE ram_array_q_11 ;
   data_reg_12 <= datain WHEN (addrwr(12) = '1') ELSE ram_array_q_12 ;
   data_reg_13 <= datain WHEN (addrwr(13) = '1') ELSE ram_array_q_13 ;
   data_reg_14 <= datain WHEN (addrwr(14) = '1') ELSE ram_array_q_14 ;
   data_reg_15 <= datain WHEN (addrwr(15) = '1') ELSE ram_array_q_15 ;
   dataout1_tmp1 <= "00000000000000" WHEN re = '1' ELSE dataout1_i after 0 ns;
   dataout2_tmp2 <= "00000000000000" WHEN re = '1' ELSE dataout2_i after 0 ns;

   PROCESS (ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3, ram_array_q_4, ram_array_q_5, ram_array_q_6, ram_array_q_7, ram_array_q_8, ram_array_q_9, ram_array_q_10, ram_array_q_11, ram_array_q_12, ram_array_q_13, ram_array_q_14, ram_array_q_15, addrrd1, addrrd2)
      VARIABLE dataout1_i_tmp3  : std_logic_vector(ram_width - 1 DOWNTO 0);
      VARIABLE dataout2_i_tmp4  : std_logic_vector(ram_width - 1 DOWNTO 0);
   BEGIN
      CASE addrrd1 IS
         WHEN "0000000000000001" =>
                  dataout1_i_tmp3 := ram_array_q_0;    
         WHEN "0000000000000010" =>
                  dataout1_i_tmp3 := ram_array_q_1;    
         WHEN "0000000000000100" =>
                  dataout1_i_tmp3 := ram_array_q_2;    
         WHEN "0000000000001000" =>
                  dataout1_i_tmp3 := ram_array_q_3;    
         WHEN "0000000000010000" =>
                  dataout1_i_tmp3 := ram_array_q_4;    
         WHEN "0000000000100000" =>
                  dataout1_i_tmp3 := ram_array_q_5;    
         WHEN "0000000001000000" =>
                  dataout1_i_tmp3 := ram_array_q_6;    
         WHEN "0000000010000000" =>
                  dataout1_i_tmp3 := ram_array_q_7;    
         WHEN "0000000100000000" =>
                  dataout1_i_tmp3 := ram_array_q_8;    
         WHEN "0000001000000000" =>
                  dataout1_i_tmp3 := ram_array_q_9;    
         WHEN "0000010000000000" =>
                  dataout1_i_tmp3 := ram_array_q_10;    
         WHEN "0000100000000000" =>
                  dataout1_i_tmp3 := ram_array_q_11;    
         WHEN "0001000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_12;    
         WHEN "0010000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_13;    
         WHEN "0100000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_14;    
         WHEN "1000000000000000" =>
                  dataout1_i_tmp3 := ram_array_q_15;    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
      CASE addrrd2 IS
         WHEN "0000000000000001" =>
                  dataout2_i_tmp4 := ram_array_q_0;    
         WHEN "0000000000000010" =>
                  dataout2_i_tmp4 := ram_array_q_1;    
         WHEN "0000000000000100" =>
                  dataout2_i_tmp4 := ram_array_q_2;    
         WHEN "0000000000001000" =>
                  dataout2_i_tmp4 := ram_array_q_3;    
         WHEN "0000000000010000" =>
                  dataout2_i_tmp4 := ram_array_q_4;    
         WHEN "0000000000100000" =>
                  dataout2_i_tmp4 := ram_array_q_5;    
         WHEN "0000000001000000" =>
                  dataout2_i_tmp4 := ram_array_q_6;    
         WHEN "0000000010000000" =>
                  dataout2_i_tmp4 := ram_array_q_7;    
         WHEN "0000000100000000" =>
                  dataout2_i_tmp4 := ram_array_q_8;    
         WHEN "0000001000000000" =>
                  dataout2_i_tmp4 := ram_array_q_9;    
         WHEN "0000010000000000" =>
                  dataout2_i_tmp4 := ram_array_q_10;    
         WHEN "0000100000000000" =>
                  dataout2_i_tmp4 := ram_array_q_11;    
         WHEN "0001000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_12;    
         WHEN "0010000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_13;    
         WHEN "0100000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_14;    
         WHEN "1000000000000000" =>
                  dataout2_i_tmp4 := ram_array_q_15;    
         WHEN OTHERS =>
                  NULL;
         
      END CASE;
      dataout1_i <= dataout1_i_tmp3;
      dataout2_i <= dataout2_i_tmp4;
   END PROCESS;

   PROCESS (clk, reset)
   BEGIN
      IF (reset = '1') THEN
         ram_array_q_0 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_1 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_2 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_3 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_4 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_5 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_6 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_7 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_8 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_9 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_10 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_11 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_12 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_13 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_14 <= "00000000000000" AFTER 0 ns;    
         ram_array_q_15 <= "00000000000000" AFTER 0 ns;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         ram_array_q_0 <= ram_array_d_0 AFTER 0 ns;    
         ram_array_q_1 <= ram_array_d_1 AFTER 0 ns;    
         ram_array_q_2 <= ram_array_d_2 AFTER 0 ns;    
         ram_array_q_3 <= ram_array_d_3 AFTER 0 ns;    
         ram_array_q_4 <= ram_array_d_4 AFTER 0 ns;    
         ram_array_q_5 <= ram_array_d_5 AFTER 0 ns;    
         ram_array_q_6 <= ram_array_d_6 AFTER 0 ns;    
         ram_array_q_7 <= ram_array_d_7 AFTER 0 ns;    
         ram_array_q_8 <= ram_array_d_8 AFTER 0 ns;    
         ram_array_q_9 <= ram_array_d_9 AFTER 0 ns;    
         ram_array_q_10 <= ram_array_d_10 AFTER 0 ns;    
         ram_array_q_11 <= ram_array_d_11 AFTER 0 ns;    
         ram_array_q_12 <= ram_array_d_12 AFTER 0 ns;    
         ram_array_q_13 <= ram_array_d_13 AFTER 0 ns;    
         ram_array_q_14 <= ram_array_d_14 AFTER 0 ns;    
         ram_array_q_15 <= ram_array_d_15 AFTER 0 ns;    
      END IF;
   END PROCESS;

   PROCESS (we, data_reg_0, data_reg_1, data_reg_2, data_reg_3, data_reg_4, data_reg_5, data_reg_6, data_reg_7, data_reg_8, data_reg_9, data_reg_10, data_reg_11, data_reg_12, data_reg_13, data_reg_14, data_reg_15, ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3, ram_array_q_4, ram_array_q_5, ram_array_q_6, ram_array_q_7, ram_array_q_8, ram_array_q_9, ram_array_q_10, ram_array_q_11, ram_array_q_12, ram_array_q_13, ram_array_q_14, ram_array_q_15)
   BEGIN
      IF (we = '1') THEN
         ram_array_d_0 <= data_reg_0 AFTER 0 ns;    
         ram_array_d_1 <= data_reg_1 AFTER 0 ns;    
         ram_array_d_2 <= data_reg_2 AFTER 0 ns;    
         ram_array_d_3 <= data_reg_3 AFTER 0 ns;    
         ram_array_d_4 <= data_reg_4 AFTER 0 ns;    
         ram_array_d_5 <= data_reg_5 AFTER 0 ns;    
         ram_array_d_6 <= data_reg_6 AFTER 0 ns;    
         ram_array_d_7 <= data_reg_7 AFTER 0 ns;    
         ram_array_d_8 <= data_reg_8 AFTER 0 ns;    
         ram_array_d_9 <= data_reg_9 AFTER 0 ns;    
         ram_array_d_10 <= data_reg_10 AFTER 0 ns;    
         ram_array_d_11 <= data_reg_11 AFTER 0 ns;    
         ram_array_d_12 <= data_reg_12 AFTER 0 ns;    
         ram_array_d_13 <= data_reg_13 AFTER 0 ns;    
         ram_array_d_14 <= data_reg_14 AFTER 0 ns;    
         ram_array_d_15 <= data_reg_15 AFTER 0 ns;    
      ELSE
         ram_array_d_0 <= ram_array_q_0 AFTER 0 ns;    
         ram_array_d_1 <= ram_array_q_1 AFTER 0 ns;    
         ram_array_d_2 <= ram_array_q_2 AFTER 0 ns;    
         ram_array_d_3 <= ram_array_q_3 AFTER 0 ns;    
         ram_array_d_4 <= ram_array_q_4 AFTER 0 ns;    
         ram_array_d_5 <= ram_array_q_5 AFTER 0 ns;    
         ram_array_d_6 <= ram_array_q_6 AFTER 0 ns;    
         ram_array_d_7 <= ram_array_q_7 AFTER 0 ns;    
         ram_array_d_8 <= ram_array_q_8 AFTER 0 ns;    
         ram_array_d_9 <= ram_array_q_9 AFTER 0 ns;    
         ram_array_d_10 <= ram_array_q_10 AFTER 0 ns;    
         ram_array_d_11 <= ram_array_q_11 AFTER 0 ns;    
         ram_array_d_12 <= ram_array_q_12 AFTER 0 ns;    
         ram_array_d_13 <= ram_array_q_13 AFTER 0 ns;    
         ram_array_d_14 <= ram_array_q_14 AFTER 0 ns;    
         ram_array_d_15 <= ram_array_q_15 AFTER 0 ns;    
      END IF;
   END PROCESS;

END arch_deskew_ram_block;

--/////////////////////////////////////////////////////////////////////////////
--
--                              STRATIXGX_DESKEW_FIFO
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratixgx_gxb, std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.std_logic_arith.all; 

ENTITY stratixgx_deskew_fifo IS
   PORT (
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      errdetectin             : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disperrin               : IN std_logic;   
      patterndetectin         : IN std_logic;   
      writeclock              : IN std_logic;   
      readclock               : IN std_logic;   
      adetectdeskew           : OUT std_logic;   
      fiforesetrd             : IN std_logic;   
      enabledeskew            : IN std_logic;   
      reset                   : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      dataoutpre              : OUT std_logic_vector(9 DOWNTO 0);   
      errdetect               : OUT std_logic;   
      syncstatus              : OUT std_logic;   
      disperr                 : OUT std_logic;   
      patterndetect           : OUT std_logic;   
      errdetectpre            : OUT std_logic;   
      syncstatuspre           : OUT std_logic;   
      disperrpre              : OUT std_logic;   
      patterndetectpre        : OUT std_logic;   
      rdalign                 : OUT std_logic);   
END stratixgx_deskew_fifo;

ARCHITECTURE arch_stratixgx_deskew_fifo OF stratixgx_deskew_fifo IS

   COMPONENT deskew_ram_block
      PORT (
         clk                     : IN  std_logic;
         reset                   : IN  std_logic;
         addrwr                  : IN  std_logic_vector(15 DOWNTO 0);
         addrrd1                 : IN  std_logic_vector(15 DOWNTO 0);
         addrrd2                 : IN  std_logic_vector(15 DOWNTO 0);
         datain                  : IN  std_logic_vector(13 DOWNTO 0);
         we                      : IN  std_logic;
         re                      : IN  std_logic;
         dataout1                : OUT std_logic_vector(13 DOWNTO 0);
         dataout2                : OUT std_logic_vector(13 DOWNTO 0));
   END COMPONENT;


   CONSTANT  a                     :  std_logic_vector(9 DOWNTO 0) := "0011000011";    
   CONSTANT  FIFO_DEPTH            :  integer := 16;    
   SIGNAL fifo                     :  std_logic_vector(16 * 15 - 1 DOWNTO 0);   
   SIGNAL dataout_tmp              :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL dataout_tmp_pre          :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL dataout_fifo             :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL adetectdeskew_tmp        :  std_logic;   
   SIGNAL errdetect_tmp            :  std_logic;   
   SIGNAL syncstatus_tmp           :  std_logic;   
   SIGNAL disperr_tmp              :  std_logic;   
   SIGNAL errdetect_tmp_pre        :  std_logic;   
   SIGNAL syncstatus_tmp_pre       :  std_logic;   
   SIGNAL disperr_tmp_pre          :  std_logic;   
   SIGNAL patterndetect_tmp        :  std_logic;   
   SIGNAL patterndetect_tmp_pre    :  std_logic;   
   SIGNAL align_count              :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL adetect_deskew           :  std_logic;   
   SIGNAL adetect_deskew_dly       :  std_logic;
   SIGNAL enabledeskew_dly0        :  std_logic;   
   SIGNAL enabledeskew_dly1        :  std_logic;   
   SIGNAL enabledeskew_dly2        :  std_logic;   
   SIGNAL adetectdeskew_dly        :  std_logic;   
   SIGNAL write_enable             :  std_logic;   
   SIGNAL wr_enable                :  std_logic;   
   SIGNAL reset_fifo               :  std_logic;   
   SIGNAL reset_write              :  std_logic;   
   SIGNAL wr_align                 :  std_logic;   
   SIGNAL AUDI_d                   :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL AUDI_pre_d               :  std_logic_vector(13 DOWNTO 0);   
   SIGNAL write_ptr                :  std_logic_vector(FIFO_DEPTH - 1 DOWNTO 0);   
   SIGNAL read_ptr1                :  std_logic_vector(FIFO_DEPTH - 1 DOWNTO 0);   
   SIGNAL read_ptr2                :  std_logic_vector(FIFO_DEPTH - 1 DOWNTO 0);   
   -- WRITE ENABLE LOGIC
   SIGNAL tmp_23                  :  std_logic_vector(13 DOWNTO 0);   
   -- active low
   -- active high
   SIGNAL port_tmp24              :  std_logic;   
   SIGNAL port_tmp25              :  std_logic;   
   SIGNAL adetect_out              :  std_logic;
   SIGNAL adetect_in               :  std_logic;

BEGIN

   PROCESS (reset, writeclock)
   BEGIN
      IF (reset = '1') THEN
         write_ptr <= "0000000000000001";    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF ((reset_fifo OR reset_write) = '1') THEN
            write_ptr <= "0000000000000001";    
         ELSE
            IF ((wr_enable OR wr_align) = '1') THEN
               write_ptr <= write_ptr(FIFO_DEPTH - 2 DOWNTO 0) & write_ptr(FIFO_DEPTH - 1);    
            ELSE
               write_ptr <= write_ptr;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, readclock)
   BEGIN
      IF (reset = '1') THEN
         read_ptr1 <= "0000000000000001";    
         read_ptr2 <= "0000000000000010";    
      ELSIF (readclock'EVENT AND readclock = '1') THEN
         IF (fiforesetrd = '1') THEN
            read_ptr1 <= "0000000000000001";    
            read_ptr2 <= "0000000000000010";    
         ELSE
            IF (NOT enabledeskew = '1') THEN
               read_ptr1 <= read_ptr1(FIFO_DEPTH - 2 DOWNTO 0) & read_ptr1(FIFO_DEPTH - 1);    
               read_ptr2 <= read_ptr2(FIFO_DEPTH - 2 DOWNTO 0) & read_ptr2(FIFO_DEPTH - 1);    
            ELSE
               read_ptr1 <= "0000000000000001";    
               read_ptr2 <= "0000000000000010";    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   tmp_23 <= patterndetectin & disperrin & syncstatusin & errdetectin & datain(9 DOWNTO 0);
   port_tmp24 <= '1';
   port_tmp25 <= '0';
   deskew_ram : deskew_ram_block 
      PORT MAP (
         clk => writeclock,
         reset => reset,
         addrwr => write_ptr,
         addrrd1 => read_ptr1,
         addrrd2 => read_ptr2,
         datain => tmp_23,
         we => port_tmp24,
         re => port_tmp25,
         dataout1 => AUDI_d,
         dataout2 => AUDI_pre_d);   
   
   PROCESS (reset, readclock)
      VARIABLE dataout_tmp_tmp26  : std_logic_vector(9 DOWNTO 0);
      VARIABLE errdetect_tmp_tmp27  : std_logic;
      VARIABLE syncstatus_tmp_tmp28  : std_logic;
      VARIABLE disperr_tmp_tmp29  : std_logic;
      VARIABLE dataout_tmp_pre_tmp30  : std_logic_vector(9 DOWNTO 0);
      VARIABLE errdetect_tmp_pre_tmp31  : std_logic;
      VARIABLE syncstatus_tmp_pre_tmp32  : std_logic;
      VARIABLE disperr_tmp_pre_tmp33  : std_logic;
      VARIABLE patterndetect_tmp_tmp34  : std_logic;
      VARIABLE patterndetect_tmp_pre_tmp35  : std_logic;
   BEGIN
      IF (reset = '1') THEN
         dataout_tmp_tmp26 := "0000000000";    
         errdetect_tmp_tmp27 := '0';    
         syncstatus_tmp_tmp28 := '0';    
         disperr_tmp_tmp29 := '0';    
         dataout_tmp_pre_tmp30 := "0000000000";    
         errdetect_tmp_pre_tmp31 := '0';    
         syncstatus_tmp_pre_tmp32 := '0';    
         disperr_tmp_pre_tmp33 := '0';    
         patterndetect_tmp_tmp34 := '0';    
         patterndetect_tmp_pre_tmp35 := '0';    
      ELSIF (readclock'EVENT AND readclock = '1') THEN
         dataout_tmp_tmp26 := AUDI_d(9 DOWNTO 0);    
         errdetect_tmp_tmp27 := AUDI_d(10);    
         syncstatus_tmp_tmp28 := AUDI_d(11);    
         disperr_tmp_tmp29 := AUDI_d(12);    
         patterndetect_tmp_tmp34 := AUDI_d(13);    
         dataout_tmp_pre_tmp30 := AUDI_pre_d(9 DOWNTO 0);    
         errdetect_tmp_pre_tmp31 := AUDI_pre_d(10);    
         syncstatus_tmp_pre_tmp32 := AUDI_pre_d(11);    
         disperr_tmp_pre_tmp33 := AUDI_pre_d(12);    
         patterndetect_tmp_pre_tmp35 := AUDI_pre_d(13);    
      END IF;
      dataout_tmp <= dataout_tmp_tmp26;
      errdetect_tmp <= errdetect_tmp_tmp27;
      syncstatus_tmp <= syncstatus_tmp_tmp28;
      disperr_tmp <= disperr_tmp_tmp29;
      dataout_tmp_pre <= dataout_tmp_pre_tmp30;
      errdetect_tmp_pre <= errdetect_tmp_pre_tmp31;
      syncstatus_tmp_pre <= syncstatus_tmp_pre_tmp32;
      disperr_tmp_pre <= disperr_tmp_pre_tmp33;
      patterndetect_tmp <= patterndetect_tmp_tmp34;
      patterndetect_tmp_pre <= patterndetect_tmp_pre_tmp35;
   END PROCESS;

   PROCESS (reset, writeclock)
   BEGIN
      IF (reset = '1') THEN
         wr_enable <= '0';    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF ((reset_fifo OR reset_write) = '1') THEN
            wr_enable <= '0';    
         ELSE
            IF (wr_align = '1') THEN
               wr_enable <= '1';    
            ELSE
               wr_enable <= wr_enable;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (writeclock, reset)
   BEGIN
      IF (reset = '1') THEN
         adetect_deskew <= '0';    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF (wr_align = '1') THEN
            adetect_deskew <= '1';    
         ELSE
            IF (align_count = 0) THEN
               adetect_deskew <= '0';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclock)
   BEGIN
      IF (reset = '1') THEN
         align_count <= "0000";    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         IF (NOT enabledeskew_dly1 = '1') THEN
            align_count <= "0000";    
         ELSE
            IF (wr_align = '1') THEN
               align_count <= "1001";    
            ELSE
               IF (align_count /= 0) THEN
                  align_count <= align_count - "0001";    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (writeclock, reset)
   BEGIN
      IF (reset = '1') THEN
         enabledeskew_dly0 <= '1';    
         enabledeskew_dly1 <= '1';    
         enabledeskew_dly2 <= '1';    
      ELSIF (writeclock'EVENT AND writeclock = '1') THEN
         enabledeskew_dly0 <= enabledeskew;    
         enabledeskew_dly1 <= enabledeskew_dly0;    
         enabledeskew_dly2 <= enabledeskew_dly1;    
      END IF;
   END PROCESS;

   adetect_deskew_dly <= adetect_deskew after 1 ps;

   PROCESS (reset, readclock)
   BEGIN
      IF (reset = '1') THEN
         adetectdeskew_dly <= '0';    
         adetectdeskew_tmp <= '0';    
      ELSIF (readclock'EVENT AND readclock = '1') THEN
         adetectdeskew_dly <= adetect_deskew_dly;    
         adetectdeskew_tmp <= adetectdeskew_dly;    
      END IF;
   END PROCESS;

   adetect_out <= '1' when ((unsigned(dataout_tmp(9 DOWNTO 0)) = unsigned(a)) OR 
   (unsigned(dataout_tmp(9 DOWNTO 0)) = unsigned(NOT a))) else '0';
   adetect_in <= '1' when ((unsigned(datain(9 DOWNTO 0)) = unsigned(a)) OR 
   (unsigned(datain(9 DOWNTO 0)) = unsigned(NOT a))) else '0';
   rdalign <= '1' when ( (adetect_out = '1') AND (disperr_tmp = '0') AND (errdetect_tmp = '0') ) else '0' ;
   wr_align <= '1' when ((adetect_in = '1') AND (enabledeskew_dly1 = '1') AND (disperrin = '0') AND (errdetectin = '0')) else '0';
   reset_fifo <= (wr_enable AND write_ptr(FIFO_DEPTH - 1)) AND enabledeskew_dly1 ;
   reset_write <= enabledeskew_dly1 AND NOT enabledeskew_dly2 ;
   adetectdeskew <= adetectdeskew_tmp ;
   dataout <= dataout_tmp ;
   errdetect <= errdetect_tmp ;
   syncstatus <= syncstatus_tmp ;
   disperr <= disperr_tmp ;
   dataoutpre <= dataout_tmp_pre ;
   errdetectpre <= errdetect_tmp_pre ;
   syncstatuspre <= syncstatus_tmp_pre ;
   disperrpre <= disperr_tmp_pre ;
   patterndetect <= patterndetect_tmp ;
   patterndetectpre <= patterndetect_tmp_pre ;

END arch_stratixgx_deskew_fifo;


--/////////////////////////////////////////////////////////////////////////////
--
--                               STRATIXGX_RX_CORE
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratixgx_gxb;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_rx_core IS
   GENERIC (
      channel_width                  :  integer := 10;    
      use_double_data_mode           :  string  := "false";    
      use_channel_align              :  string  := "false";    
      use_8b_10b_mode                :  string  := "true";    
      align_pattern                      :  string  := "0000000000000000";
      synchronization_mode           :  string  := "none");
   PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      errdetectin             : IN std_logic;   
      patterndetectin         : IN std_logic;   
      decdatavalid            : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      post8b10b               : IN std_logic_vector(9 DOWNTO 0);   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      xgmctrlin               : IN std_logic;   
      ctrldetectin            : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disparityerrin          : IN std_logic;   
      syncstatus              : OUT std_logic_vector(1 DOWNTO 0);   
      errdetect               : OUT std_logic_vector(1 DOWNTO 0);   
      ctrldetect              : OUT std_logic_vector(1 DOWNTO 0);   
      disparityerr            : OUT std_logic_vector(1 DOWNTO 0);   
      patterndetect           : OUT std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(19 DOWNTO 0);   
      a1a2sizeout             : OUT std_logic_vector(1 DOWNTO 0);   
      clkout                  : OUT std_logic);   
END stratixgx_rx_core;

ARCHITECTURE arch_stratixgx_rx_core OF stratixgx_rx_core IS
   SIGNAL detect                   :  std_logic;   
   SIGNAL xgmxor                   :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL resync_d                 :  std_logic;   
   SIGNAL disperr_d                :  std_logic;   
   SIGNAL patterndetect_d          :  std_logic;   
   SIGNAL syncstatusin_1           :  std_logic;   
   SIGNAL syncstatusin_2           :  std_logic;   
   SIGNAL disparityerrin_1         :  std_logic;   
   SIGNAL disparityerrin_2         :  std_logic;   
   SIGNAL patterndetectin_1        :  std_logic;   
   SIGNAL patterndetectin_2        :  std_logic;   
   SIGNAL writeclk_by2             :  std_logic := '0';   
   SIGNAL data_low_sync            :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL data_low                 :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL data_high                :  std_logic_vector(12 DOWNTO 0);   
   SIGNAL data_int                 :  std_logic_vector(9 DOWNTO 0);   
   SIGNAL dataout_tmp              :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL patterndetect_tmp        :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_tmp         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL syncstatus_tmp           :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_tmp            :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_tmp           :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL a1a2sizeout_tmp          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL dataout_sync1            :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL patterndetect_sync1      :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_sync1       :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL syncstatus_sync1         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_sync1          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_sync1         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL a1a2sizeout_sync1        :  std_logic_vector(1 DOWNTO 0) := "00";
   SIGNAL dataout_sync2            :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL patterndetect_sync2      :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_sync2       :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL syncstatus_sync2         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_sync2          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_sync2         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL a1a2sizeout_sync2        :  std_logic_vector(1 DOWNTO 0) := "00";
   SIGNAL doublewidth              :  std_logic;   
   SIGNAL individual               :  std_logic;   
   SIGNAL ena8b10b                 :  std_logic;   
   SIGNAL smdisable                :  std_logic;   
   SIGNAL syncstatus_tmp1         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL errdetect_tmp2          :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL ctrldetect_tmp3         :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL disparityerr_tmp4       :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL patterndetect_tmp5      :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL dataout_tmp6            :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL a1a2sizeout_tmp7        :  std_logic_vector(1 downto 0);   
   SIGNAL clkout_tmp8             :  std_logic;   
   SIGNAL running_disp            :  std_logic;
   -- A1A2 patterndetect related signals
   signal align_pattern_int : std_logic_vector(15 downto 0);
   signal patterndetect_8b : std_logic;
   signal patterndetect_1_latch : std_logic;
   signal patterndetect_2_latch : std_logic;
   signal patterndetect_3_latch : std_logic;

BEGIN
  
   syncstatus <= syncstatus_tmp1;
   errdetect <= errdetect_tmp2;
   ctrldetect <= ctrldetect_tmp3;
   disparityerr <= disparityerr_tmp4;
   patterndetect <= patterndetect_tmp5;
   dataout <= dataout_tmp6;
   a1a2sizeout <= a1a2sizeout_tmp7;
   clkout <= clkout_tmp8;
   doublewidth <= '1' WHEN (use_double_data_mode = "true") ELSE '0' ;
   individual <= '1' WHEN (use_channel_align /= "true") ELSE '0' ;
   ena8b10b <= '1' WHEN (use_8b_10b_mode = "true") ELSE '0' ;
   smdisable <= '1' WHEN (synchronization_mode = "none") ELSE '0' ;
   running_disp <= disparityerrin OR errdetectin;
   
   -- A1A2 pattern detection
   align_pattern_int <= pattern_conversion(align_pattern);

   -- A1A2 patterndetect block
   PROCESS (datain, align_pattern_int, patterndetect_1_latch, patterndetect_3_latch)
      VARIABLE patterndetect_8b_tmp10  : std_logic;
      VARIABLE match_tmp  : std_logic := '0';
   BEGIN
      IF (datain(8) = '1') THEN
         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(15 DOWNTO 8))) then
            match_tmp := '1';
         else
            match_tmp := '0';
         end if;
         patterndetect_8b_tmp10 := match_tmp AND patterndetect_3_latch;    
      ELSE
         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(15 DOWNTO 8))) then
            match_tmp := '1';
         else
            match_tmp := '0';
         end if;
         patterndetect_8b_tmp10 := match_tmp AND patterndetect_1_latch;    
      END IF;
      patterndetect_8b <= patterndetect_8b_tmp10;
   END PROCESS;

   -- A1A2 patterndetect latch
   PROCESS (reset, writeclk)
      VARIABLE match_low  : std_logic := '0';
      VARIABLE match_high  : std_logic := '0';
   BEGIN
      IF (reset = '1') THEN
         patterndetect_1_latch <= '0';    
         patterndetect_2_latch <= '0';    
         patterndetect_3_latch <= '0';    
      ELSIF (writeclk'EVENT AND writeclk = '1') THEN
         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(7 DOWNTO 0))) then
            match_low := '1';
         else
            match_low := '0';
         end if;    

         if (UNSIGNED(datain(7 DOWNTO 0)) = UNSIGNED(align_pattern_int(15 DOWNTO 8))) then
            match_high := '1';
         else
            match_high := '0';
         end if;    

         patterndetect_1_latch <= match_low;
         patterndetect_2_latch <= (patterndetect_1_latch) AND match_low;
         patterndetect_3_latch <= (patterndetect_2_latch) AND match_high;
      END IF;
   END PROCESS;

   PROCESS (xgmdatain, datain, xgmctrlin, ctrldetectin, decdatavalid, data_int, syncstatusin, disparityerrin, patterndetectin, patterndetect_8b, syncstatusin_2, disparityerrin_2, patterndetectin_2, running_disp)
    variable i_detect : std_logic;
   BEGIN
      IF (ena8b10b = '1') THEN
         IF (individual = '1') THEN
            resync_d <= syncstatusin;    
            disperr_d <= disparityerrin;    
            IF ((NOT decdatavalid AND NOT smdisable) = '1') THEN
               data_int(8 DOWNTO 0) <= "110011100";    
               data_int(9) <= '0';    
               patterndetect_d <= '0';    
            ELSE
               IF (channel_width = 10) THEN
                  patterndetect_d <= patterndetectin;    
               ELSE
                  patterndetect_d <= patterndetect_8b;    
               END IF;

               IF (((decdatavalid AND NOT smdisable) AND running_disp) = '1') THEN
                  data_int(8 DOWNTO 0) <= "111111110";    
                  data_int(9) <= running_disp;    
               ELSE
                  data_int(8 DOWNTO 0) <= ctrldetectin & datain(7 DOWNTO 0);    
                  data_int(9) <= running_disp;    
               END IF;
            END IF;
         ELSE
            resync_d <= syncstatusin_2;    
            disperr_d <= disparityerrin_2;    
            patterndetect_d <= patterndetectin_2;    
            data_int(8 DOWNTO 0) <= xgmctrlin & xgmdatain(7 DOWNTO 0);    
            i_detect := '0';
            if (xgmxor /= 0) then
            i_detect := '1';
            end if;
        data_int(9) <= xgmctrlin AND NOT i_detect;    

         END IF;
      ELSE
         resync_d <= syncstatusin;    
         disperr_d <= disparityerrin;    
         data_int <= datain;    
         IF ((NOT decdatavalid AND NOT smdisable) = '1') THEN
            patterndetect_d <= '0';    
         ELSE
            IF (channel_width = 10) THEN
               patterndetect_d <= patterndetectin;    
            ELSE
               patterndetect_d <= patterndetect_8b;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   xgmxor <= xgmdatain(7 DOWNTO 0) XOR "11111110" ;

   PROCESS (reset, writeclk)
   BEGIN
      IF (reset = '1') THEN
         writeclk_by2 <= '0';    
         data_high <= "0000000000000";    
         data_low <= "0000000000000";    
         data_low_sync <= "0000000000000";    
         syncstatusin_1 <= '0';    
         syncstatusin_2 <= '0';    
         disparityerrin_1 <= '0';    
         disparityerrin_2 <= '0';    
         patterndetectin_1 <= '0';    
         patterndetectin_2 <= '0';    
      ELSIF (writeclk'EVENT AND writeclk = '1') THEN
         writeclk_by2 <= NOT ((writeclk_by2 AND individual) OR (writeclk_by2 AND NOT individual));    
         syncstatusin_1 <= syncstatusin;    
         syncstatusin_2 <= syncstatusin_1;    
         disparityerrin_1 <= disparityerrin;    
         disparityerrin_2 <= disparityerrin_1;    
         patterndetectin_1 <= patterndetectin;    
         patterndetectin_2 <= patterndetectin_1;    
         IF ((doublewidth AND NOT writeclk_by2) = '1') THEN
            data_high(9 DOWNTO 0) <= data_int;    
            data_high(10) <= resync_d;    
            data_high(11) <= disperr_d;    
            data_high(12) <= patterndetect_d;    
         END IF;
         IF ((doublewidth AND writeclk_by2) = '1') THEN
            data_low(9 DOWNTO 0) <= data_int;    
            data_low(10) <= resync_d;    
            data_low(11) <= disperr_d;    
            data_low(12) <= patterndetect_d;    
         END IF;
         IF (NOT doublewidth = '1') THEN
            data_low_sync(9 DOWNTO 0) <= data_int;    
            data_low_sync(10) <= resync_d;    
            data_low_sync(11) <= disperr_d;    
            data_low_sync(12) <= patterndetect_d;    
         ELSE
            data_low_sync <= data_low;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (writeclk_by2, writeclk)
   BEGIN
      IF (doublewidth = '1') THEN
         clkout_tmp8 <= NOT writeclk_by2;    
      ELSE
         clkout_tmp8 <= NOT writeclk;    
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         dataout_tmp <= "00000000000000000000";    
         patterndetect_tmp <= "00";    
         disparityerr_tmp <= "00";    
         syncstatus_tmp <= "00";    
         errdetect_tmp <= "00";    
         ctrldetect_tmp <= "00";    
         a1a2sizeout_tmp <= "00";    
         dataout_sync1 <= "00000000000000000000";    
         patterndetect_sync1 <= "00";    
         disparityerr_sync1 <= "00";    
         syncstatus_sync1 <= "00";    
         errdetect_sync1 <= "00";    
         ctrldetect_sync1 <= "00";    
         a1a2sizeout_sync1 <= "00";   
         dataout_sync2 <= "00000000000000000000";    
         patterndetect_sync2 <= "00";    
         disparityerr_sync2 <= "00";    
         syncstatus_sync2 <= "00";    
         errdetect_sync2 <= "00";    
         ctrldetect_sync2 <= "00";
         a1a2sizeout_sync2 <= "00";   
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         IF (ena8b10b = '1' OR channel_width = 8 OR channel_width = 16) THEN
            dataout_sync1 <= "0000" & data_high(7 DOWNTO 0) & data_low_sync(7 DOWNTO 0);    
         ELSE
            dataout_sync1 <= data_high(9 DOWNTO 0) & data_low_sync(9 DOWNTO 0);    
         END IF;

         patterndetect_sync1 <= data_high(12) & data_low_sync(12);    
         disparityerr_sync1 <= data_high(11) & data_low_sync(11);    
         syncstatus_sync1 <= data_high(10) & data_low_sync(10);    
         errdetect_sync1 <= data_high(9) & data_low_sync(9);    
         ctrldetect_sync1 <= data_high(8) & data_low_sync(8);    
         IF (channel_width = 8) THEN
            a1a2sizeout_sync1 <= data_high(8) & data_low_sync(8);    
         ELSE
            a1a2sizeout_sync1 <= "00";    
         END IF;
         dataout_sync2 <= dataout_sync1;    
         patterndetect_sync2 <= patterndetect_sync1;    
         disparityerr_sync2 <= disparityerr_sync1;    
         syncstatus_sync2 <= syncstatus_sync1;    
         errdetect_sync2 <= errdetect_sync1;    
         ctrldetect_sync2 <= ctrldetect_sync1;    
         a1a2sizeout_sync2 <= a1a2sizeout_sync1;    
         dataout_tmp <= dataout_sync2;    
         patterndetect_tmp <= patterndetect_sync2;    
         disparityerr_tmp <= disparityerr_sync2;    
         syncstatus_tmp <= syncstatus_sync2;    
         errdetect_tmp <= errdetect_sync2;    
         ctrldetect_tmp <= ctrldetect_sync2;    
         a1a2sizeout_tmp <= a1a2sizeout_sync2;    
      END IF;
   END PROCESS;
   dataout_tmp6 <= dataout_tmp ;
   a1a2sizeout_tmp7 <= a1a2sizeout_tmp;
   patterndetect_tmp5 <= patterndetect_tmp ;
   disparityerr_tmp4 <= disparityerr_tmp ;
   syncstatus_tmp1 <= syncstatus_tmp ;
   errdetect_tmp2 <= errdetect_tmp ;
   ctrldetect_tmp3 <= ctrldetect_tmp ;

END arch_stratixgx_rx_core;

--/////////////////////////////////////////////////////////////////////////////
--
--                               STRATIXGX_TX_CORE
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY stratixgx_tx_core IS
   GENERIC (
      use_double_data_mode           :  string := "false";    
      use_fifo_mode                  :  string := "true";    
      transmit_protocol              :  string := "none";
      channel_width                  :  integer := 10;    
      KCHAR                          :  std_logic := '0';    
      ECHAR                          :  std_logic := '0');
   PORT (
      reset                   : IN std_logic;   
      datain                  : IN std_logic_vector(19 DOWNTO 0);   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      ctrlena                 : IN std_logic_vector(1 DOWNTO 0);   
      forcedisp               : IN std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      forcedispout            : OUT std_logic;   
      ctrlenaout              : OUT std_logic;   
      rdenasync               : OUT std_logic;   
      xgmctrlena              : OUT std_logic;   
      xgmdataout              : OUT std_logic_vector(7 DOWNTO 0);   
      pre8b10bdataout         : OUT std_logic_vector(9 DOWNTO 0));   
END stratixgx_tx_core;

ARCHITECTURE arch_stratixgx_tx_core OF stratixgx_tx_core IS
   SIGNAL kchar_sync_1             :  std_logic;   
   SIGNAL kchar_sync               :  std_logic;   
   SIGNAL echar_sync_1             :  std_logic;   
   SIGNAL echar_sync               :  std_logic;   
   SIGNAL datain_high              :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL datain_low               :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_tmp            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_dly1           :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_dly2           :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_high_dly3           :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_tmp             :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_dly1            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_dly2            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL fifo_low_dly3            :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL dataout_read             :  std_logic_vector(11 DOWNTO 0);   
   SIGNAL wr_enable                :  std_logic;   
   SIGNAL rd_enable_sync_1         :  std_logic;   
   SIGNAL rd_enable_sync_2         :  std_logic;   
   SIGNAL rd_enable_sync_out       :  std_logic;   
   SIGNAL fifo_select_out          :  std_logic;   
   SIGNAL rdenasync_tmp            :  std_logic;   
   SIGNAL out_ena1                 :  std_logic;   
   SIGNAL out_ena2                 :  std_logic;   
   SIGNAL out_ena3                 :  std_logic;   
   SIGNAL out_ena4                 :  std_logic;   
   SIGNAL out_ena5                 :  std_logic;   
   SIGNAL doublewidth              :  std_logic;   
   SIGNAL disablefifo              :  std_logic;   
   SIGNAL individual               :  std_logic;   
   SIGNAL writeclk_dly             :  std_logic;   

BEGIN
   doublewidth <= '1' WHEN (use_double_data_mode = "true") ELSE '0' ;
   disablefifo <= '1' WHEN (use_fifo_mode = "false") ELSE '0' ;
   individual <= '1' WHEN (transmit_protocol /= "xaui") ELSE '0' ;

   PROCESS (writeclk)
   BEGIN
     writeclk_dly <= writeclk;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         kchar_sync_1 <= '0';    
         kchar_sync <= '0';    
         echar_sync_1 <= '0';    
         echar_sync <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         kchar_sync_1 <= KCHAR;    
         kchar_sync <= kchar_sync_1;    
         echar_sync_1 <= ECHAR;    
         echar_sync <= echar_sync_1;    
      END IF;
   END PROCESS;

   -- outputs
   dataout         <= dataout_read(9 DOWNTO 0);
   xgmdataout      <= dataout_read(7 DOWNTO 0);
   pre8b10bdataout <= dataout_read(9 DOWNTO 0);

   forcedispout    <= dataout_read(10);
   ctrlenaout      <= dataout_read(11);
   xgmctrlena      <= dataout_read(11);

   rdenasync       <= rdenasync_tmp;

   PROCESS (reset, writeclk_dly, datain, forcedisp, ctrlena)
   BEGIN
      IF (reset = '1') THEN
         datain_high(11 DOWNTO 0) <= "000000000000";    
         datain_low(11 DOWNTO 0) <= "000000000000";    
      ELSE
         IF (channel_width = 10 OR channel_width = 20) THEN
              IF (doublewidth = '1') THEN
                datain_high(11 DOWNTO 0) <= ctrlena(1) & forcedisp(1) & datain(19 DOWNTO 10);
              ELSE
                datain_high(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & datain(9 DOWNTO 0);
              END IF;

              datain_low(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & datain(9 DOWNTO 0);   
        ELSE
              IF (doublewidth = '1') THEN
                datain_high(11 DOWNTO 0) <= ctrlena(1) & forcedisp(1) & "00" & datain(15 DOWNTO 8);
              ELSE
                datain_high(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & "00" & datain(7 DOWNTO 0);
              END IF;

              datain_low(11 DOWNTO 0) <= ctrlena(0) & forcedisp(0) & "00" & datain(7 DOWNTO 0);
        END IF;
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         fifo_high_dly1 <= "000000000000";    
         fifo_high_dly2 <= "000000000000";    
         fifo_high_dly3 <= "000000000000";    
         fifo_high_tmp <= "000000000000";    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         fifo_high_dly1 <= datain_high;    
         fifo_high_dly2 <= fifo_high_dly1;    
         fifo_high_dly3 <= fifo_high_dly2;    
         fifo_high_tmp <= fifo_high_dly3;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         fifo_low_dly1 <= "000000000000";    
         fifo_low_dly2 <= "000000000000";    
         fifo_low_dly3 <= "000000000000";    
         fifo_low_tmp <= "000000000000";    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         fifo_low_dly1 <= datain_low;    
         fifo_low_dly2 <= fifo_low_dly1;    
         fifo_low_dly3 <= fifo_low_dly2;    
         fifo_low_tmp <= fifo_low_dly3;    
      END IF;
   END PROCESS;

   -- DATAOUT ENALBE LOGIC
   out_ena1 <= (((NOT disablefifo AND rdenasync_tmp) AND (NOT doublewidth OR fifo_select_out)) AND NOT kchar_sync) AND NOT echar_sync ;
   out_ena2 <= (((NOT disablefifo AND rdenasync_tmp) AND (doublewidth AND NOT fifo_select_out)) AND NOT kchar_sync) AND NOT echar_sync ;
   out_ena3 <= ((disablefifo AND (NOT doublewidth OR NOT fifo_select_out)) AND NOT kchar_sync) AND NOT echar_sync ;
   out_ena4 <= NOT kchar_sync AND echar_sync ;
   out_ena5 <= (((disablefifo AND doublewidth) AND fifo_select_out) AND NOT kchar_sync) AND NOT echar_sync ;

   -- Dataout, CTRL, FORCE_DISP registered by read clock
   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         dataout_read(11 DOWNTO 0) <= "000000000000";    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
       IF (out_ena1 = '1') THEN
         dataout_read <= fifo_low_tmp;
       ELSIF (out_ena2 = '1') THEN
         dataout_read <= fifo_high_tmp;
       ELSIF (out_ena3 = '1') THEN
         dataout_read <= datain_low;         
       ELSIF (out_ena4 = '1') THEN
           dataout_read(7 DOWNTO 0) <= "11111110";
           dataout_read(10) <= '0';
           dataout_read(11) <= '1';
       ELSIF (out_ena5 = '1') THEN
           dataout_read <= datain_high;
       ELSE 
           dataout_read(10) <= '0';
           dataout_read(11) <= '1';  -- fixed from 0 to 1 in 3.0 .
           IF ((NOT individual) = '1') THEN
             dataout_read(7 DOWNTO 0) <= "00000111"; 
           ELSE
             dataout_read(7 DOWNTO 0) <= "10111100";
           END IF;
       END IF;
         
     END IF; -- end of not reset
   END PROCESS;

   -- fifo select
   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1' OR writeclk_dly = '1') THEN
         fifo_select_out <= '1';    
      ELSE
         fifo_select_out <= '0';    
      END IF;
   END PROCESS;

   PROCESS (reset, readclk)
   BEGIN
      IF (reset = '1') THEN
         rd_enable_sync_1 <= '0';    
         rd_enable_sync_2 <= '0';    
         rd_enable_sync_out <= '0';    
      ELSIF (readclk'EVENT AND readclk = '1') THEN
         rd_enable_sync_1 <= wr_enable OR disablefifo;    
         rd_enable_sync_2 <= rd_enable_sync_1;    
         rd_enable_sync_out <= rd_enable_sync_2;    
      END IF;
   END PROCESS;

   PROCESS (reset, writeclk_dly)
   BEGIN
      IF (reset = '1') THEN
         wr_enable <= '0';    
      ELSIF (writeclk_dly'EVENT AND writeclk_dly = '1') THEN
         wr_enable <= '1';    
      END IF;
   END PROCESS;
   rdenasync_tmp <= rd_enable_sync_out WHEN (individual) = '1' ELSE rd_enable_sync_1 ;

END arch_stratixgx_tx_core;


-- 
-- 4 to 1 MULTIPLEXER
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_hssi_mux4 IS
   PORT (
      Y                       : OUT std_logic;   
      I0                      : IN std_logic;   
      I1                      : IN std_logic;   
      I2                      : IN std_logic;   
      I3                      : IN std_logic;   
      C0                      : IN std_logic;   
      C1                      : IN std_logic);
END stratixgx_hssi_mux4;

ARCHITECTURE stratixgx_hssi_mux4_arch OF stratixgx_hssi_mux4 IS
  SIGNAL Y_tmp                  :  std_logic;   
BEGIN
   Y <= Y_tmp;

   PROCESS (I0, I1, I2, I3, C0, C1)
      VARIABLE Y_tmp1  : std_logic;
      VARIABLE ctrl  : std_logic_vector(1 DOWNTO 0);
   BEGIN
      ctrl := C1 & C0;
      CASE ctrl IS
         WHEN "00" =>
                  Y_tmp1 := I0;    
         WHEN "01" =>
                  Y_tmp1 := I1;    
         WHEN "10" =>
                  Y_tmp1 := I2;    
         WHEN "11" =>
                  Y_tmp1 := I3;    
         WHEN OTHERS =>
                  NULL;
      END CASE;
      Y_tmp <= Y_tmp1;
   END PROCESS;

END stratixgx_hssi_mux4_arch;

--
-- DIVIDE BY TWO LOGIC
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_hssi_divide_by_two IS
   GENERIC (
      divide                  :  string := "true");
   PORT (
      reset                   : IN std_logic := '0';   
      clkin                   : IN std_logic;   
      clkout                  : OUT std_logic);   
END stratixgx_hssi_divide_by_two;

ARCHITECTURE stratixgx_hssi_divide_by_two_arch OF stratixgx_hssi_divide_by_two IS
  SIGNAL clktmp                   :  std_logic := '0';   
BEGIN
   PROCESS (clkin, reset)
   BEGIN
      IF (divide = "false") THEN
         clktmp <= clkin;    
      ELSIF (reset'event and (reset = '1')) THEN
         clktmp <= '0';
      ELSE
         IF (reset = '0' and clkin'event and (clkin = '1')) THEN
            clktmp <= NOT clktmp;    
         END IF;
      END IF;
   END PROCESS;
   clkout <= clktmp;
END stratixgx_hssi_divide_by_two_arch;

--
-- stratixgx_xgm_interface
--

library IEEE, stratixgx_gxb;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratixgx_gxb.hssi_pack.all;

ENTITY stratixgx_xgm_interface IS
  generic (
    use_continuous_calibration_mode : String := "false";
    mode_is_xaui : String := "false";
    rx_ppm_setting_0    : integer := 0;
    rx_ppm_setting_1    : integer := 0;
    digital_test_output_select          : integer := 0;
    analog_test_output_signal_select    : integer := 0;
    analog_test_output_channel_select   : integer := 0;
    use_rx_calibration_status           : String  := "false";
    use_global_serial_loopback          : String  := "false";
    rx_calibration_test_write_value     : integer := 0;
    enable_rx_calibration_test_write    : String  := "false";
    tx_calibration_test_write_value     : integer := 0;
    enable_tx_calibration_test_write    : String  := "false";
    TimingChecksOn      : Boolean := True;
    MsgOn               : Boolean := DefGlitchMsgOn;
    XOn                 : Boolean := DefGlitchXOn;
    MsgOnChecks		: Boolean := DefMsgOnChecks;
    XOnChecks		: Boolean := DefXOnChecks;
    InstancePath	: String  := "*";
    tipd_txdatain       : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
    tipd_txctrl		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rdenablesync	: VitalDelayType01 := DefpropDelay01;
    tipd_txclk		: VitalDelayType01 := DefpropDelay01;
    tipd_rxdatain       : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxctrl		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxclk		: VitalDelayType01 := DefpropDelay01;
    tipd_rxrunningdisp  : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rxdatavalid	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_resetall	: VitalDelayType01 := DefpropDelay01;
    tipd_adet		: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_syncstatus	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_rdalign	: VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
    tipd_recovclk	: VitalDelayType01 := DefpropDelay01
    );

   PORT (
      txdatain                : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      txctrl                  : IN std_logic_vector(3 DOWNTO 0) := "0000";
      rdenablesync            : IN std_logic := '0';
      txclk                   : IN std_logic := '0';   
      rxdatain                : IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
      rxctrl                  : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxrunningdisp           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxdatavalid             : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxclk                   : IN std_logic := '0';   
      resetall                : IN std_logic := '0';   
      adet                    : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      syncstatus              : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rdalign                 : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      recovclk                : IN std_logic := '0';   
      devpor                  : IN std_logic := '0';   
      devclrn                 : IN std_logic := '0';   
      txdataout               : OUT std_logic_vector(31 DOWNTO 0);   
      txctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
      rxdataout               : OUT std_logic_vector(31 DOWNTO 0);   
      rxctrlout               : OUT std_logic_vector(3 DOWNTO 0);   
      resetout                : OUT std_logic;   
      alignstatus             : OUT std_logic;   
      enabledeskew            : OUT std_logic;   
      fiforesetrd             : OUT std_logic;
      -- NEW MDIO/PE ONLY PORTS
      mdioclk                 : IN std_logic := '0';
      mdiodisable             : IN std_logic := '0';
      mdioin                  : IN std_logic := '0';
      rxppmselect             : IN std_logic := '0';
      scanclk                 : IN std_logic := '0';
      scanin                  : IN std_logic := '0';
      scanmode                : IN std_logic := '0';
      scanshift               : IN std_logic := '0';
      -- NEW MDIO/PE ONLY PORTS
      calibrationstatus       : OUT std_logic_vector(4 DOWNTO 0);
      digitalsmtest           : OUT std_logic_vector(3 DOWNTO 0);
      mdiooe                  : OUT std_logic;
      mdioout                 : OUT std_logic;
      scanout                 : OUT std_logic;
      test                    : OUT std_logic;
      -- RESET PORTS
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
      pllreset                : IN std_logic := '0';   
      pllenable               : IN std_logic := '1';   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic
    );   

END stratixgx_xgm_interface;

ARCHITECTURE vital_stratixgx_xgm_interface_atom OF stratixgx_xgm_interface IS

	-- input buffers
	signal txdatain_ipd : std_logic_vector(31 downto 0);
	signal txctrl_ipd : std_logic_vector(3 downto 0);
	signal rdenablesync_ipd : std_logic;
	signal txclk_ipd : std_logic;
	signal rxdatain_ipd : std_logic_vector(31 downto 0);
	signal rxctrl_ipd : std_logic_vector(3 downto 0);
	signal rxrunningdisp_ipd : std_logic_vector(3 downto 0);
	signal rxdatavalid_ipd : std_logic_vector(3 downto 0);
	signal rxclk_ipd : std_logic;
	signal resetall_ipd : std_logic;
	signal adet_ipd : std_logic_vector(3 downto 0);
	signal syncstatus_ipd : std_logic_vector(3 downto 0);
	signal rdalign_ipd : std_logic_vector(3 downto 0);
	signal recovclk_ipd : std_logic;

   -- internal input signals
   SIGNAL reset_int                :  std_logic;
   SIGNAL extended_pllreset        :  std_logic;
   SIGNAL rxdigitalresetout_tmp    :  std_logic_vector(3 downto 0) := "0000";
   SIGNAL txdigitalresetout_tmp    :  std_logic_vector(3 downto 0) := "0000";
   -- internal output signals
   SIGNAL resetout_tmp             :  std_logic;   
   SIGNAL txdataout_xtmp1          :  std_logic_vector(31 DOWNTO 0);   
   SIGNAL txctrlout_xtmp2          :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL rxdataout_xtmp3          :  std_logic_vector(31 DOWNTO 0);   
   SIGNAL rxctrlout_xtmp4          :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL resetout_xtmp5           :  std_logic;   
   SIGNAL alignstatus_xtmp6        :  std_logic;   
   SIGNAL enabledeskew_xtmp7       :  std_logic;   
   SIGNAL fiforesetrd_xtmp8        :  std_logic;   

component stratixgx_reset_block
   PORT (
      txdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxdigitalreset          : IN std_logic_vector(3 DOWNTO 0);   
      rxanalogreset           : IN std_logic_vector(3 DOWNTO 0);   
      pllreset                : IN std_logic;   
      pllenable               : IN std_logic;   
      txdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      rxdigitalresetout       : OUT std_logic_vector(3 DOWNTO 0);   
      txanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      rxanalogresetout        : OUT std_logic_vector(3 DOWNTO 0);   
      pllresetout             : OUT std_logic);   
END component;

component stratixgx_xgm_rx_sm 
   port (
     rxdatain			: IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
     rxctrl         : IN std_logic_vector(3 DOWNTO 0) := "0000";
     rxrunningdisp  : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxdatavalid    : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rxclk          : IN std_logic := '0';   
     resetall       : IN std_logic := '0';   
     rxdataout      : OUT std_logic_vector(31 DOWNTO 0);   
     rxctrlout      : OUT std_logic_vector(3 DOWNTO 0)
     );   
end component;

component stratixgx_xgm_tx_sm 
   port (
     txdatain			: IN std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";   
     txctrl         : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rdenablesync   : IN std_logic := '0';   
     txclk          : IN std_logic := '0';   
     resetall       : IN std_logic := '0';   
     txdataout      : OUT std_logic_vector(31 DOWNTO 0);   
     txctrlout      : OUT std_logic_vector(3 DOWNTO 0));   
end component;

component stratixgx_xgm_dskw_sm 
   port (
     resetall       : IN std_logic := '0';   
     adet           : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     syncstatus     : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     rdalign        : IN std_logic_vector(3 DOWNTO 0) := "0000";   
     recovclk       : IN std_logic := '0';   
     alignstatus    : OUT std_logic;   
     enabledeskew   : OUT std_logic;   
     fiforesetrd    : OUT std_logic);   
end component;

BEGIN
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (txdatain_ipd(0), txdatain(0), tipd_txdatain(0));
		VitalWireDelay (txdatain_ipd(1), txdatain(1), tipd_txdatain(1));
		VitalWireDelay (txdatain_ipd(2), txdatain(2), tipd_txdatain(2));
		VitalWireDelay (txdatain_ipd(3), txdatain(3), tipd_txdatain(3));
		VitalWireDelay (txdatain_ipd(4), txdatain(4), tipd_txdatain(4));
		VitalWireDelay (txdatain_ipd(5), txdatain(5), tipd_txdatain(5));
		VitalWireDelay (txdatain_ipd(6), txdatain(6), tipd_txdatain(6));
		VitalWireDelay (txdatain_ipd(7), txdatain(7), tipd_txdatain(7));
		VitalWireDelay (txdatain_ipd(8), txdatain(8), tipd_txdatain(8));
		VitalWireDelay (txdatain_ipd(9), txdatain(9), tipd_txdatain(9));
		VitalWireDelay (txdatain_ipd(10), txdatain(10), tipd_txdatain(10));
		VitalWireDelay (txdatain_ipd(11), txdatain(11), tipd_txdatain(11));
		VitalWireDelay (txdatain_ipd(12), txdatain(12), tipd_txdatain(12));
		VitalWireDelay (txdatain_ipd(13), txdatain(13), tipd_txdatain(13));
		VitalWireDelay (txdatain_ipd(14), txdatain(14), tipd_txdatain(14));
		VitalWireDelay (txdatain_ipd(15), txdatain(15), tipd_txdatain(15));
		VitalWireDelay (txdatain_ipd(16), txdatain(16), tipd_txdatain(16));
		VitalWireDelay (txdatain_ipd(17), txdatain(17), tipd_txdatain(17));
		VitalWireDelay (txdatain_ipd(18), txdatain(18), tipd_txdatain(18));
		VitalWireDelay (txdatain_ipd(19), txdatain(19), tipd_txdatain(19));
		VitalWireDelay (txdatain_ipd(20), txdatain(20), tipd_txdatain(20));
		VitalWireDelay (txdatain_ipd(21), txdatain(21), tipd_txdatain(21));
		VitalWireDelay (txdatain_ipd(22), txdatain(22), tipd_txdatain(22));
		VitalWireDelay (txdatain_ipd(23), txdatain(23), tipd_txdatain(23));
		VitalWireDelay (txdatain_ipd(24), txdatain(24), tipd_txdatain(24));
		VitalWireDelay (txdatain_ipd(25), txdatain(25), tipd_txdatain(25));
		VitalWireDelay (txdatain_ipd(26), txdatain(26), tipd_txdatain(26));
		VitalWireDelay (txdatain_ipd(27), txdatain(27), tipd_txdatain(27));
		VitalWireDelay (txdatain_ipd(28), txdatain(28), tipd_txdatain(28));
		VitalWireDelay (txdatain_ipd(29), txdatain(29), tipd_txdatain(29));
		VitalWireDelay (txdatain_ipd(30), txdatain(30), tipd_txdatain(30));
		VitalWireDelay (txdatain_ipd(31), txdatain(31), tipd_txdatain(31));

		VitalWireDelay (rxdatain_ipd(0), rxdatain(0), tipd_rxdatain(0));
		VitalWireDelay (rxdatain_ipd(1), rxdatain(1), tipd_rxdatain(1));
		VitalWireDelay (rxdatain_ipd(2), rxdatain(2), tipd_rxdatain(2));
		VitalWireDelay (rxdatain_ipd(3), rxdatain(3), tipd_rxdatain(3));
		VitalWireDelay (rxdatain_ipd(4), rxdatain(4), tipd_rxdatain(4));
		VitalWireDelay (rxdatain_ipd(5), rxdatain(5), tipd_rxdatain(5));
		VitalWireDelay (rxdatain_ipd(6), rxdatain(6), tipd_rxdatain(6));
		VitalWireDelay (rxdatain_ipd(7), rxdatain(7), tipd_rxdatain(7));
		VitalWireDelay (rxdatain_ipd(8), rxdatain(8), tipd_rxdatain(8));
		VitalWireDelay (rxdatain_ipd(9), rxdatain(9), tipd_rxdatain(9));
		VitalWireDelay (rxdatain_ipd(10), rxdatain(10), tipd_rxdatain(10));
		VitalWireDelay (rxdatain_ipd(11), rxdatain(11), tipd_rxdatain(11));
		VitalWireDelay (rxdatain_ipd(12), rxdatain(12), tipd_rxdatain(12));
		VitalWireDelay (rxdatain_ipd(13), rxdatain(13), tipd_rxdatain(13));
		VitalWireDelay (rxdatain_ipd(14), rxdatain(14), tipd_rxdatain(14));
		VitalWireDelay (rxdatain_ipd(15), rxdatain(15), tipd_rxdatain(15));
		VitalWireDelay (rxdatain_ipd(16), rxdatain(16), tipd_rxdatain(16));
		VitalWireDelay (rxdatain_ipd(17), rxdatain(17), tipd_rxdatain(17));
		VitalWireDelay (rxdatain_ipd(18), rxdatain(18), tipd_rxdatain(18));
		VitalWireDelay (rxdatain_ipd(19), rxdatain(19), tipd_rxdatain(19));
		VitalWireDelay (rxdatain_ipd(20), rxdatain(20), tipd_rxdatain(20));
		VitalWireDelay (rxdatain_ipd(21), rxdatain(21), tipd_rxdatain(21));
		VitalWireDelay (rxdatain_ipd(22), rxdatain(22), tipd_rxdatain(22));
		VitalWireDelay (rxdatain_ipd(23), rxdatain(23), tipd_rxdatain(23));
		VitalWireDelay (rxdatain_ipd(24), rxdatain(24), tipd_rxdatain(24));
		VitalWireDelay (rxdatain_ipd(25), rxdatain(25), tipd_rxdatain(25));
		VitalWireDelay (rxdatain_ipd(26), rxdatain(26), tipd_rxdatain(26));
		VitalWireDelay (rxdatain_ipd(27), rxdatain(27), tipd_rxdatain(27));
		VitalWireDelay (rxdatain_ipd(28), rxdatain(28), tipd_rxdatain(28));
		VitalWireDelay (rxdatain_ipd(29), rxdatain(29), tipd_rxdatain(29));
		VitalWireDelay (rxdatain_ipd(30), rxdatain(30), tipd_rxdatain(30));
		VitalWireDelay (rxdatain_ipd(31), rxdatain(31), tipd_rxdatain(31));

		VitalWireDelay (txctrl_ipd(0), txctrl(0), tipd_txctrl(0));
		VitalWireDelay (txctrl_ipd(1), txctrl(1), tipd_txctrl(1));
		VitalWireDelay (txctrl_ipd(2), txctrl(2), tipd_txctrl(2));
		VitalWireDelay (txctrl_ipd(3), txctrl(3), tipd_txctrl(3));

		VitalWireDelay (rxctrl_ipd(0), rxctrl(0), tipd_rxctrl(0));
		VitalWireDelay (rxctrl_ipd(1), rxctrl(1), tipd_rxctrl(1));
		VitalWireDelay (rxctrl_ipd(2), rxctrl(2), tipd_rxctrl(2));
		VitalWireDelay (rxctrl_ipd(3), rxctrl(3), tipd_rxctrl(3));

		VitalWireDelay (rxrunningdisp_ipd(0), rxrunningdisp(0), tipd_rxrunningdisp(0));
		VitalWireDelay (rxrunningdisp_ipd(1), rxrunningdisp(1), tipd_rxrunningdisp(1));
		VitalWireDelay (rxrunningdisp_ipd(2), rxrunningdisp(2), tipd_rxrunningdisp(2));
		VitalWireDelay (rxrunningdisp_ipd(3), rxrunningdisp(3), tipd_rxrunningdisp(3));

		VitalWireDelay (rxdatavalid_ipd(0), rxdatavalid(0), tipd_rxdatavalid(0));
		VitalWireDelay (rxdatavalid_ipd(1), rxdatavalid(1), tipd_rxdatavalid(1));
		VitalWireDelay (rxdatavalid_ipd(2), rxdatavalid(2), tipd_rxdatavalid(2));
		VitalWireDelay (rxdatavalid_ipd(3), rxdatavalid(3), tipd_rxdatavalid(3));

		VitalWireDelay (rdenablesync_ipd, rdenablesync, tipd_rdenablesync);

		VitalWireDelay (txclk_ipd, txclk, tipd_txclk);
		VitalWireDelay (rxclk_ipd, rxclk, tipd_rxclk);
		VitalWireDelay (recovclk_ipd, recovclk, tipd_recovclk);

		VitalWireDelay (resetall_ipd, resetall, tipd_resetall);

		VitalWireDelay (adet_ipd(0), adet(0), tipd_adet(0));
		VitalWireDelay (adet_ipd(1), adet(1), tipd_adet(1));
		VitalWireDelay (adet_ipd(2), adet(2), tipd_adet(2));
		VitalWireDelay (adet_ipd(3), adet(3), tipd_adet(3));

		VitalWireDelay (syncstatus_ipd(0), syncstatus(0), tipd_syncstatus(0));
		VitalWireDelay (syncstatus_ipd(1), syncstatus(1), tipd_syncstatus(1));
		VitalWireDelay (syncstatus_ipd(2), syncstatus(2), tipd_syncstatus(2));
		VitalWireDelay (syncstatus_ipd(3), syncstatus(3), tipd_syncstatus(3));

		VitalWireDelay (rdalign_ipd(0), rdalign(0), tipd_rdalign(0));
		VitalWireDelay (rdalign_ipd(1), rdalign(1), tipd_rdalign(1));
		VitalWireDelay (rdalign_ipd(2), rdalign(2), tipd_rdalign(2));
		VitalWireDelay (rdalign_ipd(3), rdalign(3), tipd_rdalign(3));
	end block;

	------------------------
	--  Timing Check Section
	------------------------

   txdataout <= txdataout_xtmp1;
   txctrlout <= txctrlout_xtmp2;
   rxdataout <= rxdataout_xtmp3;
   rxctrlout <= rxctrlout_xtmp4;
   resetout <= resetout_xtmp5;
   alignstatus <= alignstatus_xtmp6;
   enabledeskew <= enabledeskew_xtmp7;
   fiforesetrd <= fiforesetrd_xtmp8;
   reset_int <= resetall_ipd ;
   rxdigitalresetout <= rxdigitalresetout_tmp;
   txdigitalresetout <= txdigitalresetout_tmp;
   resetout_tmp <= resetall_ipd ;
   extended_pllreset <= pllreset OR (NOT devpor) OR (NOT devclrn);
        
   stratixgx_reset : stratixgx_reset_block
     port map (
       txdigitalreset => txdigitalreset,
       rxdigitalreset => rxdigitalreset,
       rxanalogreset  => rxanalogreset,
       pllreset       => extended_pllreset,
       pllenable      => pllenable,
       txdigitalresetout => txdigitalresetout_tmp,
       rxdigitalresetout => rxdigitalresetout_tmp,
       txanalogresetout  => txanalogresetout,
       rxanalogresetout  => rxanalogresetout,
       pllresetout       => pllresetout);
        
   s_xgm_rx_sm : stratixgx_xgm_rx_sm 
      PORT MAP (
         rxdatain => rxdatain_ipd,
         rxctrl => rxctrl_ipd,
         rxrunningdisp => rxrunningdisp_ipd,
         rxdatavalid => rxdatavalid_ipd,
         rxclk => rxclk_ipd,
         resetall => rxdigitalresetout_tmp(0),
         rxdataout => rxdataout_xtmp3,
         rxctrlout => rxctrlout_xtmp4);   
   
   s_xgm_tx_sm : stratixgx_xgm_tx_sm 
      PORT MAP (
         txdatain => txdatain_ipd,
         txctrl => txctrl_ipd,
         rdenablesync => rdenablesync_ipd,
         txclk => txclk_ipd,
         resetall => txdigitalresetout_tmp(0),
         txdataout => txdataout_xtmp1,
         txctrlout => txctrlout_xtmp2);   
   
   s_xgm_dskw_sm : stratixgx_xgm_dskw_sm 
      PORT MAP (
         resetall => rxdigitalresetout_tmp(0),
         adet => adet_ipd,
         syncstatus => syncstatus_ipd,
         rdalign => rdalign_ipd,
         recovclk => recovclk_ipd,
         alignstatus => alignstatus_xtmp6,
         enabledeskew => enabledeskew_xtmp7,
         fiforesetrd => fiforesetrd_xtmp8);   
   
   resetout_xtmp5 <= resetout_tmp AND '1';   

	----------------------
	--  Path Delay Section
	----------------------

END vital_stratixgx_xgm_interface_atom;

--
-- STRATIXGX_HSSI_RECEIVER
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratixgx_gxb.hssi_pack.all;
use std.textio.all;

entity stratixgx_hssi_receiver is
  generic (
    channel_num                 : integer := 1;
    channel_width		: integer := 20;
    deserialization_factor	: integer := 10;
    run_length			: integer := 4;
    run_length_enable		: String  := "false";
    use_8b_10b_mode		: String  := "false";
    use_double_data_mode	: String  := "false";
    use_rate_match_fifo		: String  := "false";
    rate_matching_fifo_mode	: String  := "none";
    use_channel_align		: String  := "false";
    use_symbol_align		: String  := "true";
    use_auto_bit_slip		: String  := "false";
    use_parallel_feedback       : String  := "false";
    use_post8b10b_feedback      : String  := "false";
    send_reverse_parallel_feedback : String := "false";
    synchronization_mode	: String  := "none";
    align_pattern		: String  := "0000000000000000";
    align_pattern_length	: integer  := 7;
    infiniband_invalid_code	: integer  := 0;
    disparity_mode		: String  := "false";
    clk_out_mode_reference	: String  := "true";
    cruclk_period		: integer := 5000;
    cruclk_multiplier 		: integer := 4;
    use_cruclk_divider		: String  := "false";
    use_self_test_mode          : String  := "false";
    self_test_mode          : integer  := 0;
    use_equalizer_ctrl_signal   : String  := "false";
    enable_dc_coupling          : String  := "false";
    equalizer_ctrl_setting      : integer := 20;
    signal_threshold_select     : integer := 2;
    vco_bypass                  : String  := "false";
    force_signal_detect         : String  := "false";
    bandwidth_type          : String  := "low";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    TimingChecksOn		: Boolean := True;
    MsgOn			: Boolean := DefGlitchMsgOn;
    XOn				: Boolean := DefGlitchXOn;
    MsgOnChecks			: Boolean := DefMsgOnChecks;
    XOnChecks			: Boolean := DefXOnChecks;
    InstancePath		: String  := "*";
    tipd_datain			: VitalDelayType01 := DefpropDelay01;
    tipd_cruclk			: VitalDelayType01 := DefpropDelay01;
    tipd_pllclk			: VitalDelayType01 := DefpropDelay01;
    tipd_masterclk		: VitalDelayType01 := DefpropDelay01;
    tipd_coreclk		: VitalDelayType01 := DefpropDelay01;
    tipd_softreset		: VitalDelayType01 := DefpropDelay01;
    tipd_serialfdbk		: VitalDelayType01 := DefpropDelay01;
    tipd_analogreset		: VitalDelayType01 := DefpropDelay01;
    tipd_locktorefclk		: VitalDelayType01 := DefpropDelay01;
    tipd_locktodata		: VitalDelayType01 := DefpropDelay01;
    tipd_equalizerctrl          : VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
    tipd_parallelfdbk           : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
    tipd_post8b10b              : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
    tipd_slpbk                  : VitalDelayType01 := DefpropDelay01;
    tipd_bitslip		: VitalDelayType01 := DefpropDelay01;
    tipd_a1a2size		: VitalDelayType01 := DefpropDelay01;
    tipd_enacdet		: VitalDelayType01 := DefpropDelay01;
    tipd_we			: VitalDelayType01 := DefpropDelay01;
    tipd_re			: VitalDelayType01 := DefpropDelay01;
    tipd_alignstatus		: VitalDelayType01 := DefpropDelay01;
    tipd_disablefifordin	: VitalDelayType01 := DefpropDelay01;
    tipd_disablefifowrin	: VitalDelayType01 := DefpropDelay01;
    tipd_fifordin		: VitalDelayType01 := DefpropDelay01;
    tipd_enabledeskew		: VitalDelayType01 := DefpropDelay01;
    tipd_fiforesetrd		: VitalDelayType01 := DefpropDelay01;
    tipd_xgmdatain              : VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
    tipd_xgmctrlin		: VitalDelayType01 := DefpropDelay01;
    tsetup_re_coreclk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
    thold_re_coreclk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
    tpd_coreclk_dataout_posedge : VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_syncstatus_posedge      : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_patterndetect_posedge   : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_ctrldetect_posedge      : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_errdetect_posedge       : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_disperr_posedge         : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_a1a2sizeout_posedge     : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tpd_coreclk_fifofull_posedge        : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoempty_posedge       : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoalmostfull_posedge  : VitalDelayType01 := DefPropDelay01;
    tpd_coreclk_fifoalmostempty_posedge : VitalDelayType01 := DefPropDelay01
    );

  port (
    datain		: in std_logic := '0';
    cruclk		: in std_logic := '0';
    pllclk		: in std_logic := '0';
    masterclk		: in std_logic := '0';
    coreclk		: in std_logic := '0';
    softreset		: in std_logic := '0';
    serialfdbk		: in std_logic := '0';
    parallelfdbk	: in std_logic_vector(9 downto 0) := "0000000000";
    post8b10b		: in std_logic_vector(9 downto 0) := "0000000000";
    slpbk		: in std_logic := '0';
    bitslip		: in std_logic := '0';
    enacdet		: in std_logic := '0';
    we			: in std_logic := '0';
    re			: in std_logic := '0';
    alignstatus		: in std_logic := '0';
    disablefifordin	: in std_logic := '0';
    disablefifowrin	: in std_logic := '0';
    fifordin		: in std_logic := '0';
    enabledeskew	: in std_logic := '0';
    fiforesetrd		: in std_logic := '0';
    xgmdatain		: in std_logic_vector(7 downto 0) := "00000000";
    xgmctrlin		: in std_logic := '0';
    devclrn		: in std_logic := '1';
    devpor		: in std_logic := '1';
    analogreset		: in std_logic := '0';
    a1a2size		: in std_logic := '0';
    locktorefclk	: in std_logic := '0';
    locktodata		: in std_logic := '0';
    equalizerctrl	: in std_logic_vector(2 downto 0) := "000";
    syncstatus		: out std_logic_vector(1 downto 0);
    patterndetect	: out std_logic_vector(1 downto 0);
    ctrldetect		: out std_logic_vector(1 downto 0);
    errdetect		: out std_logic_vector(1 downto 0);
    disperr		: out std_logic_vector(1 downto 0);
    syncstatusdeskew	: out std_logic;
    adetectdeskew	: out std_logic;
    rdalign		: out std_logic;
    dataout		: out std_logic_vector(19 downto 0);
    xgmdataout		: out std_logic_vector(7 downto 0);
    xgmctrldet		: out std_logic;
    xgmrunningdisp	: out std_logic;
    xgmdatavalid	: out std_logic;
    fifofull		: out std_logic;
    fifoalmostfull	: out std_logic;
    fifoempty		: out std_logic;
    fifoalmostempty	: out std_logic;
    disablefifordout	: out std_logic;
    disablefifowrout	: out std_logic;
    fifordout		: out std_logic;
    signaldetect	: out std_logic;
    lock		: out std_logic;
    freqlock		: out std_logic;
    rlv			: out std_logic;
    clkout		: out std_logic;
    recovclkout		: out std_logic;
    bisterr             : out std_logic := '0';
    bistdone            : out std_logic := '1';
    a1a2sizeout         : out std_logic_vector(1 downto 0) 
    );
end stratixgx_hssi_receiver;

architecture vital_receiver_atom of stratixgx_hssi_receiver is
  signal datain_ipd : std_logic;
  signal cruclk_ipd  : std_logic;
  signal pllclk_ipd  : std_logic;
  signal masterclk_ipd  : std_logic;
  signal coreclk_ipd  : std_logic;
  signal softreset_ipd	: std_logic := '0';
  signal serialfdbk_ipd : std_logic := '0';
  signal analogreset_ipd : std_logic := '0';
  signal locktorefclk_ipd : std_logic := '0';
  signal locktodata_ipd : std_logic := '0';
  signal equalizerctrl_ipd : std_logic_vector(2 downto 0);
  signal parallelfdbk_ipd  : std_logic_vector(9 downto 0);
  signal post8b10b_ipd	: std_logic_vector(9 downto 0);
  signal slpbk_ipd : std_logic := '0';
  signal bitslip_ipd : std_logic := '0';
  signal a1a2size_ipd : std_logic := '0';
  signal enacdet_ipd : std_logic := '0';
  signal we_ipd: std_logic := '0';
  signal re_ipd : std_logic := '0';
  signal alignstatus_ipd : std_logic := '0';
  signal disablefifordin_ipd : std_logic := '0';
  signal disablefifowrin_ipd : std_logic := '0';
  signal fifordin_ipd : std_logic := '0';
  signal enabledeskew_ipd : std_logic := '0';
  signal fiforesetrd_ipd : std_logic := '0';
  signal xgmdatain_ipd : std_logic_vector(7 downto 0);
  signal xgmctrlin_ipd : std_logic := '0';
  
  signal clkout_tmp : std_logic;
  signal dataout_tmp : std_logic_vector(19 downto 0);
  
  --constant signals
  signal vcc : std_logic := '1';
  signal gnd : std_logic := '0';
  signal idle_bus : std_logic_vector(9 downto 0) := "0000000000";

  --lower lever softreset 
  signal reset_int : std_logic;
  
  -- serdes output signals
  signal serdes_clkout : std_logic; --receovered clock
  signal serdes_rlv : std_logic;
  signal serdes_signaldetect : std_logic;
  signal serdes_lock : std_logic;
  signal serdes_freqlock : std_logic;
  signal serdes_dataout : std_logic_vector(9 downto 0);

  -- word aligner input/output signals
  signal wa_datain : std_logic_vector(9 downto 0);
  signal wa_clk : std_logic;
  signal wa_enacdet : std_logic;
  signal wa_bitslip : std_logic;
  signal wa_a1a2size : std_logic;
  
  signal wa_aligneddata : std_logic_vector(9 downto 0);
  signal wa_aligneddatapre : std_logic_vector(9 downto 0);
  signal wa_invalidcode : std_logic;
  signal wa_invalidcodepre : std_logic;
  signal wa_disperr : std_logic;
  signal wa_disperrpre : std_logic;
  signal wa_patterndetect : std_logic;
  signal wa_patterndetectpre : std_logic;
  signal wa_syncstatus : std_logic;
  signal wa_syncstatusdeskew : std_logic;

  -- deskew FIFO input/output signals
  signal dsfifo_datain : std_logic_vector(9 downto 0);     
  signal dsfifo_errdetectin : std_logic;
  signal dsfifo_syncstatusin : std_logic;
  signal dsfifo_disperrin : std_logic; 
  signal dsfifo_patterndetectin : std_logic; 
  signal dsfifo_writeclock : std_logic;
  signal dsfifo_readclock : std_logic; 
  signal dsfifo_fiforesetrd : std_logic; 
  signal dsfifo_enabledeskew : std_logic;
  
  signal dsfifo_dataout : std_logic_vector(9 downto 0); 
  signal dsfifo_dataoutpre : std_logic_vector(9 downto 0); 
  signal dsfifo_errdetect : std_logic;   
  signal dsfifo_syncstatus : std_logic; 
  signal dsfifo_disperr : std_logic;    
  signal dsfifo_patterndetect : std_logic; 
  signal dsfifo_errdetectpre : std_logic;   
  signal dsfifo_syncstatuspre : std_logic; 
  signal dsfifo_disperrpre : std_logic;    
  signal dsfifo_patterndetectpre : std_logic; 
  signal dsfifo_adetectdeskew : std_logic;
  signal dsfifo_rdalign : std_logic;     
   
  -- comp FIFO input/output signals
  signal cmfifo_datain : std_logic_vector(9 downto 0);
  signal cmfifo_datainpre : std_logic_vector(9 downto 0);
  signal cmfifo_invalidcodein : std_logic; 
  signal cmfifo_invalidcodeinpre : std_logic; 
  signal cmfifo_disperrin : std_logic;  
  signal cmfifo_disperrinpre : std_logic;  
  signal cmfifo_patterndetectin : std_logic;
  signal cmfifo_patterndetectinpre : std_logic;
  signal cmfifo_syncstatusin : std_logic;
  signal cmfifo_syncstatusinpre : std_logic;
  signal cmfifo_writeclk : std_logic;      
  signal cmfifo_readclk : std_logic;      
  signal cmfifo_alignstatus : std_logic;
  signal cmfifo_re : std_logic;
  signal cmfifo_we : std_logic;
  signal cmfifo_fifordin : std_logic;
  signal cmfifo_disablefifordin : std_logic; 
  signal cmfifo_disablefifowrin : std_logic;
  
  signal cmfifo_dataout : std_logic_vector(9 downto 0); 
  signal cmfifo_invalidcode : std_logic;
  signal cmfifo_syncstatus : std_logic;
  signal cmfifo_disperr : std_logic;
  signal cmfifo_patterndetect : std_logic;
  signal cmfifo_datavalid : std_logic;
  signal cmfifo_fifofull : std_logic;
  signal cmfifo_fifoalmostfull : std_logic;
  signal cmfifo_fifoempty : std_logic;
  signal cmfifo_fifoalmostempty : std_logic;
  signal cmfifo_disablefifordout : std_logic;
  signal cmfifo_disablefifowrout : std_logic;
  signal cmfifo_fifordout : std_logic;

  -- 8B10B decode input/output signals
  signal decoder_clk : std_logic; 
  signal decoder_datain : std_logic_vector(9 downto 0);   
  signal decoder_errdetectin : std_logic;         
  signal decoder_syncstatusin : std_logic;         
  signal decoder_disperrin : std_logic;         
  signal decoder_patterndetectin : std_logic;         
  signal decoder_indatavalid : std_logic;         
   
  signal decoder_dataout : std_logic_vector(7 downto 0); 
  signal decoder_tenBdata : std_logic_vector(9 downto 0); 
  signal decoder_valid : std_logic;         
  signal decoder_errdetect : std_logic;         
  signal decoder_syncstatus : std_logic;         
  signal decoder_disperr : std_logic;         
  signal decoder_patterndetect : std_logic;         
  signal decoder_rderr : std_logic;         
  signal decoder_decdatavalid : std_logic;    
  signal decoder_ctrldetect : std_logic;   
  signal decoder_xgmdatavalid : std_logic;   
  signal decoder_xgmrunningdisp : std_logic;   
  signal decoder_xgmctrldet : std_logic;   
  signal decoder_xgmdataout : std_logic_vector(7 downto 0); 

  -- rx_core input/output signals
  signal core_datain : std_logic_vector(9 downto 0);
  signal core_writeclk : std_logic;   
  signal core_readclk : std_logic;   
  signal core_decdatavalid : std_logic;   
  signal core_xgmdatain : std_logic_vector(7 downto 0);
  signal core_xgmctrlin : std_logic;   
  signal core_post8b10b : std_logic_vector(9 downto 0);   
  signal core_syncstatusin : std_logic;   
  signal core_errdetectin: std_logic;   
  signal core_ctrldetectin: std_logic;   
  signal core_disparityerrin: std_logic;   
  signal core_patterndetectin: std_logic;   

  signal core_dataout : std_logic_vector(19 downto 0);
  signal core_clkout : std_logic;   
  signal core_syncstatus : std_logic_vector(1 downto 0);   
  signal core_errdetect : std_logic_vector(1 downto 0);   
  signal core_ctrldetect : std_logic_vector(1 downto 0);   
  signal core_disparityerr : std_logic_vector(1 downto 0);   
  signal core_patterndetect : std_logic_vector(1 downto 0);   
  signal core_a1a2sizeout : std_logic_vector(1 downto 0);   

  -- clkout mux output
  -- added gfifo
  signal clkoutmux_clkout     : std_logic;
  signal clkoutmux_clkout_pre : std_logic;

  -- MAIN CLOCKS
  SIGNAL rxrdclk_mux1             :  std_logic;   
  SIGNAL rxrdclk_mux1_by2         :  std_logic;   
  SIGNAL rxrdclkmux1_c0           :  std_logic;   
  SIGNAL rxrdclkmux1_c1           :  std_logic;   
  SIGNAL rxrdclkmux2_c0           :  std_logic;   
  SIGNAL rxrdclkmux2_c1           :  std_logic;  
  
  SIGNAL clk2_mux1                :  std_logic;   
  SIGNAL clk2mux1_c0              :  std_logic;   
  SIGNAL clk2mux1_c1              :  std_logic;   
  
  SIGNAL rcvd_clk                 :  std_logic;   
  SIGNAL clk_1                    :  std_logic;   
  SIGNAL clk_2                    :  std_logic;   
  SIGNAL rx_rd_clk                :  std_logic;   
  SIGNAL rx_rd_clk_mux            :  std_logic;  

-- sub module componet declaration
component stratixgx_hssi_rx_serdes 
  generic (
    channel_width	: integer := 10;
    rlv_length		: integer := 1;
    run_length_enable	: String := "false";
    cruclk_period	: integer :=5000; 
    cruclk_multiplier	: integer :=4; 
    use_cruclk_divider	: String := "false";
    use_double_data_mode :  string  := "false"    
    );
  
  port (
    datain		: in std_logic := '0';
    cruclk		: in std_logic := '0';
    areset		: in std_logic := '0';
    feedback		: in std_logic := '0';
    fbkcntl		: in std_logic := '0';
    ltr		    : in std_logic := '0';
    ltd		    : in std_logic := '0';
    dataout		: out std_logic_vector(9 downto 0);
    clkout		: out std_logic;
    rlv			: out std_logic;
    lock		: out std_logic;
    freqlock		: out std_logic;
    signaldetect        : out std_logic
    );

end component;

component stratixgx_hssi_word_aligner 
  generic	(
    channel_width       : integer := 10;
    align_pattern_length: integer := 10;
    infiniband_invalid_code : integer := 0;
    align_pattern 	: string := "0000000101111100";
    synchronization_mode: string := "XAUI";
    use_8b_10b_mode	: string := "true";
    use_auto_bit_slip   : string := "true"
    );
  port	(
    datain		: in std_logic_vector(9 downto 0) := "0000000000"; 
    clk			: in std_logic := '0'; 
    softreset		: in std_logic := '0'; 
    enacdet		: in std_logic := '0'; 
    bitslip		: in std_logic := '0'; 
    a1a2size		: in std_logic := '0'; 
    aligneddata		: out std_logic_vector(9 downto 0); 
    aligneddatapre	: out std_logic_vector(9 downto 0); 
    invalidcode		: out std_logic;
    invalidcodepre	: out std_logic;
    syncstatus		: out std_logic;
    syncstatusdeskew	: out std_logic;
    disperr		: out std_logic;
    disperrpre		: out std_logic;
    patterndetect	: out std_logic;
    patterndetectpre	: out std_logic
    );

end component;

component stratixgx_deskew_fifo
  port 
	(
    datain        : IN std_logic_vector(9 DOWNTO 0) := "0000000000";   
    errdetectin   : IN std_logic := '0';   
    syncstatusin  : IN std_logic := '0';   
    disperrin     : IN std_logic := '0';   
    patterndetectin : IN std_logic := '0';   
    writeclock	  : IN std_logic := '0';   
    readclock	  : IN std_logic := '0';   
    adetectdeskew : OUT std_logic := '0';  
    fiforesetrd   : IN std_logic := '0';   
    enabledeskew  : IN std_logic := '0';   
    reset         : IN std_logic := '0';   
    dataout       : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
    dataoutpre    : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
    errdetect     : OUT std_logic := '0';   
    syncstatus    : OUT std_logic := '0';   
    disperr       : OUT std_logic := '0';   
    patterndetect : OUT std_logic := '0';   
    errdetectpre  : OUT std_logic := '0';   
    syncstatuspre : OUT std_logic := '0';   
    disperrpre    : OUT std_logic := '0';   
    patterndetectpre : OUT std_logic := '0';   
    rdalign       : OUT std_logic := '0'
    );  

end component;

component stratixgx_comp_fifo
  GENERIC (
    use_rate_match_fifo     : string  := "true";
    rate_matching_fifo_mode : string  := "xaui";
    use_channel_align       : string  := "true";
    for_engineering_sample_device    : String := "true"; -- new in 3.0 SP2 
    channel_num             : integer := 0
    );
   port (
     datain                  : IN std_logic_vector(9 DOWNTO 0);   
     datainpre               : IN std_logic_vector(9 DOWNTO 0);   
     reset                   : IN std_logic;   
     errdetectin             : IN std_logic;   
     syncstatusin            : IN std_logic;   
     disperrin               : IN std_logic;   
     patterndetectin         : IN std_logic;   
     errdetectinpre          : IN std_logic;   
     syncstatusinpre         : IN std_logic;   
     disperrinpre            : IN std_logic;   
     patterndetectinpre      : IN std_logic;   
     writeclk                : IN std_logic;   
     readclk                 : IN std_logic;   
     re                      : IN std_logic;   
     we                      : IN std_logic;   
     fifordin                : IN std_logic;   
     disablefifordin         : IN std_logic;   
     disablefifowrin         : IN std_logic;   
     alignstatus             : IN std_logic;   
     dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
     errdetectout            : OUT std_logic;   
     syncstatus              : OUT std_logic;   
     disperr                 : OUT std_logic;   
     patterndetect	      : OUT std_logic;   
     codevalid               : OUT std_logic;   
     fifofull                : OUT std_logic;   
     fifoalmostful           : OUT std_logic;   
     fifoempty               : OUT std_logic;   
     fifoalmostempty         : OUT std_logic;   
     disablefifordout        : OUT std_logic;   
     disablefifowrout        : OUT std_logic;   
     fifordout               : OUT std_logic
     );   

end component;

component stratixgx_8b10b_decoder 
  port (
    clk         : in std_logic := '0'; 
    reset       : in std_logic := '0'; -- reset the decoder
    errdetectin : in std_logic := '0';
    syncstatusin: in std_logic := '0';
    disperrin   : in std_logic := '0';
    patterndetectin : in std_logic := '0';
    datainvalid : in std_logic := '0';
    datain      : in std_logic_vector(9 downto 0) := "0000000000"; 
    valid       : out std_logic := '1'; -- valid decode
    dataout     : out std_logic_vector(7 downto 0) := "00000000";  
    tenBdata    : OUT std_logic_vector(9 DOWNTO 0) := "0000000000";   
    errdetect   : out std_logic := '0';
    syncstatus  : out std_logic := '0';
    disperr     : out std_logic := '0';
    patterndetect : out std_logic := '0';
    kout        : out std_logic := '0'; -- high if decode of control word 
    rderr       : out std_logic := '0'; -- running disparity error
    decdatavalid: out std_logic := '0';
    xgmdatavalid: out std_logic := '0';
    xgmrunningdisp : out std_logic := '0';
    xgmctrldet  : out std_logic := '0';
    xgmdataout  : out std_logic_vector(7 downto 0) := "00000000"
    );
end component;

component stratixgx_rx_core
   GENERIC (
      channel_width                  :  integer := 10;    
      use_double_data_mode           :  string  := "false";    
      use_channel_align              :  string  := "false";    
      use_8b_10b_mode                :  string  := "true";    
      align_pattern						 :  string  := "0000000000000000";
      synchronization_mode           :  string  := "none");
   PORT (
      reset                   : IN std_logic;   
      writeclk                : IN std_logic;   
      readclk                 : IN std_logic;   
      errdetectin             : IN std_logic;   
      patterndetectin         : IN std_logic;   
      decdatavalid            : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      post8b10b               : IN std_logic_vector(9 DOWNTO 0);   
      datain                  : IN std_logic_vector(9 DOWNTO 0);   
      xgmctrlin               : IN std_logic;   
      ctrldetectin            : IN std_logic;   
      syncstatusin            : IN std_logic;   
      disparityerrin          : IN std_logic;   
      syncstatus              : OUT std_logic_vector(1 DOWNTO 0);   
      errdetect               : OUT std_logic_vector(1 DOWNTO 0);   
      ctrldetect              : OUT std_logic_vector(1 DOWNTO 0);   
      disparityerr            : OUT std_logic_vector(1 DOWNTO 0);   
      patterndetect           : OUT std_logic_vector(1 DOWNTO 0);   
      dataout                 : OUT std_logic_vector(19 DOWNTO 0);   
      a1a2sizeout             : OUT std_logic_vector(1 DOWNTO 0);   
      clkout                  : OUT std_logic);   
end component;

component stratixgx_hssi_mux4 
   PORT (
      Y                       : OUT std_logic;   
      I0                      : IN std_logic;   
      I1                      : IN std_logic;   
      I2                      : IN std_logic;   
      I3                      : IN std_logic;   
      C0                      : IN std_logic;   
      C1                      : IN std_logic);   
END component;

component stratixgx_hssi_divide_by_two 
  GENERIC (
    divide                  :  string := "true");
  PORT (
    reset                   : IN std_logic := '0';   
    clkin                   : IN std_logic;   
    clkout                  : OUT std_logic);   
END component;

-- end of sub module componet declaration

begin
	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (datain_ipd, datain, tipd_datain);
		VitalWireDelay (cruclk_ipd, cruclk, tipd_cruclk);
		VitalWireDelay (pllclk_ipd, pllclk, tipd_pllclk);
		VitalWireDelay (masterclk_ipd, masterclk, tipd_masterclk);
		VitalWireDelay (coreclk_ipd, coreclk, tipd_coreclk);
		VitalWireDelay (softreset_ipd, softreset, tipd_softreset);
		VitalWireDelay (serialfdbk_ipd, serialfdbk, tipd_serialfdbk);
		VitalWireDelay (analogreset_ipd, analogreset, tipd_analogreset);
		VitalWireDelay (locktorefclk_ipd, locktorefclk, tipd_locktorefclk);
		VitalWireDelay (locktodata_ipd, locktodata, tipd_locktodata);

		VitalWireDelay (equalizerctrl_ipd(0), equalizerctrl(0), tipd_equalizerctrl(0));
		VitalWireDelay (equalizerctrl_ipd(1), equalizerctrl(1), tipd_equalizerctrl(1));
		VitalWireDelay (equalizerctrl_ipd(2), equalizerctrl(2), tipd_equalizerctrl(2));

		VitalWireDelay (parallelfdbk_ipd(0), parallelfdbk(0), tipd_parallelfdbk(0));
		VitalWireDelay (parallelfdbk_ipd(1), parallelfdbk(1), tipd_parallelfdbk(1));
		VitalWireDelay (parallelfdbk_ipd(2), parallelfdbk(2), tipd_parallelfdbk(2));
		VitalWireDelay (parallelfdbk_ipd(3), parallelfdbk(3), tipd_parallelfdbk(3));
		VitalWireDelay (parallelfdbk_ipd(4), parallelfdbk(4), tipd_parallelfdbk(4));
		VitalWireDelay (parallelfdbk_ipd(5), parallelfdbk(5), tipd_parallelfdbk(5));
		VitalWireDelay (parallelfdbk_ipd(6), parallelfdbk(6), tipd_parallelfdbk(6));
		VitalWireDelay (parallelfdbk_ipd(7), parallelfdbk(7), tipd_parallelfdbk(7));
		VitalWireDelay (parallelfdbk_ipd(8), parallelfdbk(8), tipd_parallelfdbk(8));
		VitalWireDelay (parallelfdbk_ipd(9), parallelfdbk(9), tipd_parallelfdbk(9));

		VitalWireDelay (post8b10b_ipd(0), post8b10b(0), tipd_post8b10b(0));
		VitalWireDelay (post8b10b_ipd(1), post8b10b(1), tipd_post8b10b(1));
		VitalWireDelay (post8b10b_ipd(2), post8b10b(2), tipd_post8b10b(2));
		VitalWireDelay (post8b10b_ipd(3), post8b10b(3), tipd_post8b10b(3));
		VitalWireDelay (post8b10b_ipd(4), post8b10b(4), tipd_post8b10b(4));
		VitalWireDelay (post8b10b_ipd(5), post8b10b(5), tipd_post8b10b(5));
		VitalWireDelay (post8b10b_ipd(6), post8b10b(6), tipd_post8b10b(6));
		VitalWireDelay (post8b10b_ipd(7), post8b10b(7), tipd_post8b10b(7));
                VitalWireDelay (post8b10b_ipd(8), post8b10b(8), tipd_post8b10b(8));
                VitalWireDelay (post8b10b_ipd(9), post8b10b(9), tipd_post8b10b(9));

		VitalWireDelay (slpbk_ipd, slpbk, tipd_slpbk);
		VitalWireDelay (bitslip_ipd, bitslip, tipd_bitslip);
		VitalWireDelay (a1a2size_ipd, a1a2size, tipd_a1a2size);
		VitalWireDelay (enacdet_ipd, enacdet, tipd_enacdet);
		VitalWireDelay (we_ipd, we, tipd_we);
		VitalWireDelay (re_ipd, re, tipd_re);
		VitalWireDelay (alignstatus_ipd, alignstatus, tipd_alignstatus);
		VitalWireDelay (disablefifordin_ipd, disablefifordin, tipd_disablefifordin);
		VitalWireDelay (disablefifowrin_ipd, disablefifowrin, tipd_disablefifowrin);
		VitalWireDelay (fifordin_ipd, fifordin, tipd_fifordin);
		VitalWireDelay (enabledeskew_ipd, enabledeskew, tipd_enabledeskew);
		VitalWireDelay (fiforesetrd_ipd, fiforesetrd, tipd_fiforesetrd);

		VitalWireDelay (xgmdatain_ipd(0), xgmdatain(0), tipd_xgmdatain(0));
		VitalWireDelay (xgmdatain_ipd(1), xgmdatain(1), tipd_xgmdatain(1));
		VitalWireDelay (xgmdatain_ipd(2), xgmdatain(2), tipd_xgmdatain(2));
		VitalWireDelay (xgmdatain_ipd(3), xgmdatain(3), tipd_xgmdatain(3));
		VitalWireDelay (xgmdatain_ipd(4), xgmdatain(4), tipd_xgmdatain(4));
		VitalWireDelay (xgmdatain_ipd(5), xgmdatain(5), tipd_xgmdatain(5));
		VitalWireDelay (xgmdatain_ipd(6), xgmdatain(6), tipd_xgmdatain(6));
		VitalWireDelay (xgmdatain_ipd(7), xgmdatain(7), tipd_xgmdatain(7));
		VitalWireDelay (xgmctrlin_ipd, xgmctrlin, tipd_xgmctrlin);
	end block;

-- generate internal inut signals

reset_int <= softreset_ipd;

-- word_align inputs
wa_datain  <= parallelfdbk when (use_parallel_feedback = "true") else serdes_dataout;
wa_clk     <= rcvd_clk;
wa_enacdet <= enacdet_ipd; 
wa_bitslip <= bitslip_ipd; 
wa_a1a2size <= a1a2size_ipd; 

-- deskew FIFO inputs
dsfifo_datain       <= wa_aligneddata WHEN (use_symbol_align = "true") ELSE idle_bus;     
dsfifo_errdetectin  <= wa_invalidcode WHEN (use_symbol_align = "true") ELSE '0';   
dsfifo_syncstatusin <= wa_syncstatus WHEN (use_symbol_align = "true") ELSE '1';  
dsfifo_disperrin    <= wa_disperr WHEN (use_symbol_align = "true") ELSE '0';
dsfifo_patterndetectin <= wa_patterndetect WHEN (use_symbol_align = "true") ELSE '0';
dsfifo_writeclock   <= rcvd_clk;
dsfifo_readclock    <= clk_1;
dsfifo_fiforesetrd  <= fiforesetrd_ipd; 
dsfifo_enabledeskew <= enabledeskew_ipd;

-- comp FIFO inputs
cmfifo_datain <= dsfifo_dataout WHEN (use_channel_align = "true") ELSE wa_aligneddata WHEN (use_symbol_align = "true") ELSE serdes_dataout;

cmfifo_datainpre <= dsfifo_dataoutpre WHEN (use_channel_align = "true") ELSE wa_aligneddatapre WHEN (use_symbol_align = "true") ELSE idle_bus;

cmfifo_invalidcodein <= dsfifo_errdetect WHEN (use_channel_align = "true") ELSE wa_invalidcode WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_syncstatusin <= dsfifo_syncstatus WHEN (use_channel_align = "true") ELSE wa_syncstatus WHEN (use_symbol_align = "true") ELSE '1';

cmfifo_disperrin <= dsfifo_disperr WHEN (use_channel_align = "true") ELSE wa_disperr WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_patterndetectin <= dsfifo_patterndetect WHEN (use_channel_align = "true") ELSE wa_patterndetect WHEN (use_symbol_align = "true") ELSE '1';

cmfifo_invalidcodeinpre <= dsfifo_errdetectpre WHEN (use_channel_align = "true") ELSE wa_invalidcodepre WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_syncstatusinpre <= dsfifo_syncstatuspre WHEN (use_channel_align = "true") ELSE wa_syncstatusdeskew WHEN (use_symbol_align = "true") ELSE '1';

cmfifo_disperrinpre <= dsfifo_disperrpre WHEN (use_channel_align = "true") ELSE wa_disperrpre WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_patterndetectinpre <= dsfifo_patterndetectpre WHEN (use_channel_align = "true") ELSE wa_patterndetectpre WHEN (use_symbol_align = "true") ELSE '0';

cmfifo_writeclk <= clk_1;

cmfifo_readclk <=  clk_2;

cmfifo_alignstatus <= alignstatus_ipd;
cmfifo_re <= re_ipd;
cmfifo_we <= we_ipd;
cmfifo_fifordin <= fifordin_ipd;
cmfifo_disablefifordin <= disablefifordin_ipd; 
cmfifo_disablefifowrin <= disablefifowrin_ipd;

-- 8B10B decoder inputs
decoder_clk  <= clk_2;
decoder_datain <= cmfifo_dataout WHEN (use_rate_match_fifo = "true") ELSE dsfifo_dataout WHEN (use_channel_align = "true") ELSE wa_aligneddata WHEN (use_symbol_align = "true") ELSE serdes_dataout;   

decoder_errdetectin <= cmfifo_invalidcode WHEN (use_rate_match_fifo = "true") ELSE dsfifo_errdetect WHEN (use_channel_align = "true") ELSE wa_invalidcode WHEN (use_symbol_align = "true") ELSE '0';   

decoder_syncstatusin <= cmfifo_syncstatus WHEN (use_rate_match_fifo = "true") ELSE dsfifo_syncstatus WHEN (use_channel_align = "true") ELSE wa_syncstatus WHEN (use_symbol_align = "true") ELSE '1';   

decoder_disperrin <= cmfifo_disperr WHEN (use_rate_match_fifo = "true") ELSE dsfifo_disperr WHEN (use_channel_align = "true") ELSE wa_disperr WHEN (use_symbol_align = "true") ELSE '0';   

decoder_patterndetectin <= cmfifo_patterndetect WHEN (use_rate_match_fifo = "true") ELSE dsfifo_patterndetect WHEN (use_channel_align = "true") ELSE wa_patterndetect WHEN (use_symbol_align = "true") ELSE '0';   

decoder_indatavalid <= cmfifo_datavalid WHEN (use_rate_match_fifo = "true") ELSE '1';   

-- rx_core inputs
core_datain <= post8b10b when (use_post8b10b_feedback = "true") else ("00" & decoder_dataout) WHEN (use_8b_10b_mode = "true") ELSE decoder_tenBdata;
core_writeclk <= clk_2;
core_readclk <= rx_rd_clk;
core_decdatavalid <= decoder_decdatavalid WHEN (use_8b_10b_mode = "true") ELSE '1'; 
core_xgmdatain <= xgmdatain_ipd;
core_xgmctrlin <= xgmctrlin_ipd;
core_post8b10b <= post8b10b_ipd;
core_syncstatusin <= decoder_syncstatus;
core_errdetectin <= decoder_errdetect;
core_ctrldetectin <= decoder_ctrldetect;
core_disparityerrin <= decoder_disperr;
core_patterndetectin <= decoder_patterndetect;

   rcvd_clk <= pllclk_ipd WHEN (use_parallel_feedback = "true") ELSE serdes_clkout ;
   clk_1 <= pllclk_ipd WHEN (use_parallel_feedback = "true") ELSE masterclk_ipd WHEN (use_channel_align = "true") ELSE serdes_clkout ;
   
   -- added gfifo
   clk_2 <= coreclk_ipd WHEN (clk_out_mode_reference = "false") ELSE clk2_mux1 ;
   rx_rd_clk <= coreclk_ipd WHEN (clk_out_mode_reference = "false") ELSE rx_rd_clk_mux ;

clk2mux1 : stratixgx_hssi_mux4 
      PORT MAP (
         Y => clk2_mux1,
         I0 => serdes_clkout,
         I1 => masterclk_ipd,
         I2 => gnd,
         I3 => pllclk_ipd,
         C0 => clk2mux1_c0,
         C1 => clk2mux1_c1);   
   
   clk2mux1_c0 <= '1' WHEN (use_parallel_feedback = "true") OR (use_channel_align = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;
   clk2mux1_c1 <= '1' WHEN (use_parallel_feedback = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;

   rxrdclkmux1 : stratixgx_hssi_mux4 
      PORT MAP (
         Y => rxrdclk_mux1,
         I0 => serdes_clkout,
         I1 => masterclk_ipd,
         I2 => gnd,
         I3 => pllclk_ipd,
         C0 => rxrdclkmux1_c0,
         C1 => rxrdclkmux1_c1);   

   rxrdclkmux1_c1 <= '1' WHEN (use_parallel_feedback = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;
   rxrdclkmux1_c0 <= '1' WHEN (use_parallel_feedback = "true") OR (use_channel_align = "true") OR (use_rate_match_fifo = "true") ELSE '0' ;

   rxrdclkmux2 : stratixgx_hssi_mux4 
      PORT MAP (
         Y => rx_rd_clk_mux,
         I0 => coreclk_ipd,
         I1 => gnd,
         I2 => rxrdclk_mux1_by2,
         I3 => rxrdclk_mux1,
         C0 => rxrdclkmux2_c0,
         C1 => rxrdclkmux2_c1);   
   
   rxrdclkmux2_c1 <= '1' WHEN (send_reverse_parallel_feedback = "true") ELSE '0' ;
   rxrdclkmux2_c0 <= '1' WHEN ((use_double_data_mode = "false") AND (send_reverse_parallel_feedback = "true")) ELSE '0' ;

   rxrdclkmux_by2 : stratixgx_hssi_divide_by_two 
      GENERIC MAP (
         divide => use_double_data_mode)
      PORT MAP (
         clkin => rxrdclk_mux1,
         clkout => rxrdclk_mux1_by2);   

-- sub modules
s_rx_serdes :	stratixgx_hssi_rx_serdes
					generic map (
									channel_width => deserialization_factor,
									rlv_length => run_length,
									run_length_enable => run_length_enable,
									cruclk_period => cruclk_period,
									cruclk_multiplier => cruclk_multiplier,
	                        use_cruclk_divider => use_cruclk_divider,
                           use_double_data_mode => use_double_data_mode
									)
					port map (
								datain => datain,
							 	cruclk => cruclk,
								areset => analogreset_ipd,
								feedback => serialfdbk,
								fbkcntl => slpbk,
                                ltr => locktorefclk,
                                ltd => locktodata,
								dataout => serdes_dataout,
								clkout => serdes_clkout,
								rlv => serdes_rlv,
								lock => serdes_lock,
								freqlock => serdes_freqlock,
								signaldetect => serdes_signaldetect
								);
				
s_word_align :	stratixgx_hssi_word_aligner
  generic map	(
    channel_width => deserialization_factor,
    align_pattern_length => align_pattern_length,
    infiniband_invalid_code => infiniband_invalid_code,
    align_pattern => align_pattern,
    synchronization_mode => synchronization_mode,
    use_auto_bit_slip => use_auto_bit_slip
    )
  port map	(	
    datain => wa_datain, 
    clk => wa_clk, 
    softreset => reset_int, 
    enacdet => wa_enacdet, 
    bitslip => wa_bitslip, 
    a1a2size => wa_a1a2size, 
    aligneddata => wa_aligneddata, 
    aligneddatapre => wa_aligneddatapre, 
    invalidcode => wa_invalidcode, 
    invalidcodepre => wa_invalidcodepre, 
    syncstatus => wa_syncstatus, 
    syncstatusdeskew => wa_syncstatusdeskew, 
    disperr => wa_disperr, 
    disperrpre => wa_disperrpre, 
    patterndetect => wa_patterndetect,
    patterndetectpre => wa_patterndetectpre
    );

s_dsfifo :	stratixgx_deskew_fifo 
  port map	(
    datain => dsfifo_datain,
    errdetectin => dsfifo_errdetectin,
    syncstatusin => dsfifo_syncstatusin,
    disperrin => dsfifo_disperrin,   
    patterndetectin => dsfifo_patterndetectin,
    writeclock => dsfifo_writeclock,  
    readclock => dsfifo_readclock,   
    adetectdeskew => dsfifo_adetectdeskew,
    fiforesetrd => dsfifo_fiforesetrd,
    enabledeskew => dsfifo_enabledeskew,
    reset => reset_int,
    dataout => dsfifo_dataout,   
    dataoutpre => dsfifo_dataoutpre,   
    errdetect => dsfifo_errdetect,    
    syncstatus => dsfifo_syncstatus,
    disperr => dsfifo_disperr,
    patterndetect => dsfifo_patterndetect,
    errdetectpre => dsfifo_errdetectpre,    
    syncstatuspre => dsfifo_syncstatuspre,
    disperrpre => dsfifo_disperrpre,
    patterndetectpre => dsfifo_patterndetectpre,
    rdalign => dsfifo_rdalign
    );

s_cmfifo :	stratixgx_comp_fifo
  generic map (
    use_rate_match_fifo     => use_rate_match_fifo,
    rate_matching_fifo_mode => rate_matching_fifo_mode,
    use_channel_align       => use_channel_align,
    for_engineering_sample_device  => for_engineering_sample_device, -- new in 3.0 SP2 
    channel_num             => channel_num
    )
  port map (
    datain => cmfifo_datain,
    datainpre => cmfifo_datainpre,
    reset => reset_int,
    errdetectin => cmfifo_invalidcodein, 
    syncstatusin => cmfifo_syncstatusin,
    disperrin => cmfifo_disperrin,
    patterndetectin => cmfifo_patterndetectin,
    errdetectinpre => cmfifo_invalidcodeinpre, 
    syncstatusinpre => cmfifo_syncstatusinpre,
    disperrinpre => cmfifo_disperrinpre,
    patterndetectinpre => cmfifo_patterndetectinpre,
    writeclk => cmfifo_writeclk,
    readclk => cmfifo_readclk,
    re => cmfifo_re,
    we => cmfifo_we,
    fifordin => cmfifo_fifordin,
    disablefifordin => cmfifo_disablefifordin,
    disablefifowrin => cmfifo_disablefifowrin,
    alignstatus => cmfifo_alignstatus,
    dataout => cmfifo_dataout,
    errdetectout => cmfifo_invalidcode,
    syncstatus => cmfifo_syncstatus,
    disperr => cmfifo_disperr,
    patterndetect => cmfifo_patterndetect,
    codevalid => cmfifo_datavalid,
    fifofull => cmfifo_fifofull,
    fifoalmostful => cmfifo_fifoalmostfull,
    fifoempty => cmfifo_fifoempty,
    fifoalmostempty => cmfifo_fifoalmostempty,
    disablefifordout => cmfifo_disablefifordout,
    disablefifowrout => cmfifo_disablefifowrout,
    fifordout => cmfifo_fifordout
    );

s_decoder :	stratixgx_8b10b_decoder
  port map	( 
    clk => decoder_clk, 
    reset => reset_int, 
    errdetectin => decoder_errdetectin, 
    syncstatusin => decoder_syncstatusin, 
    disperrin => decoder_disperrin, 
    patterndetectin => decoder_patterndetectin, 
    datainvalid => decoder_indatavalid, 
    datain => decoder_datain, 
    valid => decoder_valid, 
    dataout => decoder_dataout,
    tenBdata => decoder_tenBdata,
    errdetect => decoder_errdetect,
    syncstatus => decoder_syncstatus,
    disperr => decoder_disperr,
    patterndetect => decoder_patterndetect,
    kout => decoder_ctrldetect,
    rderr => decoder_rderr,
    decdatavalid => decoder_decdatavalid,
    xgmdatavalid => decoder_xgmdatavalid,
    xgmrunningdisp => decoder_xgmrunningdisp,
    xgmctrldet => decoder_xgmctrldet,
    xgmdataout => decoder_xgmdataout
    );

s_rx_clkout_mux : stratixgx_hssi_divide_by_two 
   GENERIC MAP (
      divide => use_double_data_mode)
   PORT MAP (
      reset => reset_int,
      clkin => rxrdclk_mux1,
      clkout => clkoutmux_clkout_pre
   );   

s_rx_core :	stratixgx_rx_core 
generic map (
  channel_width => deserialization_factor,
  use_double_data_mode => use_double_data_mode,
  use_channel_align    => use_channel_align,
  use_8b_10b_mode      => use_8b_10b_mode,
  align_pattern	     => align_pattern,
  synchronization_mode => synchronization_mode
  )
  port map
  (
    reset => reset_int,
    datain => core_datain,
    writeclk => core_writeclk,
    readclk => core_readclk,
    decdatavalid => core_decdatavalid,
    xgmdatain => core_xgmdatain,
    xgmctrlin => core_xgmctrlin,
    post8b10b => core_post8b10b,
    syncstatusin => core_syncstatusin,
    errdetectin => core_errdetectin,
    ctrldetectin => core_ctrldetectin,
    disparityerrin => core_disparityerrin,
    patterndetectin => core_patterndetectin,
    dataout => core_dataout,
    syncstatus => core_syncstatus,
    errdetect => core_errdetect,
    ctrldetect => core_ctrldetect,
    disparityerr => core_disparityerr,
	 patterndetect => core_patterndetect,
	 a1a2sizeout => core_a1a2sizeout,
    clkout => core_clkout
  );   

dataout_tmp <= core_dataout;

-- output from clkout mux
-- - added gfifo
clkoutmux_clkout <= serdes_clkout WHEN ((use_parallel_feedback = "false") AND (clk_out_mode_reference = "false")) ELSE clkoutmux_clkout_pre;

clkout <= clkoutmux_clkout;

VITAL: process (pllclk_ipd, coreclk_ipd, dataout_tmp, core_syncstatus, core_patterndetect,
    cmfifo_fifofull, cmfifo_fifoempty, cmfifo_fifoalmostfull, cmfifo_fifoalmostempty, re_ipd,
	core_a1a2sizeout,
	core_ctrldetect, core_errdetect, core_disparityerr)

variable Tviol_datain_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(19 downto 0);
variable syncstatus_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable patterndetect_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable ctrldetect_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable errdetect_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable disperr_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable a1a2sizeout_VitalGlitchDataArray : VitalGlitchDataArrayType(1 downto 0);
variable fifofull_VitalGlitchData: VitalGlitchDataType;
variable fifoempty_VitalGlitchData: VitalGlitchDataType;
variable fifoalmostfull_VitalGlitchData: VitalGlitchDataType;
variable fifoalmostempty_VitalGlitchData: VitalGlitchDataType;
variable Tviol_re_clk : std_ulogic := '0';
variable TimingData_re_clk : VitalTimingDataType := VitalTimingDataInit;

begin


	------------------------
	--  Timing Check Section
	------------------------

	if (TimingChecksOn) then

		VitalSetupHoldCheck (
			Violation       => Tviol_re_clk,
			TimingData      => TimingData_re_clk,
			TestSignal      => re_ipd,
			TestSignalName  => "RE",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_re_coreclk_noedge_posedge,
			SetupLow        => tsetup_re_coreclk_noedge_posedge,
			HoldHigh        => thold_re_coreclk_noedge_posedge,
			HoldLow         => thold_re_coreclk_noedge_posedge,
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_RECEIVER",
			XOn             => XOnChecks,
			MsgOn           => MsgOnChecks );
   end if;



   ----------------------
   --  Path Delay Section
   ----------------------


   VitalPathDelay01 (
      OutSignal => fifofull,
      OutSignalName => "FIFOFULL",
      OutTemp => cmfifo_fifofull,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifofull_posedge, TRUE)),
      GlitchData => fifofull_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => fifoempty,
      OutSignalName => "FIFOEMPTY",
      OutTemp => cmfifo_fifoempty,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifoempty_posedge, TRUE)),
      GlitchData => fifoempty_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => fifoalmostfull,
      OutSignalName => "FIFOALMOSTFULL",
      OutTemp => cmfifo_fifoalmostfull,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifoalmostfull_posedge, TRUE)),
      GlitchData => fifoalmostfull_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => fifoalmostempty,
      OutSignalName => "FIFOALMOSTEMPTY",
      OutTemp => cmfifo_fifoalmostempty,
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_fifoalmostempty_posedge, TRUE)),
      GlitchData => fifoalmostempty_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(0),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(0),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(0), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(0),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(1),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(1),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(1), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(1),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(2),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(2),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(2), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(2),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(3),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(3),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(3), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(3),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(4),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(4),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(4), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(4),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(5),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(5),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(5), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(5),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(6),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(6),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(6), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(6),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(7),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(7),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(7), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(7),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(8),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(8),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(8), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(8),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(9),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(9),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(9), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(9),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(10),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(10),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(10), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(10),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(11),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(11),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(11), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(11),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(12),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(12),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(12), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(12),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(13),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(13),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(13), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(13),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(14),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(14),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(14), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(14),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(15),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(15),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(15), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(15),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(16),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(16),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(16), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(16),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(17),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(17),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(17), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(17),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(18),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(18),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(18), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(18),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	VitalPathDelay01 (
		OutSignal => dataout(19),
		OutSignalName => "DATAOUT",
		OutTemp => dataout_tmp(19),
		Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_dataout_posedge(19), TRUE)),
		GlitchData => dataout_VitalGlitchDataArray(19),
		Mode => DefGlitchMode,
		XOn  => XOn,
		MsgOn  => MsgOn );

	-- control signals
   VitalPathDelay01 (
      OutSignal => syncstatus(0),
      OutSignalName => "SYNCSTATUS",
      OutTemp => core_syncstatus(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_syncstatus_posedge(0), TRUE)),
      GlitchData => syncstatus_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => syncstatus(1),
      OutSignalName => "SYNCSTATUS",
      OutTemp => core_syncstatus(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_syncstatus_posedge(1), TRUE)),
      GlitchData => syncstatus_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => patterndetect(0),
      OutSignalName => "patterndetect(0)",
      OutTemp => core_patterndetect(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_patterndetect_posedge(0), TRUE)),
      GlitchData => patterndetect_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => patterndetect(1),
      OutSignalName => "patterndetect(1)",
      OutTemp => core_patterndetect(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_patterndetect_posedge(1), TRUE)),
      GlitchData => patterndetect_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => ctrldetect(0),
      OutSignalName => "ctrldetect(0)",
      OutTemp => core_ctrldetect(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_ctrldetect_posedge(0), TRUE)),
      GlitchData => ctrldetect_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => ctrldetect(1),
      OutSignalName => "ctrldetect(1)",
      OutTemp => core_ctrldetect(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_ctrldetect_posedge(1), TRUE)),
      GlitchData => ctrldetect_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => errdetect(0),
      OutSignalName => "errdetect(0)",
      OutTemp => core_errdetect(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_errdetect_posedge(0), TRUE)),
      GlitchData => errdetect_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => errdetect(1),
      OutSignalName => "errdetect(1)",
      OutTemp => core_errdetect(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_errdetect_posedge(1), TRUE)),
      GlitchData => errdetect_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => disperr(0),
      OutSignalName => "disperr(0)",
      OutTemp => core_disparityerr(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_disperr_posedge(0), TRUE)),
      GlitchData => disperr_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => disperr(1),
      OutSignalName => "disperr(1)",
      OutTemp => core_disparityerr(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_disperr_posedge(1), TRUE)),
      GlitchData => disperr_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => a1a2sizeout(0),
      OutSignalName => "a1a2sizeout(0)",
      OutTemp => core_a1a2sizeout(0),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_a1a2sizeout_posedge(0), TRUE)),
      GlitchData => a1a2sizeout_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

   VitalPathDelay01 (
      OutSignal => a1a2sizeout(1),
      OutSignalName => "a1a2sizeout(1)",
      OutTemp => core_a1a2sizeout(1),
      Paths => (1 => (coreclk_ipd'last_event, tpd_coreclk_a1a2sizeout_posedge(1), TRUE)),
      GlitchData => a1a2sizeout_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

end process;


-- generate output signals

-- outputs from serdes
recovclkout <= serdes_clkout;
rlv <= serdes_rlv;
lock <= serdes_lock;
freqlock <= serdes_freqlock;
signaldetect <= serdes_signaldetect;

-- outputs from word_aligner
syncstatusdeskew <= wa_syncstatusdeskew;

-- outputs from deskew FIFO
adetectdeskew <= dsfifo_adetectdeskew;
rdalign <= dsfifo_rdalign;

-- outputs from comp FIFO
-- fifofull <= cmfifo_fifofull;
-- fifoalmostfull <= cmfifo_fifoalmostfull;
-- fifoempty <= cmfifo_fifoempty;
-- fifoalmostempty <= cmfifo_fifoalmostempty;
fifordout <= cmfifo_fifordout;
disablefifordout <= cmfifo_disablefifordout;
disablefifowrout <= cmfifo_disablefifowrout;

-- outputs from decoder
xgmctrldet <= decoder_xgmctrldet;
xgmrunningdisp <= decoder_xgmrunningdisp;
xgmdatavalid <= decoder_xgmdatavalid;
xgmdataout <= decoder_xgmdataout;

end vital_receiver_atom;

--
-- STRATIXGX_HSSI_TRANSMITTER
--

library IEEE, stratixgx_gxb,std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratixgx_gxb.hssi_pack.all;
use std.textio.all;

entity stratixgx_hssi_transmitter is
  generic (
    channel_num		: integer := 1;
    channel_width	: integer := 20;
    serialization_factor: integer := 10;
    use_8b_10b_mode	: String  := "false";
    use_double_data_mode: String  := "false";
    use_fifo_mode	: String  := "false";
    use_reverse_parallel_feedback : String := "false";
    force_disparity_mode: String  := "false";
    transmit_protocol	: String  := "none";
    use_vod_ctrl_signal : String := "false";
    use_preemphasis_ctrl_signal : String := "false";
    use_self_test_mode          : String := "false";
    self_test_mode          : integer  := 0;
    vod_ctrl_setting            : integer := 4;  
    preemphasis_ctrl_setting    : integer := 5;
    termination                 : integer := 0;
    TimingChecksOn	: Boolean := True;
    MsgOn		: Boolean := DefGlitchMsgOn;
    XOn			: Boolean := DefGlitchXOn;
    MsgOnChecks		: Boolean := DefMsgOnChecks;
    XOnChecks		: Boolean := DefXOnChecks;
    InstancePath	: String  := "*";
    tipd_datain         : VitalDelayArrayType01(19 downto 0) := (OTHERS => DefPropDelay01);
    tipd_pllclk		: VitalDelayType01 := DefpropDelay01;
    tipd_fastpllclk	: VitalDelayType01 := DefpropDelay01;
    tipd_coreclk	: VitalDelayType01 := DefpropDelay01;
    tipd_softreset	: VitalDelayType01 := DefpropDelay01;
    tipd_ctrlenable     : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tipd_forcedisparity : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
    tipd_serialdatain	: VitalDelayType01 := DefpropDelay01;
    tipd_xgmdatain	: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
    tipd_xgmctrl	: VitalDelayType01 := DefpropDelay01;
    tipd_srlpbk		: VitalDelayType01 := DefpropDelay01;
    tipd_analogreset	: VitalDelayType01 := DefpropDelay01;
    tipd_vodctrl	: VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
    tipd_preemphasisctrl: VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
    tsetup_datain_coreclk_noedge_posedge        : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_datain_coreclk_noedge_posedge         : VitalDelayArrayType(19 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_ctrlenable_coreclk_noedge_posedge    : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_ctrlenable_coreclk_noedge_posedge     : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_forcedisparity_coreclk_noedge_posedge: VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_forcedisparity_coreclk_noedge_posedge : VitalDelayArrayType(1 downto 0) := (OTHERS => DefSetupHoldCnst)
    );
  
  port (
    datain      : in std_logic_vector(19 downto 0);
    pllclk	: in std_logic := '0';
    fastpllclk	: in std_logic := '0';
    coreclk	: in std_logic := '0';
    softreset	: in std_logic := '0';
    ctrlenable	: in std_logic_vector(1 downto 0) := "00";
    forcedisparity : in std_logic_vector(1 downto 0) := "00";
    serialdatain   : in std_logic := '0';
    xgmdatain	: in std_logic_vector(7 downto 0) := "00000000";
    xgmctrl	: in std_logic := '0';
    srlpbk      : in std_logic := '0';
    devclrn	: in std_logic := '1';
    devpor	: in std_logic := '1';
    analogreset	: in std_logic := '0'; 
    vodctrl	: in std_logic_vector(2 downto 0) := "000";
    preemphasisctrl : in std_logic_vector(2 downto 0) := "000";
    dataout	: out std_logic;
    xgmdataout	: out std_logic_vector(7 downto 0);
    xgmctrlenable : out std_logic;
    rdenablesync  : out std_logic;
    parallelfdbkdata : out std_logic_vector(9 downto 0);
    pre8b10bdata     : out std_logic_vector(9 downto 0)
    );
end stratixgx_hssi_transmitter;

architecture vital_transmitter_atom of stratixgx_hssi_transmitter is
	signal datain_ipd : std_logic_vector(19 downto 0);
	signal pllclk_ipd  : std_logic;
	signal fastpllclk_ipd  : std_logic;
	signal coreclk_ipd  : std_logic;
	signal softreset_ipd  : std_logic;
	signal ctrlenable_ipd : std_logic_vector(1 downto 0);
	signal forcedisparity_ipd : std_logic_vector(1 downto 0);
	signal analogreset_ipd : std_logic;
	signal vodctrl_ipd : std_logic_vector(2 downto 0);
	signal preemphasisctrl_ipd : std_logic_vector(2 downto 0);
	signal serialdatain_ipd  : std_logic;
	signal xgmdatain_ipd : std_logic_vector(7 downto 0);
	signal xgmctrl_ipd  : std_logic;
	signal srlpbk_ipd  : std_logic;

	--constant signals
	signal vcc : std_logic := '1';
	signal gnd : std_logic := '0';
	signal idle_bus : std_logic_vector(9 downto 0) := "0000000000";

	--lower lever softreset 
	signal reset_int : std_logic;

	-- tx_core input/output signals
	signal core_datain : std_logic_vector(19 downto 0);
	signal core_writeclk : std_logic;
	signal core_readclk : std_logic;
	signal core_ctrlena : std_logic_vector(1 downto 0);
	signal core_forcedisp : std_logic_vector(1 downto 0);

	signal core_dataout : std_logic_vector(9 downto 0);
	signal core_forcedispout : std_logic;
	signal core_ctrlenaout : std_logic;
	signal core_rdenasync : std_logic;
	signal core_xgmctrlena : std_logic;
	signal core_xgmdataout : std_logic_vector(7 downto 0);
	signal core_pre8b10bdataout : std_logic_vector(9 downto 0);

	-- serdes input/output signals
	signal serdes_clk : std_logic;
	signal serdes_clk1 : std_logic;
	signal serdes_datain : std_logic_vector(9 downto 0);
	signal serdes_serialdatain : std_logic;
	signal serdes_srlpbk : std_logic;

	signal serdes_dataout : std_logic;

	-- encoder input/output signals
	signal encoder_clk : std_logic := '0'; 
	signal encoder_kin : std_logic := '0';  
	signal encoder_datain : std_logic_vector(7 downto 0) := "00000000";
   signal encoder_para : std_logic_vector(9 downto 0) := "0000000000";
   signal encoder_xgmdatain : std_logic_vector(7 downto 0) := "00000000";
   signal encoder_xgmctrl : std_logic := '0';

	signal encoder_dataout : std_logic_vector(9 downto 0) := "0000000000"; 
	signal encoder_rdout : std_logic := '0'; 

	-- internal signal for parallelfdbkdata
	signal parallelfdbkdata_tmp : std_logic_vector(9 downto 0);

   signal txclk : std_logic;
   signal pllclk_int : std_logic;
    
-- sub module component declaration

component stratixgx_tx_core
  GENERIC (
    use_double_data_mode           :  string := "false";    
    use_fifo_mode                  :  string := "true"; 
    channel_width                  :  integer := 10;   
    transmit_protocol              :  string  := "none";
    KCHAR                          :  std_logic := '0';    
    ECHAR                          :  std_logic := '0');
   port (
	      reset                   : IN std_logic;   
	      datain                  : IN std_logic_vector(19 DOWNTO 0);   
	      writeclk                : IN std_logic;   
	      readclk                 : IN std_logic;   
	      ctrlena                 : IN std_logic_vector(1 DOWNTO 0);   
	      forcedisp               : IN std_logic_vector(1 DOWNTO 0);   
	      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
	      forcedispout            : OUT std_logic;   
	      ctrlenaout              : OUT std_logic;   
	      rdenasync               : OUT std_logic;   
	      xgmctrlena              : OUT std_logic;   
	      xgmdataout              : OUT std_logic_vector(7 DOWNTO 0);   
	      pre8b10bdataout         : OUT std_logic_vector(9 DOWNTO 0)
		);   

end component;

component stratixgx_hssi_tx_serdes 
  generic (
    channel_width           : integer := 10
    );
  port (
    clk             : in std_logic := '0';
    clk1            : in std_logic := '0';
    datain          : in std_logic_vector(9 downto 0) := "0000000000";
    serialdatain	 : in std_logic := '0';
    srlpbk			 : in std_logic := '0';
    areset          : in std_logic := '0';
    dataout         : out std_logic
    );
end component;

component stratixgx_8b10b_encoder
   GENERIC (
      transmit_protocol              :  string := "none";    
      use_8b_10b_mode                :  string := "true";    
      force_disparity_mode           :  string := "false");
   PORT (
      clk                     : IN std_logic;   
      reset                   : IN std_logic;   
      xgmctrl                 : IN std_logic;   
      kin                     : IN std_logic;   
      xgmdatain               : IN std_logic_vector(7 DOWNTO 0);   
      datain                  : IN std_logic_vector(7 DOWNTO 0);   
      forcedisparity          : IN std_logic;   
      dataout                 : OUT std_logic_vector(9 DOWNTO 0);   
      parafbkdataout          : OUT std_logic_vector(9 DOWNTO 0));   
END component;

component stratixgx_hssi_divide_by_two 
  GENERIC (
    divide                  :  string := "true");
  PORT (
    reset                   : IN std_logic := '0';   
    clkin                   : IN std_logic;   
    clkout                  : OUT std_logic);   
END component;

-- end of sub module component declaration

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
		VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
		VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
		VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
		VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
		VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
		VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
		VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
		VitalWireDelay (datain_ipd(8), datain(8), tipd_datain(8));
		VitalWireDelay (datain_ipd(9), datain(9), tipd_datain(9));
		VitalWireDelay (datain_ipd(10), datain(10), tipd_datain(10));
		VitalWireDelay (datain_ipd(11), datain(11), tipd_datain(11));
		VitalWireDelay (datain_ipd(12), datain(12), tipd_datain(12));
		VitalWireDelay (datain_ipd(13), datain(13), tipd_datain(13));
		VitalWireDelay (datain_ipd(14), datain(14), tipd_datain(14));
		VitalWireDelay (datain_ipd(15), datain(15), tipd_datain(15));
		VitalWireDelay (datain_ipd(16), datain(16), tipd_datain(16));
		VitalWireDelay (datain_ipd(17), datain(17), tipd_datain(17));
		VitalWireDelay (datain_ipd(18), datain(18), tipd_datain(18));
		VitalWireDelay (datain_ipd(19), datain(19), tipd_datain(19));

		VitalWireDelay (pllclk_ipd, pllclk, tipd_pllclk);
		VitalWireDelay (fastpllclk_ipd, fastpllclk, tipd_fastpllclk);
		VitalWireDelay (coreclk_ipd, coreclk, tipd_coreclk);
		VitalWireDelay (softreset_ipd, softreset, tipd_softreset);

		VitalWireDelay (ctrlenable_ipd(0), ctrlenable(0), tipd_ctrlenable(0));
		VitalWireDelay (ctrlenable_ipd(1), ctrlenable(1), tipd_ctrlenable(1));

		VitalWireDelay (forcedisparity_ipd(0), forcedisparity(0), tipd_forcedisparity(0));
		VitalWireDelay (forcedisparity_ipd(1), forcedisparity(1), tipd_forcedisparity(1));

		VitalWireDelay (analogreset_ipd, analogreset, tipd_analogreset);
		VitalWireDelay (vodctrl_ipd(0), vodctrl(0), tipd_vodctrl(0));
		VitalWireDelay (vodctrl_ipd(1), vodctrl(1), tipd_vodctrl(1));
		VitalWireDelay (vodctrl_ipd(2), vodctrl(2), tipd_vodctrl(2));
		VitalWireDelay (preemphasisctrl_ipd(0), preemphasisctrl(0), tipd_preemphasisctrl(0));
		VitalWireDelay (preemphasisctrl_ipd(1), preemphasisctrl(1), tipd_preemphasisctrl(1));
		VitalWireDelay (preemphasisctrl_ipd(2), preemphasisctrl(2), tipd_preemphasisctrl(2));

		VitalWireDelay (serialdatain_ipd, serialdatain, tipd_serialdatain);

		VitalWireDelay (xgmdatain_ipd(0), xgmdatain(0), tipd_xgmdatain(0));
		VitalWireDelay (xgmdatain_ipd(1), xgmdatain(1), tipd_xgmdatain(1));
		VitalWireDelay (xgmctrl_ipd, xgmctrl, tipd_xgmctrl);
		VitalWireDelay (srlpbk_ipd, srlpbk, tipd_srlpbk);
	end block;

-- generate internal inut signals

    txclk_block : stratixgx_hssi_divide_by_two 
      GENERIC MAP (
        divide => use_double_data_mode)
      PORT MAP (
        clkin => pllclk_ipd,
        clkout => pllclk_int);   

    txclk <= pllclk_int when use_reverse_parallel_feedback = "true" else coreclk_ipd;
        
reset_int <= softreset_ipd;

-- core_interface inputs
core_datain <= datain_ipd;
core_writeclk <= txclk;
core_readclk <= pllclk_ipd;
core_ctrlena <= ctrlenable_ipd;
core_forcedisp <= forcedisparity_ipd;

-- encoder inputs
encoder_clk <= pllclk_ipd;
encoder_kin <=  core_ctrlenaout; 
encoder_datain <= core_dataout(7 downto 0);
encoder_xgmdatain <= xgmdatain(7 downto 0);
encoder_xgmctrl <= xgmctrl_ipd;

-- serdes inputs
serdes_clk <= fastpllclk_ipd;
serdes_clk1 <= pllclk_ipd;
serdes_datain <= encoder_dataout WHEN (use_8b_10b_mode = "true") ELSE core_dataout;
serdes_serialdatain <= serialdatain_ipd;
serdes_srlpbk <= srlpbk_ipd;

-- sub modules

s_tx_core :	stratixgx_tx_core 
  generic map (
    use_double_data_mode => use_double_data_mode, 
    use_fifo_mode => use_fifo_mode,
    channel_width => channel_width,
    transmit_protocol => transmit_protocol)
  port map (
    reset => reset_int,
    datain => core_datain, 
    writeclk => core_writeclk,
    readclk => core_readclk,
    ctrlena => core_ctrlena,
    forcedisp => core_forcedisp,
    dataout => core_dataout,
    forcedispout => core_forcedispout,
    ctrlenaout => core_ctrlenaout,
    rdenasync => core_rdenasync,
    xgmctrlena => core_xgmctrlena,
    xgmdataout => core_xgmdataout,
    pre8b10bdataout => core_pre8b10bdataout
    );   

s_encoder :	stratixgx_8b10b_encoder
  generic map (
    transmit_protocol => transmit_protocol,
    use_8b_10b_mode   => use_8b_10b_mode,
    force_disparity_mode => force_disparity_mode 
    )
  port map (
    clk             => encoder_clk,
    reset           => reset_int,
    kin             => encoder_kin,
    datain          => encoder_datain,
    xgmdatain       => encoder_xgmdatain,
    xgmctrl         => encoder_xgmctrl,
    forcedisparity  => core_forcedispout,
    dataout         => encoder_dataout,
    parafbkdataout  => encoder_para
    );
        
s_tx_serdes :	stratixgx_hssi_tx_serdes 
  generic map (
    channel_width => serialization_factor
    )
  port map (
    clk => serdes_clk,
    clk1 => serdes_clk1,
    datain => serdes_datain,
    serialdatain => serdes_serialdatain,
    srlpbk => serdes_srlpbk,
    areset => analogreset_ipd,
    dataout => serdes_dataout
    );

-- end of sub modules
 
-- generate output signals
parallelfdbkdata_tmp <= encoder_dataout WHEN (use_8b_10b_mode = "true") ELSE core_dataout; 

dataout <= serdes_dataout;
xgmctrlenable <= core_xgmctrlena;
rdenablesync <= core_rdenasync;
xgmdataout <= core_xgmdataout;
pre8b10bdata <= core_pre8b10bdataout;
parallelfdbkdata <= parallelfdbkdata_tmp;

VITAL: process (pllclk_ipd, fastpllclk_ipd, coreclk_ipd)

variable Tviol_datain_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable Tviol_ctrlenable_clk : std_ulogic := '0';
variable TimingData_ctrlenable_clk : VitalTimingDataType := VitalTimingDataInit;
variable Tviol_forcedisparity_clk : std_ulogic := '0';
variable TimingData_forcedisparity_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(19 downto 0);
variable clkout_VitalGlitchData: VitalGlitchDataType;

begin

	------------------------
	--  Timing Check Section
	------------------------

	if (TimingChecksOn) then

		VitalSetupHoldCheck (
			Violation       => Tviol_datain_clk,
			TimingData      => TimingData_datain_clk,
			TestSignal      => datain_ipd,
			TestSignalName  => "DATAIN",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_datain_coreclk_noedge_posedge(0),
			SetupLow        => tsetup_datain_coreclk_noedge_posedge(0),
			HoldHigh        => thold_datain_coreclk_noedge_posedge(0),
			HoldLow         => thold_datain_coreclk_noedge_posedge(0),
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_TRANSMITTER",
			XOn             => XOn,
			MsgOn           => MsgOnChecks );

		VitalSetupHoldCheck (
			Violation       => Tviol_ctrlenable_clk,
			TimingData      => TimingData_ctrlenable_clk,
			TestSignal      => ctrlenable_ipd,
			TestSignalName  => "CTRLENABLE",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_ctrlenable_coreclk_noedge_posedge(0),
			SetupLow        => tsetup_ctrlenable_coreclk_noedge_posedge(0),
			HoldHigh        => thold_ctrlenable_coreclk_noedge_posedge(0),
			HoldLow         => thold_ctrlenable_coreclk_noedge_posedge(0),
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_TRANSMITTER",
			XOn             => XOn,
			MsgOn           => MsgOnChecks );

		VitalSetupHoldCheck (
			Violation       => Tviol_forcedisparity_clk,
			TimingData      => TimingData_forcedisparity_clk,
			TestSignal      => forcedisparity_ipd,
			TestSignalName  => "FORCEDISPARITY",
			RefSignal       => coreclk_ipd,
			RefSignalName   => "CORECLK",
			SetupHigh       => tsetup_forcedisparity_coreclk_noedge_posedge(0),
			SetupLow        => tsetup_forcedisparity_coreclk_noedge_posedge(0),
			HoldHigh        => thold_forcedisparity_coreclk_noedge_posedge(0),
			HoldLow         => thold_forcedisparity_coreclk_noedge_posedge(0),
			RefTransition   => '/',
			HeaderMsg       => InstancePath & "/STRATIXGX_HSSI_TRANSMITTER",
			XOn             => XOn,
			MsgOn           => MsgOnChecks );

   end if;

	----------------------
	--  Path Delay Section
	----------------------

end process;

end vital_transmitter_atom;

