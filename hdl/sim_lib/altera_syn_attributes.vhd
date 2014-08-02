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
-- Copyright (c) 2006 by Altera Corp.  All rights reserved.                --
--                                                                         --
--                                                                         --
--  Description:  Package containing Attribute Declarations for all        --
--                attributes that control Quartus II Integrated Synthesis. --
--                Please refer to the Quartus II Help for documentation    --
--                on using these attributes.                               -- 
--                                                                         --
--                                                                         --
-----------------------------------------------------------------------------

library std;
use std.standard.all;


PACKAGE altera_syn_attributes is

  -- Directs Quartus II to implement input, output, and output
  -- enable registers in I/O cells that have fast, direct connections to
  -- an I/O pin, when possible
  ATTRIBUTE useioff : BOOLEAN;

  -- Prevents Quartus II from minimizing or removing a register
  ATTRIBUTE preserve : BOOLEAN;

  -- Prevents Quartus II from removing a dangling register
  ATTRIBUTE noprune : BOOLEAN;
  
  -- Prevents Quartus II from merging a register with a duplicate
  ATTRIBUTE dont_merge : BOOLEAN;

  -- Prevents Quartus II from replicating a register to improve timing
  ATTRIBUTE dont_replicate : BOOLEAN;

  -- Prevents Quartus II from retiming a register
  ATTRIBUTE dont_retime : BOOLEAN;

  -- Identifies the critical clock enable signal for a register.  The
  -- Quartus II software will attempt to connect this signal to the
  -- dedicated clock enable port.
  ATTRIBUTE direct_enable : BOOLEAN;
  
  -- Prevents Quartus II from minimizing or removing a particular
  -- signal net during combinational logic optimization
  ATTRIBUTE keep : BOOLEAN;

  -- Sets a fan-out limit on a register or net.
  ATTRIBUTE maxfan : NATURAL;

  -- Controls the implementation of a multiplication (*) operations in VHDL
  ATTRIBUTE multstyle : STRING;
  
  -- Controls the implementation of inferred memories
  ATTRIBUTE ramstyle : STRING;

  -- Controls the implementation of inferred ROMs 
  ATTRIBUTE romstyle : STRING;
  
  -- Specifies a Memory Initialization File (.mif) for an inferred RAM
  ATTRIBUTE ram_init_file : STRING;

  -- Assigns a logic encoding to an enumerated type.  Prevents state
  -- machine extraction for all objects with the enumerated type.
  ATTRIBUTE enum_encoding : STRING;

  -- Assigns a state encoding to an enumerated type that models the states
  -- of an extracted state machine.
  ATTRIBUTE syn_encoding : STRING;

  -- Specifies device pin assignments for a VHDL entity port
  ATTRIBUTE chip_pin : STRING;
  
  -- Applies an arbitrary number of Quartus Settings File (QSF) assignments
  -- to a signal, entity, architecture, instance, or inferred register
  ATTRIBUTE altera_attribute : STRING;

END altera_syn_attributes;

