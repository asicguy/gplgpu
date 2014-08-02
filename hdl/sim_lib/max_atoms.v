// Copyright (C) 1991-2011 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.
// Quartus II 11.0 Build 157 04/27/2011

///////////////////////////////////////////////////////////////////////////////
//
// MAX IO Atom
//
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module max_asynch_io (datain, oe, padio, dataout);

    parameter operation_mode = "input";
    parameter bus_hold = "false";
    parameter open_drain_output = "false";
    parameter weak_pull_up = "false";

    input datain, oe;
    output dataout;
    inout padio;

    reg  prev_value;

    reg tmp_padio, tmp_dataout;
    reg buf_control;

    wire datain_in;
    wire oe_in;

    buf(datain_in, datain);
    buf(oe_in, oe);

    tri padio_tmp;

specify
    (padio => dataout) = (0,0);
    (datain => padio) = (0, 0);
    (posedge oe => (padio +: padio_tmp)) = (0, 0);
    (negedge oe => (padio +: 1'bz)) = (0, 0);

endspecify

initial
begin
    prev_value = 'b1;
    tmp_padio = 'bz;
end

always @(datain_in or oe_in or padio)
begin
		if (bus_hold == "true" )
        begin
                buf_control = 'b1;
				if (operation_mode == "input")
				begin
					prev_value = padio;
					tmp_dataout = padio;					
				end
                else if ( operation_mode == "output" || operation_mode == "bidir")
                begin
                        if ( oe_in == 1)
                        begin
                                if ( open_drain_output == "true" )
                                begin
                                        if (datain_in == 0)
                                        begin
                                                tmp_padio =     1'b0;
                                                prev_value = 1'b0;
                                        end
                                        else if (datain_in == 1'bx)
                                        begin
                                                tmp_padio = 1'bx;
                                                prev_value = 1'bx;
                                        end
                                        else   // 'Z'
                                        begin
                                                if ( padio != 1'bz)
                                                begin
                                                        prev_value = padio;
                                                end
                                        end
                                end  // end open_drain_output , true
                                else
                                begin
                                        tmp_padio = datain_in;
                                        prev_value = datain_in;
                                end  // end open_drain_output false
                        end             // end oe_in == 1
                        else if ( oe_in == 0 )
                        begin
							if ( padio !== 1'bz)
							begin
								prev_value = padio;
								if ((padio === 1'bx) && (operation_mode == "output") && (padio_tmp === 1'bx) && (prev_value === 1'bx))
								begin
									prev_value = 'b0;
								end
							end
							tmp_padio = 'bz;
                        end
                        else
                        begin
							begin
                                tmp_padio = 1'bx;
                                prev_value = 1'bx;
                        end
                        end

                        if ( operation_mode == "bidir")
                                tmp_dataout = padio;
                        else
                                tmp_dataout = 1'bz;

                        if ( $realtime <= 1 )
                                prev_value = 0;
                end
        end
        else    // bus hold is false
		if (bus_hold == "false")
        begin
                buf_control = 'b0;
                if ( operation_mode == "input")
                begin
                        tmp_dataout = padio;
						if (weak_pull_up == "true")
						begin
							if (tmp_dataout === 1'bz)
								tmp_dataout = 1'b1;
						end
                end
                else if (operation_mode == "output" || operation_mode == "bidir")
                begin
                        if ( operation_mode  == "bidir")
						begin
                                tmp_dataout = padio;
								if (weak_pull_up == "true")
								begin
									if (tmp_dataout === 1'bz)
										tmp_dataout = 1'b1;
								end
						end
                        if ( oe_in == 1 )
                        begin
                                if ( open_drain_output == "true" )
                                begin
                                        if (datain_in == 0)
                                                tmp_padio = 1'b0;
                                        else if ( datain_in == 1'bx)
                                                tmp_padio = 1'bx;
                                        else
										begin
                                                tmp_padio = 1'bz;
												if (weak_pull_up == "true")
												begin
													if (tmp_padio === 1'bz)
														buf_control = 1;
												end
										end

                                end
                                else
								begin
										if ((datain_in !== 1'b1)&&(datain_in !== 1'b0)&&(datain_in !== 'bx))
											tmp_padio = 'bz;
										else
                                        tmp_padio = datain_in;
										
										if (weak_pull_up == "true")
										begin
											if (tmp_padio === 1'bz)
												buf_control = 1;
										end
                        end
                        end
                        else if ( oe_in == 0 )
						begin
                                tmp_padio = 1'bz;
								if (weak_pull_up == "true")
								begin
									if (tmp_padio === 1'bz)
									begin
										buf_control = 1;
									end
								end
						end
                        else
                                tmp_padio = 1'bx;
                end
                else
                begin
                        $display ("Error: Invalid operation_mode specified in max io atom!\n");
                        $display ("Time: %0t  Instance: %m", $time);
                end
        end
end

bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
pmos (padio_tmp, tmp_padio, 'b0);
pmos (dataout, tmp_dataout, 'b0);
pmos (padio, padio_tmp, 'b0);

endmodule


module max_io (datain, oe, padio, dataout);

        parameter operation_mode = "input";
		parameter bus_hold = "false";
		parameter open_drain_output = "false";
		parameter weak_pull_up = "false";

        inout        padio;
        input        datain, oe;
        output       dataout;

	max_asynch_io asynch_inst (datain, oe, padio, dataout);
   	defparam
		asynch_inst.operation_mode = operation_mode,
		asynch_inst.bus_hold = bus_hold,
	    asynch_inst.open_drain_output = open_drain_output,
	    asynch_inst.weak_pull_up = weak_pull_up;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// MAX MCELL ATOM
//
//////////////////////////////////////////////////////////////////////////////

//   MAX MCELL ASYNCH

`timescale 1 ps/1 ps
module  max_asynch_mcell (pterm0, pterm1, pterm2, pterm3, pterm4, 
			  pterm5, fpin, pxor, pexpin, fbkin, 
			  combout, pexpout, regin);

   parameter operation_mode	= "normal";
   parameter pexp_mode = "off";
   parameter register_mode = "dff";

   input [51:0] pterm0, pterm1, pterm2, pterm3, pterm4, pterm5, pxor;
   input 	pexpin, fbkin, fpin;
   output 	combout, pexpout, regin;

   reg 		icomb, ipexpout, tmp_comb, tmp_fpin;
   reg 		tmp_pterm0, tmp_pterm1, tmp_pterm2;
   reg 		tmp_pterm3, tmp_pterm4, tmp_pexpin;
   wire [51:0] 	ipterm0, ipterm1, ipterm2, ipterm3, ipterm4, ipterm5, ipxor;
    
    wire ipexpin;
    wire ifpin;

    buf (ipexpin, pexpin);
    buf (ifpin, fpin);

    buf (ipterm0[0], pterm0[0]);
    buf (ipterm0[1], pterm0[1]);
    buf (ipterm0[2], pterm0[2]);
    buf (ipterm0[3], pterm0[3]);
    buf (ipterm0[4], pterm0[4]);
    buf (ipterm0[5], pterm0[5]);
    buf (ipterm0[6], pterm0[6]);
    buf (ipterm0[7], pterm0[7]);
    buf (ipterm0[8], pterm0[8]);
    buf (ipterm0[9], pterm0[9]);
    buf (ipterm0[10], pterm0[10]);
    buf (ipterm0[11], pterm0[11]);
    buf (ipterm0[12], pterm0[12]);
    buf (ipterm0[13], pterm0[13]);
    buf (ipterm0[14], pterm0[14]);
    buf (ipterm0[15], pterm0[15]);
    buf (ipterm0[16], pterm0[16]);
    buf (ipterm0[17], pterm0[17]);
    buf (ipterm0[18], pterm0[18]);
    buf (ipterm0[19], pterm0[19]);
    buf (ipterm0[20], pterm0[20]);
    buf (ipterm0[21], pterm0[21]);
    buf (ipterm0[22], pterm0[22]);
    buf (ipterm0[23], pterm0[23]);
    buf (ipterm0[24], pterm0[24]);
    buf (ipterm0[25], pterm0[25]);
    buf (ipterm0[26], pterm0[26]);
    buf (ipterm0[27], pterm0[27]);
    buf (ipterm0[28], pterm0[28]);
    buf (ipterm0[29], pterm0[29]);
    buf (ipterm0[30], pterm0[30]);
    buf (ipterm0[31], pterm0[31]);
    buf (ipterm0[32], pterm0[32]);
    buf (ipterm0[33], pterm0[33]);
    buf (ipterm0[34], pterm0[34]);
    buf (ipterm0[35], pterm0[35]);
    buf (ipterm0[36], pterm0[36]);
    buf (ipterm0[37], pterm0[37]);
    buf (ipterm0[38], pterm0[38]);
    buf (ipterm0[39], pterm0[39]);
    buf (ipterm0[40], pterm0[40]);
    buf (ipterm0[41], pterm0[41]);
    buf (ipterm0[42], pterm0[42]);
    buf (ipterm0[43], pterm0[43]);
    buf (ipterm0[44], pterm0[44]);
    buf (ipterm0[45], pterm0[45]);
    buf (ipterm0[46], pterm0[46]);
    buf (ipterm0[47], pterm0[47]);
    buf (ipterm0[48], pterm0[48]);
    buf (ipterm0[49], pterm0[49]);
    buf (ipterm0[50], pterm0[50]);
    buf (ipterm0[51], pterm0[51]);

    buf (ipterm1[0], pterm1[0]);
    buf (ipterm1[1], pterm1[1]);
    buf (ipterm1[2], pterm1[2]);
    buf (ipterm1[3], pterm1[3]);
    buf (ipterm1[4], pterm1[4]);
    buf (ipterm1[5], pterm1[5]);
    buf (ipterm1[6], pterm1[6]);
    buf (ipterm1[7], pterm1[7]);
    buf (ipterm1[8], pterm1[8]);
    buf (ipterm1[9], pterm1[9]);
    buf (ipterm1[10], pterm1[10]);
    buf (ipterm1[11], pterm1[11]);
    buf (ipterm1[12], pterm1[12]);
    buf (ipterm1[13], pterm1[13]);
    buf (ipterm1[14], pterm1[14]);
    buf (ipterm1[15], pterm1[15]);
    buf (ipterm1[16], pterm1[16]);
    buf (ipterm1[17], pterm1[17]);
    buf (ipterm1[18], pterm1[18]);
    buf (ipterm1[19], pterm1[19]);
    buf (ipterm1[20], pterm1[20]);
    buf (ipterm1[21], pterm1[21]);
    buf (ipterm1[22], pterm1[22]);
    buf (ipterm1[23], pterm1[23]);
    buf (ipterm1[24], pterm1[24]);
    buf (ipterm1[25], pterm1[25]);
    buf (ipterm1[26], pterm1[26]);
    buf (ipterm1[27], pterm1[27]);
    buf (ipterm1[28], pterm1[28]);
    buf (ipterm1[29], pterm1[29]);
    buf (ipterm1[30], pterm1[30]);
    buf (ipterm1[31], pterm1[31]);
    buf (ipterm1[32], pterm1[32]);
    buf (ipterm1[33], pterm1[33]);
    buf (ipterm1[34], pterm1[34]);
    buf (ipterm1[35], pterm1[35]);
    buf (ipterm1[36], pterm1[36]);
    buf (ipterm1[37], pterm1[37]);
    buf (ipterm1[38], pterm1[38]);
    buf (ipterm1[39], pterm1[39]);
    buf (ipterm1[40], pterm1[40]);
    buf (ipterm1[41], pterm1[41]);
    buf (ipterm1[42], pterm1[42]);
    buf (ipterm1[43], pterm1[43]);
    buf (ipterm1[44], pterm1[44]);
    buf (ipterm1[45], pterm1[45]);
    buf (ipterm1[46], pterm1[46]);
    buf (ipterm1[47], pterm1[47]);
    buf (ipterm1[48], pterm1[48]);
    buf (ipterm1[49], pterm1[49]);
    buf (ipterm1[50], pterm1[50]);
    buf (ipterm1[51], pterm1[51]);

    buf (ipterm2[0], pterm2[0]);
    buf (ipterm2[1], pterm2[1]);
    buf (ipterm2[2], pterm2[2]);
    buf (ipterm2[3], pterm2[3]);
    buf (ipterm2[4], pterm2[4]);
    buf (ipterm2[5], pterm2[5]);
    buf (ipterm2[6], pterm2[6]);
    buf (ipterm2[7], pterm2[7]);
    buf (ipterm2[8], pterm2[8]);
    buf (ipterm2[9], pterm2[9]);
    buf (ipterm2[10], pterm2[10]);
    buf (ipterm2[11], pterm2[11]);
    buf (ipterm2[12], pterm2[12]);
    buf (ipterm2[13], pterm2[13]);
    buf (ipterm2[14], pterm2[14]);
    buf (ipterm2[15], pterm2[15]);
    buf (ipterm2[16], pterm2[16]);
    buf (ipterm2[17], pterm2[17]);
    buf (ipterm2[18], pterm2[18]);
    buf (ipterm2[19], pterm2[19]);
    buf (ipterm2[20], pterm2[20]);
    buf (ipterm2[21], pterm2[21]);
    buf (ipterm2[22], pterm2[22]);
    buf (ipterm2[23], pterm2[23]);
    buf (ipterm2[24], pterm2[24]);
    buf (ipterm2[25], pterm2[25]);
    buf (ipterm2[26], pterm2[26]);
    buf (ipterm2[27], pterm2[27]);
    buf (ipterm2[28], pterm2[28]);
    buf (ipterm2[29], pterm2[29]);
    buf (ipterm2[30], pterm2[30]);
    buf (ipterm2[31], pterm2[31]);
    buf (ipterm2[32], pterm2[32]);
    buf (ipterm2[33], pterm2[33]);
    buf (ipterm2[34], pterm2[34]);
    buf (ipterm2[35], pterm2[35]);
    buf (ipterm2[36], pterm2[36]);
    buf (ipterm2[37], pterm2[37]);
    buf (ipterm2[38], pterm2[38]);
    buf (ipterm2[39], pterm2[39]);
    buf (ipterm2[40], pterm2[40]);
    buf (ipterm2[41], pterm2[41]);
    buf (ipterm2[42], pterm2[42]);
    buf (ipterm2[43], pterm2[43]);
    buf (ipterm2[44], pterm2[44]);
    buf (ipterm2[45], pterm2[45]);
    buf (ipterm2[46], pterm2[46]);
    buf (ipterm2[47], pterm2[47]);
    buf (ipterm2[48], pterm2[48]);
    buf (ipterm2[49], pterm2[49]);
    buf (ipterm2[50], pterm2[50]);
    buf (ipterm2[51], pterm2[51]);

    buf (ipterm3[0], pterm3[0]);
    buf (ipterm3[1], pterm3[1]);
    buf (ipterm3[2], pterm3[2]);
    buf (ipterm3[3], pterm3[3]);
    buf (ipterm3[4], pterm3[4]);
    buf (ipterm3[5], pterm3[5]);
    buf (ipterm3[6], pterm3[6]);
    buf (ipterm3[7], pterm3[7]);
    buf (ipterm3[8], pterm3[8]);
    buf (ipterm3[9], pterm3[9]);
    buf (ipterm3[10], pterm3[10]);
    buf (ipterm3[11], pterm3[11]);
    buf (ipterm3[12], pterm3[12]);
    buf (ipterm3[13], pterm3[13]);
    buf (ipterm3[14], pterm3[14]);
    buf (ipterm3[15], pterm3[15]);
    buf (ipterm3[16], pterm3[16]);
    buf (ipterm3[17], pterm3[17]);
    buf (ipterm3[18], pterm3[18]);
    buf (ipterm3[19], pterm3[19]);
    buf (ipterm3[20], pterm3[20]);
    buf (ipterm3[21], pterm3[21]);
    buf (ipterm3[22], pterm3[22]);
    buf (ipterm3[23], pterm3[23]);
    buf (ipterm3[24], pterm3[24]);
    buf (ipterm3[25], pterm3[25]);
    buf (ipterm3[26], pterm3[26]);
    buf (ipterm3[27], pterm3[27]);
    buf (ipterm3[28], pterm3[28]);
    buf (ipterm3[29], pterm3[29]);
    buf (ipterm3[30], pterm3[30]);
    buf (ipterm3[31], pterm3[31]);
    buf (ipterm3[32], pterm3[32]);
    buf (ipterm3[33], pterm3[33]);
    buf (ipterm3[34], pterm3[34]);
    buf (ipterm3[35], pterm3[35]);
    buf (ipterm3[36], pterm3[36]);
    buf (ipterm3[37], pterm3[37]);
    buf (ipterm3[38], pterm3[38]);
    buf (ipterm3[39], pterm3[39]);
    buf (ipterm3[40], pterm3[40]);
    buf (ipterm3[41], pterm3[41]);
    buf (ipterm3[42], pterm3[42]);
    buf (ipterm3[43], pterm3[43]);
    buf (ipterm3[44], pterm3[44]);
    buf (ipterm3[45], pterm3[45]);
    buf (ipterm3[46], pterm3[46]);
    buf (ipterm3[47], pterm3[47]);
    buf (ipterm3[48], pterm3[48]);
    buf (ipterm3[49], pterm3[49]);
    buf (ipterm3[50], pterm3[50]);
    buf (ipterm3[51], pterm3[51]);

    buf (ipterm4[0], pterm4[0]);
    buf (ipterm4[1], pterm4[1]);
    buf (ipterm4[2], pterm4[2]);
    buf (ipterm4[3], pterm4[3]);
    buf (ipterm4[4], pterm4[4]);
    buf (ipterm4[5], pterm4[5]);
    buf (ipterm4[6], pterm4[6]);
    buf (ipterm4[7], pterm4[7]);
    buf (ipterm4[8], pterm4[8]);
    buf (ipterm4[9], pterm4[9]);
    buf (ipterm4[10], pterm4[10]);
    buf (ipterm4[11], pterm4[11]);
    buf (ipterm4[12], pterm4[12]);
    buf (ipterm4[13], pterm4[13]);
    buf (ipterm4[14], pterm4[14]);
    buf (ipterm4[15], pterm4[15]);
    buf (ipterm4[16], pterm4[16]);
    buf (ipterm4[17], pterm4[17]);
    buf (ipterm4[18], pterm4[18]);
    buf (ipterm4[19], pterm4[19]);
    buf (ipterm4[20], pterm4[20]);
    buf (ipterm4[21], pterm4[21]);
    buf (ipterm4[22], pterm4[22]);
    buf (ipterm4[23], pterm4[23]);
    buf (ipterm4[24], pterm4[24]);
    buf (ipterm4[25], pterm4[25]);
    buf (ipterm4[26], pterm4[26]);
    buf (ipterm4[27], pterm4[27]);
    buf (ipterm4[28], pterm4[28]);
    buf (ipterm4[29], pterm4[29]);
    buf (ipterm4[30], pterm4[30]);
    buf (ipterm4[31], pterm4[31]);
    buf (ipterm4[32], pterm4[32]);
    buf (ipterm4[33], pterm4[33]);
    buf (ipterm4[34], pterm4[34]);
    buf (ipterm4[35], pterm4[35]);
    buf (ipterm4[36], pterm4[36]);
    buf (ipterm4[37], pterm4[37]);
    buf (ipterm4[38], pterm4[38]);
    buf (ipterm4[39], pterm4[39]);
    buf (ipterm4[40], pterm4[40]);
    buf (ipterm4[41], pterm4[41]);
    buf (ipterm4[42], pterm4[42]);
    buf (ipterm4[43], pterm4[43]);
    buf (ipterm4[44], pterm4[44]);
    buf (ipterm4[45], pterm4[45]);
    buf (ipterm4[46], pterm4[46]);
    buf (ipterm4[47], pterm4[47]);
    buf (ipterm4[48], pterm4[48]);
    buf (ipterm4[49], pterm4[49]);
    buf (ipterm4[50], pterm4[50]);
    buf (ipterm4[51], pterm4[51]);

    buf (ipterm5[0], pterm5[0]);
    buf (ipterm5[1], pterm5[1]);
    buf (ipterm5[2], pterm5[2]);
    buf (ipterm5[3], pterm5[3]);
    buf (ipterm5[4], pterm5[4]);
    buf (ipterm5[5], pterm5[5]);
    buf (ipterm5[6], pterm5[6]);
    buf (ipterm5[7], pterm5[7]);
    buf (ipterm5[8], pterm5[8]);
    buf (ipterm5[9], pterm5[9]);
    buf (ipterm5[10], pterm5[10]);
    buf (ipterm5[11], pterm5[11]);
    buf (ipterm5[12], pterm5[12]);
    buf (ipterm5[13], pterm5[13]);
    buf (ipterm5[14], pterm5[14]);
    buf (ipterm5[15], pterm5[15]);
    buf (ipterm5[16], pterm5[16]);
    buf (ipterm5[17], pterm5[17]);
    buf (ipterm5[18], pterm5[18]);
    buf (ipterm5[19], pterm5[19]);
    buf (ipterm5[20], pterm5[20]);
    buf (ipterm5[21], pterm5[21]);
    buf (ipterm5[22], pterm5[22]);
    buf (ipterm5[23], pterm5[23]);
    buf (ipterm5[24], pterm5[24]);
    buf (ipterm5[25], pterm5[25]);
    buf (ipterm5[26], pterm5[26]);
    buf (ipterm5[27], pterm5[27]);
    buf (ipterm5[28], pterm5[28]);
    buf (ipterm5[29], pterm5[29]);
    buf (ipterm5[30], pterm5[30]);
    buf (ipterm5[31], pterm5[31]);
    buf (ipterm5[32], pterm5[32]);
    buf (ipterm5[33], pterm5[33]);
    buf (ipterm5[34], pterm5[34]);
    buf (ipterm5[35], pterm5[35]);
    buf (ipterm5[36], pterm5[36]);
    buf (ipterm5[37], pterm5[37]);
    buf (ipterm5[38], pterm5[38]);
    buf (ipterm5[39], pterm5[39]);
    buf (ipterm5[40], pterm5[40]);
    buf (ipterm5[41], pterm5[41]);
    buf (ipterm5[42], pterm5[42]);
    buf (ipterm5[43], pterm5[43]);
    buf (ipterm5[44], pterm5[44]);
    buf (ipterm5[45], pterm5[45]);
    buf (ipterm5[46], pterm5[46]);
    buf (ipterm5[47], pterm5[47]);
    buf (ipterm5[48], pterm5[48]);
    buf (ipterm5[49], pterm5[49]);
    buf (ipterm5[50], pterm5[50]);
    buf (ipterm5[51], pterm5[51]);

    buf (ipxor[0], pxor[0]);
    buf (ipxor[1], pxor[1]);
    buf (ipxor[2], pxor[2]);
    buf (ipxor[3], pxor[3]);
    buf (ipxor[4], pxor[4]);
    buf (ipxor[5], pxor[5]);
    buf (ipxor[6], pxor[6]);
    buf (ipxor[7], pxor[7]);
    buf (ipxor[8], pxor[8]);
    buf (ipxor[9], pxor[9]);
    buf (ipxor[10], pxor[10]);
    buf (ipxor[11], pxor[11]);
    buf (ipxor[12], pxor[12]);
    buf (ipxor[13], pxor[13]);
    buf (ipxor[14], pxor[14]);
    buf (ipxor[15], pxor[15]);
    buf (ipxor[16], pxor[16]);
    buf (ipxor[17], pxor[17]);
    buf (ipxor[18], pxor[18]);
    buf (ipxor[19], pxor[19]);
    buf (ipxor[20], pxor[20]);
    buf (ipxor[21], pxor[21]);
    buf (ipxor[22], pxor[22]);
    buf (ipxor[23], pxor[23]);
    buf (ipxor[24], pxor[24]);
    buf (ipxor[25], pxor[25]);
    buf (ipxor[26], pxor[26]);
    buf (ipxor[27], pxor[27]);
    buf (ipxor[28], pxor[28]);
    buf (ipxor[29], pxor[29]);
    buf (ipxor[30], pxor[30]);
    buf (ipxor[31], pxor[31]);
    buf (ipxor[32], pxor[32]);
    buf (ipxor[33], pxor[33]);
    buf (ipxor[34], pxor[34]);
    buf (ipxor[35], pxor[35]);
    buf (ipxor[36], pxor[36]);
    buf (ipxor[37], pxor[37]);
    buf (ipxor[38], pxor[38]);
    buf (ipxor[39], pxor[39]);
    buf (ipxor[40], pxor[40]);
    buf (ipxor[41], pxor[41]);
    buf (ipxor[42], pxor[42]);
    buf (ipxor[43], pxor[43]);
    buf (ipxor[44], pxor[44]);
    buf (ipxor[45], pxor[45]);
    buf (ipxor[46], pxor[46]);
    buf (ipxor[47], pxor[47]);
    buf (ipxor[48], pxor[48]);
    buf (ipxor[49], pxor[49]);
    buf (ipxor[50], pxor[50]);
    buf (ipxor[51], pxor[51]);

    specify

    (pterm0[0] => combout) = (0, 0) ;
    (pterm0[1] => combout) = (0, 0) ;
    (pterm0[2] => combout) = (0, 0) ;
    (pterm0[3] => combout) = (0, 0) ;
    (pterm0[4] => combout) = (0, 0) ;
    (pterm0[5] => combout) = (0, 0) ;
    (pterm0[6] => combout) = (0, 0) ;
    (pterm0[7] => combout) = (0, 0) ;
    (pterm0[8] => combout) = (0, 0) ;
    (pterm0[9] => combout) = (0, 0) ;
    (pterm0[10] => combout) = (0, 0) ;
    (pterm0[11] => combout) = (0, 0) ;
    (pterm0[12] => combout) = (0, 0) ;
    (pterm0[13] => combout) = (0, 0) ;
    (pterm0[14] => combout) = (0, 0) ;
    (pterm0[15] => combout) = (0, 0) ;
    (pterm0[16] => combout) = (0, 0) ;
    (pterm0[17] => combout) = (0, 0) ;
    (pterm0[18] => combout) = (0, 0) ;
    (pterm0[19] => combout) = (0, 0) ;
    (pterm0[20] => combout) = (0, 0) ;
    (pterm0[21] => combout) = (0, 0) ;
    (pterm0[22] => combout) = (0, 0) ;
    (pterm0[23] => combout) = (0, 0) ;
    (pterm0[24] => combout) = (0, 0) ;
    (pterm0[25] => combout) = (0, 0) ;
    (pterm0[26] => combout) = (0, 0) ;
    (pterm0[27] => combout) = (0, 0) ;
    (pterm0[28] => combout) = (0, 0) ;
    (pterm0[29] => combout) = (0, 0) ;
    (pterm0[30] => combout) = (0, 0) ;
    (pterm0[31] => combout) = (0, 0) ;
    (pterm0[32] => combout) = (0, 0) ;
    (pterm0[33] => combout) = (0, 0) ;
    (pterm0[34] => combout) = (0, 0) ;
    (pterm0[35] => combout) = (0, 0) ;
    (pterm0[36] => combout) = (0, 0) ;
    (pterm0[37] => combout) = (0, 0) ;
    (pterm0[38] => combout) = (0, 0) ;
    (pterm0[39] => combout) = (0, 0) ;
    (pterm0[40] => combout) = (0, 0) ;
    (pterm0[41] => combout) = (0, 0) ;
    (pterm0[42] => combout) = (0, 0) ;
    (pterm0[43] => combout) = (0, 0) ;
    (pterm0[44] => combout) = (0, 0) ;
    (pterm0[45] => combout) = (0, 0) ;
    (pterm0[46] => combout) = (0, 0) ;
    (pterm0[47] => combout) = (0, 0) ;
    (pterm0[48] => combout) = (0, 0) ;
    (pterm0[49] => combout) = (0, 0) ;
    (pterm0[50] => combout) = (0, 0) ;
    (pterm0[51] => combout) = (0, 0) ;

    (pterm1[0] => combout) = (0, 0) ;
    (pterm1[1] => combout) = (0, 0) ;
    (pterm1[2] => combout) = (0, 0) ;
    (pterm1[3] => combout) = (0, 0) ;
    (pterm1[4] => combout) = (0, 0) ;
    (pterm1[5] => combout) = (0, 0) ;
    (pterm1[6] => combout) = (0, 0) ;
    (pterm1[7] => combout) = (0, 0) ;
    (pterm1[8] => combout) = (0, 0) ;
    (pterm1[9] => combout) = (0, 0) ;
    (pterm1[10] => combout) = (0, 0) ;
    (pterm1[11] => combout) = (0, 0) ;
    (pterm1[12] => combout) = (0, 0) ;
    (pterm1[13] => combout) = (0, 0) ;
    (pterm1[14] => combout) = (0, 0) ;
    (pterm1[15] => combout) = (0, 0) ;
    (pterm1[16] => combout) = (0, 0) ;
    (pterm1[17] => combout) = (0, 0) ;
    (pterm1[18] => combout) = (0, 0) ;
    (pterm1[19] => combout) = (0, 0) ;
    (pterm1[20] => combout) = (0, 0) ;
    (pterm1[21] => combout) = (0, 0) ;
    (pterm1[22] => combout) = (0, 0) ;
    (pterm1[23] => combout) = (0, 0) ;
    (pterm1[24] => combout) = (0, 0) ;
    (pterm1[25] => combout) = (0, 0) ;
    (pterm1[26] => combout) = (0, 0) ;
    (pterm1[27] => combout) = (0, 0) ;
    (pterm1[28] => combout) = (0, 0) ;
    (pterm1[29] => combout) = (0, 0) ;
    (pterm1[30] => combout) = (0, 0) ;
    (pterm1[31] => combout) = (0, 0) ;
    (pterm1[32] => combout) = (0, 0) ;
    (pterm1[33] => combout) = (0, 0) ;
    (pterm1[34] => combout) = (0, 0) ;
    (pterm1[35] => combout) = (0, 0) ;
    (pterm1[36] => combout) = (0, 0) ;
    (pterm1[37] => combout) = (0, 0) ;
    (pterm1[38] => combout) = (0, 0) ;
    (pterm1[39] => combout) = (0, 0) ;
    (pterm1[40] => combout) = (0, 0) ;
    (pterm1[41] => combout) = (0, 0) ;
    (pterm1[42] => combout) = (0, 0) ;
    (pterm1[43] => combout) = (0, 0) ;
    (pterm1[44] => combout) = (0, 0) ;
    (pterm1[45] => combout) = (0, 0) ;
    (pterm1[46] => combout) = (0, 0) ;
    (pterm1[47] => combout) = (0, 0) ;
    (pterm1[48] => combout) = (0, 0) ;
    (pterm1[49] => combout) = (0, 0) ;
    (pterm1[50] => combout) = (0, 0) ;
    (pterm1[51] => combout) = (0, 0) ;

    (pterm2[0] => combout) = (0, 0) ;
    (pterm2[1] => combout) = (0, 0) ;
    (pterm2[2] => combout) = (0, 0) ;
    (pterm2[3] => combout) = (0, 0) ;
    (pterm2[4] => combout) = (0, 0) ;
    (pterm2[5] => combout) = (0, 0) ;
    (pterm2[6] => combout) = (0, 0) ;
    (pterm2[7] => combout) = (0, 0) ;
    (pterm2[8] => combout) = (0, 0) ;
    (pterm2[9] => combout) = (0, 0) ;
    (pterm2[10] => combout) = (0, 0) ;
    (pterm2[11] => combout) = (0, 0) ;
    (pterm2[12] => combout) = (0, 0) ;
    (pterm2[13] => combout) = (0, 0) ;
    (pterm2[14] => combout) = (0, 0) ;
    (pterm2[15] => combout) = (0, 0) ;
    (pterm2[16] => combout) = (0, 0) ;
    (pterm2[17] => combout) = (0, 0) ;
    (pterm2[18] => combout) = (0, 0) ;
    (pterm2[19] => combout) = (0, 0) ;
    (pterm2[20] => combout) = (0, 0) ;
    (pterm2[21] => combout) = (0, 0) ;
    (pterm2[22] => combout) = (0, 0) ;
    (pterm2[23] => combout) = (0, 0) ;
    (pterm2[24] => combout) = (0, 0) ;
    (pterm2[25] => combout) = (0, 0) ;
    (pterm2[26] => combout) = (0, 0) ;
    (pterm2[27] => combout) = (0, 0) ;
    (pterm2[28] => combout) = (0, 0) ;
    (pterm2[29] => combout) = (0, 0) ;
    (pterm2[30] => combout) = (0, 0) ;
    (pterm2[31] => combout) = (0, 0) ;
    (pterm2[32] => combout) = (0, 0) ;
    (pterm2[33] => combout) = (0, 0) ;
    (pterm2[34] => combout) = (0, 0) ;
    (pterm2[35] => combout) = (0, 0) ;
    (pterm2[36] => combout) = (0, 0) ;
    (pterm2[37] => combout) = (0, 0) ;
    (pterm2[38] => combout) = (0, 0) ;
    (pterm2[39] => combout) = (0, 0) ;
    (pterm2[40] => combout) = (0, 0) ;
    (pterm2[41] => combout) = (0, 0) ;
    (pterm2[42] => combout) = (0, 0) ;
    (pterm2[43] => combout) = (0, 0) ;
    (pterm2[44] => combout) = (0, 0) ;
    (pterm2[45] => combout) = (0, 0) ;
    (pterm2[46] => combout) = (0, 0) ;
    (pterm2[47] => combout) = (0, 0) ;
    (pterm2[48] => combout) = (0, 0) ;
    (pterm2[49] => combout) = (0, 0) ;
    (pterm2[50] => combout) = (0, 0) ;
    (pterm2[51] => combout) = (0, 0) ;

    (pterm3[0] => combout) = (0, 0) ;
    (pterm3[1] => combout) = (0, 0) ;
    (pterm3[2] => combout) = (0, 0) ;
    (pterm3[3] => combout) = (0, 0) ;
    (pterm3[4] => combout) = (0, 0) ;
    (pterm3[5] => combout) = (0, 0) ;
    (pterm3[6] => combout) = (0, 0) ;
    (pterm3[7] => combout) = (0, 0) ;
    (pterm3[8] => combout) = (0, 0) ;
    (pterm3[9] => combout) = (0, 0) ;
    (pterm3[10] => combout) = (0, 0) ;
    (pterm3[11] => combout) = (0, 0) ;
    (pterm3[12] => combout) = (0, 0) ;
    (pterm3[13] => combout) = (0, 0) ;
    (pterm3[14] => combout) = (0, 0) ;
    (pterm3[15] => combout) = (0, 0) ;
    (pterm3[16] => combout) = (0, 0) ;
    (pterm3[17] => combout) = (0, 0) ;
    (pterm3[18] => combout) = (0, 0) ;
    (pterm3[19] => combout) = (0, 0) ;
    (pterm3[20] => combout) = (0, 0) ;
    (pterm3[21] => combout) = (0, 0) ;
    (pterm3[22] => combout) = (0, 0) ;
    (pterm3[23] => combout) = (0, 0) ;
    (pterm3[24] => combout) = (0, 0) ;
    (pterm3[25] => combout) = (0, 0) ;
    (pterm3[26] => combout) = (0, 0) ;
    (pterm3[27] => combout) = (0, 0) ;
    (pterm3[28] => combout) = (0, 0) ;
    (pterm3[29] => combout) = (0, 0) ;
    (pterm3[30] => combout) = (0, 0) ;
    (pterm3[31] => combout) = (0, 0) ;
    (pterm3[32] => combout) = (0, 0) ;
    (pterm3[33] => combout) = (0, 0) ;
    (pterm3[34] => combout) = (0, 0) ;
    (pterm3[35] => combout) = (0, 0) ;
    (pterm3[36] => combout) = (0, 0) ;
    (pterm3[37] => combout) = (0, 0) ;
    (pterm3[38] => combout) = (0, 0) ;
    (pterm3[39] => combout) = (0, 0) ;
    (pterm3[40] => combout) = (0, 0) ;
    (pterm3[41] => combout) = (0, 0) ;
    (pterm3[42] => combout) = (0, 0) ;
    (pterm3[43] => combout) = (0, 0) ;
    (pterm3[44] => combout) = (0, 0) ;
    (pterm3[45] => combout) = (0, 0) ;
    (pterm3[46] => combout) = (0, 0) ;
    (pterm3[47] => combout) = (0, 0) ;
    (pterm3[48] => combout) = (0, 0) ;
    (pterm3[49] => combout) = (0, 0) ;
    (pterm3[50] => combout) = (0, 0) ;
    (pterm3[51] => combout) = (0, 0) ;

    (pterm4[0] => combout) = (0, 0) ;
    (pterm4[1] => combout) = (0, 0) ;
    (pterm4[2] => combout) = (0, 0) ;
    (pterm4[3] => combout) = (0, 0) ;
    (pterm4[4] => combout) = (0, 0) ;
    (pterm4[5] => combout) = (0, 0) ;
    (pterm4[6] => combout) = (0, 0) ;
    (pterm4[7] => combout) = (0, 0) ;
    (pterm4[8] => combout) = (0, 0) ;
    (pterm4[9] => combout) = (0, 0) ;
    (pterm4[10] => combout) = (0, 0) ;
    (pterm4[11] => combout) = (0, 0) ;
    (pterm4[12] => combout) = (0, 0) ;
    (pterm4[13] => combout) = (0, 0) ;
    (pterm4[14] => combout) = (0, 0) ;
    (pterm4[15] => combout) = (0, 0) ;
    (pterm4[16] => combout) = (0, 0) ;
    (pterm4[17] => combout) = (0, 0) ;
    (pterm4[18] => combout) = (0, 0) ;
    (pterm4[19] => combout) = (0, 0) ;
    (pterm4[20] => combout) = (0, 0) ;
    (pterm4[21] => combout) = (0, 0) ;
    (pterm4[22] => combout) = (0, 0) ;
    (pterm4[23] => combout) = (0, 0) ;
    (pterm4[24] => combout) = (0, 0) ;
    (pterm4[25] => combout) = (0, 0) ;
    (pterm4[26] => combout) = (0, 0) ;
    (pterm4[27] => combout) = (0, 0) ;
    (pterm4[28] => combout) = (0, 0) ;
    (pterm4[29] => combout) = (0, 0) ;
    (pterm4[30] => combout) = (0, 0) ;
    (pterm4[31] => combout) = (0, 0) ;
    (pterm4[32] => combout) = (0, 0) ;
    (pterm4[33] => combout) = (0, 0) ;
    (pterm4[34] => combout) = (0, 0) ;
    (pterm4[35] => combout) = (0, 0) ;
    (pterm4[36] => combout) = (0, 0) ;
    (pterm4[37] => combout) = (0, 0) ;
    (pterm4[38] => combout) = (0, 0) ;
    (pterm4[39] => combout) = (0, 0) ;
    (pterm4[40] => combout) = (0, 0) ;
    (pterm4[41] => combout) = (0, 0) ;
    (pterm4[42] => combout) = (0, 0) ;
    (pterm4[43] => combout) = (0, 0) ;
    (pterm4[44] => combout) = (0, 0) ;
    (pterm4[45] => combout) = (0, 0) ;
    (pterm4[46] => combout) = (0, 0) ;
    (pterm4[47] => combout) = (0, 0) ;
    (pterm4[48] => combout) = (0, 0) ;
    (pterm4[49] => combout) = (0, 0) ;
    (pterm4[50] => combout) = (0, 0) ;
    (pterm4[51] => combout) = (0, 0) ;

    (pterm5[0] => combout) = (0, 0) ;
    (pterm5[1] => combout) = (0, 0) ;
    (pterm5[2] => combout) = (0, 0) ;
    (pterm5[3] => combout) = (0, 0) ;
    (pterm5[4] => combout) = (0, 0) ;
    (pterm5[5] => combout) = (0, 0) ;
    (pterm5[6] => combout) = (0, 0) ;
    (pterm5[7] => combout) = (0, 0) ;
    (pterm5[8] => combout) = (0, 0) ;
    (pterm5[9] => combout) = (0, 0) ;
    (pterm5[10] => combout) = (0, 0) ;
    (pterm5[11] => combout) = (0, 0) ;
    (pterm5[12] => combout) = (0, 0) ;
    (pterm5[13] => combout) = (0, 0) ;
    (pterm5[14] => combout) = (0, 0) ;
    (pterm5[15] => combout) = (0, 0) ;
    (pterm5[16] => combout) = (0, 0) ;
    (pterm5[17] => combout) = (0, 0) ;
    (pterm5[18] => combout) = (0, 0) ;
    (pterm5[19] => combout) = (0, 0) ;
    (pterm5[20] => combout) = (0, 0) ;
    (pterm5[21] => combout) = (0, 0) ;
    (pterm5[22] => combout) = (0, 0) ;
    (pterm5[23] => combout) = (0, 0) ;
    (pterm5[24] => combout) = (0, 0) ;
    (pterm5[25] => combout) = (0, 0) ;
    (pterm5[26] => combout) = (0, 0) ;
    (pterm5[27] => combout) = (0, 0) ;
    (pterm5[28] => combout) = (0, 0) ;
    (pterm5[29] => combout) = (0, 0) ;
    (pterm5[30] => combout) = (0, 0) ;
    (pterm5[31] => combout) = (0, 0) ;
    (pterm5[32] => combout) = (0, 0) ;
    (pterm5[33] => combout) = (0, 0) ;
    (pterm5[34] => combout) = (0, 0) ;
    (pterm5[35] => combout) = (0, 0) ;
    (pterm5[36] => combout) = (0, 0) ;
    (pterm5[37] => combout) = (0, 0) ;
    (pterm5[38] => combout) = (0, 0) ;
    (pterm5[39] => combout) = (0, 0) ;
    (pterm5[40] => combout) = (0, 0) ;
    (pterm5[41] => combout) = (0, 0) ;
    (pterm5[42] => combout) = (0, 0) ;
    (pterm5[43] => combout) = (0, 0) ;
    (pterm5[44] => combout) = (0, 0) ;
    (pterm5[45] => combout) = (0, 0) ;
    (pterm5[46] => combout) = (0, 0) ;
    (pterm5[47] => combout) = (0, 0) ;
    (pterm5[48] => combout) = (0, 0) ;
    (pterm5[49] => combout) = (0, 0) ;
    (pterm5[50] => combout) = (0, 0) ;
    (pterm5[51] => combout) = (0, 0) ;

    (pxor[0] => combout) = (0, 0) ;
    (pxor[1] => combout) = (0, 0) ;
    (pxor[2] => combout) = (0, 0) ;
    (pxor[3] => combout) = (0, 0) ;
    (pxor[4] => combout) = (0, 0) ;
    (pxor[5] => combout) = (0, 0) ;
    (pxor[6] => combout) = (0, 0) ;
    (pxor[7] => combout) = (0, 0) ;
    (pxor[8] => combout) = (0, 0) ;
    (pxor[9] => combout) = (0, 0) ;
    (pxor[10] => combout) = (0, 0) ;
    (pxor[11] => combout) = (0, 0) ;
    (pxor[12] => combout) = (0, 0) ;
    (pxor[13] => combout) = (0, 0) ;
    (pxor[14] => combout) = (0, 0) ;
    (pxor[15] => combout) = (0, 0) ;
    (pxor[16] => combout) = (0, 0) ;
    (pxor[17] => combout) = (0, 0) ;
    (pxor[18] => combout) = (0, 0) ;
    (pxor[19] => combout) = (0, 0) ;
    (pxor[20] => combout) = (0, 0) ;
    (pxor[21] => combout) = (0, 0) ;
    (pxor[22] => combout) = (0, 0) ;
    (pxor[23] => combout) = (0, 0) ;
    (pxor[24] => combout) = (0, 0) ;
    (pxor[25] => combout) = (0, 0) ;
    (pxor[26] => combout) = (0, 0) ;
    (pxor[27] => combout) = (0, 0) ;
    (pxor[28] => combout) = (0, 0) ;
    (pxor[29] => combout) = (0, 0) ;
    (pxor[30] => combout) = (0, 0) ;
    (pxor[31] => combout) = (0, 0) ;
    (pxor[32] => combout) = (0, 0) ;
    (pxor[33] => combout) = (0, 0) ;
    (pxor[34] => combout) = (0, 0) ;
    (pxor[35] => combout) = (0, 0) ;
    (pxor[36] => combout) = (0, 0) ;
    (pxor[37] => combout) = (0, 0) ;
    (pxor[38] => combout) = (0, 0) ;
    (pxor[39] => combout) = (0, 0) ;
    (pxor[40] => combout) = (0, 0) ;
    (pxor[41] => combout) = (0, 0) ;
    (pxor[42] => combout) = (0, 0) ;
    (pxor[43] => combout) = (0, 0) ;
    (pxor[44] => combout) = (0, 0) ;
    (pxor[45] => combout) = (0, 0) ;
    (pxor[46] => combout) = (0, 0) ;
    (pxor[47] => combout) = (0, 0) ;
    (pxor[48] => combout) = (0, 0) ;
    (pxor[49] => combout) = (0, 0) ;
    (pxor[50] => combout) = (0, 0) ;
    (pxor[51] => combout) = (0, 0) ;

    (pexpin => combout) = (0, 0) ;

    (pterm0[0] => pexpout) = (0, 0) ;
    (pterm0[1] => pexpout) = (0, 0) ;
    (pterm0[2] => pexpout) = (0, 0) ;
    (pterm0[3] => pexpout) = (0, 0) ;
    (pterm0[4] => pexpout) = (0, 0) ;
    (pterm0[5] => pexpout) = (0, 0) ;
    (pterm0[6] => pexpout) = (0, 0) ;
    (pterm0[7] => pexpout) = (0, 0) ;
    (pterm0[8] => pexpout) = (0, 0) ;
    (pterm0[9] => pexpout) = (0, 0) ;
    (pterm0[10] => pexpout) = (0, 0) ;
    (pterm0[11] => pexpout) = (0, 0) ;
    (pterm0[12] => pexpout) = (0, 0) ;
    (pterm0[13] => pexpout) = (0, 0) ;
    (pterm0[14] => pexpout) = (0, 0) ;
    (pterm0[15] => pexpout) = (0, 0) ;
    (pterm0[16] => pexpout) = (0, 0) ;
    (pterm0[17] => pexpout) = (0, 0) ;
    (pterm0[18] => pexpout) = (0, 0) ;
    (pterm0[19] => pexpout) = (0, 0) ;
    (pterm0[20] => pexpout) = (0, 0) ;
    (pterm0[21] => pexpout) = (0, 0) ;
    (pterm0[22] => pexpout) = (0, 0) ;
    (pterm0[23] => pexpout) = (0, 0) ;
    (pterm0[24] => pexpout) = (0, 0) ;
    (pterm0[25] => pexpout) = (0, 0) ;
    (pterm0[26] => pexpout) = (0, 0) ;
    (pterm0[27] => pexpout) = (0, 0) ;
    (pterm0[28] => pexpout) = (0, 0) ;
    (pterm0[29] => pexpout) = (0, 0) ;
    (pterm0[30] => pexpout) = (0, 0) ;
    (pterm0[31] => pexpout) = (0, 0) ;
    (pterm0[32] => pexpout) = (0, 0) ;
    (pterm0[33] => pexpout) = (0, 0) ;
    (pterm0[34] => pexpout) = (0, 0) ;
    (pterm0[35] => pexpout) = (0, 0) ;
    (pterm0[36] => pexpout) = (0, 0) ;
    (pterm0[37] => pexpout) = (0, 0) ;
    (pterm0[38] => pexpout) = (0, 0) ;
    (pterm0[39] => pexpout) = (0, 0) ;
    (pterm0[40] => pexpout) = (0, 0) ;
    (pterm0[41] => pexpout) = (0, 0) ;
    (pterm0[42] => pexpout) = (0, 0) ;
    (pterm0[43] => pexpout) = (0, 0) ;
    (pterm0[44] => pexpout) = (0, 0) ;
    (pterm0[45] => pexpout) = (0, 0) ;
    (pterm0[46] => pexpout) = (0, 0) ;
    (pterm0[47] => pexpout) = (0, 0) ;
    (pterm0[48] => pexpout) = (0, 0) ;
    (pterm0[49] => pexpout) = (0, 0) ;
    (pterm0[50] => pexpout) = (0, 0) ;
    (pterm0[51] => pexpout) = (0, 0) ;

    (pterm1[0] => pexpout) = (0, 0) ;
    (pterm1[1] => pexpout) = (0, 0) ;
    (pterm1[2] => pexpout) = (0, 0) ;
    (pterm1[3] => pexpout) = (0, 0) ;
    (pterm1[4] => pexpout) = (0, 0) ;
    (pterm1[5] => pexpout) = (0, 0) ;
    (pterm1[6] => pexpout) = (0, 0) ;
    (pterm1[7] => pexpout) = (0, 0) ;
    (pterm1[8] => pexpout) = (0, 0) ;
    (pterm1[9] => pexpout) = (0, 0) ;
    (pterm1[10] => pexpout) = (0, 0) ;
    (pterm1[11] => pexpout) = (0, 0) ;
    (pterm1[12] => pexpout) = (0, 0) ;
    (pterm1[13] => pexpout) = (0, 0) ;
    (pterm1[14] => pexpout) = (0, 0) ;
    (pterm1[15] => pexpout) = (0, 0) ;
    (pterm1[16] => pexpout) = (0, 0) ;
    (pterm1[17] => pexpout) = (0, 0) ;
    (pterm1[18] => pexpout) = (0, 0) ;
    (pterm1[19] => pexpout) = (0, 0) ;
    (pterm1[20] => pexpout) = (0, 0) ;
    (pterm1[21] => pexpout) = (0, 0) ;
    (pterm1[22] => pexpout) = (0, 0) ;
    (pterm1[23] => pexpout) = (0, 0) ;
    (pterm1[24] => pexpout) = (0, 0) ;
    (pterm1[25] => pexpout) = (0, 0) ;
    (pterm1[26] => pexpout) = (0, 0) ;
    (pterm1[27] => pexpout) = (0, 0) ;
    (pterm1[28] => pexpout) = (0, 0) ;
    (pterm1[29] => pexpout) = (0, 0) ;
    (pterm1[30] => pexpout) = (0, 0) ;
    (pterm1[31] => pexpout) = (0, 0) ;
    (pterm1[32] => pexpout) = (0, 0) ;
    (pterm1[33] => pexpout) = (0, 0) ;
    (pterm1[34] => pexpout) = (0, 0) ;
    (pterm1[35] => pexpout) = (0, 0) ;
    (pterm1[36] => pexpout) = (0, 0) ;
    (pterm1[37] => pexpout) = (0, 0) ;
    (pterm1[38] => pexpout) = (0, 0) ;
    (pterm1[39] => pexpout) = (0, 0) ;
    (pterm1[40] => pexpout) = (0, 0) ;
    (pterm1[41] => pexpout) = (0, 0) ;
    (pterm1[42] => pexpout) = (0, 0) ;
    (pterm1[43] => pexpout) = (0, 0) ;
    (pterm1[44] => pexpout) = (0, 0) ;
    (pterm1[45] => pexpout) = (0, 0) ;
    (pterm1[46] => pexpout) = (0, 0) ;
    (pterm1[47] => pexpout) = (0, 0) ;
    (pterm1[48] => pexpout) = (0, 0) ;
    (pterm1[49] => pexpout) = (0, 0) ;
    (pterm1[50] => pexpout) = (0, 0) ;
    (pterm1[51] => pexpout) = (0, 0) ;

    (pterm2[0] => pexpout) = (0, 0) ;
    (pterm2[1] => pexpout) = (0, 0) ;
    (pterm2[2] => pexpout) = (0, 0) ;
    (pterm2[3] => pexpout) = (0, 0) ;
    (pterm2[4] => pexpout) = (0, 0) ;
    (pterm2[5] => pexpout) = (0, 0) ;
    (pterm2[6] => pexpout) = (0, 0) ;
    (pterm2[7] => pexpout) = (0, 0) ;
    (pterm2[8] => pexpout) = (0, 0) ;
    (pterm2[9] => pexpout) = (0, 0) ;
    (pterm2[10] => pexpout) = (0, 0) ;
    (pterm2[11] => pexpout) = (0, 0) ;
    (pterm2[12] => pexpout) = (0, 0) ;
    (pterm2[13] => pexpout) = (0, 0) ;
    (pterm2[14] => pexpout) = (0, 0) ;
    (pterm2[15] => pexpout) = (0, 0) ;
    (pterm2[16] => pexpout) = (0, 0) ;
    (pterm2[17] => pexpout) = (0, 0) ;
    (pterm2[18] => pexpout) = (0, 0) ;
    (pterm2[19] => pexpout) = (0, 0) ;
    (pterm2[20] => pexpout) = (0, 0) ;
    (pterm2[21] => pexpout) = (0, 0) ;
    (pterm2[22] => pexpout) = (0, 0) ;
    (pterm2[23] => pexpout) = (0, 0) ;
    (pterm2[24] => pexpout) = (0, 0) ;
    (pterm2[25] => pexpout) = (0, 0) ;
    (pterm2[26] => pexpout) = (0, 0) ;
    (pterm2[27] => pexpout) = (0, 0) ;
    (pterm2[28] => pexpout) = (0, 0) ;
    (pterm2[29] => pexpout) = (0, 0) ;
    (pterm2[30] => pexpout) = (0, 0) ;
    (pterm2[31] => pexpout) = (0, 0) ;
    (pterm2[32] => pexpout) = (0, 0) ;
    (pterm2[33] => pexpout) = (0, 0) ;
    (pterm2[34] => pexpout) = (0, 0) ;
    (pterm2[35] => pexpout) = (0, 0) ;
    (pterm2[36] => pexpout) = (0, 0) ;
    (pterm2[37] => pexpout) = (0, 0) ;
    (pterm2[38] => pexpout) = (0, 0) ;
    (pterm2[39] => pexpout) = (0, 0) ;
    (pterm2[40] => pexpout) = (0, 0) ;
    (pterm2[41] => pexpout) = (0, 0) ;
    (pterm2[42] => pexpout) = (0, 0) ;
    (pterm2[43] => pexpout) = (0, 0) ;
    (pterm2[44] => pexpout) = (0, 0) ;
    (pterm2[45] => pexpout) = (0, 0) ;
    (pterm2[46] => pexpout) = (0, 0) ;
    (pterm2[47] => pexpout) = (0, 0) ;
    (pterm2[48] => pexpout) = (0, 0) ;
    (pterm2[49] => pexpout) = (0, 0) ;
    (pterm2[50] => pexpout) = (0, 0) ;
    (pterm2[51] => pexpout) = (0, 0) ;

    (pterm3[0] => pexpout) = (0, 0) ;
    (pterm3[1] => pexpout) = (0, 0) ;
    (pterm3[2] => pexpout) = (0, 0) ;
    (pterm3[3] => pexpout) = (0, 0) ;
    (pterm3[4] => pexpout) = (0, 0) ;
    (pterm3[5] => pexpout) = (0, 0) ;
    (pterm3[6] => pexpout) = (0, 0) ;
    (pterm3[7] => pexpout) = (0, 0) ;
    (pterm3[8] => pexpout) = (0, 0) ;
    (pterm3[9] => pexpout) = (0, 0) ;
    (pterm3[10] => pexpout) = (0, 0) ;
    (pterm3[11] => pexpout) = (0, 0) ;
    (pterm3[12] => pexpout) = (0, 0) ;
    (pterm3[13] => pexpout) = (0, 0) ;
    (pterm3[14] => pexpout) = (0, 0) ;
    (pterm3[15] => pexpout) = (0, 0) ;
    (pterm3[16] => pexpout) = (0, 0) ;
    (pterm3[17] => pexpout) = (0, 0) ;
    (pterm3[18] => pexpout) = (0, 0) ;
    (pterm3[19] => pexpout) = (0, 0) ;
    (pterm3[20] => pexpout) = (0, 0) ;
    (pterm3[21] => pexpout) = (0, 0) ;
    (pterm3[22] => pexpout) = (0, 0) ;
    (pterm3[23] => pexpout) = (0, 0) ;
    (pterm3[24] => pexpout) = (0, 0) ;
    (pterm3[25] => pexpout) = (0, 0) ;
    (pterm3[26] => pexpout) = (0, 0) ;
    (pterm3[27] => pexpout) = (0, 0) ;
    (pterm3[28] => pexpout) = (0, 0) ;
    (pterm3[29] => pexpout) = (0, 0) ;
    (pterm3[30] => pexpout) = (0, 0) ;
    (pterm3[31] => pexpout) = (0, 0) ;
    (pterm3[32] => pexpout) = (0, 0) ;
    (pterm3[33] => pexpout) = (0, 0) ;
    (pterm3[34] => pexpout) = (0, 0) ;
    (pterm3[35] => pexpout) = (0, 0) ;
    (pterm3[36] => pexpout) = (0, 0) ;
    (pterm3[37] => pexpout) = (0, 0) ;
    (pterm3[38] => pexpout) = (0, 0) ;
    (pterm3[39] => pexpout) = (0, 0) ;
    (pterm3[40] => pexpout) = (0, 0) ;
    (pterm3[41] => pexpout) = (0, 0) ;
    (pterm3[42] => pexpout) = (0, 0) ;
    (pterm3[43] => pexpout) = (0, 0) ;
    (pterm3[44] => pexpout) = (0, 0) ;
    (pterm3[45] => pexpout) = (0, 0) ;
    (pterm3[46] => pexpout) = (0, 0) ;
    (pterm3[47] => pexpout) = (0, 0) ;
    (pterm3[48] => pexpout) = (0, 0) ;
    (pterm3[49] => pexpout) = (0, 0) ;
    (pterm3[50] => pexpout) = (0, 0) ;
    (pterm3[51] => pexpout) = (0, 0) ;

    (pterm4[0] => pexpout) = (0, 0) ;
    (pterm4[1] => pexpout) = (0, 0) ;
    (pterm4[2] => pexpout) = (0, 0) ;
    (pterm4[3] => pexpout) = (0, 0) ;
    (pterm4[4] => pexpout) = (0, 0) ;
    (pterm4[5] => pexpout) = (0, 0) ;
    (pterm4[6] => pexpout) = (0, 0) ;
    (pterm4[7] => pexpout) = (0, 0) ;
    (pterm4[8] => pexpout) = (0, 0) ;
    (pterm4[9] => pexpout) = (0, 0) ;
    (pterm4[10] => pexpout) = (0, 0) ;
    (pterm4[11] => pexpout) = (0, 0) ;
    (pterm4[12] => pexpout) = (0, 0) ;
    (pterm4[13] => pexpout) = (0, 0) ;
    (pterm4[14] => pexpout) = (0, 0) ;
    (pterm4[15] => pexpout) = (0, 0) ;
    (pterm4[16] => pexpout) = (0, 0) ;
    (pterm4[17] => pexpout) = (0, 0) ;
    (pterm4[18] => pexpout) = (0, 0) ;
    (pterm4[19] => pexpout) = (0, 0) ;
    (pterm4[20] => pexpout) = (0, 0) ;
    (pterm4[21] => pexpout) = (0, 0) ;
    (pterm4[22] => pexpout) = (0, 0) ;
    (pterm4[23] => pexpout) = (0, 0) ;
    (pterm4[24] => pexpout) = (0, 0) ;
    (pterm4[25] => pexpout) = (0, 0) ;
    (pterm4[26] => pexpout) = (0, 0) ;
    (pterm4[27] => pexpout) = (0, 0) ;
    (pterm4[28] => pexpout) = (0, 0) ;
    (pterm4[29] => pexpout) = (0, 0) ;
    (pterm4[30] => pexpout) = (0, 0) ;
    (pterm4[31] => pexpout) = (0, 0) ;
    (pterm4[32] => pexpout) = (0, 0) ;
    (pterm4[33] => pexpout) = (0, 0) ;
    (pterm4[34] => pexpout) = (0, 0) ;
    (pterm4[35] => pexpout) = (0, 0) ;
    (pterm4[36] => pexpout) = (0, 0) ;
    (pterm4[37] => pexpout) = (0, 0) ;
    (pterm4[38] => pexpout) = (0, 0) ;
    (pterm4[39] => pexpout) = (0, 0) ;
    (pterm4[40] => pexpout) = (0, 0) ;
    (pterm4[41] => pexpout) = (0, 0) ;
    (pterm4[42] => pexpout) = (0, 0) ;
    (pterm4[43] => pexpout) = (0, 0) ;
    (pterm4[44] => pexpout) = (0, 0) ;
    (pterm4[45] => pexpout) = (0, 0) ;
    (pterm4[46] => pexpout) = (0, 0) ;
    (pterm4[47] => pexpout) = (0, 0) ;
    (pterm4[48] => pexpout) = (0, 0) ;
    (pterm4[49] => pexpout) = (0, 0) ;
    (pterm4[50] => pexpout) = (0, 0) ;
    (pterm4[51] => pexpout) = (0, 0) ;

    (pterm5[0] => pexpout) = (0, 0) ;
    (pterm5[1] => pexpout) = (0, 0) ;
    (pterm5[2] => pexpout) = (0, 0) ;
    (pterm5[3] => pexpout) = (0, 0) ;
    (pterm5[4] => pexpout) = (0, 0) ;
    (pterm5[5] => pexpout) = (0, 0) ;
    (pterm5[6] => pexpout) = (0, 0) ;
    (pterm5[7] => pexpout) = (0, 0) ;
    (pterm5[8] => pexpout) = (0, 0) ;
    (pterm5[9] => pexpout) = (0, 0) ;
    (pterm5[10] => pexpout) = (0, 0) ;
    (pterm5[11] => pexpout) = (0, 0) ;
    (pterm5[12] => pexpout) = (0, 0) ;
    (pterm5[13] => pexpout) = (0, 0) ;
    (pterm5[14] => pexpout) = (0, 0) ;
    (pterm5[15] => pexpout) = (0, 0) ;
    (pterm5[16] => pexpout) = (0, 0) ;
    (pterm5[17] => pexpout) = (0, 0) ;
    (pterm5[18] => pexpout) = (0, 0) ;
    (pterm5[19] => pexpout) = (0, 0) ;
    (pterm5[20] => pexpout) = (0, 0) ;
    (pterm5[21] => pexpout) = (0, 0) ;
    (pterm5[22] => pexpout) = (0, 0) ;
    (pterm5[23] => pexpout) = (0, 0) ;
    (pterm5[24] => pexpout) = (0, 0) ;
    (pterm5[25] => pexpout) = (0, 0) ;
    (pterm5[26] => pexpout) = (0, 0) ;
    (pterm5[27] => pexpout) = (0, 0) ;
    (pterm5[28] => pexpout) = (0, 0) ;
    (pterm5[29] => pexpout) = (0, 0) ;
    (pterm5[30] => pexpout) = (0, 0) ;
    (pterm5[31] => pexpout) = (0, 0) ;
    (pterm5[32] => pexpout) = (0, 0) ;
    (pterm5[33] => pexpout) = (0, 0) ;
    (pterm5[34] => pexpout) = (0, 0) ;
    (pterm5[35] => pexpout) = (0, 0) ;
    (pterm5[36] => pexpout) = (0, 0) ;
    (pterm5[37] => pexpout) = (0, 0) ;
    (pterm5[38] => pexpout) = (0, 0) ;
    (pterm5[39] => pexpout) = (0, 0) ;
    (pterm5[40] => pexpout) = (0, 0) ;
    (pterm5[41] => pexpout) = (0, 0) ;
    (pterm5[42] => pexpout) = (0, 0) ;
    (pterm5[43] => pexpout) = (0, 0) ;
    (pterm5[44] => pexpout) = (0, 0) ;
    (pterm5[45] => pexpout) = (0, 0) ;
    (pterm5[46] => pexpout) = (0, 0) ;
    (pterm5[47] => pexpout) = (0, 0) ;
    (pterm5[48] => pexpout) = (0, 0) ;
    (pterm5[49] => pexpout) = (0, 0) ;
    (pterm5[50] => pexpout) = (0, 0) ;
    (pterm5[51] => pexpout) = (0, 0) ;

    (pexpin => pexpout) = (0, 0) ;

    (pterm0[0] => regin) = (0, 0) ;
    (pterm0[1] => regin) = (0, 0) ;
    (pterm0[2] => regin) = (0, 0) ;
    (pterm0[3] => regin) = (0, 0) ;
    (pterm0[4] => regin) = (0, 0) ;
    (pterm0[5] => regin) = (0, 0) ;
    (pterm0[6] => regin) = (0, 0) ;
    (pterm0[7] => regin) = (0, 0) ;
    (pterm0[8] => regin) = (0, 0) ;
    (pterm0[9] => regin) = (0, 0) ;
    (pterm0[10] => regin) = (0, 0) ;
    (pterm0[11] => regin) = (0, 0) ;
    (pterm0[12] => regin) = (0, 0) ;
    (pterm0[13] => regin) = (0, 0) ;
    (pterm0[14] => regin) = (0, 0) ;
    (pterm0[15] => regin) = (0, 0) ;
    (pterm0[16] => regin) = (0, 0) ;
    (pterm0[17] => regin) = (0, 0) ;
    (pterm0[18] => regin) = (0, 0) ;
    (pterm0[19] => regin) = (0, 0) ;
    (pterm0[20] => regin) = (0, 0) ;
    (pterm0[21] => regin) = (0, 0) ;
    (pterm0[22] => regin) = (0, 0) ;
    (pterm0[23] => regin) = (0, 0) ;
    (pterm0[24] => regin) = (0, 0) ;
    (pterm0[25] => regin) = (0, 0) ;
    (pterm0[26] => regin) = (0, 0) ;
    (pterm0[27] => regin) = (0, 0) ;
    (pterm0[28] => regin) = (0, 0) ;
    (pterm0[29] => regin) = (0, 0) ;
    (pterm0[30] => regin) = (0, 0) ;
    (pterm0[31] => regin) = (0, 0) ;
    (pterm0[32] => regin) = (0, 0) ;
    (pterm0[33] => regin) = (0, 0) ;
    (pterm0[34] => regin) = (0, 0) ;
    (pterm0[35] => regin) = (0, 0) ;
    (pterm0[36] => regin) = (0, 0) ;
    (pterm0[37] => regin) = (0, 0) ;
    (pterm0[38] => regin) = (0, 0) ;
    (pterm0[39] => regin) = (0, 0) ;
    (pterm0[40] => regin) = (0, 0) ;
    (pterm0[41] => regin) = (0, 0) ;
    (pterm0[42] => regin) = (0, 0) ;
    (pterm0[43] => regin) = (0, 0) ;
    (pterm0[44] => regin) = (0, 0) ;
    (pterm0[45] => regin) = (0, 0) ;
    (pterm0[46] => regin) = (0, 0) ;
    (pterm0[47] => regin) = (0, 0) ;
    (pterm0[48] => regin) = (0, 0) ;
    (pterm0[49] => regin) = (0, 0) ;
    (pterm0[50] => regin) = (0, 0) ;
    (pterm0[51] => regin) = (0, 0) ;

    (pterm1[0] => regin) = (0, 0) ;
    (pterm1[1] => regin) = (0, 0) ;
    (pterm1[2] => regin) = (0, 0) ;
    (pterm1[3] => regin) = (0, 0) ;
    (pterm1[4] => regin) = (0, 0) ;
    (pterm1[5] => regin) = (0, 0) ;
    (pterm1[6] => regin) = (0, 0) ;
    (pterm1[7] => regin) = (0, 0) ;
    (pterm1[8] => regin) = (0, 0) ;
    (pterm1[9] => regin) = (0, 0) ;
    (pterm1[10] => regin) = (0, 0) ;
    (pterm1[11] => regin) = (0, 0) ;
    (pterm1[12] => regin) = (0, 0) ;
    (pterm1[13] => regin) = (0, 0) ;
    (pterm1[14] => regin) = (0, 0) ;
    (pterm1[15] => regin) = (0, 0) ;
    (pterm1[16] => regin) = (0, 0) ;
    (pterm1[17] => regin) = (0, 0) ;
    (pterm1[18] => regin) = (0, 0) ;
    (pterm1[19] => regin) = (0, 0) ;
    (pterm1[20] => regin) = (0, 0) ;
    (pterm1[21] => regin) = (0, 0) ;
    (pterm1[22] => regin) = (0, 0) ;
    (pterm1[23] => regin) = (0, 0) ;
    (pterm1[24] => regin) = (0, 0) ;
    (pterm1[25] => regin) = (0, 0) ;
    (pterm1[26] => regin) = (0, 0) ;
    (pterm1[27] => regin) = (0, 0) ;
    (pterm1[28] => regin) = (0, 0) ;
    (pterm1[29] => regin) = (0, 0) ;
    (pterm1[30] => regin) = (0, 0) ;
    (pterm1[31] => regin) = (0, 0) ;
    (pterm1[32] => regin) = (0, 0) ;
    (pterm1[33] => regin) = (0, 0) ;
    (pterm1[34] => regin) = (0, 0) ;
    (pterm1[35] => regin) = (0, 0) ;
    (pterm1[36] => regin) = (0, 0) ;
    (pterm1[37] => regin) = (0, 0) ;
    (pterm1[38] => regin) = (0, 0) ;
    (pterm1[39] => regin) = (0, 0) ;
    (pterm1[40] => regin) = (0, 0) ;
    (pterm1[41] => regin) = (0, 0) ;
    (pterm1[42] => regin) = (0, 0) ;
    (pterm1[43] => regin) = (0, 0) ;
    (pterm1[44] => regin) = (0, 0) ;
    (pterm1[45] => regin) = (0, 0) ;
    (pterm1[46] => regin) = (0, 0) ;
    (pterm1[47] => regin) = (0, 0) ;
    (pterm1[48] => regin) = (0, 0) ;
    (pterm1[49] => regin) = (0, 0) ;
    (pterm1[50] => regin) = (0, 0) ;
    (pterm1[51] => regin) = (0, 0) ;

    (pterm2[0] => regin) = (0, 0) ;
    (pterm2[1] => regin) = (0, 0) ;
    (pterm2[2] => regin) = (0, 0) ;
    (pterm2[3] => regin) = (0, 0) ;
    (pterm2[4] => regin) = (0, 0) ;
    (pterm2[5] => regin) = (0, 0) ;
    (pterm2[6] => regin) = (0, 0) ;
    (pterm2[7] => regin) = (0, 0) ;
    (pterm2[8] => regin) = (0, 0) ;
    (pterm2[9] => regin) = (0, 0) ;
    (pterm2[10] => regin) = (0, 0) ;
    (pterm2[11] => regin) = (0, 0) ;
    (pterm2[12] => regin) = (0, 0) ;
    (pterm2[13] => regin) = (0, 0) ;
    (pterm2[14] => regin) = (0, 0) ;
    (pterm2[15] => regin) = (0, 0) ;
    (pterm2[16] => regin) = (0, 0) ;
    (pterm2[17] => regin) = (0, 0) ;
    (pterm2[18] => regin) = (0, 0) ;
    (pterm2[19] => regin) = (0, 0) ;
    (pterm2[20] => regin) = (0, 0) ;
    (pterm2[21] => regin) = (0, 0) ;
    (pterm2[22] => regin) = (0, 0) ;
    (pterm2[23] => regin) = (0, 0) ;
    (pterm2[24] => regin) = (0, 0) ;
    (pterm2[25] => regin) = (0, 0) ;
    (pterm2[26] => regin) = (0, 0) ;
    (pterm2[27] => regin) = (0, 0) ;
    (pterm2[28] => regin) = (0, 0) ;
    (pterm2[29] => regin) = (0, 0) ;
    (pterm2[30] => regin) = (0, 0) ;
    (pterm2[31] => regin) = (0, 0) ;
    (pterm2[32] => regin) = (0, 0) ;
    (pterm2[33] => regin) = (0, 0) ;
    (pterm2[34] => regin) = (0, 0) ;
    (pterm2[35] => regin) = (0, 0) ;
    (pterm2[36] => regin) = (0, 0) ;
    (pterm2[37] => regin) = (0, 0) ;
    (pterm2[38] => regin) = (0, 0) ;
    (pterm2[39] => regin) = (0, 0) ;
    (pterm2[40] => regin) = (0, 0) ;
    (pterm2[41] => regin) = (0, 0) ;
    (pterm2[42] => regin) = (0, 0) ;
    (pterm2[43] => regin) = (0, 0) ;
    (pterm2[44] => regin) = (0, 0) ;
    (pterm2[45] => regin) = (0, 0) ;
    (pterm2[46] => regin) = (0, 0) ;
    (pterm2[47] => regin) = (0, 0) ;
    (pterm2[48] => regin) = (0, 0) ;
    (pterm2[49] => regin) = (0, 0) ;
    (pterm2[50] => regin) = (0, 0) ;
    (pterm2[51] => regin) = (0, 0) ;

    (pterm3[0] => regin) = (0, 0) ;
    (pterm3[1] => regin) = (0, 0) ;
    (pterm3[2] => regin) = (0, 0) ;
    (pterm3[3] => regin) = (0, 0) ;
    (pterm3[4] => regin) = (0, 0) ;
    (pterm3[5] => regin) = (0, 0) ;
    (pterm3[6] => regin) = (0, 0) ;
    (pterm3[7] => regin) = (0, 0) ;
    (pterm3[8] => regin) = (0, 0) ;
    (pterm3[9] => regin) = (0, 0) ;
    (pterm3[10] => regin) = (0, 0) ;
    (pterm3[11] => regin) = (0, 0) ;
    (pterm3[12] => regin) = (0, 0) ;
    (pterm3[13] => regin) = (0, 0) ;
    (pterm3[14] => regin) = (0, 0) ;
    (pterm3[15] => regin) = (0, 0) ;
    (pterm3[16] => regin) = (0, 0) ;
    (pterm3[17] => regin) = (0, 0) ;
    (pterm3[18] => regin) = (0, 0) ;
    (pterm3[19] => regin) = (0, 0) ;
    (pterm3[20] => regin) = (0, 0) ;
    (pterm3[21] => regin) = (0, 0) ;
    (pterm3[22] => regin) = (0, 0) ;
    (pterm3[23] => regin) = (0, 0) ;
    (pterm3[24] => regin) = (0, 0) ;
    (pterm3[25] => regin) = (0, 0) ;
    (pterm3[26] => regin) = (0, 0) ;
    (pterm3[27] => regin) = (0, 0) ;
    (pterm3[28] => regin) = (0, 0) ;
    (pterm3[29] => regin) = (0, 0) ;
    (pterm3[30] => regin) = (0, 0) ;
    (pterm3[31] => regin) = (0, 0) ;
    (pterm3[32] => regin) = (0, 0) ;
    (pterm3[33] => regin) = (0, 0) ;
    (pterm3[34] => regin) = (0, 0) ;
    (pterm3[35] => regin) = (0, 0) ;
    (pterm3[36] => regin) = (0, 0) ;
    (pterm3[37] => regin) = (0, 0) ;
    (pterm3[38] => regin) = (0, 0) ;
    (pterm3[39] => regin) = (0, 0) ;
    (pterm3[40] => regin) = (0, 0) ;
    (pterm3[41] => regin) = (0, 0) ;
    (pterm3[42] => regin) = (0, 0) ;
    (pterm3[43] => regin) = (0, 0) ;
    (pterm3[44] => regin) = (0, 0) ;
    (pterm3[45] => regin) = (0, 0) ;
    (pterm3[46] => regin) = (0, 0) ;
    (pterm3[47] => regin) = (0, 0) ;
    (pterm3[48] => regin) = (0, 0) ;
    (pterm3[49] => regin) = (0, 0) ;
    (pterm3[50] => regin) = (0, 0) ;
    (pterm3[51] => regin) = (0, 0) ;

    (pterm4[0] => regin) = (0, 0) ;
    (pterm4[1] => regin) = (0, 0) ;
    (pterm4[2] => regin) = (0, 0) ;
    (pterm4[3] => regin) = (0, 0) ;
    (pterm4[4] => regin) = (0, 0) ;
    (pterm4[5] => regin) = (0, 0) ;
    (pterm4[6] => regin) = (0, 0) ;
    (pterm4[7] => regin) = (0, 0) ;
    (pterm4[8] => regin) = (0, 0) ;
    (pterm4[9] => regin) = (0, 0) ;
    (pterm4[10] => regin) = (0, 0) ;
    (pterm4[11] => regin) = (0, 0) ;
    (pterm4[12] => regin) = (0, 0) ;
    (pterm4[13] => regin) = (0, 0) ;
    (pterm4[14] => regin) = (0, 0) ;
    (pterm4[15] => regin) = (0, 0) ;
    (pterm4[16] => regin) = (0, 0) ;
    (pterm4[17] => regin) = (0, 0) ;
    (pterm4[18] => regin) = (0, 0) ;
    (pterm4[19] => regin) = (0, 0) ;
    (pterm4[20] => regin) = (0, 0) ;
    (pterm4[21] => regin) = (0, 0) ;
    (pterm4[22] => regin) = (0, 0) ;
    (pterm4[23] => regin) = (0, 0) ;
    (pterm4[24] => regin) = (0, 0) ;
    (pterm4[25] => regin) = (0, 0) ;
    (pterm4[26] => regin) = (0, 0) ;
    (pterm4[27] => regin) = (0, 0) ;
    (pterm4[28] => regin) = (0, 0) ;
    (pterm4[29] => regin) = (0, 0) ;
    (pterm4[30] => regin) = (0, 0) ;
    (pterm4[31] => regin) = (0, 0) ;
    (pterm4[32] => regin) = (0, 0) ;
    (pterm4[33] => regin) = (0, 0) ;
    (pterm4[34] => regin) = (0, 0) ;
    (pterm4[35] => regin) = (0, 0) ;
    (pterm4[36] => regin) = (0, 0) ;
    (pterm4[37] => regin) = (0, 0) ;
    (pterm4[38] => regin) = (0, 0) ;
    (pterm4[39] => regin) = (0, 0) ;
    (pterm4[40] => regin) = (0, 0) ;
    (pterm4[41] => regin) = (0, 0) ;
    (pterm4[42] => regin) = (0, 0) ;
    (pterm4[43] => regin) = (0, 0) ;
    (pterm4[44] => regin) = (0, 0) ;
    (pterm4[45] => regin) = (0, 0) ;
    (pterm4[46] => regin) = (0, 0) ;
    (pterm4[47] => regin) = (0, 0) ;
    (pterm4[48] => regin) = (0, 0) ;
    (pterm4[49] => regin) = (0, 0) ;
    (pterm4[50] => regin) = (0, 0) ;
    (pterm4[51] => regin) = (0, 0) ;

    (pterm5[0] => regin) = (0, 0) ;
    (pterm5[1] => regin) = (0, 0) ;
    (pterm5[2] => regin) = (0, 0) ;
    (pterm5[3] => regin) = (0, 0) ;
    (pterm5[4] => regin) = (0, 0) ;
    (pterm5[5] => regin) = (0, 0) ;
    (pterm5[6] => regin) = (0, 0) ;
    (pterm5[7] => regin) = (0, 0) ;
    (pterm5[8] => regin) = (0, 0) ;
    (pterm5[9] => regin) = (0, 0) ;
    (pterm5[10] => regin) = (0, 0) ;
    (pterm5[11] => regin) = (0, 0) ;
    (pterm5[12] => regin) = (0, 0) ;
    (pterm5[13] => regin) = (0, 0) ;
    (pterm5[14] => regin) = (0, 0) ;
    (pterm5[15] => regin) = (0, 0) ;
    (pterm5[16] => regin) = (0, 0) ;
    (pterm5[17] => regin) = (0, 0) ;
    (pterm5[18] => regin) = (0, 0) ;
    (pterm5[19] => regin) = (0, 0) ;
    (pterm5[20] => regin) = (0, 0) ;
    (pterm5[21] => regin) = (0, 0) ;
    (pterm5[22] => regin) = (0, 0) ;
    (pterm5[23] => regin) = (0, 0) ;
    (pterm5[24] => regin) = (0, 0) ;
    (pterm5[25] => regin) = (0, 0) ;
    (pterm5[26] => regin) = (0, 0) ;
    (pterm5[27] => regin) = (0, 0) ;
    (pterm5[28] => regin) = (0, 0) ;
    (pterm5[29] => regin) = (0, 0) ;
    (pterm5[30] => regin) = (0, 0) ;
    (pterm5[31] => regin) = (0, 0) ;
    (pterm5[32] => regin) = (0, 0) ;
    (pterm5[33] => regin) = (0, 0) ;
    (pterm5[34] => regin) = (0, 0) ;
    (pterm5[35] => regin) = (0, 0) ;
    (pterm5[36] => regin) = (0, 0) ;
    (pterm5[37] => regin) = (0, 0) ;
    (pterm5[38] => regin) = (0, 0) ;
    (pterm5[39] => regin) = (0, 0) ;
    (pterm5[40] => regin) = (0, 0) ;
    (pterm5[41] => regin) = (0, 0) ;
    (pterm5[42] => regin) = (0, 0) ;
    (pterm5[43] => regin) = (0, 0) ;
    (pterm5[44] => regin) = (0, 0) ;
    (pterm5[45] => regin) = (0, 0) ;
    (pterm5[46] => regin) = (0, 0) ;
    (pterm5[47] => regin) = (0, 0) ;
    (pterm5[48] => regin) = (0, 0) ;
    (pterm5[49] => regin) = (0, 0) ;
    (pterm5[50] => regin) = (0, 0) ;
    (pterm5[51] => regin) = (0, 0) ;

    (pxor[0] => regin) = (0, 0) ;
    (pxor[1] => regin) = (0, 0) ;
    (pxor[2] => regin) = (0, 0) ;
    (pxor[3] => regin) = (0, 0) ;
    (pxor[4] => regin) = (0, 0) ;
    (pxor[5] => regin) = (0, 0) ;
    (pxor[6] => regin) = (0, 0) ;
    (pxor[7] => regin) = (0, 0) ;
    (pxor[8] => regin) = (0, 0) ;
    (pxor[9] => regin) = (0, 0) ;
    (pxor[10] => regin) = (0, 0) ;
    (pxor[11] => regin) = (0, 0) ;
    (pxor[12] => regin) = (0, 0) ;
    (pxor[13] => regin) = (0, 0) ;
    (pxor[14] => regin) = (0, 0) ;
    (pxor[15] => regin) = (0, 0) ;
    (pxor[16] => regin) = (0, 0) ;
    (pxor[17] => regin) = (0, 0) ;
    (pxor[18] => regin) = (0, 0) ;
    (pxor[19] => regin) = (0, 0) ;
    (pxor[20] => regin) = (0, 0) ;
    (pxor[21] => regin) = (0, 0) ;
    (pxor[22] => regin) = (0, 0) ;
    (pxor[23] => regin) = (0, 0) ;
    (pxor[24] => regin) = (0, 0) ;
    (pxor[25] => regin) = (0, 0) ;
    (pxor[26] => regin) = (0, 0) ;
    (pxor[27] => regin) = (0, 0) ;
    (pxor[28] => regin) = (0, 0) ;
    (pxor[29] => regin) = (0, 0) ;
    (pxor[30] => regin) = (0, 0) ;
    (pxor[31] => regin) = (0, 0) ;
    (pxor[32] => regin) = (0, 0) ;
    (pxor[33] => regin) = (0, 0) ;
    (pxor[34] => regin) = (0, 0) ;
    (pxor[35] => regin) = (0, 0) ;
    (pxor[36] => regin) = (0, 0) ;
    (pxor[37] => regin) = (0, 0) ;
    (pxor[38] => regin) = (0, 0) ;
    (pxor[39] => regin) = (0, 0) ;
    (pxor[40] => regin) = (0, 0) ;
    (pxor[41] => regin) = (0, 0) ;
    (pxor[42] => regin) = (0, 0) ;
    (pxor[43] => regin) = (0, 0) ;
    (pxor[44] => regin) = (0, 0) ;
    (pxor[45] => regin) = (0, 0) ;
    (pxor[46] => regin) = (0, 0) ;
    (pxor[47] => regin) = (0, 0) ;
    (pxor[48] => regin) = (0, 0) ;
    (pxor[49] => regin) = (0, 0) ;
    (pxor[50] => regin) = (0, 0) ;
    (pxor[51] => regin) = (0, 0) ;

    (pexpin => regin)  = (0, 0) ;
    (fpin => regin)    = (0, 0);
    (fbkin => regin)   = (0, 0) ;
    (fbkin => pexpout) = (0, 0) ;
    (fbkin => combout) = (0, 0) ;

    endspecify

always @ (ipterm0 or ipterm1 or ipterm2 or ipterm3 
	  or ipterm4 or ipterm5 or ipxor or ipexpin or fbkin or ifpin) 
begin
   if (ifpin !== 'b0)
     tmp_fpin = 'b1;
   else
     tmp_fpin = 'b0;
   if (ipexpin !== 'b1)
     tmp_pexpin = 'b0;
   else
     tmp_pexpin = 'b1;
   if (&ipterm0 !== 'b1)
     tmp_pterm0 = 'b0;
   else
     tmp_pterm0 = 'b1; 
   if (&ipterm1 !== 'b1)
     tmp_pterm1 = 'b0;
   else
     tmp_pterm1 = 'b1;
   if (&ipterm2 !== 'b1)
     tmp_pterm2 = 'b0;
   else
     tmp_pterm2 = 'b1;
   if (&ipterm3 !== 'b1)
     tmp_pterm3 = 'b0;
   else
     tmp_pterm3 = 'b1;
   if (&ipterm4 !== 'b1)
     tmp_pterm4 = 'b0;
   else
     tmp_pterm4 = 'b1;
   if (pexp_mode == "off")
     begin
	if (operation_mode == "normal")
	  begin
	     if (register_mode == "tff")
	       icomb = ((tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			 | tmp_pterm4) | tmp_pexpin) ^ fbkin;
	     else
	       icomb = tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			| tmp_pterm4 | tmp_pexpin;
	  end
	else if (operation_mode == "invert")
	  begin
	     if (register_mode == "tff")
	       icomb = ((tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			 | tmp_pterm4 | tmp_pexpin) ^ (~fbkin));
	     else
	       icomb = (tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			| tmp_pterm4 | tmp_pexpin) ^ 'b1;
	  end
	else if (operation_mode == "xor")
	  icomb = (tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
		   | tmp_pterm4 | tmp_pexpin) ^ &ipxor;
	else if (operation_mode == "vcc")
	  begin
	     if (register_mode == "tff")
	       icomb = 1'b1 ^ fbkin;
	     else
	       icomb = tmp_fpin;
	  end
	else
	  icomb = 'bz;
     end
   else	//pexp_mode = on
     begin
	if (operation_mode == "normal")
	  begin
	     if (register_mode == "tff")
	       icomb = &ipterm5 ^ fbkin;
	     else
	       icomb = &ipterm5;
	     ipexpout = tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			 | tmp_pterm4 | tmp_pexpin;
	  end
	else if (operation_mode == "invert")
	  begin
	     if (register_mode == "tff")
	       icomb = &ipterm5 ^ (~fbkin);
	     else
	       icomb = &ipterm5 ^ 'b1;
	     ipexpout = tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			 | tmp_pterm4 | tmp_pexpin;
	  end
	else if (operation_mode == "xor")
	  begin
	     ipexpout = (tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			 | tmp_pterm4 | tmp_pexpin);
	     icomb = &ipterm5 ^ &ipxor;
	  end
	else if (operation_mode == "vcc")
	  begin
	     if (register_mode == "tff")
	       icomb = 1'b1 ^ fbkin;
	     else
	       icomb = tmp_fpin;
	     ipexpout = tmp_pterm0 | tmp_pterm1 | tmp_pterm2 | tmp_pterm3 
			 | tmp_pterm4 | tmp_pexpin;
	  end
	else
	  begin
	     icomb = 'bz;
	     ipexpout = 'bz;
	  end
     end		
end 


and (pexpout, ipexpout, 'b1);
and (combout, icomb, 'b1);
and (regin, icomb, 'b1);

endmodule

//   MAX MCELL REG

`timescale 1 ps/1 ps
module  max_mcell_register (datain, clk, aclr, pclk, pena, paclr, 
			    papre, regout, fbkout);
	parameter operation_mode = "normal";    
	parameter power_up    = "low";
	parameter register_mode = "dff";

    input  datain, clk, aclr;
	input  [51:0] pclk, pena, paclr, papre;
    output regout, fbkout;

    reg  iregout, oldclk1, oldclk2;
    reg  pena_viol, clk_per_viol, datain_viol, pclk_per_viol;
	reg  pterm_aclr, pterm_preset, ptermclk, penable;
    wire reset;
	wire [51:0] ipclk, ipena, ipaclr, ipapre;

    reg violation;

    wire clk_in;
    wire iclr;

    buf (clk_in, clk);
    buf (iclr, aclr);

    buf (ipclk[0], pclk[0]);
    buf (ipclk[1], pclk[1]);
    buf (ipclk[2], pclk[2]);
    buf (ipclk[3], pclk[3]);
    buf (ipclk[4], pclk[4]);
    buf (ipclk[5], pclk[5]);
    buf (ipclk[6], pclk[6]);
    buf (ipclk[7], pclk[7]);
    buf (ipclk[8], pclk[8]);
    buf (ipclk[9], pclk[9]);
    buf (ipclk[10], pclk[10]);
    buf (ipclk[11], pclk[11]);
    buf (ipclk[12], pclk[12]);
    buf (ipclk[13], pclk[13]);
    buf (ipclk[14], pclk[14]);
    buf (ipclk[15], pclk[15]);
    buf (ipclk[16], pclk[16]);
    buf (ipclk[17], pclk[17]);
    buf (ipclk[18], pclk[18]);
    buf (ipclk[19], pclk[19]);
    buf (ipclk[20], pclk[20]);
    buf (ipclk[21], pclk[21]);
    buf (ipclk[22], pclk[22]);
    buf (ipclk[23], pclk[23]);
    buf (ipclk[24], pclk[24]);
    buf (ipclk[25], pclk[25]);
    buf (ipclk[26], pclk[26]);
    buf (ipclk[27], pclk[27]);
    buf (ipclk[28], pclk[28]);
    buf (ipclk[29], pclk[29]);
    buf (ipclk[30], pclk[30]);
    buf (ipclk[31], pclk[31]);
    buf (ipclk[32], pclk[32]);
    buf (ipclk[33], pclk[33]);
    buf (ipclk[34], pclk[34]);
    buf (ipclk[35], pclk[35]);
    buf (ipclk[36], pclk[36]);
    buf (ipclk[37], pclk[37]);
    buf (ipclk[38], pclk[38]);
    buf (ipclk[39], pclk[39]);
    buf (ipclk[40], pclk[40]);
    buf (ipclk[41], pclk[41]);
    buf (ipclk[42], pclk[42]);
    buf (ipclk[43], pclk[43]);
    buf (ipclk[44], pclk[44]);
    buf (ipclk[45], pclk[45]);
    buf (ipclk[46], pclk[46]);
    buf (ipclk[47], pclk[47]);
    buf (ipclk[48], pclk[48]);
    buf (ipclk[49], pclk[49]);
    buf (ipclk[50], pclk[50]);
    buf (ipclk[51], pclk[51]);

    buf (ipena[0], pena[0]);
    buf (ipena[1], pena[1]);
    buf (ipena[2], pena[2]);
    buf (ipena[3], pena[3]);
    buf (ipena[4], pena[4]);
    buf (ipena[5], pena[5]);
    buf (ipena[6], pena[6]);
    buf (ipena[7], pena[7]);
    buf (ipena[8], pena[8]);
    buf (ipena[9], pena[9]);
    buf (ipena[10], pena[10]);
    buf (ipena[11], pena[11]);
    buf (ipena[12], pena[12]);
    buf (ipena[13], pena[13]);
    buf (ipena[14], pena[14]);
    buf (ipena[15], pena[15]);
    buf (ipena[16], pena[16]);
    buf (ipena[17], pena[17]);
    buf (ipena[18], pena[18]);
    buf (ipena[19], pena[19]);
    buf (ipena[20], pena[20]);
    buf (ipena[21], pena[21]);
    buf (ipena[22], pena[22]);
    buf (ipena[23], pena[23]);
    buf (ipena[24], pena[24]);
    buf (ipena[25], pena[25]);
    buf (ipena[26], pena[26]);
    buf (ipena[27], pena[27]);
    buf (ipena[28], pena[28]);
    buf (ipena[29], pena[29]);
    buf (ipena[30], pena[30]);
    buf (ipena[31], pena[31]);
    buf (ipena[32], pena[32]);
    buf (ipena[33], pena[33]);
    buf (ipena[34], pena[34]);
    buf (ipena[35], pena[35]);
    buf (ipena[36], pena[36]);
    buf (ipena[37], pena[37]);
    buf (ipena[38], pena[38]);
    buf (ipena[39], pena[39]);
    buf (ipena[40], pena[40]);
    buf (ipena[41], pena[41]);
    buf (ipena[42], pena[42]);
    buf (ipena[43], pena[43]);
    buf (ipena[44], pena[44]);
    buf (ipena[45], pena[45]);
    buf (ipena[46], pena[46]);
    buf (ipena[47], pena[47]);
    buf (ipena[48], pena[48]);
    buf (ipena[49], pena[49]);
    buf (ipena[50], pena[50]);
    buf (ipena[51], pena[51]);

    buf (ipaclr[0], paclr[0]);
    buf (ipaclr[1], paclr[1]);
    buf (ipaclr[2], paclr[2]);
    buf (ipaclr[3], paclr[3]);
    buf (ipaclr[4], paclr[4]);
    buf (ipaclr[5], paclr[5]);
    buf (ipaclr[6], paclr[6]);
    buf (ipaclr[7], paclr[7]);
    buf (ipaclr[8], paclr[8]);
    buf (ipaclr[9], paclr[9]);
    buf (ipaclr[10], paclr[10]);
    buf (ipaclr[11], paclr[11]);
    buf (ipaclr[12], paclr[12]);
    buf (ipaclr[13], paclr[13]);
    buf (ipaclr[14], paclr[14]);
    buf (ipaclr[15], paclr[15]);
    buf (ipaclr[16], paclr[16]);
    buf (ipaclr[17], paclr[17]);
    buf (ipaclr[18], paclr[18]);
    buf (ipaclr[19], paclr[19]);
    buf (ipaclr[20], paclr[20]);
    buf (ipaclr[21], paclr[21]);
    buf (ipaclr[22], paclr[22]);
    buf (ipaclr[23], paclr[23]);
    buf (ipaclr[24], paclr[24]);
    buf (ipaclr[25], paclr[25]);
    buf (ipaclr[26], paclr[26]);
    buf (ipaclr[27], paclr[27]);
    buf (ipaclr[28], paclr[28]);
    buf (ipaclr[29], paclr[29]);
    buf (ipaclr[30], paclr[30]);
    buf (ipaclr[31], paclr[31]);
    buf (ipaclr[32], paclr[32]);
    buf (ipaclr[33], paclr[33]);
    buf (ipaclr[34], paclr[34]);
    buf (ipaclr[35], paclr[35]);
    buf (ipaclr[36], paclr[36]);
    buf (ipaclr[37], paclr[37]);
    buf (ipaclr[38], paclr[38]);
    buf (ipaclr[39], paclr[39]);
    buf (ipaclr[40], paclr[40]);
    buf (ipaclr[41], paclr[41]);
    buf (ipaclr[42], paclr[42]);
    buf (ipaclr[43], paclr[43]);
    buf (ipaclr[44], paclr[44]);
    buf (ipaclr[45], paclr[45]);
    buf (ipaclr[46], paclr[46]);
    buf (ipaclr[47], paclr[47]);
    buf (ipaclr[48], paclr[48]);
    buf (ipaclr[49], paclr[49]);
    buf (ipaclr[50], paclr[50]);
    buf (ipaclr[51], paclr[51]);

    buf (ipapre[0], papre[0]);
    buf (ipapre[1], papre[1]);
    buf (ipapre[2], papre[2]);
    buf (ipapre[3], papre[3]);
    buf (ipapre[4], papre[4]);
    buf (ipapre[5], papre[5]);
    buf (ipapre[6], papre[6]);
    buf (ipapre[7], papre[7]);
    buf (ipapre[8], papre[8]);
    buf (ipapre[9], papre[9]);
    buf (ipapre[10], papre[10]);
    buf (ipapre[11], papre[11]);
    buf (ipapre[12], papre[12]);
    buf (ipapre[13], papre[13]);
    buf (ipapre[14], papre[14]);
    buf (ipapre[15], papre[15]);
    buf (ipapre[16], papre[16]);
    buf (ipapre[17], papre[17]);
    buf (ipapre[18], papre[18]);
    buf (ipapre[19], papre[19]);
    buf (ipapre[20], papre[20]);
    buf (ipapre[21], papre[21]);
    buf (ipapre[22], papre[22]);
    buf (ipapre[23], papre[23]);
    buf (ipapre[24], papre[24]);
    buf (ipapre[25], papre[25]);
    buf (ipapre[26], papre[26]);
    buf (ipapre[27], papre[27]);
    buf (ipapre[28], papre[28]);
    buf (ipapre[29], papre[29]);
    buf (ipapre[30], papre[30]);
    buf (ipapre[31], papre[31]);
    buf (ipapre[32], papre[32]);
    buf (ipapre[33], papre[33]);
    buf (ipapre[34], papre[34]);
    buf (ipapre[35], papre[35]);
    buf (ipapre[36], papre[36]);
    buf (ipapre[37], papre[37]);
    buf (ipapre[38], papre[38]);
    buf (ipapre[39], papre[39]);
    buf (ipapre[40], papre[40]);
    buf (ipapre[41], papre[41]);
    buf (ipapre[42], papre[42]);
    buf (ipapre[43], papre[43]);
    buf (ipapre[44], papre[44]);
    buf (ipapre[45], papre[45]);
    buf (ipapre[46], papre[46]);
    buf (ipapre[47], papre[47]);
    buf (ipapre[48], papre[48]);
    buf (ipapre[49], papre[49]);
    buf (ipapre[50], papre[50]);
    buf (ipapre[51], papre[51]);

    assign reset = (!iclr) && (&ipena);

    specify

    $period (posedge clk &&& reset, 0, clk_per_viol);	

	$setuphold (posedge clk &&& reset, datain, 0, 0, datain_viol) ;

	$setuphold (posedge clk &&& reset, pena[0], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[1], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[2], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[3], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[4], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[5], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[6], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[7], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[8], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[9], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[10], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[11], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[12], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[13], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[14], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[15], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[16], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[17], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[18], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[19], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[20], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[21], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[22], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[23], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[24], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[25], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[26], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[27], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[28], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[29], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[30], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[31], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[32], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[33], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[34], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[35], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[36], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[37], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[38], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[39], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[40], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[41], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[42], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[43], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[44], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[45], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[46], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[47], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[48], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[49], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[50], 0, 0, pena_viol) ;
	$setuphold (posedge clk &&& reset, pena[51], 0, 0, pena_viol) ;
	
	$setuphold (posedge pclk[0] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[1] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[2] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[3] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[4] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[5] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[6] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[7] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[8] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[9] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[10] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[11] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[12] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[13] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[14] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[15] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[16] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[17] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[18] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[19] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[20] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[21] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[22] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[23] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[24] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[25] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[26] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[27] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[28] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[29] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[30] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[31] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[32] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[33] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[34] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[35] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[36] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[37] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[38] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[39] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[40] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[41] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[42] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[43] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[44] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[45] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[46] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[47] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[48] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[49] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[50] &&& reset, datain, 0, 0, datain_viol) ;
	$setuphold (posedge pclk[51] &&& reset, datain, 0, 0, datain_viol) ;

    (posedge clk => (regout +: datain)) = 0 ;

    (posedge pclk[0] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[1] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[2] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[3] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[4] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[5] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[6] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[7] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[8] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[9] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[10] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[11] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[12] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[13] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[14] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[15] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[16] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[17] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[18] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[19] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[20] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[21] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[22] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[23] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[24] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[25] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[26] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[27] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[28] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[29] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[30] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[31] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[32] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[33] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[34] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[35] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[36] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[37] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[38] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[39] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[40] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[41] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[42] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[43] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[44] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[45] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[46] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[47] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[48] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[49] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[50] => (regout +: datain)) =  (0, 0) ;
    (posedge pclk[51] => (regout +: datain)) =  (0, 0) ;

    (posedge aclr => (regout +: 1'b0)) = (0, 0) ;

    (posedge paclr[0] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[1] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[2] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[3] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[4] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[5] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[6] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[7] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[8] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[9] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[10] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[11] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[12] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[13] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[14] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[15] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[16] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[17] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[18] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[19] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[20] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[21] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[22] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[23] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[24] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[25] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[26] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[27] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[28] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[29] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[30] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[31] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[32] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[33] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[34] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[35] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[36] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[37] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[38] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[39] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[40] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[41] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[42] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[43] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[44] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[45] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[46] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[47] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[48] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[49] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[50] => (regout +: 1'b0)) = (0, 0) ;
    (posedge paclr[51] => (regout +: 1'b0)) = (0, 0) ;

    (posedge papre[0] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[1] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[2] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[3] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[4] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[5] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[6] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[7] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[8] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[9] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[10] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[11] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[12] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[13] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[14] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[15] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[16] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[17] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[18] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[19] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[20] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[21] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[22] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[23] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[24] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[25] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[26] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[27] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[28] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[29] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[30] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[31] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[32] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[33] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[34] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[35] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[36] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[37] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[38] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[39] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[40] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[41] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[42] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[43] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[44] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[45] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[46] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[47] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[48] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[49] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[50] => (regout +: 1'b1)) = (0, 0) ;
    (posedge papre[51] => (regout +: 1'b1)) = (0, 0) ;

    (posedge clk => (fbkout +: datain)) = 0 ;

    (posedge pclk[0] => (fbkout +: datain)) = 0 ;
    (posedge pclk[1] => (fbkout +: datain)) = 0 ;
    (posedge pclk[2] => (fbkout +: datain)) = 0 ;
    (posedge pclk[3] => (fbkout +: datain)) = 0 ;
    (posedge pclk[4] => (fbkout +: datain)) = 0 ;
    (posedge pclk[5] => (fbkout +: datain)) = 0 ;
    (posedge pclk[6] => (fbkout +: datain)) = 0 ;
    (posedge pclk[7] => (fbkout +: datain)) = 0 ;
    (posedge pclk[8] => (fbkout +: datain)) = 0 ;
    (posedge pclk[9] => (fbkout +: datain)) = 0 ;
    (posedge pclk[10] => (fbkout +: datain)) = 0 ;
    (posedge pclk[11] => (fbkout +: datain)) = 0 ;
    (posedge pclk[12] => (fbkout +: datain)) = 0 ;
    (posedge pclk[13] => (fbkout +: datain)) = 0 ;
    (posedge pclk[14] => (fbkout +: datain)) = 0 ;
    (posedge pclk[15] => (fbkout +: datain)) = 0 ;
    (posedge pclk[16] => (fbkout +: datain)) = 0 ;
    (posedge pclk[17] => (fbkout +: datain)) = 0 ;
    (posedge pclk[18] => (fbkout +: datain)) = 0 ;
    (posedge pclk[19] => (fbkout +: datain)) = 0 ;
    (posedge pclk[20] => (fbkout +: datain)) = 0 ;
    (posedge pclk[21] => (fbkout +: datain)) = 0 ;
    (posedge pclk[22] => (fbkout +: datain)) = 0 ;
    (posedge pclk[23] => (fbkout +: datain)) = 0 ;
    (posedge pclk[24] => (fbkout +: datain)) = 0 ;
    (posedge pclk[25] => (fbkout +: datain)) = 0 ;
    (posedge pclk[26] => (fbkout +: datain)) = 0 ;
    (posedge pclk[27] => (fbkout +: datain)) = 0 ;
    (posedge pclk[28] => (fbkout +: datain)) = 0 ;
    (posedge pclk[29] => (fbkout +: datain)) = 0 ;
    (posedge pclk[30] => (fbkout +: datain)) = 0 ;
    (posedge pclk[31] => (fbkout +: datain)) = 0 ;
    (posedge pclk[32] => (fbkout +: datain)) = 0 ;
    (posedge pclk[33] => (fbkout +: datain)) = 0 ;
    (posedge pclk[34] => (fbkout +: datain)) = 0 ;
    (posedge pclk[35] => (fbkout +: datain)) = 0 ;
    (posedge pclk[36] => (fbkout +: datain)) = 0 ;
    (posedge pclk[37] => (fbkout +: datain)) = 0 ;
    (posedge pclk[38] => (fbkout +: datain)) = 0 ;
    (posedge pclk[39] => (fbkout +: datain)) = 0 ;
    (posedge pclk[40] => (fbkout +: datain)) = 0 ;
    (posedge pclk[41] => (fbkout +: datain)) = 0 ;
    (posedge pclk[42] => (fbkout +: datain)) = 0 ;
    (posedge pclk[43] => (fbkout +: datain)) = 0 ;
    (posedge pclk[44] => (fbkout +: datain)) = 0 ;
    (posedge pclk[45] => (fbkout +: datain)) = 0 ;
    (posedge pclk[46] => (fbkout +: datain)) = 0 ;
    (posedge pclk[47] => (fbkout +: datain)) = 0 ;
    (posedge pclk[48] => (fbkout +: datain)) = 0 ;
    (posedge pclk[49] => (fbkout +: datain)) = 0 ;
    (posedge pclk[50] => (fbkout +: datain)) = 0 ;
    (posedge pclk[51] => (fbkout +: datain)) = 0 ;
    
    (posedge aclr => (fbkout +: 1'b0)) = (0, 0) ;

    (posedge paclr[0] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[1] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[2] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[3] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[4] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[5] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[6] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[7] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[8] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[9] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[10] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[11] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[12] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[13] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[14] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[15] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[16] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[17] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[18] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[19] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[20] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[21] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[22] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[23] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[24] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[25] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[26] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[27] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[28] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[29] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[30] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[31] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[32] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[33] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[34] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[35] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[36] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[37] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[38] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[39] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[40] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[41] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[42] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[43] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[44] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[45] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[46] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[47] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[48] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[49] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[50] => (fbkout +: 1'b0)) = (0, 0) ;
    (posedge paclr[51] => (fbkout +: 1'b0)) = (0, 0) ;

    (posedge papre[0] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[1] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[2] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[3] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[4] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[5] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[6] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[7] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[8] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[9] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[10] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[11] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[12] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[13] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[14] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[15] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[16] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[17] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[18] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[19] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[20] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[21] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[22] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[23] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[24] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[25] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[26] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[27] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[28] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[29] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[30] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[31] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[32] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[33] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[34] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[35] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[36] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[37] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[38] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[39] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[40] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[41] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[42] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[43] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[44] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[45] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[46] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[47] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[48] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[49] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[50] => (fbkout +: 1'b1)) = (0, 0) ;
    (posedge papre[51] => (fbkout +: 1'b1)) = (0, 0) ;

    endspecify

    initial
    begin
		penable = 'b1;
		pterm_aclr = 'b0;
		pterm_preset = 'b0;
		ptermclk = 'b0;
		oldclk1 = 'b0;
		oldclk2 = 'b0;
		violation = 0;
		if (power_up == "low")
			iregout = 'b0;
		else if (power_up == "high")
			iregout = 'b1;
	end

    always @(datain_viol or clk_per_viol or pclk_per_viol or pena_viol)
    begin
       violation = 1;
    end

always @ (clk_in or iclr or ipaclr or ipapre or ipena or posedge violation 
	  or ipclk)
begin
   if (&ipclk !== 'b1)
     ptermclk = 'b0;
   else
     ptermclk = 'b1;
   if (&ipena == 'b0)
     penable = 'b0;
   else
     penable = 'b1;
   if ((&ipaclr) == 'b1)
     pterm_aclr = 'b1;
   else
     pterm_aclr = 'b0;
   if (&ipapre == 'b1)
     pterm_preset = 'b1;
   else
     pterm_preset = 'b0;
   if ((iclr == 'b1) || (pterm_aclr === 'b1))
     iregout = 'b0;
   else if (pterm_preset == 'b1)
     iregout = 'b1;
   else if (violation == 1'b1)
     begin
	violation = 0;
	iregout = 'bx;
     end
   else if (penable == 'b1)
     begin
	if (((clk_in == 'b1) && (oldclk1 == 'b0)) || ((ptermclk == 'b1) && (oldclk2 == 'b0)))
	  begin
	     iregout = datain;
	  end
     end
   oldclk1 = clk_in;
   oldclk2 = ptermclk;
end       

and (regout, iregout, 'b1);
and (fbkout, iregout, 'b1);

endmodule

//
//   MAX MCELL ATOM
//
`timescale 1 ps/1 ps
module  max_mcell (pterm0, pterm1, pterm2, pterm3, pterm4, pterm5, pxor, 
		   pexpin, clk, aclr, fpin, pclk, pena, paclr, papre, 
		   dataout, pexpout);

   parameter operation_mode	= "normal";
   parameter output_mode 	= "comb";
   parameter register_mode = "dff";
   parameter pexp_mode = "off";
   parameter power_up    = "low";

   input [51:0] pterm0, pterm1, pterm2, pterm3, pterm4, pterm5;
   input [51:0] pxor, pclk, pena, paclr, papre;
   input 	pexpin, clk, aclr, fpin;
   output 	dataout, pexpout;

   wire 	fbk, dffin, combo, dffo;
    

   max_asynch_mcell pcom (pterm0, pterm1, pterm2, pterm3, pterm4, 
			  pterm5, fpin, pxor, pexpin, fbk, combo, 
			  pexpout, dffin);
   max_mcell_register preg (dffin, clk, aclr, pclk, pena, paclr, 
			    papre, dffo, fbk);
   defparam 	
	pcom.operation_mode = operation_mode,
	pcom.pexp_mode = pexp_mode,
	pcom.register_mode = register_mode,
	preg.operation_mode = operation_mode,
	preg.power_up = power_up,
	preg.register_mode = register_mode;

assign dataout = (output_mode == "comb") ? combo : dffo;	

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// MAX SEXP ATOM
//
//////////////////////////////////////////////////////////////////////////////

//   MAX SEXP ASYNCH

`timescale 1 ps/1 ps
module  max_asynch_sexp (datain, dataout);

    input  [51:0] datain;
    output dataout;

    reg tmp_dataout;
    wire [51:0] idatain;
    

    buf (idatain[0], datain[0]);
    buf (idatain[1], datain[1]);
    buf (idatain[2], datain[2]);
    buf (idatain[3], datain[3]);
    buf (idatain[4], datain[4]);
    buf (idatain[5], datain[5]);
    buf (idatain[6], datain[6]);
    buf (idatain[7], datain[7]);
    buf (idatain[8], datain[8]);
    buf (idatain[9], datain[9]);
    buf (idatain[10], datain[10]);
    buf (idatain[11], datain[11]);
    buf (idatain[12], datain[12]);
    buf (idatain[13], datain[13]);
    buf (idatain[14], datain[14]);
    buf (idatain[15], datain[15]);
    buf (idatain[16], datain[16]);
    buf (idatain[17], datain[17]);
    buf (idatain[18], datain[18]);
    buf (idatain[19], datain[19]);
    buf (idatain[20], datain[20]);
    buf (idatain[21], datain[21]);
    buf (idatain[22], datain[22]);
    buf (idatain[23], datain[23]);
    buf (idatain[24], datain[24]);
    buf (idatain[25], datain[25]);
    buf (idatain[26], datain[26]);
    buf (idatain[27], datain[27]);
    buf (idatain[28], datain[28]);
    buf (idatain[29], datain[29]);
    buf (idatain[30], datain[30]);
    buf (idatain[31], datain[31]);
    buf (idatain[32], datain[32]);
    buf (idatain[33], datain[33]);
    buf (idatain[34], datain[34]);
    buf (idatain[35], datain[35]);
    buf (idatain[36], datain[36]);
    buf (idatain[37], datain[37]);
    buf (idatain[38], datain[38]);
    buf (idatain[39], datain[39]);
    buf (idatain[40], datain[40]);
    buf (idatain[41], datain[41]);
    buf (idatain[42], datain[42]);
    buf (idatain[43], datain[43]);
    buf (idatain[44], datain[44]);
    buf (idatain[45], datain[45]);
    buf (idatain[46], datain[46]);
    buf (idatain[47], datain[47]);
    buf (idatain[48], datain[48]);
    buf (idatain[49], datain[49]);
    buf (idatain[50], datain[50]);
    buf (idatain[51], datain[51]);

    specify

    (datain[0] => dataout) = (0, 0) ;
    (datain[1] => dataout) = (0, 0) ;
    (datain[2] => dataout) = (0, 0) ;
    (datain[3] => dataout) = (0, 0) ;
    (datain[4] => dataout) = (0, 0) ;
    (datain[5] => dataout) = (0, 0) ;
    (datain[6] => dataout) = (0, 0) ;
    (datain[7] => dataout) = (0, 0) ;
    (datain[8] => dataout) = (0, 0) ;
    (datain[9] => dataout) = (0, 0) ;
    (datain[10] => dataout) = (0, 0) ;
    (datain[11] => dataout) = (0, 0) ;
    (datain[12] => dataout) = (0, 0) ;
    (datain[13] => dataout) = (0, 0) ;
    (datain[14] => dataout) = (0, 0) ;
    (datain[15] => dataout) = (0, 0) ;
    (datain[16] => dataout) = (0, 0) ;
    (datain[17] => dataout) = (0, 0) ;
    (datain[18] => dataout) = (0, 0) ;
    (datain[19] => dataout) = (0, 0) ;
    (datain[20] => dataout) = (0, 0) ;
    (datain[21] => dataout) = (0, 0) ;
    (datain[22] => dataout) = (0, 0) ;
    (datain[23] => dataout) = (0, 0) ;
    (datain[24] => dataout) = (0, 0) ;
    (datain[25] => dataout) = (0, 0) ;
    (datain[26] => dataout) = (0, 0) ;
    (datain[27] => dataout) = (0, 0) ;
    (datain[28] => dataout) = (0, 0) ;
    (datain[29] => dataout) = (0, 0) ;
    (datain[30] => dataout) = (0, 0) ;
    (datain[31] => dataout) = (0, 0) ;
    (datain[32] => dataout) = (0, 0) ;
    (datain[33] => dataout) = (0, 0) ;
    (datain[34] => dataout) = (0, 0) ;
    (datain[35] => dataout) = (0, 0) ;
    (datain[36] => dataout) = (0, 0) ;
    (datain[37] => dataout) = (0, 0) ;
    (datain[38] => dataout) = (0, 0) ;
    (datain[39] => dataout) = (0, 0) ;
    (datain[40] => dataout) = (0, 0) ;
    (datain[41] => dataout) = (0, 0) ;
    (datain[42] => dataout) = (0, 0) ;
    (datain[43] => dataout) = (0, 0) ;
    (datain[44] => dataout) = (0, 0) ;
    (datain[45] => dataout) = (0, 0) ;
    (datain[46] => dataout) = (0, 0) ;
    (datain[47] => dataout) = (0, 0) ;
    (datain[48] => dataout) = (0, 0) ;
    (datain[49] => dataout) = (0, 0) ;
    (datain[50] => dataout) = (0, 0) ;
    (datain[51] => dataout) = (0, 0) ;

    endspecify

always @ (idatain) 
begin
	tmp_dataout = ~(&idatain);
end 

and (dataout, tmp_dataout, 'b1);

endmodule

//
//   MAX SEXP ATOM
//
`timescale 1 ps/1 ps
module  max_sexp (datain, dataout);

    input  [51:0] datain;
    output dataout;

max_asynch_sexp pcom (datain, dataout);

endmodule
