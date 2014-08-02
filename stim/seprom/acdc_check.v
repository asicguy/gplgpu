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

module acdc_check (c, d, s, hold, write_op, read_op, srwd_wrsr,write_protect, wrsr);

   input c; 
   input d; 
   input s; 
   input hold; 
   input write_op; 
   input read_op;
   input write_protect; 
   input srwd_wrsr;
   input wrsr;
   
   ////////////////
   // TIMING VALUES
   ////////////////
   time t_C_rise;
   time t_C_fall;
   time t_H_rise;
   time t_H_fall;
   time t_S_rise;
   time t_S_fall;
   time t_D_change;
   time high_time;
   time low_time;
   time t_write_protect_rise; 
   time t_write_protect_fall; 
   ////////////////
   
   reg toggle;
   
   initial
   begin
      high_time = 100000;
      low_time = 100000;
      toggle = 1'b0;
   end

   //--------------------------------------------
   // This process checks pulses length on pin /S
   //--------------------------------------------
   always 
   begin : shsl_watch
      @(posedge s); 
      begin
         if ($time != 0) 
         begin
            t_S_rise = $time; 
            @(negedge s); 
            t_S_fall = $time; 
            if ((t_S_fall - t_S_rise) < `TSHSL)
            begin
               $display("%t : ERROR : tSHSL condition violated",$realtime); 
            end 
         end
      end 
   end 

   //----------------------------------------------------
      // This process checks select setup and hold timings 
      //----------------------------------------------------
      always 
      begin : s_watch1  
         @(s); 
         if ((s == 1'b0) && (hold != 1'b0))
         begin
            if ($time != 0) 
            begin
               t_S_fall = $time;
               if ( ($time - t_C_rise) < `TCHSL)
                   begin
                   $display("%t : ERROR :tCHSL condition violated",$realtime); 
               if (c ==1'b1)
                   begin
                   @(c);
                   @(c);
                   if (($time - t_S_fall) < `TSLCH)
                         begin 
                         $display("%t : ERROR :tSLCH condition violated",$realtime);  
                         end
                   end 
                   end
               else if (c == 1'b0)
                   begin
                   @(c);
                   if (($time - t_S_fall) < `TSLCH)
                       begin 
                       $display("%t : ERROR :tSLCH condition violated",$realtime);  
                       end
                   end 
                   end
         end 
      end
      
      //----------------------------------------------------
      // This process checks deselect setup and hold timings 
      //----------------------------------------------------
      always
      begin : s_watch2  
      @(s);
         if ((s == 1'b1) && (hold != 1'b0))
         begin
            if ($time != 0) 
            begin
               t_S_rise = $time;
               if ( ($time - t_C_rise) < `TCHSH)
                   begin
                   $display("%t : ERROR :tCHSH condition violated",$realtime); 
                   end 
               if (c == 1'b1)
                   begin
                   @(c);
                   @(c);
                   if ( ($time - t_S_rise) < `TSHCH )
                       begin
                       $display("%t : ERROR :tSHCH condition violated",$realtime);
                       end
                   end
               else if (c == 1'b0)
                   begin
                   @(c);
                   if ( ($time - t_S_rise) < `TSHCH )
                       begin
                       $display("%t : ERROR :tSHCH condition violated",$realtime);
                       end
                   end 
             end
         end 
   end

   //---------------------------------
   // This process checks hold timings
   //---------------------------------
   always 
   begin : hold_watch
      @(hold); 
      if ((hold == 1'b0) && (s == 1'b0))
      begin
         if ($time != 0) 
         begin
            t_H_fall = $time ;
            if ( (t_H_fall - t_C_rise) < `TCHHL)
            begin
               $display("%t : ERROR : tCHHL condition violated",$realtime); 
            end 
         
            @(posedge c);
            if( ($time - t_H_fall) < `THLCH)
            begin
               $display("%t : ERROR : tHLCH condition violated",$realtime);
            end
         end
      end 


      if ((hold == 1'b1) && (s == 1'b0))
      begin
         if ($time != 0) 
         begin
            t_H_rise = $time ;
            if ( (t_H_rise - t_C_rise) < `TCHHH)
            begin
               $display("%t : ERROR : tCHHH condition violated",$realtime); 
            end 
            @(posedge c);
            if( ($time - t_H_fall) < `THHCH)
            begin
               $display("%t : ERROR : tHHCH condition violated",$realtime);
            end
         end
      end 
   end 

   //--------------------------------------------------
   // This process checks data hold and setup timings
   //--------------------------------------------------
   always 
   begin : d_watch
      @(d);
      if ((s ==1'b0)  && (hold == 1'b1))  
      begin
      if ($time != 0) 
      begin
         t_D_change = $time;
         if (c == 1'b1)
         begin
            if ( ($time - t_C_rise) < `TCHDX)
            begin
               $display("%t : ERROR : tCHDX condition violated",$realtime); 
            end 
         end
         else if (c == 1'b0)
         begin
            @(c);
            if ( ($time - t_D_change) < `TDVCH) 
            begin
               $display("%t : ERROR : tDVCH condition violated",$realtime);
            end
         end 
      end
      end
   end 

   //-------------------------------------
   // This process checks clock high time
   //-------------------------------------
   always 
   begin : c_high_watch
      @(c); 
      if ($time != 0) 
         begin
         if (c == 1'b1)
         begin
            if (s==1'b1) high_time=100; 
            if (s==1'b0)  
                begin 
                t_C_rise = $time; 
                @(negedge c); 
                t_C_fall = $time; 
                high_time = t_C_fall - t_C_rise;
                 toggle = ~toggle;
                 if ((t_C_fall - t_C_rise) < `TCH)
                      begin
                      if ((s == 1'b0) && (hold == 1'b1))
                           begin
                           if ($time != 0) $display("%t : ERROR : tCH condition violated",$realtime); 
                          end 
                      end 
                 end
          end
         end 
    end
   //-------------------------------------
   // This process checks clock low time
   //-------------------------------------
   always 
   begin : c_low_watch
      @(c); 
      if ($time != 0)
          begin
          if (s==1'b1) low_time=100; 
          if (s==1'b0)  
              begin  
              if (c == 1'b0)
                  begin
                  t_C_fall = $time; 
                  @(posedge c); 
                  t_C_rise = $time; 
                  low_time = t_C_rise - t_C_fall;
                  toggle = ~toggle;
                  if ((t_C_rise - t_C_fall) < `TCL)
                       begin
                        if ((s == 1'b0) && (hold == 1'b1))
                           begin
                           $display("%t : ERROR : tCL condition violated",$realtime); 
                           end 
                       end 
                   end
               end
          end
       end

   //-----------------------------------------------
   // This process checks clock frequency
   //-----------------------------------------------
   //   always @(high_time or low_time or read_op)
   always @(toggle or read_op)
   begin : freq_watch
      if ($time != 0) 
      begin
         if ((s == 1'b0) && (hold == 1'b1))// 21/10/02 clock frequency time check inhibition when S=1 or Hold=0
         begin
            if (read_op)
            begin
               if ((high_time + low_time) < `TR)
               begin
                  if ($time != 0) $display("%t : ERROR : Clock frequency condition violated for READ instruction: fR>20MHz",$realtime); 
               end 
            end
            else if ((high_time + low_time) < `TC)
            begin
               if ($time != 0) $display("%t : ERROR : Clock frequency condition violated: fC>25MHz",$realtime); 
            end 
         end
      end
   end 
   
   //--------------------------------------------------
   // This process detects the write_potect transitions  
   //--------------------------------------------------
   always @(write_protect)
   begin : write_protect_watch
         if ($time != 0)
         begin
              if (write_protect)
                  begin
                  t_write_protect_rise = $time;
                  end
              if (!write_protect)
                  begin
                  t_write_protect_fall = $time;
                  end
         end
   end
   
   
   //----------------------------------------
   // This process checks the TWHSL parameter  
   //----------------------------------------
      always @(posedge srwd_wrsr)
      begin : TWHSL_watch
            if ($time != 0)
                begin
                if ((t_S_fall - t_write_protect_fall) < `TWHSL)
                     begin
                     $display("%d",t_write_protect_fall, ": ERROR : TWHSL condition violated"); 
                     $finish;
                     end
                end
      end
      
      
    //----------------------------------------
    // This process checks the TSLWL parameter  
    //----------------------------------------
    always @(posedge write_protect)
    begin : TSHWL_watch
        if ($time != 0)
            begin
            t_write_protect_rise = $time;
            if (s)
                begin
                if (((t_write_protect_rise-t_S_rise) < `TSHWL) && wrsr)
                    begin
                    $display("%t : ERROR : TSHWL condition violated",$realtime); 
                    $finish;
                    end
                end
             end
     end
    
   
endmodule
