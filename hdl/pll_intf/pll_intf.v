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
//  Title       :  External PLL Interface.
//  File        :  pll_intf.v
//  Author      :  Jim Macleod
//  Created     :  30-Dec-2005
//  RCS File    :  $Source: 
//  Status      :  $Id: 
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//
//
//
/////////////////////////////////////////////////////////////////////////////////
//  Modules Instantiated:
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
 
`timescale 1 ns / 10 ps

module pll_intf
(
	input	      	hclk,
	input	      	hresetn,
	input		p_update,
	input	[23:0]	pll_params,
	input		m66_en,
	input		alt_pll_lock,

	output reg	      sclk,
	output reg	      sdat,
	output reg	      sdat_oe,
	output reg	      sclk_oe,
	output reg	      shift_done,
	output reg	      ext_pll_locked
	);
  
  // Power on reset register size.
  `define POR_SIZE 8

  parameter	dev_adr           	= 7'h69,
		low			= 3'b0_00,
		high			= 3'b0_01,
		sdata			= 3'b0_10,
		tri_state		= 3'b1_01,
		p_start_0	= 6'h0,
		p_start_1	= 6'h1,
		p_start_2	= 6'h2,
		p_dat_0_0	= 6'h3,
		p_dat_0_1	= 6'h4,
		p_dat_0_2	= 6'h5,
		p_dat_1_0	= 6'h6,
		p_dat_1_1	= 6'h7,
		p_dat_1_2	= 6'h8,
		p_dat_2_0	= 6'h9,
		p_dat_2_1	= 6'ha,
		p_dat_2_2	= 6'hb,
		p_dat_3_0	= 6'hc,
		p_dat_3_1	= 6'hd,
		p_dat_3_2	= 6'he,
		p_dat_4_0	= 6'hf,
		p_dat_4_1	= 6'h10,
		p_dat_4_2	= 6'h11,
		p_dat_5_0	= 6'h12,
		p_dat_5_1	= 6'h13,
		p_dat_5_2	= 6'h14,
		p_dat_6_0	= 6'h15,
		p_dat_6_1	= 6'h16,
		p_dat_6_2	= 6'h17,
		p_dat_7_0	= 6'h18,
		p_dat_7_1	= 6'h19,
		p_dat_7_2	= 6'h1a,
		p_ack_0		= 6'h1b,
		p_ack_1		= 6'h1c,
		p_ack_2		= 6'h1d,
		p_stop_0	= 6'h1e,
		p_stop_1	= 6'h1f,
		p_stop_2	= 6'h20;

/////////////////////////////////////////////////////////////////////////////////////
//
// The formula is:
// 	Fpll = Freq x (PT/QT)
// 	Where
// 	PT = (2 x (P + 3)) + PO
// 	And
// 	QT = Q + 2
// 	We have post scaler = 1/2
// 	
parameter
// MEM_P=10'h00D, MEM_Q=8'h01, MEM_LF=3'b010, MEM_P0=1'b0, MEM_POST=7'h4 // 100MHz.
// MEM_P=10'h013, MEM_Q=8'h03, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h3 // 110MHz.
// MEM_P=10'h014, MEM_Q=8'h03, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h3 // 115MHz.
// MEM_P=10'h015, MEM_Q=8'h03, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h3 // 120MHz.
// MEM_P=10'h007, MEM_Q=8'h00, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h3 // 125MHz.
// MEM_P=10'h017, MEM_Q=8'h03, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h3 // 130MHz.
// MEM_P=10'h082, MEM_Q=8'h17, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h3 // 133MHz.
MEM_P=10'h00F, MEM_Q=8'h03, MEM_LF=3'b010, MEM_P0=1'b0, MEM_POST=7'h2 // 135MHz.
// MEM_P=10'h035, MEM_Q=8'h0D, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 140MHz.
// MEM_P=10'h11B, MEM_Q=8'h49, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 143MHz.
// MEM_P=10'h037, MEM_Q=8'h0D, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 145MHz.
// MEM_P=10'h005, MEM_Q=8'h00, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 150MHz.
// MEM_P=10'h03B, MEM_Q=8'h0D, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 155MHz.
// MEM_P=10'h03D, MEM_Q=8'h0D, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 160MHz.
// MEM_P=10'h149, MEM_Q=8'h19, MEM_LF=3'b100, MEM_P0=1'b0, MEM_POST=7'h2 // 166MHz.
 ;
/////////////////////////////////////////////////////////////////////////////////////

reg [11:0] 		clkcnt;
reg [2:0]		write_phase;
reg [5:0] 	      	p_cstate;
reg [7:0] 	      	shift_count;
reg 		      	load_shifter;
reg 		      	shift_enable;
reg [323:0] 	      	p_shifter; 
reg [2:0] 	      	sdat_sel;
reg			sclk_a;
reg			sclk_en;
  
wire		p0;
wire	[3:0]	preg;
wire	[9:0]	mreg;
wire	[8:0]	nreg;

reg	[`POR_SIZE-1:0]	por_reg;
reg	[18:0]		pll_counter;
reg			po_reset;
reg 			reset_flag;
reg 			reset_flag_1;
reg 			reset_update;
reg 			por_flag;
reg 			clr_por;
reg			alt_pll_lock_sync;
reg			alt_pll_lock_3;
reg			alt_pll_lock_2;
reg			alt_pll_lock_1;

assign {p0, preg, mreg, nreg} = pll_params;

wire [2:0] LF = (mreg > 1043) ? 3'b100 :
	        (mreg > 834)  ? 3'b011 :
	        (mreg > 626)  ? 3'b010 :
	        (mreg > 231)  ? 3'b001 : 3'b000;

//////////////////////////////////////////////////////////////////////////
// Syncronize the lock signal from the altera PLL
// This provides lock time for back door programing of
// the external PLL.
// Detects the ALT_PLL loss of lock.
// 
always @(posedge hclk)
        begin
                alt_pll_lock_sync <= alt_pll_lock_3 & ~alt_pll_lock_2;
                alt_pll_lock_3 <= alt_pll_lock_2;
                alt_pll_lock_2 <= alt_pll_lock_1;
                alt_pll_lock_1 <= alt_pll_lock;
        end

//////////////////////////////////////////////////////////////////////////
// 
// 
// 
// 
// 
always @(posedge hclk or negedge hresetn)
        begin
                if(!hresetn) pll_counter <= 19'h50000;
                else if(shift_done) pll_counter <= 19'h50000;
                else if(alt_pll_lock_sync) pll_counter <= 19'h50000;
		else if(|pll_counter) pll_counter <= pll_counter - 19'h1;
        end

always @(posedge hclk or negedge hresetn)
        begin
                if(!hresetn) ext_pll_locked <= 1'b0;
		else if(p_update | reset_update | alt_pll_lock_sync) ext_pll_locked <= 1'b0;
		else if(pll_counter == 19'h00001) ext_pll_locked <= 1'b1;
        end

//////////////////////////////////////////////////////////////////////////
//
// Power on Reset.
//
always @(posedge hclk)
        begin
                if(~&por_reg) 
			begin
				por_reg <= por_reg + `POR_SIZE'h1;
                		po_reset <= 1'b1;
			end
		else po_reset <= 1'b0;
        end

//////////////////////////////////////////////////////////////////////////
//
// Generate clk divider
//
always @(posedge hclk)
        begin
                if(|clkcnt & |p_cstate) clkcnt <= clkcnt - 7'h1;
                else if(m66_en)clkcnt <= 7'h38;
                else clkcnt <= 7'h1c;
        end

// generate clock enable signal
wire ena_edge = ~|clkcnt;


always @(posedge hclk)
	begin
		reset_update <= reset_flag_1 & ~reset_flag;
		reset_flag_1 <= reset_flag;
		reset_flag <= po_reset;

		if(reset_flag_1 & ~reset_flag) por_flag <= 1'b1;
		else if(clr_por) por_flag <= 1'b0;
	end


//////////////////////////////////////////////////////////////////////////
//
// External PLL programing state machine.
//
always @(posedge hclk or negedge hresetn)
	begin
    	if(!hresetn) 
		begin
			p_cstate <= 6'h0;
    			load_shifter <= 1'b0;
    			shift_enable <= 1'b0;
    			sclk_a <= 1'b1;
			shift_count <= 8'h0;
			write_phase <= 3'b0;
			shift_done <= 1'b0;
			sclk_en <= 1'b0;
    			sdat_sel <= tri_state;
			clr_por <= 1'b0;
		end
	else begin
  	load_shifter <= 1'b0;
    	shift_enable <= 1'b0;
	shift_done <= 1'b0;
    	sdat_sel <= sdata;
	sclk_en <= 1'b1;
	clr_por <= 1'b0;
    case(p_cstate)
      p_start_0: 
	begin
    		sclk_a 	 <= 1'b1;
		if(p_update | reset_update)
		begin
			p_cstate <= p_start_1;
			shift_count <= 8'h2;
    			load_shifter <= 1'b1;
		end
		else begin
			p_cstate <= p_start_0;
			sclk_en <= 1'b1;
    			sdat_sel <= tri_state;
		end
	end
      p_start_1: 
		begin
			sclk_a <= 1'b1;
    			sdat_sel <= low;
			if(ena_edge) p_cstate <= p_start_2;
		end
      p_start_2: 
		begin
			sclk_a <= 1'b0;
    			sdat_sel <= low;
			if(ena_edge) p_cstate <= p_dat_0_0;
		end
      p_dat_0_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_0_1; end
      p_dat_0_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_0_2; end
      p_dat_0_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_1_0; shift_enable <= 1'b1; end
      p_dat_1_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_1_1; end
      p_dat_1_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_1_2; end
      p_dat_1_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_2_0; shift_enable <= 1'b1; end
      p_dat_2_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_2_1; end
      p_dat_2_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_2_2; end
      p_dat_2_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_3_0; shift_enable <= 1'b1; end
      p_dat_3_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_3_1; end
      p_dat_3_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_3_2; end
      p_dat_3_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_4_0; shift_enable <= 1'b1; end
      p_dat_4_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_4_1; end
      p_dat_4_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_4_2; end
      p_dat_4_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_5_0; shift_enable <= 1'b1; end
      p_dat_5_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_5_1; end
      p_dat_5_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_5_2; end
      p_dat_5_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_6_0; shift_enable <= 1'b1; end
      p_dat_6_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_6_1; end
      p_dat_6_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_6_2; end
      p_dat_6_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_7_0; shift_enable <= 1'b1; end
      p_dat_7_0: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_dat_7_1; end
      p_dat_7_1: begin sclk_a <= 1'b1; if(ena_edge) p_cstate <= p_dat_7_2; end
      p_dat_7_2: begin sclk_a <= 1'b0; if(ena_edge) p_cstate <= p_ack_0; shift_enable <= 1'b1; end

      p_ack_0: begin 
			sclk_a <= 1'b0; 
    			sdat_sel <= tri_state;
			if(ena_edge) p_cstate <= p_ack_1; 
		end
      p_ack_1: begin 
			sclk_a <= 1'b1; 
    			sdat_sel <= tri_state;
			if(ena_edge) p_cstate <= p_ack_2; 
		end
      p_ack_2: begin 
			sclk_a <= 1'b0; 
    			sdat_sel <= tri_state;
			shift_enable <= 1'b1;
			if(ena_edge && (|shift_count)) 
				begin
					p_cstate <= p_dat_0_0; 
					shift_count <= shift_count - 8'h1;
				end
			else if(ena_edge) p_cstate <= p_stop_0; 
		end

      p_stop_0: begin 
			sclk_a <= 1'b0; 
    			sdat_sel <= low;
			if(ena_edge) p_cstate <= p_stop_1; 
		end
      p_stop_1: begin 
			sclk_a <= 1'b1; 
    			sdat_sel <= low;
			if(ena_edge) p_cstate <= p_stop_2; 
		end
      p_stop_2: begin 
			sclk_a <= 1'b1; 
    			sdat_sel <= high;
			casex({por_flag, ena_edge, write_phase})
			5'bx_1_000:
			begin
				shift_count <= 8'h2;
				p_cstate <= p_start_1; 
				write_phase <= 3'b001;
			end
			5'bx_1_001:
			begin
				shift_count <= 8'h5;
				p_cstate <= p_start_1; 
				write_phase <= 3'b010;
			end
			5'bx_1_010:
			begin
				shift_count <= 8'h08;
				p_cstate <= p_start_1; 
				write_phase <= 3'b011;
			end
			5'b1_1_011:
			begin
				shift_count <= 8'h2;
				p_cstate <= p_start_1; 
				write_phase <= 3'b100;
			end
			5'b1_1_100:
			begin
				shift_count <= 8'h6;
				p_cstate <= p_start_1; 
				write_phase <= 3'b101;
			end
			5'b1_1_101:
			begin
				shift_count <= 8'h4;
				p_cstate <= p_start_1; 
				write_phase <= 3'b110;
			end
			5'b1_1_110, 5'b0_1_011:
				begin
					p_cstate <= p_start_0; 
					write_phase <= 3'b000;
					shift_done <= 1'b1;
					clr_por <= 1'b1;
				end
			default: p_cstate <= p_stop_2; 
			endcase
		end
	default:begin
			p_cstate <= 6'h0;
    			load_shifter <= 1'b0;
    			shift_enable <= 1'b0;
    			sclk_a <= 1'b1;
			shift_count <= 8'h0;
			write_phase <= 5'b1;
			shift_done <= 1'b0;
    			sdat_sel <= high;
			clr_por <= 1'b0;
		end

    endcase
  end
  end

always @(posedge hclk or negedge hresetn) begin
    if(!hresetn) begin
      p_shifter	   <= 324'h0;
    end else if(load_shifter) begin
      // Turn off PLL Number 2 (write_phase 0).
      p_shifter[323:317] 	<= dev_adr; 			// Device Address 7'h69.
      p_shifter[316] 		<= 1'b0; 			// R/W, 0 = write.
      p_shifter[315] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[314:307] 	<= 8'h13; 			// Start Address(0x13).
      p_shifter[306] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[305:298] 	<= 8'h00;			// {1'b0, PLL2_En, PLL2_LF[2:0], PLL2_PO, PLL2_P[9:8]}
      p_shifter[297] 		<= 1'bz; 			// Ack bit from Slave.
      // Turn off PLL Number 3 (write_phase 1).
      p_shifter[296:290] 	<= dev_adr; 			// Device Address 7'h69.
      p_shifter[289] 		<= 1'b0; 			// R/W, 0 = write.
      p_shifter[288] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[287:280] 	<= 8'h16; 			// Start Address(0x16).
      p_shifter[279] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[278:271] 	<= 8'h00;			// {1'b0, PLL2_En, PLL2_LF[2:0], PLL2_PO, PLL2_P[9:8]}
      p_shifter[270] 		<= 1'bz; 			// Ack bit from Slave.
      // Program PLL 2 and 3 (write_phase 2).
      p_shifter[269:263] 	<= dev_adr; 			// Device Address 7'h69.
      p_shifter[262] 		<= 1'b0; 			// R/W, 0 = write.
      p_shifter[261] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[260:253] 	<= 8'h08; 			// Start Address.
      p_shifter[252] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x08 CLKA
      p_shifter[251:244] 	<= {4'h0, preg};		// Pixel Clock Zero Post Scaler.
      p_shifter[243] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x09 CLKA
      p_shifter[242:235] 	<= {4'h0, preg};		// Pixel Clock Zero Post Scaler.
      p_shifter[234] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x0A CLKB
      p_shifter[233:226] 	<= 8'h1;			// VGA Clock Zero Post Scaler.
      p_shifter[225] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x0B CLKB
      p_shifter[224:217] 	<= 8'h1;			// VGA Clock Post Scaler.
      p_shifter[216] 		<= 1'bz; 			// Ack bit from Slave.
      // Program PLL 2 and 3 (write_phase 3).
      p_shifter[215:209] 	<= dev_adr; 			// Device Address 7'h69.
      p_shifter[208] 		<= 1'b0; 			// R/W, 0 = write.
      p_shifter[207] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[206:199] 	<= 8'h11; 			// Start Address.
      p_shifter[198] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x11
      p_shifter[197:190] 	<= 8'h3;		// PLL 2 Q, VGA CLock Pre Scale N
      p_shifter[189] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x12
      p_shifter[188:181] 	<= 8'h1;		// PLL 2 P, VGA CLock Mult M
      p_shifter[180] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x13
      p_shifter[179:172] 	<= 8'h40;		// {1'b0, PLL2_En, PLL2_LF[2:0], PLL2_PO, PLL2_P[9:8]}
      p_shifter[171] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x14
      p_shifter[170:163] 	<= nreg[7:0];		// PLL 3 Q, Pix/CRT One CLock Pre Scale N
      p_shifter[162] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x15
      p_shifter[161:154] 	<= mreg[7:0];		// PLL 3 P, Pix/CRT One CLock Mult M
      p_shifter[153] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x16
      p_shifter[152:145] 	<= {2'h1, LF, p0, mreg[9:8]};	// {1'b0, PLL3_En, PLL3_LF[2:0], PLL3_PO, PLL3_P[9:8]}
      p_shifter[144] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x17
      // p_shifter[143:136] 	<= 8'b000000_10;		// {OscCap[5:0], OscDrv[1:0]}
      p_shifter[143:136] 	<= 8'b000000_00;		// {OscCap[5:0], OscDrv[1:0]}
      p_shifter[135] 		<= 1'bz; 		// Ack bit from Slave.
      /////////////////////////////////////////////////////////////////////////////////
      //
      //	The remainder of the parameters only get programmed on POR.
      //
      // Turn off PLL Number 1 (write_phase 4).
      p_shifter[134:128] 	<= dev_adr; 			// Device Address.
      p_shifter[127] 		<= 1'b0; 			// R/W, 0 = write.
      p_shifter[126] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[125:118] 	<= 8'h4B; 			// Start Address.
      p_shifter[117] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[116:109] 	<= {1'b0, 1'b1, 6'h0};		// {1'b0, PLL1_En, PLL1_LF[2:0], PLL1_PO, PLL1_P[9:8]}
      p_shifter[108] 		<= 1'bz; 			// Ack bit from Slave.
      // Turn off PLL Number 1 (write_phase 5).
      p_shifter[107:101] 	<= dev_adr; 			// Device Address.
      p_shifter[100] 		<= 1'b0; 			// R/W, 0 = write.
      p_shifter[99] 		<= 1'bz; 			// Ack bit from Slave.
      p_shifter[98:91] 		<= 8'h0C; 			// Start Address.
      p_shifter[90] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x0C CLKC
      p_shifter[89:82] 		<= {1'b0, MEM_POST};		// Memory Clock Post Scaler.
      p_shifter[81] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x0D CLKD
      p_shifter[80:73] 		<= 8'h0;			// Not Used, zero turns off the output.
      p_shifter[72] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x0E CLKD, CLKC, CLKB, CLKA
      p_shifter[71:64] 		<= 8'b00_01_10_11;		// {ClkD_FS[2:1], ClkC_FS[2:1],  ClkB_FS[2:1], ClkA_FS[2:1]} 
      p_shifter[63] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x0F
      p_shifter[62:55] 	<= 8'b01_01_0_1_00;		// Clk(C,X) AC Adj, Clk(A,B,D,E) AC Adj, PdnEn, Xbuf OE, ClkE Div. 
      p_shifter[54] 		<= 1'bz; 			// Ack bit from Slave.
      // 0x10
      p_shifter[53:46] 		<= 8'b01_01_01_01;		// Clk(X) DC Adj, Clk(D,E) DC Adj, CLk(C) DC Adj, Clk(A,B) DC Adj.
      p_shifter[45] 		<= 1'bz; 			// Ack bit from Slave.
      // Program PLL 1 (write_phase 6).
      p_shifter[044:038] 	<= dev_adr; 		// Device Address.
      p_shifter[037] 		<= 1'b0; 		// R/W, 0 = write.
      p_shifter[036] 		<= 1'bz; 		// Ack bit from Slave.
      p_shifter[035:028] 	<= 8'h49; 		// Start Address.
      p_shifter[027] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x49
      p_shifter[026:019] 	<= MEM_Q;		// PLL 1 Q, MC CLock Pre Scale N
      p_shifter[018] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x4A
      p_shifter[017:010] 	<= MEM_P[7:0];		// PLL 1 P, MC Zero CLock Mult M
      p_shifter[009] 		<= 1'bz; 		// Ack bit from Slave.
      // 0x4B
      // {1'b0, PLL1_En, PLL1_LF[2:0], PLL1_PO, PLL1_P[9:8]}
      p_shifter[008:001] 	<= {1'b0, 1'b1, MEM_LF, MEM_P0, MEM_P[9:8]};
      // p_shifter[008:001] 	<= {1'b0, 1'b1, 3'b000, 1'b0, 2'b00};	// {1'b0, PLL1_En, PLL1_LF[2:0], PLL1_PO, PLL1_P[9:8]}
      p_shifter[000] 		<= 1'bz; 		// Ack bit from Slave.
    end
    else if(shift_enable & ena_edge) p_shifter <= p_shifter << 1;
  end
  



always @(posedge hclk)
	begin
		sdat <= (sdat_sel[1:0] == low) ? 1'b0 :
			(sdat_sel[1:0] == high) ? 1'b1 : p_shifter[323];
		sclk <= sclk_a;
		sdat_oe <= ~sdat_sel[2];
		sclk_oe <= sclk_en;
	end

endmodule

