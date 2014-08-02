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

module memory_access (add_mem, be_enable, se_enable, add_pp_enable, pp_enable, read_enable, data_request, data_to_write, page_add_index, data_to_read);

   input[(`NB_BIT_ADD_MEM - 1):0] add_mem; 
   input be_enable; 
   input se_enable; 
   input add_pp_enable; 
   input pp_enable; 
   input read_enable; 
   input data_request; 
   input[(`NB_BIT_DATA - 1):0] data_to_write; 
   input[(`LSB_TO_CODE_PAGE-1):0] page_add_index;

   output[(`NB_BIT_DATA - 1):0] data_to_read; 
   reg[(`NB_BIT_DATA - 1):0] data_to_read;

   reg[(`NB_BIT_DATA - 1):0] p_prog[0:(`PLENGTH-1)];
   reg[(`NB_BIT_DATA - 1):0] content[0:`TOP_MEM]; 
   reg[`BIT_TO_CODE_MEM - 1:0] cut_add; 

   integer i; 
   integer deb_zone; 
   integer int_add; 
   integer int_add_mem;
   parameter initfile = "initM25P40.txt"; // Modification introduced on 14/11/02 
                                             //to create default initialization file

   initial
   begin
      cut_add = 0;
      deb_zone = 0;
      int_add = 0;
      int_add_mem = `BIT_TO_CODE_MEM ;
      
      
      //-------------------------------
      // initialisation of memory array
      //-------------------------------
      $display("%t : NOTE : Load memory with Initial content",$realtime); 
      $readmemh(initfile, content); 
                                                     
      $display("%t : NOTE : Initial Load End",$realtime); 
         
      for(i = 0; i <= (`PLENGTH-1); i = i + 1)
      begin
         p_prog[i] = 8'b11111111 ; 
      end
   end

   //--------------------------------------------------
   //                PROCESS MEMORY
   //--------------------------------------------------

   always
   begin
      @(negedge add_pp_enable )

         for(i = 0; i <= (`PLENGTH-1); i = i + 1)
         begin
            p_prog[i] = 8'b11111111 ; 
         end
   end

   always
   begin
      @(page_add_index)
      if ($time != 0)
      begin
         if (page_add_index !== 8'bxxxxxxxx)
         begin
            if (add_pp_enable == 1'b1 && pp_enable == 1'b0)
            begin
               p_prog[page_add_index] <= data_to_write ;
            end
         end
      end
   end

   always 
      @(posedge se_enable or posedge read_enable or add_pp_enable)
      if ($time != 0)
      begin
         for(i = 0; i <= `BIT_TO_CODE_MEM - 1; i = i + 1)
         begin
            cut_add[i] = add_mem[i]; 
         end
      end

    wire #1 delayed_data_request = data_request;
   always 
      @(posedge delayed_data_request)
      if ($time != 0)
      begin
         if (read_enable)
         begin
            int_add = cut_add; 
            //---------------------------------------------------------
            // Read instruction
            //---------------------------------------------------------
            if (int_add > `TOP_MEM)
            begin
               for(i = 0; i <= `BIT_TO_CODE_MEM - 1; i = i + 1)
               begin
                  cut_add[i] = 1'b0; 
               end
               int_add = 0; // roll over at the end of mem array
            end 
            data_to_read <= content[int_add] ; 
            //cut_add <= cut_add + 1; // next address 
         end
      end

    always
    @(negedge data_request)
         if ($time != 0)
              begin
              cut_add <= cut_add+1;
              end
   
   always 
      @(negedge read_enable)
      if ($time != 0)
      begin
         for(i = 0; i <= `NB_BIT_DATA - 1; i = i + 1)
         begin
            data_to_read[i] <= 1'b0 ; 
         end
      end

   //--------------------------------------------------------
   // Page program instruction
   // To find the first adress of the memory to be programmed
   //--------------------------------------------------------
   always 
      @(add_pp_enable)
         if (add_pp_enable == 1'b1)
         begin
            int_add_mem = cut_add; 
            int_add = `TOP_MEM + 1; 
            while (int_add > int_add_mem)
            begin
               int_add = int_add - `PLENGTH ; 
            end
         end

      //----------------------------------------------------
      // Sector erase instruction
      // To find the first adress of the sector to be erased
      //----------------------------------------------------
   always 
      @(posedge se_enable)
         begin
            int_add = cut_add & `MASK_SECTOR ;
         end
   //----------------------------------------------------
   // Write or erase cycle execution
   //----------------------------------------------------
   always 
      @(posedge pp_enable)
      if ($time != 0)            // to avoid any corruption at initialization of variables
      begin
         for(i = 0; i <= (`PLENGTH - 1); i = i + 1)
         begin
            content[int_add + i] = p_prog[i] & content[int_add + i];
         end
      end

   always 
      @(negedge be_enable)
      if ($time != 0)            // to avoid any corruption at initialization of variables
      begin
         for(i = 0; i <= `TOP_MEM; i = i + 1)
         begin
            content[i] = 8'b11111111; 
         end
      end

   always 
      @(negedge se_enable)
      if ($time != 0)            // to avoid any corruption at initialization of variables
      begin
         for(i = int_add; i <= (int_add + (`SSIZE / `NB_BIT_DATA) - 1); i = i + 1)
         begin
            content[i] = 8'b11111111; 
         end
      end

endmodule
