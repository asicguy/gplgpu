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
//  Title       :  Display Controller
//  File        :  dc_contr.v
//  Author      :  Frank Bruno
//  Created     :  30-Dec-2005
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
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

  module dc_contr 
    (
     input              dcnreset,
     input 	        hnreset,
     input 	        pixclock,
     input 	        crtclock,
     input 	        mclock,
     input 	        vsync,
     input 	        refresh_enable_regist,
     input [3:0] 	dzoom_regist,
     input [11:0] 	vactive_regist,
     input [9:0] 	pinl_regist,
     input 	        mcdc_ready,       
     input [9:0] 	ovtl_x,  //overlay top left x position (in pixels)
     input [9:0] 	ovtl_y, //overlay top  left y position (in pixels/lines)
     input [9:0] 	ovbr_x, //overlay bottom right x position (in pixels)
     input [9:0] 	ovbr_y, //overlay bottom left  y position (in pixels/lines)
     input [1:0] 	bpp, /* screen depths (from idac pixel_representation register
			      * only bits[2:1] )        
			      * 2'b01: 8bpp
			      * 2'b10: 16pbb
			      * 2'b11 or 00: 32bpp */
     input 	        ovnokey, // from ov. module, 1-suppress req, 0-normal requests
     input 	        ovignr_regist, /* from crtregist(test/safety) 
					* 1- normal display refreshes 
					* ignore ovnokey and ovignr16l_regist
					* 0- suppresses display refreshes 
					* inside overlay window if ovnokey=1 */
     input 	        ovignr16l_regist, /* (test/safety) 
					   * 1 -suppress display refreshes only
					   * if pages masked >=16
					   * 0 -suppressed display refreshes
					   * even for 1 page 
					   * ovignr_regist=1 has priority ! */
     input [9:0] 	wrusedw,
     
     output [9:0] 	ff_stp, // to DC_ADOUT to compare and stop addr. increment
     output [9:0] 	ff_rls, // to DC_ADOUT to compare and relase addr. increment
     output reg	            rsuppr, // to DC_ADOUT synchronized and qualified rsuppr_regist
     output reg		    mcdc_req,
     output reg	[11:0]      mcdcy,
     output reg	[9:0] 	mcdcx,
     output [4:0] 	mcdcpg //SH where 5'b0=32pages,5'b00001=1page 
     );
  parameter 	DC_START             = 2'b10,
		DC_WAIT_FOR_TRANSFER = 2'b00,
		DC_TRANSFER_DONE     = 2'b01,
		DC_IDLE              = 2'b11; 

  reg [11:0] 	mcdcy_next; 
  reg [11:0] 	linfr_count, linfr_count_next; 
  reg [3:0] 	zcount, zcount_next;
  reg [9:0] 	pinl_count, pinl_count_next;
  reg [9:0] 	left_pinl, right_pinl;
  reg [9:0] 	mcdcx_next;
  reg [9:0] 	xr_start;
  reg [1:0] 	refr_state, refr_state_next;
  reg 		rsuppre;   // control bit synchronised locked on vsync 
  reg [1:0] 	lstat, lstat_next; /* line status
                                    * 00,
                                    * 11: full, not masked line 
                                    * 10: left segment before masking window
                                    * 01: right segment after masking window */
  reg 		suppr16up;
  wire [11:0] 	linfr_total;        // limits to 2k y_screen + 2k-1 y_overlay  
  wire [11:0] 	incrlc;
  wire [11:0] 	lstrc;
  wire 		lstf,lstr;
  wire 		mt1, mt16;

  reg [5:0] 	preq;                 /* SH  number of pages to be requested
                                       * but not codded yet 
				       * 6'b10_0000 = 32 pages
                                       * 6'b0= 0 pages
                                       * for memory controller this will be 
				       * codded
                                       * 0 = 32; 
				       * 1 =1, zero pages is never requested */
  reg 		fifo_full;
  reg 		stop_req0, stop_req;
  
  ////////////////////////////////////////////////////////////////////////
  //Comments related to overlays:
  //masking requests from DC will be done on 16 byte boundries (one page)
  //first page in line will always be requested by DC (never masked)
  //last  page in line will always be requested by DC (never masked)
  //screen is divided into: full length lines, 
  //                        lines before left edge of overlay window   
  //                        lines after right edge of overlay window
  // then total number of lines seen in this module is 
  //                        vactive_regist + y_extend of overlay window
  // depending on ovtl_y and ovbr_y, a counter of pages in line (pinl_count)   
  // will be preloaded to: full length line (from pinl_regist), or
  // to number of unmasked  pages on left side of overlay window (lpginl) or 
  // to number of unmasked  pages on right side of overlay window (rpginl) 
  // To keep the pixel fifo (DC_RAM64X128) in sync, pages and lines  on output
  // side of the fifo will also be counted and the counters will stall after
  // left edge of overlay window pointing to the next location where the first
  // page of unmasked  data is already stored 
  // (after right edge of overlay window)
  // Looks like with overlays it is more convienient to count lines from 0
  // to total rather than opossite,so I have changed the count

  //////////////////////////////////////////////////////////////////////
  //  Memory request. A request is generated at same cycle when mcdc_ready
  //  appears .
  /////////////////////////////////////////////////////////////////////////
//  always @(posedge mclock) fifo_full <= (wrusedw[9:0] >= 9'd200);
    always @* fifo_full = wrusedw[9];
  
  always @(posedge pixclock) 
    if (crtclock) begin
      stop_req0 <= fifo_full;
      stop_req  <= stop_req0;
    end
  
  always @*
    mcdc_req = ~stop_req & (refr_state == DC_WAIT_FOR_TRANSFER) & mcdc_ready;

  // Pages requested for use by this module (preq) and memory contr.(mcdcpg)
  always @*
//    preq = ((pinl_count[9:0] <= (~wrusedw + 1)) && (pinl_count[9:0] <= 9'h20)
    // we won't overflow the buffer, so just check if the count is less than
    // 32 and either request 32 or the remainder
    preq = (pinl_count[9:0] <= 9'h20) ? pinl_count[5:0] : 6'h20;

  assign 	mcdcpg[4:0]=preq[4:0]; 

  ////////////////////////////////////////////////////////////////
  //Total number of active lines (cut into full,left and right lines) 
  //Lock rsuppre on vsync to avoid screen distortions when
  //enabling "suppress_requests mode" 
  // Dont bother with "suppress_requests mode" if less then one page is to be
  // masked Add here other qualifiers
  // e.g overlay outside the screen etc. ?????????????
  // Rest of the signals here assummed stable by the end of vsync and
  // during an active frame 
  
  assign 	mt1 = (xr_start > left_pinl)? 1'b1: 1'b0; 
  assign 	mt16= (xr_start > (left_pinl + 5'h10) )? 1'b1: 1'b0;

  always @(posedge pixclock or negedge hnreset) 
    if      (!hnreset) rsuppr  <= 1'b0;
    else if (!dcnreset && crtclock) rsuppr  <= 1'b0;
    else if(!vsync && crtclock)
      casex ({rsuppre, suppr16up, mt16, mt1} )
        4'b0xxx, 
        4'b10x0,
        4'b110x: rsuppr <= 1'b0;    // don't even bother
        4'b10x1,                    // at least one full page to be masked
          4'b111x: rsuppr <= 1'b1;  // at least 16 full pages to be masked
      endcase

  assign 	linfr_total=(rsuppr)? vactive_regist + ovbr_y - ovtl_y + 1'b1 :
                            vactive_regist; 

  ////////////////////////////////////////////////////////////////////
  //make indicators: 1) last full line before going into y_overlay space(lstf)
  //                 2) last right line before going outside y_overlay space
  //                    (lstr)

  assign 	incrlc = linfr_count + 1'b1;
  // all this to ensure sizes to comp.
  assign 	lstf = ( {1'b0,ovtl_y}==incrlc ); 

  //at the time of last right line counter is 2xovbr-ovtl +1 
  assign 	lstrc=   {ovbr_y,1'b0} - ovtl_y + 1'b1; 
  assign 	lstr = (lstrc ==linfr_count ); 

  ////////////////////////////////////////////////////////////////////
  // Calculate pages in  left and right lines and page start address
  // of the right line .
  // Full line takes pinl_regist directly /// from CRT register
  // right and left never less then one!

  always @*
    case(bpp) //synopsys parallel_case full_case
      2'b01: left_pinl = (ovtl_x >> 4) + 1'b1;    //8bpp 
      2'b10: left_pinl = (ovtl_x >> 3) + 1'b1;  //16bpp 
      2'b00,
        2'b11: left_pinl = (ovtl_x >> 2) + 1'b1; //32bpp
    endcase

  always @*
    case(bpp) //synopsys parallel_case full_case
      2'b01: right_pinl= pinl_regist - (ovbr_x >> 4) ;    //8bpp 
      2'b10: right_pinl= pinl_regist - (ovbr_x >> 3) ;  //16bpp 
      2'b00,
        2'b11: right_pinl= pinl_regist - (ovbr_x >> 2) ; //32bpp
    endcase
  
  always @*
    case(bpp) //synopsys parallel_case full_case
      2'b01: xr_start= ovbr_x >> 4 ;    //8bpp 
      2'b10: xr_start= ovbr_x >> 3 ;  //16bpp 
      2'b00,
        2'b11: xr_start= ovbr_x >> 2 ; //32bpp
    endcase

  // Just rename them  for ouputs going to other side of fifo 
  // These signals are used in dc_adout module.
  // If page counter on otput of the fifo (counts from zero up )
  // matches ff_stp (and overlay scan line ) it will stop to increment
  // ram_outaddr until  ff_rls will match the count. 

  assign 	ff_stp = left_pinl;
  assign 	ff_rls  = xr_start ;   

  //// x, y addresses requested  

  always  @*
    if (!vsync) begin
      refr_state_next = DC_START;  //no matter what
      //lucy pinl_count_next[9:0] = pinl_regist[9:0];
      pinl_count_next[9:0] = (rsuppr & ~(|ovtl_y))? left_pinl: //load left
                             pinl_regist[9:0];              //load full
      lstat_next= (rsuppr & ~(|ovtl_y))? 2'b10: 2'b11;
      
      mcdcx_next=10'b0; 
      mcdcy_next=12'b0; 
      linfr_count_next = 12'b0;
      zcount_next[3:0]=dzoom_regist[3:0];
    end else begin
      
      case (refr_state) //synopsys parallel_case full_case
	
	DC_START:   begin
          if(  (pinl_count == 10'b0)  
               ||(vactive_regist==12'b0) //check
               ||(!refresh_enable_regist)
               )
            refr_state_next = DC_IDLE;
          else
            refr_state_next = DC_WAIT_FOR_TRANSFER;
	  
          pinl_count_next[9:0] = pinl_count[9:0];
          lstat_next=lstat;
          linfr_count_next=linfr_count; 
          zcount_next=zcount;
          mcdcx_next=10'b0; 
          mcdcy_next=12'b0; 
        end
	
	
	DC_WAIT_FOR_TRANSFER:
          if(mcdc_req) begin
	    
            refr_state_next = DC_TRANSFER_DONE;
            if(pinl_count[9:0] == preq[5:0])//new line in next req
            begin
              //increment line counter
              linfr_count_next=incrlc ;
              
              //change line status and 
              //load pages_in_line counter for next line 
              case (lstat)  //synopsys parallel_case full_case
                2'b00,
                2'b11: //now is full
                  if (lstf && rsuppr) begin //next is left  
                    lstat_next=2'b10; 
                    pinl_count_next = left_pinl; end
                  else begin                //next is full  
                    lstat_next=2'b11; 
                    pinl_count_next = pinl_regist; end
		
                2'b10: //now is left
                  begin                //next is right  
                    lstat_next=2'b01; 
                    pinl_count_next = right_pinl; end
		
                2'b01: //now is right
                  if (lstr ) begin         //next is full  
                    lstat_next=2'b11; 
                    pinl_count_next = pinl_regist; end
                  else begin               //next is left  
                    lstat_next=2'b10; 
                    pinl_count_next = left_pinl; end
              endcase
              
              //x,y, zoom 
              if(lstat==2'b10)     //now is left jump to right
              begin
                mcdcx_next=xr_start; 
                mcdcy_next= mcdcy;
                zcount_next=zcount; end
              else              //go to left or full(next x=0)
              begin  
                mcdcx_next=10'b0; 
                if(zcount==4'b0)
                begin
                  mcdcy_next= mcdcy + 1'b1;
                  zcount_next=dzoom_regist; end
                else begin
                  mcdcy_next= mcdcy;
                  zcount_next=zcount - 1'b1; end
              end
            end
            else begin // not end of a line, continue current line
              pinl_count_next[9:0] = pinl_count[9:0] - preq[5:0];
              lstat_next=lstat;
              mcdcx_next=mcdcx + preq[5:0];
              mcdcy_next= mcdcy;
              zcount_next=zcount;
              linfr_count_next=linfr_count; end
	    
          end else begin // no request 
            refr_state_next = refr_state;
            pinl_count_next[9:0] = pinl_count[9:0] ;
            lstat_next=lstat;
            mcdcx_next=mcdcx;
            mcdcy_next= mcdcy;
            zcount_next=zcount;
            linfr_count_next=linfr_count; 
	  end 
	
	DC_TRANSFER_DONE:           //to ensure no req. and check frame done 
          begin
            if (linfr_count==linfr_total) // frame done  
              refr_state_next = DC_IDLE;
            else 
              refr_state_next = DC_WAIT_FOR_TRANSFER;
	    
            pinl_count_next = pinl_count ;
            lstat_next=lstat;
            mcdcx_next=mcdcx; 
            mcdcy_next= mcdcy;
            zcount_next=zcount;
            linfr_count_next=linfr_count; 
          end
	
	DC_IDLE:    begin    
          refr_state_next = refr_state; //stay here until vsync
          mcdcx_next=mcdcx; 
          mcdcy_next= mcdcy;
          zcount_next=zcount;
          linfr_count_next=linfr_count; 
          pinl_count_next = pinl_count ;
          lstat_next=lstat;
        end
	
      endcase
    end
  
  always @(posedge pixclock or negedge hnreset)
    if(!hnreset) begin
      refr_state  <= DC_IDLE; 
      mcdcx       <= 10'b0; 
      mcdcy       <= 12'b0; 
      zcount      <= 4'b0;
      pinl_count  <= 10'b0;
      lstat       <= 2'b0;
      linfr_count <= 12'b0; 
      rsuppre     <= 1'b0;
      suppr16up   <= 1'b0;
    end else if(!dcnreset && crtclock) begin
      refr_state  <= DC_IDLE; 
      mcdcx       <= 10'b0; 
      mcdcy       <= 12'b0; 
      zcount      <= 4'b0;
      pinl_count  <= 10'b0;
      lstat       <= 2'b0;
      linfr_count <= 12'b0; 
      rsuppre     <= 1'b0;
      suppr16up   <= 1'b0;
    end else if (crtclock) begin
      refr_state  <= refr_state_next;
      mcdcx       <= mcdcx_next; 
      mcdcy       <= mcdcy_next; 
      zcount      <= zcount_next;
      pinl_count  <= pinl_count_next;
      lstat       <= lstat_next;
      linfr_count <= linfr_count_next; 
      rsuppre     <= (ovnokey & ~ovignr_regist);
      suppr16up   <= ovignr16l_regist;
    end

endmodule





