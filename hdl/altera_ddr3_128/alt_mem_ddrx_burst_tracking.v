
//altera message_off 10230

module alt_mem_ddrx_burst_tracking
# (
    // module parameter port list
    parameter
        CFG_BURSTCOUNT_TRACKING_WIDTH   =   7,
        CFG_BUFFER_ADDR_WIDTH           =   6,
        CFG_INT_SIZE_WIDTH              =   4
)
(
    // port list
    ctl_clk,
    ctl_reset_n,

    // data burst interface
    burst_ready,
    burst_valid,

    // burstcount counter sent to data_id_manager
    burst_pending_burstcount,
    burst_next_pending_burstcount,

    // burstcount consumed by data_id_manager
    burst_consumed_valid,
    burst_counsumed_burstcount
);

    // -----------------------------
    // local parameter declarations
    // -----------------------------

    // -----------------------------
    // port declaration
    // -----------------------------

    input                                           ctl_clk;
    input                                           ctl_reset_n;
    
    // data burst interface
    input                                           burst_ready;
    input                                           burst_valid;

    // burstcount counter sent to data_id_manager
    output  [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]     burst_pending_burstcount;
    output  [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]     burst_next_pending_burstcount;

    // burstcount consumed by data_id_manager
    input                                           burst_consumed_valid;
    input   [CFG_INT_SIZE_WIDTH-1:0]                burst_counsumed_burstcount;

    // -----------------------------
    // port type declaration
    // -----------------------------

    wire                                            ctl_clk;
    wire                                            ctl_reset_n;

    // data burst interface
    wire                                            burst_ready;
    wire                                            burst_valid;

    // burstcount counter sent to data_id_manager
    wire    [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]     burst_pending_burstcount;
    wire    [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]     burst_next_pending_burstcount;
    //wire    [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]    burst_count_accepted;

    // burstcount consumed by data_id_manager
    wire                                            burst_consumed_valid;
    wire    [CFG_INT_SIZE_WIDTH-1:0]                burst_counsumed_burstcount;


    // -----------------------------
    // signal declaration
    // -----------------------------

    reg     [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]     burst_counter;
    reg     [CFG_BURSTCOUNT_TRACKING_WIDTH-1:0]     burst_counter_next;
    wire                                            burst_accepted;

    // -----------------------------
    // module definition
    // -----------------------------

    assign burst_pending_burstcount      = burst_counter;
    assign burst_next_pending_burstcount = burst_counter_next;
    
    assign burst_accepted = burst_ready & burst_valid;

    always @ (*) 
    begin
        if (burst_accepted & burst_consumed_valid)
        begin
            burst_counter_next = burst_counter + 1 - burst_counsumed_burstcount;
        end
        else if (burst_accepted)
        begin
            burst_counter_next = burst_counter + 1;
        end
        else if (burst_consumed_valid)
        begin
            burst_counter_next = burst_counter - burst_counsumed_burstcount;
        end
        else 
        begin
            burst_counter_next = burst_counter;
        end
    end

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            burst_counter <= 0;
        end
        else
        begin

            burst_counter <= burst_counter_next;

        end
    end
    
endmodule
