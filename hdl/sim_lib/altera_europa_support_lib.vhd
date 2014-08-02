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
-----------------------------------------------------------------------------
--                                                                         --
--  Description:  Declares utility package for Altera IP support           --
--                                                                         --
--                                                                         --
--    *** USER DESIGNS SHOULD NOT INCLUDE THIS PACKAGE DIRECTLY ***        --
--                                                                         --
------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
--
-- These routines are used to help SOPC Builder generate VHDL code.
--
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package altera_europa_support_lib is

  attribute IS_SIGNED : BOOLEAN ;
  attribute SYNTHESIS_RETURN : STRING ;


  FUNCTION  and_reduce(arg : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  -- Result subtype: STD_LOGIC.
  -- Result: Result of and'ing all of the bits of the vector.

  FUNCTION nand_reduce(arg : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  -- Result subtype: STD_LOGIC.
  -- Result: Result of nand'ing all of the bits of the vector.

  FUNCTION   or_reduce(arg : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  -- Result subtype: STD_LOGIC.
  -- Result: Result of or'ing all of the bits of the vector.

  FUNCTION  nor_reduce(arg : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  -- Result subtype: STD_LOGIC.
  -- Result: Result of nor'ing all of the bits of the vector.

  FUNCTION  xor_reduce(arg : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  -- Result subtype: STD_LOGIC.
  -- Result: Result of xor'ing all of the bits of the vector.

  FUNCTION xnor_reduce(arg : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  -- Result subtype: STD_LOGIC.
  -- Result: Result of xnor'ing all of the bits of the vector.

  FUNCTION A_SRL(arg: std_logic_vector; shift: integer) RETURN std_logic_vector;
  FUNCTION A_SLL(arg: std_logic_vector; shift: integer) RETURN std_logic_vector;

  FUNCTION A_SRL(arg: std_logic_vector; shift: std_logic_vector) RETURN std_logic_vector;
  FUNCTION A_SLL(arg: std_logic_vector; shift: std_logic_vector) RETURN std_logic_vector;

  FUNCTION A_TOSTDLOGICVECTOR(a: std_logic) RETURN std_logic_vector;
  FUNCTION A_TOSTDLOGICVECTOR(a: std_logic_vector) RETURN std_logic_vector;

  FUNCTION A_WE_StdLogic  (select_arg: boolean; then_arg: STD_LOGIC ; else_arg:STD_LOGIC) RETURN STD_LOGIC;
  FUNCTION A_WE_StdUlogic (select_arg: boolean; then_arg: STD_ULOGIC; else_arg:STD_ULOGIC) RETURN STD_ULOGIC;
  FUNCTION A_WE_StdLogicVector(select_arg: boolean; then_arg: STD_LOGIC_VECTOR; else_arg:STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR;
  FUNCTION A_WE_StdUlogicVector(select_arg: boolean; then_arg: STD_ULOGIC_VECTOR; else_arg:STD_ULOGIC_VECTOR) RETURN STD_ULOGIC_VECTOR;

  FUNCTION Vector_To_Std_Logic(vector: STD_LOGIC_VECTOR) return Std_Logic;

  function TO_STD_LOGIC(arg : BOOLEAN) return STD_LOGIC;
  -- Result subtype: STD_LOGIC
  -- Result: Converts a BOOLEAN to a STD_LOGIC..
  
  FUNCTION a_rep(arg : STD_LOGIC; repeat : INTEGER) RETURN STD_LOGIC_VECTOR ;
  FUNCTION a_rep_vector(arg : STD_LOGIC_VECTOR; repeat : INTEGER) RETURN STD_LOGIC_VECTOR ;
  function a_min(L, R: INTEGER) return INTEGER ;
  function a_max(L, R: INTEGER) return INTEGER ;
  FUNCTION a_ext (arg : STD_LOGIC_VECTOR; size : INTEGER) RETURN STD_LOGIC_VECTOR ;

  -------------------------------------------------------
  -- Conversions for Verilog $display/$write emulation --
  -------------------------------------------------------

  -- All required padding is to the left of the value (right justified) to
  -- a string that can hold the maximum value of the vector in that radix.
  -- When displaying decimal values (e.g. %d), padding is spaces.
  -- When displaying other radices (e.g. %h), padding is zeros.
  -- There is no padding when a zero is placed after the % (e.g. %0d or %0h).

  type pad_type is (pad_none, pad_spaces, pad_zeros);
 
  function to_hex_string(val       : std_logic_vector;
                         pad       : pad_type := pad_zeros) return string;

  function to_decimal_string(val   : integer;
                             pad   : pad_type := pad_spaces) return string;

  function to_decimal_string(val   : std_logic_vector;
                             pad   : pad_type := pad_spaces) return string;

  function to_octal_string(val     : std_logic_vector;
                           pad     : pad_type := pad_zeros) return string;

  function to_binary_string(val    : std_logic_vector;
                            pad    : pad_type := pad_zeros) return string;

  function to_hex_string(val       : std_logic;
                         pad       : pad_type := pad_zeros) return string;

  function to_decimal_string(val   : std_logic;
                             pad   : pad_type := pad_spaces) return string;

  function to_octal_string(val     : std_logic;
                           pad     : pad_type := pad_zeros) return string;

  function to_binary_string(val    : std_logic;
                            pad    : pad_type := pad_zeros) return string;

end altera_europa_support_lib;

package body altera_europa_support_lib is

  --
  -- Reducing logical functions.
  --

  FUNCTION and_reduce(arg: STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    VARIABLE result: STD_LOGIC;
    -- Exemplar synthesis directive attributes for this function
    ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_AND" ;
  BEGIN
    result := '1';
    FOR i IN arg'RANGE LOOP
      result := result AND arg(i);
    END LOOP;
    RETURN result;
  END;

  FUNCTION nand_reduce(arg: STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    VARIABLE result: STD_LOGIC;
    ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_NAND" ;
  BEGIN
      result := NOT and_reduce(arg);
      RETURN result;
  END;

  FUNCTION or_reduce(arg: STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    VARIABLE result: STD_LOGIC;
    -- Exemplar synthesis directive attributes for this function
    ATTRIBUTE synthesis_return OF result:VARIABLE IS "REDUCE_OR" ;
  BEGIN
    result := '0';
    FOR i IN arg'RANGE LOOP
      result := result OR arg(i);
    END LOOP;
    RETURN result;
  END;

  FUNCTION nor_reduce(arg: STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    VARIABLE result: STD_LOGIC;
    ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_NOR" ;
  BEGIN
    result := NOT or_reduce(arg);
    RETURN result;
  END;

  FUNCTION xor_reduce(arg: STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    VARIABLE result: STD_LOGIC;
    -- Exemplar synthesis directive attributes for this function
    ATTRIBUTE synthesis_return OF result:VARIABLE IS "REDUCE_XOR" ;
  BEGIN
    result := '0';
    FOR i IN arg'RANGE LOOP
      result := result XOR arg(i);
    END LOOP;
    RETURN result;
  END;

  FUNCTION xnor_reduce(arg: STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    VARIABLE result: STD_LOGIC;
    ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_XNOR" ;
  BEGIN
    result := NOT xor_reduce(arg);
    RETURN result;
  END;

  function TO_STD_LOGIC(arg : BOOLEAN) return STD_LOGIC is
  begin
    if(arg = true) then
        return('1');
    else
        return('0');
    end if;
  end;

  FUNCTION A_SRL(arg : STD_LOGIC_VECTOR; shift : STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR IS
  BEGIN 
    RETURN(A_SRL(arg,conv_integer(shift)));   
  END;

  FUNCTION A_SLL(arg : STD_LOGIC_VECTOR; shift : STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR IS
  BEGIN 
    RETURN(A_SLL(arg,conv_integer(shift)));   
  END;

  FUNCTION A_SRL(arg : STD_LOGIC_VECTOR; shift : INTEGER) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(arg'LEFT DOWNTO 0) := (arg'RANGE => '0');
  BEGIN 
    IF ((shift <= arg'LEFT) AND (shift >= 0)) THEN
      IF (shift = 0) THEN
        result := arg;
      ELSE
        result(arg'LEFT - shift DOWNTO 0) := arg(arg'LEFT DOWNTO shift);
      END IF;
    END IF;

    RETURN(result);   
  END;

  FUNCTION A_SLL(arg : STD_LOGIC_VECTOR; shift : INTEGER) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(arg'LEFT DOWNTO 0) := (arg'RANGE => '0');
  BEGIN 
    IF ((shift <= arg'LEFT) AND (shift >= 0)) THEN
      IF (shift = 0) THEN
        result := arg;
      ELSE
        result(arg'LEFT DOWNTO shift) := arg(arg'LEFT - shift DOWNTO 0);
      END IF;
    END IF;

    RETURN(result);   
  END;



  FUNCTION A_TOSTDLOGICVECTOR(a: std_logic) RETURN std_logic_vector IS
  BEGIN
    IF a = '1'     THEN
      return "1";
    ELSE 
      return "0";
    END IF;
  END;
  
  FUNCTION A_TOSTDLOGICVECTOR(a: std_logic_vector) RETURN std_logic_vector IS
  BEGIN
      return a;
  END;

  FUNCTION A_WE_StdLogic  (select_arg: boolean; then_arg: STD_LOGIC ; else_arg:STD_LOGIC) RETURN STD_LOGIC IS
  BEGIN
      IF (select_arg) THEN
	return (then_arg);
      ELSE
  	return (else_arg);
      END IF;
  END;

  FUNCTION A_WE_StdUlogic (select_arg: boolean; then_arg: STD_ULOGIC; else_arg:STD_ULOGIC) RETURN STD_ULOGIC IS
  BEGIN
      IF (select_arg) THEN
	return (then_arg);
      ELSE
  	return (else_arg);
      END IF;
  END;

  FUNCTION A_WE_StdLogicVector(select_arg: boolean; then_arg: STD_LOGIC_VECTOR; else_arg:STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR IS
  BEGIN
      IF (select_arg) THEN
	return (then_arg);
      ELSE
  	return (else_arg);
      END IF;
  END;

  FUNCTION A_WE_StdUlogicVector(select_arg: boolean; then_arg: STD_ULOGIC_VECTOR; else_arg:STD_ULOGIC_VECTOR) RETURN STD_ULOGIC_VECTOR IS
  BEGIN
      IF (select_arg) THEN
	return (then_arg);
      ELSE
  	return (else_arg);
      END IF;
  END;

  FUNCTION Vector_To_Std_Logic(vector: STD_LOGIC_VECTOR)
  return Std_Logic IS
  BEGIN
      return (vector(vector'right));
  END;


  FUNCTION a_rep(arg : STD_LOGIC; repeat : INTEGER) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(repeat-1 DOWNTO 0) := (others => '0'); 
    VARIABLE i : integer := 0;
  BEGIN 
    FOR i IN 0 TO (repeat-1) LOOP 
      result(i) := arg;
    end LOOP;
     
     RETURN(result);   
  END;

  FUNCTION a_rep_vector(arg : STD_LOGIC_VECTOR; repeat : INTEGER) RETURN STD_LOGIC_VECTOR IS
    VARIABLE arg_copy : STD_LOGIC_VECTOR ((arg'length - 1)DOWNTO 0) :=  arg ;
    VARIABLE result : STD_LOGIC_VECTOR(((repeat * (arg_copy'LEFT+1))-1) DOWNTO 0) := (others => '0');
    VARIABLE i : integer := 0;  
  BEGIN 
    FOR i IN 0 TO (repeat-1) LOOP 
      result((((arg_copy'left + 1) * i) + arg_copy'left) downto ((arg_copy'left + 1) * i)) := arg_copy(arg_copy'LEFT DOWNTO 0);
    end LOOP;
    
    RETURN(result);   
  END;

  -- a_min : return the minimum of two integers;
  function a_min(L, R: INTEGER) return INTEGER is
  begin
      if L < R then
          return L;
      else
          return R;
      end if;
  end;

  -- a_max : return the minimum of two integers;
  function a_max(L, R: INTEGER) return INTEGER is
  begin
      if L > R then
          return L;
      else
          return R;
      end if;
  end;

  -- a_ext is the Altera version of the EXT function.  It is used to both
  -- zero-extend a signal to a new length, and to extract a signal of 'size'
  -- length from a larger signal.
  FUNCTION a_ext (arg : STD_LOGIC_VECTOR; size : INTEGER) RETURN STD_LOGIC_VECTOR IS
    VARIABLE arg_copy : STD_LOGIC_VECTOR ((arg'length - 1)DOWNTO 0) :=  arg ;
    VARIABLE result : STD_LOGIC_VECTOR((size-1) DOWNTO 0) := (others => '0');
    VARIABLE i : integer := 0;  
    VARIABLE bits_to_copy : integer := 0;
    VARIABLE arg_length : integer := arg'length ;
    VARIABLE LSB_bit : integer := 0;
  BEGIN 
    bits_to_copy := a_min(arg_length, size);
    FOR i IN 0 TO (bits_to_copy - 1) LOOP 
      result(i) := arg_copy(i);
    end LOOP;
    
    RETURN(result);   
  END;

  -------------------------------------------------------
  -- Conversions for Verilog $display/$write emulation --
  -------------------------------------------------------

  subtype slv4        is std_logic_vector(1 to 4);
  subtype slv3        is std_logic_vector(1 to 3);

  -- Remove leading zeros.  Also changes strings of all 'x' or 'z' to one char.
  -- This handles the %0<radix> kind of Verilog syntax in the format string.
  -- Examples:
  --        input           output
  --        -----           -----------
  --        001f            1f
  --        0000            0
  --        xxxx            x
  --        zzzz            z
  --        xxzz            xxzz

  function do_pad_none(
      str_in             : string) return string is
      variable start     : integer;
      variable all_x     : boolean := true;
      variable all_z     : boolean := true;
  begin
      -- Nothing to remove if string isn't at least two characters long.
      if (str_in'length < 2) then
         return str_in;
      end if;

      for i in str_in'range loop
          case str_in(i) is
            when 'X' | 'x' => all_z := false;
            when 'Z' | 'z' => all_x := false;
            when others    => all_x := false; all_z := false;
          end case;
      end loop;

      if (all_x or all_z) then
         return str_in(str_in'left to str_in'left);
      end if;

      -- Find index of first non-zero character.
      for i in str_in'range loop
          start := i;
          exit when (str_in(i) /= '0');
      end loop;

      return str_in(start to str_in'right);
  end do_pad_none;  

  -- Replace leading zeros with spaces.
  -- This handles the %d kind of Verilog syntax in the format string.
  function replace_leading_zeros(
      str_in           : string;
      c                : character) return string is
      variable str_out : string(str_in'range) := str_in;
  begin
      -- Nothing to replace if string isn't at least two characters long.
      if (str_in'length < 2) then
         return str_in;
      end if;

      for i in str_in'range loop
          if (str_in(i) = '0') then
              str_out(i) := c;
          else
              exit;
          end if;
      end loop;

      return str_out;
  end replace_leading_zeros;  

  function do_pad(
      str            : string;
      pad            : pad_type) return string is
  begin
      case pad is
        when pad_none =>   return do_pad_none(str);
        when pad_spaces => return replace_leading_zeros(str, ' ');
        when pad_zeros =>  return str;
      end case;
  end do_pad;

  function round_up_to_multiple(
      val        : integer; 
      size       : integer) return integer is
  begin
      return ((val + size - 1) / size) * size;
  end round_up_to_multiple;

  function to_hex_string(
      val              : std_logic_vector;
      pad              : pad_type     := pad_zeros) return string is
      variable ext_len : integer := round_up_to_multiple(val'length,4);
      variable val_ext : std_logic_vector(1 to ext_len) := (others => '0');
      variable ptr     : integer range 1 to (ext_len/4)+1 := 1;
      variable str     : string(1 to ext_len/4) := (others=>'0');
      variable found_x : boolean := false;
      variable found_z : boolean := false;
  begin
      val_ext(ext_len-val'length+1 to ext_len) := val;

      -- Extend MSB to extended sulv unless it starts with one (unsigned).
      -- Done to extend 'x' and 'z'.
      if ext_len-val'length > 0 and val(val'left) /= '1' then 
        val_ext(1 to ext_len-val'length) := (others => val(val'left));
      end if;

      for i in val_ext'range loop
        next when i rem 4 /= 1;

        case slv4(to_x01z(val_ext(i to i+3))) is
          when "0000" => str(ptr) := '0';
          when "0001" => str(ptr) := '1';
          when "0010" => str(ptr) := '2';
          when "0011" => str(ptr) := '3';
          when "0100" => str(ptr) := '4';
          when "0101" => str(ptr) := '5';
          when "0110" => str(ptr) := '6';
          when "0111" => str(ptr) := '7';
          when "1000" => str(ptr) := '8';
          when "1001" => str(ptr) := '9';
          when "1010" => str(ptr) := 'a';
          when "1011" => str(ptr) := 'b';
          when "1100" => str(ptr) := 'c';
          when "1101" => str(ptr) := 'd';
          when "1110" => str(ptr) := 'e';
          when "1111" => str(ptr) := 'f';
          when "XXXX" => str(ptr) := 'x';
          when "ZZZZ" => str(ptr) := 'z';
          when others =>
            for j in 0 to 3 loop
                case val_ext(i + j) is
                  when 'X' => found_x := true;
                  when 'Z' => found_z := true;
                  when others => null;
                end case;
            end loop;
            
            if found_x then
                str(ptr) := 'X';
            elsif found_z then
                str(ptr) := 'Z';
            else
                str(ptr) := 'X';
            end if;
        end case;
        ptr := ptr + 1;
      end loop;
      return do_pad(str, pad);
    end to_hex_string;

  function to_decimal_string(
      val              : integer;
      pad              : pad_type := pad_spaces) return string is
      variable     tmp : integer := val;
      variable     ptr : integer range 1 to 32 := 32;
      variable     str : string(1 to 32) := (others=>'0');
  begin
      if val=0 then 
          return do_pad("0", pad); 
      else
          while tmp > 0 loop
              case tmp rem 10 is
                when 0 => str(ptr) := '0';
                when 1 => str(ptr) := '1';
                when 2 => str(ptr) := '2';
                when 3 => str(ptr) := '3';
                when 4 => str(ptr) := '4';
                when 5 => str(ptr) := '5';
                when 6 => str(ptr) := '6';
                when 7 => str(ptr) := '7';
                when 8 => str(ptr) := '8';
                when 9 => str(ptr) := '9';
                when others => null;
              end case;

              tmp := tmp / 10;
              ptr := ptr - 1;
          end loop;

          return do_pad(str(ptr+1 to 32), pad);
      end if;
  end to_decimal_string;

  function to_decimal_string(
      val                : std_logic_vector;
      pad                : pad_type := pad_spaces) return string is
      variable all_x     : boolean := true;
      variable all_z     : boolean := true;
      variable some_x    : boolean := false;
      variable some_z    : boolean := false;
      variable fixed_str : string(1 to 1);
  begin
      for i in val'range loop
          case to_x01z(val(i)) is
            when 'X'    => some_x := true; all_z := false;
            when 'Z'    => some_z := true; all_x := false;
            when others => all_x := false; all_z := false;
          end case;
      end loop;

      if (all_x) then
          fixed_str(1) := 'x';
          return fixed_str;
      elsif (all_z) then
          fixed_str(1) := 'z';
          return fixed_str;
      elsif (some_x) then
          fixed_str(1) := 'X';
          return fixed_str;
      elsif (some_z) then
          fixed_str(1) := 'Z';
          return fixed_str;
      else
          return to_decimal_string(conv_integer(val), pad);
      end if;
  end to_decimal_string;

  function to_octal_string(
      val              : std_logic_vector;
      pad              : pad_type     := pad_zeros) return string is
      variable ext_len : integer := round_up_to_multiple(val'length,3);
      variable val_ext : std_logic_vector(1 to ext_len) := (others => '0');
      variable ptr     : integer range 1 to (ext_len/3)+1 := 1;
      variable str     : string(1 to ext_len/3) := (others=>'0');
      variable found_x : boolean := false;
      variable found_z : boolean := false;
  begin
      val_ext(ext_len-val'length+1 to ext_len) := val;

      -- Extend MSB to extended sulv unless it starts with one (unsigned).
      -- Done to extend 'x' and 'z'.
      if ext_len-val'length > 0 and val(val'left) /= '1' then 
        val_ext(1 to ext_len-val'length) := (others => val(val'left));
      end if;

      for i in val_ext'range loop
        next when i rem 3 /= 1;

        case slv3(to_x01z(val_ext(i to i+2))) is
          when "000" => str(ptr) := '0';
          when "001" => str(ptr) := '1';
          when "010" => str(ptr) := '2';
          when "011" => str(ptr) := '3';
          when "100" => str(ptr) := '4';
          when "101" => str(ptr) := '5';
          when "110" => str(ptr) := '6';
          when "111" => str(ptr) := '7';
          when "XXX" => str(ptr) := 'x';
          when "ZZZ" => str(ptr) := 'z';
          when others =>
            for j in 0 to 2 loop
                case val_ext(i + j) is
                  when 'X' => found_x := true;
                  when 'Z' => found_z := true;
                  when others => null;
                end case;
            end loop;
            
            if found_x then
                str(ptr) := 'X';
            elsif found_z then
                str(ptr) := 'Z';
            else
                str(ptr) := 'X';
            end if;
        end case;
        ptr := ptr + 1;
      end loop;
      return do_pad(str, pad);
  end to_octal_string;

  function to_hex_string(
      val              : std_logic;
      pad              : pad_type     := pad_zeros) return string is
  begin
      return to_binary_string(val, pad);
  end to_hex_string;

  function to_decimal_string(
      val              : std_logic;
      pad              : pad_type     := pad_spaces) return string is
  begin
      return to_binary_string(val, pad);
  end to_decimal_string;

  function to_octal_string(
      val              : std_logic;
      pad              : pad_type     := pad_zeros) return string is
  begin
      return to_binary_string(val, pad);
  end to_octal_string;

  function to_binary_string(
      val              : std_logic;
      pad              : pad_type := pad_zeros) return string is
      variable str     : string(1 to 1);
  begin
      case to_x01z(val) is
          when '0'    => str(1) := '0';
          when '1'    => str(1) := '1';
          when 'X'    => str(1) := 'x';
          when 'Z'    => str(1) := 'z';
          when others => str(1) := 'x';
        end case;
      return do_pad(str, pad);
  end to_binary_string;

  function to_binary_string(
      val              : std_logic_vector;
      pad              : pad_type := pad_zeros) return string is
      variable str     : string(1 to val'length) := (others=>'0');
      variable ptr     : integer := str'left;
  begin
      for i in val'range loop
        str(ptr to ptr) := to_binary_string(val(i));
        ptr := ptr + 1;
      end loop;
      return do_pad(str, pad);
  end to_binary_string;

end altera_europa_support_lib;
