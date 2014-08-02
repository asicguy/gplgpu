///////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2014 Francis Bruno, All Rights Reserved
// 
//  This program is free software; you can redistribute it and/or modify it 
//  under the terms of the GNU General Public License as published by the Free 
//  Software Foundation; either version 3 of the License, or (at your option) 
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but 
//  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
//  or FITNESS FOR A PARTICULAR PURPOSE. 
//  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with
//  this program; if not, see <http://www.gnu.org/licenses>.
//
//  This code is available under licenses for commercial use. Please contact
//  Francis Bruno for more information.
//
//  http://www.gplgpu.com
//  http://www.asicsolutions.com
//
//  Title       :  
//  File        :  clks_params.h
//  Author      :  Frank Bruno
//  Created     :  14-May-2011
//  RCS File    :  $Source:$
//  Status      :  $Id:$
//
///////////////////////////////////////////////////////////////////////////////
//
//  Description : 
//  Clock parameters for simulation
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
//
///////////////////////////////////////////////////////////////////////////////

`ifdef AGP_SGR_CLKS
parameter
              test_period = 15,
                hclk_low = 7.5,
                hclk_hi  = 7.5,
                hclk_offset = 0,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 6,
                dclk_hi  = 6,
                dclk_offset  = 0,
                dclk     = dclk_low + dclk_hi,
 
                cclk_low = 7.5,
                cclk_hi  = 7.5,
                cclk_offset  = 3.75,
                cclk     = cclk_low + cclk_hi,
 
                sclk_low = 4,
                sclk_hi  = 4,
                sclk_offset  = 0,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 5,
                mclk_hi  = 5,
                mclk_offset  = 1,
                mclk     = mclk_low + mclk_hi;
`else
`ifdef SLOW_HCLK
parameter
              test_period = 75,
                hclk_low = 37.5,
                hclk_hi  = 37.5,
                hclk_offset = 0,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 6,
                dclk_hi  = 6,
                dclk_offset  = 0,
                dclk     = dclk_low + dclk_hi,
 
                cclk_low = 7.5,
                cclk_hi  = 7.5,
                cclk_offset  = 3.75,
                cclk     = cclk_low + cclk_hi,
 
                sclk_low = 4,
                sclk_hi  = 4,
                sclk_offset  = 0,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 7.5,
                mclk_hi  = 7.5,
                mclk_offset  = 1,
                mclk     = mclk_low + mclk_hi;
`else
`ifdef PCI20_SGR_CLKS
parameter
              test_period = 50,
                hclk_low = 25,
                hclk_hi  = 25,
                hclk_offset = 0,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 6,
                dclk_hi  = 6,
                dclk_offset  = 0,
                dclk     = dclk_low + dclk_hi,
 
                cclk_low = 7.5,
                cclk_hi  = 7.5,
                cclk_offset  = 3.75,
                cclk     = cclk_low + cclk_hi,
 
                sclk_low = 4,
                sclk_hi  = 4,
                sclk_offset  = 0,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 5,
                mclk_hi  = 5,
                mclk_offset  = 5,
                mclk     = mclk_low + mclk_hi;
`else
`ifdef AGP_TEST
parameter
              test_period = 15,
                hclk_low = 7.5,
                hclk_hi  = 7.5,
                hclk_offset = 0,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 7.5,
                dclk_hi  = 7.5,
                dclk_offset  = 2,
                dclk     = dclk_low + dclk_hi,
 
                cclk_low = 7.5,
                cclk_hi  = 7.5,
                cclk_offset  = 1,
                cclk     = cclk_low + cclk_hi,
 
                sclk_low = 7.5,
                sclk_hi  = 7.5,
                sclk_offset  = 3.75,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 7.5,
                mclk_hi  = 7.5,
                mclk_offset  = 7.5,
                mclk     = mclk_low + mclk_hi;
`else
`ifdef GATE_LEVEL_CLKS
parameter       hclk_low = 16,
                hclk_hi  = 16,
                hclk     = hclk_low + hclk_hi,
                dclk_low = 16,
                dclk_hi  = 16,
                dclk     = dclk_low + dclk_hi,
                mclk_low = 8,
                mclk_hi  = 8,
                mclk     = mclk_low + mclk_hi,
                cclk_low = 16,
                cclk_hi  = 16,
                cclk     = cclk_low + cclk_hi,
                vclk_low = 16,
                vclk_hi  = 16,
                vclk     = vclk_low + vclk_hi,
                sclk_low = 16,
                sclk_hi  = 16,
                sclk     = sclk_low + sclk_hi;
`else


`ifdef FASTTEST
parameter 
		test_period = 20.0,


		hclk_low = 20,
		hclk_hi  = 20,
                hclk_offset = 0,
		hclk     = hclk_low + hclk_hi,

		dclk_low = 10,
		dclk_hi  = 10,
		dclk_offset  = 10,
		dclk     = dclk_low + dclk_hi,

		cclk_low =6.25,
		cclk_hi  = 6.25,
		cclk_offset  = 0,
		cclk     = cclk_low + cclk_hi,

		sclk_low = 25,
		sclk_hi  = 25,
		sclk_offset  = 0,
		sclk     = sclk_low + sclk_hi,

		mclk_low = 10,
		mclk_hi  = 10,
		mclk_offset  = 5,
		mclk     = mclk_low + mclk_hi;


`else
`ifdef LIKEVECT
parameter 
		test_period = 1000,


		hclk_low = 900,
		hclk_hi  = 100,
                hclk_offset = 100,
		hclk     = hclk_low + hclk_hi,

		dclk_low = 900,
		dclk_hi  = 100,
		dclk_offset  = 300,
		dclk     = dclk_low + dclk_hi,

		cclk_low = 900,
		cclk_hi  = 100,
		cclk_offset  = 300,
		cclk     = cclk_low + cclk_hi,

		sclk_low = 1000,
		sclk_hi  = 1000,
		sclk_offset  = 0,
		sclk     = sclk_low + sclk_hi,

		mclk_low = 900,
		mclk_hi  = 100,
		mclk_offset  = 500,
		mclk     = mclk_low + mclk_hi;
`else
`ifdef SAFE_EDGE
parameter
                test_period = 105,
 
 
                hclk_low = 90,
                hclk_hi  = 15,
                hclk_offset = 15,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 90,
                dclk_hi  = 15,
                dclk_offset  = 45,
                dclk     = dclk_low + dclk_hi,
 
              //  cclk_low = 90, // N.A driven as inverted SCLK
              //  cclk_hi  = 15,
              //  cclk_offset  = 45,
              //  cclk     = cclk_low + cclk_hi,
 
                sclk_low = 105,
                sclk_hi  = 105,
                sclk_offset  = 0,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 90,
                mclk_hi  = 15,
                mclk_offset  = 75,
                mclk     = mclk_low + mclk_hi;
 
`else 
`ifdef SAFE_EDGE_FAST
parameter
                test_period = 16,
 
 
                hclk_low = 16,
                hclk_hi  = 16,
                hclk_offset = 4,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 8,
                dclk_hi  = 8,
                dclk_offset  = 0,
                dclk     = dclk_low + dclk_hi,

                cclk_low = 8,
                cclk_hi  = 8,
                cclk_offset  = 0,
                cclk     = cclk_low + cclk_hi,
 
               // if external then it is twice slower than CRTCLK
               // and edges shifted by 4ns from CRTCLK and 8ns from HCLK 
                sclk_low = 16,
                sclk_hi  = 16,
                sclk_offset  = 12,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 8,
                mclk_hi  = 8,
                mclk_offset  = 0,
                mclk     = mclk_low + mclk_hi;
 

`else
`ifdef ANY_CLOCKS
parameter
             // for memory tests 66M+C/33rest
              test_period = 15,
                hclk_low = 10.0,
                hclk_hi  = 10.0,
                hclk_offset = 0,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 10.0,
                dclk_hi  = 10.0,
                dclk_offset  = 10.0,
                dclk     = dclk_low + dclk_hi,
 
                cclk_low = 10.0,
                cclk_hi  = 10.0,
                cclk_offset  = 5.00,
                cclk     = cclk_low + cclk_hi,
 
                sclk_low = 10.0,
                sclk_hi  = 10.0,
                sclk_offset  = 5.0,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 10.0,
                mclk_hi  = 10.0,
                mclk_offset  = 15.00,
                mclk     = mclk_low + mclk_hi;
           /**
               // for crt tests
              test_period = 40,
                hclk_low = 20,
                hclk_hi  = 20,
                hclk_offset = 10,
                hclk     = hclk_low + hclk_hi,
 
                dclk_low = 10,
                dclk_hi  = 10,
                dclk_offset  = 15,
                dclk     = dclk_low + dclk_hi,
 
                cclk_low = 5,
                cclk_hi  = 5,
                cclk_offset  = 0,
                cclk     = cclk_low + cclk_hi,
 
                sclk_low = 10,
                sclk_hi  = 10,
                sclk_offset  = 15,
                sclk     = sclk_low + sclk_hi,
 
                mclk_low = 10,
                mclk_hi  = 10,
                mclk_offset  = 5,
                mclk     = mclk_low + mclk_hi;


          **/


`else   

parameter       hclk_low = 15,
                hclk_hi  = 15,
                hclk     = hclk_low + hclk_hi,
                dclk_low = 15,
                dclk_hi  = 15,
                dclk     = dclk_low + dclk_hi,
                mclk_low = 10,
                mclk_hi  = 10,
                mclk     = mclk_low + mclk_hi,
                cclk_low = 15,
                cclk_hi  = 15,
                cclk     = cclk_low + cclk_hi,
                vclk_low = 15,
                vclk_hi  = 15,
                vclk     = vclk_low + vclk_hi,
                sclk_low = 15,
                sclk_hi  = 15,
                sclk     = sclk_low + sclk_hi;
 

`endif
`endif
`endif
`endif
`endif
`endif
`endif
`endif
`endif
`endif


