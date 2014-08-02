//////////////////////////////////////////////////////////////////////////////
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
//  Title       :  RAMDAC Cursor module
//  File        :  cursor.v
//  Author      :  Jim MacLeod
//  Created     :  29-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
//////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  
// This module  handles the cursor logic and the cursor ram
// 4 ram blocks will be used, each 256x8
//
// Bypass ram_pixel_addr reg, to send address to cursor rams one cycle earlier.
// Add cursor address change detector, which is used to create load_pipe.
// Load pipe is used in ram_ctl block to allow loading of cursor data pipe
// every other cycle.  The effect of these changes is to give the cursor rams
// two cycle, instead of single cycle access.
//
/////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 10 ps

module cursor
  (
   input		pixclk,
   input		reset,
   input		wrn,
   input                rdn,
   input		adcurctl, 
   input                hsync, 
   input                vsync,
   input [7:0]	        cursor1_data, 
   input [7:0]          cursor2_data, 
   input [7:0]          cursor3_data, 
   input [7:0]          cursor4_data,
   input [7:0]          cur1red, 
   input [7:0]          cur1grn, 
   input [7:0]          cur1blu, 
   input [7:0]          cur2red, 
   input [7:0]          cur2grn, 
   input [7:0]          cur2blu, 
   input [7:0]          cur3red,
   input [7:0]          cur3grn, 
   input [7:0]          cur3blu, 
   input [7:0]          curctl, 
   input [7:0]          adcuratt, 
   input [7:0]          curxlow, 
   input [7:0]          curxhi, 
   input [7:0]          curylow,
   input [7:0]          curyhi,
   input [5:0]	        curhotx, 
   input [5:0]          curhoty,
   input [10:0]	        idx_raw,
   
   output reg 		display_cursor,
   output               p0_apply_cursor, 
   output               p0_highlight, 
   output               p0_translucent,
   output [7:0]	        act_curxlow,
   output [7:0]	        act_curxhi,
   output [7:0]	        act_curylow,
   output [7:0]	        act_curyhi,
   output reg [7:0]     p0_red_cursor,
   output reg [7:0]     p0_grn_cursor,
   output reg [7:0]     p0_blu_cursor,
   output [7:0]	        cursor_addr
   );
  
  parameter idle       = 0, 
	    process_x  = 1, 
	    process_y  = 2, 
	    hsync_time = 3, 
	    wait_one   = 4, 
	    finish     = 5;
  
  reg [11:0] ram_pixel_addr ;
  // bypass ram_pixel_addr register, to send address to cursor rams one
  // cycle earlier
  //
  reg [7:0]  ram_address;
  reg [15:0] act_x, act_y;
  reg [15:0] sync0_x_cursor, sync0_y_cursor;
  reg [15:0] x_start, y_start;
  reg [15:0] x_max, y_max;
  reg [15:0] x_cursor, y_cursor;
  reg [5:0]  sync0_x_hot,sync0_y_hot;
  reg [5:0]  x_hot, y_hot;
  reg 	     p0_adv_col0, p0_adv_col1, p0_adv_col2, p0_adv_col3,
	     p0_trans_c0, p0_trans_c1, p0_trans_c2, p0_trans_c3;
  reg        p0_std_col1, p0_std_col2, p0_std_col3, p0_std_high;
  
  reg 	     hsync_d, hsync_d1, hsync_d2;
  reg 	     upd_ctl1 , upd_ctl2, load_cursor_values;
  wire 	     hsync_m3; 
  reg 	     hsync_m4; 
  reg 	     hsync_m5; 
  reg [15:0] applied_cursor_x, applied_cursor_y;
  reg [1:0]  cursor_mode ;
  reg 	     adcurctl1   ;
  reg 	     adcurctl2   ;
  reg 	     adcurctl3   ;
  reg [7:0]  adcuratt1   ;
  reg [7:0]  adcuratt2   ;
  reg [7:0]  adcuratt3   ;
  reg 	     cursor_size ;
  reg [1:0]  cursor_smlc ;
  reg [1:0]  cursor_mode1;
  reg 	     cursor_size1;
  reg [1:0]  cursor_smlc1;
  reg [1:0]  cursor_mode2;
  reg 	     cursor_size2;
  reg [1:0]  cursor_smlc2;
  reg [15:0] x_counter ;
  reg [15:0] y_counter ;
  reg [15:0] pix_counter ;
  reg [15:0] h_counter;
  reg [5:0]  x_offset;
  reg [5:0]  y_offset;
  reg [5:0]  x_adr;
  reg [5:0]  y_adr;
  reg 	     pix_order   ;
  reg 	     pix_order1  ;
  reg 	     pix_order2  ;
  reg 	     wr1 ;       // sync. proc. stuff to pix clk
  reg 	     wr2 ;       //  '' ''
  reg 	     wr3 ;       //
  reg 	     rd1 ;
  reg 	     rd2 ;
  reg 	     rd3 ;
  reg 	     new_location, inc_y, frame_d1, frame_d2, frame_d3;
  reg 	     new_location1;
  reg 	     new_location2;
  reg 	     new_location3;
  reg        display_cursor1;
  reg        display_cursor2;
  reg        display_cursor3;
  reg        display_cursor4;
  reg [7:0]  cursor_index_byte;
  reg [1:0]  cursor_index;
  reg 	     immediate;
  reg 	     p0_high_c0, p0_high_c1, p0_high_c2, p0_high_c3;
  reg		load_pipe;

  wire 	     inc_x;
  wire       display_cursor5;
  
  
  wire 	     wr_pulse = wr2 & !wr3;
  
  reg [15:0] y_max21, y_max11,
	     y_max22, y_max12,
	     y_max23, y_max13,
	     y_max24, y_max14,
	     x_max21, x_max11,
	     x_max22, x_max12,
	     x_max23, x_max13,
	     x_max24, x_max14;
  
  wire 	     newframeu;
  assign     newframeu = vsync & !hsync;

  wire 	     new_2x = new_location2 | hsync_m3;   
  wire 	     new_2y = new_location2 | frame_d2;   

  wire 	     new_3x = new_location3 | hsync_m5; 
  wire 	     new_3y = new_location3 | frame_d3;

  wire 	     y_max_neg = |y_max[15:12];

  wire 	     x_max_neg = |x_max[15:12];

  wire 	     y_neg     = |y_start[15:12];
  
  wire 	     x_neg     = |x_start[15:12];

  wire 	     ap_y_neg = |applied_cursor_y[15:12];

  wire 	     ap_x_neg = |applied_cursor_x[15:12];

  wire [1:0] load_y_max;
  wire [1:0] load_x_max;
  wire [3:0] p0_stand_mode;
  wire [3:0] p0_adv_mode0;
  wire [3:0] p0_adv_mode1;
  wire [3:0] p0_adv_mode2;
  wire [3:0] p0_adv_mode3;
  
  assign     cursor_addr = ram_address;  
  assign     act_curylow  = act_y[7:0];
  assign     act_curyhi   = act_y[15:8]; 
  assign     act_curxlow  = act_x[7:0];
  assign     act_curxhi   = act_x[15:8]; 
  assign     load_y_max = {cursor_size2, ap_y_neg};
  assign     load_x_max = {cursor_size2, ap_x_neg};
  assign     hsync_m3 = hsync_d1 & (~hsync_d2);

  //---------- sync the processor interface to the palette clock
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      new_location1  <=  1'b0;
      new_location2  <=  1'b0;
      new_location3  <=  1'b0;
      hsync_d        <=  1'b0;
      hsync_d1       <=  1'b0;
      hsync_d2       <=  1'b0;
      hsync_m4       <=  1'b0;
      hsync_m5       <=  1'b0;   
      wr1            <=  1'b0;       // sync. proc. stuff to pix clk
      wr2            <=  1'b0;       //  '' ''
      wr3            <=  1'b0;       //
      rd1            <=  1'b0;       // sync. proc. stuff to pix clk
      rd2            <=  1'b0;       //  '' ''
      rd3            <=  1'b0;       //
      upd_ctl1       <=  1'b0;
      upd_ctl2       <=  1'b0;
      sync0_x_cursor <= 16'h0000; // to the clock, address already stable
      sync0_y_cursor <= 16'h0000;
      sync0_x_hot    <=  6'h00;
      sync0_y_hot    <=  6'h00;
      x_hot          <=  6'h00;
      y_hot          <=  6'h00;
      cursor_size    <= 1'b0;
      cursor_size1   <= 1'b0;
      cursor_mode    <= 2'b0;
      cursor_mode1   <= 2'b0;
      cursor_smlc    <= 2'b0;
      cursor_smlc1   <= 2'b0;
      pix_order1     <= 1'b0;
      pix_order      <= 1'b0;
      adcurctl1      <= 1'b0;
      adcurctl2      <= 1'b0;
      adcuratt1      <= 7'b0;
      adcuratt2      <= 7'b0;
      frame_d1  <= 1'b0;
      frame_d2 <= 1'b0;
      frame_d3 <= 1'b0;
      display_cursor1 <= 1'b0;
      display_cursor2 <= 1'b0;
      display_cursor3 <= 1'b0;
      display_cursor4 <= 1'b0;
      display_cursor  <= 1'b0;
      
    end else begin
      display_cursor4 <= display_cursor5 ;
      display_cursor3 <= display_cursor4 ;
      display_cursor2 <= display_cursor3 ;
      display_cursor1 <= display_cursor2 ;
      display_cursor  <= display_cursor1 ;
      hsync_d <= hsync;
      hsync_d1 <= hsync_d;
      hsync_d2 <= hsync_d1;
      hsync_m4 <= hsync_m3;
      hsync_m5 <= hsync_m4; 
      
      wr1 <= wrn;     // sync. proc. stuff to pix clk
      wr2 <= wr1   ;     //  '' ''
      wr3 <= wr2   ;     //
      rd1 <= rdn;     // sync. proc. stuff to pix clk
      rd2 <= rd1   ;     //  '' ''
      rd3 <= rd2   ;     //
      
      sync0_x_cursor <= {curxhi[7:0] , curxlow[7:0]};
      sync0_y_cursor <= {curyhi[7:0] , curylow[7:0]};
      
      sync0_x_hot    <= curhotx;
      sync0_y_hot    <= curhoty;
      x_hot    <= sync0_x_hot;
      y_hot    <= sync0_y_hot;
      cursor_size <= curctl[2];
      cursor_size1 <= cursor_size ;
      cursor_mode <= curctl[1:0];
      cursor_smlc <= curctl[7:6];
      pix_order   <= curctl[5];
      cursor_mode1 <= cursor_mode;
      cursor_smlc1 <= cursor_smlc;
      pix_order1   <= pix_order;
      upd_ctl1 <=curctl[3];
      upd_ctl2 <=upd_ctl1 ;
      new_location1  <= ((new_location & immediate) | newframeu)  ; 
      new_location2  <= new_location1 ;
      new_location3  <= new_location2 ;
      adcurctl1      <= adcurctl ;
      adcurctl2      <= adcurctl1;
      adcuratt1      <= adcuratt ;
      adcuratt2      <= adcuratt1;
      frame_d1 <= newframeu;
      frame_d2 <=  frame_d1;
      frame_d3 <=  frame_d2;
    end
  end
  
  //------------------------- sample cursor controls during vblank---------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      immediate    <= 1'b0;
      cursor_mode2 <= 2'b0;
      cursor_smlc2 <= 2'b0;
      pix_order2   <= 1'b0;
      adcuratt3    <= 7'b0;
      adcurctl3    <= 1'b0;
      cursor_size2 <= 1'b0;
    end else if (vsync == 1) begin   // update immediate
      immediate    <= upd_ctl2;
      cursor_mode2 <= cursor_mode1;
      cursor_size2 <= cursor_size1;
      cursor_smlc2 <= cursor_smlc1;
      pix_order2   <= pix_order1;
      adcuratt3    <= adcuratt2;
      adcurctl3    <= adcurctl2;
    end
  end

  //---------------------------------------------------------
  wire curxl, curxh, curyl, curyh;
  assign curxl = (idx_raw == 11'h031);
  assign curxh = (idx_raw == 11'h032);
  assign curyl = (idx_raw == 11'h033);
  assign curyh = (idx_raw == 11'h034);
  
  //-------- Detect writing the Cursor Y high register------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      new_location   <= 1'b0;
      x_cursor       <= 16'h0000;
      y_cursor       <= 16'h0000;
    end else if (new_location & (immediate | newframeu)) begin
      new_location <= 1'b0;     // t
      x_cursor     <= x_cursor;
      y_cursor     <= y_cursor;
    end else if (immediate & wr_pulse & (curxl | curxh | curyl | curyh)) begin
      new_location <= 1'b1;     // set
      x_cursor     <= sync0_x_cursor;
      y_cursor     <= sync0_y_cursor;
    end else if (wr_pulse & curyh) begin
      new_location <= 1'b1;     // set
      x_cursor <= sync0_x_cursor;
      y_cursor <= sync0_y_cursor;
    end
  end                           // or at vsync time

  //------------ generate the programmed cursor to be applied--------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      load_cursor_values <= 1'b0;
      applied_cursor_x <= 16'h0000;
      applied_cursor_y <= 16'h0000; 
    end else if (new_location & (immediate | (vsync & hsync))) begin
      load_cursor_values <= 1'b1;
      applied_cursor_x <= x_cursor;
      applied_cursor_y <= y_cursor;
    end else begin
      load_cursor_values <= 1'b0;
      applied_cursor_x <= applied_cursor_x;
      applied_cursor_y <= applied_cursor_y;
    end
  end

  //------------------- first timing stage ------------------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      y_max11 <= 16'h0000;
      y_max12 <= 16'h0000;
      y_max13 <= 16'h0000;
      y_max14 <= 16'h0000;
      x_max11 <= 16'h0000;
      x_max12 <= 16'h0000;
      x_max13 <= 16'h0000;
      x_max14 <= 16'h0000;
    end else begin
      y_max11 <= (y_cursor -  {10'b0 , y_hot}) ;
      y_max12 <= (y_cursor + ~{10'b0 , y_hot}) ;
      y_max13 <= (y_cursor -  {10'b0 , y_hot}) ;
      y_max14 <= (y_cursor + ~{10'b0 , y_hot}) ;
      x_max11 <= (x_cursor -  {10'b0 , x_hot}) ;
      x_max12 <= (x_cursor + ~{10'b0 , x_hot}) ;
      x_max13 <= (x_cursor -  {10'b0 , x_hot}) ;
      x_max14 <= (x_cursor + ~{10'b0 , x_hot}) ;
    end
  end

  reg [15:0] x_plus1, y_plus1;

  //------------------second  timing stage ------------------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      y_max21 <= 16'h0000;
      y_max22 <= 16'h0000;
      y_max23 <= 16'h0000;
      y_max24 <= 16'h0000;
      x_max21 <= 16'h0000;
      x_max22 <= 16'h0000;
      x_max23 <= 16'h0000;
      x_max24 <= 16'h0000;
      x_plus1 <= 16'h0000;
      y_plus1 <= 16'h0000;
    end else begin
      y_max21 <= (y_max11 + 16'd31) ;
      y_max22 <= (y_max12 + 16'd32) ;
      y_max23 <= (y_max13 + 16'd63) ;
      y_max24 <= (y_max14 + 16'd64) ;
      x_max21 <= (x_max11 + 16'd31) ;
      x_max22 <= (x_max12 + 16'd32) ;
      x_max23 <= (x_max13 + 16'd63) ;
      x_max24 <= (x_max14 + 16'd64) ;
      y_plus1 <= (y_max12 + 16'd1)  ;
      x_plus1 <= (x_max12 + 16'd1)  ;
    end
  end

  //-------------- generate cursor max count--for y counter---------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) y_max <= 16'h0000;
    else if (load_cursor_values) begin
      case(load_y_max)
        2'b00: y_max <= y_max21;
        2'b01: y_max <= y_max22;
        2'b10: y_max <= y_max23;
        2'b11: y_max <= y_max24;
      endcase
    end
  end
  
  //-------------- generate cursor max count--for x counter---------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) x_max <= 16'h0000;
    else if (load_cursor_values) begin
      case(load_x_max)
        2'b00: x_max <= x_max21;
        2'b01: x_max <= x_max22;
        2'b10: x_max <= x_max23;
        2'b11: x_max <= x_max24;
      endcase
    end
  end

  //-------------- generate cursor Y  start position------------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) y_start <= 16'h0000;
    // was missing for cursor update synchronization
    else if (load_cursor_values)y_start <= (ap_y_neg) ? y_plus1 : y_max11;
  end

  //-------------- generate cursor X  start position------------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset)x_start <= 16'h0000;
    // was missing for cursor update synchronization
    else  if (load_cursor_values) x_start <= (ap_x_neg) ? x_plus1 : x_max11;
  end

  //------------ Compute Effective Cursor X displayed Pixels ----------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) x_counter <= 16'h0000;
    else begin
      casex({new_2x, x_neg, inc_x})
        3'b10x : x_counter <= x_start;  // counter loaded with with offset pos
        3'b11x : x_counter <= 16'h0000; // counter loaded with reamaing pixels
        3'b0x1 : x_counter <= x_counter + 16'h0001; //  Increment counter
        default: x_counter <= x_counter;
      endcase
    end
  end

  //------------ Compute Effective Cursor y displayed Pixels ----------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) y_counter <= 16'h0000;
    else begin
      casex({(new_location2 | newframeu) , y_neg,  inc_y})
        3'b10x : y_counter <= y_start;  // counter loaded with 64 pixel value
        3'b11x : y_counter <= 16'h0000;  // counter loaded with reamaing pixels
        3'b0x1 : y_counter <= y_counter + 16'h0001; //  Increment counter
        default: y_counter <= y_counter;
      endcase
    end
  end

  //---------------------------------------------------------------
  // Now  Caluculate cursor offset relative to the cusror ram
  // I don't believe it is required new_2y includes newframeu.
  // and the x,y_adr starts few cycles later. 
  // new2 is used instead of new_location to synchronize the
  // processor to the pipeline all the time.
  always @(posedge pixclk or negedge reset) begin
    if (!reset) x_offset[5:0] <= 6'b0;
    else if (new_2x & x_neg)  x_offset[5:0] <= (~x_start[5:0]) +6'b1;
    else if (new_2x & !x_neg) x_offset[5:0] <= 6'b0;
  end

  always @(posedge pixclk or negedge reset) begin
    if (!reset) y_offset[5:0] <= 6'b0;
    else if (new_2y & y_neg)  y_offset[5:0] <= (~y_start[5:0]) +6'b1;
    else if (new_2y & !y_neg) y_offset[5:0] <= 6'b0;
  end
  
  //--------------------------------------------------------------------------
  // Now generate Cursor ram address in (x,y) coordinates, 
  // i.e cursor pixel address:
  reg		inc_xd;
  wire [2:0] 	cx_adr ;
  assign 	cx_adr = {new_3x, cursor_size2, inc_xd};
  wire [2:0] 	cy_adr ;
  assign 	cy_adr = {new_3y, cursor_size2, inc_y};

  //---------------------------------------------------------------
  // Now  Caluculate cursor offset relative to the cusror ram
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      x_adr[5:0] <= 6'b0;
      y_adr[5:0] <= 6'b0;
    end else begin
      casex(cx_adr)
        3'b10x   :        x_adr <=  {1'b0, x_offset[4:0]};
        3'b11x   :        x_adr <=  x_offset[5:0];
        3'b0x1   :        x_adr <=  x_adr + 6'b1;  
        default  :        x_adr <=  x_adr;
      endcase
      
      casex(cy_adr)
        3'b10x   :        y_adr <=  {1'b0, y_offset[4:0]};
        3'b11x   :        y_adr <=  y_offset[5:0];
        3'b0x1   :        y_adr <=  y_adr + 6'b1;
        default  :        y_adr <=  y_adr;
      endcase
    end
  end

  //-------------- Geting h_counter and pixel counter going ------------------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      pix_counter <= 16'h0000;
      h_counter   <= 16'h0000;
    end else if (newframeu) begin
      h_counter   <= 16'h0000;
      pix_counter <= 16'h0000;
    end else if (hsync_d & !hsync) begin 
      h_counter <= h_counter + 16'b1;
      pix_counter <= 16'h0000;
    end else if (!hsync_d2) pix_counter <= pix_counter + 16'b1; // active line
  end

  //-------Now calculating the displayed curosr for processor read back------
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      act_x <= 16'h0000;
      act_y <= 16'h0000;
    end else if (rd3 & !rd2) begin
      if (cursor_size2) begin
        act_x  <=  x_start[15:0] + {10'b0, x_adr[5:0]};
        act_y  <=  y_start[15:0] + {10'b0, y_adr[5:0]};
      end else begin
        act_x  <=  x_start[15:0] + {11'b0, x_adr[4:0]};
        act_y  <=  y_start[15:0] + {11'b0, y_adr[4:0]};
      end
    end
  end
  
  ///// ---------Displayed Cursor state machine------------------------------
  ///////////////NOTE: for pipeline to work, state machine may process
  ////////////////////////pixels early on in the cylce
  //////////////////////////It still have to synchronize the counters
  reg	[2:0]	state ;

  always @(posedge pixclk or negedge reset) 
    if (!reset) begin
      inc_y <= 1'b0;
      state <= idle;
    end else begin
      inc_y <= 1'b0;
      case(state)
        idle: 
	  if (!hsync) state <= process_y;
          else state <= idle;

	// cursor off screen
	process_y: 
	  if (x_max_neg | y_max_neg) state <= process_y;
          else if  (y_counter == (y_max + 1 )) state <= finish;
          else if (y_counter == h_counter) state <= process_x;
	  else state <= wait_one;

	hsync_time: 
	  if (vsync ) state <= idle;
          else if (hsync_m5) begin
            inc_y <= 1'b1;
            state <= wait_one;
          end else state <= hsync_time;
	
        wait_one : state <= idle;

        process_x: 
	  if ((x_counter == x_max) | hsync_m3 ) state <= hsync_time;
          else state <= process_x;

        finish: 
	  if(vsync ) state <= idle;
          else  state <= finish;

      endcase
    end

  assign inc_x = ((!hsync_d2) && (state==process_x) && (x_counter == pix_counter)) ? 1'b1 : 1'b0;

  assign display_cursor5 = inc_x;

  //---------------------------------------------------------------------------
  reg [5:0] x_adr_delayed; 


  // Pipe Stage 1
  // Now expand the address to the cursor ram
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      inc_xd <= 1'b0; 
      x_adr_delayed <= 6'b000000;
      ram_pixel_addr[11:0] <=  12'h000;
    end else begin
      x_adr_delayed[5:0] <= x_adr[5:0];
      inc_xd <= inc_x; 
      if (cursor_size2) 
	ram_pixel_addr[11:0] <=  {y_adr[5:0] ,x_adr_delayed[5:0]};  
      else 
	ram_pixel_addr[11:0] <= {cursor_smlc2, y_adr[4:0], x_adr_delayed[4:0]};
    end
  end

  // This logic was added to detect a cursor RAM address change
  // and generate a load for the new pipeline register.
  // Pipe register is also loaded just before a new frame
  // starts, in case new ram data was loaded during vblank, and ram address has
  // not changed. (newframeu used for this)
  //
  wire		load_pipe_e;

  always @* begin
    if (cursor_size2) ram_address = {y_adr[3:0], x_adr_delayed[5:2]};
    else              ram_address = {y_adr[4:0], x_adr_delayed[4:2]};
  end

  assign load_pipe_e = (ram_pixel_addr[9:2] != ram_address);

  always @(posedge pixclk or negedge reset) begin
    if (!reset) load_pipe <= 1'b0;
    else        load_pipe <= load_pipe_e | newframeu;
  end

  // Pipe Stage 2
  //--------------------------------------------------------------------------
  // Cursor direct ram address is ram_pixel_addr[9:2]
  // ram_pixel_addr[11:10] are used for the ram chip select
  //          (high level address) and needs to be skewed by 1 clk
  // ram_pixel_addr[1:0] are for low level address  to select the actual cursor
  //          they needs to be skewed by 1 clk and may need to be inverted
  //        ram_address    address to all cursor rams
  //        ram _data1,2,3,4 cursor data from cursor ram
  //
  //
  //
  reg [1:0] byte_sel; 
  reg [1:0] cursor_sel;
  //----------------------------------------------------------------
  // hi/lo address bits to be skewed to match ram access time
  always @(posedge pixclk or negedge reset) begin
    if (!reset) begin
      byte_sel[1:0]   <=  2'b0;
      cursor_sel      <=  2'b0;
    end else begin
      byte_sel[1:0] <= (ram_pixel_addr[11:10]);
      cursor_sel <=  ram_pixel_addr[1:0] ;
    end
  end

  // Pipe Stage 3: data back from ram
  //--------------------------------------------------------------------------
  // 
  always @(posedge pixclk) 
    if(load_pipe) begin
      case(byte_sel)
        2'b00 :  cursor_index_byte = cursor1_data;
        2'b01 :  cursor_index_byte = cursor2_data;
        2'b10 :  cursor_index_byte = cursor3_data;
        2'b11 :  cursor_index_byte = cursor4_data;
      endcase
    end

  //-----------------------------------------------------------

  always @*
    case({pix_order2, cursor_sel})
      // Normal mode
      3'b0_00 :  cursor_index = cursor_index_byte[1:0];
      3'b0_01 :  cursor_index = cursor_index_byte[3:2];
      3'b0_10 :  cursor_index = cursor_index_byte[5:4];
      3'b0_11 :  cursor_index = cursor_index_byte[7:6];
      // Reversed order
      3'b1_00 :  cursor_index = cursor_index_byte[7:6];
      3'b1_01 :  cursor_index = cursor_index_byte[5:4];
      3'b1_10 :  cursor_index = cursor_index_byte[3:2];
      3'b1_11 :  cursor_index = cursor_index_byte[1:0];
    endcase

  //-- Now finally that we got the cursor index out of ram what to do with it.
  // generate standard mode cursor
  assign    p0_stand_mode = {cursor_mode2[1:0], cursor_index[1:0]};

  // Pipe Stage 4: Determine cursor settings
  // Select Standard mode P0:
  always @(posedge pixclk or negedge reset) 
    if (!reset) begin
      p0_std_col1 <=  1'b0;
      p0_std_col2 <=  1'b0;
      p0_std_col3 <=  1'b0;
      p0_std_high <=  1'b0;
    end else begin
      p0_std_col1 <= ((p0_stand_mode == 4'h5) | (p0_stand_mode == 4'h8) | 
		      (p0_stand_mode == 4'hE)) ? !adcurctl3 : 1'b0;
      p0_std_col2 <= ((p0_stand_mode == 4'h6) | (p0_stand_mode == 4'h9) | 
		      (p0_stand_mode == 4'hF)) ? !adcurctl3 : 1'b0;
      p0_std_col3 <= (p0_stand_mode == 4'h7) ? !adcurctl3 : 1'b0;
      p0_std_high <= (p0_stand_mode == 4'hB) ? !adcurctl3 : 1'b0;
    end

  //---------------------------------------------------------------
  // generate advanced mode cursor
  assign 	p0_adv_mode0 = {cursor_index[1:0], adcuratt3[1:0]};
  assign 	p0_adv_mode1 = {cursor_index[1:0], adcuratt3[3:2]};
  assign 	p0_adv_mode2 = {cursor_index[1:0], adcuratt3[5:4]};
  assign 	p0_adv_mode3 = {cursor_index[1:0], adcuratt3[7:6]};

  // Pipe Stage 5: output cursor data
  // Select P0:
  always @(posedge pixclk or negedge reset) 
    if (!reset) begin
      p0_adv_col0 <=  1'b0;
      p0_adv_col1 <=  1'b0;
      p0_adv_col2 <=  1'b0;
      p0_adv_col3 <=  1'b0;
      p0_trans_c0 <=  1'b0;
      p0_trans_c1 <=  1'b0;
      p0_trans_c2 <=  1'b0;
      p0_trans_c3 <=  1'b0;
      p0_high_c0  <=  1'b0;
      p0_high_c1  <=  1'b0;
      p0_high_c2  <=  1'b0;
      p0_high_c3  <=  1'b0;
    end else begin
      // 00 00        transparent
      // 00 01        solid color
      p0_adv_col0 <= (p0_adv_mode0 == 4'h1) ? adcurctl3 & display_cursor1 : 1'b0;
      // 00 10        tranlucent_0
      p0_trans_c0 <= (p0_adv_mode0 == 4'h2) ? adcurctl3 & display_cursor1 : 1'b0;
      // 00 11        highlight
      p0_high_c0  <= (p0_adv_mode0 == 4'h3) ? adcurctl3 & display_cursor1 : 1'b0;

      //-----------------------------------------------------------
      // 01 01        col 1
      p0_adv_col1 <= (p0_adv_mode1 == 4'h5) ? adcurctl3 & display_cursor1 : 1'b0;
      // 01 10        tranlucent_1
      p0_trans_c1 <= (p0_adv_mode1 == 4'h6) ? adcurctl3 & display_cursor1 : 1'b0;
      // 01 11        highlight
      p0_high_c1  <= (p0_adv_mode1 == 4'h7) ? adcurctl3 & display_cursor1 : 1'b0;

      //-----------------------------------------------------------
      // 10 01        col 2
      p0_adv_col2 <= (p0_adv_mode2 == 4'h9) ? adcurctl3 & display_cursor1 : 1'b0;
      // 10 10        tranlucent_2
      p0_trans_c2 <= (p0_adv_mode2 == 4'ha) ? adcurctl3 & display_cursor1 : 1'b0;
      // 10 11        highlight
      p0_high_c2  <= (p0_adv_mode2 == 4'hb) ? adcurctl3 & display_cursor1 : 1'b0;

      //-----------------------------------------------------------
      // 11 01        col 3
      p0_adv_col3 <= (p0_adv_mode3 == 4'hd) ? adcurctl3 & display_cursor1 : 1'b0;
      // 11 10        tranlucent_3
      p0_trans_c3 <= (p0_adv_mode3 == 4'he) ? adcurctl3 & display_cursor1 : 1'b0;
      // 11 11        highlight
      p0_high_c3  <= (p0_adv_mode3 == 4'hf) ? adcurctl3 & display_cursor1 : 1'b0;
    end

  //-----------------------------------------------------
  // Module outputs.
  assign p0_apply_cursor =  (p0_adv_col0 | p0_std_col1 | 
			     p0_adv_col1 | p0_std_col2 |
                       	     p0_adv_col2 | p0_std_col3 | p0_adv_col3);
  assign p0_highlight = (p0_std_high | p0_high_c0 | p0_high_c1 | 
			 p0_high_c2 | p0_high_c3);
  assign p0_translucent = (p0_trans_c0 | p0_trans_c2 | p0_trans_c1 | 
			   p0_trans_c3);

  //-----------------------------------------------------
  wire 	 p0_selcolor0 = (p0_adv_col0 | p0_trans_c0 | p0_high_c0);
  wire 	 p0_selcolor1 = (p0_std_col1 | p0_adv_col1 | p0_trans_c1 | p0_high_c1);
  wire 	 p0_selcolor2 = (p0_std_col2 | p0_adv_col2 | p0_trans_c2 | p0_high_c2);
  wire 	 p0_selcolor3 = (p0_std_col3 | p0_adv_col3 | p0_trans_c3 | p0_high_c3);

  // P0 color outputs
  always @* begin
    casex ({p0_selcolor0 , p0_selcolor1 , p0_selcolor2 , p0_selcolor3}) 
      4'b1xxx : begin
        p0_red_cursor <= 8'b0;
        p0_grn_cursor <= 8'b0;
        p0_blu_cursor <= 8'b0;
      end          
      4'b01xx : begin
        p0_red_cursor <= cur1red;
        p0_grn_cursor <= cur1grn;
        p0_blu_cursor <= cur1blu;
      end
      4'b001x : begin
        p0_red_cursor <= cur2red;
        p0_grn_cursor <= cur2grn;
        p0_blu_cursor <= cur2blu;
      end
      4'b0001 : begin
        p0_red_cursor <= cur3red;
        p0_grn_cursor <= cur3grn;
        p0_blu_cursor <= cur3blu;
      end
      default : begin
        p0_red_cursor <= cur3red;
        p0_grn_cursor <= cur3grn;
        p0_blu_cursor <= cur3blu;
      end
    endcase
  end

endmodule
