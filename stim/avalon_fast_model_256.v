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
//  Title       :  Avalon memory interface functional model
//  File        :  avalon_fast_model_256.v
//  Author      :  Jim MacLeod
//  Created     :  10-19-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : This models a memory based on the avalon interface to
//                speed up simulations.
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
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
`define INFO  $display
`timescale 1ns / 10ps
//parameter READ_DELAY    = 37;
parameter READ_DELAY    = 10;
parameter READ_PIPE     = READ_DELAY+1;
parameter MEM_SIZE      = 32'h100000;
// parameter full_mem_bits = 28;
// parameter full_mem_bits = 27;
parameter full_mem_bits = 26;
parameter part_mem_bits = 23;
parameter ADDR_INCR     =  1;

module avalon_fast_model
  (
	local_address,
	local_write_req,
	local_read_req,
	local_wdata,
	local_be,
	local_size,
	global_reset_n,
	pll_ref_clk,
	soft_reset_n,
	local_ready,
	local_rdata,
	local_rdata_valid,

        local_burstbegin,

	reset_request_n,
	mem_odt,
	mem_cs_n,
	mem_cke,
	mem_addr,
	mem_ba,
	mem_ras_n,
	mem_cas_n,
	mem_we_n,
	mem_dm,
	local_refresh_ack,
	local_wdata_req,
	local_init_done,
	reset_phy_clk_n,
   mem_reset_n,
   dll_reference_clk,
   dqs_delay_ctrl_export,
	phy_clk,
	aux_full_rate_clk,
	aux_half_rate_clk,
	mem_clk,
	mem_clk_n,
	mem_dq,
	mem_dqs,
	mem_dqsn);


	input		pll_ref_clk;
	input		global_reset_n;

	input	[23:0]	local_address;
	input		local_write_req;
        input           local_burstbegin;
	input		local_read_req;
	input	[255:0]	local_wdata;
	input	[31:0]	local_be;
	input	[6:0]	local_size;
	input		soft_reset_n;
	output		local_ready;
	output	[255:0]	local_rdata;
	output		local_rdata_valid;
	output		reset_request_n;
	output		local_refresh_ack;
	output		local_wdata_req;
	output		local_init_done;

        //Unused in this model
	output		phy_clk;
	output		aux_full_rate_clk;
	output		aux_half_rate_clk;
	output		reset_phy_clk_n;
	output		mem_reset_n;
	output		dll_reference_clk;
	output	[5:0]	dqs_delay_ctrl_export;
	output	[0:0]	mem_odt;
	output	[0:0]	mem_cs_n;
	output	[0:0]	mem_cke;
	output	[12:0]	mem_addr;
	output	[2:0]	mem_ba;
	output		mem_ras_n;
	output		mem_cas_n;
	output		mem_we_n;
	output	[3:0]	mem_dm;

	inout	     	mem_clk;
	inout	     	mem_clk_n;
	inout	[31:0]	mem_dq;
	inout	[3:0]	mem_dqs;
	inout	[3:0]	mem_dqsn;

	`define B0  [7:0]
	`define B1  [15:8]
	`define B2  [23:16]
	`define B3  [31:24]
	`define B4  [39:32]
	`define B5  [47:40]
	`define B6  [55:48]
	`define B7  [63:56]
	`define B8  [71:64]
	`define B9  [79:72]
	`define B10 [87:80]
	`define B11 [95:88]
	`define B12 [103:96]
	`define B13 [111:104]
	`define B14 [119:112]
	`define B15 [127:120]
	`define B16 [135:128]
	`define B17 [143:136]
	`define B18 [151:144]
	`define B19 [159:152]
	`define B20 [167:160]
	`define B21 [175:168]
	`define B22 [183:176]
	`define B23 [191:184]
	`define B24 [199:192]
	`define B25 [207:200]
	`define B26 [215:208]
	`define B27 [223:216]
	`define B28 [231:224]
	`define B29 [239:232]
	`define B30 [247:240]
	`define B31 [255:248]

  // Wires.
  
  logic         clk;
  assign        clk   =   pll_ref_clk;

  logic		phy_clk;
  assign        phy_clk = aux_half_rate_clk;

  logic         reset_phy_clk_n;
//assign        reset_phy_clk_n = 1'b1;

  logic		aux_full_rate_clk;
  assign        aux_full_rate_clk = clk;

  wire [0:0]		mem_clk;
  assign        mem_clk = clk;

  wire [0:0]		mem_clk_n;
  assign        mem_clk_n = !clk;

  logic         reset;
  assign        reset = !global_reset_n;

  // Registers.
//logic [31:13] pxa_to_dsp1_ipc_map; 
  
  logic		aux_half_rate_clk;
  logic		local_ready;
  logic	[255:0]	local_rdata;
  logic		local_rdata_valid;
  logic		reset_request_n;
  logic		local_refresh_ack;
  logic		local_wdata_req;
  logic         local_wdata_req_q1;
  logic		local_init_done;

  logic [31:0]	local_be_q0;
  logic [31:0]	local_be_q1;

  logic [255:0]	local_wdata_q0;
  logic [255:0]	local_wdata_q1;

  logic         local_burstbegin_q0;
  logic         local_burstbegin_q1;

  logic	[255:0]	local_rdata_d;
  logic	[255:0]	buf_data;
  logic		local_rdata_valid_d;
  
  logic	[23:0]	local_address_q0;
  logic	[23:0]	local_address_q1;
  logic	[6:0]	local_size_q0;
  logic	[6:0]	local_size_q1;
  logic		local_read_req_q0;
 
  logic [23:0]  addr, current_addr;

//logic [127:0] mem[MEM_SIZE];
  // Memory Banks
  `ifdef FAST_MEM_FULL
    // logic [127:0] mem[0:MEM_SIZE];
    logic [7:0] mem[0 : (1<<full_mem_bits)-1];
  `else
      logic [127:0] mem[0 : (1<<part_mem_bits)-1];
      reg   [127:                0] mem_array  [0 : (1<<part_mem_bits)-1];
      reg   [full_mem_bits - 1 : 0] addr_array [0 : (1<<part_mem_bits)-1];
      reg   [part_mem_bits     : 0] mem_used;
      reg   [part_mem_bits     : 0] memory_index;
      initial mem_used = 0;
  `endif

  //Pipeline to delay rd data
  logic [255:0] pipe_rdat[READ_PIPE];
  logic         pipe_rval[READ_PIPE];
  integer       pipe_i;
  integer       byte_en;

  logic [  4:0] reset_counter;

  logic     [31:0]   pop_dat;
  logic              pop_dat_vld ;
                     
  logic              afull;

  //66.5MHz
  //parameter HALF_PERIOD = 7.519ns;  //66.5MHx
  parameter HALF_PERIOD = 2.501ns;  

  always begin
    #HALF_PERIOD aux_half_rate_clk = 0;
    #HALF_PERIOD aux_half_rate_clk = 1;
  end


  //Drive reset_phy_clk_n for 8 clks after reset
  always @(posedge clk) begin
    if (reset) begin
      reset_phy_clk_n   <= 0;
      reset_counter     <= 0;
    end 
    else begin
      if (reset_counter<8)
        reset_counter   <= reset_counter + 1;
      reset_phy_clk_n <= reset_counter[3];
    end 
  end


  always @(posedge phy_clk) begin
    if (reset) begin
      for (pipe_i=0; pipe_i<READ_PIPE; pipe_i++) begin
        pipe_rdat[pipe_i]    <= 256'b0;
        pipe_rval[pipe_i]    <= 1'b0;
      end
    end 
    else begin
      for (pipe_i=0; pipe_i<READ_PIPE-1; pipe_i++) begin
        pipe_rdat[pipe_i]    <= pipe_rdat[pipe_i+1]    ;
        pipe_rval[pipe_i]    <= pipe_rval[pipe_i+1]    ;
      end
        pipe_rdat[READ_DELAY]<= local_rdata_d      ;
        pipe_rval[READ_DELAY]<= local_rdata_valid_d;
    end 
  end

  always @(posedge phy_clk) begin
    if (reset) begin
      local_ready            <= 1'b0              ;
      local_init_done        <= 1'b0              ;
      local_refresh_ack      <= 1'b0              ;
    end
    else begin
    //local_ready            <= (local_burstbegin && local_read_req)? 1'b0 : 1'b1;
      local_ready            <= ~afull;
      local_init_done        <= 1'b1              ;
      local_refresh_ack      <= 1'b0              ;
      local_address_q1       <= local_address_q0  ;
      local_address_q0       <= local_address     ;
      local_size_q1          <= local_size_q0  ;
      local_size_q0          <= local_size     ;
      local_read_req_q0      <= local_read_req    ;
      local_rdata            <= pipe_rdat[  0   ] ;
      local_rdata_valid      <= pipe_rval[  0   ] ;

      local_wdata_req_q1     <= local_wdata_req;
      local_wdata_req        <= local_write_req   ;

      local_be_q1            <= local_be_q0;
      local_be_q0            <= local_be;

      local_wdata_q1         <= local_wdata_q0;
      local_wdata_q0         <= local_wdata;

      local_burstbegin_q1    <= local_burstbegin_q0;
      local_burstbegin_q0    <= local_burstbegin   ;
    end

  end  

  assign addr = (local_burstbegin_q1?local_address_q1:local_address_q1+ADDR_INCR);

  // Write First Data.
  always @(posedge phy_clk) begin
    if (local_wdata_req_q1 && local_burstbegin_q1) begin
      current_addr <= addr + 1;
      `INFO("%t: DDR_CTRL wr: addr %0h \t data %0h mask %0h", $time,       addr      , local_wdata_q1, local_be_q1);
      write_mem(addr, local_be_q1, local_wdata_q1);
    end 
    // Write any remaining data.
    else if (local_wdata_req_q1) begin
      current_addr <= current_addr + 1;
      `INFO("%t: DDR_CTRL wr: addr %0h \t data %0h mask %0h", $time,       current_addr      , local_wdata_q1, local_be_q1);
      write_mem(current_addr, local_be_q1, local_wdata_q1);
    end
  end

  

  // always_comb begin, Aldec has a problem with this.
  always @* begin
    local_rdata_valid_d = pop_dat_vld;
    if (pop_dat_vld) begin
      read_mem(pop_dat, local_rdata_d);
          `INFO("%t: DDR_CTRL rd: addr %0h \t data %0h", $time, pop_dat , local_rdata_d);
    end
  end
   

    // Write Memory
    task write_mem;
        input [full_mem_bits - 1 : 0] addr;
        input     [31            : 0] be;
        input     [255           : 0] data;
        reg       [part_mem_bits : 0] i;
        begin
	 // @(negedge phy_clk) begin
            if(be[31]) mem[{addr, 5'd31}] = data`B31;
            if(be[30]) mem[{addr, 5'd30}] = data`B30;
            if(be[29]) mem[{addr, 5'd29}] = data`B29;
            if(be[28]) mem[{addr, 5'd28}] = data`B28;
            if(be[27]) mem[{addr, 5'd27}] = data`B27;
            if(be[26]) mem[{addr, 5'd26}] = data`B26;
            if(be[25]) mem[{addr, 5'd25}] = data`B25;
            if(be[24]) mem[{addr, 5'd24}] = data`B24;
            if(be[23]) mem[{addr, 5'd23}] = data`B23;
            if(be[22]) mem[{addr, 5'd22}] = data`B22;
            if(be[21]) mem[{addr, 5'd21}] = data`B21;
            if(be[20]) mem[{addr, 5'd20}] = data`B20;
            if(be[19]) mem[{addr, 5'd19}] = data`B19;
            if(be[18]) mem[{addr, 5'd18}] = data`B18;
            if(be[17]) mem[{addr, 5'd17}] = data`B17;
            if(be[16]) mem[{addr, 5'd16}] = data`B16;
            if(be[15]) mem[{addr, 5'd15}] = data`B15;
            if(be[14]) mem[{addr, 5'd14}] = data`B14;
            if(be[13]) mem[{addr, 5'd13}] = data`B13;
            if(be[12]) mem[{addr, 5'd12}] = data`B12;
            if(be[11]) mem[{addr, 5'd11}] = data`B11;
            if(be[10]) mem[{addr, 5'd10}] = data`B10;
            if(be[9])  mem[{addr, 5'd9 }] = data`B9;
            if(be[8])  mem[{addr, 5'd8 }] = data`B8;
            if(be[7])  mem[{addr, 5'd7 }] = data`B7;
            if(be[6])  mem[{addr, 5'd6 }] = data`B6;
            if(be[5])  mem[{addr, 5'd5 }] = data`B5;
            if(be[4])  mem[{addr, 5'd4 }] = data`B4;
            if(be[3])  mem[{addr, 5'd3 }] = data`B3;
            if(be[2])  mem[{addr, 5'd2 }] = data`B2;
            if(be[1])  mem[{addr, 5'd1 }] = data`B1;
            if(be[0])  mem[{addr, 5'd0 }] = data`B0;
    // end
        end
    endtask


    // Read Memory
    task read_mem;
        input [full_mem_bits - 1 : 0] addr;
        output    [255           : 0] data;
        reg       [part_mem_bits : 0] i;
        begin
`ifdef FAST_MEM_FULL
            data`B31 = mem[{addr, 5'd31}];
            data`B30 = mem[{addr, 5'd30}];
            data`B29 = mem[{addr, 5'd29}];
            data`B28 = mem[{addr, 5'd28}];
            data`B27 = mem[{addr, 5'd27}];
            data`B26 = mem[{addr, 5'd26}];
            data`B25 = mem[{addr, 5'd25}];
            data`B24 = mem[{addr, 5'd24}];
            data`B23 = mem[{addr, 5'd23}];
            data`B22 = mem[{addr, 5'd22}];
            data`B21 = mem[{addr, 5'd21}];
            data`B20 = mem[{addr, 5'd20}];
            data`B19 = mem[{addr, 5'd19}];
            data`B18 = mem[{addr, 5'd18}];
            data`B17 = mem[{addr, 5'd17}];
            data`B16 = mem[{addr, 5'd16}];
            data`B15 = mem[{addr, 5'd15}];
            data`B14 = mem[{addr, 5'd14}];
            data`B13 = mem[{addr, 5'd13}];
            data`B12 = mem[{addr, 5'd12}];
            data`B11 = mem[{addr, 5'd11}];
            data`B10 = mem[{addr, 5'd10}];
            data`B9  = mem[{addr, 5'd9 }];
            data`B8  = mem[{addr, 5'd8 }];
            data`B7  = mem[{addr, 5'd7 }];
            data`B6  = mem[{addr, 5'd6 }];
            data`B5  = mem[{addr, 5'd5 }];
            data`B4  = mem[{addr, 5'd4 }];
            data`B3  = mem[{addr, 5'd3 }];
            data`B2  = mem[{addr, 5'd2 }];
            data`B1  = mem[{addr, 5'd1 }];
            data`B0  = mem[{addr, 5'd0 }];
`else
            begin : loop
                for (i = 0; i < mem_used; i = i + 1) begin
                    if (addr_array[i] === addr) begin
                        disable loop;
                    end
                end
            end
            if (i <= mem_used) begin
                data = mem_array[i];
            end else begin
                data = 'bx;
            end
`endif
        end
    endtask

   sync_fifo  u_sync_fifo(
    .push        (local_read_req_q0 && local_burstbegin_q0),
    .burst       (local_burstbegin_q0),
    .burst_count (local_size_q0),
    .push_dat    ({8'h0, local_address_q0}),
    .pop         (1'b1),
    .pop_dat     (pop_dat),
    .pop_dat_vld (pop_dat_vld),

    .full        (),
    .afull       (afull),
    .empty       (),
                 
    .clk         (phy_clk),
    .reset       (reset)
   );

endmodule 

// FIFO
//

parameter FIFO_DEPTH = 128;
parameter AFULL_SIZE = 64;

module sync_fifo (
   push,
   burst,
   burst_count,
   push_dat,
   pop,
   pop_dat,
   pop_dat_vld ,

   full,
   afull,
   empty,

   clk,
   reset

  );

    input            push;
    input            burst;
    input [6:0]	     burst_count;
    input   [31:0]   push_dat;
    input            pop;
    output  [31:0]   pop_dat;
    output           pop_dat_vld ;
                     
    output           full;
    output           afull;
    output           empty;
                     
    input            clk;
    input            reset;


    logic            full;
    logic            afull;

    //---------------------------------- 
    // Fifo and pointers 
    bit [31:0]        fifo[FIFO_DEPTH-1:0]; 
    bit [31:0]        wr_ptr; 
    bit [31:0]        rd_ptr; 
  bit [6:0] 	      count;
  
    logic  [31:0]     pop_dat;
    logic             pop_dat_vld ;

    integer           verbose = 0;
 
    //---------------------------------- 

    assign pop_dat  = fifo[rd_ptr];
    assign empty    = (rd_ptr == wr_ptr);


  //---------------------------------
  // Init fifo
  //---------------------------------
  initial begin
    for (int jj=0;jj<FIFO_DEPTH;jj++) begin
      fifo[jj]   = 0;
    end

    wr_ptr = 0;
    rd_ptr = 0;
    full   = 0;
    afull   = 0;


  end // initial

  assign pop_dat_vld = (pop && (wr_ptr != rd_ptr));

  always @(negedge clk) begin
    if (!reset) begin
      //POP
      //incr Rd ptr if diff
      if (pop && (wr_ptr != rd_ptr)) begin
        fifo[rd_ptr]  <= 0;
        rd_ptr        <= fifo_ptr_inc(rd_ptr);
      end
      
      //PUSH
      count = 1;
      if (push) begin
        fifo_push(push_dat);
	if (burst)
		while (count != burst_count)
            		fifo_push(push_dat + count++);
	
      end
    end
  end
  
    always @(wr_ptr or rd_ptr) begin
      full     = (fifo_space() == 0);
      afull    = (fifo_avail(AFULL_SIZE)== 0 );
    end

  //Push new ddr_req onto fifo after checking for space
  task fifo_push(
    input [31:0]        ddr_rq);
  begin
    if (fifo_space()) begin
      if (verbose>10)
        $display("%t: fifo_model: OutputQ.Push :  rq:%0d; wr_ptr:%0d, rd_ptr:%0d",
        $time, ddr_rq, wr_ptr, rd_ptr );

      fifo[wr_ptr] = ddr_rq;
      wr_ptr = fifo_ptr_inc(wr_ptr);
    end
    else begin
      $display("%t:%m: attempting to write to fifo but no space left", 
        $time);
      $display("%t: Q.Push :  rd_ptr:%0d; wr_ptr:%0d",
        $time, rd_ptr, wr_ptr );
      $finish();
    end
  end
  endtask

  function bit [31:0] fifo_ptr_inc;
    input bit [31:0]    ptr;
  begin
      fifo_ptr_inc = (ptr==(FIFO_DEPTH-1))? 0: ptr+1;
  end
  endfunction

  function logic fifo_space();
  begin
    fifo_space=  fifo_avail(1);
  end
  endfunction


  //Check is there are num spaces available 
  function logic fifo_avail(bit[15:0] num = 1);
  begin
    fifo_avail=    wr_ptr == rd_ptr      ||
                 ( rd_ptr >  wr_ptr &&
                  (rd_ptr -  wr_ptr >  num)) ||
                 ( wr_ptr >  rd_ptr &&
                  ( FIFO_DEPTH-1 -
                  (wr_ptr -  rd_ptr) >= num)) ;
  end
  endfunction

endmodule

