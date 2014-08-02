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

package stratixiii_atom_pack is

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
    TYPE stratixiii_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

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

end stratixiii_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body stratixiii_atom_pack is

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

end stratixiii_atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package stratixiii_pllpack is


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

end stratixiii_pllpack;

package body stratixiii_pllpack is


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

end stratixiii_pllpack;

--
--
--  DFFE Model
--
--

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

entity stratixiii_dffe is
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
    attribute VITAL_LEVEL0 of stratixiii_dffe : entity is TRUE;
end stratixiii_dffe;

-- architecture body --

architecture behave of stratixiii_dffe is
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
--  stratixiii_mux21 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixiii_atom_pack.all;

entity stratixiii_mux21 is
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
    attribute VITAL_LEVEL0 of stratixiii_mux21 : entity is TRUE;
end stratixiii_mux21;

architecture AltVITAL of stratixiii_mux21 is
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
--  stratixiii_mux41 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixiii_atom_pack.all;

entity stratixiii_mux41 is
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
    attribute VITAL_LEVEL0 of stratixiii_mux41 : entity is TRUE;
end stratixiii_mux41;

architecture AltVITAL of stratixiii_mux41 is
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
--  stratixiii_and1 Model
--
--
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixiii_atom_pack.all;

-- entity declaration --
entity stratixiii_and1 is
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
    attribute VITAL_LEVEL0 of stratixiii_and1 : entity is TRUE;
end stratixiii_and1;

-- architecture body --

architecture AltVITAL of stratixiii_and1 is
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
-------------------------------------------------------------------
--
-- Entity Name : stratixiii_jtag
--
-- Description : Stratix JTAG VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

entity  stratixiii_jtag is
    generic (
        lpm_type : string := "stratixiii_jtag"
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
end stratixiii_jtag;

architecture architecture_jtag of stratixiii_jtag is
begin

end architecture_jtag;

-------------------------------------------------------------------
--
-- Entity Name : stratixiii_crcblock
--
-- Description : Stratix CRCBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

entity  stratixiii_crcblock is
    generic  (
        oscillator_divider : integer := 1;
 crc_deld_disable : string := "off";
 error_delay : integer :=  0 ;
 error_dra_dl_bypass : string := "off";

        lpm_type : string := "stratixiii_crcblock"
        );	
    port (
        clk : in std_logic := '0'; 
        shiftnld : in std_logic := '0'; 
        crcerror : out std_logic; 
        regout : out std_logic
        ); 
end stratixiii_crcblock;

architecture architecture_crcblock of stratixiii_crcblock is
begin
	crcerror <= '0';
	regout <= '0';
end architecture_crcblock;
---------------------------------------------------------------------
--
-- Entity Name :  stratixiii_lcell_comb
-- 
-- Description :  Stratix III LCELL_COMB VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

entity stratixiii_lcell_comb is
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
              dont_touch : string := "off";
             lpm_type : string := "stratixiii_lcell_comb";
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
   attribute VITAL_LEVEL0 of stratixiii_lcell_comb : entity is TRUE;
end stratixiii_lcell_comb;
        
architecture vital_lcell_comb of stratixiii_lcell_comb is
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


---------------------------------------------------------------------
--
-- Entity Name :  stratixiii_routing_wire
--
-- Description :  Stratix III Routing Wire VHDL simulation model
--
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_routing_wire is
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
   attribute VITAL_LEVEL0 of stratixiii_routing_wire : entity is TRUE;
end stratixiii_routing_wire;

ARCHITECTURE behave of stratixiii_routing_wire is
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
--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixiii_lvds_tx_reg
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
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_lvds_tx_reg is
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
    attribute VITAL_LEVEL0 of stratixiii_lvds_tx_reg : ENTITY is TRUE;
END stratixiii_lvds_tx_reg;

ARCHITECTURE vital_stratixiii_lvds_tx_reg of stratixiii_lvds_tx_reg is

    attribute VITAL_LEVEL0 of vital_stratixiii_lvds_tx_reg : architecture is TRUE;

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
                      HeaderMsg       => InstancePath & "/stratixiii_lvds_tx_reg",
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

end vital_stratixiii_lvds_tx_reg;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity name : stratixiii_lvds_tx_parallel_register
--
-- Description : Register for the 10 data input channels of the Stratix III
--               LVDS Tx
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;
USE std.textio.all;

ENTITY stratixiii_lvds_tx_parallel_register is
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

END stratixiii_lvds_tx_parallel_register;

ARCHITECTURE vital_tx_reg of stratixiii_lvds_tx_parallel_register is
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
                HeaderMsg       => InstancePath & "/stratixiii_lvds_tx_parallel_register",
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
-- Entity name : stratixiii_lvds_tx_out_block
--
-- Description : Negative-edge triggered register on the Tx output.
--               Also, optionally generates an identical/inverted output clock
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;
USE std.textio.all;

ENTITY stratixiii_lvds_tx_out_block is
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

END stratixiii_lvds_tx_out_block;

ARCHITECTURE vital_tx_out_block of stratixiii_lvds_tx_out_block is
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
-- Entity name : stratixiii_lvds_transmitter
--
-- Description : Timing simulation model for the Stratix III LVDS Tx WYSIWYG.
--               It instantiates the following sub-modules :
--               1) primitive DFFE
--               2) Stratix III_lvds_tx_parallel_register and
--               3) Stratix III_lvds_tx_out_block
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;
USE std.textio.all;
USE work.stratixiii_lvds_tx_parallel_register;
USE work.stratixiii_lvds_tx_out_block;
USE work.stratixiii_lvds_tx_reg;

ENTITY stratixiii_lvds_transmitter is
    GENERIC ( channel_width                    : integer := 10;
              bypass_serializer                : String  := "false";
              invert_clock                     : String  := "false";
              use_falling_clock_edge           : String  := "false";
              use_serial_data_input            : String  := "false";
              use_post_dpa_serial_data_input   : String  := "false";
              is_used_as_outclk              : String  := "false";      
              tx_output_path_delay_engineering_bits : Integer  := -1;   
              enable_dpaclk_to_lvdsout    : string := "off";    
              preemphasis_setting              : integer := 0;
              vod_setting                      : integer := 0;
              differential_drive               : integer := 0;
              lpm_type                         : string  := "stratixiii_lvds_transmitter";
              TimingChecksOn                   : Boolean := True;
              MsgOn                            : Boolean := DefGlitchMsgOn;
              XOn                              : Boolean := DefGlitchXOn;
              MsgOnChecks                      : Boolean := DefMsgOnChecks;
              XOnChecks                        : Boolean := DefXOnChecks;
              InstancePath                     : String := "*";
              tpd_clk0_dataout_posedge         : VitalDelayType01 := DefPropDelay01;
              tpd_clk0_dataout_negedge         : VitalDelayType01 := DefPropDelay01;
              tpd_serialdatain_dataout         : VitalDelayType01 := DefPropDelay01;
              tpd_dpaclkin_dataout             : VitalDelayType01 := DefPropDelay01;
              tpd_postdpaserialdatain_dataout  : VitalDelayType01 := DefPropDelay01;
              tipd_clk0                        : VitalDelayType01 := DefpropDelay01;
              tipd_enable0                     : VitalDelayType01 := DefpropDelay01;
              tipd_datain                      : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01);
              tipd_serialdatain                : VitalDelayType01 := DefpropDelay01;
              tipd_dpaclkin                    : VitalDelayType01 := DefpropDelay01; 
              tipd_postdpaserialdatain         : VitalDelayType01 := DefpropDelay01
            );

    PORT    ( clk0                     : in std_logic;
              enable0                  : in std_logic := '0';
              datain                   : in std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
              serialdatain             : in std_logic := '0';
              postdpaserialdatain      : in std_logic := '0';
              dpaclkin                  : in std_logic := '0';
              devclrn                  : in std_logic := '1';
              devpor                   : in std_logic := '1';
              dataout                  : out std_logic;
              serialfdbkout            : out std_logic
            );

end stratixiii_lvds_transmitter;

ARCHITECTURE vital_transmitter_atom of stratixiii_lvds_transmitter is

signal clk0_ipd : std_logic;
signal serialdatain_ipd : std_logic;
signal postdpaserialdatain_ipd : std_logic;
signal dpaclkin_ipd : std_logic;

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

COMPONENT stratixiii_lvds_tx_parallel_register
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

COMPONENT stratixiii_lvds_tx_out_block
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

COMPONENT stratixiii_lvds_tx_reg
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
        VitalWireDelay (dpaclkin_ipd, dpaclkin, tipd_dpaclkin);
        VitalWireDelay (postdpaserialdatain_ipd, postdpaserialdatain, tipd_postdpaserialdatain);
    end block;

    txload0_reg: stratixiii_lvds_tx_reg
             PORT MAP (d    => enable0,
                       clrn => vcc,
                       prn  => vcc,
                       ena  => vcc,
                       clk  => clk0_dly2,
                       q    => txload0
                      );

    input_reg: stratixiii_lvds_tx_parallel_register
             GENERIC MAP ( channel_width => channel_width)
             PORT MAP    ( clk => txload0,
                           enable => vcc,
                           datain => datain_dly,
                           dataout => input_data,
                           devclrn => devclrn,
                           devpor => devpor
                         );

    output_module: stratixiii_lvds_tx_out_block
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
            dpaclkin_ipd, 
            tmp_dataout
            )
    variable dataout_tmp : std_logic := '0';
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    begin
        if (serialdatain_ipd'event and use_serial_data_input = "true") then
            dataout_tmp := serialdatain_ipd;
        elsif (postdpaserialdatain_ipd'event and use_post_dpa_serial_data_input = "true") then
            dataout_tmp := postdpaserialdatain_ipd;
        elsif (dpaclkin_ipd'event and enable_dpaclk_to_lvdsout = "on") then
            dataout_tmp := dpaclkin_ipd;
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
     elsif (enable_dpaclk_to_lvdsout = "on") then    
            VitalPathDelay01 (                        
                OutSignal => dataout,                 
                OutSignalName => "DATAOUT",           
                OutTemp => dataout_tmp,                
                Paths => (0 => (dpaclkin_ipd'last_event, tpd_dpaclkin_dataout, TRUE)),     
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
--
--
--  STRATIXIII_RUBLOCK Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.stratixiii_atom_pack.all;

entity  stratixiii_rublock is
	generic
	(
		sim_init_config : string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_status : integer := 0;
		lpm_type : string := "stratixiii_rublock"
	);
	port 
	(
		clk	        : in std_logic; 
		shiftnld	: in std_logic; 
		captnupdt	: in std_logic; 
		regin		: in std_logic; 
		rsttimer	: in std_logic; 
		rconfig		: in std_logic; 
		regout		: out std_logic
	);

end stratixiii_rublock;

architecture architecture_rublock of stratixiii_rublock is

begin

end architecture_rublock;


----------------------------------------------------------------------------
-- Module Name     : stratixiii_ram_register
-- Description     : Register module for RAM inputs/outputs
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_ram_register IS

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

END stratixiii_ram_register;

ARCHITECTURE reg_arch OF stratixiii_ram_register IS

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
-- Module Name     : stratixiii_ram_pulse_generator
-- Description     : Generate pulse to initiate memory read/write operations
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_ram_pulse_generator IS
GENERIC (
    tipd_clk : VitalDelayType01 := (0.5 ns,0.5 ns);
    tipd_ena : VitalDelayType01 := DefPropDelay01;
    tpd_clk_pulse_posedge : VitalDelayType01 := DefPropDelay01
    );
PORT ( 
    clk,ena : IN STD_LOGIC;
 delaywrite : IN STD_LOGIC := '0';
    pulse,cycle : OUT STD_LOGIC
    );
ATTRIBUTE VITAL_Level0 OF stratixiii_ram_pulse_generator:ENTITY IS TRUE;
END stratixiii_ram_pulse_generator;

ARCHITECTURE pgen_arch OF stratixiii_ram_pulse_generator IS
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
         IF (delaywrite = '1') THEN
             state <= '1' AFTER 1 NS; -- delayed write
         ELSE
        state <= '1';
         END IF;
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
USE work.stratixiii_atom_pack.all;
USE work.stratixiii_ram_register;
USE work.stratixiii_ram_pulse_generator;

ENTITY stratixiii_ram_block IS
    GENERIC (
        -- -------- GLOBAL PARAMETERS ---------
        operation_mode                 :  STRING := "single_port";    
        mixed_port_feed_through_mode   :  STRING := "dont_care";    
        ram_block_type                 :  STRING := "auto";    
        logical_ram_name               :  STRING := "ram_name";    
        init_file                      :  STRING := "init_file.hex";    
        init_file_layout               :  STRING := "none";    
          enable_ecc               :  STRING := "false";
	  width_eccstatus          :  INTEGER := 3;
        data_interleave_width_in_bits  :  INTEGER := 1;    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        port_a_logical_ram_depth       :  INTEGER := 0;    
        port_a_logical_ram_width       :  INTEGER := 0;    
        port_a_first_address           :  INTEGER := 0;    
        port_a_last_address            :  INTEGER := 0;    
        port_a_first_bit_number        :  INTEGER := 0;    
        port_a_address_clear           :  STRING := "none";    
        port_a_data_out_clear          :  STRING := "none";    
        port_a_data_in_clock           :  STRING := "clock0";    
        port_a_address_clock           :  STRING := "clock0";    
        port_a_write_enable_clock      :  STRING := "clock0";    
         port_a_read_enable_clock     :  STRING := "clock0";           
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
        port_b_address_clear           :  STRING := "none";    
        port_b_data_out_clear          :  STRING := "none";    
        port_b_data_in_clock           :  STRING := "clock1";    
        port_b_address_clock           :  STRING := "clock1";    
         port_b_write_enable_clock: STRING := "clock1";    
         port_b_read_enable_clock: STRING := "clock1";    
        port_b_byte_enable_clock       :  STRING := "clock1";    
        port_b_data_out_clock          :  STRING := "none";    
        port_b_data_width              :  INTEGER := 1;    
        port_b_address_width           :  INTEGER := 1;    
        port_b_byte_enable_mask_width  :  INTEGER := 1;    
        
         port_a_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
         port_b_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";    
        power_up_uninitialized         :  STRING := "false";  
        port_b_byte_size : INTEGER := 0;
        port_a_byte_size : INTEGER := 0;  
        lpm_type                  : string := "stratixiii_ram_block";
        lpm_hint                  : string := "true";
         clk0_input_clock_enable  : STRING := "none"; -- ena0,ena2,none
         clk0_core_clock_enable   : STRING := "none"; -- ena0,ena2,none
         clk0_output_clock_enable : STRING := "none"; -- ena0,none
         clk1_input_clock_enable  : STRING := "none"; -- ena1,ena3,none
         clk1_core_clock_enable   : STRING := "none"; -- ena1,ena3,none
         clk1_output_clock_enable : STRING := "none"; -- ena1,none
	  clock_duty_cycle_dependence : STRING := "Auto";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
         mem_init2 : BIT_VECTOR := X"0";
         mem_init3 : BIT_VECTOR := X"0";
         mem_init4 : BIT_VECTOR := X"0";
          mem_init5 : BIT_VECTOR := X"0";
          mem_init6 : BIT_VECTOR := X"0";
          mem_init7 : BIT_VECTOR := X"0";
          mem_init8 : BIT_VECTOR := X"0";
          mem_init9 : BIT_VECTOR := X"0";
          mem_init10 : BIT_VECTOR := X"0";
          mem_init11 : BIT_VECTOR := X"0";
          mem_init12 : BIT_VECTOR := X"0";
          mem_init13 : BIT_VECTOR := X"0";
          mem_init14 : BIT_VECTOR := X"0";
          mem_init15 : BIT_VECTOR := X"0";
          mem_init16 : BIT_VECTOR := X"0";
          mem_init17 : BIT_VECTOR := X"0";
          mem_init18 : BIT_VECTOR := X"0";
          mem_init19 : BIT_VECTOR := X"0";
          mem_init20 : BIT_VECTOR := X"0";
          mem_init21 : BIT_VECTOR := X"0";
          mem_init22 : BIT_VECTOR := X"0";
          mem_init23 : BIT_VECTOR := X"0";
          mem_init24 : BIT_VECTOR := X"0";
          mem_init25 : BIT_VECTOR := X"0";
          mem_init26 : BIT_VECTOR := X"0";
          mem_init27 : BIT_VECTOR := X"0";
          mem_init28 : BIT_VECTOR := X"0";
          mem_init29 : BIT_VECTOR := X"0";
          mem_init30 : BIT_VECTOR := X"0";
          mem_init31 : BIT_VECTOR := X"0";
          mem_init32 : BIT_VECTOR := X"0";
          mem_init33 : BIT_VECTOR := X"0";
          mem_init34 : BIT_VECTOR := X"0";
          mem_init35 : BIT_VECTOR := X"0";
          mem_init36 : BIT_VECTOR := X"0";
          mem_init37 : BIT_VECTOR := X"0";
          mem_init38 : BIT_VECTOR := X"0";
          mem_init39 : BIT_VECTOR := X"0";
          mem_init40 : BIT_VECTOR := X"0";
          mem_init41 : BIT_VECTOR := X"0";
          mem_init42 : BIT_VECTOR := X"0";
          mem_init43 : BIT_VECTOR := X"0";
          mem_init44 : BIT_VECTOR := X"0";
          mem_init45 : BIT_VECTOR := X"0";
          mem_init46 : BIT_VECTOR := X"0";
          mem_init47 : BIT_VECTOR := X"0";
          mem_init48 : BIT_VECTOR := X"0";
          mem_init49 : BIT_VECTOR := X"0";
          mem_init50 : BIT_VECTOR := X"0";
          mem_init51 : BIT_VECTOR := X"0";
          mem_init52 : BIT_VECTOR := X"0";
          mem_init53 : BIT_VECTOR := X"0";
          mem_init54 : BIT_VECTOR := X"0";
          mem_init55 : BIT_VECTOR := X"0";
          mem_init56 : BIT_VECTOR := X"0";
          mem_init57 : BIT_VECTOR := X"0";
          mem_init58 : BIT_VECTOR := X"0";
          mem_init59 : BIT_VECTOR := X"0";
          mem_init60 : BIT_VECTOR := X"0";
          mem_init61 : BIT_VECTOR := X"0";
          mem_init62 : BIT_VECTOR := X"0";
          mem_init63 : BIT_VECTOR := X"0";
          mem_init64 : BIT_VECTOR := X"0";
          mem_init65 : BIT_VECTOR := X"0";
          mem_init66 : BIT_VECTOR := X"0";
          mem_init67 : BIT_VECTOR := X"0";
          mem_init68 : BIT_VECTOR := X"0";
          mem_init69 : BIT_VECTOR := X"0";
          mem_init70 : BIT_VECTOR := X"0";
          mem_init71 : BIT_VECTOR := X"0";
        connectivity_checking     : string := "off"
        );    
    -- -------- PORT DECLARATIONS ---------
    PORT (
        portadatain             : IN STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portaaddr               : IN STD_LOGIC_VECTOR(port_a_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portawe                 : IN STD_LOGIC := '0';   
         portare                 : IN STD_LOGIC := '1';   
        portbdatain             : IN STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portbaddr               : IN STD_LOGIC_VECTOR(port_b_address_width - 1 DOWNTO 0) := (OTHERS => '0');   
         portbwe                 : IN STD_LOGIC := '0';   
         portbre                 : IN STD_LOGIC := '1';   
        clk0                    : IN STD_LOGIC := '0';   
        clk1                    : IN STD_LOGIC := '0';   
        ena0                    : IN STD_LOGIC := '1';   
        ena1                    : IN STD_LOGIC := '1';   
         ena2                    : IN STD_LOGIC := '1';   
         ena3                    : IN STD_LOGIC := '1';   
        clr0                    : IN STD_LOGIC := '0';   
        clr1                    : IN STD_LOGIC := '0';   
        portabyteenamasks       : IN STD_LOGIC_VECTOR(port_a_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        portbbyteenamasks       : IN STD_LOGIC_VECTOR(port_b_byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        devclrn                 : IN STD_LOGIC := '1';   
        devpor                  : IN STD_LOGIC := '1';   
         portaaddrstall : IN STD_LOGIC := '0';
         portbaddrstall : IN STD_LOGIC := '0';
          eccstatus : OUT STD_LOGIC_VECTOR(width_eccstatus - 1 DOWNTO 0) := (OTHERS => '0');
          dftout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );

END stratixiii_ram_block;

ARCHITECTURE block_arch OF stratixiii_ram_block IS

COMPONENT stratixiii_ram_pulse_generator
    PORT (
          clk                     : IN  STD_LOGIC;
          ena                     : IN  STD_LOGIC;
           delaywrite          : IN STD_LOGIC := '0';
          pulse                   : OUT STD_LOGIC;
          cycle                   : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT stratixiii_ram_register
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

    CONSTANT ram_type : BOOLEAN := FALSE;
                               
TYPE bool_to_std_logic_map IS ARRAY(TRUE DOWNTO FALSE) OF STD_LOGIC;
CONSTANT bool_to_std_logic : bool_to_std_logic_map := ('1','0');

 -- Hardware write modes

 CONSTANT dual_clock : BOOLEAN := (operation_mode = "dual_port" OR
                                   operation_mode = "bidir_dual_port") AND
                                  (port_b_address_clock = "clock1");
 CONSTANT both_new_data_same_port : BOOLEAN := (
                                         ((port_a_read_during_write_mode = "new_data_no_nbe_read") OR
                                          (port_a_read_during_write_mode = "dont_care")) AND
                                         ((port_b_read_during_write_mode = "new_data_no_nbe_read") OR
                                          (port_b_read_during_write_mode = "dont_care"))
                                     ); 
 SIGNAL hw_write_mode_a : STRING(3 DOWNTO 1);                                    
 SIGNAL hw_write_mode_b : STRING(3 DOWNTO 1);
  
 SIGNAL delay_write_pulse_a : STD_LOGIC ;
 SIGNAL delay_write_pulse_b : STD_LOGIC ;
 
 CONSTANT be_mask_write_a  : BOOLEAN := (port_a_read_during_write_mode = "new_data_with_nbe_read");
 CONSTANT be_mask_write_b  : BOOLEAN := (port_b_read_during_write_mode = "new_data_with_nbe_read");
 
 CONSTANT old_data_write_a : BOOLEAN := (port_a_read_during_write_mode = "old_data");
 CONSTANT old_data_write_b : BOOLEAN := (port_b_read_during_write_mode = "old_data");
 
 SIGNAL read_before_write_a : BOOLEAN;
 SIGNAL read_before_write_b : BOOLEAN;
                              
-- -------- internal signals ---------
-- clock / clock enable
SIGNAL clk_a_in,clk_b_in : STD_LOGIC;
SIGNAL clk_a_byteena,clk_b_byteena : STD_LOGIC;
SIGNAL clk_a_out,clk_b_out : STD_LOGIC;
SIGNAL clkena_a_out,clkena_b_out : STD_LOGIC;
 SIGNAL clkena_out_c0, clkena_out_c1 : STD_LOGIC;
SIGNAL write_cycle_a,write_cycle_b : STD_LOGIC;

 SIGNAL clk_a_rena, clk_a_wena : STD_LOGIC;
 SIGNAL clk_a_core : STD_LOGIC;

 SIGNAL clk_b_rena, clk_b_wena : STD_LOGIC;
 SIGNAL clk_b_core : STD_LOGIC;

SUBTYPE one_bit_bus_type IS STD_LOGIC_VECTOR(0 DOWNTO 0);

-- asynch clear
TYPE   clear_mode_type IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF BOOLEAN;
TYPE   clear_vec_type  IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF STD_LOGIC;
SIGNAL datain_a_clr,datain_b_clr   :  STD_LOGIC;
SIGNAL dataout_a_clr,dataout_b_clr :  STD_LOGIC;
 SIGNAL dataout_a_clr_reg, dataout_b_clr_reg : STD_LOGIC;
 SIGNAL dataout_a_clr_reg_in, dataout_b_clr_reg_in : one_bit_bus_type;
 SIGNAL dataout_a_clr_reg_out, dataout_b_clr_reg_out : one_bit_bus_type;


SIGNAL addr_a_clr,addr_b_clr       :  STD_LOGIC;
SIGNAL byteena_a_clr,byteena_b_clr :  STD_LOGIC;
 SIGNAL we_a_clr,re_a_clr,we_b_clr,re_b_clr : STD_LOGIC;
SIGNAL datain_a_clr_in,datain_b_clr_in :  STD_LOGIC;
SIGNAL addr_a_clr_in,addr_b_clr_in     :  STD_LOGIC;
SIGNAL byteena_a_clr_in,byteena_b_clr_in  :  STD_LOGIC;
 SIGNAL we_a_clr_in,re_a_clr_in,we_b_clr_in,re_b_clr_in : STD_LOGIC;
SIGNAL mem_invalidate,mem_invalidate_loc,read_latch_invalidate : clear_mode_type;
SIGNAL clear_asserted_during_write :  clear_vec_type;


-- port A registers
SIGNAL we_a_reg                 :  STD_LOGIC;
 SIGNAL re_a_reg                : STD_LOGIC;
SIGNAL we_a_reg_in,we_a_reg_out :  one_bit_bus_type;
 SIGNAL re_a_reg_in,re_a_reg_out : one_bit_bus_type;
SIGNAL addr_a_reg               :  STD_LOGIC_VECTOR(port_a_address_width - 1 DOWNTO 0);
SIGNAL datain_a_reg             :  STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);
SIGNAL dataout_a_reg            :  STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);
SIGNAL dataout_a                :  STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);
SIGNAL byteena_a_reg            :  STD_LOGIC_VECTOR(port_a_byte_enable_mask_width- 1 DOWNTO 0);
-- port B registers
 SIGNAL we_b_reg, re_b_reg       : STD_LOGIC;
 SIGNAL re_b_reg_in,re_b_reg_out,we_b_reg_in,we_b_reg_out : one_bit_bus_type;
SIGNAL addr_b_reg               :  STD_LOGIC_VECTOR(port_b_address_width - 1 DOWNTO 0);
SIGNAL datain_b_reg             :  STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0);
SIGNAL dataout_b_reg            :  STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0);
SIGNAL dataout_b                :  STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0);
SIGNAL byteena_b_reg            :  STD_LOGIC_VECTOR(port_b_byte_enable_mask_width- 1 DOWNTO 0);
-- pulses
TYPE   pulse_vec IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF STD_LOGIC;
SIGNAL write_pulse,read_pulse,read_pulse_feedthru : pulse_vec; 
 SIGNAL rw_pulse : pulse_vec;
SIGNAL wpgen_a_clk,wpgen_a_clkena,wpgen_b_clk,wpgen_b_clkena : STD_LOGIC;
SIGNAL rpgen_a_clkena,rpgen_b_clkena : STD_LOGIC;
SIGNAL ftpgen_a_clkena,ftpgen_b_clkena : STD_LOGIC;
 SIGNAL rwpgen_a_clkena,rwpgen_b_clkena : STD_LOGIC;
-- registered address
SIGNAL addr_prime_reg,addr_sec_reg :  INTEGER;   
-- input/output
SIGNAL datain_prime_reg,dataout_prime     :  STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);   
SIGNAL datain_sec_reg,dataout_sec         :  STD_LOGIC_VECTOR(data_unit_width - 1 DOWNTO 0);
--  overlapping location write
SIGNAL dual_write : BOOLEAN; 
 --  byte enable mask write
 TYPE be_mask_write_vec IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF BOOLEAN;
 SIGNAL be_mask_write : be_mask_write_vec; 
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
 SIGNAL active_a_core_in_vec,active_b_core_in_vec,active_a_core_out,active_b_core_out : one_bit_bus_type;
SIGNAL active_a_in,active_b_in   : STD_LOGIC;
SIGNAL active_write_a :  BOOLEAN;
SIGNAL active_write_b :  BOOLEAN;
 SIGNAL active_b_in_c0,active_b_core_in_c0,active_b_in_c1,active_b_core_in_c1 : STD_LOGIC;
 SIGNAL active_a_core_in,active_b_core_in : STD_LOGIC;
 SIGNAL active_a_core, active_b_core : BOOLEAN;
SIGNAL wire_vcc : STD_LOGIC := '1';
SIGNAL wire_gnd : STD_LOGIC := '0';






BEGIN
    -- memory initialization
    init_mem <= TRUE;
     -- hardware write modes
     hw_write_mode_a <= "R+W" WHEN ((port_a_read_during_write_mode = "old_data") OR
                                                      (port_a_read_during_write_mode = "new_data_with_nbe_read")) ELSE
                                          " FW"  WHEN (dual_clock OR (
                                                              mixed_port_feed_through_mode = "dont_care" AND 
                                                              both_new_data_same_port
                                                              )) ELSE
                                          " DW";
                                          
     hw_write_mode_b <= "R+W" WHEN ((port_b_read_during_write_mode = "old_data") OR
                                                      (port_b_read_during_write_mode = "new_data_with_nbe_read")) ELSE
                                          " FW"  WHEN (dual_clock OR (
                                                              mixed_port_feed_through_mode = "dont_care" AND 
                                                              both_new_data_same_port
                                                              )) ELSE
                                          " DW";
      delay_write_pulse_a <= '0' WHEN (mode_is_dp AND mixed_port_feed_through_mode = "dont_care") ELSE '1' WHEN (hw_write_mode_a /= " FW") ELSE '0';
     delay_write_pulse_b <= '1' WHEN (hw_write_mode_b /= " FW") ELSE '0' ;
     read_before_write_a <= (hw_write_mode_a = "R+W");
     read_before_write_b <= (hw_write_mode_b = "R+W");
    
    -- -------- core logic ---------------
    clk_a_in      <= clk0;
     clk_a_wena <= '0' WHEN (port_a_write_enable_clock = "none") ELSE clk_a_in;
     clk_a_rena <= '0' WHEN (port_a_read_enable_clock = "none") ELSE clk_a_in;

    clk_a_byteena <= '0'   WHEN (port_a_byte_enable_clock = "none" OR port_a_byte_enable_clock = "UNUSED") ELSE clk_a_in;
    clk_a_out     <= '0'   WHEN (port_a_data_out_clock = "none" OR port_a_data_out_clock = "UNUSED")    ELSE 
                      clk0 WHEN (port_a_data_out_clock = "clock0")  ELSE clk1;
                      
     clk_b_in      <=  clk0 WHEN (port_b_address_clock = "clock0") ELSE clk1;
    clk_b_byteena <=  '0'  WHEN (port_b_byte_enable_clock = "none" OR port_b_byte_enable_clock = "UNUSED") ELSE 
                      clk0 WHEN (port_b_byte_enable_clock = "clock0") ELSE clk1;
     clk_b_wena <= '0'  WHEN (port_b_write_enable_clock = "none") ELSE
                   clk0 WHEN (port_b_write_enable_clock = "clock0") ELSE
                   clk1;
     clk_b_rena <= '0'  WHEN (port_b_read_enable_clock = "none") ELSE
                   clk0 WHEN (port_b_read_enable_clock = "clock0") ELSE
                   clk1;
    clk_b_out     <=  '0'  WHEN (port_b_data_out_clock = "none" OR port_b_data_out_clock = "UNUSED")    ELSE 
                      clk0 WHEN (port_b_data_out_clock = "clock0")  ELSE clk1;

    addr_a_clr_in <=  '0'  WHEN (port_a_address_clear = "none" OR port_a_address_clear = "UNUSED") ELSE clr0;
    addr_b_clr_in <=  '0'  WHEN (port_b_address_clear = "none" OR port_b_address_clear = "UNUSED") ELSE 
                      clr0 WHEN (port_b_address_clear = "clear0") ELSE clr1;

     datain_a_clr_in <= '0';
     datain_b_clr_in <= '0';
    
      dataout_a_clr   <= '0' WHEN (port_a_data_out_clear = "none" OR port_a_data_out_clear = "UNUSED")   ELSE 
                       clr0 WHEN (port_a_data_out_clear = "clear0") ELSE clr1;
    
      dataout_b_clr   <= '0' WHEN (port_b_data_out_clear = "none" OR port_b_data_out_clear = "UNUSED")   ELSE 
                       clr0 WHEN (port_b_data_out_clear = "clear0") ELSE clr1;
                      
     byteena_a_clr_in <= '0';
     byteena_b_clr_in <= '0';
     we_a_clr_in      <= '0';
     re_a_clr_in      <= '0';
     we_b_clr_in    <= '0';
     re_b_clr_in    <= '0';
                
     active_a_in <= '1'  WHEN (clk0_input_clock_enable = "none") ELSE
                    ena0 WHEN (clk0_input_clock_enable = "ena0") ELSE
                    ena2;
     active_a_core_in <= '1'  WHEN (clk0_core_clock_enable = "none") ELSE
                         ena0 WHEN (clk0_core_clock_enable = "ena0") ELSE
                         ena2;
    
     be_mask_write(primary_port_is_a) <= be_mask_write_a;
     be_mask_write(primary_port_is_b) <= be_mask_write_b;
    
     active_b_in_c0 <= '1'  WHEN (clk0_input_clock_enable = "none") ELSE 
                       ena0 WHEN (clk0_input_clock_enable = "ena0") ELSE
                       ena2;
     active_b_in_c1 <= '1'  WHEN (clk1_input_clock_enable = "none") ELSE 
                       ena1 WHEN (clk1_input_clock_enable = "ena1") ELSE
                       ena3;
     active_b_in <= active_b_in_c0 WHEN (port_b_address_clock = "clock0")  ELSE active_b_in_c1;
     active_b_core_in_c0 <= '1'  WHEN (clk0_core_clock_enable = "none") ELSE 
                            ena0 WHEN (clk0_core_clock_enable = "ena0") ELSE
                            ena2;
     active_b_core_in_c1 <= '1'  WHEN (clk1_core_clock_enable = "none") ELSE 
                            ena1 WHEN (clk1_core_clock_enable = "ena1") ELSE
                            ena3;
     active_b_core_in <= active_b_core_in_c0 WHEN (port_b_address_clock = "clock0")  ELSE active_b_core_in_c1;
 
     active_write_a <= (byteena_a_reg /= bytes_a_disabled);
    
     active_write_b <= (byteena_b_reg /= bytes_b_disabled);

     -- Store core clock enable value for delayed write
     -- port A core active
     active_a_core_in_vec(0) <= active_a_core_in;
     active_core_port_a : stratixiii_ram_register
         GENERIC MAP ( width => 1 )
         PORT MAP (
             d => active_a_core_in_vec,
             clk => clk_a_in,
             aclr => wire_gnd,
             devclrn => wire_vcc,devpor => wire_vcc,
             ena => wire_vcc,
             stall => wire_gnd,
             q => active_a_core_out
         );
     active_a_core <= (active_a_core_out(0) = '1');
    
     -- port B core active
     active_b_core_in_vec(0) <= active_b_core_in;
     active_core_port_b : stratixiii_ram_register
         GENERIC MAP ( width => 1 )
         PORT MAP (
             d => active_b_core_in_vec,
             clk => clk_b_in,
             aclr => wire_gnd,
             devclrn => wire_vcc,devpor => wire_vcc,
             ena => wire_vcc,
             stall => wire_gnd,
             q => active_b_core_out
         );
     active_b_core <= (active_b_core_out(0) = '1');
    


    -- ------ A input registers
    -- write enable
    we_a_reg_in(0) <= '0' WHEN mode_is_rom ELSE portawe;
    we_a_register : stratixiii_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => we_a_reg_in,
             clk => clk_a_wena,
            aclr => we_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
              ena => active_a_core_in,
            q   => we_a_reg_out,
            aclrout => we_a_clr
        );
    we_a_reg <= we_a_reg_out(0);
     -- read enable
     re_a_reg_in(0) <= portare;
     re_a_register : stratixiii_ram_register
         GENERIC MAP ( width => 1 )
         PORT MAP (
             d => re_a_reg_in,
             clk => clk_a_rena,
             aclr => re_a_clr_in,
             devclrn => devclrn,
             devpor => devpor,
             stall => wire_gnd,
              ena => active_a_core_in,
             q   => re_a_reg_out,
             aclrout => re_a_clr
         );
     re_a_reg <= re_a_reg_out(0);
    
    -- address
    addr_a_register : stratixiii_ram_register
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
    datain_a_register : stratixiii_ram_register
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
    byteena_a_register : stratixiii_ram_register
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
    
     -- read enable
     re_b_reg_in(0) <= portbre;
     re_b_register : stratixiii_ram_register
         GENERIC MAP (
             width  => 1
            )
         PORT MAP (
             d => re_b_reg_in,
             clk => clk_b_in,
             aclr => re_b_clr_in,
             devclrn => devclrn,
             devpor => devpor,
             stall => wire_gnd,
              ena => active_b_core_in,
             q   => re_b_reg_out,
             aclrout => re_b_clr
         );
     re_b_reg <= re_b_reg_out(0);
    
     -- write enable
     we_b_reg_in(0) <= portbwe;
     we_b_register : stratixiii_ram_register
         GENERIC MAP (
             width  => 1
            )
         PORT MAP (
             d => we_b_reg_in,
             clk => clk_b_in,
             aclr => we_b_clr_in,
             devclrn => devclrn,
             devpor => devpor,
             stall => wire_gnd,
              ena => active_b_core_in,
             q   => we_b_reg_out,
             aclrout => we_b_clr
         );
     we_b_reg <= we_b_reg_out(0);
    
    -- address
    addr_b_register : stratixiii_ram_register
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
    datain_b_register : stratixiii_ram_register
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
    byteena_b_register : stratixiii_ram_register
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
     wpgen_a_clk <= clk_a_in;
     wpgen_a_clkena <= '1' WHEN (active_a_core AND active_write_a AND (we_a_reg = '1')) ELSE '0';
    
    wpgen_a : stratixiii_ram_pulse_generator 
        PORT MAP (
            clk => wpgen_a_clk,
            ena => wpgen_a_clkena,
    delaywrite => delay_write_pulse_a,
            pulse => write_pulse(primary_port_is_a),
            cycle => write_cycle_a
        );
        
     wpgen_b_clk <= clk_b_in;
     wpgen_b_clkena <= '1' WHEN (active_b_core AND active_write_b AND mode_is_bdp AND (we_b_reg = '1')) ELSE '0';
    
    
    wpgen_b : stratixiii_ram_pulse_generator
        PORT MAP (
            clk => wpgen_b_clk,
            ena => wpgen_b_clkena,
    delaywrite => delay_write_pulse_b,
            pulse => write_pulse(primary_port_is_b),
            cycle => write_cycle_b
            );
            
    -- Read  pulse generation
      rpgen_a_clkena <= '1' WHEN (active_a_core AND (re_a_reg = '1') AND (we_a_reg = '0')) ELSE '0';
    
    rpgen_a : stratixiii_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => rpgen_a_clkena,
             cycle => clk_a_core,
            pulse => read_pulse(primary_port_is_a)
        );
      rpgen_b_clkena <= '1' WHEN ((mode_is_dp OR mode_is_bdp) AND active_b_core AND (re_b_reg = '1') AND (we_b_reg = '0')) ELSE '0'; 
    rpgen_b : stratixiii_ram_pulse_generator
        PORT MAP (
            clk => clk_b_in,
            ena => rpgen_b_clkena,
             cycle => clk_b_core,
            pulse => read_pulse(primary_port_is_b)
        );
    
     -- Read-during-Write pulse generation
      rwpgen_a_clkena <= '1' WHEN (active_a_core AND (re_a_reg = '1') AND (we_a_reg = '1') AND read_before_write_a) ELSE '0';
     rwpgen_a : stratixiii_ram_pulse_generator
         PORT MAP (
             clk => clk_a_in,
             ena => rwpgen_a_clkena,
             pulse => rw_pulse(primary_port_is_a)
         );
    
      rwpgen_b_clkena <= '1' WHEN (active_b_core AND mode_is_bdp AND (re_b_reg = '1') AND (we_b_reg = '1') AND read_before_write_b) ELSE '0';
     rwpgen_b : stratixiii_ram_pulse_generator
         PORT MAP (
             clk => clk_b_in,
             ena => rwpgen_b_clkena,
             pulse => rw_pulse(primary_port_is_b)
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
                       rw_pulse,
                      mem_invalidate,mem_invalidate_loc,read_latch_invalidate)
    -- mem init
    TYPE rw_type IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF BOOLEAN;
    VARIABLE addr_range_init,row,col,index :  INTEGER;
    VARIABLE mem_init_std :  STD_LOGIC_VECTOR((port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1 DOWNTO 0);
    VARIABLE mem_init  :  bit_vector(mem_init71'length + mem_init70'length + mem_init69'length + mem_init68'length + mem_init67'length + mem_init66'length +
                mem_init65'length + mem_init64'length + mem_init63'length + mem_init62'length + mem_init61'length +
                mem_init60'length + mem_init59'length + mem_init58'length + mem_init57'length + mem_init56'length +
                mem_init55'length + mem_init54'length + mem_init53'length + mem_init52'length + mem_init51'length +
                mem_init50'length + mem_init49'length + mem_init48'length + mem_init47'length + mem_init46'length +
                mem_init45'length + mem_init44'length + mem_init43'length + mem_init42'length + mem_init41'length +
                mem_init40'length + mem_init39'length + mem_init38'length + mem_init37'length + mem_init36'length +
                mem_init35'length + mem_init34'length + mem_init33'length + mem_init32'length + mem_init31'length +
                mem_init30'length + mem_init29'length + mem_init28'length + mem_init27'length + mem_init26'length +
                mem_init25'length + mem_init24'length + mem_init23'length + mem_init22'length + mem_init21'length +
                mem_init20'length + mem_init19'length + mem_init18'length + mem_init17'length + mem_init16'length +
                mem_init15'length + mem_init14'length + mem_init13'length + mem_init12'length + mem_init11'length +
                mem_init10'length + mem_init9'length + mem_init8'length + mem_init7'length + mem_init6'length +
                mem_init5'length + mem_init4'length + mem_init3'length + mem_init2'length + mem_init1'length +
                mem_init0'length - 1 DOWNTO 0);

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
                  mem_init := mem_init71 & mem_init70 & mem_init69 & mem_init68 & mem_init67 & mem_init66 &
                            mem_init65 & mem_init64 & mem_init63 & mem_init62 & mem_init61 &
                            mem_init60 & mem_init59 & mem_init58 & mem_init57 & mem_init56 &
                            mem_init55 & mem_init54 & mem_init53 & mem_init52 & mem_init51 &
                            mem_init50 & mem_init49 & mem_init48 & mem_init47 & mem_init46 &
                            mem_init45 & mem_init44 & mem_init43 & mem_init42 & mem_init41 &
                            mem_init40 & mem_init39 & mem_init38 & mem_init37 & mem_init36 &
                            mem_init35 & mem_init34 & mem_init33 & mem_init32 & mem_init31 &
                            mem_init30 & mem_init29 & mem_init28 & mem_init27 & mem_init26 &
                            mem_init25 & mem_init24 & mem_init23 & mem_init22 & mem_init21 &
                            mem_init20 & mem_init19 & mem_init18 & mem_init17 & mem_init16 &
                            mem_init15 & mem_init14 & mem_init13 & mem_init12 & mem_init11 &
                            mem_init10 & mem_init9  & mem_init8  & mem_init7  & mem_init6  &
                            mem_init5  & mem_init4  & mem_init3  & mem_init2  & mem_init1  &
                            mem_init0;
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
         -- Read before Write stage 1 : read data from memory
         -- Read before Write stage 2 : send data to output
         IF (rw_pulse(primary)'EVENT) THEN 
             IF (rw_pulse(primary) = '1') THEN
                 read_latch.prime <=  mem(addr_prime_reg);
             ELSE
                 IF (be_mask_write(primary)) THEN
                     FOR i IN 0 TO data_width - 1 LOOP
    	                    IF (mask_vector.prime(normal)(i) = 'X') THEN
    	                        row_prime := i / data_unit_width; col_prime := i mod data_unit_width;
    	                        dataout_prime(i) <= read_latch.prime(row_prime)(col_prime);
    	                    END IF;                       
       	             END LOOP;
   	             ELSE
   	                 FOR i IN 0 TO data_width - 1 LOOP
    	                    row_prime := i / data_unit_width; col_prime := i mod data_unit_width;
    	                    dataout_prime(i) <= read_latch.prime(row_prime)(col_prime);                      
       	             END LOOP;
                 END IF;
             END IF;
         END IF;
         IF (rw_pulse(secondary)'EVENT) THEN
             IF (rw_pulse(secondary) = '1') THEN
                 read_latch.sec <= mem(row_sec)(col_sec);
             ELSE
                 IF (be_mask_write(secondary)) THEN
                     FOR i IN 0 TO data_unit_width - 1 LOOP
    	                    IF (mask_vector.sec(normal)(i) = 'X') THEN
    	                        dataout_sec(i) <= read_latch.sec(i);
    	                    END IF;  
    	                END LOOP;
                 ELSE
                     dataout_sec <= read_latch.sec;
                 END IF;
             END IF;
         END IF;
        
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
         IF (be_mask_write(primary)) THEN
             FOR i IN 0 TO data_width - 1 LOOP
    	            IF (mask_vector.prime(normal)(i) = '0') THEN
    	                dataout_prime(i) <= datain_prime_reg(i);
    	            END IF;                       
       	     END LOOP;    
         ELSE
             dataout_prime <= datain_prime_reg XOR mask_vector.prime(normal);
         END IF;
        END IF;
        
        IF (read_pulse_feedthru(secondary)'EVENT AND read_pulse_feedthru(secondary) = '0') THEN
         IF (be_mask_write(secondary)) THEN
             FOR i IN 0 TO data_unit_width - 1 LOOP
    	            IF (mask_vector.sec(normal)(i) = '0') THEN
    	                dataout_sec(i) <= datain_sec_reg(i);
    	            END IF;                       
       	     END LOOP;    
         ELSE
             dataout_sec <= datain_sec_reg XOR mask_vector.sec(normal);
         END IF;
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
    ftpgen_a_clkena <= '1' WHEN (active_a_core AND (NOT mode_is_dp) AND (NOT old_data_write_a) AND (we_a_reg = '1') AND (re_a_reg = '1')) ELSE '0';
    ftpgen_a : stratixiii_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => ftpgen_a_clkena,
            pulse => read_pulse_feedthru(primary_port_is_a)
        );
   ftpgen_b_clkena <= '1' WHEN (active_b_core AND mode_is_bdp AND (NOT old_data_write_b) AND (we_b_reg = '1') AND (re_b_reg = '1')) ELSE '0';

    ftpgen_b : stratixiii_ram_pulse_generator
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
           ELSIF (active_a_core AND re_a_reg = '1') THEN
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
    
    clear_b : PROCESS(addr_b_clr,we_b_clr,datain_b_clr)
    BEGIN
        IF (addr_b_clr'EVENT AND addr_b_clr = '1') THEN
            clear_asserted_during_write(primary_port_is_b) <= write_pulse(primary_port_is_b);
          IF (mode_is_bdp AND active_write_b AND (write_cycle_b = '1') AND (we_b_reg = '1')) THEN   
                mem_invalidate(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
          ELSIF ((mode_is_dp OR mode_is_bdp) AND active_b_core AND re_b_reg = '1') THEN
                read_latch_invalidate(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
            END IF;
        END IF;
         IF ((we_b_clr'EVENT AND we_b_clr = '1') OR (datain_b_clr'EVENT AND datain_b_clr = '1')) THEN
            clear_asserted_during_write(primary_port_is_b) <= write_pulse(primary_port_is_b);
             IF (mode_is_bdp AND active_write_b AND (write_cycle_b = '1') AND (we_b_reg = '1')) THEN
                mem_invalidate_loc(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
                read_latch_invalidate(primary_port_is_b) <= TRUE,FALSE AFTER 0.5 ns;
            END IF;
        END IF;
    END PROCESS clear_b;
      -- Clear mux registers (Latch Clear)
      -- Port A output register clear
      dataout_a_clr_reg_in(0) <= dataout_a_clr;
      aclr_a_mux_register : stratixiii_ram_register
          GENERIC MAP ( width => 1 )
          PORT MAP (
             d => dataout_a_clr_reg_in,
             clk => clk_a_core,
             aclr => wire_gnd,
             devclrn => devclrn,
             devpor => devpor,
             stall => wire_gnd,
             ena => wire_vcc,
             q   => dataout_a_clr_reg_out
         );
      dataout_a_clr_reg <= dataout_a_clr_reg_out(0);
    
      -- Port B output register clear
      dataout_b_clr_reg_in(0) <= dataout_b_clr;
      aclr_b_mux_register : stratixiii_ram_register
         GENERIC MAP ( width => 1 )
         PORT MAP (
             d => dataout_b_clr_reg_in,
             clk => clk_b_core,
             aclr => wire_gnd,
             devclrn => devclrn,
             devpor => devpor,
             stall => wire_gnd,
             ena => wire_vcc,
             q   => dataout_b_clr_reg_out
         );
      dataout_b_clr_reg <= dataout_b_clr_reg_out(0);
    
    
    
    -- ------ Output registers
    
    
     clkena_out_c0 <= '1'  WHEN (clk0_output_clock_enable = "none") ELSE ena0;
     clkena_out_c1 <= '1'  WHEN (clk1_output_clock_enable = "none") ELSE ena1;
     clkena_a_out    <= clkena_out_c0 WHEN (port_a_data_out_clock = "clock0") ELSE clkena_out_c1;
     clkena_b_out    <= clkena_out_c0 WHEN (port_b_data_out_clock = "clock0") ELSE clkena_out_c1;
    
    dataout_a <= dataout_prime WHEN primary_port_is_a ELSE dataout_sec;
    dataout_b <= (OTHERS => 'U') WHEN (mode_is_rom OR mode_is_sp) ELSE 
                 dataout_prime   WHEN primary_port_is_b ELSE dataout_sec;
    
    dataout_a_register : stratixiii_ram_register
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
        
    dataout_b_register : stratixiii_ram_register
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
        
     portadataout <= dataout_a_reg WHEN (out_a_is_reg) ELSE
                     (OTHERS => '0') WHEN ((dataout_a_clr = '1') OR (dataout_a_clr_reg = '1')) ELSE
                     dataout_a;
     portbdataout <= dataout_b_reg WHEN (out_b_is_reg) ELSE
                     (OTHERS => '0') WHEN ((dataout_b_clr = '1') OR (dataout_b_clr_reg = '1')) ELSE
                     dataout_b;
    
  eccstatus <= (OTHERS => '0');
  dftout <= (OTHERS => '0');

END block_arch;


---------------------------------------------------------------------
--
-- Entity Name :  stratixiii_ff
-- 
-- Description :  Stratix III FF VHDL simulation model
--  
--
---------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;
use work.stratixiii_and1;

entity stratixiii_ff is
    generic (
             power_up : string := "low";
             x_on_violation : string := "on";
             lpm_type : string := "stratixiii_ff";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clrn_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_asdata_q: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_asdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_clrn : VitalDelayType01 := DefPropDelay01; 
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
          d : in std_logic := '0';
          clk : in std_logic := '0';
          clrn : in std_logic := '1';
          aload : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          asdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          q : out std_logic
         );
   attribute VITAL_LEVEL0 of stratixiii_ff : entity is TRUE;
end stratixiii_ff;
        
architecture vital_lcell_ff of stratixiii_ff is
   attribute VITAL_LEVEL0 of vital_lcell_ff : architecture is TRUE;
   signal clk_ipd : std_logic;
   signal d_ipd : std_logic;
   signal d_dly : std_logic;
   signal asdata_ipd : std_logic;
   signal asdata_dly : std_logic;
   signal asdata_dly1 : std_logic;
   signal sclr_ipd : std_logic;
   signal sload_ipd : std_logic;
   signal clrn_ipd : std_logic;
   signal aload_ipd : std_logic;
   signal ena_ipd : std_logic;

component stratixiii_and1
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

ddelaybuffer: stratixiii_and1
                   port map(IN1 => d_ipd,
                            Y => d_dly);

asdatadelaybuffer: stratixiii_and1
                   port map(IN1 => asdata_ipd,
                            Y => asdata_dly);

asdatadelaybuffer1: stratixiii_and1
                   port map(IN1 => asdata_dly,
                            Y => asdata_dly1);


    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (d_ipd, d, tipd_d);
        VitalWireDelay (asdata_ipd, asdata, tipd_asdata);
        VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
        VitalWireDelay (clrn_ipd, clrn, tipd_clrn);
        VitalWireDelay (aload_ipd, aload, tipd_aload);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process (clk_ipd, d_dly, asdata_dly1,
                           sclr_ipd, sload_ipd, clrn_ipd, aload_ipd,
                           ena_ipd, devclrn, devpor)
    
    variable Tviol_d_clk : std_ulogic := '0';
    variable Tviol_asdata_clk : std_ulogic := '0';
    variable Tviol_sclr_clk : std_ulogic := '0';
    variable Tviol_sload_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_asdata_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable q_VitalGlitchData : VitalGlitchDataType;
    
    variable iq : std_logic := '0';
    variable idata: std_logic := '0';
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';
    
    begin
      
        if (now = 0 ns) then
            if (power_up = "low") then
                iq := '0';
            elsif (power_up = "high") then
                iq := '1';
            end if;
        end if;

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_d_clk,
                TimingData      => TimingData_d_clk,
                TestSignal      => d,
                TestSignalName  => "DATAIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_d_clk_noedge_posedge,
                SetupLow        => tsetup_d_clk_noedge_posedge,
                HoldHigh        => thold_d_clk_noedge_posedge,
                HoldLow         => thold_d_clk_noedge_posedge,
                CheckEnabled    => TO_X01((NOT clrn_ipd) OR
                                          (sload_ipd) OR
                                          (sclr_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_asdata_clk,
                TimingData      => TimingData_asdata_clk,
                TestSignal      => asdata_ipd,
                TestSignalName  => "ASDATA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_asdata_clk_noedge_posedge,
                SetupLow        => tsetup_asdata_clk_noedge_posedge,
                HoldHigh        => thold_asdata_clk_noedge_posedge,
                HoldLow         => thold_asdata_clk_noedge_posedge,
                CheckEnabled    => TO_X01((NOT clrn_ipd) OR
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
                CheckEnabled    => TO_X01((NOT clrn_ipd) OR
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
                CheckEnabled    => TO_X01((NOT clrn_ipd) OR
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
                CheckEnabled    => TO_X01((NOT clrn_ipd) OR
                                          (NOT devpor) OR
                                          (NOT devclrn) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL_FF",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
    
        end if;
    
        violation := Tviol_d_clk or Tviol_asdata_clk or 
                     Tviol_sclr_clk or Tviol_sload_clk or Tviol_ena_clk;
    
    
        if ((devpor = '0') or (devclrn = '0') or (clrn_ipd = '0'))  then
            iq := '0';
        elsif (aload_ipd = '1') then
            iq := asdata_dly1;
        elsif (violation = 'X' and x_on_violation = "on") then
            iq := 'X';
        elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' then
            if (ena_ipd = '1') then
                if (sclr_ipd = '1') then
                    iq := '0';
                elsif (sload_ipd = '1') then
                    iq := asdata_dly1;
                else
                    iq := d_dly;
                end if;
            end if;
        end if;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => q,
            OutSignalName => "Q",
            OutTemp => iq,
            Paths => (0 => (clrn_ipd'last_event, tpd_clrn_q_posedge, TRUE),
                      1 => (aload_ipd'last_event, tpd_aload_q_posedge, TRUE),
                      2 => (asdata_ipd'last_event, tpd_asdata_q, TRUE),
                      3 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE)),
            GlitchData => q_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
    end process;

end vital_lcell_ff;	

--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Model for Stratix III CLKSELECT Atom
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  STRATIXIII_CLKSELECT Model
--
--

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

entity stratixiii_clkselect is
    generic (
             lpm_type : STRING := "stratixiii_clkselect";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
             tpd_inclk_outclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
             tpd_clkselect_outclk : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01)
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          outclk : out std_logic
          );    
   attribute VITAL_LEVEL0 of stratixiii_clkselect : entity is TRUE;
end stratixiii_clkselect;
        
architecture vital_clkselect of stratixiii_clkselect is
    attribute VITAL_LEVEL0 of vital_clkselect : architecture is TRUE;

    signal inclk_ipd : std_logic_vector(3 downto 0);
    signal clkselect_ipd : std_logic_vector(1 downto 0);
    signal clkmux_out : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (inclk_ipd(0), inclk(0), tipd_inclk(0));
        VitalWireDelay (inclk_ipd(1), inclk(1), tipd_inclk(1));
        VitalWireDelay (inclk_ipd(2), inclk(2), tipd_inclk(2));
        VitalWireDelay (inclk_ipd(3), inclk(3), tipd_inclk(3));
        VitalWireDelay (clkselect_ipd(0), clkselect(0), tipd_clkselect(0));
        VitalWireDelay (clkselect_ipd(1), clkselect(1), tipd_clkselect(1));
    end block;

    process(inclk_ipd, clkselect_ipd)
        variable outclk_VitalGlitchData : VitalGlitchDataType;
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

            ----------------------
            --  Path Delay Section
            ----------------------
            
            VitalPathDelay01
            (
                OutSignal => outclk,
                OutSignalName => "OUTCLOCK",
                OutTemp => tmp,
                Paths => (0 => (inclk_ipd(0)'last_event, tpd_inclk_outclk(0), TRUE),
                         1 => (inclk_ipd(1)'last_event, tpd_inclk_outclk(1), TRUE),
                         2 => (inclk_ipd(2)'last_event, tpd_inclk_outclk(2), TRUE),
                         3 => (inclk_ipd(3)'last_event, tpd_inclk_outclk(3), TRUE),
                         4 => (clkselect_ipd(0)'last_event, tpd_clkselect_outclk(0), TRUE),
                         5 => (clkselect_ipd(1)'last_event, tpd_clkselect_outclk(1), TRUE)),
                GlitchData => outclk_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn => MsgOn
            );
                
    end process;

end vital_clkselect;	

--/////////////////////////////////////////////////////////////////////////////
--
-- stratixiii_and2 Model
-- Description : Simulation model for a simple two input AND gate.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.stratixiii_atom_pack.all;

-- entity declaration --
entity stratixiii_and2 is
    generic(
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        InstancePath: STRING := "*";
        tpd_IN1_Y :  VitalDelayType01 := DefPropDelay01;
        tpd_IN2_Y :  VitalDelayType01 := DefPropDelay01;
        tipd_IN1  :  VitalDelayType01 := DefPropDelay01;
        tipd_IN2  :  VitalDelayType01 := DefPropDelay01);

    port(
        Y         :  out   STD_LOGIC;
        IN1       :  in    STD_LOGIC;
        IN2       :  in    STD_LOGIC);
    attribute VITAL_LEVEL0 of stratixiii_and2 : entity is TRUE;
end stratixiii_and2;

-- architecture body --

architecture AltVITAL of stratixiii_and2 is
    attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

    SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
    SIGNAL IN2_ipd    : STD_ULOGIC := 'U';

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
        VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
    end block;
    --------------------
    --  BEHAVIOR SECTION
    --------------------
    VITALBehavior : process (IN1_ipd, IN2_ipd)


    -- functionality results
    VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
    ALIAS Y_zd : STD_ULOGIC is Results(1);

    -- output glitch detection variables
    VARIABLE Y_GlitchData    : VitalGlitchDataType;

    begin

        -------------------------
        --  Functionality Section
        -------------------------
        Y_zd := TO_X01(IN1_ipd) AND TO_X01(IN2_ipd);

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => Y,
            OutSignalName => "Y",
            OutTemp => Y_zd,
            Paths => ( 0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                       1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE)),
            GlitchData => Y_GlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn        => MsgOn );

    end process;
end AltVITAL;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixiii_ena_reg
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
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_ena_reg is
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
   attribute VITAL_LEVEL0 of stratixiii_ena_reg : entity is TRUE;
end stratixiii_ena_reg;

ARCHITECTURE behave of stratixiii_ena_reg is
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
                HeaderMsg       => InstancePath & "/stratixiii_ena_reg",
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
--              VHDL Simulation Model for Stratix III CLKCTRL Atom
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  Stratix III_CLKCTRL Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;
use work.stratixiii_ena_reg;
use work.stratixiii_and2;

entity stratixiii_clkena is
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "stratixiii_clkena";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01
             );
    port (
          inclk : in std_logic := '0';
          ena : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          enaout : out std_logic;
          outclk : out std_logic
          );    
   attribute VITAL_LEVEL0 of stratixiii_clkena : entity is TRUE;
end stratixiii_clkena;
        
architecture vital_clkena of stratixiii_clkena is
    attribute VITAL_LEVEL0 of vital_clkena : architecture is TRUE;

    component stratixiii_and2
        generic(
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_IN1_Y  :  VitalDelayType01 := DefPropDelay01;
            tpd_IN2_Y  :  VitalDelayType01 := DefPropDelay01;
            tipd_IN1   :  VitalDelayType01 := DefPropDelay01;
            tipd_IN2   :  VitalDelayType01 := DefPropDelay01);
    
        port(
            Y          :  out   STD_LOGIC;
            IN1        :  in    STD_LOGIC;
            IN2        :  in    STD_LOGIC);
    end component;

    component stratixiii_ena_reg
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

    signal inclk_ipd : std_logic;
    signal inclk_inv : std_logic;
    signal ena_ipd : std_logic;
    signal cereg_clr : std_logic;
    signal cereg1_out : std_logic;
    signal cereg2_out : std_logic;
    signal ena_out : std_logic;
    signal vcc : std_logic := '1';
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (inclk_ipd, inclk, tipd_inclk);
    end block;

    inclk_inv <= NOT inclk_ipd;

    extena_reg1 : stratixiii_ena_reg
                  port map (
                            clk => inclk_inv,
                            ena => vcc,
                            d => ena_ipd, 
                            clrn => vcc,
                            prn => devpor,
                            q => cereg1_out 
                           );

    extena_reg2 : stratixiii_ena_reg
                  port map (
                            clk => inclk_inv,
                            ena => vcc,
                            d => cereg1_out, 
                            clrn => vcc,
                            prn => devpor,
                            q => cereg2_out 
                           );

    ena_out <= cereg1_out WHEN (ena_register_mode = "falling edge") ELSE 
               ena_ipd WHEN (ena_register_mode = "none") ELSE cereg2_out;

    outclk_and : stratixiii_and2
                 port map (
                           IN1 => inclk_ipd,
                           IN2 => ena_out,
                           Y => outclk
                          );
 
    enaout_and : stratixiii_and2
                 port map (
                           IN1 => vcc,
                           IN2 => ena_out,
                           Y => enaout
                          );
 

end vital_clkena;	



----------------------------------------------------------------------------
-- Module Name     : stratixiii_mlab_cell_pulse_generator
-- Description     : Generate pulse to initiate memory read/write operations
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_mlab_cell_pulse_generator IS
GENERIC (
    tipd_clk : VitalDelayType01 := (1 ps,1 ps);
    tipd_ena : VitalDelayType01 := DefPropDelay01;
    tpd_clk_pulse_posedge : VitalDelayType01 := DefPropDelay01
    );
PORT ( 
    clk,ena : IN STD_LOGIC;
    pulse,cycle : OUT STD_LOGIC
    );
ATTRIBUTE VITAL_Level0 OF stratixiii_mlab_cell_pulse_generator:ENTITY IS TRUE;
END stratixiii_mlab_cell_pulse_generator;

ARCHITECTURE pgen_arch OF stratixiii_mlab_cell_pulse_generator IS
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
USE work.stratixiii_atom_pack.all;
USE work.stratixiii_mlab_cell_pulse_generator;

ENTITY stratixiii_mlab_cell IS
    GENERIC (
        -- -------- GLOBAL PARAMETERS ---------
        logical_ram_name               :  STRING := "lutram";    
        init_file                      :  STRING := "UNUSED";    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        logical_ram_depth       :  INTEGER := 0;    
        logical_ram_width       :  INTEGER := 0;    
        first_address           :  INTEGER := 0;    
        last_address            :  INTEGER := 0;    
        first_bit_number        :  INTEGER := 0;
        data_width              :  INTEGER := 1;    
        address_width           :  INTEGER := 1;    
        byte_enable_mask_width  :  INTEGER := 1;    
	byte_size               :  INTEGER := 1;
        lpm_type                  : string := "stratixiii_mlab_cell";
        lpm_hint                  : string := "true";
	mixed_port_feed_through_mode : string := "dont_care";
        mem_init0 : BIT_VECTOR := X"0";
        -- --------- VITAL PARAMETERS --------
        tipd_clk0        : VitalDelayType01 := DefPropDelay01;
        tipd_ena0        : VitalDelayType01 := DefPropDelay01;
        tipd_portaaddr   : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_portbaddr   : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_portabyteenamasks        : VitalDelayArrayType01(20 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tsetup_portaaddr_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_portabyteenamasks_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena0_clk0_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_portaaddr_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_portabyteenamasks_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_ena0_clk0_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
	tpd_portbaddr_portbdataout : VitalDelayType01 := DefPropDelay01

        );    
    -- -------- PORT DECLARATIONS ---------
    PORT (
        portadatain             : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portaaddr               : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portabyteenamasks       : IN STD_LOGIC_VECTOR(byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        portbaddr               : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        clk0                : IN STD_LOGIC := '0';   
        ena0                : IN STD_LOGIC := '1';   
        portbdataout            : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)   
        );

END stratixiii_mlab_cell;

ARCHITECTURE block_arch OF stratixiii_mlab_cell IS
COMPONENT stratixiii_mlab_cell_pulse_generator
    PORT (
          clk                     : IN  STD_LOGIC;
          ena                     : IN  STD_LOGIC;
          pulse                   : OUT STD_LOGIC;
          cycle                   : OUT STD_LOGIC
    );
END COMPONENT;

CONSTANT port_byte_size : INTEGER := data_width / byte_enable_mask_width;

-- -------- internal signals ---------

-- Write address
SIGNAL write_address : INTEGER := 0;
SIGNAL read_address  : INTEGER := 0;
-- pulses
SIGNAL write_pulse, write_cycle, write_clock : STD_LOGIC; 

-- memory core
SUBTYPE  mem_word_type IS STD_LOGIC_VECTOR (data_width - 1 DOWNTO 0);
TYPE     mem_type IS ARRAY ((2 ** address_width) - 1 DOWNTO 0) OF mem_word_type;
SIGNAL   mem : mem_type;
SIGNAL   init_mem : BOOLEAN := FALSE;


-- byte enable
TYPE   mask_type IS (normal,inverse);
TYPE   mask_write IS ARRAY(mask_type'HIGH DOWNTO mask_type'LOW) OF mem_word_type;

SIGNAL mask_vector : mask_write := (
                          normal  => (OTHERS => '0'),
                          inverse => (OTHERS => 'X')
                     );
-- output

FUNCTION get_mask(
    b_ena : IN STD_LOGIC_VECTOR;
    CONSTANT b_ena_width ,byte_size: INTEGER
) RETURN mask_write IS

VARIABLE l : INTEGER;
VARIABLE mask : mask_write := (normal => (OTHERS => '0'),inverse => (OTHERS => 'X'));                           
BEGIN
    FOR l in 0 TO b_ena_width - 1  LOOP
        IF (b_ena(l) = '0') THEN 
                mask(normal) ((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => 'X');
                mask(inverse)((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => '0');
        ELSIF (b_ena(l) = 'X' OR b_ena(l) = 'U') THEN 
                mask(normal) ((l+1)*byte_size - 1 DOWNTO l*byte_size) := (OTHERS => 'X');
        END IF;
    END LOOP;
    RETURN mask;
END get_mask;

SIGNAL clk0_ipd : STD_LOGIC;
SIGNAL ena0_ipd : STD_LOGIC;
SIGNAL portaaddr_ipd : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
SIGNAL portbaddr_ipd : STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0);
SIGNAL portabyteenamasks_ipd : STD_LOGIC_VECTOR(byte_enable_mask_width - 1 DOWNTO 0);
SIGNAL ena0_reg : STD_LOGIC := '0';

BEGIN
    -- interconnect delays
    WireDelay : BLOCK
    BEGIN
        loopbits_ad : FOR i in portaaddr'RANGE GENERATE
            VitalWireDelay (portaaddr_ipd(i), portaaddr(i), tipd_portaaddr(i));
            VitalWireDelay (portbaddr_ipd(i), portbaddr(i), tipd_portbaddr(i));
        END GENERATE;
        loopbits_be : FOR j in portabyteenamasks'RANGE GENERATE
            VitalWireDelay (portabyteenamasks_ipd(j), portabyteenamasks(j), tipd_portabyteenamasks(j));
        END GENERATE;
        VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
        VitalWireDelay (ena0_ipd, ena0, tipd_ena0);
    END BLOCK;

    -- setup/hold checks
    setup_hold_checks: PROCESS (ena0_reg,portaaddr_ipd,portabyteenamasks_ipd,clk0_ipd,ena0_ipd)
    VARIABLE Tviol_clk_enable        : STD_ULOGIC := '0';
    VARIABLE Tviol_clk_address       : STD_ULOGIC := '0';
    VARIABLE Tviol_clk_bemasks       : STD_ULOGIC := '0';
    VARIABLE TimingData_clk_enable   : VitalTimingDataType := VitalTimingDataInit;
    VARIABLE TimingData_clk_address  : VitalTimingDataType := VitalTimingDataInit;
    VARIABLE TimingData_clk_bemasks  : VitalTimingDataType := VitalTimingDataInit;
    BEGIN
    -- Timing checks

    VitalSetupHoldCheck (
        Violation       => Tviol_clk_enable,
        TimingData      => TimingData_clk_enable,
        TestSignal      => ena0_ipd,
        TestSignalName  => "ena0",
        RefSignal       => clk0_ipd,
        RefSignalName   => "clk0",
        SetupHigh       => tsetup_ena0_clk0_noedge_posedge,
        SetupLow        => tsetup_ena0_clk0_noedge_posedge,
        HoldHigh        => thold_ena0_clk0_noedge_posedge,
        HoldLow         => thold_ena0_clk0_noedge_posedge,
        CheckEnabled    => TRUE,

        RefTransition   => '/',
        HeaderMsg       => "/LUTRAM VitalSetupHoldCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );

    VitalSetupHoldCheck (
        Violation       => Tviol_clk_address,
        TimingData      => TimingData_clk_address,
        TestSignal      => portaaddr_ipd,
        TestSignalName  => "portaaddr",
        RefSignal       => clk0_ipd,
        RefSignalName   => "clk0",
        SetupHigh       => tsetup_portaaddr_clk0_noedge_negedge,
        SetupLow        => tsetup_portaaddr_clk0_noedge_negedge,
        HoldHigh        => thold_portaaddr_clk0_noedge_negedge,
        HoldLow         => thold_portaaddr_clk0_noedge_negedge,
        CheckEnabled    => (ena0_reg = '1'),

        RefTransition   => '\',
        HeaderMsg       => "/LUTRAM VitalSetupHoldCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );

    VitalSetupHoldCheck (
        Violation       => Tviol_clk_bemasks,
        TimingData      => TimingData_clk_bemasks,
        TestSignal      => portabyteenamasks_ipd,
        TestSignalName  => "portabyteenamasks",
        RefSignal       => clk0_ipd,
        RefSignalName   => "clk0",
        SetupHigh       => tsetup_portabyteenamasks_clk0_noedge_negedge,
        SetupLow        => tsetup_portabyteenamasks_clk0_noedge_negedge,
        HoldHigh        => thold_portabyteenamasks_clk0_noedge_negedge,
        HoldLow         => thold_portabyteenamasks_clk0_noedge_negedge,
        CheckEnabled    => (ena0_reg = '1'),

        RefTransition   => '\',
        HeaderMsg       => "/LUTRAM VitalSetupHoldCheck",
        XOn           => DefXOnChecks,
        MsgOn         => DefMsgOnChecks );

    END PROCESS setup_hold_checks;

    -- latch CE signal
    PROCESS (clk0_ipd)
    BEGIN
        IF (clk0_ipd'EVENT AND clk0_ipd = '1') THEN
            ena0_reg <= ena0_ipd;
        END IF;
    END PROCESS;

    -- output path delay 
    PROCESS (portbaddr_ipd)
    VARIABLE CQDelay  : TIME := 0 ns;
    BEGIN
        CQDelay := SelectDelay(
                  ( 1 =>  ( portbaddr_ipd'LAST_EVENT, tpd_portbaddr_portbdataout, TRUE ) )
           );
        read_address <= TRANSPORT alt_conv_integer(portbaddr_ipd) AFTER CQDelay; 		
    END PROCESS;

    -- memory initialization
    init_mem <= TRUE;
    write_clock <= NOT clk0_ipd;
    write_address <= alt_conv_integer(portaaddr_ipd);
    
    -- Write pulse generation (neg edge)
    wpgen_a : stratixiii_mlab_cell_pulse_generator 
        PORT MAP (
            clk => write_clock,
            ena => ena0_reg,
            pulse => write_pulse,
            cycle => write_cycle
        );
        
    -- Create internal masks for byte enable processing
    mask_create : PROCESS (portabyteenamasks_ipd)
    VARIABLE mask : mask_write;
    BEGIN
    IF (portabyteenamasks_ipd'EVENT) THEN
        mask := get_mask(portabyteenamasks_ipd,byte_enable_mask_width,port_byte_size);
        mask_vector <= mask;
    END IF;
    END PROCESS mask_create;
    
   
    mem_rw : PROCESS (init_mem, write_pulse)
    -- mem init
    VARIABLE addr_range_init,index :  INTEGER;
    VARIABLE mem_init_std :  STD_LOGIC_VECTOR((last_address - first_address + 1)*data_width - 1 DOWNTO 0);
    VARIABLE mem_init :  bit_vector(mem_init0'length - 1 DOWNTO 0);
    VARIABLE mem_val : mem_type; 
    -- read/write 
    VARIABLE mem_data_p : mem_word_type;
    BEGIN
    -- Memory initialization
    IF (init_mem'EVENT) THEN
        -- Initialize output to 0
        mem_val := (OTHERS => (OTHERS => '0')); 
        IF (init_file /= "UNUSED" AND init_file /= "unused") THEN
            addr_range_init := last_address - first_address + 1;
	    mem_init := mem_init0;
            mem_init_std := to_stdlogicvector(mem_init)((last_address - first_address + 1)*data_width - 1 DOWNTO 0);
            FOR row IN 0 TO addr_range_init - 1 LOOP
                index := row * data_width;
                mem_val(row) := mem_init_std(index + data_width -1 DOWNTO index );
            END LOOP;
        END IF;
        mem <= mem_val;
    END IF;
    
    -- Write stage 1 : X to memory
    -- Write stage 2 : actual data to memory
   	IF (write_pulse'EVENT) THEN
    	    IF (write_pulse = '1') THEN
    	        mem_data_p := mem(write_address);
    	        FOR i IN 0 TO data_width - 1 LOOP
    	            mem_data_p(i) := mem_data_p(i) XOR mask_vector(inverse)(i);
    	        END LOOP;
    	        mem(write_address) <= mem_data_p;
    	    ELSIF (write_pulse = '0') THEN
                mem_data_p := mem(write_address);
    	        FOR i IN 0 TO data_width - 1 LOOP
    	            IF (mask_vector(normal)(i) = '0') THEN
    	                mem(write_address)(i) <= portadatain(i);
                        mem_data_p(i) := portadatain(i);
    	            ELSIF (mask_vector(inverse)(i) = 'X') THEN
    	                mem(write_address)(i) <= 'X';
                        mem_data_p(i) := 'X';
    	            END IF;                       
   	        END LOOP;
    	    END IF;
   	END IF;


   	END PROCESS mem_rw;

    -- Continuous read
        portbdataout <= mem(read_address);    	
    
END block_arch;


---------------------------------------------------------------------
--
-- Entity Name :  stratixiii_io_ibuf
-- 
-- Description :  Stratix III IO Ibuf VHDL simulation model
--  
--
---------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_io_ibuf IS
    GENERIC (
             tipd_i                  : VitalDelayType01 := DefPropDelay01;
             tipd_ibar               : VitalDelayType01 := DefPropDelay01;
             tipd_dynamicterminationcontrol   : VitalDelayType01 := DefPropDelay01;  
             tpd_i_o                 : VitalDelayType01 := DefPropDelay01;
             tpd_ibar_o              : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             differential_mode       :  string := "false";
             bus_hold                :  string := "false";
             simulate_z_as          : string    := "Z";
             lpm_type                :  string := "stratixiii_io_ibuf"
            );    
    PORT (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          dynamicterminationcontrol   : IN std_logic := '0';                                 
          o                       : OUT std_logic
         );       
END stratixiii_io_ibuf;

ARCHITECTURE arch OF stratixiii_io_ibuf IS
    SIGNAL i_ipd    : std_logic := '0';   
    SIGNAL ibar_ipd : std_logic := '0';     
    SIGNAL o_tmp    :  std_logic; 
    SIGNAL out_tmp    :  std_logic;
    SIGNAL prev_value : std_logic := '0'; 
BEGIN
    WireDelay : block
        begin                                                             
            VitalWireDelay (i_ipd, i, tipd_i);          
            VitalWireDelay (ibar_ipd, ibar, tipd_ibar);
        end block;                                                        

    PROCESS(i_ipd, ibar_ipd)
        BEGIN                                             
            IF (differential_mode = "false") THEN         
                IF (i_ipd = '1') THEN                         
                    o_tmp <= '1'; 
                    prev_value <= '1';                            
                ELSIF (i_ipd = '0') THEN                                     
                    o_tmp <= '0';                               
                    prev_value <= '0';
                ELSE
                    o_tmp <= i_ipd;
                END IF;
            ELSE                                          
                IF (( i_ipd =  '0' ) and (ibar_ipd = '1')) then       
                        o_tmp <= '0';                             
                ELSIF (( i_ipd =  '1' ) and (ibar_ipd = '0')) then
                    o_tmp <= '1';                             
                ELSIF((( i_ipd =  '1' ) and (ibar_ipd = '1'))  or (( i_ipd =  '0' ) and (ibar_ipd = '0')))then    
                    o_tmp <= 'X';
                ELSE                                   
                    o_tmp <= 'X';                             
                END IF;                                   
            END IF;        
        END PROCESS;
                
    out_tmp <= prev_value when (bus_hold = "true") else 
                'Z' when((o_tmp = 'Z') AND (simulate_z_as = "Z")) else
                'X' when((o_tmp = 'Z') AND (simulate_z_as = "X")) else
                '1' when((o_tmp = 'Z') AND (simulate_z_as = "vcc")) else
                '0' when((o_tmp = 'Z') AND (simulate_z_as = "gnd")) else
                o_tmp;    
             ----------------------
             --  Path Delay Section
             ----------------------
    PROCESS( out_tmp)
        variable output_VitalGlitchData : VitalGlitchDataType;
    BEGIN                                                                             
        VitalPathDelay01 (                                                            
                           OutSignal => o,                                                 
                           OutSignalName => "o",                                           
                           OutTemp => out_tmp,                                               
                           Paths => (0 => (i_ipd'last_event, tpd_i_o, TRUE),             
                                     1 => (ibar_ipd'last_event, tpd_ibar_o, TRUE)),   
                           GlitchData => output_VitalGlitchData,                                
                           Mode => DefGlitchMode,                                                
                           XOn  => XOn,                                                          
                           MsgOn  => MsgOn                                            
                         );                                                           
    END PROCESS;
 END arch;
 
 
 
---------------------------------------------------------------------
--
-- Entity Name :  stratixiii_io_obuf
-- 
-- Description :  Stratix III IO Obuf VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_io_obuf IS
    GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tipd_oe                          : VitalDelayType01 := DefPropDelay01;
             tipd_dynamicterminationcontrol   : VitalDelayType01 := DefPropDelay01;  
             tipd_seriesterminationcontrol    : VitalDelayArrayType01(13 DOWNTO 0) := (others => DefPropDelay01);   
             tipd_parallelterminationcontrol  : VitalDelayArrayType01(13 DOWNTO 0) := (others => DefPropDelay01 );   
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_oe_o                         : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             tpd_oe_obar                      : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;  
             open_drain_output                :  string := "false";              
             shift_series_termination_control :  string := "false";  
             sim_dynamic_termination_control_is_connected :  string := "false";                
             bus_hold                         :  string := "false";              
             lpm_type                         :  string := "stratixiii_io_obuf"
            );               
    PORT (
           i                       : IN std_logic := '0';                                                 
           oe                      : IN std_logic := '1';                                                 
           dynamicterminationcontrol   : IN std_logic := '0';                                 
           seriesterminationcontrol    : IN std_logic_vector(13 DOWNTO 0) := (others => '0');     
           parallelterminationcontrol  : IN std_logic_vector(13 DOWNTO 0) := (others => '0');   
           devoe                       : IN std_logic := '1';
           o                       : OUT std_logic;                                                       
           obar                    : OUT std_logic
         );                                                      
END stratixiii_io_obuf;

ARCHITECTURE arch OF stratixiii_io_obuf IS
    --INTERNAL Signals
    SIGNAL i_ipd                    : std_logic := '0'; 
    SIGNAL oe_ipd                   : std_logic := '0'; 
    SIGNAL dynamicterminationcontrol_ipd : std_logic := '0';   
    SIGNAL out_tmp                  :  std_logic := 'Z';   
    SIGNAL out_tmp_bar              :  std_logic;   
    SIGNAL prev_value               :  std_logic := '0';     
    SIGNAL o_tmp                    :  std_logic;    
    SIGNAL obar_tmp                 :  std_logic;  
    SIGNAL o_tmp1                    :  std_logic;    
    SIGNAL obar_tmp1                 :  std_logic;  
    SIGNAL seriesterminationcontrol_ipd    : std_logic_vector(13 DOWNTO 0) := (others => '0');   
    SIGNAL parallelterminationcontrol_ipd  : std_logic_vector(13 DOWNTO 0) := (others => '0');   
 
BEGIN

WireDelay : block
    begin                                                             
        VitalWireDelay (i_ipd, i, tipd_i);          
        VitalWireDelay (oe_ipd, oe, tipd_oe); 
        VitalWireDelay (dynamicterminationcontrol_ipd, dynamicterminationcontrol, tipd_dynamicterminationcontrol);   
        g1 :for i in seriesterminationcontrol'range generate
            VitalWireDelay (seriesterminationcontrol_ipd(i), seriesterminationcontrol(i), tipd_seriesterminationcontrol(i));
        end generate;
        g2 :for i in parallelterminationcontrol'range generate                                                                         
            VitalWireDelay (parallelterminationcontrol_ipd(i), parallelterminationcontrol(i), tipd_parallelterminationcontrol(i));     
        end generate;                                                                                                                  


    end block;                                                                              
    PROCESS( i_ipd, oe_ipd)
        BEGIN                                              
            IF (oe_ipd = '1') THEN                      
                IF (open_drain_output = "true") THEN
                    IF (i_ipd = '0') THEN               
                        out_tmp <= '0';             
                        out_tmp_bar <= '1';         
                        prev_value <= '0';          
                    ELSE                            
                        out_tmp <= 'Z';             
                        out_tmp_bar <= 'Z';         
                    END IF;                         
                ELSE                                
                    IF (i_ipd = '0') THEN               
                        out_tmp <= '0';             
                        out_tmp_bar <= '1';         
                        prev_value <= '0';          
                    ELSE                            
                        IF (i_ipd = '1') THEN           
                            out_tmp <= '1';         
                            out_tmp_bar <= '0';     
                            prev_value <= '1';      
                        ELSE                        
                            out_tmp <= i_ipd;           
                            out_tmp_bar <= i_ipd;       
                        END IF;                     
                    END IF;                         
                END IF;                             
            ELSE                                    
                IF (oe_ipd = '0') THEN                  
                    out_tmp <= 'Z';                 
                    out_tmp_bar <= 'Z';             
                ELSE                                
                    out_tmp <= 'X';                 
                    out_tmp_bar <= 'X';             
                END IF;                             
            END IF;                                     
    END PROCESS;
    o_tmp1 <= prev_value WHEN (bus_hold = "true") ELSE out_tmp;
    obar_tmp1 <= NOT prev_value WHEN (bus_hold = "true") ELSE out_tmp_bar;  
    o_tmp <= 'X' when (( oe_ipd = '1') and (dynamicterminationcontrol = '1') and (sim_dynamic_termination_control_is_connected = "true")) else o_tmp1 WHEN (devoe = '1') ELSE 'Z'; 
    obar_tmp <= 'X' when (( oe_ipd = '1') and (dynamicterminationcontrol = '1')and (sim_dynamic_termination_control_is_connected = "true")) else obar_tmp1 WHEN (devoe = '1') ELSE 'Z'; 
         ---------------------
     --  Path Delay Section
     ----------------------
    PROCESS( o_tmp,obar_tmp)
        variable o_VitalGlitchData : VitalGlitchDataType;
        variable obar_VitalGlitchData : VitalGlitchDataType;
        BEGIN
            VitalPathDelay01 (                                                                  
                              OutSignal => o,                                                  
                              OutSignalName => "o",                                            
                              OutTemp => o_tmp,                                                
                              Paths => (0 => (i_ipd'last_event, tpd_i_o, TRUE),                
                                        1 => (oe_ipd'last_event, tpd_oe_o, TRUE)),   
                              GlitchData => o_VitalGlitchData,                           
                              Mode => DefGlitchMode,                                           
                              XOn  => XOn,                                                     
                              MsgOn  => MsgOn                                                  
                              ); 
            VitalPathDelay01 (                                                               
                  OutSignal => obar,                                                
                  OutSignalName => "obar",                                          
                  OutTemp => obar_tmp,                                              
                  Paths => (0 => (i_ipd'last_event, tpd_i_obar, TRUE),              
                            1 => (oe_ipd'last_event, tpd_oe_obar, TRUE)),   
                  GlitchData => obar_VitalGlitchData,                         
                  Mode => DefGlitchMode,                                         
                  XOn  => XOn,                                                   
                  MsgOn  => MsgOn                                                
                  ); 
        END PROCESS;                                                                                                                                              
END arch;

-----------------------------------------------------------------------                                       
--                                                                                                            
-- Entity Name :  stratixiii_ddio_in                                                                               
--                                                                                                            
-- Description :  Stratix III DDIO_IN VHDL simulation model                                                         
--                                                                                                            
--                                                                                                            
---------------------------------------------------------------------                                         
LIBRARY IEEE;                                                                                                 
LIBRARY altera;                                                                                               
use IEEE.std_logic_1164.all;                                                                                  
use IEEE.std_logic_arith.all;                                                                                 
use IEEE.VITAL_Timing.all;                                                                                    
use IEEE.VITAL_Primitives.all;                                                                                
use altera.all;                                                                  
use work.stratixiii_atom_pack.all;                                                                              
                                                                                                           
                                                                                                              
ENTITY stratixiii_ddio_in IS                                                                                       
    generic(                                                                                                  
            tipd_datain                        : VitalDelayType01 := DefPropDelay01;                          
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;                          
            tipd_clkn                          : VitalDelayType01 := DefPropDelay01;                          
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;                          
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;                          
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;                          
            XOn                                : Boolean := DefGlitchXOn;                                     
            MsgOn                              : Boolean := DefGlitchMsgOn;                                   
            power_up                           :  string := "low";                                            
            async_mode                         :  string := "none";                                           
            sync_mode                          :  string := "none";                                           
            use_clkn                           :  string := "false";                                          
            lpm_type                           :  string := "stratixiii_ddio_in"                                   
           );                                                                                                 
    PORT (                                                                                                    
           datain                  : IN std_logic := '0';                                                     
           clk                     : IN std_logic := '0';                                                     
           clkn                    : IN std_logic := '0';                                                     
           ena                     : IN std_logic := '1';                                                     
           areset                  : IN std_logic := '0';                                                     
           sreset                  : IN std_logic := '0';                                                     
           regoutlo                : OUT std_logic;                                                           
           regouthi                : OUT std_logic;                                                           
           dfflo                   : OUT std_logic;                                                           
           devclrn                 : IN std_logic := '1';                                                     
           devpor                  : IN std_logic := '1'                                                      
        );                                                                                                    
END stratixiii_ddio_in;                                                                                            
                                                                                                              
ARCHITECTURE arch OF stratixiii_ddio_in IS                                                                         
                                                                                                              
component dffeas                                                                                              
    generic (                                                                                                 
             power_up : string := "DONT_CARE";                                                                
             is_wysiwyg : string := "false";                                                                  
             x_on_violation : string := "on";                                                                 
             lpm_type : string := "DFFEAS";                                                                   
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                
             tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                           
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
             tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
             thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                 
             thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                               
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;                                          
             tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;                                       
             tpd_prn_q_negedge : VitalDelayType01 := DefPropDelay01;                                         
             tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;                                        
             tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                                                
             tipd_clk : VitalDelayType01 := DefPropDelay01;                                                   
             tipd_d : VitalDelayType01 := DefPropDelay01;                                                     
             tipd_asdata : VitalDelayType01 := DefPropDelay01;                                                
             tipd_sclr : VitalDelayType01 := DefPropDelay01;                                                  
             tipd_sload : VitalDelayType01 := DefPropDelay01;                                                 
             tipd_clrn : VitalDelayType01 := DefPropDelay01;                                                  
             tipd_prn : VitalDelayType01 := DefPropDelay01;                                                   
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
           d : in std_logic := '0';                                                                           
           clk : in std_logic := '0';                                                                         
           ena : in std_logic := '1';                                                                         
           clrn : in std_logic := '1';                                                                        
           prn : in std_logic := '1';                                                                         
           aload : in std_logic := '0';                                                                       
           asdata : in std_logic := '1';                                                                      
           sclr : in std_logic := '0';                                                                        
           sload : in std_logic := '0';                                                                       
           devclrn : in std_logic := '1';                                                                     
           devpor : in std_logic := '1';                                                                      
           q : out std_logic                                                                                  
         );                                                                                                   
end component;                                                                                                
                                                                                                              
    --Internal Signals                                                                                        
    SIGNAL datain_ipd               : std_logic := '0';                                                       
    SIGNAL clk_ipd                  : std_logic := '0';                                                       
    SIGNAL clkn_ipd                 : std_logic := '0';                                                       
    SIGNAL ena_ipd                  : std_logic := '0';                                                       
    SIGNAL areset_ipd               : std_logic := '0';                                                       
    SIGNAL sreset_ipd               : std_logic := '0';                                                       
    SIGNAL ddioreg_aclr             :  std_logic;                                                             
    SIGNAL ddioreg_prn              :  std_logic;                                                             
    SIGNAL ddioreg_adatasdata       :  std_logic;                                                             
    SIGNAL ddioreg_sclr             :  std_logic;                                                             
    SIGNAL ddioreg_sload            :  std_logic;                                                             
    SIGNAL ddioreg_clk              :  std_logic;                                                             
    SIGNAL dfflo_tmp                :  std_logic;                                                             
    SIGNAL regout_tmp_hi            :  std_logic;                                                             
    SIGNAL regout_tmp_lo            :  std_logic;                                                             
    SIGNAL regouthi_tmp            :  std_logic;                                                              
    SIGNAL regoutlo_tmp            :  std_logic;                                                              
                                                                                                              
                                                                                                              
BEGIN                                                                                                         
                                                                                                              
WireDelay : block                                                                                             
    begin                                                                                                     
        VitalWireDelay (datain_ipd, datain, tipd_datain);                                                    
        VitalWireDelay (clk_ipd, clk, tipd_clk);                                                              
        VitalWireDelay (clkn_ipd, clkn, tipd_clkn);                                                           
        VitalWireDelay (ena_ipd, ena, tipd_ena);                                                              
        VitalWireDelay (areset_ipd, areset, tipd_areset);                                                     
        VitalWireDelay (sreset_ipd, sreset, tipd_sreset);                                                     
    end block;                                                                                                
                                                                                                              
                                                                                                           
    ddioreg_clk <= NOT clk_ipd WHEN (use_clkn = "false") ELSE clkn_ipd;                                       
                                                                                                              
    --Decode the control values for the DDIO registers                                                     
    PROCESS                                                                                                
        BEGIN                                                                                              
            WAIT UNTIL areset_ipd'EVENT OR sreset_ipd'EVENT;                                               
                IF (async_mode = "clear") THEN                                                             
                    ddioreg_aclr <= NOT areset_ipd;                                                        
                    ddioreg_prn <= '1';                                                                    
                ELSIF (async_mode = "preset") THEN                                                        
                    ddioreg_aclr <= '1';                                                                   
                    ddioreg_prn <= NOT areset_ipd;                                                         
                ELSE                                                                                       
                    ddioreg_aclr <= '1';                                                                   
                    ddioreg_prn <= '1';                                                                    
                END IF;                                                                                    
                                                                                                           
                IF (sync_mode = "clear") THEN                                                              
                    ddioreg_adatasdata <= '0';                                                             
                    ddioreg_sclr <= sreset_ipd;                                                            
                    ddioreg_sload <= '0';                                                                  
                ELSIF (sync_mode = "preset") THEN                                                        
                    ddioreg_adatasdata <= '1';                                                             
                    ddioreg_sclr <= '0';                                                                   
                    ddioreg_sload <= sreset_ipd;                                                             
                ELSE                                                                                                                
                    ddioreg_adatasdata <= '0';                                                             
                    ddioreg_sclr <= '0';                                                                   
                    ddioreg_sload <= '0';                                                                                                                                               
                END IF;                                                                                    
    END PROCESS;                                                                                              
                                                                                                              
       --DDIO High Register                                                                                   
    ddioreg_hi : dffeas                                                                                       
        GENERIC MAP (                                                                                         
                      power_up => power_up                                                                    
                    )                                                                                         
        PORT MAP (                                                                                            
                  d => datain_ipd,                                                                            
                  clk => clk_ipd,                                                                             
                  clrn => ddioreg_aclr,                                                                       
                  prn  => ddioreg_prn,                                                                     
                  sclr => ddioreg_sclr,                                                                       
                  sload => ddioreg_sload,                                                                     
                  asdata => ddioreg_adatasdata,                                                               
                  ena => ena_ipd,                                                                             
                  q => regout_tmp_hi,                                                                         
                  devpor => devpor,                                                                           
                  devclrn => devclrn                                                                          
                 );                                                                                           
                                                                                                              
    --DDIO Low Register                                                                                       
    ddioreg_lo : dffeas                                                                                       
        GENERIC MAP (                                                                                         
                     power_up => power_up                                                                     
                    )                                                                                         
        PORT MAP (                                                                                            
                  d => datain_ipd,                                                                            
                  clk => ddioreg_clk,                                                                         
                  clrn => ddioreg_aclr,                                                                       
                  prn  => ddioreg_prn,                                                                     
                  sclr => ddioreg_sclr,                                                                       
                  sload => ddioreg_sload,                                                                     
                  asdata => ddioreg_adatasdata,                                                               
                  ena => ena_ipd,                                                                             
                  q => dfflo_tmp,                                                                             
                  devpor => devpor,                                                                           
                  devclrn => devclrn                                                                          
                );                                                                                            
                                                                                                              
    ddioreg_lo1 : dffeas                                                                                      
        GENERIC MAP (                                                                                         
                     power_up => power_up                                                                     
                    )                                                                                         
        PORT MAP (                                                                                            
                   d => dfflo_tmp,                                                                            
                   clk => clk_ipd,                                                                            
                   clrn => ddioreg_aclr,                                                                      
                   prn  => ddioreg_prn,                                                                    
                   sclr => ddioreg_sclr,                                                                      
                   sload => ddioreg_sload,                                                                    
                   asdata => ddioreg_adatasdata,                                                              
                   ena => ena_ipd,                                                                            
                   q => regout_tmp_lo,                                                                        
                   devpor => devpor,                                                                          
                   devclrn => devclrn                                                                         
                );                                                                                            
                                                                                                              
    regouthi <= regout_tmp_hi ;                                                                               
    regoutlo <= regout_tmp_lo ;                                                                               
    dfflo <= dfflo_tmp ;                                                                                      
END arch;                                                                                                     
                                                                                                              
---------------------------------------------------------------------      
--                                                                         
-- Entity Name :  stratixiii_ddio_oe                                            
-- 
-- Description :  Stratix III DDIO_OE VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
LIBRARY altera;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use altera.all;
use work.stratixiii_atom_pack.all;



ENTITY stratixiii_ddio_oe IS
    generic(
            tipd_oe                            : VitalDelayType01 := DefPropDelay01;
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;
            XOn                                : Boolean := DefGlitchXOn;           
            MsgOn                              : Boolean := DefGlitchMsgOn;         
            power_up              :  string := "low";    
            async_mode            :  string := "none";    
            sync_mode             :  string := "none";
            lpm_type              :  string := "stratixiii_ddio_oe"
           );    
      
    PORT (
          oe                      : IN std_logic := '1';   
          clk                     : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic;         
          devclrn                 : IN std_logic := '1';               
          devpor                  : IN std_logic := '1'
         );             
END stratixiii_ddio_oe;

ARCHITECTURE arch OF stratixiii_ddio_oe IS

component stratixiii_mux21
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
            tipd_S                       :    VitalDelayType01 := DefPropDelay01
           );
    port (
          A : in std_logic := '0';
          B : in std_logic := '0';
          S : in std_logic := '0';
          MO : out std_logic
         );    
end component;

component dffeas
    generic (
             power_up : string := "DONT_CARE";                                     
             is_wysiwyg : string := "false";                                       
             x_on_violation : string := "on";                                      
             lpm_type : string := "DFFEAS";                                        
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;     
             tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;  
             tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst; 
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;   
             thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;      
             thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst; 
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;   
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;  
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;    
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;               
             tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;  
             tpd_prn_q_negedge : VitalDelayType01 := DefPropDelay01;               
             tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;             
             tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                     
             tipd_clk : VitalDelayType01 := DefPropDelay01;                        
             tipd_d : VitalDelayType01 := DefPropDelay01;                          
             tipd_asdata : VitalDelayType01 := DefPropDelay01;                     
             tipd_sclr : VitalDelayType01 := DefPropDelay01;                       
             tipd_sload : VitalDelayType01 := DefPropDelay01;                      
             tipd_clrn : VitalDelayType01 := DefPropDelay01;                       
             tipd_prn : VitalDelayType01 := DefPropDelay01;                        
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
           d : in std_logic := '0';      
           clk : in std_logic := '0';    
           ena : in std_logic := '1';    
           clrn : in std_logic := '1';   
           prn : in std_logic := '1';    
           aload : in std_logic := '0';  
           asdata : in std_logic := '1'; 
           sclr : in std_logic := '0';   
           sload : in std_logic := '0';  
           devclrn : in std_logic := '1';
           devpor : in std_logic := '1'; 
           q : out std_logic 
        );          
end component;
   
    --Internal Signals
    SIGNAL oe_ipd               : std_logic := '0';           
    SIGNAL clk_ipd                  : std_logic := '0';                      
    SIGNAL ena_ipd                  : std_logic := '0';           
    SIGNAL areset_ipd               : std_logic := '0';           
    SIGNAL sreset_ipd               : std_logic := '0';           
    SIGNAL ddioreg_aclr             :  std_logic;   
    SIGNAL ddioreg_prn              :  std_logic;   
    SIGNAL ddioreg_adatasdata       :  std_logic;   
    SIGNAL ddioreg_sclr             :  std_logic;   
    SIGNAL ddioreg_sload            :  std_logic;   
    SIGNAL dfflo_tmp                :  std_logic;   
    SIGNAL dffhi_tmp                :  std_logic;  
    signal nclk                     :  std_logic;
    signal dataout_tmp              :  std_logic; 
   
BEGIN
   
   WireDelay : block                                             
       begin                                                     
           VitalWireDelay (oe_ipd, oe, tipd_oe);     
           VitalWireDelay (clk_ipd, clk, tipd_clk);                         
           VitalWireDelay (ena_ipd, ena, tipd_ena);              
           VitalWireDelay (areset_ipd, areset, tipd_areset);     
           VitalWireDelay (sreset_ipd, sreset, tipd_sreset);     
       end block;
                                                
   nclk <= NOT clk_ipd;
   PROCESS
      BEGIN
            WAIT UNTIL areset_ipd'EVENT OR sreset_ipd'EVENT;                                               
                IF (async_mode = "clear") THEN                                                             
                    ddioreg_aclr <= NOT areset_ipd;                                                        
                    ddioreg_prn <= '1';                                                                  
                ELSIF (async_mode = "preset") THEN                                                        
                    ddioreg_aclr <= '1';                                           
                    ddioreg_prn <= NOT areset_ipd;                                 
                ELSE 
                    ddioreg_aclr <= '1';                                               
                    ddioreg_prn <= '1';                                                
                END IF;   
                                                                                       
                IF (sync_mode = "clear") THEN                                  
                    ddioreg_adatasdata <= '0';                                 
                    ddioreg_sclr <= sreset_ipd;                                                    
                    ddioreg_sload <= '0';                                                          
                ELSIF (sync_mode = "preset") THEN                                                 
                    ddioreg_adatasdata <= '1';                                                 
                    ddioreg_sclr <= '0';                                                       
                    ddioreg_sload <= sreset_ipd;                                                              
                ELSE                                                                                                                
                    ddioreg_adatasdata <= '0';                                                 
                    ddioreg_sclr <= '0';                                                       
                    ddioreg_sload <= '0';                                                                                                                                               
                END IF;                                                                            
    END PROCESS;                                                             
        
       ddioreg_hi : dffeas 
        GENERIC MAP (
                     power_up => power_up
                    )
        PORT MAP (
                  d => oe_ipd,                     
                  clk => clk_ipd,                  
                  clrn => ddioreg_aclr,        
                  prn => ddioreg_prn,      
                  sclr => ddioreg_sclr,        
                  sload => ddioreg_sload,      
                  asdata => ddioreg_adatasdata,
                  ena => ena_ipd,              
                  q => dffhi_tmp,              
                  devpor => devpor,            
                  devclrn => devclrn           
                );   
    
    
    --DDIO Low Register
    ddioreg_lo : dffeas 
        GENERIC MAP (
                     power_up => power_up
                    )
        PORT MAP (
                  d => dffhi_tmp,              
                  clk => nclk,             
                  clrn => ddioreg_aclr,        
                  prn => ddioreg_prn,      
                  sclr => ddioreg_sclr,        
                  sload => ddioreg_sload,      
                  asdata => ddioreg_adatasdata,
                  ena => ena_ipd,              
                  q => dfflo_tmp,              
                  devpor => devpor,            
                  devclrn => devclrn           
                );   
    
    --registered output 
    or_gate : stratixiii_mux21
        port map (
                   A => dffhi_tmp,
                   B => dfflo_tmp,
                   S => dfflo_tmp,
                   MO => dataout  
                  );              

    dfflo <= dfflo_tmp ;
    dffhi <= dffhi_tmp ;
    
END arch;
---------------------------------------------------------------------
--
-- Entity Name :  stratixiii_ddio_out
-- 
-- Description :  Stratix III DDIO_OUT VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
LIBRARY altera;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use altera.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_ddio_out IS
    generic(
            tipd_datainlo                      : VitalDelayType01 := DefPropDelay01;
            tipd_datainhi                      : VitalDelayType01 := DefPropDelay01;
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;
            tipd_clkhi                         : VitalDelayType01 := DefPropDelay01;
            tipd_clklo                         : VitalDelayType01 := DefPropDelay01;
            tipd_muxsel                        : VitalDelayType01 := DefPropDelay01;
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;
            XOn                                : Boolean := DefGlitchXOn;           
            MsgOn                              : Boolean := DefGlitchMsgOn;         
            power_up                           :  string := "low";          
            async_mode                         :  string := "none";       
            sync_mode                          :  string := "none";
            half_rate_mode                     :  string := "false";       
            use_new_clocking_model             :  string := "false";
            lpm_type                           :  string := "stratixiii_ddio_out"
           );
    PORT (
          datainlo                : IN std_logic := '0';   
          datainhi                : IN std_logic := '0';   
          clk                     : IN std_logic := '0'; 
          clkhi                   : IN std_logic := '0'; 
          clklo                   : IN std_logic := '0'; 
          muxsel                  : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic_vector(1 downto 0) ;      
          devclrn                 : IN std_logic := '1';   
          devpor                  : IN std_logic := '1'   
        );   
END stratixiii_ddio_out;

ARCHITECTURE arch OF stratixiii_ddio_out IS

component stratixiii_mux21
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
            tipd_S                       :    VitalDelayType01 := DefPropDelay01
           );
    port (
          A : in std_logic := '0';
          B : in std_logic := '0';
          S : in std_logic := '0';
          MO : out std_logic
         );    
end component;

component dffeas
    generic (
             power_up : string := "DONT_CARE";                                     
             is_wysiwyg : string := "false";                                       
             x_on_violation : string := "on";                                      
             lpm_type : string := "DFFEAS";                                        
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;     
             tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;  
             tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst; 
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;   
             thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;      
             thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst; 
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;   
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;  
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;    
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;               
             tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;
             tpd_prn_q_negedge : VitalDelayType01 := DefPropDelay01;              
             tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;             
             tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                     
             tipd_clk : VitalDelayType01 := DefPropDelay01;                        
             tipd_d : VitalDelayType01 := DefPropDelay01;                          
             tipd_asdata : VitalDelayType01 := DefPropDelay01;                     
             tipd_sclr : VitalDelayType01 := DefPropDelay01;                       
             tipd_sload : VitalDelayType01 := DefPropDelay01;                      
             tipd_clrn : VitalDelayType01 := DefPropDelay01;                       
             tipd_prn : VitalDelayType01 := DefPropDelay01;                        
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
          d : in std_logic := '0';      
          clk : in std_logic := '0';    
          ena : in std_logic := '1';    
          clrn : in std_logic := '1';   
          prn : in std_logic := '1';    
          aload : in std_logic := '0';  
          asdata : in std_logic := '1'; 
          sclr : in std_logic := '0';   
          sload : in std_logic := '0';  
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1'; 
          q : out std_logic
         );          
end component;
   
   
    --Internal Signals
    SIGNAL datainlo_ipd             : std_logic := '0';  
    SIGNAL datainhi_ipd             : std_logic := '0';             
    SIGNAL clk_ipd                  : std_logic := '0'; 
    SIGNAL clkhi_ipd                : std_logic := '0';
    SIGNAL clklo_ipd                : std_logic := '0';
    SIGNAL muxsel_ipd               : std_logic := '0';        
    SIGNAL ena_ipd                  : std_logic := '0';         
    SIGNAL areset_ipd               : std_logic := '0';         
    SIGNAL sreset_ipd               : std_logic := '0';         
    SIGNAL ddioreg_aclr             :  std_logic;   
    SIGNAL ddioreg_prn              :  std_logic;   
    SIGNAL ddioreg_adatasdata       :  std_logic;   
    SIGNAL ddioreg_sclr             :  std_logic;   
    SIGNAL ddioreg_sload            :  std_logic;   
    SIGNAL dfflo_tmp                :  std_logic;   
    SIGNAL dffhi_tmp                :  std_logic;  
    SIGNAL dataout_tmp              :  std_logic; 
    Signal mux_sel                  :  std_logic;
    Signal mux_hi                   :  std_logic;
   Signal dffhi1_tmp                :  std_logic;     
   Signal sel_mux_hi_in             :  std_logic;
   signal nclk                      :  std_logic;     
   signal clk1                      :  std_logic;
   signal clk_hi                    :  std_logic;
   signal clk_lo                    :  std_logic;
   signal clk_hr                    :  std_logic; 

    signal muxsel1 : std_logic;
    signal muxsel2: std_logic;
    signal clk2   : std_logic;
    signal muxsel_tmp: std_logic;
    signal sel_mux_lo_in : std_logic;
    signal datainlo_tmp : std_logic;
    signal datainhi_tmp : std_logic;

BEGIN

WireDelay : block                                            
    begin                                                    
        VitalWireDelay (datainlo_ipd, datainlo, tipd_datainlo);  
        VitalWireDelay (datainhi_ipd, datainhi, tipd_datainhi);             
        VitalWireDelay (clk_ipd, clk, tipd_clk);  
        VitalWireDelay (clkhi_ipd, clkhi, tipd_clkhi); 
        VitalWireDelay (clklo_ipd, clklo, tipd_clklo); 
        VitalWireDelay (muxsel_ipd, muxsel, tipd_muxsel);            
        VitalWireDelay (ena_ipd, ena, tipd_ena);             
        VitalWireDelay (areset_ipd, areset, tipd_areset);    
        VitalWireDelay (sreset_ipd, sreset, tipd_sreset);    
    end block;                                               
   nclk <= NOT clk_ipd;                                  
   PROCESS                                                                                                
        BEGIN                                                                                              
            WAIT UNTIL areset_ipd'EVENT OR sreset_ipd'EVENT;                                               
                IF (async_mode = "clear") THEN                                                             
                    ddioreg_aclr <= NOT areset_ipd;                                                        
                    ddioreg_prn <= '1';                                                                  
                ELSIF (async_mode = "preset") THEN                                                        
                    ddioreg_aclr <= '1';                                           
                    ddioreg_prn <= NOT areset_ipd;                                 
                ELSE 
                    ddioreg_aclr <= '1';                                               
                    ddioreg_prn <= '1';                                                
                END IF;   
  
                IF (sync_mode = "clear") THEN                                  
                    ddioreg_adatasdata <= '0';                                 
                    ddioreg_sclr <= sreset_ipd;                                                    
                    ddioreg_sload <= '0';                                                          
                ELSIF (sync_mode = "preset") THEN                                                 
                    ddioreg_adatasdata <= '1';                                                 
                    ddioreg_sclr <= '0';                                                       
                    ddioreg_sload <= sreset_ipd;                                                              
                ELSE                                                                                                                
                    ddioreg_adatasdata <= '0';                                                 
                    ddioreg_sclr <= '0';                                                       
                    ddioreg_sload <= '0';                                                                                                                                               
                END IF;                                                                            
    END PROCESS;                    
    
    process(clk_ipd)
        begin                   
            clk1 <= clk_ipd;
    end process;

   process(muxsel_ipd)
        begin                   
            muxsel1 <= muxsel_ipd;
    end process;
    
        

    --DDIO HIGH Register 
    clk_hi <=  clkhi_ipd when(use_new_clocking_model = "true") else  clk_ipd;  
    datainhi_tmp <= datainhi;
    ddioreg_hi : dffeas                                      
        GENERIC MAP (                                        
                     power_up => power_up                    
                    )                                        
        PORT MAP (                                           
                  d => datainhi_tmp,                         
                  clk => clk_hi,                             
                  clrn => ddioreg_aclr,                      
                  prn => ddioreg_prn,                        
                  sclr => ddioreg_sclr,                      
                  sload => ddioreg_sload,                    
                  asdata => ddioreg_adatasdata,              
                  ena => ena_ipd,                            
                  q => dffhi_tmp,                            
                  devpor => devpor,                          
                  devclrn => devclrn                         
                );                                           

        
    --DDIO Low Register
    clk_lo <= clklo_ipd when(use_new_clocking_model = "true") else clk_ipd;
    datainlo_tmp <= datainlo;
    ddioreg_lo : dffeas 
        GENERIC MAP (
                      power_up => power_up
                    )
        PORT MAP (
                  d => datainlo_tmp,               
                  clk => clk_lo,                  
                  clrn => ddioreg_aclr,        
                  prn => ddioreg_prn,      
                  sclr => ddioreg_sclr,        
                  sload => ddioreg_sload,      
                  asdata => ddioreg_adatasdata,
                  ena => ena_ipd,                  
                  q => dfflo_tmp,               
                  devpor => devpor,            
                  devclrn => devclrn           
                );   
   clk_hr <= NOT clkhi_ipd when(use_new_clocking_model = "true") else NOT clk_ipd;             
   ddioreg_hi1 : dffeas                               
        GENERIC MAP (                                 
                      power_up => power_up            
                    )                                 
        PORT MAP (                                    
                  d => dffhi_tmp,                     
                  clk => clk_hr,                      
                  clrn => ddioreg_aclr,               
                  prn => ddioreg_prn,                 
                  sclr => ddioreg_sclr,               
                  sload => ddioreg_sload,             
                  asdata => ddioreg_adatasdata,       
                  ena => ena_ipd,                     
                  q => dffhi1_tmp,                    
                  devpor => devpor,                   
                  devclrn => devclrn                  
                );                                    
                                                      
                                                      
  
  muxsel2 <= muxsel1;
  clk2 <= clk1;
  mux_sel <= muxsel2 when(use_new_clocking_model = "true") else clk2;       
  muxsel_tmp <= mux_sel;  
  sel_mux_lo_in <= dfflo_tmp;              
  sel_mux_hi_in <= dffhi1_tmp when(half_rate_mode = "true") else dffhi_tmp;  
  
  sel_mux : stratixiii_mux21
        port map (
                   A => sel_mux_lo_in,
                   B => sel_mux_hi_in,
                   S => muxsel_tmp,
                   MO => dataout  
                  );              

    dfflo <= dfflo_tmp;
    dffhi(0) <= dffhi_tmp; 
    dffhi(1) <= dffhi1_tmp;                                           
END arch;

-- --------------------------------------------------------------------
-- Module Name: stratixiii_rt_sm
-- Description: Parallel Termination State Machine
-- --------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY stratixiii_rt_sm IS
    PORT (
        rup                     : IN std_logic;   
        rdn                     : IN std_logic;   
        clk                     : IN std_logic;   
        clken                   : IN std_logic;   
        clr                     : IN std_logic;   
        rtena                   : IN std_logic;   
        rscaldone               : IN std_logic;   
        rtoffsetp               : OUT std_logic_vector(3 DOWNTO 0);   
        rtoffsetn               : OUT std_logic_vector(3 DOWNTO 0);   
        caldone                 : OUT std_logic;   
        sel_rup_vref            : OUT std_logic_vector(2 DOWNTO 0);   
        sel_rdn_vref            : OUT std_logic_vector(2 DOWNTO 0));   
END stratixiii_rt_sm;

ARCHITECTURE stratixiii_rt_sm_rtl OF stratixiii_rt_sm IS


    CONSTANT  STRATIXIII_RTOCT_WAIT      :  std_logic_vector(4 DOWNTO 0) := "00000";    
    CONSTANT  RUP_VREF_M_RDN_VER_M  :  std_logic_vector(4 DOWNTO 0) := "00001";    
    CONSTANT  RUP_VREF_L_RDN_VER_L  :  std_logic_vector(4 DOWNTO 0) := "00010";    
    CONSTANT  RUP_VREF_H_RDN_VER_H  :  std_logic_vector(4 DOWNTO 0) := "00011";    
    CONSTANT  RUP_VREF_L_RDN_VER_H  :  std_logic_vector(4 DOWNTO 0) := "00100";    
    CONSTANT  RUP_VREF_H_RDN_VER_L  :  std_logic_vector(4 DOWNTO 0) := "00101";    
    CONSTANT  STRATIXIII_RTOCT_INC_PN    :  std_logic_vector(4 DOWNTO 0) := "01000";    
    CONSTANT  STRATIXIII_RTOCT_DEC_PN    :  std_logic_vector(4 DOWNTO 0) := "01001";    
    CONSTANT  STRATIXIII_RTOCT_INC_P     :  std_logic_vector(4 DOWNTO 0) := "01010";    
    CONSTANT  STRATIXIII_RTOCT_DEC_P     :  std_logic_vector(4 DOWNTO 0) := "01011";    
    CONSTANT  STRATIXIII_RTOCT_INC_N     :  std_logic_vector(4 DOWNTO 0) := "01100";    
    CONSTANT  STRATIXIII_RTOCT_DEC_N     :  std_logic_vector(4 DOWNTO 0) := "01101";    
    CONSTANT  STRATIXIII_RTOCT_SWITCH_REG:  std_logic_vector(4 DOWNTO 0) := "10001";    
    CONSTANT  STRATIXIII_RTOCT_DONE      :  std_logic_vector(4 DOWNTO 0) := "11111";    
    -- interface
    SIGNAL nclr                     :  std_logic := '1';   --  for synthesis
    SIGNAL rtcalclk                 :  std_logic;   
    SIGNAL caldone_sig              :  std_logic := '0';   
    -- sm
    SIGNAL current_state            :  std_logic_vector(4 DOWNTO 0) := "00000";   
    SIGNAL next_state               :  std_logic_vector(4 DOWNTO 0) := "00000";   
    SIGNAL sel_rup_vref_h_d         :  std_logic := '0';   
    SIGNAL sel_rup_vref_h           :  std_logic := '0';   
    SIGNAL sel_rup_vref_m_d         :  std_logic := '1';   
    SIGNAL sel_rup_vref_m           :  std_logic := '1';   
    SIGNAL sel_rup_vref_l_d         :  std_logic := '0';   
    SIGNAL sel_rup_vref_l           :  std_logic := '0';   
    SIGNAL sel_rdn_vref_h_d         :  std_logic := '0';   
    SIGNAL sel_rdn_vref_h           :  std_logic := '0';   
    SIGNAL sel_rdn_vref_m_d         :  std_logic := '1';   
    SIGNAL sel_rdn_vref_m           :  std_logic := '1';   
    SIGNAL sel_rdn_vref_l_d         :  std_logic := '0';   
    SIGNAL sel_rdn_vref_l           :  std_logic := '0';   
    SIGNAL switch_region_d          :  std_logic := '0';   
    SIGNAL switch_region            :  std_logic := '0';   
    SIGNAL cmpup                    :  std_logic := '0';   
    SIGNAL cmpdn                    :  std_logic := '0';   
    SIGNAL rt_sm_done_d             :  std_logic := '0';   
    SIGNAL rt_sm_done               :  std_logic := '0';   
    -- cnt
    SIGNAL p_cnt_d                  :  std_logic_vector(2 DOWNTO 0) := "000";   
    SIGNAL p_cnt                    :  std_logic_vector(2 DOWNTO 0) := "000";   
    SIGNAL n_cnt_d                  :  std_logic_vector(2 DOWNTO 0) := "000";   
    SIGNAL n_cnt                    :  std_logic_vector(2 DOWNTO 0) := "000";   
    SIGNAL p_cnt_sub_d              :  std_logic := '0';   
    SIGNAL p_cnt_sub                :  std_logic := '0';   
    SIGNAL n_cnt_sub_d              :  std_logic := '0';   
    SIGNAL n_cnt_sub                :  std_logic := '0';   

BEGIN
    -- primary output - MSB is sign bit
    rtoffsetp <= p_cnt_sub & p_cnt ;
    rtoffsetn <= n_cnt_sub & n_cnt ;
    caldone   <= caldone_sig;
    caldone_sig <= rt_sm_done WHEN (rtena = '1') ELSE '1';

    sel_rup_vref <= sel_rup_vref_h & sel_rup_vref_m & sel_rup_vref_l ;
    sel_rdn_vref <= sel_rdn_vref_h & sel_rdn_vref_m & sel_rdn_vref_l ;

    -- input interface
    nclr <= NOT clr ;
    rtcalclk <= ((rscaldone AND clken) AND (NOT caldone_sig)) AND clk ;

    -- latch registers - rising on everything except cmpup and cmpdn
    -- cmpup/dn
    
    PROCESS
    BEGIN
        WAIT UNTIL (rtcalclk'EVENT AND rtcalclk = '0') OR (nclr'EVENT AND nclr = '0');
        IF (nclr = '0') THEN
            cmpup <= '0';    
            cmpdn <= '0';    
        ELSE
            cmpup <= rup;    
            cmpdn <= rdn;    
        END IF;
    END PROCESS;

    -- other regisers
    
    PROCESS
    BEGIN
        WAIT UNTIL (rtcalclk'EVENT AND rtcalclk = '1') OR (clr'EVENT AND clr = '1');
        IF (clr = '1') THEN
            current_state <= STRATIXIII_RTOCT_WAIT;    
            switch_region <= '0';    
            rt_sm_done <= '0'; 
            p_cnt <= "000";    
            p_cnt_sub <= '0';    
            n_cnt <= "000";    
            n_cnt_sub <= '0';    
            sel_rup_vref_h <= '0';    
            sel_rup_vref_m <= '1';    
            sel_rup_vref_l <= '0';    
            sel_rdn_vref_h <= '0';    
            sel_rdn_vref_m <= '1';    
            sel_rdn_vref_l <= '0';    
        ELSE
            current_state <= next_state;    
            switch_region <= switch_region_d;    
            rt_sm_done <= rt_sm_done_d;   
            p_cnt <= p_cnt_d;    
            p_cnt_sub <= p_cnt_sub_d;    
            n_cnt <= n_cnt_d;    
            n_cnt_sub <= n_cnt_sub_d;    
            sel_rup_vref_h <= sel_rup_vref_h_d;    
            sel_rup_vref_m <= sel_rup_vref_m_d;    
            sel_rup_vref_l <= sel_rup_vref_l_d;    
            sel_rdn_vref_h <= sel_rdn_vref_h_d;    
            sel_rdn_vref_m <= sel_rdn_vref_m_d;    
            sel_rdn_vref_l <= sel_rdn_vref_l_d;    
        END IF;
    END PROCESS;

    -- state machine
    
    PROCESS(current_state, rtena, cmpup, cmpdn, p_cnt, n_cnt, switch_region)
    variable p_cnt_d_var, n_cnt_d_var : std_logic_vector(2 DOWNTO 0);
    variable p_cnt_sub_d_var, n_cnt_sub_d_var : std_logic;
    BEGIN
        p_cnt_d_var := p_cnt;    
        n_cnt_d_var := n_cnt;    
        p_cnt_sub_d_var := '0';    
        n_cnt_sub_d_var := '0';    
        CASE current_state IS
            WHEN STRATIXIII_RTOCT_WAIT =>
                        IF (rtena = '0') THEN
                            next_state <= STRATIXIII_RTOCT_WAIT;    
                        ELSE
                            next_state <= RUP_VREF_M_RDN_VER_M;    
                            sel_rup_vref_h_d <= '0';    
                            sel_rup_vref_m_d <= '1';    
                            sel_rup_vref_l_d <= '0';    
                            sel_rdn_vref_h_d <= '0';    
                            sel_rdn_vref_m_d <= '1';    
                            sel_rdn_vref_l_d <= '0';    
                        END IF;
            WHEN RUP_VREF_M_RDN_VER_M =>
                        IF (cmpup = '0' AND cmpdn = '0') THEN
                            next_state <= RUP_VREF_L_RDN_VER_L;    
                            sel_rup_vref_h_d <= '0';    
                            sel_rup_vref_m_d <= '0';    
                            sel_rup_vref_l_d <= '1';    
                            sel_rdn_vref_h_d <= '0';    
                            sel_rdn_vref_m_d <= '0';    
                            sel_rdn_vref_l_d <= '1';    
                        ELSE
                            IF (cmpup = '1' AND cmpdn = '1') THEN
                                next_state <= RUP_VREF_H_RDN_VER_H;    
                                sel_rup_vref_h_d <= '1';    
                                sel_rup_vref_m_d <= '0';    
                                sel_rup_vref_l_d <= '0';    
                                sel_rdn_vref_h_d <= '1';    
                                sel_rdn_vref_m_d <= '0';    
                                sel_rdn_vref_l_d <= '0';    
                            ELSE
                                IF (cmpup = '1' AND cmpdn = '0') THEN
                                    next_state <= STRATIXIII_RTOCT_INC_PN;
                                    p_cnt_d_var := p_cnt_d_var + 1;
                                    p_cnt_sub_d_var := '0';    
                                    n_cnt_d_var := n_cnt_d_var + 1;
                                    n_cnt_sub_d_var := '0';    
                                ELSE
                                    IF (cmpup = '0' AND cmpdn = '1') THEN
                                        next_state <= STRATIXIII_RTOCT_DEC_PN;    
                                        p_cnt_d_var := p_cnt_d_var + 1;
                                        p_cnt_sub_d_var := '1';    
                                        n_cnt_d_var := n_cnt_d_var + 1;
                                        n_cnt_sub_d_var := '1';    
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
            WHEN RUP_VREF_L_RDN_VER_L =>
                        IF (cmpup = '1' AND cmpdn = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (cmpup = '0') THEN
                                next_state <= STRATIXIII_RTOCT_DEC_N;    
                                n_cnt_d_var := n_cnt_d_var + 1;
                                n_cnt_sub_d_var := '1';    
                            ELSE
                                IF (cmpup = '1' AND cmpdn = '0') THEN
                                    next_state <= STRATIXIII_RTOCT_INC_P;    
                                    p_cnt_d_var := p_cnt_d_var + 1;
                                    p_cnt_sub_d_var := '0';    
                                END IF;
                            END IF;
                        END IF;
            WHEN RUP_VREF_H_RDN_VER_H =>
                        IF (cmpup = '0' AND cmpdn = '0') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (cmpup = '1') THEN
                                next_state <= STRATIXIII_RTOCT_INC_N;    
                                n_cnt_d_var := n_cnt_d_var + 1;
                                n_cnt_sub_d_var := '0';    
                            ELSE
                                IF (cmpup = '0' AND cmpdn = '1') THEN
                                    next_state <= STRATIXIII_RTOCT_DEC_P;    
                                    p_cnt_d_var := p_cnt_d_var + 1;
                                    p_cnt_sub_d_var := '1';    
                                END IF;
                            END IF;
                        END IF;
            WHEN RUP_VREF_L_RDN_VER_H =>
                        IF (cmpup = '1' AND cmpdn = '0') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (cmpup = '1' AND switch_region = '1') THEN
                                next_state <= STRATIXIII_RTOCT_DEC_P;    
                                p_cnt_d_var := p_cnt_d_var + 1;
                                p_cnt_sub_d_var := '1';    
                            ELSE
                                IF (cmpup = '0' AND switch_region = '1') THEN
                                    next_state <= STRATIXIII_RTOCT_DEC_N;    
                                    n_cnt_d_var := n_cnt_d_var + 1;
                                    n_cnt_sub_d_var := '1';    
                                ELSE
                                    IF ((switch_region = '0') AND (cmpup = '0' OR cmpdn = '1')) THEN
                                        next_state <= STRATIXIII_RTOCT_SWITCH_REG;    
                                        switch_region_d <= '1';    
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
            WHEN RUP_VREF_H_RDN_VER_L =>
                        IF (cmpup = '0' AND cmpdn = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (cmpup = '1' AND switch_region = '1') THEN
                                next_state <= STRATIXIII_RTOCT_INC_N;    
                                n_cnt_d_var := n_cnt_d_var + 1;
                                n_cnt_sub_d_var := '0';    
                            ELSE
                                IF (cmpup = '0' AND switch_region = '1') THEN
                                    next_state <= STRATIXIII_RTOCT_INC_P;    
                                    p_cnt_d_var := p_cnt_d_var + 1;
                                    p_cnt_sub_d_var := '0';    
                                ELSE
                                    IF ((switch_region = '0') AND (cmpup = '1' OR cmpdn = '0')) THEN
                                        next_state <= STRATIXIII_RTOCT_SWITCH_REG;    
                                        switch_region_d <= '1';    
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
            WHEN STRATIXIII_RTOCT_INC_PN =>
                        IF (cmpup = '1' AND cmpdn = '0') THEN
                            next_state <= STRATIXIII_RTOCT_INC_PN;    
                            p_cnt_d_var := p_cnt_d_var + 1;
                            p_cnt_sub_d_var := '0';    
                            n_cnt_d_var := n_cnt_d_var + 1;
                            n_cnt_sub_d_var := '0';    
                        ELSE
                            IF (cmpup = '0' AND cmpdn = '0') THEN
                                next_state <= RUP_VREF_L_RDN_VER_L;    
                                sel_rup_vref_h_d <= '0';    
                                sel_rup_vref_m_d <= '0';    
                                sel_rup_vref_l_d <= '1';    
                                sel_rdn_vref_h_d <= '0';    
                                sel_rdn_vref_m_d <= '0';    
                                sel_rdn_vref_l_d <= '1';    
                            ELSE
                                IF (cmpup = '1' AND cmpdn = '1') THEN
                                    next_state <= RUP_VREF_H_RDN_VER_H;    
                                    sel_rup_vref_h_d <= '1';    
                                    sel_rup_vref_m_d <= '0';    
                                    sel_rup_vref_l_d <= '0';    
                                    sel_rdn_vref_h_d <= '1';    
                                    sel_rdn_vref_m_d <= '0';    
                                    sel_rdn_vref_l_d <= '0';    
                                ELSE
                                    IF (cmpup = '0' AND cmpdn = '1') THEN
                                        next_state <= RUP_VREF_L_RDN_VER_H;    
                                        sel_rup_vref_h_d <= '0';    
                                        sel_rup_vref_m_d <= '0';    
                                        sel_rup_vref_l_d <= '1';    
                                        sel_rdn_vref_h_d <= '1';    
                                        sel_rdn_vref_m_d <= '0';    
                                        sel_rdn_vref_l_d <= '0';    
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
            WHEN STRATIXIII_RTOCT_DEC_PN =>
                        IF (cmpup = '0' AND cmpdn = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DEC_PN;    
                            p_cnt_d_var := p_cnt_d_var + 1;
                            p_cnt_sub_d_var := '1';    
                            n_cnt_d_var := n_cnt_d_var + 1;
                            n_cnt_sub_d_var := '1';    
                        ELSE
                            IF (cmpup = '0' AND cmpdn = '0') THEN
                                next_state <= RUP_VREF_L_RDN_VER_L;    
                                sel_rup_vref_h_d <= '0';    
                                sel_rup_vref_m_d <= '0';    
                                sel_rup_vref_l_d <= '1';    
                                sel_rdn_vref_h_d <= '0';    
                                sel_rdn_vref_m_d <= '0';    
                                sel_rdn_vref_l_d <= '1';    
                            ELSE
                                IF (cmpup = '1' AND cmpdn = '1') THEN
                                    next_state <= RUP_VREF_H_RDN_VER_H;    
                                    sel_rup_vref_h_d <= '1';    
                                    sel_rup_vref_m_d <= '0';    
                                    sel_rup_vref_l_d <= '0';    
                                    sel_rdn_vref_h_d <= '1';    
                                    sel_rdn_vref_m_d <= '0';    
                                    sel_rdn_vref_l_d <= '0';    
                                ELSE
                                    IF (cmpup = '1' AND cmpdn = '0') THEN
                                        next_state <= RUP_VREF_H_RDN_VER_L;    
                                        sel_rup_vref_h_d <= '1';    
                                        sel_rup_vref_m_d <= '0';    
                                        sel_rup_vref_l_d <= '0';    
                                        sel_rdn_vref_h_d <= '0';    
                                        sel_rdn_vref_m_d <= '0';    
                                        sel_rdn_vref_l_d <= '1';    
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
			----------------- same action begin 
            WHEN STRATIXIII_RTOCT_INC_P =>
                        IF (switch_region = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (switch_region = '0') THEN
                                next_state <= RUP_VREF_M_RDN_VER_M;    
                                sel_rup_vref_h_d <= '0';    
                                sel_rup_vref_m_d <= '1';    
                                sel_rup_vref_l_d <= '0';    
                                sel_rdn_vref_h_d <= '0';    
                                sel_rdn_vref_m_d <= '1';    
                                sel_rdn_vref_l_d <= '0';    
                            END IF;
                        END IF;
            WHEN STRATIXIII_RTOCT_DEC_P =>
                        IF (switch_region = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (switch_region = '0') THEN
                                next_state <= RUP_VREF_M_RDN_VER_M;    
                                sel_rup_vref_h_d <= '0';    
                                sel_rup_vref_m_d <= '1';    
                                sel_rup_vref_l_d <= '0';    
                                sel_rdn_vref_h_d <= '0';    
                                sel_rdn_vref_m_d <= '1';    
                                sel_rdn_vref_l_d <= '0';    
                            END IF;
                        END IF;
            WHEN STRATIXIII_RTOCT_INC_N =>
                        IF (switch_region = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (switch_region = '0') THEN
                                next_state <= RUP_VREF_M_RDN_VER_M;    
                                sel_rup_vref_h_d <= '0';    
                                sel_rup_vref_m_d <= '1';    
                                sel_rup_vref_l_d <= '0';    
                                sel_rdn_vref_h_d <= '0';    
                                sel_rdn_vref_m_d <= '1';    
                                sel_rdn_vref_l_d <= '0';    
                            END IF;
                        END IF;
            WHEN STRATIXIII_RTOCT_DEC_N =>
                        IF (switch_region = '1') THEN
                            next_state <= STRATIXIII_RTOCT_DONE;    
                        ELSE
                            IF (switch_region = '0') THEN
                                next_state <= RUP_VREF_M_RDN_VER_M;    
                                sel_rup_vref_h_d <= '0';    
                                sel_rup_vref_m_d <= '1';    
                                sel_rup_vref_l_d <= '0';    
                                sel_rdn_vref_h_d <= '0';    
                                sel_rdn_vref_m_d <= '1';    
                                sel_rdn_vref_l_d <= '0';    
                            END IF;
                        END IF;
			----------------- same action end 
            WHEN STRATIXIII_RTOCT_SWITCH_REG =>
                        next_state <= RUP_VREF_M_RDN_VER_M;    
                        sel_rup_vref_h_d <= '0';    
                        sel_rup_vref_m_d <= '1';    
                        sel_rup_vref_l_d <= '0';    
                        sel_rdn_vref_h_d <= '0';    
                        sel_rdn_vref_m_d <= '1';    
                        sel_rdn_vref_l_d <= '0';    
            WHEN STRATIXIII_RTOCT_DONE =>
                        next_state <= STRATIXIII_RTOCT_DONE;    
                        rt_sm_done_d <= '1';    
            WHEN OTHERS  =>
                        next_state <= STRATIXIII_RTOCT_WAIT;    
            
        END CASE;
        -- case(current_state)
        
        -- schedule the outputs
        p_cnt_d <= p_cnt_d_var;    
        n_cnt_d <= n_cnt_d_var;    
        p_cnt_sub_d <= p_cnt_sub_d_var;    
        n_cnt_sub_d <= n_cnt_sub_d_var;    
        
    END PROCESS;

END stratixiii_rt_sm_rtl;

-------------------------------------------------------------------------------
-- Module Name: stratixiii_termination_aux_clock_div
-- Description: auxilary clock divider module
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY stratixiii_termination_aux_clock_div IS
    GENERIC (
        clk_divide_by : INTEGER := 1;
        extra_latency : INTEGER := 0
    );
    PORT (
        clk                     : IN STD_LOGIC;   
        reset                   : IN STD_LOGIC := '0';   
        clkout                  : OUT STD_LOGIC
    );   
END stratixiii_termination_aux_clock_div;

ARCHITECTURE oct_clock_div_arch OF stratixiii_termination_aux_clock_div IS  
    SIGNAL clk_edges                :  INTEGER := -1;     
    SIGNAL div_n_register           :  STD_LOGIC_VECTOR(2 * extra_latency DOWNTO 0)
                                                    := (OTHERS => '0');     

BEGIN
    PROCESS(clk,reset)
    VARIABLE div_n : STD_LOGIC_VECTOR(2 * extra_latency DOWNTO 0) := (OTHERS => '0');
    VARIABLE m : INTEGER := 0;
    VARIABLE running_clk_edge : INTEGER := -1;
    BEGIN
        running_clk_edge := clk_edges;
        IF (reset = '1') THEN
            clk_edges <= -1;
            m := 0;    
            div_n := (OTHERS => '0');  
        ELSE
        IF (clk'EVENT) THEN
            IF (running_clk_edge = -1) THEN
                m := 0;
                div_n(0) := clk;
                IF (clk = '1') THEN running_clk_edge := 0; END IF;
            ELSIF (running_clk_edge mod clk_divide_by = 0) THEN
                div_n(0) := NOT div_n(0);
            END IF;
            IF (running_clk_edge >= 0 OR clk = '1') THEN 
                clk_edges <= (running_clk_edge + 1) mod (2 * clk_divide_by);
            END IF;
        END IF;
        
        END IF;   
        m := 0;
        div_n_register(m) <= div_n(m); 
        WHILE (m < 2 * extra_latency) LOOP
            div_n_register(m+1) <=  div_n_register(m);  
            m := m + 1;
        END LOOP;
        
    END PROCESS;
    clkout <= div_n_register(2 * extra_latency);

END oct_clock_div_arch;

-------------------------------------------------------------------------------
--
-- Module Name : stratixiii_termination
--
-- Description : Stratix III Termination Atom 
--               Verilog simulation model 
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.ALL;
USE IEEE.VITAL_Primitives.ALL;
use work.stratixiii_atom_pack.all;

USE WORK.stratixiii_termination_aux_clock_div;
USE WORK.stratixiii_rt_sm;

ENTITY stratixiii_termination IS
    GENERIC (
        runtime_control                :  STRING := "false";    
        allow_serial_data_from_core    :  STRING := "false";    
        power_down                     :  STRING := "true";    
        enable_parallel_termination    :  STRING := "false";    
        test_mode                      :  STRING := "false"; 
        enable_calclk_divider          :  STRING := "false";  -- replaced by below
        clock_divider_enable           :  STRING := "false"; 
        enable_pwrupmode_enser_for_usrmode :  STRING := "false"; 
        bypass_enser_logic             :  STRING := "false"; 
        bypass_rt_calclk               :  STRING := "false"; 
        enable_rt_scan_mode            :  STRING := "false"; 
        enable_loopback                :  STRING := "false";   
        
        force_rtcalen_for_pllbiasen    :  STRING := "false"; 
        enable_rt_sm_loopback          :  STRING := "false";   
        select_vrefl_values            :  integer := 0;
        select_vrefh_values            :  integer := 0;
        divide_intosc_by               :  integer := 2;
        use_usrmode_clear_for_configmode : STRING := "false"; 
         
        tipd_rup                       : VitalDelayType01 := DefpropDelay01;
        tipd_rdn                       : VitalDelayType01 := DefpropDelay01;
        tipd_terminationclock          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationclear          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationenable         : VitalDelayType01 := DefpropDelay01;
        tipd_serializerenable          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationcontrolin      : VitalDelayType01 := DefpropDelay01;
        tipd_otherserializerenable     : VitalDelayArrayType01(8 downto 0) := (OTHERS => DefPropDelay01);
        lpm_type                       :  STRING := "stratixiii_termination");    
    PORT (
        rup                     : IN std_logic := '0';   
        rdn                     : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        terminationclear        : IN std_logic := '0';   
        terminationenable       : IN std_logic := '1';   
        serializerenable        : IN std_logic := '0';   
        terminationcontrolin    : IN std_logic := '0';   
        scanin                  : IN std_logic := '0';   
        scanen                  : IN std_logic := '0';   
        otherserializerenable   : IN std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');   
        devclrn                 : IN std_logic := '1';   
        devpor                  : IN std_logic := '1';   
        incrup                  : OUT std_logic;   
        incrdn                  : OUT std_logic;   
        serializerenableout     : OUT std_logic;   
        terminationcontrol      : OUT std_logic;   
        terminationcontrolprobe : OUT std_logic;   
        scanout                 : OUT std_logic;   
        shiftregisterprobe      : OUT std_logic);   
END stratixiii_termination;

ARCHITECTURE stratixiii_oct_arch OF stratixiii_termination IS

    COMPONENT stratixiii_termination_aux_clock_div
        GENERIC (
            clk_divide_by : INTEGER := 1;
            extra_latency : INTEGER := 0
        );
        PORT (
            clk                     : IN STD_LOGIC;
            reset                   : IN STD_LOGIC := '0';
            clkout                  : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT stratixiii_rt_sm
        PORT (
            rup                     : IN std_logic;   
            rdn                     : IN std_logic;   
            clk                     : IN std_logic;   
            clken                   : IN std_logic;   
            clr                     : IN std_logic;   
            rtena                   : IN std_logic;   
            rscaldone               : IN std_logic;   
            rtoffsetp               : OUT std_logic_vector(3 DOWNTO 0);   
            rtoffsetn               : OUT std_logic_vector(3 DOWNTO 0);   
            caldone                 : OUT std_logic;   
            sel_rup_vref            : OUT std_logic_vector(2 DOWNTO 0);   
            sel_rdn_vref            : OUT std_logic_vector(2 DOWNTO 0)
        );   
    END COMPONENT;

    -- HW outputs
    SIGNAL compout_rup_core         :  std_logic;   
    SIGNAL compout_rdn_core         :  std_logic;   
    SIGNAL ser_data_io              :  std_logic;   
    SIGNAL ser_data_core            :  std_logic;   
    -- HW inputs
    SIGNAL usr_clk                  :  std_logic;   
    SIGNAL cal_clk                  :  std_logic;   
    SIGNAL rscal_clk                :  std_logic;   
    SIGNAL cal_clken                :  std_logic;   
    SIGNAL cal_nclr                 :  std_logic;   
    -- legality check on enser
    SIGNAL enser_checked            :  std_logic := '0';   
    -- Shift Register
    SIGNAL sreg_bit_out             :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL sreg_bit_out_tmp0        :  std_logic := '0';   
    SIGNAL sreg_vshift_bit_tmp      :  std_logic := '0';   
    SIGNAL sreg_vshift_bit_out      :  std_logic := '0';   
    SIGNAL sreg_rscaldone_prev      :  std_logic := '0';   
    SIGNAL sreg_rscaldone_prev1     :  std_logic := '0';   
    SIGNAL sregn_rscaldone_out      :  std_logic := '0';   
    SIGNAL sreg_bit6_prev           :  std_logic := '1';   
    -- nreg before SA-ADC
    SIGNAL regn_rup_in              :  std_logic;   
    SIGNAL regn_rdn_in              :  std_logic;   
    SIGNAL regn_compout_rup         :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL regn_compout_rdn         :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    -- SA-ADC
    SIGNAL sa_octcaln_out           :  std_logic_vector(6 DOWNTO 0);   --  RUP - NMOS
    SIGNAL sa_octcalp_out           :  std_logic_vector(6 DOWNTO 0);   --  RDN - PMOS
    SIGNAL sa_octcaln_in            :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL sa_octcalp_in            :  std_logic_vector(6 DOWNTO 0);   
    -- ENSER
    SIGNAL enser_out                :  std_logic;   
    SIGNAL enser_gen_out            :  std_logic;   
    SIGNAL enser_cnt                :  INTEGER := 0;   
    -- RT State Machine
    SIGNAL rtsm_rup_in              :  std_logic;   
    SIGNAL rtsm_rdn_in              :  std_logic;   
    SIGNAL rtsm_rtena_in            :  std_logic;   
    SIGNAL rtsm_rscaldone_in        :  std_logic;   
    SIGNAL rtsm_caldone_out         :  std_logic;   
    SIGNAL rtsm_rtoffsetp_out       :  std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rtsm_rtoffsetn_out       :  std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rtsm_sel_rup_vref_out    :  std_logic_vector(2 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rtsm_sel_rdn_vref_out    :  std_logic_vector(2 DOWNTO 0) := (OTHERS => '0');   
    -- RT Adder/Sub
    SIGNAL rtas_rs_rpcdp_in         :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL rtas_rs_rpcdn_in         :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL rtas_rtoffsetp_in        :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rtas_rtoffsetn_in        :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rtas_rs_rpcdp_out        :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL rtas_rs_rpcdn_out        :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL rtas_rt_rpcdp_out        :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rtas_rt_rpcdn_out        :  std_logic_vector(6 DOWNTO 0) := (OTHERS => '0');   
    -- P2S
    SIGNAL p2s_rs_rpcdp_in          :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL p2s_rs_rpcdn_in          :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL p2s_rt_rpcdp_in          :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL p2s_rt_rpcdn_in          :  std_logic_vector(6 DOWNTO 0);   
    SIGNAL p2s_enser_in             :  std_logic;   
    SIGNAL p2s_clk_in               :  std_logic;   
    SIGNAL p2s_ser_data_out         :  std_logic;   
    SIGNAL p2s_parallel_reg         :  std_logic_vector(27 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL p2s_serial_reg           :  std_logic := '0';   
    SIGNAL p2s_index                :  integer   := 27;   

    -- used to set SA outputs 
    SIGNAL temp_xhdl10              :  std_logic;
    SIGNAL temp_xhdl12              :  std_logic;
    SIGNAL temp_xhdl14              :  std_logic;
    SIGNAL temp_xhdl16              :  std_logic;
    SIGNAL temp_xhdl18              :  std_logic;
    SIGNAL temp_xhdl20              :  std_logic;
    SIGNAL temp_xhdl22              :  std_logic;
    SIGNAL temp_xhdl24              :  std_logic;
    SIGNAL temp_xhdl26              :  std_logic;
    SIGNAL temp_xhdl28              :  std_logic;
    SIGNAL temp_xhdl30              :  std_logic;
    SIGNAL temp_xhdl32              :  std_logic;
    SIGNAL temp_xhdl34              :  std_logic;
    SIGNAL temp_xhdl36              :  std_logic;
    
    SIGNAL MY_GND                   :  std_logic := '0';  
    
    -- timing
    SIGNAL rup_ipd                     : std_logic;   
    SIGNAL rdn_ipd                     : std_logic;   
    SIGNAL terminationclock_ipd        : std_logic;   
    SIGNAL terminationclear_ipd        : std_logic;   
    SIGNAL terminationenable_ipd       : std_logic;   
    SIGNAL serializerenable_ipd        : std_logic;   
    SIGNAL terminationcontrolin_ipd    : std_logic;   
    SIGNAL otherserializerenable_ipd   : std_logic_vector(8 DOWNTO 0);   

BEGIN
    -- primary outputs
    incrup <= terminationenable_ipd WHEN (enable_loopback = "true") ELSE compout_rup_core;
    incrdn <= terminationclear_ipd  WHEN (enable_loopback = "true") ELSE compout_rdn_core;
    terminationcontrol <= ser_data_io;
    terminationcontrolprobe <= serializerenable_ipd  WHEN (enable_loopback = "true") ELSE ser_data_core;
    shiftregisterprobe <= terminationclock_ipd  WHEN (enable_loopback = "true") ELSE sreg_vshift_bit_out;
    serializerenableout <= serializerenable;

    compout_rup_core <= rup ;
    compout_rdn_core <= rdn ;
    ser_data_io <= terminationcontrolin WHEN (allow_serial_data_from_core = "true") ELSE p2s_ser_data_out;
    ser_data_core <= p2s_ser_data_out ;

    -- primary inputs
    usr_clk <= terminationclock ;
    cal_nclr <= '1' WHEN (terminationclear = '1') ELSE '0';
    cal_clken <= '1' WHEN (terminationenable = '1' AND serializerenable = '1') ELSE '0';

    -- divide by 100 clock
    m_gen_calclk : stratixiii_termination_aux_clock_div 
        GENERIC MAP (
            clk_divide_by => 100,
            extra_latency => 0)
        PORT MAP (
            clk => usr_clk,
            reset => MY_GND,
            clkout => cal_clk);   
    
    rscal_clk <= cal_clk AND (NOT sregn_rscaldone_out) ;

    -- legality check on enser
    
    PROCESS
    BEGIN
        WAIT UNTIL (usr_clk'EVENT AND usr_clk = '1');
        IF (serializerenable = '1' AND cal_clken = '0') THEN
            IF (otherserializerenable(0) = '1' OR 
                otherserializerenable(1) = '1' OR 
                otherserializerenable(2) = '1' OR 
                otherserializerenable(3) = '1' OR 
                otherserializerenable(4) = '1' OR 
                otherserializerenable(5) = '1' OR 
                otherserializerenable(6) = '1' OR 
                otherserializerenable(7) = '1' OR 
                otherserializerenable(8) = '1') THEN
                IF (enser_checked = '0') THEN
                    assert false 
                    report "serializizerable and some bits of otherserializerenable are asserted at data transfer time"
                    severity warning;
                    enser_checked <= '1';    
                END IF;
            ELSE
                enser_checked <= '0';    --  for another check       
            END IF;
        ELSE
            enser_checked <= '0';    --  for another check           
        END IF;
    END PROCESS;

    -- SHIFT regiter
    
    PROCESS
    BEGIN
        WAIT UNTIL (rscal_clk'EVENT AND rscal_clk = '1') OR (cal_nclr'EVENT AND cal_nclr = '1');
        IF (cal_nclr = '1') THEN
            sreg_bit6_prev <= '1';    
            sreg_bit_out <= "0000000";    
            sreg_vshift_bit_out <= '0';    
            sreg_vshift_bit_tmp <= '0';    
            sreg_bit_out_tmp0 <= '0';    
            sreg_rscaldone_prev <= '0';    
            sreg_rscaldone_prev1 <= '0';    
        ELSE
            IF (cal_clken = '1') THEN
                sreg_bit_out(6) <= sreg_bit6_prev;    
                sreg_bit_out(5) <= sreg_bit_out(6);    
                sreg_bit_out(4) <= sreg_bit_out(5);    
                sreg_bit_out(3) <= sreg_bit_out(4);    
                sreg_bit_out(2) <= sreg_bit_out(3);    
                sreg_bit_out(1) <= sreg_bit_out(2);    
                sreg_bit_out_tmp0 <= sreg_bit_out(1);    
                sreg_vshift_bit_tmp <= sreg_bit_out_tmp0;    
                sreg_bit_out(0) <= sreg_bit_out(1) OR sreg_vshift_bit_tmp;    
                sreg_vshift_bit_out <= sreg_bit_out_tmp0 OR sreg_vshift_bit_tmp;    
                sreg_bit6_prev <= '0';    
            END IF;
        END IF;
        
        -- might falling outside of 10 cycles    
        IF (sreg_vshift_bit_tmp = '1') THEN
            sreg_rscaldone_prev <= '1';    
        END IF;
        sreg_rscaldone_prev1 <= sreg_rscaldone_prev;  
          
    END PROCESS;

    PROCESS
    BEGIN
        WAIT UNTIL (rscal_clk'EVENT AND rscal_clk = '0') OR (cal_nclr'EVENT AND cal_nclr = '1');
        IF (cal_nclr = '1') THEN
            sregn_rscaldone_out <= '0';    
        ELSE -- if (cal_clken == 1'b1) - outside of 10 cycles
            IF (sreg_rscaldone_prev1 = '1' AND sregn_rscaldone_out = '0') THEN
                sregn_rscaldone_out <= '1';    
            END IF;
        END IF;
    END PROCESS;

    -- nreg and SA-ADC: 
    --
    --    RDN_vol < ref_voltage < RUP_voltage
    --    after reset, ref_voltage=VCCN/2; after ref_voltage_shift, ref_voltage=neighbor(VCCN/2)
    --    at 0 code, RUP=VCCN so voltage_compare_out for RUP = 0
    --               RDN=GND  so voltage compare out for RDN = 0
    regn_rup_in <= rup ;
    regn_rdn_in <= rdn ;

    PROCESS
    BEGIN
        WAIT UNTIL (cal_nclr'EVENT AND cal_nclr = '1') OR (rscal_clk'EVENT AND rscal_clk = '0');
        IF (cal_nclr = '1') THEN
            regn_compout_rup <= "0000000";    
            regn_compout_rdn <= "0000000";    
        ELSE
            -- rup            
            IF (sreg_bit_out(0) = '1') THEN
                regn_compout_rup(0) <= regn_rup_in;    
            END IF;
            IF (sreg_bit_out(1) = '1') THEN
                regn_compout_rup(1) <= regn_rup_in;    
            END IF;
            IF (sreg_bit_out(2) = '1') THEN
                regn_compout_rup(2) <= regn_rup_in;    
            END IF;
            IF (sreg_bit_out(3) = '1') THEN
                regn_compout_rup(3) <= regn_rup_in;    
            END IF;
            IF (sreg_bit_out(4) = '1') THEN
                regn_compout_rup(4) <= regn_rup_in;    
            END IF;
            IF (sreg_bit_out(5) = '1') THEN
                regn_compout_rup(5) <= regn_rup_in;    
            END IF;
            IF (sreg_bit_out(6) = '1') THEN
                regn_compout_rup(6) <= regn_rup_in;    
            END IF;
            -- rdn         
            IF (sreg_bit_out(0) = '1') THEN
                regn_compout_rdn(0) <= regn_rdn_in;    
            END IF;
            IF (sreg_bit_out(1) = '1') THEN
                regn_compout_rdn(1) <= regn_rdn_in;    
            END IF;
            IF (sreg_bit_out(2) = '1') THEN
                regn_compout_rdn(2) <= regn_rdn_in;    
            END IF;
            IF (sreg_bit_out(3) = '1') THEN
                regn_compout_rdn(3) <= regn_rdn_in;    
            END IF;
            IF (sreg_bit_out(4) = '1') THEN
                regn_compout_rdn(4) <= regn_rdn_in;    
            END IF;
            IF (sreg_bit_out(5) = '1') THEN
                regn_compout_rdn(5) <= regn_rdn_in;    
            END IF;
            IF (sreg_bit_out(6) = '1') THEN
                regn_compout_rdn(6) <= regn_rdn_in;    
            END IF;
        END IF;
    END PROCESS;
    
    sa_octcaln_in <= sreg_bit_out ;
    sa_octcalp_in <= sreg_bit_out ;
    
    
    -- RUP - octcaln_in == 1 = (pin_voltage < ref_voltage): clear the bit setting
    temp_xhdl10 <= '1' WHEN (sa_octcaln_in(0) = '1') ELSE sa_octcaln_out(0);
    sa_octcaln_out(0) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(0) = '1') ELSE temp_xhdl10;
    temp_xhdl12 <= '1' WHEN (sa_octcaln_in(1) = '1') ELSE sa_octcaln_out(1);
    sa_octcaln_out(1) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(1) = '1') ELSE temp_xhdl12;
    temp_xhdl14 <= '1' WHEN (sa_octcaln_in(2) = '1') ELSE sa_octcaln_out(2);
    sa_octcaln_out(2) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(2) = '1') ELSE temp_xhdl14;
    temp_xhdl16 <= '1' WHEN (sa_octcaln_in(3) = '1') ELSE sa_octcaln_out(3);
    sa_octcaln_out(3) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(3) = '1') ELSE temp_xhdl16;
    temp_xhdl18 <= '1' WHEN (sa_octcaln_in(4) = '1') ELSE sa_octcaln_out(4);
    sa_octcaln_out(4) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(4) = '1') ELSE temp_xhdl18;
    temp_xhdl20 <= '1' WHEN (sa_octcaln_in(5) = '1') ELSE sa_octcaln_out(5);
    sa_octcaln_out(5) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(5) = '1') ELSE temp_xhdl20;
    temp_xhdl22 <= '1' WHEN (sa_octcaln_in(6) = '1') ELSE sa_octcaln_out(6);
    sa_octcaln_out(6) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rup(6) = '1') ELSE temp_xhdl22;
    temp_xhdl24 <= '1' WHEN (sa_octcalp_in(0) = '1') ELSE sa_octcalp_out(0);
    sa_octcalp_out(0) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(0) = '1') ELSE temp_xhdl24;
    temp_xhdl26 <= '1' WHEN (sa_octcalp_in(1) = '1') ELSE sa_octcalp_out(1);
    sa_octcalp_out(1) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(1) = '1') ELSE temp_xhdl26;
    temp_xhdl28 <= '1' WHEN (sa_octcalp_in(2) = '1') ELSE sa_octcalp_out(2);
    sa_octcalp_out(2) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(2) = '1') ELSE temp_xhdl28;
    temp_xhdl30 <= '1' WHEN (sa_octcalp_in(3) = '1') ELSE sa_octcalp_out(3);
    sa_octcalp_out(3) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(3) = '1') ELSE temp_xhdl30;
    temp_xhdl32 <= '1' WHEN (sa_octcalp_in(4) = '1') ELSE sa_octcalp_out(4);
    sa_octcalp_out(4) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(4) = '1') ELSE temp_xhdl32;
    temp_xhdl34 <= '1' WHEN (sa_octcalp_in(5) = '1') ELSE sa_octcalp_out(5);
    sa_octcalp_out(5) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(5) = '1') ELSE temp_xhdl34;
    temp_xhdl36 <= '1' WHEN (sa_octcalp_in(6) = '1') ELSE sa_octcalp_out(6);
    sa_octcalp_out(6) <= '0' WHEN (cal_nclr = '1' OR regn_compout_rdn(6) = '1') ELSE temp_xhdl36;

    -- ENSER
    enser_out <= serializerenable WHEN (runtime_control = "true" OR bypass_enser_logic = "true") ELSE enser_gen_out;
    enser_gen_out <= '1' WHEN (enser_cnt > 0 AND enser_cnt < 31) ELSE '0';

    PROCESS
    BEGIN
        WAIT UNTIL (usr_clk'EVENT AND usr_clk = '1') OR (sregn_rscaldone_out'EVENT AND sregn_rscaldone_out = '1');
        IF (sregn_rscaldone_out = '0') THEN
            enser_cnt <= 0;    
        ELSE
            IF (enser_cnt < 63) THEN
                enser_cnt <= enser_cnt + 1;    
            END IF;
        END IF;
    END PROCESS;
    
    -- RT SM
    rtsm_rup_in <= rup ;
    rtsm_rdn_in <= rdn ;
    rtsm_rtena_in <= '1' WHEN (enable_parallel_termination = "true") ELSE '0';
    rtsm_rscaldone_in <= sregn_rscaldone_out ;

    m_rt_sm : stratixiii_rt_sm
        PORT MAP (
            rup => rtsm_rup_in,                     
            rdn => rtsm_rdn_in, 
            clk => cal_clk,      
            clken => cal_clken, 
            clr => cal_nclr,
            rtena => rtsm_rtena_in,                 
            rscaldone => rtsm_rscaldone_in,
            rtoffsetp => rtsm_rtoffsetp_out,        
            rtoffsetn => rtsm_rtoffsetn_out,
            caldone => rtsm_caldone_out,
            sel_rup_vref => rtsm_sel_rup_vref_out,  
            sel_rdn_vref => rtsm_sel_rdn_vref_out
        );
    
    -- RT Adder/Sub
    rtas_rs_rpcdp_in <= sa_octcalp_out ;
    rtas_rs_rpcdn_in <= sa_octcaln_out ;
    rtas_rtoffsetp_in <= "0000" & rtsm_rtoffsetp_out(2 DOWNTO 0);
    rtas_rtoffsetn_in <="0000" &  rtsm_rtoffsetn_out(2 DOWNTO 0);

    rtas_rs_rpcdp_out <= rtas_rs_rpcdp_in ;
    rtas_rs_rpcdn_out <= rtas_rs_rpcdn_in ;


    rtas_rt_rpcdn_out <= (rtas_rs_rpcdn_in + rtas_rtoffsetn_in) WHEN (rtsm_rtoffsetn_out(3) = '0') ELSE
                         (rtas_rs_rpcdn_in - rtas_rtoffsetn_in);
    rtas_rt_rpcdp_out <= (rtas_rs_rpcdp_in + rtas_rtoffsetp_in) WHEN (rtsm_rtoffsetp_out(3) = '0') ELSE
                         (rtas_rs_rpcdp_in - rtas_rtoffsetp_in);

    -- P2S   
    p2s_rs_rpcdp_in <= rtas_rs_rpcdp_out ;
    p2s_rs_rpcdn_in <= rtas_rs_rpcdn_out ;
    p2s_rt_rpcdp_in <= rtas_rt_rpcdp_out;
    p2s_rt_rpcdn_in <= rtas_rt_rpcdn_out;
    
    p2s_enser_in <= enser_out ;
    p2s_clk_in <= usr_clk ;
    p2s_ser_data_out <= p2s_serial_reg ;

    -- load - clken
    PROCESS
    BEGIN
        WAIT UNTIL (p2s_clk_in'EVENT AND p2s_clk_in = '1') OR (cal_nclr'EVENT AND cal_nclr = '1');
        IF (cal_nclr = '1') THEN
            p2s_parallel_reg <= "0000000000000000000000000000";    
        ELSE
            IF (cal_clken = '1') THEN
                p2s_parallel_reg <= p2s_rs_rpcdp_in & p2s_rs_rpcdn_in & p2s_rt_rpcdp_in & p2s_rt_rpcdn_in;    
            END IF;
        END IF;
    END PROCESS;

    -- shift - enser
    PROCESS
    BEGIN
        WAIT UNTIL (p2s_clk_in'EVENT AND p2s_clk_in = '1') OR (cal_nclr'EVENT AND cal_nclr = '1');
        IF (cal_nclr = '1') THEN
            p2s_serial_reg <= '0';    
            p2s_index <= 27;    
        ELSE
            IF (p2s_enser_in = '1' AND cal_clken = '0') THEN
                p2s_serial_reg <= p2s_parallel_reg(p2s_index);    
                IF (p2s_index > 0) THEN
                    p2s_index <= p2s_index - 1;    
                END IF;
            END IF;
        END IF;
    END PROCESS;


    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (rup_ipd,                      rup,                      tipd_rup);
        VitalWireDelay (rdn_ipd,                      rdn,                      tipd_rdn);
        VitalWireDelay (terminationclock_ipd,         terminationclock,         tipd_terminationclock);
        VitalWireDelay (terminationclear_ipd,         terminationclear,         tipd_terminationclear);
        VitalWireDelay (terminationenable_ipd,        terminationenable,        tipd_terminationenable);
        VitalWireDelay (serializerenable_ipd,         serializerenable,         tipd_serializerenable);
        VitalWireDelay (terminationcontrolin_ipd,     terminationcontrolin,     tipd_terminationcontrolin);
        VitalWireDelay (otherserializerenable_ipd(0), otherserializerenable(0), tipd_otherserializerenable(0));

        VitalWireDelay (otherserializerenable_ipd(1), otherserializerenable(1), tipd_otherserializerenable(1));
        VitalWireDelay (otherserializerenable_ipd(2), otherserializerenable(2), tipd_otherserializerenable(2));
        VitalWireDelay (otherserializerenable_ipd(3), otherserializerenable(3), tipd_otherserializerenable(3));
        VitalWireDelay (otherserializerenable_ipd(4), otherserializerenable(4), tipd_otherserializerenable(4));
        VitalWireDelay (otherserializerenable_ipd(5), otherserializerenable(5), tipd_otherserializerenable(5));
        VitalWireDelay (otherserializerenable_ipd(6), otherserializerenable(6), tipd_otherserializerenable(6));
        VitalWireDelay (otherserializerenable_ipd(7), otherserializerenable(7), tipd_otherserializerenable(7));
        VitalWireDelay (otherserializerenable_ipd(8), otherserializerenable(8), tipd_otherserializerenable(8));
    end block;

END stratixiii_oct_arch;

-------------------------------------------------------------------------------
--
-- Module Name : stratixiii_termination_logic
--
-- Description : Stratix III Termination Logic Atom 
--               Verilog simulation model 
--
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.VITAL_Timing.ALL;
USE IEEE.VITAL_Primitives.ALL;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_termination_logic IS
    GENERIC (
        tipd_serialloadenable          : VitalDelayType01 := DefpropDelay01;
        tipd_terminationclock          : VitalDelayType01 := DefpropDelay01;
        tipd_parallelloadenable        : VitalDelayType01 := DefpropDelay01;
        tipd_terminationdata           : VitalDelayType01 := DefpropDelay01;
        test_mode                      : string := "false";    
        lpm_type                       : string := "stratixiii_termination_logic");    
    PORT (
        serialloadenable        : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        parallelloadenable      : IN std_logic := '0';   
        terminationdata         : IN std_logic := '0';   
        devclrn                 : IN std_logic := '1';   
        devpor                  : IN std_logic := '1';   
        seriesterminationcontrol   : OUT std_logic_vector(13 DOWNTO 0);   
        parallelterminationcontrol : OUT std_logic_vector(13 DOWNTO 0));   
END stratixiii_termination_logic;

ARCHITECTURE stratixiii_oct_logic_arch OF stratixiii_termination_logic IS

    CONSTANT xhdl_timescale         : time := 1 ps;


    SIGNAL usr_clk                  :  std_logic;   
    SIGNAL rs_reg                   :  std_logic_vector(13 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL rt_reg                   :  std_logic_vector(13 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL hold_reg                 :  std_logic_vector(27 DOWNTO 0) := (OTHERS => '0');   
    SIGNAL shift_index              :  integer := 27;   

    -- timing
    SIGNAL serialloadenable_ipd     : std_logic;   
    SIGNAL terminationclock_ipd     : std_logic;   
    SIGNAL parallelloadenable_ipd   : std_logic;   
    SIGNAL terminationdata_ipd      : std_logic;   

BEGIN
    seriesterminationcontrol <= rs_reg;
    parallelterminationcontrol <= rt_reg;
    usr_clk <= terminationclock  AFTER 11 * xhdl_timescale;

    PROCESS
    BEGIN
        WAIT UNTIL (usr_clk'EVENT AND usr_clk = '1');
        IF (serialloadenable = '0') THEN
            shift_index <= 27;    
        ELSE
            hold_reg(shift_index) <= terminationdata;    
            IF (shift_index > 0) THEN
                shift_index <= shift_index - 1;    
            END IF;
        END IF;
    END PROCESS;

    PROCESS
    BEGIN
        WAIT UNTIL (parallelloadenable'EVENT AND parallelloadenable = '1');
        IF (parallelloadenable = '1') THEN
            rs_reg <= hold_reg(27 DOWNTO 14);    
            rt_reg <= hold_reg(13 DOWNTO 0);    
        END IF;
    END PROCESS;

    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (serialloadenable_ipd,   serialloadenable,   tipd_serialloadenable);
        VitalWireDelay (terminationclock_ipd,   terminationclock,   tipd_terminationclock);
        VitalWireDelay (parallelloadenable_ipd, parallelloadenable, tipd_parallelloadenable);
        VitalWireDelay (terminationdata_ipd,    terminationdata,    tipd_terminationdata);
    end block;

END stratixiii_oct_logic_arch;
-------------------------------------------------------------------------------
-- utilities common for ddr
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
package stratixiii_atom_ddr_pack is
    function dll_unsigned2bin (in_int : integer) return std_logic_vector;
end stratixiii_atom_ddr_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body stratixiii_atom_ddr_pack is

	-- truncate input integer to get 6 LSB bits
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

end stratixiii_atom_ddr_pack;

-------------------------------------------------------------------------------
-- auxilary module for ddr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY stratixiii_dll_gray_encoder IS
    GENERIC ( width : integer := 6 );
    PORT (    mbin  : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
              gout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
    );
END stratixiii_dll_gray_encoder;

ARCHITECTURE stratixiii_dll_gray_encoder_arch OF stratixiii_dll_gray_encoder IS

    SIGNAL greg : STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    gout <= greg;
    PROCESS(mbin)
        VARIABLE i : INTEGER := 0;
    BEGIN
        greg(width-1) <= mbin(width-1);
        IF (width > 1) THEN
            i := width - 2;
            WHILE (i >= 0) LOOP
                greg(i) <= mbin(i+1) XOR mbin(i);
                i := i - 1;
            END LOOP;
        END IF;
    END PROCESS;

END stratixiii_dll_gray_encoder_arch;

-------------------------------------------------------------------------------
-- auxilary module for ddr
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY stratixiii_dll_gray_decoder IS
    GENERIC ( width : integer := 6 );
    PORT (    gin   : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
              bout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
    );
END stratixiii_dll_gray_decoder;

ARCHITECTURE stratixiii_dll_gray_decoder_arch OF stratixiii_dll_gray_decoder IS

    SIGNAL breg : STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    bout <= breg;
    PROCESS(gin)
        VARIABLE i : INTEGER := 0;
        VARIABLE bvar : STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        bvar(width-1) := gin(width-1);
        IF (width > 1) THEN
            i := width - 2;
            WHILE (i >= 0) LOOP
                bvar(i) := bvar(i+1) XOR gin(i);
                i := i - 1;
            END LOOP;
        END IF;
        breg <= bvar;
     END PROCESS;

END stratixiii_dll_gray_decoder_arch;

-------------------------------------------------------------------------------
-- Module Name: stratixiii_ddr_delay_chain_s
-- Description: auxilary module - delay chain-setting
-------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use work.stratixiii_atom_pack.all;
use work.stratixiii_dll_gray_decoder;

ENTITY stratixiii_ddr_delay_chain_s IS
    GENERIC (
        use_phasectrlin : string  := "true";
        phase_setting   : integer :=  0;
        delay_buffer_mode               : string  := "high";
        sim_low_buffer_intrinsic_delay  : integer := 350;
        sim_high_buffer_intrinsic_delay : integer := 175;
        sim_buffer_delay_increment  : integer := 10;
        phasectrlin_limit           : integer := 7
    );
    PORT (
        clk         : IN std_logic := '0';
        delayctrlin : IN std_logic_vector(5 DOWNTO 0) := (OTHERS => '0');
        phasectrlin : IN std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
        delayed_clkout : OUT std_logic
    );
END stratixiii_ddr_delay_chain_s;

ARCHITECTURE stratixiii_ddr_delay_chain_s_arch OF stratixiii_ddr_delay_chain_s IS

    COMPONENT stratixiii_dll_gray_decoder
        GENERIC ( width : integer := 6 );
        PORT (    gin   : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
                  bout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk_delay     : INTEGER := 0;
    SIGNAL delayed_clk   : STD_LOGIC := '0';
    SIGNAL delayctrl_bin : STD_LOGIC_VECTOR (5 DOWNTO 0) := (OTHERS => '0');
    
    SIGNAL delayctrlin_in : STD_LOGIC_VECTOR (5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL phasectrlin_in : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    
BEGIN

    delayctrlin_in(0) <= '1'  WHEN (delayctrlin(0) = '1') ELSE '0';
    delayctrlin_in(1) <= '1'  WHEN (delayctrlin(1) = '1') ELSE '0';
    delayctrlin_in(2) <= '1'  WHEN (delayctrlin(2) = '1') ELSE '0';
    delayctrlin_in(3) <= '1'  WHEN (delayctrlin(3) = '1') ELSE '0';
    delayctrlin_in(4) <= '1'  WHEN (delayctrlin(4) = '1') ELSE '0';
    delayctrlin_in(5) <= '1'  WHEN (delayctrlin(5) = '1') ELSE '0';
    phasectrlin_in(0) <= '1'  WHEN (phasectrlin(0) = '1') ELSE '0';
    phasectrlin_in(1) <= '1'  WHEN (phasectrlin(1) = '1') ELSE '0';
    phasectrlin_in(2) <= '1'  WHEN (phasectrlin(2) = '1') ELSE '0';
    phasectrlin_in(3) <= '1'  WHEN (phasectrlin(3) = '1') ELSE '0';

    -- decoder
    mdr_delayctrl_in_dec : stratixiii_dll_gray_decoder
        GENERIC MAP (width => 6)
        PORT MAP (gin => delayctrlin_in, bout => delayctrl_bin);

    PROCESS(delayctrl_bin, phasectrlin_in)
        variable sim_intrinsic_delay : INTEGER := 0;
        variable acell_delay         : INTEGER := 0;
        variable delay_chain_len     : INTEGER := 0;
    BEGIN
        IF (delay_buffer_mode = "low") THEN
            sim_intrinsic_delay := sim_low_buffer_intrinsic_delay;
        ELSE 
            sim_intrinsic_delay := sim_high_buffer_intrinsic_delay;
        END IF;
        
        -- cell
        acell_delay := sim_intrinsic_delay + alt_conv_integer(delayctrl_bin) * sim_buffer_delay_increment;
        -- no of cells
        IF (use_phasectrlin = "false") THEN
            delay_chain_len := phase_setting;
        ELSIF (alt_conv_integer(phasectrlin_in) > phasectrlin_limit) THEN
            delay_chain_len := 0;
        ELSE
            delay_chain_len := alt_conv_integer(phasectrlin_in);
        END IF;
        -- total delay - added extra 1 ps for resolving racing
        clk_delay <= delay_chain_len * acell_delay + 1;
    
        IF ((use_phasectrlin = "true") AND (alt_conv_integer(phasectrlin_in) > phasectrlin_limit)) THEN
            assert false report "Warning: DDR phasesetting has invalid phasectrlin setting" severity warning;
        END IF;     
    
    END PROCESS; -- generating delays

	delayed_clk <= transport clk after (clk_delay * 1 ps);
	delayed_clkout <= delayed_clk;
    
END  stratixiii_ddr_delay_chain_s_arch;

-------------------------------------------------------------------------------
-- based on dffeas 
-------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

entity stratixiii_ddr_io_reg is
    generic(
        power_up : string := "DONT_CARE";
        is_wysiwyg : string := "false";
        x_on_violation : string := "on";
        tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_prn_q_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_asdata_q: VitalDelayType01 := DefPropDelay01;
        tipd_clk : VitalDelayType01 := DefPropDelay01;
        tipd_d : VitalDelayType01 := DefPropDelay01;
        tipd_asdata : VitalDelayType01 := DefPropDelay01;
        tipd_sclr : VitalDelayType01 := DefPropDelay01; 
        tipd_sload : VitalDelayType01 := DefPropDelay01;
        tipd_clrn : VitalDelayType01 := DefPropDelay01; 
        tipd_prn : VitalDelayType01 := DefPropDelay01; 
        tipd_aload : VitalDelayType01 := DefPropDelay01; 
        tipd_ena : VitalDelayType01 := DefPropDelay01; 
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*"
    );
    
    port(
        d : in std_logic := '0';
        clk : in std_logic := '0';
        ena : in std_logic := '1';
        clrn : in std_logic := '1';
        prn : in std_logic := '1';
        aload : in std_logic := '0';
        asdata : in std_logic := '1';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        devclrn : in std_logic := '1';
        devpor : in std_logic := '1';
        q : out std_logic
    );
    attribute VITAL_LEVEL0 of stratixiii_ddr_io_reg : entity is TRUE;
end stratixiii_ddr_io_reg;


architecture vital_stratixiii_ddr_io_reg of stratixiii_ddr_io_reg is
    attribute VITAL_LEVEL0 of vital_stratixiii_ddr_io_reg : architecture is TRUE;
    signal clk_ipd : std_logic;
    signal d_ipd : std_logic;
    signal d_dly : std_logic;
    signal asdata_ipd : std_logic;
    signal asdata_dly : std_logic;
    signal asdata_dly1 : std_logic;
    signal sclr_ipd : std_logic;
    signal sload_ipd : std_logic;
    signal clrn_ipd : std_logic;
    signal prn_ipd : std_logic;
    signal aload_ipd : std_logic;
    signal ena_ipd : std_logic;

begin

    d_dly <= d_ipd;
    asdata_dly <= asdata_ipd;
    asdata_dly1 <= asdata_dly;


    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (d_ipd, d, tipd_d);
        VitalWireDelay (asdata_ipd, asdata, tipd_asdata);
        VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
        VitalWireDelay (clrn_ipd, clrn, tipd_clrn);
        VitalWireDelay (prn_ipd, prn, tipd_prn);
        VitalWireDelay (aload_ipd, aload, tipd_aload);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process ( clk_ipd, d_dly, asdata_dly1,
                            sclr_ipd, sload_ipd, clrn_ipd, prn_ipd, aload_ipd,
                            ena_ipd, devclrn, devpor)
    
    variable Tviol_d_clk : std_ulogic := '0';
    variable Tviol_asdata_clk : std_ulogic := '0';
    variable Tviol_sclr_clk : std_ulogic := '0';
    variable Tviol_sload_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_asdata_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable q_VitalGlitchData : VitalGlitchDataType;
    
    variable iq : std_logic := '0';
    variable idata: std_logic := '0';
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';
    
    begin
      
        if (now = 0 ns) then
            if ((power_up = "low") or (power_up = "DONT_CARE")) then
                iq := '0';
            elsif (power_up = "high") then
                iq := '1';
            else
                iq := '0';
            end if;
        end if;

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then

            VitalSetupHoldCheck (
                Violation       => Tviol_d_clk,
                TimingData      => TimingData_d_clk,
                TestSignal      => d,
                TestSignalName  => "DATAIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_d_clk_noedge_posedge,
                SetupLow        => tsetup_d_clk_noedge_posedge,
                HoldHigh        => thold_d_clk_noedge_posedge,
                HoldLow         => thold_d_clk_noedge_posedge,
                CheckEnabled    => TO_X01(  (NOT clrn_ipd) OR
                                            (NOT prn_ipd) OR
                                            (sload_ipd) OR
                                            (sclr_ipd) OR
                                            (NOT devpor) OR
                                            (NOT devclrn) OR
                                            (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/stratixiii_ddr_io_reg",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_asdata_clk,
                TimingData      => TimingData_asdata_clk,
                TestSignal      => asdata_ipd,
                TestSignalName  => "ASDATA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_asdata_clk_noedge_posedge,
                SetupLow        => tsetup_asdata_clk_noedge_posedge,
                HoldHigh        => thold_asdata_clk_noedge_posedge,
                HoldLow         => thold_asdata_clk_noedge_posedge,
                CheckEnabled    => TO_X01(  (NOT clrn_ipd) OR
                                            (NOT prn_ipd) OR
                                            (NOT sload_ipd) OR
                                            (NOT devpor) OR
                                            (NOT devclrn) OR
                                            (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/stratixiii_ddr_io_reg",
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
                CheckEnabled    => TO_X01(  (NOT clrn_ipd) OR
                                            (NOT prn_ipd) OR
                                            (NOT devpor) OR
                                            (NOT devclrn) OR
                                            (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/stratixiii_ddr_io_reg",
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
                CheckEnabled    => TO_X01(  (NOT clrn_ipd) OR
                                            (NOT prn_ipd) OR
                                            (NOT devpor) OR
                                            (NOT devclrn) OR
                                            (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/stratixiii_ddr_io_reg",
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
                CheckEnabled    => TO_X01(  (NOT clrn_ipd) OR
                                            (NOT prn_ipd) OR
                                            (NOT devpor) OR
                                            (NOT devclrn) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/stratixiii_ddr_io_reg",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        end if;
    
        violation := Tviol_d_clk or Tviol_asdata_clk or 
                        Tviol_sclr_clk or Tviol_sload_clk or Tviol_ena_clk;
    
    
        if ((devpor = '0') or (devclrn = '0') or (clrn_ipd = '0'))  then
            iq := '0';
        elsif (prn_ipd = '0') then
            iq := '1';
        elsif (aload_ipd = '1') then
            iq := asdata_dly1;
        elsif (violation = 'X' and x_on_violation = "on") then
            iq := 'X';
        elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' then
            if (ena_ipd = '1') then
                if (sclr_ipd = '1') then
                    iq := '0';
                elsif (sload_ipd = '1') then
                    iq := asdata_dly1;
                else
                    iq := d_dly;
                end if;
            end if;
        end if;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => q,
            OutSignalName => "Q",
            OutTemp => iq,
            Paths =>   (0 => (clrn_ipd'last_event, tpd_clrn_q_negedge, TRUE),
                        1 => (prn_ipd'last_event, tpd_prn_q_negedge, TRUE),
                        2 => (aload_ipd'last_event, tpd_aload_q_posedge, TRUE),
                        3 => (asdata_ipd'last_event, tpd_asdata_q, TRUE),
                        4 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE)),
            GlitchData => q_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    
    end process;

end vital_stratixiii_ddr_io_reg;

-------------------------------------------------------------------------------
--
-- Entity Name : Stratix III_dll
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;
use work.stratixiii_pllpack.all;
use work.stratixiii_atom_ddr_pack.all;
use work.stratixiii_dll_gray_encoder;

ENTITY stratixiii_dll is
    GENERIC ( 
    input_frequency          : string := "0 ps";
    delay_buffer_mode        : string := "low";
    delay_chain_length       : integer := 12;
    delayctrlout_mode        : string := "normal";
    jitter_reduction         : string := "false";
    use_upndnin              : string := "false";
    use_upndninclkena        : string := "false";
    dual_phase_comparators   : string := "true";
    sim_valid_lock           : integer := 16;
    sim_valid_lockcount      : integer := 0;  -- 10000 = 1000 + 100*dllcounter
    sim_low_buffer_intrinsic_delay  : integer := 350;
    sim_high_buffer_intrinsic_delay : integer := 175;
    sim_buffer_delay_increment      : integer := 10;
    static_delay_ctrl        : integer := 0;
    lpm_type                 : string := "stratixiii_dll";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_upndnin             : VitalDelayType01 := DefpropDelay01;
    tipd_upndninclkena       : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tsetup_upndnin_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_upndnin_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tsetup_upndninclkena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
    thold_upndninclkena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_upndnout_posedge                : VitalDelayType01 := DefPropDelay01;
    tpd_clk_delayctrlout_posedge            : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );

    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              upndnin                  : IN std_logic := '1';
              upndninclkena            : IN std_logic := '1';
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '0';
              delayctrlout             : OUT std_logic_vector(5 DOWNTO 0);
              dqsupdate                : OUT std_logic;
              offsetdelayctrlout       : OUT std_logic_vector(5 DOWNTO 0);
              offsetdelayctrlclkout    : OUT std_logic;
              upndnout                 : OUT std_logic	
            );

END stratixiii_dll;


ARCHITECTURE vital_titandll of stratixiii_dll is

COMPONENT stratixiii_dll_gray_encoder
    GENERIC ( width : integer := 6 );
    PORT (    mbin  : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
              gout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
    );
END COMPONENT;

signal clk_in               : std_logic := '0';
signal aload_in_buf         : std_logic := '0';
signal upndn_in             : std_logic := '0';
signal upndninclkena_in     : std_logic := '1';

signal delayctrl_out        : std_logic_vector(5 DOWNTO 0) := "000000";
signal offsetdelayctrl_out  : std_logic_vector(5 DOWNTO 0) := "000000";
signal upndn_out            : std_logic := '0';
signal dqsupdate_out        : std_logic := '0';

signal para_delay_buffer_mode       : std_logic_vector (1 DOWNTO 0) := "01";
signal para_delayctrlout_mode       : std_logic_vector (1 DOWNTO 0) := "00";
signal para_static_delay_ctrl       : integer := 0;
signal para_jitter_reduction        : std_logic := '0';
signal para_use_upndnin             : std_logic := '0';
signal para_use_upndninclkena       : std_logic := '1';

-- INTERNAL NETS AND VARIABLES

-- for functionality - by modules
signal sim_buffer_intrinsic_delay : INTEGER := 0;

-- two reg on the de-assertion of dll
SIGNAL aload_in        : std_logic := '0';
SIGNAL aload_reg1      : std_logic := '1';
SIGNAL aload_reg2      : std_logic := '1';

-- delay and offset control out resolver
signal dr_delayctrl_out       : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_delayctrl_int       : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_offsetctrl_out      : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_dllcount_in         : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_clk8_in             : std_logic := '0';
signal dr_aload_in            : std_logic := '0';
                           
signal dr_reg_dllcount        : std_logic_vector (5 DOWNTO 0) := "000000";

signal para_static_delay_ctrl_gray : std_logic_vector (5 DOWNTO 0) := "000000";

                                                                                  
-- delay chain setting counter
signal dc_dllcount_out_gray   : std_logic_vector (5 DOWNTO 0) := "000000";
signal dc_dllcount_out_vec   : std_logic_vector (5 DOWNTO 0) := "000000";
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
signal jc_clkena_in           : std_logic := '1'; -- new in stratixiii
                                    
signal jc_count               : integer   := 8;
signal jc_reg_upndn           : std_logic := '0';
signal jc_reg_upndnclkena     : std_logic := '0';
                                   
-- phase comparator
signal pc_lock                : std_logic := '0'; -- new in stratixiii
signal pc_upndn_out           : std_logic := '1';
signal pc_dllcount_in         : integer := 0;
signal pc_clk1_in             : std_logic := '0';
signal pc_clk8_in             : std_logic := '0';
signal pc_aload_in            : std_logic := '0';
                                      
signal pc_reg_upndn           : std_logic := '1';
signal pc_delay               : integer   := 0; 
signal pc_lock_reg            : std_logic := '0';  -- new in stratixiii
signal pc_comp_range          : integer   := 0;  -- new in stratixiii 
                                       
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
	para_static_delay_ctrl <= static_delay_ctrl;
    para_use_upndnin       <= '1' WHEN use_upndnin = "true" ELSE '0';
    para_jitter_reduction  <= '1' WHEN jitter_reduction = "true" ELSE '0';
    para_use_upndninclkena  <= '1' WHEN use_upndninclkena = "true" ELSE '0';
    para_delay_buffer_mode  <= "00" WHEN delay_buffer_mode = "auto" ELSE "01" WHEN delay_buffer_mode = "low" ELSE "10";
    para_delayctrlout_mode  <= "01" WHEN delayctrlout_mode = "test" ELSE "10" WHEN delayctrlout_mode="normal" ELSE "11" WHEN delayctrlout_mode="static" ELSE "00";

    sim_buffer_intrinsic_delay <= sim_low_buffer_intrinsic_delay WHEN (delay_buffer_mode = "low") ELSE 
                                  sim_high_buffer_intrinsic_delay;  

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
    offsetdelayctrl_out <= dr_offsetctrl_out;
    offsetdelayctrlclkout <= dr_clk8_in;
    dqsupdate_out  <= cg_clk8a_out;
    upndn_out      <= pc_upndn_out;

    -- two registers on aload path --------------------------------------------
    aload_in <= (aload_in_buf OR aload_reg2);
    
    process(clk_in)
    begin
        if (clk_in = '0' and clk_in'event) then
            aload_reg2 <= aload_reg1;
            aload_reg1 <= aload_in_buf;
        end if;
     end process;
                      	
    -- Delay and offset ctrl out resolver -------------------------------------
    -------- convert calculations into integer
                   
    -- inputs
    dr_clk8_in     <= not cg_clk8b_out;
    dr_dllcount_in <= dc_dllcount_out_gray; 
    dr_aload_in    <= aload_in; 
    
    mdll_count_enc : stratixiii_dll_gray_encoder
        GENERIC MAP (width => 6)
        PORT MAP (mbin => dc_dllcount_out_vec, gout => dc_dllcount_out_gray);
    
    dc_dllcount_out_vec <= dll_unsigned2bin(dc_dllcount_out);
                
    -- outputs
    dr_delayctrl_out  <= dr_reg_dllcount;
    dr_offsetctrl_out <= dr_delayctrl_int; 
    
    -- assumed para_static_delay_ctrl is gray-coded
    para_static_delay_ctrl_gray <=  dll_unsigned2bin(para_static_delay_ctrl);
         	
    dr_delayctrl_int <= para_static_delay_ctrl_gray WHEN (delayctrlout_mode = "static") ELSE
                        dr_dllcount_in;
    
                              
    -- model
    process(dr_clk8_in, dr_aload_in)
    begin
        if (dr_aload_in = '1' and dr_aload_in'event) then
            dr_reg_dllcount <= "000000";
        elsif (dr_clk8_in = '1' and dr_clk8_in'event and dr_aload_in /= '1') then
            dr_reg_dllcount <= dr_delayctrl_int;
        end if;
     end process;
    
                           
    -- Delay Setting Control Counter ------------------------------------------
             
    --inputs
    dc_dlltolock_in   <= dll_to_lock;
    dc_aload_in       <= aload_in;
    dc_clk1_in        <= cg_clk1_out;
    dc_clk8_in        <= not cg_clk8b_out;
    dc_upndnclkena_in <= upndninclkena      WHEN (para_use_upndninclkena = '1')    ELSE
                         jc_upndnclkena_out WHEN (para_jitter_reduction = '1')     ELSE 
                         (not pc_lock)      WHEN (dual_phase_comparators = "true") ELSE 
                         '1';
    dc_upndn_in       <= upndnin      WHEN (para_use_upndnin = '1')      ELSE 
                         jc_upndn_out WHEN (para_jitter_reduction = '1') ELSE 
                         pc_upndn_out;
           
    -- outputs
    dc_dllcount_out  <= dc_reg_dllcount;  -- needs to turn into gray counter
                
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
              
    -- new in stratixiii
    jc_clkena_in <= '1' WHEN (dual_phase_comparators = "false") ELSE (not pc_lock);

    -- outputs
    jc_upndn_out       <= jc_reg_upndn;
    jc_upndnclkena_out <= jc_reg_upndnclkena;
             
    -- Model
    process (jc_clk8_in, jc_aload_in)
    begin
        if (jc_aload_in = '1' and jc_aload_in'event) then
            jc_count <= 8;
        elsif (jc_aload_in /= '1' and jc_clk8_in'event and jc_clk8_in = '1') then
		  if (jc_clkena_in = '1') then
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
		  else -- not clkena
            jc_reg_upndnclkena <= '0';
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
	pc_lock <= pc_lock_reg;
          
    -- parameter used
    -- sim_loop_intrinsic_delay, sim_loop_delay_increment
    pc_comp_range <= (3*delay_chain_length*sim_buffer_delay_increment)/2;
     
    -- Model
    process (pc_clk8_in, pc_aload_in)
    variable pc_var_delay : integer := 0;
    begin
        if (pc_aload_in = '1' and pc_aload_in'event) then
            pc_var_delay := 0;
        elsif (pc_aload_in /= '1' and pc_clk8_in'event and pc_clk8_in = '1' ) then	   
            pc_var_delay := delay_chain_length * (sim_buffer_intrinsic_delay + sim_buffer_delay_increment * pc_dllcount_in);
            pc_delay <= pc_var_delay;     

            if (dual_phase_comparators = "false") then
                if (pc_var_delay > input_period) then
                    pc_reg_upndn <= '0';
                else
                    pc_reg_upndn <= '1';
                end if;
		    else -- use dual phase
                if (pc_var_delay < (input_period - pc_comp_range/2)) then
                    pc_reg_upndn <= '1';
                    pc_lock_reg  <= '0';
                elsif (pc_var_delay <= (input_period + pc_comp_range/2)) then
                    pc_reg_upndn <= '0';
                    pc_lock_reg  <= '1';
                else
                    pc_reg_upndn <= '0';
                    pc_lock_reg  <= '0';				    
                end if;                 
			end if; 
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
        VitalWireDelay (aload_in_buf,     aload,     tipd_aload);
        VitalWireDelay (upndn_in,     upndnin,   tipd_upndnin);
        VitalWireDelay (upndninclkena_in, upndninclkena, tipd_upndninclkena);
    end block;
         
   	------------------------
    --  Timing Check Section
    ------------------------
    VITALtiming : process (clk_in, upndn_in, upndninclkena_in, 
                           delayctrl_out, offsetdelayctrl_out, dqsupdate_out, upndn_out)
    
    variable Tviol_upndnin_clk       : std_ulogic := '0';
    variable Tviol_upndninclkena_clk : std_ulogic := '0';
           
    variable TimingData_upndnin_clk       : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_upndninclkena_clk : VitalTimingDataType := VitalTimingDataInit;
         
    variable delayctrlout_VitalGlitchDataArray  : VitalGlitchDataArrayType(5 downto 0);
	variable upndnout_VitalGlitchData           : VitalGlitchDataType;
                  
    begin

        if (TimingChecksOn) then
                      
                          
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
               HeaderMsg       => InstancePath & "/STRATIXIII_DLL",
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
               HeaderMsg       => InstancePath & "/STRATIXIII_DLL",
               XOn             => XOn,
               MsgOn           => MsgOnChecks );
                          
       end if;

       ----------------------
       --  Path Delay Section
       ----------------------
                                                                     
       offsetdelayctrlout <= offsetdelayctrl_out;
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
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(0),   TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(0),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => delayctrlout(1),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(1),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(1),   TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(1),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
           
       VitalPathDelay01 (
           OutSignal     => delayctrlout(2),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(2),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(2),   TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(2),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => delayctrlout(3),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(3),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(3),   TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(3),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => delayctrlout(4),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(4),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(4),   TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(4),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
           
       VitalPathDelay01 (
           OutSignal     => delayctrlout(5),
           OutSignalName => "DELAYCTRLOUT",
           OutTemp       => delayctrl_out(5),
           Paths => (0   => (clk_in'last_event,   tpd_clk_delayctrlout_posedge(5),   TRUE)),
           GlitchData    => delayctrlout_VitalGlitchDataArray(5),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );

    end process;  -- vital timing

end vital_titandll;

-------------------------------------------------------------------------------
--
-- Entity Name : Stratix III_dll_offset_ctrl
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;
USE work.stratixiii_pllpack.all;
use work.stratixiii_atom_ddr_pack.all;
use work.stratixiii_dll_gray_encoder;
use work.stratixiii_dll_gray_decoder;

ENTITY stratixiii_dll_offset_ctrl is
    GENERIC ( 
    use_offset               : string := "false";
    static_offset            : string := "0";
    delay_buffer_mode        : string := "low";
    lpm_type                 : string := "stratixiii_dll_offset_ctrl";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_offset              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_offsetdelayctrlin   : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_addnsub             : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tsetup_offset_clk_noedge_posedge        : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_offset_clk_noedge_posedge         : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_addnsub_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_addnsub_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_offsetctrlout_posedge           : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );

    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              offsetdelayctrlin        : IN std_logic_vector(5 DOWNTO 0) := "000000";
              offset                   : IN std_logic_vector(5 DOWNTO 0) := "000000";
              addnsub                  : IN std_logic := '1';
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '0';
              offsettestout            : OUT std_logic_vector(5 DOWNTO 0);
              offsetctrlout            : OUT std_logic_vector(5 DOWNTO 0)
            );

END stratixiii_dll_offset_ctrl;


ARCHITECTURE vital_titanoffset of stratixiii_dll_offset_ctrl is

COMPONENT stratixiii_dll_gray_encoder
    GENERIC ( width : integer := 6 );
    PORT (    mbin  : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
              gout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT stratixiii_dll_gray_decoder
    GENERIC ( width : integer := 6 );
    PORT (    gin   : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
              bout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
    );
END COMPONENT;

signal clk_in               : std_logic := '0';
signal aload_in             : std_logic := '0';
signal offset_in            : std_logic_vector(5 DOWNTO 0) := "000000";
signal offsetdelayctrlin_in : std_logic_vector(5 DOWNTO 0) := "000000";
signal addnsub_in           : std_logic := '0';

signal offsetctrl_out       : std_logic_vector(5 DOWNTO 0) := "000000";

signal para_delay_buffer_mode       : std_logic_vector (1 DOWNTO 0) := "01";
signal para_use_offset              : std_logic := '0';
signal para_static_offset           : integer := 0;
signal para_static_offset_pos       : integer := 0;

-- INTERNAL NETS AND VARIABLES

-- for functionality - by modules

-- two reg on the de-assertion of aload
SIGNAL aload_reg1      : std_logic := '1';
SIGNAL aload_reg2      : std_logic := '1';

-- delay and offset control out resolver
signal dr_offsetctrl_out      : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_offsettest_out      : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_offsetctrl_out_gray : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_addnsub_in          : std_logic := '1';
signal dr_clk8_in             : std_logic := '0';
signal dr_aload_in             : std_logic := '0';
signal dr_offset_in_gray       : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_delayctrl_in_gray    : std_logic_vector (5 DOWNTO 0) := "000000";
signal para_static_offset_vec_pos : std_logic_vector (5 DOWNTO 0) := "000000";
signal para_static_offset_gray    : std_logic_vector (5 DOWNTO 0) := "000000";  -- signed in 2's complement

-- docoder
signal dr_delayctrl_in_bin     : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_offset_in_bin        : std_logic_vector (5 DOWNTO 0) := "000000";
signal dr_offset_in_bin_pos    : std_logic_vector (5 DOWNTO 0) := "000000";     -- for over/underflow check
signal para_static_offset_bin  : std_logic_vector (5 DOWNTO 0) := "000000";
signal para_static_offset_bin_pos  : std_logic_vector (5 DOWNTO 0) := "000000"; -- for over/underflow check
                           
signal dr_reg_offset           : std_logic_vector (5 DOWNTO 0) := "000000";
                                                                                      
begin
    -- paramters
    para_delay_buffer_mode  <= "01" WHEN delay_buffer_mode = "low" ELSE "00";
    para_use_offset <= '1' WHEN use_offset = "true" ELSE '0';
    para_static_offset     <= dqs_str2int(static_offset);  -- signed int
    para_static_offset_pos <= para_static_offset WHEN (para_static_offset > 0) ELSE (-1)*para_static_offset;
                   
    -- outputs
    offsetctrl_out <= dr_offsetctrl_out_gray;
    offsettestout  <= dr_offsettest_out;    
        
    -- two registers on aload path --------------------------------------------
    -- it should be user clock to DLL, not the /8 clock of offsetctrl 
    process(clk_in)
    begin
        if (clk_in = '0' and clk_in'event) then
            aload_reg2 <= aload_reg1;
            aload_reg1 <= aload_in;
        end if;
     end process;
                    	
    -- Delay and offset ctrl out resolver -------------------------------------
                   
    -- inputs
    dr_clk8_in     <= clk_in;
    dr_addnsub_in  <= addnsub_in; 
    dr_aload_in    <= aload_in;   -- aload_in | aload_reg2;
    dr_delayctrl_in_gray <= offsetdelayctrlin_in;
    dr_offset_in_gray   <= offset_in;

    para_static_offset_vec_pos <= dll_unsigned2bin(para_static_offset_pos);
    para_static_offset_gray <= ("111111" - para_static_offset_vec_pos + "000001") WHEN (para_static_offset < 0) ELSE para_static_offset_vec_pos;
                    
    -- outputs
    dr_offsetctrl_out <= dr_reg_offset;
    moffsetctrl_out_enc : stratixiii_dll_gray_encoder
        GENERIC MAP (width => 6)
        PORT MAP (mbin => dr_reg_offset, gout => dr_offsetctrl_out_gray);

    dr_offsettest_out <= para_static_offset_gray WHEN (use_offset = "false") ELSE offset_in;
              
    -- model

    -- decoders
    mdr_delayctrl_in_dec : stratixiii_dll_gray_decoder
        GENERIC MAP (width => 6)
        PORT MAP (gin => dr_delayctrl_in_gray, bout => dr_delayctrl_in_bin);
    mdr_offset_in_dec : stratixiii_dll_gray_decoder
        GENERIC MAP (width => 6)
        PORT MAP (gin => dr_offset_in_gray, bout => dr_offset_in_bin);
    mpara_static_offset_dec : stratixiii_dll_gray_decoder
        GENERIC MAP (width => 6)
        PORT MAP (gin => para_static_offset_gray, bout => para_static_offset_bin);

    -- get postive value of decoded offset for over/underflow check
    para_static_offset_bin_pos <= ("111111" - para_static_offset_bin + "000001") WHEN (para_static_offset < 0) ELSE para_static_offset_bin;
    dr_offset_in_bin_pos   <= ("111111" - dr_offset_in_bin + "000001") WHEN ((use_offset = "true") AND  (addnsub_in = '0')) ELSE dr_offset_in_bin;
              
    -- generating dr_reg_offset
    process(dr_clk8_in, dr_aload_in)
    begin
        if (dr_aload_in = '1' and dr_aload_in'event) then
            dr_reg_offset <= "000000";
        elsif (dr_aload_in /= '1' and dr_clk8_in = '1' and dr_clk8_in'event) then
		  if (use_offset = "true") then
            if (dr_addnsub_in = '1') then
                if (dr_delayctrl_in_bin < "111111" - dr_offset_in_bin) then
                    dr_reg_offset <= dr_delayctrl_in_bin + dr_offset_in_bin;
                else 
                    dr_reg_offset <= "111111";
                end if;
            elsif (dr_addnsub_in = '0') then
                if (dr_delayctrl_in_bin > dr_offset_in_bin_pos) then
                    dr_reg_offset <= dr_delayctrl_in_bin + dr_offset_in_bin;  -- same as - *_pos
                else
                    dr_reg_offset <= "000000";
                end if;
            end if;
          else
            if (para_static_offset >= 0) then               -- do not use a + b < "11111" as it does not check overflow
                if ((para_static_offset_bin < "111111") AND (dr_delayctrl_in_bin < "111111" - para_static_offset_bin )) then
                    dr_reg_offset <= dr_delayctrl_in_bin + para_static_offset_bin;
                else
                    dr_reg_offset <= "111111";
                end if;
            else
                if ((para_static_offset_bin_pos < "111111") AND (dr_delayctrl_in_bin > para_static_offset_bin_pos)) then
                    dr_reg_offset <= dr_delayctrl_in_bin + para_static_offset_bin; -- same as - *_pos
                else
                    dr_reg_offset <= "000000";
                end if;
            end if;
          end if;
        end if; -- rising clock
    end process ;  -- generating dr_reg_offset
                                        
    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_in,       clk,       tipd_clk);
        VitalWireDelay (aload_in,     aload,     tipd_aload);
        VitalWireDelay (addnsub_in,   addnsub,   tipd_addnsub);
        VitalWireDelay (offset_in(0), offset(0), tipd_offset(0));
        VitalWireDelay (offset_in(1), offset(1), tipd_offset(1));
        VitalWireDelay (offset_in(2), offset(2), tipd_offset(2));
        VitalWireDelay (offset_in(3), offset(3), tipd_offset(3));
        VitalWireDelay (offset_in(4), offset(4), tipd_offset(4));
        VitalWireDelay (offset_in(5), offset(5), tipd_offset(5));
        VitalWireDelay (offsetdelayctrlin_in(0), offsetdelayctrlin(0), tipd_offsetdelayctrlin(0));
        VitalWireDelay (offsetdelayctrlin_in(1), offsetdelayctrlin(1), tipd_offsetdelayctrlin(1));
        VitalWireDelay (offsetdelayctrlin_in(2), offsetdelayctrlin(2), tipd_offsetdelayctrlin(2));
        VitalWireDelay (offsetdelayctrlin_in(3), offsetdelayctrlin(3), tipd_offsetdelayctrlin(3));
        VitalWireDelay (offsetdelayctrlin_in(4), offsetdelayctrlin(4), tipd_offsetdelayctrlin(4));
        VitalWireDelay (offsetdelayctrlin_in(5), offsetdelayctrlin(5), tipd_offsetdelayctrlin(5));
    end block;
         
   	------------------------
    --  Timing Check Section
    ------------------------
    VITALtiming : process (clk_in, offset_in, addnsub_in, 
                           offsetctrl_out)
    
    variable Tviol_offset_clk        : std_ulogic := '0';
    variable Tviol_addnsub_clk       : std_ulogic := '0';
           
    variable TimingData_offset_clk        : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_addnsub_clk       : VitalTimingDataType := VitalTimingDataInit;
         
    variable offsetctrlout_VitalGlitchDataArray  : VitalGlitchDataArrayType(5 downto 0);
                  
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
               HeaderMsg       => InstancePath & "/STRATIXIII_OFFSETCTRL",
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
               HeaderMsg       => InstancePath & "/STRATIXIII_OFFSETCTRL",
               XOn             => XOn,
               MsgOn           => MsgOnChecks );   	               
       end if;

       ----------------------
       --  Path Delay Section
       ----------------------
                                                                                                                                                                        
       VitalPathDelay01 (
           OutSignal     => offsetctrlout(0),
           OutSignalName => "offsetctrlOUT",
           OutTemp       => offsetctrl_out(0),
           Paths => (0   => (clk_in'last_event,   tpd_clk_offsetctrlout_posedge(0),   TRUE)),
           GlitchData    => offsetctrlout_VitalGlitchDataArray(0),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => offsetctrlout(1),
           OutSignalName => "offsetctrlOUT",
           OutTemp       => offsetctrl_out(1),
           Paths => (0   => (clk_in'last_event,   tpd_clk_offsetctrlout_posedge(1),   TRUE)),
           GlitchData    => offsetctrlout_VitalGlitchDataArray(1),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
           
       VitalPathDelay01 (
           OutSignal     => offsetctrlout(2),
           OutSignalName => "offsetctrlOUT",
           OutTemp       => offsetctrl_out(2),
           Paths => (0   => (clk_in'last_event,   tpd_clk_offsetctrlout_posedge(2),   TRUE)),
           GlitchData    => offsetctrlout_VitalGlitchDataArray(2),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => offsetctrlout(3),
           OutSignalName => "offsetctrlOUT",
           OutTemp       => offsetctrl_out(3),
           Paths => (0   => (clk_in'last_event,   tpd_clk_offsetctrlout_posedge(3),   TRUE)),
           GlitchData    => offsetctrlout_VitalGlitchDataArray(3),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
             
       VitalPathDelay01 (
           OutSignal     => offsetctrlout(4),
           OutSignalName => "offsetctrlOUT",
           OutTemp       => offsetctrl_out(4),
           Paths => (0   => (clk_in'last_event,   tpd_clk_offsetctrlout_posedge(4),   TRUE)),
           GlitchData    => offsetctrlout_VitalGlitchDataArray(4),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
           
       VitalPathDelay01 (
           OutSignal     => offsetctrlout(5),
           OutSignalName => "offsetctrlOUT",
           OutTemp       => offsetctrl_out(5),
           Paths => (0   => (clk_in'last_event,   tpd_clk_offsetctrlout_posedge(5),   TRUE)),
           GlitchData    => offsetctrlout_VitalGlitchDataArray(5),
           Mode          => DefGlitchMode,
           XOn           => XOn,
           MsgOn         => MsgOn );
 


    end process;  -- vital timing


end vital_titanoffset;

 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_dqs_delay_chain
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
 use work.stratixiii_dll_gray_decoder;
 
 ENTITY stratixiii_dqs_delay_chain IS
     GENERIC ( 
         dqs_input_frequency             : string := "unused" ;
         use_phasectrlin                 : string := "false";
         phase_setting                   : integer := 0;
         delay_buffer_mode               : string := "low";
         dqs_phase_shift                 : integer := 0;
         dqs_offsetctrl_enable           : string := "false";
         dqs_ctrl_latches_enable         : string := "false";
         -- DFT added in WYS 1.33
         test_enable                     : string := "false";
         test_select                     : integer := 0;
         -- SIM only
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;
         lpm_type                        : string := "stratixiii_dqs_delay_chain";
         tipd_dqsin               : VitalDelayType01 := DefpropDelay01;
         tipd_aload               : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_offsetctrlin        : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_dqsupdateen         : VitalDelayType01 := DefpropDelay01;
         tipd_phasectrlin         : VitalDelayArrayType01(2 downto 0) := (OTHERS => DefPropDelay01);
         tpd_dqsin_dqsbusout      : VitalDelayType01 := DefPropDelay01;
         tsetup_delayctrlin_dqsupdateen_noedge_posedge  : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         thold_delayctrlin_dqsupdateen_noedge_posedge   : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         tsetup_offsetctrlin_dqsupdateen_noedge_posedge : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         thold_offsetctrlin_dqsupdateen_noedge_posedge  : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         dqsin        : IN std_logic := '0';
         delayctrlin  : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         offsetctrlin : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         dqsupdateen  : IN std_logic := '1';
         phasectrlin  : IN std_logic_vector(2 downto 0) := (OTHERS => '0');
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dqsbusout    : OUT std_logic;
         dffin        : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_dqs_delay_chain_arch OF stratixiii_dqs_delay_chain IS
 
     -- component section
     COMPONENT stratixiii_dll_gray_decoder
         GENERIC ( width : integer := 6 );
         PORT (    gin   : IN  STD_LOGIC_VECTOR (width-1 DOWNTO 0) := (OTHERS => '0');
               bout  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
     );
     END COMPONENT;
     
     -- signal section
     SIGNAL delayctrl_bin  : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL offsetctrl_bin : std_logic_vector(5 downto 0) := (OTHERS => '0');
     
     -- offsetctrl after "dqs_offsetctrl_enable" mux
     SIGNAL offsetctrl_mux  : std_logic_vector(5 downto 0) := (OTHERS => '0');
 
     -- reged outputs of delay count
     SIGNAL delayctrl_reg  : std_logic_vector(5 downto 0) := (OTHERS => '1');
     SIGNAL offsetctrl_reg : std_logic_vector(5 downto 0) := (OTHERS => '1');
 
     -- delay count after latch enable mux
     SIGNAL delayctrl_reg_mux  : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL offsetctrl_reg_mux : std_logic_vector(5 downto 0) := (OTHERS => '0');
     
     -- timing outputs
     SIGNAL tmp_dqsbusout : STD_LOGIC := '0';
     SIGNAL dqs_delay     : INTEGER := 0;  
     
     -- timing inputs
     SIGNAL dqsin_in        : std_logic := '0';
     SIGNAL delayctrlin_in  : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL offsetctrlin_in : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL dqsupdateen_in  : std_logic := '1';
     SIGNAL phasectrlin_in  : std_logic_vector(2 downto 0) := (OTHERS => '0');
 
     SIGNAL test_bus        : std_logic_vector(12 downto 0);
     SIGNAL test_lpbk       : std_logic;
     SIGNAL tmp_dqsin       : std_logic;
         
 BEGIN
         
     PROCESS(dqsupdateen_in)
     BEGIN
         IF (dqsupdateen_in = '1') THEN
             delayctrl_reg  <= delayctrlin_in;
             offsetctrl_reg <= offsetctrl_mux;
         END IF;
     END PROCESS;
     
     offsetctrl_mux <= offsetctrlin_in WHEN (dqs_offsetctrl_enable = "true") ELSE delayctrlin_in;
 
     -- mux after reg
     delayctrl_reg_mux  <= delayctrl_reg  WHEN (dqs_ctrl_latches_enable = "true") ELSE delayctrlin_in;
     offsetctrl_reg_mux <= offsetctrl_reg WHEN (dqs_ctrl_latches_enable = "true") ELSE offsetctrl_mux;
 
     mdelayctrlin_dec : stratixiii_dll_gray_decoder
         GENERIC MAP (width => 6)
         PORT MAP (gin => delayctrl_reg_mux, bout => delayctrl_bin);
     moffsetctrlin_dec : stratixiii_dll_gray_decoder
         GENERIC MAP (width => 6)
         PORT MAP (gin => offsetctrl_reg_mux, bout => offsetctrl_bin);
         
     PROCESS (delayctrl_bin, offsetctrl_bin, phasectrlin_in)        
         variable sim_intrinsic_delay : INTEGER := 0;
         variable tmp_delayctrl       : std_logic_vector(5 downto 0) := (OTHERS => '0');
         variable tmp_offsetctrl      : std_logic_vector(5 downto 0) := (OTHERS => '0');
         variable acell_delay         : INTEGER := 0;
         variable aoffsetcell_delay   : INTEGER := 0;
         variable delay_chain_len     : INTEGER := 0;
     BEGIN
         IF (delay_buffer_mode = "low") THEN
             sim_intrinsic_delay := sim_low_buffer_intrinsic_delay;
         ELSE 
             sim_intrinsic_delay := sim_high_buffer_intrinsic_delay;
         END IF;
         
         IF (delay_buffer_mode = "high" AND delayctrl_bin(5) = '1') THEN
             tmp_delayctrl  := "011111";
         ELSE       
             tmp_delayctrl  := delayctrl_bin;
         END IF;
         IF (delay_buffer_mode = "high" AND offsetctrl_bin(5) = '1') THEN
             tmp_offsetctrl  := "011111";
         ELSE       
             tmp_offsetctrl  := offsetctrl_bin;
         END IF;
         
         -- cell
         acell_delay := sim_intrinsic_delay + alt_conv_integer(tmp_delayctrl) * sim_buffer_delay_increment;
         IF (dqs_offsetctrl_enable = "true") THEN
             aoffsetcell_delay := sim_intrinsic_delay + alt_conv_integer(tmp_offsetctrl)*sim_buffer_delay_increment;
         ELSE 
             aoffsetcell_delay := acell_delay;
         END IF;
         -- no of cells
         IF (use_phasectrlin = "false") THEN
             delay_chain_len := phase_setting;
         ELSIF (phasectrlin_in(2) = '1') THEN
             delay_chain_len := 0;
         ELSE
             delay_chain_len := alt_conv_integer(phasectrlin_in) + 1;
         END IF;
         -- total delay
         IF (delay_chain_len = 0) THEN
             dqs_delay <= 0;
         ELSE
             dqs_delay <= (delay_chain_len - 1)*acell_delay + aoffsetcell_delay;
         END IF;
     
     END PROCESS; -- generating delays
 
     -- test bus loopback
     test_bus  <= (not dqsupdateen_in) & offsetctrl_reg_mux & delayctrl_reg_mux; 
     test_lpbk <= test_bus(test_select) WHEN ((0 <= test_select) AND (test_select <= 12)) ELSE 'Z';
     tmp_dqsin <= (test_lpbk AND dqsin) WHEN (test_enable = "true") ELSE dqsin_in;
 
 	tmp_dqsbusout <= transport tmp_dqsin after (dqs_delay * 1 ps);
     
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (dqsin_in,       dqsin,       tipd_dqsin);
         loopbits_delayctrlin : FOR i in delayctrlin'RANGE GENERATE
             VitalWireDelay (delayctrlin_in(i), delayctrlin(i), tipd_delayctrlin(i));
         END GENERATE;
         loopbits_offsetctrlin : FOR i in offsetctrlin'RANGE GENERATE
             VitalWireDelay (offsetctrlin_in(i), offsetctrlin(i), tipd_offsetctrlin(i));
         END GENERATE;
         VitalWireDelay (dqsupdateen_in, dqsupdateen, tipd_dqsupdateen);
         loopbits_phasectrlin : FOR i in phasectrlin'RANGE GENERATE
             VitalWireDelay (phasectrlin_in(i), phasectrlin(i), tipd_phasectrlin(i));
         END GENERATE;
     end block;
 
     -----------------------------------
     -- Timing Check Section
     -----------------------------------
     VITAL_timing_check: PROCESS (dqsupdateen_in,offsetctrlin_in,delayctrlin_in)
     
     variable Tviol_dqsupdateen_offsetctrlin : std_ulogic := '0';
     variable TimingData_dqsupdateen_offsetctrlin : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_dqsupdateen_delayctrlin    : std_ulogic := '0';
     variable TimingData_dqsupdateen_delayctrlin  : VitalTimingDataType := VitalTimingDataInit;
     
     BEGIN
         IF (TimingChecksOn) THEN
             VitalSetupHoldCheck (
                         Violation       => Tviol_dqsupdateen_offsetctrlin,
                         TimingData      => TimingData_dqsupdateen_offsetctrlin,
                         TestSignal      => offsetctrlin_in,
                         TestSignalName  => "offsetctrlin",
                         RefSignal       => dqsupdateen_in,
                         RefSignalName   => "dqsupdateen",
                         SetupHigh       => tsetup_offsetctrlin_dqsupdateen_noedge_posedge(0),
                         SetupLow        => tsetup_offsetctrlin_dqsupdateen_noedge_posedge(0),
                         HoldHigh        => thold_offsetctrlin_dqsupdateen_noedge_posedge(0),
                         HoldLow         => thold_offsetctrlin_dqsupdateen_noedge_posedge(0),
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_DQS_DELAY_CHAIN",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
             VitalSetupHoldCheck (
                         Violation       => Tviol_dqsupdateen_delayctrlin,
                         TimingData      => TimingData_dqsupdateen_delayctrlin,
                         TestSignal      => delayctrlin_in,
                         TestSignalName  => "delayctrlin",
                         RefSignal       => dqsupdateen_in,
                         RefSignalName   => "dqsupdateen",
                         SetupHigh       => tsetup_delayctrlin_dqsupdateen_noedge_posedge(0),
                         SetupLow        => tsetup_delayctrlin_dqsupdateen_noedge_posedge(0),
                         HoldHigh        => thold_delayctrlin_dqsupdateen_noedge_posedge(0),
                         HoldLow         => thold_delayctrlin_dqsupdateen_noedge_posedge(0),
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_DQS_DELAY_CHAIN",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
         END IF;
     END PROCESS;  -- timing check
 
     --------------------------------------
     --  Path Delay Section
     --------------------------------------
     
     VITAL_path_delays: PROCESS (tmp_dqsbusout)
         variable dqsbusout_VitalGlitchData : VitalGlitchDataType;
     BEGIN
         VitalPathDelay01 (
             OutSignal => dqsbusout,
             OutSignalName => "dqsbusout",
             OutTemp => tmp_dqsbusout,
             Paths =>   (0 => (dqsin_in'last_event, tpd_dqsin_dqsbusout, TRUE)),
             GlitchData => dqsbusout_VitalGlitchData,
             Mode => DefGlitchMode,
             XOn  => XOn,
             MsgOn  => MsgOn );
     END PROCESS;  -- Path Delays
 
 END stratixiii_dqs_delay_chain_arch;

-------------------------------------------------------------------------------
--
-- Entity Name :  stratixiii_dqs_enable
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;
    
ENTITY stratixiii_dqs_enable IS
    GENERIC ( 
        lpm_type               : string := "stratixiii_dqs_enable";
        tipd_dqsin               : VitalDelayType01 := DefpropDelay01;
        tipd_dqsenable           : VitalDelayType01 := DefpropDelay01;
        tpd_dqsin_dqsbusout      : VitalDelayType01 := DefPropDelay01;
        tpd_dqsenable_dqsbusout  : VitalDelayType01 := DefPropDelay01;
        TimingChecksOn           : Boolean := True;
        MsgOn                    : Boolean := DefGlitchMsgOn;
        XOn                      : Boolean  := DefGlitchXOn;
        MsgOnChecks              : Boolean := DefMsgOnChecks;
        XOnChecks                : Boolean := DefXOnChecks;
        InstancePath             : String := "*"   
    );
    
    PORT (
        dqsin        : IN std_logic := '0';
        dqsenable    : IN std_logic := '1';
        devclrn      : IN std_logic := '1';
        devpor       : IN std_logic := '1';
        dqsbusout    : OUT std_logic
    );

END;

ARCHITECTURE stratixiii_dqs_enable_arch OF stratixiii_dqs_enable IS
    -- component section
    
    -- signal section
    SIGNAL ena_reg : STD_LOGIC := '1';
    
    -- timing output
    SIGNAL tmp_dqsbusout   : std_logic := '0';
    
    -- timing input
    SIGNAL dqsin_in        : std_logic := '0';
    SIGNAL dqsenable_in    : std_logic := '1';

            
BEGIN
    tmp_dqsbusout <= ena_reg AND dqsin_in;
    PROCESS(tmp_dqsbusout, dqsenable_in)
    BEGIN
        IF (dqsenable_in = '1') THEN
            ena_reg <= '1';
        ELSIF (tmp_dqsbusout'event AND tmp_dqsbusout = '0') THEN
            ena_reg <= '0';
        END IF;   
    END PROCESS;
   
    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (dqsin_in,       dqsin,       tipd_dqsin);
        VitalWireDelay (dqsenable_in,   dqsenable,   tipd_dqsenable);
    end block;
    
    --------------------------------------
    --  Path Delay Section
    --------------------------------------
    
    VITAL_path_delays: PROCESS (tmp_dqsbusout)
        variable dqsbusout_VitalGlitchData : VitalGlitchDataType;
    BEGIN
        VitalPathDelay01 (
            OutSignal => dqsbusout,
            OutSignalName => "dqsbusout",
            OutTemp => tmp_dqsbusout,
            Paths =>   (0 => (dqsin_in'last_event, tpd_dqsin_dqsbusout, TRUE),
                        1 => (dqsenable_in'last_event, tpd_dqsenable_dqsbusout, TRUE)),
            GlitchData => dqsbusout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    END PROCESS;  -- Path Delays
    
END stratixiii_dqs_enable_arch;

 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_dqs_enable_ctrl
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
 use work.stratixiii_ddr_io_reg;
 use work.stratixiii_ddr_delay_chain_s;
 
 ENTITY stratixiii_dqs_enable_ctrl IS
     GENERIC ( 
         use_phasectrlin                 : string := "true";
         phase_setting                   : integer := 0;
         delay_buffer_mode               : string := "high";
         level_dqs_enable                : string := "false";
         delay_dqs_enable_by_half_cycle  : string := "false";
         add_phase_transfer_reg          : string := "false";
         invert_phase                    : string := "false";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;    
         lpm_type                        : string := "stratixiii_dqs_enable_ctrl";
         tipd_dqsenablein         : VitalDelayType01 := DefpropDelay01;
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_enaphasetransferreg : VitalDelayType01 := DefpropDelay01;
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         dqsenablein         : IN std_logic := '1';
         clk                 : IN std_logic := '0';
         delayctrlin         : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin         : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         enaphasetransferreg : IN std_logic := '0';
         phaseinvertctrl     : IN std_logic := '0';
         devclrn             : IN std_logic := '1';
         devpor              : IN std_logic := '1';        
         dqsenableout        : OUT std_logic;
         dffin               : OUT std_logic;
         dffextenddqsenable  : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_dqs_enable_ctrl_arch OF stratixiii_dqs_enable_ctrl IS
     -- component section
     COMPONENT stratixiii_ddr_delay_chain_s
     GENERIC (
         use_phasectrlin : string  := "true";
         phase_setting   : integer :=  0;
         delay_buffer_mode               : string  := "high";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment  : integer := 10;
         phasectrlin_limit           : integer := 7
     );
     PORT (
         clk         : IN std_logic := '0';
         delayctrlin : IN std_logic_vector(5 DOWNTO 0) := (OTHERS => '0');
         phasectrlin : IN std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
         delayed_clkout : OUT std_logic
     );
     END COMPONENT;
     
     component stratixiii_ddr_io_reg                                                                                              
     generic (                                                                                                 
              power_up : string := "DONT_CARE";                                                                
              is_wysiwyg : string := "false";                                                                  
              x_on_violation : string := "on";                                                                 
              tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                
              tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                           
              tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                 
              thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                               
              tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;                                          
              tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;                                         
              tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;                                        
              tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                                                
              tipd_clk : VitalDelayType01 := DefPropDelay01;                                                   
              tipd_d : VitalDelayType01 := DefPropDelay01;                                                     
              tipd_asdata : VitalDelayType01 := DefPropDelay01;                                                
              tipd_sclr : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_sload : VitalDelayType01 := DefPropDelay01;                                                 
              tipd_clrn : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_prn : VitalDelayType01 := DefPropDelay01;                                                   
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
            d : in std_logic := '0';                                                                           
            clk : in std_logic := '0';                                                                         
            ena : in std_logic := '1';                                                                         
            clrn : in std_logic := '1';                                                                        
            prn : in std_logic := '1';                                                                         
            aload : in std_logic := '0';                                                                       
            asdata : in std_logic := '0';                                                                      
            sclr : in std_logic := '0';                                                                        
            sload : in std_logic := '0';                                                                       
            devclrn : in std_logic := '1';                                                                     
            devpor : in std_logic := '1';                                                                      
            q : out std_logic                                                                                  
          );                                                                                                   
     end component;                                                                                                
     
 
     -- int signals
     SIGNAL phasectrl_clkout  : std_logic := '0';
     SIGNAL delayed_clk       : std_logic := '0';
     SIGNAL dqsenablein_reg_q : std_logic := '0';
     SIGNAL dqsenablein_level_ena : std_logic := '0';
 
     -- transfer delay
     SIGNAL dqsenablein_reg_dly : std_logic := '0';
     SIGNAL phasetransferdelay_mux_out : std_logic := '0';
 
     SIGNAL dqsenable_delayed_regp : std_logic := '0';
     SIGNAL dqsenable_delayed_regn : std_logic := '0';
     
     SIGNAL m_vcc : std_logic := '1';
     SIGNAL m_gnd : std_logic := '0';
     
     SIGNAL not_clk_in      : std_logic := '1';
     SIGNAL not_delayed_clk : std_logic := '1';
     
     -- timing output
     SIGNAL tmp_dqsenableout       : std_logic := '1';
 
     -- timing input
     SIGNAL dqsenablein_in         : std_logic := '1';
     SIGNAL clk_in                 : std_logic := '0';
     SIGNAL delayctrlin_in         : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL phasectrlin_in         : std_logic_vector(3 downto 0) := (OTHERS => '0');
     SIGNAL enaphasetransferreg_in : std_logic := '0';
     SIGNAL phaseinvertctrl_in     : std_logic := '0';
     
 BEGIN
 
     -- delay chain
     m_delay_chain : stratixiii_ddr_delay_chain_s 
         GENERIC MAP (
             phase_setting               => phase_setting,
             use_phasectrlin             => use_phasectrlin,
             delay_buffer_mode           => delay_buffer_mode,
             sim_low_buffer_intrinsic_delay  => sim_low_buffer_intrinsic_delay,
             sim_high_buffer_intrinsic_delay => sim_high_buffer_intrinsic_delay,
             sim_buffer_delay_increment      => sim_buffer_delay_increment
         )
         PORT MAP(
             clk            => clk_in, 
             delayctrlin    => delayctrlin_in, 
             phasectrlin    => phasectrlin_in, 
             delayed_clkout => phasectrl_clkout
        ); 
     
     delayed_clk <= (not phasectrl_clkout) WHEN (invert_phase = "true") ELSE
                    phasectrl_clkout       WHEN (invert_phase = "false") ELSE
                    (not phasectrl_clkout) WHEN (phaseinvertctrl_in = '1') ELSE
                    phasectrl_clkout;
                    
     not_clk_in <= not clk_in;
     not_delayed_clk <= not delayed_clk;
                          
     dqsenablein_reg : stratixiii_ddr_io_reg
         PORT MAP(
             d        => dqsenablein_in, 
             clk     => clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => m_gnd, 
             asdata  => m_gnd, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dqsenablein_reg_q
         );
   
     dqsenable_transfer_reg : stratixiii_ddr_io_reg  
         PORT MAP ( 
             d       => dqsenablein_reg_q, 
             clk     => not_delayed_clk, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => m_gnd, 
             asdata  => m_gnd, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dqsenablein_reg_dly
         );
 
     -- add phase transfer mux
     phasetransferdelay_mux_out <= dqsenablein_reg_dly WHEN (add_phase_transfer_reg = "true")  ELSE 
                                   dqsenablein_reg_q   WHEN (add_phase_transfer_reg = "false") ELSE
                                   dqsenablein_reg_dly WHEN (enaphasetransferreg_in = '1')     ELSE 
                                   dqsenablein_reg_q;
 
     dqsenablein_level_ena      <= phasetransferdelay_mux_out WHEN (level_dqs_enable = "true") ELSE dqsenablein_in;
 
     dqsenableout_reg : stratixiii_ddr_io_reg  
         PORT MAP(
             d       => dqsenablein_level_ena, 
             clk     => delayed_clk, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => m_gnd, 
             asdata  => m_gnd, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dqsenable_delayed_regp
         );
         
     dqsenableout_extend_reg : stratixiii_ddr_io_reg
         PORT MAP(
             d       => dqsenable_delayed_regp, 
             clk     => not_delayed_clk, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => m_gnd, 
             asdata  => m_gnd, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dqsenable_delayed_regn
         );
     
     tmp_dqsenableout <= dqsenable_delayed_regp WHEN (delay_dqs_enable_by_half_cycle = "false") ELSE
                         (dqsenable_delayed_regp AND dqsenable_delayed_regn);
                           
     dqsenableout <= tmp_dqsenableout;
 
 
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (dqsenablein_in,       dqsenablein,       tipd_dqsenablein);
         VitalWireDelay (clk_in,       clk,       tipd_clk);
         loopbits_delayctrlin : FOR i in delayctrlin'RANGE GENERATE
             VitalWireDelay (delayctrlin_in(i), delayctrlin(i), tipd_delayctrlin(i));
         END GENERATE;
         loopbits_phasectrlin : FOR i in phasectrlin'RANGE GENERATE
             VitalWireDelay (phasectrlin_in(i), phasectrlin(i), tipd_phasectrlin(i));
         END GENERATE;
         VitalWireDelay (enaphasetransferreg_in, enaphasetransferreg, tipd_enaphasetransferreg);
         VitalWireDelay (phaseinvertctrl_in,     phaseinvertctrl,     tipd_phaseinvertctrl);
     end block;
     
 
 END stratixiii_dqs_enable_ctrl_arch;

 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_delay_chain
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
  
 ENTITY stratixiii_delay_chain IS
     GENERIC ( 
         sim_delayctrlin_rising_delay_0   : integer := 0;
         sim_delayctrlin_rising_delay_1   : integer := 50;
         sim_delayctrlin_rising_delay_2   : integer := 100;
         sim_delayctrlin_rising_delay_3   : integer := 150;
         sim_delayctrlin_rising_delay_4   : integer := 200;
         sim_delayctrlin_rising_delay_5   : integer := 250;
         sim_delayctrlin_rising_delay_6   : integer := 300;
         sim_delayctrlin_rising_delay_7   : integer := 350;
         sim_delayctrlin_rising_delay_8   : integer := 400;
         sim_delayctrlin_rising_delay_9   : integer := 450;
         sim_delayctrlin_rising_delay_10  : integer := 500;
         sim_delayctrlin_rising_delay_11  : integer := 550;
         sim_delayctrlin_rising_delay_12  : integer := 600;
         sim_delayctrlin_rising_delay_13  : integer := 650;
         sim_delayctrlin_rising_delay_14  : integer := 700;
         sim_delayctrlin_rising_delay_15  : integer := 750;
         sim_delayctrlin_falling_delay_0  : integer := 0;
         sim_delayctrlin_falling_delay_1  : integer := 50;
         sim_delayctrlin_falling_delay_2  : integer := 100;
         sim_delayctrlin_falling_delay_3  : integer := 150;
         sim_delayctrlin_falling_delay_4  : integer := 200;
         sim_delayctrlin_falling_delay_5  : integer := 250;
         sim_delayctrlin_falling_delay_6  : integer := 300;
         sim_delayctrlin_falling_delay_7  : integer := 350;
         sim_delayctrlin_falling_delay_8  : integer := 400;
         sim_delayctrlin_falling_delay_9  : integer := 450;
         sim_delayctrlin_falling_delay_10  : integer := 500;
         sim_delayctrlin_falling_delay_11  : integer := 550;
         sim_delayctrlin_falling_delay_12  : integer := 600;
         sim_delayctrlin_falling_delay_13  : integer := 650;
         sim_delayctrlin_falling_delay_14  : integer := 700;
         sim_delayctrlin_falling_delay_15  : integer := 750;
         use_delayctrlin                   : string := "true";
         delay_setting                     : integer := 0;
         -- new in STRATIXIV ww30.2008
         sim_finedelayctrlin_falling_delay_0 : integer := 0;
         sim_finedelayctrlin_falling_delay_1 : integer := 25;
         sim_finedelayctrlin_rising_delay_0  : integer := 0;
         sim_finedelayctrlin_rising_delay_1  : integer := 25;
         use_finedelayctrlin                 : string  := "false";
 
         lpm_type                          : string := "stratixiii_delay_chain";
         tipd_datain              : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tpd_datain_dataout       : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         datain       : IN std_logic := '0';
         delayctrlin  : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         finedelayctrlin : IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dataout      : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_delay_chain_arch OF stratixiii_delay_chain IS
     -- type def
     type delay_chain_int_vec is array (natural range <>) of integer;
     
     -- component section
     
     -- signal section
     SIGNAL rising_dly  : INTEGER := 0;
     SIGNAL falling_dly : INTEGER := 0;
     SIGNAL delayctrlin_in : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
     SIGNAL finedelayctrlin_in : STD_LOGIC := '0';
     
     -- timing inputs
     SIGNAL tmp_dataout     : std_logic := '0';
     
     -- timing inputs
     SIGNAL datain_in       : std_logic := '0';
     
 BEGIN
     -- filtering X/U etc.
     delayctrlin_in(0) <= '1' WHEN (delayctrlin(0) = '1') ELSE '0';
     delayctrlin_in(1) <= '1' WHEN (delayctrlin(1) = '1') ELSE '0';
     delayctrlin_in(2) <= '1' WHEN (delayctrlin(2) = '1') ELSE '0';
     delayctrlin_in(3) <= '1' WHEN (delayctrlin(3) = '1') ELSE '0';
     finedelayctrlin_in <= '1' WHEN (finedelayctrlin = '1') ELSE '0';
 
     --  generate dynamic delay table and dynamic delay       
     process(delayctrlin_in, finedelayctrlin_in)
         variable init : boolean := true;
         variable dly_table_rising : delay_chain_int_vec(15 downto 0) := (OTHERS => 0);
         variable dly_table_falling : delay_chain_int_vec(15 downto 0) := (OTHERS => 0);
         variable finedly_table_rising : delay_chain_int_vec(1 downto 0) := (OTHERS => 0);
         variable finedly_table_falling : delay_chain_int_vec(1 downto 0) := (OTHERS => 0);
         variable dly_setting : integer := 0;
         variable finedly_setting : integer := 0;
     begin
         if (init) then
             dly_table_rising(0) := sim_delayctrlin_rising_delay_0;
             dly_table_rising(1) := sim_delayctrlin_rising_delay_1;
             dly_table_rising(2) := sim_delayctrlin_rising_delay_2;
             dly_table_rising(3) := sim_delayctrlin_rising_delay_3;
             dly_table_rising(4) := sim_delayctrlin_rising_delay_4;
             dly_table_rising(5) := sim_delayctrlin_rising_delay_5;
             dly_table_rising(6) := sim_delayctrlin_rising_delay_6;
             dly_table_rising(7) := sim_delayctrlin_rising_delay_7;
             dly_table_rising(8) := sim_delayctrlin_rising_delay_8;
             dly_table_rising(9) := sim_delayctrlin_rising_delay_9;
             dly_table_rising(10) := sim_delayctrlin_rising_delay_10;
             dly_table_rising(11) := sim_delayctrlin_rising_delay_11;
             dly_table_rising(12) := sim_delayctrlin_rising_delay_12;
             dly_table_rising(13) := sim_delayctrlin_rising_delay_13;
             dly_table_rising(14) := sim_delayctrlin_rising_delay_14;
             dly_table_rising(15) := sim_delayctrlin_rising_delay_15;
 
             dly_table_falling(0) := sim_delayctrlin_falling_delay_0;
             dly_table_falling(1) := sim_delayctrlin_falling_delay_1;
             dly_table_falling(2) := sim_delayctrlin_falling_delay_2;
             dly_table_falling(3) := sim_delayctrlin_falling_delay_3;
             dly_table_falling(4) := sim_delayctrlin_falling_delay_4;
             dly_table_falling(5) := sim_delayctrlin_falling_delay_5;
             dly_table_falling(6) := sim_delayctrlin_falling_delay_6;
             dly_table_falling(7) := sim_delayctrlin_falling_delay_7;
             dly_table_falling(8) := sim_delayctrlin_falling_delay_8;
             dly_table_falling(9) := sim_delayctrlin_falling_delay_9;
             dly_table_falling(10) := sim_delayctrlin_falling_delay_10;
             dly_table_falling(11) := sim_delayctrlin_falling_delay_11;
             dly_table_falling(12) := sim_delayctrlin_falling_delay_12;
             dly_table_falling(13) := sim_delayctrlin_falling_delay_13;
             dly_table_falling(14) := sim_delayctrlin_falling_delay_14;
             dly_table_falling(15) := sim_delayctrlin_falling_delay_15;
                     
             finedly_table_rising(0)  := sim_finedelayctrlin_rising_delay_0;
             finedly_table_rising(1)  := sim_finedelayctrlin_rising_delay_1;
             finedly_table_falling(0) := sim_finedelayctrlin_falling_delay_0;
             finedly_table_falling(1) := sim_finedelayctrlin_falling_delay_1;
 
             init := false;
         end if;
         
         IF (use_delayctrlin = "false") THEN
             dly_setting := delay_setting;
         ELSE
             dly_setting := alt_conv_integer(delayctrlin_in);
         END IF;
          	
         IF (finedelayctrlin_in = '1') THEN
             finedly_setting := 1;
         ELSE
             finedly_setting := 0;
         END IF;
          	
 	     IF (use_finedelayctrlin = "true") THEN
 	         rising_dly  <= dly_table_rising(dly_setting) + finedly_table_rising(finedly_setting);
 	         falling_dly <= dly_table_falling(dly_setting) + finedly_table_falling(finedly_setting);
 	     ELSE 
             rising_dly  <= dly_table_rising(dly_setting);
             falling_dly <= dly_table_falling(dly_setting);
         END IF;
     end process; -- generating dynamic delays
 
     PROCESS(datain_in)
     BEGIN
         if (datain_in = '0') then
             tmp_dataout <= transport datain_in after (falling_dly * 1 ps);
         else
             tmp_dataout <= transport datain_in after (rising_dly * 1 ps);
         end if;
     END PROCESS;
         
     ----------------------------------
     --  Path Delay Section
     ----------------------------------
     
     VITAL: process(tmp_dataout)
         variable dataout_VitalGlitchData : VitalGlitchDataType;
     begin 
         VitalPathDelay01 (
             OutSignal => dataout,
             OutSignalName => "dataout",
             OutTemp => tmp_dataout,
             Paths => (0 => (datain_in'last_event, tpd_datain_dataout, TRUE)),
             GlitchData => dataout_VitalGlitchData,
             Mode => DefGlitchMode,
             XOn  => XOn,
             MsgOn  => MsgOn );
     end process;
 
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (datain_in,       datain,       tipd_datain);
     end block;
     
 END stratixiii_delay_chain_arch;
 
 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_io_clock_divider
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
 use work.stratixiii_ddr_delay_chain_s;
     
 ENTITY stratixiii_io_clock_divider IS
     GENERIC ( 
         use_phasectrlin                 : string := "true";
         phase_setting                   : integer := 0;     
         delay_buffer_mode               : string := "high";
         use_masterin                    : string := "false";
         invert_phase                    : string := "false";    
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;    
         lpm_type                        : string := "stratixiii_io_clock_divider";
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_phaseselect         : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         tipd_masterin            : VitalDelayType01 := DefpropDelay01;
         tpd_clk_clkout           : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         clk             : IN std_logic := '0';
         phaseselect     : IN std_logic := '0';
         delayctrlin     : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin     : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         phaseinvertctrl : IN std_logic := '0';
         masterin        : IN std_logic := '0';
         devclrn         : IN std_logic := '1';
         devpor          : IN std_logic := '1';
         clkout          : OUT std_logic;
         slaveout        : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_io_clock_divider_arch OF stratixiii_io_clock_divider IS
     -- component section
     COMPONENT stratixiii_ddr_delay_chain_s
     GENERIC (
         use_phasectrlin : string  := "true";
         phase_setting   : integer :=  0;
         delay_buffer_mode               : string  := "high";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment  : integer := 10;
         phasectrlin_limit           : integer := 7
     );
     PORT (
         clk         : IN std_logic := '0';
         delayctrlin : IN std_logic_vector(5 DOWNTO 0) := (OTHERS => '0');
         phasectrlin : IN std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
         delayed_clkout : OUT std_logic
     );
     END COMPONENT;
     
     -- int signals
     SIGNAL phasectrl_clkout : STD_LOGIC := '0';
     SIGNAL delayed_clk      : STD_LOGIC := '0';
     SIGNAL divided_clk_in   : STD_LOGIC := '0';
     SIGNAL divided_clk      : STD_LOGIC := '0';
     
     -- timing outputs
     SIGNAL tmp_clkout       : STD_LOGIC := '0';
     
     -- timing inputs
     SIGNAL clk_in             : std_logic := '0';
     SIGNAL phaseselect_in     : std_logic := '0';
     SIGNAL delayctrlin_in     : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL phasectrlin_in     : std_logic_vector(3 downto 0) := (OTHERS => '0');
     SIGNAL phaseinvertctrl_in : std_logic := '0';
     SIGNAL masterin_in        : std_logic := '0';
     
 BEGIN
 
     -- delay chain
     m_delay_chain : stratixiii_ddr_delay_chain_s 
         GENERIC MAP (
             phase_setting               => phase_setting,
             use_phasectrlin             => use_phasectrlin,
             delay_buffer_mode           => delay_buffer_mode,
             sim_low_buffer_intrinsic_delay  => sim_low_buffer_intrinsic_delay,
             sim_high_buffer_intrinsic_delay => sim_high_buffer_intrinsic_delay,
             sim_buffer_delay_increment      => sim_buffer_delay_increment
         )
         PORT MAP(
             clk            => clk_in, 
             delayctrlin    => delayctrlin_in, 
             phasectrlin    => phasectrlin_in, 
             delayed_clkout => phasectrl_clkout
        ); 
        
     delayed_clk <= (not phasectrl_clkout) WHEN (invert_phase = "true") ELSE
                    phasectrl_clkout       WHEN (invert_phase = "false") ELSE
                    (not phasectrl_clkout) WHEN (phaseinvertctrl_in = '1') ELSE
                    phasectrl_clkout;
 
     divided_clk_in <= masterin_in WHEN (use_masterin = "true") ELSE divided_clk;
   
     PROCESS (delayed_clk)
     BEGIN
         if (delayed_clk = '1') then
             divided_clk <= not divided_clk_in;
         end if;
     END PROCESS;
       
     
     tmp_clkout <= (not divided_clk) WHEN (phaseselect_in = '1') ELSE divided_clk;
 
     slaveout <= divided_clk;
     
     ----------------------------------
     --  Path Delay Section
     ----------------------------------
     
     VITAL: process(tmp_clkout)
         variable clkout_VitalGlitchData : VitalGlitchDataType;
     begin 
         VitalPathDelay01 (
             OutSignal => clkout,
             OutSignalName => "clkout",
             OutTemp => tmp_clkout,
             Paths => (0 => (clk_in'last_event, tpd_clk_clkout, TRUE)),
             GlitchData => clkout_VitalGlitchData,
             Mode => DefGlitchMode,
             XOn  => XOn,
             MsgOn  => MsgOn );
     end process;
                           
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (clk_in,         clk,         tipd_clk);
         VitalWireDelay (phaseselect_in, phaseselect, tipd_phaseselect);
         loopbits_delayctrlin : FOR i in delayctrlin'RANGE GENERATE
             VitalWireDelay (delayctrlin_in(i), delayctrlin(i), tipd_delayctrlin(i));
         END GENERATE;
         loopbits_phasectrlin : FOR i in phasectrlin'RANGE GENERATE
             VitalWireDelay (phasectrlin_in(i), phasectrlin(i), tipd_phasectrlin(i));
         END GENERATE;
         VitalWireDelay (phaseinvertctrl_in, phaseinvertctrl, tipd_phaseinvertctrl);
         VitalWireDelay (masterin_in,        masterin,        tipd_masterin);
     end block;
     
 END stratixiii_io_clock_divider_arch;
 
 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_output_phase_alignment
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
 use work.stratixiii_ddr_io_reg;
 use work.stratixiii_ddr_delay_chain_s;
     
 ENTITY stratixiii_output_phase_alignment IS
     GENERIC ( 
         operation_mode                   : string := "ddio_out";
         use_phasectrlin                  : string := "true";
         phase_setting                    : integer := 0;      
         delay_buffer_mode                : string := "high";
         power_up                         : string := "low";
         async_mode                       : string := "none";
         sync_mode                        : string := "none";
         add_output_cycle_delay           : string := "false";
         use_delayed_clock                : string := "false";
         add_phase_transfer_reg           : string := "false"; 
         use_phasectrl_clock              : string := "true";   
         use_primary_clock                : string := "true";   
         invert_phase                     : string := "false";  
         bypass_input_register            : string := "false";  
         phase_setting_for_delayed_clock  : integer := 2;           
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;  
         -- new in STRATIXIV: ww30.2008
         duty_cycle_delay_mode : string := "none";
         sim_dutycycledelayctrlin_falling_delay_0 : integer :=  0 ;
         sim_dutycycledelayctrlin_falling_delay_1 : integer :=  25 ;
         sim_dutycycledelayctrlin_falling_delay_10 : integer :=  250 ;
         sim_dutycycledelayctrlin_falling_delay_11 : integer :=  275 ;
         sim_dutycycledelayctrlin_falling_delay_12 : integer :=  300 ;
         sim_dutycycledelayctrlin_falling_delay_13 : integer :=  325 ;
         sim_dutycycledelayctrlin_falling_delay_14 : integer :=  350 ;
         sim_dutycycledelayctrlin_falling_delay_15 : integer :=  375 ;
         sim_dutycycledelayctrlin_falling_delay_2 : integer :=  50 ;
         sim_dutycycledelayctrlin_falling_delay_3 : integer :=  75 ;
         sim_dutycycledelayctrlin_falling_delay_4 : integer :=  100 ;
         sim_dutycycledelayctrlin_falling_delay_5 : integer :=  125 ;
         sim_dutycycledelayctrlin_falling_delay_6 : integer :=  150 ;
         sim_dutycycledelayctrlin_falling_delay_7 : integer :=  175 ;
         sim_dutycycledelayctrlin_falling_delay_8 : integer :=  200 ;
         sim_dutycycledelayctrlin_falling_delay_9 : integer :=  225 ;
         sim_dutycycledelayctrlin_rising_delay_0 : integer :=  0 ;
         sim_dutycycledelayctrlin_rising_delay_1 : integer :=  25 ;
         sim_dutycycledelayctrlin_rising_delay_10 : integer :=  250 ;
         sim_dutycycledelayctrlin_rising_delay_11 : integer :=  275 ;
         sim_dutycycledelayctrlin_rising_delay_12 : integer :=  300 ;
         sim_dutycycledelayctrlin_rising_delay_13 : integer :=  325 ;
         sim_dutycycledelayctrlin_rising_delay_14 : integer :=  350 ;
         sim_dutycycledelayctrlin_rising_delay_15 : integer :=  375 ;
         sim_dutycycledelayctrlin_rising_delay_2 : integer :=  50 ;
         sim_dutycycledelayctrlin_rising_delay_3 : integer :=  75 ;
         sim_dutycycledelayctrlin_rising_delay_4 : integer :=  100 ;
         sim_dutycycledelayctrlin_rising_delay_5 : integer :=  125 ;
         sim_dutycycledelayctrlin_rising_delay_6 : integer :=  150 ;
         sim_dutycycledelayctrlin_rising_delay_7 : integer :=  175 ;
         sim_dutycycledelayctrlin_rising_delay_8 : integer :=  200 ;
         sim_dutycycledelayctrlin_rising_delay_9 : integer :=  225 ;
         lpm_type                        : string := "stratixiii_output_phase_alignment";
         tipd_datain              : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_areset              : VitalDelayType01 := DefpropDelay01;
         tipd_sreset              : VitalDelayType01 := DefpropDelay01;
         tipd_clkena              : VitalDelayType01 := DefpropDelay01;
         tipd_enaoutputcycledelay : VitalDelayType01 := DefpropDelay01;
         tipd_enaphasetransferreg : VitalDelayType01 := DefpropDelay01;
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         datain              : IN std_logic_vector(1 downto 0) := (OTHERS => '0');
         clk                 : IN std_logic := '0';
         delayctrlin         : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin         : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         areset              : IN std_logic := '0';
         sreset              : IN std_logic := '0';
         clkena              : IN std_logic := '1';
         enaoutputcycledelay : IN std_logic := '0';
         enaphasetransferreg : IN std_logic := '0';
         phaseinvertctrl     : IN std_logic := '0';
         devclrn             : IN std_logic := '1';
         devpor              : IN std_logic := '1';    
         delaymode           : IN std_logic := '0'; -- new in STRATIXIV: ww30.2008
         dutycycledelayctrlin: IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         dataout             : OUT std_logic;
         dffin               : OUT std_logic_vector(1 downto 0);
         dff1t               : OUT std_logic_vector(1 downto 0);
         dffddiodataout      : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_output_phase_alignment_arch OF stratixiii_output_phase_alignment IS
     -- type def
     type delay_chain_int_vec is array (natural range <>) of integer;
     
     -- component section
     COMPONENT stratixiii_ddr_delay_chain_s
     GENERIC (
         use_phasectrlin : string  := "true";
         phase_setting   : integer :=  0;
         delay_buffer_mode               : string  := "high";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment  : integer := 10;
         phasectrlin_limit           : integer := 7
     );
     PORT (
         clk         : IN std_logic := '0';
         delayctrlin : IN std_logic_vector(5 DOWNTO 0) := (OTHERS => '0');
         phasectrlin : IN std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
         delayed_clkout : OUT std_logic
     );
     END COMPONENT;
     
     component stratixiii_ddr_io_reg                                                                                              
     generic (                                                                                                 
              power_up : string := "DONT_CARE";                                                                
              is_wysiwyg : string := "false";                                                                  
              x_on_violation : string := "on";                                                                 
              tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                
              tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                           
              tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                 
              thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                               
              tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;                                          
              tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;                                         
              tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;                                        
              tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                                                
              tipd_clk : VitalDelayType01 := DefPropDelay01;                                                   
              tipd_d : VitalDelayType01 := DefPropDelay01;                                                     
              tipd_asdata : VitalDelayType01 := DefPropDelay01;                                                
              tipd_sclr : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_sload : VitalDelayType01 := DefPropDelay01;                                                 
              tipd_clrn : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_prn : VitalDelayType01 := DefPropDelay01;                                                   
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
            d : in std_logic := '0';                                                                           
            clk : in std_logic := '0';                                                                         
            ena : in std_logic := '1';                                                                         
            clrn : in std_logic := '1';                                                                        
            prn : in std_logic := '1';                                                                         
            aload : in std_logic := '0';                                                                       
            asdata : in std_logic := '0';                                                                      
            sclr : in std_logic := '0';                                                                        
            sload : in std_logic := '0';                                                                       
            devclrn : in std_logic := '1';                                                                     
            devpor : in std_logic := '1';                                                                      
            q : out std_logic                                                                                  
          );                                                                                                   
     end component;                                                                                                
     
     -- int signals on clock paths
     SIGNAL clk_in_delayed: STD_LOGIC := '0';
     SIGNAL clk_in_mux: STD_LOGIC := '0';
     SIGNAL phasectrl_clkout: STD_LOGIC := '0';
     SIGNAL phaseinvertctrl_out: STD_LOGIC := '0';
 
     SIGNAL m_vcc: STD_LOGIC := '1';
     SIGNAL m_gnd: STD_LOGIC := '0';
     
     -- IO registers
     -- common
     SIGNAL adatasdata_in_r : STD_LOGIC := '0';   -- sync reset - common for transfer and output reg
     SIGNAL sclr_in_r : STD_LOGIC := '0';
     SIGNAL sload_in_r : STD_LOGIC := '0';  
     SIGNAL sclr_in : STD_LOGIC := '0';
     SIGNAL sload_in : STD_LOGIC := '0';
     SIGNAL adatasdata_in : STD_LOGIC := '0';
     SIGNAL clrn_in_r : STD_LOGIC := '1';        -- async reset - common for all registers
     SIGNAL prn_in_r : STD_LOGIC := '1';
     
     SIGNAL datain_q: STD_LOGIC := '0';
     SIGNAL ddio_datain_q: STD_LOGIC := '0';
 
     SIGNAL cycledelay_q: STD_LOGIC := '0';
     SIGNAL ddio_cycledelay_q: STD_LOGIC := '0';
 
     SIGNAL cycledelay_mux_out: STD_LOGIC := '0';
     SIGNAL ddio_cycledelay_mux_out: STD_LOGIC := '0';
 
     SIGNAL bypass_input_reg_mux_out      : STD_LOGIC := '0';
     SIGNAL ddio_bypass_input_reg_mux_out : STD_LOGIC := '0';
 
     SIGNAL not_clk_in_mux: STD_LOGIC := '0';
     
     SIGNAL ddio_out_clk_mux: STD_LOGIC := '0';
     SIGNAL ddio_out_lo_q: STD_LOGIC := '0';
     SIGNAL ddio_out_hi_q: STD_LOGIC := '0';
     
     -- transfer delay now by negative clk
     SIGNAL transfer_q: STD_LOGIC := '0';
     SIGNAL ddio_transfer_q: STD_LOGIC := '0';
 
     -- Duty Cycle Delay
     SIGNAL dcd_in            : STD_LOGIC := '0';
     SIGNAL dcd_out           : STD_LOGIC := '0';
     SIGNAL dcd_both          : STD_LOGIC := '0';
     SIGNAL dcd_both_gnd      : STD_LOGIC := '0';
     SIGNAL dcd_both_vcc      : STD_LOGIC := '0';
     SIGNAL dcd_fallnrise     : STD_LOGIC := '0';
     SIGNAL dcd_fallnrise_gnd : STD_LOGIC := '0';
     SIGNAL dcd_fallnrise_vcc : STD_LOGIC := '0';
     SIGNAL dcd_rising_dly    : INTEGER := 0;
     SIGNAL dcd_falling_dly   : INTEGER := 0;
 
     SIGNAL dlyclk_clk: STD_LOGIC := '0';
     SIGNAL dlyclk_d: STD_LOGIC := '0';
     SIGNAL dlyclk_q: STD_LOGIC := '0';
     SIGNAL ddio_dlyclk_d: STD_LOGIC := '0';
     SIGNAL ddio_dlyclk_q: STD_LOGIC := '0';
 
     SIGNAL dlyclk_clkena_in: STD_LOGIC := '0';     -- shared    
     SIGNAL dlyclk_extended_q: STD_LOGIC := '0';
     SIGNAL dlyclk_extended_clk: STD_LOGIC := '0';
 
     SIGNAL normal_dataout: STD_LOGIC := '0';
     SIGNAL extended_dataout: STD_LOGIC := '0';
     SIGNAL ddio_dataout: STD_LOGIC := '0';
     SIGNAL tmp_dataout: STD_LOGIC := '0';
 
     
     -- timing inputs
     SIGNAL datain_in              : std_logic_vector(1 downto 0) := (OTHERS => '0');
     SIGNAL clk_in                 : std_logic := '0';
     SIGNAL delayctrlin_in         : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL phasectrlin_in         : std_logic_vector(3 downto 0) := (OTHERS => '0');
     SIGNAL areset_in              : std_logic := '0';
     SIGNAL sreset_in              : std_logic := '0';
     SIGNAL clkena_in              : std_logic := '1';
     SIGNAL enaoutputcycledelay_in : std_logic := '0';
     SIGNAL enaphasetransferreg_in : std_logic := '0';
     SIGNAL phaseinvertctrl_in     : std_logic := '0';
     
     SIGNAL delaymode_in: std_logic := '0';
     SIGNAL dutycycledelayctrlin_in : std_logic_vector(3 downto 0) := (OTHERS => '0');
  
 BEGIN
 
     -- filtering X/U etc.
     delaymode_in <= '1' WHEN (delaymode = '1') ELSE '0';
     dutycycledelayctrlin_in(0) <= '1' WHEN (dutycycledelayctrlin(0) = '1') ELSE '0';
     dutycycledelayctrlin_in(1) <= '1' WHEN (dutycycledelayctrlin(1) = '1') ELSE '0';
     dutycycledelayctrlin_in(2) <= '1' WHEN (dutycycledelayctrlin(2) = '1') ELSE '0';
     dutycycledelayctrlin_in(3) <= '1' WHEN (dutycycledelayctrlin(3) = '1') ELSE '0';
 
     -- delay chain for clk_in delay
     m_clk_in_delay_chain : stratixiii_ddr_delay_chain_s 
         GENERIC MAP (
             phase_setting               => phase_setting_for_delayed_clock,
             use_phasectrlin             => "false",
             delay_buffer_mode           => delay_buffer_mode,
             sim_low_buffer_intrinsic_delay  => sim_low_buffer_intrinsic_delay,
             sim_high_buffer_intrinsic_delay => sim_high_buffer_intrinsic_delay,
             sim_buffer_delay_increment      => sim_buffer_delay_increment
         )
         PORT MAP(
             clk            => clk_in, 
             delayctrlin    => delayctrlin_in, 
             phasectrlin    => phasectrlin_in, 
             delayed_clkout => clk_in_delayed
        ); 
        
     -- clock source for datain and cycle delay registers
     clk_in_mux <= clk_in_delayed WHEN (use_delayed_clock = "true") ELSE clk_in;
 
     -- delay chain for phase control
     m_delay_chain : stratixiii_ddr_delay_chain_s 
         GENERIC MAP (
             phase_setting               => phase_setting,
             use_phasectrlin             => use_phasectrlin,
             delay_buffer_mode           => delay_buffer_mode,
             sim_low_buffer_intrinsic_delay  => sim_low_buffer_intrinsic_delay,
             sim_high_buffer_intrinsic_delay => sim_high_buffer_intrinsic_delay,
             phasectrlin_limit               => 10,
             sim_buffer_delay_increment      => sim_buffer_delay_increment
         )
         PORT MAP(
             clk            => clk_in, 
             delayctrlin    => delayctrlin_in, 
             phasectrlin    => phasectrlin_in, 
             delayed_clkout => phasectrl_clkout
        ); 
        
     -- primary outputs
     normal_dataout   <= dlyclk_q;
     extended_dataout <= dlyclk_q OR dlyclk_extended_q;    -- oe port is active low
     ddio_dataout     <= ddio_out_hi_q WHEN (ddio_out_clk_mux = '1') ELSE ddio_out_lo_q;
     tmp_dataout      <= ddio_dataout     WHEN (operation_mode = "ddio_out") ELSE
                         extended_dataout WHEN (operation_mode = "extended_oe" OR operation_mode = "extended_rtena") ELSE
                         normal_dataout   WHEN (operation_mode = "output" OR operation_mode = "oe" OR operation_mode = "rtena") ELSE  
                         'Z';
     dataout <= tmp_dataout;   
                            
     ddio_out_clk_mux <= dlyclk_clk after 1 ps;  -- symbolic T4 to remove glitch on data_h
     ddio_out_lo_q <= dlyclk_q after 2 ps;       -- symbolic 2 T4 to remove glitch on data_l
     ddio_out_hi_q <= ddio_dlyclk_q;
 
     -- resolve reset modes
     PROCESS(areset_in)
     BEGIN
         IF (async_mode = "clear") THEN
             clrn_in_r  <= not areset_in;
             prn_in_r   <= '1';
         ELSIF (async_mode = "preset") THEN
             prn_in_r   <=  not areset_in;
             clrn_in_r  <= '1';
         END IF;
     END PROCESS;
 
     PROCESS(sreset_in)
     BEGIN
         IF (sync_mode = "clear") THEN
             sclr_in_r       <= sreset_in;
             adatasdata_in_r <= '0';
             sload_in_r      <= '0';      
         ELSIF (sync_mode = "preset") THEN
             sload_in_r      <= sreset_in;  
             adatasdata_in_r <= '1';
             sclr_in_r       <= '0';
         END IF;
     END PROCESS;
     
 
     sclr_in   <= '0' WHEN (operation_mode = "rtena" OR operation_mode = "extended_rtena") ELSE sclr_in_r;
     sload_in  <= '0' WHEN (operation_mode = "rtena" OR operation_mode = "extended_rtena") ELSE sload_in_r; 
     adatasdata_in    <= adatasdata_in_r;
     dlyclk_clkena_in <= '1' WHEN (operation_mode = "rtena" OR operation_mode = "extended_rtena") ELSE clkena_in;
 
     -- Datain Register
     datain_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in(0), 
             clk     => clk_in_mux, 
             ena     => m_vcc, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => datain_q
         );
          
     -- DDIO Datain Register  
     ddio_datain_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in(1), 
             clk     => clk_in_mux, 
             ena     => m_vcc, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => ddio_datain_q
        );
 
     -- Cycle Delay Register  
     cycledelay_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_q, 
             clk     => clk_in_mux, 
             ena     => m_vcc, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => cycledelay_q
         );
          
     -- DDIO Cycle Delay Register  
     ddio_cycledelay_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => ddio_datain_q, 
             clk     => clk_in_mux, 
             ena     => m_vcc, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => ddio_cycledelay_q
         );
 
     -- enaoutputcycledelay data path mux
     cycledelay_mux_out <=  cycledelay_q WHEN (add_output_cycle_delay = "true")  ELSE 
                            datain_q     WHEN (add_output_cycle_delay = "false") ELSE
                            cycledelay_q WHEN (enaoutputcycledelay_in = m_vcc)   ELSE
                            datain_q;
 
     -- input register bypass mux
     bypass_input_reg_mux_out <= datain_in(0) WHEN (bypass_input_register = "true") ELSE cycledelay_mux_out;
 
     --assign #300 transfer_q = cycledelay_mux_out;
     -- transfer delay is implemented with negative register in rev1.26 
     transferdelay_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => bypass_input_reg_mux_out, 
             clk     => not_clk_in_mux,
             ena     => m_vcc, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => sclr_in, 
             sload   => sload_in,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => transfer_q
         );
 
     -- add phase transfer data path mux
     dlyclk_d <=  transfer_q   WHEN (add_phase_transfer_reg = "true")  ELSE 
                  bypass_input_reg_mux_out WHEN (add_phase_transfer_reg = "false") ELSE
                  transfer_q   WHEN (enaphasetransferreg_in = m_vcc)   ELSE 
                  bypass_input_reg_mux_out;
 
     -- clock mux for the output register
     phaseinvertctrl_out <=  (not phasectrl_clkout) WHEN (invert_phase = "true")      ELSE
                             phasectrl_clkout       WHEN (invert_phase = "false")     ELSE
                             (not phasectrl_clkout) WHEN (phaseinvertctrl_in = m_vcc) ELSE 
                             phasectrl_clkout;
 
     -- Duty Cycle Delay
     dcd_in <= phaseinvertctrl_out WHEN (use_phasectrl_clock = "true") ELSE clk_in_mux;
 
     PROCESS(dutycycledelayctrlin_in)
         variable init : boolean := true;
         variable dcd_table_rising : delay_chain_int_vec(15 downto 0) := (OTHERS => 0);
         variable dcd_table_falling : delay_chain_int_vec(15 downto 0) := (OTHERS => 0);
         variable dcd_dly_setting : integer := 0;
     begin
         if (init) then
             dcd_table_rising(0) := sim_dutycycledelayctrlin_rising_delay_0;
             dcd_table_rising(1) := sim_dutycycledelayctrlin_rising_delay_1;
             dcd_table_rising(2) := sim_dutycycledelayctrlin_rising_delay_2;
             dcd_table_rising(3) := sim_dutycycledelayctrlin_rising_delay_3;
             dcd_table_rising(4) := sim_dutycycledelayctrlin_rising_delay_4;
             dcd_table_rising(5) := sim_dutycycledelayctrlin_rising_delay_5;
             dcd_table_rising(6) := sim_dutycycledelayctrlin_rising_delay_6;
             dcd_table_rising(7) := sim_dutycycledelayctrlin_rising_delay_7;
             dcd_table_rising(8) := sim_dutycycledelayctrlin_rising_delay_8;
             dcd_table_rising(9) := sim_dutycycledelayctrlin_rising_delay_9;
             dcd_table_rising(10) := sim_dutycycledelayctrlin_rising_delay_10;
             dcd_table_rising(11) := sim_dutycycledelayctrlin_rising_delay_11;
             dcd_table_rising(12) := sim_dutycycledelayctrlin_rising_delay_12;
             dcd_table_rising(13) := sim_dutycycledelayctrlin_rising_delay_13;
             dcd_table_rising(14) := sim_dutycycledelayctrlin_rising_delay_14;
             dcd_table_rising(15) := sim_dutycycledelayctrlin_rising_delay_15;
 
             dcd_table_falling(0) := sim_dutycycledelayctrlin_falling_delay_0;
             dcd_table_falling(1) := sim_dutycycledelayctrlin_falling_delay_1;
             dcd_table_falling(2) := sim_dutycycledelayctrlin_falling_delay_2;
             dcd_table_falling(3) := sim_dutycycledelayctrlin_falling_delay_3;
             dcd_table_falling(4) := sim_dutycycledelayctrlin_falling_delay_4;
             dcd_table_falling(5) := sim_dutycycledelayctrlin_falling_delay_5;
             dcd_table_falling(6) := sim_dutycycledelayctrlin_falling_delay_6;
             dcd_table_falling(7) := sim_dutycycledelayctrlin_falling_delay_7;
             dcd_table_falling(8) := sim_dutycycledelayctrlin_falling_delay_8;
             dcd_table_falling(9) := sim_dutycycledelayctrlin_falling_delay_9;
             dcd_table_falling(10) := sim_dutycycledelayctrlin_falling_delay_10;
             dcd_table_falling(11) := sim_dutycycledelayctrlin_falling_delay_11;
             dcd_table_falling(12) := sim_dutycycledelayctrlin_falling_delay_12;
             dcd_table_falling(13) := sim_dutycycledelayctrlin_falling_delay_13;
             dcd_table_falling(14) := sim_dutycycledelayctrlin_falling_delay_14;
             dcd_table_falling(15) := sim_dutycycledelayctrlin_falling_delay_15;
 
             init := false;
         end if;
 
        dcd_dly_setting := alt_conv_integer(dutycycledelayctrlin_in);
        dcd_rising_dly  <= dcd_table_rising(dcd_dly_setting);
        dcd_falling_dly <= dcd_table_falling(dcd_dly_setting);
     end process; -- generating dynamic delays
 
     PROCESS(dcd_in)
     BEGIN
         dcd_both_gnd <= dcd_in;
 
         if (dcd_in = '0') then
             dcd_both_vcc <= transport dcd_in after (dcd_falling_dly * 1 ps);
         else
             dcd_both_vcc <= transport dcd_in after (dcd_rising_dly * 1 ps);
         end if;
     END PROCESS;
         
     PROCESS(dcd_in)
     BEGIN
         if (dcd_in = '0') then
             dcd_fallnrise_gnd <= transport dcd_in after (dcd_falling_dly * 1 ps);
         else
             dcd_fallnrise_vcc <= transport dcd_in after (dcd_rising_dly * 1 ps);
         end if;
     END PROCESS;
                         
     dcd_both      <= dcd_both_vcc      WHEN (delaymode_in = '1')             ELSE dcd_both_gnd; 
     dcd_fallnrise <= dcd_fallnrise_vcc WHEN (delaymode_in = '1')             ELSE dcd_fallnrise_gnd; 
     dlyclk_clk    <= dcd_both          WHEN (duty_cycle_delay_mode = "both") ELSE
                      dcd_fallnrise     WHEN (duty_cycle_delay_mode = "fallnrise") ELSE dcd_in;
 
     -- Output Register clocked by phasectrl_clk
     dlyclk_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => dlyclk_d, 
             clk     => dlyclk_clk, 
             ena     => dlyclk_clkena_in, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => sclr_in, 
             sload   => sload_in,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => dlyclk_q
         );
 
     -- enaoutputcycledelay data path mux
     ddio_cycledelay_mux_out <= ddio_cycledelay_q WHEN (add_output_cycle_delay = "true")  ELSE 
                                ddio_datain_q     WHEN (add_output_cycle_delay = "false") ELSE
                                ddio_cycledelay_q WHEN (enaoutputcycledelay_in = m_vcc)   ELSE 
                                ddio_datain_q;
 
     -- input register bypass mux
     ddio_bypass_input_reg_mux_out <= datain_in(1) WHEN (bypass_input_register = "true") ELSE ddio_cycledelay_mux_out;
                              
     --assign #300 ddio_transfer_q = ddio_cycledelay_mux_out;
     -- transfer delay is implemented with negative register in rev1.26 
     not_clk_in_mux <= not clk_in_mux;
     
     ddio_transferdelay_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => ddio_bypass_input_reg_mux_out, 
             clk     => not_clk_in_mux,
             ena     => m_vcc, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => sclr_in, 
             sload   => sload_in,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => ddio_transfer_q
         );
 
     -- add phase transfer data path mux
     ddio_dlyclk_d <= ddio_transfer_q   WHEN (add_phase_transfer_reg = "true")  ELSE 
                      ddio_bypass_input_reg_mux_out WHEN (add_phase_transfer_reg = "false") ELSE
                      ddio_transfer_q   WHEN (enaphasetransferreg_in = m_vcc)   ELSE 
                      ddio_bypass_input_reg_mux_out;
 
     -- Output Register clocked by phasectrl_clk
     ddio_dlyclk_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => ddio_dlyclk_d, 
             clk     => dlyclk_clk, 
             ena     => dlyclk_clkena_in, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => sclr_in, 
             sload   => sload_in,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => ddio_dlyclk_q
         );
 
     -- Extension Register
     dlyclk_extended_clk <= not dlyclk_clk;
 
     dlyclk_extended_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => dlyclk_q, 
             clk     => dlyclk_extended_clk, 
             ena     => dlyclk_clkena_in, 
             clrn    => clrn_in_r, 
             prn     => prn_in_r,
             aload   => m_gnd, 
             asdata  => adatasdata_in, 
             sclr    => sclr_in, 
             sload   => sload_in,
             devclrn => devclrn,
             devpor  => devpor, 
             q       => dlyclk_extended_q
          );
     
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         loopbits_datain : FOR i in datain'RANGE GENERATE
             VitalWireDelay (datain_in(i), datain(i), tipd_datain(i));
         END GENERATE;
         VitalWireDelay (clk_in,       clk,       tipd_clk);
         loopbits_delayctrlin : FOR i in delayctrlin'RANGE GENERATE
             VitalWireDelay (delayctrlin_in(i), delayctrlin(i), tipd_delayctrlin(i));
         END GENERATE;
         loopbits_phasectrlin : FOR i in phasectrlin'RANGE GENERATE
             VitalWireDelay (phasectrlin_in(i), phasectrlin(i), tipd_phasectrlin(i));
         END GENERATE;
         VitalWireDelay (areset_in,       areset,       tipd_areset);
         VitalWireDelay (sreset_in,       sreset,       tipd_sreset);
         VitalWireDelay (clkena_in,       clkena,       tipd_clkena);   
              
         VitalWireDelay (enaoutputcycledelay_in, enaoutputcycledelay, tipd_enaoutputcycledelay);
         VitalWireDelay (enaphasetransferreg_in, enaphasetransferreg, tipd_enaphasetransferreg);
         VitalWireDelay (phaseinvertctrl_in,     phaseinvertctrl,     tipd_phaseinvertctrl);
     end block;
     
 END stratixiii_output_phase_alignment_arch;
 
 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_input_phase_alignment
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
 use work.stratixiii_ddr_io_reg;
 use work.stratixiii_ddr_delay_chain_s;
  
 ENTITY stratixiii_input_phase_alignment IS
     GENERIC ( 
         use_phasectrlin                 : string := "true";
         phase_setting                   : integer := 0;
         delay_buffer_mode               : string := "high";
         power_up                        : string := "low";
         async_mode                      : string := "none";
         add_input_cycle_delay           : string := "false";
         bypass_output_register          : string := "false";
         add_phase_transfer_reg          : string := "false";
         invert_phase                    : string := "false";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment      : integer := 10;        
         lpm_type                 : string := "stratixiii_input_phase_alignment";
         tipd_datain              : VitalDelayType01 := DefpropDelay01;
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
         tipd_phasectrlin         : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
         tipd_areset              : VitalDelayType01 := DefpropDelay01;
         tipd_enainputcycledelay  : VitalDelayType01 := DefpropDelay01;
         tipd_enaphasetransferreg : VitalDelayType01 := DefpropDelay01;
         tipd_phaseinvertctrl     : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         datain              : IN std_logic := '0';
         clk                 : IN std_logic := '0';
         delayctrlin         : IN std_logic_vector(5 downto 0) := (OTHERS => '0');
         phasectrlin         : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
         areset              : IN std_logic := '0';
         enainputcycledelay  : IN std_logic := '0';
         enaphasetransferreg : IN std_logic := '0';
         phaseinvertctrl     : IN std_logic := '0';
         devclrn             : IN std_logic := '1';
         devpor              : IN std_logic := '1';
         dataout             : OUT std_logic;
         dffin               : OUT std_logic;
         dff1t               : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_input_phase_alignment_arch OF stratixiii_input_phase_alignment IS
     -- component section
     COMPONENT stratixiii_ddr_delay_chain_s
     GENERIC (
         use_phasectrlin : string  := "true";
         phase_setting   : integer :=  0;
         delay_buffer_mode               : string  := "high";
         sim_low_buffer_intrinsic_delay  : integer := 350;
         sim_high_buffer_intrinsic_delay : integer := 175;
         sim_buffer_delay_increment  : integer := 10;
         phasectrlin_limit           : integer := 7
     );
     PORT (
         clk         : IN std_logic := '0';
         delayctrlin : IN std_logic_vector(5 DOWNTO 0) := (OTHERS => '0');
         phasectrlin : IN std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
         delayed_clkout : OUT std_logic
     );
     END COMPONENT;
     
     component stratixiii_ddr_io_reg                                                                                              
     generic (                                                                                                 
              power_up : string := "DONT_CARE";                                                                
              is_wysiwyg : string := "false";                                                                  
              x_on_violation : string := "on";                                                                 
              tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                
              tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                           
              tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                 
              thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                               
              tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;                                          
              tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;                                         
              tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;                                        
              tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                                                
              tipd_clk : VitalDelayType01 := DefPropDelay01;                                                   
              tipd_d : VitalDelayType01 := DefPropDelay01;                                                     
              tipd_asdata : VitalDelayType01 := DefPropDelay01;                                                
              tipd_sclr : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_sload : VitalDelayType01 := DefPropDelay01;                                                 
              tipd_clrn : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_prn : VitalDelayType01 := DefPropDelay01;                                                   
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
            d : in std_logic := '0';                                                                           
            clk : in std_logic := '0';                                                                         
            ena : in std_logic := '1';                                                                         
            clrn : in std_logic := '1';                                                                        
            prn : in std_logic := '1';                                                                         
            aload : in std_logic := '0';                                                                       
            asdata : in std_logic := '0';                                                                      
            sclr : in std_logic := '0';                                                                        
            sload : in std_logic := '0';                                                                       
            devclrn : in std_logic := '1';                                                                     
            devpor : in std_logic := '1';                                                                      
            q : out std_logic                                                                                  
          );                                                                                                   
     end component;                                                                                                
     
     -- int signals
     SIGNAL phasectrl_clkout : STD_LOGIC := '0';
     SIGNAL delayed_clk : STD_LOGIC := '0';
     SIGNAL not_delayed_clk : STD_LOGIC := '1';
     
     SIGNAL m_vcc: STD_LOGIC := '1';
     SIGNAL m_gnd: STD_LOGIC := '0';
 
     -- IO registers
     -- common
     SIGNAL adatasdata_in_r : STD_LOGIC := '0';
     SIGNAL aload_in_r : STD_LOGIC := '0';
 
     SIGNAL datain_q : STD_LOGIC := '0';
 
     SIGNAL cycledelay_q : STD_LOGIC := '0';
     SIGNAL cycledelay_mux_out : STD_LOGIC := '0';
     SIGNAL cycledelay_mux_out_dly : STD_LOGIC := '0';
 
     SIGNAL dlyclk_d : STD_LOGIC := '0';
     SIGNAL dlyclk_q : STD_LOGIC := '0';
 
     SIGNAL tmp_dataout : STD_LOGIC := '0';
     
     -- timing inputs
     SIGNAL datain_in              : std_logic := '0';
     SIGNAL clk_in                 : std_logic := '0';
     SIGNAL delayctrlin_in         : std_logic_vector(5 downto 0) := (OTHERS => '0');
     SIGNAL phasectrlin_in         : std_logic_vector(3 downto 0) := (OTHERS => '0');
     SIGNAL areset_in              : std_logic := '0';
     SIGNAL enainputcycledelay_in  : std_logic := '0';
     SIGNAL enaphasetransferreg_in : std_logic := '0';
     SIGNAL phaseinvertctrl_in     : std_logic := '0';
 
 BEGIN
     m_clk_in_delay_chain : stratixiii_ddr_delay_chain_s 
         GENERIC MAP (
             phase_setting               => phase_setting,
             use_phasectrlin             => use_phasectrlin,
             delay_buffer_mode           => delay_buffer_mode,
             sim_low_buffer_intrinsic_delay  => sim_low_buffer_intrinsic_delay,
             sim_high_buffer_intrinsic_delay => sim_high_buffer_intrinsic_delay,
             sim_buffer_delay_increment      => sim_buffer_delay_increment
         )
         PORT MAP(
             clk            => clk_in, 
             delayctrlin    => delayctrlin_in, 
             phasectrlin    => phasectrlin_in, 
             delayed_clkout => phasectrl_clkout
        );
         
     delayed_clk <= (not phasectrl_clkout) WHEN (invert_phase = "true")  ELSE
                    phasectrl_clkout       WHEN (invert_phase = "false") ELSE
                    (not phasectrl_clkout) WHEN (phaseinvertctrl_in = '1') ELSE
                    phasectrl_clkout;
                      
 
     -- primary output
     dataout <= tmp_dataout;
     tmp_dataout <= dlyclk_d WHEN (bypass_output_register = "true") ELSE dlyclk_q;
 
     -- add phase transfer data path mux
     dlyclk_d <= cycledelay_mux_out_dly WHEN (add_phase_transfer_reg = "true")    ELSE 
                 cycledelay_mux_out     WHEN (add_phase_transfer_reg = "false")   ELSE
                 cycledelay_mux_out_dly WHEN (enaphasetransferreg_in = '1')       ELSE 
                 cycledelay_mux_out;
 
     -- enaoutputcycledelay data path mux
     cycledelay_mux_out <= cycledelay_q  WHEN (add_input_cycle_delay = "true")    ELSE 
                           datain_q      WHEN (add_input_cycle_delay = "false")   ELSE
                           cycledelay_q  WHEN (enainputcycledelay_in = '1')       ELSE 
                           datain_q;
 
     -- resolve reset modes
     PROCESS (areset_in)
     BEGIN 
         if (async_mode = "clear") then
             aload_in_r   <= areset_in;
             adatasdata_in_r <= '0';
         elsif (async_mode = "preset") then
             aload_in_r   <= areset_in;
             adatasdata_in_r <= '1';
         else      -- async_mode = "none"
             adatasdata_in_r <= 'Z';
         end if;
     END PROCESS;
 
 
     -- Datain Register  
     datain_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in, 
             clk     => delayed_clk, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => datain_q
         );
          
     -- Cycle Delay Register  
     cycledelay_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_q, 
             clk     => delayed_clk, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => cycledelay_q
         );
 
     -- assign #300 cycledelay_mux_out_dly = cycledelay_mux_out;  replaced by neg reg   
     -- Transfer Register  - clocked by negative edge
     not_delayed_clk <= not delayed_clk;
     
     transfer_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => cycledelay_mux_out, 
             clk     => not_delayed_clk,  -- ~delayed_clk
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => cycledelay_mux_out_dly
         );
          
          
     -- Register clocked by actually by clk_in
     dlyclk_reg : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => dlyclk_d, 
             clk     => clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dlyclk_q
         );
 
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (datain_in,       datain,       tipd_datain);
         VitalWireDelay (clk_in,       clk,       tipd_clk);
         loopbits_delayctrlin : FOR i in delayctrlin'RANGE GENERATE
             VitalWireDelay (delayctrlin_in(i), delayctrlin(i), tipd_delayctrlin(i));
         END GENERATE;
         loopbits_phasectrlin : FOR i in phasectrlin'RANGE GENERATE
             VitalWireDelay (phasectrlin_in(i), phasectrlin(i), tipd_phasectrlin(i));
         END GENERATE;
         VitalWireDelay (areset_in,               areset,               tipd_areset);
         VitalWireDelay (enainputcycledelay_in,   enainputcycledelay,   tipd_enainputcycledelay);
         VitalWireDelay (enaphasetransferreg_in,  enaphasetransferreg,  tipd_enaphasetransferreg);
         VitalWireDelay (phaseinvertctrl_in,      phaseinvertctrl,      tipd_phaseinvertctrl);
     end block;
     
 END stratixiii_input_phase_alignment_arch;
 
 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_half_rate_input
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
 use work.stratixiii_ddr_io_reg;
     
 ENTITY stratixiii_half_rate_input IS
     GENERIC ( 
         power_up           : string := "low";
         async_mode         : string := "none";
         use_dataoutbypass  : string := "false";
         lpm_type           : string := "stratixiii_half_rate_input";
         tipd_datain              : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
         tipd_directin            : VitalDelayType01 := DefpropDelay01;
         tipd_clk                 : VitalDelayType01 := DefpropDelay01;
         tipd_areset              : VitalDelayType01 := DefpropDelay01;
         tipd_dataoutbypass       : VitalDelayType01 := DefpropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         datain       : IN std_logic_vector(1 downto 0) := (OTHERS => '0');
         directin     : IN std_logic := '0';
         clk          : IN std_logic := '0';
         areset       : IN std_logic := '0';
         dataoutbypass: IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dataout      : OUT std_logic_vector(3 downto 0);
         dffin        : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_half_rate_input_arch OF stratixiii_half_rate_input IS
     -- component section
     component stratixiii_ddr_io_reg                                                                                              
     generic (                                                                                                 
              power_up : string := "DONT_CARE";                                                                
              is_wysiwyg : string := "false";                                                                  
              x_on_violation : string := "on";                                                                 
              tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                
              tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                           
              tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                                 
              thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                            
              thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                              
              thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                             
              thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;                               
              tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;                                          
              tpd_clrn_q_negedge : VitalDelayType01 := DefPropDelay01;                                         
              tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;                                        
              tpd_asdata_q: VitalDelayType01 := DefPropDelay01;                                                
              tipd_clk : VitalDelayType01 := DefPropDelay01;                                                   
              tipd_d : VitalDelayType01 := DefPropDelay01;                                                     
              tipd_asdata : VitalDelayType01 := DefPropDelay01;                                                
              tipd_sclr : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_sload : VitalDelayType01 := DefPropDelay01;                                                 
              tipd_clrn : VitalDelayType01 := DefPropDelay01;                                                  
              tipd_prn : VitalDelayType01 := DefPropDelay01;                                                   
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
            d : in std_logic := '0';                                                                           
            clk : in std_logic := '0';                                                                         
            ena : in std_logic := '1';                                                                         
            clrn : in std_logic := '1';                                                                        
            prn : in std_logic := '1';                                                                         
            aload : in std_logic := '0';                                                                       
            asdata : in std_logic := '0';                                                                      
            sclr : in std_logic := '0';                                                                        
            sload : in std_logic := '0';                                                                       
            devclrn : in std_logic := '1';                                                                     
            devpor : in std_logic := '1';                                                                      
            q : out std_logic                                                                                  
          );                                                                                                   
     end component;                                                                                                
     
     SIGNAL m_vcc: STD_LOGIC := '1';
     SIGNAL m_gnd: STD_LOGIC := '0';
 
     -- IO SIGNAListers
     -- common
     SIGNAL neg_clk_in      : STD_LOGIC := '0';
     SIGNAL adatasdata_in_r : STD_LOGIC := '0';
     SIGNAL aload_in_r      : STD_LOGIC := '0';
 
     -- low_bank  = {1, 0} - capturing datain at falling edge then sending at falling rise 
     -- high_bank = {3, 2} - output of SIGNALister datain at rising 
     SIGNAL high_bank     : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
     SIGNAL low_bank      : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
     SIGNAL low_bank_low  : STD_LOGIC := '0';
     SIGNAL low_bank_high : STD_LOGIC := '0';
     SIGNAL high_bank_low : STD_LOGIC := '0';
     SIGNAL high_bank_high: STD_LOGIC := '0';
 
     SIGNAL dataout_reg_n : STD_LOGIC_VECTOR (1 DOWNTO 0) := (OTHERS => '0');
     SIGNAL tmp_dataout   : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
     
     -- delayed version to ensure 1 latency as expected in functional sim
     SIGNAL datain_in       : std_logic_vector(1 downto 0) := (OTHERS => '0');
     
     -- timing inputs
     SIGNAL datain_ipd      : std_logic_vector(1 downto 0) := (OTHERS => '0');
     SIGNAL directin_in     : std_logic := '0';
     SIGNAL clk_in          : std_logic := '0';
     SIGNAL areset_in       : std_logic := '0';
     SIGNAL dataoutbypass_in: std_logic := '0';
     
 BEGIN
     -- primary input
     datain_in <= transport datain_ipd after 2 ps;
     
     -- primary output
     dataout <= tmp_dataout;
     tmp_dataout(3) <= directin_in WHEN (dataoutbypass_in = '0' AND use_dataoutbypass = "true") ELSE high_bank_high;
     tmp_dataout(2) <= directin_in WHEN (dataoutbypass_in = '0' AND use_dataoutbypass = "true") ELSE high_bank_low;
     tmp_dataout(1) <= low_bank(1);
     tmp_dataout(0) <= low_bank(0);
 
     low_bank  <= low_bank_high  & low_bank_low;
     high_bank <= high_bank_high & high_bank_low;
 
     -- resolve reset modes
     PROCESS(areset_in)
     BEGIN
         if (async_mode = "clear") then
             aload_in_r   <= areset_in;
             adatasdata_in_r <= '0';
         elsif (async_mode = "preset") then
             aload_in_r   <= areset_in;
             adatasdata_in_r <= '1';
         else  -- async_mode = "none"
             adatasdata_in_r <= 'Z';
         end if;
     END PROCESS;
 
     neg_clk_in <= not clk_in;
     
     --  datain_1 - H  
     reg1_h : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in(1), 
             clk     => clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => high_bank_high
         );
 
     --  datain_0 - H  
     reg0_h : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in(0), 
             clk     => clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => high_bank_low
         );
 
     --  datain_1 - L (n)  
     reg1_l_n : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in(1), 
             clk     => neg_clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dataout_reg_n(1)
         );
          
     --  datain_1 - L  
     reg1_l : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => dataout_reg_n(1), 
             clk     => clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => low_bank_high
         );
 
     --  datain_0 - L (n)  
     reg0_l_n : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => datain_in(0), 
             clk     => neg_clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => dataout_reg_n(0)
         );
          
     --  datain_0 - L  
     reg0_l : stratixiii_ddr_io_reg  
         GENERIC MAP (power_up => power_up)  
         PORT MAP( 
             d       => dataout_reg_n(0), 
             clk     => clk_in, 
             ena     => m_vcc, 
             clrn    => m_vcc, 
             prn     => m_vcc,
             aload   => aload_in_r, 
             asdata  => adatasdata_in_r, 
             sclr    => m_gnd, 
             sload   => m_gnd,
             devclrn => devclrn,
             devpor  => devpor,
             q       => low_bank_low
         );
          
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         loopbits_datain : FOR i in datain'RANGE GENERATE
             VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
         END GENERATE;
         VitalWireDelay (directin_in,      directin,      tipd_directin);
         VitalWireDelay (clk_in,           clk,           tipd_clk);
         VitalWireDelay (areset_in,        areset,        tipd_areset);
         VitalWireDelay (dataoutbypass_in, dataoutbypass, tipd_dataoutbypass);
     end block;
     
 END stratixiii_half_rate_input_arch;
 
 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_io_config
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
     
 ENTITY stratixiii_io_config IS
     GENERIC ( 
         enhanced_mode      : string := "false";
         lpm_type           : string := "stratixiii_io_config";
         tipd_datain                       : VitalDelayType01 := DefpropDelay01;
         tipd_clk                          : VitalDelayType01 := DefpropDelay01;
         tipd_ena                          : VitalDelayType01 := DefpropDelay01;
         tipd_update                       : VitalDelayType01 := DefpropDelay01;
         tsetup_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
         thold_datain_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
         tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         datain       : IN std_logic := '0';
         clk          : IN std_logic := '0';
         ena          : IN std_logic := '1';
         update       : IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         -- new STRATIXIV: ww30.2008
         dutycycledelaymode                 : OUT std_logic;
         dutycycledelaysettings             : OUT std_logic_vector(3 downto 0);
         outputfinedelaysetting1            : OUT std_logic;
         outputfinedelaysetting2            : OUT std_logic;
         outputonlydelaysetting2            : OUT std_logic_vector(2 downto 0);
         outputonlyfinedelaysetting2        : OUT std_logic;
         padtoinputregisterfinedelaysetting : OUT std_logic;
         padtoinputregisterdelaysetting : OUT std_logic_vector(3 downto 0);
         outputdelaysetting1            : OUT std_logic_vector(3 downto 0);
         outputdelaysetting2            : OUT std_logic_vector(2 downto 0);
         dataout                        : OUT std_logic
     );
 
 END;
 
 ARCHITECTURE stratixiii_io_config_arch OF stratixiii_io_config IS
     -- component section
     
     SIGNAL shift_reg   : std_logic_vector(10 downto 0) := (OTHERS => '0');
     SIGNAL output_reg  : std_logic_vector(10 downto 0) := (OTHERS => '0');
     SIGNAL tmp_output  : std_logic_vector(10 downto 0) := (OTHERS => '0');
     
     SIGNAL enhance_shift_reg  : std_logic_vector(22 downto 0) := (OTHERS => '0');
     SIGNAL enhance_output_reg : std_logic_vector(22 downto 0) := (OTHERS => '0');
     SIGNAL enhance_tmp_output : std_logic_vector(22 downto 0) := (OTHERS => '0');
  
     -- timing outputs
     SIGNAL tmp_dataout     : std_logic := '0';
     
     -- timing inputs
     SIGNAL datain_in       : std_logic := '0';
     SIGNAL clk_in          : std_logic := '0';
     SIGNAL ena_in          : std_logic := '0';
     SIGNAL update_in       : std_logic := '0';
     
 BEGIN
     -- primary outputs
     tmp_dataout <= enhance_shift_reg(22) WHEN (enhanced_mode = "true") ELSE shift_reg(10);
 
     -- bit order changed in wys revision 1.32
     outputdelaysetting1            <= tmp_output(3 DOWNTO 0);
     outputdelaysetting2            <= tmp_output(6 DOWNTO 4);
     padtoinputregisterdelaysetting <= tmp_output(10 DOWNTO 7);
     -- padtoinputregisterdelaysetting <= tmp_output(3 DOWNTO 0);
     -- outputdelaysetting1            <= tmp_output(7 DOWNTO 4);
     -- outputdelaysetting2            <= tmp_output(10 DOWNTO 8);
     tmp_output <= output_reg;
 
     outputdelaysetting1            <= enhance_tmp_output(3 DOWNTO 0)  WHEN (enhanced_mode = "true") ELSE tmp_output(3 DOWNTO 0);
     outputdelaysetting2            <= enhance_tmp_output(6 DOWNTO 4)  WHEN (enhanced_mode = "true") ELSE tmp_output(6 DOWNTO 4);
     padtoinputregisterdelaysetting <= enhance_tmp_output(10 DOWNTO 7) WHEN (enhanced_mode = "true") ELSE tmp_output(10 DOWNTO 7);
  
     outputfinedelaysetting1            <= enhance_tmp_output(11)      WHEN (enhanced_mode = "true") ELSE '0';
     outputfinedelaysetting2            <= enhance_tmp_output(12)      WHEN (enhanced_mode = "true") ELSE '0';
     padtoinputregisterfinedelaysetting <= enhance_tmp_output(13)      WHEN (enhanced_mode = "true") ELSE '0';
     outputonlyfinedelaysetting2        <= enhance_tmp_output(14)      WHEN (enhanced_mode = "true") ELSE '0';
     outputonlydelaysetting2            <= enhance_tmp_output(17 DOWNTO 15)  WHEN (enhanced_mode = "true") ELSE "000";
     dutycycledelaymode                 <= enhance_tmp_output(18)            WHEN (enhanced_mode = "true") ELSE '0';
     dutycycledelaysettings             <= enhance_tmp_output(22 DOWNTO 19)  WHEN (enhanced_mode = "true") ELSE "0000";
  
     tmp_output <= output_reg;
     enhance_tmp_output <= enhance_output_reg;
 
     PROCESS(clk_in)
     BEGIN
         if (clk_in = '1' AND ena_in = '1') then
             shift_reg(0) <= datain_in;
             shift_reg(10 DOWNTO 1) <= shift_reg(9 DOWNTO 0);
 
             enhance_shift_reg(0) <= datain_in;
             enhance_shift_reg(22 DOWNTO 1) <= enhance_shift_reg(21 DOWNTO 0);
         end if;
     END PROCESS;
 
 
     PROCESS(clk_in)
     BEGIN
         if (clk_in = '1' AND update_in = '1') then
             output_reg <= shift_reg;
             enhance_output_reg <= enhance_shift_reg;
         end if;
     END PROCESS;
 
 
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (datain_in,    datain,    tipd_datain);
         VitalWireDelay (clk_in,       clk,       tipd_clk);
         VitalWireDelay (ena_in,       ena,       tipd_ena);
         VitalWireDelay (update_in,    update,    tipd_update);
     end block;
         
     -----------------------------------
     -- Timing Check Section
     -----------------------------------
     VITAL_timing_check: PROCESS (clk_in,datain_in,ena_in,update_in)
     
     variable Tviol_clk_datain : std_ulogic := '0';
     variable TimingData_clk_datain : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_clk_ena    : std_ulogic := '0';
     variable TimingData_clk_ena    : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_clk_update : std_ulogic := '0';
     variable TimingData_clk_update : VitalTimingDataType := VitalTimingDataInit;
     
     BEGIN
         IF (TimingChecksOn) THEN
             VitalSetupHoldCheck (
                         Violation       => Tviol_clk_datain,
                         TimingData      => TimingData_clk_datain,
                         TestSignal      => datain_in,
                         TestSignalName  => "Datain",
                         RefSignal       => clk_in,
                         RefSignalName   => "clk",
                         SetupHigh       => tsetup_datain_clk_noedge_posedge,
                         SetupLow        => tsetup_datain_clk_noedge_posedge,
                         HoldHigh        => thold_datain_clk_noedge_posedge,
                         HoldLow         => thold_datain_clk_noedge_posedge,
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_IO_CONFIG",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
             VitalSetupHoldCheck (
                         Violation       => Tviol_clk_ena,
                         TimingData      => TimingData_clk_ena,
                         TestSignal      => ena_in,
                         TestSignalName  => "Ena",
                         RefSignal       => clk_in,
                         RefSignalName   => "clk",
                         SetupHigh       => tsetup_datain_clk_noedge_posedge,
                         SetupLow        => tsetup_datain_clk_noedge_posedge,
                         HoldHigh        => thold_datain_clk_noedge_posedge,
                         HoldLow         => thold_datain_clk_noedge_posedge,
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_IO_CONFIG",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
             VitalSetupHoldCheck (
                         Violation       => Tviol_clk_update,
                         TimingData      => TimingData_clk_update,
                         TestSignal      => update_in,
                         TestSignalName  => "Update",
                         RefSignal       => clk_in,
                         RefSignalName   => "clk",
                         SetupHigh       => tsetup_datain_clk_noedge_posedge,
                         SetupLow        => tsetup_datain_clk_noedge_posedge,
                         HoldHigh        => thold_datain_clk_noedge_posedge,
                         HoldLow         => thold_datain_clk_noedge_posedge,
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_IO_CONFIG",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
         END IF;
     END PROCESS;  -- timing check
 
     --------------------------------------
     --  Path Delay Section
     --------------------------------------
     
     VITAL_path_delays: PROCESS (tmp_dataout)
     
         variable dataout_VitalGlitchData : VitalGlitchDataType;
     
     BEGIN
         VitalPathDelay01 (
             OutSignal => dataout,
             OutSignalName => "Dataout",
             OutTemp => tmp_dataout,
             Paths =>   (0 => (clk_in'last_event, tpd_clk_dataout_posedge, TRUE)),
             GlitchData => dataout_VitalGlitchData,
             Mode => DefGlitchMode,
             XOn  => XOn,
             MsgOn  => MsgOn );
     
     END PROCESS;  -- Path Delays
         
 END stratixiii_io_config_arch;
 
 -------------------------------------------------------------------------------
 --
 -- Entity Name : stratixiii_dqs_config
 --
 -------------------------------------------------------------------------------
 
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.VITAL_Timing.all;
 use IEEE.VITAL_Primitives.all;
 use work.stratixiii_atom_pack.all;
     
 ENTITY stratixiii_dqs_config IS
     GENERIC ( 
         enhanced_mode            : string := "false";
         lpm_type                 : string := "stratixiii_dqs_config";
         tipd_datain                       : VitalDelayType01 := DefpropDelay01;
         tipd_clk                          : VitalDelayType01 := DefpropDelay01;
         tipd_ena                          : VitalDelayType01 := DefpropDelay01;
         tipd_update                       : VitalDelayType01 := DefpropDelay01;
         tsetup_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
         thold_datain_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
         tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
         TimingChecksOn           : Boolean := True;
         MsgOn                    : Boolean := DefGlitchMsgOn;
         XOn                      : Boolean := DefGlitchXOn;
         MsgOnChecks              : Boolean := DefMsgOnChecks;
         XOnChecks                : Boolean := DefXOnChecks;
         InstancePath             : String := "*"   
     );
     
     PORT (
         datain       : IN std_logic := '0';
         clk          : IN std_logic := '0';
         ena          : IN std_logic := '0';
         update       : IN std_logic := '0';
         devclrn      : IN std_logic := '1';
         devpor       : IN std_logic := '1';
         dqsbusoutfinedelaysetting   : OUT std_logic;  -- new in STRATIXIV
         dqsenablefinedelaysetting   : OUT std_logic;  -- new in STRATIXIV
         dqsbusoutdelaysetting     : OUT std_logic_vector(3 downto 0);          
         dqsinputphasesetting      : OUT std_logic_vector(2 downto 0);
         dqsenablectrlphasesetting : OUT std_logic_vector(3 downto 0);
         dqsoutputphasesetting     : OUT std_logic_vector(3 downto 0);
         dqoutputphasesetting      : OUT std_logic_vector(3 downto 0);
         resyncinputphasesetting   : OUT std_logic_vector(3 downto 0);
         dividerphasesetting       : OUT std_logic;
         enaoctcycledelaysetting   : OUT std_logic;
         enainputcycledelaysetting : OUT std_logic;
         enaoutputcycledelaysetting: OUT std_logic;
         dqsenabledelaysetting     : OUT std_logic_vector(2 downto 0);
         octdelaysetting1          : OUT std_logic_vector(3 downto 0);
         octdelaysetting2          : OUT std_logic_vector(2 downto 0);
         enadataoutbypass          : OUT std_logic;
         enadqsenablephasetransferreg : OUT std_logic;
         enaoctphasetransferreg    : OUT std_logic;       
         enaoutputphasetransferreg : OUT std_logic;   
         enainputphasetransferreg  : OUT std_logic;
         resyncinputphaseinvert    : OUT std_logic;
         dqsenablectrlphaseinvert  : OUT std_logic;
         dqoutputphaseinvert       : OUT std_logic;        
         dqsoutputphaseinvert      : OUT std_logic; 
         dataout                   : OUT std_logic
     );
 
 END;
     
 ARCHITECTURE stratixiii_dqs_config_arch OF stratixiii_dqs_config IS
     -- component section
     
     SIGNAL shift_reg  : STD_LOGIC_VECTOR (47 DOWNTO 0) := (OTHERS => '0');
     SIGNAL output_reg : STD_LOGIC_VECTOR (47 DOWNTO 0) := (OTHERS => '0');
     SIGNAL tmp_output : STD_LOGIC_VECTOR (47 DOWNTO 0) := (OTHERS => '0');
     
     -- timing outputs
     SIGNAL tmp_dataout     : std_logic := '0';
     
     -- timing inputs
     SIGNAL datain_in       : std_logic := '0';
     SIGNAL clk_in          : std_logic := '0';
     SIGNAL ena_in          : std_logic := '0';
     SIGNAL update_in       : std_logic := '0';
     
 BEGIN
     -- primary outputs
     tmp_dataout <= shift_reg(47) WHEN (enhanced_mode = "true")ELSE shift_reg(45);
 
     dqsbusoutdelaysetting     <= tmp_output(3   DOWNTO  0);
     dqsinputphasesetting      <= tmp_output(6   DOWNTO  4);
     dqsenablectrlphasesetting <= tmp_output(10  DOWNTO  7);
     dqsoutputphasesetting     <= tmp_output(14  DOWNTO  11);
     dqoutputphasesetting      <= tmp_output(18  DOWNTO  15);
     resyncinputphasesetting   <= tmp_output(22  DOWNTO  19);
     dividerphasesetting       <= tmp_output(23);
     enaoctcycledelaysetting   <= tmp_output(24);
     enainputcycledelaysetting <= tmp_output(25);
     enaoutputcycledelaysetting<= tmp_output(26);
     dqsenabledelaysetting     <= tmp_output(29  DOWNTO  27);
     octdelaysetting1          <= tmp_output(33  DOWNTO  30);
     octdelaysetting2          <= tmp_output(36  DOWNTO  34);
     enadataoutbypass          <= tmp_output(37);
     enadqsenablephasetransferreg <= tmp_output(38); -- new in 1.23
     enaoctphasetransferreg       <= tmp_output(39); -- new in 1.23 
     enaoutputphasetransferreg    <= tmp_output(40); -- new in 1.23
     enainputphasetransferreg     <= tmp_output(41); -- new in 1.23
     resyncinputphaseinvert       <= tmp_output(42);    -- new in 1.26
     dqsenablectrlphaseinvert     <= tmp_output(43);    -- new in 1.26
     dqoutputphaseinvert          <= tmp_output(44);    -- new in 1.26
     dqsoutputphaseinvert         <= tmp_output(45);    -- new in 1.26
     -- new in STRATIXIV: ww30.2008
     dqsbusoutfinedelaysetting    <= tmp_output(46) WHEN (enhanced_mode = "true") ELSE '0';    
     dqsenablefinedelaysetting    <= tmp_output(47) WHEN (enhanced_mode = "true") ELSE '0';    
 
     tmp_output         <= output_reg;
 
     PROCESS(clk_in)
     begin
         if (clk_in = '1' AND ena_in = '1') then 
             shift_reg(0) <= datain_in;
             shift_reg(47 DOWNTO 1) <= shift_reg(46 DOWNTO 0);
         end if;
     end process;
 
     PROCESS(clk_in)
     begin
         if (clk_in = '1' AND update_in = '1') then 
             output_reg <= shift_reg;
         end if;
     end process;
 
     --------------------
     -- INPUT PATH DELAYS
     --------------------
     WireDelay : block
     begin
         VitalWireDelay (datain_in,    datain,    tipd_datain);
         VitalWireDelay (clk_in,       clk,       tipd_clk);
         VitalWireDelay (ena_in,       ena,       tipd_ena);
         VitalWireDelay (update_in,    update,    tipd_update);
     end block;
         
     -----------------------------------
     -- Timing Check Section
     -----------------------------------
     VITAL_timing_check: PROCESS (clk_in,datain_in,ena_in,update_in)
     
     variable Tviol_clk_datain : std_ulogic := '0';
     variable TimingData_clk_datain : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_clk_ena    : std_ulogic := '0';
     variable TimingData_clk_ena    : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_clk_update : std_ulogic := '0';
     variable TimingData_clk_update : VitalTimingDataType := VitalTimingDataInit;
     
     BEGIN
         IF (TimingChecksOn) THEN
             VitalSetupHoldCheck (
                         Violation       => Tviol_clk_datain,
                         TimingData      => TimingData_clk_datain,
                         TestSignal      => datain_in,
                         TestSignalName  => "Datain",
                         RefSignal       => clk_in,
                         RefSignalName   => "clk",
                         SetupHigh       => tsetup_datain_clk_noedge_posedge,
                         SetupLow        => tsetup_datain_clk_noedge_posedge,
                         HoldHigh        => thold_datain_clk_noedge_posedge,
                         HoldLow         => thold_datain_clk_noedge_posedge,
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_IO_CONFIG",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
             VitalSetupHoldCheck (
                         Violation       => Tviol_clk_ena,
                         TimingData      => TimingData_clk_ena,
                         TestSignal      => ena_in,
                         TestSignalName  => "Ena",
                         RefSignal       => clk_in,
                         RefSignalName   => "clk",
                         SetupHigh       => tsetup_datain_clk_noedge_posedge,
                         SetupLow        => tsetup_datain_clk_noedge_posedge,
                         HoldHigh        => thold_datain_clk_noedge_posedge,
                         HoldLow         => thold_datain_clk_noedge_posedge,
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_IO_CONFIG",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
             VitalSetupHoldCheck (
                         Violation       => Tviol_clk_update,
                         TimingData      => TimingData_clk_update,
                         TestSignal      => update_in,
                         TestSignalName  => "Update",
                         RefSignal       => clk_in,
                         RefSignalName   => "clk",
                         SetupHigh       => tsetup_datain_clk_noedge_posedge,
                         SetupLow        => tsetup_datain_clk_noedge_posedge,
                         HoldHigh        => thold_datain_clk_noedge_posedge,
                         HoldLow         => thold_datain_clk_noedge_posedge,
                         RefTransition   => '/',
                         HeaderMsg       => InstancePath & "/STRATIXIII_IO_CONFIG",
                         XOn             => XOnChecks,
                         MsgOn           => MsgOnChecks
             );
             
         END IF;
     END PROCESS;  -- timing check
 
     --------------------------------------
     --  Path Delay Section
     --------------------------------------
     
     VITAL_path_delays: PROCESS (tmp_dataout)
     
         variable dataout_VitalGlitchData : VitalGlitchDataType;
     
     BEGIN
         VitalPathDelay01 (
             OutSignal => dataout,
             OutSignalName => "Dataout",
             OutTemp => tmp_dataout,
             Paths =>   (0 => (clk_in'last_event, tpd_clk_dataout_posedge, TRUE)),
             GlitchData => dataout_VitalGlitchData,
             Mode => DefGlitchMode,
             XOn  => XOn,
             MsgOn  => MsgOn );
     
     END PROCESS;  -- Path Delays
     
 END stratixiii_dqs_config_arch;
-------------------------------------------------------------------------------
--  Module Name:             stratixiii_mac_bit_register                          --
--  Description:             Stratix III MAC single bit register                   --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_mac_bit_register IS
 GENERIC (
             tipd_datain : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clk_dataout_posedge : VitalDelayType01 := DefPropDelay01;
             tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks
        );
    PORT (
          datain                  : IN std_logic := '0';
          clk                     : IN std_logic := '0';
          aclr                    : IN std_logic := '0';
          sload                   : IN std_logic := '0';
          bypass_register         : IN std_logic := '0';
          dataout                 : OUT std_logic
         );
END stratixiii_mac_bit_register;

ARCHITECTURE arch OF stratixiii_mac_bit_register IS
    SIGNAL datain_ipd : std_logic := '0';
    SIGNAL clk_ipd : std_logic := '0';
    SIGNAL aclr_ipd : std_logic := '0';
    SIGNAL sload_ipd : std_logic := '1';
    SIGNAL dataout_tmp              :  std_logic := '0';
    SIGNAL dataout_reg              :  std_logic := '0';
BEGIN

WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
    end block;

    PROCESS(clk_ipd, datain_ipd, sload_ipd, aclr_ipd)
        variable Tviol_datain_clk : std_ulogic := '0';
        variable Tviol_sload_clk : std_ulogic := '0';
        variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
        variable q_VitalGlitchData : VitalGlitchDataType;
        VARIABLE CQDelay  : TIME := 0 ns;

        BEGIN
            IF (aclr_ipd = '1') THEN
                dataout_reg <=  '0';
            ELSIF (clk_ipd'EVENT AND clk_ipd = '1') THEN
                IF (sload_ipd = '1') THEN
                    dataout_reg <= datain_ipd;
                ELSE
                    dataout_reg <= dataout_reg;
                END IF;
            END IF;

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
                    CheckEnabled    => TO_X01((NOT aclr_ipd) OR
                                              (sload_ipd)) /= '1',
                    RefTransition   => '/',
                    HeaderMsg       => "/MAC Register VitalSetupHoldCheck",
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
                    CheckEnabled    => TO_X01((NOT aclr_ipd)) /= '1',
                    RefTransition   => '/',
                    HeaderMsg       => "/MAC Register VitalSetupHoldCheck",
                    XOn             => XOnChecks,
                    MsgOn           => MsgOnChecks );

        END PROCESS;

        dataout_tmp <= datain_ipd WHEN bypass_register = '1' ELSE dataout_reg;

    PROCESS(dataout_tmp)
        variable dataout_VitalGlitchData : VitalGlitchDataType;
        BEGIN
            VitalPathDelay01 (
                OutSignal     => dataout,
                OutSignalName => "dataout",
                OutTemp       => dataout_tmp,
                Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                                  1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
                GlitchData    => dataout_VitalGlitchData,
                Mode          => DefGlitchMode,
                XOn           => TRUE,
                MsgOn         => TRUE );
     END PROCESS;
END arch;

-------------------------------------------------------------------------------
--  Module Name:             stratixiii_mac_register                              --
--  Description:             Stratix III MAC variable width register               --
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_mac_register IS
    GENERIC (
              data_width           :  integer := 18;
              tipd_datain       : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
              tipd_clk        : VitalDelayType01 := DefPropDelay01;
              tipd_sload        : VitalDelayType01 := DefPropDelay01;
              tipd_aclr       : VitalDelayType01 := DefPropDelay01;
              tpd_aclr_dataout_posedge   : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
              tpd_clk_dataout_posedge    : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
              tsetup_datain_clk_noedge_posedge : VitalDelayArrayType(71 downto 0) := (OTHERS => DefSetupHoldCnst);
              thold_datain_clk_noedge_posedge  : VitalDelayArrayType(71 downto 0) := (OTHERS => DefSetupHoldCnst);
              tsetup_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
              thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
              MsgOn: Boolean := DefGlitchMsgOn;
              XOn: Boolean := DefGlitchXOn;
              MsgOnChecks: Boolean := DefMsgOnChecks;
              XOnChecks: Boolean := DefXOnChecks
          );
    PORT (
           datain                  : IN std_logic_vector(data_width - 1 DOWNTO 0) := (others => '0');
           clk                     : IN std_logic := '0';
           aclr                    : IN std_logic := '0';
           sload                   : IN std_logic := '0';
           bypass_register         : IN std_logic := '0';
           dataout                 : OUT std_logic_vector(data_width - 1 DOWNTO 0)
        );
END stratixiii_mac_register;

ARCHITECTURE arch OF stratixiii_mac_register IS
    SIGNAL datain_ipd : std_logic_vector(data_width -1 downto 0) := (others => '0');
    SIGNAL clk_ipd : std_logic := '0';
    SIGNAL aclr_ipd : std_logic := '0';
    SIGNAL sload_ipd : std_logic := '1';
    SIGNAL dataout_tmp              :  std_logic_vector(data_width - 1 DOWNTO 0) := (others => '0');
    SIGNAL dataout_reg              :  std_logic_vector(data_width - 1 DOWNTO 0) := (others => '0');
BEGIN

WireDelay : block
    begin
        g1 :for i in datain'range generate
            VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
        end generate;
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
  end block;


    PROCESS(clk_ipd, datain_ipd, sload_ipd, aclr_ipd)
        BEGIN
            IF (aclr_ipd = '1') THEN
                dataout_reg <= (OTHERS => '0');
            ELSIF (clk_ipd'EVENT AND clk_ipd = '1') THEN
                IF (sload_ipd = '1') THEN
                    dataout_reg <= datain_ipd;
                ELSE
                    dataout_reg <= dataout_reg;
                END IF;
            END IF;
    END process;

    sh: block
    begin
        g0 : for i in datain'range generate
            process(datain_ipd(i),clk_ipd,sload_ipd)
                 variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(71 downto 0);
                 variable Tviol_sload_clk : std_ulogic := '0';
                variable Tviol_datain_clk : std_ulogic := '0';
                variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
                variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
                begin
                VitalSetupHoldCheck (
                    Violation       => Tviol_datain_clk,
                    TimingData      => TimingData_datain_clk,
                    TestSignal      => datain_ipd(i),
                    TestSignalName  => "DATAIN(i)",
                    RefSignal       => clk_ipd,
                    RefSignalName   => "CLK",
                    SetupHigh       => tsetup_datain_clk_noedge_posedge(i),
                    SetupLow        => tsetup_datain_clk_noedge_posedge(i),
                    HoldHigh        => thold_datain_clk_noedge_posedge(i),
                    HoldLow         => thold_datain_clk_noedge_posedge(i),
                    CheckEnabled    => TO_X01((NOT aclr_ipd) OR
                                              (sload_ipd)) /= '1',
                    RefTransition   => '/',
                    HeaderMsg       => "/MAC_REG",
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
                    CheckEnabled    => TO_X01((NOT aclr_ipd)) /= '1',
                    RefTransition   => '/',
                    HeaderMsg       => "/MAC_REG",
                    XOn             => XOnChecks,
                    MsgOn           => MsgOnChecks );
    END PROCESS;
    end generate g0;
    end block;

    dataout_tmp <= datain_ipd WHEN bypass_register = '1' ELSE dataout_reg;

    PathDelay : block
        begin
            g1 : for i in dataout'range generate
                PROCESS (dataout_tmp(i))
                    variable dataout_VitalGlitchData : VitalGlitchDataType;
                    begin
                        VitalPathDelay01 (
                          OutSignal     => dataout(i),
                          OutSignalName => "dataout",
                          OutTemp       => dataout_tmp(i),
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

-------------------------------------------------------------------------------
--  Module Name:             stratixiii_mac_multiplier                            --
--  Description:             Stratix III MAC signed multiplier                     --
-------------------------------------------------------------------------------


LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_mac_multiplier IS
    GENERIC (
             dataa_width           :  integer := 18;
             datab_width           :  integer := 18;
             tipd_dataa            : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             tipd_datab            : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             tipd_signa            : VitalDelayType01  := DefPropDelay01;
             tipd_signb            : VitalDelayType01  := DefPropDelay01;
             tpd_dataa_dataout     : VitalDelayArrayType01(18*36-1 downto 0) := (others => DefPropDelay01);
             tpd_datab_dataout     : VitalDelayArrayType01(18*36-1 downto 0) := (others => DefPropDelay01);
             tpd_signa_dataout     : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
             tpd_signb_dataout     : VitalDelayArrayType01(35 downto 0) := (others => DefPropDelay01);
             XOn                   : Boolean := DefGlitchXOn;
             MsgOn                 : Boolean := DefGlitchMsgOn
            );
    PORT (
           dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0) := (others => '0');
           datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '0');
           signa                   : IN std_logic := '0';
           signb                   : IN std_logic := '0';
           dataout                 : OUT std_logic_vector(dataa_width + datab_width - 1 DOWNTO 0)
         );
END stratixiii_mac_multiplier;

ARCHITECTURE arch OF stratixiii_mac_multiplier IS
    constant dataout_width          :  integer := dataa_width + datab_width;
    SIGNAL product                  :  std_logic_vector(dataout_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL abs_product              :  std_logic_vector(dataout_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL abs_a                    :  std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL abs_b                    :  std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL dataout_tmp              :  std_logic_vector(dataout_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL product_sign             :  std_logic := '0';
    SIGNAL dataa_sign               :  std_logic := '0';
    SIGNAL datab_sign               :  std_logic := '0';
    SIGNAL dataa_ipd                :  std_logic_vector(dataa_width -1 DOWNTO 0) := (others => '0');
    SIGNAL datab_ipd                :  std_logic_vector(datab_width -1 DOWNTO 0) := (others => '0');
    SIGNAL signa_ipd                :  std_logic := '0';
    SIGNAL signb_ipd                :  std_logic := '0';
BEGIN
    WireDelay : block
    begin
        g1 :for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        g2 :for i in datab'range generate
            VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        end generate;
        VitalWireDelay (signa_ipd, signa, tipd_signa);
        VitalWireDelay (signb_ipd, signb, tipd_signb);
    end block;


    dataa_sign <= dataa_ipd(dataa_width - 1) AND signa_ipd ;
    datab_sign <= datab_ipd(datab_width - 1) AND signb_ipd ;
    product_sign <= dataa_sign XOR datab_sign ;
    abs_a <= (NOT dataa_ipd + '1') WHEN dataa_sign = '1' ELSE dataa_ipd;
    abs_b <= (NOT datab_ipd + '1') WHEN datab_sign = '1' ELSE datab_ipd;
    abs_product <=  abs_a * abs_b ;
    dataout_tmp   <= (NOT abs_product + 1) WHEN product_sign = '1' ELSE abs_product;

     PathDelay : block
     begin
         do : for i in dataout'range generate
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
     end block;
END arch;

----------------------------------------------------------------------------------
--  Module Name:             stratixiii_mac_mult_atom                                --
--  Description:             Simulation model for stratixiii mac mult atom.          --
--                           This model instantiates the following components.  --
--                              1.stratixiii_mac_bit_register.                       --
--                              2.stratixiii_mac_register.                           --
--                              3.stratixiii_mac_multiplier.                         --
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_mac_mult IS
   GENERIC (
            dataa_width                    :  integer := 18;
            datab_width                    :  integer := 18;
            dataa_clock                    :  string := "none";
            datab_clock                    :  string := "none";
            signa_clock                    :  string := "none";
            signb_clock                    :  string := "none";
            scanouta_clock                 :  string := "none";
            dataa_clear                    :  string := "none";
            datab_clear                    :  string := "none";
            signa_clear                    :  string := "none";
            signb_clear                    :  string := "none";
            scanouta_clear                 :  string := "none";
            signa_internally_grounded      :  string := "false";
            signb_internally_grounded      :  string := "false";
            lpm_type                       :  string := "stratixiii_mac_mult"
           );
   PORT (
         dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '1');
         datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '1');
         signa                   : IN std_logic := '1';
         signb                   : IN std_logic := '1';
         clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
         aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
         ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');
         dataout                 : OUT std_logic_vector(dataa_width + datab_width - 1 DOWNTO 0);
         scanouta                : OUT std_logic_vector(dataa_width - 1 DOWNTO 0);
         devclrn                 : IN std_logic := '1';
         devpor                  : IN std_logic := '1'
        );
END stratixiii_mac_mult;

ARCHITECTURE arch OF stratixiii_mac_mult IS
    constant dataout_width  : integer := dataa_width + datab_width;

    COMPONENT stratixiii_mac_bit_register
       PORT (
           datain                  : IN std_logic := '0';
           clk                     : IN std_logic := '0';
           aclr                    : IN std_logic := '0';
           sload                   : IN std_logic := '0';
           bypass_register         : IN std_logic := '0';
           dataout                 : OUT std_logic
          );
    END COMPONENT;

    COMPONENT stratixiii_mac_register
     GENERIC (
               data_width           :  integer := 18
             );
     PORT (
            datain                  : IN std_logic_vector(data_width - 1 DOWNTO 0) := (others => '0');
            clk                     : IN std_logic := '0';
            aclr                    : IN std_logic := '0';
            sload                   : IN std_logic := '0';
            bypass_register         : IN std_logic := '0';
            dataout                 : OUT std_logic_vector(data_width - 1 DOWNTO 0)
         );
    END COMPONENT;

    COMPONENT stratixiii_mac_multiplier
        GENERIC (
              dataa_width           :  integer := 18;
              datab_width           :  integer := 18
             );
        PORT (
            dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0) := (others => '0');
            datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '0');
            signa                   : IN std_logic := '0';
            signb                   : IN std_logic := '0';
            dataout                 : OUT std_logic_vector(dataa_width + datab_width - 1 DOWNTO 0)
          );
    END COMPONENT;

    --Internal signals to instantiate the dataa input register unit
    SIGNAL dataa_clk_value          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL dataa_aclr_value         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL dataa_clk                :  std_logic := '0';
    SIGNAL dataa_aclr               :  std_logic := '0';
    SIGNAL dataa_sload              :  std_logic := '0';
    SIGNAL dataa_bypass_register    :  std_logic := '0';
    SIGNAL dataa_in_reg             :  std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL dataa_in             :  std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '0');

    --Internal signals to instantiate the datab input register unit
    SIGNAL datab_clk_value          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL datab_aclr_value         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL datab_clk                :  std_logic := '0';
    SIGNAL datab_aclr               :  std_logic := '0';
    SIGNAL datab_sload              :  std_logic := '0';
    SIGNAL datab_bypass_register    :  std_logic := '0';
    SIGNAL datab_in_reg             :  std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '0');
    SIGNAL datab_in           :  std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '0');

    --Internal signals to instantiate the signa input register unit
    SIGNAL signa_clk_value          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signa_aclr_value         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signa_clk                :  std_logic := '0';
    SIGNAL signa_aclr               :  std_logic := '0';
    SIGNAL signa_sload              :  std_logic := '0';
    SIGNAL signa_bypass_register    :  std_logic := '0';
    SIGNAL signa_in_reg             :  std_logic := '0';
    SIGNAL signa_in                 :  std_logic := '0';

    
    --Internal signbls to instantiate the signb input register unit
    SIGNAL signb_clk_value          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signb_aclr_value         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signb_clk                :  std_logic := '0';
    SIGNAL signb_aclr               :  std_logic := '0';
    SIGNAL signb_sload              :  std_logic := '0';
    SIGNAL signb_bypass_register    :  std_logic := '0';
    SIGNAL signb_in_reg             :  std_logic := '0';
    SIGNAL signb_in                 :  std_logic := '0';

    --Internal scanoutals to instantiate the scanouta input register unit
    SIGNAL scanouta_clk_value       :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL scanouta_aclr_value      :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL scanouta_clk             :  std_logic := '0';
    SIGNAL scanouta_aclr            :  std_logic := '0';
    SIGNAL scanouta_sload           :  std_logic := '0';
    SIGNAL scanouta_bypass_register :  std_logic := '0';
    SIGNAL scanouta_tmp          :  std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '0');
    --Internal Signals to instantiate the mac multiplier
    SIGNAL signa_mult               :  std_logic := '0';
    SIGNAL signb_mult               :  std_logic := '0';
    SIGNAL dataout_tmp              :  std_logic_vector(dataout_width - 1 DOWNTO 0):= (others => '0');

BEGIN

    --Instantiate the dataa input Register
    dataa_clk_value <= "0000" WHEN ((dataa_clock = "0") or (dataa_clock = "none"))
                        ELSE "0001" WHEN (dataa_clock = "1")
                        ELSE "0010" WHEN (dataa_clock = "2")
                        ELSE "0011" WHEN (dataa_clock = "3")
                        ELSE "0000" ;

    dataa_aclr_value <= "0000" WHEN ((dataa_clear = "0") or (dataa_clear = "none"))
                         ELSE "0001" WHEN (dataa_clear = "1")
                         ELSE "0010" WHEN (dataa_clear = "2")
                         ELSE "0011" WHEN (dataa_clear = "3")
                         ELSE "0000" ;

    dataa_clk <= '1' WHEN clk(conv_integer(dataa_clk_value)) = '1' ELSE '0';

    dataa_aclr <= '1' WHEN (aclr(conv_integer(dataa_aclr_value)) OR (NOT devclrn) OR (NOT devpor)) = '1' ELSE '0';

    dataa_sload <= '1' WHEN ena(conv_integer(dataa_clk_value)) = '1' ELSE '0';

    dataa_bypass_register <= '1' WHEN (dataa_clock = "none") ELSE '0';
    
    dataa_in <= dataa;

    dataa_input_register : stratixiii_mac_register
       GENERIC MAP (
                   data_width => dataa_width
                   )
       PORT MAP (
                   datain => dataa_in,
                   clk => dataa_clk,
                   aclr => dataa_aclr,
                   sload => dataa_sload,
                   bypass_register => dataa_bypass_register,
                   dataout => dataa_in_reg
                 );


    --Instantiate the datab input Register
    datab_clk_value <= "0000" WHEN ((datab_clock = "0") or (datab_clock = "none"))
                        ELSE "0001" WHEN (datab_clock = "1")
                        ELSE "0010" WHEN (datab_clock = "2")
                        ELSE "0011" WHEN (datab_clock = "3")
                        ELSE "0000" ;

    datab_aclr_value <= "0000" WHEN ((datab_clear = "0") or (datab_clear = "none"))
                         ELSE "0001" WHEN (datab_clear = "1")
                         ELSE "0010" WHEN (datab_clear = "2")
                         ELSE "0011" WHEN (datab_clear = "3")
                         ELSE "0000" ;

    datab_clk <= '1' WHEN clk(conv_integer(datab_clk_value)) = '1' ELSE '0';

    datab_aclr <= '1' WHEN (aclr(conv_integer(datab_aclr_value)) OR (NOT devclrn) OR (NOT devpor)) = '1' ELSE '0';

    datab_sload <= '1' WHEN ena(conv_integer(datab_clk_value)) = '1' ELSE '0';

    datab_bypass_register <= '1' WHEN (datab_clock = "none") ELSE '0';
    
    datab_in <= datab;


    datab_input_register : stratixiii_mac_register
       GENERIC MAP (
                   data_width => datab_width
                   )
       PORT MAP (
                   datain => datab_in,
                   clk => datab_clk,
                   aclr => datab_aclr,
                   sload => datab_sload,
                   bypass_register => datab_bypass_register,
                   dataout => datab_in_reg
                 );


    --Instantiate the signa input Register
    signa_clk_value <= "0000" WHEN ((signa_clock = "0") or (signa_clock = "none"))
                        ELSE "0001" WHEN (signa_clock = "1")
                        ELSE "0010" WHEN (signa_clock = "2")
                        ELSE "0011" WHEN (signa_clock = "3")
                        ELSE "0000" ;

    signa_aclr_value <= "0000" WHEN ((signa_clear = "0") or (signa_clear = "none"))
                         ELSE "0001" WHEN (signa_clear = "1")
                         ELSE "0010" WHEN (signa_clear = "2")
                         ELSE "0011" WHEN (signa_clear = "3")
                         ELSE "0000" ;

    signa_clk <= '1' WHEN clk(conv_integer(signa_clk_value)) = '1' ELSE '0';

    signa_aclr <= '1' WHEN (aclr(conv_integer(signa_aclr_value)) OR (NOT devclrn) OR (NOT devpor)) = '1' ELSE '0';

    signa_sload <= '1' WHEN ena(conv_integer(signa_clk_value)) = '1' ELSE '0';

    signa_bypass_register <= '1' WHEN (signa_clock = "none") ELSE '0';
    
    signa_in <= signa;


    signa_input_register : stratixiii_mac_bit_register
       PORT MAP (
                   datain => signa_in,
                   clk => signa_clk,
                   aclr => signa_aclr,
                   sload => signa_sload,
                   bypass_register => signa_bypass_register,
                   dataout => signa_in_reg
                 );
    --Instantiate the signb input Register
    signb_clk_value <= "0000" WHEN ((signb_clock = "0") or (signb_clock = "none"))
                        ELSE "0001" WHEN (signb_clock = "1")
                        ELSE "0010" WHEN (signb_clock = "2")
                        ELSE "0011" WHEN (signb_clock = "3")
                        ELSE "0000" ;

    signb_aclr_value <= "0000" WHEN ((signb_clear = "0") or (signb_clear = "none"))
                         ELSE "0001" WHEN (signb_clear = "1")
                         ELSE "0010" WHEN (signb_clear = "2")
                         ELSE "0011" WHEN (signb_clear = "3")
                         ELSE "0000" ;

    signb_clk <= '1' WHEN clk(conv_integer(signb_clk_value)) = '1' ELSE '0';

    signb_aclr <= '1' WHEN (aclr(conv_integer(signb_aclr_value)) OR (NOT devclrn) OR (NOT devpor)) = '1' ELSE '0';

    signb_sload <= '1' WHEN ena(conv_integer(signb_clk_value)) = '1' ELSE '0';

    signb_bypass_register <= '1' WHEN (signb_clock = "none") ELSE '0';
    
     signb_in <= signb;


    signb_input_register : stratixiii_mac_bit_register
       PORT MAP (
                   datain => signb_in,
                   clk => signb_clk,
                   aclr => signb_aclr,
                   sload => signb_sload,
                   bypass_register => signb_bypass_register,
                   dataout => signb_in_reg
                 );
    --Instantiate the scanouta input Register
    scanouta_clk_value <= "0000" WHEN ((scanouta_clock = "0") or (scanouta_clock = "none"))
                        ELSE "0001" WHEN (scanouta_clock = "1")
                        ELSE "0010" WHEN (scanouta_clock = "2")
                        ELSE "0011" WHEN (scanouta_clock = "3")
                        ELSE "0000" ;

    scanouta_aclr_value <= "0000" WHEN ((scanouta_clear = "0") or (scanouta_clear = "none"))
                         ELSE "0001" WHEN (scanouta_clear = "1")
                         ELSE "0010" WHEN (scanouta_clear = "2")
                         ELSE "0011" WHEN (scanouta_clear = "3")
                         ELSE "0000" ;

    scanouta_clk <= '1' WHEN clk(conv_integer(scanouta_clk_value)) = '1' ELSE '0';

    scanouta_aclr <= '1' WHEN (aclr(conv_integer(scanouta_aclr_value)) OR (NOT devclrn) OR (NOT devpor)) = '1' ELSE '0';

    scanouta_sload <= '1' WHEN ena(conv_integer(scanouta_clk_value)) = '1' ELSE '0';

    scanouta_bypass_register <= '1' WHEN (scanouta_clock = "none") ELSE '0';

    scanouta_input_register : stratixiii_mac_register
       GENERIC MAP (
                   data_width => dataa_width
                   )
       PORT MAP (
                   datain => dataa_in_reg,
                   clk => scanouta_clk,
                   aclr => scanouta_aclr,
                   sload => scanouta_sload,
                   bypass_register => scanouta_bypass_register,
                   dataout => scanouta
                 );

    --Instantiate mac_multiplier block

    signa_mult <= '0' WHEN (signa_internally_grounded = "true") ELSE signa_in_reg;
    signb_mult <= '0' WHEN (signb_internally_grounded = "true") ELSE signb_in_reg;

    mac_multiplier : stratixiii_mac_multiplier
       GENERIC MAP (
                      dataa_width => dataa_width,
                      datab_width => datab_width
                    )
       PORT MAP (
                   dataa => dataa_in_reg,
                   datab => datab_in_reg,
                   signa => signa_mult,
                   signb => signb_mult,
                   dataout => dataout
                 );
END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_fsa_isse                                                     --
--  Description:             Stratix III first stage adder input selection and sign extension block.  --
--------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_fsa_isse IS
   GENERIC (
            dataa_width                    :  integer := 36;
            datab_width                    :  integer := 36;
            datac_width                    :  integer := 36;
            datad_width                    :  integer := 36;
            chainin_width                  :  integer := 44;
            multa_signa_internally_grounded : string := "false";
            multa_signb_internally_grounded : string := "false";
            multb_signa_internally_grounded : string := "false";
            multb_signb_internally_grounded : string := "false";
            multc_signa_internally_grounded : string := "false";
            multc_signb_internally_grounded : string := "false";
            multd_signa_internally_grounded : string := "false";
            multd_signb_internally_grounded : string := "false";
            operation_mode                 :  string  := "output_only"
           );
   PORT (
         dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0);
         datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0);
         datac                   : IN std_logic_vector(datac_width - 1 DOWNTO 0);
         datad                   : IN std_logic_vector(datad_width - 1 DOWNTO 0);
         chainin                 : IN std_logic_vector(chainin_width - 1 DOWNTO 0);
         signa                   : IN std_logic := '0';
         signb                   : IN std_logic := '0';
         dataa_out               : OUT std_logic_vector(71 DOWNTO 0);
         datab_out               : OUT std_logic_vector(71 DOWNTO 0);
         datac_out               : OUT std_logic_vector(71 DOWNTO 0);
         datad_out               : OUT std_logic_vector(71 DOWNTO 0);
         chainin_out             : OUT std_logic_vector(71 DOWNTO 0);
         operation               : OUT std_logic_vector(3 DOWNTO 0)
        );
END stratixiii_fsa_isse;

ARCHITECTURE arch OF stratixiii_fsa_isse IS
    signal dataa_out_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
    signal datab_out_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
    signal datac_out_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
    signal datad_out_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
    signal chainin_out_tmp: std_logic_vector(71 DOWNTO 0) := (others => '0');
    signal sign :std_logic := '0';
    
BEGIN
    operation <=   "0000" WHEN (operation_mode = "output_only") ELSE
                   "0001" WHEN (operation_mode = "one_level_adder") ELSE
                   "0010" WHEN (operation_mode = "loopback") ELSE
                   "0011" WHEN (operation_mode = "accumulator") ELSE
                   "0100" WHEN (operation_mode = "accumulator_chain_out") ELSE
                   "0101" WHEN (operation_mode = "two_level_adder") ELSE
                   "0110" WHEN (operation_mode = "two_level_adder_chain_out") ELSE
                   "0111" WHEN (operation_mode = "36_bit_multiply") ELSE
                   "1000" WHEN (operation_mode = "shift") ELSE
                   "1001" WHEN (operation_mode = "double") ELSE "0000";
    sign <= signa or signb;
    

    PROCESS( dataa,datab,datac,datad,chainin,signa,signb)
        variable active_signb : std_logic := '0';
        variable active_signc : std_logic := '0';
        variable active_signd : std_logic := '0'; 
        variable read_new_param : std_logic := '0';
        variable datab_out_tim_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable datac_out_tim_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable datad_out_tim_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable datab_out_fun_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable datac_out_fun_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable datad_out_fun_tmp  : std_logic_vector(71 DOWNTO 0) := (others => '0');
        BEGIN
        
        IF (  multa_signa_internally_grounded = "false" AND multa_signb_internally_grounded = "false" 
           AND multb_signa_internally_grounded = "false" AND multb_signb_internally_grounded = "false" 
           AND multc_signa_internally_grounded = "false" AND multc_signb_internally_grounded = "false"
           AND multd_signa_internally_grounded = "false" AND multd_signb_internally_grounded = "false") THEN
           read_new_param := '0' ;
        ELSE                      
           read_new_param := '1'  ;
        END IF;
   
        IF ((operation_mode = "36_bit_multiply") or (operation_mode = "shift") or (operation_mode = "double")) THEN
               if (multb_signb_internally_grounded = "false" AND multb_signa_internally_grounded = "true") then
                    active_signb := signb;
                elsif(multb_signb_internally_grounded = "true" AND multb_signa_internally_grounded = "false" ) then
                    active_signb := signa;
                elsif(multb_signb_internally_grounded = "false" AND multb_signa_internally_grounded = "false") then
                    active_signb := sign;
                else
                    active_signb := '0';
                end if;
           ELSE
                active_signb := sign;
            END IF;
            
            IF ((operation_mode = "36_bit_multiply") or (operation_mode = "shift") or (operation_mode = "double")) THEN
               if (multc_signb_internally_grounded = "false" AND multc_signa_internally_grounded = "true") then
                    active_signc := signb;
                elsif(multc_signb_internally_grounded = "true" AND multc_signa_internally_grounded = "false" ) then
                    active_signc := signa;
                elsif(multc_signb_internally_grounded = "false" AND multc_signa_internally_grounded = "false") then
                    active_signc := sign;
                else
                    active_signc := '0';
                end if;
           ELSE
                active_signc := sign;
            END IF;
            
            IF ((operation_mode = "36_bit_multiply") or (operation_mode = "shift") or (operation_mode = "double")) THEN
               if (multd_signb_internally_grounded = "false" AND multd_signa_internally_grounded = "true") then
                    active_signd := signb;
                elsif(multd_signb_internally_grounded = "true" AND multd_signa_internally_grounded = "false" ) then
                    active_signd := signa;
                elsif(multd_signb_internally_grounded = "false" AND multd_signa_internally_grounded = "false") then
                    active_signd := sign;
                else
                    active_signd := '0';
                end if;
           ELSE
                active_signd := sign;
            END IF;

           IF (dataa(dataa_width - 1) = '1' AND sign = '1') THEN
               dataa_out_tmp <=  sxt(dataa(dataa_width - 1 DOWNTO 0), 72);
           ELSE
               dataa_out_tmp <=  ext(dataa(dataa_width - 1 DOWNTO 0), 72);
           END IF;

         
            IF (datab(datab_width - 1) = '1' AND active_signb = '1') THEN
                datab_out_tim_tmp :=  sxt(datab(datab_width - 1 DOWNTO 0), 72);
            ELSE
                datab_out_tim_tmp :=  ext(datab(datab_width - 1 DOWNTO 0), 72);
            END IF;
           
            IF (datac(datac_width - 1) = '1' AND active_signc = '1') THEN
               datac_out_tim_tmp :=  sxt(datac(datac_width - 1 DOWNTO 0), 72);
           ELSE
               datac_out_tim_tmp :=  ext(datac(datac_width - 1 DOWNTO 0), 72);
           END IF;
           
             IF (datad(datad_width - 1) = '1' AND active_signd = '1') THEN
               datad_out_tim_tmp :=  sxt(datad(datad_width - 1 DOWNTO 0), 72);
           ELSE
               datad_out_tim_tmp :=  ext(datad(datad_width - 1 DOWNTO 0), 72);
           END IF;

           
            IF ((operation_mode = "36_bit_multiply") or (operation_mode = "shift")) THEN
                IF(datab(datab_width - 1) = '1' AND signb = '1') THEN
                     datab_out_fun_tmp :=  sxt(datab(datab_width - 1 DOWNTO 0), 72);
                ELSE
                    datab_out_fun_tmp :=  ext(datab(datab_width - 1 DOWNTO 0), 72);
                END IF;
            ELSIF(operation_mode = "double") THEN
                IF(datab(datab_width - 1) = '1' AND signa = '1') THEN
                   datab_out_fun_tmp :=  sxt(datab(datab_width - 1 DOWNTO 0), 72);
                ELSE
                    datab_out_fun_tmp :=  ext(datab(datab_width - 1 DOWNTO 0), 72);
                END IF;
            ELSE
                IF (datab(datab_width - 1) = '1' AND sign = '1') THEN
                    datab_out_fun_tmp :=  sxt(datab(datab_width - 1 DOWNTO 0), 72);
                ELSE
                     datab_out_fun_tmp :=  ext(datab(datab_width - 1 DOWNTO 0), 72);
                END IF;
            END IF;
            
           IF ((operation_mode = "36_bit_multiply") or (operation_mode = "shift")) THEN
               IF (datac(datac_width - 1) = '1' AND signa = '1') THEN
                    datac_out_fun_tmp :=  sxt(datac(datac_width - 1 DOWNTO 0), 72);
               ELSE
                   datac_out_fun_tmp :=  ext(datac(datac_width - 1 DOWNTO 0), 72);
               END IF;
            ELSE
                IF (datac(datac_width - 1) = '1' AND sign = '1') THEN
                    datac_out_fun_tmp :=  sxt(datac(datac_width - 1 DOWNTO 0), 72);
                ELSE
                    datac_out_fun_tmp :=  ext(datac(datac_width - 1 DOWNTO 0), 72);
                END IF;
           END IF;

           IF ((operation_mode = "36_bit_multiply") or (operation_mode = "shift")) THEN
               datad_out_fun_tmp :=  ext(datad(datad_width - 1 DOWNTO 0), 72);
           ELSIF(operation_mode = "double")THEN
               IF (datad(datad_width - 1) = '1' AND signa = '1') THEN
                    datad_out_fun_tmp :=  sxt(datad(datad_width - 1 DOWNTO 0), 72);
                ELSE
                    datad_out_fun_tmp :=  ext(datad(datad_width - 1 DOWNTO 0), 72);
                END IF;
           ELSE
                IF (datad(datad_width - 1) = '1' AND sign = '1') THEN
                    datad_out_fun_tmp :=  sxt(datad(datad_width - 1 DOWNTO 0), 72);
                ELSE
                    datad_out_fun_tmp :=  ext(datad(datad_width - 1 DOWNTO 0), 72);
                END IF;
            END IF;
            
           IF (chainin(chainin_width - 1) = '1') THEN
               chainin_out_tmp <=  sxt(chainin(chainin_width - 1 DOWNTO 0), 72);
           ELSE
               chainin_out_tmp <=  ext(chainin(chainin_width - 1 DOWNTO 0), 72);
           END IF;
           
     IF(read_new_param = '1') THEN
        datab_out_tmp <= datab_out_tim_tmp;
        datac_out_tmp <= datac_out_tim_tmp;
        datad_out_tmp <= datad_out_tim_tmp;
     ELSE
        datab_out_tmp <= datab_out_fun_tmp;
        datac_out_tmp <= datac_out_fun_tmp;
        datad_out_tmp <= datad_out_fun_tmp;
     END IF;
 
     END process;
    
     
     dataa_out <= dataa_out_tmp;
     datab_out <= datab_out_tmp;
     datac_out <= datac_out_tmp;
     datad_out <= datad_out_tmp;
     chainin_out <= chainin_out_tmp;

END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_first_stage_add_sub                                          --
--  Description:             Stratix III First Stage Adder Subtractor Unit                            --
--------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;


ENTITY stratixiii_first_stage_add_sub IS
    GENERIC (
             dataa_width                    :  integer := 36;
             datab_width                    :  integer := 36;
             fsa_mode                       :  string := "add";
             tipd_dataa                     : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
             tipd_datab                     : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
             tipd_sign                      : VitalDelayType01 :=DefPropDelay01;
             tpd_dataa_dataout              : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
             tpd_datab_dataout              : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
             tpd_sign_dataout               : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             XOn                            : Boolean := DefGlitchXOn;
             MsgOn                          : Boolean := DefGlitchMsgOn
            );
    PORT (
            dataa                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
            datab                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
            sign                    : IN std_logic := '0';
            operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
            dataout                 : OUT std_logic_vector(71 DOWNTO 0)
        );
END stratixiii_first_stage_add_sub;

ARCHITECTURE arch OF stratixiii_first_stage_add_sub IS
    SIGNAL dataout_tmp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL abs_b                    :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL abs_a                    :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL sign_a                   :  std_logic := '0';
    SIGNAL sign_b                   :  std_logic := '0';
    SIGNAL dataa_ipd                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datab_ipd                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL sign_ipd                 :  std_logic := '0';

BEGIN
     WireDelay : block
    begin
        g1 :for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        g2 :for i in datab'range generate
            VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        end generate;
        VitalWireDelay (sign_ipd, sign, tipd_sign);
    end block;

    PROCESS
    BEGIN
        WAIT UNTIL dataa_ipd'EVENT OR datab_ipd'EVENT OR sign_ipd'EVENT OR operation'EVENT;
        IF ((operation = "0111") OR (operation = "1000")or (operation = "1001")) THEN --36 std_logic multiply, shift and add
            dataout_tmp <= dataa_ipd(53 DOWNTO 36) & dataa_ipd(35 DOWNTO 0) & "000000000000000000" + datab_ipd;
        ELSE
            IF(fsa_mode = "add")THEN
                IF (sign_ipd = '1') THEN
                    dataout_tmp <= signed(dataa_ipd) + signed(datab_ipd);
                ELSE
                    dataout_tmp <= unsigned(dataa_ipd) + unsigned(datab_ipd);
                END IF;
            ELSE
                IF (sign_ipd = '1') THEN
                    dataout_tmp <= signed(dataa_ipd) - signed(datab_ipd);
                ELSE
                    dataout_tmp <= unsigned(dataa_ipd) - unsigned(datab_ipd);
                END IF;
            END IF;
        END IF;
    END process ;

    PathDelay : block
     begin
         do1 : for i in dataout'range generate
             process(dataout_tmp(i))
                 VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;

                 begin
                     VitalPathDelay01 (
                       OutSignal => dataout(i),
                       OutSignalName => "dataout",
                       OutTemp => dataout_tmp(i),
                       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout(i), TRUE),
                                 1 => (datab_ipd'last_event, tpd_datab_dataout(i), TRUE),
                                 2 => (sign'last_event, tpd_sign_dataout(i), TRUE)),
                       GlitchData => dataout_VitalGlitchData,
                       Mode => DefGlitchMode,
                       MsgOn => FALSE,
                       XOn  => TRUE
                       );
             end process;
         end generate do1;
     end block;
END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_second_stage_add_accum                                       --
--  Description:             Stratix III Second stage Adder and Accumulator/Decimator Unit            --
--------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;


ENTITY stratixiii_second_stage_add_accum IS
   GENERIC (
            dataa_width                    :  integer := 36;
            datab_width                    :  integer := 36;
            ssa_mode                       :  string := "add";
            tipd_dataa                     : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
            tipd_datab                     : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
            tipd_accumin                   : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
            tipd_sign                      : VitalDelayType01 :=DefPropDelay01;
            tpd_dataa_dataout              : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
            tpd_datab_dataout              : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
            tpd_accumin_dataout            : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
            tpd_sign_dataout               : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
            tpd_dataa_overflow             : VitalDelayType01 :=  DefPropDelay01;
            tpd_datab_overflow             : VitalDelayType01 :=  DefPropDelay01;
            tpd_accumin_overflow           : VitalDelayType01 :=  DefPropDelay01;
            tpd_sign_overflow              : VitalDelayType01 :=  DefPropDelay01;
            XOn                            : Boolean := DefGlitchXOn;
            MsgOn                          : Boolean := DefGlitchMsgOn
            );
   PORT (
           dataa                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
           datab                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
           accumin                : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
           sign                    : IN std_logic := '0';
           operation               : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
           dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
           overflow                : OUT std_logic
        );
END stratixiii_second_stage_add_accum;

ARCHITECTURE arch OF stratixiii_second_stage_add_accum IS
    constant accum_width            :  integer := dataa_width + 7;
    SIGNAL dataout_temp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL dataa_tmp                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datab_tmp                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL accum_tmp                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL overflow_tmp             :  std_logic := '0';
    SIGNAL dataa_ipd                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datab_ipd                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL accumin_ipd              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL sign_ipd                :  std_logic := '0';
    SIGNAL signb_ipd               :  std_logic := '0';

BEGIN
    WireDelay : block
    begin
        g1 :for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        g2 :for i in datab'range generate
            VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        end generate;
        g3 :for i in accumin'range generate
            VitalWireDelay (accumin_ipd(i), accumin(i), tipd_accumin(i));
        end generate;
        VitalWireDelay (sign_ipd, sign, tipd_sign);
    end block;

    PROCESS
    Variable dataout_tmp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    BEGIN
        WAIT UNTIL dataa_ipd'EVENT OR datab_ipd'EVENT OR sign_ipd'EVENT OR accumin_ipd'EVENT OR operation'EVENT;
                IF (operation = "0011" OR operation = "0100") THEN --Accumultor or Accumulator chainout
                    IF(ssa_mode = "add")THEN
                        IF (sign_ipd = '1') THEN
                            dataout_tmp := signed(sxt(accumin_ipd(accum_width-1 downto 0),72)) + signed(sxt(dataa_ipd(accum_width-1 downto 0),72)) + signed(sxt(datab_ipd(accum_width-1 downto 0),72));
                      ELSE
                            dataout_tmp := unsigned(ext(accumin_ipd(accum_width-1 downto 0),72)) + unsigned(ext(dataa_ipd(accum_width-1 downto 0),72)) + unsigned(ext(datab_ipd(accum_width-1 downto 0),72));
                      END IF;
                  ELSE
                        IF (sign_ipd = '1') THEN
                        dataout_tmp := signed(accumin_ipd) - signed(dataa_ipd)- signed(datab_ipd);
                     ELSE
                         dataout_tmp := unsigned(accumin_ipd) - unsigned(dataa_ipd)- unsigned(datab_ipd);
                     END IF;
                 END IF;
                 IF(sign_ipd = '1')THEN
                    overflow_tmp <= dataout_tmp(accum_width) xor dataout_tmp(accum_width -1);
                 ELSE
                    IF(ssa_mode = "add")THEN
                        overflow_tmp <= dataout_tmp(accum_width);
                    ELSE
                        overflow_tmp <= 'X';
                    END IF;
                 END IF;
            ELSIF (operation = "0101" OR operation = "0110") THEN -- two level adder or two level with chainout
                    overflow_tmp <= '0';
                    IF (sign_ipd = '1') THEN
                    dataout_tmp := signed(dataa_ipd) + signed(datab_ipd);
                    ELSE
                    dataout_tmp := unsigned(dataa_ipd) + unsigned(datab_ipd);
                    END IF;
             ELSIF ((operation = "0111") OR (operation = "1000")) THEN --36 std_logic multiply; shift and add
                    dataout_tmp(71 DOWNTO 0) := dataa_ipd(53 DOWNTO 0) & "000000000000000000" + datab_ipd;
                    overflow_tmp <= '0';
             ELSIF ((operation = "1001")) THEN --double mode
                    dataout_tmp(71 DOWNTO 0) := dataa_ipd + datab_ipd;
                    overflow_tmp <= '0';
             END IF;
    dataout_temp <= dataout_tmp;
    END   PROCESS;

    PathDelay : block
     begin
         do1 : for i in dataout'range generate
             process(dataout_temp(i))
                 VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;
                 begin
                     VitalPathDelay01 (
                       OutSignal => dataout(i),
                       OutSignalName => "dataout",
                       OutTemp => dataout_temp(i),
                       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout(i), TRUE),
                                 1 => (datab_ipd'last_event, tpd_datab_dataout(i), TRUE),
                                 2 => (accumin_ipd'last_event, tpd_accumin_dataout(i), TRUE),
                                 3 => (sign'last_event, tpd_sign_dataout(i), TRUE)),
                       GlitchData => dataout_VitalGlitchData,
                       Mode => DefGlitchMode,
                       MsgOn => FALSE,
                       XOn  => TRUE
                       );
             end process;
         end generate do1;

         process(overflow_tmp)
             VARIABLE overflow_VitalGlitchData : VitalGlitchDataType;
             begin
                 VitalPathDelay01 (
                 OutSignal     => overflow,
                 OutSignalName => "overflow",
                 OutTemp       => overflow_tmp,
                 paths => (0 => (dataa_ipd'last_event, tpd_dataa_overflow, TRUE),
                           1 => (datab_ipd'last_event, tpd_datab_overflow, TRUE),
                           2 => (accumin_ipd'last_event, tpd_accumin_overflow, TRUE),
                           3 => (sign'last_event, tpd_sign_overflow, TRUE)),
                 GlitchData    => overflow_VitalGlitchData,
                 Mode          => DefGlitchMode,
                 XOn           => TRUE,
                 MsgOn         => TRUE
                 );
             end process;
     end block;
END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_round_block                                                  --
--  Description:             Stratix III round block                                                  --
--------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;


ENTITY stratixiii_round_block IS
   GENERIC (
            round_mode                     :  string := "nearest_integer";
            round_width                    : integer := 15;
            operation_mode                 :  string := "output_only"
           );
   PORT (
         datain                  : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
         round                   : IN std_logic := '0';
         datain_width            : IN std_logic_vector(7 DOWNTO 0):= (others => '0');
         dataout                 : OUT std_logic_vector(71 DOWNTO 0)
        );
END stratixiii_round_block;

ARCHITECTURE arch OF stratixiii_round_block IS
    signal out_tmp : std_logic_vector(71 DOWNTO 0) := (others => '0');

BEGIN
    dataout <= out_tmp ;
    PROCESS(datain,round,datain_width)
        variable i                        :  integer ;
        variable j                        :  integer ;
        variable sign                     :  std_logic ;
        variable result_tmp               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable dataout_tmp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
        variable dataout_value            :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    BEGIN
        if(round = '0')then
            dataout_value := datain;
        else
            dataout_value := datain;
            j := 0;
            sign := '0';
            IF( conv_integer(datain_width) > round_width) THEN
                for i in ((conv_integer(datain_width)) - round_width) to (conv_integer(datain_width) -1) loop
                    result_tmp(j) := datain(i);
                    j := j + 1;
                END LOOP;
                for i in 0 to (conv_integer(datain_width) - round_width -2) loop
                    sign := sign or datain(i);
                    dataout_value(i) := 'X';
                 END LOOP;
                dataout_value((conv_integer(datain_width)) - round_width -1) := 'X';

                IF (datain(conv_integer(datain_width) - round_width -1) = '0') THEN -- fractional < 0.5
                    dataout_tmp := result_tmp;
                ELSE
                    IF ((datain(conv_integer(datain_width) - round_width -1) = '1') AND (sign = '1')) THEN --fractional > 0.5
                        dataout_tmp := result_tmp + '1';
                    ELSE
                        IF (round_mode = "nearest_even") THEN --unbiased rounding
                            IF(result_tmp(0) = '1') THEN --check for odd integer
                                dataout_tmp := result_tmp + '1' ;
                            ELSE
                                dataout_tmp := result_tmp;
                            END IF;
                        ELSE --biased rounding
                            dataout_tmp := result_tmp + '1';
                        END IF;
                    END IF;
                END IF;
                j := conv_integer(datain_width) - round_width;
                FOR i IN 0 to (round_width -1)LOOP
                    dataout_value(j) := dataout_tmp(i);
                    j := j + 1;
                END LOOP;
            ELSE
                dataout_value := datain;
            END IF;
        end if;
            out_tmp <= dataout_value;
    END PROCESS;
END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_saturate_block                                               --
--  Description:             Stratix III saturation block                                             --
--------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;


ENTITY stratixiii_saturate_block IS
   GENERIC (
            dataa_width                    :  integer := 36;
            datab_width                    :  integer := 36;
            saturate_width                 :  integer := 15;
            round_width                    :  integer := 15;
            saturate_mode                  :  string := " asymmetric";
            operation_mode                 :  string := "output_only"
           );
   PORT (
         datain                  : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
         saturate                : IN std_logic := '0';
         round                   : IN std_logic := '0';
         signa                   : IN std_logic := '0';
         signb                   : IN std_logic := '0';
         datain_width            : IN std_logic_vector(7 DOWNTO 0) := (others => '0');
         dataout                 : OUT std_logic_vector(71 DOWNTO 0):= (others => '0');
         saturation_overflow     : OUT std_logic
        );
END stratixiii_saturate_block;

ARCHITECTURE arch OF stratixiii_saturate_block IS
    constant   accum_width          :  integer := dataa_width + 8;
    SIGNAL saturation_overflow_tmp  :  std_logic := '0';
    signal msb                      :  std_logic := '0';
    signal sign                     :  std_logic := '0';
    signal min                      :  std_logic_vector(71 downto 0):=(others => '1');
    signal max                      :  std_logic_vector(71 downto 0):=(others => '0');
    signal dataout_tmp              :  std_logic_vector(71 DOWNTO 0):= (others => '0');
    SIGNAL i                        :  integer;

BEGIN

   sign <= signa OR signb ;
   msb <= datain(accum_width) when ((operation_mode = "accumulator") or (operation_mode = "accumulator_chain_out") or(operation_mode = "two_level_adder_chain_out"))
          ELSE datain(dataa_width +1) when(operation_mode = "two_level_adder")
          ELSE datain(dataa_width) when((operation_mode = "one_level_adder")or (operation_mode = "loopback"))
          ELSE datain(dataa_width -1);
   dataout <= dataout_tmp ;
   saturation_overflow <= saturation_overflow_tmp ;

   PROCESS(datain,datain_width,round,saturate,sign,msb)
    variable saturation_temp : std_logic := '0';
    variable sign_tmp : std_logic := '1';
    variable data_tmp : std_logic := '0';
   BEGIN
      IF (saturate = '0') THEN
         dataout_tmp <= datain;
         saturation_overflow_tmp <= '0';
      ELSE
         saturation_temp := '0';
         data_tmp := '0';
         sign_tmp := '1';
         IF (round = '1') THEN

            for i in 0 to (conv_integer(datain_width) - round_width -1) LOOP
               min(i) <= 'X';
               max(i) <= 'X';
            END LOOP;
         END IF;

         IF (saturate_mode = "symmetric") THEN
           for i in 0 to (conv_integer(datain_width) - round_width -1) LOOP
               IF (round = '1') THEN
                   max(i) <= 'X';
                   min(i) <= 'X';
               ELSE
                   max(i) <= '1';
                   min(i) <= '0';
               END IF;
            END LOOP;

            for i in (conv_integer(datain_width) - round_width)  to (conv_integer(datain_width) - saturate_width -1) LOOP
               data_tmp := data_tmp or datain(i);
               max(i) <= '1';
               min(i) <= '0';
            END LOOP;

	    IF (round = '1') THEN
                min(conv_integer(datain_width) - round_width) <= '1';
            ELSE
		min(0) <= '1';
            END IF;
         END IF;

         IF (saturate_mode = "asymmetric") THEN
           for i in 0 to (conv_integer(datain_width) - saturate_width -1) LOOP
               max(i) <= '1';
               min(i) <= '0';
            END LOOP;
         END IF;

        if((saturate_width = 1))then
            IF (msb /= datain(conv_integer(datain_width)-1)) THEN
                    saturation_temp := '1';
        ELSE
           sign_tmp := sign_tmp and datain(conv_integer(datain_width)-1);
            END IF;
        else
            for i in (conv_integer(datain_width) - saturate_width)  to (conv_integer(datain_width)-1) LOOP
                sign_tmp := sign_tmp and datain(i);
                IF (datain(conv_integer(datain_width)-1) /= datain(i)) THEN
                    saturation_temp := '1';
                end if;
            END LOOP;
         end if;

        -- Trigger the saturation overflow for data=-2^n in case of symmetric saturation.
        if((sign_tmp ='1') and (data_tmp = '0') and (saturate_mode = "symmetric")) then
         saturation_temp := '1';
        end if;

    saturation_overflow_tmp <= saturation_temp;
         IF (saturation_temp = '1') THEN

            IF ((operation_mode = "output_only")or (operation_mode = "accumulator_chain_out") or(operation_mode = "two_level_adder_chain_out")) THEN
               IF (msb = '1') THEN
                  dataout_tmp <= min;
               ELSE
                  dataout_tmp <= max;
               END IF;
            ELSE
               IF (sign = '1') THEN
                  IF (msb = '1') THEN
                     dataout_tmp <= min;
                  ELSE
                     dataout_tmp <= max;
                  END IF;
               ELSE
                  dataout_tmp  <= (others => 'X');
               END IF;
            END IF;
         ELSE
            dataout_tmp <= datain;
         END IF;
      END IF;
   END PROCESS;

END arch;


--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_round_saturate_block                                         --
--  Description:             Stratix III round and saturation Unit.                                   --
--                           This unit instantiated the following components.                   --
--                            1.stratixiii_round_block.                                              --
--                            2.stratixiii_saturate_block.                                           --
--------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;


ENTITY stratixiii_round_saturate_block IS
    GENERIC (
             dataa_width                    :  integer := 36;
             datab_width                    :  integer := 36;
             saturate_width                 :  integer := 15;
             round_width                    :  integer := 15;
             saturate_mode                  :  string := " asymmetric";
             round_mode                     :  string := "nearest_integer";
             operation_mode                 :  string := "output_only"  ;
             tipd_datain          : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
             tipd_round            : VitalDelayType01 :=DefPropDelay01;
             tipd_saturate         : VitalDelayType01 :=DefPropDelay01;
             tipd_signa            : VitalDelayType01 :=DefPropDelay01;
             tipd_signb            : VitalDelayType01 :=DefPropDelay01;
             tpd_datain_dataout    : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
             tpd_round_dataout     : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             tpd_saturate_dataout  : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             tpd_signa_dataout     : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             tpd_signb_dataout     : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             tpd_datain_saturationoverflow    : VitalDelayType01 := DefPropDelay01;
             tpd_round_saturationoverflow     : VitalDelayType01 := DefPropDelay01;
             tpd_saturate_saturationoverflow  : VitalDelayType01 := DefPropDelay01;
             tpd_signa_saturationoverflow     : VitalDelayType01 := DefPropDelay01;
             tpd_signb_saturationoverflow     : VitalDelayType01 := DefPropDelay01;
             XOn                   : Boolean := DefGlitchXOn;
             MsgOn                 : Boolean := DefGlitchMsgOn
            );
    PORT (
          datain                  : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
          round                   : IN std_logic := '0';
          saturate                : IN std_logic := '0';
          signa                   : IN std_logic := '0';
          signb                   : IN std_logic := '0';
          datain_width            : IN std_logic_vector(7 DOWNTO 0);
          dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
          saturationoverflow     : OUT std_logic
         );
END stratixiii_round_saturate_block;

ARCHITECTURE arch OF stratixiii_round_saturate_block IS
    COMPONENT stratixiii_round_block
       GENERIC (
            round_mode                     :  string := "nearest_integer";
            round_width                    : integer := 15;
            operation_mode                 :  string := "output_only"
           );

       PORT (
             datain                  : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
             round                   : IN std_logic := '0';
             datain_width            : IN  std_logic_vector(7 DOWNTO 0)  := (others => '0');
             dataout                 : OUT std_logic_vector(71 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT stratixiii_saturate_block
       GENERIC (
                 dataa_width                    :  integer := 36;
                 datab_width                    :  integer := 36;
                 saturate_mode                  :  string := " asymmetric";
                 saturate_width                 :  integer := 15;
                 round_width                    :  integer := 15;
                 operation_mode                 :  string := "output_only"
                );
       PORT (
             datain                  : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
             saturate                : IN std_logic := '0';
             round                   : IN std_logic := '0';
             signa                   : IN  std_logic := '0';
             signb                   : IN  std_logic := '0';
             datain_width                : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
             dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
             saturation_overflow     : OUT std_logic
            );
    END COMPONENT;

    SIGNAL dataout_round            :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL saturate_in              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL dataout_saturate         :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datain_ipd               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL signa_ipd                :  std_logic := '0';
    SIGNAL signb_ipd                :  std_logic := '0';
    SIGNAL round_ipd                :  std_logic := '0';
    SIGNAL saturate_ipd             :  std_logic := '0';
    SIGNAL saturationoverflow_tmp                :  std_logic := '0';

BEGIN
    WireDelay : block
    begin
        g1 :for i in datain'range generate
            VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
        end generate;
        VitalWireDelay (signa_ipd, signa, tipd_signa);
        VitalWireDelay (signb_ipd, signb, tipd_signb);
        VitalWireDelay (round_ipd, round, tipd_round);
        VitalWireDelay (saturate_ipd, saturate, tipd_saturate);
    end block;

    round_unit : stratixiii_round_block
       GENERIC MAP (
                      operation_mode => operation_mode,
                      round_width => round_width,
                      round_mode => round_mode
                    )
       PORT MAP (
                 datain => datain_ipd,
                 round => round_ipd,
                 datain_width => datain_width,
                 dataout => dataout_round
                );

    saturate_unit : stratixiii_saturate_block
       GENERIC MAP (
                    dataa_width => dataa_width,
                    datab_width => datab_width,
                    operation_mode => operation_mode,
                    saturate_mode => saturate_mode,
                    saturate_width =>saturate_width,
                     round_width =>round_width
                    )
       PORT MAP (
                 datain => dataout_round,
                 saturate => saturate_ipd,
                 round    => round_ipd,
                 signa => signa_ipd,
                 signb => signb_ipd,
                 datain_width => datain_width,
                 dataout => dataout_saturate,
                 saturation_overflow => saturationoverflow_tmp
               );

     PathDelay : block
     begin
         do1 : for i in dataout'range generate
             process(dataout_saturate(i))
                 VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;
                 begin
                     VitalPathDelay01 (
                       OutSignal => dataout(i),
                       OutSignalName => "dataout",
                       OutTemp => dataout_saturate(i),
                       Paths => (0 => (datain_ipd'last_event, tpd_datain_dataout(i), TRUE),
                                 1 => (round_ipd'last_event, tpd_round_dataout(i), TRUE),
                                 2 => (saturate_ipd'last_event, tpd_saturate_dataout(i), TRUE),
                                 3 => (signa'last_event, tpd_signa_dataout(i), TRUE),
                                 4 => (signb'last_event, tpd_signb_dataout(i), TRUE)),
                       GlitchData => dataout_VitalGlitchData,
                       Mode => DefGlitchMode,
                       MsgOn => FALSE,
                       XOn  => TRUE
                       );
             end process;
         end generate do1;

         process(saturationoverflow_tmp)
             VARIABLE saturationoverflow_VitalGlitchData : VitalGlitchDataType;
             begin
                 VitalPathDelay01 (
                 OutSignal     => saturationoverflow,
                 OutSignalName => "saturationoverflow",
                 OutTemp       => saturationoverflow_tmp,
                Paths => (0 => (datain_ipd'last_event, tpd_datain_saturationoverflow, TRUE),
                          1 => (round_ipd'last_event, tpd_round_saturationoverflow, TRUE),
                          2 => (saturate_ipd'last_event, tpd_saturate_saturationoverflow, TRUE),
                          3 => (signa'last_event, tpd_signa_saturationoverflow, TRUE),
                          4 => (signb'last_event, tpd_signb_saturationoverflow, TRUE)),
                 GlitchData    => saturationoverflow_VitalGlitchData,
                 Mode          => DefGlitchMode,
                 XOn           => TRUE,
                 MsgOn         => TRUE
                 );
             end process;
     end block;
END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_rotate_shift_block                                           --
--  Description:             Stratix III roate and shift Unit.                                        --
--------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_rotate_shift_block IS
    GENERIC (
             dataa_width                    :  integer := 32;
             datab_width                    :  integer := 32;
             tipd_datain           : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
             tipd_rotate           : VitalDelayType01 :=DefPropDelay01;
             tipd_shiftright       : VitalDelayType01 :=DefPropDelay01;
             tipd_signa            : VitalDelayType01 :=DefPropDelay01;
             tipd_signb            : VitalDelayType01 :=DefPropDelay01;
             tpd_datain_dataout    : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
             tpd_rotate_dataout    : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             tpd_shiftright_dataout: VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             tpd_signa_dataout     : VitalDelayArrayType01(71 downto 0) := (others => DefPropDelay01);
             XOn                   : Boolean := DefGlitchXOn;
             MsgOn                 : Boolean := DefGlitchMsgOn
             );
    PORT (
          datain                  : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
          rotate                  : IN std_logic := '0';
          shiftright              : IN std_logic := '0';
          signa                   : IN std_logic := '0';
          signb                   : IN std_logic := '0';
          dataout                 : OUT std_logic_vector(71 DOWNTO 0)
          );
END stratixiii_rotate_shift_block;

ARCHITECTURE arch OF stratixiii_rotate_shift_block IS
    signal dataout_tmp              :  std_logic_vector(71 downto 0) := (others => '0');
    SIGNAL datain_ipd               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL signa_ipd                :  std_logic := '0';
    SIGNAL signb_ipd                :  std_logic := '0';
    SIGNAL rotate_ipd                :  std_logic := '0';
    SIGNAL shiftright_ipd             :  std_logic := '0';
    SIGNAL sign                       : std_logic;

BEGIN
    WireDelay : block
    begin
        g1 :for i in datain'range generate
            VitalWireDelay (datain_ipd(i), datain(i), tipd_datain(i));
        end generate;
        VitalWireDelay (signa_ipd, signa, tipd_signa);
        VitalWireDelay (signb_ipd, signa, tipd_signa);
        VitalWireDelay (rotate_ipd, rotate, tipd_rotate);
        VitalWireDelay (shiftright_ipd, shiftright, tipd_shiftright);
    end block;

    PROCESS
    BEGIN
        WAIT UNTIL datain_ipd'EVENT OR rotate_ipd'EVENT OR shiftright_ipd'EVENT;
        sign <= signa_ipd xor signb_ipd;
        dataout_tmp <= datain;
        IF ((rotate_ipd = '0') AND (shiftright_ipd = '0')) THEN
            dataout_tmp(39 downto 8) <=   datain_ipd(39 downto 8);
        ELSIF ((rotate_ipd = '0') AND (shiftright_ipd = '1')) THEN --shift right
            dataout_tmp(39 downto 8) <= datain_ipd(71 downto 40);
        ELSIF((rotate_ipd = '1') AND (shiftright_ipd = '0')) THEN
            dataout_tmp(39 downto 8) <=   datain_ipd(39 downto 8) OR datain_ipd(71 downto 40);
        ELSE
            dataout_tmp <= datain_ipd;
        END IF;
    END PROCESS;

     PathDelay : block
     begin
         do1 : for i in dataout'range generate
             process(dataout_tmp(i))
                 VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;
                 begin
                     VitalPathDelay01 (
                       OutSignal => dataout(i),
                       OutSignalName => "dataout",
                       OutTemp => dataout_tmp(i),
                       Paths => (0 => (datain_ipd'last_event, tpd_datain_dataout(i), TRUE),
                                 1 => (rotate_ipd'last_event, tpd_rotate_dataout(i), TRUE),
                                 2 => (shiftright_ipd'last_event, tpd_shiftright_dataout(i), TRUE),
                                 3 => (signa'last_event, tpd_signa_dataout(i), TRUE)),
                       GlitchData => dataout_VitalGlitchData,
                       Mode => DefGlitchMode,
                       MsgOn => FALSE,
                       XOn  => TRUE
                       );
             end process;
         end generate do1;
     end block;

END arch;

--------------------------------------------------------------------------------------------------
--  Module Name:             stratixiii_carry_chain_adder                                            --
--  Description:             Stratix III carry Chain Adder                                            --
--------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_carry_chain_adder IS
    GENERIC(
            tipd_dataa            : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
            tipd_datab            : VitalDelayArrayType01(71 downto 0) := (OTHERS => DefPropDelay01);
            tpd_dataa_dataout     : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
            tpd_datab_dataout     : VitalDelayArrayType01(72*72-1 downto 0) := (others => DefPropDelay01);
            XOn                   : Boolean := DefGlitchXOn;
            MsgOn                 : Boolean := DefGlitchMsgOn
            );
    PORT (
           dataa                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
           datab                   : IN std_logic_vector(71 DOWNTO 0) := (others => '0');
           dataout                 : OUT STD_LOGIC_vector(71 DOWNTO 0)
         );
END stratixiii_carry_chain_adder;

ARCHITECTURE arch OF stratixiii_carry_chain_adder IS
    SIGNAL dataa_ipd               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datab_ipd               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL dataout_tmp               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
BEGIN
    WireDelay : block
    begin
        g1 :for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        g2 :for i in datab'range generate
            VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        end generate;
    end block;

    dataout_tmp <= (dataa_ipd(71 downto 45) & dataa_ipd(43) & dataa_ipd(43 downto 0)) + (datab_ipd(71 downto 45) & datab_ipd(43) & datab_ipd(43 downto 0)) ;

    PathDelay : block
     begin
         do1 : for i in dataout'range generate
             process(dataout_tmp(i))
                 VARIABLE dataout_VitalGlitchData : VitalGlitchDataType;
                 begin
                     VitalPathDelay01 (
                       OutSignal => dataout(i),
                       OutSignalName => "dataout",
                       OutTemp => dataout_tmp(i),
                       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout(i), TRUE),
                                 1 => (datab_ipd'last_event, tpd_datab_dataout(i), TRUE)),
                       GlitchData => dataout_VitalGlitchData,
                       Mode => DefGlitchMode,
                       MsgOn => FALSE,
                       XOn  => TRUE
                       );
             end process;
         end generate do1;
     end block;
END arch;

----------------------------------------------------------------------------------
--  Module Name:             stratixiii_mac_out_atom                                 --
--  Description:             Simulation model for stratixiii mac out atom            --
--                           This model instantiates the following components   --
--                              1.stratixiii_mac_bit_register                        --
--                              2.stratixiii_mac_register                            --
--                              3.stratixiii_fsa_isse                                --
--                              4.stratixiii_first_stage_add_sub                     --
--                              5.stratixiii_second_stage_add_accum                  --
--                              6.stratixiii_round_saturate_block                    --
--                              7.stratixiii_rotate_shift_block                      --
--                              8.stratixiii_carry_chain_adder                       --
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

ENTITY stratixiii_mac_out IS
    GENERIC (
            operation_mode                 :  string := "output_only";
            dataa_width                    :  integer := 1;
            datab_width                    :  integer := 1;
            datac_width                    :  integer := 1;
            datad_width                    :  integer := 1;
            chainin_width                  :  integer := 1;
            round_width                    :  integer := 15;
            round_chain_out_width          :  integer := 15;
            saturate_width                 :  integer := 15;
            saturate_chain_out_width       :  integer := 15;
            first_adder0_clock             :  string := "none";
            first_adder0_clear             :  string := "none";
            first_adder1_clock             :  string := "none";
            first_adder1_clear             :  string := "none";
            second_adder_clock             :  string := "none";
            second_adder_clear             :  string := "none";
            output_clock                   :  string := "none";
            output_clear                   :  string := "none";
            signa_clock                    :  string := "none";
            signa_clear                    :  string := "none";
            signb_clock                    :  string := "none";
            signb_clear                    :  string := "none";
            round_clock                    :  string := "none";
            round_clear                    :  string := "none";
            roundchainout_clock            :  string := "none";
            roundchainout_clear            :  string := "none";
            saturate_clock                 :  string := "none";
            saturate_clear                 :  string := "none";
            saturatechainout_clock         :  string := "none";
            saturatechainout_clear         :  string := "none";
            zeroacc_clock                  :  string := "none";
            zeroacc_clear                  :  string := "none";
            zeroloopback_clock             :  string := "none";
            zeroloopback_clear             :  string := "none";
            rotate_clock                   :  string := "none";
            rotate_clear                   :  string := "none";
            shiftright_clock               :  string := "none";
            shiftright_clear               :  string := "none";
            signa_pipeline_clock           :  string := "none";
            signa_pipeline_clear           :  string := "none";
            signb_pipeline_clock           :  string := "none";
            signb_pipeline_clear           :  string := "none";
            round_pipeline_clock           :  string := "none";
            round_pipeline_clear           :  string := "none";
            roundchainout_pipeline_clock   :  string := "none";
            roundchainout_pipeline_clear   :  string := "none";
            saturate_pipeline_clock        :  string := "none";
            saturate_pipeline_clear        :  string := "none";
            saturatechainout_pipeline_clock:  string := "none";
            saturatechainout_pipeline_clear:  string := "none";
            zeroacc_pipeline_clock         :  string := "none";
            zeroacc_pipeline_clear         :  string := "none";
            zeroloopback_pipeline_clock    :  string := "none";
            zeroloopback_pipeline_clear    :  string := "none";
            rotate_pipeline_clock          :  string := "none";
            rotate_pipeline_clear          :  string := "none";
            shiftright_pipeline_clock      :  string := "none";
            shiftright_pipeline_clear      :  string := "none";
            roundchainout_output_clock     :  string := "none";
            roundchainout_output_clear     :  string := "none";
            saturatechainout_output_clock  :  string := "none";
            saturatechainout_output_clear  :  string := "none";
            zerochainout_output_clock      :  string := "none";
            zerochainout_output_clear      :  string := "none";
            zeroloopback_output_clock      :  string := "none";
            zeroloopback_output_clear      :  string := "none";
            rotate_output_clock            :  string := "none";
            rotate_output_clear            :  string := "none";
            shiftright_output_clock        :  string := "none";
            shiftright_output_clear        :  string := "none";
            first_adder0_mode              :  string := "add";
            first_adder1_mode              :  string := "add";
            acc_adder_operation            :  string := "add";
            round_mode                     :  string := "nearest_integer";
            round_chain_out_mode           :  string := "nearest_integer";
            saturate_mode                  :  string := "asymmetric";
            saturate_chain_out_mode        :  string := "asymmetric";
            multa_signa_internally_grounded : string := "false";
            multa_signb_internally_grounded : string := "false";
            multb_signa_internally_grounded : string := "false";
            multb_signb_internally_grounded : string := "false";
            multc_signa_internally_grounded : string := "false";
            multc_signb_internally_grounded : string := "false";
            multd_signa_internally_grounded : string := "false";
            multd_signb_internally_grounded : string := "false";
            lpm_type                       :  string := "stratixiii_mac_out";
            dataout_width                  :  integer:=72
           );
    PORT (
          dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '1');
          datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '1');
          datac                   : IN std_logic_vector(datac_width - 1 DOWNTO 0):= (others => '1');
          datad                   : IN std_logic_vector(datad_width - 1 DOWNTO 0):= (others => '1');
          signa                   : IN std_logic := '1';
          signb                   : IN std_logic := '1';
          chainin                 : IN std_logic_vector(chainin_width - 1 DOWNTO 0):= (others => '0');
          round                   : IN std_logic := '0';
          saturate                : IN std_logic := '0';
          zeroacc                 : IN std_logic := '0';
          roundchainout           : IN std_logic := '0';
          saturatechainout        : IN std_logic := '0';
          zerochainout            : IN std_logic := '0';
          zeroloopback            : IN std_logic := '0';
          rotate                  : IN std_logic := '0';
          shiftright              : IN std_logic := '0';
          clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
          ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');
          aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');
          loopbackout             : OUT std_logic_vector(17 DOWNTO 0):= (others => '0');
          dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
          overflow                : OUT std_logic := '0';
          saturatechainoutoverflow: OUT std_logic := '0';
          dftout                  : OUT std_logic := '0';
          devpor                  : IN std_logic := '1';
          devclrn                 : IN std_logic := '1'
       );
END stratixiii_mac_out;

ARCHITECTURE arch OF stratixiii_mac_out IS
    COMPONENT stratixiii_mac_bit_register
      PORT (
            datain                  : IN  std_logic := '0';
            clk                     : IN  std_logic := '0';
            aclr                    : IN  std_logic := '0';
            sload                   : IN  std_logic := '0';
            bypass_register         : IN  std_logic := '0';
            dataout                 : OUT std_logic
            );
   END COMPONENT;

   COMPONENT stratixiii_mac_register
        GENERIC (
                 data_width                     :  integer := 18
                );
        PORT (
               datain                  : IN  std_logic_vector(data_width - 1 DOWNTO 0) := (others => '0');
               clk                     : IN  std_logic := '0';
               aclr                    : IN  std_logic := '0';
               sload                   : IN  std_logic := '0';
               bypass_register         : IN  std_logic := '0';
               dataout                 : OUT std_logic_vector(data_width - 1 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT stratixiii_fsa_isse
        GENERIC (
                   datab_width                    :  integer := 36;
                   dataa_width                    :  integer := 36;
                   chainin_width                  :  integer := 44;
                   operation_mode                 :  string := "output_only";
                   datad_width                    :  integer := 36;
                   multa_signa_internally_grounded : string := "false";
                   multa_signb_internally_grounded : string := "false";
                   multb_signa_internally_grounded : string := "false";
                   multb_signb_internally_grounded : string := "false";
                   multc_signa_internally_grounded : string := "false";
                   multc_signb_internally_grounded : string := "false";
                   multd_signa_internally_grounded : string := "false";
                   multd_signb_internally_grounded : string := "false";
                   datac_width                    :  integer := 36
                );
        PORT (
               dataa                   : IN  std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '0');
               datab                   : IN  std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '0');
               datac                   : IN  std_logic_vector(datac_width - 1 DOWNTO 0):= (others => '0');
               datad                   : IN  std_logic_vector(datad_width - 1 DOWNTO 0):= (others => '0');
               chainin                 : IN  std_logic_vector(chainin_width - 1 DOWNTO 0):= (others => '0');
               signa                    : IN  std_logic := '0';
               signb                    : IN  std_logic := '0';
               dataa_out               : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               datab_out               : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               datac_out               : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               datad_out               : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               chainin_out             : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               operation               : OUT std_logic_vector(3 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT stratixiii_first_stage_add_sub
        GENERIC (
                  dataa_width                    :  integer := 36;
                  datab_width                    :  integer := 36;
                  fsa_mode                       :  string := "add"
                );
        PORT (
               dataa                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               datab                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               sign                    : IN  std_logic := '0';
               operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
               dataout                 : OUT std_logic_vector(71 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT stratixiii_second_stage_add_accum
       GENERIC (
                dataa_width                    :  integer := 36;
                datab_width                    :  integer := 36;
                ssa_mode                       :  string := "add"
                );
        PORT (
               dataa                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               datab                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               accumin                : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               sign                    : IN  std_logic := '0';
               operation               : IN  std_logic_vector(3 DOWNTO 0) := (others => '0');
               dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               overflow                : OUT std_logic
            );
    END COMPONENT;

    COMPONENT stratixiii_round_saturate_block
        GENERIC (
                   datab_width                    :  integer := 36;
                   dataa_width                    :  integer := 36;
                   saturate_mode                  :  string := " asymmetric";
                   saturate_width                 :  integer := 15;
                   round_width                    :  integer := 15;
                   operation_mode                 :  string := "output_only";
                   round_mode                     :  string := "nearest_integer"
                );
        PORT (
               datain                  : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               round                   : IN  std_logic := '0';
               saturate                : IN  std_logic := '0';
               signa                   : IN  std_logic := '0';
               signb                   : IN  std_logic := '0';
               datain_width            : IN  std_logic_vector(7 DOWNTO 0) := (others => '0');
               dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');
               saturationoverflow     : OUT std_logic
            );
    END COMPONENT;

 COMPONENT stratixiii_rotate_shift_block
        GENERIC (
                   datab_width                    :  integer := 32;
                   dataa_width                    :  integer := 32
                );
        PORT (
               datain                  : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               rotate                  : IN  std_logic := '0';
               shiftright              : IN  std_logic := '0';
               signa                   : IN  std_logic := '0';
               signb                   : IN  std_logic := '0';
               dataout                 : OUT std_logic_vector(71 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT stratixiii_carry_chain_adder
        PORT (
               dataa                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               datab                   : IN  std_logic_vector(71 DOWNTO 0) := (others => '0');
               dataout                 : OUT std_logic_vector(71 DOWNTO 0)
            );
    END COMPONENT;

    --signals for zeroloopback input register
    SIGNAL zeroloopback_clkval_ir   :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroloopback_aclrval_ir  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroloopback_clk_ir      :  std_logic := '0';
    SIGNAL zeroloopback_aclr_ir     :  std_logic := '0';
    SIGNAL zeroloopback_sload_ir    :  std_logic := '0';
    SIGNAL zeroloopback_bypass_register_ir :  std_logic := '0';
    SIGNAL zeroloopback_in_reg      :  std_logic := '0';
    SIGNAL zeroloopback_in      :  std_logic := '0';

    --signals for zeroacc input register
    SIGNAL zeroacc_clkval_ir        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroacc_aclrval_ir       :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroacc_clk_ir           :  std_logic := '0';
    SIGNAL zeroacc_aclr_ir          :  std_logic := '0';
    SIGNAL zeroacc_sload_ir         :  std_logic := '0';
    SIGNAL zeroacc_bypass_register_ir      :  std_logic := '0';
    SIGNAL zeroacc_in_reg           :  std_logic := '0';
    SIGNAL zeroacc_in           :  std_logic := '0';

    --Signals for signa input register
    SIGNAL signa_clkval_ir          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signa_aclrval_ir         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signa_clk_ir             :  std_logic := '0';
    SIGNAL signa_aclr_ir            :  std_logic := '0';
    SIGNAL signa_sload_ir           :  std_logic := '0';
    SIGNAL signa_bypass_register_ir :  std_logic := '0';
    SIGNAL signa_in_reg             :  std_logic := '0';
    SIGNAL signa_in             :  std_logic := '0';

    --signals for signb input register
    SIGNAL signb_clkval_ir          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signb_aclrval_ir         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signb_clk_ir             :  std_logic := '0';
    SIGNAL signb_aclr_ir            :  std_logic := '0';
    SIGNAL signb_sload_ir           :  std_logic := '0';
    SIGNAL signb_bypass_register_ir :  std_logic := '0';
    SIGNAL signb_in_reg             :  std_logic := '0';
    SIGNAL signb_in             :  std_logic := '0';
    
    --signals for rotate input register
    SIGNAL rotate_clkval_ir         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rotate_aclrval_ir        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rotate_clk_ir            :  std_logic := '0';
    SIGNAL rotate_aclr_ir           :  std_logic := '0';
    SIGNAL rotate_sload_ir          :  std_logic := '0';
    SIGNAL rotate_bypass_register_ir:  std_logic := '0';
    SIGNAL rotate_in_reg            :  std_logic := '0';
    SIGNAL rotate_in            :  std_logic := '0';
    
    --signals for shiftright input register
    SIGNAL shiftright_clkval_ir     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL shiftright_aclrval_ir    :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL shiftright_clk_ir        :  std_logic := '0';
    SIGNAL shiftright_aclr_ir       :  std_logic := '0';
    SIGNAL shiftright_sload_ir      :  std_logic := '0';
    SIGNAL shiftright_bypass_register_ir   :  std_logic := '0';
    SIGNAL shiftright_in_reg        :  std_logic := '0';
    SIGNAL shiftright_in        :  std_logic := '0';
    --signals for round input register
    SIGNAL round_clkval_ir          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL round_aclrval_ir         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL round_clk_ir             :  std_logic := '0';
    SIGNAL round_aclr_ir            :  std_logic := '0';
    SIGNAL round_sload_ir           :  std_logic := '0';
    SIGNAL round_bypass_register_ir :  std_logic := '0';
    SIGNAL round_in_reg             :  std_logic := '0';
    SIGNAL round_in             :  std_logic := '0';

    --signals for saturate input register
    SIGNAL saturate_clkval_ir       :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturate_aclrval_ir      :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturate_clk_ir          :  std_logic := '0';
    SIGNAL saturate_aclr_ir         :  std_logic := '0';
    SIGNAL saturate_sload_ir        :  std_logic := '0';
    SIGNAL saturate_bypass_register_ir     :  std_logic := '0';
    SIGNAL saturate_in_reg          :  std_logic := '0';
    SIGNAL saturate_in          :  std_logic := '0';
    --signals for roundchainout input register
    SIGNAL roundchainout_clkval_ir  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL roundchainout_aclrval_ir :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL roundchainout_clk_ir     :  std_logic := '0';
    SIGNAL roundchainout_aclr_ir    :  std_logic := '0';
    SIGNAL roundchainout_sload_ir   :  std_logic := '0';
    SIGNAL roundchainout_bypass_register_ir:  std_logic := '0';
    SIGNAL roundchainout_in_reg     :  std_logic := '0';
    SIGNAL roundchainout_in          :  std_logic := '0';
    --signals for saturatechainout input register
    SIGNAL saturatechainout_clkval_ir      :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturatechainout_aclrval_ir     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturatechainout_clk_ir  :  std_logic := '0';
    SIGNAL saturatechainout_aclr_ir :  std_logic := '0';
    SIGNAL saturatechainout_sload_ir:  std_logic := '0';
    SIGNAL saturatechainout_bypass_register_ir:  std_logic := '0';
    SIGNAL saturatechainout_in_reg  :  std_logic := '0';
    SIGNAL saturatechainout_in  :  std_logic := '0';
   
    --signals for fsa_input_interface
    SIGNAL dataa_fsa_in             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datab_fsa_in             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datac_fsa_in             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL datad_fsa_in             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL chainin_coa_in           :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL operation                :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    --Signals for First Stage Adder units
    SIGNAL dataout_fsa0             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL fsa_pip_datain1          :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL dataout_fsa1             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL overflow_fsa0            :  std_logic := '0';
    SIGNAL overflow_fsa1            :  std_logic := '0';
    --signals for zeroloopback pipeline register
    SIGNAL zeroloopback_clkval_pip  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroloopback_aclrval_pip :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroloopback_clk_pip     :  std_logic := '0';
    SIGNAL zeroloopback_aclr_pip    :  std_logic := '0';
    SIGNAL zeroloopback_sload_pip   :  std_logic := '0';
    SIGNAL zeroloopback_bypass_register_pip:  std_logic := '0';
    SIGNAL zeroloopback_pip_reg     :  std_logic := '0';
    --signals for zeroacc pipeline register
    SIGNAL zeroacc_clkval_pip       :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroacc_aclrval_pip      :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroacc_clk_pip          :  std_logic := '0';
    SIGNAL zeroacc_aclr_pip         :  std_logic := '0';
    SIGNAL zeroacc_sload_pip        :  std_logic := '0';
    SIGNAL zeroacc_bypass_register_pip     :  std_logic := '0';
    SIGNAL zeroacc_pip_reg          :  std_logic := '0';
    --Signals for signa pipeline register
    SIGNAL signa_clkval_pip         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signa_aclrval_pip        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signa_clk_pip            :  std_logic := '0';
    SIGNAL signa_aclr_pip           :  std_logic := '0';
    SIGNAL signa_sload_pip          :  std_logic := '0';
    SIGNAL signa_bypass_register_pip:  std_logic := '0';
    SIGNAL signa_pip_reg            :  std_logic := '0';
    --signals for signb pipeline register
    SIGNAL signb_clkval_pip         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signb_aclrval_pip        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL signb_clk_pip            :  std_logic := '0';
    SIGNAL signb_aclr_pip           :  std_logic := '0';
    SIGNAL signb_sload_pip          :  std_logic := '0';
    SIGNAL signb_bypass_register_pip:  std_logic := '0';
    SIGNAL signb_pip_reg            :  std_logic := '0';
    --signals for rotate pipeline register
    SIGNAL rotate_clkval_pip        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rotate_aclrval_pip       :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rotate_clk_pip           :  std_logic := '0';
    SIGNAL rotate_aclr_pip          :  std_logic := '0';
    SIGNAL rotate_sload_pip         :  std_logic := '0';
    SIGNAL rotate_bypass_register_pip      :  std_logic := '0';
    SIGNAL rotate_pip_reg           :  std_logic := '0';
    --signals for shiftright pipeline register
    SIGNAL shiftright_clkval_pip    :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL shiftright_aclrval_pip   :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL shiftright_clk_pip       :  std_logic := '0';
    SIGNAL shiftright_aclr_pip      :  std_logic := '0';
    SIGNAL shiftright_sload_pip     :  std_logic := '0';
    SIGNAL shiftright_bypass_register_pip  :  std_logic := '0';
    SIGNAL shiftright_pip_reg       :  std_logic := '0';
    --signals for round pipeline register
    SIGNAL round_clkval_pip         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL round_aclrval_pip        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL round_clk_pip            :  std_logic := '0';
    SIGNAL round_aclr_pip           :  std_logic := '0';
    SIGNAL round_sload_pip          :  std_logic := '0';
    SIGNAL round_bypass_register_pip:  std_logic := '0';
    SIGNAL round_pip_reg            :  std_logic := '0';
    --signals for saturate pipeline register
    SIGNAL saturate_clkval_pip      :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturate_aclrval_pip     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturate_clk_pip         :  std_logic := '0';
    SIGNAL saturate_aclr_pip        :  std_logic := '0';
    SIGNAL saturate_sload_pip       :  std_logic := '0';
    SIGNAL saturate_bypass_register_pip    :  std_logic := '0';
    SIGNAL saturate_pip_reg         :  std_logic := '0';
    --signals for roundchainout pipeline register
    SIGNAL roundchainout_clkval_pip :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL roundchainout_aclrval_pip:  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL roundchainout_clk_pip    :  std_logic := '0';
    SIGNAL roundchainout_aclr_pip   :  std_logic := '0';
    SIGNAL roundchainout_sload_pip  :  std_logic := '0';
    SIGNAL roundchainout_bypass_register_pip:  std_logic := '0';
    SIGNAL roundchainout_pip_reg    :  std_logic := '0';
    --signals for saturatechainout pipeline register
    SIGNAL saturatechainout_clkval_pip     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturatechainout_aclrval_pip    :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturatechainout_clk_pip :  std_logic := '0';
    SIGNAL saturatechainout_aclr_pip:  std_logic := '0';
    SIGNAL saturatechainout_sload_pip      :  std_logic := '0';
    SIGNAL saturatechainout_bypass_register_pip:  std_logic := '0';
    SIGNAL saturatechainout_pip_reg :  std_logic := '0';
    --signals for fsa0 pipeline register
    SIGNAL fsa0_clkval_pip          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL fsa0_aclrval_pip         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL fsa0_clk_pip             :  std_logic := '0';
    SIGNAL fsa0_aclr_pip            :  std_logic := '0';
    SIGNAL fsa0_sload_pip           :  std_logic := '0';
    SIGNAL fsa0_bypass_register_pip :  std_logic := '0';
    SIGNAL fsa0_pip_reg             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    --signals for fsa1 pipeline register
    SIGNAL fsa1_clkval_pip          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL fsa1_aclrval_pip         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL fsa1_clk_pip             :  std_logic := '0';
    SIGNAL fsa1_aclr_pip            :  std_logic := '0';
    SIGNAL fsa1_sload_pip           :  std_logic := '0';
    SIGNAL fsa1_bypass_register_pip :  std_logic := '0';
    SIGNAL fsa1_pip_reg             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    --Signals for second stage adder
    SIGNAL ssa_accum_in             :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL ssa_sign                 :  std_logic := '0';
    SIGNAL ssa_dataout              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL ssa_overflow             :  std_logic := '0';
    --Signals for RS block
    SIGNAL rs_datain                :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout               :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_of            :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_tmp           :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL rs_saturation_overflow   :  std_logic := '0';
    SIGNAL ssa_datain_width         :  std_logic_vector(7 DOWNTO 0);
    SIGNAL ssa_round_width          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    --signals for zeroloopback output register
    SIGNAL zeroloopback_clkval_or   :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroloopback_aclrval_or  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zeroloopback_clk_or      :  std_logic := '0';
    SIGNAL zeroloopback_aclr_or     :  std_logic := '0';
    SIGNAL zeroloopback_sload_or    :  std_logic := '0';
    SIGNAL zeroloopback_bypass_register_or :  std_logic := '0';
    SIGNAL zeroloopback_out_reg     :  std_logic := '0';
    --signals for zerochainout output register
    SIGNAL zerochainout_clkval_or   :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zerochainout_aclrval_or  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL zerochainout_clk_or      :  std_logic := '0';
    SIGNAL zerochainout_aclr_or     :  std_logic := '0';
    SIGNAL zerochainout_sload_or    :  std_logic := '0';
    SIGNAL zerochainout_bypass_register_or :  std_logic := '0';
    SIGNAL zerochainout_out_reg     :  std_logic := '0';
    --Signals for saturation_overflow output register
    SIGNAL rs_saturation_overflow_in        :  std_logic := '0';
    SIGNAL saturation_overflow_clkval_or   :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturation_overflow_aclrval_or  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturation_overflow_clk_or      :  std_logic := '0';
    SIGNAL saturation_overflow_aclr_or     :  std_logic := '0';
    SIGNAL saturation_overflow_sload_or    :  std_logic := '0';
    SIGNAL saturation_overflow_bypass_register_or:  std_logic := '0';
    SIGNAL saturation_overflow_out_reg     :  std_logic := '0';
    --signals for rs_dataout output register
    SIGNAL rs_dataout_in            :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_clkval_or     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_aclrval_or    :  std_logic_vector(3 DOWNTO 0) := (others => '0');
     SIGNAL rs_dataout_clkval_or_co     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_aclrval_or_co    :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_clkval_or_o     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_aclrval_or_o   :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rs_dataout_clk_or        :  std_logic := '0';
    SIGNAL rs_dataout_aclr_or       :  std_logic := '0';
    SIGNAL rs_dataout_sload_or      :  std_logic := '0';
    SIGNAL rs_dataout_bypass_register_or_co   :  std_logic := '0';
    SIGNAL rs_dataout_bypass_register_or_o   :  std_logic := '0';
    SIGNAL rs_dataout_bypass_register_or   :  std_logic := '0';
    SIGNAL rs_dataout_out_reg       :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL rs_saturation_overflow_out_reg  :  std_logic := '0';

    --signals for rotate output register
    SIGNAL rotate_clkval_or         :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rotate_aclrval_or        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL rotate_clk_or            :  std_logic := '0';
    SIGNAL rotate_aclr_or           :  std_logic := '0';
    SIGNAL rotate_sload_or          :  std_logic := '0';
    SIGNAL rotate_bypass_register_or:  std_logic := '0';
    SIGNAL rotate_out_reg           :  std_logic := '0';
    --signals for shiftright output register
    SIGNAL shiftright_clkval_or     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL shiftright_aclrval_or    :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL shiftright_clk_or        :  std_logic := '0';
    SIGNAL shiftright_aclr_or       :  std_logic := '0';
    SIGNAL shiftright_sload_or      :  std_logic := '0';
    SIGNAL shiftright_bypass_register_or   :  std_logic := '0';
    SIGNAL shiftright_out_reg       :  std_logic := '0';
    --signals for roundchainout output register
    SIGNAL roundchainout_clkval_or  :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL roundchainout_aclrval_or :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL roundchainout_clk_or     :  std_logic := '0';
    SIGNAL roundchainout_aclr_or    :  std_logic := '0';
    SIGNAL roundchainout_sload_or   :  std_logic := '0';
    SIGNAL roundchainout_bypass_register_or:  std_logic := '0';
    SIGNAL roundchainout_out_reg    :  std_logic := '0';
    --signals for saturatechainout output register
    SIGNAL saturatechainout_clkval_or      :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturatechainout_aclrval_or     :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL saturatechainout_clk_or  :  std_logic := '0';
    SIGNAL saturatechainout_aclr_or :  std_logic := '0';
    SIGNAL saturatechainout_sload_or:  std_logic := '0';
    SIGNAL saturatechainout_bypass_register_or:  std_logic := '0';
    SIGNAL saturatechainout_out_reg :  std_logic := '0';
    --Signals for chainout Adder RS Block
    SIGNAL coa_dataout              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL coa_round_width          :  std_logic_vector(3 DOWNTO 0) := (others => '0');
     SIGNAL coa_rs_dataout           :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL coa_rs_saturation_overflow      :  std_logic := '0';
    --signals for control signals for COA output register
    SIGNAL coa_reg_clkval_or        :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL coa_reg_aclrval_or       :  std_logic_vector(3 DOWNTO 0) := (others => '0');
    SIGNAL coa_reg_clk_or           :  std_logic := '0';
    SIGNAL coa_reg_aclr_or          :  std_logic := '0';
    SIGNAL coa_reg_sload_or         :  std_logic := '0';
    SIGNAL coa_reg_bypass_register_or      :  std_logic := '0';
    SIGNAL coa_reg_out_reg          :  std_logic := '0';
    SIGNAL coa_rs_saturation_overflow_out_reg:  std_logic := '0';
    SIGNAL coa_rs_saturationchainout_overflow_out_reg:  std_logic := '0';
    SIGNAL coa_rs_dataout_out_reg   :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL dataout_shift_rot        :  std_logic_vector(71 DOWNTO 0):= (others => '0');
    SIGNAL dataout_tmp              :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL loopbackout_tmp          :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL saturation_overflow_tmp  :  std_logic := '0';
    SIGNAL saturationchainout_overflow_tmp :  std_logic := '0';
    SIGNAL rs_dataout_tmp1          :  std_logic_vector(71 DOWNTO 0) := (others => '0');
    SIGNAL sign                     :  std_logic := '0';

BEGIN
process(rs_dataout, rs_saturation_overflow, saturate_pip_reg)
variable rs_tmp : std_logic_vector(71 downto 0):= (others => '0');
begin
    rs_tmp := rs_dataout;
    if (((operation_mode = "output_only")or (operation_mode = "one_level_adder") or(operation_mode = "loopback")) and (dataa_width > 1) and (saturate_pip_reg = '1'))then
        rs_tmp(dataa_width -1) := rs_saturation_overflow ;
    end if;
    rs_dataout_of <= rs_tmp;
end process;
    --Instantiate the zeroloopback input Register
    zeroloopback_clkval_ir <= "0000" WHEN ((zeroloopback_clock = "0") or (zeroloopback_clock = "none"))
                               ELSE "0001" WHEN (zeroloopback_clock = "1")
                               ELSE "0010" WHEN (zeroloopback_clock = "2")
                               ELSE "0011" WHEN (zeroloopback_clock = "3")
                               ELSE "0000" ;
    zeroloopback_aclrval_ir <= "0000" WHEN ((zeroloopback_clear = "0") or (zeroloopback_clear = "none"))
                               ELSE "0001" WHEN (zeroloopback_clear = "1")
                               ELSE "0010" WHEN (zeroloopback_clear = "2")
                               ELSE "0011" WHEN (zeroloopback_clear = "3")
                               ELSE "0000" ;
    zeroloopback_clk_ir <= '1' WHEN clk(conv_integer(zeroloopback_clkval_ir)) = '1' ELSE '0';
    zeroloopback_aclr_ir <= '1' WHEN (aclr(conv_integer(zeroloopback_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    zeroloopback_sload_ir <= '1' WHEN ena(conv_integer(zeroloopback_clkval_ir)) = '1' ELSE '0';
    zeroloopback_bypass_register_ir <= '1' WHEN (zeroloopback_clock = "none") ELSE '0';
    zeroloopback_in <= zeroloopback;
    zeroloopback_input_register : stratixiii_mac_bit_register
         PORT MAP (
                   datain => zeroloopback_in,
                   clk => zeroloopback_clk_ir,
                   aclr => zeroloopback_aclr_ir,
                   sload => zeroloopback_sload_ir,
                   bypass_register => zeroloopback_bypass_register_ir,
                   dataout => zeroloopback_in_reg
                 );

    --Instantiate the zeroacc input Register

     zeroacc_clkval_ir <= "0000" WHEN ((zeroacc_clock = "0") or (zeroacc_clock = "none"))
                                    ELSE "0001" WHEN (zeroacc_clock = "1")
                                    ELSE "0010" WHEN (zeroacc_clock = "2")
                                    ELSE "0011" WHEN (zeroacc_clock = "3")
                                    ELSE "0000" ;
    zeroacc_aclrval_ir <= "0000" WHEN ((zeroacc_clear = "0") or (zeroacc_clear = "none"))
                              ELSE "0001" WHEN (zeroacc_clear = "1")
                              ELSE "0010" WHEN (zeroacc_clear = "2")
                              ELSE "0011" WHEN (zeroacc_clear = "3")
                              ELSE "0000" ;
    zeroacc_clk_ir <= '1' WHEN clk(conv_integer(zeroacc_clkval_ir)) = '1' ELSE '0';
    zeroacc_aclr_ir <= '1' WHEN (aclr(conv_integer(zeroacc_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    zeroacc_sload_ir <= '1' WHEN ena(conv_integer(zeroacc_clkval_ir)) = '1' ELSE '0';
    zeroacc_bypass_register_ir <= '1' WHEN (zeroacc_clock = "none") ELSE '0';
    zeroacc_in  <= zeroacc;
    zeroacc_input_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => zeroacc_in,
                  clk => zeroacc_clk_ir,
                  aclr => zeroacc_aclr_ir,
                  sload => zeroacc_sload_ir,
                  bypass_register => zeroacc_bypass_register_ir,
                  dataout => zeroacc_in_reg
                  );

       --Instantiate the signa input Register
    signa_clkval_ir <= "0000" WHEN ((signa_clock = "0") or (signa_clock = "none"))
                            ELSE "0001" WHEN (signa_clock = "1")
                            ELSE "0010" WHEN (signa_clock = "2")
                            ELSE "0011" WHEN (signa_clock = "3")
                            ELSE "0000" ;
    signa_aclrval_ir <= "0000" WHEN ((signa_clear = "0") or (signa_clear = "none"))
                          ELSE "0001" WHEN (signa_clear = "1")
                          ELSE "0010" WHEN (signa_clear = "2")
                          ELSE "0011" WHEN (signa_clear = "3")
                          ELSE "0000" ;
    signa_clk_ir <= '1' WHEN clk(conv_integer(signa_clkval_ir)) = '1' ELSE '0';
    signa_aclr_ir <= '1' WHEN (aclr(conv_integer(signa_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    signa_sload_ir <= '1' WHEN ena(conv_integer(signa_clkval_ir)) = '1' ELSE '0';
    signa_bypass_register_ir <= '1' WHEN (signa_clock = "none") ELSE '0';
    signa_in <= signa;
    signa_input_register : stratixiii_mac_bit_register
       PORT MAP (
                datain => signa_in,
                clk => signa_clk_ir,
                aclr => signa_aclr_ir,
                sload => signa_sload_ir,
                bypass_register => signa_bypass_register_ir,
                dataout => signa_in_reg
              );

   --Instantiate the signb input Register

    signb_clkval_ir <= "0000" WHEN ((signb_clock = "0") or (signb_clock = "none"))
                         ELSE "0001" WHEN (signb_clock = "1")
                         ELSE "0010" WHEN (signb_clock = "2")
                         ELSE "0011" WHEN (signb_clock = "3")
                         ELSE "0000" ;
    signb_aclrval_ir <= "0000" WHEN ((signb_clear = "0") or (signb_clear = "none"))
                         ELSE "0001" WHEN (signb_clear = "1")
                         ELSE "0010" WHEN (signb_clear = "2")
                         ELSE "0011" WHEN (signb_clear = "3")
                         ELSE "0000" ;
    signb_clk_ir <= '1' WHEN clk(conv_integer(signb_clkval_ir)) = '1' ELSE '0';
    signb_aclr_ir <= '1' WHEN (aclr(conv_integer(signb_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    signb_sload_ir <= '1' WHEN ena(conv_integer(signb_clkval_ir)) = '1' ELSE '0';
    signb_bypass_register_ir <= '1' WHEN (signb_clock = "none") ELSE '0';
    signb_in <= signb;

    signb_input_register : stratixiii_mac_bit_register
     PORT MAP (
               datain => signb_in,
               clk => signb_clk_ir,
               aclr => signb_aclr_ir,
               sload => signb_sload_ir,
               bypass_register => signb_bypass_register_ir,
               dataout => signb_in_reg
               );

     --Instantiate the rotate input Register
    rotate_clkval_ir <= "0000" WHEN ((rotate_clock = "0") or (rotate_clock = "none"))
                         ELSE "0001" WHEN (rotate_clock = "1")
                         ELSE "0010" WHEN (rotate_clock = "2")
                         ELSE "0011" WHEN (rotate_clock = "3")
                         ELSE "0000" ;
    rotate_aclrval_ir <= "0000" WHEN ((rotate_clear = "0") or (rotate_clear = "none"))
                          ELSE "0001" WHEN (rotate_clear = "1")
                          ELSE "0010" WHEN (rotate_clear = "2")
                          ELSE "0011" WHEN (rotate_clear = "3")
                          ELSE "0000" ;
    rotate_clk_ir <= '1' WHEN clk(conv_integer(rotate_clkval_ir)) = '1' ELSE '0';
    rotate_aclr_ir <= '1' WHEN (aclr(conv_integer(rotate_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    rotate_sload_ir <= '1' WHEN ena(conv_integer(rotate_clkval_ir)) = '1' ELSE '0';
    rotate_bypass_register_ir <= '1' WHEN (rotate_clock = "none") ELSE '0';
    rotate_in <= rotate;
    rotate_input_register : stratixiii_mac_bit_register
     PORT MAP (
               datain => rotate_in,
               clk => rotate_clk_ir,
               aclr => rotate_aclr_ir,
               sload => rotate_sload_ir,
               bypass_register => rotate_bypass_register_ir,
               dataout => rotate_in_reg
              );


   --Instantiate the shiftright input Register
    shiftright_clkval_ir <= "0000" WHEN ((shiftright_clock = "0") or (shiftright_clock = "none"))
                             ELSE "0001" WHEN (shiftright_clock = "1")
                             ELSE "0010" WHEN (shiftright_clock = "2")
                             ELSE "0011" WHEN (shiftright_clock = "3")
                             ELSE "0000" ;
    shiftright_aclrval_ir <= "0000" WHEN ((shiftright_clear = "0") or (shiftright_clear = "none"))
                              ELSE "0001" WHEN (shiftright_clear = "1")
                              ELSE "0010" WHEN (shiftright_clear = "2")
                              ELSE "0011" WHEN (shiftright_clear = "3")
                              ELSE "0000" ;
    shiftright_clk_ir <= '1' WHEN clk(conv_integer(shiftright_clkval_ir)) = '1' ELSE '0';
    shiftright_aclr_ir <= '1' WHEN (aclr(conv_integer(shiftright_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0' ;
    shiftright_sload_ir <= '1' WHEN ena(conv_integer(shiftright_clkval_ir)) = '1' ELSE '0';
    shiftright_bypass_register_ir <= '1' WHEN (shiftright_clock = "none") ELSE '0';
    shiftright_in <= shiftright;
     shiftright_input_register : stratixiii_mac_bit_register
       PORT MAP (
                 datain => shiftright_in,
                 clk => shiftright_clk_ir,
                 aclr => shiftright_aclr_ir,
                 sload => shiftright_sload_ir,
                 bypass_register => shiftright_bypass_register_ir,
                 dataout => shiftright_in_reg
              );

     --Instantiate the round input Register
    round_clkval_ir <= "0000" WHEN ((round_clock = "0") or (round_clock = "none"))
                         ELSE "0001" WHEN (round_clock = "1")
                         ELSE "0010" WHEN (round_clock = "2")
                         ELSE "0011" WHEN (round_clock = "3")
                         ELSE "0000" ;
    round_aclrval_ir <= "0000" WHEN ((round_clear = "0") or (round_clear = "none"))
                           ELSE "0001" WHEN (round_clear = "1")
                           ELSE "0010" WHEN (round_clear = "2")
                           ELSE "0011" WHEN (round_clear = "3")
                           ELSE "0000" ;
    round_clk_ir <= '1' WHEN clk(conv_integer(round_clkval_ir)) = '1' ELSE '0';
    round_aclr_ir <= '1' WHEN (aclr(conv_integer(round_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    round_sload_ir <= '1' WHEN ena(conv_integer(round_clkval_ir)) = '1' ELSE '0';
    round_bypass_register_ir <= '1' WHEN (round_clock = "none") ELSE '0';
    round_in <= round;
    round_input_register : stratixiii_mac_bit_register
      PORT MAP (
                datain => round_in,
                clk => round_clk_ir,
                aclr => round_aclr_ir,
                sload => round_sload_ir,
                bypass_register => round_bypass_register_ir,
                dataout => round_in_reg
                );

    --Instantiate the saturate input Register
    saturate_clkval_ir <= "0000" WHEN ((saturate_clock = "0") or (saturate_clock = "none"))
                           ELSE "0001" WHEN (saturate_clock = "1")
                           ELSE "0010" WHEN (saturate_clock = "2")
                           ELSE "0011" WHEN (saturate_clock = "3")
                           ELSE "0000" ;
    saturate_aclrval_ir <= "0000" WHEN ((saturate_clear = "0") or (saturate_clear = "none"))
                            ELSE "0001" WHEN (saturate_clear = "1")
                            ELSE "0010" WHEN (saturate_clear = "2")
                            ELSE "0011" WHEN (saturate_clear = "3")
                            ELSE "0000" ;
    saturate_clk_ir <= '1' WHEN clk(conv_integer(saturate_clkval_ir)) = '1' ELSE '0';
    saturate_aclr_ir <= '1' WHEN (aclr(conv_integer(saturate_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    saturate_sload_ir <= '1' WHEN ena(conv_integer(saturate_clkval_ir)) = '1' ELSE '0';
    saturate_bypass_register_ir <= '1' WHEN (saturate_clock = "none") ELSE '0';
    saturate_in <=  saturate;
    saturate_input_register : stratixiii_mac_bit_register
     PORT MAP (
               datain => saturate_in,
               clk => saturate_clk_ir,
               aclr => saturate_aclr_ir,
               sload => saturate_sload_ir,
               bypass_register => saturate_bypass_register_ir,
               dataout => saturate_in_reg
               );


    --Instantiate the roundchainout input Register
     roundchainout_clkval_ir <= "0000" WHEN ((roundchainout_clock = "0") or (roundchainout_clock = "none"))
                                 ELSE "0001" WHEN (roundchainout_clock = "1")
                                 ELSE "0010" WHEN (roundchainout_clock = "2")
                                 ELSE "0011" WHEN (roundchainout_clock = "3")
                                 ELSE "0000" ;
     roundchainout_aclrval_ir <= "0000" WHEN ((roundchainout_clear = "0") or (roundchainout_clear = "none"))
                                  ELSE "0001" WHEN (roundchainout_clear = "1")
                                  ELSE "0010" WHEN (roundchainout_clear = "2")
                                  ELSE "0011" WHEN (roundchainout_clear = "3")
                                  ELSE "0000" ;
     roundchainout_clk_ir <= '1' WHEN clk(conv_integer(roundchainout_clkval_ir)) = '1' ELSE '0';
     roundchainout_aclr_ir <= '1' WHEN (aclr(conv_integer(roundchainout_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
     roundchainout_sload_ir <= '1' WHEN ena(conv_integer(roundchainout_clkval_ir)) = '1' ELSE '0';
     roundchainout_bypass_register_ir <= '1' WHEN (roundchainout_clock = "none") ELSE '0';
     roundchainout_in <= roundchainout;
     roundchainout_input_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => roundchainout_in,
                  clk => roundchainout_clk_ir,
                  aclr => roundchainout_aclr_ir,
                  sload => roundchainout_sload_ir,
                  bypass_register => roundchainout_bypass_register_ir,
                  dataout => roundchainout_in_reg
                  );

       --Instantiate the saturatechainout input Register
    saturatechainout_clkval_ir <= "0000" WHEN ((saturatechainout_clock = "0") or (saturatechainout_clock = "none"))
                                  ELSE "0001" WHEN (saturatechainout_clock = "1")
                                  ELSE "0010" WHEN (saturatechainout_clock = "2")
                                  ELSE "0011" WHEN (saturatechainout_clock = "3")
                                  ELSE "0000" ;
    saturatechainout_aclrval_ir <= "0000" WHEN ((saturatechainout_clear = "0") or (saturatechainout_clear = "none"))
                                     ELSE "0001" WHEN (saturatechainout_clear = "1")
                                     ELSE "0010" WHEN (saturatechainout_clear = "2")
                                     ELSE "0011" WHEN (saturatechainout_clear = "3")
                                     ELSE "0000" ;
    saturatechainout_clk_ir <= '1' WHEN clk(conv_integer(saturatechainout_clkval_ir)) = '1' ELSE '0';
    saturatechainout_aclr_ir <= '1' WHEN (aclr(conv_integer(saturatechainout_aclrval_ir)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    saturatechainout_sload_ir <= '1' WHEN ena(conv_integer(saturatechainout_clkval_ir)) = '1' ELSE '0';
    saturatechainout_bypass_register_ir <= '1' WHEN (saturatechainout_clock = "none") ELSE '0';
    saturatechainout_in <= saturatechainout;
    saturatechainout_input_register : stratixiii_mac_bit_register
       PORT MAP (
                 datain => saturatechainout_in,
                 clk => saturatechainout_clk_ir,
                 aclr => saturatechainout_aclr_ir,
                 sload => saturatechainout_sload_ir,
                 bypass_register => saturatechainout_bypass_register_ir,
                 dataout => saturatechainout_in_reg
               );

    --Instantiate the First level adder interface and sign extension block
    sign <= signa_in_reg OR signb_in_reg ;
    fsa_interface : stratixiii_fsa_isse
        GENERIC MAP (
                     chainin_width => chainin_width,
                     dataa_width => dataa_width,
                     datab_width => datab_width,
                     datac_width => datac_width,
                     datad_width => datad_width,
                     operation_mode => operation_mode,
                     multa_signa_internally_grounded => multa_signa_internally_grounded,
                     multa_signb_internally_grounded => multa_signb_internally_grounded,
                     multb_signa_internally_grounded => multb_signa_internally_grounded,
                     multb_signb_internally_grounded => multb_signb_internally_grounded,
                     multc_signa_internally_grounded => multc_signa_internally_grounded,
                     multc_signb_internally_grounded => multc_signb_internally_grounded,
                     multd_signa_internally_grounded => multd_signa_internally_grounded,
                     multd_signb_internally_grounded => multd_signb_internally_grounded
                     )
        PORT MAP (
                  dataa => dataa,
                  datab => datab,
                  datac => datac,
                  datad => datad,
                  chainin => chainin,
                  signa => signa_in_reg,
                  signb => signb_in_reg,
                  dataa_out => dataa_fsa_in,
                  datab_out => datab_fsa_in,
                  datac_out => datac_fsa_in,
                  datad_out => datad_fsa_in,
                  chainin_out => chainin_coa_in,
                  operation => operation
                );

    --Instantiate First Stage Adder/Subtractor Unit0
    fsaunit0 : stratixiii_first_stage_add_sub
        GENERIC MAP (
                     dataa_width => dataa_width,
                     datab_width => datab_width,
                     fsa_mode => first_adder0_mode
                    )
        PORT MAP (
                  dataa => dataa_fsa_in,
                  datab => datab_fsa_in,
                  sign => sign,
                  operation => operation,
                  dataout => dataout_fsa0
                );


    --Instantiate First Stage Adder/Subtractor Unit1
    fsaunit1 : stratixiii_first_stage_add_sub
        GENERIC MAP (
                     dataa_width => datac_width,
                     datab_width => datad_width,
                     fsa_mode => first_adder1_mode
                    )
        PORT MAP (
                  dataa => datac_fsa_in,
                  datab => datad_fsa_in,
                  sign => sign,
                  operation => operation,
                  dataout => dataout_fsa1
                  );


    --Instantiate the zeroloopback pipeline Register
    zeroloopback_clkval_pip <= "0000" WHEN ((zeroloopback_pipeline_clock = "0") or (zeroloopback_pipeline_clock = "none"))
                                ELSE "0001" WHEN (zeroloopback_pipeline_clock = "1")
                                ELSE "0010" WHEN (zeroloopback_pipeline_clock = "2")
                                ELSE "0011" WHEN (zeroloopback_pipeline_clock = "3")
                                ELSE "0000" ;
    zeroloopback_aclrval_pip <= "0000" WHEN ((zeroloopback_pipeline_clear = "0") or (zeroloopback_pipeline_clear = "none"))
                                  ELSE "0001" WHEN (zeroloopback_pipeline_clear = "1")
                                  ELSE "0010" WHEN (zeroloopback_pipeline_clear = "2")
                                  ELSE "0011" WHEN (zeroloopback_pipeline_clear = "3")
                                  ELSE "0000" ;
    zeroloopback_clk_pip <= '1' WHEN clk(conv_integer(zeroloopback_clkval_pip)) = '1' ELSE '0';
    zeroloopback_aclr_pip <= '1' WHEN (aclr(conv_integer(zeroloopback_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    zeroloopback_sload_pip <= '1' WHEN ena(conv_integer(zeroloopback_clkval_pip)) = '1' ELSE '0';
    zeroloopback_bypass_register_pip <= '1' WHEN (zeroloopback_pipeline_clock = "none") ELSE '0';


    zeroloopback_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => zeroloopback_in_reg,
                  clk => zeroloopback_clk_pip,
                  aclr => zeroloopback_aclr_pip,
                  sload => zeroloopback_sload_pip,
                  bypass_register => zeroloopback_bypass_register_pip,
                  dataout => zeroloopback_pip_reg
                );
        --Instantiate the zeroacc pipeline Register
    zeroacc_clkval_pip <= "0000" WHEN ((zeroacc_pipeline_clock = "0") or (zeroacc_pipeline_clock = "none"))
                           ELSE "0001" WHEN (zeroacc_pipeline_clock = "1")
                           ELSE "0010" WHEN (zeroacc_pipeline_clock = "2")
                           ELSE "0011" WHEN (zeroacc_pipeline_clock = "3")
                           ELSE "0000" ;
    zeroacc_aclrval_pip <= "0000" WHEN ((zeroacc_pipeline_clear = "0") or (zeroacc_pipeline_clear = "none"))
                              ELSE "0001" WHEN (zeroacc_pipeline_clear = "1")
                              ELSE "0010" WHEN (zeroacc_pipeline_clear = "2")
                              ELSE "0011" WHEN (zeroacc_pipeline_clear = "3")
                              ELSE "0000" ;
    zeroacc_clk_pip <= '1' WHEN clk(conv_integer(zeroacc_clkval_pip)) = '1' ELSE '0';
    zeroacc_aclr_pip <= '1' WHEN (aclr(conv_integer(zeroacc_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    zeroacc_sload_pip <= '1' WHEN ena(conv_integer(zeroacc_clkval_pip)) = '1' ELSE '0';
    zeroacc_bypass_register_pip <= '1' WHEN (zeroacc_pipeline_clock = "none") ELSE '0';

    zeroacc_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => zeroacc_in_reg,
                  clk => zeroacc_clk_pip,
                  aclr => zeroacc_aclr_pip,
                  sload => zeroacc_sload_pip,
                  bypass_register => zeroacc_bypass_register_pip,
                  dataout => zeroacc_pip_reg
                );

    --Instantiate the signa pipeline Register
    signa_clkval_pip <= "0000" WHEN ((signa_pipeline_clock = "0") or (signa_pipeline_clock = "none"))
                         ELSE "0001" WHEN (signa_pipeline_clock = "1")
                         ELSE "0010" WHEN (signa_pipeline_clock = "2")
                         ELSE "0011" WHEN (signa_pipeline_clock = "3")
                         ELSE "0000" ;
    signa_aclrval_pip <= "0000" WHEN ((signa_pipeline_clear = "0") or (signa_pipeline_clear = "none"))
                          ELSE "0001" WHEN (signa_pipeline_clear = "1")
                          ELSE "0010" WHEN (signa_pipeline_clear = "2")
                          ELSE "0011" WHEN (signa_pipeline_clear = "3")
                          ELSE "0000" ;
    signa_clk_pip <= '1' WHEN clk(conv_integer(signa_clkval_pip)) = '1' ELSE '0';
    signa_aclr_pip <= '1' WHEN (aclr(conv_integer(signa_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    signa_sload_pip <= '1' WHEN ena(conv_integer(signa_clkval_pip)) = '1' ELSE '0';
    signa_bypass_register_pip <= '1' WHEN (signa_pipeline_clock = "none") ELSE '0';

    signa_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => signa_in_reg,
                  clk => signa_clk_pip,
                  aclr => signa_aclr_pip,
                  sload => signa_sload_pip,
                  bypass_register => signa_bypass_register_pip,
                  dataout => signa_pip_reg
                );

    --Instantiate the signb pipeline Register
    signb_clkval_pip <= "0000" WHEN ((signb_pipeline_clock = "0") or (signb_pipeline_clock = "none"))
                         ELSE "0001" WHEN (signb_pipeline_clock = "1")
                         ELSE "0010" WHEN (signb_pipeline_clock = "2")
                         ELSE "0011" WHEN (signb_pipeline_clock = "3")
                         ELSE "0000" ;
    signb_aclrval_pip <= "0000" WHEN ((signb_pipeline_clear = "0") or (signb_pipeline_clear = "none"))
                          ELSE "0001" WHEN (signb_pipeline_clear = "1")
                          ELSE "0010" WHEN (signb_pipeline_clear = "2")
                          ELSE "0011" WHEN (signb_pipeline_clear = "3")
                          ELSE "0000" ;
    signb_clk_pip <= '1' WHEN clk(conv_integer(signb_clkval_pip)) = '1' ELSE '0';
    signb_aclr_pip <= '1' WHEN (aclr(conv_integer(signb_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    signb_sload_pip <= '1' WHEN ena(conv_integer(signb_clkval_pip)) = '1' ELSE '0';
    signb_bypass_register_pip <= '1' WHEN (signb_pipeline_clock = "none") ELSE '0';

    signb_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => signb_in_reg,
                  clk => signb_clk_pip,
                  aclr => signb_aclr_pip,
                  sload => signb_sload_pip,
                  bypass_register => signb_bypass_register_pip,
                  dataout => signb_pip_reg
                );

    --Instantiate the rotate pipeline Register
    rotate_clkval_pip <= "0000" WHEN ((rotate_pipeline_clock = "0") or (rotate_pipeline_clock = "none"))
                          ELSE "0001" WHEN (rotate_pipeline_clock = "1")
                          ELSE "0010" WHEN (rotate_pipeline_clock = "2")
                          ELSE "0011" WHEN (rotate_pipeline_clock = "3")
                          ELSE "0000" ;
    rotate_aclrval_pip <= "0000" WHEN ((rotate_pipeline_clear = "0") or (rotate_pipeline_clear = "none"))
                            ELSE "0001" WHEN (rotate_pipeline_clear = "1")
                            ELSE "0010" WHEN (rotate_pipeline_clear = "2")
                            ELSE "0011" WHEN (rotate_pipeline_clear = "3")
                            ELSE "0000" ;
    rotate_clk_pip <= '1' WHEN clk(conv_integer(rotate_clkval_pip)) = '1' ELSE '0';
    rotate_aclr_pip <= '1' WHEN (aclr(conv_integer(rotate_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    rotate_sload_pip <= '1' WHEN ena(conv_integer(rotate_clkval_pip)) = '1' ELSE '0';
    rotate_bypass_register_pip <= '1' WHEN (rotate_pipeline_clock = "none") ELSE '0';

    rotate_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => rotate_in_reg,
                  clk => rotate_clk_pip,
                  aclr => rotate_aclr_pip,
                  sload => rotate_sload_pip,
                  bypass_register => rotate_bypass_register_pip,
                  dataout => rotate_pip_reg
                );

    --Instantiate the shiftright pipeline Register
    shiftright_clkval_pip <= "0000" WHEN ((shiftright_pipeline_clock = "0") or (shiftright_pipeline_clock = "none"))
                                ELSE "0001" WHEN (shiftright_pipeline_clock = "1")
                                ELSE "0010" WHEN (shiftright_pipeline_clock = "2")
                                ELSE "0011" WHEN (shiftright_pipeline_clock = "3")
                                ELSE "0000" ;
    shiftright_aclrval_pip <= "0000" WHEN ((shiftright_pipeline_clear = "0") or (shiftright_pipeline_clear = "none"))
                                ELSE "0001" WHEN (shiftright_pipeline_clear = "1")
                                ELSE "0010" WHEN (shiftright_pipeline_clear = "2")
                                ELSE "0011" WHEN (shiftright_pipeline_clear = "3")
                                ELSE "0000" ;
    shiftright_clk_pip <= '1' WHEN clk(conv_integer(shiftright_clkval_pip)) = '1' ELSE '0';
    shiftright_aclr_pip <= '1' WHEN (aclr(conv_integer(shiftright_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    shiftright_sload_pip <= '1' WHEN ena(conv_integer(shiftright_clkval_pip)) = '1' ELSE '0';
    shiftright_bypass_register_pip <= '1' WHEN (shiftright_pipeline_clock = "none") ELSE '0';

    shiftright_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => shiftright_in_reg,
                  clk => shiftright_clk_pip,
                  aclr => shiftright_aclr_pip,
                  sload => shiftright_sload_pip,
                  bypass_register => shiftright_bypass_register_pip,
                  dataout => shiftright_pip_reg
                 );

      --Instantiate the round pipeline Register
    round_clkval_pip <= "0000" WHEN ((round_pipeline_clock = "0") or (round_pipeline_clock = "none"))
                         ELSE "0001" WHEN (round_pipeline_clock = "1")
                         ELSE "0010" WHEN (round_pipeline_clock = "2")
                         ELSE "0011" WHEN (round_pipeline_clock = "3")
                         ELSE "0000" ;
    round_aclrval_pip <= "0000" WHEN ((round_pipeline_clear = "0") or (round_pipeline_clear = "none"))
                          ELSE "0001" WHEN (round_pipeline_clear = "1")
                          ELSE "0010" WHEN (round_pipeline_clear = "2")
                          ELSE "0011" WHEN (round_pipeline_clear = "3")
                          ELSE "0000" ;
    round_clk_pip <= '1' WHEN clk(conv_integer(round_clkval_pip)) = '1' ELSE '0';
    round_aclr_pip <= '1' WHEN (aclr(conv_integer(round_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    round_sload_pip <= '1' WHEN ena(conv_integer(round_clkval_pip)) = '1' ELSE '0';
    round_bypass_register_pip <= '1' WHEN (round_pipeline_clock = "none") ELSE '0';

    round_pipeline_register : stratixiii_mac_bit_register
     PORT MAP (
               datain => round_in_reg,
               clk => round_clk_pip,
               aclr => round_aclr_pip,
               sload => round_sload_pip,
               bypass_register => round_bypass_register_pip,
               dataout => round_pip_reg
             );

        --Instantiate the saturate pipeline Register
    saturate_clkval_pip <= "0000" WHEN ((saturate_pipeline_clock = "0") or (saturate_pipeline_clock = "none"))
                            ELSE "0001" WHEN (saturate_pipeline_clock = "1")
                            ELSE "0010" WHEN (saturate_pipeline_clock = "2")
                            ELSE "0011" WHEN (saturate_pipeline_clock = "3")
                            ELSE "0000" ;
    saturate_aclrval_pip <= "0000" WHEN ((saturate_pipeline_clear = "0") or (saturate_pipeline_clear = "none"))
                            ELSE "0001" WHEN (saturate_pipeline_clear = "1")
                            ELSE "0010" WHEN (saturate_pipeline_clear = "2")
                            ELSE "0011" WHEN (saturate_pipeline_clear = "3")
                            ELSE "0000" ;
    saturate_clk_pip <= '1' WHEN clk(conv_integer(saturate_clkval_pip)) = '1' ELSE '0';
    saturate_aclr_pip <= '1' WHEN (aclr(conv_integer(saturate_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    saturate_sload_pip <= '1' WHEN ena(conv_integer(saturate_clkval_pip)) = '1' ELSE '0';
    saturate_bypass_register_pip <= '1' WHEN (saturate_pipeline_clock = "none") ELSE '0';

    saturate_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => saturate_in_reg,
                  clk => saturate_clk_pip,
                  aclr => saturate_aclr_pip,
                  sload => saturate_sload_pip,
                  bypass_register => saturate_bypass_register_pip,
                  dataout => saturate_pip_reg
                );

    --Instantiate the roundchainout pipeline Register
    roundchainout_clkval_pip <= "0000" WHEN ((roundchainout_pipeline_clock = "0") or (roundchainout_pipeline_clock = "none"))
                                 ELSE "0001" WHEN (roundchainout_pipeline_clock = "1")
                                 ELSE "0010" WHEN (roundchainout_pipeline_clock = "2")
                                 ELSE "0011" WHEN (roundchainout_pipeline_clock = "3")
                                 ELSE "0000" ;
    roundchainout_aclrval_pip <= "0000" WHEN ((roundchainout_pipeline_clear = "0") or (roundchainout_pipeline_clear = "none"))
                                  ELSE "0001" WHEN (roundchainout_pipeline_clear = "1")
                                  ELSE "0010" WHEN (roundchainout_pipeline_clear = "2")
                                  ELSE "0011" WHEN (roundchainout_pipeline_clear = "3")
                                  ELSE "0000" ;
    roundchainout_clk_pip <= '1' WHEN clk(conv_integer(roundchainout_clkval_pip)) = '1' ELSE '0';
    roundchainout_aclr_pip <= '1' WHEN (aclr(conv_integer(roundchainout_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    roundchainout_sload_pip <= '1' WHEN ena(conv_integer(roundchainout_clkval_pip)) = '1' ELSE '0';
    roundchainout_bypass_register_pip <= '1' WHEN (roundchainout_pipeline_clock = "none") ELSE '0';

    roundchainout_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => roundchainout_in_reg,
                  clk => roundchainout_clk_pip,
                  aclr => roundchainout_aclr_pip,
                  sload => roundchainout_sload_pip,
                  bypass_register => roundchainout_bypass_register_pip,
                  dataout => roundchainout_pip_reg
                 );

        --Instantiate the saturatechainout pipeline Register
    saturatechainout_clkval_pip <= "0000" WHEN ((saturatechainout_pipeline_clock = "0") or (saturatechainout_pipeline_clock = "none"))
                                    ELSE "0001" WHEN (saturatechainout_pipeline_clock = "1")
                                    ELSE "0010" WHEN (saturatechainout_pipeline_clock = "2")
                                    ELSE "0011" WHEN (saturatechainout_pipeline_clock = "3")
                                    ELSE "0000" ;
    saturatechainout_aclrval_pip <= "0000" WHEN ((saturatechainout_pipeline_clear = "0") or (saturatechainout_pipeline_clear = "none"))
                                     ELSE "0001" WHEN (saturatechainout_pipeline_clear = "1")
                                     ELSE "0010" WHEN (saturatechainout_pipeline_clear = "2")
                                     ELSE "0011" WHEN (saturatechainout_pipeline_clear = "3")
                                     ELSE "0000" ;
    saturatechainout_clk_pip <= '1' WHEN clk(conv_integer(saturatechainout_clkval_pip)) = '1' ELSE '0';
    saturatechainout_aclr_pip <= '1' WHEN (aclr(conv_integer(saturatechainout_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    saturatechainout_sload_pip <= '1' WHEN ena(conv_integer(saturatechainout_clkval_pip)) = '1' ELSE '0';
    saturatechainout_bypass_register_pip <= '1' WHEN (saturatechainout_pipeline_clock = "none") ELSE '0';

    saturatechainout_pipeline_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => saturatechainout_in_reg,
                  clk => saturatechainout_clk_pip,
                  aclr => saturatechainout_aclr_pip,
                  sload => saturatechainout_sload_pip,
                  bypass_register => saturatechainout_bypass_register_pip,
                  dataout => saturatechainout_pip_reg
                );

        -- Instantiate fsa0 dataout pipline register
    fsa_pip_datain1 <= dataa_fsa_in WHEN (operation_mode = "output_only") ELSE dataout_fsa0;
    fsa0_clkval_pip <= "0000" WHEN ((first_adder0_clock = "0") or (first_adder0_clock = "none"))
                         ELSE "0001" WHEN (first_adder0_clock = "1")
                         ELSE "0010" WHEN (first_adder0_clock = "2")
                         ELSE "0011" WHEN (first_adder0_clock = "3")
                         ELSE "0000" ;
    fsa0_aclrval_pip <= "0000" WHEN ((first_adder0_clear = "0") or (first_adder0_clear = "none"))
                         ELSE "0001" WHEN (first_adder0_clear = "1")
                         ELSE "0010" WHEN (first_adder0_clear = "2")
                         ELSE "0011" WHEN (first_adder0_clear = "3")
                         ELSE "0000" ;
    fsa0_clk_pip <= '1' WHEN clk(conv_integer(fsa0_clkval_pip)) = '1' ELSE '0';
    fsa0_aclr_pip <= '1' WHEN (aclr(conv_integer(fsa0_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    fsa0_sload_pip <= '1' WHEN ena(conv_integer(fsa0_clkval_pip)) = '1' ELSE '0';
    fsa0_bypass_register_pip <= '1' WHEN (first_adder0_clock = "none") ELSE '0';


    fsa0_pipeline_register : stratixiii_mac_register
        GENERIC MAP (
                     data_width => 72
                     )
        PORT MAP (
                  datain => fsa_pip_datain1,
                  clk => fsa0_clk_pip,
                  aclr => fsa0_aclr_pip,
                  sload => fsa0_sload_pip,
                  bypass_register => fsa0_bypass_register_pip,
                  dataout => fsa0_pip_reg
                  );

      -- Instantiate fsa1 dataout pipline register
    fsa1_clkval_pip <= "0000" WHEN ((first_adder1_clock = "0") or (first_adder1_clock = "none"))
                        ELSE "0001" WHEN (first_adder1_clock = "1")
                        ELSE "0010" WHEN (first_adder1_clock = "2")
                        ELSE "0011" WHEN (first_adder1_clock = "3")
                        ELSE "0000" ;
    fsa1_aclrval_pip <= "0000" WHEN ((first_adder1_clear = "0") or (first_adder1_clear = "none"))
                         ELSE "0001" WHEN (first_adder1_clear = "1")
                         ELSE "0010" WHEN (first_adder1_clear = "2")
                         ELSE "0011" WHEN (first_adder1_clear = "3")
                         ELSE "0000" ;
    fsa1_clk_pip <= '1' WHEN clk(conv_integer(fsa1_clkval_pip)) = '1' ELSE '0';
    fsa1_aclr_pip <= '1' WHEN (aclr(conv_integer(fsa1_aclrval_pip)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    fsa1_sload_pip <= '1' WHEN ena(conv_integer(fsa1_clkval_pip)) = '1' ELSE '0';
    fsa1_bypass_register_pip <= '1' WHEN (first_adder1_clock = "none") ELSE '0';

    fsa1_pipeline_register : stratixiii_mac_register
        GENERIC MAP (
                     data_width => 72
                     )
        PORT MAP (
                  datain => dataout_fsa1,
                  clk => fsa1_clk_pip,
                  aclr => fsa1_aclr_pip,
                  sload => fsa1_sload_pip,
                  bypass_register => fsa1_bypass_register_pip,
                  dataout => fsa1_pip_reg
                );

    --Instantiate the second level adder/accumulator block
    ssa_accum_in <= rs_dataout_out_reg WHEN (NOT zeroacc_pip_reg) = '1' ELSE (others => '0');
    ssa_sign <= signa_pip_reg OR signb_pip_reg ;

    ssa_unit : stratixiii_second_stage_add_accum
        GENERIC MAP (
                     dataa_width => dataa_width + 1,
                     datab_width => datac_width + 1,
                     ssa_mode => acc_adder_operation
                    )
        PORT MAP (
                  dataa => fsa0_pip_reg,
                  datab => fsa1_pip_reg,
                  accumin => ssa_accum_in,
                  sign => ssa_sign,
                  operation => operation,
                  dataout => ssa_dataout,
                  overflow => ssa_overflow
                );


    -- Instantiate round and saturation block
    rs_datain <= fsa0_pip_reg when ((operation_mode = "output_only") or (operation_mode = "one_level_adder")or(operation_mode = "loopback"))
                 ELSE ssa_dataout ;

    ssa_datain_width <= CONV_STD_LOGIC_VECTOR(dataa_width + 8,8) when ((operation_mode = "accumulator") or(operation_mode = "accumulator_chain_out") or(operation_mode = "two_level_adder_chain_out"))
                ELSE CONV_STD_LOGIC_VECTOR(dataa_width +2,8) when(operation_mode = "two_level_adder")
                ELSE CONV_STD_LOGIC_VECTOR(dataa_width + datab_width,8) when ((operation_mode = "shift" ) or (operation_mode = "36_bit_multiply" ))
                ELSE CONV_STD_LOGIC_VECTOR(dataa_width + 8,8) when ((operation_mode = "double" ))
                ELSE CONV_STD_LOGIC_VECTOR(dataa_width,8);




    rs_block : stratixiii_round_saturate_block
        GENERIC MAP (
                     dataa_width => dataa_width,
                     datab_width => datab_width,
                     operation_mode => operation_mode,
                     round_mode => round_mode,
                     saturate_mode => saturate_mode,
                     saturate_width => saturate_width,
                     round_width => round_width
                    )
        PORT MAP (
                  datain => rs_datain,
                  round => round_pip_reg,
                  saturate => saturate_pip_reg,
                  signa => signa_pip_reg,
                  signb => signb_pip_reg,
                  datain_width => ssa_datain_width,
                  dataout => rs_dataout,
                  saturationoverflow => rs_saturation_overflow
                );
    --Instantiate the zeroloopback output Register
    zeroloopback_clkval_or <= "0000" WHEN ((zeroloopback_output_clock = "0") or (zeroloopback_output_clock = "none"))
                               ELSE "0001" WHEN (zeroloopback_output_clock = "1")
                               ELSE "0010" WHEN (zeroloopback_output_clock = "2")
                               ELSE "0011" WHEN (zeroloopback_output_clock = "3")
                               ELSE "0000" ;
    zeroloopback_aclrval_or <= "0000" WHEN ((zeroloopback_output_clear = "0") or (zeroloopback_output_clear = "none"))
                               ELSE "0001" WHEN (zeroloopback_output_clear = "1")
                               ELSE "0010" WHEN (zeroloopback_output_clear = "2")
                               ELSE "0011" WHEN (zeroloopback_output_clear = "3")
                               ELSE "0000" ;
    zeroloopback_clk_or <= '1' WHEN clk(conv_integer(zeroloopback_clkval_or)) = '1' ELSE '0';
    zeroloopback_aclr_or <= '1' WHEN (aclr(conv_integer(zeroloopback_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    zeroloopback_sload_or <= '1' WHEN ena(conv_integer(zeroloopback_clkval_or)) = '1' ELSE '0';
    zeroloopback_bypass_register_or <= '1' WHEN (zeroloopback_output_clock = "none") ELSE '0';

    zeroloopback_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => zeroloopback_pip_reg,
                  clk => zeroloopback_clk_or,
                  aclr => zeroloopback_aclr_or,
                  sload => zeroloopback_sload_or,
                  bypass_register => zeroloopback_bypass_register_or,
                  dataout => zeroloopback_out_reg
                );

    --Instantiate the zerochainout output Register

    zerochainout_clkval_or <= "0000" WHEN ((zerochainout_output_clock = "0") or (zerochainout_output_clock = "none"))
                               ELSE "0001" WHEN (zerochainout_output_clock = "1")
                               ELSE "0010" WHEN (zerochainout_output_clock = "2")
                               ELSE "0011" WHEN (zerochainout_output_clock = "3")
                               ELSE "0000" ;
    zerochainout_aclrval_or <= "0000" WHEN ((zerochainout_output_clear = "0") or (zerochainout_output_clear = "none"))
                               ELSE "0001" WHEN (zerochainout_output_clear = "1")
                               ELSE "0010" WHEN (zerochainout_output_clear = "2")
                               ELSE "0011" WHEN (zerochainout_output_clear = "3")
                               ELSE "0000" ;
    zerochainout_clk_or <= '1' WHEN clk(conv_integer(zerochainout_clkval_or)) = '1' ELSE '0';
    zerochainout_aclr_or <= '1' WHEN (aclr(conv_integer(zerochainout_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    zerochainout_sload_or <= '1' WHEN ena(conv_integer(zerochainout_clkval_or)) = '1' ELSE '0';
    zerochainout_bypass_register_or <= '1' WHEN (zerochainout_output_clock = "none") ELSE '0';

    zerochainout_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => zerochainout,
                  clk => zerochainout_clk_or,
                  aclr => zerochainout_aclr_or,
                  sload => zerochainout_sload_or,
                  bypass_register => zerochainout_bypass_register_or,
                  dataout => zerochainout_out_reg
                 );


 -- Instantiate Round_Saturate dataout output register
    rs_dataout_clkval_or_co <= "0000" WHEN ((second_adder_clock = "0") or (second_adder_clock = "none"))
                             ELSE "0001" WHEN (second_adder_clock = "1")
                             ELSE "0010" WHEN (second_adder_clock = "2")
                             ELSE "0011" WHEN (second_adder_clock = "3")
                             ELSE "0000" ;
    rs_dataout_aclrval_or_co <= "0000" WHEN ((second_adder_clear = "0") or (second_adder_clear = "none"))
                              ELSE "0001" WHEN (second_adder_clear = "1")
                              ELSE "0010" WHEN (second_adder_clear = "2")
                              ELSE "0011" WHEN (second_adder_clear = "3")
                              ELSE "0000" ;

    rs_dataout_clkval_or_o <= "0000" WHEN ((output_clock = "0") or (output_clock = "none"))
                             ELSE "0001" WHEN (output_clock = "1")
                             ELSE "0010" WHEN (output_clock = "2")
                             ELSE "0011" WHEN (output_clock = "3")
                             ELSE "0000" ;
    rs_dataout_aclrval_or_o <= "0000" WHEN ((output_clear = "0") or (output_clear = "none"))
                              ELSE "0001" WHEN (output_clear = "1")
                              ELSE "0010" WHEN (output_clear = "2")
                              ELSE "0011" WHEN (output_clear = "3")
                              ELSE "0000" ;
     rs_dataout_aclrval_or <=  rs_dataout_aclrval_or_co WHEN ((operation_mode = "two_level_adder_chain_out") or  (operation_mode = "accumulator_chain_out" ))
                               ELSE    rs_dataout_aclrval_or_o;

     rs_dataout_clkval_or <=  rs_dataout_clkval_or_co WHEN ((operation_mode = "two_level_adder_chain_out") or  (operation_mode = "accumulator_chain_out" ))
                               ELSE    rs_dataout_clkval_or_o;

     rs_dataout_bypass_register_or_co <= '1' WHEN (second_adder_clock = "none") ELSE '0';
     rs_dataout_bypass_register_or_o <= '1' WHEN (output_clock = "none") ELSE '0';

    rs_dataout_clk_or <= '1' WHEN clk(conv_integer(rs_dataout_clkval_or)) = '1' ELSE '0';
    rs_dataout_aclr_or <= '1' WHEN (aclr(conv_integer(rs_dataout_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    rs_dataout_sload_or <= '1' WHEN ena(conv_integer(rs_dataout_clkval_or)) = '1' ELSE '0';
    rs_dataout_bypass_register_or <= rs_dataout_bypass_register_or_co WHEN ((operation_mode = "two_level_adder_chain_out") or  (operation_mode = "accumulator_chain_out" ))
                                      ELSE   rs_dataout_bypass_register_or_o;

    rs_dataout_in <= ssa_dataout WHEN ((operation_mode = "36_bit_multiply") OR (operation_mode = "shift")) ELSE rs_dataout_of;

    rs_dataout_output_register : stratixiii_mac_register
        GENERIC MAP (
                     data_width => 72
                    )
        PORT MAP (
                  datain => rs_dataout_in,
                  clk => rs_dataout_clk_or,
                  aclr => rs_dataout_aclr_or,
                  sload => rs_dataout_sload_or,
                  bypass_register => rs_dataout_bypass_register_or,
                  dataout => rs_dataout_out_reg
                );

    -- Instantiate Round_Saturate saturation_overflow output register

    rs_saturation_overflow_in <= rs_saturation_overflow WHEN (saturate_pip_reg = '1') ELSE ssa_overflow;
    rs_saturation_overflow_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => rs_saturation_overflow_in,
                  clk => rs_dataout_clk_or,
                  aclr => rs_dataout_aclr_or,
                  sload => rs_dataout_sload_or,
                  bypass_register => rs_dataout_bypass_register_or,
                  dataout => rs_saturation_overflow_out_reg
                 );


    --Instantiate the rotate output Register
    rotate_clkval_or <= "0000" WHEN ((rotate_output_clock = "0") or (rotate_output_clock = "none"))
                          ELSE "0001" WHEN (rotate_output_clock = "1")
                          ELSE "0010" WHEN (rotate_output_clock = "2")
                          ELSE "0011" WHEN (rotate_output_clock = "3")
                          ELSE "0000" ;
    rotate_aclrval_or <= "0000" WHEN ((rotate_output_clear = "0") or (rotate_output_clear = "none"))
                           ELSE "0001" WHEN (rotate_output_clear = "1")
                           ELSE "0010" WHEN (rotate_output_clear = "2")
                           ELSE "0011" WHEN (rotate_output_clear = "3")
                           ELSE "0000" ;
    rotate_clk_or <= '1' WHEN clk(conv_integer(rotate_clkval_or)) = '1' ELSE '0';
    rotate_aclr_or <= '1' WHEN (aclr(conv_integer(rotate_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    rotate_sload_or <= '1' WHEN ena(conv_integer(rotate_clkval_or)) = '1' ELSE '0';
    rotate_bypass_register_or <= '1' WHEN (rotate_output_clock = "none") ELSE '0';

    rotate_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => rotate_pip_reg,
                  clk => rotate_clk_or,
                  aclr => rotate_aclr_or,
                  sload => rotate_sload_or,
                  bypass_register => rotate_bypass_register_or,
                  dataout => rotate_out_reg
                );

       --Instantiate the shiftright output Register
    shiftright_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => shiftright_pip_reg,
                  clk => shiftright_clk_or,
                  aclr => shiftright_aclr_or,
                  sload => shiftright_sload_or,
                  bypass_register => shiftright_bypass_register_or,
                  dataout => shiftright_out_reg
                );

    shiftright_clkval_or <= "0000" WHEN ((shiftright_output_clock = "0") or (shiftright_output_clock = "none"))
                              ELSE "0001" WHEN (shiftright_output_clock = "1")
                              ELSE "0010" WHEN (shiftright_output_clock = "2")
                              ELSE "0011" WHEN (shiftright_output_clock = "3")
                              ELSE "0000" ;
    shiftright_aclrval_or <= "0000" WHEN ((shiftright_output_clear = "0") or (shiftright_output_clear = "none"))
                                ELSE "0001" WHEN (shiftright_output_clear = "1")
                                ELSE "0010" WHEN (shiftright_output_clear = "2")
                                ELSE "0011" WHEN (shiftright_output_clear = "3")
                                ELSE "0000" ;
    shiftright_clk_or <= '1' WHEN clk(conv_integer(shiftright_clkval_or)) = '1' ELSE '0';
    shiftright_aclr_or <= '1' WHEN (aclr(conv_integer(shiftright_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    shiftright_sload_or <= '1' WHEN ena(conv_integer(shiftright_clkval_or)) = '1' ELSE '0';
    shiftright_bypass_register_or <= '1' WHEN (shiftright_output_clock = "none") ELSE '0';

    --Instantiate the roundchainout output Register
    roundchainout_clkval_or <= "0000" WHEN ((roundchainout_output_clock = "0") or (roundchainout_output_clock = "none"))
                                ELSE "0001" WHEN (roundchainout_output_clock = "1")
                                ELSE "0010" WHEN (roundchainout_output_clock = "2")
                                ELSE "0011" WHEN (roundchainout_output_clock = "3")
                                ELSE "0000" ;
    roundchainout_aclrval_or <= "0000" WHEN ((roundchainout_output_clear = "0") or (roundchainout_output_clear = "none"))
                                   ELSE "0001" WHEN (roundchainout_output_clear = "1")
                                   ELSE "0010" WHEN (roundchainout_output_clear = "2")
                                   ELSE "0011" WHEN (roundchainout_output_clear = "3")
                                   ELSE "0000" ;
    roundchainout_clk_or <= '1' WHEN clk(conv_integer(roundchainout_clkval_or)) = '1' ELSE '0';
    roundchainout_aclr_or <= '1' WHEN (aclr(conv_integer(roundchainout_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    roundchainout_sload_or <= '1' WHEN ena(conv_integer(roundchainout_clkval_or)) = '1' ELSE '0';
    roundchainout_bypass_register_or <= '1' WHEN (roundchainout_output_clock = "none") ELSE '0';

    roundchainout_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => roundchainout_pip_reg,
                  clk => roundchainout_clk_or,
                  aclr => roundchainout_aclr_or,
                  sload => roundchainout_sload_or,
                  bypass_register => roundchainout_bypass_register_or,
                  dataout => roundchainout_out_reg
                );


    --Instantiate the saturatechainout output Register
    saturatechainout_clkval_or <= "0000" WHEN ((saturatechainout_output_clock = "0") or (saturatechainout_output_clock = "none"))
                                    ELSE "0001" WHEN (saturatechainout_output_clock = "1")
                                    ELSE "0010" WHEN (saturatechainout_output_clock = "2")
                                    ELSE "0011" WHEN (saturatechainout_output_clock = "3")
                                    ELSE "0000" ;
    saturatechainout_aclrval_or <= "0000" WHEN ((saturatechainout_output_clear = "0") or (saturatechainout_output_clear = "none"))
                                      ELSE "0001" WHEN (saturatechainout_output_clear = "1")
                                      ELSE "0010" WHEN (saturatechainout_output_clear = "2")
                                      ELSE "0011" WHEN (saturatechainout_output_clear = "3")
                                      ELSE "0000" ;
    saturatechainout_clk_or <= '1' WHEN clk(conv_integer(saturatechainout_clkval_or)) = '1' ELSE '0';
    saturatechainout_aclr_or <= '1' WHEN (aclr(conv_integer(saturatechainout_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    saturatechainout_sload_or <= '1' WHEN ena(conv_integer(saturatechainout_clkval_or)) = '1' ELSE '0';
    saturatechainout_bypass_register_or <= '1' WHEN (saturatechainout_output_clock = "none") ELSE '0';

    saturatechainout_output_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => saturatechainout_pip_reg,
                  clk => saturatechainout_clk_or,
                  aclr => saturatechainout_aclr_or,
                  sload => saturatechainout_sload_or,
                  bypass_register => saturatechainout_bypass_register_or,
                  dataout => saturatechainout_out_reg
                );

    --Instantiate the Carry chainout Adder
    chainout_adder : stratixiii_carry_chain_adder
        PORT MAP (
                  dataa => rs_dataout_out_reg,
                  datab => chainin_coa_in,
                  dataout => coa_dataout
                );


    --Instantiate the carry chainout adder RS Block



    coa_rs_block : stratixiii_round_saturate_block
        GENERIC MAP (
                     dataa_width => dataa_width,
                     datab_width => datab_width,
                     operation_mode => operation_mode,
                     round_mode => round_chain_out_mode,
                     saturate_mode => saturate_chain_out_mode,
                     saturate_width => saturate_chain_out_width,
                     round_width => round_chain_out_width
                    )
        PORT MAP (
                  datain => coa_dataout,
                  round => roundchainout_out_reg,
                  saturate => saturatechainout_out_reg,
                  signa => signa_pip_reg,
                  signb => signb_pip_reg,
                  datain_width => ssa_datain_width,
                  dataout => coa_rs_dataout,
                  saturationoverflow => coa_rs_saturation_overflow
                );

        --Instantiate the rs_saturation_overflow output register (after COA)
    coa_reg_clkval_or <= "0000" WHEN ((output_clock = "0") or (output_clock = "none"))
                         ELSE "0001" WHEN (output_clock = "1")
                         ELSE "0010" WHEN (output_clock = "2")
                         ELSE "0011" WHEN (output_clock = "3")
                         ELSE "0000" ;
    coa_reg_aclrval_or <= "0000" WHEN ((output_clear = "0") or (output_clear = "none"))
                          ELSE "0001" WHEN (output_clear = "1")
                          ELSE "0010" WHEN (output_clear = "2")
                          ELSE "0011" WHEN (output_clear = "3")
                          ELSE "0000" ;
    coa_reg_clk_or <= '1' WHEN clk(conv_integer(coa_reg_clkval_or)) = '1' ELSE '0';
    coa_reg_aclr_or <= '1' WHEN (aclr(conv_integer(coa_reg_aclrval_or)) OR NOT devclrn OR NOT devpor) = '1' ELSE '0';
    coa_reg_sload_or <= '1' WHEN ena(conv_integer(coa_reg_clkval_or)) = '1' ELSE '0';
    coa_reg_bypass_register_or <= '1' WHEN (output_clock = "none") ELSE '0';

    coa_rs_saturation_overflow_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => rs_saturation_overflow_out_reg,
                  clk => coa_reg_clk_or,
                  aclr => coa_reg_aclr_or,
                  sload => coa_reg_sload_or,
                  bypass_register => '1',
                  dataout => coa_rs_saturation_overflow_out_reg
                 );


    --Instantiate the rs_saturationchainout_overflow output register
    coa_rs_saturationchainout_overflow_register : stratixiii_mac_bit_register
        PORT MAP (
                  datain => coa_rs_saturation_overflow,
                  clk => coa_reg_clk_or,
                  aclr => coa_reg_aclr_or,
                  sload => coa_reg_sload_or,
                  bypass_register => coa_reg_bypass_register_or,
                  dataout => coa_rs_saturationchainout_overflow_out_reg
                 );


    -- Instantiate the coa_rs_dataout output register
    coa_rs_dataout_register : stratixiii_mac_register
        GENERIC MAP (
                     data_width => 72
                    )
        PORT MAP (
                  datain => coa_rs_dataout,
                  clk => coa_reg_clk_or,
                  aclr => coa_reg_aclr_or,
                  sload => coa_reg_sload_or,
                  bypass_register => coa_reg_bypass_register_or,
                  dataout => coa_rs_dataout_out_reg
                );

    --Instantiate the shift/Rotate Unit
    shift_rot_unit : stratixiii_rotate_shift_block
        GENERIC MAP (
                     dataa_width => dataa_width,
                     datab_width => datab_width
                    )
        PORT MAP (
                  datain => rs_dataout_out_reg,
                  rotate => rotate_out_reg,
                  shiftright => shiftright_out_reg,
                  signa => signa_pip_reg,
                  signb => signb_pip_reg,
                  dataout => dataout_shift_rot
                 );

    --Assign the dataout depENDing on the mode of operation
    dataout_tmp <=  coa_rs_dataout_out_reg when((operation_mode = "accumulator_chain_out")or(operation_mode = "two_level_adder_chain_out"))
                              ELSE dataout_shift_rot when (operation_mode = "shift")
                              ELSE rs_dataout_out_reg;


    --Assign the loopbackout for loopback mode
    loopbackout_tmp <= rs_dataout_out_reg when((operation_mode = "loopback") and (zeroloopback_out_reg = '0'))
                          ELSE (others => '0');

    --Assign the saturation overflow output
    saturation_overflow_tmp <= rs_saturation_overflow_out_reg when((operation_mode = "accumulator") or(operation_mode = "two_level_adder"))
                            ELSE coa_rs_saturation_overflow_out_reg when((operation_mode = "accumulator_chain_out")or(operation_mode = "two_level_adder_chain_out"))
                            ELSE '0';

    --Assign the saturationchainout overflow output
    saturationchainout_overflow_tmp <= coa_rs_saturationchainout_overflow_out_reg when((operation_mode = "accumulator_chain_out") or(operation_mode = "two_level_adder_chain_out"))
                                                ELSE '0';

    dataout <= (others => '0') WHEN (((operation_mode = "accumulator_chain_out")or(operation_mode = "two_level_adder_chain_out")) and (zerochainout_out_reg = '1'))
                ELSE dataout_tmp;
    loopbackout <= loopbackout_tmp(35 downto 18);
    overflow <= saturation_overflow_tmp;
    saturatechainoutoverflow <= saturationchainout_overflow_tmp;
 END arch;
----------------------------------------------------------------------------
-- Module Name     : stratixiii_io_pad
-- Description     : Simulation model for stratixiii IO pad
----------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

ENTITY stratixiii_io_pad IS
    GENERIC (
        lpm_type                       :  string := "stratixiii_io_pad");    
    PORT (
        --INPUT PORTS

        padin                   : IN std_logic := '0';   -- Input Pad
        --OUTPUT PORTS

        padout                  : OUT std_logic);   -- Output Pad
END stratixiii_io_pad;

ARCHITECTURE arch OF stratixiii_io_pad IS

BEGIN
    padout <= padin;    
END arch;
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixiii_mn_cntr
--
-- Description : Timing simulation model for the M and N counter. This is a
--               common model for the input counter and the loop feedback
--               counter of the StratixII PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY stratixiii_mn_cntr is
    PORT(  clk           : IN std_logic;
            reset         : IN std_logic := '0';
            cout          : OUT std_logic;
            initial_value : IN integer := 1;
            modulus       : IN integer := 1;
            time_delay    : IN integer := 0
        );
END stratixiii_mn_cntr;

ARCHITECTURE behave of stratixiii_mn_cntr is
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

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixiii_scale_cntr
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

ENTITY stratixiii_scale_cntr is
    PORT(   clk            : IN std_logic;
            reset          : IN std_logic := '0';
            initial        : IN integer := 1;
            high           : IN integer := 1;
            low            : IN integer := 1;
            mode           : IN string := "bypass";
            ph_tap         : IN integer := 0;
            cout           : OUT std_logic
        );
END stratixiii_scale_cntr;

ARCHITECTURE behave of stratixiii_scale_cntr is
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

--BEGIN MF PORTING DELETE
--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixiii_pll_reg
--
-- Description : Simulation model for a simple DFF.
--               This is required for the generation of the bit slip-signals.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY stratixiii_pll_reg is
    PORT(   clk : in std_logic;
            ena : in std_logic := '1';
            d : in std_logic;
            clrn : in std_logic := '1';
            prn : in std_logic := '1';
            q : out std_logic
        );
end stratixiii_pll_reg;

ARCHITECTURE behave of stratixiii_pll_reg is
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
--END MF PORTING DELETE
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratixiii_pll
--
-- Description : Timing simulation model for the StratixII PLL.
--               In the functional mode, it is also the model for the altpll
--               megafunction.
--
-- Limitations : Does not support Spread Spectrum and Bandwidth.
--
-- Outputs     : Up to 10 output clocks, each defined by its own set of
--               parameters. Locked output (active high) indicates when the
--               PLL locks. clkbad and activeclock are used for
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
USE work.stratixiii_atom_pack.all;
USE work.stratixiii_pllpack.all;
USE work.stratixiii_mn_cntr;
USE work.stratixiii_scale_cntr;
USE work.stratixiii_dffe;
USE work.stratixiii_pll_reg;

-- New Features : The list below outlines key new features in STRATIXIII:
--                1. Dynamic Phase Reconfiguration
--                2. Dynamic PLL Reconfiguration (different protocol)
--                3. More output counters

ENTITY stratixiii_pll is
    GENERIC (
        operation_mode              : string := "normal";
        pll_type                    : string := "auto";  -- AUTO/FAST/ENHANCED/LEFT_RIGHT/TOP_BOTTOM
        compensate_clock            : string := "clock0";
        
        inclk0_input_frequency      : integer := 0;
        inclk1_input_frequency      : integer := 0;
        
        self_reset_on_loss_lock     : string  := "off";
        switch_over_type            : string  := "auto";
        switch_over_counter         : integer := 1;
        enable_switch_over_counter  : string := "off";

        dpa_multiply_by : integer := 0;
        dpa_divide_by   : integer := 0;
        dpa_divider     : integer := 0;
        
        bandwidth                    : integer := 0;
        bandwidth_type               : string  := "auto";
        use_dc_coupling              : string  := "false";

        
        
        lock_c                      : integer := 4;
        sim_gate_lock_device_behavior : string := "off";
        lock_high                   : integer := 0;
        lock_low                    : integer := 0;
        lock_window_ui              : string := "0.05";
        lock_window                 : time := 5 ps;
        test_bypass_lock_detect     : string := "off";
        

        clk0_output_frequency       : integer := 0;
        clk0_multiply_by            : integer := 0;
        clk0_divide_by              : integer := 0;
        clk0_phase_shift            : string := "0";
        clk0_duty_cycle             : integer := 50;

        clk1_output_frequency       : integer := 0;
        clk1_multiply_by            : integer := 0;
        clk1_divide_by              : integer := 0;
        clk1_phase_shift            : string := "0";
        clk1_duty_cycle             : integer := 50;

        clk2_output_frequency       : integer := 0;
        clk2_multiply_by            : integer := 0;
        clk2_divide_by              : integer := 0;
        clk2_phase_shift            : string := "0";
        clk2_duty_cycle             : integer := 50;

        clk3_output_frequency       : integer := 0;
        clk3_multiply_by            : integer := 0;
        clk3_divide_by              : integer := 0;
        clk3_phase_shift            : string := "0";
        clk3_duty_cycle             : integer := 50;

        clk4_output_frequency       : integer := 0;
        clk4_multiply_by            : integer := 0;
        clk4_divide_by              : integer := 0;
        clk4_phase_shift            : string := "0";
        clk4_duty_cycle             : integer := 50;

        clk5_output_frequency       : integer := 0;
        clk5_multiply_by            : integer := 0;
        clk5_divide_by              : integer := 0;
        clk5_phase_shift            : string := "0";
        clk5_duty_cycle             : integer := 50;
        
        clk6_output_frequency       : integer := 0;
        clk6_multiply_by            : integer := 0;
        clk6_divide_by              : integer := 0;
        clk6_phase_shift            : string := "0";
        clk6_duty_cycle             : integer := 50;
        
        clk7_output_frequency       : integer := 0;
        clk7_multiply_by            : integer := 0;
        clk7_divide_by              : integer := 0;
        clk7_phase_shift            : string := "0";
        clk7_duty_cycle             : integer := 50;
        
        clk8_output_frequency       : integer := 0;
        clk8_multiply_by            : integer := 0;
        clk8_divide_by              : integer := 0;
        clk8_phase_shift            : string := "0";
        clk8_duty_cycle             : integer := 50;
        
        clk9_output_frequency       : integer := 0;
        clk9_multiply_by            : integer := 0;
        clk9_divide_by              : integer := 0;
        clk9_phase_shift            : string := "0";
        clk9_duty_cycle             : integer := 50;
        

        pfd_min                     : integer := 0;
        pfd_max                     : integer := 0;
        vco_min                     : integer := 0;
        vco_max                     : integer := 0;
        vco_center                  : integer := 0;

        -- ADVANCED USER PARAMETERS
        m_initial                   : integer := 1;
        m                           : integer := 0;
        n                           : integer := 1;

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
        
        c6_high                     : integer := 1;
        c6_low                      : integer := 1;
        c6_initial                  : integer := 1;
        c6_mode                     : string := "bypass";
        c6_ph                       : integer := 0;
        
        c7_high                     : integer := 1;
        c7_low                      : integer := 1;
        c7_initial                  : integer := 1;
        c7_mode                     : string := "bypass";
        c7_ph                       : integer := 0;
        
        c8_high                     : integer := 1;
        c8_low                      : integer := 1;
        c8_initial                  : integer := 1;
        c8_mode                     : string := "bypass";
        c8_ph                       : integer := 0;
        
        c9_high                     : integer := 1;
        c9_low                      : integer := 1;
        c9_initial                  : integer := 1;
        c9_mode                     : string := "bypass";
        c9_ph                       : integer := 0;
        
        m_ph                        : integer := 0;
        
        clk0_counter                : string := "unused";
        clk1_counter                : string := "unused";
        clk2_counter                : string := "unused";
        clk3_counter                : string := "unused";
        clk4_counter                : string := "unused";
        clk5_counter                : string := "unused";
        clk6_counter                : string := "unused";
        clk7_counter                : string := "unused";
        clk8_counter                : string := "unused";
        clk9_counter                : string := "unused";
        
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
        c5_use_casc_in              : string := "off";
        c6_use_casc_in              : string := "off";
        c7_use_casc_in              : string := "off";
        c8_use_casc_in              : string := "off";
        c9_use_casc_in              : string := "off";
        
        m_test_source               : integer := -1;
        c0_test_source              : integer := -1;
        c1_test_source              : integer := -1;
        c2_test_source              : integer := -1;
        c3_test_source              : integer := -1;
        c4_test_source              : integer := -1;
        c5_test_source              : integer := -1;
        c6_test_source              : integer := -1;
        c7_test_source              : integer := -1;
        c8_test_source              : integer := -1;
        c9_test_source              : integer := -1;
        
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        vco_post_scale              : integer := 1;
        vco_frequency_control       : string  := "auto";
        vco_phase_shift_step        : integer := 0;
        
        charge_pump_current         : integer := 10;
        loop_filter_r               : string := " 1.0";
        loop_filter_c               : integer := 0;

        
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        lpm_type                    : string := "stratixiii_pll";
        
        clk0_use_even_counter_mode  : string := "off";
        clk1_use_even_counter_mode  : string := "off";
        clk2_use_even_counter_mode  : string := "off";
        clk3_use_even_counter_mode  : string := "off";
        clk4_use_even_counter_mode  : string := "off";
        clk5_use_even_counter_mode  : string := "off";
        clk6_use_even_counter_mode  : string := "off";
        clk7_use_even_counter_mode  : string := "off";
        clk8_use_even_counter_mode  : string := "off";
        clk9_use_even_counter_mode  : string := "off";
        
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
        clk5_use_even_counter_value : string := "off";
        clk6_use_even_counter_value : string := "off";
        clk7_use_even_counter_value : string := "off";
        clk8_use_even_counter_value : string := "off";
        clk9_use_even_counter_value : string := "off";
            
-- Test only
        init_block_reset_a_count    : integer := 1;
        init_block_reset_b_count    : integer := 1;
        charge_pump_current_bits : integer := 0;
        lock_window_ui_bits : integer := 0;
        loop_filter_c_bits : integer := 0;
        loop_filter_r_bits : integer := 0;
        test_counter_c0_delay_chain_bits : integer := 0;
        test_counter_c1_delay_chain_bits : integer := 0;
        test_counter_c2_delay_chain_bits : integer := 0;
        test_counter_c3_delay_chain_bits : integer := 0;
        test_counter_c4_delay_chain_bits : integer := 0;
        test_counter_c5_delay_chain_bits : integer := 0;
        test_counter_c6_delay_chain_bits : integer := 0;
        test_counter_c7_delay_chain_bits : integer := 0;
        test_counter_c8_delay_chain_bits : integer := 0;
        test_counter_c9_delay_chain_bits : integer := 0;
        test_counter_m_delay_chain_bits : integer := 0;
        test_counter_n_delay_chain_bits : integer := 0;
        test_feedback_comp_delay_chain_bits : integer := 0;
        test_input_comp_delay_chain_bits : integer := 0;
        test_volt_reg_output_mode_bits : integer := 0;
        test_volt_reg_output_voltage_bits : integer := 0;
        test_volt_reg_test_mode : string := "false";
        vco_range_detector_high_bits : integer := -1;
        vco_range_detector_low_bits : integer := -1;
        scan_chain_mif_file : string := "";
        dpa_output_clock_phase_shift : integer := 0;
        test_counter_c3_sclk_delay_chain_bits   : integer := -1;
        test_counter_c4_sclk_delay_chain_bits   : integer := -1;
        test_counter_c5_lden_delay_chain_bits   : integer := -1;
        test_counter_c6_lden_delay_chain_bits   : integer := -1;

        auto_settings : string  := "true";     
-- Simulation only generics
        family_name                 : string  := "StratixIII";

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
       tipd_scanclkena             : VitalDelayType01 := DefPropDelay01;
       tipd_scandata               : VitalDelayType01 := DefPropDelay01;
       tipd_configupdate           : VitalDelayType01 := DefPropDelay01;
       tipd_clkswitch              : VitalDelayType01 := DefPropDelay01;
       tipd_phaseupdown            : VitalDelayType01 := DefPropDelay01;
       tipd_phasecounterselect     : VitalDelayArrayType01(3 DOWNTO 0) := (OTHERS => DefPropDelay01);
       tipd_phasestep              : VitalDelayType01 := DefPropDelay01;
       tsetup_scandata_scanclk_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
       thold_scandata_scanclk_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
       tsetup_scanclkena_scanclk_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
       thold_scanclkena_scanclk_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
        use_vco_bypass              : string := "false"
    );

    PORT
    (
        inclk                       : in std_logic_vector(1 downto 0);
        fbin                         : in std_logic := '0';
        fbout                        : out std_logic;
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        scandata                    : in std_logic := '0';
        scanclk                     : in std_logic := '0';
        scanclkena                  : in std_logic := '1';
        configupdate                : in std_logic := '0';
        clk                         : out std_logic_vector(9 downto 0);
        phasecounterselect          : in std_logic_vector(3 downto 0) := "0000";
        phaseupdown                 : in std_logic := '0';
        phasestep                   : in std_logic := '0';
        clkbad                      : out std_logic_vector(1 downto 0);
        activeclock                 : out std_logic;
        locked                      : out std_logic;
        scandataout                 : out std_logic;
        scandone                    : out std_logic;
        phasedone                   : out std_logic;
        vcooverrange                : out std_logic;
        vcounderrange               : out std_logic

    );
END stratixiii_pll;

ARCHITECTURE vital_pll of stratixiii_pll is

function get_vco_min_no_division(i_vco_post_scale : INTEGER) return INTEGER is
begin
    if (i_vco_post_scale = 1) then
        return vco_min * 2;
    else
        return vco_min;
    end if;
end;

function get_vco_max_no_division(i_vco_post_scale : INTEGER) return INTEGER is
begin
    if (i_vco_post_scale = 1) then
        return vco_max * 2;
    else
        return vco_max;
    end if;
end;

TYPE int_array is ARRAY(NATURAL RANGE <>) of integer;
TYPE str_array is ARRAY(NATURAL RANGE <>) of string(1 to 6);
TYPE str_array1 is ARRAY(NATURAL RANGE <>) of string(1 to 9);
TYPE std_logic_array is ARRAY(NATURAL RANGE <>) of std_logic;

constant VCO_MIN_NO_DIVISION   : integer := get_vco_min_no_division(vco_post_scale);
constant VCO_MAX_NO_DIVISION   : integer := get_vco_max_no_division(vco_post_scale);

-- internal advanced parameter signals
signal   i_vco_min      : integer := vco_min;
signal   i_vco_max      : integer := vco_max;
signal   i_vco_center   : integer;
signal   i_pfd_min      : integer;
signal   i_pfd_max      : integer;
    signal   c_ph_val       : int_array(0 to 9) := (OTHERS => 0);
    signal   c_ph_val_tmp   : int_array(0 to 9) := (OTHERS => 0);
    signal   c_high_val     : int_array(0 to 9) := (OTHERS => 1);
    signal   c_low_val      : int_array(0 to 9) := (OTHERS => 1);
    signal   c_initial_val  : int_array(0 to 9) := (OTHERS => 1);
    signal   c_mode_val     : str_array(0 to 9);
    signal   clk_num     : str_array(0 to 9);

-- old values
    signal   c_high_val_old : int_array(0 to 9) := (OTHERS => 1);
    signal   c_low_val_old  : int_array(0 to 9) := (OTHERS => 1);
    signal   c_ph_val_old   : int_array(0 to 9) := (OTHERS => 0);
    signal   c_mode_val_old : str_array(0 to 9);
-- hold registers
    signal   c_high_val_hold : int_array(0 to 9) := (OTHERS => 1);
    signal   c_low_val_hold  : int_array(0 to 9) := (OTHERS => 1);
    signal   c_ph_val_hold   : int_array(0 to 9) := (OTHERS => 0);
    signal   c_mode_val_hold : str_array(0 to 9);

-- temp registers
    signal   sig_c_ph_val_tmp   : int_array(0 to 9) := (OTHERS => 0);
    signal   c_ph_val_orig  : int_array(0 to 9) := (OTHERS => 0);

    signal   i_clk9_counter         : integer := 9;
    signal   i_clk8_counter         : integer := 8;
    signal   i_clk7_counter         : integer := 7;
    signal   i_clk6_counter         : integer := 6;
    signal   i_clk5_counter         : integer := 5;
signal   real_lock_high : integer := 0;
signal   i_clk4_counter         : integer := 4;
signal   i_clk3_counter         : integer := 3;
signal   i_clk2_counter         : integer := 2;
signal   i_clk1_counter         : integer := 1;
signal   i_clk0_counter         : integer := 0;
signal   i_charge_pump_current  : integer;
signal   i_loop_filter_r        : integer;

-- end internal advanced parameter signals

-- CONSTANTS
CONSTANT    SCAN_CHAIN : integer := 144;
CONSTANT    GPP_SCAN_CHAIN : integer := 234;
CONSTANT    FAST_SCAN_CHAIN : integer := 180;
    CONSTANT cntrs : str_array(9 downto 0) := ("    C9", "    C8", "    C7", "    C6", "    C5", "    C4", "    C3", "    C2", "    C1", "    C0");
CONSTANT    ss_cntrs : str_array(0 to 3) := ("     M", "    M2", "     N", "    N2");
            
CONSTANT    loop_filter_c_arr : int_array(0 to 3) := (0,0,0,0);
CONSTANT    fpll_loop_filter_c_arr : int_array(0 to 3) := (0,0,0,0);
CONSTANT    charge_pump_curr_arr : int_array(0 to 15) := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

CONSTANT    num_phase_taps : integer := 8;
-- signals

signal    vcc : std_logic := '1';
          
signal    fbclk       : std_logic;
signal    refclk      : std_logic;
signal    vco_over    : std_logic := '0';
signal    vco_under   : std_logic := '1';

signal pll_locked : boolean := false;


    signal c_clk : std_logic_array(0 to 9);
signal vco_out : std_logic_vector(7 downto 0) := (OTHERS => '0');

-- signals to assign values to counter params
signal    m_val : integer := 1;
signal    n_val : integer := 1;
signal    m_ph_val : integer := 0;
signal    m_ph_initial : integer := 0;
signal    m_ph_val_tmp  : integer := 0;
signal    m_initial_val : integer := m_initial;
         
signal    m_mode_val : string(1 to 6) := "      ";
signal    n_mode_val : string(1 to 6) := "      ";
signal    lfc_val : integer := 0;
signal    vco_cur : integer := vco_post_scale;
signal    cp_curr_val : integer := 0;
signal    lfr_val : string(1 to 2) := "  ";
         
signal    cp_curr_old_bit_setting : integer := charge_pump_current_bits;
signal    cp_curr_val_bit_setting : std_logic_vector(2 downto 0) := (OTHERS => '0');
signal    lfr_old_bit_setting : integer := loop_filter_r_bits;
signal    lfr_val_bit_setting : std_logic_vector(4 downto 0) := (OTHERS => '0');
signal    lfc_old_bit_setting : integer := loop_filter_c_bits; 
signal    lfc_val_bit_setting : std_logic_vector(1 downto 0) := (OTHERS => '0');
         
signal    pll_reconfig_display_full_setting : boolean := FALSE; -- display full setting, change to true
-- old    values
signal    m_val_old : integer := 1;
signal    n_val_old : integer := 1;
signal    m_mode_val_old : string(1 to 6) := "      ";
signal    n_mode_val_old : string(1 to 6) := "      ";
signal    m_ph_val_old : integer := 0;
signal    lfc_old : integer := 0;
signal    vco_old : integer := 0;
signal    cp_curr_old : integer := 0;
signal    lfr_old : string(1 to 2) := "  ";
    signal num_output_cntrs : integer := 10;
signal    scanclk_period : time := 1 ps;
    signal scan_data : std_logic_vector(0 to 233) := (OTHERS => '0');


    signal clk_pfd : std_logic_vector(0 to 9);
signal    clk0_tmp : std_logic;
signal    clk1_tmp : std_logic;
signal    clk2_tmp : std_logic;
signal    clk3_tmp : std_logic;
signal    clk4_tmp : std_logic;
    signal clk5_tmp : std_logic;
    signal clk6_tmp : std_logic;
    signal clk7_tmp : std_logic;
    signal clk8_tmp : std_logic;
    signal clk9_tmp : std_logic;

signal    update_conf_latches : std_logic := '0';
signal    update_conf_latches_reg : std_logic := '0';

signal    clkin : std_logic := '0';
signal    gate_locked : std_logic := '0';
signal    pfd_locked : std_logic := '0';
signal    lock : std_logic := '0';
signal    about_to_lock : boolean := false;
signal    reconfig_err : boolean := false;

signal    inclk_c0 : std_logic;
signal    inclk_c1 : std_logic;
signal    inclk_c2 : std_logic;
signal    inclk_c3 : std_logic;
signal    inclk_c4 : std_logic;
    signal inclk_c5 : std_logic;
    signal inclk_c6 : std_logic;
    signal inclk_c7 : std_logic;
    signal inclk_c8 : std_logic;
    signal inclk_c9 : std_logic;
signal inclk_m : std_logic;
signal devpor : std_logic;
signal devclrn : std_logic;

signal inclk0_ipd : std_logic;
signal inclk1_ipd : std_logic;
signal pfdena_ipd : std_logic;
signal areset_ipd : std_logic;
signal fbin_ipd : std_logic;
signal scanclk_ipd : std_logic;
signal scanclkena_ipd, scanclkena_reg : std_logic;
signal scandata_ipd : std_logic;
signal clkswitch_ipd : std_logic;
    signal phasecounterselect_ipd : std_logic_vector(3 downto 0);
signal phaseupdown_ipd : std_logic;
signal phasestep_ipd : std_logic;
signal configupdate_ipd : std_logic;
-- registered signals

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


signal reset_low : std_logic := '0';

-- Phase Reconfig

    SIGNAL phasecounterselect_reg   :  std_logic_vector(3 DOWNTO 0);

SIGNAL phaseupdown_reg          :  std_logic := '0';
SIGNAL phasestep_reg            :  std_logic := '0';
SIGNAL phasestep_high_count     :  integer := 0;
SIGNAL update_phase             :  std_logic := '0';

signal scandataout_tmp : std_logic := '0';
signal scandata_in : std_logic := '0';
signal scandata_out : std_logic := '0';
signal scandone_tmp : std_logic := '1';
signal initiate_reconfig : std_logic := '0';

signal sig_refclk_period : time := (inclk0_input_frequency * 1 ps) * n;

signal schedule_vco : std_logic := '0';

signal areset_ena_sig : std_logic := '0';
signal pll_in_test_mode : boolean := false;
signal pll_has_just_been_reconfigured : boolean := false;

    signal inclk_c_from_vco : std_logic_array(0 to 9);

signal inclk_m_from_vco : std_logic;

SIGNAL inclk0_period              : time := 0 ps;
SIGNAL last_inclk0_period         : time := 0 ps;
SIGNAL last_inclk0_edge         : time := 0 ps;
SIGNAL first_inclk0_edge_detect : STD_LOGIC := '0';
SIGNAL inclk1_period              : time := 0 ps;
SIGNAL last_inclk1_period         : time := 0 ps;
SIGNAL last_inclk1_edge         : time := 0 ps;
SIGNAL first_inclk1_edge_detect : STD_LOGIC := '0';



COMPONENT stratixiii_mn_cntr
    PORT (
        clk           : IN std_logic;
        reset         : IN std_logic := '0';
        cout          : OUT std_logic;
        initial_value : IN integer := 1;
        modulus       : IN integer := 1;
        time_delay    : IN integer := 0
    );
END COMPONENT;

COMPONENT stratixiii_scale_cntr
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

COMPONENT stratixiii_dffe
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

COMPONENT stratixiii_pll_reg
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
        VitalWireDelay (fbin_ipd, fbin, tipd_fbin);
        VitalWireDelay (pfdena_ipd, pfdena, tipd_pfdena);
        VitalWireDelay (scanclk_ipd, scanclk, tipd_scanclk);
        VitalWireDelay (scanclkena_ipd, scanclkena, tipd_scanclkena);
        VitalWireDelay (scandata_ipd, scandata, tipd_scandata);
        VitalWireDelay (configupdate_ipd, configupdate, tipd_configupdate);
        VitalWireDelay (clkswitch_ipd, clkswitch, tipd_clkswitch);
        VitalWireDelay (phaseupdown_ipd, phaseupdown, tipd_phaseupdown);
        VitalWireDelay (phasestep_ipd, phasestep, tipd_phasestep);
        VitalWireDelay (phasecounterselect_ipd(0), phasecounterselect(0), tipd_phasecounterselect(0));
        VitalWireDelay (phasecounterselect_ipd(1), phasecounterselect(1), tipd_phasecounterselect(1));
        VitalWireDelay (phasecounterselect_ipd(2), phasecounterselect(2), tipd_phasecounterselect(2));
        VitalWireDelay (phasecounterselect_ipd(3), phasecounterselect(3), tipd_phasecounterselect(3));

    end block;

inclk_m <=  fbclk when m_test_source = 0 else
            refclk when m_test_source = 1 else
            inclk_m_from_vco;

    areset_ena_sig <= areset_ipd or sig_stop_vco;

    pll_in_test_mode <= true when   (m_test_source /= -1 or c0_test_source /= -1 or
                                    c1_test_source /= -1 or c2_test_source /= -1 or
                                    c3_test_source /= -1 or c4_test_source /= -1 or
                                    c5_test_source /= -1 or c6_test_source /= -1 or 
                                    c7_test_source /= -1 or c8_test_source /= -1 or
                                    c9_test_source /= -1)
                        else
                        false;
   

    real_lock_high <= lock_high WHEN (sim_gate_lock_device_behavior = "on") ELSE 0;   
    m1 : stratixiii_mn_cntr
        port map (  clk           => inclk_m,
                    reset         => areset_ena_sig,
                    cout          => fbclk,
                    initial_value => m_initial_val,
                    modulus       => m_val,
                    time_delay    => m_delay
                );

    -- add delta delay to inclk1 to ensure inclk0 and inclk1 are processed
    -- in different simulation deltas.
    inclk1_tmp <= inclk1_ipd;

    -- Calculate the inclk0 period
    PROCESS
    VARIABLE inclk0_period_tmp : time := 0 ps;
    BEGIN
        WAIT UNTIL (inclk0_ipd'EVENT AND inclk0_ipd = '1');
        IF (first_inclk0_edge_detect = '0') THEN
            first_inclk0_edge_detect <= '1';
        ELSE
            last_inclk0_period <= inclk0_period;
            inclk0_period_tmp  := NOW - last_inclk0_edge;
        END IF;
        last_inclk0_edge <= NOW;
        inclk0_period <= inclk0_period_tmp;
    END PROCESS;
   
   
    -- Calculate the inclk1 period
    PROCESS
    VARIABLE inclk1_period_tmp : time := 0 ps;
    BEGIN
    WAIT UNTIL (inclk1_ipd'EVENT AND inclk1_ipd = '1');
        IF (first_inclk1_edge_detect = '0') THEN
            first_inclk1_edge_detect <= '1';
        ELSE
            last_inclk1_period <= inclk1_period;
            inclk1_period_tmp  := NOW - last_inclk1_edge;
        END IF;
        last_inclk1_edge <= NOW;
        inclk1_period <= inclk1_period_tmp;
    END PROCESS;

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
    variable diff_percent_period : integer := 0;
    variable buf : line;
    variable switch_clock : boolean := false;

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
                switch_clock := true;
            elsif (clkswitch_ipd'event and clkswitch_ipd = '0') then
                switch_clock := false;
            end if;
        end if;

        if (switch_clock = true) then
            if (inclk0_ipd'event or inclk1_tmp'event) then
                if (current_clock = 0) then
                    current_clock := 1;
                    active_clock := '1';
                    clkin <= transport inclk1_tmp;
                elsif (current_clock = 1) then
                    current_clock := 0;
                    active_clock := '0';
                    clkin <= transport inclk0_ipd;
                end if;
                switch_clock := false;
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
            if (input_value = '1' and enable_switch_over_counter = "on" and primary_clk_is_bad) then
                switch_over_count := switch_over_count + 1;
            end if;
            if ((input_value = '0')) then
                if (external_switch and (got_curr_clk_falling_edge_after_clkswitch or current_clk_is_bad)) or (primary_clk_is_bad and clkswitch_ipd /= '1' and (enable_switch_over_counter = "off" or switch_over_count = switch_over_counter)) then
                    got_curr_clk_falling_edge_after_clkswitch := false;

                    if (areset_ipd = '0') then
                        if ((inclk0_period > inclk1_period) and (inclk1_period /= 0 ps)) then
                            diff_percent_period := (( inclk0_period - inclk1_period ) * 100) / inclk1_period;
                        elsif (inclk0_period /= 0 ps) then
                            diff_percent_period := (( inclk1_period - inclk0_period ) * 100) / inclk0_period;
                        end if;

                        if((diff_percent_period > 20)and ( switch_over_type = "auto")) then
                            WRITE(buf,string'("Warning : The input clock frequencies specified for the specified PLL are too far apart for auto-switch-over feature to work properly. Please make sure that the clock frequencies are 20 percent apart for correct functionality."));
                            writeline(output, buf);
                        end if;
                    end if;

                    if (current_clock = 0) then
                        current_clock := 1;
                    else
                        current_clock := 0;
                    end if;
                    active_clock := not active_clock;
                    switch_over_count := 0;
                    external_switch := false;
                    current_clk_is_bad := false;
                else
                    if(switch_over_type = "auto") then
                        if(current_clock = 0 and clk0_is_bad = '1' and clk1_is_bad = '0' ) then
                            current_clock := 1;
                            active_clock := not active_clock;
                        end if;
                
                        if(current_clock = 1 and clk0_is_bad = '0' and clk1_is_bad = '1' ) then
                            current_clock := 0;
                            active_clock := not active_clock;
                        end if;
                    end if;
                end if;         
                
            end if;
        end if;

        -- schedule outputs
        clkbad(0) <= clk0_is_bad;
        clkbad(1) <= clk1_is_bad;
        activeclock <= active_clock;

    end process;


    n1 : stratixiii_mn_cntr
        port map (
                clk           => clkin,
                reset         => areset_ipd,
                cout          => refclk,
                initial_value => n_val,
                modulus       => n_val);

inclk_c0 <= refclk when c0_test_source = 1 else
            fbclk   when c0_test_source = 0 else
            inclk_c_from_vco(0);


    c0 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c0,
                reset          => areset_ena_sig,
                cout           => c_clk(0),
                initial        => c_initial_val(0),
                high           => c_high_val(0),
                low            => c_low_val(0),
                mode           => c_mode_val(0),
                ph_tap         => c_ph_val(0));

    inclk_c1 <= refclk when c1_test_source = 1 else
                fbclk  when c1_test_source = 0 else
                c_clk(0) when c1_use_casc_in = "on" else
                inclk_c_from_vco(1);
                

    c1 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c1,
                reset          => areset_ena_sig,
                cout           => c_clk(1),
                initial        => c_initial_val(1),
                high           => c_high_val(1),
                low            => c_low_val(1),
                mode           => c_mode_val(1),
                ph_tap         => c_ph_val(1));

inclk_c2 <= refclk when c2_test_source = 1 else
            fbclk  when c2_test_source = 0 else
            c_clk(1) when c2_use_casc_in = "on" else
            inclk_c_from_vco(2);

    c2 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c2,
                reset          => areset_ena_sig,
                cout           => c_clk(2),
                initial        => c_initial_val(2),
                high           => c_high_val(2),
                low            => c_low_val(2),
                mode           => c_mode_val(2),
                ph_tap         => c_ph_val(2));


    inclk_c3 <= refclk when c3_test_source = 1 else
                fbclk  when c3_test_source = 0 else
                c_clk(2) when c3_use_casc_in = "on" else
                inclk_c_from_vco(3);
                
    c3 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c3,
                reset          => areset_ena_sig,
                cout           => c_clk(3),
                initial        => c_initial_val(3),
                high           => c_high_val(3),
                low            => c_low_val(3),
                mode           => c_mode_val(3),
                ph_tap         => c_ph_val(3));

    inclk_c4 <= refclk when c4_test_source = 1 else
                fbclk  when c4_test_source = 0 else
                c_clk(3) when (c4_use_casc_in = "on") else
                inclk_c_from_vco(4);
                
    c4 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c4,
                reset          => areset_ena_sig,
                cout           => c_clk(4),
                initial        => c_initial_val(4),
                high           => c_high_val(4),
                low            => c_low_val(4),
                mode           => c_mode_val(4),
                ph_tap         => c_ph_val(4));

    inclk_c5 <= refclk when c5_test_source = 1 else
            fbclk  when c5_test_source = 0 else
            c_clk(4) when c5_use_casc_in = "on" else
            inclk_c_from_vco(5);
            
    c5 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c5,
                reset          => areset_ena_sig,
                cout           => c_clk(5),
                initial        => c_initial_val(5),
                high           => c_high_val(5),
                low            => c_low_val(5),
                mode           => c_mode_val(5),
                ph_tap         => c_ph_val(5));

    inclk_c6 <= refclk when c6_test_source = 1 else
                fbclk  when c6_test_source = 0 else
                c_clk(5) when c6_use_casc_in = "on" else
                inclk_c_from_vco(6);
            
    c6 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c6,
                reset          => areset_ena_sig,
                cout           => c_clk(6),
                initial        => c_initial_val(6),
                high           => c_high_val(6),
                low            => c_low_val(6),
                mode           => c_mode_val(6),
                ph_tap         => c_ph_val(6));

    inclk_c7 <= refclk when c7_test_source = 1 else
                fbclk  when c7_test_source = 0 else
                c_clk(6) when c7_use_casc_in = "on" else
                inclk_c_from_vco(7);
            
    c7 : stratixiii_scale_cntr
                port map (
                clk            => inclk_c7,
                reset          => areset_ena_sig,
                cout           => c_clk(7),
                initial        => c_initial_val(7),
                high           => c_high_val(7),
                low            => c_low_val(7),
                mode           => c_mode_val(7),
                ph_tap         => c_ph_val(7));

    inclk_c8 <= refclk when c8_test_source = 1 else
                fbclk  when c8_test_source = 0 else
                c_clk(7) when c8_use_casc_in = "on" else
                inclk_c_from_vco(8);
            
    c8 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c8,
                reset          => areset_ena_sig,
                cout           => c_clk(8),
                initial        => c_initial_val(8),
                high           => c_high_val(8),
                low            => c_low_val(8),
                mode           => c_mode_val(8),
                ph_tap         => c_ph_val(8));

    inclk_c9 <= refclk when c9_test_source = 1 else
                fbclk  when c9_test_source = 0 else
                c_clk(8) when c9_use_casc_in = "on" else
                inclk_c_from_vco(9);
            
    c9 : stratixiii_scale_cntr
        port map (
                clk            => inclk_c9,
                reset          => areset_ena_sig,
                cout           => c_clk(9),
                initial        => c_initial_val(9),
                high           => c_high_val(9),
                low            => c_low_val(9),
                mode           => c_mode_val(9),
                ph_tap         => c_ph_val(9));
    
    process(scandone_tmp, lock)
    begin
        if (scandone_tmp'event and (scandone_tmp = '1')) then
            pll_has_just_been_reconfigured <= true;
        elsif (lock'event and (lock = '1')) then
            pll_has_just_been_reconfigured <= false;
        end if;
    end process;
    
    process(inclk_c0, inclk_c1, areset_ipd, sig_stop_vco)
    variable c0_got_first_rising_edge : boolean := false;
    variable c0_count : integer := 2;
    variable c0_initial_count : integer := 1;
    variable c0_tmp, c1_tmp : std_logic := '0';
    variable c1_got_first_rising_edge : boolean := false;
    variable c1_count : integer := 2;
    variable c1_initial_count : integer := 1;
    begin
        if (areset_ipd = '1' or sig_stop_vco = '1') then
            c0_count := 2;
            c1_count := 2;
            c0_initial_count := 1;
            c1_initial_count := 1;
            c0_got_first_rising_edge := false;
            c1_got_first_rising_edge := false;
        else
            if (not c0_got_first_rising_edge) then
                if (inclk_c0'event and inclk_c0 = '1') then
                    if (c0_initial_count = c_initial_val(0)) then
                        c0_got_first_rising_edge := true;
                    else
                        c0_initial_count := c0_initial_count + 1;
                    end if;
                end if;
            elsif (inclk_c0'event) then
                c0_count := c0_count + 1;
                if (c0_count = (c_high_val(0) + c_low_val(0)) * 2) then
                    c0_count := 1;
                end if;
            end if;
            if (inclk_c0'event and inclk_c0 = '0') then
                if (c0_count = 1) then
                    c0_tmp := '1';
                    c0_got_first_rising_edge := false;
                else
                    c0_tmp := '0';
                end if;
            end if;

            if (not c1_got_first_rising_edge) then
                if (inclk_c1'event and inclk_c1 = '1') then
                    if (c1_initial_count = c_initial_val(1)) then
                        c1_got_first_rising_edge := true;
                    else
                        c1_initial_count := c1_initial_count + 1;
                    end if;
                end if;
            elsif (inclk_c1'event) then
                c1_count := c1_count + 1;
                if (c1_count = (c_high_val(1) + c_low_val(1)) * 2) then
                    c1_count := 1;
                end if;
            end if;
            if (inclk_c1'event and inclk_c1 = '0') then
                if (c1_count = 1) then
                    c1_tmp := '1';
                    c1_got_first_rising_edge := false;
                else
                    c1_tmp := '0';
                end if;
            end if;
        end if;

    end process;

    
    locked <=   pfd_locked WHEN (test_bypass_lock_detect = "on") ELSE
                lock;


    process (scandone_tmp)
    variable buf : line;
    begin
        if (scandone_tmp'event and scandone_tmp = '1') then
            if (reconfig_err = false) then
                ASSERT false REPORT "PLL Reprogramming completed with the following values (Values in parantheses indicate values before reprogramming) :" severity note;
                write (buf, string'("    N modulus = "));
                write (buf, n_val);
                write (buf, string'(" ( "));
                write (buf, n_val_old);
                write (buf, string'(" )"));
                writeline (output, buf);

                write (buf, string'("    M modulus = "));
                write (buf, m_val);
                write (buf, string'(" ( "));
                write (buf, m_val_old);
                write (buf, string'(" )"));
                writeline (output, buf);

                write (buf, string'("    M ph_tap = "));
                write (buf, m_ph_val);
                write (buf, string'(" ( "));
                write (buf, m_ph_val_old);
                write (buf, string'(" )"));
                writeline (output, buf);

                for i in 0 to (num_output_cntrs-1) loop
                    write (buf, clk_num(i));
                    write (buf, string'(" : "));
                    write (buf, cntrs(i));
                    write (buf, string'(" :   high = "));
                    write (buf, c_high_val(i));
                    write (buf, string'(" ("));
                    write (buf, c_high_val_old(i));
                    write (buf, string'(") "));
                    write (buf, string'(" ,   low = "));
                    write (buf, c_low_val(i));
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

                IF (pll_reconfig_display_full_setting) THEN
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
                
                write (buf, string'("    VCO_Post_Scale = "));
                write (buf, vco_cur);
                write (buf, string'(" ( "));
                write (buf, vco_old);
                write (buf, string'(" ) "));
                writeline (output, buf);

                
                ELSE
                write (buf, string'("    Charge Pump Current  (bit setting) = "));
                write (buf, alt_conv_integer(cp_curr_val_bit_setting));
                write (buf, string'(" ( "));
                write (buf, cp_curr_old_bit_setting);
                write (buf, string'(" ) "));
                writeline (output, buf);

                write (buf, string'("    Loop Filter Capacitor (bit setting)  = "));
                write (buf, alt_conv_integer(lfc_val_bit_setting));
                write (buf, string'(" ( "));
                write (buf, lfc_old_bit_setting);
                write (buf, string'(" ) "));
                writeline (output, buf);

                write (buf, string'("    Loop Filter Resistor (bit setting)  = "));
                write (buf, alt_conv_integer(lfr_val_bit_setting));
                write (buf, string'(" ( "));
                write (buf, lfr_old_bit_setting);
                write (buf, string'(" ) "));
                writeline (output, buf);
                
                write (buf, string'("    VCO_Post_Scale = "));
                write (buf, vco_cur);
                write (buf, string'(" ( "));
                write (buf, vco_old);
                write (buf, string'(" ) "));
                writeline (output, buf);
                
                END IF;
                cp_curr_old_bit_setting <= alt_conv_integer(cp_curr_val_bit_setting);
                lfc_old_bit_setting <= alt_conv_integer(lfc_val_bit_setting);
                lfr_old_bit_setting <= alt_conv_integer(lfr_val_bit_setting);
            else ASSERT false REPORT "Errors were encountered during PLL reprogramming. Please refer to error/warning messages above." severity warning;
            end if;
        end if;
        
    end process;

    update_conf_latches <= configupdate_ipd;

    
    process (scandone_tmp,areset_ipd,update_conf_latches, c_clk(0), c_clk(1), c_clk(2), c_clk(3), c_clk(4), c_clk(5), c_clk(6), c_clk(7), c_clk(8), c_clk(9), vco_out, fbclk, scanclk_ipd)
    variable init : boolean := true;
    variable low, high : std_logic_vector(7 downto 0);
    variable low_fast, high_fast : std_logic_vector(3 downto 0);
    variable mode : string(1 to 6) := "bypass";
    variable is_error : boolean := false;
    variable m_tmp, n_tmp : std_logic_vector(8 downto 0);
    variable lfr_val_tmp : string(1 to 2) := "  ";

    variable c_high_val_tmp,c_hval : int_array(0 to 9) := (OTHERS => 1);
    variable c_low_val_tmp,c_lval  : int_array(0 to 9) := (OTHERS => 1);
    variable c_mode_val_tmp : str_array(0 to 9);
    variable m_val_tmp      : integer := 0;
    variable c0_rising_edge_transfer_done : boolean := false;
    variable c1_rising_edge_transfer_done : boolean := false;
    variable c2_rising_edge_transfer_done : boolean := false;
    variable c3_rising_edge_transfer_done : boolean := false;
    variable c4_rising_edge_transfer_done : boolean := false;
    variable c5_rising_edge_transfer_done : boolean := false;
    variable c6_rising_edge_transfer_done : boolean := false;
    variable c7_rising_edge_transfer_done : boolean := false;
    variable c8_rising_edge_transfer_done : boolean := false;
    variable c9_rising_edge_transfer_done : boolean := false;

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
    variable i_clk6_mult_by    : integer := 1;
    variable i_clk6_div_by     : integer := 1;
    variable i_clk7_mult_by    : integer := 1;
    variable i_clk7_div_by     : integer := 1;
    variable i_clk8_mult_by    : integer := 1;
    variable i_clk8_div_by     : integer := 1;
    variable i_clk9_mult_by    : integer := 1;
    variable i_clk9_div_by     : integer := 1;
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
    variable   i_c_high       : int_array(0 to 9);
    variable   i_c_low       : int_array(0 to 9);
    variable   i_c_initial       : int_array(0 to 9);
    variable   i_c_ph       : int_array(0 to 9);
    variable   i_c_mode       : str_array(0 to 9);
    variable   i_m_ph         : integer;
    variable   output_count   : integer;
    variable   new_divisor    : integer;

    variable clk0_cntr : string(1 to 6) := "    c0";
    variable clk1_cntr : string(1 to 6) := "    c1";
    variable clk2_cntr : string(1 to 6) := "    c2";
    variable clk3_cntr : string(1 to 6) := "    c3";
    variable clk4_cntr : string(1 to 6) := "    c4";
    variable clk5_cntr : string(1 to 6) := "    c5";
    variable clk6_cntr : string(1 to 6) := "    c6";
    variable clk7_cntr : string(1 to 6) := "    c7";
    variable clk8_cntr : string(1 to 6) := "    c8";
    variable clk9_cntr : string(1 to 6) := "    c9";

    variable fbk_cntr : string(1 to 2);
    variable fbk_cntr_index : integer;
    variable start_bit : integer;
    variable quiet_time : time := 0 ps;
    variable slowest_clk_old : time := 0 ps;
    variable slowest_clk_new : time := 0 ps;

    variable i : integer := 0;
    variable j : integer := 0;
    variable scanread_active_edge : time := 0 ps;
    variable got_first_scanclk : boolean := false;
    variable scanclk_last_rising_edge : time := 0 ps;
    variable current_scan_data : std_logic_vector(0 to 233) := (OTHERS => '0');

    variable index : integer := 0;
    variable Tviol_scandata_scanclk : std_ulogic := '0';
    variable TimingData_scandata_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_scanclkena_scanclk : std_ulogic := '0';
    variable TimingData_scanclkena_scanclk : VitalTimingDataType := VitalTimingDataInit;
    variable scan_chain_length : integer := GPP_SCAN_CHAIN;
    variable tmp_rem : integer := 0;
    variable scanclk_cycles : integer := 0;
    variable lfc_tmp : std_logic_vector(1 downto 0);
    variable lfr_tmp : std_logic_vector(5 downto 0);
    variable lfr_int : integer := 0;

    variable n_hi,n_lo,m_hi,m_lo : std_logic_vector(7 downto 0);
    variable buf : line;
    variable buf_scan_data : STD_LOGIC_VECTOR(0 TO 1) := (OTHERS => '0');
    variable buf_scan_data_2 : STD_LOGIC_VECTOR(0 TO 2) := (OTHERS => '0');
    
    function slowest_clk (
            C0 : integer; C0_mode : string(1 to 6);
            C1 : integer; C1_mode : string(1 to 6);
            C2 : integer; C2_mode : string(1 to 6);
            C3 : integer; C3_mode : string(1 to 6);
            C4 : integer; C4_mode : string(1 to 6);
            C5 : integer; C5_mode : string(1 to 6);
            C6 : integer; C6_mode : string(1 to 6);
            C7 : integer; C7_mode : string(1 to 6);
            C8 : integer; C8_mode : string(1 to 6);
            C9 : integer; C9_mode : string(1 to 6);
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
        if (C6 > max_modulus and C6_mode /= "bypass" and C6_mode /= "   off") then
            max_modulus := C6;
        end if;
        if (C7 > max_modulus and C7_mode /= "bypass" and C7_mode /= "   off") then
            max_modulus := C7;
        end if;
        if (C8 > max_modulus and C8_mode /= "bypass" and C8_mode /= "   off") then
            max_modulus := C8;
        end if;
        if (C9 > max_modulus and C9_mode /= "bypass" and C9_mode /= "   off") then
            max_modulus := C9;
        end if;

        refclk_int := refclk / 1 ps;
        if (m_mod /= 0) then
            q_period := (refclk_int * max_modulus / m_mod) * 1 ps;
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

    function extract_cntr_string (arg:string) return string is
    variable str : string(1 to 6) := "    c0";
    begin
        if (arg = "c0") then
            str := "    c0";
        elsif (arg = "c1") then
            str := "    c1";
        elsif (arg = "c2") then
            str := "    c2";
        elsif (arg = "c3") then
            str := "    c3";
        elsif (arg = "c4") then
            str := "    c4";
        elsif (arg = "c5") then
            str := "    c5";
        elsif (arg = "c6") then
            str := "    c6";
        elsif (arg = "c7") then
            str := "    c7";
        elsif (arg = "c8") then
            str := "    c8";
        elsif (arg = "c9") then
            str := "    c9";
        else str := "    c0";

        end if;

        return str;

    end extract_cntr_string;
    
    function extract_cntr_index (arg:string) return integer is
    variable index : integer := 0;
    begin
        if (arg(6) = '0') then
            index := 0;
        elsif (arg(6) = '1') then
            index := 1;
        elsif (arg(6) = '2') then
            index := 2;
        elsif (arg(6) = '3') then
            index := 3;
        elsif (arg(6) = '4') then
            index := 4;
        elsif (arg(6) = '5') then
            index := 5;
        elsif (arg(6) = '6') then
            index := 6;
        elsif (arg(6) = '7') then
            index := 7;
        elsif (arg(6) = '8') then
            index := 8;
        else index := 9;
        end if;

        return index;
    end extract_cntr_index;

    function output_cntr_num (arg:string) return string is
    variable str : string(1 to 6) := "unused";
    begin
        if (arg = "c0") then
            str := "  clk0";
        elsif (arg = "c1") then
            str := "  clk1";
        elsif (arg = "c2") then
            str := "  clk2";
        elsif (arg = "c3") then
            str := "  clk3";
        elsif (arg = "c4") then
            str := "  clk4";
        elsif (arg = "c5") then
            str := "  clk5";
        elsif (arg = "c6") then
            str := "  clk6";
        elsif (arg = "c7") then
            str := "  clk7";
        elsif (arg = "c8") then
            str := "  clk8";
        elsif (arg = "c9") then
            str := "  clk9";
        else str := "unused";
        end if;
        return str;
    end output_cntr_num;

    begin
        IF (areset_ipd'EVENT AND areset_ipd = '1') then
            c_ph_val <= i_c_ph;
        END IF;
        
        if (init) then
            if (m = 0) then
                clk9_cntr  := "    c9";
                clk8_cntr  := "    c8";
                clk7_cntr  := "    c7";
                clk6_cntr  := "    c6";
                clk5_cntr  := "    c5";
                clk4_cntr  := "    c4";
                clk3_cntr  := "    c3";
                clk2_cntr  := "    c2";
                clk1_cntr  := "    c1";
                clk0_cntr  := "    c0";
            else
                clk9_cntr  := extract_cntr_string(clk9_counter);
                clk8_cntr  := extract_cntr_string(clk8_counter);
                clk7_cntr  := extract_cntr_string(clk7_counter);
                clk6_cntr  := extract_cntr_string(clk6_counter);
                clk5_cntr  := extract_cntr_string(clk5_counter);
                clk4_cntr  := extract_cntr_string(clk4_counter);
                clk3_cntr  := extract_cntr_string(clk3_counter);
                clk2_cntr  := extract_cntr_string(clk2_counter);
                clk1_cntr  := extract_cntr_string(clk1_counter);
                clk0_cntr  := extract_cntr_string(clk0_counter);
            end if;

    clk_num(9)  <= output_cntr_num(clk9_counter);
    clk_num(8)  <= output_cntr_num(clk8_counter);
    clk_num(7)  <= output_cntr_num(clk7_counter);
    clk_num(6)  <= output_cntr_num(clk6_counter);
    clk_num(5)  <= output_cntr_num(clk5_counter);
                clk_num(4)  <= output_cntr_num(clk4_counter);
                clk_num(3)  <= output_cntr_num(clk3_counter);
                clk_num(2)  <= output_cntr_num(clk2_counter);
                clk_num(1)  <= output_cntr_num(clk1_counter);
                clk_num(0)  <= output_cntr_num(clk0_counter);
            
            i_clk0_counter <= extract_cntr_index(clk0_cntr);
            i_clk1_counter <= extract_cntr_index(clk1_cntr);
            i_clk2_counter <= extract_cntr_index(clk2_cntr);
            i_clk3_counter <= extract_cntr_index(clk3_cntr);
            i_clk4_counter <= extract_cntr_index(clk4_cntr);
            i_clk5_counter <= extract_cntr_index(clk5_cntr);
            i_clk6_counter <= extract_cntr_index(clk6_cntr);
            i_clk7_counter <= extract_cntr_index(clk7_cntr);
            i_clk8_counter <= extract_cntr_index(clk8_cntr);
            i_clk9_counter <= extract_cntr_index(clk9_cntr);


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
                find_simple_integer_fraction(clk6_multiply_by, clk6_divide_by,
                                max_d_value, i_clk6_mult_by, i_clk6_div_by);
                find_simple_integer_fraction(clk7_multiply_by, clk7_divide_by,
                                max_d_value, i_clk7_mult_by, i_clk7_div_by);
                find_simple_integer_fraction(clk8_multiply_by, clk8_divide_by,
                                max_d_value, i_clk8_mult_by, i_clk8_div_by);
                find_simple_integer_fraction(clk9_multiply_by, clk9_divide_by,
                                max_d_value, i_clk9_mult_by, i_clk9_div_by);
                                
                if (vco_frequency_control = "manual_phase") then
                    find_m_and_n_4_manual_phase(inclk0_input_frequency, vco_phase_shift_step,
                                i_clk0_mult_by, i_clk1_mult_by,
                                i_clk2_mult_by, i_clk3_mult_by,
                                i_clk4_mult_by, 
                                i_clk5_mult_by,i_clk6_mult_by,
                                i_clk7_mult_by,i_clk8_mult_by,i_clk9_mult_by,
                                i_clk0_div_by, i_clk1_div_by,
                                i_clk2_div_by, i_clk3_div_by,
                                i_clk4_div_by, 
                                i_clk5_div_by,i_clk6_div_by,
                                i_clk7_div_by,i_clk8_div_by,i_clk9_div_by,
                                clk0_counter, clk1_counter,
                                clk2_counter, clk3_counter,
                                clk4_counter, 
                                clk5_counter,clk6_counter,
                                clk7_counter,clk8_counter,clk9_counter,
                        i_m, i_n);
                elsif (((pll_type = "fast") or (pll_type = "lvds") OR (pll_type = "left_right")) and ((vco_multiply_by /= 0) and (vco_divide_by /= 0))) then
                    i_n := vco_divide_by;
                    i_m := vco_multiply_by;
                else
                    i_n := 1;

                    if (((pll_type = "fast") or (pll_type = "left_right")) and (compensate_clock = "lvdsclk")) then
                        i_m := i_clk0_mult_by;
                    else
                        i_m := lcm (i_clk0_mult_by, i_clk1_mult_by,
                                i_clk2_mult_by, i_clk3_mult_by,
                                i_clk4_mult_by, 
                                i_clk5_mult_by,i_clk6_mult_by,
                                i_clk7_mult_by,i_clk8_mult_by,i_clk9_mult_by,
                                inclk0_input_frequency);
                    end if;
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
                                        str2int(clk6_phase_shift),
                                        str2int(clk7_phase_shift),
                                        str2int(clk8_phase_shift),
                                        str2int(clk9_phase_shift)
                                        );
                i_m_ph  := counter_ph(get_phase_degree(max_neg_abs,inclk0_input_frequency), i_m, i_n); 

                i_c_ph(0) := counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(1) := counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(2) := counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(3) := counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(4) := counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(5) := counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(6) := counter_ph(get_phase_degree(ph_adjust(str2int(clk6_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(7) := counter_ph(get_phase_degree(ph_adjust(str2int(clk7_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(8) := counter_ph(get_phase_degree(ph_adjust(str2int(clk8_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(9) := counter_ph(get_phase_degree(ph_adjust(str2int(clk9_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                
                
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
                i_c_high(6) := counter_high(output_counter_value(i_clk6_div_by,
                                i_clk6_mult_by,  i_m, i_n), clk6_duty_cycle);

                i_c_high(7) := counter_high(output_counter_value(i_clk7_div_by,
                                i_clk7_mult_by,  i_m, i_n), clk7_duty_cycle);

                i_c_high(8) := counter_high(output_counter_value(i_clk8_div_by,
                                i_clk8_mult_by,  i_m, i_n), clk8_duty_cycle);

                i_c_high(9) := counter_high(output_counter_value(i_clk9_div_by,
                                i_clk9_mult_by,  i_m, i_n), clk9_duty_cycle);

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
                i_c_low(6)  := counter_low(output_counter_value(i_clk6_div_by,
                                i_clk6_mult_by,  i_m, i_n), clk6_duty_cycle);
                i_c_low(7)  := counter_low(output_counter_value(i_clk7_div_by,
                                i_clk7_mult_by,  i_m, i_n), clk7_duty_cycle);
                i_c_low(8)  := counter_low(output_counter_value(i_clk8_div_by,
                                i_clk8_mult_by,  i_m, i_n), clk8_duty_cycle);
                i_c_low(9)  := counter_low(output_counter_value(i_clk9_div_by,
                                i_clk9_mult_by,  i_m, i_n), clk9_duty_cycle);

                i_m_initial  := counter_initial(get_phase_degree(max_neg_abs, inclk0_input_frequency), i_m,i_n);
                
                i_c_initial(0) := counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(1) := counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(2) := counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(3) := counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(4) := counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(5) := counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(6) := counter_initial(get_phase_degree(ph_adjust(str2int(clk6_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(7) := counter_initial(get_phase_degree(ph_adjust(str2int(clk7_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(8) := counter_initial(get_phase_degree(ph_adjust(str2int(clk8_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(9) := counter_initial(get_phase_degree(ph_adjust(str2int(clk9_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_mode(0) := counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
                i_c_mode(1) := counter_mode(clk1_duty_cycle, output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
                i_c_mode(2) := counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
                i_c_mode(3) := counter_mode(clk3_duty_cycle, output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
                i_c_mode(4) := counter_mode(clk4_duty_cycle, output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
                i_c_mode(5) := counter_mode(clk5_duty_cycle, output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));
                i_c_mode(6) := counter_mode(clk6_duty_cycle, output_counter_value(i_clk6_div_by, i_clk6_mult_by,  i_m, i_n));
                i_c_mode(7) := counter_mode(clk7_duty_cycle, output_counter_value(i_clk7_div_by, i_clk7_mult_by,  i_m, i_n));
                i_c_mode(8) := counter_mode(clk8_duty_cycle, output_counter_value(i_clk8_div_by, i_clk8_mult_by,  i_m, i_n));
                i_c_mode(9) := counter_mode(clk9_duty_cycle, output_counter_value(i_clk9_div_by, i_clk9_mult_by,  i_m, i_n));

                
 
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
                i_c_ph(6)         := c6_ph;
                i_c_ph(7)         := c7_ph;
                i_c_ph(8)         := c8_ph;
                i_c_ph(9)         := c9_ph;
                i_c_high(0)       := c0_high;
                i_c_high(1)       := c1_high;
                i_c_high(2)       := c2_high;
                i_c_high(3)       := c3_high;
                i_c_high(4)       := c4_high;
                i_c_high(5)       := c5_high;
                i_c_high(6)       := c6_high;
                i_c_high(7)       := c7_high;
                i_c_high(8)       := c8_high;
                i_c_high(9)       := c9_high;
                i_c_low(0)        := c0_low;
                i_c_low(1)        := c1_low;
                i_c_low(2)        := c2_low;
                i_c_low(3)        := c3_low;
                i_c_low(4)        := c4_low;
                i_c_low(5)        := c5_low;
                i_c_low(6)        := c6_low;
                i_c_low(7)        := c7_low;
                i_c_low(8)        := c8_low;
                i_c_low(9)        := c9_low;
                i_c_initial(0)    := c0_initial;
                i_c_initial(1)    := c1_initial;
                i_c_initial(2)    := c2_initial;
                i_c_initial(3)    := c3_initial;
                i_c_initial(4)    := c4_initial;
                i_c_initial(5)    := c5_initial;
                i_c_initial(6)    := c6_initial;
                i_c_initial(7)    := c7_initial;
                i_c_initial(8)    := c8_initial;
                i_c_initial(9)    := c9_initial;
                i_c_mode(0)       := translate_string(c0_mode);
                i_c_mode(1)       := translate_string(c1_mode);
                i_c_mode(2)       := translate_string(c2_mode);
                i_c_mode(3)       := translate_string(c3_mode);
                i_c_mode(4)       := translate_string(c4_mode);
                i_c_mode(5)       := translate_string(c5_mode);
                i_c_mode(6)       := translate_string(c6_mode);
                i_c_mode(7)       := translate_string(c7_mode);
                i_c_mode(8)       := translate_string(c8_mode);
                i_c_mode(9)       := translate_string(c9_mode);

            end if; -- user to advanced conversion.

            m_initial_val <= i_m_initial;
            n_val <= i_n;
            m_val <= i_m;

            if (i_m = 1) then
                m_mode_val <= "bypass";
            else
                m_mode_val <= "      ";
            end if;
            if (i_n = 1) then
                n_mode_val <= "bypass";
            else
                n_mode_val <= "      ";
            end if;

            m_ph_val  <= i_m_ph;
            m_ph_initial <= i_m_ph;
            m_val_tmp := i_m;

            for i in 0 to 9 loop
                if (i_c_mode(i) = "bypass") then
                    if (pll_type = "fast" or pll_type = "lvds" OR (pll_type = "left_right")) then
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
                c_hval(i)           := i_c_high(i);
                c_low_val_tmp(i)    := i_c_low(i);
                c_lval(i)           := i_c_low(i);
                c_mode_val_tmp(i)   := i_c_mode(i);
                c_ph_val_orig(i)    <= i_c_ph(i);
                c_high_val_hold(i)  <= i_c_high(i);
                c_low_val_hold(i)   <= i_c_low(i);
                c_mode_val_hold(i)  <= i_c_mode(i);
            end loop;

            

            if (pll_type = "fast" OR (pll_type = "left_right")) then
                scan_chain_length := FAST_SCAN_CHAIN;
            else
                scan_chain_length := GPP_SCAN_CHAIN;
            end if;

               
            if (pll_type = "fast" or pll_type = "lvds" OR (pll_type = "left_right")) then
                num_output_cntrs <= 7;
            else
                num_output_cntrs <= 10;
            end if;

            init := false;
        elsif (scandone_tmp'EVENT AND scandone_tmp = '1') then
            c0_rising_edge_transfer_done := false;
            c1_rising_edge_transfer_done := false;
            c2_rising_edge_transfer_done := false;
            c3_rising_edge_transfer_done := false;
            c4_rising_edge_transfer_done := false;
            c5_rising_edge_transfer_done := false;
            c6_rising_edge_transfer_done := false;
            c7_rising_edge_transfer_done := false;
            c8_rising_edge_transfer_done := false;
            c9_rising_edge_transfer_done := false;
            update_conf_latches_reg <= '0';
        elsif (update_conf_latches'event and update_conf_latches = '1') then
            initiate_reconfig <= '1';
        elsif (areset_ipd'event AND areset_ipd = '1') then
            if (scandone_tmp = '0') then scandone_tmp <= '1' AFTER scanclk_period; end if;
        elsif (scanclk_ipd'event and scanclk_ipd = '1') then
            IF (initiate_reconfig = '1') THEN
                initiate_reconfig <= '0';
                ASSERT false REPORT "PLL Reprogramming Initiated" severity note;

                update_conf_latches_reg <= update_conf_latches;
                reconfig_err <= false;
                scandone_tmp <= '0';
                cp_curr_old <= cp_curr_val;    
                lfc_old <= lfc_val;    
                lfr_old <= lfr_val;    
                vco_old <= vco_cur;   
                -- LF unused : bit 0,1
                -- LF Capacitance : bits 2,3 : all values are legal
                buf_scan_data := scan_data(2 TO 3);

                IF ((pll_type = "fast") OR (pll_type = "lvds") OR (pll_type = "left_right")) THEN
                    lfc_val <= fpll_loop_filter_c_arr(alt_conv_integer(buf_scan_data));    
                ELSE
                    lfc_val <= loop_filter_c_arr(alt_conv_integer(buf_scan_data));    
                END IF;
                -- LF Resistance : bits 4-8
                -- valid values - 00000,00100,10000,10100,11000,11011,11100,11110
                IF (scan_data(4 TO 8) = "00000") THEN
                    lfr_val <= "20";
                ELSIF (scan_data(4 TO 8) = "00100") THEN
                    lfr_val <= "16";
                ELSIF (scan_data(4 TO 8) = "10000") THEN
                    lfr_val <= "12";
                ELSIF (scan_data(4 TO 8) = "10100") THEN
                    lfr_val <= "08";
                ELSIF (scan_data(4 TO 8) = "11000") THEN
                    lfr_val <= "06";
                ELSIF (scan_data(4 TO 8) = "11011") THEN
                    lfr_val <= "04";
                ELSIF (scan_data(4 TO 8) = "11100") THEN
                    lfr_val <= "02"; 
                ELSE 
                    lfr_val <= "01";
                END IF;
            
             
                -- VCO post scale assignment   
                if (scan_data(9) = '1') then  -- vco_post_scale = 1
                    i_vco_max <= VCO_MAX_NO_DIVISION/2;
                    i_vco_min <= VCO_MIN_NO_DIVISION/2;
                    vco_cur <= 1;
                else
                    i_vco_max <= vco_max;
                    i_vco_min <= vco_min;  
                    vco_cur <= 2;
                end if;             
                -- CP
                -- Bit 9 : CRBYPASS
                -- Bit 10-14 : unused
                -- Bits 15-17 : all values are legal
        
                buf_scan_data_2 := scan_data(15 TO 17); 
                cp_curr_val <= charge_pump_curr_arr(alt_conv_integer(buf_scan_data_2));    
                -- save old values for display info.
                
                cp_curr_val_bit_setting <= scan_data(15 TO 17);
                lfc_val_bit_setting <= scan_data(2 TO 3);
                lfr_val_bit_setting <= scan_data(4 TO 8);
                
                m_val_old <= m_val;    
                n_val_old <= n_val;    
                m_mode_val_old <= m_mode_val;    
                n_mode_val_old <= n_mode_val;    
                WHILE (i < num_output_cntrs) LOOP
                    c_high_val_old(i) <= c_high_val(i);    
                    c_low_val_old(i) <= c_low_val(i);    
                    c_mode_val_old(i) <= c_mode_val(i);    
                    i := i + 1;
                END LOOP;
                -- M counter
                -- 1. Mode - bypass (bit 18)
                
                IF (scan_data(18) = '1') THEN
                    m_mode_val <= "bypass";  
                -- 3. Mode - odd/even (bit 27)
                ELSIF (scan_data(27) = '1') THEN
                    m_mode_val <= "   odd";    
                ELSE
                    m_mode_val <= "  even"; 
                END IF;
        
                -- 2. High (bit 19-26)
                
                m_hi := scan_data(19 TO 26);    
                
                -- 4. Low (bit 28-35)
                
                m_lo := scan_data(28 TO 35);    
                -- N counter
                -- 1. Mode - bypass (bit 36)
                
                IF (scan_data(36) = '1') THEN
                    n_mode_val <= "bypass"; 
                -- 3. Mode - odd/even (bit 45)
                ELSIF  (scan_data(45) = '1') THEN
                    n_mode_val <= "   odd";   
                ELSE
                    n_mode_val <= "  even";   
                END IF;
        
                -- 2. High (bit 37-44)
                
                n_hi := scan_data(37 TO 44);    
                
                -- 4. Low (bit 46-53)
                
                n_lo := scan_data(46 TO 53);    
                -- C counters (start bit 54) bit 1:mode(bypass),bit 2-9:high,bit 10:mode(odd/even),bit 11-18:low
                
                i := 0;
                WHILE (i < num_output_cntrs) LOOP
                    -- 1. Mode - bypass
                    
                    IF (scan_data(54 + i * 18 + 0) = '1') THEN
                        c_mode_val_tmp(i) := "bypass";    
                    -- 3. Mode - odd/even
                    ELSIF (scan_data(54 + i * 18 + 9) = '1') THEN
                        c_mode_val_tmp(i) := "   odd";    
                    ELSE
                        c_mode_val_tmp(i) := "  even";  
                    END IF;
                    -- 2. Hi
                    
                    high := scan_data(54 + i * 18 + 1 TO 54 + i * 18 + 8);
                    c_hval(i) := alt_conv_integer(high);
                    IF (c_hval(i) /= 0) THEN
                        c_high_val_tmp(i) := c_hval(i);
                    ELSE
                        c_high_val_tmp(i) := alt_conv_integer("000000001");
                    END IF;
                    
                    -- 4. Low 
                    
                    low := scan_data(54 + i * 18 + 10 TO 54 + i * 18 + 17);
                    c_lval(i) := alt_conv_integer(low);
                    IF (c_lval(i) /= 0) THEN
                        c_low_val_tmp(i) := c_lval(i);
                    ELSE
                        c_low_val_tmp(i) := alt_conv_integer("000000001");
                    END IF;
                    i := i + 1;
                END LOOP;
        -- Legality Checks
               
                --  M counter value
    IF(scan_data(18) /= '1') THEN
        IF ((m_hi /= m_lo) and (scan_data(27) /= '1')) THEN
                        reconfig_err <= TRUE;    
                        WRITE(buf,string'("Warning : The M counter of the " & family_name & " Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work"));   
                        writeline(output, buf);
                    ELSIF (m_hi /= "00000000") THEN
                        m_val_tmp := alt_conv_integer(m_hi) + alt_conv_integer(m_lo);    
                    ELSE
                        m_val_tmp := alt_conv_integer("000000001");
                    END IF;
                ELSE
                    m_val_tmp := alt_conv_integer("10000000");
                END IF;
                -- N counter value
    IF(scan_data(36) /= '1') THEN
        IF ((n_hi /= n_lo)and (scan_data(45) /= '1')) THEN
                    reconfig_err <= TRUE;    
                    WRITE(buf,string'("Warning : The N counter of the " & family_name & " Fast PLL should be configured for 50%% duty cycle only. In this case the HIGH and LOW moduli programmed will result in a duty cycle other than 50%%, which is illegal. Reconfiguration may not work"));   
                    writeline(output, buf);
                ELSIF (n_hi /= "00000000") THEN
                    n_val <= alt_conv_integer(n_hi) + alt_conv_integer(n_lo);    
                ELSE
                    n_val <= alt_conv_integer("000000001");
                END IF;
                ELSE
                    n_val <= alt_conv_integer("10000000");
                END IF;
                -- TODO : Give warnings/errors in the following cases?
                -- 1. Illegal counter values (error)
                -- 2. Change of mode (warning)
                -- 3. Only 50% duty cycle allowed for M counter (odd mode - hi-lo=1,even - hi-lo=0)
                
            END IF;
        end if;

        
        if (fbclk'event and fbclk = '1') then
            m_val <= m_val_tmp;
        end if;
        
        if (update_conf_latches_reg = '1') then
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c0_rising_edge_transfer_done := true;
                c_high_val(0) <= c_high_val_tmp(0);
                c_mode_val(0) <= c_mode_val_tmp(0);
            end if;
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c1_rising_edge_transfer_done := true;
                c_high_val(1) <= c_high_val_tmp(1);
                c_mode_val(1) <= c_mode_val_tmp(1);
            end if;
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c2_rising_edge_transfer_done := true;
                c_high_val(2) <= c_high_val_tmp(2);
                c_mode_val(2) <= c_mode_val_tmp(2);
            end if;
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(3) <= c_high_val_tmp(3);
                c_mode_val(3) <= c_mode_val_tmp(3);
                c3_rising_edge_transfer_done := true;
            end if;
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(4) <= c_high_val_tmp(4);
                c_mode_val(4) <= c_mode_val_tmp(4);
                c4_rising_edge_transfer_done := true;
            end if;
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(5) <= c_high_val_tmp(5);
                c_mode_val(5) <= c_mode_val_tmp(5);
                c5_rising_edge_transfer_done := true;
            end if;
    
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(6) <= c_high_val_tmp(6);
                c_mode_val(6) <= c_mode_val_tmp(6);
                c6_rising_edge_transfer_done := true;
            end if;
    
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(7) <= c_high_val_tmp(7);
                c_mode_val(7) <= c_mode_val_tmp(7);
                c7_rising_edge_transfer_done := true;
            end if;
    
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(8) <= c_high_val_tmp(8);
                c_mode_val(8) <= c_mode_val_tmp(8);
                c8_rising_edge_transfer_done := true;
            end if;
    
            if (scanclk_ipd'event and scanclk_ipd = '1') then
                c_high_val(9) <= c_high_val_tmp(9);
                c_mode_val(9) <= c_mode_val_tmp(9);
                c9_rising_edge_transfer_done := true;
            end if;
    
        end if;

        if (scanclk_ipd'event and scanclk_ipd = '0' and c0_rising_edge_transfer_done) then
            c_low_val(0) <= c_low_val_tmp(0);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c1_rising_edge_transfer_done) then
            c_low_val(1) <= c_low_val_tmp(1);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c2_rising_edge_transfer_done) then
            c_low_val(2) <= c_low_val_tmp(2);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c3_rising_edge_transfer_done) then
            c_low_val(3) <= c_low_val_tmp(3);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c4_rising_edge_transfer_done) then
            c_low_val(4) <= c_low_val_tmp(4);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c5_rising_edge_transfer_done) then
            c_low_val(5) <= c_low_val_tmp(5);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c6_rising_edge_transfer_done) then
            c_low_val(6) <= c_low_val_tmp(6);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c7_rising_edge_transfer_done) then
            c_low_val(7) <= c_low_val_tmp(7);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c8_rising_edge_transfer_done) then
            c_low_val(8) <= c_low_val_tmp(8);
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '0' and c9_rising_edge_transfer_done) then
            c_low_val(9) <= c_low_val_tmp(9);
        end if;

        if (update_phase = '1') then
            if (vco_out(0)'event and vco_out(0) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 0) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 0) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(1)'event and vco_out(1) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 1) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 1) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(2)'event and vco_out(2) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 2) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 2) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(3)'event and vco_out(3) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 3) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 3) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(4)'event and vco_out(4) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 4) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 4) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(5)'event and vco_out(5) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 5) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 5) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(6)'event and vco_out(6) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 6) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 6) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(7)'event and vco_out(7) = '0') then
                for i in 0 to 9 loop
                    if (c_ph_val(i) = 7) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 7) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
        end if;

        

        if (vco_out(0)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 0) then
                    inclk_c_from_vco(i) <= vco_out(0);
                end if;
            end loop;
            if (m_ph_val = 0) then
                inclk_m_from_vco <= vco_out(0);
            end if;
        end if;
        if (vco_out(1)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 1) then
                    inclk_c_from_vco(i) <= vco_out(1);
                end if;
            end loop;
            if (m_ph_val = 1) then
                inclk_m_from_vco <= vco_out(1);
            end if;
        end if;
        if (vco_out(2)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 2) then
                    inclk_c_from_vco(i) <= vco_out(2);
                end if;
            end loop;
            if (m_ph_val = 2) then
                inclk_m_from_vco <= vco_out(2);
            end if;
        end if;
        if (vco_out(3)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 3) then
                    inclk_c_from_vco(i) <= vco_out(3);
                end if;
            end loop;
            if (m_ph_val = 3) then
                inclk_m_from_vco <= vco_out(3);
            end if;
        end if;
        if (vco_out(4)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 4) then
                    inclk_c_from_vco(i) <= vco_out(4);
                end if;
            end loop;
            if (m_ph_val = 4) then
                inclk_m_from_vco <= vco_out(4);
            end if;
        end if;
        if (vco_out(5)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 5) then
                    inclk_c_from_vco(i) <= vco_out(5);
                end if;
            end loop;
            if (m_ph_val = 5) then
                inclk_m_from_vco <= vco_out(5);
            end if;
        end if;
        if (vco_out(6)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 6) then
                    inclk_c_from_vco(i) <= vco_out(6);
                end if;
            end loop;
            if (m_ph_val = 6) then
                inclk_m_from_vco <= vco_out(6);
            end if;
        end if;
        if (vco_out(7)'event) then
                for i in 0 to 9 loop
                if (c_ph_val(i) = 7) then
                    inclk_c_from_vco(i) <= vco_out(7);
                end if;
            end loop;
            if (m_ph_val = 7) then
                inclk_m_from_vco <= vco_out(7);
            end if;
        end if;
        

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
             SetupHigh       => tsetup_scandata_scanclk_noedge_negedge,
             SetupLow        => tsetup_scandata_scanclk_noedge_negedge,
             HoldHigh        => thold_scandata_scanclk_noedge_negedge,
             HoldLow         => thold_scandata_scanclk_noedge_negedge,
                   CheckEnabled    => TRUE,
             RefTransition   => '\',
             HeaderMsg       => InstancePath & "/stratixiii_pll",
             XOn             => XOnChecks,
             MsgOn           => MsgOnChecks );



        VitalSetupHoldCheck (
             Violation       => Tviol_scanclkena_scanclk,
             TimingData      => TimingData_scanclkena_scanclk,
             TestSignal      => scanclkena_ipd,
             TestSignalName  => "scanclkena",
             RefSignal       => scanclk_ipd,
             RefSignalName   => "scanclk",
             SetupHigh       => tsetup_scanclkena_scanclk_noedge_negedge,
             SetupLow        => tsetup_scanclkena_scanclk_noedge_negedge,
             HoldHigh        => thold_scanclkena_scanclk_noedge_negedge,
             HoldLow         => thold_scanclkena_scanclk_noedge_negedge,
                   CheckEnabled    => TRUE,
             RefTransition   => '\',
             HeaderMsg       => InstancePath & "/stratixiii_pll",
             XOn             => XOnChecks,
             MsgOn           => MsgOnChecks );

     end if;
   
        if (scanclk_ipd'event AND scanclk_ipd = '0' AND now > 0 ps) then
            scanclkena_reg <= scanclkena_ipd;
            if (scanclkena_reg = '1') then
                scandata_in <= scandata_ipd;
                scandata_out <= scandataout_tmp;
            end if;
        end if;
        if (scanclk_ipd'event and scanclk_ipd = '1' and now > 0 ps) then
            if (got_first_scanclk) then
                scanclk_period <= now - scanclk_last_rising_edge;
            else
                got_first_scanclk := true;
            end if;
            if (scanclkena_reg = '1') then
            for j in scan_chain_length - 1 downto 1 loop
                scan_data(j) <= scan_data(j-1);
            end loop;
            scan_data(0) <= scandata_in;
            end if;
            scanclk_last_rising_edge := now;
        end if;
    end process;

-- PLL Phase Reconfiguration

PROCESS(scanclk_ipd, areset_ipd,phasestep_ipd)
    VARIABLE i : INTEGER := 0;
    VARIABLE c_ph : INTEGER := 0;
    VARIABLE m_ph : INTEGER := 0;
    VARIABLE select_counter :  INTEGER := 0;
BEGIN
    IF (NOW = 0 ps) THEN
        m_ph_val_tmp <= m_ph_initial;
    END IF;
            
    -- Latch phase enable (same as phasestep) on neg edge of scan clock
    IF (scanclk_ipd'EVENT AND scanclk_ipd = '0') THEN
        phasestep_reg <= phasestep_ipd;
    END IF;  
     
    IF (phasestep_ipd'EVENT and phasestep_ipd = '1') THEN
        IF (update_phase = '0') THEN 
            phasestep_high_count <= 0;  -- phase adjustments must be 1 cycle apart
                                        -- if not, next phasestep cycle is skipped
        END IF;
    END IF;     
    -- revert counter phase tap values to POF programmed values
    -- if PLL is reset

    IF (areset_ipd'EVENT AND areset_ipd = '1') then
            c_ph_val_tmp <= c_ph_val_orig;
            m_ph_val_tmp <= m_ph_initial;
    END IF;
    
    IF (scanclk_ipd'EVENT AND scanclk_ipd = '1') THEN
    IF (phasestep_reg = '1') THEN
        IF (phasestep_high_count = 1) THEN
            phasecounterselect_reg <= phasecounterselect_ipd;
            phaseupdown_reg <= phaseupdown_ipd;
            -- start reconfiguration
            IF (phasecounterselect_ipd < "1100") THEN -- no counters selected 
            IF (phasecounterselect_ipd = "0000") THEN
                            i := 0;
                            WHILE (i < num_output_cntrs) LOOP
                                c_ph := c_ph_val(i);
                                IF (phaseupdown_ipd = '1') THEN
                                    c_ph := (c_ph + 1) mod num_phase_taps;
                                ELSIF (c_ph = 0) THEN
                                    c_ph := num_phase_taps - 1;
                                ELSE
                                    c_ph := (c_ph - 1) mod num_phase_taps;
                                END IF;
                                c_ph_val_tmp(i) <= c_ph;
                                i := i + 1;
                            END LOOP;
            ELSIF (phasecounterselect_ipd = "0001") THEN
                            m_ph := m_ph_val;
                            IF (phaseupdown_ipd = '1') THEN
                                m_ph := (m_ph + 1) mod num_phase_taps;
                            ELSIF (m_ph = 0) THEN
                                m_ph := num_phase_taps - 1;
                            ELSE
                                m_ph := (m_ph - 1) mod num_phase_taps;
                            END IF;
                            m_ph_val_tmp <= m_ph;
                        ELSE
                            select_counter := alt_conv_integer(phasecounterselect_ipd) - 2;
                            c_ph := c_ph_val(select_counter);
                            IF (phaseupdown_ipd = '1') THEN
                                c_ph := (c_ph + 1) mod num_phase_taps;
                            ELSIF (c_ph = 0) THEN
                                c_ph := num_phase_taps - 1;
                            ELSE
                                c_ph := (c_ph - 1) mod num_phase_taps;
                            END IF;
                                c_ph_val_tmp(select_counter) <= c_ph;
                        END IF; 
                        update_phase <= '1','0' AFTER (0.5 * scanclk_period);
                    END IF;
                END IF;
                phasestep_high_count <= phasestep_high_count + 1; 
       
        END IF;
    END IF;
END PROCESS;

    scandataout_tmp <= scan_data(FAST_SCAN_CHAIN-2) when (pll_type = "fast" or pll_type = "lvds" or pll_type = "left_right") else scan_data(GPP_SCAN_CHAIN-2);

    process (schedule_vco, areset_ipd, pfdena_ipd, refclk, fbclk)
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
    variable cycles_pfd_low : integer := 0;
    variable cycles_pfd_high : integer := 0;
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
    variable buf : line;
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
                refclk_period := inclk0_input_frequency * n_val * 1 ps;

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
            pll_is_locked := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;
        end if;

        if (areset_ipd = '1') then
            pll_is_in_reset := true;
            got_first_refclk := false;
            got_second_refclk := false;

            -- drop VCO taps to 0
            for i in 0 to 7 loop
                vco_out(i) <= transport '0' after 1 ps;
            end loop;
        end if;


        if (schedule_vco'event and (areset_ipd = '1' or stop_vco)) then

            -- drop VCO taps to 0
            for i in 0 to 7 loop
                vco_out(i) <= transport '0' after last_phase_shift(i);
                phase_shift(i) := 0 ps;
                last_phase_shift(i) := 0 ps;
            end loop;

            -- reset lock parameters
            pll_is_locked := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;

            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := 0 ps;
            got_first_fbclk := false;
            fbclk_time := 0 ps;
            first_fbclk_time := 0 ps;
            fbclk_period := 0 ps;

            first_schedule := true;
            vco_val := '0';
            vco_period_was_phase_adjusted := false;
            phase_adjust_was_scheduled := false;

        elsif ((schedule_vco'event or areset_ipd'event) and areset_ipd = '0'  and (not stop_vco) and now > 0 ps) then

            -- note areset deassert time
            -- note it as refclk_time to prevent false triggering
            -- of stop_vco after areset
            if (areset_ipd'event and areset_ipd = '0' and pll_is_in_reset) then
                refclk_time := now;
                locked_tmp := '0';
            end if;

            pll_is_in_reset := false;
            -- calculate loop_xplier : this will be different from m_val
            -- in external_feedback_mode
            loop_xplier := m_val;
            loop_initial := m_initial_val - 1;
            loop_ph := m_ph_val;


            -- convert initial value to delay
            initial_delay := (loop_initial * m_times_vco_period)/loop_xplier;

            -- convert loop ph_tap to delay
            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            tmp_vco_per := (m_times_vco_period/1 ps) / loop_xplier;
            if (my_rem /= 0) then
                tmp_vco_per := tmp_vco_per + 1;
            end if;
            fbk_phase := (loop_ph * tmp_vco_per)/8;

            pull_back_M := initial_delay/1 ps + fbk_phase;

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
            
            fbk_delay := total_pull_back - fbk_phase;
            if (fbk_delay < 0) then
                offset := offset - (fbk_phase * 1 ps);
                fbk_delay := total_pull_back;
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

                    -- schedule the phase taps
                    for k in 0 to 7 loop
                        phase_shift(k) := (k * vco_per)/8;
                        if (first_schedule) then
                            vco_out(k) <= transport vco_val after (sched_time + phase_shift(k));
                        else
                            vco_out(k) <= transport vco_val after (sched_time + last_phase_shift(k));
                        end if;
                    end loop;
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
                -- schedule the phase taps
                for k in 0 to 7 loop
                    phase_shift(k) := (k * vco_per)/8;
                    vco_out(k) <= transport vco_val after (sched_time + phase_shift(k));
                end loop;
                first_schedule := false;
            end if;

            schedule_vco <= transport not schedule_vco after sched_time;

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
-- Bypass lock detect

if (refclk'event and refclk = '1' and areset_ipd = '0') then
    if (test_bypass_lock_detect = "on") then
        if (pfdena_ipd = '1') then
            cycles_pfd_low := 0;
            if (pfd_locked = '0') then
                if (cycles_pfd_high = lock_high) then
                    assert false report family_name & " PLL locked in test mode on PFD enable assertion." severity warning;
                    pfd_locked <= '1';
                end if;
                cycles_pfd_high := cycles_pfd_high + 1;
            end if;
        end if;
        
        if (pfdena_ipd = '0') then
            cycles_pfd_high := 0;
            if (pfd_locked = '1') then
                if (cycles_pfd_low = lock_low) then
                    assert false report family_name & " PLL lost lock in test mode on PFD enable de-assertion." severity warning;
                    pfd_locked <= '0';
                end if;
                cycles_pfd_low := cycles_pfd_low + 1;
            end if;
        end if;
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
                if ( (i_vco_max /= 0 and i_vco_min /= 0 and pfdena_ipd = '1') and
                    (((refclk_period/1 ps)/loop_xplier > i_vco_max) or
                    ((refclk_period/1 ps)/loop_xplier < i_vco_min)) ) then
                    if (pll_is_locked) then
                        if ((refclk_period/1 ps)/loop_xplier > i_vco_max) then
                            assert false report "Input clock freq. is over VCO range. " & family_name & " PLL may lose lock" severity warning;
                            vco_over <= '1';
                        end if;
                        if ((refclk_period/1 ps)/loop_xplier < i_vco_min) then
                            assert false report "Input clock freq. is under VCO range. " & family_name & " PLL may lose lock" severity warning;
                            vco_under <= '1';
                        end if;
                        if (inclk_out_of_range) then
                            pll_is_locked := false;
                            locked_tmp := '0';
                            cycles_to_lock := 0;
                            vco_period_was_phase_adjusted := false;
                            phase_adjust_was_scheduled := false;
                            assert false report family_name & " PLL lost lock." severity note;
                        end if;
                    elsif (not no_warn) then
                        if ((refclk_period/1 ps)/loop_xplier > i_vco_max) then
                            assert false report "Input clock freq. is over VCO range. " & family_name & " PLL may lose lock" severity warning;
                            vco_over <= '1';
                        end if;
                        if ((refclk_period/1 ps)/loop_xplier < i_vco_min) then
                            assert false report "Input clock freq. is under VCO range. " & family_name & " PLL may lose lock" severity warning;
                            vco_under <= '1';
                        end if;
                        assert false report " Input clock freq. is not within VCO range : " & family_name & " PLL may not lock. Please use the correct frequency." severity warning;
                        no_warn := true;
                    end if;
                    inclk_out_of_range := true;
                else
                    vco_over  <= '0';
                    vco_under <= '0';
                    inclk_out_of_range := false;
                    no_warn := false;
                end if;
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

-- Update M counter value on feedback clock edge

        if (fbclk'event and fbclk = '1') then
            got_fbclk_posedge := true;
            if (not got_first_fbclk) then
                got_first_fbclk := true;
            else
                fbclk_period := now - fbclk_time;
            end if;

            -- need refclk_period here, so initialized to proper value above
            if ( ( (now - refclk_time > 1.5 * refclk_period) and pfdena_ipd = '1' and pll_is_locked) or
                ( (now - refclk_time > 5 * refclk_period) and pfdena_ipd = '1' and pll_has_just_been_reconfigured = false) or
                ( (now - refclk_time > 50 * refclk_period) and pfdena_ipd = '1' and pll_has_just_been_reconfigured = true) ) then
                stop_vco := true;
                -- reset
                got_first_refclk := false;
                got_first_fbclk := false;
                got_second_refclk := false;
                if (pll_is_locked) then
                    pll_is_locked := false;
                    locked_tmp := '0';
                    assert false report family_name & " PLL lost lock due to loss of input clock or the input clock is not detected within the allowed time frame." severity note;
                    if ((i_vco_max = 0) and (i_vco_min = 0)) then
                        assert false report "Please run timing simulation to check whether the input clock is operating within the supported VCO range or not." severity note;
                    end if;
                end if;
                cycles_to_lock := 0;
                cycles_to_unlock := 0;
                first_schedule := true;
                vco_period_was_phase_adjusted := false;
                phase_adjust_was_scheduled := false;
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
                if (cycles_to_lock = real_lock_high) then
                    if (not pll_is_locked) then
                        assert false report family_name & " PLL locked to incoming clock" severity note;
                    end if;
                    pll_is_locked := true;
                    locked_tmp := '1';
                    cycles_to_unlock := 0;
                end if;
                -- increment lock counter only if second part of above
                -- time check is NOT true
                if (not(abs(refclk_period - abs(fbclk_time - refclk_time)) <= lock_window)) then
                    cycles_to_lock := cycles_to_lock + 1;
                end if;

                -- adjust m_times_vco_period
                new_m_times_vco_period := refclk_period;
            else
                -- if locked, begin unlock
                if (pll_is_locked) then
                    cycles_to_unlock := cycles_to_unlock + 1;
                    if (cycles_to_unlock = lock_low) then
                        pll_is_locked := false;
                        locked_tmp := '0';
                        cycles_to_lock := 0;
                        vco_period_was_phase_adjusted := false;
                        phase_adjust_was_scheduled := false;
                        assert false report family_name & " PLL lost lock." severity note;
                        got_first_refclk := false;
                        got_first_fbclk := false;
                        got_second_refclk := false;
                    end if;
                end if;
                if ( abs(refclk_period - fbclk_period) <= 2 ps ) then
                    -- frequency is still good
                    if (now = fbclk_time and (not phase_adjust_was_scheduled)) then
                        if ( abs(fbclk_time - refclk_time) > refclk_period/2) then
                            new_m_times_vco_period := m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                            vco_period_was_phase_adjusted := true;
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

        -- signal to calculate quiet_time
        sig_refclk_period <= refclk_period;

        if (stop_vco = true) then
            sig_stop_vco <= '1';
        else
            sig_stop_vco <= '0';
        end if;
        
        pll_locked <= pll_is_locked;
    end process;

    clk0_tmp <= c_clk(i_clk0_counter);
    clk_pfd(0) <= clk0_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(0)   <= clk_pfd(0) WHEN (test_bypass_lock_detect = "on") ELSE 
                clk0_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else
                'X';

    clk1_tmp <= c_clk(i_clk1_counter);
    clk_pfd(1) <= clk1_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(1)   <= clk_pfd(1) WHEN (test_bypass_lock_detect = "on") ELSE
                clk1_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';

    clk2_tmp <= c_clk(i_clk2_counter);
    clk_pfd(2) <= clk2_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(2)   <= clk_pfd(2) WHEN (test_bypass_lock_detect = "on") ELSE
                clk2_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';

    clk3_tmp <= c_clk(i_clk3_counter);
    clk_pfd(3) <= clk3_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(3)   <= clk_pfd(3) WHEN (test_bypass_lock_detect = "on") ELSE
                clk3_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';

    clk4_tmp <= c_clk(i_clk4_counter);
    clk_pfd(4) <= clk4_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(4)   <= clk_pfd(4) WHEN (test_bypass_lock_detect = "on") ELSE
                clk4_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';

    clk5_tmp <= c_clk(i_clk5_counter);
    clk_pfd(5) <= clk5_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(5)   <= clk_pfd(5) WHEN (test_bypass_lock_detect = "on") ELSE
                clk5_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';


    clk6_tmp <= c_clk(i_clk6_counter);
    clk_pfd(6) <= clk6_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(6)   <= clk_pfd(6) WHEN (test_bypass_lock_detect = "on") ELSE
                clk6_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';


    clk7_tmp <= c_clk(i_clk7_counter);
    clk_pfd(7) <= clk7_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(7)   <= clk_pfd(7) WHEN (test_bypass_lock_detect = "on") ELSE
                clk7_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';


    clk8_tmp <= c_clk(i_clk8_counter);
    clk_pfd(8) <= clk8_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(8)   <= clk_pfd(8) WHEN (test_bypass_lock_detect = "on") ELSE
                clk8_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';


    clk9_tmp <= c_clk(i_clk9_counter);
    clk_pfd(9) <= clk9_tmp WHEN (pfd_locked = '1') ELSE 'X';
    clk(9)   <= clk_pfd(9) WHEN (test_bypass_lock_detect = "on") ELSE
                clk9_tmp when (areset_ipd = '1' or pll_in_test_mode) or (pll_locked and (not reconfig_err)) else 'X';



scandataout <= scandata_out;
scandone <= NOT scandone_tmp;
phasedone <= NOT update_phase;
vcooverrange <= 'Z' WHEN (vco_range_detector_high_bits = -1) ELSE vco_over;
vcounderrange <= 'Z' WHEN (vco_range_detector_low_bits = -1) ELSE vco_under;
fbout <= fbclk;
end vital_pll;
-- END ARCHITECTURE VITAL_PLL
-------------------------------------------------------------------
--
-- Entity Name : stratixiii_asmiblock
--
-- Description : Stratix III ASMIBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

entity  stratixiii_asmiblock is
    generic (
        lpm_type : string := "stratixiii_asmiblock"
        );	
    port (
        dclkin : in std_logic := '0'; 
        scein : in std_logic := '0'; 
        sdoin : in std_logic := '0'; 
        data0in : in std_logic := '0'; 
        oe : in std_logic := '0'; 
        dclkout : out std_logic; 
        sceout : out std_logic; 
        sdoout : out std_logic; 
        data0out: out std_logic
        );
end stratixiii_asmiblock;

architecture architecture_asmiblock of stratixiii_asmiblock is
begin

end architecture_asmiblock;  -- end of stratixiii_asmiblock
--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixiii_lvds_reg
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
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_lvds_reg is
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
END stratixiii_lvds_reg;

ARCHITECTURE vital_stratixiii_lvds_reg of stratixiii_lvds_reg is


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

end vital_stratixiii_lvds_reg;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixiii_lvds_rx_fifo_sync_ram
--
-- Description :
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_lvds_rx_fifo_sync_ram is
    PORT ( clk                     : IN std_logic;
           datain                  : IN std_logic := '0';
           writereset             : IN std_logic := '0';
           waddr                   : IN std_logic_vector(2 DOWNTO 0) := "000";
           raddr                   : IN std_logic_vector(2 DOWNTO 0) := "000";
           we                      : IN std_logic := '0';
           dataout                 : OUT std_logic
         );

END stratixiii_lvds_rx_fifo_sync_ram;

ARCHITECTURE vital_arm_lvds_rx_fifo_sync_ram OF stratixiii_lvds_rx_fifo_sync_ram IS

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
-- Module Name : stratixiii_lvds_rx_fifo
--
-- Description :
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;
USE work.stratixiii_lvds_rx_fifo_sync_ram;

ENTITY stratixiii_lvds_rx_fifo is
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

END stratixiii_lvds_rx_fifo;

ARCHITECTURE vital_arm_lvds_rx_fifo of stratixiii_lvds_rx_fifo is
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

    COMPONENT stratixiii_lvds_rx_fifo_sync_ram
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
    s_fifo_ram : stratixiii_lvds_rx_fifo_sync_ram
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
-- Module Name : stratixiii_lvds_rx_bitslip
--
-- Description :
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE, std;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;
USE work.stratixiii_lvds_reg;

ENTITY stratixiii_lvds_rx_bitslip is
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
END stratixiii_lvds_rx_bitslip;

ARCHITECTURE vital_arm_lvds_rx_bitslip OF stratixiii_lvds_rx_bitslip IS
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

    COMPONENT stratixiii_lvds_reg
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

    bslipcntlreg : stratixiii_lvds_reg
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

    slip_data <= bitslip_arr(slip_count);

    dataoutreg : stratixiii_lvds_reg
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
-- Module Name : stratixiii_lvds_rx_deser
--
-- Description : Timing simulation model for the stratixiii LVDS RECEIVER
--               DESERIALIZER. This module receives serial data and outputs
--               parallel data word of width = channel width
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_lvds_rx_deser IS
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

END stratixiii_lvds_rx_deser;

ARCHITECTURE vital_arm_lvds_rx_deser OF stratixiii_lvds_rx_deser IS

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
-- Module Name : stratixiii_lvds_rx_parallel_reg
--
-- Description : Timing simulation model for the stratixiii LVDS RECEIVER
--               PARALLEL REGISTER. The data width equals max. channel width,
--               which is 10.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;

ENTITY stratixiii_lvds_rx_parallel_reg IS
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

END stratixiii_lvds_rx_parallel_reg;

ARCHITECTURE vital_arm_lvds_rx_parallel_reg OF stratixiii_lvds_rx_parallel_reg IS
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

  -------------------------------------------------------------------------------
  --
  -- Module Name : stratixiii_pclk_divider
  --
  -- Description : Simulation model for a clock divider
  --               output clock is divided by value specified
  --                 in the parameter clk_divide_by
  --
  -------------------------------------------------------------------------------

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY stratixiii_pclk_divider IS
   GENERIC (
      clk_divide_by                  :  integer := 1);
   PORT (
      clkin                   : IN std_logic;
      lloaden                 : OUT std_logic;
      clkout                  : OUT std_logic);
END stratixiii_pclk_divider;

ARCHITECTURE arch OF stratixiii_pclk_divider IS

   SIGNAL lloaden_tmp : std_logic := '0';
   SIGNAL clkout_tmp               :  std_logic := '0';
   SIGNAL cnt                      :  std_logic_vector(4 DOWNTO 0):= (others => '0');

BEGIN
   clkout <= clkin WHEN (clk_divide_by = 1) ELSE clkout_tmp;
   lloaden <= lloaden_tmp;
   PROCESS(clkin)
   variable count               : std_logic := '0';
   variable start               :  std_logic := '0';
   variable prev_load           :  std_logic := '0';
   BEGIN

      IF(clkin = '1') THEN
           count := '1';
      END IF;
      if( count = '1') then
      IF (cnt < clk_divide_by) THEN
         clkout_tmp <= '0';
         cnt <= cnt + "00001";
      ELSE
         IF (cnt = (2 * clk_divide_by - 1)) THEN
            cnt <= "00000";
         ELSE
            clkout_tmp <= '1';
            cnt <= cnt + "00001";
         END IF;
      END IF;
      end if;
   END PROCESS;

    process( clkin, cnt )
    begin
        if( cnt =( 2*clk_divide_by -2) )then
            lloaden_tmp <= '1';
        else
            if(cnt = 0)then
                lloaden_tmp <= '0';
            end if;
        end if;
    end process;

END arch;

  -------------------------------------------------------------------------------
   --
   -- Module Name : stratixiii_select_ini_phase_dpaclk
   --
   -- Description : Simulation model for selecting the initial phase of the dpa clock
   --
   --
   -------------------------------------------------------------------------------

LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE IEEE.std_logic_arith.ALL;


ENTITY stratixiii_select_ini_phase_dpaclk IS
    GENERIC(
            initial_phase_select          :  integer := 0
            );
   PORT (

      clkin    : IN STD_LOGIC;
      loaden   : IN STD_LOGIC;
      enable   : IN STD_LOGIC;
      clkout     : OUT STD_LOGIC;
      loadenout     : OUT STD_LOGIC
   );
END stratixiii_select_ini_phase_dpaclk;

ARCHITECTURE trans OF stratixiii_select_ini_phase_dpaclk IS

   SIGNAL clk_period              : time := 0 ps;
   SIGNAL last_clk_period         : time := 0 ps;
   SIGNAL last_clkin_edge         : time := 0 ps;

   SIGNAL first_clkin_edge_detect : STD_LOGIC := '0';
   SIGNAL clk0_tmp                : STD_LOGIC;
   SIGNAL clk1_tmp                : STD_LOGIC;
   SIGNAL clk2_tmp                : STD_LOGIC;
   SIGNAL clk3_tmp                : STD_LOGIC;
   SIGNAL clk4_tmp                : STD_LOGIC;
   SIGNAL clk5_tmp                : STD_LOGIC;
   SIGNAL clk6_tmp                : STD_LOGIC;
   SIGNAL clk7_tmp                : STD_LOGIC;
   SIGNAL loaden0_tmp                : STD_LOGIC;
   SIGNAL loaden1_tmp                : STD_LOGIC;
   SIGNAL loaden2_tmp                : STD_LOGIC;
   SIGNAL loaden3_tmp                : STD_LOGIC;
   SIGNAL loaden4_tmp                : STD_LOGIC;
   SIGNAL loaden5_tmp                : STD_LOGIC;
   SIGNAL loaden6_tmp                : STD_LOGIC;
   SIGNAL loaden7_tmp                : STD_LOGIC;

   SIGNAL clkout_tmp                : STD_LOGIC;
   SIGNAL loadenout_tmp             : STD_LOGIC;

BEGIN
  clkout_tmp <=  clk1_tmp  when    (initial_phase_select = 1) else
                 clk2_tmp  when    (initial_phase_select = 2) else
                 clk3_tmp  when    (initial_phase_select = 3) else
                 clk4_tmp  when    (initial_phase_select = 4) else
                 clk5_tmp  when    (initial_phase_select = 5) else
                 clk6_tmp  when    (initial_phase_select = 6) else
                 clk7_tmp  when    (initial_phase_select = 7) else
                 clk0_tmp;

    clkout <= clkout_tmp when enable = '1' else clkin;

      loadenout_tmp <=  loaden1_tmp  when    (initial_phase_select = 1) else
                 loaden2_tmp  when    (initial_phase_select = 2) else
                 loaden3_tmp  when    (initial_phase_select = 3) else
                 loaden4_tmp  when    (initial_phase_select = 4) else
                 loaden5_tmp  when    (initial_phase_select = 5) else
                 loaden6_tmp  when    (initial_phase_select = 6) else
                 loaden7_tmp  when    (initial_phase_select = 7) else
                 loaden0_tmp;

    loadenout <= loadenout_tmp when enable = '1' else loaden;


   -- Calculate the clock period
   PROCESS
   VARIABLE clk_period_tmp : time := 0 ps;
   BEGIN
   WAIT UNTIL (clkin'EVENT AND clkin = '1');
      IF (first_clkin_edge_detect = '0') THEN
         first_clkin_edge_detect <= '1';
      ELSE
         last_clk_period <= clk_period;
         clk_period_tmp  := NOW - last_clkin_edge;
      END IF;

      last_clkin_edge <= NOW;
      clk_period <= clk_period_tmp;
   END PROCESS;

   -- Generate the phase shifted signals
   PROCESS (clkin)
   BEGIN
      clk0_tmp <= clkin;
      clk1_tmp <= TRANSPORT clkin after (clk_period * 0.125) ;
      clk2_tmp <= TRANSPORT clkin after (clk_period * 0.25) ;
      clk3_tmp <= TRANSPORT clkin after (clk_period * 0.375) ;
      clk4_tmp <= TRANSPORT clkin after (clk_period * 0.5) ;
      clk5_tmp <= TRANSPORT clkin after (clk_period * 0.625) ;
      clk6_tmp <= TRANSPORT clkin after (clk_period * 0.75) ;
      clk7_tmp <= TRANSPORT clkin after (clk_period * 0.875) ;
   END PROCESS;

   PROCESS (loaden)
   BEGIN
      loaden0_tmp <= clkin;
      loaden1_tmp <= TRANSPORT loaden after (clk_period * 0.125) ;
      loaden2_tmp <= TRANSPORT loaden after (clk_period * 0.25) ;
      loaden3_tmp <= TRANSPORT loaden after (clk_period * 0.375) ;
      loaden4_tmp <= TRANSPORT loaden after (clk_period * 0.5) ;
      loaden5_tmp <= TRANSPORT loaden after (clk_period * 0.625) ;
      loaden6_tmp <= TRANSPORT loaden after (clk_period * 0.75) ;
      loaden7_tmp <= TRANSPORT loaden after (clk_period * 0.875) ;
   END PROCESS;

END trans;

   -------------------------------------------------------------------------------
   --
   -- Module Name : stratixiii_dpa_retime_block
   --
   -- Description : Simulation model for generating the retimed clock,data and loaden.
   --               Each of the signals has 8 different phase shifted versions.
   --
   --
   -------------------------------------------------------------------------------

LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE IEEE.std_logic_arith.ALL;


ENTITY stratixiii_dpa_retime_block IS
   PORT (

      clkin    : IN STD_LOGIC;
      datain   : IN STD_LOGIC;
      reset    : IN STD_LOGIC;

      clk0     : OUT STD_LOGIC;
      clk1     : OUT STD_LOGIC;
      clk2     : OUT STD_LOGIC;
      clk3     : OUT STD_LOGIC;
      clk4     : OUT STD_LOGIC;
      clk5     : OUT STD_LOGIC;
      clk6     : OUT STD_LOGIC;
      clk7     : OUT STD_LOGIC;
      data0    : OUT STD_LOGIC;
      data1    : OUT STD_LOGIC;
      data2    : OUT STD_LOGIC;
      data3    : OUT STD_LOGIC;
      data4    : OUT STD_LOGIC;
      data5    : OUT STD_LOGIC;
      data6    : OUT STD_LOGIC;
      data7    : OUT STD_LOGIC;
      lock     : OUT STD_LOGIC
   );
END stratixiii_dpa_retime_block;

ARCHITECTURE trans OF stratixiii_dpa_retime_block IS

   SIGNAL clk_period              : time := 0 ps;
   SIGNAL last_clk_period         : time := 0 ps;
   SIGNAL last_clkin_edge         : time := 0 ps;

   SIGNAL first_clkin_edge_detect : STD_LOGIC := '0';
   SIGNAL clk0_tmp                : STD_LOGIC;
   SIGNAL clk1_tmp                : STD_LOGIC;
   SIGNAL clk2_tmp                : STD_LOGIC;
   SIGNAL clk3_tmp                : STD_LOGIC;
   SIGNAL clk4_tmp                : STD_LOGIC;
   SIGNAL clk5_tmp                : STD_LOGIC;
   SIGNAL clk6_tmp                : STD_LOGIC;
   SIGNAL clk7_tmp                : STD_LOGIC;
   SIGNAL data0_tmp               : STD_LOGIC;
   SIGNAL data1_tmp               : STD_LOGIC;
   SIGNAL data2_tmp               : STD_LOGIC;
   SIGNAL data3_tmp               : STD_LOGIC;
   SIGNAL data4_tmp               : STD_LOGIC;
   SIGNAL data5_tmp               : STD_LOGIC;
   SIGNAL data6_tmp               : STD_LOGIC;
   SIGNAL data7_tmp               : STD_LOGIC;
   SIGNAL lock_tmp                : STD_LOGIC := '0';
BEGIN

   clk0 <= '0' WHEN reset = '1' ELSE clk0_tmp;
   clk1 <= '0' WHEN reset = '1' ELSE clk1_tmp;
   clk2 <= '0' WHEN reset = '1' ELSE clk2_tmp;
   clk3 <= '0' WHEN reset = '1' ELSE clk3_tmp;
   clk4 <= '0' WHEN reset = '1' ELSE clk4_tmp;
   clk5 <= '0' WHEN reset = '1' ELSE clk5_tmp;
   clk6 <= '0' WHEN reset = '1' ELSE clk6_tmp;
   clk7 <= '0' WHEN reset = '1' ELSE clk7_tmp;

   data0 <= '0' WHEN reset = '1' ELSE data0_tmp;
   data1 <= '0' WHEN reset = '1' ELSE data1_tmp;
   data2 <= '0' WHEN reset = '1' ELSE data2_tmp;
   data3 <= '0' WHEN reset = '1' ELSE data3_tmp;
   data4 <= '0' WHEN reset = '1' ELSE data4_tmp;
   data5 <= '0' WHEN reset = '1' ELSE data5_tmp;
   data6 <= '0' WHEN reset = '1' ELSE data6_tmp;
   data7 <= '0' WHEN reset = '1' ELSE data7_tmp;


   lock <= '0' WHEN reset = '1' ELSE lock_tmp;

   -- Calculate the clock period
   PROCESS
   VARIABLE clk_period_tmp : time := 0 ps;
   BEGIN
   WAIT UNTIL (clkin'EVENT AND clkin = '1');
      IF (first_clkin_edge_detect = '0') THEN
         first_clkin_edge_detect <= '1';
      ELSE
         last_clk_period <= clk_period;
         clk_period_tmp  := NOW - last_clkin_edge;
      END IF;

      IF (((clk_period_tmp = last_clk_period) OR (clk_period_tmp = last_clk_period + 1 ps) OR (clk_period_tmp = last_clk_period - 1 ps)) AND (clk_period_tmp /= 0 ps ) AND (last_clk_period /= 0 ps)) THEN
         lock_tmp <= '1';
      ELSE
         lock_tmp <= '0';
      END IF;

      last_clkin_edge <= NOW;
      clk_period <= clk_period_tmp;
   END PROCESS;

   -- Generate the phase shifted signals
   PROCESS (clkin)
   BEGIN
      clk0_tmp <= clkin;
      clk1_tmp <= TRANSPORT clkin after (clk_period * 0.125) ;
      clk2_tmp <= TRANSPORT clkin after (clk_period * 0.25) ;
      clk3_tmp <= TRANSPORT clkin after (clk_period * 0.375) ;
      clk4_tmp <= TRANSPORT clkin after (clk_period * 0.5) ;
      clk5_tmp <= TRANSPORT clkin after (clk_period * 0.625) ;
      clk6_tmp <= TRANSPORT clkin after (clk_period * 0.75) ;
      clk7_tmp <= TRANSPORT clkin after (clk_period * 0.875) ;
   END PROCESS;

   PROCESS (datain)
   BEGIN
      data0_tmp <= datain;
      data1_tmp <= TRANSPORT datain after (clk_period * 0.125) ;
      data2_tmp <= TRANSPORT datain after (clk_period * 0.25) ;
      data3_tmp <= TRANSPORT datain after (clk_period * 0.375) ;
      data4_tmp <= TRANSPORT datain after (clk_period * 0.5) ;
      data5_tmp <= TRANSPORT datain after (clk_period * 0.625) ;
      data6_tmp <= TRANSPORT datain after (clk_period * 0.75) ;
      data7_tmp <= TRANSPORT datain after (clk_period * 0.875) ;
  END PROCESS;

END trans;

   -------------------------------------------------------------------------------
   --
   -- Module Name : stratixiii_dpa_block
   --
   -- Description : Simulation model for selecting the retimed data, clock and loaden
   --               depending on the PPM varaiation and direction of shift.
   --
   -------------------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE work.stratixiii_dpa_retime_block;


ENTITY stratixiii_dpa_block IS
   GENERIC (
      net_ppm_variation    : INTEGER := 0;
      is_negative_ppm_drift  : STRING := "off";
      enable_soft_cdr_mode: STRING := "on"
   );
   PORT (

      clkin            : IN STD_LOGIC;
      dpareset         : IN STD_LOGIC;
      dpahold          : IN STD_LOGIC;
      datain           : IN STD_LOGIC;

      clkout           : OUT STD_LOGIC;
      dataout          : OUT STD_LOGIC;
      dpalock          : OUT STD_LOGIC
   );
END stratixiii_dpa_block;

ARCHITECTURE trans OF stratixiii_dpa_block IS
   COMPONENT stratixiii_dpa_retime_block
      PORT (
         clkin            : IN STD_LOGIC;
         datain           : IN STD_LOGIC;
         reset            : IN STD_LOGIC;
         clk0             : OUT STD_LOGIC;
         clk1             : OUT STD_LOGIC;
         clk2             : OUT STD_LOGIC;
         clk3             : OUT STD_LOGIC;
         clk4             : OUT STD_LOGIC;
         clk5             : OUT STD_LOGIC;
         clk6             : OUT STD_LOGIC;
         clk7             : OUT STD_LOGIC;
         data0            : OUT STD_LOGIC;
         data1            : OUT STD_LOGIC;
         data2            : OUT STD_LOGIC;
         data3            : OUT STD_LOGIC;
         data4            : OUT STD_LOGIC;
         data5            : OUT STD_LOGIC;
         data6            : OUT STD_LOGIC;
         data7            : OUT STD_LOGIC;
         lock             : OUT STD_LOGIC
      );
   END COMPONENT;


   SIGNAL clk0_tmp                : STD_LOGIC;
   SIGNAL clk1_tmp                : STD_LOGIC;
   SIGNAL clk2_tmp                : STD_LOGIC;
   SIGNAL clk3_tmp                : STD_LOGIC;
   SIGNAL clk4_tmp                : STD_LOGIC;
   SIGNAL clk5_tmp                : STD_LOGIC;
   SIGNAL clk6_tmp                : STD_LOGIC;
   SIGNAL clk7_tmp                : STD_LOGIC;
   SIGNAL data0_tmp               : STD_LOGIC;
   SIGNAL data1_tmp               : STD_LOGIC;
   SIGNAL data2_tmp               : STD_LOGIC;
   SIGNAL data3_tmp               : STD_LOGIC;
   SIGNAL data4_tmp               : STD_LOGIC;
   SIGNAL data5_tmp               : STD_LOGIC;
   SIGNAL data6_tmp               : STD_LOGIC;
   SIGNAL data7_tmp               : STD_LOGIC;

   SIGNAL select_xhdl1            : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
   SIGNAL clkout_tmp              : STD_LOGIC;
   SIGNAL dataout_tmp             : STD_LOGIC;

   SIGNAL counter_reset_value     : INTEGER ;
   SIGNAL count_value             : INTEGER ;
   SIGNAL i                       : INTEGER := 0;
   SIGNAL dpalock_xhdl0           : STD_LOGIC;

BEGIN
   -- Drive referenced outputs
   dpalock <= dpalock_xhdl0;
   dataout <= dataout_tmp when (enable_soft_cdr_mode = "on") else datain;
   clkout <= clkout_tmp when (enable_soft_cdr_mode = "on") else clkin;

   data_clock_retime : stratixiii_dpa_retime_block
      PORT MAP (
         clkin    => clkin,
         datain   => datain,
         reset    => dpareset,
         clk0     => clk0_tmp,
         clk1     => clk1_tmp,
         clk2     => clk2_tmp,
         clk3     => clk3_tmp,
         clk4     => clk4_tmp,
         clk5     => clk5_tmp,
         clk6     => clk6_tmp,
         clk7     => clk7_tmp,
         data0    => data0_tmp,
         data1    => data1_tmp,
         data2    => data2_tmp,
         data3    => data3_tmp,
         data4    => data4_tmp,
         data5    => data5_tmp,
         data6    => data6_tmp,
         data7    => data7_tmp,
         lock     => dpalock_xhdl0
      );

   PROCESS (clkin, dpareset, dpahold)
   variable initial : boolean := true;
   variable ppm_tmp : integer;
   BEGIN
   if(initial) then
        if(net_ppm_variation = 0) then
        	ppm_tmp := 1;
        else
        	ppm_tmp := net_ppm_variation;
        end if;
        
        if(net_ppm_variation = 0) then
            counter_reset_value <=  1;
            count_value <= 1;
            initial := false;
        else
            counter_reset_value <=  1000000 / (ppm_tmp * 8);
            count_value <= 1000000 / (ppm_tmp * 8);
            initial := false;
        end if;
    end if;

      IF (clkin'EVENT AND clkin = '1') THEN
          IF(net_ppm_variation = 0) THEN
            select_xhdl1 <= "000";
          ELSE
             IF (dpareset = '1') THEN
                i <= 0;
                select_xhdl1 <= "000";
             ELSE
                IF (dpahold = '0') THEN
                   IF (i < count_value) THEN
                      i <= i + 1;
                   ELSE
                      select_xhdl1 <= select_xhdl1 + "001";
                      i <= 0;
                   END IF;
                END IF;
             END IF;
          END IF;
      END IF;
   END PROCESS;

   PROCESS (select_xhdl1, clk0_tmp, clk1_tmp, clk2_tmp, clk3_tmp, clk4_tmp, clk5_tmp, clk6_tmp, clk7_tmp,
            data0_tmp, data1_tmp, data2_tmp, data3_tmp, data4_tmp, data5_tmp, data6_tmp, data7_tmp)
   BEGIN
      if (select_xhdl1 = "000") then
            clkout_tmp <= clk0_tmp;
            dataout_tmp <= data0_tmp;

      elsif (select_xhdl1 = "001") then
            if( is_negative_ppm_drift = "off")then
                clkout_tmp <= clk1_tmp;
                dataout_tmp <= data1_tmp;
            else
                clkout_tmp <= clk7_tmp;
                dataout_tmp <= data7_tmp;
            end if;

    elsif (select_xhdl1 = "010") then
      if( is_negative_ppm_drift = "off")then
            clkout_tmp <= clk2_tmp;
            dataout_tmp <= data2_tmp;
        else
            clkout_tmp <= clk6_tmp;
            dataout_tmp <= data6_tmp;
        end if;

     elsif (select_xhdl1 = "011")then
      if( is_negative_ppm_drift = "off")then
            clkout_tmp <= clk3_tmp;
            dataout_tmp <= data3_tmp;
        else
            clkout_tmp <= clk5_tmp;
            dataout_tmp <= data5_tmp;
        end if;

    elsif (select_xhdl1 = "100")then
       clkout_tmp <= clk4_tmp;
       dataout_tmp <= data4_tmp;

     elsif (select_xhdl1 = "101")then
      if( is_negative_ppm_drift = "off")then
            clkout_tmp <= clk5_tmp;
            dataout_tmp <= data5_tmp;
        else
            clkout_tmp <= clk3_tmp;
            dataout_tmp <= data3_tmp;
        end if;

     elsif (select_xhdl1 = "110") then
        if( is_negative_ppm_drift = "off")then
            clkout_tmp <= clk6_tmp;
            dataout_tmp <= data6_tmp;
        else
            clkout_tmp <= clk2_tmp;
            dataout_tmp <= data2_tmp;
        end if;

     elsif (select_xhdl1 = "111")then
        if( is_negative_ppm_drift = "off")then
            clkout_tmp <= clk7_tmp;
            dataout_tmp <= data7_tmp;
        else
            clkout_tmp <= clk1_tmp;
            dataout_tmp <= data1_tmp;
        end if;
     else
        clkout_tmp <= clk0_tmp;
        dataout_tmp <= data0_tmp;
     end if;
   END PROCESS;

END trans;

--/////////////////////////////////////////////////////////////////////////////
--
-- Module Name : stratixiii_LVDS_RECEIVER
--
-- Description : Timing simulation model for the stratixiii LVDS RECEIVER
--               atom. This module instantiates the following sub-modules :
--               1) stratixiii_lvds_rx_fifo
--               2) stratixiii_lvds_rx_bitslip
--               3) DFFEs for the LOADEN signals
--               4) stratixiii_lvds_rx_parallel_reg
--               5) stratixiii_pclk_divider
--               6) stratixiii_select_ini_phase_dpaclk
--               7) stratixiii_dpa_block
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.stratixiii_atom_pack.all;
USE work.stratixiii_lvds_rx_bitslip;
USE work.stratixiii_lvds_rx_fifo;
USE work.stratixiii_lvds_rx_deser;
USE work.stratixiii_lvds_rx_parallel_reg;
USE work.stratixiii_lvds_reg;
USE work.stratixiii_pclk_divider;
USE work.stratixiii_select_ini_phase_dpaclk;
USE work.stratixiii_dpa_block;

ENTITY stratixiii_lvds_receiver IS
    GENERIC ( channel_width                  :  integer := 10;
              data_align_rollover            :  integer := 2;
              enable_dpa                     :  string := "off";
              lose_lock_on_one_change        :  string := "off";
              reset_fifo_at_first_lock       :  string := "on";
              align_to_rising_edge_only      :  string := "on";
              use_serial_feedback_input      :  string := "off";
              dpa_debug                      :  string := "off";
              enable_soft_cdr                : string := "off";
              dpa_output_clock_phase_shift   : INTEGER := 0 ;
              enable_dpa_initial_phase_selection  : string := "off";
              dpa_initial_phase_value    : INTEGER := 0;
              enable_dpa_align_to_rising_edge_only   : string := "off";
              net_ppm_variation     : INTEGER := 0;
              is_negative_ppm_drift   : string := "off";
               rx_input_path_delay_engineering_bits : INTEGER := -1;
              x_on_bitslip                   :  string := "on";
              lpm_type                       :  string := "stratixiii_lvds_receiver";
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
              dpalock                 : OUT std_logic:= '0';
              bitslipmax              : OUT std_logic;
              serialdataout           : OUT std_logic;
              postdpaserialdataout    : OUT std_logic;
              divfwdclk               : OUT std_logic;
              dpaclkout               : OUT std_logic;
              devclrn                 : IN std_logic := '1';
              devpor                  : IN std_logic := '1'
            );

END stratixiii_lvds_receiver;

ARCHITECTURE vital_arm_lvds_receiver OF stratixiii_lvds_receiver IS

    COMPONENT stratixiii_lvds_rx_bitslip
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

    COMPONENT stratixiii_lvds_rx_fifo
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

    COMPONENT stratixiii_lvds_rx_deser
        GENERIC ( channel_width           :  integer := 4
                );
        PORT    ( clk                     : IN  std_logic;
                  datain                  : IN  std_logic;
                  dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);
                  devclrn                 : IN  std_logic := '1';
                  devpor                  : IN  std_logic := '1'
                );
    END COMPONENT;

    COMPONENT stratixiii_lvds_rx_parallel_reg
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

    COMPONENT stratixiii_lvds_reg
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

      COMPONENT stratixiii_pclk_divider
         GENERIC (
                    clk_divide_by                  :  integer := 1);
         PORT (
                  clkin                   : IN std_logic;
                  lloaden                 : OUT std_logic;
                  clkout                  : OUT std_logic);
     END COMPONENT;


 COMPONENT stratixiii_select_ini_phase_dpaclk
    GENERIC(
            initial_phase_select          :  integer := 0
            );
   PORT (

      clkin    : IN STD_LOGIC;
      loaden   : IN STD_LOGIC;
      enable   : IN STD_LOGIC;
      loadenout : OUT STD_LOGIC;
      clkout     : OUT STD_LOGIC
   );
 END COMPONENT;


   COMPONENT stratixiii_dpa_block
   GENERIC (
      net_ppm_variation    : INTEGER := 0;
      is_negative_ppm_drift  : STRING := "off";
      enable_soft_cdr_mode: STRING := "on"
            );
    PORT (
      clkin            : IN STD_LOGIC;
      dpareset         : IN STD_LOGIC;
      dpahold          : IN STD_LOGIC;
      datain           : IN STD_LOGIC;

      clkout           : OUT STD_LOGIC;
      dataout          : OUT STD_LOGIC;
      dpalock          : OUT STD_LOGIC
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
    signal dpa_clk                  :  std_logic;
    signal dpa_rst                  :  std_logic;
    signal datain_reg               :  std_logic;
    signal datain_reg_neg           :  std_logic;
    signal datain_reg_tmp           :  std_logic;
    signal deser_dataout            :  std_logic_vector(channel_width - 1 DOWNTO 0);
    signal reset_fifo               :  std_logic;
    signal gnd                      :  std_logic := '0';
    signal vcc                      :  std_logic := '1';
    signal in_reg_data              :  std_logic;
    signal slip_datain_tmp          :  std_logic;
    signal s_bitslip_clk             :  std_logic;
    signal loaden                     :  std_logic;
    signal ini_dpa_clk          :  std_logic;
    signal ini_dpa_load         :  std_logic;
    signal ini_phase_select_enable       :  std_logic;
    signal dpa_clk_shift          :  std_logic;
    signal dpa_data_shift          :  std_logic;
    signal lloaden       :  std_logic;
    signal lock_tmp               :  std_logic;
    signal divfwdclk_tmp       :  std_logic;
    signal dpa_is_locked        : std_logic;
    signal dpareg0_out          : std_logic;
    signal dpareg1_out          : std_logic;

    signal xhdl_12                  :  std_logic;
    signal rxload                   :  std_logic;
    signal clk0_tmp                  :  std_logic; 
    signal clk0_tmp_neg                  :  std_logic; 


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

        process (clk0_ipd, dpareset_ipd,lock_tmp )
        variable dpalock_VitalGlitchData : VitalGlitchDataType;
       variable initial : boolean := true;
        begin
            if (initial) then

                if (reset_fifo_at_first_lock = "on") then
                    reset_fifo <= '1';
                else
                    reset_fifo <= '0';
                end if;

                initial := false;
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
             if(lock_tmp = '1') then
                reset_fifo   <= '0';
             else
                reset_fifo <= '1';
             end if;
        end process;


       
        xhdl_12 <= devclrn OR devpor;


         -- input register in non-DPA mode for sampling incoming data
        in_reg : stratixiii_lvds_reg
            PORT MAP ( 
                     d    => in_reg_data,
                       clk  => clk0_tmp,
                       ena  => vcc,
                       clrn => xhdl_12,
                       prn  => vcc,
                       q    => datain_reg
                     );
      in_reg_data <= serialfbk_ipd WHEN (use_serial_feedback_input = "on") ELSE datain_ipd;
      						 
      						 

      clk0_tmp <= clk0_ipd;
      clk0_tmp_neg <= not clk0_ipd;
      

      neg_reg : stratixiii_lvds_reg
            PORT MAP ( 
                     d    => in_reg_data,
                       clk  => clk0_tmp_neg,
                       ena  => vcc,
                       clrn => xhdl_12,
                       prn  => vcc,
                       q    => datain_reg_neg
                     );

      datain_reg_tmp <= datain_reg WHEN (align_to_rising_edge_only = "on") ELSE datain_reg_neg;

    -- dpa initial phase select
    ini_clk_phase_select: stratixiii_select_ini_phase_dpaclk
    GENERIC MAP(
            initial_phase_select          => dpa_initial_phase_value
            )
   PORT MAP(
      clkin    => clk0_ipd,
      loaden   => enable0_ipd,
      enable   => ini_phase_select_enable,
      loadenout=>ini_dpa_load,
      clkout   => ini_dpa_clk
   );
 ini_phase_select_enable <= '1' when (enable_dpa_initial_phase_selection = "on") else '0';

   -- DPA circuitary
       dpareg0 : stratixiii_lvds_reg
        PORT MAP ( 
                d    => in_reg_data,
   clk  => ini_dpa_clk,                 
                   clrn => vcc,
                   prn  => vcc,
                   ena  => vcc,
                   q    => dpareg0_out
                 );

    dpareg1 : stratixiii_lvds_reg
        PORT MAP ( d    => dpareg0_out,
                   clk  => ini_dpa_clk,
                   clrn => vcc,
                   prn  => vcc,
                   ena  => vcc,
                   q    => dpareg1_out
                 );
    dpa_circuit: stratixiii_dpa_block
    GENERIC MAP(
            net_ppm_variation => net_ppm_variation,
            is_negative_ppm_drift => is_negative_ppm_drift,
            enable_soft_cdr_mode => enable_soft_cdr
            )
     PORT MAP(
                clkin      =>   ini_dpa_clk,
                dpareset   =>   dpareset_ipd,
                dpahold    =>   dpahold_ipd,
                datain     =>   dpareg1_out,
                clkout     =>   dpa_clk_shift,
                dataout    =>   dpa_data_shift,
                dpalock    =>   lock_tmp
            );

        dpa_clk <= dpa_clk_shift when ((enable_soft_cdr = "on") or (enable_dpa = "on")) else '0' ;
        dpa_rst <= dpareset_ipd when ((enable_soft_cdr = "on") or (enable_dpa = "on")) else '0' ;

  -- PCLK and lloaden generation
   clk_forward: stratixiii_pclk_divider
   GENERIC MAP (
      clk_divide_by   => channel_width )
   PORT MAP(
      clkin   => dpa_clk,
      lloaden => lloaden,
      clkout  => divfwdclk_tmp
      );

 -- FIFO
    s_fifo : stratixiii_lvds_rx_fifo
        GENERIC MAP ( channel_width => channel_width
                    )
        PORT MAP    ( wclk    => dpa_clk,
                      rclk    => fifo_rclk,
                      fiforst => fifo_reset,
                      dparst  => dpa_rst,
                      datain  => fifo_datain,
                      dataout => fifo_dataout
                    );

        fifo_rclk <= clk0_ipd WHEN (enable_dpa = "on") ELSE gnd ;
        fifo_wclk <= dpa_clk ;
        fifo_datain <= dpa_data_shift WHEN (enable_dpa = "on") ELSE gnd ;
        fifo_reset <= (NOT devpor) OR (NOT devclrn) OR fiforeset_ipd OR dpa_rst OR reset_fifo ;

   -- Bit Slip
    s_bslip : stratixiii_lvds_rx_bitslip
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
    bitslip_reset <= (NOT devpor) OR (NOT devclrn) OR bitslipreset_ipd ;
   slip_datain_tmp <= fifo_dataout when (enable_dpa = "on" and dpaswitch_ipd = '1') else datain_reg_tmp ;
    slip_datain <= dpa_data_shift when(enable_soft_cdr = "on") else slip_datain_tmp;
    s_bitslip_clk <= dpa_clk when (enable_soft_cdr = "on") else clk0_ipd;

    -- DESERIALISER
    rxload_reg : stratixiii_lvds_reg
        PORT MAP ( d    => loaden,
                   clk  => s_bitslip_clk,
                   ena  => vcc,
                   clrn => vcc,
                   prn  => vcc,
                   q    => rxload
                 );
    loaden <= lloaden when (enable_soft_cdr = "on") else ini_dpa_load;

    s_deser : stratixiii_lvds_rx_deser
        GENERIC MAP (channel_width => channel_width
                    )
        PORT MAP    (clk => s_bitslip_clk,
                     datain => slip_dataout,
                     devclrn => devclrn,
                     devpor => devpor,
                     dataout => deser_dataout
                    );

    output_reg : stratixiii_lvds_rx_parallel_reg
        GENERIC MAP ( channel_width => channel_width
                    )
        PORT MAP    ( clk => s_bitslip_clk,
                      enable => rxload,
                      datain => deser_dataout,
                      devpor => devpor,
                      devclrn => devclrn,
                      dataout => dataout
                    );

    dpa_is_locked <= gnd;
    dpaclkout <= dpa_clk_shift;
    postdpaserialdataout <= dpa_data_shift ;
    serialdataout <= datain_ipd;
     divfwdclk <= divfwdclk_tmp ;

END vital_arm_lvds_receiver;
----------------------------------------------------------------------------------
--Module Name:                    stratixiii_pseudo_diff_out                          --
--Description:                    Simulation model for Stratix III Pseudo Differential --
--                                Output Buffer                                  --
----------------------------------------------------------------------------------


LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_pseudo_diff_out IS
 GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             lpm_type                         :  string := "stratixiii_pseudo_diff_out"
            );
 PORT (
           i                       : IN std_logic := '0';
           o                       : OUT std_logic;
           obar                    : OUT std_logic
         );
END stratixiii_pseudo_diff_out;

ARCHITECTURE arch OF stratixiii_pseudo_diff_out IS
        SIGNAL i_ipd                  : std_logic ;
        SIGNAL o_tmp                  :  std_logic ;
        SIGNAL obar_tmp               :  std_logic;

BEGIN
    WireDelay : block
    begin
        VitalWireDelay (i_ipd, i, tipd_i);
    end block;

    PROCESS( i_ipd)
        BEGIN
            IF (i_ipd = '0') THEN
                o_tmp <= '0';
                obar_tmp <= '1';
            ELSE
                IF (i_ipd = '1') THEN
                    o_tmp <= '1';
                    obar_tmp <= '0';
                ELSE
                    o_tmp <= i_ipd;
                    obar_tmp <= i_ipd;
                END IF;
            END IF;
        END PROCESS;

        ---------------------
     --  Path Delay Section
     ----------------------
    PROCESS( o_tmp,obar_tmp)
        variable o_VitalGlitchData : VitalGlitchDataType;
        variable obar_VitalGlitchData : VitalGlitchDataType;
        BEGIN
            VitalPathDelay01 (
                              OutSignal => o,
                              OutSignalName => "o",
                              OutTemp => o_tmp,
                              Paths => (0 => (i_ipd'last_event, tpd_i_o, TRUE)),
                              GlitchData => o_VitalGlitchData,
                              Mode => DefGlitchMode,
                              XOn  => XOn,
                              MsgOn  => MsgOn
                              );
            VitalPathDelay01 (
                  OutSignal => obar,
                  OutSignalName => "obar",
                  OutTemp => obar_tmp,
                  Paths => (0 => (i_ipd'last_event, tpd_i_obar, TRUE)),
                  GlitchData => obar_VitalGlitchData,
                  Mode => DefGlitchMode,
                  XOn  => XOn,
                  MsgOn  => MsgOn
                  );
        END PROCESS;
END arch;
--------------------------------------------------------------
--
-- Entity Name : stratixiii_bias_logic
--
-- Description : STRATIXIII Bias Block's Logic Block
--               VHDL simulation model
--
--------------------------------------------------------------
LIBRARY IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_bias_logic IS
    GENERIC (
            tipd_clk : VitalDelayType01 := DefPropDelay01;
            tipd_shiftnld : VitalDelayType01 := DefPropDelay01;
            tipd_captnupdt : VitalDelayType01 := DefPropDelay01;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks
            );
    PORT (
        clk : in std_logic := '0';
        shiftnld : in std_logic := '0';
        captnupdt : in std_logic := '0';
        mainclk : out std_logic := '0';
        updateclk : out std_logic := '0';
        capture : out std_logic := '0';
        update : out std_logic := '0'
        );

    attribute VITAL_LEVEL0 of stratixiii_bias_logic : ENTITY IS TRUE;
end stratixiii_bias_logic;

ARCHITECTURE vital_bias_logic of stratixiii_bias_logic IS
    attribute VITAL_LEVEL0 of vital_bias_logic : ARCHITECTURE IS TRUE;
    signal clk_ipd : std_logic := '0';
    signal shiftnld_ipd : std_logic := '0';
    signal captnupdt_ipd : std_logic := '0';
begin

    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (shiftnld_ipd, shiftnld, tipd_shiftnld);
        VitalWireDelay (captnupdt_ipd, captnupdt, tipd_captnupdt);
    end block;

    process (clk_ipd, shiftnld_ipd, captnupdt_ipd)
    variable select_tmp : std_logic_vector(1 DOWNTO 0) := (others => '0');
    begin
        select_tmp := captnupdt_ipd & shiftnld_ipd;
        case select_tmp IS
            when "10"|"11" =>
                mainclk <= '0';
                updateclk <= clk_ipd;
                capture <= '1';
                update <= '0';
            when "01" =>
                mainclk <= '0';
                updateclk <= clk_ipd;
                capture <= '0';
                update <= '0';
            when "00" =>
                mainclk <= clk_ipd;
                updateclk <= '0';
                capture <= '0';
                update <= '1';
            when others =>
                mainclk <= '0';
                updateclk <= '0';
                capture <= '0';
                update <= '0';
        end case;
    end process;

end vital_bias_logic;

--------------------------------------------------------------
--
-- Entity Name : stratixiii_bias_generator
--
-- Description : STRATIXIII Bias Generator VHDL simulation model
--
--------------------------------------------------------------
LIBRARY IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_bias_generator IS
    GENERIC (
        tipd_din : VitalDelayType01 := DefPropDelay01;
        tipd_mainclk : VitalDelayType01 := DefPropDelay01;
        tipd_updateclk : VitalDelayType01 := DefPropDelay01;
        tipd_update : VitalDelayType01 := DefPropDelay01;
        tipd_capture : VitalDelayType01 := DefPropDelay01;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks
        );
    PORT (
        din : in std_logic := '0';
        mainclk : in std_logic := '0';
        updateclk : in std_logic := '0';
        capture : in std_logic := '0';
        update : in std_logic := '0';
        dout : out std_logic := '0'
        );

    attribute VITAL_LEVEL0 of stratixiii_bias_generator : ENTITY IS TRUE;
end stratixiii_bias_generator;

ARCHITECTURE vital_bias_generator of stratixiii_bias_generator IS
    attribute VITAL_LEVEL0 of vital_bias_generator : ARCHITECTURE IS TRUE;
    CONSTANT TOTAL_REG : integer := 252;
    signal din_ipd : std_logic := '0';
    signal mainclk_ipd : std_logic := '0';
    signal updateclk_ipd : std_logic := '0';
    signal update_ipd : std_logic := '0';
    signal capture_ipd : std_logic := '0';
    signal generator_reg : std_logic_vector((TOTAL_REG - 1) DOWNTO 0) := (others => '0');
    signal update_reg : std_logic_vector((TOTAL_REG - 1) DOWNTO 0) := (others => '0');
    signal dout_tmp : std_logic := '0';
    signal i : integer := 0;
    
begin

    WireDelay : block
    begin
        VitalWireDelay (din_ipd, din, tipd_din);
        VitalWireDelay (mainclk_ipd, mainclk, tipd_mainclk);
        VitalWireDelay (updateclk_ipd, updateclk, tipd_updateclk);
        VitalWireDelay (update_ipd, update, tipd_update);
        VitalWireDelay (capture_ipd, capture, tipd_capture);
    end block;

    process (mainclk_ipd)
    begin
        if (mainclk_ipd'event AND (mainclk_ipd = '1') AND (mainclk_ipd'last_value = '0')) then 
            if ((capture_ipd = '0') AND (update_ipd = '1')) then 
                for i in 0 to (TOTAL_REG - 1)
                loop
                    generator_reg(i) <= update_reg(i);
                end loop;
            end if;
        end if;
    end process;

    process (updateclk_ipd)
    begin
        if (updateclk_ipd'event AND (updateclk_ipd = '1') AND (updateclk_ipd'last_value = '0')) then 
            dout_tmp <= update_reg(TOTAL_REG - 1);
    
            if ((capture_ipd = '0') AND (update_ipd = '0')) then 
                for i in 1 to (TOTAL_REG - 1)
                loop
                    update_reg(i) <= update_reg(i - 1);
                end loop;
                update_reg(0) <= din_ipd;
            elsif ((capture_ipd = '1') AND (update_ipd = '0')) then 
                for i in 1 to (TOTAL_REG - 1)
                loop
                    update_reg(i) <= generator_reg(i);
                end loop;
            end if; 
        end if;
    end process;

    dout <= dout_tmp;

end vital_bias_generator;

--------------------------------------------------------------
--
-- Entity Name : stratixiii_bias_block
--
-- Description : STRATIXIII Bias Block VHDL simulation model
--
--------------------------------------------------------------
LIBRARY IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

ENTITY stratixiii_bias_block IS
    GENERIC (
        lpm_type : string := "stratixiii_bias_block";
        tipd_clk : VitalDelayType01 := DefPropDelay01;
        tipd_shiftnld : VitalDelayType01 := DefPropDelay01;
        tipd_captnupdt : VitalDelayType01 := DefPropDelay01;
        tipd_din : VitalDelayType01 := DefPropDelay01;
        tsetup_din_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_shiftnld_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_captnupdt_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_din_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_shiftnld_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_captnupdt_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_dout_posedge : VitalDelayType01 := DefPropDelay01;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks
        );
    PORT (
        clk : in std_logic := '0';
        shiftnld : in std_logic := '0';
        captnupdt : in std_logic := '0';
        din : in std_logic := '0';
        dout : out std_logic := '0'
        );

    attribute VITAL_LEVEL0 of stratixiii_bias_block : ENTITY IS TRUE;
end stratixiii_bias_block;

ARCHITECTURE vital_bias_block of stratixiii_bias_block IS

    COMPONENT stratixiii_bias_logic
        GENERIC (
                tipd_clk : VitalDelayType01 := DefPropDelay01;
                tipd_shiftnld : VitalDelayType01 := DefPropDelay01;
                tipd_captnupdt : VitalDelayType01 := DefPropDelay01;
                MsgOn: Boolean := DefGlitchMsgOn;
                XOn: Boolean := DefGlitchXOn;
                MsgOnChecks: Boolean := DefMsgOnChecks;
                XOnChecks: Boolean := DefXOnChecks
                );
        PORT (
            clk : in std_logic := '0';
            shiftnld : in std_logic := '0';
            captnupdt : in std_logic := '0';
            mainclk : out std_logic := '0';
            updateclk : out std_logic := '0';
            capture : out std_logic := '0';
            update : out std_logic := '0'
            );
    end COMPONENT;
    
    COMPONENT stratixiii_bias_generator
        GENERIC (
            tipd_din : VitalDelayType01 := DefPropDelay01;
            tipd_mainclk : VitalDelayType01 := DefPropDelay01;
            tipd_updateclk : VitalDelayType01 := DefPropDelay01;
            tipd_update : VitalDelayType01 := DefPropDelay01;
            tipd_capture : VitalDelayType01 := DefPropDelay01;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks
            );
        PORT (
            din : in std_logic := '0';
            mainclk : in std_logic := '0';
            updateclk : in std_logic := '0';
            capture : in std_logic := '0';
            update : in std_logic := '0';
            dout : out std_logic := '0'
            );
    end COMPONENT;

    signal mainclk_wire : std_logic := '0';
    signal updateclk_wire : std_logic := '0';
    signal capture_wire : std_logic := '0';
    signal update_wire : std_logic := '0';

begin

    logic_block : stratixiii_bias_logic
                  PORT MAP (
                           clk => clk,
                           shiftnld => shiftnld,
                           captnupdt => captnupdt,
                           mainclk => mainclk_wire,
                           updateclk => updateclk_wire,
                           capture => capture_wire,
                           update => update_wire
                           );

    bias_generator : stratixiii_bias_generator
                  PORT MAP (
                           din => din,
                           mainclk => mainclk_wire,
                           updateclk => updateclk_wire,
                           capture => capture_wire,
                           update => update_wire,
                           dout => dout
                           );
    
end vital_bias_block;
-------------------------------------------------------------------
--
-- Entity Name : stratixiii_tsdblock
--
-- Description : Stratix III TSDBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.stratixiii_atom_pack.all;

entity  stratixiii_tsdblock is
    generic (
        poi_cal_temperature : integer := 85;
        clock_divider_enable : string := "on";
        clock_divider_value : integer := 40;
        sim_tsdcalo : integer := 0;
        user_offset_enable : string := "off";
        lpm_type : string := "stratixiii_tsdblock"
        );	
    port (
        offset : in std_logic_vector(5 downto 0) := (OTHERS => '0');
        clk : in std_logic := '0'; 
        ce : in std_logic := '0'; 
        clr : in std_logic := '0'; 
        testin : in std_logic_vector(7 downto 0) := (OTHERS => '0');
        tsdcalo : out std_logic_vector(7 downto 0);
        tsdcaldone : out std_logic; 
        fdbkctrlfromcore : in std_logic := '0';
        compouttest : in std_logic := '0';
        tsdcompout : out std_logic; 
        offsetout : out std_logic_vector(5 downto 0)
        );
end stratixiii_tsdblock;

architecture architecture_tsdblock of stratixiii_tsdblock is
begin

end architecture_tsdblock;  -- end of stratixiii_tsdblock
