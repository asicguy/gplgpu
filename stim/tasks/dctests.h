///// defines task for all DC_ tests 
////  this file is a part of task_file.h (included)
/// tasks in this file can be run with WRAMs used as regular DRAMs



//////////////////////////////////////////////////////////////////////////
task dc_testzoom;
begin
$display ("initializing dc_testzoom  ");
$display ("TEST COUNT=%d", TEST_COUNT);
          /* Enable all address decoding. Put this in front of every task */
  mov_dw(IO_WR, rbase_io+CONFIG1, 32'h00ff_ff14, 4'h0, 1 );
//->discon_sclk;  // moved to here to avoid trigger. two events (conn and discon)
`ifdef DEL_SAMPLING
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0050_0000, 4'h1, 1 ); // no wait states
`else
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0010_0000, 4'h1, 1 ); // no wait states
`endif

mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_ff00, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h3000_0000, 4'h0, 1); // stop crt
mov_dw (MEM_WR, rbase_g+INT_VCNT, 32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+INT_HCNT, 32'h0000_000f, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+DB_ADR,   32'h003f_fc70, 4'h0, 1); //start from 512 m.l 
mov_dw (MEM_WR, rbase_g+DB_PTCH,  32'h0000_03f0, 4'h0, 1); 

mov_dw (MEM_WR, rbase_g+CRT_HAC,  32'h0000_0040, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_HBL,  32'h0000_0080, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_HFP,  32'h0000_0010, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_HS,   32'h0000_0020, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VAC,  32'h0000_0012, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_VBL,  32'h0000_0003, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VFP,  32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VS,   32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_BORD, 32'h0001_0010, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_ZOOM, 32'h000f_000f, 4'h0, 1);  // x16
/// clear interrupt register
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts
// start crt
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0170, 4'h0, 1);  // 
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0100, 4'h0, 1); // refr+
$display ("CRT set for dc_testzoom  ");
$display ("TEST COUNT=%d",TEST_COUNT);
#(320*hclk);
$display ("reading interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0100, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt 
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts

end
endtask


////////////////////////// CRT TEST COUNT ////////////////////////////

task dc_hvcount;
reg[18:0] ind;
begin
$display ("initializing dc_hvcount ");
$display ("set CRT for dc_hvcount checking xyaddr,pages requested ");
$display ("TEST COUNT=%d", TEST_COUNT);
          /* Enable all address decoding. Put this in front of every task */
  mov_dw(IO_WR, rbase_io+CONFIG1, 32'h00ff_ff00, 4'h0, 1 );
//->discon_sclk;
`ifdef DEL_SAMPLING
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0050_0000, 4'h1, 1 ); // no wait states
`else
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0010_0000, 4'h1, 1 ); // no wait states
`endif


// initialize memory
// end of sec bank -32 pages
// assumes memory is initialized to something


mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_000f, 4'h1, 1); // stop crt 
mov_dw (MEM_WR, rbase_g+INT_VCNT, 32'h0000_0000, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+INT_HCNT, 32'h0000_0002, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+DB_ADR,   32'h01ff_ff00, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+DB_PTCH,  32'h0000_00f0, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_HAC,  32'h0000_007b, 4'h0, 1);//123 clk->16+14+3/4p 
mov_dw (MEM_WR, rbase_g+CRT_HBL,  32'h0000_000f, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_HFP,  32'h0000_0008, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_HS,   32'h0000_0008, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VAC,  32'h0000_0001, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_VBL,  32'h0000_0002, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VFP,  32'h0000_0000, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VS,   32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_BORD, 32'h0000_0000, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_ZOOM, 32'h0000_0000, 4'h0, 1);
//->dc_wav;

/// clear interrupt register
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts
mov_dw(MEM_WR,rbase_i+GINTM,32'h0001_0003, 4'h0, 1);  // unmask crt interrupts
$display ("reading interrupt reg - cleared");
rd(MEM_RD, rbase_i+GINTP,1);
//start crt in testmode
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h8001_0070, 4'h0, 1); //  noBT 
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'hffff_ffff, 4'h0, 1); // dc on 
                                                      // rest of it don't care 
$display (" toggling yx addr requested , pages requested");
#(450*hclk);
$display ("reading interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt 
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts


$display ("set CRT for dc_hvcount checking pinl_count ");
mov_dw (MEM_WR, rbase_g+CRT_VAC,  32'h0000_0fff, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_HAC,  32'h0000_fffc, 4'h0, 1);//pinl max
//start crt in testmode
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h8001_0070, 4'h0, 1); //  noBT 
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'hffff_ffff, 4'h0, 1); // dc on 
                                                      // rest of it don't care 
$display ("checking pinl_count, linfr");
#(20*hclk);
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt 
#(20*hclk);
$display ("reading interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts

$display ("set CRT for dc_hvcount checking vcounter,hcounter, vicount");
$display ("run several frames");


mov_dw (MEM_WR, rbase_g+INT_VCNT, 32'h0000_0000, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+INT_HCNT, 32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+DB_ADR,   32'h0000_0000, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+DB_PTCH,  32'h0000_0100, 4'h0, 1); 
mov_dw (MEM_WR, rbase_g+CRT_HAC,  32'h0000_0004, 4'h0, 1);//small
mov_dw (MEM_WR, rbase_g+CRT_HBL,  32'h0000_0010, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_HFP,  32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_HS,   32'h0000_0002, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VAC,  32'h0000_0002, 4'h0, 1);// to see h.blank 
mov_dw (MEM_WR, rbase_g+CRT_VBL,  32'h0000_0002, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VFP,  32'h0000_0000, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_VS,   32'h0000_0001, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_BORD, 32'h0000_0002, 4'h0, 1);
mov_dw (MEM_WR, rbase_g+CRT_ZOOM, 32'h0000_0000, 4'h0, 1);

//start crt in testmode
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h8001_0070, 4'h0, 1); //  noBT 
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'hffff_ffff, 4'h0, 1); // dc on from DRAM
                                                      // rest of it don't care 
#(120*hclk);
$display ("reading and clearing interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts
rd(MEM_RD, rbase_i+GINTP,1);
#(120*hclk);
$display("next frame");
$display ("reading interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
#(150*hclk);
$display("last frame");
$display ("reading interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt 
$display ("reading interrupt reg");
rd(MEM_RD, rbase_i+GINTP,1);
$display ("reading interrupt reg test_reg off");
rd(MEM_RD, rbase_i+GINTP,1);
mov_dw(MEM_WR,rbase_i+GINTP,32'h0000_0000, 4'he, 1);  // clear interrupts

$display ("CRT dc_hvcount done");
$display ("TEST COUNT=%d", TEST_COUNT);
#(hclk);

end
endtask



/////// dc_test for 640 480 x32
            
task dc_640x32;

begin
$display ("initializing dc_test640 ");
//$display ("TEST COUNT=%d", TEST_COUNT);
          /* Enable all address decoding to registers.
            Put this in front of every task */

  mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0000_3f00, 4'h0, 1 );
//->discon_sclk;
`ifdef DEL_SAMPLING
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0050_0000, 4'h1, 1 ); // no wait states
`else
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0010_0000, 4'h1, 1 ); // no wait states
`endif


mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt & dc 


mov_dw(MEM_WR,rbase_g+INT_VCNT,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+INT_HCNT,32'h0,4'h0,1);
//mov_dw(MEM_WR,rbase_g+DB_ADR,32'h7f_fff0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_ADR,32'h10,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_PTCH,32'ha00,4'h0,1);

//mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h280,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h140,4'h0,1);  // half above
//mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h11,4'h0,1);  //temp vshort

mov_dw(MEM_WR,rbase_g+CRT_HBL,32'h28,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HFP,32'h4,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HS,32'h18,4'h0,1);

//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h1e0,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h2c,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VFP,32'ha,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VS,32'h4,4'h0,1);

// mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h30,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h3,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h2,4'h0,1);
//  mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h1,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h0,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VS,32'h1,4'h0,1);

mov_dw(MEM_WR,rbase_g+CRT_BORD,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_ZOOM,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_1CON,32'h1_0170,4'h0,1); //BT on
mov_dw(MEM_WR,rbase_g+CRT_2CON,32'h2000_0100,4'h0,1);


$display ("DC_SET set for dc_test640 ");
//$display ("TEST COUNT=%d", TEST_COUNT);
end
endtask


/////// dc_test for 1280 x24
            
task dc_1280x24;

begin
$display ("initializing dc_test1280x24 ");
//$display ("TEST COUNT=%d", TEST_COUNT);
  mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0013_3f00, 4'h0, 1 );
//->discon_sclk;
`ifdef DEL_SAMPLING
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0050_0000, 4'h1, 1 ); // no wait states
`else
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0010_0000, 4'h1, 1 ); // no wait states
`endif



mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0001_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt & dc 


mov_dw(MEM_WR,rbase_g+INT_VCNT,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+INT_HCNT,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_ADR,32'h7f_fff0,4'h0,1);
//mov_dw(MEM_WR,rbase_g+DB_ADR,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_PTCH,32'hf00,4'h0,1);

mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h3c0,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h11,4'h0,1);  //temp vshort

mov_dw(MEM_WR,rbase_g+CRT_HBL,32'h60,4'h0,1);  // about 1us only
mov_dw(MEM_WR,rbase_g+CRT_HFP,32'h4,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HS,32'h18,4'h0,1);

//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h1e0,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h2c,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VFP,32'ha,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VS,32'h4,4'h0,1);

  mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h8,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h2,4'h0,1);
//  mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h1,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h0,4'h0,1);
  mov_dw(MEM_WR,rbase_g+CRT_VS,32'h1,4'h0,1);

mov_dw(MEM_WR,rbase_g+CRT_BORD,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_ZOOM,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_1CON,32'h1_0170,4'h0,1); //BT on
mov_dw(MEM_WR,rbase_g+CRT_2CON,32'h2000_0100,4'h0,1);


$display ("DC_SET set for dc_test1280x24 ");
//$display ("TEST COUNT=%d", TEST_COUNT);
end
endtask

task dc_test_lily;
begin

// mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0000_ff00, 4'h0, 1 );// turn of all windows
//->discon_sclk;

VR.ram_floadh("imfiles/templily32.cap",0,18343);
VR.save_fbmp (0,332,221,"outfiles/lilyref.out",32'h530,2'b10 );

mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0000_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt & dc
 
mov_dw(MEM_WR,rbase_g+INT_VCNT,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+INT_HCNT,32'h0,4'h0,1);

mov_dw(MEM_WR,rbase_g+DB_ADR,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_ADR2,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_PTCH,32'h530,4'h0,1);
 
//64bit ramdac
//mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h53,4'h0,1);//332/2/2 (1/2 of lily imag.)
mov_dw(MEM_WR,rbase_g+CRT_HAC,32'ha6,4'h0,1); // 332/2/1 (1/1 of lily imag.)
//display just 128 pixels in line
// mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h40,4'h0,1); // 128/2/1 (128 pixels of lily )

//orig
mov_dw(MEM_WR,rbase_g+CRT_HBL,32'h2f,4'h0,1); 
mov_dw(MEM_WR,rbase_g+CRT_HFP,32'h3,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HS,32'h0f,4'h0,1);
//shortest
//mov_dw(MEM_WR,rbase_g+CRT_HBL,32'h3,4'h0,1); 
//mov_dw(MEM_WR,rbase_g+CRT_HFP,32'h1,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_HS,32'h01,4'h0,1);


//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h3f,4'h0,1);  //63 small
//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h6e,4'h0,1);  // half 
mov_dw(MEM_WR,rbase_g+CRT_VAC,32'hdd,4'h0,1);  //221 full
//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h44,4'h0,1);  //only 68 lines 


//mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h3,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h24,4'h0,1); //to make vblank for ramdac(smal
mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h14,4'h0,1);//to make vblank for ramdac (full)
// mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h12,4'h0,1);//should be ok for 128 pix 

mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h1,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_VS,32'h1,4'h0,1);
 
mov_dw(MEM_WR,rbase_g+CRT_BORD,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_ZOOM,32'h0,4'h0,1);


/// start crt but no refresh yet
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0000_0170, 4'h0, 1);  //  BT is NA, ninter
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h1, 1); // no refr, no split
                                                           // mem not modyf.
//wait for crt to transfer valid origins
rd(MEM_RD,rbase_g+DB_ADR,1);
while (test_reg[31] | test_reg[31] ===1'bx) rd(MEM_RD,rbase_g+DB_ADR,1);
//turn on refresh now

mov_dw(MEM_WR,rbase_g+CRT_2CON,32'h2000_0100,4'h0,1);
 

$display ("DC_SET set for dc_testlily ");
//save_dcout("outfiles/dc_lily.out"); //used for direct
//save_vdac_frame("outfiles/vdac_lilylt.out"); //used for LUT
// save_vdac_frame("outfiles/vdac_lilycr.out"); //used for LUT+cursor
end
endtask

// the shortest possible task to put valid data on the crt output pins
// it fills all fifo locations with data
task dcfifoinit;
begin
$display ("initializing dcfifoinit ");
$display ("TEST COUNT=%d", TEST_COUNT);
          /* Enable all address decoding. Put this in front of every task */
  mov_dw(IO_WR, rbase_io+CONFIG1, 32'h00ff_ff00, 4'h0, 1 );
//->discon_sclk;
`ifdef DEL_SAMPLING
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0050_0000, 4'h1, 1 ); // no wait states
`else
 mov_dw(IO_WR, rbase_io+CONFIG2, 32'h0010_0000, 4'h1, 1 ); // no wait states
`endif



mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0000_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt & dc 

 
mov_dw(MEM_WR,rbase_g+INT_VCNT,32'hffff_ffff,4'h0,1); // dont care actually
mov_dw(MEM_WR,rbase_g+INT_HCNT,32'hffff_ffff,4'h0,1);
 
mov_dw(MEM_WR,rbase_g+DB_ADR,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_PTCH,32'h010,4'h0,1);  // smallest 
 
mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h20,4'h0,1); // for four 8p requests
                                        // 4 short lines, all loaded on blank
mov_dw(MEM_WR,rbase_g+CRT_HBL,32'h8,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HFP,32'h1,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HS,32'h02,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h04,4'h0,1); 
mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h2,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_VS,32'h1,4'h0,1);
 
mov_dw(MEM_WR,rbase_g+CRT_BORD,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_ZOOM,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_1CON,32'h0_0070,4'h0,1); //BT off
mov_dw(MEM_WR,rbase_g+CRT_2CON,32'h2000_0100,4'h0,1);
#(150*hclk);

mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0000_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt & dc 

end
endtask


task dc_test_lily555;
begin

mov_dw(IO_WR, rbase_io+CONFIG1, 32'h0000_ff00, 4'h0, 1 );// turn of all windows
//->discon_sclk;

VR.ram_floadh("imfiles/lily_1555.mem",0,14144);
VR.save_fbmp (0,512,221,"outfiles/lilyref555.out",32'h400,2'b01 );


mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0000_0000, 4'h0, 1);  //  both just
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h0, 1); // stop crt & dc
 
mov_dw(MEM_WR,rbase_g+INT_VCNT,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+INT_HCNT,32'h0,4'h0,1);

mov_dw(MEM_WR,rbase_g+DB_ADR,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+DB_PTCH,32'h400,4'h0,1);
 
//64bit ramdac, 16bpp image
mov_dw(MEM_WR,rbase_g+CRT_HAC,32'h80,4'h0,1);//512pix/4 (1/1 of lily imag.)

mov_dw(MEM_WR,rbase_g+CRT_HBL,32'h2f,4'h0,1); 
mov_dw(MEM_WR,rbase_g+CRT_HFP,32'h3,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_HS,32'h0f,4'h0,1);
//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h3f,4'h0,1);  //63 small
mov_dw(MEM_WR,rbase_g+CRT_VAC,32'h6e,4'h0,1);  // half 
//mov_dw(MEM_WR,rbase_g+CRT_VAC,32'hdd,4'h0,1);  //221 full
//mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h3,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_VBL,32'h24,4'h0,1); //to make vblank for ramdac
mov_dw(MEM_WR,rbase_g+CRT_VFP,32'h1,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_VS,32'h1,4'h0,1);
 
mov_dw(MEM_WR,rbase_g+CRT_BORD,32'h0,4'h0,1);
mov_dw(MEM_WR,rbase_g+CRT_ZOOM,32'h0,4'h0,1);


/// start crt but no refresh yet
mov_dw (MEM_WR, rbase_g+CRT_1CON, 32'h0000_0170, 4'h0, 1);  //  BT is NA, ninter
mov_dw (MEM_WR, rbase_g+CRT_2CON, 32'h2000_0000, 4'h1, 1); // no refr, no split
                                                           // mem not modyf.
//wait for crt to transfer valid origins
rd(MEM_RD,rbase_g+DB_ADR,1);
while (test_reg[31] | test_reg[30]) rd(MEM_RD,rbase_g+DB_ADR,1);
//turn on refresh now
mov_dw(MEM_WR,rbase_g+CRT_2CON,32'h2000_0100,4'h0,1);
 

$display ("DC_SET set for dc_testlily555 ");
//save_dcout("outfiles/dc_lily.out"); //used for direct
//save_vdac_frame("outfiles/vdac_lilylt.out"); //used for LUT
// save_vdac_frame("outfiles/vdac_lilycr555"); //used for LUT+cursor
//save_vdac_frame("outfiles/vdac_lilycr555d"); //used for direct+cursor
end
endtask

