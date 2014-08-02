
//altera message_off 10230

module alt_mem_ddrx_list
# (
    // module parameter port list
    parameter
        CTL_LIST_WIDTH              =    3,        // number of dram commands that can be tracked at a time
        CTL_LIST_DEPTH              =    8,
        CTL_LIST_INIT_VALUE_TYPE    =    "INCR",   // INCR, ZERO
        CTL_LIST_INIT_VALID         =    "VALID"   // VALID, INVALID
)
(
    // port list
    ctl_clk,
    ctl_reset_n,

    // pop free list
    list_get_entry_valid,
    list_get_entry_ready,
    list_get_entry_id,   
    list_get_entry_id_vector,

    // push free list
    list_put_entry_valid,
    list_put_entry_ready,
    list_put_entry_id   

);

    // -----------------------------
    // port declaration
    // -----------------------------

    input                               ctl_clk;
    input                               ctl_reset_n;

    // pop free list
    input                               list_get_entry_ready;
    output                              list_get_entry_valid;
    output [CTL_LIST_WIDTH-1:0]         list_get_entry_id;
    output [CTL_LIST_DEPTH-1:0]         list_get_entry_id_vector;

    // push free list
    output                              list_put_entry_ready;
    input                               list_put_entry_valid;
    input [CTL_LIST_WIDTH-1:0]          list_put_entry_id;


    // -----------------------------
    // port type declaration
    // -----------------------------

    reg                                 list_get_entry_valid;
    wire                                list_get_entry_ready;
    reg  [CTL_LIST_WIDTH-1:0]           list_get_entry_id;   
    reg  [CTL_LIST_DEPTH-1:0]           list_get_entry_id_vector;

    wire                                list_put_entry_valid;
    reg                                 list_put_entry_ready;
    wire [CTL_LIST_WIDTH-1:0]           list_put_entry_id;

    // -----------------------------
    // signal declaration
    // -----------------------------

    reg [CTL_LIST_WIDTH-1:0]            list          [CTL_LIST_DEPTH-1:0];
    reg                                 list_v        [CTL_LIST_DEPTH-1:0];
    reg [CTL_LIST_DEPTH-1:0]            list_vector;

    wire                                list_get = list_get_entry_valid & list_get_entry_ready;
    wire                                list_put = list_put_entry_valid & list_put_entry_ready;

    // -----------------------------
    // module definition
    // -----------------------------

    // generate interface signals
    always @ (*) 
    begin
        // connect interface signals to list head & tail
        list_get_entry_valid     = list_v[0];
        list_get_entry_id        = list[0];
        list_get_entry_id_vector = list_vector;
        list_put_entry_ready     = ~list_v[CTL_LIST_DEPTH-1];
    end

    // list put & get management
    integer i; 
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            for (i = 0; i < CTL_LIST_DEPTH; i = i + 1'b1)
            begin
                // initialize every entry
                if (CTL_LIST_INIT_VALUE_TYPE == "INCR")
                begin
                    list           [i]     <= i;
                end
                else
                begin
                    list           [i]     <= {CTL_LIST_WIDTH{1'b0}};
                end

                if (CTL_LIST_INIT_VALID == "VALID")
                begin
                    list_v         [i]     <= 1'b1;
                end
                else
                begin
                    list_v         [i]     <= 1'b0;
                end

            end
            
            list_vector <= {CTL_LIST_DEPTH{1'b0}};
        end
        else
        begin
            // get request code must be above put request code
            if (list_get)
            begin
                // on a get request, list is shifted to move next entry to head
                for (i = 1; i < CTL_LIST_DEPTH; i = i + 1'b1)
                begin
                    list_v     [i-1]   <=  list_v [i];
                    list       [i-1]   <=  list   [i];
                end

                    list_v     [CTL_LIST_DEPTH-1]   <=  0;
                
                for (i = 0; i < CTL_LIST_DEPTH;i = i + 1'b1)
                begin
                    if (i == list [1])
                    begin
                        list_vector [i] <= 1'b1;
                    end
                    else
                    begin
                        list_vector [i] <= 1'b0;
                    end
                end
            end

            if (list_put)
            begin
                // on a put request, next empty list entry is written
                
                if (~list_get)
                begin
                    // put request only
                    for (i = 1; i < CTL_LIST_DEPTH; i = i + 1'b1)
                    begin
                        if ( list_v[i-1] & ~list_v[i])
                        begin
                            list_v     [i]   <=  1'b1;
                            list       [i]   <=  list_put_entry_id;
                        end
                    end
                    if (~list_v[0])
                    begin
                        list_v     [0]   <=  1'b1;
                        list       [0]   <=  list_put_entry_id;
                        
                        for (i = 0; i < CTL_LIST_DEPTH;i = i + 1'b1)
                        begin
                            if (i == list_put_entry_id)
                            begin
                                list_vector [i] <= 1'b1;
                            end
                            else
                            begin
                                list_vector [i] <= 1'b0;
                            end
                        end
                    end
                end
                else
                begin
                    // put & get request on same cycle
                    for (i = 1; i < CTL_LIST_DEPTH; i = i + 1'b1)
                    begin
                        if (list_v[i-1] & ~list_v[i])
                        begin
                            list_v     [i-1]   <=  1'b1;
                            list       [i-1]   <=  list_put_entry_id;
                        end
                    end
                    // if (~list_v[0])
                    // begin
                    //     $display("error - list underflow");
                    // end
                    
                    for (i = 0; i < CTL_LIST_DEPTH;i = i + 1'b1)
                    begin
                        if (list_v[0] & ~list_v[1])
                        begin
                            if (i == list_put_entry_id)
                            begin
                                list_vector [i] <= 1'b1;
                            end
                            else
                            begin
                                list_vector [i] <= 1'b0;
                            end
                        end
                        else
                        begin
                            if (i == list [1])
                            begin
                                list_vector [i] <= 1'b1;
                            end
                            else
                            begin
                                list_vector [i] <= 1'b0;
                            end
                        end
                    end
                end

            end

        end
    end

endmodule
