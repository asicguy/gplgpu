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
 *  File        :  cfgfile.h
 *  Author      :  Frank Bruno
 *  Created     :  14-May-2011
 *  RCS File    :  $Source:$
 *  Status      :  $Id:$
 *
 ******************************************************************************
 *
 *  Description : 
 *
 *  This file is a set of common defines and structure definitions 
 *  used by all configuration include file.                        
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

#define DEFAULT_CFG_DIRECTORY       "C:\\"
#define DEFAULT_CFG_NAME            "NUMBER9"

/* Entries in the SYSTEM.INI file for the location of items. */
#define SECTION_NAME          "Imagine-128"     /* section containing entries */
#define CFG_PATH_ENTRY        "CFG"
#define HAWKEYE_PATH_ENTRY    "HawkEye"

#define  ENV_VAR              CFG_PATH_ENTRY  /* "NUMBER9" */
#define  MAX_BOARD_NAME       9

#define  FILE_NAME_SIZE       16

#ifndef FALSE
#define  FALSE                0
#endif

#ifndef TRUE
#define  TRUE                 !FALSE
#endif

/*  used to create unique variable names for each include file  */
#define   CAT(x, y)           x ## y
#define  XCAT(x, y)           CAT(x,y)

/* DAC types */
#define  DACTYPE_BT485        0x01
#define  DACTYPE_BT484        0x02
#define  DACTYPE_ATT491       0x03
#define  DACTYPE_TIVPT        0x04
#define  DACTYPE_TIVPTjr      0x05
#define  DACTYPE_ATT498       0x06
#define  DACTYPE_IBM528       0x09
#define  DACTYPE_IBM524       0x0A
#define  DACTYPE_TI3026       0x0B

/* Frequency Types */
#define  FREQTYPE_ICD_2061A   0x01
#define  FREQTYPE_ICD_2062    0x02

/* Bus type defines */
/* These are the host bus types currently planned to be supported. */
#define  BUS_IS_ISA           0x01
#define  BUS_IS_EISA          0x02
#define  BUS_IS_VL            0x03
#define  BUS_IS_PCI           0x04
#define  BUS_IS_PAWS          0x05

/* Structure's valid data flags */
/* These flags are set within the valid fields in the configuration file */
#define  DATA_INVALID         0x0000L
#define  DATA_VALID           0x0001L

/* Board selection commands */
#define  DEFAULT_BOARD        (-1)

/* Macros to extract a major or minor version number from
   the entry within a structure. */
#define  MAKEMAJORREV(x)      ((x & 0x0000FF00L)>>8)
#define  MAKEMINORREV(x)      (x & 0x000000FFL)

/*  display flags  */
#define  DEFAULT_NONVIRTUAL   0x0001   /* If not virtual display use this */
#define  DISPLAY_AS_VIRTUAL   0x0002   /* Display bitmap as virtual */
#define  DISPLAY_PIPE         0x0004   /* Display is going through chip */
#define  DONOT_MODIFY_DRIVER  0x0008   /* don't modify the driver name */
#define  CLOCK_DOUBLING       0x0010   /* clock doubling is performed */
#define  HORIZONTAL_HALVED    0x0020   /* horz values need to be halved */
#define  DISPLAY_CURSDBL      0x0040   /* double cursor position on zoom */
#define  USING_RAW_PIXEL_RATE 0x0080   /* pixel rate is not halved if doubling */
#define  SYNC_ON_GREEN        0x0100   /* Our old friend... */
#define  NEGATIVE_V_SYNC      0x0000   /* Our old friend... */
#define  NEGATIVE_H_SYNC      0x0000   /* Our old friend... */
#define  POSITIVE_V_SYNC      0x0200   /* Our old friend... */
#define  POSITIVE_H_SYNC      0x0400   /* Our old friend... */
#define  COMPOSITE_SYNC       0x0800   /* Our old friend... */

#define  FLAT_PANEL           0x1000   /* Use flat panel display */
#define  FLAT_PANEL_ZOOM      0x3000   /* Use zoom on flat panel */

/* hardware flags */

/* for color_format */
#define CLRFMT_16BPP_IS565    0x0001   /* 16bpp is 565, else 555 */
#define CLRFMT_32BPP_ISRGBO   0x0002   /* 32bpp formats */
#define CLRFMT_32BPP_IS0RGB   0x0004   /* R = Red, G = Green */
#define CLRFMT_32BPP_ISOBGR   0x0008   /* B = Blue, O = overlay or other */


typedef struct
   {
   long  file_id;
   char  file_name[FILE_NAME_SIZE];
   long  version;
   long  default_flag;       /* is this board the default? */
   long  offset_next_board;  /* start of next file header */
   long  offset_resolution;
   long  offset_bus_info;
   long  offset_hardware;
   long  offset_video;
   long  reserved[20];
   } CfgFileHeader;

#define   SIZEHEADER          sizeof (CfgFileHeader)

typedef struct
   {
   long  version;
   long  num_modes;
   long  default_mode;
   long  size_mode;
   long  offset_mode;
   long  num_vesa;
   long  offset_vesa;
   long  reserved[18];
   } CfgFileResolution;

#define   SIZERESOLUTION      sizeof (CfgFileResolution)

typedef struct
   {
   /* display and bitmap parameters */
   long  version;
   char  driver_name[FILE_NAME_SIZE];
   long  VESA_mode;
   long  board_dept_offset;    /* resolution dependent registers  */
   long  display_flags;
   long  config_1;
   long  config_2;
   long  pixel_frequency;
   long  clock_numbers;
   long  display_start;
   short bitmap_width;
   short bitmap_height;
   short bitmap_pitch;
   short bitmap_bpp;
   short display_x;
   short display_y;
   short h_active;
   short h_blank;
   short h_front_porch;
   short h_sync;
   short v_active;
   short v_blank;
   short v_front_porch;
   short v_sync;
   short border;
   short y_zoom;
   short max_depth;
   short h_total;
   short v_total;
   short Reserved[31];
   } CfgFileMode;

#define   SIZEMODE            sizeof (CfgFileMode)

typedef struct
   {
   long  version;
   long  valid;
   long  bus_type;
   long  IO_address;
   long  VL_mem_address;
   long  VL_mem_size;
   long  PCI_dev_number;
   long  reserved[20];
   } CfgFileBus;

#define   SIZEBUS             sizeof (CfgFileBus)


typedef struct
   {
   long  version;
   long  valid;
   long  DAC_type;
   long  freq_synth;
   long  disp_size;
   long  virt_size;
   long  mask_size;
   long  DAC_speed_max;
   long  internal_bus_width;
   long  processor_id;
   long  color_format;
   long  mclock_numbers;
   long  reserved[16];
   } CfgFileHardware;

#define   SIZEHARDWARE        sizeof (CfgFileHardware)


typedef struct
   {
   long  version;
   long  valid;
   long  reserved[62];
   } CfgFileVideo;

#define   SIZEVIDEO           sizeof (CfgFileVideo)

typedef struct
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
   } CfgFileVESA;

#define   SIZEVESA           sizeof (CfgFileVESA)

typedef struct
   {
   CfgFileHeader     * pHeader;
   CfgFileResolution * pResolution;
   CfgFileMode       * pMode_table;
   CfgFileBus        * pBus;
   CfgFileHardware   * pHardware;
   CfgFileVideo      * pVideo;
   CfgFileVESA       * pVESA_syncs;
   } CfgFileStruct;


/* Structures for data stream processing. */
/* IOW how the GXE64 driver interprets the stream. */
struct CfgStreamCmd
   {
   unsigned char opCode;   /* the operation to perform */
   unsigned char value;    /* the data value */
   unsigned short IOaddr;  /* the IO address */
   };
typedef union
   {
   unsigned long lData;    /* data as a raw long */
   struct CfgStreamCmd cmd;/* the command and data breakdown */
   } CfgDataStream;

#define SIZEDATASTREAM        sizeof(CfgDataStream)

/* These are the commands which can be placed */
/* within CfgDataStream.cmd.opCode */
#define DS_INSERTVALUE        0  /* blasts the value in (IO value ignored) */
#define DS_ANDVALUE           1  /* ands data with IO port */
#define DS_ORVALUE            2  /* ors data with IO port */
#define DS_XORVALUE           3  /* xors data with IO port */
#define DS_NOTVALUE           4  /* nots the value of the IO port (data ignored) */

