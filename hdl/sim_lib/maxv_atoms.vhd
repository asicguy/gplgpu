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

package maxv_atom_pack is

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
    TYPE maxv_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

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

end maxv_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body maxv_atom_pack is

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

end maxv_atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package maxv_pllpack is


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

end maxv_pllpack;

package body maxv_pllpack is


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

end maxv_pllpack;

--
--
--  DFFE Model
--
--

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.maxv_atom_pack.all;

entity maxv_dffe is
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
    attribute VITAL_LEVEL0 of maxv_dffe : entity is TRUE;
end maxv_dffe;

-- architecture body --

architecture behave of maxv_dffe is
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
--  maxv_mux21 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.maxv_atom_pack.all;

entity maxv_mux21 is
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
    attribute VITAL_LEVEL0 of maxv_mux21 : entity is TRUE;
end maxv_mux21;

architecture AltVITAL of maxv_mux21 is
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
--  maxv_mux41 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.maxv_atom_pack.all;

entity maxv_mux41 is
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
    attribute VITAL_LEVEL0 of maxv_mux41 : entity is TRUE;
end maxv_mux41;

architecture AltVITAL of maxv_mux41 is
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
--  maxv_and1 Model
--
--
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.maxv_atom_pack.all;

-- entity declaration --
entity maxv_and1 is
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
    attribute VITAL_LEVEL0 of maxv_and1 : entity is TRUE;
end maxv_and1;

-- architecture body --

architecture AltVITAL of maxv_and1 is
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
-- Entity Name : maxv_jtag
--
-- Description : MAXV JTAG VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.maxv_atom_pack.all;

entity  maxv_jtag is
    generic (
        lpm_type : string := "maxv_jtag"
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
end maxv_jtag;

architecture architecture_jtag of maxv_jtag is
begin

end architecture_jtag;

-------------------------------------------------------------------
--
-- Entity Name : maxv_crcblock
--
-- Description : MAXV CRCBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.maxv_atom_pack.all;

entity  maxv_crcblock is
    generic  (
        oscillator_divider : integer := 1;

        lpm_type : string := "maxv_crcblock"
        );	
    port (
        clk : in std_logic := '0'; 
        shiftnld : in std_logic := '0'; 
        crcerror : out std_logic; 
        regout : out std_logic
        ); 
end maxv_crcblock;

architecture architecture_crcblock of maxv_crcblock is
begin
	crcerror <= '0';
	regout <= '0';
end architecture_crcblock;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for MAXV Atoms
--
--/////////////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : maxv_asynch_lcell
--
-- Description : VHDL simulation model for the asynchnous submodule of
--               MAXV Lcell.
--
-- Outputs     : Asynchnous LUT function of MAXV Lcell.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.maxv_atom_pack.all;

ENTITY maxv_asynch_lcell is
    GENERIC (
             lms : std_logic_vector(15 downto 0) := "1111111111111111";
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
             tpd_cin_combout : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_combout : VitalDelayType01 := DefPropDelay01;
             tpd_cin1_combout : VitalDelayType01 := DefPropDelay01;
             tpd_inverta_combout : VitalDelayType01 := DefPropDelay01;
             tpd_qfbkin_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_regin : VitalDelayType01 := DefPropDelay01;
             tpd_datab_regin : VitalDelayType01 := DefPropDelay01;
             tpd_datac_regin : VitalDelayType01 := DefPropDelay01;
             tpd_datad_regin : VitalDelayType01 := DefPropDelay01;
             tpd_cin_regin : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_regin : VitalDelayType01 := DefPropDelay01;
             tpd_cin1_regin : VitalDelayType01 := DefPropDelay01;
             tpd_inverta_regin : VitalDelayType01 := DefPropDelay01;
             tpd_qfbkin_regin : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin1_cout : VitalDelayType01 := DefPropDelay01;
             tpd_inverta_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_cin0_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_inverta_cout0 : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_cin1_cout1 : VitalDelayType01 := DefPropDelay01;
             tpd_inverta_cout1 : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01; 
             tipd_cin0 : VitalDelayType01 := DefPropDelay01; 
             tipd_cin1 : VitalDelayType01 := DefPropDelay01; 
             tipd_inverta : VitalDelayType01 := DefPropDelay01); 

    PORT (
          dataa : in std_logic := '1';
          datab : in std_logic := '1';
          datac : in std_logic := '1';
          datad : in std_logic := '1';
          cin : in std_logic := '0';
          cin0 : in std_logic := '0';
          cin1 : in std_logic := '1';
          inverta : in std_logic := '0';
          qfbkin : in std_logic := '0';
          mode : in std_logic_vector(5 downto 0);
          regin : out std_logic;
          combout : out std_logic;
          cout : out std_logic;
          cout0 : out std_logic;
          cout1 : out std_logic
          );
    attribute VITAL_LEVEL0 of maxv_asynch_lcell : ENTITY is TRUE;

END maxv_asynch_lcell;
        
ARCHITECTURE vital_le of maxv_asynch_lcell is
    attribute VITAL_LEVEL1 of vital_le : ARCHITECTURE is TRUE;
    signal dataa_ipd : std_ulogic;
    signal datab_ipd : std_ulogic;
    signal datac_ipd : std_ulogic;
    signal datad_ipd : std_ulogic;
    signal inverta_ipd : std_ulogic;
    signal cin_ipd : std_ulogic;
    signal cin0_ipd : std_ulogic;
    signal cin1_ipd : std_ulogic;

    -- operation_mode --> mode(0) - normal=1 arithemtic=0
    -- sum_lutc_cin   --> mode(1) - lutc=1   cin=0
    -- sum_lutc_qfbk  --> mode(2) - qfbk=1   mode1=0 
    -- cin_used       --> mode(3) - true=1   false=0
    -- cin0_used      --> mode(4) - true=1   false=0
    -- cin1_used      --> mode(5) - true=1   false=0

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
        VitalWireDelay (cin_ipd, cin, tipd_cin);
        VitalWireDelay (cin0_ipd, cin0, tipd_cin0);
        VitalWireDelay (cin1_ipd, cin1, tipd_cin1);
        VitalWireDelay (inverta_ipd, inverta, tipd_inverta);
    end block;

    VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd, mode,
                          cin_ipd, cin0_ipd, cin1_ipd, inverta_ipd, qfbkin)
    
        variable combout_VitalGlitchData : VitalGlitchDataType;
        variable cout_VitalGlitchData : VitalGlitchDataType;
        variable cout0_VitalGlitchData : VitalGlitchDataType;
        variable cout1_VitalGlitchData : VitalGlitchDataType;
        variable regin_VitalGlitchData : VitalGlitchDataType;
        variable tmp_combout : std_ulogic;
        variable tmp_cout : std_ulogic;
        variable tmp_cout0 : std_ulogic;
        variable tmp_cout1 : std_ulogic;
        variable tmp_regin : std_ulogic;
        variable lutb : std_ulogic;
        variable cintmp : std_ulogic;
        variable invertsig : std_ulogic := '0';
        variable cinsel : std_ulogic;
        variable cinsig : std_ulogic;
        variable cin01sel : std_ulogic;
        variable luta : std_ulogic;
        variable lutc : std_ulogic;
        variable lutd : std_ulogic;
        variable datacsig : std_ulogic;
        
        variable lms_var : std_logic_vector(15 downto 0) := "1111111111111111";
    
        begin
      
            lms_var := lms;
    
            cinsel := (cin_ipd and mode(3)) or 
                      (inverta_ipd and (not mode(3)));
            cin01sel := (cin1_ipd and cinsel) or 
                        (cin0_ipd and (not cinsel)); 
            cintmp := (cin_ipd and mode(0)) or 
                      ((not mode(0)) and mode(3) and cin_ipd) or
                      ((not mode(0)) and (not mode(3)) and inverta_ipd); 
            cinsig := (cintmp and ((not mode(4)) and (not mode(5)))) or
                      (cin01sel and (mode(4) or mode(5))); 
            datacsig := (datac_ipd and mode(1)) or  
                        (cinsig and (not mode(1)));
            luta := dataa_ipd XOR inverta_ipd;
            lutb := datab_ipd;
            lutc := (qfbkin and mode(2)) or 
                    (datacsig and (not mode(2)));
            lutd := (datad_ipd and mode(0)) or (not mode(0));
    
            tmp_combout := VitalMUX(data => lms_var,
                                    dselect => (lutd,
                                                lutc,
                                                lutb,
                                                luta)
                                   ); 
    
            tmp_cout0 := VitalMUX(data => lms_var,
                                  dselect => ('0',
                                              cin0_ipd,
                                              lutb,
                                              luta)
                                 );
    
            tmp_cout1 := VitalMUX(data => lms_var,
                                  dselect => ('0',
                                              cin1_ipd,
                                              lutb,
                                              luta)
                                 );
    
            tmp_cout := VitalMux2(VitalMux2(tmp_cout1, 
                                            tmp_cout0, 
                                            cin_ipd),
                                  VitalMux2(tmp_cout1, 
                                            tmp_cout0, 
                                            inverta_ipd), 
                                  mode(3)
                                 );
    
            ----------------------
            --  Path Delay Section
            ----------------------
                
            VitalPathDelay01
            (
                OutSignal => combout,
                OutSignalName => "COMBOUT",
                OutTemp => tmp_combout,
                Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                          1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                          2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                          3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                          4 => (cin_ipd'last_event, tpd_cin_combout, TRUE),
                          5 => (cin0_ipd'last_event, tpd_cin0_combout, TRUE),
                          6 => (cin1_ipd'last_event, tpd_cin1_combout, TRUE),
                          7 => (inverta_ipd'last_event, tpd_inverta_combout, TRUE),
                          8 => (qfbkin'last_event, tpd_qfbkin_combout, (mode(2) = '1'))),
                GlitchData => combout_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn => MsgOn
            );
                
            VitalPathDelay01
            (
                OutSignal => regin,
                OutSignalName => "REGIN",
                OutTemp => tmp_combout,
                Paths => (0 => (dataa_ipd'last_event, tpd_dataa_regin, TRUE),
                          1 => (datab_ipd'last_event, tpd_datab_regin, TRUE),
                          2 => (datac_ipd'last_event, tpd_datac_regin, TRUE),
                          3 => (datad_ipd'last_event, tpd_datad_regin, TRUE),
                          4 => (cin_ipd'last_event, tpd_cin_regin, TRUE),
                          5 => (cin0_ipd'last_event, tpd_cin0_regin, TRUE),
                          6 => (cin1_ipd'last_event, tpd_cin1_regin, TRUE),
                          7 => (inverta_ipd'last_event, tpd_inverta_regin, TRUE),
                          8 => (qfbkin'last_event, tpd_qfbkin_regin, (mode(2) = '1'))),
                GlitchData => regin_VitalGlitchData,
                Mode => DefGlitchMode,
                XOn  => XOn,
                MsgOn => MsgOn
            );
                
            VitalPathDelay01 ( 
                OutSignal => cout, 
                OutSignalName => "COUT",
                OutTemp => tmp_cout,
                Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                          1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                          2 => (cin_ipd'last_event, tpd_cin_cout, TRUE),
                          3 => (cin0_ipd'last_event, tpd_cin0_cout, TRUE),
                          4 => (cin1_ipd'last_event, tpd_cin1_cout, TRUE),
                          5 => (inverta_ipd'last_event, tpd_inverta_cout, TRUE)),
                GlitchData => cout_VitalGlitchData,    
                Mode => DefGlitchMode, 
                XOn  => XOn, 
                MsgOn => MsgOn
            );
                
            VitalPathDelay01 ( 
                OutSignal => cout0, 
                OutSignalName => "COUT0",
                OutTemp => tmp_cout0,
                Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout0, TRUE),
                          1 => (datab_ipd'last_event, tpd_datab_cout0, TRUE),
                          2 => (cin0_ipd'last_event, tpd_cin0_cout0, TRUE),
                          3 => (inverta_ipd'last_event, tpd_inverta_cout0, TRUE)),
                GlitchData => cout0_VitalGlitchData,    
                Mode => DefGlitchMode, 
                XOn  => XOn, 
                MsgOn => MsgOn
            );
                
            VitalPathDelay01 ( 
                OutSignal => cout1, 
                OutSignalName => "COUT1",
                OutTemp => tmp_cout1,
                Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout1, TRUE),
                          1 => (datab_ipd'last_event, tpd_datab_cout1, TRUE),
                          2 => (cin1_ipd'last_event, tpd_cin1_cout1, TRUE),
                          3 => (inverta_ipd'last_event, tpd_inverta_cout1, TRUE)),
                GlitchData => cout1_VitalGlitchData,    
                Mode => DefGlitchMode, 
                XOn  => XOn, 
                MsgOn => MsgOn
            );

    end process;

end vital_le;	

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : maxv_lcell_register
--
-- Description : VHDL simulation model for the register submodule of
--               MAXV Lcell.
--
-- Outputs     : Registered output of MAXV Lcell.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.maxv_atom_pack.all;

ENTITY maxv_lcell_register is
    GENERIC (
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
    
             tsetup_regcascin_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_regcascin_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
             tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
             tpd_aload_regout_posedge		: VitalDelayType01 := DefPropDelay01;
             tpd_datac_regout			: VitalDelayType01 := DefPropDelay01;
             tpd_clk_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
             tpd_aclr_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
             tpd_aload_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
             tpd_datac_qfbkout			: VitalDelayType01 := DefPropDelay01;
                 
             tipd_clk        : VitalDelayType01 := DefPropDelay01;
             tipd_datac      : VitalDelayType01 := DefPropDelay01;
             tipd_regcascin  : VitalDelayType01 := DefPropDelay01; 
             tipd_ena        : VitalDelayType01 := DefPropDelay01; 
             tipd_aclr       : VitalDelayType01 := DefPropDelay01; 
             tipd_aload      : VitalDelayType01 := DefPropDelay01; 
             tipd_sclr       : VitalDelayType01 := DefPropDelay01; 
             tipd_sload      : VitalDelayType01 := DefPropDelay01
             );
  
    PORT (clk : in std_logic := '0';
          datain  : in std_logic := '0';
          datac   : in std_logic := '0';
          regcascin : in std_logic := '0';
          aclr    : in std_logic := '0';
          aload   : in std_logic := '0';
          sclr    : in std_logic := '0';
          sload   : in std_logic := '0';
          ena     : in std_logic := '1';
          cena : in std_logic := '0';
          xonv : in std_logic := '1';
          smode : in std_logic := '0';
          regout  : out std_logic;
          qfbkout : out std_logic
         );
   attribute VITAL_LEVEL0 of maxv_lcell_register : ENTITY is TRUE;
end maxv_lcell_register;
        
ARCHITECTURE vital_le_reg of maxv_lcell_register is
    attribute VITAL_LEVEL1 of vital_le_reg : ARCHITECTURE is TRUE;
    signal ena_ipd : std_ulogic := '1';
    signal sload_ipd : std_ulogic := '0';
    signal aload_ipd : std_ulogic := '0';
    signal datac_ipd : std_ulogic := '0';
    signal regcascin_ipd : std_ulogic := '0';
    signal clk_ipd : std_ulogic := '0';
    signal aclr_ipd : std_ulogic := '0';
    signal sclr_ipd : std_ulogic := '0';
    
    constant maxv_regtab : VitalStateTableType := (
--   CLK ACLR D   D1  D2   EN  Aload Sclr Sload Casc Synch Qp  Q
    ( x,  H,  x,  x,  x,   x,   x,    x,    x,   x,   x,   x,  L ), -- Areset
    ( x,  x,  x,  L,  x,   x,   H,    x,    x,   x,   x,   x,  L ), -- Aload
    ( x,  x,  x,  H,  x,   x,   H,    x,    x,   x,   x,   x,  H ), -- Aload
    ( x,  x,  x,  x,  x,   x,   H,    x,    x,   x,   x,   x,  U ), -- Aload
    ( x,  x,  x,  x,  x,   L,   x,    x,    x,   x,   x,   x,  S ), -- Q=Q
    ( R,  x,  x,  x,  x,   H,   x,    H,    x,   x,   H,   x,  L ), -- Sreset
    ( R,  x,  x,  L,  x,   H,   x,    x,    H,   x,   H,   x,  L ), -- Sload
    ( R,  x,  x,  H,  x,   H,   x,    x,    H,   x,   H,   x,  H ), -- Sload
    ( R,  x,  x,  x,  x,   H,   x,    x,    H,   x,   H,   x,  U ), -- Sload
    ( R,  x,  x,  x,  L,   H,   x,    x,    x,   H,   x,   x,  L ), -- Cascade
    ( R,  x,  x,  x,  H,   H,   x,    x,    x,   H,   x,   x,  H ), -- Cascade
    ( R,  x,  x,  x,  x,   H,   x,    x,    x,   H,   x,   x,  U ), -- Cascade
    ( R,  x,  L,  x,  x,   H,   x,    x,    x,   x,   H,   x,  L ), -- Datain
    ( R,  x,  H,  x,  x,   H,   x,    x,    x,   x,   H,   x,  H ), -- Datain
    ( R,  x,  x,  x,  x,   H,   x,    x,    x,   x,   H,   x,  U ), -- Datain
    ( R,  x,  L,  x,  x,   H,   x,    x,    x,   x,   x,   x,  L ), -- Datain
    ( R,  x,  H,  x,  x,   H,   x,    x,    x,   x,   x,   x,  H ), -- Datain
    ( R,  x,  x,  x,  x,   H,   x,    x,    x,   x,   x,   x,  U ), -- Datain
    ( x,  x,  x,  x,  x,   x,   x,    x,    x,   x,   x,   x,  S )); -- Q=Q


begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datac_ipd, datac, tipd_datac);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (regcascin_ipd, regcascin, tipd_regcascin);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (aload_ipd, aload, tipd_aload);
        VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
        VitalWireDelay (sload_ipd, sload, tipd_sload);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process(clk_ipd, aclr_ipd, aload_ipd, datac_ipd, 
                          regcascin_ipd, datain, sclr_ipd, ena_ipd, 
                          sload_ipd, cena, xonv, smode)

    variable Tviol_regcascin_clk : std_ulogic := '0';
    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_datac_clk : std_ulogic := '0';
    variable Tviol_sclr_clk : std_ulogic := '0';
    variable Tviol_sload_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_regcascin_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_datac_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable qfbkout_VitalGlitchData : VitalGlitchDataType;



    -- variables for 'X' generation
    
    variable Tviolation : std_ulogic := '0';
    variable tmp_regout : STD_ULOGIC := '0';
    variable PreviousData : STD_LOGIC_VECTOR(0 to 10);

    begin
  
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
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (sload_ipd) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => TRUE,
                MsgOn           => TRUE );

            VitalSetupHoldCheck (
                Violation       => Tviol_regcascin_clk,
                TimingData      => TimingData_regcascin_clk,
                TestSignal      => regcascin_ipd,
                TestSignalName  => "REGCASCIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_regcascin_clk_noedge_posedge,
                SetupLow        => tsetup_regcascin_clk_noedge_posedge,
                HoldHigh        => thold_regcascin_clk_noedge_posedge,
                HoldLow         => thold_regcascin_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => TRUE,
                MsgOn           => TRUE );

		VitalSetupHoldCheck (
                Violation       => Tviol_datac_clk,
                TimingData      => TimingData_datac_clk,
                TestSignal      => datac_ipd,
                TestSignalName  => "DATAC",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datac_clk_noedge_posedge,
                SetupLow        => tsetup_datac_clk_noedge_posedge,
                HoldHigh        => thold_datac_clk_noedge_posedge,
                HoldLow         => thold_datac_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => TRUE,
                MsgOn           => TRUE );


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
                CheckEnabled    => TO_X01(aclr_ipd)  /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => TRUE,
                MsgOn           => TRUE );

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
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => TRUE,
                MsgOn           => TRUE );

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
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => TRUE,
                MsgOn           => TRUE );

        end if;

        -------------------------
        --  Functionality Section
        -------------------------

        Tviolation := Tviol_regcascin_clk or Tviol_datain_clk or 
                      Tviol_datac_clk or Tviol_ena_clk or 
                      Tviol_sclr_clk or Tviol_sload_clk;

        VitalStateTable (
            Result => tmp_regout,
            PreviousDataIn => PreviousData,
            StateTable => maxv_regtab,
            DataIn => (CLK_ipd, ACLR_ipd, datain, datac_ipd, 
                       regcascin_ipd, ENA_ipd, aload_ipd, sclr_ipd, 
                       sload_ipd, cena, smode)
            );

        tmp_regout := (xonv AND Tviolation) XOR tmp_regout;

  
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => tmp_regout,
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                      1 => (aload_ipd'last_event, tpd_aload_regout_posedge, TRUE),
                      2 => (datac_ipd'last_event, tpd_datac_regout, TRUE),
                      3 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => OnEvent,
            XOn  => XOn,
            MsgOn  => MsgOn );
		
        VitalPathDelay01 (
            OutSignal => qfbkout,
            OutSignalName => "QFBKOUT",
            OutTemp => tmp_regout,
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_qfbkout_posedge, TRUE),
                      1 => (aload_ipd'last_event, tpd_aload_qfbkout_posedge, TRUE),
                      2 => (datac_ipd'last_event, tpd_datac_qfbkout, TRUE),
                      3 => (clk_ipd'last_event, tpd_clk_qfbkout_posedge, TRUE)),
            GlitchData => qfbkout_VitalGlitchData,
            Mode => OnEvent,
            XOn  => XOn,
            MsgOn  => MsgOn );

    end process;
end vital_le_reg;	

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : maxv_lcell
--
-- Description : VHDL simulation model for MAXV Lcell.
--
-- Outputs     : Output of MAXV Lcell.
--
--///////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.maxv_atom_pack.all;
use work.maxv_asynch_lcell;
use work.maxv_lcell_register;

ENTITY maxv_lcell is
    GENERIC (
             operation_mode  : string := "normal";
             synch_mode      : string := "off";
             register_cascade_mode : string := "off";
             sum_lutc_input  : string := "datac";
             lut_mask        : string := "ffff";
             power_up        : string := "low";
             cin_used        : string := "false";
             cin0_used       : string := "false";
             cin1_used       : string := "false";
             output_mode     : string := "reg_and_comb";
             x_on_violation  : string := "on";
             lpm_type        : string := "maxv_lcell"
            );
    PORT (
          clk       : in std_logic := '0';
          dataa     : in std_logic := '1';
          datab     : in std_logic := '1';
          datac     : in std_logic := '1';
          datad     : in std_logic := '1';
          aclr      : in std_logic := '0';
          aload     : in std_logic := '0';
          sclr      : in std_logic := '0';
          sload     : in std_logic := '0';
          ena       : in std_logic := '1';
          cin       : in std_logic := '0';
          cin0      : in std_logic := '0';
          cin1      : in std_logic := '1';
          inverta   : in std_logic := '0';
          regcascin : in std_logic := '0';
          devclrn   : in std_logic := '1';
          devpor    : in std_logic := '1';
          combout   : out std_logic;
          regout    : out std_logic;
          cout      : out std_logic;
          cout0     : out std_logic;
          cout1     : out std_logic
);

end maxv_lcell;
        
ARCHITECTURE vital_le_atom of maxv_lcell is

signal dffin : std_logic;
signal qfbkin : std_logic;

signal mode : std_logic_vector(5 downto 0);


COMPONENT maxv_asynch_lcell 
    GENERIC (
        lms : std_logic_vector(15 downto 0);
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
              
        tpd_dataa_combout   : VitalDelayType01 := DefPropDelay01;
        tpd_datab_combout   : VitalDelayType01 := DefPropDelay01;
        tpd_datac_combout   : VitalDelayType01 := DefPropDelay01;
        tpd_datad_combout   : VitalDelayType01 := DefPropDelay01;
        tpd_cin_combout     : VitalDelayType01 := DefPropDelay01;
        tpd_cin0_combout    : VitalDelayType01 := DefPropDelay01;
        tpd_cin1_combout    : VitalDelayType01 := DefPropDelay01;
        tpd_inverta_combout : VitalDelayType01 := DefPropDelay01;
        tpd_qfbkin_combout  : VitalDelayType01 := DefPropDelay01;
        tpd_dataa_regin     : VitalDelayType01 := DefPropDelay01;
        tpd_datab_regin     : VitalDelayType01 := DefPropDelay01;
        tpd_datac_regin     : VitalDelayType01 := DefPropDelay01;
        tpd_datad_regin     : VitalDelayType01 := DefPropDelay01;
        tpd_cin_regin       : VitalDelayType01 := DefPropDelay01;
        tpd_cin0_regin      : VitalDelayType01 := DefPropDelay01;
        tpd_cin1_regin      : VitalDelayType01 := DefPropDelay01;
        tpd_inverta_regin   : VitalDelayType01 := DefPropDelay01;
        tpd_qfbkin_regin    : VitalDelayType01 := DefPropDelay01;
        tpd_dataa_cout      : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cout      : VitalDelayType01 := DefPropDelay01;
        tpd_cin_cout        : VitalDelayType01 := DefPropDelay01;
        tpd_cin0_cout       : VitalDelayType01 := DefPropDelay01;
        tpd_cin1_cout       : VitalDelayType01 := DefPropDelay01;
        tpd_inverta_cout    : VitalDelayType01 := DefPropDelay01;
        tpd_dataa_cout0     : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cout0     : VitalDelayType01 := DefPropDelay01;
        tpd_cin0_cout0      : VitalDelayType01 := DefPropDelay01;
        tpd_inverta_cout0   : VitalDelayType01 := DefPropDelay01;
        tpd_dataa_cout1     : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cout1     : VitalDelayType01 := DefPropDelay01;
        tpd_cin1_cout1      : VitalDelayType01 := DefPropDelay01;
        tpd_inverta_cout1   : VitalDelayType01 := DefPropDelay01;
        tipd_dataa          : VitalDelayType01 := DefPropDelay01; 
        tipd_datab          : VitalDelayType01 := DefPropDelay01; 
        tipd_datac          : VitalDelayType01 := DefPropDelay01; 
        tipd_datad          : VitalDelayType01 := DefPropDelay01; 
        tipd_cin            : VitalDelayType01 := DefPropDelay01; 
        tipd_cin0           : VitalDelayType01 := DefPropDelay01; 
        tipd_cin1           : VitalDelayType01 := DefPropDelay01; 
        tipd_inverta        : VitalDelayType01 := DefPropDelay01
        );

    PORT (
          dataa     : in std_logic := '1';
          datab     : in std_logic := '1';
          datac     : in std_logic := '1';
          datad     : in std_logic := '1';
          cin       : in std_logic := '0';
          cin0      : in std_logic := '0';
          cin1      : in std_logic := '1';
          inverta   : in std_logic := '0';
          qfbkin    : in std_logic := '0';
          mode      : in std_logic_vector(5 downto 0);
          regin     : out std_logic;
          combout   : out std_logic;
          cout      : out std_logic;
          cout0     : out std_logic;
          cout1     : out std_logic
         );
end COMPONENT;


COMPONENT maxv_lcell_register
    GENERIC (
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        
        tsetup_regcascin_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_regcascin_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_regout_posedge   : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_regout_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_clk_qfbkout_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_qfbkout_posedge : VitalDelayType01 := DefPropDelay01;
              
        tipd_clk       : VitalDelayType01 := DefPropDelay01;
        tipd_datac     : VitalDelayType01 := DefPropDelay01;
        tipd_regcascin : VitalDelayType01 := DefPropDelay01; 
        tipd_ena       : VitalDelayType01 := DefPropDelay01; 
        tipd_aclr      : VitalDelayType01 := DefPropDelay01; 
        tipd_aload     : VitalDelayType01 := DefPropDelay01; 
        tipd_sclr      : VitalDelayType01 := DefPropDelay01; 
        tipd_sload     : VitalDelayType01 := DefPropDelay01
        );

    PORT (
          clk     :in std_logic := '0';
          datain  : in std_logic := '0';
          datac   : in std_logic := '0';
          regcascin : in std_logic := '0';
          aclr    : in std_logic := '0';
          aload   : in std_logic := '0';
          sclr    : in std_logic := '0';
          sload   : in std_logic := '0';
          ena     : in std_logic := '1';
          cena : in std_logic := '0';
          xonv : in std_logic := '1';
          smode : in std_logic := '0';
          regout  : out std_logic;
          qfbkout : out std_logic
         );

end COMPONENT;

signal aclr1, xonv, cena, smode : std_logic ;

begin

    aclr1 <= aclr or (not devclrn) or (not devpor);
    cena  <= '1' when (register_cascade_mode = "on") else '0';
    xonv  <= '1' when (x_on_violation = "on") else '0';
    smode <= '1' when (synch_mode = "on") else '0';
     

    mode(0) <= '1' when operation_mode = "normal" else
               '0'; --  operation_mode = "arithmetic"
    mode(1) <= '1' when sum_lutc_input = "datac" else
               '0' ; -- sum_lutc_input = "cin"
    mode(2) <= '1' when sum_lutc_input = "qfbk" else
               '0'; --  sum_lutc_input = "cin" or "datac"
    mode(3) <= '1' when cin_used = "true" else 
               '0'; --  cin_used = "false"
    mode(4) <= '1' when cin0_used = "true" else 
               '0'; --  cin0_used = "false"
    mode(5) <= '1' when cin1_used = "true" else 
               '0'; --  cin1_used = "false"

    lecomb: maxv_asynch_lcell
            GENERIC map (
                         lms => str_to_bin(lut_mask)
                        )
            PORT map (
                      dataa => dataa,
                      datab => datab,
                      datac => datac,
                      datad => datad,
                      qfbkin => qfbkin,
                      inverta => map_x_to_0(inverta),
                      cin => cin,
                      cin0 => cin0,
                      cin1 => cin1,
                      mode => mode,
                      combout => combout,
                      cout => cout,
                      cout0 => cout0,
                      cout1 => cout1,
                      regin => dffin
                     );

    lereg: maxv_lcell_register

           PORT map (
                     clk => clk, 
                     datain => dffin, 
                     datac => datac, 
                     smode => smode,
                     regcascin => regcascin,
                     aclr => aclr1, 
                     aload => aload, 
                     sclr => sclr, 
                     sload => sload, 
                     ena => ena, 
                     cena => cena, 
                     xonv => xonv, 
                     regout => regout, 
                     qfbkout => qfbkin
                    );

end vital_le_atom;

--/////////////////////////////////////////////////////////////////////////////
--
--                  MAXV UFM ATOM
--
--
--/////////////////////////////////////////////////////////////////////////////

-- MODULE DECLARATION

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use std.textio.all;
use work.maxv_atom_pack.all;

entity maxv_ufm is
    generic (
        -- PARAMETER DECLARATION
        address_width   : integer := 9;
        init_file       : string := "none";
        lpm_type        : string := "maxv_ufm";
        mem1            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem2            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem3            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem4            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem5            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem6            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem7            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem8            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem9            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem10           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem11           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem12           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem13           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem14           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem15           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        mem16           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
        osc_sim_setting : integer := 180000; -- default osc frequency to 5.56MHz
        program_time    : integer := 1600000; -- default program_time is 1600ns
        erase_time      : integer := 500000000; -- default erase time is 500us

        TimingChecksOn: Boolean := True;
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;

        tpd_program_busy_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_erase_busy_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_drclk_drdout_posedge: VitalDelayType01 := DefPropDelay01;
        tpd_oscena_osc_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_sbdin_sbdout : VitalDelayType01 := DefPropDelay01;

        tsetup_arshft_arclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        tsetup_ardin_arclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_drshft_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        tsetup_drdin_drclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_oscena_program_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_oscena_erase_noedge_posedge : VitalDelayType := DefSetupHoldCnst;

        thold_arshft_arclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_ardin_arclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_drshft_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_drdin_drclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;

        thold_program_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
        thold_erase_arclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        thold_oscena_program_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_oscena_erase_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_program_busy_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_erase_busy_noedge_negedge : VitalDelayType := DefSetupHoldCnst;

        tipd_program  : VitalDelayType01 := DefPropDelay01;
        tipd_erase : VitalDelayType01 := DefPropDelay01;
        tipd_oscena : VitalDelayType01 := DefPropDelay01;
        tipd_arclk : VitalDelayType01 := DefPropDelay01;
        tipd_arshft : VitalDelayType01 := DefPropDelay01;
        tipd_ardin : VitalDelayType01 := DefPropDelay01;
        tipd_drclk : VitalDelayType01 := DefPropDelay01;
        tipd_drshft : VitalDelayType01 := DefPropDelay01;
        tipd_drdin : VitalDelayType01 := DefPropDelay01;
        tipd_sbdin : VitalDelayType01 := DefPropDelay01
        );
    port (
        program       : in std_logic := '0';
        erase         : in std_logic := '0';
        oscena        : in std_logic;
        arclk         : in std_logic;
        arshft        : in std_logic;
        ardin         : in std_logic;
        drclk         : in std_logic;
        drshft        : in std_logic;
        drdin         : in std_logic := '0';
        sbdin         : in std_logic := '0';
        devclrn       : in std_logic := '1'; -- simulation only port
        devpor        : in std_logic := '1'; -- simulation only port
        ctrl_bgpbusy  : in std_logic := '0'; -- simulation only port, to control
                                             --   and emulate the output
                                             --   behaviour of bgpbusy
        busy          : out std_logic;
        osc           : out std_logic := 'X';
        drdout        : out std_logic;
        sbdout        : out std_logic;
        bgpbusy       : out std_logic);

END maxv_ufm;

architecture behave of maxv_ufm is

    -- CONSTANT DECLARATION
    constant WIDTHDATA           : integer := 16;
    constant SECTOR0_RANGE       : integer := (2**(address_width-1));
    constant SECTOR_SIZE         : integer := (WIDTHDATA * (2**(address_width-1)));

    -- TYPE DECLARATION
    type ufm_memory is array ((2**address_width)-1 downto 0) of std_logic_vector(WIDTHDATA-1 downto 0);

    -- SIGNAL DECLARATION
    signal addr_reg         : std_logic_vector(address_width - 1 downto 0) := (OTHERS => '0');
    signal data_reg         : std_logic_vector((WIDTHDATA - 1) downto 0) := (OTHERS => 'X');
    signal storage_output   : std_logic_vector((WIDTHDATA - 1) downto 0) := (OTHERS => '1');
    signal int_osc          : std_logic := 'X';
    signal program_pulse    : std_logic := '0';
    signal erase_pulse      : std_logic := '0';
    signal sys_busy         : std_logic;
    signal i                : integer;
    signal j                : integer;
    signal numwords         : integer;

    signal program_ipd      : std_logic;
    signal erase_ipd        : std_logic;
    signal oscena_ipd       : std_logic;
    signal arclk_ipd        : std_logic;
    signal arshft_ipd       : std_logic;
    signal ardin_ipd        : std_logic;
    signal drclk_ipd        : std_logic;
    signal drshft_ipd       : std_logic;
    signal drdin_ipd        : std_logic;
    signal sbdin_ipd        : std_logic;
    signal program_reg      : std_logic;
    signal erase_reg        : std_logic;
    signal busy_tmp         : std_logic;

    -- FUNCTION DECLARATION
    -- convert std_logic_vector to integer
    function convert_to_int(arg : in std_logic_vector) return integer is
        variable result : integer := 0;
    begin
        result := 0;
        for i in arg'range loop
            if arg(i) = '1' then
                result := result + 2**i;
            end if;
        end loop;
        return result;
    end convert_to_int;

begin
    bgpbusy <= ctrl_bgpbusy;        -- No delay necessary as for simulation only


    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (program_ipd, program, tipd_program);
        VitalWireDelay (erase_ipd, erase, tipd_erase);
        VitalWireDelay (oscena_ipd, oscena, tipd_oscena);
        VitalWireDelay (arclk_ipd, arclk, tipd_arclk);
        VitalWireDelay (arshft_ipd, arshft, tipd_arshft);
        VitalWireDelay (ardin_ipd, ardin, tipd_ardin);
        VitalWireDelay (drclk_ipd, drclk, tipd_drclk);
        VitalWireDelay (drshft_ipd, drshft, tipd_drshft);
        VitalWireDelay (drdin_ipd, drdin, tipd_drdin);
        VitalWireDelay (sbdin_ipd, sbdin, tipd_sbdin);
    end block;


    VITAL_sbdin : process (sbdin_ipd)
        variable sbdout_tmp   : std_logic;
        variable sbdout_VitalGlitchData : VitalGlitchDataType;
    begin
        sbdout <= sbdin_ipd;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
          OutSignal => sbdout,
          OutSignalName => "SBDOUT",
          OutTemp => sbdout_tmp,
          Paths => (0 => (sbdin_ipd'last_event, tpd_sbdin_sbdout, TRUE)),
          GlitchData => sbdout_VitalGlitchData,
          Mode => DefGlitchMode,
          XOn  => XOn,
          MsgOn  => MsgOn );
    end process;


    -- Produce oscillation clock to UFM
    VITAL_oscena : process (oscena_ipd, int_osc)
        variable osc_VitalGlitchData : VitalGlitchDataType;
        variable first_warning : boolean := true;
        variable TOSCMN_PW : time := 90000 ps; --pulse width of osc - default to 1/2 of osc period
        variable need_init : boolean := true;
    begin

        if (need_init = true) then
            if (osc_sim_setting /= 0) then
                TOSCMN_PW := (osc_sim_setting / 2) * 1 ps;
                need_init := false;
            end if;
        end if;

        if (oscena_ipd = '1') then
            if (first_warning = true) then
                assert FALSE
                report "UFM oscillator can operate at any frequency between 3.33MHz to 5.56Mhz."
                severity NOTE;

                first_warning := false;
            end if;
            if ((int_osc = '0') or (int_osc = '1')) then
                int_osc <= not int_osc after TOSCMN_PW;
            else
                int_osc <= '0' after TOSCMN_PW;
            end if;
        else
            int_osc <= '1' after TOSCMN_PW;
        end if;

        VitalPathDelay01 (
            OutSignal     => osc,
            OutSignalName => "osc",
            OutTemp       => int_osc,
            Paths         => (0 => (InputChangeTime => oscena_ipd'last_event,
                                    PathDelay => tpd_oscena_osc_posedge,
                                    PathCondition => (oscena_ipd = '1'))),
            GlitchData    => osc_VitalGlitchData,
            Mode          => DefGlitchMode,
            XOn           => XOn,
            MsgOn         => MsgOn );
    end process;


    -- Shift address from LSB to MSB when arshft is '1'; else increment address.
    -- (Using block statement to avoid race condition warning; therefore, the
    -- order of assignments must be taken care to ensure correct behaviour)
    VITAL_arclk : process (arclk_ipd, arshft_ipd, ardin_ipd, sys_busy, devclrn, devpor)
        variable addr_reg_var  : std_logic_vector(address_width-1 downto 0) := (OTHERS => '0');
        variable Tviol_arshft_arclk : std_ulogic := '0';
        variable Tviol_ardin_arclk  : std_ulogic := '0';
        variable TimingData_arshft_arclk : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_ardin_arclk : VitalTimingDataType := VitalTimingDataInit;

    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
            -- setup and hold time verification on ARSHFT
            VitalSetupHoldCheck (
                Violation       => Tviol_arshft_arclk,
                TimingData      => TimingData_arshft_arclk,
                TestSignal      => arshft_ipd,
                TestSignalName  => "arshft",
                RefSignal       => arclk_ipd,
                RefSignalName   => "arclk",
                SetupHigh       => tsetup_arshft_arclk_noedge_posedge,
                SetupLow        => tsetup_arshft_arclk_noedge_posedge,
                HoldHigh        => thold_arshft_arclk_noedge_posedge,
                HoldLow         => thold_arshft_arclk_noedge_posedge,
                CheckEnabled    => TO_X01(devpor AND devclrn) /= '0',
                RefTransition   => '/',
                HeaderMsg       => "/UFM Arshft VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

            -- setup and hold time verification on ARDIN
            VitalSetupHoldCheck (
                Violation       => Tviol_ardin_arclk,
                TimingData      => TimingData_ardin_arclk,
                TestSignal      => ardin_ipd,
                TestSignalName  => "ardin",
                RefSignal       => arclk_ipd,
                RefSignalName   => "arclk",
                SetupHigh       => tsetup_ardin_arclk_noedge_posedge,
                SetupLow        => tsetup_ardin_arclk_noedge_posedge,
                HoldHigh        => thold_ardin_arclk_noedge_posedge,
                HoldLow         => thold_ardin_arclk_noedge_posedge,
                CheckEnabled    => TO_X01(devpor AND devclrn) /= '0',
                RefTransition   => '/',
                HeaderMsg       => "/UFM Ardin VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );
        end if;

        -- The behaviour of ARSHFT and ARDIN
        if ((devpor = '0') or (devclrn = '0')) then
            addr_reg_var := (OTHERS => '0');
        elsif (arclk_ipd'event and arclk_ipd = '1' and sys_busy = '0') then
            if (address_width /= 9) then
                assert false
                report "address_width parameter must be equal to 9."
                severity error;
            end if;
            if (arshft_ipd = '1') then
                for i in address_width-1 downto 1 loop
                    addr_reg_var(i) := addr_reg(i-1);
                end loop;
                addr_reg_var(0) := ardin_ipd;
            else
                addr_reg_var := addr_reg_var + '1';
            end if;
        end if;

        addr_reg <= addr_reg_var;

    end process;


    -- Shift data from LSB to MSB when drshft is '1'; else load new data.
    VITAL_drclk : process (drclk_ipd, drshft_ipd, drdin_ipd, sys_busy, devclrn, devpor)
        variable drdout_tmp   : std_logic;
        variable data_reg_var : std_logic_vector((WIDTHDATA - 1) downto 0) := (OTHERS => 'X');
        variable Tviol_drshft_drclk : std_ulogic := '0';
        variable Tviol_drdin_drclk  : std_ulogic := '0';
        variable TimingData_drshft_drclk : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_drdin_drclk : VitalTimingDataType := VitalTimingDataInit;
        variable drdout_VitalGlitchData : VitalGlitchDataType;
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
            -- setup and hold time verification on DRSHFT
            VitalSetupHoldCheck (
                Violation       => Tviol_drshft_drclk,
                TimingData      => TimingData_drshft_drclk,
                TestSignal      => drshft_ipd,
                TestSignalName  => "drshft",
                RefSignal       => drclk_ipd,
                RefSignalName   => "drclk",
                SetupHigh       => tsetup_drshft_drclk_noedge_posedge,
                SetupLow        => tsetup_drshft_drclk_noedge_posedge,
                HoldHigh        => thold_drshft_drclk_noedge_posedge,
                HoldLow         => thold_drshft_drclk_noedge_posedge,
                CheckEnabled    => TO_X01(devpor AND devclrn) /= '0',
                RefTransition   => '/',
                HeaderMsg       => "/UFM Drshft VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

            -- setup and hold time verification on DRDIN
            VitalSetupHoldCheck (
                Violation       => Tviol_drdin_drclk,
                TimingData      => TimingData_drdin_drclk,
                TestSignal      => drdin_ipd,
                TestSignalName  => "drdin",
                RefSignal       => drclk_ipd,
                RefSignalName   => "drclk",
                SetupHigh       => tsetup_drdin_drclk_noedge_posedge,
                SetupLow        => tsetup_drdin_drclk_noedge_posedge,
                HoldHigh        => thold_drdin_drclk_noedge_posedge,
                HoldLow         => thold_drdin_drclk_noedge_posedge,
                CheckEnabled    => TO_X01(devpor AND devclrn) /= '0',
                RefTransition   => '/',
                HeaderMsg       => "/UFM Drdin VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );
        end if;

        -- The behaviour of DRSHFT and DRDIN
        if ((devpor = '0') or (devclrn = '0')) then
            data_reg_var := (OTHERS => '0');
        elsif (drclk_ipd'EVENT AND drclk_ipd = '1' and sys_busy = '0') then
            if (drshft_ipd = '1') then
                for j in WIDTHDATA-1 downto 1 loop
                    data_reg_var(j) := data_reg(j - 1);
                end loop;
                data_reg_var(0) := drdin_ipd;
            else
                data_reg_var := storage_output;
            end if;
        end if;
        data_reg <= data_reg_var;
        drdout_tmp := data_reg_var((WIDTHDATA - 1));

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal     => drdout,
            OutSignalName => "drdout",
            OutTemp       => drdout_tmp,
            Paths         => (0 => (InputChangeTime => drclk_ipd'last_event,
                                    PathDelay => tpd_drclk_drdout_posedge,
                                    PathCondition => (drclk_ipd = '1'))),
            GlitchData    => drdout_VitalGlitchData,
            Mode          => DefGlitchMode,
            XOn           => XOn,
            MsgOn         => MsgOn );

    end process;

    REG_PROG_ERASE : process (int_osc)
    begin
        if(int_osc'event and int_osc = '1') then
            program_reg <= program_ipd;
            erase_reg <= erase_ipd;
        end if;
    end process;

    VITAL_program_erase : process (program_ipd, erase_ipd, program_reg, erase_reg, drclk_ipd, arclk_ipd, oscena_ipd)
        variable Tviol_erase_arclk      : std_ulogic := '0';
        variable Tviol_program_drclk    : std_ulogic := '0';
        variable Tviol_oscena_program   : std_ulogic := '0';
        variable Tviol_oscena_erase     : std_ulogic := '0';
        variable TimingData_erase_arclk : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_program_drclk : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_oscena_erase : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_oscena_program : VitalTimingDataType := VitalTimingDataInit;
        variable TPPMX : time := 1600000 ps;
        variable TEPMX : time := 500000000 ps;
        variable need_init: boolean := true;


    begin

        if (need_init = true) then
            if (program_time /= 0) then
                TPPMX := (program_time * 1 ps);
            end if;
            if (erase_time /= 0) then
                TEPMX := (erase_time/1000) * 1 ps;
            end if;
            need_init := false;
        end if;

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
            -- hold time verification on DRCLK
            VitalSetupHoldCheck (
                Violation       => Tviol_program_drclk,
                TimingData      => TimingData_program_drclk,
                TestSignal      => program_ipd,
                TestSignalName  => "program",
                RefSignal       => drclk_ipd,
                RefSignalName   => "drclk",
                HoldHigh        => thold_program_drclk_noedge_posedge,
                HoldLow         => thold_program_drclk_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => "/UFM Program to Drclk VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

            -- hold time verification on ARCLK
            VitalSetupHoldCheck (
                Violation       => Tviol_erase_arclk,
                TimingData      => TimingData_erase_arclk,
                TestSignal      => erase_ipd,
                TestSignalName  => "erase",
                RefSignal       => arclk_ipd,
                RefSignalName   => "arclk",
                HoldHigh        => thold_erase_arclk_noedge_posedge,
                HoldLow         => thold_erase_arclk_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => "/UFM Erase to Arclk VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

            -- setuphold check for oscena vs program
            VitalSetupHoldCheck (
                Violation       => Tviol_oscena_program,
                TimingData      => TimingData_oscena_program,
                TestSignal      => oscena_ipd,
                TestSignalName  => "oscena",
                RefSignal       => program_ipd,
                RefSignalName   => "program",
                SetupHigh       => tsetup_oscena_program_noedge_posedge,
                SetupLow        => tsetup_oscena_program_noedge_posedge,
                HoldHigh        => thold_oscena_program_noedge_negedge,
                HoldLow         => thold_oscena_program_noedge_negedge,
                CheckEnabled    => TO_X01(devpor AND devclrn) /= '0',
                RefTransition   => '/',
                HeaderMsg       => "/UFM OSCENA to PROGRAM VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

            -- setuphold check for oscena vs erase
            VitalSetupHoldCheck (
                Violation       => Tviol_oscena_erase,
                TimingData      => TimingData_oscena_erase,
                TestSignal      => oscena_ipd,
                TestSignalName  => "oscena",
                RefSignal       => erase_ipd,
                RefSignalName   => "erase",
                SetupHigh       => tsetup_oscena_erase_noedge_posedge,
                SetupLow        => tsetup_oscena_erase_noedge_posedge,
                HoldHigh        => thold_oscena_erase_noedge_negedge,
                HoldLow         => thold_oscena_erase_noedge_negedge,
                CheckEnabled    => TO_X01(devpor AND devclrn) /= '0',
                RefTransition   => '/',
                HeaderMsg       => "/UFM OSCENA to ERASE VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

        end if;

        -- Pulse to indicate programming UFM for maxinum time of
        -- TPPMX
        if (program_reg'event and program_reg = '1') then
            if (sys_busy = '0' and program_pulse = '0') then
                program_pulse <= '1';
                program_pulse <= transport '0' after TPPMX;
            end if;
        elsif (erase_reg'event and erase_reg = '1') then
        -- Pulse to indicate erasing UFM for maxinum time of
        -- TEPMX
            if (sys_busy = '0' and erase_pulse = '0') then
                erase_pulse <= '1';
                erase_pulse <= transport '0' after (TEPMX * 1000);
            end if;
        end if;

    end process;


    -- Insert timing delay for Erase and Program to Busy
    VITAL_pulse : process(program_pulse, erase_pulse, program_ipd, erase_ipd, busy_tmp)
        variable Tviol_program_busy : std_ulogic := '0';
        variable Tviol_erase_busy : std_ulogic := '0';
        variable TimingData_program_busy : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_erase_busy : VitalTimingDataType := VitalTimingDataInit;
        variable busy_VitalGlitchData : VitalGlitchDataType;
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
            -- hold time verification on PROGRAM from BUSY's falling edge
            VitalSetupHoldCheck (
                Violation       => Tviol_program_busy,
                TimingData      => TimingData_program_busy,
                TestSignal      => program_ipd,
                TestSignalName  => "program",
                RefSignal       => busy_tmp,
                RefSignalName   => "busy",
                HoldHigh        => thold_program_busy_noedge_negedge,
                HoldLow         => thold_program_busy_noedge_negedge,
                RefTransition   => '/',
                HeaderMsg       => "/UFM Busy to Program VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );

            -- hold time verification on ERASE from BUSY's falling edge
            VitalSetupHoldCheck (
                Violation       => Tviol_erase_busy,
                TimingData      => TimingData_erase_busy,
                TestSignal      => erase_ipd,
                TestSignalName  => "erase",
                RefSignal       => busy_tmp,
                RefSignalName   => "busy",
                HoldHigh        => thold_erase_busy_noedge_negedge,
                HoldLow         => thold_erase_busy_noedge_negedge,
                RefTransition   => '/',
                HeaderMsg       => "/UFM Busy to Erase VitalSetupHoldCheck",
                XOn             => TRUE,
                MsgOn           => TRUE );
        end if;

        sys_busy <= busy_tmp;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal     => busy,
            OutSignalName => "busy",
            OutTemp       => busy_tmp,
            Paths         => (0 => (InputChangeTime => erase_ipd'last_event,
                                    PathDelay => tpd_erase_busy_posedge,
                                    PathCondition => (erase_pulse = '1')),
                              1 => (InputChangeTime => program_ipd'last_event,
                                    PathDelay => tpd_program_busy_posedge,
                                    PathCondition => (program_pulse = '1'))),
            GlitchData    => busy_VitalGlitchData,
            Mode          => DefGlitchMode,
            XOn           => XOn,
            MsgOn         => MsgOn );

    end process;

    VITAL_busy : process(program_pulse, erase_pulse)
    begin
        busy_tmp <= program_pulse or erase_pulse;
    end process;


    -- MEMORY PROCESSING BLOCK
    MEMORY: process(program_pulse, erase_pulse, addr_reg)
        variable ufm_storage : ufm_memory;   -- UFM sector0 and sector1
        variable ufm_initf_sec0 : std_logic_vector((SECTOR_SIZE-1) downto 0) := (OTHERS=>'1');
        variable ufm_initf_sec1 : std_logic_vector((SECTOR_SIZE-1) downto 0) := (OTHERS=>'1');
        variable init_word0 : std_logic_vector ((WIDTHDATA - 1) downto 0);
        variable init_word1 : std_logic_vector ((WIDTHDATA - 1) downto 0);
        variable storage_init : boolean := false;
        variable i       : integer := 0;
        variable k       : integer := 0;
        variable mem_cnt : integer := 0;
        variable bit_cnt : integer := 0;

    begin
        -- INITIALIZE --
        if NOT(storage_init) then
            -- INITIALIZE TO 1; UFM content is initially all 1's
            for i in ufm_storage'low to ufm_storage'high loop
                ufm_storage(i) := (OTHERS => '1');
            end loop;

            if (init_file = "none") then
                assert FALSE
                report "Not using any memory initialization file."
                severity WARNING;
            else
                -- initialize UFM from memory initialization file (*.mif or *.hex)
                -- the contents of the memory initialization file are passed in via the
                -- mem* parameters
                ufm_initf_sec0(SECTOR_SIZE-1 downto 0) := (mem8 & mem7 & mem6 & mem5 &
                                                           mem4 & mem3 & mem2 & mem1);
                ufm_initf_sec1(SECTOR_SIZE-1 downto 0) := (mem16 & mem15 & mem14 & mem13 &
                                                           mem12 & mem11 & mem10 & mem9);

                for mem_cnt in 1 to SECTOR0_RANGE loop
                    for bit_cnt in 0 to (WIDTHDATA-1) loop
                        init_word0(bit_cnt) := ufm_initf_sec0(((mem_cnt-1)*WIDTHDATA) + bit_cnt);
                        init_word1(bit_cnt) := ufm_initf_sec1(((mem_cnt-1)*WIDTHDATA) + bit_cnt);
                    end loop;

                    ufm_storage(mem_cnt-1) := init_word0;
                    ufm_storage((mem_cnt-1) + SECTOR0_RANGE) := init_word1;
                end loop;
            end if;
            storage_init := TRUE;

        end if; -- if NOT(storage_init)

        -- MEMORY FUNCTION --

        -- Programming data into the UFM
        if (program_pulse'EVENT and program_pulse = '1') then
            ufm_storage(convert_to_int(addr_reg)) := data_reg and
                                       ufm_storage(convert_to_int(addr_reg));
        elsif (erase_pulse'EVENT and erase_pulse = '1') then
        -- Erasing data from selected sector of UFM
            if (addr_reg(address_width - 1) = '0') then
                for k in 0 to (SECTOR0_RANGE - 1) loop
                   ufm_storage(k) := (others => '1');
                end loop;
            else
                for k in SECTOR0_RANGE to (SECTOR0_RANGE * 2 - 1) loop
                    ufm_storage(k) := (others => '1');
                end loop;
            end if;
        end if;

        storage_output <= ufm_storage(convert_to_int(addr_reg)) ;

    end process; -- memory

END behave;
--
--
--  MAXV_IO Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.maxv_atom_pack.all;

entity maxv_io is
    generic(
            lpm_type  : STRING := "maxv_io";
            operation_mode  : STRING := "input";
            open_drain_output : STRING := "false";
            bus_hold : STRING := "false";

            XOn: Boolean := DefGlitchXOn;
            MsgOn: Boolean := DefGlitchMsgOn;

            tpd_datain_padio : VitalDelayType01 := DefPropDelay01;
            tpd_oe_padio_posedge : VitalDelayType01 := DefPropDelay01;
            tpd_oe_padio_negedge : VitalDelayType01 := DefPropDelay01;
            tpd_padio_combout : VitalDelayType01 := DefPropDelay01;

            tipd_datain : VitalDelayType01 := DefPropDelay01;
            tipd_oe : VitalDelayType01 := DefPropDelay01;
            tipd_padio : VitalDelayType01 := DefPropDelay01
           );
    port(
        datain : in  STD_LOGIC := '0';
        oe : in  STD_LOGIC := '1';
        padio : inout STD_LOGIC;
        combout : out STD_LOGIC
        );
		
    attribute VITAL_LEVEL0 of maxv_io : entity is TRUE;
end maxv_io;

architecture behave of maxv_io is
attribute VITAL_LEVEL0 of behave : architecture is TRUE;
signal datain_ipd : std_logic;
signal oe_ipd : std_logic;
signal padio_ipd : std_logic;

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
    variable combout_VitalGlitchData : VitalGlitchDataType;
    variable padio_VitalGlitchData : VitalGlitchDataType;
    variable tmp_combout : std_logic;
    variable tmp_padio : std_logic;
    variable prev_value : std_logic := 'H';

    begin

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

            if ( now <= 1 ps AND prev_value = 'W' ) then --for autotest
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

    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
        OutSignal => combout,
        OutSignalName => "combout",
        OutTemp => tmp_combout,
        Paths => (1 => (padio_ipd'last_event, tpd_padio_combout, TRUE)),
        GlitchData => combout_VitalGlitchData,
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


---------------------------------------------------------------------
--
-- Entity Name :  maxv_routing_wire
--
-- Description :  StratixII Routing Wire VHDL simulation model
--
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.maxv_atom_pack.all;

ENTITY maxv_routing_wire is
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
   attribute VITAL_LEVEL0 of maxv_routing_wire : entity is TRUE;
end maxv_routing_wire;

ARCHITECTURE behave of maxv_routing_wire is
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
