---------------------------------------------------------------------------
-- This VHDL file was developed by Altera Corporation.  It may be
-- freely copied and/or distributed at no cost.  Any persons using this
-- file for any purpose do so at their own risk, and are responsible for
-- the results of such use.  Altera Corporation does not guarantee that
-- this file is complete, correct, or fit for any particular purpose.
-- NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
-- accompany any copy of this file.
--------------------------------------------------------------------------
--
-- Quartus II 11.0 Build 157 04/27/2011
--
--------------------------------------------------------------------------
-- LPM Synthesizable Models (Support string type generic)
-- These models are based on LPM version 220 (EIA-IS103 October 1998).
--------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
-- Assumptions:
--
-- 1. All ports and signal types are std_logic or std_logic_vector
--    from IEEE 1164 package.
-- 2. Synopsys std_logic_arith, std_logic_unsigned, and std_logic_signed
--    package are assumed to be accessible from IEEE library.
-- 3. lpm_component_package must be accessible from library work.
-- 4. The default value of LPM_SVALUE, LPM_AVALUE, LPM_MODULUS, LPM_HINT,
--    LPM_NUMWORDS, LPM_STRENGTH, LPM_DIRECTION, and LPM_PVALUE is
--    string "UNUSED".
------------------------------------------------------------------------------- 


---START_PACKAGE_HEADER-----------------------------------------------------
--
-- Package Name    :  LPM_COMMON_CONVERSION
--
-- Description     :  Common conversion functions
--
---END_PACKAGE_HEADER--------------------------------------------------------
-- BEGINING OF PACKAGE
Library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

-- PACKAGE DECLARATION
package LPM_COMMON_CONVERSION is
-- FUNCTION DECLARATION
    function STR_TO_INT (str : string) return integer;
    function INT_TO_STR (value : in integer) return string;
    function HEX_STR_TO_INT (str : in string) return integer;
    function BIN_STR_TO_INT (str : in string) return integer;
    function OCT_STR_TO_INT (str : in string) return integer;
    function INT_STR_TO_INT (str : in string) return integer;
    function ALPHA_TOLOWER (given_string : in string) return string;
    procedure SHRINK_LINE (str_line : inout line; pos : in integer);
end LPM_COMMON_CONVERSION;

package body LPM_COMMON_CONVERSION is
function STR_TO_INT ( str : string ) return integer is
variable len : integer := str'length;
variable ivalue : integer := 0;
variable digit : integer := 0;
begin
    for i in 1 to len loop
        case str(i) is
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
                REPORT "Illegal Character "&  str(i) & "in string parameter! "
                SEVERITY ERROR;
        end case;
        ivalue := ivalue * 10 + digit;
    end loop;
    return ivalue;
end STR_TO_INT;

-- This function converts an integer to a string
function INT_TO_STR (value : in integer) return string is
variable ivalue : integer := 0;
variable index  : integer := 0;
variable digit : integer := 0;
variable line_no: string(8 downto 1) := "        ";  
begin
    ivalue := value;
    index := 1;
    
    while (ivalue > 0) loop
        digit := ivalue MOD 10;
        ivalue := ivalue/10;
        case digit is
            when 0 => line_no(index) := '0';
            when 1 => line_no(index) := '1';
            when 2 => line_no(index) := '2';
            when 3 => line_no(index) := '3';
            when 4 => line_no(index) := '4';
            when 5 => line_no(index) := '5';
            when 6 => line_no(index) := '6';
            when 7 => line_no(index) := '7';
            when 8 => line_no(index) := '8';
            when 9 => line_no(index) := '9';
            when others =>
                ASSERT FALSE
                REPORT "Illegal number!"
                SEVERITY ERROR;
        end case;
        index := index + 1;
    end loop;
    
    return line_no;
end INT_TO_STR;

-- This function converts a hexadecimal number to an integer
function HEX_STR_TO_INT (str : in string) return integer is
variable len : integer := str'length;
variable ivalue : integer := 0;
variable digit : integer := 0;
begin
    for i in len downto 1 loop
        case str(i) is
            when '0' => digit := 0;
            when '1' => digit := 1;
            when '2' => digit := 2;
            when '3' => digit := 3;
            when '4' => digit := 4;
            when '5' => digit := 5;
            when '6' => digit := 6;
            when '7' => digit := 7;
            when '8' => digit := 8;
            when '9' => digit := 9;
            when 'A' => digit := 10;
            when 'a' => digit := 10;
            when 'B' => digit := 11;
            when 'b' => digit := 11;
            when 'C' => digit := 12;
            when 'c' => digit := 12;
            when 'D' => digit := 13;
            when 'd' => digit := 13;
            when 'E' => digit := 14;
            when 'e' => digit := 14;
            when 'F' => digit := 15;
            when 'f' => digit := 15;
            when others =>
                ASSERT FALSE
                REPORT "Illegal hex character "&  str(i) & "! "
                SEVERITY ERROR;
        end case;
        ivalue := ivalue * 16 + digit;
    end loop;
    return ivalue;
end HEX_STR_TO_INT;

-- This function converts a binary number to an integer
function BIN_STR_TO_INT (str : in string) return integer is
variable len : integer := str'length;
variable ivalue : integer := 0;
variable digit : integer := 0;
begin
    for i in len downto 1 loop
        case str(i) is
            when '0' => digit := 0;
            when '1' => digit := 1;
            when others =>
                ASSERT FALSE
                REPORT "Illegal bin character "&  str(i) & "! "
                SEVERITY ERROR;
        end case;
        ivalue := ivalue * 2 + digit;
    end loop;
    return ivalue;
end BIN_STR_TO_INT;

-- This function converts a octadecimal number to an integer
function OCT_STR_TO_INT (str : in string) return integer is
variable len : integer := str'length;
variable ivalue : integer := 0;
variable digit : integer := 0;
begin
    for i in len downto 1 loop
        case str(i) is
            when '0' => digit := 0;
            when '1' => digit := 1;
            when '2' => digit := 2;
            when '3' => digit := 3;
            when '4' => digit := 4;
            when '5' => digit := 5;
            when '6' => digit := 6;
            when '7' => digit := 7;
            when others =>
                ASSERT FALSE
                REPORT "Illegal octadecimal character "&  str(i) & "! "
                SEVERITY ERROR;
        end case;
        ivalue := ivalue * 8 + digit;
    end loop;
    return ivalue;
end OCT_STR_TO_INT;

-- This function converts a integer string to an integer
function INT_STR_TO_INT (str : in string) return integer is
variable len : integer := str'length;
variable newdigit : integer := 0;
variable sign : integer := 1;
variable digit : integer := 0;
begin
    for i in 1 to len loop
        case str(i) is
            when '-' =>
                if i = 1 then
                    sign := -1;
                else
                    ASSERT FALSE
                    REPORT "Illegal Character "&  str(i) & "i n string parameter! "
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
                REPORT "Illegal Character "&  str(i) & "in string parameter! "
                SEVERITY ERROR;
        end case;
        newdigit := newdigit * 10 + digit;
    end loop;

    return (sign*newdigit);
end;

-- converts uppercase parameter values (e.g. "AUTO") to lowercase ("auto")
function ALPHA_TOLOWER (given_string : in string) return string is
    -- VARIABLE DECLARATION
    variable result_string : string(given_string'low to given_string'high);

begin
    for i in given_string'low to given_string'high loop
        case given_string(i) is
            when 'A' => result_string(i) := 'a';
            when 'B' => result_string(i) := 'b';
            when 'C' => result_string(i) := 'c';
            when 'D' => result_string(i) := 'd';
            when 'E' => result_string(i) := 'e';
            when 'F' => result_string(i) := 'f';
            when 'G' => result_string(i) := 'g';
            when 'H' => result_string(i) := 'h';
            when 'I' => result_string(i) := 'i';
            when 'J' => result_string(i) := 'j';
            when 'K' => result_string(i) := 'k';
            when 'L' => result_string(i) := 'l';
            when 'M' => result_string(i) := 'm';
            when 'N' => result_string(i) := 'n';
            when 'O' => result_string(i) := 'o';
            when 'P' => result_string(i) := 'p';
            when 'Q' => result_string(i) := 'q';
            when 'R' => result_string(i) := 'r';
            when 'S' => result_string(i) := 's';
            when 'T' => result_string(i) := 't';
            when 'U' => result_string(i) := 'u';
            when 'V' => result_string(i) := 'v';
            when 'W' => result_string(i) := 'w';
            when 'X' => result_string(i) := 'x';
            when 'Y' => result_string(i) := 'y';
            when 'Z' => result_string(i) := 'z';
            when others => result_string(i) := given_string(i);
        end case;
    end loop;

    return (result_string(given_string'low to given_string'high));
end;

-- This procedure "cuts" the str_line into desired length
procedure SHRINK_LINE (str_line : inout line; pos : in integer) is
subtype nstring is string(1 to pos);
variable str : nstring;
begin
    if (pos >= 1) then
        read(str_line, str);
    end if;
end;
end LPM_COMMON_CONVERSION;
-- END OF PACKAGE 

---START_PACKAGE_HEADER-----------------------------------------------------
--
-- Package Name    :  LPM_HINT_EVALUATION
--
-- Description     :  Common function to grep the value of altera specific parameters
--                    within the lpm_hint parameter.
--
---END_PACKAGE_HEADER--------------------------------------------------------

-- BEGINING OF PACKAGE
Library ieee;
use ieee.std_logic_1164.all;

-- PACKAGE DECLARATION
package LPM_HINT_EVALUATION is
-- FUNCTION DECLARATION
    function get_parameter_value( constant  given_string : string;
                                            compare_param_name : string) return string;
end LPM_HINT_EVALUATION;

package body LPM_HINT_EVALUATION is

-- This function will search through the string (given string) to look for a match for the
-- a given parameter(compare_param_name). It will return the value for the given parameter.
function get_parameter_value( constant  given_string : string; 
                                        compare_param_name : string) return string is
    variable param_name_left_index   : integer := given_string'length;
    variable param_name_right_index  : integer := given_string'length;
    variable param_value_left_index  : integer := given_string'length;
    variable param_value_right_index : integer := given_string'length;
    variable set_right_index         : boolean := true;
    variable extract_param_value     : boolean := true; 
    variable extract_param_name      : boolean := false;  
    variable param_found             : boolean := false;
    variable given_string_tmp        : string(1 to given_string'length) := given_string;
    
begin

    -- checking every character of the given_string from right to left.
    for i in given_string'length downto 1 loop
        if (given_string(i) /= ' ') then
            if (given_string(i) = '=') then
                extract_param_value := false;
                extract_param_name  := true;
                set_right_index := true;
            elsif (given_string(i) = ',') then
                extract_param_value := true;
                extract_param_name  := false;
                set_right_index := true;
                
                if (compare_param_name = given_string_tmp(param_name_left_index to param_name_right_index)) then
                        param_found := true;  -- the compare_param_name have been found in the given_string
                        exit;
                end if;            
            else            
                if (extract_param_value = true) then                
                    if (set_right_index = true) then                    
                        param_value_right_index := i;
                        set_right_index := false;    
                    end if;
                    param_value_left_index := i;
                elsif (extract_param_name = true) then                
                    if (set_right_index = true) then                    
                        param_name_right_index := i;
                        set_right_index := false;    
                    end if;
                    param_name_left_index := i;    
                end if;
            end if;
        end if;
    end loop;

    -- for the case whether parameter's name is the left most part of the given_string
    if (extract_param_name = true) then
        if(compare_param_name = given_string_tmp(param_name_left_index to param_name_right_index)) then        
            param_found := true;                
        end if;
    end if;

    if(param_found = true) then             
        return given_string_tmp(param_value_left_index to param_value_right_index);    
    else    
        return "";   -- return empty string if parameter not found
    end if;
    
end get_parameter_value;
end LPM_HINT_EVALUATION;
-- END OF PACKAGE 

-- BEGINING OF PACKAGES
Library ieee;
use ieee.std_logic_1164.all;

-- PACKAGE DECLARATION
package LPM_DEVICE_FAMILIES is
-- FUNCTION DECLARATION
    function IS_FAMILY_MAX7000B (device : in string) return boolean;
    function IS_FAMILY_MAX7000AE (device : in string) return boolean;
    function IS_FAMILY_MAX3000A (device : in string) return boolean;
    function IS_FAMILY_MAX7000S (device : in string) return boolean;
    function IS_FAMILY_STRATIX (device : in string) return boolean;
    function IS_FAMILY_STRATIXGX (device : in string) return boolean;
    function IS_FAMILY_CYCLONE (device : in string) return boolean;
    function FEATURE_FAMILY_BASE_STRATIX (device : in string) return boolean;
    function FEATURE_FAMILY_BASE_CYCLONE (device : in string) return boolean;
    function FEATURE_FAMILY_MAX (device : in string) return boolean;
    function IS_VALID_FAMILY (device: in string) return boolean;
end LPM_DEVICE_FAMILIES;

package body LPM_DEVICE_FAMILIES is


function IS_FAMILY_MAX7000B (device : in string) return boolean is
variable is_max7000b : boolean := false;
begin
    if ((device = "MAX7000B") or (device = "max7000b") or (device = "MAX 7000B") or (device = "max 7000b"))
    then
        is_max7000b := true;
    end if;
    return is_max7000b;
end IS_FAMILY_MAX7000B;

function IS_FAMILY_MAX7000AE (device : in string) return boolean is
variable is_max7000ae : boolean := false;
begin
    if ((device = "MAX7000AE") or (device = "max7000ae") or (device = "MAX 7000AE") or (device = "max 7000ae"))
    then
        is_max7000ae := true;
    end if;
    return is_max7000ae;
end IS_FAMILY_MAX7000AE;

function IS_FAMILY_MAX3000A (device : in string) return boolean is
variable is_max3000a : boolean := false;
begin
    if ((device = "MAX3000A") or (device = "max3000a") or (device = "MAX 3000A") or (device = "max 3000a"))
    then
        is_max3000a := true;
    end if;
    return is_max3000a;
end IS_FAMILY_MAX3000A;

function IS_FAMILY_MAX7000S (device : in string) return boolean is
variable is_max7000s : boolean := false;
begin
    if ((device = "MAX7000S") or (device = "max7000s") or (device = "MAX 7000S") or (device = "max 7000s"))
    then
        is_max7000s := true;
    end if;
    return is_max7000s;
end IS_FAMILY_MAX7000S;

function IS_FAMILY_STRATIX (device : in string) return boolean is
variable is_stratix : boolean := false;
begin
    if ((device = "Stratix") or (device = "STRATIX") or (device = "stratix") or (device = "Yeager") or (device = "YEAGER") or (device = "yeager"))
    then
        is_stratix := true;
    end if;
    return is_stratix;
end IS_FAMILY_STRATIX;

function IS_FAMILY_STRATIXGX (device : in string) return boolean is
variable is_stratixgx : boolean := false;
begin
    if ((device = "Stratix GX") or (device = "STRATIX GX") or (device = "stratix gx") or (device = "Stratix-GX") or (device = "STRATIX-GX") or (device = "stratix-gx") or (device = "StratixGX") or (device = "STRATIXGX") or (device = "stratixgx") or (device = "Aurora") or (device = "AURORA") or (device = "aurora"))
    then
        is_stratixgx := true;
    end if;
    return is_stratixgx;
end IS_FAMILY_STRATIXGX;

function IS_FAMILY_CYCLONE (device : in string) return boolean is
variable is_cyclone : boolean := false;
begin
    if ((device = "Cyclone") or (device = "CYCLONE") or (device = "cyclone") or (device = "ACEX2K") or (device = "acex2k") or (device = "ACEX 2K") or (device = "acex 2k") or (device = "Tornado") or (device = "TORNADO") or (device = "tornado"))
    then
        is_cyclone := true;
    end if;
    return is_cyclone;
end IS_FAMILY_CYCLONE;

function FEATURE_FAMILY_BASE_STRATIX (device : in string) return boolean is
variable var_family_base_stratix : boolean := false;
begin
    if (IS_FAMILY_STRATIX(device) or IS_FAMILY_STRATIXGX(device) )
    then
        var_family_base_stratix := true;
    end if;
    return var_family_base_stratix;
end FEATURE_FAMILY_BASE_STRATIX;


function FEATURE_FAMILY_BASE_CYCLONE (device : in string) return boolean is
variable var_family_base_cyclone : boolean := false;
begin
    if (IS_FAMILY_CYCLONE(device) )
    then
        var_family_base_cyclone := true;
    end if;
    return var_family_base_cyclone;
end FEATURE_FAMILY_BASE_CYCLONE;


function FEATURE_FAMILY_MAX (device : in string) return boolean is
variable var_family_max : boolean := false;
begin
    if ((device = "MAX5000") or IS_FAMILY_MAX3000A(device) or (device = "MAX7000") or (device = "MAX7000A") or IS_FAMILY_MAX7000AE(device) or (device = "MAX7000E") or IS_FAMILY_MAX7000S(device) or IS_FAMILY_MAX7000B(device) or (device = "MAX9000") )
    then
        var_family_max := true;
    end if;
    return var_family_max;
end FEATURE_FAMILY_MAX;


function IS_VALID_FAMILY (device : in string) return boolean is
variable is_valid : boolean := false;
begin
    if (((device = "MAX7000B") or (device = "max7000b") or (device = "MAX 7000B") or (device = "max 7000b"))
    or ((device = "MAX7000AE") or (device = "max7000ae") or (device = "MAX 7000AE") or (device = "max 7000ae"))
    or ((device = "MAX3000A") or (device = "max3000a") or (device = "MAX 3000A") or (device = "max 3000a"))
    or ((device = "MAX7000S") or (device = "max7000s") or (device = "MAX 7000S") or (device = "max 7000s"))
    or ((device = "Stratix") or (device = "STRATIX") or (device = "stratix") or (device = "Yeager") or (device = "YEAGER") or (device = "yeager"))
    or ((device = "Stratix GX") or (device = "STRATIX GX") or (device = "stratix gx") or (device = "Stratix-GX") or (device = "STRATIX-GX") or (device = "stratix-gx") or (device = "StratixGX") or (device = "STRATIXGX") or (device = "stratixgx") or (device = "Aurora") or (device = "AURORA") or (device = "aurora"))
    or ((device = "Cyclone") or (device = "CYCLONE") or (device = "cyclone") or (device = "ACEX2K") or (device = "acex2k") or (device = "ACEX 2K") or (device = "acex 2k") or (device = "Tornado") or (device = "TORNADO") or (device = "tornado"))
    or ((device = "MAX II") or (device = "max ii") or (device = "MAXII") or (device = "maxii") or (device = "Tsunami") or (device = "TSUNAMI") or (device = "tsunami"))
    or ((device = "Stratix II") or (device = "STRATIX II") or (device = "stratix ii") or (device = "StratixII") or (device = "STRATIXII") or (device = "stratixii") or (device = "Armstrong") or (device = "ARMSTRONG") or (device = "armstrong"))
    or ((device = "Stratix II GX") or (device = "STRATIX II GX") or (device = "stratix ii gx") or (device = "StratixIIGX") or (device = "STRATIXIIGX") or (device = "stratixiigx"))
    or ((device = "Arria GX") or (device = "ARRIA GX") or (device = "arria gx") or (device = "ArriaGX") or (device = "ARRIAGX") or (device = "arriagx") or (device = "Stratix II GX Lite") or (device = "STRATIX II GX LITE") or (device = "stratix ii gx lite") or (device = "StratixIIGXLite") or (device = "STRATIXIIGXLITE") or (device = "stratixiigxlite"))
    or ((device = "Cyclone II") or (device = "CYCLONE II") or (device = "cyclone ii") or (device = "Cycloneii") or (device = "CYCLONEII") or (device = "cycloneii") or (device = "Magellan") or (device = "MAGELLAN") or (device = "magellan"))
    or ((device = "HardCopy II") or (device = "HARDCOPY II") or (device = "hardcopy ii") or (device = "HardCopyII") or (device = "HARDCOPYII") or (device = "hardcopyii") or (device = "Fusion") or (device = "FUSION") or (device = "fusion"))
    or ((device = "Stratix III") or (device = "STRATIX III") or (device = "stratix iii") or (device = "StratixIII") or (device = "STRATIXIII") or (device = "stratixiii") or (device = "Titan") or (device = "TITAN") or (device = "titan") or (device = "SIII") or (device = "siii"))
    or ((device = "Cyclone III") or (device = "CYCLONE III") or (device = "cyclone iii") or (device = "CycloneIII") or (device = "CYCLONEIII") or (device = "cycloneiii") or (device = "Barracuda") or (device = "BARRACUDA") or (device = "barracuda") or (device = "Cuda") or (device = "CUDA") or (device = "cuda") or (device = "CIII") or (device = "ciii"))
    or ((device = "BS") or (device = "bs"))
    or ((device = "Stratix IV") or (device = "STRATIX IV") or (device = "stratix iv") or (device = "TGX") or (device = "tgx") or (device = "StratixIV") or (device = "STRATIXIV") or (device = "stratixiv") or (device = "Stratix IV (GT)") or (device = "STRATIX IV (GT)") or (device = "stratix iv (gt)") or (device = "Stratix IV (GX)") or (device = "STRATIX IV (GX)") or (device = "stratix iv (gx)") or (device = "Stratix IV (E)") or (device = "STRATIX IV (E)") or (device = "stratix iv (e)") or (device = "StratixIV(GT)") or (device = "STRATIXIV(GT)") or (device = "stratixiv(gt)") or (device = "StratixIV(GX)") or (device = "STRATIXIV(GX)") or (device = "stratixiv(gx)") or (device = "StratixIV(E)") or (device = "STRATIXIV(E)") or (device = "stratixiv(e)") or (device = "StratixIIIGX") or (device = "STRATIXIIIGX") or (device = "stratixiiigx") or (device = "Stratix IV (GT/GX/E)") or (device = "STRATIX IV (GT/GX/E)") or (device = "stratix iv (gt/gx/e)") or (device = "Stratix IV (GT/E/GX)") or (device = "STRATIX IV (GT/E/GX)") or (device = "stratix iv (gt/e/gx)") or (device = "Stratix IV (E/GT/GX)") or (device = "STRATIX IV (E/GT/GX)") or (device = "stratix iv (e/gt/gx)") or (device = "Stratix IV (E/GX/GT)") or (device = "STRATIX IV (E/GX/GT)") or (device = "stratix iv (e/gx/gt)") or (device = "StratixIV(GT/GX/E)") or (device = "STRATIXIV(GT/GX/E)") or (device = "stratixiv(gt/gx/e)") or (device = "StratixIV(GT/E/GX)") or (device = "STRATIXIV(GT/E/GX)") or (device = "stratixiv(gt/e/gx)") or (device = "StratixIV(E/GX/GT)") or (device = "STRATIXIV(E/GX/GT)") or (device = "stratixiv(e/gx/gt)") or (device = "StratixIV(E/GT/GX)") or (device = "STRATIXIV(E/GT/GX)") or (device = "stratixiv(e/gt/gx)") or (device = "Stratix IV (GX/E)") or (device = "STRATIX IV (GX/E)") or (device = "stratix iv (gx/e)") or (device = "StratixIV(GX/E)") or (device = "STRATIXIV(GX/E)") or (device = "stratixiv(gx/e)"))
    or ((device = "tgx_commercial_v1_1") or (device = "TGX_COMMERCIAL_V1_1"))
    or ((device = "Arria II GX") or (device = "ARRIA II GX") or (device = "arria ii gx") or (device = "ArriaIIGX") or (device = "ARRIAIIGX") or (device = "arriaiigx") or (device = "Arria IIGX") or (device = "ARRIA IIGX") or (device = "arria iigx") or (device = "ArriaII GX") or (device = "ARRIAII GX") or (device = "arriaii gx") or (device = "Arria II") or (device = "ARRIA II") or (device = "arria ii") or (device = "ArriaII") or (device = "ARRIAII") or (device = "arriaii") or (device = "Arria II (GX/E)") or (device = "ARRIA II (GX/E)") or (device = "arria ii (gx/e)") or (device = "ArriaII(GX/E)") or (device = "ARRIAII(GX/E)") or (device = "arriaii(gx/e)") or (device = "PIRANHA") or (device = "piranha"))
    or ((device = "HardCopy III") or (device = "HARDCOPY III") or (device = "hardcopy iii") or (device = "HardCopyIII") or (device = "HARDCOPYIII") or (device = "hardcopyiii") or (device = "HCX") or (device = "hcx"))
    or ((device = "HardCopy IV") or (device = "HARDCOPY IV") or (device = "hardcopy iv") or (device = "HardCopyIV") or (device = "HARDCOPYIV") or (device = "hardcopyiv") or (device = "HardCopy IV (GX)") or (device = "HARDCOPY IV (GX)") or (device = "hardcopy iv (gx)") or (device = "HardCopy IV (E)") or (device = "HARDCOPY IV (E)") or (device = "hardcopy iv (e)") or (device = "HardCopyIV(GX)") or (device = "HARDCOPYIV(GX)") or (device = "hardcopyiv(gx)") or (device = "HardCopyIV(E)") or (device = "HARDCOPYIV(E)") or (device = "hardcopyiv(e)") or (device = "HCXIV") or (device = "hcxiv") or (device = "HardCopy IV (GX/E)") or (device = "HARDCOPY IV (GX/E)") or (device = "hardcopy iv (gx/e)") or (device = "HardCopy IV (E/GX)") or (device = "HARDCOPY IV (E/GX)") or (device = "hardcopy iv (e/gx)") or (device = "HardCopyIV(GX/E)") or (device = "HARDCOPYIV(GX/E)") or (device = "hardcopyiv(gx/e)") or (device = "HardCopyIV(E/GX)") or (device = "HARDCOPYIV(E/GX)") or (device = "hardcopyiv(e/gx)"))
    or ((device = "Cyclone III LS") or (device = "CYCLONE III LS") or (device = "cyclone iii ls") or (device = "CycloneIIILS") or (device = "CYCLONEIIILS") or (device = "cycloneiiils") or (device = "Cyclone III LPS") or (device = "CYCLONE III LPS") or (device = "cyclone iii lps") or (device = "Cyclone LPS") or (device = "CYCLONE LPS") or (device = "cyclone lps") or (device = "CycloneLPS") or (device = "CYCLONELPS") or (device = "cyclonelps") or (device = "Tarpon") or (device = "TARPON") or (device = "tarpon") or (device = "Cyclone IIIE") or (device = "CYCLONE IIIE") or (device = "cyclone iiie"))
    or ((device = "Cyclone IV GX") or (device = "CYCLONE IV GX") or (device = "cyclone iv gx") or (device = "Cyclone IVGX") or (device = "CYCLONE IVGX") or (device = "cyclone ivgx") or (device = "CycloneIV GX") or (device = "CYCLONEIV GX") or (device = "cycloneiv gx") or (device = "CycloneIVGX") or (device = "CYCLONEIVGX") or (device = "cycloneivgx") or (device = "Cyclone IV") or (device = "CYCLONE IV") or (device = "cyclone iv") or (device = "CycloneIV") or (device = "CYCLONEIV") or (device = "cycloneiv") or (device = "Cyclone IV (GX)") or (device = "CYCLONE IV (GX)") or (device = "cyclone iv (gx)") or (device = "CycloneIV(GX)") or (device = "CYCLONEIV(GX)") or (device = "cycloneiv(gx)") or (device = "Cyclone III GX") or (device = "CYCLONE III GX") or (device = "cyclone iii gx") or (device = "CycloneIII GX") or (device = "CYCLONEIII GX") or (device = "cycloneiii gx") or (device = "Cyclone IIIGX") or (device = "CYCLONE IIIGX") or (device = "cyclone iiigx") or (device = "CycloneIIIGX") or (device = "CYCLONEIIIGX") or (device = "cycloneiiigx") or (device = "Cyclone III GL") or (device = "CYCLONE III GL") or (device = "cyclone iii gl") or (device = "CycloneIII GL") or (device = "CYCLONEIII GL") or (device = "cycloneiii gl") or (device = "Cyclone IIIGL") or (device = "CYCLONE IIIGL") or (device = "cyclone iiigl") or (device = "CycloneIIIGL") or (device = "CYCLONEIIIGL") or (device = "cycloneiiigl") or (device = "Stingray") or (device = "STINGRAY") or (device = "stingray"))
    or ((device = "Cyclone IV E") or (device = "CYCLONE IV E") or (device = "cyclone iv e") or (device = "CycloneIV E") or (device = "CYCLONEIV E") or (device = "cycloneiv e") or (device = "Cyclone IVE") or (device = "CYCLONE IVE") or (device = "cyclone ive") or (device = "CycloneIVE") or (device = "CYCLONEIVE") or (device = "cycloneive"))
    or ((device = "Stratix V") or (device = "STRATIX V") or (device = "stratix v") or (device = "StratixV") or (device = "STRATIXV") or (device = "stratixv") or (device = "Stratix V (GS)") or (device = "STRATIX V (GS)") or (device = "stratix v (gs)") or (device = "StratixV(GS)") or (device = "STRATIXV(GS)") or (device = "stratixv(gs)") or (device = "Stratix V (GT)") or (device = "STRATIX V (GT)") or (device = "stratix v (gt)") or (device = "StratixV(GT)") or (device = "STRATIXV(GT)") or (device = "stratixv(gt)") or (device = "Stratix V (GX)") or (device = "STRATIX V (GX)") or (device = "stratix v (gx)") or (device = "StratixV(GX)") or (device = "STRATIXV(GX)") or (device = "stratixv(gx)") or (device = "Stratix V (GS/GX)") or (device = "STRATIX V (GS/GX)") or (device = "stratix v (gs/gx)") or (device = "StratixV(GS/GX)") or (device = "STRATIXV(GS/GX)") or (device = "stratixv(gs/gx)") or (device = "Stratix V (GS/GT)") or (device = "STRATIX V (GS/GT)") or (device = "stratix v (gs/gt)") or (device = "StratixV(GS/GT)") or (device = "STRATIXV(GS/GT)") or (device = "stratixv(gs/gt)") or (device = "Stratix V (GT/GX)") or (device = "STRATIX V (GT/GX)") or (device = "stratix v (gt/gx)") or (device = "StratixV(GT/GX)") or (device = "STRATIXV(GT/GX)") or (device = "stratixv(gt/gx)") or (device = "Stratix V (GX/GS)") or (device = "STRATIX V (GX/GS)") or (device = "stratix v (gx/gs)") or (device = "StratixV(GX/GS)") or (device = "STRATIXV(GX/GS)") or (device = "stratixv(gx/gs)") or (device = "Stratix V (GT/GS)") or (device = "STRATIX V (GT/GS)") or (device = "stratix v (gt/gs)") or (device = "StratixV(GT/GS)") or (device = "STRATIXV(GT/GS)") or (device = "stratixv(gt/gs)") or (device = "Stratix V (GX/GT)") or (device = "STRATIX V (GX/GT)") or (device = "stratix v (gx/gt)") or (device = "StratixV(GX/GT)") or (device = "STRATIXV(GX/GT)") or (device = "stratixv(gx/gt)") or (device = "Stratix V (GS/GT/GX)") or (device = "STRATIX V (GS/GT/GX)") or (device = "stratix v (gs/gt/gx)") or (device = "Stratix V (GS/GX/GT)") or (device = "STRATIX V (GS/GX/GT)") or (device = "stratix v (gs/gx/gt)") or (device = "Stratix V (GT/GS/GX)") or (device = "STRATIX V (GT/GS/GX)") or (device = "stratix v (gt/gs/gx)") or (device = "Stratix V (GT/GX/GS)") or (device = "STRATIX V (GT/GX/GS)") or (device = "stratix v (gt/gx/gs)") or (device = "Stratix V (GX/GS/GT)") or (device = "STRATIX V (GX/GS/GT)") or (device = "stratix v (gx/gs/gt)") or (device = "Stratix V (GX/GT/GS)") or (device = "STRATIX V (GX/GT/GS)") or (device = "stratix v (gx/gt/gs)") or (device = "StratixV(GS/GT/GX)") or (device = "STRATIXV(GS/GT/GX)") or (device = "stratixv(gs/gt/gx)") or (device = "StratixV(GS/GX/GT)") or (device = "STRATIXV(GS/GX/GT)") or (device = "stratixv(gs/gx/gt)") or (device = "StratixV(GT/GS/GX)") or (device = "STRATIXV(GT/GS/GX)") or (device = "stratixv(gt/gs/gx)") or (device = "StratixV(GT/GX/GS)") or (device = "STRATIXV(GT/GX/GS)") or (device = "stratixv(gt/gx/gs)") or (device = "StratixV(GX/GS/GT)") or (device = "STRATIXV(GX/GS/GT)") or (device = "stratixv(gx/gs/gt)") or (device = "StratixV(GX/GT/GS)") or (device = "STRATIXV(GX/GT/GS)") or (device = "stratixv(gx/gt/gs)"))
    or ((device = "Arria II GZ") or (device = "ARRIA II GZ") or (device = "arria ii gz") or (device = "ArriaII GZ") or (device = "ARRIAII GZ") or (device = "arriaii gz") or (device = "Arria IIGZ") or (device = "ARRIA IIGZ") or (device = "arria iigz") or (device = "ArriaIIGZ") or (device = "ARRIAIIGZ") or (device = "arriaiigz"))
    or ((device = "arriaiigz_commercial_v1_1") or (device = "ARRIAIIGZ_COMMERCIAL_V1_1"))
    or ((device = "MAX V") or (device = "max v") or (device = "MAXV") or (device = "maxv") or (device = "Jade") or (device = "JADE") or (device = "jade"))
    or ((device = "Arria V") or (device = "ARRIA V") or (device = "arria v") or (device = "ArriaV") or (device = "ARRIAV") or (device = "arriav")))
    then
        is_valid := true;
    end if;
    return is_valid;
end IS_VALID_FAMILY;


end LPM_DEVICE_FAMILIES;
-- END OF PACKAGE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_constant
--
-- Description     :  Parameterized constant generator megafunction. lpm_constant
--                    may be useful for convert a parameter into a constant.
--
-- Limitation      :  n/a
--
-- results Expected:  Value specified by the argument to lpm_cvalue.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_CONSTANT is

-- GENERIC DECLARATION
    generic (
        lpm_width    : natural;     -- Width of the result[] port. (Required)
        lpm_cvalue   : natural;     -- Constant value to be driven out on the
                                    -- result[] port. (Required)
        lpm_strength : string := "UNUSED";
        lpm_type     : string := "LPM_CONSTANT";
        lpm_hint     : string := "UNUSED"
    );
    
-- PORT DECLARATION 
    port (
        -- // Value specified by the argument to lpm_cvalue. (Required)
        result : out std_logic_vector(lpm_width-1 downto 0)
    );
    
end LPM_CONSTANT;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_CONSTANT is
begin
-- PROCESS DECLARATION
    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    result <= conv_std_logic_vector(lpm_cvalue, lpm_width);

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_inv
--
-- Description     :  Parameterized inverter megafunction.
--
-- Limitation      :  n/a
--
-- results Expected:  Inverted value of input data.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_INV is

-- GENERIC DECLARATION
    generic (
        lpm_width : natural;    -- MUST be greater than 0
        lpm_type  : string := "LPM_INV";
        lpm_hint  : string := "UNUSED"
    );

-- PORT DECLARATION 
    port (
        data : in std_logic_vector(lpm_width-1 downto 0);
        result : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_INV;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_INV is
begin

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    result <= not data;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_and
--
-- Description     :  Parameterized AND gate. This megafunction takes in data inputs
--                    for a number of AND gates.
--
-- Limitation      :  n/a
--
-- results Expected:  Each result[] bit is the result of each AND gate.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity lpm_and is
    generic (
        -- Width of the data[][] and result[] ports. Number of AND gates. (Required)
        lpm_width : natural;
        -- Number of inputs to each AND gate. Number of input buses. (Required)
        lpm_size  : natural; 
        lpm_type  : string := "LPM_AND";
        lpm_hint  : string := "UNUSED"
    );

    port (
        -- Data input to the AND gates. (Required)
        data   : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0);
        -- Result of the AND operators. (Required)
        result : out std_logic_vector(lpm_width-1 downto 0)
    );
end lpm_and;

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of lpm_and is

-- SIGNAL DECLARATION
signal result_int : std_logic_2d(lpm_size-1 downto 0,lpm_width-1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_size <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_size parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process; -- MSG process

    L1: for i in 0 to lpm_width-1 generate
            result_int(0,i) <= data(0,i);
    L2:     for j in 0 to lpm_size-2 generate
                result_int(j+1,i) <=  result_int(j,i) and data(j+1,i);
    L3:         if j = lpm_size-2 generate
                    result(i) <= result_int(lpm_size-1,i);
                end generate L3;
            end generate L2;
    L4:     if lpm_size = 1 generate
                result(i) <= result_int(0,i);
            end generate L4;
        end generate L1;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_or
--
-- Description     :  Parameterized OR gate megafunction. This megafunction takes in
--                    data inputs for a number of OR gates.
--
-- Limitation      :  n/a
--
-- results Expected:  Each result[] bit is the result of each OR gate.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_OR is
    generic (
        -- Width of the data[] and result[] ports. Number of OR gates. (Required)
        lpm_width : natural;
        -- Number of inputs to each OR gate. Number of input buses. (Required)
        lpm_size  : natural;
        lpm_type  : string := "LPM_OR";
        lpm_hint  : string := "UNUSED"
    );
    port (
        -- Data input to the OR gates. (Required)
        data   : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0); 
        -- Result of OR operators. (Required)
        result : out std_logic_vector(lpm_width-1 downto 0)); 
end LPM_OR;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_OR is

-- SIGNAL DECLARATION
signal result_int : std_logic_2d(lpm_size-1 downto 0,lpm_width-1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_size <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_size parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;


    L1: for i in 0 to lpm_width-1 generate
            result_int(0,i) <= data(0,i);
    L2:     for j in 0 to lpm_size-2 generate
                result_int(j+1,i) <=  result_int(j,i) or data(j+1,i);
    L3:         if j = lpm_size-2 generate
                    result(i) <= result_int(lpm_size-1,i);
                end generate L3;
            end generate L2;
    L4:     if lpm_size = 1 generate
                result(i) <= result_int(0,i);
            end generate L4;
        end generate L1;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_xor
--
-- Description     :  Parameterized XOR gate megafunction. This megafunction takes in
--                    data inputs for a number of XOR gates.

--
-- Limitation      :  n/a
--
-- results Expected:  Each result[] bit is the result of each XOR gates.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_XOR is
    generic (
        -- Width of the data[] and result[] ports. Number of XOR gates. (Required)
        lpm_width : natural;
        -- Number of inputs to each XOR gate. Number of input buses. (Required)
        lpm_size : natural;
        lpm_type : string := "LPM_XOR";
        lpm_hint : string := "UNUSED");
    port (
        -- data input to the XOR gates. (Required)
        data : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0); 
        -- result of XOR operators. (Required)
        result : out std_logic_vector(lpm_width-1 downto 0)
    ); 
end LPM_XOR;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_XOR is

-- SIGNAL DECLARATION
signal result_int : std_logic_2d(lpm_size-1 downto 0,lpm_width-1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_size <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_size parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    L1: for i in 0 to lpm_width-1 generate
            result_int(0,i) <= data(0,i);
    L2:     for j in 0 to lpm_size-2 generate
                result_int(j+1,i) <=  result_int(j,i) xor data(j+1,i);
    L3:         if j = lpm_size-2 generate
                    result(i) <= result_int(lpm_size-1,i);
                end generate L3;
            end generate L2;
    L4:     if lpm_size = 1 generate
                result(i) <= result_int(0,i);
            end generate L4;
        end generate L1;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_bustri
--
-- Description     :  Parameterized tri-state buffer. lpm_bustri is useful for 
--                    controlling both unidirectional and bidirectional I/O bus 
--                    controllers.
--
-- Limitation      :  n/a
--
-- results Expected:  Belows are the three configurations which are valid:
--
--                    1) Only the input ports data[lpm_width-1..0] and enabledt are
--                       present, and only the output ports tridata[lpm_width-1..0] 
--                       are present. 
--
--                        ----------------------------------------------------
--                       | Input           |  Output                          |
--                       |====================================================|
--                       | enabledt        |     tridata[lpm_width-1..0]      |
--                       |----------------------------------------------------|
--                       |    0            |     Z                            |
--                       |----------------------------------------------------|
--                       |    1            |     data[lpm_width-1..0]         |
--                        ----------------------------------------------------
--
--                    2) Only the input ports tridata[lpm_width-1..0] and enabletr
--                       are present, and only the output ports result[lpm_width-1..0]
--                       are present.
--
--                        ----------------------------------------------------
--                       | Input           |  Output                          |
--                       |====================================================|
--                       | enabletr        |     result[lpm_width-1..0]       |
--                       |----------------------------------------------------|
--                       |    0            |     Z                            |
--                       |----------------------------------------------------|
--                       |    1            |     tridata[lpm_width-1..0]      |
--                        ----------------------------------------------------
--
--                    3) All ports are present: input ports data[lpm_width-1..0],
--                       enabledt, and enabletr; output ports result[lpm_width-1..0];
--                       and bidirectional ports tridata[lpm_width-1..0].
--
--        ----------------------------------------------------------------------------
--       |         Input        |      Bidirectional       |         Output           |
--       |----------------------------------------------------------------------------|
--       | enabledt  | enabletr | tridata[lpm_width-1..0]  |  result[lpm_width-1..0]  |
--       |============================================================================|
--       |    0      |     0    |       Z (input)          |          Z               |
--       |----------------------------------------------------------------------------|
--       |    0      |     1    |       Z (input)          |  tridata[lpm_width-1..0] |
--       |----------------------------------------------------------------------------|
--       |    1      |     0    |     data[lpm_width-1..0] |          Z               |
--       |----------------------------------------------------------------------------|
--       |    1      |     1    |     data[lpm_width-1..0] |  data[lpm_width-1..0]    |
--       ----------------------------------------------------------------------------
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_BUSTRI is

-- GENERIC DECLARATION
    generic (
        lpm_width : natural;    -- MUST be greater than 0 (Required)
        lpm_type  : string := "LPM_BUSTRI";
        lpm_hint  : string := "UNUSED"
    );

-- PORT DECLARATION
    port (
        -- Bidirectional bus signal. (Required)
        tridata : inout std_logic_vector(lpm_width-1 downto 0);
        -- Data input to the tridata[] bus. (Required)
        data : in std_logic_vector(lpm_width-1 downto 0);
        -- If high, enables tridata[] onto the result bus.
        enabletr : in std_logic := '1';
        -- If high, enables data onto the tridata[] bus.
        enabledt : in std_logic := '1';
        -- Output from the tridata[] bus.
        result : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_BUSTRI;

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_BUSTRI is
begin

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    -- get the tri-state buffer output
    BUSTRI: process(data, tridata, enabletr, enabledt)
    begin
        if enabledt = '0' and enabletr = '1' then
            result <= tridata;
        elsif enabledt = '1' and enabletr = '0' then
            result <= (OTHERS => 'Z');
        elsif enabledt = '1' and enabletr = '1' then
            result <= data;
        else
            result <= (OTHERS => 'Z');
        end if;
    end process BUSTRI;
    
-- SIGNAL ASSIGNMENT
    tridata <= data when (enabledt = '1')
        else (OTHERS => 'Z');

end LPM_SYN;

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_mux
--
-- Description     :  Parameterized multiplexer megafunctions.
--
-- Limitation      :  n/a
--
-- results Expected:  Selected input port.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_MUX is

-- GENERIC DECLARATION
    generic (
        lpm_width    : natural;  -- Width of the data[][] and result[] ports. (Required)
        lpm_size     : natural;  -- Number of input buses to the multiplexer. (Required)
        lpm_widths   : natural;  -- Width of the sel[] input port. (Required)
        lpm_pipeline : natural := 0;-- Specifies the number of Clock cycles of latency
                                    -- associated with the result[] output.
        lpm_type     : string := "LPM_MUX";
        lpm_hint     : string := "UNUSED"
    );

-- PORT DECLARATION 
    port (
        -- Data input. (Required)
        data  : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0);
        -- Selects one of the input buses. (Required)
        sel   : in std_logic_vector(lpm_widths-1 downto 0); 
        -- Clock for pipelined usage
        clock : in std_logic := '0';
        -- Asynchronous clear for pipelined usage.
        aclr  : in std_logic := '0';
        -- Clock enable for pipelined usage.
        clken : in std_logic := '1';
        -- Selected input port. (Required)
        result : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_MUX;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_MUX is

-- TYPE DECLARATION
type t_resulttmp IS ARRAY (0 to lpm_pipeline) of std_logic_vector(lpm_width-1 downto 0);

begin

-- PROCESS DECLARATION
    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_size <= 1) then
            ASSERT FALSE
            REPORT "Value of lpm_size parameter must be greater than 1!"
            SEVERITY ERROR;
        end if;
        
        if (lpm_widths <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widths parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_pipeline < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_pipeline parameter must be greater than or equal to 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process (aclr, clock, sel, data, clken)
    variable resulttmp : t_resulttmp;
    variable sel_int : integer;
    begin
        if (lpm_pipeline >= 0) then
            sel_int := conv_integer(sel);

            for i in 0 to lpm_width-1 loop
                if (sel_int < lpm_size) then 
                    resulttmp(lpm_pipeline)(i) := data(sel_int,i);
                else
                    resulttmp(lpm_pipeline)(i) := 'X';
                end if;
            end loop;

            if (lpm_pipeline > 0) then
                if (aclr = '1') then
                    for i in 0 to lpm_pipeline loop
                        resulttmp(i) := (OTHERS => '0');
                    end loop;
                elsif (rising_edge(clock) and clken = '1') then
                    resulttmp(0 to lpm_pipeline - 1) := resulttmp(1 to lpm_pipeline);
                end if;
            end if;

            result <= resulttmp(0);
        end if;
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_decode
--
-- Description     :  Parameterized decoder megafunction.
--
-- Limitation      :  n/a
--
-- Results Expected:  Decoded output.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_DECODE is
    generic (
        -- Width of the data[] port, or the input value to be decoded. (Required)
        lpm_width    : natural;
        -- Number of explicit decoder outputs. (Required)
        lpm_decodes  : natural;
        -- Number of Clock cycles of latency 
        lpm_pipeline : natural := 0;
        lpm_type     : string  := "LPM_DECODE";
        lpm_hint     : string  := "UNUSED"
    );
    
    port (
        -- Data input. Treated as an unsigned binary encoded number. (Required)
        data : in std_logic_vector(lpm_width-1 downto 0);
        -- Enable. All outputs low when not active.
        enable : in std_logic := '1';
        -- Clock for pipelined usage.
        clock : in std_logic := '0';
        -- Asynchronous clear for pipelined usage.
        aclr : in std_logic := '0';
        -- Clock enable for pipelined usage.
        clken : in std_logic := '1';
        -- Decoded output. (Required)
        eq : out std_logic_vector(lpm_decodes-1 downto 0)
    );
end LPM_DECODE;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_DECODE is

-- TYPE DECLARATION
type t_eqtmp IS ARRAY (0 to lpm_pipeline) of std_logic_vector(lpm_decodes-1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_decodes <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_decodes parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        if (lpm_decodes > (2**lpm_width)) then
            ASSERT FALSE
            REPORT "Value of lpm_decodes parameter must be less or equal to 2^lpm_width!"
            SEVERITY ERROR;
        end if;

        if (lpm_pipeline < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_pipeline parameter must be greater or equal to 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process(aclr, clock, data, enable)
    variable eqtmp : t_eqtmp;
    begin

        for i in 0 to lpm_decodes-1 loop
            if (conv_integer(data) = i) then
                if (enable = '1') then
                    eqtmp(lpm_pipeline)(i) := '1';
                else
                    eqtmp(lpm_pipeline)(i) := '0';
                end if;
            else
                eqtmp(lpm_pipeline)(i) := '0';
            end if;
        end loop;

        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                for i in 0 to lpm_pipeline loop
                    eqtmp(i) := (OTHERS => '0');
                end loop;
            end if;
        elsif (clock'event and (clock = '1')) then
            if ((clken = '1') and (lpm_pipeline > 0)) then
                eqtmp(0 to lpm_pipeline - 1) := eqtmp(1 to lpm_pipeline);
            end if;
        end if;

        eq <= eqtmp(0);
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_clshift
--
-- Description     :  Parameterized combinatorial logic shifter or barrel shifter
--                    megafunction.
--
-- Limitation      :  n/a
--
-- results Expected:  Return the shifted data and underflow/overflow status bit.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_CLSHIFT is

-- GENERIC DECLARATION
    generic (
        lpm_width     : natural;    -- Width of the data[] and result[] ports.
                                    -- MUST be greater than 0 (Required)                                    
        lpm_widthdist : natural;    -- Width of the distance[] input port.
                                    -- MUST be greater than 0 (Required)
        lpm_shifttype : string := "LOGICAL"; -- Type of shifting operation to be performed.
        lpm_pipeline  : natural := 0; -- Number of Clock cycles of latency.
        lpm_type      : string := "LPM_CLSHIFT";
        lpm_hint      : string := "UNUSED"
    );

-- PORT DECLARATION 
    port (
        -- data to be shifted. (Required)
        data      : in STD_LOGIC_VECTOR(lpm_width-1 downto 0); 
        -- Number of positions to shift data[] in the direction specified by the
        -- direction port. (Required)
        distance  : in STD_LOGIC_VECTOR(lpm_widthdist-1 downto 0); 
        -- direction of shift. Low = left (toward the MSB), high = right (toward the LSB). 
        direction : in STD_LOGIC := '0';
        -- Clock for pipelined usage.
        clock     : in std_logic := '0';
        -- Asynchronous clear for pipelined usage.
        aclr      : in std_logic := '0';
        -- Clock enable for pipelined usage.
        clken     : in std_logic := '1';
        -- Shifted data. (Required)
        result    : out STD_LOGIC_VECTOR(lpm_width-1 downto 0);
        -- Logical or arithmetic underflow.
        underflow : out STD_LOGIC;
        -- Logical or arithmetic overflow.
        overflow  : out STD_LOGIC
    );
end LPM_CLSHIFT;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_CLSHIFT is

-- TYPE DECLARATION
type t_resulttmp IS ARRAY (0 to lpm_pipeline) of std_logic_vector(lpm_width-1 downto 0);

-- SIGNAL DECLARATION
signal i_result : std_logic_vector(lpm_width-1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        if (lpm_widthdist <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthdist parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;   
        wait;
    end process MSG;

    -- Get the shifted data
    process(data, distance, direction)
    variable tmpdata : std_logic_vector(lpm_width-1 downto 0);
    variable tmpdist : integer;
    begin
        if ((lpm_shifttype = "ARITHMETIC") or (lpm_shifttype = "LOGICAL")) then
            tmpdata := conv_std_logic_vector(unsigned(data), lpm_width);
            tmpdist := conv_integer(unsigned(distance));
            for i in lpm_width-1 downto 0 loop
                if (direction = '0') then
                    if (i >= tmpdist) then
                        i_result(i) <= tmpdata(i-tmpdist);
                    else
                        i_result(i) <= '0';
                    end if;
                elsif (direction = '1') then
                    if ((i+tmpdist) < lpm_width) then
                        i_result(i) <= tmpdata(i+tmpdist);
                    elsif (lpm_shifttype = "ARITHMETIC") then
                        i_result(i) <= data(lpm_width-1);
                    else
                        i_result(i) <= '0';
                    end if;
                end if;
            end loop;
        elsif (lpm_shifttype = "ROTATE") then
            tmpdata := conv_std_logic_vector(unsigned(data), lpm_width);
            tmpdist := conv_integer(unsigned(distance)) mod lpm_width;
            for i in lpm_width-1 downto 0 loop
                if (direction = '0') then
                    if (i >= tmpdist) then
                        i_result(i) <= tmpdata(i-tmpdist);
                    else
                        i_result(i) <= tmpdata(i+lpm_width-tmpdist);
                    end if;
                elsif (direction = '1') then
                    if (i+tmpdist < lpm_width) then
                        i_result(i) <= tmpdata(i+tmpdist);
                    else
                        i_result(i) <= tmpdata(i-lpm_width+tmpdist);
                    end if;
                end if;
            end loop;
        else
            ASSERT FALSE
            REPORT "Illegal lpm_shifttype property value for LPM_CLSHIFT!"
            SEVERITY ERROR;
        end if;
    end process;

    -- Get the overflow/underflow status bit.
    process(aclr, clock, data, distance, direction, i_result)
    variable neg_one : signed(lpm_width-1 downto 0) := (OTHERS => '1');
    variable tmpdata : std_logic_vector(lpm_width-1 downto 0);
    variable tmpdist : integer;
    variable msb_cnt : integer := 0;
    variable lsb_cnt : integer := 0;
    variable sgn_bit : std_logic;
    variable result_pipe : t_resulttmp := (OTHERS => (OTHERS => '0'));
    variable overflow_pipe : std_logic_vector(0 to lpm_pipeline) := (OTHERS => '0');
    variable underflow_pipe : std_logic_vector(0 to lpm_pipeline) := (OTHERS => '0');
    begin
        tmpdata := conv_std_logic_vector(unsigned(data), lpm_width);
        tmpdist := conv_integer(distance);

        result_pipe(lpm_pipeline) := i_result;
        overflow_pipe(lpm_pipeline) := '0';
        underflow_pipe(lpm_pipeline) := '0';

        if ((tmpdist /= 0) and (tmpdata /= 0)) then
            if (lpm_shifttype = "ROTATE") then
                overflow_pipe(lpm_pipeline) := 'U';
                underflow_pipe(lpm_pipeline) := 'U';
            else
                if (tmpdist < lpm_width) then
                    if (lpm_shifttype = "LOGICAL") then
                        msb_cnt := 0;
                        while ((msb_cnt < lpm_width) and
                                (tmpdata(lpm_width-msb_cnt-1) = '0')) loop
                            msb_cnt := msb_cnt + 1;
                        end loop;

                        if ((tmpdist > msb_cnt) and (direction = '0')) then
                            overflow_pipe(lpm_pipeline) := '1';
                        elsif ((tmpdist + msb_cnt >= lpm_width) and (direction = '1')) then
                            underflow_pipe(lpm_pipeline) := '1';
                        end if;
                    elsif (lpm_shifttype = "ARITHMETIC") then
                        sgn_bit := '0';
                        if (tmpdata(lpm_width-1) = '1') then
                            sgn_bit := '1';
                        end if;

                        msb_cnt := 0;
                        while ((msb_cnt < lpm_width) and
                                (tmpdata(lpm_width-msb_cnt-1) = sgn_bit)) loop
                            msb_cnt := msb_cnt + 1;
                        end loop;

                        lsb_cnt := 0;
                        while ((lsb_cnt < lpm_width) and (tmpdata(lsb_cnt) = '0')) loop
                            lsb_cnt := lsb_cnt + 1;
                        end loop;

                        if (direction = '1') then         -- shift right
                            if (tmpdata(lpm_width-1) = '1') then  -- negative
                                if ((msb_cnt + tmpdist >= lpm_width) and 
                                    (msb_cnt /= lpm_width)) then
                                    underflow_pipe(lpm_pipeline) := '1';
                                end if;
                            else  -- non-neg
                                if (((msb_cnt + tmpdist) >= lpm_width) and
                                    (msb_cnt /= lpm_width)) then
                                    underflow_pipe(lpm_pipeline) := '1';
                                end if;
                            end if;
                        elsif (direction = '0') then      -- shift left
                            if (tmpdata(lpm_width-1) = '1') then -- negative
                                if (((signed(tmpdata) /= neg_one) and
                                    (tmpdist >= lpm_width)) or (tmpdist >= msb_cnt)) then
                                    overflow_pipe(lpm_pipeline) := '1';
                                end if;
                            else  -- non-neg
                                if (((tmpdata /= 0) and (tmpdist >= lpm_width-1)) or
                                    (tmpdist >= msb_cnt)) then
                                    overflow_pipe(lpm_pipeline) := '1';
                                end if;
                            end if;
                        end if;
                    end if;
                else
                    if (direction = '0') then
                        overflow_pipe(lpm_pipeline) := '1';
                    elsif (direction = '1') then
                        underflow_pipe(lpm_pipeline) := '1';
                    end if;
                end if;  -- tmpdist < lpm_width
            end if;  -- lpm_shifttype = "ROTATE"
        end if;  -- tmpdist /= 0 and tmpdata /= 0
        
        
        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                result_pipe := (OTHERS => (OTHERS => '0'));
                overflow_pipe := (OTHERS => '0');
                underflow_pipe := (OTHERS => '0');
            end if;
        elsif (clock'event and (clock = '1')) then
            if ((clken = '1') and (lpm_pipeline > 0)) then
                result_pipe(0 to lpm_pipeline - 1) := result_pipe(1 to lpm_pipeline);
                overflow_pipe(0 to lpm_pipeline - 1) := overflow_pipe(1 to lpm_pipeline);
                underflow_pipe(0 to lpm_pipeline - 1) := underflow_pipe(1 to lpm_pipeline);
            end if;
        end if;

        result <= result_pipe(0);
        overflow <= overflow_pipe(0);
        underflow <= underflow_pipe(0);

    end process;

end LPM_SYN;
-- END OF ARCHITECTURE
---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_add_sub_signed
--
-- Description     :  This entity is instiatiated by lpm_add_sub megafunction to perform
--                    adder/subtrator function for signed number.
--
-- Limitation      :  n/a
--
-- Results Expected:  If performs as adder, the result will be dataa[]+datab[]+cin.
--                    If performs as subtractor, the result will be dataa[]-datab[]+cin-1.
--                    Also returns carry out bit and overflow status bit.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_ADD_SUB_SIGNED is
    generic (
        lpm_width     : natural;    -- MUST be greater than 0
        lpm_direction : string := "UNUSED";
        lpm_pipeline  : natural := 0;
        lpm_type      : string := "LPM_ADD_SUB";
        lpm_hint      : string := "UNUSED"
    );
    
    port (
        dataa   : in std_logic_vector(lpm_width downto 1);
        datab   : in std_logic_vector(lpm_width downto 1);
        cin     : in std_logic := 'Z';
        add_sub : in std_logic := '1';
        clock   : in std_logic := '0';
        aclr    : in std_logic := '0';
        clken   : in std_logic := '1';
        result   : out std_logic_vector(lpm_width-1 downto 0);
        cout     : out std_logic;
        overflow : out std_logic
    );
    
end LPM_ADD_SUB_SIGNED;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_ADD_SUB_SIGNED is

-- SIGNAL DECLARATION
signal i_dataa, i_datab : std_logic_vector(lpm_width downto 0);

-- TYPE DECLARATION
type T_RESULTTMP IS ARRAY (0 to lpm_pipeline) of std_logic_vector(lpm_width downto 0);

begin

    i_dataa <= (dataa(lpm_width) & dataa);
    i_datab <= (datab(lpm_width) & datab);

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_pipeline < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_pipeline parameter must be greater than or equal to 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process(aclr, clock, i_dataa, i_datab, cin, add_sub)
    variable resulttmp : T_RESULTTMP := (OTHERS => (OTHERS => '0'));
    variable couttmp : std_logic_vector(0 to lpm_pipeline) := (OTHERS => '0');
    variable overflowtmp : std_logic_vector(0 to lpm_pipeline) := (OTHERS => '0');
    variable i_cin : std_logic;
    begin
        if ((lpm_direction = "ADD") or
            (((lpm_direction = "UNUSED") or (lpm_direction = "DEFAULT"))and (add_sub = '1'))) then
            if (cin = 'Z') then
                i_cin := '0';
            else
                i_cin := cin;
            end if;

            -- Perform as adder
            resulttmp(lpm_pipeline) := i_dataa + i_datab + i_cin;
            couttmp(lpm_pipeline) :=    resulttmp(lpm_pipeline)(lpm_width) xor
                                        i_dataa(lpm_width) xor
                                        i_datab(lpm_width);

            if ((i_dataa(lpm_width) = '0') and (i_datab(lpm_width) = '0') and 
                (resulttmp(lpm_pipeline)(lpm_width-1) = '1'))  or
                ((i_dataa(lpm_width) = '1') and (i_datab(lpm_width) = '1') and 
                (resulttmp(lpm_pipeline)(lpm_width-1) = '0')) then
                overflowtmp(lpm_pipeline) := '1';   
            else
                overflowtmp(lpm_pipeline) := '0';
            end if;
        elsif ((lpm_direction = "SUB") or
                (((lpm_direction = "UNUSED") or (lpm_direction = "DEFAULT")) and (add_sub = '0'))) then
            if (cin = 'Z') then
                i_cin := '1';
            else
                i_cin := cin;
            end if;

            -- Perform as subtrator
            resulttmp(lpm_pipeline) := i_dataa - i_datab + i_cin - 1;
            couttmp(lpm_pipeline) :=    (not resulttmp(lpm_pipeline)(lpm_width)) xor
                                        i_dataa(lpm_width) xor
                                        i_datab(lpm_width);

            if ((i_dataa(lpm_width) = '0') and (i_datab(lpm_width) = '1') and 
                (resulttmp(lpm_pipeline)(lpm_width-1) = '1'))  or
                ((i_dataa(lpm_width) = '1') and (i_datab(lpm_width) = '0') and 
                (resulttmp(lpm_pipeline)(lpm_width-1) = '0')) then
                overflowtmp(lpm_pipeline) := '1';   
            else
                overflowtmp(lpm_pipeline) := '0';
            end if;
        elsif ((lpm_direction /= "UNUSED") and (lpm_direction /= "DEFAULT")) then
            ASSERT FALSE
            REPORT "Illegal lpm_direction property value for LPM_ADD_SUB!"
            SEVERITY ERROR;
        end if;
            
        -- Pipeline the result
        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                overflowtmp := (OTHERS => '0');
                couttmp := (OTHERS => '0');
                for i in 0 to lpm_pipeline loop
                    resulttmp(i) := (OTHERS => '0');
                end loop;
            end if;
        elsif (clock'event and (clock = '1')) then
            if ((clken = '1') and (lpm_pipeline > 0)) then
                overflowtmp(0 to lpm_pipeline - 1) := overflowtmp(1 to lpm_pipeline);
                couttmp(0 to lpm_pipeline - 1) := couttmp(1 to lpm_pipeline);
                resulttmp(0 to lpm_pipeline - 1) := resulttmp(1 to lpm_pipeline);
            end if;
        end if;

        -- send the pipeline result to output ports
        cout <= couttmp(0);
        overflow <= overflowtmp(0);
        result <= resulttmp(0)(lpm_width-1 downto 0);
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE


---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_add_sub_unsigned
--
-- Description     :  This entity is instiatiated by lpm_add_sub megafunction to perform
--                    adder/subtrator function for unsigned number.
--
-- Limitation      :  n/a
--
-- Results Expected:  If performs as adder, the result will be dataa[]+datab[]+cin.
--                    If performs as subtractor, the result will be dataa[]-datab[]+cin-1.
--                    Also returns carry out bit and overflow status bit.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_ADD_SUB_UNSIGNED is
    generic (
        lpm_width      : natural;    -- MUST be greater than 0
        lpm_direction  : string  := "UNUSED";
        lpm_pipeline   : natural := 0;
        lpm_type       : string  := "LPM_ADD_SUB";
        lpm_hint       : string  := "UNUSED"
    );
    
    port (
        dataa   : in std_logic_vector(lpm_width-1 downto 0);
        datab   : in std_logic_vector(lpm_width-1 downto 0);
        cin     : in std_logic := 'Z';
        add_sub : in std_logic := '1';
        clock   : in std_logic := '0';
        aclr    : in std_logic := '0';
        clken   : in std_logic := '1';
        result   : out std_logic_vector(lpm_width-1 downto 0);
        cout     : out std_logic;
        overflow : out std_logic
    );
end LPM_ADD_SUB_UNSIGNED;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_ADD_SUB_UNSIGNED is

-- SIGNAL DECLARATION
signal i_dataa, i_datab : std_logic_vector(lpm_width downto 0);

-- TYPE DECLARATION
type T_RESULTTMP IS ARRAY (0 to lpm_pipeline) of std_logic_vector(lpm_width downto 0);

begin

    i_dataa <= ('0' & dataa);
    i_datab <= ('0' & datab);

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_pipeline < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_pipeline parameter must be greater than or equal to 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process(aclr, clock, i_dataa, i_datab, cin, add_sub)
    variable resulttmp   : T_RESULTTMP := (OTHERS => (OTHERS => '0'));
    variable couttmp     : std_logic_vector(0 to lpm_pipeline) := (OTHERS => '0');
    variable overflowtmp : std_logic_vector(0 to lpm_pipeline) := (OTHERS => '0');
    variable i_cin       : std_logic;
    begin

        if ((lpm_direction = "ADD") or
            (((lpm_direction = "UNUSED") or (lpm_direction = "DEFAULT")) and (add_sub = '1'))) then
            if (cin = 'Z') then
                i_cin := '0';
            else
                i_cin := cin;
            end if;

            -- Perform as adder
            resulttmp(lpm_pipeline) := i_dataa + i_datab + i_cin;
            couttmp(lpm_pipeline)   := resulttmp(lpm_pipeline)(lpm_width);
        elsif ((lpm_direction = "SUB") or
                (((lpm_direction = "UNUSED")  or (lpm_direction = "DEFAULT")) and (add_sub = '0'))) then
            if (cin = 'Z') then
                i_cin := '1';
            else
                i_cin := cin;
            end if;

            -- Perform as subtractor
            resulttmp(lpm_pipeline) := i_dataa - i_datab + i_cin - 1;
            couttmp(lpm_pipeline)   := not resulttmp(lpm_pipeline)(lpm_width);
        elsif ((lpm_direction /= "UNUSED") and (lpm_direction /= "DEFAULT")) then
            ASSERT FALSE
            REPORT "Illegal lpm_direction property value for LPM_ADD_SUB!"
            SEVERITY ERROR;
        end if;

        overflowtmp(lpm_pipeline) := resulttmp(lpm_pipeline)(lpm_width);

        -- Pipeline the result
        if (aclr = '1') then
            if (lpm_pipeline > 0) then 
                overflowtmp := (OTHERS => '0');
                couttmp := (OTHERS => '0');
                for i in 0 to lpm_pipeline loop
                    resulttmp(i) := (OTHERS => '0');
                end loop;
            end if;
        elsif (clock'event and (clock = '1') ) then
            if ((clken = '1') and (lpm_pipeline > 0)) then 
                overflowtmp(0 to lpm_pipeline - 1) := overflowtmp(1 to lpm_pipeline);
                couttmp(0 to lpm_pipeline - 1) := couttmp(1 to lpm_pipeline);
                resulttmp(0 to lpm_pipeline - 1) := resulttmp(1 to lpm_pipeline);
            end if;
        end if;

        -- Send the pipelined result to output ports
        cout <= couttmp(0);
        overflow <= overflowtmp(0);
        result <= resulttmp(0)(lpm_width-1 downto 0);
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE


---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_add_sub
--
-- Description     :  Parameterized adder/subtractor megafunction.
--
-- Limitation      :  n/a
--
-- Results Expected:  If performs as adder, the result will be dataa[]+datab[]+cin.
--                    If performs as subtractor, the result will be dataa[]-datab[]+cin-1.
--                    Also returns carry out bit and overflow status bit.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;
use work.LPM_ADD_SUB_SIGNED;
use work.LPM_ADD_SUB_UNSIGNED;

-- ENTITY DECLARATION
entity LPM_ADD_SUB is
    generic (
        lpm_width          : natural;    -- MUST be greater than 0
        lpm_representation : string := "SIGNED";
        lpm_direction      : string := "UNUSED";
        lpm_pipeline       : natural := 0;
        lpm_type           : string := "LPM_ADD_SUB";
        lpm_hint           : string := "UNUSED"
    );
    
    port (
        dataa   : in std_logic_vector(lpm_width-1 downto 0);
        datab   : in std_logic_vector(lpm_width-1 downto 0);
        cin     : in std_logic := 'Z';
        add_sub : in std_logic := '1';
        clock   : in std_logic := '0';
        aclr    : in std_logic := '0';
        clken   : in std_logic := '1';
        result   : out std_logic_vector(lpm_width-1 downto 0);
        cout     : out std_logic;
        overflow : out std_logic
    );
end LPM_ADD_SUB;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_ADD_SUB is

-- COMPONENT DECLARATION
    component LPM_ADD_SUB_SIGNED
            generic (
                lpm_width     : natural;    -- MUST be greater than 0
                lpm_direction : string := "UNUSED";
                lpm_pipeline  : natural := 0;
                lpm_type      : string := "LPM_ADD_SUB";
                lpm_hint      : string := "UNUSED"
            );
            port (
                dataa   : in std_logic_vector(lpm_width downto 1);
                datab   : in std_logic_vector(lpm_width downto 1);
                cin     : in std_logic := 'Z';
                add_sub : in std_logic := '1';
                clock   : in std_logic := '0';
                aclr    : in std_logic := '0';
                clken   : in std_logic := '1';
                result   : out std_logic_vector(lpm_width-1 downto 0);
                cout     : out std_logic;
                overflow : out std_logic
            );
    end component;

    component LPM_ADD_SUB_UNSIGNED
            generic (
                lpm_width     : natural;    -- MUST be greater than 0
                lpm_direction : string := "UNUSED";
                lpm_pipeline  : natural := 0;
                lpm_type      : string := "LPM_ADD_SUB";
                lpm_hint      : string := "UNUSED"
            );
            port (
                dataa   : in std_logic_vector(lpm_width-1 downto 0);
                datab   : in std_logic_vector(lpm_width-1 downto 0);
                cin     : in std_logic := 'Z';
                add_sub : in std_logic := '1';
                clock   : in std_logic := '0';
                aclr    : in std_logic := '0';
                clken   : in std_logic := '1';
                result   : out std_logic_vector(lpm_width-1 downto 0);
                cout     : out std_logic;
                overflow : out std_logic
            );
    end component;


begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
    
        if ((lpm_representation /= "SIGNED") and
            (lpm_representation /= "UNSIGNED")) then
            ASSERT FALSE
            REPORT "Value of lpm_representation parameter must be SIGNED or UNSIGNED!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    L1: if (lpm_representation = "UNSIGNED") generate

        U:  LPM_ADD_SUB_UNSIGNED
            generic map (
                lpm_width => lpm_width,
                lpm_direction => lpm_direction,
                lpm_pipeline => lpm_pipeline, 
                lpm_type => lpm_type,
                lpm_hint => lpm_hint
            )
        
            port map (
                dataa => dataa,
                datab => datab,
                cin => cin,
                add_sub => add_sub,
                clock => clock,
                aclr => aclr,
                clken => clken,
                result => result,
                cout => cout,
                overflow => overflow
            );
            end generate;

    L2: if (lpm_representation = "SIGNED") generate

        V:  LPM_ADD_SUB_SIGNED
            generic map (
                lpm_width => lpm_width,
                lpm_direction => lpm_direction,
                lpm_pipeline => lpm_pipeline,
                lpm_type => lpm_type,
                lpm_hint => lpm_hint
            )
            
            port map (
                dataa => dataa,
                datab => datab,
                cin => cin,
                add_sub => add_sub,
                clock => clock,
                aclr => aclr,
                clken => clken,
                result => result,
                cout => cout,
                overflow => overflow
            );
        end generate;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_compare_signed
--
-- Description     :  This module is used in lpm_compare megafunction when
--                    type of comparison is "SIGNED".
--
-- Limitation      :  n/a
--
-- Results Expected:  Return status bits of the comparision between dataa[] and
--                    datab[].
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_COMPARE_SIGNED is

-- GENERIC DECLARATION
    generic (
        -- Width of the dataa[] and datab[] ports. (Required)
        lpm_width    : natural;        
        -- Specifies the number of clock cycles of latency associated with the
        -- alb, aeb, agb, ageb, aleb or aneb output.
        lpm_pipeline : natural := 0;
        lpm_type     : string  := "LPM_COMPARE";
        lpm_hint     : string  := "UNUSED"
    );
        
-- PORT DECLARATION 
    port (
        -- Value to be compared to datab[]. (Required)
        dataa : in std_logic_vector(lpm_width-1 downto 0);
        -- Value to be compared to dataa[]. (Required)
        datab : in std_logic_vector(lpm_width-1 downto 0);
        -- clock for pipelined usage.
        clock : in std_logic := '0';
        -- Asynchronous clear for pipelined usage.
        aclr  : in std_logic := '0';
        -- clock enable for pipelined usage.
        clken : in std_logic := '1';
        
        -- One of the following ports must be present.
        alb  : out std_logic;  -- High (1) if dataa[] < datab[].
        aeb  : out std_logic;  -- High (1) if dataa[] == datab[].
        agb  : out std_logic;  -- High (1) if dataa[] > datab[].
        aleb : out std_logic;  -- High (1) if dataa[] <= datab[].
        aneb : out std_logic;  -- High (1) if dataa[] != datab[].
        ageb : out std_logic   -- High (1) if dataa[] >= datab[].
    );
end LPM_COMPARE_SIGNED;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_COMPARE_SIGNED is
begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        if (lpm_pipeline < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_pipeline parameter must NOT less than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    -- perform the data comparison
    process(aclr, clock, dataa, datab)
    variable agbtmp : std_logic_vector (0 to lpm_pipeline);
    variable agebtmp : std_logic_vector (0 to lpm_pipeline);
    variable aebtmp : std_logic_vector (0 to lpm_pipeline);
    variable anebtmp : std_logic_vector (0 to lpm_pipeline);
    variable albtmp : std_logic_vector (0 to lpm_pipeline);
    variable alebtmp : std_logic_vector (0 to lpm_pipeline);

    begin       
        -- get the status of comparation
        if (signed(dataa) > signed(datab)) then
            agbtmp(lpm_pipeline) := '1';
            agebtmp(lpm_pipeline) := '1';
            anebtmp(lpm_pipeline) := '1';
            aebtmp(lpm_pipeline) := '0';
            albtmp(lpm_pipeline) := '0';
            alebtmp(lpm_pipeline) := '0';
        elsif (signed(dataa) = signed(datab)) then
            agbtmp(lpm_pipeline) := '0';
            agebtmp(lpm_pipeline) := '1';
            anebtmp(lpm_pipeline) := '0';
            aebtmp(lpm_pipeline) := '1';
            albtmp(lpm_pipeline) := '0';
            alebtmp(lpm_pipeline) := '1';
        else
            agbtmp(lpm_pipeline) := '0';
            agebtmp(lpm_pipeline) := '0';
            anebtmp(lpm_pipeline) := '1';
            aebtmp(lpm_pipeline) := '0';
            albtmp(lpm_pipeline) := '1';
            alebtmp(lpm_pipeline) := '1';
        end if;

        -- if lpm_pipine > 0, then create latency on the output result            
        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                for i in 0 to lpm_pipeline loop
                    agbtmp(i) := '0';
                    agebtmp(i) := '0';
                    anebtmp(i) := '0';
                    aebtmp(i) := '0';
                    albtmp(i) := '0';
                    alebtmp(i) := '0';
                end loop;
            end if;
        elsif (clock'event and (clock = '1')) then
            if ((clken = '1') and (lpm_pipeline > 0)) then
                agbtmp(0 to lpm_pipeline-1) :=  agbtmp(1 to lpm_pipeline);
                agebtmp(0 to lpm_pipeline-1) := agebtmp(1 to lpm_pipeline) ;
                anebtmp(0 to lpm_pipeline-1) := anebtmp(1 to lpm_pipeline);
                aebtmp(0 to lpm_pipeline-1) := aebtmp(1 to lpm_pipeline);
                albtmp(0 to lpm_pipeline-1) := albtmp(1 to lpm_pipeline);
                alebtmp(0 to lpm_pipeline-1) := alebtmp(1 to lpm_pipeline);
            end if;
        end if;

        agb <= agbtmp(0);
        ageb <= agebtmp(0);
        aneb <= anebtmp(0);
        aeb <= aebtmp(0);
        alb <= albtmp(0);
        aleb <= alebtmp(0);
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_compare_unsigned
--
-- Description     :  This module is used in lpm_compare megafunction when
--                    type of comparison is "UNSIGNED".
--
-- Limitation      :  n/a
--
-- Results Expected:  Return status bits of the comparision between dataa[] and
--                    datab[].
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_COMPARE_UNSIGNED is

-- GENERIC DECLARATION
    generic (
        -- Width of the dataa[] and datab[] ports. (Required)
        lpm_width    : natural;
        -- Specifies the number of clock cycles of latency associated with the
        -- alb, aeb, agb, ageb, aleb or aneb output.
        lpm_pipeline : natural := 0;
        lpm_type     : string  := "LPM_COMPARE";
        lpm_hint     : string  := "UNUSED"
    );

-- PORT DECLARATION 
    port (
        -- Value to be compared to datab[]. (Required)
        dataa : in std_logic_vector(lpm_width-1 downto 0);
        -- Value to be compared to dataa[]. (Required)
        datab : in std_logic_vector(lpm_width-1 downto 0);
        -- clock for pipelined usage.
        clock : in std_logic := '0';
        -- Asynchronous clear for pipelined usage.
        aclr  : in std_logic := '0';
        -- clock enable for pipelined usage.
        clken : in std_logic := '1';
        
        -- One of the following ports must be present.
        alb  : out std_logic;  -- High (1) if dataa[] < datab[].
        aeb  : out std_logic;  -- High (1) if dataa[] == datab[].
        agb  : out std_logic;  -- High (1) if dataa[] > datab[].
        aleb : out std_logic;  -- High (1) if dataa[] <= datab[].
        aneb : out std_logic;  -- High (1) if dataa[] != datab[].
        ageb : out std_logic   -- High (1) if dataa[] >= datab[].
    );
end LPM_COMPARE_UNSIGNED;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_COMPARE_UNSIGNED is
begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        if (lpm_pipeline < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_pipeline parameter must NOT less than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    -- perform the data comparison
    process(aclr, clock, dataa, datab)
    variable agbtmp : std_logic_vector (0 to lpm_pipeline);
    variable agebtmp : std_logic_vector (0 to lpm_pipeline);
    variable aebtmp : std_logic_vector (0 to lpm_pipeline);
    variable anebtmp : std_logic_vector (0 to lpm_pipeline);
    variable albtmp : std_logic_vector (0 to lpm_pipeline);
    variable alebtmp : std_logic_vector (0 to lpm_pipeline);

    begin
        -- get the status of comparation
        if (unsigned(dataa) > unsigned(datab)) then
            agbtmp(lpm_pipeline) := '1';
            agebtmp(lpm_pipeline) := '1';
            anebtmp(lpm_pipeline) := '1';
            aebtmp(lpm_pipeline) := '0';
            albtmp(lpm_pipeline) := '0';
            alebtmp(lpm_pipeline) := '0';
        elsif (unsigned(dataa) = unsigned(datab)) then
            agbtmp(lpm_pipeline) := '0';
            agebtmp(lpm_pipeline) := '1';
            anebtmp(lpm_pipeline) := '0';
            aebtmp(lpm_pipeline) := '1';
            albtmp(lpm_pipeline) := '0';
            alebtmp(lpm_pipeline) := '1';
        else
            agbtmp(lpm_pipeline) := '0';
            agebtmp(lpm_pipeline) := '0';
            anebtmp(lpm_pipeline) := '1';
            aebtmp(lpm_pipeline) := '0';
            albtmp(lpm_pipeline) := '1';
            alebtmp(lpm_pipeline) := '1';
        end if;

        -- if lpm_pipine > 0, then create latency on the output result
        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                for i in 0 to lpm_pipeline loop
                    agbtmp(i) := '0';
                    agebtmp(i) := '0';
                    anebtmp(i) := '0';
                    aebtmp(i) := '0';
                    albtmp(i) := '0';
                    alebtmp(i) := '0';
                end loop;
            end if;
        elsif (clock'event and (clock = '1')) then
            if ((clken = '1') and (lpm_pipeline > 0)) then
                agbtmp(0 to lpm_pipeline-1) :=  agbtmp(1 to lpm_pipeline);
                agebtmp(0 to lpm_pipeline-1) := agebtmp(1 to lpm_pipeline) ;
                anebtmp(0 to lpm_pipeline-1) := anebtmp(1 to lpm_pipeline);
                aebtmp(0 to lpm_pipeline-1) := aebtmp(1 to lpm_pipeline);
                albtmp(0 to lpm_pipeline-1) := albtmp(1 to lpm_pipeline);
                alebtmp(0 to lpm_pipeline-1) := alebtmp(1 to lpm_pipeline);
            end if;
        end if;

        agb <= agbtmp(0);
        ageb <= agebtmp(0);
        aneb <= anebtmp(0);
        aeb <= aebtmp(0);
        alb <= albtmp(0);
        aleb <= alebtmp(0);
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_compare
--
-- Description     :   Parameterized comparator megafunction. The comparator will
--                    compare between data[] and datab[] and return the status of
--                    comparation for the following operation.
--                    1) dataa[] < datab[].
--                    2) dataa[] == datab[].
--                    3) dataa[] > datab[].
--                    4) dataa[] >= datab[].
--                    5) dataa[] != datab[].
--                    6) dataa[] <= datab[].
--
-- Limitation      :  n/a
--
-- Results Expected:  Return status bits of the comparision between dataa[] and
--                    datab[].
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMPARE_SIGNED;
use work.LPM_COMPARE_UNSIGNED;

-- ENTITY DECLARATION
entity LPM_COMPARE is

-- GENERIC DECLARATION
    generic (
        -- Width of the dataa[] and datab[] ports. (Required)
        lpm_width : natural;
        -- Type of comparison performed: "SIGNED", "UNSIGNED"
        lpm_representation : string := "UNSIGNED";
        -- Specifies the number of clock cycles of latency associated with the
        -- alb, aeb, agb, ageb, aleb or aneb output.
        lpm_pipeline : natural := 0;
        lpm_type: string := "LPM_COMPARE";
        lpm_hint : string := "UNUSED"
    );
    
-- PORT DECLARATION   
    port (
        -- Value to be compared to datab[]. (Required)
        dataa : in std_logic_vector(lpm_width-1 downto 0);
        -- Value to be compared to dataa[]. (Required)
        datab : in std_logic_vector(lpm_width-1 downto 0);
        -- clock for pipelined usage.
        clock : in std_logic := '0';
        -- Asynchronous clear for pipelined usage.
        aclr  : in std_logic := '0';
        -- clock enable for pipelined usage.
        clken : in std_logic := '1';
        
        -- One of the following ports must be present.
        alb  : out std_logic;  -- High (1) if dataa[] < datab[].
        aeb  : out std_logic;  -- High (1) if dataa[] == datab[].
        agb  : out std_logic;  -- High (1) if dataa[] > datab[].
        aleb : out std_logic;  -- High (1) if dataa[] <= datab[].
        aneb : out std_logic;  -- High (1) if dataa[] != datab[].
        ageb : out std_logic   -- High (1) if dataa[] >= datab[].
    );
end LPM_COMPARE;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_COMPARE is

-- COMPONENT DECLARATION

    component LPM_COMPARE_SIGNED
        generic (
            lpm_width    : natural;
            lpm_pipeline : natural := 0;
            lpm_type     : string  := "LPM_COMPARE";
            lpm_hint     : string  := "UNUSED"
        );
        port (
            dataa : in std_logic_vector(lpm_width-1 downto 0);
            datab : in std_logic_vector(lpm_width-1 downto 0);
            clock : in std_logic := '0';
            aclr  : in std_logic := '0';
            clken : in std_logic := '1';
            alb  : out std_logic;
            aeb  : out std_logic;
            agb  : out std_logic;
            aleb : out std_logic;
            aneb : out std_logic;
            ageb : out std_logic
        );
    end component;

    component LPM_COMPARE_UNSIGNED
        generic (
            lpm_width    : natural;
            lpm_pipeline : natural := 0;
            lpm_type     : string  := "LPM_COMPARE";
            lpm_hint     : string  := "UNUSED"
        );
        port (
            dataa : in std_logic_vector(lpm_width-1 downto 0);
            datab : in std_logic_vector(lpm_width-1 downto 0);
            clock : in std_logic := '0';
            aclr  : in std_logic := '0';
            clken : in std_logic := '1';
            alb  : out std_logic;
            aeb  : out std_logic;
            agb  : out std_logic;
            aleb : out std_logic;
            aneb : out std_logic;
            ageb : out std_logic
        );
    end component;

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if ((lpm_representation /= "UNSIGNED") and (lpm_representation /= "SIGNED")) then
            ASSERT FALSE
            REPORT "Value of lpm_representation parameter must be SIGNED or UNSIGNED!"
            SEVERITY ERROR;
        end if;        
        wait;
    end process MSG;

-- instantiate LPM_COMPARE_UNSIGNED to perform "UNSIGNED" data comparison
L1: if lpm_representation = "UNSIGNED" generate
    U1: LPM_COMPARE_UNSIGNED
        generic map (
            lpm_width    => lpm_width,
            lpm_pipeline => lpm_pipeline,
            lpm_type     => lpm_type,
            lpm_hint     => lpm_hint
        )
        port map (
            dataa => dataa,
            datab => datab,
            clock => clock,
            aclr => aclr,
            clken => clken,
            alb => alb,
            aeb => aeb,
            agb => agb,
            aleb => aleb,
            aneb => aneb,
            ageb => ageb
        );
    end generate;

-- instantiate LPM_COMPARE_SIGNED to perform "SIGNED" data comparison
L2: if lpm_representation = "SIGNED" generate
    U2: LPM_COMPARE_SIGNED
        generic map (
            lpm_width    => lpm_width,
            lpm_pipeline => lpm_pipeline,
            lpm_type     => lpm_type,
            lpm_hint     => lpm_hint
        )
        port map (
            dataa => dataa,
            datab => datab,
            clock => clock,
            aclr => aclr,
            clken => clken,
            alb => alb,
            aeb => aeb,
            agb => agb,
            aleb => aleb,
            aneb => aneb,
            ageb => ageb
        );
    end generate;
end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_mult
--
-- Description     :  Parameterized multiplier megafunction.
--
-- Limitation      :  n/a
--
-- results Expected:  dataa[] * datab[] + sum[].
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.LPM_COMPONENTS.all;
use work.LPM_HINT_EVALUATION.all;

-- ENTITY DECLARATION
entity LPM_MULT is

-- GENERIC DECLARATION
    generic (
        lpm_widtha : natural;  -- Width of the dataa[] port. (Required)
        lpm_widthb : natural;  -- Width of the datab[] port. (Required)
        lpm_widthp : natural;  -- Width of the result[] port. (Required)
        lpm_widths : natural := 1; -- Width of the sum[] port. (Required)
        lpm_representation : string  := "UNSIGNED"; -- Type of multiplication performed
        lpm_pipeline       : natural := 0; -- Number of clock cycles of latency
        lpm_type           : string  := "LPM_MULT";
        lpm_hint           : string  := "UNUSED"
    );

-- PORT DECLARATION 
    port (
        -- Multiplicand. (Required)
        dataa : in std_logic_vector(lpm_widtha-1 downto 0);
        -- Multiplier. (Required)
        datab : in std_logic_vector(lpm_widthb-1 downto 0);
        -- Partial sum.
        sum   : in std_logic_vector(lpm_widths-1 downto 0) := (OTHERS => '0');
        -- Asynchronous clear for pipelined usage.
        aclr  : in std_logic := '0';
        -- Clock for pipelined usage.
        clock : in std_logic := '0';
        -- Clock enable for pipelined usage.
        clken : in std_logic := '1';
        -- result = dataa[] * datab[] + sum. The product LSB is aligned with the sum LSB.
        result : out std_logic_vector(lpm_widthp-1 downto 0)
    );
end LPM_MULT;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_MULT is

-- FUNCTION DECLARATION
    function str2bin (constant i_str : in string;
            constant i_width_str : in natural) return std_logic_vector is
        variable binary_bits : std_logic_vector (255 downto 0) := (others => '0');
    begin
        if(i_str'length > 0) then
            for i in 0 to (i_str'right - i_str'left) loop
                if (i_str'left >= i) then
                    case i_str(i_str'right - i) is
                        when '0' => binary_bits(i) := '0';
                        when '1' => binary_bits(i) := '1';
                        when others => binary_bits(i) := 'X';
                    end case;
                end if;
            end loop;
        end if;        
        return binary_bits(i_width_str -1 downto 0);
    end str2bin;

-- TYPE DECLARATION
type T_RESULTTMP IS ARRAY (0 to lpm_pipeline) of std_logic_vector(lpm_widthp-1 downto 0);

-- CONSTANT DECLARATION
constant INPUT_A_IS_CONSTANT : string := GET_PARAMETER_VALUE(lpm_hint, "INPUT_A_IS_CONSTANT");
constant INPUT_B_IS_CONSTANT : string := GET_PARAMETER_VALUE(lpm_hint, "INPUT_B_IS_CONSTANT");
constant INPUT_A_FIXED_VALUE : string := GET_PARAMETER_VALUE(lpm_hint, "INPUT_A_FIXED_VALUE");
constant INPUT_B_FIXED_VALUE : string := GET_PARAMETER_VALUE(lpm_hint, "INPUT_B_FIXED_VALUE");
constant DATAA_FIXED : std_logic_vector(lpm_widtha-1 downto 0) := str2bin(INPUT_A_FIXED_VALUE, lpm_widtha);
constant DATAB_FIXED : std_logic_vector(lpm_widthb-1 downto 0) := str2bin(INPUT_B_FIXED_VALUE, lpm_widthb);

-- SIGNAL DECLARATION
signal i_dataa : std_logic_vector(lpm_widtha-1 downto 0);
signal i_datab : std_logic_vector(lpm_widthb-1 downto 0);

begin

    i_dataa <= dataa when (INPUT_A_IS_CONSTANT /= "FIXED")
            else DATAA_FIXED;
    i_datab <= datab when (INPUT_B_IS_CONSTANT /= "FIXED")
            else DATAB_FIXED;

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_widtha <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widtha parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widthb <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthb parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widthp <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthp parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widths <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widths parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        wait;
    end process MSG;

    process (clock, aclr, i_dataa, i_datab, sum)
    variable resulttmp : T_RESULTTMP;
    variable tmp_prod_ab : std_logic_vector(lpm_widtha+lpm_widthb downto 0);
    variable tmp_prod_s : std_logic_vector(lpm_widths downto 0);
    variable tmp_prod_p : std_logic_vector(lpm_widthp-1 downto 0);
    variable tmp_use : integer;
    begin
        if (lpm_representation = "SIGNED") then
            tmp_prod_ab(lpm_widtha+lpm_widthb-1 downto 0) := signed(i_dataa) * signed(i_datab);
            tmp_prod_ab(lpm_widtha+lpm_widthb) := tmp_prod_ab(lpm_widtha+lpm_widthb-1);
        elsif (lpm_representation = "UNSIGNED") then
            tmp_prod_ab(lpm_widtha+lpm_widthb-1 downto 0) := unsigned(i_dataa) * unsigned(i_datab);
            tmp_prod_ab(lpm_widtha+lpm_widthb) := '0';
        else
            ASSERT FALSE
            REPORT "Illegal lpm_representation property value for LPM_MULT!"
            SEVERITY ERROR;
        end if;
        tmp_use := 1; --AB
        if (lpm_widths > (lpm_widtha+lpm_widthb)) then
            if (lpm_representation = "SIGNED") then
                tmp_prod_s := (OTHERS => tmp_prod_ab(lpm_widtha+lpm_widthb));
                tmp_prod_s(lpm_widtha+lpm_widthb downto 0) := tmp_prod_ab;
                tmp_prod_s := signed(tmp_prod_s) + signed(sum);
                tmp_prod_p := (OTHERS => tmp_prod_s(lpm_widths));
            else
                tmp_prod_s := (OTHERS => '0');
                tmp_prod_s(lpm_widtha+lpm_widthb downto 0) := tmp_prod_ab;
                tmp_prod_s := unsigned(tmp_prod_s) + unsigned(sum);
                tmp_prod_p := (OTHERS => '0');
            end if;
            tmp_use := 2; --S
        elsif (lpm_widths > 0) then
            if (lpm_representation = "SIGNED") then
                tmp_prod_ab := signed(tmp_prod_ab) + signed(sum);
                tmp_prod_p := (OTHERS => tmp_prod_ab(lpm_widtha+lpm_widthb));
            else
                tmp_prod_ab := unsigned(tmp_prod_ab) + unsigned(sum);
                tmp_prod_p := (OTHERS => '0');
            end if;
        end if;

        if (tmp_use = 2) then --S
            if (lpm_widthp > lpm_widths) then
                tmp_prod_p(lpm_widths downto 0) := tmp_prod_s;
            elsif (lpm_widthp = lpm_widths) then
                tmp_prod_p := tmp_prod_s(lpm_widthp-1 downto 0);
            else
                tmp_prod_p := tmp_prod_s(lpm_widths-1 downto lpm_widths-lpm_widthp);
            end if;
        else --AB
            if (lpm_widthp > (lpm_widtha+lpm_widthb)) then
                tmp_prod_p(lpm_widtha+lpm_widthb downto 0) := tmp_prod_ab(lpm_widtha+lpm_widthb downto 0);
            elsif (lpm_widthp = lpm_widtha+lpm_widthb) then
                tmp_prod_p := tmp_prod_ab(lpm_widthp-1 downto 0);
            else
                tmp_prod_p := tmp_prod_ab(lpm_widtha+lpm_widthb-1 downto lpm_widtha+lpm_widthb-lpm_widthp);
            end if;
        end if;                

        resulttmp(lpm_pipeline) := tmp_prod_p;

        -- Pipelining the result of multiplication
        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                for i in 0 to lpm_pipeline loop
                    resulttmp(i) := (OTHERS => '0');
                end loop;
            end if;
        elsif (clock'event and (clock = '1')) then
            if((clken = '1') and (lpm_pipeline > 0) and (now > 0 ns)) then
                resulttmp(0 to lpm_pipeline - 1) := resulttmp(1 to lpm_pipeline);
            end if;
        end if;

        result <= resulttmp(0);
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_divide
--
-- Description     :  Parameterized divider megafunction. This function performs a
--                    divide operation such that denom * quotient + remain = numer
--                    The function allows for all combinations of signed(two's 
--                    complement) and unsigned inputs. If any of the inputs is 
--                    signed, the output is signed. Otherwise the output is unsigned.
--                    The function also allows the remainder to be specified as
--                    always positive (in which case remain >= 0); otherwise remain
--                    is zero or the same sign as the numerator
--                    (this parameter is ignored in the case of purely unsigned
--                    division). Finally the function is also pipelinable.
--
-- Limitation      :  n/a
--
-- Results Expected:  Return quotient and remainder.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_HINT_EVALUATION.all;


-- ENTITY DECLARATION
entity LPM_DIVIDE is
    generic (
        lpm_widthn : natural;  -- Width of the numer[] and quotient[] port. (Required)
        lpm_widthd : natural;  -- Width of the denom[] and remain[] port. (Required)
        lpm_nrepresentation : string := "UNSIGNED"; -- The representation of numer
        lpm_drepresentation : string := "UNSIGNED"; -- The representation of denom
        lpm_pipeline : natural := 0;  -- Number of Clock cycles of latency
        lpm_type : string := "LPM_DIVIDE";
        lpm_hint : string := "LPM_REMAINDERPOSITIVE=TRUE"
    );
    
    port (
        numer : in std_logic_vector(lpm_widthn-1 downto 0);  -- The numerator (Required)
        denom : in std_logic_vector(lpm_widthd-1 downto 0);  -- The denominator (Required)
        clock : in std_logic := '0';  -- Clock input for pipelined usage
        aclr  : in std_logic := '0';  -- Asynchronous clear signal
        clken : in std_logic := '1';  -- Clock enable for pipelined usage
        quotient : out std_logic_vector(lpm_widthn-1 downto 0); -- Quotient (Required)
        remain   : out std_logic_vector(lpm_widthd-1 downto 0)  -- Remainder (Required)
    );
end LPM_DIVIDE;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture behave of lpm_divide is

-- CONSTANT DECLARATION    
constant MAX_WIDTH      : integer  := 256;
constant  LPM_REMAINDERPOSITIVE : string := GET_PARAMETER_VALUE(LPM_HINT, "LPM_REMAINDERPOSITIVE");

-- TYPE DECLARATION
type QPIPELINE is array (0 to lpm_pipeline) of std_logic_vector(lpm_widthn-1 downto 0);
type RPIPELINE is array (0 to lpm_pipeline) of std_logic_vector(lpm_widthd-1 downto 0);

-- SIGNAL DECLARATION
signal quotient_pipe    : std_logic_vector (lpm_widthn - 1 downto 0)
                        := (others => '0');
signal quotient_value   : std_logic_vector (lpm_widthn - 1 downto 0)
                        := (others => '0');
signal remainder_pipe   : std_logic_vector (lpm_widthd - 1 downto 0)
                        := (others => '0');
signal remainder_value  : std_logic_vector (lpm_widthd - 1 downto 0)
                        := (others => '0');

-- FUNCTION DECLARATION
    -- Bitwise left shift
    procedure shift_left ( val : inout std_logic_vector; num : in integer)  is
        variable temp : std_logic_vector((val'length - 1) downto 0);
    begin
        if num /= 0 then 
            temp := val;
            if (val'length > 1) then
                for i in temp'high downto num loop
                    temp(i) := temp(i- num);
                end loop;
                for i in num-1 downto 0 loop
                    temp(i) := '0';
                end loop;
            end if;
            temp(0) :='0';
            val := temp;
        end if;
    end shift_left;

    -- Bitwise right shift
    procedure shift_right ( val : inout std_logic_vector ) is
        variable temp : std_logic_vector(val'length-1 downto 0);
    begin
        temp := val;
        if (val'length > 1) then
            for i in 0 to temp'high - 1 loop
                temp(i) := temp(i+1);
            end loop;
        end if;
        temp(temp'high) := '0';
        val := temp;
    end shift_right;

begin

-- SIGNAL ASSIGNMENTS
    quotient <= quotient_pipe when (lpm_pipeline > 0) else quotient_value;
    remain <= remainder_pipe when (lpm_pipeline > 0) else remainder_value;

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_widthn <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthn parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widthd <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthd parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if ((LPM_REMAINDERPOSITIVE /= "TRUE") and
            (LPM_REMAINDERPOSITIVE /= "FALSE")) then
            ASSERT FALSE
            REPORT " LPM_REMAINDERPOSITIVE value must be TRUE or FALSE!"
            SEVERITY ERROR;
        end if;
        
        wait;
    end process MSG;

    process (numer, denom)
    variable i_denom : std_logic_vector(MAX_WIDTH-1 downto 0) := (OTHERS => '0');
    variable i_quotient : std_logic_vector(lpm_widthn-1 downto 0) := (OTHERS => '0');
    variable i_remain   : std_logic_vector(MAX_WIDTH-1 downto 0) := (OTHERS => '0');
    variable sign_numer : std_logic;
    variable sign_denom : std_logic;
    variable trailing_zero_count : integer;
    variable int_numer, int_denom, int_quotient, int_remain : integer := 0;
    variable signed_quotient : signed(lpm_widthn-1 downto 0);
    variable unsigned_quotient : unsigned(lpm_widthn-1 downto 0);
    begin
    
        if ((lpm_widthn < 32) and (lpm_widthd < 32)) then
            -- perform division using integer division.
            if (lpm_nrepresentation = "UNSIGNED") then
                int_numer := conv_integer(unsigned(numer));
            elsif (lpm_nrepresentation = "SIGNED") then
                int_numer := conv_integer(signed(numer));
            else
                ASSERT FALSE
                REPORT "Illegal lpm_nrepresentation property value for LPM_DIVIDE!"
                SEVERITY ERROR;
            end if;
            if (lpm_drepresentation = "UNSIGNED" ) then
                int_denom := conv_integer(unsigned(denom));
            elsif (lpm_drepresentation = "SIGNED") then
                int_denom := conv_integer(signed(denom));
            else
                ASSERT FALSE
                REPORT "Illegal lpm_drepresentation property value for LPM_DIVIDE!"
                SEVERITY ERROR;
            end if;

            if (int_denom = 0) then
                remainder_value <= (OTHERS => 'X');
                quotient_value <= (OTHERS => 'X');
            else
                int_quotient := int_numer / int_denom;
                int_remain := int_numer rem int_denom;
    
                -- LPM 220 standard
                if ((LPM_REMAINDERPOSITIVE="TRUE") and (int_remain < 0)) then
                    if (int_denom < 0) then
                        int_quotient := int_quotient + 1;
                    else
                        int_quotient := int_quotient - 1;
                    end if;
                    int_remain := int_numer - (int_quotient*int_denom);
                end if;
                
                signed_quotient := conv_signed(int_quotient, lpm_widthn);
                unsigned_quotient := conv_unsigned(int_quotient, lpm_widthn);
        
                remainder_value <= conv_std_logic_vector(int_remain, lpm_widthd);
    
                if ((lpm_nrepresentation = "UNSIGNED") and (lpm_drepresentation = "UNSIGNED")) then
                    quotient_value <= conv_std_logic_vector(unsigned_quotient, lpm_widthn);
                else
                    quotient_value <= conv_std_logic_vector(signed_quotient, lpm_widthn);
                end if;
            end if;

        else
            -- perform division using long division algorithm
            sign_numer := '0';
            sign_denom := '0';
            trailing_zero_count := 0;
            i_quotient := (OTHERS => '0');
            i_denom := (OTHERS => '0');
            i_remain := (OTHERS => '0');
            
            if (lpm_nrepresentation = "UNSIGNED") then
                i_remain(lpm_widthn -1 downto 0) := numer;              
            elsif (lpm_nrepresentation = "SIGNED") then
                if (numer(lpm_widthn-1) = '1') then
                    i_remain(lpm_widthn -1 downto 0) := not numer + 1;
                    sign_numer := '1';
                else
                    i_remain(lpm_widthn -1 downto 0) := numer;
                end if;
            else
                ASSERT FALSE
                REPORT "Illegal lpm_nrepresentation property value for LPM_DIVIDE!"
                SEVERITY ERROR;
            end if;
            if (lpm_drepresentation = "UNSIGNED" ) then
                i_denom(MAX_WIDTH-1 downto MAX_WIDTH-lpm_widthd) := denom;
            elsif (lpm_drepresentation = "SIGNED") then
                if (denom(lpm_widthd-1) = '1') then
                    i_denom(MAX_WIDTH-1 downto MAX_WIDTH-lpm_widthd) := not denom + 1;
                    sign_denom := '1';
                else
                    i_denom(MAX_WIDTH-1 downto MAX_WIDTH-lpm_widthd) := denom;
                end if;
            else
                ASSERT FALSE
                REPORT "Illegal lpm_drepresentation property value for LPM_DIVIDE!"
                SEVERITY ERROR;
            end if;
            
            
            -- if divide with zero, set quotient to all 'X'
            if (i_denom = 0) then              
                i_quotient := (OTHERS => 'X');
                i_remain := (OTHERS => 'X');
            elsif (numer = 0) then
                i_quotient := (OTHERS => '0');
            else
                -- get number of zero bits in the denom
                for i in 0 to lpm_widthd-1 loop
                    if (i_denom(MAX_WIDTH-lpm_widthd + i) /= '0') then                    
                        trailing_zero_count := i;
                        exit;
                    end if;
                end loop;
            
                -- shift the i_denom until the first non-zero bit become leftmost bit.
                for i in 0 to lpm_widthd-1 loop
                    if (i_denom(MAX_WIDTH-1-i) /= '0') then
                        shift_left(i_denom, i);
                        exit;
                    end if;
                end loop;
                
                -- perform division
                if (unsigned(i_remain) >= unsigned(i_denom)) then
                    i_remain := i_remain - i_denom;
                    i_quotient(0) := '1';
                else
                    i_quotient(0) := '0';
                end if;
                
                while (i_denom(trailing_zero_count) = '0') loop
                    shift_right(i_denom);
                    shift_left(i_quotient, 1);
                    if (unsigned(i_remain) >= unsigned(i_denom)) then
                        i_remain := i_remain - i_denom;
                        i_quotient(0) := '1';
                    else
                        i_quotient(0) := '0';
                    end if;                             
                end loop;
    
                -- quotient is negative number if either numer or denom (but not both)
                -- is negative number 
                if ((sign_numer xor sign_denom) = '1') then
                    i_quotient := not i_quotient + 1;
                end if;            
                
                -- LPM 220 standard
                if ((sign_numer = '1') and (i_remain /= 0)) then
                    if (LPM_REMAINDERPOSITIVE = "TRUE") then
                        if (sign_denom = '1') then
                            i_quotient := i_quotient + 1;
                        else
                            i_quotient := i_quotient - 1;
                        end if;
                        i_remain := i_denom - i_remain;
                    else
                        i_remain := not i_remain + 1;
                    end if;
    
                end if;
            end if;
            
            remainder_value <= i_remain(lpm_widthd -1 downto 0); 
            quotient_value <= i_quotient;
        end if;
    end process;

    process (aclr, clock)
    variable tmp_quotient : QPIPELINE := (OTHERS => (OTHERS => '0'));
    variable tmp_remain   : RPIPELINE := (OTHERS => (OTHERS => '0'));
    begin
   
        if (aclr = '1') then
            if (lpm_pipeline > 0) then
                -- clear the pipeline
                for i in 0 to lpm_pipeline loop
                    tmp_quotient(i) := (OTHERS => '0');
                    tmp_remain(i) := (OTHERS => '0');
                end loop;
            end if;
        elsif (clock'event and (clock = '1')) then
            if (lpm_pipeline > 0) then
                if (clken = '1') then
                    -- pipeline the result
                    tmp_remain(lpm_pipeline) := remainder_value; 
                    tmp_quotient(lpm_pipeline) := quotient_value;
                    tmp_quotient(0 to lpm_pipeline-1) := tmp_quotient(1 to lpm_pipeline);
                    tmp_remain(0 to lpm_pipeline-1) := tmp_remain(1 to lpm_pipeline);
                end if;
            end if;
        end if;
        
        quotient_pipe <= tmp_quotient(0);
        remainder_pipe <= tmp_remain(0);
    end process;
end behave;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_abs
--
-- Description     :  Parameterized absolute value megafunction. This megafunction
--                    requires the input data to be signed number.
--
-- Limitation      :  
--
-- results Expected:  Return absolute value of data and the overflow status
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity lpm_abs is
    generic (
            lpm_width : natural;    -- Width of the data[] and result[] ports.
                                    -- MUST be greater than 0 (Required)
            lpm_type  : string := "LPM_ABS";
            lpm_hint  : string := "UNUSED"
            );

    port    ( 
            data      : in std_logic_vector(lpm_width-1 downto 0); -- (Required)
            result    : out std_logic_vector(lpm_width-1 downto 0); -- (Required)
            overflow  : out std_logic
            );
end LPM_ABS;

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_ABS is
begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;
    
    GENERATE_ABS : process(data)
    begin
        if (data(lpm_width-1) = '1') then
            if (lpm_width = 1) then
                overflow <= '1';
                result <= data;
            elsif ((lpm_width > 1) and (data(lpm_width -2 downto 0) = 0)) then
                overflow <= '1';
                result <= data;
            else
                result <= 0 - data;
                overflow <= '0';
            end if;
        else
            result <= data;
            overflow <= '0';
        end if;
    end process GENERATE_ABS;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_counter
--
-- Description     :  Parameterized counter megafunction. The lpm_counter
--                    megafunction is a binary counter that features an up, 
--                    down, or up/down counter with optional synchronous or
--                    asynchronous clear, set, and load ports.
--
-- Limitation      :  n/a
--
-- Results Expected:  data output from the counter and carry-out of the MSB.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;

-- ENTITY DECLARATION
entity LPM_COUNTER is
    generic (
        lpm_width     : natural;    -- MUST be greater than 0
        lpm_direction : string  := "UNUSED";
        lpm_modulus   : natural := 0;
        lpm_avalue    : string  := "UNUSED";
        lpm_svalue    : string  := "UNUSED";
        lpm_pvalue    : string  := "UNUSED";
        lpm_port_updown : string := "PORT_CONNECTIVITY";
        lpm_type      : string  := "LPM_COUNTER";
        lpm_hint      : string  := "UNUSED"
    );
    port (
        clock   : in std_logic;
        clk_en  : in std_logic := '1';
        cnt_en  : in std_logic := '1';
        updown  : in std_logic := '1';
        aclr    : in std_logic := '0';
        aset    : in std_logic := '0';
        aload   : in std_logic := '0';
        sclr    : in std_logic := '0';
        sset    : in std_logic := '0';
        sload   : in std_logic := '0';
        data    : in std_logic_vector(lpm_width-1 downto 0):= (OTHERS => '0');
        cin     : in std_logic := '1';
        q    : out std_logic_vector(lpm_width-1 downto 0);
        cout : out std_logic := '0';
        eq   : out std_logic_vector(15 downto 0) := (OTHERS => '0')
    );

end LPM_COUNTER;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_COUNTER is

-- CONSTANT DECLARATION
constant ONES : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '1');

-- FUNCTION DECLARATION
function STR_TO_STD_LOGIC_VECTOR ( str : string ) return std_logic_vector is
variable len : integer := str'length;
variable ivalue : std_logic_vector(lpm_width+5 downto 0) := (others => '0');
variable digit : std_logic_vector(3 downto 0) := (others => '0');
variable ten : std_logic_vector(3 downto 0) := "1010";
begin
    if (str /= "UNUSED") then
        for i in 1 to len loop
            case str(i) is
                when '0' =>
                    digit := "0000";
                when '1' =>
                    digit := "0001";
                when '2' =>
                    digit := "0010";
                when '3' =>
                    digit := "0011";
                when '4' =>
                    digit := "0100";
                when '5' =>
                    digit := "0101";
                when '6' =>
                    digit := "0110";
                when '7' =>
                    digit := "0111";
                when '8' =>
                    digit := "1000";
                when '9' =>
                    digit := "1001";
                when others =>
                    ASSERT FALSE
                    REPORT "Illegal Character "&  str(i) & " in string parameter! "
                    SEVERITY ERROR;
            end case;
            ivalue(lpm_width+4 downto 0) := unsigned(ivalue(lpm_width downto 0)) * unsigned(ten) + unsigned(digit);
        end loop;
    end if;
    return ivalue(lpm_width downto 0);
end STR_TO_STD_LOGIC_VECTOR;

-- SIGNAL DECLARATION
signal count : std_logic_vector(lpm_width downto 0);
signal dir : std_logic_vector(1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_modulus < 0) then
            ASSERT FALSE
            REPORT "Value of lpm_modulus parameter must be greater or equal to 0!"
            SEVERITY ERROR;
        end if;
        
        if(lpm_width < 31) then
            if (lpm_modulus > 2**lpm_width) then
                ASSERT FALSE
                REPORT "LPM_MODULUS should be within 1 to 2^LPM_WIDTH. Assuming no modulus input."
                SEVERITY WARNING;
            end if;        
        end if;
        wait;
    end process MSG;

    DIRECTION: process (updown)
    begin
        if (lpm_port_updown = "PORT_USED") then
            dir(0) <= updown;
            if ((updown = '0') or (updown = '1')) then
                dir(1) <= '0';  -- increment or decrement
            else
                dir(1) <= '1';  -- unknown
            end if;
        elsif (lpm_port_updown = "PORT_UNUSED") then
            if (lpm_direction = "DOWN") then
                dir <= "00";    -- decrement
            else
                dir <= "01";    -- increment
            end if;
        else
            if (lpm_direction = "UP") then
                dir <= "01";    -- increment
            elsif (lpm_direction = "DOWN") then
                dir <= "00";    -- decrement
            else
                dir(0) <= updown;
                if ((updown = '0') or (updown = '1')) then
                    dir(1) <= '0';  -- increment or decrement
                else
                    if ((lpm_direction = "UNUSED") or (lpm_direction = "DEFAULT")) then
                        dir <= "01"; -- default to increment
                    else
                        dir(1) <= '1';  -- unknown
                    end if;
                end if;
            end if;
        end if;
    end process DIRECTION;

    COUNTER: process (clock, aclr, aset, aload, data)
        variable imodulus : integer := lpm_modulus;
        variable init : boolean := false;
        variable avalue : std_logic_vector(lpm_width downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_avalue);
        variable svalue : std_logic_vector(lpm_width downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_svalue);
        variable pvalue : std_logic_vector(lpm_width downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_pvalue);
    begin
        if (init = false) then

            -- Initialize to pvalue and setup variables            
            if (lpm_pvalue /= "UNUSED") then
                count <= pvalue;
            else
                count <= (OTHERS => '0');
            end if;

            if (lpm_width < 31) then -- 32 bit integer limit
                if (lpm_modulus > (2 ** lpm_width)) then
                    imodulus := 2 ** lpm_width ;
                else
                    imodulus := lpm_modulus;
                end if;
            else
                imodulus := lpm_modulus;
            end if;

            -- Check parameters validity
            if ((lpm_direction /= "UNUSED") and (lpm_direction /= "DEFAULT") and
                (lpm_direction /= "UP") and (lpm_direction /= "DOWN")) then
                ASSERT FALSE
                REPORT "Illegal lpm_direction property value for lpm_counter!"
                SEVERITY ERROR;
            end if;

            init := true;
        end if;
        
        if (aclr = '1') then
            count <= (OTHERS => '0');
        elsif (aset = '1') then
            if (lpm_avalue = "UNUSED") then
                count <= (OTHERS => '1');
            else
                count <= avalue;
            end if;
        elsif (aload = '1') then
            count(lpm_width-1 downto 0) <= data;
        elsif (clock'event and (clock = '1')) then
            if (clk_en = '1') then
                if (sclr = '1') then
                    count <= (OTHERS => '0');
                elsif (sset = '1') then
                    if (lpm_svalue = "UNUSED") then
                        count <= (OTHERS => '1');
                    else
                        count <= svalue;
                    end if;
                elsif (sload = '1') then
                    count(lpm_width-1 downto 0) <= data;
                elsif (cnt_en = '1') then
                    if (imodulus = 1) then
                        count <= (OTHERS => '0');
                    elsif (cin = '1') then
                        if ((dir(0) = '1') and (dir(1) = '0')) then
                            -- Increase the count
                            if (((lpm_modulus = 0) and (unsigned(count(lpm_width-1 downto 0)) = unsigned(ONES))) or
                                ((lpm_modulus /= 0) and ((count + 1) = imodulus))) then
                                count <= conv_std_logic_vector(0, lpm_width+1);
                            else
                                count <= count + 1;
                            end if;
                        elsif ((dir(0) = '0') and (dir(1) = '0')) then
                            -- Decrease the count
                            if (count = 0) then
                                if (lpm_modulus /= 0) then
                                    count <= conv_std_logic_vector(imodulus-1, lpm_width+1);
                                else
                                    count <= (OTHERS => '1');
                                end if;
                            else
                                count <= count - 1;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
        
        count(lpm_width) <= '0';
    end process COUNTER;

    CARRYOUT: process (count, cin, dir)
        variable imodulus : integer := lpm_modulus;
        variable init : boolean := false;
    begin
        if (init = false) then
            if (lpm_width < 31) then  -- 32 bit integer limit
                if (lpm_modulus > (2 ** lpm_width)) then
                    imodulus := 2 ** lpm_width ;
                else
                    imodulus := lpm_modulus;
                end if;
            else
                imodulus := lpm_modulus;
            end if;
            
            init := true;
        end if;

        if (dir(1) = '0') then
            cout <= '0';
            if (imodulus = 1) then
                cout <= '1';
            elsif (cin = '1') then
                if (((dir(0) = '0') and (count = 0)) or
                    ((dir(0) = '1') and (((count = imodulus - 1) and (lpm_modulus /= 0)) or
                    ((lpm_modulus = 0) and
                    (unsigned(count(lpm_width-1 downto 0)) = unsigned(ONES)))) )) then
                    cout <= '1';
                end if;
            end if;
        end if;
    end process CARRYOUT;

    q <= count(lpm_width-1 downto 0);

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_latch
--
-- Description     :  Parameterized latch megafunction.
--
-- Limitation      :  n/a
--
-- Results Expected:  data output from the latch.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;

-- ENTITY DECLARATION
entity LPM_LATCH is

-- GENERIC DECLARATION
    generic (
        lpm_width  : natural;  -- Width of the data[] and q[] ports. (Required)
        lpm_avalue : string := "UNUSED"; -- Constant value that is loaded when aset is high.
        lpm_pvalue : string := "UNUSED";
        lpm_type   : string := "LPM_LATCH";
        lpm_hint   : string := "UNUSED"
    );

-- PORT DECLARATION 
    port (
        data : in std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
        gate : in std_logic;
        aclr : in std_logic := '0';
        aset : in std_logic := '0';
        aconst : in std_logic := '0';
        q    : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_LATCH;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_LATCH is

-- FUNCTION DECLARATION
function STR_TO_STD_LOGIC_VECTOR ( str : string ) return std_logic_vector is
variable len : integer := str'length;
variable ivalue : std_logic_vector(lpm_width+4 downto 0) := (others => '0');
variable digit : std_logic_vector(3 downto 0) := (others => '0');
variable ten : std_logic_vector(3 downto 0) := "1010";
begin
    if (str /= "UNUSED") then
        for i in 1 to len loop
            case str(i) is
                when '0' =>
                    digit := "0000";
                when '1' =>
                    digit := "0001";
                when '2' =>
                    digit := "0010";
                when '3' =>
                    digit := "0011";
                when '4' =>
                    digit := "0100";
                when '5' =>
                    digit := "0101";
                when '6' =>
                    digit := "0110";
                when '7' =>
                    digit := "0111";
                when '8' =>
                    digit := "1000";
                when '9' =>
                    digit := "1001";
                when others =>
                    ASSERT FALSE
                    REPORT "Illegal Character "&  str(i) & " in string parameter! "
                    SEVERITY ERROR;
            end case;
            ivalue(lpm_width+3 downto 0) := unsigned(ivalue(lpm_width-1 downto 0)) * unsigned(ten) + unsigned(digit);
        end loop;
    end if;
    return ivalue(lpm_width-1 downto 0);
end STR_TO_STD_LOGIC_VECTOR;

-- SIGNAL DECLARATION
signal init : std_logic := '0';
signal tmp_init: std_logic := '0';

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process (tmp_init)
    begin
    if (tmp_init = '1') then
        init <= '1';
    end if;
    end process;
    
    process (data, gate, aclr, aset, init)
    variable avalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_avalue);
    variable pvalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_pvalue);
    begin

        if (init = '0') then
            if (lpm_pvalue /= "UNUSED") then
                -- initialize to pvalue
                q <= pvalue;
            end if;
            tmp_init <= '1';
        else
            if (aclr =  '1') then
                q <= (OTHERS => '0');
            elsif (aset = '1') then
                if (lpm_avalue = "UNUSED") then
                    q <= (OTHERS => '1');
                else
                    q <= avalue;
                end if;
            elsif (gate = '1') then
                q <= data;
            end if;
        end if;
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_ff
--
-- Description     :  Parameterized flipflop megafunction. The lpm_ff function
--                    contains features that are not available in the DFF, DFFE,
--                    DFFEA, TFF, and TFFE primitives, such as synchronous or
--                    asynchronous set, clear, and load inputs.
--
-- Limitation      :  n/a
--
-- Results Expected:  Data output from D or T flipflops. 
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- BEGINNING OF ENTITY
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;

-- ENTITY DECLARATION
entity LPM_FF is
    generic (
        -- Width of the data[] and q[] ports. (Required)
        lpm_width  : natural;
        -- Constant value that is loaded when aset is high.
        lpm_avalue : string := "UNUSED";
        -- Constant value that is loaded on the rising edge of clock when sset is high.
        lpm_svalue : string := "UNUSED";
        lpm_pvalue : string := "UNUSED";
        -- Type of flipflop.
        lpm_fftype : string := "DFF";
        lpm_type   : string := "LPM_FF";
        lpm_hint   : string := "UNUSED"
    );
    
    port (
        data   : in std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '1');
        clock  : in std_logic;
        enable : in std_logic := '1';
        aclr   : in std_logic := '0';
        aset   : in std_logic := '0';
        aload  : in std_logic := '0';
        sclr   : in std_logic := '0';
        sset   : in std_logic := '0';
        sload  : in std_logic := '0';
        q : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_FF;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_FF is

-- FUNCTION DECLARATION
function STR_TO_STD_LOGIC_VECTOR ( str : string ) return std_logic_vector is
variable len : integer := str'length;
variable ivalue : std_logic_vector(lpm_width+4 downto 0) := (others => '0');
variable digit : std_logic_vector(3 downto 0) := (others => '0');
variable ten : std_logic_vector(3 downto 0) := "1010";
begin
    if (str /= "UNUSED") then
        for i in 1 to len loop
            case str(i) is
                when '0' =>
                    digit := "0000";
                when '1' =>
                    digit := "0001";
                when '2' =>
                    digit := "0010";
                when '3' =>
                    digit := "0011";
                when '4' =>
                    digit := "0100";
                when '5' =>
                    digit := "0101";
                when '6' =>
                    digit := "0110";
                when '7' =>
                    digit := "0111";
                when '8' =>
                    digit := "1000";
                when '9' =>
                    digit := "1001";
                when others =>
                    ASSERT FALSE
                    REPORT "Illegal Character "&  str(i) & " in string parameter! "
                    SEVERITY ERROR;
            end case;
            ivalue(lpm_width+3 downto 0) := unsigned(ivalue(lpm_width-1 downto 0)) * unsigned(ten) + unsigned(digit);
        end loop;
    end if;
    return ivalue(lpm_width-1 downto 0);
end STR_TO_STD_LOGIC_VECTOR;

-- SIGNAL DECLARATION
signal iq : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');

begin

-- PROCESS DECLARATION

    process (data, clock, aclr, aset, aload)
    variable init : std_logic := '0';
    variable avalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_avalue);
    variable svalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_svalue);
    variable pvalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_pvalue);
    begin
        -- INITIALIZE TO PVALUE --
        if (init = '0') then
            if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of LPM_WIDTH parameter must be greater than 0!"
            SEVERITY ERROR;
            end if;        
            if ((lpm_fftype /= "DFF") and (lpm_fftype /= "TFF")) then
                ASSERT FALSE
                REPORT "Illegal LPM_FFTYPE property value for LPM_FF!"
                SEVERITY ERROR;
            end if;
            if (lpm_pvalue /= "UNUSED") then
                iq <= pvalue;
            end if;
            init := '1';
        end if;
        
        if (aclr =  '1') then
            iq <= (OTHERS => '0');
        elsif (aclr =  'X') then
            iq <= (OTHERS => 'X');
        elsif (aset = '1') then
            if (lpm_avalue = "UNUSED") then
                iq <= (OTHERS => '1');
            else
                iq <= avalue;
            end if;
        elsif (aload = '1') then
            if (lpm_fftype = "TFF") then
                iq <= data;
            end if;
        elsif ((aclr = '0') and (now = 0 ps)) then
            if (lpm_pvalue = "UNUSED") then
                iq <= (OTHERS => '0');
            else
                iq <= pvalue;
            end if;
        elsif (clock'event and (clock = '1') and (NOW > 0 ns)) then
            if (enable = '1') then
                if (sclr = '1') then
                    iq <= (OTHERS => '0');
                elsif (sset = '1') then
                    if (lpm_svalue = "UNUSED") then
                        iq <= (OTHERS => '1');
                    else
                        iq <= svalue;
                    end if;
                elsif (sload = '1') then
                    if (lpm_fftype = "TFF") then
                        iq <= data;
                    end if;
                else
                    if (lpm_fftype = "TFF") then
                        for i in 0 to lpm_width-1 loop
                            if (data(i) = '1') then
                                iq(i) <= not iq(i);
                            end if;
                        end loop;
                    else
                        iq <= data;
                    end if;
                end if;
            end if;
        end if;
    end process;

    q <= iq;

end LPM_SYN;

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_shiftreg
--
-- Description     :  Parameterized shift register megafunction.
--
-- Limitation      :  n/a 
--
-- Results Expected:  data output from the shift register and the Serial shift data output.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;

-- ENTITY DECLARATION
entity LPM_SHIFTREG is
    generic (
        -- Width of the data[] and q ports. (Required)
        lpm_width     : natural;
        lpm_direction : string := "LEFT";
        -- Constant value that is loaded when aset is high.
        lpm_avalue    : string := "UNUSED";
        -- Constant value that is loaded on the rising edge of clock when sset is high.
        lpm_svalue    : string := "UNUSED";
        lpm_pvalue    : string := "UNUSED";
        lpm_type      : string := "L_SHIFTREG";
        lpm_hint      : string := "UNUSED"
    );
    port (
        -- Data input to the shift register.
        data : in std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
        -- Positive-edge-triggered clock. (Required)
        clock : in std_logic;
        -- Clock enable input
        enable : in std_logic := '1';
        -- Serial shift data input.
        shiftin : in std_logic := '1';
        -- Synchronous parallel load. High (1): load operation; low (0): shift operation.
        load : in std_logic := '0';
        -- Asynchronous clear input.
        aclr : in std_logic := '0';
        -- Asynchronous set input.
        aset : in std_logic := '0';
        -- Synchronous clear input.
        sclr : in std_logic := '0';
        -- Synchronous set input.
        sset : in std_logic := '0';
        -- Data output from the shift register.
        q : out std_logic_vector(lpm_width-1 downto 0);
        -- Serial shift data output.
        shiftout : out std_logic
    );
end LPM_SHIFTREG;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_SHIFTREG is

-- FUNCTION DECLARATION
function STR_TO_STD_LOGIC_VECTOR ( str : string ) return std_logic_vector is
variable len : integer := str'length;
variable ivalue : std_logic_vector(lpm_width+4 downto 0) := (others => '0');
variable digit : std_logic_vector(3 downto 0) := (others => '0');
variable ten : std_logic_vector(3 downto 0) := "1010";
begin
    if (str /= "UNUSED") then
        for i in 1 to len loop
            case str(i) is
                when '0' =>
                    digit := "0000";
                when '1' =>
                    digit := "0001";
                when '2' =>
                    digit := "0010";
                when '3' =>
                    digit := "0011";
                when '4' =>
                    digit := "0100";
                when '5' =>
                    digit := "0101";
                when '6' =>
                    digit := "0110";
                when '7' =>
                    digit := "0111";
                when '8' =>
                    digit := "1000";
                when '9' =>
                    digit := "1001";
                when others =>
                    ASSERT FALSE
                    REPORT "Illegal Character "&  str(i) & " in string parameter! "
                    SEVERITY ERROR;
            end case;
            ivalue(lpm_width+3 downto 0) := unsigned(ivalue(lpm_width-1 downto 0)) * unsigned(ten) + unsigned(digit);
        end loop;
    end if;
    return ivalue(lpm_width-1 downto 0);
end STR_TO_STD_LOGIC_VECTOR;

-- SIGNAL DECLARATION
signal i_q : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
signal init : std_logic := '0';
signal tmp_init : std_logic := '0';
signal i_shiftout_pos : natural := lpm_width-1;

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process (tmp_init)
    begin
        if (tmp_init = '1') then
        init <= '1';
        end if;
    end process;

    process (clock, aclr, aset, init)
    variable avalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_avalue);
    variable svalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_svalue);
    variable pvalue : std_logic_vector(lpm_width-1 downto 0) := STR_TO_STD_LOGIC_VECTOR(lpm_pvalue);
    begin
        -- initIALIZE TO PVALUE --
        if (init = '0') then
            if (lpm_pvalue /= "UNUSED") then
                i_q <= pvalue;
            end if;
            if ((lpm_direction = "LEFT") or (lpm_direction = "UNUSED")) then
                i_shiftout_pos <= lpm_width-1;
            elsif (lpm_direction = "RIGHT") then
                i_shiftout_pos <= 0;
            else
                ASSERT FALSE
                REPORT "Illegal lpm_direction property value for LPM_SHIFTREG!"
                SEVERITY ERROR;
            end if;
            tmp_init <= '1';
        elsif (aclr =  '1') then
            i_q <= (OTHERS => '0');
        elsif (aset = '1') then
            if (lpm_avalue = "UNUSED") then
                i_q <= (OTHERS => '1');
            else
                i_q <= avalue;
            end if;
        elsif (rising_edge(clock)) then
            if (enable = '1') then
                if (sclr = '1') then
                    i_q <= (OTHERS => '0');
                elsif (sset = '1') then
                    if (lpm_svalue = "UNUSED") then
                        i_q <= (OTHERS => '1');
                    else
                        i_q <= svalue;
                    end if;
                elsif (load = '1') then
                    i_q <= data;
                else
                    if (lpm_width < 2) then
                        i_q(0) <= shiftin;
                    elsif (lpm_direction = "LEFT") then
                        i_q <= (i_q(lpm_width-2 downto 0) & shiftin);
                    else
                        i_q <= (shiftin & i_q(lpm_width-1 downto 1));
                    end if;
                end if;
            end if;
        end if;
    end process;

    q <= i_q;
    shiftout <= i_q(i_shiftout_pos);

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_ram_dq
--
-- Description     :  Parameterized RAM with separate input and output ports megafunction.
--                    lpm_ram_dp implement asynchronous memory or memory with synchronous
--                    inputs and/or outputs.
--
-- Limitation      :  n/a
--
-- Results Expected:  data output from the memory. 
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;
use work.LPM_DEVICE_FAMILIES.all;
use std.textio.all;

-- ENTITY DECLARATION
entity LPM_RAM_DQ is
    generic (
        -- Width of data[] and q[] ports. (Required)
        lpm_width    : natural;
        -- Width of the address port. (Required)
        lpm_widthad  : natural;
        -- Number of words stored in memory.
        lpm_numwords : natural := 0;
        -- Controls whether the data port is registered.
        lpm_indata   : string := "REGISTERED";
        -- Controls whether the address and we ports are registered.
        lpm_address_control: string := "REGISTERED";
        -- Controls whether the q ports are registered.
        lpm_outdata  : string := "REGISTERED";
        -- Name of the file containing RAM initialization data.
        lpm_file     : string := "UNUSED";
        -- Specified whether to use the EAB or not.
        use_eab      : string := "ON";
        intended_device_family : string := "UNUSED";
        lpm_type     : string := L_RAM_DQ;
        lpm_hint     : string := "UNUSED"
    );
    port (
        -- Data input to the memory. (Required)
        data     : in std_logic_vector(lpm_width-1 downto 0);
        -- Address input to the memory. (Required)
        address  : in std_logic_vector(lpm_widthad-1 downto 0);
        -- Synchronizes memory loading.
        inclock  : in std_logic := '0';
        -- Synchronizes q outputs from memory.
        outclock : in std_logic := '0';
        -- Write enable input. Enables write operations to the memory when high. (Required)
        we       : in std_logic;
        -- Data output from the memory. (Required)
        q        : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_RAM_DQ;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of lpm_ram_dq is

-- TYPE DECLARATION
type LPM_MEMORY is array((2**lpm_widthad)-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

-- SIGNAL DECLARATION
signal data_tmp : std_logic_vector(lpm_width-1 downto 0);
signal data_reg : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal q_tmp : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal q_reg : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal address_tmp : std_logic_vector(lpm_widthad-1 downto 0);
signal address_reg : std_logic_vector(lpm_widthad-1 downto 0) := (others => '0');
signal we_tmp : std_logic;
signal we_reg : std_logic := '0';

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widthad <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthad parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (IS_VALID_FAMILY(intended_device_family) = false) then
            ASSERT FALSE
            REPORT "Unknown intended_device_family " & intended_device_family
            SEVERITY ERROR;
        end if;

        wait;
    end process MSG;

    SYNC: process(  data, data_reg, address, address_reg,
                    we, we_reg, q_tmp, q_reg)
    begin
        if (lpm_address_control = "REGISTERED") then
            address_tmp <= address_reg;
            we_tmp <= we_reg;
        elsif (lpm_address_control = "UNREGISTERED") then
            address_tmp <= address;
            we_tmp <= we;
        else
            ASSERT FALSE
            REPORT "Illegal lpm_address_control property value for LPM_RAM_DQ!"
            SEVERITY ERROR;
        end if;
        
        if (lpm_indata = "REGISTERED") then
            data_tmp <= data_reg;
        elsif (lpm_indata = "UNREGISTERED") then
            data_tmp <= data;
        else
            ASSERT FALSE
            REPORT "Illegal lpm_indata property value for LPM_RAM_DQ!"
            SEVERITY ERROR;
        end if;
        
        if (lpm_outdata = "REGISTERED") then
            q <= q_reg;
        elsif (lpm_outdata = "UNREGISTERED") then
            q <= q_tmp;
        else
            ASSERT FALSE
            REPORT "Illegal lpm_outdata property value for LPM_RAM_DQ!"
            SEVERITY ERROR;
        end if;
    end process SYNC;

    INPUT_REG: process (inclock)
    begin
        if (inclock'event and (inclock = '1')) then
            data_reg <= data;
            address_reg <= address;
            we_reg <= we;
        end if;
    end process INPUT_REG;

    OUTPUT_REG: process (outclock)
    begin
        if (outclock'event and (outclock = '1')) then
            q_reg <= q_tmp;
        end if;
    end process OUTPUT_REG;

    MEMORY: process(data_tmp, we_tmp, address_tmp, inclock)
    variable mem_data : LPM_MEMORY;
    variable mem_data_word : std_logic_vector(lpm_width-1 downto 0);
    variable mem_init: boolean := false;
    variable i, j, k, n, m, lineno: integer := 0;
    variable buf: line ;
    variable booval: boolean ;
    FILE mem_data_file: TEXT IS IN lpm_file;
    variable char : string(1 downto 1) := " ";
    variable base, byte, rec_type, datain, addr, checksum: string(2 downto 1);
    variable startadd: string(4 downto 1);
    variable ibase: integer := 0;
    variable ibyte: integer := 0;
    variable istartadd: integer := 0;
    variable check_sum_vec, check_sum_vec_tmp: std_logic_vector(7 downto 0);
    variable m_string : string(1 to 15);
    variable m_data_radix : string(1 to 3);
    variable m_address_radix : string(1 to 3);
    variable m_width : integer;
    variable m_depth : integer;
    variable m_start_address_int : integer := 0;
    variable m_end_address_int : integer := 0;
    variable m_address_int : integer := 0;
    variable m_data_int : std_logic_vector(lpm_width+4 downto 0) := (OTHERS => '0');
    variable found_keyword_content : boolean := false;
    variable get_memory_content : boolean := false;
    variable get_start_Address : boolean := false;
    variable get_end_Address : boolean := false;
    begin
        -- Initialize
        if not (mem_init) then
            -- Initialize to 0
            for i in mem_data'LOW to mem_data'HIGH loop
                mem_data(i) := (OTHERS => '0');
            end loop;

            if (lpm_file /= "UNUSED") then
                if (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".hex") then
                    while not ENDFILE(mem_data_file) loop
                        booval := true;
                        READLINE(mem_data_file, buf);
                        lineno := lineno + 1;
                        check_sum_vec := (OTHERS => '0');
                        if (buf(buf'low) = ':') then
                            i := 1;
                            SHRINK_LINE(buf, i);
                            READ(L=>buf, VALUE=>byte, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format!"
                                SEVERITY ERROR;
                            end if;
                            ibyte := HEX_STR_TO_INT(byte);
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(ibyte, 8));
                            READ(L=>buf, VALUE=>startadd, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            istartadd := HEX_STR_TO_INT(startadd);
                            addr(2) := startadd(4);
                            addr(1) := startadd(3);
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            addr(2) := startadd(2);
                            addr(1) := startadd(1);
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            READ(L=>buf, VALUE=>rec_type, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(rec_type), 8));
                        else
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                            SEVERITY ERROR;
                        end if;
                        case rec_type is
                            when "00"=>     -- data record
                                i := 0;
                                k := lpm_width / 8;
                                if ((lpm_width mod 8) /= 0) then
                                    k := k + 1; 
                                end if;
                                -- k = no. of bytes per CAM entry.
                                while (i < ibyte) loop
                                    mem_data_word := (others => '0');
                                    n := (k - 1)*8;
                                    m := lpm_width - 1;
                                    
                                    for j in 1 to k loop
                                        READ(L=>buf, VALUE=>datain,good=>booval); -- read in data a byte (2 hex chars) at a time.
                                        if not (booval) then
                                            ASSERT FALSE
                                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                            SEVERITY ERROR;
                                        end if;
                                        check_sum_vec :=    unsigned(check_sum_vec) + 
                                                            unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), 8));
                                        mem_data_word(m downto n) := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), m-n+1);
                                        m := n - 1;
                                        n := n - 8;
                                    end loop;
                                    i := i + k;
                                    mem_data(ibase + istartadd) := mem_data_word;
                                    istartadd := istartadd + 1;
                                end loop;
                            when "01"=>
                                exit;
                            when "02"=>
                                ibase := 0;
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format for record type 02! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := (ibase * 256) + HEX_STR_TO_INT(base);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec :=    unsigned(check_sum_vec) + 
                                                        unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 16;
                            when "03"=>
                        
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 03! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when "04"=>
                                ibase := 0;
                        
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 04! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := (ibase * 256) + HEX_STR_TO_INT(base);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 65536;
                            when "05"=>
                        
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 05! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when OTHERS =>
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal record type in Intel Hex File! "
                                SEVERITY ERROR;
                        end case;
                        READ(L=>buf, VALUE=>checksum,good=>booval);
                        if not (booval) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Checksum is missing! "
                            SEVERITY ERROR;
                        end if;
    
                        check_sum_vec := unsigned(not (check_sum_vec)) + 1 ;
                        check_sum_vec_tmp := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(checksum),8);
    
                        if (unsigned(check_sum_vec) /= unsigned(check_sum_vec_tmp)) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Incorrect checksum!"
                            SEVERITY ERROR;
                        end if;
                    end loop;
                elsif (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".mif") then
                    -- ************************************************
                    -- Read in RAM initialization file (mif)
                    -- ************************************************
                    while not endfile(mem_data_file) loop
                        booval := true;
                        readline(mem_data_file, buf);
                        lineno := lineno + 1;
                        LOOP2 : while (buf'length > 0) loop
                            if (buf(buf'low) = '-') then
                                if (buf(buf'low) = '-') then
                                    -- ignore comment started with --.
                                    exit LOOP2;
                                end if;
                            elsif (buf(buf'low) = '%') then
                                i := 1;
                                
                                -- ignore comment which begin with % and end with another %.
                                while ((i < buf'high) and (buf(buf'low + i) /= '%')) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i+1);
                                end if;
                            elsif ((buf(buf'low) = ' ') or (buf(buf'low) = HT)) then
                                i := 1;
                                -- ignore space or tab character.
                                while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i);
                                end if;
                            elsif (get_memory_content = true) then
                            
                                if (((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "end") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "END") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "End")) then
                                    get_memory_content := false;
                                    exit LOOP2;
                                else
                                    get_start_address := false;
                                    get_end_address := false;
                                    m_start_address_int := 0;
                                    m_end_address_int := 0;
                                    m_address_int := 0;
                                    m_data_int := (others => '0');
                                    if (buf(buf'low) = '[') then
                                        get_start_Address := true;
                                        SHRINK_LINE(buf, 1);
                                    end if;
        
                                    case m_address_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported address_radix!"
                                            severity error;
                                    end case;
        
                                    if (get_start_Address = true) then
                                    
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;
            
                                        if ((buf(buf'low) = '.') and (buf(buf'low+1) = '.')) then
                                            get_start_Address := false;
                                            get_end_Address := true;
                                            m_start_address_int := m_address_int;
                                            SHRINK_LINE(buf, 2);    
                                        end if;
                                    end if;
        
                                    if (get_end_address = true) then
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;                                
                                        
                                        m_address_int := 0;
                                        case m_address_radix is
                                            when "hex" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                                end loop;
                                            when "bin" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                                end loop;
                                            when "dec" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "uns" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "oct" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                                end loop;
                                            when others =>
                                                assert false
                                                report "Unsupported address_radix!"
                                                severity error;
                                        end case;
        
                                        if (buf(buf'low) = ']') then
                                            get_end_address := false;
                                            m_end_address_int := m_address_int;
                                            SHRINK_LINE(buf, 1);    
                                        end if;
                                    end if;
                                        
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;                                
                                    
                                    if (buf(buf'low) = ':') then
                                        SHRINK_LINE(buf, 1);    
                                    end if;
                                    
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;
            
                                    case m_data_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+4 downto 0) := m_data_int(lpm_width-1 downto 0) * "10000" + conv_std_logic_vector(HEX_STR_TO_INT(char), 4);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+1 downto 0) := m_data_int(lpm_width-1 downto 0) * "10" + conv_std_logic_vector(BIN_STR_TO_INT(char), 4);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1000" + conv_std_logic_vector(OCT_STR_TO_INT(char), 4);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported data_radix!"
                                            severity error;
                                        end case;                           
        
                                        if (m_start_address_int /= m_end_address_int) then
                                            for i in m_start_address_int to m_end_address_int loop
                                                mem_data(i) := m_data_int(lpm_width-1 downto 0);
                                            end loop;
                                        else
                                            mem_data(m_address_int) := m_data_int(lpm_width-1 downto 0);
                                        end if;
                                    exit LOOP2;
                                end if;                                
                            elsif ((buf(buf'low) = 'W') or (buf(buf'low) = 'w')) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "width") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_width := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif (((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) and
                                    ((buf(buf'low+1) = 'E') or (buf(buf'low+1) = 'e'))) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "depth") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_depth := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) then
                                read(l=>buf, value=>m_string(1 to 10));
        
                                if (ALPHA_TOLOWER(m_string(1 to 10))  = "data_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_data_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'A') or (buf(buf'low) = 'a')) then
                                read(l=>buf, value=>m_string(1 to 13));
        
                                if (ALPHA_TOLOWER(m_string(1 to 13))  = "address_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_address_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'C') or (buf(buf'low) = 'c')) then
                                read(l=>buf, value=>m_string(1 to 7));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 7))  = "content") then
                                    found_keyword_content := true;
                                end if;
                            elsif ((buf(buf'low) = 'B') or (buf(buf'low) = 'b')) then
                                read(l=>buf, value=>m_string(1 to 5));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "begin") then
                                    if (found_keyword_content = true) then
                                        get_memory_content := true;
                                    end if;
                                end if;
                            end if;
                        end loop;
                    end loop;
                
                else
                    assert false
                    report "Unsupported memory initialization file type (" & (lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) & ")!"
                    severity error;
                end if;
            end if;
            mem_init := TRUE;
        end if;

        -- MEMORY FUNCTION --
        if (we_tmp = '1') then
            if (((use_eab = "ON") or 
                (lpm_hint = "use_eab=ON")) and (lpm_address_control = "REGISTERED")) then
                if (inclock = '0') then
                    mem_data (conv_integer(address_tmp)) := data_tmp ;
                end if;
            else
                mem_data (conv_integer(address_tmp)) := data_tmp;
            end if;
        end if;
        q_tmp <= mem_data(conv_integer(address_tmp));
    end process MEMORY;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_ram_dp
--
-- Description     :  Parameterized dual-port RAM megafunction.
--
-- Limitation      :  n/a
--
-- Results Expected:  Data output from the memory.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_DEVICE_FAMILIES.all;
use work.LPM_COMMON_CONVERSION.all;
use std.textio.all;

-- ENTITY DECLARATION
entity LPM_RAM_DP is
    generic (
        -- Width of the data[] and q[] ports. (Required)
        lpm_width    : natural; 
        -- Width of the rdaddress[] and wraddress[] ports. (Required)
        lpm_widthad  : natural;
        -- Number of words stored in memory.
        lpm_numwords : natural := 0;
        -- Determines the clock used by the data port.
        lpm_indata   : string := "REGISTERED";
        -- Determines the clock used by the rdaddress and rden ports.
        lpm_rdaddress_control : string := "REGISTERED";
        -- Determines the clock used by the wraddress and wren ports.
        lpm_wraddress_control : string := "REGISTERED";
        -- Determines the clock used by the q[] port. 
        lpm_outdata  : string := "REGISTERED";
        -- Name of the file containing RAM initialization data.
        lpm_file     : string := "UNUSED";
        -- Specified whether to use the EAB or not.
        use_eab      : string := "ON";
        -- Specified whether to use the rden port or not.
        rden_used    : string := "TRUE";
        intended_device_family : string := "UNUSED";
        lpm_type     : string := "LPM_RAM_DP";
        lpm_hint     : string := "UNUSED"
    );
    port (
        -- Data input to the memory. (Required)
        data      : in std_logic_vector(lpm_width-1 downto 0);
        -- Read address input to the memory. (Required)
        rdaddress : in std_logic_vector(lpm_widthad-1 downto 0);
        -- Write address input to the memory. (Required)
        wraddress : in std_logic_vector(lpm_widthad-1 downto 0);
        -- Positive-edge-triggered clock for read operation.
        rdclock   : in std_logic := '0';
        -- Clock enable for rdclock.
        rdclken   : in std_logic := '1';
        -- Positive-edge-triggered clock for write operation.
        wrclock   : in std_logic := '0';
        -- Clock enable for wrclock.
        wrclken   : in std_logic := '1';
        -- Read enable input. Disables reading when low (0). 
        rden      : in std_logic := '1';
        -- Write enable input. (Required)
        wren      : in std_logic;
        -- Data output from the memory. (Required)
        q         : out std_logic_vector(lpm_width-1 downto 0)
    );

end LPM_RAM_DP;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_RAM_DP is

-- TYPE DECLARATION
type LPM_MEMORY is array((2**lpm_widthad)-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

-- SIGNAL DECLARATION
signal data_tmp : std_logic_vector(lpm_width-1 downto 0);
signal data_reg : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal q_reg : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal q_tmp : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal rdaddress_tmp : std_logic_vector(lpm_widthad-1 downto 0);
signal rdaddress_reg : std_logic_vector(lpm_widthad-1 downto 0) := (others => '0');
signal wraddress_tmp : std_logic_vector(lpm_widthad-1 downto 0);
signal wraddress_reg : std_logic_vector(lpm_widthad-1 downto 0) := (others => '0');
signal wren_tmp : std_logic;
signal wren_reg : std_logic := '0';
signal rden_tmp : std_logic;
signal rden_reg : std_logic := '0';

begin

-- SIGNAL ASSIGNMENTS

    rden_tmp <= '1' when (rden_used = "FALSE")
        else rden when (lpm_rdaddress_control = "UNREGISTERED")
        else rden_reg;
        
    rdaddress_tmp <= rdaddress when (lpm_rdaddress_control = "UNREGISTERED")
        else rdaddress_reg;
        
    wren_tmp <= wren when (lpm_wraddress_control = "UNREGISTERED")
        else wren_reg;
        
    wraddress_tmp <= wraddress when (lpm_wraddress_control = "UNREGISTERED")
        else wraddress_reg;
        
    data_tmp <= data when (lpm_indata = "UNREGISTERED")
        else data_reg;
        
    q <= q_tmp when (lpm_outdata = "UNREGISTERED")
        else q_reg;

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widthad <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthad parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if ((lpm_indata /= "REGISTERED") and (lpm_indata /= "UNREGISTERED")) then
            ASSERT FALSE
            REPORT "Value lpm_indata must be 'REGISTERED' or 'UNREGISTERED'!"
            SEVERITY ERROR;
        end if;

        if ((lpm_outdata /= "REGISTERED") and (lpm_outdata /= "UNREGISTERED")) then
            ASSERT FALSE
            REPORT "Value of lpm_outdata parameter must be 'REGISTERED' or 'UNREGISTERED'!"
            SEVERITY ERROR;
        end if;       

        if ((lpm_wraddress_control /= "REGISTERED") and
            (lpm_wraddress_control /= "UNREGISTERED")) then
            ASSERT FALSE
            REPORT "Value of lpm_wraddress_control parameter must be 'REGISTERED' or 'UNREGISTERED'!"
            SEVERITY ERROR;
        end if;       

        if ((lpm_rdaddress_control /= "REGISTERED") and
            (lpm_rdaddress_control /= "UNREGISTERED")) then
            ASSERT FALSE
            REPORT "Value of lpm_rdaddress_control parameter must be 'REGISTERED' or 'UNREGISTERED'!"
            SEVERITY ERROR;
        end if;       

        if (IS_VALID_FAMILY(intended_device_family) = false) then
            ASSERT FALSE
            REPORT "Unknown INTENDED_DEVICE_FAMILY " & intended_device_family
            SEVERITY ERROR;
        end if;

        wait;
    end process MSG;

    INPUT_REG: process (wrclock)
    begin
        if (wrclock'event and (wrclock = '1')) then
            if (wrclken = '1') then
                data_reg <= data;
                wraddress_reg <= wraddress;
                wren_reg <= wren;
            end if;
        end if;
    end process INPUT_REG;

    OUTPUT_REG: process (rdclock)
    begin
        if (rdclock'event and (rdclock = '1')) then
            if (rdclken = '1') then
                rdaddress_reg <= rdaddress;
                rden_reg <= rden; 
                q_reg <= q_tmp;
            end if;
        end if;
    end process OUTPUT_REG;

    MEMORY: process(data_tmp, wren_tmp, rdaddress_tmp, wraddress_tmp, rden_tmp, wrclock)
    variable mem_data : LPM_MEMORY;
    variable mem_data_word : std_logic_vector(lpm_width-1 downto 0);
    variable mem_init: boolean := false;
    variable i, j, k, n, m, lineno : integer := 0;
    variable buf: line ;
    variable booval: boolean ;
    FILE mem_data_file: TEXT IS IN lpm_file;
    variable char              : string(1 downto 1) := " ";
    variable base, byte, rec_type, datain, addr, checksum : string(2 downto 1) := "  ";
    variable startadd : string(4 downto 1) := "    ";
    variable ibase : integer := 0;
    variable ibyte : integer := 0;
    variable istartadd : integer := 0;
    variable check_sum_vec, check_sum_vec_tmp : std_logic_vector(7 downto 0);
    variable m_string : string(1 to 15);
    variable m_data_radix : string(1 to 3);
    variable m_address_radix : string(1 to 3);
    variable m_width : integer;
    variable m_depth : integer;
    variable m_start_address_int : integer := 0;
    variable m_end_address_int : integer := 0;
    variable m_address_int : integer := 0;
    variable m_data_int : std_logic_vector(lpm_width+4 downto 0) := (OTHERS => '0');
    variable found_keyword_content : boolean := false;
    variable get_memory_content : boolean := false;
    variable get_start_Address : boolean := false;
    variable get_end_Address : boolean := false;
    begin
        -- Initialize
        if NOT(mem_init) then
            -- Initialize to 0
            for i in mem_data'LOW to mem_data'HIGH loop
                mem_data(i) := (OTHERS => '0');
            end loop;

            if ((use_eab = "ON") or (lpm_hint = "use_eab=ON")) then
                q_tmp <= (others => '1');
            end if;

            if (lpm_file /= "UNUSED") then
                if (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".hex") then               
                    while not ENDFILE(mem_data_file) loop
                        booval := true;
                        READLINE(mem_data_file, buf);
                        lineno := lineno + 1;
                        check_sum_vec := (OTHERS => '0');
                        if (buf(buf'LOW) = ':') then
                            i := 1;
                            SHRINK_LINE(buf, i);
                            READ(L=>buf, VALUE=>byte, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format!"
                                SEVERITY ERROR;
                            end if;
                            ibyte := HEX_STR_TO_INT(byte);
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(ibyte, 8));
                            READ(L=>buf, VALUE=>startadd, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            istartadd := HEX_STR_TO_INT(startadd);
                            addr(2) := startadd(4);
                            addr(1) := startadd(3);
                            check_sum_vec :=    unsigned(check_sum_vec) +
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            addr(2) := startadd(2);
                            addr(1) := startadd(1);
                            check_sum_vec :=    unsigned(check_sum_vec) +
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            READ(L=>buf, VALUE=>rec_type, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            check_sum_vec :=    unsigned(check_sum_vec) +
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(rec_type), 8));
                        else
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                            SEVERITY ERROR;
                        end if;
                        case rec_type is
                            when "00" =>     -- data record
                                i := 0;
                                k := lpm_width / 8;
                                if ((lpm_width mod 8) /= 0) then
                                    k := k + 1; 
                                end if;
                                -- k = no. of bytes per CAM entry.
                                while (i < ibyte) loop
                                    mem_data_word := (others => '0');
                                    n := (k - 1)*8;
                                    m := lpm_width - 1;
                                    
                                    for j in 1 to k loop
                                        -- read in data a byte (2 hex chars) at a time.
                                        READ(L=>buf, VALUE=>datain,good=>booval); 
                                        if not (booval) then
                                            ASSERT FALSE
                                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                            SEVERITY ERROR;
                                        end if;
                                        check_sum_vec :=    unsigned(check_sum_vec) + 
                                                            unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), 8));
                                        mem_data_word(m downto n) := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), m-n+1);
                                        m := n - 1;
                                        n := n - 8;
                                    end loop;
                                    i := i + k;
                                    mem_data(ibase + istartadd) := mem_data_word;
                                    istartadd := istartadd + 1;
                                end loop;
                            when "01"=>
                                exit;
                            when "02"=>
                                ibase := 0;
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format for record type 02! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := ibase * 256 + HEX_STR_TO_INT(base);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec :=    unsigned(check_sum_vec) +
                                                        unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 16;
                            when "03"=>
                        
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 03! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when "04"=>
                                ibase := 0;
                        
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 04! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := (ibase * 256) + HEX_STR_TO_INT(base);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 65536;
                            when "05"=>
                        
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 05! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when OTHERS =>
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal record type in Intel Hex File! "
                                SEVERITY ERROR;
                        end case;
                        READ(L=>buf, VALUE=>checksum,good=>booval);
                        if not (booval) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Checksum is missing! "
                            SEVERITY ERROR;
                        end if;
    
                        check_sum_vec := unsigned(not (check_sum_vec)) + 1 ;
                        check_sum_vec_tmp := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(checksum),8);
    
                        if (unsigned(check_sum_vec) /= unsigned(check_sum_vec_tmp)) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Incorrect checksum!"
                            SEVERITY ERROR;
                        end if;
                    end loop;
                elsif (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".mif") then
                    -- ************************************************
                    -- Read in RAM initialization file (mif)
                    -- ************************************************
                    while not endfile(mem_data_file) loop
                        booval := true;
                        readline(mem_data_file, buf);
                        lineno := lineno + 1;
                        LOOP2 : while (buf'length > 0) loop
                            if (buf(buf'low) = '-') then
                                if (buf(buf'low) = '-') then
                                    -- ignore comment started with --.
                                    exit LOOP2;
                                end if;
                            elsif (buf(buf'low) = '%') then
                                i := 1;
                                
                                -- ignore comment which begin with % and end with another %.
                                while ((i < buf'high) and (buf(buf'low + i) /= '%')) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i+1);
                                end if;
                            elsif ((buf(buf'low) = ' ') or (buf(buf'low) = HT)) then
                                i := 1;
                                -- ignore space or tab character.
                                while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i);
                                end if;
                            elsif (get_memory_content = true) then
                            
                                if (((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "end") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "END") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "End")) then
                                    get_memory_content := false;
                                    exit LOOP2;
                                else
                                    get_start_address := false;
                                    get_end_address := false;
                                    m_start_address_int := 0;
                                    m_end_address_int := 0;
                                    m_address_int := 0;
                                    m_data_int := (others => '0');
                                    if (buf(buf'low) = '[') then
                                        get_start_Address := true;
                                        SHRINK_LINE(buf, 1);
                                    end if;
        
                                    case m_address_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported address_radix!"
                                            severity error;
                                    end case;
        
                                    if (get_start_Address = true) then
                                    
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;
            
                                        if ((buf(buf'low) = '.') and (buf(buf'low+1) = '.')) then
                                            get_start_Address := false;
                                            get_end_Address := true;
                                            m_start_address_int := m_address_int;
                                            SHRINK_LINE(buf, 2);    
                                        end if;
                                    end if;
        
                                    if (get_end_address = true) then
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;                                
                                        
                                        m_address_int := 0;
                                        case m_address_radix is
                                            when "hex" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                                end loop;
                                            when "bin" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                                end loop;
                                            when "dec" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "uns" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "oct" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                                end loop;
                                            when others =>
                                                assert false
                                                report "Unsupported address_radix!"
                                                severity error;
                                        end case;
        
                                        if (buf(buf'low) = ']') then
                                            get_end_address := false;
                                            m_end_address_int := m_address_int;
                                            SHRINK_LINE(buf, 1);    
                                        end if;
                                    end if;
                                        
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;                                
                                    
                                    if (buf(buf'low) = ':') then
                                        SHRINK_LINE(buf, 1);    
                                    end if;
                                    
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;
            
                                    case m_data_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+4 downto 0) := m_data_int(lpm_width-1 downto 0) * "10000" + conv_std_logic_vector(HEX_STR_TO_INT(char), 4);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+1 downto 0) := m_data_int(lpm_width-1 downto 0) * "10" + conv_std_logic_vector(BIN_STR_TO_INT(char), 4);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1000" + conv_std_logic_vector(OCT_STR_TO_INT(char), 4);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported data_radix!"
                                            severity error;
                                        end case;                           
        
                                        if (m_start_address_int /= m_end_address_int) then
                                            for i in m_start_address_int to m_end_address_int loop
                                                mem_data(i) := m_data_int(lpm_width-1 downto 0);
                                            end loop;
                                        else
                                            mem_data(m_address_int) := m_data_int(lpm_width-1 downto 0);
                                        end if;
                                    exit LOOP2;
                                end if;                                
                            elsif ((buf(buf'low) = 'W') or (buf(buf'low) = 'w')) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "width") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_width := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif (((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) and
                                    ((buf(buf'low+1) = 'E') or (buf(buf'low+1) = 'e'))) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "depth") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_depth := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) then
                                read(l=>buf, value=>m_string(1 to 10));
        
                                if (ALPHA_TOLOWER(m_string(1 to 10))  = "data_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_data_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'A') or (buf(buf'low) = 'a')) then
                                read(l=>buf, value=>m_string(1 to 13));
        
                                if (ALPHA_TOLOWER(m_string(1 to 13))  = "address_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_address_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'C') or (buf(buf'low) = 'c')) then
                                read(l=>buf, value=>m_string(1 to 7));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 7))  = "content") then
                                    found_keyword_content := true;
                                end if;
                            elsif ((buf(buf'low) = 'B') or (buf(buf'low) = 'b')) then
                                read(l=>buf, value=>m_string(1 to 5));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "begin") then
                                    if (found_keyword_content = true) then
                                        get_memory_content := true;
                                    end if;
                                end if;
                            end if;
                        end loop;
                    end loop;
                
                else
                    assert false
                    report "Unsupported memory initialization file type (" & (lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) & ")!"
                    severity error;
                end if;

            end if;
            mem_init := TRUE;
        end if;

        -- MEMORY FUNCTION --
        if (wren_tmp = '1') then
            if (((use_eab = "ON") or (lpm_hint = "use_eab=ON")) and
                (lpm_wraddress_control = "REGISTERED")) then
                if (wrclock = '0') then
                    mem_data (conv_integer(wraddress_tmp)) := data_tmp;
                end if;
            else
                mem_data (conv_integer(wraddress_tmp)) := data_tmp ;
            end if;
        end if;
        if ((rden_tmp = '1') or (rden_used = "FALSE")) then
            q_tmp <= mem_data(conv_integer(rdaddress_tmp));
        end if;
    end process MEMORY;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_ram_io
--
-- Description     :  
--
-- Limitation      :  
--
-- Results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;
use std.textio.all;

entity LPM_RAM_IO is
    generic (   LPM_WIDTH : natural;    -- MUST be greater than 0
                LPM_WIDTHAD : natural;    -- MUST be greater than 0
                LPM_NUMWORDS : natural := 0;
                LPM_INDATA : string := "REGISTERED";
                LPM_ADDRESS_CONTROL : string := "REGISTERED";
                LPM_OUTDATA : string := "REGISTERED";
                LPM_FILE : string := "UNUSED";
                LPM_TYPE : string := "LPM_RAM_IO";
                USE_EAB  : string := "ON";
                INTENDED_DEVICE_FAMILY  : string := "UNUSED";
                LPM_HINT : string := "UNUSED");
    port (  ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
            INCLOCK : in STD_LOGIC := '0';
            OUTCLOCK : in STD_LOGIC := '0';
            MEMENAB : in STD_LOGIC := '1';
            OUTENAB : in STD_LOGIC := 'Z';
            WE : in STD_LOGIC := 'Z';
            DIO : inout STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0));

end LPM_RAM_IO;

architecture LPM_SYN of lpm_ram_io is

--type lpm_memory is array(lpm_numwords-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);
type lpm_memory is array((2**lpm_widthad)-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

signal data_tmp, di, do : std_logic_vector(lpm_width-1 downto 0);
signal data_reg : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal q_tmp, q : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal q_reg : std_logic_vector(lpm_width-1 downto 0) := (others => '0');
signal address_tmp : std_logic_vector(lpm_widthad-1 downto 0);
signal address_reg : std_logic_vector(lpm_widthad-1 downto 0) := (others => '0');
signal we_tmp : std_logic;
signal we_reg : std_logic := '0';
signal memenab_tmp : std_logic;
signal memenab_reg : std_logic := '0';

signal outenab_used : std_logic;

-- provided for MP2 compliance
signal we_used : std_logic;

begin
    sync: process(  di, data_reg, address, address_reg, memenab, memenab_reg, 
                    we,we_reg, q_tmp, q_reg)
    begin
        if (lpm_address_control = "REGISTERED") then
            address_tmp <= address_reg;
            we_tmp <= we_reg;
            memenab_tmp <= memenab_reg;
        elsif (lpm_address_control = "UNREGISTERED") then
            address_tmp <= address;
            we_tmp <= we;
            memenab_tmp <= memenab;
        else
            ASSERT FALSE
            REPORT "Illegal LPM_ADDRESS_CONTROL property value for LPM_RAM_IO!"
            SEVERITY ERROR;
        end if;
        if (lpm_indata = "REGISTERED") then
            data_tmp <= data_reg;
        elsif (lpm_indata = "UNREGISTERED") then
            data_tmp <= di;
        else
            ASSERT FALSE
            REPORT "Illegal LPM_INDATA property value for LPM_RAM_IO!"
            SEVERITY ERROR;
        end if;
        if (lpm_outdata = "REGISTERED") then
            q <= q_reg;
        elsif (lpm_outdata = "UNREGISTERED") then
            q <= q_tmp;
        else
            ASSERT FALSE
            REPORT "Illegal LPM_OUTDATA property value for LPM_RAM_IO!"
            SEVERITY ERROR;
        end if;
    end process;

    input_reg: process (inclock)
    begin
        if inclock'event and inclock = '1' then
            data_reg <= di;
            address_reg <= address;
            we_reg <= we;
            memenab_reg <= memenab;
        end if;
    end process;

    output_reg: process (outclock)
    begin
        if outclock'event and outclock = '1' then
            q_reg <= q_tmp;
        end if;
    end process;

    INITIALIZE : process(we, outenab)
    variable init : boolean := FALSE;
    begin
        if NOT (init) then
            if (outenab = 'Z' and we = 'Z') then
                ASSERT FALSE
                REPORT "One of OutEnab or WE must be used!"
                SEVERITY ERROR;
            end if;

            -- In reality, both are needed in current TDF implementation
            if (outenab /= 'Z' and we /= 'Z') then
                ASSERT FALSE
                REPORT "Only one of OutEnab or WE should be used!"
                -- Change severity to ERROR for full LPM 220 compliance
                SEVERITY WARNING;
            end if;

            -- Comment out the following 5 lines for full LPM 220 compliance
            if (we = 'Z') then
                ASSERT FALSE
                REPORT "WE is required!"
                SEVERITY WARNING;
            end if;

            if (outenab = 'Z') then
                outenab_used <= '0';
                we_used <= '1';
            else
                outenab_used <= '1';
                we_used <= '0';
            end if;
            
            -- Comment out the following 5 lines for full LPM 220 compliance
            if (we = 'Z') then
                we_used <= '0';
            else
                we_used <= '1';
            end if;

            init := TRUE;
        end if;
    end process;
    
    memory: process(data_tmp, we_tmp, memenab_tmp, outenab, address_tmp, inclock, we_used, outenab_used)
    variable mem_data : lpm_memory;
        variable mem_data_word : std_logic_vector(lpm_width-1 downto 0);
    variable mem_init: boolean := false;
    variable i,j,k,n,m,lineno: integer := 0;
    variable buf: line ;
    variable booval: boolean ;
    FILE mem_data_file: TEXT IS IN lpm_file;
    variable char : string(1 downto 1) := " ";
    variable base, byte, rec_type, datain, addr, checksum: string(2 downto 1);
    variable startadd: string(4 downto 1);
    variable ibase: integer := 0;
    variable ibyte: integer := 0;
    variable istartadd: integer := 0;
    variable check_sum_vec, check_sum_vec_tmp: std_logic_vector(7 downto 0);
    variable m_string : string(1 to 15);
    variable m_data_radix : string(1 to 3);
    variable m_address_radix : string(1 to 3);
    variable m_width : integer;
    variable m_depth : integer;
    variable m_start_address_int : integer := 0;
    variable m_end_address_int : integer := 0;
    variable m_address_int : integer := 0;
    variable m_data_int : std_logic_vector(lpm_width+4 downto 0) := (OTHERS => '0');
    variable found_keyword_content : boolean := false;
    variable get_memory_content : boolean := false;
    variable get_start_Address : boolean := false;
    variable get_end_Address : boolean := false;
    begin
        -- INITIALIZE --
        if NOT(mem_init) then
            -- INITIALIZE TO 0 --
            for i in mem_data'LOW to mem_data'HIGH loop
                mem_data(i) := (OTHERS => '0');
            end loop;


            if (LPM_FILE /= "UNUSED") then
                if (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".hex") then
                    WHILE NOT ENDFILE(mem_data_file) loop
                        booval := true;
                        READLINE(mem_data_file, buf);
                        lineno := lineno + 1;
                        check_sum_vec := (OTHERS => '0');
                        if (buf(buf'LOW) = ':') then
                            i := 1;
                            SHRINK_LINE(buf, i);
                            READ(L=>buf, VALUE=>byte, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format!"
                                SEVERITY ERROR;
                            end if;
                            ibyte := HEX_STR_TO_INT(byte);
                            check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(ibyte, 8));
                            READ(L=>buf, VALUE=>startadd, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            istartadd := HEX_STR_TO_INT(startadd);
                            addr(2) := startadd(4);
                            addr(1) := startadd(3);
                            check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            addr(2) := startadd(2);
                            addr(1) := startadd(1);
                            check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            READ(L=>buf, VALUE=>rec_type, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(rec_type), 8));
                        else
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                            SEVERITY ERROR;
                        end if;
                        case rec_type is
                            when "00"=>     -- Data record
                                i := 0;
                                k := lpm_width / 8;
                                if ((lpm_width MOD 8) /= 0) then
                                    k := k + 1; 
                                end if;
                                -- k = no. of bytes per CAM entry.
                                while (i < ibyte) loop
                                    mem_data_word := (others => '0');
                                    n := (k - 1)*8;
                                    m := lpm_width - 1;
                                    for j in 1 to k loop
                                        READ(L=>buf, VALUE=>datain,good=>booval); -- read in data a byte (2 hex chars) at a time.
                                        if not (booval) then
                                            ASSERT FALSE
                                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                            SEVERITY ERROR;
                                        end if;
                                        check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), 8));
                                        mem_data_word(m downto n) := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), m-n+1);
                                        m := n - 1;
                                        n := n - 8;
                                    end loop;
                                    i := i + k;
                                    mem_data(ibase + istartadd) := mem_data_word;
                                    istartadd := istartadd + 1;
                                end loop;
                            when "01"=>
                                exit;
                            when "02"=>
                                ibase := 0;
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format for record type 02! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := ibase * 256 + HEX_STR_TO_INT(base);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 16;
                            when "03"=>
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 03! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when "04"=>
                                ibase := 0;
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 04! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := (ibase * 256) + HEX_STR_TO_INT(base);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 65536;
                            when "05"=>
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 05! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when OTHERS =>
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal record type in Intel Hex File! "
                                SEVERITY ERROR;
                        end case;
                        READ(L=>buf, VALUE=>checksum,good=>booval);
                        if not (booval) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Checksum is missing! "
                            SEVERITY ERROR;
                        end if;
    
                        check_sum_vec := unsigned(not (check_sum_vec)) + 1 ;
                        check_sum_vec_tmp := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(checksum),8);
    
                        if (unsigned(check_sum_vec) /= unsigned(check_sum_vec_tmp)) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Incorrect checksum!"
                            SEVERITY ERROR;
                        end if;
                    end loop;
                elsif (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".mif") then
                    -- ************************************************
                    -- Read in RAM initialization file (mif)
                    -- ************************************************
                    while not endfile(mem_data_file) loop
                        booval := true;
                        readline(mem_data_file, buf);
                        lineno := lineno + 1;
                        LOOP2 : while (buf'length > 0) loop
                            if (buf(buf'low) = '-') then
                                if (buf(buf'low) = '-') then
                                    -- ignore comment started with --.
                                    exit LOOP2;
                                end if;
                            elsif (buf(buf'low) = '%') then
                                i := 1;
                                
                                -- ignore comment which begin with % and end with another %.
                                while ((i < buf'high) and (buf(buf'low + i) /= '%')) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i+1);
                                end if;
                            elsif ((buf(buf'low) = ' ') or (buf(buf'low) = HT)) then
                                i := 1;
                                -- ignore space or tab character.
                                while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i);
                                end if;
                            elsif (get_memory_content = true) then
                            
                                if (((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "end") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "END") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "End")) then
                                    get_memory_content := false;
                                    exit LOOP2;
                                else
                                    get_start_address := false;
                                    get_end_address := false;
                                    m_start_address_int := 0;
                                    m_end_address_int := 0;
                                    m_address_int := 0;
                                    m_data_int := (others => '0');
                                    if (buf(buf'low) = '[') then
                                        get_start_Address := true;
                                        SHRINK_LINE(buf, 1);
                                    end if;
        
                                    case m_address_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported address_radix!"
                                            severity error;
                                    end case;
        
                                    if (get_start_Address = true) then
                                    
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;
            
                                        if ((buf(buf'low) = '.') and (buf(buf'low+1) = '.')) then
                                            get_start_Address := false;
                                            get_end_Address := true;
                                            m_start_address_int := m_address_int;
                                            SHRINK_LINE(buf, 2);    
                                        end if;
                                    end if;
        
                                    if (get_end_address = true) then
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;                                
                                        
                                        m_address_int := 0;
                                        case m_address_radix is
                                            when "hex" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                                end loop;
                                            when "bin" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                                end loop;
                                            when "dec" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "uns" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "oct" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                                end loop;
                                            when others =>
                                                assert false
                                                report "Unsupported address_radix!"
                                                severity error;
                                        end case;
        
                                        if (buf(buf'low) = ']') then
                                            get_end_address := false;
                                            m_end_address_int := m_address_int;
                                            SHRINK_LINE(buf, 1);    
                                        end if;
                                    end if;
                                        
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;                                
                                    
                                    if (buf(buf'low) = ':') then
                                        SHRINK_LINE(buf, 1);    
                                    end if;
                                    
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;
            
                                    case m_data_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+4 downto 0) := m_data_int(lpm_width-1 downto 0) * "10000" + conv_std_logic_vector(HEX_STR_TO_INT(char), 4);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+1 downto 0) := m_data_int(lpm_width-1 downto 0) * "10" + conv_std_logic_vector(BIN_STR_TO_INT(char), 4);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1000" + conv_std_logic_vector(OCT_STR_TO_INT(char), 4);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported data_radix!"
                                            severity error;
                                        end case;                           
        
                                        if (m_start_address_int /= m_end_address_int) then
                                            for i in m_start_address_int to m_end_address_int loop
                                                mem_data(i) := m_data_int(lpm_width-1 downto 0);
                                            end loop;
                                        else
                                            mem_data(m_address_int) := m_data_int(lpm_width-1 downto 0);
                                        end if;
                                    exit LOOP2;
                                end if;                                
                            elsif ((buf(buf'low) = 'W') or (buf(buf'low) = 'w')) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "width") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_width := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif (((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) and
                                    ((buf(buf'low+1) = 'E') or (buf(buf'low+1) = 'e'))) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "depth") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_depth := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) then
                                read(l=>buf, value=>m_string(1 to 10));
        
                                if (ALPHA_TOLOWER(m_string(1 to 10))  = "data_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_data_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'A') or (buf(buf'low) = 'a')) then
                                read(l=>buf, value=>m_string(1 to 13));
        
                                if (ALPHA_TOLOWER(m_string(1 to 13))  = "address_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_address_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'C') or (buf(buf'low) = 'c')) then
                                read(l=>buf, value=>m_string(1 to 7));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 7))  = "content") then
                                    found_keyword_content := true;
                                end if;
                            elsif ((buf(buf'low) = 'B') or (buf(buf'low) = 'b')) then
                                read(l=>buf, value=>m_string(1 to 5));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "begin") then
                                    if (found_keyword_content = true) then
                                        get_memory_content := true;
                                    end if;
                                end if;
                            end if;
                        end loop;
                    end loop;
                
                else
                    assert false
                    report "Unsupported memory initialization file type (" & (lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) & ")!"
                    severity error;
                end if;
            end if;
            mem_init := TRUE;
        end if;

        -- MEMORY FUNCTION --
        if (((we_used = '1' and we_tmp = '1')
            or (outenab_used = '1' and we_used = '0' and outenab = '0'))
            and memenab_tmp = '1') then
                        if (((use_eab = "ON") or (lpm_hint = "USE_EAB=ON")) and (lpm_address_control = "REGISTERED")) then
                if inclock = '0' then
                                mem_data (conv_integer(address_tmp)) := data_tmp ;
                            end if;
                        else
                mem_data (conv_integer(address_tmp)) := data_tmp ;
                        end if;
            q_tmp <= data_tmp ;
        else
            q_tmp <= mem_data(conv_integer(address_tmp)) ; 
        end if;
    end process;

    di <= dio when ((outenab_used = '0' and we = '1')
                    or (outenab_used = '1' and outenab = '0'))
                    else (OTHERS => 'Z');
    do <= q when memenab_tmp = '1' else (OTHERS => 'Z') ;
    dio <= do when ((outenab_used = '0' and we = '0')
                    or (outenab_used = '1' and outenab = '1'))
                    else (OTHERS => 'Z');

end LPM_SYN;

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_rom
--
-- Description     :  Parameterized ROM megafunction. This megafunction is provided
--                    only for backward compatibility in Cyclone, Stratix, and
--                    Stratix GX designs; instead, Altera recommends using the
--                    altsyncram megafunction.
--
-- Limitation      :  This option is available for all Altera devices supported by
--                    the Quartus II software except MAX 3000 and MAX 7000 devices. 
--
-- Results Expected:  Output of memory.
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_COMMON_CONVERSION.all;
use work.LPM_DEVICE_FAMILIES.all;
use std.textio.all;

-- ENTITY DECLARATION
entity LPM_ROM is
    generic (
        -- Width of the q[] port. (Required)
        lpm_width    : natural;
        -- Width of the address[] port. (Required)
        lpm_widthad  : natural;
        -- Number of words stored in memory.
        lpm_numwords : natural := 0;
        -- Indicates whether the address port is registered.
        lpm_address_control : string := "REGISTERED";
        -- Indicates whether the q and eq ports are registered.
        lpm_outdata  : string := "REGISTERED";
        -- Name of the memory file containing ROM initialization data 
        lpm_file     : string;
        intended_device_family  : string := "UNUSED";
        lpm_type     : string := "LPM_ROM";
        lpm_hint     : string := "UNUSED"
    );
    port (
        -- Address input to the memory. (Required)
        address  : in STD_LOGIC_VECTOR(lpm_widthad-1 downto 0);
        -- Clock for input registers.
        inclock  : in STD_LOGIC := '0';
        -- Clock for output registers.
        outclock : in STD_LOGIC := '0';
        -- Memory enable input.
        memenab  : in STD_LOGIC := '1';
        -- Output of memory.  (Required)
        q        : out STD_LOGIC_VECTOR(lpm_width-1 downto 0)
    );

end LPM_ROM;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of lpm_rom is

-- FUNCTION DECLARATION
    --- Get the number of word stored in memory ---
    function get_num_words (constant i_lpm_numwords,
                                        i_lpm_widthad : in natural) return natural is
        variable i_num_words : natural;

    begin
        if (i_lpm_numwords = 0)  then
            i_num_words := (2**lpm_widthad);
        elsif (i_lpm_numwords > 0)  then
            i_num_words := i_lpm_numwords;
        else
            ASSERT FALSE
            REPORT "Value of lpm_numwords parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        
        return i_num_words;

    end get_num_words;

-- CONSTANT DECLARATION
constant NUM_WORDS      : natural  := get_num_words(lpm_numwords, lpm_widthad);

-- TYPE DECLARATION
type LPM_MEMORY is array(NUM_WORDS-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

-- SIGNAL DECLARATION
signal q2, q_tmp, q_reg : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
signal address_tmp, address_reg : std_logic_vector(lpm_widthad-1 downto 0);

begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (lpm_widthad <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_widthad parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;

        if (IS_VALID_FAMILY(intended_device_family) = false) then
            ASSERT FALSE
            REPORT "Unknown INTENDED_DEVICE_FAMILY " & intended_device_family
            SEVERITY ERROR;
        end if;

        if (FEATURE_FAMILY_MAX(intended_device_family) = true) then
            ASSERT FALSE
            REPORT "LPM_ROM megafunction does not support " & intended_device_family & " devices"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;


    ENABLE_MEM: process(memenab, q2)
    begin
        if (memenab = '1') then
            q <= q2;
        else
            q <= (OTHERS => 'Z');
        end if;
    end process ENABLE_MEM;

    SYNC: process(address, address_reg, q_tmp, q_reg)
    begin
        if (lpm_address_control = "REGISTERED") then
            address_tmp <= address_reg;
        elsif (lpm_address_control = "UNREGISTERED") then
            address_tmp <= address;
        else
            ASSERT FALSE
            REPORT "Illegal lpm_address_control property value for LPM_RAM_ROM!"
            SEVERITY ERROR;
        end if;
        if (lpm_outdata = "REGISTERED") then
            q2 <= q_reg;
        elsif (lpm_outdata = "UNREGISTERED") then
            q2 <= q_tmp;
        else
            ASSERT FALSE
            REPORT "Illegal lpm_outdata property value for LPM_RAM_ROM!"
            SEVERITY ERROR;
        end if;
    end process SYNC;

    INPUT_REG: process (inclock)
    begin
        if (inclock'event and (inclock = '1')) then
            address_reg <= address;
        end if;
    end process INPUT_REG;

    OUTPUT_REG: process (outclock)
    begin
        if (outclock'event and (outclock = '1')) then
            q_reg <= q_tmp;
        end if;
    end process OUTPUT_REG;

    MEMORY: process(memenab, address_tmp)
    variable mem_data : LPM_MEMORY;
    variable mem_data_word : std_logic_vector(lpm_width-1 downto 0);
    variable mem_init: boolean := false;
    variable i, j, k, n, m, lineno : integer := 0;
    variable buf: line ;
    variable booval: boolean ;
    FILE mem_data_file: TEXT IS IN lpm_file;
    variable char : string(1 downto 1) := " ";
    variable base, byte, rec_type, datain, addr, checksum: string(2 downto 1);
    variable startadd: string(4 downto 1);
    variable ibase: integer := 0;
    variable ibyte: integer := 0;
    variable istartadd: integer := 0;
    variable check_sum_vec, check_sum_vec_tmp: std_logic_vector(7 downto 0);
    variable m_string : string(1 to 15);
    variable m_data_radix : string(1 to 3);
    variable m_address_radix : string(1 to 3);
    variable m_width : integer;
    variable m_depth : integer;
    variable m_start_address_int : integer := 0;
    variable m_end_address_int : integer := 0;
    variable m_address_int : integer := 0;
    variable m_data_int : std_logic_vector(lpm_width+4 downto 0) := (OTHERS => '0');
    variable found_keyword_content : boolean := false;
    variable get_memory_content : boolean := false;
    variable get_start_Address : boolean := false;
    variable get_end_Address : boolean := false;
    begin
        -- Initialize
        if NOT(mem_init) then
            -- check for number of words out of bound
            if ((NUM_WORDS > (2**lpm_widthad)) or
                (NUM_WORDS <= (2**(lpm_widthad-1)))) then
                ASSERT FALSE
                REPORT "The ceiling of log2(LPM_NUMWORDS) must equal to LPM_WIDTHAD!"
                SEVERITY ERROR;
            end if;

            -- Initialize to zero
            for i in mem_data'LOW to mem_data'HIGH loop
                mem_data(i) := (OTHERS => '0');
            end loop;

            if ((lpm_file = "UNUSED") or (lpm_file = "")) then
                ASSERT FALSE
                REPORT "Initialization file not found!"
                SEVERITY ERROR;
            else
                if (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".hex") then
                    WHILE NOT ENDFILE(mem_data_file) loop
                        booval := true;
                        READLINE(mem_data_file, buf);
                        lineno := lineno + 1;
                        check_sum_vec := (OTHERS => '0');
                        if (buf(buf'LOW) = ':') then
                            i := 1;
                            SHRINK_LINE(buf, i);
                            READ(L=>buf, VALUE=>byte, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format!"
                                SEVERITY ERROR;
                            end if;
                            ibyte := HEX_STR_TO_INT(byte);
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(ibyte, 8));
                            READ(L=>buf, VALUE=>startadd, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            istartadd := HEX_STR_TO_INT(startadd);
                            addr(2) := startadd(4);
                            addr(1) := startadd(3);
                            check_sum_vec :=    unsigned(check_sum_vec) + 
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            addr(2) := startadd(2);
                            addr(1) := startadd(1);
                            check_sum_vec :=    unsigned(check_sum_vec) +
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(addr), 8));
                            READ(L=>buf, VALUE=>rec_type, good=>booval);
                            if not (booval) then
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                SEVERITY ERROR;
                            end if;
                            check_sum_vec :=    unsigned(check_sum_vec) +
                                                unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(rec_type), 8));
                        else
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                            SEVERITY ERROR;
                        end if;
                        case rec_type is
                            when "00"=>  -- Data record
                                i := 0;
                                k := lpm_width / 8;
                                if ((lpm_width MOD 8) /= 0) then
                                    k := k + 1; 
                                end if;
                                -- k = no. of bytes per CAM entry.
                                while (i < ibyte) loop
                                    mem_data_word := (others => '0');
                                    n := (k - 1)*8;
                                    m := lpm_width - 1;
                                    
                                    for j in 1 to k loop
                                        -- read in data a byte (2 hex chars) at a time.
                                        READ(L=>buf, VALUE=>datain,good=>booval);
                                        if not (booval) then
                                            ASSERT FALSE
                                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                            SEVERITY ERROR;
                                        end if;
                                        check_sum_vec :=    unsigned(check_sum_vec) + 
                                                            unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), 8));
                                        mem_data_word(m downto n) := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(datain), m-n+1);
                                        m := n - 1;
                                        n := n - 8;
                                    end loop;
                                    
                                    i := i + k;
                                    mem_data(ibase + istartadd) := mem_data_word;
                                    istartadd := istartadd + 1;
                                end loop;
                            when "01"=>
                                exit;
                            when "02"=>
                                ibase := 0;
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format for record type 02! "
                                    SEVERITY ERROR;
                                end if;
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := ibase * 256 + HEX_STR_TO_INT(base);
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    check_sum_vec :=    unsigned(check_sum_vec) +                                
                                                        unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 16;
                            when "03"=>
                        
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 03! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when "04"=>
                                ibase := 0;
                        
                                if (ibyte /= 2) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 04! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    ibase := (ibase * 256) + HEX_STR_TO_INT(base);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                                ibase := ibase * 65536;
                            when "05"=>
                        
                                if (ibyte /= 4) then
                                    ASSERT FALSE
                                    REPORT  "[Line "& INT_TO_STR(lineno) & 
                                            "]:Illegal Intel Hex Format for record type 05! "
                                    SEVERITY ERROR;
                                end if;
                                
                                for i in 0 to (ibyte-1) loop
                                    READ(L=>buf, VALUE=>base,good=>booval);
                                    
                                    if not (booval) then
                                        ASSERT FALSE
                                        REPORT  "[Line "& INT_TO_STR(lineno) & 
                                                "]:Illegal Intel Hex Format! "
                                        SEVERITY ERROR;
                                    end if;
                                    
                                    check_sum_vec := unsigned(check_sum_vec) + unsigned(CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(base), 8));
                                end loop;
                            when OTHERS =>
                                ASSERT FALSE
                                REPORT "[Line "& INT_TO_STR(lineno) & "]:Illegal record type in Intel Hex File! "
                                SEVERITY ERROR;
                        end case;
                        READ(L=>buf, VALUE=>checksum,good=>booval);
                        if not (booval) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Checksum is missing! "
                            SEVERITY ERROR;
                        end if;
    
                        check_sum_vec := unsigned(not (check_sum_vec)) + 1 ;
                        check_sum_vec_tmp := CONV_STD_LOGIC_VECTOR(HEX_STR_TO_INT(checksum),8);
    
                        if (unsigned(check_sum_vec) /= unsigned(check_sum_vec_tmp)) then
                            ASSERT FALSE
                            REPORT "[Line "& INT_TO_STR(lineno) & "]:Incorrect checksum!"
                            SEVERITY ERROR;
                        end if;
                    end loop;
                elsif (ALPHA_TOLOWER(lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) = ".mif") then
                    -- ************************************************
                    -- Read in RAM initialization file (mif)
                    -- ************************************************
                    while not endfile(mem_data_file) loop
                        booval := true;
                        readline(mem_data_file, buf);
                        lineno := lineno + 1;
                        LOOP2 : while (buf'length > 0) loop
                            if (buf(buf'low) = '-') then
                                if (buf(buf'low) = '-') then
                                    -- ignore comment started with --.
                                    exit LOOP2;
                                end if;
                            elsif (buf(buf'low) = '%') then
                                i := 1;
                                
                                -- ignore comment which begin with % and end with another %.
                                while ((i < buf'high) and (buf(buf'low + i) /= '%')) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i+1);
                                end if;
                            elsif ((buf(buf'low) = ' ') or (buf(buf'low) = HT)) then
                                i := 1;
                                -- ignore space or tab character.
                                while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                    i := i+1;
                                end loop;
                                
                                if (i >= buf'high) then
                                    exit LOOP2;
                                else
                                    SHRINK_LINE(buf, i);
                                end if;
                            elsif (get_memory_content = true) then
                            
                                if (((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "end") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "END") or
                                    ((buf(buf'low) & buf(buf'low +1) & buf(buf'low +2)) = "End")) then
                                    get_memory_content := false;
                                    exit LOOP2;
                                else
                                    get_start_address := false;
                                    get_end_address := false;
                                    m_start_address_int := 0;
                                    m_end_address_int := 0;
                                    m_address_int := 0;
                                    m_data_int := (others => '0');
                                    if (buf(buf'low) = '[') then
                                        get_start_Address := true;
                                        SHRINK_LINE(buf, 1);
                                    end if;
        
                                    case m_address_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                    (buf(buf'low) /= ':') and (buf(buf'low) /= '.')) loop
                                                read(l => buf, value => char, good => booval);
                                                m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported address_radix!"
                                            severity error;
                                    end case;
        
                                    if (get_start_Address = true) then
                                    
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;
            
                                        if ((buf(buf'low) = '.') and (buf(buf'low+1) = '.')) then
                                            get_start_Address := false;
                                            get_end_Address := true;
                                            m_start_address_int := m_address_int;
                                            SHRINK_LINE(buf, 2);    
                                        end if;
                                    end if;
        
                                    if (get_end_address = true) then
                                        i := 0;
                                        -- ignore space or tab character.
                                        while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                            (buf(buf'low+i) = HT))) loop
                                            i := i+1;
                                        end loop;
                                    
                                        if (i > 0) then
                                            SHRINK_LINE(buf, i);
                                        end if;                                
                                        
                                        m_address_int := 0;
                                        case m_address_radix is
                                            when "hex" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *16 +  HEX_STR_TO_INT(char);
                                                end loop;
                                            when "bin" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *2 +  BIN_STR_TO_INT(char);
                                                end loop;
                                            when "dec" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "uns" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *10 +  INT_STR_TO_INT(char);
                                                end loop;
                                            when "oct" =>
                                                while ((buf(buf'low) /= ' ') and (buf(buf'low) /= HT) and
                                                        (buf(buf'low) /= ']')) loop
                                                    read(l => buf, value => char, good => booval);
                                                    m_address_int := m_address_int *8 + OCT_STR_TO_INT(char);
                                                end loop;
                                            when others =>
                                                assert false
                                                report "Unsupported address_radix!"
                                                severity error;
                                        end case;
        
                                        if (buf(buf'low) = ']') then
                                            get_end_address := false;
                                            m_end_address_int := m_address_int;
                                            SHRINK_LINE(buf, 1);    
                                        end if;
                                    end if;
                                        
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;                                
                                    
                                    if (buf(buf'low) = ':') then
                                        SHRINK_LINE(buf, 1);    
                                    end if;
                                    
                                    i := 0;
                                    -- ignore space or tab character.
                                    while ((i < buf'high-1) and ((buf(buf'low +i) = ' ') or
                                        (buf(buf'low+i) = HT))) loop
                                        i := i+1;
                                    end loop;
                                    
                                    if (i > 0) then
                                        SHRINK_LINE(buf, i);
                                    end if;
            
                                    case m_data_radix is
                                        when "hex" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+4 downto 0) := m_data_int(lpm_width-1 downto 0) * "10000" + conv_std_logic_vector(HEX_STR_TO_INT(char), 4);
                                            end loop;
                                        when "bin" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+1 downto 0) := m_data_int(lpm_width-1 downto 0) * "10" + conv_std_logic_vector(BIN_STR_TO_INT(char), 4);
                                            end loop;
                                        when "dec" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "uns" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1010" + conv_std_logic_vector(INT_STR_TO_INT(char), 4);
                                            end loop;
                                        when "oct" =>
                                            while ((buf(buf'low) /= ';') and (buf(buf'low) /= ' ') and
                                                    (buf(buf'low) /= HT)) loop
                                                read(l => buf, value => char, good => booval);
                                                m_data_int(lpm_width+3 downto 0) := m_data_int(lpm_width-1 downto 0) * "1000" + conv_std_logic_vector(OCT_STR_TO_INT(char), 4);
                                            end loop;
                                        when others =>
                                            assert false
                                            report "Unsupported data_radix!"
                                            severity error;
                                        end case;                           
        
                                        if (m_start_address_int /= m_end_address_int) then
                                            for i in m_start_address_int to m_end_address_int loop
                                                mem_data(i) := m_data_int(lpm_width-1 downto 0);
                                            end loop;
                                        else
                                            mem_data(m_address_int) := m_data_int(lpm_width-1 downto 0);
                                        end if;
                                    exit LOOP2;
                                end if;                                
                            elsif ((buf(buf'low) = 'W') or (buf(buf'low) = 'w')) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "width") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_width := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif (((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) and
                                    ((buf(buf'low+1) = 'E') or (buf(buf'low+1) = 'e'))) then
                                read(l=>buf, value=>m_string(1 to 5));
        
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "depth") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low +i) = ' ') or (buf(buf'low +i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to i));
                                    
                                    m_depth := INT_STR_TO_INT(m_string(1 to i));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'D') or (buf(buf'low) = 'd')) then
                                read(l=>buf, value=>m_string(1 to 10));
        
                                if (ALPHA_TOLOWER(m_string(1 to 10))  = "data_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_data_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'A') or (buf(buf'low) = 'a')) then
                                read(l=>buf, value=>m_string(1 to 13));
        
                                if (ALPHA_TOLOWER(m_string(1 to 13))  = "address_radix") then
                                    i := 0;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                   
                                    if (buf(buf'low + i) = '=') then
                                        i := i+1;
                                    end if;
        
                                    while ((buf(buf'low+i) = ' ') or (buf(buf'low+i) = HT)) loop
                                        i := i+1;
                                    end loop;
                                                                   
                                    SHRINK_LINE(buf, i);
        
                                    i := 0;
                                    while (buf(buf'low + i) /= ';') loop
                                        i := i+1;
                                    end loop;
                                    
                                    read(l=>buf, value=>m_string(1 to 3));
                                    
                                    m_address_radix := ALPHA_TOLOWER(m_string(1 to 3));
                                end if;
                                exit LOOP2;
                            elsif ((buf(buf'low) = 'C') or (buf(buf'low) = 'c')) then
                                read(l=>buf, value=>m_string(1 to 7));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 7))  = "content") then
                                    found_keyword_content := true;
                                end if;
                            elsif ((buf(buf'low) = 'B') or (buf(buf'low) = 'b')) then
                                read(l=>buf, value=>m_string(1 to 5));
                                
                                if (ALPHA_TOLOWER(m_string(1 to 5))  = "begin") then
                                    if (found_keyword_content = true) then
                                        get_memory_content := true;
                                    end if;
                                end if;
                            end if;
                        end loop;
                    end loop;
                
                else
                    assert false
                    report "Unsupported memory initialization file type (" & (lpm_file(lpm_file'length -3) & lpm_file(lpm_file'length -2) & lpm_file(lpm_file'length -1) & lpm_file(lpm_file'length)) & ")!"
                    severity error;
                end if;
            end if;
            mem_init := TRUE;
        end if;

            q_tmp <= mem_data(conv_integer(address_tmp));

    end process MEMORY;

end LPM_SYN;
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_fifo
--
-- Description     :  
--
-- Limitation      :  
--
-- Results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

library IEEE;
-- BEGINNING OF ENTITY
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_DEVICE_FAMILIES.all;
use work.LPM_HINT_EVALUATION.all;

-- ENTITY DECLARATION
entity LPM_FIFO is
-- GENERIC DECLARATION
    generic (
    lpm_width               : natural;
    lpm_widthu              : natural;
    lpm_numwords            : natural;
    lpm_showahead           : string := "OFF";
    lpm_type                : string := "LPM_FIFO";
    lpm_hint                : string := "");
    
-- PORT DECLARATION
    port (
-- INPUT PORT DECLARATION
    data         : in std_logic_vector(lpm_width-1 downto 0);
    clock        : in std_logic;
    wrreq        : in std_logic;
    rdreq        : in std_logic;
    aclr         : in std_logic := '0';
    sclr         : in std_logic := '0';
-- OUTPUT PORT DECLARATION
    q            : out std_logic_vector(lpm_width-1 downto 0);
    usedw        : out std_logic_vector(lpm_widthu-1 downto 0);
    full         : out std_logic;
    empty        : out std_logic);
end LPM_FIFO;
-- END OF ENTITY
    
-- BEGINNING OF ARCHITECTURE
-- ARCHITECTURE DECLARATION
architecture behavior of LPM_FIFO is
-- TYPE DECLARATION
    type lpm_memory is array (2**lpm_widthu-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

-- FUNCTION DECLARATION
    function get_underflow_checking return string is
        constant param_value : string := get_parameter_value(LPM_HINT, "UNDERFLOW_CHECKING");
    begin    
    if ( param_value /= "") then
        return param_value;
    else
        return "ON"; 
    end if;

    end get_underflow_checking; 

    function get_overflow_checking return string is
        constant param_value : string := get_parameter_value(LPM_HINT, "OVERFLOW_CHECKING");
    begin 
    if ( param_value /= "") then
        return param_value;
    else
        return "ON"; 
    end if;

    end get_overflow_checking; 

    function get_allow_rwcycle_when_full return string is
        constant param_value : string := get_parameter_value(LPM_HINT, "ALLOW_RWCYCLE_WHEN_FULL");
    begin 
    if ( param_value /= "") then
        return param_value;
    else
        return "OFF"; 
    end if;

    end get_allow_rwcycle_when_full; 

    function get_intended_device_family return string is
        constant param_value : string := get_parameter_value(LPM_HINT, "INTENDED_DEVICE_FAMILY");
    begin 
    if ( param_value /= "") then
        return param_value;
    else
        return "Stratix II"; 
    end if;

    end get_intended_device_family; 

-- CONSTANT DECLARATION
constant ZEROS : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
constant UNKNOWNS : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => 'X');
constant  underflow_checking : string := get_underflow_checking;
constant  overflow_checking : string := get_overflow_checking;
constant  allow_rwcycle_when_full : string := get_allow_rwcycle_when_full;
constant  intended_device_family : string := get_intended_device_family;

-- SIGNAL DECLARATION
signal i_count_id : integer := 0;
signal i_read_id : integer := 0;
signal i_write_id : integer := 0;
signal i_full_flag : std_logic := '0';
signal i_empty_flag : std_logic := '1';
signal i_tmp_q : std_logic_vector(lpm_width-1 downto 0) := ZEROS;


begin
-- PROCESS DECLARATION
    process (clock, aclr)
    -- VARIABLE DECLARATION
    variable mem_data : lpm_memory := (OTHERS => ZEROS);
    variable tmp_data : std_logic_vector(lpm_width-1 downto 0) := ZEROS;
    variable write_id : integer := 0;
    variable write_flag : boolean := false;
    variable full_flag : boolean := false;
    variable valid_rreq : boolean := false;
    variable valid_wreq : boolean := false;
    variable max_widthu : integer := 0;
    variable numwords_minus_one : integer := 0;
    variable need_init : boolean := true;
    begin
        if (need_init) then
            if ((lpm_showahead /= "ON") and (lpm_showahead /= "OFF")) then
                ASSERT FALSE
                REPORT "Illegal LPM_SHOWAHEAD property value for LPM_FIFO!"
                SEVERITY ERROR;
            end if;
            
            if ((underflow_checking /= "ON") and (underflow_checking /= "OFF")) then
                ASSERT FALSE
                REPORT "Illegal UNDERFLOW_CHECKING property value for LPM_FIFO!"
                SEVERITY ERROR;
            end if;
            
            if ((overflow_checking /= "ON") and (overflow_checking /= "OFF")) then
                ASSERT FALSE
                REPORT "Illegal OVERFLOW_CHECKING property value for LPM_FIFO!"
                SEVERITY ERROR;
            end if;
            
            if ((allow_rwcycle_when_full /= "ON") and (allow_rwcycle_when_full /= "OFF")) then
                ASSERT FALSE
                REPORT "Illegal ALLOW_RWCYCLE_WHEN_FULL property value for LPM_FIFO!"
                SEVERITY ERROR;
            end if;

            if (IS_VALID_FAMILY(intended_device_family) = false) then
                ASSERT FALSE
                REPORT "Illegal INTENDED_DEVICE_FAMILY for LPM_FIFO!"
                SEVERITY ERROR;
            end if;

            for i in 0 to (lpm_widthu - 1) loop
                if (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
                FEATURE_FAMILY_BASE_CYCLONE(intended_device_family)) then
                    mem_data(i) := UNKNOWNS;
                else
                    mem_data(i) := ZEROS;
                end if;
            end loop;

            if (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
            FEATURE_FAMILY_BASE_CYCLONE(intended_device_family)) then
                i_tmp_q <= UNKNOWNS;
            else
                i_tmp_q <= ZEROS;
            end if;

            max_widthu := (2 ** lpm_widthu) - 1;
            numwords_minus_one := lpm_numwords - 1;

            need_init := false;
        end if; -- need_init

        if (aclr = '1') then
            full_flag := false;
            if (not (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
            FEATURE_FAMILY_BASE_CYCLONE(intended_device_family))) then
                i_tmp_q <= ZEROS;
            end if;
            write_id := 0;
            if (lpm_showahead = "ON") then
                i_tmp_q <= mem_data(0);
            end if;
        end if; -- aclr event

        if (clock'event and (clock = '1') and
        ((aclr = '0') or (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
        FEATURE_FAMILY_BASE_CYCLONE(intended_device_family))))
        then
            valid_rreq := rdreq = '1' and ((i_empty_flag = '0') or
                (underflow_checking = "OFF"));
            valid_wreq := wrreq = '1' and ((i_full_flag = '0') or
                (overflow_checking = "OFF") or ((rdreq = '1') and
                (allow_rwcycle_when_full = "ON")));

            if (sclr = '1')
            then
                i_tmp_q <= mem_data(i_read_id);
                i_read_id <= 0;
                i_count_id <= 0;
                i_write_id <= 0;
                i_full_flag <= '0';
                i_empty_flag <= '1';
                write_id := 0;
                full_flag := false;

                if (valid_wreq)
                then
                    tmp_data := data;
                    write_id := i_write_id;
                    write_flag := true;
                end if;
                if ((lpm_showahead = "ON") or (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
                FEATURE_FAMILY_BASE_CYCLONE(intended_device_family)))
                then
                    i_tmp_q <= mem_data(0);
                end if;
            else
                -- Both WRITE and READ operations
                if (valid_wreq and valid_rreq)
                then
                    tmp_data := data;
                    write_id := i_write_id;
                    write_flag := true;

                    i_empty_flag <= '0';
                    if (allow_rwcycle_when_full = "OFF")
                    then
                        i_full_flag <= '0';
                        full_flag := false;
                    end if;

                    if (i_write_id >= max_widthu)
                    then
                        i_write_id <= 0;
                    else
                        i_write_id <= i_write_id + 1;
                    end if;

                    i_tmp_q <= mem_data(i_read_id);
                    if (i_read_id >= max_widthu)
                    then
                        i_read_id <= 0;
                        if (lpm_showahead = "ON")
                        then
                            i_tmp_q <= mem_data(0);
                        end if;
                    else
                        i_read_id <= i_read_id + 1;
                        if (lpm_showahead = "ON")
                        then
                            i_tmp_q <= mem_data(i_read_id + 1);
                        end if;
                    end if;

                -- WRITE operation only
                elsif (valid_wreq)
                then
                    tmp_data := data;
                    write_id := i_write_id;
                    write_flag := true;

                    if (lpm_showahead = "ON")
                    then
                        i_tmp_q <= mem_data(i_read_id);
                    end if;

                    i_count_id <= i_count_id + 1;
                    i_empty_flag <= '0';

                    if (i_count_id >= max_widthu)
                    then
                        i_count_id <= 0;
                    end if;
                    if ((i_count_id = numwords_minus_one) and (i_empty_flag = '0'))
                    then
                        i_full_flag <= '1';
                        full_flag := true;
                    end if;
                    if (i_write_id >= max_widthu)
                    then
                        i_write_id <= 0;
                    else
                        i_write_id <= i_write_id + 1;
                    end if;

                -- READ operation only
                elsif (valid_rreq)
                then
                    i_tmp_q <= mem_data(i_read_id);
                    i_count_id <= i_count_id - 1;
                    i_full_flag <= '0';
                    full_flag := false;

                    if (i_count_id <= 0)
                    then
                        i_count_id <= max_widthu;
                    end if;
                    if (i_count_id = 1 and i_full_flag = '0')
                    then
                        i_empty_flag <= '1';
                    end if;
                    if (i_read_id >= max_widthu)
                    then
                        i_read_id <= 0;
                        if (lpm_showahead = "ON")
                        then
                            i_tmp_q <= mem_data(0);
                        end if;
                    else
                        i_read_id <= i_read_id + 1;
                        if (lpm_showahead = "ON")
                        then
                            i_tmp_q <= mem_data(i_read_id + 1);
                        end if;
                    end if;
                end if;  -- if Both WRITE and READ operations
        end if;  -- if sclr = '1'
        elsif (clock'event and (clock = '0'))
        then
            if (write_flag)
            then
                write_flag := false;
                mem_data(write_id) := tmp_data;
            end if;
            if (lpm_showahead = "ON")
            then
                i_tmp_q <= mem_data(i_read_id);
            end if;
        end if;  -- clock event

        if (aclr = '1')
        then
            i_full_flag <= '0';
            i_empty_flag <= '1';
            i_read_id <= 0;
            i_write_id <= 0;
            i_count_id <= 0;
            write_id := 0;
        end if;
    end process; -- clock, aclr events

    q <= i_tmp_q;
    full <= i_full_flag;
    empty <= i_empty_flag;
    usedw <= conv_std_logic_vector(i_count_id, lpm_widthu);

end behavior; -- LPM_FIFO
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_fifo_dc_dffpipe
--
-- Description     :  Dual Clocks FIFO
--
-- Limitation      :  
--
-- Results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- BEGINNING OF ENTITY
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_FIFO_DC_DFFPIPE is
-- GENERIC DECLARATION
    generic (
        lpm_delay : natural;
        lpm_width : natural
    );
-- PORT DECLARATION     
    port (
-- INPUT PORT DECLARATION
        d     : in std_logic_vector (lpm_width-1 downto 0);
        clock : in std_logic;
        aclr  : in std_logic := '0';
-- OUTPUT PORT DECLARATION    
        q     : out std_logic_vector (lpm_width-1 downto 0)
    );
end LPM_FIFO_DC_DFFPIPE;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
-- ARCHITECTURE DECLARATION
architecture behavior of LPM_FIFO_DC_DFFPIPE is
-- TYPE DECLARATION
type DELAYPIPE is array (lpm_delay downto 0) of std_logic_vector (lpm_width-1 downto 0);

-- CONSTANT DECLARATION
constant ZEROS : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
begin

-- PROCESS DECLARATION
    process (clock, aclr, d)
------ VARIABLE DECLARATION
    variable intpipe : DELAYPIPE := (OTHERS => ZEROS);
    variable delay : integer := lpm_delay - 1;
    variable need_init : boolean := true;
    begin
        if (lpm_delay = 0) 
        then
            if ((aclr = '1') or need_init) 
            then
                q <= ZEROS;
                need_init := false;
            else
                q <= d;
            end if;
        else
            if ((aclr = '1') or need_init) 
            then
                for i in lpm_delay downto 0 loop
                    intpipe(i) := ZEROS;
                end loop;
                need_init := false;
                q <= ZEROS;
            end if;
            
            if (rising_edge(clock) and (NOW > 0 ns))
            then
                if (delay > 0) then
                    for i in delay downto 1 loop
                        intpipe(i) := intpipe(i-1);
                    end loop;
                end if;
                intpipe(0) := d;
                q <= intpipe(delay);
            end if;
        end if; -- (lpm_delay = 0)
    end process; -- clock, aclr, d events
end behavior; -- lpm_fifo_dc_dffpipe
-- END OF ARCHITECTURE


---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_fifo_dc_fefifo
--
-- Description     :  Dual Clocks FIFO
--
-- Limitation      :  
--
-- Results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- BEGINNING OF ENTITY
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;

-- ENTITY DECLARATION
entity LPM_FIFO_DC_FEFIFO is
-- GENERIC DECLARATION
    generic (
    lpm_widthad  : natural;
    lpm_numwords : natural;
    underflow_checking : string := "ON";
    overflow_checking : string := "ON";
    lpm_mode     : string);
-- PORT DECLARATION             
    port (
-- INPUT PORT DECLARATION    
    usedw_in : in std_logic_vector(lpm_widthad-1 downto 0);
    wreq     : in std_logic := 'Z';
    rreq     : in std_logic := 'Z';
    clock    : in std_logic;
    aclr     : in std_logic := '0';
-- OUTPUT PORT DECLARATION          
    empty    : out std_logic;
    full     : out std_logic);
end LPM_FIFO_DC_FEFIFO;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
-- ARCHITECTURE DECLARATION
architecture behavior of LPM_FIFO_DC_FEFIFO is

-- SIGNAL DECLARATION
signal i_empty : std_logic := '1';
signal i_full : std_logic := '0';

begin

-- PROCESS DECLARATION
    process (clock, aclr)
------ VARIABLE DECLARATION
    variable sm_empty : std_logic_vector(1 downto 0) := "00";
    variable lrreq : std_logic := '0';
    variable almost_full : integer := 0;
    variable usedw_is_1 : boolean := false;
    variable need_init : boolean := true;
    begin
        if (need_init) 
        then
            if ((lpm_mode /= "READ") and (lpm_mode /= "WRITE"))
            then
                ASSERT FALSE
                REPORT "Error! LPM_MODE must be READ or WRITE."
                SEVERITY ERROR;
            end if;
            if ((underflow_checking /= "ON") and (underflow_checking /= "OFF"))
            then
                ASSERT FALSE
                REPORT "Error! UNDERFLOW_CHECKING must be ON or OFF."
                SEVERITY ERROR;
            end if;
            if ((overflow_checking /= "ON") and (overflow_checking /= "OFF"))
            then
                ASSERT FALSE
                REPORT "Error! OVERFLOW_CHECKING must be ON or OFF."
                SEVERITY ERROR;
            end if;

            if (lpm_numwords >= 3) 
            then
                almost_full := lpm_numwords - 3;
            else
                almost_full := 0;
            end if;
            
            need_init := false;
        end if; -- need_init
    
        if (aclr'event and (aclr = '1'))
        then
            sm_empty := "00";
            lrreq := '0';
            
            i_empty <= '1';
            i_full <= '0';
        end if; -- aclr event
            
        if (rising_edge(clock) and (aclr = '0') and (NOW > 0 ns))
        then
            if (lpm_mode = "READ") 
            then
                case sm_empty is
                    -- state_empty
                    when "00" =>                    
                        if (usedw_in /= 0) 
                        then
                            sm_empty := "01";
                        end if;
                    -- state_non_empty
                    when "01" =>                    
                        if (lpm_widthad > 1) 
                        then
                            usedw_is_1 := ((usedw_in = 1) and (lrreq = '0')) or ((usedw_in = 2) and (lrreq = '1'));
                        else
                            usedw_is_1 := (usedw_in = 1) and (lrreq = '0');
                        end if;
                        
                        if ((rreq = '1') and usedw_is_1) 
                        then
                            sm_empty := "10";
                        end if;
                    -- state_emptywait                  
                    when "10" =>
                        if (usedw_in > 1) 
                        then
                            sm_empty := "01";
                        else
                            sm_empty := "00";
                        end if;
                    when others =>
                        ASSERT FALSE
                        REPORT "Error! Invalid sm_empty state in read mode."
                        SEVERITY ERROR;
                end case;
            elsif (lpm_mode = "WRITE") 
            then
                case sm_empty is
                    -- state_empty
                    when "00" =>                    
                        if (wreq = '1') 
                        then
                            sm_empty := "01";
                        end if;
                    -- state_one
                    when "01" =>        
                        if (wreq = '0') 
                        then
                            sm_empty := "11";
                        end if;
                    -- state_non_empty
                    when "11" =>
                        if (wreq = '1') 
                        then
                            sm_empty := "01";
                        elsif (usedw_in = 0) 
                        then
                            sm_empty := "00";
                        end if;
                    when others =>
                        ASSERT FALSE
                        REPORT "Error! Invalid sm_empty state in write mode."
                        SEVERITY ERROR;
                end case;
            end if;
        
            i_empty <= not sm_empty(0);
            if ((aclr = '0') and (usedw_in >= almost_full) and (NOW > 0 ns))
            then
                i_full <= '1';
            else
                i_full <= '0';
            end if;

            if (underflow_checking = "OFF")
            then
                lrreq := rreq;
            else
                lrreq := rreq and not i_empty;
            end if;
        end if; -- clock event
    end process; -- clock, aclr events

    empty <= i_empty;
    full <= i_full;

end behavior; -- lpm_fifo_dc_fefifo
-- END OF ARCHITECTURE

--
-- Entity Name     :  lpm_fifo_dc_async
--
-- Description     :  Asynchoronous Dual Clocks FIFO
--
-- Limitation      :  
--
-- Results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- BEGINNING OF ENTITY
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_DEVICE_FAMILIES.all;
use work.LPM_FIFO_DC_FEFIFO;
use work.LPM_FIFO_DC_DFFPIPE;

-- ENTITY DECLARATION
entity LPM_FIFO_DC_ASYNC is
-- GENERIC DECLARATION
    generic (
    lpm_width               : natural;
    lpm_widthu              : natural;
    lpm_numwords            : natural;
    delay_rdusedw           : natural := 1;
    delay_wrusedw           : natural := 1;
    rdsync_delaypipe        : natural := 3;
    wrsync_delaypipe        : natural := 3; 
    lpm_showahead           : string := "OFF";
    underflow_checking      : string := "ON";
    overflow_checking       : string := "ON";
    use_eab                 : string := "ON";
    intended_device_family  : string := "Stratix");
-- PORT DECLARATION          
    port (
-- INPUT PORT DECLARATION      
    data    : in std_logic_vector(lpm_width-1 downto 0);
    rdclk   : in std_logic;
    wrclk   : in std_logic;
    rdreq   : in std_logic;
    wrreq   : in std_logic;
    aclr    : in std_logic := '0';
-- OUTPUT PORT DECLARATION        
    rdempty : out std_logic;
    wrempty : out std_logic;
    rdfull  : out std_logic;
    wrfull  : out std_logic;
    rdusedw : out std_logic_vector(lpm_widthu-1 downto 0);
    wrusedw : out std_logic_vector(lpm_widthu-1 downto 0);
    q       : out std_logic_vector(lpm_width-1 downto 0));
end LPM_FIFO_DC_ASYNC; 
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
-- ARCHITECTURE DECLARATION
architecture behavior of LPM_FIFO_DC_ASYNC is
-- TYPE DECLARATION
type LPM_MEMORY is array (2**lpm_widthu-1 downto 0) of std_logic_vector(lpm_width-1 downto 0);

-- CONSTANT DECLARATION
constant ZEROS : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
constant ZEROU : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
constant GRAY_DELAYPIPE : integer := 1;
constant WRUSEDW_DELAYPIPE : integer := 1;  -- delayed usedw to compute empty/full
constant RDUSEDW_DELAYPIPE : integer := 1;  -- delayed usedw to compute empty/full

-- SIGNAL DECLARATION
signal i_data_tmp : std_logic_vector(lpm_width-1 downto 0);
signal i_rdptr : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wrptr : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wrptr_tmp : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rdptrrg : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wrdelaycycle : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rden : std_logic := '0';
signal i_wren : std_logic := '0';
signal i_rdenclock : std_logic := '0';
signal i_wren_tmp : std_logic := '0';
signal i_rdempty : std_logic := '1'; 
signal i_wrempty : std_logic := '1';
signal i_rdfull : std_logic := '0';
signal i_wrfull : std_logic := '0';
signal i_rdusedw : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wrusedw : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_ws_nbrp : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rs_nbwp : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_ws_dbrp : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rs_dbwp : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wr_udwn : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rd_udwn : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wr_dbuw : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rd_dbuw : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_q_tmp : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
signal i_zero : std_logic := '0';


-- COMPONENT DECLARATION
component LPM_FIFO_DC_FEFIFO
    generic (
        lpm_widthad : natural;
        lpm_numwords : natural;
        underflow_checking : string := "ON";
        overflow_checking : string := "ON";
        lpm_mode : string);
    port (
        usedw_in : in std_logic_vector(lpm_widthad-1 downto 0);
        wreq : in std_logic := 'Z';
        rreq : in std_logic := 'Z';
        clock : in std_logic;
        aclr : in std_logic := '0';    
        empty : out std_logic;
        full : out std_logic);
end component;

component LPM_FIFO_DC_DFFPIPE
    generic (
        lpm_delay : natural;
        lpm_width : natural);
    port (
        d : in std_logic_vector(lpm_width-1 downto 0);
        clock : in std_logic;
        aclr : in std_logic := '0';
        q : out std_logic_vector(lpm_width-1 downto 0));
end component;

begin
-- COMPONENT ASSIGNMENTS
    -- Delays & DFF Pipes
    DP_RDPTR_D: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => 0, 
        lpm_width => lpm_widthu)
    port map (
        d => i_rdptr, 
        clock => i_rdenclock, 
        aclr => aclr,
        q => i_rdptrrg);

    DP_WRPTR_D: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => 1,
        lpm_width => lpm_widthu)
    port map (
        d => i_wrptr, 
        clock => wrclk, 
        aclr => aclr,
        q => i_wrdelaycycle);

    DP_WS_NBRP: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => WRSYNC_DELAYPIPE,
        lpm_width => lpm_widthu)
    port map (
        d => i_rdptrrg, 
        clock => wrclk, 
        aclr => aclr,
        q => i_ws_nbrp);

    DP_RS_NBWP: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => RDSYNC_DELAYPIPE,
        lpm_width => lpm_widthu)
    port map (
        d => i_wrdelaycycle, 
        clock => rdclk, 
        aclr => aclr,
        q => i_rs_nbwp);

    DP_WS_DBRP: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => GRAY_DELAYPIPE,
        lpm_width => lpm_widthu)
    port map (
        d => i_ws_nbrp, 
        clock => wrclk, 
        aclr => aclr,
        q => i_ws_dbrp);

    DP_RS_DBWP: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => GRAY_DELAYPIPE,
        lpm_width => lpm_widthu)
    port map (
        d => i_rs_nbwp, 
        clock => rdclk, 
        aclr => aclr,
        q => i_rs_dbwp);
    
    DP_WR_USEDW: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => DELAY_WRUSEDW,
        lpm_width => lpm_widthu)
    port map (
        d => i_wr_udwn, 
        clock => wrclk, 
        aclr => aclr,
        q => i_wrusedw);

    DP_RD_USEDW: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => DELAY_RDUSEDW,
        lpm_width => lpm_widthu)
    port map (
        d => i_rd_udwn, 
        clock => rdclk, 
        aclr => aclr,
        q => i_rdusedw);

    DP_WR_DBUW: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => WRUSEDW_DELAYPIPE,
        lpm_width => lpm_widthu)
    port map (
        d => i_wr_udwn, 
        clock => wrclk, 
        aclr => aclr,
        q => i_wr_dbuw);

    DP_RD_DBUW: LPM_FIFO_DC_DFFPIPE
    generic map (
        lpm_delay => RDUSEDW_DELAYPIPE,
        lpm_width => lpm_widthu)
    port map (
        d => i_rd_udwn, 
        clock => rdclk, 
        aclr => aclr,
        q => i_rd_dbuw);  
    
    -- Empty/Full
    WR_FE: LPM_FIFO_DC_FEFIFO
    generic map (
        lpm_widthad => lpm_widthu,
        lpm_numwords => lpm_numwords,
        underflow_checking => underflow_checking,
        overflow_checking => overflow_checking,
        lpm_mode => "WRITE")
    port map (
        usedw_in => i_wr_dbuw, 
        wreq => wrreq,
        rreq => i_zero,
        clock => wrclk, 
        aclr => aclr,
        empty => i_wrempty, 
        full => i_wrfull);

    RD_FE: LPM_FIFO_DC_FEFIFO
    generic map (
        lpm_widthad => lpm_widthu,
        lpm_numwords => lpm_numwords,
        underflow_checking => underflow_checking,
        overflow_checking => overflow_checking,
        lpm_mode => "READ")
    port map (
        usedw_in => i_rd_dbuw, 
        wreq => i_zero,
        rreq => rdreq, 
        clock => rdclk, 
        aclr => aclr,
        empty => i_rdempty, 
        full => i_rdfull);
    
-- PROCESS DECLARATION
    -- FIFOram    
    process (wrclk, rdclk, aclr)
------ VARIABLE DECLARATION
    variable max_widthu : integer := 0;
    variable max_widthu_minus_one : integer := 0;
    variable mem_data : LPM_MEMORY := (OTHERS => ZEROS);
    variable need_init : boolean := true;
    begin
        if (need_init) then
            if ((lpm_showahead /= "ON") and (lpm_showahead /= "OFF")) 
            then
                ASSERT FALSE
                REPORT "Error! LPM_SHOWAHEAD must be ON or OFF."
                SEVERITY ERROR;
            end if;
            if ((underflow_checking /= "ON") and (underflow_checking /= "OFF"))
            then
                ASSERT FALSE
                REPORT "Error! UNDERFLOW_CHECKING must be ON or OFF."
                SEVERITY ERROR;
            end if;
            if ((overflow_checking /= "ON") and (overflow_checking /= "OFF")) 
            then
                ASSERT FALSE
                REPORT "Error! OVERFLOW_CHECKING must be ON or OFF."
                SEVERITY ERROR;
            end if;
            if ((use_eab /= "ON") and (use_eab /= "OFF"))
            then
                ASSERT FALSE
                REPORT "Error! USE_EAB must be ON or OFF."
                SEVERITY ERROR;
            end if;  
            if (IS_VALID_FAMILY(intended_device_family) = false) then
                ASSERT FALSE
                REPORT "Error! Illegal INTENDED_DEVICE_FAMILY."
                SEVERITY ERROR;
            end if;

            max_widthu := 2 ** lpm_widthu;
            max_widthu_minus_one :=  (2 ** lpm_widthu) - 1;
            
            for i in lpm_numwords - 1 downto 0 loop
                mem_data(i) := ZEROS;
            end loop;

            need_init := false;
        end if; -- need_init
        
        if (aclr'event and (aclr = '1'))
        then
            i_rdptr <= ZEROU;
            i_wrptr <= ZEROU;
            if (not (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
                FEATURE_FAMILY_BASE_CYCLONE(intended_device_family)) or
                (use_eab = "OFF"))
                then
                    if (lpm_showahead = "ON")
                    then
                        i_q_tmp <= mem_data(0);
                    else
                        i_q_tmp <= ZEROS;
                end if;
            end if;
        end if; -- aclr event
        
        if (rising_edge(wrclk))
        then
            if ((aclr = '1') and (not (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
                FEATURE_FAMILY_BASE_CYCLONE(intended_device_family)) or
                (use_eab = "OFF")))
            then
                i_data_tmp <= ZEROS;
                i_wrptr_tmp <= ZEROU;
                i_wren_tmp <= '0';
            elsif (NOW > 0 ns)
            then
                i_data_tmp <= data;
                i_wrptr_tmp <= i_wrptr;
                i_wren_tmp <= i_wren;
            
                if (i_wren = '1')
                then
                    if ((aclr = '0') and (i_wrptr < max_widthu_minus_one)) 
                    then
                        i_wrptr <= i_wrptr + 1;
                    else
                        i_wrptr <= ZEROU;
                    end if;
                    
                    if (use_eab = "OFF")
                    then
                        mem_data(CONV_INTEGER(i_wrptr) mod max_widthu) := data;
                        
                        if (lpm_showahead = "ON")
                        then
                            i_q_tmp <= mem_data(CONV_INTEGER(i_rdptr) mod max_widthu);
                        end if;
                    end if;
                end if;
            end if;
        end if; -- wrclk = '1'  and wrclk'event
        
        if ((falling_edge(wrclk) and (use_eab = "ON")) and (NOW > 0 ns))
        then
            if (i_wren_tmp = '1')
            then
                mem_data(CONV_INTEGER(i_wrptr_tmp) mod max_widthu) := i_data_tmp;
            end if;
            
            if (lpm_showahead = "ON")
            then
                i_q_tmp <= mem_data(CONV_INTEGER(i_rdptr) mod max_widthu);
            end if;
        end if; -- wrclk = '0' and wrclk event and (use_eab = "ON")) and (NOW > 0 ns)
        
        
        if (rising_edge(rdclk))
        then
            if ((aclr = '1') and (not (FEATURE_FAMILY_BASE_STRATIX(intended_device_family) or
                FEATURE_FAMILY_BASE_CYCLONE(intended_device_family)) or
                (use_eab = "OFF")))
            then
                if (lpm_showahead = "ON")
                then
                    i_q_tmp <= mem_data(0);
                else
                    i_q_tmp <= ZEROS;
                end if;
            elsif ((i_rden = '1') and (NOW > 0 ns))
            then
                if ((aclr = '0') and (i_rdptr < max_widthu_minus_one))
                then
                    i_rdptr <= i_rdptr + 1;                 
                else
                    i_rdptr <= ZEROU;
                end if;
                    
                if (lpm_showahead = "ON")
                then
                    i_q_tmp <= mem_data(CONV_INTEGER(i_rdptr + 1) mod max_widthu);
                else
                    i_q_tmp <= mem_data(CONV_INTEGER(i_rdptr) mod max_widthu);
                end if;
            end if;
        end if; -- rdclk = '1' and rdclk event
    end process; -- aclr, wrclk, rdclk events

    i_rden <= rdreq when underflow_checking = "OFF" else
        rdreq and not i_rdempty;
    i_wren <= wrreq when overflow_checking = "OFF" else
        wrreq and not i_wrfull;

    -- Delays & DFF Pipes
    process (rdclk)
    begin
        if (falling_edge(rdclk)) 
        then
            i_rdenclock <= '0';
        elsif (rising_edge(rdclk)) 
        then
            if (i_rden = '1')
            then
                i_rdenclock <= '1';
            end if;
        end if;
    end process; -- rdclk event

    process (i_wrptr, i_ws_dbrp)
    begin
        if (NOW > 0 ns)
        then
            i_wr_udwn <= i_wrptr - i_ws_dbrp;
        end if;
    end process; -- i_wrptr, i_ws_dbrp events
            
    process (i_rdptr, i_rs_dbwp)
    begin
        if (NOW > 0 ns)
        then
            i_rd_udwn <= i_rs_dbwp - i_rdptr;
        end if;
    end process; -- i_rdptr, i_rs_dbwp events
            
    -- Outputs
    rdempty <= i_rdempty;
    rdfull <= i_rdfull;    
    wrempty <= i_wrempty;
    wrfull <= i_wrfull;
    rdusedw <= i_rdusedw;
    wrusedw <= i_wrusedw;
    q <= i_q_tmp;

end behavior; -- lpm_fifo_dc_async
-- END OF ARCHITECTURE


---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_fifo_dc
--
-- Description     :  Dual clocks FIFO
--
-- Limitation      :  
--
-- Results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.LPM_COMPONENTS.all;
use work.LPM_HINT_EVALUATION.all;
use work.LPM_FIFO_DC_ASYNC;

-- ENTITY DECLARATION
entity LPM_FIFO_DC is
-- GENERIC DECLARATION
    generic ( 
    lpm_width               : natural;
    lpm_widthu              : natural;
    lpm_numwords            : natural;
    lpm_showahead           : string := "OFF";
    underflow_checking      : string := "ON";
    overflow_checking       : string := "ON";
    lpm_hint                : string := "";   
    lpm_type                : string := "LPM_FIFO_DC");
-- PORT DECLARATION     
    port ( 
-- INPUT PORT DECLARATION      
    data    : in std_logic_vector(lpm_width-1 downto 0);
    rdclock   : in std_logic;
    wrclock   : in std_logic;
    aclr    : in std_logic := '0';
    rdreq   : in std_logic;
    wrreq   : in std_logic;

-- OUTPUT PORT DECLARATION        
    rdfull  : out std_logic;
    wrfull  : out std_logic;
    rdempty : out std_logic;    
    wrempty : out std_logic;
    rdusedw : out std_logic_vector(lpm_widthu-1 downto 0);
    wrusedw : out std_logic_vector(lpm_widthu-1 downto 0);
    q       : out std_logic_vector(lpm_width-1 downto 0));  
end LPM_FIFO_DC; 
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
-- ARCHITECTURE DECLARATION
architecture behavior of LPM_FIFO_DC is

-- FUNCTION DECLARATION
function get_underflow_checking return string is
    constant param_value : string := get_parameter_value(LPM_HINT, "UNDERFLOW_CHECKING");
    begin
    if ( param_value /= "") then
        return param_value;
    else
        return underflow_checking; 
    end if;

end get_underflow_checking; 

function get_overflow_checking return string is
    constant param_value : string := get_parameter_value(LPM_HINT, "OVERFLOW_CHECKING");
    begin
    if ( param_value /= "") then
        return param_value;
    else
        return overflow_checking; 
    end if;

end get_overflow_checking; 

function get_use_eab return string is
    constant param_value : string := get_parameter_value(LPM_HINT, "USE_EAB");
    begin
    if ( param_value /= "") then
        return param_value;
    else
        return "ON"; 
    end if;

end get_use_eab; 

function get_intended_device_family return string is
    constant param_value : string := get_parameter_value(LPM_HINT, "INTENDED_DEVICE_FAMILY");
    begin 
    if ( param_value /= "") then
        return param_value;
    else
        return "Stratix II"; 
    end if;

end get_intended_device_family; 

-- CONSTANT DECLARATION
constant  C_UNDERFLOW_CHECKING : string := get_underflow_checking;
constant  C_OVERFLOW_CHECKING : string := get_overflow_checking;
constant  C_USE_EAB : string := get_use_eab;
constant  C_INTENDED_DEVICE_FAMILY : string := get_intended_device_family;

-- SIGNAL DECLARATION
signal i_rdfull_a : std_logic := '0';
signal i_wrfull_a : std_logic := '0';
signal i_rdempty_a : std_logic := '1';
signal i_wrempty_a : std_logic := '1';
signal i_rdfull_s : std_logic := '0';
signal i_wrfull_s : std_logic := '0';
signal i_rdempty_s : std_logic := '1';
signal i_wrempty_s : std_logic := '1';
signal i_rdusedw_a : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wrusedw_a : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_rdusedw_s : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_wrusedw_s : std_logic_vector(lpm_widthu-1 downto 0) := (OTHERS => '0');
signal i_q_a : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');
signal i_q_s : std_logic_vector(lpm_width-1 downto 0) := (OTHERS => '0');

-- COMPONENT DECLARATION
component LPM_FIFO_DC_ASYNC
    generic (
        lpm_width               : natural;
        lpm_widthu              : natural;
        lpm_numwords            : natural;
        lpm_showahead           : string := "OFF";
        underflow_checking      : string := "ON";
        overflow_checking       : string := "ON";
        use_eab                 : string := "ON";
        intended_device_family  : string := "Stratix");
    port (
        data    : in std_logic_vector(lpm_width-1 downto 0);
        rdclk   : in std_logic;
        wrclk   : in std_logic;
        aclr    : in std_logic := '0';
        rdreq   : in std_logic;
        wrreq   : in std_logic;
        rdfull  : out std_logic;
        wrfull  : out std_logic;
        rdempty : out std_logic;    
        wrempty : out std_logic;
        rdusedw : out std_logic_vector(lpm_widthu-1 downto 0);
        wrusedw : out std_logic_vector(lpm_widthu-1 downto 0);
        q       : out std_logic_vector(lpm_width-1 downto 0));
end component;

begin
-- COMPONENT ASSIGNMENTS
    ASYNC: LPM_FIFO_DC_ASYNC
    generic map (
        lpm_width => lpm_width,
        lpm_widthu => lpm_widthu,
        lpm_numwords => lpm_numwords,
        lpm_showahead => lpm_showahead,
        underflow_checking => C_UNDERFLOW_CHECKING,
        overflow_checking => C_OVERFLOW_CHECKING,
        use_eab => C_USE_EAB,
        intended_device_family => C_INTENDED_DEVICE_FAMILY)
    port map (
        data => data, 
        rdclk => rdclock, 
        wrclk => wrclock, 
        aclr => aclr, 
        rdreq => rdreq, 
        wrreq => wrreq, 
        rdfull => i_rdfull_a, 
        wrfull => i_wrfull_a, 
        rdempty => i_rdempty_a, 
        wrempty => i_wrempty_a,
        rdusedw => i_rdusedw_a, 
        wrusedw => i_wrusedw_a, 
        q => i_q_a);

    rdfull <= i_rdfull_a;
    wrfull <= i_wrfull_a;
    rdempty <= i_rdempty_a;
    wrempty <= i_wrempty_a;
    rdusedw <= i_rdusedw_a;
    wrusedw <= i_wrusedw_a;
    q <= i_q_a;

end behavior; -- lpm_fifo_dc
-- END OF ARCHITECTURE

---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_inpad
--
-- Description     :  
--
-- Limitation      :  n/a
--
-- results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;

entity LPM_INpad is
    generic (
        lpm_width : natural;    -- MUST be greater than 0
        lpm_type  : string := "LPM_INpad";
        lpm_hint  : string := "UNUSED"
    );
    port (
        pad : in std_logic_vector(lpm_width-1 downto 0);
        result : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_INpad;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_INpad is
begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    result <=  pad;

end LPM_SYN;
-- END OF ARCHITECTURE


---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_outpad
--
-- Description     :  
--
-- Limitation      :  n/a
--
-- results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;

entity LPM_OUTpad is
    generic (
        lpm_width : natural;    -- MUST be greater than 0
        lpm_type : string := "L_OUTpad";
        lpm_hint : string := "UNUSED"
    );
    port (
        data : in std_logic_vector(lpm_width-1 downto 0);
        pad : out std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_OUTpad;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_OUTpad is
begin

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    pad <= data;

end LPM_SYN;
-- END OF ARCHITECTURE


---START_ENTITY_HEADER---------------------------------------------------------
--
-- Entity Name     :  lpm_bipad
--
-- Description     :  
--
-- Limitation      :  n/a
--
-- results Expected:  
--
---END_ENTITY_HEADER-----------------------------------------------------------

-- LIBRARY USED----------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.LPM_COMPONENTS.all;

entity LPM_BIpad is
    generic (
        lpm_width : natural;    -- MUST be greater than 0
        lpm_type : string := "LPM_BIpad";
        lpm_hint : string := "UNUSED"
    );
    port (
        data : in std_logic_vector(lpm_width-1 downto 0);
        enable : in std_logic;
        result : out std_logic_vector(lpm_width-1 downto 0);
        pad : inout std_logic_vector(lpm_width-1 downto 0)
    );
end LPM_BIpad;
-- END OF ENTITY

-- BEGINNING OF ARCHITECTURE
architecture LPM_SYN of LPM_BIpad is

signal tmp_pad : std_logic_vector(lpm_width-1 downto 0);

begin

    tmp_pad <= pad;

-- PROCESS DECLARATION

    -- basic error checking for invalid parameters
    MSG: process
    begin
        if (lpm_width <= 0) then
            ASSERT FALSE
            REPORT "Value of lpm_width parameter must be greater than 0!"
            SEVERITY ERROR;
        end if;
        wait;
    end process MSG;

    process(data, tmp_pad, enable)
    begin
        if enable = '1' then
            pad <= data;
            result <= (OTHERS => 'Z');
        else
            result <= tmp_pad;
            pad <= (OTHERS => 'Z');
        end if;
    end process;

end LPM_SYN;
-- END OF ARCHITECTURE

