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
 *  Title       :  Prototype Header file
 *  File        :  os.h
 *  Author      :  Frank Bruno
 *  Created     :  14-May-2011
 *  RCS File    :  $Source:$
 *  Status      :  $Id:$
 *
 ******************************************************************************
 *
 *  Description : 
 *
 *  File containing definitions specific to an operating system.
 *
 *  Contained here are prototypes, data types, operating system
 *  includes, and other definitions.
 *
 *  This file should, ultimately, be a file which contains the definitions
 *  needed for the one operating system source code is being compiled on.
 *  When the source code is moved, the values contained within here should
 *  be changed for the needs of the new operating system.
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
/* -DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-DOS-*/
/* ---------------------------------------------------------------------*/
/* ---------------------------------------------------------------------*/
#if DOS_COMPILE 

#define FAR                
#define PROTOTYPES         1
#define BIG_ENDIAN_MODE         0

/* ---------------------------------------------------------------------*/
/* -END DOS-END DOS-END DOS-END DOS-END DOS-END DOS-END DOS-END DOS-*/


/* -Windows-Windows-Windows-Windows-Windows-Windows-Windows-Windows-*/
/* ---------------------------------------------------------------------*/
/* ---------------------------------------------------------------------*/
#elif WINDOWS_COMPILE

#include <windows.h>

/* FAR is defined in windows.h */
#define PROTOTYPES         1
#define BIG_ENDIAN_MODE         0

/* ---------------------------------------------------------------------*/
/* -END Windows-END Windows-END Windows-END Windows-END Windows-*/


/* -UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-UNIX-*/
/* ---------------------------------------------------------------------*/
/* ---------------------------------------------------------------------*/
#elif UNIX_COMPILE 

#define FAR    
#define PROTOTYPES         0
#define BIG_ENDIAN_MODE         0

/* ---------------------------------------------------------------------*/
/* -END UNIX-END UNIX-END UNIX-END UNIX-END UNIX-END UNIX-END UNIX-*/


/* -SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-SUN-*/
/* ---------------------------------------------------------------------*/
/* ---------------------------------------------------------------------*/
#elif SUN_COMPILE 

#define FAR    
#define PROTOTYPES         0
#define BIG_ENDIAN_MODE         1

/* ---------------------------------------------------------------------*/
/* -END SUN-END SUN-END SUN-END SUN-END SUN-END SUN-END SUN-END SUN-*/


/* -GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-GNU-C-*/
/* ---------------------------------------------------------------------*/
/* ---------------------------------------------------------------------*/
#elif GNU_C_COMPILE 

#define FAR    
#define PROTOTYPES         1
#define BIG_ENDIAN_MODE         0

/* ---------------------------------------------------------------------*/
/* -END GNU-C-END GNU-C-END GNU-C-END GNU-C-END GNU-C-END GNU-C-END GNU-C-*/


/* -Generic-Generic-Generic-Generic-Generic-Generic-Generic-Generic-*/
/* ---------------------------------------------------------------------*/
/* ---------------------------------------------------------------------*/
#else  /* ???  Default/Unknown  ??? */

#define FAR    
#define PROTOTYPES         0
#define BIG_ENDIAN_MODE         0

/* ---------------------------------------------------------------------*/
/* -END Generic-END Generic-END Generic-END Generic-END Generic-*/

/* ---------------------------------------------------------------------*/

#endif  /* ???_COMPILE */
