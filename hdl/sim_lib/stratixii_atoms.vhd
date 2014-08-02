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

package stratixii_atom_pack is

function str_to_bin (lut_mask : string ) return std_logic_vector;

function product(list : std_logic_vector) return std_logic ;

function alt_conv_integer(arg : in std_logic_vector) return integer;


-- default generic values
    CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
    CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
    CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
-- default control options
--    CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
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

-- Declare array types for CAM_SLICE
    TYPE stratixii_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

function int2str( value : integer ) return string;

function map_x_to_0 (value : std_logic) return std_logic;

function SelectDelay (CONSTANT Paths: IN  VitalPathArray01Type) return TIME;

function int2bit (arg : boolean) return std_logic;
function int2bit (arg : integer) return std_logic;
function bin2int (s : std_logic_vector) return integer;
function bin2int (s : std_logic) return integer;
function int2bin (arg : integer; size : integer) return std_logic_vector;
function int2bin (arg : boolean; size : integer) return std_logic_vector;
function calc_sum_len( widtha : integer; widthb : integer) return integer;

end stratixii_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body stratixii_atom_pack is

type masklength is array (4 downto 1) of std_logic_vector(3 downto 0);
function str_to_bin (lut_mask : string) return std_logic_vector is
variable slice : masklength := (OTHERS => "0000");
variable mask : std_logic_vector(15 downto 0);


begin

    for i in 1 to lut_mask'length loop
        case lut_mask(i) is
            when '0' => slice(i) := "0000";
            when '1' => slice(i) := "0001";
            when '2' => slice(i) := "0010";
            when '3' => slice(i) := "0011";
            when '4' => slice(i) := "0100";
            when '5' => slice(i) := "0101";
            when '6' => slice(i) := "0110";
            when '7' => slice(i) := "0111";
            when '8' => slice(i) := "1000";
            when '9' => slice(i) := "1001";
            when 'a' => slice(i) := "1010";
            when 'A' => slice(i) := "1010";
            when 'b' => slice(i) := "1011";
            when 'B' => slice(i) := "1011";
            when 'c' => slice(i) := "1100";
            when 'C' => slice(i) := "1100";
            when 'd' => slice(i) := "1101";
            when 'D' => slice(i) := "1101";
            when 'e' => slice(i) := "1110";
            when 'E' => slice(i) := "1110";
            when others => slice(i) := "1111";
        end case;
    end loop;
 
 
    mask := (slice(1) & slice(2) & slice(3) & slice(4));
    return (mask);
 
end str_to_bin;
 
function product (list: std_logic_vector) return std_logic is
begin

    for i in 0 to 31 loop
        if list(i) = '0' then
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

function int2str( value : integer ) return string is
variable ivalue,index : integer;
variable digit : integer;
variable line_no: string(8 downto 1) := "        ";
begin
    ivalue := value;
    index := 1;
    if (ivalue = 0) then
        line_no := "       0";
    end if;
    while (ivalue > 0) loop
        digit := ivalue MOD 10;
        ivalue := ivalue/10;
        case digit is
            when 0 =>
                    line_no(index) := '0';
            when 1 =>
                    line_no(index) := '1';
            when 2 =>
                    line_no(index) := '2';
            when 3 =>
                    line_no(index) := '3';
            when 4 =>
                    line_no(index) := '4';
            when 5 =>
                    line_no(index) := '5';
            when 6 =>
                    line_no(index) := '6';
            when 7 =>
                    line_no(index) := '7';
            when 8 =>
                    line_no(index) := '8';
            when 9 =>
                    line_no(index) := '9';
            when others =>
                    ASSERT FALSE
                    REPORT "Illegal number!"
                    SEVERITY ERROR;
        end case;
        index := index + 1;
    end loop;
    return line_no;
end;

function map_x_to_0 (value : std_logic) return std_logic is
begin
    if (Is_X (value) = TRUE) then
        return '0';
    else
        return value;
    end if;
end;

function SelectDelay (CONSTANT Paths : IN  VitalPathArray01Type) return TIME IS

variable Temp  : TIME;
variable TransitionTime  : TIME := TIME'HIGH;
variable PathDelay : TIME := TIME'HIGH;

begin

    for i IN Paths'RANGE loop
        next when not Paths(i).PathCondition;

        next when Paths(i).InputChangeTime > TransitionTime;

        Temp := Paths(i).PathDelay(tr01);

        if Paths(i).InputChangeTime < TransitionTime then
            PathDelay := Temp;
        else
            if Temp < PathDelay then
                PathDelay := Temp;
            end if;
        end if;
        TransitionTime := Paths(i).InputChangeTime;
    end loop;

    return PathDelay;

end;

function int2bit (arg : integer) return std_logic is
    variable int_val : integer := arg;
    variable result : std_logic;
    begin
        
            if (int_val  = 0) then
                result := '0';
            else
                result := '1';
            end if;
            
        return result;
end int2bit;

function int2bit (arg : boolean) return std_logic is
    variable int_val : boolean := arg;
    variable result : std_logic;
    begin
        
            if (int_val ) then
                result := '1';
            else
                result := '0';
            end if;
            
        return result;
end int2bit;

function bin2int (s : std_logic_vector) return integer is

      constant temp      : std_logic_vector(s'high-s'low DOWNTO 0) := s;      
      variable result      : integer := 0;
   begin
      for i in temp'range loop
         if (temp(i) = '1') then
            result := result + (2**i);
         end if;
      end loop;
      return(result);
   end bin2int;
                  
function bin2int (s : std_logic) return integer is
      constant temp      : std_logic := s;      
      variable result      : integer := 0;
   begin
         if (temp = '1') then
            result := 1;
         else
                result := 0;
         end if;
      return(result);
        end bin2int;

        function int2bin (arg : integer; size : integer) return std_logic_vector is
    variable int_val : integer := arg;
    variable result : std_logic_vector(size-1 downto 0);
    begin
        for i in 0 to result'left loop
            if ((int_val mod 2) = 0) then
                result(i) := '0';
            else
                result(i) := '1';
            end if;
            int_val := int_val/2;
        end loop;
        return result;
    end int2bin;
    
function int2bin (arg : boolean; size : integer) return std_logic_vector is
    variable result : std_logic_vector(size-1 downto 0);
    begin
                if(arg)then
                        result := (OTHERS => '1');
                else
                        result := (OTHERS => '0');
                end if;
        return result;
    end int2bin;

function calc_sum_len( widtha : integer; widthb : integer) return integer is
variable result: integer;
begin
        if(widtha >= widthb) then
                result := widtha + 1;
        else
                result := widthb + 1;
        end if;
        return result;
end calc_sum_len;

end stratixii_atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package stratixii_pllpack is


    procedure find_simple_integer_fraction( numerator   : in integer;
                                            denominator : in integer;
                                            max_denom   : in integer;
                                            fraction_num : out integer; 
                                            fraction_div : out integer);

    procedure find_m_and_n_4_manual_phase ( inclock_period : in integer;
                                            vco_phase_shift_step : in integer;
                                            clk0_mult: in integer; clk1_mult: in integer;
                                            clk2_mult: in integer; clk3_mult: in integer;
                                            clk4_mult: in integer; clk5_mult: in integer;
                                            clk6_mult: in integer; clk7_mult: in integer;
                                            clk8_mult: in integer; clk9_mult: in integer;
                                            clk0_div : in integer; clk1_div : in integer;
                                            clk2_div : in integer; clk3_div : in integer;
                                            clk4_div : in integer; clk5_div : in integer;
                                            clk6_div : in integer; clk7_div : in integer;
                                            clk8_div : in integer; clk9_div : in integer;
                                            clk0_used : in string; clk1_used : in string;
                                            clk2_used : in string; clk3_used : in string;
                                            clk4_used : in string; clk5_used : in string;
                                            clk6_used : in string; clk7_used : in string;
                                            clk8_used : in string; clk9_used : in string;
                                            m : out integer;
                                            n : out integer );

    function gcd (X: integer; Y: integer) return integer;

    function count_digit (X: integer) return integer;

    function scale_num (X: integer; Y: integer) return integer;

    function lcm (A1: integer; A2: integer; A3: integer; A4: integer;
                A5: integer; A6: integer; A7: integer;
                A8: integer; A9: integer; A10: integer; P: integer) return integer;

    function output_counter_value (clk_divide: integer; clk_mult : integer ;
            M: integer; N: integer ) return integer;

    function counter_mode (duty_cycle: integer; output_counter_value: integer) return string;

    function counter_high (output_counter_value: integer := 1; duty_cycle: integer)
                        return integer;

    function counter_low (output_counter_value: integer; duty_cycle: integer)
                        return integer;

    function mintimedelay (t1: integer; t2: integer; t3: integer; t4: integer;
                        t5: integer; t6: integer; t7: integer; t8: integer;
                        t9: integer; t10: integer) return integer;

    function maxnegabs (t1: integer; t2: integer; t3: integer; t4: integer;
                        t5: integer; t6: integer; t7: integer; t8: integer;
                        t9: integer; t10: integer) return integer;

    function counter_time_delay ( clk_time_delay: integer;
                        m_time_delay: integer; n_time_delay: integer)
                        return integer;

    function get_phase_degree (phase_shift: integer; clk_period: integer) return integer;

    function counter_initial (tap_phase: integer; m: integer; n: integer)
                        return integer;

    function counter_ph (tap_phase: integer; m : integer; n: integer) return integer;

    function ph_adjust (tap_phase: integer; ph_base : integer) return integer;

    function translate_string (mode : string) return string;
    
    function str2int (s : string) return integer;

    function dqs_str2int (s : string) return integer;

end stratixii_pllpack;

package body stratixii_pllpack is


-- finds the closest integer fraction of a given pair of numerator and denominator. 
procedure find_simple_integer_fraction( numerator   : in integer;
                                        denominator : in integer;
                                        max_denom   : in integer;
                                        fraction_num : out integer; 
                                        fraction_div : out integer) is
    constant MAX_ITER : integer := 20; 
    type INT_ARRAY is array ((MAX_ITER-1) downto 0) of integer;

    variable quotient_array : INT_ARRAY;
    variable int_loop_iter : integer;
    variable int_quot  : integer;
    variable m_value   : integer;
    variable d_value   : integer;
    variable old_m_value : integer;
    variable swap  : integer;
    variable loop_iter : integer;
    variable num   : integer;
    variable den   : integer;
    variable i_max_iter : integer;

begin      
    loop_iter := 0;

    if (numerator = 0) then
        num := 1;
    else
        num := numerator;
    end if;

    if (denominator = 0) then
        den := 1;
    else
        den := denominator;
    end if;

    i_max_iter := max_iter;
   
    while (loop_iter < i_max_iter) loop
        int_quot := num / den;
        quotient_array(loop_iter) := int_quot;
        num := num - (den*int_quot);
        loop_iter := loop_iter+1;
        
        if ((num = 0) or (max_denom /= -1) or (loop_iter = i_max_iter)) then
            -- calculate the numerator and denominator if there is a restriction on the
            -- max denom value or if the loop is ending
            m_value := 0;
            d_value := 1;
            -- get the rounded value at this stage for the remaining fraction
            if (den /= 0) then
                m_value := (2*num/den);
            end if;
            -- calculate the fraction numerator and denominator at this stage
            for int_loop_iter in (loop_iter-1) downto 0 loop
                if (m_value = 0) then
                    m_value := quotient_array(int_loop_iter);
                    d_value := 1;
                else
                    old_m_value := m_value;
                    m_value := (quotient_array(int_loop_iter)*m_value) + d_value;
                    d_value := old_m_value;
                end if;
            end loop;
            -- if the denominator is less than the maximum denom_value or if there is no restriction save it
            if ((d_value <= max_denom) or (max_denom = -1)) then
                if ((m_value = 0) or (d_value = 0)) then
                    fraction_num := numerator;
                    fraction_div := denominator;
                else
                    fraction_num := m_value;
                    fraction_div := d_value;
                end if;
            end if;
            -- end the loop if the denomitor has overflown or the numerator is zero (no remainder during this round)
            if (((d_value > max_denom) and (max_denom /= -1)) or (num = 0)) then
                i_max_iter := loop_iter;
            end if;
        end if;
        -- swap the numerator and denominator for the next round
        swap := den;
        den := num;
        num := swap;
    end loop;
end find_simple_integer_fraction;

-- find the M and N values for Manual phase based on the following 5 criterias:
-- 1. The PFD frequency (i.e. Fin / N) must be in the range 5 MHz to 720 MHz
-- 2. The VCO frequency (i.e. Fin * M / N) must be in the range 300 MHz to 1300 MHz
-- 3. M is less than 512
-- 4. N is less than 512
-- 5. It's the smallest M/N which satisfies all the above constraints, and is within 2ps
--    of the desired vco-phase-shift-step
procedure find_m_and_n_4_manual_phase ( inclock_period : in integer;
                                        vco_phase_shift_step : in integer;
                                        clk0_mult: in integer; clk1_mult: in integer;
                                        clk2_mult: in integer; clk3_mult: in integer;
                                        clk4_mult: in integer; clk5_mult: in integer;
                                        clk6_mult: in integer; clk7_mult: in integer;
                                        clk8_mult: in integer; clk9_mult: in integer;
                                        clk0_div : in integer; clk1_div : in integer;
                                        clk2_div : in integer; clk3_div : in integer;
                                        clk4_div : in integer; clk5_div : in integer;
                                        clk6_div : in integer; clk7_div : in integer;
                                        clk8_div : in integer; clk9_div : in integer;
                                        clk0_used : in string; clk1_used : in string;
                                        clk2_used : in string; clk3_used : in string;
                                        clk4_used : in string; clk5_used : in string;
                                        clk6_used : in string; clk7_used : in string;
                                        clk8_used : in string; clk9_used : in string;
                                        m : out integer;
                                        n : out integer ) is
        constant MAX_M : integer := 511;
        constant MAX_N : integer := 511;
        constant MAX_PFD : integer := 720;
        constant MIN_PFD : integer := 5;
        constant MAX_VCO : integer := 1600; -- max vco frequency. (in mHz)
        constant MIN_VCO : integer := 300;  -- min vco frequency. (in mHz)
        constant MAX_OFFSET : real := 0.004;

        variable vco_period : integer;
        variable pfd_freq : integer;
        variable vco_freq : integer;
        variable vco_ps_step_value : integer;

        variable i_m : integer;
        variable i_n : integer;

        variable i_pre_m : integer;
        variable i_pre_n : integer;

        variable closest_vco_step_value : integer;

        variable i_max_iter : integer;
        variable loop_iter : integer;
        
        variable clk0_div_factor_real : real;
        variable clk1_div_factor_real : real;
        variable clk2_div_factor_real : real;
        variable clk3_div_factor_real : real;
        variable clk4_div_factor_real : real;
        variable clk5_div_factor_real : real;
        variable clk6_div_factor_real : real;
        variable clk7_div_factor_real : real;
        variable clk8_div_factor_real : real;
        variable clk9_div_factor_real : real;
        variable clk0_div_factor_int : integer;
        variable clk1_div_factor_int : integer;
        variable clk2_div_factor_int : integer;
        variable clk3_div_factor_int : integer;
        variable clk4_div_factor_int : integer;
        variable clk5_div_factor_int : integer;
        variable clk6_div_factor_int : integer;
        variable clk7_div_factor_int : integer;
        variable clk8_div_factor_int : integer;
        variable clk9_div_factor_int : integer;
begin
    vco_period := vco_phase_shift_step * 8;
    i_pre_m := 0;
    i_pre_n := 0;
    closest_vco_step_value := 0;

    LOOP_1 :   for i_n_out in 1 to MAX_N loop
        for i_m_out in 1 to MAX_M loop
        
            clk0_div_factor_real := real(clk0_div * i_m_out) / real(clk0_mult * i_n_out);
            clk1_div_factor_real := real(clk1_div * i_m_out) / real(clk1_mult * i_n_out);
            clk2_div_factor_real := real(clk2_div * i_m_out) / real(clk2_mult * i_n_out);
            clk3_div_factor_real := real(clk3_div * i_m_out) / real(clk3_mult * i_n_out);
            clk4_div_factor_real := real(clk4_div * i_m_out) / real(clk4_mult * i_n_out);
            clk5_div_factor_real := real(clk5_div * i_m_out) / real(clk5_mult * i_n_out);
            clk6_div_factor_real := real(clk6_div * i_m_out) / real(clk6_mult * i_n_out);
            clk7_div_factor_real := real(clk7_div * i_m_out) / real(clk7_mult * i_n_out);
            clk8_div_factor_real := real(clk8_div * i_m_out) / real(clk8_mult * i_n_out);
            clk9_div_factor_real := real(clk9_div * i_m_out) / real(clk9_mult * i_n_out);

            clk0_div_factor_int := integer(clk0_div_factor_real);
            clk1_div_factor_int := integer(clk1_div_factor_real);
            clk2_div_factor_int := integer(clk2_div_factor_real);
            clk3_div_factor_int := integer(clk3_div_factor_real);
            clk4_div_factor_int := integer(clk4_div_factor_real);
            clk5_div_factor_int := integer(clk5_div_factor_real);
            clk6_div_factor_int := integer(clk6_div_factor_real);
            clk7_div_factor_int := integer(clk7_div_factor_real);
            clk8_div_factor_int := integer(clk8_div_factor_real);
            clk9_div_factor_int := integer(clk9_div_factor_real);
                        
            if (((abs(clk0_div_factor_real - real(clk0_div_factor_int)) < MAX_OFFSET) or (clk0_used = "unused")) and
                ((abs(clk1_div_factor_real - real(clk1_div_factor_int)) < MAX_OFFSET) or (clk1_used = "unused")) and
                ((abs(clk2_div_factor_real - real(clk2_div_factor_int)) < MAX_OFFSET) or (clk2_used = "unused")) and
                ((abs(clk3_div_factor_real - real(clk3_div_factor_int)) < MAX_OFFSET) or (clk3_used = "unused")) and
                ((abs(clk4_div_factor_real - real(clk4_div_factor_int)) < MAX_OFFSET) or (clk4_used = "unused")) and
                ((abs(clk5_div_factor_real - real(clk5_div_factor_int)) < MAX_OFFSET) or (clk5_used = "unused")) and
                ((abs(clk6_div_factor_real - real(clk6_div_factor_int)) < MAX_OFFSET) or (clk6_used = "unused")) and
                ((abs(clk7_div_factor_real - real(clk7_div_factor_int)) < MAX_OFFSET) or (clk7_used = "unused")) and
                ((abs(clk8_div_factor_real - real(clk8_div_factor_int)) < MAX_OFFSET) or (clk8_used = "unused")) and
                ((abs(clk9_div_factor_real - real(clk9_div_factor_int)) < MAX_OFFSET) or (clk9_used = "unused")) )
            then
                if ((i_m_out /= 0) and (i_n_out /= 0))
                then
                    pfd_freq := 1000000 / (inclock_period * i_n_out);
                    vco_freq := (1000000 * i_m_out) / (inclock_period * i_n_out);
                    vco_ps_step_value := (inclock_period * i_n_out) / (8 * i_m_out);
    
                    if ( (i_m_out < max_m) and (i_n_out < max_n) and (pfd_freq >= min_pfd) and (pfd_freq <= max_pfd) and
                        (vco_freq >= min_vco) and (vco_freq <= max_vco) )
                    then
                        if (abs(vco_ps_step_value - vco_phase_shift_step) <= 2)
                        then
                            i_pre_m := i_m_out;
                            i_pre_n := i_n_out;
                            exit LOOP_1;
                        else
                            if ((closest_vco_step_value = 0) or (abs(vco_ps_step_value - vco_phase_shift_step) < abs(closest_vco_step_value - vco_phase_shift_step)))
                            then
                                i_pre_m := i_m_out;
                                i_pre_n := i_n_out;
                                closest_vco_step_value := vco_ps_step_value;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end loop;
    end loop;
    
    if ((i_pre_m /= 0) and (i_pre_n /= 0))
    then
        find_simple_integer_fraction(i_pre_m, i_pre_n,
                    MAX_N, m, n);
    else
        n := 1;
        m := lcm  (clk0_mult, clk1_mult, clk2_mult, clk3_mult,
                clk4_mult, clk5_mult, clk6_mult,
                clk7_mult, clk8_mult, clk9_mult, inclock_period);
    end if;
end find_m_and_n_4_manual_phase;

-- find the greatest common denominator of X and Y
function gcd (X: integer; Y: integer) return integer is
variable L, S, R, G : integer := 1;
begin
    if (X < Y) then -- find which is smaller.
        S := X;
        L := Y;
    else
        S := Y;
        L := X;
    end if;

    R := S;
    while ( R > 1) loop
        S := L;
        L := R;
        R := S rem L;   -- divide bigger number by smaller.
                        -- remainder becomes smaller number.
    end loop;
    if (R = 0) then  -- if evenly divisible then L is gcd else it is 1.
        G := L;
    else
        G := R;
    end if;

    return G;
end gcd;

-- count the number of digits in the given integer
function count_digit (X: integer)
        return integer is
variable count, result: integer := 0;
begin
    result := X;
    while (result /= 0) loop
        result := (result / 10);
        count := count + 1;
    end loop;
    
    return count;
end count_digit;
    
-- reduce the given huge number to Y significant digits
function scale_num (X: integer; Y: integer)
        return integer is
variable count : integer := 0; 
variable lc, fac_ten, result: integer := 1;
begin
    count := count_digit(X);

    for lc in 1 to (count-Y) loop
        fac_ten := fac_ten * 10;
    end loop;
    
    result := (X / fac_ten);
    
    return result;
end scale_num;

-- find the least common multiple of A1 to A10
function lcm (A1: integer; A2: integer; A3: integer; A4: integer;
            A5: integer; A6: integer; A7: integer;
            A8: integer; A9: integer; A10: integer; P: integer)
        return integer is
variable M1, M2, M3, M4, M5 , M6, M7, M8, M9, R: integer := 1;
begin
    M1 := (A1 * A2)/gcd(A1, A2);
    M2 := (M1 * A3)/gcd(M1, A3);
    M3 := (M2 * A4)/gcd(M2, A4);
    M4 := (M3 * A5)/gcd(M3, A5);
    M5 := (M4 * A6)/gcd(M4, A6);
    M6 := (M5 * A7)/gcd(M5, A7);
    M7 := (M6 * A8)/gcd(M6, A8);
    M8 := (M7 * A9)/gcd(M7, A9);
    M9 := (M8 * A10)/gcd(M8, A10);
    if (M9 < 3) then
        R := 10;
    elsif (M9 = 3) then
        R := 9;
    elsif ((M9 <= 10) and (M9 > 3)) then
        R := 4 * M9;
    elsif (M9 > 1000) then
        R := scale_num(M9,3);
    else
        R := M9 ;
    end if;

    return R;
end lcm;

-- find the factor of division of the output clock frequency compared to the VCO
function output_counter_value (clk_divide: integer; clk_mult: integer ;
                                M: integer; N: integer ) return integer is
variable r_real : real := 1.0;
variable r: integer := 1;
begin
    r_real := real(clk_divide * M)/ real(clk_mult * N);
    r := integer(r_real);

    return R;
end output_counter_value;

-- find the mode of each PLL counter - bypass, even or odd
function counter_mode (duty_cycle: integer; output_counter_value: integer)
        return string is
variable R: string (1 to 6) := "      ";
variable counter_value: integer := 1;
begin
    counter_value := (2*duty_cycle*output_counter_value)/100;
    if output_counter_value = 1 then
        R := "bypass";
    elsif (counter_value REM 2) = 0 then
        R := "  even";
    else
        R := "   odd";
    end if;

    return R;
end counter_mode;

-- find the number of VCO clock cycles to hold the output clock high
function counter_high (output_counter_value: integer := 1; duty_cycle: integer)
        return integer is
variable R: integer := 1;
variable half_cycle_high : integer := 1;
begin
    half_cycle_high := (duty_cycle * output_counter_value *2)/100 ;
    if (half_cycle_high REM 2 = 0) then
        R := half_cycle_high/2 ;
    else
        R := (half_cycle_high/2) + 1;
    end if;

    return R;
end;

-- find the number of VCO clock cycles to hold the output clock low
function counter_low (output_counter_value: integer; duty_cycle: integer)
        return integer is
variable R, R1: integer := 1;
variable half_cycle_high : integer := 1;
begin
    half_cycle_high := (duty_cycle * output_counter_value*2)/100 ;
    if (half_cycle_high REM 2 = 0) then
        R1 := half_cycle_high/2 ;
    else
        R1 := (half_cycle_high/2) + 1;
    end if;

    R := output_counter_value - R1;

    if (R = 0) then
        R := 1;
    end if;

    return R;
end;

-- find the smallest time delay amongst t1 to t10
function mintimedelay (t1: integer; t2: integer; t3: integer; t4: integer;
                        t5: integer; t6: integer; t7: integer; t8: integer;
                        t9: integer; t10: integer) return integer is
variable m1,m2,m3,m4,m5,m6,m7,m8,m9 : integer := 0;
begin
    if (t1 < t2) then m1 := t1; else m1 := t2; end if;
    if (m1 < t3) then m2 := m1; else m2 := t3; end if;
    if (m2 < t4) then m3 := m2; else m3 := t4; end if;
    if (m3 < t5) then m4 := m3; else m4 := t5; end if;
    if (m4 < t6) then m5 := m4; else m5 := t6; end if;
    if (m5 < t7) then m6 := m5; else m6 := t7; end if;
    if (m6 < t8) then m7 := m6; else m7 := t8; end if;
    if (m7 < t9) then m8 := m7; else m8 := t9; end if;
    if (m8 < t10) then m9 := m8; else m9 := t10; end if;
    if (m9 > 0) then return m9; else return 0; end if;
end;

-- find the numerically largest negative number, and return its absolute value
function maxnegabs (t1: integer; t2: integer; t3: integer; t4: integer;
                    t5: integer; t6: integer; t7: integer; t8: integer;
                    t9: integer; t10: integer) return integer is
variable m1,m2,m3,m4,m5,m6,m7,m8,m9 : integer := 0;
begin
    if (t1 < t2) then m1 := t1; else m1 := t2; end if;
    if (m1 < t3) then m2 := m1; else m2 := t3; end if;
    if (m2 < t4) then m3 := m2; else m3 := t4; end if;
    if (m3 < t5) then m4 := m3; else m4 := t5; end if;
    if (m4 < t6) then m5 := m4; else m5 := t6; end if;
    if (m5 < t7) then m6 := m5; else m6 := t7; end if;
    if (m6 < t8) then m7 := m6; else m7 := t8; end if;
    if (m7 < t9) then m8 := m7; else m8 := t9; end if;
    if (m8 < t10) then m9 := m8; else m9 := t10; end if;
    if (m9 < 0) then return (0 - m9); else return 0; end if;
end;

-- adjust the phase (tap_phase) with the largest negative number (ph_base)
function ph_adjust (tap_phase: integer; ph_base : integer) return integer is
begin
    return (tap_phase + ph_base);
end;

-- find the time delay for each PLL counter
function counter_time_delay (clk_time_delay: integer;
                            m_time_delay: integer; n_time_delay: integer)
        return integer is
variable R: integer := 0;
begin
    R := clk_time_delay + m_time_delay - n_time_delay;

    return R;
end;

-- calculate the given phase shift (in ps) in terms of degrees
function get_phase_degree (phase_shift: integer; clk_period: integer)
        return integer is
variable result: integer := 0;
begin
    result := ( phase_shift * 360 ) / clk_period;
    -- to round up the calculation result
    if (result > 0) then
        result := result + 1;
    elsif (result < 0) then
        result := result - 1;
    else
        result := 0;
    end if;

    return result;
end;

-- find the number of VCO clock cycles to wait initially before the first rising
-- edge of the output clock
function counter_initial (tap_phase: integer; m: integer; n: integer)
        return integer is
variable R: integer;
variable R1: real;
begin
    R1 := (real(abs(tap_phase)) * real(m))/(360.0 * real(n)) + 0.6;
    -- Note NCSim VHDL had problem in rounding up for 0.5 - 0.99. 
    -- This checking will ensure that the rounding up is done.
    if (R1 >= 0.5) and (R1 <= 1.0) then
        R1 := 1.0;
    end if;

    R := integer(R1);

    return R;
end;

-- find which VCO phase tap (0 to 7) to align the rising edge of the output clock to
function counter_ph (tap_phase: integer; m: integer; n: integer) return integer is
variable R: integer := 0;
begin
    -- 0.5 is added for proper rounding of the tap_phase.
    R := integer(real(integer(real(tap_phase * m / n)+ 0.5) REM 360)/45.0) rem 8;

    return R;
end;

-- convert given string to length 6 by padding with spaces
function translate_string (mode : string) return string is
variable new_mode : string (1 to 6) := "      ";
begin
    if (mode = "bypass") then
        new_mode := "bypass";
    elsif (mode = "even") then
        new_mode := "  even";
    elsif (mode = "odd") then
        new_mode := "   odd";
    end if;

    return new_mode;
end;

function str2int (s : string) return integer is
variable len : integer := s'length;
variable newdigit : integer := 0;
variable sign : integer := 1;
variable digit : integer := 0;
begin
    for i in 1 to len loop
        case s(i) is
            when '-' =>
                if i = 1 then
                    sign := -1;
                else
                    ASSERT FALSE
                    REPORT "Illegal Character "&  s(i) & "i n string parameter! "
                    SEVERITY ERROR;
                end if;
            when '0' =>
                digit := 0;
            when '1' =>
                digit := 1;
            when '2' =>
                digit := 2;
            when '3' =>
                digit := 3;
            when '4' =>
                digit := 4;
            when '5' =>
                digit := 5;
            when '6' =>
                digit := 6;
            when '7' =>
                digit := 7;
            when '8' =>
                digit := 8;
            when '9' =>
                digit := 9;
            when others =>
                ASSERT FALSE
                REPORT "Illegal Character "&  s(i) & "in string parameter! "
                SEVERITY ERROR;
        end case;
        newdigit := newdigit * 10 + digit;
    end loop;

    return (sign*newdigit);
end;

function dqs_str2int (s : string) return integer is
variable len : integer := s'length;
variable newdigit : integer := 0;
variable sign : integer := 1;
variable digit : integer := 0;
variable err : boolean := false;
begin
    for i in 1 to len loop
        case s(i) is
            when '-' =>
                if i = 1 then
                    sign := -1;
                else
                    ASSERT FALSE
                    REPORT "Illegal Character "&  s(i) & " in string parameter! "
                    SEVERITY ERROR;
                    err := true;
                end if;
            when '0' =>
                digit := 0;
            when '1' =>
                digit := 1;
            when '2' =>
                digit := 2;
            when '3' =>
                digit := 3;
            when '4' =>
                digit := 4;
            when '5' =>
                digit := 5;
            when '6' =>
                digit := 6;
            when '7' =>
                digit := 7;
            when '8' =>
                digit := 8;
            when '9' =>
                digit := 9;
            when others =>
                -- set error flag
                err := true;
        end case;
        if (err) then
            err := false;
        else
            newdigit := newdigit * 10 + digit;
        end if;
    end loop;

    return (sign*newdigit);
end;

end stratixii_pllpack;

--
--
--  DFFE Model
--
--

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

entity stratixii_dffe is
    generic(
        TimingChecksOn: Boolean := True;
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
        tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
        tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
        tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
        tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
        tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
        tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
        thold_D_CLK_noedge_posedge     :   VitalDelayType := DefSetupHoldCnst;
        thold_D_CLK_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
        thold_ENA_CLK_noedge_posedge   :   VitalDelayType := DefSetupHoldCnst;
        tipd_D                         :  VitalDelayType01 := DefPropDelay01;
        tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
        tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
        tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
        tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

    port(
        Q                              :  out   STD_LOGIC := '0';
        D                              :  in    STD_LOGIC;
        CLRN                           :  in    STD_LOGIC;
        PRN                            :  in    STD_LOGIC;
        CLK                            :  in    STD_LOGIC;
        ENA                            :  in    STD_LOGIC);
    attribute VITAL_LEVEL0 of stratixii_dffe : entity is TRUE;
end stratixii_dffe;

-- architecture body --

architecture behave of stratixii_dffe is
    attribute VITAL_LEVEL0 of behave : architecture is TRUE;
    
    signal D_ipd  : STD_ULOGIC := 'U';
    signal CLRN_ipd       : STD_ULOGIC := 'U';
    signal PRN_ipd        : STD_ULOGIC := 'U';
    signal CLK_ipd        : STD_ULOGIC := 'U';
    signal ENA_ipd        : STD_ULOGIC := 'U';

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (D_ipd, D, tipd_D);
        VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
        VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
        VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
        VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
    end block;
    --------------------
    --  BEHAVIOR SECTION
    --------------------
    VITALBehavior : process (D_ipd, CLRN_ipd, PRN_ipd, CLK_ipd, ENA_ipd)
    
    -- timing check results
    VARIABLE Tviol_D_CLK : STD_ULOGIC := '0';
    VARIABLE Tviol_ENA_CLK       : STD_ULOGIC := '0';
    VARIABLE TimingData_D_CLK : VitalTimingDataType := VitalTimingDataInit;
    VARIABLE TimingData_ENA_CLK : VitalTimingDataType := VitalTimingDataInit;
    
    -- functionality results
    VARIABLE Violation : STD_ULOGIC := '0';
    VARIABLE PrevData_Q : STD_LOGIC_VECTOR(0 to 7);
    VARIABLE D_delayed : STD_ULOGIC := 'U';
    VARIABLE CLK_delayed : STD_ULOGIC := 'U';
    VARIABLE ENA_delayed : STD_ULOGIC := 'U';
    VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => '0');

    -- output glitch detection variables
    VARIABLE Q_VitalGlitchData   : VitalGlitchDataType;


    CONSTANT dffe_Q_tab : VitalStateTableType := (
        ( L,  L,  x,  x,  x,  x,  x,  x,  x,  L ),
        ( L,  H,  L,  H,  H,  x,  x,  H,  x,  H ),
        ( L,  H,  L,  H,  x,  L,  x,  H,  x,  H ),
        ( L,  H,  L,  x,  H,  H,  x,  H,  x,  H ),
        ( L,  H,  H,  x,  x,  x,  H,  x,  x,  S ),
        ( L,  H,  x,  x,  x,  x,  L,  x,  x,  H ),
        ( L,  H,  x,  x,  x,  x,  H,  L,  x,  S ),
        ( L,  x,  L,  L,  L,  x,  H,  H,  x,  L ),
        ( L,  x,  L,  L,  x,  L,  H,  H,  x,  L ),
        ( L,  x,  L,  x,  L,  H,  H,  H,  x,  L ),
        ( L,  x,  x,  x,  x,  x,  x,  x,  x,  S ));
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
            VitalSetupHoldCheck (
                Violation       => Tviol_D_CLK,
                TimingData      => TimingData_D_CLK,
                TestSignal      => D_ipd,
                TestSignalName  => "D",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_D_CLK_noedge_posedge,
                SetupLow        => tsetup_D_CLK_noedge_posedge,
                HoldHigh        => thold_D_CLK_noedge_posedge,
                HoldLow         => thold_D_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) OR ( (NOT ENA_ipd) )) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalSetupHoldCheck (
                Violation       => Tviol_ENA_CLK,
                TimingData      => TimingData_ENA_CLK,
                TestSignal      => ENA_ipd,
                TestSignalName  => "ENA",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ENA_CLK_noedge_posedge,
                SetupLow        => tsetup_ENA_CLK_noedge_posedge,
                HoldHigh        => thold_ENA_CLK_noedge_posedge,
                HoldLow         => thold_ENA_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        end if;

        -------------------------
        --  Functionality Section
        -------------------------
        Violation := Tviol_D_CLK or Tviol_ENA_CLK;
        VitalStateTable(
        StateTable => dffe_Q_tab,
        DataIn => (
                Violation, CLRN_ipd, CLK_delayed, Results(1), D_delayed, ENA_delayed, PRN_ipd, CLK_ipd),
        Result => Results,
        NumStates => 1,
        PreviousDataIn => PrevData_Q);
        D_delayed := D_ipd;
        CLK_delayed := CLK_ipd;
        ENA_delayed := ENA_ipd;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
        OutSignal => Q,
        OutSignalName => "Q",
        OutTemp => Results(1),
        Paths => (  0 => (PRN_ipd'last_event, tpd_PRN_Q_negedge, TRUE),
                    1 => (CLRN_ipd'last_event, tpd_CLRN_Q_negedge, TRUE),
                    2 => (CLK_ipd'last_event, tpd_CLK_Q_posedge, TRUE)),
        GlitchData => Q_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn        => MsgOn );

    end process;

end behave;

--
--
--  stratixii_mux21 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixii_atom_pack.all;

entity stratixii_mux21 is
    generic(
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        InstancePath: STRING := "*";
        tpd_A_MO                      :   VitalDelayType01 := DefPropDelay01;
        tpd_B_MO                      :   VitalDelayType01 := DefPropDelay01;
        tpd_S_MO                      :   VitalDelayType01 := DefPropDelay01;
        tipd_A                       :    VitalDelayType01 := DefPropDelay01;
        tipd_B                       :    VitalDelayType01 := DefPropDelay01;
        tipd_S                       :    VitalDelayType01 := DefPropDelay01);
    port (
        A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic);
    attribute VITAL_LEVEL0 of stratixii_mux21 : entity is TRUE;
end stratixii_mux21;

architecture AltVITAL of stratixii_mux21 is
    attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

    signal A_ipd, B_ipd, S_ipd  : std_logic;

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (A_ipd, A, tipd_A);
        VitalWireDelay (B_ipd, B, tipd_B);
        VitalWireDelay (S_ipd, S, tipd_S);
    end block;

    --------------------
    --  BEHAVIOR SECTION
    --------------------
    VITALBehavior : process (A_ipd, B_ipd, S_ipd)

    -- output glitch detection variables
    VARIABLE MO_GlitchData       : VitalGlitchDataType;

    variable tmp_MO : std_logic;
    begin
        -------------------------
        --  Functionality Section
        -------------------------
        if (S_ipd = '1') then
            tmp_MO := B_ipd;
        else
            tmp_MO := A_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
        OutSignal => MO,
        OutSignalName => "MO",
        OutTemp => tmp_MO,
        Paths => (  0 => (A_ipd'last_event, tpd_A_MO, TRUE),
                    1 => (B_ipd'last_event, tpd_B_MO, TRUE),
                    2 => (S_ipd'last_event, tpd_S_MO, TRUE)),
        GlitchData => MO_GlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn        => MsgOn );

    end process;
end AltVITAL;

--
--
--  stratixii_mux41 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixii_atom_pack.all;

entity stratixii_mux41 is
    generic(
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_IN0_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN1_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN2_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN3_MO : VitalDelayType01 := DefPropDelay01;
            tpd_S_MO : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
            tipd_IN0 : VitalDelayType01 := DefPropDelay01;
            tipd_IN1 : VitalDelayType01 := DefPropDelay01;
            tipd_IN2 : VitalDelayType01 := DefPropDelay01;
            tipd_IN3 : VitalDelayType01 := DefPropDelay01;
            tipd_S : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01)
        );
    port (
            IN0 : in std_logic := '0';
            IN1 : in std_logic := '0';
            IN2 : in std_logic := '0';
            IN3 : in std_logic := '0';
            S : in std_logic_vector(1 downto 0) := (OTHERS => '0');
            MO : out std_logic
        );
    attribute VITAL_LEVEL0 of stratixii_mux41 : entity is TRUE;
end stratixii_mux41;

architecture AltVITAL of stratixii_mux41 is
    attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

    signal IN0_ipd, IN1_ipd, IN2_ipd, IN3_ipd  : std_logic;
    signal S_ipd : std_logic_vector(1 downto 0);

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (IN0_ipd, IN0, tipd_IN0);
        VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
        VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
        VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
        VitalWireDelay (S_ipd(0), S(0), tipd_S(0));
        VitalWireDelay (S_ipd(1), S(1), tipd_S(1));
    end block;

    --------------------
    --  BEHAVIOR SECTION
    --------------------
    VITALBehavior : process (IN0_ipd, IN1_ipd, IN2_ipd, IN3_ipd, S_ipd(0), S_ipd(1))

    -- output glitch detection variables
    VARIABLE MO_GlitchData       : VitalGlitchDataType;

    variable tmp_MO : std_logic;
    begin
        -------------------------
        --  Functionality Section
        -------------------------
        if ((S_ipd(1) = '1') AND (S_ipd(0) = '1')) then
            tmp_MO := IN3_ipd;
        elsif ((S_ipd(1) = '1') AND (S_ipd(0) = '0')) then
            tmp_MO := IN2_ipd;
        elsif ((S_ipd(1) = '0') AND (S_ipd(0) = '1')) then
            tmp_MO := IN1_ipd;
        else
            tmp_MO := IN0_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
                        OutSignal => MO,
                        OutSignalName => "MO",
                        OutTemp => tmp_MO,
                        Paths => (  0 => (IN0_ipd'last_event, tpd_IN0_MO, TRUE),
                                    1 => (IN1_ipd'last_event, tpd_IN1_MO, TRUE),
                                    2 => (IN2_ipd'last_event, tpd_IN2_MO, TRUE),
                                    3 => (IN3_ipd'last_event, tpd_IN3_MO, TRUE),
                                    4 => (S_ipd(0)'last_event, tpd_S_MO(0), TRUE),
                                    5 => (S_ipd(1)'last_event, tpd_S_MO(1), TRUE)),
                        GlitchData => MO_GlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn => MsgOn );

    end process;
end AltVITAL;

--
--
--  stratixii_and1 Model
--
--
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixii_atom_pack.all;

-- entity declaration --
entity stratixii_and1 is
    generic(
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        InstancePath: STRING := "*";
        tpd_IN1_Y                      :  VitalDelayType01 := DefPropDelay01;
        tipd_IN1                       :  VitalDelayType01 := DefPropDelay01);

    port(
        Y                              :  out   STD_LOGIC;
        IN1                            :  in    STD_LOGIC);
    attribute VITAL_LEVEL0 of stratixii_and1 : entity is TRUE;
end stratixii_and1;

-- architecture body --

architecture AltVITAL of stratixii_and1 is
    attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

    SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
    VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
    end block;
    --------------------
    --  BEHAVIOR SECTION
    --------------------
    VITALBehavior : process (IN1_ipd)


    -- functionality results
    VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
    ALIAS Y_zd : STD_ULOGIC is Results(1);

    -- output glitch detection variables
    VARIABLE Y_GlitchData    : VitalGlitchDataType;

    begin

        -------------------------
        --  Functionality Section
        -------------------------
        Y_zd := TO_X01(IN1_ipd);

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => Y,
            OutSignalName => "Y",
            OutTemp => Y_zd,
            Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
            GlitchData => Y_GlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn        => MsgOn );

    end process;
end AltVITAL;
----------------------------------------------------------------------------
-- Module Name     : stratixii_ram_register
-- Description     : Register module for RAM inputs/outputs
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_ram_register IS

GENERIC (
    width   : INTEGER := 1;
    preset  : STD_LOGIC := '0';
    tipd_d  : VitalDelayArrayType01(143 DOWNTO 0) := (OTHERS => DefPropDelay01); 
    tipd_clk        : VitalDelayType01 := DefPropDelay01;
    tipd_ena        : VitalDelayType01 := DefPropDelay01;
    tipd_stall      : VitalDelayType01 := DefPropDelay01;
    tipd_aclr       : VitalDelayType01 := DefPropDelay01;
    tpw_ena_posedge : VitalDelayType   := DefPulseWdthCnst;
    tpd_clk_q_posedge        : VitalDelayType01 := DefPropDelay01;
    tpd_aclr_q_posedge       : VitalDelayType01 := DefPropDelay01;
    tsetup_d_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
    thold_d_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
    tsetup_ena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    thold_ena_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
    tsetup_stall_clk_noedge_posedge  : VitalDelayType   := DefSetupHoldCnst;
    thold_stall_clk_noedge_posedge   : VitalDelayType   := DefSetupHoldCnst;
    tsetup_aclr_clk_noedge_posedge : VitalDelayType   := DefSetupHoldCnst;
    thold_aclr_clk_noedge_posedge  : VitalDelayType   := DefSetupHoldCnst
    );

PORT (
    d       : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    clk     : IN STD_LOGIC;
    ena     : IN STD_LOGIC;
    stall : IN STD_LOGIC;
    aclr    : IN STD_LOGIC;
    devclrn : IN STD_LOGIC;
    devpor  : IN STD_LOGIC;
    q       : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    aclrout : OUT STD_LOGIC
    );

END stratixii_ram_register;

ARCHITECTURE reg_arch OF stratixii_ram_register IS

SIGNAL d_ipd : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
SIGNAL clk_ipd  : STD_LOGIC;
SIGNAL ena_ipd  : STD_LOGIC;
SIGNAL aclr_ipd : STD_LOGIC;
SIGNAL stall_ipd : STD_LOGIC;

BEGIN

WireDelay : BLOCK
BEGIN
    loopbits : FOR i in d'RANGE GENERATE
        VitalWireDelay (d_ipd(i), d(i), tipd_d(i));
    END GENERATE;
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
    VitalWireDelay (stall_ipd, stall, tipd_stall);
END BLOCK;

   PROCESS (d_ipd,ena_ipd,stall_ipd,clk_ipd,aclr_ipd,devclrn,devpor)
VARIABLE Tviol_clk_ena        : STD_ULOGIC := '0';
VARIABLE Tviol_clk_aclr       : STD_ULOGIC := '0';
VARIABLE Tviol_data_clk       : STD_ULOGIC := '0';
VARIABLE TimingData_clk_ena   : VitalTimingDataType := VitalTimingDataInit;
VARIABLE TimingData_clk_stall   : VitalTimingDataType := VitalTimingDataInit;
VARIABLE TimingData_clk_aclr  : VitalTimingDataType := VitalTimingDataInit;
VARIABLE TimingData_data_clk  : VitalTimingDataType := VitalTimingDataInit;
VARIABLE Tviol_ena            : STD_ULOGIC := '0';
VARIABLE PeriodData_ena       : VitalPeriodDataType := VitalPeriodDataInit;
VARIABLE q_VitalGlitchDataArray : VitalGlitchDataArrayType(143 downto 0);
VARIABLE CQDelay  : TIME := 0 ns;
VARIABLE q_reg    : STD_LOGIC_VECTOR(width - 1 DOWNTO 0) := (OTHERS => preset);
BEGIN

    IF (aclr_ipd = '1' OR devclrn = '0' OR devpor = '0') THEN
        q_reg := (OTHERS => preset);
       ELSIF (clk_ipd = '1' AND clk_ipd'EVENT AND ena_ipd = '1' AND stall_ipd = '0') THEN
        q_reg := d_ipd;
    END IF;
    
    -- Timing checks
    VitalSetupHoldCheck (
        Violation       => Tviol_clk_ena,
        TimingData      => TimingData_clk_ena,
        TestSignal      => ena_ipd,
        TestSignalName  => "ena",
        RefSignal       => clk_ipd,
        RefSignalName   => "clk",
        SetupHigh       => tsetup_ena_clk_noedge_posedge,
        SetupLow        => tsetup_ena_clk_noedge_posedge,
        HoldHigh        => thold_ena_clk_noedge_posedge,
        HoldLow         => thold_ena_clk_noedge_posedge,
        CheckEnabled    => ((aclr_ipd) OR (NOT ena_ipd)) /= '1',                              
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );
        
  VitalSetupHoldCheck (
      Violation       => Tviol_clk_ena,
      TimingData      => TimingData_clk_stall,
      TestSignal      => stall_ipd,
      TestSignalName  => "stall",
      RefSignal       => clk_ipd,
      RefSignalName   => "clk",
      SetupHigh       => tsetup_stall_clk_noedge_posedge,
      SetupLow        => tsetup_stall_clk_noedge_posedge,
      HoldHigh        => thold_stall_clk_noedge_posedge,
      HoldLow         => thold_stall_clk_noedge_posedge,
      CheckEnabled    => ((aclr_ipd) OR (NOT ena_ipd)) /= '1',                              
      RefTransition   => '/',
      HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
      XOn           => DefXOnChecks,
      MsgOn         => DefMsgOnChecks );
        
    VitalSetupHoldCheck (
        Violation       => Tviol_clk_aclr,
        TimingData      => TimingData_clk_aclr,
        TestSignal      => aclr_ipd,
        TestSignalName  => "aclr",
        RefSignal       => clk_ipd,
        RefSignalName   => "clk",
        SetupHigh       => tsetup_aclr_clk_noedge_posedge,
        SetupLow        => tsetup_aclr_clk_noedge_posedge,
        HoldHigh        => thold_aclr_clk_noedge_posedge,
        HoldLow         => thold_aclr_clk_noedge_posedge,
        CheckEnabled    => ((aclr_ipd) OR (NOT ena_ipd)) /= '1',
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );
        
    VitalSetupHoldCheck (
        Violation       => Tviol_data_clk,
        TimingData      => TimingData_data_clk,
        TestSignal      => d_ipd,
        TestSignalName  => "data",
        RefSignal       => clk_ipd,
        RefSignalName   => "clk",
        SetupHigh       => tsetup_d_clk_noedge_posedge,
        SetupLow        => tsetup_d_clk_noedge_posedge,
        HoldHigh        => thold_d_clk_noedge_posedge,
        HoldLow         => thold_d_clk_noedge_posedge,
        CheckEnabled    => ((aclr_ipd) OR (NOT ena_ipd)) /= '1',
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );
       
    VitalPeriodPulseCheck (
        Violation       => Tviol_ena,
        PeriodData      => PeriodData_ena,
        TestSignal      => ena_ipd,
        TestSignalName  => "ena",
        PulseWidthHigh  => tpw_ena_posedge,
        HeaderMsg       => "/RAM Register VitalPeriodPulseCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );
        
    -- Path Delay Selection
    CQDelay := SelectDelay (
                   Paths => (
                       (0 => (clk_ipd'LAST_EVENT,tpd_clk_q_posedge,TRUE),
                        1 => (aclr_ipd'LAST_EVENT,tpd_aclr_q_posedge,TRUE))
                   )
               );
    q <= TRANSPORT q_reg AFTER CQDelay; 
        
END PROCESS;

aclrout <= aclr_ipd;

END reg_arch;

----------------------------------------------------------------------------
-- Module Name     : stratixii_ram_pulse_generator
-- Description     : Generate pulse to initiate memory read/write operations
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_ram_pulse_generator IS
GENERIC (
    tipd_clk : VitalDelayType01 := (0.5 ns,0.5 ns);
    tipd_ena : VitalDelayType01 := DefPropDelay01;
    tpd_clk_pulse_posedge : VitalDelayType01 := DefPropDelay01
    );
PORT ( 
    clk,ena : IN STD_LOGIC;
    pulse,cycle : OUT STD_LOGIC
    );
ATTRIBUTE VITAL_Level0 OF stratixii_ram_pulse_generator:ENTITY IS TRUE;
END stratixii_ram_pulse_generator;

ARCHITECTURE pgen_arch OF stratixii_ram_pulse_generator IS
SIGNAL clk_ipd,ena_ipd : STD_LOGIC;
SIGNAL state : STD_LOGIC;
ATTRIBUTE VITAL_Level0 OF pgen_arch:ARCHITECTURE IS TRUE;
BEGIN

WireDelay : BLOCK
BEGIN
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
END BLOCK;

PROCESS (clk_ipd,state)
BEGIN
    IF (state = '1' AND state'EVENT) THEN
        state <= '0';
    ELSIF (clk_ipd = '1' AND clk_ipd'EVENT AND ena_ipd = '1') THEN
        state <= '1';
    END IF;
END PROCESS;

PathDelay : PROCESS
VARIABLE pulse_VitalGlitchData : VitalGlitchDataType;
BEGIN
    WAIT UNTIL state'EVENT;
    VitalPathDelay01 (
        OutSignal     => pulse,
        OutSignalName => "pulse",
        OutTemp       => state,
        Paths         => (0 => (clk_ipd'LAST_EVENT,tpd_clk_pulse_posedge,TRUE)),
        GlitchData    => pulse_VitalGlitchData,
        Mode          => DefGlitchMode,
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks
    );
END PROCESS;

cycle <= clk_ipd;

END pgen_arch;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE work.stratixii_ram_register;
USE work.stratixii_ram_pulse_generator;

ENTITY stratixii_ram_block IS
    GENERIC (
        -- -------- GLOBAL PARAMETERS ---------
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
        data_interleave_width_in_bits  :  INTEGER := 1;    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        port_a_logical_ram_depth       :  INTEGER := 0;    
        port_a_logical_ram_width       :  INTEGER := 0;    
        port_a_first_address           :  INTEGER := 0;    
        port_a_last_address            :  INTEGER := 0;    
        port_a_first_bit_number        :  INTEGER := 0;    
        port_a_data_in_clear           :  STRING := "none";    
        port_a_address_clear           :  STRING := "none";    
        port_a_write_enable_clear      :  STRING := "none";    
        port_a_data_out_clear          :  STRING := "none";    
        port_a_byte_enable_clear       :  STRING := "none";    
        port_a_data_in_clock           :  STRING := "clock0";    
        port_a_address_clock           :  STRING := "clock0";    
        port_a_write_enable_clock      :  STRING := "clock0";    
        port_a_byte_enable_clock       :  STRING := "clock0";    
        port_a_data_out_clock          :  STRING := "none";    
        port_a_data_width              :  INTEGER := 1;    
        port_a_address_width           :  INTEGER := 1;    
        port_a_byte_enable_mask_width  :  INTEGER := 1;    
        port_b_logical_ram_depth       :  INTEGER := 0;    
        port_b_logical_ram_width       :  INTEGER := 0;    
        port_b_first_address           :  INTEGER := 0;    
        port_b_last_address            :  INTEGER := 0;    
        port_b_first_bit_number        :  INTEGER := 0;    
        port_b_data_in_clear           :  STRING := "none";    
        port_b_address_clear           :  STRING := "none";    
        port_b_read_enable_write_enable_clear: STRING := "none";    
        port_b_byte_enable_clear       :  STRING := "none";    
        port_b_data_out_clear          :  STRING := "none";    
        port_b_data_in_clock           :  STRING := "clock1";    
        port_b_address_clock           :  STRING := "clock1";    
        port_b_read_enable_write_enable_clock: STRING := "clock1";    
        port_b_byte_enable_clock       :  STRING := "clock1";    
        port_b_data_out_clock          :  STRING := "none";    
        port_b_data_width              :  INTEGER := 1;    
        port_b_address_width           :  INTEGER := 1;    
        port_b_byte_enable_mask_width  :  INTEGER := 1;    
        
        power_up_uninitialized         :  STRING := "false";  
        port_b_disable_ce_on_output_registers : STRING := "off";
        port_b_disable_ce_on_input_registers : STRING := "off";
        port_b_byte_size : INTEGER := 0;
        port_a_disable_ce_on_output_registers : STRING := "off";
        port_a_disable_ce_on_input_registers : STRING := "off";
        port_a_byte_size : INTEGER := 0;  
        lpm_type                  : string := "stratixii_ram_block";
        lpm_hint                  : string := "true";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        connectivity_checking     : string := "off"
        );    
    -- -------- PORT DECLARATIONS ---------
    PORT (
        portadatain             : IN STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portaaddr               : IN STD_LOGIC_VECTOR(port_a_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portawe                 : IN STD_LOGIC := '0';   
        portbdatain             : IN STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portbaddr               : IN STD_LOGIC_VECTOR(port_b_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portbrewe               : IN STD_LOGIC := '0';   
        clk0                    : IN STD_LOGIC := '0';   
        clk1                    : IN STD_LOGIC := '0';   
        ena0                    : IN STD_LOGIC := '1';   
        ena1                    : IN STD_LOGIC := '1';   
        clr0                    : IN STD_LOGIC := '0';   
        clr1                    : IN STD_LOGIC := '0';   
        portabyteenamasks       : IN STD_LOGIC_VECTOR(port_a_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        portbbyteenamasks       : IN STD_LOGIC_VECTOR(port_b_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        devclrn                 : IN STD_LOGIC := '1';   
        devpor                  : IN STD_LOGIC := '1';   
         portaaddrstall : IN STD_LOGIC := '0';
         portbaddrstall : IN STD_LOGIC := '0';
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );

END stratixii_ram_block;

ARCHITECTURE block_arch OF stratixii_ram_block IS

COMPONENT stratixii_ram_pulse_generator
    PORT (
          clk                     : IN  STD_LOGIC;
          ena                     : IN  STD_LOGIC;
          pulse                   : OUT STD_LOGIC;
          cycle                   : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT stratixii_ram_register
    GENERIC (
        preset                    :  STD_LOGIC := '0';
        width                     :  integer := 1
    );
    PORT    (
        d                       : IN  STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        clk                     : IN  STD_LOGIC;
        aclr                    : IN  STD_LOGIC;
        devclrn                 : IN  STD_LOGIC;
        devpor                  : IN  STD_LOGIC;
        ena                     : IN  STD_LOGIC;
        stall                     : IN  STD_LOGIC;
        q                       : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        aclrout                 : OUT STD_LOGIC
     );
END COMPONENT;

FUNCTION cond (condition : BOOLEAN;CONSTANT a,b : INTEGER) RETURN INTEGER IS
VARIABLE c: INTEGER;
BEGIN
    IF (condition) THEN c := a; ELSE c := b; END IF;
    RETURN c;
END;

SUBTYPE port_type IS BOOLEAN;

CONSTANT primary   : port_type := TRUE;
CONSTANT secondary : port_type := FALSE;

CONSTANT primary_port_is_a : BOOLEAN := (port_b_data_width <= port_a_data_width);
CONSTANT primary_port_is_b : BOOLEAN := NOT primary_port_is_a;

CONSTANT mode_is_rom : BOOLEAN := (operation_mode = "rom");
CONSTANT mode_is_sp  : BOOLEAN := (operation_mode = "single_port");
CONSTANT mode_is_dp  : BOOLEAN := (operation_mode = "dual_port");
CONSTANT mode_is_bdp : BOOLEAN := (operation_mode = "bidir_dual_port");

CONSTANT wired_mode : BOOLEAN := (port_a_address_width = port_b_address_width) AND (port_a_address_width = 1)
                                  AND (port_a_data_width /= port_b_data_width);
CONSTANT num_cols : INTEGER := cond(mode_is_rom OR mode_is_sp,1,
                                    cond(wired_mode,2,2 ** (ABS(port_b_address_width - port_a_address_width))));
CONSTANT data_width      : INTEGER := cond(primary_port_is_a,port_a_data_width,port_b_data_width);
CONSTANT data_unit_width : INTEGER := cond(mode_is_rom OR mode_is_sp OR primary_port_is_b,port_a_data_width,port_b_data_width);

CONSTANT address_unit_width : INTEGER := cond(mode_is_rom OR mode_is_sp OR primary_port_is_a,port_a_address_width,port_b_address_width);
CONSTANT address_width      : INTEGER := cond(mode_is_rom OR mode_is_sp OR primary_port_is_b,port_a_address_width,port_b_address_width);

CONSTANT byte_size_a : INTEGER := port_a_data_width / port_a_byte_enable_mask_width;
CONSTANT byte_size_b : INTEGER := port_b_data_width / port_b_byte_enable_mask_width;    

CONSTANT out_a_is_reg : BOOLEAN := (port_a_data_out_clock /= "none" AND port_a_data_out_clock /= "UNUSED");
CONSTANT out_b_is_reg : BOOLEAN := (port_b_data_out_clock /= "none" AND port_b_data_out_clock /= "UNUSED");

CONSTANT bytes_a_disabled : STD_LOGIC_VECTOR(port_a_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '0');
CONSTANT bytes_b_disabled : STD_LOGIC_VECTOR(port_b_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '0');

CONSTANT ram_type : BOOLEAN := (ram_block_type = "M-RAM" OR ram_block_type = "m-ram" OR ram_block_type = "MegaRAM" OR 
                               (ram_block_type = "auto"  AND mixed_port_feed_through_mode = "dont_care" AND port_b_read_enable_write_enable_clock = "clock0"));
                               
TYPE bool_to_std_logic_map IS ARRAY(TRUE DOWNTO FALSE) OF STD_LOGIC;
CONSTANT bool_to_std_logic : bool_to_std_logic_map := ('1','0');


                              
-- -------- internal signals ---------
-- clock / clock enable
SIGNAL clk_a_in,clk_b_in : STD_LOGIC;
SIGNAL clk_a_byteena,clk_b_byteena : STD_LOGIC;
SIGNAL clk_a_out,clk_b_out : STD_LOGIC;
SIGNAL clkena_a_out,clkena_b_out : STD_LOGIC;
SIGNAL write_cycle_a,write_cycle_b : STD_LOGIC;



SUBTYPE one_bit_bus_type IS STD_LOGIC_VECTOR(0 DOWNTO 0);

-- asynch clear
TYPE   clear_mode_type IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF BOOLEAN;
TYPE   clear_vec_type  IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF STD_LOGIC;
SIGNAL datain_a_clr,datain_b_clr   :  STD_LOGIC;
SIGNAL dataout_a_clr,dataout_b_clr :  STD_LOGIC;


SIGNAL addr_a_clr,addr_b_clr       :  STD_LOGIC;
SIGNAL byteena_a_clr,byteena_b_clr :  STD_LOGIC;
SIGNAL we_a_clr,rewe_b_clr         :  STD_LOGIC;
SIGNAL datain_a_clr_in,datain_b_clr_in :  STD_LOGIC;
SIGNAL addr_a_clr_in,addr_b_clr_in     :  STD_LOGIC;
SIGNAL byteena_a_clr_in,byteena_b_clr_in  :  STD_LOGIC;
SIGNAL we_a_clr_in,rewe_b_clr_in          :  STD_LOGIC;
SIGNAL mem_invalidate,mem_invalidate_loc,read_latch_invalidate : clear_mode_type;
SIGNAL clear_asserted_during_write :  clear_vec_type;


-- port A registers
SIGNAL we_a_reg                 :  STD_LOGIC;
SIGNAL we_a_reg_in,we_a_reg_out :  one_bit_bus_type;
SIGNAL addr_a_reg               :  STD_LOGIC_VECTOR(port_a_address_width - 1 DOWNTO 0);
SIGNAL datain_a_reg             :  STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);
SIGNAL dataout_a_reg            :  STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);
SIGNAL dataout_a                :  STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);
SIGNAL byteena_a_reg            :  STD_LOGIC_VECTOR(port_a_byte_enable_mask_width- 1 DOWNTO 0);
-- port B registers
SIGNAL rewe_b_reg               :  STD_LOGIC;
SIGNAL rewe_b_reg_in,rewe_b_reg_out :  one_bit_bus_type;
SIGNAL addr_b_reg               :  STD_LOGIC_VECTOR(port_b_address_width - 1 DOWNTO 0);
SIGNAL datain_b_reg             :  STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0);
SIGNAL dataout_b_reg            :  STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0);
SIGNAL dataout_b                :  STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0);
SIGNAL byteena_b_reg            :  STD_LOGIC_VECTOR(port_b_byte_enable_mask_width- 1 DOWNTO 0);
-- pulses
TYPE   pulse_vec IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF STD_LOGIC;
SIGNAL write_pulse,read_pulse,read_pulse_feedthru : pulse_vec; 
SIGNAL wpgen_a_clk,wpgen_a_clkena,wpgen_b_clk,wpgen_b_clkena : STD_LOGIC;
SIGNAL rpgen_a_clkena,rpgen_b_clkena : STD_LOGIC;
SIGNAL ftpgen_a_clkena,ftpgen_b_clkena : STD_LOGIC;
-- registered address
SIGNAL addr_prime_reg,addr_sec_reg :  INTEGER;   
-- input/output
SIGNAL datain_prime_reg,dataout_prime     :  STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);   
SIGNAL datain_sec_reg,dataout_sec         :  STD_LOGIC_VECTOR(data_unit_width - 1 DOWNTO 0);
--  overlapping location write
SIGNAL dual_write : BOOLEAN; 
-- memory core
SUBTYPE  mem_word_type IS STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
SUBTYPE  mem_col_type  IS STD_LOGIC_VECTOR (data_unit_width - 1 DOWNTO 0);
TYPE     mem_row_type  IS ARRAY (num_cols - 1 DOWNTO 0) OF mem_col_type;
TYPE     mem_type IS ARRAY ((2 ** address_unit_width) - 1 DOWNTO 0) OF mem_row_type;
SIGNAL   mem : mem_type;
SIGNAL   init_mem : BOOLEAN := FALSE;
CONSTANT mem_x : mem_type     := (OTHERS => (OTHERS => (OTHERS => 'X')));
CONSTANT row_x : mem_row_type := (OTHERS => (OTHERS => 'X'));
CONSTANT col_x : mem_col_type := (OTHERS => 'X');
SIGNAL   mem_data : mem_row_type;
SIGNAL   old_mem_data : mem_row_type;
SIGNAL   mem_unit_data : mem_col_type;

-- latches
TYPE   read_latch_rec IS RECORD
       prime : mem_row_type;
       sec   : mem_col_type;
END RECORD;
SIGNAL read_latch      :  read_latch_rec;
-- (row,column) coordinates
SIGNAL row_sec,col_sec  : INTEGER;
-- byte enable
TYPE   mask_type IS (normal,inverse);
TYPE   mask_prime_type IS ARRAY(mask_type'HIGH DOWNTO mask_type'LOW) OF mem_word_type;
TYPE   mask_sec_type   IS ARRAY(mask_type'HIGH DOWNTO mask_type'LOW) OF mem_col_type;
TYPE   mask_rec IS RECORD
       prime : mask_prime_type;
       sec   : mask_sec_type;
END RECORD;
SIGNAL mask_vector : mask_rec;
SIGNAL mask_vector_common : mem_col_type;

FUNCTION get_mask(
    b_ena : IN STD_LOGIC_VECTOR;
    mode  : port_type;
    CONSTANT b_ena_width ,byte_size: INTEGER
) RETURN mask_rec IS

VARIABLE l : INTEGER;
VARIABLE mask : mask_rec := (
                                (normal => (OTHERS => '0'),inverse => (OTHERS => 'X')),
                                (normal => (OTHERS => '0'),inverse => (OTHERS => 'X'))
                            );
BEGIN
    FOR l in 0 TO b_ena_width - 1  LOOP
        IF (b_ena(l) = '0') THEN 
            IF (mode = primary) THEN
                mask.prime(normal) ((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => 'X');
                mask.prime(inverse)((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => '0');
            ELSE
                mask.sec(normal) ((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => 'X');
                mask.sec(inverse)((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => '0');
            END IF;
        ELSIF (b_ena(l) = 'X' OR b_ena(l) = 'U') THEN 
            IF (mode = primary) THEN
                mask.prime(normal) ((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => 'X');
            ELSE
                mask.sec(normal) ((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => 'X');
            END IF;
        END IF;
    END LOOP;
    RETURN mask;
END get_mask;
-- port active for read/write
SIGNAL active_a_in_vec,active_b_in_vec,active_a_out,active_b_out : one_bit_bus_type;
SIGNAL active_a_in,active_b_in   : STD_LOGIC;
SIGNAL active_a,active_b : BOOLEAN;
SIGNAL active_write_a :  BOOLEAN;
SIGNAL active_write_b :  BOOLEAN;
SIGNAL wire_vcc : STD_LOGIC := '1';
SIGNAL wire_gnd : STD_LOGIC := '0';






BEGIN
    -- memory initialization
    init_mem <= TRUE;
    
    -- -------- core logic ---------------
    clk_a_in      <= clk0;

    clk_a_byteena <= '0'   WHEN (port_a_byte_enable_clock = "none" OR port_a_byte_enable_clock = "UNUSED") ELSE clk_a_in;
    clk_a_out     <= '0'   WHEN (port_a_data_out_clock = "none" OR port_a_data_out_clock = "UNUSED")    ELSE 
                      clk0 WHEN (port_a_data_out_clock = "clock0")  ELSE clk1;
                      
    clk_b_in      <=  clk0 WHEN (port_b_read_enable_write_enable_clock = "clock0") ELSE clk1;
    clk_b_byteena <=  '0'  WHEN (port_b_byte_enable_clock = "none" OR port_b_byte_enable_clock = "UNUSED") ELSE 
                      clk0 WHEN (port_b_byte_enable_clock = "clock0") ELSE clk1;
    clk_b_out     <=  '0'  WHEN (port_b_data_out_clock = "none" OR port_b_data_out_clock = "UNUSED")    ELSE 
                      clk0 WHEN (port_b_data_out_clock = "clock0")  ELSE clk1;

    addr_a_clr_in <=  '0'  WHEN (port_a_address_clear = "none" OR port_a_address_clear = "UNUSED") ELSE clr0;
    addr_b_clr_in <=  '0'  WHEN (port_b_address_clear = "none" OR port_b_address_clear = "UNUSED") ELSE 
                      clr0 WHEN (port_b_address_clear = "clear0") ELSE clr1;

    datain_a_clr_in <= '0' WHEN (port_a_data_in_clear = "none" OR port_a_data_in_clear = "UNUSED") ELSE clr0;
    datain_b_clr_in <= '0' WHEN (port_b_data_in_clear = "none" OR port_b_data_in_clear = "UNUSED") ELSE 
                       clr0 WHEN (port_b_data_in_clear = "clear0") ELSE clr1;
    
    dataout_a_clr   <= '0' WHEN (port_a_data_out_clear = "none" OR port_a_data_out_clear = "UNUSED")   ELSE 
                     clr0 WHEN (port_a_data_out_clear = "clear0") ELSE clr1;
    
    dataout_b_clr   <= '0' WHEN (port_b_data_out_clear = "none" OR port_b_data_out_clear = "UNUSED")   ELSE 
                     clr0 WHEN (port_b_data_out_clear = "clear0") ELSE clr1;
                      
    byteena_a_clr_in <= '0' WHEN (port_a_byte_enable_clear = "none" OR port_a_byte_enable_clear = "UNUSED") ELSE clr0;
    byteena_b_clr_in <= '0' WHEN (port_b_byte_enable_clear = "none" OR port_b_byte_enable_clear = "UNUSED") ELSE 
                        clr0 WHEN (port_b_byte_enable_clear = "clear0") ELSE clr1;
    we_a_clr_in      <= '0' WHEN (port_a_write_enable_clear = "none" OR port_a_write_enable_clear = "UNUSED") ELSE clr0;
    rewe_b_clr_in    <= '0' WHEN (port_b_read_enable_write_enable_clear = "none" OR port_b_read_enable_write_enable_clear = "UNUSED")   ELSE 
                        clr0 WHEN (port_b_read_enable_write_enable_clear = "clear0") ELSE clr1;
                
        active_a_in <= '1'  WHEN (port_a_disable_ce_on_input_registers = "on") ELSE ena0;
    
    
        active_b_in <= '1'  WHEN (port_b_disable_ce_on_input_registers = "on") ELSE 
                       ena0 WHEN (port_b_read_enable_write_enable_clock = "clock0") ELSE ena1;
 
    -- Store clock enable value for SEAB/MEAB
    -- A port active 
    active_a_in_vec(0) <= active_a_in;
    active_port_a : stratixii_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => active_a_in_vec,
            clk => clk_a_in,
            aclr => wire_gnd,
            devclrn => wire_vcc,devpor => wire_vcc,
            ena => wire_vcc,
            stall => wire_gnd,
            q => active_a_out
        );
    active_a <= (active_a_out(0) = '1');
    active_write_a <= active_a AND (byteena_a_reg /= bytes_a_disabled);
    
    -- B port active
    active_b_in_vec(0) <= active_b_in;
    active_port_b : stratixii_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => active_b_in_vec,
            clk => clk_b_in,
            aclr => wire_gnd,
            devclrn => wire_vcc,devpor => wire_vcc,
            stall => wire_gnd,
            ena => wire_vcc,
            q => active_b_out
        );
    active_b <= (active_b_out(0) = '1');
    active_write_b <= active_b AND (byteena_b_reg /= bytes_b_disabled);

    
    


    -- ------ A input registers
    -- write enable
    we_a_reg_in(0) <= '0' WHEN mode_is_rom ELSE portawe;
    we_a_register : stratixii_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => we_a_reg_in,
            clk => clk_a_in,
            aclr => we_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
             ena => active_a_in,
            q   => we_a_reg_out,
            aclrout => we_a_clr
        );
    we_a_reg <= we_a_reg_out(0);
    
    -- address
    addr_a_register : stratixii_ram_register
        GENERIC MAP ( width => port_a_address_width )
        PORT MAP (
            d => portaaddr,
            clk => clk_a_in,
            aclr => addr_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => portaaddrstall,
            ena => active_a_in,
            q   => addr_a_reg,
            aclrout => addr_a_clr
        );
    -- data
    datain_a_register : stratixii_ram_register
        GENERIC MAP ( width => port_a_data_width )
        PORT MAP (
            d => portadatain,
            clk => clk_a_in,
            aclr => datain_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => active_a_in,
            q   => datain_a_reg,
            aclrout => datain_a_clr
        );
    -- byte enable
    byteena_a_register : stratixii_ram_register
        GENERIC MAP (
            width  => port_a_byte_enable_mask_width,
            preset => '1'
        )
        PORT MAP (
            d => portabyteenamasks,
            clk => clk_a_byteena,
            aclr => byteena_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => active_a_in,
            q   => byteena_a_reg,
            aclrout => byteena_a_clr
        );
    -- ------ B input registers 
    -- read/write enable
    rewe_b_reg_in(0) <= portbrewe;
    rewe_b_register : stratixii_ram_register
        GENERIC MAP (
            width  => 1,
            preset => bool_to_std_logic(mode_is_dp)
        )
        PORT MAP (
            d => rewe_b_reg_in,
            clk => clk_b_in,
            aclr => rewe_b_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => active_b_in,
            q   => rewe_b_reg_out,
            aclrout => rewe_b_clr
        );
    rewe_b_reg <= rewe_b_reg_out(0);
    
    
    
    -- address
    addr_b_register : stratixii_ram_register
        GENERIC MAP ( width  => port_b_address_width )
        PORT MAP (
            d => portbaddr,
            clk => clk_b_in,
            aclr => addr_b_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => portbaddrstall,
            ena => active_b_in,
            q   => addr_b_reg,
            aclrout => addr_b_clr
        );
    -- data
    datain_b_register : stratixii_ram_register
        GENERIC MAP ( width  => port_b_data_width )
        PORT MAP (
            d => portbdatain,
            clk => clk_b_in,
            aclr => datain_b_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => active_b_in,
            q   => datain_b_reg,
            aclrout => datain_b_clr
        );
    -- byte enable
    byteena_b_register : stratixii_ram_register
        GENERIC MAP (
            width  => port_b_byte_enable_mask_width,
            preset => '1'
        )
        PORT MAP (
            d => portbbyteenamasks,
            clk => clk_b_byteena,
            aclr => byteena_b_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => active_b_in,
            q   => byteena_b_reg,
            aclrout => byteena_b_clr
        );
    
    datain_prime_reg <= datain_a_reg WHEN primary_port_is_a ELSE datain_b_reg;
    addr_prime_reg   <= alt_conv_integer(addr_a_reg)   WHEN primary_port_is_a ELSE alt_conv_integer(addr_b_reg);
    
    datain_sec_reg   <= (OTHERS => 'U') WHEN (mode_is_rom OR mode_is_sp) ELSE 
                        datain_b_reg    WHEN primary_port_is_a           ELSE datain_a_reg;
    addr_sec_reg     <= alt_conv_integer(addr_b_reg)   WHEN primary_port_is_a ELSE alt_conv_integer(addr_a_reg);
    
    -- Write pulse generation
    wpgen_a_clk <= clk_a_in WHEN ram_type ELSE (NOT clk_a_in);
      wpgen_a_clkena <= '1' WHEN (active_write_a AND (we_a_reg = '1')) ELSE '0';
    
    wpgen_a : stratixii_ram_pulse_generator 
        PORT MAP (
            clk => wpgen_a_clk,
            ena => wpgen_a_clkena,
            pulse => write_pulse(primary_port_is_a),
            cycle => write_cycle_a
        );
        
    wpgen_b_clk <= clk_b_in WHEN ram_type ELSE (NOT clk_b_in);
      wpgen_b_clkena <= '1' WHEN (active_write_b AND mode_is_bdp AND (rewe_b_reg = '1')) ELSE '0';
    
    
    wpgen_b : stratixii_ram_pulse_generator
        PORT MAP (
            clk => wpgen_b_clk,
            ena => wpgen_b_clkena,
            pulse => write_pulse(primary_port_is_b),
            cycle => write_cycle_b
            );
            
    -- Read  pulse generation
    rpgen_a_clkena <= '1' WHEN (active_a AND (we_a_reg = '0')) ELSE '0';
    
    rpgen_a : stratixii_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => rpgen_a_clkena,
            pulse => read_pulse(primary_port_is_a)
        );
    rpgen_b_clkena <= '1' WHEN (active_b AND mode_is_dp  AND (rewe_b_reg = '1')) OR 
                               (active_b AND mode_is_bdp AND (rewe_b_reg = '0'))
                         ELSE '0';
    rpgen_b : stratixii_ram_pulse_generator
        PORT MAP (
            clk => clk_b_in,
            ena => rpgen_b_clkena,
            pulse => read_pulse(primary_port_is_b)
        );
    
    
    
    -- Create internal masks for byte enable processing
    mask_create : PROCESS (byteena_a_reg,byteena_b_reg)
    VARIABLE mask : mask_rec;
    BEGIN
        IF (byteena_a_reg'EVENT) THEN
            mask := get_mask(byteena_a_reg,primary_port_is_a,port_a_byte_enable_mask_width,byte_size_a);
            IF (primary_port_is_a) THEN
                mask_vector.prime <= mask.prime;
            ELSE
                mask_vector.sec   <= mask.sec;
            END IF;
        END IF;
        IF (byteena_b_reg'EVENT) THEN
            mask := get_mask(byteena_b_reg,primary_port_is_b,port_b_byte_enable_mask_width,byte_size_b);
            IF (primary_port_is_b) THEN
                mask_vector.prime <= mask.prime;
            ELSE
                mask_vector.sec   <= mask.sec;
            END IF;
        END IF;
    END PROCESS mask_create;
    
    -- (row,col) coordinates
    row_sec <= addr_sec_reg / num_cols;    
    col_sec <= addr_sec_reg mod num_cols;
    

            
    
    mem_rw : PROCESS (init_mem,
                      write_pulse,read_pulse,read_pulse_feedthru,
                      mem_invalidate,mem_invalidate_loc,read_latch_invalidate)
    -- mem init
    TYPE rw_type IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF BOOLEAN;
    VARIABLE addr_range_init,row,col,index :  INTEGER;
    VARIABLE mem_init_std :  STD_LOGIC_VECTOR((port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1 DOWNTO 0);
   VARIABLE mem_init  :  bit_vector(mem_init1'length + mem_init0'length - 1 DOWNTO 0);

    VARIABLE mem_val : mem_type; 
    -- read/write
    VARIABLE mem_data_p : mem_row_type;
    VARIABLE old_mem_data_p : mem_row_type;
    VARIABLE row_prime,col_prime  : INTEGER;
    VARIABLE access_same_location : BOOLEAN;
    VARIABLE read_during_write    : rw_type;
    BEGIN

        read_during_write := (FALSE,FALSE);
        -- Memory initialization
        IF (init_mem'EVENT) THEN
            -- Initialize output latches to 0
            IF (primary_port_is_a) THEN
                dataout_prime <= (OTHERS => '0');
                IF (mode_is_dp OR mode_is_bdp) THEN dataout_sec <= (OTHERS => '0'); END IF;
            ELSE
                dataout_sec   <= (OTHERS => '0');
                IF (mode_is_dp OR mode_is_bdp) THEN dataout_prime <= (OTHERS => '0'); END IF;
            END IF;
             IF (power_up_uninitialized = "false" AND (NOT ram_type)) THEN
                 mem_val := (OTHERS => (OTHERS => (OTHERS => '0'))); 
             END IF;
            IF (primary_port_is_a) THEN 
                addr_range_init := port_a_last_address - port_a_first_address + 1;
            ELSE
                addr_range_init := port_b_last_address - port_b_first_address + 1;
            END IF;
            IF (init_file_layout = "port_a" OR init_file_layout = "port_b") THEN
                mem_init := mem_init1 & mem_init0;
                mem_init_std := to_stdlogicvector(mem_init) ((port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1 DOWNTO 0);
                FOR row IN 0 TO addr_range_init - 1 LOOP
                    FOR col IN 0 to num_cols - 1 LOOP
                        index := row * data_width;
                        mem_val(row)(col) := mem_init_std(index + (col+1)*data_unit_width -1 DOWNTO 
                                                          index +  col*data_unit_width);
                    END LOOP;
                END LOOP;
            END IF;
            mem <= mem_val;
        END IF;
        access_same_location := (mode_is_dp OR mode_is_bdp) AND (addr_prime_reg = row_sec);
        
        -- Write stage 1 : X to buffer
        -- Write stage 2 : actual data to memory
    	IF (write_pulse(primary)'EVENT) THEN
    	    IF (write_pulse(primary) = '1') THEN
    	        old_mem_data_p := mem(addr_prime_reg);
    	        mem_data_p := mem(addr_prime_reg);
    	        FOR i IN 0 TO num_cols - 1 LOOP
    	            mem_data_p(i) := mem_data_p(i) XOR 
    	                             mask_vector.prime(inverse)((i + 1)*data_unit_width - 1 DOWNTO i*data_unit_width);
    	        END LOOP;
    	        read_during_write(secondary) := (access_same_location AND read_pulse(secondary)'EVENT AND read_pulse(secondary) = '1');
    	        IF (read_during_write(secondary)) THEN    
    	            read_latch.sec <= old_mem_data_p(col_sec);
    	        ELSE
    	            mem_data <= mem_data_p;
    	        END IF;
    	    ELSIF (clear_asserted_during_write(primary) /= '1') THEN
    	        FOR i IN 0 TO data_width - 1 LOOP
    	            IF (mask_vector.prime(normal)(i) = '0') THEN
    	                mem(addr_prime_reg)(i / data_unit_width)(i mod data_unit_width) <= datain_prime_reg(i);
    	            ELSIF (mask_vector.prime(inverse)(i) = 'X') THEN
    	                mem(addr_prime_reg)(i / data_unit_width)(i mod data_unit_width) <= 'X';
    	            END IF;                       
       	        END LOOP;
    	    END IF;
    	END IF;
    	
    	IF (write_pulse(secondary)'EVENT) THEN
    	    IF (write_pulse(secondary) = '1') THEN
    	        read_during_write(primary) := (access_same_location AND read_pulse(primary)'EVENT AND read_pulse(primary) = '1');
    	        IF (read_during_write(primary)) THEN
    	            read_latch.prime <= mem(addr_prime_reg);
    	            read_latch.prime(col_sec) <= mem(row_sec)(col_sec) XOR mask_vector.sec(inverse);
    	        ELSE
    	            mem_unit_data <= mem(row_sec)(col_sec) XOR mask_vector.sec(inverse);
    	        END IF;
    	        
    	        IF (access_same_location AND write_pulse(primary)'EVENT AND write_pulse(primary) = '1') THEN
    	            mask_vector_common <= 
                       mask_vector.prime(inverse)(((col_sec + 1)* data_unit_width - 1) DOWNTO col_sec*data_unit_width) AND 
                       mask_vector.sec(inverse);
                    dual_write <= TRUE;
    	        END IF;
    	    ELSIF (clear_asserted_during_write(secondary) /= '1') THEN
    	        FOR i IN 0 TO data_unit_width - 1 LOOP
    	            IF (mask_vector.sec(normal)(i) = '0') THEN
    	                mem(row_sec)(col_sec)(i) <= datain_sec_reg(i);
    	            ELSIF (mask_vector.sec(inverse)(i) = 'X') THEN
    	                mem(row_sec)(col_sec)(i) <= 'X';
    	            END IF;                       
       	        END LOOP;
    	    END IF;
    	END IF;
    	-- Simultaneous write
        IF (dual_write AND write_pulse = "00") THEN
           mem(row_sec)(col_sec) <= mem(row_sec)(col_sec) XOR mask_vector_common;
           dual_write <= FALSE;
        END IF;
    	-- Read stage 1 : read data 
    	-- Read stage 2 : send data to output
    	IF ((NOT read_during_write(primary)) AND read_pulse(primary)'EVENT) THEN
    	    IF (read_pulse(primary) = '1') THEN
    	        read_latch.prime <= mem(addr_prime_reg);
    	        IF (access_same_location AND write_pulse(secondary) = '1') THEN
    	            read_latch.prime(col_sec) <= mem_unit_data;
    	        END IF;    
    	    ELSE
    	        FOR i IN 0 TO data_width - 1 LOOP
    	            row_prime := i / data_unit_width; col_prime := i mod data_unit_width;
    	            dataout_prime(i) <= read_latch.prime(row_prime)(col_prime);                      
       	        END LOOP;
    	    END IF;
    	END IF;
    	
    	IF ((NOT read_during_write(secondary)) AND read_pulse(secondary)'EVENT) THEN
    	    IF (read_pulse(secondary) = '1') THEN
    	        IF (access_same_location AND write_pulse(primary) = '1') THEN
    	            read_latch.sec <= mem_data(col_sec);
    	        ELSE
    	            read_latch.sec <= mem(row_sec)(col_sec);
    	        END IF;
    	    ELSE
    	        dataout_sec <= read_latch.sec;
    	    END IF;
    	END IF;
    	-- Same port feed thru
    	   IF (read_pulse_feedthru(primary)'EVENT AND read_pulse_feedthru(primary) = '0') THEN
            dataout_prime <= datain_prime_reg XOR mask_vector.prime(normal);
        END IF;
        
        IF (read_pulse_feedthru(secondary)'EVENT AND read_pulse_feedthru(secondary) = '0') THEN
           dataout_sec <= datain_sec_reg XOR mask_vector.sec(normal);
        END IF;
        -- Async clear
        IF (mem_invalidate'EVENT) THEN
            IF (mem_invalidate(primary) = TRUE OR mem_invalidate(secondary) = TRUE) THEN
                mem <= mem_x;
            END IF;
        END IF;
        IF (mem_invalidate_loc'EVENT) THEN
            IF (mem_invalidate_loc(primary))   THEN mem(addr_prime_reg)   <= row_x;  END IF;
            IF (mem_invalidate_loc(secondary)) THEN mem(row_sec)(col_sec) <= col_x;  END IF;
        END IF;
        IF (read_latch_invalidate'EVENT) THEN
            IF (read_latch_invalidate(primary)) THEN 
                read_latch.prime <= row_x; 
            END IF;
            IF (read_latch_invalidate(secondary)) THEN 
                read_latch.sec   <= col_x;
            END IF;
        END IF;
    
    END PROCESS mem_rw;
    
    -- Same port feed through
   ftpgen_a_clkena <= '1' WHEN (active_a AND (NOT mode_is_dp) AND (we_a_reg = '1')) ELSE '0';            
    ftpgen_a : stratixii_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => ftpgen_a_clkena,
            pulse => read_pulse_feedthru(primary_port_is_a)
        );
   ftpgen_b_clkena <= '1' WHEN (active_b AND mode_is_bdp AND (rewe_b_reg = '1')) ELSE '0';               

    ftpgen_b : stratixii_ram_pulse_generator
        PORT MAP (
            clk => clk_b_in,
            ena => ftpgen_b_clkena,
            pulse => read_pulse_feedthru(primary_port_is_b)
        );





    -- Asynch clear events    
    clear_a : PROCESS(addr_a_clr,we_a_clr,datain_a_clr)
    BEGIN
        IF (addr_a_clr'EVENT AND addr_a_clr = '1') THEN
            clear_asserted_during_write(primary_port_is_a) <= write_pulse(primary_port_is_a);
            IF (active_write_a AND (write_cycle_a = '1') AND (we_a_reg = '1')) THEN
                mem_invalidate(primary_port_is_a) <= TRUE,FALSE AFTER 0.5 ns;
           ELSIF (active_a AND we_a_reg = '0') THEN
                read_latch_invalidate(primary_port_is_a) <= TRUE,FALSE AFTER 0.5 ns;
            END IF;
        END IF;
        IF ((we_a_clr'EVENT AND we_a_clr = '1') OR (datain_a_clr'EVENT AND datain_a_clr = '1')) THEN
            clear_asserted_during_write(primary_port_is_a) <= write_pulse(primary_port_is_a);
            IF (active_write_a AND (write_cycle_a = '1') AND (we_a_reg = '1')) THEN
                mem_invalidate_loc(primary_port_is_a) <= TRUE,FALSE AFTER 0.5 ns;
                read_latch_invalidate(primary_port_is_a) <= TRUE,FALSE AFTER 0.5 ns;
            END IF;
        END IF;
    END PROCESS clear_a;
    
   clear_b : PROCESS(addr_b_clr,rewe_b_clr,datain_b_clr)
    BEGIN
        IF (addr_b_clr'EVENT AND addr_b_clr = '1') THEN
            clear_asserted_during_write(primary_port_is_b) <= write_pulse(primary_port_is_b);
           IF (mode_is_bdp AND active_write_b AND (write_cycle_b = '1') AND (rewe_b_reg = '1')) THEN
                mem_invalidate(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
           ELSIF (active_b AND ((mode_is_dp AND rewe_b_reg = '1') OR (mode_is_bdp AND rewe_b_reg = '0'))) THEN
                read_latch_invalidate(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
            END IF;
        END IF;
       IF ((rewe_b_clr'EVENT AND rewe_b_clr = '1') OR (datain_b_clr'EVENT AND datain_b_clr = '1')) THEN
            clear_asserted_during_write(primary_port_is_b) <= write_pulse(primary_port_is_b);
           IF (mode_is_bdp AND active_write_b AND (write_cycle_b = '1') AND (rewe_b_reg = '1')) THEN
                mem_invalidate_loc(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
                read_latch_invalidate(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
            END IF;
        END IF;
    END PROCESS clear_b;
    
    
    
    
    -- ------ Output registers
       clkena_a_out <= '1'  WHEN (port_a_disable_ce_on_output_registers = "on") ELSE
                       ena0 WHEN (port_a_data_out_clock = "clock0") ELSE ena1;
    
      clkena_b_out <= '1'  WHEN (port_b_disable_ce_on_output_registers = "on") ELSE
                       ena0 WHEN (port_b_data_out_clock = "clock0") ELSE ena1;
    
    
    dataout_a <= dataout_prime WHEN primary_port_is_a ELSE dataout_sec;
    dataout_b <= (OTHERS => 'U') WHEN (mode_is_rom OR mode_is_sp) ELSE 
                 dataout_prime   WHEN primary_port_is_b ELSE dataout_sec;
    
    dataout_a_register : stratixii_ram_register
        GENERIC MAP ( width => port_a_data_width )
        PORT MAP (
            d => dataout_a,
            clk => clk_a_out,
                     aclr => dataout_a_clr,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => clkena_a_out,
            q => dataout_a_reg
        );
        
    dataout_b_register : stratixii_ram_register
        GENERIC MAP ( width => port_b_data_width )
        PORT MAP (
            d => dataout_b,
            clk => clk_b_out,
                     aclr => dataout_b_clr,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => clkena_b_out,
            q => dataout_b_reg
        );
        
   portadataout <= dataout_a_reg WHEN out_a_is_reg ELSE dataout_a;
   portbdataout <= dataout_b_reg WHEN out_b_is_reg ELSE dataout_b;
    

END block_arch;


-------------------------------------------------------------------
--
-- Entity Name : stratixii_jtag
--
-- Description : StratixII JTAG VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixii_atom_pack.all;

entity  stratixii_jtag is
    generic (
        lpm_type : string := "stratixii_jtag"
        );	
    port (
        tms : in std_logic := '0'; 
        tck : in std_logic := '0'; 
        tdi : in std_logic := '0'; 
        ntrst : in std_logic := '0'; 
        tdoutap : in std_logic := '0'; 
        tdouser : in std_logic := '0'; 
        tdo: out std_logic; 
        tmsutap: out std_logic; 
        tckutap: out std_logic; 
        tdiutap: out std_logic; 
        shiftuser: out std_logic; 
        clkdruser: out std_logic; 
        updateuser: out std_logic; 
        runidleuser: out std_logic; 
        usr1user: out std_logic
        );
end stratixii_jtag;

architecture architecture_jtag of stratixii_jtag is
begin

end architecture_jtag;

-------------------------------------------------------------------
--
-- Entity Name : stratixii_crcblock
--
-- Description : StratixII CRCBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixii_atom_pack.all;

entity  stratixii_crcblock is
    generic  (
        oscillator_divider : integer := 1;

        lpm_type : string := "stratixii_crcblock"
        );	
    port (
        clk : in std_logic := '0'; 
        shiftnld : in std_logic := '0'; 
           ldsrc : in std_logic := '0'; 
        crcerror : out std_logic; 
        regout : out std_logic
        ); 
end stratixii_crcblock;

architecture architecture_crcblock of stratixii_crcblock is
begin
	crcerror <= '0';
	regout <= '0';
end architecture_crcblock;
-------------------------------------------------------------------
--
-- Entity Name : stratixii_asmiblock
--
-- Description : StratixII ASMIBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixii_atom_pack.all;

entity  stratixii_asmiblock is
	 generic (
					lpm_type	: string := "stratixii_asmiblock"
				);	
    port (dclkin : in std_logic; 
    		 scein : in std_logic; 
    		 sdoin : in std_logic; 
    		 oe : in std_logic; 
          data0out: out std_logic);
end stratixii_asmiblock;

architecture architecture_asmiblock of stratixii_asmiblock is
begin

process(dclkin, scein, sdoin, oe)
begin

end process;

end architecture_asmiblock;  -- end of stratixii_asmiblock
---------------------------------------------------------------------
--
-- Entity Name :  stratixii_lcell_ff
-- 
-- Description :  StratixII LCELL_FF VHDL simulation model
--  
--
---------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
use work.stratixii_and1;

entity stratixii_lcell_ff is
    generic (
             x_on_violation : string := "on";
             lpm_type : string := "stratixii_lcell_ff";
             tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_adatasdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_adatasdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aload_regout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_adatasdata_regout: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01;
             tipd_adatasdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01; 
             tipd_aload : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01; 
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*"
            );
    
    port (
          datain : in std_logic := '0';
          clk : in std_logic := '0';
          aclr : in std_logic := '0';
          aload : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          adatasdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          regout : out std_logic
         );
   attribute VITAL_LEVEL0 of stratixii_lcell_ff : entity is TRUE;
end stratixii_lcell_ff;
        
architecture vital_lcell_ff of stratixii_lcell_ff is
   attribute VITAL_LEVEL0 of vital_lcell_ff : architecture is TRUE;
   signal clk_ipd : std_logic;
   signal datain_ipd : std_logic;
   signal datain_dly : std_logic;
   signal adatasdata_ipd : std_logic;
   signal adatasdata_dly : std_logic;
   signal adatasdata_dly1 : std_logic;
   signal sclr_ipd : std_logic;
   signal sload_ipd : std_logic;
   signal aclr_ipd : std_logic;
   signal aload_ipd : std_logic;
   signal ena_ipd : std_logic;

component stratixii_and1
    generic (XOn                  : Boolean := DefGlitchXOn;
             MsgOn                : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y            : VitalDelayType01 := DefPropDelay01;
             tipd_IN1             : VitalDelayType01 := DefPropDelay01
            );
        
    port    (Y                    :  out   STD_LOGIC;
             IN1                  :  in    STD_LOGIC
            );
end component;

begin

dataindelaybuffer: stratixii_and1
                   port map(IN1 => datain_ipd,
                            Y => datain_dly);

adatasdatadelaybuffer: stratixii_and1
                   port map(IN1 => adatasdata_ipd,
                            Y => adatasdata_dly);

adatasdatadelaybuffer1: stratixii_and1
                   port map(IN1 => adatasdata_dly,
                            Y => adatasdata_dly1);


    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (adatasdata_ipd, adatasdata, tipd_adatasdata);
        VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (aload_ipd, aload, tipd_aload);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process (clk_ipd, datain_dly, adatasdata_dly1,
                           sclr_ipd, sload_ipd, aclr_ipd, aload_ipd,
                           ena_ipd, devclrn, devpor)
    
    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_adatasdata_clk : std_ulogic := '0';
    variable Tviol_sclr_clk : std_ulogic := '0';
    variable Tviol_sload_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_adatasdata_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    
    variable iregout : std_logic := '0';
    variable idata: std_logic := '0';
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';
    
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
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datain_clk_noedge_posedge,
                SetupLow        => tsetup_datain_clk_noedge_posedge,
                HoldHigh        => thold_datain_clk_noedge_posedge,
                HoldLow         => thold_datain_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (sload_ipd) OR
                                          (sclr_ipd) OR
                                          (aload_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_adatasdata_clk,
                TimingData      => TimingData_adatasdata_clk,
                TestSignal      => adatasdata_ipd,
                TestSignalName  => "ADATASDATA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_adatasdata_clk_noedge_posedge,
                SetupLow        => tsetup_adatasdata_clk_noedge_posedge,
                HoldHigh        => thold_adatasdata_clk_noedge_posedge,
                HoldLow         => thold_adatasdata_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT sload_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
            VitalSetupHoldCheck (
                Violation       => Tviol_sclr_clk,
                TimingData      => TimingData_sclr_clk,
                TestSignal      => sclr_ipd,
                TestSignalName  => "SCLR",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sclr_clk_noedge_posedge,
                SetupLow        => tsetup_sclr_clk_noedge_posedge,
                HoldHigh        => thold_sclr_clk_noedge_posedge,
                HoldLow         => thold_sclr_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_sload_clk,
                TimingData      => TimingData_sload_clk,
                TestSignal      => sload_ipd,
                TestSignalName  => "SLOAD",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sload_clk_noedge_posedge,
                SetupLow        => tsetup_sload_clk_noedge_posedge,
                HoldHigh        => thold_sload_clk_noedge_posedge,
                HoldLow         => thold_sload_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        
            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena_ipd,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
        end if;
    
        violation := Tviol_datain_clk or Tviol_adatasdata_clk or 
                     Tviol_sclr_clk or Tviol_sload_clk or Tviol_ena_clk;
    
    
        if ((devpor = '0') or (devclrn = '0') or (aclr_ipd = '1'))  then
            iregout := '0';
        elsif (aload_ipd = '1') then
            iregout := adatasdata_dly1;
        elsif (violation = 'X' and x_on_violation = "on") then
            iregout := 'X';
        elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' then
            if (ena_ipd = '1') then
                if (sclr_ipd = '1') then
                    iregout := '0';
                elsif (sload_ipd = '1') then
                    iregout := adatasdata_dly1;
                else
                    iregout := datain_dly;
                end if;
            end if;
        end if;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => iregout,
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                      1 => (aload_ipd'last_event, tpd_aload_regout_posedge, TRUE),
                      2 => (adatasdata_ipd'last_event, tpd_adatasdata_regout, TRUE),
                      3 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
    end process;

end vital_lcell_ff;	

---------------------------------------------------------------------
--
-- Entity Name :  stratixii_lcell_comb
-- 
-- Description :  StratixII LCELL_COMB VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

entity stratixii_lcell_comb is
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
             lpm_type : string := "stratixii_lcell_comb";
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
             tpd_dataa_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datae_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datag_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_sharein_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tpd_sharein_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_shareout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_datae : VitalDelayType01 := DefPropDelay01; 
             tipd_dataf : VitalDelayType01 := DefPropDelay01; 
             tipd_datag : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01; 
             tipd_sharein : VitalDelayType01 := DefPropDelay01
            );
    
    port (
          dataa : in std_logic := '0';
          datab : in std_logic := '0';
          datac : in std_logic := '0';
          datad : in std_logic := '0';
          datae : in std_logic := '0';
          dataf : in std_logic := '0';
          datag : in std_logic := '0';
          cin : in std_logic := '0';
          sharein : in std_logic := '0';
          combout : out std_logic;
          sumout : out std_logic;
          cout : out std_logic;
          shareout : out std_logic
         );
   attribute VITAL_LEVEL0 of stratixii_lcell_comb : entity is TRUE;
end stratixii_lcell_comb;
        
architecture vital_lcell_comb of stratixii_lcell_comb is
    attribute VITAL_LEVEL0 of vital_lcell_comb : architecture is TRUE;
    signal dataa_ipd : std_logic;
    signal datab_ipd : std_logic;
    signal datac_ipd : std_logic;
    signal datad_ipd : std_logic;
    signal datae_ipd : std_logic;
    signal dataf_ipd : std_logic;
    signal datag_ipd : std_logic;
    signal cin_ipd : std_logic;
    signal sharein_ipd : std_logic;
    signal f2_input3 : std_logic;
    -- sub masks
    signal f0_mask : std_logic_vector(15 downto 0);
    signal f1_mask : std_logic_vector(15 downto 0);
    signal f2_mask : std_logic_vector(15 downto 0);
    signal f3_mask : std_logic_vector(15 downto 0);
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (dataa_ipd, dataa, tipd_dataa);
        VitalWireDelay (datab_ipd, datab, tipd_datab);
        VitalWireDelay (datac_ipd, datac, tipd_datac);
        VitalWireDelay (datad_ipd, datad, tipd_datad);
        VitalWireDelay (datae_ipd, datae, tipd_datae);
        VitalWireDelay (dataf_ipd, dataf, tipd_dataf);
        VitalWireDelay (datag_ipd, datag, tipd_datag);
        VitalWireDelay (cin_ipd, cin, tipd_cin);
        VitalWireDelay (sharein_ipd, sharein, tipd_sharein);
    end block;

    f0_mask <= lut_mask(15 downto 0);
    f1_mask <= lut_mask(31 downto 16);
    f2_mask <= lut_mask(47 downto 32);
    f3_mask <= lut_mask(63 downto 48);

    f2_input3 <= datag_ipd WHEN (extended_lut = "on") ELSE datac_ipd;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd,
                      datae_ipd, dataf_ipd, f2_input3, cin_ipd, 
                      sharein_ipd)

variable combout_VitalGlitchData : VitalGlitchDataType;
variable sumout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
variable shareout_VitalGlitchData : VitalGlitchDataType;
-- sub lut outputs
variable f0_out : std_logic;
variable f1_out : std_logic;
variable f2_out : std_logic;
variable f3_out : std_logic;
-- muxed output
variable g0_out : std_logic;
variable g1_out : std_logic;
-- internal variables
variable f2_f : std_logic;
variable adder_input2 : std_logic;
-- output variables
variable combout_tmp : std_logic;
variable sumout_tmp : std_logic;
variable cout_tmp : std_logic;
-- temp variable for NCVHDL
variable lut_mask_var : std_logic_vector(63 downto 0) := (OTHERS => '1');

begin
  
    lut_mask_var := lut_mask;

    ------------------------
    --  Timing Check Section
    ------------------------

    f0_out := VitalMUX(data => f0_mask,
                       dselect => (datad_ipd,
                                   datac_ipd,
                                   datab_ipd,
                                   dataa_ipd));
    f1_out := VitalMUX(data => f1_mask,
                       dselect => (datad_ipd,
                                   f2_input3,
                                   datab_ipd,
                                   dataa_ipd));
    f2_out := VitalMUX(data => f2_mask,
                       dselect => (datad_ipd,
                                   datac_ipd,
                                   datab_ipd,
                                   dataa_ipd));
    f3_out := VitalMUX(data => f3_mask,
                       dselect => (datad_ipd,
                                   f2_input3,
                                   datab_ipd,
                                   dataa_ipd));
    
    -- combout 
    if (extended_lut = "on") then
        if (datae_ipd = '0') then
            g0_out := f0_out;
            g1_out := f2_out;
        elsif (datae_ipd = '1') then
            g0_out := f1_out;
            g1_out := f3_out;
        else
            g0_out := 'X';
            g1_out := 'X';
        end if;

        if (dataf_ipd = '0') then
            combout_tmp := g0_out;
        elsif ((dataf_ipd = '1')  or (g0_out = g1_out))then
            combout_tmp := g1_out;
        else
            combout_tmp := 'X';
        end if;
    else
        combout_tmp := VitalMUX(data => lut_mask_var,
                                dselect => (dataf_ipd,
                                            datae_ipd,
                                            datad_ipd,
                                            datac_ipd,
                                            datab_ipd,
                                            dataa_ipd));
    end if;

    -- sumout and cout
    f2_f := VitalMUX(data => f2_mask,
                     dselect => (dataf_ipd,
                                 datac_ipd,
                                 datab_ipd,
                                 dataa_ipd));

    if (shared_arith = "on") then
        adder_input2 := sharein_ipd;
    else
        adder_input2 := NOT f2_f;
    end if;

    sumout_tmp := cin_ipd XOR f0_out XOR adder_input2;
    cout_tmp := (cin_ipd AND f0_out) OR (cin_ipd AND adder_input2) OR
                (f0_out AND adder_input2);

    ----------------------
    --  Path Delay Section
    ----------------------

    VitalPathDelay01 (
        OutSignal => combout,
        OutSignalName => "COMBOUT",
        OutTemp => combout_tmp,
        Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                  1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                  2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                  3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                  4 => (datae_ipd'last_event, tpd_datae_combout, TRUE),
                  5 => (dataf_ipd'last_event, tpd_dataf_combout, TRUE),
                  6 => (datag_ipd'last_event, tpd_datag_combout, TRUE)),
        GlitchData => combout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

    VitalPathDelay01 (
        OutSignal => sumout,
        OutSignalName => "SUMOUT",
        OutTemp => sumout_tmp,
        Paths => (0 => (dataa_ipd'last_event, tpd_dataa_sumout, TRUE),
                  1 => (datab_ipd'last_event, tpd_datab_sumout, TRUE),
                  2 => (datac_ipd'last_event, tpd_datac_sumout, TRUE),
                  3 => (datad_ipd'last_event, tpd_datad_sumout, TRUE),
                  4 => (dataf_ipd'last_event, tpd_dataf_sumout, TRUE),
                  5 => (cin_ipd'last_event, tpd_cin_sumout, TRUE),
                  6 => (sharein_ipd'last_event, tpd_sharein_sumout, TRUE)),
        GlitchData => sumout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

    VitalPathDelay01 (
        OutSignal => cout,
        OutSignalName => "COUT",
        OutTemp => cout_tmp,
        Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                  1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                  2 => (datac_ipd'last_event, tpd_datac_cout, TRUE),
                  3 => (datad_ipd'last_event, tpd_datad_cout, TRUE),
                  4 => (dataf_ipd'last_event, tpd_dataf_cout, TRUE),
                  5 => (cin_ipd'last_event, tpd_cin_cout, TRUE),
                  6 => (sharein_ipd'last_event, tpd_sharein_cout, TRUE)),
        GlitchData => cout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

    VitalPathDelay01 (
        OutSignal => shareout,
        OutSignalName => "SHAREOUT",
        OutTemp => f2_out,
        Paths => (0 => (dataa_ipd'last_event, tpd_dataa_shareout, TRUE),
                  1 => (datab_ipd'last_event, tpd_datab_shareout, TRUE),
                  2 => (datac_ipd'last_event, tpd_datac_shareout, TRUE),
                  3 => (datad_ipd'last_event, tpd_datad_shareout, TRUE)),
        GlitchData => shareout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

end process;

end vital_lcell_comb;	

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : ena_reg
--
-- Description : Simulation model for a simple DFF.
--               This is used for the gated clock generation
--               Powers upto 1.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_ena_reg is
    generic (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          clk : in std_logic;
          ena : in std_logic := '1';
          d : in std_logic;
          clrn : in std_logic := '1';
          prn : in std_logic := '1';
          q : out std_logic
         );
   attribute VITAL_LEVEL0 of stratixii_ena_reg : entity is TRUE;
end stratixii_ena_reg;

ARCHITECTURE behave of stratixii_ena_reg is
    attribute VITAL_LEVEL0 of behave : architecture is TRUE;
    signal d_ipd : std_logic;
    signal clk_ipd : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (d_ipd, d, tipd_d);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
    end block;

    VITALtiming :  process (clk_ipd, prn, clrn)
    variable Tviol_d_clk : std_ulogic := '0';
    variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
    variable q_VitalGlitchData : VitalGlitchDataType;
    variable q_reg : std_logic := '1';
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_d_clk,
                TimingData      => TimingData_d_clk,
                TestSignal      => d,
                TestSignalName  => "D",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_d_clk_noedge_posedge,
                SetupLow        => tsetup_d_clk_noedge_posedge,
                HoldHigh        => thold_d_clk_noedge_posedge,
                HoldLow         => thold_d_clk_noedge_posedge,
                CheckEnabled    => TO_X01((clrn) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/ENA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if (prn = '0') then
            q_reg := '1';
        elsif (clrn = '0') then
            q_reg := '0';
        elsif (clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' and (ena = '1')) then
            q_reg := d_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => q,
            OutSignalName => "Q",
            OutTemp => q_reg,
            Paths => (0 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE)),
            GlitchData => q_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    end process;

end behave;

--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Model for StratixII CLKCTRL Atom
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  STRATIXII_CLKCTRL Model
--
--

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
use work.stratixii_ena_reg;

entity stratixii_clkctrl is
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "stratixii_clkctrl";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_ena : VitalDelayType01 := DefPropDelay01
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          ena : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          outclk : out std_logic
          );    
   attribute VITAL_LEVEL0 of stratixii_clkctrl : entity is TRUE;
end stratixii_clkctrl;
        
architecture vital_clkctrl of stratixii_clkctrl is
    attribute VITAL_LEVEL0 of vital_clkctrl : architecture is TRUE;

    component stratixii_ena_reg
        generic (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
                 tipd_d : VitalDelayType01 := DefPropDelay01;
                 tipd_clk : VitalDelayType01 := DefPropDelay01
                );
        PORT (
              clk : in std_logic;
              ena : in std_logic := '1';
              d : in std_logic;
              clrn : in std_logic := '1';
              prn : in std_logic := '1';
              q : out std_logic
             );
    end component;

    signal inclk_ipd : std_logic_vector(3 downto 0);
    signal clkselect_ipd : std_logic_vector(1 downto 0);
    signal ena_ipd : std_logic;
    signal clkmux_out : std_logic;
    signal clkmux_out_inv : std_logic;
    signal cereg_clr : std_logic;
    signal cereg_out : std_logic;
    signal vcc : std_logic := '1';
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (inclk_ipd(0), inclk(0), tipd_inclk(0));
        VitalWireDelay (inclk_ipd(1), inclk(1), tipd_inclk(1));
        VitalWireDelay (inclk_ipd(2), inclk(2), tipd_inclk(2));
        VitalWireDelay (inclk_ipd(3), inclk(3), tipd_inclk(3));
        VitalWireDelay (clkselect_ipd(0), clkselect(0), tipd_clkselect(0));
        VitalWireDelay (clkselect_ipd(1), clkselect(1), tipd_clkselect(1));
    end block;

    process(inclk_ipd, clkselect_ipd)
    variable tmp : std_logic;
    begin
        if (clkselect_ipd = "11") then
            tmp := inclk_ipd(3);
        elsif (clkselect_ipd = "10") then
            tmp := inclk_ipd(2);
        elsif (clkselect_ipd = "01") then
            tmp := inclk_ipd(1);
        else
            tmp := inclk_ipd(0);
        end if;
        clkmux_out <= tmp;
        clkmux_out_inv <= NOT tmp;
    end process;

    extena0_reg : stratixii_ena_reg
                  port map (
                            clk => clkmux_out_inv,
                            ena => vcc,
                            d => ena_ipd, 
                            clrn => vcc,
                            prn => devpor,
                            q => cereg_out 
                           );

    outclk <= cereg_out AND clkmux_out;

end vital_clkctrl;	


--
--
--  STRATIXII_ASYNCH_IO Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

entity stratixii_asynch_io is
    generic(
        operation_mode : STRING := "input";
        open_drain_output : STRING := "false";
        bus_hold : STRING := "false";
        dqs_input_frequency      : STRING := "10000 ps";
        dqs_out_mode             : STRING := "none";
        dqs_delay_buffer_mode    : STRING := "low";
        dqs_phase_shift          : INTEGER := 0;
        dqs_offsetctrl_enable    : STRING := "false";
        dqs_ctrl_latches_enable  : STRING := "false";
        dqs_edge_detect_enable   : STRING := "false";  
        gated_dqs                : STRING := "false";  
        sim_dqs_intrinsic_delay  : INTEGER := 0;
        sim_dqs_delay_increment  : INTEGER := 0;
        sim_dqs_offset_increment : INTEGER := 0;
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;
        tpd_datain_padio : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_padio_combout : VitalDelayType01 := DefPropDelay01;
        tpd_regin_regout : VitalDelayType01 := DefPropDelay01;
        tpd_ddioregin_ddioregout : VitalDelayType01 := DefPropDelay01;
        tpd_padio_dqsbusout : VitalDelayType01 := DefPropDelay01;
        tpd_regin_dqsbusout : VitalDelayType01 := DefPropDelay01;
        tipd_datain : VitalDelayType01 := DefPropDelay01;
        tipd_oe : VitalDelayType01 := DefPropDelay01;
        tipd_padio : VitalDelayType01 := DefPropDelay01;
        tipd_dqsupdateen : VitalDelayType01 := DefPropDelay01;
        tipd_offsetctrlin : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
        tipd_delayctrlin : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01));
        port(
            datain : in  STD_LOGIC := '0';
            oe : in  STD_LOGIC := '1';
            regin : in std_logic;
            ddioregin : in std_logic;
            padio : inout STD_LOGIC;
            delayctrlin  : in std_logic_vector(5 downto 0);
            offsetctrlin : in std_logic_vector(5 downto 0);
            dqsupdateen  : in std_logic;
            dqsbusout    : out std_logic;
            combout : out STD_LOGIC;
            regout : out STD_LOGIC;
            ddioregout : out STD_LOGIC
            );

    attribute VITAL_LEVEL0 of stratixii_asynch_io : entity is TRUE;
end stratixii_asynch_io;

architecture behave of stratixii_asynch_io is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;
signal datain_ipd, oe_ipd, padio_ipd: std_logic;
signal delayctrlin_in  : std_logic_vector(5 downto 0);
signal offsetctrlin_in : std_logic_vector(5 downto 0);
signal dqsupdateen_in : std_logic;

signal dqs_delay_int : integer := 0;
signal tmp_dqsbusout : std_logic;

signal dqs_ctrl_latches_ena : std_logic := '1';
signal combout_tmp_sig      : std_logic := '0';
signal dqsbusout_tmp_sig    : std_logic := '0';

begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (oe_ipd, oe, tipd_oe);
        VitalWireDelay (padio_ipd, padio, tipd_padio);
        VitalWireDelay (delayctrlin_in(5), delayctrlin(5), tipd_delayctrlin(5));
        VitalWireDelay (delayctrlin_in(4), delayctrlin(4), tipd_delayctrlin(4));
        VitalWireDelay (delayctrlin_in(3), delayctrlin(3), tipd_delayctrlin(3));
        VitalWireDelay (delayctrlin_in(2), delayctrlin(2), tipd_delayctrlin(2));
        VitalWireDelay (delayctrlin_in(1), delayctrlin(1), tipd_delayctrlin(1));
        VitalWireDelay (delayctrlin_in(0), delayctrlin(0), tipd_delayctrlin(0));
        VitalWireDelay (dqsupdateen_in, dqsupdateen, tipd_dqsupdateen);
        VitalWireDelay (offsetctrlin_in(5), offsetctrlin(5), tipd_offsetctrlin(5));
        VitalWireDelay (offsetctrlin_in(4), offsetctrlin(4), tipd_offsetctrlin(4));
        VitalWireDelay (offsetctrlin_in(3), offsetctrlin(3), tipd_offsetctrlin(3));
        VitalWireDelay (offsetctrlin_in(2), offsetctrlin(2), tipd_offsetctrlin(2));
        VitalWireDelay (offsetctrlin_in(1), offsetctrlin(1), tipd_offsetctrlin(1));
        VitalWireDelay (offsetctrlin_in(0), offsetctrlin(0), tipd_offsetctrlin(0));
    end block;

    dqs_ctrl_latches_ena <= '1' when dqs_ctrl_latches_enable = "false" ELSE 
                            dqsupdateen_in when dqs_edge_detect_enable = "false"  ELSE
                            (not (combout_tmp_sig xor tmp_dqsbusout) and dqsupdateen_in);

    process(delayctrlin_in, offsetctrlin_in, dqs_ctrl_latches_ena)
        variable tmp_delayctrl  : integer := 0;
        variable tmp_offsetctrl : integer := 0;
    begin
        if ((dqs_delay_buffer_mode = "high") AND (delayctrlin_in(5) = '1')) THEN        
            tmp_delayctrl  := 31;
        else 
            tmp_delayctrl  := alt_conv_integer(delayctrlin_in);
        end if;
        
        if (dqs_offsetctrl_enable = "true") then
            if ((dqs_delay_buffer_mode = "high") AND (offsetctrlin_in(5) = '1')) THEN        
                tmp_offsetctrl := 31;
            else 
                tmp_offsetctrl := alt_conv_integer(offsetctrlin_in);
            end if;
        else 
            tmp_offsetctrl := 0;
        end if;
             
        if (dqs_ctrl_latches_ena = '1') THEN
            dqs_delay_int <= sim_dqs_intrinsic_delay + sim_dqs_delay_increment*tmp_delayctrl + sim_dqs_offset_increment*tmp_offsetctrl;
        end if;
            
        if ((dqs_delay_buffer_mode = "high") AND (delayctrlin_in(5) = '1')) THEN
            assert false report "DELAYCTRLIN of DQS I/O exceeds 5-bit range in high-frequency mode" severity warning;
        end if;       
        if ((dqs_delay_buffer_mode = "high") AND (offsetctrlin_in(5) = '1')) THEN
            assert false report "OFFSETCTRLIN of DQS I/O exceeds 5-bit range in high-frequency mode" severity warning;
        end if;       
    end process;

    VITAL: process(padio_ipd, datain_ipd, oe_ipd, regin, ddioregin, tmp_dqsbusout)
        variable combout_VitalGlitchData : VitalGlitchDataType;
        variable dqsbusout_VitalGlitchData : VitalGlitchDataType;
        variable padio_VitalGlitchData : VitalGlitchDataType;
        variable regout_VitalGlitchData : VitalGlitchDataType;
        variable ddioregout_VitalGlitchData : VitalGlitchDataType;
          
        variable tmp_combout, tmp_padio : std_logic;
        variable prev_value : std_logic := 'H';
           
        variable dqsbusout_tmp   : std_logic;
        variable combout_delay   : VitalDelayType01 := (0 ps, 0 ps);
        variable init : boolean := true;
            
        begin
            
        if (init) then
            combout_delay := tpd_padio_combout;
            init := false;
        end if;
                      
        if (bus_hold = "true" ) then
            if ( operation_mode = "input") then
                if ( padio_ipd = 'Z') then
                    tmp_combout := to_x01z(prev_value);
                else
                    if ( padio_ipd = '1') then
                        prev_value := 'H';
                    elsif ( padio_ipd = '0') then
                        prev_value := 'L';
                    else
                        prev_value := 'W';
                    end if;
                    tmp_combout := to_x01z(padio_ipd);
                end if;
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
                        prev_value := 'W';
                    end if;
                    tmp_padio := prev_value;
                else
                    tmp_padio := 'X';
                    prev_value := 'W';
                end if; -- end oe_in
                
                if ( operation_mode = "bidir") then
                    tmp_combout := to_x01z(padio_ipd);
                else
                    tmp_combout := 'Z';
                end if;
            end if;
                
            if ( now <= 1 ps AND prev_value = 'W' ) then     --hack for autotest to pass
                    prev_value := 'L';
            end if;

        else    -- bus_hold is false
            if ( operation_mode = "input") then
                tmp_combout := padio_ipd;
                tmp_padio := 'Z';
            elsif (operation_mode = "output" or operation_mode = "bidir" ) then
                if ( operation_mode  = "bidir") then
                    tmp_combout := padio_ipd;
                else
                    tmp_combout := 'Z';
                end if;
        
                if ( oe_ipd = '1') then
                    if ( open_drain_output = "true" ) then
                        if (datain_ipd = '0') then
                            tmp_padio := '0';
                        elsif (datain_ipd = 'X') then
                            tmp_padio := 'X';
                        else
                            tmp_padio := 'Z';
                        end if;
                    else
                        tmp_padio := datain_ipd;
                    end if;
                elsif ( oe_ipd = '0' ) then
                    tmp_padio := 'Z';
                else
                    tmp_padio := 'X';
                end if;
            end if;
        end if; -- end bus_hold

		tmp_dqsbusout <= transport tmp_combout after (dqs_delay_int * 1 ps);

        if (gated_dqs = "true") then
            dqsbusout_tmp := tmp_dqsbusout AND regin;
        else
            dqsbusout_tmp := tmp_dqsbusout;
        end if;

        -- for dqs delay ctrl latches enable
        dqsbusout_tmp_sig <= dqsbusout_tmp;
        combout_tmp_sig <= tmp_combout;

    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
        OutSignal => combout,
        OutSignalName => "combout",
        OutTemp => tmp_combout,
        Paths => (1 => (padio_ipd'last_event, combout_delay, TRUE)),
        GlitchData => combout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

    VitalPathDelay01 (
        OutSignal => dqsbusout,
        OutSignalName => "dqsbusout",
        OutTemp => dqsbusout_tmp,
        Paths => (1 => (tmp_dqsbusout'last_event, tpd_padio_dqsbusout, TRUE),
                  2 => (regin'last_event, tpd_regin_dqsbusout, gated_dqs = "true")),
        GlitchData => dqsbusout_VitalGlitchData,
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

    VitalPathDelay01 (
        OutSignal => regout,
        OutSignalName => "regout",
        OutTemp => regin,
        Paths => (1 => (regin'last_event, tpd_regin_regout, TRUE)),
        GlitchData => regout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

    VitalPathDelay01 (
        OutSignal => ddioregout,
        OutSignalName => "ddioregout",
        OutTemp => ddioregin,
        Paths => (1 => (ddioregin'last_event, tpd_ddioregin_ddioregout, TRUE)),
        GlitchData => ddioregout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

    end process;

end behave;

--
-- STRATIXII_IO_REGISTER
--

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

entity stratixii_io_register is
    generic (
        async_reset : string := "none";
        sync_reset : string := "none";
        power_up : string := "low";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
        tpd_areset_regout_posedge		: VitalDelayType01 := DefPropDelay01;
        tipd_clk  			: VitalDelayType01 := DefPropDelay01;
        tipd_datain  			: VitalDelayType01 := DefPropDelay01;
        tipd_ena  		: VitalDelayType01 := DefPropDelay01; 
        tipd_areset 			: VitalDelayType01 := DefPropDelay01; 
        tipd_sreset 			: VitalDelayType01 := DefPropDelay01
        );

    port (
        clk :in std_logic := '0';
        datain  : in std_logic := '0';
        ena     : in std_logic := '1';
        sreset : in std_logic := '0';
        areset : in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic
        );
    attribute VITAL_LEVEL0 of stratixii_io_register : entity is TRUE;
end stratixii_io_register;
        
architecture vital_io_reg of stratixii_io_register is
    attribute VITAL_LEVEL0 of vital_io_reg : architecture is TRUE;
    signal datain_ipd, ena_ipd, sreset_ipd : std_logic;
    signal clk_ipd, areset_ipd : std_logic;
begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (sreset_ipd, sreset, tipd_sreset);
        VitalWireDelay (areset_ipd, areset, tipd_areset);
    end block;

    VITALtiming : process(clk_ipd, datain_ipd, ena_ipd, sreset_ipd, areset_ipd, devclrn, devpor)
    
    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable Tviol_sreset_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sreset_clk : VitalTimingDataType := VitalTimingDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    
    variable iregout : std_logic;
    variable idata : std_logic := '0';
    variable tmp_regout : std_logic;
    variable tmp_reset : std_logic := '0';
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';
    
    begin
    
        if (now = 0 ns) then
            if (power_up = "low") then
                iregout := '0';
            elsif (power_up = "high") then
                iregout := '1';
            end if;
        end if;
        
        if ( async_reset /= "none") then
            tmp_reset := areset_ipd; -- this is used to enable timing check.
        end if;
    
        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
    
        VitalSetupHoldCheck (
            Violation       => Tviol_datain_clk,
            TimingData      => TimingData_datain_clk,
            TestSignal      => datain_ipd,
            TestSignalName  => "DATAIN",
            RefSignal       => clk_ipd,
            RefSignalName   => "CLK",
            SetupHigh       => tsetup_datain_clk_noedge_posedge,
            SetupLow        => tsetup_datain_clk_noedge_posedge,
            HoldHigh        => thold_datain_clk_noedge_posedge,
            HoldLow         => thold_datain_clk_noedge_posedge,
            CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & "/LCELL",
            XOn             => XOnChecks,
            MsgOn           => MsgOnChecks );
    
        VitalSetupHoldCheck (
            Violation       => Tviol_ena_clk,
            TimingData      => TimingData_ena_clk,
            TestSignal      => ena_ipd,
            TestSignalName  => "ENA",
            RefSignal       => clk_ipd,
            RefSignalName   => "CLK",
            SetupHigh       => tsetup_ena_clk_noedge_posedge,
            SetupLow        => tsetup_ena_clk_noedge_posedge,
            HoldHigh        => thold_ena_clk_noedge_posedge,
            HoldLow         => thold_ena_clk_noedge_posedge,
            CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & "/LCELL",
            XOn             => XOnChecks,
            MsgOn           => MsgOnChecks );
    
        VitalSetupHoldCheck (
                Violation       => Tviol_sreset_clk,
                TimingData      => TimingData_sreset_clk,
                TestSignal      => sreset_ipd,
                TestSignalName  => "SRESET",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sreset_clk_noedge_posedge,
                SetupLow        => tsetup_sreset_clk_noedge_posedge,
                HoldHigh        => thold_sreset_clk_noedge_posedge,
                HoldLow         => thold_sreset_clk_noedge_posedge,
                CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        end if;
    
        violation := Tviol_datain_clk or Tviol_ena_clk or Tviol_sreset_clk;
    
        if (devpor = '0') then
        	if (power_up = "low") then
        		iregout := '0';
        	elsif (power_up = "high") then
        		iregout := '1';
        	end if;
        elsif (devclrn = '0') then
        	iregout := '0';
        elsif (async_reset = "clear" and areset_ipd = '1') then
        	iregout := '0';
        elsif ( async_reset = "preset" and areset_ipd = '1') then
        	iregout := '1';
        elsif (violation = 'X') then
        	iregout := 'X';
        elsif (ena_ipd = '1' and clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0') then
        	if (sync_reset = "clear" and sreset_ipd = '1' ) then
        		iregout := '0';
        	elsif (sync_reset = "preset" and sreset_ipd = '1' ) then
        		iregout := '1';
        	else
        		iregout := to_x01z(datain_ipd);
        	end if;
        end if;
        
        tmp_regout := iregout;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => tmp_regout,
            Paths => (0 => (areset_ipd'last_event, tpd_areset_regout_posedge, async_reset /= "none"),
            		 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    end process;
end vital_io_reg;	


--
-- STRATIXII_IO_LATCH
--

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

entity stratixii_io_latch is
    generic (
        async_reset : string := "none";
        sync_reset : string := "none";
        power_up : string := "low";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
        tpd_areset_regout_posedge		: VitalDelayType01 := DefPropDelay01;
        tipd_clk  			: VitalDelayType01 := DefPropDelay01;
        tipd_datain  			: VitalDelayType01 := DefPropDelay01;
        tipd_ena  		: VitalDelayType01 := DefPropDelay01; 
        tipd_areset 			: VitalDelayType01 := DefPropDelay01; 
        tipd_sreset 			: VitalDelayType01 := DefPropDelay01
        );

    port (
        clk :in std_logic := '0';
        datain  : in std_logic := '0';
        ena     : in std_logic := '1';
        sreset : in std_logic := '0';
        areset : in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic
        );
    attribute VITAL_LEVEL0 of stratixii_io_latch : entity is TRUE;
end stratixii_io_latch;
        
architecture vital_io_latch of stratixii_io_latch is
    attribute VITAL_LEVEL0 of vital_io_latch : architecture is TRUE;
    signal datain_ipd, ena_ipd, sreset_ipd : std_logic;
    signal clk_ipd, areset_ipd : std_logic;
begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (sreset_ipd, sreset, tipd_sreset);
        VitalWireDelay (areset_ipd, areset, tipd_areset);
    end block;

    VITALtiming : process(clk_ipd, datain_ipd, ena_ipd, sreset_ipd, areset_ipd, devclrn, devpor)
    
    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable Tviol_sreset_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sreset_clk : VitalTimingDataType := VitalTimingDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    
    variable iregout : std_logic;
    variable idata : std_logic := '0';
    variable tmp_regout : std_logic;
    variable tmp_reset : std_logic := '0';
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';
    
    begin
    
        if (now = 0 ns) then
            if (power_up = "low") then
                iregout := '0';
            elsif (power_up = "high") then
                iregout := '1';
            end if;
        end if;
        
        if ( async_reset /= "none") then
            tmp_reset := areset_ipd; -- this is used to enable timing check.
        end if;
    
        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
    
        VitalSetupHoldCheck (
            Violation       => Tviol_datain_clk,
            TimingData      => TimingData_datain_clk,
            TestSignal      => datain_ipd,
            TestSignalName  => "DATAIN",
            RefSignal       => clk_ipd,
            RefSignalName   => "CLK",
            SetupHigh       => tsetup_datain_clk_noedge_posedge,
            SetupLow        => tsetup_datain_clk_noedge_posedge,
            HoldHigh        => thold_datain_clk_noedge_posedge,
            HoldLow         => thold_datain_clk_noedge_posedge,
            CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & "/LCELL",
            XOn             => XOnChecks,
            MsgOn           => MsgOnChecks );
    
        VitalSetupHoldCheck (
            Violation       => Tviol_ena_clk,
            TimingData      => TimingData_ena_clk,
            TestSignal      => ena_ipd,
            TestSignalName  => "ENA",
            RefSignal       => clk_ipd,
            RefSignalName   => "CLK",
            SetupHigh       => tsetup_ena_clk_noedge_posedge,
            SetupLow        => tsetup_ena_clk_noedge_posedge,
            HoldHigh        => thold_ena_clk_noedge_posedge,
            HoldLow         => thold_ena_clk_noedge_posedge,
            CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & "/LCELL",
            XOn             => XOnChecks,
            MsgOn           => MsgOnChecks );
    
        VitalSetupHoldCheck (
                Violation       => Tviol_sreset_clk,
                TimingData      => TimingData_sreset_clk,
                TestSignal      => sreset_ipd,
                TestSignalName  => "SRESET",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sreset_clk_noedge_posedge,
                SetupLow        => tsetup_sreset_clk_noedge_posedge,
                HoldHigh        => thold_sreset_clk_noedge_posedge,
                HoldLow         => thold_sreset_clk_noedge_posedge,
                CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        end if;
    
        violation := Tviol_datain_clk or Tviol_ena_clk or Tviol_sreset_clk;
    
        if (devpor = '0') then
        	if (power_up = "low") then
        		iregout := '0';
        	elsif (power_up = "high") then
        		iregout := '1';
        	end if;
        elsif (devclrn = '0') then
        	iregout := '0';
        elsif (async_reset = "clear" and areset_ipd = '1') then
        	iregout := '0';
        elsif ( async_reset = "preset" and areset_ipd = '1') then
        	iregout := '1';
        elsif (violation = 'X') then
        	iregout := 'X';
        elsif (ena_ipd = '1' and clk_ipd = '1') then
        	if (sync_reset = "clear" and sreset_ipd = '1' ) then
        		iregout := '0';
        	elsif (sync_reset = "preset" and sreset_ipd = '1' ) then
        		iregout := '1';
        	else
        		iregout := to_x01z(datain_ipd);
        	end if;
        end if;
        
        tmp_regout := iregout;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => tmp_regout,
            Paths => (0 => (areset_ipd'last_event, tpd_areset_regout_posedge, async_reset /= "none"),
            		 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    end process;
end vital_io_latch;	

--
-- STRATIXII_IO
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
use work.stratixii_asynch_io;
use work.stratixii_io_register;
use work.stratixii_io_latch;
use work.stratixii_mux21;
use work.stratixii_and1;

entity  stratixii_io is
    generic (
        operation_mode : string := "input";
        ddio_mode : string := "none";
        open_drain_output : string := "false";
        bus_hold : string := "false";
        output_register_mode : string := "none";
        output_async_reset : string := "none";
        output_power_up : string := "low";
        output_sync_reset : string := "none";
        tie_off_output_clock_enable : string := "false";
        oe_register_mode : string := "none";
        oe_async_reset : string := "none";
        oe_power_up : string := "low";
        oe_sync_reset : string := "none";
        tie_off_oe_clock_enable : string := "false";
        input_register_mode : string := "none";
        input_async_reset : string := "none";
        input_power_up : string := "low";
        input_sync_reset : string := "none";
        extend_oe_disable : string := "false";
        dqs_input_frequency : string := "10000 ps";
        dqs_out_mode : string := "none";
        dqs_delay_buffer_mode : string := "low";
        dqs_phase_shift : integer := 0;
        inclk_input : string := "normal";
        ddioinclk_input : string := "negated_inclk";
        dqs_offsetctrl_enable : string := "false";
        dqs_ctrl_latches_enable : string := "false";
        dqs_edge_detect_enable : string := "false";
        gated_dqs : string := "false";
        sim_dqs_intrinsic_delay : integer := 0;
        sim_dqs_delay_increment : integer := 0;
        sim_dqs_offset_increment : integer := 0;
        lpm_type : string := "stratixii_io"
        );
    port (
        datain          : in std_logic := '0';
        ddiodatain      : in std_logic := '0';
        oe              : in std_logic := '1';
        outclk          : in std_logic := '0';
        outclkena       : in std_logic := '1';
        inclk           : in std_logic := '0';
        inclkena        : in std_logic := '1';
        areset          : in std_logic := '0';
        sreset          : in std_logic := '0';
        ddioinclk       : in std_logic := '0';
        delayctrlin     : in std_logic_vector(5 downto 0) := "000000";
        offsetctrlin    : in std_logic_vector(5 downto 0) := "000000";
        dqsupdateen     : in std_logic := '0';
        linkin		  : in std_logic := '0';
        terminationcontrol : in std_logic_vector(13 downto 0) := "00000000000000";      
        devclrn         : in std_logic := '1';
        devpor          : in std_logic := '1';
        devoe           : in std_logic := '0';
        padio           : inout std_logic;
        combout         : out std_logic;
        regout          : out std_logic;
        ddioregout      : out std_logic;
        dqsbusout		  : out std_logic;
        linkout		  : out std_logic
        );
end stratixii_io;

architecture structure of stratixii_io is
    component stratixii_asynch_io
        generic(
                operation_mode : string := "input";
                open_drain_output : string := "false";
                bus_hold : string := "false";
                dqs_input_frequency      : string := "10000 ps";
                dqs_out_mode             : string := "none";
                dqs_delay_buffer_mode    : string := "low";
                dqs_phase_shift          : integer := 0;
                dqs_offsetctrl_enable    : string := "false";
                dqs_ctrl_latches_enable  : string := "false";
                dqs_edge_detect_enable   : string := "false";  
                gated_dqs                : string := "false";
                sim_dqs_intrinsic_delay  : integer := 0;
                sim_dqs_delay_increment  : integer := 0;
                sim_dqs_offset_increment : integer := 0);
        port(
                datain : in  STD_LOGIC := '0';
                oe         : in  STD_LOGIC := '1';
                regin  : in std_logic;
                ddioregin  : in std_logic;
                padio  : inout STD_LOGIC;
                delayctrlin  : in std_logic_vector(5 downto 0);
                offsetctrlin : in std_logic_vector(5 downto 0);
                dqsupdateen  : in std_logic;
                dqsbusout    : out std_logic;
                combout: out STD_LOGIC;
                regout : out STD_LOGIC;
                ddioregout : out STD_LOGIC);
    end component;

    component stratixii_io_register
        generic (
            async_reset : string := "none";
            sync_reset : string := "none";
            power_up : string := "low";
            
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks;
            InstancePath: STRING := "*";
            
            tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
            tpd_areset_regout_posedge		: VitalDelayType01 := DefPropDelay01;
            
            tipd_clk  			: VitalDelayType01 := DefPropDelay01;
            tipd_datain  			: VitalDelayType01 := DefPropDelay01;
            tipd_ena  		: VitalDelayType01 := DefPropDelay01; 
            tipd_areset 			: VitalDelayType01 := DefPropDelay01; 
            tipd_sreset 			: VitalDelayType01 := DefPropDelay01
            );
        port (
            clk :in std_logic := '0';
            datain  : in std_logic := '0';
            ena     : in std_logic := '1';
            sreset : in std_logic := '0';
            areset : in std_logic := '0';
            devclrn   : in std_logic := '1';
            devpor    : in std_logic := '1';
            regout    : out std_logic
            );
    end component;

    component stratixii_io_latch
        generic (
            async_reset : string := "none";
            sync_reset : string := "none";
            power_up : string := "low";
            
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks;
            InstancePath: STRING := "*";
            
            tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
            tpd_areset_regout_posedge		: VitalDelayType01 := DefPropDelay01;
            
            tipd_clk  			: VitalDelayType01 := DefPropDelay01;
            tipd_datain  			: VitalDelayType01 := DefPropDelay01;
            tipd_ena  		: VitalDelayType01 := DefPropDelay01; 
            tipd_areset 			: VitalDelayType01 := DefPropDelay01; 
            tipd_sreset 			: VitalDelayType01 := DefPropDelay01
            );
        port (
            clk :in std_logic := '0';
            datain  : in std_logic := '0';
            ena     : in std_logic := '1';
            sreset : in std_logic := '0';
            areset : in std_logic := '0';
            devclrn   : in std_logic := '1';
            devpor    : in std_logic := '1';
            regout    : out std_logic
            );
    end component;

    component stratixii_mux21
        generic (
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_A_MO : VitalDelayType01 := DefPropDelay01;
            tpd_B_MO : VitalDelayType01 := DefPropDelay01;
            tpd_S_MO : VitalDelayType01 := DefPropDelay01;
            tipd_A   : VitalDelayType01 := DefPropDelay01;
            tipd_B   : VitalDelayType01 := DefPropDelay01;
            tipd_S   : VitalDelayType01 := DefPropDelay01
            );

        port ( 
            A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
            );
    end component;

    component stratixii_and1
       generic (
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_IN1_Y : VitalDelayType01 := DefPropDelay01;
            tipd_IN1  : VitalDelayType01 := DefPropDelay01
            );

        port (
            Y    :  out   STD_LOGIC;
            IN1  :  in    STD_LOGIC
            );
    end component;

    signal  oe_out : std_logic;
    
    signal  in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out: std_logic;
    signal  oe_reg_out, oe_pulse_reg_out : std_logic;
    signal  out_reg_out, out_ddio_reg_out: std_logic;
    
    
    signal  tmp_datain : std_logic;
    signal  not_inclk, not_outclk : std_logic;
    
    -- for DDIO
    signal ddio_data : std_logic;
    signal outclk_delayed : std_logic;
    
    signal out_clk_ena, oe_clk_ena : std_logic;

    begin


    not_inclk <= (ddioinclk) WHEN (ddioinclk_input = "dqsb_bus") ELSE (not inclk);
    
    not_outclk <= not outclk;

    out_clk_ena <= '1' WHEN tie_off_output_clock_enable = "true" ELSE outclkena;
    oe_clk_ena <= '1' WHEN tie_off_oe_clock_enable = "true" ELSE outclkena;
    
    --input register
    in_reg : stratixii_io_register
    	generic map ( ASYNC_RESET => input_async_reset,
    				  SYNC_RESET => input_sync_reset,
    				  POWER_UP => input_power_up)
    	port map ( regout  => in_reg_out,
                   clk => inclk,
    			   ena => inclkena,
    			   datain => padio, 
    			   areset => areset,
    			   sreset => sreset,
    			   devpor => devpor,
    			   devclrn => devclrn);

    -- in_ddio0_reg
    in_ddio0_reg : stratixii_io_register
    	generic map ( ASYNC_RESET => input_async_reset,
    				  SYNC_RESET => input_sync_reset,
    				  POWER_UP => input_power_up)
    	port map (regout => in_ddio0_reg_out,
                  clk => not_inclk,
    			  ena => inclkena,
    			  datain => padio, 
    			  areset => areset,
    			  sreset => sreset,
    			  devpor => devpor,
    			  devclrn => devclrn);
    -- in_ddio1_latch
    in_ddio1_reg : stratixii_io_latch
    	generic map ( ASYNC_RESET => input_async_reset,
    				  SYNC_RESET => "none",  -- this register does not have sync_reset
    				  POWER_UP => input_power_up)
    	port map (regout  => in_ddio1_reg_out,
                  clk => inclk,
    			  ena => inclkena,
    			  datain => in_ddio0_reg_out, 
    			  areset => areset,
    			  devpor => devpor,
    			  devclrn => devclrn);
          
    -- out_reg
    out_reg : stratixii_io_register
    	generic map ( ASYNC_RESET => output_async_reset,
    				  SYNC_RESET => output_sync_reset,
    				  POWER_UP => output_power_up)
    	port map (regout  => out_reg_out,
                  clk => outclk,
    			  ena => out_clk_ena,
    			  datain => datain, 
    			  areset => areset,
    			  sreset => sreset,
    			  devpor => devpor,
    			  devclrn => devclrn);

    -- out ddio reg
    out_ddio_reg : stratixii_io_register
    	generic map ( ASYNC_RESET => output_async_reset,
    				  SYNC_RESET => output_sync_reset,
    				  POWER_UP => output_power_up)
    	port map (regout  => out_ddio_reg_out,
                  clk => outclk,
    			  ena => out_clk_ena,
    			  datain => ddiodatain, 
    			  areset => areset,
    			  sreset => sreset,
    			  devpor => devpor,
    			  devclrn => devclrn);

    -- oe reg
    oe_reg : stratixii_io_register
    	generic map (ASYNC_RESET => oe_async_reset,
    				 SYNC_RESET => oe_sync_reset,
    				 POWER_UP => oe_power_up)
    	port map (regout  => oe_reg_out,
                  clk => outclk,
    			  ena => oe_clk_ena,
    			  datain => oe, 
    			  areset => areset,
    			  sreset => sreset,
    			  devpor => devpor,
    			  devclrn => devclrn);
    
    -- oe_pulse reg
    oe_pulse_reg : stratixii_io_register
    	generic map (ASYNC_RESET => oe_async_reset,
    				 SYNC_RESET => oe_sync_reset,
    				 POWER_UP => oe_power_up)
    	port map (regout  => oe_pulse_reg_out,
                  clk => not_outclk,
    			  ena => oe_clk_ena,
    			  datain => oe_reg_out, 
    			  areset => areset,
    			  sreset => sreset,
    			  devpor => devpor,
    			  devclrn => devclrn);


    oe_out <= (oe_pulse_reg_out and oe_reg_out) WHEN (extend_oe_disable = "true") ELSE oe_reg_out WHEN (oe_register_mode = "register") ELSE oe;

    sel_delaybuf  : stratixii_and1
        port map (Y => outclk_delayed,
                  IN1 => outclk);

    ddio_data_mux : stratixii_mux21
        port map (MO => ddio_data,
                  A => out_ddio_reg_out,
                  B => out_reg_out,
                  S => outclk_delayed);

    tmp_datain <= ddio_data WHEN (ddio_mode = "output" or ddio_mode = "bidir") ELSE
                  out_reg_out WHEN (output_register_mode = "register") ELSE
                  datain;


    -- timing info in case output and/or input are not registered.
    inst1 : stratixii_asynch_io
        generic map ( OPERATION_MODE => operation_mode,
                      OPEN_DRAIN_OUTPUT => open_drain_output,
                      BUS_HOLD => bus_hold,
                      dqs_input_frequency => dqs_input_frequency,
                      dqs_out_mode => dqs_out_mode,
                      dqs_delay_buffer_mode => dqs_delay_buffer_mode,
                      dqs_phase_shift => dqs_phase_shift,
                      dqs_offsetctrl_enable => dqs_offsetctrl_enable,
                      dqs_ctrl_latches_enable => dqs_ctrl_latches_enable,
                      dqs_edge_detect_enable => dqs_edge_detect_enable,
                      gated_dqs => gated_dqs,    
                      sim_dqs_intrinsic_delay => sim_dqs_intrinsic_delay,
                      sim_dqs_delay_increment => sim_dqs_delay_increment,
                      sim_dqs_offset_increment => sim_dqs_offset_increment)
        port map( datain => tmp_datain,
                  oe => oe_out,
                  regin => in_reg_out,
                  ddioregin => in_ddio1_reg_out,
                  padio => padio,
                  delayctrlin  => delayctrlin,
                  offsetctrlin => offsetctrlin,
                  dqsupdateen  => dqsupdateen,
                  dqsbusout    => dqsbusout,
                  combout => combout,
                  regout => regout,
                  ddioregout => ddioregout);


end structure;
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixii_m_cntr
--
-- Description : Timing simulation model for the M counter. M is the loop 
--               feedback counter of the StratixII PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY stratixii_m_cntr is
    PORT(  clk           : IN std_logic;
            reset         : IN std_logic := '0';
            cout          : OUT std_logic;
            initial_value : IN integer := 1;
            modulus       : IN integer := 1;
            time_delay    : IN integer := 0
        );
END stratixii_m_cntr;

ARCHITECTURE behave of stratixii_m_cntr is
begin

    process (clk, reset)
    variable count : integer := 1;
    variable first_rising_edge : boolean := true;
    variable tmp_cout : std_logic;
    begin
        if (reset = '1') then
            count := 1;
            tmp_cout := '0';
            first_rising_edge := true;
        elsif (clk'event) then
            if (clk = '1' and first_rising_edge) then
                first_rising_edge := false;
                tmp_cout := clk;
            elsif (not first_rising_edge) then
                if (count < modulus) then
                    count := count + 1;
                else
                    count := 1;
                    tmp_cout := not tmp_cout;
                end if;
            end if;
        end if;
        cout <= transport tmp_cout after time_delay * 1 ps;
    end process;
end behave;

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixii_n_cntr
--
-- Description : Timing simulation model for the N counter. N is the
--               input counter of the StratixII PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY stratixii_n_cntr is
    PORT(  clk           : IN std_logic;
            reset         : IN std_logic := '0';
            cout          : OUT std_logic;
            initial_value : IN integer := 1;
            modulus       : IN integer := 1;
            time_delay    : IN integer := 0
        );
END stratixii_n_cntr;

ARCHITECTURE behave of stratixii_n_cntr is
begin

    process (clk, reset)
    variable count : integer := 1;
    variable first_rising_edge : boolean := true;
    variable tmp_cout : std_logic;
    variable clk_last_valid_value : std_logic;
    begin
        if (reset = '1') then
            count := 1;
            tmp_cout := '0';
            first_rising_edge := true;
        elsif (clk'event) then
            if (clk = 'X') then
                ASSERT FALSE REPORT "Invalid transition to 'X' detected on PLL input clk. This edge will be ignored." severity warning;
            elsif (clk = '1' and first_rising_edge) then
                first_rising_edge := false;
                tmp_cout := clk;
            elsif (not first_rising_edge) then
                if (count < modulus) then
                    count := count + 1;
                else
                    count := 1;
                    tmp_cout := not tmp_cout;
                end if;
            end if;
        end if;
        if (clk /= 'X') then
            clk_last_valid_value := clk;
        end if;
        cout <= transport tmp_cout after time_delay * 1 ps;
    end process;
end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixii_scale_cntr
--
-- Description : Timing simulation model for the output scale-down counters.
--               This is a common model for the C0, C1, C2, C3, C4 and C5
--               output counters of the StratixII PLL.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY stratixii_scale_cntr is
    PORT(   clk            : IN std_logic;
            reset          : IN std_logic := '0';
            initial        : IN integer := 1;
            high           : IN integer := 1;
            low            : IN integer := 1;
            mode           : IN string := "bypass";
            ph_tap         : IN integer := 0;
            cout           : OUT std_logic
        );
END stratixii_scale_cntr;

ARCHITECTURE behave of stratixii_scale_cntr is
begin
    process (clk, reset)
    variable tmp_cout : std_logic := '0';
    variable count : integer := 1;
    variable output_shift_count : integer := 1;
    variable first_rising_edge : boolean := false;
    begin
        if (reset = '1') then
            count := 1;
            output_shift_count := 1;
            tmp_cout := '0';
            first_rising_edge := false;
        elsif (clk'event) then
            if (mode = "   off") then
                tmp_cout := '0';
            elsif (mode = "bypass") then
                tmp_cout := clk;
                first_rising_edge := true;
            elsif (not first_rising_edge) then
                if (clk = '1') then
                    if (output_shift_count = initial) then
                        tmp_cout := clk;
                        first_rising_edge := true;
                    else
                        output_shift_count := output_shift_count + 1;
                    end if;
                end if;
            elsif (output_shift_count < initial) then
                if (clk = '1') then
                    output_shift_count := output_shift_count + 1;
                end if;
            else
                count := count + 1;
                if (mode = "  even" and (count = (high*2) + 1)) then
                    tmp_cout := '0';
                elsif (mode = "   odd" and (count = high*2)) then
                    tmp_cout := '0';
                elsif (count = (high + low)*2 + 1) then
                    tmp_cout := '1';
                    count := 1;  -- reset count
                end if;
            end if;
        end if;
        cout <= transport tmp_cout;
    end process;

end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixii_pll_reg
--
-- Description : Simulation model for a simple DFF.
--               This is required for the generation of the bit slip-signals.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY stratixii_pll_reg is
    PORT(   clk : in std_logic;
            ena : in std_logic := '1';
            d : in std_logic;
            clrn : in std_logic := '1';
            prn : in std_logic := '1';
            q : out std_logic
        );
end stratixii_pll_reg;

ARCHITECTURE behave of stratixii_pll_reg is
begin
    process (clk, prn, clrn)
    variable q_reg : std_logic := '0';
    begin
        if (prn = '0') then
            q_reg := '1';
        elsif (clrn = '0') then
            q_reg := '0';
        elsif (clk'event and clk = '1' and (ena = '1')) then
            q_reg := D;
        end if;

        Q <= q_reg;
    end process;
end behave;
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixii_pll
--
-- Description : Timing simulation model for the StratixII PLL.
--               In the functional mode, it is also the model for the altpll
--               megafunction.
--
-- Limitations : Does not support Spread Spectrum and Bandwidth.
--
-- Outputs     : Up to 6 output clocks, each defined by its own set of
--               parameters. Locked output (active high) indicates when the
--               PLL locks. clkbad, clkloss and activeclock are used for
--               clock switchover to indicate which input clock has gone
--               bad, when the clock switchover initiates and which input
--               clock is being used as the reference, respectively.
--               scandataout is the data output of the serial scan chain.
--
--///////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE STD.TEXTIO.all;
USE work.stratixii_atom_pack.all;
USE work.stratixii_pllpack.all;
USE work.stratixii_m_cntr;
USE work.stratixii_n_cntr;
USE work.stratixii_scale_cntr;
USE work.stratixii_dffe;
USE work.stratixii_pll_reg;

ENTITY stratixii_pll is
    GENERIC (
        operation_mode              : string := "normal";
        pll_type                    : string := "auto";  -- EGPP/FAST/AUTO
        compensate_clock            : string := "clk0";
        feedback_source             : string := "clk0";
        qualify_conf_done           : string := "off";

        test_input_comp_delay       : integer := 0;
        test_feedback_comp_delay    : integer := 0;

        inclk0_input_frequency      : integer := 10000;
        inclk1_input_frequency      : integer := 10000;

        gate_lock_signal            : string := "no";
        gate_lock_counter           : integer := 1;
        self_reset_on_gated_loss_lock : string := "off";
        valid_lock_multiplier       : integer := 1;
        invalid_lock_multiplier     : integer := 5;
        sim_gate_lock_device_behavior : string := "off";

        switch_over_type            : string := "auto";
        switch_over_on_lossclk      : string := "off";
        switch_over_on_gated_lock   : string := "off";
        switch_over_counter         : integer := 1;
        enable_switch_over_counter  : string := "on";

        bandwidth                   : integer := 0;
        bandwidth_type              : string := "auto";
        down_spread                 : string := "0.0";
        spread_frequency            : integer := 0;

        clk0_output_frequency       : integer := 0;
        clk0_multiply_by            : integer := 1;
        clk0_divide_by              : integer := 1;
        clk0_phase_shift            : string := "0";
        clk0_duty_cycle             : integer := 50;

        clk1_output_frequency       : integer := 0;
        clk1_multiply_by            : integer := 1;
        clk1_divide_by              : integer := 1;
        clk1_phase_shift            : string := "0";
        clk1_duty_cycle             : integer := 50;

        clk2_output_frequency       : integer := 0;
        clk2_multiply_by            : integer := 1;
        clk2_divide_by              : integer := 1;
        clk2_phase_shift            : string := "0";
        clk2_duty_cycle             : integer := 50;

        clk3_output_frequency       : integer := 0;
        clk3_multiply_by            : integer := 1;
        clk3_divide_by              : integer := 1;
        clk3_phase_shift            : string := "0";
        clk3_duty_cycle             : integer := 50;

        clk4_output_frequency       : integer := 0;
        clk4_multiply_by            : integer := 1;
        clk4_divide_by              : integer := 1;
        clk4_phase_shift            : string := "0";
        clk4_duty_cycle             : integer := 50;

        clk5_output_frequency       : integer := 0;
        clk5_multiply_by            : integer := 1;
        clk5_divide_by              : integer := 1;
        clk5_phase_shift            : string := "0";
        clk5_duty_cycle             : integer := 50;

        pfd_min                     : integer := 0;
        pfd_max                     : integer := 0;
        vco_min                     : integer := 0;
        vco_max                     : integer := 0;
        vco_center                  : integer := 0;

        -- ADVANCED USER PARAMETERS
        m_initial                   : integer := 1;
        m                           : integer := 0;
        n                           : integer := 1;
        m2                          : integer := 1;
        n2                          : integer := 1;
        ss                          : integer := 0;

        c0_high                     : integer := 1;
        c0_low                      : integer := 1;
        c0_initial                  : integer := 1; 
        c0_mode                     : string := "bypass";
        c0_ph                       : integer := 0;

        c1_high                     : integer := 1;
        c1_low                      : integer := 1;
        c1_initial                  : integer := 1;
        c1_mode                     : string := "bypass";
        c1_ph                       : integer := 0;

        c2_high                     : integer := 1;
        c2_low                      : integer := 1;
        c2_initial                  : integer := 1;
        c2_mode                     : string := "bypass";
        c2_ph                       : integer := 0;

        c3_high                     : integer := 1;
        c3_low                      : integer := 1;
        c3_initial                  : integer := 1;
        c3_mode                     : string := "bypass";
        c3_ph                       : integer := 0;

        c4_high                     : integer := 1;
        c4_low                      : integer := 1;
        c4_initial                  : integer := 1;
        c4_mode                     : string := "bypass";
        c4_ph                       : integer := 0;
        
        c5_high                     : integer := 1;
        c5_low                      : integer := 1;
        c5_initial                  : integer := 1;
        c5_mode                     : string := "bypass";
        c5_ph                       : integer := 0;
        
        m_ph                        : integer := 0;
        
        clk0_counter                : string := "c0";
        clk1_counter                : string := "c1";
        clk2_counter                : string := "c2";
        clk3_counter                : string := "c3";
        clk4_counter                : string := "c4";
        clk5_counter                : string := "c5";
        
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
        c5_use_casc_in              : string := "off";
        
        m_test_source               : integer := 5;
        c0_test_source              : integer := 5;
        c1_test_source              : integer := 5;
        c2_test_source              : integer := 5;
        c3_test_source              : integer := 5;
        c4_test_source              : integer := 5;
        c5_test_source              : integer := 5;
        
        -- LVDS mode parameters
        enable0_counter             : string := "c0";
        enable1_counter             : string := "c1";
        sclkout0_phase_shift        : string := "0";
        sclkout1_phase_shift        : string := "0";
        
        charge_pump_current         : integer := 52;
        loop_filter_r               : string := " 1.000000";
        loop_filter_c               : integer := 16;
        common_rx_tx                : string := "off";
        use_vco_bypass              : string := "false";
        use_dc_coupling             : string := "false";
        
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        lpm_type                    : string := "stratixii_pll";

        -- Simulation only generics
        family_name                 : string  := "StratixII";
        
        clk0_use_even_counter_mode  : string := "off";
        clk1_use_even_counter_mode  : string := "off";
        clk2_use_even_counter_mode  : string := "off";
        clk3_use_even_counter_mode  : string := "off";
        clk4_use_even_counter_mode  : string := "off";
        clk5_use_even_counter_mode  : string := "off";
        
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
        clk5_use_even_counter_value : string := "off";
        
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        scan_chain_mif_file         : string := "";
        vco_post_scale              : integer := 1;

        -- VITAL generics
        XOn                         : Boolean := DefGlitchXOn;
        MsgOn                       : Boolean := DefGlitchMsgOn;
        MsgOnChecks                 : Boolean := DefMsgOnChecks;
        XOnChecks                   : Boolean := DefXOnChecks;
        TimingChecksOn              : Boolean := true;
        InstancePath                : STRING := "*";
        tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
        tipd_ena                    : VitalDelayType01 := DefPropDelay01;
        tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
        tipd_areset                 : VitalDelayType01 := DefPropDelay01;
        tipd_fbin                   : VitalDelayType01 := DefPropDelay01;
        tipd_scanclk                : VitalDelayType01 := DefPropDelay01;
        tipd_scanread               : VitalDelayType01 := DefPropDelay01;
        tipd_scandata               : VitalDelayType01 := DefPropDelay01;
        tipd_scanwrite              : VitalDelayType01 := DefPropDelay01;
        tipd_clkswitch              : VitalDelayType01 := DefPropDelay01;
        tsetup_scandata_scanclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_scandata_scanclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_scanread_scanclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_scanread_scanclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_scanwrite_scanclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_scanwrite_scanclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst
    );

    PORT
    (
        inclk                       : in std_logic_vector(1 downto 0);
        fbin                        : in std_logic := '0';
        ena                         : in std_logic := '1';
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        scanread                    : in std_logic := '0';
        scanwrite                   : in std_logic := '0';
        scandata                    : in std_logic := '0';
        scanclk                     : in std_logic := '0';
        testin                      : in std_logic_vector(3 downto 0) := "0000";
        clk                         : out std_logic_vector(5 downto 0);
        clkbad                      : out std_logic_vector(1 downto 0);
        activeclock                 : out std_logic;
        locked                      : out std_logic;
        clkloss                     : out std_logic;
        scandataout                 : out std_logic;
        scandone                    : out std_logic;
        testupout                   : out std_logic;
        testdownout                 : out std_logic;
        -- lvds specific ports
        enable0                     : out std_logic;
        enable1                     : out std_logic;
        sclkout                     : out std_logic_vector(1 downto 0)
    );
END stratixii_pll;

ARCHITECTURE vital_pll of stratixii_pll is

TYPE int_array is ARRAY(NATURAL RANGE <>) of integer;
TYPE str_array is ARRAY(NATURAL RANGE <>) of string(1 to 6);
TYPE str_array1 is ARRAY(NATURAL RANGE <>) of string(1 to 9);
TYPE std_logic_array is ARRAY(NATURAL RANGE <>) of std_logic;

-- internal advanced parameter signals
signal   i_vco_min      : integer;
signal   i_vco_max      : integer;
signal   i_vco_center   : integer;
signal   i_pfd_min      : integer;
signal   i_pfd_max      : integer;
signal   c_ph_val       : int_array(0 to 5) := (OTHERS => 0);
signal   c_high_val     : int_array(0 to 5) := (OTHERS => 1);
signal   c_low_val      : int_array(0 to 5) := (OTHERS => 1);
signal   c_initial_val  : int_array(0 to 5) := (OTHERS => 1);
signal   c_mode_val     : str_array(0 to 5);

-- old values
signal   c_high_val_old : int_array(0 to 5) := (OTHERS => 1);
signal   c_low_val_old  : int_array(0 to 5) := (OTHERS => 1);
signal   c_ph_val_old   : int_array(0 to 5) := (OTHERS => 0);
signal   c_mode_val_old : str_array(0 to 5);

-- hold registers
signal   c_high_val_hold : int_array(0 to 5) := (OTHERS => 1);
signal   c_low_val_hold  : int_array(0 to 5) := (OTHERS => 1);
signal   c_ph_val_hold   : int_array(0 to 5) := (OTHERS => 0);
signal   c_mode_val_hold : str_array(0 to 5);

-- temp registers
signal   sig_c_ph_val_tmp   : int_array(0 to 5) := (OTHERS => 0);
signal   sig_c_low_val_tmp  : int_array(0 to 5) := (OTHERS => 1);
signal   sig_c_hi_val_tmp  : int_array(0 to 5) := (OTHERS => 1);
signal   c_ph_val_orig  : int_array(0 to 5) := (OTHERS => 0);

--signal   i_clk5_counter         : string(1 to 2) := "c5";
--signal   i_clk4_counter         : string(1 to 2) := "c4";
--signal   i_clk3_counter         : string(1 to 2) := "c3";
--signal   i_clk2_counter         : string(1 to 2) := "c2";
--signal   i_clk1_counter         : string(1 to 2) := "c1";
--signal   i_clk0_counter         : string(1 to 2) := "c0";

signal   i_clk5_counter         : integer := 5;
signal   i_clk4_counter         : integer := 4;
signal   i_clk3_counter         : integer := 3;
signal   i_clk2_counter         : integer := 2;
signal   i_clk1_counter         : integer := 1;
signal   i_clk0_counter         : integer := 0;
signal   i_charge_pump_current  : integer;
signal   i_loop_filter_r        : integer;

-- end internal advanced parameter signals

-- CONSTANTS
CONSTANT GPP_SCAN_CHAIN : integer := 174;
CONSTANT FAST_SCAN_CHAIN : integer := 75;
CONSTANT GATE_LOCK_CYCLES : integer := 7;

CONSTANT cntrs : str_array(5 downto 0) := ("    C5", "    C4", "    C3", "    C2", "    C1", "    C0");
CONSTANT ss_cntrs : str_array(0 to 3) := ("     M", "    M2", "     N", "    N2");

CONSTANT loop_filter_c_arr : int_array(0 to 3) := (57, 16, 36, 5);
CONSTANT fpll_loop_filter_c_arr : int_array(0 to 3) := (18, 13, 8, 2);
CONSTANT charge_pump_curr_arr : int_array(0 to 15) := (6, 12, 30, 36, 52, 57, 72, 77, 92, 96, 110, 114, 127, 131, 144, 148);
CONSTANT loop_filter_r_arr : str_array1(0 to 39) := (" 1.000000", " 1.500000", " 2.000000", " 2.500000", " 3.000000", " 3.500000", " 4.000000", " 4.500000", " 5.000000", " 5.500000", " 6.000000", " 6.500000", " 7.000000", " 7.500000", " 8.000000", " 8.500000", " 9.000000", " 9.500000", "10.000000", "10.500000", "11.000000", "11.500000", "12.000000", "12.500000", "13.000000", "13.500000", "14.000000", "14.500000", "15.000000", "15.500000", "16.000000", "16.500000", "17.000000", "17.500000", "18.000000", "18.500000", "19.000000", "19.500000", "20.000000", "20.500000");

-- signals

signal vcc : std_logic := '1';

signal fbclk       : std_logic;
signal refclk      : std_logic;

signal c_clk : std_logic_array(0 to 5);
signal vco_out : std_logic_vector(7 downto 0) := (OTHERS => '0');
signal vco_tap : std_logic_vector(7 downto 0) := (OTHERS => '0');
signal vco_out_last_value : std_logic_vector(7 downto 0);
signal vco_tap_last_value : std_logic_vector(7 downto 0);

-- signals to assign values to counter params
signal m_val : int_array(0 to 1) := (OTHERS => 1);
signal n_val : int_array(0 to 1) := (OTHERS => 1);
signal m_ph_val : integer := 0;
signal m_initial_val : integer := m_initial;

signal m_mode_val : str_array(0 to 1) := (OTHERS => "      ");
signal n_mode_val : str_array(0 to 1) := (OTHERS => "      ");
signal lfc_val : integer := 0;
signal cp_curr_val : integer := 0;
signal lfr_val : string(1 to 9) := "         ";

-- old values
signal m_val_old : int_array(0 to 1) := (OTHERS => 1);
signal n_val_old : int_array(0 to 1) := (OTHERS => 1);
signal m_mode_val_old : str_array(0 to 1) := (OTHERS => "      ");
signal n_mode_val_old : str_array(0 to 1) := (OTHERS => "      ");
signal m_ph_val_old : integer := 0;
signal lfc_old : integer := 0;
signal cp_curr_old : integer := 0;
signal lfr_old : string(1 to 9) := "         ";
signal num_output_cntrs : integer := 6;

signal scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');

signal clk0_tmp : std_logic;
signal clk1_tmp : std_logic;
signal clk2_tmp : std_logic;
signal clk3_tmp : std_logic;
signal clk4_tmp : std_logic;
signal clk5_tmp : std_logic;
signal sclkout0_tmp : std_logic;
signal sclkout1_tmp : std_logic;

signal clkin : std_logic := '0';
signal gate_locked : std_logic := '0';
signal lock : std_logic := '0';
signal about_to_lock : boolean := false;
signal reconfig_err : boolean := false;

signal inclk_c0 : std_logic;
signal inclk_c1 : std_logic;
signal inclk_c2 : std_logic;
signal inclk_c3 : std_logic;
signal inclk_c4 : std_logic;
signal inclk_c5 : std_logic;
signal inclk_m : std_logic;
signal devpor : std_logic;
signal devclrn : std_logic;

signal inclk0_ipd : std_logic;
signal inclk1_ipd : std_logic;
signal ena_ipd : std_logic;
signal pfdena_ipd : std_logic;
signal areset_ipd : std_logic;
signal fbin_ipd : std_logic;
signal scanclk_ipd : std_logic;
signal scanread_ipd : std_logic;
signal scanwrite_ipd : std_logic;
signal scandata_ipd : std_logic;
signal clkswitch_ipd : std_logic;
-- registered signals
signal scanread_reg : std_logic := '0';
signal scanwrite_reg : std_logic := '0';
signal scanwrite_enabled : std_logic := '0';
signal gated_scanclk : std_logic := '1';

signal inclk_c0_dly1 : std_logic := '0';
signal inclk_c0_dly2 : std_logic := '0';
signal inclk_c0_dly3 : std_logic := '0';
signal inclk_c0_dly4 : std_logic := '0';
signal inclk_c0_dly5 : std_logic := '0';
signal inclk_c0_dly6 : std_logic := '0';
signal inclk_c1_dly1 : std_logic := '0';
signal inclk_c1_dly2 : std_logic := '0';
signal inclk_c1_dly3 : std_logic := '0';
signal inclk_c1_dly4 : std_logic := '0';
signal inclk_c1_dly5 : std_logic := '0';
signal inclk_c1_dly6 : std_logic := '0';


signal sig_offset : time := 0 ps;
signal sig_refclk_time : time := 0 ps;
signal sig_fbclk_period : time := 0 ps;
signal sig_vco_period_was_phase_adjusted : boolean := false;
signal sig_phase_adjust_was_scheduled : boolean := false;
signal sig_stop_vco : std_logic := '0';
signal sig_m_times_vco_period : time := 0 ps;
signal sig_new_m_times_vco_period : time := 0 ps;
signal sig_got_refclk_posedge : boolean := false;
signal sig_got_fbclk_posedge : boolean := false;
signal sig_got_second_refclk : boolean := false;

signal m_delay : integer := 0;
signal n_delay : integer := 0;

signal inclk1_tmp : std_logic := '0';

signal ext_fbk_cntr_high : integer := 0;
signal ext_fbk_cntr_low : integer := 0;
signal ext_fbk_cntr_ph : integer := 0;
signal ext_fbk_cntr_initial : integer := 1;
signal ext_fbk_cntr     : string(1 to 2) := "c0";
signal ext_fbk_cntr_mode : string(1 to 6) := "bypass";
signal ext_fbk_cntr_index : integer := 0;

signal enable0_tmp : std_logic := '0';
signal enable1_tmp : std_logic := '0';
signal reset_low : std_logic := '0';

signal scandataout_tmp : std_logic := '0';
signal scandone_tmp : std_logic := '0';

signal sig_refclk_period : time := (inclk0_input_frequency * 1 ps) * n;

signal schedule_vco : std_logic := '0';

signal areset_ena_sig : std_logic := '0';
signal pll_in_test_mode : boolean := false;

signal inclk_c_from_vco : std_logic_array(0 to 5);

signal inclk_m_from_vco : std_logic;
signal inclk_sclkout0_from_vco : std_logic;
signal inclk_sclkout1_from_vco : std_logic;

--signal tap0_is_active : boolean := true;
    signal sig_quiet_time : time := 0 ps;
    signal sig_slowest_clk_old : time := 0 ps;
    signal sig_slowest_clk_new : time := 0 ps;
    signal sig_m_val_tmp : int_array(0 to 1) := (OTHERS => 1);

COMPONENT stratixii_m_cntr
    PORT (
        clk           : IN std_logic;
        reset         : IN std_logic := '0';
        cout          : OUT std_logic;
        initial_value : IN integer := 1;
        modulus       : IN integer := 1;
        time_delay    : IN integer := 0
    );
END COMPONENT;

COMPONENT stratixii_n_cntr
    PORT (
        clk           : IN std_logic;
        reset         : IN std_logic := '0';
        cout          : OUT std_logic;
        initial_value : IN integer := 1;
        modulus       : IN integer := 1;
        time_delay    : IN integer := 0
    );
END COMPONENT;

COMPONENT stratixii_scale_cntr
    PORT (
        clk            : IN std_logic;
        reset          : IN std_logic := '0';
        cout           : OUT std_logic;
        initial        : IN integer := 1;
        high           : IN integer := 1;
        low            : IN integer := 1;
        mode           : IN string := "bypass";
        ph_tap         : IN integer := 0
    );
END COMPONENT;

COMPONENT stratixii_dffe
    GENERIC(
      TimingChecksOn: Boolean := true;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

    PORT(
        Q                              :  out   STD_LOGIC := '0';
        D                              :  in    STD_LOGIC := '1';
        CLRN                           :  in    STD_LOGIC := '1';
        PRN                            :  in    STD_LOGIC := '1';
        CLK                            :  in    STD_LOGIC := '0';
        ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

COMPONENT stratixii_pll_reg
    PORT(
        Q                              :  out   STD_LOGIC := '0';
        D                              :  in    STD_LOGIC := '1';
        CLRN                           :  in    STD_LOGIC := '1';
        PRN                            :  in    STD_LOGIC := '1';
        CLK                            :  in    STD_LOGIC := '0';
        ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (inclk0_ipd, inclk(0), tipd_inclk(0));
        VitalWireDelay (inclk1_ipd, inclk(1), tipd_inclk(1));
        VitalWireDelay (areset_ipd, areset, tipd_areset);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (fbin_ipd, fbin, tipd_fbin);
        VitalWireDelay (pfdena_ipd, pfdena, tipd_pfdena);
        VitalWireDelay (scanclk_ipd, scanclk, tipd_scanclk);
        VitalWireDelay (scanread_ipd, scanread, tipd_scanread);
        VitalWireDelay (scandata_ipd, scandata, tipd_scandata);
        VitalWireDelay (scanwrite_ipd, scanwrite, tipd_scanwrite);
        VitalWireDelay (clkswitch_ipd, clkswitch, tipd_clkswitch);
    end block;

    inclk_m <=  clkin when m_test_source = 0 else
                clk0_tmp when operation_mode = "external_feedback" and feedback_source = "clk0" else
                clk1_tmp when operation_mode = "external_feedback" and feedback_source = "clk1" else
                clk2_tmp when operation_mode = "external_feedback" and feedback_source = "clk2" else
                clk3_tmp when operation_mode = "external_feedback" and feedback_source = "clk3" else
                clk4_tmp when operation_mode = "external_feedback" and feedback_source = "clk4" else
                clk5_tmp when operation_mode = "external_feedback" and feedback_source = "clk5" else
                inclk_m_from_vco;


    ext_fbk_cntr_high <= c_high_val(ext_fbk_cntr_index);
    ext_fbk_cntr_low  <= c_low_val(ext_fbk_cntr_index);
    ext_fbk_cntr_ph   <= c_ph_val(ext_fbk_cntr_index);
    ext_fbk_cntr_initial <= c_initial_val(ext_fbk_cntr_index);
    ext_fbk_cntr_mode <= c_mode_val(ext_fbk_cntr_index);

    areset_ena_sig <= areset_ipd or (not ena_ipd) or sig_stop_vco;

    pll_in_test_mode <= true when   m_test_source /= 5 or c0_test_source /= 5 or
                                    c1_test_source /= 5 or c2_test_source /= 5 or
                                    c3_test_source /= 5 or c4_test_source /= 5 or
                                    c5_test_source /= 5 else
                        false;
   
   
    m1 : stratixii_m_cntr
        port map (  clk           => inclk_m,
                    reset         => areset_ena_sig,
                    cout          => fbclk,
                    initial_value => m_initial_val,
                    modulus       => m_val(0),
                    time_delay    => m_delay
                );

    -- add delta delay to inclk1 to ensure inclk0 and inclk1 are processed
    -- in different simulation deltas.
    inclk1_tmp <= inclk1_ipd;

    process (inclk0_ipd, inclk1_tmp, clkswitch_ipd)
    variable input_value : std_logic := '0';
    variable current_clock : integer := 0;
    variable clk0_count, clk1_count : integer := 0;
    variable clk0_is_bad, clk1_is_bad : std_logic := '0';
    variable primary_clk_is_bad : boolean := false;
    variable current_clk_is_bad : boolean := false;
    variable got_curr_clk_falling_edge_after_clkswitch : boolean := false;
    variable switch_over_count : integer := 0;
    variable active_clock : std_logic := '0';
    variable external_switch : boolean := false;
    begin
        if (now = 0 ps) then
            if (switch_over_type = "manual" and clkswitch_ipd = '1') then
                current_clock := 1;
                active_clock := '1';
            end if;
        end if;
        if (clkswitch_ipd'event and clkswitch_ipd = '1' and switch_over_type = "auto") then
            external_switch := true;
        elsif (switch_over_type = "manual") then
            if (clkswitch_ipd'event and clkswitch_ipd = '1') then
                current_clock := 1;
                active_clock := '1';
                clkin <= transport inclk1_tmp;
            elsif (clkswitch_ipd'event and clkswitch_ipd = '0') then
                current_clock := 0;
                active_clock := '0';
                clkin <= transport inclk0_ipd;
            end if;
        end if;
        -- save the current inclk event value
        if (inclk0_ipd'event) then
            input_value := inclk0_ipd;
        elsif (inclk1_tmp'event) then
            input_value := inclk1_tmp;
        end if;

        -- check if either input clk is bad
        if (inclk0_ipd'event and inclk0_ipd = '1') then
            clk0_count := clk0_count + 1;
            clk0_is_bad := '0';
            clk1_count := 0;
            if (clk0_count > 2) then
                -- no event on other clk for 2 cycles
                clk1_is_bad := '1';
                if (current_clock = 1) then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;
        if (inclk1_tmp'event and inclk1_tmp = '1') then
            clk1_count := clk1_count + 1;
            clk1_is_bad := '0';
            clk0_count := 0;
            if (clk1_count > 2) then
                -- no event on other clk for 2 cycles
                clk0_is_bad := '1';
                if (current_clock = 0) then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;

        -- check if the bad clk is the primary clock
        if (clk0_is_bad = '1') then
            primary_clk_is_bad := true;
        else
            primary_clk_is_bad := false;
        end if;

        -- actual switching
        if (inclk0_ipd'event and current_clock = 0) then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk0_ipd = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk0_ipd;
                end if;
            else
                clkin <= transport inclk0_ipd;
            end if;
        elsif (inclk1_tmp'event and current_clock = 1) then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk1_tmp = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk1_tmp;
                end if;
            else
                clkin <= transport inclk1_tmp;
            end if;
        else
            if (input_value = '1' and switch_over_on_lossclk = "on"  and enable_switch_over_counter = "on" and primary_clk_is_bad) then
                switch_over_count := switch_over_count + 1;
            end if;
            if (input_value = '0') then
                if (external_switch and (got_curr_clk_falling_edge_after_clkswitch or current_clk_is_bad)) or (switch_over_on_lossclk = "on" and primary_clk_is_bad and clkswitch_ipd /= '1' and (enable_switch_over_counter = "off" or switch_over_count = switch_over_counter)) then
                    got_curr_clk_falling_edge_after_clkswitch := false;
                    if (current_clock = 0) then
                        current_clock := 1;
                    else
                        current_clock := 0;
                    end if;
                    active_clock := not active_clock;
                    switch_over_count := 0;
                    external_switch := false;
                    current_clk_is_bad := false;
                end if;
       
            end if;
        end if;

        -- schedule outputs
        clkbad(0) <= clk0_is_bad;
        clkbad(1) <= clk1_is_bad;
        if (switch_over_on_lossclk = "on" and clkswitch_ipd /= '1') then
            if (primary_clk_is_bad) then
                -- assert clkloss
                clkloss <= '1';
            else
                clkloss <= '0';
            end if;
        else
            clkloss <= clkswitch_ipd;
        end if;
        activeclock <= active_clock;

    end process;

    process (inclk_sclkout0_from_vco)
    begin
        sclkout0_tmp <= inclk_sclkout0_from_vco;
    end process;

    process (inclk_sclkout1_from_vco)
    begin
        sclkout1_tmp <= inclk_sclkout1_from_vco;
    end process;

    n1 : stratixii_n_cntr
        port map (
                clk           => clkin,
                reset         => areset_ipd,
                cout          => refclk,
                initial_value => n_val(0),
                modulus       => n_val(0));


    inclk_c0 <= clkin when c0_test_source = 0 else
                refclk when c0_test_source = 1 else
                inclk_c_from_vco(0);
    c0 : stratixii_scale_cntr
        port map (
                clk            => inclk_c0,
                reset          => areset_ena_sig,
                cout           => c_clk(0),
                initial        => c_initial_val(0),
                high           => c_high_val(0),
                low            => c_low_val(0),
                mode           => c_mode_val(0),
                ph_tap         => c_ph_val(0));

                
    inclk_c1 <= clkin when c1_test_source = 0 else
                fbclk when c1_test_source = 2 else
                c_clk(0) when c1_use_casc_in = "on" else
                inclk_c_from_vco(1);
    c1 : stratixii_scale_cntr
        port map (
                clk            => inclk_c1,
                reset          => areset_ena_sig,
                cout           => c_clk(1),
                initial        => c_initial_val(1),
                high           => c_high_val(1),
                low            => c_low_val(1),
                mode           => c_mode_val(1),
                ph_tap         => c_ph_val(1));


    inclk_c2 <= clkin when c2_test_source = 0 else
                c_clk(1) when c2_use_casc_in = "on" else
                inclk_c_from_vco(2);
    c2 : stratixii_scale_cntr
        port map (
                clk            => inclk_c2,
                reset          => areset_ena_sig,
                cout           => c_clk(2),
                initial        => c_initial_val(2),
                high           => c_high_val(2),
                low            => c_low_val(2),
                mode           => c_mode_val(2),
                ph_tap         => c_ph_val(2));


    inclk_c3 <= clkin when c3_test_source = 0 else
                c_clk(2) when c3_use_casc_in = "on" else
                inclk_c_from_vco(3);
    c3 : stratixii_scale_cntr
        port map (
                clk            => inclk_c3,
                reset          => areset_ena_sig,
                cout           => c_clk(3),
                initial        => c_initial_val(3),
                high           => c_high_val(3),
                low            => c_low_val(3),
                mode           => c_mode_val(3),
                ph_tap         => c_ph_val(3));

    inclk_c4 <= '0' when (pll_type = "fast") else
                clkin when (c4_test_source = 0) else
                c_clk(3) when (c4_use_casc_in = "on") else
                inclk_c_from_vco(4);
    c4 : stratixii_scale_cntr
        port map (
                clk            => inclk_c4,
                reset          => areset_ena_sig,
                cout           => c_clk(4),
                initial        => c_initial_val(4),
                high           => c_high_val(4),
                low            => c_low_val(4),
                mode           => c_mode_val(4),
                ph_tap         => c_ph_val(4));

    inclk_c5 <= '0' when (pll_type = "fast") else
                clkin when c5_test_source = 0 else
                c_clk(4) when c5_use_casc_in = "on" else
                inclk_c_from_vco(5);
    c5 : stratixii_scale_cntr
        port map (
                clk            => inclk_c5,
                reset          => areset_ena_sig,
                cout           => c_clk(5),
                initial        => c_initial_val(5),
                high           => c_high_val(5),
                low            => c_low_val(5),
                mode           => c_mode_val(5),
                ph_tap         => c_ph_val(5));

    inclk_c0_dly1 <= inclk_c0 when (pll_type = "fast" or pll_type = "lvds")
                    else '0';
    inclk_c0_dly2 <= inclk_c0_dly1;
    inclk_c0_dly3 <= inclk_c0_dly2;
    inclk_c0_dly4 <= inclk_c0_dly3;
    inclk_c0_dly5 <= inclk_c0_dly4;
    inclk_c0_dly6 <= inclk_c0_dly5;

    inclk_c1_dly1 <= inclk_c1 when (pll_type = "fast" or pll_type = "lvds")
                    else '0';
    inclk_c1_dly2 <= inclk_c1_dly1;
    inclk_c1_dly3 <= inclk_c1_dly2;
    inclk_c1_dly4 <= inclk_c1_dly3;
    inclk_c1_dly5 <= inclk_c1_dly4;
    inclk_c1_dly6 <= inclk_c1_dly5;

    process(inclk_c0_dly6, inclk_c1_dly6, areset_ipd, ena_ipd, sig_stop_vco)
    variable c0_got_first_rising_edge : boolean := false;
    variable c0_count : integer := 2;
    variable c0_initial_count : integer := 1;
    variable c0_tmp, c1_tmp : std_logic := '0';
    variable c1_got_first_rising_edge : boolean := false;
    variable c1_count : integer := 2;
    variable c1_initial_count : integer := 1;
    begin
        if (areset_ipd = '1' or ena_ipd = '0' or sig_stop_vco = '1') then
            c0_count := 2;
            c1_count := 2;
            c0_initial_count := 1;
            c1_initial_count := 1;
            c0_got_first_rising_edge := false;
            c1_got_first_rising_edge := false;
        else
            if (not c0_got_first_rising_edge) then
                if (inclk_c0_dly6'event and inclk_c0_dly6 = '1') then
                    if (c0_initial_count = c_initial_val(0)) then
                        c0_got_first_rising_edge := true;
                    else
                        c0_initial_count := c0_initial_count + 1;
                    end if;
                end if;
            elsif (inclk_c0_dly6'event) then
                c0_count := c0_count + 1;
                if (c0_count = (c_high_val(0) + c_low_val(0)) * 2) then
                    c0_count := 1;
                end if;
            end if;
            if (inclk_c0_dly6'event and inclk_c0_dly6 = '0') then
                if (c0_count = 1) then
                    c0_tmp := '1';
                    c0_got_first_rising_edge := false;
                else
                    c0_tmp := '0';
                end if;
            end if;

            if (not c1_got_first_rising_edge) then
                if (inclk_c1_dly6'event and inclk_c1_dly6 = '1') then
                    if (c1_initial_count = c_initial_val(1)) then
                        c1_got_first_rising_edge := true;
                    else
                        c1_initial_count := c1_initial_count + 1;
                    end if;
                end if;
            elsif (inclk_c1_dly6'event) then
                c1_count := c1_count + 1;
                if (c1_count = (c_high_val(1) + c_low_val(1)) * 2) then
                    c1_count := 1;
                end if;
            end if;
            if (inclk_c1_dly6'event and inclk_c1_dly6 = '0') then
                if (c1_count = 1) then
                    c1_tmp := '1';
                    c1_got_first_rising_edge := false;
                else
                    c1_tmp := '0';
                end if;
            end if;
        end if;

        if (enable0_counter = "c0") then
            enable0_tmp <= c0_tmp;
        elsif (enable0_counter = "c1") then
            enable0_tmp <= c1_tmp;
        else
            enable0_tmp <= '0';
        end if;

        if (enable1_counter = "c0") then
            enable1_tmp <= c0_tmp;
        elsif (enable1_counter = "c1") then
            enable1_tmp <= c1_tmp;
        else
            enable1_tmp <= '0';
        end if;

    end process;

    glocked_cntr : process(clkin, ena_ipd, areset_ipd)
    variable count : integer := 0;
    variable output : std_logic := '0';
    begin
        if (areset_ipd = '1') then
            count := 0;
            output := '0';
        elsif (clkin'event and clkin = '1') then
            if (ena_ipd = '1') then
                count := count + 1;
                if (sim_gate_lock_device_behavior = "on") then
                    if (count = gate_lock_counter) then
                        output := '1';
                    end if;
                elsif (count = GATE_LOCK_CYCLES) then
                    output := '1';
                end if;
            end if;
        end if;
        gate_locked <= output;
    end process;

    locked <=   gate_locked and lock when gate_lock_signal = "yes" else
                lock;


    process (scandone_tmp)
    variable buf : line;
    begin
        if (scandone_tmp'event and scandone_tmp = '1') then
            if (reconfig_err = false) then
                ASSERT false REPORT family_name & " PLL Reprogramming completed with the following values (Values in parantheses indicate values before reprogramming) :" severity note;
                write (buf, string'("    N modulus = "));
                write (buf, n_val(0));
                write (buf, string'(" ( "));
                write (buf, n_val_old(0));
                write (buf, string'(" )"));
                writeline (output, buf);

                write (buf, string'("    M modulus = "));
                write (buf, m_val(0));
                write (buf, string'(" ( "));
                write (buf, m_val_old(0));
                write (buf, string'(" )"));
                writeline (output, buf);

                write (buf, string'("    M ph_tap = "));
                write (buf, m_ph_val);
                write (buf, string'(" ( "));
                write (buf, m_ph_val_old);
                write (buf, string'(" )"));
                writeline (output, buf);

                if (ss > 0) then
                    write (buf, string'("    M2 modulus = "));
                    write (buf, m_val(1));
                    write (buf, string'(" ( "));
                    write (buf, m_val_old(1));
                    write (buf, string'(" )"));
                    writeline (output, buf);

                    write (buf, string'("    N2 modulus = "));
                    write (buf, n_val(1));
                    write (buf, string'(" ( "));
                    write (buf, n_val_old(1));
                    write (buf, string'(" )"));
                    writeline (output, buf);
                end if;

                for i in 0 to (num_output_cntrs-1) loop
                    write (buf, cntrs(i));
                    write (buf, string'(" :   high = "));
                    write (buf, c_high_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_high_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   low = "));
                    write (buf, sig_c_low_val_tmp(i));
                    write (buf, string'(" ("));
                    write (buf, c_low_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   mode = "));
                    write (buf, c_mode_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_mode_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   phase tap = "));
                    write (buf, c_ph_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_ph_val_old(i));
                    write (buf, string'(") "));
                    writeline(output, buf);
                end loop;

                write (buf, string'("    Charge Pump Current (uA) = "));
                write (buf, cp_curr_val);
                write (buf, string'(" ( "));
                write (buf, cp_curr_old);
                write (buf, string'(" ) "));
                writeline (output, buf);

                write (buf, string'("    Loop Filter Capacitor (pF) = "));
                write (buf, lfc_val);
                write (buf, string'(" ( "));
                write (buf, lfc_old);
                write (buf, string'(" ) "));
                writeline (output, buf);

                write (buf, string'("    Loop Filter Resistor (Kohm) = "));
                write (buf, lfr_val);
                write (buf, string'(" ( "));
                write (buf, lfr_old);
                write (buf, string'(" ) "));
                writeline (output, buf);

            else ASSERT false REPORT "Errors were encountered during PLL reprogramming. Please refer to error/warning messages above." severity warning;
            end if;
        end if;
    end process;

    process (scanwrite_enabled, c_clk(0), c_clk(1), c_clk(2), c_clk(3), c_clk(4), c_clk(5), vco_tap, fbclk, scanclk_ipd, gated_scanclk)
    variable init : boolean := true;
    variable low, high : std_logic_vector(7 downto 0);
    variable low_fast, high_fast : std_logic_vector(3 downto 0);
    variable mode : string(1 to 6) := "bypass";
    variable is_error : boolean := false;
    variable m_tmp, n_tmp : std_logic_vector(8 downto 0);
    variable n_fast : std_logic_vector(1 downto 0);
    variable c_high_val_tmp : int_array(0 to 5) := (OTHERS => 1);
    variable c_low_val_tmp  : int_array(0 to 5) := (OTHERS => 1);
    variable c_ph_val_tmp   : int_array(0 to 5) := (OTHERS => 0);
    variable c_mode_val_tmp : str_array(0 to 5);
    variable m_ph_val_tmp   : integer := 0;
    variable m_val_tmp      : int_array(0 to 1) := (OTHERS => 1);
    variable c0_rising_edge_transfer_done : boolean := false;
    variable c1_rising_edge_transfer_done : boolean := false;
    variable c2_rising_edge_transfer_done : boolean := false;
    variable c3_rising_edge_transfer_done : boolean := false;
    variable c4_rising_edge_transfer_done : boolean := false;
    variable c5_rising_edge_transfer_done : boolean := false;

    -- variables for scaling of multiply_by and divide_by values
    variable i_clk0_mult_by    : integer := 1;
    variable i_clk0_div_by     : integer := 1;
    variable i_clk1_mult_by    : integer := 1;
    variable i_clk1_div_by     : integer := 1;
    variable i_clk2_mult_by    : integer := 1;
    variable i_clk2_div_by     : integer := 1;
    variable i_clk3_mult_by    : integer := 1;
    variable i_clk3_div_by     : integer := 1;
    variable i_clk4_mult_by    : integer := 1;
    variable i_clk4_div_by     : integer := 1;
    variable i_clk5_mult_by    : integer := 1;
    variable i_clk5_div_by     : integer := 1;
    variable max_d_value       : integer := 1;
    variable new_multiplier    : integer := 1;
    
    -- internal variables for storing the phase shift number.(used in lvds mode only)
    variable i_clk0_phase_shift : integer := 1;
    variable i_clk1_phase_shift : integer := 1;
    variable i_clk2_phase_shift : integer := 1;

    -- user to advanced variables

    variable   max_neg_abs    : integer := 0;
    variable   i_m_initial    : integer;
    variable   i_m            : integer := 1;
    variable   i_n            : integer := 1;
    variable   i_m2           : integer;
    variable   i_n2           : integer;
    variable   i_ss           : integer;
    variable   i_c_high       : int_array(0 to 5);
    variable   i_c_low        : int_array(0 to 5);
    variable   i_c_initial    : int_array(0 to 5);
    variable   i_c_ph         : int_array(0 to 5);
    variable   i_c_mode       : str_array(0 to 5);
    variable   i_m_ph         : integer;
    variable   output_count   : integer;
    variable   new_divisor    : integer;

    variable clk0_cntr : string(1 to 2) := "c0";
    variable clk1_cntr : string(1 to 2) := "c1";
    variable clk2_cntr : string(1 to 2) := "c2";
    variable clk3_cntr : string(1 to 2) := "c3";
    variable clk4_cntr : string(1 to 2) := "c4";
    variable clk5_cntr : string(1 to 2) := "c5";

    variable fbk_cntr : string(1 to 2);
    variable fbk_cntr_index : integer;
    variable start_bit : integer;
    variable quiet_time : time := 0 ps;
    variable slowest_clk_old : time := 0 ps;
    variable slowest_clk_new : time := 0 ps;
    variable tmp_scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');
    variable m_lo, m_hi : std_logic_vector(4 downto 0);

    variable j : integer := 0;
    variable scanread_active_edge : time := 0 ps;
    variable got_first_scanclk : boolean := false;
    variable got_first_gated_scanclk : boolean := false;
    variable scanclk_last_rising_edge : time := 0 ps;
    variable scanclk_period : time := 0 ps;
    variable current_scan_data : std_logic_vector(173 downto 0) := (OTHERS => '0');
    variable index : integer := 0;
    variable Tviol_scandata_scanclk : std_ulogic := '0';
    variable Tviol_scanread_scanclk : std_ulogic := '0';
    variable Tviol_scanwrite_scanclk : std_ulogic := '0';
    variable TimingData_scandata_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_scanread_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_scanwrite_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable scan_chain_length : integer := GPP_SCAN_CHAIN;
    variable tmp_rem : integer := 0;
    variable scanclk_cycles : integer := 0;
    variable lfc_tmp : std_logic_vector(1 downto 0);
    variable lfr_tmp : std_logic_vector(5 downto 0);
    variable lfr_int : integer := 0;

    function slowest_clk (
            C0 : integer; C0_mode : string(1 to 6);
            C1 : integer; C1_mode : string(1 to 6);
            C2 : integer; C2_mode : string(1 to 6);
            C3 : integer; C3_mode : string(1 to 6);
            C4 : integer; C4_mode : string(1 to 6);
            C5 : integer; C5_mode : string(1 to 6);
            refclk : time; m_mod : integer) return time is
    variable max_modulus : integer := 1;
    variable q_period : time := 0 ps;
    variable refclk_int : integer := 0;
    begin
        if (C0_mode /= "bypass" and C0_mode /= "   off") then
            max_modulus := C0;
        end if;
        if (C1 > max_modulus and C1_mode /= "bypass" and C1_mode /= "   off") then
            max_modulus := C1;
        end if;
        if (C2 > max_modulus and C2_mode /= "bypass" and C2_mode /= "   off") then
            max_modulus := C2;
        end if;
        if (C3 > max_modulus and C3_mode /= "bypass" and C3_mode /= "   off") then
            max_modulus := C3;
        end if;
        if (C4 > max_modulus and C4_mode /= "bypass" and C4_mode /= "   off") then
            max_modulus := C4;
        end if;
        if (C5 > max_modulus and C5_mode /= "bypass" and C5_mode /= "   off") then
            max_modulus := C5;
        end if;

        refclk_int := refclk / 1 ps;
        if (m_mod /= 0) then
            if (refclk_int > (refclk_int * max_modulus / m_mod)) then
                q_period := refclk_int * 1 ps;
            else
                q_period := (refclk_int * max_modulus / m_mod) * 1 ps;
            end if;
        end if;
        return (2*q_period);
    end slowest_clk;

    function int2bin (arg : integer; size : integer) return std_logic_vector is
    variable int_val : integer := arg;
    variable result : std_logic_vector(size-1 downto 0);
    begin
        for i in 0 to result'left loop
            if ((int_val mod 2) = 0) then
                result(i) := '0';
            else
                result(i) := '1';
            end if;
            int_val := int_val/2;
        end loop;
        return result;
    end int2bin;

    function extract_cntr_index (arg:string) return integer is
    variable index : integer := 0;
    begin
        if (arg(2) = '0') then
            index := 0;
        elsif (arg(2) = '1') then
            index := 1;
        elsif (arg(2) = '2') then
            index := 2;
        elsif (arg(2) = '3') then
            index := 3;
        elsif (arg(2) = '4') then
            index := 4;
        else index := 5;
        end if;

        return index;
    end extract_cntr_index;

    begin
        if (init) then
            if (m = 0) then
                clk5_cntr  := "c5";
                clk4_cntr  := "c4";
                clk3_cntr  := "c3";
                clk2_cntr  := "c2";
                clk1_cntr  := "c1";
                clk0_cntr  := "c0";
            else
                clk5_cntr  := clk5_counter;
                clk4_cntr  := clk4_counter;
                clk3_cntr  := clk3_counter;
                clk2_cntr  := clk2_counter;
                clk1_cntr  := clk1_counter;
                clk0_cntr  := clk0_counter;
            end if;

            if (operation_mode = "external_feedback") then
                if (feedback_source = "clk0") then
                    fbk_cntr := clk0_cntr;
                elsif (feedback_source = "clk1") then
                    fbk_cntr := clk1_cntr;
                elsif (feedback_source = "clk2") then
                    fbk_cntr := clk2_cntr;
                elsif (feedback_source = "clk3") then
                    fbk_cntr := clk3_cntr;
                elsif (feedback_source = "clk4") then
                    fbk_cntr := clk4_cntr;
                elsif (feedback_source = "clk5") then
                    fbk_cntr := clk5_cntr;
                else
                    fbk_cntr := "c0";
                end if;

                if (fbk_cntr = "c0") then
                    fbk_cntr_index := 0;
                elsif (fbk_cntr = "c1") then
                    fbk_cntr_index := 1;
                elsif (fbk_cntr = "c2") then
                    fbk_cntr_index := 2;
                elsif (fbk_cntr = "c3") then
                    fbk_cntr_index := 3;
                elsif (fbk_cntr = "c4") then
                    fbk_cntr_index := 4;
                elsif (fbk_cntr = "c5") then
                    fbk_cntr_index := 5;
                end if;

                ext_fbk_cntr <= fbk_cntr;
                ext_fbk_cntr_index <= fbk_cntr_index;
            end if;
            i_clk0_counter <= extract_cntr_index(clk0_cntr);
            i_clk1_counter <= extract_cntr_index(clk1_cntr);
            i_clk2_counter <= extract_cntr_index(clk2_cntr);
            i_clk3_counter <= extract_cntr_index(clk3_cntr);
            i_clk4_counter <= extract_cntr_index(clk4_cntr);
            i_clk5_counter <= extract_cntr_index(clk5_cntr);


            if (m = 0) then  -- convert user parameters to advanced
                -- set the limit of the divide_by value that can be returned by
                -- the following function.
                max_d_value := 500;

                -- scale down the multiply_by and divide_by values provided by the design
                -- before attempting to use them in the calculations below
                find_simple_integer_fraction(clk0_multiply_by, clk0_divide_by,
                                max_d_value, i_clk0_mult_by, i_clk0_div_by);
                find_simple_integer_fraction(clk1_multiply_by, clk1_divide_by,
                                max_d_value, i_clk1_mult_by, i_clk1_div_by);
                find_simple_integer_fraction(clk2_multiply_by, clk2_divide_by,
                                max_d_value, i_clk2_mult_by, i_clk2_div_by);
                find_simple_integer_fraction(clk3_multiply_by, clk3_divide_by,
                                max_d_value, i_clk3_mult_by, i_clk3_div_by);
                find_simple_integer_fraction(clk4_multiply_by, clk4_divide_by,
                                max_d_value, i_clk4_mult_by, i_clk4_div_by);
                find_simple_integer_fraction(clk5_multiply_by, clk5_divide_by,
                                max_d_value, i_clk5_mult_by, i_clk5_div_by);

                if (((pll_type = "fast") or (pll_type = "lvds")) and ((vco_multiply_by /= 0) and (vco_divide_by /= 0))) then
                    i_n := vco_divide_by;
                    i_m := vco_multiply_by;
                else
                    i_n := 1;
                    i_m := lcm (i_clk0_mult_by, i_clk1_mult_by,
                                i_clk2_mult_by, i_clk3_mult_by,
                                i_clk4_mult_by, i_clk5_mult_by,
                                1, 1, 1, 1, inclk0_input_frequency);
                end if;

                if (pll_type = "flvds") then
                    -- Need to readjust phase shift values when the clock multiply value has been readjusted.
                    new_multiplier := clk0_multiply_by / i_clk0_mult_by;
                    i_clk0_phase_shift := str2int(clk0_phase_shift) * new_multiplier;
                    i_clk1_phase_shift := str2int(clk1_phase_shift) * new_multiplier;
                    i_clk2_phase_shift := str2int(clk2_phase_shift) * new_multiplier;
                else
                    i_clk0_phase_shift := str2int(clk0_phase_shift);
                    i_clk1_phase_shift := str2int(clk1_phase_shift);
                    i_clk2_phase_shift := str2int(clk2_phase_shift);
                end if;

                max_neg_abs := maxnegabs(i_clk0_phase_shift, 
                                        i_clk1_phase_shift,
                                        i_clk2_phase_shift,
                                        str2int(clk3_phase_shift),
                                        str2int(clk4_phase_shift),
                                        str2int(clk5_phase_shift),
                                        0, 0, 0, 0);
                i_m_ph  := counter_ph(get_phase_degree(max_neg_abs,inclk0_input_frequency), i_m, i_n); 

                i_c_ph(0) := counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(1) := counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(2) := counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(3) := counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(4) := counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(5) := counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_high(0) := counter_high(output_counter_value(i_clk0_div_by,
                                i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);
                i_c_high(1) := counter_high(output_counter_value(i_clk1_div_by,
                                i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
                i_c_high(2) := counter_high(output_counter_value(i_clk2_div_by,
                                i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
                i_c_high(3) := counter_high(output_counter_value(i_clk3_div_by,
                                i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
                i_c_high(4) := counter_high(output_counter_value(i_clk4_div_by,
                                i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_c_high(5) := counter_high(output_counter_value(i_clk5_div_by,
                                i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
                i_c_low(0)  := counter_low(output_counter_value(i_clk0_div_by,
                                i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
                i_c_low(1)  := counter_low(output_counter_value(i_clk1_div_by,
                                i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
                i_c_low(2)  := counter_low(output_counter_value(i_clk2_div_by,
                                i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
                i_c_low(3)  := counter_low(output_counter_value(i_clk3_div_by,
                                i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
                i_c_low(4)  := counter_low(output_counter_value(i_clk4_div_by,
                                i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                i_c_low(5)  := counter_low(output_counter_value(i_clk5_div_by,
                                i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
                i_m_initial  := counter_initial(get_phase_degree(max_neg_abs, inclk0_input_frequency), i_m,i_n);
                
                i_c_initial(0) := counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(1) := counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(2) := counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(3) := counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(4) := counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(5) := counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_mode(0) := counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
                i_c_mode(1) := counter_mode(clk1_duty_cycle, output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
                i_c_mode(2) := counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
                i_c_mode(3) := counter_mode(clk3_duty_cycle, output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
                i_c_mode(4) := counter_mode(clk4_duty_cycle, output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
                i_c_mode(5) := counter_mode(clk5_duty_cycle, output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));

                -- in external feedback mode, need to adjust M value to take
                -- into consideration the external feedback counter value
                if(operation_mode = "external_feedback") then
                    -- if there is a negative phase shift, m_initial can
                    -- only be 1
                    if (max_neg_abs > 0) then
                        i_m_initial := 1;
                    end if;

                    -- calculate the feedback counter multiplier
                    if (i_c_mode(fbk_cntr_index) = "bypass") then
                        output_count := 1;
                    else
                        output_count := i_c_high(fbk_cntr_index) + i_c_low(fbk_cntr_index);
                    end if;

                    new_divisor := gcd(i_m, output_count);
                    i_m := i_m / new_divisor;
                    i_n := output_count / new_divisor;
                end if;
 
            else -- m /= 0

                i_n             := n;
                i_m             := m;
                i_m_initial     := m_initial;
                i_m_ph          := m_ph;
                i_c_ph(0)         := c0_ph;
                i_c_ph(1)         := c1_ph;
                i_c_ph(2)         := c2_ph;
                i_c_ph(3)         := c3_ph;
                i_c_ph(4)         := c4_ph;
                i_c_ph(5)         := c5_ph;
                i_c_high(0)       := c0_high;
                i_c_high(1)       := c1_high;
                i_c_high(2)       := c2_high;
                i_c_high(3)       := c3_high;
                i_c_high(4)       := c4_high;
                i_c_high(5)       := c5_high;
                i_c_low(0)        := c0_low;
                i_c_low(1)        := c1_low;
                i_c_low(2)        := c2_low;
                i_c_low(3)        := c3_low;
                i_c_low(4)        := c4_low;
                i_c_low(5)        := c5_low;
                i_c_initial(0)    := c0_initial;
                i_c_initial(1)    := c1_initial;
                i_c_initial(2)    := c2_initial;
                i_c_initial(3)    := c3_initial;
                i_c_initial(4)    := c4_initial;
                i_c_initial(5)    := c5_initial;
                i_c_mode(0)       := translate_string(c0_mode);
                i_c_mode(1)       := translate_string(c1_mode);
                i_c_mode(2)       := translate_string(c2_mode);
                i_c_mode(3)       := translate_string(c3_mode);
                i_c_mode(4)       := translate_string(c4_mode);
                i_c_mode(5)       := translate_string(c5_mode);

            end if; -- user to advanced conversion.

            m_initial_val <= i_m_initial;
            n_val(0) <= i_n;
            m_val(0) <= i_m;
            m_val(1) <= m2;
            n_val(1) <= n2;

            if (i_m = 1) then
                m_mode_val(0) <= "bypass";
            else
                m_mode_val(0) <= "      ";
            end if;
            if (m2 = 1) then
                m_mode_val(1) <= "bypass";
            end if;
            if (i_n = 1) then
                n_mode_val(0) <= "bypass";
            end if;
            if (n2 = 1) then
                n_mode_val(1) <= "bypass";
            end if;

            m_ph_val  <= i_m_ph;
            m_ph_val_tmp := i_m_ph;
            m_val_tmp := m_val;

            for i in 0 to 5 loop
                if (i_c_mode(i) = "bypass") then
                    if (pll_type = "fast" or pll_type = "lvds") then
                        i_c_high(i) := 16;
                        i_c_low(i) := 16;
                    else
                        i_c_high(i) := 256;
                        i_c_low(i) := 256;
                    end if;
                end if;
                c_ph_val(i)         <= i_c_ph(i);
                c_initial_val(i)    <= i_c_initial(i);
                c_high_val(i)       <= i_c_high(i);
                c_low_val(i)        <= i_c_low(i);
                c_mode_val(i)       <= i_c_mode(i);
                c_high_val_tmp(i)   := i_c_high(i);
                c_low_val_tmp(i)    := i_c_low(i);
                c_mode_val_tmp(i)   := i_c_mode(i);
                c_ph_val_tmp(i)     := i_c_ph(i);
                c_ph_val_orig(i)    <= i_c_ph(i);
                c_high_val_hold(i)  <= i_c_high(i);
                c_low_val_hold(i)   <= i_c_low(i);
                c_mode_val_hold(i)  <= i_c_mode(i);
            end loop;

            lfc_val <= loop_filter_c;
            lfr_val <= loop_filter_r;
            cp_curr_val <= charge_pump_current;

            if (pll_type = "fast") then
                scan_chain_length := FAST_SCAN_CHAIN;
            end if;
            -- initialize the scan_chain contents
            -- CP/LF bits
            scan_data(11 downto 0) <= "000000000000";
            for i in 0 to 3 loop
                if (pll_type = "fast" or pll_type = "lvds") then
                    if (fpll_loop_filter_c_arr(i) = loop_filter_c) then
                        scan_data(11 downto 10) <= int2bin(i, 2);
                    end if;
                else
                    if (loop_filter_c_arr(i) = loop_filter_c) then
                        scan_data(11 downto 10) <= int2bin(i, 2);
                    end if;
                end if;
            end loop;
            for i in 0 to 15 loop
                if (charge_pump_curr_arr(i) = charge_pump_current) then
                    scan_data(3 downto 0) <= int2bin(i, 4);
                end if;
            end loop;
            for i in 0 to 39 loop
                if (loop_filter_r_arr(i) = loop_filter_r) then
                    if (i >= 16 and i <= 23) then
                        scan_data(9 downto 4) <= int2bin((i+8), 6);
                    elsif (i >= 24 and i <= 31) then
                        scan_data(9 downto 4) <= int2bin((i+16), 6);
                    elsif (i >= 32) then
                        scan_data(9 downto 4) <= int2bin((i+24), 6);
                    else
                        scan_data(9 downto 4) <= int2bin(i, 6);
                    end if;
                end if;
            end loop;
               
            if (pll_type = "fast" or pll_type = "lvds") then
                scan_data(21 downto 12) <= "0000000000"; -- M, C3-C0 ph
                -- C0-C3 high
                scan_data(25 downto 22) <= int2bin(i_c_high(0), 4);
                scan_data(35 downto 32) <= int2bin(i_c_high(1), 4);
                scan_data(45 downto 42) <= int2bin(i_c_high(2), 4);
                scan_data(55 downto 52) <= int2bin(i_c_high(3), 4);
                -- C0-C3 low
                scan_data(30 downto 27) <= int2bin(i_c_low(0), 4);
                scan_data(40 downto 37) <= int2bin(i_c_low(1), 4);
                scan_data(50 downto 47) <= int2bin(i_c_low(2), 4);
                scan_data(60 downto 57) <= int2bin(i_c_low(3), 4);
                -- C0-C3 mode
                for i in 0 to 3 loop
                    if (i_c_mode(i) = "   off" or i_c_mode(i) = "bypass") then
                        scan_data(26 + (10*i)) <= '1';
                        if (i_c_mode(i) = "   off") then
                            scan_data(31 + (10*i)) <= '1';
                        else
                            scan_data(31 + (10*i)) <= '0';
                        end if;
                    else 
                        scan_data(26 + (10*i)) <= '0';
                        if (i_c_mode(i) = "   odd") then
                            scan_data(31 + (10*i)) <= '1';
                        else
                            scan_data(31 + (10*i)) <= '0';
                        end if;
                    end if;
                end loop;
                -- M
                if (i_m = 1) then
                    scan_data(66) <= '1';
                    scan_data(71) <= '0';
                    scan_data(65 downto 62) <= "0000";
                    scan_data(70 downto 67) <= "0000";
                else
                    scan_data(66) <= '0';       -- set BYPASS bit to 0
                    scan_data(70 downto 67) <= int2bin(i_m/2, 4);   -- set M low
                    if (i_m rem 2 = 0) then
                        -- M is an even no. : set M high = low,
                        -- set odd/even bit to 0
                        scan_data(65 downto 62) <= int2bin(i_m/2, 4);
                        scan_data(71) <= '0';
                    else       -- M is odd : M high = low + 1
                        scan_data(65 downto 62) <= int2bin((i_m/2) + 1, 4);
                        scan_data(71) <= '1';
                    end if;
                end if;
                -- N
                scan_data(73 downto 72) <= int2bin(i_n, 2);
                if (i_n = 1) then
                    scan_data(74) <= '1';
                    scan_data(73 downto 72) <= "00";
                end if;
            else          -- PLL type is auto or enhanced
                scan_data(25 downto 12) <= "00000000000000"; -- M, C5-C0 ph
                -- C0-C5 high
                scan_data(123 downto 116) <= int2bin(i_c_high(0), 8);
                scan_data(105 downto 98) <= int2bin(i_c_high(1), 8);
                scan_data(87 downto 80) <= int2bin(i_c_high(2), 8);
                scan_data(69 downto 62) <= int2bin(i_c_high(3), 8);
                scan_data(51 downto 44) <= int2bin(i_c_high(4), 8);
                scan_data(33 downto 26) <= int2bin(i_c_high(5), 8);
                -- C0-C5 low
                scan_data(132 downto 125) <= int2bin(i_c_low(0), 8);
                scan_data(114 downto 107) <= int2bin(i_c_low(1), 8);
                scan_data(96 downto 89) <= int2bin(i_c_low(2), 8);
                scan_data(78 downto 71) <= int2bin(i_c_low(3), 8);
                scan_data(60 downto 53) <= int2bin(i_c_low(4), 8);
                scan_data(42 downto 35) <= int2bin(i_c_low(5), 8);
                -- C0-C5 mode
                for i in 0 to 5 loop
                    if (i_c_mode(i) = "   off" or i_c_mode(i) = "bypass") then
                        scan_data(124 - (18*i)) <= '1';
                        if (i_c_mode(i) = "   off") then
                            scan_data(133 - (18*i)) <= '1';
                        else
                            scan_data(133 - (18*i)) <= '0';
                        end if;
                    else 
                        scan_data(124 - (18*i)) <= '0';
                        if (i_c_mode(i) = "   odd") then
                            scan_data(133 - (18*i)) <= '1';
                        else
                            scan_data(133 - (18*i)) <= '0';
                        end if;
                    end if;
                end loop;

                -- M/M2
                scan_data(142 downto 134) <= int2bin(i_m, 9);
                scan_data(143) <= '0';
                scan_data(152 downto 144) <= int2bin(m2, 9);
                scan_data(153) <= '0';
                if (i_m = 1) then
                    scan_data(143) <= '1';
                    scan_data(142 downto 134) <= "000000000";
                end if;
                if (m2 = 1) then
                    scan_data(153) <= '1';
                    scan_data(152 downto 144) <= "000000000";
                end if;
               
                -- N/N2
                scan_data(162 downto 154) <= int2bin(i_n, 9);
                scan_data(172 downto 164) <= int2bin(n2, 9);
                if (i_n = 1) then
                    scan_data(163) <= '1';
                    scan_data(162 downto 154) <= "000000000";
                end if;
                if (n2 = 1) then
                    scan_data(173) <= '1';
                    scan_data(172 downto 164) <= "000000000";
                end if;
               
            end if;
            if (pll_type = "fast" or pll_type = "lvds") then
                num_output_cntrs <= 4;
            else
                num_output_cntrs <= 6;
            end if;

            init := false;
        elsif (scanwrite_enabled'event and scanwrite_enabled = '0') then
            -- falling edge : deassert scandone
            scandone_tmp <= transport '0' after (1.5 * scanclk_period);
            c0_rising_edge_transfer_done := false;
            c1_rising_edge_transfer_done := false;
            c2_rising_edge_transfer_done := false;
            c3_rising_edge_transfer_done := false;
            c4_rising_edge_transfer_done := false;
            c5_rising_edge_transfer_done := false;
        elsif (scanwrite_enabled'event and scanwrite_enabled = '1') then
            ASSERT false REPORT "PLL Reprogramming Initiated" severity note;

            reconfig_err <= false;

            -- make temporary copy of scan_data for processing
            tmp_scan_data := scan_data;

            -- save old values
            lfc_old <= lfc_val;
            lfr_old <= lfr_val;
            cp_curr_old <= cp_curr_val;

            -- CP
            -- Bits 0-3 : all values are legal
            cp_curr_val <= charge_pump_curr_arr(alt_conv_integer(scan_data(3 downto 0)));

            -- LF Resistance : bits 4-9
            -- values from 010000 - 010111, 100000 - 100111,
            --             110000 - 110111 are illegal
            lfr_tmp := tmp_scan_data(9 downto 4);
            lfr_int := alt_conv_integer(lfr_tmp);
            if (((lfr_int >= 16) and (lfr_int <= 23)) or
                ((lfr_int >= 32) and (lfr_int <= 39)) or
                ((lfr_int >= 48) and (lfr_int <= 55))) then
                reconfig_err <= true;
                ASSERT false REPORT "Illegal bit settings for Loop Filter Resistance. Legal bit values range from 000000-001111, 011000-011111, 101000-101111 and 111000-111111. Reconfiguration may not work." severity warning;
            else
                if (lfr_int >= 56) then
                    lfr_int := lfr_int - 24;
                elsif ((lfr_int >= 40) and (lfr_int <= 47)) then
                    lfr_int := lfr_int - 16;
                elsif ((lfr_int >= 24) and (lfr_int <= 31)) then
                    lfr_int := lfr_int - 8;
                end if;
                lfr_val <= loop_filter_r_arr(lfr_int);
            end if;

            -- LF Capacitance : bits 10,11 : all values are legal
            lfc_tmp := scan_data(11 downto 10);
            if (pll_type = "fast" or pll_type = "lvds") then
                lfc_val <= fpll_loop_filter_c_arr(alt_conv_integer(lfc_tmp));
            else
                lfc_val <= loop_filter_c_arr(alt_conv_integer(lfc_tmp));
            end if;

            -- cntrs c0-c5
            -- save old values for display info.
            m_val_old <= m_val;
            n_val_old <= n_val;
            m_mode_val_old <= m_mode_val;
            n_mode_val_old <= n_mode_val;
            m_ph_val_old <= m_ph_val;
            c_high_val_old <= c_high_val;
            c_low_val_old <= c_low_val;
            c_ph_val_old <= c_ph_val;
            c_mode_val_old <= c_mode_val;

            -- first the M counter phase : bit order same for fast and GPP
            if (scan_data(12) = '0') then
                -- do nothing
            elsif (scan_data(12) = '1' and scan_data(13) = '1') then
                m_ph_val_tmp := m_ph_val_tmp + 1;
                if (m_ph_val_tmp > 7) then
                    m_ph_val_tmp := 0;
                end if;
            elsif (scan_data(12) = '1' and scan_data(13) = '0') then
                m_ph_val_tmp := m_ph_val_tmp - 1;
                if (m_ph_val_tmp < 0) then
                    m_ph_val_tmp := 7;
                end if;
            else
                reconfig_err <= true;
                ASSERT false REPORT "Illegal values for M counter phase tap. Reconfiguration may not work." severity warning;
            end if;

            -- read the fast PLL bits
            if (pll_type = "fast" or pll_type = "lvds") then
                -- C3-C0 phase bits
                for i in 3 downto 0 loop
                    start_bit := 14 + ((3-i)*2);
                    if (tmp_scan_data(start_bit) = '0') then
                        -- do nothing
                    elsif (tmp_scan_data(start_bit) = '1') then
                        if (tmp_scan_data(start_bit + 1) = '1') then
                            c_ph_val_tmp(i) := c_ph_val_tmp(i) + 1;
                            if (c_ph_val_tmp(i) > 7) then
                                c_ph_val_tmp(i) := 0;
                            end if;
                        elsif (tmp_scan_data(start_bit + 1) = '0') then
                            c_ph_val_tmp(i) := c_ph_val_tmp(i) - 1;
                            if (c_ph_val_tmp(i) < 0) then
                                c_ph_val_tmp(i) := 7;
                            end if;
                        end if;
                    end if;
                end loop;
                -- C0-C3 counter moduli
                for i in 0 to 3 loop
                    start_bit := 22 + (i*10);
                    if (tmp_scan_data(start_bit + 4) = '1') then
                        c_mode_val_tmp(i) := "bypass";
                        if (tmp_scan_data(start_bit + 9) = '1') then
                            c_mode_val_tmp(i) := "   off";
                            ASSERT false REPORT "The specified bit settings will turn OFF the " &cntrs(i)& "counter. It cannot be turned on unless the part is re-initialized." severity warning;
                        end if;
                    elsif (tmp_scan_data(start_bit + 9) = '1') then
                        c_mode_val_tmp(i) := "   odd";
                    else
                        c_mode_val_tmp(i) := "  even";
                    end if;
                    high_fast := tmp_scan_data(start_bit+3 downto start_bit);
                    low_fast := tmp_scan_data(start_bit+8 downto start_bit+5);
                    if (tmp_scan_data(start_bit+3 downto start_bit) = "0000") then
                        c_high_val_tmp(i) := 16;
                    else
                        c_high_val_tmp(i) := alt_conv_integer(high_fast);
                    end if;
                    if (tmp_scan_data(start_bit+8 downto start_bit+5) = "0000") then
                        c_low_val_tmp(i) := 16;
                    else
                        c_low_val_tmp(i) := alt_conv_integer(low_fast);
                    end if;
                end loop;
                sig_c_ph_val_tmp <= c_ph_val_tmp;
                sig_c_low_val_tmp <= c_low_val_tmp;
                sig_c_hi_val_tmp <= c_high_val_tmp;
                -- M
                -- some temporary storage
                if (tmp_scan_data(65 downto 62) = "0000") then
                    m_hi := "10000";
                else
                    m_hi := "0" & tmp_scan_data(65 downto 62);
                end if;
                if (tmp_scan_data(70 downto 67) = "0000") then
                    m_lo := "10000";
                else
                    m_lo := "0" & tmp_scan_data(70 downto 67);
                end if;
                m_val_tmp(0) := alt_conv_integer(m_hi) + alt_conv_integer(m_lo);
                if (tmp_scan_data(66) = '1') then
                    if (tmp_scan_data(71) = '1') then
                        -- this will turn off the M counter : error
                        reconfig_err <= true;
                        is_error := true;
                        ASSERT false REPORT "The specified bit settings will turn OFF the M counter. This is illegal. Reconfiguration may not work." severity warning;
                    else -- M counter is being bypassed
                        if (m_mode_val(0) /= "bypass") then
                            -- mode is switched : give warning
                            ASSERT false REPORT "M counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                        end if;
                        m_val_tmp(0) := 1;
                        m_mode_val(0) <= "bypass";
                    end if;
                else
                    if (m_mode_val(0) = "bypass") then
                        -- mode is switched : give warning
                        ASSERT false REPORT "M counter switched BYPASS mode to enabled. PLL may lose lock." severity warning;
                    end if;
                    m_mode_val(0) <= "      ";
                    if (tmp_scan_data(71) = '1') then
                        -- odd : check for duty cycle, if not 50% -- error
                        if (alt_conv_integer(m_hi) - alt_conv_integer(m_lo) /= 1) then
                            reconfig_err <= true;
                            ASSERT FALSE REPORT "The M counter of the " & family_name & " FAST PLL can be configured for 50% duty cycle only. In this case, the HIGH and LOW moduli programmed will result in a duty cycle other than 50%, which is illegal. Reconfiguration may not work." severity warning;
                        end if;
                    else -- even
                        if (alt_conv_integer(m_hi) /= alt_conv_integer(m_lo)) then
                            reconfig_err <= true;
                            ASSERT FALSE REPORT "The M counter of the " & family_name & " FAST PLL can be configured for 50% duty cycle only. In this case, the HIGH and LOW moduli programmed will result in a duty cycle other than 50%, which is illegal. Reconfiguration may not work." severity warning;
                        end if;
                    end if;
                end if;

                -- N
                is_error := false;
                n_fast := tmp_scan_data(73 downto 72);
                n_val(0) <= alt_conv_integer(n_fast);
                if (tmp_scan_data(74) /= '1') then
                    if (alt_conv_integer(n_fast) = 1) then
                        is_error := true;
                        reconfig_err <= true;
                        -- cntr value is illegal : give warning
                        ASSERT false REPORT "Illegal 1 value for N counter. Instead the counter should be BYPASSED. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(n_fast) = 0) then
                        n_val(0) <= 4;
                        ASSERT FALSE REPORT "N Modulus = " &int2str(4)& " " severity note;
                    end if;
                    if (not is_error) then
                        if (n_mode_val(0) = "bypass") then
                            ASSERT false REPORT "N Counter switched from BYPASS mode to enabled (N modulus = " &int2str(alt_conv_integer(n_fast))& "). PLL may lose lock." severity warning;
                        else
                            ASSERT FALSE REPORT "N modulus = " &int2str(alt_conv_integer(n_fast))& " "severity note;
                        end if;
                        n_mode_val(0) <= "      ";
                    end if;
                elsif (tmp_scan_data(74) = '1') then
                    if (tmp_scan_data(72) /= '0') then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false report "Illegal value for N counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                    else
                        if (n_mode_val(0) /= "bypass") then
                            ASSERT false REPORT "N Counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                        end if;
                        n_val(0) <= 1;
                        n_mode_val(0) <= "bypass";
                    end if;
                end if;
            else   -- GENERAL PURPOSE PLL
                for i in 0 to 5 loop
                    start_bit := 116 - (i*18);
                    if (tmp_scan_data(start_bit + 8) = '1') then
                        c_mode_val_tmp(i) := "bypass";
                        if (tmp_scan_data(start_bit + 17) = '1') then
                            c_mode_val_tmp(i) := "   off";
                            ASSERT false REPORT "The specified bit settings will turn OFF the " &cntrs(i)& "counter. It cannot be turned on unless the part is re-initialized." severity warning;
                        end if;
                    elsif (tmp_scan_data(start_bit + 17) = '1') then
                        c_mode_val_tmp(i) := "   odd";
                    else
                        c_mode_val_tmp(i) := "  even";
                    end if;
                    high := tmp_scan_data(start_bit + 7 downto start_bit);
                    low := tmp_scan_data(start_bit+16 downto start_bit+9);
                    if (tmp_scan_data(start_bit+7 downto start_bit) = "00000000") then
                        c_high_val_tmp(i) := 256;
                    else
                        c_high_val_tmp(i) := alt_conv_integer(high);
                    end if;
                    if (tmp_scan_data(start_bit+16 downto start_bit+9) = "00000000") then
                        c_low_val_tmp(i) := 256;
                    else
                        c_low_val_tmp(i) := alt_conv_integer(low);
                    end if;
                end loop;
                -- the phase taps
                for i in 0 to 5 loop
                    start_bit := 14 + (i*2);
                    if (tmp_scan_data(start_bit) = '0') then
                        -- do nothing
                    elsif (tmp_scan_data(start_bit) = '1') then
                        if (tmp_scan_data(start_bit + 1) = '1') then
                            c_ph_val_tmp(i) := c_ph_val_tmp(i) + 1;
                            if (c_ph_val_tmp(i) > 7) then
                                c_ph_val_tmp(i) := 0;
                            end if;
                        elsif (tmp_scan_data(start_bit + 1) = '0') then
                            c_ph_val_tmp(i) := c_ph_val_tmp(i) - 1;
                            if (c_ph_val_tmp(i) < 0) then
                                c_ph_val_tmp(i) := 7;
                            end if;
                        end if;
                    end if;
                end loop;
                sig_c_ph_val_tmp <= c_ph_val_tmp;
                sig_c_low_val_tmp <= c_low_val_tmp;
                sig_c_hi_val_tmp <= c_high_val_tmp;

                -- cntrs M/M2
                for i in 0 to 1 loop
                    start_bit := 134 + (i*10);
                    if ( i = 0 or (i = 1 and ss > 0) ) then
                        is_error := false;
                        m_tmp := tmp_scan_data(start_bit+8 downto start_bit);
                        m_val_tmp(i) := alt_conv_integer(m_tmp);
                        if (tmp_scan_data(start_bit+9) /= '1') then
                            if (alt_conv_integer(m_tmp) = 1) then
                                is_error := true;
                                reconfig_err <= true;
                                -- cntr value is illegal : give warning
                                ASSERT false REPORT "Illegal 1 value for " &ss_cntrs(i)& "counter. Instead " &ss_cntrs(i)& "should be BYPASSED. Reconfiguration may not work." severity warning;
                            elsif (tmp_scan_data(start_bit+8 downto start_bit) = "000000000") then
                                m_val_tmp(i) := 512;
                            end if;
                            if (not is_error) then
                                if (m_mode_val(i) = "bypass") then
                                    -- Mode is switched : give warning
                                    ASSERT false REPORT "M Counter switched from BYPASS mode to enabled (M modulus = " &int2str(alt_conv_integer(m_tmp))& "). PLL may lose lock." severity warning;
                                else
                                end if;
                                m_mode_val(i) <= "      ";
                            end if;
                        elsif (tmp_scan_data(start_bit+9) = '1') then
                            if (tmp_scan_data(start_bit) /= '0') then
                                is_error := true;
                                reconfig_err <= true;
                                ASSERT false report "Illegal value for counter " &ss_cntrs(i)& "in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                            else
                                if (m_mode_val(i) /= "bypass") then
                                    -- Mode is switched : give warning
                                    ASSERT false REPORT "M Counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                                end if;
                                m_val_tmp(i) := 1;
                                m_mode_val(i) <= "bypass";
                            end if;
                        end if;
                    end if;
                end loop;
                if (ss > 0) then
                    if (m_mode_val(0) /= m_mode_val(1)) then
                        reconfig_err <= true;
                        is_error := true;
                        ASSERT false REPORT "Incompatible modes for M/M2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                    end if;
                end if;
                sig_m_val_tmp <= m_val_tmp;
                -- cntrs N/N2
                for i in 0 to 1 loop
                    start_bit := 154 + i*10;
                    if ( i = 0 or (i = 1 and ss > 0) ) then
                        is_error := false;
                        n_tmp := tmp_scan_data(start_bit+8 downto start_bit);
                        n_val(i) <= alt_conv_integer(n_tmp);
                        if (tmp_scan_data(start_bit+9) /= '1') then
                            if (alt_conv_integer(n_tmp) = 1) then
                                is_error := true;
                                reconfig_err <= true;
                                -- cntr value is illegal : give warning
                                ASSERT false REPORT "Illegal 1 value for " &ss_cntrs(2+i)& "counter. Instead " &ss_cntrs(2+i)& "should be BYPASSED. Reconfiguration may not work." severity warning;
                            elsif (alt_conv_integer(n_tmp) = 0) then
                                n_val(i) <= 512;
                            end if;
                            if (not is_error) then
                                if (n_mode_val(i) = "bypass") then
                                    ASSERT false REPORT "N Counter switched from BYPASS mode to enabled (N modulus = " &int2str(alt_conv_integer(n_tmp))& "). PLL may lose lock." severity warning;
                                else
                                end if;
                                n_mode_val(i) <= "      ";
                            end if;
                        elsif (tmp_scan_data(start_bit+9) = '1') then
                            if (tmp_scan_data(start_bit) /= '0') then
                                is_error := true;
                                reconfig_err <= true;
                                ASSERT false report "Illegal value for counter " &ss_cntrs(2+i)& "in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                            else
                                if (n_mode_val(i) /= "bypass") then
                                    ASSERT false REPORT "N Counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                                end if;
                                n_val(i) <= 1;
                                n_mode_val(i) <= "bypass";
                            end if;
                        end if;
                    end if;
                end loop;
                if (ss > 0) then
                    if (n_mode_val(0) /= n_mode_val(1)) then
                        reconfig_err <= true;
                        is_error := true;
                        ASSERT false REPORT "Incompatible modes for N/N2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                    end if;
                end if;
            end if;
            
            slowest_clk_old := slowest_clk(c_high_val(0)+c_low_val(0), c_mode_val(0),
                                    c_high_val(1)+c_low_val(1), c_mode_val(1),
                                    c_high_val(2)+c_low_val(2), c_mode_val(2),
                                    c_high_val(3)+c_low_val(3), c_mode_val(3),
                                    c_high_val(4)+c_low_val(4), c_mode_val(4),
                                    c_high_val(5)+c_low_val(5), c_mode_val(5),
                                    sig_refclk_period, m_val(0));

            slowest_clk_new := slowest_clk(c_high_val_tmp(0)+c_low_val_tmp(0), c_mode_val_tmp(0),
                                    c_high_val_tmp(1)+c_low_val_tmp(1), c_mode_val_tmp(1),
                                    c_high_val_tmp(2)+c_low_val_tmp(2), c_mode_val_tmp(2),
                                    c_high_val_tmp(3)+c_low_val_tmp(3), c_mode_val_tmp(3),
                                    c_high_val_tmp(4)+c_low_val_tmp(4), c_mode_val_tmp(4),
                                    c_high_val_tmp(5)+c_low_val_tmp(5), c_mode_val_tmp(5),
                                    sig_refclk_period, m_val_tmp(0));

            if (slowest_clk_new > slowest_clk_old) then
                quiet_time := slowest_clk_new;
            else
                quiet_time := slowest_clk_old;
            end if;
            sig_quiet_time <= quiet_time;
            sig_slowest_clk_old <= slowest_clk_old;
            sig_slowest_clk_new <= slowest_clk_new;
            tmp_rem := (quiet_time/1 ps) rem (scanclk_period/ 1 ps);
            scanclk_cycles := (quiet_time/1 ps) / (scanclk_period/1 ps);
            if (tmp_rem /= 0) then
                scanclk_cycles := scanclk_cycles + 1;
            end if;
            scandone_tmp <= transport '1' after ((scanclk_cycles+1)*scanclk_period - (scanclk_period/2));
        end if;

        if (scanwrite_enabled = '1') then
            if (fbclk'event and fbclk = '1') then
                m_val <= m_val_tmp;
            end if;

            if (c_clk(0)'event and c_clk(0) = '1') then
                c_high_val(0) <= c_high_val_tmp(0);
                c_mode_val(0) <= c_mode_val_tmp(0);
                c0_rising_edge_transfer_done := true;
            end if;
            if (c_clk(1)'event and c_clk(1) = '1') then
                c_high_val(1) <= c_high_val_tmp(1);
                c_mode_val(1) <= c_mode_val_tmp(1);
                c1_rising_edge_transfer_done := true;
            end if;
            if (c_clk(2)'event and c_clk(2) = '1') then
                c_high_val(2) <= c_high_val_tmp(2);
                c_mode_val(2) <= c_mode_val_tmp(2);
                c2_rising_edge_transfer_done := true;
            end if;
            if (c_clk(3)'event and c_clk(3) = '1') then
                c_high_val(3) <= c_high_val_tmp(3);
                c_mode_val(3) <= c_mode_val_tmp(3);
                c3_rising_edge_transfer_done := true;
            end if;
            if (c_clk(4)'event and c_clk(4) = '1') then
                c_high_val(4) <= c_high_val_tmp(4);
                c_mode_val(4) <= c_mode_val_tmp(4);
                c4_rising_edge_transfer_done := true;
            end if;
            if (c_clk(5)'event and c_clk(5) = '1') then
                c_high_val(5) <= c_high_val_tmp(5);
                c_mode_val(5) <= c_mode_val_tmp(5);
                c5_rising_edge_transfer_done := true;
            end if;
        end if;

        if (c_clk(0)'event and c_clk(0) = '0' and c0_rising_edge_transfer_done) then
            c_low_val(0) <= c_low_val_tmp(0);
        end if;
        if (c_clk(1)'event and c_clk(1) = '0' and c1_rising_edge_transfer_done) then
            c_low_val(1) <= c_low_val_tmp(1);
        end if;
        if (c_clk(2)'event and c_clk(2) = '0' and c2_rising_edge_transfer_done) then
            c_low_val(2) <= c_low_val_tmp(2);
        end if;
        if (c_clk(3)'event and c_clk(3) = '0' and c3_rising_edge_transfer_done) then
            c_low_val(3) <= c_low_val_tmp(3);
        end if;
        if (c_clk(4)'event and c_clk(4) = '0' and c4_rising_edge_transfer_done) then
            c_low_val(4) <= c_low_val_tmp(4);
        end if;
        if (c_clk(5)'event and c_clk(5) = '0' and c5_rising_edge_transfer_done) then
            c_low_val(5) <= c_low_val_tmp(5);
        end if;

        if (scanwrite_enabled = '1') then
            for x in 0 to 7 loop
                if (vco_tap(x) /= vco_tap_last_value(x) and vco_tap(x) = '0') then
                    -- TAP X has event
                    for i in 0 to 5 loop
                        if (c_ph_val(i) = x) then
                            c_ph_val(i) <= c_ph_val_tmp(i);
                        end if;
                    end loop;
                    if (m_ph_val = x) then
                        m_ph_val <= m_ph_val_tmp;
                    end if;
                end if;
            end loop;
        end if;

        -- revert counter phase tap values to POF programmed values
        -- if PLL is reset

        if (areset_ipd = '1') then
            c_ph_val <= i_c_ph;
            c_ph_val_tmp := i_c_ph;
            m_ph_val <= i_m_ph;
            m_ph_val_tmp := i_m_ph;
        end if;

        for x in 0 to 7 loop
            if (vco_tap(x) /= vco_tap_last_value(x)) then
                -- TAP X has event
                for i in 0 to 5 loop
                    if (c_ph_val(i) = x) then
                        inclk_c_from_vco(i) <= vco_tap(x);
                        if (i = 0 and enable0_counter = "c0") then
                            inclk_sclkout0_from_vco <= vco_tap(x);
                        end if;
                        if (i = 0 and enable1_counter = "c0") then
                            inclk_sclkout1_from_vco <= vco_tap(x);
                        end if;
                        if (i = 1 and enable0_counter = "c1") then
                            inclk_sclkout0_from_vco <= vco_tap(x);
                        end if;
                        if (i = 1 and enable1_counter = "c1") then
                            inclk_sclkout1_from_vco <= vco_tap(x);
                        end if;
                    end if;
                end loop;

                if (m_ph_val = x) then
                    inclk_m_from_vco <= vco_tap(x);
                end if;

                vco_tap_last_value(x) <= vco_tap(x);
            end if;
        end loop;


      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
              Violation       => Tviol_scandata_scanclk,
              TimingData      => TimingData_scandata_scanclk,
              TestSignal      => scandata_ipd,
              TestSignalName  => "scandata",
              RefSignal       => scanclk_ipd,
              RefSignalName   => "scanclk",
              SetupHigh       => tsetup_scandata_scanclk_noedge_posedge,
              SetupLow        => tsetup_scandata_scanclk_noedge_posedge,
              HoldHigh        => thold_scandata_scanclk_noedge_posedge,
              HoldLow         => thold_scandata_scanclk_noedge_posedge,
--                    CheckEnabled    => TO_X01( (NOT ena_ipd) ) /= '1',
              RefTransition   => '/',
              HeaderMsg       => InstancePath & "/stratixii_pll",
              XOn             => XOnChecks,
              MsgOn           => MsgOnChecks );
 
         VitalSetupHoldCheck (
              Violation       => Tviol_scanread_scanclk,
              TimingData      => TimingData_scanread_scanclk,
              TestSignal      => scanread_ipd,
              TestSignalName  => "scanread",
              RefSignal       => scanclk_ipd,
              RefSignalName   => "scanclk",
              SetupHigh       => tsetup_scanread_scanclk_noedge_posedge,
              SetupLow        => tsetup_scanread_scanclk_noedge_posedge,
              HoldHigh        => thold_scanread_scanclk_noedge_posedge,
              HoldLow         => thold_scanread_scanclk_noedge_posedge,
--                    CheckEnabled    => TO_X01( (NOT ena_ipd) ) /= '1',
              RefTransition   => '/',
              HeaderMsg       => InstancePath & "/stratixii_pll",
              XOn             => XOnChecks,
              MsgOn           => MsgOnChecks );
 
         VitalSetupHoldCheck (
              Violation       => Tviol_scanwrite_scanclk,
              TimingData      => TimingData_scanwrite_scanclk,
              TestSignal      => scanwrite_ipd,
              TestSignalName  => "scanwrite",
              RefSignal       => scanclk_ipd,
              RefSignalName   => "scanclk",
              SetupHigh       => tsetup_scanwrite_scanclk_noedge_posedge,
              SetupLow        => tsetup_scanwrite_scanclk_noedge_posedge,
              HoldHigh        => thold_scanwrite_scanclk_noedge_posedge,
              HoldLow         => thold_scanwrite_scanclk_noedge_posedge,
--                    CheckEnabled    => TO_X01( (NOT ena_ipd) ) /= '1',
              RefTransition   => '/',
              HeaderMsg       => InstancePath & "/stratixii_pll",
              XOn             => XOnChecks,
              MsgOn           => MsgOnChecks );
 
      end if;

        if (scanclk_ipd'event and scanclk_ipd = '0') then
            -- enable scanwrite on falling edge
            scanwrite_enabled <= scanwrite_reg;
        end if;

        if (scanread_reg = '1') then
            gated_scanclk <= transport scanclk_ipd and scanread_reg;
        else
            gated_scanclk <= transport '1';
        end if;

        if (scanclk_ipd'event and scanclk_ipd = '1') then
            -- register scanread and scanwrite
            scanread_reg <= scanread_ipd;
            scanwrite_reg <= scanwrite_ipd;

            if (got_first_scanclk) then
                scanclk_period := now - scanclk_last_rising_edge;
            else
                got_first_scanclk := true;
            end if;
            -- reset got_first_scanclk on falling edge of scanread_reg
            if (scanread_ipd = '0' and scanread_reg = '1') then
                got_first_scanclk := false;
                got_first_gated_scanclk := false;
            end if;

            scanclk_last_rising_edge := now;
        end if;
   
        if (gated_scanclk'event and gated_scanclk = '1' and now > 0 ps) then
            if (not got_first_gated_scanclk) then
                got_first_gated_scanclk := true;
            end if;
            for j in scan_chain_length - 1 downto 1 loop
                scan_data(j) <= scan_data(j-1);
            end loop;
            scan_data(0) <= scandata_ipd;
        end if;
    end process;

    scandataout_tmp <= scan_data(FAST_SCAN_CHAIN-1) when (pll_type = "fast" or pll_type = "lvds") else scan_data(GPP_SCAN_CHAIN-1);


    SCHEDULE : process (schedule_vco, areset_ipd, ena_ipd, pfdena_ipd, refclk, fbclk, vco_out)
    variable sched_time : time := 0 ps;

    TYPE time_array is ARRAY (0 to 7) of time;
    variable init : boolean := true;
    variable refclk_period : time;
    variable m_times_vco_period : time;
    variable new_m_times_vco_period : time;

    variable phase_shift : time_array := (OTHERS => 0 ps);
    variable last_phase_shift : time_array := (OTHERS => 0 ps);

    variable l_index : integer := 1;
    variable cycle_to_adjust : integer := 0;

    variable stop_vco : boolean := false;

    variable locked_tmp : std_logic := '0';
    variable pll_is_locked : boolean := false;
    variable pll_about_to_lock : boolean := false;
    variable cycles_to_lock : integer := 0;
    variable cycles_to_unlock : integer := 0;

    variable got_first_refclk : boolean := false;
    variable got_second_refclk : boolean := false;
    variable got_first_fbclk : boolean := false;

    variable refclk_time : time := 0 ps;
    variable fbclk_time : time := 0 ps;
    variable first_fbclk_time : time := 0 ps;

    variable fbclk_period : time := 0 ps;

    variable first_schedule : boolean := true;

    variable vco_val : std_logic := '0';
    variable vco_period_was_phase_adjusted : boolean := false;
    variable phase_adjust_was_scheduled : boolean := false;

    variable loop_xplier : integer;
    variable loop_initial : integer := 0;
    variable loop_ph : integer := 0;
    variable loop_time_delay : integer := 0;

    variable initial_delay : time := 0 ps;
    variable vco_per : time;
    variable tmp_rem : integer;
    variable my_rem : integer;
    variable fbk_phase : integer := 0;

    variable pull_back_M : integer := 0;
    variable total_pull_back : integer := 0;
    variable fbk_delay : integer := 0;

    variable offset : time := 0 ps;

    variable tmp_vco_per : integer := 0;
    variable high_time : time;
    variable low_time : time;

    variable got_refclk_posedge : boolean := false;
    variable got_fbclk_posedge : boolean := false;
    variable inclk_out_of_range : boolean := false;
    variable no_warn : boolean := false;

    variable ext_fbk_cntr_modulus : integer := 1;
    variable init_clks : boolean := true;
    variable pll_is_in_reset : boolean := false;
    variable pll_is_disabled : boolean := false;
    variable next_vco_sched_time : time  := 0 ps;
    variable tap0_is_active : boolean := true;

    begin
        if (init) then

            -- jump-start the VCO
            -- add 1 ps delay to ensure all signals are updated to initial
            -- values
            schedule_vco <= transport not schedule_vco after 1 ps;

            init := false;
        end if;

        if (schedule_vco'event) then
            if (init_clks) then
                refclk_period := inclk0_input_frequency * n_val(0) * 1 ps;

                m_times_vco_period := refclk_period;
                new_m_times_vco_period := refclk_period;
                init_clks := false;
            end if;
            sched_time := 0 ps;
            for i in 0 to 7 loop
                last_phase_shift(i) := phase_shift(i);
            end loop;
            cycle_to_adjust := 0;
            l_index := 1;
            m_times_vco_period := new_m_times_vco_period;
        end if;

        -- areset was asserted
        if (areset_ipd'event and areset_ipd = '1') then
            assert false report family_name & " PLL was reset" severity note;
            -- reset lock parameters
            locked_tmp := '0';
            pll_is_locked := false;
            pll_about_to_lock := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;
            pll_is_in_reset := true;
            tap0_is_active := false;
            for x in 0 to 7 loop
                vco_tap(x) <= '0';
            end loop;
        end if;

        -- note areset deassert time
        -- note it as refclk_time to prevent false triggering
        -- of stop_vco after areset
        if (areset_ipd'event and areset_ipd = '0' and pll_is_in_reset) then
            refclk_time := now;
            pll_is_in_reset := false;
            if (ena_ipd = '1' and not stop_vco and next_vco_sched_time <= now) then
                schedule_vco <= not schedule_vco;
            end if;
        end if;

        -- ena was deasserted
        if (ena_ipd'event and ena_ipd = '0') then
            assert false report family_name & " PLL was disabled" severity note;
            pll_is_disabled := true;
            tap0_is_active := false;
            for x in 0 to 7 loop
                vco_tap(x) <= '0';
            end loop;
        end if;

        if (ena_ipd'event and ena_ipd = '1') then
            assert false report family_name & " PLL is enabled" severity note;
            pll_is_disabled := false;
            if (areset_ipd /= '1' and not stop_vco and next_vco_sched_time < now) then
                schedule_vco <= not schedule_vco;
            end if;
        end if;

        -- illegal value on areset_ipd
        if (areset_ipd'event and areset_ipd = 'X') then
            assert false report "Illegal value 'X' detected on ARESET input" severity warning;
        end if;

        if (areset_ipd = '1' or ena_ipd = '0' or stop_vco) then

            -- reset lock parameters
            locked_tmp := '0';
            pll_is_locked := false;
            pll_about_to_lock := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;

            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := 0 ps;
            got_first_fbclk := false;
            fbclk_time := 0 ps;
            first_fbclk_time := 0 ps;
            fbclk_period := 0 ps;

--            first_schedule := true;
--            vco_val := '0';
            vco_period_was_phase_adjusted := false;
            phase_adjust_was_scheduled := false;

            -- reset all counter phase taps to POF programmed values
        end if;

        if (schedule_vco'event and areset_ipd /= '1' and ena_ipd /= '0' and (not stop_vco) and now > 0 ps) then


            -- calculate loop_xplier : this will be different from m_val
            -- in external_feedback_mode
            loop_xplier := m_val(0);
            loop_initial := m_initial_val - 1;
            loop_ph := m_ph_val;

            if (operation_mode = "external_feedback") then
                if (ext_fbk_cntr_mode = "bypass") then
                    ext_fbk_cntr_modulus := 1;
                else
                    ext_fbk_cntr_modulus := ext_fbk_cntr_high + ext_fbk_cntr_low;
                end if;
                loop_xplier := m_val(0) * (ext_fbk_cntr_modulus);
                loop_ph := ext_fbk_cntr_ph;
                loop_initial := ext_fbk_cntr_initial - 1 + ((m_initial_val - 1) * ext_fbk_cntr_modulus);
            end if;

            -- convert initial value to delay
            initial_delay := (loop_initial * m_times_vco_period)/loop_xplier;

            -- convert loop ph_tap to delay
            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            tmp_vco_per := (m_times_vco_period/1 ps) / loop_xplier;
            if (my_rem /= 0) then
                tmp_vco_per := tmp_vco_per + 1;
            end if;
            fbk_phase := (loop_ph * tmp_vco_per)/8;

            if (operation_mode = "external_feedback") then
                pull_back_M :=  (m_initial_val - 1) * ext_fbk_cntr_modulus * ((refclk_period/loop_xplier)/1 ps);
                while (pull_back_M > refclk_period/1 ps) loop
                    pull_back_M := pull_back_M - refclk_period/ 1 ps;
                end loop;
            else
                pull_back_M := initial_delay/1 ps + fbk_phase;
            end if;

            total_pull_back := pull_back_M;

            if (simulation_type = "timing") then
                total_pull_back := total_pull_back + pll_compensation_delay;
            end if;
            while (total_pull_back > refclk_period/1 ps) loop
                total_pull_back := total_pull_back - refclk_period/1 ps;
            end loop;

            if (total_pull_back > 0) then
                offset := refclk_period - (total_pull_back * 1 ps);
            end if;
            if (operation_mode = "external_feedback") then
                fbk_delay := pull_back_M;
                if (simulation_type = "timing") then
                    fbk_delay := fbk_delay + pll_compensation_delay;
                end if;
            else
                fbk_delay := total_pull_back - fbk_phase;
                if (fbk_delay < 0) then
                    offset := offset - (fbk_phase * 1 ps);
                    fbk_delay := total_pull_back;
                end if;
            end if;

            -- assign m_delay
            m_delay <= transport fbk_delay after 1 ps;

            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            for i in 1 to loop_xplier loop
                -- adjust cycles
                tmp_vco_per := (m_times_vco_period/1 ps)/loop_xplier;
                if (my_rem /= 0 and l_index <= my_rem) then
                    tmp_rem := (loop_xplier * l_index) rem my_rem;
                    cycle_to_adjust := (loop_xplier * l_index) / my_rem;
                    if (tmp_rem /= 0) then
                        cycle_to_adjust := cycle_to_adjust + 1;
                    end if;
                end if;
                if (cycle_to_adjust = i) then
                    tmp_vco_per := tmp_vco_per + 1;
                    l_index := l_index + 1;
                end if;

                -- calculate high and low periods
                vco_per := tmp_vco_per * 1 ps;
                high_time := (tmp_vco_per/2) * 1 ps;
                if (tmp_vco_per rem 2 /= 0) then
                    high_time := high_time + 1 ps;
                end if;
                low_time := vco_per - high_time;

                -- schedule the rising and falling edges
                for j in 1 to 2 loop
                    vco_val := not vco_val;
                    if (vco_val = '0') then
                        sched_time := sched_time + high_time;
                    elsif (vco_val = '1') then
                        sched_time := sched_time + low_time;
                    end if;

                    -- schedule tap0
                    vco_out(0) <= transport vco_val after sched_time;
                end loop;
            end loop;

            -- schedule once more
            if (first_schedule) then
                vco_val := not vco_val;
                if (vco_val = '0') then
                    sched_time := sched_time + high_time;
                elsif (vco_val = '1') then
                    sched_time := sched_time + low_time;
                end if;
                -- schedule tap 0
                vco_out(0) <= transport vco_val after sched_time;

                first_schedule := false;
            end if;

            schedule_vco <= transport not schedule_vco after sched_time;
            next_vco_sched_time := now + sched_time;

            if (vco_period_was_phase_adjusted) then
                m_times_vco_period := refclk_period;
                new_m_times_vco_period := refclk_period;
                vco_period_was_phase_adjusted := false;
                phase_adjust_was_scheduled := true;

                vco_per := m_times_vco_period/loop_xplier;
                for k in 0 to 7 loop
                    phase_shift(k) := (k * vco_per)/8;
                end loop;
            end if;
        end if;

        -- now schedule the other taps with the appropriate phase-shift
        if (vco_out(0)'event) then
            for k in 1 to 7 loop
                phase_shift(k) := (k * vco_per)/8;
                vco_out(k) <= transport vco_out(0) after phase_shift(k);
            end loop;
        end if;

        if (refclk'event and refclk = '1' and areset_ipd = '0') then
            got_refclk_posedge := true;
            if (not got_first_refclk) then
                got_first_refclk := true;
            else
                got_second_refclk := true;
                refclk_period := now - refclk_time;

                -- check if incoming freq. will cause VCO range to be
                -- exceeded
                if ( (vco_max /= 0 and vco_min /= 0 and pfdena_ipd = '1') and
                    (((refclk_period/1 ps)/loop_xplier > vco_max) or
                    ((refclk_period/1 ps)/loop_xplier < vco_min)) ) then
                    if (pll_is_locked) then
                        assert false report " Input clock freq. is not within VCO range : " & family_name & " PLL may lose lock" severity warning;
                        if (inclk_out_of_range) then
                            pll_is_locked := false;
                            locked_tmp := '0';
                            pll_about_to_lock := false;
                            cycles_to_lock := 0;
                            vco_period_was_phase_adjusted := false;
                            phase_adjust_was_scheduled := false;
                            assert false report family_name & " PLL lost lock." severity note;
                        end if;
                    elsif (not no_warn) then
                        assert false report " Input clock freq. is not within VCO range : " & family_name & " PLL may not lock. Please use the correct frequency." severity warning;
                        no_warn := true;
                    end if;
                    inclk_out_of_range := true;
                else
                    inclk_out_of_range := false;
                end if;
            end if;

            if (stop_vco) then
                stop_vco := false;
                schedule_vco <= not schedule_vco;
            end if;

            refclk_time := now;
        else
            got_refclk_posedge := false;
        end if;

        if (fbclk'event and fbclk = '1') then
            got_fbclk_posedge := true;
            if (not got_first_fbclk) then
                got_first_fbclk := true;
            else
                fbclk_period := now - fbclk_time;
            end if;

            -- need refclk_period here, so initialized to proper value above
            if ( ( (now - refclk_time > 1.5 * refclk_period) and pfdena_ipd = '1' and pll_is_locked) or ( (now - refclk_time > 5 * refclk_period) and pfdena_ipd = '1') ) then
                stop_vco := true;
                -- reset
                got_first_refclk := false;
                got_first_fbclk := false;
                got_second_refclk := false;
                if (pll_is_locked) then
                    pll_is_locked := false;
                    locked_tmp := '0';
                    assert false report family_name & " PLL lost lock due to loss of input clock" severity note;
                end if;
                pll_about_to_lock := false;
                cycles_to_lock := 0;
                cycles_to_unlock := 0;
                first_schedule := true;
                vco_period_was_phase_adjusted := false;
                phase_adjust_was_scheduled := false;
                tap0_is_active := false;
                for x in 0 to 7 loop
                    vco_tap(x) <= '0';
                end loop;
            end if;
            fbclk_time := now;
        else
            got_fbclk_posedge := false;
        end if;

        if ((got_refclk_posedge or got_fbclk_posedge) and got_second_refclk and pfdena_ipd = '1' and (not inclk_out_of_range)) then

            -- now we know actual incoming period
            if ( abs(fbclk_time - refclk_time) <= 5 ps or
                (got_first_fbclk and abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5 ps)) then
                -- considered in phase
                if (cycles_to_lock = valid_lock_multiplier - 1) then
                    pll_about_to_lock := true;
                end if;
                if (cycles_to_lock = valid_lock_multiplier) then
                    if (not pll_is_locked) then
                        assert false report family_name & " PLL locked to incoming clock" severity note;
                    end if;
                    pll_is_locked := true;
                    locked_tmp := '1';
                    cycles_to_unlock := 0;
                end if;
                -- increment lock counter only if second part of above
                -- time check is NOT true
                if (not(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5 ps)) then
                    cycles_to_lock := cycles_to_lock + 1;
                end if;

                -- adjust m_times_vco_period
                new_m_times_vco_period := refclk_period;
            else
                -- if locked, begin unlock
                if (pll_is_locked) then
                    cycles_to_unlock := cycles_to_unlock + 1;
                    if (cycles_to_unlock = invalid_lock_multiplier) then
                        pll_is_locked := false;
                        locked_tmp := '0';
                        pll_about_to_lock := false;
                        cycles_to_lock := 0;
                        vco_period_was_phase_adjusted := false;
                        phase_adjust_was_scheduled := false;
                        assert false report family_name & " PLL lost lock." severity note;
                    end if;
                end if;
                if ( abs(refclk_period - fbclk_period) <= 2 ps ) then
                    -- frequency is still good
                    if (now = fbclk_time and (not phase_adjust_was_scheduled)) then
                        if ( abs(fbclk_time - refclk_time) > refclk_period/2) then
                            if ( abs(fbclk_time - refclk_time) > 1.5 * refclk_period) then
                                -- input clock may have stopped : do nothing
                            else
                            new_m_times_vco_period := m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                            vco_period_was_phase_adjusted := true;
                            end if;
                        else
                            new_m_times_vco_period := m_times_vco_period - abs(fbclk_time - refclk_time);
                            vco_period_was_phase_adjusted := true;
                        end if;

                    end if;
                else
                    phase_adjust_was_scheduled := false;
                    new_m_times_vco_period := refclk_period;
                end if;

            end if;
        end if;

        -- check which vco_tap has event
        for x in 0 to 7 loop
            if (vco_out(x) /= vco_out_last_value(x)) then
                -- TAP X has event
                if (x = 0 and areset_ipd = '0' and ena_ipd = '1' and sig_stop_vco = '0') then
                    if (vco_out(0) = '1') then
                        tap0_is_active := true;
                    end if;
                    if (tap0_is_active) then
                        vco_tap(0) <= vco_out(0);
                    end if;
                elsif (tap0_is_active) then
                        vco_tap(x) <= vco_out(x);
                end if;
                if (sig_stop_vco = '1') then
                    vco_tap(x) <= '0';
                end if;
                vco_out_last_value(x) <= vco_out(x);
            end if;
        end loop;
        
        if (pfdena_ipd = '0') then
            if (pll_is_locked) then
                locked_tmp := 'X';
            end if;
            pll_is_locked := false;
            cycles_to_lock := 0;
        end if;

        -- give message only at time of deassertion
        if (pfdena_ipd'event and pfdena_ipd = '0') then
            assert false report "PFDENA deasserted." severity note;
        elsif (pfdena_ipd'event and pfdena_ipd = '1') then
            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := now;
        end if;

        if (reconfig_err) then
            lock <= '0';
        else
            lock <= locked_tmp;
        end if;
        about_to_lock <= pll_about_to_lock after 1 ps;

        -- signal to calculate quiet_time
        sig_refclk_period <= refclk_period;

        if (stop_vco = true) then
            sig_stop_vco <= '1';
        else
            sig_stop_vco <= '0';
        end if;
    end process SCHEDULE;

    clk0_tmp <= c_clk(i_clk0_counter);
    clk(0)   <= clk0_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    clk1_tmp <= c_clk(i_clk1_counter);
    clk(1)   <= clk1_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    clk2_tmp <= c_clk(i_clk2_counter);
    clk(2)   <= clk2_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    clk3_tmp <= c_clk(i_clk3_counter);
    clk(3)   <= clk3_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    clk4_tmp <= c_clk(i_clk4_counter);
    clk(4)   <= clk4_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    clk5_tmp <= c_clk(i_clk5_counter);
    clk(5)   <= clk5_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    sclkout(0) <= sclkout0_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    sclkout(1) <= sclkout1_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    enable0 <= enable0_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';
    enable1 <= enable1_tmp when (areset_ipd = '1' or ena_ipd = '0' or pll_in_test_mode) or (about_to_lock and (not reconfig_err)) else
                'X';

    scandataout <= scandataout_tmp;
    scandone <= scandone_tmp;

end vital_pll;
-- END ARCHITECTURE VITAL_PLL
--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixii_mac_bit_register
--
-- Description : a single bit register. This is used for registering all
--               single bit input ports.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_bit_register IS
    GENERIC (
             power_up :  std_logic := '0';
             tipd_data : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clk_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst);
   PORT (
         data : IN std_logic := '0';   
         clk : IN std_logic := '0';   
         aclr : IN std_logic := '0';
         if_aclr : IN std_logic := '0';
         ena : IN std_logic := '1';
         async : IN std_logic := '1';
         dataout : OUT std_logic :=  '0'
        );   
END stratixii_mac_bit_register;

ARCHITECTURE arch OF stratixii_mac_bit_register IS

    SIGNAL data_ipd : std_logic := '0';   
    SIGNAL clk_ipd : std_logic := '0';   
    SIGNAL aclr_ipd : std_logic := '0';   
    SIGNAL ena_ipd : std_logic := '1';   
    SIGNAL dataout_reg : std_logic := '0';   
    SIGNAL viol_notifier : std_logic := '0';   
    SIGNAL data_dly : std_logic := '0';   

BEGIN

    WireDelay : block
    begin
        VitalWireDelay (data_ipd, data, tipd_data);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    clk_delay: process (data_ipd)
        begin
            data_dly <= data_ipd;
        end process;

    PROCESS (data_dly, clk_ipd, aclr_ipd, ena_ipd, async)
    variable dataout_reg       : STD_LOGIC := '0';
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    variable Tviol_clk_ena     : STD_ULOGIC := '0';
    variable Tviol_data_clk    : STD_ULOGIC := '0';
    variable TimingData_clk_ena : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_data_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena         : STD_ULOGIC := '0';
    variable PeriodData_ena    : VitalPeriodDataType := VitalPeriodDataInit;
    BEGIN
        if(async = '1') then
            dataout_reg := data_dly;
        else
           if (if_aclr = '1') then
               IF (aclr_ipd = '1') THEN
                   dataout_reg := '0';    
               ELSIF (clk_ipd'EVENT AND clk_ipd = '1') THEN
                   IF (ena_ipd = '1') THEN
                       dataout_reg := data_dly;    
                   ELSE
                       dataout_reg := dataout_reg;    
                   END IF;
               END IF;
           else
               IF (clk_ipd'EVENT AND clk_ipd = '1') THEN
                   IF (ena_ipd = '1') THEN
                       dataout_reg := data_dly;    
                   ELSE
                       dataout_reg := dataout_reg;    
                   END IF;
               END IF;
           end if;
        end if;

        VitalPathDelay01 (
            OutSignal     => dataout,
            OutSignalName => "dataout",
            OutTemp       => dataout_reg,
            Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
            1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
            GlitchData    => dataout_VitalGlitchData,
            Mode          => DefGlitchMode,
            XOn           => TRUE,
            MsgOn         => TRUE );
    END PROCESS;
END arch;
--/////////////////////////////////////////////////////////////////////////////
--
--                              STRATIXII_MAC_REGISTER
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_register IS
   GENERIC (
      data_width      :  integer := 18;    
      power_up        :  std_logic := '0';
      tipd_data       : VitalDelayArrayType01(143 downto 0) := (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge  : VitalDelayArrayType01(143 downto 0) := (OTHERS => DefPropDelay01);
      tpd_clk_dataout_posedge   : VitalDelayArrayType01(143 downto 0) := (OTHERS => DefPropDelay01);
      tsetup_data_clk_noedge_posedge : VitalDelayArrayType(143 downto 0) := (OTHERS => DefSetupHoldCnst);
      thold_data_clk_noedge_posedge : VitalDelayArrayType(143 downto 0) := (OTHERS => DefSetupHoldCnst);
      tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst);
   PORT (
      data                    : IN std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
      clk                     : IN std_logic := '0';   
      aclr                    : IN std_logic := '0';
      if_aclr                 : IN std_logic := '0';
      ena                     : IN std_logic := '1';
      async                   : IN std_logic := '1';
      dataout                 : OUT std_logic_vector(data_width -1 DOWNTO 0) := (others => '0'));   
END stratixii_mac_register;

ARCHITECTURE arch OF stratixii_mac_register IS

   SIGNAL data_ipd                 :  std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL clk_ipd                  :  std_logic := '0';   
   SIGNAL aclr_ipd                 :  std_logic := '0';   
   SIGNAL ena_ipd                  :  std_logic := '1';   
   SIGNAL dataout_reg              :  std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL viol_notifier            :  std_logic := '0';   

BEGIN

  WireDelay : block
  begin
    g1 : for i in data'range generate
      VitalWireDelay (data_ipd(i), data(i), tipd_data(i));
    end generate;
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
  end block;

  PROCESS (data_ipd, clk_ipd, aclr_ipd, ena_ipd, async)
     variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(143 downto 0);
     variable Tviol_clk_ena     : STD_ULOGIC := '0';
     variable Tviol_data_clk    : STD_ULOGIC := '0';
     variable TimingData_clk_ena : VitalTimingDataType := VitalTimingDataInit;
     variable TimingData_data_clk : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_ena         : STD_ULOGIC := '0';
     variable PeriodData_ena    : VitalPeriodDataType := VitalPeriodDataInit;
   BEGIN
     if(async = '1') then
       dataout_reg <= data_ipd;
     else
       if (if_aclr = '1') then
         IF (aclr_ipd = '1') THEN
           dataout_reg <= (others => '0');
         ELSIF (clk_ipd'EVENT AND clk_ipd = '1') THEN
           IF (ena_ipd = '1') THEN
             dataout_reg <= data_ipd;    
           ELSE
             dataout_reg <= dataout_reg;    
           END IF;
         END IF;
       else
         IF (clk_ipd'EVENT AND clk_ipd = '1') THEN
           IF (ena_ipd = '1') THEN
             dataout_reg <= data_ipd;    
           ELSE
             dataout_reg <= dataout_reg;    
           END IF;
         END IF;
       end if;
     end if;
   END PROCESS;

  PathDelay : block
  begin
    g1 : for i in dataout'range generate
      PROCESS (dataout_reg(i))
        variable dataout_VitalGlitchData : VitalGlitchDataType;
      begin
        VitalPathDelay01 (
          OutSignal     => dataout(i),
          OutSignalName => "dataout",
          OutTemp       => dataout_reg(i),
          Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge(i), TRUE),
                            1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge(i), TRUE)),
          GlitchData    => dataout_VitalGlitchData,
          Mode          => DefGlitchMode,
          XOn           => TRUE,
          MsgOn         => TRUE );
      end process;
    end generate;
  end block;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                              STRATIXII_MAC_RS_BLOCK
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_rs_block IS
   GENERIC (
     tpd_saturate_dataout           : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
     tpd_round_dataout              : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
     block_type                     :  string := "mac_mult";    
     dataa_width                    :  integer := 18;    
     datab_width                    :  integer := 18);
   PORT (
      operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      round                   : IN std_logic := '0';   
      saturate                : IN std_logic := '0';   
      addnsub                 : IN std_logic := '0';   
      signa                   : IN std_logic := '0';   
      signb                   : IN std_logic := '0';   
      signsize                : IN std_logic_vector(7 DOWNTO 0) := (others => '0');   
      roundsize               : IN std_logic_vector(7 DOWNTO 0) := (others => '0');   
      dataoutsize             : IN std_logic_vector(7 DOWNTO 0) := (others => '0');   
      dataa                   : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');   
      datab                   : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');   
      datain                  : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0'));   
END stratixii_mac_rs_block;

ARCHITECTURE arch OF stratixii_mac_rs_block IS

   SIGNAL round_ipd                :  std_logic := '0';   
   SIGNAL saturate_ipd             :  std_logic := '0';   
   SIGNAL addnsub_ipd              :  std_logic := '0';   
   SIGNAL signa_ipd                :  std_logic := '0';   
   SIGNAL signb_ipd                :  std_logic := '0';   
   SIGNAL dataa_ipd                :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datab_ipd                :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datain_ipd               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tbuf             :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL rs_saturate              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL rs_mac_mult              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL rs_mac_out               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_round            :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_saturate         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dly              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL saturated                :  std_logic := '0';   
   SIGNAL min                      :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL max                      :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL msb                      :  std_logic := '0';   
   SIGNAL dataout_tmp1            :  std_logic_vector(71 DOWNTO 0) := (others => '0');   

BEGIN
   round_ipd <= round ;   
   saturate_ipd <= saturate ;   
   addnsub_ipd <= addnsub ;   
   signa_ipd <= signa ;   
   signb_ipd <= signb ;   
   dataa_ipd(dataa_width-1 downto 0) <= dataa;   
   datab_ipd(datab_width-1 downto 0) <= datab;   
   datain_ipd(71 downto 0) <= datain(71 downto 0) ;   
   PROCESS (datain_ipd,
            signa_ipd,
            signb_ipd,
            addnsub_ipd,
            round_ipd)
      VARIABLE dataout_round_tmp2  : std_logic_vector(71 DOWNTO 0);
   BEGIN
      IF (round_ipd = '1') THEN
        dataout_round_tmp2 := datain_ipd + (2 **(conv_integer(dataoutsize - signsize - roundsize - "00000001")));    
      ELSE
        dataout_round_tmp2 := datain_ipd;    
      END IF;
      dataout_round <= dataout_round_tmp2;
   END PROCESS;
   PROCESS (datain_ipd,
            signa_ipd,
            signb_ipd,
            round_ipd,
            saturate_ipd,
            addnsub_ipd,
            dataout_round)
      VARIABLE dataout_saturate_tmp3  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE saturated_tmp4  : std_logic := '0';
      VARIABLE gnd  	 : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE min_tmp5  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE max_tmp6  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE msb_tmp7  : std_logic := '0';
      VARIABLE i         :  integer;
   BEGIN
      IF (saturate_ipd = '1') THEN
         IF (block_type = "mac_mult") THEN
            IF (dataout_round(dataa_width + datab_width - 1) = '0' AND dataout_round(dataa_width + datab_width - 2) = '1') THEN
               dataout_saturate_tmp3 := "111111111111111111111111111111111111111111111111111111111111111111111111";  
               FOR i IN dataa_width + datab_width - 2 TO (72 - 1) LOOP
                  dataout_saturate_tmp3(i) := '0';    
               END LOOP;
               saturated_tmp4 := '1';    
            ELSE
               dataout_saturate_tmp3 := dataout_round;
               saturated_tmp4 := '0';    
            END IF;
            min_tmp5 := dataout_saturate_tmp3;
            max_tmp6 := dataout_saturate_tmp3;
         ELSE
           IF ((operation(2) = '1') AND ((block_type = "ab") OR (block_type = "cd"))) THEN
             saturated_tmp4 := '0';    
             i := datab_width - 2;
             WHILE (i < (datab_width + signsize - 2)) LOOP
               IF (dataout_round(datab_width - 2) /= dataout_round(i)) THEN
                 saturated_tmp4 := '1';    
               END IF;
               i := i + 1;
             END LOOP;
             IF (saturated_tmp4 = '1') THEN
               min_tmp5 := "111111111111111111111111111111111111111111111111111111111111111111111111";  
               max_tmp6 := "111111111111111111111111111111111111111111111111111111111111111111111111";  
               FOR i IN 0 TO ((datab_width - 2) - 1) LOOP
                 max_tmp6(i) := '0';    
               END LOOP;
               FOR i IN datab_width - 2 TO (72 - 1) LOOP
                 min_tmp5(i) := '0';    
               END LOOP;
             ELSE
               dataout_saturate_tmp3 := dataout_round;
             END IF;
             msb_tmp7 := dataout_round(datab_width + 15);    
           ELSE
             IF ((signa_ipd OR signb_ipd OR NOT addnsub_ipd) = '1') THEN
               min_tmp5 := gnd + (2 **(conv_integer(dataa_width)));
               max_tmp6 := gnd + ((2 **(conv_integer(dataa_width))) - 1);
             ELSE
               min_tmp5 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
               max_tmp6 := gnd + ((2 **(conv_integer(dataa_width + 1))) - 1);
             END IF;
             saturated_tmp4 := '0';    
             i := dataa_width - 2;
             WHILE (i < (dataa_width + signsize - 1)) LOOP
               IF (dataout_round(dataa_width - 2) /= dataout_round(i)) THEN
                 saturated_tmp4 := '1';    
               END IF;
               i := i + 1;
             END LOOP;
             msb_tmp7 := dataout_round(i);    
           END IF;
           IF (saturated_tmp4 = '1') THEN
             IF (msb_tmp7 = '1') THEN
               dataout_saturate_tmp3 := max_tmp6;    
             ELSE
               dataout_saturate_tmp3 := min_tmp5;    
             END IF;
           ELSE
             dataout_saturate_tmp3 := dataout_round;    
           END IF;
         END IF;
      ELSE
        saturated_tmp4 := '0';    
        dataout_saturate_tmp3 := dataout_round;    
      END IF;
      dataout_saturate <= dataout_saturate_tmp3;
      saturated <= saturated_tmp4;
      min <= min_tmp5;
      max <= max_tmp6;
      msb <= msb_tmp7;
   END PROCESS;

   PROCESS (datain_ipd,
            signa_ipd,
            signb_ipd,
            round_ipd,
            saturate_ipd,
            dataout_round,
            dataout_saturate)
      VARIABLE dataout_dly_tmp8 : std_logic_vector(71 DOWNTO 0);
      VARIABLE i                :  integer;
      VARIABLE width_tmp : integer;
      
   BEGIN
      IF (round_ipd = '1') THEN
         dataout_dly_tmp8 := dataout_saturate;     
         width_tmp := conv_integer(dataoutsize) - conv_integer(signsize) - conv_integer(roundsize);
         i := 0;
         WHILE (i < width_tmp) LOOP
            dataout_dly_tmp8(i) := '0';    
            i := i + 1;
         END LOOP;
      ELSE
         dataout_dly_tmp8 := dataout_saturate;    
      END IF;
      dataout_dly <= dataout_dly_tmp8;
   END PROCESS;
   dataout_tbuf <= datain WHEN (operation = 0) OR (operation = 7) ELSE rs_saturate ;
   rs_saturate <= rs_mac_mult WHEN (saturate_ipd = '1') ELSE rs_mac_out ;
   rs_mac_mult <= (dataout_dly(71 DOWNTO 3) & "00" & saturated)
                  WHEN ((saturate_ipd = '1') AND (saturated = '1') AND (block_type = "mac_mult")) ELSE rs_mac_out ;
   rs_mac_out <= (dataout_dly(71 DOWNTO 3) & saturated & datain_ipd(1 DOWNTO 0))
                 WHEN ((saturate_ipd = '1') AND (block_type /= "mac_mult")) ELSE dataout_dly ;

pathDelay : BLOCK
  BEGIN
    g1 : for i in dataout'range generate
   PROCESS (dataout_tbuf)
     		VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;
   BEGIN
     VitalPathDelay01 (
      		OutSignal     => dataout(i),
       OutSignalName => "dataout",
      		OutTemp       => dataout_tbuf(i),
      		Paths         => (0 => (round_ipd'last_event, tpd_round_dataout(i), TRUE),
      		                  1 => (saturate_ipd'last_event, tpd_saturate_dataout(i), TRUE)),
      		GlitchData    => dataout_VitalGlitchData,
       Mode          => DefGlitchMode,
       XOn           => TRUE,
       MsgOn         => TRUE );
		END PROCESS;
	END GENERATE;
END BLOCK;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                         STRATIXII_MAC_MULT_INTERNAL
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_mult_internal IS
   GENERIC (
      dataa_width                    :  integer := 18;    
      datab_width                    :  integer := 18;    
      dataout_width                  :  integer := 36;
      dynamic_mode                   :  string  := "no";
      tipd_dataa        : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
      tipd_datab        : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
      tpd_dataa_dataout : VitalDelayArrayType01(18*36-1 downto 0) := (others => DefPropDelay01);
      tpd_datab_dataout : VitalDelayArrayType01(18*36-1 downto 0) := (others => DefPropDelay01);
      tpd_signa_dataout : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
      tpd_signb_dataout : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
      tpd_dataa_scanouta   : VitalDelayArrayType01(18*18-1 downto 0) := (others => DefPropDelay01);
      tpd_datab_scanoutb   : VitalDelayArrayType01(18*18-1 downto 0) := (others => DefPropDelay01);
      XOn               : Boolean := DefGlitchXOn;     
      MsgOn             : Boolean := DefGlitchMsgOn
      );
   PORT (
      dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0) := (others => '0');   
      datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0) := (others => '0');   
      signa                   : IN std_logic := '0';   
      signb                   : IN std_logic := '0';   
      bypass                  : IN std_logic := '0';   
      scanouta                : OUT std_logic_vector(dataa_width - 1 DOWNTO 0) := (others => '0');   
      scanoutb                : OUT std_logic_vector(datab_width - 1 DOWNTO 0) := (others => '0');   
      dataout                 : OUT std_logic_vector(35 DOWNTO 0) := (others => '0')
      );   
END stratixii_mac_mult_internal;

ARCHITECTURE arch OF stratixii_mac_mult_internal IS

   SIGNAL dataa_ipd                :  std_logic_vector(17 DOWNTO 0) := (others => '0');   
   SIGNAL datab_ipd                :  std_logic_vector(17 DOWNTO 0) := (others => '0');   
   SIGNAL neg                      :  std_logic := '0';   
   SIGNAL dataout_pre_bypass       :  std_logic_vector((dataa_width+datab_width) -1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp              :  std_logic_vector((dataa_width+datab_width) -1 DOWNTO 0) := (others => '0');   
   SIGNAL abs_a                    :  std_logic_vector(dataa_width - 1 DOWNTO 0) := (others => '0');   
   SIGNAL abs_b                    :  std_logic_vector(datab_width - 1 DOWNTO 0) := (others => '0');   
   SIGNAL abs_output               :  std_logic_vector((dataa_width+datab_width) -1 DOWNTO 0) := (others => '0');   
   
BEGIN

    neg <= (dataa_ipd(dataa_width - 1) AND signa) XOR (datab_ipd(datab_width - 1) AND signb) ;
    abs_a <= (NOT dataa_ipd(dataa_width - 1 DOWNTO 0) + 1) WHEN (signa AND dataa_ipd(dataa_width - 1)) = '1' ELSE dataa_ipd(dataa_width - 1 DOWNTO 0) ;
    abs_b <= (NOT datab_ipd(datab_width - 1 DOWNTO 0) + 1) WHEN (signb AND datab_ipd(datab_width - 1)) = '1' ELSE datab_ipd(datab_width - 1 DOWNTO 0) ;
    abs_output((dataa_width + datab_width) - 1 DOWNTO 0) <= abs_a(dataa_width-1 downto 0) * abs_b(datab_width-1 downto 0) ;
    dataout_pre_bypass((dataa_width + datab_width) - 1 DOWNTO 0) <= (NOT abs_output + 1) WHEN neg = '1' ELSE abs_output ;
    dataout_tmp((dataa_width + datab_width) - 1 DOWNTO 0) <= datab(datab_width-1 downto 0) & dataa(dataa_width-1 downto 0) when ((dynamic_mode = "yes") and (bypass = '1')) else dataa(dataa_width-1 downto 0) & datab(datab_width-1 downto 0) WHEN (bypass = '1') ELSE dataout_pre_bypass ;

  PathDelay : block
  begin
    
       do:for i in dataout_tmp'range generate   
        process(dataout_tmp(i))
          VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;
        begin
          VitalPathDelay01 (
            OutSignal => dataout(i),
            OutSignalName => "dataout",
            OutTemp => dataout_tmp(i),
            Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout(i), TRUE),
                      1 => (datab_ipd'last_event, tpd_datab_dataout(i), TRUE),
                      2 => (signa'last_event, tpd_signa_dataout(i), TRUE),
                      3 => (signb'last_event, tpd_signb_dataout(i), TRUE)),
            GlitchData => dataout_VitalGlitchData,
            Mode => DefGlitchMode,
            MsgOn => FALSE,
            XOn  => TRUE
            );
        end process;
      end generate do;
      sa: for i in dataa'range generate   
        VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        PROCESS(dataa_ipd)
          variable scanouta_VitalGlitchData : VitalGlitchDataType;
        BEGIN
          VitalPathDelay01 (
            OutSignal => scanouta(i),
            OutSignalName => "scanouta",
            OutTemp => dataa_ipd(i),
            Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta(i), TRUE)),
            GlitchData => scanouta_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
            );
        end process;
      end generate sa;
      sb: for i in datab'range generate      
        VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        PROCESS(datab_ipd)
          variable scanoutb_VitalGlitchData : VitalGlitchDataType;
        BEGIN
          VitalPathDelay01 (
            OutSignal => scanoutb(i),
            OutSignalName => "scanoutb",
            OutTemp => datab_ipd(i),
            Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb(i), TRUE)),
            GlitchData => scanoutb_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
            );
        end process;
      end generate sb;
  end block;

END arch;
--/////////////////////////////////////////////////////////////////////////////
--
--                              STRATIXII_MAC_MULT
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
use work.stratixii_mac_mult_internal;
use work.stratixii_mac_bit_register;
use work.stratixii_mac_register;
use work.stratixii_mac_rs_block;

ENTITY stratixii_mac_mult IS
   GENERIC (
      dataa_width                    :  integer := 18;    
      datab_width                    :  integer := 18;
      dataa_clock                    :  string := "none";    
      datab_clock                    :  string := "none";    
      signa_clock                    :  string := "none";    
      signb_clock                    :  string := "none";    
      round_clock                    :  string := "none";    
      saturate_clock                 :  string := "none";    
      output_clock                   :  string := "none";    
      round_clear                    :  string := "none";    
      saturate_clear                 :  string := "none";    
      dataa_clear                    :  string := "none";    
      datab_clear                    :  string := "none";    
      signa_clear                    :  string := "none";    
      signb_clear                    :  string := "none";    
      output_clear                   :  string := "none";    
      bypass_multiplier              :  string := "no";    
      mode_clock                     :  string := "none";    
      zeroacc_clock                  :  string := "none";
      mode_clear                     :  string := "none";
      zeroacc_clear                  :  string := "none";    
      signa_internally_grounded      :  string := "false";    
      signb_internally_grounded      :  string := "false";    
      lpm_hint                       :  string := "true";    
      lpm_type                       :  string := "stratixii_mac_mult";
      dynamic_mode                   :  string := "no");
   PORT (
      dataa                   : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '1');
      datab                   : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '1');
      scanina                 : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
      scaninb                 : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
      sourcea                 : IN std_logic := '0';   
      sourceb                 : IN std_logic := '0';   
      signa                   : IN std_logic := '1';   
      signb                   : IN std_logic := '1';   
      round                   : IN std_logic := '0';   
      saturate                : IN std_logic := '0';   
      clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');   
      mode                    : IN std_logic := '0';  
      zeroacc                 : IN std_logic := '0';   
      dataout                 : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0) := (others => '0');   
      scanouta                : OUT std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
      scanoutb                : OUT std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
      devclrn                 : IN std_logic := '1';
      devpor                  : IN std_logic := '1'
      );   
END stratixii_mac_mult;

ARCHITECTURE arch OF stratixii_mac_mult IS

   COMPONENT stratixii_mac_mult_internal
      GENERIC (
          dataout_width                  :  integer := 36;    
          dataa_width                    :  integer := 18;    
          datab_width                    :  integer := 18;
          dynamic_mode                   :  string  := "no";
          tipd_dataa        : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
          tipd_datab        : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
           tpd_dataa_dataout : VitalDelayArrayType01(18*36-1 downto 0) := (others => DefPropDelay01);
          tpd_datab_dataout : VitalDelayArrayType01(18*36-1 downto 0) := (others => DefPropDelay01);
          tpd_signa_dataout : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
          tpd_signb_dataout : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
          tpd_dataa_scanouta   : VitalDelayArrayType01(18*18-1 downto 0) := (others => DefPropDelay01);
          tpd_datab_scanoutb   : VitalDelayArrayType01(18*18-1 downto 0) := (others => DefPropDelay01);
          XOn               : Boolean := DefGlitchXOn;     
          MsgOn             : Boolean := DefGlitchMsgOn
          );
      PORT (
         dataa                   : IN  std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
         datab                   : IN  std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
         signa                   : IN  std_logic := '0';
         signb                   : IN  std_logic := '0';
         bypass                  : IN  std_logic := '0';
         scanouta                : OUT std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
         scanoutb                : OUT std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
         dataout                 : OUT std_logic_vector(35 DOWNTO 0));
   END COMPONENT;

   COMPONENT stratixii_mac_bit_register
      GENERIC (
          power_up                       :  std_logic := '0');
      PORT (
        data                    : IN std_logic := '0';   
        clk                     : IN std_logic := '0';   
        aclr                    : IN std_logic := '0';
        if_aclr                 : IN std_logic := '0';
        ena                     : IN std_logic := '1';
        async                   : IN std_logic := '1';
        dataout                 : OUT std_logic := '0');   
   END COMPONENT;

   COMPONENT stratixii_mac_register
      GENERIC (
          power_up                       :  std_logic := '0';    
          data_width                     :  integer := 18);
      PORT (
        data                    : IN std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
        clk                     : IN std_logic := '0';   
        aclr                    : IN std_logic := '0';
        if_aclr                 : IN std_logic := '0';
        ena                     : IN std_logic := '1';
        async                   : IN std_logic := '1';
        dataout                 : OUT std_logic_vector(data_width -1 DOWNTO 0) := (others => '0'));   
   END COMPONENT;

   COMPONENT stratixii_mac_rs_block
      GENERIC (
        tpd_saturate_dataout           : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
        tpd_round_dataout              : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
        block_type                     :  string := "mac_mult";    
        dataa_width                    :  integer := 18;    
        datab_width                    :  integer := 18);        
      PORT (
         operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
         round                   : IN  std_logic := '0';
         saturate                : IN  std_logic := '0';
         addnsub                 : IN  std_logic := '0';
         signa                   : IN  std_logic := '0';
         signb                   : IN  std_logic := '0';
         signsize                : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
         roundsize               : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
         dataoutsize             : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
         dataa                   : IN  std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
         datab                   : IN  std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
         datain                  : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0'));
   END COMPONENT;


   SIGNAL mult_output              :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL signa_out                :  std_logic := '0';   
   SIGNAL signb_out                :  std_logic := '0';   
   SIGNAL round_out                :  std_logic := '0';   
   SIGNAL saturate_out             :  std_logic := '0';   
   SIGNAL mode_out                 :  std_logic := '0';   
   SIGNAL zeroacc_out              :  std_logic := '0';   
   SIGNAL dataout_tmp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_reg              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
   SIGNAL dataout_rs               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL scanouta_tmp             :  std_logic_vector(dataa_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL scanoutb_tmp             :  std_logic_vector(datab_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL dataa_src                :  std_logic_vector(dataa_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL datab_src                :  std_logic_vector(datab_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL dataa_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL datab_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signa_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signb_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate_clk             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output_clk               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate_aclr            :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL dataa_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL datab_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signa_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signb_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output_aclr              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode_clk                 :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode_aclr                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL clk_dataa                :  std_logic := '0';   
   SIGNAL clear_dataa              :  std_logic := '0';   
   SIGNAL aclr_dataa               :  std_logic := '0';   
   SIGNAL ena_dataa                :  std_logic := '0';   
   SIGNAL async_dataa              :  std_logic := '0';   
   SIGNAL clk_datab                :  std_logic := '0';   
   SIGNAL clear_datab              :  std_logic := '0';   
   SIGNAL aclr_datab               :  std_logic := '0';   
   SIGNAL ena_datab                :  std_logic := '0';   
   SIGNAL async_datab              :  std_logic := '0';   
   SIGNAL clk_signa                :  std_logic := '0';   
   SIGNAL clear_signa              :  std_logic := '0';   
   SIGNAL aclr_signa               :  std_logic := '0';   
   SIGNAL ena_signa                :  std_logic := '0';   
   SIGNAL async_signa              :  std_logic := '0';   
   SIGNAL clk_signb                :  std_logic := '0';   
   SIGNAL clear_signb              :  std_logic := '0';   
   SIGNAL aclr_signb               :  std_logic := '0';   
   SIGNAL ena_signb                :  std_logic := '0';   
   SIGNAL async_signb              :  std_logic := '0';   
   SIGNAL clk_round                :  std_logic := '0';   
   SIGNAL clear_round              :  std_logic := '0';   
   SIGNAL aclr_round               :  std_logic := '0';   
   SIGNAL ena_round                :  std_logic := '0';   
   SIGNAL async_round              :  std_logic := '0';   
   SIGNAL clk_saturate             :  std_logic := '0';   
   SIGNAL clear_saturate           :  std_logic := '0';   
   SIGNAL aclr_saturate            :  std_logic := '0';   
   SIGNAL ena_saturate             :  std_logic := '0';   
   SIGNAL async_saturate           :  std_logic := '0';   
   SIGNAL clk_mode                 :  std_logic := '0';   
   SIGNAL clear_mode               :  std_logic := '0';   
   SIGNAL aclr_mode                :  std_logic := '0';   
   SIGNAL ena_mode                 :  std_logic := '0';   
   SIGNAL async_mode               :  std_logic := '0';   
   SIGNAL clk_zeroacc              :  std_logic := '0';   
   SIGNAL clear_zeroacc            :  std_logic := '0';   
   SIGNAL aclr_zeroacc             :  std_logic := '0';   
   SIGNAL ena_zeroacc              :  std_logic := '0';   
   SIGNAL async_zeroacc            :  std_logic := '0';   
   SIGNAL clk_output               :  std_logic := '0';   
   SIGNAL clear_output             :  std_logic := '0';   
   SIGNAL aclr_output              :  std_logic := '0';   
   SIGNAL ena_output               :  std_logic := '0';   
   SIGNAL async_output             :  std_logic := '0';   
   SIGNAL signa_internal           :  std_logic := '0';   
   SIGNAL signb_internal           :  std_logic := '0';   
   SIGNAL bypass                   :  std_logic := '0';   
   SIGNAL mac_mult_dataoutsize     :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL tmp_4                   :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL tmp_60                  :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL port_tmp62              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL port_tmp63              :  std_logic := '0';   
   SIGNAL port_tmp64              :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL port_tmp65              :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp1            :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL scanouta_tmp2           :  std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL scanoutb_tmp3           :  std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');   


BEGIN
   dataout <= dataout_tmp1(dataout'range);
   scanouta <= scanouta_tmp2;
   scanoutb <= scanoutb_tmp3;
   dataout_tmp1 <= dataout_tmp(35 DOWNTO 0) ;
   dataa_src <= scanina WHEN (sourcea = '1') ELSE dataa ;
   datab_src <= scaninb WHEN (sourceb = '1') ELSE datab ;
   dataa_mac_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => dataa_width,
         power_up => '0')
      PORT MAP (
         data => dataa_src,
         clk => clk_dataa,
         aclr => aclr_dataa,
         if_aclr => clear_dataa,
         ena => ena_dataa,
         dataout => scanouta_tmp,
         async => async_dataa);   
   
   async_dataa <= '1' WHEN (dataa_clock = "none") ELSE '0' ;
   clear_dataa <= '1' WHEN (dataa_clear /= "none") ELSE '0' ;
   clk_dataa <= '1' WHEN clk(conv_integer(dataa_clk)) = '1' ELSE '0' ;
   aclr_dataa <= '1' WHEN (aclr(conv_integer(dataa_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_dataa <= '1' WHEN ena(conv_integer(dataa_clk)) = '1' ELSE '0' ;
   dataa_clk <= "0000" WHEN ((dataa_clock = "0") OR (dataa_clock = "none")) ELSE "0001" WHEN (dataa_clock = "1") ELSE "0010" WHEN (dataa_clock = "2") ELSE "0011" WHEN (dataa_clock = "3") ELSE "0000" ;
   dataa_aclr <= "0000" WHEN ((dataa_clear = "0") OR (dataa_clear = "none")) ELSE "0001" WHEN (dataa_clear = "1") ELSE "0010" WHEN (dataa_clear = "2") ELSE "0011" WHEN (dataa_clear = "3") ELSE "0000" ;
   datab_mac_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => datab_width,
         power_up => '0')
      PORT MAP (
         data => datab_src,
         clk => clk_datab,
         aclr => aclr_datab,
         if_aclr => clear_datab,
         ena => ena_datab,
         dataout => scanoutb_tmp,
         async => async_datab);   
   
   async_datab <= '1' WHEN (datab_clock = "none") ELSE '0' ;
   clear_datab <= '1' WHEN (datab_clear /= "none") ELSE '0' ;
   clk_datab <= '1' WHEN clk(conv_integer(datab_clk)) = '1' ELSE '0' ;
   aclr_datab <= '1' WHEN (aclr(conv_integer(datab_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_datab <= '1' WHEN ena(conv_integer(datab_clk)) = '1' ELSE '0' ;
   datab_clk <= "0000" WHEN ((datab_clock = "0") OR (datab_clock = "none")) ELSE "0001" WHEN (datab_clock = "1") ELSE "0010" WHEN (datab_clock = "2") ELSE "0011" WHEN (datab_clock = "3") ELSE "0000" ;
   datab_aclr <= "0000" WHEN ((datab_clear = "0") OR (datab_clear = "none")) ELSE "0001" WHEN (datab_clear = "1") ELSE "0010" WHEN (datab_clear = "2") ELSE "0011" WHEN (datab_clear = "3") ELSE "0000" ;
   signa_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => signa,
         clk => clk_signa,
         aclr => aclr_signa,
         if_aclr => clear_signa,
         ena => ena_signa,
         dataout => signa_out,
         async => async_signa);   
   
   async_signa <= '1' WHEN (signa_clock = "none") ELSE '0' ;
   clear_signa <= '1' WHEN (signa_clear /= "none") ELSE '0' ;
   clk_signa <= '1' WHEN clk(conv_integer(signa_clk)) = '1' ELSE '0' ;
   aclr_signa <= '1' WHEN (aclr(conv_integer(signa_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_signa <= '1' WHEN ena(conv_integer(signa_clk)) = '1' ELSE '0' ;
   signa_clk <= "0000" WHEN ((signa_clock = "0") OR (signa_clock = "none")) ELSE "0001" WHEN (signa_clock = "1") ELSE "0010" WHEN (signa_clock = "2") ELSE "0011" WHEN (signa_clock = "3") ELSE "0000" ;
   signa_aclr <= "0000" WHEN ((signa_clear = "0") OR (signa_clear = "none")) ELSE "0001" WHEN (signa_clear = "1") ELSE "0010" WHEN (signa_clear = "2") ELSE "0011" WHEN (signa_clear = "3") ELSE "0000" ;
   signb_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => signb,
         clk => clk_signb,
         aclr => aclr_signb,
         if_aclr => clear_signb,
         ena => ena_signb,
         dataout => signb_out,
         async => async_signb);   
   
   async_signb <= '1' WHEN (signb_clock = "none") ELSE '0' ;
   clear_signb <= '1' WHEN (signb_clear /= "none") ELSE '0' ;
   clk_signb <= '1' WHEN clk(conv_integer(signb_clk)) = '1' ELSE '0' ;
   aclr_signb <= '1' WHEN (aclr(conv_integer(signb_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_signb <= '1' WHEN ena(conv_integer(signb_clk)) = '1' ELSE '0' ;
   signb_clk <= "0000" WHEN ((signb_clock = "0") OR (signb_clock = "none")) ELSE "0001" WHEN (signb_clock = "1") ELSE "0010" WHEN (signb_clock = "2") ELSE "0011" WHEN (signb_clock = "3") ELSE "0000" ;
   signb_aclr <= "0000" WHEN ((signb_clear = "0") OR (signb_clear = "none")) ELSE "0001" WHEN (signb_clear = "1") ELSE "0010" WHEN (signb_clear = "2") ELSE "0011" WHEN (signb_clear = "3") ELSE "0000" ;
   round_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => round,
         clk => clk_round,
         aclr => aclr_round,
         if_aclr => clear_round,
         ena => ena_round,
         dataout => round_out,
         async => async_round);   
   
   async_round <= '1' WHEN (round_clock = "none") ELSE '0' ;
   clear_round <= '1' WHEN (round_clear /= "none") ELSE '0' ;
   clk_round <= '1' WHEN clk(conv_integer(round_clk)) = '1' ELSE '0' ;
   aclr_round <= '1' WHEN (aclr(conv_integer(round_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_round <= '1' WHEN ena(conv_integer(round_clk)) = '1' ELSE '0' ;
   round_clk <= "0000" WHEN ((round_clock = "0") OR (round_clock = "none")) ELSE "0001" WHEN (round_clock = "1") ELSE "0010" WHEN (round_clock = "2") ELSE "0011" WHEN (round_clock = "3") ELSE "0000" ;
   round_aclr <= "0000" WHEN ((round_clear = "0") OR (round_clear = "none")) ELSE "0001" WHEN (round_clear = "1") ELSE "0010" WHEN (round_clear = "2") ELSE "0011" WHEN (round_clear = "3") ELSE "0000" ;
   saturate_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => saturate,
         clk => clk_saturate,
         aclr => aclr_saturate,
         if_aclr => clear_saturate,
         ena => ena_saturate,
         dataout => saturate_out,
         async => async_saturate);   
   
   async_saturate <= '1' WHEN (saturate_clock = "none") ELSE '0' ;
   clear_saturate <= '1' WHEN (saturate_clear /= "none") ELSE '0' ;
   clk_saturate <= '1' WHEN clk(conv_integer(saturate_clk)) = '1' ELSE '0' ;
   aclr_saturate <= '1' WHEN (aclr(conv_integer(saturate_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_saturate <= '1' WHEN ena(conv_integer(saturate_clk)) = '1' ELSE '0' ;
   saturate_clk <= "0000" WHEN ((saturate_clock = "0") OR (saturate_clock = "none")) ELSE "0001" WHEN (saturate_clock = "1") ELSE "0010" WHEN (saturate_clock = "2") ELSE "0011" WHEN (saturate_clock = "3") ELSE "0000" ;
   saturate_aclr <= "0000" WHEN ((saturate_clear = "0") OR (saturate_clear = "none")) ELSE "0001" WHEN (saturate_clear = "1") ELSE "0010" WHEN (saturate_clear = "2") ELSE "0011" WHEN (saturate_clear = "3") ELSE "0000" ;
   mode_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => mode,
         clk => clk_mode,
         aclr => aclr_mode,
         if_aclr => clear_mode,
         ena => ena_mode,
         dataout => mode_out,
         async => async_mode);   
   
   async_mode <= '1' WHEN (mode_clock = "none") ELSE '0' ;
   clear_mode <= '1' WHEN (mode_clear /= "none") ELSE '0' ;
   clk_mode <= '1' WHEN clk(conv_integer(mode_clk)) = '1' ELSE '0' ;
   aclr_mode <= '1' WHEN (aclr(conv_integer(mode_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_mode <= '1' WHEN ena(conv_integer(mode_clk)) = '1' ELSE '0' ;
   mode_clk <= "0000" WHEN ((mode_clock = "0") OR (mode_clock = "none")) ELSE "0001" WHEN (mode_clock = "1") ELSE "0010" WHEN (mode_clock = "2") ELSE "0011" WHEN (mode_clock = "3") ELSE "0000" ;
   mode_aclr <= "0000" WHEN ((mode_clear = "0") OR (mode_clear = "none")) ELSE "0001" WHEN (mode_clear = "1") ELSE "0010" WHEN (mode_clear = "2") ELSE "0011" WHEN (mode_clear = "3") ELSE "0000" ;
   zeroacc_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => zeroacc,
         clk => clk_zeroacc,
         aclr => aclr_zeroacc,
         if_aclr => clear_zeroacc,
         ena => ena_zeroacc,
         dataout => zeroacc_out,
         async => async_zeroacc);   
   
   async_zeroacc <= '1' WHEN (zeroacc_clock = "none") ELSE '0' ;
   clear_zeroacc <= '1' WHEN (zeroacc_clear /= "none") ELSE '0' ;
   clk_zeroacc <= '1' WHEN clk(conv_integer(zeroacc_clk)) = '1' ELSE '0' ;
   aclr_zeroacc <= '1' WHEN (aclr(conv_integer(zeroacc_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_zeroacc <= '1' WHEN ena(conv_integer(zeroacc_clk)) = '1' ELSE '0' ;
   zeroacc_clk <= "0000" WHEN ((zeroacc_clock = "0") OR (zeroacc_clock = "none")) ELSE "0001" WHEN (zeroacc_clock = "1") ELSE "0010" WHEN (zeroacc_clock = "2") ELSE "0011" WHEN (zeroacc_clock = "3") ELSE "0000" ;
   zeroacc_aclr <= "0000" WHEN ((zeroacc_clear = "0") OR (zeroacc_clear = "none")) ELSE "0001" WHEN (zeroacc_clear = "1") ELSE "0010" WHEN (zeroacc_clear = "2") ELSE "0011" WHEN (zeroacc_clear = "3") ELSE "0000" ;
   mac_multiply : stratixii_mac_mult_internal 
      GENERIC MAP (
         dataa_width => dataa_width,
         datab_width => datab_width,
         dataout_width => dataa_width + datab_width,
         dynamic_mode => dynamic_mode)
      PORT MAP (
         dataa => scanouta_tmp,
         datab => scanoutb_tmp,
         signa => signa_internal,
         signb => signb_internal,
         bypass => bypass,
         scanouta => scanouta_tmp2,
         scanoutb => scanoutb_tmp3,
         dataout => mult_output);   
   
   signa_internal <= '0' WHEN ((signa_internally_grounded = "true") AND (dynamic_mode = "no")) OR ((((signa_internally_grounded = "true") AND (dynamic_mode = "yes")) AND (zeroacc_out = '1')) AND (mode_out = '0')) ELSE signa_out ;
   signb_internal <= '0' WHEN ((signb_internally_grounded = "true") AND (dynamic_mode = "no")) OR ((((signb_internally_grounded = "true") AND (dynamic_mode = "yes")) AND (zeroacc_out = '1')) AND (mode_out = '0')) ELSE signb_out ;
   bypass <= '1' WHEN ((bypass_multiplier = "yes") AND (dynamic_mode = "no")) OR (((bypass_multiplier = "yes") AND (mode_out = '1')) AND (dynamic_mode = "yes")) ELSE '0' ;
   tmp_60 <= '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & mult_output(35 DOWNTO 0);
   port_tmp62 <= "1111";
   port_tmp63 <= '0';
   port_tmp64 <= "00000010";
   port_tmp65 <= "00001111";
   mac_rs_block : stratixii_mac_rs_block 
      GENERIC MAP (
         block_type => "mac_mult",
         dataa_width => dataa_width,
         datab_width => datab_width)
      PORT MAP (
         operation => port_tmp62,
         round => round_out,
         saturate => saturate_out,
         addnsub => port_tmp63,
         signa => signa_out,
         signb => signb_out,
         signsize => port_tmp64,
         roundsize => port_tmp65,
         dataoutsize => mac_mult_dataoutsize,
         dataa => scanouta_tmp,
         datab => scanoutb_tmp,
         datain => tmp_60,
         dataout => dataout_rs);   
   
   mac_mult_dataoutsize <= CONV_STD_LOGIC_VECTOR(dataa_width + datab_width, 8) ;

   dataout_reg <= tmp_60 when bypass = '1' else dataout_rs;
   
   dataout_mac_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => dataa_width + datab_width,
         power_up => '0')
      PORT MAP (
         data => dataout_reg((dataa_width + datab_width) -1 downto 0),
         clk => clk_output,
         aclr => aclr_output,
         if_aclr => clear_output,
         ena => ena_output,
         dataout => dataout_tmp((dataa_width + datab_width) -1 downto 0),
         async => async_output);   
   
   async_output <= '1' WHEN (output_clock = "none") ELSE '0' ;
   clear_output <= '1' WHEN (output_clear /= "none") ELSE '0' ;
   clk_output <= '1' WHEN clk(conv_integer(output_clk)) = '1' ELSE '0' ;
   aclr_output <= '1' WHEN (aclr(conv_integer(output_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output <= '1' WHEN ena(conv_integer(output_clk)) = '1' ELSE '0' ;
   output_clk <= "0000" WHEN ((output_clock = "0") OR (output_clock = "none")) ELSE "0001" WHEN (output_clock = "1") ELSE "0010" WHEN (output_clock = "2") ELSE "0011" WHEN (output_clock = "3") ELSE "0000" ;
   output_aclr <= "0000" WHEN ((output_clear = "0") OR (output_clear = "none")) ELSE "0001" WHEN (output_clear = "1") ELSE "0010" WHEN (output_clear = "2") ELSE "0011" WHEN (output_clear = "3") ELSE "0000" ;

END arch;

--////////////////////////////////////////////////////////////////////////////
--
--                                 STRATIXII_MAC_ADDNSUB
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_addnsub IS
   GENERIC (
      dataa_width                    :  integer := 36;    
      datab_width                    :  integer := 36;    
      datac_width                    :  integer := 36;    
      datad_width                    :  integer := 36;    
      block_type                     :  string := "ab");
   PORT (
      dataa                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      datab                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      datac                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      datad                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      signb                   : IN std_logic := '0';   
      signa                   : IN std_logic := '0';   
      operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      addnsub                 : IN std_logic := '0';   
      dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');   
      overflow                : OUT std_logic := '0');   
END stratixii_mac_addnsub;

ARCHITECTURE arch OF stratixii_mac_addnsub IS

   -- REGULAR ADD/SUB
   SIGNAL sa                       :  std_logic := '0';   
   SIGNAL sb                       :  std_logic := '0';   
   SIGNAL abs_a                    :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL abs_b                    :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL overflow_tmp             :  std_logic := '0';   
   -- 36 BIT MULT
   SIGNAL dataa_u                  :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datab_u                  :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datab_s                  :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datac_u                  :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datac_s                  :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datad_u                  :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datad_s                  :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   --SIGNAL z36                      :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   --SIGNAL z18                      :  std_logic_vector(17 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp1            :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL overflow_tmp2           :  std_logic := '0';   

BEGIN
   dataout <= dataout_tmp1;
   overflow <= overflow_tmp2;

   PROCESS (dataa, datab, datac, datad, signa, signb, operation, addnsub)
      --VARIABLE z36_tmp3  : std_logic_vector(35 DOWNTO 0) := (others => '0');
      --VARIABLE z18_tmp4  : std_logic_vector(17 DOWNTO 0) := (others => '0');
      VARIABLE dataout_tmp_tmp12  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE overflow_tmp_tmp13  : std_logic;
      VARIABLE sa_tmp14  : std_logic;
      VARIABLE sb_tmp15  : std_logic;
      VARIABLE abs_a_tmp16  : std_logic_vector(71 DOWNTO 0);
      VARIABLE abs_b_tmp17  : std_logic_vector(71 DOWNTO 0);
      VARIABLE dataout_t    : std_logic_vector(72 downto 0) := (others => '0');
      VARIABLE dataa_u        : std_logic_vector(71 downto 0) := (others => '0');
      VARIABLE datab_u        : std_logic_vector(71 downto 0) := (others => '0');
      VARIABLE datab_s        : std_logic_vector(71 downto 0) := (others => '0'); 
      VARIABLE datac_u        : std_logic_vector(71 downto 0) := (others => '0');
      VARIABLE datac_s        : std_logic_vector(71 downto 0) := (others => '0'); 
      VARIABLE datad_u        : std_logic_vector(71 downto 0) := (others => '0');
      VARIABLE datad_s        : std_logic_vector(71 downto 0) := (others => '0'); 
   BEGIN
     IF ((unsigned(operation) = 7) AND (block_type /= "sum")) THEN
       dataa_u := (others => '0');
       datab_u := (others => '0');
       datac_u := (others => '0');
       datad_u := (others => '0');
       datab_s := (others => '0');
       datac_s := (others => '0');
       dataa_u(35 downto 0) := dataa(35 downto 0);
       datab_u(71 downto 36) := datab(35 downto 0);
       datab_s(71 downto 36) := datab(35 downto 0);
       datac_u(53 downto 18) := datac(35 downto 0);
       datac_s(71 downto 18) := sxt(datac(datac_width-1 downto 0), 54);
       datad_u(53 downto 18) := datad(35 downto 0);
       datad_s(71 downto 18) := sxt(datad(datad_width-1 downto 0), 54);
       if((signa = '0') and (signb = '0')) then 
         dataout_tmp_tmp12 := unsigned(datab_u) + unsigned(datac_u)
                              + unsigned(datad_u) + unsigned(dataa_u);
       elsif((signa = '0') and (signb = '1')) then
         dataout_t := signed(datab_s) + unsigned(datac_u)
                      + signed(datad_s) + unsigned(dataa_u);
         dataout_tmp_tmp12 := dataout_t(71 downto 0);
       elsif((signa = '1') and (signb = '0')) then
         dataout_t := signed(datab_s) + signed(datac_s)
                      + unsigned(datad_u) + unsigned(dataa_u);
         dataout_tmp_tmp12 := dataout_t(71 downto 0);
       elsif((signa = '1') and (signb = '1')) then
         dataout_t := signed(datab_s) + signed(datac_s)
                      + signed(datad_s) + unsigned(dataa_u);
         dataout_tmp_tmp12 := dataout_t(71 downto 0);
       end if;
       overflow_tmp_tmp13 := '0';    
     ELSE
         IF ((operation(2) = '1') AND (block_type = "ab")) THEN
           if(addnsub = '0') then 
             if ((signa or signb) = '1') then
               dataout_tmp_tmp12(datab_width+16 downto 0) :=
                 signed(sxt(dataa(datab_width+15 downto 0), datab_width+17)) -
                 signed(sxt(datab(datab_width-1 downto 0), datab_width+17));
             else
               dataout_tmp_tmp12(datab_width+16 downto 0) :=
                 unsigned(ext(dataa(datab_width+15 downto 0), datab_width+17)) -
                 unsigned(ext(datab(datab_width-1 downto 0), datab_width+17));
             end if;
           else
             if ((signa or signb) = '1') then
               dataout_tmp_tmp12(datab_width+16 downto 0) :=
                 signed(sxt(dataa(datab_width+15 downto 0), datab_width+17)) +
                 signed(sxt(datab(datab_width-1 downto 0), datab_width+17));
             else
               dataout_tmp_tmp12(datab_width+16 downto 0) :=
                 unsigned(ext(dataa(datab_width+15 downto 0), datab_width+17)) +
                 unsigned(ext(datab(datab_width-1 downto 0), datab_width+17));
             end if;
           end if;
           IF ((signa OR signb) = '1') THEN
             overflow_tmp_tmp13 := dataout_tmp_tmp12(datab_width + 16) XOR dataout_tmp_tmp12(datab_width + 15);    
           ELSE
             overflow_tmp_tmp13 := dataout_tmp_tmp12(datab_width + 16);    
           END IF;
         ELSE
           IF ((operation(2) = '1') AND (block_type = "cd")) THEN
             if(addnsub = '0') then 
               if ((signa or signb) = '1') then
                 dataout_tmp_tmp12(datad_width+16 downto 0) :=
                   signed(sxt(datac(datad_width+15 downto 0), datad_width+17)) -
                   signed(sxt(datad(datad_width-1 downto 0), datad_width+17));
               else
                 dataout_tmp_tmp12(datad_width+16 downto 0) :=
                   unsigned(ext(datac(datad_width+15 downto 0), datad_width+17)) -
                   unsigned(ext(datad(datad_width-1 downto 0), datad_width+17));
               end if;
             else
               if ((signa or signb) = '1') then
                 dataout_tmp_tmp12(datad_width+16 downto 0) :=
                   signed(sxt(datac(datad_width+15 downto 0), datad_width+17)) +
                   signed(sxt(datad(datad_width-1 downto 0), datad_width+17));
               else
                 dataout_tmp_tmp12(datad_width+16 downto 0) :=
                   unsigned(ext(datac(datad_width+15 downto 0), datad_width+17)) +
                   unsigned(ext(datad(datad_width-1 downto 0), datad_width+17));
               end if;
             end if;
             IF ((signa OR signb) = '1') THEN
               overflow_tmp_tmp13 := dataout_tmp_tmp12(datad_width + 16) XOR dataout_tmp_tmp12(datad_width + 15);    
             ELSE
               overflow_tmp_tmp13 := dataout_tmp_tmp12(datad_width + 16);    
             END IF;
            ELSE
               IF (block_type = "sum") THEN
                 if ((signa = '1') and (signb = '0')) then
                   dataout_tmp_tmp12(dataa_width+1 downto 0) :=
                     signed(sxt(dataa(dataa_width downto 0), dataa_width+2)) +
                     signed(ext(datab(datab_width downto 0), dataa_width+2));
                 elsif ((signa = '0') and (signb = '1')) then
                   dataout_tmp_tmp12(dataa_width+1 downto 0) :=
                     signed(ext(dataa(dataa_width downto 0), dataa_width+2)) +
                     signed(sxt(datab(datab_width downto 0), dataa_width+2));
				elsif ((signa = '1') and (signb = '1')) then
                   dataout_tmp_tmp12(dataa_width+1 downto 0) :=
                     signed(sxt(dataa(dataa_width downto 0), dataa_width+2)) +
                     signed(sxt(datab(datab_width downto 0), dataa_width+2));
                 else
                   dataout_tmp_tmp12(dataa_width+1 downto 0) :=
                     unsigned(ext(dataa(dataa_width downto 0), dataa_width+2)) +
                     unsigned(ext(datab(datab_width downto 0), dataa_width+2));
                 end if;
                 overflow_tmp_tmp13 := '0';
               ELSE
                  IF (block_type = "cd") THEN
                    if(addnsub = '0') then 
                      if ((signa or signb) = '1') then
                        if(datac_width >= datad_width) then
                          dataout_tmp_tmp12(datac_width downto 0) :=
                            signed(sxt(datac(datac_width-1 downto 0), datac_width+1)) -
                            signed(sxt(datad(datad_width-1 downto 0), datad_width+1));
                        else
                          dataout_tmp_tmp12(datad_width downto 0) :=
                            signed(sxt(datac(datac_width-1 downto 0), datac_width+1)) -
                            signed(sxt(datad(datad_width-1 downto 0), datad_width+1));
                        end if;
                      else
                        if(datac_width >= datad_width) then
                          dataout_tmp_tmp12(datac_width downto 0) :=
                            unsigned(ext(datac(datac_width-1 downto 0), datac_width+1)) -
                            unsigned(ext(datad(datad_width-1 downto 0), datad_width+1));
                        else
                          dataout_tmp_tmp12(datad_width downto 0) :=
                            unsigned(ext(datac(datac_width-1 downto 0), datac_width+1)) -
                            unsigned(ext(datad(datad_width-1 downto 0), datad_width+1));
                        end if;
                      end if;
                    else
                      if ((signa or signb) = '1') then
                        if(datac_width >= datad_width) then
                          dataout_tmp_tmp12(datac_width downto 0) :=
                            signed(sxt(datac(datac_width-1 downto 0), datac_width+1)) +
                            signed(sxt(datad(datad_width-1 downto 0), datad_width+1));
                        else
                          dataout_tmp_tmp12(datad_width downto 0) :=
                            signed(sxt(datac(datac_width-1 downto 0), datac_width+1)) +
                            signed(sxt(datad(datad_width-1 downto 0), datad_width+1));
                        end if;
                      else
                        if(datac_width >= datad_width) then
                          dataout_tmp_tmp12(datac_width downto 0) :=
                            unsigned(ext(datac(datac_width-1 downto 0), datac_width+1)) +
                            unsigned(ext(datad(datad_width-1 downto 0), datad_width+1));
                        else
                          dataout_tmp_tmp12(datad_width downto 0) :=
                            unsigned(ext(datac(datac_width-1 downto 0), datac_width+1)) +
                            unsigned(ext(datad(datad_width-1 downto 0), datad_width+1));
                        end if;
                      end if;
                    end if;                    
                    IF ((signa OR signb) = '1') THEN
                      overflow_tmp_tmp13 := dataout_tmp_tmp12(datac_width + 1) XOR dataout_tmp_tmp12(datac_width);    
                    ELSE
                      overflow_tmp_tmp13 := dataout_tmp_tmp12(datac_width + 1);    
                    END IF;
                  ELSE
                    if(addnsub = '0') then 
                      if ((signa or signb) = '1') then
                        if(dataa_width >= datab_width) then
                          dataout_tmp_tmp12(dataa_width downto 0) :=
                            signed(sxt(dataa(dataa_width-1 downto 0), dataa_width+1)) -
                            signed(sxt(datab(datab_width-1 downto 0), datab_width+1));
                        else
                          dataout_tmp_tmp12(datab_width downto 0) :=
                            signed(sxt(dataa(dataa_width-1 downto 0), dataa_width+1)) -
                            signed(sxt(datab(datab_width-1 downto 0), datab_width+1));
                        end if;
                      else
                        if(dataa_width >= datab_width) then
                          dataout_tmp_tmp12(dataa_width downto 0) :=
                            unsigned(ext(dataa(dataa_width-1 downto 0), dataa_width+1)) -
                            unsigned(ext(datab(datab_width-1 downto 0), datab_width+1));
                        else
                          dataout_tmp_tmp12(datab_width downto 0) :=
                            unsigned(ext(dataa(dataa_width-1 downto 0), dataa_width+1)) -
                            unsigned(ext(datab(datab_width-1 downto 0), datab_width+1));
                        end if;
                      end if;
                    else
                      if ((signa or signb) = '1') then
                        if(dataa_width >= datab_width) then
                          dataout_tmp_tmp12(dataa_width downto 0) :=
                            signed(sxt(dataa(dataa_width-1 downto 0), dataa_width+1)) +
                            signed(sxt(datab(datab_width-1 downto 0), datab_width+1));
                        else
                          dataout_tmp_tmp12(datab_width downto 0) :=
                            signed(sxt(dataa(dataa_width-1 downto 0), dataa_width+1)) +
                            signed(sxt(datab(datab_width-1 downto 0), datab_width+1));
                        end if;
                      else
                        if(dataa_width >= datab_width) then
                          dataout_tmp_tmp12(dataa_width downto 0) :=
                            unsigned(ext(dataa(dataa_width-1 downto 0), dataa_width+1)) +
                            unsigned(ext(datab(datab_width-1 downto 0), datab_width+1));
                        else
                          dataout_tmp_tmp12(datab_width downto 0) :=
                            unsigned(ext(dataa(dataa_width-1 downto 0), dataa_width+1)) +
                            unsigned(ext(datab(datab_width-1 downto 0), datab_width+1));
                        end if;
                      end if;
                    end if;
                    IF ((signa OR signb) = '1') THEN
                      overflow_tmp_tmp13 := dataout_tmp_tmp12(dataa_width + 1) XOR dataout_tmp_tmp12(dataa_width);    
                    ELSE
                      overflow_tmp_tmp13 := dataout_tmp_tmp12(dataa_width + 1);    
                    END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
      --z36 <= z36_tmp3;
      --z18 <= z18_tmp4;
      dataout_tmp <= dataout_tmp_tmp12;
      overflow_tmp <= overflow_tmp_tmp13;
      sa <= sa_tmp14;
      sb <= sb_tmp15;
      abs_a <= abs_a_tmp16;
      abs_b <= abs_b_tmp17;
   END PROCESS;
   dataout_tmp1 <= dataout_tmp ;
   overflow_tmp2 <= overflow_tmp ;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                            STRATIXII_MAC_DYNAMIC_SRC
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_dynamic_src IS
   GENERIC (
      dataa_width                    :  integer := 36;    
      datab_width                    :  integer := 36;    
      datac_width                    :  integer := 36;    
      datad_width                    :  integer := 36);
   PORT (
      accuma                  : IN std_logic_vector(51 DOWNTO 0) := (others => '0');   
      accumc                  : IN std_logic_vector(51 DOWNTO 0) := (others => '0');   
      dataa                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      datab                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      datac                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      datad                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      multabsaturate          : IN std_logic := '0';   
      multcdsaturate          : IN std_logic := '0';   
      signa                   : IN std_logic := '0';   
      signb                   : IN std_logic := '0';   
      zeroacc                 : IN std_logic := '0';   
      zeroacc1                : IN std_logic := '0';   
      operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      outa                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');   
      outb                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');   
      outc                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');   
      outd                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');   
      sata                    : OUT std_logic := '0';   
      satb                    : OUT std_logic := '0';   
      satc                    : OUT std_logic := '0';   
      satd                    : OUT std_logic := '0';   
      satab                   : OUT std_logic := '0';   
      satcd                   : OUT std_logic := '0'
      );   
END stratixii_mac_dynamic_src;

ARCHITECTURE arch OF stratixii_mac_dynamic_src IS


   SIGNAL outa_tmp                 :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL outb_tmp                 :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL outc_tmp                 :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL outd_tmp                 :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL sata_tmp                 :  std_logic := '0';   
   SIGNAL satb_tmp                 :  std_logic := '0';   
   SIGNAL satc_tmp                 :  std_logic := '0';   
   SIGNAL satd_tmp                 :  std_logic := '0';   
   SIGNAL satab_tmp                :  std_logic := '0';   
   SIGNAL satcd_tmp                :  std_logic := '0';   
   SIGNAL i                        :  integer;   
   SIGNAL j                        :  integer;   
   SIGNAL outa_tmp1               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL outb_tmp2               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL outc_tmp3               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL outd_tmp4               :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL sata_tmp5               :  std_logic := '0';   
   SIGNAL satb_tmp6               :  std_logic := '0';   
   SIGNAL satc_tmp7               :  std_logic := '0';   
   SIGNAL satd_tmp8               :  std_logic := '0';   
   SIGNAL satab_tmp9              :  std_logic := '0';   
   SIGNAL satcd_tmp10             :  std_logic := '0';   

   SIGNAL dynamic_dataa_width     : integer := 36;
   SIGNAL dynamic_datab_width     : integer := 36;
   SIGNAL dynamic_datac_width     : integer := 36;
   SIGNAL dynamic_datad_width     : integer := 36;

BEGIN
   outa <= outa_tmp1;
   outb <= outb_tmp2;
   outc <= outc_tmp3;
   outd <= outd_tmp4;
   sata <= sata_tmp5;
   satb <= satb_tmp6;
   satc <= satc_tmp7;
   satd <= satd_tmp8;
   satab <= satab_tmp9;
   satcd <= satcd_tmp10;

   dynamic_dataa_width <= dataa_width WHEN (dataa_width > 0) ELSE 36;
   dynamic_datab_width <= datab_width WHEN (datab_width > 0) ELSE 36;
   dynamic_datac_width <= datac_width WHEN (datac_width > 0) ELSE 36;
   dynamic_datad_width <= datad_width WHEN (datad_width > 0) ELSE 36;

   PROCESS (accuma, accumc, dataa, datab, datac, datad, multabsaturate, multcdsaturate, signa, signb, zeroacc, zeroacc1, operation)
      VARIABLE outa_tmp_tmp11  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE outb_tmp_tmp12  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE outc_tmp_tmp13  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE outd_tmp_tmp14  : std_logic_vector(71 DOWNTO 0) := (others => '0');
      VARIABLE j_tmp15  : integer;
      VARIABLE temp_tmp16  : std_logic_vector(1 DOWNTO 0) := (others => '0');
      VARIABLE sata_tmp_tmp17  : std_logic := '0';
      VARIABLE satb_tmp_tmp18  : std_logic := '0';
      VARIABLE satc_tmp_tmp19  : std_logic := '0';
      VARIABLE satd_tmp_tmp20  : std_logic := '0';
      VARIABLE satab_tmp_tmp21  : std_logic := '0';
      VARIABLE satcd_tmp_tmp22  : std_logic := '0';
   BEGIN
      CASE operation IS
         WHEN "0000" =>
                  IF (dataa(dynamic_dataa_width - 1) = '1' AND signa = '1') then 
                    outa_tmp_tmp11 := sxt(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72);
                  ELSE
                    outa_tmp_tmp11 := ext(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72);
                  END IF;
                  IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                    outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72);
                  ELSE
                    outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72);
                  END IF;
                  IF (datac(dynamic_datac_width - 1) = '1' AND signa = '1') THEN
                     outc_tmp_tmp13 := sxt(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                  ELSE
                     outc_tmp_tmp13 := ext(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                  END IF;
                  IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                     outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                  ELSE
                     outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                  END IF;
         WHEN "0100" =>
                  IF (zeroacc = '1') THEN
                     outa_tmp_tmp11 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                     IF (dataa(datab_width + 15) = '1' AND signa = '1') THEN
                        outa_tmp_tmp11:= sxt(dataa(datab_width+15 downto 0), 72);
                     ELSE
                        outa_tmp_tmp11:= ext(dataa(datab_width+15 downto 0), 72);
                     END IF;
                     j_tmp15 := 0;    
                     IF (datab_width + 16 > dataa_width) THEN
                        FOR i IN datab_width + 16 - dataa_width TO (datab_width + 16 - 1) LOOP
                           outa_tmp_tmp11(i) := dataa(j_tmp15);    
                           j_tmp15 := j_tmp15 + 1;    
                        END LOOP;
                        FOR i IN 0 to datab_width + 16 - dataa_width - 1 LOOP
                           outa_tmp_tmp11(i) := '0';    
                        END LOOP;
                     ELSE
                        j_tmp15 := dataa_width - 1;
			FOR i IN (datab_width + 15) DOWNTO 0 LOOP
                           outa_tmp_tmp11(i) := dataa(j_tmp15);   
                           j_tmp15 := j_tmp15 - 1;
                        END LOOP;
                     END IF;
                     IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                        outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72);
                     ELSE
                        outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72);
                     END IF;
                     IF (datac(dynamic_datac_width - 1) = '1' AND signa = '1') THEN
                        outc_tmp_tmp13 := sxt(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                     ELSE
                        outc_tmp_tmp13 := ext(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                     END IF;
                     IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                        outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                     ELSE
                        outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                     END IF;
                  ELSE
                     IF (accuma(datab_width + 15) = '1' AND signa = '1') THEN
                        outa_tmp_tmp11 := sxt(accuma(datab_width + 15 DOWNTO 0), 72); 
                     ELSE
                        outa_tmp_tmp11 := ext(accuma(datab_width + 15 DOWNTO 0), 72); 
                     END IF;
                     IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                        outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72);
                     ELSE
                        outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72);
                     END IF;
                     IF (datac(dynamic_datac_width - 1) = '1' AND signa = '1') THEN
                        outc_tmp_tmp13 := sxt(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                     ELSE
                        outc_tmp_tmp13 := ext(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                     END IF;
                     IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                        outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                     ELSE
                        outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                     END IF;
                  END IF;
         WHEN "1100" =>
                  temp_tmp16 := zeroacc1 & zeroacc;
                  CASE temp_tmp16 IS
                     WHEN "00" =>
                              IF (accuma(datab_width + 15) = '1' AND signa = '1') THEN
                                 outa_tmp_tmp11 := sxt(accuma(datab_width + 15 DOWNTO 0), 72);
                              ELSE
                                 outa_tmp_tmp11 := ext(accuma(datab_width + 15 DOWNTO 0), 72);
                              END IF;
                              IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                                 outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              END IF;
                              IF (accumc(datad_width + 15) = '1' AND signa = '1') THEN
                                 outc_tmp_tmp13 := sxt(accumc(datad_width + 15 DOWNTO 0), 72);
                              ELSE
                                 outc_tmp_tmp13 := ext(accumc(datad_width + 15 DOWNTO 0), 72);
                              END IF;
                              IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                                 outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              END IF;
                     WHEN "01" =>
                              outa_tmp_tmp11 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                              IF (dataa(datab_width + 15) = '1' AND signa = '1') THEN
                                 outa_tmp_tmp11 := sxt(dataa(datab_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outa_tmp_tmp11 := ext(dataa(datab_width + 15 DOWNTO 0), 72); 
                              END IF;
                              j_tmp15 := 0;    
                              IF (datab_width + 16 > dataa_width) THEN
                                 FOR i IN datab_width + 16 - dataa_width TO (datab_width + 16 - 1) LOOP
                                    outa_tmp_tmp11(i) := dataa(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                                 FOR i IN 0 to datab_width + 16 - dataa_width - 1 LOOP
                                   outa_tmp_tmp11(i) := '0';    
                                 END LOOP;
                              ELSE
                                 FOR i IN 0 TO (datab_width + 15 - 1) LOOP
                                    outa_tmp_tmp11(i) := dataa(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                              END IF;
                              outa_tmp_tmp11(dataa_width + 15 DOWNTO 0) := dataa(15 DOWNTO 0) & dataa(35 DOWNTO 18) & dataa(17 downto 16) & "0000000000000000";
                              IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                                 outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              END IF;
                              IF (accumc(datad_width + 15) = '1' AND signa = '1') THEN
                                 outc_tmp_tmp13 := sxt(accumc(datad_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outc_tmp_tmp13 := ext(accumc(datad_width + 15 DOWNTO 0), 72); 
                              END IF;
                              IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                                 outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              END IF;
                     WHEN "10" =>
                              IF (accuma(datab_width + 15) = '1' AND signa = '1') THEN
                                 outa_tmp_tmp11 := sxt(accuma(datab_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outa_tmp_tmp11 := ext(accuma(datab_width + 15 DOWNTO 0), 72); 
                              END IF;
                              IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                                 outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outb_tmp_tmp12 := ext(datab(datab_width - 1 DOWNTO 0), 72); 
                              END IF;
                              outc_tmp_tmp13 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                              IF (datac(datad_width + 15) = '1' AND signb = '1') THEN
                                 outc_tmp_tmp13 := sxt(datac(datad_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outc_tmp_tmp13 := ext(datac(datad_width + 15 DOWNTO 0), 72); 
                              END IF;
                              j_tmp15 := 0;    
                              IF (datad_width + 16 > datac_width) THEN
                                 FOR i IN datad_width + 16 - datac_width TO (datad_width + 16 - 1) LOOP
                                    outc_tmp_tmp13(i) := datac(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                                 FOR i IN 0 to datad_width + 16 - datac_width - 1 LOOP
                                   outc_tmp_tmp13(i) := '0';    
                                 END LOOP;
                              ELSE
                                 FOR i IN 0 TO (datad_width + 15 - 1) LOOP
                                    outc_tmp_tmp13(i) := datac(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                              END IF;
                              outc_tmp_tmp13(datac_width + 15 DOWNTO 0) := datac(15 DOWNTO 0) & datac(35 DOWNTO 18) & datac(17 downto 16) & "0000000000000000";
                              IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                                 outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              END IF;
                     WHEN "11" =>
                              outa_tmp_tmp11 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                              IF (dataa(datab_width + 15) = '1' AND signa = '1') THEN
                                 outa_tmp_tmp11 := sxt(dataa(datab_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outa_tmp_tmp11 := ext(dataa(datab_width + 15 DOWNTO 0), 72); 
                              END IF;
                              j_tmp15 := 0;    
                              IF (datab_width + 16 > dataa_width) THEN
                                 FOR i IN datab_width + 16 - dataa_width TO (datab_width + 16 - 1) LOOP
                                    outa_tmp_tmp11(i) := dataa(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                                 FOR i IN 0 to datab_width + 16 - dataa_width - 1 LOOP
                                   outa_tmp_tmp11(i) := '0';    
                                 END LOOP;
                              ELSE
                                 FOR i IN 0 TO (datab_width + 15 - 1) LOOP
                                    outa_tmp_tmp11(i) := dataa(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                              END IF;
                              outa_tmp_tmp11(dataa_width + 15 DOWNTO 0) := dataa(15 DOWNTO 0) & dataa(35 DOWNTO 18) & dataa(17 downto 16) & "0000000000000000";
                              IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                                 outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              END IF;
                              outc_tmp_tmp13 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                              IF (datac(datad_width + 15) = '1' AND signb = '1') THEN
                                 outc_tmp_tmp13 := sxt(datac(datad_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outc_tmp_tmp13 := ext(datac(datad_width + 15 DOWNTO 0), 72); 
                              END IF;
                              j_tmp15 := 0;    
                              IF (datad_width + 16 > datac_width) THEN
                                 FOR i IN datad_width + 16 - datac_width TO (datad_width + 16 - 1) LOOP
                                    outc_tmp_tmp13(i) := datac(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                                 FOR i IN 0 to datad_width + 16 - datac_width - 1 LOOP
                                   outc_tmp_tmp13(i) := '0';    
                                 END LOOP;
                              ELSE
                                 FOR i IN 0 TO (datad_width + 15 - 1) LOOP
                                    outc_tmp_tmp13(i) := datac(j_tmp15);    
                                    j_tmp15 := j_tmp15 + 1;    
                                 END LOOP;
                              END IF;
                              outc_tmp_tmp13(datac_width + 15 DOWNTO 0) := datac(15 DOWNTO 0) & datac(35 DOWNTO 18) & datac(17 downto 16) & "0000000000000000";
                              IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                                 outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              END IF;
                     WHEN OTHERS  =>
                              IF (accuma(datab_width + 15) = '1' AND signa = '1') THEN
                                 outa_tmp_tmp11 := sxt(accuma(datab_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outa_tmp_tmp11 := ext(accuma(datab_width + 15 DOWNTO 0), 72); 
                              END IF;
                              IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                                 outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                              END IF;
                              IF (accumc(datad_width + 15) = '1' AND signa = '1') THEN
                                 outc_tmp_tmp13 := sxt(accumc(datad_width + 15 DOWNTO 0), 72); 
                              ELSE
                                 outc_tmp_tmp13 := ext(accumc(datad_width + 15 DOWNTO 0), 72); 
                              END IF;
                              IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                                 outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              ELSE
                                 outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                              END IF;
                     
                  END CASE;
         WHEN "1101" =>
                  IF (zeroacc = '1') THEN
                     outa_tmp_tmp11 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                     IF (dataa(datab_width + 15) = '1' AND signa = '1') THEN
                        outa_tmp_tmp11 := sxt(dataa(datab_width + 15 DOWNTO 0), 72); 
                     ELSE
                        outa_tmp_tmp11 := ext(dataa(datab_width + 15 DOWNTO 0), 72); 
                     END IF;
                     j_tmp15 := 0;    
                     IF (datab_width + 16 > dataa_width) THEN
                        FOR i IN datab_width + 16 - dataa_width TO (datab_width + 16 - 1) LOOP
                           outa_tmp_tmp11(i) := dataa(j_tmp15);    
                           j_tmp15 := j_tmp15 + 1;    
                        END LOOP;
                        FOR i IN 0 to datab_width + 16 - dataa_width - 1 LOOP
                          outa_tmp_tmp11(i) := '0';    
                        END LOOP;
                     ELSE
                        FOR i IN 0 TO (datab_width + 15 - 1) LOOP
                           outa_tmp_tmp11(i) := dataa(j_tmp15);    
                           j_tmp15 := j_tmp15 + 1;    
                        END LOOP;
                     END IF;
                     outa_tmp_tmp11(dataa_width + 15 DOWNTO 0) := dataa(15 DOWNTO 0) & dataa(35 DOWNTO 18) & dataa(17 downto 16) & "0000000000000000";
                     IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                        outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     END IF;
                     IF (datac(dynamic_datac_width - 1) = '1' AND signa = '1') THEN
                        outc_tmp_tmp13 := sxt(datac(dynamic_datac_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outc_tmp_tmp13 := ext(datac(dynamic_datac_width - 1 DOWNTO 0), 72); 
                     END IF;
                     IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                        outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72);
                     END IF;
                  ELSE
                     IF (accuma(datab_width + 15) = '1' AND signa = '1') THEN
                        outa_tmp_tmp11 := sxt(accuma(datab_width + 15 DOWNTO 0), 72);
                     ELSE
                        outa_tmp_tmp11 := ext(accuma(datab_width + 15 DOWNTO 0), 72);
                     END IF;
                     IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                        outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     END IF;
                     IF (datac(dynamic_datac_width - 1) = '1' AND signa = '1') THEN
                        outc_tmp_tmp13 := sxt(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                     ELSE
                        outc_tmp_tmp13 := ext(datac(dynamic_datac_width - 1 DOWNTO 0), 72);
                     END IF;
                     IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                        outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     END IF;
                  END IF;
         WHEN "1110" =>
                  IF (zeroacc1 = '1') THEN
                     IF (dataa(dynamic_dataa_width - 1) = '1' AND signa = '1') THEN
                        outa_tmp_tmp11 := sxt(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outa_tmp_tmp11 := ext(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72); 
                     END IF;
                     IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                        outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     END IF;
                     outc_tmp_tmp13 := "000000000000000000000000000000000000000000000000000000000000000000000000";    
                     IF (datac(datad_width + 15) = '1' AND signb = '1') THEN
                        outc_tmp_tmp13 := sxt(datac(datad_width + 15 DOWNTO 0), 72); 
                     ELSE
                        outc_tmp_tmp13 := ext(datac(datad_width + 15 DOWNTO 0), 72); 
                     END IF;
                     j_tmp15 := 0;    
                     IF (datad_width + 16 > datac_width) THEN
                        FOR i IN datad_width + 16 - datac_width TO (datad_width + 16 - 1) LOOP
                           outc_tmp_tmp13(i) := datac(j_tmp15);    
                           j_tmp15 := j_tmp15 + 1;    
                        END LOOP;
                        FOR i IN 0 to datad_width + 16 - datac_width - 1 LOOP
                          outc_tmp_tmp13(i) := '0';    
                        END LOOP;
                     ELSE
                        FOR i IN 0 TO (datad_width + 15 - 1) LOOP
                           outc_tmp_tmp13(i) := datac(j_tmp15);    
                           j_tmp15 := j_tmp15 + 1;    
                        END LOOP;
                     END IF;
                     outc_tmp_tmp13(datac_width + 15 DOWNTO 0) := datac(15 DOWNTO 0) & datac(35 DOWNTO 18) & datac(17 downto 16) & "0000000000000000";
                     IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                        outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     END IF;
                  ELSE
                     IF (dataa(dynamic_dataa_width - 1) = '1' AND signa = '1') THEN
                        outa_tmp_tmp11 := sxt(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outa_tmp_tmp11 := ext(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72); 
                     END IF;
                     IF (datab(dynamic_datab_width - 1) = '1' AND signb = '1') THEN
                        outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                     END IF;
                     IF (accumc(datad_width + 15) = '1' AND signa = '1') THEN
                        outc_tmp_tmp13 := sxt(accumc(datad_width + 15 DOWNTO 0), 72); 
                     ELSE
                        outc_tmp_tmp13 := ext(accumc(datad_width + 15 DOWNTO 0), 72); 
                     END IF;
                     IF (datad(dynamic_datad_width - 1) = '1' AND signb = '1') THEN
                        outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     ELSE
                        outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                     END IF;
                  END IF;
         WHEN OTHERS  =>
                  IF (dataa(dynamic_dataa_width - 1) = '1' AND signa = '1') THEN
                     outa_tmp_tmp11 := sxt(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72); 
                  ELSE
                     outa_tmp_tmp11 := ext(dataa(dynamic_dataa_width - 1 DOWNTO 0), 72); 
                  END IF;
                  IF (datab(dynamic_datab_width - 1) = '1' AND signa = '1') THEN
                     outb_tmp_tmp12 := sxt(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                  ELSE
                     outb_tmp_tmp12 := ext(datab(dynamic_datab_width - 1 DOWNTO 0), 72); 
                  END IF;
                  IF (datac(dynamic_datac_width - 1) = '1' AND signa = '1') THEN
                     outc_tmp_tmp13 := sxt(datac(dynamic_datac_width - 1 DOWNTO 0), 72); 
                  ELSE
                     outc_tmp_tmp13 := ext(datac(dynamic_datac_width - 1 DOWNTO 0), 72); 
                  END IF;
                  IF (datad(dynamic_datad_width - 1) = '1' AND signa = '1') THEN
                     outd_tmp_tmp14 := sxt(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                  ELSE
                     outd_tmp_tmp14 := ext(datad(dynamic_datad_width - 1 DOWNTO 0), 72); 
                  END IF;
         
      END CASE;
      IF (multabsaturate = '1') THEN
         IF ((outa_tmp_tmp11(0) AND ((zeroacc AND operation(2)) OR NOT operation(2))) = '1') THEN
            sata_tmp_tmp17 := '1';    
            outa_tmp_tmp11(0) := '0';    
         ELSE
            sata_tmp_tmp17 := '0';    
         END IF;
         IF (outb_tmp_tmp12(0) = '1') THEN
            satb_tmp_tmp18 := '1';    
            outb_tmp_tmp12(0) := '0';    
         ELSE
            satb_tmp_tmp18 := '0';    
         END IF;
      ELSE
         sata_tmp_tmp17 := '0';    
         satb_tmp_tmp18 := '0';    
      END IF;
      IF (multcdsaturate = '1') THEN
         IF ((outc_tmp_tmp13(0) AND ((zeroacc1 AND operation(2)) OR NOT operation(2))) = '1') THEN
            satc_tmp_tmp19 := '1';    
            outc_tmp_tmp13(0) := '0';    
         ELSE
            satc_tmp_tmp19 := '0';    
         END IF;
         IF (outd_tmp_tmp14(0) = '1') THEN
            satd_tmp_tmp20 := '1';    
            outd_tmp_tmp14(0) := '0';    
         ELSE
            satd_tmp_tmp20 := '0';    
         END IF;
      ELSE
         satc_tmp_tmp19 := '0';    
         satd_tmp_tmp20 := '0';    
      END IF;
      IF ((sata_tmp_tmp17 OR satb_tmp_tmp18) = '1') THEN
         satab_tmp_tmp21 := '1';    
      ELSE
         satab_tmp_tmp21 := '0';    
      END IF;
      IF ((satc_tmp_tmp19 OR satd_tmp_tmp20) = '1') THEN
         satcd_tmp_tmp22 := '1';    
      ELSE
         satcd_tmp_tmp22 := '0';    
      END IF;
      outa_tmp <= outa_tmp_tmp11;
      outb_tmp <= outb_tmp_tmp12;
      outc_tmp <= outc_tmp_tmp13;
      outd_tmp <= outd_tmp_tmp14;
      j <= j_tmp15;
      sata_tmp <= sata_tmp_tmp17;
      satb_tmp <= satb_tmp_tmp18;
      satc_tmp <= satc_tmp_tmp19;
      satd_tmp <= satd_tmp_tmp20;
      satab_tmp <= satab_tmp_tmp21;
      satcd_tmp <= satcd_tmp_tmp22;
   END PROCESS;
   outa_tmp1 <= outa_tmp ;
   outb_tmp2 <= outb_tmp ;
   outc_tmp3 <= outc_tmp ;
   outd_tmp4 <= outd_tmp ;
   sata_tmp5 <= sata_tmp ;
   satb_tmp6 <= satb_tmp ;
   satc_tmp7 <= satc_tmp ;
   satd_tmp8 <= satd_tmp ;
   satab_tmp9 <= satab_tmp ;
   satcd_tmp10 <= satcd_tmp ;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                           STRATIXII_MAC_DYNAMIC_MUX
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_dynamic_mux IS
   PORT (
      ab                      : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      cd                      : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      sata                    : IN std_logic := '0';   
      satb                    : IN std_logic := '0';   
      satc                    : IN std_logic := '0';   
      satd                    : IN std_logic := '0';   
      multsatab               : IN std_logic := '0';   
      multsatcd               : IN std_logic := '0';   
      outsatab                : IN std_logic := '0';   
      outsatcd                : IN std_logic := '0';   
      multabsaturate          : IN std_logic := '0';   
      multcdsaturate          : IN std_logic := '0';   
      saturateab              : IN std_logic := '0';   
      saturatecd              : IN std_logic := '0';   
      overab                  : IN std_logic := '0';   
      overcd                  : IN std_logic := '0';   
      sum                     : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      m36                     : IN std_logic_vector(71 DOWNTO 0) := (others => '0');   
      bypass                  : IN std_logic_vector(143 DOWNTO 0) := (others => '0');   
      operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      dataout                 : OUT std_logic_vector(143 DOWNTO 0) := (others => '0');   
      accoverflow             : OUT std_logic := '0');   
END stratixii_mac_dynamic_mux;

ARCHITECTURE arch OF stratixii_mac_dynamic_mux IS


   SIGNAL dataout_tmp              :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL accoverflow_tmp          :  std_logic := '0';   
   SIGNAL dataout_tmp1            :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL accoverflow_tmp2        :  std_logic := '0';   

BEGIN
   dataout <= dataout_tmp1;
   accoverflow <= accoverflow_tmp2;

   PROCESS (ab, cd, sata, satb, satc, satd, multsatab, multsatcd, outsatab, outsatcd, multabsaturate, multcdsaturate, saturateab, saturatecd, overab, overcd, sum, m36, bypass, operation)
      VARIABLE dataout_tmp_tmp3  : std_logic_vector(143 DOWNTO 0) := (others => '0');
      VARIABLE accoverflow_tmp_tmp4  : std_logic := '0';
      VARIABLE temp_tmp5  : std_logic_vector(1 DOWNTO 0) := (others => '0');
      VARIABLE temp_tmp6  : std_logic_vector(1 DOWNTO 0) := (others => '0');
      VARIABLE temp_tmp7  : std_logic_vector(3 DOWNTO 0) := (others => '0');
      VARIABLE temp_tmp8  : std_logic_vector(1 DOWNTO 0) := (others => '0');
      VARIABLE temp_tmp9  : std_logic_vector(1 DOWNTO 0) := (others => '0');
   BEGIN
      CASE operation IS
         WHEN "0000" =>
                  dataout_tmp_tmp3 := bypass;    
                  accoverflow_tmp_tmp4 := '0';    
         WHEN "0100" =>
                  temp_tmp5 := saturateab & multabsaturate;
                  CASE temp_tmp5 IS
                     WHEN "00" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 0);    
                     WHEN "01" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 2) & multsatab & ab(0);    
                     WHEN "10" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 3) & outsatab & ab(1 DOWNTO 0);    
                     WHEN "11" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 3) & outsatab & multsatab & ab(0);    
                     WHEN OTHERS  =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 0);    
                     
                  END CASE;
                  accoverflow_tmp_tmp4 := overab;    
         WHEN "0001" =>
                  IF (multabsaturate = '1') THEN
                     dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 2) & satb & sata;    
                  ELSE
                     dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 0);    
                  END IF;
                  accoverflow_tmp_tmp4 := '0';    
         WHEN "0010" =>
                  temp_tmp6 := multsatcd & multsatab;
                  CASE temp_tmp6 IS
                     WHEN "00" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & sum(71 DOWNTO 0);    
                              accoverflow_tmp_tmp4 := '0';    
                     WHEN "01" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & sum(71 DOWNTO 2) & satb & sata;    
                              accoverflow_tmp_tmp4 := '0';    
                     WHEN "10" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & sum(71 DOWNTO 3) & satc & sum(1 DOWNTO 0);    
                              accoverflow_tmp_tmp4 := satd;    
                     WHEN "11" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & sum(71 DOWNTO 3) & satc & satb & sata;    
                              accoverflow_tmp_tmp4 := satd;    
                     WHEN OTHERS  =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & sum(71 DOWNTO 0);    
                              accoverflow_tmp_tmp4 := '0';    
                     
                  END CASE;
         WHEN "0111" =>
                  dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & m36;    
                  accoverflow_tmp_tmp4 := '0';    
         WHEN "1100" =>
                  temp_tmp7 := saturatecd & saturateab & multsatcd & multsatab;
                  CASE temp_tmp7 IS
                     WHEN "0000" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 0);    
                     WHEN "0001" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 2) & multsatab & ab(0);    
                     WHEN "0010" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 2) & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 0);    
                     WHEN "0011" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 2) & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 2) & multsatab & ab(0);    
                     WHEN "0100" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & ab(1 DOWNTO 0);    
                     WHEN "0101" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & multsatab & ab(0);    
                     WHEN "0110" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 2) & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & ab(1 DOWNTO 0);    
                     WHEN "0111" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 2) & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & multsatab & ab(0);    
                     WHEN "1000" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & cd(1 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 0);    
                     WHEN "1001" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & cd(1 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 2) & multsatab & ab(0);    
                     WHEN "1010" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 0);    
                     WHEN "1011" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 2) & multsatab & ab(0);    
                     WHEN "1100" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & cd(1 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & ab(1 DOWNTO 0);    
                     WHEN "1101" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & cd(1 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & multsatab & ab(0);    
                     WHEN "1110" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & ab(1 DOWNTO 0);    
                     WHEN "1111" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & multsatcd & cd(0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & multsatab & ab(0);    
                     WHEN OTHERS  =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 0);    
                     
                  END CASE;
                  accoverflow_tmp_tmp4 := overab;    
         WHEN "1101" =>
                  temp_tmp8 := saturateab & multabsaturate;
                  CASE temp_tmp8 IS
                     WHEN "00" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 0);    
                     WHEN "01" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 2) & multsatab & ab(0);    
                     WHEN "10" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & ab(1 DOWNTO 0);    
                     WHEN "11" =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 3) & outsatab & multsatab & ab(0);    
                     WHEN OTHERS  =>
                              dataout_tmp_tmp3 := bypass(143 DOWNTO 72) & ab(71 DOWNTO 53) & overab & ab(51 DOWNTO 36) & ab(35 DOWNTO 0);    
                     
                  END CASE;
                  accoverflow_tmp_tmp4 := overab;    
         WHEN "1110" =>
                  temp_tmp9 := saturatecd & multcdsaturate;
                  CASE temp_tmp9 IS
                     WHEN "00" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & bypass(71 DOWNTO 0);    
                     WHEN "01" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 2) & multsatcd & cd(0) & bypass(71 DOWNTO 0);    
                     WHEN "10" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & cd(1 DOWNTO 0) & bypass(71 DOWNTO 0);    
                     WHEN "11" =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 3) & outsatcd & multsatcd & cd(0) & bypass(71 DOWNTO 0);    
                     WHEN OTHERS  =>
                              dataout_tmp_tmp3 := cd(71 DOWNTO 53) & overcd & cd(51 DOWNTO 0) & bypass(71 DOWNTO 0);    
                     
                  END CASE;
                  accoverflow_tmp_tmp4 := overcd;    
         WHEN OTHERS  =>
                  dataout_tmp_tmp3 := bypass;    
                  accoverflow_tmp_tmp4 := '0';    
         
      END CASE;
      dataout_tmp <= dataout_tmp_tmp3;
      accoverflow_tmp <= accoverflow_tmp_tmp4;
   END PROCESS;
   dataout_tmp1 <= dataout_tmp ;
   accoverflow_tmp2 <= accoverflow_tmp ;
END arch;
--/////////////////////////////////////////////////////////////////////////////
--
--                            STRATIXII_MAC_OUT_INTERNAL
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
use work.stratixii_mac_addnsub;
use work.stratixii_mac_dynamic_mux;
use work.stratixii_mac_dynamic_src;
use work.stratixii_mac_rs_block;

ENTITY stratixii_mac_out_internal IS
   GENERIC (
      operation_mode                 :  string := "output_only";    
      dataa_width                    :  integer := 36;    
      datab_width                    :  integer := 36;    
      datac_width                    :  integer := 36;    
      datad_width                    :  integer := 36;
      tmp_width                      :  integer := 144;
      dataout_width                  :  integer := 144;
      tipd_dataa        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
      tipd_datab        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
      tipd_datac        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
      tipd_datad        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
      tipd_feedback        : VitalDelayArrayType01(143 downto 0):= (OTHERS => DefPropDelay01);
      tpd_dataa_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
      tpd_datab_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
      tpd_datac_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
      tpd_datad_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
      tpd_feedback_dataout      : VitalDelayArrayType01(144*144-1 downto 0) := (others => DefPropDelay01);
      tpd_signx_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_signy_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_addnsub0_dataout      : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_addnsub1_dataout      : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_zeroacc_dataout       : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_zeroacc1_dataout      : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_multabsaturate_dataout: VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_multcdsaturate_dataout: VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_mode0_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_mode1_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
      tpd_dataa_accoverflow     : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
      tpd_feedback_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_signx_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_signy_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub0_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub1_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_zeroacc_accoverflow   : VitalDelayType01 := DefPropDelay01;
      tpd_zeroacc1_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_mode0_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_mode1_accoverflow     : VitalDelayType01 := DefPropDelay01;
      XOn: Boolean              := DefGlitchXOn;   
      MsgOn: Boolean            := DefGlitchMsgOn
      );
   PORT (
      dataa                   : IN std_logic_vector(dataa_width -1 DOWNTO 0) := (others => '0');   
      datab                   : IN std_logic_vector(datab_width -1 DOWNTO 0) := (others => '0');   
      datac                   : IN std_logic_vector(datac_width -1 DOWNTO 0) := (others => '0');   
      datad                   : IN std_logic_vector(datad_width -1 DOWNTO 0) := (others => '0');   
      mode0                   : IN std_logic := '0';   
      mode1                   : IN std_logic := '0';   
      roundab                 : IN std_logic := '0';   
      saturateab              : IN std_logic := '0';   
      roundcd                 : IN std_logic := '0';   
      saturatecd              : IN std_logic := '0';   
      multabsaturate          : IN std_logic := '0';   
      multcdsaturate          : IN std_logic := '0';   
      signx                   : IN std_logic := '0';   
      signy                   : IN std_logic := '0';   
      addnsub0                : IN std_logic := '0';   
      addnsub1                : IN std_logic := '0';   
      zeroacc                 : IN std_logic := '0';   
      zeroacc1                : IN std_logic := '0';   
      feedback       		  : IN std_logic_vector(tmp_width -1 DOWNTO 0) := (others => '0');   
      dataout                 : OUT std_logic_vector(dataout_width -1 DOWNTO 0) := (others => '0');   
      accoverflow             : OUT std_logic := '0'
      );   
END stratixii_mac_out_internal;

ARCHITECTURE arch OF stratixii_mac_out_internal IS

   COMPONENT stratixii_mac_addnsub
      GENERIC (
          dataa_width                    :  integer := 36;    
          datab_width                    :  integer := 36;    
          block_type                     :  string := "ab";    
          datac_width                    :  integer := 36;    
          datad_width                    :  integer := 36);
      PORT (
         dataa                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         datab                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         datac                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         datad                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         signb                   : IN  std_logic := '0';
         signa                   : IN  std_logic := '0';
         operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
         addnsub                 : IN  std_logic := '0';
         dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
         overflow                : OUT std_logic := '0');
   END COMPONENT;

   COMPONENT stratixii_mac_dynamic_mux
      PORT (
         ab                      : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         cd                      : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         sata                    : IN  std_logic := '0';
         satb                    : IN  std_logic := '0';
         satc                    : IN  std_logic := '0';
         satd                    : IN  std_logic := '0';
         multsatab               : IN  std_logic := '0';
         multsatcd               : IN  std_logic := '0';
         outsatab                : IN  std_logic := '0';
         outsatcd                : IN  std_logic := '0';
         multabsaturate          : IN  std_logic := '0';
         multcdsaturate          : IN  std_logic := '0';
         saturateab              : IN  std_logic := '0';
         saturatecd              : IN  std_logic := '0';
         overab                  : IN  std_logic := '0';
         overcd                  : IN  std_logic := '0';
         sum                     : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         m36                     : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         bypass                  : IN  std_logic_vector(143 DOWNTO 0) := (others => '0');
         operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
         dataout                 : OUT std_logic_vector(143 DOWNTO 0) := (others => '0');
         accoverflow             : OUT std_logic := '0');
   END COMPONENT;

   COMPONENT stratixii_mac_dynamic_src
      GENERIC (
          dataa_width                    :  integer := 36;    
          datab_width                    :  integer := 36;    
          datac_width                    :  integer := 36;    
          datad_width                    :  integer := 36);
      PORT (
         accuma                  : IN  std_logic_vector(51 DOWNTO 0) := (others => '0');
         accumc                  : IN  std_logic_vector(51 DOWNTO 0) := (others => '0');
         dataa                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         datab                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         datac                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         datad                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         multabsaturate          : IN  std_logic := '0';
         multcdsaturate          : IN  std_logic := '0';
         signa                   : IN  std_logic := '0';
         signb                   : IN  std_logic := '0';
         zeroacc                 : IN  std_logic := '0';
         zeroacc1                : IN  std_logic := '0';
         operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
         outa                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
         outb                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
         outc                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
         outd                    : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
         sata                    : OUT std_logic := '0';
         satb                    : OUT std_logic := '0';
         satc                    : OUT std_logic := '0';
         satd                    : OUT std_logic := '0';
         satab                   : OUT std_logic := '0';
         satcd                   : OUT std_logic := '0');
   END COMPONENT;

   COMPONENT stratixii_mac_rs_block
      GENERIC (
        tpd_saturate_dataout           : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
        tpd_round_dataout              : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
        block_type                     :  string := "mac_mult";    
        dataa_width                    :  integer := 18;    
        datab_width                    :  integer := 18);                
      PORT (
         operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
         round                   : IN  std_logic := '0';
         saturate                : IN  std_logic := '0';
         addnsub                 : IN  std_logic := '0';
         signa                   : IN  std_logic := '0';
         signb                   : IN  std_logic := '0';
         signsize                : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
         roundsize               : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
         dataoutsize             : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
         dataa                   : IN  std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');
         datab                   : IN  std_logic_vector(datab_width-1 DOWNTO 0) := (others => '0');
         datain                  : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
         dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0'));
   END COMPONENT;


   SIGNAL dataout_tmp              :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL accoverflow_tmp          :  std_logic := '0';   
   SIGNAL dataa_src                :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datab_src                :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datac_src                :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL datad_src                :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL sata                     :  std_logic := '0';   
   SIGNAL satb                     :  std_logic := '0';   
   SIGNAL satc                     :  std_logic := '0';   
   SIGNAL satd                     :  std_logic := '0';   
   SIGNAL satab                    :  std_logic := '0';   
   SIGNAL satcd                    :  std_logic := '0';   
   SIGNAL addnsub_ab_out           :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub_cd_out           :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub_sum              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL overflow_ab              :  std_logic := '0';   
   SIGNAL overflow_cd              :  std_logic := '0';   
   SIGNAL overflow_sum             :  std_logic := '0';   
   SIGNAL rs_block_ab_size         :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL rs_block_cd_size         :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL rs_block_ab_sign_size    :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL rs_block_cd_sign_size    :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_low              :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_high             :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataa_ipd                :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datab_ipd                :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datac_ipd                :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL datad_ipd                :  std_logic_vector(35 DOWNTO 0) := (others => '0');   
   SIGNAL feedback_ipd                :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL saturateab_ipd           :  std_logic := '0';   
   SIGNAL saturatecd_ipd           :  std_logic := '0';   
   SIGNAL multabsaturate_ipd       :  std_logic := '0';   
   SIGNAL multcdsaturate_ipd       :  std_logic := '0';   
   SIGNAL dataout_tbuf             :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL accoverflow_tbuf         :  std_logic;   
   SIGNAL operation                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signx_or_y               :  std_logic;   
   SIGNAL addnsub_signa_input 	   :  std_logic;
   SIGNAL addnsub_signb_input 	   :  std_logic;
   SIGNAL feedback_accuma          :  std_logic_vector(51 DOWNTO 0) := (others => '0');   
   SIGNAL feedback_accumc          :  std_logic_vector(51 DOWNTO 0) := (others => '0');   
   SIGNAL xory_addnsub0            :  std_logic := '0';   
   SIGNAL xory_addnsub1            :  std_logic := '0';   
   SIGNAL tmp_4                   :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL tmp_6                   :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL tmp_8                   :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL tmp_10                  :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL port_tmp38              :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL port_tmp43              :  std_logic_vector(7 DOWNTO 0) := (others => '0');   
   SIGNAL port_tmp50              :  std_logic := '0';   
   SIGNAL tmp_59                  :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp1            :  std_logic_vector(143 DOWNTO 0) := (others => '0');   
   SIGNAL accoverflow_tmp2        :  std_logic := '0';   

BEGIN
   dataa_ipd(dataa_width -1 downto 0) <= dataa;   
   datab_ipd(datab_width -1 downto 0) <= datab;   
   datac_ipd(datac_width -1 downto 0) <= datac;   
   datad_ipd(datad_width -1 downto 0) <= datad; 
   
   WireDelay : block
    begin
        loopbits : FOR i in feedback'RANGE GENERATE
            VitalWireDelay (feedback_ipd(i), feedback(i), tipd_feedback(i));
        END GENERATE;
    end block;
    
   multabsaturate_ipd <= multabsaturate ;   
   multcdsaturate_ipd <= multcdsaturate ;   
   saturateab_ipd <= saturateab ;   
   saturatecd_ipd <= saturatecd ;   
   operation <= "0000" WHEN (operation_mode = "output_only") ELSE "0001" WHEN (operation_mode = "one_level_adder") ELSE "0010" WHEN (operation_mode = "two_level_adder") ELSE "0100" WHEN (operation_mode = "accumulator") ELSE "0111" WHEN (operation_mode = "36_bit_multiply") ELSE "0000" WHEN (((((operation_mode = "dynamic") AND (mode0 = '0')) AND (mode1 = '0')) AND (zeroacc = '0')) AND (zeroacc1 = '0')) ELSE "1100" WHEN (((operation_mode = "dynamic") AND (mode0 = '1')) AND (mode1 = '1')) ELSE "1101" WHEN (((operation_mode = "dynamic") AND (mode0 = '1')) AND (mode1 = '0')) ELSE "1110" WHEN (((operation_mode = "dynamic") AND (mode0 = '0')) AND (mode1 = '1')) ELSE "0111" WHEN (((((operation_mode = "dynamic") AND (mode0 = '0')) AND (mode1 = '0')) AND (zeroacc = '1')) AND (zeroacc1 = '1')) ELSE "0000" ;
   addnsub_signa_input <= signx WHEN (operation_mode = "36_bit_multiply") ELSE signx WHEN (((((operation_mode = "dynamic") AND (mode0 = '0')) AND (mode1 = '0')) AND (zeroacc = '1')) AND (zeroacc1 = '1')) ELSE signx_or_y;
   addnsub_signb_input <= signy WHEN (operation_mode = "36_bit_multiply") ELSE signy WHEN (((((operation_mode = "dynamic") AND (mode0 = '0')) AND (mode1 = '0')) AND (zeroacc = '1')) AND (zeroacc1 = '1')) ELSE signx_or_y;
   tmp_4(dataa_ipd'range) <= dataa_ipd;
   tmp_6(datab_ipd'range) <= datab_ipd;
   tmp_8(datac_ipd'range) <= datac_ipd;
   tmp_10(datad_ipd'range) <= datad_ipd;
   dynamic_src : stratixii_mac_dynamic_src 
      GENERIC MAP (
         dataa_width => dataa_width,
         datab_width => datab_width,
         datac_width => datac_width,
         datad_width => datad_width)
      PORT MAP (
         accuma => feedback_accuma,
         accumc => feedback_accumc,
         dataa => tmp_4,
         datab => tmp_6,
         datac => tmp_8,
         datad => tmp_10,
         multabsaturate => multabsaturate_ipd,
         multcdsaturate => multcdsaturate_ipd,
         zeroacc => zeroacc,
         zeroacc1 => zeroacc1,
         signa => signx,
         signb => signy,
         operation => operation,
         sata => sata,
         satb => satb,
         satc => satc,
         satd => satd,
         satab => satab,
         satcd => satcd,
         outa => dataa_src,
         outb => datab_src,
         outc => datac_src,
         outd => datad_src);   
   
   signx_or_y <= signx OR signy ;
   feedback_accuma <= feedback(52 DOWNTO 37) & feedback(35 DOWNTO 0) WHEN (operation_mode = "dynamic") ELSE feedback(51 DOWNTO 0) ;
   feedback_accumc <= feedback(124 DOWNTO 109) & feedback(107 DOWNTO 72) WHEN (operation_mode = "dynamic") ELSE feedback(123 DOWNTO 72) ;
   addnsub_ab : stratixii_mac_addnsub 
      GENERIC MAP (
         block_type => "ab",
         dataa_width => dataa_width,
         datab_width => datab_width,
         datac_width => datac_width,
         datad_width => datad_width)
      PORT MAP (
         dataa => dataa_src,
         datab => datab_src,
         datac => datac_src,
         datad => datad_src,
         signa => addnsub_signa_input,
         signb => addnsub_signb_input,
         operation => operation,
         addnsub => addnsub0,
         dataout => addnsub_ab_out,
         overflow => overflow_ab);   
   
   addnsub_cd : stratixii_mac_addnsub 
      GENERIC MAP (
         block_type => "cd",
         dataa_width => dataa_width,
         datab_width => datab_width,
         datac_width => datac_width,
         datad_width => datad_width)
      PORT MAP (
         dataa => dataa_src,
         datab => datab_src,
         datac => datac_src,
         datad => datad_src,
         signa => signx_or_y,
         signb => signx_or_y,
         operation => operation,
         addnsub => addnsub1,
         dataout => addnsub_cd_out,
         overflow => overflow_cd);   
   
   port_tmp38 <= "00001111";
   mac_rs_block_low : stratixii_mac_rs_block 
      GENERIC MAP (
         block_type => "ab",
         dataa_width => dataa_width,
         datab_width => datab_width)
      PORT MAP (
         operation => operation,
         round => roundab,
         saturate => saturateab_ipd,
         addnsub => addnsub0,
         signa => signx_or_y,
         signb => signx_or_y,
         signsize => rs_block_ab_sign_size,
         roundsize => port_tmp38,
         dataoutsize => rs_block_ab_size,
         dataa => dataa_src(dataa_width-1 downto 0),
         datab => datab_src(datab_width-1 downto 0),
         datain => addnsub_ab_out,
         dataout => dataout_low);   
   
   rs_block_ab_size <= CONV_STD_LOGIC_VECTOR((datab_width + 16), 8) WHEN (operation(2) = '1') ELSE CONV_STD_LOGIC_VECTOR((dataa_width + 1), 8) WHEN (unsigned(operation) = 1) ELSE CONV_STD_LOGIC_VECTOR((dataa_width + 1), 8) WHEN (unsigned(operation) = 2) ELSE "00100100" ;
   rs_block_ab_sign_size <= "00010010" WHEN (operation(2) = '1') ELSE "00000011" WHEN (unsigned(operation) = 1) OR (unsigned(operation) = 2) ELSE "00000010" ;
   port_tmp43 <= "00001111";
   mac_rs_block_high : stratixii_mac_rs_block 
      GENERIC MAP (
         block_type => "cd",
         dataa_width => datac_width,
         datab_width => datad_width)
      PORT MAP (
         operation => operation,
         round => roundcd,
         saturate => saturatecd_ipd,
         addnsub => addnsub1,
         signa => signx_or_y,
         signb => signx_or_y,
         signsize => rs_block_cd_sign_size,
         roundsize => port_tmp43,
         dataoutsize => rs_block_cd_size,
         dataa => datac_src(datac_width -1 downto 0),
         datab => datad_src(datad_width -1 downto 0),
         datain => addnsub_cd_out,
         dataout => dataout_high);   
   
   rs_block_cd_size <= CONV_STD_LOGIC_VECTOR((datad_width + 16), 8) WHEN (operation(2) = '1') ELSE CONV_STD_LOGIC_VECTOR((datac_width + 1), 8) WHEN (unsigned(operation) = 1) ELSE CONV_STD_LOGIC_VECTOR((datac_width + 1), 8) WHEN (unsigned(operation) = 2) ELSE "00100100" ;
   rs_block_cd_sign_size <= "00010010" WHEN (operation(2) = '1') ELSE "00000011" WHEN (unsigned(operation) = 1) OR (unsigned(operation) = 2) ELSE "00000010" ;
   port_tmp50 <= '1';
   addnsub_sum_abcd : stratixii_mac_addnsub 
      GENERIC MAP (
         block_type => "sum",
         dataa_width => dataa_width,
         datab_width => dataa_width,
         datac_width => datac_width,
         datad_width => datad_width)
      PORT MAP (
         dataa => dataout_low,
         datab => dataout_high,
         datac => datac_src,
         datad => datad_src,
         signa => xory_addnsub0,
         signb => xory_addnsub1,
         operation => operation,
         addnsub => port_tmp50,
         dataout => addnsub_sum,
         overflow => overflow_sum);   
   
   xory_addnsub0 <= signx_or_y OR NOT addnsub0 ;
   xory_addnsub1 <= signx_or_y OR NOT addnsub1 ;
   tmp_59 <= datad_ipd & datac_ipd & datab_ipd & dataa_ipd;
   dynamic_mux : stratixii_mac_dynamic_mux 
      PORT MAP (
         ab => dataout_low,
         cd => dataout_high,
         sata => sata,
         satb => satb,
         satc => satc,
         satd => satd,
         multsatab => satab,
         multsatcd => satcd,
         outsatab => dataout_low(2),
         outsatcd => dataout_high(2),
         multabsaturate => multabsaturate_ipd,
         multcdsaturate => multcdsaturate_ipd,
         saturateab => saturateab_ipd,
         saturatecd => saturatecd_ipd,
         overab => overflow_ab,
         overcd => overflow_cd,
         sum => addnsub_sum,
         m36 => addnsub_ab_out,
         bypass => tmp_59,
         operation => operation,
         dataout => dataout_tmp,
         accoverflow => accoverflow_tmp);   

  PathDelay: for i in dataout'range generate
    PROCESS(dataout_tmp(i))
      variable dataout_VitalGlitchData : VitalGlitchDataType;
    begin
      VitalPathDelay01 (
        OutSignal => dataout(i),
        OutSignalName => "dataout",
        OutTemp => dataout_tmp(i),
              Paths => (1 => (dataa'last_event, tpd_dataa_dataout(i), TRUE),
                  2 => (datab'last_event, tpd_datab_dataout(i), TRUE),
                  3 => (datac'last_event, tpd_datac_dataout(i), TRUE),
                  4 => (datad'last_event, tpd_datad_dataout(i), TRUE),
                  5 => (signx'last_event, tpd_signx_dataout(i), TRUE),
                  6 => (signy'last_event, tpd_signy_dataout(i), TRUE),
                  7 => (addnsub0'last_event, tpd_addnsub0_dataout(i), TRUE),
                  8 => (addnsub1'last_event, tpd_addnsub1_dataout(i), TRUE),
                  9 => (zeroacc'last_event, tpd_zeroacc_dataout(i), TRUE),
                  10 => (zeroacc1'last_event, tpd_zeroacc1_dataout(i), TRUE),
                  11 => (mode0'last_event, tpd_mode0_dataout(i), TRUE),
                  12 => (mode1'last_event, tpd_mode1_dataout(i), TRUE),
                  13 => (multabsaturate'last_event, tpd_multabsaturate_dataout(i), TRUE),
                  14 => (multcdsaturate'last_event, tpd_multcdsaturate_dataout(i), TRUE),
                  15 => (feedback'last_event, tpd_feedback_dataout(i), TRUE)
                  ),
        GlitchData => dataout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn
      );
    end process;
  end generate PathDelay;

  acc: for i in dataa'range generate
  PROCESS(accoverflow_tmp)
    variable accoverflow_VitalGlitchData : VitalGlitchDataType;
  BEGIN
    VitalPathDelay01 (
      OutSignal => accoverflow,
      OutSignalName => "accoverflow",
      OutTemp => accoverflow_tmp,
      Paths => (1 => (dataa'last_event, tpd_dataa_accoverflow(i), TRUE),
                2 => (signx'last_event, tpd_signx_accoverflow, TRUE),
                3 => (signy'last_event, tpd_signy_accoverflow, TRUE),
                4 => (addnsub0'last_event, tpd_addnsub0_accoverflow, TRUE),
                5 => (addnsub1'last_event, tpd_addnsub1_accoverflow, TRUE),
                6 => (zeroacc'last_event, tpd_zeroacc_accoverflow, TRUE),
                7 => (zeroacc1'last_event, tpd_zeroacc1_accoverflow, TRUE),
                8 => (mode0'last_event, tpd_mode0_accoverflow, TRUE),
                9 => (mode1'last_event, tpd_mode1_accoverflow, TRUE),
                10 => (feedback'last_event, tpd_feedback_accoverflow, TRUE)
                ),
      GlitchData => accoverflow_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
  
  END process;
  END GENERATE acc;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                             STRATIXII_MAC_PIN_MAP
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_mac_pin_map IS
   GENERIC (
      tipd_addnsub : VitalDelayType01 := DefPropDelay01;
      data_width :              integer := 144;
      tipd_datain               : VitalDelayArrayType01(143 downto 0) := (OTHERS => (20 ps,20 ps));
      operation_mode 		:  string := "output_only";    
      pinmap 			:  string := "map");
   PORT (
      datain                  : IN std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
      operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
	  addnsub				  : IN std_logic := '0';
      dataout                 : OUT std_logic_vector(data_width -1 DOWNTO 0) := (others => '0'));   
END stratixii_mac_pin_map;

ARCHITECTURE arch OF stratixii_mac_pin_map IS
   SIGNAL addnsub_ipd : std_logic := '0';   
   SIGNAL datain_ipd             :  std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');
   SIGNAL dataout_tmp              :  std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp2            :  std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');   
      
BEGIN
    WireDelay : block
    begin
        VitalWireDelay (addnsub_ipd, addnsub, tipd_addnsub);
        loopbits : FOR i in datain'RANGE GENERATE
            VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
        END GENERATE;
    end block;

   dataout <= dataout_tmp2(dataout'range);

   PROCESS (datain_ipd, addnsub_ipd)
      VARIABLE dataout_tmp_tmp3  : std_logic_vector(143 DOWNTO 0) := (others => '0');
   BEGIN
      IF (operation_mode = "dynamic") THEN
         IF (pinmap = "map") THEN
           CASE operation IS
             WHEN "1100" =>
               dataout_tmp_tmp3 := "XXXXXXXXXXXXXXXXXXX" & datain_ipd(123 DOWNTO 108) &
                                   'X' & datain_ipd(107 DOWNTO 72) &
                                   "XXXXXXXXXXXXXXXXXXX" & datain_ipd(51 DOWNTO 36) &
                                   'X' & datain_ipd(35 DOWNTO 0);
             WHEN "1101" =>
               dataout_tmp_tmp3 := datain_ipd(143 DOWNTO 72)& "XXXXXXXXXXXXXXXXXXX" & datain_ipd(51 DOWNTO 36) & 'X' & datain_ipd(35 DOWNTO 0);    
             WHEN "1110" =>
               dataout_tmp_tmp3 := "XXXXXXXXXXXXXXXXXXX" & datain_ipd(123 DOWNTO 108) & 'X' & datain_ipd(107 DOWNTO 0);    
             WHEN "0111" =>
				IF (addnsub_ipd = '1') THEN				
	               dataout_tmp_tmp3(17 DOWNTO 0) := datain_ipd(17 DOWNTO 0);    
	               dataout_tmp_tmp3(35 DOWNTO 18) := datain_ipd(53 DOWNTO 36);    
	               dataout_tmp_tmp3(53 DOWNTO 36) := datain_ipd(35 DOWNTO 18);    
	               dataout_tmp_tmp3(71 DOWNTO 54) := datain_ipd(71 DOWNTO 54);    
				ELSE
	               dataout_tmp_tmp3(17 DOWNTO 0) := "XXXXXXXXXXXXXXXXXX";    
	               dataout_tmp_tmp3(35 DOWNTO 18) := "XXXXXXXXXXXXXXXXXX";    
	               dataout_tmp_tmp3(53 DOWNTO 36) := "XXXXXXXXXXXXXXXXXX";    
	               dataout_tmp_tmp3(71 DOWNTO 54) := "XXXXXXXXXXXXXXXXXX";    
				END IF;
               dataout_tmp_tmp3(143 DOWNTO 72) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";    
             WHEN OTHERS  =>
               dataout_tmp_tmp3 := datain_ipd;    
           END CASE;
         ELSE
            CASE operation IS
               WHEN "1100" =>
                        dataout_tmp_tmp3(35 DOWNTO 0) := datain_ipd(35 DOWNTO 0);    
                        dataout_tmp_tmp3(70 DOWNTO 36) := datain_ipd(71 DOWNTO 37);    
                        dataout_tmp_tmp3(107 DOWNTO 72) := datain_ipd(107 DOWNTO 72);    
                        dataout_tmp_tmp3(142 DOWNTO 108) := datain_ipd(143 DOWNTO 109);    
               WHEN "1101" =>
                        dataout_tmp_tmp3(35 DOWNTO 0) := datain_ipd(35 DOWNTO 0);    
                        dataout_tmp_tmp3(70 DOWNTO 36) := datain_ipd(71 DOWNTO 37);    
                        dataout_tmp_tmp3(143 DOWNTO 72) := datain_ipd(143 DOWNTO 72);    
               WHEN "1110" =>
                        dataout_tmp_tmp3(107 DOWNTO 0) := datain_ipd(107 DOWNTO 0);    
                        dataout_tmp_tmp3(107 DOWNTO 72) := datain_ipd(107 DOWNTO 72);    
                        dataout_tmp_tmp3(142 DOWNTO 108) := datain_ipd(143 DOWNTO 109);    
               WHEN "0111" =>
                        dataout_tmp_tmp3(17 DOWNTO 0) := datain_ipd(17 DOWNTO 0);    
                        dataout_tmp_tmp3(53 DOWNTO 36) := datain_ipd(35 DOWNTO 18);    
                        dataout_tmp_tmp3(35 DOWNTO 18) := datain_ipd(53 DOWNTO 36);    
                        dataout_tmp_tmp3(71 DOWNTO 54) := datain_ipd(71 DOWNTO 54);    
                        dataout_tmp_tmp3(143 DOWNTO 72) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";    
               WHEN OTHERS  =>
                        dataout_tmp_tmp3 := datain_ipd;    
               
            END CASE;
         END IF;
      ELSE
         dataout_tmp_tmp3 := datain_ipd;    
      END IF;
      dataout_tmp <= dataout_tmp_tmp3;
   END PROCESS;
   dataout_tmp2 <= dataout_tmp ;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                               STRATIXII_MAC_OUT
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
use work.stratixii_mac_out_internal;
use work.stratixii_mac_pin_map;
use work.stratixii_mac_bit_register;
use work.stratixii_mac_register;

ENTITY stratixii_mac_out IS
   GENERIC (
      operation_mode                 :  string := "output_only";    
      dataa_width                    :  integer := 1;    
      datab_width                    :  integer := 1;    
      datac_width                    :  integer := 1;    
      datad_width                    :  integer := 1;    
      dataout_width                  :  integer := 144;
      tmp_width                      :  integer := 144;
      addnsub0_clock                 :  string := "none";    
      addnsub1_clock                 :  string := "none";    
      zeroacc_clock                  :  string := "none";    
      round0_clock                   :  string := "none";    
      round1_clock                   :  string := "none";    
      saturate_clock                 :  string := "none";    
      multabsaturate_clock           :  string := "none";    
      multcdsaturate_clock           :  string := "none";    
      signa_clock                    :  string := "none";    
      signb_clock                    :  string := "none";    
      output_clock                   :  string := "none";    
      addnsub0_clear                 :  string := "none";    
      addnsub1_clear                 :  string := "none";    
      zeroacc_clear                  :  string := "none";    
      round0_clear                   :  string := "none";    
      round1_clear                   :  string := "none";    
      saturate_clear                 :  string := "none";    
      multabsaturate_clear           :  string := "none";    
      multcdsaturate_clear           :  string := "none";    
      signa_clear                    :  string := "none";    
      signb_clear                    :  string := "none";    
      output_clear                   :  string := "none";    
      addnsub0_pipeline_clock        :  string := "none";    
      addnsub1_pipeline_clock        :  string := "none";    
      round0_pipeline_clock          :  string := "none";    
      round1_pipeline_clock          :  string := "none";    
      saturate_pipeline_clock        :  string := "none";    
      multabsaturate_pipeline_clock  :  string := "none";    
      multcdsaturate_pipeline_clock  :  string := "none";    
      zeroacc_pipeline_clock         :  string := "none";    
      signa_pipeline_clock           :  string := "none";    
      signb_pipeline_clock           :  string := "none";    
      addnsub0_pipeline_clear        :  string := "none";    
      addnsub1_pipeline_clear        :  string := "none";    
      round0_pipeline_clear          :  string := "none";    
      round1_pipeline_clear          :  string := "none";    
      saturate_pipeline_clear        :  string := "none";    
      multabsaturate_pipeline_clear  :  string := "none";    
      multcdsaturate_pipeline_clear  :  string := "none";    
      zeroacc_pipeline_clear         :  string := "none";    
      signa_pipeline_clear           :  string := "none";    
      signb_pipeline_clear           :  string := "none";    
      mode0_clock                    :  string := "none";    
      mode1_clock                    :  string := "none";    
      zeroacc1_clock                 :  string := "none";    
      saturate1_clock                :  string := "none";    
      output1_clock                  :  string := "none";    
      output2_clock                  :  string := "none";    
      output3_clock                  :  string := "none";    
      output4_clock                  :  string := "none";    
      output5_clock                  :  string := "none";    
      output6_clock                  :  string := "none";    
      output7_clock                  :  string := "none";    
      mode0_clear                    :  string := "none";    
      mode1_clear                    :  string := "none";    
      zeroacc1_clear                 :  string := "none";    
      saturate1_clear                :  string := "none";    
      output1_clear                  :  string := "none";    
      output2_clear                  :  string := "none";    
      output3_clear                  :  string := "none";    
      output4_clear                  :  string := "none";    
      output5_clear                  :  string := "none";    
      output6_clear                  :  string := "none";    
      output7_clear                  :  string := "none";    
      mode0_pipeline_clock           :  string := "none";    
      mode1_pipeline_clock           :  string := "none";    
      zeroacc1_pipeline_clock        :  string := "none";    
      saturate1_pipeline_clock       :  string := "none";    
      mode0_pipeline_clear           :  string := "none";    
      mode1_pipeline_clear           :  string := "none";    
      zeroacc1_pipeline_clear        :  string := "none";    
      saturate1_pipeline_clear       :  string := "none";    
      dataa_forced_to_zero           :  string := "no";    
      datac_forced_to_zero           :  string := "no";    
      lpm_hint                       :  string := "true";    
      lpm_type                       :  string := "stratixii_mac_out");
   PORT (
      dataa                   : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '1');
      datab                   : IN std_logic_vector(datab_width-1 DOWNTO 0) := (others => '1');
      datac                   : IN std_logic_vector(datac_width-1 DOWNTO 0) := (others => '1');
      datad                   : IN std_logic_vector(datad_width-1 DOWNTO 0) := (others => '1');
      zeroacc                 : IN std_logic := '0';
      addnsub0                : IN std_logic := '1';   
      addnsub1                : IN std_logic := '1';   
      round0                  : IN std_logic := '0';   
      round1                  : IN std_logic := '0';   
      saturate                : IN std_logic := '0';   
      multabsaturate          : IN std_logic := '0';   
      multcdsaturate          : IN std_logic := '0';   
      signa                   : IN std_logic := '1';   
      signb                   : IN std_logic := '1';   
      clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
      ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');   
      mode0                   : IN std_logic := '0';  
      mode1                   : IN std_logic := '0';   
      zeroacc1                : IN std_logic := '0';  
      saturate1               : IN std_logic := '0';  
      dataout                 : OUT std_logic_vector(dataout_width -1 DOWNTO 0) := (others => '0');   
      accoverflow             : OUT std_logic := '0';   
      devclrn                 : IN std_logic := '1';   
      devpor                  : IN std_logic := '1'
      );   
END stratixii_mac_out;

ARCHITECTURE arch OF stratixii_mac_out IS

   COMPONENT stratixii_mac_out_internal
      GENERIC (
                operation_mode                 :  string := "output_only";    
                dataa_width                    :  integer := 36;    
                datab_width                    :  integer := 36;    
                datac_width                    :  integer := 36;    
                datad_width                    :  integer := 36;
                tmp_width                      :  integer := 144;
                dataout_width                  :  integer := 144;
                tipd_dataa        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
                tipd_datab        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
                tipd_datac        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
                tipd_datad        : VitalDelayArrayType01(35 downto 0):= (OTHERS => DefPropDelay01);
                tipd_feedback        : VitalDelayArrayType01(143 downto 0):= (OTHERS => DefPropDelay01);
     	        tpd_dataa_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
     	  tpd_datab_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
     	  tpd_datac_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
     	  tpd_datad_dataout         : VitalDelayArrayType01(144*36-1 downto 0) := (others => DefPropDelay01);
     	  tpd_feedback_dataout         : VitalDelayArrayType01(144*144-1 downto 0) := (others => DefPropDelay01);
     	  tpd_signx_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_signy_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_addnsub0_dataout      : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_addnsub1_dataout      : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_zeroacc_dataout       : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_zeroacc1_dataout      : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_multabsaturate_dataout: VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_multcdsaturate_dataout: VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_mode0_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_mode1_dataout         : VitalDelayArrayType01(143 downto 0) := (others => DefPropDelay01);
     	  tpd_dataa_accoverflow     : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
                tpd_feedback_accoverflow     : VitalDelayType01 := DefPropDelay01;
                tpd_signx_accoverflow     : VitalDelayType01 := DefPropDelay01;
                tpd_signy_accoverflow     : VitalDelayType01 := DefPropDelay01;
                tpd_addnsub0_accoverflow  : VitalDelayType01 := DefPropDelay01;
                tpd_addnsub1_accoverflow  : VitalDelayType01 := DefPropDelay01;
                tpd_zeroacc_accoverflow   : VitalDelayType01 := DefPropDelay01;
                tpd_zeroacc1_accoverflow  : VitalDelayType01 := DefPropDelay01;
                tpd_mode0_accoverflow     : VitalDelayType01 := DefPropDelay01;
                tpd_mode1_accoverflow     : VitalDelayType01 := DefPropDelay01;
                XOn: Boolean              := DefGlitchXOn;   
                MsgOn: Boolean            := DefGlitchMsgOn
             );
      PORT (
         dataa                   : IN  std_logic_vector(dataa_width -1 DOWNTO 0) := (others => '0');
         datab                   : IN  std_logic_vector(datab_width -1 DOWNTO 0) := (others => '0');
         datac                   : IN  std_logic_vector(datac_width -1 DOWNTO 0) := (others => '0');
         datad                   : IN  std_logic_vector(datad_width -1 DOWNTO 0) := (others => '0');
         mode0                   : IN  std_logic := '0';
         mode1                   : IN  std_logic := '0';
         roundab                 : IN  std_logic := '0';
         saturateab              : IN  std_logic := '0';
         roundcd                 : IN  std_logic := '0';
         saturatecd              : IN  std_logic := '0';
         multabsaturate          : IN  std_logic := '0';
         multcdsaturate          : IN  std_logic := '0';
         signx                   : IN  std_logic := '0';
         signy                   : IN  std_logic := '0';
         addnsub0                : IN  std_logic := '0';
         addnsub1                : IN  std_logic := '0';
         zeroacc                 : IN  std_logic := '0';
         zeroacc1                : IN  std_logic := '0';
         feedback  			      : IN  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');
         dataout                 : OUT std_logic_vector(dataout_width-1 DOWNTO 0) := (others => '0');
         accoverflow             : OUT std_logic);
   END COMPONENT;

   COMPONENT stratixii_mac_pin_map
      GENERIC (
          pinmap                         :  string := "map";
          data_width :          integer := 144;
          operation_mode                 :  string := "output_only");
      PORT (
         datain                  : IN  std_logic_vector(data_width-1 DOWNTO 0) := (others => '0');
         operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
	 	 addnsub				 : IN  std_logic := '0';
         dataout                 : OUT std_logic_vector(data_width-1 DOWNTO 0) := (others => '0'));
   END COMPONENT;

   COMPONENT stratixii_mac_bit_register
      GENERIC (
          power_up                       :  std_logic := '0');
      PORT (
        data                    : IN std_logic := '0';   
        clk                     : IN std_logic := '0';   
        aclr                    : IN std_logic := '0';
        if_aclr                 : IN std_logic := '0';
        ena                     : IN std_logic := '1';
        async                   : IN std_logic := '1';
        dataout                 : OUT std_logic := '0');   
   END COMPONENT;

   COMPONENT stratixii_mac_register
      GENERIC (
          power_up                       :  std_logic := '0';    
          data_width                     :  integer := 18);
      PORT (
         data                    : IN  std_logic_vector(data_width -1 DOWNTO 0) := (others => '0');
         clk                     : IN  std_logic := '0';
         aclr                    : IN  std_logic := '0';
         if_aclr                 : IN  std_logic := '0';
         ena                     : IN  std_logic := '1';
         async                   : IN  std_logic := '1';
         dataout                 : OUT std_logic_vector(data_width -1 DOWNTO 0) := (others => '0'));
   END COMPONENT;

   SIGNAL dataa_f                  :  std_logic_vector(dataa_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL datac_f                  :  std_logic_vector(datac_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL signa_pipe               :  std_logic :=  '0';   
   SIGNAL signb_pipe               :  std_logic :=  '0';   
   SIGNAL multabsaturate_pipe      :  std_logic :=  '0';   
   SIGNAL multcdsaturate_pipe      :  std_logic :=  '0';   
   SIGNAL signa_out                :  std_logic :=  '0';   
   SIGNAL signb_out                :  std_logic :=  '0';   
   SIGNAL multabsaturate_out       :  std_logic :=  '0';   
   SIGNAL multcdsaturate_out       :  std_logic :=  '0';   
   SIGNAL addnsub0_pipe            :  std_logic :=  '0';   
   SIGNAL addnsub1_pipe            :  std_logic :=  '0';   
   SIGNAL addnsub0_out             :  std_logic :=  '0';   
   SIGNAL addnsub1_out             :  std_logic :=  '0';   
   SIGNAL zeroacc_pipe             :  std_logic :=  '0';   
   SIGNAL zeroacc1_pipe            :  std_logic :=  '0';   
   SIGNAL zeroacc_out              :  std_logic :=  '0';   
   SIGNAL zeroacc1_out             :  std_logic :=  '0';   
   SIGNAL dataout_feedback         :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp              :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_map              :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_mapped           :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_unmapped         :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_non_dynamic      :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic          :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');  
   SIGNAL dataout_dynamic1         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic2         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic3         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic4         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic5         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic6         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_dynamic7         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp_low          :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_tmp_high         :  std_logic_vector(71 DOWNTO 0) := (others => '0');   
   SIGNAL dataout_to_reg           :  std_logic_vector(tmp_width-1 DOWNTO 0) := (others => '0');   
   SIGNAL accoverflow_reg          :  std_logic := '0';   
   SIGNAL accoverflow_tmp          :  std_logic := '0';   
   SIGNAL operation                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round0_pipe              :  std_logic := '0'; 
   SIGNAL round1_pipe              :  std_logic := '0';   
   SIGNAL saturate_pipe            :  std_logic := '0';   
   SIGNAL saturate1_pipe           :  std_logic := '0';   
   SIGNAL mode0_pipe               :  std_logic := '0';   
   SIGNAL mode1_pipe               :  std_logic := '0';   
   SIGNAL round0_out               :  std_logic := '0';   
   SIGNAL round1_out               :  std_logic := '0';   
   SIGNAL saturate_out             :  std_logic := '0';   
   SIGNAL saturate1_out            :  std_logic := '0';   
   SIGNAL mode0_out                :  std_logic := '0';   
   SIGNAL mode1_out                :  std_logic := '0';   
   SIGNAL addnsub0_clk             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub1_clk             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round0_clk               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round1_clk               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate_clk             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multabsaturate_clk       :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multcdsaturate_clk       :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signa_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signb_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output_clk               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub0_aclr            :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub1_aclr            :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round0_aclr              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round1_aclr              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate_aclr            :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multabsaturate_aclr      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multcdsaturate_aclr      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signa_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signb_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output_aclr              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub0_pipeline_clk    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub1_pipeline_clk    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round0_pipeline_clk      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round1_pipeline_clk      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate_pipeline_clk    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multabsaturate_pipeline_clk     :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multcdsaturate_pipeline_clk     :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc_pipeline_clk     :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signa_pipeline_clk       :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signb_pipeline_clk       :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub0_pipeline_aclr   :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL addnsub1_pipeline_aclr   :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round0_pipeline_aclr     :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL round1_pipeline_aclr     :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate_pipeline_aclr   :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multabsaturate_pipeline_aclr    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL multcdsaturate_pipeline_aclr    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc_pipeline_aclr    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signa_pipeline_aclr      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL signb_pipeline_aclr      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode0_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode1_clk                :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc1_clk             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate1_clk            :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output1_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output2_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output3_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output4_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output5_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output6_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output7_clk              :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode0_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode1_aclr               :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc1_aclr            :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate1_aclr           :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output1_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output2_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output3_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output4_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output5_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output6_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL output7_aclr             :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode0_pipeline_clk       :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode1_pipeline_clk       :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc1_pipeline_clk    :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate1_pipeline_clk   :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode0_pipeline_aclr      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL mode1_pipeline_aclr      :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL zeroacc1_pipeline_aclr   :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL saturate1_pipeline_aclr  :  std_logic_vector(3 DOWNTO 0) := (others => '0');   
   SIGNAL clk_signa                :  std_logic := '0';   
   SIGNAL clear_signa              :  std_logic := '0';   
   SIGNAL aclr_signa               :  std_logic := '0';   
   SIGNAL ena_signa                :  std_logic := '0';   
   SIGNAL async_signa              :  std_logic := '0';   
   SIGNAL clk_signb                :  std_logic := '0';   
   SIGNAL clear_signb              :  std_logic := '0';   
   SIGNAL aclr_signb               :  std_logic := '0';   
   SIGNAL ena_signb                :  std_logic := '0';   
   SIGNAL async_signb              :  std_logic := '0';   
   SIGNAL clk_zeroacc              :  std_logic := '0';   
   SIGNAL clear_zeroacc            :  std_logic := '0';   
   SIGNAL aclr_zeroacc             :  std_logic := '0';   
   SIGNAL ena_zeroacc              :  std_logic := '0';   
   SIGNAL async_zeroacc            :  std_logic := '0';   
   SIGNAL clk_zeroacc1             :  std_logic := '0';   
   SIGNAL clear_zeroacc1           :  std_logic := '0';   
   SIGNAL aclr_zeroacc1            :  std_logic := '0';   
   SIGNAL ena_zeroacc1             :  std_logic := '0';   
   SIGNAL async_zeroacc1           :  std_logic := '0';   
   SIGNAL clk_addnsub0             :  std_logic := '0';   
   SIGNAL clear_addnsub0           :  std_logic := '0';   
   SIGNAL aclr_addnsub0            :  std_logic := '0';   
   SIGNAL ena_addnsub0             :  std_logic := '0';   
   SIGNAL async_addnsub0           :  std_logic := '0';   
   SIGNAL clk_addnsub1             :  std_logic := '0';   
   SIGNAL clear_addnsub1           :  std_logic := '0';   
   SIGNAL aclr_addnsub1            :  std_logic := '0';   
   SIGNAL ena_addnsub1             :  std_logic := '0';   
   SIGNAL async_addnsub1           :  std_logic := '0';   
   SIGNAL clk_round0               :  std_logic := '0';   
   SIGNAL clear_round0             :  std_logic := '0';   
   SIGNAL aclr_round0              :  std_logic := '0';   
   SIGNAL ena_round0               :  std_logic := '0';   
   SIGNAL async_round0             :  std_logic := '0';   
   SIGNAL clk_saturate             :  std_logic := '0';   
   SIGNAL clear_saturate           :  std_logic := '0';   
   SIGNAL aclr_saturate            :  std_logic := '0';   
   SIGNAL ena_saturate             :  std_logic := '0';   
   SIGNAL async_saturate           :  std_logic := '0';   
   SIGNAL clk_mode0                :  std_logic := '0';   
   SIGNAL clear_mode0              :  std_logic := '0';   
   SIGNAL aclr_mode0               :  std_logic := '0';   
   SIGNAL ena_mode0                :  std_logic := '0';   
   SIGNAL async_mode0              :  std_logic := '0';   
   SIGNAL clk_round1               :  std_logic := '0';   
   SIGNAL clear_round1             :  std_logic := '0';   
   SIGNAL aclr_round1              :  std_logic := '0';   
   SIGNAL ena_round1               :  std_logic := '0';   
   SIGNAL async_round1             :  std_logic := '0';   
   SIGNAL clk_saturate1            :  std_logic := '0';   
   SIGNAL clear_saturate1          :  std_logic := '0';   
   SIGNAL aclr_saturate1           :  std_logic := '0';   
   SIGNAL ena_saturate1            :  std_logic := '0';   
   SIGNAL async_saturate1          :  std_logic := '0';   
   SIGNAL clk_mode1                :  std_logic := '0';   
   SIGNAL clear_mode1              :  std_logic := '0';   
   SIGNAL aclr_mode1               :  std_logic := '0';   
   SIGNAL ena_mode1                :  std_logic := '0';   
   SIGNAL async_mode1              :  std_logic := '0';   
   SIGNAL clk_multabsaturate       :  std_logic := '0';   
   SIGNAL clear_multabsaturate     :  std_logic := '0';   
   SIGNAL aclr_multabsaturate      :  std_logic := '0';   
   SIGNAL ena_multabsaturate       :  std_logic := '0';   
   SIGNAL async_multabsaturate     :  std_logic := '0';   
   SIGNAL clk_multcdsaturate       :  std_logic := '0';   
   SIGNAL clear_multcdsaturate     :  std_logic := '0';   
   SIGNAL aclr_multcdsaturate      :  std_logic := '0';   
   SIGNAL ena_multcdsaturate       :  std_logic := '0';   
   SIGNAL async_multcdsaturate     :  std_logic := '0';   
   SIGNAL clk_signa_pipeline       :  std_logic := '0';   
   SIGNAL clear_signa_pipeline     :  std_logic := '0';   
   SIGNAL aclr_signa_pipeline      :  std_logic := '0';   
   SIGNAL ena_signa_pipeline       :  std_logic := '0';   
   SIGNAL async_signa_pipeline     :  std_logic := '0';   
   SIGNAL clk_signb_pipeline       :  std_logic := '0';   
   SIGNAL clear_signb_pipeline     :  std_logic := '0';   
   SIGNAL aclr_signb_pipeline      :  std_logic := '0';   
   SIGNAL ena_signb_pipeline       :  std_logic := '0';   
   SIGNAL async_signb_pipeline     :  std_logic := '0';   
   SIGNAL clk_zeroacc_pipeline     :  std_logic := '0';   
   SIGNAL clear_zeroacc_pipeline   :  std_logic := '0';   
   SIGNAL aclr_zeroacc_pipeline    :  std_logic := '0';   
   SIGNAL ena_zeroacc_pipeline     :  std_logic := '0';   
   SIGNAL async_zeroacc_pipeline   :  std_logic := '0';   
   SIGNAL clk_zeroacc1_pipeline    :  std_logic := '0';   
   SIGNAL clear_zeroacc1_pipeline  :  std_logic := '0';   
   SIGNAL aclr_zeroacc1_pipeline   :  std_logic := '0';   
   SIGNAL ena_zeroacc1_pipeline    :  std_logic := '0';   
   SIGNAL async_zeroacc1_pipeline  :  std_logic := '0';   
   SIGNAL clk_addnsub0_pipeline    :  std_logic := '0';   
   SIGNAL clear_addnsub0_pipeline  :  std_logic := '0';   
   SIGNAL aclr_addnsub0_pipeline   :  std_logic := '0';   
   SIGNAL ena_addnsub0_pipeline    :  std_logic := '0';   
   SIGNAL async_addnsub0_pipeline  :  std_logic := '0';   
   SIGNAL clk_addnsub1_pipeline    :  std_logic := '0';   
   SIGNAL clear_addnsub1_pipeline  :  std_logic := '0';   
   SIGNAL aclr_addnsub1_pipeline   :  std_logic := '0';   
   SIGNAL ena_addnsub1_pipeline    :  std_logic := '0';   
   SIGNAL async_addnsub1_pipeline  :  std_logic := '0';   
   SIGNAL clk_round0_pipeline      :  std_logic := '0';   
   SIGNAL clear_round0_pipeline    :  std_logic := '0';   
   SIGNAL aclr_round0_pipeline     :  std_logic := '0';   
   SIGNAL ena_round0_pipeline      :  std_logic := '0';   
   SIGNAL async_round0_pipeline    :  std_logic := '0';   
   SIGNAL clk_saturate_pipeline    :  std_logic := '0';   
   SIGNAL clear_saturate_pipeline  :  std_logic := '0';   
   SIGNAL aclr_saturate_pipeline   :  std_logic := '0';   
   SIGNAL ena_saturate_pipeline    :  std_logic := '0';   
   SIGNAL async_saturate_pipeline  :  std_logic := '0';   
   SIGNAL clk_mode0_pipeline       :  std_logic := '0';   
   SIGNAL clear_mode0_pipeline     :  std_logic := '0';   
   SIGNAL aclr_mode0_pipeline      :  std_logic := '0';   
   SIGNAL ena_mode0_pipeline       :  std_logic := '0';   
   SIGNAL async_mode0_pipeline     :  std_logic := '0';   
   SIGNAL clk_round1_pipeline      :  std_logic := '0';   
   SIGNAL clear_round1_pipeline    :  std_logic := '0';   
   SIGNAL aclr_round1_pipeline     :  std_logic := '0';   
   SIGNAL ena_round1_pipeline      :  std_logic := '0';   
   SIGNAL async_round1_pipeline    :  std_logic := '0';   
   SIGNAL clk_saturate1_pipeline   :  std_logic := '0';   
   SIGNAL clear_saturate1_pipeline :  std_logic := '0';   
   SIGNAL aclr_saturate1_pipeline  :  std_logic := '0';   
   SIGNAL ena_saturate1_pipeline   :  std_logic := '0';   
   SIGNAL async_saturate1_pipeline :  std_logic := '0';   
   SIGNAL clk_mode1_pipeline       :  std_logic := '0';   
   SIGNAL clear_mode1_pipeline     :  std_logic := '0';   
   SIGNAL aclr_mode1_pipeline      :  std_logic := '0';   
   SIGNAL ena_mode1_pipeline       :  std_logic := '0';   
   SIGNAL async_mode1_pipeline     :  std_logic := '0';   
   SIGNAL clk_multabsaturate_pipeline     :  std_logic := '0';   
   SIGNAL clear_multabsaturate_pipeline   :  std_logic := '0';   
   SIGNAL aclr_multabsaturate_pipeline    :  std_logic := '0';   
   SIGNAL ena_multabsaturate_pipeline     :  std_logic := '0';   
   SIGNAL async_multabsaturate_pipeline   :  std_logic := '0';   
   SIGNAL clk_multcdsaturate_pipeline     :  std_logic := '0';   
   SIGNAL clear_multcdsaturate_pipeline   :  std_logic := '0';   
   SIGNAL aclr_multcdsaturate_pipeline    :  std_logic := '0';   
   SIGNAL ena_multcdsaturate_pipeline     :  std_logic := '0';   
   SIGNAL async_multcdsaturate_pipeline   :  std_logic := '0';   
   SIGNAL clk_output               :  std_logic := '0';   
   SIGNAL clear_output             :  std_logic := '0';   
   SIGNAL aclr_output              :  std_logic := '0';   
   SIGNAL ena_output               :  std_logic := '0';   
   SIGNAL async_output             :  std_logic := '0';   
   SIGNAL clk_output1              :  std_logic := '0';   
   SIGNAL clear_output1            :  std_logic := '0';   
   SIGNAL aclr_output1             :  std_logic := '0';   
   SIGNAL ena_output1              :  std_logic := '0';   
   SIGNAL async_output1            :  std_logic := '0';   
   SIGNAL clk_output2              :  std_logic := '0';   
   SIGNAL clear_output2            :  std_logic := '0';   
   SIGNAL aclr_output2             :  std_logic := '0';   
   SIGNAL ena_output2              :  std_logic := '0';   
   SIGNAL async_output2            :  std_logic := '0';   
   SIGNAL clk_output3              :  std_logic := '0';   
   SIGNAL clear_output3            :  std_logic := '0';   
   SIGNAL aclr_output3             :  std_logic := '0';   
   SIGNAL ena_output3              :  std_logic := '0';   
   SIGNAL async_output3            :  std_logic := '0';   
   SIGNAL clk_output4              :  std_logic := '0';   
   SIGNAL clear_output4            :  std_logic := '0';   
   SIGNAL aclr_output4             :  std_logic := '0';   
   SIGNAL ena_output4              :  std_logic := '0';   
   SIGNAL async_output4            :  std_logic := '0';   
   SIGNAL clk_output5              :  std_logic := '0';   
   SIGNAL clear_output5            :  std_logic := '0';   
   SIGNAL aclr_output5             :  std_logic := '0';   
   SIGNAL ena_output5              :  std_logic := '0';   
   SIGNAL async_output5            :  std_logic := '0';   
   SIGNAL clk_output6              :  std_logic := '0';   
   SIGNAL clear_output6            :  std_logic := '0';   
   SIGNAL aclr_output6             :  std_logic := '0';   
   SIGNAL ena_output6              :  std_logic := '0';   
   SIGNAL async_output6            :  std_logic := '0';   
   SIGNAL clk_output7              :  std_logic := '0';   
   SIGNAL clear_output7            :  std_logic := '0';   
   SIGNAL aclr_output7             :  std_logic := '0';   
   SIGNAL ena_output7              :  std_logic := '0';   
   SIGNAL async_output7            :  std_logic := '0';   
   SIGNAL tmp_186                 :  std_logic := '0';   
   SIGNAL tmp_189                 :  std_logic := '0';   
   SIGNAL accoverflow_tmp2        :  std_logic := '0';   
   SIGNAL pin_map_addnsub		  :  std_logic := '0';

BEGIN
   dataout <= dataout_tmp(dataout'range);
   accoverflow <= accoverflow_tmp2;
   signa_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => signa,
         clk => clk_signa,
         aclr => aclr_signa,
         if_aclr => clear_signa,
         ena => ena_signa,
         dataout => signa_pipe,
         async => async_signa);   
   
   async_signa <= '1' WHEN (signa_clock = "none") ELSE '0' ;
   clear_signa <= '1' WHEN (signa_clear /= "none") ELSE '0' ;
   clk_signa <= '1' WHEN clk(conv_integer(signa_clk)) = '1' ELSE '0' ;
   aclr_signa <= '1' WHEN (aclr(conv_integer(signa_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_signa <= '1' WHEN ena(conv_integer(signa_clk)) = '1' ELSE '0' ;
   signa_clk <= "0000" WHEN ((signa_clock = "0") OR (signa_clock = "none")) ELSE "0001" WHEN (signa_clock = "1") ELSE "0010" WHEN (signa_clock = "2") ELSE "0011" WHEN (signa_clock = "3") ELSE "0000" ;
   signa_aclr <= "0000" WHEN ((signa_clear = "0") OR (signa_clear = "none")) ELSE "0001" WHEN (signa_clear = "1") ELSE "0010" WHEN (signa_clear = "2") ELSE "0011" WHEN (signa_clear = "3") ELSE "0000" ;
   signb_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => signb,
         clk => clk_signb,
         aclr => aclr_signb,
         if_aclr => clear_signb,
         ena => ena_signb,
         dataout => signb_pipe,
         async => async_signb);   
   
   async_signb <= '1' WHEN (signb_clock = "none") ELSE '0' ;
   clear_signb <= '1' WHEN (signb_clear /= "none") ELSE '0' ;
   clk_signb <= '1' WHEN clk(conv_integer(signb_clk)) = '1' ELSE '0' ;
   aclr_signb <= '1' WHEN (aclr(conv_integer(signb_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_signb <= '1' WHEN ena(conv_integer(signb_clk)) = '1' ELSE '0' ;
   signb_clk <= "0000" WHEN ((signb_clock = "0") OR (signb_clock = "none")) ELSE "0001" WHEN (signb_clock = "1") ELSE "0010" WHEN (signb_clock = "2") ELSE "0011" WHEN (signb_clock = "3") ELSE "0000" ;
   signb_aclr <= "0000" WHEN ((signb_clear = "0") OR (signb_clear = "none")) ELSE "0001" WHEN (signb_clear = "1") ELSE "0010" WHEN (signb_clear = "2") ELSE "0011" WHEN (signb_clear = "3") ELSE "0000" ;
   zeroacc_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => zeroacc,
         clk => clk_zeroacc,
         aclr => aclr_zeroacc,
         if_aclr => clear_zeroacc,
         ena => ena_zeroacc,
         dataout => zeroacc_pipe,
         async => async_zeroacc);   
   
   async_zeroacc <= '1' WHEN (zeroacc_clock = "none") ELSE '0' ;
   clear_zeroacc <= '1' WHEN (zeroacc_clear /= "none") ELSE '0' ;
   clk_zeroacc <= '1' WHEN clk(conv_integer(zeroacc_clk)) = '1' ELSE '0' ;
   aclr_zeroacc <= '1' WHEN (aclr(conv_integer(zeroacc_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_zeroacc <= '1' WHEN ena(conv_integer(zeroacc_clk)) = '1' ELSE '0' ;
   zeroacc_clk <= "0000" WHEN ((zeroacc_clock = "0") OR (zeroacc_clock = "none")) ELSE "0001" WHEN (zeroacc_clock = "1") ELSE "0010" WHEN (zeroacc_clock = "2") ELSE "0011" WHEN (zeroacc_clock = "3") ELSE "0000" ;
   zeroacc_aclr <= "0000" WHEN ((zeroacc_clear = "0") OR (zeroacc_clear = "none")) ELSE "0001" WHEN (zeroacc_clear = "1") ELSE "0010" WHEN (zeroacc_clear = "2") ELSE "0011" WHEN (zeroacc_clear = "3") ELSE "0000" ;
   zeroacc1_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => zeroacc1,
         clk => clk_zeroacc1,
         aclr => aclr_zeroacc1,
         if_aclr => clear_zeroacc1,
         ena => ena_zeroacc1,
         dataout => zeroacc1_pipe,
         async => async_zeroacc1);   
   
   async_zeroacc1 <= '1' WHEN (zeroacc1_clock = "none") ELSE '0' ;
   clear_zeroacc1 <= '1' WHEN (zeroacc1_clear /= "none") ELSE '0' ;
   clk_zeroacc1 <= '1' WHEN clk(conv_integer(zeroacc1_clk)) = '1' ELSE '0' ;
   aclr_zeroacc1 <= '1' WHEN (aclr(conv_integer(zeroacc1_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_zeroacc1 <= '1' WHEN ena(conv_integer(zeroacc1_clk)) = '1' ELSE '0' ;
   zeroacc1_clk <= "0000" WHEN ((zeroacc1_clock = "0") OR (zeroacc1_clock = "none")) ELSE "0001" WHEN (zeroacc1_clock = "1") ELSE "0010" WHEN (zeroacc1_clock = "2") ELSE "0011" WHEN (zeroacc1_clock = "3") ELSE "0000" ;
   zeroacc1_aclr <= "0000" WHEN ((zeroacc1_clear = "0") OR (zeroacc1_clear = "none")) ELSE "0001" WHEN (zeroacc1_clear = "1") ELSE "0010" WHEN (zeroacc1_clear = "2") ELSE "0011" WHEN (zeroacc1_clear = "3") ELSE "0000" ;
   addnsub0_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => addnsub0,
         clk => clk_addnsub0,
         aclr => aclr_addnsub0,
         if_aclr => clear_addnsub0,
         ena => ena_addnsub0,
         dataout => addnsub0_pipe,
         async => async_addnsub0);   
   
   async_addnsub0 <= '1' WHEN (addnsub0_clock = "none") ELSE '0' ;
   clear_addnsub0 <= '1' WHEN (addnsub0_clear /= "none") ELSE '0' ;
   clk_addnsub0 <= '1' WHEN clk(conv_integer(addnsub0_clk)) = '1' ELSE '0' ;
   aclr_addnsub0 <= '1' WHEN (aclr(conv_integer(addnsub0_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_addnsub0 <= '1' WHEN ena(conv_integer(addnsub0_clk)) = '1' ELSE '0' ;
   addnsub0_clk <= "0000" WHEN ((addnsub0_clock = "0") OR (addnsub0_clock = "none")) ELSE "0001" WHEN (addnsub0_clock = "1") ELSE "0010" WHEN (addnsub0_clock = "2") ELSE "0011" WHEN (addnsub0_clock = "3") ELSE "0000" ;
   addnsub0_aclr <= "0000" WHEN ((addnsub0_clear = "0") OR (addnsub0_clear = "none")) ELSE "0001" WHEN (addnsub0_clear = "1") ELSE "0010" WHEN (addnsub0_clear = "2") ELSE "0011" WHEN (addnsub0_clear = "3") ELSE "0000" ;
   addnsub1_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => addnsub1,
         clk => clk_addnsub1,
         aclr => aclr_addnsub1,
         if_aclr => clear_addnsub1,
         ena => ena_addnsub1,
         dataout => addnsub1_pipe,
         async => async_addnsub1);   
   
   async_addnsub1 <= '1' WHEN (addnsub1_clock = "none") ELSE '0' ;
   clear_addnsub1 <= '1' WHEN (addnsub1_clear /= "none") ELSE '0' ;
   clk_addnsub1 <= '1' WHEN clk(conv_integer(addnsub1_clk)) = '1' ELSE '0' ;
   aclr_addnsub1 <= '1' WHEN (aclr(conv_integer(addnsub1_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_addnsub1 <= '1' WHEN ena(conv_integer(addnsub1_clk)) = '1' ELSE '0' ;
   addnsub1_clk <= "0000" WHEN ((addnsub1_clock = "0") OR (addnsub1_clock = "none")) ELSE "0001" WHEN (addnsub1_clock = "1") ELSE "0010" WHEN (addnsub1_clock = "2") ELSE "0011" WHEN (addnsub1_clock = "3") ELSE "0000" ;
   addnsub1_aclr <= "0000" WHEN ((addnsub1_clear = "0") OR (addnsub1_clear = "none")) ELSE "0001" WHEN (addnsub1_clear = "1") ELSE "0010" WHEN (addnsub1_clear = "2") ELSE "0011" WHEN (addnsub1_clear = "3") ELSE "0000" ;
   round0_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => round0,
         clk => clk_round0,
         aclr => aclr_round0,
         if_aclr => clear_round0,
         ena => ena_round0,
         dataout => round0_pipe,
         async => async_round0);   
   
   async_round0 <= '1' WHEN (round0_clock = "none") ELSE '0' ;
   clear_round0 <= '1' WHEN (round0_clear /= "none") ELSE '0' ;
   clk_round0 <= '1' WHEN clk(conv_integer(round0_clk)) = '1' ELSE '0' ;
   aclr_round0 <= '1' WHEN (aclr(conv_integer(round0_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_round0 <= '1' WHEN ena(conv_integer(round0_clk)) = '1' ELSE '0' ;
   round0_clk <= "0000" WHEN ((round0_clock = "0") OR (round0_clock = "none")) ELSE "0001" WHEN (round0_clock = "1") ELSE "0010" WHEN (round0_clock = "2") ELSE "0011" WHEN (round0_clock = "3") ELSE "0000" ;
   round0_aclr <= "0000" WHEN ((round0_clear = "0") OR (round0_clear = "none")) ELSE "0001" WHEN (round0_clear = "1") ELSE "0010" WHEN (round0_clear = "2") ELSE "0011" WHEN (round0_clear = "3") ELSE "0000" ;
   saturate_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => saturate,
         clk => clk_saturate,
         aclr => aclr_saturate,
         if_aclr => clear_saturate,
         ena => ena_saturate,
         dataout => saturate_pipe,
         async => async_saturate);   
   
   async_saturate <= '1' WHEN (saturate_clock = "none") ELSE '0' ;
   clear_saturate <= '1' WHEN (saturate_clear /= "none") ELSE '0' ;
   clk_saturate <= '1' WHEN clk(conv_integer(saturate_clk)) = '1' ELSE '0' ;
   aclr_saturate <= '1' WHEN (aclr(conv_integer(saturate_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_saturate <= '1' WHEN ena(conv_integer(saturate_clk)) = '1' ELSE '0' ;
   saturate_clk <= "0000" WHEN ((saturate_clock = "0") OR (saturate_clock = "none")) ELSE "0001" WHEN (saturate_clock = "1") ELSE "0010" WHEN (saturate_clock = "2") ELSE "0011" WHEN (saturate_clock = "3") ELSE "0000" ;
   saturate_aclr <= "0000" WHEN ((saturate_clear = "0") OR (saturate_clear = "none")) ELSE "0001" WHEN (saturate_clear = "1") ELSE "0010" WHEN (saturate_clear = "2") ELSE "0011" WHEN (saturate_clear = "3") ELSE "0000" ;
   mode0_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => mode0,
         clk => clk_mode0,
         aclr => aclr_mode0,
         if_aclr => clear_mode0,
         ena => ena_mode0,
         dataout => mode0_pipe,
         async => async_mode0);   
   
   async_mode0 <= '1' WHEN (mode0_clock = "none") ELSE '0' ;
   clear_mode0 <= '1' WHEN (mode0_clear /= "none") ELSE '0' ;
   clk_mode0 <= '1' WHEN clk(conv_integer(mode0_clk)) = '1' ELSE '0' ;
   aclr_mode0 <= '1' WHEN (aclr(conv_integer(mode0_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_mode0 <= '1' WHEN ena(conv_integer(mode0_clk)) = '1' ELSE '0' ;
   mode0_clk <= "0000" WHEN ((mode0_clock = "0") OR (mode0_clock = "none")) ELSE "0001" WHEN (mode0_clock = "1") ELSE "0010" WHEN (mode0_clock = "2") ELSE "0011" WHEN (mode0_clock = "3") ELSE "0000" ;
   mode0_aclr <= "0000" WHEN ((mode0_clear = "0") OR (mode0_clear = "none")) ELSE "0001" WHEN (mode0_clear = "1") ELSE "0010" WHEN (mode0_clear = "2") ELSE "0011" WHEN (mode0_clear = "3") ELSE "0000" ;
   round1_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => round1,
         clk => clk_round1,
         aclr => aclr_round1,
         if_aclr => clear_round1,
         ena => ena_round1,
         dataout => round1_pipe,
         async => async_round1);   
   
   async_round1 <= '1' WHEN (round1_clock = "none") ELSE '0' ;
   clear_round1 <= '1' WHEN (round1_clear /= "none") ELSE '0' ;
   clk_round1 <= '1' WHEN clk(conv_integer(round1_clk)) = '1' ELSE '0' ;
   aclr_round1 <= '1' WHEN (aclr(conv_integer(round1_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_round1 <= '1' WHEN ena(conv_integer(round1_clk)) = '1' ELSE '0' ;
   round1_clk <= "0000" WHEN ((round1_clock = "0") OR (round1_clock = "none")) ELSE "0001" WHEN (round1_clock = "1") ELSE "0010" WHEN (round1_clock = "2") ELSE "0011" WHEN (round1_clock = "3") ELSE "0000" ;
   round1_aclr <= "0000" WHEN ((round1_clear = "0") OR (round1_clear = "none")) ELSE "0001" WHEN (round1_clear = "1") ELSE "0010" WHEN (round1_clear = "2") ELSE "0011" WHEN (round1_clear = "3") ELSE "0000" ;
   saturate1_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => saturate1,
         clk => clk_saturate1,
         aclr => aclr_saturate1,
         if_aclr => clear_saturate1,
         ena => ena_saturate1,
         dataout => saturate1_pipe,
         async => async_saturate1);   
   
   async_saturate1 <= '1' WHEN (saturate1_clock = "none") ELSE '0' ;
   clear_saturate1 <= '1' WHEN (saturate1_clear /= "none") ELSE '0' ;
   clk_saturate1 <= '1' WHEN clk(conv_integer(saturate1_clk)) = '1' ELSE '0' ;
   aclr_saturate1 <= '1' WHEN (aclr(conv_integer(saturate1_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_saturate1 <= '1' WHEN ena(conv_integer(saturate1_clk)) = '1' ELSE '0' ;
   saturate1_clk <= "0000" WHEN ((saturate1_clock = "0") OR (saturate1_clock = "none")) ELSE "0001" WHEN (saturate1_clock = "1") ELSE "0010" WHEN (saturate1_clock = "2") ELSE "0011" WHEN (saturate1_clock = "3") ELSE "0000" ;
   saturate1_aclr <= "0000" WHEN ((saturate1_clear = "0") OR (saturate1_clear = "none")) ELSE "0001" WHEN (saturate1_clear = "1") ELSE "0010" WHEN (saturate1_clear = "2") ELSE "0011" WHEN (saturate1_clear = "3") ELSE "0000" ;
   mode1_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => mode1,
         clk => clk_mode1,
         aclr => aclr_mode1,
         if_aclr => clear_mode1,
         ena => ena_mode1,
         dataout => mode1_pipe,
         async => async_mode1);   
   
   async_mode1 <= '1' WHEN (mode1_clock = "none") ELSE '0' ;
   clear_mode1 <= '1' WHEN (mode1_clear /= "none") ELSE '0' ;
   clk_mode1 <= '1' WHEN clk(conv_integer(mode1_clk)) = '1' ELSE '0' ;
   aclr_mode1 <= '1' WHEN (aclr(conv_integer(mode1_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_mode1 <= '1' WHEN ena(conv_integer(mode1_clk)) = '1' ELSE '0' ;
   mode1_clk <= "0000" WHEN ((mode1_clock = "0") OR (mode1_clock = "none")) ELSE "0001" WHEN (mode1_clock = "1") ELSE "0010" WHEN (mode1_clock = "2") ELSE "0011" WHEN (mode1_clock = "3") ELSE "0000" ;
   mode1_aclr <= "0000" WHEN ((mode1_clear = "0") OR (mode1_clear = "none")) ELSE "0001" WHEN (mode1_clear = "1") ELSE "0010" WHEN (mode1_clear = "2") ELSE "0011" WHEN (mode1_clear = "3") ELSE "0000" ;
   multabsaturate_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => multabsaturate,
         clk => clk_multabsaturate,
         aclr => aclr_multabsaturate,
         if_aclr => clear_multabsaturate,
         ena => ena_multabsaturate,
         dataout => multabsaturate_pipe,
         async => async_multabsaturate);   
   
   async_multabsaturate <= '1' WHEN (multabsaturate_clock = "none") ELSE '0' ;
   clear_multabsaturate <= '1' WHEN (multabsaturate_clear /= "none") ELSE '0' ;
   clk_multabsaturate <= '1' WHEN clk(conv_integer(multabsaturate_clk)) = '1' ELSE '0' ;
   aclr_multabsaturate <= '1' WHEN (aclr(conv_integer(multabsaturate_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_multabsaturate <= '1' WHEN ena(conv_integer(multabsaturate_clk)) = '1' ELSE '0' ;
   multabsaturate_clk <= "0000" WHEN ((multabsaturate_clock = "0") OR (multabsaturate_clock = "none")) ELSE "0001" WHEN (multabsaturate_clock = "1") ELSE "0010" WHEN (multabsaturate_clock = "2") ELSE "0011" WHEN (multabsaturate_clock = "3") ELSE "0000" ;
   multabsaturate_aclr <= "0000" WHEN ((multabsaturate_clear = "0") OR (multabsaturate_clear = "none")) ELSE "0001" WHEN (multabsaturate_clear = "1") ELSE "0010" WHEN (multabsaturate_clear = "2") ELSE "0011" WHEN (multabsaturate_clear = "3") ELSE "0000" ;
   multcdsaturate_mac_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => multcdsaturate,
         clk => clk_multcdsaturate,
         aclr => aclr_multcdsaturate,
         if_aclr => clear_multcdsaturate,
         ena => ena_multcdsaturate,
         dataout => multcdsaturate_pipe,
         async => async_multcdsaturate);   
   
   async_multcdsaturate <= '1' WHEN (multcdsaturate_clock = "none") ELSE '0' ;
   clear_multcdsaturate <= '1' WHEN (multcdsaturate_clear /= "none") ELSE '0' ;
   clk_multcdsaturate <= '1' WHEN clk(conv_integer(multcdsaturate_clk)) = '1' ELSE '0' ;
   aclr_multcdsaturate <= '1' WHEN (aclr(conv_integer(multcdsaturate_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_multcdsaturate <= '1' WHEN ena(conv_integer(multcdsaturate_clk)) = '1' ELSE '0' ;
   multcdsaturate_clk <= "0000" WHEN ((multcdsaturate_clock = "0") OR (multcdsaturate_clock = "none")) ELSE "0001" WHEN (multcdsaturate_clock = "1") ELSE "0010" WHEN (multcdsaturate_clock = "2") ELSE "0011" WHEN (multcdsaturate_clock = "3") ELSE "0000" ;
   multcdsaturate_aclr <= "0000" WHEN ((multcdsaturate_clear = "0") OR (multcdsaturate_clear = "none")) ELSE "0001" WHEN (multcdsaturate_clear = "1") ELSE "0010" WHEN (multcdsaturate_clear = "2") ELSE "0011" WHEN (multcdsaturate_clear = "3") ELSE "0000" ;
   signa_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => signa_pipe,
         clk => clk_signa_pipeline,
         aclr => aclr_signa_pipeline,
         if_aclr => clear_signa_pipeline,
         ena => ena_signa_pipeline,
         dataout => signa_out,
         async => async_signa_pipeline);   
   
   async_signa_pipeline <= '1' WHEN (signa_pipeline_clock = "none") ELSE '0' ;
   clear_signa_pipeline <= '1' WHEN (signa_pipeline_clear /= "none") ELSE '0' ;
   clk_signa_pipeline <= '1' WHEN clk(conv_integer(signa_pipeline_clk)) = '1' ELSE '0' ;
   aclr_signa_pipeline <= '1' WHEN (aclr(conv_integer(signa_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_signa_pipeline <= '1' WHEN ena(conv_integer(signa_pipeline_clk)) = '1' ELSE '0' ;
   signa_pipeline_clk <= "0000" WHEN ((signa_pipeline_clock = "0") OR (signa_pipeline_clock = "none")) ELSE "0001" WHEN (signa_pipeline_clock = "1") ELSE "0010" WHEN (signa_pipeline_clock = "2") ELSE "0011" WHEN (signa_pipeline_clock = "3") ELSE "0000" ;
   signa_pipeline_aclr <= "0000" WHEN ((signa_pipeline_clear = "0") OR (signa_pipeline_clear = "none")) ELSE "0001" WHEN (signa_pipeline_clear = "1") ELSE "0010" WHEN (signa_pipeline_clear = "2") ELSE "0011" WHEN (signa_pipeline_clear = "3") ELSE "0000" ;
   signb_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => signb_pipe,
         clk => clk_signb_pipeline,
         aclr => aclr_signb_pipeline,
         if_aclr => clear_signb_pipeline,
         ena => ena_signb_pipeline,
         dataout => signb_out,
         async => async_signb_pipeline);   
   
   async_signb_pipeline <= '1' WHEN (signb_pipeline_clock = "none") ELSE '0' ;
   clear_signb_pipeline <= '1' WHEN (signb_pipeline_clear /= "none") ELSE '0' ;
   clk_signb_pipeline <= '1' WHEN clk(conv_integer(signb_pipeline_clk)) = '1' ELSE '0' ;
   aclr_signb_pipeline <= '1' WHEN (aclr(conv_integer(signb_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_signb_pipeline <= '1' WHEN ena(conv_integer(signb_pipeline_clk)) = '1' ELSE '0' ;
   signb_pipeline_clk <= "0000" WHEN ((signb_pipeline_clock = "0") OR (signb_pipeline_clock = "none")) ELSE "0001" WHEN (signb_pipeline_clock = "1") ELSE "0010" WHEN (signb_pipeline_clock = "2") ELSE "0011" WHEN (signb_pipeline_clock = "3") ELSE "0000" ;
   signb_pipeline_aclr <= "0000" WHEN ((signb_pipeline_clear = "0") OR (signb_pipeline_clear = "none")) ELSE "0001" WHEN (signb_pipeline_clear = "1") ELSE "0010" WHEN (signb_pipeline_clear = "2") ELSE "0011" WHEN (signb_pipeline_clear = "3") ELSE "0000" ;
   zeroacc_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => zeroacc_pipe,
         clk => clk_zeroacc_pipeline,
         aclr => aclr_zeroacc_pipeline,
         if_aclr => clear_zeroacc_pipeline,
         ena => ena_zeroacc_pipeline,
         dataout => zeroacc_out,
         async => async_zeroacc_pipeline);   
   
   async_zeroacc_pipeline <= '1' WHEN (zeroacc_pipeline_clock = "none") ELSE '0' ;
   clear_zeroacc_pipeline <= '1' WHEN (zeroacc_pipeline_clear /= "none") ELSE '0' ;
   clk_zeroacc_pipeline <= '1' WHEN clk(conv_integer(zeroacc_pipeline_clk)) = '1' ELSE '0' ;
   aclr_zeroacc_pipeline <= '1' WHEN (aclr(conv_integer(zeroacc_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_zeroacc_pipeline <= '1' WHEN ena(conv_integer(zeroacc_pipeline_clk)) = '1' ELSE '0' ;
   zeroacc_pipeline_clk <= "0000" WHEN ((zeroacc_pipeline_clock = "0") OR (zeroacc_pipeline_clock = "none")) ELSE "0001" WHEN (zeroacc_pipeline_clock = "1") ELSE "0010" WHEN (zeroacc_pipeline_clock = "2") ELSE "0011" WHEN (zeroacc_pipeline_clock = "3") ELSE "0000" ;
   zeroacc_pipeline_aclr <= "0000" WHEN ((zeroacc_pipeline_clear = "0") OR (zeroacc_pipeline_clear = "none")) ELSE "0001" WHEN (zeroacc_pipeline_clear = "1") ELSE "0010" WHEN (zeroacc_pipeline_clear = "2") ELSE "0011" WHEN (zeroacc_pipeline_clear = "3") ELSE "0000" ;
   zeroacc1_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => zeroacc1_pipe,
         clk => clk_zeroacc1_pipeline,
         aclr => aclr_zeroacc1_pipeline,
         if_aclr => clear_zeroacc1_pipeline,
         ena => ena_zeroacc1_pipeline,
         dataout => zeroacc1_out,
         async => async_zeroacc1_pipeline);   
   
   async_zeroacc1_pipeline <= '1' WHEN (zeroacc1_pipeline_clock = "none") ELSE '0' ;
   clear_zeroacc1_pipeline <= '1' WHEN (zeroacc1_pipeline_clear /= "none") ELSE '0' ;
   clk_zeroacc1_pipeline <= '1' WHEN clk(conv_integer(zeroacc1_pipeline_clk)) = '1' ELSE '0' ;
   aclr_zeroacc1_pipeline <= '1' WHEN (aclr(conv_integer(zeroacc1_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_zeroacc1_pipeline <= '1' WHEN ena(conv_integer(zeroacc1_pipeline_clk)) = '1' ELSE '0' ;
   zeroacc1_pipeline_clk <= "0000" WHEN ((zeroacc1_pipeline_clock = "0") OR (zeroacc1_pipeline_clock = "none")) ELSE "0001" WHEN (zeroacc1_pipeline_clock = "1") ELSE "0010" WHEN (zeroacc1_pipeline_clock = "2") ELSE "0011" WHEN (zeroacc1_pipeline_clock = "3") ELSE "0000" ;
   zeroacc1_pipeline_aclr <= "0000" WHEN ((zeroacc1_pipeline_clear = "0") OR (zeroacc1_pipeline_clear = "none")) ELSE "0001" WHEN (zeroacc1_pipeline_clear = "1") ELSE "0010" WHEN (zeroacc1_pipeline_clear = "2") ELSE "0011" WHEN (zeroacc1_pipeline_clear = "3") ELSE "0000" ;
   addnsub0_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => addnsub0_pipe,
         clk => clk_addnsub0_pipeline,
         aclr => aclr_addnsub0_pipeline,
         if_aclr => clear_addnsub0_pipeline,
         ena => ena_addnsub0_pipeline,
         dataout => addnsub0_out,
         async => async_addnsub0_pipeline);   
   
   async_addnsub0_pipeline <= '1' WHEN (addnsub0_pipeline_clock = "none") ELSE '0' ;
   clear_addnsub0_pipeline <= '1' WHEN (addnsub0_pipeline_clear /= "none") ELSE '0' ;
   clk_addnsub0_pipeline <= '1' WHEN clk(conv_integer(addnsub0_pipeline_clk)) = '1' ELSE '0' ;
   aclr_addnsub0_pipeline <= '1' WHEN (aclr(conv_integer(addnsub0_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_addnsub0_pipeline <= '1' WHEN ena(conv_integer(addnsub0_pipeline_clk)) = '1' ELSE '0' ;
   addnsub0_pipeline_clk <= "0000" WHEN ((addnsub0_pipeline_clock = "0") OR (addnsub0_pipeline_clock = "none")) ELSE "0001" WHEN (addnsub0_pipeline_clock = "1") ELSE "0010" WHEN (addnsub0_pipeline_clock = "2") ELSE "0011" WHEN (addnsub0_pipeline_clock = "3") ELSE "0000" ;
   addnsub0_pipeline_aclr <= "0000" WHEN ((addnsub0_pipeline_clear = "0") OR (addnsub0_pipeline_clear = "none")) ELSE "0001" WHEN (addnsub0_pipeline_clear = "1") ELSE "0010" WHEN (addnsub0_pipeline_clear = "2") ELSE "0011" WHEN (addnsub0_pipeline_clear = "3") ELSE "0000" ;
   addnsub1_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => addnsub1_pipe,
         clk => clk_addnsub1_pipeline,
         aclr => aclr_addnsub1_pipeline,
         if_aclr => clear_addnsub1_pipeline,
         ena => ena_addnsub1_pipeline,
         dataout => addnsub1_out,
         async => async_addnsub1_pipeline);   
   
   async_addnsub1_pipeline <= '1' WHEN (addnsub1_pipeline_clock = "none") ELSE '0' ;
   clear_addnsub1_pipeline <= '1' WHEN (addnsub1_pipeline_clear /= "none") ELSE '0' ;
   clk_addnsub1_pipeline <= '1' WHEN clk(conv_integer(addnsub1_pipeline_clk)) = '1' ELSE '0' ;
   aclr_addnsub1_pipeline <= '1' WHEN (aclr(conv_integer(addnsub1_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_addnsub1_pipeline <= '1' WHEN ena(conv_integer(addnsub1_pipeline_clk)) = '1' ELSE '0' ;
   addnsub1_pipeline_clk <= "0000" WHEN ((addnsub1_pipeline_clock = "0") OR (addnsub1_pipeline_clock = "none")) ELSE "0001" WHEN (addnsub1_pipeline_clock = "1") ELSE "0010" WHEN (addnsub1_pipeline_clock = "2") ELSE "0011" WHEN (addnsub1_pipeline_clock = "3") ELSE "0000" ;
   addnsub1_pipeline_aclr <= "0000" WHEN ((addnsub1_pipeline_clear = "0") OR (addnsub1_pipeline_clear = "none")) ELSE "0001" WHEN (addnsub1_pipeline_clear = "1") ELSE "0010" WHEN (addnsub1_pipeline_clear = "2") ELSE "0011" WHEN (addnsub1_pipeline_clear = "3") ELSE "0000" ;
   round0_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => round0_pipe,
         clk => clk_round0_pipeline,
         aclr => aclr_round0_pipeline,
         if_aclr => clear_round0_pipeline,
         ena => ena_round0_pipeline,
         dataout => round0_out,
         async => async_round0_pipeline);   
   
   async_round0_pipeline <= '1' WHEN (round0_pipeline_clock = "none") ELSE '0' ;
   clear_round0_pipeline <= '1' WHEN (round0_pipeline_clear /= "none") ELSE '0' ;
   clk_round0_pipeline <= '1' WHEN clk(conv_integer(round0_pipeline_clk)) = '1' ELSE '0' ;
   aclr_round0_pipeline <= '1' WHEN (aclr(conv_integer(round0_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_round0_pipeline <= '1' WHEN ena(conv_integer(round0_pipeline_clk)) = '1' ELSE '0' ;
   round0_pipeline_clk <= "0000" WHEN ((round0_pipeline_clock = "0") OR (round0_pipeline_clock = "none")) ELSE "0001" WHEN (round0_pipeline_clock = "1") ELSE "0010" WHEN (round0_pipeline_clock = "2") ELSE "0011" WHEN (round0_pipeline_clock = "3") ELSE "0000" ;
   round0_pipeline_aclr <= "0000" WHEN ((round0_pipeline_clear = "0") OR (round0_pipeline_clear = "none")) ELSE "0001" WHEN (round0_pipeline_clear = "1") ELSE "0010" WHEN (round0_pipeline_clear = "2") ELSE "0011" WHEN (round0_pipeline_clear = "3") ELSE "0000" ;
   saturate_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => saturate_pipe,
         clk => clk_saturate_pipeline,
         aclr => aclr_saturate_pipeline,
         if_aclr => clear_saturate_pipeline,
         ena => ena_saturate_pipeline,
         dataout => saturate_out,
         async => async_saturate_pipeline);   
   
   async_saturate_pipeline <= '1' WHEN (saturate_pipeline_clock = "none") ELSE '0' ;
   clear_saturate_pipeline <= '1' WHEN (saturate_pipeline_clear /= "none") ELSE '0' ;
   clk_saturate_pipeline <= '1' WHEN clk(conv_integer(saturate_pipeline_clk)) = '1' ELSE '0' ;
   aclr_saturate_pipeline <= '1' WHEN (aclr(conv_integer(saturate_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_saturate_pipeline <= '1' WHEN ena(conv_integer(saturate_pipeline_clk)) = '1' ELSE '0' ;
   saturate_pipeline_clk <= "0000" WHEN ((saturate_pipeline_clock = "0") OR (saturate_pipeline_clock = "none")) ELSE "0001" WHEN (saturate_pipeline_clock = "1") ELSE "0010" WHEN (saturate_pipeline_clock = "2") ELSE "0011" WHEN (saturate_pipeline_clock = "3") ELSE "0000" ;
   saturate_pipeline_aclr <= "0000" WHEN ((saturate_pipeline_clear = "0") OR (saturate_pipeline_clear = "none")) ELSE "0001" WHEN (saturate_pipeline_clear = "1") ELSE "0010" WHEN (saturate_pipeline_clear = "2") ELSE "0011" WHEN (saturate_pipeline_clear = "3") ELSE "0000" ;
   mode0_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => mode0_pipe,
         clk => clk_mode0_pipeline,
         aclr => aclr_mode0_pipeline,
         if_aclr => clear_mode0_pipeline,
         ena => ena_mode0_pipeline,
         dataout => mode0_out,
         async => async_mode0_pipeline);   
   
   async_mode0_pipeline <= '1' WHEN (mode0_pipeline_clock = "none") ELSE '0' ;
   clear_mode0_pipeline <= '1' WHEN (mode0_pipeline_clear /= "none") ELSE '0' ;
   clk_mode0_pipeline <= '1' WHEN clk(conv_integer(mode0_pipeline_clk)) = '1' ELSE '0' ;
   aclr_mode0_pipeline <= '1' WHEN (aclr(conv_integer(mode0_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_mode0_pipeline <= '1' WHEN ena(conv_integer(mode0_pipeline_clk)) = '1' ELSE '0' ;
   mode0_pipeline_clk <= "0000" WHEN ((mode0_pipeline_clock = "0") OR (mode0_pipeline_clock = "none")) ELSE "0001" WHEN (mode0_pipeline_clock = "1") ELSE "0010" WHEN (mode0_pipeline_clock = "2") ELSE "0011" WHEN (mode0_pipeline_clock = "3") ELSE "0000" ;
   mode0_pipeline_aclr <= "0000" WHEN ((mode0_pipeline_clear = "0") OR (mode0_pipeline_clear = "none")) ELSE "0001" WHEN (mode0_pipeline_clear = "1") ELSE "0010" WHEN (mode0_pipeline_clear = "2") ELSE "0011" WHEN (mode0_pipeline_clear = "3") ELSE "0000" ;
   round1_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => round1_pipe,
         clk => clk_round1_pipeline,
         aclr => aclr_round1_pipeline,
         if_aclr => clear_round1_pipeline,
         ena => ena_round1_pipeline,
         dataout => round1_out,
         async => async_round1_pipeline);   
   
   async_round1_pipeline <= '1' WHEN (round1_pipeline_clock = "none") ELSE '0' ;
   clear_round1_pipeline <= '1' WHEN (round1_pipeline_clear /= "none") ELSE '0' ;
   clk_round1_pipeline <= '1' WHEN clk(conv_integer(round1_pipeline_clk)) = '1' ELSE '0' ;
   aclr_round1_pipeline <= '1' WHEN (aclr(conv_integer(round1_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_round1_pipeline <= '1' WHEN ena(conv_integer(round1_pipeline_clk)) = '1' ELSE '0' ;
   round1_pipeline_clk <= "0000" WHEN ((round1_pipeline_clock = "0") OR (round1_pipeline_clock = "none")) ELSE "0001" WHEN (round1_pipeline_clock = "1") ELSE "0010" WHEN (round1_pipeline_clock = "2") ELSE "0011" WHEN (round1_pipeline_clock = "3") ELSE "0000" ;
   round1_pipeline_aclr <= "0000" WHEN ((round1_pipeline_clear = "0") OR (round1_pipeline_clear = "none")) ELSE "0001" WHEN (round1_pipeline_clear = "1") ELSE "0010" WHEN (round1_pipeline_clear = "2") ELSE "0011" WHEN (round1_pipeline_clear = "3") ELSE "0000" ;
   saturate1_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => saturate1_pipe,
         clk => clk_saturate1_pipeline,
         aclr => aclr_saturate1_pipeline,
         if_aclr => clear_saturate1_pipeline,
         ena => ena_saturate1_pipeline,
         dataout => saturate1_out,
         async => async_saturate1_pipeline);   
   
   async_saturate1_pipeline <= '1' WHEN (saturate1_pipeline_clock = "none") ELSE '0' ;
   clear_saturate1_pipeline <= '1' WHEN (saturate1_pipeline_clear /= "none") ELSE '0' ;
   clk_saturate1_pipeline <= '1' WHEN clk(conv_integer(saturate1_pipeline_clk)) = '1' ELSE '0' ;
   aclr_saturate1_pipeline <= '1' WHEN (aclr(conv_integer(saturate1_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_saturate1_pipeline <= '1' WHEN ena(conv_integer(saturate1_pipeline_clk)) = '1' ELSE '0' ;
   saturate1_pipeline_clk <= "0000" WHEN ((saturate1_pipeline_clock = "0") OR (saturate1_pipeline_clock = "none")) ELSE "0001" WHEN (saturate1_pipeline_clock = "1") ELSE "0010" WHEN (saturate1_pipeline_clock = "2") ELSE "0011" WHEN (saturate1_pipeline_clock = "3") ELSE "0000" ;
   saturate1_pipeline_aclr <= "0000" WHEN ((saturate1_pipeline_clear = "0") OR (saturate1_pipeline_clear = "none")) ELSE "0001" WHEN (saturate1_pipeline_clear = "1") ELSE "0010" WHEN (saturate1_pipeline_clear = "2") ELSE "0011" WHEN (saturate1_pipeline_clear = "3") ELSE "0000" ;
   mode1_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => mode1_pipe,
         clk => clk_mode1_pipeline,
         aclr => aclr_mode1_pipeline,
         if_aclr => clear_mode1_pipeline,
         ena => ena_mode1_pipeline,
         dataout => mode1_out,
         async => async_mode1_pipeline);   
   
   async_mode1_pipeline <= '1' WHEN (mode1_pipeline_clock = "none") ELSE '0' ;
   clear_mode1_pipeline <= '1' WHEN (mode1_pipeline_clear /= "none") ELSE '0' ;
   clk_mode1_pipeline <= '1' WHEN clk(conv_integer(mode1_pipeline_clk)) = '1' ELSE '0' ;
   aclr_mode1_pipeline <= '1' WHEN (aclr(conv_integer(mode1_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_mode1_pipeline <= '1' WHEN ena(conv_integer(mode1_pipeline_clk)) = '1' ELSE '0' ;
   mode1_pipeline_clk <= "0000" WHEN ((mode1_pipeline_clock = "0") OR (mode1_pipeline_clock = "none")) ELSE "0001" WHEN (mode1_pipeline_clock = "1") ELSE "0010" WHEN (mode1_pipeline_clock = "2") ELSE "0011" WHEN (mode1_pipeline_clock = "3") ELSE "0000" ;
   mode1_pipeline_aclr <= "0000" WHEN ((mode1_pipeline_clear = "0") OR (mode1_pipeline_clear = "none")) ELSE "0001" WHEN (mode1_pipeline_clear = "1") ELSE "0010" WHEN (mode1_pipeline_clear = "2") ELSE "0011" WHEN (mode1_pipeline_clear = "3") ELSE "0000" ;
   multabsaturate_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => multabsaturate_pipe,
         clk => clk_multabsaturate_pipeline,
         aclr => aclr_multabsaturate_pipeline,
         if_aclr => clear_multabsaturate_pipeline,
         ena => ena_multabsaturate_pipeline,
         dataout => multabsaturate_out,
         async => async_multabsaturate_pipeline);   
   
   async_multabsaturate_pipeline <= '1' WHEN (multabsaturate_pipeline_clock = "none") ELSE '0' ;
   clear_multabsaturate_pipeline <= '1' WHEN (multabsaturate_pipeline_clear /= "none") ELSE '0' ;
   clk_multabsaturate_pipeline <= '1' WHEN clk(conv_integer(multabsaturate_pipeline_clk)) = '1' ELSE '0' ;
   aclr_multabsaturate_pipeline <= '1' WHEN (aclr(conv_integer(multabsaturate_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_multabsaturate_pipeline <= '1' WHEN ena(conv_integer(multabsaturate_pipeline_clk)) = '1' ELSE '0' ;
   multabsaturate_pipeline_clk <= "0000" WHEN ((multabsaturate_pipeline_clock = "0") OR (multabsaturate_pipeline_clock = "none")) ELSE "0001" WHEN (multabsaturate_pipeline_clock = "1") ELSE "0010" WHEN (multabsaturate_pipeline_clock = "2") ELSE "0011" WHEN (multabsaturate_pipeline_clock = "3") ELSE "0000" ;
   multabsaturate_pipeline_aclr <= "0000" WHEN ((multabsaturate_pipeline_clear = "0") OR (multabsaturate_pipeline_clear = "none")) ELSE "0001" WHEN (multabsaturate_pipeline_clear = "1") ELSE "0010" WHEN (multabsaturate_pipeline_clear = "2") ELSE "0011" WHEN (multabsaturate_pipeline_clear = "3") ELSE "0000" ;
   multcdsaturate_mac_pipeline_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => multcdsaturate_pipe,
         clk => clk_multcdsaturate_pipeline,
         aclr => aclr_multcdsaturate_pipeline,
         if_aclr => clear_multcdsaturate_pipeline,
         ena => ena_multcdsaturate_pipeline,
         dataout => multcdsaturate_out,
         async => async_multcdsaturate_pipeline);   
   
   async_multcdsaturate_pipeline <= '1' WHEN (multcdsaturate_pipeline_clock = "none") ELSE '0' ;
   clear_multcdsaturate_pipeline <= '1' WHEN (multcdsaturate_pipeline_clear /= "none") ELSE '0' ;
   clk_multcdsaturate_pipeline <= '1' WHEN clk(conv_integer(multcdsaturate_pipeline_clk)) = '1' ELSE '0' ;
   aclr_multcdsaturate_pipeline <= '1' WHEN (aclr(conv_integer(multcdsaturate_pipeline_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_multcdsaturate_pipeline <= '1' WHEN ena(conv_integer(multcdsaturate_pipeline_clk)) = '1' ELSE '0' ;
   multcdsaturate_pipeline_clk <= "0000" WHEN ((multcdsaturate_pipeline_clock = "0") OR (multcdsaturate_pipeline_clock = "none")) ELSE "0001" WHEN (multcdsaturate_pipeline_clock = "1") ELSE "0010" WHEN (multcdsaturate_pipeline_clock = "2") ELSE "0011" WHEN (multcdsaturate_pipeline_clock = "3") ELSE "0000" ;
   multcdsaturate_pipeline_aclr <= "0000" WHEN ((multcdsaturate_pipeline_clear = "0") OR (multcdsaturate_pipeline_clear = "none")) ELSE "0001" WHEN (multcdsaturate_pipeline_clear = "1") ELSE "0010" WHEN (multcdsaturate_pipeline_clear = "2") ELSE "0011" WHEN (multcdsaturate_pipeline_clear = "3") ELSE "0000" ;
   dataa_f <= (others => '0') WHEN (dataa_forced_to_zero = "yes") ELSE dataa ;
   datac_f <= (others => '0') WHEN (datac_forced_to_zero = "yes") ELSE datac ;
   mac_adder : stratixii_mac_out_internal 
      GENERIC MAP (
         dataa_width => dataa_width,
         datab_width => datab_width,
         datac_width => datac_width,
         datad_width => datad_width,
         dataout_width => dataout_width,
         operation_mode => operation_mode)
      PORT MAP (
         dataa => dataa_f,
         datab => datab,
         datac => datac_f,
         datad => datad,
         mode0 => mode0_out,       
         mode1 => mode1_out,       
         zeroacc => zeroacc_out,
         zeroacc1 => zeroacc1_out, 
         roundab => round0_out,
         roundcd => round1_out,
         saturateab => saturate_out,
         saturatecd => saturate1_out,
         multabsaturate => multabsaturate_out,
         multcdsaturate => multcdsaturate_out,
         signx => signa_out,
         signy => signb_out,
         addnsub0 => addnsub0_out,
         addnsub1 => addnsub1_out,
         feedback => dataout_feedback,
         dataout => dataout_map(dataout_width -1 downto 0),
         accoverflow => accoverflow_reg);   

   pin_map_addnsub <= addnsub0_out AND addnsub1_out;
   
   mac_pin_map : stratixii_mac_pin_map 
      GENERIC MAP (
         operation_mode => operation_mode,
         data_width => tmp_width,
         pinmap => "map")
      PORT MAP (
         datain => dataout_map,
         operation => operation,
		 addnsub => pin_map_addnsub,
         dataout => dataout_to_reg);   
   
   output0_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => dataout_width,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(dataout_width -1 DOWNTO 0),
         clk => clk_output,
         aclr => aclr_output,
         if_aclr => clear_output,
         ena => ena_output,
         dataout => dataout_non_dynamic(dataout_width -1 DOWNTO 0),
         async => async_output);   
   
   async_output <= '1' WHEN (output_clock = "none") ELSE '0' ;
   clear_output <= '1' WHEN (output_clear /= "none") ELSE '0' ;
   clk_output <= '1' WHEN clk(conv_integer(output_clk)) = '1' ELSE '0' ;
   aclr_output <= '1' WHEN (aclr(conv_integer(output_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output <= '1' WHEN ena(conv_integer(output_clk)) = '1' ELSE '0' ;
   output_clk <= "0000" WHEN ((output_clock = "0") OR (output_clock = "none")) ELSE "0001" WHEN (output_clock = "1") ELSE "0010" WHEN (output_clock = "2") ELSE "0011" WHEN (output_clock = "3") ELSE "0000" ;
   output_aclr <= "0000" WHEN ((output_clear = "0") OR (output_clear = "none")) ELSE "0001" WHEN (output_clear = "1") ELSE "0010" WHEN (output_clear = "2") ELSE "0011" WHEN (output_clear = "3") ELSE "0000" ;
   output1_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(35 DOWNTO 18),
         clk => clk_output1,
         aclr => aclr_output1,
         if_aclr => clear_output1,
         ena => ena_output1,
         dataout => dataout_dynamic1(17 downto 0),
         async => async_output1);   
   
   async_output1 <= '1' WHEN (output1_clock = "none") ELSE '0' ;
   clear_output1 <= '1' WHEN (output1_clear /= "none") ELSE '0' ;
   clk_output1 <= '1' WHEN clk(conv_integer(output1_clk)) = '1' ELSE '0' ;
   aclr_output1 <= '1' WHEN (aclr(conv_integer(output1_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output1 <= '1' WHEN ena(conv_integer(output1_clk)) = '1' ELSE '0' ;
   output1_clk <= "0000" WHEN ((output1_clock = "0") OR (output1_clock = "none")) ELSE "0001" WHEN (output1_clock = "1") ELSE "0010" WHEN (output1_clock = "2") ELSE "0011" WHEN (output1_clock = "3") ELSE "0000" ;
   output1_aclr <= "0000" WHEN ((output1_clear = "0") OR (output1_clear = "none")) ELSE "0001" WHEN (output1_clear = "1") ELSE "0010" WHEN (output1_clear = "2") ELSE "0011" WHEN (output1_clear = "3") ELSE "0000" ;
   output2_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(53 DOWNTO 36),
         clk => clk_output2,
         aclr => aclr_output2,
         if_aclr => clear_output2,
         ena => ena_output2,
         dataout => dataout_dynamic2(17 downto 0),
         async => async_output2);   
   
   async_output2 <= '1' WHEN (output2_clock = "none") ELSE '0' ;
   clear_output2 <= '1' WHEN (output2_clear /= "none") ELSE '0' ;
   clk_output2 <= '1' WHEN clk(conv_integer(output2_clk)) = '1' ELSE '0' ;
   aclr_output2 <= '1' WHEN (aclr(conv_integer(output2_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output2 <= '1' WHEN ena(conv_integer(output2_clk)) = '1' ELSE '0' ;
   output2_clk <= "0000" WHEN ((output2_clock = "0") OR (output2_clock = "none")) ELSE "0001" WHEN (output2_clock = "1") ELSE "0010" WHEN (output2_clock = "2") ELSE "0011" WHEN (output2_clock = "3") ELSE "0000" ;
   output2_aclr <= "0000" WHEN ((output2_clear = "0") OR (output2_clear = "none")) ELSE "0001" WHEN (output2_clear = "1") ELSE "0010" WHEN (output2_clear = "2") ELSE "0011" WHEN (output2_clear = "3") ELSE "0000" ;
   output3_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(71 DOWNTO 54),
         clk => clk_output3,
         aclr => aclr_output3,
         if_aclr => clear_output3,
         ena => ena_output3,
         dataout => dataout_dynamic3(17 downto 0),
         async => async_output3);   
   
   async_output3 <= '1' WHEN (output3_clock = "none") ELSE '0' ;
   clear_output3 <= '1' WHEN (output3_clear /= "none") ELSE '0' ;
   clk_output3 <= '1' WHEN clk(conv_integer(output3_clk)) = '1' ELSE '0' ;
   aclr_output3 <= '1' WHEN (aclr(conv_integer(output3_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output3 <= '1' WHEN ena(conv_integer(output3_clk)) = '1' ELSE '0' ;
   output3_clk <= "0000" WHEN ((output3_clock = "0") OR (output3_clock = "none")) ELSE "0001" WHEN (output3_clock = "1") ELSE "0010" WHEN (output3_clock = "2") ELSE "0011" WHEN (output3_clock = "3") ELSE "0000" ;
   output3_aclr <= "0000" WHEN ((output3_clear = "0") OR (output3_clear = "none")) ELSE "0001" WHEN (output3_clear = "1") ELSE "0010" WHEN (output3_clear = "2") ELSE "0011" WHEN (output3_clear = "3") ELSE "0000" ;
   output4_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(89 DOWNTO 72),
         clk => clk_output4,
         aclr => aclr_output4,
         if_aclr => clear_output4,
         ena => ena_output4,
         dataout => dataout_dynamic4(17 downto 0),
         async => async_output4);   
   
   async_output4 <= '1' WHEN (output4_clock = "none") ELSE '0' ;
   clear_output4 <= '1' WHEN (output4_clear /= "none") ELSE '0' ;
   clk_output4 <= '1' WHEN clk(conv_integer(output4_clk)) = '1' ELSE '0' ;
   aclr_output4 <= '1' WHEN (aclr(conv_integer(output4_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output4 <= '1' WHEN ena(conv_integer(output4_clk)) = '1' ELSE '0' ;
   output4_clk <= "0000" WHEN ((output4_clock = "0") OR (output4_clock = "none")) ELSE "0001" WHEN (output4_clock = "1") ELSE "0010" WHEN (output4_clock = "2") ELSE "0011" WHEN (output4_clock = "3") ELSE "0000" ;
   output4_aclr <= "0000" WHEN ((output4_clear = "0") OR (output4_clear = "none")) ELSE "0001" WHEN (output4_clear = "1") ELSE "0010" WHEN (output4_clear = "2") ELSE "0011" WHEN (output4_clear = "3") ELSE "0000" ;
   output5_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(107 DOWNTO 90),
         clk => clk_output5,
         aclr => aclr_output5,
         if_aclr => clear_output5,
         ena => ena_output5,
         dataout => dataout_dynamic5(17 downto 0),
         async => async_output5);   
   
   async_output5 <= '1' WHEN (output5_clock = "none") ELSE '0' ;
   clear_output5 <= '1' WHEN (output5_clear /= "none") ELSE '0' ;
   clk_output5 <= '1' WHEN clk(conv_integer(output5_clk)) = '1' ELSE '0' ;
   aclr_output5 <= '1' WHEN (aclr(conv_integer(output5_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output5 <= '1' WHEN ena(conv_integer(output5_clk)) = '1' ELSE '0' ;
   output5_clk <= "0000" WHEN ((output5_clock = "0") OR (output5_clock = "none")) ELSE "0001" WHEN (output5_clock = "1") ELSE "0010" WHEN (output5_clock = "2") ELSE "0011" WHEN (output5_clock = "3") ELSE "0000" ;
   output5_aclr <= "0000" WHEN ((output5_clear = "0") OR (output5_clear = "none")) ELSE "0001" WHEN (output5_clear = "1") ELSE "0010" WHEN (output5_clear = "2") ELSE "0011" WHEN (output5_clear = "3") ELSE "0000" ;
   output6_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(125 DOWNTO 108),
         clk => clk_output6,
         aclr => aclr_output6,
         if_aclr => clear_output6,
         ena => ena_output6,
         dataout => dataout_dynamic6(17 downto 0),
         async => async_output6);   
   
   async_output6 <= '1' WHEN (output6_clock = "none") ELSE '0' ;
   clear_output6 <= '1' WHEN (output6_clear /= "none") ELSE '0' ;
   clk_output6 <= '1' WHEN clk(conv_integer(output6_clk)) = '1' ELSE '0' ;
   aclr_output6 <= '1' WHEN (aclr(conv_integer(output6_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output6 <= '1' WHEN ena(conv_integer(output6_clk)) = '1' ELSE '0' ;
   output6_clk <= "0000" WHEN ((output6_clock = "0") OR (output6_clock = "none")) ELSE "0001" WHEN (output6_clock = "1") ELSE "0010" WHEN (output6_clock = "2") ELSE "0011" WHEN (output6_clock = "3") ELSE "0000" ;
   output6_aclr <= "0000" WHEN ((output6_clear = "0") OR (output6_clear = "none")) ELSE "0001" WHEN (output6_clear = "1") ELSE "0010" WHEN (output6_clear = "2") ELSE "0011" WHEN (output6_clear = "3") ELSE "0000" ;
   output7_reg : stratixii_mac_register 
      GENERIC MAP (
         data_width => 18,
         power_up => '0')
      PORT MAP (
         data => dataout_to_reg(tmp_width-1 DOWNTO 126),
         clk => clk_output7,
         aclr => aclr_output7,
         if_aclr => clear_output7,
         ena => ena_output7,
         dataout => dataout_dynamic7(17 downto 0),
         async => async_output7);   
   
   async_output7 <= '1' WHEN (output7_clock = "none") ELSE '0' ;
   clear_output7 <= '1' WHEN (output7_clear /= "none") ELSE '0' ;
   clk_output7 <= '1' WHEN clk(conv_integer(output7_clk)) = '1' ELSE '0' ;
   aclr_output7 <= '1' WHEN (aclr(conv_integer(output7_aclr)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
   ena_output7 <= '1' WHEN ena(conv_integer(output7_clk)) = '1' ELSE '0' ;
   output7_clk <= "0000" WHEN ((output7_clock = "0") OR (output7_clock = "none")) ELSE "0001" WHEN (output7_clock = "1") ELSE "0010" WHEN (output7_clock = "2") ELSE "0011" WHEN (output7_clock = "3") ELSE "0000" ;
   output7_aclr <= "0000" WHEN ((output7_clear = "0") OR (output7_clear = "none")) ELSE "0001" WHEN (output7_clear = "1") ELSE "0010" WHEN (output7_clear = "2") ELSE "0011" WHEN (output7_clear = "3") ELSE "0000" ;
   tmp_186 <= '1' when (output_clear /= "none") else '0';
   tmp_189 <= '1' when (output_clock = "none") else '0';
   accoverflow_out_reg : stratixii_mac_bit_register 
      GENERIC MAP (
         power_up => '0')
      PORT MAP (
         data => accoverflow_reg,
         clk => clk_output,
         aclr => aclr_output,
         if_aclr => tmp_186,
         ena => ena_output,
         dataout => accoverflow_tmp,
         async => tmp_189);   
   
   dataout_dynamic(tmp_width-1 DOWNTO 0) <= dataout_dynamic7(17 DOWNTO 0) & dataout_dynamic6(17 DOWNTO 0) & dataout_dynamic5(17 DOWNTO 0) & dataout_dynamic4(17 DOWNTO 0) & dataout_dynamic3(17 DOWNTO 0) & dataout_dynamic2(17 DOWNTO 0) & dataout_dynamic1(17 DOWNTO 0) & dataout_non_dynamic(17 DOWNTO 0) ;
   dataout_tmp <= dataout_dynamic WHEN (operation_mode = "dynamic") ELSE dataout_non_dynamic ;
   operation <= "0000" WHEN (operation_mode = "output_only") ELSE "0001" WHEN (operation_mode = "one_level_adder") ELSE "0010" WHEN (operation_mode = "two_level_adder") ELSE "0100" WHEN (operation_mode = "accumulator") ELSE "0111" WHEN (operation_mode = "36_bit_multiply") ELSE "0000" WHEN (((((operation_mode = "dynamic") AND (mode0_out = '0')) AND (mode1_out = '0')) AND (zeroacc_out = '0')) AND (zeroacc1_out = '0')) ELSE "1100" WHEN (((operation_mode = "dynamic") AND (mode0_out = '1')) AND (mode1_out = '1')) ELSE "1101" WHEN (((operation_mode = "dynamic") AND (mode0_out = '1')) AND (mode1_out = '0')) ELSE "1110" WHEN (((operation_mode = "dynamic") AND (mode0_out = '0')) AND (mode1_out = '1')) ELSE "0111" WHEN (((((operation_mode = "dynamic") AND (mode0_out = '0')) AND (mode1_out = '0')) AND (zeroacc_out = '1')) AND (zeroacc1_out = '1')) ELSE "0000" ;
   
   dataout_feedback <= dataout_dynamic WHEN (operation_mode = "dynamic") ELSE dataout_non_dynamic ;
   accoverflow_tmp2 <= accoverflow_tmp;

END arch;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_tx_reg
--
-- Description : Simulation model for a simple DFF.
--               This is used for registering the enable inputs.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_lvds_tx_reg is
    GENERIC ( MsgOn                       : Boolean := DefGlitchMsgOn;
              XOn                         : Boolean := DefGlitchXOn;
              MsgOnChecks                 : Boolean := DefMsgOnChecks;
              XOnChecks                   : Boolean := DefXOnChecks;
              TimingChecksOn              : Boolean := True;
              InstancePath                : String := "*";
              tipd_clk                    : VitalDelayType01 := DefpropDelay01;
              tipd_ena                    : VitalDelayType01 := DefpropDelay01;
              tipd_d                      : VitalDelayType01 := DefpropDelay01;
              tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
              thold_d_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
              tpd_clk_q_posedge           : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( q                       : OUT std_logic;
              clk                     : IN std_logic;
              ena                     : IN std_logic;
              d                       : IN std_logic;
              clrn                    : IN std_logic;
              prn                     : IN std_logic
            );
    attribute VITAL_LEVEL0 of stratixii_lvds_tx_reg : ENTITY is TRUE;
END stratixii_lvds_tx_reg;

ARCHITECTURE vital_stratixii_lvds_tx_reg of stratixii_lvds_tx_reg is

    attribute VITAL_LEVEL0 of vital_stratixii_lvds_tx_reg : architecture is TRUE;

    -- INTERNAL SIGNALS
    signal clk_ipd                  :  std_logic;
    signal d_ipd                    :  std_logic;
    signal ena_ipd                  :  std_logic;

    begin

        ----------------------
        --  INPUT PATH DELAYs
        ----------------------
        WireDelay : block
        begin
            VitalWireDelay (clk_ipd, clk, tipd_clk);
            VitalWireDelay (ena_ipd, ena, tipd_ena);
            VitalWireDelay (d_ipd, d, tipd_d);
        end block;

        process (clk_ipd, clrn, prn)
        variable q_tmp :  std_logic := '0';
        variable q_VitalGlitchData : VitalGlitchDataType;
        variable Tviol_d_clk : std_ulogic := '0';
        variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
        begin

            ------------------------
            --  Timing Check Section
            ------------------------
            if (TimingChecksOn) then
               VitalSetupHoldCheck (
                      Violation       => Tviol_d_clk,
                      TimingData      => TimingData_d_clk,
                      TestSignal      => d_ipd,
                      TestSignalName  => "d",
                      RefSignal       => clk_ipd,
                      RefSignalName   => "clk",
                      SetupHigh       => tsetup_d_clk_noedge_posedge,
                      SetupLow        => tsetup_d_clk_noedge_posedge,
                      HoldHigh        => thold_d_clk_noedge_posedge,
                      HoldLow         => thold_d_clk_noedge_posedge,
                      CheckEnabled    => TO_X01( (NOT ena_ipd) ) /= '1',
                      RefTransition   => '/',
                      HeaderMsg       => InstancePath & "/stratixii_lvds_tx_reg",
                      XOn             => XOnChecks,
                      MsgOn           => MsgOnChecks );
            end if;

            if (prn = '0') then
                q_tmp := '1';
            elsif (clrn = '0') then
                q_tmp := '0';
            elsif (clk_ipd'event and clk_ipd = '1') then
                if (ena_ipd = '1') then
                    q_tmp := d_ipd;
                end if;
            end if;

            ----------------------
            --  Path Delay Section
            ----------------------
            VitalPathDelay01 (
                        OutSignal => q,
                        OutSignalName => "Q",
                        OutTemp => q_tmp,
                        Paths => (1 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE)),
                        GlitchData => q_VitalGlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn  => MsgOn );

        end process;

end vital_stratixii_lvds_tx_reg;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity name : stratixii_lvds_tx_parallel_register
--
-- Description : Register for the 10 data input channels of the StratixII
--               LVDS Tx
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE std.textio.all;

ENTITY stratixii_lvds_tx_parallel_register is
    GENERIC ( channel_width                     : integer := 10;
              TimingChecksOn                    : Boolean := True;
              MsgOn                             : Boolean := DefGlitchMsgOn;
              XOn                               : Boolean := DefGlitchXOn;
              MsgOnChecks                       : Boolean := DefMsgOnChecks;
              XOnChecks                         : Boolean := DefXOnChecks;
              InstancePath                      : String := "*";
              tsetup_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
              thold_datain_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
              tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
              tipd_clk                          : VitalDelayType01 := DefpropDelay01;
              tipd_enable                       : VitalDelayType01 := DefpropDelay01;
              tipd_datain                       : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01)
            );

    PORT    ( clk                            : in std_logic;
              enable                         : in std_logic;
              datain                         : in std_logic_vector(channel_width - 1 downto 0);
              devclrn                        : in std_logic := '1';
              devpor                         : in std_logic := '1';
              dataout                        : out std_logic_vector(channel_width - 1 downto 0)
            );

END stratixii_lvds_tx_parallel_register;

ARCHITECTURE vital_tx_reg of stratixii_lvds_tx_parallel_register is
    signal clk_ipd : std_logic;
    signal enable_ipd : std_logic;
    signal datain_ipd : std_logic_vector(channel_width - 1 downto 0);

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (enable_ipd, enable, tipd_enable);
        loopbits : FOR i in datain'RANGE GENERATE
            VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
        END GENERATE;
    end block;

    VITAL: process (clk_ipd, enable_ipd, datain_ipd, devpor, devclrn)
        variable Tviol_datain_clk : std_ulogic := '0';
        variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
        variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
        variable i : integer := 0;
        variable dataout_tmp : std_logic_vector(channel_width - 1 downto 0);
        variable CQDelay : TIME := 0 ns;
    begin

        if (now = 0 ns) then
             dataout_tmp := (OTHERS => '0');
        end if;

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then

            VitalSetupHoldCheck (
                Violation       => Tviol_datain_clk,
                TimingData      => TimingData_datain_clk,
                TestSignal      => datain_ipd,
                TestSignalName  => "DATAIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datain_clk_noedge_posedge,
                SetupLow        => tsetup_datain_clk_noedge_posedge,
                HoldHigh        => thold_datain_clk_noedge_posedge,
                HoldLow         => thold_datain_clk_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/stratixii_lvds_tx_parallel_register",
                XOn             => XOn,
                MsgOn           => MsgOnChecks );
        end if;

        if ((devpor = '0') or (devclrn = '0')) then
            dataout_tmp := (OTHERS => '0');
        else
            if (clk_ipd'event and clk_ipd = '1') then
                if (enable_ipd = '1') then
                    dataout_tmp := datain_ipd;
                end if;
            end if;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        CQDelay := SelectDelay(
                        (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE))
                    );
        dataout <= TRANSPORT dataout_tmp AFTER CQDelay;

    end process;

end vital_tx_reg;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity name : stratixii_lvds_tx_out_block
--
-- Description : Negative-edge triggered register on the Tx output.
--               Also, optionally generates an identical/inverted output clock
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE std.textio.all;

ENTITY stratixii_lvds_tx_out_block is
    GENERIC ( bypass_serializer          : String := "false";
              invert_clock               : String := "false";
              use_falling_clock_edge     : String := "false";
              TimingChecksOn             : Boolean := True;
              MsgOn                      : Boolean := DefGlitchMsgOn;
              XOn                        : Boolean := DefGlitchXOn;
              MsgOnChecks                : Boolean := DefMsgOnChecks;
              XOnChecks                  : Boolean := DefXOnChecks;
              InstancePath               : String := "*";
              tpd_datain_dataout         : VitalDelayType01 := DefPropDelay01;
              tpd_clk_dataout            : VitalDelayType01 := DefPropDelay01;
              tpd_clk_dataout_negedge    : VitalDelayType01 := DefPropDelay01;
              tipd_clk                   : VitalDelayType01 := DefpropDelay01;
              tipd_datain                : VitalDelayType01 := DefpropDelay01
            );

    PORT    ( clk                        : in std_logic;
              datain                     : in std_logic;
              devclrn                    : in std_logic := '1';
              devpor                     : in std_logic := '1';
              dataout                    : out std_logic
            );

END stratixii_lvds_tx_out_block;

ARCHITECTURE vital_tx_out_block of stratixii_lvds_tx_out_block is
    signal clk_ipd : std_logic;
    signal datain_ipd : std_logic;
    signal inv_clk : integer;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
    end block;


    VITAL: process (clk_ipd, datain_ipd, devpor, devclrn)
        variable dataout_VitalGlitchData : VitalGlitchDataType;
        variable dataout_tmp : std_logic;
    begin
        if (now = 0 ns) then
            dataout_tmp := '0';
        else
            if (bypass_serializer = "false") then
                if (use_falling_clock_edge = "false") then
                    dataout_tmp := datain_ipd;
                end if;

                if (clk_ipd'event and clk_ipd = '0') then
                    if (use_falling_clock_edge = "true") then
                        dataout_tmp := datain_ipd;
                    end if;
                end if;
            else
                if (invert_clock = "false") then
                    dataout_tmp := clk_ipd;
                else
                    dataout_tmp := NOT (clk_ipd);
                end if;

                if (invert_clock = "false") then
                    inv_clk <= 0;
                else
                    inv_clk <= 1;
                end if;
            end if;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------

        if (bypass_serializer = "false") then
            VitalPathDelay01 (
                OutSignal => dataout,
                OutSignalName => "DATAOUT",
                OutTemp => dataout_tmp,
                Paths => (0 => (datain_ipd'last_event, tpd_datain_dataout, TRUE),
                          1 => (clk_ipd'last_event, tpd_clk_dataout_negedge, use_falling_clock_edge = "true")),
                GlitchData => dataout_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn  => MsgOn );
        end if;

        if (bypass_serializer = "true") then
            VitalPathDelay01 (
                OutSignal => dataout,
                OutSignalName => "DATAOUT",
                OutTemp => dataout_tmp,
                Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout, TRUE)),
                GlitchData => dataout_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn  => MsgOn );
        end if;
    end process;
end vital_tx_out_block;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity name : stratixii_lvds_transmitter
--
-- Description : Timing simulation model for the StratixII LVDS Tx WYSIWYG.
--               It instantiates the following sub-modules :
--               1) primitive DFFE
--               2) StratixII_lvds_tx_parallel_register and
--               3) StratixII_lvds_tx_out_block
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE std.textio.all;
USE work.stratixii_lvds_tx_parallel_register;
USE work.stratixii_lvds_tx_out_block;
USE work.stratixii_lvds_tx_reg;

ENTITY stratixii_lvds_transmitter is
    GENERIC ( channel_width                    : integer := 10;
              bypass_serializer                : String  := "false";
              invert_clock                     : String  := "false";
              use_falling_clock_edge           : String  := "false";
              use_serial_data_input            : String  := "false";
              use_post_dpa_serial_data_input   : String  := "false";
              preemphasis_setting              : integer := 0;
              vod_setting                      : integer := 0;
              differential_drive               : integer := 0;
              lpm_type                         : string  := "stratixii_lvds_transmitter";
              TimingChecksOn                   : Boolean := True;
              MsgOn                            : Boolean := DefGlitchMsgOn;
              XOn                              : Boolean := DefGlitchXOn;
              MsgOnChecks                      : Boolean := DefMsgOnChecks;
              XOnChecks                        : Boolean := DefXOnChecks;
              InstancePath                     : String := "*";
              tpd_clk0_dataout_posedge         : VitalDelayType01 := DefPropDelay01;
              tpd_clk0_dataout_negedge         : VitalDelayType01 := DefPropDelay01;
              tpd_serialdatain_dataout         : VitalDelayType01 := DefPropDelay01;
              tpd_postdpaserialdatain_dataout  : VitalDelayType01 := DefPropDelay01;
              tipd_clk0                        : VitalDelayType01 := DefpropDelay01;
              tipd_enable0                     : VitalDelayType01 := DefpropDelay01;
              tipd_datain                      : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01);
              tipd_serialdatain                : VitalDelayType01 := DefpropDelay01;
              tipd_postdpaserialdatain         : VitalDelayType01 := DefpropDelay01
            );

    PORT    ( clk0                     : in std_logic;
              enable0                  : in std_logic := '0';
              datain                   : in std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
              serialdatain             : in std_logic := '0';
              postdpaserialdatain      : in std_logic := '0';
              devclrn                  : in std_logic := '1';
              devpor                   : in std_logic := '1';
              dataout                  : out std_logic;
              serialfdbkout            : out std_logic
            );

end stratixii_lvds_transmitter;

ARCHITECTURE vital_transmitter_atom of stratixii_lvds_transmitter is

signal clk0_ipd : std_logic;
signal serialdatain_ipd : std_logic;
signal postdpaserialdatain_ipd : std_logic;

signal input_data : std_logic_vector(channel_width - 1 downto 0);
signal txload0 : std_logic;
signal shift_out : std_logic;

signal clk0_dly0 : std_logic;
signal clk0_dly1 : std_logic;
signal clk0_dly2 : std_logic;

signal datain_dly : std_logic_vector(channel_width - 1 downto 0);
signal datain_dly1 : std_logic_vector(channel_width - 1 downto 0);
signal datain_dly2 : std_logic_vector(channel_width - 1 downto 0);
signal datain_dly3 : std_logic_vector(channel_width - 1 downto 0);
signal datain_dly4 : std_logic_vector(channel_width - 1 downto 0);

signal vcc : std_logic := '1';
signal tmp_dataout : std_logic;

COMPONENT stratixii_lvds_tx_parallel_register
    GENERIC ( channel_width           : integer := 10;
              TimingChecksOn          : Boolean := True;
              MsgOn                   : Boolean := DefGlitchMsgOn;
              XOn                     : Boolean := DefGlitchXOn;
              MsgOnChecks             : Boolean := DefMsgOnChecks;
              XOnChecks               : Boolean := DefXOnChecks;
              InstancePath                : String := "*";
              tpd_clk_dataout_posedge : VitalDelayType01 := DefPropDelay01;
              tipd_clk                : VitalDelayType01 := DefpropDelay01;
              tipd_enable             : VitalDelayType01 := DefpropDelay01;
              tipd_datain             : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01)
            );

    PORT    ( clk                     : in std_logic;
              enable                  : in std_logic;
              datain                  : in std_logic_vector(channel_width - 1 downto 0);
              devclrn                 : in std_logic := '1';
              devpor                  : in std_logic := '1';
              dataout                 : out std_logic_vector(channel_width - 1 downto 0)
            );

END COMPONENT;

COMPONENT stratixii_lvds_tx_out_block
    GENERIC ( bypass_serializer        : String := "false";
              invert_clock             : String := "false";
              use_falling_clock_edge   : String := "false";
              TimingChecksOn           : Boolean := True;
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tpd_datain_dataout       : VitalDelayType01 := DefPropDelay01;
              tpd_clk_dataout          : VitalDelayType01 := DefPropDelay01;
              tpd_clk_dataout_negedge  : VitalDelayType01 := DefPropDelay01;
              tipd_clk                 : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayType01 := DefpropDelay01
            );

    PORT    ( clk                      : in std_logic;
              datain                   : in std_logic;
              devclrn                  : in std_logic := '1';
              devpor                   : in std_logic := '1';
              dataout                  : out std_logic
            );
END COMPONENT;

COMPONENT stratixii_lvds_tx_reg
    GENERIC (TimingChecksOn                : Boolean := true;
             InstancePath                  : STRING := "*";
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             MsgOnChecks                   : Boolean := DefMsgOnChecks;
             XOnChecks                     : Boolean := DefXOnChecks;
             tpd_clk_q_posedge             : VitalDelayType01 := DefPropDelay01;
             tsetup_d_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
             tipd_d                        : VitalDelayType01 := DefPropDelay01;
             tipd_clk                      : VitalDelayType01 := DefPropDelay01;
             tipd_ena                      : VitalDelayType01 := DefPropDelay01
            );

    PORT  ( q                              :  out   STD_LOGIC := '0';
            d                              :  in    STD_LOGIC := '1';
            clrn                           :  in    STD_LOGIC := '1';
            prn                            :  in    STD_LOGIC := '1';
            clk                            :  in    STD_LOGIC := '0';
            ena                            :  in    STD_LOGIC := '1'
          );
END COMPONENT;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
        VitalWireDelay (serialdatain_ipd, serialdatain, tipd_serialdatain);
        VitalWireDelay (postdpaserialdatain_ipd, postdpaserialdatain, tipd_postdpaserialdatain);
    end block;

    txload0_reg: stratixii_lvds_tx_reg
             PORT MAP (d    => enable0,
                       clrn => vcc,
                       prn  => vcc,
                       ena  => vcc,
                       clk  => clk0_dly2,
                       q    => txload0
                      );

    input_reg: stratixii_lvds_tx_parallel_register
             GENERIC MAP ( channel_width => channel_width)
             PORT MAP    ( clk => txload0,
                           enable => vcc,
                           datain => datain_dly,
                           dataout => input_data,
                           devclrn => devclrn,
                           devpor => devpor
                         );

    output_module: stratixii_lvds_tx_out_block
             GENERIC MAP ( bypass_serializer => bypass_serializer,
                           use_falling_clock_edge => use_falling_clock_edge,
                           invert_clock => invert_clock)
             PORT MAP    ( clk => clk0_dly2,
                           datain => shift_out,
                           dataout => tmp_dataout,
                           devclrn => devclrn,
                           devpor => devpor
                         );

    clk_delay: process (clk0_ipd, datain)
    begin
        clk0_dly0 <= clk0_ipd;
        datain_dly1 <= datain;
    end process;

    clk_delay1: process (clk0_dly0, datain_dly1)
    begin
        clk0_dly1 <= clk0_dly0;
        datain_dly2 <= datain_dly1;
    end process;

    clk_delay2: process (clk0_dly1, datain_dly2)
    begin
        clk0_dly2 <= clk0_dly1;
        datain_dly3 <= datain_dly2;
    end process;

    data_delay: process (datain_dly3)
    begin
        datain_dly4 <= datain_dly3;
    end process;

    data_delay1: process (datain_dly4)
    begin
        datain_dly <= datain_dly4;
    end process;

    VITAL: process (clk0_ipd, devclrn, devpor)
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    variable i : integer := 0;
    variable shift_data : std_logic_vector(channel_width-1 downto 0);
    begin
        if (now = 0 ns) then
            shift_data := (OTHERS => '0');
        end if;

        if ((devpor = '0') or (devclrn = '0')) then
            shift_data := (OTHERS => '0');
        else
            if (bypass_serializer = "false") then
                if (clk0_ipd'event and clk0_ipd = '1') then
                    if (txload0 = '1') then
                        shift_data := input_data;
                    end if;

                    shift_out <= shift_data(channel_width - 1);

                    for i in channel_width-1 downto 1 loop
                        shift_data(i) := shift_data(i - 1);
                    end loop;
                end if;
            end if;
        end if;

    end process;

    process (serialdatain_ipd,
            postdpaserialdatain_ipd,
            tmp_dataout
            )
    variable dataout_tmp : std_logic := '0';
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    begin
        if (serialdatain_ipd'event and use_serial_data_input = "true") then
            dataout_tmp := serialdatain_ipd;
        elsif (postdpaserialdatain_ipd'event and use_post_dpa_serial_data_input = "true") then
            dataout_tmp := postdpaserialdatain_ipd;
        else
            dataout_tmp := tmp_dataout;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        if (use_serial_data_input = "true") then
            VitalPathDelay01 (
                OutSignal => dataout,
                OutSignalName => "DATAOUT",
                OutTemp => dataout_tmp,
                Paths => (0 => (serialdatain_ipd'last_event, tpd_serialdatain_dataout, TRUE)),
                GlitchData => dataout_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn  => MsgOn );

        elsif (use_post_dpa_serial_data_input = "true") then
            VitalPathDelay01 (
                OutSignal => dataout,
                OutSignalName => "DATAOUT",
                OutTemp => dataout_tmp,
                Paths => (0 => (postdpaserialdatain_ipd'last_event, tpd_postdpaserialdatain_dataout, TRUE)),
                GlitchData => dataout_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn  => MsgOn );
        else
            VitalPathDelay01 (
                OutSignal => dataout,
                OutSignalName => "DATAOUT",
                OutTemp => dataout_tmp,
                Paths => (0 => (tmp_dataout'last_event, DefPropDelay01, TRUE)),
                GlitchData => dataout_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn  => MsgOn );
        end if;
    end process;

end vital_transmitter_atom;
--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_reg
--
-- Description : Simulation model for a simple DFF.
--               This is used for registering the enable inputs.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_lvds_reg is
    GENERIC ( MsgOn                   : Boolean := DefGlitchMsgOn;
              XOn                     : Boolean := DefGlitchXOn;
              MsgOnChecks             : Boolean := DefMsgOnChecks;
              XOnChecks               : Boolean := DefXOnChecks;
              TimingChecksOn          : Boolean := True;
              InstancePath            : String := "*";
              tipd_clk                : VitalDelayType01 := DefpropDelay01;
              tipd_ena                : VitalDelayType01 := DefpropDelay01;
              tipd_d                  : VitalDelayType01 := DefpropDelay01;
              tpd_clk_q_posedge       : VitalDelayType01 := DefPropDelay01;
              tpd_prn_q_negedge       : VitalDelayType01 := DefPropDelay01;
              tpd_clrn_q_negedge      : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( q                       : OUT std_logic;   
              clk                     : IN std_logic;   
              ena                     : IN std_logic := '1';
              d                       : IN std_logic;
              clrn                    : IN std_logic := '1';
              prn                     : IN std_logic := '1'
            );   
END stratixii_lvds_reg;

ARCHITECTURE vital_stratixii_lvds_reg of stratixii_lvds_reg is


    -- INTERNAL SIGNALS
    signal clk_ipd                  :  std_logic;   
    signal d_ipd                    :  std_logic;   
    signal ena_ipd                  :  std_logic;   

    begin

        ----------------------
        --  INPUT PATH DELAYs
        ----------------------
        WireDelay : block
        begin
            VitalWireDelay (clk_ipd, clk, tipd_clk);
            VitalWireDelay (ena_ipd, ena, tipd_ena);
            VitalWireDelay (d_ipd, d, tipd_d);
        end block;

        process (clk_ipd, d_ipd, clrn, prn)
        variable q_tmp :  std_logic := '0';
        variable q_VitalGlitchData : VitalGlitchDataType;
        variable Tviol_d_clk : std_ulogic := '0';
        variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
        begin

            ------------------------
            --  Timing Check Section
            ------------------------

            if (prn = '0') then
                q_tmp := '1';    
            elsif (clrn = '0') then
                q_tmp := '0';    
            elsif (clk_ipd'event and clk_ipd = '1') then
                if (ena_ipd = '1') then
                    q_tmp := d_ipd;    
                end if;
            end if;

            ----------------------
            --  Path Delay Section
            ----------------------
            VitalPathDelay01 (
                        OutSignal => q,
                        OutSignalName => "Q",
                        OutTemp => q_tmp,
                        Paths => (1 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE)),
                        GlitchData => q_VitalGlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn  => MsgOn );

        end process;

end vital_stratixii_lvds_reg;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_rx_fifo_sync_ram
--
-- Description :
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_lvds_rx_fifo_sync_ram is
    PORT ( clk                     : IN std_logic;   
           datain                  : IN std_logic := '0';
           writereset             : IN std_logic := '0';
           waddr                   : IN std_logic_vector(2 DOWNTO 0) := "000";
           raddr                   : IN std_logic_vector(2 DOWNTO 0) := "000";
           we                      : IN std_logic := '0';
           dataout                 : OUT std_logic
         );

END stratixii_lvds_rx_fifo_sync_ram;

ARCHITECTURE vital_arm_lvds_rx_fifo_sync_ram OF stratixii_lvds_rx_fifo_sync_ram IS

    -- INTERNAL SIGNALS
    signal dataout_tmp              :  std_logic;
    signal ram_d                    :  std_logic_vector(0 TO 5);
    signal ram_q                    :  std_logic_vector(0 TO 5);
    signal data_reg                 :  std_logic_vector(0 TO 5);

    begin
        dataout <= dataout_tmp;

    process (clk, writereset)
    variable initial : boolean := true;
    begin
        if (initial) then
            for i in 0 to 5 loop
                ram_q(i) <= '0';    
            end loop;
            initial := false;
        end if;
        if (writereset = '1') then
            for i in 0 to 5 loop
                ram_q(i) <= '0';    
            end loop;
        elsif (clk'event and clk = '1') then
            for i in 0 to 5 loop
                ram_q(i) <= ram_d(i);    
            end loop;
        end if;
    end process;

    process (we, data_reg, ram_q)
    begin
        if (we = '1') then
            ram_d <= data_reg;    
        else
            ram_d <= ram_q;    
        end if;
    end process;

   data_reg(0) <= datain when (waddr = "000") else ram_q(0) ;
   data_reg(1) <= datain when (waddr = "001") else ram_q(1) ;
   data_reg(2) <= datain when (waddr = "010") else ram_q(2) ;
   data_reg(3) <= datain when (waddr = "011") else ram_q(3) ;
   data_reg(4) <= datain when (waddr = "100") else ram_q(4) ;
   data_reg(5) <= datain when (waddr = "101") else ram_q(5) ;

    process (ram_q, we, waddr, raddr)
    variable initial : boolean := true;
    begin
        if (initial) then
            dataout_tmp <= '0';
            initial := false;
        end if;
        case raddr is
            when "000" =>
                  dataout_tmp <= ram_q(0);    
            when "001" =>
                  dataout_tmp <= ram_q(1);    
            when "010" =>
                  dataout_tmp <= ram_q(2);    
            when "011" =>
                  dataout_tmp <= ram_q(3);    
            when "100" =>
                  dataout_tmp <= ram_q(4);    
            when "101" =>
                  dataout_tmp <= ram_q(5);    
            when others  =>
                  dataout_tmp <= '0';    
      end case;
   end process;

END vital_arm_lvds_rx_fifo_sync_ram;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_rx_fifo
--
-- Description :
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE work.stratixii_lvds_rx_fifo_sync_ram;

ENTITY stratixii_lvds_rx_fifo is
    GENERIC ( channel_width           :  integer := 10;
              MsgOn                   : Boolean := DefGlitchMsgOn;
              XOn                     : Boolean := DefGlitchXOn;
              MsgOnChecks             : Boolean := DefMsgOnChecks;
              XOnChecks               : Boolean := DefXOnChecks;
              InstancePath            : String := "*";
              tipd_wclk               : VitalDelayType01 := DefpropDelay01;
              tipd_rclk               : VitalDelayType01 := DefpropDelay01;
              tipd_dparst             : VitalDelayType01 := DefpropDelay01;
              tipd_fiforst            : VitalDelayType01 := DefpropDelay01;
              tipd_datain             : VitalDelayType01 := DefpropDelay01;
              tpd_rclk_dataout_posedge: VitalDelayType01 := DefPropDelay01;
              tpd_dparst_dataout_posedge: VitalDelayType01 := DefPropDelay01
            );

    PORT    ( wclk                    : IN std_logic:= '0';
              rclk                    : IN std_logic:= '0';
              dparst                  : IN std_logic := '0';
              fiforst                 : IN std_logic := '0';
              datain                  : IN std_logic := '0';
              dataout                 : OUT std_logic
            );

END stratixii_lvds_rx_fifo;

ARCHITECTURE vital_arm_lvds_rx_fifo of stratixii_lvds_rx_fifo is
    -- INTERNAL SIGNALS
    signal datain_in                :  std_logic;   
    signal rclk_in                  :  std_logic;   
    signal dparst_in                :  std_logic;   
    signal fiforst_in               :  std_logic;   
    signal wclk_in                  :  std_logic;

    signal ram_datain               :  std_logic;   
    signal ram_dataout              :  std_logic;   
    signal wrPtr                    :  std_logic_vector(2 DOWNTO 0);   
    signal rdPtr                    :  std_logic_vector(2 DOWNTO 0);   
    signal rdAddr                   :  std_logic_vector(2 DOWNTO 0);   
    signal ram_we                   :  std_logic;   
    signal write_side_sync_reset    :  std_logic;   
    signal read_side_sync_reset     :  std_logic;   

    COMPONENT stratixii_lvds_rx_fifo_sync_ram
        PORT ( clk                  : IN  std_logic;
               datain               : IN  std_logic := '0';
               writereset          : IN  std_logic := '0';
               waddr                : IN  std_logic_vector(2 DOWNTO 0) := "000";
               raddr                : IN  std_logic_vector(2 DOWNTO 0) := "000";
               we                   : IN  std_logic := '0';
               dataout              : OUT std_logic
             );
    END COMPONENT;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (wclk_in, wclk, tipd_wclk);
        VitalWireDelay (rclk_in, rclk, tipd_rclk);
        VitalWireDelay (dparst_in, dparst, tipd_dparst);
        VitalWireDelay (fiforst_in, fiforst, tipd_fiforst);
        VitalWireDelay (datain_in, datain, tipd_datain);
    end block;

    rdAddr <= rdPtr ;
    s_fifo_ram : stratixii_lvds_rx_fifo_sync_ram 
           PORT MAP ( clk         => wclk_in,
                      datain      => ram_datain,
                      writereset => write_side_sync_reset,
                      waddr       => wrPtr,
                      raddr       => rdAddr,
                      we          => ram_we,
                      dataout     => ram_dataout
                    );
   

    process (wclk_in, dparst_in)
    variable initial : boolean := true;
    begin
        if (initial) then
            wrPtr <= "000";    
            write_side_sync_reset <= '0';
            ram_we <= '0';
            ram_datain <= '0';
            initial := false;
        end if;
        if (dparst_in = '1' or (fiforst_in = '1' and wclk_in'event and wclk_in = '1')) then
            write_side_sync_reset <= '1';    
            ram_datain <= '0';    
            wrPtr <= "000";    
            ram_we <= '0';    
        elsif (dparst_in = '0' and (fiforst_in = '0' and wclk_in'event and wclk_in = '1')) then
            write_side_sync_reset <= '0';    
        end if;
        if (wclk_in'event and wclk_in = '1' and write_side_sync_reset = '0' and  fiforst_in = '0' and dparst_in = '0') then
            ram_datain <= datain_in;    
            ram_we <= '1';
            case wrPtr is
                when "000" => wrPtr <= "001";
                when "001" => wrPtr <= "010";
                when "010" => wrPtr <= "011";
                when "011" => wrPtr <= "100";
                when "100" => wrPtr <= "101";
                when "101" => wrPtr <= "000";
                when others => wrPtr <= "000";
            end case;
        end if;
    end process;

    process (rclk_in, dparst_in)
    variable initial : boolean := true;
    variable dataout_tmp : std_logic := '0';
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    begin
        if (initial) then
            rdPtr <= "011";    
            read_side_sync_reset <= '0';
            dataout_tmp := '0';
            initial := false;
        end if;
        if (dparst_in = '1' or (fiforst_in = '1' and rclk_in'event and rclk_in = '1')) then
            read_side_sync_reset <= '1';    
            rdPtr <= "011";    
            dataout_tmp := '0';    
        elsif (dparst_in = '0' and (fiforst_in = '0' and rclk_in'event and rclk_in = '1')) then
            read_side_sync_reset <= '0';    
        end if;
        if (rclk_in'event and rclk_in = '1' and read_side_sync_reset = '0' and fiforst_in = '0' and dparst_in = '0') then
            case rdPtr is
                when "000" => rdPtr <= "001";
                when "001" => rdPtr <= "010";
                when "010" => rdPtr <= "011";
                when "011" => rdPtr <= "100";
                when "100" => rdPtr <= "101";
                when "101" => rdPtr <= "000";
                when others => rdPtr <= "000";
            end case;
            dataout_tmp := ram_dataout;    
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
                        Outsignal => dataout,
                        OutsignalName => "DATAOUT",
                        OutTemp => dataout_tmp,
                        Paths => (1 => (rclk_in'last_event, tpd_rclk_dataout_posedge, TRUE)),
                        GlitchData => dataout_VitalGlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn  => MsgOn );

    end process;

END vital_arm_lvds_rx_fifo;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_rx_bitslip
--
-- Description :
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE work.stratixii_lvds_reg;

ENTITY stratixii_lvds_rx_bitslip is
    GENERIC ( channel_width            : integer := 10;    
              bitslip_rollover         : integer := 12;
              x_on_bitslip             : string  := "on";
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tipd_clk0                : VitalDelayType01 := DefpropDelay01;
              tipd_bslipcntl           : VitalDelayType01 := DefpropDelay01;
              tipd_bsliprst            : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayType01 := DefpropDelay01;
              tpd_bsliprst_bslipmax_posedge: VitalDelayType01 := DefPropDelay01;
              tpd_clk0_bslipmax_posedge: VitalDelayType01 := DefPropDelay01
            );

    PORT    ( clk0                     : IN std_logic := '0';   
              bslipcntl                : IN std_logic := '0';   
              bsliprst                 : IN std_logic := '0';   
              datain                   : IN std_logic := '0';   
              bslipmax                 : OUT std_logic;   
              dataout                  : OUT std_logic
            );
END stratixii_lvds_rx_bitslip;

ARCHITECTURE vital_arm_lvds_rx_bitslip OF stratixii_lvds_rx_bitslip IS
    -- INTERNAL SIGNALS
    signal clk0_in               :  std_logic;   
    signal bslipcntl_in          :  std_logic;   
    signal bsliprst_in           :  std_logic;   
    signal datain_in             :  std_logic;   

    signal slip_count            :  integer := 0;
    signal dataout_tmp           :  std_logic;   
    signal bitslip_arr           :  std_logic_vector(11 DOWNTO 0) := "000000000000";
    signal bslipcntl_reg         :  std_logic;
    signal vcc                   : std_logic := '1';
    signal slip_data             : std_logic := '0';
    signal start_corrupt_bits    : std_logic := '0';
    signal num_corrupt_bits      : integer := 0;

    COMPONENT stratixii_lvds_reg
        GENERIC ( MsgOn                   : Boolean := DefGlitchMsgOn;
                  XOn                     : Boolean := DefGlitchXOn;
                  MsgOnChecks             : Boolean := DefMsgOnChecks;
                  XOnChecks               : Boolean := DefXOnChecks;
                  InstancePath            : String := "*";
                  tipd_clk                : VitalDelayType01 := DefpropDelay01;
                  tipd_ena                : VitalDelayType01 := DefpropDelay01;
                  tipd_d                  : VitalDelayType01 := DefpropDelay01;
                  tpd_clk_q_posedge       : VitalDelayType01 := DefPropDelay01
                );

        PORT    ( q                       : OUT std_logic;
                  clk                     : IN  std_logic;
                  ena                     : IN  std_logic := '1';
                  d                       : IN  std_logic;
                  clrn                    : IN  std_logic := '1';
                  prn                     : IN  std_logic := '1'
                );
    END COMPONENT;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk0_in, clk0, tipd_clk0);
        VitalWireDelay (bslipcntl_in, bslipcntl, tipd_bslipcntl);
        VitalWireDelay (bsliprst_in, bsliprst, tipd_bsliprst);
        VitalWireDelay (datain_in, datain, tipd_datain);
    end block;

    bslipcntlreg : stratixii_lvds_reg 
           PORT MAP ( d    => bslipcntl_in,
                      clk  => clk0_in,
                      ena  => vcc,
                      clrn => vcc,
                      prn  => vcc,
                      q    => bslipcntl_reg
                    );

    -- 4-bit slip counter and 12-bit shift register
    process (bslipcntl_reg, bsliprst_in, clk0_in)
    variable initial : boolean := true;
    variable bslipmax_tmp : std_logic := '0';
    variable bslipmax_VitalGlitchData : VitalGlitchDataType;
    begin
        if (bsliprst_in = '1') then
            slip_count <= 0;    
            bslipmax_tmp := '0';
--            bitslip_arr <= (OTHERS => '0');
            if (bsliprst_in'event and bsliprst_in = '1' and bsliprst_in'last_value = '0') then
                ASSERT false report "Bit Slip Circuit was reset. Serial Data stream will have 0 latency" severity note;
            end if;
        else
            if (bslipcntl_reg'event and bslipcntl_reg = '1' and bslipcntl_reg'last_value = '0') then
                if (x_on_bitslip = "on") then
                    start_corrupt_bits <= '1';
                end if;
                num_corrupt_bits <= 0;
                if (slip_count = bitslip_rollover) then
                    ASSERT false report "Rollover occurred on Bit Slip circuit. Serial data stream will have 0 latency." severity note;
                    slip_count <= 0;    
                    bslipmax_tmp := '0';    
                else
                    slip_count <= slip_count + 1;    
                    if ((slip_count + 1) = bitslip_rollover) then
                        ASSERT false report "The Bit Slip circuit has reached the maximum Bit Slip limit. Rollover will occur on the next slip." severity note;
                        bslipmax_tmp := '1';    
                    end if;
                end if;
            elsif (bslipcntl_reg'event and bslipcntl_reg = '0' and bslipcntl_reg'last_value = '1') then
                start_corrupt_bits <= '0';
                num_corrupt_bits <= 0;
            end if;
        end if;
            if (clk0_in'event and clk0_in = '1' and clk0_in'last_value = '0') then
                bitslip_arr(0) <= datain_in;
                for i in 0 to (bitslip_rollover - 1) loop
                    bitslip_arr(i + 1) <= bitslip_arr(i);    
                end loop;
 
                if (start_corrupt_bits = '1') then
                    num_corrupt_bits <= num_corrupt_bits + 1;
                end if;
                if (num_corrupt_bits+1 = 3) then
                    start_corrupt_bits <= '0';
                end if;
            end if;
--        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
                        Outsignal => bslipmax,
                        OutsignalName => "BSLIPMAX",
                        OutTemp => bslipmax_tmp,
                        Paths => (1 => (clk0_in'last_event, tpd_clk0_bslipmax_posedge, TRUE),
                                  2 => (bsliprst_in'last_event, tpd_bsliprst_bslipmax_posedge, TRUE)),
                        GlitchData => bslipmax_VitalGlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn  => MsgOn );
    end process;

    -- Bit Slip shift register
--    process (clk0_in, bsliprst_in)
--    begin
--        if (bsliprst_in = '1') then
--        elsif (clk0_in'event and clk0_in = '1' and clk0'last_value = '0') then
--            bitslip_arr(0) <= datain_in;
--            for i in 0 to (bitslip_rollover - 1) loop
--                bitslip_arr(i + 1) <= bitslip_arr(i);    
--            end loop;
--
--            if (start_corrupt_bits = '1') then
--                num_corrupt_bits <= num_corrupt_bits + 1;
--            end if;
--            if (num_corrupt_bits+1 = 3) then
--                start_corrupt_bits <= '0';
--            end if;
--        end if;
--    end process;

    slip_data <= bitslip_arr(slip_count);

    dataoutreg : stratixii_lvds_reg 
          PORT MAP ( d => slip_data,
                     clk => clk0_in,
                     ena => vcc,
                     clrn => vcc,
                     prn => vcc,
                     q => dataout_tmp
                   );

    dataout <= dataout_tmp when start_corrupt_bits = '0' else
               'X' when start_corrupt_bits = '1' and num_corrupt_bits < 3 else
               dataout_tmp;

END vital_arm_lvds_rx_bitslip;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_rx_deser
--
-- Description : Timing simulation model for the STRATIXII LVDS RECEIVER
--               DESERIALIZER. This module receives serial data and outputs
--               parallel data word of width = channel width
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_lvds_rx_deser IS
    GENERIC ( channel_width            :  integer := 4;
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tipd_clk                 : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayType01 := DefpropDelay01;
              tpd_clk_dataout_posedge  : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( clk                      : IN std_logic := '0';   
              datain                   : IN std_logic := '0';   
              dataout                  : OUT std_logic_vector(channel_width - 1 DOWNTO 0);   
              devclrn                  : IN std_logic := '1';   
              devpor                   : IN std_logic := '1'
            );

END stratixii_lvds_rx_deser;

ARCHITECTURE vital_arm_lvds_rx_deser OF stratixii_lvds_rx_deser IS

    -- INTERNAL SIGNALS
    signal clk_ipd                  :  std_logic;   
    signal datain_ipd               :  std_logic;   

    begin

        ----------------------
        --  INPUT PATH DELAYs
        ----------------------
        WireDelay : block
        begin
            VitalWireDelay (clk_ipd, clk, tipd_clk);
            VitalWireDelay (datain_ipd, datain, tipd_datain);
        end block;

        VITAL: process (clk_ipd, devpor, devclrn)
        variable dataout_tmp : std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
        variable i : integer := 0;
        variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
        variable CQDelay : TIME := 0 ns;
        begin
            if (devclrn = '0' or devpor = '0') then
                dataout_tmp := (OTHERS => '0');    
        else
            if (clk_ipd'event and clk_ipd  = '1' and clk_ipd'last_value = '0') then
                for i in channel_width - 1 DOWNTO 1 loop
                    dataout_tmp(i) := dataout_tmp(i - 1);    
                end loop;
                dataout_tmp(0) := datain_ipd;    
            end if;
        end if;

            ----------------------
            --  Path Delay Section
            ----------------------

            CQDelay := SelectDelay (
                       (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE))
            );
            dataout <= TRANSPORT dataout_tmp AFTER CQDelay;
        end process;

END vital_arm_lvds_rx_deser;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixii_lvds_rx_parallel_reg
--
-- Description : Timing simulation model for the STRATIXII LVDS RECEIVER
--               PARALLEL REGISTER. The data width equals max. channel width,
--               which is 10.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;

ENTITY stratixii_lvds_rx_parallel_reg IS
    GENERIC ( channel_width            :  integer := 4;
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tipd_clk                 : VitalDelayType01 := DefpropDelay01;
              tipd_enable              : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01);
              tpd_clk_dataout_posedge  : VitalDelayType01 := DefPropDelay01
            );
    PORT    ( clk                      : IN std_logic;   
              enable                   : IN std_logic := '1';   
              datain                   : IN std_logic_vector(channel_width - 1 DOWNTO 0);   
              dataout                  : OUT std_logic_vector(channel_width - 1 DOWNTO 0);   
              devclrn                  : IN std_logic := '1';   
              devpor                   : IN std_logic := '1'
            );

END stratixii_lvds_rx_parallel_reg;

ARCHITECTURE vital_arm_lvds_rx_parallel_reg OF stratixii_lvds_rx_parallel_reg IS
    -- INTERNAL SIGNALS
    signal clk_ipd                  :  std_logic;   
    signal datain_ipd               :  std_logic_vector(channel_width - 1 downto 0);   
    signal enable_ipd               :  std_logic;   

    begin

        ----------------------
        --  INPUT PATH DELAYs
        ----------------------
        WireDelay : block
        begin
            VitalWireDelay (clk_ipd, clk, tipd_clk);
            VitalWireDelay (enable_ipd, enable, tipd_enable);
            loopbits : FOR i in datain'RANGE GENERATE
                VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
            END GENERATE;
        end block;

        VITAL: process (clk_ipd, devpor, devclrn)
        variable dataout_tmp : std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
        variable i : integer := 0;
        variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
        variable CQDelay : TIME := 0 ns;
        begin
            if ((devpor = '0') or (devclrn = '0')) then
                dataout_tmp := (OTHERS => '0');
            else
                if (clk_ipd'event and clk_ipd = '1') then
                    if (enable_ipd = '1') then
                        dataout_tmp := datain_ipd;
                    end if;
                end if;
            end if;

            ----------------------
            --  Path Delay Section
            ----------------------

            CQDelay := SelectDelay (
                    (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE))
            );
            dataout <= dataout_tmp AFTER CQDelay;
        end process;
END vital_arm_lvds_rx_parallel_reg;



--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : STRATIXII_LVDS_RECEIVER
--
-- Description : Timing simulation model for the STRATIXII LVDS RECEIVER
--               atom. This module instantiates the following sub-modules :
--               1) stratixii_lvds_rx_fifo
--               2) stratixii_lvds_rx_bitslip
--               3) DFFEs for the LOADEN signals
--               4) stratixii_lvds_rx_parallel_reg
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixii_atom_pack.all;
USE work.stratixii_lvds_rx_bitslip;
USE work.stratixii_lvds_rx_fifo;
USE work.stratixii_lvds_rx_deser;
USE work.stratixii_lvds_rx_parallel_reg;
USE work.stratixii_lvds_reg;

ENTITY stratixii_lvds_receiver IS
    GENERIC ( channel_width                  :  integer := 10;    
              data_align_rollover            :  integer := 2;    
              enable_dpa                     :  string := "off";    
              lose_lock_on_one_change        :  string := "off";    
              reset_fifo_at_first_lock       :  string := "on";    
              align_to_rising_edge_only      :  string := "on";    
              use_serial_feedback_input      :  string := "off";    
              dpa_debug                      :  string := "off";
              x_on_bitslip                   :  string := "on";
              lpm_type                       :  string := "stratixii_lvds_receiver";
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tipd_clk0                : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayType01 := DefpropDelay01;
              tipd_enable0             : VitalDelayType01 := DefpropDelay01;
              tipd_dpareset            : VitalDelayType01 := DefpropDelay01;
              tipd_dpahold             : VitalDelayType01 := DefpropDelay01;
              tipd_dpaswitch           : VitalDelayType01 := DefpropDelay01;
              tipd_fiforeset           : VitalDelayType01 := DefpropDelay01;
              tipd_bitslip             : VitalDelayType01 := DefpropDelay01;
              tipd_bitslipreset        : VitalDelayType01 := DefpropDelay01;
              tipd_serialfbk           : VitalDelayType01 := DefpropDelay01;
              tpd_clk0_dpalock_posedge : VitalDelayType01 := DefPropDelay01
            );
    PORT    ( clk0                    : IN std_logic;   
              datain                  : IN std_logic := '0';   
              enable0                 : IN std_logic := '0';   
              dpareset                : IN std_logic := '0';   
              dpahold                 : IN std_logic := '0';   
              dpaswitch               : IN std_logic := '0';   
              fiforeset               : IN std_logic := '0';   
              bitslip                 : IN std_logic := '0';   
              bitslipreset            : IN std_logic := '0';   
              serialfbk               : IN std_logic := '0';   
              dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);   
              dpalock                 : OUT std_logic;   
              bitslipmax              : OUT std_logic;   
              serialdataout           : OUT std_logic;   
              postdpaserialdataout    : OUT std_logic;
              devclrn                 : IN std_logic := '1';   
              devpor                  : IN std_logic := '1'
            );

END stratixii_lvds_receiver;

ARCHITECTURE vital_arm_lvds_receiver OF stratixii_lvds_receiver IS

    COMPONENT stratixii_lvds_rx_bitslip
        GENERIC ( channel_width            : integer := 10;    
                  bitslip_rollover         : integer := 12;
                  x_on_bitslip             : string  := "on";
                  MsgOn                    : Boolean := DefGlitchMsgOn;
                  XOn                      : Boolean := DefGlitchXOn;
                  MsgOnChecks              : Boolean := DefMsgOnChecks;
                  XOnChecks                : Boolean := DefXOnChecks;
                  InstancePath             : String := "*";
                  tipd_clk0                : VitalDelayType01 := DefpropDelay01;
                  tipd_bslipcntl           : VitalDelayType01 := DefpropDelay01;
                  tipd_bsliprst            : VitalDelayType01 := DefpropDelay01;
                  tipd_datain              : VitalDelayType01 := DefpropDelay01;
                  tpd_bsliprst_bslipmax_posedge: VitalDelayType01 := DefPropDelay01;
                  tpd_clk0_bslipmax_posedge: VitalDelayType01 := DefPropDelay01
                );
        PORT    ( clk0                    : IN  std_logic := '0';
                  bslipcntl               : IN  std_logic := '0';
                  bsliprst                : IN  std_logic := '0';
                  datain                  : IN  std_logic := '0';
                  bslipmax                : OUT std_logic;
                  dataout                 : OUT std_logic
                );
    END COMPONENT;

    COMPONENT stratixii_lvds_rx_fifo
        GENERIC ( channel_width           :  integer := 10
                );
        PORT    ( wclk                    : IN  std_logic := '0';
                  rclk                    : IN  std_logic := '0';
                  fiforst                 : IN  std_logic := '0';
                  dparst                  : IN  std_logic := '0';
                  datain                  : IN  std_logic := '0';
                  dataout                 : OUT std_logic
                );
    END COMPONENT;

    COMPONENT stratixii_lvds_rx_deser
        GENERIC ( channel_width           :  integer := 4
                );
        PORT    ( clk                     : IN  std_logic;
                  datain                  : IN  std_logic;
                  dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);
                  devclrn                 : IN  std_logic := '1';
                  devpor                  : IN  std_logic := '1'
                );
    END COMPONENT;

    COMPONENT stratixii_lvds_rx_parallel_reg
        GENERIC ( channel_width           :  integer := 4
                );
        PORT    ( clk                     : IN  std_logic;
                  enable                  : IN  std_logic := '1';
                  datain                  : IN  std_logic_vector(channel_width - 1 DOWNTO 0);
                  dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);
                  devclrn                 : IN  std_logic := '1';
                  devpor                  : IN  std_logic := '1'
                );
    END COMPONENT;

    COMPONENT stratixii_lvds_reg
        GENERIC ( MsgOn                   : Boolean := DefGlitchMsgOn;
                  XOn                     : Boolean := DefGlitchXOn;
                  MsgOnChecks             : Boolean := DefMsgOnChecks;
                  XOnChecks               : Boolean := DefXOnChecks;
                  InstancePath            : String := "*";
                  tipd_clk                : VitalDelayType01 := DefpropDelay01;
                  tipd_ena                : VitalDelayType01 := DefpropDelay01;
                  tipd_d                  : VitalDelayType01 := DefpropDelay01;
                  tpd_clk_q_posedge       : VitalDelayType01 := DefPropDelay01
                );
        PORT    ( q                       : OUT std_logic;
                  clk                     : IN  std_logic;
                  ena                     : IN  std_logic := '1';
                  d                       : IN  std_logic;
                  clrn                    : IN  std_logic := '1';
                  prn                     : IN  std_logic := '1'
                );
      END COMPONENT;             
   

    -- INTERNAL SIGNALS
    signal bitslip_ipd              :  std_logic;   
    signal bitslipreset_ipd         :  std_logic;   
    signal clk0_ipd                 :  std_logic;   
    signal datain_ipd               :  std_logic;   
    signal dpahold_ipd              :  std_logic;   
    signal dpareset_ipd             :  std_logic;   
    signal dpaswitch_ipd            :  std_logic;   
    signal enable0_ipd              :  std_logic;   
    signal fiforeset_ipd            :  std_logic;   
    signal serialfbk_ipd            :  std_logic;   

    signal fifo_wclk                :  std_logic;   
    signal fifo_rclk                :  std_logic;   
    signal fifo_datain              :  std_logic;   
    signal fifo_dataout             :  std_logic;   
    signal fifo_reset               :  std_logic;   
    signal slip_datain              :  std_logic;   
    signal slip_dataout             :  std_logic;   
    signal bitslip_reset            :  std_logic;   
    --    wire deser_dataout;
    signal dpareg0_out              :  std_logic;   
    signal dpareg1_out              :  std_logic;   
    signal dpa_clk                  :  std_logic;   
    signal dpa_rst                  :  std_logic;   
    signal datain_reg               :  std_logic;
    signal datain_reg_neg           :  std_logic;
    signal datain_reg_tmp           :  std_logic;   
    signal deser_dataout            :  std_logic_vector(channel_width - 1 DOWNTO 0);   
    signal reset_fifo               :  std_logic;   
    signal first_dpa_lock           :  std_logic;   
    signal loadreg_datain           :  std_logic_vector(channel_width - 1 DOWNTO 0);   
    signal reset_int                :  std_logic;   
    signal gnd                      :  std_logic := '0';
    signal vcc                      :  std_logic := '1';
    signal in_reg_data              :  std_logic;   
    signal clk0_dly                 :  std_logic;   
    signal datain_tmp               :  std_logic;   
    signal slip_datain_tmp          :  std_logic; 
    signal s_bitslip_clk             :  std_logic; 
    signal loaden                     :  std_logic;
        
        
    -- INTERNAL PARAMETERS
    CONSTANT  DPA_CYCLES_TO_LOCK    :  integer := 2;

    signal xhdl_12                  :  std_logic;   
    signal rxload                   :  std_logic;   

    begin

        WireDelay : block
        begin
            VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
            VitalWireDelay (datain_ipd, datain, tipd_datain);
            VitalWireDelay (enable0_ipd, enable0, tipd_enable0);
            VitalWireDelay (dpareset_ipd, dpareset, tipd_dpareset);
            VitalWireDelay (dpahold_ipd, dpahold, tipd_dpahold);
            VitalWireDelay (dpaswitch_ipd, dpaswitch, tipd_dpaswitch);   
            VitalWireDelay (fiforeset_ipd, fiforeset, tipd_fiforeset);
            VitalWireDelay (bitslip_ipd, bitslip, tipd_bitslip);
            VitalWireDelay (bitslipreset_ipd, bitslipreset, tipd_bitslipreset);
            VitalWireDelay (serialfbk_ipd, serialfbk, tipd_serialfbk);
        end block;

        fifo_rclk <= clk0_ipd WHEN (enable_dpa = "on") ELSE gnd ;
        fifo_wclk <= dpa_clk ;
        fifo_datain <= dpareg1_out WHEN (enable_dpa = "on") ELSE gnd ;
        reset_int <= (NOT devpor) OR (NOT devclrn) ;
        fifo_reset <= (NOT devpor) OR (NOT devclrn) OR fiforeset_ipd OR dpareset_ipd OR reset_fifo ;
        bitslip_reset <= (NOT devpor) OR (NOT devclrn) OR bitslipreset_ipd ;
        in_reg_data <= serialfbk_ipd WHEN (use_serial_feedback_input = "on") ELSE datain_ipd;
        clk0_dly <= clk0_ipd;

        xhdl_12 <= devclrn OR devpor;
    
        -- SUB-MODULE INSTANTIATION

        -- input register in non-DPA mode for sampling incoming data
        in_reg : stratixii_lvds_reg 
            PORT MAP ( d    => in_reg_data,
                       clk  => clk0_dly,
                       ena  => vcc,
                       clrn => xhdl_12,
                       prn  => vcc,
                       q    => datain_reg
                     );
        datain_reg_tmp <= datain_reg;              

        dpa_clk <= clk0_ipd when (enable_dpa = "on") else '0' ;    
        dpa_rst <= dpareset_ipd when (enable_dpa = "on") else '0' ;

        process (dpa_clk, dpa_rst)
        variable dpa_lock_count : integer := 0;
        variable dparst_msg : boolean := false;
        variable dpa_is_locked : std_logic := '0';
        variable dpalock_VitalGlitchData : VitalGlitchDataType;
        variable initial : boolean := true;
        begin
            if (initial) then
                if (reset_fifo_at_first_lock = "on") then
                    reset_fifo <= '1';
                else
                    reset_fifo <= '0';
                end if;

                if (enable_dpa = "on") then
                    ASSERT false report "DPA Phase tracking is not modeled, and once locked, DPA will continue to lock until the next reset is asserted. Please refer to the StratixII device handbook for further details." severity warning;
                end if;

                initial := false;
            end if;

            if (dpa_rst = '1') then
                dpa_is_locked := '0';    
                dpa_lock_count := 0;    
                if (not dparst_msg) then
                    ASSERT false report "DPA was reset" severity note;
                    dparst_msg := true;    
                end if;
            elsif (dpa_clk'event and dpa_clk = '1') then
                dparst_msg := false;    
                if (dpa_is_locked = '0') then
                    dpa_lock_count := dpa_lock_count + 1;    
                    if (dpa_lock_count > DPA_CYCLES_TO_LOCK) then
                        dpa_is_locked := '1';    
                        ASSERT false report "DPA locked" severity note;
                        reset_fifo <= '0';    
                    end if;
                end if;
            end if;

            ----------------------
            --  Path Delay Section
            ----------------------
            VitalPathDelay01 (
                        OutSignal => dpalock,
                        OutSignalName => "DPALOCK",
                        OutTemp => dpa_is_locked,
                        Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dpalock_posedge, enable_dpa = "on")),
                        GlitchData => dpalock_VitalGlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn  => MsgOn );
    end process;

    -- ?????????? insert delay to mimic DPLL dataout ?????????

    -- DPA registers
    dpareg0 : stratixii_lvds_reg 
        PORT MAP ( d    => in_reg_data,
                   clk  => dpa_clk,
                   clrn => vcc,
                   prn  => vcc,
                   ena  => vcc,
                   q    => dpareg0_out
                 );
   
    dpareg1 : stratixii_lvds_reg             
        PORT MAP ( d    => dpareg0_out,      
                   clk  => dpa_clk,          
                   clrn => vcc,              
                   prn  => vcc,              
                   ena  => vcc,              
                   q    => dpareg1_out       
                 );                          
   
    s_fifo : stratixii_lvds_rx_fifo 
        GENERIC MAP ( channel_width => channel_width
                    )
        PORT MAP    ( wclk    => fifo_wclk,
                      rclk    => fifo_rclk,
                      fiforst => fifo_reset,
                      dparst  => dpa_rst,
                      datain  => fifo_datain,
                      dataout => fifo_dataout
                    );
   
    slip_datain_tmp <= fifo_dataout when (enable_dpa = "on" and dpaswitch_ipd = '1') else datain_reg_tmp ;
    
    slip_datain <= slip_datain_tmp; 
    
    s_bitslip_clk <= clk0_dly; 
    
    s_bslip : stratixii_lvds_rx_bitslip 
        GENERIC MAP ( bitslip_rollover => data_align_rollover,
                      channel_width    => channel_width,
                      x_on_bitslip     => x_on_bitslip
                    )
        PORT MAP    ( clk0      => s_bitslip_clk,
                      bslipcntl => bitslip_ipd,
                      bsliprst  => bitslip_reset,
                      datain    => slip_datain,
                      bslipmax  => bitslipmax,
                      dataout   => slip_dataout
                    );
   
    --********* DESERIALISER *********//
loaden <= enable0_ipd;  

   -- only 1 enable signal used for StratixII
    rxload_reg : stratixii_lvds_reg 
        PORT MAP ( d    => loaden,
                   clk  => s_bitslip_clk,
                   ena  => vcc,
                   clrn => vcc,
                   prn  => vcc,
                   q    => rxload
                 );

    s_deser : stratixii_lvds_rx_deser
        GENERIC MAP (channel_width => channel_width
                    )
        PORT MAP    (clk => s_bitslip_clk,
                     datain => slip_dataout,
                     devclrn => devclrn,
                     devpor => devpor,
                     dataout => deser_dataout
                    );

    output_reg : stratixii_lvds_rx_parallel_reg 
        GENERIC MAP ( channel_width => channel_width
                    )
        PORT MAP    ( clk => s_bitslip_clk,
                      enable => rxload,
                      datain => deser_dataout,
                      devpor => devpor,
                      devclrn => devclrn,
                      dataout => dataout
                    );
                                                            
                                                            
    postdpaserialdataout <= dpareg1_out ;
    serialdataout <= datain_ipd;   

END vital_arm_lvds_receiver;
-------------------------------------------------------------------------------
--
-- Entity Name : StratixII_dll
--
-- Outputs     : delayctrlout - current delay chain settings for DQS pin
--               offsetctrlout - current delay offset setting
--               dqsupdate - update enable signal for delay setting latces
--               upndnout - raw output of the phase comparator
--
-- Inputs      : clk - reference clock matching in frequency to DQS clock
--               aload - asychronous load signal for delay setting counter
--                       when asserted, counter is loaded with initial value
--               offset - offset added/subtracted from delayctrlout
--               upndnin - up/down input port for delay setting counter in
--                         use_updndnin mode (user control mode)
--               upndninclkena - clock enable for the delaying setting counter
--               addnsub - dynamically control +/- on offsetctrlout
--
-- Formulae    : delay (input_period) = sim_loop_intrinsic_delay + 
--                                      sim_loop_delay_increment * dllcounter;
--
-- Latency     : 3 (clk8 cycles) = pc + dc + dr
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;
USE work.stratixii_pllpack.all;

ENTITY stratixii_dll is
    GENERIC ( 
    input_frequency          : string := "10000 ps";
    delay_chain_length       : integer := 16;
    delay_buffer_mode        : string := "low";
    delayctrlout_mode        : string := "normal";
    static_delay_ctrl        : integer := 0;
    offsetctrlout_mode       : string := "static";
    static_offset            : string := "0";
    jitter_reduction         : string := "false";
    use_upndnin              : string := "false";
    use_upndninclkena        : string := "false";
    sim_valid_lock           : integer := 1;
    sim_loop_intrinsic_delay : integer := 1000;
    sim_loop_delay_increment : integer := 100;
    sim_valid_lockcount      : integer := 90;  -- 10000 = 1000 + 100*dllcounter
    lpm_type                 : string := "stratixii_dll";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_offset              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_upndnin             : VitalDelayType01 := DefpropDelay01;
    tipd_upndninclkena       : VitalDelayType01 := DefpropDelay01;
    tipd_addnsub             : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tpd_offset_delayctrlout  : VitalDelayType01 := DefPropDelay01;
    tpd_clk_upndnout_posedge : VitalDelayType01 := DefPropDelay01;
    tsetup_offset_clk_noedge_posedge        : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_offset_clk_noedge_posedge         : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_upndnin_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_upndnin_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tsetup_upndninclkena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
    thold_upndninclkena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    tsetup_addnsub_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_addnsub_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_delayctrlout_posedge            : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );

    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              offset                   : IN std_logic_vector(5 DOWNTO 0) := "000000";
              upndnin                  : IN std_logic := '1';
              upndninclkena            : IN std_logic := '1';
              addnsub                  : IN std_logic := '1';
              delayctrlout             : OUT std_logic_vector(5 DOWNTO 0);
              offsetctrlout            : OUT std_logic_vector(5 DOWNTO 0);
              dqsupdate                : OUT std_logic;
              upndnout                 : OUT std_logic;	
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '1'
            );

END stratixii_dll;


ARCHITECTURE vital_armdll of stratixii_dll is

-- tuncate input integer to get 6 LSB bits
function dll_unsigned2bin (in_int : integer) return std_logic_vector is
variable tmp_int, i : integer;
variable tmp_bit : integer;
variable result : std_logic_vector(5 downto 0) := "000000";
begin
    tmp_int := in_int;
    for i in 0 to 5 loop
        tmp_bit := tmp_int MOD 2;
        if (tmp_bit = 1) then
            result(i) := '1';
        else
            result(i) := '0';
	    end if;
		tmp_int := tmp_int/2;
    end loop;
    return result;
end dll_unsigned2bin;

signal clk_in               : std_logic := '0';
signal aload_in             : std_logic := '0';
signal offset_in            : std_logic_vector(5 DOWNTO 0) := "000000";
signal upndn_in             : std_logic := '0';
signal upndninclkena_in     : std_logic := '1';
signal addnsub_in           : std_logic := '0';

signal delayctrl_out        : std_logic_vector(5 DOWNTO 0) := "000000";
signal offsetctrl_out       : std_logic_vector(5 DOWNTO 0) := "000000";
signal dqsupdate_out        : std_logic := '1';
signal upndn_out            : std_logic := '0';

signal para_delay_buffer_mode       : std_logic_vector (1 DOWNTO 0) := "01";
signal para_delayctrlout_mode       : std_logic_vector (1 DOWNTO 0) := "00";
signal para_offsetctrlout_mode      : std_logic_vector (1 DOWNTO 0) := "00";
signal para_static_offset           : integer := 0;
signal para_static_delay_ctrl       : integer := 0;
signal para_jitter_reduction        : std_logic := '0';
signal para_use_upndnin             : std_logic := '0';
signal para_use_upndninclkena       : std_logic := '1';

-- INTERNAL NETS AND VARIABLES

-- for functionality - by modules

-- delay and offset control out resolver
signal dr_delayctrl_out       : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_delayctrl_int       : integer := 0;
signal dr_offsetctrl_out      : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_offsetctrl_int      : integer := 0;
signal dr_offset_in           : integer := 0;
signal dr_dllcount_in         : integer := 0;
signal dr_addnsub_in          : std_logic := '1';
signal dr_clk8_in             : std_logic := '0';
signal dr_aload_in             : std_logic := '0';
                           
signal dr_reg_offset          : integer := 0;
signal dr_reg_dllcount        : integer := 0;
signal dr_delayctrl_out_tmp   : integer := 0;

                            
                                                          
-- delay chain setting counter
signal dc_dllcount_out        : integer := 0;
signal dc_dqsupdate_out       : std_logic := '0';
signal dc_upndn_in            : std_logic := '1';
signal dc_aload_in            : std_logic := '0';
signal dc_upndnclkena_in      : std_logic := '1';
signal dc_clk8_in             : std_logic := '0';
signal dc_clk1_in             : std_logic := '0';
signal dc_dlltolock_in        : std_logic := '0';
                                
signal dc_reg_dllcount        : integer := 0;
signal dc_reg_dlltolock_pulse : std_logic := '0';
                                   
-- jitter reduction counter   
signal jc_upndn_out           : std_logic := '0';
signal jc_upndnclkena_out     : std_logic := '1';
signal jc_clk8_in             : std_logic := '0';
signal jc_upndn_in            : std_logic := '1';
signal jc_aload_in            : std_logic := '0';
                                    
signal jc_count               : integer   := 8;
signal jc_reg_upndn           : std_logic := '0';
signal jc_reg_upndnclkena     : std_logic := '0';
                                   
-- phase comparator
signal pc_upndn_out           : std_logic := '1';
signal pc_dllcount_in         : integer := 0;
signal pc_clk1_in             : std_logic := '0';
signal pc_clk8_in             : std_logic := '0';
signal pc_aload_in            : std_logic := '0';
                                      
signal pc_reg_upndn           : std_logic := '1';
signal pc_delay               : integer   := 0; 
                                       
-- clock generator
signal cg_clk_in              : std_logic := '0';
signal cg_aload_in            : std_logic := '0';
signal cg_clk1_out            : std_logic := '0';

signal cg_clk8a_out           : std_logic := '0';
signal cg_clk8b_out           : std_logic := '0';

-- por: 000                                                  
signal cg_reg_1           : std_logic := '0';
signal cg_rega_2          : std_logic := '0';
signal cg_rega_3          : std_logic := '0';

-- por: 010
signal cg_regb_2          : std_logic := '1';
signal cg_regb_3          : std_logic := '0';
                                          
-- for violation checks                                          
signal dll_to_lock            : std_logic := '0';
signal input_period           : integer := 10000;
signal clk_in_last_value      : std_logic := 'X';


begin
    -- paramters
    input_period           <= dqs_str2int(input_frequency);
    para_static_offset     <= dqs_str2int(static_offset);
	para_static_delay_ctrl <= static_delay_ctrl;
    para_use_upndnin       <= '1' WHEN use_upndnin = "true" ELSE '0';
    para_jitter_reduction  <= '1' WHEN jitter_reduction = "true" ELSE '0';
    para_use_upndninclkena  <= '1' WHEN use_upndninclkena = "true" ELSE '0';
    para_delay_buffer_mode  <= "00" WHEN delay_buffer_mode = "auto" ELSE "01" WHEN delay_buffer_mode = "low" ELSE "10";
    para_delayctrlout_mode  <= "01" WHEN delayctrlout_mode = "offset_only" ELSE "10" WHEN delayctrlout_mode="normal_offset" ELSE "11" WHEN delayctrlout_mode="static" ELSE "00";
    para_offsetctrlout_mode <= "11" WHEN offsetctrlout_mode = "dynamic_addnsub" ELSE "10" WHEN offsetctrlout_mode = "dynamic_sub" ELSE "01" WHEN offsetctrlout_mode = "dynamic_add" ELSE "00";

	-- violation check block
    process (clk_in)
               
    variable got_first_rising_edge  : std_logic := '0';
    variable got_first_falling_edge : std_logic := '0';

    variable per_violation              : std_logic  := '0';
    variable duty_violation             : std_logic  := '0';
    variable sent_per_violation         : std_logic  := '0';
    variable sent_duty_violation        : std_logic  := '0';
               
    variable clk_in_last_rising_edge  : time := 0 ps;
    variable clk_in_last_falling_edge : time := 0 ps;
                      
    variable input_period_ps     : time := 10000 ps;
    variable duty_cycle          : time := 5000 ps;
    variable clk_in_period       : time := 10000 ps;
    variable clk_in_duty_cycle   : time := 5000 ps;
    variable clk_per_tolerance   : time := 2 ps;
    variable half_cycles_to_lock : integer := 1;
                      
    variable init : boolean := true;
                     
    begin
        if (init) then
            input_period_ps := dqs_str2int(input_frequency) * 1 ps;
			if (input_period_ps = 0 ps) then
                assert false report "Need to specify ps scale in simulation command" severity error;
            end if;

            duty_cycle := input_period_ps/2;
            clk_per_tolerance := 2 ps;                        
            half_cycles_to_lock := 0;
            init := false;
        end if;
             
        if (clk_in'event and clk_in = '1')    then -- rising edge
            if (got_first_rising_edge = '0') then
                got_first_rising_edge := '1';
            else     -- subsequent rising
                -- check for clock period and duty cycle violation
                clk_in_period := now - clk_in_last_rising_edge;
                clk_in_duty_cycle := now - clk_in_last_falling_edge;
                if ((clk_in_period < (input_period_ps - clk_per_tolerance)) or (clk_in_period > (input_period_ps + clk_per_tolerance))) then
                    per_violation := '1';
                    if (sent_per_violation /= '1') then
                        sent_per_violation := '1';
                        assert false report "Input clock frequency violation." severity warning;
                    end if;
                elsif ((clk_in_duty_cycle < (duty_cycle - clk_per_tolerance/2 - 1 ps)) or (clk_in_duty_cycle > (duty_cycle + clk_per_tolerance/2 + 1 ps))) then
                    duty_violation := '1';
                    if (sent_duty_violation /= '1') then
                        sent_duty_violation := '1';
                        assert false report "Input clock duty cycle violation." severity warning;
                    end if;
                else
                    if (per_violation = '1') then
                        sent_per_violation := '0';
                        assert false report "Input clock frequency now matches specified clock frequency." severity warning;
                    end if;
                    per_violation := '0';
                    duty_violation := '0';
                end if;
            end if;
            
            if (per_violation = '0' and duty_violation = '0' and dll_to_lock = '0') then			       
                half_cycles_to_lock := half_cycles_to_lock + 1;
                if (half_cycles_to_lock >= sim_valid_lock) then
                    dll_to_lock <= '1';
                    assert false report "DLL to lock to incoming clock" severity note;
                end if;                          
            end if;
            clk_in_last_rising_edge := now;
        elsif (clk_in'event and clk_in = '0') then  -- falling edge
            got_first_falling_edge := '1';
            if (got_first_rising_edge = '1') then
                -- duty cycle check
                clk_in_duty_cycle := now - clk_in_last_rising_edge;
                if ((clk_in_duty_cycle < (duty_cycle - clk_per_tolerance/2 - 1 ps)) or (clk_in_duty_cycle > (duty_cycle + clk_per_tolerance/2 + 1 ps))) then
                    duty_violation := '1';
                    if (sent_duty_violation /= '1') then
                        sent_duty_violation := '1';
                        assert false report "Input clock duty cycle violation." severity warning;
                    end if;
                else
                    duty_violation := '0';
                end if;
                             
                if (dll_to_lock = '0' and duty_violation = '0') then 
                    half_cycles_to_lock := half_cycles_to_lock + 1;
                end if;
            end if;
            clk_in_last_falling_edge := now;
        elsif (got_first_falling_edge = '1' or got_first_rising_edge = '1') then
            -- switches from 1, 0 to X
            half_cycles_to_lock := 0;
            got_first_rising_edge := '0';
            got_first_falling_edge := '0';
            if (dll_to_lock = '1') then
                dll_to_lock <= '0';
                assert false report "Illegal value detected on input clock. DLL will lose lock." severity warning;
            else
                assert false report "Illegal value detected on input clock." severity warning;
            end if;               
        end if;
                 
        clk_in_last_value <= clk_in;
                     
    end process ; -- violation check
                    
                   
    -- outputs
    delayctrl_out  <= dr_delayctrl_out;
    offsetctrl_out <= dr_offsetctrl_out;
    dqsupdate_out  <= cg_clk8a_out;
    upndn_out      <= pc_upndn_out;
        
                    	
    -- Delay and offset ctrl out resolver -------------------------------------
    -------- convert calculations into integer
                   
    -- inputs
    dr_clk8_in     <= not cg_clk8b_out;
    dr_offset_in   <= (64 - alt_conv_integer(offset_in)) WHEN ((offset_in /= "000000") AND ((offsetctrlout_mode = "dynamic_addnsub" AND  addnsub_in = '0') or (offsetctrlout_mode = "dynamic_sub"))) ELSE
                       alt_conv_integer(offset_in);
    dr_dllcount_in <= dc_dllcount_out; 
    dr_addnsub_in  <= addnsub_in; 
    dr_aload_in    <= aload_in; 
                
    -- outputs
    dr_delayctrl_out  <= dll_unsigned2bin(dr_delayctrl_out_tmp);
    dr_offsetctrl_out <= dll_unsigned2bin(dr_reg_offset); 
    
    dr_delayctrl_out_tmp <= dr_offset_in    WHEN (delayctrlout_mode = "offset_only")   ELSE
                            dr_reg_offset   WHEN (delayctrlout_mode = "normal_offset") ELSE
                            dr_reg_dllcount;
      	
    dr_delayctrl_int <= para_static_delay_ctrl WHEN (delayctrlout_mode = "static") ELSE
                        dr_dllcount_in;
    
    dr_offsetctrl_int <= para_static_offset WHEN (offsetctrlout_mode = "static") ELSE
                         dr_offset_in;
          
    -- model
    process(dr_clk8_in, dr_aload_in)
    begin
        if (dr_aload_in = '1' and dr_aload_in'event) then
            dr_reg_dllcount <= 0;
        elsif (dr_clk8_in = '1' and dr_clk8_in'event and dr_aload_in /= '1') then
            dr_reg_dllcount <= dr_delayctrl_int;
        end if;
     end process;
    
    -- generating dr_reg_offset
    process(dr_clk8_in, dr_aload_in)
    begin
        if (dr_aload_in = '1' and dr_aload_in'event) then
            dr_reg_offset <= 0;
        elsif (dr_aload_in /= '1' and dr_clk8_in = '1' and dr_clk8_in'event) then
		  if (offsetctrlout_mode = "dynamic_addnsub") then
            if (dr_addnsub_in = '1') then
                if (dr_delayctrl_int < 63 - dr_offset_in) then
                    dr_reg_offset <= dr_delayctrl_int + dr_offset_in;
                else 
                    dr_reg_offset <= 63;
                end if;
            elsif (dr_addnsub_in = '0') then
                if (dr_delayctrl_int > dr_offset_in) then
                    dr_reg_offset <= dr_delayctrl_int - dr_offset_in;
                else
                    dr_reg_offset <= 0;
                end if;
            end if;
          elsif (offsetctrlout_mode = "dynamic_sub") then
            if (dr_delayctrl_int > dr_offset_in) then
                dr_reg_offset <= dr_delayctrl_int - dr_offset_in;
            else
                dr_reg_offset <= 0;
            end if;    
          elsif (offsetctrlout_mode = "dynamic_add") then
            if (dr_delayctrl_int < 63 - dr_offset_in) then
                dr_reg_offset <= dr_delayctrl_int + dr_offset_in;
            else 
                dr_reg_offset <= 63;
            end if;
          elsif (offsetctrlout_mode = "static") then
            if (para_static_offset >= 0) then
                if ((para_static_offset < 64) AND (para_static_offset < 64 - dr_delayctrl_int)) then
                    dr_reg_offset <= dr_delayctrl_int + para_static_offset;
                else
                    dr_reg_offset <= 64;
                end if;
            else
                if ((para_static_offset > -63) AND (dr_delayctrl_int > (-1)*para_static_offset)) then
                    dr_reg_offset <= dr_delayctrl_int + para_static_offset;
                else
                    dr_reg_offset <= 0;
                end if;
            end if;
          else
    	    dr_reg_offset <= 14;  -- error
          end if; -- modes
        end if; -- rising clock
    end process ;  -- generating dr_reg_offset
                           
    -- Delay Setting Control Counter ------------------------------------------
             
    --inputs
    dc_dlltolock_in   <= dll_to_lock;
    dc_aload_in       <= aload_in;
    dc_clk1_in        <= cg_clk1_out;
    dc_clk8_in        <= not cg_clk8b_out;
    dc_upndnclkena_in <= jc_upndnclkena_out WHEN (para_jitter_reduction = '1') ELSE 
                         upndninclkena      WHEN (para_use_upndninclkena = '1')      ELSE 
                         '1';
    dc_upndn_in       <= upndnin      WHEN (para_use_upndnin = '1')      ELSE 
                         jc_upndn_out WHEN (para_jitter_reduction = '1') ELSE 
                         pc_upndn_out;
           
    -- outputs
    dc_dllcount_out  <= dc_reg_dllcount;
                
    -- dll counter logic
    process(dc_clk8_in, dc_aload_in, dc_dlltolock_in)
    variable dc_var_dllcount : integer := 64;
    variable init            : boolean := true;
    begin
        if (init) then
            if (delay_buffer_mode = "low") then
                dc_var_dllcount := 32; 
            else
                dc_var_dllcount := 16;
		    end if;
            init := false;
        end if;
              
        if (dc_aload_in = '1' and dc_aload_in'event) then
            if (delay_buffer_mode = "low") then
                dc_var_dllcount := 32; 
            else
                dc_var_dllcount := 16;
            end if;
        elsif (dc_aload_in /= '1' and dc_dlltolock_in = '1' and dc_reg_dlltolock_pulse /= '1' and
               dc_upndnclkena_in = '1' and para_use_upndnin = '0') then
                dc_var_dllcount := sim_valid_lockcount;
                dc_reg_dlltolock_pulse <= '1';
        elsif (dc_aload_in /= '1' and
                dc_upndnclkena_in = '1' and dc_clk8_in'event and dc_clk8_in = '1')  then  -- posedge clk            
                if (dc_upndn_in = '1') then
                    if ((para_delay_buffer_mode = "01" and dc_var_dllcount < 63) or
                        (para_delay_buffer_mode /= "01" and dc_var_dllcount < 31)) then
                       dc_var_dllcount := dc_var_dllcount + 1;
                    end if;
                elsif (dc_upndn_in = '0') then
                    if (dc_var_dllcount > 0) then
                        dc_var_dllcount := dc_var_dllcount - 1;
                    end if;
                end if;
        end if;  -- rising clock
                  
        -- schedule signal dc_reg_dllcount
        dc_reg_dllcount <= dc_var_dllcount;
    end process;
                                 
    -- Jitter reduction counter -----------------------------------------------
         
    -- inputs
    jc_clk8_in  <= not cg_clk8b_out;
    jc_upndn_in <= pc_upndn_out;
    jc_aload_in <= aload_in;
              
    -- outputs
    jc_upndn_out       <= jc_reg_upndn;
    jc_upndnclkena_out <= jc_reg_upndnclkena;
             
    -- Model
    process (jc_clk8_in, jc_aload_in)
    begin
        if (jc_aload_in = '1' and jc_aload_in'event) then
            jc_count <= 8;
        elsif (jc_aload_in /= '1' and jc_clk8_in'event and jc_clk8_in = '1') then
            if (jc_count = 12) then
                jc_reg_upndn <= '1';
                jc_reg_upndnclkena <= '1';
                jc_count <= 8;
            elsif (jc_count = 4) then
                jc_reg_upndn <= '0';
                jc_reg_upndnclkena <= '1';
                jc_count <= 8;
            else  -- increment/decrement counter
                jc_reg_upndnclkena <= '0';
                if (jc_upndn_in = '1') then
                    jc_count <= jc_count + 1;
                elsif (jc_upndn_in = '0') then
                    jc_count <= jc_count - 1;
                end if;
            end if;
        end if;
    end process;
         
    -- Phase comparator -------------------------------------------------------
                 
    -- inputs
    pc_clk1_in <= cg_clk1_out;
    pc_clk8_in <= cg_clk8b_out;  -- positive
    pc_dllcount_in <= dc_dllcount_out; -- for phase loop calculation
    pc_aload_in <= aload_in;
       
    -- outputs
    pc_upndn_out <= pc_reg_upndn;
          
    -- parameter used
    -- sim_loop_intrinsic_delay, sim_loop_delay_increment
         
    -- Model
    process (pc_clk8_in, pc_aload_in)
    variable pc_var_delay : integer := 0;
    begin
        if (pc_aload_in = '1' and pc_aload_in'event) then
            pc_var_delay := 0;
        elsif (pc_aload_in /= '1' and pc_clk8_in'event and pc_clk8_in = '1' ) then	   
            pc_var_delay := sim_loop_intrinsic_delay + sim_loop_delay_increment * pc_dllcount_in;
            if (pc_var_delay > input_period) then
                pc_reg_upndn <= '0';
            else
                pc_reg_upndn <= '1';
            end if;
             
            pc_delay <= pc_var_delay;
        end if;
    end process;
           
    -- Clock Generator -------------------------------------------------------
          
    -- inputs
    cg_clk_in <= clk_in;
    cg_aload_in <= aload_in;
         	
    -- outputs
    cg_clk8a_out <= cg_rega_3;
    cg_clk8b_out <= cg_regb_3;
    cg_clk1_out <= '0' WHEN cg_aload_in = '1' ELSE cg_clk_in;
              
    -- Model
    process(cg_clk1_out, cg_aload_in)
    begin
        if (cg_aload_in = '1' and cg_aload_in'event) then
            cg_reg_1 <= '0';
        elsif (cg_aload_in /= '1' and cg_clk1_out = '1' and cg_clk1_out'event) then
            cg_reg_1 <= not cg_reg_1;
        end if;
    end  process;
             
    process(cg_reg_1, cg_aload_in)
    begin
        if (cg_aload_in = '1' and cg_aload_in'event) then
            cg_rega_2 <= '0';
            cg_regb_2 <= '1';
        elsif (cg_aload_in /= '1' and cg_reg_1 = '1' and cg_reg_1'event) then
            cg_rega_2 <= not cg_rega_2;
            cg_regb_2 <= not cg_regb_2;
        end if;
    end  process;
            
    process (cg_rega_2, cg_aload_in)
    begin
        if (cg_aload_in = '1' and cg_aload_in'event) then
            cg_rega_3 <= '0';
        elsif (cg_aload_in /= '1' and cg_rega_2 = '1' and cg_rega_2'event) then
            cg_rega_3 <= not cg_rega_3;
        end if;
    end  process;
            
    process (cg_regb_2, cg_aload_in)
    begin
        if (cg_aload_in = '1' and cg_aload_in'event) then
            cg_regb_3 <= '0';
        elsif (cg_aload_in /= '1' and cg_regb_2 = '1' and cg_regb_2'event) then
            cg_regb_3 <= not cg_regb_3;
        end if;
    end  process;
             
    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_in,       clk,       tipd_clk);
        VitalWireDelay (aload_in,     aload,     tipd_aload);
        VitalWireDelay (upndn_in,     upndnin,   tipd_upndnin);
        VitalWireDelay (addnsub_in,   addnsub,   tipd_addnsub);
        VitalWireDelay (offset_in(0), offset(0), tipd_offset(0));
        VitalWireDelay (offset_in(1), offset(1), tipd_offset(1));
        VitalWireDelay (offset_in(2), offset(2), tipd_offset(2));
        VitalWireDelay (offset_in(3), offset(3), tipd_offset(3));
        VitalWireDelay (offset_in(4), offset(4), tipd_offset(4));
        VitalWireDelay (offset_in(5), offset(5), tipd_offset(5));
        VitalWireDelay (upndninclkena_in, upndninclkena, tipd_upndninclkena);
    end block;
         
   	------------------------
    --  Timing Check Section
    ------------------------
    VITALtiming : process (clk_in, offset_in, upndn_in, upndninclkena_in, addnsub_in, 
                           delayctrl_out, offsetctrl_out, dqsupdate_out, upndn_out)
    
    variable Tviol_offset_clk        : std_ulogic := '0';
    variable Tviol_upndnin_clk       : std_ulogic := '0';
    variable Tviol_addnsub_clk       : std_ulogic := '0';
    variable Tviol_upndninclkena_clk : std_ulogic := '0';
           
    variable TimingData_offset_clk        : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_upndnin_clk       : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_addnsub_clk       : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_upndninclkena_clk : VitalTimingDataType := VitalTimingDataInit;
         
    variable delayctrlout_VitalGlitchDataArray  : VitalGlitchDataArrayType(5 downto 0);
	variable upndnout_VitalGlitchData           : VitalGlitchDataType;
                  
    begin

        if (TimingChecksOn) then
                      
           VitalSetupHoldCheck (
               Violation       => Tviol_offset_clk,
               TimingData      => TimingData_offset_clk,
               TestSignal      => offset_in,
               TestSignalName  => "OFFSET",
               RefSignal       => clk_in,
               RefSignalName   => "CLK",
               SetupHigh       => tsetup_offset_clk_noedge_posedge(0),
               SetupLow        => tsetup_offset_clk_noedge_posedge(0),
               HoldHigh        => thold_offset_clk_noedge_posedge(0),
               HoldLow         => thold_offset_clk_noedge_posedge(0),                
               RefTransition   => '/',
               HeaderMsg       => InstancePath & "/SRRATIXII_DLL",
               XOn             => XOn,
               MsgOn           => MsgOnChecks );
                          
           VitalSetupHoldCheck (
               Violation       => Tviol_upndnin_clk,
               TimingData      => TimingData_upndnin_clk,
               TestSignal      => upndn_in,
               TestSignalName  => "UPNDNIN",
               RefSignal       => clk_in,
               RefSignalName   => "CLK",
               SetupHigh       => tsetup_upndnin_clk_noedge_posedge,
               SetupLow        => tsetup_upndnin_clk_noedge_posedge,
               HoldHigh        => thold_upndnin_clk_noedge_posedge,
               HoldLow         => thold_upndnin_clk_noedge_posedge,
               RefTransition   => '/',
               HeaderMsg       => InstancePath & "/STRATIXII_DLL",
               XOn             => XOn,
               MsgOn           => MsgOnChecks );
                          
           VitalSetupHoldCheck (
               Violation       => Tviol_upndninclkena_clk,
               TimingData      => TimingData_upndninclkena_clk,
               TestSignal      => upndninclkena_in,
               TestSignalName  => "UPNDNINCLKENA",
               RefSignal       => clk_in,
               RefSignalName   => "CLK",
               SetupHigh       => tsetup_upndninclkena_clk_noedge_posedge,
               SetupLow        => tsetup_upndninclkena_clk_noedge_posedge,
               HoldHigh        => thold_upndninclkena_clk_noedge_posedge,
               HoldLow         => thold_upndninclkena_clk_noedge_posedge,
               RefTransition   => '/',
               HeaderMsg       => InstancePath & "/STRATIXII_DLL",
               XOn             => XOn,
               MsgOn           => MsgOnChecks );
                          
           VitalSetupHoldCheck (
               Violation       => Tviol_addnsub_clk,
               TimingData      => TimingData_addnsub_clk,
               TestSignal      => addnsub_in,
               TestSignalName  => "ADDNSUB",
               RefSignal       => clk_in,
               RefSignalName   => "CLK",
               SetupHigh       => tsetup_addnsub_clk_noedge_posedge,
               SetupLow        => tsetup_addnsub_clk_noedge_posedge,
               HoldHigh        => thold_addnsub_clk_noedge_posedge,
               HoldLow         => thold_addnsub_clk_noedge_posedge,
               RefTransition   => '/',
               HeaderMsg       => InstancePath & "/STRATIXII_DLL",
               XOn             => XOn,
               MsgOn           => MsgOnChecks );   	               
       end if;

       ----------------------
       --  Path Delay Section
       ----------------------
                                                                     
       offsetctrlout <= offsetctrl_out;
	   dqsupdate <= dqsupdate_out;
                                                                     
       VitalPathDelay01 (
           OutSignal     => upndnout,
           OutSignalName => "UPNDNOUT",
           OutTemp       => upndn_out,
           Paths => (0   => (clk_in'last_event,   tpd_clk_upndnout_posedge,   TRUE)),
           GlitchData    => upndnout_VitalGlitchData,
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
                              
       VitalPathDelay01 (
           OutSignal     => delayctrlout(0),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(0),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE),
                     1   => (offset_in'last_event, tpd_offset_delayctrlout, TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(0),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => delayctrlout(1),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(1),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE),
                     1   => (offset_in'last_event, tpd_offset_delayctrlout, TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(1),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
           
       VitalPathDelay01 (
           OutSignal     => delayctrlout(2),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(2),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE),
                     1   => (offset_in'last_event, tpd_offset_delayctrlout, TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(2),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => delayctrlout(3),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(3),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE),
                     1   => (offset_in'last_event, tpd_offset_delayctrlout, TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(3),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => delayctrlout(4),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(4),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE),
                     1   => (offset_in'last_event, tpd_offset_delayctrlout, TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(4),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
           
       VitalPathDelay01 (
           OutSignal     => delayctrlout(5),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(5),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE),
                     1   => (offset_in'last_event, tpd_offset_delayctrlout, TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(5),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
 


    end process;  -- vital timing


end vital_armdll;

--
--
--  STRATIXII_RUBLOCK Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.stratixii_atom_pack.all;

entity  stratixii_rublock is
	generic
	(
		operation_mode			: string := "remote";
		sim_init_config			: string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_page_select	: integer := 0;
		sim_init_status			: integer := 0;
		lpm_type				: string := "stratixii_rublock"
	);
	port 
	(
		clk			: in std_logic; 
		shiftnld	: in std_logic; 
		captnupdt	: in std_logic; 
		regin		: in std_logic; 
		rsttimer	: in std_logic; 
		rconfig		: in std_logic; 
		regout		: out std_logic; 
		pgmout		: out std_logic_vector(2 downto 0)
	);

end stratixii_rublock;

architecture architecture_rublock of stratixii_rublock is

	signal update_reg : std_logic_vector(20 downto 0);
	signal status_reg : std_logic_vector(4 downto 0) := conv_std_logic_vector(sim_init_status, 5);
	signal shift_reg : std_logic_vector(25 downto 0) := (others => '0');

	signal pgmout_update : std_logic_vector(2 downto 0) := (others => '0');

begin

	-- regout is output of shift-reg bit 0
	-- note that in Stratix, there is an inverter to regout.
	-- but in Stratix II, there is no inverter.
	regout <= shift_reg(0);

	-- pgmout is set when reconfig is asserted
	pgmout <= pgmout_update;

	process (clk)
	begin

		-- initialize registers/outputs
		if ( now = 0 ns ) then

			-- wd_timeout field
			update_reg(20 downto 9) <= conv_std_logic_vector(sim_init_watchdog_value, 12);

			-- wd enable field
			if (sim_init_watchdog_value > 0) then
				update_reg(8) <= '1';
			else
				update_reg(8) <= '0';
			end if;

			-- PGM[] field
			update_reg(7 downto 1) <= conv_std_logic_vector(sim_init_page_select, 7);

			-- AnF bit
			if (sim_init_config = "factory") then
				update_reg(0) <= '0';
			else
				update_reg(0) <= '1';
			end if;

			--to-do: print field values
			--report "Remote Update Block: Initial configuration:";
			--report "        -> Field CRC, POF ID, SW ID Error Caused Reconfiguration is set to" & status_reg(0);
			--report "        -> Field nSTATUS Caused Reconfiguration is set to %s", status_reg[1] ? "True" : "False";
			--report "        -> Field Core nCONFIG Caused Reconfiguration is set to %s", status_reg[2] ? "True" : "False";
			--report "        -> Field Pin nCONFIG Caused Reconfiguration is set to %s", status_reg[3] ? "True" : "False";
			--report "        -> Field Watchdog Timeout Caused Reconfiguration is set to %s", status_reg[4] ? "True" : "False";
			--report "        -> Field Current Configuration is set to %s", update_reg[0] ? "Application" : "Factory";
			--report "        -> Field PGM[] Page Select is set to %d", update_reg[7:1]);
			--report "        -> Field User Watchdog is set to %s", update_reg[8] ? "Enabled" : "Disabled";
			--report "        -> Field User Watchdog Timeout Value is set to %d", update_reg[20:9];

		else 
			-- dont handle clk events during initialization since this will
			-- destroy the register values that we just initialized

			if (clk = '1') then
				if (shiftnld = '1') then
					-- register shifting
					for i in 0 to 24 loop
						shift_reg(i) <= shift_reg(i+1);
					end loop;

					shift_reg(25) <= regin;

				elsif (shiftnld = '0') then
					-- register loading

					if (captnupdt = '1') then
						-- capture data into shift register
						shift_reg <= update_reg & status_reg;

					elsif (captnupdt = '0') then
						-- update data from shift into Update Register

						if (sim_init_config = "factory" and 
							(operation_mode = "remote" or operation_mode = "active_serial_remote")) then
							-- every bit in Update Reg gets updated
							update_reg(20 downto 0) <= shift_reg(25 downto 5);

							--to-do: print field values
							--VHDL93 only: report "Remote Update Block: Update Register updated at time " & time'image(now);
							--report "        -> Field PGM[] Page Select is set to %d", shift_reg[12:6];
							--report "        -> Field User Watchdog is set to %s", (shift_reg[13] == 1) ? "Enableds" : (shift_reg[13] == 0) ? "Disabled" : "x";
							--report "        -> Field User Watchdog Timeout Value is set to %d", shift_reg[25:14];
						else
							-- trying to do update in Application mode
							--VHDL93 only: report "Remote Update Block: Attempted update of Update Register at time " & time'image(now) & " when Configuration is set to Application" severity WARNING;
						end if;

					else
						-- invalid captnupdt
						-- destroys update and shift regs
						shift_reg <= (others => 'X');
						if (sim_init_config = "factory") then
							update_reg(20 downto 1) <= (others => 'X');
						end if;
					end if;

				else
					-- invalid shiftnld: destroys update and shift regs
					shift_reg <= (others => 'X');
					if (sim_init_config = "factory") then
						update_reg(20 downto 1) <= (others => 'X');
					end if;
				end if;

			elsif (clk /= '0') then
				-- invalid clk: destroys registers
				shift_reg <= (others => 'X');
				if (sim_init_config = "factory") then
					update_reg(20 downto 1) <= (others => 'X');
				end if;
			end if;
		end if;
	end process;

	process (rconfig)
	begin
		-- initialize registers/outputs
		if ( now = 0 ns ) then

			-- pgmout update

			if (operation_mode = "local") then
				pgmout_update <= "001";
			elsif (operation_mode = "remote") then
				pgmout_update <= conv_std_logic_vector(sim_init_page_select, 3);
				-- PGM[] field
			else
				pgmout_update <= (others => 'X');			
			end if;
		end if;

		if (rconfig = '1') then
			-- start reconfiguration
			--to-do: print field values
			--VHDL93 only: report "Remote Update Block: Reconfiguration initiated at time " & time'image(now);
			--report "        -> Field Current Configuration is set to %s", update_reg[0] ? "Application" : "Factory";
			--report "        -> Field PGM[] Page Select is set to %d", update_reg[7:1];
			--report "        -> Field User Watchdog is set to %s", (update_reg[8] == 1) ? "Enabled" : (update_reg[8] == 0) ? "Disabled" : "x";
			--report "        -> Field User Watchdog Timeout Value is set to %d", update_reg[20:9];

			if (operation_mode = "remote") then
				-- set pgm[] to page as set in Update Register
				pgmout_update <= update_reg(3 downto 1);
				
			elsif (operation_mode = "local") then
				-- set pgm[] to page as 001
				pgmout_update <= "001";
			else			
				-- invalid rconfig: destroys pgmout (only if not initializing)
				pgmout_update <= (others => 'X');			
			end if;
			
		elsif (rconfig /= '0') then
			-- invalid rconfig: destroys pgmout (only if not initializing)
			if (now /= 0 ns) then
				pgmout_update <= (others => 'X');			
			end if;
		end if;
	end process;

end architecture_rublock;


-------------------------------------------------------------------------------
--
-- Entity Name : stratixii_termination
--
-- Outputs     : incrup and incrdn - output of voltage comparator
--               terminationcontrol - to I/O, cannot wired to PLD
--               terminationcontrolprobe - internal testing outputs only
--
-- Descriptions : the Atom represent On Chip Termination calibration block.
--               The block has no digital outputs that can be observed in PLD.
--               Therefore we do not have simulation model other than entity
--               declaration.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_termination is
    GENERIC (
    runtime_control           : string := "false";
    use_core_control          : string := "false";
    pullup_control_to_core    : string := "true";
    use_high_voltage_compare  : string := "true";
    use_both_compares         : string := "false";
    pullup_adder              : integer := 0;
    pulldown_adder            : integer := 0;
    half_rate_clock           : string := "false";
    power_down : string       := "true";
    left_shift : string       := "false";
    test_mode : string        := "false";
    lpm_type : string         := "stratixii_termination";

    tipd_rup                  : VitalDelayType01 := DefpropDelay01;
    tipd_rdn                  : VitalDelayType01 := DefpropDelay01;
    tipd_terminationclock     : VitalDelayType01 := DefpropDelay01;
    tipd_terminationclear     : VitalDelayType01 := DefpropDelay01;
    tipd_terminationenable    : VitalDelayType01 := DefpropDelay01;
    tipd_terminationpullup    : VitalDelayArrayType01(6 downto 0) := (OTHERS => DefPropDelay01);
    tipd_terminationpulldown  : VitalDelayArrayType01(6 downto 0) := (OTHERS => DefPropDelay01);

    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";

    tpd_terminationclock_terminationcontrol_posedge       : VitalDelayArrayType01(13 downto 0) := (OTHERS => DefPropDelay01);
    tpd_terminationclock_terminationcontrolprobe_posedge  : VitalDelayArrayType01(6 downto 0)  := (OTHERS => DefPropDelay01)
    );

    PORT ( 
    rup                      : IN std_logic := '0';
    rdn                      : IN std_logic := '0';
    terminationclock         : IN std_logic := '0';
    terminationclear         : IN std_logic := '0';
    terminationenable        : IN std_logic := '1';
    terminationpullup        : IN std_logic_vector(6 DOWNTO 0) := "0000000";
    terminationpulldown      : IN std_logic_vector(6 DOWNTO 0) := "0000000";
    devclrn                  : IN std_logic := '1';
    devpor                   : IN std_logic := '0';
    incrup                   : OUT std_logic;
    incrdn                   : OUT std_logic;
    terminationcontrol       : OUT std_logic_vector(13 DOWNTO 0);
    terminationcontrolprobe  : OUT std_logic_vector(6 DOWNTO 0)
    );

END stratixii_termination;

ARCHITECTURE vital_armtermination of stratixii_termination is

begin             
    --------------------
    -- INPUT PATH DELAYS
    --------------------
         
   	------------------------
    --  Timing Check Section
    ------------------------

    ----------------------
    --  Path Delay Section
    ----------------------
                                                                     
end vital_armtermination;

---------------------------------------------------------------------
--
-- Entity Name :  stratixii_routing_wire
--
-- Description :  StratixII Routing Wire VHDL simulation model
--
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixii_atom_pack.all;

ENTITY stratixii_routing_wire is
    generic (
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             tpd_datain_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_datainglitch_dataout : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          datain : in std_logic;
          dataout : out std_logic
         );
   attribute VITAL_LEVEL0 of stratixii_routing_wire : entity is TRUE;
end stratixii_routing_wire;

ARCHITECTURE behave of stratixii_routing_wire is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;
signal datain_ipd : std_logic;
signal datainglitch_inert : std_logic;
begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
    end block;

    VITAL: process(datain_ipd, datainglitch_inert)
    variable datain_inert_VitalGlitchData : VitalGlitchDataType;
    variable dataout_VitalGlitchData : VitalGlitchDataType;

    begin
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => datainglitch_inert,
            OutSignalName => "datainglitch_inert",
            OutTemp => datain_ipd,
            Paths => (1 => (datain_ipd'last_event, tpd_datainglitch_dataout, TRUE)),
            GlitchData => datain_inert_VitalGlitchData,
            Mode => VitalInertial,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
        VitalPathDelay01 (
            OutSignal => dataout,
            OutSignalName => "dataout",
            OutTemp => datainglitch_inert,
            Paths => (1 => (datain_ipd'last_event, tpd_datain_dataout, TRUE)),
            GlitchData => dataout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

    end process;

end behave;
