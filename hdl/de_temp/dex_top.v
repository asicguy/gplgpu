///////////////////////////////////////////////////////////////////////////////
//
//  Silicon Spectrum Corporation - All Rights Reserved
//  Copyright (C) 2009 - All rights reserved
//
//  This File is copyright Silicon Spectrum Corporation and is licensed for
//  use by Universal Avionics Systems,i Corp., hereafter the "licensee", as defined by the NDA and the 
//  license agreement. 
//
//  This code may not be used as a basis for new development without a written
//  agreement between Silicon Spectrum and the licensee. 
//
//  New development includes, but is not limited to new designs based on this 
//  code, using this code to aid verification or using this code to test code 
//  developed independently by the licensee.
//
//  This copyright notice must be maintained as written, modifying or removing
//  this copyright header will be considered a breach of the license agreement.
//
//  The licensee may modify the code for the licensed project.
//  Silicon Spectrum does not give up the copyright to the original 
//  file or encumber in any way.
//
//  Use of this file is restricted by the license agreement between the
//  licensee and Silicon Spectrum, Inc.
//  
//  Title       :  Drawing Engine Execution Unit
//  File        :  dex_top.v
//  Author      :  Jim MacLeod
//  Created     :  30-Dec-2008
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description :
//  This module handles the execution of Drawing Engine commands
//
//////////////////////////////////////////////////////////////////////////////
//
//  Modules Instantiated:
//
///////////////////////////////////////////////////////////////////////////////
//
//  Modification History:
//
//  $Log:$
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 10ps
module dex_top
  (
   input                de_clk,         // drawing engine clock
   input                mclock,         // Memory controller clock
   input                rstn,           // syncronous reset
   input [31:0]         de_sorg_2,      // lower four bits of sorg
   input [31:0]         de_dorg_2,      // lower four bits of dorg
   input [3:0]          opc_1,          // drawing opcode first level of pipe
   input [3:0]          opc_15,         // drawing opcode first level of pipe
   input [3:0]          rop_1,          // drawing raster opcode        
   input [3:0]          rop_2,          // drawing raster opcode
   input                solid_1,        // solid bit                    
   input                solid_2,        // solid bit                    
   input                trnsp_2,        // transparent bit.             
   input                stpl_1,         // stipple bit.                 
   input [1:0]          stpl_2,         // stipple bit.                 
   input [1:0]          apat_2,         // area pattern mode            
   input                apat_1,         // the or of the area pattern mode bit
   input                sfd_2,          // source fetch disable bit.    
   input                edi_2,          // edge inclusion bit           
   input                prst,           // pattern reset bit            
   input                nlst_2,         // pattern register             
   input [2:0]          clp_2,          // clip control register        
   input [31:0]         lpat_1,         // line pattern register        
   input [15:0]         pctrl_1,        // pattern control register      
   input [31:0]         clptl_1,        // clip top left corner           
   input [31:0]         clpbr_1,        // clip bottom right corner       
   input [159:0]        xydat_1,        // xy data from the host registers 
   input                pc_mcrdy,       // memory controller in busy.       
                        pcbusy,         // pixel cache in busy.            
   input [1:0]          ps_1,           // pixel size.                   
   input                ps8_2,          // pixel size is eight bits       
                        ps16_2,         // pixel size is sixteen bits   
                        ps565_2,        // pixel size is sixteen bits, 565.   
                        ps32_2,         // pixel size is thirty two bits
                        pc_dirty,       // data is left in the pixel cache. 
   input                ca_rdy,         // Cache ready bit.                    
   input                pad8_2,         // Select 8 bit padding.               
   input                force8,         // Force 8 page mode.           
   input                mw_fip,         // Memory window flush in progress.  
   input		load_actvn,     // load the active command             
   input		load_actv_3d,   // load the active 3D, used prevent clipping scale.             
   input		cmdcpyclr,      // command copy clear.                 
   input		goline,         // Start Line Command.
   input		goblt,          // Start BLT Command.
   input		l3_incpat,      // Increment the line pattern, from 3D line SM.
   input		busy_3d,        // 3D command in progress.
   
   output               busy,           // command busy                        
                        bound,          // bound                               
                        pc_ld,          // load the pixel cache                
                        mem_req,        // memory request                      
                        mem_rd,         // memory read                         
                        mem_rmw,        // memory read modify write            
                        ld_wcnt,        // load the word count register        
   output [15:0]        fx,             // X alu output.  
   output [15:0]        srcx,           // source X output                    
                        srcy,           // source Y output                    
                        dstx,           // destination X output              
                        dsty,           // destination Y output            
   output               line_actv_2,    // line active signal                 
   output               blt_actv_2,     // bit blt active.                    
   output               fg_bgn,         // foreground=1, back=0, line pat.
   output [15:0]        lpat_state,     // read back path for line pat state   
   output [31:0]        clpx_bus_2,     // clipping X values.                  
   output               rstn_wad,       // load the cache write address countr.
   output               ld_rad,         // load the cache read address counter
   output               ld_rad_e,       // load the cache read address counter 
   output               sol_2,          // set the start of line signal.       
                        eol_2,          // set the end of line signal.         
   output               ld_msk,         // load the start and end masks.
   output [3:0]         fx_1,           // load the cache read address counter
   output               clip,           // clip indicator.                  
   output               y_clip_2,       // clip indicator.                 
   output               src_lte_dst,    // source less than dest.              
   output [4:0]         xpat_ofs,       
   output [4:0]         ypat_ofs,       
   output [15:0]        real_dstx,      
   output [15:0]        real_dsty,      
   output               xchng,
   output               ychng,
   output               ld_initial,
   output               next_x,
   output               next_y,
   output               pc_msk_last,frst_pix,
   output               last_pixel,
   output               line_actv_1,
   output               blt_actv_1,
   output [2:0]         frst8, 
   output               dex_busy,
   output [31:0]	clptl_2,
   output [31:0]	clpbr_2
   );

  /***********************************************************************/
  /*            create internal signalst                                */
  /************************************************************************/
  wire [2:0]    dir_2;          /* direction bits                       */
  /************************************************************************/
  /*            make internal assignments                               */
  /************************************************************************/
  wire          wr_gt_8;        
  wire          wr_gt_16;       
  wire [15:0]   fy;
  wire [4:0]    aluop;
  wire [4:0]    aad;
  wire [4:0]    bad;
  wire [3:0]    wad;
  wire [1:0]    wen;
  wire [4:0]    ksel;
  wire [15:0]   ax;
  wire [15:0]   ay;
  wire [15:0]   bx;
  wire [15:0]   by;
  wire          signx;
  wire          signy;
  wire          cstop_2;
  wire [3:0]    src_cntrl;
  wire [1:0]    dst_cntrl;
  wire [2:0]    t_dir;
  wire          wrk0_eqz;
  wire          wrk5_eqz;
  wire          set_sol;
  wire          set_eol;
  wire          ps16_1;
  wire          ps32_1;
  wire          eneg,eeqz;
  wire          src_upd,b_clr_ld_disab,b_cin;
  wire [2:0]    clp_status;
  wire          dex_next_x;
  wire          xeqz;
  wire          yeqz;
  wire          ldmajor;
  wire          ldminor;
  wire          incpat;
  wire          w_chgx;
  wire          eline_actv_1;
  wire          pline_actv_1;
  wire          pline_actv_2;
  wire          mul;
  wire          local_sol;
  wire          mod8;
  wire          mod32;
  wire          read_2;
  wire          tx_clr_seol;
  wire          inc_err;
  wire          rst_err;
  wire		line_actv_3d_1;
  
  assign        cstop_2 = clp_2[2];
  assign        ps16_1 = (ps_1==2'b01);
  assign        ps32_1 = (ps_1==2'b10);

  /************************************************************************/
  /*            MODULES                                                 */
  /************************************************************************/

  dex_sm u_dex_sm
    (
     .de_clk                 (de_clk),
     .de_rstn                (rstn),
     .mclock                 (mclock),
     .cstop_2                (cstop_2),
     .nlst_2                 (nlst_2),
     .solid_1                (solid_1),
     .solid_2                (solid_2),
     .trnsp_2                (trnsp_2),
     .stpl_pk_1              (stpl_1),
     .stpl_2                 (stpl_2),
     .apat_1                 (apat_1),
     .apat_2                 (apat_2),
     .sfd_2                  (sfd_2),
     .edi_2                  (edi_2),
     .mcrdy                  (pc_mcrdy),
     .pcbusyin               (pcbusy),
     .clip                   (clip),
     .wrk0_eqz               (wrk0_eqz),
     .wrk5_eqz               (wrk5_eqz),
     .signx                  (signx),
     .signy                  (signy),
     .xeqz                   (xeqz),
     .yeqz                   (yeqz),
     .dir                    (dir_2),
     .opc_1                  (opc_1),
     .opc_15                 (opc_15),
     .rop_1                  (rop_1),
     .rop_2                  (rop_2),
     .pc_dirty               (pc_dirty),
     .ps16_1                 (ps16_1),
     .ps32_1                 (ps32_1),
     .ps8_2                  (ps8_2),
     .ps16_2                 (ps16_2),
     .ps32_2                 (ps32_2),
     .eol_2                  (eol_2),
     .frst8                  (frst8),
     .ca_rdy                 (ca_rdy),
     .pad8_2                 (pad8_2),
     .wr_gt_8                (wr_gt_8),
     .wr_gt_16               (wr_gt_16),
     .eneg                   (eneg),
     .eeqz                   (eeqz),
     .force8                 (force8),
     .clp_status             (clp_status),
     .mw_fip                 (mw_fip),
     .load_actvn             (load_actvn),
     .cmdcpyclr              (cmdcpyclr),
     .goline                 (goline),
     .goblt                  (goblt),
     .busy_3d                (busy_3d),
     
     .aluop                  (aluop),
     .aad                    (aad),
     .bad                    (bad),
     .wad                    (wad),
     .wen                    (wen),
     .ksel                   (ksel),
     .l_ldmaj                (ldmajor),
     .l_ldmin                (ldminor),
     .l_bound                (bound),
     .l_incpat               (incpat),
     .src_cntrl              (src_cntrl),
     .dst_cntrl              (dst_cntrl),
     .wrk_chgx               (w_chgx),
     .pixreq                 (pc_ld),
     .busy_out               (busy),
     .mem_req                (mem_req),
     .mem_rd                 (mem_rd),
     .mem_rmw                (mem_rmw),
     .line_actv_1            (line_actv_1),
     .line_actv_3d_1         (line_actv_3d_1),
     .eline_actv_1           (eline_actv_1),
     .pline_actv_1           (pline_actv_1),
     .pline_actv_2           (pline_actv_2),
     .line_actv_2            (line_actv_2),
     .blt_actv_1             (blt_actv_1),
     .blt_actv_2             (blt_actv_2),
     .rstn_wad               (rstn_wad),
     .ld_rad                 (ld_rad),
     .ld_rad_e               (ld_rad_e),
     .set_sol                (set_sol),
     .set_eol                (set_eol),
     .ld_msk                 (ld_msk),
     .ld_wcnt                (ld_wcnt),
     .mul                    (mul),
     .local_sol              (local_sol),
     .mod8                   (mod8),
     .mod32                  (mod32),
     .read_2                 (read_2),
     .clr_seol               (tx_clr_seol),
     .ld_initial             (ld_initial),
     .next_x                 (next_x),
     .dex_next_x             (dex_next_x),
     .next_y                 (next_y),
     .inc_err                (inc_err),
     .rst_err                (rst_err),
     .pc_msk_last            (pc_msk_last),
     .frst_pix               (frst_pix),
     .last_pixel             (last_pixel),
     .src_upd                (src_upd),
     .b_clr_ld_disab         (b_clr_ld_disab),
     .b_cin                  (b_cin),
     .dex_busy               (dex_busy)
     );
  
dex_alu u_dex_alu
        (
        // Inputs.
        .de_clk                 (de_clk),
        .rstn                   (rstn),
        .aluop                  (aluop),
        .ax                     (ax),
        .bx                     (bx),
        .ay                     (ay),
        .by                     (by),
        .ksel                   (ksel),
        .load_actvn             (load_actvn),
        .ps32_2                 (ps32_2),
        .ps16_2                 (ps16_2),
        .local_sol              (local_sol),
        .mod8                   (mod8),
        .mod32                  (mod32),
        .pad8_2                 (pad8_2),
        .read_2                 (read_2),
        .b_cin                  (b_cin),
        // Outputs.
        .fx                     (fx),
        .fy                     (fy),
        .xeqz                   (xeqz),
        .yeqz                   (yeqz),
        .frst8                  (frst8[1:0]),
        .fx_1                   (fx_1),
        .signx                  (signx),
        .signy                  (signy),
        .src_lte_dst            (src_lte_dst)
        );
  
dex_reg u_dex_reg
        (
        .de_clk                 (de_clk),
        .de_rstn                (rstn),
        .xydat_1                (xydat_1),
        .load_actvn_in          (load_actvn),
        .load_actv_3d           (load_actv_3d),
        .line_actv_1            (line_actv_1),
        .line_actv_3d_1         (line_actv_3d_1),
        .line_actv_2            (line_actv_2),
        .blt_actv_1             (blt_actv_1),
        .blt_actv_2             (blt_actv_2),
        .aad                    (aad),
        .bad                    (bad),
        .wad                    (wad),
        .wen                    (wen),
        .ldmajor                (ldmajor),
        .ldminor                (ldminor),
        .prst                   (prst),
        .incpat                 (incpat),
        .l3_incpat              (l3_incpat),
        .src_cntrl              (src_cntrl),
        .dst_cntrl              (dst_cntrl),
        .w_chgx                 (w_chgx),
        .fx                     (fx),
        .fy                     (fy),
        .lpat_1                 (lpat_1),
        .pctrl_1                (pctrl_1),
        .clp_2                  (clp_2[1:0]),
        .clptl_1                (clptl_1),
        .clpbr_1                (clpbr_1),
        .de_sorg_2              (de_sorg_2),
        .de_dorg_2              (de_dorg_2),
        .set_sol                (set_sol),
        .set_eol                (set_eol),
        .mem_req                (mem_req),
        .mem_read               (mem_rd),
        .ps_1                   (ps_1),
        .ps16_2                 (ps16_2),
        .ps32_2                 (ps32_2),
        .eline_actv_1           (eline_actv_1),
        .pline_actv_1           (pline_actv_1),
        .pline_actv_2           (pline_actv_2),
        .mul                    (mul),
        .stpl_2                 (stpl_2[1]),
        .tx_clr_seol            (tx_clr_seol),
        .edi_2                  (edi_2),
        .inc_err                (inc_err),
        .rst_err                (rst_err),
        .stpl_1                 (stpl_1),
        .src_upd                (src_upd),
        .b_clr_ld_disab         (b_clr_ld_disab),
        .next_x                 (dex_next_x),
        .dir                    (dir_2),
        .wrk0_eqz               (wrk0_eqz),
        .wrk5_eqz               (wrk5_eqz),
        .ax                     (ax),
        .bx                     (bx),
        .ay                     (ay),
        .by                     (by),
        .clip                   (clip),
        .srcx                   (srcx),
        .srcy                   (srcy),
        .dstx                   (dstx),
        .dsty                   (dsty),
        .fg_bgn                 (fg_bgn),
        .lpat_state             (lpat_state),
        .clpx_bus_2             (clpx_bus_2),
        .sol_2                  (sol_2),
        .eol_2                  (eol_2),
        .y_clip_2               (y_clip_2),
        .rd_eq_wr               (frst8[2]),
        .wr_gt_8                (wr_gt_8),
        .wr_gt_16               (wr_gt_16),
        .xpat_ofs               (xpat_ofs),
        .ypat_ofs               (ypat_ofs),
        .real_dstx              (real_dstx),
        .real_dsty              (real_dsty),
        .xchng                  (xchng),
        .ychng                  (ychng),
        .eneg                   (eneg),
        .eeqz                   (eeqz),
        .clp_status             (clp_status),
        .clptl_r             	(clptl_2),
        .clpbr_r             	(clpbr_2)
        );

endmodule
