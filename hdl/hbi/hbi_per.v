///////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2014 Francis Bruno, All Rights Reserved
// 
//  This program is free software; you can redistribute it and/or modify it 
//  under the terms of the GNU General Public License as published by the Free 
//  Software Foundation; either version 3 of the License, or (at your option) 
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but 
//  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
//  or FITNESS FOR A PARTICULAR PURPOSE. 
//  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with
//  this program; if not, see <http://www.gnu.org/licenses>.
//
//  This code is available under licenses for commercial use. Please contact
//  Francis Bruno for more information.
//
//  http://www.gplgpu.com
//  http://www.asicsolutions.com
//
//  Title       :  Peripheral Controller
//  File        :  hbi_per.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  THis is the top level module of the peripheral devices controler.
//  Entire controler is in host clock domain.
//  Peripheral devices include:
//  EPROM and/ or Flash PROM external RAMDAC and  internal RAMDAC
//  Soft switch (external write only register). Read data from the softswitch
//  comes actually from an internal shadow register ( in HBI)
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 10ps

/****************************************************************************
* input per_soft_0 ; not used any more.  Controls Default to soft switch write
*                    if request is not for DAC nor PROM
* output per_push;    not used any more. Read data (registered in PER_ )
*                    has to be valid  at the time of per_done or before,
*                    and will stay until next read cycle .
*****************************************************************************/
module hbi_per 
  (
   input           reset, 
   input           hclock,
   input           ser_parn,  // Serial Eprom Select
   input           per_req,   // PERIPHERAL request
   input           per_read,  // PER. read(h)/write(l) indicator
   input           per_dac,   // DAC request  indicator (active low!)
   input           per_prom,  // PROM request indicator (active low!)
   input           per_lbe_f, // high if ALL byte enable are high  
   input [15:0]    per_org,   /* PER origin changed from [19:0] to [15:0] 
			       * just for 64k */
   input [7:0]     per_data_wr, // PER write data from the host
   input [2:0]     dac_wait,    /* DAC wait states
				 * dac_wait[2:1] make RD/WR low  as below
				 *  00 => 3 clocks + 0 clocks
				 *        (use it for IBM @ 33)
				 *  01 -> 3 clocks + 2 clocks
				 *        (use it for IBM @ 66)
				 *  10 => 3 clocks + 4 clocks 
				 *  11 => 3 clocks + 8 clocks
				 * dac_wait[0] makes minimum RD/WR high as 
				 * below
				 *   0 => 4clocks (use it for TI like dacs)
				 *   1 => 16 (use it for IBM like dacs)
				 * to guarantee 6 pixel clocks @ 25 MHz with
				 * host running @ 66 MHz */
   
   input [3:0]     prom_wait,   // EPROM wait states
   input           bios_rdat,   // Serial Eprom Read Data.

   output reg      per_ready,   /* PERIPHERAL interface READY
				 * there is no double buffering for requests, 
				 * so per_ready goes low on the edge of clock 
				 * when request is registered and stays low 
				 * until a cycle (regardless the type) is 
				 * completely finished  */
   output reg      per_done,    /* PER.read cycle finished,
				 * and valid data is present on per_data_rd
				 * Only to avoid other changes in HBI
				 * generate per_done after writes also , 
				 * but then issue per_done on next clock after
				 * request */
   output reg [31:0] per_data_rd,/* registered read data from peripheral device
				  * to HBI */
   input           idac_en,     /* from configuration ? register
				 * enables access to internal RAMDAC */
   
   // signals to from internal RAMDAC
   input [7:0]     idac_data_in,// data from innternal RAMDAC
   output          idac_wr,     // write strobe to internal RAMDAC
   output          idac_rd,     // read  strobe to internal RAMDAC
   
   /// signals from/to peripheral devices I/O
   output [15:0]   aux_addr,    // changed from 9:0 to 7:0 (max eprom size 64k)
   // may not be enough for multiple BIOS images
   input  [7:0]    aux_data_in, // input  data from per. devices data bus
   output reg [7:0]aux_data_out,// output data to   per. devices data bus
   output [1:0]    aux_dac_wr,  // DAC write strobe (act.low)
   output [1:0]    aux_dac_rd,  // DAC read strobe (act.low)
   output reg      aux_prom_cs, /* EPROM chip select , (act.low)
				 * also used to latch upper addresses in an
				 * external latch 1(transp.) 0 latches  */
   
   output reg      aux_prom_oe, // EPROM output enable select (act.low)
   output reg      aux_prom_we, // write strobe for flash prom (act.low) 
   output reg      aux_ld_sft,  // Soft switch load pulse (act.high) 
   output reg      aux_buff_en, // output enable to data I/Os (act.low) 
   input [3:0]     sepm_cmd,    // Serial Eprom Command
   input [18:0]    sepm_addr,   // Serial Eprom address for page clearing
   input           sepm_busy,   // Kick off a command
   output reg      clr_sepm_busy,// Done w/ a serial eprom command
   output 	   bios_clk,
   output 	   bios_hld,
   output 	   bios_csn,
   output reg	   bios_wdat
   );

  // For now we use the following connections for the serial eprom:
  // pd_in[1]     = ser_q

  reg [15:0] per_addr;
  reg [3:0]  lcount;
  reg [2:0]  hcount;
  reg [1:0]  pcount;
  reg 	     read_cyc, incraddr, pdecr, ldecr, hdecr, reload_lcount,
             reload_hcount, aux_prom_oe_i,
             aux_prom_we_i,  aux_buff_en_i, aux_ld_sft_i,
             per_done_i, per_ready_i,  dac_wr_i, dac_rd_i, aux_prom_cs_i,
             per_clkd, prom_rd_cyc,
             dac_wr, dac_rd, idac_sel;
  reg [4:0]  cstate,nstate;
  reg [31:0] ser_cmd[8:0];
  reg 	     clear_serial_counter;
  reg [5:0]  serial_counter;          // Counter used for shifting out addr
  reg 	     ser_inc;                 // Increment the serial counter
  reg 	     ser_s_i, ser_s_ii;
  reg 	     ser_addr_en, ser_addr_en_i;
  reg 	     load_command;            // Load the serial command
  reg 	     ser_capt;                // Capture incoming serial data
  reg 	     ser_h_i, ser_h_ii;
  reg 	     rdsr;
  reg 	     delay_dat;
  reg 	     clk_en, clk_en_i;        // enable the clock out of the chip
  reg [7:0]  ser_data;
  reg        ser_c;       // Serial Eprom Clock
  reg        ser_h;       // Serial Eprom Hold signal
  reg        ser_s;       // Serial Eprom Select Signal
  
  wire 	     l_wait, last;
  wire [31:0] command;
  
  parameter IDLE           = 5'b00_000,
	    SOFT_ONE       = 5'b00_001,
	    SOFT_TWO       = 5'b00_010,
	    SOFT_THREE     = 5'b00_011,
	    DAC_ZERO       = 5'b00_100,
	    DAC_ONE        = 5'b00_101,
	    DAC_TWO        = 5'b00_110,
	    DAC_THREE      = 5'b00_111,
	    PROM_ONE       = 5'b01_000,
	    PROM_TWO       = 5'b01_001,
	    PROM_THREE     = 5'b01_010,
	    PROM_FOUR      = 5'b01_011,
	    PROM_FIVE      = 5'b01_100,
	    PROM_SIX       = 5'b01_101,
	    PROM_SEVEN     = 5'b01_110,
	    PERIPH_END     = 5'b01_111,
	    SPROM1         = 5'b10_000,
	    SPROM_ADDR     = 5'b10_001,
	    SPROM_READ     = 5'b10_010,
	    SPROM_WIDLE    = 5'b10_011,
	    SPROM_WIDLE1   = 5'b11_001,
	    SPROM_WRITE    = 5'b10_100,
	    SPROM_RDSR_IDLE= 5'b10_101,
	    SPROM_RDSR_IDLE1= 5'b10_110,
	    SPROM_RDSR     = 5'b10_111,
	    SPROM_WIP      = 5'b11_000,
	    SPROM_S        = 5'b11_010,
	    SEPM_READ      = 4'b0000, // Read command (ignore)
	    SEPM_PP        = 4'b0001, // Page Program Command
	    SEPM_SE        = 4'b0010, // Sector Erase
	    SEPM_BE        = 4'b0011, // Bulk Erase
	    SEPM_WREN      = 4'b0100, // Write Enable
	    SEPM_WRDI      = 4'b0101, // Write Disable
	    SEPM_RDSR      = 4'b1000, // Internal Read status register
	    SEPM_EOP       = 4'b1001; // External end PP sequence

  // The serial eprom needs commands to be executed, so we will build them
  // up here
  always @* begin
    // Read command: Read data from the PROM
    ser_cmd[0] = {8'b00000011, 8'b0, per_addr[15:0]};
    // PP commnds:   Program the ROM Pages
    ser_cmd[1] = {8'b00000010, 5'b0, sepm_addr};
    // SE Command:   Sector Erase
    ser_cmd[2] = {8'b11011000, 5'b0, sepm_addr};
    // BE Command:   Bulk Erase
    ser_cmd[3] = {8'b11000111, 24'b0};
    // WREN command: Enable writing to the PROM
    ser_cmd[4] = {8'b00000110, 24'b0}; // Only the upper 8 bits are used
    // WRDI command: Disable writing to the prom
    ser_cmd[5] = {8'b00000100, 24'b0}; // only the upper 8 bits are used
    // Dummy's
    ser_cmd[6] = 32'b0;
    ser_cmd[7] = 32'b0;
    // RDSR command: Read Status REgister
    ser_cmd[8] = {8'b00000101, 24'b0}; // only the upper 8 bits are used
  end // always @ *
  
  /***************************************************************************
   * register data / address coming with request
   * request is reloading address immediately, incraddr (from PER_SM) may
   * increment the address if needed for eprom's four reads 
   * Store also read_cycle for convienence in state machine 
   * and internal/external dac select at the time of any request
   ***************************************************************************/
  always @* delay_dat = (ser_addr_en) ? command[~serial_counter[5:1]] :
			ser_data[~serial_counter[3:1]];

  always @(posedge hclock) if (ser_parn) bios_wdat <= delay_dat;

  always @(posedge hclock)
  begin
    if (per_req) begin
      aux_data_out <= per_data_wr;
      ser_data     <= per_data_wr;
      per_addr     <= per_org;
      read_cyc     <= per_read;
      idac_sel     <= idac_en;
    end 
	else if (incraddr) per_addr <= per_addr + 1'b1; 
  end


  /***************************************************************************
   * mux per_addr into 8 address pins, for eprom addressing aux_prom_cs
   * will latch first (high) byte of address in external latch     
   ***************************************************************************/
  assign aux_addr = per_addr[15:0];
  assign bios_clk = (ser_c & clk_en);
  assign bios_hld = ser_h;
  assign bios_csn = ser_s;

//  assign aux_addr = {serial_counter[0], ser_h, ser_s, per_addr[15:0]};

  /**************************************************************************
   * enable strobes to selected  dac only internal/external
   * disabled strobes remain   high 
   ***************************************************************************/
  assign aux_dac_wr = {2{dac_wr | idac_sel}}; //idac_sel low enables strobes
  assign aux_dac_rd = {2{dac_rd | idac_sel}}; // to external dac
  
  assign idac_wr    = dac_wr | ~idac_sel ;// idac_sel high enables strobes 
  assign idac_rd    = dac_rd | ~idac_sel ; // internal dac
  
  /***************************************************************************
   * load wait state cunter lcount (for DAC and EPROM) with request or reload again
   * between four reads prom cycles. Return  "count=zero" to PER_SM. 
   * per_dac is active low!
   *
   * load wait state conter hcount for keeping minimum RD/WR high (for DAC only) 
   * reload the counter to extend  the begining and  the end of a sequence 
   * for total 6+6+4 
   *
   * load "prom_read_cycle"  counter. Always four read cycles are performed
   * and  the data is formated into one dword to be sent to HBI.
   Return "count=zero" to PER_SM.
   
   ***************************************************************************/
  always @(posedge hclock or negedge reset)
    if(!reset) begin
      lcount <= 4'b0;
      hcount <= 3'b0;
      pcount <= 2'b0; //who cares
    end else begin
      casex ({per_req, reload_lcount, ldecr, per_dac}) 
	4'b000x: lcount <= lcount;
	4'b001x: lcount <= lcount - 1'b1;
	4'b01xx: lcount <= prom_wait;
	4'b1xx0: lcount <= {1'b0, dac_wait[2:1] , 1'b0};
	4'b1xx1: lcount <=  prom_wait;
      endcase
      casex ({per_req, reload_hcount, hdecr, dac_wait[0]}) 
	4'b000x: hcount <= hcount;
	4'b001x: hcount <= hcount - 1'b1;
	4'b01xx: hcount <= 3'b101; //load with five
	4'b1xx0: hcount <= 3'b000; // load with zero on request
	4'b1xx1: hcount <= 3'b101; //load with five on request
      endcase
      casex ({per_req , pdecr})
	2'b00: pcount <= pcount;
	2'b01: pcount <= pcount - 1'b1;
	2'b1x: pcount <= 2'b11;
      endcase
    end
  
  assign l_wait = |lcount ; // (wait in state machine if l_wait high) 
  assign last     = (pcount==2'b0);

  /*************************************************************************
   * select and  register data comming from peripheral devices  data bus 
   * the registered data will be used by HBI when per_done impulse
   * (after read cycle) is issued, or later. Nothing  changes this data until
   * next read cycle will run .
   **************************************************************************/
  always @(posedge hclock) begin
    casex({(ser_capt & ~ser_c), per_clkd, prom_rd_cyc, per_addr[1:0]})
      5'b010xx: begin  // DAC cycle, replicate data on all bytes
        if(idac_sel) begin//internal dac selected
          per_data_rd[7:0]   <= idac_data_in;
          per_data_rd[15:8]  <= idac_data_in;
          per_data_rd[23:16] <= idac_data_in;
          per_data_rd[31:24] <= idac_data_in;
        end else begin     //external ram dac selected
          per_data_rd[7:0]   <= aux_data_in;
          per_data_rd[15:8]  <= aux_data_in;
          per_data_rd[23:16] <= aux_data_in;
          per_data_rd[31:24] <= aux_data_in;
        end
      end
      
      5'b01100: begin // EPROM cycle, first byte strobed
        per_data_rd[7:0]   <= aux_data_in;
      end
      
      5'b01101: begin // EPROM cycle, second byte strobed
        per_data_rd[15:8]  <= aux_data_in;
      end
 
      5'b01110: begin // EPROM cycle, third byte strobed
        per_data_rd[23:16] <= aux_data_in;
      end
      
      5'b01111: begin // EPROM cycle, fourth byte strobed
        per_data_rd[31:24] <= aux_data_in;
      end

      // Serial Eprom Capture
      5'b1xxxx: begin
	case (serial_counter[5:4])
	  2'b00: per_data_rd[7:0]   <= {per_data_rd[6:0],   bios_rdat};
	  2'b01: per_data_rd[15:8]  <= {per_data_rd[14:8],  bios_rdat};
	  2'b10: per_data_rd[23:16] <= {per_data_rd[22:16], bios_rdat};
	  2'b11: per_data_rd[31:24] <= {per_data_rd[30:24], bios_rdat};
	endcase
      end
      default: per_data_rd <= per_data_rd;
    endcase
  end

  /***************************************************************************
   *                    PERIPHERAL STATE MACHINE                             * 
   ***************************************************************************/
  //signals to I/Os or host to be driven from flip-flops 
  always @(posedge hclock) begin 
    aux_prom_oe    <= aux_prom_oe_i;
    aux_prom_we    <= aux_prom_we_i;
    aux_buff_en    <= aux_buff_en_i;
    aux_ld_sft     <= aux_ld_sft_i;
    dac_wr         <= dac_wr_i;
    dac_rd         <= dac_rd_i;
    aux_prom_cs    <= aux_prom_cs_i;	
    per_done       <= per_done_i;
    per_ready      <= per_ready_i;
    // Serial stuff--- figure out pins!
    ser_c          <= serial_counter[0];
    ser_s_ii       <= ser_s_i;
    ser_s          <= ser_s_ii;
    clk_en         <= clk_en_i;
    ser_addr_en    <= ser_addr_en_i;
  end

  // always @(negedge hclock) begin
  always @(posedge hclock) begin
    ser_h_ii <= ser_h_i;
    ser_h <= ser_h_ii;
  end
  
  assign command = (rdsr) ? ser_cmd[SEPM_RDSR] : ser_cmd[sepm_cmd];
  
  // Serial Counter
  always @(posedge hclock or negedge reset)
    if (!reset)                    serial_counter <= 6'b0;
    else if (clear_serial_counter) serial_counter <= 6'b0;
    else                           serial_counter <= serial_counter + ser_inc;
  
  always @(posedge hclock or negedge reset)
    if (!reset) cstate <= IDLE ;
    else        cstate <= nstate;
  
  // PERIPHERAL CYCLES STATE MACHINE
  always @* begin 
    aux_prom_oe_i        = 1'b1;
    aux_prom_we_i        = 1'b1;
    aux_buff_en_i        = 1'b1;
    aux_ld_sft_i         = 1'b0;
    dac_wr_i             = 1'b1;
    dac_rd_i             = 1'b1;
    aux_prom_cs_i        = 1'b1;
    per_clkd             = 1'b0;
    prom_rd_cyc          = 1'b0; // set if data from eprom gets registered
    incraddr             = 1'b0; // The default is not to increment the address
    pdecr                = 1'b0; //
    ldecr                = 1'b0; //
    hdecr                = 1'b0; //
    reload_lcount        = 1'b0; // The default is to not re-load lcount
    reload_hcount        = 1'b0; // The default is to not re-load hcount
    per_ready_i          = 1'b0; 
    per_done_i           = 1'b0; 
    clear_serial_counter = 1'b0; // Do not clear serial counter
    ser_s_i              = 1'b1; // Default to not selecting serial prom
    ser_addr_en_i        = 1'b0; // default to data mode
    ser_capt             = 1'b0;
    ser_inc              = 1'b0;
    clr_sepm_busy        = 1'b0;
    ser_h_i              = 1'b1; // Serial hold signal internal
    rdsr                 = 1'b0;
    clk_en_i             = 1'b0;
    nstate               = cstate;
    
    case (cstate)  //synopsys parallel_case

      IDLE: begin
        per_ready_i=(per_req)? 1'b0: 1'b1; //send "not ready" on next cycle
        per_done_i =(per_req && (!per_read || (per_read && per_dac && per_prom)
				 ||  per_lbe_f)); 

        // send done on next cycle for all writes cycles and
        // in case of attempting reads from softsw 
        // ( error conditions),
        // and any time request with per_lbe_f==1 occures 
        if (per_req & ~per_lbe_f) // All BEn's set, no data xfer
          casex ({per_dac, per_prom, per_read}) //per_dac,per_eprom act.low
            3'b0xx: nstate = DAC_ZERO ;  //gives priority to DAC cycles 
            3'b10x: nstate = (ser_parn) ? SPROM1 : PROM_ONE ; 
            3'b110: nstate = SOFT_ONE ; // writes to soft switch 
            3'b111: nstate = IDLE ;     /* ignore this type of request 
                                         * no reads from softswitch
                                         * should occure */
          endcase
        else if (sepm_busy) nstate = SPROM1;
	else nstate= IDLE ; 
      end

      ////////// SOFT SWITCH WRITE CYCLE
      SOFT_ONE: begin
	aux_buff_en_i = 1'b0;
	nstate = SOFT_TWO ;
      end

      SOFT_TWO: begin
	aux_buff_en_i = 1'b0;
	nstate = SOFT_THREE ;
      end
      
      SOFT_THREE: begin
	aux_ld_sft_i = 1'b1;
	aux_buff_en_i = 1'b0;
	nstate = PERIPH_END;
      end

      ////////// DAC READ/WRITE CYCLE
      DAC_ZERO  : nstate = DAC_ONE;
      // this makes minimum 2 clocks
      // of address setup to falling edge of
      //  DAC's RW or RD signal
      // hcount here can only be five or zero
      // loaded with request

      DAC_ONE : 
	begin
          if (read_cyc) dac_rd_i = 1'b1;
          else
            begin
              dac_wr_i   = 1'b1;
              aux_buff_en_i = 1'b0;
            end    
	  nstate = DAC_TWO ;
	end

      DAC_TWO : 
	begin
          if (read_cyc)
            dac_rd_i = 1'b0;
          else
            begin
              dac_wr_i   = 1'b0;
              aux_buff_en_i = 1'b0;
            end
	  nstate = DAC_THREE ;
	end

      DAC_THREE  : 
	begin
          if (read_cyc)
            begin
              per_clkd  = 1'b1;     // data gets registered,
              per_done_i= 1'b1;     // valid registered data and
              // and per_done will occure after
              // the same (next) rising edge of clock
            end
          else aux_buff_en_i = 1'b0;  //  dac_wr_i goes high acutal WR cycle 
          // this provides 1 clock of hold time for
          // write data
          nstate = PERIPH_END; //hcount can only be
	end

      //////////////////////////////////////////////////////////////////////

      ////////// EPROM CYCLES

      PROM_ONE: begin
	aux_prom_cs_i  = 1'b0;     // this gives one clock address setup 
        // to falling edge of  Latch enable of F373  
	if (read_cyc) nstate  = PROM_TWO ; // EPROM read
	else          nstate  = PROM_FIVE ; // EPROM write
      end

      PROM_TWO: begin          // sel_addr_high_i  switched to 0
	aux_prom_cs_i  = 1'b0; // this gives one clock address hold time 
	aux_prom_oe_i  = 1'b0; // to falling edge of  Latch enable of F373  
	nstate = PROM_THREE ;   // (uses prom_cs)
      end

      PROM_THREE: begin
	aux_prom_cs_i  = 1'b0;
	aux_prom_oe_i  = 1'b0;
	ldecr = 1'b1;       
	// Decrement wait state count, if wait states count is
        // zero it will overflow , but then who cares
        // the state  will jump to PROM_FOUR 
        // Mimimum time to rising edge of clock strobing
        // data is 3 clocks from CS low 
        // and 2 (two!) clocks from OE low and complete address
        // minus all delays from clock to
        // address/CS/OE  on PROM pins.
	if (!l_wait)   nstate = PROM_FOUR ;
	else           nstate = PROM_THREE ; 
      end

      PROM_FOUR: begin
	aux_prom_cs_i  = (last)? 1'b1: 1'b0;
	aux_prom_oe_i  = (last)? 1'b1: 1'b0;
        // don't toggle cs and oe between four reads
        // but speed up turning off after last read. 
        // to have more turn-around time for other
        // accesses (if ever used such mixed acces )
        // in normal case eprom will be read in to
        // shadow memory.
        // hold time for last byte is O.K ( as below)
	reload_lcount = 1'b1;
	incraddr   = 1'b1;
        // hold time for data coming in to rising 
        // edge of clock is guaranteed by address output
        // buffers delay + input_data_path
        // + prom_data_delay_from address
        // so it is safe to strobe on the clock in this
        // state 
	pdecr    = 1'b1;
        // it will overflow if all 4 pages done, but 
        // who cares, the state will jump to PERIPH_END 
	per_clkd     = 1'b1;    
        prom_rd_cyc    = 1'b1;     // prom read cycle indicator  
        per_done_i  = (last)? 1'b1: 1'b0; // send done (valid data )to host  
        
	if (last) nstate = PERIPH_END ; // 4 pages done
	else      nstate = PROM_THREE ;  // do next page 
      end

      PROM_FIVE: begin  //double check flash eprom spec !!
	aux_prom_cs_i  = 1'b0;
        //sel_addr_high_i switched to low
        //to make 1 clock of hold time on ext.latch
        // (uses prom_cs)
	aux_buff_en_i  = 1'b0; 
	nstate = PROM_SIX ;
      end

      PROM_SIX: begin
	aux_prom_cs_i  = 1'b0;
	aux_buff_en_i  = 1'b0;
	aux_prom_we_i  = 1'b0;
	// prom_WE low time is 1+prom_wait
        // address (complete and valid) to falling
        // edge WE is 1 clock
        // address (complete and valid) to rising
        // edge WE is 2 clocks + prom wait
	ldecr = 1'b1;                  // Decrement wait state count
	if (!l_wait)   nstate = PROM_SEVEN ;
	else           nstate = PROM_SIX ;
      end

      PROM_SEVEN: begin	
	aux_prom_cs_i  = 1'b0; // 
	aux_buff_en_i  = 1'b0;
	// this gives 1 clock of hold time for data 
        // from rising edge of eprom WE.
        
	nstate = PERIPH_END ;
      end

      // Serial EPROM Cycles
      SPROM1: begin
	clk_en_i = 1'b1;
	aux_buff_en_i = 1'b0;
	if (read_cyc || sepm_busy) begin
	  clear_serial_counter = 1'b1;
	  ser_s_i = 1'b0; // drop the serial select low
	  ser_inc = 1'b1; // Increment the counter
	  ser_addr_en_i = 1'b1; // select the command output
	  // if we are writing an unsupported command, or if we are writing
	  // a read command, then we're done. Note that the EOP command is
	  // unsupported unless in a write loop.
	  if ((sepm_cmd > 4'b0101) || 
	      (sepm_busy && sepm_cmd == SEPM_READ)) begin
	    nstate  = PERIPH_END; // Unsupported external command
	    clr_sepm_busy = 1'b1; // Clear the busy flag
	    per_done_i = 1'b1;     // signal cycle done
	  end else 
	    nstate = SPROM_ADDR;
	end
      end // case: SPROM1
      
      SPROM_ADDR: begin
	clk_en_i = 1'b1;
	aux_buff_en_i = 1'b0;
	ser_s_i = 1'b0; // keep the serial select low
	ser_inc = 1'b1; // Keep incrementing the counter
	ser_addr_en_i = 1'b1; // select the command output
	// Determine if we are done w/ the address
	casex ({sepm_cmd, serial_counter[5:0]})
	  {SEPM_WREN, 6'bxx1111}, {SEPM_WRDI, 6'bxx1111}: begin
	    // To set or reset the write latch takes only the instruction
	    nstate  = PERIPH_END; 
	    clr_sepm_busy = 1'b1; // Clear the busy flag
	    per_done_i = 1'b1;     // signal cycle done
	    clear_serial_counter = 1'b1;
	  end 
	  {SEPM_READ, 6'b111111}: begin
	    nstate = SPROM_READ;
	    ser_addr_en_i = 1'b0; // select the command output
	  end
	  {SEPM_PP, 6'b111111}: begin
	    // Here we are setting up for a programming session.
	    // Send out the programming command and then we will go to
	    // the write idle state
	    nstate  = SPROM_WIDLE; 
//	    ser_h_i = 1'b0;
//	    clr_sepm_busy = 1'b1; // Clear the busy flag
	    per_done_i = 1'b1;     // signal cycle done
	    clear_serial_counter = 1'b1;
	    per_ready_i = 1'b1;    // be ready in next idle state
	  end
	  {SEPM_SE, 6'b111111}: begin
	    // Send the command to clear the sector. Then we will go to the
	    // wait for WIP to go away state. However, release comtrol to the
	    // host so we can commence polling
	    clear_serial_counter = 1'b1;
	    nstate  = SPROM_RDSR_IDLE; 
	    per_done_i = 1'b1;     // signal cycle done
	  end
	  {SEPM_BE, 6'b001111}: begin
	    clear_serial_counter = 1'b1;
	    nstate  = SPROM_RDSR_IDLE;
	    per_done_i = 1'b1;     // signal cycle done
	  end
	  default: nstate = SPROM_ADDR;
	endcase // casex({sepm_cmd, serial_counter[5:1]})
      end
      
      SPROM_READ:  begin
	clk_en_i = 1'b1;
	ser_s_i = 1'b0; // keep the serial select low
	ser_inc = 1'b1; // Keep incrementing the counter
	ser_capt = 1'b1; // Capture incoming data
	// Read in 32 bits of data (4 bytes)
	if (&serial_counter) begin
	  nstate = PERIPH_END;
	  per_done_i = 1'b1;     // signal cycle done
	end else
          nstate = SPROM_READ;
      end
      
      SPROM_WIDLE: begin
	per_ready_i = 1'b1;    // be ready in next idle state
	aux_buff_en_i = 1'b0;
	ser_s_i = 1'b0; // keep the serial select low
	ser_h_i = 1'b0;
	ser_inc = 1'b1; // Keep incrementing the counter
	clk_en_i = 1'b1;
	if (sepm_cmd == SEPM_EOP && sepm_busy) begin
	  clk_en_i = 1'b0;
	  ser_h_i = 1'b1;
//	  ser_s_i = 1'b1;
	  clear_serial_counter = 1'b1;
	  nstate  = SPROM_S; 
	  per_done_i = 1'b1;     // signal cycle done
	end else if (!per_prom & per_req & ~per_lbe_f) begin
//	  clear_serial_counter = 1;
	  nstate = SPROM_WIDLE1;
	end else nstate = SPROM_WIDLE;
      end // case: SPROM_WIDLE

      SPROM_S: begin
	// Delay releasing S until 1 cycle after releasing hold
	clk_en_i = 1'b0;
	ser_s_i = 1'b1;
	ser_inc = 1'b1; // Keep incrementing the counter
	if (&serial_counter[2:0]) begin
	  clear_serial_counter = 1'b1;
	  nstate = SPROM_RDSR_IDLE;
	  ser_h_i = 1'b1;
	end else nstate = SPROM_S;
      end
      
      SPROM_WIDLE1: begin
	aux_buff_en_i = 1'b0;
	ser_s_i = 1'b0; // keep the serial select low
	ser_inc = 1'b1; // Keep incrementing the counter
	clk_en_i = 1'b1;
	ser_h_i = 1'b0;
	if (~|serial_counter[3:0]) begin
	  nstate = SPROM_WRITE;
	  ser_h_i = 1'b1;
	end else nstate = SPROM_WIDLE1;
      end // case: SPROM_WIDLE

      SPROM_WRITE: begin
	clk_en_i = 1'b1;
	aux_buff_en_i = 1'b0;
	ser_s_i = 1'b0; // keep the serial select low
	ser_inc = 1'b1; // Increment the counter
	if (&serial_counter[3:0]) begin
	  per_done_i = 1'b1;     // signal cycle done
	  nstate = SPROM_WIDLE;
	end else 
	  nstate = SPROM_WRITE;
      end

      SPROM_RDSR_IDLE: begin
	ser_inc = 1'b1; // Increment the counter
	if (&serial_counter[2:0]) begin
	  aux_buff_en_i = 1'b0;
	  clear_serial_counter = 1'b1;
	  nstate = SPROM_RDSR_IDLE1;
	end else nstate = SPROM_RDSR_IDLE;
      end
      
      SPROM_RDSR_IDLE1: begin
	clk_en_i = 1'b1;
	aux_buff_en_i = 1'b0;
	ser_s_i = 1'b0; // keep the serial select low
	clear_serial_counter = 1'b1;
	nstate = SPROM_RDSR;
	rdsr = 1'b1;
      end
      
      SPROM_RDSR: begin
	clk_en_i = 1'b1;
	rdsr = 1'b1;
	aux_buff_en_i = 1'b0;
	ser_s_i = 1'b0; // keep the serial select low
	ser_inc = 1'b1; // Increment the counter
	ser_addr_en_i = 1'b1; // select the command output
	if (&serial_counter[3:0]) begin
	  //clear_serial_counter = 1;
	  nstate = SPROM_WIP;
	end else nstate = SPROM_RDSR;
      end

      SPROM_WIP: begin
	clk_en_i = 1'b1;
	ser_s_i = 1'b0; // keep the serial select low
	ser_inc = 1'b1; // Increment the counter
	if (&serial_counter[3:0] && ~aux_data_in[1]) begin
	  // The WIP bit has gone low, so we're done
	  clr_sepm_busy = 1'b1; // Clear the busy flag
	  nstate = PERIPH_END;
	end else nstate = SPROM_WIP;
      end
	    
      PERIPH_END: begin                         // disable all divers
	per_ready_i = 1'b1;    // be ready in next idle state
	nstate = IDLE ;
      end
      
      default:  nstate = IDLE ;
      
    endcase 
  end 





endmodule

