// Author: Hugues CREUSY
// February 2004
// Verilog model
// project: M25P40 25 MHz,
// release: 1.1



// These Verilog HDL models are provided "as is" without warranty
// of any kind, included but not limited to, implied warranty
// of merchantability and fitness for a particular purpose.





`timescale 1ns/1ns
`include "parameter.v"

module m25p40_driver (clk, din, cs_valid, hard_protect, hold);


   output clk; 
   reg clk;
   
   output din; 
   reg din;
   
   output cs_valid; 
   reg cs_valid;
   
   output hard_protect; 
   reg hard_protect;
   
   output hold; 
   reg hold;

   initial
   begin : init_driver
/*      $monitor($time,,,
               "C = %b D = %b _S = %b _W = %b _H = %b",
               clk,din,cs_valid,hard_protect,hold);
*/      
      clk = 1'b0 ; 
      din = 1'b1 ; 
      cs_valid = 1'b1 ; 
      hold = 1'b1 ; 
      hard_protect = 1'b1 ; 
      
   end
   
   always
   begin : driver
      parameter thigh = 20; 
      parameter tlow = 20; 
      #100000
      

// Checking memory initialization at higher speed
      fast_read( thigh,tlow, 24'b111111111111111111111111, 2); 
      #(5 * tlow); 
      fast_read( thigh,tlow, 24'b000000010000000000000000, 15); 
      #(5 * tlow); 
      fast_read( thigh,tlow, 24'b000000100000000000000000, 15); 
      #(5 * tlow); 
      fast_read( thigh,tlow, 24'b000000110000000000000000, 15); 
      #(5 * tlow); 

// hold condition test during a WREN
      hold_wren( thigh,tlow); 
      #(5 * tlow); 
      rdsr( thigh,tlow, 1); 
      #(5 * tlow); 
      wrdi( thigh,tlow); 
      #(5 * tlow); 
      rdsr( thigh,tlow, 1); 
      #(5 * tlow); 

// WREN/WRDI test
      wren( thigh,tlow); 
      #(5 * tlow); 
      rdsr( thigh,tlow, 1); 
      #(5 * tlow); 
      wrdi( thigh,tlow); 
      #(5 * tlow); 
      rdsr( thigh,tlow, 1); 
      #(5 * tlow); 

// WRSR : Protect All sectors + Set SRWD
      wren( thigh,tlow); 
      #(5 * tlow); 
      wrsr( thigh,tlow, 8'b11111111); 
      #14965000;     // WRSR not completed if Tw < 15ms
// WIP Polling during Prog Cycle
      rdsr(thigh, tlow, 120); 
      #(5 * tlow); 

// WRSR canceled by HPM (SRWD bit is still set)
      wren( thigh,tlow);
      #(5 * tlow);
      hard_protect <= 1'b0 ;
      #(5 * tlow); 
      wrsr( thigh,tlow,8'b00000000);
      #(5 * tlow);
      hard_protect <= 1'b1 ;
      #(5 * tlow);   // All sectors are still protected

// OPCODES sent during Deep Power Down Mode will have no effect on device
      dp( thigh,tlow); 
      #3001;               // Deep Power Down Mode is active after 3us
      wren( thigh,tlow); 
      #(5 * tlow); 
      rdsr( thigh,tlow, 1); 
      #(5 * tlow); 
      pp( thigh,tlow, 24'b000011111100001111000011, 8'b10101010, 15); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000011111100001111000011, 15); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000011111100001111000011, 15); 
      #(5 * tlow); 
      be(thigh, tlow); 
      #(5 * tlow); 
      se(thigh, tlow, 24'b000000000000000000000000); 
      #(5 * tlow); 
      fast_read( thigh,tlow, 24'b111111111111111111111111, 15); 
      #(5 * tlow); 
      wrdi(thigh, tlow); 
      #(5 * tlow); 
      res(thigh, tlow); 
      #3001;               // Device is returned into StandBy Mode
      
      read_es(thigh, tlow); 
      #(5 * tlow); 
      read_es(thigh, tlow); 
      #(5 * tlow); 

// Page prog on protected sectors will have no effect
      pp(thigh, tlow, 24'b000011111100001111000011, 8'b10101010, 15); 
      #(5 * tlow); 
// Device content still virgin
      fast_read( thigh,tlow, 24'h0FC3C3, 15); 
      #(5 * tlow); 
      
// WRSR to reset BP(i) bits ; All sectors unprotected
      wren(thigh, tlow); 
      #(5 * tlow); 
      wrsr(thigh, tlow, 8'b00000000); 
      #14965000;                          // WRSR not completed if Tw < 15ms
      rdsr(thigh, tlow, 120);             // WIP polling during Write progress
      #(5 * tlow);                        // device is not protected anymore

// Bulk Erase Instruction Check
      wren(thigh, tlow); 
      #(5 * tlow); 
      be(thigh, tlow);                          // Erase all device
      #`Tbase ; // # accept only 32bit wide delays
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ; // # accept only 32bit wide delays
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #(`Tbase+1)  ;// and 10s width is > 32 bits

      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'h00000, 8'h00, 1);   // prog first byte of sector 0
      #5000001; 
      fast_read( thigh,tlow, 24'h3FFFF, 3);   // read last and 2 first byte of memory 
      #(5 * tlow);

      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'h2FFFF, 8'h88, 255);   // prog last row of sector 2 except 1 byte to check roll over in write inside a page
      #5000001;   // 5ms
      fast_read( thigh,tlow, 24'h2FFFD, 3);   // read 3 last byte of sector 2
      #(5 * tlow);
      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'h30000, 8'hAA, 256);   // prog first row of sector 3
      #5000001; 
      fast_read( thigh,tlow, 24'h2FF00, 512);   // read two previous rows
      #(5 * tlow);

      wren(thigh, tlow); 
      #(5 * tlow); 
      wrsr(thigh, tlow, 8'b00000100);           // protection of sector 3 (30000h to 3FFFFh )
      #15000001;  // 15ms
      rdsr(thigh, tlow, 1);
      #(5 * tlow);

      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'h30000, 8'h55, 256);   // prog first row of sector 3 (protected)
      #5000001; 
      fast_read( thigh,tlow, 24'h2FF00, 512);   // read first row of sector 3 & last row of sector 2
      #(5 * tlow);

      wren(thigh, tlow); 
      #(5 * tlow); 
      se(thigh, tlow, 24'h2FFFF);   // Erase sector 2 (not protected)
      #`Tbase ;
      #`Tbase ;
      #(`Tbase+1) ;      // 3s
      wren(thigh, tlow); 
      #(5 * tlow); 
      se(thigh, tlow, 24'h30000);   // Erase  sector 3 (protected)
      #`Tbase ;
      #`Tbase ;
      #(`Tbase+1) ;      // 3s

      fast_read( thigh,tlow, 24'h2FF00, 1);   // read first byte of last page of sector 2
      #(5 * tlow);
      fast_read( thigh,tlow, 24'h2FFFD, 4);   // read 3 last bytes of sector 2 & first byte of sector 3
      #(5 * tlow);
      fast_read( thigh,tlow, 24'h3FFFF, 3);   // read last byte of sector 3 & first byte of sector 1 to check roll over in read inside memory array
      #(5 * tlow);

      wren(thigh, tlow); 
      #(5 * tlow); 
      wrsr(thigh, tlow, 8'h00);           // Unprotect sector 3
      #15000001;
// End Sector Erase Instruction Check

// deep power down mode AND release from deep power down + read electronic signature
      dp(thigh, tlow); 
      #3001; 
      read_es(thigh, tlow); 
      #1801;      // 1.8us

// READ programmed bytes preceded and followed by one non programmed byte
      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'h00101, 8'b10101010, 10); 
      #4965000; 
      rdsr(thigh, tlow, 120);    //WIP Polling
      #(5 * tlow); 
      
      
// Program 55h on AAh
      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'h00102, 8'b01010101, 8); 
      #4965000; 
      rdsr(thigh, tlow, 120);    // WIP Polling
      #(5 * tlow); 
// READ: AAh+55h=>00h
      fast_read(thigh, tlow, 24'h00100, 12); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'h00100, 12); 
      #(5 * tlow); 

// Page prog of more than 256 bytes in the sectors 1 and 2.
// Note: the PP task sends automatically 00h when byte number is higher than 256
      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'b000000010000000000000000, 8'b01010101, 280); 
      #5010000;   // 5.01ms
      read(2 * thigh, 2 * tlow, 24'b000000010000000000000000, 256); 
      #(5 * tlow); 
      wren(thigh, tlow); 
      #(5 * tlow); 
      pp(thigh, tlow, 24'b000000100000000000000000, 8'b01010101, 280); 
      #5010000; 
      read(2 * thigh, 2 * tlow, 24'b000000100000000000000000, 256); 
      #(5 * tlow); 

// Erase all memory content
      wren(thigh, tlow);
      #(5 * tlow);
      wren(thigh, tlow); 
      #(5 * tlow); 
      be(thigh, tlow); 
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ; 
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #(`Tbase+1) ;     //10s
      
      
      
// protects the fisrt 1/8
      wren(thigh, tlow);
      #(5 * tlow);
      wren(thigh, tlow); 
      #(5 * tlow); 
      wrsr(thigh, tlow, 8'b00000100);  // protect sector 3
      #15001000;        // 15ms
      rdsr(thigh, tlow, 1); 
      #(5 * tlow); 

// Bulk erase on a protected area
      wren(thigh, tlow); 
      wren(thigh, tlow); 
      #(5 * tlow); 
      be(thigh, tlow); 
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ; 
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #(`Tbase+1) ;      //10s
// unprotects memory      
      wren(thigh, tlow); 
      #(5 * tlow); 
      wrsr(thigh, tlow, 8'b00000000);  // unprotect sector 3
      #15001000;        // 15ms
      rdsr(thigh, tlow, 1); 
      #(5 * tlow); 

// Bulk erase on an unprotected device
      wren(thigh, tlow); 
      #(5 * tlow);
      wren(thigh, tlow); 
      #(5 * tlow); 
      be(thigh, tlow); 
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ; 
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #`Tbase ;
      #(`Tbase+1) ;      //10s

// READ again to check BE
      wren(thigh, tlow);
      #(5 * tlow);
      read(2 * thigh, 2 * tlow, 24'b000011111100001111000010, 17); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000000000000000000000000, 15); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000000111111111111111111, 15); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000000111111111100000000, 15); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000000010000000000000000, 1); 
      #(5 * tlow); 
      read(2 * thigh, 2 * tlow, 24'b000000100000000000000000, 1); 
      #(5 * tlow); 
      #100000 $finish; 
   end 

    
      task stop;
            input t0; 
            time t0;
            input t1; 
            time t1;

            begin
               hold <= 1'b1 ; 
               
               #t0 hold <= 1'b0 ; 
               #t1 hold <= 1'b1 ; 
            end
      endtask
   
      task hold_wren;
         input t1; 
         time t1;
         input t0; 
         time t0;
         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            hold <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
               for(i = 0; i <= 17; i = i + 1)
               begin
                  if (i == 0)
                  begin
                     cs_valid <= 1'b0 ; 
                     hold <= 1'b1 ; 
                     din <= 1'b0 ; 
                  end 
                  if ((i == 5) || (i == 6))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  if (i == 12)
                  begin
                     cs_valid <= 1'b1 ; 
                  end 
                  #((t1 / 2)); 
                  if (i == 7)
                  begin
                     hold <= 1'b0 ; 
                  end 
                  #((t1 / 2)); 
               end
   
            hold <= 1'b0 ; 
            clk <= 1'b0 ; 
            #(t0 / 4); 
   
            hold <= 1'b1 ; 
            clk <= 1'b0 ; 
         end
      endtask
   
      task waitc;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input n; 
         integer n;
         integer i;
   
         begin
               for(i = 0; i <= (n - 1); i = i + 1)
               begin
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
         end
      endtask
   
   
      task rdsr;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input n; 
         integer n;

         integer i;

         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
            if (n == 1)
            begin
                  for(i = 0; i <= 15; i = i + 1)
                  begin
                     if ((i == 5) || (i == 7))
                     begin
                        din <= 1'b1 ; 
                     end
                     else
                     begin
                        din <= 1'b0 ; 
                     end 
                     clk <= 1'b0 ; 
                     #t0; 
                     clk <= 1'b1 ; 
                     #t1; 
                  end
            end
            else
            begin
                  for(i = 0; i <= (8 * (n + 1) - 1); i = i + 1)
                  begin
                     if ((i == 5) || (i == 7))
                     begin
                        din <= 1'b1 ; 
                     end
                     else
                     begin
                        din <= 1'b0 ; 
                     end 
                     clk <= 1'b0 ; 
                     #t0; 
                     clk <= 1'b1 ; 
                     #t1; 
                  end
            end 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
   
      task rdsr_11;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input n; 
         integer n;

         integer i;

         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b1 ; 
            #(t0/2); 
            cs_valid <= 1'b0 ; 
            #(t0/2);
            clk <= 1'b0 ; 
            if (n == 1)
            begin
                  for(i = 0; i <= 15; i = i + 1)
                  begin
                     if ((i == 5) || (i == 7))
                     begin
                        din <= 1'b1 ; 
                     end
                     else
                     begin
                        din <= 1'b0 ; 
                     end 
                     clk <= 1'b0 ; 
                     #t0; 
                     clk <= 1'b1 ; 
                     #t1; 
                  end
            end
            else
            begin
                  for(i = 0; i <= (8 * (n + 1) - 1); i = i + 1)
                  begin
                     if ((i == 5) || (i == 7))
                     begin
                        din <= 1'b1 ; 
                     end
                     else
                     begin
                        din <= 1'b0 ; 
                     end 
                     clk <= 1'b0 ; 
                     #t0; 
                     clk <= 1'b1 ; 
                     #(t1/2); 
                  end
            end 
            cs_valid <= 1'b1; 
            #(t1/2); 
            clk <= 1'b0 ;
         end
      endtask  
   
      task wrsr;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input[(`NB_BIT_DATA-1):0] status; 

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 15; i = i + 1)
               begin
                  if (i == 7)
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i >= 8) && ((status[15 - i]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask


      task wren;
         input t1; 
         time t1;
         input t0; 
         time t0;

         integer i;

         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 0)
                  begin
                     cs_valid <= 1'b0 ; 
                     din <= 1'b0 ; 
                  end 
                  if ((i == 5) || (i == 6))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task wrdi;
         input t1; 
         time t1;
         input t0; 
         time t0;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 5)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task read;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input[(`NB_BIT_ADD_MEM-1):0] address; 
         input n; 
         integer n;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 0)
                  begin
                  end 
                  if ((i == 6) || (i == 7))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 23; i = i + 1)
               begin
                  if ((address[23 - i]) == 1'b1)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= (8 * n - 1); i = i + 1)
               begin
                  if (i == 0)
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task fast_read;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input[(`NB_BIT_ADD_MEM-1):0] address; 
         input n; 
         integer n;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 0)
                  begin
                  end 
                  if ((i == 4) || (i == 6) || (i == 7))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 23; i = i + 1)
               begin
                  if ((address[23 - i]) == 1'b1)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 7; i = i + 1)
               begin
                  din <= 1'b0 ; 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= (8 * n - 1); i = i + 1)
               begin
                  if (i == 0)
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task fast_read_no_select ;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input[(`NB_BIT_ADD_MEM-1):0] address; 
         input n; 
         integer n;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 0)
                  begin
                  end 
                  if ((i == 4) || (i == 6) || (i == 7))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 23; i = i + 1)
               begin
                  if ((address[23 - i]) == 1'b1)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 7; i = i + 1)
               begin
                  din <= 1'b0 ; 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= (8 * n - 1); i = i + 1)
               begin
                  if (i == 0)
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 0'b1 ; 
         end
      endtask
      
      
   
      task pp;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input[(`NB_BIT_ADD_MEM-1):0] address; 
         input[(`NB_BIT_DATA-1):0] data; 
         input n; 
         integer n;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  // send  Instruction Byte
                  if (i == 6)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 23; i = i + 1)
               begin
                  // send Address Byte of the Page to Program
                  if ((address[23 - i]) == 1'b1)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= (8 * n - 1); i = i + 1)
               begin
                  // send Data Bytes to Program
                  if (i > 2047)
                  begin
                     din <= 1'b0 ; 
                  end
                  else if ((i % 8 == 0) && (i != (8 * n)) && ((data[7]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 1) && ((data[6]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 2) && ((data[5]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 3) && ((data[4]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 4) && ((data[3]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 5) && ((data[2]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 6) && ((data[1]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else if ((i % 8 == 7) && ((data[0]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
      task se;
         input t1; 
         time t1;
         input t0; 
         time t0;

         input[(`NB_BIT_ADD_MEM-1):0] address; 

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
            clk <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 0 || i == 1 || i == 3 || i == 4)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 23; i = i + 1)
               begin
                  if (((address[23 - i]) == 1'b1))
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task be;
         input t1; 
         time t1;
         input t0; 
         time t0;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 0 || i == 1 || i == 5 || i == 6 || i == 7)
                  begin
                     din <= 1'b1 ; 
                  end
                  else
                  begin
                     din <= 1'b0 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task dp;
         input t1; 
         time t1;
         input t0; 
         time t0;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 1 || i == 5 || i == 6)
                  begin
                     din <= 1'b0 ; 
                  end
                  else
                  begin
                     din <= 1'b1 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task res;
         input t1; 
         time t1;
         input t0; 
         time t0;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 1 || i == 3 || i == 5)
                  begin
                     din <= 1'b0 ; 
                  end
                  else
                  begin
                     din <= 1'b1 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask
   
   
      task read_es;
         input t1; 
         time t1;
         input t0; 
         time t0;

         integer i;
   
         begin
            cs_valid <= 1'b1 ; 
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b0 ; 
               for(i = 0; i <= 7; i = i + 1)
               begin
                  if (i == 1 || i == 3 || i == 5)
                  begin
                     din <= 1'b0 ; 
                  end
                  else
                  begin
                     din <= 1'b1 ; 
                  end 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
               for(i = 0; i <= 31; i = i + 1)
               begin
                  din <= 1'b0 ; 
                  clk <= 1'b0 ; 
                  #t0; 
                  clk <= 1'b1 ; 
                  #t1; 
               end
            clk <= 1'b0 ; 
            #t0; 
            cs_valid <= 1'b1 ; 
         end
      endtask


      task wrsr_wc0;  // FOR DEBUG ONLY HC
               input t1; 
               time t1;
               input t0; 
               time t0;
      
               input[(`NB_BIT_DATA-1):0] status; 
      
               integer i;
         
               begin
                  hard_protect <=1'b0;
                  cs_valid <= 1'b1 ; 
                  clk <= 1'b0 ; 
                  #t0; 
                  hard_protect <=1'b1;
                  #(t0/3); 
                  cs_valid <= 1'b0 ; 
                  clk <= 1'b0 ; 
                     for(i = 0; i <= 15; i = i + 1)
                     begin
                        if (i == 2)
                           begin
			   // hard_protect <=1'b0;
			   // din <= 1'b1 ; 
                           end
                        if (i == 7)
                           begin
                           //hard_protect <=1'b0;
                           din <= 1'b1 ; 
                           end
                        else if ((i >= 8) && ((status[15 - i]) == 1'b1))
                           begin
                           hard_protect <=1'b1;
                           din <= 1'b1 ; 
                           end
                        else
                           begin
                           din <= 1'b0 ; 
                           end 
                        clk <= 1'b0 ; 
                        #t0; 
                        clk <= 1'b1 ; 
                        #t1; 
                     end 
                  clk <= 1'b0 ; 
                  #t0; 
                  cs_valid <= 1'b1 ; 
                  
               end
      endtask
      task wren_wc0;  // FOR DEBUG ONLY HC
               input t1; 
               time t1;
               input t0; 
               time t0;
      
               integer i;
      
               begin
                  cs_valid <= 1'b1 ; 
                  clk <= 1'b0 ; 
                  #t0; 
                     for(i = 0; i <= 7; i = i + 1)
                     begin
                        if (i == 0)
                        begin
                           cs_valid <= 1'b0 ; 
                           din <= 1'b0 ; 
                        end 
                        if ((i == 5) || (i == 6))
                        begin
                           hard_protect <= 1'b0;
                           din <= 1'b1 ; 
                        end
                        else
                        begin
                           din <= 1'b0 ; 
                        end 
                        clk <= 1'b0 ; 
                        #t0; 
                        hard_protect <= 1'b1;
                        clk <= 1'b1 ; 
                        #t1; 
                     end
                  clk <= 1'b0 ; 
                  #t0; 
                  cs_valid <= 1'b1 ; 
               end
      endtask

endmodule


