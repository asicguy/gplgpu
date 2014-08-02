module alt_mem_ddrx_buffer_manager
# (
    parameter
        CFG_BUFFER_ADDR_WIDTH         =   6
)
(
    // port list
    ctl_clk,
    ctl_reset_n,

    // write interface
    writeif_ready,
    writeif_valid,
    writeif_address,
    writeif_address_blocked,

    // buffer write interface
    buffwrite_valid,
    buffwrite_address,

    // read interface
    readif_valid,
    readif_address,

    // buffer read interface
    buffread_valid,
    buffread_datavalid,
    buffread_address

);

    // -----------------------------
    // local parameter declarations
    // -----------------------------

    localparam CTL_BUFFER_DEPTH             =   two_pow_N(CFG_BUFFER_ADDR_WIDTH);

    // -----------------------------
    // port declaration
    // -----------------------------

    input                                           ctl_clk;
    input                                           ctl_reset_n;

    // write interface
    output                                          writeif_ready;
    input                                           writeif_valid;
    input  [CFG_BUFFER_ADDR_WIDTH-1:0]              writeif_address;
    input                                           writeif_address_blocked;

    // buffer write interface
    output                                          buffwrite_valid;
    output  [CFG_BUFFER_ADDR_WIDTH-1:0]             buffwrite_address;

    // read data interface
    input                                           readif_valid;
    input   [CFG_BUFFER_ADDR_WIDTH-1:0]             readif_address;

    // buffer read interface
    output                                          buffread_valid;
    output                                          buffread_datavalid;
    output  [CFG_BUFFER_ADDR_WIDTH-1:0]             buffread_address;

    // -----------------------------
    // port type declaration
    // -----------------------------

    wire                                            ctl_clk;
    wire                                            ctl_reset_n;
                                                                             
    // write interface                                                       
    reg                                             writeif_ready;
    wire                                            writeif_valid;
    wire     [CFG_BUFFER_ADDR_WIDTH-1:0]            writeif_address;
                                                                             
    wire                                            writeif_address_blocked;
                                                                             
    // buffer write interface                                                
    wire                                            buffwrite_valid;
    wire     [CFG_BUFFER_ADDR_WIDTH-1:0]            buffwrite_address;
                                                                             
    // read data interface                                                   
    wire                                            readif_valid;
    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]             readif_address;
                                                                             
    // buffer read interface                                                 
    wire                                            buffread_valid;
    reg                                             buffread_datavalid;
    wire    [CFG_BUFFER_ADDR_WIDTH-1:0]             buffread_address;

    // -----------------------------
    // signal declaration
    // -----------------------------

    wire                                            writeif_accepted;
    reg     [CTL_BUFFER_DEPTH-1:0]                  mux_writeif_ready;
    reg     [CTL_BUFFER_DEPTH-1:0]                  buffer_valid_array;    
    reg     [CFG_BUFFER_ADDR_WIDTH-1:0]             buffer_valid_counter;
                                                                                       
    reg                                             err_buffer_valid_counter_overflow;

    // -----------------------------
    // module definition
    // -----------------------------

    assign  writeif_accepted    = writeif_ready & writeif_valid;

    assign  buffwrite_address   = writeif_address;
    assign  buffwrite_valid     = writeif_accepted;

    assign  buffread_address    = readif_address;
    assign  buffread_valid      = readif_valid;

    always @ (*) 
    begin

        if (writeif_address_blocked)
        begin
            // can't write ahead of lowest address currently tracked by dataid array
            writeif_ready = 1'b0;
        end
        else 
        begin
            // buffer is full when every location has been written
            writeif_ready = ~&buffer_valid_counter;
        end

    end


    // generate buffread_datavalid. 
    // data is valid one cycle after adddress is presented to the buffer
    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            buffread_datavalid <= 0;
        end
        else
        begin
            buffread_datavalid <= buffread_valid;
        end
    end


    // genvar i;
    // generate
    //     for (i = 0; i < CTL_BUFFER_DEPTH; i = i + 1) 
    //     begin : gen_mux_buffer_valid_array_signals

    //         wire    [CFG_BUFFER_ADDR_WIDTH-1:0] gen_buffer_address = i;

    //         always @ (posedge ctl_clk or negedge ctl_reset_n) 
    //         begin
    //             if (~ctl_reset_n)
    //             begin
    //                 //reset state ...
    //                 buffer_valid_array [i] <= 0;
    //             end
    //             else
    //             begin
    //                 //active state ...

    //                 // write & read to same location won't happen on same time

    //                 // write
    //                 if ( (writeif_address == gen_buffer_address) & writeif_accepted)
    //                 begin
    //                     buffer_valid_array[i] <= 1;
    //                 end

    //                 // read
    //                 if ( (readif_address== gen_buffer_address) & readif_valid)
    //                 begin
    //                     buffer_valid_array[i] <= 0;
    //                 end

    //             end
    //         end

    //         always @ (*) 
    //         begin
    //             // mano - fmax !    
    //             if ( (writeif_address == gen_buffer_address) & buffer_valid_array[i] )
    //             begin
    //                 mux_writeif_ready[i]  = 0;
    //             end
    //             else
    //             begin
    //                 mux_writeif_ready[i]  = 1;
    //             end
    //         end

    //     end
    // endgenerate

    always @ (posedge ctl_clk or negedge ctl_reset_n) 
    begin
        if (~ctl_reset_n)
        begin
            buffer_valid_counter <= 0;
            err_buffer_valid_counter_overflow <= 0;
        end
        else
        begin

            if (writeif_accepted & readif_valid)
            begin
                // write & read at same time
                buffer_valid_counter <= buffer_valid_counter;
            end
            else if (writeif_accepted)
            begin
                // write only
                {err_buffer_valid_counter_overflow, buffer_valid_counter} <= buffer_valid_counter + 1;
            end
            else if (readif_valid)
            begin
                // read only
                buffer_valid_counter <= buffer_valid_counter - 1;
            end
            else
            begin
                buffer_valid_counter <= buffer_valid_counter;
            end


        end
    end



    function integer two_pow_N;
        input integer value;
    begin
        two_pow_N = 2 << (value-1);
    end
    endfunction



endmodule

//
// assert
//
// - write & read to same location happen on same time
