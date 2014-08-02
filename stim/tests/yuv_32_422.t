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
//    		TASK TO TEST YUV (LINEAR 0-->YUV_422, LINEAR1-->YUV_422)
/******************************************************************************/
task yuv_32_422;

 reg [7:0] j; //loop counter
 reg [31:0] data_in, addr_in, read_addr;
 reg [31:0] data_in_0, addr_in_0, data_in_1, addr_in_1;
 reg [7:0] fail_count0, fail_count1;
 reg[23:0] first_pixel, second_pixel;
 reg [31:0] first_read_mem_table, second_read_mem_table;
 

 parameter
   YUV = 1,
    `ifdef TRIAL_RUN
      burst_length = 8;
  `else
      burst_length = 17;
  `endif


begin
 fail_count0= 0; //initialize the fail count
 fail_count1= 0; //initialize the fail count
 
  $fdisplay(results, "\n*******************************************");
  $fdisplay(results, "            YUV_32_422 TEST START               ");
  $fdisplay(results, "*******************************************\n");
 

 
 REV2_STIM.open_file("hb_test_result/yuv_32_422.res"); //open up the dump result file


 mov_dw (CONFIG_WR, 32'h10, 32'h7000_0008, 4'h0, 1); //assign 4M bytes for linear window 0.
 mov_dw (CONFIG_WR, 32'h14, 32'hb050_0008, 4'h0, 1); //assign 4M bytes for linear window 1.

 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0000_0214, 4'h0, 1); //diasble all decode except linear windows.

//****SET PACKING MODE FOR LINEAR 0 TO YUV_422 at 32BBP *****
 mov_dw (MEM_WR, rbase_w+MW0_CTRL,   32'h3838_0040, 4'h0, 1);  // MW0_CTRL(32 PACKING , 422)
 mov_dw (MEM_WR, rbase_w+MW0_AD,     32'h7000_0000, 4'h0, 1);  // MW0_AD
 mov_dw (MEM_WR, rbase_w+MW0_SZ,     32'h0000_0000, 4'h0, 1);  // MW0_SZ
 mov_dw (MEM_WR, rbase_w+MW0_PGE,    32'h0000_0000, 4'h0, 1);  // MW0_PGE
 mov_dw (MEM_WR, rbase_w+MW0_ORG,    32'h0030_0000, 4'h0, 1);  // MW0_ORG
 mov_dw (MEM_WR, rbase_w+MW0_WSRC,   32'hffff_ffff, 4'h0 ,1);  // MW0_WSRC
 mov_dw (MEM_WR, rbase_w+MW0_WKEY,   32'haaaa_5555, 4'h0, 1);  // MW0_KEY
 mov_dw (MEM_WR, rbase_w+MW0_KYDAT,  32'h0000_0005, 4'h0, 1);  // MW0_KYDAT
 mov_dw (MEM_WR, rbase_w+MW0_MASK,   32'hffff_ffff, 4'h0, 1);  // MW0_MASK


//****SET PACKING MODE FOR LINEAR 1 TO YUV_422 at 32BBP *****
 mov_dw (MEM_WR, rbase_w+MW1_CTRL,   32'h3838_0000, 4'h0, 1);  // MW1_CTRL(32 PACKING , 422)
 mov_dw (MEM_WR, rbase_w+MW1_AD,     32'hb050_0000, 4'h0, 1);  // MW1_AD
 mov_dw (MEM_WR, rbase_w+MW1_SZ,     32'h0000_0005, 4'h0, 1);  // MW1_SZ
 mov_dw (MEM_WR, rbase_w+MW1_PGE,    32'h0000_0000, 4'h0, 1);  // MW1_PGE
 mov_dw (MEM_WR, rbase_w+MW1_ORG,    32'h0060_0000, 4'h0, 1);  // MW1_ORG
 mov_dw (MEM_WR, rbase_w+MW1_WSRC,   32'hffff_ffff, 4'h0 ,1);  // MW1_WSRC
 mov_dw (MEM_WR, rbase_w+MW1_WKEY,   32'h5555_aaaa, 4'h0, 1);  // MW1_KEY
 mov_dw (MEM_WR, rbase_w+MW1_KYDAT,  32'h0000_000a, 4'h0, 1);  // MW1_KYDAT
 mov_dw (MEM_WR, rbase_w+MW1_MASK,   32'hffff_ffff, 4'h0, 1);  // MW1_MASK
 
 mov_dw (IO_WR, rbase_io+CONFIG1,   32'h0003_0214, 4'h0, 1);  //Enabling Memory Window 0 & 1 decode 

$fdisplay(fname,"*******************************");
$fdisplay(fname,"****** BEGIN TESTING **********");
$fdisplay(fname,"*******************************\n");
write_index=0; //initialize write index
read_index=0; //initialize read index

 
$fdisplay(fname,"\n**********************************");
$fdisplay(fname,"***  WINDOW 0 , YUV 422 at 32BBP ***");
$fdisplay(fname,"***********************************\n");

 
//WRITING TO THE HOST CACHE CONTROL REGISTER
 mov_dw (MEM_WR, rbase_w+8'h50, 32'h0001_8010, 4'h0, 1); //ENABLE COUNTER, ENABLE YUV CACHE MECHANISIM, YUV MODE

 for (j=0; j<=burst_length; j=j+1)
   begin
    $fdisplay(fname, "\nTEST ROUND=%d", j);
 
   mov_dw (MEM_WR, rbase_w+MW0_ORG,   32'h0030_0000, 4'h0, 1);  // MW0_ORG

    data_in[31:0] = $random;
    addr_in[31:0] = 32'h7000_0000+{j,2'h0};
    write_flag_n=0; //enable writting to memory array

       mov_dw (MEM_WR, addr_in, data_in , 4'h0, j+1); //WRITE

 write_index=0; //reset the memory array index to 0 after each round
 write_flag_n=1;//disable writting to the memory array (since you need the data for comparisson)
 
 
//READ DATA FROM MEMORY
 //SET THE ORG_REG TO POINT TO THE TRANSLATED ADDRESS
 mov_dw (MEM_WR, rbase_w+8'h54, 32'h0, 4'hf, 1); //write to the flush register
 wait_win0_not_busy;
 mov_dw (MEM_WR, rbase_w+MW0_ORG,   32'h0060_0000, 4'h0, 1);  // MW0_ORG

 
 read_addr[31:0] = 32'h7000_0000+{j*2,2'h0};
 read_flag_n=0; //enale writting to the memory read table.
       rd     (MEM_RD, read_addr, ((j*2)+2)); // READ
 read_index=0;
 read_flag_n=1; //disable writting to the memory read table.

 //COMPARISON
 for (i=0; i<=j; i=i+1)
   begin

  yuv_compare (write_mem_table[i],YUV, first_pixel, second_pixel);

//compare the first pixel
 first_read_mem_table[31:0] = read_mem_table[2*i];
 second_read_mem_table[31:0]= read_mem_table[(2*i)+1];
 begin
  if (first_read_mem_table[23:0] == first_pixel)
     $fdisplay(fname, "COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
   
   else
         begin
            fail_count0= fail_count0+1;
            $fdisplay(fname, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
           $fdisplay(results, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});

         end
  end

//compare the second pixel
 begin
  if (second_read_mem_table[23:0] == second_pixel)
     $fdisplay(fname, "COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
   
   else
         begin
            fail_count0= fail_count0+1;
            $fdisplay(fname, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
            $fdisplay(results, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});

         end
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

$fdisplay(fname,"\n**********************************");
$fdisplay(fname,"***  WINDOW 1 , YUV 422 at 32BBP ***");
$fdisplay(fname,"***********************************\n");

 
//WRITING TO THE HOST CACHE CONTROL REGISTER
 mov_dw (MEM_WR, rbase_w+8'h50, 32'h0001_8010, 4'h0, 1); //ENABLE COUNTER, ENABLE YUV CACHE MECHANISIM, YUV MODE

 for (j=0; j<=burst_length; j=j+1)
   begin
    $fdisplay(fname, "\nTEST ROUND=%d", j);
 
    mov_dw (MEM_WR, rbase_w+MW1_ORG,   32'h0060_0000, 4'h0, 1);  // MW1_ORG
    data_in[31:0] = $random;
    addr_in[31:0] = 32'hb050_0000+{j,2'h0};
    write_flag_n=0; //enable writting to memory array
 
       mov_dw (MEM_WR, addr_in, data_in , 4'h0, j+1); //WRITE
 
 write_index=0; //reset the memory array index to 0 after each round
 write_flag_n=1;//disable writting to the memory array (since you need the data for comparisson)
 
 mov_dw(MEM_WR, rbase_w+MW1_MASK, 32'h0, 4'hf, 1);
 
//READ DATA FROM MEMORY
//SET THE ORG_REG TO POINT TO THE TRANSLATED ADDRESS
 wait_win1_not_busy;
 mov_dw (MEM_WR, rbase_w+MW1_ORG,   32'h00c0_0000, 4'h0, 1);  // MW1_ORG

 
 read_addr[31:0] = 32'hb050_0000+{j*2,2'h0};
 read_flag_n=0; //enale writting to the memory read table.
       rd     (MEM_RD, read_addr, ((j*2)+2)); // READ
 read_index=0;
 read_flag_n=1; //disable writting to the memory read table.

 //COMPARISON
 for (i=0; i<=j; i=i+1)
   begin

  yuv_compare (write_mem_table[i],YUV, first_pixel, second_pixel);

//compare the first pixel
 first_read_mem_table[31:0] = read_mem_table[2*i];
 second_read_mem_table[31:0]= read_mem_table[(2*i)+1];
 begin
  if (first_read_mem_table[23:0] == first_pixel)
     $fdisplay(fname, "COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
   
   else
         begin
            fail_count1= fail_count1+1;
            $fdisplay(fname, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
           $fdisplay(results, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});

         end
  end

//compare the second pixel
 begin
  if (second_read_mem_table[23:0] == second_pixel)
     $fdisplay(fname, "COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
   
   else
         begin
            fail_count1= fail_count1+1;
            $fdisplay(fname, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
            $fdisplay(results, "COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});

         end
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


$fdisplay(fname,"\n********************************************************************");
$fdisplay(fname,"***  WINDOW 0 , YUV 422 at 32BBP, PROCESSING THE FIRST  PIXEL ONLY ***");
$fdisplay(fname,"***  WINDOW 1 , YUV 422 at 32BBP, PROCESSING THE SECOND PIXEL ONLY ***");
$fdisplay(fname,"*********************************************************************\n");

 $fdisplay(fname,"\n******************************************");
 $fdisplay(fname," INITIALIZING THE MEMORY TO A KNOWN PATTERN ");
 $fdisplay(fname," ******************************************\n");
  
  init_fb_0(32'h7000_0000, 32'h0060_0000, 32'h5555_5555, (2*burst_length)+2);
  init_fb_1(32'hb050_0000, 32'h00c0_0000, 32'haaaa_aaaa, (2*burst_length)+2);

 
//WRITING TO THE HOST CACHE CONTROL REGISTER
 mov_dw (MEM_WR, rbase_w+8'h50, 32'h0001_8010, 4'h0, 1); //ENABLE COUNTER, ENABLE YUV CACHE MECHANISIM, YUV MODE

 //SET THE ORG_REGs
 mov_dw (MEM_WR, rbase_w+MW0_CTRL,  32'h3838_0000, 4'h0, 1);  // MW0_CTRL(32 PACKING , 422)
 mov_dw (MEM_WR, rbase_w+MW1_CTRL,  32'h3838_0040, 4'h0, 1);

 
 for (j=0; j<=burst_length; j=j+1)
   begin
     data_in_0[31:0] = $random;
     data_in_1[31:0] = $random;
     addr_in_0[31:0] = 32'h7000_0000+{j,2'h0};
     addr_in_1[31:0] = 32'hb050_0000+{j,2'h0};
     mov_dw (MEM_WR, rbase_w+MW0_ORG,   32'h0030_0000, 4'h0, 1);  // MW0_ORG
     mov_dw (MEM_WR, rbase_w+MW1_ORG,   32'h0060_0000, 4'h0, 1);  // MW1_ORG

  
     write_flag_n=0; //enable writting to memory array
         mov_dw (MEM_WR, addr_in_0, data_in_0 , 4'h8, j+1); //WRITE TO WINDOW 0 THE FIRST PIXEL
     write_flag_n=1;

     write_flag_1_n=0;
         mov_dw (MEM_WR, addr_in_1, data_in_1 , 4'h2, j+1); //WRITE TO WINDOW 1 THE SECOND PIXEL
     write_flag_1_n=1;
 
     write_index=0; //reset the memory array index to 0 after each round
     write_index_1=0; //reset the memory array index to 0 after each round
 

$fdisplay(fname, "\n READ FROM WINDOW 0 \n");

//READ DATA FROM WINDOW 0
//SET THE ORG_REG TO POINT TO THE TRANSLATED ADDRESS
 mov_dw (MEM_WR, rbase_w+8'h54, 32'h0, 4'hf, 1); //write to the flush register
 wait_win0_not_busy;
 wait_win1_not_busy;
 mov_dw (MEM_WR, rbase_w+MW0_ORG,   32'h0060_0000, 4'h0, 1);  // MW0_ORG
 mov_dw (MEM_WR, rbase_w+MW1_ORG,   32'h00c0_0000, 4'h0, 1);  // MW1_ORG
 
 read_addr[31:0] = 32'h7000_0000+{j*2,2'h0};
 read_index=0;
 read_flag_n=0; //enale writting to the memory read table.
       rd     (MEM_RD, read_addr, (2*j)+2); // READ
 read_flag_n=1; //disable writting to the memory read table.

 //COMPARISON
 for (i=0; i<=j; i=i+1)
   begin

  yuv_compare (write_mem_table[i],YUV, first_pixel, second_pixel);

//compare the first pixel
 first_read_mem_table[31:0] = read_mem_table[2*i];
 second_read_mem_table[31:0]= read_mem_table[(2*i)+1];

 begin
  if (first_read_mem_table[23:0] == first_pixel)
     $fdisplay(fname,"COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
   
   else
         begin
            fail_count0= fail_count0+1;
            $fdisplay(fname,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
           $fdisplay(results,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       first_pixel, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});

         end
  end

//compare the second pixel
   begin
     if (second_read_mem_table[23:0] == 24'h5555_55)
      $fdisplay(fname,"COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        24'h5555_55, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
   
   else
         begin
            fail_count0= fail_count0+1;
            $fdisplay(fname,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       24'h5555_55, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
           $fdisplay(results,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       24'h5555_55, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});

         end
   end
  end

$fdisplay(fname, "\n READ FROM WINDOW 1 \n");


//READ DATA FROM WINDOW 1
 read_addr[31:0] = 32'hb050_0000+{j*2,2'h0};
 read_index=0;
 read_flag_n=0; //enale writting to the memory read table.
       rd     (MEM_RD, read_addr, (2*j)+2); // READ
 read_flag_n=1; //disable writting to the memory read table.
 
 //COMPARISON
 for (i=0; i<=j; i=i+1)
   begin
 
  yuv_compare (write_mem_table_1[i],YUV, first_pixel, second_pixel);
 
//compare the first pixel
 first_read_mem_table[31:0] = read_mem_table[2*i];
 second_read_mem_table[31:0]= read_mem_table[(2*i)+1];
 begin
  if (first_read_mem_table[23:0] == 24'haaaa_aa)
     $fdisplay(fname,"COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        24'haaaa_aa, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
  
   else
         begin
            fail_count1= fail_count1+1;
            $fdisplay(fname,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       24'haaaa_aa, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});
           $fdisplay(results,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       24'haaaa_aa, first_read_mem_table[23:0], read_addr+{(2*i),2'h0});

         end
  end
 
//compare the second pixel
   begin
     if (second_read_mem_table[23:0] == second_pixel)
      $fdisplay(fname,"COMPARISON PASSED, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                        second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
 
   else
         begin
            fail_count1= fail_count1+1;
            $fdisplay(fname,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});
            $fdisplay(results,"COMPARISON FAILED!!!!, EXPECTED=%h ACTUAL=%h AT ADDR=%h",
                       second_pixel, second_read_mem_table[23:0], read_addr+{((2*i)+1),2'h0});

         end
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
  $fdisplay(results, "            YUV_32_422 TEST END               ");
  $fdisplay(results, "*******************************************");
  $fdisplay(results, "*******************************************\n");
 

 
 
 REV2_STIM.close_file("hb_test_result/yuv_32_422.res"); //close the dump file.

  end
endtask
