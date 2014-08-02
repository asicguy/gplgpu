//Legal Notice: (C)2010 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

///////////////////////////////////////////////////////////////////////////////
// Title         : DDR controller Avalon Interface
//
// File          : alt_ddrx_avalon_if.v
//
// Abstract      : Avalon interface
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module alt_ddrx_avalon_if 
    #(parameter     INTERNAL_SIZE_WIDTH    = 7,
                    LOCAL_SIZE_WIDTH       = 6,
                    CTL_HRB_ENABLED        = 0,
                    LOCAL_ADDR_WIDTH       = 28,
                    INTERNAL_ADDR_WIDTH    = 33,
                    DWIDTH_RATIO           = 2,
                    LOCAL_DATA_WIDTH       = 64,
                    INTERNAL_DATA_WIDTH    = 32
     )
     (
        // input
        ctl_clk, 								
        ctl_reset_n,
        ctl_half_clk ,
        ctl_half_clk_reset_n ,
        local_write_req, 
        local_wdata,     
        local_be,  
        local_addr,
        internal_ready,
        local_read_req,
        local_size,
        local_burstbegin,
        ecc_rdata,
        ecc_rdata_valid,
        ecc_rdata_error,
        local_multicast,
        local_autopch_req,

        //output
        avalon_wdata,
        avalon_be,
        avalon_addr,
        avalon_write_req,   
        avalon_read_req,
        avalon_size,
        avalon_burstbegin,
        local_ready,
        local_rdata,
        local_rdata_error,
        local_rdata_valid,
        avalon_multicast,
        avalon_autopch_req
    );
    localparam   LOCAL_BE_WIDTH         = LOCAL_DATA_WIDTH/8;
    localparam   INTERNAL_BE_WIDTH      = INTERNAL_DATA_WIDTH/8;
    localparam   AVM_ADDR_WIDTH         = LOCAL_ADDR_WIDTH + log2(LOCAL_BE_WIDTH);
    
    input                               ctl_clk;
    input                               ctl_reset_n;
    input                               ctl_half_clk;
    input                               ctl_half_clk_reset_n;
    input                               local_write_req;
    input  [LOCAL_DATA_WIDTH -1 : 0]    local_wdata;
    input  [LOCAL_BE_WIDTH -1 : 0]      local_be;
    input  [LOCAL_ADDR_WIDTH -1 : 0]    local_addr;
    input                               internal_ready;
    input                               local_read_req;
    input  [INTERNAL_DATA_WIDTH -1 : 0] ecc_rdata;
    input  [DWIDTH_RATIO/2-1:0]         ecc_rdata_valid;
    input                               ecc_rdata_error;
    input  [LOCAL_SIZE_WIDTH-1:0]       local_size;
    input                               local_burstbegin;
    input                               local_multicast;
    input                               local_autopch_req;

    output [INTERNAL_DATA_WIDTH -1 : 0] avalon_wdata;
    output [INTERNAL_BE_WIDTH -1 : 0]   avalon_be;
    output [INTERNAL_ADDR_WIDTH - 1 : 0]avalon_addr;
    output                              avalon_write_req;
    output                              avalon_read_req;
    output [INTERNAL_SIZE_WIDTH-1:0]    avalon_size;
    output                              avalon_burstbegin;
    output                              local_ready;
    output [LOCAL_DATA_WIDTH -1 : 0]    local_rdata;
    output                              local_rdata_valid;
    output                              local_rdata_error;
    output                              avalon_multicast;
    output                              avalon_autopch_req;
    
    generate if (CTL_HRB_ENABLED == 1) begin
        wire                                    avs_chipselect;
        wire   [LOCAL_DATA_WIDTH -1 : 0]        avs_readdata;
        wire   [LOCAL_DATA_WIDTH -1 : 0]        avs_writedata;
        wire                                    avs_waitrequest;
        wire                                    avm_write;
        wire                                    avm_read;
        wire   [AVM_ADDR_WIDTH - 1 : 0]         avm_address;
        reg    [LOCAL_ADDR_WIDTH -1 : 0]        avs_address;
        reg    [2:0]                            state;
        reg    [INTERNAL_SIZE_WIDTH-1 : 0]      burstcount;
        reg    [INTERNAL_SIZE_WIDTH-1:0]        internal_size;
        reg    [INTERNAL_SIZE_WIDTH-1:0]        internal_size_r;
        reg    [INTERNAL_SIZE_WIDTH-1:0]        avalon_avm_size;
        wire   [2:0]                            avalon_avm_count;
        reg    [2:0]                            avalon_avm_count_r;
        reg                                     avalon_avs_toggle;
        reg                                     avalon_avm_toggle;
        reg                                     avalon_avm_toggle_r;
        wire                                    avalon_avs_clk_ph;
        reg                                     internal_multicast;
        reg                                     internal_multicast_r;
        reg                                     internal_autopch;
        reg                                     internal_autopch_r;
        reg                                     avalon_avm_multicast;
        reg                                     avalon_avm_autopch;
        
        
        assign local_ready = !avs_waitrequest;
        assign avalon_write_req = avm_write & internal_ready;
        assign avalon_read_req = avm_read & internal_ready;
        assign avalon_addr = {avm_address[AVM_ADDR_WIDTH - 1 : log2(LOCAL_BE_WIDTH)],1'b0};
        assign avs_chipselect = local_read_req|local_write_req; 
        
        //burst adaptor logic
        assign avalon_burstbegin = (burstcount == 0);
        assign avalon_size = avalon_avm_size;
        assign avalon_multicast = avalon_avm_multicast;
        assign avalon_autopch_req = avalon_avm_autopch;
        assign avalon_avs_clk_ph = avalon_avm_toggle ^ avalon_avm_toggle_r;
        
        always @(posedge ctl_half_clk or negedge ctl_reset_n)
          if (~ctl_reset_n)
            avalon_avs_toggle <= 1'b0;
          else
            avalon_avs_toggle <= ~avalon_avs_toggle;
        
        always @(posedge ctl_clk or negedge ctl_reset_n)
          if (~ctl_reset_n)
          begin
            avalon_avm_toggle <= 1'b0;
            avalon_avm_toggle_r <= 1'b0;
          end
          else
          begin
            avalon_avm_toggle <= avalon_avs_toggle;
            avalon_avm_toggle_r <= avalon_avm_toggle;
          end

        always @(avalon_avm_count_r,internal_size,internal_multicast,internal_autopch,internal_size_r,internal_multicast_r,internal_autopch_r) begin
           if(avalon_avm_count_r >=3) begin
               avalon_avm_size <= internal_size_r;
               avalon_avm_multicast <= internal_multicast_r;
               avalon_avm_autopch <= internal_autopch_r;
           end
           else begin
               avalon_avm_size <= internal_size;
               avalon_avm_multicast <= internal_multicast;
               avalon_avm_autopch <= internal_autopch;
           end
        end
        
        assign avalon_avm_count = avalon_avm_count_r + (((local_write_req | local_read_req) & local_ready & avalon_avs_clk_ph) ? 3'd2 : 3'd0)
                                       - (avalon_write_req ? 3'd1 : 3'd0)
                                       - (avalon_read_req ? 3'd2 : 3'd0);
                                     
          always @(posedge ctl_clk or negedge ctl_reset_n) begin
             if (!ctl_reset_n) begin
                 avalon_avm_count_r <= 0;
             end
             else begin
                 avalon_avm_count_r <= avalon_avm_count;
             end
          end
        
          always @(posedge ctl_half_clk or negedge ctl_reset_n) begin
             if (!ctl_reset_n) begin
                 internal_size <= 0;
                 internal_size_r <= 0;
                 internal_multicast <= 0;
                 internal_multicast_r <= 0;
                 internal_autopch <= 0;
                 internal_autopch_r <= 0;
             end
             else if((local_write_req | local_read_req) & local_ready) begin
                 internal_size <= {local_size,1'b0}; // multiply local_size by 2
                 internal_size_r <= internal_size;
                 internal_multicast <= local_multicast;
                 internal_multicast_r <= internal_multicast;
                 internal_autopch <= local_autopch_req;
                 internal_autopch_r <= internal_autopch;
             end
          end
        
          always @(posedge ctl_clk or negedge ctl_reset_n) begin
                if (!ctl_reset_n) begin
                    burstcount <= 0;
                    state <= 3'd0;
                end
                else begin
                case (state)
                      3'd0: begin
                            if(avalon_write_req) begin
                                burstcount <= burstcount + 1;
                                state <= 3'd1;
                            end
                      end
                      
                      3'd1: begin
                            if(avalon_write_req) begin
                                if(burstcount == avalon_avm_size -1) begin
                                    burstcount <= 0;
                                    state <= 3'd0;
                                end
                                else begin
                                    burstcount <= burstcount + 1;
                                end
                            end
                      end
                endcase
                end
          end
        
        altera_avalon_half_rate_bridge #(
            .AVM_DATA_WIDTH             (INTERNAL_DATA_WIDTH),
            .AVM_ADDR_WIDTH             (AVM_ADDR_WIDTH),
            .AVM_BYTE_WIDTH             (INTERNAL_BE_WIDTH),
            .AVS_DATA_WIDTH             (LOCAL_DATA_WIDTH),
            .AVS_ADDR_WIDTH             (LOCAL_ADDR_WIDTH),
            .AVS_BYTE_WIDTH             (LOCAL_BE_WIDTH) 
        ) HRB_inst (  
            .avs_reset_n                (ctl_reset_n),
            .avm_reset_n                (ctl_half_clk_reset_n),

            // Avalon slave input
            .avs_clk                    (ctl_half_clk         ),
            .avs_chipselect             (avs_chipselect       ),
            .avs_address                (local_addr          ),
            .avs_write                  (local_write_req     ),
            .avs_read                   (local_read_req       ),
            .avs_byteenable             (local_be             ),
            .avs_writedata              (local_wdata        ),
            
            // Avalon slave output 
            .avs_readdata               (local_rdata          ),
            .avs_waitrequest            (avs_waitrequest      ),
            .avs_readdatavalid          (local_rdata_valid    ),
            
            // Avalon master input
            .avm_clk                    (ctl_clk              ),
            .avm_readdata               (ecc_rdata            ),
            .avm_waitrequest            (!internal_ready      ),
            .avm_readdatavalid          (ecc_rdata_valid[0]   ),
            
            // Avalon master output
            .avm_burstcount             (),     //not going to use it, because burstcount in the HRB is fixed at 2
            .avm_address                (avm_address          ),
            .avm_write                  (avm_write      ),
            .avm_read                   (avm_read      ),
            .avm_byteenable             (avalon_be            ),
            .avm_writedata              (avalon_wdata        )
        );
    end
    
    else begin
        assign avalon_write_req = local_write_req & internal_ready;
        assign avalon_wdata = local_wdata;
        assign avalon_be = local_be;
        assign avalon_read_req = local_read_req & internal_ready;
        assign local_rdata = ecc_rdata;
        assign local_rdata_valid = ecc_rdata_valid[0];
        assign local_rdata_error = ecc_rdata_error;
        assign avalon_addr = local_addr;
        assign avalon_size = local_size;
        assign avalon_burstbegin = local_burstbegin;
        assign local_ready = internal_ready;
        assign avalon_multicast = local_multicast;
        assign avalon_autopch_req = local_autopch_req;
    end
    endgenerate
    
    function integer log2;  //constant function
           input integer value;
           begin
               for (log2=0; value>0; log2=log2+1)
                   value = value>>1;
               log2 = log2 - 1;
           end
    endfunction
endmodule
    
    
    
    
