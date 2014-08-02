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
//  Title       :  
//  File        :  
//  Author      :  Jim MacLeod
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
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
//
///////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
//    		TASK TO VERIFY THE DATA INTEGRITY OF THE LUT TABLES
/******************************************************************************/
task yuv_lut_verify;

 integer i; //loop counter

 real temp_u0, temp_u1;
 real temp_v0, temp_v1;
 reg [9:0] U00, U10;
 reg [9:0] V00, V10;
 reg [9:0] temp_u00, temp_u10;
 reg [9:0] temp_v00, temp_v10;
 reg [9:0] U0, U1;
 reg [9:0] V0, V1;
 reg [7:0] fail_count0, fail_count1;

 begin

 fail_count0= 0; //initialize the fail count
 fail_count1= 0; //initialize the fail count


REV2_STIM.open_file("hb_test_result/yuv_lut_verify.res");
 
$fdisplay(fname,"\n*********************************");
$fdisplay(fname,"     BEGIN YUV_LUT_VERIFY TEST   ");
$fdisplay(fname,"*********************************\n");



$fdisplay(fname,"\n**************************************************");
$fdisplay(fname,"  TESTING THE INTEGRITY OF THE U LUT DATA VALUES");
$fdisplay(fname,"*************************************************\n");

//testing the first half of the lut.
for (i=0; i<127; i=i+1)
  begin
    mov_dw(MEM_WR, rbase_w+8'h58, 32'h0000_0300+i, 4'h0, 1);
    rd (MEM_RD, rbase_w+8'h5c, 1);
 
 temp_u0 = (1.733*2*('d128-i));
 U00=temp_u0;
 U0 = (~(U00)+1'b1);

 temp_u1 = (0.337*4*('d128-i));
 U10= temp_u1;
 U1 = (~(U10) + 1'b1);
 
  begin
   if (test_reg[9:0]==U0)
       $fdisplay(fname,"U0: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, U0, test_reg[9:0]);
   else
     begin
       $fdisplay(fname,"U0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, U0, test_reg[9:0]);
       $fdisplay(results,"U0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, U0, test_reg[9:0]);
       fail_count0= fail_count0+1;
     end
      end
 
  begin
  if (test_reg[25:16]==U1)
     $fdisplay(fname,"U1: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, U1, test_reg[25:16]);
  else
   begin
     $fdisplay(fname,"U1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, U1, test_reg[25:16]);
     $fdisplay(results,"U1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, U1, test_reg[25:16]);
     fail_count0= fail_count0+1;
   end
  end
 end
 

//testing the second half of the lut.
for (i=128; i<256; i=i+1)
  begin
    mov_dw(MEM_WR, rbase_w+8'h58, 32'h0000_0300+i, 4'h0, 1);
    rd (MEM_RD, rbase_w+8'h5c, 1);

 temp_u0 = (1.733*2*(i-'d128));
 U0 = temp_u0;

 temp_u1 = (0.337*4*(i-'d128));
 U1= temp_u1;

   begin
    if (test_reg[9:0]==U0)
      $fdisplay(fname,"U0: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, U0, test_reg[9:0]);
     else
      begin
       $fdisplay(fname,"U0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, U0, test_reg[9:0]);
       $fdisplay(results,"U0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, U0, test_reg[9:0]);
       fail_count0= fail_count0+1;
      end
  end

  begin
    if (test_reg[25:16]==U1)
     $fdisplay(fname,"U1: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, U1, test_reg[25:16]);
    else
     begin
      $fdisplay(fname,"U1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, U1, test_reg[25:16]);
      $fdisplay(results,"U1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, U1, test_reg[25:16]);
      fail_count0= fail_count0+1;
     end
  end
    end


$fdisplay(fname,"\n**************************************************");
$fdisplay(fname,"\nTESTING THE INTEGRITY OF THE V LUT DATA VALUES");
$fdisplay(fname,"*************************************************\n");
 
//testing the first half of the lut.
for (i=0; i<127; i=i+1)
  begin
    mov_dw(MEM_WR, rbase_w+8'h58, 32'h0000_0100+i, 4'h0, 1);
    rd (MEM_RD, rbase_w+8'h5c, 1);
 
 temp_v0 = (1.371*2*('d128-i));
 V00=temp_v0;
 V0 = (~(V00)+1'b1);
 
 temp_v1 = (0.698*4*('d128-i));
 V10=temp_v1;
 V1 = (~(V10)+1'b1);

   begin
    if (test_reg[9:0]==V0)
     $fdisplay(fname,"V0: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, V0, test_reg[9:0]);
    else
     begin
      $fdisplay(fname,"V0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, V0, test_reg[9:0]);
      $fdisplay(results,"V0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, V0, test_reg[9:0]);
      fail_count1= fail_count1+1;
     end
   end
 
   begin
   if (test_reg[25:16]==V1)
     $fdisplay(fname,"V1: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, V1, test_reg[25:16]);
   else
    begin
     $fdisplay(fname,"V1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, V1, test_reg[25:16]);
     $fdisplay(results,"V1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, V1, test_reg[25:16]);
     fail_count1= fail_count1+1;
    end
  end
   end
 

//testing the second half of the lut.
for (i=128; i<256; i=i+1)
  begin
    mov_dw(MEM_WR, rbase_w+8'h58, 32'h0000_0100+i, 4'h0, 1);
    rd (MEM_RD, rbase_w+8'h5c, 1);
 
 temp_v0 = (1.371*2*(i-'d128));
 V0=temp_v0;
 
 temp_v1 = (0.698*4*(i-'d128));
 V1=temp_v1;

  begin
   if (test_reg[9:0]==V0)
     $fdisplay(fname,"V0: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, V0, test_reg[9:0]);
   else
    begin
     $fdisplay(fname,"V0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, V0, test_reg[9:0]);
     $fdisplay(results,"V0: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h", i, V0, test_reg[9:0]);
     fail_count1= fail_count1+1;
    end
  end
 
   begin
    if (test_reg[25:16]==V1)
     $fdisplay(fname,"V1: COMPARISON PASSED   LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, V1, test_reg[25:16]);
    else
     begin
      $fdisplay(fname,"V1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, V1, test_reg[25:16]);
      $fdisplay(results,"V1: COMPARISON FAILED!! LOCATION=%d      EXPECTED_DATA=%h ACTUAL_DATA=%h\n", i, V1, test_reg[25:16]);
      fail_count1= fail_count1+1;
     end
   end
    end
 


$fdisplay(fname,"\n************************************************************************************");
$fdisplay(fname,"************************************************************************************");
$fdisplay(fname,"       END YUV_LUT_VERIFY TEST , NUMBER OF FAILURES IN U TABLE =%d", fail_count0);
$fdisplay(fname,"                                 NUMBER OF FAILURES IN V TABLE =%d", fail_count1);  
$fdisplay(fname,"************************************************************************************");
$fdisplay(fname,"************************************************************************************\n");

  $fdisplay(results, "\n*******************************************");
  $fdisplay(results, "*******************************************");
  $fdisplay(results, "            YUV_LUT_VERIFY END               ");
  $fdisplay(results, "*******************************************");
  $fdisplay(results, "*******************************************\n");


 REV2_STIM.close_file("hb_test_result/yuv_lut_verify.res");

  end
endtask
