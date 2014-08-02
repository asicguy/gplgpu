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

package cyclone_atom_pack is

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
    TYPE cyclone_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

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

end cyclone_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body cyclone_atom_pack is

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

end cyclone_atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package cyclone_pllpack is


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

end cyclone_pllpack;

package body cyclone_pllpack is


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

end cyclone_pllpack;

--
--
--  DFFE Model
--
--

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cyclone_atom_pack.all;

entity cyclone_dffe is
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
    attribute VITAL_LEVEL0 of cyclone_dffe : entity is TRUE;
end cyclone_dffe;

-- architecture body --

architecture behave of cyclone_dffe is
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
--  cyclone_mux21 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.cyclone_atom_pack.all;

entity cyclone_mux21 is
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
    attribute VITAL_LEVEL0 of cyclone_mux21 : entity is TRUE;
end cyclone_mux21;

architecture AltVITAL of cyclone_mux21 is
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
--  cyclone_mux41 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.cyclone_atom_pack.all;

entity cyclone_mux41 is
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
    attribute VITAL_LEVEL0 of cyclone_mux41 : entity is TRUE;
end cyclone_mux41;

architecture AltVITAL of cyclone_mux41 is
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
--  cyclone_and1 Model
--
--
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.cyclone_atom_pack.all;

-- entity declaration --
entity cyclone_and1 is
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
    attribute VITAL_LEVEL0 of cyclone_and1 : entity is TRUE;
end cyclone_and1;

-- architecture body --

architecture AltVITAL of cyclone_and1 is
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
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for CYCLONE Atoms
--
--/////////////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cyclone_asynch_lcell
--
-- Description : VHDL simulation model for the asynchnous submodule of
--               Cyclone Lcell.
--
-- Outputs     : Asynchnous LUT function of Cyclone Lcell.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.cyclone_atom_pack.all;

ENTITY cyclone_asynch_lcell is
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
    attribute VITAL_LEVEL0 of cyclone_asynch_lcell : ENTITY is TRUE;

END cyclone_asynch_lcell;
        
ARCHITECTURE vital_le of cyclone_asynch_lcell is
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
-- Entity Name : cyclone_lcell_register
--
-- Description : VHDL simulation model for the register submodule of
--               Cyclone Lcell.
--
-- Outputs     : Registered output of Cyclone Lcell.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cyclone_atom_pack.all;

ENTITY cyclone_lcell_register is
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
   attribute VITAL_LEVEL0 of cyclone_lcell_register : ENTITY is TRUE;
end cyclone_lcell_register;
        
ARCHITECTURE vital_le_reg of cyclone_lcell_register is
    attribute VITAL_LEVEL1 of vital_le_reg : ARCHITECTURE is TRUE;
    signal ena_ipd : std_ulogic := '1';
    signal sload_ipd : std_ulogic := '0';
    signal aload_ipd : std_ulogic := '0';
    signal datac_ipd : std_ulogic := '0';
    signal regcascin_ipd : std_ulogic := '0';
    signal clk_ipd : std_ulogic := '0';
    signal aclr_ipd : std_ulogic := '0';
    signal sclr_ipd : std_ulogic := '0';
    
    constant cyclone_regtab : VitalStateTableType := (
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
            StateTable => cyclone_regtab,
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
-- Entity Name : cyclone_lcell
--
-- Description : VHDL simulation model for Cyclone Lcell.
--
-- Outputs     : Output of Cyclone Lcell.
--
--///////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cyclone_atom_pack.all;
use work.cyclone_asynch_lcell;
use work.cyclone_lcell_register;

ENTITY cyclone_lcell is
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
             lpm_type        : string := "cyclone_lcell"
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

end cyclone_lcell;
        
ARCHITECTURE vital_le_atom of cyclone_lcell is

signal dffin : std_logic;
signal qfbkin : std_logic;

signal mode : std_logic_vector(5 downto 0);


COMPONENT cyclone_asynch_lcell 
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


COMPONENT cyclone_lcell_register
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

    lecomb: cyclone_asynch_lcell
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

    lereg: cyclone_lcell_register

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
----------------------------------------------------------------------------
-- Module Name     : cyclone_ram_register
-- Description     : Register module for RAM inputs/outputs
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.cyclone_atom_pack.all;

ENTITY cyclone_ram_register IS

GENERIC (
    width   : INTEGER := 1;
    preset  : STD_LOGIC := '0';
    tipd_d  : VitalDelayArrayType01(143 DOWNTO 0) := (OTHERS => DefPropDelay01); 
    tipd_clk        : VitalDelayType01 := DefPropDelay01;
    tipd_ena        : VitalDelayType01 := DefPropDelay01;
    tipd_aclr       : VitalDelayType01 := DefPropDelay01;
    tpw_ena_posedge : VitalDelayType   := DefPulseWdthCnst;
    tpd_clk_q_posedge        : VitalDelayType01 := DefPropDelay01;
    tpd_aclr_q_posedge       : VitalDelayType01 := DefPropDelay01;
    tsetup_d_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
    thold_d_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
    tsetup_ena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    thold_ena_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
    tsetup_aclr_clk_noedge_posedge : VitalDelayType   := DefSetupHoldCnst;
    thold_aclr_clk_noedge_posedge  : VitalDelayType   := DefSetupHoldCnst
    );

PORT (
    d       : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    clk     : IN STD_LOGIC;
    ena     : IN STD_LOGIC;
    aclr    : IN STD_LOGIC;
    devclrn : IN STD_LOGIC;
    devpor  : IN STD_LOGIC;
    q       : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
    aclrout : OUT STD_LOGIC
    );

END cyclone_ram_register;

ARCHITECTURE reg_arch OF cyclone_ram_register IS

SIGNAL d_ipd : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
SIGNAL clk_ipd  : STD_LOGIC;
SIGNAL ena_ipd  : STD_LOGIC;
SIGNAL aclr_ipd : STD_LOGIC;

BEGIN

WireDelay : BLOCK
BEGIN
    loopbits : FOR i in d'RANGE GENERATE
        VitalWireDelay (d_ipd(i), d(i), tipd_d(i));
    END GENERATE;
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
END BLOCK;

PROCESS (d_ipd,ena_ipd,clk_ipd,aclr_ipd,devclrn,devpor)
VARIABLE Tviol_clk_ena        : STD_ULOGIC := '0';
VARIABLE Tviol_clk_aclr       : STD_ULOGIC := '0';
VARIABLE Tviol_data_clk       : STD_ULOGIC := '0';
VARIABLE TimingData_clk_ena   : VitalTimingDataType := VitalTimingDataInit;
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
    ELSIF (clk_ipd = '1' AND clk_ipd'EVENT AND ena_ipd = '1') THEN
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
-- Module Name     : cyclone_ram_pulse_generator
-- Description     : Generate pulse to initiate memory read/write operations
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.cyclone_atom_pack.all;

ENTITY cyclone_ram_pulse_generator IS
GENERIC (
    tipd_clk : VitalDelayType01 := (0.5 ns,0.5 ns);
    tipd_ena : VitalDelayType01 := DefPropDelay01;
    tpd_clk_pulse_posedge : VitalDelayType01 := DefPropDelay01
    );
PORT ( 
    clk,ena : IN STD_LOGIC;
    pulse,cycle : OUT STD_LOGIC
    );
ATTRIBUTE VITAL_Level0 OF cyclone_ram_pulse_generator:ENTITY IS TRUE;
END cyclone_ram_pulse_generator;

ARCHITECTURE pgen_arch OF cyclone_ram_pulse_generator IS
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
USE work.cyclone_atom_pack.all;
USE work.cyclone_ram_register;
USE work.cyclone_ram_pulse_generator;

ENTITY cyclone_ram_block IS
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
        lpm_type                  : string := "cyclone_ram_block";
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
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );

END cyclone_ram_block;

ARCHITECTURE block_arch OF cyclone_ram_block IS

COMPONENT cyclone_ram_pulse_generator
    PORT (
          clk                     : IN  STD_LOGIC;
          ena                     : IN  STD_LOGIC;
          pulse                   : OUT STD_LOGIC;
          cycle                   : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT cyclone_ram_register
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
                
     active_a_in <= ena0;
    
    
     active_b_in <= ena0 WHEN (port_b_read_enable_write_enable_clock = "clock0") ELSE ena1;
 
    -- Store clock enable value for SEAB/MEAB
    -- A port active 
    active_a_in_vec(0) <= active_a_in;
    active_port_a : cyclone_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => active_a_in_vec,
            clk => clk_a_in,
            aclr => wire_gnd,
            devclrn => wire_vcc,devpor => wire_vcc,
            ena => wire_vcc,
            q => active_a_out
        );
    active_a <= (active_a_out(0) = '1');
    active_write_a <= active_a AND (byteena_a_reg /= bytes_a_disabled);
    
    -- B port active
    active_b_in_vec(0) <= active_b_in;
    active_port_b : cyclone_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => active_b_in_vec,
            clk => clk_b_in,
            aclr => wire_gnd,
            devclrn => wire_vcc,devpor => wire_vcc,
            ena => wire_vcc,
            q => active_b_out
        );
    active_b <= (active_b_out(0) = '1');
    active_write_b <= active_b AND (byteena_b_reg /= bytes_b_disabled);

    
    


    -- ------ A input registers
    -- write enable
    we_a_reg_in(0) <= '0' WHEN mode_is_rom ELSE portawe;
    we_a_register : cyclone_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => we_a_reg_in,
            clk => clk_a_in,
            aclr => we_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
             ena => active_a_in,
            q   => we_a_reg_out,
            aclrout => we_a_clr
        );
    we_a_reg <= we_a_reg_out(0);
    
    -- address
    addr_a_register : cyclone_ram_register
        GENERIC MAP ( width => port_a_address_width )
        PORT MAP (
            d => portaaddr,
            clk => clk_a_in,
            aclr => addr_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            ena => active_a_in,
            q   => addr_a_reg,
            aclrout => addr_a_clr
        );
    -- data
    datain_a_register : cyclone_ram_register
        GENERIC MAP ( width => port_a_data_width )
        PORT MAP (
            d => portadatain,
            clk => clk_a_in,
            aclr => datain_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            ena => active_a_in,
            q   => datain_a_reg,
            aclrout => datain_a_clr
        );
    -- byte enable
    byteena_a_register : cyclone_ram_register
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
            ena => active_a_in,
            q   => byteena_a_reg,
            aclrout => byteena_a_clr
        );
    -- ------ B input registers 
    -- read/write enable
    rewe_b_reg_in(0) <= portbrewe;
    rewe_b_register : cyclone_ram_register
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
            ena => active_b_in,
            q   => rewe_b_reg_out,
            aclrout => rewe_b_clr
        );
    rewe_b_reg <= rewe_b_reg_out(0);
    
    
    
    -- address
    addr_b_register : cyclone_ram_register
        GENERIC MAP ( width  => port_b_address_width )
        PORT MAP (
            d => portbaddr,
            clk => clk_b_in,
            aclr => addr_b_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            ena => active_b_in,
            q   => addr_b_reg,
            aclrout => addr_b_clr
        );
    -- data
    datain_b_register : cyclone_ram_register
        GENERIC MAP ( width  => port_b_data_width )
        PORT MAP (
            d => portbdatain,
            clk => clk_b_in,
            aclr => datain_b_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            ena => active_b_in,
            q   => datain_b_reg,
            aclrout => datain_b_clr
        );
    -- byte enable
    byteena_b_register : cyclone_ram_register
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
    
    wpgen_a : cyclone_ram_pulse_generator 
        PORT MAP (
            clk => wpgen_a_clk,
            ena => wpgen_a_clkena,
            pulse => write_pulse(primary_port_is_a),
            cycle => write_cycle_a
        );
        
    wpgen_b_clk <= clk_b_in WHEN ram_type ELSE (NOT clk_b_in);
      wpgen_b_clkena <= '1' WHEN (active_write_b AND mode_is_bdp AND (rewe_b_reg = '1')) ELSE '0';
    
    
    wpgen_b : cyclone_ram_pulse_generator
        PORT MAP (
            clk => wpgen_b_clk,
            ena => wpgen_b_clkena,
            pulse => write_pulse(primary_port_is_b),
            cycle => write_cycle_b
            );
            
    -- Read  pulse generation
    rpgen_a_clkena <= '1' WHEN (active_a AND (we_a_reg = '0')) ELSE '0';
    
    rpgen_a : cyclone_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => rpgen_a_clkena,
            pulse => read_pulse(primary_port_is_a)
        );
    rpgen_b_clkena <= '1' WHEN (active_b AND mode_is_dp  AND (rewe_b_reg = '1')) OR 
                               (active_b AND mode_is_bdp AND (rewe_b_reg = '0'))
                         ELSE '0';
    rpgen_b : cyclone_ram_pulse_generator
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
            mem_val := (OTHERS => (OTHERS => (OTHERS => '0')));
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
    ftpgen_a : cyclone_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => ftpgen_a_clkena,
            pulse => read_pulse_feedthru(primary_port_is_a)
        );
   ftpgen_b_clkena <= '1' WHEN (active_b AND mode_is_bdp AND (rewe_b_reg = '1')) ELSE '0';               

    ftpgen_b : cyclone_ram_pulse_generator
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
    clkena_a_out <= ena0 WHEN (port_a_data_out_clock = "clock0") ELSE ena1;
    
    clkena_b_out <= ena0 WHEN (port_b_data_out_clock = "clock0") ELSE ena1;
    
    
    dataout_a <= dataout_prime WHEN primary_port_is_a ELSE dataout_sec;
    dataout_b <= (OTHERS => 'U') WHEN (mode_is_rom OR mode_is_sp) ELSE 
                 dataout_prime   WHEN primary_port_is_b ELSE dataout_sec;
    
    dataout_a_register : cyclone_ram_register
        GENERIC MAP ( width => port_a_data_width )
        PORT MAP (
            d => dataout_a,
            clk => clk_a_out,
                     aclr => dataout_a_clr,
            devclrn => devclrn,
            devpor => devpor,
            ena => clkena_a_out,
            q => dataout_a_reg
        );
        
    dataout_b_register : cyclone_ram_register
        GENERIC MAP ( width => port_b_data_width )
        PORT MAP (
            d => dataout_b,
            clk => clk_b_out,
                     aclr => dataout_b_clr,
            devclrn => devclrn,
            devpor => devpor,
            ena => clkena_b_out,
            q => dataout_b_reg
        );
        
   portadataout <= dataout_a_reg WHEN out_a_is_reg ELSE dataout_a;
   portbdataout <= dataout_b_reg WHEN out_b_is_reg ELSE dataout_b;
    

END block_arch;


--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cyclone_m_cntr
--
-- Description : Timing simulation model for the M counter. This is a
--               model for the loop feedback counter of the Cyclone PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY cyclone_m_cntr is
    PORT  ( clk           : IN std_logic;
            reset         : IN std_logic;
            cout          : OUT std_logic;
            initial_value : IN integer;
            modulus       : IN integer;
            time_delay    : IN integer;
            ph            : IN integer := 0);
END cyclone_m_cntr;

ARCHITECTURE behave of cyclone_m_cntr is
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
-- Entity Name : cyclone_n_cntr
--
-- Description : Timing simulation model for the N counter. This is a
--               model for the input counter of the Cyclone PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY cyclone_n_cntr is
    PORT  ( clk           : IN std_logic;
            reset         : IN std_logic;
            cout          : OUT std_logic;
            modulus       : IN integer;
            time_delay    : IN integer);
END cyclone_n_cntr;

ARCHITECTURE behave of cyclone_n_cntr is
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
                ASSERT FALSE REPORT "Invalid transition to 'X' detected on Cyclone PLL input clk. This edge will be ignored" severity warning;
            elsif (clk = '1' and first_rising_edge) then
                first_rising_edge := false;
                tmp_cout := clk;
            elsif (not first_rising_edge and (clk_last_valid_value /= clk)) then
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
-- Entity Name : cyclone_scale_cntr
--
-- Description : Timing simulation model for the output scale-down counters.
--               This is a common model for the L0, L1, G0, G1, G2, G3, E0,
--               E1, E2 and E3 output counters of the Cyclone PLL.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY cyclone_scale_cntr is
    PORT  ( clk            : IN std_logic;
            reset          : IN std_logic;
            initial        : IN integer;
            high           : IN integer;
            low            : IN integer;
            mode           : IN string := "bypass";
            time_delay     : IN integer;
            ph_tap         : IN natural;
            cout           : OUT std_logic);
END cyclone_scale_cntr;

ARCHITECTURE behave of cyclone_scale_cntr is
begin
    process (clk, reset)
    variable tmp_cout : std_logic := '0';
    variable count : integer := 1;
    variable output_shift_count : integer := 0;
    variable first_rising_edge : boolean := false;
    variable high_reg : integer := 0;
    variable low_reg : integer := 0;
    variable init : boolean := true;
    variable high_cnt_xfer_done : boolean := false;
    begin
        if (reset = '1') then
            count := 1;
            output_shift_count := 0;
            tmp_cout := '0';
            first_rising_edge := false;
        elsif (clk'event) then
            if (init) then
                init := false;
                high_reg := high;
                low_reg := low;
            end if;
            if (mode = "   off") then
                tmp_cout := '0';
            elsif (mode = "bypass") then
                tmp_cout := clk;
            elsif (not first_rising_edge) then
                if (clk = '1') then
                    output_shift_count := output_shift_count + 1;
                    if (output_shift_count = initial) then
                        tmp_cout := clk;
                        first_rising_edge := true;
                    end if;
                end if;
            elsif (output_shift_count < initial) then
                if (clk = '1') then
                    output_shift_count := output_shift_count + 1;
                end if;
            else
                count := count + 1;
                if (mode = "  even" and (count = (high_reg*2) + 1)) then
                    tmp_cout := '0';
                    if (high_cnt_xfer_done) then
                        low_reg := low;
                        high_cnt_xfer_done := false;
                    end if;
                elsif (mode = "   odd" and (count = high_reg*2)) then
                    tmp_cout := '0';
                    if (high_cnt_xfer_done) then
                        low_reg := low;
                        high_cnt_xfer_done := false;
                    end if;
                elsif (count = (high_reg + low_reg)*2 + 1) then
                    tmp_cout := '1';
                    count := 1;  -- reset count
                    if (high_reg /= high) then
                        high_cnt_xfer_done := true;
                        high_reg := high;
                    end if;
                end if;
            end if;
        end if;
        cout <= transport tmp_cout after time_delay * 1 ps;
    end process;

end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cyclone_pll_reg
--
-- Description : Simulation model for a simple DFF.
--               This is required for the generation of the bit slip-signals.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY cyclone_pll_reg is
    PORT  ( clk : in std_logic;
            ena : in std_logic := '1';
            d : in std_logic;
            clrn : in std_logic := '1';
            prn : in std_logic := '1';
            q : out std_logic);
end cyclone_pll_reg;

ARCHITECTURE behave of cyclone_pll_reg is
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
-- Entity Name : cyclone_pll
--
-- Description : Timing simulation model for the Cyclone StratixGX PLL.
--               In the functional mode, it is also the model for the altpll
--               megafunction.
--
-- Limitations : Does not support Spread Spectrum and Bandwidth.
--
-- Outputs     : Up to 10 output clocks, each defined by its own set of
--               parameters. Locked output (active high) indicates when the
--               PLL locks. clkbad, clkloss and activeclock are used for
--               clock switchover to indicate which input clock has gone
--               bad, when the clock switchover initiates and which input
--               clock is being used as the reference, respectively.
--               scandataout is the data output of the serial scan chain.
--
--///////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE STD.TEXTIO.all;
USE work.cyclone_atom_pack.all;
USE work.cyclone_pllpack.all;
USE work.cyclone_m_cntr;
USE work.cyclone_n_cntr;
USE work.cyclone_scale_cntr;
USE work.cyclone_dffe;
USE work.cyclone_pll_reg;

ENTITY cyclone_pll is
    GENERIC   ( operation_mode              : string := "normal";
                qualify_conf_done           : string := "off";
                compensate_clock            : string := "clk0";
                pll_type                    : string := "auto";  -- EGPP/FAST/AUTO
                scan_chain                  : string := "long";
                lpm_type                    : string := "cyclone_pll";

                clk0_multiply_by            : integer := 1;
                clk0_divide_by              : integer := 1;
                clk0_phase_shift            : string := "0";
                clk0_time_delay             : string := "0";
                clk0_duty_cycle             : integer := 50;

                clk1_multiply_by            : integer := 1;
                clk1_divide_by              : integer := 1;
                clk1_phase_shift            : string := "0";
                clk1_time_delay             : string := "0";
                clk1_duty_cycle             : integer := 50;

                clk2_multiply_by            : integer := 1;
                clk2_divide_by              : integer := 1;
                clk2_phase_shift            : string := "0";
                clk2_time_delay             : string := "0";
                clk2_duty_cycle             : integer := 50;

                clk3_multiply_by            : integer := 1;
                clk3_divide_by              : integer := 1;
                clk3_phase_shift            : string := "0";
                clk3_time_delay             : string := "0";
                clk3_duty_cycle             : integer := 50;

                clk4_multiply_by            : integer := 1;
                clk4_divide_by              : integer := 1;
                clk4_phase_shift            : string := "0";
                clk4_time_delay             : string := "0";
                clk4_duty_cycle             : integer := 50;

                clk5_multiply_by            : integer := 1;
                clk5_divide_by              : integer := 1;
                clk5_phase_shift            : string := "0";
                clk5_time_delay             : string := "0";
                clk5_duty_cycle             : integer := 50;

                extclk0_multiply_by         : integer := 1;
                extclk0_divide_by           : integer := 1;
                extclk0_phase_shift         : string := "0";
                extclk0_time_delay          : string := "0";
                extclk0_duty_cycle          : integer := 50;

                extclk1_multiply_by         : integer := 1;
                extclk1_divide_by           : integer := 1;
                extclk1_phase_shift         : string := "0";
                extclk1_time_delay          : string := "0";
                extclk1_duty_cycle          : integer := 50;

                extclk2_multiply_by         : integer := 1;
                extclk2_divide_by           : integer := 1;
                extclk2_phase_shift         : string := "0";
                extclk2_time_delay          : string := "0";
                extclk2_duty_cycle          : integer := 50;

                extclk3_multiply_by         : integer := 1;
                extclk3_divide_by           : integer := 1;
                extclk3_phase_shift         : string := "0";
                extclk3_time_delay          : string := "0";
                extclk3_duty_cycle          : integer := 50;

                primary_clock               : string := "inclk0";
                inclk0_input_frequency      : integer := 10000;
                inclk1_input_frequency      : integer := 10000;
                gate_lock_signal            : string := "no";
                gate_lock_counter           : integer := 1;
                valid_lock_multiplier       : integer := 5;
                invalid_lock_multiplier     : integer := 5;

                switch_over_on_lossclk      : string := "off";
                switch_over_on_gated_lock   : string := "off";
                switch_over_counter         : integer := 1;
                enable_switch_over_counter  : string := "off";
                feedback_source             : string := "extclk0";
                bandwidth_type              : string := "auto";
                bandwidth                   : integer := 0;
                spread_frequency            : integer := 0;
                down_spread                 : string := "0.0";

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

                l0_high                     : integer := 1;
                l0_low                      : integer := 1;
                l0_initial                  : integer := 1; 
                l0_mode                     : string := "bypass";
                l0_ph                       : integer := 0;
                l0_time_delay               : integer := 0;

                l1_high                     : integer := 1;
                l1_low                      : integer := 1;
                l1_initial                  : integer := 1;
                l1_mode                     : string := "bypass";
                l1_ph                       : integer := 0;
                l1_time_delay               : integer := 0;

                g0_high                     : integer := 1;
                g0_low                      : integer := 1;
                g0_initial                  : integer := 1;
                g0_mode                     : string := "bypass";
                g0_ph                       : integer := 0;
                g0_time_delay               : integer := 0;

                g1_high                     : integer := 1;
                g1_low                      : integer := 1;
                g1_initial                  : integer := 1;
                g1_mode                     : string := "bypass";
                g1_ph                       : integer := 0;
                g1_time_delay               : integer := 0;

                g2_high                     : integer := 1;
                g2_low                      : integer := 1;
                g2_initial                  : integer := 1;
                g2_mode                     : string := "bypass";
                g2_ph                       : integer := 0;
                g2_time_delay               : integer := 0;

                g3_high                     : integer := 1;
                g3_low                      : integer := 1;
                g3_initial                  : integer := 1;
                g3_mode                     : string := "bypass";
                g3_ph                       : integer := 0;
                g3_time_delay               : integer := 0;

                e0_high                     : integer := 1;
                e0_low                      : integer := 1;
                e0_initial                  : integer := 1;
                e0_mode                     : string := "bypass";
                e0_ph                       : integer := 0;
                e0_time_delay               : integer := 0;

                e1_high                     : integer := 1;
                e1_low                      : integer := 1;
                e1_initial                  : integer := 1;
                e1_mode                     : string := "bypass";
                e1_ph                       : integer := 0;
                e1_time_delay               : integer := 0;

                e2_high                     : integer := 1;
                e2_low                      : integer := 1;
                e2_initial                  : integer := 1;
                e2_mode                     : string := "bypass";
                e2_ph                       : integer := 0;
                e2_time_delay               : integer := 0;

                e3_high                     : integer := 1;
                e3_low                      : integer := 1;
                e3_initial                  : integer := 1;
                e3_mode                     : string := "bypass";
                e3_ph                       : integer := 0;
                e3_time_delay               : integer := 0;

                m_ph                        : integer := 0;
                m_time_delay                : integer := 0;
                n_time_delay                : integer := 0;
  
                extclk0_counter             : string := "e0";
                extclk1_counter             : string := "e1";
                extclk2_counter             : string := "e2";
                extclk3_counter             : string := "e3";

                clk0_counter                : string := "g0";
                clk1_counter                : string := "g1";
                clk2_counter                : string := "g2";
                clk3_counter                : string := "g3";
                clk4_counter                : string := "l0";
                clk5_counter                : string := "l1";

                -- LVDS mode parameters
                enable0_counter             : string := "l0";
                enable1_counter             : string := "l0";
  
                charge_pump_current         : integer := 0;
                loop_filter_r               : string := "1.0";
                loop_filter_c               : integer := 1;
                common_rx_tx                : string := "off";
                rx_outclock_resource        : string := "auto";
                use_vco_bypass              : string := "false";
                use_dc_coupling             : string := "false";

                pll_compensation_delay      : integer := 0;
                simulation_type             : string := "timing";
                source_is_pll               : string := "off";

                clk0_use_even_counter_mode  : string := "off";
                clk1_use_even_counter_mode  : string := "off";
                clk2_use_even_counter_mode  : string := "off";
                clk3_use_even_counter_mode  : string := "off";
                clk4_use_even_counter_mode  : string := "off";
                clk5_use_even_counter_mode  : string := "off";
                extclk0_use_even_counter_mode  : string := "off";
                extclk1_use_even_counter_mode  : string := "off";
                extclk2_use_even_counter_mode  : string := "off";
                extclk3_use_even_counter_mode  : string := "off";

                clk0_use_even_counter_value : string := "off";
                clk1_use_even_counter_value : string := "off";
                clk2_use_even_counter_value : string := "off";
                clk3_use_even_counter_value : string := "off";
                clk4_use_even_counter_value : string := "off";
                clk5_use_even_counter_value : string := "off";
                extclk0_use_even_counter_value : string := "off";
                extclk1_use_even_counter_value : string := "off";
                extclk2_use_even_counter_value : string := "off";
                extclk3_use_even_counter_value : string := "off";

                -- Simulation only generics
                family_name                 : string  := "Cyclone";

                skip_vco                    : string := "off";
  
              -- VITAL generics
              XOn                         : Boolean := DefGlitchXOn;
              MsgOn                       : Boolean := DefGlitchMsgOn;
              tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
              tipd_clkena                 : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
              tipd_extclkena              : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
              tipd_ena                    : VitalDelayType01 := DefPropDelay01;
              tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
              tipd_areset                 : VitalDelayType01 := DefPropDelay01;
              tipd_fbin                   : VitalDelayType01 := DefPropDelay01;
              tipd_scanclk                : VitalDelayType01 := DefPropDelay01;
              tipd_scanaclr               : VitalDelayType01 := DefPropDelay01;
              tipd_scandata               : VitalDelayType01 := DefPropDelay01;
              tipd_comparator             : VitalDelayType01 := DefPropDelay01;
              tipd_clkswitch              : VitalDelayType01 := DefPropDelay01
            );

    PORT      ( inclk                       : in std_logic_vector(1 downto 0);
                fbin                        : in std_logic := '0';
                ena                         : in std_logic := '1';
                clkswitch                   : in std_logic := '0';
                areset                      : in std_logic := '0';
                pfdena                      : in std_logic := '1';
                clkena                      : in std_logic_vector(5 downto 0) := "111111";
                extclkena                   : in std_logic_vector(3 downto 0) := "1111";
                scanaclr                    : in std_logic := '0';
                scandata                    : in std_logic := '0';
                scanclk                     : in std_logic := '0';
                clk                         : out std_logic_vector(5 downto 0);
                extclk                      : out std_logic_vector(3 downto 0);
                clkbad                      : out std_logic_vector(1 downto 0);
                activeclock                 : out std_logic;
                locked                      : out std_logic;
                clkloss                     : out std_logic;
                scandataout                 : out std_logic;
                -- lvds specific ports
                comparator                  : in std_logic := '0';
                enable0                     : out std_logic;
                enable1                     : out std_logic 
                );
END cyclone_pll;

ARCHITECTURE vital_pll of cyclone_pll is

-- internal advanced parameter signals
signal   i_vco_min      : natural;
signal   i_vco_max      : natural;
signal   i_vco_center   : natural;
signal   i_pfd_min      : natural;
signal   i_pfd_max      : natural;
signal   l0_ph_val      : natural;
signal   l1_ph_val      : natural;
signal   g0_ph_val      : natural;
signal   g1_ph_val      : natural;
signal   g2_ph_val      : natural;
signal   g3_ph_val      : natural;
signal   e0_ph_val      : natural;
signal   e1_ph_val      : natural;
signal   e2_ph_val      : natural;
signal   e3_ph_val      : natural;
signal   i_extclk3_counter      : string(1 to 2) := "e3";
signal   i_extclk2_counter      : string(1 to 2) := "e2";
signal   i_extclk1_counter      : string(1 to 2) := "e1";
signal   i_extclk0_counter      : string(1 to 2) := "e0";
signal   i_clk5_counter         : string(1 to 2) := "l1";
signal   i_clk4_counter         : string(1 to 2) := "l0";
signal   i_clk3_counter         : string(1 to 2) := "g3";
signal   i_clk2_counter         : string(1 to 2) := "g2";
signal   i_clk1_counter         : string(1 to 2) := "g1";
signal   i_clk0_counter         : string(1 to 2) := "g0";
signal   i_charge_pump_current  : natural;
signal   i_loop_filter_r        : natural;

-- end internal advanced parameter signals

-- CONSTANTS
CONSTANT EGPP_SCAN_CHAIN : integer := 289;
CONSTANT GPP_SCAN_CHAIN : integer := 193;
CONSTANT TRST : time := 5000 ps;
CONSTANT TRSTCLK : time := 5000 ps;

-- signals

signal vcc : std_logic := '1';

signal fbclk       : std_logic;
signal refclk      : std_logic;

signal l0_clk : std_logic;
signal l1_clk : std_logic;
signal g0_clk : std_logic;
signal g1_clk : std_logic;
signal g2_clk : std_logic;
signal g3_clk : std_logic;
signal e0_clk : std_logic;
signal e1_clk : std_logic;
signal e2_clk : std_logic;
signal e3_clk : std_logic;

signal vco_out : std_logic_vector(7 downto 0) := (OTHERS => '0');

-- signals to assign values to counter params
signal m_val : integer := 1;
signal m_val_tmp : integer := 1;
signal m2_val : integer := 1;
signal n_val : integer := 1;
signal n_val_tmp : integer := 1;
signal n2_val : integer := 1;
signal m_time_delay_val, n_time_delay_val : integer := 0;
signal m_ph_val : integer := 0;
signal m_initial_val : integer := m_initial;

signal l0_initial_val : integer := l0_initial;
signal l1_initial_val : integer := l1_initial;
signal l0_high_val : integer := l0_high;
signal l1_high_val : integer := l1_high;
signal l0_low_val : integer := l0_low;
signal l1_low_val : integer := l1_low;
signal l0_mode_val : string(1 to 6) := "bypass";
signal l1_mode_val : string(1 to 6) := "bypass";
signal l0_time_delay_val : integer := l0_time_delay;
signal l1_time_delay_val : integer := l1_time_delay;

signal g0_initial_val : integer := g0_initial;
signal g1_initial_val : integer := g1_initial;
signal g2_initial_val : integer := g2_initial;
signal g3_initial_val : integer := g3_initial;
signal g0_high_val : integer := g0_high;
signal g1_high_val : integer := g1_high;
signal g2_high_val : integer := g2_high;
signal g3_high_val : integer := g3_high;
signal g0_mode_val : string(1 to 6) := "bypass";
signal g1_mode_val : string(1 to 6) := "bypass";
signal g2_mode_val : string(1 to 6) := "bypass";
signal g3_mode_val : string(1 to 6) := "bypass";
signal g0_low_val : integer := g0_low;
signal g1_low_val : integer := g1_low;
signal g2_low_val : integer := g2_low;
signal g3_low_val : integer := g3_low;
signal g0_time_delay_val : integer := g0_time_delay;
signal g1_time_delay_val : integer := g1_time_delay;
signal g2_time_delay_val : integer := g2_time_delay;
signal g3_time_delay_val : integer := g3_time_delay;

signal e0_initial_val : integer := e0_initial;
signal e1_initial_val : integer := e1_initial;
signal e2_initial_val : integer := e2_initial;
signal e3_initial_val : integer := e3_initial;
signal e0_high_val : integer := e0_high;
signal e1_high_val : integer := e1_high;
signal e2_high_val : integer := e2_high;
signal e3_high_val : integer := e3_high;
signal e0_low_val : integer := e0_low;
signal e1_low_val : integer := e1_low;
signal e2_low_val : integer := e2_low;
signal e3_low_val : integer := e3_low;
signal e0_time_delay_val : integer := e0_time_delay;
signal e1_time_delay_val : integer := e1_time_delay;
signal e2_time_delay_val : integer := e2_time_delay;
signal e3_time_delay_val : integer := e3_time_delay;
signal e0_mode_val : string(1 to 6) := "bypass";
signal e1_mode_val : string(1 to 6) := "bypass";
signal e2_mode_val : string(1 to 6) := "bypass";
signal e3_mode_val : string(1 to 6) := "bypass";

signal m_mode_val : string(1 to 6) := "      ";
signal m2_mode_val : string(1 to 6) := "      ";
signal n_mode_val : string(1 to 6) := "      ";
signal n2_mode_val : string(1 to 6) := "      ";

signal cntr_e0_initial : integer := 1;
signal cntr_e1_initial : integer := 1;
signal cntr_e2_initial : integer := 1;
signal cntr_e3_initial : integer := 1;
signal ext_fbk_delay : integer := 0;
signal cntr_e0_delay : integer := 0;
signal cntr_e1_delay : integer := 0;
signal cntr_e2_delay : integer := 0;
signal cntr_e3_delay : integer := 0;

signal transfer : std_logic := '0';

signal scan_data : std_logic_vector(288 downto 0) := (OTHERS => '0');
signal ena0 : std_logic;
signal ena1 : std_logic;
signal ena2 : std_logic;
signal ena3 : std_logic;
signal ena4 : std_logic;
signal ena5 : std_logic;
signal extena0 : std_logic;
signal extena1 : std_logic;
signal extena2 : std_logic;
signal extena3 : std_logic;

signal clk0_tmp : std_logic;
signal clk1_tmp : std_logic;
signal clk2_tmp : std_logic;
signal clk3_tmp : std_logic;
signal clk4_tmp : std_logic;
signal clk5_tmp : std_logic;
signal extclk0_tmp : std_logic;
signal extclk1_tmp : std_logic;
signal extclk2_tmp : std_logic;
signal extclk3_tmp : std_logic;

signal not_clk0_tmp : std_logic;
signal not_clk1_tmp : std_logic;
signal not_clk2_tmp : std_logic;
signal not_clk3_tmp : std_logic;
signal not_clk4_tmp : std_logic;
signal not_clk5_tmp : std_logic;

signal not_extclk0_tmp : std_logic;
signal not_extclk1_tmp : std_logic;
signal not_extclk2_tmp : std_logic;
signal not_extclk3_tmp : std_logic;

signal clkin : std_logic := '0';
signal gate_locked : std_logic := '0';
signal lock : std_logic := '0';
signal about_to_lock : boolean := false;
signal quiet_period_violation : boolean := false;
signal reconfig_err : boolean := false;
signal scanclr_violation : boolean := false;
signal scanclr_clk_violation : boolean := false;

signal inclk_l0 : std_logic;
signal inclk_l1 : std_logic;
signal inclk_g0 : std_logic;
signal inclk_g1 : std_logic;
signal inclk_g2 : std_logic;
signal inclk_g3 : std_logic;
signal inclk_e0 : std_logic;
signal inclk_e1 : std_logic;
signal inclk_e2 : std_logic;
signal inclk_e3 : std_logic;
signal inclk_m : std_logic;
signal devpor : std_logic;
signal devclrn : std_logic;

signal inclk0_ipd : std_logic;
signal inclk1_ipd : std_logic;
signal ena_ipd : std_logic;
signal pfdena_ipd : std_logic;
signal comparator_ipd : std_logic;
signal areset_ipd : std_logic;
signal fbin_ipd : std_logic;
signal clkena0_ipd : std_logic;
signal clkena1_ipd : std_logic;
signal clkena2_ipd : std_logic;
signal clkena3_ipd : std_logic;
signal clkena4_ipd : std_logic;
signal clkena5_ipd : std_logic;
signal extclkena0_ipd : std_logic;
signal extclkena1_ipd : std_logic;
signal extclkena2_ipd : std_logic;
signal extclkena3_ipd : std_logic;
signal scanclk_ipd : std_logic;
signal scanaclr_ipd : std_logic;
signal scandata_ipd : std_logic;
signal clkswitch_ipd : std_logic;

signal lvds_dffa_clk : std_logic;
signal lvds_dffb_clk : std_logic;
signal lvds_dffc_clk : std_logic;
signal lvds_dffd_clk : std_logic;
signal dffa_out : std_logic := '0';
signal dffb_out : std_logic := '0';
signal dffc_out : std_logic := '0';
signal dffd_out : std_logic := '0';
signal nce_temp : std_logic := '0';
signal nce_l0 : std_logic := '0';
signal nce_l1 : std_logic := '0';

signal inclk_l0_dly1 : std_logic := '0';
signal inclk_l0_dly2 : std_logic := '0';
signal inclk_l0_dly3 : std_logic := '0';
signal inclk_l0_dly4 : std_logic := '0';
signal inclk_l0_dly5 : std_logic := '0';
signal inclk_l0_dly6 : std_logic := '0';
signal inclk_l1_dly1 : std_logic := '0';
signal inclk_l1_dly2 : std_logic := '0';
signal inclk_l1_dly3 : std_logic := '0';
signal inclk_l1_dly4 : std_logic := '0';
signal inclk_l1_dly5 : std_logic := '0';
signal inclk_l1_dly6 : std_logic := '0';


signal sig_offset : time := 0 ps;
signal sig_refclk_time : time := 0 ps;
signal sig_fbclk_time : time := 0 ps;
signal sig_fbclk_period : time := 0 ps;
signal sig_vco_period_was_phase_adjusted : boolean := false;
signal sig_phase_adjust_was_scheduled : boolean := false;
signal sig_stop_vco : std_logic := '0';
signal sig_m_times_vco_period : time := 0 ps;
signal sig_new_m_times_vco_period : time := 0 ps;
signal sig_got_refclk_posedge : boolean := false;
signal sig_got_fbclk_posedge : boolean := false;
signal sig_got_second_refclk : boolean := false;
signal sig_current_clock : string(1 to 6);

signal m_delay : integer := 0;
signal n_delay : integer := 0;

signal sig_curr_clock : string(1 to 6) := primary_clock;
signal scan_chain_length : integer := GPP_SCAN_CHAIN;

signal ext_fbk_cntr_high : integer := 0;
signal ext_fbk_cntr_low : integer := 0;
signal ext_fbk_cntr_delay : integer := 0;
signal ext_fbk_cntr_ph : integer := 0;
signal ext_fbk_cntr_initial : integer := 1;
signal ext_fbk_cntr     : string(1 to 2) := "e0";
signal ext_fbk_cntr_mode : string(1 to 6) := "bypass";

signal enable0_tmp : std_logic := '0';
signal enable1_tmp : std_logic := '0';
signal reset_low : std_logic := '0';

signal scandataout_tmp : std_logic := '0';
signal sdataout_trig : std_logic := '0';
signal sdataout_rst_trig : std_logic := '0';

signal sig_refclk_period : time := (inclk0_input_frequency * 1 ps) * n;

signal schedule_vco : std_logic := '0';

signal areset_ena_sig : std_logic := '0';
signal done_with_param_calc : boolean := false;

COMPONENT cyclone_m_cntr
    PORT  ( clk           : IN std_logic;
            reset         : IN std_logic;
            cout          : OUT std_logic;
            initial_value : IN integer := 1;
            modulus       : IN integer;
            time_delay    : IN integer;
            ph            : IN integer := 0 );
END COMPONENT;

COMPONENT cyclone_n_cntr
    PORT  ( clk           : IN std_logic;
            reset         : IN std_logic;
            cout          : OUT std_logic;
            modulus       : IN integer;
            time_delay    : IN integer);
END COMPONENT;

COMPONENT cyclone_scale_cntr
    PORT  ( clk            : IN std_logic;
            reset          : IN std_logic;
            cout           : OUT std_logic;
            initial        : IN integer := 1;
            high           : IN integer := 1;
            low            : IN integer := 1;
            mode           : IN string := "bypass";
            time_delay     : IN integer := 0;
            ph_tap         : IN natural );
END COMPONENT;

COMPONENT cyclone_dffe
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

    PORT  ( Q                              :  out   STD_LOGIC := '0';
            D                              :  in    STD_LOGIC := '1';
            CLRN                           :  in    STD_LOGIC := '1';
            PRN                            :  in    STD_LOGIC := '1';
            CLK                            :  in    STD_LOGIC := '0';
            ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

COMPONENT cyclone_pll_reg
    PORT  ( Q                              :  out   STD_LOGIC := '0';
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
        VitalWireDelay (clkena0_ipd, clkena(0), tipd_clkena(0));
        VitalWireDelay (clkena1_ipd, clkena(1), tipd_clkena(1));
        VitalWireDelay (clkena2_ipd, clkena(2), tipd_clkena(2));
        VitalWireDelay (clkena3_ipd, clkena(3), tipd_clkena(3));
        VitalWireDelay (clkena4_ipd, clkena(4), tipd_clkena(4));
        VitalWireDelay (clkena5_ipd, clkena(5), tipd_clkena(5));
        VitalWireDelay (extclkena0_ipd, extclkena(0), tipd_extclkena(0));
        VitalWireDelay (extclkena1_ipd, extclkena(1), tipd_extclkena(1));
        VitalWireDelay (extclkena2_ipd, extclkena(2), tipd_extclkena(2));
        VitalWireDelay (extclkena3_ipd, extclkena(3), tipd_extclkena(3));
        VitalWireDelay (scanclk_ipd, scanclk, tipd_scanclk);
        VitalWireDelay (scanaclr_ipd, scanaclr, tipd_scanaclr);
        VitalWireDelay (scandata_ipd, scandata, tipd_scandata);
        VitalWireDelay (comparator_ipd, comparator, tipd_comparator);
        VitalWireDelay (clkswitch_ipd, clkswitch, tipd_clkswitch);
    end block;

    -- User to Advanced parameter conversion

    i_extclk3_counter       <=  "e3" when m=0 else extclk3_counter;
    i_extclk2_counter       <=  "e2" when m=0 else extclk2_counter;
    i_extclk1_counter       <=  "e1" when m=0 else extclk1_counter;
    i_extclk0_counter       <=  "e0" when m=0 else extclk0_counter;
    i_clk5_counter          <=  "l1" when m=0 else clk5_counter;
    i_clk4_counter          <=  "l0" when m=0 else clk4_counter;
    i_clk3_counter          <=  "g3" when m=0 else clk3_counter;
    i_clk2_counter          <=  "g2" when m=0 else clk2_counter;
    i_clk1_counter          <=  "g1" when m=0 else clk1_counter;
    i_clk0_counter          <=  "l0" when m=0 and pll_type = "lvds" else
                                "g0" when m=0 else clk0_counter;

    -- end parameter conversion

    inclk_m <=  extclk0_tmp when operation_mode = "external_feedback" and feedback_source = "extclk0" else
                extclk1_tmp when operation_mode = "external_feedback" and feedback_source = "extclk1" else
                extclk2_tmp when operation_mode = "external_feedback" and feedback_source = "extclk2" else
                extclk3_tmp when operation_mode = "external_feedback" and feedback_source = "extclk3" else
                vco_out(m_ph_val);

    ext_fbk_cntr <= "e0" when (feedback_source = "extclk0" and extclk0_counter = "e0") or (feedback_source = "extclk1" and extclk1_counter = "e0") or (feedback_source = "extclk2" and extclk2_counter = "e0") or (feedback_source = "extclk3" and extclk3_counter = "e0") else
                    "e1" when (feedback_source = "extclk0" and extclk0_counter = "e1") or (feedback_source = "extclk1" and extclk1_counter = "e1") or (feedback_source = "extclk2" and extclk2_counter = "e1") or (feedback_source = "extclk3" and extclk3_counter = "e1") else
                    "e2" when (feedback_source = "extclk0" and extclk0_counter = "e2") or (feedback_source = "extclk1" and extclk1_counter = "e2") or (feedback_source = "extclk2" and extclk2_counter = "e2") or (feedback_source = "extclk3" and extclk3_counter = "e2") else
                    "e3" when (feedback_source = "extclk0" and extclk0_counter = "e3") or (feedback_source = "extclk1" and extclk1_counter = "e3") or (feedback_source = "extclk2" and extclk2_counter = "e3") or (feedback_source = "extclk3" and extclk3_counter = "e3") else
                    "e0";

    ext_fbk_cntr_high   <=  e0_high_val when ext_fbk_cntr = "e0" else
                            e1_high_val when ext_fbk_cntr = "e1" else
                            e2_high_val when ext_fbk_cntr = "e2" else
                            e3_high_val when ext_fbk_cntr = "e3" else
                            1;
    ext_fbk_cntr_low   <=   e0_low_val when ext_fbk_cntr = "e0" else
                            e1_low_val when ext_fbk_cntr = "e1" else
                            e2_low_val when ext_fbk_cntr = "e2" else
                            e3_low_val when ext_fbk_cntr = "e3" else
                            1;
    ext_fbk_cntr_delay  <=  e0_time_delay_val when ext_fbk_cntr = "e0" else
                            e1_time_delay_val when ext_fbk_cntr = "e1" else
                            e2_time_delay_val when ext_fbk_cntr = "e2" else
                            e3_time_delay_val when ext_fbk_cntr = "e3" else
                            0;

    ext_fbk_cntr_ph    <=   e0_ph_val when ext_fbk_cntr = "e0" else
                            e1_ph_val when ext_fbk_cntr = "e1" else
                            e2_ph_val when ext_fbk_cntr = "e2" else
                            e3_ph_val when ext_fbk_cntr = "e3" else
                            0;

    ext_fbk_cntr_initial <= e0_initial_val when ext_fbk_cntr = "e0" else
                            e1_initial_val when ext_fbk_cntr = "e1" else
                            e2_initial_val when ext_fbk_cntr = "e2" else
                            e3_initial_val when ext_fbk_cntr = "e3" else
                            0;
    ext_fbk_cntr_mode  <=   e0_mode_val when ext_fbk_cntr = "e0" else
                            e1_mode_val when ext_fbk_cntr = "e1" else
                            e2_mode_val when ext_fbk_cntr = "e2" else
                            e3_mode_val when ext_fbk_cntr = "e3" else
                            e0_mode_val;

    areset_ena_sig <= areset_ipd or (not ena_ipd) or sig_stop_vco;

    m1 : cyclone_m_cntr
            port map  ( clk           => inclk_m,
                        reset         => areset_ena_sig,
                        cout          => fbclk,
                        initial_value => m_initial_val,
                        modulus       => m_val,
                        time_delay    => m_delay,
                        ph            => m_ph_val );

    -- add delta delay to inclk1 to ensure inclk0 and inclk1 are processed
    -- in different simulation deltas.

    n1 : cyclone_n_cntr
            port map  ( clk           => clkin,
                        reset         => areset_ipd,
                        cout          => refclk,
                        modulus       => n_val,
                        time_delay    => n_time_delay_val);

    inclk_l0 <= vco_out(l0_ph_val);
    l0 : cyclone_scale_cntr
            port map  ( clk            => inclk_l0,
                        reset          => areset_ena_sig,
                        cout           => l0_clk,
                        initial        => l0_initial_val,
                        high           => l0_high_val,
                        low            => l0_low_val,
                        mode           => l0_mode_val,
                        time_delay     => l0_time_delay_val,
                        ph_tap         => l0_ph_val);

    inclk_l1 <= vco_out(l1_ph_val);
    l1 : cyclone_scale_cntr
            port map  ( clk            => inclk_l1,
                        reset          => areset_ena_sig,
                        cout           => l1_clk,
                        initial        => l1_initial_val,
                        high           => l1_high_val,
                        low            => l1_low_val,
                        mode           => l1_mode_val,
                        time_delay     => l1_time_delay_val,
                        ph_tap         => l1_ph_val);

    inclk_g0 <= vco_out(g0_ph_val);
    g0 : cyclone_scale_cntr
            port map  ( clk            => inclk_g0,
                        reset          => areset_ena_sig,
                        cout           => g0_clk,
                        initial        => g0_initial_val,
                        high           => g0_high_val,
                        low            => g0_low_val,
                        mode           => g0_mode_val,
                        time_delay     => g0_time_delay_val,
                        ph_tap         => g0_ph_val);


    process(g0_clk, l0_clk, l1_clk)
    begin
        if (g0_clk'event and g0_clk = '1') then
            dffa_out <= comparator_ipd;
        end if;
        if (l0_clk'event and l0_clk = '1' and enable0_counter = "l0") then
            dffb_out <= dffa_out;
            dffc_out <= dffb_out;
            dffd_out <= nce_temp;
        end if;
        if (l1_clk'event and l1_clk = '1' and enable0_counter = "l1") then
            dffb_out <= dffa_out;
            dffc_out <= dffb_out;
            dffd_out <= nce_temp;
        end if;
    end process;

    nce_temp <= (not dffc_out) and dffb_out;

    nce_l0 <= dffd_out when enable0_counter = "l0" else '0';
    nce_l1 <= dffd_out when enable0_counter = "l1" else '0';

    inclk_g1 <= vco_out(g1_ph_val);
    g1 : cyclone_scale_cntr
            port map  ( clk            => inclk_g1,
                        reset          => areset_ena_sig,
                        cout           => g1_clk,
                        initial        => g1_initial_val,
                        high           => g1_high_val,
                        low            => g1_low_val,
                        mode           => g1_mode_val,
                        time_delay     => g1_time_delay_val,
                        ph_tap         => g1_ph_val);

    inclk_g2 <= vco_out(g2_ph_val);
    g2 : cyclone_scale_cntr
            port map  ( clk            => inclk_g2,
                        reset          => areset_ena_sig,
                        cout           => g2_clk,
                        initial        => g2_initial_val,
                        high           => g2_high_val,
                        low            => g2_low_val,
                        mode           => g2_mode_val,
                        time_delay     => g2_time_delay_val,
                        ph_tap         => g2_ph_val);

    inclk_g3 <= vco_out(g3_ph_val);
    g3 : cyclone_scale_cntr
            port map  ( clk            => inclk_g3,
                        reset          => areset_ena_sig,
                        cout           => g3_clk,
                        initial        => g3_initial_val,
                        high           => g3_high_val,
                        low            => g3_low_val,
                        mode           => g3_mode_val,
                        time_delay     => g3_time_delay_val,
                        ph_tap         => g3_ph_val);

    inclk_e0 <= vco_out(e0_ph_val);
    cntr_e0_initial <= 1  when  operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e0" else e0_initial_val;
    cntr_e0_delay  <=   ext_fbk_delay when operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e0" else
                        e0_time_delay_val;
    e0 : cyclone_scale_cntr
            port map  ( clk            => inclk_e0,
                        reset          => areset_ena_sig,
                        cout           => e0_clk,
                        initial        => cntr_e0_initial,
                        high           => e0_high_val,
                        low            => e0_low_val,
                        mode           => e0_mode_val,
                        time_delay     => cntr_e0_delay,
                        ph_tap         => e0_ph_val);

    inclk_e1 <= vco_out(e1_ph_val);
    cntr_e1_initial <= 1  when  operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e1" else e1_initial_val;
    cntr_e1_delay  <=   ext_fbk_delay when operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e1" else
                        e1_time_delay_val;
    e1 : cyclone_scale_cntr
            port map  ( clk            => inclk_e1,
                        reset          => areset_ena_sig,
                        cout           => e1_clk,
                        initial        => cntr_e1_initial,
                        high           => e1_high_val,
                        low            => e1_low_val,
                        mode           => e1_mode_val,
                        time_delay     => cntr_e1_delay,
                        ph_tap         => e1_ph_val);

    inclk_e2 <= vco_out(e2_ph_val);
    cntr_e2_initial <= 1  when  operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e2" else e2_initial_val;
    cntr_e2_delay  <=   ext_fbk_delay when operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e2" else
                        e2_time_delay_val;
    e2 : cyclone_scale_cntr
            port map  ( clk            => inclk_e2,
                        reset          => areset_ena_sig,
                        cout           => e2_clk,
                        initial        => cntr_e2_initial,
                        high           => e2_high_val,
                        low            => e2_low_val,
                        mode           => e2_mode_val,
                        time_delay     => cntr_e2_delay,
                        ph_tap         => e2_ph_val);

    inclk_e3 <= vco_out(e3_ph_val);
    cntr_e3_initial <= 1  when  operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e3" else e3_initial_val;
    cntr_e3_delay  <=   ext_fbk_delay when operation_mode = "external_feedback" and
                                ext_fbk_cntr = "e3" else
                        e3_time_delay_val;
    e3 : cyclone_scale_cntr
            port map  ( clk            => inclk_e3,
                        reset          => areset_ena_sig,
                        cout           => e3_clk,
                        initial        => cntr_e3_initial,
                        high           => e3_high_val,
                        low            => e3_low_val,
                        mode           => e3_mode_val,
                        time_delay     => cntr_e3_delay,
                        ph_tap         => e3_ph_val);

    inclk_l0_dly1 <= inclk_l0;
    inclk_l0_dly2 <= inclk_l0_dly1;
    inclk_l0_dly3 <= inclk_l0_dly2;
    inclk_l0_dly4 <= inclk_l0_dly3;
    inclk_l0_dly5 <= inclk_l0_dly4;
    inclk_l0_dly6 <= inclk_l0_dly5;

    inclk_l1_dly1 <= inclk_l1;
    inclk_l1_dly2 <= inclk_l1_dly1;
    inclk_l1_dly3 <= inclk_l1_dly2;
    inclk_l1_dly4 <= inclk_l1_dly3;
    inclk_l1_dly5 <= inclk_l1_dly4;
    inclk_l1_dly6 <= inclk_l1_dly5;

    process(inclk_l0_dly6, inclk_l1_dly6, areset_ipd, ena_ipd, sig_stop_vco)
    variable l0_got_first_rising_edge : boolean := false;
    variable l0_count : integer := 1;
    variable l0_tmp, l1_tmp : std_logic := '0';
    variable l1_got_first_rising_edge : boolean := false;
    variable l1_count : integer := 1;
    begin
        if (areset_ipd = '1' or ena_ipd = '0' or sig_stop_vco = '1') then
            l0_count := 1;
            l1_count := 1;
            l0_got_first_rising_edge := false;
            l1_got_first_rising_edge := false;
        else
            if (nce_l0 = '0') then
                if (not l0_got_first_rising_edge) then
                    if (inclk_l0_dly6'event and inclk_l0_dly6 = '1') then
                        l0_got_first_rising_edge := true;
                    end if;
                elsif (inclk_l0_dly6'event) then
                    l0_count := l0_count + 1;
                    if (l0_count = (l0_high_val + l0_low_val) * 2) then
                        l0_count := 1;
                    end if;
                end if;
            end if;
            if (inclk_l0_dly6'event and inclk_l0_dly6 = '0') then
                if (l0_count = 1) then
                    l0_tmp := '1';
                    l0_got_first_rising_edge := false;
                else
                    l0_tmp := '0';
                end if;
            end if;

            if (nce_l1 = '0') then
                if (not l1_got_first_rising_edge) then
                    if (inclk_l1_dly6'event and inclk_l1_dly6 = '1') then
                        l1_got_first_rising_edge := true;
                    end if;
                elsif (inclk_l1_dly6'event) then
                    l1_count := l1_count + 1;
                    if (l1_count = (l1_high_val + l1_low_val) * 2) then
                        l1_count := 1;
                    end if;
                end if;
            end if;
            if (inclk_l1_dly6'event and inclk_l1_dly6 = '0') then
                if (l1_count = 1) then
                    l1_tmp := '1';
                    l1_got_first_rising_edge := false;
                else
                    l1_tmp := '0';
                end if;
            end if;
        end if;

        if (enable0_counter = "l0") then
            enable0_tmp <= l0_tmp;
        elsif (enable0_counter = "l1") then
            enable0_tmp <= l1_tmp;
        else
            enable0_tmp <= '0';
        end if;

        if (enable1_counter = "l0") then
            enable1_tmp <= l0_tmp;
        elsif (enable1_counter = "l1") then
            enable1_tmp <= l1_tmp;
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
                if (count = gate_lock_counter) then
                    output := '1';
                end if;
            end if;
        end if;
        gate_locked <= output;
    end process;

    locked  <=  gate_locked and lock when gate_lock_signal = "yes" else
                lock;

    process (transfer)
    variable init : boolean := true;
    variable low, high : std_logic_vector(8 downto 0);
    variable delay_chain : std_logic_vector(3 downto 0);
    variable mn_delay_chain : std_logic_vector(0 to 3);
    variable mode : string(1 to 6) := "bypass";
    variable delay_val : integer := 0;
    variable is_error : boolean := false;
    variable buf : line;

    -- user to advanced variables

    variable   i_m_initial    : natural;
    variable   i_m            : integer := 1;
    variable   i_n            : natural := 1;
    variable   i_m2           : natural;
    variable   i_n2           : natural;
    variable   i_ss           : natural;
    variable   i_l0_high      : natural;
    variable   i_l1_high      : natural;
    variable   i_g0_high      : natural;
    variable   i_g1_high      : natural;
    variable   i_g2_high      : natural;
    variable   i_g3_high      : natural;
    variable   i_e0_high      : natural;
    variable   i_e1_high      : natural;
    variable   i_e2_high      : natural;
    variable   i_e3_high      : natural;
    variable   i_l0_low       : natural;
    variable   i_l1_low       : natural;
    variable   i_g0_low       : natural;
    variable   i_g1_low       : natural;
    variable   i_g2_low       : natural;
    variable   i_g3_low       : natural;
    variable   i_e0_low       : natural;
    variable   i_e1_low       : natural;
    variable   i_e2_low       : natural;
    variable   i_e3_low       : natural;
    variable   i_l0_initial   : natural;
    variable   i_l1_initial   : natural;
    variable   i_g0_initial   : natural;
    variable   i_g1_initial   : natural;
    variable   i_g2_initial   : natural;
    variable   i_g3_initial   : natural;
    variable   i_e0_initial   : natural;
    variable   i_e1_initial   : natural;
    variable   i_e2_initial   : natural;
    variable   i_e3_initial   : natural;
    variable   i_l0_mode      : string(1 to 6);
    variable   i_l1_mode      : string(1 to 6);
    variable   i_g0_mode      : string(1 to 6);
    variable   i_g1_mode      : string(1 to 6);
    variable   i_g2_mode      : string(1 to 6);
    variable   i_g3_mode      : string(1 to 6);
    variable   i_e0_mode      : string(1 to 6);
    variable   i_e1_mode      : string(1 to 6);
    variable   i_e2_mode      : string(1 to 6);
    variable   i_e3_mode      : string(1 to 6);
    variable   max_neg_abs    : integer := 0;
    variable   i_l0_time_delay        : natural;
    variable   i_l1_time_delay        : natural;
    variable   i_g0_time_delay        : natural;
    variable   i_g1_time_delay        : natural;
    variable   i_g2_time_delay        : natural;
    variable   i_g3_time_delay        : natural;
    variable   i_e0_time_delay        : natural;
    variable   i_e1_time_delay        : natural;
    variable   i_e2_time_delay        : natural;
    variable   i_e3_time_delay        : natural;
    variable   i_m_time_delay         : natural;
    variable   i_n_time_delay         : natural;
    variable   i_l0_ph        : natural;
    variable   i_l1_ph        : natural;
    variable   i_g0_ph        : natural;
    variable   i_g1_ph        : natural;
    variable   i_g2_ph        : natural;
    variable   i_g3_ph        : natural;
    variable   i_e0_ph        : natural;
    variable   i_e1_ph        : natural;
    variable   i_e2_ph        : natural;
    variable   i_e3_ph        : natural;
    variable   i_m_ph         : natural;
    variable   output_count   : natural;
    variable   new_divisor    : natural;
    
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
    variable i_extclk0_mult_by : integer := 1;
    variable i_extclk0_div_by  : integer := 1;
    variable i_extclk1_mult_by : integer := 1;
    variable i_extclk1_div_by  : integer := 1;
    variable i_extclk2_mult_by : integer := 1;
    variable i_extclk2_div_by  : integer := 1;
    variable i_extclk3_mult_by : integer := 1;
    variable i_extclk3_div_by  : integer := 1;
    variable max_d_value       : integer := 1;
    variable new_multiplier    : integer := 1;
    
    -- internal variables for storing the phase shift number.(used in lvds mode only)
    variable i_clk0_phase_shift : integer := 1;
    variable i_clk1_phase_shift : integer := 1;
    variable i_clk2_phase_shift : integer := 1;

    begin
        if (init) then
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
                find_simple_integer_fraction(extclk0_multiply_by, extclk0_divide_by,
                                max_d_value, i_extclk0_mult_by, i_extclk0_div_by);
                find_simple_integer_fraction(extclk1_multiply_by, extclk1_divide_by,
                                max_d_value, i_extclk1_mult_by, i_extclk1_div_by);
                find_simple_integer_fraction(extclk2_multiply_by, extclk2_divide_by,
                                max_d_value, i_extclk2_mult_by, i_extclk2_div_by);
                find_simple_integer_fraction(extclk3_multiply_by, extclk3_divide_by,
                                max_d_value, i_extclk3_mult_by, i_extclk3_div_by);
                
                i_n := 1;
                if (pll_type = "lvds") then
                    i_m := clk0_multiply_by;
                else
                    i_m := lcm (i_clk0_mult_by, i_clk1_mult_by,
                            i_clk2_mult_by, i_clk3_mult_by,
                            i_clk4_mult_by, i_clk5_mult_by,
                            i_extclk0_mult_by,
                            i_extclk1_mult_by, i_extclk2_mult_by,
                            i_extclk3_mult_by, inclk0_input_frequency);
                end if;
                i_m_time_delay  :=  maxnegabs ( str2int(clk0_time_delay), 
                                                str2int(clk1_time_delay),
                                                str2int(clk2_time_delay), 
                                                str2int(clk3_time_delay), 
                                                str2int(clk4_time_delay),
                                                str2int(clk5_time_delay), 
                                                str2int(extclk0_time_delay),
                                                str2int(extclk1_time_delay), 
                                                str2int(extclk2_time_delay),
                                                str2int(extclk3_time_delay)); 
                i_n_time_delay  := mintimedelay(str2int(clk0_time_delay), 
                                                str2int(clk1_time_delay),
                                                str2int(clk2_time_delay), 
                                                str2int(clk3_time_delay), 
                                                str2int(clk4_time_delay),
                                                str2int(clk5_time_delay), 
                                                str2int(extclk0_time_delay),
                                                str2int(extclk1_time_delay), 
                                                str2int(extclk2_time_delay),
                                                str2int(extclk3_time_delay)); 
                if (pll_type = "lvds") then
                    i_g0_time_delay := counter_time_delay ( str2int(clk2_time_delay), 
                                                            i_m_time_delay, i_n_time_delay);
                else
                    i_g0_time_delay := counter_time_delay ( str2int(clk0_time_delay),
                                                            i_m_time_delay,i_n_time_delay);
                end if;
                i_g1_time_delay := counter_time_delay ( str2int(clk1_time_delay),
                                                        i_m_time_delay, i_n_time_delay);
                i_g2_time_delay := counter_time_delay ( str2int(clk2_time_delay), 
                                                        i_m_time_delay, i_n_time_delay);
                i_g3_time_delay := counter_time_delay ( str2int(clk3_time_delay), 
                                                        i_m_time_delay, i_n_time_delay);
                if (pll_type = "lvds") then
                    i_l0_time_delay := i_g0_time_delay;
                    i_l1_time_delay := i_g0_time_delay;
                else
                    i_l0_time_delay := counter_time_delay ( str2int(clk4_time_delay),
                                                            i_m_time_delay, i_n_time_delay);
                    i_l1_time_delay := counter_time_delay ( str2int(clk5_time_delay),
                                                            i_m_time_delay, i_n_time_delay);
                end if;
                i_e0_time_delay := counter_time_delay ( str2int(extclk0_time_delay), 
                                                        i_m_time_delay, i_n_time_delay);
                i_e1_time_delay := counter_time_delay ( str2int(extclk1_time_delay), 
                                                        i_m_time_delay, i_n_time_delay);
                i_e2_time_delay := counter_time_delay ( str2int(extclk2_time_delay), 
                                                        i_m_time_delay, i_n_time_delay);
                i_e3_time_delay := counter_time_delay ( str2int(extclk3_time_delay), 
                                                        i_m_time_delay, i_n_time_delay);
                                                        
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
            
                max_neg_abs :=  maxnegabs ( i_clk0_phase_shift, 
                                            i_clk1_phase_shift,
                                            i_clk2_phase_shift,
                                            str2int(clk3_phase_shift),
                                            str2int(clk4_phase_shift),
                                            str2int(clk5_phase_shift),
                                            str2int(extclk0_phase_shift),
                                            str2int(extclk1_phase_shift),
                                            str2int(extclk2_phase_shift),
                                            str2int(extclk3_phase_shift));
                i_m_ph  := counter_ph(get_phase_degree(max_neg_abs,inclk0_input_frequency), i_m, i_n);
                if (pll_type = "lvds") then
                    i_g0_ph := counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs),inclk0_input_frequency), i_m, i_n);
                else
                    i_g0_ph := counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs),inclk0_input_frequency), i_m, i_n);
                end if;
                
                i_g1_ph := counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_g2_ph := counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_g3_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);

                if (pll_type = "lvds") then
                    i_l0_ph := i_g0_ph;
                    i_l1_ph := i_g0_ph;
                else
                    i_l0_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                    i_l1_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                end if;
                i_e0_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e1_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e2_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e3_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                if (pll_type = "lvds") then
                    i_g0_high := counter_high ( output_counter_value(i_clk2_div_by,
                                                i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
                else
                    i_g0_high := counter_high ( output_counter_value(i_clk0_div_by,
                                                i_clk0_mult_by, i_m, i_n), clk0_duty_cycle);
                end if;
                i_g1_high := counter_high ( output_counter_value(i_clk1_div_by,
                                            i_clk1_mult_by, i_m, i_n), clk1_duty_cycle);
                i_g2_high := counter_high ( output_counter_value(i_clk2_div_by,
                                            i_clk2_mult_by, i_m, i_n), clk2_duty_cycle);
                i_g3_high := counter_high ( output_counter_value(i_clk3_div_by,
                                            i_clk3_mult_by, i_m, i_n), clk3_duty_cycle);
                if (pll_type = "lvds") then
                    i_l0_high := i_g0_high;
                    i_l1_high := i_g0_high;
                else
                    i_l0_high := counter_high ( output_counter_value(i_clk4_div_by,
                                                i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                    i_l1_high := counter_high ( output_counter_value(i_clk5_div_by,
                                                i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
                end if;
                i_e0_high := counter_high ( output_counter_value(i_extclk0_div_by,
                                            i_extclk0_mult_by,  i_m, i_n), extclk0_duty_cycle);
                i_e1_high := counter_high ( output_counter_value(i_extclk1_div_by,
                                            i_extclk1_mult_by,  i_m, i_n), extclk1_duty_cycle);
                i_e2_high := counter_high ( output_counter_value(i_extclk2_div_by,
                                            i_extclk2_mult_by,  i_m, i_n), extclk2_duty_cycle);
                i_e3_high := counter_high ( output_counter_value(i_extclk3_div_by,
                                            i_extclk3_mult_by,  i_m, i_n), extclk3_duty_cycle);
                if (pll_type = "lvds") then
                    i_g0_low  :=  counter_low ( output_counter_value(i_clk2_div_by,
                                                i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
                else
                    i_g0_low  :=  counter_low ( output_counter_value(i_clk0_div_by,
                                                i_clk0_mult_by,  i_m, i_n), clk0_duty_cycle);
                end if;
                i_g1_low  :=  counter_low ( output_counter_value(i_clk1_div_by,
                                            i_clk1_mult_by,  i_m, i_n), clk1_duty_cycle);
                i_g2_low  :=  counter_low ( output_counter_value(i_clk2_div_by,
                                            i_clk2_mult_by,  i_m, i_n), clk2_duty_cycle);
                i_g3_low  :=  counter_low ( output_counter_value(i_clk3_div_by,
                                            i_clk3_mult_by,  i_m, i_n), clk3_duty_cycle);
                if (pll_type = "lvds") then
                    i_l0_low  := i_g0_low;
                    i_l1_low  := i_g0_low;
                else
                    i_l0_low  :=  counter_low ( output_counter_value(i_clk4_div_by,
                                                i_clk4_mult_by,  i_m, i_n), clk4_duty_cycle);
                    i_l1_low  :=  counter_low ( output_counter_value(i_clk5_div_by,
                                                i_clk5_mult_by,  i_m, i_n), clk5_duty_cycle);
                end if;
                i_e0_low  :=  counter_low ( output_counter_value(i_extclk0_div_by,
                                            i_extclk0_mult_by,  i_m, i_n), extclk0_duty_cycle);
                i_e1_low  :=  counter_low ( output_counter_value(i_extclk1_div_by,
                                            i_extclk1_mult_by,  i_m, i_n), extclk1_duty_cycle);
                i_e2_low  :=  counter_low ( output_counter_value(i_extclk2_div_by,
                                            i_extclk2_mult_by,  i_m, i_n), extclk2_duty_cycle);
                i_e3_low  :=  counter_low ( output_counter_value(i_extclk3_div_by,
                                            i_extclk3_mult_by,  i_m, i_n), extclk3_duty_cycle);
                i_m_initial  := counter_initial(get_phase_degree(max_neg_abs, inclk0_input_frequency), i_m,i_n);
                if (pll_type = "lvds") then
                    i_g0_initial := counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                else
                    i_g0_initial := counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                end if;
                
                i_g1_initial := counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_g2_initial := counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_g3_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                if (pll_type = "lvds") then
                    i_l0_initial := i_g0_initial;
                    i_l1_initial := i_g0_initial;
                else
                    i_l0_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                    i_l1_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                end if;
                i_e0_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e1_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e2_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e3_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                if (pll_type = "lvds") then
                    i_g0_mode := counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
                else
                    i_g0_mode := counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
                end if;
                i_g1_mode := counter_mode(clk1_duty_cycle, output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
                i_g2_mode := counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
                i_g3_mode := counter_mode(clk3_duty_cycle, output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
                if (pll_type = "lvds") then
                    i_l0_mode := "bypass";
                    i_l1_mode := "bypass";
                else
                    i_l0_mode := counter_mode(clk4_duty_cycle, output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));
                    i_l1_mode := counter_mode(clk5_duty_cycle, output_counter_value(i_clk5_div_by, i_clk5_mult_by,  i_m, i_n));
                end if;
                i_e0_mode := counter_mode(extclk0_duty_cycle, output_counter_value(i_extclk0_div_by, i_extclk0_mult_by,  i_m, i_n));
                i_e1_mode := counter_mode(extclk1_duty_cycle, output_counter_value(i_extclk1_div_by, i_extclk1_mult_by,  i_m, i_n));
                i_e2_mode := counter_mode(extclk2_duty_cycle, output_counter_value(i_extclk2_div_by, i_extclk2_mult_by,  i_m, i_n));
                i_e3_mode := counter_mode(extclk3_duty_cycle, output_counter_value(i_extclk3_div_by, i_extclk3_mult_by,  i_m, i_n));

                -- in external feedback mode, need to adjust M value to take
                -- into consideration the external feedback counter value
                if(operation_mode = "external_feedback") then
                    -- if there is a negative phase shift, m_initial can
                    -- only be 1
                    if (max_neg_abs > 0) then
                        i_m_initial := 1;
                    end if;

                    -- calculate the feedback counter multiplier
                    if (feedback_source = "extclk0") then
                        if (i_e0_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e0_high + i_e0_low;
                        end if;
                    elsif (feedback_source = "extclk1") then
                        if (i_e1_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e1_high + i_e1_low;
                        end if;
                    elsif (feedback_source = "extclk2") then
                        if (i_e2_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e2_high + i_e2_low;
                        end if;
                    elsif (feedback_source = "extclk3") then
                        if (i_e3_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e3_high + i_e3_low;
                        end if;
                    else -- default to e0
                        if (i_e0_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e0_high + i_e0_low;
                        end if;
                    end if;

                    new_divisor := gcd(i_m, output_count);
                    i_m := i_m / new_divisor;
                    i_n := output_count / new_divisor;
                end if;
 
            else -- m /= 0

                i_n             := n;
                i_m             := m;
                i_m_initial     := m_initial;
                i_m_time_delay  := m_time_delay;
                i_n_time_delay  := n_time_delay;
                i_l0_time_delay := l0_time_delay;
                i_l1_time_delay := l1_time_delay;
                i_g0_time_delay := g0_time_delay;
                i_g1_time_delay := g1_time_delay;
                i_g2_time_delay := g2_time_delay;
                i_g3_time_delay := g3_time_delay;
                i_e0_time_delay := e0_time_delay;
                i_e1_time_delay := e1_time_delay;
                i_e2_time_delay := e2_time_delay;
                i_e3_time_delay := e3_time_delay;
                i_m_ph          := m_ph;
                i_l0_ph         := l0_ph;
                i_l1_ph         := l1_ph;
                i_g0_ph         := g0_ph;
                i_g1_ph         := g1_ph;
                i_g2_ph         := g2_ph;
                i_g3_ph         := g3_ph;
                i_e0_ph         := e0_ph;
                i_e1_ph         := e1_ph;
                i_e2_ph         := e2_ph;
                i_e3_ph         := e3_ph;
                i_l0_high       := l0_high;
                i_l1_high       := l1_high;
                i_g0_high       := g0_high;
                i_g1_high       := g1_high;
                i_g2_high       := g2_high;
                i_g3_high       := g3_high;
                i_e0_high       := e0_high;
                i_e1_high       := e1_high;
                i_e2_high       := e2_high;
                i_e3_high       := e3_high;
                i_l0_low        := l0_low;
                i_l1_low        := l1_low;
                i_g0_low        := g0_low;
                i_g1_low        := g1_low;
                i_g2_low        := g2_low;
                i_g3_low        := g3_low;
                i_e0_low        := e0_low;
                i_e1_low        := e1_low;
                i_e2_low        := e2_low;
                i_e3_low        := e3_low;
                i_l0_initial    := l0_initial;
                i_l1_initial    := l1_initial;
                i_g0_initial    := g0_initial;
                i_g1_initial    := g1_initial;
                i_g2_initial    := g2_initial;
                i_g3_initial    := g3_initial;
                i_e0_initial    := e0_initial;
                i_e1_initial    := e1_initial;
                i_e2_initial    := e2_initial;
                i_e3_initial    := e3_initial;
                i_l0_mode       := translate_string(l0_mode);
                i_l1_mode       := translate_string(l1_mode);
                i_g0_mode       := translate_string(g0_mode);
                i_g1_mode       := translate_string(g1_mode);
                i_g2_mode       := translate_string(g2_mode);
                i_g3_mode       := translate_string(g3_mode);
                i_e0_mode       := translate_string(e0_mode);
                i_e1_mode       := translate_string(e1_mode);
                i_e2_mode       := translate_string(e2_mode);
                i_e3_mode       := translate_string(e3_mode);

            end if; -- user to advanced conversion.

            m_initial_val <= i_m_initial;
            n_val_tmp <= i_n;
            m_val_tmp <= i_m;

            if (i_m = 1) then
                m_mode_val <= "bypass";
            end if;
            if (i_n = 1) then
                n_mode_val <= "bypass";
            end if;

            -- NOTE: m_time_delay (vco time delay) not supported for external
            --       feedback mode
            --       in feedback mode, m_time_delay = delay of feedback loop tap

            m_time_delay_val <= i_m_time_delay; 
            n_time_delay_val <= i_n_time_delay;

            m_ph_val  <= i_m_ph;

            m2_val <= m2;
            n2_val <= n2;
            if (m2 = 1) then
                m2_mode_val <= "bypass";
            end if;
            if (n2 = 1) then
                n2_mode_val <= "bypass";
            end if;

            if (skip_vco = "on") then
                m_val_tmp <= 1;
                m_initial_val <= 1;
                m_time_delay_val <= 0;
                m_ph_val <= 0;
            end if;

            l0_ph_val <= i_l0_ph;
            l1_ph_val <= i_l1_ph;
            g0_ph_val <= i_g0_ph;
            g1_ph_val <= i_g1_ph;
            g2_ph_val <= i_g2_ph;
            g3_ph_val <= i_g3_ph;
            e0_ph_val <= i_e0_ph;
            e1_ph_val <= i_e1_ph;
            e2_ph_val <= i_e2_ph;
            e3_ph_val <= i_e3_ph;

            l0_initial_val    <= i_l0_initial;
            l0_high_val       <= i_l0_high;
            l0_low_val        <= i_l0_low;
            l0_mode_val       <= i_l0_mode;
            l0_time_delay_val <= i_l0_time_delay;

            l1_initial_val    <= i_l1_initial;
            l1_high_val       <= i_l1_high;
            l1_low_val        <= i_l1_low;
            l1_mode_val       <= i_l1_mode;
            l1_time_delay_val <= i_l1_time_delay;

            g0_initial_val    <= i_g0_initial;
            g0_high_val       <= i_g0_high;
            g0_low_val        <= i_g0_low;
            g0_mode_val       <= i_g0_mode;
            g0_time_delay_val <= i_g0_time_delay;

            g1_initial_val    <= i_g1_initial;
            g1_high_val       <= i_g1_high;
            g1_low_val        <= i_g1_low;
            g1_mode_val       <= i_g1_mode;
            g1_time_delay_val <= i_g1_time_delay;

            g2_initial_val    <= i_g2_initial;
            g2_high_val       <= i_g2_high;
            g2_low_val        <= i_g2_low;
            g2_mode_val       <= i_g2_mode;
            g2_time_delay_val <= i_g2_time_delay;

            g3_initial_val    <= i_g3_initial;
            g3_high_val       <= i_g3_high;
            g3_low_val        <= i_g3_low;
            g3_mode_val       <= i_g3_mode;
            g3_time_delay_val <= i_g3_time_delay;

            if (scan_chain = "long") then
                e0_initial_val    <= i_e0_initial;
                e0_high_val       <= i_e0_high;
                e0_low_val        <= i_e0_low;
                e0_mode_val       <= i_e0_mode;
                e0_time_delay_val <= i_e0_time_delay;

                e1_initial_val    <= i_e1_initial;
                e1_high_val       <= i_e1_high;
                e1_low_val        <= i_e1_low;
                e1_mode_val       <= i_e1_mode;
                e1_time_delay_val <= i_e1_time_delay;

                e2_initial_val    <= i_e2_initial;
                e2_high_val       <= i_e2_high;
                e2_low_val        <= i_e2_low;
                e2_mode_val       <= i_e2_mode;
                e2_time_delay_val <= i_e2_time_delay;

                e3_initial_val    <= i_e3_initial;
                e3_high_val       <= i_e3_high;
                e3_low_val        <= i_e3_low;
                e3_mode_val       <= i_e3_mode;
                e3_time_delay_val <= i_e3_time_delay;

                scan_chain_length <= EGPP_SCAN_CHAIN;
            end if;
            init := false;
            done_with_param_calc <= true;
        elsif (transfer'event and transfer = '1') then
            reconfig_err <= false;
            ASSERT false REPORT "Reconfiguring PLL" severity note;
            if (scan_chain = "long") then
                -- cntr e3
                delay_chain := scan_data(287 downto 284);
                if (scan_data(273) = '1') then
                    e3_mode_val <= "bypass";
                    if (scan_data(283) = '1') then
                        e3_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E3 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(283) = '1') then
                    e3_mode_val <= "   odd";
                else 
                    e3_mode_val <= "  even";
                end if;
                high := scan_data(272 downto 264);
                low := scan_data(282 downto 274);
                e3_low_val <= alt_conv_integer(low);
                e3_high_val <= alt_conv_integer(high);
                -- count value of 0 is actually 512
                if (alt_conv_integer(high) = 0) then
                    e3_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e3_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                end if;
                e3_time_delay_val <= delay_val;
  
                -- cntr e2
                delay_chain := scan_data(263 downto 260);
                if (scan_data(249) = '1') then
                    e2_mode_val <= "bypass";
                    if (scan_data(259) = '1') then
                        e2_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E2 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(259) = '1') then
                    e2_mode_val <= "   odd";
                else 
                    e2_mode_val <= "  even";
                end if;
                high := scan_data(248 downto 240);
                low := scan_data(258 downto 250);
                e2_low_val <= alt_conv_integer(low);
                e2_high_val <= alt_conv_integer(high);
                if (alt_conv_integer(high) = 0) then
                    e2_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e2_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                end if;
                e2_time_delay_val <= delay_val;

                -- cntr e1
                delay_chain := scan_data(239 downto 236);
                if (scan_data(225) = '1') then
                    e1_mode_val <= "bypass";
                    if (scan_data(235) = '1') then
                        e1_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E1 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(235) = '1') then
                    e1_mode_val <= "   odd";
                else 
                    e1_mode_val <= "  even";
                end if;
                high := scan_data(224 downto 216);
                low := scan_data(234 downto 226);
                e1_low_val <= alt_conv_integer(low);
                e1_high_val <= alt_conv_integer(high);
                if (alt_conv_integer(high) = 0) then
                    e1_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e1_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                end if;
                e1_time_delay_val <= delay_val;

                -- cntr e0
                delay_chain := scan_data(215 downto 212);
                if (scan_data(201) = '1') then
                    e0_mode_val <= "bypass";
                    if (scan_data(211) = '1') then
                        e0_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E0 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(211) = '1') then
                    e0_mode_val <= "   odd";
                else 
                    e0_mode_val <= "  even";
                end if;
                high := scan_data(200 downto 192);
                low := scan_data(210 downto 202);
                e0_low_val <= alt_conv_integer(low);
                e0_high_val <= alt_conv_integer(high);
                if (alt_conv_integer(high) = 0) then
                    e0_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e0_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                end if;
                e0_time_delay_val <= delay_val;
 
            end if;
            -- cntr l1
            delay_chain := scan_data(191 downto 188);
            if (scan_data(177) = '1') then
                l1_mode_val <= "bypass";
                if (scan_data(187) = '1') then
                    l1_mode_val <= "   off";
                    ASSERT false REPORT "The specified bit settings will turn OFF the L1 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                end if;
            elsif (scan_data(187) = '1') then
                l1_mode_val <= "   odd";
            else 
                l1_mode_val <= "  even";
            end if;
            high := scan_data(176 downto 168);
            low := scan_data(186 downto 178);
            l1_low_val <= alt_conv_integer(low);
            l1_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                l1_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                l1_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            l1_time_delay_val <= delay_val;

            -- cntr l0
            delay_chain := scan_data(167 downto 164);
            if (scan_data(153) = '1') then
                l0_mode_val <= "bypass";
                if (scan_data(163) = '1') then
                    l0_mode_val <= "   off";
                    ASSERT false REPORT "The specified bit settings will turn OFF the L0 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                end if;
            elsif (scan_data(163) = '1') then
                l0_mode_val <= "   odd";
            else 
                l0_mode_val <= "  even";
            end if;
            high := scan_data(152 downto 144);
            low := scan_data(162 downto 154);
            l0_low_val <= alt_conv_integer(low);
            l0_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                l0_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                l0_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            l0_time_delay_val <= delay_val;

            -- cntr g3
            delay_chain := scan_data(143 downto 140);
            if (scan_data(129) = '1') then
                g3_mode_val <= "bypass";
                if (scan_data(139) = '1') then
                    g3_mode_val <= "   off";
                    ASSERT false REPORT "The specified bit settings will turn OFF the G3 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                end if;
            elsif (scan_data(139) = '1') then
                g3_mode_val <= "   odd";
            else 
                g3_mode_val <= "  even";
            end if;
            high := scan_data(128 downto 120);
            low := scan_data(138 downto 130);
            g3_low_val <= alt_conv_integer(low);
            g3_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g3_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g3_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            g3_time_delay_val <= delay_val;

            -- cntr g2
            delay_chain := scan_data(119 downto 116);
            if (scan_data(105) = '1') then
                g2_mode_val <= "bypass";
                if (scan_data(115) = '1') then
                    g2_mode_val <= "   off";
                    ASSERT false REPORT "The specified bit settings will turn OFF the G2 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                end if;
            elsif (scan_data(115) = '1') then
                g2_mode_val <= "   odd";
            else 
                g2_mode_val <= "  even";
            end if;
            high := scan_data(104 downto 96);
            low := scan_data(114 downto 106);
            g2_low_val <= alt_conv_integer(low);
            g2_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g2_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g2_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            g2_time_delay_val <= delay_val;

            -- cntr g1
            delay_chain := scan_data(95 downto 92);
            if (scan_data(81) = '1') then
                g1_mode_val <= "bypass";
                if (scan_data(91) = '1') then
                    g1_mode_val <= "   off";
                    ASSERT false REPORT "The specified bit settings will turn OFF the G1 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                end if;
            elsif (scan_data(91) = '1') then
                g1_mode_val <= "   odd";
            else 
                g1_mode_val <= "  even";
            end if;
            high := scan_data(80 downto 72);
            low := scan_data(90 downto 82);
            g1_low_val <= alt_conv_integer(low);
            g1_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g1_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g1_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            g1_time_delay_val <= delay_val;

            -- cntr g0
            delay_chain := scan_data(71 downto 68);
            if (scan_data(57) = '1') then
                g0_mode_val <= "bypass";
                if (scan_data(67) = '1') then
                    g0_mode_val <= "   off";
                    ASSERT false REPORT "The specified bit settings will turn OFF the G0 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                end if;
            elsif (scan_data(67) = '1') then
                g0_mode_val <= "   odd";
            else 
                g0_mode_val <= "  even";
            end if;
            high := scan_data(56 downto 48);
            low := scan_data(66 downto 58);
            g0_low_val <= alt_conv_integer(low);
            g0_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g0_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g0_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            g0_time_delay_val <= delay_val;

            -- cntr M
            is_error := false;
            -- 'low' contains modulus for m_cntr(spread_spectrum disabled)
            low := scan_data(32 downto 24);
            m_val_tmp <= alt_conv_integer(low);
            if (scan_data(33) /= '1') then
                if (alt_conv_integer(low) = 1) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal 1 value for M counter. Instead, M counter should be BYPASSED. Reconfiguration may not work." severity warning;
                elsif (alt_conv_integer(low) = 0) then
                    m_val_tmp <= 512;
                end if;
                if (not is_error) then
                    if (m_mode_val = "bypass") then
                        ASSERT false REPORT "M counter switched from BYPASS mode to enabled (M modulus = " &int2str(alt_conv_integer(low))& "). PLL may lose lock." severity warning;
                    else
                        write (buf, string'("   M modulus = "));
                        write (buf, alt_conv_integer(low));
                        writeline (output, buf);
                    end if;
                    m_mode_val <= "      ";
                end if;
            elsif (scan_data(33) = '1') then
                if (scan_data(24) /= '0') then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal value for M counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                else
                    if (m_mode_val /= "bypass") then
                        ASSERT false REPORT "M counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                    end if;
                    write (buf, string'("   M modulus = "));
                    write (buf, 1);
                    writeline (output, buf);
                    m_val_tmp <= 1;
                    m_mode_val <= "bypass";
                end if;
            end if;

            if (skip_vco = "on") then
                m_val_tmp <= 1;
                ASSERT FALSE REPORT "VCO is bypassed, setting M modulus = 1, M time delay = 0" severity note;
            end if;

            -- cntr M2
            if (ss > 0) then
                is_error := false;
                low := scan_data(42 downto 34);
                m2_val <= alt_conv_integer(low);
                if (scan_data(43) /= '1') then
                    if (alt_conv_integer(low) = 1) then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal 1 value for M2 counter. Instead, M counter should be BYPASSED. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(low) = 0) then
                        m2_val <= 512;
                    end if;
                    if (not is_error) then
                        if (m2_mode_val = "bypass") then
                            ASSERT false REPORT "M2 counter switched from BYPASS mode to enabled (M2 modulus = " &int2str(alt_conv_integer(low))& "). PLL may lose lock." severity warning;
                        else
                            write (buf, string'("   M2 modulus = "));
                            write (buf, alt_conv_integer(low));
                            writeline (output, buf);
                        end if;
                        m2_mode_val <= "      ";
                    end if;
                elsif (scan_data(43) = '1') then
                    if (scan_data(34) /= '0') then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal value for M2 counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                    else
                        if (m2_mode_val /= "bypass") then
                            ASSERT false REPORT "M2 counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                        end if;
                        write (buf, string'("   M2 modulus = "));
                        write (buf, 1);
                        writeline (output, buf);
                        m2_val <= 1;
                        m2_mode_val <= "bypass";
                    end if;
                end if;
                if (m_mode_val /= m2_mode_val) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Incompatible modes for M1/M2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                end if;
            end if;

            delay_chain := scan_data(47 downto 44);
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            m_time_delay_val <= delay_val;
            if (skip_vco = "on") then
                m_time_delay_val <= 0;
                delay_val := 0;
            end if;
            write (buf, string'("   M time delay = "));
            write (buf, delay_val);
            writeline (output, buf);

            -- cntr N
            is_error := false;
            -- 'low' contains modulus for n_cntr(spread_spectrum disabled)
            low := scan_data(8 downto 0);
            n_val_tmp <= alt_conv_integer(low);
            if (scan_data(9) /= '1') then
                if (alt_conv_integer(low) = 1) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal 1 value for N counter. Instead, N counter should be BYPASSED. Reconfiguration may not work." severity warning;
                elsif (alt_conv_integer(low) = 0) then
                    n_val_tmp <= 512;
                    write (buf, string'("   N modulus = "));
                    write (buf, 512);
                    writeline (output, buf);
                else
                    write (buf, string'("   N modulus = "));
                    write (buf, alt_conv_integer(low));
                    writeline (output, buf);
                end if;
                if (not is_error) then
                    if (n_mode_val = "bypass") then
                        ASSERT false REPORT "N Counter switched from BYPASS mode to enabled (N modulus = " &int2str(alt_conv_integer(low))& "). PLL may lose lock." severity warning;
                    else
                        write (buf, string'("   N modulus = "));
                        write (buf, alt_conv_integer(low));
                        writeline (output, buf);
                    end if;
                    n_mode_val <= "      ";
                end if;
            elsif (scan_data(9) = '1') then
                if (scan_data(0) /= '0') then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal value for N counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                else
                    if (n_mode_val /= "bypass") then
                        ASSERT false REPORT "N counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                    end if;
                    write (buf, string'("   N modulus = "));
                    write (buf, 1);
                    writeline (output, buf);
                    n_val_tmp <= 1;
                    n_mode_val <= "bypass";
                end if;
            end if;

            -- cntr N2
            if (ss > 0) then
                is_error := false;
                low := scan_data(18 downto 10);
                n2_val <= alt_conv_integer(low);
                if (scan_data(19) /= '1') then
                    if (alt_conv_integer(low) = 1) then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal 1 value for N2 counter. Instead, N counter should be BYPASSED. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(low) = 0) then
                        n2_val <= 512;
                    end if;
                    if (not is_error) then
                        if (n2_mode_val = "bypass") then
                            ASSERT false REPORT "N2 counter switched from BYPASS mode to enabled (N2 modulus = " &int2str(alt_conv_integer(low))& "). PLL may lose lock." severity warning;
                        else
                            write (buf, string'("   N2 modulus = "));
                            write (buf, alt_conv_integer(low));
                            writeline (output, buf);
                        end if;
                        n2_mode_val <= "      ";
                    end if;
                elsif (scan_data(19) = '1') then
                    if (scan_data(10) /= '0') then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal value for N2 counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                    else
                        if (n2_mode_val /= "bypass") then
                            ASSERT false REPORT "N2 counter switched from enabled to BYPASS mode. PLL may lose lock." severity warning;
                        end if;
                        write (buf, string'("   N2 modulus = "));
                        write (buf, 1);
                        writeline (output, buf);
                        n2_val <= 1;
                        n2_mode_val <= "bypass";
                    end if;
                end if;
                if (n_mode_val /= n2_mode_val) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Incompatible modes for N1/N2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                end if;
            end if;

            delay_chain := scan_data(23 downto 20);
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
                delay_val := 3000;
            end if;
            n_time_delay_val <= delay_val;
            write (buf, string'("   N time delay = "));
            write (buf, delay_val);
            writeline (output, buf);

        else
            if (scan_chain = "long") then
                write (buf, string'("   E3 high = "));
                write (buf, e3_high_val);
                write (buf, string'(" ,  E3 low = "));
                write (buf, e3_low_val);
                write (buf, string'(" ,  E3 mode = "));
                write (buf, e3_mode_val);
                write (buf, string'(" ,  E3 time delay = "));
                write (buf, e3_time_delay_val);
                writeline(output, buf);

                write (buf, string'("   E2 high = "));
                write (buf, e2_high_val);
                write (buf, string'(" ,  E2 low = "));
                write (buf, e2_low_val);
                write (buf, string'(" ,  E2 mode = "));
                write (buf, e2_mode_val);
                write (buf, string'(" ,  E2 time delay = "));
                write (buf, e2_time_delay_val);
                writeline(output, buf);

                write (buf, string'("   E1 high = "));
                write (buf, e1_high_val);
                write (buf, string'(" ,  E1 low = "));
                write (buf, e1_low_val);
                write (buf, string'(" ,  E1 mode = "));
                write (buf, e1_mode_val);
                write (buf, string'(" ,  E1 time delay = "));
                write (buf, e1_time_delay_val);
                writeline(output, buf);

                write (buf, string'("   E0 high = "));
                write (buf, e0_high_val);
                write (buf, string'(" ,  E0 low = "));
                write (buf, e0_low_val);
                write (buf, string'(" ,  E0 mode = "));
                write (buf, e0_mode_val);
                write (buf, string'(" ,  E0 time delay = "));
                write (buf, e0_time_delay_val);
                writeline(output, buf);
            end if;

            write (buf, string'("   L1 high = "));
            write (buf, l1_high_val);
            write (buf, string'(" ,  L1 low = "));
            write (buf, l1_low_val);
            write (buf, string'(" ,  L1 mode = "));
            write (buf, l1_mode_val);
            write (buf, string'(" ,  L1 time delay = "));
            write (buf, l1_time_delay_val);
            writeline(output, buf);

            write (buf, string'("   L0 high = "));
            write (buf, l0_high_val);
            write (buf, string'(" ,  L0 low = "));
            write (buf, l0_low_val);
            write (buf, string'(" ,  L0 mode = "));
            write (buf, l0_mode_val);
            write (buf, string'(" ,  L0 time delay = "));
            write (buf, l0_time_delay_val);
            writeline(output, buf);

            write (buf, string'("   G3 high = "));
            write (buf, g3_high_val);
            write (buf, string'(" ,  G3 low = "));
            write (buf, g3_low_val);
            write (buf, string'(" ,  G3 mode = "));
            write (buf, g3_mode_val);
            write (buf, string'(" ,  G3 time delay = "));
            write (buf, g3_time_delay_val);
            writeline(output, buf);

            write (buf, string'("   G2 high = "));
            write (buf, g2_high_val);
            write (buf, string'(" ,  G2 low = "));
            write (buf, g2_low_val);
            write (buf, string'(" ,  G2 mode = "));
            write (buf, g2_mode_val);
            write (buf, string'(" ,  G2 time delay = "));
            write (buf, g2_time_delay_val);
            writeline(output, buf);

            write (buf, string'("   G1 high = "));
            write (buf, g1_high_val);
            write (buf, string'(" ,  G1 low = "));
            write (buf, g1_low_val);
            write (buf, string'(" ,  G1 mode = "));
            write (buf, g1_mode_val);
            write (buf, string'(" ,  G1 time delay = "));
            write (buf, g1_time_delay_val);
            writeline(output, buf);

            write (buf, string'("   G0 high = "));
            write (buf, g0_high_val);
            write (buf, string'(" ,  G0 low = "));
            write (buf, g0_low_val);
            write (buf, string'(" ,  G0 mode = "));
            write (buf, g0_mode_val);
            write (buf, string'(" ,  G0 time delay = "));
            write (buf, g0_time_delay_val);
            writeline(output, buf);

        end if;
    end process;

    process (schedule_vco, areset_ipd, ena_ipd, pfdena_ipd, refclk, fbclk, inclk0_ipd, inclk1_ipd, clkswitch_ipd, done_with_param_calc)
    variable sched_time : time := 0 ps;

    TYPE time_array is ARRAY (0 to 7) of time;
    variable init : boolean := true;
    variable refclk_period : time;
    variable primary_clock_frequency : time;
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
    variable schedule_offset : boolean := true;

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

    variable pull_back_ext_fbk_cntr : integer := 0;
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
    variable init_clks : boolean := true;
    variable ext_fbk_cntr_modulus : integer := 1;
    variable pll_is_in_reset : boolean := false;

    -- clkswitch variables
    variable other_clock_value : std_logic := '0';
    variable other_clock_last_value : std_logic;
    variable current_clock : string(1 to 6) := primary_clock;
    variable clk0_count, clk1_count : integer := 0;
    variable clk0_is_bad, clk1_is_bad : std_logic := '0';
    variable primary_clk_is_bad : boolean := false;
    variable current_clk_is_bad : boolean := false;
    variable got_curr_clk_falling_edge_after_clkswitch : boolean := false;
    variable switch_over_count : integer := 0;
    variable active_clock : std_logic := '0';
    variable external_switch : boolean := false;

    begin
        if (init and done_with_param_calc) then
            if (pll_type = "fast") then
                locked_tmp := '1';
            end if;
            m_val <= m_val_tmp;
            n_val <= n_val_tmp;
            -- jump-start the VCO
            -- add 1 ps delay to ensure all signals are updated to initial
            -- values
            schedule_vco <= transport not schedule_vco after 1 ps;

            init := false;
        end if;

        -- merged from separate process
        if (now = 0 ps) then
            if (current_clock = "inclk1") then
                active_clock := '1';
            end if;
        end if;
        if (clkswitch_ipd'event and clkswitch_ipd = '1') then
            external_switch := true;
        end if;
        -- save the current inclk event value
        if (inclk0_ipd'event) then
            if (current_clock /= "inclk0") then
                other_clock_value := inclk0_ipd;
            end if;
        end if;
        if (inclk1_ipd'event) then
            if (current_clock /= "inclk1") then
                other_clock_value := inclk1_ipd;
            end if;
        end if;

        -- check if either input clk is bad
        if (inclk0_ipd'event and inclk0_ipd = '1') then
            clk0_count := clk0_count + 1;
            clk0_is_bad := '0';
            if (current_clock = "inclk0") then
                current_clk_is_bad := false;
            end if;
            clk1_count := 0;
            if (clk0_count > 2) then
                -- no event on other clk for 2 cycles
                clk1_is_bad := '1';
                if (current_clock = "inclk1") then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;
        if (inclk1_ipd'event and inclk1_ipd = '1') then
            clk1_count := clk1_count + 1;
            clk1_is_bad := '0';
            if (current_clock = "inclk1") then
                current_clk_is_bad := false;
            end if;
            clk0_count := 0;
            if (clk1_count > 2) then
                -- no event on other clk for 2 cycles
                clk0_is_bad := '1';
                if (current_clock = "inclk0") then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;

        -- check if the bad clk is the primary clock
        if ((primary_clock = "inclk0" and clk0_is_bad = '1') or (primary_clock = "inclk1" and clk1_is_bad = '1')) then
            primary_clk_is_bad := true;
        else
            primary_clk_is_bad := false;
        end if;

        -- actual switching
        if (inclk0_ipd'event and current_clock = "inclk0") then
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
        end if;
        if (inclk1_ipd'event and current_clock = "inclk1") then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk1_ipd = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk1_ipd;
                end if;
            else
                clkin <= transport inclk1_ipd;
            end if;
        end if;
        if (inclk0_ipd'event or inclk1_ipd'event) then
            if ( (other_clock_value = '1') and
                (other_clock_value /= other_clock_last_value) and
                (switch_over_on_lossclk = "on") and
                (enable_switch_over_counter = "on") and
                (primary_clk_is_bad) ) then
                    switch_over_count := switch_over_count + 1;
            end if;
            if ((other_clock_value = '0') and (other_clock_value /= other_clock_last_value)) then
                if (external_switch and (got_curr_clk_falling_edge_after_clkswitch or current_clk_is_bad)) or (switch_over_on_lossclk = "on" and primary_clk_is_bad and (enable_switch_over_counter = "off" or switch_over_count = switch_over_counter)) then
                    got_curr_clk_falling_edge_after_clkswitch := false;
                    if (current_clock = "inclk0") then
                        current_clock := "inclk1";
                    else
                        current_clock := "inclk0";
                    end if;
                    active_clock := not active_clock;
                    switch_over_count := 0;
                    external_switch := false;
                    current_clk_is_bad := false;
                end if;
            end if;
            other_clock_last_value := other_clock_value;
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

        -- end -- clkswitch

        if (schedule_vco'event) then
            if (init_clks) then
                if (primary_clock = "inclk0") then
                    refclk_period := inclk0_input_frequency * n_val * 1 ps;
                    primary_clock_frequency := inclk0_input_frequency * 1 ps;
                elsif (primary_clock = "inclk1") then
                    refclk_period := inclk1_input_frequency * n_val * 1 ps;
                    primary_clock_frequency := inclk1_input_frequency * 1 ps;
                end if;

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
        end if;

        -- areset deasserted
        if (areset_ipd'event and areset_ipd = '0') then
            if (scandataout_tmp = '1') then
                sdataout_rst_trig <= transport not sdataout_rst_trig;
            end if;
        end if;

        -- ena was deasserted
        if (ena_ipd'event and ena_ipd = '0') then
            assert false report family_name & " PLL was disabled" severity note;
        end if;

        if (schedule_vco'event and (areset_ipd = '1' or ena_ipd = '0' or stop_vco)) then
            if (areset_ipd = '1') then
                pll_is_in_reset := true;
            end if;

            -- drop VCO taps to 0
            for i in 0 to 7 loop
                vco_out(i) <= transport '0' after last_phase_shift(i);
                phase_shift(i) := 0 ps;
                last_phase_shift(i) := 0 ps;
            end loop;

            -- reset lock parameters
            locked_tmp := '0';
            if (pll_type = "fast") then
                locked_tmp := '1';
            end if;
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

            first_schedule := true;
            schedule_offset := true;
            vco_val := '0';
            vco_period_was_phase_adjusted := false;
            phase_adjust_was_scheduled := false;

        elsif ((schedule_vco'event or ena_ipd'event or areset_ipd'event) and areset_ipd = '0' and ena_ipd = '1' and (not stop_vco) and (now > 0 ps)) then

            -- note areset deassert time
            -- note it as refclk_time to prevent false triggering
            -- of stop_vco after areset
            if (areset_ipd'event and areset_ipd = '0' and pll_is_in_reset) then
                refclk_time := now;
                pll_is_in_reset := false;
            end if;

            -- calculate loop_xplier : this will be different from m_val
            -- in external_feedback_mode
            loop_xplier := m_val;
            loop_initial := m_initial_val - 1;
            loop_ph := m_ph_val;
            loop_time_delay := m_time_delay_val;

            if (operation_mode = "external_feedback") then
                if (ext_fbk_cntr_mode = "bypass") then
                    ext_fbk_cntr_modulus := 1;
                else
                    ext_fbk_cntr_modulus := ext_fbk_cntr_high + ext_fbk_cntr_low;
                end if;

                loop_xplier := m_val * (ext_fbk_cntr_modulus);
                loop_ph := ext_fbk_cntr_ph;
                loop_initial := ext_fbk_cntr_initial - 1 + ((m_initial_val - 1) * (ext_fbk_cntr_modulus));
                loop_time_delay := m_time_delay_val + ext_fbk_cntr_delay;
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
                pull_back_ext_fbk_cntr :=  ext_fbk_cntr_delay + (ext_fbk_cntr_initial - 1) * (m_times_vco_period/loop_xplier)/1 ps + fbk_phase;
                while (pull_back_ext_fbk_cntr > refclk_period/1 ps) loop
                    pull_back_ext_fbk_cntr := pull_back_ext_fbk_cntr - refclk_period/ 1 ps;
                end loop;
                pull_back_M :=  m_time_delay_val + (m_initial_val - 1) * (ext_fbk_cntr_modulus) * ((refclk_period/loop_xplier)/1 ps);
                while (pull_back_M > refclk_period/1 ps) loop
                    pull_back_M := pull_back_M - refclk_period/ 1 ps;
                end loop;
            else
                pull_back_ext_fbk_cntr := 0;
                pull_back_M := initial_delay/1 ps + m_time_delay_val + fbk_phase;
            end if;

            total_pull_back := pull_back_M + pull_back_ext_fbk_cntr;

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
                ext_fbk_delay <= transport (pull_back_ext_fbk_cntr - fbk_phase) after 1 ps;
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

                    -- add offset
                    if (schedule_offset) then
                        sched_time := sched_time + offset;
                        schedule_offset := false;
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

            if (sched_time > 0 ps) then
                schedule_vco <= transport not schedule_vco after sched_time;
            end if;

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

        if (refclk'event and refclk = '1' and areset_ipd = '0') then
            n_val <= n_val_tmp;
            got_refclk_posedge := true;
            if (not got_first_refclk) then
                got_first_refclk := true;
            else
                got_second_refclk := true;
                refclk_period := now - refclk_time;

                -- check if incoming freq. will cause VCO range to be
                -- exceeded
                if ((vco_max /= 0 and vco_min /= 0 and skip_vco = "off" and pfdena_ipd = '1') and
                    (((refclk_period/1 ps)/loop_xplier > vco_max) or
                    ((refclk_period/1 ps)/loop_xplier < vco_min)) ) then
                    if (pll_is_locked) then
                        assert false report " Input clock freq. is not within VCO range : " & family_name & " PLL may lose lock" severity warning;
                        if (inclk_out_of_range) then
                            -- unlock
                            pll_is_locked := false;
                            locked_tmp := '0';
                            if (pll_type = "fast") then
                                locked_tmp := '1';
                            end if;
                            pll_about_to_lock := false;
                            cycles_to_lock := 0;
                            assert false report family_name & " PLL lost lock" severity note;
                            first_schedule := true;
                            schedule_offset := true;
                            vco_period_was_phase_adjusted := false;
                            phase_adjust_was_scheduled := false;
                        end if;
                    elsif (not no_warn) then
                        assert false report " Input clock freq. is not within VCO range : " & family_name & " PLL may not lock." severity warning;
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
            m_val <= transport m_val_tmp after 1 ps;
            got_fbclk_posedge := true;
            if (not got_first_fbclk) then
                got_first_fbclk := true;
            else
                fbclk_period := now - fbclk_time;
            end if;

            -- need refclk_period here, so initialized to proper value above
            if ( ( (now - refclk_time > 1.5 * refclk_period) and pfdena_ipd = '1' and pll_is_locked)  or ((now - refclk_time > 5 * refclk_period) and pfdena_ipd = '1') ) then
                stop_vco := true;
                -- reset
                got_first_refclk := false;
                got_first_fbclk := false;
                got_second_refclk := false;
                if (pll_is_locked) then
                    pll_is_locked := false;
                    locked_tmp := '0';
                    if (pll_type = "fast") then
                        locked_tmp := '1';
                    end if;
                    assert false report family_name & " PLL lost lock due to loss of input clock" severity note;
                end if;
                pll_about_to_lock := false;
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
                if (cycles_to_lock = valid_lock_multiplier - 1) then
                    pll_about_to_lock := true;
                end if;
                if (cycles_to_lock = valid_lock_multiplier) then
                    if (not pll_is_locked) then
                        assert (quiet_period_violation) report family_name & " PLL locked to incoming clock" severity note;
                    end if;
                    pll_is_locked := true;
                    locked_tmp := '1';
                    if (pll_type = "fast") then
                        locked_tmp := '0';
                    end if;
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
                        if (pll_type = "fast") then
                            locked_tmp := '1';
                        end if;
                        pll_about_to_lock := false;
                        cycles_to_lock := 0;
                        assert (quiet_period_violation) report family_name & " PLL lost lock" severity note;
                        first_schedule := true;
                        schedule_offset := true;
                        vco_period_was_phase_adjusted := false;
                        phase_adjust_was_scheduled := false;
                    end if;
                end if;
                if ( abs(refclk_period - fbclk_period) <= 2 ps ) then
                    -- frequency is still good
                    if (now = fbclk_time and (not phase_adjust_was_scheduled)) then
                        if ( abs(fbclk_time - refclk_time) > refclk_period/2) then
                            if ( abs(fbclk_time - refclk_time) > 1.5 * refclk_period) then
                                -- input clock may have stopped; do nothing
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

        if (pfdena_ipd = '0') then
            locked_tmp := 'X';
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

        if (quiet_period_violation or reconfig_err or scanclr_violation or scanclr_clk_violation) then
            lock <= '0';
            if (pll_type = "fast") then
                lock <= '1';
            end if;
        else
            lock <= locked_tmp;
        end if;
        about_to_lock <= pll_about_to_lock after 1 ps;

        -- signal to calculate quiet_time
        sig_refclk_period <= refclk_period;
        sig_current_clock <= current_clock;

        -- signals for debugging
        sig_offset <= offset;
        sig_refclk_time <= refclk_time;
        sig_fbclk_time <= fbclk_time;
        sig_fbclk_period <= fbclk_period;
        sig_vco_period_was_phase_adjusted <= vco_period_was_phase_adjusted;
        sig_phase_adjust_was_scheduled <= phase_adjust_was_scheduled;
        if (stop_vco = true) then
            sig_stop_vco <= '1';
        else
            sig_stop_vco <= '0';
        end if;
        sig_m_times_vco_period <= m_times_vco_period;
        sig_new_m_times_vco_period <= new_m_times_vco_period;
        sig_got_refclk_posedge <= got_refclk_posedge;
        sig_got_fbclk_posedge <= got_fbclk_posedge;
        sig_got_second_refclk <= got_second_refclk;
    end process;

    process (scanclk_ipd, scanaclr_ipd, scan_data, transfer, sdataout_trig, sdataout_rst_trig)
    variable j : integer := 0;
    variable pll_in_quiet_period : boolean := false;
    variable start_quiet_time : time := 0 ps;
    variable quiet_time : time := 0 ps;
    variable scanclr_rising_time : time := 0 ps;
    variable scanclr_falling_time : time := 0 ps;
    variable got_first_scanclk_after_scanclr_inactive_edge : boolean := false;
    variable scan_chain_being_reset : boolean := false;

    function  slowest_clk ( L0 : integer; L0_mode : string(1 to 6);
                            L1 : integer; L1_mode : string(1 to 6);
                            G0 : integer; G0_mode : string(1 to 6);
                            G1 : integer; G1_mode : string(1 to 6);
                            G2 : integer; G2_mode : string(1 to 6);
                            G3 : integer; G3_mode : string(1 to 6);
                            E0 : integer; E0_mode : string(1 to 6);
                            E1 : integer; E1_mode : string(1 to 6);
                            E2 : integer; E2_mode : string(1 to 6);
                            E3 : integer; E3_mode : string(1 to 6);
                            scan_chain : string; 
                            refclk : time; m_mod : integer) return time is
        variable max_modulus : integer := 1;
        variable q_period : time := 0 ps;
        variable refclk_int : integer := 0;
        begin
            if (L0_mode /= "bypass" and L0_mode /= "   off") then
                max_modulus := L0;
            end if;
            if (L1 > max_modulus and L1_mode /= "bypass" and L1_mode /= "   off") then
                max_modulus := L1;
            end if;
            if (G0 > max_modulus and G0_mode /= "bypass" and G0_mode /= "   off") then
                max_modulus := G0;
            end if;
            if (G1 > max_modulus and G1_mode /= "bypass" and G1_mode /= "   off") then
                max_modulus := G1;
            end if;
            if (G2 > max_modulus and G2_mode /= "bypass" and G2_mode /= "   off") then
                max_modulus := G2;
            end if;
            if (G3 > max_modulus and G3_mode /= "bypass" and G3_mode /= "   off") then
                max_modulus := G3;
            end if;
            if (scan_chain = "long") then
                if (E0 > max_modulus and E0_mode /= "bypass" and E0_mode /= "   off") then
                    max_modulus := E0;
                end if;
                if (E1 > max_modulus and E1_mode /= "bypass" and E1_mode /= "   off") then
                    max_modulus := E1;
                end if;
                if (E2 > max_modulus and E2_mode /= "bypass" and E2_mode /= "   off") then
                    max_modulus := E2;
                end if;
                if (E3 > max_modulus and E3_mode /= "bypass" and E3_mode /= "   off") then
                    max_modulus := E3;
                end if;
            end if;
            refclk_int := refclk / 1 ps;
            if (m_mod /= 0) then
                q_period := ((refclk_int/m_mod) * max_modulus) * 1 ps;
            end if;
        return (2*q_period);
    end slowest_clk;

    begin
        if (transfer'event) then
            if (transfer = '0') then
                -- clear the chain
                for i in scan_data'range loop
                    scan_data(i) <= '0';
                end loop;
            end if;
        elsif (scanaclr_ipd'event and scanaclr_ipd = '1') then
            -- scanaclr rising
            scanclr_rising_time := now;
            scan_chain_being_reset := true;
        elsif (scanaclr_ipd'event and scanaclr_ipd = '0') then
            -- scanaclr falling
            scanclr_falling_time := now;
            if (scan_chain_being_reset and (now - scanclr_rising_time < TRST)) then
                scanclr_violation <= true;
                ASSERT false REPORT "Detected SCANACLR ACTIVE pulse width violation. Required is 5000 ps, actual is "& int2str((now - scanclr_rising_time) / 1 ps) &". The PLL may not function correctly." severity warning;
            else
                scanclr_violation <= false;
                for i in scan_data'range loop
                    scan_data(i) <= '0';
                end loop;
            end if;
            scan_chain_being_reset := false;
            got_first_scanclk_after_scanclr_inactive_edge := false;
        elsif (scanclk_ipd'event and scanclk_ipd = '1' and not got_first_scanclk_after_scanclr_inactive_edge and (now - scanclr_falling_time < TRSTCLK)) then
            scanclr_clk_violation <= true;
            got_first_scanclk_after_scanclr_inactive_edge := true;

            ASSERT false REPORT "Detected SCANACLR INACTIVE time violation before rising edge of SCANCLK. Required is 5000 ps, actual is "& int2str((now - scanclr_falling_time) / 1 ps) &". Reconfiguration may not work." severity warning;
        elsif (scanclk_ipd'event and scanclk_ipd = '1' and scanaclr_ipd = '0') then
            if (pll_in_quiet_period and (now - start_quiet_time < quiet_time)) then
                ASSERT false REPORT "Detected transition on SCANCLK during quiet period. The PLL may not function correctly." severity warning;
                quiet_period_violation <= true;
            else
                pll_in_quiet_period := false;
                for j in scan_chain_length-1 downto 1 loop
                    scan_data(j) <= scan_data(j-1);
                end loop;
                scan_data(0) <= scandata_ipd;
            end if;
            if (not got_first_scanclk_after_scanclr_inactive_edge) then
                got_first_scanclk_after_scanclr_inactive_edge := true;
                scanclr_clk_violation <= false;
            end if;
        elsif (scanclk_ipd'event and scanclk_ipd = '0' and scanaclr_ipd = '0') then
            if (pll_in_quiet_period and (now - start_quiet_time < quiet_time)) then
                ASSERT false REPORT "Detected transition on SCANCLK during quiet period. The PLL may not function correctly." severity warning;
                quiet_period_violation <= true;
            elsif (scan_data(scan_chain_length-1) = '1') then
                -- reset violation flag only after another reconfig seq.
                quiet_period_violation <= false;

                -- initiate transfer
                transfer <= '1';
                transfer <= transport '0' after 1 ps;
                scandataout_tmp <= '1';
                pll_in_quiet_period := true;
                start_quiet_time := now;
                quiet_time := slowest_clk ( l0_high_val+l0_low_val, l0_mode_val,
                                            l1_high_val+l1_low_val, l1_mode_val,
                                            g0_high_val+g0_low_val, g0_mode_val,
                                            g1_high_val+g1_low_val, g1_mode_val,
                                            g2_high_val+g2_low_val, g2_mode_val,
                                            g3_high_val+g3_low_val, g3_mode_val,
                                            e0_high_val+e0_low_val, e0_mode_val,
                                            e1_high_val+e1_low_val, e1_mode_val,
                                            e2_high_val+e2_low_val, e2_mode_val,
                                            e3_high_val+e3_low_val, e3_mode_val,
                                            scan_chain, sig_refclk_period, m_val);
                sdataout_trig <= transport not sdataout_trig after quiet_time;
            end if;
        elsif (sdataout_trig'event) then
            if (areset_ipd = '0') then
                scandataout_tmp <= transport '0';
            end if;
        elsif (sdataout_rst_trig'event) then
            scandataout_tmp <= transport '0' after quiet_time;
        end if;
    end process;

    clk0_tmp <= l0_clk when i_clk0_counter = "l0" else
                l1_clk when i_clk0_counter = "l1" else
                g0_clk when i_clk0_counter = "g0" else
                g1_clk when i_clk0_counter = "g1" else
                g2_clk when i_clk0_counter = "g2" else
                g3_clk when i_clk0_counter = "g3" else
                '0';
    not_clk0_tmp <= not clk0_tmp;
    ena0_reg : cyclone_dffe
                port map  ( D    => clkena(0),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_clk0_tmp,
                            Q    => ena0 );
                            
    clk(0)  <=  ena0 and clk0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                ena0 and 'X';

    clk1_tmp <= l0_clk when i_clk1_counter = "l0" else
                l1_clk when i_clk1_counter = "l1" else
                g0_clk when i_clk1_counter = "g0" else
                g1_clk when i_clk1_counter = "g1" else
                g2_clk when i_clk1_counter = "g2" else
                g3_clk when i_clk1_counter = "g3" else
                '0';
    not_clk1_tmp <= not clk1_tmp;
    ena1_reg : cyclone_dffe
                port map  ( D    => clkena(1),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_clk1_tmp,
                            Q    => ena1 );
                            
    clk(1)  <=  ena1 and clk1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                ena1 and 'X';

    clk2_tmp <= l0_clk when i_clk2_counter = "l0" else
                l1_clk when i_clk2_counter = "l1" else
                g0_clk when i_clk2_counter = "g0" else
                g1_clk when i_clk2_counter = "g1" else
                g2_clk when i_clk2_counter = "g2" else
                g3_clk when i_clk2_counter = "g3" else
                '0';
    not_clk2_tmp <= not clk2_tmp;
    ena2_reg : cyclone_dffe
                port map  ( D    => clkena(2),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_clk2_tmp,
                            Q    => ena2 );
                            
    clk(2)  <=  ena2 and clk2_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                ena2 and 'X';

    clk3_tmp <= l0_clk when i_clk3_counter = "l0" else
                l1_clk when i_clk3_counter = "l1" else
                g0_clk when i_clk3_counter = "g0" else
                g1_clk when i_clk3_counter = "g1" else
                g2_clk when i_clk3_counter = "g2" else
                g3_clk when i_clk3_counter = "g3" else
                '0';
    not_clk3_tmp <= not clk3_tmp;
    ena3_reg : cyclone_dffe
                port map  ( D    => clkena(3),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_clk3_tmp,
                            Q    => ena3 );
                            
    clk(3)  <=  ena3 and clk3_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                ena3 and 'X';

    clk4_tmp <= l0_clk when i_clk4_counter = "l0" else
                l1_clk when i_clk4_counter = "l1" else
                g0_clk when i_clk4_counter = "g0" else
                g1_clk when i_clk4_counter = "g1" else
                g2_clk when i_clk4_counter = "g2" else
                g3_clk when i_clk4_counter = "g3" else
                '0';
    not_clk4_tmp <= not clk4_tmp;
    ena4_reg : cyclone_dffe
                port map  ( D    => clkena(4),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_clk4_tmp,
                            Q    => ena4 );
                            
    clk(4)  <=  ena4 and clk4_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                ena4 and 'X';

    clk5_tmp <= l0_clk when i_clk5_counter = "l0" else
                l1_clk when i_clk5_counter = "l1" else
                g0_clk when i_clk5_counter = "g0" else
                g1_clk when i_clk5_counter = "g1" else
                g2_clk when i_clk5_counter = "g2" else
                g3_clk when i_clk5_counter = "g3" else
                '0';
    not_clk5_tmp <= not clk5_tmp;
    ena5_reg : cyclone_dffe
                port map  ( D    => clkena(5),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_clk5_tmp,
                            Q    => ena5 );
                            
    clk(5)  <=  ena5 and clk5_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                ena5 and 'X';

    extclk0_tmp <=  e0_clk when i_extclk0_counter = "e0" else
                    e1_clk when i_extclk0_counter = "e1" else
                    e2_clk when i_extclk0_counter = "e2" else
                    e3_clk when i_extclk0_counter = "e3" else
                    g0_clk when i_extclk0_counter = "g0" else
                    '0';
    not_extclk0_tmp <= not extclk0_tmp;
    extena0_reg : cyclone_dffe
                port map  ( D    => extclkena(0),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_extclk0_tmp,
                            Q    => extena0 );
                            
    extclk(0)  <=   extena0 and extclk0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                    extena0 and 'X';

    extclk1_tmp <=  e0_clk when i_extclk1_counter = "e0" else
                    e1_clk when i_extclk1_counter = "e1" else
                    e2_clk when i_extclk1_counter = "e2" else
                    e3_clk when i_extclk1_counter = "e3" else
                    g0_clk when i_extclk1_counter = "g0" else
                    '0';
    not_extclk1_tmp <= not extclk1_tmp;
    extena1_reg : cyclone_dffe
                port map  ( D    => extclkena(1),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_extclk1_tmp,
                            Q    => extena1 );
                            
    extclk(1)  <=   extena1 and extclk1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                    extena1 and 'X';

    extclk2_tmp <=  e0_clk when i_extclk2_counter = "e0" else
                    e1_clk when i_extclk2_counter = "e1" else
                    e2_clk when i_extclk2_counter = "e2" else
                    e3_clk when i_extclk2_counter = "e3" else
                    g0_clk when i_extclk2_counter = "g0" else
                    '0';
    not_extclk2_tmp <= not extclk2_tmp;
    extena2_reg : cyclone_dffe
                port map  ( D    => extclkena(2),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_extclk2_tmp,
                            Q    => extena2 );
                            
    extclk(2)  <=   extena2 and extclk2_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                    extena2 and 'X';

    extclk3_tmp <=  e0_clk when i_extclk3_counter = "e0" else
                    e1_clk when i_extclk3_counter = "e1" else
                    e2_clk when i_extclk3_counter = "e2" else
                    e3_clk when i_extclk3_counter = "e3" else
                    g0_clk when i_extclk3_counter = "g0" else
                    '0';
    not_extclk3_tmp <= not extclk3_tmp;
    extena3_reg : cyclone_dffe
                port map  ( D    => extclkena(3),
                            CLRN => vcc,
                            PRN  => vcc,
                            ENA  => vcc,
                            CLK  => not_extclk3_tmp,
                            Q    => extena3 );
                            
    extclk(3)  <=   extena3 and extclk3_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                    extena3 and 'X';

    enable0 <=  enable0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                'X';
    enable1 <=  enable1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                'X';

    scandataout <= scandataout_tmp;

end vital_pll;
-- END ARCHITECTURE VITAL_PLL
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cyclone_dll
--
-- Description : Simulation model for the Cyclone DLL.
--
-- Outputs     : Delayctrlout output (active high) indicates when the
--               DLL locks to the incoming clock
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.cyclone_atom_pack.all;
USE work.cyclone_pllpack.all;

ENTITY cyclone_dll is
    GENERIC ( input_frequency   : string  := "10000 ps";
              phase_shift       : string  := "0";
              sim_valid_lock    : integer := 1;
              sim_invalid_lock  : integer := 5;
              lpm_type          : string  := "cyclone_dll";

              -- VITAL generics
              XOn                         : Boolean := DefGlitchXOn;
              MsgOn                       : Boolean := DefGlitchMsgOn;
              tipd_clk                    : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( clk           : IN std_logic;
              delayctrlout  : OUT std_logic
            );
END cyclone_dll;

ARCHITECTURE vital_dll of cyclone_dll is

signal clk_detect : std_logic := '0';
signal clk_ipd : std_logic;

begin

    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
    end block;

    process (clk_ipd, clk_detect)
    variable got_first_rising_edge : boolean := false;
    variable got_first_falling_edge : boolean := false;
    variable clk_ipd_last_rising_edge : time := 0 ps;
    variable clk_ipd_last_falling_edge : time := 0 ps;

    variable inclk_ps : time := 0 ps;
    variable duty_cycle : time := 0 ps;
    variable clk_per_tolerance : time := 0 ps;

    variable clk_detect_count : integer := 0;
    variable start_clk_detect : boolean := false;
    variable half_cycles_to_lock : integer := 0;
    variable half_cycles_to_keep_lock : integer := 0;
    variable violation : boolean := false;

    variable dll_is_locked : std_logic := '0';
    variable init : boolean := true;
    variable input_freq_warn : boolean := true;
    variable duty_cycle_warn : boolean := true;
    begin
        if (init) then
            -- convert the frequency in string form to integer
            inclk_ps := dqs_str2int(input_frequency) * 1 ps;
            duty_cycle := inclk_ps/2;
            clk_per_tolerance := inclk_ps * 0.1;

            -- if sim_valid_lock = 0, dll starts out locked
            if (sim_valid_lock = 0) then
                dll_is_locked := '1';
            end if;
            init := false;
        end if;
        if (clk_ipd'event and clk_ipd = '1') then
            if (not got_first_rising_edge) then
                got_first_rising_edge := true;
                half_cycles_to_lock := half_cycles_to_lock + 1;
                if (sim_valid_lock > 0 and half_cycles_to_lock >= sim_valid_lock and not violation) then
                    dll_is_locked := '1';
                    assert false report "DLL locked to incoming clock" severity note;
                end if;
                -- start the internal clock that will monitor
                -- the input clock
                if (not start_clk_detect) then
                    start_clk_detect := true;
                    clk_detect <= '1';
                end if;
            else
                -- reset clk_event counter
                clk_detect_count := 0;
                -- check for clk period violation
                if ( ((now - clk_ipd_last_rising_edge) < (inclk_ps - clk_per_tolerance)) or ((now - clk_ipd_last_rising_edge) > (inclk_ps + clk_per_tolerance)) ) then
                    violation := true;
                    if (input_freq_warn) then
                        assert false report "Input frequency violation." severity warning;
                        input_freq_warn := false;
                    end if;
                elsif ( ((now - clk_ipd_last_falling_edge) < (duty_cycle - clk_per_tolerance/2)) or ((now - clk_ipd_last_falling_edge) > (duty_cycle + clk_per_tolerance/2)) ) then
                    violation := true;
                    if (duty_cycle_warn) then
                        assert false report "Duty cycle violation." severity warning;
                        duty_cycle_warn := false;
                    end if;
                else
                    violation := false;
                end if;
                if (violation and dll_is_locked = '1') then
                    half_cycles_to_keep_lock := half_cycles_to_keep_lock + 1;
                    if (half_cycles_to_keep_lock > sim_invalid_lock) then
                        dll_is_locked := '0';
                        assert false report "DLL lost lock due to Input Frequency / Duty Cycle violation" severity warning;
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                    end if;
                elsif (violation) then
                    half_cycles_to_lock := 0;
                elsif (not violation and dll_is_locked = '0') then
                    -- increment lock counter
                    half_cycles_to_lock := half_cycles_to_lock + 1;
                    if (half_cycles_to_lock > sim_valid_lock) then
                        dll_is_locked := '1';
                        assert false report "DLL locked to incoming clock" severity note;
                    end if;
                else
                    half_cycles_to_keep_lock := 0;
                end if;
            end if;
            clk_ipd_last_rising_edge := now;
        elsif (clk_ipd'event and clk_ipd = '0') then
            -- reset clk_event counter
            clk_detect_count := 0;
            got_first_falling_edge := true;
            if (got_first_rising_edge) then
                -- check for duty cycle violation
                if ( ((now - clk_ipd_last_rising_edge) < (duty_cycle - clk_per_tolerance/2)) or ((now - clk_ipd_last_rising_edge) > (duty_cycle + clk_per_tolerance/2)) ) then
                    violation := true;
                    if (duty_cycle_warn) then
                        assert false report "Duty cycle violation." severity warning;
                        duty_cycle_warn := false;
                    end if;
                else
                    violation := false;
                end if;
                if (dll_is_locked = '1' and violation) then
                    half_cycles_to_keep_lock := half_cycles_to_keep_lock + 1;
                    if (half_cycles_to_keep_lock > sim_invalid_lock) then
                        dll_is_locked := '0';
                        assert false report "DLL lost lock due to Input Frequency / Duty Cycle violation" severity warning;
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                    end if;
                elsif (dll_is_locked = '1') then
                    half_cycles_to_keep_lock := 0;
                elsif (dll_is_locked = '0' and violation) then
                    half_cycles_to_lock := 0;
                else
                    half_cycles_to_lock := half_cycles_to_lock + 1;
                end if;
            else
                -- first clk edge is falling edge, do nothing
            end if;
            clk_ipd_last_falling_edge := now;
        else
            if (clk_ipd'event) then
                -- illegal value
                if (got_first_rising_edge or got_first_falling_edge) then
                    if (dll_is_locked = '1') then
                        dll_is_locked := '0';
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                        assert false report "Illegal value detected on input clock. DLL will lose lock." severity error;
                    else
                        -- clock started up, then went to 'X'
                        -- this is to weed out the 'X' at start of simulation.
                        assert false report "Illegal value detected on input clock." severity error;
                        -- reset lock counter
                        half_cycles_to_lock := 0;
                    end if;
                end if;
            end if;
        end if;

    -- ********************************************************************
    -- The following block generates the internal clock that is used to
    -- track loss of input clock. A counter counts events on this internal
    -- clock, and is reset to 0 on event on input clock. If input clock
    -- flatlines, the counter will exceed the limit and DLL will lose lock.
    -- Events on internal clock are scheduled at the max. allowable input
    -- clock tolerance, to allow 'sim_invalid_lock' parameter value = 1.
    -- ********************************************************************

        if (start_clk_detect) then
            if (clk_detect'event and clk_detect /= clk_detect'last_value) then
                -- increment clock event counter
                clk_detect_count := clk_detect_count + 1;
                if (dll_is_locked = '1') then
                    if (clk_detect_count > sim_invalid_lock) then
                        dll_is_locked := '0';
                        assert false report "DLL lost lock due to loss of input clock" severity warning;
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                        clk_detect_count := 0;
                        start_clk_detect := false;
                        clk_detect <= transport '0' after inclk_ps/2;
                    else
                        clk_detect <= transport not clk_detect after (inclk_ps/2 + clk_per_tolerance/2);
                    end if;
                elsif (clk_detect_count > 10) then
                    assert false report "No input clock : DLL will not lock" severity warning;
                    clk_detect_count := 0;
                else
                    clk_detect <= transport not clk_detect after (inclk_ps/2 + clk_per_tolerance/2);
                end if;
            end if;
        end if;

        delayctrlout <= dll_is_locked;

    end process;


end vital_dll;
-------------------------------------------------------------------
--
-- Entity Name : cyclone_jtag
--
-- Description : Cyclone JTAG VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.cyclone_atom_pack.all;

entity  cyclone_jtag is
    generic (
        lpm_type : string := "cyclone_jtag"
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
end cyclone_jtag;

architecture architecture_jtag of cyclone_jtag is
begin

end architecture_jtag;

-------------------------------------------------------------------
--
-- Entity Name : cyclone_crcblock
--
-- Description : Cyclone CRCBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.cyclone_atom_pack.all;

entity  cyclone_crcblock is
    generic  (
        oscillator_divider : integer := 1;

        lpm_type : string := "cyclone_crcblock"
        );	
    port (
        clk : in std_logic := '0'; 
        shiftnld : in std_logic := '0'; 
           ldsrc : in std_logic := '0'; 
        crcerror : out std_logic; 
        regout : out std_logic
        ); 
end cyclone_crcblock;

architecture architecture_crcblock of cyclone_crcblock is
begin
	crcerror <= '0';
	regout <= '0';
end architecture_crcblock;

---------------------------------------------------------------------
--
-- Entity Name :  cyclone_routing_wire
--
-- Description :  Cyclone Routing Wire VHDL simulation model
--
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cyclone_atom_pack.all;

ENTITY cyclone_routing_wire is
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
   attribute VITAL_LEVEL0 of cyclone_routing_wire : entity is TRUE;
end cyclone_routing_wire;

ARCHITECTURE behave of cyclone_routing_wire is
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

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cyclone_asynch_io
--
-- Description : Simulation model for asynchronous submodule of
--               Cyclone Lcell.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cyclone_atom_pack.all;

ENTITY cyclone_asynch_io is
    generic (
        operation_mode  : STRING := "input";
        open_drain_output : STRING := "false";
        bus_hold : STRING := "false";
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;
        tpd_datain_padio     : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_padio_combout    : VitalDelayType01 := DefPropDelay01;
        tpd_regin_regout     : VitalDelayType01 := DefPropDelay01;
        tipd_datain          : VitalDelayType01 := DefPropDelay01;
        tipd_oe              : VitalDelayType01 := DefPropDelay01;
        tipd_padio           : VitalDelayType01 := DefPropDelay01
        );

    port (
        datain  : in  STD_LOGIC := '0';
        oe      : in  STD_LOGIC := '1';
        regin   : in std_logic;
        padio   : inout STD_LOGIC;
        combout : out STD_LOGIC;
        regout  : out STD_LOGIC
        );
		
    attribute VITAL_LEVEL0 of cyclone_asynch_io : ENTITY is TRUE;
end cyclone_asynch_io;

ARCHITECTURE behave of cyclone_asynch_io is
    attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;
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

    VITAL: process(padio_ipd, datain_ipd, oe_ipd, regin)
    variable combout_VitalGlitchData : VitalGlitchDataType;
    variable padio_VitalGlitchData : VitalGlitchDataType;
    variable regout_VitalGlitchData : VitalGlitchDataType;
        
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
            elsif (operation_mode = "output" or 
                   operation_mode = "bidir") then
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

            if ( now <= 1 ps AND prev_value = 'W' ) then
                --for autotest to pass
                prev_value := 'L';
            end if;

        else    -- bus_hold is false
            if (operation_mode = "input") then
                tmp_combout := padio_ipd;
                tmp_padio := 'Z';
            elsif (operation_mode = "output" or 
                   operation_mode = "bidir" ) then
                if ( operation_mode  = "bidir") then
                    tmp_combout := padio_ipd;
                else
                    tmp_combout := 'Z';
                end if;

                if (oe_ipd = '1') then
                    if (open_drain_output = "true" ) then
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
                elsif (oe_ipd = '0' ) then
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
        
        VitalPathDelay01 (
        OutSignal => regout,
        OutSignalName => "regout",
        OutTemp => regin,
        Paths => (1 => (regin'last_event, tpd_regin_regout, TRUE)),
        GlitchData => regout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn  => MsgOn );

    end process;

end behave;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cyclone_io
--
-- Description : Simulation model for Cyclone IO.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cyclone_atom_pack.all;
use work.cyclone_asynch_io;
use work.cyclone_dffe;
use work.cyclone_mux21;

ENTITY  cyclone_io is
    generic (
        operation_mode : string := "input";
        open_drain_output : string := "false";
        bus_hold : string := "false";
        output_register_mode : string := "none";
        output_async_reset : string := "none";
        output_sync_reset : string := "none";
        output_power_up : string := "low";
        tie_off_output_clock_enable : string := "false";
        oe_register_mode : string := "none";
        oe_async_reset : string := "none";
        oe_sync_reset : string := "none";
        oe_power_up : string := "low";
        tie_off_oe_clock_enable : string := "false";
        input_register_mode : string := "none";
        input_async_reset : string := "none";
        input_sync_reset : string := "none";
        input_power_up : string := "low";
        lpm_type : STRING := "cyclone_io"
        );

    port (
        datain          : in std_logic := '0';
        oe              : in std_logic := '1';
        outclk          : in std_logic := '0';
        outclkena       : in std_logic := '1';
        inclk           : in std_logic := '0';
        inclkena        : in std_logic := '1';
        areset          : in std_logic := '0';
        sreset          : in std_logic := '0';
        devclrn         : in std_logic := '1';
        devpor          : in std_logic := '1';
        devoe           : in std_logic := '0';
        combout         : out std_logic;
        regout          : out std_logic;
        padio           : inout std_logic
        );

end cyclone_io;

ARCHITECTURE structure of cyclone_io is
COMPONENT cyclone_asynch_io 
    generic(
        operation_mode : string := "input";
        open_drain_output : string := "false";
        bus_hold : string := "false"
        );

    port(
        datain : in  STD_LOGIC := '0';
        oe	   : in  STD_LOGIC := '0';
        regin  : in std_logic;
        padio  : inout STD_LOGIC;
        combout: out STD_LOGIC;
        regout : out STD_LOGIC
        );
end COMPONENT;

COMPONENT cyclone_dffe
    generic(
        TimingChecksOn: Boolean := true;
        InstancePath: STRING := "*";
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        tpd_PRN_Q_negedge  : VitalDelayType01 := DefPropDelay01;
        tpd_CLRN_Q_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_CLK_Q_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_ENA_Q_posedge  : VitalDelayType01 := DefPropDelay01;
        tsetup_D_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_D_CLK_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_D_CLK_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_D_CLK_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
        thold_ENA_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tipd_D    : VitalDelayType01 := DefPropDelay01;
        tipd_CLRN : VitalDelayType01 := DefPropDelay01;
        tipd_PRN  : VitalDelayType01 := DefPropDelay01;
        tipd_CLK  : VitalDelayType01 := DefPropDelay01;
        tipd_ENA  : VitalDelayType01 := DefPropDelay01
        );

    port(
        Q    : out STD_LOGIC := '0';
        D    : in STD_LOGIC := '1';
        CLRN : in STD_LOGIC := '1';
        PRN  : in STD_LOGIC := '1';
        CLK  : in STD_LOGIC := '0';
        ENA  : in STD_LOGIC := '1'
        );
end COMPONENT;

COMPONENT cyclone_mux21
    port (
        A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic
        );
end COMPONENT;

signal is_bidir_or_output : std_logic;
signal out_reg_clk_ena : std_logic;
signal oe_reg_clk_ena : std_logic;
signal tmp_oe_reg_out : std_logic;
signal tmp_input_reg_out : std_logic;
signal tmp_output_reg_out : std_logic;
	
signal inreg_sreset_is_used : std_logic;
signal outreg_sreset_is_used : std_logic;
signal oereg_sreset_is_used : std_logic;

signal inreg_sreset : std_logic;
signal outreg_sreset : std_logic;
signal oereg_sreset : std_logic;

signal in_reg_aclr : std_logic;
signal in_reg_apreset : std_logic;
	
signal oe_reg_aclr : std_logic;
signal oe_reg_apreset : std_logic;
signal oe_reg_sel : std_logic;
	
signal out_reg_aclr : std_logic;
signal out_reg_apreset : std_logic;
signal out_reg_sel : std_logic;
	
signal input_reg_pu_low : std_logic;
signal output_reg_pu_low : std_logic;
signal oe_reg_pu_low : std_logic;
	
signal inreg_D : std_logic;
signal outreg_D : std_logic;
signal oereg_D : std_logic;

signal tmp_datain : std_logic;
signal tmp_oe : std_logic;

signal iareset : std_logic;
signal isreset : std_logic;
	
signal inreg_mux_sel : std_logic;
signal outreg_mux_sel : std_logic;
signal oereg_mux_sel : std_logic;
	
signal input_dffe_aclr : std_logic;
signal input_dffe_apreset : std_logic;
signal output_dffe_aclr : std_logic;
signal output_dffe_apreset : std_logic;

signal oe_dffe_aclr : std_logic;
signal oe_dffe_apreset : std_logic;
              
begin     

    is_bidir_or_output <= '1' WHEN (operation_mode = "bidir" OR 
                                    operation_mode = "output") 
                              ELSE '0';

    input_reg_pu_low <=  '0' WHEN input_power_up = "low" ELSE '1';
    output_reg_pu_low <= '0' WHEN output_power_up = "low" ELSE '1';
    oe_reg_pu_low <= '0' WHEN oe_power_up = "low" ELSE '1';

    out_reg_sel <= '1' WHEN output_register_mode = "register" ELSE '0';
    oe_reg_sel <= '1' WHEN oe_register_mode = "register" ELSE '0';
 
    iareset <= (NOT areset) WHEN ( areset = '1' OR areset = '0') 
                            ELSE '1';
    isreset <= sreset WHEN ( areset = '1' OR areset = '0') ELSE '0';


    -- output registere signals
    out_reg_aclr <= iareset WHEN output_async_reset = "clear" ELSE '1';
    out_reg_apreset <= iareset WHEN output_async_reset = "preset" 
                               ELSE '1';
    outreg_sreset_is_used <= '0' WHEN output_sync_reset = "none" 
                                 ELSE '1';
    outreg_sreset <= '0' WHEN output_sync_reset = "clear" ELSE '1';

    -- oe register signals
    oe_reg_aclr <= iareset WHEN oe_async_reset = "clear" ELSE '1';
    oe_reg_apreset <= iareset WHEN oe_async_reset = "preset" ELSE '1';
    oereg_sreset_is_used <= '0' WHEN oe_sync_reset = "none" ELSE '1';
    oereg_sreset <= '0' WHEN oe_sync_reset = "clear" ELSE '1';
    
    -- input register signals
    in_reg_aclr <= iareset WHEN input_async_reset = "clear" ELSE '1';
    in_reg_apreset <= iareset WHEN input_async_reset = "preset" 
                              ELSE '1';
    inreg_sreset_is_used <= '0' WHEN input_sync_reset = "none" ELSE '1';
    inreg_sreset <= '0' WHEN input_sync_reset = "clear" ELSE '1';

    -- oe and output register clock enable signals
    out_reg_clk_ena <= '1' WHEN tie_off_output_clock_enable = "true" 
                           ELSE outclkena;
    oe_reg_clk_ena <= '1' WHEN tie_off_oe_clock_enable = "true" 
                          ELSE outclkena;
    
    -- input register
    inreg_mux_sel <= isreset AND inreg_sreset_is_used;
    input_dffe_aclr  <= in_reg_aclr AND devclrn AND 
                        (input_reg_pu_low OR devpor);
    input_dffe_apreset <= in_reg_apreset AND 
                          ((NOT input_reg_pu_low) OR devpor);

    inreg_D_mux : cyclone_mux21
                  port map (
                           A => padio,
                           B => inreg_sreset,
                           S => inreg_mux_sel,
                           MO=> inreg_D
                           );

    input_reg : cyclone_dffe
                port map (
                         D => inreg_D,
                         CLRN => input_dffe_aclr,
                         PRN => input_dffe_apreset,
                         CLK => inclk,
                         ENA => inclkena,
                         Q => tmp_input_reg_out
                         );

    -- output register
    outreg_mux_sel <= isreset AND outreg_sreset_is_used;
    output_dffe_aclr <= out_reg_aclr AND devclrn AND 
                        (output_reg_pu_low OR devpor);
    output_dffe_apreset <= out_reg_apreset AND 
                           ((NOT output_reg_pu_low) OR devpor);

    outreg_D_mux : cyclone_mux21
                   port map (
                            A => datain,
                            B => outreg_sreset,
                            S => outreg_mux_sel,
                            MO=> outreg_D
                            );

    output_reg : cyclone_dffe
                 port map (
                          D => outreg_D,
                          CLRN => output_dffe_aclr,
                          PRN => output_dffe_apreset,
                          CLK => outclk,
                          ENA => out_reg_clk_ena,
                          Q => tmp_output_reg_out
                          );

    -- oe register
    oereg_mux_sel <= isreset AND oereg_sreset_is_used;
    oe_dffe_aclr <= oe_reg_aclr AND devclrn AND 
                    (oe_reg_pu_low OR devpor);
    oe_dffe_apreset <= oe_reg_apreset AND 
                       ((NOT oe_reg_pu_low) OR devpor);

    oereg_D_mux : cyclone_mux21
                  port map (
                           A => oe,
                           B => oereg_sreset,
                           S => oereg_mux_sel,
                           MO=> oereg_D
                           );

    oe_reg : cyclone_dffe
             port map (
                      D => oereg_D,
                      CLRN => oe_dffe_aclr,
                      PRN => oe_dffe_apreset,
                      CLK => outclk,
                      ENA => oe_reg_clk_ena,
                      Q => tmp_oe_reg_out
                      );

    -- asynchrous block
    tmp_oe <= tmp_oe_reg_out WHEN oe_reg_sel = '1' ELSE oe;
    tmp_datain <= tmp_output_reg_out WHEN (is_bidir_or_output = '1' AND
                                           out_reg_sel = '1') 
                                     ELSE datain;

    asynch_inst : cyclone_asynch_io
                  generic map (
                              OPERATION_MODE => operation_mode, 
                              OPEN_DRAIN_OUTPUT => open_drain_output, 
                              BUS_HOLD => bus_hold
                              )
                   port map (
                            datain => tmp_datain,
                            oe => tmp_oe,
                            regin => tmp_input_reg_out,
                            padio => padio,
                            combout => combout,
                            regout => regout
                            );

end structure;

-------------------------------------------------------------------
--
-- Entity Name : cyclone_asmiblock
--
-- Description : Cyclone ASMIBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.cyclone_atom_pack.all;

entity  cyclone_asmiblock is
	 generic (
					lpm_type	: string := "cyclone_asmiblock"
				);	
    port (dclkin : in std_logic; 
    		 scein : in std_logic; 
    		 sdoin : in std_logic; 
    		 oe : in std_logic; 
          data0out: out std_logic);
end cyclone_asmiblock;

architecture architecture_asmiblock of cyclone_asmiblock is
begin

process(dclkin, scein, sdoin, oe)
begin

end process;

end architecture_asmiblock;  -- end of cyclone_asmiblock
