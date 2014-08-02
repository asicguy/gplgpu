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
/*************************************************************************************************/
//    		TASK TO TEST YUV (WINDOW 0-->YUV_444 at 32BBP , WINDOW 1-->YUV_444 at 32BBP )
/************************************************************************************************/
task ycbcr_32_444;

 reg [7:0] j; //loop counter
 reg [31:0] data_in, addr_in, read_addr;
 reg [7:0] fail_count0, fail_count1;
 reg[23:0] first_pixel, second_pixel;
 reg [31:0] first_read_mem_table, second_read_mem_table;
 reg [15:0] first_half, second_half;
 

 parameter
   YCBCR = 0,
    `ifdef TRIAL_RUN
      burst_length = 4;
  `else
      burst_length = 40;
  `endif

begin
 fail_count0= 0; //initialize the fail count
 fail_count1= 0; //initialize the fail count
 
  $fdisplay(results, "\n*******************************************");
  $fdisplay(results, "            YCBCR_32_444 TEST START               ");
  $fdisplay(results, "*******************************************\n");

 
 REV2_STIM.open_file("hb_test_result/ycbcr_32_444.res"); //open up the dump result file

 mov_dw (CONFIG_WR, 32'h10, 32'h7000_0008, 4'h0, 1); //assign 4M bytes for linear window 0.
 mov_dw (CONFIG_WR, 32'h14, 32'h9040_0008, 4'h0, 1); //assign 4M bytes for linear window 1.


 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0000_0214, 4'h0, 1); //diasble all decode except linear windows.

//****SET PACKING MODE FOR LINEAR 0 TO YUV_444 at 32BBP
 mov_dw (MEM_WR, rbase_w+MW0_CTRL,   32'h38b0_0040, 4'h0, 1);  // MW0_CTRL(32 PACKING , 444)
 mov_dw (MEM_WR, rbase_w+MW0_AD,     32'h7000_0000, 4'h0, 1);  // MW0_AD
 mov_dw (MEM_WR, rbase_w+MW0_SZ,     32'h0000_0009, 4'h0, 1);  // MW0_SZ
 mov_dw (MEM_WR, rbase_w+MW0_PGE,    32'h0000_0000, 4'h0, 1);  // MW0_PGE
 mov_dw (MEM_WR, rbase_w+MW0_ORG,    32'h0000_0000, 4'h0, 1);  // MW0_ORG
 mov_dw (MEM_WR, rbase_w+MW0_WSRC,   32'hffff_ffff, 4'h0 ,1);  // MW0_WSRC
 mov_dw (MEM_WR, rbase_w+MW0_WKEY,   32'haaaa_5555, 4'h0, 1);  // MW0_KEY
 mov_dw (MEM_WR, rbase_w+MW0_KYDAT,  32'h0000_0005, 4'h0, 1);  // MW0_KYDAT
 mov_dw (MEM_WR, rbase_w+MW0_MASK,   32'hffff_ffff, 4'h0, 1);  // MW0_MASK


//****SET PACKING MODE FOR LINEAR 1 TO YUV_444 at 32BBP *****
 mov_dw (MEM_WR, rbase_w+MW1_CTRL,   32'h38b8_0040, 4'h0, 1);  // MW1_CTRL(32 PACKING , 444)
 mov_dw (MEM_WR, rbase_w+MW1_AD,     32'h9040_0000, 4'h0, 1);  // MW1_AD
 mov_dw (MEM_WR, rbase_w+MW1_SZ,     32'h0000_0005, 4'h0, 1);  // MW1_SZ
 mov_dw (MEM_WR, rbase_w+MW1_PGE,    32'h0000_0000, 4'h0, 1);  // MW1_PGE
 mov_dw (MEM_WR, rbase_w+MW1_ORG,    32'h0000_0000, 4'h0, 1);  // MW1_ORG
 mov_dw (MEM_WR, rbase_w+MW1_WSRC,   32'hffff_ffff, 4'h0 ,1);  // MW1_WSRC
 mov_dw (MEM_WR, rbase_w+MW1_WKEY,   32'h5555_aaaa, 4'h0, 1);  // MW1_KEY
 mov_dw (MEM_WR, rbase_w+MW1_KYDAT,  32'h0000_000a, 4'h0, 1);  // MW1_KYDAT
 mov_dw (MEM_WR, rbase_w+MW1_MASK,   32'hffff_ffff, 4'h0, 1);  // MW1_MASK
 

 $display("\n Enabling Memory Window 0 & 1 decode \n");

 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0003_0214, 4'h0, 1);  // 

$fdisplay(fname,"*******************************");
$fdisplay(fname,"****** BEGIN TESTING **********");
$fdisplay(fname,"*******************************\n");

write_index=0; //initialize write index
read_index=0; //initialize read index

 
$fdisplay(fname,"\n***************************************");
$fdisplay(fname,"***  WINDOW 0 , YUV 444 at 32BBP ***");
$fdisplay(fname,"***************************************\n");
 
//WRITING TO THE HOST CACHE CONTROL REGISTER
 mov_dw (MEM_WR, rbase_w+8'h50, 32'h0000_8010, 4'h0, 1); //ENABLE COUNTER, ENABLE YUV CACHE MECHANISIM

 for (j=0; j<=burst_length; j=j+1)
   begin
    $fdisplay(fname, "\nTEST ROUND=%d", j);
 
    data_in[31:0] = $random;
    addr_in[31:0] = 32'h7000_0000+{j,2'h0};
    write_flag_n=0; //enable writting to memory array
 
       mov_dw (MEM_WR, addr_in, data_in , 4'h0, j+1); //WRITE
 
 write_index=0; //reset the memory array index to 0 after each round
 write_flag_n=1;//disable writting to the memory array (since you need the data for comparisson)
 
 rd(MEM_RD, rbase_w+MW1_MASK, 1);
 
//READ DATA FROM MEMORY
 
 read_addr[31:0] = 32'h7000_0000+{j,2'h0};
 read_flag_n=0; //enale writting to the memory read table.
       rd     (MEM_RD, read_addr, j+1); // READ
 read_index=0;
 read_flag_n=1; //disable writting to the memory read table.

 //COMPARISON
 for (i=0; i<=j; i=i+1)
   begin

  yuv_compare (write_mem_table[i], YCBCR, first_pixel, second_pixel);

  first_read_mem_table[31:0] = read_mem_table[i];

  if (first_read_mem_table[23:0]== first_pixel)
     $fdisplay(fname, "COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{i,2'h0});
   
   else
         begin
            fail_count0= fail_count0+1;
            $fdisplay(fname, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{i,2'h0});
           $fdisplay(results, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{i,2'h0});
         end

 end
 end

/************************************/
//     CLEARING THE MEMORY TABLE
 for (i=0; i<=burst_length; i=i+1)
   begin
    write_mem_table[i] = 32'h0;
    read_mem_table[i]  = 32'h0;
   end
write_index=0; //initialize write index
read_index=0; //initialize read index

/***********************************/


$fdisplay(fname,"\n***************************************");
$fdisplay(fname,"***  WINDOW 1 , YUV 444 at 32BBP ***");
$fdisplay(fname,"***************************************\n");
 
//WRITING TO THE HOST CACHE CONTROL REGISTER
 mov_dw (MEM_WR, rbase_w+8'h50, 32'h0000_8010, 4'h0, 1); //ENABLE COUNTER, ENABLE YUV CACHE MECHANISIM
 
 for (j=0; j<=burst_length; j=j+1)
   begin
    $fdisplay(fname, "\nTEST ROUND=%d", j);
 
    data_in[31:0] = $random;
    addr_in[31:0] = 32'h9040_0000+{j,2'h0};
    write_flag_n=0; //enable writting to memory array
 
       mov_dw (MEM_WR, addr_in, data_in , 4'h0, j+1); //WRITE
 
 write_index=0; //reset the memory array index to 0 after each round
 write_flag_n=1;//disable writting to the memory array (since you need the data for comparisson)
 
 mov_dw (MEM_WR, rbase_w+MW1_MASK, 32'h0, 4'hf, 1);
 rd(MEM_RD, rbase_w+MW1_MASK, 1);
 
//READ DATA FROM MEMORY
 
 read_addr[31:0] = 32'h9040_0000+{j,2'h0};
 read_flag_n=0; //enale writting to the memory read table.
       rd     (MEM_RD, read_addr, j+1); // READ
 read_index=0;
 read_flag_n=1; //disable writting to the memory read table.
 
 //COMPARISON
 for (i=0; i<=j; i=i+1)
   begin
 
  yuv_compare (write_mem_table[i],YCBCR,  first_pixel, second_pixel);
 
  first_read_mem_table[31:0] = read_mem_table[i];
 
  if (first_read_mem_table[23:0]== first_pixel)
     $fdisplay(fname, "COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{i,2'h0});
 
   else
         begin
            fail_count1= fail_count1+1;
            $fdisplay(fname, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{i,2'h0});
           $fdisplay(results, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{i,2'h0});
         end
 
 end
 end

/************************************/
//     CLEARING THE MEMORY TABLE
 for (i=0; i<=burst_length; i=i+1)
   begin
    write_mem_table[i] = 32'h0;
    read_mem_table[i]  = 32'h0;
   end
write_index=0; //initialize write index
read_index=0; //initialize read index
 
/***********************************/
 


  //EXITING THE TASK
 
     $fdisplay(fname, "\n***********************************************************************");
      $fdisplay(fname, "    END OF SIMULATION.  NUMBER OF FAILURES IN WINDOW 0 =%d", fail_count0);
      $fdisplay(fname, "                        NUMBER OF FAILURES IN WINDOW 1 =%d", fail_count1);
      $fdisplay(fname, "***********************************************************************");
 
 
  $fdisplay(results, "\n*******************************************");
  $fdisplay(results, "*******************************************");
  $fdisplay(results, "            YCBCR_32_444 TEST END               ");
  $fdisplay(results, "*******************************************");
  $fdisplay(results, "*******************************************\n");

 
 REV2_STIM.close_file("hb_test_result/ycbcr_32_444.res"); //close the dump file.

  end
endtask
