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
//  Title       :  YUV 2 RGB Converter
//  File        :  hbi_yuv2rgb.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  red = y + f(v)
//  blue = y + f(u)
//  green = y - (f(u) + f(v))
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
`timescale 1ns/10ps

  module hbi_yuv2rgb
    (
     input              hb_clk,       // Host clock
     input [31:0]	hbi_din,      // PCI data
     input [2:0]	mw_dp_mode,   // memory window datapath mode (YUV, etc)
     input [9:0]	lut_v0,       // for red
     input [9:0]	lut_v1,       // for green
     input [9:0]	lut_u0,       // for blue
     input [9:0]	lut_u1,       // for green
     input		ycbcr_sel_n,  //1=yuv, 0=ycbcr
     input              select,       // signal from mw control
     
     output reg [31:0]	pci_data,
     output reg [7:0]	lut_u0_index, // index to uLUT
     output reg [7:0]	lut_v0_index // index to vLUT
     );
  
  reg [10:0] green_uv0;
  reg [10:0] red0, green0, blue0;
  reg [10:0] red1, green1, blue1;
  reg [7:0]  red0_pix, green0_pix, blue0_pix;
  reg [7:0]  red1_pix, green1_pix, blue1_pix;
  reg [31:0] hbi_del;
  reg [2:0]  mw_dp_mode_del;
  reg 	     select_del;
  
  wire [7:0] y0, y1, y2, y3;
  
  // We are delaying the inputs lut_* by one cycle. Now we must delay all
  // associated signals that are needed.
  always @(posedge hb_clk) begin
    hbi_del        <= hbi_din;
    mw_dp_mode_del <= mw_dp_mode;
    select_del     <= select;
  end

  assign y0[7:0] = hbi_del[15:8];
  assign y1[7:0] = hbi_del[31:24];

  /*
   * Map incoming PCI data to y,u,v (or y,Cb,Cr).  Y's are used directly
   * below, U,V form indices to look-up tables.  Also, mux the yuv_lut_index
   * register to the LUTs when in readback mode.
   */
  always @* begin
    // lut indexes
    if (ycbcr_sel_n) begin
      //yuv: ~MSB is tricky way of adding 128
      lut_u0_index = {~hbi_din[7],hbi_din[6:0]};
      lut_v0_index = {~hbi_din[23],hbi_din[22:16]};
    end else begin
      //ycbcr
      lut_u0_index = hbi_din[7:0];
      lut_v0_index = hbi_din[23:16];
    end // else: !if(y_cbcr_sel_n)
  end // always @ (hbi_din or yuv_adr or lut_rdback_en_p or ycbcr_sel_n)
  

  /*
   * common term u+v for green calc
   */
  always @* begin
    green_uv0[10:0] = {lut_u1[9],lut_u1[9:0]} + {lut_v1[9],lut_v1[9:0]};
  end
  
  // Create Pixel 0
  always @* begin
    // convert to rgb and round in one step
    red0[10:0]      = {y0[7:0],1'b1} + {lut_v0[9],lut_v0[9:0]};
    blue0[10:0]     = {y0[7:0],1'b1} + {lut_u0[9],lut_u0[9:0]};
    green0[10:0]    = {y0[7:0],1'b1} - {green_uv0[10],green_uv0[10:1]};

    // rgb data is in bits [8:1], fix overflows, underflows
    case (red0[10:9])
      2'b00: // no overflow/underflow
	red0_pix = red0[8:1];
      2'b01: // overflow
	red0_pix = 8'hff;
      2'b10, 2'b11: // underflow
	red0_pix = 8'h0;
    endcase // case (red0[10:9])
    
    case (green0[10:9])
      2'b00: // no overflow/underflow
	green0_pix = green0[8:1];
      2'b01: // overflow
	green0_pix = 8'hff;
      2'b10, 2'b11: // underflow
	green0_pix = 8'h0;
    endcase // case (green0[10:9])

    case (blue0[10:9])
      2'b00: // no overflow/underflow
	blue0_pix = blue0[8:1];
      2'b01: // overflow
	blue0_pix = 8'hff;
      2'b10, 2'b11: // underflow
	blue0_pix = 8'h0;
    endcase // case (blue0[10:9])

  end // always @ (y0, lut_v0, lut_v1, lut_u0, lut_u1)
  
  // Create Pixel 1
  always @* begin
    // convert to rgb and round in one step
    red1[10:0]      = {y1[7:0],1'b1} + {lut_v0[9],lut_v0[9:0]};
    blue1[10:0]     = {y1[7:0],1'b1} + {lut_u0[9],lut_u0[9:0]};
    green1[10:0]    = {y1[7:0],1'b1} - {green_uv0[10],green_uv0[10:1]};

    // rgb data is in bits [8:1], fix overflows, underflows
    case (red1[10:9])
      2'b00: // no overflow/underflow
	red1_pix = red1[8:1];
      2'b01: // overflow
	red1_pix = 8'hff;
      2'b10, 2'b11: // underflow
	red1_pix = 8'h0;
    endcase // case (red1[10:9])

    case (green1[10:9])
      2'b00: // no overflow/underflow
	green1_pix = green1[8:1];
      2'b01: // overflow
	green1_pix = 8'hff;
      2'b10, 2'b11: // underflow
	green1_pix = 8'h0;
    endcase // case (green1[10:9])

    case (blue1[10:9])
      2'b00: // no overflow/underflow
	blue1_pix = blue1[8:1];
      2'b01: // overflow
	blue1_pix = 8'hff;
      2'b10, 2'b11: // underflow
	blue1_pix = 8'h0;
    endcase // case (blue1[10:9])

  end // always @ (y1, lut_v0, lut_v1, lut_u0, lut_u1)

  // Output data formatter: Put data on the appropriate bits, depending on data
  // path mode.
  always @* begin
    casex ({mw_dp_mode_del, select_del}) // synopsys parallel_case
      4'b001x: // YUV_422_16_555
	pci_data = {1'b0,red1_pix[7:3],green1_pix[7:3],blue1_pix[7:3],
		    1'b0,red0_pix[7:3],green0_pix[7:3],blue0_pix[7:3]};
      4'b010x: // YUV_422_16_565
	pci_data = {red1_pix[7:3],green1_pix[7:2],blue1_pix[7:3],
		    red0_pix[7:3],green0_pix[7:2],blue0_pix[7:3]};
      4'b0110: // YUV_422_32
	pci_data = {8'h0, red0_pix, green0_pix, blue0_pix};
      4'b0111: // YUV_422_32
	pci_data = {8'h0, red1_pix, green1_pix, blue1_pix};
      4'b100x: // YUV_444_16_555
	pci_data = {2{1'b0,red0_pix[7:3],green0_pix[7:3],blue0_pix[7:3]}};
      4'b101x: // YUV_444_16_565
	pci_data = {2{red0_pix[7:3],green0_pix[7:2],blue0_pix[7:3]}};
      4'b110x: // YUV_444_32
	pci_data = {8'h0, red0_pix, green0_pix, blue0_pix};
      default:  // direct linear
	pci_data = hbi_del;
    endcase // case (mw_dp_mode)
  end // always @ (hbi_din or red0_pix or green0_pix or blue0_pix or red1_pix...
endmodule // HBI_YUV2RGB

