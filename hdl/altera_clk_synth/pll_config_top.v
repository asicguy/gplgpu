
module pix_pll_rc_top
	(
	input		hb_clk,
	input		hb_rstn,
	input		ref_clk,
	input	  	reconfig,
	input	  	write_param,
	input	[2:0]   counter_param,
	input	[3:0]   counter_type,
	input	[8:0]   data_in,
	input	  	pll_areset_in,

	output	  	busy,
	output	  	pix_clk,
	output	  	pix_locked
	);

	wire	  pll_configupdate;
	wire	  pll_areset;
	wire	  pll_scanclk;
	wire	  reset;
	wire	  pll_scanclkena;
	wire	  pll_scandata;
	// wire	  pll_areset_in;
	wire	  pll_scandataout;
	wire	  pll_scandone;

	// assign pll_areset_in = ~hb_rstn;
	assign reset = ~hb_rstn;

pll_config_intf u_pll_config_intf 
	(
	.clock			(hb_clk),
	.reset			(reset),
	.read_param		(1'b0),
	.counter_param		(counter_param),
	.counter_type		(counter_type),
	.data_in		(data_in),
	.reconfig		(reconfig),
	.write_param		(write_param),
	.pll_areset_in		(pll_areset_in),
	.pll_scandataout	(pll_scandataout),
	.pll_scandone		(pll_scandone),
	// Outputs.
	.busy			(busy),
	.data_out		(),
	.pll_areset		(pll_areset),
	.pll_configupdate	(pll_configupdate),
	.pll_scanclk		(pll_scanclk),
	.pll_scanclkena		(pll_scanclkena),
	.pll_scandata		(pll_scandata)
	);


pll_config_pll u_pll_config_pll 
	(
	.inclk0			(ref_clk),
	.areset			(pll_areset),
	.configupdate		(pll_configupdate),
	// .scanclk		(pll_scanclk),
	.scanclk		(hb_clk),
	.scanclkena		(pll_scanclkena),
	.scandata		(pll_scandata),
	// Outputs.
	.scandataout		(pll_scandataout),
	.scandone		(pll_scandone),
	.c0			(pix_clk),
	.locked			(pix_locked)
	);


endmodule
