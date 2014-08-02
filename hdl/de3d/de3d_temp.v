// Moved from Texture Cache to improve performance.
de3d_tc_addr_in u_de3d_tc_addr_in
	(
	// Inputs.
	.de_clk			(de_clk),
	.push_uv		(push_uv),
	.ul_u			(current_u_g1[19:9]), 
	.ul_v			(current_v_g1[19:9]),
        .clamp_x		(tex_2`T_TCU),		// clamp u		
	.clamp_y		(tex_2`T_TCV),		// clamp v	
        .bitmask_x		(current_bit_mask_x_g1), 
	.bitmask_y		(current_bit_mask_y_g1), 
	.current_clip		(current_clip_g1),
	.current_mipmap		(current_mipmap_g1),
	.current_exact		(current_exact_g1),
	// Outputs.
	.push_uv_d		(push_uv_d),
        .ul_x			(ul_x), 
        .ul_y			(ul_y), 
	.ur_x			(ur_x), 
	.ur_y			(ur_y), 
	.ll_x			(ll_x), 
	.ll_y			(ll_y), 
	.lr_x			(lr_x),
	.lr_y			(lr_y),
        .clamp_ul		(clamp_ul), 
	.clamp_ur		(clamp_ur),
        .clamp_ll		(clamp_ll), 
	.clamp_lr		(clamp_lr),
	.current_clip_d		(current_clip_d),
	.current_mipmap_d	(current_mipmap_d),
	.current_exact_d	(current_exact_d)
	);

// Current UV for Texture Cache..
// This needs to be a look ahead fifo.
sfifo_82x256_la u_sfifo_82x256_uv_tc
	(
	.aclr			(~de_rstn),
	.clock			(de_clk),
	.data			({ 
				current_clip_d,		// [0] 
				current_mipmap_d,	// [3:0]		 
				current_exact_d, 	// [0]
        			ul_x, 			// [8:0]
        			ul_y, 			// [8:0]
				ur_x, 			// [8:0]
				ur_y, 			// [8:0]
				ll_x, 			// [8:0]
				ll_y, 			// [8:0]
				lr_x,			// [8:0]
				lr_y,			// [8:0]
        			clamp_ul,		// [0]
				clamp_ur,		// [0]
        			clamp_ll, 		// [0]
				clamp_lr		// [0]
				}),
	.wrreq			(push_uv_d & tex_2`T_TM),
	.rdreq			(pop_uv), // tc_ready), // tc_ack),
	.q			({ 
				tc_clip,		// 1  bit.
				tc_mipmap, 		// 4  bits.
				tc_exact,		// 1  bit. 
        			tc_ul_x, 		// 9 bits
        			tc_ul_y, 		// 9 bits
				tc_ur_x, 		// 9 bits
				tc_ur_y, 		// 9 bits
				tc_ll_x, 		// 9 bits
				tc_ll_y, 		// 9 bits
				tc_lr_x,		// 9 bits
				tc_lr_y,		// 9 bits
        			tc_clamp_ul,		// 1 bits
				tc_clamp_ur,		// 1 bits
        			tc_clamp_ll, 		// 1 bits
				tc_clamp_lr		// 1 bits
			       	}),
	.empty			(tc_fetch_n),
	.usedw			(usedw_tc),
	.full			(),
	.almost_full		(full_tc)
	);

