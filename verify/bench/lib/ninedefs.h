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
 *  File        :  ninedefs.h
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
/***********************************************/
/*      Primitive Definitions                  */
/***********************************************/

/* ----------------------- */
/* minor changes need to be made to be compatible with Windows.h */
#ifndef _INC_WINDOWS

#define  INT        int
#define  BYTE       char
#define  DWORD      long
#ifndef FAR
#define  FAR        far
#endif  /* FAR */
#define  VOID       void
#define  SHORT      short
#define  FLOAT      float
#define  DOUBLE     double

#ifndef NULL
        #define NULL        (VOID *) 0
#endif

#ifdef FALSE
        #undef FALSE
#endif
#define FALSE           0

#ifdef TRUE
        #undef TRUE
#endif
#define TRUE        !FALSE

#ifdef WORD
        #undef WORD
#endif
#define  WORD       SHORT

#ifdef BOOL
        #undef BOOL
#endif
#define  BOOL       char               

#define  UINT       unsigned INT
#define  HANDLE     DWORD              
#define  BADHANDLE  (HANDLE) -1

#define  LPSTR      char far *

#else   /* ! _INC_WINDOWS */

/* C7.0 Translations */
#define read(x, y, z)      _read(x, y, z)
#define strlwr(x)          _strlwr(x)
#define strnset(x, y, z)   _strnset(x, y, z)
#define strcmpi(x, y)      _stricmp(x, y)
#define strnicmp(x, y, z)  _strnicmp(x, y, z)
#define write(x, y, z)     _write(x, y, z)
#define open(x, y)         _open(x, y)
#define close(x)           _close(x)

#endif   /* ! _INC_WINDOWS */
/* ----------------------- */


#define  UWORD      unsigned short
#define  UDWORD     unsigned long
#define  USHORT     unsigned short
#define  GIANT      long double
#define  UBYTE      unsigned char


#define  EQU        ==
#define  NOT        !
#define  AND        &&
#define  OR         ||
#define  NOT_EQU    !=

#define  NFG         -1
#define  OK          TRUE
#define  NOT_OK      FALSE
#define  ESCAPE      NFG
#define  EVER        ; ;

#define  MIN(a,b)    ((a) > (b) ? (b) : (a))
#define  MAX(a,b)    ((a) < (b) ? (b) : (a))

#define  LO_NB_MASK   0x0F
#define  HI_NB_MASK   0xF0
#define  LO_NIBL(x)   (UWORD)((x) & LO_NB_MASK)
#define  HI_NIBL(x)   (UWORD)(((x) & HI_NB_MASK) >> 4)

#define  LO_MASK      0x00FF
#define  HI_MASK      0xFF00
#define  LO_BYTE(x)   (UBYTE)((x) & LO_MASK)
#define  HI_BYTE(x)   (UBYTE)(((x) & HI_MASK) >> 8)

#define  LO_DW_MASK   0x0000FFFF
#define  HI_DW_MASK   0xFFFF0000
#define  LO_WORD(x)   (UWORD)((x) & LO_DW_MASK)
#define  HI_WORD(x)   (UWORD)(((x) & HI_DW_MASK) >> 16)

/*****************************************************************/
/*****  EOF EOF EOF EOF EOF EOF EOF EOF EOF EOF EOF EOF EOF ******/
/*****************************************************************/


