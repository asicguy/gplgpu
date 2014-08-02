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

module internal_logic (c, d, w, s, hold, data_to_read, q, data_to_write, page_add_index, add_mem, write_op, read_op, be_enable, se_enable, add_pp_enable, pp_enable, read_enable, data_request, srwd_wrsr,write_protect, wrsr);
   ////////////////////////////////
   // declaration of the parameters
   ////////////////////////////////
   input c; 
   input d; 
   input w; 
   input s; 
   input hold; 
   input[(`NB_BIT_DATA - 1):0] data_to_read; 
   
   output q; 
   reg q;

   output[(`NB_BIT_DATA - 1):0] data_to_write;
   reg[(`NB_BIT_DATA - 1):0] data_to_write;
   
   output[(`LSB_TO_CODE_PAGE - 1):0] page_add_index;    // position to write data_to_write inside the page
   reg[(`LSB_TO_CODE_PAGE - 1):0] page_add_index;

   output[(`NB_BIT_ADD_MEM - 1):0] add_mem; 
   reg[(`NB_BIT_ADD_MEM - 1):0] add_mem;

   output write_op; 
   reg write_op;

   output read_op; 
   reg read_op;

   output be_enable; 
   reg be_enable;

   output se_enable; 
   reg se_enable;

   output add_pp_enable; 
   reg add_pp_enable;
   
   output pp_enable; 
   reg pp_enable;
   
   output read_enable; 
   reg read_enable;

   output data_request; 
   reg data_request;
   
   output srwd_wrsr; 
   reg srwd_wrsr;
      
   output write_protect; 
   reg write_protect;
   
   output wrsr;
   reg wrsr;
   
   
   ///////////////////////////////////////////////
   // declaration of internal variables
   ///////////////////////////////////////////////
   reg only_rdsr;
   reg only_res;
   //reg write_protect;
   reg write_protect_toggle;
   reg select_ok;
   reg raz;
   reg byte_ok;
   reg wren;
   reg wrdi;
   reg rdsr;
   reg read_data;
   reg fast_read;
   reg pp;
   reg se;
   reg be;
   reg dp;
   reg res;
   reg q_bis;
   reg protect;
   reg wr_cycle;
   reg hold_cond;
   reg inhib_wren;
   reg inhib_wrdi;
   reg inhib_rdsr;
   reg inhib_wrsr;
   reg inhib_read;
   reg inhib_pp;
   reg inhib_se;
   reg inhib_be;
   reg inhib_dp;
   reg inhib_res;
   reg reset_wel;
   reg wel;
   reg wip;
   reg c_int;

   reg [2:0]   cpt; 
   reg [2:0]   bit_index;       // to allow shift inside a byte 
   reg [2:0]   bit_res;         // to allow shift inside signature
   reg [2:0]   bit_register;    // to allow shift inside status register

   reg [7:0]   data; 
   reg [7:0]   adress_1; 
   reg [7:0]   adress_2; 
   reg [7:0]   adress_3; 
   reg [7:0]   sr_mask; 
   reg [7:0]   signature; 

   reg [(`NB_BIT_DATA-1):0]   wr_latch; 
   reg [(`NB_BIT_DATA-1):0]   page_ini; 
   reg [(`NB_BIT_DATA-1):0]   data_latch;
   reg [(`NB_BIT_DATA-1):0]   register_bis; 
   reg [(`NB_BIT_DATA-1):0]   register_temp;
   reg [(`NB_BIT_DATA-1):0]   status_register;
   
   reg [(`NB_BPI-1):0]              bp; 
   reg [(`NB_BIT_ADD_MEM-1):0]      adress; 
   reg [(`BIT_TO_CODE_MEM-1):0]     cut_add; 
   reg [(`LSB_TO_CODE_PAGE -1) :0]  lsb_adress; 

   integer     byte_cpt;
   integer     int_add; 
   integer    i,j;
   integer     count_enable; 

   time        t_only_res ;
   time t_write_protect_toggle;

   initial
   begin
      ////////////////////////////////////////////
      // Initialization of the internal variables
      ////////////////////////////////////////////
      only_rdsr      = `FALSE;
      only_res       = `FALSE;
      write_protect  = `FALSE;
      select_ok      = `FALSE;
      raz            = `FALSE;
      byte_ok        = `FALSE;

      cpt         = 0;
      byte_cpt    = 0;

      data_to_write  = 8'bxxxxxxxx;
      data_latch     = 8'bxxxxxxxx;
      data_request <= `FALSE;
      
      wren        = `FALSE;
      wrdi        = `FALSE;
      rdsr        = `FALSE;
      wrsr        = `FALSE;
      read_data   = `FALSE;
      fast_read   = `FALSE;
      pp          = `FALSE;
      se          = `FALSE;
      be          = `FALSE;
      dp          = `FALSE;
      res         = `FALSE;

      q_bis          = 1'bz;

      register_bis   = 8'b00000000;
      wr_latch       = 8'b00000000;

      protect     = `FALSE;
      wr_cycle    = `FALSE;
      hold_cond   = `FALSE;
      write_op    = `FALSE;
      read_op     = `FALSE;

      inhib_wren  = `FALSE;
      inhib_wrdi  = `FALSE;
      inhib_rdsr  = `FALSE;
      inhib_wrsr  = `FALSE;
      inhib_read  = `FALSE;
      inhib_pp    = `FALSE;
      inhib_se    = `FALSE;
      inhib_be    = `FALSE;
      inhib_dp    = `FALSE;
      inhib_res   = `FALSE;

      add_pp_enable  = `FALSE;
      read_enable    = `FALSE;
      pp_enable      = `FALSE;
      be_enable      = `FALSE;
      se_enable      = `FALSE;


      count_enable   = `FALSE;
      data           = 8'b00000000;

      // decode process
      bit_index      = 8'b00000000;
      bit_res        = 8'b00000000;
      bit_register   = 8'b00000000;

      bp          = `NB_BPI'h0 ;

      int_add     = 0;
      sr_mask     = 8'b10000000;
      page_ini    = 8'b11111111;

      reset_wel   = 1'b0;
      wel         = 1'b0;
      wip         = 1'b0;

      signature   = `SIGNATURE ;
   end // initial

   always @(register_bis) status_register = register_bis ;
   //assign status_register = register_bis ; // Continuous Assignment

   //-----------------------------------------------------------
   // This process generates the Hold condition when it is valid
   always 
   begin : hold_com
      @(hold); 
      begin
      if ((hold == 1'b0) && (s == 1'b0))
      begin
         if (c == 1'b0)
         begin
            hold_cond <= `TRUE;
            if ($time != 0) $display("%t:  NOTE: COMMUNICATION PAUSED",$realtime); 
         end
         else
         begin
            @(c or hold); 
            if (c == 1'b0)
            begin
               hold_cond <= `TRUE;
               if ($time != 0) $display("%t:  NOTE: COMMUNICATION PAUSED",$realtime); 
            end 
         end 
      end
      else if (hold == 1'b1)
      begin
         if (c == 1'b0)
         begin
            hold_cond <= `FALSE;
            if ($time != 0) $display("%t:  NOTE: COMMUNICATION (RE)STARTED",$realtime); 
         end
         else
         begin
            @(c or hold); 
            if (c == 1'b0)
            begin
               hold_cond <= `FALSE;
               if ($time != 0) $display("%t:  NOTE: COMMUNICATION (RE)STARTED",$realtime); 
            end 
         end 
      end
      end
   end 

   //----------------------------------------------------------------------
   // This process inhibits the internal clock when hold condition is valid
   always 
   begin : horloge
      @(c); 
      begin
      if (!hold_cond)
      begin
         c_int <= c ; 
      end
      else
      begin
         c_int <= 1'b0 ; 
      end 
      end
   end 

   //---------------------------------------------------------------
   // This process inhibits data output when hold condition is valid
   always @(posedge hold_cond ) q <= #`THLQZ 1'bz ;
   
   always @(negedge hold_cond) q <= #`THHQX q_bis ; 
   
   always @ (q_bis or s)
      if (!hold_cond)
      begin
         q <= q_bis ; 
      end

   //----------------------------------------------------------
   // This process increments 2 counters:  one bit counter (cpt)
   // one byte counter (byte_cpt)
   always 
   begin : count_bit_raz
         @(raz); 
         begin
            if (raz || !select_ok)
            begin
               cpt <= 0 ; 
               byte_cpt <= 0 ; 
               count_enable = `FALSE; 
            end
         end
   end 

   always 
   begin : count_bit_enable
      @(posedge c_int or negedge raz);
      begin
            if (!raz && select_ok)
            begin
               // count enable is an intermediate variable which allows cpt to be
               // constant during a whole period
               count_enable = `TRUE; 
            end
      end
   end
   

   always 
   begin : count_bit
      @(negedge c_int);
      begin
         if (!raz && select_ok)
         begin
            if (count_enable)
            begin
               cpt <= cpt + 1 ; 
            end 
         end 
      end
   end 

   always @(negedge c_int)
      if (byte_ok)
      begin
         //byte_cpt = (byte_cpt + 1) ; 
         byte_cpt <= (byte_cpt + 1) ; 
      end 

   //---------------------------------------------------------------------
   // This process latches every byte of data received and returns byte_ok 
   always 
   begin : data_in_reset

      @(c_int or select_ok); 
      begin
         if (!select_ok)
         begin
            raz <= `TRUE ; 
            byte_ok <= `FALSE ; 
            data_latch <= 8'b00000000 ; 
            data = 8'b00000000;
         end
      end
   end
   
   always 
   begin : data_in

      @(posedge c_int); 
      begin
      if (select_ok)
      begin
         raz <= `FALSE ; 
         if (cpt == 0)
         begin
            data_latch <= 8'b00000000 ; 
            byte_ok <= `FALSE ; 
         end 
         data[7 - cpt] = d; 
         if (cpt == 7)
         begin
            byte_ok <= `TRUE ; 
            data_latch <= data ; 
         end 
         else data_latch <= 8'bxxxxxxxx;
      end 
      end
   end 

   //-------------------------------------------------------------
   //--------------- ASYNCHRONOUS DECODE PROCESS -----------------
   //-------------------------------------------------------------
   always 
   begin : decode
      //-------------------------
      // status register mask ini
      //-------------------------
      for(i = 0; i <= (`NB_BPI - 1); i = i + 1)
      begin
         sr_mask[i + 2] = 1'b1; 
      end
      

      @(byte_ok); 
      if (byte_ok == 1'b1)
      begin         
         //-----------------------------------------------------------
         //-- op_code decode
         //-----------------------------------------------------------
         if (byte_cpt == 0)
         begin
            if (data_latch == 8'b00000110)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR :This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  wren <= `TRUE ; 
                  write_op <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b00000100)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  wrdi <= `TRUE ; 
                  write_op <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b00000101)
            begin
               if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  rdsr <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b00000001)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  wrsr <= `TRUE ; 
                  write_op <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b00000011)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  read_data <= `TRUE ; 
                  read_op <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b00001011)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  fast_read <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b00000010)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  pp <= `TRUE ; 
                  write_op <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b11011000)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  se <= `TRUE ; 
                  write_op <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b11000111)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  be <= `TRUE ; 
                  write_op <= `TRUE ; 
                  for(i = 0; i <= (`NB_BPI - 1); i = i + 1)
                  begin
                     bp[i] = status_register[i + 2]; 
                  end
                  if (bp != 2'b00)
                  begin
                     protect <= `TRUE ; 
                     write_op <= `FALSE ; 
                  end 
               end 
            end
            else if (data_latch == 8'b10111001)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else if (only_res)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a DEEP POWER DOWN ",$realtime); 
               end
               else
               begin
                  dp <= `TRUE ; 
               end 
            end
            else if (data_latch == 8'b10101011)
            begin
               if (only_rdsr)
               begin
                  if ($time != 0) $display("%t:  ERROR : This Opcode is not decoded during a Prog. Cycle ",$realtime); 
               end
               else
               begin
                  res <= `TRUE ; 
               end 
            end
            else
            begin
               if ($time != 0) $display("%t:  ERROR : False instruction, please retry ",$realtime); 
            end 
         end
         //---------------------------------------------------------------------
         // addresses and data reception and treatment
         //---------------------------------------------------------------------
         if ( (byte_cpt == 1) && (!only_rdsr) && (!only_res))
         begin
            if (((read_data) || (fast_read) || (se) || (pp)) && (!rdsr))
            begin
               adress_1 = data_latch; 
            end
            else if (wrsr && (!rdsr))
            begin
               wr_latch <= data_latch ; 
            end 
         end 
         
         if ((byte_cpt == 2) && (!only_rdsr) && (!only_res))
         begin
            if (((read_data) || (fast_read) || (se) || (pp)) && (!rdsr))
            begin
               adress_2 = data_latch; 
            end 
         end 
         if ((byte_cpt == 3) && (!only_rdsr) && (!only_res))
         begin
            if (((read_data) || (fast_read) || (se) || (pp)) && (!rdsr))
            begin
               adress_3 = data_latch; 
               for(i = 0; i <= (`NB_BIT_ADD - 1); i = i + 1)
               begin
                  adress[i] = adress_3[i]; 
                  adress[i + `NB_BIT_ADD] = adress_2[i]; 
                  adress[i + 2 * `NB_BIT_ADD] = adress_1[i]; 
                  add_mem <= adress ; 
               end
               for(i = (`LSB_TO_CODE_PAGE - 1); i >= 0; i = i - 1)
               begin
                  lsb_adress[i] = adress[i]; 
               end
            end 
            if ((se || pp) && (!rdsr))
            begin
               //-----------------------------------------
               // To ignore don't care MSB of the adress
               //----------------------------------------- 
               for(i = 0; i <= `BIT_TO_CODE_MEM -1; i = i + 1)
               begin
                  cut_add[i] = adress[i]; 
               end
               int_add = cut_add; 
               //------------------------------------------------
               // Sector protection detection
               //------------------------------------------------
               for(i = 0; i <= (`NB_BPI - 1); i = i + 1)
               begin
                  bp[i] = status_register[i + 2]; 
               end
               if (bp == 3'b111 || bp == 3'b110 || bp == 3'b101 || bp == 3'b100) // whole memory protected
               begin
                  protect <= `TRUE ; 
                  write_op <= `FALSE ; 
               end
               else if (bp == 3'b011) // address >= 40000h protected 
               begin
                  if (int_add >= ((`TOP_MEM + 1) / 2))
                  begin
                     protect <= `TRUE ; 
                     write_op <= `FALSE ; 
                  end 
               end
               else if (bp == 3'b010) // address >= 60000h protected
               begin
                  if (int_add >= ((`TOP_MEM + 1) * 3 / 4))
                  begin
                     protect <= `TRUE ; 
                     write_op <= `FALSE ; 
                  end 
               end
               else if (bp == 3'b001) // address >= 70000h protected
	       begin
	           if (int_add >= ((`TOP_MEM + 1) * 7 / 8))
	           begin
	           protect <= `TRUE ; 
	           write_op <= `FALSE ; 
	           end 
               end
               else
               begin
                  protect <= `FALSE ; 
               end 
            end 
         end 
         //---------------------------------------------------------------------------
         // PAGE PROGRAM
         // The adress's LSBs necessary to code a whole page are converted to a natural
         // and used to fullfill the page buffer p_prog the same way as the memory page
         // will be fullfilled.
         //--------------------------------------------------------------------------
         if ( (byte_cpt >= 4) && (pp) && (!only_rdsr) && (!rdsr))
         begin
            data_to_write = data_latch ; 
            page_add_index = (byte_cpt - 1 - (`NB_BIT_ADD_MEM / `NB_BIT_ADD) + lsb_adress); 
         end 
         else
         begin
            data_to_write  = 8'bxxxxxxxx; 
            page_add_index = 8'bxxxxxxxx; 
         end

         // to launch adress treatment in memory access
         if (( read_data && (byte_cpt == 3)) || (fast_read && (byte_cpt == 4)))
         begin
            read_enable <= `TRUE ; 
         end 
         // to send a request for the data pointed by the adress
         if (( read_data && (byte_cpt >= 3)) || ( fast_read && (byte_cpt >= 4)))
         begin
            data_request <= `TRUE ; 
         end 
      end   //(if byte_ok)
   end   //(process decode)
   
   //-----------------------------------------
   // adresses initialization and reset
   //-----------------------------------------
   always @(posedge select_ok) 
   begin
      for(i = 0; i <= (`NB_BIT_ADD - 1); i = i + 1)
      begin
         adress_1[i] = 1'b0; 
         adress_2[i] = 1'b0; 
         adress_3[i] = 1'b0; 
      end
      for(i = 0; i <= (`NB_BIT_ADD_MEM - 1); i = i + 1)
      begin
         adress[i] = 1'b0; 
      end
      add_mem <= adress ; 
   end
   

   always @(negedge byte_ok)
   begin
      if ((read_data && (byte_cpt > 3) ) || (fast_read && (byte_cpt > 4) ))
      begin
         data_request <= `FALSE ; 

      end 
   end
      
   always @(posedge inhib_read)
   begin
         read_op <= `FALSE ; 
         read_data <= `FALSE ; 
         fast_read <= `FALSE ; 
         read_enable <= `FALSE ; 
         data_request <= `FALSE ; 

   end
   //------------------------------------------------------
   // STATUS REGISTER INSTRUCTIONS
   //------------------------------------------------------
   // WREN/WRDI instructions
   //-----------------------
   always @(posedge wel)
   begin
      register_bis[1] <= 1'b1 ; 

   end

   always @(posedge inhib_wren) 
   begin
      wren <= `FALSE ; 
      write_op <= `FALSE ; 
   end 

   always @(posedge inhib_wrdi)
   begin
      wrdi <= `FALSE ; 
      write_op <= `FALSE ; 
   end 

   //----------------------
   // RESET WEL instruction
   //----------------------
   always @(posedge reset_wel)
   begin
      register_bis[1] <= 1'b0 ; 
   end 
   //-------------------
   // WRSR instructions
   //-------------------
   always @(posedge wr_cycle)
      begin
         if ($time != 0) $display("%t:  NOTE : Write status register cycle has begun ",$realtime); 
         register_bis <= ((register_bis) | (8'b00000011)) ; 
      end 
   always @(negedge wr_cycle)
      begin
         if ($time != 0) $display("%t:  NOTE : Write status register cycle is finished",$realtime); 
         register_bis <= ((wr_latch) & sr_mask) ; 
         wrsr <= `FALSE ; 
      end 

   always @(posedge inhib_wrsr) wrsr <= `FALSE ; 

   always @(negedge wrsr) wr_latch <= 8'b00000000 ; 

   //------
   // PROG
   //------
   always @(wip)
   begin
      if (wip == 1'b1)
      begin
         register_bis[0] <= 1'b1 ; 
      end 
      else
      begin
         register_bis[0] <= 1'b0 ; 
         write_op <= `FALSE ; 

      end 
   end
   //------------------
   // rdsr instruction
   //------------------
   always @(posedge inhib_rdsr) rdsr <= `FALSE ; 
   //----------------------------------------------------------
   // BULK/SECTOR ERASE INSTRUCTIONS
   //----------------------------------------------------------
   always @(posedge inhib_be)
   begin
      protect <= `FALSE ; 
      be <= `FALSE ; 
   end 
   always @(posedge inhib_se)
   begin
      protect <= `FALSE ; 
      se <= `FALSE ; 
   end 
   //----------------------------------------------------------
   //PAGE PROGRAM INSTRUCTIONS
   //----------------------------------------------------------
   always @(posedge inhib_pp)
   begin
      protect <= `FALSE ; 
      pp <= `FALSE ; 
   end 
   //----------------------------------------------------------
   // DEEP POWER DOWN
   // RELEASE FROM DEEP POWER DOWN AND READ ELECTRONIC SIGNATURE
   //-----------------------------------------------------------
   always @(posedge inhib_dp) dp <= `FALSE ; 

   always @(posedge inhib_res) res <= `FALSE ; 

   //--------------------------------------------------------
   //--------------- SYNCHRONOUS PROCESS  ----------------
   //--------------------------------------------------------
   always 
   @(c_int or select_ok)
   begin
      wel <= 1'b0 ; 
      reset_wel <= 1'b0 ; 
   end

      //-------------------------------------------
      // READ_data
      //-------------------------------------------
   always 
      @(c_int or select_ok)
      begin
         if ((!read_data) && (!fast_read))
         begin
            inhib_read <= `FALSE ; 
         end 
         if (((byte_cpt == 0) || (byte_cpt == 1) || (byte_cpt == 2) || ((byte_cpt == 3) && (cpt != 7))) && read_data && (!select_ok))
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is deselected",$realtime); 
            inhib_read <= `TRUE ; 
            bit_index <= 8'b00000000; 
         end 
         if (read_data && (((byte_cpt == 3) && (cpt == 7)) || (byte_cpt >= 4)))
         begin
            if (!select_ok)
            begin
               inhib_read <= `TRUE ; 
               bit_index <= 8'b00000000; 
               q_bis <= #`TSHQZ 1'bz ; 
            end
         end
      end
   
   always 
   @(negedge c_int)
   begin
      if (read_data && (((byte_cpt == 3) && (cpt == 7)) || (byte_cpt >= 4)))
      begin

         if (select_ok)
         begin
            q_bis <= #`TCLQV data_to_read[7 - bit_index] ; 
            bit_index = bit_index + 1; 
         end 
      end
   end

      //------------------------------------------------------------------
      // Fast_Read
      //------------------------------------------------------------------
   always 
      @(c_int or select_ok)
      begin
         if (((byte_cpt == 0) || (byte_cpt == 1) || (byte_cpt == 2) || (byte_cpt == 3) || ((byte_cpt == 4) && (cpt != 7))) && fast_read && (!select_ok))
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is deselected",$realtime); 
            inhib_read <= `TRUE ; 
            bit_index <= 8'b00000000; 
         end 
         if (fast_read && (((byte_cpt == 4) && (cpt == 7)) || (byte_cpt >= 5)))
         begin
            if (!select_ok)
            begin
               inhib_read <= `TRUE ; 
               bit_index <= 8'b00000000; 
               q_bis <= #`TSHQZ 1'bz ; 
            end
         end
      end
   
   always 
      @(negedge c_int)
      begin
         if (fast_read && (((byte_cpt == 4) && (cpt == 7)) || (byte_cpt >= 5)))
         begin
            if (select_ok)
            begin
               q_bis <= #`TCLQV data_to_read[7 - bit_index] ; 
               bit_index = bit_index + 1 ;
            end 
         end
      end

      //-----------------------------------------
      // Write_enable 
      //-----------------------------------------
   always 
      @(c_int or select_ok)
      begin
         if (!wren)
         begin
            inhib_wren <= `FALSE ; 
         end
         if (wren && (!only_rdsr) && (!only_res))
         begin
            if (!select_ok)
            begin
               wel <= 1'b1 ; 
               inhib_wren <= `TRUE ; 
            end
         end
      end

   always 
      @(posedge c_int)
      begin
         if (wren && (!only_rdsr) && (!only_res) && select_ok)
         begin
            inhib_wren <= `TRUE ; 
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is still selected",$realtime); 
         end
      end

      //-------------------------------------------
      // Write_disable
      //-------------------------------------------
   always 
      @(c_int or select_ok)
      begin
         if (!wrdi)
         begin
            inhib_wrdi <= `FALSE ; 
         end 
         if (wrdi && (!only_rdsr) && (!only_res))
         begin
            if (!select_ok)
            begin
               reset_wel <= 1'b1 ; 
               inhib_wrdi <= `TRUE ; 
            end 
         end
      end

   always 
      @(posedge c_int)
      begin
         if (wrdi && (!only_rdsr) && (!only_res) && select_ok)
         begin
            inhib_wrdi <= `TRUE ; 
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is still selected",$realtime); 
         end
      end

      //-----------------------------------------
      // Write_status_register
      //-----------------------------------------
   always 
      @(c_int or select_ok)
      begin
         if (!wrsr)
         begin
            inhib_wrsr <= `FALSE ; 
            srwd_wrsr <= `FALSE;
         end 
         if (wrsr && (!only_rdsr) && (!only_res))
         begin
            if ((byte_cpt == 1) && ((cpt != 7) || (!byte_ok)) && (!wr_cycle))
            begin
               if (!select_ok)
               begin
                  if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is deselected",$realtime); 
                  inhib_wrsr <= `TRUE;
                  srwd_wrsr <= `FALSE;
               end 
            end
            else if ((byte_cpt == 1) && (cpt == 7) && byte_ok)
            begin
               if (write_protect)
               begin
                  if ($time != 0) $display("%t:  WARNING : Instruction canceled because status register is hardware protected",$realtime); 
                  inhib_wrsr <= `TRUE ; 
               end
            end
         end
      end
      
      
  //-------------------------------------------------------------------------------------------
  // this process returns an error if SRWD=1 and Wc has been switched during a WRSR instruction HC 20/01/03
  always
    @(wrsr or write_protect_toggle)
    begin
      if (wrsr && write_protect_toggle)
          begin
          if ($time != 0) $display("%d", t_write_protect_toggle,":  ERROR : It is not allowed to switch the Wc pin during a WRSR instruction");
          $finish;
          end
      if (wrsr && (status_register[7]) == 1'b1)
          begin
          srwd_wrsr <= `TRUE;  // becomes one when WRSR is decoded and WIP=1
          end
    end
      

   always 
      @(negedge select_ok)
      begin
         if (wrsr && (!only_rdsr) && (!only_res))
         begin
            if ((byte_cpt == 1) && (cpt == 7) && byte_ok && (!write_protect))
            begin
               if ((status_register[1]) == 1'b0)
               begin
                  if ($time != 0) $display("%t:  WARNING : Instruction canceled because WEL is reset",$realtime); 
                  inhib_wrsr <= `TRUE ; 
               end
               else
               begin
                  wr_cycle <= `TRUE ; 
                  wip <= 1'b1 ; 
                  #`TW; 
                  wip <= 1'b0 ; 
                  wr_cycle <= `FALSE ; 
               end 
            end
            else if (byte_cpt == 2)
            begin
               if ((status_register[1]) == 1'b0)
               begin
                  if ($time != 0) $display("%t:  WARNING : Instruction canceled because WEL is reset",$realtime); 
                  inhib_wrsr <= `TRUE ; 
               end
               else
               begin
                  wr_cycle <= `TRUE ; 
                  wip <= 1'b1 ; 
                  #`TW; 
                  wr_cycle <= `FALSE ; 
                  wip <= 1'b0 ; 
               end 
            end
         end
      end

   always @(posedge c_int)
   begin
      if (wrsr && (!only_rdsr) && (!only_res))
         if (byte_cpt == 2 && !rdsr)
         begin
            if ($time != 0) $display("WARNING : Instruction canceled because the chip is still selected",$realtime); 
            inhib_wrsr <= `TRUE ; 
         end
      end

      //-------------------------------------------
      // Bulk_erase
      //-------------------------------------------
   always @( c_int or select_ok)
   begin
      if (!be)
      begin
         inhib_be <= `FALSE ; 
      end 
      if (be && (!only_rdsr) && (!only_res))
      begin
         if (!select_ok)
         begin
            if ((status_register[1]) == 1'b0)
            begin
               if ($time != 0) $display("%t:  WARNING : Instruction canceled because WEL is reset",$realtime); 
               be_enable <= `FALSE ; 
               inhib_be <= `TRUE ; 
            end
            else if (protect && be)
            begin
               if ($time != 0) $display("%t:  WARNING : Instruction canceled because at least one sector is protected",$realtime); 
               be_enable <= `FALSE ; 
               inhib_be <= `TRUE ; 
            end
            else
            begin
               if ($time != 0) $display("%t:  NOTE : Bulk erase cycle has begun",$realtime); 
               be_enable <= `TRUE ; 
               wip <= 1'b1 ; 
               for(j = 1; j <= `TBE; j = j + 1) // Bulk erase duration = TBExTbase = TBE x 1s (to avoid number wider thab 32 bit)
                   begin
                     #`Tbase ;
                   end
               if ($time != 0) $display("%t:  NOTE : Bulk erase cycle is finished",$realtime); 
               be_enable <= `FALSE ; 
               inhib_be <= `TRUE ; 
               wip <= 1'b0 ; 
               reset_wel <= 1'b1 ; 
            end
         end
      end
   end

   always @(posedge c_int)
   begin
      if (be && (!only_rdsr) && (!only_res))
      begin
         if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is still selected",$realtime); 
         inhib_be <= `TRUE ; 
      end
   end

      //-------------------------------------------
      // Sector_erase
      //-------------------------------------------
   always @( c_int or select_ok)
   begin
      if (!se)
      begin
         inhib_se <= `FALSE ; 
      end 
      if (((byte_cpt == 0) || (byte_cpt == 1) || (byte_cpt == 2) || ((byte_cpt == 3) && ((cpt != 7) || !byte_ok))) && se && (!only_rdsr) && (!only_res))
      begin
         if (!select_ok)
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is deselected",$realtime); 
            inhib_se <= `TRUE ; 
         end 
      end 
      if ( ((byte_cpt == 4) || ((byte_cpt == 3) && (cpt == 7) && byte_ok)) && se && (!only_rdsr) && (!only_res))
      begin
         if (!select_ok)
         begin
            if ((status_register[1]) == 1'b0)
            begin
               if ($time != 0) $display("%t:  WARNING : Instruction canceled because WEL is reset",$realtime); 
               se_enable <= `FALSE ; 
               inhib_se <= `TRUE ; 
            end
            else if (protect && se)
            begin
               if ($time != 0) $display("%t:  WARNING : Instruction canceled because the SE sector is protected",$realtime); 
               se_enable <= `FALSE ; 
               inhib_se <= `TRUE ; 
            end
            else
            begin
               if ($time != 0) $display("%t:  NOTE : Sector erase cycle has begun",$realtime); 
               se_enable <= `TRUE ; 
               wip <= 1'b1 ; 
              for(j = 1; j <= `TSE; j = j + 1) // Sector erase duration = TSE x Tbase = TSE x 1s (to avoid number wider thab 32 bit)
                  begin
                    #`Tbase ;
                  end
               if ($time != 0) $display("%t:  NOTE : Sector erase cycle is finished",$realtime); 
               se_enable <= `FALSE ; 
               inhib_se <= `TRUE ; 
               wip <= 1'b0 ; 
               reset_wel <= 1'b1 ; 
            end 
         end 
      end
   end
   
   always @(posedge c_int)
   begin
      if ( ((byte_cpt == 4) || ((byte_cpt == 3) && (cpt == 7) && byte_ok)) && se && (!only_rdsr) && (!only_res))
      begin
         if (byte_cpt == 4 && select_ok)
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is still selected",$realtime); 
            inhib_se <= `TRUE ; 
         end
      end
   end

      //-------------------------------------------
      // Page_Program
      //-------------------------------------------
   always @(c_int or select_ok)
   begin
      if (!pp)
      begin
         inhib_pp <= `FALSE ; 
         add_pp_enable <= `FALSE ; 
         pp_enable <= `FALSE ; 
      end 
      
      if (((byte_cpt == 5) || ((byte_cpt == 4) && (cpt == 7))) && pp && (!only_rdsr) && (!only_res))
      begin
         add_pp_enable <= `TRUE ; 
         if ((status_register[1]) == 1'b0)
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because WEL is reset",$realtime); 
            pp_enable <= `FALSE ; 
            inhib_pp <= `TRUE ; 
         end
         else if (protect && pp)
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the PP sector is protected",$realtime); 
            pp_enable <= `FALSE ; 
            inhib_pp <= `TRUE ; 
         end 
      end 
   end
   
   always @(negedge select_ok)
   begin
      if (((byte_cpt == 0) || (byte_cpt == 1) || (byte_cpt == 2) || (byte_cpt == 3) || ((byte_cpt == 4) && ((cpt != 7) || !byte_ok))) && pp && (!only_rdsr) && (!only_res) && (!select_ok))
         begin
            if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is deselected",$realtime); 
            inhib_pp <= `TRUE ; 
         end 
      if (((byte_cpt == 5) || ((byte_cpt == 4) && (cpt == 7))) && pp && (!only_rdsr) && (!only_res))
      begin
         add_pp_enable <= `TRUE ; 
         if (pp)
         begin
            if ($time != 0) $display("%t:  NOTE : Page program cycle is started",$realtime); 
            wip <= 1'b1 ; 
            #`TPP; 
            if ($time != 0) $display("%t:  NOTE : Page program cycle is finished",$realtime); 
            pp_enable <= `TRUE ; 
            wip <= 1'b0 ; 
            inhib_pp <= `TRUE ; 
            reset_wel <= 1'b1 ; 
         end 
      end 
      if ((byte_cpt > 5) && pp && (!only_rdsr) && (!only_res) && byte_ok)
      begin
         if ($time != 0) $display("%t:  NOTE : Page program cycle is started",$realtime); 
         wip <= 1'b1 ; 
         #`TPP; 
         if ($time != 0) $display("%t:  NOTE : Page program cycle is finished",$realtime); 
         pp_enable <= `TRUE ; 
         wip <= 1'b0 ; 
         inhib_pp <= `TRUE ; 
         reset_wel <= 1'b1 ; 
      end 
      if ((byte_cpt > 5) && pp && (!only_rdsr) && (!only_res) && (!byte_ok))
      begin
         if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is deselected",$realtime); 
         inhib_pp <= `TRUE ; 
         pp_enable <= `FALSE ; 
      end 
   end

      //-----------------------------------------
      // Deep Power Down
      //-----------------------------------------
   always @(c_int or select_ok)
   begin
      if (!dp)
      begin
         inhib_dp <= `FALSE ; 
         only_res <= `FALSE ; 
         t_only_res = 0;
      end 
   end

   always @(posedge c_int)
   begin
      if (dp && (!only_rdsr) && (!only_res) && (!res))
      begin
         if ($time != 0) $display("%t:  WARNING : Instruction canceled because the chip is still selected",$realtime); 
         inhib_dp <= `TRUE ; 
         only_res <= `FALSE ; 
         t_only_res = 0;
      end
   end

   always @(negedge select_ok)
   begin
      if (dp && (!only_rdsr) && (!only_res) && (!res))
      begin
         if ($time != 0) $display("%t:  NOTE : Chip is entering deep power down mode",$realtime); 
         // useful when chip is selected again to inhib every op_code except RES
         // and to check tDP
         t_only_res = $time;
         only_res <= `TRUE ; 
         
      end
   end

      //---------------------------------------------------------------------
      // Release from Deep Power Down Mode and Read Electronic Signature
      //---------------------------------------------------------------------
   always @(select_ok or c_int)
   begin
      if (!res)
      begin
         inhib_res <= `FALSE ; 
         bit_res <= 0; 
      end 
      
      if (res && ((byte_cpt == 1) && (cpt == 0)) && (!only_rdsr) && (!select_ok))
      begin
      if (only_res)
         begin
         if ($time != 0) $display("%t:  NOTE : The chip is releasing from DEEP POWER DOWN",$realtime); 
         inhib_res <= `FALSE; inhib_dp <= `FALSE; #`TRES1;
	 inhib_res <= `TRUE; inhib_dp <= `TRUE; 
        end
      else  inhib_res <= `TRUE; inhib_dp <= `TRUE;
      end
      else if ((((byte_cpt == 1) && (cpt > 0)) || (byte_cpt == 2) || (byte_cpt == 3) || ((byte_cpt == 4) && ((cpt < 7) || (!byte_ok)))) && res && (!only_rdsr) && (!select_ok))
      begin
         if ($time != 0) $display("%t:  ERROR : Electronic Signature must be read at least once. Instruction not valid",$realtime); 
      end
      else if ((((byte_cpt == 4) && (cpt == 7) && byte_ok) || (byte_cpt > 4)) && res && (!only_rdsr) && (!select_ok))
                 begin
                 if (only_res)
                    begin
                    if ($time != 0) $display("%t:  NOTE : The Chip is releasing from DEEP POWER DOWN",$realtime); 
                    inhib_res <= `FALSE ; inhib_dp <=  `FALSE ;#`TRES2;
		    inhib_res <= `TRUE ; inhib_dp <=  `TRUE;
                    end
                 else inhib_res <= `TRUE ; inhib_dp <=  `TRUE;
                 q_bis <= 1'bz ; 
                 end
   end
   
   always @(negedge c_int)
   begin
      if ((((byte_cpt == 3) && (cpt == 7)) || (byte_cpt >= 4)) && res && (!only_rdsr) )
      begin
         q_bis <= #`TCLQV signature[7 - bit_res] ; 
         bit_res = bit_res + 1; 
      end 
   end

   //-------------------------------------------------------
   // This process shifts out status register on data output
   always 
      @(c_int or select_ok or rdsr)
      begin
         if (!rdsr)
         begin
            inhib_rdsr <= `FALSE ; 
         end 
         if (rdsr && (!select_ok))
         begin
            bit_register <= 0; 
            q_bis <= #`TSHQZ 1'bz ; 
            inhib_rdsr <= `TRUE ; 
         end
      end

   always 
      @(negedge c_int)
      begin
         if (rdsr && (select_ok))
         begin
            q_bis <= #`TCLQV status_register[7 - bit_register] ; 
            bit_register = bit_register + 1; 
         end
      end
   //--------------------------------------------------------------------------------------
   // This process checks select and deselect conditions. Some other conditions are tested:
   // prog cycle, deep power down mode and read electronic signature.
   always 
   begin : pin_s
      @(s); 
      begin
      if (s == 1'b0)
      begin
         if (res && only_res)
         begin
            if ($time != 0) $display("%t:  ERROR : The chip must not be selected until tRES",$realtime); 
         end
         else if (dp)
         begin
            if (($time - t_only_res) < `TDP)
            begin
               if ($time != 0) $display("%t:  ERROR : The chip must not be selected until tDP",$realtime); 
            end
            else
            begin
               if ($time != 0) $display("%t:  NOTE : Only a Read Electronic Signature instruction will be valid",$realtime); 
            end 
         end 
         select_ok <= `TRUE ; 
         if (pp || wrsr || be || se)
         begin
            if ($time != 0) $display("%t:  NOTE : Only a Read Status Register instruction will be valid",$realtime); 
            only_rdsr <= `TRUE ; 
         end 
      end 
      else
      begin
         select_ok <= `FALSE ; 
         only_rdsr <= `FALSE ; 
      end 
      end
   end 

   //--------------------------------------------------------------
   // This Process detects the hardware protection mode
   always 
      @(w or c_int)
      begin
         if ((w == 1'b0) && ((status_register[7]) == 1'b1))
         begin
            write_protect <= `TRUE ; 
         end 
         if (w == 1'b1)
         begin
            write_protect <= `FALSE ; 
         end 
      end
      
   //--------------------------------------------------------------
   // this process detects if write_protect toggles during an instruction // HC 20/01/03
   always
   @(select_ok)
   begin
       if (select_ok)
       begin
            @(write_protect)
            write_protect_toggle <= `TRUE;
            if ($time != 0)
	        begin
	        t_write_protect_toggle = $time;
                end
       end
       if (!select_ok)
       begin
            write_protect_toggle <= `FALSE;
       end
   end



endmodule
