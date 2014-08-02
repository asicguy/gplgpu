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
//  Title       :  HRES TABLE
//  File        :  hres_table.h
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2010
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
//  Modules Instantiated: None
//
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


  // FIXME These are the values for 2 pixels per clock.
  /*
  parameter 	  hactv_640  = 14'h0A0,
  		  hactv_800  = 14'h0C0,
  		  hactv_1024 = 14'h100,
  		  hactv_1280 = 14'h140,
  		  hactv_1600 = 14'h190;
   */
  parameter 	  hactv8_640  =  14'hA0,
  	 	  hactv16_640  = 14'h140,
  	 	  hactv32_640  = 14'h280,

  		  hactv8_780  =  14'hC3,
  		  hactv16_780  = 14'h186,
  		  hactv32_780  = 14'h30C,

  		  hactv8_800  =  14'hC8,
  		  hactv16_800  = 14'h190,
  		  hactv32_800  = 14'h320,

  		  hactv8_1024 =  14'h100,
  		  hactv16_1024 = 14'h200,
  		  hactv32_1024 = 14'h400,

  		  hactv8_1152 =  14'h120,
  		  hactv16_1152 = 14'h240,
  		  hactv32_1152 = 14'h480,

  		  hactv8_1280 =  14'h140,
  		  hactv16_1280 = 14'h280,
  		  hactv32_1280 = 14'h500,

  		  hactv8_1600 =  14'h190,
  		  hactv16_1600 = 14'h320,
  		  hactv32_1600 = 14'h640;

  // Horizontal Active Time Decoding.
  always @*
	begin
		case({bpp, hactive_regist}) 
  		  {2'b01, hactv8_640}:   horiz_actv_decode = 3'b001;
  		  {2'b10, hactv16_640}:  horiz_actv_decode = 3'b001;
  		  {2'b00, hactv32_640}:  horiz_actv_decode = 3'b001;
  		  {2'b11, hactv32_640}:  horiz_actv_decode = 3'b001;
		  // 
  		  {2'b01, hactv8_780}:   horiz_actv_decode = 3'b011;
  		  {2'b10, hactv16_780}:  horiz_actv_decode = 3'b011;
  		  {2'b00, hactv32_780}:  horiz_actv_decode = 3'b011;
  		  {2'b11, hactv32_780}:  horiz_actv_decode = 3'b011;
		  // 
  		  {2'b01, hactv8_800}:   horiz_actv_decode = 3'b011;
  		  {2'b10, hactv16_800}:  horiz_actv_decode = 3'b011;
  		  {2'b00, hactv32_800}:  horiz_actv_decode = 3'b011;
  		  {2'b11, hactv32_800}:  horiz_actv_decode = 3'b011;
		  // 
  		  {2'b01, hactv8_1024}:  horiz_actv_decode = 3'b100;
  		  {2'b10, hactv16_1024}: horiz_actv_decode = 3'b100;
  		  {2'b00, hactv32_1024}: horiz_actv_decode = 3'b100;
  		  {2'b11, hactv32_1024}: horiz_actv_decode = 3'b100;
		  // 
  		  {2'b01, hactv8_1152}:  horiz_actv_decode = 3'b101;
  		  {2'b10, hactv16_1152}: horiz_actv_decode = 3'b101;
  		  {2'b00, hactv32_1152}: horiz_actv_decode = 3'b101;
  		  {2'b11, hactv32_1152}: horiz_actv_decode = 3'b101;
		  // 
  		  {2'b01, hactv8_1280}:  horiz_actv_decode = 3'b101;
  		  {2'b10, hactv16_1280}: horiz_actv_decode = 3'b101;
  		  {2'b00, hactv32_1280}: horiz_actv_decode = 3'b101;
  		  {2'b11, hactv32_1280}: horiz_actv_decode = 3'b101;
		  // 
  		  {2'b01, hactv8_1600}:  horiz_actv_decode = 3'b110;
  		  {2'b10, hactv16_1600}: horiz_actv_decode = 3'b110;
  		  {2'b00, hactv32_1600}: horiz_actv_decode = 3'b110;
  		  {2'b11, hactv32_1600}: horiz_actv_decode = 3'b110;
		  // 
  		  default:    		 horiz_actv_decode = 3'b000;
		endcase
	end

