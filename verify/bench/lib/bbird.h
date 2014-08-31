/******************************************************************************
 *
 *  Copyright (C) 2014 Francis Bruno, All Rights Reserved
 * 
 *  This program is free software; you can redistribute it and/or modify it 
 *  under the terms of the GNU General Public License as published by the Free 
 *  Software Foundation; either version 3 of the License, or (at your option) 
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful, but 
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 *  or FITNESS FOR A PARTICULAR PURPOSE. 
 *  See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along with
 *  this program; if not, see <http://www.gnu.org/licenses>.
 *
 *  This code is available under licenses for commercial use. Please contact
 *  Francis Bruno for more information.
 *
 *  http://www.gplgpu.com
 *  http://www.asicsolutions.com
 *
 *  Title       :  
 *  File        :  bbird.h
 *  Author      :  Frank Bruno
 *  Created     :  14-May-2011
 *  RCS File    :  $Source:$
 *  Status      :  $Id:$
 *
 ******************************************************************************
 *
 *  Description : 
 *
 *  Header file for test genration
 *
 ******************************************************************************
 *
 *  Modules Instantiated:
 *
 ******************************************************************************
 *
 *  Modification History:
 *
 *  $Log:$
 *
 *
 *****************************************************************************/
#include "os.h"
#include "ninedefs.h"
#include "cfgfile.h"

/* PCI defines */
#define BBIRD_PCI_VENDOR_ID     0x105D
#define BBIRD_PCI_DEVICE_ID     0x2309
#define BBIRD_PCI_DEVICE_ID2    0x2339
#define BBIRD_PCI_DEVICE_ID3    0x493D
#define BBIRD_PCI_DEVICE_ID_SH  0x5348 /* Silver Hammer */

/* PCI Subsystem IDs */
#define BBIRD_PCI_SUBSYS_VRAM   0x00
#define BBIRD_PCI_SUBSYS_TIDRAM 0x03
#define BBIRD_PCI_SUBSYS_DRAM   0x08
#define BBIRD_PCI_SUBSYS_8MVRAM 0x0A
#define BBIRD_PCI_SUBSYS_8MVRAM_FAST    0x0B

/* Flags */
#define BBIRD_SELECT_ENGINE_A   0
#define BBIRD_SELECT_ENGINE_B   1

#define BBIRD_FILE_ERROR        (-1)    /* A file error occured */
#define BBIRD_MODE_ERROR        (-2)    /* The mode fails on this board */
#define BBIRD_MODE_VGA          (-1)    /* Set VGA mode */
#define BBIRD_MODE_DEFAULT      (-2)    /* Set the default mode */
#define BBIRD_MODE_CLEAR_DISP   0x0001  /* Clear the display screen */
#define BBIRD_MODE_CLEAR_VIRT   0x0002  /* Clear the virtual page */
#define BBIRD_MODE_CLEAR_MASK   0x0004  /* Clear the mask page */
#define BBIRD_MODE_CLEAR        0x0007  /* Clear all the screen pages */
#define BBIRD_MODE_ENGINE_INIT  0x0010  /* Initialize the drawing engine */
#define BBIRD_NO_ERROR          0       /* if no errors in bbird_set_mode */
#define BBIRD_HARD_ERROR        (-3)    /* if a hardware error occured */
#define BBIRD_RANGE_ERROR       (-4)    /* Address is out of range */

/* Parameters for the source bitmap */
#define BBIRD_FLAG_SRC_BITS     0x47008320      /* Mask to set src flags */
#define BBIRD_FLAG_SRC_DISP     0x00000000      /* Select Disp as source */
#define BBIRD_FLAG_SRC_VIRT     0x00000100      /* Select Virt as source */
#define BBIRD_FLAG_SRC_MASK     0x00000200      /* Select MASK plane as src */
#define BBIRD_FLAG_SRC_CACHE    0x00000300      /* Select host cache as src */
#define BBIRD_FLAG_XY_ORIGIN    0x00008000      /* X-Y origin mode */
#define BBIRD_FLAG_8_BPP        0x00000000      /* Use  8 bits per pixel */
#define BBIRD_FLAG_16_BPP       0x01000000      /* Use 16 bits per pixel */
#define BBIRD_FLAG_32_BPP       0x02000000      /* Use 32 bits per pixel */
#define BBIRD_FLAG_NO_BPP       0x03000000      /* Don't use bits per pixel */
#define BBIRD_FLAG_CACHE_ON     0x40000000      /* Cache is always on */
#define BBIRD_FLAG_CACHE_READY  0x80000000      /* Set this when cache ready */
#define BBIRD_FLAG_CE_555       0x00000000      /* Set Copy Engine 555 mode */
#define BBIRD_FLAG_CE_565       0x04000000      /* Set Copy Engine 565 mode */

/* Parameters for the destination bitmap */
#define BBIRD_FLAG_DST_BITS     0x077FFC3E      /* Mask to set dst flags */
#define BBIRD_FLAG_DST_DISP     0x00000000      /* Select DISP as dst */
#define BBIRD_FLAG_DST_VIRT     0x00000400      /* Select VIRT as dst */
#define BBIRD_FLAG_DST_MASK     0x00000800      /* Select MASK plane as dst */
#define BBIRD_FLAG_DST_NONE     0x00000C00      /* No destination selected */
#define BBIRD_FLAG_SHADOW_D     0x00001000      /* Also write to DISP */
#define BBIRD_FLAG_SHADOW_V     0x00002000      /* Also write to VIRT */
#define BBIRD_FLAG_SHADOW_M     0x00004000      /* Also write to MASK */
#define BBIRD_FLAG_MASK_DISP    0x00000008      /* Apply MASK mask to DISP */
#define BBIRD_FLAG_MASK_VIRT    0x00000002      /* Apply MASK mask to VIRT */
#define BBIRD_FLAG_MASK_ZERO    0x00000000      /* Allow write when MASK=1 */
#define BBIRD_FLAG_MASK_ONE     0x00000004      /* Allow write when MASK=0 */
#define BBIRD_FLAG_MASK_WID     0x00000010      /* Set up Window ID masking */
#define BBIRD_FLAG_FORCE8       0x00000020      /* Force 8 page mode */
#define BBIRD_FLAG_MASK_KEY     0x00200000      /* Set MASK when color=key */
#define BBIRD_FLAG_MASK_PLANAR  0x00400000      /* Set MASK bits planar mode */
#define BBIRD_FLAG_PLANE(x)     ((long)((x) & 0x1F) << 16) /* Set MASK plane */
#define BBIRD_FLAG_555          0x00000000      /* Set Engine 555 mode */
#define BBIRD_FLAG_565          0x04000000      /* Set Engine 565 mode */

/* Various flags for most drawing functions */
#define BBIRD_CMD_ROP_SHIFT     8               /* if using CMD_ROP reg */
#define BBIRD_ROP_CLEAR         0x00000000      /* Set dest to Zero */
#define BBIRD_ROP_NOR           0x00000100      /* (not src) and (not dst) */
#define BBIRD_ROP_ANDINVERTED   0x00000200      /* (not src) and dest */
#define BBIRD_ROP_COPYINVERTED  0x00000300      /* not src */
#define BBIRD_ROP_ANDREVERSE    0x00000400      /* src and (not dest) */
#define BBIRD_ROP_INVERT        0x00000500      /* not dest */
#define BBIRD_ROP_XOR           0x00000600      /* src xor dest */
#define BBIRD_ROP_NAND          0x00000700      /* (not src) or (not dest) */
#define BBIRD_ROP_AND           0x00000800      /* src and dest */
#define BBIRD_ROP_EQUIV         0x00000900      /* (not src) xor dest */
#define BBIRD_ROP_NOOP          0x00000A00      /* dest */
#define BBIRD_ROP_ORINVERTED    0x00000B00      /* (not src) or dest */
#define BBIRD_ROP_COPY          0x00000C00      /* src */
#define BBIRD_ROP_ORREVERSE     0x00000D00      /* src or (not dest) */
#define BBIRD_ROP_OR            0x00000E00      /* src or dest */
#define BBIRD_ROP_SET           0x00000F00      /* Set dest to 1 */

#define BBIRD_OPCODE_NOOP       0x00            /* No drawing operation */
#define BBIRD_OPCODE_BITBLT     0x01            /* Do a bit block transfer */
#define BBIRD_OPCODE_LINE       0x02            /* Draw a line */
#define BBIRD_OPCODE_ELINE      0x03            /* Draw line, error terms */
#define BBIRD_OPCODE_TRIANGLE   0x04            /* Draw a triangle or quad */
#define BBIRD_OPCODE_PLINE      0x05            /* Draw poly line */
#define BBIRD_OPCODE_RXFER      0x06            /* Transfer data to host */
#define BBIRD_OPCODE_WXFER      0x07            /* Transfer data from host */
#define BBIRD_TRIAN_3DS         0x08            /* 3D Triangle, slopes req. */
#define BBIRD_LINE_3D           0x08            /* 3D line */
#define BBIRD_TRIAN_3D          0x09            /* 3D Triangle, no slopes */
    
#define BBIRD_COPY_OP_ONE_SHOT  0x01            /* One shot copy */
#define BBIRD_COPY_OP_FREE_RUN  0x02            /* free running copy */
#define BBIRD_COPY_OP_V_TRIGGER 0x03            /* vertical triggered copy */

#define BBIRD_CMD_STYLE_SHIFT   16              /* If using CMD_STYLE reg */
#define BBIRD_CMD_SOLID         0x00010000      /* Set to foreground color */
#define BBIRD_CMD_TRANSPARENT   0x00020000      /* Background transparency */
#define BBIRD_CMD_STIPPLE_OFF   0x00000000      /* No stipple */
#define BBIRD_CMD_STIPPLE_PLANAR 0x00040000     /* Stipple is planar mode. */
#define BBIRD_CMD_STIPPLE_PACK32 0x00080000     /* packed, padded to 32 bits */
#define BBIRD_CMD_STIPPLE_PACK8 0x000C0000      /* packed, padded to 8 bits */
#define BBIRD_CMD_EDGE_INCLUDE  0x00100000      /* Edge include mode */
#define BBIRD_CMD_AREAPAT_OFF   0x00000000      /* No area pattern */
#define BBIRD_CMD_AREAPAT_8x8   0x01000000      /* Source is 8x8 pattern. */
#define BBIRD_CMD_AREAPAT_32x32 0x02000000      /* Source is 32x32 pattern.*/
#define BBIRD_CMD_NO_LAST       0x04000000      /* No last pixel in a line.*/
#define BBIRD_CMD_PATT_RESET    0x08000000      /* Reset pattern pointers. */
#define BBIRD_CMD_CLIP_IN       0x00400000      /* Clip inside cliprect. */
#define BBIRD_CMD_CLIP_OUT      0x00600000      /* Clip outside cliprect. */
#define BBIRD_CMD_NO_CLIP       0x00000000      /* No rectangle clipping */
#define BBIRD_CMD_CLIP_STOP     0x00800000      /* Stop if clipping. */
#define BBIRD_CMD_SWAP_SHIFT    28
#define BBIRD_CMD_SWAP_BITS     0x70000000      /* Host data swap control. */
#define BBIRD_CMD_BIT_SWAP      0x10000000      /* Swap bits in each byte */
#define BBIRD_CMD_BYTE_SWAP     0x20000000      /* Swap bytes in each word */
#define BBIRD_CMD_WORD_SWAP     0x40000000      /* Swap words in each dword */
#define BBIRD_CMD_SHADE         0x80000000      /* Use shading on 3D triangles */

#define BBIRD_CMD_COPY_Y_INTERP 0x00010000      /* Copy engine Y interpolator */
#define BBIRD_CMD_COPY_X_INTERP 0x00020000      /* Copy engine X interpolator */

/* These flags inidicate which value is written to MASK. */
#define BBIRD_KEY_FLAG_ZERO     0x00000000      /* Write 0 to MASK */
#define BBIRD_KEY_FLAG_ONE      0x000F000F      /* Write 1 to MASK */
#define BBIRD_KEY_FLAG_MATCH    0x0000000F      /* Write 1 if match else 0 */
#define BBIRD_KEY_FLAG_DIFFER   0x000F0000      /* Write 0 if match else 1 */
#define BBIRD_LPAT_LENGTH(x)    ((x) & 0x1F)    /* Pattern length (32,1-31)*/
#define BBIRD_LPAT_ZOOM(x)      ((((x) - 1) & 7) << 5)/* Pattern zoom (1-8) */
#define BBIRD_LPAT_INIT_PAT(x)  (((x) & 0x1F) << 8)/* Initial pattern offset */
#define BBIRD_LPAT_INIT_ZOOM(x) (((x) & 7) << 13)/* Initial zoom step */
#define BBIRD_LPAT_STATE        0xFFFF0000      /* current state */

#define BBIRD_DIR_LR_TB         0x00            /* left-right, top-bottom */
#define BBIRD_DIR_LR_BT         0x01            /* left-right, bottom-top */
#define BBIRD_DIR_RL_TB         0x02            /* right-left, top-bottom */
#define BBIRD_DIR_RL_BT         0x03            /* right-left, bottom-top */

#define BBIRD_BLIT_NO_ZOOM      0x00000000      /* straight copy */
#define BBIRD_BLIT_ZOOM_Y(x)    ((x) & 0xF)     /* Set Y zoom factor (1-8) */
#define BBIRD_BLIT_ZOOM_X(x)    ((long)((x) & 0xF) << 16)/* Set X zoom (1-8) */
#define BBIRD_BLIT_ZOOM(x)      (BBIRD_BLIT_ZOOM_X(x) | BBIRD_BLIT_ZOOM_Y(x))

/* Copy engine zoom */
#define BBIRD_COPY_NO_ZOOM      0x10001000
#define BBIRD_COPY_ZOOM_1(x)    ((4096 + (x) - 1)/(x))
#define BBIRD_COPY_ZOOM(x,y)    ((((long)BBIRD_COPY_ZOOM_1(x)) << 16) | \
                                (long)BBIRD_COPY_ZOOM_1(y))

/* Parameters for INTP/INTM */
#define BBIRD_INT_ENGINE        0x00000001      /* Engine op complete */
#define BBIRD_INT_CLIP_A        0x00000002      /* Engine clipped */
#define BBIRD_INT_Z_OVERFLOW    0x00000100      /* Engine Z overflow */
#define BBIRD_INT_Z_UNDERFLOW   0x00000200      /* Engine Z underflow */
#define BBIRD_INT_YON           0x00000400      /* Engine Yon interrupt */
#define BBIRD_INT_HITHER        0x00000800      /* Engine Hither interrupt */

#ifdef I3D
/* Alpha blending register */
#define BBIRD_ZA_SRC_ZERO                       0x00000000
#define BBIRD_ZA_SRC_ONE                        0x00000001
#define BBIRD_ZA_SRC_DST_COLOR                  0x00000002
#define BBIRD_ZA_SRC_ONE_MINUS_DST              0x00000003
#define BBIRD_ZA_SRC_SRC_ALPHA                  0x00000004
#define BBIRD_ZA_SRC_ONE_MINUS_SRC_ALPHA        0x00000005
#define BBIRD_ZA_SRC_DST_ALPHA                  0x00000006
#define BBIRD_ZA_SRC_ONE_MINUS_DST_ALPHA        0x00000007

#define BBIRD_ZA_DST_ZERO                       0x00000000
#define BBIRD_ZA_DST_ONE                        0x00000010
#define BBIRD_ZA_DST_SRC_COLOR                  0x00000020
#define BBIRD_ZA_DST_ONE_MINUS_SRC              0x00000030
#define BBIRD_ZA_DST_SRC_ALPHA                  0x00000040
#define BBIRD_ZA_DST_ONE_MINUS_SRC_ALPHA        0x00000050
#define BBIRD_ZA_DST_DST_ALPHA                  0x00000060
#define BBIRD_ZA_DST_ONE_MINUS_DST_ALPHA        0x00000070

#define BBIRD_ZA_SRE            0x00000100
#define BBIRD_ZA_DRE            0x00000200
#define BBIRD_ZA_BLEND_ENABLE   0x00000400
/* Etc. */

/* I3D_CTRL */
#define BBIRD_Z3D_Z_ENABLE      0x00000001
#define BBIRD_Z3D_Z_READ_ONLY   0x00000002
#define BBIRD_Z3D_Z_LOW_RES     0x00000004
#define BBIRD_Z3D_ORTHO_Z_MODE  0x00000008
#define BBIRD_Z3D_NO_DITHER     0x00000000
#define BBIRD_Z3D_2x2_DITHER    0x00010000
#define BBIRD_Z3D_4x4_DITHER    0x00020000
#define BBIRD_Z3D_8x8_DITHER    0x00030000
#define BBIRD_Z3D_SHADE         0x01000000
#define BBIRD_Z3D_SPECULAR      0x02000000
#define BBIRD_Z3D_ALPHA_FOGGED  0x04000000
#define BBIRD_Z3D_FOG           0x08000000
#define BBIRD_Z3D_RECTANGLE     0x10000000
#define BBIRD_Z3D_8BPP_PALLETTE 0x20000000
#define BBIRD_Z3D_Z_SCALE       0x40000000

#define BBIRD_Z3D_COMP_NEVER    0x00000000      /* Z comparator never */
#define BBIRD_Z3D_COMP_ALWAYS   0x00000020      /* Z comparator always */
#define BBIRD_Z3D_COMP_LT       0x00000040      /* Z comparator less than */
#define BBIRD_Z3D_COMP_LE       0x00000060      /* Z comparator < or = */
#define BBIRD_Z3D_COMP_EQ       0x00000080      /* Z comparator equal */
#define BBIRD_Z3D_COMP_GE       0x000000A0      /* Z comparator > or = */
#define BBIRD_Z3D_COMP_GT       0x000000C0      /* Z comparator greater than */
#define BBIRD_Z3D_COMP_NE       0x000000E0      /* Z comparator not equal */

#define BBIRD_Z3D_YON_NEVER     0x00000000      /* Yon comp.  never */
#define BBIRD_Z3D_YON_ALWAYS    0x00000100      /* Yon comp.  always */
#define BBIRD_Z3D_YON_LT        0x00000200      /* Yon comp.  less than */
#define BBIRD_Z3D_YON_LE        0x00000300      /* Yon comp.  < or = */
#define BBIRD_Z3D_YON_EQ        0x00000400      /* Yon comp.  equal */
#define BBIRD_Z3D_YON_GE        0x00000500      /* Yon comp.  > or = */
#define BBIRD_Z3D_YON_GT        0x00000600      /* Yon comp.  greater than */
#define BBIRD_Z3D_YON_NE        0x00000700      /* Yon comp.  not equal */

#define BBIRD_Z3D_HITH_NEVER    0x00000000      /* Hither comp. never */
#define BBIRD_Z3D_HITH_ALWAYS   0x00000800      /* Hither comp. always */
#define BBIRD_Z3D_HITH_LT       0x00001000      /* Hither comp. less than */
#define BBIRD_Z3D_HITH_LE       0x00001800      /* Hither comp. < or = */
#define BBIRD_Z3D_HITH_EQ       0x00002000      /* Hither comp. equal */
#define BBIRD_Z3D_HITH_GE       0x00002800      /* Hither comp. > or = */
#define BBIRD_Z3D_HITH_GT       0x00003000      /* Hither comp. greater than */
#define BBIRD_Z3D_HITH_NE       0x00003800      /* Hither comp. not equal */

/* TEX_CNTRL */
#define BBIRD_ZT_TEXTURE_MAP    0x00000001      /* Enable texture mapping */
#define BBIRD_ZT_MIP_MAP        0x00000002      /* Enable mip mapping */
#define BBIRD_ZT_MIP_MAP_CORR   0x00000004      /* Enable mip map correction */
#define BBIRD_ZT_TRILINEAR      0x00000008      /* Enable trilinear mapping */
#define BBIRD_ZT_NEAREST_MODE   0x00000010      /* Enable nearest mode */
#define BBIRD_ZT_RGB_MODULATION 0x00000020      /* Enable RGB modulation */
#define BBIRD_ZT_PERSPECTIVE    0x00000040      /* Enable perspective mode */

#define BBIRD_ZT_NO_MIRRORING   0x00000000
#define BBIRD_ZT_MIRROR_X       0x00000800
#define BBIRD_ZT_MIRROR_Y       0x00001000
#define BBIRD_ZT_MIRROR_X_AND_Y 0x00001800
#define BBIRD_ZT_1_MIPMAP       0x00000000
#define BBIRD_ZT_2_MIPMAP       0x00002000
#define BBIRD_ZT_3_MIPMAP       0x00004000
#define BBIRD_ZT_4_MIPMAP       0x00006000
#define BBIRD_ZT_5_MIPMAP       0x00008000

#define BBIRD_ZT_TSIZE_P1_1555  0x00000000
#define BBIRD_ZT_TSIZE_P1_0565  0x01000000
#define BBIRD_ZT_TSIZE_P1_4444  0x02000000
#define BBIRD_ZT_TSIZE_P2_1555  0x04000000
#define BBIRD_ZT_TSIZE_P2_0565  0x05000000
#define BBIRD_ZT_TSIZE_P2_4444  0x06000000
#define BBIRD_ZT_TSIZE_P4_1555  0x08000000
#define BBIRD_ZT_TSIZE_P4_0565  0x09000000
#define BBIRD_ZT_TSIZE_P4_4444  0x0A000000
#define BBIRD_ZT_TSIZE_8_1232   0x0C000000
#define BBIRD_ZT_TSIZE_8_0332   0x0D000000
#define BBIRD_ZT_TSIZE_16_4444  0x10000000
#define BBIRD_ZT_TSIZE_16_1555  0x11000000
#define BBIRD_ZT_TSIZE_16_0565  0x12000000
#define BBIRD_ZT_TSIZE_32_8888  0x14000000

#define BBIRD_ZT_TXTURE_INVALID 0x20000000
#define BBIRD_ZT_TEXTURE_CACHED 0x40000000
#define BBIRD_ZT_SCALE_UV       0x80000000
#else   /* !I3D */
/* Z Control register bits */
#define BBIRD_Z_ENABLE          0x00000001      /* Enable Z clipping */
#define BBIRD_Z_COMP_OP         0x0000000E      /* Z comparator opcode */
#define BBIRD_Z_YON_OP          0x00000070      /* Hither comparator op */
#define BBIRD_Z_HITH_OP         0x00000380      /* Yon comparator op */
#define BBIRD_Z_READ_ONLY       0x00000400      /* Do not write to Z buffer */
#define BBIRD_Z_16_BIT          0x00000800      /* Force Z buffer to 16 bit */
#define BBIRD_Z_DELAY           0x00001000      /* Delay each Z cycle */

#define BBIRD_Z_COMP_NEVER      0x00000000      /* Z comparator never */
#define BBIRD_Z_COMP_ALWAYS     0x00000002      /* Z comparator always */
#define BBIRD_Z_COMP_LT         0x00000004      /* Z comparator less than */
#define BBIRD_Z_COMP_LE         0x00000006      /* Z comparator < or = */
#define BBIRD_Z_COMP_EQ         0x00000008      /* Z comparator equal */
#define BBIRD_Z_COMP_GE         0x0000000A      /* Z comparator > or = */
#define BBIRD_Z_COMP_GT         0x0000000C      /* Z comparator greater than */
#define BBIRD_Z_COMP_NE         0x0000000E      /* Z comparator not equal */

#define BBIRD_Z_YON_NEVER       0x00000000      /* Yon comp.  never */
#define BBIRD_Z_YON_ALWAYS      0x00000010      /* Yon comp.  always */
#define BBIRD_Z_YON_LT          0x00000020      /* Yon comp.  less than */
#define BBIRD_Z_YON_LE          0x00000030      /* Yon comp.  < or = */
#define BBIRD_Z_YON_EQ          0x00000040      /* Yon comp.  equal */
#define BBIRD_Z_YON_GE          0x00000050      /* Yon comp.  > or = */
#define BBIRD_Z_YON_GT          0x00000060      /* Yon comp.  greater than */
#define BBIRD_Z_YON_NE          0x00000070      /* Yon comp.  not equal */

#define BBIRD_Z_HITH_NEVER      0x00000000      /* Hither comp. never */
#define BBIRD_Z_HITH_ALWAYS     0x00000080      /* Hither comp. always */
#define BBIRD_Z_HITH_LT         0x00000100      /* Hither comp. less than */
#define BBIRD_Z_HITH_LE         0x00000180      /* Hither comp. < or = */
#define BBIRD_Z_HITH_EQ         0x00000200      /* Hither comp. equal */
#define BBIRD_Z_HITH_GE         0x00000280      /* Hither comp. > or = */
#define BBIRD_Z_HITH_GT         0x00000300      /* Hither comp. greater than */
#define BBIRD_Z_HITH_NE         0x00000380      /* Hither comp. not equal */

/* Copy engine zoom */
#define BBIRD_COPY_NO_ZOOM      0x10001000
#define BBIRD_COPY_ZOOM_1(x)    ((4096 + (x) - 1)/(x))
#define BBIRD_COPY_ZOOM(x,y)    ((((long)BBIRD_COPY_ZOOM_1(x)) << 16) | \
                                (long)BBIRD_COPY_ZOOM_1(y))
#endif  /* !I3D */

/* Parameters for Display List Processor */
#define BBIRD_DL_FMT0           0x00000000
#define BBIRD_DL_FMT1           0x20000000
#define BBIRD_DL_SRC_DISP       0x00000000
#define BBIRD_DL_SRC_VIRT       0x40000000
#define BBIRD_DL_STOP           0x80000000

/*         wait_flag -          Flag to indicate which state to wait for */
#define BBIRD_WAIT_READY        0x00000000      /* Wait for engine ready */
#define BBIRD_WAIT_IDLE         0x00000001      /* Wait for engine idle */
#define BBIRD_WAIT_DONE         0x00000003      /* Wait for engine stop */
#define BBIRD_WAIT_PREVIOUS     0x00000004      /* Wait for prev. cache */
#define BBIRD_WAIT_CACHE        0x00000005      /* Wait for cache ready */

/* Parameters for the XY window */
#define BBIRD_XYWIN_SZ_4K       0x00000000
#define BBIRD_XYWIN_SZ_8K       0x00000100
#define BBIRD_XYWIN_SZ_16K      0x00000200
#define BBIRD_XYWIN_SZ_32K      0x00000300
#define BBIRD_XYWIN_SZ_64K      0x00000400
#define BBIRD_XYWIN_SZ_128K     0x00000500
#define BBIRD_XYWIN_SZ_256K     0x00000600
#define BBIRD_XYWIN_SZ_512K     0x00000700
#define BBIRD_XYWIN_SZ_1M       0x00000800
#define BBIRD_XYWIN_SZ_2M       0x00000900
#define BBIRD_XYWIN_SZ_4M       0x00000A00
#define BBIRD_XYWIN_SZ_8M       0x00000B00
#define BBIRD_XYWIN_SZ_16M      0x00000C00
#define BBIRD_XYWIN_SZ_32M      0x00000D00

/* Parameters for the linear memory window */
#define BBIRD_MEMW_SZ_4K        0x00000000
#define BBIRD_MEMW_SZ_8K        0x00000001
#define BBIRD_MEMW_SZ_16K       0x00000002
#define BBIRD_MEMW_SZ_32K       0x00000003
#define BBIRD_MEMW_SZ_64K       0x00000004
#define BBIRD_MEMW_SZ_128K      0x00000005
#define BBIRD_MEMW_SZ_256K      0x00000006
#define BBIRD_MEMW_SZ_512K      0x00000007
#define BBIRD_MEMW_SZ_1M        0x00000008
#define BBIRD_MEMW_SZ_2M        0x00000009
#define BBIRD_MEMW_SZ_4M        0x0000000A
#define BBIRD_MEMW_SZ_8M        0x0000000B
#define BBIRD_MEMW_SZ_16M       0x0000000C
#define BBIRD_MEMW_SZ_32M       0x0000000D

/* Linear Memory Window conversion options */
#define BBIRD_MEMW_SZ_SRC_555   0x00000000
#define BBIRD_MEMW_SZ_SRC_565   0x00010000
#define BBIRD_MEMW_SZ_SRC_X888  0x00020000
#define BBIRD_MEMW_SZ_SRC_888   0x00030000
#define BBIRD_MEMW_SZ_DST_555   0x00000000
#define BBIRD_MEMW_SZ_DST_565   0x00040000
#define BBIRD_MEMW_SZ_DST_X888  0x00080000
#define BBIRD_MEMW_SZ_DST_888   0x000C0000
#define BBIRD_MEMW_SZ_DIB_ENB   0x00800000
#define BBIRD_MEMW_SZ_DE_FLSH   0x01000000
#define BBIRD_MEMW_SZ_CE_FLSH   0x02000000
#define BBIRD_MEMW_SZ_CRT_FLSH  0x04000000

#define BBIRD_MEMW_SRC_DISP     0x00000000      /* Select Disp as source */
#define BBIRD_MEMW_SRC_VIRT     0x00000010      /* Select Virt as source */
#define BBIRD_MEMW_SRC_MASK     0x00000020      /* Select MASK plane as src */
#define BBIRD_MEMW_SRC_NONE     0x00000030      /* No input selected */
#define BBIRD_MEMW_WR_CACHE     0x00000040      /* Enable write cache */
#define BBIRD_MEMW_8_BPP        0x00000000      /* Use  8 bits per pixel */
#define BBIRD_MEMW_16_BPP       0x04000000      /* Use 16 bits per pixel */
#define BBIRD_MEMW_24_BPP       0x0C000000      /* Use 24 bits per pixel */
#define BBIRD_MEMW_32_BPP       0x08000000      /* Use 32 bits per pixel */
#define BBIRD_MEMW_DST_DISP     0x00000000      /* Select DISP as dst */
#define BBIRD_MEMW_DST_VIRT     0x01000000      /* Select VIRT as dst */
#define BBIRD_MEMW_DST_MASK     0x02000000      /* Select MASK plane as dst */
#define BBIRD_MEMW_DST_NONE     0x03000000      /* No destination selected */
#define BBIRD_MEMW_SHADOW_D     0x40000000      /* Also write to DISP */
#define BBIRD_MEMW_SHADOW_V     0x20000000      /* Also write to VIRT */
#define BBIRD_MEMW_SHADOW_M     0x10000000      /* Also write to MASK */
#define BBIRD_MEMW_MASK_DISP    0x00000008      /* Apply MASK mask to DISP */
#define BBIRD_MEMW_MASK_VIRT    0x00000002      /* Apply MASK mask to VIRT */
#define BBIRD_MEMW_MASK_ZERO    0x00000000      /* Allow write when MASK=1 */
#define BBIRD_MEMW_MASK_ONE     0x00000004      /* Allow write when MASK=0 */
#define BBIRD_MEMW_MASK_KEY     0x00200000      /* Set MASK when color=key */
#define BBIRD_MEMW_MASK_DIRECT  0x00600000      /* Set MASK bits directly */
#define BBIRD_MEMW_BUSY         0x00000100      /* Memory window is busy */

#define BBIRD_MEMW_WR_CACHE     0x00000040      /* Enable write cache */
#define BBIRD_MEMW_WRITE_ENABLE 0x00000040      /* Enable write cache */
#define BBIRD_MEMW_RGB_24       0x00000080      /* 24 -> 32 conversion */
#define BBIRD_MEMW_BIT_SWAP     0x00010000      /* Swap bits in each byte */
#define BBIRD_MEMW_BYTE_SWAP    0x00020000      /* Swap bytes in each word */
#define BBIRD_MEMW_WORD_SWAP    0x00040000      /* Swap words in each dword */
#define BBIRD_MEMW_MD_555       0x00000000      /* 555/565 mode switch */
#define BBIRD_MEMW_MD_565       0x00080000      /* 555/565 mode switch */
#define BBIRD_MEMW_CLR_CONVERT  0x00100000      /* Color space conversion on */
#define BBIRD_MEMW_YUV_422      0x00000000      /* 422 YUV source */
#define BBIRD_MEMW_YUV_444      0x00800000      /* 422 YUV source */
#define BBIRD_MEMW_READ_CACHE   0x80000000      /* Enable read cache */

#define BBIRD_MEMW_FLUSH(x)     (0x8000 | (x))  /* enable the flush count */
#define BBIRD_MEMW_FLUSH_MAX    0x03FF          /* max. flush count value */
#define BBIRD_MEMW_FLUSH_YCB    0x00000000      /* ???? */
#define BBIRD_MEMW_FLUSH_YCR    0x00010000      /* ???? */
#define BBIRD_MEMW_FLUSH_YUV    0x00010000      /* ???? */

#define BBIRD_MEMW_LUT_READ     0x00000100      /* LUT read enable bit */
#define BBIRD_MEMW_LUT_SELECT_U 0x00000200      /* Select U LUT */
#define BBIRD_MEMW_LUT_SELECT_V 0x00000000      /* Select V LUT */

/* IO Mapped Configuration Register Offsets */
#define BBIRD_OFFSET_RBASE_G    0x0000
#define BBIRD_OFFSET_RBASE_W    0x0004
#define BBIRD_OFFSET_RBASE_A    0x0008
#define BBIRD_OFFSET_RBASE_B    0x000C
#define BBIRD_OFFSET_RBASE_I    0x0010
#define BBIRD_OFFSET_RBASE_E    0x0014
#define BBIRD_OFFSET_ID         0x0018
#define BBIRD_OFFSET_CONFIG1    0x001C
#define BBIRD_OFFSET_CONFIG2    0x0020
#define BBIRD_OFFSET_SGR_CONFIG 0x0024
#define BBIRD_OFFSET_UNIQ       0x0024
#define BBIRD_OFFSET_SSWTCH     0x0028
#define BBIRD_OFFSET_M_INFO     0x002C
#define BBIRD_OFFSET_VGA_CTRL   0x0030

/* IO Memory Window registers */
#define BBIRD_OFFSET_MW1_CTRL   0x0040
#define BBIRD_OFFSET_MW1_AD     0x0044
#define BBIRD_OFFSET_MW1_SZ     0x0048
#define BBIRD_OFFSET_MW1_PGE    0x004C
#define BBIRD_OFFSET_MW1_ORG    0x0050
#define BBIRD_OFFSET_MW1_MSRC   0x0058
#define BBIRD_OFFSET_MW1_WKEY   0x005C
#define BBIRD_OFFSET_MW1_KYDAT  0x0060
#define BBIRD_OFFSET_MW1_MASK   0x0064

/* General purpose BIOS registers */
#define BBIRD_OFFSET_BIOS1      0x0068
#define BBIRD_OFFSET_BIOS2      0x006C
#define BBIRD_OFFSET_BIOS3      0x0070
#define BBIRD_OFFSET_BIOS4      0x0074

/* IO Mapped DAC registers */
#define BBIRD_OFFSET_DAC               0x0080
#define BBIRD_OFFSET_DAC_WR_ADDR       (BBIRD_OFFSET_DAC+BBIRD_DAC_WR_ADDR)
#define BBIRD_OFFSET_DAC_PAL_DAT       (BBIRD_OFFSET_DAC+BBIRD_DAC_PAL_DAT)
#define BBIRD_OFFSET_DAC_PEL_MASK      (BBIRD_OFFSET_DAC+BBIRD_DAC_PEL_MASK)
#define BBIRD_OFFSET_DAC_RD_ADDR       (BBIRD_OFFSET_DAC+BBIRD_DAC_RD_ADDR)
#define BBIRD_OFFSET_DAC_VPT_INDEX     (BBIRD_OFFSET_DAC+BBIRD_DAC_VPT_INDEX)
#define BBIRD_OFFSET_DAC_VPT_DATA      (BBIRD_OFFSET_DAC+BBIRD_DAC_VPT_DATA)
#define BBIRD_OFFSET_DAC_IBM528_IDXLOW (BBIRD_OFFSET_DAC+BBIRD_DAC_IBM528_IDXLOW)
#define BBIRD_OFFSET_DAC_IBM528_IDXHI  (BBIRD_OFFSET_DAC+BBIRD_DAC_IBM528_IDXHI)
#define BBIRD_OFFSET_DAC_IBM528_DATA   (BBIRD_OFFSET_DAC+BBIRD_DAC_IBM528_DATA)
#define BBIRD_OFFSET_DAC_IBM528_IDXCTL (BBIRD_OFFSET_DAC+BBIRD_DAC_IBM528_IDXCTL)
#define BBIRD_OFFSET_DAC_TI3026_INDEX  (BBIRD_OFFSET_DAC+0x28)
#define BBIRD_OFFSET_DAC_TI3026_DATA   (BBIRD_OFFSET_DAC)

/* Bus type defines */
/* These are the host bus types currently planned to be supported. */
#define BBIRD_BUS_IS_ISA         0x01
#define BBIRD_BUS_IS_EISA        0x02
#define BBIRD_BUS_IS_VL          0x03
#define BBIRD_BUS_IS_PCI         0x04
#define BBIRD_BUS_IS_PAWS        0x05

/* Structure Version Numbers */
/* Each structure must have its own version number to ensure that
   the data being read is interpreted correctly.
   These are the most current version numbers. */
#define BBIRD_FILE_VERSION       0x0100L
#define BBIRD_RES_VERSION        0x0100L
#define BBIRD_MODE_VERSION       0x0100L
#define BBIRD_BUS_VERSION        0x0100L
#define BBIRD_HARDWARE_VERSION   0x0100L
#define BBIRD_VIDEO_VERSION      0x0100L

/* DAC types */
#define BBIRD_DACTYPE_BT485             0x01
#define BBIRD_DACTYPE_BT484             0x02
#define BBIRD_DACTYPE_ATT491            0x03
#define BBIRD_DACTYPE_TIVPT             0x04
#define BBIRD_DACTYPE_TIVPTjr           0x05
#define BBIRD_DACTYPE_IBM528            0x09
#define BBIRD_DACTYPE_IBM524            0x0A
#define BBIRD_DACTYPE_TI3026            0x0B

/* Frequency Types */
#define BBIRD_FREQTYPE_ICD_2061A 0x01
#define BBIRD_FREQTYPE_ICD_2062  0x02

/* Structure's valid data flags */
/* These flags are set within the valid fields in the configuration file */
#define BBIRD_DATA_INVALID       0x0000L
#define BBIRD_DATA_VALID         0x0001L

/* Board selection commands */
#define BBIRD_DEFAULT_BOARD      (-1)

/* Programming defines */
#define BLACKBIRD_ENV            "BBIRD"  /* OS environment variable */
#define BLACKBIRD_CFG_FILE       "BBIRDCFG" /* CFG file name */

/* Macros to extract a major or minor version number from
   the entry within a structure. */
#define BBIRD_MAKEMAJORREV(x)    ((x & 0x0000FF00L)>>8)
#define BBIRD_MAKEMINORREV(x)    (x & 0x000000FFL)

#ifdef I3D
struct Blackbird_Engine
  {
/* This structure is identical to the drawing engine hardware registers */
        long    intrupt;                /* 0x00 */
        long    intrupt_mask;           /* 0x04 */
        long    flow;                   /* 0x08 */
        long    busy;                   /* 0x0C */
        long    xyw_adsz;               /* 0x10 */
        long    reserved_a1;            /* 0x14 */
        long    z_control;              /* 0x18 (unused) */
        long    reserved_a2;            /* 0x1C */
        long    buf_control;            /* 0x20 */
        long    reserved_z2;            /* 0x24 */
        long    src_origin;             /* 0x28 */
        long    dst_origin;             /* 0x2C */
        long    reserved_z3;            /* 0x30 */
        long    reserved_b;             /* 0x34 */
        long    tex_pitch;              /* 0x38 */
        long    zbuf_pitch;             /* 0x3C */
        long    src_pitch;              /* 0x40 */
        long    dst_pitch;              /* 0x44 */
        long    cmd;                    /* 0x48 */
        long    reserved_z5;            /* 0x4C */
        long    cmd_opcode;             /* 0x50 */
        long    cmd_raster_op;          /* 0x54 */
        long    cmd_style;              /* 0x58 */
        long    cmd_pattern;            /* 0x5C */
        long    cmd_clip;               /* 0x60 */
        long    cmd_swap;               /* 0x64 */
        long    foreground;             /* 0x68 */
        long    background;             /* 0x6C */
        long    plane_mask;             /* 0x70 */
        long    de_key;                 /* 0x74 */
        long    line_pattern;           /* 0x78 */
        long    pattern_ctrl;           /* 0x7C */
        long    clip_top_left;          /* 0x80 */
        long    clip_bottom_right;      /* 0x84 */

        long    xy0;                    /* 0x88 */
        long    xy1;                    /* 0x8C */
        long    xy2;                    /* 0x90 */
        long    xy3;                    /* 0x94 */
        long    xy4;                    /* 0x98 */
        long    xy5;                    /* 0x9C */
        long    reserved_x1;            /* 0xA0 */
        long    reserved_x2;            /* 0xA4 */
        long    reserved_x3;            /* 0xA8 */

        long    reserved_x4;            /* 0xAC */
        long    reserved_x5;            /* 0xB0 */

        long    reserved_x6;            /* 0xB4 */
        long    reserved_x7;            /* 0xB8 */
        long    reserved_x8;            /* 0xBC */
        long    reserved_x9;            /* 0xC0 */
        long    reserved_x10;           /* 0xC4 */
        long    reserved_x11;           /* 0xC8 */
        long    reserved_x12;           /* 0xCC */

        long    lod0_sh;                /* 0xD0 */
        long    lod1_sh;                /* 0xD4 */
        long    lod2_sh;                /* 0xD8 */
        long    lod3_sh;                /* 0xDC */
        long    lod4_sh;                /* 0xE0 */
        long    lod5_sh;                /* 0xE4 */
        long    lod6_sh;                /* 0xE8 */
        long    lod7_sh;                /* 0xEC */
        long    lod8_sh;                /* 0xF0 */
        long    lod9_sh;                /* 0xF4 */

        long    dl_addr;                /* 0xF8 */
        long    dl_cntrl;               /* 0xFC */

        long    z_org;                  /* 0x100 */

        long    lod0_org;               /* 0x104 */
        long    lod1_org;               /* 0x108 */
        long    lod2_org;               /* 0x10C */
        long    lod3_org;               /* 0x110 */
        long    lod4_org;               /* 0x114 */

        long    tpalorg;                /* 0x118 */
        long    hith;                   /* 0x11C */
        long    yon;                    /* 0x120 */
        long    fog_col;                /* 0x124 */
        long    alpha;                  /* 0x128 */
        long    reserved_n1;            /* 0x12C */
        long    reserved_n2;            /* 0x130 */
        long    reserved_n3;            /* 0x134 */
        long    reserved_n4;            /* 0x138 */
        long    reserved_n5;            /* 0x13C */
        long    reserved_n6;            /* 0x140 */
        long    reserved_n7;            /* 0x144 */
        long    reserved_n8;            /* 0x148 */
        long    reserved_n9;            /* 0x14C */
        long    reserved_n10;           /* 0x150 */
        long    reserved_n11;           /* 0x154 */
        long    reserved_n12;           /* 0x158 */
        long    reserved_n13;           /* 0x15C */
        long    reserved_n14;           /* 0x160 */
        long    reserved_n15;           /* 0x164 */
        long    cmd2;                   /* 0x168 */
        long    a_cntrl;                /* 0x16C */
        long    i3d_cntrl;              /* 0x170 */
        long    tex_cntrl;              /* 0x174 */

        long    cp0;                    /* 0x178 */
        float   cp1;                    /* 0x17C */
        float   cp2;                    /* 0x180 */
        float   cp3;                    /* 0x184 */
        float   cp4;                    /* 0x188 */
        long    cp5;                    /* 0x18C */
        long    cp6;                    /* 0x190 */
        float   cp7;                    /* 0x194 */
        float   cp8;                    /* 0x198 */
        float   cp9;                    /* 0x19C */
        float   cp10;                   /* 0x1A0 */
        float   cp11;                   /* 0x1A4 */
        float   cp12;                   /* 0x1A8 */
        long    cp13;                   /* 0x1AC */
        long    cp14;                   /* 0x1B0 */
        float   cp15;                   /* 0x1B4 */
        float   cp16;                   /* 0x1B8 */
        float   cp17;                   /* 0x1BC */
        float   cp18;                   /* 0x1C0 */
        float   cp19;                   /* 0x1C4 */
        float   cp20;                   /* 0x1C8 */
        long    cp21;                   /* 0x1CC */
        long    cp22;                   /* 0x1D0 */
        float   cp23;                   /* 0x1D4 */
        float   cp24;                   /* 0x1D8 */
        long    trigger;                /* 0x1DC */
        long    glblendc;               /* 0x1E0 */
        long    cp25;                   /* 0x1E4 */
        long    cp26;                   /* 0x1E8 */
        long    cp27;                   /* 0x1EC */
        long    cp28;                   /* 0x1F0 */
        long    cp29;                   /* 0x1F4 */
        long    cp30;                   /* 0x1F8 */
        long    reserved_o2;            /* 0x1FC */
  };
#else   /* !I3D */
struct Blackbird_Engine
  {
/* This structure is identical to the drawing engine hardware registers */
        long    intrupt;                /* 0x00 */
        long    intrupt_mask;           /* 0x04 */
        long    flow;                   /* 0x08 */
        long    busy;                   /* 0x0C */
        long    xyw_adsz;               /* 0x10 */
        long    reserved_a1;            /* 0x14 */
        long    z_control;              /* 0x18 */
        long    reserved_a2;            /* 0x1C */
        long    buf_control;            /* 0x20 */
        long    page;                   /* 0x24 */
        long    src_origin;             /* 0x28 */
        long    dst_origin;             /* 0x2C */
        long    msk_source;             /* 0x30 */
        long    reserved_b;             /* 0x34 */
        long    key;                    /* 0x38 */
        long    key_data;               /* 0x3C */
        long    src_pitch;              /* 0x40 */
        long    dst_pitch;              /* 0x44 */
        long    cmd;                    /* 0x48 */
        long    cmd_shade;              /* 0x4C */
        long    cmd_opcode;             /* 0x50 */
        long    cmd_raster_op;          /* 0x54 */
        long    cmd_style;              /* 0x58 */
        long    cmd_pattern;            /* 0x5C */
        long    cmd_clip;               /* 0x60 */
        long    cmd_swap;               /* 0x64 */
        long    foreground;             /* 0x68 */
        long    background;             /* 0x6C */
        long    plane_mask;             /* 0x70 */
        long    rop_mask;               /* 0x74 */
        long    line_pattern;           /* 0x78 */
        long    pattern_ctrl;           /* 0x7C */
        long    clip_top_left;          /* 0x80 */
        long    clip_bottom_right;      /* 0x84 */

        long    xy0;                    /* 0x88 */
        long    xy1;                    /* 0x8C */
        long    xy2;                    /* 0x90 */
        long    xy3;                    /* 0x94 */
        long    xy4;                    /* 0x98 */
        long    xy5;                    /* 0x9C */
        long    xy6;                    /* 0xA0 */
        long    xy7;                    /* 0xA4 */
        long    xy8;                    /* 0xA8 */

        long    hither;                 /* 0xAC */
        long    yon;                    /* 0xB0 */

        long    z0;                     /* 0xB4 */
        long    z1;                     /* 0xB8 */
        long    z2;                     /* 0xBC */
        long    z3;                     /* 0xC0 */
        long    z4;                     /* 0xC4 */
        long    z5;                     /* 0xC8 */

        long    color0;                 /* 0xCC */
        long    color1;                 /* 0xD0 */
        long    color2;                 /* 0xD4 */
        long    color3;                 /* 0xD8 */
        long    color4;                 /* 0xDC */
        long    color5;                 /* 0xE0 */
        long    color6;                 /* 0xE4 */
        long    color7;                 /* 0xE8 */
        long    color8;                 /* 0xEC */

        long    reserved_d;             /* 0xF0 */
        long    reserved_e;             /* 0xF4 */
        long    dl_addr;                /* 0xF8 */
        long    dl_cntrl;               /* 0xFC */
  };
#endif  /* !I3D */

struct Blackbird_Copy_Engine
  {
/* This structure is identical to the copy engine hardware registers */
        long    intrupt;                /* 0x00 */
        long    intrupt_mask;           /* 0x04 */
        long    flow;                   /* 0x08 */
        long    busy;                   /* 0x0C */
        long    reserved_c1;            /* 0x10 */
        long    reserved_a1;            /* 0x14 */
        long    reserved_c2;            /* 0x18 */
        long    reserved_a2;            /* 0x1C */
        long    buf_control;            /* 0x20 */
        long    page;                   /* 0x24 */
        long    src_origin;             /* 0x28 */
        long    dst_origin;             /* 0x2C */
        long    msk_source;             /* 0x30 */
        long    reserved_b;             /* 0x34 */
        long    reserved_c3;            /* 0x38 */
        long    reserved_c4;            /* 0x3C */
        long    src_pitch;              /* 0x40 */
        long    dst_pitch;              /* 0x44 */
        long    cmd;                    /* 0x48 */
        long    reserved_c;             /* 0x4C */
        long    cmd_opcode;             /* 0x50 */
        long    reserved_c5;            /* 0x54 */
        long    cmd_interpolate;        /* 0x58 */
        long    reserved_c7;            /* 0x5C */
        long    cmd_clip;               /* 0x60 */
        long    reserved_c8;            /* 0x64 */
        long    reserved_c9;            /* 0x68 */
        long    reserved_ca;            /* 0x6C */
        long    plane_mask;             /* 0x70 */
        long    reserved_cb;            /* 0x74 */
        long    reserved_cc;            /* 0x78 */
        long    reserved_cd;            /* 0x7C */
        long    clip_top_left;          /* 0x80 */
        long    clip_bottom_right;      /* 0x84 */

        long    xy0;/* Source */        /* 0x88 */
        long    xy1;/* Destination */   /* 0x8C */
        long    xy2;/* Extents */       /* 0x90 */
        long    xy3;/* Reserved */      /* 0x94 */
        long    xy4;/* Zoom factors */  /* 0x98 */
  };

struct Blackbird_Memwin
  {
/* This structure is identical to the memory window hardware registers */
        long    control;
        long    address;
        long    size;
        long    page;
        long    origin;
        long    RESERVED;
        long    msk_source;
        long    key;
        long    key_data;
        long    plane_mask;

        /* The following are accessible ONLY from bbird_info.memwins[1] */
        long    flush_count;
        long    flush_trigger;
        long    yuv_address;
        long    yuv_data;
        long    mw_control;
  };

struct Blackbird_Syncs
  {
/* This structure is identical to the display engine hardware registers */
        long    int_vcount;
        long    int_hcount;
        long    address;
        long    pitch;
        long    h_active;
        long    h_blank;
        long    h_front_porch;
        long    h_sync;
        long    v_active;
        long    v_blank;
        long    v_front_porch;
        long    v_sync;
        long    line_count;	/* border; */
        long    zoom;
        long    config_1;
        long    config_2;
  };

struct Blackbird_Global
  {
/* This structure is identical to the global hardware registers */
        char                            dac_regs[8 * 4];

        struct Blackbird_Syncs          syncs;
        char                            Reserved[48];
        char                            new_dac_regs[16 * 4];
  };

struct Blackbird_IO
  {
        /* This structure is identical to the Blackbird IO hardware registers */
        long    rbase_g;
        long    rbase_w;
        long    rbase_a;
        long    rbase_b;
        long    rbase_i;
        long    rbase_e;
        long    id;
        long    config1;
        long    config2;
        long    LID;
        long    soft_switch;
        long    m_info;
        long    vga_ctrl;
        long    bios[4];
  };

struct Blackbird_Interrupts
  {
/* This structure is identical to the global interrupt hardware registers */
        long    bbird_interrupt;
        long    bbird_interrupt_mask;

        long    Reserved[30];

        struct Blackbird_IO bbird_global_ctrl;
  };

struct Memory_Window_Info
  {
        char    FAR *pointer;
        long    physical_host_address;
        long    length;
  };

struct Blackbird_Info
  {
        /* Addresses of register blocks */
        struct Blackbird_Engine         volatile FAR *engine_a;
        struct Blackbird_Engine         volatile FAR *engine_b;
        struct Blackbird_Memwin         volatile FAR *memwins[2];
        struct Blackbird_Global         volatile FAR *global;
        struct Blackbird_Interrupts     volatile FAR *global_int;

        /* Memory Window Information */
        struct Memory_Window_Info       xy_win[2];
        struct Memory_Window_Info       memwin[2];

        /* Memory sizes */
        long                            Disp_size;
        long                            Virt_size;
        long                            Mask_size;

        /* Board hardware configuration */
        long                            max_pixel_rate;
        long                            hard_flags;
        long                            crystal_rate;
        long                            Blackbird_ID;
        long                            video_flags;

        /* More junk ... */
        long                            IO_Address;
        struct Blackbird_IO             IO_Regs;
  };

#define  FILE_NAME_SIZE       16

struct Blackbird_Mode
  {
        /* Sync parameters */
        long    version;
        char    driver_name[FILE_NAME_SIZE];
        long    VESA_mode;
        long    board_dept_offset;    /* resolution dependent registers  */
        long    display_flags;
        long    config_1;
        long    config_2;
        long    clock_frequency;
        long    clock_numbers;
        long    display_start;  /*****/
        short   bitmap_width;   /*****/
        short   bitmap_height;  /*****/
        short   bitmap_pitch;   /*****/
        short   selected_depth; /*****/
        short   display_x;
        short   display_y;
        short   h_active;
        short   h_blank;
        short   h_front_porch;
        short   h_sync;
        short   v_active;
        short   v_blank;
        short   v_front_porch;
        short   v_sync;
        short   border;
        short   y_zoom;
        short   max_depth;
        short   Reserved[33];
  };

/* The Blackbird file contains only one mode entry for each resolution.  For
example, if we were to support 512x512, 640x480, 800x600, 1024x768, 1152x870,
1280x1024, 1536x1152, and 1600x1200,  there would be only eight entries in
the file.
*/

struct Blackbird_File
  {
        long    file_id;
        long    version;
        long    default_board_flag;  /* is this board the default? */
        long    next_board;          /* start of next file header */
        long    offset_resolution;
        long    offset_bus_info;
        long    offset_hardware;
        long    offset_video;
        long    reserved[20];
  };

/* #define      BBIRD_FILE_ID   0x99429971 */   /* Number Nine ID */
#define BBIRD_FILE_ID   (0x31375253L)   /* Number Nine ID */

struct Blackbird_File_Resolution
  {
        long    version;
        long    num_modes;
        long    default_mode;
        long    mode_size;
        long    mode_offset;
        long    num_vesa;
        long    offset_vesa;
        long    reserved[18];
  };

struct Blackbird_File_Bus
  {
        long    version;
        long    valid;
        long    type;
        long    IO_address;
        long    VL_mem_address;
        long    VL_mem_size;
        long    PCI_dev_number;
        long    reserved[20];
  };

struct Blackbird_File_Hardware
  {
        long    version;
        long    valid;
        long    DAC_type;
        long    freq_synth;
        long    disp_size;
        long    virt_size;
        long    mask_size;
        long    DAC_speed_max;
        long    internal_bus_width;
        long    processor_id;
        long    color_format;
        long    mclock_numbers;
        long    reserved[16];
  };

struct Blackbird_File_VESA
   {
   long  version;
   long  pixel_frequency;
   long  clock_numbers;
   short refresh_rate;
   short display_x;
   short display_y;
   short bitmap_bpp;
   short h_total;
   short h_active;
   short h_border;
   short h_blank;
   short h_front_porch;
   short h_sync;
   short v_total;
   short v_active;
   short v_border;
   short v_blank;
   short v_front_porch;
   short v_sync;
   short m_value;
   short n_value;
   short display_flags;
   short Reserved[9];
   };

/* #define   SIZEVESA           sizeof (struct Blackbird_File_VESA) */

struct Blackbird_File_Video
  {
        long    version;
        long    valid;
        long    reserved[62];
  };

/* Low-level Blackbird flags */

/* ID flag */
#define BBIRD_ID_REVISION       0x00000007
#define BBIRD_ID_BUS_BITS       0x00000018
#define BBIRD_ID_BUS_PCI        0x00000000
#define BBIRD_ID_BUS_VL         0x00000008
#define BBIRD_ID_BUS_WIDTH      0x00000020
#define BBIRD_ID_PCI_BASE0      0x000000C0
#define BBIRD_ID_DISP_BITS      0x00000300
#define BBIRD_ID_DISP_NONE      0x00000000
#define BBIRD_ID_DISP_256KxN    0x00000100
#define BBIRD_ID_DISP_2_BANKS   0x00000400
#define BBIRD_ID_PCI_BASE1      0x00001800
#define BBIRD_ID_PCI_BASE2      0x00006000
#define BBIRD_ID_DATA_BUS_SIZE  0x00008000
#define BBIRD_ID_VIRT_BITS      0x00030000
#define BBIRD_ID_VIRT_NONE      0x00000000
#define BBIRD_ID_VIRT_256KxN    0x00010000
#define BBIRD_ID_VIRT_1MxN      0x00020000
#define BBIRD_ID_VIRT_2_BANKS   0x00040000
#define BBIRD_ID_PCI_BASE3      0x00180000
#define BBIRD_ID_PCI_BASE_ROM   0x00E00000
#define BBIRD_ID_MASK_BITS      0x03000000
#define BBIRD_ID_MASK_NONE      0x00000000
#define BBIRD_ID_MASK_256KxN    0x01000000
#define BBIRD_ID_MASK_1MxN      0x02000000
#define BBIRD_ID_RAS_PULSE      0x04000000
#define BBIRD_ID_VGA_SNOOP      0x08000000
#define BBIRD_ID_PCI_CLASS_BITS 0x30000000
#define BBIRD_ID_PCI_CLASS_VGA  0x00000000
#define BBIRD_ID_PCI_CLASS_XGA  0x10000000
#define BBIRD_ID_PCI_CLASS_OTHR 0x20000000
#define BBIRD_ID_PCI_CLASS_OTH2 0x30000000
#define BBIRD_ID_PCI_EPROM_ENAB 0x40000000
#define BBIRD_ID_PCI_RSVD       0x80000000

/* Config register 1 */
#define BBIRD_C1_VGA_SHADOW     0x00000001
#define BBIRD_C1_RESET          0x00000002
#define BBIRD_C1_WIDTH_128      0x00000004
#define BBIRD_C1_VGA_SNOOP      0x00000008
#define BBIRD_C1_PCI_IRQ        0x00000010
#define BBIRD_C1_ENABLE_GLOBAL  0x00000100
#define BBIRD_C1_ENABLE_MEMWIN  0x00000200
#define BBIRD_C1_ENABLE_DRAW_A  0x00000400
#define BBIRD_C1_ENABLE_DRAW_B  0x00000800
#define BBIRD_C1_ENABLE_INT     0x00001000
#define BBIRD_C1_ENABLE_EPROM   0x00002000
#define BBIRD_C1_ENABLE_MEMWIN0 0x00010000
#define BBIRD_C1_ENABLE_MEMWIN1 0x00020000
#define BBIRD_C1_ENABLE_XY_A    0x00100000
#define BBIRD_C1_ENABLE_XY_B    0x00200000
#define BBIRD_C1_PRIORITY_BITS  0xFF000000
#define BBIRD_C1_PRI_HOST(x)    ((long)((x) & 3) << 24)
#define BBIRD_C1_PRI_VIDEO(x)   ((long)((x) & 3) << 26)
#define BBIRD_C1_PRI_A(x)       ((long)((x) & 3) << 28)
#define BBIRD_C1_PRI_B(x)       ((long)((x) & 3) << 30)
#define BBIRD_C1_PRI_LOW        0
#define BBIRD_C1_PRI_MED        1
#define BBIRD_C1_PRI_HI         2

/* Config register 2 */
#define BBIRD_C2_DATA_WAIT(x)   (long)((x) & 3)
#define BBIRD_C2_EDO            0x00000004      /* Generate EDO timing */
#define BBIRD_C2_JV             0x00000008      /* Joint VRAM transfers */
#define BBIRD_C2_RCD            0x00000010      /* RAS to CAS delay (EDO) */
#define BBIRD_C2_REFCNT_768     0x00000000      /* refresh rate in mclocks */
#define BBIRD_C2_REFCNT_1024    0x00000020
#define BBIRD_C2_REFCNT_1280    0x00000040
#define BBIRD_C2_REFCNT_3584    0x00000060
#define BBIRD_C2_IV             0x00000080      /* Enable internal VGA */
#define BBIRD_C2_EPROM_WAIT(x)  ((long)((x) & 0xF) << 8)
#define BBIRD_C2_DAC_WAIT(x)    ((long)((x) & 0x7) << 16)
#define BBIRD_C2_BUFFER_ENABLE  0x00100000      /* Enable Display Memory */
#define BBIRD_C2_REFRESH_DISAB  0x00200000      /* Memory refresh disable */
#define BBIRD_C2_DELAY_SAMPLE   0x00400000      /* Delay data during read */
#define BBIRD_C2_MEMORY_SKEW    0x00800000      /* Skew memory control */
#define BBIRD_C2_FAST_BACK      0x01000000      /* Fast back-to back signals */
#define BBIRD_C2_RESERVED       0x40000000      /* Reserved switch */
#define BBIRD_C2_SLOW_DAC       0x80000000      /* Dac speed < 175MHz */

/* VGA control register bits */
#define BBIRD_VGA_MEM_MUX       0x00000001      /* VGA can draw in memory */
#define BBIRD_VGA_DECODE        0x00000002      /* VGA decodes PCI cycles */
#define BBIRD_VGA_VID_MUX       0x00000004      /* VGA display active */
#define BBIRD_VGA_MEM_ENABLE    0x00000008      /* VGA decodes A or B memory */
#define BBIRD_VGA_BUF_SELECT    0x00000010      /* VGA uses Virtual buffer */
#define BBIRD_VGA_STRETCH       0x00000020      /* Stretch reads to 4 clocks */
#define BBIRD_VGA_SH_3C2        0x00000040      /* VGA reg 3C2 is shadowed */
#define BBIRD_VGA_DAC_DECODE    0x00000080      /* VGA decodes DAC cycles */
#define BBIRD_VGA_OFFSET_MASK   0x0000FF00      /* Offset into memory to VGA */

#define BBIRD_VGA_DEFAULT       0x0000008F      /* Default value for VGA */

/* Global interrupt register (read only) */
#define BBIRD_GINT_VB           0x00000001      /* Vertical blank */
#define BBIRD_GINT_HB           0x00000002      /* Horizontal blank */
#define BBIRD_GINT_ENGINE_A     0x00000100      /* Engine A op complete */
#define BBIRD_GINT_CLIP_A       0x00000200      /* Engine A clip */
#define BBIRD_GINT_Z_OVERFLOW   0x00000400      /* Engine A Z overflow */
#define BBIRD_GINT_Z_UNDERFLOW  0x00000800      /* Engine A Z underflow */
#define BBIRD_GINT_YON          0x00001000      /* Engine A yon interrupt */
#define BBIRD_GINT_HITHER       0x00002000      /* Engine A hither interrupt */
#define BBIRD_GINT_ENGINE_B     0x00010000      /* Engine B op complete */
#define BBIRD_GINT_CLIP_B       0x00020000      /* Engine B clip */
#define BBIRD_GINT_VIDEO(x)     (1L << ((x) + 24))

/* Global interrupt mask (read/write) */
#define BBIRD_GINT_VB_MASK      0x00000001
#define BBIRD_GINT_HB_MASK      0x00000002
#define BBIRD_GINT_CE_MASK      0x00000004
#define BBIRD_GINT_GLOBAL_MASK  0x00010000

/* DAC register defines */
#define BBIRD_DAC_WR_ADDR       0
#define BBIRD_DAC_PAL_DAT       4
#define BBIRD_DAC_PEL_MASK      8
#define BBIRD_DAC_RD_ADDR       12
#define BBIRD_DAC_RSVD1         16
#define BBIRD_DAC_RSVD2         20
#define BBIRD_DAC_VPT_INDEX     24
#define BBIRD_DAC_VPT_DATA      28
#define BBIRD_DAC_IBM528_IDXLOW 16
#define BBIRD_DAC_IBM528_IDXHI  20
#define BBIRD_DAC_IBM528_DATA   24
#define BBIRD_DAC_IBM528_IDXCTL 28
#define BBIRD_DAC_TI3026_INDEX  0
#define BBIRD_DAC_TI3026_DATA   152

/* CRT Zoom factors */
#define BBIRD_CRT_NO_Y_ZOOM     0x00000000
#define BBIRD_CRT_Y_ZOOM(x)     ((x) - 1)       /* x between 1 and 16 */

/* CRT configuration register 1 */
#define BBIRD_CRT_C1_POS_HSYNC  0x00000001
#define BBIRD_CRT_C1_POS_VSYNC  0x00000002
#define BBIRD_CRT_C1_COMP_SYNC  0x00000004
#define BBIRD_CRT_C1_INTERLACED 0x00000008
#define BBIRD_CRT_C1_HSYNC_ENBL 0x00000010
#define BBIRD_CRT_C1_VSYNC_ENBL 0x00000020
#define BBIRD_CRT_C1_VIDEO_ENBL 0x00000040
#define BBIRD_CRT_C1_SCLK_DIR   0x00000100

/* CRT configuration register 2 */
#define BBIRD_CRT_C2_DISP_256K  0x00000001      /* Not used */
#define BBIRD_CRT_C2_VSHIFT_4K  0x00000000
#define BBIRD_CRT_C2_VSHIFT_2K  0x00000002
#define BBIRD_CRT_C2_VSHIFT_8K  0x00000004
#define BBIRD_CRT_C2_REFRESH    0x00000100
#define BBIRD_CRT_C2_XFER_DELAY(x)      ((long)((x) & 0x7) << 16)
#define BBIRD_CRT_C2_SPLIT_XFER 0x01000000
#define BBIRD_CRT_C2_DRAM_ON    0x20000000
#define BBIRD_CRT_C2_DRAM_VIRT  0x30000000


/* Selcted examples of library entries: */

/* Global variables */
extern struct Blackbird_Engine  volatile FAR *bbird_engine;
extern struct Blackbird_Engine  volatile FAR *bbird_copy_engine;
extern struct Blackbird_Info    bbird_info;
extern struct Blackbird_File_Resolution bbird_resolutions;
extern CfgFileHardware          bbird_hardware;

#if     PROTOTYPES
/* System Setup Functions */

int   bbird_init(int);
int   bbird_ioaddr(void);
int   bbird_get_mode(struct Blackbird_Mode FAR *, int, int, char FAR *);
void  bbird_set_mode(struct Blackbird_Mode FAR *, int);
int   bbird_modify_mode(struct Blackbird_Mode FAR *, double, int, char FAR *);
void  bbird_set_engine(short);
void  bbird_log(int);
long  bbird_calc_clock(long);

/* Basic Drawing Functions */
void  bbird_msk_bitmap(long);
void  bbird_src_bitmap(long, long, long);
void  bbird_dst_bitmap(long, long, long, short, short, short, short);
void  bbird_flags(long, long, long, long);
void  bbird_colors(long, long, long, long);
void  bbird_line_pat(long, long);
void  bbird_line(short, short, short, short);
void  bbird_box(short, short, short, short);

void  bbird_eline(short, short, short, short, short, short, short, short);
void  bbird_bitblit(short, short, short, short, short, short, long, long);
void  bbird_triangle(short, short, short, short, short, short, short, short);
void  bbird_quad(short, short, short, short, short, short, short, short, short);
void  bbird_trapezoid(short, short, short, short, short, short, short, short,
                      short, short, short, short);
void  bbird_3d_flags(long, long, long, long, long);
void  bbird_3d_trapezoid(short, short, short, short, long,
                         long, long, long, long, long, long, long, long,
                         long, long, long, long, long, long, long, long,
                         long, long, long);
void  bbird_3d_triangle(int, int, float, float, float, int, int, 
                        int, float, float, float, int, int, int, 
                        float, float, float, int, int, int);
void  bbird_3d_line(short, short, short, short, short, short,
                    short, short, short, short, short, short);
void  bbird_bitmap_read(long FAR *, long, short, short, short, short,
                        short, short);
void  bbird_set_cache(long FAR *, short, short);
int   bbird_bitmap_write(long FAR *, long, short, short, short, short, short,
                   short, short);
void  bbird_engine_wait(int);

/* Memory Window Function */
int   bbird_memxfer_setup(short, long, long, long, long, long);

/* Shortcut Drawing Functions */
void  bbird_save_engine_state(struct Blackbird_Engine FAR *);
void  bbird_restore_engine_state(struct Blackbird_Engine FAR *);
long  bbird_read_pixel(short, short);
void  bbird_write_pixel(short, short, long);
void  bbird_rectangle(short, short, short, short);
void  bbird_hline(short, short, short);
void  bbird_vline(short, short, short);
void  bbird_oval(short, short, short, short);
void  bbird_polyline(long, short FAR *);
void  bbird_polygon(long, short FAR *, short, short);
void  bbird_clip_region(short, long, short FAR *, long, short FAR *);  
void  bbird_area_pattern(long FAR *, short, short, long);
void  bbird_set_bit_pattern(long FAR *, long, short, short, short,
                            short, short);
void  bbird_patcopy(short, short, short, short, short, short, short);
void  bbird_clear_bitmap(long);
#else   /* PROTOTYPES */
/* System Setup Functions */

int   bbird_init();
int   bbird_get_mode();
void  bbird_set_mode();
int   bbird_modify_mode();
void  bbird_set_engine();
void  bbird_log();
long  bbird_calc_clock();

/* Basic Drawing Functions */
void  bbird_msk_bitmap();
void  bbird_src_bitmap();
void  bbird_dst_bitmap();
void  bbird_flags();
void  bbird_colors();
void  bbird_line_pat();
void  bbird_line();
void  bbird_eline();
void  bbird_bitblit();
void  bbird_triangle();
void  bbird_quad();
void  bbird_trapezoid();
void  bbird_equad();
void  bbird_bitmap_read();
void  bbird_set_cache();
int   bbird_bitmap_write();
void  bbird_engine_wait();

/* Memory Window Function */
int   bbird_memxfer_setup();

/* Shortcut Drawing Functions */
void  bbird_save_engine_state();
void  bbird_restore_engine_state();
long  bbird_read_pixel();
void  bbird_write_pixel();
void  bbird_rectangle();
void  bbird_hline();
void  bbird_vline();
void  bbird_oval();
void  bbird_polyline();
void  bbird_polygon();
void  bbird_clip_region();  
void  bbird_area_pattern();
void  bbird_set_bit_pattern();
void  bbird_patcopy();
void  bbird_clear_bitmap();
#endif  /* PROTOTYPES */

#define makexy(x, y)    (((long)(x) << 16) | (y))

#define bbird_log(x)            /* This should do nothing */
#define vlogreg(reg, val)       /* This should do nothing */
#define vlogcrt(x, y)           /* This should do nothing */
#define vlog1(a)                /* This should do nothing */
#define vlog2(a, b)             /* This should do nothing */
#define vlog3(a, b, c)          /* This should do nothing */
#define vlog4(a, b, c, d)       /* This should do nothing */
#define vlog5(a, b, c, d, e)    /* This should do nothing */

#define bbird_set_engine(flag)  { \
        if ((flag) == BBIRD_SELECT_ENGINE_A) \
          bbird_engine = bbird_info.engine_a; \
        else if ((flag) == BBIRD_SELECT_ENGINE_B) \
          bbird_engine = bbird_info.engine_b; \
                                }

#ifdef  DEBUG
#define CANCEL  if (kbhit()) exit(2)
#else   /* !DEBUG */
#define CANCEL
#endif  /* !DEBUG */

#define bbird_engine_wait(x)    switch (x) {                                 \
          case BBIRD_WAIT_READY:                                             \
                while (bbird_engine->busy) CANCEL;                           \
                break;                                                       \
          case BBIRD_WAIT_IDLE:                                              \
                while (bbird_engine->flow & 1) CANCEL;                       \
                break;                                                       \
          case BBIRD_WAIT_PREVIOUS:                                          \
                while (bbird_engine->flow & 8) CANCEL;                       \
                break;                                                       \
          case BBIRD_WAIT_CACHE:                                             \
                while (bbird_engine->buf_control & BBIRD_FLAG_CACHE_READY)   \
                  CANCEL;                                                    \
                break;                                                       \
          case BBIRD_WAIT_DONE:                                              \
          default:                                                           \
                while (bbird_engine->flow & 3) CANCEL;                       \
                break;                                                       \
                                           }

#define bbird_cache_trigger()   { \
      bbird_engine->buf_control |= BBIRD_FLAG_CACHE_READY; \
      vlogreg("BUF_CTRL", bbird_engine->buf_control); \
                                }

#if DOS_COMPILE | WINDOWS_COMPILE
#define DEFAULT_PATHNAME        "C:\\NUMBER9"
#endif /* DOS_COMPILE | WINDOWS_COMPILE */
#if UNIX_COMPILE
#define DEFAULT_PATHNAME        "/usr/lib/number9/bb.cfg"
#endif  /* UNIX_COMPILE */
