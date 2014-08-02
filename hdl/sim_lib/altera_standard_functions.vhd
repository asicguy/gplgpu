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
library std;
use std.standard.all;

package altera_standard_functions is

    function maximum (L, R: integer) return integer;
    function minimum (L, R: integer) return integer;
    
end altera_standard_functions;

package body altera_standard_functions is

    function maximum (L, R: integer) return integer is
    begin
        if L > R then
            return L;
        else
            return R;
        end if;
    end maximum;

    function minimum (L, R: integer) return integer is
    begin
        if L > R then
            return R;
        else
            return L;
        end if;
    end minimum;
    
end altera_standard_functions;
