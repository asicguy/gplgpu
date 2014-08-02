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

Library ieee;
use ieee.std_logic_1164.all;
entity GLOBAL is
    port(
        a_in                           :  in    std_logic;
        a_out                          :  out   std_logic);
end GLOBAL;
architecture BEHAVIOR of GLOBAL is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity CARRY is
    port(
        a_in                           :  in    std_logic;
        a_out                          :  out   std_logic);
end CARRY;
architecture BEHAVIOR of CARRY is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity CASCADE is
    port(
        a_in                           :  in    std_logic;
        a_out                          :  out   std_logic);
end CASCADE;
architecture BEHAVIOR of CASCADE is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity CARRY_SUM is
    port(
        sin                           :  in    std_logic;
        cin                           :  in    std_logic;
        sout                          :  out   std_logic;
        cout                          :  out   std_logic);
end CARRY_SUM;
architecture BEHAVIOR of CARRY_SUM is
begin
    sout <= sin;
    cout <= cin;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity EXP is
    port(
        a_in                           :  in    std_logic;
        a_out                          :  out   std_logic);
end EXP;
architecture BEHAVIOR of EXP is
begin
    a_out <= not a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity SOFT is
    port(
        a_in                        :  in    std_logic;
        a_out                       :  out   std_logic);
end SOFT;
architecture BEHAVIOR of SOFT is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity OPNDRN is
    port(
        a_in                        :  in    std_logic;
        a_out                       :  out   std_logic);
end OPNDRN;
architecture BEHAVIOR of OPNDRN is
begin
    process (a_in)
    begin
        if (a_in = '0') then
            a_out <= '0';
        elsif (a_in = '1') then
            a_out <= 'Z';
        else
            a_out <= 'X';
        end if;
    end process;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity ROW_GLOBAL is
    port(
        a_in                        :  in    std_logic;
        a_out                       :  out   std_logic);
end ROW_GLOBAL;
architecture BEHAVIOR of ROW_GLOBAL is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity TRI is
    port(
        a_in                        :  in    std_logic;
        oe                          :  in    std_logic;
        a_out                       :  out   std_logic);
end TRI;
architecture BEHAVIOR of TRI is
begin
    a_out <= a_in when oe = '1'
        else 'Z';
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity LUT_INPUT is
    port(
        a_in                        :  in    std_logic;
        a_out                       :  out   std_logic);
end LUT_INPUT;
architecture BEHAVIOR of LUT_INPUT is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity LUT_OUTPUT is
    port(
        a_in                        :  in    std_logic;
        a_out                       :  out   std_logic);
end LUT_OUTPUT;
architecture BEHAVIOR of LUT_OUTPUT is
begin
    a_out <= a_in;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity latch is
    port(
        d                        :  in    std_logic;
        ena                      :  in    std_logic;
        q                        :  out   std_logic);
end latch;
architecture BEHAVIOR of latch is
signal iq : std_logic := '0';
begin
    process (d, ena)
    begin
        if (ena = '1') then
            iq <= d;
        end if;
    end process;
    q <= iq;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity dlatch is
    port(
        d                        :  in    std_logic;
        ena                      :  in    std_logic;
        clrn                     :  in    std_logic;
        prn                      :  in    std_logic;
        q                        :  out   std_logic);
end dlatch;
architecture BEHAVIOR of dlatch is
signal iq : std_logic := '0';
begin
    process (d, ena, clrn, prn)
    begin
        if (clrn = '0') then
            iq <= '0';
        elsif (prn = '0') then
            iq <= '1';
        elsif (ena = '1') then
            iq <= d;
        end if;
    end process;
    q <= iq;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity PRIM_GDFF is
    port(
        d, clk, ena, clr, pre, ald, adt, sclr, sload :  in  std_logic;
        q                                            :  out std_logic);
end PRIM_GDFF;

architecture BEHAVIOR of PRIM_GDFF is

signal iq : std_logic := '0';
signal init : std_logic := '0';
signal stalled_adata : std_logic := '0';

begin
    process (clk, clr, pre, ald, stalled_adata)
    begin
        if (clr =  '1') then
            iq <= '0';
        elsif (pre = '1') then
            iq <= '1';
        elsif (ald = '1') then
            iq <= stalled_adata;
        elsif (clk'event and (clk = '1') and (clk'last_value = '0')) then
            if (ena = '1') then
                if (sclr = '1') then
                    iq <= '0';
                elsif (sload = '1') then
                    iq <= stalled_adata;
                else
                    iq <= d;
                end if;
            end if;
        end if;
    end process;

    process (adt, init)
    begin
        if (init = '0') then
            stalled_adata <= adt;
            init <= '1';
        else
            stalled_adata <= adt after 1 ps;
        end if;
    end process;

    q <= iq;

end BEHAVIOR; -- PRIM_GDFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GDFF;

entity DFF is
    port(
        d, clk, clrn, prn :  in  std_logic;
        q                 :  out std_logic);
end DFF;

architecture BEHAVIOR of DFF is

    component PRIM_GDFF
        port(
            d, clk, ena, clr, pre, ald, adt, sclr, sload :  in  std_logic;
            q                                            :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';
signal zero_bit      : std_logic := '0';
signal one_bit       : std_logic := '1';

begin
   
    PRIM_GDFF_INST :  PRIM_GDFF       
        port map (
            d     => d, 
            clk   => clk,
            ena   => one_bit,
            clr   => clear,
            pre   => preset,
            ald   => zero_bit,
            adt   => zero_bit,
            sclr  => zero_bit,
            sload => zero_bit,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- DFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GDFF;

entity DFFE is
    port(
        d, clk, ena, clrn, prn :  in  std_logic;
        q                      :  out std_logic);
end DFFE;

architecture BEHAVIOR of DFFE is

    component PRIM_GDFF
        port(
            d, clk, ena, clr, pre, ald, adt, sclr, sload :  in  std_logic;
            q                                            :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';
signal zero_bit      : std_logic := '0';

begin
   
    PRIM_GDFF_INST :  PRIM_GDFF       
        port map (
            d     => d, 
            clk   => clk,
            ena   => ena,
            clr   => clear,
            pre   => preset,
            ald   => zero_bit,
            adt   => zero_bit,
            sclr  => zero_bit,
            sload => zero_bit,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- DFFE

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GDFF;

entity DFFEA is
    port(
        d, clk, ena, clrn, prn, aload, adata :  in  std_logic;
        q                                    :  out std_logic);
end DFFEA;

architecture BEHAVIOR of DFFEA is

    component PRIM_GDFF
        port(
            d, clk, ena, clr, pre, ald, adt, sclr, sload :  in  std_logic;
            q                                            :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';
signal zero_bit      : std_logic := '0';

begin
   
    PRIM_GDFF_INST :  PRIM_GDFF       
        port map (
            d     => d, 
            clk   => clk,
            ena   => ena,
            clr   => clear,
            pre   => preset,
            ald   => aload,
            adt   => adata,
            sclr  => zero_bit,
            sload => zero_bit,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- DFFEA

Library ieee;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.dffeas_pack.all;

entity DFFEAS is
    generic(
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
    attribute VITAL_LEVEL0 of dffeas : entity is TRUE;
end DFFEAS;


architecture vital_dffeas of dffeas is
    attribute VITAL_LEVEL0 of vital_dffeas : architecture is TRUE;
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
                TestSignal      => d_ipd,
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
                HeaderMsg       => InstancePath & "/DFFEAS",
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
                HeaderMsg       => InstancePath & "/DFFEAS",
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
                HeaderMsg       => InstancePath & "/DFFEAS",
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
                HeaderMsg       => InstancePath & "/DFFEAS",
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
                HeaderMsg       => InstancePath & "/DFFEAS",
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
                    iq := asdata_dly;
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

end vital_dffeas;

Library ieee;
use ieee.std_logic_1164.all;
entity PRIM_GTFF is
    port(
        t, clk, ena, clr, pre :  in  std_logic;
        q                     :  out std_logic);
end PRIM_GTFF;

architecture BEHAVIOR of PRIM_GTFF is

signal iq : std_logic := '0';
signal init : std_logic := '0';

begin
    process (clk, clr, pre)
    begin
        if (clr =  '1') then
            iq <= '0';
        elsif (pre = '1') then
            iq <= '1';
        elsif (clk'event and (clk = '1') and (clk'last_value = '0')) then
            if (ena = '1') then
                if (t = '1') then
                    iq <= not iq;
                end if;
            end if;
        end if;
    end process;

    q <= iq;

end BEHAVIOR; -- PRIM_GTFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GTFF;

entity TFF is
    port(
        t, clk, clrn, prn :  in  std_logic;
        q                 :  out std_logic);
end TFF;

architecture BEHAVIOR of TFF is

    component PRIM_GTFF
        port(
            t, clk, ena, clr, pre :  in  std_logic;
            q                     :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';
signal one_bit       : std_logic := '1';

begin
   
    PRIM_GTFF_INST :  PRIM_GTFF       
        port map (
            t     => t, 
            clk   => clk,
            ena   => one_bit,
            clr   => clear,
            pre   => preset,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- TFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GTFF;

entity TFFE is
    port(
        t, clk, ena, clrn, prn :  in  std_logic;
        q                      :  out std_logic);
end TFFE;

architecture BEHAVIOR of TFFE is

    component PRIM_GTFF
        port(
            t, clk, ena, clr, pre :  in  std_logic;
            q                     :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';

begin
   
    PRIM_GTFF_INST :  PRIM_GTFF       
        port map (
            t     => t, 
            clk   => clk,
            ena   => ena,
            clr   => clear,
            pre   => preset,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- TFFE


Library ieee;
use ieee.std_logic_1164.all;
entity PRIM_GJKFF is
    port(
        j, k, clk, ena, clr, pre :  in  std_logic;
        q                        :  out std_logic);
end PRIM_GJKFF;

architecture BEHAVIOR of PRIM_GJKFF is

signal iq : std_logic := '0';

begin
    process (clk, clr, pre)
    begin
        if (clr =  '1') then
            iq <= '0';
        elsif (pre = '1') then
            iq <= '1';
        elsif (clk'event and (clk = '1') and (clk'last_value = '0')) then
            if (ena = '1') then
                if ((j = '1') and (k = '0')) then
                    iq <= '1';
                elsif ((j = '0') and (k = '1')) then
                    iq <= '0';
                elsif ((j = '1') and (k = '1')) then
                    iq <= not iq;
                end if;
            end if;
        end if;
    end process;

    q <= iq;

end BEHAVIOR; -- PRIM_GJKFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GJKFF;

entity JKFF is
    port(
        j, k, clk, clrn, prn :  in  std_logic;
        q                    :  out std_logic);
end JKFF;

architecture BEHAVIOR of JKFF is

    component PRIM_GJKFF
        port(
            j, k, clk, ena, clr, pre :  in  std_logic;
            q                        :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';
signal one_bit       : std_logic := '1';

begin
   
    PRIM_GJKFF_INST :  PRIM_GJKFF       
        port map (
            j     => j, 
            k     => k, 
            clk   => clk,
            ena   => one_bit,
            clr   => clear,
            pre   => preset,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- JKFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GJKFF;

entity JKFFE is
    port(
        j, k, clk, ena, clrn, prn :  in  std_logic;
        q                         :  out std_logic);
end JKFFE;

architecture BEHAVIOR of JKFFE is

    component PRIM_GJKFF
        port(
            j, k, clk, ena, clr, pre :  in  std_logic;
            q                        :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';

begin
   
    PRIM_GJKFF_INST :  PRIM_GJKFF
        port map (
            j     => j, 
            k     => k, 
            clk   => clk,
            ena   => ena,
            clr   => clear,
            pre   => preset,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- JKFFE

Library ieee;
use ieee.std_logic_1164.all;
entity PRIM_GSRFF is
    port(
        s, r, clk, ena, clr, pre :  in  std_logic;
        q                        :  out std_logic);
end PRIM_GSRFF;

architecture BEHAVIOR of PRIM_GSRFF is

signal iq : std_logic := '0';

begin
    process (clk, clr, pre)
    begin
        if (clr =  '1') then
            iq <= '0';
        elsif (pre = '1') then
            iq <= '1';
        elsif (clk'event and (clk = '1') and (clk'last_value = '0')) then
            if (ena = '1') then
                if ((s = '1') and (r = '0')) then
                    iq <= '1';
                elsif ((s = '0') and (r = '1')) then
                    iq <= '0';
                elsif ((s = '1') and (r = '1')) then
                    iq <= not iq;
                end if;
            end if;
        end if;
    end process;

    q <= iq;

end BEHAVIOR; -- PRIM_GSRFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GSRFF;

entity SRFF is
    port(
        s, r, clk, clrn, prn :  in  std_logic;
        q                    :  out std_logic);
end SRFF;

architecture BEHAVIOR of SRFF is

    component PRIM_GSRFF
        port(
            s, r, clk, ena, clr, pre :  in  std_logic;
            q                        :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';
signal one_bit       : std_logic := '1';

begin
   
    PRIM_GSRFF_INST :  PRIM_GSRFF       
        port map (
            s     => s, 
            r     => r, 
            clk   => clk,
            ena   => one_bit,
            clr   => clear,
            pre   => preset,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- SRFF

Library ieee;
use ieee.std_logic_1164.all;
use work.PRIM_GSRFF;

entity SRFFE is
    port(
        s, r, clk, ena, clrn, prn :  in  std_logic;
        q                         :  out std_logic);
end SRFFE;

architecture BEHAVIOR of SRFFE is

    component PRIM_GSRFF
        port(
            s, r, clk, ena, clr, pre :  in  std_logic;
            q                        :  out std_logic);
    end component;
    
signal clear         : std_logic := '0';
signal preset        : std_logic := '0';

begin
   
    PRIM_GSRFF_INST :  PRIM_GSRFF
        port map (
            s     => s, 
            r     => r, 
            clk   => clk,
            ena   => ena,
            clr   => clear,
            pre   => preset,
            q     => q );

    clear  <= not clrn;
    preset <= not prn;
    

end BEHAVIOR; -- SRFFE


library ieee;
use ieee.std_logic_1164.all;

-- ENTITY DECLARATION
entity clklock is
generic(
    input_frequency       : natural := 10000;   -- units in ps
    clockboost            : natural := 1

);
port(
    inclk   : in std_logic;  -- required port, input reference clock
    outclk  : out std_logic  -- outclk output
);
end clklock;
-- END ENTITY DECLARATION

-- BEGINNING OF ARCHITECTURE BEHAVIOR
architecture behavior of clklock is

-- CONSTANT DECLARATION
constant valid_lock_cycles       : natural := 1;
constant invalid_lock_cycles     : natural := 2;

-- SIGNAL DECLARATION
SIGNAL pll_lock      : std_logic := '0';
SIGNAL check_lock    : std_logic := '0';
SIGNAL outclk_tmp    : std_logic := 'X';
begin

-- checking for invalid parameters
MSG: process
begin
    if (input_frequency <= 0) then
        ASSERT FALSE
        REPORT "The period of the input clock (input_frequency) must be greater than 0!"
        SEVERITY ERROR;
    end if;

    if ((clockboost /= 1) and (clockboost /= 2)) then
        ASSERT FALSE
        REPORT "The clock multiplication factor (clockboost) must be a value of 1 or 2!"
        SEVERITY ERROR;
    end if;

    wait;

end process MSG;

LOCK: process(inclk, pll_lock, check_lock)
    -- VARIABLE DECLARATION
    variable inclk_ps : time := 0 ps;
    variable violation : boolean := false;
    variable pll_lock_tmp : std_logic := '0';
    variable start_lock_count, stop_lock_count : integer := 0;
    variable pll_last_rising_edge, pll_last_falling_edge : time := 0 ps;
    variable pll_rising_edge_count : integer := 0;
    variable pll_cycle, pll_duty_cycle : time := 0 ps;
    variable expected_next_clk_edge : time := 0 ps;
    variable clk_per_tolerance : time := 0 ps;

    variable last_synchronizing_rising_edge_for_outclk : time := 0 ps;
    variable input_cycles_per_outclk            : integer := 1;
    variable input_cycle_count_to_sync0 : integer := 0;
    variable init : boolean := true;
    variable output_value : std_logic := '0';
    variable vco_per : time := 0 ps;
    variable high_time : time := 0 ps;
    variable low_time : time := 0 ps;
    variable sched_time : time := 0 ps;
    variable tmp_per  : integer := 0;
    variable temp, tmp_rem, my_rem : integer := 0;
    variable inc : integer := 1;
    variable cycle_to_adjust : integer := 0;
    variable outclk_synchronizing_period : time;
    variable outclk_cycles_per_sync_period      : integer := clockboost;
    variable schedule_outclk : boolean := false;
begin
    if (init) then
        outclk_cycles_per_sync_period := clockboost;
        input_cycles_per_outclk := 1;
        
        clk_per_tolerance := (0.1 * real(input_frequency)) * 1 ps;
        init := false;
    end if;

    if (inclk'event and inclk = '1') then
        if (pll_lock_tmp = '1') then
            check_lock <= not check_lock after (inclk_ps+clk_per_tolerance)/2.0;
        end if;
        if pll_rising_edge_count = 0 then      -- at 1st rising edge
            inclk_ps := (input_frequency / 1) * 1 ps;
            pll_duty_cycle := inclk_ps/2;
        elsif pll_rising_edge_count = 1 then      -- at 2nd rising edge
            pll_cycle := now - pll_last_rising_edge;    -- calculate period
            if ((NOW - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance)  or
                (NOW - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                ASSERT FALSE
                REPORT "Inclock_Period Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = invalid_lock_cycles) then
                        pll_lock_tmp := '0';
                        ASSERT FALSE
                        REPORT "clklock out of lock."
                        SEVERITY WARNING;
                    end if;
                else
                    start_lock_count := 1;
                end if;
            else
                violation := false;
            end if;
            if ((now - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) or
                (now - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2)) then
                ASSERT FALSE
                REPORT "Duty Cycle Violation"
                SEVERITY WARNING;
                violation := true;
            else
                violation := false;
            end if;
        else
            pll_cycle := now - pll_last_rising_edge;    -- calculate period
            if ((now - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance) or
                (now - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                ASSERT FALSE
                REPORT "Cycle Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = invalid_lock_cycles) then
                        pll_lock_tmp := '0';
                        ASSERT FALSE
                        REPORT "clklock out of lock."
                        SEVERITY WARNING;
                    end if;
                else
                    start_lock_count := 1;
                end if;
            else
                violation := false;
            end if;
        end if;
        pll_last_rising_edge := now;
        pll_rising_edge_count := pll_rising_edge_count +1;
        if (not violation) then
            if (pll_lock_tmp = '1') then
                input_cycle_count_to_sync0 := input_cycle_count_to_sync0 + 1;
                if (input_cycle_count_to_sync0 = input_cycles_per_outclk) then
                    outclk_synchronizing_period := now - last_synchronizing_rising_edge_for_outclk;
                    last_synchronizing_rising_edge_for_outclk := now;
                    schedule_outclk := true;
                    input_cycle_count_to_sync0 := 0;
                end if;
            else
                start_lock_count := start_lock_count + 1;
                if (start_lock_count >= valid_lock_cycles) then
                    pll_lock_tmp := '1';
                    input_cycle_count_to_sync0 := 0;
                    outclk_synchronizing_period := ((pll_cycle/1 ps) * input_cycles_per_outclk) * 1 ps;
                    last_synchronizing_rising_edge_for_outclk := now;
                    schedule_outclk := true;
                end if;
            end if;
        else
            start_lock_count := 1;
        end if;

    elsif (inclk'event and inclk= '0') then
        if (pll_lock_tmp = '1') then
            check_lock <= not check_lock after (inclk_ps+clk_per_tolerance)/2.0;
            if (now > 0 ns and ((now - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) or
                (now - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2))) then
                ASSERT FALSE
                REPORT "Duty Cycle Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = invalid_lock_cycles) then
                        pll_lock_tmp := '0';
                        ASSERT FALSE
                        REPORT "clklock out of lock."
                        SEVERITY WARNING;
                    end if;
                end if;
            else
                violation := false;
            end if;
        else
            start_lock_count := start_lock_count + 1;
        end if;
        pll_last_falling_edge := now;
    else
        if pll_lock_tmp = '1' then
            if (inclk = '1') then
                expected_next_clk_edge := pll_last_rising_edge + (inclk_ps+clk_per_tolerance)/2.0;
            else
                expected_next_clk_edge := pll_last_falling_edge + (inclk_ps+clk_per_tolerance)/2.0;
            end if;
            violation := false;
            if (now < expected_next_clk_edge) then
                check_lock <= not check_lock after (expected_next_clk_edge - now);
            elsif (now = expected_next_clk_edge) then
                check_lock <= not check_lock after (inclk_ps+clk_per_tolerance)/2.0;
            else
                ASSERT FALSE
                REPORT "Inclock_Period Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                    stop_lock_count := stop_lock_count + 1;
                    if (stop_lock_count = invalid_lock_cycles) then
                        pll_lock_tmp := '0';
                        ASSERT FALSE
                        REPORT "clklock out of lock."
                        SEVERITY WARNING;
                    else
                        check_lock <= not check_lock after (inclk_ps/2.0);
                    end if;
                end if;
            end if;
        end if;
    end if;
    pll_lock <= pll_lock_tmp;
    if (pll_lock'event and pll_lock = '0') then
        start_lock_count := 1;
        stop_lock_count := 0;
        outclk_tmp <= 'X';
    end if;

    -- outclk output
    if (schedule_outclk = true) then
        -- initialize variables
        sched_time := 0 ps;
        cycle_to_adjust := 0;
        inc := 1;
        output_value := '1';
        temp := outclk_synchronizing_period / 1 ps;
        my_rem := temp rem outclk_cycles_per_sync_period;

        -- schedule <outclk_cycles_per_sync_period> number of output clock
        -- cycles in this loop in order to synchronize the output clock to the
        -- input clock - to get rid of drifting for cases where the input clock
        -- period is not always divisible
        for i in 1 to outclk_cycles_per_sync_period loop
            tmp_per := temp/outclk_cycles_per_sync_period;
            if ((my_rem /= 0) and (inc <= my_rem)) then
                tmp_rem := (outclk_cycles_per_sync_period * inc) rem my_rem;
                cycle_to_adjust := (outclk_cycles_per_sync_period * inc) / my_rem;
                if (tmp_rem /= 0) then
                    cycle_to_adjust := cycle_to_adjust + 1;
                end if;
            end if;

            -- if this cycle is the one to adjust the output period in, then
            -- increment the period by 1 unit
            if (cycle_to_adjust = i) then
                tmp_per := tmp_per + 1;
                inc := inc + 1;
            end if;

            -- adjust the high and low cycle period
            vco_per := tmp_per * 1 ps;
            high_time := (tmp_per / 2) * 1 ps;
            if ((tmp_per rem 2) /= 0) then
                high_time := high_time + 1 ps;
            end if;

            low_time := vco_per - high_time;

            -- schedule the high and low cycle of 1 output clock period
            for j in 1 to 2 loop
                outclk_tmp <= transport output_value after sched_time;
                output_value := not output_value;
                if (output_value = '0') then
                    sched_time := sched_time + high_time;
                elsif (output_value = '1') then
                    sched_time := sched_time + low_time;
                end if;
            end loop;
        end loop;

        -- reset schedule_outclk
        schedule_outclk := false;
    end if; -- schedule_outclk
end process LOCK;

    outclk <= outclk_tmp;

end behavior;
-- END ARCHITECTURE BEHAVIOR


Library ieee;
use ieee.std_logic_1164.all;
entity alt_inbuf is
    generic(
        io_standard           : string := "NONE";
        location              : string := "NONE";
        enable_bus_hold       : string := "NONE";
        weak_pull_up_resistor : string := "NONE"; 
        termination           : string := "NONE";
        lpm_type              : string := "alt_inbuf" );
    port(
        i : in  std_logic;
        o : out std_logic);
end alt_inbuf;
architecture BEHAVIOR of alt_inbuf is
begin
    o <= i;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_outbuf is
    generic(
        io_standard           : string  := "NONE";
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        slow_slew_rate        : string  := "NONE";
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf" );
    port(
        i : in  std_logic;
        o : out std_logic);
end alt_outbuf;
architecture BEHAVIOR of alt_outbuf is
begin
    o <= i;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_outbuf_tri is
    generic(
        io_standard           : string  := "NONE";
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        slow_slew_rate        : string  := "NONE";
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE";
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf_tri" );
    port(
        i  : in  std_logic;
        oe : in  std_logic;
        o  : out std_logic);
end alt_outbuf_tri;
architecture BEHAVIOR of alt_outbuf_tri is
begin
    o <= i when oe = '1'
        else 'Z';
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_iobuf is
    generic(
        io_standard           : string  := "NONE";
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        slow_slew_rate        : string  := "NONE";
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE";
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_iobuf" );
    port(
        i  : in    std_logic;
        oe : in    std_logic;
        io : inout std_logic;
        o  : out   std_logic);
end alt_iobuf;
architecture BEHAVIOR of alt_iobuf is
begin
    process(i, io, oe)
    begin
        if oe = '1' then
            io <= i;
        else
            io <= 'Z';
        end if;
        o <= io;
    end process;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_inbuf_diff is
    generic(
        io_standard           : string := "NONE"; 
        location              : string := "NONE";
        enable_bus_hold       : string := "NONE";
        weak_pull_up_resistor : string := "NONE"; 
        termination           : string := "NONE";
        lpm_type              : string := "alt_inbuf_diff" );
    port(
        i    : in  std_logic;
        ibar : in  std_logic;
        o    : out std_logic);
end alt_inbuf_diff;
architecture BEHAVIOR of alt_inbuf_diff is
begin
    process(i, ibar)
    variable out_tmp : std_logic;
    variable in_tmp  : std_logic_vector(1 downto 0);
    begin
        in_tmp(0) := ibar;
        in_tmp(1) := i;
        case in_tmp is
            when "00" => out_tmp := 'X';
            when "01" => out_tmp := '0';
            when "10" => out_tmp := '1';
            when "11" => out_tmp := 'X';
            when others => out_tmp := 'X';
        end case;
        o <= out_tmp;
    end process;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_outbuf_diff is
    generic(
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE"; 
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf_diff" ); 
    port(
        i   : in  std_logic;
        o   : out std_logic;
        obar : out std_logic);
end alt_outbuf_diff;
architecture BEHAVIOR of alt_outbuf_diff is
begin
    o <= i;
    obar <= not i;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_outbuf_tri_diff is
    generic(
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE"; 
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        lpm_type              : string := "alt_outbuf_tri_diff" );  
    port(
        i    : in  std_logic;
        oe   : in  std_logic;
        o    : out   std_logic;
        obar : out std_logic);
end alt_outbuf_tri_diff;
architecture BEHAVIOR of alt_outbuf_tri_diff is
begin
    o <= i when oe = '1'
        else 'Z' when oe = '0'
        else 'X';
    obar <= (not i) when oe = '1'
        else 'Z' when oe = '0'
        else 'X';
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_iobuf_diff is
    generic(
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE";
        current_strength_new  : string  := "NONE"; 
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_iobuf_diff" ); 
    port(
        i     : in    std_logic;
        oe    : in    std_logic;
        io    : inout std_logic;
        iobar : inout std_logic;
        o     : out   std_logic);
end alt_iobuf_diff;
architecture BEHAVIOR of alt_iobuf_diff is
begin

    process(i, io, iobar, oe)
    variable in_tmp  : std_logic_vector(1 downto 0);
    variable out_tmp : std_logic;
    begin
        in_tmp(0) := iobar;
        in_tmp(1) := io;
        case in_tmp is
            when "00" => out_tmp := 'X';
            when "01" => out_tmp := '0';
            when "10" => out_tmp := '1';
            when "11" => out_tmp := 'X';
            when others => out_tmp := 'X';
        end case;

        if oe = '1' then
            io    <= i;
            iobar <= not i;
        elsif oe = '0' then
            io    <= 'Z';
            iobar <= 'Z';
        else
            io    <= 'X';
            iobar <= 'X';        
        end if;

        o <= out_tmp;
    end process;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_bidir_diff is
    generic(
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE"; 
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_bidir_diff" ); 
    port(
        oe      : in    std_logic;
        bidirin : inout std_logic;
        io      : inout std_logic;
        iobar   : inout std_logic);
end alt_bidir_diff;
architecture BEHAVIOR of alt_bidir_diff is
begin

    process(bidirin, io, iobar, oe)
    variable in_tmp  : std_logic_vector(1 downto 0);
    variable out_tmp : std_logic;
    begin
        in_tmp(0) := iobar;
        in_tmp(1) := io;
        case in_tmp is
            when "00" => out_tmp := 'X';
            when "01" => out_tmp := '0';
            when "10" => out_tmp := '1';
            when "11" => out_tmp := 'X';
            when others => out_tmp := 'X';
        end case;

        if oe = '1' then
            io   <= bidirin;
            iobar <= not bidirin;
            bidirin <= 'Z';
        elsif oe = '0' then
            io   <= 'Z';
            iobar <= 'Z';
            bidirin <= out_tmp;
        else
            io   <= 'X';
            iobar <= 'X';
            bidirin <= 'X';
        end if;
    end process;
end BEHAVIOR;

Library ieee;
use ieee.std_logic_1164.all;
entity alt_bidir_buf is
    generic(
        io_standard           : string  := "NONE"; 
        current_strength      : string  := "NONE"; 
        current_strength_new  : string  := "NONE";
        slew_rate             : integer := -1;
        location              : string  := "NONE";
        enable_bus_hold       : string  := "NONE";
        weak_pull_up_resistor : string  := "NONE"; 
        termination           : string  := "NONE";
        input_termination     : string  := "NONE";
        output_termination    : string  := "NONE";
        lpm_type              : string := "alt_bidir_buf" ); 
    port(
        oe      : in    std_logic;
        bidirin : inout std_logic;
        io      : inout std_logic);
end alt_bidir_buf;
architecture BEHAVIOR of alt_bidir_buf is
begin

    process(bidirin, io, oe)
    variable in_tmp  : std_logic;
    variable out_tmp : std_logic;
    begin
        in_tmp := io;
        case in_tmp is
            when '0' => out_tmp := '0';
            when '1' => out_tmp := '1';
            when others => out_tmp := 'X';
        end case;

        if oe = '1' then
            io   <= bidirin;
            bidirin <= 'Z';
        elsif oe = '0' then
            io   <= 'Z';
            bidirin <= out_tmp;
        else
            io   <= 'X';
            bidirin <= 'X';
        end if;
    end process;
end BEHAVIOR;

