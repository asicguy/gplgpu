//
module ddr3_int_ex_lfsr8 (
clk, reset_n, enable, pause, load, data, ldata);

   parameter seed  = 32;
   input clk;
   input reset_n;
   input enable;
   input pause;
   input load;
   output[8 - 1:0] data;
   wire[8 - 1:0] data;
   input[8 - 1:0] ldata;

   reg[8 - 1:0] lfsr_data;

   assign data = lfsr_data ;

   always @(posedge clk or negedge reset_n)
   begin
      if (!reset_n)
      begin
         // Reset - asynchronously reset to seed value
         lfsr_data <= seed[7:0] ;
      end
      else
      begin
         if (!enable)
         begin
            lfsr_data <= seed[7:0];
         end
         else
         begin
            if (load)
            begin
               lfsr_data <= ldata ;
            end
            else
            begin
               // Registered mode - synchronous propagation of signals
               if (!pause)
               begin
                  lfsr_data[0] <= lfsr_data[7] ;
                  lfsr_data[1] <= lfsr_data[0] ;
                  lfsr_data[2] <= lfsr_data[1] ^ lfsr_data[7] ;
                  lfsr_data[3] <= lfsr_data[2] ^ lfsr_data[7] ;
                  lfsr_data[4] <= lfsr_data[3] ^ lfsr_data[7] ;
                  lfsr_data[5] <= lfsr_data[4] ;
                  lfsr_data[6] <= lfsr_data[5] ;
                  lfsr_data[7] <= lfsr_data[6] ;
               end
            end
         end
      end
   end
endmodule
