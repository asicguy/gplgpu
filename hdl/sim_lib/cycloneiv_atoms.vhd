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

package cycloneiv_atom_pack is

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
    TYPE cycloneiv_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

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

end cycloneiv_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body cycloneiv_atom_pack is

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

end cycloneiv_atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package cycloneiv_pllpack is


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

end cycloneiv_pllpack;

package body cycloneiv_pllpack is


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

end cycloneiv_pllpack;

--
--
--  DFFE Model
--
--

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

entity cycloneiv_dffe is
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
    attribute VITAL_LEVEL0 of cycloneiv_dffe : entity is TRUE;
end cycloneiv_dffe;

-- architecture body --

architecture behave of cycloneiv_dffe is
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
--  cycloneiv_mux21 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.cycloneiv_atom_pack.all;

entity cycloneiv_mux21 is
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
    attribute VITAL_LEVEL0 of cycloneiv_mux21 : entity is TRUE;
end cycloneiv_mux21;

architecture AltVITAL of cycloneiv_mux21 is
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
--  cycloneiv_mux41 Model
--
--

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use work.cycloneiv_atom_pack.all;

entity cycloneiv_mux41 is
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
    attribute VITAL_LEVEL0 of cycloneiv_mux41 : entity is TRUE;
end cycloneiv_mux41;

architecture AltVITAL of cycloneiv_mux41 is
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
--  cycloneiv_and1 Model
--
--
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.cycloneiv_atom_pack.all;

-- entity declaration --
entity cycloneiv_and1 is
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
    attribute VITAL_LEVEL0 of cycloneiv_and1 : entity is TRUE;
end cycloneiv_and1;

-- architecture body --

architecture AltVITAL of cycloneiv_and1 is
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
---------------------------------------------------------------------
--
-- Entity Name :  cycloneiv_lcell_comb
-- 
-- Description :  Cyclone II LCELL_COMB VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

entity cycloneiv_lcell_comb is
    generic (
             lut_mask : std_logic_vector(15 downto 0) := (OTHERS => '1');
             sum_lutc_input : string := "datac";
              dont_touch : string := "off";
             lpm_type : string := "cycloneiv_lcell_comb";
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
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01
            );
    
    port (
          dataa : in std_logic := '1';
          datab : in std_logic := '1';
          datac : in std_logic := '1';
          datad : in std_logic := '1';
          cin : in std_logic := '0';
          combout : out std_logic;
          cout : out std_logic
         );
   attribute VITAL_LEVEL0 of cycloneiv_lcell_comb : entity is TRUE;
end cycloneiv_lcell_comb;
        
architecture vital_lcell_comb of cycloneiv_lcell_comb is
    attribute VITAL_LEVEL0 of vital_lcell_comb : architecture is TRUE;
    signal dataa_ipd : std_logic;
    signal datab_ipd : std_logic;
    signal datac_ipd : std_logic;
    signal datad_ipd : std_logic;
    signal cin_ipd : std_logic;
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
    end block;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd,
                      cin_ipd)

variable combout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
-- output variables
variable combout_tmp : std_logic;
variable cout_tmp : std_logic;

begin
  
    -- lut_mask_var := lut_mask;

    ------------------------
    --  Timing Check Section
    ------------------------

    if (sum_lutc_input = "datac") then
        -- combout 
        combout_tmp := VitalMUX(data => lut_mask,
                                dselect => (datad_ipd,
                                            datac_ipd,
                                            datab_ipd,
                                            dataa_ipd));
    elsif (sum_lutc_input = "cin") then
        -- combout 
        combout_tmp := VitalMUX(data => lut_mask,
                                dselect => (datad_ipd,
                                            cin_ipd,
                                            datab_ipd,
                                            dataa_ipd));
    end if;

    -- cout 
    cout_tmp := VitalMUX(data => lut_mask,
                         dselect => ('0',
                                     cin_ipd,
                                     datab_ipd,
                                     dataa_ipd));

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
                  4 => (cin_ipd'last_event, tpd_cin_combout, TRUE)),
        GlitchData => combout_VitalGlitchData,
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
                  4 => (cin_ipd'last_event, tpd_cin_cout, TRUE)),
        GlitchData => cout_VitalGlitchData,
        Mode => DefGlitchMode,
        XOn  => XOn,
        MsgOn => MsgOn );

end process;

end vital_lcell_comb;	


---------------------------------------------------------------------
--
-- Entity Name :  cycloneiv_routing_wire
--
-- Description :  Cyclone IV GX Routing Wire VHDL simulation model
--
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_routing_wire is
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
   attribute VITAL_LEVEL0 of cycloneiv_routing_wire : entity is TRUE;
end cycloneiv_routing_wire;

ARCHITECTURE behave of cycloneiv_routing_wire is
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
---------------------------------------------------------------------
--
-- Entity Name :  cycloneiv_ff
-- 
-- Description :  Cyclone IV GX FF VHDL simulation model
--  
--
---------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;
use work.cycloneiv_and1;

entity cycloneiv_ff is
    generic (
             power_up : string := "low";
             x_on_violation : string := "on";
             lpm_type : string := "cycloneiv_ff";
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
   attribute VITAL_LEVEL0 of cycloneiv_ff : entity is TRUE;
end cycloneiv_ff;
        
architecture vital_lcell_ff of cycloneiv_ff is
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

component cycloneiv_and1
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

ddelaybuffer: cycloneiv_and1
                   port map(IN1 => d_ipd,
                            Y => d_dly);

asdatadelaybuffer: cycloneiv_and1
                   port map(IN1 => asdata_ipd,
                            Y => asdata_dly);

asdatadelaybuffer1: cycloneiv_and1
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

----------------------------------------------------------------------------
-- Module Name     : cycloneiv_ram_register
-- Description     : Register module for RAM inputs/outputs
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_ram_register IS

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

END cycloneiv_ram_register;

ARCHITECTURE reg_arch OF cycloneiv_ram_register IS

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
-- Module Name     : cycloneiv_ram_pulse_generator
-- Description     : Generate pulse to initiate memory read/write operations
----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_ram_pulse_generator IS
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
ATTRIBUTE VITAL_Level0 OF cycloneiv_ram_pulse_generator:ENTITY IS TRUE;
END cycloneiv_ram_pulse_generator;

ARCHITECTURE pgen_arch OF cycloneiv_ram_pulse_generator IS
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
USE work.cycloneiv_atom_pack.all;
USE work.cycloneiv_ram_register;
USE work.cycloneiv_ram_pulse_generator;

ENTITY cycloneiv_ram_block IS
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
        safe_write : STRING := "err_on_2clk";  
        init_file_restructured : STRING := "unused";  
        lpm_type                  : string := "cycloneiv_ram_block";
        lpm_hint                  : string := "true";
        clk0_input_clock_enable  : STRING := "none"; -- ena0,ena2,none
        clk0_core_clock_enable   : STRING := "none"; -- ena0,ena2,none
        clk0_output_clock_enable : STRING := "none"; -- ena0,none
        clk1_input_clock_enable  : STRING := "none"; -- ena1,ena3,none
        clk1_core_clock_enable   : STRING := "none"; -- ena1,ena3,none
        clk1_output_clock_enable : STRING := "none"; -- ena1,none
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        mem_init2 : BIT_VECTOR := X"0";
        mem_init3 : BIT_VECTOR := X"0";
        mem_init4 : BIT_VECTOR := X"0";
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
        portadataout            : OUT STD_LOGIC_VECTOR(port_a_data_width - 1 DOWNTO 0);   
        portbdataout            : OUT STD_LOGIC_VECTOR(port_b_data_width - 1 DOWNTO 0)
        );

END cycloneiv_ram_block;

ARCHITECTURE block_arch OF cycloneiv_ram_block IS

COMPONENT cycloneiv_ram_pulse_generator
    PORT (
          clk                     : IN  STD_LOGIC;
          ena                     : IN  STD_LOGIC;
          delaywrite          : IN STD_LOGIC := '0';
          pulse                   : OUT STD_LOGIC;
          cycle                   : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT cycloneiv_ram_register
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
 SIGNAL dataout_a_clr_reg_latch, dataout_b_clr_reg_latch : STD_LOGIC;
 SIGNAL dataout_a_clr_reg_latch_in, dataout_b_clr_reg_latch_in : one_bit_bus_type;
 SIGNAL dataout_a_clr_reg_latch_out, dataout_b_clr_reg_latch_out : one_bit_bus_type;


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
     delay_write_pulse_a <= '1' WHEN (hw_write_mode_a /= " FW") ELSE '0';
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
    
     dataout_a_clr_reg   <= '0' WHEN (port_a_data_out_clear = "none" OR port_a_data_out_clear = "UNUSED")   ELSE 
                            clr0 WHEN (port_a_data_out_clear = "clear0") ELSE clr1;
     dataout_a_clr <= dataout_a_clr_reg WHEN (port_a_data_out_clock = "none" OR port_a_data_out_clock = "UNUSED") ELSE
                      '0';
    
     dataout_b_clr_reg   <= '0' WHEN (port_b_data_out_clear = "none" OR port_b_data_out_clear = "UNUSED")   ELSE 
                            clr0 WHEN (port_b_data_out_clear = "clear0") ELSE clr1;
     dataout_b_clr <= dataout_b_clr_reg WHEN (port_b_data_out_clock = "none" OR port_b_data_out_clock = "UNUSED") ELSE
                      '0';
                      
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
    active_core_port_a : cycloneiv_ram_register
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
    active_core_port_b : cycloneiv_ram_register
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
    we_a_register : cycloneiv_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => we_a_reg_in,
            clk => clk_a_wena,
            aclr => we_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
             stall => wire_gnd,
             ena => active_a_in,
            q   => we_a_reg_out,
            aclrout => we_a_clr
        );
    we_a_reg <= we_a_reg_out(0);
    -- read enable
    re_a_reg_in(0) <= portare;
    re_a_register : cycloneiv_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => re_a_reg_in,
            clk => clk_a_rena,
            aclr => re_a_clr_in,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
         ena => active_a_in,
            q   => re_a_reg_out,
            aclrout => re_a_clr
        );
    re_a_reg <= re_a_reg_out(0);
    
    -- address
    addr_a_register : cycloneiv_ram_register
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
    datain_a_register : cycloneiv_ram_register
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
    byteena_a_register : cycloneiv_ram_register
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
    re_b_register : cycloneiv_ram_register
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
         ena => active_b_in,
            q   => re_b_reg_out,
            aclrout => re_b_clr
        );
    re_b_reg <= re_b_reg_out(0);
    
    -- write enable
    we_b_reg_in(0) <= portbwe;
    we_b_register : cycloneiv_ram_register
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
         ena => active_b_in,
            q   => we_b_reg_out,
            aclrout => we_b_clr
        );
    we_b_reg <= we_b_reg_out(0);
    
    -- address
    addr_b_register : cycloneiv_ram_register
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
    datain_b_register : cycloneiv_ram_register
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
    byteena_b_register : cycloneiv_ram_register
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
    
    wpgen_a : cycloneiv_ram_pulse_generator 
        PORT MAP (
            clk => wpgen_a_clk,
            ena => wpgen_a_clkena,
   delaywrite => delay_write_pulse_a,
            pulse => write_pulse(primary_port_is_a),
            cycle => write_cycle_a
        );
        
    wpgen_b_clk <= clk_b_in;
    wpgen_b_clkena <= '1' WHEN (active_b_core AND active_write_b AND mode_is_bdp AND (we_b_reg = '1')) ELSE '0';
    
    
    wpgen_b : cycloneiv_ram_pulse_generator
        PORT MAP (
            clk => wpgen_b_clk,
            ena => wpgen_b_clkena,
   delaywrite => delay_write_pulse_b,
            pulse => write_pulse(primary_port_is_b),
            cycle => write_cycle_b
            );
            
    -- Read  pulse generation
     rpgen_a_clkena <= '1' WHEN (active_a_core AND (re_a_reg = '1') AND (we_a_reg = '0') AND (dataout_a_clr = '0')) ELSE '0';
    
    rpgen_a : cycloneiv_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => rpgen_a_clkena,
            cycle => clk_a_core,
            pulse => read_pulse(primary_port_is_a)
        );
     rpgen_b_clkena <= '1' WHEN ((mode_is_dp OR mode_is_bdp) AND active_b_core AND (re_b_reg = '1') AND (we_b_reg = '0') AND (dataout_b_clr = '0')) ELSE '0'; 
    rpgen_b : cycloneiv_ram_pulse_generator
        PORT MAP (
            clk => clk_b_in,
            ena => rpgen_b_clkena,
            cycle => clk_b_core,
            pulse => read_pulse(primary_port_is_b)
        );
    
    -- Read-during-Write pulse generation
     rwpgen_a_clkena <= '1' WHEN (active_a_core AND (re_a_reg = '1') AND (we_a_reg = '1') AND read_before_write_a AND (dataout_a_clr = '0')) ELSE '0';
    rwpgen_a : cycloneiv_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => rwpgen_a_clkena,
            pulse => rw_pulse(primary_port_is_a)
        );
    
     rwpgen_b_clkena <= '1' WHEN (active_b_core AND mode_is_bdp AND (re_b_reg = '1') AND (we_b_reg = '1') AND read_before_write_b AND (dataout_b_clr = '0')) ELSE '0';
    rwpgen_b : cycloneiv_ram_pulse_generator
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
                       dataout_a_clr, dataout_b_clr,
                      mem_invalidate,mem_invalidate_loc,read_latch_invalidate)
    -- mem init
    TYPE rw_type IS ARRAY (port_type'HIGH DOWNTO port_type'LOW) OF BOOLEAN;
    VARIABLE addr_range_init,row,col,index :  INTEGER;
    VARIABLE mem_init_std :  STD_LOGIC_VECTOR((port_a_last_address - port_a_first_address + 1)*port_a_data_width - 1 DOWNTO 0);
    VARIABLE mem_init :  bit_vector(mem_init4'length + mem_init3'length + mem_init2'length + mem_init1'length + mem_init0'length - 1 DOWNTO 0);

    VARIABLE mem_val : mem_type; 
    -- read/write
    VARIABLE mem_data_p : mem_row_type;
    VARIABLE old_mem_data_p : mem_row_type;
    VARIABLE row_prime,col_prime  : INTEGER;
    VARIABLE access_same_location : BOOLEAN;
    VARIABLE read_during_write    : rw_type;
    BEGIN
     -- Latch Clear
         IF (dataout_a_clr'EVENT AND dataout_a_clr = '1') THEN
             IF (primary_port_is_a) THEN
                 read_latch.prime <= (OTHERS => (OTHERS => '0'));
                 dataout_prime <= (OTHERS => '0');
             ELSE
                 read_latch.sec   <= (OTHERS => '0');
                 dataout_sec <= (OTHERS => '0');
             END IF;
         END IF;

         IF (dataout_b_clr'EVENT AND dataout_b_clr = '1') THEN
             IF (primary_port_is_b) THEN
                 read_latch.prime <= (OTHERS => (OTHERS => '0'));
                 dataout_prime <= (OTHERS => '0');
             ELSE
                 read_latch.sec   <= (OTHERS => '0');
                 dataout_sec <= (OTHERS => '0');
             END IF;
         END IF;
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
                 mem_init := mem_init4 & mem_init3 & mem_init2 & mem_init1 & mem_init0;
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
 ftpgen_a_clkena <= '1' WHEN (active_a_core AND (NOT mode_is_dp) AND (NOT old_data_write_a) AND (we_a_reg = '1') AND (re_a_reg = '1') AND (dataout_a_clr = '0')) ELSE '0';
    ftpgen_a : cycloneiv_ram_pulse_generator
        PORT MAP (
            clk => clk_a_in,
            ena => ftpgen_a_clkena,
            pulse => read_pulse_feedthru(primary_port_is_a)
        );
    ftpgen_b_clkena <= '1' WHEN (active_b_core AND mode_is_bdp AND (NOT old_data_write_b) AND (we_b_reg = '1') AND (re_b_reg = '1') AND (dataout_b_clr = '0')) ELSE '0';

    ftpgen_b : cycloneiv_ram_pulse_generator
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
           ELSIF (active_a_core AND re_a_reg = '1' AND dataout_a_clr = '0' AND dataout_a_clr_reg_latch = '0') THEN
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
           ELSIF ((mode_is_dp OR mode_is_bdp) AND active_b_core AND re_b_reg = '1' AND dataout_b_clr = '0' AND dataout_b_clr_reg_latch = '0') THEN
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
     dataout_a_clr_reg_latch_in(0) <= dataout_a_clr;
     aclr_a_mux_register : cycloneiv_ram_register
         GENERIC MAP ( width => 1 )
         PORT MAP (
            d => dataout_a_clr_reg_latch_in,
            clk => clk_a_core,
            aclr => wire_gnd,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => wire_vcc,
            q   => dataout_a_clr_reg_latch_out
        );
     dataout_a_clr_reg_latch <= dataout_a_clr_reg_latch_out(0);
    
     -- Port B output register clear
     dataout_b_clr_reg_latch_in(0) <= dataout_b_clr;
     aclr_b_mux_register : cycloneiv_ram_register
        GENERIC MAP ( width => 1 )
        PORT MAP (
            d => dataout_b_clr_reg_latch_in,
            clk => clk_b_core,
            aclr => wire_gnd,
            devclrn => devclrn,
            devpor => devpor,
            stall => wire_gnd,
            ena => wire_vcc,
            q   => dataout_b_clr_reg_latch_out
        );
     dataout_b_clr_reg_latch <= dataout_b_clr_reg_latch_out(0);
    
    -- ------ Output registers
    
    
    clkena_out_c0 <= '1'  WHEN (clk0_output_clock_enable = "none") ELSE ena0;
    clkena_out_c1 <= '1'  WHEN (clk1_output_clock_enable = "none") ELSE ena1;
    clkena_a_out    <= clkena_out_c0 WHEN (port_a_data_out_clock = "clock0") ELSE clkena_out_c1;
    clkena_b_out    <= clkena_out_c0 WHEN (port_b_data_out_clock = "clock0") ELSE clkena_out_c1;
    
    dataout_a <= dataout_prime WHEN primary_port_is_a ELSE dataout_sec;
    dataout_b <= (OTHERS => 'U') WHEN (mode_is_rom OR mode_is_sp) ELSE 
                 dataout_prime   WHEN primary_port_is_b ELSE dataout_sec;
    
    dataout_a_register : cycloneiv_ram_register
        GENERIC MAP ( width => port_a_data_width )
        PORT MAP (
            d => dataout_a,
            clk => clk_a_out,
                     aclr => dataout_a_clr_reg,
            devclrn => devclrn,
            devpor => devpor,
             stall => wire_gnd,
            ena => clkena_a_out,
            q => dataout_a_reg
        );
        
    dataout_b_register : cycloneiv_ram_register
        GENERIC MAP ( width => port_b_data_width )
        PORT MAP (
            d => dataout_b,
            clk => clk_b_out,
                     aclr => dataout_b_clr_reg,
            devclrn => devclrn,
            devpor => devpor,
             stall => wire_gnd,
            ena => clkena_b_out,
            q => dataout_b_reg
        );
        
    portadataout <= dataout_a_reg WHEN out_a_is_reg ELSE dataout_a;
    portbdataout <= dataout_b_reg WHEN out_b_is_reg ELSE dataout_b;
    

END block_arch;


-----------------------------------------------------------------------
--
-- Module Name : cycloneiv_mac_data_reg
--
-- Description : Simulation model for the data input register of 
--               Cyclone II MAC_MULT
--
-----------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_mac_data_reg IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_data : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
      		 tsetup_data_clk_noedge_posedge : VitalDelayArrayType(17 downto 0) := (OTHERS => DefSetupHoldCnst);
      		 thold_data_clk_noedge_posedge : VitalDelayArrayType(17 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      		 thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tpd_aclr_dataout_posedge : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             tpd_clk_dataout_posedge : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             data_width : integer := 18
            );    
    PORT (
          -- INPUT PORTS
          clk : IN std_logic;   
          data : IN std_logic_vector(17 DOWNTO 0);   
          ena : IN std_logic;   
          aclr : IN std_logic;   
          -- OUTPUT PORTS
          dataout : OUT std_logic_vector(17 DOWNTO 0)
         );
END cycloneiv_mac_data_reg;

ARCHITECTURE vital_cycloneiv_mac_data_reg OF cycloneiv_mac_data_reg IS

    SIGNAL data_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL aclr_ipd : std_logic;   
    SIGNAL clk_ipd : std_logic;   
    SIGNAL ena_ipd : std_logic;   
    SIGNAL dataout_tmp : std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');

BEGIN

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        g1 : for i in data'range generate
            VitalWireDelay (data_ipd(i), data(i), tipd_data(i));
        end generate;
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

        
    process (clk_ipd, aclr_ipd, data_ipd)
	begin
    if (aclr_ipd = '1') then
            dataout_tmp <= (OTHERS => '0');
        elsif (clk_ipd'event and clk_ipd = '1' and (ena_ipd = '1')) then
            dataout_tmp <= data_ipd;
        end if;

    end process;
    
    sh: block
		begin
		g0 : for i in data'range generate
    	process (data_ipd(i),clk_ipd,ena_ipd)
    variable Tviol_data_clk : std_ulogic := '0';
    variable TimingData_data_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_data_clk,
                TimingData      => TimingData_data_clk,
                TestSignal      => data_ipd(i),
                TestSignalName  => "DATA(i)",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_data_clk_noedge_posedge(i),
                SetupLow        => tsetup_data_clk_noedge_posedge(i),
                HoldHigh        => thold_data_clk_noedge_posedge(i),
                HoldLow         => thold_data_clk_noedge_posedge(i),
                CheckEnabled    => TO_X01((aclr) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
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
                CheckEnabled    => TO_X01(aclr)  /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

    END PROCESS;
    end generate g0;
    end block;

    ----------------------
    --  Path Delay Section
    ----------------------
    PathDelay : block
    begin
        g1 : for i in dataout_tmp'range generate
          VITALtiming :  process (dataout_tmp(i))
              variable dataout_VitalGlitchData : VitalGlitchDataType;
          begin
            VitalPathDelay01 (OutSignal => dataout(i),
                              OutSignalName => "DATAOUT",
                              OutTemp => dataout_tmp(i),
                              Paths => (0 => (clk_ipd'last_event,  tpd_clk_dataout_posedge(i),  TRUE),
                                        1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge(i), TRUE)),
                              GlitchData => dataout_VitalGlitchData,
                              Mode => DefGlitchMode,
                              XOn  => XOn,
                              MsgOn  => MsgOn);                  
          end process;
        end generate;
    end block;

END vital_cycloneiv_mac_data_reg;

--------------------------------------------------------------------
--
-- Module Name : cycloneiv_mac_sign_reg
--
-- Description : Simulation model for the sign input register of 
--               Cyclone II MAC_MULT
--
--------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_mac_sign_reg IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aclr_q_posedge : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          -- INPUT PORTS
          clk : IN std_logic;   
          d : IN std_logic;   
          ena : IN std_logic;   
          aclr : IN std_logic;   

          -- OUTPUT PORTS
          q : OUT std_logic
         );   
END cycloneiv_mac_sign_reg;

ARCHITECTURE cycloneiv_mac_sign_reg OF cycloneiv_mac_sign_reg IS

    signal d_ipd : std_logic;
    signal clk_ipd : std_logic;
    signal aclr_ipd : std_logic;
    signal ena_ipd : std_logic;
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (d_ipd, d, tipd_d);
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming :  process (clk_ipd, aclr_ipd)
    variable Tviol_d_clk : std_ulogic := '0';
    variable TimingData_d_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable q_VitalGlitchData : VitalGlitchDataType;
    variable q_reg : std_logic := '0';
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
                CheckEnabled    => TO_X01((aclr) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/SIGN_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01(aclr) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/SIGN_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if (aclr_ipd = '1') then
            q_reg := '0';
        elsif (clk_ipd'event and clk_ipd = '1' and (ena_ipd = '1')) then
            q_reg := d_ipd;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => q,
            OutSignalName => "Q",
            OutTemp => q_reg,
            Paths => (0 => (clk_ipd'last_event, tpd_clk_q_posedge, TRUE),
                      1 => (aclr_ipd'last_event, tpd_aclr_q_posedge, TRUE)),
            GlitchData => q_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );
    end process;
END cycloneiv_mac_sign_reg;

--------------------------------------------------------------------
--
-- Module Name : cycloneiv_mac_mult_internal
--
-- Description : Cyclone II MAC_MULT_INTERNAL VHDL simulation model 
--
--------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_mac_mult_internal IS
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_dataa : VitalDelayArrayType01(17 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_datab : VitalDelayArrayType01(17 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_signa : VitalDelayType01 := DefPropDelay01;
             tipd_signb : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_dataout : VitalDelayArrayType01(18*36 -1 downto 0) :=(others => DefPropDelay01);
             tpd_datab_dataout : VitalDelayArrayType01(18*36 -1 downto 0) :=(others => DefPropDelay01);
             tpd_signa_dataout : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
             tpd_signb_dataout : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
             dataa_width : integer := 18;    
             datab_width : integer := 18
            );
    PORT (
          dataa : IN std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
          datab : IN std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
          signa : IN std_logic := '1';
          signb : IN std_logic := '1';
          dataout : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0)
         );   
END cycloneiv_mac_mult_internal;

ARCHITECTURE vital_cycloneiv_mac_mult_internal OF cycloneiv_mac_mult_internal IS

    -- Internal variables
    SIGNAL dataa_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL datab_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL signa_ipd : std_logic;   
    SIGNAL signb_ipd : std_logic;   

    --  padding with 1's for input negation
    SIGNAL reg_aclr : std_logic;   
    SIGNAL dataout_tmp : STD_LOGIC_VECTOR (dataa_width + datab_width downto 0) := (others => '0');

BEGIN

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        g1 : for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
        end generate;
        g2 : for i in datab'range generate
            VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
        end generate;

        VitalWireDelay (signa_ipd, signa, tipd_signa);
        VitalWireDelay (signb_ipd, signb, tipd_signb);
    end block;


    VITALtiming : process(dataa_ipd, datab_ipd, signa_ipd, signb_ipd)
    begin
        if((signa_ipd = '0') and (signb_ipd = '1')) then
            dataout_tmp <= 
                unsigned(dataa_ipd(dataa_width-1 downto 0)) * 
                signed(datab_ipd(datab_width-1 downto 0));
        elsif((signa_ipd = '1') and (signb_ipd = '0')) then
            dataout_tmp <= 
                signed(dataa_ipd(dataa_width-1 downto 0)) * 
                unsigned(datab_ipd(datab_width-1 downto 0));
        elsif((signa_ipd = '1') and (signb_ipd = '1')) then
            dataout_tmp(dataout'range) <= 
                signed(dataa_ipd(dataa_width-1 downto 0)) * 
                signed(datab_ipd(datab_width-1 downto 0));
        else --((signa_ipd = '0') and (signb_ipd = '0')) then
            dataout_tmp(dataout'range) <=
                unsigned(dataa_ipd(dataa_width-1 downto 0)) * 
                unsigned(datab_ipd(datab_width-1 downto 0));
        end if;
    end process;

    ----------------------
    --  Path Delay Section
    ----------------------
    PathDelay : block
    begin
        g1 : for i in dataout'range generate
          VITALtiming :  process (dataout_tmp(i))
              variable dataout_VitalGlitchData : VitalGlitchDataType;
          begin
              VitalPathDelay01 (OutSignal => dataout(i),
                                OutSignalName => "dataout",
                                OutTemp => dataout_tmp(i),
                                Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout(i), TRUE),
                                          1 => (datab_ipd'last_event, tpd_datab_dataout(i), TRUE),
                                          2 => (signa'last_event, tpd_signa_dataout(i), TRUE),
                                          3 => (signb'last_event, tpd_signb_dataout(i), TRUE)),
                                GlitchData => dataout_VitalGlitchData,
                                Mode => DefGlitchMode,
                                MsgOn => FALSE,
                                XOn  => TRUE );
          end process;
        end generate;
    end block;

END vital_cycloneiv_mac_mult_internal;

--------------------------------------------------------------------
--
-- Module Name : cycloneiv_mac_mult
--
-- Description : Cyclone II MAC_MULT VHDL simulation model 
--
--------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE work.cycloneiv_atom_pack.all;
USE work.cycloneiv_mac_data_reg;
USE work.cycloneiv_mac_sign_reg;
USE work.cycloneiv_mac_mult_internal;

ENTITY cycloneiv_mac_mult IS
    GENERIC (
             dataa_width : integer := 18;    
             datab_width : integer := 18;
             dataa_clock : string := "none";    
             datab_clock : string := "none";    
             signa_clock : string := "none";    
             signb_clock : string := "none";    
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneiv_mac_mult"
            );
    PORT (
          dataa : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (OTHERS => '0');
          datab : IN std_logic_vector(datab_width-1 DOWNTO 0) := (OTHERS => '0');
          signa : IN std_logic := '1';
          signb : IN std_logic := '1';
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '0';
          dataout : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
END cycloneiv_mac_mult;

ARCHITECTURE vital_cycloneiv_mac_mult OF cycloneiv_mac_mult IS

    COMPONENT cycloneiv_mac_data_reg
        GENERIC (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tipd_data : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
                 tipd_clk : VitalDelayType01 := DefPropDelay01;
                 tipd_ena : VitalDelayType01 := DefPropDelay01;
                 tipd_aclr : VitalDelayType01 := DefPropDelay01;
      		 tsetup_data_clk_noedge_posedge : VitalDelayArrayType(17 downto 0) := (OTHERS => DefSetupHoldCnst);
      		 thold_data_clk_noedge_posedge : VitalDelayArrayType(17 downto 0) := (OTHERS => DefSetupHoldCnst);
                 tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      		 thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tpd_aclr_dataout_posedge : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
             tpd_clk_dataout_posedge : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
                 data_width : integer := 18
                );    
        PORT (
              -- INPUT PORTS
              clk : IN std_logic;   
              data : IN std_logic_vector(17 DOWNTO 0);   
              ena : IN std_logic;   
              aclr : IN std_logic;   
              -- OUTPUT PORTS
              dataout : OUT std_logic_vector(17 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT cycloneiv_mac_sign_reg
        GENERIC (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                 thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
                 tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
                 tpd_aclr_q_posedge : VitalDelayType01 := DefPropDelay01;
                 tipd_d : VitalDelayType01 := DefPropDelay01;
                 tipd_ena : VitalDelayType01 := DefPropDelay01;
                 tipd_aclr : VitalDelayType01 := DefPropDelay01;
                 tipd_clk : VitalDelayType01 := DefPropDelay01
                );
        PORT (
              -- INPUT PORTS
              clk : IN std_logic;   
              d : IN std_logic;   
              ena : IN std_logic;   
              aclr : IN std_logic;   
    
              -- OUTPUT PORTS
              q : OUT std_logic
             );   
    END COMPONENT;

    COMPONENT cycloneiv_mac_mult_internal 
        GENERIC (
                 TimingChecksOn : Boolean := True;
                 MsgOn : Boolean := DefGlitchMsgOn;
                 XOn : Boolean := DefGlitchXOn;
                 MsgOnChecks : Boolean := DefMsgOnChecks;
                 XOnChecks : Boolean := DefXOnChecks;
                 InstancePath : STRING := "*";
                 tipd_dataa : VitalDelayArrayType01(17 downto 0)
                                       := (OTHERS => DefPropDelay01);
                 tipd_datab : VitalDelayArrayType01(17 downto 0)
                                       := (OTHERS => DefPropDelay01);
                 tipd_signa : VitalDelayType01 := DefPropDelay01;
                 tipd_signb : VitalDelayType01 := DefPropDelay01;
             	tpd_dataa_dataout : VitalDelayArrayType01(18*36 -1 downto 0) :=(others => DefPropDelay01);
             	tpd_datab_dataout : VitalDelayArrayType01(18*36 -1 downto 0) :=(others => DefPropDelay01);
             	tpd_signa_dataout : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
             	tpd_signb_dataout : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
                 dataa_width : integer := 18;    
                 datab_width : integer := 18
                );
        PORT (
              dataa : IN std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
              datab : IN std_logic_vector(17 DOWNTO 0) := (OTHERS => '0');
              signa : IN std_logic := '1';
              signb : IN std_logic := '1';
              dataout : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0)
             );   
    END COMPONENT;

    -- Internal variables
    SIGNAL dataa_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL datab_ipd : std_logic_vector(17 DOWNTO 0);   
    SIGNAL idataa_reg : std_logic_vector(17 DOWNTO 0);   --  optional register for dataa input
    SIGNAL idatab_reg : std_logic_vector(17 DOWNTO 0);   --  optional register for datab input
    SIGNAL isigna_reg : std_logic;   --  optional register for signa input
    SIGNAL isignb_reg : std_logic;   --  optional register for signb input
    SIGNAL idataa_int : std_logic_vector(17 DOWNTO 0);   --  dataa as seen by the multiplier input
    SIGNAL idatab_int : std_logic_vector(17 DOWNTO 0);   --  datab as seen by the multiplier input
    SIGNAL isigna_int : std_logic;   --  signa as seen by the multiplier input
    SIGNAL isignb_int : std_logic;   --  signb as seen by the multiplier input
    --  padding with 1's for input negation
    SIGNAL reg_aclr : std_logic;   
    SIGNAL dataout_tmp : STD_LOGIC_VECTOR (dataa_width + datab_width downto 0) := (others => '0');

BEGIN

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------

    reg_aclr <= (NOT devpor) OR (NOT devclrn) OR (aclr) ;

    -- padding input data to full bus width
    dataa_ipd(dataa_width-1 downto 0) <= dataa;
    datab_ipd(datab_width-1 downto 0) <= datab;

    -- Optional input registers for dataa,b and signa,b
    dataa_reg : cycloneiv_mac_data_reg 
        GENERIC MAP (
            data_width => dataa_width)
        PORT MAP (
            clk => clk,
            data => dataa_ipd,
            ena => ena,
            aclr => reg_aclr,
            dataout => idataa_reg);   
    
    datab_reg : cycloneiv_mac_data_reg 
        GENERIC MAP (
            data_width => datab_width)
        PORT MAP (
            clk => clk,
            data => datab_ipd,
            ena => ena,
            aclr => reg_aclr,
            dataout => idatab_reg);   
    
    signa_reg : cycloneiv_mac_sign_reg 
        PORT MAP (
            clk => clk,
            d => signa,
            ena => ena,
            aclr => reg_aclr,
            q => isigna_reg);   
    
    signb_reg : cycloneiv_mac_sign_reg 
        PORT MAP (
            clk => clk,
            d => signb,
            ena => ena,
            aclr => reg_aclr,
            q => isignb_reg);   
    
    idataa_int <= dataa_ipd WHEN (dataa_clock = "none") ELSE idataa_reg;
    idatab_int <= datab_ipd WHEN (datab_clock = "none") ELSE idatab_reg;
    isigna_int <= signa WHEN (signa_clock = "none") ELSE isigna_reg;
    isignb_int <= signb WHEN (signb_clock = "none") ELSE isignb_reg;

    mac_multiply : cycloneiv_mac_mult_internal
        GENERIC MAP (
             dataa_width => dataa_width,
             datab_width => datab_width
            )
        PORT MAP (
              dataa => idataa_int, 
              datab => idatab_int,
              signa => isigna_int,
              signb => isignb_int,
              dataout => dataout
             );   
END vital_cycloneiv_mac_mult;

--------------------------------------------------------------------
--
-- Module Name : cycloneiv_mac_out
--
-- Description : Cyclone II MAC_OUT VHDL simulation model 
--
--------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.std_logic_1164.all;
USE work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_mac_out IS
    GENERIC (
             dataa_width : integer := 1;
             output_clock : string := "none";    
			 TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_dataa : VitalDelayArrayType01(35 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_dataout :VitalDelayArrayType01(36*36 -1 downto 0) :=(others => DefPropDelay01);
             tpd_aclr_dataout_posedge : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
             tpd_clk_dataout_posedge :VitalDelayArrayType01(35  downto 0) :=(others => DefPropDelay01);
             tsetup_dataa_clk_noedge_posedge : VitalDelayArrayType(35 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_dataa_clk_noedge_posedge :  VitalDelayArrayType(35 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneiv_mac_out");    
    PORT (
          dataa : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (OTHERS => '0');
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector(dataa_width-1 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
END cycloneiv_mac_out;

ARCHITECTURE vital_cycloneiv_mac_out OF cycloneiv_mac_out IS

    --  internal variables
    SIGNAL dataa_ipd : std_logic_vector(dataa'range);
    SIGNAL clk_ipd : std_logic;
    SIGNAL aclr_ipd : std_logic;
    SIGNAL ena_ipd : std_logic;

    --  optional register
    SIGNAL use_reg : std_logic;

    SIGNAL dataout_tmp : std_logic_vector(dataout'range) := (OTHERS => '0');

BEGIN

    ---------------------
    -- PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        g1 : for i in dataa'range generate
            VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
            VITALtiming :  process (clk_ipd, aclr_ipd, dataout_tmp(i))
              variable dataout_VitalGlitchData : VitalGlitchDataType;
              begin
                VitalPathDelay01 (
                  OutSignal => dataout(i),
                  OutSignalName => "DATAOUT",
                  OutTemp => dataout_tmp(i),
                  Paths => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge(i), use_reg = '1'),
                            1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge(i), use_reg = '1'),
                            2 => (dataa_ipd(i)'last_event, tpd_dataa_dataout(i), use_reg = '0')),
                  GlitchData => dataout_VitalGlitchData,
                  Mode => DefGlitchMode,
                  XOn  => XOn,
                  MsgOn  => MsgOn );
              end process;
        end generate;

        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        
    end block;

    use_reg <= '1' WHEN (output_clock /= "none") ELSE '0';
    
    sh: block
	begin
	g0 : for i in dataa'range generate
    VITALtiming :  process (clk_ipd, ena_ipd, dataa_ipd(i))
    variable Tviol_dataa_clk : std_ulogic := '0';
    variable TimingData_dataa_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena_clk : std_ulogic := '0';
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_dataa_clk,
                TimingData      => TimingData_dataa_clk,
                TestSignal      => dataa(i),
                TestSignalName  => "D",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_dataa_clk_noedge_posedge(i),
                SetupLow        => tsetup_dataa_clk_noedge_posedge(i),
                HoldHigh        => thold_dataa_clk_noedge_posedge(i),
                HoldLow         => thold_dataa_clk_noedge_posedge(i),
                CheckEnabled    => TO_X01((aclr) OR (NOT use_reg) OR
                                          (NOT ena)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr) OR 
                                          (NOT use_reg)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/MAC_DATA_REG",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;
        END PROCESS;
    end generate g0;
    end block;

    process (clk_ipd, aclr_ipd,ena_ipd, dataa_ipd)
    begin
            if (use_reg = '0') then
            dataout_tmp <= dataa_ipd;
        else
            if (aclr_ipd = '1') then
                dataout_tmp <= (OTHERS => '0');
            elsif (clk_ipd'event and clk_ipd = '1' and (ena_ipd = '1')) then
                dataout_tmp <= dataa_ipd;
            end if;
        end if;

    end process;

END vital_cycloneiv_mac_out;

    
---------------------------------------------------------------------
--
-- Entity Name :  cycloneiv_io_ibuf
-- 
-- Description :  Cyclone IV GX IO Ibuf VHDL simulation model
--  
--
---------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_io_ibuf IS
    GENERIC (
             tipd_i                  : VitalDelayType01 := DefPropDelay01;
             tipd_ibar               : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                 : VitalDelayType01 := DefPropDelay01;
             tpd_ibar_o              : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             differential_mode       :  string := "false";
             bus_hold                :  string := "false";
             simulate_z_as          : string    := "Z";
             lpm_type                :  string := "cycloneiv_io_ibuf"
            );    
    PORT (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          o                       : OUT std_logic
         );       
END cycloneiv_io_ibuf;

ARCHITECTURE arch OF cycloneiv_io_ibuf IS
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
-- Entity Name :  cycloneiv_io_obuf
-- 
-- Description :  Cyclone IV GX IO Obuf VHDL simulation model
--  
--
---------------------------------------------------------------------

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_io_obuf IS
    GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tipd_oe                          : VitalDelayType01 := DefPropDelay01;
             tipd_seriesterminationcontrol    : VitalDelayArrayType01(15 DOWNTO 0) := (others => DefPropDelay01 ); 
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_oe_o                         : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             tpd_oe_obar                      : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;  
             open_drain_output                :  string := "false";              
             bus_hold                         :  string := "false";              
             lpm_type                         :  string := "cycloneiv_io_obuf"
            );               
    PORT (
           i                       : IN std_logic := '0';                                                 
           oe                      : IN std_logic := '1';                                                 
           seriesterminationcontrol    : IN std_logic_vector(15 DOWNTO 0) := (others => '0'); 
           devoe                       : IN std_logic := '1';
           o                       : OUT std_logic;                                                       
           obar                    : OUT std_logic
         );                                                      
END cycloneiv_io_obuf;

ARCHITECTURE arch OF cycloneiv_io_obuf IS
    --INTERNAL Signals
    SIGNAL i_ipd                    : std_logic := '0'; 
    SIGNAL oe_ipd                   : std_logic := '0'; 
    SIGNAL out_tmp                  :  std_logic := 'Z';   
    SIGNAL out_tmp_bar              :  std_logic;   
    SIGNAL prev_value               :  std_logic := '0';     
    SIGNAL o_tmp                    :  std_logic;    
    SIGNAL obar_tmp                 :  std_logic;  
    SIGNAL o_tmp1                    :  std_logic;    
    SIGNAL obar_tmp1                 :  std_logic;  
    SIGNAL seriesterminationcontrol_ipd    : std_logic_vector(15 DOWNTO 0) := (others => '0'); 
 
BEGIN

WireDelay : block
    begin                                                             
        VitalWireDelay (i_ipd, i, tipd_i);          
        VitalWireDelay (oe_ipd, oe, tipd_oe); 
        g1 :for i in seriesterminationcontrol'range generate
            VitalWireDelay (seriesterminationcontrol_ipd(i), seriesterminationcontrol(i), tipd_seriesterminationcontrol(i));
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
    o_tmp <= o_tmp1 WHEN (devoe = '1') ELSE 'Z';
    obar_tmp <= obar_tmp1 WHEN (devoe = '1') ELSE 'Z';
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

---------------------------------------------------------------------      
--                                                                         
-- Entity Name :  cycloneiv_ddio_oe                                            
-- 
-- Description :  Cyclone IV GX DDIO_OE VHDL simulation model
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
use work.cycloneiv_atom_pack.all;



ENTITY cycloneiv_ddio_oe IS
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
            lpm_type              :  string := "cycloneiv_ddio_oe"
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
END cycloneiv_ddio_oe;

ARCHITECTURE arch OF cycloneiv_ddio_oe IS

component cycloneiv_mux21
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
    or_gate : cycloneiv_mux21
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
-- Entity Name :  cycloneiv_latch                                                          
--                                                                                     
-- Description :  Cyclone IV GX latch VHDL simulation model                                     
--                                                                                     
--                                                                                     
---------------------------------------------------------------------                  
                                                                                       
Library ieee;                                                                          
use ieee.std_logic_1164.all;                                                           
use IEEE.VITAL_Timing.all;                                                             
use IEEE.VITAL_Primitives.all;                                                         
use work.cycloneiv_atom_pack.all;                                                          
entity cycloneiv_latch is                                                                  
    generic(                                                                           
        is_wysiwyg : string := "false";                                                
        x_on_violation : string := "on";                                               
        lpm_type : string := "cycloneiv_latch";                                            
        tsetup_d_ena_noedge_negedge : VitalDelayType := DefSetupHoldCnst;              
        thold_d_ena_noedge_negedge : VitalDelayType := DefSetupHoldCnst;               
        tpd_d_q : VitalDelayType01 := DefPropDelay01;                                  
        tpd_ena_q_negedge : VitalDelayType01 := DefPropDelay01;                        
        tpd_clr_q_negedge : VitalDelayType01 := DefPropDelay01;                        
        tpd_pre_q_negedge : VitalDelayType01 := DefPropDelay01;                        
        tipd_d : VitalDelayType01 := DefPropDelay01;                                   
        tipd_clr : VitalDelayType01 := DefPropDelay01;                                 
        tipd_pre : VitalDelayType01 := DefPropDelay01;                                 
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
        ena : in std_logic := '1';                                                     
        clr : in std_logic := '1';                                                     
        pre : in std_logic := '1';                                                     
        q : out std_logic                                                              
    );                                                                                 
    attribute VITAL_LEVEL0 of cycloneiv_latch : entity is TRUE;                            
end cycloneiv_latch;                                                                       
                                                                                       
                                                                                       
architecture vital_latch of cycloneiv_latch is                                             
    attribute VITAL_LEVEL0 of vital_latch : architecture is TRUE;                      
    signal d_ipd : std_logic;                                                          
    signal d_dly : std_logic;                                                          
    signal clr_ipd : std_logic;                                                        
    signal pre_ipd : std_logic;                                                        
    signal ena_ipd : std_logic;                                                        
                                                                                       
begin                                                                                  
                                                                                       
    d_dly <= d_ipd;                                                                    
                                                                                       
    ---------------------                                                              
    --  INPUT PATH DELAYs                                                              
    ---------------------                                                              
    WireDelay : block                                                                  
    begin                                                                              
        VitalWireDelay (d_ipd, d, tipd_d);                                             
        VitalWireDelay (clr_ipd, clr, tipd_clr);                                       
        VitalWireDelay (pre_ipd, pre, tipd_pre);                                       
        VitalWireDelay (ena_ipd, ena, tipd_ena);                                       
    end block;                                                                         
                                                                                       
    VITALtiming : process (  d_dly,  clr_ipd, pre_ipd,ena_ipd)                         
                                                                                       
    variable Tviol_d_ena : std_ulogic := '0';                                          
    variable TimingData_d_ena : VitalTimingDataType := VitalTimingDataInit;            
    variable q_VitalGlitchData : VitalGlitchDataType;                                  
                                                                                       
    variable iq : std_logic := '0';                                                    
    variable idata: std_logic := '0';                                                  
                                                                                       
    -- variables for 'X' generation                                                    
    variable violation : std_logic := '0';                                             
                                                                                       
    begin                                                                              
                                                                                       
                                                                                       
        ------------------------                                                       
        --  Timing Check Section                                                       
        ------------------------                                                       
        if (TimingChecksOn) then                                                       
                                                                                       
            VitalSetupHoldCheck (                                                      
                Violation       => Tviol_d_ena,                                        
                TimingData      => TimingData_d_ena,                                   
                TestSignal      => d_ipd,                                              
                TestSignalName  => "DATAIN",                                           
                RefSignal       => ena_ipd,                                            
                RefSignalName   => "ENA",                                              
                SetupHigh       => tsetup_d_ena_noedge_negedge,                        
                SetupLow        => tsetup_d_ena_noedge_negedge,                        
                HoldHigh        => thold_d_ena_noedge_negedge,                         
                HoldLow         => thold_d_ena_noedge_negedge,                         
                CheckEnabled    => TRUE,                                               
                RefTransition   => '\',                                                
                HeaderMsg       => InstancePath & "/cycloneiv_latch",                      
                XOn             => XOnChecks,                                          
                MsgOn           => MsgOnChecks );                                      
                                                                                       
                                                                                       
                                                                                       
        violation := Tviol_d_ena;                                                      
                                                                                       
                                                                                       
        if ( (clr_ipd = '0'))  then                                                    
            iq := '0';                                                                 
        elsif (pre_ipd = '0') then                                                     
            iq := '1';                                                                 
        elsif (violation = 'X' and x_on_violation = "on") then                         
            iq := 'X';                                                                 
         elsif (ena_ipd = '1') then                                                    
            iq := d_dly;                                                               
         end if;                                                                       
         end if;                                                                       
                                                                                       
        ----------------------                                                         
        --  Path Delay Section                                                         
        ----------------------                                                         
        VitalPathDelay01 (                                                             
            OutSignal => q,                                                            
            OutSignalName => "Q",                                                      
            OutTemp => iq,                                                             
            Paths =>   (0 => (clr_ipd'last_event, tpd_clr_q_negedge, TRUE),            
                        1 => (pre_ipd'last_event, tpd_pre_q_negedge, TRUE),            
                        2 => (ena_ipd'last_event, tpd_ena_q_negedge, TRUE)),           
            GlitchData => q_VitalGlitchData,                                           
            Mode => DefGlitchMode,                                                     
            XOn  => XOn,                                                               
            MsgOn  => MsgOn );                                                         
                                                                                       
    end process;                                                                       
                                                                                       
end vital_latch;                                                                       
---------------------------------------------------------------------
--
-- Entity Name :  cycloneiv_ddio_out
-- 
-- Description :  Cyclone IV GX DDIO_OUT VHDL simulation model
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
use work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_ddio_out IS
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
            use_new_clocking_model             :  string := "false";
            lpm_type                           :  string := "cycloneiv_ddio_out"
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
          dffhi                   : OUT std_logic ;         
          devclrn                 : IN std_logic := '1';   
          devpor                  : IN std_logic := '1'   
        );   
END cycloneiv_ddio_out;

ARCHITECTURE arch OF cycloneiv_ddio_out IS

component cycloneiv_mux21
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
   
component cycloneiv_latch                                                                  
    generic(                                                                           
        is_wysiwyg : string := "false";                                                
        x_on_violation : string := "on";                                               
        lpm_type : string := "cycloneiv_latch";                                            
        tsetup_d_ena_noedge_negedge : VitalDelayType := DefSetupHoldCnst;              
        thold_d_ena_noedge_negedge : VitalDelayType := DefSetupHoldCnst;               
        tpd_d_q : VitalDelayType01 := DefPropDelay01;                                  
        tpd_ena_q_negedge : VitalDelayType01 := DefPropDelay01;                        
        tpd_clr_q_negedge : VitalDelayType01 := DefPropDelay01;                        
        tpd_pre_q_negedge : VitalDelayType01 := DefPropDelay01;                        
        tipd_d : VitalDelayType01 := DefPropDelay01;                                   
        tipd_clr : VitalDelayType01 := DefPropDelay01;                                 
        tipd_pre : VitalDelayType01 := DefPropDelay01;                                 
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
        ena : in std_logic := '1';                                                     
        clr : in std_logic := '1';                                                     
        pre : in std_logic := '1';                                                     
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
   Signal sel_mux_hi_in             :  std_logic;
   signal clk1                      :  std_logic;
   signal clk_hi                    :  std_logic;
   signal clk_lo                    :  std_logic;

    signal muxsel1 : std_logic;
    signal muxsel2: std_logic;
    signal clk2   : std_logic;
    signal muxsel_tmp: std_logic;
    signal sel_mux_lo_in : std_logic;
    signal datainlo_tmp : std_logic;
    signal datainhi_tmp : std_logic;
    signal dffhi_tmp1 : std_logic;    

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
    
    process(dffhi_tmp)                
        begin                          
            dffhi_tmp1 <= dffhi_tmp;   
        end process;                  
        

    --DDIO HIGH Register 
    clk_hi <= ((NOT clkhi_ipd) and ena_ipd) when(use_new_clocking_model = "true") else ((NOT clk_ipd) and ena_ipd); 
    datainhi_tmp <= '1' when (ddioreg_sclr ='0'and  ddioreg_sload = '1')else '0'when (ddioreg_sclr ='1'and  ddioreg_sload = '0') else datainhi;

       ddioreg_hi : cycloneiv_latch                         
       PORT MAP (                                       
                    d=> datainhi_tmp,                   
                    ena =>  clk_hi,                     
                    pre => ddioreg_prn,                 
                    clr => ddioreg_aclr,                
                    q => dffhi_tmp                      
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
                                                      
  
  muxsel2 <= muxsel1;
  clk2 <= clk1;
  mux_sel <= muxsel2 when(use_new_clocking_model = "true") else clk2;       
  muxsel_tmp <= NOT mux_sel;  
  sel_mux_lo_in <= dfflo_tmp;              
  sel_mux_hi_in <= dffhi_tmp1;       
  
  sel_mux : cycloneiv_mux21
        port map (
                   A => sel_mux_hi_in, 
                   B => sel_mux_lo_in, 
                   S => muxsel_tmp, 
                   MO => dataout  
                  );              

    dfflo <= dfflo_tmp;
    dffhi <= dffhi_tmp; 
END arch;
----------------------------------------------------------------------------
-- Module Name     : cycloneiv_io_pad
-- Description     : Simulation model for cycloneiv IO pad
----------------------------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

ENTITY cycloneiv_io_pad IS
    GENERIC (
        lpm_type                       :  string := "cycloneiv_io_pad");    
    PORT (
        --INPUT PORTS

        padin                   : IN std_logic := '0';   -- Input Pad
        --OUTPUT PORTS

        padout                  : OUT std_logic);   -- Output Pad
END cycloneiv_io_pad;

ARCHITECTURE arch OF cycloneiv_io_pad IS

BEGIN
    padout <= padin;    
END arch;
--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cycloneiv_ena_reg
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
use work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_ena_reg is
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
   attribute VITAL_LEVEL0 of cycloneiv_ena_reg : entity is TRUE;
end cycloneiv_ena_reg;

ARCHITECTURE behave of cycloneiv_ena_reg is
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
                HeaderMsg       => InstancePath & "/cycloneiv_ena_reg",
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
--              VHDL Simulation Model for Cyclone III CLKCTRL Atom
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  CYCLONEIV_CLKCTRL Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;
use work.cycloneiv_ena_reg;

entity cycloneiv_clkctrl is
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "cycloneiv_clkctrl";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tpd_inclk_outclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
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
   attribute VITAL_LEVEL0 of cycloneiv_clkctrl : entity is TRUE;
end cycloneiv_clkctrl;
        
architecture vital_clkctrl of cycloneiv_clkctrl is
    attribute VITAL_LEVEL0 of vital_clkctrl : architecture is TRUE;

    component cycloneiv_ena_reg
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
    signal cereg1_out : std_logic;
    signal cereg2_out : std_logic;
    signal ena_out : std_logic;
    signal outclk_tmp : std_logic;
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

    extena0_reg : cycloneiv_ena_reg
                  port map (
                            clk => clkmux_out_inv,
                            ena => vcc,
                            d => ena_ipd, 
                            clrn => vcc,
                            prn => devpor,
                            q => cereg1_out 
                           );

    extena1_reg : cycloneiv_ena_reg
                  port map (
                            clk => clkmux_out_inv,
                            ena => vcc,
                            d => cereg1_out, 
                            clrn => vcc,
                            prn => devpor,
                            q => cereg2_out 
                           );

    ena_out <= cereg1_out WHEN (ena_register_mode = "falling edge") ELSE
               ena_ipd WHEN (ena_register_mode = "none") ELSE cereg2_out;

    outclk_tmp <= ena_out AND clkmux_out;

    -- output path
    process (inclk_ipd,outclk_tmp)
    variable outclk_VitalGlitchData : VitalGlitchDataType;
    begin
        ----------------------
        --  Path Delay Section
        ----------------------

        VitalPathDelay01
        (
            OutSignal => outclk,
            OutSignalName => "OUTCLK",
            OutTemp => outclk_tmp,
            Paths => (0 => (inclk_ipd(0)'last_event, tpd_inclk_outclk(0), TRUE),
                      1 => (inclk_ipd(1)'last_event, tpd_inclk_outclk(1), TRUE),
                      2 => (inclk_ipd(2)'last_event, tpd_inclk_outclk(2), TRUE),
                      3 => (inclk_ipd(3)'last_event, tpd_inclk_outclk(3), TRUE)),
            GlitchData => outclk_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
        );
    end process;


end vital_clkctrl;	

----------------------------------------------------------------------------------
--Module Name:                    cycloneiv_pseudo_diff_out                          --
--Description:                    Simulation model for Cyclone IV GX Pseudo Differential --
--                                Output Buffer                                  --
----------------------------------------------------------------------------------


LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

ENTITY cycloneiv_pseudo_diff_out IS
 GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             lpm_type                         :  string := "cycloneiv_pseudo_diff_out"
            );
 PORT (
           i                       : IN std_logic := '0';
           o                       : OUT std_logic;
           obar                    : OUT std_logic
         );
END cycloneiv_pseudo_diff_out;

ARCHITECTURE arch OF cycloneiv_pseudo_diff_out IS
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
--
--
--  CYCLONEIV_RUBLOCK Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.cycloneiv_atom_pack.all;

entity  cycloneiv_rublock is
	generic
	(
		sim_init_config : string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_status : integer := 0;
		sim_init_config_is_application : string := "false";
		sim_init_watchdog_enabled : string := "false";
		operation_mode : string := "active_serial_remote";
		lpm_type : string := "cycloneiv_rublock"
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

end cycloneiv_rublock;

architecture architecture_rublock of cycloneiv_rublock is

begin

end architecture_rublock;



--------------------------------------------------------------------
--
-- Module Name : cycloneiv_termination
--
-- Description : Cyclone IV GX Termination Atom VHDL simulation model 
--          
--------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cycloneiv_termination IS
    GENERIC (
         pullup_control_to_core:  string := "false";    
         power_down            :  string := "true";    
         test_mode             :  string := "false";    
         left_shift_termination_code :  string := "false";    
         pullup_adder          :  integer := 0;    
         pulldown_adder        :  integer := 0;    
         clock_divide_by       :  integer := 32;    --  1, 4, 32
         runtime_control       :  string := "false";    
         shift_vref_rup        :  string := "true";    
         shift_vref_rdn        :  string := "true";    
         shifted_vref_control  :  string := "true";    
         lpm_type              :  string := "cycloneiv_termination");
    PORT (
        rup                     : IN std_logic := '0';   
        rdn                     : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        terminationclear        : IN std_logic := '0';  
        devpor                  : IN std_logic := '1';   
        devclrn                 : IN std_logic := '1';   
        comparatorprobe         : OUT std_logic;   
        terminationcontrolprobe : OUT std_logic;   
        calibrationdone         : OUT std_logic;   
        terminationcontrol      : OUT std_logic_vector(15 DOWNTO 0));   
END cycloneiv_termination;

ARCHITECTURE cycloneiv_termination_arch OF cycloneiv_termination IS
    SIGNAL rup_compout          : std_logic := '0';
    SIGNAL rdn_compout          : std_logic := '1';
    
BEGIN
    calibrationdone <= '1';      -- power-up calibration status
    
    comparatorprobe <= rup_compout WHEN (pullup_control_to_core = "true") ELSE rdn_compout;
    rup_compout	<= rup;
    rdn_compout	<= not rdn;
     
END cycloneiv_termination_arch;
-------------------------------------------------------------------
--
-- Entity Name : cycloneiv_jtag
--
-- Description : Cyclone IV GX JTAG VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.cycloneiv_atom_pack.all;

entity  cycloneiv_jtag is
    generic (
        lpm_type : string := "cycloneiv_jtag"
        );	
    port (
        tms : in std_logic := '0'; 
        tck : in std_logic := '0'; 
        tdi : in std_logic := '0';
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
end cycloneiv_jtag;

architecture architecture_jtag of cycloneiv_jtag is
begin

end architecture_jtag;

-------------------------------------------------------------------
--
-- Entity Name : cycloneiv_crcblock
--
-- Description : Cyclone IV GX CRCBLOCK VHDL Simulation model
--
-------------------------------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.cycloneiv_atom_pack.all;

entity  cycloneiv_crcblock is
    generic  (
        oscillator_divider : integer := 1;
        lpm_type : string := "cycloneiv_crcblock"
        );	
    port (
        clk : in std_logic := '0'; 
        shiftnld : in std_logic := '0'; 
        ldsrc : in std_logic := '0'; 
        crcerror : out std_logic; 
        regout : out std_logic
        ); 
end cycloneiv_crcblock;

architecture architecture_crcblock of cycloneiv_crcblock is
begin
	crcerror <= '0';
	regout <= '0';

end architecture_crcblock;

--
--
--  CYCLONEIV_OSCILLATOR Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.cycloneiv_atom_pack.all;

entity  cycloneiv_oscillator is
	generic
	(
            lpm_type: string := "cycloneiv_oscillator";
            TimingChecksOn: Boolean := True;
            XOn: Boolean := DefGlitchXOn;
            MsgOn: Boolean := DefGlitchMsgOn;
            tpd_oscena_clkout_posedge  : VitalDelayType01 := DefPropDelay01;
            tipd_oscena : VitalDelayType01 := DefPropDelay01
	);
	port 
	(
            oscena : in std_logic; 
            observableoutputport: out std_logic;
            clkout : out std_logic
	);

end cycloneiv_oscillator;

architecture architecture_oscillator of cycloneiv_oscillator is
    signal oscena_ipd : std_logic;
    signal int_osc : std_logic := '0';

begin        

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (oscena_ipd, oscena, tipd_oscena);
    end block;

    VITAL_osc : process(oscena_ipd, int_osc)
        variable OSC_PW : time := 6250 ps; -- pulse width for 80MHz clock
        variable osc_VitalGlitchData : VitalGlitchDataType;
    begin
        if (oscena_ipd = '1') then
            if ((int_osc = '0') or (int_osc = '1')) then
                int_osc <= not int_osc after OSC_PW;
            else
                int_osc <= '0' after OSC_PW;
            end if;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal     => clkout,
            OutSignalName => "osc",
            OutTemp       => int_osc,
            Paths         => (0 => (InputChangeTime => oscena_ipd'last_event,
                                    PathDelay => tpd_oscena_clkout_posedge,
                                    PathCondition => (oscena_ipd = '1'))),
            GlitchData    => osc_VitalGlitchData,
            Mode          => DefGlitchMode,
            XOn           => XOn,
            MsgOn         => MsgOn );
    end process;

end architecture_oscillator;


--
--
--  CYCLONEIV_CONTROLLER Model
--
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.cycloneiv_atom_pack.all;

entity  cycloneiv_controller is
	generic
	(
		lpm_type: string := "cycloneiv_controller"
	);
	port 
	(
		usermode   : out std_logic;
		nceout     : out std_logic
	);

end cycloneiv_controller;

architecture architecture_apfcontroller of cycloneiv_controller is


begin

end architecture_apfcontroller;


--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cycloneiv_mn_cntr
--
-- Description : Timing simulation model for the M and N counter. This is a
--               common model for the input counter and the loop feedback
--               counter of the Cyclone IV GX PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY cycloneiv_mn_cntr is
    PORT(  clk           : IN std_logic;
            reset         : IN std_logic := '0';
            cout          : OUT std_logic;
            initial_value : IN integer := 1;
            modulus       : IN integer := 1;
            time_delay    : IN integer := 0
        );
END cycloneiv_mn_cntr;

ARCHITECTURE behave of cycloneiv_mn_cntr is
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
-- Entity Name : cycloneiv_post_divider
--
-- Description : Timing simulation model that models the icdrclk output.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY cycloneiv_post_divider is
    GENERIC ( dpa_divider : integer := 1
        );
    PORT(  clk           : IN std_logic;
            reset         : IN std_logic := '0';
            cout          : OUT std_logic
        );
END cycloneiv_post_divider;

ARCHITECTURE behave of cycloneiv_post_divider is
begin

    process (clk, reset)
    variable count : integer := 1;
    variable first_rising_edge : boolean := true;
    variable tmp_cout : std_logic;
    variable modules : integer := 0;
    variable init : boolean := true;
    begin
        if (init = true) then
            if (dpa_divider = 0) then
                modules := 1;
            else
                modules := dpa_divider;
            end if;
            init := false;
        end if;

        if (reset = '1') then
            count := 1;
            tmp_cout := '0';
            first_rising_edge := true;
        elsif (clk'event) then
            if (clk = '1' and first_rising_edge) then
            first_rising_edge := false;
            tmp_cout := clk;
        elsif (not first_rising_edge) then
            if (count < modules) then
                count := count + 1;
            else
                count := 1;
                tmp_cout := not tmp_cout;
            end if;
        end if;
        end if;
        cout <= transport tmp_cout;
    end process;
end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : cycloneiv_scale_cntr
--
-- Description : Timing simulation model for the output scale-down counters.
--               This is a common model for the C0, C1, C2, C3, C4 and C5
--               output counters of the Cyclone IV GX PLL.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY cycloneiv_scale_cntr is
    PORT(   clk            : IN std_logic;
            reset          : IN std_logic := '0';
            initial        : IN integer := 1;
            high           : IN integer := 1;
            low            : IN integer := 1;
            mode           : IN string := "bypass";
            ph_tap         : IN integer := 0;
            cout           : OUT std_logic
        );
END cycloneiv_scale_cntr;

ARCHITECTURE behave of cycloneiv_scale_cntr is
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
-- Entity Name : cycloneiv_pll_reg
--
-- Description : Simulation model for a simple DFF.
--               This is required for the generation of the bit slip-signals.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY cycloneiv_pll_reg is
    PORT(   clk : in std_logic;
            ena : in std_logic := '1';
            d : in std_logic;
            clrn : in std_logic := '1';
            prn : in std_logic := '1';
            q : out std_logic
        );
end cycloneiv_pll_reg;

ARCHITECTURE behave of cycloneiv_pll_reg is
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
-- Entity Name : cycloneiv_pll
--
-- Description : Timing simulation model for the Cyclone IV GX PLL.
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
USE work.cycloneiv_atom_pack.all;
USE work.cycloneiv_pllpack.all;
USE work.cycloneiv_mn_cntr;
USE work.cycloneiv_scale_cntr;
USE work.cycloneiv_dffe;
USE work.cycloneiv_pll_reg;


ENTITY cycloneiv_pll is
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

        pfd_min                     : integer := 0;
        pfd_max                     : integer := 0;
        vco_min                     : integer := 0;
        vco_max                     : integer := 0;
        vco_center                  : integer := 0;

        feedback_source             : integer := 0;
        feedback_external_loop_divider : string := "false";


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

        m_ph                        : integer := 0;

        clk0_counter                : string := "unused";
        clk1_counter                : string := "unused";
        clk2_counter                : string := "unused";
        clk3_counter                : string := "unused";
        clk4_counter                : string := "unused";
        
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
        
        m_test_source               : integer := -1;
        c0_test_source              : integer := -1;
        c1_test_source              : integer := -1;
        c2_test_source              : integer := -1;
        c3_test_source              : integer := -1;
        c4_test_source              : integer := -1;
        
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        vco_post_scale              : integer := 1;
        vco_frequency_control       : string  := "auto";
        vco_phase_shift_step        : integer := 0;

        dpa_multiply_by             : integer := 0;
        dpa_divide_by               : integer := 0;
        dpa_divider                 : integer := 1;

        charge_pump_current         : integer := 10;
        loop_filter_r               : string := " 1.0";
        loop_filter_c               : integer := 0;
      
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        lpm_type                    : string := "cycloneiv_pll";
	lpm_hint                    : string := "unused";
        
        clk0_use_even_counter_mode  : string := "off";
        clk1_use_even_counter_mode  : string := "off";
        clk2_use_even_counter_mode  : string := "off";
        clk3_use_even_counter_mode  : string := "off";
        clk4_use_even_counter_mode  : string := "off";
        
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
            
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

        auto_settings : string  := "true";     
-- Simulation only generics
        family_name                 : string  := "Cyclone IV GX";

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
        tipd_phasecounterselect     : VitalDelayArrayType01(2 DOWNTO 0) := (OTHERS => DefPropDelay01);
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
        clk                         : out std_logic_vector(4 downto 0);
        phasecounterselect          : in std_logic_vector(2 downto 0) := "000";
        phaseupdown                 : in std_logic := '0';
        phasestep                   : in std_logic := '0';
        clkbad                      : out std_logic_vector(1 downto 0);
        activeclock                 : out std_logic;
        locked                      : out std_logic;
        scandataout                 : out std_logic;
        scandone                    : out std_logic;
        phasedone                   : out std_logic;
        vcooverrange                : out std_logic;
        vcounderrange               : out std_logic;
        fref                        : out std_logic;
        icdrclk                     : out std_logic
    );
END cycloneiv_pll;

ARCHITECTURE vital_pll of cycloneiv_pll is

TYPE int_array is ARRAY(NATURAL RANGE <>) of integer;
TYPE str_array is ARRAY(NATURAL RANGE <>) of string(1 to 6);
TYPE str_array1 is ARRAY(NATURAL RANGE <>) of string(1 to 9);
TYPE std_logic_array is ARRAY(NATURAL RANGE <>) of std_logic;

-- internal advanced parameter signals
signal   i_vco_min      : integer := vco_min * (vco_post_scale/2);
signal   i_vco_max      : integer := vco_max * (vco_post_scale/2);
signal   i_vco_center   : integer;
signal   i_pfd_min      : integer;
signal   i_pfd_max      : integer;
    signal   c_ph_val       : int_array(0 to 4) := (OTHERS => 0);
    signal   c_ph_val_tmp   : int_array(0 to 4) := (OTHERS => 0);
    signal   c_high_val     : int_array(0 to 4) := (OTHERS => 1);
    signal   c_low_val      : int_array(0 to 4) := (OTHERS => 1);
    signal   c_initial_val  : int_array(0 to 4) := (OTHERS => 1);
    signal   c_mode_val     : str_array(0 to 4);
    signal   clk_num     : str_array(0 to 4);

-- old values
    signal   c_high_val_old : int_array(0 to 4) := (OTHERS => 1);
    signal   c_low_val_old  : int_array(0 to 4) := (OTHERS => 1);
    signal   c_ph_val_old   : int_array(0 to 4) := (OTHERS => 0);
    signal   c_mode_val_old : str_array(0 to 4);
-- hold registers
    signal   c_high_val_hold : int_array(0 to 4) := (OTHERS => 1);
    signal   c_low_val_hold  : int_array(0 to 4) := (OTHERS => 1);
    signal   c_ph_val_hold   : int_array(0 to 4) := (OTHERS => 0);
    signal   c_mode_val_hold : str_array(0 to 4);

-- temp registers
    signal   sig_c_ph_val_tmp   : int_array(0 to 4) := (OTHERS => 0);
    signal   c_ph_val_orig  : int_array(0 to 4) := (OTHERS => 0);

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
    CONSTANT cntrs : str_array(4 downto 0) := ("    C4", "    C3", "    C2", "    C1", "    C0");
CONSTANT    ss_cntrs : str_array(0 to 3) := ("     M", "    M2", "     N", "    N2");
            
CONSTANT    loop_filter_c_arr : int_array(0 to 3) := (0,0,0,0);
CONSTANT    fpll_loop_filter_c_arr : int_array(0 to 3) := (0,0,0,0);
CONSTANT    charge_pump_curr_arr : int_array(0 to 15) := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

CONSTANT    num_phase_taps : integer := 8;
-- signals

signal    vcc : std_logic := '1';
          
signal    fbclk       : std_logic;
signal    refclk      : std_logic;

signal    icdr_clk     : std_logic;

signal    vco_over    : std_logic := '0';
signal    vco_under   : std_logic := '1';

signal pll_locked : boolean := false;


    signal c_clk : std_logic_array(0 to 4);
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
    signal num_output_cntrs : integer := 5;
signal    scanclk_period : time := 1 ps;
    signal scan_data : std_logic_vector(0 to 143) := (OTHERS => '0');


    signal clk_pfd : std_logic_vector(0 to 4);
signal    clk0_tmp : std_logic;
signal    clk1_tmp : std_logic;
signal    clk2_tmp : std_logic;
signal    clk3_tmp : std_logic;
signal    clk4_tmp : std_logic;

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
    signal phasecounterselect_ipd : std_logic_vector(2 downto 0);
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

    SIGNAL phasecounterselect_reg   :  std_logic_vector(2 DOWNTO 0);

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

    signal inclk_c_from_vco : std_logic_array(0 to 4);

signal inclk_m_from_vco : std_logic;

SIGNAL inclk0_period              : time := 0 ps;
SIGNAL last_inclk0_period         : time := 0 ps;
SIGNAL last_inclk0_edge         : time := 0 ps;
SIGNAL first_inclk0_edge_detect : STD_LOGIC := '0';
SIGNAL inclk1_period              : time := 0 ps;
SIGNAL last_inclk1_period         : time := 0 ps;
SIGNAL last_inclk1_edge         : time := 0 ps;
SIGNAL first_inclk1_edge_detect : STD_LOGIC := '0';



COMPONENT cycloneiv_mn_cntr
    PORT (
        clk           : IN std_logic;
        reset         : IN std_logic := '0';
        cout          : OUT std_logic;
        initial_value : IN integer := 1;
        modulus       : IN integer := 1;
        time_delay    : IN integer := 0
    );
END COMPONENT;

COMPONENT cycloneiv_post_divider
    GENERIC ( dpa_divider : integer := 0
    );
    PORT (
        clk           : IN std_logic;
        reset         : IN std_logic := '0';
        cout          : OUT std_logic
    );
END COMPONENT;


COMPONENT cycloneiv_scale_cntr
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

COMPONENT cycloneiv_dffe
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

COMPONENT cycloneiv_pll_reg
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

    end block;

inclk_m <=  fbclk when m_test_source = 0 else
            refclk when m_test_source = 1 else
            inclk_m_from_vco;

    areset_ena_sig <= areset_ipd or sig_stop_vco;

   
    pll_in_test_mode <= true when   (m_test_source /= -1 or c0_test_source /= -1 or
                                    c1_test_source /= -1 or c2_test_source /= -1 or
                                    c3_test_source /= -1 or c4_test_source /= -1)
                                    else false;

    real_lock_high <= lock_high WHEN (sim_gate_lock_device_behavior = "on") ELSE 0;   
    m1 : cycloneiv_mn_cntr
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


    n1 : cycloneiv_mn_cntr
        port map (
                clk           => clkin,
                reset         => areset_ipd,
                cout          => refclk,
                initial_value => n_val,
                modulus       => n_val);

    d1 : cycloneiv_post_divider
        generic map ( dpa_divider => dpa_divider)
        port map (
                clk           => inclk_m_from_vco,
                reset         => areset_ipd,
                cout          => icdr_clk);


inclk_c0 <= refclk when c0_test_source = 1 else
            fbclk   when c0_test_source = 0 else
            inclk_c_from_vco(0);


    c0 : cycloneiv_scale_cntr
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
                

    c1 : cycloneiv_scale_cntr
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

    c2 : cycloneiv_scale_cntr
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
                
    c3 : cycloneiv_scale_cntr
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
                
    c4 : cycloneiv_scale_cntr
        port map (
                clk            => inclk_c4,
                reset          => areset_ena_sig,
                cout           => c_clk(4),
                initial        => c_initial_val(4),
                high           => c_high_val(4),
                low            => c_low_val(4),
                mode           => c_mode_val(4),
                ph_tap         => c_ph_val(4));

            

            

            

            

            
    
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

    
    process (scandone_tmp,areset_ipd,update_conf_latches, c_clk(0), c_clk(1), c_clk(2), c_clk(3), c_clk(4), vco_out, fbclk, scanclk_ipd)
    variable init : boolean := true;
    variable low, high : std_logic_vector(7 downto 0);
    variable low_fast, high_fast : std_logic_vector(3 downto 0);
    variable mode : string(1 to 6) := "bypass";
    variable is_error : boolean := false;
    variable m_tmp, n_tmp : std_logic_vector(8 downto 0);
    variable lfr_val_tmp : string(1 to 2) := "  ";

    variable c_high_val_tmp,c_hval : int_array(0 to 4) := (OTHERS => 1);
    variable c_low_val_tmp,c_lval  : int_array(0 to 4) := (OTHERS => 1);
    variable c_mode_val_tmp : str_array(0 to 4);
    variable m_val_tmp      : integer := 0;
    variable c0_rising_edge_transfer_done : boolean := false;
    variable c1_rising_edge_transfer_done : boolean := false;
    variable c2_rising_edge_transfer_done : boolean := false;
    variable c3_rising_edge_transfer_done : boolean := false;
    variable c4_rising_edge_transfer_done : boolean := false;

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
    variable   i_c_high       : int_array(0 to 4);
    variable   i_c_low       : int_array(0 to 4);
    variable   i_c_initial       : int_array(0 to 4);
    variable   i_c_ph       : int_array(0 to 4);
    variable   i_c_mode       : str_array(0 to 4);
    variable   i_m_ph         : integer;
    variable   output_count   : integer;
    variable   new_divisor    : integer;

    variable clk0_cntr : string(1 to 6) := "    c0";
    variable clk1_cntr : string(1 to 6) := "    c1";
    variable clk2_cntr : string(1 to 6) := "    c2";
    variable clk3_cntr : string(1 to 6) := "    c3";
    variable clk4_cntr : string(1 to 6) := "    c4";

    variable   i_clk4_cntr         : integer := 4;
    variable   i_clk3_cntr         : integer := 3;
    variable   i_clk2_cntr         : integer := 2;
    variable   i_clk1_cntr         : integer := 1;
    variable   i_clk0_cntr         : integer := 0;

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
    variable current_scan_data : std_logic_vector(0 to 143) := (OTHERS => '0');

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
    
    variable clk_index : integer := 0;
    
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
                clk4_cntr  := "    c4";
                clk3_cntr  := "    c3";
                clk2_cntr  := "    c2";
                clk1_cntr  := "    c1";
                clk0_cntr  := "    c0";
            else
                clk4_cntr  := extract_cntr_string(clk4_counter);
                clk3_cntr  := extract_cntr_string(clk3_counter);
                clk2_cntr  := extract_cntr_string(clk2_counter);
                clk1_cntr  := extract_cntr_string(clk1_counter);
                clk0_cntr  := extract_cntr_string(clk0_counter);
            end if;

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

            i_clk0_cntr := extract_cntr_index(clk0_cntr);
            i_clk1_cntr := extract_cntr_index(clk1_cntr);
            i_clk2_cntr := extract_cntr_index(clk2_cntr);
            i_clk3_cntr := extract_cntr_index(clk3_cntr);
            i_clk4_cntr := extract_cntr_index(clk4_cntr);

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
                                
                if (vco_frequency_control = "manual_phase") then
                    find_m_and_n_4_manual_phase(inclk0_input_frequency, vco_phase_shift_step,
                                i_clk0_mult_by, i_clk1_mult_by,
                                i_clk2_mult_by, i_clk3_mult_by,
                                i_clk4_mult_by, 
                                1,1,1,1,1,
                                i_clk0_div_by, i_clk1_div_by,
                                i_clk2_div_by, i_clk3_div_by,
                                i_clk4_div_by, 
                                1,1,1,1,1,
                                clk0_counter, clk1_counter,
                                clk2_counter, clk3_counter,
                                clk4_counter, 
                                "unused","unused","unused","unused","unused",
                        i_m, i_n);
                elsif (((pll_type = "fast") or (pll_type = "lvds") OR (pll_type = "left_right")) and ((vco_multiply_by /= 0) and (vco_divide_by /= 0))) then
                    i_n := vco_divide_by;
                    i_m := vco_multiply_by;
                elsif ((dpa_multiply_by /= 0) and (dpa_divide_by /= 0)) then
                    i_n := dpa_divide_by;
                    i_m := dpa_multiply_by;
                else
                    i_n := 1;

                    if (((pll_type = "fast") or (pll_type = "left_right")) and (compensate_clock = "lvdsclk")) then
                        i_m := i_clk0_mult_by;
                    else
                        i_m := lcm (i_clk0_mult_by, i_clk1_mult_by,
                                i_clk2_mult_by, i_clk3_mult_by,
                                i_clk4_mult_by, 
                                1,1,1,1,1,
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
                                        0,
                                        0,
                                        0,
                                        0,
                                        0
                                        );
                i_m_ph  := counter_ph(get_phase_degree(max_neg_abs,inclk0_input_frequency), i_m, i_n); 

                i_c_ph(0) := counter_ph(get_phase_degree(ph_adjust(i_clk0_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(1) := counter_ph(get_phase_degree(ph_adjust(i_clk1_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(2) := counter_ph(get_phase_degree(ph_adjust(i_clk2_phase_shift,max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(3) := counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_c_ph(4) := counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                
                
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

                i_m_initial  := counter_initial(get_phase_degree(max_neg_abs, inclk0_input_frequency), i_m,i_n);
                
                i_c_initial(0) := counter_initial(get_phase_degree(ph_adjust(i_clk0_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(1) := counter_initial(get_phase_degree(ph_adjust(i_clk1_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(2) := counter_initial(get_phase_degree(ph_adjust(i_clk2_phase_shift, max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(3) := counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_initial(4) := counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_c_mode(0) := counter_mode(clk0_duty_cycle, output_counter_value(i_clk0_div_by, i_clk0_mult_by,  i_m, i_n));
                i_c_mode(1) := counter_mode(clk1_duty_cycle, output_counter_value(i_clk1_div_by, i_clk1_mult_by,  i_m, i_n));
                i_c_mode(2) := counter_mode(clk2_duty_cycle, output_counter_value(i_clk2_div_by, i_clk2_mult_by,  i_m, i_n));
                i_c_mode(3) := counter_mode(clk3_duty_cycle, output_counter_value(i_clk3_div_by, i_clk3_mult_by,  i_m, i_n));
                i_c_mode(4) := counter_mode(clk4_duty_cycle, output_counter_value(i_clk4_div_by, i_clk4_mult_by,  i_m, i_n));

                
 
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
                i_c_high(0)       := c0_high;
                i_c_high(1)       := c1_high;
                i_c_high(2)       := c2_high;
                i_c_high(3)       := c3_high;
                i_c_high(4)       := c4_high;
                i_c_low(0)        := c0_low;
                i_c_low(1)        := c1_low;
                i_c_low(2)        := c2_low;
                i_c_low(3)        := c3_low;
                i_c_low(4)        := c4_low;
                i_c_initial(0)    := c0_initial;
                i_c_initial(1)    := c1_initial;
                i_c_initial(2)    := c2_initial;
                i_c_initial(3)    := c3_initial;
                i_c_initial(4)    := c4_initial;
                i_c_mode(0)       := translate_string(c0_mode);
                i_c_mode(1)       := translate_string(c1_mode);
                i_c_mode(2)       := translate_string(c2_mode);
                i_c_mode(3)       := translate_string(c3_mode);
                i_c_mode(4)       := translate_string(c4_mode);

            end if; -- user to advanced conversion.

            m_initial_val <= i_m_initial;

	    if ((compensate_clock = "iqtxrxclk") and (m /= 0)) then

                case feedback_source is
                    when 0 => clk_index :=   i_clk0_cntr;
                    when 1 => clk_index :=   i_clk1_cntr;
                    when 2 => clk_index :=   i_clk2_cntr;
                    when 3 => clk_index :=   i_clk3_cntr;
                    when 4 => clk_index :=   i_clk4_cntr;
                    when others =>
                        ASSERT FALSE
                        REPORT "Invalid feedback_source value (" & int2str(feedback_source) & ")!"
                        SEVERITY ERROR;
                end case;

                if(feedback_external_loop_divider = "true") then
                    m_val <= i_m * (i_c_high(clk_index) + i_c_low(clk_index)) * 2;
                    m_val_tmp := i_m * (i_c_high(clk_index) + i_c_low(clk_index)) * 2;
                else
                    m_val <= i_m * (i_c_high(clk_index) + i_c_low(clk_index));
                    m_val_tmp := i_m * (i_c_high(clk_index) + i_c_low(clk_index));
                end if;
            else
                m_val <= i_m;
                m_val_tmp := i_m;
	    end if;

            n_val <= i_n;


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


            for i in 0 to 4 loop
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

            

            scan_chain_length := SCAN_CHAIN;

               
            num_output_cntrs <= 5;

            init := false;
        elsif (scandone_tmp'EVENT AND scandone_tmp = '1') then
            c0_rising_edge_transfer_done := false;
            c1_rising_edge_transfer_done := false;
            c2_rising_edge_transfer_done := false;
            c3_rising_edge_transfer_done := false;
            c4_rising_edge_transfer_done := false;
            update_conf_latches_reg <= '0';
        elsif (update_conf_latches'event and update_conf_latches = '1') then
            initiate_reconfig <= '1';
        elsif (areset_ipd'event AND areset_ipd = '1') then
            if (scandone_tmp = '0') then scandone_tmp <= '1' ; end if;
        elsif (scanclk_ipd'event and scanclk_ipd = '1') then
            IF (initiate_reconfig = '1') THEN
                initiate_reconfig <= '0';
                ASSERT false REPORT "PLL Reprogramming Initiated" severity note;

                update_conf_latches_reg <= update_conf_latches;
                reconfig_err <= false;
                scandone_tmp <= '0' AFTER scanclk_period;
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
                    i_vco_max <= vco_max/2;
                    i_vco_min <= vco_min/2;
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
                    n_mode_val <= "bypass"; 
                -- 3. Mode - odd/even (bit 27)
                ELSIF (scan_data(27) = '1') THEN
                    n_mode_val <= "   odd";
                ELSE
                    n_mode_val <= "  even"; 
                END IF;
        
                -- 2. High (bit 19-26)
                
                n_hi := scan_data(19 TO 26);    
                
                -- 4. Low (bit 28-35)
                
                n_lo := scan_data(28 TO 35);    
                -- N counter
                -- 1. Mode - bypass (bit 36)
                
                IF (scan_data(36) = '1') THEN
                    m_mode_val <= "bypass";    
                -- 3. Mode - odd/even (bit 45)
                ELSIF  (scan_data(45) = '1') THEN
                    m_mode_val <= "   odd"; 
                ELSE
                    m_mode_val <= "  even";   
                END IF;
        
                -- 2. High (bit 37-44)
                
                m_hi := scan_data(37 TO 44);    
                
                -- 4. Low (bit 46-53)
                
                m_lo := scan_data(46 TO 53);    
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
    IF(scan_data(36) /= '1') THEN
        IF ((m_hi /= m_lo) and (scan_data(45) /= '1')) THEN           
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
    IF(scan_data(18) /= '1') THEN             
        IF ((n_hi /= n_lo)and (scan_data(27) /= '1')) THEN         
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

        if (update_phase = '1') then
            if (vco_out(0)'event and vco_out(0) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 0) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 0) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(1)'event and vco_out(1) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 1) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 1) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(2)'event and vco_out(2) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 2) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 2) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(3)'event and vco_out(3) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 3) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 3) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(4)'event and vco_out(4) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 4) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 4) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(5)'event and vco_out(5) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 5) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 5) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(6)'event and vco_out(6) = '0') then
                for i in 0 to 4 loop
                    if (c_ph_val(i) = 6) then
                        c_ph_val(i) <= c_ph_val_tmp(i);
                    end if;
                end loop;
                if (m_ph_val = 6) then
                    m_ph_val <= m_ph_val_tmp;
                end if;
            end if;
            if (vco_out(7)'event and vco_out(7) = '0') then
                for i in 0 to 4 loop
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
                for i in 0 to 4 loop
                if (c_ph_val(i) = 0) then
                    inclk_c_from_vco(i) <= vco_out(0);
                end if;
            end loop;
            if (m_ph_val = 0) then
                inclk_m_from_vco <= vco_out(0);
            end if;
        end if;
        if (vco_out(1)'event) then
                for i in 0 to 4 loop
                if (c_ph_val(i) = 1) then
                    inclk_c_from_vco(i) <= vco_out(1);
                end if;
            end loop;
            if (m_ph_val = 1) then
                inclk_m_from_vco <= vco_out(1);
            end if;
        end if;
        if (vco_out(2)'event) then
                for i in 0 to 4 loop
                if (c_ph_val(i) = 2) then
                    inclk_c_from_vco(i) <= vco_out(2);
                end if;
            end loop;
            if (m_ph_val = 2) then
                inclk_m_from_vco <= vco_out(2);
            end if;
        end if;
        if (vco_out(3)'event) then
                for i in 0 to 4 loop
                if (c_ph_val(i) = 3) then
                    inclk_c_from_vco(i) <= vco_out(3);
                end if;
            end loop;
            if (m_ph_val = 3) then
                inclk_m_from_vco <= vco_out(3);
            end if;
        end if;
        if (vco_out(4)'event) then
                for i in 0 to 4 loop
                if (c_ph_val(i) = 4) then
                    inclk_c_from_vco(i) <= vco_out(4);
                end if;
            end loop;
            if (m_ph_val = 4) then
                inclk_m_from_vco <= vco_out(4);
            end if;
        end if;
        if (vco_out(5)'event) then
                for i in 0 to 4 loop
                if (c_ph_val(i) = 5) then
                    inclk_c_from_vco(i) <= vco_out(5);
                end if;
            end loop;
            if (m_ph_val = 5) then
                inclk_m_from_vco <= vco_out(5);
            end if;
        end if;
        if (vco_out(6)'event) then
                for i in 0 to 4 loop
                if (c_ph_val(i) = 6) then
                    inclk_c_from_vco(i) <= vco_out(6);
                end if;
            end loop;
            if (m_ph_val = 6) then
                inclk_m_from_vco <= vco_out(6);
            end if;
        end if;
        if (vco_out(7)'event) then
                for i in 0 to 4 loop
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
             HeaderMsg       => InstancePath & "/cycloneiv_pll",
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
             HeaderMsg       => InstancePath & "/cycloneiv_pll",
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
            IF (phasecounterselect_ipd < "111")  THEN -- no counters selected
            IF (phasecounterselect_ipd = "000") THEN
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
            ELSIF (phasecounterselect_ipd = "001") THEN
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

    scandataout_tmp <= scan_data(SCAN_CHAIN - 2);

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
    variable time_resolution : time;

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

            if (lpm_hint = "time_resolution=100fs") then
                time_resolution := 100 fs;
	    elsif (lpm_hint = "time_resolution=10fs") then
                time_resolution := 10 fs;
	    elsif (lpm_hint = "time_resolution=fs") then
                time_resolution := 1 fs;
	    else
                time_resolution := 1 ps;
	    end if;

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
            locked_tmp := '0';
            pll_is_locked := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;
        end if;


        if (schedule_vco'event and (areset_ipd = '1' or stop_vco)) then

            if (areset_ipd = '1') then
                pll_is_in_reset := true;
                got_first_refclk := false;
                got_second_refclk := false;
            end if;

            -- drop VCO taps to 0
            for i in 0 to 7 loop
                vco_out(i) <= transport '0' after last_phase_shift(i);
                phase_shift(i) := 0 ps;
                last_phase_shift(i) := 0 ps;
            end loop;

            -- reset lock parameters
            locked_tmp := '0';
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
                pll_is_in_reset := false;
                locked_tmp := '0';
            end if;

            -- calculate loop_xplier : this will be different from m_val
            -- in external_feedback_mode
            loop_xplier := m_val;
            loop_initial := m_initial_val - 1;
            loop_ph := m_ph_val;


            -- convert initial value to delay
            initial_delay := (loop_initial * m_times_vco_period)/loop_xplier;

            -- convert loop ph_tap to delay
            my_rem := (m_times_vco_period/time_resolution) rem loop_xplier;
            tmp_vco_per := (m_times_vco_period/time_resolution) / loop_xplier;
            if (my_rem /= 0) then
                tmp_vco_per := tmp_vco_per + 1;
            end if;
            fbk_phase := (loop_ph * tmp_vco_per)/8;

            pull_back_M := initial_delay/time_resolution + fbk_phase;

            total_pull_back := pull_back_M;

            if (simulation_type = "timing") then
                total_pull_back := total_pull_back + pll_compensation_delay;
            end if;
            while (total_pull_back > refclk_period/time_resolution) loop
                total_pull_back := total_pull_back - refclk_period/time_resolution;
            end loop;

            if (total_pull_back > 0) then
                offset := refclk_period - (total_pull_back * time_resolution);
            end if;
            
            fbk_delay := total_pull_back - fbk_phase;
            if (fbk_delay < 0) then
                offset := offset - (fbk_phase * time_resolution);
                fbk_delay := total_pull_back;
            end if;

            -- assign m_delay
            m_delay <= transport fbk_delay after time_resolution;

            my_rem := (m_times_vco_period/time_resolution) rem loop_xplier;
            for i in 1 to loop_xplier loop
                -- adjust cycles
                tmp_vco_per := (m_times_vco_period/time_resolution)/loop_xplier;
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
                vco_per := tmp_vco_per * time_resolution;
                high_time := (tmp_vco_per/2) * time_resolution;
                if (tmp_vco_per rem 2 /= 0) then
                    high_time := high_time + time_resolution;
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

    scandataout <= scandata_out;
    scandone <= NOT scandone_tmp;
    phasedone <= NOT update_phase;
    vcooverrange <= 'Z' WHEN (vco_range_detector_high_bits = -1) ELSE vco_over;
    vcounderrange <= 'Z' WHEN (vco_range_detector_low_bits = -1) ELSE vco_under;
    fbout <= fbclk;
    fref <= refclk;
    icdrclk <= icdr_clk;
end vital_pll;
-- END ARCHITECTURE VITAL_PLL
