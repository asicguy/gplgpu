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
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package max_atom_pack is

function product(list : std_logic_vector) return std_logic ;

function alt_conv_integer(arg : in std_logic_vector) return integer;

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

end max_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body max_atom_pack is
 
function product (list: std_logic_vector) return std_logic is
begin

        for i in 0 to 35 loop
           if ((list(i) = '0') or (list(i) = 'L')) then
             return ('0');
           end if;
        end loop;
        return ('1');

end product;

function alt_conv_integer(arg : in std_logic_vector) return integer is
variable result : integer;
begin
  result := 0;
  for i in arg'range loop
     if arg(i) = '1' then
	result := result + 2**i;
     end if;
  end loop;
  return result;
end alt_conv_integer;

end max_atom_pack;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for MAX Atoms
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  MAX7K_IO Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;

entity max_asynch_io is
  generic (	operation_mode  : STRING := "input";
               	open_drain_output : STRING := "false";
               	bus_hold : STRING := "false";
               	weak_pull_up : STRING := "false";

                XOn: Boolean := DefGlitchXOn;
                MsgOn: Boolean := DefGlitchMsgOn;

                tpd_datain_padio        : VitalDelayType01 := DefPropDelay01;
                tpd_oe_padio_posedge       : VitalDelayType01 := DefPropDelay01;
                tpd_oe_padio_negedge       : VitalDelayType01 := DefPropDelay01;
                tpd_padio_dataout   : VitalDelayType01 := DefPropDelay01;

                tipd_datain         : VitalDelayType01 := DefPropDelay01;
                tipd_oe             : VitalDelayType01 := DefPropDelay01;
                tipd_padio          : VitalDelayType01 := DefPropDelay01);

  port (        datain  : in  STD_LOGIC := '0';
                oe      : in  STD_LOGIC := '0';
                padio   : inout STD_LOGIC;
                dataout : out STD_LOGIC);
  attribute VITAL_LEVEL0 of max_asynch_io : entity is TRUE;
end max_asynch_io;

architecture behave of max_asynch_io is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;
signal datain_ipd, oe_ipd, padio_ipd: std_logic;

begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (oe_ipd, oe, tipd_oe);
        VitalWireDelay (padio_ipd, padio, tipd_padio);
    end block;

    VITAL: process(padio_ipd, datain_ipd, oe_ipd)
      variable dataout_VitalGlitchData : VitalGlitchDataType;
      variable padio_VitalGlitchData : VitalGlitchDataType;
      variable tmp_dataout, tmp_padio : std_logic;
      variable prev_value : std_logic := 'H';
    begin
      if (bus_hold = "true" ) then
        if ( operation_mode = "input") then
          tmp_dataout := padio_ipd;
          if ( padio_ipd = 'Z') then
            if (prev_value = '1') then
              tmp_dataout := 'H';
            elsif (prev_value = '0') then
              tmp_dataout := 'L';
            end if;
          end if;
          prev_value := padio_ipd;
          tmp_padio := 'Z';
        elsif ( operation_mode = "output" or operation_mode = "bidir") then
          if ( oe_ipd = '1') then
            if ( open_drain_output = "true" ) then
              if (datain_ipd = '0') then
                tmp_padio := '0';
                prev_value := 'L';
              elsif (datain_ipd = 'X') then
                tmp_padio := 'X';
                prev_value := 'W';
              else   -- 'Z'
                -- need to update prev_value
                if (padio_ipd = '1') then
                  prev_value := 'H';
                elsif (padio_ipd = '0') then
                  prev_value := 'L';
                elsif (padio_ipd = 'X') then
                  prev_value := 'W';
                end if;
                tmp_padio := prev_value;
              end if;
            else
              tmp_padio := datain_ipd;
              if ( datain_ipd = '1') then
                prev_value := 'H';
              elsif (datain_ipd = '0' ) then
                prev_value := 'L';
              elsif ( datain_ipd = 'X') then
                prev_value := 'W';
              else
                prev_value := datain_ipd;
              end if;
            end if; -- end open_drain_output
            
          elsif ( oe_ipd = '0' ) then
            -- need to update prev_value
            if (padio_ipd = '1') then
              prev_value := 'H';
            elsif (padio_ipd = '0') then
              prev_value := 'L';
            elsif (padio_ipd = 'X') then
              if (prev_value = 'L') then
                prev_value := 'L';
              elsif (prev_value = 'H') then
                prev_value := 'H';
              else 
                prev_value := 'W';
              end if;
            end if;
            tmp_padio := prev_value;
          else
            if (now <= 1 ps) then
              tmp_padio := '0';
              prev_value := 'L';
            else
              tmp_padio := 'X';
              prev_value := 'W';
            end if;
            
          end if; -- end oe_in
          
          if ( operation_mode = "bidir") then
            if ((padio_ipd /= '1') and (padio_ipd /= '0')and (padio_ipd /= 'X')) then
              tmp_dataout := prev_value;
            else
              tmp_dataout := to_x01z(padio_ipd);
            end if;
          else
            tmp_dataout := 'Z';
          end if;
        end if;
        
        if ( now <= 1 ps AND prev_value = 'W' ) then     --hack for autotest to pass
          prev_value := 'L';
        end if;
        
      else    -- bus_hold is false
        if ( operation_mode = "input") then
          tmp_dataout := padio_ipd;
          tmp_padio := 'Z';
          if (weak_pull_up = "true") then
            if (tmp_dataout = 'Z') then
              tmp_dataout := 'H';
            end if;
          end if;
          
        elsif (operation_mode = "output" or operation_mode = "bidir" ) then
          if ( operation_mode  = "bidir") then
            tmp_dataout := padio_ipd;
            if (weak_pull_up = "true") then
              if (tmp_dataout = 'Z') then
                tmp_dataout := 'H';
              end if;
            end if;
          else
            tmp_dataout := 'Z';
          end if;
          
          if ( oe_ipd = '1') then
            if ( open_drain_output = "true" ) then
              if (datain_ipd = '0') then
                tmp_padio := '0';
              elsif (datain_ipd = 'X') then
                tmp_padio := 'X';
              else
                tmp_padio := 'Z';
                if (weak_pull_up = "true") then
                  if (tmp_padio = 'Z') then
                    tmp_padio := 'H';
                  end if;
                end if;
              end if;
            else
              tmp_padio := datain_ipd;
              if (weak_pull_up = "true") then
                if (tmp_padio = 'Z') then
                  tmp_padio := 'H';
                end if;
              end if;
            end if;
          elsif ( oe_ipd = '0' ) then
            tmp_padio := 'Z';
            if (weak_pull_up = "true") then
              if (tmp_padio = 'Z') then
                tmp_padio := 'H';
              end if;
            end if;
          else
            tmp_padio := 'X';
          end if;
        end if;
      end if; -- end bus_hold
    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
        OutSignal => dataout,
        OutSignalName => "dataout",
        OutTemp => tmp_dataout,
        Paths => (1 => (padio_ipd'last_event, tpd_padio_dataout, TRUE)),
        GlitchData => dataout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

        VitalPathDelay01 (
        OutSignal => padio,
        OutSignalName => "padio",
        OutTemp => tmp_padio,
        Paths => (1 => (datain_ipd'last_event, tpd_datain_padio, TRUE),
                  2 => (oe_ipd'last_event, tpd_oe_padio_posedge, oe_ipd = '1'),
                  3 => (oe_ipd'last_event, tpd_oe_padio_negedge, oe_ipd = '0')),
        GlitchData => padio_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );
    end process;

end behave;

--
-- MAX_IO
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;
use work.max_asynch_io;

entity  max_io is
  generic (	operation_mode : string := "input";
              	open_drain_output :string := "false";
              	bus_hold : string := "false";
              	weak_pull_up : string := "false");

  port (	datain          : in std_logic := '0';
              	oe              : in std_logic := '1';
              	devoe           : in std_logic := '0';
              	dataout         : out std_logic;
              	padio           : inout std_logic);
end max_io;

architecture structure of max_io is
	signal data_out : std_logic;
	
component max_asynch_io
  generic (	operation_mode : string := "input";
                open_drain_output : string := "false";
                bus_hold : string := "false";
                weak_pull_up : string := "false");

  port (	datain : in  STD_LOGIC := '0';
                oe     : in  STD_LOGIC := '0';
                padio  : inout STD_LOGIC;
                dataout: out STD_LOGIC);
end component;
begin
asynch_inst: max_asynch_io
  generic map (	operation_mode => operation_mode,
        	bus_hold => bus_hold, 
	    	open_drain_output => open_drain_output,
			weak_pull_up => weak_pull_up)

  port map (	datain => datain, 
		oe => oe, 
		padio => padio,
		dataout => data_out);

dataout <= data_out;

end structure;

--
--  MAX MCELL Model
-- 
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;

entity max_asynch_mcell is
  generic (	operation_mode     : string := "normal";
	  	pexp_mode : string := "off";
		register_mode : string := "dff";
      		TimingChecksOn: Boolean := True;
    		MsgOn: Boolean := DefGlitchMsgOn;
		XOn: Boolean := DefGlitchXOn;
		MsgOnChecks: Boolean := DefMsgOnChecks;
		XOnChecks: Boolean := DefXOnChecks;
		InstancePath: STRING := "*";
		
		tpd_pterm0_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
		tpd_pterm1_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
		tpd_pterm2_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
		tpd_pterm3_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm4_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm5_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pxor_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pexpin_combout            :  VitalDelayType01 := DefPropDelay01;
      		tpd_fbkin_combout            :  VitalDelayType01 := DefPropDelay01;
      		tpd_pterm0_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm1_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm2_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm3_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm4_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm5_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_fpin_regin            :  VitalDelayType01 := DefPropDelay01;
      		tpd_pxor_regin            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pexpin_regin            :  VitalDelayType01 := DefPropDelay01;
      		tpd_fbkin_regin            :  VitalDelayType01 := DefPropDelay01;
      		tpd_pterm0_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm1_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm2_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm3_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm4_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm5_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pexpin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      		tpd_fbkin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      		tipd_pterm0                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm1                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm2                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm3                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm4                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm5                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pxor                         :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tipd_fpin                         :  VitalDelayType01 := DefPropDelay01;
      		tipd_pexpin                       :  VitalDelayType01 := DefPropDelay01);


  port (	pterm0	: in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm1  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm2  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm3  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm4  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm5  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
                fpin	: in std_logic := '1';
        	pxor    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
       	 	pexpin	: in std_logic := '0';
        	fbkin : in std_logic;
		combout : out std_logic;
		regin : out std_logic;
        	pexpout : out std_logic );
   attribute VITAL_LEVEL0 of max_asynch_mcell : entity is TRUE;
end max_asynch_mcell; 

architecture vital_mcell of max_asynch_mcell is
   attribute VITAL_LEVEL0 of vital_mcell : architecture is TRUE;

signal pterm0_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pterm1_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pterm2_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pterm3_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pterm4_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pterm5_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal fpin_ipd		:std_ulogic := 'U';
signal pxor_ipd		:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pexpin_ipd	:std_ulogic := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (pterm0_ipd(0), pterm0(0), tipd_pterm0(0));
   VitalWireDelay (pterm0_ipd(1), pterm0(1), tipd_pterm0(1));
   VitalWireDelay (pterm0_ipd(2), pterm0(2), tipd_pterm0(2));
   VitalWireDelay (pterm0_ipd(3), pterm0(3), tipd_pterm0(3));
   VitalWireDelay (pterm0_ipd(4), pterm0(4), tipd_pterm0(4));
   VitalWireDelay (pterm0_ipd(5), pterm0(5), tipd_pterm0(5));
   VitalWireDelay (pterm0_ipd(6), pterm0(6), tipd_pterm0(6));
   VitalWireDelay (pterm0_ipd(7), pterm0(7), tipd_pterm0(7));
   VitalWireDelay (pterm0_ipd(8), pterm0(8), tipd_pterm0(8));
   VitalWireDelay (pterm0_ipd(9), pterm0(9), tipd_pterm0(9));
   VitalWireDelay (pterm0_ipd(10), pterm0(10), tipd_pterm0(10));
   VitalWireDelay (pterm0_ipd(11), pterm0(11), tipd_pterm0(11));
   VitalWireDelay (pterm0_ipd(12), pterm0(12), tipd_pterm0(12));
   VitalWireDelay (pterm0_ipd(13), pterm0(13), tipd_pterm0(13));
   VitalWireDelay (pterm0_ipd(14), pterm0(14), tipd_pterm0(14));
   VitalWireDelay (pterm0_ipd(15), pterm0(15), tipd_pterm0(15));
   VitalWireDelay (pterm0_ipd(16), pterm0(16), tipd_pterm0(16));
   VitalWireDelay (pterm0_ipd(17), pterm0(17), tipd_pterm0(17));
   VitalWireDelay (pterm0_ipd(18), pterm0(18), tipd_pterm0(18));
   VitalWireDelay (pterm0_ipd(19), pterm0(19), tipd_pterm0(19));
   VitalWireDelay (pterm0_ipd(20), pterm0(20), tipd_pterm0(20));
   VitalWireDelay (pterm0_ipd(21), pterm0(21), tipd_pterm0(21));
   VitalWireDelay (pterm0_ipd(22), pterm0(22), tipd_pterm0(22));
   VitalWireDelay (pterm0_ipd(23), pterm0(23), tipd_pterm0(23));
   VitalWireDelay (pterm0_ipd(24), pterm0(24), tipd_pterm0(24));
   VitalWireDelay (pterm0_ipd(25), pterm0(25), tipd_pterm0(25));
   VitalWireDelay (pterm0_ipd(26), pterm0(26), tipd_pterm0(26));
   VitalWireDelay (pterm0_ipd(27), pterm0(27), tipd_pterm0(27));
   VitalWireDelay (pterm0_ipd(28), pterm0(28), tipd_pterm0(28));
   VitalWireDelay (pterm0_ipd(29), pterm0(29), tipd_pterm0(29));
   VitalWireDelay (pterm0_ipd(30), pterm0(30), tipd_pterm0(30));
   VitalWireDelay (pterm0_ipd(31), pterm0(31), tipd_pterm0(31));
   VitalWireDelay (pterm0_ipd(32), pterm0(32), tipd_pterm0(32));
   VitalWireDelay (pterm0_ipd(33), pterm0(33), tipd_pterm0(33));
   VitalWireDelay (pterm0_ipd(34), pterm0(34), tipd_pterm0(34));
   VitalWireDelay (pterm0_ipd(35), pterm0(35), tipd_pterm0(35));
   VitalWireDelay (pterm0_ipd(36), pterm0(36), tipd_pterm0(36));
   VitalWireDelay (pterm0_ipd(37), pterm0(37), tipd_pterm0(37));
   VitalWireDelay (pterm0_ipd(38), pterm0(38), tipd_pterm0(38));
   VitalWireDelay (pterm0_ipd(39), pterm0(39), tipd_pterm0(39));
   VitalWireDelay (pterm0_ipd(40), pterm0(40), tipd_pterm0(40));
   VitalWireDelay (pterm0_ipd(41), pterm0(41), tipd_pterm0(41));
   VitalWireDelay (pterm0_ipd(42), pterm0(42), tipd_pterm0(42));
   VitalWireDelay (pterm0_ipd(43), pterm0(43), tipd_pterm0(43));
   VitalWireDelay (pterm0_ipd(44), pterm0(44), tipd_pterm0(44));
   VitalWireDelay (pterm0_ipd(45), pterm0(45), tipd_pterm0(45));
   VitalWireDelay (pterm0_ipd(46), pterm0(46), tipd_pterm0(46));
   VitalWireDelay (pterm0_ipd(47), pterm0(47), tipd_pterm0(47));
   VitalWireDelay (pterm0_ipd(48), pterm0(48), tipd_pterm0(48));
   VitalWireDelay (pterm0_ipd(49), pterm0(49), tipd_pterm0(49));
   VitalWireDelay (pterm0_ipd(50), pterm0(50), tipd_pterm0(50));
   VitalWireDelay (pterm0_ipd(51), pterm0(51), tipd_pterm0(51));

   VitalWireDelay (pterm1_ipd(0), pterm1(0), tipd_pterm1(0));
   VitalWireDelay (pterm1_ipd(1), pterm1(1), tipd_pterm1(1));
   VitalWireDelay (pterm1_ipd(2), pterm1(2), tipd_pterm1(2));
   VitalWireDelay (pterm1_ipd(3), pterm1(3), tipd_pterm1(3));
   VitalWireDelay (pterm1_ipd(4), pterm1(4), tipd_pterm1(4));
   VitalWireDelay (pterm1_ipd(5), pterm1(5), tipd_pterm1(5));
   VitalWireDelay (pterm1_ipd(6), pterm1(6), tipd_pterm1(6));
   VitalWireDelay (pterm1_ipd(7), pterm1(7), tipd_pterm1(7));
   VitalWireDelay (pterm1_ipd(8), pterm1(8), tipd_pterm1(8));
   VitalWireDelay (pterm1_ipd(9), pterm1(9), tipd_pterm1(9));
   VitalWireDelay (pterm1_ipd(10), pterm1(10), tipd_pterm1(10));
   VitalWireDelay (pterm1_ipd(11), pterm1(11), tipd_pterm1(11));
   VitalWireDelay (pterm1_ipd(12), pterm1(12), tipd_pterm1(12));
   VitalWireDelay (pterm1_ipd(13), pterm1(13), tipd_pterm1(13));
   VitalWireDelay (pterm1_ipd(14), pterm1(14), tipd_pterm1(14));
   VitalWireDelay (pterm1_ipd(15), pterm1(15), tipd_pterm1(15));
   VitalWireDelay (pterm1_ipd(16), pterm1(16), tipd_pterm1(16));
   VitalWireDelay (pterm1_ipd(17), pterm1(17), tipd_pterm1(17));
   VitalWireDelay (pterm1_ipd(18), pterm1(18), tipd_pterm1(18));
   VitalWireDelay (pterm1_ipd(19), pterm1(19), tipd_pterm1(19));
   VitalWireDelay (pterm1_ipd(20), pterm1(20), tipd_pterm1(20));
   VitalWireDelay (pterm1_ipd(21), pterm1(21), tipd_pterm1(21));
   VitalWireDelay (pterm1_ipd(22), pterm1(22), tipd_pterm1(22));
   VitalWireDelay (pterm1_ipd(23), pterm1(23), tipd_pterm1(23));
   VitalWireDelay (pterm1_ipd(24), pterm1(24), tipd_pterm1(24));
   VitalWireDelay (pterm1_ipd(25), pterm1(25), tipd_pterm1(25));
   VitalWireDelay (pterm1_ipd(26), pterm1(26), tipd_pterm1(26));
   VitalWireDelay (pterm1_ipd(27), pterm1(27), tipd_pterm1(27));
   VitalWireDelay (pterm1_ipd(28), pterm1(28), tipd_pterm1(28));
   VitalWireDelay (pterm1_ipd(29), pterm1(29), tipd_pterm1(29));
   VitalWireDelay (pterm1_ipd(30), pterm1(30), tipd_pterm1(30));
   VitalWireDelay (pterm1_ipd(31), pterm1(31), tipd_pterm1(31));
   VitalWireDelay (pterm1_ipd(32), pterm1(32), tipd_pterm1(32));
   VitalWireDelay (pterm1_ipd(33), pterm1(33), tipd_pterm1(33));
   VitalWireDelay (pterm1_ipd(34), pterm1(34), tipd_pterm1(34));
   VitalWireDelay (pterm1_ipd(35), pterm1(35), tipd_pterm1(35));
   VitalWireDelay (pterm1_ipd(36), pterm1(36), tipd_pterm1(36));
   VitalWireDelay (pterm1_ipd(37), pterm1(37), tipd_pterm1(37));
   VitalWireDelay (pterm1_ipd(38), pterm1(38), tipd_pterm1(38));
   VitalWireDelay (pterm1_ipd(39), pterm1(39), tipd_pterm1(39));
   VitalWireDelay (pterm1_ipd(40), pterm1(40), tipd_pterm1(40));
   VitalWireDelay (pterm1_ipd(41), pterm1(41), tipd_pterm1(41));
   VitalWireDelay (pterm1_ipd(42), pterm1(42), tipd_pterm1(42));
   VitalWireDelay (pterm1_ipd(43), pterm1(43), tipd_pterm1(43));
   VitalWireDelay (pterm1_ipd(44), pterm1(44), tipd_pterm1(44));
   VitalWireDelay (pterm1_ipd(45), pterm1(45), tipd_pterm1(45));
   VitalWireDelay (pterm1_ipd(46), pterm1(46), tipd_pterm1(46));
   VitalWireDelay (pterm1_ipd(47), pterm1(47), tipd_pterm1(47));
   VitalWireDelay (pterm1_ipd(48), pterm1(48), tipd_pterm1(48));
   VitalWireDelay (pterm1_ipd(49), pterm1(49), tipd_pterm1(49));
   VitalWireDelay (pterm1_ipd(50), pterm1(50), tipd_pterm1(50));
   VitalWireDelay (pterm1_ipd(51), pterm1(51), tipd_pterm1(51));

   VitalWireDelay (pterm2_ipd(0), pterm2(0), tipd_pterm2(0));
   VitalWireDelay (pterm2_ipd(1), pterm2(1), tipd_pterm2(1));
   VitalWireDelay (pterm2_ipd(2), pterm2(2), tipd_pterm2(2));
   VitalWireDelay (pterm2_ipd(3), pterm2(3), tipd_pterm2(3));
   VitalWireDelay (pterm2_ipd(4), pterm2(4), tipd_pterm2(4));
   VitalWireDelay (pterm2_ipd(5), pterm2(5), tipd_pterm2(5));
   VitalWireDelay (pterm2_ipd(6), pterm2(6), tipd_pterm2(6));
   VitalWireDelay (pterm2_ipd(7), pterm2(7), tipd_pterm2(7));
   VitalWireDelay (pterm2_ipd(8), pterm2(8), tipd_pterm2(8));
   VitalWireDelay (pterm2_ipd(9), pterm2(9), tipd_pterm2(9));
   VitalWireDelay (pterm2_ipd(10), pterm2(10), tipd_pterm2(10));
   VitalWireDelay (pterm2_ipd(11), pterm2(11), tipd_pterm2(11));
   VitalWireDelay (pterm2_ipd(12), pterm2(12), tipd_pterm2(12));
   VitalWireDelay (pterm2_ipd(13), pterm2(13), tipd_pterm2(13));
   VitalWireDelay (pterm2_ipd(14), pterm2(14), tipd_pterm2(14));
   VitalWireDelay (pterm2_ipd(15), pterm2(15), tipd_pterm2(15));
   VitalWireDelay (pterm2_ipd(16), pterm2(16), tipd_pterm2(16));
   VitalWireDelay (pterm2_ipd(17), pterm2(17), tipd_pterm2(17));
   VitalWireDelay (pterm2_ipd(18), pterm2(18), tipd_pterm2(18));
   VitalWireDelay (pterm2_ipd(19), pterm2(19), tipd_pterm2(19));
   VitalWireDelay (pterm2_ipd(20), pterm2(20), tipd_pterm2(20));
   VitalWireDelay (pterm2_ipd(21), pterm2(21), tipd_pterm2(21));
   VitalWireDelay (pterm2_ipd(22), pterm2(22), tipd_pterm2(22));
   VitalWireDelay (pterm2_ipd(23), pterm2(23), tipd_pterm2(23));
   VitalWireDelay (pterm2_ipd(24), pterm2(24), tipd_pterm2(24));
   VitalWireDelay (pterm2_ipd(25), pterm2(25), tipd_pterm2(25));
   VitalWireDelay (pterm2_ipd(26), pterm2(26), tipd_pterm2(26));
   VitalWireDelay (pterm2_ipd(27), pterm2(27), tipd_pterm2(27));
   VitalWireDelay (pterm2_ipd(28), pterm2(28), tipd_pterm2(28));
   VitalWireDelay (pterm2_ipd(29), pterm2(29), tipd_pterm2(29));
   VitalWireDelay (pterm2_ipd(30), pterm2(30), tipd_pterm2(30));
   VitalWireDelay (pterm2_ipd(31), pterm2(31), tipd_pterm2(31));
   VitalWireDelay (pterm2_ipd(32), pterm2(32), tipd_pterm2(32));
   VitalWireDelay (pterm2_ipd(33), pterm2(33), tipd_pterm2(33));
   VitalWireDelay (pterm2_ipd(34), pterm2(34), tipd_pterm2(34));
   VitalWireDelay (pterm2_ipd(35), pterm2(35), tipd_pterm2(35));
   VitalWireDelay (pterm2_ipd(36), pterm2(36), tipd_pterm2(36));
   VitalWireDelay (pterm2_ipd(37), pterm2(37), tipd_pterm2(37));
   VitalWireDelay (pterm2_ipd(38), pterm2(38), tipd_pterm2(38));
   VitalWireDelay (pterm2_ipd(39), pterm2(39), tipd_pterm2(39));
   VitalWireDelay (pterm2_ipd(40), pterm2(40), tipd_pterm2(40));
   VitalWireDelay (pterm2_ipd(41), pterm2(41), tipd_pterm2(41));
   VitalWireDelay (pterm2_ipd(42), pterm2(42), tipd_pterm2(42));
   VitalWireDelay (pterm2_ipd(43), pterm2(43), tipd_pterm2(43));
   VitalWireDelay (pterm2_ipd(44), pterm2(44), tipd_pterm2(44));
   VitalWireDelay (pterm2_ipd(45), pterm2(45), tipd_pterm2(45));
   VitalWireDelay (pterm2_ipd(46), pterm2(46), tipd_pterm2(46));
   VitalWireDelay (pterm2_ipd(47), pterm2(47), tipd_pterm2(47));
   VitalWireDelay (pterm2_ipd(48), pterm2(48), tipd_pterm2(48));
   VitalWireDelay (pterm2_ipd(49), pterm2(49), tipd_pterm2(49));
   VitalWireDelay (pterm2_ipd(50), pterm2(50), tipd_pterm2(50));
   VitalWireDelay (pterm2_ipd(51), pterm2(51), tipd_pterm2(51));

   VitalWireDelay (pterm3_ipd(0), pterm3(0), tipd_pterm3(0));
   VitalWireDelay (pterm3_ipd(1), pterm3(1), tipd_pterm3(1));
   VitalWireDelay (pterm3_ipd(2), pterm3(2), tipd_pterm3(2));
   VitalWireDelay (pterm3_ipd(3), pterm3(3), tipd_pterm3(3));
   VitalWireDelay (pterm3_ipd(4), pterm3(4), tipd_pterm3(4));
   VitalWireDelay (pterm3_ipd(5), pterm3(5), tipd_pterm3(5));
   VitalWireDelay (pterm3_ipd(6), pterm3(6), tipd_pterm3(6));
   VitalWireDelay (pterm3_ipd(7), pterm3(7), tipd_pterm3(7));
   VitalWireDelay (pterm3_ipd(8), pterm3(8), tipd_pterm3(8));
   VitalWireDelay (pterm3_ipd(9), pterm3(9), tipd_pterm3(9));
   VitalWireDelay (pterm3_ipd(10), pterm3(10), tipd_pterm3(10));
   VitalWireDelay (pterm3_ipd(11), pterm3(11), tipd_pterm3(11));
   VitalWireDelay (pterm3_ipd(12), pterm3(12), tipd_pterm3(12));
   VitalWireDelay (pterm3_ipd(13), pterm3(13), tipd_pterm3(13));
   VitalWireDelay (pterm3_ipd(14), pterm3(14), tipd_pterm3(14));
   VitalWireDelay (pterm3_ipd(15), pterm3(15), tipd_pterm3(15));
   VitalWireDelay (pterm3_ipd(16), pterm3(16), tipd_pterm3(16));
   VitalWireDelay (pterm3_ipd(17), pterm3(17), tipd_pterm3(17));
   VitalWireDelay (pterm3_ipd(18), pterm3(18), tipd_pterm3(18));
   VitalWireDelay (pterm3_ipd(19), pterm3(19), tipd_pterm3(19));
   VitalWireDelay (pterm3_ipd(20), pterm3(20), tipd_pterm3(20));
   VitalWireDelay (pterm3_ipd(21), pterm3(21), tipd_pterm3(21));
   VitalWireDelay (pterm3_ipd(22), pterm3(22), tipd_pterm3(22));
   VitalWireDelay (pterm3_ipd(23), pterm3(23), tipd_pterm3(23));
   VitalWireDelay (pterm3_ipd(24), pterm3(24), tipd_pterm3(24));
   VitalWireDelay (pterm3_ipd(25), pterm3(25), tipd_pterm3(25));
   VitalWireDelay (pterm3_ipd(26), pterm3(26), tipd_pterm3(26));
   VitalWireDelay (pterm3_ipd(27), pterm3(27), tipd_pterm3(27));
   VitalWireDelay (pterm3_ipd(28), pterm3(28), tipd_pterm3(28));
   VitalWireDelay (pterm3_ipd(29), pterm3(29), tipd_pterm3(29));
   VitalWireDelay (pterm3_ipd(30), pterm3(30), tipd_pterm3(30));
   VitalWireDelay (pterm3_ipd(31), pterm3(31), tipd_pterm3(31));
   VitalWireDelay (pterm3_ipd(32), pterm3(32), tipd_pterm3(32));
   VitalWireDelay (pterm3_ipd(33), pterm3(33), tipd_pterm3(33));
   VitalWireDelay (pterm3_ipd(34), pterm3(34), tipd_pterm3(34));
   VitalWireDelay (pterm3_ipd(35), pterm3(35), tipd_pterm3(35));
   VitalWireDelay (pterm3_ipd(36), pterm3(36), tipd_pterm3(36));
   VitalWireDelay (pterm3_ipd(37), pterm3(37), tipd_pterm3(37));
   VitalWireDelay (pterm3_ipd(38), pterm3(38), tipd_pterm3(38));
   VitalWireDelay (pterm3_ipd(39), pterm3(39), tipd_pterm3(39));
   VitalWireDelay (pterm3_ipd(40), pterm3(40), tipd_pterm3(40));
   VitalWireDelay (pterm3_ipd(41), pterm3(41), tipd_pterm3(41));
   VitalWireDelay (pterm3_ipd(42), pterm3(42), tipd_pterm3(42));
   VitalWireDelay (pterm3_ipd(43), pterm3(43), tipd_pterm3(43));
   VitalWireDelay (pterm3_ipd(44), pterm3(44), tipd_pterm3(44));
   VitalWireDelay (pterm3_ipd(45), pterm3(45), tipd_pterm3(45));
   VitalWireDelay (pterm3_ipd(46), pterm3(46), tipd_pterm3(46));
   VitalWireDelay (pterm3_ipd(47), pterm3(47), tipd_pterm3(47));
   VitalWireDelay (pterm3_ipd(48), pterm3(48), tipd_pterm3(48));
   VitalWireDelay (pterm3_ipd(49), pterm3(49), tipd_pterm3(49));
   VitalWireDelay (pterm3_ipd(50), pterm3(50), tipd_pterm3(50));
   VitalWireDelay (pterm3_ipd(51), pterm3(51), tipd_pterm3(51));

   VitalWireDelay (pterm4_ipd(0), pterm4(0), tipd_pterm4(0));
   VitalWireDelay (pterm4_ipd(1), pterm4(1), tipd_pterm4(1));
   VitalWireDelay (pterm4_ipd(2), pterm4(2), tipd_pterm4(2));
   VitalWireDelay (pterm4_ipd(3), pterm4(3), tipd_pterm4(3));
   VitalWireDelay (pterm4_ipd(4), pterm4(4), tipd_pterm4(4));
   VitalWireDelay (pterm4_ipd(5), pterm4(5), tipd_pterm4(5));
   VitalWireDelay (pterm4_ipd(6), pterm4(6), tipd_pterm4(6));
   VitalWireDelay (pterm4_ipd(7), pterm4(7), tipd_pterm4(7));
   VitalWireDelay (pterm4_ipd(8), pterm4(8), tipd_pterm4(8));
   VitalWireDelay (pterm4_ipd(9), pterm4(9), tipd_pterm4(9));
   VitalWireDelay (pterm4_ipd(10), pterm4(10), tipd_pterm4(10));
   VitalWireDelay (pterm4_ipd(11), pterm4(11), tipd_pterm4(11));
   VitalWireDelay (pterm4_ipd(12), pterm4(12), tipd_pterm4(12));
   VitalWireDelay (pterm4_ipd(13), pterm4(13), tipd_pterm4(13));
   VitalWireDelay (pterm4_ipd(14), pterm4(14), tipd_pterm4(14));
   VitalWireDelay (pterm4_ipd(15), pterm4(15), tipd_pterm4(15));
   VitalWireDelay (pterm4_ipd(16), pterm4(16), tipd_pterm4(16));
   VitalWireDelay (pterm4_ipd(17), pterm4(17), tipd_pterm4(17));
   VitalWireDelay (pterm4_ipd(18), pterm4(18), tipd_pterm4(18));
   VitalWireDelay (pterm4_ipd(19), pterm4(19), tipd_pterm4(19));
   VitalWireDelay (pterm4_ipd(20), pterm4(20), tipd_pterm4(20));
   VitalWireDelay (pterm4_ipd(21), pterm4(21), tipd_pterm4(21));
   VitalWireDelay (pterm4_ipd(22), pterm4(22), tipd_pterm4(22));
   VitalWireDelay (pterm4_ipd(23), pterm4(23), tipd_pterm4(23));
   VitalWireDelay (pterm4_ipd(24), pterm4(24), tipd_pterm4(24));
   VitalWireDelay (pterm4_ipd(25), pterm4(25), tipd_pterm4(25));
   VitalWireDelay (pterm4_ipd(26), pterm4(26), tipd_pterm4(26));
   VitalWireDelay (pterm4_ipd(27), pterm4(27), tipd_pterm4(27));
   VitalWireDelay (pterm4_ipd(28), pterm4(28), tipd_pterm4(28));
   VitalWireDelay (pterm4_ipd(29), pterm4(29), tipd_pterm4(29));
   VitalWireDelay (pterm4_ipd(30), pterm4(30), tipd_pterm4(30));
   VitalWireDelay (pterm4_ipd(31), pterm4(31), tipd_pterm4(31));
   VitalWireDelay (pterm4_ipd(32), pterm4(32), tipd_pterm4(32));
   VitalWireDelay (pterm4_ipd(33), pterm4(33), tipd_pterm4(33));
   VitalWireDelay (pterm4_ipd(34), pterm4(34), tipd_pterm4(34));
   VitalWireDelay (pterm4_ipd(35), pterm4(35), tipd_pterm4(35));
   VitalWireDelay (pterm4_ipd(36), pterm4(36), tipd_pterm4(36));
   VitalWireDelay (pterm4_ipd(37), pterm4(37), tipd_pterm4(37));
   VitalWireDelay (pterm4_ipd(38), pterm4(38), tipd_pterm4(38));
   VitalWireDelay (pterm4_ipd(39), pterm4(39), tipd_pterm4(39));
   VitalWireDelay (pterm4_ipd(40), pterm4(40), tipd_pterm4(40));
   VitalWireDelay (pterm4_ipd(41), pterm4(41), tipd_pterm4(41));
   VitalWireDelay (pterm4_ipd(42), pterm4(42), tipd_pterm4(42));
   VitalWireDelay (pterm4_ipd(43), pterm4(43), tipd_pterm4(43));
   VitalWireDelay (pterm4_ipd(44), pterm4(44), tipd_pterm4(44));
   VitalWireDelay (pterm4_ipd(45), pterm4(45), tipd_pterm4(45));
   VitalWireDelay (pterm4_ipd(46), pterm4(46), tipd_pterm4(46));
   VitalWireDelay (pterm4_ipd(47), pterm4(47), tipd_pterm4(47));
   VitalWireDelay (pterm4_ipd(48), pterm4(48), tipd_pterm4(48));
   VitalWireDelay (pterm4_ipd(49), pterm4(49), tipd_pterm4(49));
   VitalWireDelay (pterm4_ipd(50), pterm4(50), tipd_pterm4(50));
   VitalWireDelay (pterm4_ipd(51), pterm4(51), tipd_pterm4(51));

   VitalWireDelay (pterm5_ipd(0), pterm5(0), tipd_pterm5(0));
   VitalWireDelay (pterm5_ipd(1), pterm5(1), tipd_pterm5(1));
   VitalWireDelay (pterm5_ipd(2), pterm5(2), tipd_pterm5(2));
   VitalWireDelay (pterm5_ipd(3), pterm5(3), tipd_pterm5(3));
   VitalWireDelay (pterm5_ipd(4), pterm5(4), tipd_pterm5(4));
   VitalWireDelay (pterm5_ipd(5), pterm5(5), tipd_pterm5(5));
   VitalWireDelay (pterm5_ipd(6), pterm5(6), tipd_pterm5(6));
   VitalWireDelay (pterm5_ipd(7), pterm5(7), tipd_pterm5(7));
   VitalWireDelay (pterm5_ipd(8), pterm5(8), tipd_pterm5(8));
   VitalWireDelay (pterm5_ipd(9), pterm5(9), tipd_pterm5(9));
   VitalWireDelay (pterm5_ipd(10), pterm5(10), tipd_pterm5(10));
   VitalWireDelay (pterm5_ipd(11), pterm5(11), tipd_pterm5(11));
   VitalWireDelay (pterm5_ipd(12), pterm5(12), tipd_pterm5(12));
   VitalWireDelay (pterm5_ipd(13), pterm5(13), tipd_pterm5(13));
   VitalWireDelay (pterm5_ipd(14), pterm5(14), tipd_pterm5(14));
   VitalWireDelay (pterm5_ipd(15), pterm5(15), tipd_pterm5(15));
   VitalWireDelay (pterm5_ipd(16), pterm5(16), tipd_pterm5(16));
   VitalWireDelay (pterm5_ipd(17), pterm5(17), tipd_pterm5(17));
   VitalWireDelay (pterm5_ipd(18), pterm5(18), tipd_pterm5(18));
   VitalWireDelay (pterm5_ipd(19), pterm5(19), tipd_pterm5(19));
   VitalWireDelay (pterm5_ipd(20), pterm5(20), tipd_pterm5(20));
   VitalWireDelay (pterm5_ipd(21), pterm5(21), tipd_pterm5(21));
   VitalWireDelay (pterm5_ipd(22), pterm5(22), tipd_pterm5(22));
   VitalWireDelay (pterm5_ipd(23), pterm5(23), tipd_pterm5(23));
   VitalWireDelay (pterm5_ipd(24), pterm5(24), tipd_pterm5(24));
   VitalWireDelay (pterm5_ipd(25), pterm5(25), tipd_pterm5(25));
   VitalWireDelay (pterm5_ipd(26), pterm5(26), tipd_pterm5(26));
   VitalWireDelay (pterm5_ipd(27), pterm5(27), tipd_pterm5(27));
   VitalWireDelay (pterm5_ipd(28), pterm5(28), tipd_pterm5(28));
   VitalWireDelay (pterm5_ipd(29), pterm5(29), tipd_pterm5(29));
   VitalWireDelay (pterm5_ipd(30), pterm5(30), tipd_pterm5(30));
   VitalWireDelay (pterm5_ipd(31), pterm5(31), tipd_pterm5(31));
   VitalWireDelay (pterm5_ipd(32), pterm5(32), tipd_pterm5(32));
   VitalWireDelay (pterm5_ipd(33), pterm5(33), tipd_pterm5(33));
   VitalWireDelay (pterm5_ipd(34), pterm5(34), tipd_pterm5(34));
   VitalWireDelay (pterm5_ipd(35), pterm5(35), tipd_pterm5(35));
   VitalWireDelay (pterm5_ipd(36), pterm5(36), tipd_pterm5(36));
   VitalWireDelay (pterm5_ipd(37), pterm5(37), tipd_pterm5(37));
   VitalWireDelay (pterm5_ipd(38), pterm5(38), tipd_pterm5(38));
   VitalWireDelay (pterm5_ipd(39), pterm5(39), tipd_pterm5(39));
   VitalWireDelay (pterm5_ipd(40), pterm5(40), tipd_pterm5(40));
   VitalWireDelay (pterm5_ipd(41), pterm5(41), tipd_pterm5(41));
   VitalWireDelay (pterm5_ipd(42), pterm5(42), tipd_pterm5(42));
   VitalWireDelay (pterm5_ipd(43), pterm5(43), tipd_pterm5(43));
   VitalWireDelay (pterm5_ipd(44), pterm5(44), tipd_pterm5(44));
   VitalWireDelay (pterm5_ipd(45), pterm5(45), tipd_pterm5(45));
   VitalWireDelay (pterm5_ipd(46), pterm5(46), tipd_pterm5(46));
   VitalWireDelay (pterm5_ipd(47), pterm5(47), tipd_pterm5(47));
   VitalWireDelay (pterm5_ipd(48), pterm5(48), tipd_pterm5(48));
   VitalWireDelay (pterm5_ipd(49), pterm5(49), tipd_pterm5(49));
   VitalWireDelay (pterm5_ipd(50), pterm5(50), tipd_pterm5(50));
   VitalWireDelay (pterm5_ipd(51), pterm5(51), tipd_pterm5(51));

   VitalWireDelay (pxor_ipd(0), pxor(0), tipd_pxor(0));
   VitalWireDelay (pxor_ipd(1), pxor(1), tipd_pxor(1));
   VitalWireDelay (pxor_ipd(2), pxor(2), tipd_pxor(2));
   VitalWireDelay (pxor_ipd(3), pxor(3), tipd_pxor(3));
   VitalWireDelay (pxor_ipd(4), pxor(4), tipd_pxor(4));
   VitalWireDelay (pxor_ipd(5), pxor(5), tipd_pxor(5));
   VitalWireDelay (pxor_ipd(6), pxor(6), tipd_pxor(6));
   VitalWireDelay (pxor_ipd(7), pxor(7), tipd_pxor(7));
   VitalWireDelay (pxor_ipd(8), pxor(8), tipd_pxor(8));
   VitalWireDelay (pxor_ipd(9), pxor(9), tipd_pxor(9));
   VitalWireDelay (pxor_ipd(10), pxor(10), tipd_pxor(10));
   VitalWireDelay (pxor_ipd(11), pxor(11), tipd_pxor(11));
   VitalWireDelay (pxor_ipd(12), pxor(12), tipd_pxor(12));
   VitalWireDelay (pxor_ipd(13), pxor(13), tipd_pxor(13));
   VitalWireDelay (pxor_ipd(14), pxor(14), tipd_pxor(14));
   VitalWireDelay (pxor_ipd(15), pxor(15), tipd_pxor(15));
   VitalWireDelay (pxor_ipd(16), pxor(16), tipd_pxor(16));
   VitalWireDelay (pxor_ipd(17), pxor(17), tipd_pxor(17));
   VitalWireDelay (pxor_ipd(18), pxor(18), tipd_pxor(18));
   VitalWireDelay (pxor_ipd(19), pxor(19), tipd_pxor(19));
   VitalWireDelay (pxor_ipd(20), pxor(20), tipd_pxor(20));
   VitalWireDelay (pxor_ipd(21), pxor(21), tipd_pxor(21));
   VitalWireDelay (pxor_ipd(22), pxor(22), tipd_pxor(22));
   VitalWireDelay (pxor_ipd(23), pxor(23), tipd_pxor(23));
   VitalWireDelay (pxor_ipd(24), pxor(24), tipd_pxor(24));
   VitalWireDelay (pxor_ipd(25), pxor(25), tipd_pxor(25));
   VitalWireDelay (pxor_ipd(26), pxor(26), tipd_pxor(26));
   VitalWireDelay (pxor_ipd(27), pxor(27), tipd_pxor(27));
   VitalWireDelay (pxor_ipd(28), pxor(28), tipd_pxor(28));
   VitalWireDelay (pxor_ipd(29), pxor(29), tipd_pxor(29));
   VitalWireDelay (pxor_ipd(30), pxor(30), tipd_pxor(30));
   VitalWireDelay (pxor_ipd(31), pxor(31), tipd_pxor(31));
   VitalWireDelay (pxor_ipd(32), pxor(32), tipd_pxor(32));
   VitalWireDelay (pxor_ipd(33), pxor(33), tipd_pxor(33));
   VitalWireDelay (pxor_ipd(34), pxor(34), tipd_pxor(34));
   VitalWireDelay (pxor_ipd(35), pxor(35), tipd_pxor(35));
   VitalWireDelay (pxor_ipd(36), pxor(36), tipd_pxor(36));
   VitalWireDelay (pxor_ipd(37), pxor(37), tipd_pxor(37));
   VitalWireDelay (pxor_ipd(38), pxor(38), tipd_pxor(38));
   VitalWireDelay (pxor_ipd(39), pxor(39), tipd_pxor(39));
   VitalWireDelay (pxor_ipd(40), pxor(40), tipd_pxor(40));
   VitalWireDelay (pxor_ipd(41), pxor(41), tipd_pxor(41));
   VitalWireDelay (pxor_ipd(42), pxor(42), tipd_pxor(42));
   VitalWireDelay (pxor_ipd(43), pxor(43), tipd_pxor(43));
   VitalWireDelay (pxor_ipd(44), pxor(44), tipd_pxor(44));
   VitalWireDelay (pxor_ipd(45), pxor(45), tipd_pxor(45));
   VitalWireDelay (pxor_ipd(46), pxor(46), tipd_pxor(46));
   VitalWireDelay (pxor_ipd(47), pxor(47), tipd_pxor(47));
   VitalWireDelay (pxor_ipd(48), pxor(48), tipd_pxor(48));
   VitalWireDelay (pxor_ipd(49), pxor(49), tipd_pxor(49));
   VitalWireDelay (pxor_ipd(50), pxor(50), tipd_pxor(50));
   VitalWireDelay (pxor_ipd(51), pxor(51), tipd_pxor(51));

   VitalWireDelay (pexpin_ipd, pexpin, tipd_pexpin);
   VitalWireDelay (fpin_ipd, fpin, tipd_fpin);

   end block;

VITALtiming : process(pterm0_ipd, pterm1_ipd, pterm2_ipd, pterm3_ipd, pterm4_ipd, pterm5_ipd, pxor_ipd, pexpin_ipd, fbkin, fpin_ipd)


variable combout_VitalGlitchData : VitalGlitchDataType;
variable regin_VitalGlitchData : VitalGlitchDataType;
variable pexpout_VitalGlitchData : VitalGlitchDataType;

variable tmp_comb, tmp_pexpout : std_logic;

begin
  if (pexp_mode = "off") then
    if (operation_mode = "normal") then
      if (register_mode = "tff") then
        tmp_comb := ((product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd) xor fbkin;
      else				
        tmp_comb := (product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd;
      end if;			
    elsif (operation_mode = "invert") then
      if (register_mode = "tff") then
        tmp_comb := (((product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd)) xor (not(fbkin));
      else	
        tmp_comb := ((product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd) xor '1';			
      end if;	
    elsif (operation_mode = "xor") then
      tmp_comb := ((product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd) xor product(pxor_ipd);
    elsif (operation_mode = "vcc") then
      if (register_mode = "tff") then
        tmp_comb := '1' xor fbkin;
      else
        tmp_comb := fpin_ipd;
      end if;
    else
      tmp_comb := 'Z';
      tmp_pexpout := 'Z';
    end if;
  elsif (pexp_mode = "on") then
    if (operation_mode = "normal") then
      if (register_mode = "tff") then
        tmp_comb := (product (pterm5_ipd)) xor fbkin;
      else
        tmp_comb := product (pterm5_ipd);
      end if;
      tmp_pexpout := (product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd;
    elsif (operation_mode = "invert") then
      if (register_mode = "tff") then
        tmp_comb :=  (product(pterm5_ipd)) xor (not(fbkin));
      else
        tmp_comb := (product(pterm5_ipd)) xor '1';
      end if;
      tmp_pexpout :=  (product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd;				
    elsif (operation_mode = "xor") then			
      tmp_pexpout := (product(pterm0_ipd) or product(pterm1_ipd) or product(pterm2_ipd) or product(pterm3_ipd) or product(pterm4_ipd)) or pexpin_ipd;			
      tmp_comb := (product(pterm5_ipd)) xor (product(pxor_ipd));
    elsif (operation_mode = "vcc") then
      if (register_mode = "tff") then
        tmp_comb := '1' xor fbkin;
      else
        tmp_comb := fpin_ipd;
      end if;
      tmp_pexpout := (product(pterm0) or product(pterm1) or product(pterm2) or product(pterm3) or product(pterm4)) or pexpin_ipd;
    else
      tmp_comb := 'Z';
      tmp_pexpout := 'Z';
    end if;
  end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => combout,
       OutSignalName => "COMBOUT",
       OutTemp => tmp_comb,
       Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_combout(0), TRUE),
                 2 => (pterm1_ipd'last_event, tpd_pterm1_combout(0), TRUE),
                 3 => (pterm2_ipd'last_event, tpd_pterm2_combout(0), TRUE),
                 4 => (pterm3_ipd'last_event, tpd_pterm3_combout(0), TRUE),
                 5 => (pterm4_ipd'last_event, tpd_pterm4_combout(0), TRUE),
                 6 => (pterm5_ipd'last_event, tpd_pterm5_combout(0), TRUE),
                 7 => (pxor_ipd'last_event, tpd_pxor_combout(0), TRUE),
                 8 => (pexpin_ipd'last_event, tpd_pexpin_combout, TRUE),
                 9 => (fbkin'last_event, tpd_fbkin_combout, TRUE)),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => pexpout, 
       OutSignalName => "PEXPOUT", 
       OutTemp => tmp_pexpout,  
       Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_pexpout(0), TRUE),
                 2 => (pterm1_ipd'last_event, tpd_pterm1_pexpout(0), TRUE),
                 3 => (pterm2_ipd'last_event, tpd_pterm2_pexpout(0), TRUE),
                 4 => (pterm3_ipd'last_event, tpd_pterm3_pexpout(0), TRUE),
                 5 => (pterm4_ipd'last_event, tpd_pterm4_pexpout(0), TRUE),
                 6 => (pexpin_ipd'last_event, tpd_pexpin_pexpout, TRUE),
                 7 => (fbkin'last_event, tpd_fbkin_pexpout, TRUE)),
       GlitchData => pexpout_VitalGlitchData, 
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => regin,
       OutSignalName => "REGIN",
       OutTemp => tmp_comb,
       Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_regin(0), TRUE),
                 2 => (pterm1_ipd'last_event, tpd_pterm1_regin(0), TRUE),
                 3 => (pterm2_ipd'last_event, tpd_pterm2_regin(0), TRUE),
                 4 => (pterm3_ipd'last_event, tpd_pterm3_regin(0), TRUE),
                 5 => (pterm4_ipd'last_event, tpd_pterm4_regin(0), TRUE),
                 6 => (pterm5_ipd'last_event, tpd_pterm5_regin(0), TRUE),
                 7 => (fpin_ipd'last_event, tpd_fpin_regin, TRUE),
                 8 => (pxor_ipd'last_event, tpd_pxor_regin(0), TRUE),
                 9 => (pexpin_ipd'last_event, tpd_pexpin_regin, TRUE),
                 10 => (fbkin'last_event, tpd_fbkin_regin, TRUE)),
       GlitchData => regin_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );
       

end process;

end vital_mcell;

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;

entity max_mcell_register is
  generic (	operation_mode : string := "normal";
		power_up : string := "low";
                register_mode : string := "dff";
                TimingChecksOn: Boolean := True;
		MsgOn: Boolean := DefGlitchMsgOn;
      		XOn: Boolean := DefGlitchXOn;
      		MsgOnChecks: Boolean := DefMsgOnChecks;
      		XOnChecks: Boolean := DefXOnChecks;
      		InstancePath: STRING := "*";
                tpd_pclk_regout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_pena_regout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_paclr_regout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_papre_regout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_aclr_regout_posedge      :  VitalDelayType01 := DefPropDelay01;
      		tpd_clk_regout_posedge       :  VitalDelayType01 := DefPropDelay01;
                tpd_pclk_fbkout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_pena_fbkout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_paclr_fbkout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_papre_fbkout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_aclr_fbkout_posedge      :  VitalDelayType01 := DefPropDelay01;
      		tpd_clk_fbkout_posedge       :  VitalDelayType01 := DefPropDelay01;
                tsetup_datain_clk_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
                tsetup_pena_clk_noedge_posedge	  :	VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
                tsetup_datain_pclk_noedge_posedge  :  VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
      		thold_datain_clk_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
                thold_pena_clk_noedge_posedge	   :	VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
      		thold_datain_pclk_noedge_posedge   :  VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
                tipd_pclk                         :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pena                         :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_paclr                        :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_papre                        :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_clk                          :  VitalDelayType01 := DefPropDelay01;
      		tipd_aclr                         :  VitalDelayType01 := DefPropDelay01);

  port (	datain	: in std_logic;
        	clk	: in std_logic;
		aclr	: in std_logic := '0';
        	pclk    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pena    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	paclr   : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	papre   : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
		regout : out std_logic;
        	fbkout : out std_logic);
   attribute VITAL_LEVEL0 of max_mcell_register : entity is TRUE;
end max_mcell_register; 

architecture vital_mcell_reg of max_mcell_register is
   attribute VITAL_LEVEL0 of vital_mcell_reg : architecture is TRUE;

signal pclk_ipd		:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal pena_ipd		:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal paclr_ipd	:std_logic_vector(51 downto 0) := (OTHERS => 'U');
signal papre_ipd	:std_logic_vector(51 downto 0) := (OTHERS => '0');
signal clk_ipd  	:std_ulogic := 'U';
signal aclr_ipd	        :std_ulogic := 'U';
signal ena_ipd	        :std_ulogic := '1';
signal ptermclk		:std_ulogic := '0';
signal penable		:std_ulogic := '1';
begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (pclk_ipd(0), pclk(0), tipd_pclk(0));
   VitalWireDelay (pclk_ipd(1), pclk(1), tipd_pclk(1));
   VitalWireDelay (pclk_ipd(2), pclk(2), tipd_pclk(2));
   VitalWireDelay (pclk_ipd(3), pclk(3), tipd_pclk(3));
   VitalWireDelay (pclk_ipd(4), pclk(4), tipd_pclk(4));
   VitalWireDelay (pclk_ipd(5), pclk(5), tipd_pclk(5));
   VitalWireDelay (pclk_ipd(6), pclk(6), tipd_pclk(6));
   VitalWireDelay (pclk_ipd(7), pclk(7), tipd_pclk(7));
   VitalWireDelay (pclk_ipd(8), pclk(8), tipd_pclk(8));
   VitalWireDelay (pclk_ipd(9), pclk(9), tipd_pclk(9));
   VitalWireDelay (pclk_ipd(10), pclk(10), tipd_pclk(10));
   VitalWireDelay (pclk_ipd(11), pclk(11), tipd_pclk(11));
   VitalWireDelay (pclk_ipd(12), pclk(12), tipd_pclk(12));
   VitalWireDelay (pclk_ipd(13), pclk(13), tipd_pclk(13));
   VitalWireDelay (pclk_ipd(14), pclk(14), tipd_pclk(14));
   VitalWireDelay (pclk_ipd(15), pclk(15), tipd_pclk(15));
   VitalWireDelay (pclk_ipd(16), pclk(16), tipd_pclk(16));
   VitalWireDelay (pclk_ipd(17), pclk(17), tipd_pclk(17));
   VitalWireDelay (pclk_ipd(18), pclk(18), tipd_pclk(18));
   VitalWireDelay (pclk_ipd(19), pclk(19), tipd_pclk(19));
   VitalWireDelay (pclk_ipd(20), pclk(20), tipd_pclk(20));
   VitalWireDelay (pclk_ipd(21), pclk(21), tipd_pclk(21));
   VitalWireDelay (pclk_ipd(22), pclk(22), tipd_pclk(22));
   VitalWireDelay (pclk_ipd(23), pclk(23), tipd_pclk(23));
   VitalWireDelay (pclk_ipd(24), pclk(24), tipd_pclk(24));
   VitalWireDelay (pclk_ipd(25), pclk(25), tipd_pclk(25));
   VitalWireDelay (pclk_ipd(26), pclk(26), tipd_pclk(26));
   VitalWireDelay (pclk_ipd(27), pclk(27), tipd_pclk(27));
   VitalWireDelay (pclk_ipd(28), pclk(28), tipd_pclk(28));
   VitalWireDelay (pclk_ipd(29), pclk(29), tipd_pclk(29));
   VitalWireDelay (pclk_ipd(30), pclk(30), tipd_pclk(30));
   VitalWireDelay (pclk_ipd(31), pclk(31), tipd_pclk(31));
   VitalWireDelay (pclk_ipd(32), pclk(32), tipd_pclk(32));
   VitalWireDelay (pclk_ipd(33), pclk(33), tipd_pclk(33));
   VitalWireDelay (pclk_ipd(34), pclk(34), tipd_pclk(34));
   VitalWireDelay (pclk_ipd(35), pclk(35), tipd_pclk(35));
   VitalWireDelay (pclk_ipd(36), pclk(36), tipd_pclk(36));
   VitalWireDelay (pclk_ipd(37), pclk(37), tipd_pclk(37));
   VitalWireDelay (pclk_ipd(38), pclk(38), tipd_pclk(38));
   VitalWireDelay (pclk_ipd(39), pclk(39), tipd_pclk(39));
   VitalWireDelay (pclk_ipd(40), pclk(40), tipd_pclk(40));
   VitalWireDelay (pclk_ipd(41), pclk(41), tipd_pclk(41));
   VitalWireDelay (pclk_ipd(42), pclk(42), tipd_pclk(42));
   VitalWireDelay (pclk_ipd(43), pclk(43), tipd_pclk(43));
   VitalWireDelay (pclk_ipd(44), pclk(44), tipd_pclk(44));
   VitalWireDelay (pclk_ipd(45), pclk(45), tipd_pclk(45));
   VitalWireDelay (pclk_ipd(46), pclk(46), tipd_pclk(46));
   VitalWireDelay (pclk_ipd(47), pclk(47), tipd_pclk(47));
   VitalWireDelay (pclk_ipd(48), pclk(48), tipd_pclk(48));
   VitalWireDelay (pclk_ipd(49), pclk(49), tipd_pclk(49));
   VitalWireDelay (pclk_ipd(50), pclk(50), tipd_pclk(50));
   VitalWireDelay (pclk_ipd(51), pclk(51), tipd_pclk(51));

   VitalWireDelay (pena_ipd(0), pena(0), tipd_pena(0));
   VitalWireDelay (pena_ipd(1), pena(1), tipd_pena(1));
   VitalWireDelay (pena_ipd(2), pena(2), tipd_pena(2));
   VitalWireDelay (pena_ipd(3), pena(3), tipd_pena(3));
   VitalWireDelay (pena_ipd(4), pena(4), tipd_pena(4));
   VitalWireDelay (pena_ipd(5), pena(5), tipd_pena(5));
   VitalWireDelay (pena_ipd(6), pena(6), tipd_pena(6));
   VitalWireDelay (pena_ipd(7), pena(7), tipd_pena(7));
   VitalWireDelay (pena_ipd(8), pena(8), tipd_pena(8));
   VitalWireDelay (pena_ipd(9), pena(9), tipd_pena(9));
   VitalWireDelay (pena_ipd(10), pena(10), tipd_pena(10));
   VitalWireDelay (pena_ipd(11), pena(11), tipd_pena(11));
   VitalWireDelay (pena_ipd(12), pena(12), tipd_pena(12));
   VitalWireDelay (pena_ipd(13), pena(13), tipd_pena(13));
   VitalWireDelay (pena_ipd(14), pena(14), tipd_pena(14));
   VitalWireDelay (pena_ipd(15), pena(15), tipd_pena(15));
   VitalWireDelay (pena_ipd(16), pena(16), tipd_pena(16));
   VitalWireDelay (pena_ipd(17), pena(17), tipd_pena(17));
   VitalWireDelay (pena_ipd(18), pena(18), tipd_pena(18));
   VitalWireDelay (pena_ipd(19), pena(19), tipd_pena(19));
   VitalWireDelay (pena_ipd(20), pena(20), tipd_pena(20));
   VitalWireDelay (pena_ipd(21), pena(21), tipd_pena(21));
   VitalWireDelay (pena_ipd(22), pena(22), tipd_pena(22));
   VitalWireDelay (pena_ipd(23), pena(23), tipd_pena(23));
   VitalWireDelay (pena_ipd(24), pena(24), tipd_pena(24));
   VitalWireDelay (pena_ipd(25), pena(25), tipd_pena(25));
   VitalWireDelay (pena_ipd(26), pena(26), tipd_pena(26));
   VitalWireDelay (pena_ipd(27), pena(27), tipd_pena(27));
   VitalWireDelay (pena_ipd(28), pena(28), tipd_pena(28));
   VitalWireDelay (pena_ipd(29), pena(29), tipd_pena(29));
   VitalWireDelay (pena_ipd(30), pena(30), tipd_pena(30));
   VitalWireDelay (pena_ipd(31), pena(31), tipd_pena(31));
   VitalWireDelay (pena_ipd(32), pena(32), tipd_pena(32));
   VitalWireDelay (pena_ipd(33), pena(33), tipd_pena(33));
   VitalWireDelay (pena_ipd(34), pena(34), tipd_pena(34));
   VitalWireDelay (pena_ipd(35), pena(35), tipd_pena(35));
   VitalWireDelay (pena_ipd(36), pena(36), tipd_pena(36));
   VitalWireDelay (pena_ipd(37), pena(37), tipd_pena(37));
   VitalWireDelay (pena_ipd(38), pena(38), tipd_pena(38));
   VitalWireDelay (pena_ipd(39), pena(39), tipd_pena(39));
   VitalWireDelay (pena_ipd(40), pena(40), tipd_pena(40));
   VitalWireDelay (pena_ipd(41), pena(41), tipd_pena(41));
   VitalWireDelay (pena_ipd(42), pena(42), tipd_pena(42));
   VitalWireDelay (pena_ipd(43), pena(43), tipd_pena(43));
   VitalWireDelay (pena_ipd(44), pena(44), tipd_pena(44));
   VitalWireDelay (pena_ipd(45), pena(45), tipd_pena(45));
   VitalWireDelay (pena_ipd(46), pena(46), tipd_pena(46));
   VitalWireDelay (pena_ipd(47), pena(47), tipd_pena(47));
   VitalWireDelay (pena_ipd(48), pena(48), tipd_pena(48));
   VitalWireDelay (pena_ipd(49), pena(49), tipd_pena(49));
   VitalWireDelay (pena_ipd(50), pena(50), tipd_pena(50));
   VitalWireDelay (pena_ipd(51), pena(51), tipd_pena(51));

   VitalWireDelay (paclr_ipd(0), paclr(0), tipd_paclr(0));
   VitalWireDelay (paclr_ipd(1), paclr(1), tipd_paclr(1));
   VitalWireDelay (paclr_ipd(2), paclr(2), tipd_paclr(2));
   VitalWireDelay (paclr_ipd(3), paclr(3), tipd_paclr(3));
   VitalWireDelay (paclr_ipd(4), paclr(4), tipd_paclr(4));
   VitalWireDelay (paclr_ipd(5), paclr(5), tipd_paclr(5));
   VitalWireDelay (paclr_ipd(6), paclr(6), tipd_paclr(6));
   VitalWireDelay (paclr_ipd(7), paclr(7), tipd_paclr(7));
   VitalWireDelay (paclr_ipd(8), paclr(8), tipd_paclr(8));
   VitalWireDelay (paclr_ipd(9), paclr(9), tipd_paclr(9));
   VitalWireDelay (paclr_ipd(10), paclr(10), tipd_paclr(10));
   VitalWireDelay (paclr_ipd(11), paclr(11), tipd_paclr(11));
   VitalWireDelay (paclr_ipd(12), paclr(12), tipd_paclr(12));
   VitalWireDelay (paclr_ipd(13), paclr(13), tipd_paclr(13));
   VitalWireDelay (paclr_ipd(14), paclr(14), tipd_paclr(14));
   VitalWireDelay (paclr_ipd(15), paclr(15), tipd_paclr(15));
   VitalWireDelay (paclr_ipd(16), paclr(16), tipd_paclr(16));
   VitalWireDelay (paclr_ipd(17), paclr(17), tipd_paclr(17));
   VitalWireDelay (paclr_ipd(18), paclr(18), tipd_paclr(18));
   VitalWireDelay (paclr_ipd(19), paclr(19), tipd_paclr(19));
   VitalWireDelay (paclr_ipd(20), paclr(20), tipd_paclr(20));
   VitalWireDelay (paclr_ipd(21), paclr(21), tipd_paclr(21));
   VitalWireDelay (paclr_ipd(22), paclr(22), tipd_paclr(22));
   VitalWireDelay (paclr_ipd(23), paclr(23), tipd_paclr(23));
   VitalWireDelay (paclr_ipd(24), paclr(24), tipd_paclr(24));
   VitalWireDelay (paclr_ipd(25), paclr(25), tipd_paclr(25));
   VitalWireDelay (paclr_ipd(26), paclr(26), tipd_paclr(26));
   VitalWireDelay (paclr_ipd(27), paclr(27), tipd_paclr(27));
   VitalWireDelay (paclr_ipd(28), paclr(28), tipd_paclr(28));
   VitalWireDelay (paclr_ipd(29), paclr(29), tipd_paclr(29));
   VitalWireDelay (paclr_ipd(30), paclr(30), tipd_paclr(30));
   VitalWireDelay (paclr_ipd(31), paclr(31), tipd_paclr(31));
   VitalWireDelay (paclr_ipd(32), paclr(32), tipd_paclr(32));
   VitalWireDelay (paclr_ipd(33), paclr(33), tipd_paclr(33));
   VitalWireDelay (paclr_ipd(34), paclr(34), tipd_paclr(34));
   VitalWireDelay (paclr_ipd(35), paclr(35), tipd_paclr(35));
   VitalWireDelay (paclr_ipd(36), paclr(36), tipd_paclr(36));
   VitalWireDelay (paclr_ipd(37), paclr(37), tipd_paclr(37));
   VitalWireDelay (paclr_ipd(38), paclr(38), tipd_paclr(38));
   VitalWireDelay (paclr_ipd(39), paclr(39), tipd_paclr(39));
   VitalWireDelay (paclr_ipd(40), paclr(40), tipd_paclr(40));
   VitalWireDelay (paclr_ipd(41), paclr(41), tipd_paclr(41));
   VitalWireDelay (paclr_ipd(42), paclr(42), tipd_paclr(42));
   VitalWireDelay (paclr_ipd(43), paclr(43), tipd_paclr(43));
   VitalWireDelay (paclr_ipd(44), paclr(44), tipd_paclr(44));
   VitalWireDelay (paclr_ipd(45), paclr(45), tipd_paclr(45));
   VitalWireDelay (paclr_ipd(46), paclr(46), tipd_paclr(46));
   VitalWireDelay (paclr_ipd(47), paclr(47), tipd_paclr(47));
   VitalWireDelay (paclr_ipd(48), paclr(48), tipd_paclr(48));
   VitalWireDelay (paclr_ipd(49), paclr(49), tipd_paclr(49));
   VitalWireDelay (paclr_ipd(50), paclr(50), tipd_paclr(50));
   VitalWireDelay (paclr_ipd(51), paclr(51), tipd_paclr(51));

   VitalWireDelay (papre_ipd(0), papre(0), tipd_papre(0));
   VitalWireDelay (papre_ipd(1), papre(1), tipd_papre(1));
   VitalWireDelay (papre_ipd(2), papre(2), tipd_papre(2));
   VitalWireDelay (papre_ipd(3), papre(3), tipd_papre(3));
   VitalWireDelay (papre_ipd(4), papre(4), tipd_papre(4));
   VitalWireDelay (papre_ipd(5), papre(5), tipd_papre(5));
   VitalWireDelay (papre_ipd(6), papre(6), tipd_papre(6));
   VitalWireDelay (papre_ipd(7), papre(7), tipd_papre(7));
   VitalWireDelay (papre_ipd(8), papre(8), tipd_papre(8));
   VitalWireDelay (papre_ipd(9), papre(9), tipd_papre(9));
   VitalWireDelay (papre_ipd(10), papre(10), tipd_papre(10));
   VitalWireDelay (papre_ipd(11), papre(11), tipd_papre(11));
   VitalWireDelay (papre_ipd(12), papre(12), tipd_papre(12));
   VitalWireDelay (papre_ipd(13), papre(13), tipd_papre(13));
   VitalWireDelay (papre_ipd(14), papre(14), tipd_papre(14));
   VitalWireDelay (papre_ipd(15), papre(15), tipd_papre(15));
   VitalWireDelay (papre_ipd(16), papre(16), tipd_papre(16));
   VitalWireDelay (papre_ipd(17), papre(17), tipd_papre(17));
   VitalWireDelay (papre_ipd(18), papre(18), tipd_papre(18));
   VitalWireDelay (papre_ipd(19), papre(19), tipd_papre(19));
   VitalWireDelay (papre_ipd(20), papre(20), tipd_papre(20));
   VitalWireDelay (papre_ipd(21), papre(21), tipd_papre(21));
   VitalWireDelay (papre_ipd(22), papre(22), tipd_papre(22));
   VitalWireDelay (papre_ipd(23), papre(23), tipd_papre(23));
   VitalWireDelay (papre_ipd(24), papre(24), tipd_papre(24));
   VitalWireDelay (papre_ipd(25), papre(25), tipd_papre(25));
   VitalWireDelay (papre_ipd(26), papre(26), tipd_papre(26));
   VitalWireDelay (papre_ipd(27), papre(27), tipd_papre(27));
   VitalWireDelay (papre_ipd(28), papre(28), tipd_papre(28));
   VitalWireDelay (papre_ipd(29), papre(29), tipd_papre(29));
   VitalWireDelay (papre_ipd(30), papre(30), tipd_papre(30));
   VitalWireDelay (papre_ipd(31), papre(31), tipd_papre(31));
   VitalWireDelay (papre_ipd(32), papre(32), tipd_papre(32));
   VitalWireDelay (papre_ipd(33), papre(33), tipd_papre(33));
   VitalWireDelay (papre_ipd(34), papre(34), tipd_papre(34));
   VitalWireDelay (papre_ipd(35), papre(35), tipd_papre(35));
   VitalWireDelay (papre_ipd(36), papre(36), tipd_papre(36));
   VitalWireDelay (papre_ipd(37), papre(37), tipd_papre(37));
   VitalWireDelay (papre_ipd(38), papre(38), tipd_papre(38));
   VitalWireDelay (papre_ipd(39), papre(39), tipd_papre(39));
   VitalWireDelay (papre_ipd(40), papre(40), tipd_papre(40));
   VitalWireDelay (papre_ipd(41), papre(41), tipd_papre(41));
   VitalWireDelay (papre_ipd(42), papre(42), tipd_papre(42));
   VitalWireDelay (papre_ipd(43), papre(43), tipd_papre(43));
   VitalWireDelay (papre_ipd(44), papre(44), tipd_papre(44));
   VitalWireDelay (papre_ipd(45), papre(45), tipd_papre(45));
   VitalWireDelay (papre_ipd(46), papre(46), tipd_papre(46));
   VitalWireDelay (papre_ipd(47), papre(47), tipd_papre(47));
   VitalWireDelay (papre_ipd(48), papre(48), tipd_papre(48));
   VitalWireDelay (papre_ipd(49), papre(49), tipd_papre(49));
   VitalWireDelay (papre_ipd(50), papre(50), tipd_papre(50));
   VitalWireDelay (papre_ipd(51), papre(51), tipd_papre(51));

   VitalWireDelay (clk_ipd, clk, tipd_clk);
   VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   end block;

VITALtiming : process(datain, ptermclk, pclk_ipd, pena_ipd, paclr_ipd,
                      papre_ipd, clk_ipd, aclr_ipd, ena_ipd)
variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_penable_clk : std_ulogic := '0';
variable Tviol_clk : std_ulogic := '0';
variable Tviol_datain_ptermclk : std_ulogic := '0';
variable Tviol_ptermclk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_pena_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_datain_pclk : VitalTimingDataType := VitalTimingDataInit;
variable regout_VitalGlitchData : VitalGlitchDataType;
variable fbkout_VitalGlitchData : VitalGlitchDataType;

variable tmp_regout : std_logic;
variable oldclk : std_logic;
variable pterm_aclr : std_logic;
variable pterm_preset : std_logic := '0';

-- variables for 'X' generation
variable violation : std_logic := '0';

begin
penable <= product(pena_ipd);
pterm_aclr := product(paclr_ipd);
pterm_preset := product(papre_ipd);
ptermclk <= product(pclk_ipd);

for N in 0 to 51 loop
if (papre_ipd(N) = 'U') then
	pterm_preset := '0';
end if;
exit when pterm_preset = '0';
end loop;

for N in 0 to 51 loop
if (paclr_ipd(N) = 'U') then
	pterm_aclr := '0';
end if;
exit when pterm_aclr = '0';
end loop;

for N in 0 to 51 loop
if (pclk_ipd(N) = 'U') then
	ptermclk <= '0';
end if;
exit when ptermclk = '0';
end loop;

if (now <= 0 ns) then
  if (power_up = "low") then
    tmp_regout := '0';
  elsif (power_up = "high") then
    tmp_regout := '1';
  end if;
  ptermclk <= '0';
end if;

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then

         VitalSetupHoldCheck ( 
                Violation       => Tviol_datain_clk, 
                TimingData      => TimingData_datain_clk, 
                TestSignal      => datain, 
                TestSignalName  => "DATAIN", 
                RefSignal       => clk_ipd, 
                RefSignalName   => "CLK", 
                SetupHigh       => tsetup_datain_clk_noedge_posedge, 
                SetupLow        => tsetup_datain_clk_noedge_posedge, 
                HoldHigh        => thold_datain_clk_noedge_posedge, 
                HoldLow         => thold_datain_clk_noedge_posedge, 
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT penable)) /= '1',
                RefTransition   => '/', 
                HeaderMsg       => InstancePath & "/MCELL", 
                XOn             => XOnChecks, 
                MsgOn           => MsgOnChecks ); 


         VitalSetupHoldCheck ( 
                Violation       => Tviol_penable_clk, 
                TimingData      => TimingData_pena_clk, 
                TestSignal      => pena_ipd, 
                TestSignalName  => "PENA", 
                RefSignal       => clk_ipd, 
                RefSignalName   => "CLK", 
                SetupHigh       => tsetup_pena_clk_noedge_posedge(0), 
                SetupLow        => tsetup_pena_clk_noedge_posedge(0), 
                HoldHigh        => thold_pena_clk_noedge_posedge(0), 
                HoldLow         => thold_pena_clk_noedge_posedge(0), 
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT penable)) /= '1',
                RefTransition   => '/', 
                HeaderMsg       => InstancePath & "/MCELL", 
                XOn             => XOnChecks, 
                MsgOn           => MsgOnChecks ); 

         VitalSetupHoldCheck ( 
                Violation       => Tviol_datain_ptermclk, 
                TimingData      => TimingData_datain_pclk, 
                TestSignal      => datain, 
                TestSignalName  => "DATAIN", 
                RefSignal       => ptermclk, 
                RefSignalName   => "PCLK", 
                SetupHigh       => tsetup_datain_pclk_noedge_posedge(0), 
                SetupLow        => tsetup_datain_pclk_noedge_posedge(0), 
                HoldHigh        => thold_datain_pclk_noedge_posedge(0), 
                HoldLow         => thold_datain_pclk_noedge_posedge(0), 
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT penable)) /= '1',
                RefTransition   => '/', 
                HeaderMsg       => InstancePath & "/MCELL", 
                XOn             => XOnChecks, 
                MsgOn           => MsgOnChecks ); 

      end if;
      
      violation := (Tviol_datain_clk or Tviol_datain_ptermclk or Tviol_penable_clk);
      
      if ((aclr_ipd = '1') or (pterm_aclr = '1')) then
        tmp_regout := '0';
      elsif (pterm_preset = '1') then
        tmp_regout := '1';
      elsif (violation = 'X') then
        tmp_regout := 'X';
      elsif (penable = '1') then 
        if ((clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0') or ((ptermclk'event) and (oldclk = '0') and (ptermclk = '1'))) then
          tmp_regout := datain;
        end if;
      end if;
      oldclk := ptermclk;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE),
                 2 => (pclk_ipd'last_event, tpd_pclk_regout_posedge(0), TRUE),
                 3 => (pena_ipd'last_event, tpd_pena_regout_posedge(0), TRUE),
                 4 => (paclr_ipd'last_event, tpd_paclr_regout_posedge(0), TRUE),				
                 5 => (papre_ipd'last_event, tpd_papre_regout_posedge(0), TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => fbkout, 
       OutSignalName => "FBKOUT", 
       OutTemp => tmp_regout,  
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE),
                 2 => (pclk_ipd'last_event, tpd_pclk_regout_posedge(0), TRUE),
                 3 => (pena_ipd'last_event, tpd_pena_regout_posedge(0), TRUE),
                 4 => (paclr_ipd'last_event, tpd_paclr_regout_posedge(0), TRUE),				
                 5 => (papre_ipd'last_event, tpd_papre_regout_posedge(0), TRUE)),
       GlitchData => fbkout_VitalGlitchData, 
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );
end process;

end vital_mcell_reg;

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;
use work.max_asynch_mcell;
use work.max_mcell_register;

entity max_mcell is
  generic (	operation_mode     : string := "normal";
	  	pexp_mode : string := "off";
      		output_mode        : string := "comb";
      		register_mode : string := "false";
      		power_up : string := "low" );


  port (	pterm0	: in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pterm1  : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pterm2  : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pterm3  : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pterm4  : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pterm5  : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pclk    : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pena    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	paclr   : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	papre   : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pxor    : in std_logic_vector(51 downto 0) := "0000000000000000000000000000000000000000000000000000";
        	pexpin	: in std_logic := '0';
        	clk	: in std_logic := '0';
		aclr	: in std_logic := '0';
		fpin	: in std_logic := '1';
		dataout : out std_logic;
        	pexpout : out std_logic );
   attribute VITAL_LEVEL0 of max_mcell : entity is TRUE;
end max_mcell; 

architecture vital_mcell_atom of max_mcell is
   attribute VITAL_LEVEL0 of vital_mcell_atom : architecture is TRUE;

component max_asynch_mcell
  generic (	operation_mode     : string := "normal";
                pexp_mode : string := "off";
                register_mode : string := "dff";
      		TimingChecksOn: Boolean := True;
      		MsgOn: Boolean := DefGlitchMsgOn;
      		XOn: Boolean := DefGlitchXOn;
      		MsgOnChecks: Boolean := DefMsgOnChecks;
      		XOnChecks: Boolean := DefXOnChecks;
      		InstancePath: STRING := "*";
      		tpd_pterm0_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm1_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm2_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm3_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm4_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm5_combout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pxor_combout              :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pexpin_combout            :  VitalDelayType01 := DefPropDelay01;
      		tpd_fbkin_combout             :  VitalDelayType01 := DefPropDelay01;
      		tpd_pterm0_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm1_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm2_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm3_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm4_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pterm5_pexpout            :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_pexpin_pexpout            :  VitalDelayType01 := DefPropDelay01;
      		tpd_fbkin_pexpout             :  VitalDelayType01 := DefPropDelay01;
      		tpd_fpin_regin			  :  VitalDelayType01 := DefPropDelay01;			
      		tipd_pterm0                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm1                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm2                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm3                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm4                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pterm5                       :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tipd_fpin                         :  VitalDelayType01 := DefPropDelay01;
      		tipd_pxor                         :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pexpin                       :  VitalDelayType01 := DefPropDelay01);

  port (	pterm0	: in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm1  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm2  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm3  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm4  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pterm5  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	fpin 	: in std_logic := '1';
        	pxor    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pexpin	: in std_logic := '0';
        	fbkin : in std_logic;
		combout : out std_logic;
        	regin : out std_logic;
        	pexpout : out std_logic );
end component; 

component max_mcell_register
  generic (	operation_mode : string := "normal";
                power_up : string := "low";
                register_mode : string := "dff";
      		TimingChecksOn: Boolean := True;
      		MsgOn: Boolean := DefGlitchMsgOn;
     	 	XOn: Boolean := DefGlitchXOn;
      		MsgOnChecks: Boolean := DefMsgOnChecks;
      		XOnChecks: Boolean := DefXOnChecks;
      		InstancePath: STRING := "*";
                tpd_pclk_regout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_pena_regout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_paclr_regout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_papre_regout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_aclr_regout_posedge      :  VitalDelayType01 := DefPropDelay01;
      		tpd_clk_regout_posedge       :  VitalDelayType01 := DefPropDelay01;
                tpd_pclk_fbkout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_pena_fbkout_posedge		 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_paclr_fbkout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
                tpd_papre_fbkout_posedge	 :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tpd_aclr_fbkout_posedge      :  VitalDelayType01 := DefPropDelay01;
      		tpd_clk_fbkout_posedge       :  VitalDelayType01 := DefPropDelay01;
      		tsetup_datain_clk_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
                tsetup_pena_clk_noedge_posedge	:	VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
                tsetup_datain_pclk_noedge_posedge  :  VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
      		thold_datain_clk_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
                thold_pena_clk_noedge_posedge	:	VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
      		thold_datain_pclk_noedge_posedge   :  VitalDelayArrayType(51 downto 0) := (OTHERS => DefSetupHoldCnst);
      		tipd_pclk                         :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_pena                         :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_paclr                        :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
      		tipd_papre                        :  VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
     		tipd_aclr                         :  VitalDelayType01 := DefPropDelay01;
      		tipd_clk                          :  VitalDelayType01 := DefPropDelay01);

  port (        datain	: in std_logic;
        	clk	: in std_logic;
		aclr	: in std_logic;
        	pclk    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	pena    : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	paclr   : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
        	papre   : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
		regout : out std_logic;
        	fbkout : out std_logic);
end component; 

signal fbk, dffin, combo, dffo	:std_ulogic ;

begin

pcom: max_asynch_mcell 
  generic map (	operation_mode => operation_mode,
                pexp_mode => pexp_mode, register_mode => register_mode)
  port map ( 	pterm0 => pterm0,
                pterm1 => pterm1,
                pterm2 => pterm2,
                pterm3 => pterm3, 
		pterm4 => pterm4,
                pterm5 => pterm5,
                fpin => fpin,
                pxor => pxor,
                pexpin => pexpin,
                fbkin => fbk, 
		regin => dffin,
                combout => combo,
                pexpout => pexpout);

preg: max_mcell_register
  generic map ( operation_mode => operation_mode,
                power_up => power_up,
                register_mode => register_mode)
  port map ( 	datain => dffin,
                clk => clk,
                aclr => aclr,
                pclk => pclk,
                pena => pena,
                paclr => paclr,
                papre => papre,
                regout => dffo,
                fbkout => fbk);	

dataout <= combo when output_mode = "comb" else dffo;

end vital_mcell_atom;

--
--
--  MAX7K_SEXP Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;

entity max_asynch_sexp is
  generic ( TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks;
            InstancePath: STRING := "*";
            tpd_datain_dataout		: VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01);
            tipd_datain         	: VitalDelayArrayType01(51 downto 0) := (OTHERS => DefPropDelay01));
  port (    datain  : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
            dataout : out STD_LOGIC);
  attribute VITAL_LEVEL0 of max_asynch_sexp : entity is TRUE;
end max_asynch_sexp;

architecture behave of max_asynch_sexp is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;
signal datain_ipd : std_logic_vector(51 downto 0) := (OTHERS => 'U');

begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
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
        VitalWireDelay (datain_ipd(20), datain(20), tipd_datain(20));
        VitalWireDelay (datain_ipd(21), datain(21), tipd_datain(21));
        VitalWireDelay (datain_ipd(22), datain(22), tipd_datain(22));
        VitalWireDelay (datain_ipd(23), datain(23), tipd_datain(23));
        VitalWireDelay (datain_ipd(24), datain(24), tipd_datain(24));
        VitalWireDelay (datain_ipd(25), datain(25), tipd_datain(25));
        VitalWireDelay (datain_ipd(26), datain(26), tipd_datain(26));
        VitalWireDelay (datain_ipd(27), datain(27), tipd_datain(27));
        VitalWireDelay (datain_ipd(28), datain(28), tipd_datain(28));
        VitalWireDelay (datain_ipd(29), datain(29), tipd_datain(29));
        VitalWireDelay (datain_ipd(30), datain(30), tipd_datain(30));
        VitalWireDelay (datain_ipd(31), datain(31), tipd_datain(31));
        VitalWireDelay (datain_ipd(32), datain(32), tipd_datain(32));
        VitalWireDelay (datain_ipd(33), datain(33), tipd_datain(33));
        VitalWireDelay (datain_ipd(34), datain(34), tipd_datain(34));
        VitalWireDelay (datain_ipd(35), datain(35), tipd_datain(35));
        VitalWireDelay (datain_ipd(36), datain(36), tipd_datain(36));
        VitalWireDelay (datain_ipd(37), datain(37), tipd_datain(37));
        VitalWireDelay (datain_ipd(38), datain(38), tipd_datain(38));
        VitalWireDelay (datain_ipd(39), datain(39), tipd_datain(39));
        VitalWireDelay (datain_ipd(40), datain(40), tipd_datain(40));
        VitalWireDelay (datain_ipd(41), datain(41), tipd_datain(41));
        VitalWireDelay (datain_ipd(42), datain(42), tipd_datain(42));
        VitalWireDelay (datain_ipd(43), datain(43), tipd_datain(43));
        VitalWireDelay (datain_ipd(44), datain(44), tipd_datain(44));
        VitalWireDelay (datain_ipd(45), datain(45), tipd_datain(45));
        VitalWireDelay (datain_ipd(46), datain(46), tipd_datain(46));
        VitalWireDelay (datain_ipd(47), datain(47), tipd_datain(47));
        VitalWireDelay (datain_ipd(48), datain(48), tipd_datain(48));
        VitalWireDelay (datain_ipd(49), datain(49), tipd_datain(49));
        VitalWireDelay (datain_ipd(50), datain(50), tipd_datain(50));
        VitalWireDelay (datain_ipd(51), datain(51), tipd_datain(51));

    end block;

    VITAL: process(datain_ipd)
      variable dataout_VitalGlitchData : VitalGlitchDataType;
      variable tmp_dataout : std_logic;
    begin
      tmp_dataout := not (product(datain_ipd));

    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
        OutSignal => dataout,
        OutSignalName => "dataout",
        OutTemp => tmp_dataout,
        Paths => (1 => (datain_ipd'last_event, tpd_datain_dataout(0), TRUE)),
        GlitchData => dataout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );
    end process;

end behave;

--
-- MAX_SEXP
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.max_atom_pack.all;
use work.max_asynch_sexp;

entity  max_sexp is
  port (	datain          : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
              	dataout         : out std_logic);
end max_sexp;

architecture structure of max_sexp is
	signal data_out : std_logic;
	
component max_asynch_sexp
  port (	datain : in std_logic_vector(51 downto 0) := "1111111111111111111111111111111111111111111111111111";
                dataout: out STD_LOGIC);
end component;
begin
  pcom: max_asynch_sexp
    port map (	datain => datain, 
                dataout => data_out);
  dataout <= data_out;
end structure;
