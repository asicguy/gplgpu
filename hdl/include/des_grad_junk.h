

parameter sub      =  1'b1,
          add      =  1'b0,
          one_fp   = 32'h3f800000,      // Floating point one.
          zero_fp  = 32'h00000000,      // Floating point zero.
          m_one_fp = 32'hbf800000,      // Floating point minus one.
          p9375_fp = 32'h3f700000;      // Floating point 15/16.

wire [31:0] dx10p_fp = s0_s_fp;
wire [31:0] dy10p_fp = s1_s_fp;
wire [31:0] dx20p_fp = s2_s_fp;
wire [31:0] dy20p_fp = s3_s_fp;
wire [31:0] dz10p_fp = s2_s_fp;
wire [31:0] dz20p_fp = s3_s_fp;

wire [31:0] dz10_fp  = hold_0;
wire [31:0] dz20_fp  = hold_1;
wire [31:0] dw10_fp  = hold_2;
wire [31:0] dw20_fp  = hold_3;
wire [31:0] duw10_fp = hold_4;
wire [31:0] duw20_fp  = hold_1;
wire [31:0] dvw10_fp  = hold_2;
wire [31:0] dvw20_fp  = hold_3;
wire [31:0] da10_fp  = hold_0;
wire [31:0] da20_fp  = hold_1;
wire [31:0] dr10_fp  = hold_2;
wire [31:0] dr20_fp  = hold_3;
wire [31:0] dg10_fp  = hold_4;
wire [31:0] dg20_fp = s3_s_fp;
wire [31:0] db10_fp = s3_s_fp;
wire [31:0] db20_fp = s3_s_fp;
wire [31:0] df10_fp  = hold_0;
wire [31:0] df20_fp  = hold_1;
wire [31:0] drs10_fp = hold_2;
wire [31:0] drs20_fp = hold_3;
wire [31:0] dgs10_fp = hold_4;
wire [31:0] dgs20_fp = s3_s_fp;
wire [31:0] dbs10_fp = s3_s_fp;
wire [31:0] dbs20_fp = s3_s_fp;

wire [31:0] det_zx = det_s_fp;
wire [31:0] det_zy = det_s_fp;
wire [31:0] det_wx = det_s_fp;
wire [31:0] det_wy = det_s_fp;
wire [31:0] det_uwx = det_s_fp;
wire [31:0] det_uwy = det_s_fp;
wire [31:0] det_vwx = det_s_fp;
wire [31:0] det_vwy = det_s_fp;
wire [31:0] det_ax = det_s_fp;
wire [31:0] det_ay = det_s_fp;
wire [31:0] det_rx = det_s_fp;
wire [31:0] det_ry = det_s_fp;
wire [31:0] det_gx = det_s_fp;
wire [31:0] det_gy = det_s_fp;
wire [31:0] det_bx = det_s_fp;
wire [31:0] det_by = det_s_fp;
wire [31:0] det_fx = det_s_fp;
wire [31:0] det_fy = det_s_fp;
wire [31:0] det_rsx = det_s_fp;
wire [31:0] det_rsy = det_s_fp;
wire [31:0] det_gsx = det_s_fp;
wire [31:0] det_gsy = det_s_fp;
wire [31:0] det_bsx = det_s_fp;
wire [31:0] det_bsy = det_s_fp;

wire [31:0] sp0yi_fp  = int0_s_fp;
wire [31:0] sp1yi_fp  = int1_s_fp;
wire [31:0] dsp0y_fp  = s0_s_fp;
wire [31:0] dsp1y_fp  = s1_s_fp;

