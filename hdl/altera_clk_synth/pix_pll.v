///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2005
//  This File is based upon: pix_pll.v
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Universal Avionics for use in FPGA development specifically for add-in
//  boards. Any other use of this source code must be discussed with Silicon
//  Spectrum and this copyright notice must be maintained.
//  Silicon Spectrum does not give up the copyright to the original file or
//  encumber in any way it's use except where related to Curtis Wright add-in
//  board business for the period set out in the original agreement.
//
//  Title       :  RAMDAC Pixel PLL Control.
//  File        :  pix_pll.v
//  Author      :  Jim Macleod
//  Created     :  07-Feb-2012
//  RCS File    :  $Source:$
//  Status      :  $Id:$
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
//  $Log:$
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
 
`timescale 1 ns / 10 ps

  module pix_pll
    (
     input	      hclk,
     input	      hresetn,
     input [2:0]      pixclksel, 	/* 001= comp-ext,  100 = std-ext
					 * 011= comp-int,  101 = std-int */
     input [1:0]      int_fs,
     input	      ext_fs,
     input [7:0]      pixreg20,
     input [7:0]      pixreg21,
     input [7:0]      pixreg22,
     input [7:0]      pixreg23,
     input [7:0]      pixreg24,
     input [7:0]      pixreg25,
     input [7:0]      pixreg26,
     input [7:0]      pixreg27,
     input            busy,
     
     output reg [6:0] mreg_temp,
     output reg [5:0] nreg_temp,
     output reg [2:0] preg,
     output reg	      sync_ext,
     output reg	      write_param,
     output reg [3:0] counter_type,
     output reg [2:0] counter_param,
     output reg [8:0] data_in,
     output reg       reconfig
     );
  

  reg 		      sync_ext0;
  reg 		      sync_reset, sync_reset0;
  reg [1:0] 	      dfreg;
  reg 		      update_0, update_1;
  reg [21:0] 	      current_pll;   // Current values PLL loaded with
  reg 		      hold_next_update;
  reg 		      shift_done;
  reg	[4:0]	      param_sel;

  `ifdef RTL_ENUM
  enum {
	SETUP		= 3'h0,
	WRITE		= 3'h1,
	WAIT		= 3'h2,
	HOLD		= 3'h3,
	WAIT_HOLD	= 3'h4,
	UPDATE_PLL	= 3'h5,
	WAIT_UPDATE	= 3'h6,
	WAIT_DONE	= 3'h7
  	} cstate;
  `else
  parameter
	SETUP		= 3'h0,
	WRITE		= 3'h1,
	WAIT		= 3'h2,
	HOLD		= 3'h3,
	WAIT_HOLD	= 3'h4,
	UPDATE_PLL	= 3'h5,
	WAIT_UPDATE	= 3'h6,
	WAIT_DONE	= 3'h7;
  reg [2:0]	      cstate;
  `endif
  
  // register mapping:
  //(1) In ext. comp mode M0=20, N0=21, M1=22, N2=23,
  //(2) In int. comp mode M0=20, N0=21, M1=22, N2=23, M2=24  N2=25, M3=26, N3=27,
  //(3) In ext. std  mode M0=20, N0=21, P0=22, C0=23, M1=24, N1=25, P1=26, C1=27,
  //(4) In int. std  mode M0=20, N0=21, P0=22, C0=23, M1=24, N1=25, P1=26, C1=27,
  //In comp mode, if df=00, p=8, if df=01, p=4, if df=10, p=2, if df=11, p=1,
  //In comp mode, c= 0;
  wire 		      update_pll;
  wire [8:0] 	      nreg_int;
  reg [8:0] 	      nreg_int1;
  wire [8:0] 	      nreg;
  reg [9:0] 	      mreg;
  wire [9:0] 	      mreg_int;
  wire [21:0] 	      new_pll;
  wire [9:0] 	      new_p;
  
  // We will update the PLL when the current PLL values are not equal to the
  // Values that the PLL is currently using. This is slightly different before,
  // but it ensures that the PLL will always end up with the current value,
  // even if programmed w/ new values concurrently
  assign 	      new_pll = {preg, mreg_temp, nreg_temp};
  assign 	      update_pll = (current_pll != new_pll);

  
  always @(posedge hclk or negedge hresetn)
    if (!hresetn) begin
      hold_next_update <= 1'b0;
      sync_ext0        <= 1'b0;
      sync_ext         <= 1'b0;
      sync_reset0      <= 1'b0;
      sync_reset       <= 1'b0; 
      current_pll      <= new_pll;
   end else begin
     // From VGA, synchronize
     sync_ext0 <= ext_fs;
     sync_ext  <= sync_ext0;
     // From pll_intf.
     //
     sync_reset0 <= shift_done;
     sync_reset  <= sync_reset0;
      if (hold_next_update) hold_next_update <= ~(sync_reset & ~sync_reset0);
      else if (update_pll) begin
	current_pll <= {preg, mreg_temp, nreg_temp};
	hold_next_update <= 1'b1;
      end
    end
  
  always @* begin
  // always @(posedge hclk) begin
    casex({sync_ext, int_fs, pixclksel})
      // Mode 1, compatibility mode external FS.
      6'b0_xx_001: mreg_temp[6:0] <= {1'b1, pixreg20[5:0]};  // add 65 in comp
      6'b1_xx_001: mreg_temp[6:0] <= {1'b1, pixreg22[5:0]};  // mode.
      // Mode 2, compatibility mode internal FS.
      6'bx_00_011: mreg_temp[6:0] <= {1'b1, pixreg20[5:0]};
      6'bx_01_011: mreg_temp[6:0] <= {1'b1, pixreg22[5:0]};
      6'bx_10_011: mreg_temp[6:0] <= {1'b1, pixreg24[5:0]};
      6'bx_11_011: mreg_temp[6:0] <= {1'b1, pixreg26[5:0]};
      // Mode 3, standard mode external FS.
      6'b0_xx_100: mreg_temp[6:0] <=  pixreg20[6:0] + 7'h1;
      6'b1_xx_100: mreg_temp[6:0] <=  pixreg24[6:0] + 7'h1;
      // Mode 4, standard mode internal FS.
      6'bx_x0_101: mreg_temp[6:0] <=  pixreg20[6:0] + 7'h1;
      default:     mreg_temp[6:0] <=  pixreg24[6:0] + 7'h1;
    endcase
  end
  
  always @* begin
  // always @(posedge hclk) begin
    casex({sync_ext, int_fs, pixclksel})
      // Mode 1, compatibility external FS.
      6'b0_xx_001: dfreg[1:0] <=  pixreg20[7:6] ;
      6'b1_xx_001: dfreg[1:0] <=  pixreg22[7:6] ;
      // Mode 2, compatibility internal FS.
      6'bx_00_011: dfreg[1:0] <=  pixreg20[7:6] ;
      6'bx_01_011: dfreg[1:0] <=  pixreg22[7:6] ;
      6'bx_10_011: dfreg[1:0] <=  pixreg24[7:6] ;
      default:     dfreg[1:0] <=  pixreg26[7:6] ;
    endcase
  end
  
  always @* begin
  // always @(posedge hclk) begin
    casex({dfreg, sync_ext, int_fs, pixclksel})
      // Mode 1, compatibility external FS.
      8'b11_0_xx_001: nreg_temp[5:0] <= {1'b0, pixreg21[4:0]};
      8'b10_0_xx_001: nreg_temp[5:0] <= { pixreg21[4:0], 1'b0}; // x2 in comp
      8'b01_0_xx_001: nreg_temp[5:0] <= { pixreg21[4:0], 1'b0}; // mode
      8'b00_0_xx_001: nreg_temp[5:0] <= { pixreg21[4:0], 1'b0};
      8'b11_1_xx_001: nreg_temp[5:0] <= {1'b0, pixreg23[4:0]};
      8'b10_1_xx_001: nreg_temp[5:0] <= { pixreg23[4:0], 1'b0}; // x2 in comp
      8'b01_1_xx_001: nreg_temp[5:0] <= { pixreg23[4:0], 1'b0}; // mode
      8'b00_1_xx_001: nreg_temp[5:0] <= { pixreg23[4:0], 1'b0};
      // Mode 2, compatibility internal FS.
      8'b11_x_00_011: nreg_temp[5:0] <= {1'b0, pixreg21[4:0]};
      8'b10_x_00_011: nreg_temp[5:0] <= { pixreg21[4:0], 1'b0}; // x2 in comp
      8'b01_x_00_011: nreg_temp[5:0] <= { pixreg21[4:0], 1'b0}; // mode
      8'b00_x_00_011: nreg_temp[5:0] <= { pixreg21[4:0], 1'b0};
      8'b11_x_01_011: nreg_temp[5:0] <= {1'b0, pixreg23[4:0]};
      8'b10_x_01_011: nreg_temp[5:0] <= { pixreg23[4:0], 1'b0}; // x2 in comp
      8'b01_x_01_011: nreg_temp[5:0] <= { pixreg23[4:0], 1'b0}; // mode
      8'b00_x_01_011: nreg_temp[5:0] <= { pixreg23[4:0], 1'b0};
      8'b11_x_10_011: nreg_temp[5:0] <= {1'b0, pixreg25[4:0]};
      8'b10_x_10_011: nreg_temp[5:0] <= { pixreg25[4:0], 1'b0}; // x2 in comp
      8'b01_x_10_011: nreg_temp[5:0] <= { pixreg25[4:0], 1'b0}; // mode
      8'b00_x_10_011: nreg_temp[5:0] <= { pixreg25[4:0], 1'b0};
      8'b11_x_11_011: nreg_temp[5:0] <= {1'b0, pixreg27[4:0]};  // x1
      8'b10_x_11_011: nreg_temp[5:0] <= { pixreg27[4:0], 1'b0}; // x2 in comp
      8'b01_x_11_011: nreg_temp[5:0] <= { pixreg27[4:0], 1'b0}; // mode
      8'b00_x_11_011: nreg_temp[5:0] <= { pixreg27[4:0], 1'b0};
      // Mode 3, standard external FS.
      8'bxx_0_xx_100: nreg_temp[5:0] <=  pixreg21[5:0] + 6'h1; 
      8'bxx_1_xx_100: nreg_temp[5:0] <=  pixreg25[5:0] + 6'h1; 
      // Mode 4, standard internal FS.
      8'bxx_x_x0_101: nreg_temp[5:0] <=  pixreg21[5:0] + 6'h1;
      default:        nreg_temp[5:0] <=  pixreg25[5:0] + 6'h1;
    endcase
  end

  // If we are in normal vga mode, the pixclk runs at 1/2 the vga clock.
  // this allows us to pack 2 pixels in to the pipe. If we are not in normal
  // vga mode, then we are zooming. Then we will replicate pixels, so run
  // at the same speed
  always @* begin
  // always @(posedge hclk) begin
    casex({dfreg, sync_ext, int_fs, pixclksel})
      // Mode 1
      8'b00_x_xx_001: preg[2:0] <= 3'b010;    // divide by 4
      8'b01_x_xx_001: preg[2:0] <= 3'b001;    // divide by 2
      8'b10_x_xx_001: preg[2:0] <= 3'b000;    // divide by 1
      8'b11_x_xx_001: preg[2:0] <= 3'b000;    // divide by 1
      // Mode 2
      8'b00_x_xx_011: preg[2:0] <= 3'b010;    // divide by 4
      8'b01_x_xx_011: preg[2:0] <= 3'b001;    // divide by 2
      8'b10_x_xx_011: preg[2:0] <= 3'b000;    // divide by 1
      8'b11_x_xx_011: preg[2:0] <= 3'b000;    // divide by 1
      // Mode 3
      8'bxx_0_xx_100: preg[2:0] <= pixreg22[2:0];
      8'bxx_1_xx_100: preg[2:0] <= pixreg26[2:0];
      // Mode 4
      8'bxx_x_x0_101: preg[2:0] <= pixreg22[2:0];
      default:        preg[2:0] <= pixreg26[2:0];
    endcase
  end

  always @* begin
	  case(param_sel)
		  // N Counters.
		  4'h0: begin counter_type = 4'b0000; counter_param = 3'h4; data_in = {8'h0, (~|nreg_temp[5:1] & nreg_temp[0])}; end
		  4'h1: begin counter_type = 4'b0000; counter_param = 3'h5; data_in = {8'h0, nreg_temp[0]}; end
		  4'h2: begin counter_type = 4'b0000; counter_param = 3'h7; data_in = {3'h0, nreg_temp}; end
		  // N Counters.
		  4'h3: begin counter_type = 4'b0001; counter_param = 3'h4; data_in = {8'h0, (~|mreg_temp[6:1] & mreg_temp[0])}; end
		  4'h4: begin counter_type = 4'b0001; counter_param = 3'h5; data_in = {8'h0, mreg_temp[0]}; end
		  4'h5: begin counter_type = 4'b0001; counter_param = 3'h7; data_in = {2'h0, mreg_temp}; end
		  // CP, LF.
		  4'h6: begin counter_type = 4'b0010; counter_param = 3'h0; data_in = 9'h7; end // LF Current
		  4'h7: begin counter_type = 4'b0010; counter_param = 3'h1; data_in = 9'hf; end // LF Res.
		  4'h8: begin counter_type = 4'b0010; counter_param = 3'h2; data_in = 9'h3; end // LF Cap.
		  // VCO Post Scaler.
		  4'h9: begin counter_type = 4'b0011; counter_param = 3'h0; data_in = 9'h0; end
		  // C0 Counters.
		  4'hA: begin counter_type = 4'b0100; counter_param = 3'h0; data_in = {6'h0, preg}; end
		  4'hB: begin counter_type = 4'b0100; counter_param = 3'h1; data_in = {6'h0, preg}; end
		  4'hC: begin counter_type = 4'b0100; counter_param = 3'h4; data_in = {8'h0, ~|preg}; end
		  4'hD: begin counter_type = 4'b0100; counter_param = 3'h5; data_in = 9'h0; end
		  default: begin counter_type = 4'b0000; counter_param = 3'h4; data_in = 9'h0; end
	  endcase
  end

  // State Machine to load the PLL.
  always @(posedge hclk, negedge hresetn) begin
	  if(!hresetn) begin
		write_param <= 1'b0;
		param_sel   <= 4'h0;
	 	reconfig      <= 1'b0;
		shift_done    <= 1'b0;
		cstate 	      <= SETUP;
	  end
	  else begin
	 	reconfig    <= 1'b0;
		write_param <= 1'b0;
		shift_done  <= 1'b0;
    		case (cstate)
      		SETUP: begin
			if(update_pll) begin
				param_sel <= 4'b0000;
				cstate 	  <= WRITE;
			end
			else cstate <= SETUP;
      		end
      		WRITE: begin
			if(!busy) begin
				write_param <= 1'b1;
				cstate <= WAIT;
			end
			else cstate <= WRITE;
      		end
      		WAIT: cstate <= HOLD;
      		HOLD: begin
			if(!busy & (param_sel == 4'hD)) begin
				cstate <= WAIT_HOLD;
				param_sel <= 4'b0000;
			end
	 		else if(!busy) begin
				param_sel <= param_sel + 4'b0001;
				cstate 	      <= WRITE;
	  		end
			else cstate <= HOLD;
      		end
      		WAIT_HOLD: cstate <= UPDATE_PLL;
      		UPDATE_PLL: begin
			if(!busy) begin
				reconfig  <= 1'b1;
				cstate <= WAIT_UPDATE;
			end
			else cstate <= UPDATE_PLL;
      		end
      		WAIT_UPDATE: cstate <= WAIT_DONE;
      		WAIT_DONE: begin
			if(!busy) begin
				cstate <= SETUP;
				shift_done <= 1'b1;
			end
			else cstate <= WAIT_DONE;
      		end
	endcase
	end
end

endmodule
