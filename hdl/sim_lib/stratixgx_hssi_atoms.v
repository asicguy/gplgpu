//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 123 mux21 348 
`timescale 1 ps / 1 ps
module  stratixgx_xgm_rx_sm
	( 
	resetall,
	rxclk,
	rxctrl,
	rxctrlout,
	rxdatain,
	rxdataout,
	rxdatavalid,
	rxrunningdisp) /* synthesis synthesis_clearbox=1 */;
	input   resetall;
	input   rxclk;
	input   [3:0]  rxctrl;
	output   [3:0]  rxctrlout;
	input   [31:0]  rxdatain;
	output   [31:0]  rxdataout;
	input   [3:0]  rxdatavalid;
	input   [3:0]  rxrunningdisp;

	reg	nl000l45;
	reg	nl000l46;
	reg	nl00iO43;
	reg	nl00iO44;
	reg	nl00OO41;
	reg	nl00OO42;
	reg	nl0i0O37;
	reg	nl0i0O38;
	reg	nl0i1l39;
	reg	nl0i1l40;
	reg	nl0iil35;
	reg	nl0iil36;
	reg	nl0ill33;
	reg	nl0ill34;
	reg	nl0iOO31;
	reg	nl0iOO32;
	reg	nl0l0l27;
	reg	nl0l0l28;
	reg	nl0l1O29;
	reg	nl0l1O30;
	reg	nl0lil25;
	reg	nl0lil26;
	reg	nl0lll23;
	reg	nl0lll24;
	reg	nl0llO21;
	reg	nl0llO22;
	reg	nl0O0O17;
	reg	nl0O0O18;
	reg	nl0O1l19;
	reg	nl0O1l20;
	reg	nl0Oli15;
	reg	nl0Oli16;
	reg	nl0OOO13;
	reg	nl0OOO14;
	reg	nli00O3;
	reg	nli00O4;
	reg	nli0lO1;
	reg	nli0lO2;
	reg	nli10l10;
	reg	nli10l9;
	reg	nli11O11;
	reg	nli11O12;
	reg	nli1ii7;
	reg	nli1ii8;
	reg	nli1OO5;
	reg	nli1OO6;
	reg	n11iO;
	reg	n1O1i;
	reg	n1O1l;
	reg	n1O1O;
	reg	n1Oii;
	reg	nlllli;
	wire	wire_n1O0O_PRN;
	reg	n00ll;
	reg	n00lO;
	reg	n00Oi;
	reg	n00Ol;
	reg	n00OO;
	reg	n0i1i;
	reg	n0i1l;
	reg	n0i1O;
	reg	n110i;
	reg	n110l;
	reg	n110O;
	reg	n111i;
	reg	n111l;
	reg	n111O;
	reg	n11ii;
	reg	n11il;
	reg	n1lOl;
	reg	n1lOO;
	reg	n1O0i;
	reg	n1O0l;
	reg	n1Oil;
	reg	ni00i;
	reg	ni00l;
	reg	ni00O;
	reg	ni01i;
	reg	ni01l;
	reg	ni01O;
	reg	ni0ii;
	reg	ni1Ol;
	reg	ni1OO;
	reg	niii;
	reg	niil;
	reg	niiO;
	reg	niOl;
	reg	nl10i;
	reg	nl10l;
	reg	nl10O;
	reg	nl11O;
	reg	nl1ii;
	reg	nl1il;
	reg	nl1iO;
	reg	nl1li;
	reg	nlllll;
	reg	nllllO;
	reg	nlllOi;
	reg	nlllOl;
	reg	nlllOO;
	reg	nllO1i;
	reg	nllO1l;
	reg	nllO1O;
	reg	nlO00i;
	reg	nlO00l;
	reg	nlO00O;
	reg	nlO0ii;
	reg	nlO0il;
	reg	nlO0iO;
	reg	nlO0li;
	reg	nlO0ll;
	reg	nlO0lO;
	reg	nlOii;
	reg	nlOil;
	reg	nlOlO;
	reg	nlOOi;
	reg	nlOOO;
	reg	n00li;
	reg	nl1i;
	reg	nl1ll;
	reg	nlOiO;
	reg	nlOli;
	reg	nlOll;
	reg	nlOOl;
	reg	niOO_clk_prev;
	wire	wire_niOO_CLRN;
	wire	wire_niOO_PRN;
	wire	wire_n000i_dataout;
	wire	wire_n000l_dataout;
	wire	wire_n001i_dataout;
	wire	wire_n001l_dataout;
	wire	wire_n001O_dataout;
	wire	wire_n00i_dataout;
	wire	wire_n00l_dataout;
	wire	wire_n00O_dataout;
	wire	wire_n010i_dataout;
	wire	wire_n010l_dataout;
	wire	wire_n010O_dataout;
	wire	wire_n011i_dataout;
	wire	wire_n011l_dataout;
	wire	wire_n011O_dataout;
	wire	wire_n01i_dataout;
	wire	wire_n01ii_dataout;
	wire	wire_n01il_dataout;
	wire	wire_n01iO_dataout;
	wire	wire_n01l_dataout;
	wire	wire_n01li_dataout;
	wire	wire_n01ll_dataout;
	wire	wire_n01lO_dataout;
	wire	wire_n01O_dataout;
	wire	wire_n01Oi_dataout;
	wire	wire_n01Ol_dataout;
	wire	wire_n01OO_dataout;
	wire	wire_n0i0i_dataout;
	wire	wire_n0i0l_dataout;
	wire	wire_n0i0O_dataout;
	wire	wire_n0ii_dataout;
	wire	wire_n0iii_dataout;
	wire	wire_n0iil_dataout;
	wire	wire_n0iiO_dataout;
	wire	wire_n0il_dataout;
	wire	wire_n0ili_dataout;
	wire	wire_n0ill_dataout;
	wire	wire_n0ilO_dataout;
	wire	wire_n0iO_dataout;
	wire	wire_n0iOi_dataout;
	wire	wire_n0iOl_dataout;
	wire	wire_n0iOO_dataout;
	wire	wire_n0l0i_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0l1i_dataout;
	wire	wire_n0l1l_dataout;
	wire	wire_n0l1O_dataout;
	wire	wire_n0li_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0ll_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lll_dataout;
	wire	wire_n0llO_dataout;
	wire	wire_n0lO_dataout;
	wire	wire_n0lOi_dataout;
	wire	wire_n0lOl_dataout;
	wire	wire_n0lOO_dataout;
	wire	wire_n0O0i_dataout;
	wire	wire_n0O0l_dataout;
	wire	wire_n0O0O_dataout;
	wire	wire_n0O1i_dataout;
	wire	wire_n0O1l_dataout;
	wire	wire_n0O1O_dataout;
	wire	wire_n0Oi_dataout;
	wire	wire_n0Oii_dataout;
	wire	wire_n0Oil_dataout;
	wire	wire_n0OiO_dataout;
	wire	wire_n0Ol_dataout;
	wire	wire_n0Oli_dataout;
	wire	wire_n0Oll_dataout;
	wire	wire_n0OlO_dataout;
	wire	wire_n0OO_dataout;
	wire	wire_n0OOi_dataout;
	wire	wire_n0OOl_dataout;
	wire	wire_n0OOO_dataout;
	wire	wire_n100i_dataout;
	wire	wire_n100l_dataout;
	wire	wire_n100O_dataout;
	wire	wire_n101i_dataout;
	wire	wire_n101l_dataout;
	wire	wire_n101O_dataout;
	wire	wire_n10i_dataout;
	wire	wire_n10ii_dataout;
	wire	wire_n10il_dataout;
	wire	wire_n10iO_dataout;
	wire	wire_n10l_dataout;
	wire	wire_n10li_dataout;
	wire	wire_n10ll_dataout;
	wire	wire_n10lO_dataout;
	wire	wire_n10O_dataout;
	wire	wire_n10Oi_dataout;
	wire	wire_n10Ol_dataout;
	wire	wire_n10OO_dataout;
	wire	wire_n11i_dataout;
	wire	wire_n11l_dataout;
	wire	wire_n11li_dataout;
	wire	wire_n11ll_dataout;
	wire	wire_n11lO_dataout;
	wire	wire_n11O_dataout;
	wire	wire_n11Oi_dataout;
	wire	wire_n11Ol_dataout;
	wire	wire_n11OO_dataout;
	wire	wire_n1i0i_dataout;
	wire	wire_n1i0l_dataout;
	wire	wire_n1i0O_dataout;
	wire	wire_n1i1i_dataout;
	wire	wire_n1i1l_dataout;
	wire	wire_n1i1O_dataout;
	wire	wire_n1ii_dataout;
	wire	wire_n1iii_dataout;
	wire	wire_n1iil_dataout;
	wire	wire_n1iiO_dataout;
	wire	wire_n1il_dataout;
	wire	wire_n1ili_dataout;
	wire	wire_n1ill_dataout;
	wire	wire_n1ilO_dataout;
	wire	wire_n1iO_dataout;
	wire	wire_n1iOi_dataout;
	wire	wire_n1iOl_dataout;
	wire	wire_n1iOO_dataout;
	wire	wire_n1l0i_dataout;
	wire	wire_n1l0l_dataout;
	wire	wire_n1l0O_dataout;
	wire	wire_n1li_dataout;
	wire	wire_n1lii_dataout;
	wire	wire_n1lil_dataout;
	wire	wire_n1liO_dataout;
	wire	wire_n1ll_dataout;
	wire	wire_n1lli_dataout;
	wire	wire_n1lll_dataout;
	wire	wire_n1llO_dataout;
	wire	wire_n1lO_dataout;
	wire	wire_n1Oi_dataout;
	wire	wire_n1OiO_dataout;
	wire	wire_n1Ol_dataout;
	wire	wire_n1Oli_dataout;
	wire	wire_n1Oll_dataout;
	wire	wire_n1OlO_dataout;
	wire	wire_n1OO_dataout;
	wire	wire_n1OOi_dataout;
	wire	wire_n1OOl_dataout;
	wire	wire_n1OOO_dataout;
	wire	wire_ni0i_dataout;
	wire	wire_ni0il_dataout;
	wire	wire_ni0iO_dataout;
	wire	wire_ni0l_dataout;
	wire	wire_ni0li_dataout;
	wire	wire_ni0ll_dataout;
	wire	wire_ni0lO_dataout;
	wire	wire_ni0O_dataout;
	wire	wire_ni0Oi_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_ni10i_dataout;
	wire	wire_ni10l_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni11i_dataout;
	wire	wire_ni11l_dataout;
	wire	wire_ni11O_dataout;
	wire	wire_ni1i_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1il_dataout;
	wire	wire_ni1iO_dataout;
	wire	wire_ni1l_dataout;
	wire	wire_ni1li_dataout;
	wire	wire_ni1ll_dataout;
	wire	wire_ni1lO_dataout;
	wire	wire_ni1O_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niili_dataout;
	wire	wire_niill_dataout;
	wire	wire_niilO_dataout;
	wire	wire_niiOi_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_nil0i_dataout;
	wire	wire_nil0l_dataout;
	wire	wire_nil0O_dataout;
	wire	wire_nil1i_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nili_dataout;
	wire	wire_nilii_dataout;
	wire	wire_nilil_dataout;
	wire	wire_niliO_dataout;
	wire	wire_nill_dataout;
	wire	wire_nilli_dataout;
	wire	wire_nilll_dataout;
	wire	wire_nillO_dataout;
	wire	wire_nilOi_dataout;
	wire	wire_nilOl_dataout;
	wire	wire_nilOO_dataout;
	wire	wire_niO0i_dataout;
	wire	wire_niO0l_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niO1i_dataout;
	wire	wire_niO1l_dataout;
	wire	wire_niO1O_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOll_dataout;
	wire	wire_niOlO_dataout;
	wire	wire_niOOi_dataout;
	wire	wire_niOOl_dataout;
	wire	wire_niOOO_dataout;
	wire	wire_nl00i_dataout;
	wire	wire_nl00l_dataout;
	wire	wire_nl00O_dataout;
	wire	wire_nl01i_dataout;
	wire	wire_nl01l_dataout;
	wire	wire_nl01O_dataout;
	wire	wire_nl0i_dataout;
	wire	wire_nl0ii_dataout;
	wire	wire_nl0il_dataout;
	wire	wire_nl0iO_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl0li_dataout;
	wire	wire_nl0ll_dataout;
	wire	wire_nl0lO_dataout;
	wire	wire_nl0Oi_dataout;
	wire	wire_nl0Ol_dataout;
	wire	wire_nl0OO_dataout;
	wire	wire_nl11i_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1lO_dataout;
	wire	wire_nl1O_dataout;
	wire	wire_nl1Oi_dataout;
	wire	wire_nl1Ol_dataout;
	wire	wire_nl1OO_dataout;
	wire	wire_nli0i_dataout;
	wire	wire_nli0l_dataout;
	wire	wire_nli0O_dataout;
	wire	wire_nli1i_dataout;
	wire	wire_nli1l_dataout;
	wire	wire_nli1O_dataout;
	wire	wire_nliii_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nlili_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll0l_dataout;
	wire	wire_nll0O_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nllii_dataout;
	wire	wire_nllil_dataout;
	wire	wire_nlliO_dataout;
	wire	wire_nllli_dataout;
	wire	wire_nllll_dataout;
	wire	wire_nlllO_dataout;
	wire	wire_nllO0i_dataout;
	wire	wire_nllO0l_dataout;
	wire	wire_nllO0O_dataout;
	wire	wire_nllOi_dataout;
	wire	wire_nllOii_dataout;
	wire	wire_nllOil_dataout;
	wire	wire_nllOiO_dataout;
	wire	wire_nllOl_dataout;
	wire	wire_nllOli_dataout;
	wire	wire_nllOll_dataout;
	wire	wire_nllOlO_dataout;
	wire	wire_nllOO_dataout;
	wire	wire_nllOOi_dataout;
	wire	wire_nllOOl_dataout;
	wire	wire_nllOOO_dataout;
	wire	wire_nlO0i_dataout;
	wire	wire_nlO0l_dataout;
	wire	wire_nlO0Oi_dataout;
	wire	wire_nlO0Ol_dataout;
	wire	wire_nlO0OO_dataout;
	wire	wire_nlO10i_dataout;
	wire	wire_nlO10l_dataout;
	wire	wire_nlO10O_dataout;
	wire	wire_nlO11i_dataout;
	wire	wire_nlO11l_dataout;
	wire	wire_nlO11O_dataout;
	wire	wire_nlO1i_dataout;
	wire	wire_nlO1ii_dataout;
	wire	wire_nlO1il_dataout;
	wire	wire_nlO1iO_dataout;
	wire	wire_nlO1l_dataout;
	wire	wire_nlO1li_dataout;
	wire	wire_nlO1ll_dataout;
	wire	wire_nlO1lO_dataout;
	wire	wire_nlO1O_dataout;
	wire	wire_nlO1Oi_dataout;
	wire	wire_nlO1Ol_dataout;
	wire	wire_nlO1OO_dataout;
	wire	wire_nlOi0i_dataout;
	wire	wire_nlOi0l_dataout;
	wire	wire_nlOi0O_dataout;
	wire	wire_nlOi1i_dataout;
	wire	wire_nlOi1l_dataout;
	wire	wire_nlOi1O_dataout;
	wire	wire_nlOiii_dataout;
	wire	wire_nlOiil_dataout;
	wire	wire_nlOiiO_dataout;
	wire	wire_nlOili_dataout;
	wire	wire_nlOill_dataout;
	wire	wire_nlOilO_dataout;
	wire	wire_nlOiOi_dataout;
	wire	wire_nlOiOl_dataout;
	wire	wire_nlOiOO_dataout;
	wire	wire_nlOl0i_dataout;
	wire	wire_nlOl0l_dataout;
	wire	wire_nlOl0O_dataout;
	wire	wire_nlOl1i_dataout;
	wire	wire_nlOl1l_dataout;
	wire	wire_nlOl1O_dataout;
	wire	wire_nlOlii_dataout;
	wire	wire_nlOlil_dataout;
	wire	wire_nlOliO_dataout;
	wire	wire_nlOlli_dataout;
	wire	wire_nlOlll_dataout;
	wire	wire_nlOllO_dataout;
	wire	wire_nlOlOi_dataout;
	wire	wire_nlOlOl_dataout;
	wire	wire_nlOlOO_dataout;
	wire	wire_nlOO0O_dataout;
	wire	wire_nlOO1i_dataout;
	wire	wire_nlOO1l_dataout;
	wire	wire_nlOO1O_dataout;
	wire	wire_nlOOii_dataout;
	wire	wire_nlOOil_dataout;
	wire	wire_nlOOiO_dataout;
	wire	wire_nlOOli_dataout;
	wire	wire_nlOOll_dataout;
	wire	wire_nlOOlO_dataout;
	wire	wire_nlOOOi_dataout;
	wire	wire_nlOOOl_dataout;
	wire  nl00ii;
	wire  nl00il;
	wire  nl00ll;
	wire  nl00lO;
	wire  nl00Oi;
	wire  nl00Ol;
	wire  nl0i0i;
	wire  nl0i0l;
	wire  nl0iii;
	wire  nl0ili;
	wire  nl0iOi;
	wire  nl0iOl;
	wire  nl0l1l;
	wire  nl0lii;
	wire  nl0lli;
	wire  nl0lOi;
	wire  nl0lOl;
	wire  nl0lOO;
	wire  nl0O0i;
	wire  nl0O0l;
	wire  nl0O1i;
	wire  nl0Oil;
	wire  nl0OiO;
	wire  nl0OlO;
	wire  nl0OOi;
	wire  nl0OOl;
	wire  nli00i;
	wire  nli00l;
	wire  nli01l;
	wire  nli01O;
	wire  nli0il;
	wire  nli0iO;
	wire  nli0li;
	wire  nli0ll;
	wire  nli11l;
	wire  nli1iO;
	wire  nli1li;
	wire  nli1ll;
	wire  nli1lO;
	wire  nli1Oi;
	wire  nli1Ol;
	wire  nlii1i;

	initial
		nl000l45 = 0;
	always @ ( posedge rxclk)
		  nl000l45 <= nl000l46;
	event nl000l45_event;
	initial
		#1 ->nl000l45_event;
	always @(nl000l45_event)
		nl000l45 <= {1{1'b1}};
	initial
		nl000l46 = 0;
	always @ ( posedge rxclk)
		  nl000l46 <= nl000l45;
	initial
		nl00iO43 = 0;
	always @ ( posedge rxclk)
		  nl00iO43 <= nl00iO44;
	event nl00iO43_event;
	initial
		#1 ->nl00iO43_event;
	always @(nl00iO43_event)
		nl00iO43 <= {1{1'b1}};
	initial
		nl00iO44 = 0;
	always @ ( posedge rxclk)
		  nl00iO44 <= nl00iO43;
	initial
		nl00OO41 = 0;
	always @ ( posedge rxclk)
		  nl00OO41 <= nl00OO42;
	event nl00OO41_event;
	initial
		#1 ->nl00OO41_event;
	always @(nl00OO41_event)
		nl00OO41 <= {1{1'b1}};
	initial
		nl00OO42 = 0;
	always @ ( posedge rxclk)
		  nl00OO42 <= nl00OO41;
	initial
		nl0i0O37 = 0;
	always @ ( posedge rxclk)
		  nl0i0O37 <= nl0i0O38;
	event nl0i0O37_event;
	initial
		#1 ->nl0i0O37_event;
	always @(nl0i0O37_event)
		nl0i0O37 <= {1{1'b1}};
	initial
		nl0i0O38 = 0;
	always @ ( posedge rxclk)
		  nl0i0O38 <= nl0i0O37;
	initial
		nl0i1l39 = 0;
	always @ ( posedge rxclk)
		  nl0i1l39 <= nl0i1l40;
	event nl0i1l39_event;
	initial
		#1 ->nl0i1l39_event;
	always @(nl0i1l39_event)
		nl0i1l39 <= {1{1'b1}};
	initial
		nl0i1l40 = 0;
	always @ ( posedge rxclk)
		  nl0i1l40 <= nl0i1l39;
	initial
		nl0iil35 = 0;
	always @ ( posedge rxclk)
		  nl0iil35 <= nl0iil36;
	event nl0iil35_event;
	initial
		#1 ->nl0iil35_event;
	always @(nl0iil35_event)
		nl0iil35 <= {1{1'b1}};
	initial
		nl0iil36 = 0;
	always @ ( posedge rxclk)
		  nl0iil36 <= nl0iil35;
	initial
		nl0ill33 = 0;
	always @ ( posedge rxclk)
		  nl0ill33 <= nl0ill34;
	event nl0ill33_event;
	initial
		#1 ->nl0ill33_event;
	always @(nl0ill33_event)
		nl0ill33 <= {1{1'b1}};
	initial
		nl0ill34 = 0;
	always @ ( posedge rxclk)
		  nl0ill34 <= nl0ill33;
	initial
		nl0iOO31 = 0;
	always @ ( posedge rxclk)
		  nl0iOO31 <= nl0iOO32;
	event nl0iOO31_event;
	initial
		#1 ->nl0iOO31_event;
	always @(nl0iOO31_event)
		nl0iOO31 <= {1{1'b1}};
	initial
		nl0iOO32 = 0;
	always @ ( posedge rxclk)
		  nl0iOO32 <= nl0iOO31;
	initial
		nl0l0l27 = 0;
	always @ ( posedge rxclk)
		  nl0l0l27 <= nl0l0l28;
	event nl0l0l27_event;
	initial
		#1 ->nl0l0l27_event;
	always @(nl0l0l27_event)
		nl0l0l27 <= {1{1'b1}};
	initial
		nl0l0l28 = 0;
	always @ ( posedge rxclk)
		  nl0l0l28 <= nl0l0l27;
	initial
		nl0l1O29 = 0;
	always @ ( posedge rxclk)
		  nl0l1O29 <= nl0l1O30;
	event nl0l1O29_event;
	initial
		#1 ->nl0l1O29_event;
	always @(nl0l1O29_event)
		nl0l1O29 <= {1{1'b1}};
	initial
		nl0l1O30 = 0;
	always @ ( posedge rxclk)
		  nl0l1O30 <= nl0l1O29;
	initial
		nl0lil25 = 0;
	always @ ( posedge rxclk)
		  nl0lil25 <= nl0lil26;
	event nl0lil25_event;
	initial
		#1 ->nl0lil25_event;
	always @(nl0lil25_event)
		nl0lil25 <= {1{1'b1}};
	initial
		nl0lil26 = 0;
	always @ ( posedge rxclk)
		  nl0lil26 <= nl0lil25;
	initial
		nl0lll23 = 0;
	always @ ( posedge rxclk)
		  nl0lll23 <= nl0lll24;
	event nl0lll23_event;
	initial
		#1 ->nl0lll23_event;
	always @(nl0lll23_event)
		nl0lll23 <= {1{1'b1}};
	initial
		nl0lll24 = 0;
	always @ ( posedge rxclk)
		  nl0lll24 <= nl0lll23;
	initial
		nl0llO21 = 0;
	always @ ( posedge rxclk)
		  nl0llO21 <= nl0llO22;
	event nl0llO21_event;
	initial
		#1 ->nl0llO21_event;
	always @(nl0llO21_event)
		nl0llO21 <= {1{1'b1}};
	initial
		nl0llO22 = 0;
	always @ ( posedge rxclk)
		  nl0llO22 <= nl0llO21;
	initial
		nl0O0O17 = 0;
	always @ ( posedge rxclk)
		  nl0O0O17 <= nl0O0O18;
	event nl0O0O17_event;
	initial
		#1 ->nl0O0O17_event;
	always @(nl0O0O17_event)
		nl0O0O17 <= {1{1'b1}};
	initial
		nl0O0O18 = 0;
	always @ ( posedge rxclk)
		  nl0O0O18 <= nl0O0O17;
	initial
		nl0O1l19 = 0;
	always @ ( posedge rxclk)
		  nl0O1l19 <= nl0O1l20;
	event nl0O1l19_event;
	initial
		#1 ->nl0O1l19_event;
	always @(nl0O1l19_event)
		nl0O1l19 <= {1{1'b1}};
	initial
		nl0O1l20 = 0;
	always @ ( posedge rxclk)
		  nl0O1l20 <= nl0O1l19;
	initial
		nl0Oli15 = 0;
	always @ ( posedge rxclk)
		  nl0Oli15 <= nl0Oli16;
	event nl0Oli15_event;
	initial
		#1 ->nl0Oli15_event;
	always @(nl0Oli15_event)
		nl0Oli15 <= {1{1'b1}};
	initial
		nl0Oli16 = 0;
	always @ ( posedge rxclk)
		  nl0Oli16 <= nl0Oli15;
	initial
		nl0OOO13 = 0;
	always @ ( posedge rxclk)
		  nl0OOO13 <= nl0OOO14;
	event nl0OOO13_event;
	initial
		#1 ->nl0OOO13_event;
	always @(nl0OOO13_event)
		nl0OOO13 <= {1{1'b1}};
	initial
		nl0OOO14 = 0;
	always @ ( posedge rxclk)
		  nl0OOO14 <= nl0OOO13;
	initial
		nli00O3 = 0;
	always @ ( posedge rxclk)
		  nli00O3 <= nli00O4;
	event nli00O3_event;
	initial
		#1 ->nli00O3_event;
	always @(nli00O3_event)
		nli00O3 <= {1{1'b1}};
	initial
		nli00O4 = 0;
	always @ ( posedge rxclk)
		  nli00O4 <= nli00O3;
	initial
		nli0lO1 = 0;
	always @ ( posedge rxclk)
		  nli0lO1 <= nli0lO2;
	event nli0lO1_event;
	initial
		#1 ->nli0lO1_event;
	always @(nli0lO1_event)
		nli0lO1 <= {1{1'b1}};
	initial
		nli0lO2 = 0;
	always @ ( posedge rxclk)
		  nli0lO2 <= nli0lO1;
	initial
		nli10l10 = 0;
	always @ ( posedge rxclk)
		  nli10l10 <= nli10l9;
	initial
		nli10l9 = 0;
	always @ ( posedge rxclk)
		  nli10l9 <= nli10l10;
	event nli10l9_event;
	initial
		#1 ->nli10l9_event;
	always @(nli10l9_event)
		nli10l9 <= {1{1'b1}};
	initial
		nli11O11 = 0;
	always @ ( posedge rxclk)
		  nli11O11 <= nli11O12;
	event nli11O11_event;
	initial
		#1 ->nli11O11_event;
	always @(nli11O11_event)
		nli11O11 <= {1{1'b1}};
	initial
		nli11O12 = 0;
	always @ ( posedge rxclk)
		  nli11O12 <= nli11O11;
	initial
		nli1ii7 = 0;
	always @ ( posedge rxclk)
		  nli1ii7 <= nli1ii8;
	event nli1ii7_event;
	initial
		#1 ->nli1ii7_event;
	always @(nli1ii7_event)
		nli1ii7 <= {1{1'b1}};
	initial
		nli1ii8 = 0;
	always @ ( posedge rxclk)
		  nli1ii8 <= nli1ii7;
	initial
		nli1OO5 = 0;
	always @ ( posedge rxclk)
		  nli1OO5 <= nli1OO6;
	event nli1OO5_event;
	initial
		#1 ->nli1OO5_event;
	always @(nli1OO5_event)
		nli1OO5 <= {1{1'b1}};
	initial
		nli1OO6 = 0;
	always @ ( posedge rxclk)
		  nli1OO6 <= nli1OO5;
	initial
	begin
		n11iO = 0;
		n1O1i = 0;
		n1O1l = 0;
		n1O1O = 0;
		n1Oii = 0;
		nlllli = 0;
	end
	always @ ( posedge rxclk or  negedge wire_n1O0O_PRN)
	begin
		if (wire_n1O0O_PRN == 1'b0) 
		begin
			n11iO <= 1;
			n1O1i <= 1;
			n1O1l <= 1;
			n1O1O <= 1;
			n1Oii <= 1;
			nlllli <= 1;
		end
		else 
		begin
			n11iO <= wire_n1OiO_dataout;
			n1O1i <= wire_n1OlO_dataout;
			n1O1l <= wire_n1OOi_dataout;
			n1O1O <= wire_n1OOl_dataout;
			n1Oii <= wire_n011l_dataout;
			nlllli <= wire_nllO0l_dataout;
		end
	end
	assign
		wire_n1O0O_PRN = ((nl0i0O38 ^ nl0i0O37) & (~ resetall));
	initial
	begin
		n00ll = 0;
		n00lO = 0;
		n00Oi = 0;
		n00Ol = 0;
		n00OO = 0;
		n0i1i = 0;
		n0i1l = 0;
		n0i1O = 0;
		n110i = 0;
		n110l = 0;
		n110O = 0;
		n111i = 0;
		n111l = 0;
		n111O = 0;
		n11ii = 0;
		n11il = 0;
		n1lOl = 0;
		n1lOO = 0;
		n1O0i = 0;
		n1O0l = 0;
		n1Oil = 0;
		ni00i = 0;
		ni00l = 0;
		ni00O = 0;
		ni01i = 0;
		ni01l = 0;
		ni01O = 0;
		ni0ii = 0;
		ni1Ol = 0;
		ni1OO = 0;
		niii = 0;
		niil = 0;
		niiO = 0;
		niOl = 0;
		nl10i = 0;
		nl10l = 0;
		nl10O = 0;
		nl11O = 0;
		nl1ii = 0;
		nl1il = 0;
		nl1iO = 0;
		nl1li = 0;
		nlllll = 0;
		nllllO = 0;
		nlllOi = 0;
		nlllOl = 0;
		nlllOO = 0;
		nllO1i = 0;
		nllO1l = 0;
		nllO1O = 0;
		nlO00i = 0;
		nlO00l = 0;
		nlO00O = 0;
		nlO0ii = 0;
		nlO0il = 0;
		nlO0iO = 0;
		nlO0li = 0;
		nlO0ll = 0;
		nlO0lO = 0;
		nlOii = 0;
		nlOil = 0;
		nlOlO = 0;
		nlOOi = 0;
		nlOOO = 0;
	end
	always @ ( posedge rxclk or  posedge resetall)
	begin
		if (resetall == 1'b1) 
		begin
			n00ll <= 0;
			n00lO <= 0;
			n00Oi <= 0;
			n00Ol <= 0;
			n00OO <= 0;
			n0i1i <= 0;
			n0i1l <= 0;
			n0i1O <= 0;
			n110i <= 0;
			n110l <= 0;
			n110O <= 0;
			n111i <= 0;
			n111l <= 0;
			n111O <= 0;
			n11ii <= 0;
			n11il <= 0;
			n1lOl <= 0;
			n1lOO <= 0;
			n1O0i <= 0;
			n1O0l <= 0;
			n1Oil <= 0;
			ni00i <= 0;
			ni00l <= 0;
			ni00O <= 0;
			ni01i <= 0;
			ni01l <= 0;
			ni01O <= 0;
			ni0ii <= 0;
			ni1Ol <= 0;
			ni1OO <= 0;
			niii <= 0;
			niil <= 0;
			niiO <= 0;
			niOl <= 0;
			nl10i <= 0;
			nl10l <= 0;
			nl10O <= 0;
			nl11O <= 0;
			nl1ii <= 0;
			nl1il <= 0;
			nl1iO <= 0;
			nl1li <= 0;
			nlllll <= 0;
			nllllO <= 0;
			nlllOi <= 0;
			nlllOl <= 0;
			nlllOO <= 0;
			nllO1i <= 0;
			nllO1l <= 0;
			nllO1O <= 0;
			nlO00i <= 0;
			nlO00l <= 0;
			nlO00O <= 0;
			nlO0ii <= 0;
			nlO0il <= 0;
			nlO0iO <= 0;
			nlO0li <= 0;
			nlO0ll <= 0;
			nlO0lO <= 0;
			nlOii <= 0;
			nlOil <= 0;
			nlOlO <= 0;
			nlOOi <= 0;
			nlOOO <= 0;
		end
		else 
		begin
			n00ll <= wire_n0i0O_dataout;
			n00lO <= wire_n0iii_dataout;
			n00Oi <= wire_n0iil_dataout;
			n00Ol <= wire_n0iiO_dataout;
			n00OO <= wire_n0ili_dataout;
			n0i1i <= wire_n0ill_dataout;
			n0i1l <= wire_n0ilO_dataout;
			n0i1O <= wire_ni0il_dataout;
			n110i <= wire_n11Ol_dataout;
			n110l <= wire_n11OO_dataout;
			n110O <= wire_n101i_dataout;
			n111i <= wire_n11ll_dataout;
			n111l <= wire_n11lO_dataout;
			n111O <= wire_n11Oi_dataout;
			n11ii <= wire_n101l_dataout;
			n11il <= wire_n101O_dataout;
			n1lOl <= wire_n1Oli_dataout;
			n1lOO <= wire_n1Oll_dataout;
			n1O0i <= wire_n1OOO_dataout;
			n1O0l <= wire_n011i_dataout;
			n1Oil <= wire_n0i0i_dataout;
			ni00i <= wire_ni0Ol_dataout;
			ni00l <= wire_ni0OO_dataout;
			ni00O <= wire_nii1i_dataout;
			ni01i <= wire_ni0ll_dataout;
			ni01l <= wire_ni0lO_dataout;
			ni01O <= wire_ni0Oi_dataout;
			ni0ii <= wire_nl1lO_dataout;
			ni1Ol <= wire_ni0iO_dataout;
			ni1OO <= wire_ni0li_dataout;
			niii <= nl0lOl;
			niil <= nl0O1i;
			niiO <= wire_nili_dataout;
			niOl <= wire_nllO0i_dataout;
			nl10i <= wire_nl1Ol_dataout;
			nl10l <= wire_nl1OO_dataout;
			nl10O <= wire_nl01i_dataout;
			nl11O <= wire_nl1Oi_dataout;
			nl1ii <= wire_nl01l_dataout;
			nl1il <= wire_nl01O_dataout;
			nl1iO <= wire_nl00i_dataout;
			nl1li <= wire_nl00l_dataout;
			nlllll <= wire_nllO0O_dataout;
			nllllO <= wire_nllOii_dataout;
			nlllOi <= wire_nllOil_dataout;
			nlllOl <= wire_nllOiO_dataout;
			nlllOO <= wire_nllOli_dataout;
			nllO1i <= wire_nllOll_dataout;
			nllO1l <= wire_nllOlO_dataout;
			nllO1O <= wire_nlO0Oi_dataout;
			nlO00i <= wire_nlO0Ol_dataout;
			nlO00l <= wire_nlO0OO_dataout;
			nlO00O <= wire_nlOi1i_dataout;
			nlO0ii <= wire_nlOi1l_dataout;
			nlO0il <= wire_nlOi1O_dataout;
			nlO0iO <= wire_nlOi0i_dataout;
			nlO0li <= wire_nlOi0l_dataout;
			nlO0ll <= wire_nlOi0O_dataout;
			nlO0lO <= wire_n11li_dataout;
			nlOii <= wire_n11l_dataout;
			nlOil <= wire_n11O_dataout;
			nlOlO <= wire_n1ii_dataout;
			nlOOi <= wire_n1il_dataout;
			nlOOO <= (((rxctrl[3] & nl0lii) & (~ wire_nl0l_dataout)) & (nl0l0l28 ^ nl0l0l27));
		end
	end
	initial
	begin
		n00li = 0;
		nl1i = 0;
		nl1ll = 0;
		nlOiO = 0;
		nlOli = 0;
		nlOll = 0;
		nlOOl = 0;
	end
	always @ (rxclk or wire_niOO_PRN or wire_niOO_CLRN)
	begin
		if (wire_niOO_PRN == 1'b0) 
		begin
			n00li <= 1;
			nl1i <= 1;
			nl1ll <= 1;
			nlOiO <= 1;
			nlOli <= 1;
			nlOll <= 1;
			nlOOl <= 1;
		end
		else if  (wire_niOO_CLRN == 1'b0) 
		begin
			n00li <= 0;
			nl1i <= 0;
			nl1ll <= 0;
			nlOiO <= 0;
			nlOli <= 0;
			nlOll <= 0;
			nlOOl <= 0;
		end
		else 
		if (rxclk != niOO_clk_prev && rxclk == 1'b1) 
		begin
			n00li <= wire_n0i0l_dataout;
			nl1i <= (~ nl0lOi);
			nl1ll <= wire_n11i_dataout;
			nlOiO <= wire_n10i_dataout;
			nlOli <= wire_n10l_dataout;
			nlOll <= wire_n10O_dataout;
			nlOOl <= wire_n1iO_dataout;
		end
		niOO_clk_prev <= rxclk;
	end
	assign
		wire_niOO_CLRN = (nl0llO22 ^ nl0llO21),
		wire_niOO_PRN = ((nl0lll24 ^ nl0lll23) & (~ resetall));
	event n00li_event;
	event nl1i_event;
	event nl1ll_event;
	event nlOiO_event;
	event nlOli_event;
	event nlOll_event;
	event nlOOl_event;
	initial
		#1 ->n00li_event;
	initial
		#1 ->nl1i_event;
	initial
		#1 ->nl1ll_event;
	initial
		#1 ->nlOiO_event;
	initial
		#1 ->nlOli_event;
	initial
		#1 ->nlOll_event;
	initial
		#1 ->nlOOl_event;
	always @(n00li_event)
		n00li <= 1;
	always @(nl1i_event)
		nl1i <= 1;
	always @(nl1ll_event)
		nl1ll <= 1;
	always @(nlOiO_event)
		nlOiO <= 1;
	always @(nlOli_event)
		nlOli <= 1;
	always @(nlOll_event)
		nlOll <= 1;
	always @(nlOOl_event)
		nlOOl <= 1;
	or(wire_n000i_dataout, nlOOi, nl0iii);
	or(wire_n000l_dataout, nlOOl, nl0iii);
	or(wire_n001i_dataout, nlOli, nl0iii);
	or(wire_n001l_dataout, nlOll, nl0iii);
	or(wire_n001O_dataout, nlOlO, nl0iii);
	assign		wire_n00i_dataout = (nl0O0l === 1'b1) ? rxctrl[0] : wire_n0Oi_dataout;
	assign		wire_n00l_dataout = (nl0O0l === 1'b1) ? rxdatain[0] : wire_n0Ol_dataout;
	assign		wire_n00O_dataout = (nl0O0l === 1'b1) ? rxdatain[1] : wire_n0OO_dataout;
	assign		wire_n010i_dataout = (nl0ili === 1'b1) ? wire_n01Oi_dataout : nlOii;
	assign		wire_n010l_dataout = (nl0ili === 1'b1) ? wire_n01Ol_dataout : nlOil;
	assign		wire_n010O_dataout = (nl0ili === 1'b1) ? wire_n01OO_dataout : nlOiO;
	and(wire_n011i_dataout, wire_n01li_dataout, ~(nl1i));
	or(wire_n011l_dataout, wire_n01ll_dataout, nl1i);
	assign		wire_n011O_dataout = (nl0ili === 1'b1) ? wire_n01lO_dataout : nl1ll;
	and(wire_n01i_dataout, wire_n0li_dataout, ~(wire_nill_dataout));
	assign		wire_n01ii_dataout = (nl0ili === 1'b1) ? wire_n001i_dataout : nlOli;
	assign		wire_n01il_dataout = (nl0ili === 1'b1) ? wire_n001l_dataout : nlOll;
	assign		wire_n01iO_dataout = (nl0ili === 1'b1) ? wire_n001O_dataout : nlOlO;
	and(wire_n01l_dataout, wire_n0ll_dataout, ~(wire_nill_dataout));
	assign		wire_n01li_dataout = (nl0ili === 1'b1) ? wire_n000i_dataout : nlOOi;
	assign		wire_n01ll_dataout = (nl0ili === 1'b1) ? wire_n000l_dataout : nlOOl;
	or(wire_n01lO_dataout, nl1ll, nl0iii);
	and(wire_n01O_dataout, wire_n0lO_dataout, ~(wire_nill_dataout));
	and(wire_n01Oi_dataout, nlOii, ~(nl0iii));
	or(wire_n01Ol_dataout, nlOil, nl0iii);
	or(wire_n01OO_dataout, nlOiO, nl0iii);
	assign		wire_n0i0i_dataout = (niiO === 1'b1) ? wire_n0Oli_dataout : wire_n0l0O_dataout;
	assign		wire_n0i0l_dataout = (niiO === 1'b1) ? wire_n0Oll_dataout : wire_n0iOi_dataout;
	assign		wire_n0i0O_dataout = (niiO === 1'b1) ? wire_n0OlO_dataout : wire_n0iOl_dataout;
	assign		wire_n0ii_dataout = (nl0O0l === 1'b1) ? rxdatain[2] : wire_ni1i_dataout;
	assign		wire_n0iii_dataout = (niiO === 1'b1) ? wire_n0OOi_dataout : wire_n0iOO_dataout;
	assign		wire_n0iil_dataout = (niiO === 1'b1) ? wire_n0OOl_dataout : wire_n0l1i_dataout;
	assign		wire_n0iiO_dataout = (niiO === 1'b1) ? wire_n0OOO_dataout : wire_n0l1l_dataout;
	assign		wire_n0il_dataout = (nl0O0l === 1'b1) ? rxdatain[3] : wire_ni1l_dataout;
	assign		wire_n0ili_dataout = (niiO === 1'b1) ? wire_ni11i_dataout : wire_n0l1O_dataout;
	assign		wire_n0ill_dataout = (niiO === 1'b1) ? wire_ni11l_dataout : wire_n0l0i_dataout;
	assign		wire_n0ilO_dataout = (niiO === 1'b1) ? wire_ni11O_dataout : wire_n0l0l_dataout;
	assign		wire_n0iO_dataout = (nl0O0l === 1'b1) ? rxdatain[4] : wire_ni1O_dataout;
	or(wire_n0iOi_dataout, wire_n0lil_dataout, (~ nl0lOi));
	and(wire_n0iOl_dataout, wire_n0liO_dataout, ~((~ nl0lOi)));
	and(wire_n0iOO_dataout, wire_n0lli_dataout, ~((~ nl0lOi)));
	and(wire_n0l0i_dataout, wire_n0lOl_dataout, ~((~ nl0lOi)));
	and(wire_n0l0l_dataout, wire_n0lOO_dataout, ~((~ nl0lOi)));
	and(wire_n0l0O_dataout, wire_n0lii_dataout, ~((~ nl0lOi)));
	and(wire_n0l1i_dataout, wire_n0lll_dataout, ~((~ nl0lOi)));
	and(wire_n0l1l_dataout, wire_n0llO_dataout, ~((~ nl0lOi)));
	and(wire_n0l1O_dataout, wire_n0lOi_dataout, ~((~ nl0lOi)));
	assign		wire_n0li_dataout = (nl0O0l === 1'b1) ? rxdatain[5] : wire_ni0i_dataout;
	or(wire_n0lii_dataout, wire_n0O1i_dataout, nl0OiO);
	or(wire_n0lil_dataout, wire_n0O1l_dataout, nl0OiO);
	or(wire_n0liO_dataout, wire_n0O1O_dataout, nl0OiO);
	assign		wire_n0ll_dataout = (nl0O0l === 1'b1) ? rxdatain[6] : wire_ni0l_dataout;
	or(wire_n0lli_dataout, wire_n0O0i_dataout, nl0OiO);
	and(wire_n0lll_dataout, wire_n0O0l_dataout, ~(nl0OiO));
	and(wire_n0llO_dataout, wire_n0O0O_dataout, ~(nl0OiO));
	assign		wire_n0lO_dataout = (nl0O0l === 1'b1) ? rxdatain[7] : wire_ni0O_dataout;
	and(wire_n0lOi_dataout, wire_n0Oii_dataout, ~(nl0OiO));
	and(wire_n0lOl_dataout, wire_n0Oil_dataout, ~(nl0OiO));
	and(wire_n0lOO_dataout, wire_n0OiO_dataout, ~(nl0OiO));
	or(wire_n0O0i_dataout, rxdatain[26], wire_nl0l_dataout);
	or(wire_n0O0l_dataout, rxdatain[27], wire_nl0l_dataout);
	or(wire_n0O0O_dataout, rxdatain[28], wire_nl0l_dataout);
	or(wire_n0O1i_dataout, rxctrl[3], wire_nl0l_dataout);
	and(wire_n0O1l_dataout, rxdatain[24], ~(wire_nl0l_dataout));
	or(wire_n0O1O_dataout, rxdatain[25], wire_nl0l_dataout);
	or(wire_n0Oi_dataout, rxctrl[0], wire_nl1l_dataout);
	or(wire_n0Oii_dataout, rxdatain[29], wire_nl0l_dataout);
	or(wire_n0Oil_dataout, rxdatain[30], wire_nl0l_dataout);
	or(wire_n0OiO_dataout, rxdatain[31], wire_nl0l_dataout);
	and(wire_n0Ol_dataout, rxdatain[0], ~(wire_nl1l_dataout));
	and(wire_n0Oli_dataout, wire_ni10i_dataout, ~((~ nl0lOi)));
	or(wire_n0Oll_dataout, wire_ni10l_dataout, (~ nl0lOi));
	and(wire_n0OlO_dataout, wire_ni10O_dataout, ~((~ nl0lOi)));
	or(wire_n0OO_dataout, rxdatain[1], wire_nl1l_dataout);
	and(wire_n0OOi_dataout, wire_ni1ii_dataout, ~((~ nl0lOi)));
	and(wire_n0OOl_dataout, wire_ni1il_dataout, ~((~ nl0lOi)));
	and(wire_n0OOO_dataout, wire_ni1iO_dataout, ~((~ nl0lOi)));
	assign		wire_n100i_dataout = (nl0O0l === 1'b1) ? wire_n1l0i_dataout : wire_n10Oi_dataout;
	assign		wire_n100l_dataout = (nl0O0l === 1'b1) ? wire_n1l0l_dataout : wire_n10Ol_dataout;
	assign		wire_n100O_dataout = (nl0O0l === 1'b1) ? wire_n1l0O_dataout : wire_n10OO_dataout;
	and(wire_n101i_dataout, wire_n10li_dataout, ~(nl1i));
	and(wire_n101l_dataout, wire_n10ll_dataout, ~(nl1i));
	and(wire_n101O_dataout, wire_n10lO_dataout, ~(nl1i));
	or(wire_n10i_dataout, wire_n1Oi_dataout, (~ nl0lOi));
	assign		wire_n10ii_dataout = (nl0O0l === 1'b1) ? wire_n1lii_dataout : wire_n1i1i_dataout;
	assign		wire_n10il_dataout = (nl0O0l === 1'b1) ? wire_n1lil_dataout : wire_n1i1l_dataout;
	assign		wire_n10iO_dataout = (nl0O0l === 1'b1) ? wire_n1liO_dataout : wire_n1i1O_dataout;
	or(wire_n10l_dataout, wire_n1Ol_dataout, (~ nl0lOi));
	assign		wire_n10li_dataout = (nl0O0l === 1'b1) ? wire_n1lli_dataout : wire_n1i0i_dataout;
	assign		wire_n10ll_dataout = (nl0O0l === 1'b1) ? wire_n1lll_dataout : wire_n1i0l_dataout;
	assign		wire_n10lO_dataout = (nl0O0l === 1'b1) ? wire_n1llO_dataout : wire_n1i0O_dataout;
	or(wire_n10O_dataout, wire_n1OO_dataout, (~ nl0lOi));
	assign		wire_n10Oi_dataout = (nl0i0i === 1'b1) ? wire_n1iii_dataout : ni0ii;
	assign		wire_n10Ol_dataout = (nl0i0i === 1'b1) ? wire_n1iil_dataout : nl11O;
	assign		wire_n10OO_dataout = (nl0i0i === 1'b1) ? wire_n1iiO_dataout : nl10i;
	or(wire_n11i_dataout, wire_n1li_dataout, (~ nl0lOi));
	and(wire_n11l_dataout, wire_n1ll_dataout, ~((~ nl0lOi)));
	and(wire_n11li_dataout, wire_n100i_dataout, ~(nl1i));
	and(wire_n11ll_dataout, wire_n100l_dataout, ~(nl1i));
	and(wire_n11lO_dataout, wire_n100O_dataout, ~(nl1i));
	and(wire_n11O_dataout, wire_n1lO_dataout, ~((~ nl0lOi)));
	and(wire_n11Oi_dataout, wire_n10ii_dataout, ~(nl1i));
	and(wire_n11Ol_dataout, wire_n10il_dataout, ~(nl1i));
	and(wire_n11OO_dataout, wire_n10iO_dataout, ~(nl1i));
	assign		wire_n1i0i_dataout = (nl0i0i === 1'b1) ? wire_n1iOi_dataout : nl1il;
	assign		wire_n1i0l_dataout = (nl0i0i === 1'b1) ? wire_n1iOl_dataout : nl1iO;
	assign		wire_n1i0O_dataout = (nl0i0i === 1'b1) ? wire_n1iOO_dataout : nl1li;
	assign		wire_n1i1i_dataout = (nl0i0i === 1'b1) ? wire_n1ili_dataout : nl10l;
	assign		wire_n1i1l_dataout = (nl0i0i === 1'b1) ? wire_n1ill_dataout : nl10O;
	assign		wire_n1i1O_dataout = (nl0i0i === 1'b1) ? wire_n1ilO_dataout : nl1ii;
	and(wire_n1ii_dataout, wire_n01i_dataout, ~((~ nl0lOi)));
	or(wire_n1iii_dataout, ni0ii, nl00Ol);
	and(wire_n1iil_dataout, nl11O, ~(nl00Ol));
	or(wire_n1iiO_dataout, nl10i, nl00Ol);
	and(wire_n1il_dataout, wire_n01l_dataout, ~((~ nl0lOi)));
	or(wire_n1ili_dataout, nl10l, nl00Ol);
	or(wire_n1ill_dataout, nl10O, nl00Ol);
	or(wire_n1ilO_dataout, nl1ii, nl00Ol);
	or(wire_n1iO_dataout, wire_n01O_dataout, (~ nl0lOi));
	or(wire_n1iOi_dataout, nl1il, nl00Ol);
	or(wire_n1iOl_dataout, nl1iO, nl00Ol);
	or(wire_n1iOO_dataout, nl1li, nl00Ol);
	or(wire_n1l0i_dataout, ni0ii, nl0i0l);
	and(wire_n1l0l_dataout, nl11O, ~(nl0i0l));
	or(wire_n1l0O_dataout, nl10i, nl0i0l);
	or(wire_n1li_dataout, wire_n00i_dataout, wire_nill_dataout);
	or(wire_n1lii_dataout, nl10l, nl0i0l);
	or(wire_n1lil_dataout, nl10O, nl0i0l);
	or(wire_n1liO_dataout, nl1ii, nl0i0l);
	or(wire_n1ll_dataout, wire_n00l_dataout, wire_nill_dataout);
	or(wire_n1lli_dataout, nl1il, nl0i0l);
	or(wire_n1lll_dataout, nl1iO, nl0i0l);
	or(wire_n1llO_dataout, nl1li, nl0i0l);
	or(wire_n1lO_dataout, wire_n00O_dataout, wire_nill_dataout);
	or(wire_n1Oi_dataout, wire_n0ii_dataout, wire_nill_dataout);
	or(wire_n1OiO_dataout, wire_n011O_dataout, nl1i);
	and(wire_n1Ol_dataout, wire_n0il_dataout, ~(wire_nill_dataout));
	and(wire_n1Oli_dataout, wire_n010i_dataout, ~(nl1i));
	and(wire_n1Oll_dataout, wire_n010l_dataout, ~(nl1i));
	or(wire_n1OlO_dataout, wire_n010O_dataout, nl1i);
	and(wire_n1OO_dataout, wire_n0iO_dataout, ~(wire_nill_dataout));
	or(wire_n1OOi_dataout, wire_n01ii_dataout, nl1i);
	or(wire_n1OOl_dataout, wire_n01il_dataout, nl1i);
	and(wire_n1OOO_dataout, wire_n01iO_dataout, ~(nl1i));
	or(wire_ni0i_dataout, rxdatain[5], wire_nl1l_dataout);
	assign		wire_ni0il_dataout = (niiO === 1'b1) ? wire_nilOl_dataout : wire_nii1l_dataout;
	assign		wire_ni0iO_dataout = (niiO === 1'b1) ? wire_nilOO_dataout : wire_nii1O_dataout;
	or(wire_ni0l_dataout, rxdatain[6], wire_nl1l_dataout);
	assign		wire_ni0li_dataout = (niiO === 1'b1) ? wire_niO1i_dataout : wire_nii0i_dataout;
	assign		wire_ni0ll_dataout = (niiO === 1'b1) ? wire_niO1l_dataout : wire_nii0l_dataout;
	assign		wire_ni0lO_dataout = (niiO === 1'b1) ? wire_niO1O_dataout : wire_nii0O_dataout;
	or(wire_ni0O_dataout, rxdatain[7], wire_nl1l_dataout);
	assign		wire_ni0Oi_dataout = (niiO === 1'b1) ? wire_niO0i_dataout : wire_niiii_dataout;
	assign		wire_ni0Ol_dataout = (niiO === 1'b1) ? wire_niO0l_dataout : wire_niiil_dataout;
	assign		wire_ni0OO_dataout = (niiO === 1'b1) ? wire_niO0O_dataout : wire_niiiO_dataout;
	or(wire_ni10i_dataout, wire_n0O1i_dataout, nl0iOi);
	or(wire_ni10l_dataout, wire_n0O1l_dataout, nl0iOi);
	or(wire_ni10O_dataout, wire_n0O1O_dataout, nl0iOi);
	and(wire_ni11i_dataout, wire_ni1li_dataout, ~((~ nl0lOi)));
	and(wire_ni11l_dataout, wire_ni1ll_dataout, ~((~ nl0lOi)));
	and(wire_ni11O_dataout, wire_ni1lO_dataout, ~((~ nl0lOi)));
	or(wire_ni1i_dataout, rxdatain[2], wire_nl1l_dataout);
	or(wire_ni1ii_dataout, wire_n0O0i_dataout, nl0iOi);
	and(wire_ni1il_dataout, wire_n0O0l_dataout, ~(nl0iOi));
	and(wire_ni1iO_dataout, wire_n0O0O_dataout, ~(nl0iOi));
	or(wire_ni1l_dataout, rxdatain[3], wire_nl1l_dataout);
	and(wire_ni1li_dataout, wire_n0Oii_dataout, ~(nl0iOi));
	and(wire_ni1ll_dataout, wire_n0Oil_dataout, ~(nl0iOi));
	and(wire_ni1lO_dataout, wire_n0OiO_dataout, ~(nl0iOi));
	or(wire_ni1O_dataout, rxdatain[4], wire_nl1l_dataout);
	and(wire_nii0i_dataout, wire_niiOi_dataout, ~((~ nl0lOi)));
	and(wire_nii0l_dataout, wire_niiOl_dataout, ~((~ nl0lOi)));
	and(wire_nii0O_dataout, wire_niiOO_dataout, ~((~ nl0lOi)));
	assign		wire_nii1i_dataout = (niiO === 1'b1) ? wire_niOii_dataout : wire_niili_dataout;
	and(wire_nii1l_dataout, wire_niill_dataout, ~((~ nl0lOi)));
	or(wire_nii1O_dataout, wire_niilO_dataout, (~ nl0lOi));
	and(wire_niiii_dataout, wire_nil1i_dataout, ~((~ nl0lOi)));
	and(wire_niiil_dataout, wire_nil1l_dataout, ~((~ nl0lOi)));
	and(wire_niiiO_dataout, wire_nil1O_dataout, ~((~ nl0lOi)));
	and(wire_niili_dataout, wire_nil0i_dataout, ~((~ nl0lOi)));
	or(wire_niill_dataout, wire_nil0l_dataout, nl0OiO);
	or(wire_niilO_dataout, wire_nil0O_dataout, nl0OiO);
	or(wire_niiOi_dataout, wire_nilii_dataout, nl0OiO);
	or(wire_niiOl_dataout, wire_nilil_dataout, nl0OiO);
	and(wire_niiOO_dataout, wire_niliO_dataout, ~(nl0OiO));
	and(wire_nil0i_dataout, wire_nilOi_dataout, ~(nl0OiO));
	or(wire_nil0l_dataout, rxctrl[2], wire_nl0i_dataout);
	and(wire_nil0O_dataout, rxdatain[16], ~(wire_nl0i_dataout));
	and(wire_nil1i_dataout, wire_nilli_dataout, ~(nl0OiO));
	and(wire_nil1l_dataout, wire_nilll_dataout, ~(nl0OiO));
	and(wire_nil1O_dataout, wire_nillO_dataout, ~(nl0OiO));
	and(wire_nili_dataout, (~ nl0OiO), ~((~ nl0lOi)));
	or(wire_nilii_dataout, rxdatain[17], wire_nl0i_dataout);
	or(wire_nilil_dataout, rxdatain[18], wire_nl0i_dataout);
	or(wire_niliO_dataout, rxdatain[19], wire_nl0i_dataout);
	and(wire_nill_dataout, nl0OiO, ~((~ nl0lOi)));
	or(wire_nilli_dataout, rxdatain[20], wire_nl0i_dataout);
	or(wire_nilll_dataout, rxdatain[21], wire_nl0i_dataout);
	or(wire_nillO_dataout, rxdatain[22], wire_nl0i_dataout);
	or(wire_nilOi_dataout, rxdatain[23], wire_nl0i_dataout);
	and(wire_nilOl_dataout, wire_niOil_dataout, ~((~ nl0lOi)));
	and(wire_nilOO_dataout, wire_niOiO_dataout, ~((~ nl0lOi)));
	and(wire_niO0i_dataout, wire_niOOi_dataout, ~((~ nl0lOi)));
	and(wire_niO0l_dataout, wire_niOOl_dataout, ~((~ nl0lOi)));
	and(wire_niO0O_dataout, wire_niOOO_dataout, ~((~ nl0lOi)));
	and(wire_niO1i_dataout, wire_niOli_dataout, ~((~ nl0lOi)));
	and(wire_niO1l_dataout, wire_niOll_dataout, ~((~ nl0lOi)));
	and(wire_niO1O_dataout, wire_niOlO_dataout, ~((~ nl0lOi)));
	and(wire_niOii_dataout, wire_nl11i_dataout, ~((~ nl0lOi)));
	or(wire_niOil_dataout, wire_nil0l_dataout, nl0iOl);
	or(wire_niOiO_dataout, wire_nil0O_dataout, nl0iOl);
	or(wire_niOli_dataout, wire_nilii_dataout, nl0iOl);
	or(wire_niOll_dataout, wire_nilil_dataout, nl0iOl);
	and(wire_niOlO_dataout, wire_niliO_dataout, ~(nl0iOl));
	and(wire_niOOi_dataout, wire_nilli_dataout, ~(nl0iOl));
	and(wire_niOOl_dataout, wire_nilll_dataout, ~(nl0iOl));
	and(wire_niOOO_dataout, wire_nillO_dataout, ~(nl0iOl));
	assign		wire_nl00i_dataout = (niiO === 1'b1) ? wire_nllli_dataout : wire_nl0Oi_dataout;
	assign		wire_nl00l_dataout = (niiO === 1'b1) ? wire_nllll_dataout : wire_nl0Ol_dataout;
	and(wire_nl00O_dataout, wire_nl0OO_dataout, ~((~ nl0lOi)));
	assign		wire_nl01i_dataout = (niiO === 1'b1) ? wire_nllii_dataout : wire_nl0li_dataout;
	assign		wire_nl01l_dataout = (niiO === 1'b1) ? wire_nllil_dataout : wire_nl0ll_dataout;
	assign		wire_nl01O_dataout = (niiO === 1'b1) ? wire_nlliO_dataout : wire_nl0lO_dataout;
	and(wire_nl0i_dataout, rxrunningdisp[2], ~(nl1i));
	and(wire_nl0ii_dataout, wire_nli1i_dataout, ~((~ nl0lOi)));
	and(wire_nl0il_dataout, wire_nli1l_dataout, ~((~ nl0lOi)));
	and(wire_nl0iO_dataout, wire_nli1O_dataout, ~((~ nl0lOi)));
	and(wire_nl0l_dataout, rxrunningdisp[3], ~(nl1i));
	and(wire_nl0li_dataout, wire_nli0i_dataout, ~((~ nl0lOi)));
	and(wire_nl0ll_dataout, wire_nli0l_dataout, ~((~ nl0lOi)));
	and(wire_nl0lO_dataout, wire_nli0O_dataout, ~((~ nl0lOi)));
	and(wire_nl0Oi_dataout, wire_nliii_dataout, ~((~ nl0lOi)));
	and(wire_nl0Ol_dataout, wire_nliil_dataout, ~((~ nl0lOi)));
	or(wire_nl0OO_dataout, wire_nliiO_dataout, nl0OiO);
	and(wire_nl11i_dataout, wire_nilOi_dataout, ~(nl0iOl));
	and(wire_nl1l_dataout, rxrunningdisp[0], ~(nl1i));
	assign		wire_nl1lO_dataout = (niiO === 1'b1) ? wire_nll1O_dataout : wire_nl00O_dataout;
	and(wire_nl1O_dataout, rxrunningdisp[1], ~(nl1i));
	assign		wire_nl1Oi_dataout = (niiO === 1'b1) ? wire_nll0i_dataout : wire_nl0ii_dataout;
	assign		wire_nl1Ol_dataout = (niiO === 1'b1) ? wire_nll0l_dataout : wire_nl0il_dataout;
	assign		wire_nl1OO_dataout = (niiO === 1'b1) ? wire_nll0O_dataout : wire_nl0iO_dataout;
	and(wire_nli0i_dataout, wire_nliOi_dataout, ~(nl0OiO));
	and(wire_nli0l_dataout, wire_nliOl_dataout, ~(nl0OiO));
	and(wire_nli0O_dataout, wire_nliOO_dataout, ~(nl0OiO));
	or(wire_nli1i_dataout, wire_nlili_dataout, nl0OiO);
	or(wire_nli1l_dataout, wire_nlill_dataout, nl0OiO);
	or(wire_nli1O_dataout, wire_nlilO_dataout, nl0OiO);
	and(wire_nliii_dataout, wire_nll1i_dataout, ~(nl0OiO));
	and(wire_nliil_dataout, wire_nll1l_dataout, ~(nl0OiO));
	or(wire_nliiO_dataout, rxctrl[1], wire_nl1O_dataout);
	and(wire_nlili_dataout, rxdatain[8], ~(wire_nl1O_dataout));
	or(wire_nlill_dataout, rxdatain[9], wire_nl1O_dataout);
	or(wire_nlilO_dataout, rxdatain[10], wire_nl1O_dataout);
	or(wire_nliOi_dataout, rxdatain[11], wire_nl1O_dataout);
	or(wire_nliOl_dataout, rxdatain[12], wire_nl1O_dataout);
	or(wire_nliOO_dataout, rxdatain[13], wire_nl1O_dataout);
	and(wire_nll0i_dataout, wire_nllOi_dataout, ~((~ nl0lOi)));
	and(wire_nll0l_dataout, wire_nllOl_dataout, ~((~ nl0lOi)));
	and(wire_nll0O_dataout, wire_nllOO_dataout, ~((~ nl0lOi)));
	or(wire_nll1i_dataout, rxdatain[14], wire_nl1O_dataout);
	or(wire_nll1l_dataout, rxdatain[15], wire_nl1O_dataout);
	and(wire_nll1O_dataout, wire_nlllO_dataout, ~((~ nl0lOi)));
	and(wire_nllii_dataout, wire_nlO1i_dataout, ~((~ nl0lOi)));
	and(wire_nllil_dataout, wire_nlO1l_dataout, ~((~ nl0lOi)));
	and(wire_nlliO_dataout, wire_nlO1O_dataout, ~((~ nl0lOi)));
	and(wire_nllli_dataout, wire_nlO0i_dataout, ~((~ nl0lOi)));
	and(wire_nllll_dataout, wire_nlO0l_dataout, ~((~ nl0lOi)));
	or(wire_nlllO_dataout, wire_nliiO_dataout, nl0l1l);
	and(wire_nllO0i_dataout, wire_nlO10O_dataout, ~(nl1i));
	or(wire_nllO0l_dataout, wire_nllOOi_dataout, nl1i);
	and(wire_nllO0O_dataout, wire_nllOOl_dataout, ~(nl1i));
	or(wire_nllOi_dataout, wire_nlili_dataout, nl0l1l);
	and(wire_nllOii_dataout, wire_nllOOO_dataout, ~(nl1i));
	and(wire_nllOil_dataout, wire_nlO11i_dataout, ~(nl1i));
	and(wire_nllOiO_dataout, wire_nlO11l_dataout, ~(nl1i));
	or(wire_nllOl_dataout, wire_nlill_dataout, nl0l1l);
	and(wire_nllOli_dataout, wire_nlO11O_dataout, ~(nl1i));
	and(wire_nllOll_dataout, wire_nlO10i_dataout, ~(nl1i));
	and(wire_nllOlO_dataout, wire_nlO10l_dataout, ~(nl1i));
	or(wire_nllOO_dataout, wire_nlilO_dataout, nl0l1l);
	assign		wire_nllOOi_dataout = (nl00il === 1'b1) ? wire_nlO1ii_dataout : n00li;
	assign		wire_nllOOl_dataout = (nl00il === 1'b1) ? wire_nlO1il_dataout : n00ll;
	assign		wire_nllOOO_dataout = (nl00il === 1'b1) ? wire_nlO1iO_dataout : n00lO;
	and(wire_nlO0i_dataout, wire_nll1i_dataout, ~(nl0l1l));
	and(wire_nlO0l_dataout, wire_nll1l_dataout, ~(nl0l1l));
	and(wire_nlO0Oi_dataout, wire_nlOiii_dataout, ~(nl1i));
	and(wire_nlO0Ol_dataout, wire_nlOiil_dataout, ~(nl1i));
	and(wire_nlO0OO_dataout, wire_nlOiiO_dataout, ~(nl1i));
	assign		wire_nlO10i_dataout = (nl00il === 1'b1) ? wire_nlO1Oi_dataout : n0i1i;
	assign		wire_nlO10l_dataout = (nl00il === 1'b1) ? wire_nlO1Ol_dataout : n0i1l;
	assign		wire_nlO10O_dataout = (nl00il === 1'b1) ? wire_nlO1OO_dataout : n1Oil;
	assign		wire_nlO11i_dataout = (nl00il === 1'b1) ? wire_nlO1li_dataout : n00Oi;
	assign		wire_nlO11l_dataout = (nl00il === 1'b1) ? wire_nlO1ll_dataout : n00Ol;
	assign		wire_nlO11O_dataout = (nl00il === 1'b1) ? wire_nlO1lO_dataout : n00OO;
	and(wire_nlO1i_dataout, wire_nliOi_dataout, ~(nl0l1l));
	and(wire_nlO1ii_dataout, n00li, ~(nl00ii));
	or(wire_nlO1il_dataout, n00ll, nl00ii);
	or(wire_nlO1iO_dataout, n00lO, nl00ii);
	and(wire_nlO1l_dataout, wire_nliOl_dataout, ~(nl0l1l));
	or(wire_nlO1li_dataout, n00Oi, nl00ii);
	or(wire_nlO1ll_dataout, n00Ol, nl00ii);
	or(wire_nlO1lO_dataout, n00OO, nl00ii);
	and(wire_nlO1O_dataout, wire_nliOO_dataout, ~(nl0l1l));
	or(wire_nlO1Oi_dataout, n0i1i, nl00ii);
	or(wire_nlO1Ol_dataout, n0i1l, nl00ii);
	or(wire_nlO1OO_dataout, n1Oil, nl00ii);
	and(wire_nlOi0i_dataout, wire_nlOiOi_dataout, ~(nl1i));
	and(wire_nlOi0l_dataout, wire_nlOiOl_dataout, ~(nl1i));
	and(wire_nlOi0O_dataout, wire_nlOiOO_dataout, ~(nl1i));
	and(wire_nlOi1i_dataout, wire_nlOili_dataout, ~(nl1i));
	and(wire_nlOi1l_dataout, wire_nlOill_dataout, ~(nl1i));
	and(wire_nlOi1O_dataout, wire_nlOilO_dataout, ~(nl1i));
	assign		wire_nlOiii_dataout = (nl00ll === 1'b1) ? wire_nlOO0O_dataout : wire_nlOl1i_dataout;
	assign		wire_nlOiil_dataout = (nl00ll === 1'b1) ? wire_nlOOii_dataout : wire_nlOl1l_dataout;
	assign		wire_nlOiiO_dataout = (nl00ll === 1'b1) ? wire_nlOOil_dataout : wire_nlOl1O_dataout;
	assign		wire_nlOili_dataout = (nl00ll === 1'b1) ? wire_nlOOiO_dataout : wire_nlOl0i_dataout;
	assign		wire_nlOill_dataout = (nl00ll === 1'b1) ? wire_nlOOli_dataout : wire_nlOl0l_dataout;
	assign		wire_nlOilO_dataout = (nl00ll === 1'b1) ? wire_nlOOll_dataout : wire_nlOl0O_dataout;
	assign		wire_nlOiOi_dataout = (nl00ll === 1'b1) ? wire_nlOOlO_dataout : wire_nlOlii_dataout;
	assign		wire_nlOiOl_dataout = (nl00ll === 1'b1) ? wire_nlOOOi_dataout : wire_nlOlil_dataout;
	assign		wire_nlOiOO_dataout = (nl00ll === 1'b1) ? wire_nlOOOl_dataout : wire_nlOliO_dataout;
	assign		wire_nlOl0i_dataout = (nlOOO === 1'b1) ? wire_nlOlOi_dataout : ni01i;
	assign		wire_nlOl0l_dataout = (nlOOO === 1'b1) ? wire_nlOlOl_dataout : ni01l;
	assign		wire_nlOl0O_dataout = (nlOOO === 1'b1) ? wire_nlOlOO_dataout : ni01O;
	assign		wire_nlOl1i_dataout = (nlOOO === 1'b1) ? wire_nlOlli_dataout : n0i1O;
	assign		wire_nlOl1l_dataout = (nlOOO === 1'b1) ? wire_nlOlll_dataout : ni1Ol;
	assign		wire_nlOl1O_dataout = (nlOOO === 1'b1) ? wire_nlOllO_dataout : ni1OO;
	assign		wire_nlOlii_dataout = (nlOOO === 1'b1) ? wire_nlOO1i_dataout : ni00i;
	assign		wire_nlOlil_dataout = (nlOOO === 1'b1) ? wire_nlOO1l_dataout : ni00l;
	assign		wire_nlOliO_dataout = (nlOOO === 1'b1) ? wire_nlOO1O_dataout : ni00O;
	or(wire_nlOlli_dataout, n0i1O, nl00lO);
	and(wire_nlOlll_dataout, ni1Ol, ~(nl00lO));
	or(wire_nlOllO_dataout, ni1OO, nl00lO);
	or(wire_nlOlOi_dataout, ni01i, nl00lO);
	or(wire_nlOlOl_dataout, ni01l, nl00lO);
	or(wire_nlOlOO_dataout, ni01O, nl00lO);
	or(wire_nlOO0O_dataout, n0i1O, nl00Oi);
	or(wire_nlOO1i_dataout, ni00i, nl00lO);
	or(wire_nlOO1l_dataout, ni00l, nl00lO);
	or(wire_nlOO1O_dataout, ni00O, nl00lO);
	and(wire_nlOOii_dataout, ni1Ol, ~(nl00Oi));
	or(wire_nlOOil_dataout, ni1OO, nl00Oi);
	or(wire_nlOOiO_dataout, ni01i, nl00Oi);
	or(wire_nlOOli_dataout, ni01l, nl00Oi);
	or(wire_nlOOll_dataout, ni01O, nl00Oi);
	or(wire_nlOOlO_dataout, ni00i, nl00Oi);
	or(wire_nlOOOi_dataout, ni00l, nl00Oi);
	or(wire_nlOOOl_dataout, ni00O, nl00Oi);
	assign
		nl00ii = (nli01O | wire_nl0l_dataout),
		nl00il = ((nl0lOl | nl00ll) | (~ (nl00iO44 ^ nl00iO43))),
		nl00ll = (nl0O0l | nl0O1i),
		nl00lO = (wire_nl0i_dataout | (nli00l & nli1li)),
		nl00Oi = (nli00l | wire_nl0i_dataout),
		nl00Ol = ((wire_nl1O_dataout | ((nli0iO & nli1lO) & (nl0i1l40 ^ nl0i1l39))) | (~ (nl00OO42 ^ nl00OO41))),
		nl0i0i = (niii | nlOOO),
		nl0i0l = (nli0iO | wire_nl1O_dataout),
		nl0iii = (wire_nl1l_dataout | ((nli0ll & nli1Ol) & (nl0iil36 ^ nl0iil35))),
		nl0ili = (nlOOO | ((niil | niii) | (~ (nl0ill34 ^ nl0ill33)))),
		nl0iOi = (nl0lOl | nl0iOl),
		nl0iOl = ((nl0O1i | nl0l1l) | (~ (nl0iOO32 ^ nl0iOO31))),
		nl0l1l = ((nl0OiO | nl0O0l) | (~ (nl0l1O30 ^ nl0l1O29))),
		nl0lii = (((((((rxdatain[24] & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & rxdatain[29]) & rxdatain[30]) & rxdatain[31]),
		nl0lli = 1'b1,
		nl0lOi = ((((rxdatavalid[0] & rxdatavalid[1]) & rxdatavalid[2]) & rxdatavalid[3]) & (nl0lil26 ^ nl0lil25)),
		nl0lOl = ((rxctrl[2] & nl0lOO) & (~ wire_nl0i_dataout)),
		nl0lOO = (((((((rxdatain[16] & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & rxdatain[21]) & rxdatain[22]) & rxdatain[23]),
		nl0O0i = (((((((rxdatain[8] & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & rxdatain[13]) & rxdatain[14]) & rxdatain[15]),
		nl0O0l = (((rxctrl[0] & nl0Oil) & (~ wire_nl1l_dataout)) & (nl0O0O18 ^ nl0O0O17)),
		nl0O1i = (((rxctrl[1] & nl0O0i) & (nl0O1l20 ^ nl0O1l19)) & (~ wire_nl1O_dataout)),
		nl0Oil = (((((((rxdatain[0] & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & rxdatain[5]) & rxdatain[6]) & rxdatain[7]),
		nl0OiO = (((~ ((((nli1Ol | nli1lO) | nli1li) | (((~ rxctrl[3]) | (~ nli1iO)) | (~ (nli1ii8 ^ nli1ii7)))) | (~ (nli10l10 ^ nli10l9)))) | (~ ((((nli0ll | nli0iO) | nli00l) | nli01O) | (~ (nli11O12 ^ nli11O11))))) | (~ (((((((~ rxctrl[0]) | (~ nli11l)) | (~ (nl0OOO14 ^ nl0OOO13))) | ((~ rxctrl[1]) | (~ nl0OOl))) | ((~ rxctrl[2]) | (~ nl0OOi))) | ((~ rxctrl[3]) | (~ nl0OlO))) | (~ (nl0Oli16 ^ nl0Oli15))))),
		nl0OlO = ((((((((~ rxdatain[24]) & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & (~ rxdatain[29])) & (~ rxdatain[30])) & (~ rxdatain[31])),
		nl0OOi = ((((((((~ rxdatain[16]) & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & (~ rxdatain[21])) & (~ rxdatain[22])) & (~ rxdatain[23])),
		nl0OOl = ((((((((~ rxdatain[8]) & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & (~ rxdatain[13])) & (~ rxdatain[14])) & (~ rxdatain[15])),
		nli00i = ((((((((~ rxdatain[24]) & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & rxdatain[29]) & (~ rxdatain[30])) & rxdatain[31]),
		nli00l = (((~ rxctrl[2]) | (~ nli0il)) | (~ (nli00O4 ^ nli00O3))),
		nli01l = ((((((((~ rxdatain[0]) & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & rxdatain[5]) & rxdatain[6]) & (~ rxdatain[7])),
		nli01O = ((~ rxctrl[3]) | (~ nli00i)),
		nli0il = ((((((((~ rxdatain[16]) & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & rxdatain[21]) & (~ rxdatain[22])) & rxdatain[23]),
		nli0iO = ((~ rxctrl[1]) | (~ nli0li)),
		nli0li = ((((((((~ rxdatain[8]) & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & rxdatain[13]) & (~ rxdatain[14])) & rxdatain[15]),
		nli0ll = (((~ rxctrl[0]) | (~ nlii1i)) | (~ (nli0lO2 ^ nli0lO1))),
		nli11l = ((((((((~ rxdatain[0]) & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & (~ rxdatain[5])) & (~ rxdatain[6])) & (~ rxdatain[7])),
		nli1iO = ((((((((~ rxdatain[24]) & (~ rxdatain[25])) & rxdatain[26]) & rxdatain[27]) & rxdatain[28]) & rxdatain[29]) & rxdatain[30]) & (~ rxdatain[31])),
		nli1li = ((~ rxctrl[2]) | (~ nli1ll)),
		nli1ll = ((((((((~ rxdatain[16]) & (~ rxdatain[17])) & rxdatain[18]) & rxdatain[19]) & rxdatain[20]) & rxdatain[21]) & rxdatain[22]) & (~ rxdatain[23])),
		nli1lO = ((~ rxctrl[1]) | (~ nli1Oi)),
		nli1Oi = ((((((((~ rxdatain[8]) & (~ rxdatain[9])) & rxdatain[10]) & rxdatain[11]) & rxdatain[12]) & rxdatain[13]) & rxdatain[14]) & (~ rxdatain[15])),
		nli1Ol = (((~ rxctrl[0]) | (~ nli01l)) | (~ (nli1OO6 ^ nli1OO5))),
		nlii1i = (((((((((~ rxdatain[0]) & (~ rxdatain[1])) & rxdatain[2]) & rxdatain[3]) & rxdatain[4]) & rxdatain[5]) & (~ rxdatain[6])) & rxdatain[7]) & (nl000l46 ^ nl000l45)),
		rxctrlout = {niOl, nllO1O, nlO0lO, n11iO},
		rxdataout = {nllO1l, nllO1i, nlllOO, nlllOl, nlllOi, nllllO, nlllll, nlllli, nlO0ll, nlO0li, nlO0iO, nlO0il, nlO0ii, nlO00O, nlO00l, nlO00i, n11il, n11ii, n110O, n110l, n110i, n111O, n111l, n111i, n1Oii, n1O0l, n1O0i, n1O1O, n1O1l, n1O1i, n1lOO, n1lOl};
endmodule //stratixgx_xgm_rx_sm
//synopsys translate_on
//VALID FILE
//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 59 mux21 20 oper_selector 10 
`timescale 1 ps / 1 ps
module  stratixgx_xgm_dskw_sm
	( 
	adet,
	alignstatus,
	enabledeskew,
	fiforesetrd,
	rdalign,
	recovclk,
	resetall,
	syncstatus) /* synthesis synthesis_clearbox=1 */;
	input   [3:0]  adet;
	output   alignstatus;
	output   enabledeskew;
	output   fiforesetrd;
	input   [3:0]  rdalign;
	input   recovclk;
	input   resetall;
	input   [3:0]  syncstatus;

	reg	nl00O43;
	reg	nl00O44;
	reg	nl0il41;
	reg	nl0il42;
	reg	nl0li39;
	reg	nl0li40;
	reg	nl0Oi37;
	reg	nl0Oi38;
	reg	nl0Ol35;
	reg	nl0Ol36;
	reg	nli0l29;
	reg	nli0l30;
	reg	nli1i33;
	reg	nli1i34;
	reg	nli1O31;
	reg	nli1O32;
	reg	nliil27;
	reg	nliil28;
	reg	nlili25;
	reg	nlili26;
	reg	nlilO23;
	reg	nlilO24;
	reg	nliOl21;
	reg	nliOl22;
	reg	nliOO19;
	reg	nliOO20;
	reg	nll0l13;
	reg	nll0l14;
	reg	nll1i17;
	reg	nll1i18;
	reg	nll1l15;
	reg	nll1l16;
	reg	nlliO11;
	reg	nlliO12;
	reg	nllll10;
	reg	nllll9;
	reg	nllOi7;
	reg	nllOi8;
	reg	nllOO5;
	reg	nllOO6;
	reg	nlO0l1;
	reg	nlO0l2;
	reg	nlO1l3;
	reg	nlO1l4;
	reg	n0i;
	reg	n1i;
	reg	n1l;
	reg	nlOO;
	wire	wire_n1O_PRN;
	reg	n0l;
	reg	nii;
	reg	nil;
	reg	nli;
	reg	nlil;
	reg	nliO;
	reg	nlli;
	reg	nlll;
	reg	nllO;
	reg	nlOi;
	reg	nlOl;
	wire	wire_niO_CLRN;
	wire	wire_n0Ol_dataout;
	wire	wire_n0OO_dataout;
	wire	wire_ni0i_dataout;
	wire	wire_ni0l_dataout;
	wire	wire_ni0O_dataout;
	wire	wire_ni1i_dataout;
	wire	wire_ni1l_dataout;
	wire	wire_niii_dataout;
	wire	wire_niil_dataout;
	wire	wire_niiO_dataout;
	wire	wire_nili_dataout;
	wire	wire_nill_dataout;
	wire	wire_nilO_dataout;
	wire	wire_niOi_dataout;
	wire	wire_niOl_dataout;
	wire	wire_niOO_dataout;
	wire	wire_nl0O_dataout;
	wire	wire_nl1i_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1O_dataout;
	wire  wire_n00l_o;
	wire  wire_n01i_o;
	wire  wire_n01O_o;
	wire  wire_n0ii_o;
	wire  wire_n0iO_o;
	wire  wire_n0ll_o;
	wire  wire_n0Oi_o;
	wire  wire_n1ll_o;
	wire  wire_n1Oi_o;
	wire  wire_n1Ol_o;
	wire  nl0ii;
	wire  nl0ll;
	wire  nl0lO;
	wire  nl0OO;
	wire  nli0i;
	wire  nliii;
	wire  nlill;
	wire  nll0i;
	wire  nll1O;
	wire  nllii;
	wire  nllil;
	wire  nllOl;
	wire  nlO0i;
	wire  nlO1i;

	initial
		nl00O43 = 0;
	always @ ( posedge recovclk)
		  nl00O43 <= nl00O44;
	event nl00O43_event;
	initial
		#1 ->nl00O43_event;
	always @(nl00O43_event)
		nl00O43 <= {1{1'b1}};
	initial
		nl00O44 = 0;
	always @ ( posedge recovclk)
		  nl00O44 <= nl00O43;
	initial
		nl0il41 = 0;
	always @ ( posedge recovclk)
		  nl0il41 <= nl0il42;
	event nl0il41_event;
	initial
		#1 ->nl0il41_event;
	always @(nl0il41_event)
		nl0il41 <= {1{1'b1}};
	initial
		nl0il42 = 0;
	always @ ( posedge recovclk)
		  nl0il42 <= nl0il41;
	initial
		nl0li39 = 0;
	always @ ( posedge recovclk)
		  nl0li39 <= nl0li40;
	event nl0li39_event;
	initial
		#1 ->nl0li39_event;
	always @(nl0li39_event)
		nl0li39 <= {1{1'b1}};
	initial
		nl0li40 = 0;
	always @ ( posedge recovclk)
		  nl0li40 <= nl0li39;
	initial
		nl0Oi37 = 0;
	always @ ( posedge recovclk)
		  nl0Oi37 <= nl0Oi38;
	event nl0Oi37_event;
	initial
		#1 ->nl0Oi37_event;
	always @(nl0Oi37_event)
		nl0Oi37 <= {1{1'b1}};
	initial
		nl0Oi38 = 0;
	always @ ( posedge recovclk)
		  nl0Oi38 <= nl0Oi37;
	initial
		nl0Ol35 = 0;
	always @ ( posedge recovclk)
		  nl0Ol35 <= nl0Ol36;
	event nl0Ol35_event;
	initial
		#1 ->nl0Ol35_event;
	always @(nl0Ol35_event)
		nl0Ol35 <= {1{1'b1}};
	initial
		nl0Ol36 = 0;
	always @ ( posedge recovclk)
		  nl0Ol36 <= nl0Ol35;
	initial
		nli0l29 = 0;
	always @ ( posedge recovclk)
		  nli0l29 <= nli0l30;
	event nli0l29_event;
	initial
		#1 ->nli0l29_event;
	always @(nli0l29_event)
		nli0l29 <= {1{1'b1}};
	initial
		nli0l30 = 0;
	always @ ( posedge recovclk)
		  nli0l30 <= nli0l29;
	initial
		nli1i33 = 0;
	always @ ( posedge recovclk)
		  nli1i33 <= nli1i34;
	event nli1i33_event;
	initial
		#1 ->nli1i33_event;
	always @(nli1i33_event)
		nli1i33 <= {1{1'b1}};
	initial
		nli1i34 = 0;
	always @ ( posedge recovclk)
		  nli1i34 <= nli1i33;
	initial
		nli1O31 = 0;
	always @ ( posedge recovclk)
		  nli1O31 <= nli1O32;
	event nli1O31_event;
	initial
		#1 ->nli1O31_event;
	always @(nli1O31_event)
		nli1O31 <= {1{1'b1}};
	initial
		nli1O32 = 0;
	always @ ( posedge recovclk)
		  nli1O32 <= nli1O31;
	initial
		nliil27 = 0;
	always @ ( posedge recovclk)
		  nliil27 <= nliil28;
	event nliil27_event;
	initial
		#1 ->nliil27_event;
	always @(nliil27_event)
		nliil27 <= {1{1'b1}};
	initial
		nliil28 = 0;
	always @ ( posedge recovclk)
		  nliil28 <= nliil27;
	initial
		nlili25 = 0;
	always @ ( posedge recovclk)
		  nlili25 <= nlili26;
	event nlili25_event;
	initial
		#1 ->nlili25_event;
	always @(nlili25_event)
		nlili25 <= {1{1'b1}};
	initial
		nlili26 = 0;
	always @ ( posedge recovclk)
		  nlili26 <= nlili25;
	initial
		nlilO23 = 0;
	always @ ( posedge recovclk)
		  nlilO23 <= nlilO24;
	event nlilO23_event;
	initial
		#1 ->nlilO23_event;
	always @(nlilO23_event)
		nlilO23 <= {1{1'b1}};
	initial
		nlilO24 = 0;
	always @ ( posedge recovclk)
		  nlilO24 <= nlilO23;
	initial
		nliOl21 = 0;
	always @ ( posedge recovclk)
		  nliOl21 <= nliOl22;
	event nliOl21_event;
	initial
		#1 ->nliOl21_event;
	always @(nliOl21_event)
		nliOl21 <= {1{1'b1}};
	initial
		nliOl22 = 0;
	always @ ( posedge recovclk)
		  nliOl22 <= nliOl21;
	initial
		nliOO19 = 0;
	always @ ( posedge recovclk)
		  nliOO19 <= nliOO20;
	event nliOO19_event;
	initial
		#1 ->nliOO19_event;
	always @(nliOO19_event)
		nliOO19 <= {1{1'b1}};
	initial
		nliOO20 = 0;
	always @ ( posedge recovclk)
		  nliOO20 <= nliOO19;
	initial
		nll0l13 = 0;
	always @ ( posedge recovclk)
		  nll0l13 <= nll0l14;
	event nll0l13_event;
	initial
		#1 ->nll0l13_event;
	always @(nll0l13_event)
		nll0l13 <= {1{1'b1}};
	initial
		nll0l14 = 0;
	always @ ( posedge recovclk)
		  nll0l14 <= nll0l13;
	initial
		nll1i17 = 0;
	always @ ( posedge recovclk)
		  nll1i17 <= nll1i18;
	event nll1i17_event;
	initial
		#1 ->nll1i17_event;
	always @(nll1i17_event)
		nll1i17 <= {1{1'b1}};
	initial
		nll1i18 = 0;
	always @ ( posedge recovclk)
		  nll1i18 <= nll1i17;
	initial
		nll1l15 = 0;
	always @ ( posedge recovclk)
		  nll1l15 <= nll1l16;
	event nll1l15_event;
	initial
		#1 ->nll1l15_event;
	always @(nll1l15_event)
		nll1l15 <= {1{1'b1}};
	initial
		nll1l16 = 0;
	always @ ( posedge recovclk)
		  nll1l16 <= nll1l15;
	initial
		nlliO11 = 0;
	always @ ( posedge recovclk)
		  nlliO11 <= nlliO12;
	event nlliO11_event;
	initial
		#1 ->nlliO11_event;
	always @(nlliO11_event)
		nlliO11 <= {1{1'b1}};
	initial
		nlliO12 = 0;
	always @ ( posedge recovclk)
		  nlliO12 <= nlliO11;
	initial
		nllll10 = 0;
	always @ ( posedge recovclk)
		  nllll10 <= nllll9;
	initial
		nllll9 = 0;
	always @ ( posedge recovclk)
		  nllll9 <= nllll10;
	event nllll9_event;
	initial
		#1 ->nllll9_event;
	always @(nllll9_event)
		nllll9 <= {1{1'b1}};
	initial
		nllOi7 = 0;
	always @ ( posedge recovclk)
		  nllOi7 <= nllOi8;
	event nllOi7_event;
	initial
		#1 ->nllOi7_event;
	always @(nllOi7_event)
		nllOi7 <= {1{1'b1}};
	initial
		nllOi8 = 0;
	always @ ( posedge recovclk)
		  nllOi8 <= nllOi7;
	initial
		nllOO5 = 0;
	always @ ( posedge recovclk)
		  nllOO5 <= nllOO6;
	event nllOO5_event;
	initial
		#1 ->nllOO5_event;
	always @(nllOO5_event)
		nllOO5 <= {1{1'b1}};
	initial
		nllOO6 = 0;
	always @ ( posedge recovclk)
		  nllOO6 <= nllOO5;
	initial
		nlO0l1 = 0;
	always @ ( posedge recovclk)
		  nlO0l1 <= nlO0l2;
	event nlO0l1_event;
	initial
		#1 ->nlO0l1_event;
	always @(nlO0l1_event)
		nlO0l1 <= {1{1'b1}};
	initial
		nlO0l2 = 0;
	always @ ( posedge recovclk)
		  nlO0l2 <= nlO0l1;
	initial
		nlO1l3 = 0;
	always @ ( posedge recovclk)
		  nlO1l3 <= nlO1l4;
	event nlO1l3_event;
	initial
		#1 ->nlO1l3_event;
	always @(nlO1l3_event)
		nlO1l3 <= {1{1'b1}};
	initial
		nlO1l4 = 0;
	always @ ( posedge recovclk)
		  nlO1l4 <= nlO1l3;
	initial
	begin
		n0i = 0;
		n1i = 0;
		n1l = 0;
		nlOO = 0;
	end
	always @ ( posedge recovclk or  negedge wire_n1O_PRN)
	begin
		if (wire_n1O_PRN == 1'b0) 
		begin
			n0i <= 1;
			n1i <= 1;
			n1l <= 1;
			nlOO <= 1;
		end
		else 
		begin
			n0i <= wire_n1Oi_o;
			n1i <= n1l;
			n1l <= n0i;
			nlOO <= wire_n0Oi_o;
		end
	end
	assign
		wire_n1O_PRN = ((nllOi8 ^ nllOi7) & (~ resetall));
	event n0i_event;
	event n1i_event;
	event n1l_event;
	event nlOO_event;
	initial
		#1 ->n0i_event;
	initial
		#1 ->n1i_event;
	initial
		#1 ->n1l_event;
	initial
		#1 ->nlOO_event;
	always @(n0i_event)
		n0i <= 1;
	always @(n1i_event)
		n1i <= 1;
	always @(n1l_event)
		n1l <= 1;
	always @(nlOO_event)
		nlOO <= 1;
	initial
	begin
		n0l = 0;
		nii = 0;
		nil = 0;
		nli = 0;
		nlil = 0;
		nliO = 0;
		nlli = 0;
		nlll = 0;
		nllO = 0;
		nlOi = 0;
		nlOl = 0;
	end
	always @ ( posedge recovclk or  negedge wire_niO_CLRN)
	begin
		if (wire_niO_CLRN == 1'b0) 
		begin
			n0l <= 0;
			nii <= 0;
			nil <= 0;
			nli <= 0;
			nlil <= 0;
			nliO <= 0;
			nlli <= 0;
			nlll <= 0;
			nllO <= 0;
			nlOi <= 0;
			nlOl <= 0;
		end
		else 
		begin
			n0l <= nii;
			nii <= wire_n1ll_o;
			nil <= nli;
			nli <= (((syncstatus[0] & syncstatus[1]) & syncstatus[2]) & syncstatus[3]);
			nlil <= wire_n1Ol_o;
			nliO <= wire_n01i_o;
			nlli <= wire_n01O_o;
			nlll <= wire_n00l_o;
			nllO <= wire_n0ii_o;
			nlOi <= wire_n0iO_o;
			nlOl <= wire_n0ll_o;
		end
	end
	assign
		wire_niO_CLRN = ((nllOO6 ^ nllOO5) & (~ resetall));
	or(wire_n0Ol_dataout, n0i, nll1O);
	and(wire_n0OO_dataout, nii, ~(nll1O));
	and(wire_ni0i_dataout, wire_ni0O_dataout, ~((~ nil)));
	and(wire_ni0l_dataout, wire_niii_dataout, ~((~ nil)));
	and(wire_ni0O_dataout, (~ nlO0i), ~(nlO1i));
	and(wire_ni1i_dataout, (~ nlO0i), ~(nll1O));
	and(wire_ni1l_dataout, nlO0i, ~(nll1O));
	and(wire_niii_dataout, nlO0i, ~(nlO1i));
	or(wire_niil_dataout, n0i, (~ nil));
	and(wire_niiO_dataout, nii, ~((~ nil)));
	and(wire_nili_dataout, nlO1i, ~((~ nil)));
	and(wire_nill_dataout, (~ nlO1i), ~((~ nil)));
	assign		wire_nilO_dataout = (nllii === 1'b1) ? nii : wire_niOi_dataout;
	or(wire_niOi_dataout, nii, nlO0i);
	and(wire_niOl_dataout, nlO0i, ~(nllii));
	and(wire_niOO_dataout, (~ nlO0i), ~(nllii));
	and(wire_nl0O_dataout, n0i, ~(nllil));
	or(wire_nl1i_dataout, n0i, nllii);
	and(wire_nl1l_dataout, nll0i, ~(nllii));
	and(wire_nl1O_dataout, (~ nll0i), ~(nllii));
	oper_selector   n00l
	( 
	.data({1'b0, wire_niOl_dataout, wire_nill_dataout, ((nl0Oi38 ^ nl0Oi37) & wire_ni0l_dataout)}),
	.o(wire_n00l_o),
	.sel({nl0OO, nllO, ((nl0Ol36 ^ nl0Ol35) & nlll), nlli}));
	defparam
		n00l.width_data = 4,
		n00l.width_sel = 4;
	oper_selector   n01i
	( 
	.data({1'b0, wire_nili_dataout, wire_ni0i_dataout, wire_ni1l_dataout}),
	.o(wire_n01i_o),
	.sel({nl0ll, ((nl0li40 ^ nl0li39) & nlli), nliO, nlil}));
	defparam
		n01i.width_data = 4,
		n01i.width_sel = 4;
	oper_selector   n01O
	( 
	.data({1'b0, wire_nili_dataout, wire_ni0i_dataout, wire_ni0l_dataout}),
	.o(wire_n01O_o),
	.sel({nl0lO, nlll, nlli, nliO}));
	defparam
		n01O.width_data = 4,
		n01O.width_sel = 4;
	oper_selector   n0ii
	( 
	.data({1'b0, wire_niOl_dataout, wire_niOO_dataout}),
	.o(wire_n0ii_o),
	.sel({nli0i, nlOi, ((nli1O32 ^ nli1O31) & nllO)}));
	defparam
		n0ii.width_data = 3,
		n0ii.width_sel = 3;
	oper_selector   n0iO
	( 
	.data({1'b0, wire_nl1l_dataout, wire_niOO_dataout}),
	.o(wire_n0iO_o),
	.sel({nliii, nlOl, nlOi}));
	defparam
		n0iO.width_data = 3,
		n0iO.width_sel = 3;
	oper_selector   n0ll
	( 
	.data({nllil, ((nlili26 ^ nlili25) & wire_nl1O_dataout), 1'b0}),
	.o(wire_n0ll_o),
	.sel({nlOO, nlOl, nlill}));
	defparam
		n0ll.width_data = 3,
		n0ll.width_sel = 3;
	oper_selector   n0Oi
	( 
	.data({(~ nllil), nllii, ((nliOl22 ^ nliOl21) & nllii), ((nliOO20 ^ nliOO19) & nllii), {3{(~ nil)}}, ((nll1i18 ^ nll1i17) & nll1O)}),
	.o(wire_n0Oi_o),
	.sel({nlOO, nlOl, nlOi, ((nll1l16 ^ nll1l15) & nllO), nlll, nlli, nliO, nlil}));
	defparam
		n0Oi.width_data = 8,
		n0Oi.width_sel = 8;
	oper_selector   n1ll
	( 
	.data({nii, wire_nilO_dataout, {3{wire_niiO_dataout}}, wire_n0OO_dataout}),
	.o(wire_n1ll_o),
	.sel({((nlOO | nlOl) | nlOi), nllO, nlll, nlli, nliO, nlil}));
	defparam
		n1ll.width_data = 6,
		n1ll.width_sel = 6;
	oper_selector   n1Oi
	( 
	.data({wire_nl0O_dataout, {3{wire_nl1i_dataout}}, {3{wire_niil_dataout}}, wire_n0Ol_dataout}),
	.o(wire_n1Oi_o),
	.sel({((nl00O44 ^ nl00O43) & nlOO), nlOl, nlOi, nllO, nlll, nlli, nliO, nlil}));
	defparam
		n1Oi.width_data = 8,
		n1Oi.width_sel = 8;
	oper_selector   n1Ol
	( 
	.data({1'b0, wire_nili_dataout, wire_ni1i_dataout}),
	.o(wire_n1Ol_o),
	.sel({nl0ii, nliO, nlil}));
	defparam
		n1Ol.width_data = 3,
		n1Ol.width_sel = 3;
	assign
		alignstatus = n0l,
		enabledeskew = n0i,
		fiforesetrd = (n0i & (~ n1l)),
		nl0ii = ((((((nlOO | nlOl) | nlOi) | nllO) | nlll) | nlli) | (~ (nl0il42 ^ nl0il41))),
		nl0ll = ((((nlOO | nlOl) | nlOi) | nllO) | nlll),
		nl0lO = ((((nlOO | nlOl) | nlOi) | nllO) | nlil),
		nl0OO = (((((nlOO | nlOl) | nlOi) | nliO) | nlil) | (~ (nli1i34 ^ nli1i33))),
		nli0i = ((((((nlOO | nlOl) | nlll) | nlli) | nliO) | nlil) | (~ (nli0l30 ^ nli0l29))),
		nliii = ((((((nlOO | nllO) | nlll) | nlli) | nliO) | nlil) | (~ (nliil28 ^ nliil27))),
		nlill = ((((((nlOi | nllO) | nlll) | nlli) | nliO) | nlil) | (~ (nlilO24 ^ nlilO23))),
		nll0i = ((nlO0i & (~ n1i)) & (nll0l14 ^ nll0l13)),
		nll1O = (nlO1i | (~ nil)),
		nllii = (nlO1i | (~ nil)),
		nllil = ((((((adet[0] & adet[1]) & adet[2]) & adet[3]) & (nllll10 ^ nllll9)) & nil) & (nlliO12 ^ nlliO11)),
		nllOl = 1'b1,
		nlO0i = ((((rdalign[0] & rdalign[1]) & rdalign[2]) & rdalign[3]) & (nlO0l2 ^ nlO0l1)),
		nlO1i = (((~ nlO0i) & (((rdalign[0] | rdalign[1]) | rdalign[2]) | rdalign[3])) & (nlO1l4 ^ nlO1l3));
endmodule //stratixgx_xgm_dskw_sm
//synopsys translate_on
//VALID FILE
//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 140 mux21 317 oper_add 1 oper_decoder 1 oper_less_than 1 oper_mux 39 
`timescale 1 ps / 1 ps
module  stratixgx_xgm_tx_sm
	( 
	rdenablesync,
	resetall,
	txclk,
	txctrl,
	txctrlout,
	txdatain,
	txdataout) /* synthesis synthesis_clearbox=1 */;
	input   rdenablesync;
	input   resetall;
	input   txclk;
	input   [3:0]  txctrl;
	output   [3:0]  txctrlout;
	input   [31:0]  txdatain;
	output   [31:0]  txdataout;

	reg	niOOOO53;
	reg	niOOOO54;
	reg	nl000l5;
	reg	nl000l6;
	reg	nl00iO3;
	reg	nl00iO4;
	reg	nl00Oi1;
	reg	nl00Oi2;
	reg	nl010i13;
	reg	nl010i14;
	reg	nl01il11;
	reg	nl01il12;
	reg	nl01lO10;
	reg	nl01lO9;
	reg	nl01OO7;
	reg	nl01OO8;
	reg	nl100O39;
	reg	nl100O40;
	reg	nl10ll37;
	reg	nl10ll38;
	reg	nl111i51;
	reg	nl111i52;
	reg	nl11iO49;
	reg	nl11iO50;
	reg	nl11li47;
	reg	nl11li48;
	reg	nl11lO45;
	reg	nl11lO46;
	reg	nl11Oi43;
	reg	nl11Oi44;
	reg	nl11OO41;
	reg	nl11OO42;
	reg	nl1i0l33;
	reg	nl1i0l34;
	reg	nl1i1i35;
	reg	nl1i1i36;
	reg	nl1iiO31;
	reg	nl1iiO32;
	reg	nl1ilO29;
	reg	nl1ilO30;
	reg	nl1iOO27;
	reg	nl1iOO28;
	reg	nl1l0i25;
	reg	nl1l0i26;
	reg	nl1lli23;
	reg	nl1lli24;
	reg	nl1lOi21;
	reg	nl1lOi22;
	reg	nl1O0i19;
	reg	nl1O0i20;
	reg	nl1Oii17;
	reg	nl1Oii18;
	reg	nl1OOi15;
	reg	nl1OOi16;
	reg	n00i;
	reg	n01i;
	reg	n01l;
	reg	n10i;
	reg	n10l;
	reg	n10O;
	reg	n11i;
	reg	n11l;
	reg	n11O;
	reg	n1ii;
	reg	n1il;
	reg	n1iO;
	reg	n1li;
	reg	n1Oi;
	reg	n1Ol;
	reg	n1OO;
	reg	nllOO;
	reg	nlO0O;
	reg	nlO1l;
	reg	nlOii;
	reg	nlOiO;
	reg	nlOli;
	reg	nlOll;
	reg	nlOlO;
	reg	nlOOi;
	reg	nlOOl;
	reg	nlOOO;
	reg	n00O;
	reg	n0Ol;
	reg	n0OOO;
	reg	nli0O;
	reg	nliii;
	reg	nlliO;
	reg	nllli;
	reg	nllll;
	reg	nlllO;
	reg	nllOi;
	reg	nllOl;
	reg	n0Oi_clk_prev;
	wire	wire_n0Oi_CLRN;
	wire	wire_n0Oi_PRN;
	reg	n0Oil;
	reg	n0OiO;
	reg	n0Oli;
	reg	n0Oll;
	reg	n0OOl;
	reg	n1l0l;
	reg	n1l0O;
	reg	n1lii;
	reg	n1lil;
	reg	n1lli;
	reg	n1lll;
	reg	n1OOO;
	reg	nll01i;
	reg	nll1li;
	reg	nll1ll;
	reg	nll1lO;
	reg	nll1Oi;
	reg	nll1OO;
	reg	nlOi0i;
	reg	nlOi0l;
	reg	nlOi0O;
	reg	nlOi1O;
	reg	nlOiil;
	reg	nlOiiO;
	reg	n0OOi_clk_prev;
	wire	wire_n0OOi_CLRN;
	wire	wire_n0OOi_PRN;
	reg	n1lO;
	reg	nlO0i;
	reg	nlO0l;
	reg	nlO1O;
	reg	nlOil;
	reg	n1ll_clk_prev;
	wire	wire_n1ll_CLRN;
	wire	wire_n1ll_PRN;
	reg	n00l;
	reg	n0O0O;
	reg	n0Oii;
	reg	n0OlO;
	reg	n0OO;
	reg	n1l0i;
	reg	n1l1O;
	reg	n1liO;
	reg	ni1l;
	reg	nl01O;
	reg	nli0i;
	reg	nli0l;
	reg	nli1O;
	reg	nll1il;
	reg	nll1iO;
	reg	nll1Ol;
	reg	nlOi1i;
	reg	nlOi1l;
	reg	nlOiii;
	wire	wire_ni1i_CLRN;
	wire	wire_n000i_dataout;
	wire	wire_n000l_dataout;
	wire	wire_n000O_dataout;
	wire	wire_n001i_dataout;
	wire	wire_n001l_dataout;
	wire	wire_n001O_dataout;
	wire	wire_n00ii_dataout;
	wire	wire_n00il_dataout;
	wire	wire_n00iO_dataout;
	wire	wire_n00li_dataout;
	wire	wire_n00ll_dataout;
	wire	wire_n00lO_dataout;
	wire	wire_n00Oi_dataout;
	wire	wire_n00Ol_dataout;
	wire	wire_n00OO_dataout;
	wire	wire_n010i_dataout;
	wire	wire_n010l_dataout;
	wire	wire_n010O_dataout;
	wire	wire_n011i_dataout;
	wire	wire_n011l_dataout;
	wire	wire_n011O_dataout;
	wire	wire_n01ii_dataout;
	wire	wire_n01il_dataout;
	wire	wire_n01iO_dataout;
	wire	wire_n01li_dataout;
	wire	wire_n01ll_dataout;
	wire	wire_n01lO_dataout;
	wire	wire_n01Oi_dataout;
	wire	wire_n01Ol_dataout;
	wire	wire_n01OO_dataout;
	wire	wire_n0i0i_dataout;
	wire	wire_n0i0l_dataout;
	wire	wire_n0i0O_dataout;
	wire	wire_n0i1i_dataout;
	wire	wire_n0i1l_dataout;
	wire	wire_n0i1O_dataout;
	wire	wire_n0ii_dataout;
	wire	wire_n0iii_dataout;
	wire	wire_n0iil_dataout;
	wire	wire_n0iiO_dataout;
	wire	wire_n0il_dataout;
	wire	wire_n0ili_dataout;
	wire	wire_n0ill_dataout;
	wire	wire_n0ilO_dataout;
	wire	wire_n0iOi_dataout;
	wire	wire_n0iOl_dataout;
	wire	wire_n0iOO_dataout;
	wire	wire_n0l0i_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0l1i_dataout;
	wire	wire_n0l1l_dataout;
	wire	wire_n0l1O_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lll_dataout;
	wire	wire_n0llO_dataout;
	wire	wire_n0lOi_dataout;
	wire	wire_n0lOl_dataout;
	wire	wire_n0lOO_dataout;
	wire	wire_n0O0i_dataout;
	wire	wire_n0O0l_dataout;
	wire	wire_n0O1i_dataout;
	wire	wire_n0O1l_dataout;
	wire	wire_n0O1O_dataout;
	wire	wire_n100i_dataout;
	wire	wire_n100l_dataout;
	wire	wire_n100O_dataout;
	wire	wire_n101i_dataout;
	wire	wire_n101l_dataout;
	wire	wire_n101O_dataout;
	wire	wire_n10ii_dataout;
	wire	wire_n10il_dataout;
	wire	wire_n10iO_dataout;
	wire	wire_n10li_dataout;
	wire	wire_n10ll_dataout;
	wire	wire_n10lO_dataout;
	wire	wire_n10Oi_dataout;
	wire	wire_n10Ol_dataout;
	wire	wire_n10OO_dataout;
	wire	wire_n110i_dataout;
	wire	wire_n110l_dataout;
	wire	wire_n110O_dataout;
	wire	wire_n111i_dataout;
	wire	wire_n111l_dataout;
	wire	wire_n111O_dataout;
	wire	wire_n11ii_dataout;
	wire	wire_n11il_dataout;
	wire	wire_n11iO_dataout;
	wire	wire_n11li_dataout;
	wire	wire_n11ll_dataout;
	wire	wire_n11lO_dataout;
	wire	wire_n11Oi_dataout;
	wire	wire_n11Ol_dataout;
	wire	wire_n11OO_dataout;
	wire	wire_n1i0i_dataout;
	wire	wire_n1i0l_dataout;
	wire	wire_n1i0O_dataout;
	wire	wire_n1i1i_dataout;
	wire	wire_n1i1l_dataout;
	wire	wire_n1i1O_dataout;
	wire	wire_n1iii_dataout;
	wire	wire_n1iil_dataout;
	wire	wire_n1iiO_dataout;
	wire	wire_n1ili_dataout;
	wire	wire_n1ill_dataout;
	wire	wire_n1ilO_dataout;
	wire	wire_n1iOi_dataout;
	wire	wire_n1iOl_dataout;
	wire	wire_n1iOO_dataout;
	wire	wire_n1l1i_dataout;
	wire	wire_n1l1l_dataout;
	wire	wire_n1llO_dataout;
	wire	wire_n1lOi_dataout;
	wire	wire_n1lOl_dataout;
	wire	wire_n1lOO_dataout;
	wire	wire_n1O0i_dataout;
	wire	wire_n1O0l_dataout;
	wire	wire_n1O1i_dataout;
	wire	wire_n1O1l_dataout;
	wire	wire_n1O1O_dataout;
	wire	wire_ni00i_dataout;
	wire	wire_ni00l_dataout;
	wire	wire_ni00O_dataout;
	wire	wire_ni0ii_dataout;
	wire	wire_ni0il_dataout;
	wire	wire_ni0iO_dataout;
	wire	wire_ni0li_dataout;
	wire	wire_ni0ll_dataout;
	wire	wire_ni0lO_dataout;
	wire	wire_ni0Oi_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_ni10i_dataout;
	wire	wire_ni10l_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni11i_dataout;
	wire	wire_ni11l_dataout;
	wire	wire_ni11O_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1il_dataout;
	wire	wire_ni1iO_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niili_dataout;
	wire	wire_niill_dataout;
	wire	wire_niilO_dataout;
	wire	wire_niiOi_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_nil0i_dataout;
	wire	wire_nil0l_dataout;
	wire	wire_nil0O_dataout;
	wire	wire_nil1i_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nilii_dataout;
	wire	wire_nilil_dataout;
	wire	wire_niliO_dataout;
	wire	wire_nilli_dataout;
	wire	wire_nilll_dataout;
	wire	wire_nillO_dataout;
	wire	wire_nilOi_dataout;
	wire	wire_nilOl_dataout;
	wire	wire_nilOO_dataout;
	wire	wire_niO0i_dataout;
	wire	wire_niO0l_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niO1i_dataout;
	wire	wire_niO1l_dataout;
	wire	wire_niO1O_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOll_dataout;
	wire	wire_niOlO_dataout;
	wire	wire_niOOi_dataout;
	wire	wire_nl00i_dataout;
	wire	wire_nl00l_dataout;
	wire	wire_nl01i_dataout;
	wire	wire_nl01l_dataout;
	wire	wire_nl10i_dataout;
	wire	wire_nl10l_dataout;
	wire	wire_nl10O_dataout;
	wire	wire_nl11l_dataout;
	wire	wire_nl1ii_dataout;
	wire	wire_nl1il_dataout;
	wire	wire_nl1iO_dataout;
	wire	wire_nl1li_dataout;
	wire	wire_nl1ll_dataout;
	wire	wire_nl1lO_dataout;
	wire	wire_nl1Oi_dataout;
	wire	wire_nl1Ol_dataout;
	wire	wire_nl1OO_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nlili_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll00i_dataout;
	wire	wire_nll00l_dataout;
	wire	wire_nll00O_dataout;
	wire	wire_nll01l_dataout;
	wire	wire_nll01O_dataout;
	wire	wire_nll0ii_dataout;
	wire	wire_nll0il_dataout;
	wire	wire_nll0iO_dataout;
	wire	wire_nll0li_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nlli0l_dataout;
	wire	wire_nlli0O_dataout;
	wire	wire_nlliii_dataout;
	wire	wire_nlliil_dataout;
	wire	wire_nlliiO_dataout;
	wire	wire_nllili_dataout;
	wire	wire_nllill_dataout;
	wire	wire_nllilO_dataout;
	wire	wire_nlliOi_dataout;
	wire	wire_nlliOl_dataout;
	wire	wire_nlliOO_dataout;
	wire	wire_nlll0i_dataout;
	wire	wire_nlll0l_dataout;
	wire	wire_nlll0O_dataout;
	wire	wire_nlll1i_dataout;
	wire	wire_nlll1l_dataout;
	wire	wire_nlll1O_dataout;
	wire	wire_nlllii_dataout;
	wire	wire_nlllil_dataout;
	wire	wire_nllliO_dataout;
	wire	wire_nlllli_dataout;
	wire	wire_nlllll_dataout;
	wire	wire_nllllO_dataout;
	wire	wire_nlllOi_dataout;
	wire	wire_nlllOl_dataout;
	wire	wire_nlllOO_dataout;
	wire	wire_nllO0l_dataout;
	wire	wire_nllO0O_dataout;
	wire	wire_nllO1i_dataout;
	wire	wire_nllOii_dataout;
	wire	wire_nllOil_dataout;
	wire	wire_nllOiO_dataout;
	wire	wire_nllOli_dataout;
	wire	wire_nllOll_dataout;
	wire	wire_nllOlO_dataout;
	wire	wire_nllOOi_dataout;
	wire	wire_nllOOl_dataout;
	wire	wire_nllOOO_dataout;
	wire	wire_nlO00i_dataout;
	wire	wire_nlO00l_dataout;
	wire	wire_nlO01i_dataout;
	wire	wire_nlO01l_dataout;
	wire	wire_nlO01O_dataout;
	wire	wire_nlO0ii_dataout;
	wire	wire_nlO0il_dataout;
	wire	wire_nlO0iO_dataout;
	wire	wire_nlO0li_dataout;
	wire	wire_nlO0ll_dataout;
	wire	wire_nlO0lO_dataout;
	wire	wire_nlO0Oi_dataout;
	wire	wire_nlO0Ol_dataout;
	wire	wire_nlO0OO_dataout;
	wire	wire_nlO10i_dataout;
	wire	wire_nlO10l_dataout;
	wire	wire_nlO10O_dataout;
	wire	wire_nlO11i_dataout;
	wire	wire_nlO11l_dataout;
	wire	wire_nlO11O_dataout;
	wire	wire_nlO1ii_dataout;
	wire	wire_nlO1il_dataout;
	wire	wire_nlO1iO_dataout;
	wire	wire_nlO1li_dataout;
	wire	wire_nlO1ll_dataout;
	wire	wire_nlO1lO_dataout;
	wire	wire_nlO1Oi_dataout;
	wire	wire_nlO1Ol_dataout;
	wire	wire_nlO1OO_dataout;
	wire	wire_nlOili_dataout;
	wire	wire_nlOill_dataout;
	wire	wire_nlOilO_dataout;
	wire	wire_nlOiOi_dataout;
	wire	wire_nlOiOl_dataout;
	wire	wire_nlOiOO_dataout;
	wire	wire_nlOl1i_dataout;
	wire	wire_nlOl1l_dataout;
	wire	wire_nlOl1O_dataout;
	wire	wire_nlOlOi_dataout;
	wire	wire_nlOlOl_dataout;
	wire	wire_nlOlOO_dataout;
	wire	wire_nlOO0i_dataout;
	wire	wire_nlOO0l_dataout;
	wire	wire_nlOO0O_dataout;
	wire	wire_nlOO1i_dataout;
	wire	wire_nlOO1l_dataout;
	wire	wire_nlOO1O_dataout;
	wire	wire_nlOOii_dataout;
	wire	wire_nlOOil_dataout;
	wire	wire_nlOOiO_dataout;
	wire	wire_nlOOli_dataout;
	wire	wire_nlOOll_dataout;
	wire	wire_nlOOlO_dataout;
	wire	wire_nlOOOi_dataout;
	wire	wire_nlOOOl_dataout;
	wire	wire_nlOOOO_dataout;
	wire  [5:0]   wire_nll1O_o;
	wire  [15:0]   wire_nl11O_o;
	wire  wire_nl0OO_o;
	wire  wire_n1O0O_o;
	wire  wire_n1Oii_o;
	wire  wire_n1Oil_o;
	wire  wire_n1OiO_o;
	wire  wire_n1Oli_o;
	wire  wire_n1Oll_o;
	wire  wire_n1OlO_o;
	wire  wire_n1OOi_o;
	wire  wire_n1OOl_o;
	wire  wire_ni01i_o;
	wire  wire_ni01l_o;
	wire  wire_ni01O_o;
	wire  wire_ni1li_o;
	wire  wire_ni1ll_o;
	wire  wire_ni1lO_o;
	wire  wire_ni1Oi_o;
	wire  wire_ni1Ol_o;
	wire  wire_ni1OO_o;
	wire  wire_niOOl_o;
	wire  wire_niOOO_o;
	wire  wire_nl11i_o;
	wire  wire_nll0ll_o;
	wire  wire_nll0lO_o;
	wire  wire_nll0Oi_o;
	wire  wire_nll0Ol_o;
	wire  wire_nll0OO_o;
	wire  wire_nlli0i_o;
	wire  wire_nlli1i_o;
	wire  wire_nlli1l_o;
	wire  wire_nlli1O_o;
	wire  wire_nlOl0i_o;
	wire  wire_nlOl0l_o;
	wire  wire_nlOl0O_o;
	wire  wire_nlOlii_o;
	wire  wire_nlOlil_o;
	wire  wire_nlOliO_o;
	wire  wire_nlOlli_o;
	wire  wire_nlOlll_o;
	wire  wire_nlOllO_o;
	wire  niOOOi;
	wire  niOOOl;
	wire  nl000i;
	wire  nl001l;
	wire  nl001O;
	wire  nl00ii;
	wire  nl00il;
	wire  nl00ll;
	wire  nl00lO;
	wire  nl010O;
	wire  nl011i;
	wire  nl011l;
	wire  nl011O;
	wire  nl01ii;
	wire  nl01li;
	wire  nl01ll;
	wire  nl01Ol;
	wire  nl0i1l;
	wire  nl100i;
	wire  nl100l;
	wire  nl101i;
	wire  nl101l;
	wire  nl101O;
	wire  nl10il;
	wire  nl10iO;
	wire  nl10li;
	wire  nl10Oi;
	wire  nl10Ol;
	wire  nl10OO;
	wire  nl110i;
	wire  nl110l;
	wire  nl110O;
	wire  nl111l;
	wire  nl111O;
	wire  nl11ii;
	wire  nl11il;
	wire  nl11ll;
	wire  nl11Ol;
	wire  nl1i0i;
	wire  nl1i1O;
	wire  nl1iii;
	wire  nl1iil;
	wire  nl1ill;
	wire  nl1iOl;
	wire  nl1l0O;
	wire  nl1l1l;
	wire  nl1l1O;
	wire  nl1lii;
	wire  nl1lil;
	wire  nl1liO;
	wire  nl1llO;
	wire  nl1lOO;
	wire  nl1O0O;
	wire  nl1O1i;
	wire  nl1O1l;
	wire  nl1O1O;
	wire  nl1OiO;
	wire  nl1Oli;
	wire  nl1Oll;
	wire  nl1OlO;
	wire  nl1OOO;

	initial
		niOOOO53 = 0;
	always @ ( posedge txclk)
		  niOOOO53 <= niOOOO54;
	event niOOOO53_event;
	initial
		#1 ->niOOOO53_event;
	always @(niOOOO53_event)
		niOOOO53 <= {1{1'b1}};
	initial
		niOOOO54 = 0;
	always @ ( posedge txclk)
		  niOOOO54 <= niOOOO53;
	initial
		nl000l5 = 0;
	always @ ( posedge txclk)
		  nl000l5 <= nl000l6;
	event nl000l5_event;
	initial
		#1 ->nl000l5_event;
	always @(nl000l5_event)
		nl000l5 <= {1{1'b1}};
	initial
		nl000l6 = 0;
	always @ ( posedge txclk)
		  nl000l6 <= nl000l5;
	initial
		nl00iO3 = 0;
	always @ ( posedge txclk)
		  nl00iO3 <= nl00iO4;
	event nl00iO3_event;
	initial
		#1 ->nl00iO3_event;
	always @(nl00iO3_event)
		nl00iO3 <= {1{1'b1}};
	initial
		nl00iO4 = 0;
	always @ ( posedge txclk)
		  nl00iO4 <= nl00iO3;
	initial
		nl00Oi1 = 0;
	always @ ( posedge txclk)
		  nl00Oi1 <= nl00Oi2;
	event nl00Oi1_event;
	initial
		#1 ->nl00Oi1_event;
	always @(nl00Oi1_event)
		nl00Oi1 <= {1{1'b1}};
	initial
		nl00Oi2 = 0;
	always @ ( posedge txclk)
		  nl00Oi2 <= nl00Oi1;
	initial
		nl010i13 = 0;
	always @ ( posedge txclk)
		  nl010i13 <= nl010i14;
	event nl010i13_event;
	initial
		#1 ->nl010i13_event;
	always @(nl010i13_event)
		nl010i13 <= {1{1'b1}};
	initial
		nl010i14 = 0;
	always @ ( posedge txclk)
		  nl010i14 <= nl010i13;
	initial
		nl01il11 = 0;
	always @ ( posedge txclk)
		  nl01il11 <= nl01il12;
	event nl01il11_event;
	initial
		#1 ->nl01il11_event;
	always @(nl01il11_event)
		nl01il11 <= {1{1'b1}};
	initial
		nl01il12 = 0;
	always @ ( posedge txclk)
		  nl01il12 <= nl01il11;
	initial
		nl01lO10 = 0;
	always @ ( posedge txclk)
		  nl01lO10 <= nl01lO9;
	initial
		nl01lO9 = 0;
	always @ ( posedge txclk)
		  nl01lO9 <= nl01lO10;
	event nl01lO9_event;
	initial
		#1 ->nl01lO9_event;
	always @(nl01lO9_event)
		nl01lO9 <= {1{1'b1}};
	initial
		nl01OO7 = 0;
	always @ ( posedge txclk)
		  nl01OO7 <= nl01OO8;
	event nl01OO7_event;
	initial
		#1 ->nl01OO7_event;
	always @(nl01OO7_event)
		nl01OO7 <= {1{1'b1}};
	initial
		nl01OO8 = 0;
	always @ ( posedge txclk)
		  nl01OO8 <= nl01OO7;
	initial
		nl100O39 = 0;
	always @ ( posedge txclk)
		  nl100O39 <= nl100O40;
	event nl100O39_event;
	initial
		#1 ->nl100O39_event;
	always @(nl100O39_event)
		nl100O39 <= {1{1'b1}};
	initial
		nl100O40 = 0;
	always @ ( posedge txclk)
		  nl100O40 <= nl100O39;
	initial
		nl10ll37 = 0;
	always @ ( posedge txclk)
		  nl10ll37 <= nl10ll38;
	event nl10ll37_event;
	initial
		#1 ->nl10ll37_event;
	always @(nl10ll37_event)
		nl10ll37 <= {1{1'b1}};
	initial
		nl10ll38 = 0;
	always @ ( posedge txclk)
		  nl10ll38 <= nl10ll37;
	initial
		nl111i51 = 0;
	always @ ( posedge txclk)
		  nl111i51 <= nl111i52;
	event nl111i51_event;
	initial
		#1 ->nl111i51_event;
	always @(nl111i51_event)
		nl111i51 <= {1{1'b1}};
	initial
		nl111i52 = 0;
	always @ ( posedge txclk)
		  nl111i52 <= nl111i51;
	initial
		nl11iO49 = 0;
	always @ ( posedge txclk)
		  nl11iO49 <= nl11iO50;
	event nl11iO49_event;
	initial
		#1 ->nl11iO49_event;
	always @(nl11iO49_event)
		nl11iO49 <= {1{1'b1}};
	initial
		nl11iO50 = 0;
	always @ ( posedge txclk)
		  nl11iO50 <= nl11iO49;
	initial
		nl11li47 = 0;
	always @ ( posedge txclk)
		  nl11li47 <= nl11li48;
	event nl11li47_event;
	initial
		#1 ->nl11li47_event;
	always @(nl11li47_event)
		nl11li47 <= {1{1'b1}};
	initial
		nl11li48 = 0;
	always @ ( posedge txclk)
		  nl11li48 <= nl11li47;
	initial
		nl11lO45 = 0;
	always @ ( posedge txclk)
		  nl11lO45 <= nl11lO46;
	event nl11lO45_event;
	initial
		#1 ->nl11lO45_event;
	always @(nl11lO45_event)
		nl11lO45 <= {1{1'b1}};
	initial
		nl11lO46 = 0;
	always @ ( posedge txclk)
		  nl11lO46 <= nl11lO45;
	initial
		nl11Oi43 = 0;
	always @ ( posedge txclk)
		  nl11Oi43 <= nl11Oi44;
	event nl11Oi43_event;
	initial
		#1 ->nl11Oi43_event;
	always @(nl11Oi43_event)
		nl11Oi43 <= {1{1'b1}};
	initial
		nl11Oi44 = 0;
	always @ ( posedge txclk)
		  nl11Oi44 <= nl11Oi43;
	initial
		nl11OO41 = 0;
	always @ ( posedge txclk)
		  nl11OO41 <= nl11OO42;
	event nl11OO41_event;
	initial
		#1 ->nl11OO41_event;
	always @(nl11OO41_event)
		nl11OO41 <= {1{1'b1}};
	initial
		nl11OO42 = 0;
	always @ ( posedge txclk)
		  nl11OO42 <= nl11OO41;
	initial
		nl1i0l33 = 0;
	always @ ( posedge txclk)
		  nl1i0l33 <= nl1i0l34;
	event nl1i0l33_event;
	initial
		#1 ->nl1i0l33_event;
	always @(nl1i0l33_event)
		nl1i0l33 <= {1{1'b1}};
	initial
		nl1i0l34 = 0;
	always @ ( posedge txclk)
		  nl1i0l34 <= nl1i0l33;
	initial
		nl1i1i35 = 0;
	always @ ( posedge txclk)
		  nl1i1i35 <= nl1i1i36;
	event nl1i1i35_event;
	initial
		#1 ->nl1i1i35_event;
	always @(nl1i1i35_event)
		nl1i1i35 <= {1{1'b1}};
	initial
		nl1i1i36 = 0;
	always @ ( posedge txclk)
		  nl1i1i36 <= nl1i1i35;
	initial
		nl1iiO31 = 0;
	always @ ( posedge txclk)
		  nl1iiO31 <= nl1iiO32;
	event nl1iiO31_event;
	initial
		#1 ->nl1iiO31_event;
	always @(nl1iiO31_event)
		nl1iiO31 <= {1{1'b1}};
	initial
		nl1iiO32 = 0;
	always @ ( posedge txclk)
		  nl1iiO32 <= nl1iiO31;
	initial
		nl1ilO29 = 0;
	always @ ( posedge txclk)
		  nl1ilO29 <= nl1ilO30;
	event nl1ilO29_event;
	initial
		#1 ->nl1ilO29_event;
	always @(nl1ilO29_event)
		nl1ilO29 <= {1{1'b1}};
	initial
		nl1ilO30 = 0;
	always @ ( posedge txclk)
		  nl1ilO30 <= nl1ilO29;
	initial
		nl1iOO27 = 0;
	always @ ( posedge txclk)
		  nl1iOO27 <= nl1iOO28;
	event nl1iOO27_event;
	initial
		#1 ->nl1iOO27_event;
	always @(nl1iOO27_event)
		nl1iOO27 <= {1{1'b1}};
	initial
		nl1iOO28 = 0;
	always @ ( posedge txclk)
		  nl1iOO28 <= nl1iOO27;
	initial
		nl1l0i25 = 0;
	always @ ( posedge txclk)
		  nl1l0i25 <= nl1l0i26;
	event nl1l0i25_event;
	initial
		#1 ->nl1l0i25_event;
	always @(nl1l0i25_event)
		nl1l0i25 <= {1{1'b1}};
	initial
		nl1l0i26 = 0;
	always @ ( posedge txclk)
		  nl1l0i26 <= nl1l0i25;
	initial
		nl1lli23 = 0;
	always @ ( posedge txclk)
		  nl1lli23 <= nl1lli24;
	event nl1lli23_event;
	initial
		#1 ->nl1lli23_event;
	always @(nl1lli23_event)
		nl1lli23 <= {1{1'b1}};
	initial
		nl1lli24 = 0;
	always @ ( posedge txclk)
		  nl1lli24 <= nl1lli23;
	initial
		nl1lOi21 = 0;
	always @ ( posedge txclk)
		  nl1lOi21 <= nl1lOi22;
	event nl1lOi21_event;
	initial
		#1 ->nl1lOi21_event;
	always @(nl1lOi21_event)
		nl1lOi21 <= {1{1'b1}};
	initial
		nl1lOi22 = 0;
	always @ ( posedge txclk)
		  nl1lOi22 <= nl1lOi21;
	initial
		nl1O0i19 = 0;
	always @ ( posedge txclk)
		  nl1O0i19 <= nl1O0i20;
	event nl1O0i19_event;
	initial
		#1 ->nl1O0i19_event;
	always @(nl1O0i19_event)
		nl1O0i19 <= {1{1'b1}};
	initial
		nl1O0i20 = 0;
	always @ ( posedge txclk)
		  nl1O0i20 <= nl1O0i19;
	initial
		nl1Oii17 = 0;
	always @ ( posedge txclk)
		  nl1Oii17 <= nl1Oii18;
	event nl1Oii17_event;
	initial
		#1 ->nl1Oii17_event;
	always @(nl1Oii17_event)
		nl1Oii17 <= {1{1'b1}};
	initial
		nl1Oii18 = 0;
	always @ ( posedge txclk)
		  nl1Oii18 <= nl1Oii17;
	initial
		nl1OOi15 = 0;
	always @ ( posedge txclk)
		  nl1OOi15 <= nl1OOi16;
	event nl1OOi15_event;
	initial
		#1 ->nl1OOi15_event;
	always @(nl1OOi15_event)
		nl1OOi15 <= {1{1'b1}};
	initial
		nl1OOi16 = 0;
	always @ ( posedge txclk)
		  nl1OOi16 <= nl1OOi15;
	initial
	begin
		n00i = 0;
		n01i = 0;
		n01l = 0;
		n10i = 0;
		n10l = 0;
		n10O = 0;
		n11i = 0;
		n11l = 0;
		n11O = 0;
		n1ii = 0;
		n1il = 0;
		n1iO = 0;
		n1li = 0;
		n1Oi = 0;
		n1Ol = 0;
		n1OO = 0;
		nllOO = 0;
		nlO0O = 0;
		nlO1l = 0;
		nlOii = 0;
		nlOiO = 0;
		nlOli = 0;
		nlOll = 0;
		nlOlO = 0;
		nlOOi = 0;
		nlOOl = 0;
		nlOOO = 0;
	end
	always @ ( posedge txclk or  posedge resetall)
	begin
		if (resetall == 1'b1) 
		begin
			n00i <= 0;
			n01i <= 0;
			n01l <= 0;
			n10i <= 0;
			n10l <= 0;
			n10O <= 0;
			n11i <= 0;
			n11l <= 0;
			n11O <= 0;
			n1ii <= 0;
			n1il <= 0;
			n1iO <= 0;
			n1li <= 0;
			n1Oi <= 0;
			n1Ol <= 0;
			n1OO <= 0;
			nllOO <= 0;
			nlO0O <= 0;
			nlO1l <= 0;
			nlOii <= 0;
			nlOiO <= 0;
			nlOli <= 0;
			nlOll <= 0;
			nlOlO <= 0;
			nlOOi <= 0;
			nlOOl <= 0;
			nlOOO <= 0;
		end
		else if  (nl101i == 1'b1) 
		begin
			n00i <= txdatain[31];
			n01i <= txdatain[29];
			n01l <= txdatain[30];
			n10i <= txdatain[18];
			n10l <= txdatain[19];
			n10O <= txdatain[20];
			n11i <= txdatain[15];
			n11l <= txdatain[16];
			n11O <= txdatain[17];
			n1ii <= txdatain[21];
			n1il <= txdatain[22];
			n1iO <= txdatain[23];
			n1li <= txdatain[24];
			n1Oi <= txdatain[26];
			n1Ol <= txdatain[27];
			n1OO <= txdatain[28];
			nllOO <= txdatain[0];
			nlO0O <= txdatain[5];
			nlO1l <= txdatain[1];
			nlOii <= txdatain[6];
			nlOiO <= txdatain[8];
			nlOli <= txdatain[9];
			nlOll <= txdatain[10];
			nlOlO <= txdatain[11];
			nlOOi <= txdatain[12];
			nlOOl <= txdatain[13];
			nlOOO <= txdatain[14];
		end
	end
	initial
	begin
		n00O = 0;
		n0Ol = 0;
		n0OOO = 0;
		nli0O = 0;
		nliii = 0;
		nlliO = 0;
		nllli = 0;
		nllll = 0;
		nlllO = 0;
		nllOi = 0;
		nllOl = 0;
	end
	always @ (txclk or wire_n0Oi_PRN or wire_n0Oi_CLRN)
	begin
		if (wire_n0Oi_PRN == 1'b0) 
		begin
			n00O <= 1;
			n0Ol <= 1;
			n0OOO <= 1;
			nli0O <= 1;
			nliii <= 1;
			nlliO <= 1;
			nllli <= 1;
			nllll <= 1;
			nlllO <= 1;
			nllOi <= 1;
			nllOl <= 1;
		end
		else if  (wire_n0Oi_CLRN == 1'b0) 
		begin
			n00O <= 0;
			n0Ol <= 0;
			n0OOO <= 0;
			nli0O <= 0;
			nliii <= 0;
			nlliO <= 0;
			nllli <= 0;
			nllll <= 0;
			nlllO <= 0;
			nllOi <= 0;
			nllOl <= 0;
		end
		else 
		if (txclk != n0Oi_clk_prev && txclk == 1'b1) 
		begin
			n00O <= wire_niOOl_o;
			n0Ol <= wire_niOOO_o;
			n0OOO <= wire_nl00i_dataout;
			nli0O <= wire_nlilO_dataout;
			nliii <= (nllOl ^ nllOi);
			nlliO <= nliii;
			nllli <= nlliO;
			nllll <= nllli;
			nlllO <= nllll;
			nllOi <= nlllO;
			nllOl <= nllOi;
		end
		n0Oi_clk_prev <= txclk;
	end
	assign
		wire_n0Oi_CLRN = (nl11Oi44 ^ nl11Oi43),
		wire_n0Oi_PRN = ((nl11lO46 ^ nl11lO45) & (~ resetall));
	event n00O_event;
	event n0Ol_event;
	event n0OOO_event;
	event nli0O_event;
	event nliii_event;
	event nlliO_event;
	event nllli_event;
	event nllll_event;
	event nlllO_event;
	event nllOi_event;
	event nllOl_event;
	initial
		#1 ->n00O_event;
	initial
		#1 ->n0Ol_event;
	initial
		#1 ->n0OOO_event;
	initial
		#1 ->nli0O_event;
	initial
		#1 ->nliii_event;
	initial
		#1 ->nlliO_event;
	initial
		#1 ->nllli_event;
	initial
		#1 ->nllll_event;
	initial
		#1 ->nlllO_event;
	initial
		#1 ->nllOi_event;
	initial
		#1 ->nllOl_event;
	always @(n00O_event)
		n00O <= 1;
	always @(n0Ol_event)
		n0Ol <= 1;
	always @(n0OOO_event)
		n0OOO <= 1;
	always @(nli0O_event)
		nli0O <= 1;
	always @(nliii_event)
		nliii <= 1;
	always @(nlliO_event)
		nlliO <= 1;
	always @(nllli_event)
		nllli <= 1;
	always @(nllll_event)
		nllll <= 1;
	always @(nlllO_event)
		nlllO <= 1;
	always @(nllOi_event)
		nllOi <= 1;
	always @(nllOl_event)
		nllOl <= 1;
	initial
	begin
		n0Oil = 0;
		n0OiO = 0;
		n0Oli = 0;
		n0Oll = 0;
		n0OOl = 0;
		n1l0l = 0;
		n1l0O = 0;
		n1lii = 0;
		n1lil = 0;
		n1lli = 0;
		n1lll = 0;
		n1OOO = 0;
		nll01i = 0;
		nll1li = 0;
		nll1ll = 0;
		nll1lO = 0;
		nll1Oi = 0;
		nll1OO = 0;
		nlOi0i = 0;
		nlOi0l = 0;
		nlOi0O = 0;
		nlOi1O = 0;
		nlOiil = 0;
		nlOiiO = 0;
	end
	always @ (txclk or wire_n0OOi_PRN or wire_n0OOi_CLRN)
	begin
		if (wire_n0OOi_PRN == 1'b0) 
		begin
			n0Oil <= 1;
			n0OiO <= 1;
			n0Oli <= 1;
			n0Oll <= 1;
			n0OOl <= 1;
			n1l0l <= 1;
			n1l0O <= 1;
			n1lii <= 1;
			n1lil <= 1;
			n1lli <= 1;
			n1lll <= 1;
			n1OOO <= 1;
			nll01i <= 1;
			nll1li <= 1;
			nll1ll <= 1;
			nll1lO <= 1;
			nll1Oi <= 1;
			nll1OO <= 1;
			nlOi0i <= 1;
			nlOi0l <= 1;
			nlOi0O <= 1;
			nlOi1O <= 1;
			nlOiil <= 1;
			nlOiiO <= 1;
		end
		else if  (wire_n0OOi_CLRN == 1'b0) 
		begin
			n0Oil <= 0;
			n0OiO <= 0;
			n0Oli <= 0;
			n0Oll <= 0;
			n0OOl <= 0;
			n1l0l <= 0;
			n1l0O <= 0;
			n1lii <= 0;
			n1lil <= 0;
			n1lli <= 0;
			n1lll <= 0;
			n1OOO <= 0;
			nll01i <= 0;
			nll1li <= 0;
			nll1ll <= 0;
			nll1lO <= 0;
			nll1Oi <= 0;
			nll1OO <= 0;
			nlOi0i <= 0;
			nlOi0l <= 0;
			nlOi0O <= 0;
			nlOi1O <= 0;
			nlOiil <= 0;
			nlOiiO <= 0;
		end
		else 
		if (txclk != n0OOi_clk_prev && txclk == 1'b1) 
		begin
			n0Oil <= wire_ni10i_dataout;
			n0OiO <= wire_ni10l_dataout;
			n0Oli <= wire_ni10O_dataout;
			n0Oll <= wire_ni1ii_dataout;
			n0OOl <= wire_ni1iO_dataout;
			n1l0l <= wire_n1lOO_dataout;
			n1l0O <= wire_n1O1i_dataout;
			n1lii <= wire_n1O1l_dataout;
			n1lil <= wire_n1O1O_dataout;
			n1lli <= wire_n1O0l_dataout;
			n1lll <= wire_ni11i_dataout;
			n1OOO <= wire_nll01l_dataout;
			nll01i <= wire_nlOili_dataout;
			nll1li <= wire_nll00l_dataout;
			nll1ll <= wire_nll00O_dataout;
			nll1lO <= wire_nll0ii_dataout;
			nll1Oi <= wire_nll0il_dataout;
			nll1OO <= wire_nll0li_dataout;
			nlOi0i <= wire_nlOiOl_dataout;
			nlOi0l <= wire_nlOiOO_dataout;
			nlOi0O <= wire_nlOl1i_dataout;
			nlOi1O <= wire_nlOiOi_dataout;
			nlOiil <= wire_nlOl1O_dataout;
			nlOiiO <= wire_n1llO_dataout;
		end
		n0OOi_clk_prev <= txclk;
	end
	assign
		wire_n0OOi_CLRN = (nl111i52 ^ nl111i51),
		wire_n0OOi_PRN = ((niOOOO54 ^ niOOOO53) & (~ resetall));
	initial
	begin
		n1lO = 0;
		nlO0i = 0;
		nlO0l = 0;
		nlO1O = 0;
		nlOil = 0;
	end
	always @ (txclk or wire_n1ll_PRN or wire_n1ll_CLRN)
	begin
		if (wire_n1ll_PRN == 1'b0) 
		begin
			n1lO <= 1;
			nlO0i <= 1;
			nlO0l <= 1;
			nlO1O <= 1;
			nlOil <= 1;
		end
		else if  (wire_n1ll_CLRN == 1'b0) 
		begin
			n1lO <= 0;
			nlO0i <= 0;
			nlO0l <= 0;
			nlO1O <= 0;
			nlOil <= 0;
		end
		else if  (nl101i == 1'b1) 
		if (txclk != n1ll_clk_prev && txclk == 1'b1) 
		begin
			n1lO <= txdatain[25];
			nlO0i <= txdatain[3];
			nlO0l <= txdatain[4];
			nlO1O <= txdatain[2];
			nlOil <= txdatain[7];
		end
		n1ll_clk_prev <= txclk;
	end
	assign
		wire_n1ll_CLRN = (nl11li48 ^ nl11li47),
		wire_n1ll_PRN = ((nl11iO50 ^ nl11iO49) & (~ resetall));
	event n1lO_event;
	event nlO0i_event;
	event nlO0l_event;
	event nlO1O_event;
	event nlOil_event;
	initial
		#1 ->n1lO_event;
	initial
		#1 ->nlO0i_event;
	initial
		#1 ->nlO0l_event;
	initial
		#1 ->nlO1O_event;
	initial
		#1 ->nlOil_event;
	always @(n1lO_event)
		n1lO <= 1;
	always @(nlO0i_event)
		nlO0i <= 1;
	always @(nlO0l_event)
		nlO0l <= 1;
	always @(nlO1O_event)
		nlO1O <= 1;
	always @(nlOil_event)
		nlOil <= 1;
	initial
	begin
		n00l = 0;
		n0O0O = 0;
		n0Oii = 0;
		n0OlO = 0;
		n0OO = 0;
		n1l0i = 0;
		n1l1O = 0;
		n1liO = 0;
		ni1l = 0;
		nl01O = 0;
		nli0i = 0;
		nli0l = 0;
		nli1O = 0;
		nll1il = 0;
		nll1iO = 0;
		nll1Ol = 0;
		nlOi1i = 0;
		nlOi1l = 0;
		nlOiii = 0;
	end
	always @ ( posedge txclk or  negedge wire_ni1i_CLRN)
	begin
		if (wire_ni1i_CLRN == 1'b0) 
		begin
			n00l <= 0;
			n0O0O <= 0;
			n0Oii <= 0;
			n0OlO <= 0;
			n0OO <= 0;
			n1l0i <= 0;
			n1l1O <= 0;
			n1liO <= 0;
			ni1l <= 0;
			nl01O <= 0;
			nli0i <= 0;
			nli0l <= 0;
			nli1O <= 0;
			nll1il <= 0;
			nll1iO <= 0;
			nll1Ol <= 0;
			nlOi1i <= 0;
			nlOi1l <= 0;
			nlOiii <= 0;
		end
		else 
		begin
			n00l <= wire_n0ii_dataout;
			n0O0O <= wire_ni11l_dataout;
			n0Oii <= wire_ni11O_dataout;
			n0OlO <= wire_ni1il_dataout;
			n0OO <= wire_nl11i_o;
			n1l0i <= wire_n1lOl_dataout;
			n1l1O <= wire_n1lOi_dataout;
			n1liO <= wire_n1O0i_dataout;
			ni1l <= wire_nl11l_dataout;
			nl01O <= wire_nliil_dataout;
			nli0i <= wire_nlili_dataout;
			nli0l <= wire_nlill_dataout;
			nli1O <= wire_nliiO_dataout;
			nll1il <= wire_nll01O_dataout;
			nll1iO <= wire_nll00i_dataout;
			nll1Ol <= wire_nll0iO_dataout;
			nlOi1i <= wire_nlOill_dataout;
			nlOi1l <= wire_nlOilO_dataout;
			nlOiii <= wire_nlOl1l_dataout;
		end
	end
	assign
		wire_ni1i_CLRN = ((nl11OO42 ^ nl11OO41) & (~ resetall));
	or(wire_n000i_dataout, txctrl[1], nl100l);
	or(wire_n000l_dataout, txdatain[8], nl100l);
	and(wire_n000O_dataout, txdatain[9], ~(nl100l));
	or(wire_n001i_dataout, wire_n00li_dataout, nl10iO);
	and(wire_n001l_dataout, wire_n00ll_dataout, ~(nl10iO));
	or(wire_n001O_dataout, wire_n00lO_dataout, nl10iO);
	or(wire_n00ii_dataout, txdatain[10], nl100l);
	or(wire_n00il_dataout, txdatain[11], nl100l);
	or(wire_n00iO_dataout, txdatain[12], nl100l);
	or(wire_n00li_dataout, txdatain[13], nl100l);
	or(wire_n00ll_dataout, txdatain[14], nl100l);
	or(wire_n00lO_dataout, txdatain[15], nl100l);
	assign		wire_n00Oi_dataout = (nl111l === 1'b1) ? wire_n01li_dataout : (~ n00l);
	assign		wire_n00Ol_dataout = (nl111l === 1'b1) ? wire_n01ll_dataout : wire_n0iii_dataout;
	assign		wire_n00OO_dataout = (nl111l === 1'b1) ? wire_n01lO_dataout : wire_n0iil_dataout;
	or(wire_n010i_dataout, wire_n01Oi_dataout, ~(nl111l));
	or(wire_n010l_dataout, wire_n01Ol_dataout, ~(nl111l));
	or(wire_n010O_dataout, wire_n01OO_dataout, ~(nl111l));
	or(wire_n011i_dataout, wire_n01li_dataout, ~(nl111l));
	and(wire_n011l_dataout, wire_n01ll_dataout, nl111l);
	and(wire_n011O_dataout, wire_n01lO_dataout, nl111l);
	assign		wire_n01ii_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : (~ nliii);
	and(wire_n01il_dataout, wire_n001l_dataout, nl111l);
	assign		wire_n01iO_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : (~ nliii);
	or(wire_n01li_dataout, wire_n000i_dataout, nl10iO);
	and(wire_n01ll_dataout, wire_n000l_dataout, ~(nl10iO));
	and(wire_n01lO_dataout, wire_n000O_dataout, ~(nl10iO));
	or(wire_n01Oi_dataout, wire_n00ii_dataout, nl10iO);
	or(wire_n01Ol_dataout, wire_n00il_dataout, nl10iO);
	or(wire_n01OO_dataout, wire_n00iO_dataout, nl10iO);
	assign		wire_n0i0i_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : wire_n0ilO_dataout;
	assign		wire_n0i0l_dataout = (nl111l === 1'b1) ? wire_n001l_dataout : wire_n0iOi_dataout;
	assign		wire_n0i0O_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : wire_n0iOl_dataout;
	assign		wire_n0i1i_dataout = (nl111l === 1'b1) ? wire_n01Oi_dataout : wire_n0iiO_dataout;
	assign		wire_n0i1l_dataout = (nl111l === 1'b1) ? wire_n01Ol_dataout : wire_n0ili_dataout;
	assign		wire_n0i1O_dataout = (nl111l === 1'b1) ? wire_n01OO_dataout : wire_n0ill_dataout;
	or(wire_n0ii_dataout, wire_n0il_dataout, nl101i);
	and(wire_n0iii_dataout, nlOiO, n00l);
	and(wire_n0iil_dataout, nlOli, n00l);
	or(wire_n0iiO_dataout, nlOll, ~(n00l));
	and(wire_n0il_dataout, n00l, ~((((((((~ ni1l) & (~ n0OO)) & n0Ol) & (~ n00O)) | ((((~ ni1l) & n0OO) & n0Ol) & n00O)) & nl11ll) & n00l)));
	or(wire_n0ili_dataout, nlOlO, ~(n00l));
	or(wire_n0ill_dataout, nlOOi, ~(n00l));
	assign		wire_n0ilO_dataout = (n00l === 1'b1) ? nlOOl : (~ nliii);
	and(wire_n0iOi_dataout, nlOOO, n00l);
	assign		wire_n0iOl_dataout = (n00l === 1'b1) ? n11i : (~ nliii);
	assign		wire_n0iOO_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : wire_nlO1li_dataout;
	and(wire_n0l0i_dataout, wire_n001O_dataout, nl111l);
	assign		wire_n0l0l_dataout = (nl111l === 1'b1) ? wire_n001i_dataout : wire_n0lii_dataout;
	assign		wire_n0l0O_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : wire_n0lil_dataout;
	assign		wire_n0l1i_dataout = (nl111l === 1'b1) ? wire_n001l_dataout : (~ nl11il);
	assign		wire_n0l1l_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : wire_nlO1ll_dataout;
	and(wire_n0l1O_dataout, wire_n001i_dataout, nl111l);
	and(wire_n0lii_dataout, nlOOl, n00l);
	and(wire_n0lil_dataout, n11i, n00l);
	or(wire_n0liO_dataout, wire_n001i_dataout, ~(nl111l));
	assign		wire_n0lli_dataout = (nl111l === 1'b1) ? wire_n001l_dataout : nl110i;
	assign		wire_n0lll_dataout = (nl111l === 1'b1) ? wire_n001O_dataout : (~ nl110i);
	or(wire_n0llO_dataout, wire_n011i_dataout, ~(rdenablesync));
	and(wire_n0lOi_dataout, wire_n011l_dataout, rdenablesync);
	and(wire_n0lOl_dataout, wire_n011O_dataout, rdenablesync);
	or(wire_n0lOO_dataout, wire_n010i_dataout, ~(rdenablesync));
	and(wire_n0O0i_dataout, wire_n01il_dataout, rdenablesync);
	or(wire_n0O0l_dataout, wire_n0l0i_dataout, ~(rdenablesync));
	or(wire_n0O1i_dataout, wire_n010l_dataout, ~(rdenablesync));
	or(wire_n0O1l_dataout, wire_n010O_dataout, ~(rdenablesync));
	or(wire_n0O1O_dataout, wire_n0l1O_dataout, ~(rdenablesync));
	and(wire_n100i_dataout, n11l, n00l);
	and(wire_n100l_dataout, n11O, n00l);
	or(wire_n100O_dataout, n10i, ~(n00l));
	assign		wire_n101i_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : wire_n10iO_dataout;
	assign		wire_n101l_dataout = (nl111l === 1'b1) ? wire_nlOOOl_dataout : wire_n10li_dataout;
	assign		wire_n101O_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : wire_n10ll_dataout;
	or(wire_n10ii_dataout, n10l, ~(n00l));
	or(wire_n10il_dataout, n10O, ~(n00l));
	assign		wire_n10iO_dataout = (n00l === 1'b1) ? n1ii : (~ nliii);
	and(wire_n10li_dataout, n1il, n00l);
	assign		wire_n10ll_dataout = (n00l === 1'b1) ? n1iO : (~ nliii);
	assign		wire_n10lO_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : wire_nlO1li_dataout;
	assign		wire_n10Oi_dataout = (nl111l === 1'b1) ? wire_nlOOOl_dataout : (~ nl11il);
	assign		wire_n10Ol_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : wire_nlO1ll_dataout;
	and(wire_n10OO_dataout, wire_nlOOOi_dataout, nl111l);
	or(wire_n110i_dataout, txdatain[18], nl101O);
	or(wire_n110l_dataout, txdatain[19], nl101O);
	or(wire_n110O_dataout, txdatain[20], nl101O);
	or(wire_n111i_dataout, txctrl[2], nl101O);
	or(wire_n111l_dataout, txdatain[16], nl101O);
	and(wire_n111O_dataout, txdatain[17], ~(nl101O));
	or(wire_n11ii_dataout, txdatain[21], nl101O);
	or(wire_n11il_dataout, txdatain[22], nl101O);
	or(wire_n11iO_dataout, txdatain[23], nl101O);
	assign		wire_n11li_dataout = (nl111l === 1'b1) ? wire_nlOOii_dataout : (~ n00l);
	assign		wire_n11ll_dataout = (nl111l === 1'b1) ? wire_nlOOil_dataout : wire_n100i_dataout;
	assign		wire_n11lO_dataout = (nl111l === 1'b1) ? wire_nlOOiO_dataout : wire_n100l_dataout;
	assign		wire_n11Oi_dataout = (nl111l === 1'b1) ? wire_nlOOli_dataout : wire_n100O_dataout;
	assign		wire_n11Ol_dataout = (nl111l === 1'b1) ? wire_nlOOll_dataout : wire_n10ii_dataout;
	assign		wire_n11OO_dataout = (nl111l === 1'b1) ? wire_nlOOlO_dataout : wire_n10il_dataout;
	and(wire_n1i0i_dataout, n1ii, n00l);
	and(wire_n1i0l_dataout, n1iO, n00l);
	or(wire_n1i0O_dataout, wire_nlOOOi_dataout, ~(nl111l));
	and(wire_n1i1i_dataout, wire_nlOOOO_dataout, nl111l);
	assign		wire_n1i1l_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : wire_n1i0i_dataout;
	assign		wire_n1i1O_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : wire_n1i0l_dataout;
	assign		wire_n1iii_dataout = (nl111l === 1'b1) ? wire_nlOOOl_dataout : nl110i;
	assign		wire_n1iil_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : (~ nl110i);
	or(wire_n1iiO_dataout, wire_nlOlOi_dataout, ~(rdenablesync));
	and(wire_n1ili_dataout, wire_nlOlOl_dataout, rdenablesync);
	and(wire_n1ill_dataout, wire_nlOlOO_dataout, rdenablesync);
	or(wire_n1ilO_dataout, wire_nlOO1i_dataout, ~(rdenablesync));
	or(wire_n1iOi_dataout, wire_nlOO1l_dataout, ~(rdenablesync));
	or(wire_n1iOl_dataout, wire_nlOO1O_dataout, ~(rdenablesync));
	or(wire_n1iOO_dataout, wire_n10OO_dataout, ~(rdenablesync));
	and(wire_n1l1i_dataout, wire_nlOO0l_dataout, rdenablesync);
	or(wire_n1l1l_dataout, wire_n1i1i_dataout, ~(rdenablesync));
	or(wire_n1llO_dataout, wire_n1O0O_o, nl1Oli);
	and(wire_n1lOi_dataout, wire_n1Oii_o, ~(nl1Oli));
	or(wire_n1lOl_dataout, wire_n1Oil_o, nl1Oli);
	or(wire_n1lOO_dataout, wire_n1OiO_o, nl1Oli);
	or(wire_n1O0i_dataout, wire_n1OOi_o, nl1Oli);
	or(wire_n1O0l_dataout, wire_n1OOl_o, nl1Oli);
	or(wire_n1O1i_dataout, wire_n1Oli_o, nl1Oli);
	or(wire_n1O1l_dataout, wire_n1Oll_o, nl1Oli);
	or(wire_n1O1O_dataout, wire_n1OlO_o, nl1Oli);
	or(wire_ni00i_dataout, wire_ni0Oi_dataout, ~(nl111l));
	and(wire_ni00l_dataout, wire_ni0Ol_dataout, nl111l);
	and(wire_ni00O_dataout, wire_ni0OO_dataout, nl111l);
	or(wire_ni0ii_dataout, wire_nii1i_dataout, ~(nl111l));
	or(wire_ni0il_dataout, wire_nii1l_dataout, ~(nl111l));
	or(wire_ni0iO_dataout, wire_nii1O_dataout, ~(nl111l));
	assign		wire_ni0li_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : (~ nliii);
	and(wire_ni0ll_dataout, wire_nii0l_dataout, nl111l);
	assign		wire_ni0lO_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : (~ nliii);
	or(wire_ni0Oi_dataout, txctrl[0], nl10iO);
	or(wire_ni0Ol_dataout, txdatain[0], nl10iO);
	and(wire_ni0OO_dataout, txdatain[1], ~(nl10iO));
	or(wire_ni10i_dataout, wire_ni1Oi_o, nl01ll);
	or(wire_ni10l_dataout, wire_ni1Ol_o, nl01ll);
	or(wire_ni10O_dataout, wire_ni1OO_o, nl01ll);
	or(wire_ni11i_dataout, wire_ni1li_o, nl01ll);
	and(wire_ni11l_dataout, wire_ni1ll_o, ~(nl01ll));
	or(wire_ni11O_dataout, wire_ni1lO_o, nl01ll);
	or(wire_ni1ii_dataout, wire_ni01i_o, nl01ll);
	or(wire_ni1il_dataout, wire_ni01l_o, nl01ll);
	or(wire_ni1iO_dataout, wire_ni01O_o, nl01ll);
	or(wire_nii0i_dataout, txdatain[5], nl10iO);
	or(wire_nii0l_dataout, txdatain[6], nl10iO);
	or(wire_nii0O_dataout, txdatain[7], nl10iO);
	or(wire_nii1i_dataout, txdatain[2], nl10iO);
	or(wire_nii1l_dataout, txdatain[3], nl10iO);
	or(wire_nii1O_dataout, txdatain[4], nl10iO);
	assign		wire_niiii_dataout = (nl111l === 1'b1) ? wire_ni0Ol_dataout : wire_niiOO_dataout;
	assign		wire_niiil_dataout = (nl111l === 1'b1) ? wire_ni0OO_dataout : wire_nil1i_dataout;
	assign		wire_niiiO_dataout = (nl111l === 1'b1) ? wire_nii1i_dataout : wire_nil1l_dataout;
	assign		wire_niili_dataout = (nl111l === 1'b1) ? wire_nii1l_dataout : wire_nil1O_dataout;
	assign		wire_niill_dataout = (nl111l === 1'b1) ? wire_nii1O_dataout : wire_nil0i_dataout;
	assign		wire_niilO_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : wire_nil0l_dataout;
	assign		wire_niiOi_dataout = (nl111l === 1'b1) ? wire_nii0l_dataout : wire_nil0O_dataout;
	assign		wire_niiOl_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : wire_nilii_dataout;
	and(wire_niiOO_dataout, nllOO, n00l);
	or(wire_nil0i_dataout, nlO0l, ~(n00l));
	assign		wire_nil0l_dataout = (n00l === 1'b1) ? nlO0O : (~ nliii);
	and(wire_nil0O_dataout, nlOii, n00l);
	and(wire_nil1i_dataout, nlO1l, n00l);
	or(wire_nil1l_dataout, nlO1O, ~(n00l));
	or(wire_nil1O_dataout, nlO0i, ~(n00l));
	assign		wire_nilii_dataout = (n00l === 1'b1) ? nlOil : (~ nliii);
	assign		wire_nilil_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : wire_nlO1li_dataout;
	assign		wire_niliO_dataout = (nl111l === 1'b1) ? wire_nii0l_dataout : (~ nl11il);
	assign		wire_nilli_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : wire_nlO1ll_dataout;
	and(wire_nilll_dataout, wire_nii0i_dataout, nl111l);
	and(wire_nillO_dataout, wire_nii0O_dataout, nl111l);
	assign		wire_nilOi_dataout = (nl111l === 1'b1) ? wire_nii0i_dataout : wire_nilOO_dataout;
	assign		wire_nilOl_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : wire_niO1i_dataout;
	and(wire_nilOO_dataout, nlO0O, n00l);
	assign		wire_niO0i_dataout = (nl111l === 1'b1) ? wire_nii0O_dataout : (~ nl110i);
	or(wire_niO0l_dataout, wire_ni00i_dataout, ~(rdenablesync));
	and(wire_niO0O_dataout, wire_ni00l_dataout, rdenablesync);
	and(wire_niO1i_dataout, nlOil, n00l);
	or(wire_niO1l_dataout, wire_nii0i_dataout, ~(nl111l));
	assign		wire_niO1O_dataout = (nl111l === 1'b1) ? wire_nii0l_dataout : nl110i;
	and(wire_niOii_dataout, wire_ni00O_dataout, rdenablesync);
	or(wire_niOil_dataout, wire_ni0ii_dataout, ~(rdenablesync));
	or(wire_niOiO_dataout, wire_ni0il_dataout, ~(rdenablesync));
	or(wire_niOli_dataout, wire_ni0iO_dataout, ~(rdenablesync));
	or(wire_niOll_dataout, wire_nilll_dataout, ~(rdenablesync));
	and(wire_niOlO_dataout, wire_ni0ll_dataout, rdenablesync);
	or(wire_niOOi_dataout, wire_nillO_dataout, ~(rdenablesync));
	or(wire_nl00i_dataout, wire_nl00l_dataout, (((((~ rdenablesync) & nl111O) | wire_nl0OO_o) | (nl11ll & (rdenablesync & nl111O))) | ((nl11il | (~ n0OOO)) & nl110l)));
	and(wire_nl00l_dataout, n0OOO, ~((nl110l & nl110i)));
	or(wire_nl01i_dataout, (~ nl110i), nl111l);
	and(wire_nl01l_dataout, (~ nl111l), rdenablesync);
	or(wire_nl10i_dataout, nliii, nl111l);
	and(wire_nl10l_dataout, (~ nliii), ~(nl111l));
	or(wire_nl10O_dataout, wire_nl1li_dataout, nl111l);
	and(wire_nl11l_dataout, wire_nl1iO_dataout, wire_nl11O_o[7]);
	and(wire_nl1ii_dataout, wire_nl1ll_dataout, ~(nl111l));
	and(wire_nl1il_dataout, (~ n00l), ~(nl111l));
	and(wire_nl1iO_dataout, n00l, ~(nl111l));
	and(wire_nl1li_dataout, nliii, ~(n00l));
	and(wire_nl1ll_dataout, (~ nliii), ~(n00l));
	or(wire_nl1lO_dataout, wire_nl1Ol_dataout, nl111l);
	and(wire_nl1Oi_dataout, wire_nlO1li_dataout, ~(nl111l));
	or(wire_nl1Ol_dataout, nliii, (~ nl11il));
	or(wire_nl1OO_dataout, (~ n00l), nl111l);
	assign		wire_nliil_dataout = (nl110O === 1'b1) ? nliii : wire_nliOi_dataout;
	assign		wire_nliiO_dataout = (nl110O === 1'b1) ? nlliO : wire_nliOl_dataout;
	assign		wire_nlili_dataout = (nl110O === 1'b1) ? nllli : wire_nliOO_dataout;
	assign		wire_nlill_dataout = (nl110O === 1'b1) ? nllll : wire_nll1i_dataout;
	or(wire_nlilO_dataout, wire_nll1l_dataout, nl110O);
	assign		wire_nliOi_dataout = (nl11il === 1'b1) ? wire_nll1O_o[1] : nl01O;
	assign		wire_nliOl_dataout = (nl11il === 1'b1) ? wire_nll1O_o[2] : nli1O;
	assign		wire_nliOO_dataout = (nl11il === 1'b1) ? wire_nll1O_o[3] : nli0i;
	or(wire_nll00i_dataout, wire_nll0Oi_o, nl10OO);
	or(wire_nll00l_dataout, wire_nll0Ol_o, nl10OO);
	or(wire_nll00O_dataout, wire_nll0OO_o, nl10OO);
	or(wire_nll01l_dataout, wire_nll0ll_o, nl10OO);
	and(wire_nll01O_dataout, wire_nll0lO_o, ~(nl10OO));
	or(wire_nll0ii_dataout, wire_nlli1i_o, nl10OO);
	or(wire_nll0il_dataout, wire_nlli1l_o, nl10OO);
	or(wire_nll0iO_dataout, wire_nlli1O_o, nl10OO);
	or(wire_nll0li_dataout, wire_nlli0i_o, nl10OO);
	assign		wire_nll1i_dataout = (nl11il === 1'b1) ? wire_nll1O_o[4] : nli0l;
	assign		wire_nll1l_dataout = (nl11il === 1'b1) ? wire_nll1O_o[5] : nli0O;
	or(wire_nlli0l_dataout, wire_nlliOl_dataout, ~(nl111l));
	and(wire_nlli0O_dataout, wire_nlliOO_dataout, nl111l);
	and(wire_nlliii_dataout, wire_nlll1i_dataout, nl111l);
	or(wire_nlliil_dataout, wire_nlll1l_dataout, ~(nl111l));
	or(wire_nlliiO_dataout, wire_nlll1O_dataout, ~(nl111l));
	or(wire_nllili_dataout, wire_nlll0i_dataout, ~(nl111l));
	assign		wire_nllill_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : (~ nliii);
	and(wire_nllilO_dataout, wire_nlll0O_dataout, nl111l);
	assign		wire_nlliOi_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : (~ nliii);
	or(wire_nlliOl_dataout, wire_nlllil_dataout, niOOOi);
	and(wire_nlliOO_dataout, wire_nllliO_dataout, ~(niOOOi));
	or(wire_nlll0i_dataout, wire_nlllOi_dataout, niOOOi);
	or(wire_nlll0l_dataout, wire_nlllOl_dataout, niOOOi);
	and(wire_nlll0O_dataout, wire_nlllOO_dataout, ~(niOOOi));
	and(wire_nlll1i_dataout, wire_nlllli_dataout, ~(niOOOi));
	or(wire_nlll1l_dataout, wire_nlllll_dataout, niOOOi);
	or(wire_nlll1O_dataout, wire_nllllO_dataout, niOOOi);
	or(wire_nlllii_dataout, wire_nllO1i_dataout, niOOOi);
	or(wire_nlllil_dataout, txctrl[3], nl101l);
	or(wire_nllliO_dataout, txdatain[24], nl101l);
	and(wire_nlllli_dataout, txdatain[25], ~(nl101l));
	or(wire_nlllll_dataout, txdatain[26], nl101l);
	or(wire_nllllO_dataout, txdatain[27], nl101l);
	or(wire_nlllOi_dataout, txdatain[28], nl101l);
	or(wire_nlllOl_dataout, txdatain[29], nl101l);
	or(wire_nlllOO_dataout, txdatain[30], nl101l);
	assign		wire_nllO0l_dataout = (nl111l === 1'b1) ? wire_nlliOl_dataout : (~ n00l);
	assign		wire_nllO0O_dataout = (nl111l === 1'b1) ? wire_nlliOO_dataout : wire_nllOOl_dataout;
	or(wire_nllO1i_dataout, txdatain[31], nl101l);
	assign		wire_nllOii_dataout = (nl111l === 1'b1) ? wire_nlll1i_dataout : wire_nllOOO_dataout;
	assign		wire_nllOil_dataout = (nl111l === 1'b1) ? wire_nlll1l_dataout : wire_nlO11i_dataout;
	assign		wire_nllOiO_dataout = (nl111l === 1'b1) ? wire_nlll1O_dataout : wire_nlO11l_dataout;
	assign		wire_nllOli_dataout = (nl111l === 1'b1) ? wire_nlll0i_dataout : wire_nlO11O_dataout;
	assign		wire_nllOll_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : wire_nlO10i_dataout;
	assign		wire_nllOlO_dataout = (nl111l === 1'b1) ? wire_nlll0O_dataout : wire_nlO10l_dataout;
	assign		wire_nllOOi_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : wire_nlO10O_dataout;
	and(wire_nllOOl_dataout, n1li, n00l);
	and(wire_nllOOO_dataout, n1lO, n00l);
	assign		wire_nlO00i_dataout = (nl111l === 1'b1) ? wire_nlll0O_dataout : nl110i;
	assign		wire_nlO00l_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : (~ nl110i);
	and(wire_nlO01i_dataout, n01i, n00l);
	and(wire_nlO01l_dataout, n00i, n00l);
	or(wire_nlO01O_dataout, wire_nlll0l_dataout, ~(nl111l));
	or(wire_nlO0ii_dataout, wire_nlli0l_dataout, ~(rdenablesync));
	and(wire_nlO0il_dataout, wire_nlli0O_dataout, rdenablesync);
	and(wire_nlO0iO_dataout, wire_nlliii_dataout, rdenablesync);
	or(wire_nlO0li_dataout, wire_nlliil_dataout, ~(rdenablesync));
	or(wire_nlO0ll_dataout, wire_nlliiO_dataout, ~(rdenablesync));
	or(wire_nlO0lO_dataout, wire_nllili_dataout, ~(rdenablesync));
	or(wire_nlO0Oi_dataout, wire_nlO1lO_dataout, ~(rdenablesync));
	and(wire_nlO0Ol_dataout, wire_nllilO_dataout, rdenablesync);
	or(wire_nlO0OO_dataout, wire_nlO1Oi_dataout, ~(rdenablesync));
	assign		wire_nlO10i_dataout = (n00l === 1'b1) ? n01i : (~ nliii);
	and(wire_nlO10l_dataout, n01l, n00l);
	assign		wire_nlO10O_dataout = (n00l === 1'b1) ? n00i : (~ nliii);
	or(wire_nlO11i_dataout, n1Oi, ~(n00l));
	or(wire_nlO11l_dataout, n1Ol, ~(n00l));
	or(wire_nlO11O_dataout, n1OO, ~(n00l));
	assign		wire_nlO1ii_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : wire_nlO1li_dataout;
	assign		wire_nlO1il_dataout = (nl111l === 1'b1) ? wire_nlll0O_dataout : (~ nl11il);
	assign		wire_nlO1iO_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : wire_nlO1ll_dataout;
	or(wire_nlO1li_dataout, (~ nliii), (~ nl11il));
	and(wire_nlO1ll_dataout, (~ nliii), ~((~ nl11il)));
	and(wire_nlO1lO_dataout, wire_nlll0l_dataout, nl111l);
	and(wire_nlO1Oi_dataout, wire_nlllii_dataout, nl111l);
	assign		wire_nlO1Ol_dataout = (nl111l === 1'b1) ? wire_nlll0l_dataout : wire_nlO01i_dataout;
	assign		wire_nlO1OO_dataout = (nl111l === 1'b1) ? wire_nlllii_dataout : wire_nlO01l_dataout;
	or(wire_nlOili_dataout, wire_nlOl0i_o, nl1lii);
	and(wire_nlOill_dataout, wire_nlOl0l_o, ~(nl1lii));
	or(wire_nlOilO_dataout, wire_nlOl0O_o, nl1lii);
	or(wire_nlOiOi_dataout, wire_nlOlii_o, nl1lii);
	or(wire_nlOiOl_dataout, wire_nlOlil_o, nl1lii);
	or(wire_nlOiOO_dataout, wire_nlOliO_o, nl1lii);
	or(wire_nlOl1i_dataout, wire_nlOlli_o, nl1lii);
	or(wire_nlOl1l_dataout, wire_nlOlll_o, nl1lii);
	or(wire_nlOl1O_dataout, wire_nlOllO_o, nl1lii);
	or(wire_nlOlOi_dataout, wire_nlOOii_dataout, ~(nl111l));
	and(wire_nlOlOl_dataout, wire_nlOOil_dataout, nl111l);
	and(wire_nlOlOO_dataout, wire_nlOOiO_dataout, nl111l);
	assign		wire_nlOO0i_dataout = (nl111l === 1'b1) ? wire_nlOOOi_dataout : (~ nliii);
	and(wire_nlOO0l_dataout, wire_nlOOOl_dataout, nl111l);
	assign		wire_nlOO0O_dataout = (nl111l === 1'b1) ? wire_nlOOOO_dataout : (~ nliii);
	or(wire_nlOO1i_dataout, wire_nlOOli_dataout, ~(nl111l));
	or(wire_nlOO1l_dataout, wire_nlOOll_dataout, ~(nl111l));
	or(wire_nlOO1O_dataout, wire_nlOOlO_dataout, ~(nl111l));
	or(wire_nlOOii_dataout, wire_n111i_dataout, niOOOl);
	and(wire_nlOOil_dataout, wire_n111l_dataout, ~(niOOOl));
	and(wire_nlOOiO_dataout, wire_n111O_dataout, ~(niOOOl));
	or(wire_nlOOli_dataout, wire_n110i_dataout, niOOOl);
	or(wire_nlOOll_dataout, wire_n110l_dataout, niOOOl);
	or(wire_nlOOlO_dataout, wire_n110O_dataout, niOOOl);
	or(wire_nlOOOi_dataout, wire_n11ii_dataout, niOOOl);
	and(wire_nlOOOl_dataout, wire_n11il_dataout, ~(niOOOl));
	or(wire_nlOOOO_dataout, wire_n11iO_dataout, niOOOl);
	oper_add   nll1O
	( 
	.a({nli0O, nli0l, nli0i, nli1O, nl01O, 1'b1}),
	.b({{4{1'b1}}, 1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_nll1O_o));
	defparam
		nll1O.sgate_representation = 0,
		nll1O.width_a = 6,
		nll1O.width_b = 6,
		nll1O.width_o = 6;
	oper_decoder   nl11O
	( 
	.i({ni1l, n0OO, n0Ol, n00O}),
	.o(wire_nl11O_o));
	defparam
		nl11O.width_i = 4,
		nl11O.width_o = 16;
	oper_less_than   nl0OO
	( 
	.a({1'b1, {3{1'b0}}}),
	.b({ni1l, n0OO, n0Ol, n00O}),
	.cin(1'b0),
	.o(wire_nl0OO_o));
	defparam
		nl0OO.sgate_representation = 0,
		nl0OO.width_a = 4,
		nl0OO.width_b = 4;
	oper_mux   n1O0O
	( 
	.data({{7{1'b1}}, wire_n011i_dataout, wire_n00Oi_dataout, {3{wire_n011i_dataout}}, wire_n0llO_dataout, wire_n00Oi_dataout, wire_n011i_dataout, 1'b1}),
	.o(wire_n1O0O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1O0O.width_data = 16,
		n1O0O.width_sel = 4;
	oper_mux   n1Oii
	( 
	.data({{7{1'b0}}, wire_n011l_dataout, wire_n00Ol_dataout, {3{wire_n011l_dataout}}, wire_n0lOi_dataout, wire_n00Ol_dataout, wire_n011l_dataout, 1'b0}),
	.o(wire_n1Oii_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oii.width_data = 16,
		n1Oii.width_sel = 4;
	oper_mux   n1Oil
	( 
	.data({{7{1'b0}}, wire_n011O_dataout, wire_n00OO_dataout, {3{wire_n011O_dataout}}, wire_n0lOl_dataout, wire_n00OO_dataout, wire_n011O_dataout, 1'b0}),
	.o(wire_n1Oil_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oil.width_data = 16,
		n1Oil.width_sel = 4;
	oper_mux   n1OiO
	( 
	.data({{7{1'b1}}, wire_n010i_dataout, wire_n0i1i_dataout, {3{wire_n010i_dataout}}, wire_n0lOO_dataout, wire_n0i1i_dataout, wire_n010i_dataout, 1'b1}),
	.o(wire_n1OiO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OiO.width_data = 16,
		n1OiO.width_sel = 4;
	oper_mux   n1Oli
	( 
	.data({{7{1'b1}}, wire_n010l_dataout, wire_n0i1l_dataout, {3{wire_n010l_dataout}}, wire_n0O1i_dataout, wire_n0i1l_dataout, wire_n010l_dataout, 1'b1}),
	.o(wire_n1Oli_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oli.width_data = 16,
		n1Oli.width_sel = 4;
	oper_mux   n1Oll
	( 
	.data({{7{1'b1}}, wire_n010O_dataout, wire_n0i1O_dataout, {3{wire_n010O_dataout}}, wire_n0O1l_dataout, wire_n0i1O_dataout, wire_n010O_dataout, 1'b1}),
	.o(wire_n1Oll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1Oll.width_data = 16,
		n1Oll.width_sel = 4;
	oper_mux   n1OlO
	( 
	.data({{7{1'b1}}, wire_n01ii_dataout, wire_n0i0i_dataout, {2{wire_n0iOO_dataout}}, wire_n0l1O_dataout, wire_n0O1O_dataout, wire_n0l0l_dataout, wire_n0liO_dataout, 1'b1}),
	.o(wire_n1OlO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OlO.width_data = 16,
		n1OlO.width_sel = 4;
	oper_mux   n1OOi
	( 
	.data({{7{1'b0}}, wire_n01il_dataout, wire_n0i0l_dataout, {2{wire_n0l1i_dataout}}, wire_n01il_dataout, wire_n0O0i_dataout, wire_n0i0l_dataout, wire_n0lli_dataout, 1'b0}),
	.o(wire_n1OOi_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OOi.width_data = 16,
		n1OOi.width_sel = 4;
	oper_mux   n1OOl
	( 
	.data({{7{1'b1}}, wire_n01iO_dataout, wire_n0i0O_dataout, {2{wire_n0l1l_dataout}}, wire_n0l0i_dataout, wire_n0O0l_dataout, wire_n0l0O_dataout, wire_n0lll_dataout, 1'b1}),
	.o(wire_n1OOl_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		n1OOl.width_data = 16,
		n1OOl.width_sel = 4;
	oper_mux   ni01i
	( 
	.data({{7{1'b1}}, wire_ni0li_dataout, wire_niilO_dataout, {2{wire_nilil_dataout}}, wire_nilll_dataout, wire_niOll_dataout, wire_nilOi_dataout, wire_niO1l_dataout, 1'b1}),
	.o(wire_ni01i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni01i.width_data = 16,
		ni01i.width_sel = 4;
	oper_mux   ni01l
	( 
	.data({{7{1'b0}}, wire_ni0ll_dataout, wire_niiOi_dataout, {2{wire_niliO_dataout}}, wire_ni0ll_dataout, wire_niOlO_dataout, wire_niiOi_dataout, wire_niO1O_dataout, 1'b0}),
	.o(wire_ni01l_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni01l.width_data = 16,
		ni01l.width_sel = 4;
	oper_mux   ni01O
	( 
	.data({{7{1'b1}}, wire_ni0lO_dataout, wire_niiOl_dataout, {2{wire_nilli_dataout}}, wire_nillO_dataout, wire_niOOi_dataout, wire_nilOl_dataout, wire_niO0i_dataout, 1'b1}),
	.o(wire_ni01O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni01O.width_data = 16,
		ni01O.width_sel = 4;
	oper_mux   ni1li
	( 
	.data({{7{1'b1}}, {5{wire_ni00i_dataout}}, wire_niO0l_dataout, {2{wire_ni00i_dataout}}, 1'b1}),
	.o(wire_ni1li_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1li.width_data = 16,
		ni1li.width_sel = 4;
	oper_mux   ni1ll
	( 
	.data({{7{1'b0}}, wire_ni00l_dataout, wire_niiii_dataout, {3{wire_ni00l_dataout}}, wire_niO0O_dataout, wire_niiii_dataout, wire_ni00l_dataout, 1'b0}),
	.o(wire_ni1ll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1ll.width_data = 16,
		ni1ll.width_sel = 4;
	oper_mux   ni1lO
	( 
	.data({{7{1'b0}}, wire_ni00O_dataout, wire_niiil_dataout, {3{wire_ni00O_dataout}}, wire_niOii_dataout, wire_niiil_dataout, wire_ni00O_dataout, 1'b0}),
	.o(wire_ni1lO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1lO.width_data = 16,
		ni1lO.width_sel = 4;
	oper_mux   ni1Oi
	( 
	.data({{7{1'b1}}, wire_ni0ii_dataout, wire_niiiO_dataout, {3{wire_ni0ii_dataout}}, wire_niOil_dataout, wire_niiiO_dataout, wire_ni0ii_dataout, 1'b1}),
	.o(wire_ni1Oi_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1Oi.width_data = 16,
		ni1Oi.width_sel = 4;
	oper_mux   ni1Ol
	( 
	.data({{7{1'b1}}, wire_ni0il_dataout, wire_niili_dataout, {3{wire_ni0il_dataout}}, wire_niOiO_dataout, wire_niili_dataout, wire_ni0il_dataout, 1'b1}),
	.o(wire_ni1Ol_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1Ol.width_data = 16,
		ni1Ol.width_sel = 4;
	oper_mux   ni1OO
	( 
	.data({{7{1'b1}}, wire_ni0iO_dataout, wire_niill_dataout, {3{wire_ni0iO_dataout}}, wire_niOli_dataout, wire_niill_dataout, wire_ni0iO_dataout, 1'b1}),
	.o(wire_ni1OO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		ni1OO.width_data = 16,
		ni1OO.width_sel = 4;
	oper_mux   niOOl
	( 
	.data({{7{1'b1}}, wire_nl10i_dataout, wire_nl10O_dataout, {2{wire_nl1lO_dataout}}, {2{1'b1}}, wire_nl1OO_dataout, wire_nl01i_dataout, 1'b1}),
	.o(wire_niOOl_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		niOOl.width_data = 16,
		niOOl.width_sel = 4;
	oper_mux   niOOO
	( 
	.data({{7{1'b1}}, wire_nl10l_dataout, wire_nl1ii_dataout, {2{wire_nl1Oi_dataout}}, 1'b0, (~ rdenablesync), 1'b0, (~ nl111l), 1'b1}),
	.o(wire_niOOO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		niOOO.width_data = 16,
		niOOO.width_sel = 4;
	oper_mux   nl11i
	( 
	.data({{7{1'b0}}, (~ nl111l), wire_nl1il_dataout, {3{(~ nl111l)}}, wire_nl01l_dataout, (~ nl111l), {2{1'b0}}}),
	.o(wire_nl11i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nl11i.width_data = 16,
		nl11i.width_sel = 4;
	oper_mux   nll0ll
	( 
	.data({{7{1'b1}}, wire_nlli0l_dataout, wire_nllO0l_dataout, {3{wire_nlli0l_dataout}}, wire_nlO0ii_dataout, wire_nllO0l_dataout, wire_nlli0l_dataout, 1'b1}),
	.o(wire_nll0ll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0ll.width_data = 16,
		nll0ll.width_sel = 4;
	oper_mux   nll0lO
	( 
	.data({{7{1'b0}}, wire_nlli0O_dataout, wire_nllO0O_dataout, {3{wire_nlli0O_dataout}}, wire_nlO0il_dataout, wire_nllO0O_dataout, wire_nlli0O_dataout, 1'b0}),
	.o(wire_nll0lO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0lO.width_data = 16,
		nll0lO.width_sel = 4;
	oper_mux   nll0Oi
	( 
	.data({{7{1'b0}}, wire_nlliii_dataout, wire_nllOii_dataout, {3{wire_nlliii_dataout}}, wire_nlO0iO_dataout, wire_nllOii_dataout, wire_nlliii_dataout, 1'b0}),
	.o(wire_nll0Oi_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0Oi.width_data = 16,
		nll0Oi.width_sel = 4;
	oper_mux   nll0Ol
	( 
	.data({{7{1'b1}}, wire_nlliil_dataout, wire_nllOil_dataout, {3{wire_nlliil_dataout}}, wire_nlO0li_dataout, wire_nllOil_dataout, wire_nlliil_dataout, 1'b1}),
	.o(wire_nll0Ol_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0Ol.width_data = 16,
		nll0Ol.width_sel = 4;
	oper_mux   nll0OO
	( 
	.data({{7{1'b1}}, wire_nlliiO_dataout, wire_nllOiO_dataout, {3{wire_nlliiO_dataout}}, wire_nlO0ll_dataout, wire_nllOiO_dataout, wire_nlliiO_dataout, 1'b1}),
	.o(wire_nll0OO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nll0OO.width_data = 16,
		nll0OO.width_sel = 4;
	oper_mux   nlli0i
	( 
	.data({{7{1'b1}}, wire_nlliOi_dataout, wire_nllOOi_dataout, {2{wire_nlO1iO_dataout}}, wire_nlO1Oi_dataout, wire_nlO0OO_dataout, wire_nlO1OO_dataout, wire_nlO00l_dataout, 1'b1}),
	.o(wire_nlli0i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli0i.width_data = 16,
		nlli0i.width_sel = 4;
	oper_mux   nlli1i
	( 
	.data({{7{1'b1}}, wire_nllili_dataout, wire_nllOli_dataout, {3{wire_nllili_dataout}}, wire_nlO0lO_dataout, wire_nllOli_dataout, wire_nllili_dataout, 1'b1}),
	.o(wire_nlli1i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli1i.width_data = 16,
		nlli1i.width_sel = 4;
	oper_mux   nlli1l
	( 
	.data({{7{1'b1}}, wire_nllill_dataout, wire_nllOll_dataout, {2{wire_nlO1ii_dataout}}, wire_nlO1lO_dataout, wire_nlO0Oi_dataout, wire_nlO1Ol_dataout, wire_nlO01O_dataout, 1'b1}),
	.o(wire_nlli1l_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli1l.width_data = 16,
		nlli1l.width_sel = 4;
	oper_mux   nlli1O
	( 
	.data({{7{1'b0}}, wire_nllilO_dataout, wire_nllOlO_dataout, {2{wire_nlO1il_dataout}}, wire_nllilO_dataout, wire_nlO0Ol_dataout, wire_nllOlO_dataout, wire_nlO00i_dataout, 1'b0}),
	.o(wire_nlli1O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlli1O.width_data = 16,
		nlli1O.width_sel = 4;
	oper_mux   nlOl0i
	( 
	.data({{7{1'b1}}, wire_nlOlOi_dataout, wire_n11li_dataout, {3{wire_nlOlOi_dataout}}, wire_n1iiO_dataout, wire_n11li_dataout, wire_nlOlOi_dataout, 1'b1}),
	.o(wire_nlOl0i_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOl0i.width_data = 16,
		nlOl0i.width_sel = 4;
	oper_mux   nlOl0l
	( 
	.data({{7{1'b0}}, wire_nlOlOl_dataout, wire_n11ll_dataout, {3{wire_nlOlOl_dataout}}, wire_n1ili_dataout, wire_n11ll_dataout, wire_nlOlOl_dataout, 1'b0}),
	.o(wire_nlOl0l_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOl0l.width_data = 16,
		nlOl0l.width_sel = 4;
	oper_mux   nlOl0O
	( 
	.data({{7{1'b0}}, wire_nlOlOO_dataout, wire_n11lO_dataout, {3{wire_nlOlOO_dataout}}, wire_n1ill_dataout, wire_n11lO_dataout, wire_nlOlOO_dataout, 1'b0}),
	.o(wire_nlOl0O_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOl0O.width_data = 16,
		nlOl0O.width_sel = 4;
	oper_mux   nlOlii
	( 
	.data({{7{1'b1}}, wire_nlOO1i_dataout, wire_n11Oi_dataout, {3{wire_nlOO1i_dataout}}, wire_n1ilO_dataout, wire_n11Oi_dataout, wire_nlOO1i_dataout, 1'b1}),
	.o(wire_nlOlii_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlii.width_data = 16,
		nlOlii.width_sel = 4;
	oper_mux   nlOlil
	( 
	.data({{7{1'b1}}, wire_nlOO1l_dataout, wire_n11Ol_dataout, {3{wire_nlOO1l_dataout}}, wire_n1iOi_dataout, wire_n11Ol_dataout, wire_nlOO1l_dataout, 1'b1}),
	.o(wire_nlOlil_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlil.width_data = 16,
		nlOlil.width_sel = 4;
	oper_mux   nlOliO
	( 
	.data({{7{1'b1}}, wire_nlOO1O_dataout, wire_n11OO_dataout, {3{wire_nlOO1O_dataout}}, wire_n1iOl_dataout, wire_n11OO_dataout, wire_nlOO1O_dataout, 1'b1}),
	.o(wire_nlOliO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOliO.width_data = 16,
		nlOliO.width_sel = 4;
	oper_mux   nlOlli
	( 
	.data({{7{1'b1}}, wire_nlOO0i_dataout, wire_n101i_dataout, {2{wire_n10lO_dataout}}, wire_n10OO_dataout, wire_n1iOO_dataout, wire_n1i1l_dataout, wire_n1i0O_dataout, 1'b1}),
	.o(wire_nlOlli_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlli.width_data = 16,
		nlOlli.width_sel = 4;
	oper_mux   nlOlll
	( 
	.data({{7{1'b0}}, wire_nlOO0l_dataout, wire_n101l_dataout, {2{wire_n10Oi_dataout}}, wire_nlOO0l_dataout, wire_n1l1i_dataout, wire_n101l_dataout, wire_n1iii_dataout, 1'b0}),
	.o(wire_nlOlll_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOlll.width_data = 16,
		nlOlll.width_sel = 4;
	oper_mux   nlOllO
	( 
	.data({{7{1'b1}}, wire_nlOO0O_dataout, wire_n101O_dataout, {2{wire_n10Ol_dataout}}, wire_n1i1i_dataout, wire_n1l1l_dataout, wire_n1i1O_dataout, wire_n1iil_dataout, 1'b1}),
	.o(wire_nlOllO_o),
	.sel({ni1l, n0OO, n0Ol, n00O}));
	defparam
		nlOllO.width_data = 16,
		nlOllO.width_sel = 4;
	assign
		niOOOi = (nl101O | niOOOl),
		niOOOl = (nl10iO | nl100l),
		nl000i = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & (~ txdatain[5])) & txdatain[6]) & (~ txdatain[7])),
		nl001l = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl001O = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & (~ txdatain[5])) & txdatain[6]) & txdatain[7]),
		nl00ii = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & (~ txdatain[6])) & (~ txdatain[7])),
		nl00il = (((((((txdatain[0] & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl00ll = (((((((txdatain[0] & txdatain[1]) & (~ txdatain[2])) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl00lO = ((((((((~ txdatain[0]) & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & (~ txdatain[5])) & (~ txdatain[6])) & txdatain[7]),
		nl010O = (((((((txdatain[8] & txdatain[9]) & (~ txdatain[10])) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl011i = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & (~ txdatain[13])) & txdatain[14]) & (~ txdatain[15])),
		nl011l = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & (~ txdatain[14])) & (~ txdatain[15])),
		nl011O = (((((((txdatain[8] & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl01ii = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & (~ txdatain[13])) & (~ txdatain[14])) & txdatain[15]),
		nl01li = (((((((txdatain[8] & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & (~ txdatain[12])) & (~ txdatain[13])) & (~ txdatain[14])) & (~ txdatain[15])),
		nl01ll = ((((((((((((((txctrl[0] & (~ nl0i1l)) & (nl00Oi2 ^ nl00Oi1)) & (~ nl00lO)) & (~ nl00ll)) & (nl00iO4 ^ nl00iO3)) & (~ nl00il)) & (~ nl00ii)) & (nl000l6 ^ nl000l5)) & (~ nl000i)) & (~ nl001O)) & (~ nl001l)) & (nl01OO8 ^ nl01OO7)) & (~ nl01Ol)) & (nl01lO10 ^ nl01lO9)),
		nl01Ol = (((((((txdatain[0] & txdatain[1]) & txdatain[2]) & (~ txdatain[3])) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]),
		nl0i1l = (((((((txdatain[0] & txdatain[1]) & txdatain[2]) & (~ txdatain[3])) & (~ txdatain[4])) & (~ txdatain[5])) & (~ txdatain[6])) & (~ txdatain[7])),
		nl100i = (((((((((((((((txdatain[16] & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl100l = ((((txctrl[1] & txctrl[2]) & txctrl[3]) & nl10il) & (nl100O40 ^ nl100O39)),
		nl101i = ((((txctrl[0] & (~ txctrl[1])) & (~ txctrl[2])) & (~ txctrl[3])) & nl00lO),
		nl101l = (txctrl[3] & nl1iOl),
		nl101O = ((txctrl[2] & txctrl[3]) & nl100i),
		nl10il = (((((((((((((((((((((((txdatain[8] & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]) & txdatain[16]) & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl10iO = (((((txctrl[0] & txctrl[1]) & txctrl[2]) & txctrl[3]) & (nl10ll38 ^ nl10ll37)) & nl10li),
		nl10li = (((((((((((((((((((((((((((((((txdatain[0] & (~ txdatain[1])) & txdatain[2]) & txdatain[3]) & txdatain[4]) & txdatain[5]) & txdatain[6]) & txdatain[7]) & txdatain[8]) & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & (~ txdatain[12])) & (~ txdatain[13])) & (~ txdatain[14])) & (~ txdatain[15])) & txdatain[16]) & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl10Oi = ((((txctrl[0] & txctrl[1]) & txctrl[2]) & txctrl[3]) & nl10Ol),
		nl10Ol = (((((((((((((((((((((((((((((((txdatain[0] & txdatain[1]) & txdatain[2]) & (~ txdatain[3])) & (~ txdatain[4])) & (~ txdatain[5])) & (~ txdatain[6])) & (~ txdatain[7])) & txdatain[8]) & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & (~ txdatain[12])) & (~ txdatain[13])) & (~ txdatain[14])) & (~ txdatain[15])) & txdatain[16]) & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])) & txdatain[24]) & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl10OO = (((((((((((((((txctrl[3] & (~ nl1l0O)) & (nl1l0i26 ^ nl1l0i25)) & (~ nl1l1O)) & (~ nl1l1l)) & (nl1iOO28 ^ nl1iOO27)) & (~ nl1iOl)) & (nl1ilO30 ^ nl1ilO29)) & (~ nl1ill)) & (nl1iiO32 ^ nl1iiO31)) & (~ nl1iil)) & (~ nl1iii)) & (nl1i0l34 ^ nl1i0l33)) & (~ nl1i0i)) & (~ nl1i1O)) & (nl1i1i36 ^ nl1i1i35)),
		nl110i = ((~ nl11il) & n0OOO),
		nl110l = (nl11ll & nl11ii),
		nl110O = ((nl11ll & (~ nl11il)) & ((((((~ ni1l) & n0OO) & n0Ol) & (~ n00O)) | ((((~ ni1l) & n0OO) & (~ n0Ol)) & n00O)) | (n0OOO & nl11ii))),
		nl111l = ((~ nl10Oi) & (~ nl101i)),
		nl111O = ((((~ ni1l) & (~ n0OO)) & n0Ol) & n00O),
		nl11ii = ((((~ ni1l) & (~ n0OO)) & (~ n0Ol)) & n00O),
		nl11il = ((((nli0O | nli0l) | nli0i) | nli1O) | nl01O),
		nl11ll = (nl10Oi | nl101i),
		nl11Ol = 1'b1,
		nl1i0i = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1i1O = (((((((txdatain[24] & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1iii = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & (~ txdatain[29])) & txdatain[30]) & txdatain[31]),
		nl1iil = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & (~ txdatain[29])) & txdatain[30]) & (~ txdatain[31])),
		nl1ill = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & txdatain[29]) & (~ txdatain[30])) & (~ txdatain[31])),
		nl1iOl = (((((((txdatain[24] & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1l0O = (((((((txdatain[24] & txdatain[25]) & txdatain[26]) & (~ txdatain[27])) & (~ txdatain[28])) & (~ txdatain[29])) & (~ txdatain[30])) & (~ txdatain[31])),
		nl1l1l = (((((((txdatain[24] & txdatain[25]) & (~ txdatain[26])) & txdatain[27]) & txdatain[28]) & txdatain[29]) & txdatain[30]) & txdatain[31]),
		nl1l1O = ((((((((~ txdatain[24]) & (~ txdatain[25])) & txdatain[26]) & txdatain[27]) & txdatain[28]) & (~ txdatain[29])) & (~ txdatain[30])) & txdatain[31]),
		nl1lii = (((((((((((((txctrl[2] & (~ nl1OiO)) & (nl1Oii18 ^ nl1Oii17)) & (~ nl1O0O)) & (nl1O0i20 ^ nl1O0i19)) & (~ nl1O1O)) & (~ nl1O1l)) & (~ nl1O1i)) & (~ nl1lOO)) & (nl1lOi22 ^ nl1lOi21)) & (~ nl1llO)) & (nl1lli24 ^ nl1lli23)) & (~ nl1liO)) & (~ nl1lil)),
		nl1lil = (((((((txdatain[16] & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1liO = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1llO = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & (~ txdatain[21])) & txdatain[22]) & txdatain[23]),
		nl1lOO = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & (~ txdatain[21])) & txdatain[22]) & (~ txdatain[23])),
		nl1O0O = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & (~ txdatain[21])) & (~ txdatain[22])) & txdatain[23]),
		nl1O1i = ((((((((~ txdatain[16]) & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & (~ txdatain[22])) & (~ txdatain[23])),
		nl1O1l = (((((((txdatain[16] & (~ txdatain[17])) & txdatain[18]) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1O1O = (((((((txdatain[16] & txdatain[17]) & (~ txdatain[18])) & txdatain[19]) & txdatain[20]) & txdatain[21]) & txdatain[22]) & txdatain[23]),
		nl1OiO = (((((((txdatain[16] & txdatain[17]) & txdatain[18]) & (~ txdatain[19])) & (~ txdatain[20])) & (~ txdatain[21])) & (~ txdatain[22])) & (~ txdatain[23])),
		nl1Oli = ((((((((((((txctrl[1] & (~ nl01li)) & (nl01il12 ^ nl01il11)) & (~ nl01ii)) & (~ nl010O)) & (nl010i14 ^ nl010i13)) & (~ nl011O)) & (~ nl011l)) & (~ nl011i)) & (~ nl1OOO)) & (nl1OOi16 ^ nl1OOi15)) & (~ nl1OlO)) & (~ nl1Oll)),
		nl1Oll = (((((((txdatain[8] & txdatain[9]) & txdatain[10]) & (~ txdatain[11])) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl1OlO = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & txdatain[13]) & txdatain[14]) & txdatain[15]),
		nl1OOO = ((((((((~ txdatain[8]) & (~ txdatain[9])) & txdatain[10]) & txdatain[11]) & txdatain[12]) & (~ txdatain[13])) & txdatain[14]) & txdatain[15]),
		txctrlout = {n1OOO, nll01i, nlOiiO, n1lll},
		txdataout = {nll1OO, nll1Ol, nll1Oi, nll1lO, nll1ll, nll1li, nll1iO, nll1il, nlOiil, nlOiii, nlOi0O, nlOi0l, nlOi0i, nlOi1O, nlOi1l, nlOi1i, n1lli, n1liO, n1lil, n1lii, n1l0O, n1l0l, n1l0i, n1l1O, n0OOl, n0OlO, n0Oll, n0Oli, n0OiO, n0Oil, n0Oii, n0O0O};
endmodule //stratixgx_xgm_tx_sm
//synopsys translate_on
//VALID FILE
//
// stratixgx_reset
//

module stratixgx_xgm_reset_block
   (
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );

   // INPUTs
   input [3:0] txdigitalreset;
   input [3:0] rxdigitalreset;
   input [3:0] rxanalogreset;
   input       pllreset;
   input       pllenable;

   // OUTPUTs:
   output [3:0] txdigitalresetout;
   output [3:0] rxdigitalresetout;   
   output [3:0] txanalogresetout;
   output [3:0] rxanalogresetout;
   output   pllresetout;

   // WIREs:
   wire     HARD_RESET;

   assign HARD_RESET = pllreset || !pllenable;

   // RESET OUTPUTs
   assign rxanalogresetout = {(HARD_RESET | rxanalogreset[3]),
                  (HARD_RESET | rxanalogreset[2]),
                  (HARD_RESET | rxanalogreset[1]),
                  (HARD_RESET | rxanalogreset[0])};
   
   assign txanalogresetout = {HARD_RESET, HARD_RESET,
                  HARD_RESET, HARD_RESET};
      
   assign pllresetout       = rxanalogresetout[0] & rxanalogresetout[1] & 
                  rxanalogresetout[2] & rxanalogresetout[3] & 
                  txanalogresetout[0] & txanalogresetout[1] & 
                  txanalogresetout[2] & txanalogresetout[3];

   assign rxdigitalresetout = {(HARD_RESET | rxdigitalreset[3]),
                   (HARD_RESET | rxdigitalreset[2]),
                   (HARD_RESET | rxdigitalreset[1]),
                   (HARD_RESET | rxdigitalreset[0])};

   assign txdigitalresetout = {(HARD_RESET | txdigitalreset[3]),
                   (HARD_RESET | txdigitalreset[2]),
                   (HARD_RESET | txdigitalreset[1]),
                   (HARD_RESET | txdigitalreset[0])};
         
endmodule // stratixgx_reset_block
///////////////////////////////////////////////////////////////////////////////
//
//                           STRATIXGX_XGM_INTERFACE
//
///////////////////////////////////////////////////////////////////////////////



//
// stratixgx_xgm_interface
//

`timescale 1 ps/1 ps

module stratixgx_xgm_interface
   (
    txdatain,
    txctrl,
    rdenablesync,
    txclk,
    rxdatain,
    rxctrl,
    rxrunningdisp,
    rxdatavalid,
    rxclk,
    resetall,
    adet,
    syncstatus,
    rdalign,
    recovclk,
    devpor,
    devclrn,
    txdataout,
    txctrlout,
    rxdataout,
    rxctrlout,
    resetout,
    alignstatus,
    enabledeskew,
    fiforesetrd,
    // PE ONLY PORTS
    scanclk, 
    scanin, 
    scanshift,
    scanmode,
    scanout,
    test,
    digitalsmtest,
    calibrationstatus,
    // MDIO PORTS
    mdiodisable,
    mdioclk,
    mdioin,
    rxppmselect,
    mdioout,
    mdiooe,
    // RESET PORTS
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );

   parameter use_continuous_calibration_mode = "false";
   parameter mode_is_xaui = "false";
   parameter digital_test_output_select = 0;
   parameter analog_test_output_signal_select = 0;
   parameter analog_test_output_channel_select = 0;
   parameter rx_ppm_setting_0 = 0;
   parameter rx_ppm_setting_1 = 0;
   parameter use_rx_calibration_status = "false";
   parameter use_global_serial_loopback = "false";
   parameter rx_calibration_test_write_value = 0;
   parameter enable_rx_calibration_test_write = "false";
   parameter tx_calibration_test_write_value = 0;
   parameter enable_tx_calibration_test_write = "false";
      
   input [31 : 0] txdatain;
   input [3 : 0]  txctrl;
   input      rdenablesync;
   input      txclk;
   input [31 : 0] rxdatain;
   input [3 : 0]  rxctrl;
   input [3 : 0]  rxrunningdisp;
   input [3 : 0]  rxdatavalid;
   input      rxclk;
   input      resetall;
   input [3 : 0]  adet;
   input [3 : 0]  syncstatus;
   input [3 : 0]  rdalign;
   input      recovclk;
   input      devpor;
   input      devclrn;
   
   // RESET PORTS
   input [3:0]    txdigitalreset;
   input [3:0]    rxdigitalreset;
   input [3:0]    rxanalogreset;
   input      pllreset;
   input      pllenable;

   // NEW MDIO/PE ONLY PORTS
   input      mdioclk;
   input      mdiodisable;
   input      mdioin;
   input      rxppmselect;
   input      scanclk;
   input      scanin;
   input      scanmode;
   input      scanshift;
   
   output [31 : 0] txdataout;
   output [3 : 0]  txctrlout;
   output [31 : 0] rxdataout;
   output [3 : 0]  rxctrlout;
   output      resetout;
   output      alignstatus;
   output      enabledeskew;
   output      fiforesetrd;
   
   // RESET PORTS
   output [3:0]    txdigitalresetout;
   output [3:0]    rxdigitalresetout;   
   output [3:0]    txanalogresetout;
   output [3:0]    rxanalogresetout;
   output      pllresetout;

   // NEW MDIO/PE ONLY PORTS
   output [4:0]    calibrationstatus;
   output [3:0]    digitalsmtest;
   output      mdiooe;
   output      mdioout;
   output      scanout;
   output      test;

// wire declarations
wire txdatain_in0;
wire txdatain_in1;
wire txdatain_in2;
wire txdatain_in3;
wire txdatain_in4;
wire txdatain_in5;
wire txdatain_in6;
wire txdatain_in7;
wire txdatain_in8;
wire txdatain_in9;
wire txdatain_in10;
wire txdatain_in11;
wire txdatain_in12;
wire txdatain_in13;
wire txdatain_in14;
wire txdatain_in15;
wire txdatain_in16;
wire txdatain_in17;
wire txdatain_in18;
wire txdatain_in19;
wire txdatain_in20;
wire txdatain_in21;
wire txdatain_in22;
wire txdatain_in23;
wire txdatain_in24;
wire txdatain_in25;
wire txdatain_in26;
wire txdatain_in27;
wire txdatain_in28;
wire txdatain_in29;
wire txdatain_in30;
wire txdatain_in31;
wire rxdatain_in0;
wire rxdatain_in1;
wire rxdatain_in2;
wire rxdatain_in3;
wire rxdatain_in4;
wire rxdatain_in5;
wire rxdatain_in6;
wire rxdatain_in7;
wire rxdatain_in8;
wire rxdatain_in9;
wire rxdatain_in10;
wire rxdatain_in11;
wire rxdatain_in12;
wire rxdatain_in13;
wire rxdatain_in14;
wire rxdatain_in15;
wire rxdatain_in16;
wire rxdatain_in17;
wire rxdatain_in18;
wire rxdatain_in19;
wire rxdatain_in20;
wire rxdatain_in21;
wire rxdatain_in22;
wire rxdatain_in23;
wire rxdatain_in24;
wire rxdatain_in25;
wire rxdatain_in26;
wire rxdatain_in27;
wire rxdatain_in28;
wire rxdatain_in29;
wire rxdatain_in30;
wire rxdatain_in31;
wire txctrl_in0;
wire txctrl_in1;
wire txctrl_in2;
wire txctrl_in3;
wire rxctrl_in0;
wire rxctrl_in1;
wire rxctrl_in2;
wire rxctrl_in3;
wire txclk_in;
wire rxclk_in;
wire recovclk_in;
wire rdenablesync_in;
wire resetall_in;
wire rxrunningdisp_in0;
wire rxrunningdisp_in1;
wire rxrunningdisp_in2;
wire rxrunningdisp_in3;
wire rxdatavalid_in0;
wire rxdatavalid_in1;
wire rxdatavalid_in2;
wire rxdatavalid_in3;
wire adet_in0;
wire adet_in1;
wire adet_in2;
wire adet_in3;
wire syncstatus_in0;
wire syncstatus_in1;
wire syncstatus_in2;
wire syncstatus_in3;
wire rdalign_in0;
wire rdalign_in1;
wire rdalign_in2;
wire rdalign_in3;

// input buffers
buf(txdatain_in0, txdatain[0]);
buf(txdatain_in1, txdatain[1]);
buf(txdatain_in2, txdatain[2]);
buf(txdatain_in3, txdatain[3]);
buf(txdatain_in4, txdatain[4]);
buf(txdatain_in5, txdatain[5]);
buf(txdatain_in6, txdatain[6]);
buf(txdatain_in7, txdatain[7]);
buf(txdatain_in8, txdatain[8]);
buf(txdatain_in9, txdatain[9]);
buf(txdatain_in10, txdatain[10]);
buf(txdatain_in11, txdatain[11]);
buf(txdatain_in12, txdatain[12]);
buf(txdatain_in13, txdatain[13]);
buf(txdatain_in14, txdatain[14]);
buf(txdatain_in15, txdatain[15]);
buf(txdatain_in16, txdatain[16]);
buf(txdatain_in17, txdatain[17]);
buf(txdatain_in18, txdatain[18]);
buf(txdatain_in19, txdatain[19]);
buf(txdatain_in20, txdatain[20]);
buf(txdatain_in21, txdatain[21]);
buf(txdatain_in22, txdatain[22]);
buf(txdatain_in23, txdatain[23]);
buf(txdatain_in24, txdatain[24]);
buf(txdatain_in25, txdatain[25]);
buf(txdatain_in26, txdatain[26]);
buf(txdatain_in27, txdatain[27]);
buf(txdatain_in28, txdatain[28]);
buf(txdatain_in29, txdatain[29]);
buf(txdatain_in30, txdatain[30]);
buf(txdatain_in31, txdatain[31]);

buf(rxdatain_in0, rxdatain[0]);
buf(rxdatain_in1, rxdatain[1]);
buf(rxdatain_in2, rxdatain[2]);
buf(rxdatain_in3, rxdatain[3]);
buf(rxdatain_in4, rxdatain[4]);
buf(rxdatain_in5, rxdatain[5]);
buf(rxdatain_in6, rxdatain[6]);
buf(rxdatain_in7, rxdatain[7]);
buf(rxdatain_in8, rxdatain[8]);
buf(rxdatain_in9, rxdatain[9]);
buf(rxdatain_in10, rxdatain[10]);
buf(rxdatain_in11, rxdatain[11]);
buf(rxdatain_in12, rxdatain[12]);
buf(rxdatain_in13, rxdatain[13]);
buf(rxdatain_in14, rxdatain[14]);
buf(rxdatain_in15, rxdatain[15]);
buf(rxdatain_in16, rxdatain[16]);
buf(rxdatain_in17, rxdatain[17]);
buf(rxdatain_in18, rxdatain[18]);
buf(rxdatain_in19, rxdatain[19]);
buf(rxdatain_in20, rxdatain[20]);
buf(rxdatain_in21, rxdatain[21]);
buf(rxdatain_in22, rxdatain[22]);
buf(rxdatain_in23, rxdatain[23]);
buf(rxdatain_in24, rxdatain[24]);
buf(rxdatain_in25, rxdatain[25]);
buf(rxdatain_in26, rxdatain[26]);
buf(rxdatain_in27, rxdatain[27]);
buf(rxdatain_in28, rxdatain[28]);
buf(rxdatain_in29, rxdatain[29]);
buf(rxdatain_in30, rxdatain[30]);
buf(rxdatain_in31, rxdatain[31]);

buf(txctrl_in0, txctrl[0]);
buf(txctrl_in1, txctrl[1]);
buf(txctrl_in2, txctrl[2]);
buf(txctrl_in3, txctrl[3]);

buf(rxctrl_in0, rxctrl[0]);
buf(rxctrl_in1, rxctrl[1]);
buf(rxctrl_in2, rxctrl[2]);
buf(rxctrl_in3, rxctrl[3]);

buf(txclk_in, txclk);
buf(rxclk_in, rxclk);
buf(recovclk_in, recovclk);

buf (rdenablesync_in, rdenablesync);
buf (resetall_in, resetall);

buf(rxrunningdisp_in0, rxrunningdisp[0]);
buf(rxrunningdisp_in1, rxrunningdisp[1]);
buf(rxrunningdisp_in2, rxrunningdisp[2]);
buf(rxrunningdisp_in3, rxrunningdisp[3]);

buf(rxdatavalid_in0, rxdatavalid[0]);
buf(rxdatavalid_in1, rxdatavalid[1]);
buf(rxdatavalid_in2, rxdatavalid[2]);
buf(rxdatavalid_in3, rxdatavalid[3]);

buf(adet_in0, adet[0]);
buf(adet_in1, adet[1]);
buf(adet_in2, adet[2]);
buf(adet_in3, adet[3]);

buf(syncstatus_in0, syncstatus[0]);
buf(syncstatus_in1, syncstatus[1]);
buf(syncstatus_in2, syncstatus[2]);
buf(syncstatus_in3, syncstatus[3]);

buf(rdalign_in0, rdalign[0]);
buf(rdalign_in1, rdalign[1]);
buf(rdalign_in2, rdalign[2]);
buf(rdalign_in3, rdalign[3]);

// internal input signals
wire reset_int;

assign reset_int = resetall_in;

// internal data bus
wire [31 : 0] txdatain_in;
wire [31 : 0] rxdatain_in;
wire [3 : 0] txctrl_in;
wire [3 : 0] rxctrl_in;
wire [3 : 0] rxrunningdisp_in;
wire [3 : 0] rxdatavalid_in;
wire [3 : 0] adet_in;
wire [3 : 0] syncstatus_in;
wire [3 : 0] rdalign_in;

assign txdatain_in = {
                            txdatain_in31, txdatain_in30, txdatain_in29,
                            txdatain_in28, txdatain_in27, txdatain_in26,
                            txdatain_in25, txdatain_in24, txdatain_in23,
                            txdatain_in22, txdatain_in21, txdatain_in20,
                            txdatain_in19, txdatain_in18, txdatain_in17,
                            txdatain_in16, txdatain_in15, txdatain_in14,
                            txdatain_in13, txdatain_in12, txdatain_in11,
                            txdatain_in10, txdatain_in9, txdatain_in8,
                            txdatain_in7, txdatain_in6, txdatain_in5,
                            txdatain_in4, txdatain_in3, txdatain_in2,
                            txdatain_in1, txdatain_in0
                            };
                            
assign rxdatain_in = {
                            rxdatain_in31, rxdatain_in30, rxdatain_in29,
                            rxdatain_in28, rxdatain_in27, rxdatain_in26,
                            rxdatain_in25, rxdatain_in24, rxdatain_in23,
                            rxdatain_in22, rxdatain_in21, rxdatain_in20,
                            rxdatain_in19, rxdatain_in18, rxdatain_in17,
                            rxdatain_in16, rxdatain_in15, rxdatain_in14,
                            rxdatain_in13, rxdatain_in12, rxdatain_in11,
                            rxdatain_in10, rxdatain_in9, rxdatain_in8,
                            rxdatain_in7, rxdatain_in6, rxdatain_in5,
                            rxdatain_in4, rxdatain_in3, rxdatain_in2,
                            rxdatain_in1, rxdatain_in0
                            };
                            
assign txctrl_in = {txctrl_in3, txctrl_in2, txctrl_in1, txctrl_in0};
assign rxctrl_in = {rxctrl_in3, rxctrl_in2, rxctrl_in1, rxctrl_in0};

assign rxrunningdisp_in = {rxrunningdisp_in3, rxrunningdisp_in2, 
                                    rxrunningdisp_in1, rxrunningdisp_in0};

assign rxdatavalid_in = {rxdatavalid_in3, rxdatavalid_in2, 
                                rxdatavalid_in1, rxdatavalid_in0};

assign adet_in = {adet_in3, adet_in2, adet_in1, adet_in0};

assign syncstatus_in = {syncstatus_in3, syncstatus_in2, 
                                syncstatus_in1, syncstatus_in0};

assign rdalign_in = {rdalign_in3, rdalign_in2, 
                            rdalign_in1, rdalign_in0};

// internal output signals
wire resetout_tmp;

assign resetout_tmp = resetall_in;

// adding devpor and devclrn - do not merge to MF models
wire extended_pllreset;
assign extended_pllreset = pllreset || (!devpor) || (!devclrn);

   stratixgx_xgm_reset_block stratixgx_reset
      (
       .txdigitalreset(txdigitalreset),
       .rxdigitalreset(rxdigitalreset),
       .rxanalogreset(rxanalogreset),
       .pllreset(extended_pllreset),
       .pllenable(pllenable),
       .txdigitalresetout(txdigitalresetout),
       .rxdigitalresetout(rxdigitalresetout),
       .txanalogresetout(txanalogresetout),
       .rxanalogresetout(rxanalogresetout),
       .pllresetout(pllresetout)
       );

   stratixgx_xgm_rx_sm s_xgm_rx_sm 
      (
       .rxdatain(rxdatain_in),
       .rxctrl(rxctrl_in),
       .rxrunningdisp(rxrunningdisp_in),
       .rxdatavalid(rxdatavalid_in),
       .rxclk(rxclk_in),
       .resetall(rxdigitalresetout[0]),
       .rxdataout(rxdataout),
       .rxctrlout(rxctrlout)
       );
   
   stratixgx_xgm_tx_sm s_xgm_tx_sm 
      (
       .txdatain(txdatain_in),
       .txctrl(txctrl_in),
       .rdenablesync(rdenablesync_in),
       .txclk(txclk_in),
       .resetall(txdigitalresetout[0]),
       .txdataout(txdataout),
       .txctrlout(txctrlout)
       );
   
   stratixgx_xgm_dskw_sm s_xgm_dskw_sm 
      (
       .resetall(rxdigitalresetout[0]),
       .adet(adet_in),
       .syncstatus(syncstatus_in),
       .rdalign(rdalign_in),
       .recovclk(recovclk_in),
       .alignstatus(alignstatus),
       .enabledeskew(enabledeskew),
       .fiforesetrd(fiforesetrd)
       );
   
   and (resetout, resetout_tmp,  1'b1);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                               STRATIXGX_TX_CORE
//
///////////////////////////////////////////////////////////////////////////////
   
`timescale 10 ps / 1 ps
module stratixgx_tx_core 
   (
    reset,
    datain,
    writeclk,
    readclk,
    ctrlena,
    forcedisp,
    dataout,
    forcedispout,
    ctrlenaout,
    rdenasync,
    xgmctrlena,
    xgmdataout,
    pre8b10bdataout
    );

   parameter use_double_data_mode = "false";    
   parameter use_fifo_mode        = "true";
   parameter transmit_protocol    = "none";
   parameter channel_width        = 10;
   parameter KCHAR  = 1'b0; // enable control char 
   parameter ECHAR  = 1'b0; // enable error char

   input reset;
   input [19:0] datain;
   input writeclk;
   input readclk;
   input [1:0] ctrlena;
   input [1:0] forcedisp;
   
   output      forcedispout;
   output      ctrlenaout;
   output      rdenasync;
   output      xgmctrlena;
   output [9:0] dataout;
   output [7:0] xgmdataout;
   output [9:0] pre8b10bdataout;
   
   reg      kchar_sync_1;
   reg      kchar_sync;
   reg      echar_sync_1;
   reg      echar_sync;
   reg [11:0]   datain_high;
   reg [11:0]   datain_low;
   reg [11:0]   fifo_high_tmp;
   reg [11:0]   fifo_high_dly1;
   reg [11:0]   fifo_high_dly2;
   reg [11:0]   fifo_high_dly3;
   reg [11:0]   fifo_low_tmp;
   reg [11:0]   fifo_low_dly1;
   reg [11:0]   fifo_low_dly2;
   reg [11:0]   fifo_low_dly3;
   reg      wr_enable;
   reg      rd_enable_sync_1;
   reg      rd_enable_sync_2; 
   reg      rd_enable_sync_out;
   reg      fifo_select_out;
   wire     rdenasync_tmp; 

   reg      writeclk_dly; 
   reg [11:0]   dataout_read;

   wire     out_ena1;
   wire     out_ena2;
   wire     out_ena3;
   wire     out_ena4;
   wire     out_ena5;
   wire     doublewidth;
   wire     disablefifo;
   wire     individual;

   assign doublewidth = (use_double_data_mode == "true") ? 1'b1 : 1'b0;
   assign disablefifo = (use_fifo_mode == "false") ? 1'b1 : 1'b0;
   assign individual  = (transmit_protocol != "xaui") ? 1'b1 : 1'b0;

   always @ (writeclk)
     begin
       writeclk_dly <= writeclk;
     end

   // READ CLOCK SYNC LOGIC
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           kchar_sync_1 <= 1'b0;
           kchar_sync   <= 1'b0;
           echar_sync_1 <= 1'b0;
           echar_sync   <= 1'b0;
        end
     else
        begin
           kchar_sync_1 <= KCHAR;
           kchar_sync   <= kchar_sync_1;
           echar_sync_1 <= ECHAR;
           echar_sync   <= echar_sync_1;
        end
      end
   
   assign dataout         = dataout_read[9:0];
   assign xgmdataout      = dataout_read[7:0];
   assign pre8b10bdataout = dataout_read[9:0];

   assign forcedispout    = dataout_read[10];
   assign ctrlenaout      = dataout_read[11];
   assign xgmctrlena      = dataout_read[11];

   assign rdenasync       = rdenasync_tmp;
      
   always @ (reset or writeclk_dly or datain or forcedisp or ctrlena)
   begin
     if (reset)
       begin
          datain_high[11:0]   <= 'b0;
          datain_low[11:0]   <= 'b0;
       end
     else
       begin
          if (channel_width == 10 || channel_width == 20)
            begin
              if (doublewidth)
                datain_high[11:0] <= {ctrlena[1], forcedisp[1], datain[19:10]};
              else
                datain_high[11:0] <= {ctrlena[0], forcedisp[0], datain[9:0]};
           
              datain_low[11:0] <= {ctrlena[0], forcedisp[0], datain[9:0]};
            end
          else
            begin
              if (doublewidth)
                datain_high[11:0] <= {ctrlena[1], forcedisp[1], 2'b00, datain[15:8]};
              else
                datain_high[11:0] <= {ctrlena[0], forcedisp[0], 2'b00, datain[7:0]};
           
             datain_low[11:0] <= {ctrlena[0], forcedisp[0], 2'b00, datain[7:0]};
            end

       end
   end
   
   // FIFO FOR HIGH BITS
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        begin
           fifo_high_dly1 <= 10'b0;
           fifo_high_dly2 <= 10'b0;
           fifo_high_dly3 <= 10'b0;
           fifo_high_tmp  <= 10'b0;
        end
     else
        begin
           fifo_high_dly1 <= datain_high;
           fifo_high_dly2 <= fifo_high_dly1;
           fifo_high_dly3 <= fifo_high_dly2;
           fifo_high_tmp  <= fifo_high_dly3;
        end
      end 

   // FIFO FOR LOWER BITS
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        begin
           fifo_low_dly1 <= 'b0;
           fifo_low_dly2 <= 'b0;
           fifo_low_dly3 <= 'b0;
           fifo_low_tmp  <= 'b0;
        end
     else
        begin
           fifo_low_dly1 <= datain_low;
           fifo_low_dly2 <= fifo_low_dly1;
           fifo_low_dly3 <= fifo_low_dly2;
           fifo_low_tmp  <= fifo_low_dly3;
        end
      end 

   // DATAOUT ENABLE LOGIC
   assign out_ena1 = (~disablefifo & rdenasync_tmp & (~doublewidth | fifo_select_out) & ~kchar_sync & ~echar_sync);
   assign out_ena2 = (~disablefifo & rdenasync_tmp & (doublewidth & ~fifo_select_out) & ~kchar_sync & ~echar_sync);
   assign out_ena3 = (disablefifo & (~doublewidth | ~fifo_select_out) & ~kchar_sync & ~echar_sync);
   assign out_ena4 = (~kchar_sync & echar_sync);
   assign out_ena5 = (disablefifo & doublewidth & fifo_select_out & ~kchar_sync & ~echar_sync);
   
   // Dataout, CTRL, FORCE_DISP registered by read clock
   always @ (posedge reset or posedge readclk)
     begin
     if (reset)
         dataout_read      <= 'b0;
     else
       begin
       if (out_ena1)
         dataout_read <= fifo_low_tmp;
       else if (out_ena2)
         dataout_read <= fifo_high_tmp;
       else if (out_ena3)
         dataout_read <= datain_low;         
       else if (out_ena4)
         begin
           dataout_read[7:0] <= 8'b11111110;
           dataout_read[10] <= 1'b0;
           dataout_read[11] <= 1'b1;
         end
       else if (out_ena5)
         begin
           dataout_read <= datain_high;
         end
       else 
         begin
           dataout_read[10] <= 1'b0;
           dataout_read[11] <= 1'b1;  // fixed from 3.0
           if (~individual)
             dataout_read[7:0] <= 8'b00000111; 
           else
             dataout_read[7:0] <= 8'b10111100;
         end
         
       end // end of not reset
     end // end of always


   // fifo_select_out == 1: send out low byte

   always @(posedge reset or writeclk_dly)
     begin
       if (reset | writeclk_dly)
         fifo_select_out  <= 1'b1;
       else
         fifo_select_out  <= 1'b0;
       end

   // Delay chains on RD_ENA 
   always @(posedge reset or posedge readclk)
     begin
    if (reset)
      begin
         rd_enable_sync_1 <= 1'b0;
         rd_enable_sync_2 <= 1'b0;
         rd_enable_sync_out <= 1'b0;
      end
    else
      begin
         rd_enable_sync_1 <= wr_enable | disablefifo;
         rd_enable_sync_2 <= rd_enable_sync_1;
         rd_enable_sync_out <= rd_enable_sync_2;
      end
     end
   
   always @ (posedge reset or posedge writeclk_dly)
     begin
    if (reset)
      wr_enable <= 1'b0;
    else
      wr_enable <= 1'b1;
     end

   assign rdenasync_tmp  = (individual)? rd_enable_sync_out : rd_enable_sync_1;
   
endmodule // stratixgx_tx_core

//
// STRATIXGX_HSSI_TX_SERDES
//

`timescale 1 ps/1 ps

module stratixgx_hssi_tx_serdes
    (
        clk, 
        clk1, 
        datain, 
        serialdatain, 
        srlpbk, 
        areset, 
        dataout 
    );

input [9:0] datain;
input clk; // fast clock
input clk1; //slow clock
input   serialdatain;
input   srlpbk;
input areset;

output dataout;

parameter channel_width = 10;

integer i;
integer pclk_count;
integer shift_edge;
reg dataout_tmp;
reg [9:0] regdata;
reg [9:0] shiftdata;

reg clk_dly;
reg clk1_dly;

wire datain_in0,datain_in1,datain_in2,datain_in3,datain_in4;
wire datain_in5,datain_in6,datain_in7,datain_in8,datain_in9;

buf (datain_in0, datain[0]);
buf (datain_in1, datain[1]);
buf (datain_in2, datain[2]);
buf (datain_in3, datain[3]);
buf (datain_in4, datain[4]);
buf (datain_in5, datain[5]);
buf (datain_in6, datain[6]);
buf (datain_in7, datain[7]);
buf (datain_in8, datain[8]);
buf (datain_in9, datain[9]);

initial
begin
   i = 0;
   pclk_count = 0;
   shift_edge = channel_width/2;
   dataout_tmp = 1'bX;
    for (i = 9; i >= 0; i = i - 1) 
    begin
        regdata[i] = 1'bZ;
        shiftdata[i] = 1'bZ;
    end
end

always @(clk or clk1)
begin
   clk_dly <= clk;
   clk1_dly = clk1;
end

always @(clk_dly or areset)
begin
    if (areset == 1'b1)
      dataout_tmp = 1'bZ;
   else 
   begin // dataout comes out on both edges 
      //load on the first fast clk after slow clk to avoid race condition
      if (pclk_count == 1)
      begin
            regdata[0] = datain_in9; 
          regdata[1] = datain_in8; 
          regdata[2] = datain_in7; 
          regdata[3] = datain_in6; 
          regdata[4] = datain_in5; 
          regdata[5] = datain_in4; 
          regdata[6] = datain_in3; 
          regdata[7] = datain_in2; 
          regdata[8] = datain_in1; 
          regdata[9] = datain_in0; 
      end

      if (clk == 1'b1) // rising edge
      begin
         pclk_count = pclk_count + 1;

         // loading edge
         if (pclk_count == shift_edge) 
            shiftdata = regdata;
      end

        if (srlpbk == 1'b1)
        dataout_tmp = serialdatain;
        else
        dataout_tmp = shiftdata[9];

      for (i = 9; i > (10 - channel_width); i = i - 1)
            shiftdata[i] = shiftdata[i-1];
    end
end

always @(posedge clk1_dly or areset)
begin
    if (areset == 1'b1)
   begin
    for (i = 9; i >= 0; i = i - 1) 
        begin
            regdata[i] = 1'bZ;
            shiftdata[i] = 1'bZ;
        end
   end
   else 
      begin
         pclk_count = 0;
        end
end

and (dataout, dataout_tmp,  1'b1);

endmodule
//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 67 mux21 46 oper_selector 10 
`timescale 1 ps / 1 ps
module  stratixgx_hssi_tx_enc_rtl
	( 
	ENDEC,
	GE_XAUI_SEL,
	IB_FORCE_DISPARITY,
	INDV,
	prbs_en,
	PUDR,
	soft_reset,
	tx_clk,
	tx_ctl_tc,
	tx_ctl_ts,
	tx_data_9_tc,
	tx_data_pg,
	tx_data_tc,
	tx_data_ts,
	TXLP10B) /* synthesis synthesis_clearbox=1 */;
	input   ENDEC;
	input   GE_XAUI_SEL;
	input   IB_FORCE_DISPARITY;
	input   INDV;
	input   prbs_en;
	output   [9:0]  PUDR;
	input   soft_reset;
	input   tx_clk;
	input   tx_ctl_tc;
	input   tx_ctl_ts;
	input   tx_data_9_tc;
	input   [9:0]  tx_data_pg;
	input   [7:0]  tx_data_tc;
	input   [7:0]  tx_data_ts;
	output   [9:0]  TXLP10B;

	reg	n100l27;
	reg	n100l28;
	reg	n101O29;
	reg	n101O30;
	reg	n10ii25;
	reg	n10ii26;
	reg	n10li23;
	reg	n10li24;
	reg	n10lO21;
	reg	n10lO22;
	reg	n10OO19;
	reg	n10OO20;
	reg	n11ii43;
	reg	n11ii44;
	reg	n11il41;
	reg	n11il42;
	reg	n11iO39;
	reg	n11iO40;
	reg	n11li37;
	reg	n11li38;
	reg	n11ll35;
	reg	n11ll36;
	reg	n11lO33;
	reg	n11lO34;
	reg	n11Ol31;
	reg	n11Ol32;
	reg	n1i0l15;
	reg	n1i0l16;
	reg	n1i1l17;
	reg	n1i1l18;
	reg	n1iii13;
	reg	n1iii14;
	reg	n1iiO11;
	reg	n1iiO12;
	reg	n1ill10;
	reg	n1ill9;
	reg	n1iOi7;
	reg	n1iOi8;
	reg	n1iOO5;
	reg	n1iOO6;
	reg	n1l1l3;
	reg	n1l1l4;
	reg	n1liO1;
	reg	n1liO2;
	reg	n10i;
	reg	n10l;
	reg	n10O;
	reg	n11O;
	reg	n1ii;
	reg	n1li;
	reg	n00i;
	reg	n00l;
	reg	n00O;
	reg	n01i;
	reg	n01l;
	reg	n01O;
	reg	n0ii;
	reg	n0il;
	reg	n11i;
	reg	n11l;
	reg	n1il;
	reg	n1ll;
	reg	n1lO;
	reg	n1OO;
	reg	nlOOO;
	reg	nO;
	wire	wire_nl_CLRN;
	reg	nlOOl;
	wire	wire_nlOOi_CLRN;
	wire	wire_nlOOi_ENA;
	wire	wire_n0i0l_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lO_dataout;
	wire	wire_n0Oi_dataout;
	wire	wire_n0Ol_dataout;
	wire	wire_n0OO_dataout;
	wire	wire_n1i_dataout;
	wire	wire_n1l_dataout;
	wire	wire_n1O_dataout;
	wire	wire_ni0i_dataout;
	wire	wire_ni0l_dataout;
	wire	wire_ni0O_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni1i_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1l_dataout;
	wire	wire_ni1O_dataout;
	wire	wire_ni1Oi_dataout;
	wire	wire_niii_dataout;
	wire	wire_niil_dataout;
	wire	wire_niiO_dataout;
	wire	wire_nili_dataout;
	wire	wire_nill_dataout;
	wire	wire_nilll_dataout;
	wire	wire_nilO_dataout;
	wire	wire_nilOl_dataout;
	wire	wire_nilOO_dataout;
	wire	wire_niO0i_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niOi_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOl_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOO_dataout;
	wire	wire_nl0i_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl1i_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1O_dataout;
	wire  wire_nlO0i_o;
	wire  wire_nlO0l_o;
	wire  wire_nlO0O_o;
	wire  wire_nlO1l_o;
	wire  wire_nlO1O_o;
	wire  wire_nlOii_o;
	wire  wire_nlOil_o;
	wire  wire_nlOiO_o;
	wire  wire_nlOli_o;
	wire  wire_nlOll_o;
	wire  n101i;
	wire  n101l;
	wire  n10il;
	wire  n10iO;
	wire  n10Ol;
	wire  n110i;
	wire  n110l;
	wire  n110O;
	wire  n111i;
	wire  n111l;
	wire  n111O;
	wire  n11Oi;
	wire  n1i0i;
	wire  n1l0i;
	wire  n1l0l;
	wire  n1lii;
	wire  nlOllO;
	wire  nlOlOi;
	wire  nlOlOl;
	wire  nlOlOO;
	wire  nlOO0i;
	wire  nlOO0l;
	wire  nlOO0O;
	wire  nlOO1i;
	wire  nlOO1l;
	wire  nlOO1O;
	wire  nlOOii;
	wire  nlOOil;
	wire  nlOOiO;
	wire  nlOOli;
	wire  nlOOll;
	wire  nlOOlO;
	wire  nlOOOi;
	wire  nlOOOl;
	wire  nlOOOO;

	initial
		n100l27 = 0;
	always @ ( posedge tx_clk)
		  n100l27 <= n100l28;
	event n100l27_event;
	initial
		#1 ->n100l27_event;
	always @(n100l27_event)
		n100l27 <= {1{1'b1}};
	initial
		n100l28 = 0;
	always @ ( posedge tx_clk)
		  n100l28 <= n100l27;
	initial
		n101O29 = 0;
	always @ ( posedge tx_clk)
		  n101O29 <= n101O30;
	event n101O29_event;
	initial
		#1 ->n101O29_event;
	always @(n101O29_event)
		n101O29 <= {1{1'b1}};
	initial
		n101O30 = 0;
	always @ ( posedge tx_clk)
		  n101O30 <= n101O29;
	initial
		n10ii25 = 0;
	always @ ( posedge tx_clk)
		  n10ii25 <= n10ii26;
	event n10ii25_event;
	initial
		#1 ->n10ii25_event;
	always @(n10ii25_event)
		n10ii25 <= {1{1'b1}};
	initial
		n10ii26 = 0;
	always @ ( posedge tx_clk)
		  n10ii26 <= n10ii25;
	initial
		n10li23 = 0;
	always @ ( posedge tx_clk)
		  n10li23 <= n10li24;
	event n10li23_event;
	initial
		#1 ->n10li23_event;
	always @(n10li23_event)
		n10li23 <= {1{1'b1}};
	initial
		n10li24 = 0;
	always @ ( posedge tx_clk)
		  n10li24 <= n10li23;
	initial
		n10lO21 = 0;
	always @ ( posedge tx_clk)
		  n10lO21 <= n10lO22;
	event n10lO21_event;
	initial
		#1 ->n10lO21_event;
	always @(n10lO21_event)
		n10lO21 <= {1{1'b1}};
	initial
		n10lO22 = 0;
	always @ ( posedge tx_clk)
		  n10lO22 <= n10lO21;
	initial
		n10OO19 = 0;
	always @ ( posedge tx_clk)
		  n10OO19 <= n10OO20;
	event n10OO19_event;
	initial
		#1 ->n10OO19_event;
	always @(n10OO19_event)
		n10OO19 <= {1{1'b1}};
	initial
		n10OO20 = 0;
	always @ ( posedge tx_clk)
		  n10OO20 <= n10OO19;
	initial
		n11ii43 = 0;
	always @ ( posedge tx_clk)
		  n11ii43 <= n11ii44;
	event n11ii43_event;
	initial
		#1 ->n11ii43_event;
	always @(n11ii43_event)
		n11ii43 <= {1{1'b1}};
	initial
		n11ii44 = 0;
	always @ ( posedge tx_clk)
		  n11ii44 <= n11ii43;
	initial
		n11il41 = 0;
	always @ ( posedge tx_clk)
		  n11il41 <= n11il42;
	event n11il41_event;
	initial
		#1 ->n11il41_event;
	always @(n11il41_event)
		n11il41 <= {1{1'b1}};
	initial
		n11il42 = 0;
	always @ ( posedge tx_clk)
		  n11il42 <= n11il41;
	initial
		n11iO39 = 0;
	always @ ( posedge tx_clk)
		  n11iO39 <= n11iO40;
	event n11iO39_event;
	initial
		#1 ->n11iO39_event;
	always @(n11iO39_event)
		n11iO39 <= {1{1'b1}};
	initial
		n11iO40 = 0;
	always @ ( posedge tx_clk)
		  n11iO40 <= n11iO39;
	initial
		n11li37 = 0;
	always @ ( posedge tx_clk)
		  n11li37 <= n11li38;
	event n11li37_event;
	initial
		#1 ->n11li37_event;
	always @(n11li37_event)
		n11li37 <= {1{1'b1}};
	initial
		n11li38 = 0;
	always @ ( posedge tx_clk)
		  n11li38 <= n11li37;
	initial
		n11ll35 = 0;
	always @ ( posedge tx_clk)
		  n11ll35 <= n11ll36;
	event n11ll35_event;
	initial
		#1 ->n11ll35_event;
	always @(n11ll35_event)
		n11ll35 <= {1{1'b1}};
	initial
		n11ll36 = 0;
	always @ ( posedge tx_clk)
		  n11ll36 <= n11ll35;
	initial
		n11lO33 = 0;
	always @ ( posedge tx_clk)
		  n11lO33 <= n11lO34;
	event n11lO33_event;
	initial
		#1 ->n11lO33_event;
	always @(n11lO33_event)
		n11lO33 <= {1{1'b1}};
	initial
		n11lO34 = 0;
	always @ ( posedge tx_clk)
		  n11lO34 <= n11lO33;
	initial
		n11Ol31 = 0;
	always @ ( posedge tx_clk)
		  n11Ol31 <= n11Ol32;
	event n11Ol31_event;
	initial
		#1 ->n11Ol31_event;
	always @(n11Ol31_event)
		n11Ol31 <= {1{1'b1}};
	initial
		n11Ol32 = 0;
	always @ ( posedge tx_clk)
		  n11Ol32 <= n11Ol31;
	initial
		n1i0l15 = 0;
	always @ ( posedge tx_clk)
		  n1i0l15 <= n1i0l16;
	event n1i0l15_event;
	initial
		#1 ->n1i0l15_event;
	always @(n1i0l15_event)
		n1i0l15 <= {1{1'b1}};
	initial
		n1i0l16 = 0;
	always @ ( posedge tx_clk)
		  n1i0l16 <= n1i0l15;
	initial
		n1i1l17 = 0;
	always @ ( posedge tx_clk)
		  n1i1l17 <= n1i1l18;
	event n1i1l17_event;
	initial
		#1 ->n1i1l17_event;
	always @(n1i1l17_event)
		n1i1l17 <= {1{1'b1}};
	initial
		n1i1l18 = 0;
	always @ ( posedge tx_clk)
		  n1i1l18 <= n1i1l17;
	initial
		n1iii13 = 0;
	always @ ( posedge tx_clk)
		  n1iii13 <= n1iii14;
	event n1iii13_event;
	initial
		#1 ->n1iii13_event;
	always @(n1iii13_event)
		n1iii13 <= {1{1'b1}};
	initial
		n1iii14 = 0;
	always @ ( posedge tx_clk)
		  n1iii14 <= n1iii13;
	initial
		n1iiO11 = 0;
	always @ ( posedge tx_clk)
		  n1iiO11 <= n1iiO12;
	event n1iiO11_event;
	initial
		#1 ->n1iiO11_event;
	always @(n1iiO11_event)
		n1iiO11 <= {1{1'b1}};
	initial
		n1iiO12 = 0;
	always @ ( posedge tx_clk)
		  n1iiO12 <= n1iiO11;
	initial
		n1ill10 = 0;
	always @ ( posedge tx_clk)
		  n1ill10 <= n1ill9;
	initial
		n1ill9 = 0;
	always @ ( posedge tx_clk)
		  n1ill9 <= n1ill10;
	event n1ill9_event;
	initial
		#1 ->n1ill9_event;
	always @(n1ill9_event)
		n1ill9 <= {1{1'b1}};
	initial
		n1iOi7 = 0;
	always @ ( posedge tx_clk)
		  n1iOi7 <= n1iOi8;
	event n1iOi7_event;
	initial
		#1 ->n1iOi7_event;
	always @(n1iOi7_event)
		n1iOi7 <= {1{1'b1}};
	initial
		n1iOi8 = 0;
	always @ ( posedge tx_clk)
		  n1iOi8 <= n1iOi7;
	initial
		n1iOO5 = 0;
	always @ ( posedge tx_clk)
		  n1iOO5 <= n1iOO6;
	event n1iOO5_event;
	initial
		#1 ->n1iOO5_event;
	always @(n1iOO5_event)
		n1iOO5 <= {1{1'b1}};
	initial
		n1iOO6 = 0;
	always @ ( posedge tx_clk)
		  n1iOO6 <= n1iOO5;
	initial
		n1l1l3 = 0;
	always @ ( posedge tx_clk)
		  n1l1l3 <= n1l1l4;
	event n1l1l3_event;
	initial
		#1 ->n1l1l3_event;
	always @(n1l1l3_event)
		n1l1l3 <= {1{1'b1}};
	initial
		n1l1l4 = 0;
	always @ ( posedge tx_clk)
		  n1l1l4 <= n1l1l3;
	initial
		n1liO1 = 0;
	always @ ( posedge tx_clk)
		  n1liO1 <= n1liO2;
	event n1liO1_event;
	initial
		#1 ->n1liO1_event;
	always @(n1liO1_event)
		n1liO1 <= {1{1'b1}};
	initial
		n1liO2 = 0;
	always @ ( posedge tx_clk)
		  n1liO2 <= n1liO1;
	initial
	begin
		n10i = 0;
		n10l = 0;
		n10O = 0;
		n11O = 0;
		n1ii = 0;
		n1li = 0;
	end
	always @ ( posedge tx_clk or  posedge soft_reset)
	begin
		if (soft_reset == 1'b1) 
		begin
			n10i <= 1;
			n10l <= 1;
			n10O <= 1;
			n11O <= 1;
			n1ii <= 1;
			n1li <= 1;
		end
		else 
		begin
			n10i <= wire_n0lil_dataout;
			n10l <= wire_n0liO_dataout;
			n10O <= wire_n0lli_dataout;
			n11O <= wire_n0lii_dataout;
			n1ii <= wire_niOii_dataout;
			n1li <= wire_niOiO_dataout;
		end
	end
	event n10i_event;
	event n10l_event;
	event n10O_event;
	event n11O_event;
	event n1ii_event;
	event n1li_event;
	initial
		#1 ->n10i_event;
	initial
		#1 ->n10l_event;
	initial
		#1 ->n10O_event;
	initial
		#1 ->n11O_event;
	initial
		#1 ->n1ii_event;
	initial
		#1 ->n1li_event;
	always @(n10i_event)
		n10i <= 1;
	always @(n10l_event)
		n10l <= 1;
	always @(n10O_event)
		n10O <= 1;
	always @(n11O_event)
		n11O <= 1;
	always @(n1ii_event)
		n1ii <= 1;
	always @(n1li_event)
		n1li <= 1;
	initial
	begin
		n00i = 0;
		n00l = 0;
		n00O = 0;
		n01i = 0;
		n01l = 0;
		n01O = 0;
		n0ii = 0;
		n0il = 0;
		n11i = 0;
		n11l = 0;
		n1il = 0;
		n1ll = 0;
		n1lO = 0;
		n1OO = 0;
		nlOOO = 0;
		nO = 0;
	end
	always @ ( posedge tx_clk or  negedge wire_nl_CLRN)
	begin
		if (wire_nl_CLRN == 1'b0) 
		begin
			n00i <= 0;
			n00l <= 0;
			n00O <= 0;
			n01i <= 0;
			n01l <= 0;
			n01O <= 0;
			n0ii <= 0;
			n0il <= 0;
			n11i <= 0;
			n11l <= 0;
			n1il <= 0;
			n1ll <= 0;
			n1lO <= 0;
			n1OO <= 0;
			nlOOO <= 0;
			nO <= 0;
		end
		else 
		begin
			n00i <= wire_nlOii_o;
			n00l <= wire_nlOil_o;
			n00O <= wire_nlOiO_o;
			n01i <= wire_nlO0i_o;
			n01l <= wire_nlO0l_o;
			n01O <= wire_nlO0O_o;
			n0ii <= wire_nlOli_o;
			n0il <= wire_nlOll_o;
			n11i <= wire_n0l0l_dataout;
			n11l <= wire_n0l0O_dataout;
			n1il <= wire_niOil_dataout;
			n1ll <= wire_niOli_dataout;
			n1lO <= wire_nlO1l_o;
			n1OO <= wire_nlO1O_o;
			nlOOO <= n10il;
			nO <= wire_nilll_dataout;
		end
	end
	assign
		wire_nl_CLRN = ((n1liO2 ^ n1liO1) & (~ soft_reset));
	initial
	begin
		nlOOl = 0;
	end
	always @ ( posedge tx_clk or  negedge wire_nlOOi_CLRN)
	begin
		if (wire_nlOOi_CLRN == 1'b0) 
		begin
			nlOOl <= 0;
		end
		else if  (wire_nlOOi_ENA == 1'b1) 
		begin
			nlOOl <= n1lii;
		end
	end
	assign
		wire_nlOOi_ENA = ((((IB_FORCE_DISPARITY & tx_data_9_tc) & (n100l28 ^ n100l27)) & (~ nlOOl)) & (n101O30 ^ n101O29)),
		wire_nlOOi_CLRN = ((n10ii26 ^ n10ii25) & (~ soft_reset));
	assign		wire_n0i0l_dataout = (((nlOOiO | ((wire_n1l_dataout | nlOOlO) | nlOOll)) | nlOO1l) === 1'b1) ? (~ n10iO) : n10iO;
	assign		wire_n0l0l_dataout = (nlOO1i === 1'b1) ? (~ wire_ni0l_dataout) : wire_ni0l_dataout;
	assign		wire_n0l0O_dataout = (nlOO1i === 1'b1) ? (~ wire_ni1Oi_dataout) : wire_ni1Oi_dataout;
	assign		wire_n0lii_dataout = (nlOO1i === 1'b1) ? (~ wire_ni1ii_dataout) : wire_ni1ii_dataout;
	assign		wire_n0lil_dataout = (nlOO1i === 1'b1) ? (~ wire_ni10O_dataout) : wire_ni10O_dataout;
	assign		wire_n0liO_dataout = (nlOO1i === 1'b1) ? (~ nlOOii) : nlOOii;
	assign		wire_n0lli_dataout = (nlOO1i === 1'b1) ? (~ nlOO0i) : nlOO0i;
	assign		wire_n0lO_dataout = (INDV === 1'b1) ? tx_data_tc[0] : tx_data_ts[0];
	assign		wire_n0Oi_dataout = (INDV === 1'b1) ? tx_data_tc[1] : tx_data_ts[1];
	assign		wire_n0Ol_dataout = (INDV === 1'b1) ? tx_data_tc[2] : tx_data_ts[2];
	assign		wire_n0OO_dataout = (INDV === 1'b1) ? tx_data_tc[3] : tx_data_ts[3];
	assign		wire_n1i_dataout = (INDV === 1'b1) ? tx_ctl_tc : tx_ctl_ts;
	and(wire_n1l_dataout, wire_n1O_dataout, ~(((nO & ((((((((~ n1l0l) & (~ n1l0i)) & (n1iOi8 ^ n1iOi7)) & GE_XAUI_SEL) & (n1ill10 ^ n1ill9)) & (~ tx_ctl_tc)) & (n1iiO12 ^ n1iiO11)) & nlOOO)) & (n1iii14 ^ n1iii13))));
	and(wire_n1O_dataout, wire_n1i_dataout, ~(((~ nO) & (((((((~ n1l0l) & (~ n1l0i)) & (n1l1l4 ^ n1l1l3)) & GE_XAUI_SEL) & (~ tx_ctl_tc)) & (n1iOO6 ^ n1iOO5)) & nlOOO))));
	assign		wire_ni0i_dataout = (INDV === 1'b1) ? tx_data_tc[7] : tx_data_ts[7];
	and(wire_ni0l_dataout, wire_niOi_dataout, ~(n1i0i));
	and(wire_ni0O_dataout, wire_niOl_dataout, ~(n1i0i));
	assign		wire_ni10O_dataout = (nlOOll === 1'b1) ? (~ wire_niil_dataout) : wire_niil_dataout;
	assign		wire_ni1i_dataout = (INDV === 1'b1) ? tx_data_tc[4] : tx_data_ts[4];
	assign		wire_ni1ii_dataout = (((wire_niiO_dataout & (wire_niil_dataout & ((~ wire_niii_dataout) & ((~ wire_ni0O_dataout) & (~ wire_ni0l_dataout))))) | nlOOlO) === 1'b1) ? (~ wire_niii_dataout) : wire_niii_dataout;
	assign		wire_ni1l_dataout = (INDV === 1'b1) ? tx_data_tc[5] : tx_data_ts[5];
	assign		wire_ni1O_dataout = (INDV === 1'b1) ? tx_data_tc[6] : tx_data_ts[6];
	assign		wire_ni1Oi_dataout = (nlOOOi === 1'b1) ? (~ wire_ni0O_dataout) : wire_ni0O_dataout;
	and(wire_niii_dataout, wire_niOO_dataout, ~(n1i0i));
	and(wire_niil_dataout, wire_nl1i_dataout, ~(n1i0i));
	or(wire_niiO_dataout, wire_nl1l_dataout, n1i0i);
	and(wire_nili_dataout, wire_nl1O_dataout, ~(n1i0i));
	or(wire_nill_dataout, wire_nl0i_dataout, n1i0i);
	assign		wire_nilll_dataout = ((n111i | (wire_nilO_dataout & n110O)) === 1'b1) ? (~ wire_n0i0l_dataout) : wire_n0i0l_dataout;
	and(wire_nilO_dataout, wire_nl0l_dataout, ~(n1i0i));
	or(wire_nilOl_dataout, wire_nilOO_dataout, n111O);
	and(wire_nilOO_dataout, (~ n110O), ~(wire_nilO_dataout));
	assign		wire_niO0i_dataout = (n111i === 1'b1) ? (~ wire_nill_dataout) : wire_nill_dataout;
	and(wire_niO0O_dataout, wire_nili_dataout, ~(n111O));
	or(wire_niOi_dataout, wire_n0lO_dataout, n10Ol);
	assign		wire_niOii_dataout = (n110i === 1'b1) ? (~ wire_niO0O_dataout) : wire_niO0O_dataout;
	assign		wire_niOil_dataout = (n110i === 1'b1) ? (~ wire_niO0i_dataout) : wire_niO0i_dataout;
	assign		wire_niOiO_dataout = (n110i === 1'b1) ? (~ wire_nilO_dataout) : wire_nilO_dataout;
	and(wire_niOl_dataout, wire_n0Oi_dataout, ~(n10Ol));
	assign		wire_niOli_dataout = (n110i === 1'b1) ? (~ wire_nilOl_dataout) : wire_nilOl_dataout;
	or(wire_niOO_dataout, wire_n0Ol_dataout, n10Ol);
	or(wire_nl0i_dataout, wire_ni1O_dataout, n10Ol);
	or(wire_nl0l_dataout, wire_ni0i_dataout, n10Ol);
	and(wire_nl1i_dataout, wire_n0OO_dataout, ~(n10Ol));
	and(wire_nl1l_dataout, wire_ni1i_dataout, ~(n10Ol));
	and(wire_nl1O_dataout, wire_ni1l_dataout, ~(n10Ol));
	oper_selector   nlO0i
	( 
	.data({n11O, tx_data_tc[2], tx_data_pg[2]}),
	.o(wire_nlO0i_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO0i.width_data = 3,
		nlO0i.width_sel = 3;
	oper_selector   nlO0l
	( 
	.data({n10i, tx_data_tc[3], tx_data_pg[3]}),
	.o(wire_nlO0l_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO0l.width_data = 3,
		nlO0l.width_sel = 3;
	oper_selector   nlO0O
	( 
	.data({n10l, ((n11ii44 ^ n11ii43) & tx_data_tc[4]), tx_data_pg[4]}),
	.o(wire_nlO0O_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO0O.width_data = 3,
		nlO0O.width_sel = 3;
	oper_selector   nlO1l
	( 
	.data({n11i, tx_data_tc[0], tx_data_pg[0]}),
	.o(wire_nlO1l_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO1l.width_data = 3,
		nlO1l.width_sel = 3;
	oper_selector   nlO1O
	( 
	.data({n11l, tx_data_tc[1], tx_data_pg[1]}),
	.o(wire_nlO1O_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlO1O.width_data = 3,
		nlO1O.width_sel = 3;
	oper_selector   nlOii
	( 
	.data({n10O, tx_data_tc[5], tx_data_pg[5]}),
	.o(wire_nlOii_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlOii.width_data = 3,
		nlOii.width_sel = 3;
	oper_selector   nlOil
	( 
	.data({n1ii, tx_data_tc[6], tx_data_pg[6]}),
	.o(wire_nlOil_o),
	.sel({((n11il42 ^ n11il41) & n101l), n101i, (~ n11Oi)}));
	defparam
		nlOil.width_data = 3,
		nlOil.width_sel = 3;
	oper_selector   nlOiO
	( 
	.data({((n11iO40 ^ n11iO39) & n1il), tx_data_tc[7], tx_data_pg[7]}),
	.o(wire_nlOiO_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlOiO.width_data = 3,
		nlOiO.width_sel = 3;
	oper_selector   nlOli
	( 
	.data({n1li, ((n11li38 ^ n11li37) & tx_ctl_tc), ((n11ll36 ^ n11ll35) & tx_data_pg[8])}),
	.o(wire_nlOli_o),
	.sel({n101l, n101i, (~ n11Oi)}));
	defparam
		nlOli.width_data = 3,
		nlOli.width_sel = 3;
	oper_selector   nlOll
	( 
	.data({n1ll, tx_data_9_tc, tx_data_pg[9]}),
	.o(wire_nlOll_o),
	.sel({n101l, ((n11lO34 ^ n11lO33) & n101i), (~ n11Oi)}));
	defparam
		nlOll.width_data = 3,
		nlOll.width_sel = 3;
	assign
		n101i = ((~ ENDEC) & (~ prbs_en)),
		n101l = (ENDEC & (~ prbs_en)),
		n10il = ((((((((tx_ctl_tc & (~ tx_data_tc[0])) & (~ tx_data_tc[1])) & tx_data_tc[2]) & tx_data_tc[3]) & tx_data_tc[4]) & tx_data_tc[5]) & (~ tx_data_tc[6])) & tx_data_tc[7]),
		n10iO = ((nO | (((IB_FORCE_DISPARITY & tx_data_9_tc) & (~ nlOOl)) & (n10lO22 ^ n10lO21))) | (~ (n10li24 ^ n10li23))),
		n10Ol = ((~ nO) & (((((((~ n1l0l) & (~ n1l0i)) & GE_XAUI_SEL) & (n1i1l18 ^ n1i1l17)) & (~ tx_ctl_tc)) & (n10OO20 ^ n10OO19)) & nlOOO)),
		n110i = ((((~ wire_n0i0l_dataout) & (wire_n1l_dataout & (~ n110O))) | n110l) ^ ((~ wire_n0i0l_dataout) & n110O)),
		n110l = (wire_nill_dataout & wire_nili_dataout),
		n110O = (n110l | n111l),
		n111i = ((~ wire_nilO_dataout) & n111l),
		n111l = ((~ wire_nill_dataout) & (~ wire_nili_dataout)),
		n111O = (wire_nilO_dataout & (wire_nill_dataout & (wire_nili_dataout & ((((~ wire_n0i0l_dataout) & ((wire_niiO_dataout & (~ wire_niil_dataout)) & (((((~ wire_niil_dataout) & ((~ wire_niii_dataout) & ((~ wire_ni0O_dataout) & wire_ni0l_dataout))) | ((~ wire_niil_dataout) & ((~ wire_niii_dataout) & (wire_ni0O_dataout & (~ wire_ni0l_dataout))))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOOOO))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOOOO))))) | (wire_n0i0l_dataout & (((~ wire_niiO_dataout) & wire_niil_dataout) & (((((~ wire_niil_dataout) & (wire_niii_dataout & nlOOOl)) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOOOl))) | (wire_niil_dataout & (wire_niii_dataout & ((~ wire_ni0O_dataout) & wire_ni0l_dataout)))) | (wire_niil_dataout & (wire_niii_dataout & (wire_ni0O_dataout & (~ wire_ni0l_dataout)))))))) | (wire_nilO_dataout & (wire_nill_dataout & (wire_n1l_dataout & wire_nili_dataout))))))),
		n11Oi = ((n101l | n101i) | (~ (n11Ol32 ^ n11Ol31))),
		n1i0i = (nO & ((((((~ n1l0l) & (~ n1l0i)) & GE_XAUI_SEL) & (~ tx_ctl_tc)) & nlOOO) & (n1i0l16 ^ n1i0l15))),
		n1l0i = (((((((((~ tx_ctl_tc) & (~ tx_data_tc[0])) & tx_data_tc[1]) & (~ tx_data_tc[2])) & (~ tx_data_tc[3])) & (~ tx_data_tc[4])) & (~ tx_data_tc[5])) & tx_data_tc[6]) & (~ tx_data_tc[7])),
		n1l0l = (((((((((~ tx_ctl_tc) & tx_data_tc[0]) & (~ tx_data_tc[1])) & tx_data_tc[2]) & (~ tx_data_tc[3])) & tx_data_tc[4]) & tx_data_tc[5]) & (~ tx_data_tc[6])) & tx_data_tc[7]),
		n1lii = 1'b1,
		nlOllO = (wire_ni0O_dataout & wire_ni0l_dataout),
		nlOlOi = ((~ wire_ni0O_dataout) & (~ wire_ni0l_dataout)),
		nlOlOl = (wire_ni0O_dataout & (~ wire_ni0l_dataout)),
		nlOlOO = ((~ wire_ni0O_dataout) & wire_ni0l_dataout),
		nlOO0i = (((wire_n1l_dataout | (~ wire_niiO_dataout)) & nlOO0O) | (wire_niiO_dataout & (((~ nlOO0l) & (~ nlOO0O)) & nlOOil))),
		nlOO0l = (((((~ wire_niil_dataout) & (wire_niii_dataout & nlOllO)) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOllO))) | (wire_niil_dataout & (wire_niii_dataout & ((~ wire_ni0O_dataout) & wire_ni0l_dataout)))) | (wire_niil_dataout & (wire_niii_dataout & (wire_ni0O_dataout & (~ wire_ni0l_dataout))))),
		nlOO0O = (((((((~ wire_niil_dataout) & ((~ wire_niii_dataout) & (wire_ni0O_dataout & wire_ni0l_dataout))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOlOO))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOlOl))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOlOO))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOlOl))) | (wire_niil_dataout & (wire_niii_dataout & ((~ wire_ni0O_dataout) & (~ wire_ni0l_dataout))))),
		nlOO1i = (((((((~ wire_niil_dataout) & (wire_niii_dataout & (wire_ni0O_dataout & wire_ni0l_dataout))) | (wire_niiO_dataout & nlOOlO)) | (wire_niiO_dataout & nlOOll)) | (wire_niiO_dataout & nlOO0l)) | nlOO1O) ^ ((~ n10iO) & (nlOO1O | ((nlOOOi | ((~ wire_niiO_dataout) & (((~ wire_niil_dataout) & nlOO0l) | nlOOli))) | nlOO1l)))),
		nlOO1l = (wire_niiO_dataout & ((wire_niil_dataout & nlOOli) | nlOO0l)),
		nlOO1O = (wire_n1l_dataout & nlOO0O),
		nlOOii = (nlOOiO | (wire_niiO_dataout & nlOOil)),
		nlOOil = ((~ wire_niil_dataout) | (wire_niii_dataout | (wire_ni0O_dataout | wire_ni0l_dataout))),
		nlOOiO = ((~ wire_niiO_dataout) & nlOOli),
		nlOOli = (((((~ wire_niil_dataout) & ((~ wire_niii_dataout) & ((~ wire_ni0O_dataout) & wire_ni0l_dataout))) | ((~ wire_niil_dataout) & ((~ wire_niii_dataout) & (wire_ni0O_dataout & (~ wire_ni0l_dataout))))) | ((~ wire_niil_dataout) & (wire_niii_dataout & nlOlOi))) | (wire_niil_dataout & ((~ wire_niii_dataout) & nlOlOi))),
		nlOOll = (wire_niil_dataout & (wire_niii_dataout & (wire_ni0O_dataout & wire_ni0l_dataout))),
		nlOOlO = ((~ wire_niil_dataout) & ((~ wire_niii_dataout) & ((~ wire_ni0O_dataout) & (~ wire_ni0l_dataout)))),
		nlOOOi = (nlOOll | nlOOlO),
		nlOOOl = (wire_ni0O_dataout & wire_ni0l_dataout),
		nlOOOO = ((~ wire_ni0O_dataout) & (~ wire_ni0l_dataout)),
		PUDR = {wire_nlOll_o, wire_nlOli_o, wire_nlOiO_o, wire_nlOil_o, wire_nlOii_o, wire_nlO0O_o, wire_nlO0l_o, wire_nlO0i_o, wire_nlO1O_o, wire_nlO1l_o},
		TXLP10B = {n0il, n0ii, n00O, n00l, n00i, n01O, n01l, n01i, n1OO, n1lO};
endmodule //stratixgx_hssi_tx_enc_rtl
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                           STRATIXGX_8b10b_ENCODER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

  module stratixgx_8b10b_encoder 
    (
     clk, 
     reset,
     xgmctrl,
     kin,
     xgmdatain,
     datain,
     forcedisparity,
     dataout,
     parafbkdataout
     );
   
   parameter    transmit_protocol = "none";
   parameter    use_8b_10b_mode = "true";
   parameter    force_disparity_mode = "false";
   
   input    clk; 
   input    reset;   // asynchronously resets the core
   input    kin;     // command byte indicator 
   input [7:0]  datain;   // data or command word
   input [7:0]  xgmdatain;// XGM State Machine Data Input
   input    xgmctrl;  // XGM Control Enable
   input    forcedisparity;
   
   output [9:0] dataout; // 10-bit encoded output
   output [9:0] parafbkdataout; // Parallel Feedback To Top Level
   
   // CORE MODULE INPUTs
   wire     tx_clk; 
   wire     soft_reset;
   wire     INDV;
   wire     ENDEC;
   wire     GE_XAUI_SEL;
   wire     IB_FORCE_DISPARITY;
   wire     prbs_en;
   wire     tx_ctl_ts;
   wire     tx_ctl_tc;
   wire [7:0]   tx_data_ts;
   wire [7:0]   tx_data_tc;
   wire     tx_data_9_tc;
   wire [9:0]   tx_data_pg;

   // CORE MODULE OUTPUTs
   wire [9:0]   TXLP10B;
   wire [9:0]   PUDR;

   // ASSIGN INPUTS
   assign  tx_clk = clk;
   assign  soft_reset = reset;
   assign INDV = (transmit_protocol != "xaui") ? 1'b1 : 1'b0;
   assign ENDEC = (use_8b_10b_mode == "true") ? 1'b1 : 1'b0;
   assign GE_XAUI_SEL = (transmit_protocol == "gige") ? 1'b1 : 1'b0;
   assign IB_FORCE_DISPARITY = (force_disparity_mode == "true") ? 1'b1 : 1'b0;
   assign prbs_en = 1'b0;
   assign tx_ctl_ts = xgmctrl;
   assign tx_ctl_tc = kin;
   assign tx_data_ts = xgmdatain;
   assign tx_data_tc = datain;
   assign tx_data_9_tc = forcedisparity;
   assign tx_data_pg = 'b0;
   
   // ASSIGN OUTPUTS
   assign dataout = PUDR;
   assign parafbkdataout = TXLP10B;

   // Instantiate core module
   stratixgx_hssi_tx_enc_rtl m_enc_core (
                .tx_clk(tx_clk), 
                .soft_reset(soft_reset),
                .INDV(INDV), 
                .ENDEC(ENDEC), 
                .GE_XAUI_SEL(GE_XAUI_SEL),
                .IB_FORCE_DISPARITY(IB_FORCE_DISPARITY),
                .prbs_en(prbs_en),
                .tx_ctl_ts(tx_ctl_ts),
                .tx_ctl_tc(tx_ctl_tc),
                .tx_data_ts(tx_data_ts),
                .tx_data_tc(tx_data_tc),
                .tx_data_9_tc(tx_data_9_tc),
                .tx_data_pg(tx_data_pg), 
                .PUDR(PUDR),
                .TXLP10B(TXLP10B)
    );
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                           STRATIXGX_HSSI_TRANSMITTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_hssi_transmitter
   (
    pllclk,
    fastpllclk,
    coreclk,
    softreset,
    serialdatain,
    xgmctrl,
    srlpbk,
    analogreset,
    datain,
    ctrlenable,
    forcedisparity,
    xgmdatain,
    vodctrl,
    preemphasisctrl,
    devclrn,
    devpor,
    dataout,
    xgmctrlenable,
    rdenablesync,
    xgmdataout,
    parallelfdbkdata,
    pre8b10bdata
    );

parameter channel_num = 1; 
parameter channel_width = 8; // (The width of the datain port)>;    
parameter serialization_factor = 8; 
parameter use_double_data_mode = "false";
parameter use_8b_10b_mode = "false";
parameter use_fifo_mode = "false";
parameter use_reverse_parallel_feedback = "false";
parameter force_disparity_mode = "false";
parameter transmit_protocol = "none"; // <gige, xaui, none>;
parameter use_vod_ctrl_signal = "false";
parameter use_preemphasis_ctrl_signal = "false";
parameter use_self_test_mode = "false";
parameter self_test_mode = 0;
parameter vod_ctrl_setting = 4;  
parameter preemphasis_ctrl_setting = 5;
parameter termination = 0; // new in 3.0


input [19 : 0] datain; // (<input bus>),
input pllclk; // (<pll clock source (ref_clk)>), 
input fastpllclk; // (<pll clock source powering SERDES>),
input coreclk; // (<core clock source>), 
input softreset; // (<unknown reset source>),
input [1 : 0] ctrlenable; // (<data sent is control code>),
input [1 : 0] forcedisparity; // (<force disparity for 8B / 10B>),
input serialdatain; // (<data to be sent directly to data output>),
input [7 : 0] xgmdatain; // (<data input from the XGM SM system>),
input xgmctrl; // (<control input from the XGM SM system>),
input srlpbk; 
input devpor;
input devclrn;
input analogreset;
input [2 : 0] vodctrl;
input [2 : 0] preemphasisctrl;
   
output dataout; // (<data output of HSSI channel>),
output [7 : 0] xgmdataout; // (<data output before 8B/10B to XGM SM>),
output xgmctrlenable; // (<ctrlenable output before 8B/10B to XGM SM>),
output rdenablesync; 
output [9 : 0] parallelfdbkdata; // (<parallel data output>),
output [9 : 0] pre8b10bdata; // (<pararrel non-encoded data output>)
   
// wire declarations
wire datain_in0,datain_in1,datain_in2,datain_in3,datain_in4;
wire datain_in5,datain_in6,datain_in7,datain_in8,datain_in9;
wire datain_in10,datain_in11,datain_in12,datain_in13,datain_in14;
wire datain_in15,datain_in16,datain_in17,datain_in18,datain_in19;
wire pllclk_in,fastpllclk_in,coreclk_in,softreset_in,analogreset_in;
wire vodctrl_in0,vodctrl_in1,vodctrl_in2;
wire preemphasisctrl_in0,preemphasisctrl_in1,preemphasisctrl_in2;
wire ctrlenable_in0,ctrlenable_in1;
wire forcedisparity_in0,forcedisparity_in1;
wire serialdatain_in;
wire xgmdatain_in0,xgmdatain_in1,xgmdatain_in2,xgmdatain_in3,xgmdatain_in4,xgmdatain_in5,xgmdatain_in6,xgmdatain_in7;
wire xgmctrl_in, srlpbk_in;

buf (datain_in0, datain[0]);
buf (datain_in1, datain[1]);
buf (datain_in2, datain[2]);
buf (datain_in3, datain[3]);
buf (datain_in4, datain[4]);
buf (datain_in5, datain[5]);
buf (datain_in6, datain[6]);
buf (datain_in7, datain[7]);
buf (datain_in8, datain[8]);
buf (datain_in9, datain[9]);
buf (datain_in10, datain[10]);
buf (datain_in11, datain[11]);
buf (datain_in12, datain[12]);
buf (datain_in13, datain[13]);
buf (datain_in14, datain[14]);
buf (datain_in15, datain[15]);
buf (datain_in16, datain[16]);
buf (datain_in17, datain[17]);
buf (datain_in18, datain[18]);
buf (datain_in19, datain[19]);

buf (pllclk_in, pllclk);
buf (fastpllclk_in, fastpllclk);
buf (coreclk_in, coreclk);
buf (softreset_in, softreset);
buf (analogreset_in, analogreset);
buf (vodctrl_in0, vodctrl[0]);
buf (vodctrl_in1, vodctrl[1]);
buf (vodctrl_in2, vodctrl[2]);
buf (preemphasisctrl_in0, preemphasisctrl[0]);
buf (preemphasisctrl_in1, preemphasisctrl[1]);
buf (preemphasisctrl_in2, preemphasisctrl[2]);
buf (ctrlenable_in0, ctrlenable[0]);
buf (ctrlenable_in1, ctrlenable[1]);
buf (forcedisparity_in0, forcedisparity[0]);
buf (forcedisparity_in1, forcedisparity[1]);
buf (serialdatain_in, serialdatain);

buf (xgmdatain_in0, xgmdatain[0]);
buf (xgmdatain_in1, xgmdatain[1]);
buf (xgmdatain_in2, xgmdatain[2]);
buf (xgmdatain_in3, xgmdatain[3]);
buf (xgmdatain_in4, xgmdatain[4]);
buf (xgmdatain_in5, xgmdatain[5]);
buf (xgmdatain_in6, xgmdatain[6]);
buf (xgmdatain_in7, xgmdatain[7]);

buf (xgmctrl_in, xgmctrl);
buf (srlpbk_in, srlpbk);
   
//constant signals
wire vcc, gnd;
wire [9 : 0] idle_bus;

//lower lever softreset
wire reset_int;

// internal bus for XGM data
wire [7 : 0] xgmdatain_in;
wire [19 : 0] datain_in;

assign xgmdatain_in = {
                                xgmdatain_in7, xgmdatain_in6,
                                xgmdatain_in5, xgmdatain_in4,
                                xgmdatain_in3, xgmdatain_in2,
                                xgmdatain_in1, xgmdatain_in0
                             };
assign datain_in = {
                                datain_in19, datain_in18,
                                datain_in17, datain_in16,
                                datain_in15, datain_in14,
                                datain_in13, datain_in12,
                                datain_in11, datain_in10,
                                datain_in9, datain_in8,
                                datain_in7, datain_in6,
                                datain_in5, datain_in4,
                                datain_in3, datain_in2,
                                datain_in1, datain_in0
                             };

assign reset_int = softreset_in;
assign vcc = 1'b1;
assign gnd = 1'b0;
assign idle_bus = 10'b0000000000;

// tx_core input/output signals
wire [19:0] core_datain;
wire core_writeclk;
wire core_readclk;
wire [1:0] core_ctrlena;
wire [1:0] core_forcedisp;
   
wire [9:0] core_dataout;
wire core_forcedispout;
wire core_ctrlenaout;
wire core_rdenasync;
wire core_xgmctrlena;
wire [7:0] core_xgmdataout;
wire [9:0] core_pre8b10bdataout;

// serdes input/output signals
wire [9:0] serdes_datain;
wire serdes_clk;
wire serdes_clk1;
wire serdes_serialdatain;
wire serdes_srlpbk;

wire serdes_dataout;

// encoder input/output signals
wire encoder_clk; 
wire encoder_kin; 
wire [7:0] encoder_datain;
wire [7:0] encoder_xgmdatain;
wire encoder_xgmctrl; 
      
wire [9:0] encoder_dataout;
wire [9:0] encoder_para;

// internal signal for parallelfdbkdata
wire [9 : 0] parallelfdbkdata_tmp; 

// TX CLOCK MUX
wire      txclk;
wire      pllclk_int;
      
specify

    $setuphold(posedge coreclk, datain[0], 0, 0);
    $setuphold(posedge coreclk, datain[1], 0, 0);
    $setuphold(posedge coreclk, datain[2], 0, 0);
    $setuphold(posedge coreclk, datain[3], 0, 0);
    $setuphold(posedge coreclk, datain[4], 0, 0);
    $setuphold(posedge coreclk, datain[5], 0, 0);
    $setuphold(posedge coreclk, datain[6], 0, 0);
    $setuphold(posedge coreclk, datain[7], 0, 0);
    $setuphold(posedge coreclk, datain[8], 0, 0);
    $setuphold(posedge coreclk, datain[9], 0, 0);
    $setuphold(posedge coreclk, datain[10], 0, 0);
    $setuphold(posedge coreclk, datain[11], 0, 0);
    $setuphold(posedge coreclk, datain[12], 0, 0);
    $setuphold(posedge coreclk, datain[13], 0, 0);
    $setuphold(posedge coreclk, datain[14], 0, 0);
    $setuphold(posedge coreclk, datain[15], 0, 0);
    $setuphold(posedge coreclk, datain[16], 0, 0);
    $setuphold(posedge coreclk, datain[17], 0, 0);
    $setuphold(posedge coreclk, datain[18], 0, 0);
    $setuphold(posedge coreclk, datain[19], 0, 0);

    $setuphold(posedge coreclk, ctrlenable[0], 0, 0);
    $setuphold(posedge coreclk, ctrlenable[1], 0, 0);

    $setuphold(posedge coreclk, forcedisparity[0], 0, 0);
    $setuphold(posedge coreclk, forcedisparity[1], 0, 0);
endspecify
   
// generate internal inut signals

// TX CLOCK MUX
stratixgx_hssi_divide_by_two txclk_block   
   (
    .reset(1'b0),
    .clkin(pllclk_in), 
    .clkout(pllclk_int)
    );
   defparam  txclk_block.divide = use_double_data_mode;

assign txclk = (use_reverse_parallel_feedback == "true") ?  pllclk_int : coreclk_in;
   
// tx_core inputs
assign core_datain = datain_in;
assign core_writeclk = txclk;
assign core_readclk = pllclk_in;
assign core_ctrlena = {ctrlenable_in1, ctrlenable_in0};
assign core_forcedisp = {forcedisparity_in1, forcedisparity_in0};
     
// encoder inputs
assign encoder_clk = pllclk_in; 
assign encoder_kin = core_ctrlenaout;
assign encoder_datain = core_dataout[7:0];
assign encoder_xgmdatain = xgmdatain_in;
assign encoder_xgmctrl = xgmctrl_in; 

// serdes inputs
assign serdes_datain = (use_8b_10b_mode == "true") ? encoder_dataout : core_dataout;
assign serdes_clk = fastpllclk_in;
assign serdes_clk1 = pllclk_in;
assign serdes_serialdatain = serialdatain_in;
assign serdes_srlpbk = srlpbk_in;

// parallelfdbkdata generation
assign parallelfdbkdata_tmp = (use_8b_10b_mode == "true") ? encoder_dataout : core_dataout; 

// sub modules

stratixgx_tx_core s_tx_core    
   (
    .reset(reset_int),
    .datain(core_datain),
    .writeclk(core_writeclk),
    .readclk(core_readclk),
    .ctrlena(core_ctrlena),
    .forcedisp(core_forcedisp),
    .dataout(core_dataout),
    .forcedispout(core_forcedispout),
    .ctrlenaout(core_ctrlenaout),
    .rdenasync(core_rdenasync),
    .xgmctrlena(core_xgmctrlena),
    .xgmdataout(core_xgmdataout),
    .pre8b10bdataout(core_pre8b10bdataout)
    );
   defparam  s_tx_core.use_double_data_mode = use_double_data_mode;
   defparam  s_tx_core.use_fifo_mode = use_fifo_mode;
   defparam  s_tx_core.channel_width = channel_width;
   defparam  s_tx_core.transmit_protocol = transmit_protocol;   
   
stratixgx_8b10b_encoder s_encoder  
   (
    .clk(encoder_clk), 
    .reset(reset_int), 
    .kin(encoder_kin),
    .datain(encoder_datain),
    .xgmdatain(encoder_xgmdatain),
    .xgmctrl(encoder_xgmctrl),
    .forcedisparity(core_forcedispout),
    .dataout(encoder_dataout),
    .parafbkdataout(encoder_para)
    );
   defparam  s_encoder.transmit_protocol = transmit_protocol;
   defparam  s_encoder.use_8b_10b_mode = use_8b_10b_mode;
   defparam  s_encoder.force_disparity_mode = force_disparity_mode;

stratixgx_hssi_tx_serdes s_tx_serdes   
  (
   .clk(serdes_clk), 
   .clk1(serdes_clk1), 
   .datain(serdes_datain),
   .serialdatain(serdes_serialdatain),
   .srlpbk(serdes_srlpbk),
   .areset(analogreset_in),
   .dataout(serdes_dataout)
   );
   defparam  s_tx_serdes.channel_width = serialization_factor;

// gererate output signals
and (dataout, 1'b1, serdes_dataout); 
and (xgmctrlenable, 1'b1, core_xgmctrlena);
and (rdenablesync, 1'b1, core_rdenasync); 

buf (xgmdataout[0], core_xgmdataout[0]);
buf (xgmdataout[1], core_xgmdataout[1]);
buf (xgmdataout[2], core_xgmdataout[2]);
buf (xgmdataout[3], core_xgmdataout[3]);
buf (xgmdataout[4], core_xgmdataout[4]);
buf (xgmdataout[5], core_xgmdataout[5]);
buf (xgmdataout[6], core_xgmdataout[6]);
buf (xgmdataout[7], core_xgmdataout[7]);

buf (pre8b10bdata[0], core_pre8b10bdataout[0]);
buf (pre8b10bdata[1], core_pre8b10bdataout[1]);
buf (pre8b10bdata[2], core_pre8b10bdataout[2]);
buf (pre8b10bdata[3], core_pre8b10bdataout[3]);
buf (pre8b10bdata[4], core_pre8b10bdataout[4]);
buf (pre8b10bdata[5], core_pre8b10bdataout[5]);
buf (pre8b10bdata[6], core_pre8b10bdataout[6]);
buf (pre8b10bdata[7], core_pre8b10bdataout[7]);
buf (pre8b10bdata[8], core_pre8b10bdataout[8]);
buf (pre8b10bdata[9], core_pre8b10bdataout[9]);

buf (parallelfdbkdata[0], parallelfdbkdata_tmp[0]); 
buf (parallelfdbkdata[1], parallelfdbkdata_tmp[1]); 
buf (parallelfdbkdata[2], parallelfdbkdata_tmp[2]); 
buf (parallelfdbkdata[3], parallelfdbkdata_tmp[3]); 
buf (parallelfdbkdata[4], parallelfdbkdata_tmp[4]); 
buf (parallelfdbkdata[5], parallelfdbkdata_tmp[5]); 
buf (parallelfdbkdata[6], parallelfdbkdata_tmp[6]); 
buf (parallelfdbkdata[7], parallelfdbkdata_tmp[7]); 
buf (parallelfdbkdata[8], parallelfdbkdata_tmp[8]); 
buf (parallelfdbkdata[9], parallelfdbkdata_tmp[9]); 

endmodule // stratixgx_hssi_transmitter

//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 81 mux21 43 
`timescale 1 ps / 1 ps
module  stratixgx_8b10b_decoder
	( 
	clk,
	datain,
	datainvalid,
	dataout,
	decdatavalid,
	disperr,
	disperrin,
	errdetect,
	errdetectin,
	kout,
	patterndetect,
	patterndetectin,
	rderr,
	reset,
	syncstatus,
	syncstatusin,
	tenBdata,
	valid,
	xgmctrldet,
	xgmdataout,
	xgmdatavalid,
	xgmrunningdisp) /* synthesis synthesis_clearbox=1 */;
	input   clk;
	input   [9:0]  datain;
	input   datainvalid;
	output   [7:0]  dataout;
	output   decdatavalid;
	output   disperr;
	input   disperrin;
	output   errdetect;
	input   errdetectin;
	output   kout;
	output   patterndetect;
	input   patterndetectin;
	output   rderr;
	input   reset;
	output   syncstatus;
	input   syncstatusin;
	output   [9:0]  tenBdata;
	output   valid;
	output   xgmctrldet;
	output   [7:0]  xgmdataout;
	output   xgmdatavalid;
	output   xgmrunningdisp;

	reg	n0iOl43;
	reg	n0iOl44;
	reg	n0l0l39;
	reg	n0l0l40;
	reg	n0l1l41;
	reg	n0l1l42;
	reg	n0lii37;
	reg	n0lii38;
	reg	n0liO35;
	reg	n0liO36;
	reg	n0lll33;
	reg	n0lll34;
	reg	n0lOi31;
	reg	n0lOi32;
	reg	n0lOO29;
	reg	n0lOO30;
	reg	n0O0l25;
	reg	n0O0l26;
	reg	n0O1l27;
	reg	n0O1l28;
	reg	n0Oil23;
	reg	n0Oil24;
	reg	n0Oli21;
	reg	n0Oli22;
	reg	n0OOi19;
	reg	n0OOi20;
	reg	n0OOO17;
	reg	n0OOO18;
	reg	ni00i5;
	reg	ni00i6;
	reg	ni0il3;
	reg	ni0il4;
	reg	ni0ll1;
	reg	ni0ll2;
	reg	ni10l13;
	reg	ni10l14;
	reg	ni11O15;
	reg	ni11O16;
	reg	ni1ii11;
	reg	ni1ii12;
	reg	ni1iO10;
	reg	ni1iO9;
	reg	ni1ll7;
	reg	ni1ll8;
	reg	n0O;
	reg	nii;
	reg	niO;
	reg	nlll;
	reg	nllO;
	reg	nlOi;
	reg	nlOl;
	reg	nlOO;
	reg	nil_clk_prev;
	wire	wire_nil_CLRN;
	reg	n0i;
	reg	n0l;
	reg	n1i;
	reg	n1l;
	reg	n1O;
	reg	ni;
	reg	niii;
	reg	niil;
	reg	niiO;
	reg	nili;
	reg	nill;
	reg	nilO;
	reg	niOi;
	reg	niOl;
	reg	niOO;
	reg	nl0i;
	reg	nl0l;
	reg	nl0O;
	reg	nl1i;
	reg	nl1l;
	reg	nl1O;
	reg	nli;
	reg	nlii;
	reg	nlil;
	reg	nliO;
	reg	nll;
	reg	nlli;
	reg	nlO;
	reg	nO;
	wire	wire_nl_CLRN;
	wire	wire_niO0i_dataout;
	wire	wire_niO0l_dataout;
	wire	wire_niO0O_dataout;
	wire	wire_niO1l_dataout;
	wire	wire_niO1O_dataout;
	wire	wire_niOii_dataout;
	wire	wire_niOil_dataout;
	wire	wire_niOiO_dataout;
	wire	wire_niOli_dataout;
	wire	wire_niOll_dataout;
	wire	wire_niOlO_dataout;
	wire	wire_niOOi_dataout;
	wire	wire_niOOl_dataout;
	wire	wire_niOOO_dataout;
	wire	wire_nl10i_dataout;
	wire	wire_nl10l_dataout;
	wire	wire_nl10O_dataout;
	wire	wire_nl11i_dataout;
	wire	wire_nl11l_dataout;
	wire	wire_nl11O_dataout;
	wire	wire_nl1il_dataout;
	wire	wire_nl1iO_dataout;
	wire	wire_nl1li_dataout;
	wire	wire_nli0i_dataout;
	wire	wire_nli0l_dataout;
	wire	wire_nli0O_dataout;
	wire	wire_nli1l_dataout;
	wire	wire_nli1O_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll0l_dataout;
	wire	wire_nll0O_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nllii_dataout;
	wire	wire_nllli_dataout;
	wire	wire_nllll_dataout;
	wire	wire_nlllO_dataout;
	wire  n0ill;
	wire  n0ilO;
	wire  n0iOi;
	wire  n0l0i;
	wire  n0l1i;
	wire  n0O0i;
	wire  n0Oii;
	wire  n0OlO;
	wire  ni01i;
	wire  ni01l;
	wire  ni01O;
	wire  ni0ii;
	wire  ni0iO;
	wire  ni11l;
	wire  ni1Oi;
	wire  ni1Ol;
	wire  ni1OO;

	initial
		n0iOl43 = 0;
	always @ ( posedge clk)
		  n0iOl43 <= n0iOl44;
	event n0iOl43_event;
	initial
		#1 ->n0iOl43_event;
	always @(n0iOl43_event)
		n0iOl43 <= {1{1'b1}};
	initial
		n0iOl44 = 0;
	always @ ( posedge clk)
		  n0iOl44 <= n0iOl43;
	initial
		n0l0l39 = 0;
	always @ ( posedge clk)
		  n0l0l39 <= n0l0l40;
	event n0l0l39_event;
	initial
		#1 ->n0l0l39_event;
	always @(n0l0l39_event)
		n0l0l39 <= {1{1'b1}};
	initial
		n0l0l40 = 0;
	always @ ( posedge clk)
		  n0l0l40 <= n0l0l39;
	initial
		n0l1l41 = 0;
	always @ ( posedge clk)
		  n0l1l41 <= n0l1l42;
	event n0l1l41_event;
	initial
		#1 ->n0l1l41_event;
	always @(n0l1l41_event)
		n0l1l41 <= {1{1'b1}};
	initial
		n0l1l42 = 0;
	always @ ( posedge clk)
		  n0l1l42 <= n0l1l41;
	initial
		n0lii37 = 0;
	always @ ( posedge clk)
		  n0lii37 <= n0lii38;
	event n0lii37_event;
	initial
		#1 ->n0lii37_event;
	always @(n0lii37_event)
		n0lii37 <= {1{1'b1}};
	initial
		n0lii38 = 0;
	always @ ( posedge clk)
		  n0lii38 <= n0lii37;
	initial
		n0liO35 = 0;
	always @ ( posedge clk)
		  n0liO35 <= n0liO36;
	event n0liO35_event;
	initial
		#1 ->n0liO35_event;
	always @(n0liO35_event)
		n0liO35 <= {1{1'b1}};
	initial
		n0liO36 = 0;
	always @ ( posedge clk)
		  n0liO36 <= n0liO35;
	initial
		n0lll33 = 0;
	always @ ( posedge clk)
		  n0lll33 <= n0lll34;
	event n0lll33_event;
	initial
		#1 ->n0lll33_event;
	always @(n0lll33_event)
		n0lll33 <= {1{1'b1}};
	initial
		n0lll34 = 0;
	always @ ( posedge clk)
		  n0lll34 <= n0lll33;
	initial
		n0lOi31 = 0;
	always @ ( posedge clk)
		  n0lOi31 <= n0lOi32;
	event n0lOi31_event;
	initial
		#1 ->n0lOi31_event;
	always @(n0lOi31_event)
		n0lOi31 <= {1{1'b1}};
	initial
		n0lOi32 = 0;
	always @ ( posedge clk)
		  n0lOi32 <= n0lOi31;
	initial
		n0lOO29 = 0;
	always @ ( posedge clk)
		  n0lOO29 <= n0lOO30;
	event n0lOO29_event;
	initial
		#1 ->n0lOO29_event;
	always @(n0lOO29_event)
		n0lOO29 <= {1{1'b1}};
	initial
		n0lOO30 = 0;
	always @ ( posedge clk)
		  n0lOO30 <= n0lOO29;
	initial
		n0O0l25 = 0;
	always @ ( posedge clk)
		  n0O0l25 <= n0O0l26;
	event n0O0l25_event;
	initial
		#1 ->n0O0l25_event;
	always @(n0O0l25_event)
		n0O0l25 <= {1{1'b1}};
	initial
		n0O0l26 = 0;
	always @ ( posedge clk)
		  n0O0l26 <= n0O0l25;
	initial
		n0O1l27 = 0;
	always @ ( posedge clk)
		  n0O1l27 <= n0O1l28;
	event n0O1l27_event;
	initial
		#1 ->n0O1l27_event;
	always @(n0O1l27_event)
		n0O1l27 <= {1{1'b1}};
	initial
		n0O1l28 = 0;
	always @ ( posedge clk)
		  n0O1l28 <= n0O1l27;
	initial
		n0Oil23 = 0;
	always @ ( posedge clk)
		  n0Oil23 <= n0Oil24;
	event n0Oil23_event;
	initial
		#1 ->n0Oil23_event;
	always @(n0Oil23_event)
		n0Oil23 <= {1{1'b1}};
	initial
		n0Oil24 = 0;
	always @ ( posedge clk)
		  n0Oil24 <= n0Oil23;
	initial
		n0Oli21 = 0;
	always @ ( posedge clk)
		  n0Oli21 <= n0Oli22;
	event n0Oli21_event;
	initial
		#1 ->n0Oli21_event;
	always @(n0Oli21_event)
		n0Oli21 <= {1{1'b1}};
	initial
		n0Oli22 = 0;
	always @ ( posedge clk)
		  n0Oli22 <= n0Oli21;
	initial
		n0OOi19 = 0;
	always @ ( posedge clk)
		  n0OOi19 <= n0OOi20;
	event n0OOi19_event;
	initial
		#1 ->n0OOi19_event;
	always @(n0OOi19_event)
		n0OOi19 <= {1{1'b1}};
	initial
		n0OOi20 = 0;
	always @ ( posedge clk)
		  n0OOi20 <= n0OOi19;
	initial
		n0OOO17 = 0;
	always @ ( posedge clk)
		  n0OOO17 <= n0OOO18;
	event n0OOO17_event;
	initial
		#1 ->n0OOO17_event;
	always @(n0OOO17_event)
		n0OOO17 <= {1{1'b1}};
	initial
		n0OOO18 = 0;
	always @ ( posedge clk)
		  n0OOO18 <= n0OOO17;
	initial
		ni00i5 = 0;
	always @ ( posedge clk)
		  ni00i5 <= ni00i6;
	event ni00i5_event;
	initial
		#1 ->ni00i5_event;
	always @(ni00i5_event)
		ni00i5 <= {1{1'b1}};
	initial
		ni00i6 = 0;
	always @ ( posedge clk)
		  ni00i6 <= ni00i5;
	initial
		ni0il3 = 0;
	always @ ( posedge clk)
		  ni0il3 <= ni0il4;
	event ni0il3_event;
	initial
		#1 ->ni0il3_event;
	always @(ni0il3_event)
		ni0il3 <= {1{1'b1}};
	initial
		ni0il4 = 0;
	always @ ( posedge clk)
		  ni0il4 <= ni0il3;
	initial
		ni0ll1 = 0;
	always @ ( posedge clk)
		  ni0ll1 <= ni0ll2;
	event ni0ll1_event;
	initial
		#1 ->ni0ll1_event;
	always @(ni0ll1_event)
		ni0ll1 <= {1{1'b1}};
	initial
		ni0ll2 = 0;
	always @ ( posedge clk)
		  ni0ll2 <= ni0ll1;
	initial
		ni10l13 = 0;
	always @ ( posedge clk)
		  ni10l13 <= ni10l14;
	event ni10l13_event;
	initial
		#1 ->ni10l13_event;
	always @(ni10l13_event)
		ni10l13 <= {1{1'b1}};
	initial
		ni10l14 = 0;
	always @ ( posedge clk)
		  ni10l14 <= ni10l13;
	initial
		ni11O15 = 0;
	always @ ( posedge clk)
		  ni11O15 <= ni11O16;
	event ni11O15_event;
	initial
		#1 ->ni11O15_event;
	always @(ni11O15_event)
		ni11O15 <= {1{1'b1}};
	initial
		ni11O16 = 0;
	always @ ( posedge clk)
		  ni11O16 <= ni11O15;
	initial
		ni1ii11 = 0;
	always @ ( posedge clk)
		  ni1ii11 <= ni1ii12;
	event ni1ii11_event;
	initial
		#1 ->ni1ii11_event;
	always @(ni1ii11_event)
		ni1ii11 <= {1{1'b1}};
	initial
		ni1ii12 = 0;
	always @ ( posedge clk)
		  ni1ii12 <= ni1ii11;
	initial
		ni1iO10 = 0;
	always @ ( posedge clk)
		  ni1iO10 <= ni1iO9;
	initial
		ni1iO9 = 0;
	always @ ( posedge clk)
		  ni1iO9 <= ni1iO10;
	event ni1iO9_event;
	initial
		#1 ->ni1iO9_event;
	always @(ni1iO9_event)
		ni1iO9 <= {1{1'b1}};
	initial
		ni1ll7 = 0;
	always @ ( posedge clk)
		  ni1ll7 <= ni1ll8;
	event ni1ll7_event;
	initial
		#1 ->ni1ll7_event;
	always @(ni1ll7_event)
		ni1ll7 <= {1{1'b1}};
	initial
		ni1ll8 = 0;
	always @ ( posedge clk)
		  ni1ll8 <= ni1ll7;
	initial
	begin
		n0O = 0;
		nii = 0;
		niO = 0;
		nlll = 0;
		nllO = 0;
		nlOi = 0;
		nlOl = 0;
		nlOO = 0;
	end
	always @ (clk or reset or wire_nil_CLRN)
	begin
		if (reset == 1'b1) 
		begin
			n0O <= 1;
			nii <= 1;
			niO <= 1;
			nlll <= 1;
			nllO <= 1;
			nlOi <= 1;
			nlOl <= 1;
			nlOO <= 1;
		end
		else if  (wire_nil_CLRN == 1'b0) 
		begin
			n0O <= 0;
			nii <= 0;
			niO <= 0;
			nlll <= 0;
			nllO <= 0;
			nlOi <= 0;
			nlOl <= 0;
			nlOO <= 0;
		end
		else 
		if (clk != nil_clk_prev && clk == 1'b1) 
		begin
			n0O <= wire_niO0O_dataout;
			nii <= wire_niO0l_dataout;
			niO <= wire_niO0i_dataout;
			nlll <= ni0ii;
			nllO <= ni0ii;
			nlOi <= wire_niO0O_dataout;
			nlOl <= wire_niO0l_dataout;
			nlOO <= wire_niO0i_dataout;
		end
		nil_clk_prev <= clk;
	end
	assign
		wire_nil_CLRN = (ni0il4 ^ ni0il3);
	event n0O_event;
	event nii_event;
	event niO_event;
	event nlll_event;
	event nllO_event;
	event nlOi_event;
	event nlOl_event;
	event nlOO_event;
	initial
		#1 ->n0O_event;
	initial
		#1 ->nii_event;
	initial
		#1 ->niO_event;
	initial
		#1 ->nlll_event;
	initial
		#1 ->nllO_event;
	initial
		#1 ->nlOi_event;
	initial
		#1 ->nlOl_event;
	initial
		#1 ->nlOO_event;
	always @(n0O_event)
		n0O <= 1;
	always @(nii_event)
		nii <= 1;
	always @(niO_event)
		niO <= 1;
	always @(nlll_event)
		nlll <= 1;
	always @(nllO_event)
		nllO <= 1;
	always @(nlOi_event)
		nlOi <= 1;
	always @(nlOl_event)
		nlOl <= 1;
	always @(nlOO_event)
		nlOO <= 1;
	initial
	begin
		n0i = 0;
		n0l = 0;
		n1i = 0;
		n1l = 0;
		n1O = 0;
		ni = 0;
		niii = 0;
		niil = 0;
		niiO = 0;
		nili = 0;
		nill = 0;
		nilO = 0;
		niOi = 0;
		niOl = 0;
		niOO = 0;
		nl0i = 0;
		nl0l = 0;
		nl0O = 0;
		nl1i = 0;
		nl1l = 0;
		nl1O = 0;
		nli = 0;
		nlii = 0;
		nlil = 0;
		nliO = 0;
		nll = 0;
		nlli = 0;
		nlO = 0;
		nO = 0;
	end
	always @ ( posedge clk or  negedge wire_nl_CLRN)
	begin
		if (wire_nl_CLRN == 1'b0) 
		begin
			n0i <= 0;
			n0l <= 0;
			n1i <= 0;
			n1l <= 0;
			n1O <= 0;
			ni <= 0;
			niii <= 0;
			niil <= 0;
			niiO <= 0;
			nili <= 0;
			nill <= 0;
			nilO <= 0;
			niOi <= 0;
			niOl <= 0;
			niOO <= 0;
			nl0i <= 0;
			nl0l <= 0;
			nl0O <= 0;
			nl1i <= 0;
			nl1l <= 0;
			nl1O <= 0;
			nli <= 0;
			nlii <= 0;
			nlil <= 0;
			nliO <= 0;
			nll <= 0;
			nlli <= 0;
			nlO <= 0;
			nO <= 0;
		end
		else 
		begin
			n0i <= wire_nlilO_dataout;
			n0l <= wire_nlill_dataout;
			n1i <= wire_niO1O_dataout;
			n1l <= wire_niO1l_dataout;
			n1O <= wire_nliOi_dataout;
			ni <= wire_nlilO_dataout;
			niii <= datain[0];
			niil <= datain[1];
			niiO <= datain[2];
			nili <= datain[3];
			nill <= datain[4];
			nilO <= datain[5];
			niOi <= datain[6];
			niOl <= datain[7];
			niOO <= datain[8];
			nl0i <= datainvalid;
			nl0l <= disperrin;
			nl0O <= patterndetectin;
			nl1i <= datain[9];
			nl1l <= disperrin;
			nl1O <= datainvalid;
			nli <= wire_niO1O_dataout;
			nlii <= syncstatusin;
			nlil <= disperrin;
			nliO <= errdetectin;
			nll <= wire_niO1l_dataout;
			nlli <= datainvalid;
			nlO <= wire_nliOi_dataout;
			nO <= wire_nlill_dataout;
		end
	end
	assign
		wire_nl_CLRN = ((ni0ll2 ^ ni0ll1) & (~ reset));
	or(wire_niO0i_dataout, wire_niOiO_dataout, ni01l);
	and(wire_niO0l_dataout, wire_niOli_dataout, ~(ni01l));
	and(wire_niO0O_dataout, wire_niOll_dataout, ~(ni01l));
	or(wire_niO1l_dataout, wire_niOii_dataout, ni01l);
	or(wire_niO1O_dataout, wire_niOil_dataout, ni01l);
	or(wire_niOii_dataout, wire_niOlO_dataout, ni11l);
	or(wire_niOil_dataout, wire_niOOi_dataout, ni11l);
	and(wire_niOiO_dataout, wire_niOOl_dataout, ~(ni11l));
	and(wire_niOli_dataout, wire_niOOO_dataout, ~(ni11l));
	and(wire_niOll_dataout, wire_nl11i_dataout, ~(ni11l));
	assign		wire_niOlO_dataout = (n0OlO === 1'b1) ? wire_nl1il_dataout : wire_nl11l_dataout;
	assign		wire_niOOi_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl11O_dataout;
	assign		wire_niOOl_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl10i_dataout;
	assign		wire_niOOO_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl10l_dataout;
	assign		wire_nl10i_dataout = (n0l1i === 1'b1) ? datain[2] : (~ wire_nli0i_dataout);
	assign		wire_nl10l_dataout = (n0l1i === 1'b1) ? datain[1] : (~ wire_nli0l_dataout);
	assign		wire_nl10O_dataout = (n0l1i === 1'b1) ? datain[0] : (~ wire_nli0O_dataout);
	assign		wire_nl11i_dataout = (n0OlO === 1'b1) ? wire_nl1iO_dataout : wire_nl10O_dataout;
	assign		wire_nl11l_dataout = (n0l1i === 1'b1) ? datain[4] : ni1Oi;
	assign		wire_nl11O_dataout = (n0l1i === 1'b1) ? datain[3] : (~ wire_nli1O_dataout);
	and(wire_nl1il_dataout, wire_nl1li_dataout, ~(n0iOi));
	and(wire_nl1iO_dataout, (~ n0ilO), ~(n0iOi));
	or(wire_nl1li_dataout, (~ (wire_nli0l_dataout & (~ wire_nli0i_dataout))), n0ilO);
	assign		wire_nli0i_dataout = (datain[5] === 1'b1) ? datain[2] : (~ datain[2]);
	assign		wire_nli0l_dataout = (datain[5] === 1'b1) ? datain[1] : (~ datain[1]);
	assign		wire_nli0O_dataout = (datain[5] === 1'b1) ? datain[0] : (~ datain[0]);
	assign		wire_nli1l_dataout = (datain[5] === 1'b1) ? datain[4] : (~ datain[4]);
	assign		wire_nli1O_dataout = (datain[5] === 1'b1) ? datain[3] : (~ datain[3]);
	and(wire_nlill_dataout, wire_nliOl_dataout, ~(ni1Ol));
	and(wire_nlilO_dataout, wire_nliOO_dataout, ~(ni1Ol));
	and(wire_nliOi_dataout, wire_nll1i_dataout, ~(ni1Ol));
	or(wire_nliOl_dataout, wire_nll1l_dataout, ni1OO);
	or(wire_nliOO_dataout, wire_nll1O_dataout, ni1OO);
	assign		wire_nll0i_dataout = ((~ ni01O) === 1'b1) ? wire_nlllO_dataout : wire_nllii_dataout;
	assign		wire_nll0l_dataout = (ni01i === 1'b1) ? (~ datain[8]) : datain[8];
	assign		wire_nll0O_dataout = (ni01i === 1'b1) ? (~ datain[7]) : datain[7];
	or(wire_nll1i_dataout, wire_nll0i_dataout, ni1OO);
	assign		wire_nll1l_dataout = ((~ ni01O) === 1'b1) ? wire_nllli_dataout : wire_nll0l_dataout;
	assign		wire_nll1O_dataout = ((~ ni01O) === 1'b1) ? wire_nllll_dataout : wire_nll0O_dataout;
	assign		wire_nllii_dataout = (ni01i === 1'b1) ? (~ datain[6]) : datain[6];
	assign		wire_nllli_dataout = (datain[9] === 1'b1) ? (~ datain[8]) : datain[8];
	assign		wire_nllll_dataout = (datain[9] === 1'b1) ? (~ datain[7]) : datain[7];
	assign		wire_nlllO_dataout = (datain[9] === 1'b1) ? (~ datain[6]) : datain[6];
	assign
		dataout = {nO, ni, nlO, nll, nli, niO, nii, n0O},
		decdatavalid = nl0i,
		disperr = nl0l,
		errdetect = nliO,
		kout = nllO,
		n0ill = ((~ wire_nli0O_dataout) & (~ wire_nli0l_dataout)),
		n0ilO = (wire_nli0l_dataout & wire_nli0i_dataout),
		n0iOi = (((~ wire_nli0l_dataout) & (~ wire_nli0i_dataout)) & (n0iOl44 ^ n0iOl43)),
		n0l0i = (((((~ wire_nli1O_dataout) & ((~ wire_nli0i_dataout) & (wire_nli0O_dataout & (~ wire_nli0l_dataout)))) | ((~ wire_nli1O_dataout) & ((~ wire_nli0i_dataout) & ((~ wire_nli0O_dataout) & wire_nli0l_dataout)))) | ((~ wire_nli1O_dataout) & (wire_nli0i_dataout & n0ill))) | (wire_nli1O_dataout & ((~ wire_nli0i_dataout) & n0ill))),
		n0l1i = (((((~ wire_nli1l_dataout) & (((((((((((~ wire_nli1O_dataout) & (((~ wire_nli0i_dataout) & (wire_nli0O_dataout & wire_nli0l_dataout)) & (n0Oli22 ^ n0Oli21))) & (n0Oil24 ^ n0Oil23)) | ((~ wire_nli1O_dataout) & (wire_nli0i_dataout & n0Oii))) | (~ (n0O0l26 ^ n0O0l25))) | (((~ wire_nli1O_dataout) & (wire_nli0i_dataout & n0O0i)) & (n0O1l28 ^ n0O1l27))) | (~ (n0lOO30 ^ n0lOO29))) | (wire_nli1O_dataout & (((~ wire_nli0i_dataout) & n0Oii) & (n0lOi32 ^ n0lOi31)))) | (~ (n0lll34 ^ n0lll33))) | ((wire_nli1O_dataout & ((~ wire_nli0i_dataout) & n0O0i)) & (n0liO36 ^ n0liO35))) | (wire_nli1O_dataout & ((wire_nli0i_dataout & ((~ wire_nli0O_dataout) & (~ wire_nli0l_dataout))) & (n0lii38 ^ n0lii37))))) & (n0l0l40 ^ n0l0l39)) | ((wire_nli1l_dataout & n0l0i) & (n0l1l42 ^ n0l1l41))) & (wire_nli0i_dataout | (wire_nli0O_dataout | wire_nli0l_dataout))),
		n0O0i = ((~ wire_nli0O_dataout) & wire_nli0l_dataout),
		n0Oii = (wire_nli0O_dataout & (~ wire_nli0l_dataout)),
		n0OlO = (wire_nli1l_dataout & (((wire_nli0O_dataout ^ wire_nli0l_dataout) ^ (~ (n0OOO18 ^ n0OOO17))) & ((wire_nli0i_dataout ^ wire_nli1O_dataout) ^ (~ (n0OOi20 ^ n0OOi19))))),
		ni01i = ((~ datain[5]) & ni01l),
		ni01l = (wire_nli1l_dataout & (wire_nli1O_dataout & ((wire_nli0i_dataout & ((~ wire_nli0O_dataout) & (~ wire_nli0l_dataout))) & (ni10l14 ^ ni10l13)))),
		ni01O = ((datain[6] ^ datain[7]) ^ (~ (ni00i6 ^ ni00i5))),
		ni0ii = ((ni01l | (ni1Oi & ni1OO)) | (~ (ni1ll8 ^ ni1ll7))),
		ni0iO = 1'b1,
		ni11l = (wire_nli1l_dataout & ((~ wire_nli1O_dataout) & (((~ wire_nli0i_dataout) & (wire_nli0O_dataout & wire_nli0l_dataout)) & (ni11O16 ^ ni11O15)))),
		ni1Oi = ((~ wire_nli1l_dataout) & n0l0i),
		ni1Ol = ((((~ wire_nlllO_dataout) & wire_nllll_dataout) & (~ wire_nllli_dataout)) & (ni1iO10 ^ ni1iO9)),
		ni1OO = (((wire_nlllO_dataout & (~ wire_nllll_dataout)) & (~ wire_nllli_dataout)) & (ni1ii12 ^ ni1ii11)),
		patterndetect = nl0O,
		rderr = nlil,
		syncstatus = nlii,
		tenBdata = {nl1i, niOO, niOl, niOi, nilO, nill, nili, niiO, niil, niii},
		valid = nlli,
		xgmctrldet = nlll,
		xgmdataout = {n0l, n0i, n1O, n1l, n1i, nlOO, nlOl, nlOi},
		xgmdatavalid = nl1O,
		xgmrunningdisp = nl1l;
endmodule //stratixgx_8b10b_decoder
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                            DESKEW FIFO RAM MODULE
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module deskew_ram_block (
    clk,
    reset, 
    addrwr,
    addrrd1,
    addrrd2,
    datain,
    we,
    re,
    dataout1,
    dataout2
    );

input       clk;
input       reset;
input   [15:0]  addrwr;
input   [15:0]  addrrd1;
input   [15:0]  addrrd2;
input   [13:0]  datain;
input       we, re;
output  [13:0]  dataout1;
output  [13:0]  dataout2;

parameter read_access_time = 0;
parameter write_access_time = 0;
parameter ram_width = 14;

reg [ram_width-1:0] dataout1_i, dataout2_i;
reg [ram_width-1:0] ram_array_d_0, ram_array_d_1, ram_array_d_2, ram_array_d_3,
            ram_array_d_4, ram_array_d_5, ram_array_d_6, ram_array_d_7,
            ram_array_d_8, ram_array_d_9, ram_array_d_10, ram_array_d_11,
            ram_array_d_12, ram_array_d_13, ram_array_d_14, ram_array_d_15,
            ram_array_q_0, ram_array_q_1, ram_array_q_2, ram_array_q_3,
            ram_array_q_4, ram_array_q_5, ram_array_q_6, ram_array_q_7,
            ram_array_q_8, ram_array_q_9, ram_array_q_10, ram_array_q_11,
            ram_array_q_12, ram_array_q_13, ram_array_q_14, ram_array_q_15;
wire [ram_width-1:0] data_reg_0, data_reg_1, data_reg_2, data_reg_3,
             data_reg_4, data_reg_5, data_reg_6, data_reg_7,
             data_reg_8, data_reg_9, data_reg_10, data_reg_11,
             data_reg_12, data_reg_13, data_reg_14, data_reg_15;

 /* Modelling the read port */
 /* Assuming address trigerred operation only */
//assignment
assign
    data_reg_0 = ( addrwr[0] == 1'b1 ) ? datain : ram_array_q_0,
    data_reg_1 = ( addrwr[1] == 1'b1 ) ? datain : ram_array_q_1,
    data_reg_2 = ( addrwr[2] == 1'b1 ) ? datain : ram_array_q_2,
    data_reg_3 = ( addrwr[3] == 1'b1 ) ? datain : ram_array_q_3,
    data_reg_4 = ( addrwr[4] == 1'b1 ) ? datain : ram_array_q_4,
    data_reg_5 = ( addrwr[5] == 1'b1 ) ? datain : ram_array_q_5,
    data_reg_6 = ( addrwr[6] == 1'b1 ) ? datain : ram_array_q_6,
    data_reg_7 = ( addrwr[7] == 1'b1 ) ? datain : ram_array_q_7,
    data_reg_8 = ( addrwr[8] == 1'b1 ) ? datain : ram_array_q_8,
    data_reg_9 = ( addrwr[9] == 1'b1 ) ? datain : ram_array_q_9,
    data_reg_10 = ( addrwr[10] == 1'b1 ) ? datain : ram_array_q_10,
    data_reg_11 = ( addrwr[11] == 1'b1 ) ? datain : ram_array_q_11,
    data_reg_12 = ( addrwr[12] == 1'b1 ) ? datain : ram_array_q_12,
    data_reg_13 = ( addrwr[13] == 1'b1 ) ? datain : ram_array_q_13,
    data_reg_14 = ( addrwr[14] == 1'b1 ) ? datain : ram_array_q_14,
    data_reg_15 = ( addrwr[15] == 1'b1 ) ? datain : ram_array_q_15;


assign #read_access_time dataout1 = re ? 13'b0000000000000 : dataout1_i;
assign #read_access_time dataout2 = re ? 13'b0000000000000 : dataout2_i;


always @(
    ram_array_q_0   or 
    ram_array_q_1   or 
    ram_array_q_2   or 
    ram_array_q_3   or 
    ram_array_q_4       or
    ram_array_q_5       or
    ram_array_q_6       or
    ram_array_q_7       or 
    ram_array_q_8       or
    ram_array_q_9       or
    ram_array_q_10      or
    ram_array_q_11      or 
    ram_array_q_12      or
    ram_array_q_13      or
    ram_array_q_14      or
    ram_array_q_15      or 
    addrrd1     or
    addrrd2     )
begin
    case ( addrrd1 )  // synopsys parallel_case full_case
    16'b0000000000000001 : dataout1_i = ram_array_q_0;
    16'b0000000000000010 : dataout1_i = ram_array_q_1;
    16'b0000000000000100 : dataout1_i = ram_array_q_2;
    16'b0000000000001000 : dataout1_i = ram_array_q_3;
    16'b0000000000010000 : dataout1_i = ram_array_q_4;
    16'b0000000000100000 : dataout1_i = ram_array_q_5;
    16'b0000000001000000 : dataout1_i = ram_array_q_6;
    16'b0000000010000000 : dataout1_i = ram_array_q_7;
    16'b0000000100000000 : dataout1_i = ram_array_q_8;
    16'b0000001000000000 : dataout1_i = ram_array_q_9;
    16'b0000010000000000 : dataout1_i = ram_array_q_10;
    16'b0000100000000000 : dataout1_i = ram_array_q_11;
    16'b0001000000000000 : dataout1_i = ram_array_q_12;
    16'b0010000000000000 : dataout1_i = ram_array_q_13;
    16'b0100000000000000 : dataout1_i = ram_array_q_14;
    16'b1000000000000000 : dataout1_i = ram_array_q_15;
    endcase

    case ( addrrd2 )  // synopsys parallel_case full_case
    16'b0000000000000001 : dataout2_i = ram_array_q_0;
    16'b0000000000000010 : dataout2_i = ram_array_q_1;
    16'b0000000000000100 : dataout2_i = ram_array_q_2;
    16'b0000000000001000 : dataout2_i = ram_array_q_3;
    16'b0000000000010000 : dataout2_i = ram_array_q_4;
    16'b0000000000100000 : dataout2_i = ram_array_q_5;
    16'b0000000001000000 : dataout2_i = ram_array_q_6;
    16'b0000000010000000 : dataout2_i = ram_array_q_7;
    16'b0000000100000000 : dataout2_i = ram_array_q_8;
    16'b0000001000000000 : dataout2_i = ram_array_q_9;
    16'b0000010000000000 : dataout2_i = ram_array_q_10;
    16'b0000100000000000 : dataout2_i = ram_array_q_11;
    16'b0001000000000000 : dataout2_i = ram_array_q_12;
    16'b0010000000000000 : dataout2_i = ram_array_q_13;
    16'b0100000000000000 : dataout2_i = ram_array_q_14;
    16'b1000000000000000 : dataout2_i = ram_array_q_15;
    endcase

end


/* Modelling the write port */
always @(posedge clk or posedge reset) 
begin
    if(reset) begin
    ram_array_q_0 <= #write_access_time 0;
    ram_array_q_1 <= #write_access_time 0;
    ram_array_q_2 <= #write_access_time 0; 
    ram_array_q_3 <= #write_access_time 0; 
        ram_array_q_4 <= #write_access_time 0;
        ram_array_q_5 <= #write_access_time 0;
        ram_array_q_6 <= #write_access_time 0;
        ram_array_q_7 <= #write_access_time 0; 
        ram_array_q_8 <= #write_access_time 0;
        ram_array_q_9 <= #write_access_time 0;
        ram_array_q_10 <= #write_access_time 0;
        ram_array_q_11 <= #write_access_time 0; 
        ram_array_q_12 <= #write_access_time 0;
        ram_array_q_13 <= #write_access_time 0;
        ram_array_q_14 <= #write_access_time 0;
        ram_array_q_15 <= #write_access_time 0; 
    end
    else begin
    ram_array_q_0 <= #write_access_time ram_array_d_0;
    ram_array_q_1 <= #write_access_time ram_array_d_1;
    ram_array_q_2 <= #write_access_time ram_array_d_2;
    ram_array_q_3 <= #write_access_time ram_array_d_3;
        ram_array_q_4 <= #write_access_time ram_array_d_4;
        ram_array_q_5 <= #write_access_time ram_array_d_5;
        ram_array_q_6 <= #write_access_time ram_array_d_6;
        ram_array_q_7 <= #write_access_time ram_array_d_7;
        ram_array_q_8 <= #write_access_time ram_array_d_8;
        ram_array_q_9 <= #write_access_time ram_array_d_9;
        ram_array_q_10 <= #write_access_time ram_array_d_10;
        ram_array_q_11 <= #write_access_time ram_array_d_11;
        ram_array_q_12 <= #write_access_time ram_array_d_12;
        ram_array_q_13 <= #write_access_time ram_array_d_13;
        ram_array_q_14 <= #write_access_time ram_array_d_14;
        ram_array_q_15 <= #write_access_time ram_array_d_15;
    end
end
         

always @( 
    we          or 
    data_reg_0      or 
    data_reg_1      or 
    data_reg_2      or 
    data_reg_3      or
    data_reg_4          or
    data_reg_5          or
    data_reg_6          or
    data_reg_7          or
    data_reg_8          or
    data_reg_9          or
    data_reg_10         or
    data_reg_11         or
    data_reg_12         or
    data_reg_13         or
    data_reg_14         or
    data_reg_15         or
    ram_array_q_0   or 
    ram_array_q_1   or
    ram_array_q_2   or
    ram_array_q_3   or
    ram_array_q_4       or
    ram_array_q_5       or
    ram_array_q_6       or
    ram_array_q_7   or
    ram_array_q_8       or
    ram_array_q_9       or
    ram_array_q_10      or
    ram_array_q_11  or
    ram_array_q_12      or
    ram_array_q_13      or
    ram_array_q_14      or
    ram_array_q_15  )
begin
    if(we) begin
    ram_array_d_0 <= #write_access_time data_reg_0;
    ram_array_d_1 <= #write_access_time data_reg_1;
    ram_array_d_2 <= #write_access_time data_reg_2;
    ram_array_d_3 <= #write_access_time data_reg_3;
        ram_array_d_4 <= #write_access_time data_reg_4;
        ram_array_d_5 <= #write_access_time data_reg_5;
        ram_array_d_6 <= #write_access_time data_reg_6;
        ram_array_d_7 <= #write_access_time data_reg_7; 
        ram_array_d_8 <= #write_access_time data_reg_8;
        ram_array_d_9 <= #write_access_time data_reg_9;
        ram_array_d_10 <= #write_access_time data_reg_10;
        ram_array_d_11 <= #write_access_time data_reg_11; 
        ram_array_d_12 <= #write_access_time data_reg_12;
        ram_array_d_13 <= #write_access_time data_reg_13;
        ram_array_d_14 <= #write_access_time data_reg_14;
        ram_array_d_15 <= #write_access_time data_reg_15; 
    end
    else begin
    ram_array_d_0 <= #write_access_time ram_array_q_0;
    ram_array_d_1 <= #write_access_time ram_array_q_1;
    ram_array_d_2 <= #write_access_time ram_array_q_2;
    ram_array_d_3 <= #write_access_time ram_array_q_3;
        ram_array_d_4 <= #write_access_time ram_array_q_4;
        ram_array_d_5 <= #write_access_time ram_array_q_5;
        ram_array_d_6 <= #write_access_time ram_array_q_6;
        ram_array_d_7 <= #write_access_time ram_array_q_7;
        ram_array_d_8 <= #write_access_time ram_array_q_8;
        ram_array_d_9 <= #write_access_time ram_array_q_9;
        ram_array_d_10 <= #write_access_time ram_array_q_10;
        ram_array_d_11 <= #write_access_time ram_array_q_11;
        ram_array_d_12 <= #write_access_time ram_array_q_12;
        ram_array_d_13 <= #write_access_time ram_array_q_13;
        ram_array_d_14 <= #write_access_time ram_array_q_14;
        ram_array_d_15 <= #write_access_time ram_array_q_15;

    end
end

endmodule

//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = deskew_ram_block 1 lut 103 mux21 112 oper_add 1 
`timescale 1 ps / 1 ps
module  stratixgx_deskew_fifo_rtl
	( 
	adetectdeskew,
	datain,
	dataout,
	dataoutpre,
	disperr,
	disperrin,
	disperrpre,
	enabledeskew,
	errdetect,
	errdetectin,
	errdetectpre,
	fiforesetrd,
	patterndetect,
	patterndetectin,
	patterndetectpre,
	readclock,
	reset,
	syncstatus,
	syncstatusin,
	syncstatuspre,
	wr_align,
	writeclock) /* synthesis synthesis_clearbox=1 */;
	output   adetectdeskew;
	input   [9:0]  datain;
	output   [9:0]  dataout;
	output   [9:0]  dataoutpre;
	output   disperr;
	input   disperrin;
	output   disperrpre;
	input   enabledeskew;
	output   errdetect;
	input   errdetectin;
	output   errdetectpre;
	input   fiforesetrd;
	output   patterndetect;
	input   patterndetectin;
	output   patterndetectpre;
	input   readclock;
	input   reset;
	output   syncstatus;
	input   syncstatusin;
	output   syncstatuspre;
	input   wr_align;
	input   writeclock;

	wire  [13:0]   wire_n0ill_dataout1;
	wire  [13:0]   wire_n0ill_dataout2;
	reg	n00li15;
	reg	n00li16;
	reg	n00ll13;
	reg	n00ll14;
	reg	n00lO11;
	reg	n00lO12;
	reg	n00Oi10;
	reg	n00Oi9;
	reg	n00OO7;
	reg	n00OO8;
	reg	n0i0l3;
	reg	n0i0l4;
	reg	n0i1l5;
	reg	n0i1l6;
	reg	n0iii1;
	reg	n0iii2;
	reg	n0ll;
	reg	n0lO;
	reg	n0Oi;
	reg	n0Ol;
	reg	n0OO;
	reg	ni0i;
	reg	ni0iO;
	reg	ni0l;
	reg	ni0li;
	reg	ni0ll;
	reg	ni0lO;
	reg	ni0O;
	reg	ni0Oi;
	reg	ni1i;
	reg	ni1l;
	reg	ni1O;
	reg	niii;
	reg	niil;
	reg	niiO;
	reg	niiOi;
	reg	nill;
	wire	wire_nili_CLRN;
	reg	nl01O;
	reg	nl11l;
	reg	nl01l_clk_prev;
	wire	wire_nl01l_CLRN;
	reg	ni00O;
	reg	ni0ii;
	reg	ni0il;
	reg	nli0O;
	reg	nli0l_clk_prev;
	wire	wire_nli0l_CLRN;
	wire	wire_nli0l_PRN;
	reg	ni00l;
	reg	niill;
	reg	nil0i;
	reg	nil0l;
	reg	nil0O;
	reg	nil1i;
	reg	nilii;
	reg	nilil;
	reg	niliO;
	reg	nilli;
	reg	nilll;
	reg	nillO;
	reg	nilOi;
	reg	nilOl;
	reg	nilOO;
	reg	niO0i;
	reg	niO0l;
	reg	niO0O;
	reg	niO1i;
	reg	niO1l;
	reg	niO1O;
	reg	niOii;
	reg	niOil;
	reg	niOiO;
	reg	niOli;
	reg	niOll;
	reg	niOlO;
	reg	niOOi;
	reg	niOOl;
	reg	niOOO;
	reg	nl00i;
	reg	nl00l;
	reg	nl00O;
	reg	nl01i;
	reg	nl0ii;
	reg	nl0il;
	reg	nl0iO;
	reg	nl0li;
	reg	nl0ll;
	reg	nl0lO;
	reg	nl0Oi;
	reg	nl0Ol;
	reg	nl0OO;
	reg	nl10i;
	reg	nl10l;
	reg	nl10O;
	reg	nl11i;
	reg	nl11O;
	reg	nl1ii;
	reg	nl1il;
	reg	nl1iO;
	reg	nl1li;
	reg	nl1ll;
	reg	nl1lO;
	reg	nl1Oi;
	reg	nl1Ol;
	reg	nl1OO;
	reg	nli0i;
	reg	nli1i;
	reg	nli1l;
	wire	wire_nli1O_CLRN;
	wire	wire_n00i_dataout;
	wire	wire_n00l_dataout;
	wire	wire_n00O_dataout;
	wire	wire_n01i_dataout;
	wire	wire_n01l_dataout;
	wire	wire_n01O_dataout;
	wire	wire_n0i_dataout;
	wire	wire_n0ii_dataout;
	wire	wire_n0il_dataout;
	wire	wire_n0iO_dataout;
	wire	wire_n0l_dataout;
	wire	wire_n0li_dataout;
	wire	wire_n0O_dataout;
	wire	wire_n10i_dataout;
	wire	wire_n10l_dataout;
	wire	wire_n10O_dataout;
	wire	wire_n11i_dataout;
	wire	wire_n11l_dataout;
	wire	wire_n11O_dataout;
	wire	wire_n1i_dataout;
	wire	wire_n1ii_dataout;
	wire	wire_n1il_dataout;
	wire	wire_n1iO_dataout;
	wire	wire_n1l_dataout;
	wire	wire_n1li_dataout;
	wire	wire_n1ll_dataout;
	wire	wire_n1lO_dataout;
	wire	wire_n1O_dataout;
	wire	wire_n1Oi_dataout;
	wire	wire_n1Ol_dataout;
	wire	wire_n1OO_dataout;
	wire	wire_ni_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_nii_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niili_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_nil_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nilO_dataout;
	wire	wire_niO_dataout;
	wire	wire_niOi_dataout;
	wire	wire_niOl_dataout;
	wire	wire_niOO_dataout;
	wire	wire_nl0i_dataout;
	wire	wire_nl0l_dataout;
	wire	wire_nl0O_dataout;
	wire	wire_nl1i_dataout;
	wire	wire_nl1l_dataout;
	wire	wire_nl1O_dataout;
	wire	wire_nli_dataout;
	wire	wire_nlii_dataout;
	wire	wire_nliii_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nlil_dataout;
	wire	wire_nlili_dataout;
	wire	wire_nlill_dataout;
	wire	wire_nlilO_dataout;
	wire	wire_nliO_dataout;
	wire	wire_nliOi_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll0l_dataout;
	wire	wire_nll0O_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nlli_dataout;
	wire	wire_nllii_dataout;
	wire	wire_nllil_dataout;
	wire	wire_nlliO_dataout;
	wire	wire_nlll_dataout;
	wire	wire_nllli_dataout;
	wire	wire_nllll_dataout;
	wire	wire_nlllO_dataout;
	wire	wire_nllO_dataout;
	wire	wire_nllOi_dataout;
	wire	wire_nllOl_dataout;
	wire	wire_nllOO_dataout;
	wire	wire_nlO_dataout;
	wire	wire_nlO0i_dataout;
	wire	wire_nlO0l_dataout;
	wire	wire_nlO0O_dataout;
	wire	wire_nlO1i_dataout;
	wire	wire_nlO1l_dataout;
	wire	wire_nlO1O_dataout;
	wire	wire_nlOi_dataout;
	wire	wire_nlOii_dataout;
	wire	wire_nlOil_dataout;
	wire	wire_nlOiO_dataout;
	wire	wire_nlOl_dataout;
	wire	wire_nlOli_dataout;
	wire	wire_nlOll_dataout;
	wire	wire_nlOlO_dataout;
	wire	wire_nlOO_dataout;
	wire	wire_nlOOi_dataout;
	wire	wire_nlOOl_dataout;
	wire	wire_nlOOO_dataout;
	wire  [4:0]   wire_niilO_o;
	wire  n00iO;
	wire  n00Ol;
	wire  n0i0i;
	wire  n0i1i;

	deskew_ram_block   n0ill
	( 
	.addrrd1({nli0i, nli1l, nli1i, nl0OO, nl0Ol, nl0Oi, nl0lO, nl0ll, nl0li, nl0iO, nl0il, nl0ii, nl00O, nl00l, nl00i, nl01O}),
	.addrrd2({nl01i, nl1OO, nl1Ol, nl1Oi, nl1lO, nl1ll, nl1li, nl1iO, nl1il, nl1ii, nl10O, nl10l, nl10i, nl11O, nl11l, nl11i}),
	.addrwr({nill, niiO, niil, niii, ni0O, ni0l, ni0i, ni1O, ni1l, ni1i, n0OO, n0Ol, n0Oi, n0lO, n0ll, nli0O}),
	.clk(writeclock),
	.datain({patterndetectin, disperrin, syncstatusin, errdetectin, datain[9:0]}),
	.dataout1(wire_n0ill_dataout1),
	.dataout2(wire_n0ill_dataout2),
	.re(1'b0),
	.reset(reset),
	.we(1'b1));
	defparam
		n0ill.ram_width = 14,
		n0ill.read_access_time = 0,
		n0ill.write_access_time = 0;
	initial
		n00li15 = 0;
	always @ ( posedge readclock)
		  n00li15 <= n00li16;
	event n00li15_event;
	initial
		#1 ->n00li15_event;
	always @(n00li15_event)
		n00li15 <= {1{1'b1}};
	initial
		n00li16 = 0;
	always @ ( posedge readclock)
		  n00li16 <= n00li15;
	initial
		n00ll13 = 0;
	always @ ( posedge readclock)
		  n00ll13 <= n00ll14;
	event n00ll13_event;
	initial
		#1 ->n00ll13_event;
	always @(n00ll13_event)
		n00ll13 <= {1{1'b1}};
	initial
		n00ll14 = 0;
	always @ ( posedge readclock)
		  n00ll14 <= n00ll13;
	initial
		n00lO11 = 0;
	always @ ( posedge readclock)
		  n00lO11 <= n00lO12;
	event n00lO11_event;
	initial
		#1 ->n00lO11_event;
	always @(n00lO11_event)
		n00lO11 <= {1{1'b1}};
	initial
		n00lO12 = 0;
	always @ ( posedge readclock)
		  n00lO12 <= n00lO11;
	initial
		n00Oi10 = 0;
	always @ ( posedge readclock)
		  n00Oi10 <= n00Oi9;
	initial
		n00Oi9 = 0;
	always @ ( posedge readclock)
		  n00Oi9 <= n00Oi10;
	event n00Oi9_event;
	initial
		#1 ->n00Oi9_event;
	always @(n00Oi9_event)
		n00Oi9 <= {1{1'b1}};
	initial
		n00OO7 = 0;
	always @ ( posedge readclock)
		  n00OO7 <= n00OO8;
	event n00OO7_event;
	initial
		#1 ->n00OO7_event;
	always @(n00OO7_event)
		n00OO7 <= {1{1'b1}};
	initial
		n00OO8 = 0;
	always @ ( posedge readclock)
		  n00OO8 <= n00OO7;
	initial
		n0i0l3 = 0;
	always @ ( posedge readclock)
		  n0i0l3 <= n0i0l4;
	event n0i0l3_event;
	initial
		#1 ->n0i0l3_event;
	always @(n0i0l3_event)
		n0i0l3 <= {1{1'b1}};
	initial
		n0i0l4 = 0;
	always @ ( posedge readclock)
		  n0i0l4 <= n0i0l3;
	initial
		n0i1l5 = 0;
	always @ ( posedge readclock)
		  n0i1l5 <= n0i1l6;
	event n0i1l5_event;
	initial
		#1 ->n0i1l5_event;
	always @(n0i1l5_event)
		n0i1l5 <= {1{1'b1}};
	initial
		n0i1l6 = 0;
	always @ ( posedge readclock)
		  n0i1l6 <= n0i1l5;
	initial
		n0iii1 = 0;
	always @ ( posedge readclock)
		  n0iii1 <= n0iii2;
	event n0iii1_event;
	initial
		#1 ->n0iii1_event;
	always @(n0iii1_event)
		n0iii1 <= {1{1'b1}};
	initial
		n0iii2 = 0;
	always @ ( posedge readclock)
		  n0iii2 <= n0iii1;
	initial
	begin
		n0ll = 0;
		n0lO = 0;
		n0Oi = 0;
		n0Ol = 0;
		n0OO = 0;
		ni0i = 0;
		ni0iO = 0;
		ni0l = 0;
		ni0li = 0;
		ni0ll = 0;
		ni0lO = 0;
		ni0O = 0;
		ni0Oi = 0;
		ni1i = 0;
		ni1l = 0;
		ni1O = 0;
		niii = 0;
		niil = 0;
		niiO = 0;
		niiOi = 0;
		nill = 0;
	end
	always @ ( posedge writeclock or  negedge wire_nili_CLRN)
	begin
		if (wire_nili_CLRN == 1'b0) 
		begin
			n0ll <= 0;
			n0lO <= 0;
			n0Oi <= 0;
			n0Ol <= 0;
			n0OO <= 0;
			ni0i <= 0;
			ni0iO <= 0;
			ni0l <= 0;
			ni0li <= 0;
			ni0ll <= 0;
			ni0lO <= 0;
			ni0O <= 0;
			ni0Oi <= 0;
			ni1i <= 0;
			ni1l <= 0;
			ni1O <= 0;
			niii <= 0;
			niil <= 0;
			niiO <= 0;
			niiOi <= 0;
			nill <= 0;
		end
		else 
		begin
			n0ll <= wire_niOi_dataout;
			n0lO <= wire_niOl_dataout;
			n0Oi <= wire_niOO_dataout;
			n0Ol <= wire_nl1i_dataout;
			n0OO <= wire_nl1l_dataout;
			ni0i <= wire_nl0O_dataout;
			ni0iO <= wire_ni0Ol_dataout;
			ni0l <= wire_nlii_dataout;
			ni0li <= wire_ni0OO_dataout;
			ni0ll <= wire_nii1i_dataout;
			ni0lO <= wire_nii1l_dataout;
			ni0O <= wire_nlil_dataout;
			ni0Oi <= wire_niiOl_dataout;
			ni1i <= wire_nl1O_dataout;
			ni1l <= wire_nl0i_dataout;
			ni1O <= wire_nl0l_dataout;
			niii <= wire_nliO_dataout;
			niil <= wire_nlli_dataout;
			niiO <= wire_nlll_dataout;
			niiOi <= wire_nil1l_dataout;
			nill <= wire_nllO_dataout;
		end
	end
	assign
		wire_nili_CLRN = ((n00OO8 ^ n00OO7) & (~ reset));
	initial
	begin
		nl01O = 0;
		nl11l = 0;
	end
	always @ (readclock or reset or wire_nl01l_CLRN)
	begin
		if (reset == 1'b1) 
		begin
			nl01O <= 1;
			nl11l <= 1;
		end
		else if  (wire_nl01l_CLRN == 1'b0) 
		begin
			nl01O <= 0;
			nl11l <= 0;
		end
		else 
		if (readclock != nl01l_clk_prev && readclock == 1'b1) 
		begin
			nl01O <= wire_nllil_dataout;
			nl11l <= wire_nliil_dataout;
		end
		nl01l_clk_prev <= readclock;
	end
	assign
		wire_nl01l_CLRN = (n00li16 ^ n00li15);
	event nl01O_event;
	event nl11l_event;
	initial
		#1 ->nl01O_event;
	initial
		#1 ->nl11l_event;
	always @(nl01O_event)
		nl01O <= 1;
	always @(nl11l_event)
		nl11l <= 1;
	initial
	begin
		ni00O = 0;
		ni0ii = 0;
		ni0il = 0;
		nli0O = 0;
	end
	always @ (writeclock or wire_nli0l_PRN or wire_nli0l_CLRN)
	begin
		if (wire_nli0l_PRN == 1'b0) 
		begin
			ni00O <= 1;
			ni0ii <= 1;
			ni0il <= 1;
			nli0O <= 1;
		end
		else if  (wire_nli0l_CLRN == 1'b0) 
		begin
			ni00O <= 0;
			ni0ii <= 0;
			ni0il <= 0;
			nli0O <= 0;
		end
		else 
		if (writeclock != nli0l_clk_prev && writeclock == 1'b1) 
		begin
			ni00O <= ni0ii;
			ni0ii <= ni0il;
			ni0il <= enabledeskew;
			nli0O <= wire_nilO_dataout;
		end
		nli0l_clk_prev <= writeclock;
	end
	assign
		wire_nli0l_CLRN = (n00Oi10 ^ n00Oi9),
		wire_nli0l_PRN = ((n00lO12 ^ n00lO11) & (~ reset));
	event ni00O_event;
	event ni0ii_event;
	event ni0il_event;
	event nli0O_event;
	initial
		#1 ->ni00O_event;
	initial
		#1 ->ni0ii_event;
	initial
		#1 ->ni0il_event;
	initial
		#1 ->nli0O_event;
	always @(ni00O_event)
		ni00O <= 1;
	always @(ni0ii_event)
		ni0ii <= 1;
	always @(ni0il_event)
		ni0il <= 1;
	always @(nli0O_event)
		nli0O <= 1;
	initial
	begin
		ni00l = 0;
		niill = 0;
		nil0i = 0;
		nil0l = 0;
		nil0O = 0;
		nil1i = 0;
		nilii = 0;
		nilil = 0;
		niliO = 0;
		nilli = 0;
		nilll = 0;
		nillO = 0;
		nilOi = 0;
		nilOl = 0;
		nilOO = 0;
		niO0i = 0;
		niO0l = 0;
		niO0O = 0;
		niO1i = 0;
		niO1l = 0;
		niO1O = 0;
		niOii = 0;
		niOil = 0;
		niOiO = 0;
		niOli = 0;
		niOll = 0;
		niOlO = 0;
		niOOi = 0;
		niOOl = 0;
		niOOO = 0;
		nl00i = 0;
		nl00l = 0;
		nl00O = 0;
		nl01i = 0;
		nl0ii = 0;
		nl0il = 0;
		nl0iO = 0;
		nl0li = 0;
		nl0ll = 0;
		nl0lO = 0;
		nl0Oi = 0;
		nl0Ol = 0;
		nl0OO = 0;
		nl10i = 0;
		nl10l = 0;
		nl10O = 0;
		nl11i = 0;
		nl11O = 0;
		nl1ii = 0;
		nl1il = 0;
		nl1iO = 0;
		nl1li = 0;
		nl1ll = 0;
		nl1lO = 0;
		nl1Oi = 0;
		nl1Ol = 0;
		nl1OO = 0;
		nli0i = 0;
		nli1i = 0;
		nli1l = 0;
	end
	always @ ( posedge readclock or  negedge wire_nli1O_CLRN)
	begin
		if (wire_nli1O_CLRN == 1'b0) 
		begin
			ni00l <= 0;
			niill <= 0;
			nil0i <= 0;
			nil0l <= 0;
			nil0O <= 0;
			nil1i <= 0;
			nilii <= 0;
			nilil <= 0;
			niliO <= 0;
			nilli <= 0;
			nilll <= 0;
			nillO <= 0;
			nilOi <= 0;
			nilOl <= 0;
			nilOO <= 0;
			niO0i <= 0;
			niO0l <= 0;
			niO0O <= 0;
			niO1i <= 0;
			niO1l <= 0;
			niO1O <= 0;
			niOii <= 0;
			niOil <= 0;
			niOiO <= 0;
			niOli <= 0;
			niOll <= 0;
			niOlO <= 0;
			niOOi <= 0;
			niOOl <= 0;
			niOOO <= 0;
			nl00i <= 0;
			nl00l <= 0;
			nl00O <= 0;
			nl01i <= 0;
			nl0ii <= 0;
			nl0il <= 0;
			nl0iO <= 0;
			nl0li <= 0;
			nl0ll <= 0;
			nl0lO <= 0;
			nl0Oi <= 0;
			nl0Ol <= 0;
			nl0OO <= 0;
			nl10i <= 0;
			nl10l <= 0;
			nl10O <= 0;
			nl11i <= 0;
			nl11O <= 0;
			nl1ii <= 0;
			nl1il <= 0;
			nl1iO <= 0;
			nl1li <= 0;
			nl1ll <= 0;
			nl1lO <= 0;
			nl1Oi <= 0;
			nl1Ol <= 0;
			nl1OO <= 0;
			nli0i <= 0;
			nli1i <= 0;
			nli1l <= 0;
		end
		else 
		begin
			ni00l <= ni0Oi;
			niill <= ni00l;
			nil0i <= wire_n0ill_dataout1[13];
			nil0l <= wire_n0ill_dataout2[12];
			nil0O <= wire_n0ill_dataout2[11];
			nil1i <= wire_n0ill_dataout2[13];
			nilii <= wire_n0ill_dataout2[10];
			nilil <= wire_n0ill_dataout2[0];
			niliO <= wire_n0ill_dataout2[1];
			nilli <= wire_n0ill_dataout2[2];
			nilll <= wire_n0ill_dataout2[3];
			nillO <= wire_n0ill_dataout2[4];
			nilOi <= wire_n0ill_dataout2[5];
			nilOl <= wire_n0ill_dataout2[6];
			nilOO <= wire_n0ill_dataout2[7];
			niO0i <= wire_n0ill_dataout1[11];
			niO0l <= wire_n0ill_dataout1[10];
			niO0O <= wire_n0ill_dataout1[0];
			niO1i <= wire_n0ill_dataout2[8];
			niO1l <= wire_n0ill_dataout2[9];
			niO1O <= wire_n0ill_dataout1[12];
			niOii <= wire_n0ill_dataout1[1];
			niOil <= wire_n0ill_dataout1[2];
			niOiO <= wire_n0ill_dataout1[3];
			niOli <= wire_n0ill_dataout1[4];
			niOll <= wire_n0ill_dataout1[5];
			niOlO <= wire_n0ill_dataout1[6];
			niOOi <= wire_n0ill_dataout1[7];
			niOOl <= wire_n0ill_dataout1[8];
			niOOO <= wire_n0ill_dataout1[9];
			nl00i <= wire_nlliO_dataout;
			nl00l <= wire_nllli_dataout;
			nl00O <= wire_nllll_dataout;
			nl01i <= wire_nllii_dataout;
			nl0ii <= wire_nlllO_dataout;
			nl0il <= wire_nllOi_dataout;
			nl0iO <= wire_nllOl_dataout;
			nl0li <= wire_nllOO_dataout;
			nl0ll <= wire_nlO1i_dataout;
			nl0lO <= wire_nlO1l_dataout;
			nl0Oi <= wire_nlO1O_dataout;
			nl0Ol <= wire_nlO0i_dataout;
			nl0OO <= wire_nlO0l_dataout;
			nl10i <= wire_nlili_dataout;
			nl10l <= wire_nlill_dataout;
			nl10O <= wire_nlilO_dataout;
			nl11i <= wire_nliii_dataout;
			nl11O <= wire_nliiO_dataout;
			nl1ii <= wire_nliOi_dataout;
			nl1il <= wire_nliOl_dataout;
			nl1iO <= wire_nliOO_dataout;
			nl1li <= wire_nll1i_dataout;
			nl1ll <= wire_nll1l_dataout;
			nl1lO <= wire_nll1O_dataout;
			nl1Oi <= wire_nll0i_dataout;
			nl1Ol <= wire_nll0l_dataout;
			nl1OO <= wire_nll0O_dataout;
			nli0i <= wire_nlOil_dataout;
			nli1i <= wire_nlO0O_dataout;
			nli1l <= wire_nlOii_dataout;
		end
	end
	assign
		wire_nli1O_CLRN = ((n00ll14 ^ n00ll13) & (~ reset));
	and(wire_n00i_dataout, nl0ll, (~ enabledeskew));
	and(wire_n00l_dataout, nl0lO, (~ enabledeskew));
	and(wire_n00O_dataout, nl0Oi, (~ enabledeskew));
	and(wire_n01i_dataout, nl0il, (~ enabledeskew));
	and(wire_n01l_dataout, nl0iO, (~ enabledeskew));
	and(wire_n01O_dataout, nl0li, (~ enabledeskew));
	assign		wire_n0i_dataout = (n0i1i === 1'b1) ? n0OO : ni1i;
	and(wire_n0ii_dataout, nl0Ol, (~ enabledeskew));
	and(wire_n0il_dataout, nl0OO, (~ enabledeskew));
	and(wire_n0iO_dataout, nli1i, (~ enabledeskew));
	assign		wire_n0l_dataout = (n0i1i === 1'b1) ? ni1i : ni1l;
	and(wire_n0li_dataout, nli1l, (~ enabledeskew));
	assign		wire_n0O_dataout = (n0i1i === 1'b1) ? ni1l : ni1O;
	and(wire_n10i_dataout, nl1li, (~ enabledeskew));
	and(wire_n10l_dataout, nl1ll, (~ enabledeskew));
	and(wire_n10O_dataout, nl1lO, (~ enabledeskew));
	and(wire_n11i_dataout, nl1ii, (~ enabledeskew));
	and(wire_n11l_dataout, nl1il, (~ enabledeskew));
	and(wire_n11O_dataout, nl1iO, (~ enabledeskew));
	assign		wire_n1i_dataout = (n0i1i === 1'b1) ? n0lO : n0Oi;
	and(wire_n1ii_dataout, nl1Oi, (~ enabledeskew));
	and(wire_n1il_dataout, nl1Ol, (~ enabledeskew));
	and(wire_n1iO_dataout, nl1OO, (~ enabledeskew));
	assign		wire_n1l_dataout = (n0i1i === 1'b1) ? n0Oi : n0Ol;
	or(wire_n1li_dataout, nli0i, ~((~ enabledeskew)));
	and(wire_n1ll_dataout, nl01O, (~ enabledeskew));
	and(wire_n1lO_dataout, nl00i, (~ enabledeskew));
	assign		wire_n1O_dataout = (n0i1i === 1'b1) ? n0Ol : n0OO;
	and(wire_n1Oi_dataout, nl00l, (~ enabledeskew));
	and(wire_n1Ol_dataout, nl00O, (~ enabledeskew));
	and(wire_n1OO_dataout, nl0ii, (~ enabledeskew));
	assign		wire_ni_dataout = (n0i1i === 1'b1) ? niiO : nill;
	and(wire_ni0Ol_dataout, wire_nii1O_dataout, ~((~ ni0ii)));
	and(wire_ni0OO_dataout, wire_nii0i_dataout, ~((~ ni0ii)));
	assign		wire_nii_dataout = (n0i1i === 1'b1) ? ni1O : ni0i;
	and(wire_nii0i_dataout, wire_niiil_dataout, ~(wr_align));
	and(wire_nii0l_dataout, wire_niiiO_dataout, ~(wr_align));
	or(wire_nii0O_dataout, wire_niili_dataout, wr_align);
	and(wire_nii1i_dataout, wire_nii0l_dataout, ~((~ ni0ii)));
	and(wire_nii1l_dataout, wire_nii0O_dataout, ~((~ ni0ii)));
	or(wire_nii1O_dataout, wire_niiii_dataout, wr_align);
	assign		wire_niiii_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[1] : ni0iO;
	assign		wire_niiil_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[2] : ni0li;
	assign		wire_niiiO_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[3] : ni0ll;
	assign		wire_niili_dataout = ((~ n00iO) === 1'b1) ? wire_niilO_o[4] : ni0lO;
	or(wire_niiOl_dataout, wire_niiOO_dataout, wr_align);
	and(wire_niiOO_dataout, ni0Oi, ~(n00iO));
	assign		wire_nil_dataout = (n0i1i === 1'b1) ? ni0i : ni0l;
	and(wire_nil1l_dataout, wire_nil1O_dataout, ~(n0i0i));
	or(wire_nil1O_dataout, niiOi, wr_align);
	or(wire_nilO_dataout, wire_nlOi_dataout, n0i0i);
	assign		wire_niO_dataout = (n0i1i === 1'b1) ? ni0l : ni0O;
	and(wire_niOi_dataout, wire_nlOl_dataout, ~(n0i0i));
	and(wire_niOl_dataout, wire_nlOO_dataout, ~(n0i0i));
	and(wire_niOO_dataout, wire_n1i_dataout, ~(n0i0i));
	and(wire_nl0i_dataout, wire_n0l_dataout, ~(n0i0i));
	and(wire_nl0l_dataout, wire_n0O_dataout, ~(n0i0i));
	and(wire_nl0O_dataout, wire_nii_dataout, ~(n0i0i));
	and(wire_nl1i_dataout, wire_n1l_dataout, ~(n0i0i));
	and(wire_nl1l_dataout, wire_n1O_dataout, ~(n0i0i));
	and(wire_nl1O_dataout, wire_n0i_dataout, ~(n0i0i));
	assign		wire_nli_dataout = (n0i1i === 1'b1) ? ni0O : niii;
	and(wire_nlii_dataout, wire_nil_dataout, ~(n0i0i));
	and(wire_nliii_dataout, wire_nlOiO_dataout, ~(fiforesetrd));
	or(wire_nliil_dataout, wire_nlOli_dataout, fiforesetrd);
	and(wire_nliiO_dataout, wire_nlOll_dataout, ~(fiforesetrd));
	and(wire_nlil_dataout, wire_niO_dataout, ~(n0i0i));
	and(wire_nlili_dataout, wire_nlOlO_dataout, ~(fiforesetrd));
	and(wire_nlill_dataout, wire_nlOOi_dataout, ~(fiforesetrd));
	and(wire_nlilO_dataout, wire_nlOOl_dataout, ~(fiforesetrd));
	and(wire_nliO_dataout, wire_nli_dataout, ~(n0i0i));
	and(wire_nliOi_dataout, wire_nlOOO_dataout, ~(fiforesetrd));
	and(wire_nliOl_dataout, wire_n11i_dataout, ~(fiforesetrd));
	and(wire_nliOO_dataout, wire_n11l_dataout, ~(fiforesetrd));
	assign		wire_nll_dataout = (n0i1i === 1'b1) ? niii : niil;
	and(wire_nll0i_dataout, wire_n10O_dataout, ~(fiforesetrd));
	and(wire_nll0l_dataout, wire_n1ii_dataout, ~(fiforesetrd));
	and(wire_nll0O_dataout, wire_n1il_dataout, ~(fiforesetrd));
	and(wire_nll1i_dataout, wire_n11O_dataout, ~(fiforesetrd));
	and(wire_nll1l_dataout, wire_n10i_dataout, ~(fiforesetrd));
	and(wire_nll1O_dataout, wire_n10l_dataout, ~(fiforesetrd));
	and(wire_nlli_dataout, wire_nll_dataout, ~(n0i0i));
	and(wire_nllii_dataout, wire_n1iO_dataout, ~(fiforesetrd));
	or(wire_nllil_dataout, wire_n1li_dataout, fiforesetrd);
	and(wire_nlliO_dataout, wire_n1ll_dataout, ~(fiforesetrd));
	and(wire_nlll_dataout, wire_nlO_dataout, ~(n0i0i));
	and(wire_nllli_dataout, wire_n1lO_dataout, ~(fiforesetrd));
	and(wire_nllll_dataout, wire_n1Oi_dataout, ~(fiforesetrd));
	and(wire_nlllO_dataout, wire_n1Ol_dataout, ~(fiforesetrd));
	and(wire_nllO_dataout, wire_ni_dataout, ~(n0i0i));
	and(wire_nllOi_dataout, wire_n1OO_dataout, ~(fiforesetrd));
	and(wire_nllOl_dataout, wire_n01i_dataout, ~(fiforesetrd));
	and(wire_nllOO_dataout, wire_n01l_dataout, ~(fiforesetrd));
	assign		wire_nlO_dataout = (n0i1i === 1'b1) ? niil : niiO;
	and(wire_nlO0i_dataout, wire_n00O_dataout, ~(fiforesetrd));
	and(wire_nlO0l_dataout, wire_n0ii_dataout, ~(fiforesetrd));
	and(wire_nlO0O_dataout, wire_n0il_dataout, ~(fiforesetrd));
	and(wire_nlO1i_dataout, wire_n01O_dataout, ~(fiforesetrd));
	and(wire_nlO1l_dataout, wire_n00i_dataout, ~(fiforesetrd));
	and(wire_nlO1O_dataout, wire_n00l_dataout, ~(fiforesetrd));
	assign		wire_nlOi_dataout = (n0i1i === 1'b1) ? nill : nli0O;
	and(wire_nlOii_dataout, wire_n0iO_dataout, ~(fiforesetrd));
	and(wire_nlOil_dataout, wire_n0li_dataout, ~(fiforesetrd));
	and(wire_nlOiO_dataout, nl01i, (~ enabledeskew));
	assign		wire_nlOl_dataout = (n0i1i === 1'b1) ? nli0O : n0ll;
	or(wire_nlOli_dataout, nl11i, ~((~ enabledeskew)));
	and(wire_nlOll_dataout, nl11l, (~ enabledeskew));
	and(wire_nlOlO_dataout, nl11O, (~ enabledeskew));
	assign		wire_nlOO_dataout = (n0i1i === 1'b1) ? n0ll : n0lO;
	and(wire_nlOOi_dataout, nl10i, (~ enabledeskew));
	and(wire_nlOOl_dataout, nl10l, (~ enabledeskew));
	and(wire_nlOOO_dataout, nl10O, (~ enabledeskew));
	oper_add   niilO
	( 
	.a({ni0lO, ni0ll, ni0li, ni0iO, 1'b1}),
	.b({{3{1'b1}}, 1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_niilO_o));
	defparam
		niilO.sgate_representation = 0,
		niilO.width_a = 5,
		niilO.width_b = 5,
		niilO.width_o = 5;
	assign
		adetectdeskew = niill,
		dataout = {niOOO, niOOl, niOOi, niOlO, niOll, niOli, niOiO, niOil, niOii, niO0O},
		dataoutpre = {niO1l, niO1i, nilOO, nilOl, nilOi, nillO, nilll, nilli, niliO, nilil},
		disperr = niO1O,
		disperrpre = nil0l,
		errdetect = niO0l,
		errdetectpre = nilii,
		n00iO = ((((~ ni0lO) & (~ ni0ll)) & (~ ni0li)) & (~ ni0iO)),
		n00Ol = 1'b1,
		n0i0i = ((ni0ii & ((nill & niiOi) & (n0iii2 ^ n0iii1))) | ((ni0ii & (~ ni00O)) & (n0i0l4 ^ n0i0l3))),
		n0i1i = ((niiOi | wr_align) | (~ (n0i1l6 ^ n0i1l5))),
		patterndetect = nil0i,
		patterndetectpre = nil1i,
		syncstatus = niO0i,
		syncstatuspre = nil0O;
endmodule //stratixgx_deskew_fifo_rtl
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXGX_DESKEW_FIFO
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

   module stratixgx_deskew_fifo
      (
       datain,
       errdetectin,
       syncstatusin,
       disperrin,   
       patterndetectin,   
       writeclock,  
       readclock,   
       adetectdeskew,
       fiforesetrd,
       enabledeskew,
       reset,
       dataout,      
       dataoutpre,      
       errdetect,    
       syncstatus,   
       disperr,
       patterndetect,
       errdetectpre,    
       syncstatuspre,
       disperrpre,
       patterndetectpre,
       rdalign
       );

   input [9:0] datain;        // encoded word
   input       errdetectin;   // From word aligner (if invalid_code)
   input       syncstatusin;  // From word aligner (not used)
   input       disperrin;     // From word aligner (not used)
   input       patterndetectin;
   input       writeclock;    // From recovered clock 
   input       readclock;     // From master clock
   input       fiforesetrd;   // reset read ptr 
   input       enabledeskew;  // enable the deskw fifo      
   input       reset;
   output [9:0] dataout;      // aligned data
   output [9:0] dataoutpre;   // aligned data
   output errdetect;          // straight output from invalid_code_in and synchronized with output
   output syncstatus;         // straight output from syncstatusin and synchronized with output
   output disperr;            // straight output from disperrin and synchronized with output
   output patterndetect;      // from word align 
   output errdetectpre;       // straight output from invalid_code_in and synchronized with output
   output syncstatuspre;      // straight output from syncstatusin and synchronized with output
   output disperrpre;         // straight output from disperrin and synchronized with output
   output patterndetectpre;   // from word align WARNING: CRITICAL TO ADD FUNCT
   output adetectdeskew;      // |A| is detected. It goes to input port adet of XGM_ATOM
   output rdalign;            // <deskew state machine |A| detect after read>
   
   parameter a = 10'b0011000011; //10'b0011110011;  - K28.3

   wire wr_align;
   wire wr_align_tmp;
   wire rdalign;
   wire rdalign_tmp;

   reg  enabledeskew_dly0;
   reg  enabledeskew_dly1;


   assign rdalign_tmp = ((dataout[9:0] == a) || (dataout[9:0] == ~a)) && ~disperr && ~errdetect;
   assign wr_align_tmp = ((datain[9:0] == a) || (datain[9:0] == ~a)) && enabledeskew_dly1 && ~disperrin && ~errdetectin;

   // filtering X
   assign wr_align = (wr_align_tmp === 1'b1) ? 1'b1 : 1'b0;
   assign rdalign = (rdalign_tmp === 1'b1) ? 1'b1 : 1'b0;

   
   // ENABLE DESKEW DELAY LOGIC - enable delay chain
   always@(posedge writeclock or posedge reset)
   begin
     if(reset)
        begin
           enabledeskew_dly0 <= 1'b1;
           enabledeskew_dly1 <= 1'b1;
        end 
     else
        begin
           enabledeskew_dly0 <= enabledeskew;
           enabledeskew_dly1 <= enabledeskew_dly0;
        end
   end 
   

   // instantiate core
   stratixgx_deskew_fifo_rtl m_dskw_fifo_rtl
   (
       .wr_align(wr_align),
       .datain(datain),
       .errdetectin(errdetectin),
       .syncstatusin(syncstatusin),
       .disperrin(disperrin),   
       .patterndetectin(patterndetectin),   
       .writeclock(writeclock),  
       .readclock(readclock),   
       .fiforesetrd(fiforesetrd),
       .enabledeskew(enabledeskew),
       .reset(reset),
       .adetectdeskew(adetectdeskew),
       .dataout(dataout),      
       .dataoutpre(dataoutpre),      
       .errdetect(errdetect),    
       .syncstatus(syncstatus),   
       .disperr(disperr),
       .patterndetect(patterndetect),
       .errdetectpre(errdetectpre),    
       .syncstatuspre(syncstatuspre),
       .disperrpre(disperrpre),
       .patterndetectpre(patterndetectpre)
   );
      
endmodule

//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 283 mux21 302 oper_add 5 oper_less_than 1 oper_mux 18 oper_selector 42 
`timescale 1 ps / 1 ps
module  stratixgx_hssi_rx_wal_rtl
	( 
	A1A2_SIZE,
	AUTOBYTEALIGN_DIS,
	BITSLIP,
	cg_comma,
	DISABLE_RX_DISP,
	DWIDTH,
	encdet_prbs,
	ENCDT,
	GE_XAUI_SEL,
	IB_INVALID_CODE,
	LP10BEN,
	PMADATAWIDTH,
	prbs_en,
	PUDI,
	PUDR,
	rcvd_clk,
	RLV,
	RLV_EN,
	RLV_lt,
	RUNDISP_SEL,
	signal_detect,
	signal_detect_sync,
	soft_reset,
	SUDI,
	SUDI_pre,
	SYNC_COMP_PAT,
	SYNC_COMP_SIZE,
	sync_curr_st,
	SYNC_SM_DIS,
	sync_status) /* synthesis synthesis_clearbox=1 */;
	input   A1A2_SIZE;
	input   AUTOBYTEALIGN_DIS;
	input   BITSLIP;
	output   cg_comma;
	input   DISABLE_RX_DISP;
	input   DWIDTH;
	input   encdet_prbs;
	input   ENCDT;
	input   GE_XAUI_SEL;
	input   [1:0]  IB_INVALID_CODE;
	input   LP10BEN;
	input   PMADATAWIDTH;
	input   prbs_en;
	input   [9:0]  PUDI;
	input   [9:0]  PUDR;
	input   rcvd_clk;
	output   RLV;
	input   RLV_EN;
	output   RLV_lt;
	input   [4:0]  RUNDISP_SEL;
	input   signal_detect;
	output   signal_detect_sync;
	input   soft_reset;
	output   [12:0]  SUDI;
	output   [9:0]  SUDI_pre;
	input   [15:0]  SYNC_COMP_PAT;
	input   [1:0]  SYNC_COMP_SIZE;
	output   [3:0]  sync_curr_st;
	input   SYNC_SM_DIS;
	output   sync_status;

	reg	n1l0OO53;
	reg	n1l0OO54;
	reg	n1li0l49;
	reg	n1li0l50;
	reg	n1li1i51;
	reg	n1li1i52;
	reg	n1llOl47;
	reg	n1llOl48;
	reg	n1lO0l43;
	reg	n1lO0l44;
	reg	n1lO1i45;
	reg	n1lO1i46;
	reg	n1lOii41;
	reg	n1lOii42;
	reg	n1lOiO39;
	reg	n1lOiO40;
	reg	n1lOOi37;
	reg	n1lOOi38;
	reg	n1lOOO35;
	reg	n1lOOO36;
	reg	n1O00i17;
	reg	n1O00i18;
	reg	n1O00l15;
	reg	n1O00l16;
	reg	n1O01i23;
	reg	n1O01i24;
	reg	n1O01l21;
	reg	n1O01l22;
	reg	n1O01O19;
	reg	n1O01O20;
	reg	n1O0ii13;
	reg	n1O0ii14;
	reg	n1O0iO11;
	reg	n1O0iO12;
	reg	n1O10i33;
	reg	n1O10i34;
	reg	n1O10O31;
	reg	n1O10O32;
	reg	n1O1il29;
	reg	n1O1il30;
	reg	n1O1Ol27;
	reg	n1O1Ol28;
	reg	n1O1OO25;
	reg	n1O1OO26;
	reg	n1Oi0l7;
	reg	n1Oi0l8;
	reg	n1Oi0O5;
	reg	n1Oi0O6;
	reg	n1Oi1i10;
	reg	n1Oi1i9;
	reg	n1Oill3;
	reg	n1Oill4;
	reg	n1OiOi1;
	reg	n1OiOi2;
	reg	n10li;
	reg	n10lO;
	reg	n10Oi;
	reg	n10OO;
	reg	n10Ol_clk_prev;
	wire	wire_n10Ol_CLRN;
	wire	wire_n10Ol_PRN;
	reg	n1lOi;
	reg	n1lOl;
	reg	n1lOO;
	reg	n1O1l;
	wire	wire_n1O1i_CLRN;
	reg	n0001i;
	reg	n0010i;
	reg	n0010l;
	reg	n0010O;
	reg	n0011O;
	reg	n001ii;
	reg	n001il;
	reg	n001iO;
	reg	n001li;
	reg	n001ll;
	reg	n001lO;
	reg	n001Oi;
	reg	n001OO;
	reg	n0101l;
	reg	n1lli;
	reg	n1lll;
	reg	n1O1O;
	reg	n1Ol0i;
	reg	n1Ol0O;
	reg	n1Olli;
	reg	n1Olll;
	reg	ni0iOl;
	reg	ni0iOO;
	reg	ni0l0i;
	reg	ni0l0O;
	reg	ni0l1i;
	reg	ni0l1l;
	reg	ni0l1O;
	reg	ni0O0O;
	reg	ni0Oii;
	reg	ni0Oil;
	reg	ni0OiO;
	reg	ni0OOO;
	reg	ni1liO;
	reg	ni1lli;
	reg	ni1lll;
	reg	ni1llO;
	reg	ni1lOi;
	reg	ni1lOl;
	reg	ni1lOO;
	reg	ni1O1i;
	reg	ni1Oli;
	reg	nii11i;
	reg	nii11l;
	reg	nii11O;
	reg	niii0i;
	reg	niii0l;
	reg	niii0O;
	reg	niii1l;
	reg	niii1O;
	reg	niiiii;
	reg	niiiil;
	reg	niiiiO;
	reg	niiili;
	reg	niiill;
	reg	niiilO;
	reg	niiiOi;
	reg	niiiOl;
	reg	niiiOO;
	reg	niil1i;
	reg	niiO0i;
	reg	niiO0l;
	reg	niiO0O;
	reg	niiO1l;
	reg	niiO1O;
	reg	niiOii;
	reg	niiOil;
	reg	niiOiO;
	reg	niiOli;
	reg	niiOll;
	reg	niiOlO;
	reg	niiOOi;
	reg	niiOOl;
	reg	nil0i;
	reg	nil0l;
	reg	nil0O;
	reg	nilii;
	reg	nilil;
	reg	niliO;
	reg	nilli;
	reg	nilll;
	reg	nilOi;
	reg	nlll0l;
	reg	nlll0O;
	reg	nlllll;
	reg	nllllO;
	reg	nlllOi;
	reg	nlllOl;
	reg	nlllOO;
	reg	nllO0i;
	reg	nllO0l;
	reg	nllO0O;
	reg	nllO1i;
	reg	nllO1l;
	reg	nllO1O;
	reg	nllOii;
	reg	nllOil;
	reg	nllOiO;
	reg	nllOli;
	reg	nllOll;
	reg	nllOlO;
	reg	nllOOi;
	reg	nllOOl;
	reg	nllOOO;
	reg	nlO00i;
	reg	nlO00l;
	reg	nlO00O;
	reg	nlO01i;
	reg	nlO01l;
	reg	nlO01O;
	reg	nlO0ii;
	reg	nlO0il;
	reg	nlO0iO;
	reg	nlO0li;
	reg	nlO10i;
	reg	nlO10l;
	reg	nlO10O;
	reg	nlO11i;
	reg	nlO11l;
	reg	nlO11O;
	reg	nlO1ii;
	reg	nlO1il;
	reg	nlO1iO;
	reg	nlO1li;
	reg	nlO1ll;
	reg	nlO1lO;
	reg	nlO1Oi;
	reg	nlO1Ol;
	reg	nlO1OO;
	reg	nillO_clk_prev;
	wire	wire_nillO_PRN;
	reg	nilOl;
	reg	nilOO;
	reg	niO1i;
	reg	nl1ll;
	reg	nl1Oi;
	reg	nl1lO_clk_prev;
	wire	wire_nl1lO_PRN;
	reg	n0000i;
	reg	n0000l;
	reg	n0000O;
	reg	n0001O;
	reg	n00OlO;
	reg	n00OOi;
	reg	n00OOl;
	reg	n00OOO;
	reg	n0i0OO;
	reg	n0i10i;
	reg	n0i10l;
	reg	n0i10O;
	reg	n0i11i;
	reg	n0i11l;
	reg	n0i11O;
	reg	n0i1ii;
	reg	n0i1il;
	reg	n0i1iO;
	reg	n0i1li;
	reg	n0i1ll;
	reg	n0i1lO;
	reg	n0i1Oi;
	reg	n0ii0i;
	reg	n0ii0l;
	reg	n0ii0O;
	reg	n0ii1i;
	reg	n0ii1l;
	reg	n0ii1O;
	reg	n10ii;
	reg	n10il;
	reg	n10iO;
	reg	n110i;
	reg	n110l;
	reg	n110O;
	reg	n111l;
	reg	n111O;
	reg	n11ii;
	reg	n11il;
	reg	n11iO;
	reg	n11li;
	reg	n11ll;
	reg	n1i1i;
	reg	n1iOi;
	reg	n1iOO;
	reg	n1l0i;
	reg	n1l0l;
	reg	n1l1i;
	reg	n1l1l;
	reg	n1l1O;
	reg	n1llO;
	reg	niO0i;
	reg	niO0l;
	reg	niO0O;
	reg	niO1l;
	reg	niO1O;
	reg	niOii;
	reg	niOil;
	reg	niOiO;
	reg	niOli;
	reg	niOll;
	reg	niOlO;
	reg	niOOi;
	reg	niOOl;
	reg	niOOO;
	reg	nl10i;
	reg	nl10l;
	reg	nl10O;
	reg	nl11i;
	reg	nl11l;
	reg	nl11O;
	reg	nl1ii;
	reg	nl1il;
	reg	nl1iO;
	reg	nl1li;
	reg	nllil;
	reg	nllli;
	reg	nlO0ll;
	reg	n001Ol;
	reg	n1Ol0l;
	reg	ni0l0l;
	reg	nlllil;
	reg	n0001l;
	reg	n1l0O;
	reg	n1lii;
	reg	n1lil;
	reg	n1liO;
	reg	nlllO;
	reg	nllll_clk_prev;
	wire	wire_nllll_CLRN;
	wire	wire_nllll_PRN;
	wire	wire_n000O_dataout;
	wire	wire_n0011i_dataout;
	wire	wire_n001O_dataout;
	wire	wire_n00i0O_dataout;
	wire	wire_n00ill_dataout;
	wire	wire_n00iO_dataout;
	wire	wire_n00l0O_dataout;
	wire	wire_n00l1i_dataout;
	wire	wire_n00lll_dataout;
	wire	wire_n00lO_dataout;
	wire	wire_n00O0O_dataout;
	wire	wire_n00O1i_dataout;
	wire	wire_n00Oll_dataout;
	wire	wire_n00OO_dataout;
	wire	wire_n0100i_dataout;
	wire	wire_n0100l_dataout;
	wire	wire_n0101i_dataout;
	wire	wire_n0101O_dataout;
	wire	wire_n010i_dataout;
	wire	wire_n010ii_dataout;
	wire	wire_n010il_dataout;
	wire	wire_n010iO_dataout;
	wire	wire_n010l_dataout;
	wire	wire_n010li_dataout;
	wire	wire_n010ll_dataout;
	wire	wire_n010lO_dataout;
	wire	wire_n010O_dataout;
	wire	wire_n010Oi_dataout;
	wire	wire_n010Ol_dataout;
	wire	wire_n010OO_dataout;
	wire	wire_n011Oi_dataout;
	wire	wire_n011Ol_dataout;
	wire	wire_n011OO_dataout;
	wire	wire_n01i0i_dataout;
	wire	wire_n01i0l_dataout;
	wire	wire_n01i0O_dataout;
	wire	wire_n01i1i_dataout;
	wire	wire_n01ii_dataout;
	wire	wire_n01iii_dataout;
	wire	wire_n01iil_dataout;
	wire	wire_n01il_dataout;
	wire	wire_n01ili_dataout;
	wire	wire_n01ill_dataout;
	wire	wire_n01ilO_dataout;
	wire	wire_n01iOi_dataout;
	wire	wire_n01iOO_dataout;
	wire	wire_n01l0i_dataout;
	wire	wire_n01l1i_dataout;
	wire	wire_n01l1l_dataout;
	wire	wire_n01l1O_dataout;
	wire	wire_n01li_dataout;
	wire	wire_n01lO_dataout;
	wire	wire_n01lOi_dataout;
	wire	wire_n01lOl_dataout;
	wire	wire_n01lOO_dataout;
	wire	wire_n01O0l_dataout;
	wire	wire_n01O0O_dataout;
	wire	wire_n01O1i_dataout;
	wire	wire_n01O1l_dataout;
	wire	wire_n01Oii_dataout;
	wire	wire_n01Oil_dataout;
	wire	wire_n01OiO_dataout;
	wire	wire_n01Oli_dataout;
	wire	wire_n01Oll_dataout;
	wire	wire_n01OlO_dataout;
	wire	wire_n01OO_dataout;
	wire	wire_n01OOO_dataout;
	wire	wire_n0i0O_dataout;
	wire	wire_n0i1O_dataout;
	wire	wire_n0iii_dataout;
	wire	wire_n0iil_dataout;
	wire	wire_n0iiO_dataout;
	wire	wire_n0ili_dataout;
	wire	wire_n0ill_dataout;
	wire	wire_n0ilO_dataout;
	wire	wire_n0iOi_dataout;
	wire	wire_n0iOl_dataout;
	wire	wire_n0iOO_dataout;
	wire	wire_n0l0i_dataout;
	wire	wire_n0l0ii_dataout;
	wire	wire_n0l0l_dataout;
	wire	wire_n0l0O_dataout;
	wire	wire_n0l1i_dataout;
	wire	wire_n0l1l_dataout;
	wire	wire_n0l1O_dataout;
	wire	wire_n0lii_dataout;
	wire	wire_n0lil_dataout;
	wire	wire_n0liO_dataout;
	wire	wire_n0lli_dataout;
	wire	wire_n0lll_dataout;
	wire	wire_n0llO_dataout;
	wire	wire_n0lOi_dataout;
	wire	wire_n0lOl_dataout;
	wire	wire_n0lOO_dataout;
	wire	wire_n0O0i_dataout;
	wire	wire_n0O0l_dataout;
	wire	wire_n0O0O_dataout;
	wire	wire_n0O1i_dataout;
	wire	wire_n0O1l_dataout;
	wire	wire_n0O1O_dataout;
	wire	wire_n0Oii_dataout;
	wire	wire_n0Oil_dataout;
	wire	wire_n0OiO_dataout;
	wire	wire_n0Oli_dataout;
	wire	wire_n0Oll_dataout;
	wire	wire_n0OlO_dataout;
	wire	wire_n0OOi_dataout;
	wire	wire_n0OOl_dataout;
	wire	wire_n0OOlO_dataout;
	wire	wire_n0OOO_dataout;
	wire	wire_n1i0i_dataout;
	wire	wire_n1i0l_dataout;
	wire	wire_n1i0O_dataout;
	wire	wire_n1i1l_dataout;
	wire	wire_n1i1O_dataout;
	wire	wire_n1iii_dataout;
	wire	wire_n1iil_dataout;
	wire	wire_n1iiO_dataout;
	wire	wire_n1Olii_dataout;
	wire	wire_n1Olil_dataout;
	wire	wire_n1OliO_dataout;
	wire	wire_ni000i_dataout;
	wire	wire_ni000l_dataout;
	wire	wire_ni000O_dataout;
	wire	wire_ni001l_dataout;
	wire	wire_ni001O_dataout;
	wire	wire_ni00i_dataout;
	wire	wire_ni00ii_dataout;
	wire	wire_ni00il_dataout;
	wire	wire_ni00iO_dataout;
	wire	wire_ni00l_dataout;
	wire	wire_ni00li_dataout;
	wire	wire_ni00ll_dataout;
	wire	wire_ni00lO_dataout;
	wire	wire_ni00O_dataout;
	wire	wire_ni00OO_dataout;
	wire	wire_ni01i_dataout;
	wire	wire_ni01l_dataout;
	wire	wire_ni01lO_dataout;
	wire	wire_ni01O_dataout;
	wire	wire_ni0i0l_dataout;
	wire	wire_ni0i0O_dataout;
	wire	wire_ni0i1i_dataout;
	wire	wire_ni0i1l_dataout;
	wire	wire_ni0i1O_dataout;
	wire	wire_ni0ii_dataout;
	wire	wire_ni0iii_dataout;
	wire	wire_ni0iil_dataout;
	wire	wire_ni0iiO_dataout;
	wire	wire_ni0il_dataout;
	wire	wire_ni0ilO_dataout;
	wire	wire_ni0iO_dataout;
	wire	wire_ni0iOi_dataout;
	wire	wire_ni0li_dataout;
	wire	wire_ni0lii_dataout;
	wire	wire_ni0lil_dataout;
	wire	wire_ni0liO_dataout;
	wire	wire_ni0ll_dataout;
	wire	wire_ni0lli_dataout;
	wire	wire_ni0lll_dataout;
	wire	wire_ni0llO_dataout;
	wire	wire_ni0lO_dataout;
	wire	wire_ni0lOi_dataout;
	wire	wire_ni0lOl_dataout;
	wire	wire_ni0Oi_dataout;
	wire	wire_ni0Ol_dataout;
	wire	wire_ni0Oli_dataout;
	wire	wire_ni0Oll_dataout;
	wire	wire_ni0OlO_dataout;
	wire	wire_ni0OO_dataout;
	wire	wire_ni0OOi_dataout;
	wire	wire_ni10i_dataout;
	wire	wire_ni10l_dataout;
	wire	wire_ni10O_dataout;
	wire	wire_ni11i_dataout;
	wire	wire_ni11l_dataout;
	wire	wire_ni11O_dataout;
	wire	wire_ni1ii_dataout;
	wire	wire_ni1il_dataout;
	wire	wire_ni1iO_dataout;
	wire	wire_ni1li_dataout;
	wire	wire_ni1ll_dataout;
	wire	wire_ni1lO_dataout;
	wire	wire_ni1O0i_dataout;
	wire	wire_ni1O0l_dataout;
	wire	wire_ni1O1l_dataout;
	wire	wire_ni1O1O_dataout;
	wire	wire_ni1Oi_dataout;
	wire	wire_ni1Oil_dataout;
	wire	wire_ni1OiO_dataout;
	wire	wire_ni1Ol_dataout;
	wire	wire_ni1Oll_dataout;
	wire	wire_ni1OlO_dataout;
	wire	wire_ni1OO_dataout;
	wire	wire_nii0i_dataout;
	wire	wire_nii0l_dataout;
	wire	wire_nii0O_dataout;
	wire	wire_nii1i_dataout;
	wire	wire_nii1l_dataout;
	wire	wire_nii1O_dataout;
	wire	wire_niii1i_dataout;
	wire	wire_niiii_dataout;
	wire	wire_niiil_dataout;
	wire	wire_niiiO_dataout;
	wire	wire_niil0i_dataout;
	wire	wire_niil0l_dataout;
	wire	wire_niil0O_dataout;
	wire	wire_niil1l_dataout;
	wire	wire_niil1O_dataout;
	wire	wire_niili_dataout;
	wire	wire_niilii_dataout;
	wire	wire_niilil_dataout;
	wire	wire_niiliO_dataout;
	wire	wire_niill_dataout;
	wire	wire_niilli_dataout;
	wire	wire_niilll_dataout;
	wire	wire_niillO_dataout;
	wire	wire_niilO_dataout;
	wire	wire_niilOi_dataout;
	wire	wire_niilOl_dataout;
	wire	wire_niilOO_dataout;
	wire	wire_niiO1i_dataout;
	wire	wire_niiOi_dataout;
	wire	wire_niiOl_dataout;
	wire	wire_niiOO_dataout;
	wire	wire_niiOOO_dataout;
	wire	wire_nil10i_dataout;
	wire	wire_nil10l_dataout;
	wire	wire_nil10O_dataout;
	wire	wire_nil11i_dataout;
	wire	wire_nil11l_dataout;
	wire	wire_nil11O_dataout;
	wire	wire_nil1i_dataout;
	wire	wire_nil1ii_dataout;
	wire	wire_nil1il_dataout;
	wire	wire_nil1iO_dataout;
	wire	wire_nil1l_dataout;
	wire	wire_nil1li_dataout;
	wire	wire_nil1ll_dataout;
	wire	wire_nil1lO_dataout;
	wire	wire_nil1O_dataout;
	wire	wire_nil1Oi_dataout;
	wire	wire_nl00i_dataout;
	wire	wire_nl00l_dataout;
	wire	wire_nl00O_dataout;
	wire	wire_nl01i_dataout;
	wire	wire_nl01l_dataout;
	wire	wire_nl01O_dataout;
	wire	wire_nl0ii_dataout;
	wire	wire_nl0il_dataout;
	wire	wire_nl0iO_dataout;
	wire	wire_nl0li_dataout;
	wire	wire_nl0ll_dataout;
	wire	wire_nl0lO_dataout;
	wire	wire_nl0Oi_dataout;
	wire	wire_nl0Ol_dataout;
	wire	wire_nl0OO_dataout;
	wire	wire_nl1Ol_dataout;
	wire	wire_nl1OO_dataout;
	wire	wire_nli0i_dataout;
	wire	wire_nli0l_dataout;
	wire	wire_nli0O_dataout;
	wire	wire_nli1i_dataout;
	wire	wire_nli1l_dataout;
	wire	wire_nli1O_dataout;
	wire	wire_nliii_dataout;
	wire	wire_nliil_dataout;
	wire	wire_nliiO_dataout;
	wire	wire_nliOl_dataout;
	wire	wire_nliOO_dataout;
	wire	wire_nll0i_dataout;
	wire	wire_nll1i_dataout;
	wire	wire_nll1l_dataout;
	wire	wire_nll1O_dataout;
	wire	wire_nlOi0O_dataout;
	wire	wire_nlOiii_dataout;
	wire	wire_nlOiil_dataout;
	wire	wire_nlOiiO_dataout;
	wire	wire_nlOili_dataout;
	wire	wire_nlOill_dataout;
	wire	wire_nlOilO_dataout;
	wire	wire_nlOiOi_dataout;
	wire	wire_nlOiOl_dataout;
	wire	wire_nlOiOO_dataout;
	wire	wire_nlOl0i_dataout;
	wire	wire_nlOl0l_dataout;
	wire	wire_nlOl0O_dataout;
	wire	wire_nlOl1i_dataout;
	wire	wire_nlOl1l_dataout;
	wire	wire_nlOl1O_dataout;
	wire	wire_nlOlii_dataout;
	wire	wire_nlOlil_dataout;
	wire	wire_nlOliO_dataout;
	wire	wire_nlOlli_dataout;
	wire	wire_nlOlOO_dataout;
	wire	wire_nlOO0i_dataout;
	wire	wire_nlOO0l_dataout;
	wire	wire_nlOO0O_dataout;
	wire	wire_nlOO1i_dataout;
	wire	wire_nlOO1l_dataout;
	wire	wire_nlOO1O_dataout;
	wire	wire_nlOOii_dataout;
	wire  [1:0]   wire_n01iiO_o;
	wire  [4:0]   wire_n1ili_o;
	wire  [5:0]   wire_ni0lOO_o;
	wire  [3:0]   wire_ni1O0O_o;
	wire  [4:0]   wire_ni1Oii_o;
	wire  wire_ni0OOl_o;
	wire  wire_n00i0l_o;
	wire  wire_n00ili_o;
	wire  wire_n00iOO_o;
	wire  wire_n00l0l_o;
	wire  wire_n00lli_o;
	wire  wire_n00lOO_o;
	wire  wire_n00O0l_o;
	wire  wire_n00Oli_o;
	wire  wire_n100i_o;
	wire  wire_n100l_o;
	wire  wire_n100O_o;
	wire  wire_n101i_o;
	wire  wire_n101l_o;
	wire  wire_n101O_o;
	wire  wire_n11lO_o;
	wire  wire_n11Oi_o;
	wire  wire_n11Ol_o;
	wire  wire_n11OO_o;
	wire  wire_n0110i_o;
	wire  wire_n0110O_o;
	wire  wire_n0111l_o;
	wire  wire_n011il_o;
	wire  wire_n011li_o;
	wire  wire_n011lO_o;
	wire  wire_n1OllO_o;
	wire  wire_n1OlOi_o;
	wire  wire_n1OlOO_o;
	wire  wire_n1OO0i_o;
	wire  wire_n1OO0O_o;
	wire  wire_n1OO1l_o;
	wire  wire_n1OO1O_o;
	wire  wire_n1OOii_o;
	wire  wire_n1OOiO_o;
	wire  wire_n1OOll_o;
	wire  wire_n1OOOi_o;
	wire  wire_n1OOOO_o;
	wire  wire_ni010i_o;
	wire  wire_ni010l_o;
	wire  wire_ni010O_o;
	wire  wire_ni011i_o;
	wire  wire_ni011O_o;
	wire  wire_ni01iO_o;
	wire  wire_ni01ll_o;
	wire  wire_ni01Oi_o;
	wire  wire_ni01OO_o;
	wire  wire_ni1OOi_o;
	wire  wire_ni1OOl_o;
	wire  wire_ni1OOO_o;
	wire  wire_nlili_o;
	wire  wire_nlill_o;
	wire  wire_nlilO_o;
	wire  wire_nliOi_o;
	wire  wire_nlOOil_o;
	wire  wire_nlOOiO_o;
	wire  wire_nlOOli_o;
	wire  wire_nlOOll_o;
	wire  wire_nlOOlO_o;
	wire  wire_nlOOOi_o;
	wire  wire_nlOOOl_o;
	wire  wire_nlOOOO_o;
	wire  n1000i;
	wire  n1000l;
	wire  n1000O;
	wire  n1001i;
	wire  n1001l;
	wire  n1001O;
	wire  n100ii;
	wire  n100il;
	wire  n100iO;
	wire  n100li;
	wire  n100ll;
	wire  n100lO;
	wire  n100Oi;
	wire  n100Ol;
	wire  n100OO;
	wire  n1010i;
	wire  n1010l;
	wire  n1010O;
	wire  n1011i;
	wire  n1011l;
	wire  n1011O;
	wire  n101ii;
	wire  n101il;
	wire  n101iO;
	wire  n101li;
	wire  n101ll;
	wire  n101lO;
	wire  n101Oi;
	wire  n101Ol;
	wire  n101OO;
	wire  n10i0i;
	wire  n10i0l;
	wire  n10i0O;
	wire  n10i1i;
	wire  n10i1l;
	wire  n10i1O;
	wire  n10iii;
	wire  n10iil;
	wire  n10iiO;
	wire  n10ili;
	wire  n10ill;
	wire  n10ilO;
	wire  n10iOi;
	wire  n10iOl;
	wire  n10iOO;
	wire  n10l0i;
	wire  n10l0l;
	wire  n10l0O;
	wire  n10l1i;
	wire  n10l1l;
	wire  n10l1O;
	wire  n10lii;
	wire  n10lil;
	wire  n10liO;
	wire  n10lli;
	wire  n10lll;
	wire  n10llO;
	wire  n10lOi;
	wire  n10lOl;
	wire  n10lOO;
	wire  n10O0i;
	wire  n10O0l;
	wire  n10O0O;
	wire  n10O1i;
	wire  n10O1l;
	wire  n10O1O;
	wire  n10Oii;
	wire  n10Oil;
	wire  n10OiO;
	wire  n10Oli;
	wire  n10Oll;
	wire  n10OlO;
	wire  n10OOi;
	wire  n10OOl;
	wire  n10OOO;
	wire  n11lii;
	wire  n11lil;
	wire  n11liO;
	wire  n11lli;
	wire  n11lll;
	wire  n11llO;
	wire  n11lOi;
	wire  n11lOl;
	wire  n11lOO;
	wire  n11O0i;
	wire  n11O0l;
	wire  n11O0O;
	wire  n11O1i;
	wire  n11O1l;
	wire  n11O1O;
	wire  n11Oii;
	wire  n11Oil;
	wire  n11OiO;
	wire  n11Oli;
	wire  n11Oll;
	wire  n11OlO;
	wire  n11OOi;
	wire  n11OOl;
	wire  n11OOO;
	wire  n1i00i;
	wire  n1i00l;
	wire  n1i00O;
	wire  n1i01i;
	wire  n1i01l;
	wire  n1i01O;
	wire  n1i0ii;
	wire  n1i0il;
	wire  n1i0iO;
	wire  n1i0li;
	wire  n1i0ll;
	wire  n1i0lO;
	wire  n1i0Oi;
	wire  n1i0Ol;
	wire  n1i0OO;
	wire  n1i10i;
	wire  n1i10l;
	wire  n1i10O;
	wire  n1i11i;
	wire  n1i11l;
	wire  n1i11O;
	wire  n1i1ii;
	wire  n1i1il;
	wire  n1i1iO;
	wire  n1i1li;
	wire  n1i1ll;
	wire  n1i1lO;
	wire  n1i1Oi;
	wire  n1i1Ol;
	wire  n1i1OO;
	wire  n1ii0i;
	wire  n1ii0l;
	wire  n1ii0O;
	wire  n1ii1i;
	wire  n1ii1l;
	wire  n1ii1O;
	wire  n1iiii;
	wire  n1iiil;
	wire  n1iiiO;
	wire  n1iili;
	wire  n1iill;
	wire  n1iilO;
	wire  n1iiOi;
	wire  n1iiOl;
	wire  n1iiOO;
	wire  n1il0i;
	wire  n1il0l;
	wire  n1il0O;
	wire  n1il1i;
	wire  n1il1l;
	wire  n1il1O;
	wire  n1ilii;
	wire  n1ilil;
	wire  n1iliO;
	wire  n1illi;
	wire  n1illl;
	wire  n1illO;
	wire  n1ilOi;
	wire  n1ilOl;
	wire  n1ilOO;
	wire  n1iO0i;
	wire  n1iO0l;
	wire  n1iO0O;
	wire  n1iO1i;
	wire  n1iO1l;
	wire  n1iO1O;
	wire  n1iOii;
	wire  n1iOil;
	wire  n1iOiO;
	wire  n1iOli;
	wire  n1iOll;
	wire  n1iOlO;
	wire  n1iOOi;
	wire  n1iOOl;
	wire  n1iOOO;
	wire  n1l00i;
	wire  n1l00l;
	wire  n1l00O;
	wire  n1l01i;
	wire  n1l01l;
	wire  n1l01O;
	wire  n1l0ii;
	wire  n1l0il;
	wire  n1l0iO;
	wire  n1l0li;
	wire  n1l0ll;
	wire  n1l0lO;
	wire  n1l0Oi;
	wire  n1l0Ol;
	wire  n1l10i;
	wire  n1l10l;
	wire  n1l10O;
	wire  n1l11i;
	wire  n1l11l;
	wire  n1l11O;
	wire  n1l1ii;
	wire  n1l1il;
	wire  n1l1iO;
	wire  n1l1li;
	wire  n1l1ll;
	wire  n1l1lO;
	wire  n1l1Oi;
	wire  n1l1Ol;
	wire  n1l1OO;
	wire  n1li0i;
	wire  n1li0O;
	wire  n1li1l;
	wire  n1li1O;
	wire  n1liii;
	wire  n1liil;
	wire  n1liiO;
	wire  n1lili;
	wire  n1lill;
	wire  n1lilO;
	wire  n1liOi;
	wire  n1liOl;
	wire  n1liOO;
	wire  n1ll0i;
	wire  n1ll0l;
	wire  n1ll0O;
	wire  n1ll1i;
	wire  n1ll1l;
	wire  n1ll1O;
	wire  n1llii;
	wire  n1llil;
	wire  n1lliO;
	wire  n1llli;
	wire  n1llll;
	wire  n1lllO;
	wire  n1llOi;
	wire  n1lO0i;
	wire  n1lO1O;
	wire  n1lOll;
	wire  n1lOlO;
	wire  n1O00O;
	wire  n1O0ll;
	wire  n1O0lO;
	wire  n1O0Oi;
	wire  n1O0Ol;
	wire  n1O0OO;
	wire  n1O11l;
	wire  n1O11O;
	wire  n1O1li;
	wire  n1O1ll;
	wire  n1O1lO;
	wire  n1O1Oi;
	wire  n1Oi0i;
	wire  n1Oi1O;
	wire  n1Oiii;
	wire  n1Oiil;
	wire  n1OiiO;
	wire  n1Oili;
	wire  n1Ol1l;

	initial
		n1l0OO53 = 0;
	always @ ( posedge rcvd_clk)
		  n1l0OO53 <= n1l0OO54;
	event n1l0OO53_event;
	initial
		#1 ->n1l0OO53_event;
	always @(n1l0OO53_event)
		n1l0OO53 <= {1{1'b1}};
	initial
		n1l0OO54 = 0;
	always @ ( posedge rcvd_clk)
		  n1l0OO54 <= n1l0OO53;
	initial
		n1li0l49 = 0;
	always @ ( posedge rcvd_clk)
		  n1li0l49 <= n1li0l50;
	event n1li0l49_event;
	initial
		#1 ->n1li0l49_event;
	always @(n1li0l49_event)
		n1li0l49 <= {1{1'b1}};
	initial
		n1li0l50 = 0;
	always @ ( posedge rcvd_clk)
		  n1li0l50 <= n1li0l49;
	initial
		n1li1i51 = 0;
	always @ ( posedge rcvd_clk)
		  n1li1i51 <= n1li1i52;
	event n1li1i51_event;
	initial
		#1 ->n1li1i51_event;
	always @(n1li1i51_event)
		n1li1i51 <= {1{1'b1}};
	initial
		n1li1i52 = 0;
	always @ ( posedge rcvd_clk)
		  n1li1i52 <= n1li1i51;
	initial
		n1llOl47 = 0;
	always @ ( posedge rcvd_clk)
		  n1llOl47 <= n1llOl48;
	event n1llOl47_event;
	initial
		#1 ->n1llOl47_event;
	always @(n1llOl47_event)
		n1llOl47 <= {1{1'b1}};
	initial
		n1llOl48 = 0;
	always @ ( posedge rcvd_clk)
		  n1llOl48 <= n1llOl47;
	initial
		n1lO0l43 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO0l43 <= n1lO0l44;
	event n1lO0l43_event;
	initial
		#1 ->n1lO0l43_event;
	always @(n1lO0l43_event)
		n1lO0l43 <= {1{1'b1}};
	initial
		n1lO0l44 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO0l44 <= n1lO0l43;
	initial
		n1lO1i45 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO1i45 <= n1lO1i46;
	event n1lO1i45_event;
	initial
		#1 ->n1lO1i45_event;
	always @(n1lO1i45_event)
		n1lO1i45 <= {1{1'b1}};
	initial
		n1lO1i46 = 0;
	always @ ( posedge rcvd_clk)
		  n1lO1i46 <= n1lO1i45;
	initial
		n1lOii41 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOii41 <= n1lOii42;
	event n1lOii41_event;
	initial
		#1 ->n1lOii41_event;
	always @(n1lOii41_event)
		n1lOii41 <= {1{1'b1}};
	initial
		n1lOii42 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOii42 <= n1lOii41;
	initial
		n1lOiO39 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOiO39 <= n1lOiO40;
	event n1lOiO39_event;
	initial
		#1 ->n1lOiO39_event;
	always @(n1lOiO39_event)
		n1lOiO39 <= {1{1'b1}};
	initial
		n1lOiO40 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOiO40 <= n1lOiO39;
	initial
		n1lOOi37 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOi37 <= n1lOOi38;
	event n1lOOi37_event;
	initial
		#1 ->n1lOOi37_event;
	always @(n1lOOi37_event)
		n1lOOi37 <= {1{1'b1}};
	initial
		n1lOOi38 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOi38 <= n1lOOi37;
	initial
		n1lOOO35 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOO35 <= n1lOOO36;
	event n1lOOO35_event;
	initial
		#1 ->n1lOOO35_event;
	always @(n1lOOO35_event)
		n1lOOO35 <= {1{1'b1}};
	initial
		n1lOOO36 = 0;
	always @ ( posedge rcvd_clk)
		  n1lOOO36 <= n1lOOO35;
	initial
		n1O00i17 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00i17 <= n1O00i18;
	event n1O00i17_event;
	initial
		#1 ->n1O00i17_event;
	always @(n1O00i17_event)
		n1O00i17 <= {1{1'b1}};
	initial
		n1O00i18 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00i18 <= n1O00i17;
	initial
		n1O00l15 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00l15 <= n1O00l16;
	event n1O00l15_event;
	initial
		#1 ->n1O00l15_event;
	always @(n1O00l15_event)
		n1O00l15 <= {1{1'b1}};
	initial
		n1O00l16 = 0;
	always @ ( posedge rcvd_clk)
		  n1O00l16 <= n1O00l15;
	initial
		n1O01i23 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01i23 <= n1O01i24;
	event n1O01i23_event;
	initial
		#1 ->n1O01i23_event;
	always @(n1O01i23_event)
		n1O01i23 <= {1{1'b1}};
	initial
		n1O01i24 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01i24 <= n1O01i23;
	initial
		n1O01l21 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01l21 <= n1O01l22;
	event n1O01l21_event;
	initial
		#1 ->n1O01l21_event;
	always @(n1O01l21_event)
		n1O01l21 <= {1{1'b1}};
	initial
		n1O01l22 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01l22 <= n1O01l21;
	initial
		n1O01O19 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01O19 <= n1O01O20;
	event n1O01O19_event;
	initial
		#1 ->n1O01O19_event;
	always @(n1O01O19_event)
		n1O01O19 <= {1{1'b1}};
	initial
		n1O01O20 = 0;
	always @ ( posedge rcvd_clk)
		  n1O01O20 <= n1O01O19;
	initial
		n1O0ii13 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0ii13 <= n1O0ii14;
	event n1O0ii13_event;
	initial
		#1 ->n1O0ii13_event;
	always @(n1O0ii13_event)
		n1O0ii13 <= {1{1'b1}};
	initial
		n1O0ii14 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0ii14 <= n1O0ii13;
	initial
		n1O0iO11 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0iO11 <= n1O0iO12;
	event n1O0iO11_event;
	initial
		#1 ->n1O0iO11_event;
	always @(n1O0iO11_event)
		n1O0iO11 <= {1{1'b1}};
	initial
		n1O0iO12 = 0;
	always @ ( posedge rcvd_clk)
		  n1O0iO12 <= n1O0iO11;
	initial
		n1O10i33 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10i33 <= n1O10i34;
	event n1O10i33_event;
	initial
		#1 ->n1O10i33_event;
	always @(n1O10i33_event)
		n1O10i33 <= {1{1'b1}};
	initial
		n1O10i34 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10i34 <= n1O10i33;
	initial
		n1O10O31 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10O31 <= n1O10O32;
	event n1O10O31_event;
	initial
		#1 ->n1O10O31_event;
	always @(n1O10O31_event)
		n1O10O31 <= {1{1'b1}};
	initial
		n1O10O32 = 0;
	always @ ( posedge rcvd_clk)
		  n1O10O32 <= n1O10O31;
	initial
		n1O1il29 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1il29 <= n1O1il30;
	event n1O1il29_event;
	initial
		#1 ->n1O1il29_event;
	always @(n1O1il29_event)
		n1O1il29 <= {1{1'b1}};
	initial
		n1O1il30 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1il30 <= n1O1il29;
	initial
		n1O1Ol27 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1Ol27 <= n1O1Ol28;
	event n1O1Ol27_event;
	initial
		#1 ->n1O1Ol27_event;
	always @(n1O1Ol27_event)
		n1O1Ol27 <= {1{1'b1}};
	initial
		n1O1Ol28 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1Ol28 <= n1O1Ol27;
	initial
		n1O1OO25 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1OO25 <= n1O1OO26;
	event n1O1OO25_event;
	initial
		#1 ->n1O1OO25_event;
	always @(n1O1OO25_event)
		n1O1OO25 <= {1{1'b1}};
	initial
		n1O1OO26 = 0;
	always @ ( posedge rcvd_clk)
		  n1O1OO26 <= n1O1OO25;
	initial
		n1Oi0l7 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0l7 <= n1Oi0l8;
	event n1Oi0l7_event;
	initial
		#1 ->n1Oi0l7_event;
	always @(n1Oi0l7_event)
		n1Oi0l7 <= {1{1'b1}};
	initial
		n1Oi0l8 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0l8 <= n1Oi0l7;
	initial
		n1Oi0O5 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0O5 <= n1Oi0O6;
	event n1Oi0O5_event;
	initial
		#1 ->n1Oi0O5_event;
	always @(n1Oi0O5_event)
		n1Oi0O5 <= {1{1'b1}};
	initial
		n1Oi0O6 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi0O6 <= n1Oi0O5;
	initial
		n1Oi1i10 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi1i10 <= n1Oi1i9;
	initial
		n1Oi1i9 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oi1i9 <= n1Oi1i10;
	event n1Oi1i9_event;
	initial
		#1 ->n1Oi1i9_event;
	always @(n1Oi1i9_event)
		n1Oi1i9 <= {1{1'b1}};
	initial
		n1Oill3 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oill3 <= n1Oill4;
	event n1Oill3_event;
	initial
		#1 ->n1Oill3_event;
	always @(n1Oill3_event)
		n1Oill3 <= {1{1'b1}};
	initial
		n1Oill4 = 0;
	always @ ( posedge rcvd_clk)
		  n1Oill4 <= n1Oill3;
	initial
		n1OiOi1 = 0;
	always @ ( posedge rcvd_clk)
		  n1OiOi1 <= n1OiOi2;
	event n1OiOi1_event;
	initial
		#1 ->n1OiOi1_event;
	always @(n1OiOi1_event)
		n1OiOi1 <= {1{1'b1}};
	initial
		n1OiOi2 = 0;
	always @ ( posedge rcvd_clk)
		  n1OiOi2 <= n1OiOi1;
	initial
	begin
		n10li = 0;
		n10lO = 0;
		n10Oi = 0;
		n10OO = 0;
	end
	always @ (rcvd_clk or wire_n10Ol_PRN or wire_n10Ol_CLRN)
	begin
		if (wire_n10Ol_PRN == 1'b0) 
		begin
			n10li <= 1;
			n10lO <= 1;
			n10Oi <= 1;
			n10OO <= 1;
		end
		else if  (wire_n10Ol_CLRN == 1'b0) 
		begin
			n10li <= 0;
			n10lO <= 0;
			n10Oi <= 0;
			n10OO <= 0;
		end
		else if  (n11ll == 1'b1) 
		if (rcvd_clk != n10Ol_clk_prev && rcvd_clk == 1'b0) 
		begin
			n10li <= wire_n1i1l_dataout;
			n10lO <= wire_n1i1O_dataout;
			n10Oi <= wire_n1i0i_dataout;
			n10OO <= wire_n1i0l_dataout;
		end
		n10Ol_clk_prev <= rcvd_clk;
	end
	assign
		wire_n10Ol_CLRN = ((n1li1i52 ^ n1li1i51) & (~ soft_reset)),
		wire_n10Ol_PRN = (n1l0OO54 ^ n1l0OO53);
	initial
	begin
		n1lOi = 0;
		n1lOl = 0;
		n1lOO = 0;
		n1O1l = 0;
	end
	always @ ( negedge rcvd_clk or  negedge wire_n1O1i_CLRN)
	begin
		if (wire_n1O1i_CLRN == 1'b0) 
		begin
			n1lOi <= 0;
			n1lOl <= 0;
			n1lOO <= 0;
			n1O1l <= 0;
		end
		else if  (n1li0O == 1'b1) 
		begin
			n1lOi <= (~ n1O0ll);
			n1lOl <= n1O0lO;
			n1lOO <= n1O0Oi;
			n1O1l <= n1O0Ol;
		end
	end
	assign
		wire_n1O1i_CLRN = ((n1li0l50 ^ n1li0l49) & (~ soft_reset));
	initial
	begin
		n0001i = 0;
		n0010i = 0;
		n0010l = 0;
		n0010O = 0;
		n0011O = 0;
		n001ii = 0;
		n001il = 0;
		n001iO = 0;
		n001li = 0;
		n001ll = 0;
		n001lO = 0;
		n001Oi = 0;
		n001OO = 0;
		n0101l = 0;
		n1lli = 0;
		n1lll = 0;
		n1O1O = 0;
		n1Ol0i = 0;
		n1Ol0O = 0;
		n1Olli = 0;
		n1Olll = 0;
		ni0iOl = 0;
		ni0iOO = 0;
		ni0l0i = 0;
		ni0l0O = 0;
		ni0l1i = 0;
		ni0l1l = 0;
		ni0l1O = 0;
		ni0O0O = 0;
		ni0Oii = 0;
		ni0Oil = 0;
		ni0OiO = 0;
		ni0OOO = 0;
		ni1liO = 0;
		ni1lli = 0;
		ni1lll = 0;
		ni1llO = 0;
		ni1lOi = 0;
		ni1lOl = 0;
		ni1lOO = 0;
		ni1O1i = 0;
		ni1Oli = 0;
		nii11i = 0;
		nii11l = 0;
		nii11O = 0;
		niii0i = 0;
		niii0l = 0;
		niii0O = 0;
		niii1l = 0;
		niii1O = 0;
		niiiii = 0;
		niiiil = 0;
		niiiiO = 0;
		niiili = 0;
		niiill = 0;
		niiilO = 0;
		niiiOi = 0;
		niiiOl = 0;
		niiiOO = 0;
		niil1i = 0;
		niiO0i = 0;
		niiO0l = 0;
		niiO0O = 0;
		niiO1l = 0;
		niiO1O = 0;
		niiOii = 0;
		niiOil = 0;
		niiOiO = 0;
		niiOli = 0;
		niiOll = 0;
		niiOlO = 0;
		niiOOi = 0;
		niiOOl = 0;
		nil0i = 0;
		nil0l = 0;
		nil0O = 0;
		nilii = 0;
		nilil = 0;
		niliO = 0;
		nilli = 0;
		nilll = 0;
		nilOi = 0;
		nlll0l = 0;
		nlll0O = 0;
		nlllll = 0;
		nllllO = 0;
		nlllOi = 0;
		nlllOl = 0;
		nlllOO = 0;
		nllO0i = 0;
		nllO0l = 0;
		nllO0O = 0;
		nllO1i = 0;
		nllO1l = 0;
		nllO1O = 0;
		nllOii = 0;
		nllOil = 0;
		nllOiO = 0;
		nllOli = 0;
		nllOll = 0;
		nllOlO = 0;
		nllOOi = 0;
		nllOOl = 0;
		nllOOO = 0;
		nlO00i = 0;
		nlO00l = 0;
		nlO00O = 0;
		nlO01i = 0;
		nlO01l = 0;
		nlO01O = 0;
		nlO0ii = 0;
		nlO0il = 0;
		nlO0iO = 0;
		nlO0li = 0;
		nlO10i = 0;
		nlO10l = 0;
		nlO10O = 0;
		nlO11i = 0;
		nlO11l = 0;
		nlO11O = 0;
		nlO1ii = 0;
		nlO1il = 0;
		nlO1iO = 0;
		nlO1li = 0;
		nlO1ll = 0;
		nlO1lO = 0;
		nlO1Oi = 0;
		nlO1Ol = 0;
		nlO1OO = 0;
	end
	always @ (rcvd_clk or wire_nillO_PRN or soft_reset)
	begin
		if (wire_nillO_PRN == 1'b0) 
		begin
			n0001i <= 1;
			n0010i <= 1;
			n0010l <= 1;
			n0010O <= 1;
			n0011O <= 1;
			n001ii <= 1;
			n001il <= 1;
			n001iO <= 1;
			n001li <= 1;
			n001ll <= 1;
			n001lO <= 1;
			n001Oi <= 1;
			n001OO <= 1;
			n0101l <= 1;
			n1lli <= 1;
			n1lll <= 1;
			n1O1O <= 1;
			n1Ol0i <= 1;
			n1Ol0O <= 1;
			n1Olli <= 1;
			n1Olll <= 1;
			ni0iOl <= 1;
			ni0iOO <= 1;
			ni0l0i <= 1;
			ni0l0O <= 1;
			ni0l1i <= 1;
			ni0l1l <= 1;
			ni0l1O <= 1;
			ni0O0O <= 1;
			ni0Oii <= 1;
			ni0Oil <= 1;
			ni0OiO <= 1;
			ni0OOO <= 1;
			ni1liO <= 1;
			ni1lli <= 1;
			ni1lll <= 1;
			ni1llO <= 1;
			ni1lOi <= 1;
			ni1lOl <= 1;
			ni1lOO <= 1;
			ni1O1i <= 1;
			ni1Oli <= 1;
			nii11i <= 1;
			nii11l <= 1;
			nii11O <= 1;
			niii0i <= 1;
			niii0l <= 1;
			niii0O <= 1;
			niii1l <= 1;
			niii1O <= 1;
			niiiii <= 1;
			niiiil <= 1;
			niiiiO <= 1;
			niiili <= 1;
			niiill <= 1;
			niiilO <= 1;
			niiiOi <= 1;
			niiiOl <= 1;
			niiiOO <= 1;
			niil1i <= 1;
			niiO0i <= 1;
			niiO0l <= 1;
			niiO0O <= 1;
			niiO1l <= 1;
			niiO1O <= 1;
			niiOii <= 1;
			niiOil <= 1;
			niiOiO <= 1;
			niiOli <= 1;
			niiOll <= 1;
			niiOlO <= 1;
			niiOOi <= 1;
			niiOOl <= 1;
			nil0i <= 1;
			nil0l <= 1;
			nil0O <= 1;
			nilii <= 1;
			nilil <= 1;
			niliO <= 1;
			nilli <= 1;
			nilll <= 1;
			nilOi <= 1;
			nlll0l <= 1;
			nlll0O <= 1;
			nlllll <= 1;
			nllllO <= 1;
			nlllOi <= 1;
			nlllOl <= 1;
			nlllOO <= 1;
			nllO0i <= 1;
			nllO0l <= 1;
			nllO0O <= 1;
			nllO1i <= 1;
			nllO1l <= 1;
			nllO1O <= 1;
			nllOii <= 1;
			nllOil <= 1;
			nllOiO <= 1;
			nllOli <= 1;
			nllOll <= 1;
			nllOlO <= 1;
			nllOOi <= 1;
			nllOOl <= 1;
			nllOOO <= 1;
			nlO00i <= 1;
			nlO00l <= 1;
			nlO00O <= 1;
			nlO01i <= 1;
			nlO01l <= 1;
			nlO01O <= 1;
			nlO0ii <= 1;
			nlO0il <= 1;
			nlO0iO <= 1;
			nlO0li <= 1;
			nlO10i <= 1;
			nlO10l <= 1;
			nlO10O <= 1;
			nlO11i <= 1;
			nlO11l <= 1;
			nlO11O <= 1;
			nlO1ii <= 1;
			nlO1il <= 1;
			nlO1iO <= 1;
			nlO1li <= 1;
			nlO1ll <= 1;
			nlO1lO <= 1;
			nlO1Oi <= 1;
			nlO1Ol <= 1;
			nlO1OO <= 1;
		end
		else if  (soft_reset == 1'b1) 
		begin
			n0001i <= 0;
			n0010i <= 0;
			n0010l <= 0;
			n0010O <= 0;
			n0011O <= 0;
			n001ii <= 0;
			n001il <= 0;
			n001iO <= 0;
			n001li <= 0;
			n001ll <= 0;
			n001lO <= 0;
			n001Oi <= 0;
			n001OO <= 0;
			n0101l <= 0;
			n1lli <= 0;
			n1lll <= 0;
			n1O1O <= 0;
			n1Ol0i <= 0;
			n1Ol0O <= 0;
			n1Olli <= 0;
			n1Olll <= 0;
			ni0iOl <= 0;
			ni0iOO <= 0;
			ni0l0i <= 0;
			ni0l0O <= 0;
			ni0l1i <= 0;
			ni0l1l <= 0;
			ni0l1O <= 0;
			ni0O0O <= 0;
			ni0Oii <= 0;
			ni0Oil <= 0;
			ni0OiO <= 0;
			ni0OOO <= 0;
			ni1liO <= 0;
			ni1lli <= 0;
			ni1lll <= 0;
			ni1llO <= 0;
			ni1lOi <= 0;
			ni1lOl <= 0;
			ni1lOO <= 0;
			ni1O1i <= 0;
			ni1Oli <= 0;
			nii11i <= 0;
			nii11l <= 0;
			nii11O <= 0;
			niii0i <= 0;
			niii0l <= 0;
			niii0O <= 0;
			niii1l <= 0;
			niii1O <= 0;
			niiiii <= 0;
			niiiil <= 0;
			niiiiO <= 0;
			niiili <= 0;
			niiill <= 0;
			niiilO <= 0;
			niiiOi <= 0;
			niiiOl <= 0;
			niiiOO <= 0;
			niil1i <= 0;
			niiO0i <= 0;
			niiO0l <= 0;
			niiO0O <= 0;
			niiO1l <= 0;
			niiO1O <= 0;
			niiOii <= 0;
			niiOil <= 0;
			niiOiO <= 0;
			niiOli <= 0;
			niiOll <= 0;
			niiOlO <= 0;
			niiOOi <= 0;
			niiOOl <= 0;
			nil0i <= 0;
			nil0l <= 0;
			nil0O <= 0;
			nilii <= 0;
			nilil <= 0;
			niliO <= 0;
			nilli <= 0;
			nilll <= 0;
			nilOi <= 0;
			nlll0l <= 0;
			nlll0O <= 0;
			nlllll <= 0;
			nllllO <= 0;
			nlllOi <= 0;
			nlllOl <= 0;
			nlllOO <= 0;
			nllO0i <= 0;
			nllO0l <= 0;
			nllO0O <= 0;
			nllO1i <= 0;
			nllO1l <= 0;
			nllO1O <= 0;
			nllOii <= 0;
			nllOil <= 0;
			nllOiO <= 0;
			nllOli <= 0;
			nllOll <= 0;
			nllOlO <= 0;
			nllOOi <= 0;
			nllOOl <= 0;
			nllOOO <= 0;
			nlO00i <= 0;
			nlO00l <= 0;
			nlO00O <= 0;
			nlO01i <= 0;
			nlO01l <= 0;
			nlO01O <= 0;
			nlO0ii <= 0;
			nlO0il <= 0;
			nlO0iO <= 0;
			nlO0li <= 0;
			nlO10i <= 0;
			nlO10l <= 0;
			nlO10O <= 0;
			nlO11i <= 0;
			nlO11l <= 0;
			nlO11O <= 0;
			nlO1ii <= 0;
			nlO1il <= 0;
			nlO1iO <= 0;
			nlO1li <= 0;
			nlO1ll <= 0;
			nlO1lO <= 0;
			nlO1Oi <= 0;
			nlO1Ol <= 0;
			nlO1OO <= 0;
		end
		else 
		if (rcvd_clk != nillO_clk_prev && rcvd_clk == 1'b1) 
		begin
			n0001i <= n001OO;
			n0010i <= wire_n1OOii_o;
			n0010l <= wire_n1OOiO_o;
			n0010O <= wire_n1OOll_o;
			n0011O <= wire_n1OO0O_o;
			n001ii <= wire_n1OOOi_o;
			n001il <= wire_n1OOOO_o;
			n001iO <= wire_n0111l_o;
			n001li <= wire_n0110i_o;
			n001ll <= wire_n0110O_o;
			n001lO <= wire_n011il_o;
			n001Oi <= wire_n011li_o;
			n001OO <= ((~ SYNC_SM_DIS) & (LP10BEN | signal_detect));
			n0101l <= wire_n1OlOO_o;
			n1lli <= n1iOi;
			n1lll <= n1llO;
			n1O1O <= nl11O;
			n1Ol0i <= wire_n1OO1O_o;
			n1Ol0O <= wire_n1OllO_o;
			n1Olli <= wire_n1OlOi_o;
			n1Olll <= wire_n1OO0i_o;
			ni0iOl <= wire_ni01ll_o;
			ni0iOO <= wire_ni01lO_dataout;
			ni0l0i <= wire_ni001O_dataout;
			ni0l0O <= wire_ni0Oli_dataout;
			ni0l1i <= wire_ni01Oi_o;
			ni0l1l <= wire_ni01OO_o;
			ni0l1O <= wire_ni001l_dataout;
			ni0O0O <= wire_ni0Oll_dataout;
			ni0Oii <= wire_ni0OlO_dataout;
			ni0Oil <= wire_ni0OOi_dataout;
			ni0OiO <= ni0OOO;
			ni0OOO <= (niil1i | nii11O);
			ni1liO <= wire_ni1Oii_o[1];
			ni1lli <= wire_ni1Oii_o[2];
			ni1lll <= wire_ni1Oii_o[3];
			ni1llO <= wire_ni1O1l_dataout;
			ni1lOi <= wire_ni1O1O_dataout;
			ni1lOl <= wire_ni1O0i_dataout;
			ni1lOO <= wire_ni1O0l_dataout;
			ni1O1i <= wire_ni01iO_o;
			ni1Oli <= wire_ni1Oii_o[0];
			nii11i <= nii11l;
			nii11l <= RLV_EN;
			nii11O <= wire_niil1l_dataout;
			niii0i <= wire_niil0l_dataout;
			niii0l <= wire_niil0O_dataout;
			niii0O <= wire_niilii_dataout;
			niii1l <= wire_niil1O_dataout;
			niii1O <= wire_niil0i_dataout;
			niiiii <= wire_niilil_dataout;
			niiiil <= wire_niiliO_dataout;
			niiiiO <= wire_niilli_dataout;
			niiili <= wire_niilll_dataout;
			niiill <= wire_niillO_dataout;
			niiilO <= wire_niilOi_dataout;
			niiiOi <= wire_niilOl_dataout;
			niiiOl <= wire_niilOO_dataout;
			niiiOO <= wire_niiO1i_dataout;
			niil1i <= wire_niiOOO_dataout;
			niiO0i <= wire_nil11O_dataout;
			niiO0l <= wire_nil10i_dataout;
			niiO0O <= wire_nil10l_dataout;
			niiO1l <= wire_nil11i_dataout;
			niiO1O <= wire_nil11l_dataout;
			niiOii <= wire_nil10O_dataout;
			niiOil <= wire_nil1ii_dataout;
			niiOiO <= wire_nil1il_dataout;
			niiOli <= wire_nil1iO_dataout;
			niiOll <= wire_nil1li_dataout;
			niiOlO <= wire_nil1ll_dataout;
			niiOOi <= wire_nil1lO_dataout;
			niiOOl <= wire_nil1Oi_dataout;
			nil0i <= nl10i;
			nil0l <= nl10l;
			nil0O <= nl10O;
			nilii <= nl1ii;
			nilil <= nl1il;
			niliO <= nl1iO;
			nilli <= nl1li;
			nilll <= nl1ll;
			nilOi <= nl1Oi;
			nlll0l <= wire_n0OOlO_dataout;
			nlll0O <= ((~ PMADATAWIDTH) & (n1l11i | n1iOOO));
			nlllll <= (((n1l10l | n1l10i) | ((~ nlO0li) & ((~ nlO0iO) & ((~ nlO0il) & n1l11O)))) | (nlO0li & (nlO0iO & (nlO0il & n1l11l))));
			nllllO <= nlllOi;
			nlllOi <= nlllOl;
			nlllOl <= n1i1i;
			nlllOO <= wire_nlOi0O_dataout;
			nllO0i <= wire_nlOili_dataout;
			nllO0l <= wire_nlOill_dataout;
			nllO0O <= wire_nlOilO_dataout;
			nllO1i <= wire_nlOiii_dataout;
			nllO1l <= wire_nlOiil_dataout;
			nllO1O <= wire_nlOiiO_dataout;
			nllOii <= wire_nlOiOi_dataout;
			nllOil <= wire_nlOiOl_dataout;
			nllOiO <= wire_nlOiOO_dataout;
			nllOli <= (~ n1l10O);
			nllOll <= ((((~ PMADATAWIDTH) & (SYNC_SM_DIS & nlllOl)) | (PMADATAWIDTH & (SYNC_SM_DIS & nllllO))) | ((~ SYNC_SM_DIS) & n0101l));
			nllOlO <= n1l1ii;
			nllOOi <= wire_nlOlOO_dataout;
			nllOOl <= wire_nlOO1i_dataout;
			nllOOO <= wire_nlOO1l_dataout;
			nlO00i <= n110i;
			nlO00l <= n110l;
			nlO00O <= n110O;
			nlO01i <= nlO0ll;
			nlO01l <= n111l;
			nlO01O <= n111O;
			nlO0ii <= n11ii;
			nlO0il <= n11il;
			nlO0iO <= n11iO;
			nlO0li <= n11li;
			nlO10i <= wire_nlOO0O_dataout;
			nlO10l <= wire_nlOOii_dataout;
			nlO10O <= nlO1OO;
			nlO11i <= wire_nlOO1O_dataout;
			nlO11l <= wire_nlOO0i_dataout;
			nlO11O <= wire_nlOO0l_dataout;
			nlO1ii <= wire_nlOOil_o;
			nlO1il <= wire_nlOOiO_o;
			nlO1iO <= wire_nlOOli_o;
			nlO1li <= wire_nlOOll_o;
			nlO1ll <= wire_nlOOlO_o;
			nlO1lO <= wire_nlOOOi_o;
			nlO1Oi <= wire_nlOOOl_o;
			nlO1Ol <= wire_nlOOOO_o;
			nlO1OO <= n1lli;
		end
		nillO_clk_prev <= rcvd_clk;
	end
	assign
		wire_nillO_PRN = (n1O1Ol28 ^ n1O1Ol27);
	initial
	begin
		nilOl = 0;
		nilOO = 0;
		niO1i = 0;
		nl1ll = 0;
		nl1Oi = 0;
	end
	always @ (rcvd_clk or wire_nl1lO_PRN or soft_reset)
	begin
		if (wire_nl1lO_PRN == 1'b0) 
		begin
			nilOl <= 1;
			nilOO <= 1;
			niO1i <= 1;
			nl1ll <= 1;
			nl1Oi <= 1;
		end
		else if  (soft_reset == 1'b1) 
		begin
			nilOl <= 0;
			nilOO <= 0;
			niO1i <= 0;
			nl1ll <= 0;
			nl1Oi <= 0;
		end
		else if  (PMADATAWIDTH == 1'b0) 
		if (rcvd_clk != nl1lO_clk_prev && rcvd_clk == 1'b0) 
		begin
			nilOl <= niOiO;
			nilOO <= niOli;
			niO1i <= niOll;
			nl1ll <= wire_nliil_dataout;
			nl1Oi <= wire_nliiO_dataout;
		end
		nl1lO_clk_prev <= rcvd_clk;
	end
	assign
		wire_nl1lO_PRN = (n1O1OO26 ^ n1O1OO25);
	initial
	begin
		n0000i = 0;
		n0000l = 0;
		n0000O = 0;
		n0001O = 0;
		n00OlO = 0;
		n00OOi = 0;
		n00OOl = 0;
		n00OOO = 0;
		n0i0OO = 0;
		n0i10i = 0;
		n0i10l = 0;
		n0i10O = 0;
		n0i11i = 0;
		n0i11l = 0;
		n0i11O = 0;
		n0i1ii = 0;
		n0i1il = 0;
		n0i1iO = 0;
		n0i1li = 0;
		n0i1ll = 0;
		n0i1lO = 0;
		n0i1Oi = 0;
		n0ii0i = 0;
		n0ii0l = 0;
		n0ii0O = 0;
		n0ii1i = 0;
		n0ii1l = 0;
		n0ii1O = 0;
		n10ii = 0;
		n10il = 0;
		n10iO = 0;
		n110i = 0;
		n110l = 0;
		n110O = 0;
		n111l = 0;
		n111O = 0;
		n11ii = 0;
		n11il = 0;
		n11iO = 0;
		n11li = 0;
		n11ll = 0;
		n1i1i = 0;
		n1iOi = 0;
		n1iOO = 0;
		n1l0i = 0;
		n1l0l = 0;
		n1l1i = 0;
		n1l1l = 0;
		n1l1O = 0;
		n1llO = 0;
		niO0i = 0;
		niO0l = 0;
		niO0O = 0;
		niO1l = 0;
		niO1O = 0;
		niOii = 0;
		niOil = 0;
		niOiO = 0;
		niOli = 0;
		niOll = 0;
		niOlO = 0;
		niOOi = 0;
		niOOl = 0;
		niOOO = 0;
		nl10i = 0;
		nl10l = 0;
		nl10O = 0;
		nl11i = 0;
		nl11l = 0;
		nl11O = 0;
		nl1ii = 0;
		nl1il = 0;
		nl1iO = 0;
		nl1li = 0;
		nllil = 0;
		nllli = 0;
		nlO0ll = 0;
	end
	always @ ( negedge rcvd_clk or  posedge soft_reset)
	begin
		if (soft_reset == 1'b1) 
		begin
			n0000i <= 0;
			n0000l <= 0;
			n0000O <= 0;
			n0001O <= 0;
			n00OlO <= 0;
			n00OOi <= 0;
			n00OOl <= 0;
			n00OOO <= 0;
			n0i0OO <= 0;
			n0i10i <= 0;
			n0i10l <= 0;
			n0i10O <= 0;
			n0i11i <= 0;
			n0i11l <= 0;
			n0i11O <= 0;
			n0i1ii <= 0;
			n0i1il <= 0;
			n0i1iO <= 0;
			n0i1li <= 0;
			n0i1ll <= 0;
			n0i1lO <= 0;
			n0i1Oi <= 0;
			n0ii0i <= 0;
			n0ii0l <= 0;
			n0ii0O <= 0;
			n0ii1i <= 0;
			n0ii1l <= 0;
			n0ii1O <= 0;
			n10ii <= 0;
			n10il <= 0;
			n10iO <= 0;
			n110i <= 0;
			n110l <= 0;
			n110O <= 0;
			n111l <= 0;
			n111O <= 0;
			n11ii <= 0;
			n11il <= 0;
			n11iO <= 0;
			n11li <= 0;
			n11ll <= 0;
			n1i1i <= 0;
			n1iOi <= 0;
			n1iOO <= 0;
			n1l0i <= 0;
			n1l0l <= 0;
			n1l1i <= 0;
			n1l1l <= 0;
			n1l1O <= 0;
			n1llO <= 0;
			niO0i <= 0;
			niO0l <= 0;
			niO0O <= 0;
			niO1l <= 0;
			niO1O <= 0;
			niOii <= 0;
			niOil <= 0;
			niOiO <= 0;
			niOli <= 0;
			niOll <= 0;
			niOlO <= 0;
			niOOi <= 0;
			niOOl <= 0;
			niOOO <= 0;
			nl10i <= 0;
			nl10l <= 0;
			nl10O <= 0;
			nl11i <= 0;
			nl11l <= 0;
			nl11O <= 0;
			nl1ii <= 0;
			nl1il <= 0;
			nl1iO <= 0;
			nl1li <= 0;
			nllil <= 0;
			nllli <= 0;
			nlO0ll <= 0;
		end
		else 
		begin
			n0000i <= prbs_en;
			n0000l <= n0000O;
			n0000O <= ENCDT;
			n0001O <= n0000i;
			n00OlO <= n1llii;
			n00OOi <= wire_n00Oli_o;
			n00OOl <= n1lliO;
			n00OOO <= wire_n00O0l_o;
			n0i0OO <= n1O11O;
			n0i10i <= wire_n00lli_o;
			n0i10l <= n1lO0i;
			n0i10O <= wire_n00l0l_o;
			n0i11i <= n1llll;
			n0i11l <= wire_n00lOO_o;
			n0i11O <= n1llOi;
			n0i1ii <= n1lOlO;
			n0i1il <= wire_n00iOO_o;
			n0i1iO <= n1O11O;
			n0i1li <= wire_n00ili_o;
			n0i1ll <= n1O1ll;
			n0i1lO <= wire_n00i0l_o;
			n0i1Oi <= n1O1ll;
			n0ii0i <= n1llll;
			n0ii0l <= n1lliO;
			n0ii0O <= n1llii;
			n0ii1i <= n1lOlO;
			n0ii1l <= n1lO0i;
			n0ii1O <= n1llOi;
			n10ii <= n10il;
			n10il <= n10iO;
			n10iO <= BITSLIP;
			n110i <= wire_n11OO_o;
			n110l <= wire_n101i_o;
			n110O <= wire_n101l_o;
			n111l <= wire_n11Oi_o;
			n111O <= wire_n11Ol_o;
			n11ii <= wire_n101O_o;
			n11il <= wire_n100i_o;
			n11iO <= wire_n100l_o;
			n11li <= wire_n100O_o;
			n11ll <= (n10il & (~ n10ii));
			n1i1i <= (~ ((((n1liO & n1lil) & n1lii) & n1l0O) | ((((~ (n1l0O ^ n1l1l)) & (~ (n1lii ^ n1l1O))) & (~ (n1lil ^ n1l0i))) & (~ (n1liO ^ n1l0l)))));
			n1iOi <= n1iOO;
			n1iOO <= n1l1i;
			n1l0i <= n1lOO;
			n1l0l <= n1O1l;
			n1l1i <= A1A2_SIZE;
			n1l1l <= n1lOi;
			n1l1O <= n1lOl;
			n1llO <= n1li0O;
			niO0i <= wire_nl01i_dataout;
			niO0l <= wire_nl01l_dataout;
			niO0O <= wire_nl01O_dataout;
			niO1l <= wire_nl1Ol_dataout;
			niO1O <= wire_nl1OO_dataout;
			niOii <= wire_nl00i_dataout;
			niOil <= wire_nl00l_dataout;
			niOiO <= wire_nl00O_dataout;
			niOli <= wire_nl0ii_dataout;
			niOll <= wire_nl0il_dataout;
			niOlO <= wire_nl0iO_dataout;
			niOOi <= wire_nl0li_dataout;
			niOOl <= wire_nl0ll_dataout;
			niOOO <= wire_nl0lO_dataout;
			nl10i <= wire_nli1i_dataout;
			nl10l <= wire_nli1l_dataout;
			nl10O <= wire_nli1O_dataout;
			nl11i <= wire_nl0Oi_dataout;
			nl11l <= wire_nl0Ol_dataout;
			nl11O <= wire_nl0OO_dataout;
			nl1ii <= wire_nli0i_dataout;
			nl1il <= wire_nli0l_dataout;
			nl1iO <= wire_nli0O_dataout;
			nl1li <= wire_nliii_dataout;
			nllil <= wire_nlill_o;
			nllli <= wire_nlilO_o;
			nlO0ll <= wire_n11lO_o;
		end
	end
	initial
	begin
		n001Ol = 0;
		n1Ol0l = 0;
		ni0l0l = 0;
		nlllil = 0;
	end
	always @ ( posedge rcvd_clk or  posedge soft_reset)
	begin
		if (soft_reset == 1'b1) 
		begin
			n001Ol <= 1;
			n1Ol0l <= 1;
			ni0l0l <= 1;
			nlllil <= 1;
		end
		else 
		begin
			n001Ol <= wire_n011lO_o;
			n1Ol0l <= wire_n1OO1l_o;
			ni0l0l <= (~ nii11i);
			nlllil <= (n1l1ii | (~ n1l10O));
		end
	end
	event n001Ol_event;
	event n1Ol0l_event;
	event ni0l0l_event;
	event nlllil_event;
	initial
		#1 ->n001Ol_event;
	initial
		#1 ->n1Ol0l_event;
	initial
		#1 ->ni0l0l_event;
	initial
		#1 ->nlllil_event;
	always @(n001Ol_event)
		n001Ol <= 1;
	always @(n1Ol0l_event)
		n1Ol0l <= 1;
	always @(ni0l0l_event)
		ni0l0l <= 1;
	always @(nlllil_event)
		nlllil <= 1;
	initial
	begin
		n0001l = 0;
		n1l0O = 0;
		n1lii = 0;
		n1lil = 0;
		n1liO = 0;
		nlllO = 0;
	end
	always @ (rcvd_clk or wire_nllll_PRN or wire_nllll_CLRN)
	begin
		if (wire_nllll_PRN == 1'b0) 
		begin
			n0001l <= 1;
			n1l0O <= 1;
			n1lii <= 1;
			n1lil <= 1;
			n1liO <= 1;
			nlllO <= 1;
		end
		else if  (wire_nllll_CLRN == 1'b0) 
		begin
			n0001l <= 0;
			n1l0O <= 0;
			n1lii <= 0;
			n1lil <= 0;
			n1liO <= 0;
			nlllO <= 0;
		end
		else 
		if (rcvd_clk != nllll_clk_prev && rcvd_clk == 1'b0) 
		begin
			n0001l <= n1Ol0l;
			n1l0O <= (~ n1O0ll);
			n1lii <= n1O0lO;
			n1lil <= n1O0Oi;
			n1liO <= n1O0Ol;
			nlllO <= wire_nliOi_o;
		end
		nllll_clk_prev <= rcvd_clk;
	end
	assign
		wire_nllll_CLRN = (n1Oi0O6 ^ n1Oi0O5),
		wire_nllll_PRN = ((n1Oi0l8 ^ n1Oi0l7) & (~ soft_reset));
	event n0001l_event;
	event n1l0O_event;
	event n1lii_event;
	event n1lil_event;
	event n1liO_event;
	event nlllO_event;
	initial
		#1 ->n0001l_event;
	initial
		#1 ->n1l0O_event;
	initial
		#1 ->n1lii_event;
	initial
		#1 ->n1lil_event;
	initial
		#1 ->n1liO_event;
	initial
		#1 ->nlllO_event;
	always @(n0001l_event)
		n0001l <= 1;
	always @(n1l0O_event)
		n1l0O <= 1;
	always @(n1lii_event)
		n1lii <= 1;
	always @(n1lil_event)
		n1lil <= 1;
	always @(n1liO_event)
		n1liO <= 1;
	always @(nlllO_event)
		nlllO <= 1;
	assign		wire_n000O_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1lllO & n0ii1O)) | (n1iOO & (n1lllO & (n0i10i & (~ n0i11O))))) : (n1llOi | n1lllO);
	or(wire_n0011i_dataout, (~ n1Ol0i), ~(n1011i));
	assign		wire_n001O_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1llli & n0ii0i)) | (n1iOO & (n1llli & (n0i11l & (~ n0i11i))))) : (n1llll | n1llli);
	or(wire_n00i0O_dataout, n1O1li, n1O1ll);
	or(wire_n00ill_dataout, n1O11l, n1O11O);
	assign		wire_n00iO_dataout = (PMADATAWIDTH === 1'b1) ? ((((~ n1iOO) & (n1lO1O & n0ii1l)) & (n1lO1i46 ^ n1lO1i45)) | (n1iOO & (n1lO1O & ((n0i10O & (~ n0i10l)) & (n1llOl48 ^ n1llOl47))))) : (n1lO0i | n1lO1O);
	or(wire_n00l0O_dataout, n1lO1O, n1lO0i);
	or(wire_n00l1i_dataout, n1lOll, n1lOlO);
	or(wire_n00lll_dataout, n1lllO, n1llOi);
	assign		wire_n00lO_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & ((n1lOll & n0ii1i) & (n1lOii42 ^ n1lOii41))) | (n1iOO & ((n1lOll & (n0i1il & (~ n0i1ii))) & (n1lO0l44 ^ n1lO0l43)))) : ((n1lOlO | n1lOll) | (~ (n1lOiO40 ^ n1lOiO39)));
	or(wire_n00O0O_dataout, n1llil, n1lliO);
	or(wire_n00O1i_dataout, n1llli, n1llll);
	or(wire_n00Oll_dataout, n1ll0O, n1llii);
	assign		wire_n00OO_dataout = (PMADATAWIDTH === 1'b1) ? ((((~ n1iOO) & (n1O11l & n0i0OO)) | (n1iOO & ((n1O11l & (n0i1li & (~ n0i1iO))) & (n1lOOO36 ^ n1lOOO35)))) | (~ (n1lOOi38 ^ n1lOOi37))) : (n1O11O | n1O11l);
	and(wire_n0100i_dataout, wire_n01iiO_o[1], ~(n11OiO));
	and(wire_n0100l_dataout, n0101l, ~(n11OiO));
	and(wire_n0101i_dataout, n11O0l, ~(n11OiO));
	and(wire_n0101O_dataout, wire_n01iiO_o[0], ~(n11OiO));
	assign		wire_n010i_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10li : n1lOi;
	and(wire_n010ii_dataout, wire_n010ll_dataout, ~((~ n0001i)));
	and(wire_n010il_dataout, wire_n010lO_dataout, ~((~ n0001i)));
	and(wire_n010iO_dataout, wire_n010Oi_dataout, ~((~ n0001i)));
	assign		wire_n010l_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10lO : n1lOl;
	and(wire_n010li_dataout, wire_n010Ol_dataout, ~((~ n0001i)));
	and(wire_n010ll_dataout, wire_n010OO_dataout, ~(n11O0O));
	and(wire_n010lO_dataout, wire_n01i1i_dataout, ~(n11O0O));
	assign		wire_n010O_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10Oi : n1lOO;
	and(wire_n010Oi_dataout, (~ n11O0l), ~(n11O0O));
	and(wire_n010Ol_dataout, n11O0l, ~(n11O0O));
	and(wire_n010OO_dataout, wire_n01iiO_o[0], ~(n11O0l));
	and(wire_n011Oi_dataout, wire_n010OO_dataout, ~(n11OiO));
	and(wire_n011Ol_dataout, wire_n01i1i_dataout, ~(n11OiO));
	and(wire_n011OO_dataout, (~ n11O0l), ~(n11OiO));
	and(wire_n01i0i_dataout, wire_n01iii_dataout, ~((~ n0001i)));
	and(wire_n01i0l_dataout, wire_n01iil_dataout, ~((~ n0001i)));
	and(wire_n01i0O_dataout, (~ n11O0O), ~((~ n0001i)));
	and(wire_n01i1i_dataout, wire_n01iiO_o[1], ~(n11O0l));
	assign		wire_n01ii_dataout = (AUTOBYTEALIGN_DIS === 1'b1) ? n10OO : n1O1l;
	and(wire_n01iii_dataout, wire_n01iiO_o[0], ~(n11O0O));
	and(wire_n01iil_dataout, wire_n01iiO_o[1], ~(n11O0O));
	and(wire_n01il_dataout, (n1ll1O | n1ll1l), ~(PMADATAWIDTH));
	or(wire_n01ili_dataout, n1Ol0l, (~ n0001i));
	and(wire_n01ill_dataout, n0101l, ~((~ n0001i)));
	and(wire_n01ilO_dataout, n11O0O, ~((~ n0001i)));
	and(wire_n01iOi_dataout, (~ n11O0O), ~((~ n0001i)));
	assign		wire_n01iOO_dataout = (n11Oil === 1'b1) ? n0101l : wire_n01l0i_dataout;
	or(wire_n01l0i_dataout, n0101l, n11Oii);
	or(wire_n01l1i_dataout, n1Ol0l, n11Oil);
	and(wire_n01l1l_dataout, n11Oii, ~(n11Oil));
	and(wire_n01l1O_dataout, (~ n11Oii), ~(n11Oil));
	and(wire_n01li_dataout, (n1ll0l | n1ll0i), ~(PMADATAWIDTH));
	assign		wire_n01lO_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1ll0O & n0ii0O)) | (n1iOO & (n1ll0O & (n00OOi & (~ n00OlO))))) : (n1llii | n1ll0O);
	assign		wire_n01lOi_dataout = (n11OiO === 1'b1) ? (~ n1Ol0i) : wire_n01O1l_dataout;
	or(wire_n01lOl_dataout, n1Ol0l, n11OiO);
	and(wire_n01lOO_dataout, (~ n11Oli), ~(n11OiO));
	assign		wire_n01O0l_dataout = (n11OOl === 1'b1) ? (~ n1Ol0i) : wire_n01Oli_dataout;
	or(wire_n01O0O_dataout, n1Ol0l, n11OOl);
	and(wire_n01O1i_dataout, n11Oli, ~(n11OiO));
	or(wire_n01O1l_dataout, (~ n1Ol0i), n11Oli);
	and(wire_n01Oii_dataout, n11OlO, ~(n11OOl));
	and(wire_n01Oil_dataout, wire_n01Oll_dataout, ~(n11OOl));
	and(wire_n01OiO_dataout, wire_n01OlO_dataout, ~(n11OOl));
	assign		wire_n01Oli_dataout = (n11OlO === 1'b1) ? (~ n1Ol0i) : n1Ol0i;
	and(wire_n01Oll_dataout, n11Oll, ~(n11OlO));
	and(wire_n01OlO_dataout, (~ n11Oll), ~(n11OlO));
	assign		wire_n01OO_dataout = (PMADATAWIDTH === 1'b1) ? (((~ n1iOO) & (n1llil & n0ii0l)) | (n1iOO & (n1llil & (n00OOO & (~ n00OOl))))) : (n1lliO | n1llil);
	and(wire_n01OOO_dataout, n1Ol0l, n1011i);
	assign		wire_n0i0O_dataout = (n1O1lO === 1'b1) ? niOiO : wire_n0l1i_dataout;
	assign		wire_n0i1O_dataout = (PMADATAWIDTH === 1'b1) ? (((((~ n1iOO) & (n1O1li & n0i1Oi)) & (n1O1il30 ^ n1O1il29)) | ((n1iOO & (n1O1li & (n0i1lO & (~ n0i1ll)))) & (n1O10O32 ^ n1O10O31))) | (~ (n1O10i34 ^ n1O10i33))) : (n1O1ll | n1O1li);
	assign		wire_n0iii_dataout = (n1O1lO === 1'b1) ? niOli : wire_n0l1l_dataout;
	assign		wire_n0iil_dataout = (n1O1lO === 1'b1) ? niOll : wire_n0l1O_dataout;
	assign		wire_n0iiO_dataout = (n1O1lO === 1'b1) ? niOlO : wire_n0l0i_dataout;
	assign		wire_n0ili_dataout = (n1O1lO === 1'b1) ? niOOi : wire_n0l0l_dataout;
	assign		wire_n0ill_dataout = (n1O1lO === 1'b1) ? niOOl : wire_n0l0O_dataout;
	assign		wire_n0ilO_dataout = (n1O1lO === 1'b1) ? niOOO : wire_n0lii_dataout;
	and(wire_n0iOi_dataout, wire_n0lil_dataout, ~(n1O1lO));
	and(wire_n0iOl_dataout, wire_n0liO_dataout, ~(n1O1lO));
	and(wire_n0iOO_dataout, wire_n0lli_dataout, ~(n1O1lO));
	and(wire_n0l0i_dataout, niOlO, ~(n1O1Oi));
	assign		wire_n0l0ii_dataout = (((((~ nlO00i) & n101il) | (nlO00i & n1l1Oi)) | (n1l00l & n1l01l)) === 1'b1) ? nlll0l : (n1l1Ol | n1l1OO);
	and(wire_n0l0l_dataout, niOOi, ~(n1O1Oi));
	and(wire_n0l0O_dataout, niOOl, ~(n1O1Oi));
	and(wire_n0l1i_dataout, niOiO, ~(n1O1Oi));
	and(wire_n0l1l_dataout, niOli, ~(n1O1Oi));
	and(wire_n0l1O_dataout, niOll, ~(n1O1Oi));
	and(wire_n0lii_dataout, niOOO, ~(n1O1Oi));
	and(wire_n0lil_dataout, nl11i, ~(n1O1Oi));
	and(wire_n0liO_dataout, nl11l, ~(n1O1Oi));
	and(wire_n0lli_dataout, nl11O, ~(n1O1Oi));
	assign		wire_n0lll_dataout = (n1O1lO === 1'b1) ? niOli : wire_n0l1l_dataout;
	assign		wire_n0llO_dataout = (n1O1lO === 1'b1) ? niOll : wire_n0l1O_dataout;
	assign		wire_n0lOi_dataout = (n1O1lO === 1'b1) ? niOlO : wire_n0l0i_dataout;
	assign		wire_n0lOl_dataout = (n1O1lO === 1'b1) ? niOOi : wire_n0l0l_dataout;
	assign		wire_n0lOO_dataout = (n1O1lO === 1'b1) ? niOOl : wire_n0l0O_dataout;
	and(wire_n0O0i_dataout, wire_n0lli_dataout, ~(n1O1lO));
	and(wire_n0O0l_dataout, wire_n0O0O_dataout, ~(n1O1lO));
	and(wire_n0O0O_dataout, nl10i, ~(n1O1Oi));
	assign		wire_n0O1i_dataout = (n1O1lO === 1'b1) ? niOOO : wire_n0lii_dataout;
	assign		wire_n0O1l_dataout = (n1O1lO === 1'b1) ? nl11i : wire_n0lil_dataout;
	and(wire_n0O1O_dataout, wire_n0liO_dataout, ~(n1O1lO));
	and(wire_n0Oii_dataout, nl11O, ~(n1O1lO));
	and(wire_n0Oil_dataout, wire_n0O0O_dataout, ~(n1O1lO));
	and(wire_n0OiO_dataout, wire_n0Oli_dataout, ~(n1O1lO));
	and(wire_n0Oli_dataout, nl10l, ~(n1O1Oi));
	and(wire_n0Oll_dataout, nl10i, ~(n1O1lO));
	and(wire_n0OlO_dataout, wire_n0Oli_dataout, ~(n1O1lO));
	and(wire_n0OOi_dataout, wire_n0OOl_dataout, ~(n1O1lO));
	and(wire_n0OOl_dataout, nl10O, ~(n1O1Oi));
	assign		wire_n0OOlO_dataout = (((nlO0il ^ nlO0ii) & n1l1il) === 1'b1) ? wire_n0l0ii_dataout : (n1l1iO | n1l1lO);
	and(wire_n0OOO_dataout, nl10l, ~(n1O1lO));
	and(wire_n1i0i_dataout, wire_n1iil_dataout, ~(n1li1O));
	or(wire_n1i0l_dataout, wire_n1iiO_dataout, n1li1O);
	or(wire_n1i0O_dataout, wire_n1ili_o[1], n1li1l);
	or(wire_n1i1l_dataout, wire_n1i0O_dataout, n1li1O);
	and(wire_n1i1O_dataout, wire_n1iii_dataout, ~(n1li1O));
	or(wire_n1iii_dataout, wire_n1ili_o[2], n1li1l);
	or(wire_n1iil_dataout, wire_n1ili_o[3], n1li1l);
	and(wire_n1iiO_dataout, wire_n1ili_o[4], ~(n1li1l));
	assign		wire_n1Olii_dataout = (n0001O === 1'b1) ? encdet_prbs : wire_n1Olil_dataout;
	assign		wire_n1Olil_dataout = (SYNC_SM_DIS === 1'b1) ? wire_n1OliO_dataout : n0001l;
	assign		wire_n1OliO_dataout = (PMADATAWIDTH === 1'b1) ? wire_nlili_o : n0000l;
	and(wire_ni000i_dataout, niii0i, ~(n10i1l));
	and(wire_ni000l_dataout, niii0l, ~(n10i1l));
	and(wire_ni000O_dataout, niii0O, ~(n10i1l));
	and(wire_ni001l_dataout, wire_ni0iOi_dataout, ni0l0i);
	and(wire_ni001O_dataout, nii11i, ni0l0l);
	and(wire_ni00i_dataout, nl1ll, ~(n1O1Oi));
	and(wire_ni00ii_dataout, niiiii, ~(n10i1l));
	and(wire_ni00il_dataout, wire_ni00ll_dataout, ~((~ nii11i)));
	and(wire_ni00iO_dataout, n10i1i, ~((~ nii11i)));
	and(wire_ni00l_dataout, nl1li, ~(n1O1lO));
	and(wire_ni00li_dataout, wire_ni00lO_dataout, ~((~ nii11i)));
	and(wire_ni00ll_dataout, (~ n100OO), ~(n10i1i));
	and(wire_ni00lO_dataout, n100OO, ~(n10i1i));
	and(wire_ni00O_dataout, wire_ni00i_dataout, ~(n1O1lO));
	and(wire_ni00OO_dataout, niiO1O, ~(n10i1l));
	and(wire_ni01i_dataout, nl1iO, ~(n1O1lO));
	and(wire_ni01l_dataout, wire_ni1OO_dataout, ~(n1O1lO));
	and(wire_ni01lO_dataout, wire_ni0ilO_dataout, ni0l0i);
	and(wire_ni01O_dataout, wire_ni00i_dataout, ~(n1O1lO));
	and(wire_ni0i0l_dataout, n10i0i, ~((~ nii11i)));
	and(wire_ni0i0O_dataout, wire_ni0iil_dataout, ~((~ nii11i)));
	and(wire_ni0i1i_dataout, niiO0i, ~(n10i1l));
	and(wire_ni0i1l_dataout, niiO0l, ~(n10i1l));
	and(wire_ni0i1O_dataout, niiO0O, ~(n10i1l));
	and(wire_ni0ii_dataout, wire_ni0il_dataout, ~(n1O1lO));
	and(wire_ni0iii_dataout, wire_ni0iiO_dataout, ~((~ nii11i)));
	and(wire_ni0iil_dataout, (~ n10i1O), ~(n10i0i));
	and(wire_ni0iiO_dataout, n10i1O, ~(n10i0i));
	and(wire_ni0il_dataout, nl1Oi, ~(n1O1Oi));
	and(wire_ni0ilO_dataout, niii1l, ~((~ nii11i)));
	assign		wire_ni0iO_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[0]) : wire_nii0i_dataout;
	and(wire_ni0iOi_dataout, (~ niii1l), ~((~ nii11i)));
	assign		wire_ni0li_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[1]) : wire_nii0l_dataout;
	and(wire_ni0lii_dataout, RUNDISP_SEL[0], ~(PMADATAWIDTH));
	and(wire_ni0lil_dataout, RUNDISP_SEL[1], ~(PMADATAWIDTH));
	assign		wire_ni0liO_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[0] : wire_ni0lOO_o[0];
	assign		wire_ni0ll_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[2]) : wire_nii0O_dataout;
	assign		wire_ni0lli_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[1] : wire_ni0lOO_o[1];
	assign		wire_ni0lll_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[2] : wire_ni0lOO_o[2];
	assign		wire_ni0llO_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[3] : wire_ni0lOO_o[3];
	assign		wire_ni0lO_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[3]) : wire_niiii_dataout;
	assign		wire_ni0lOi_dataout = (PMADATAWIDTH === 1'b1) ? RUNDISP_SEL[4] : wire_ni0lOO_o[4];
	assign		wire_ni0lOl_dataout = (PMADATAWIDTH === 1'b1) ? (~ n10i0l) : wire_ni0lOO_o[5];
	assign		wire_ni0Oi_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[4]) : wire_niiil_dataout;
	assign		wire_ni0Ol_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[5]) : wire_niiiO_dataout;
	and(wire_ni0Oli_dataout, ni0O0O, nii11i);
	and(wire_ni0Oll_dataout, ni0Oii, nii11i);
	and(wire_ni0OlO_dataout, n1Ol1l, nii11i);
	assign		wire_ni0OO_dataout = (n1O1lO === 1'b1) ? (~ SYNC_COMP_PAT[6]) : wire_niili_dataout;
	and(wire_ni0OOi_dataout, wire_ni0OOl_o, nii11i);
	and(wire_ni10i_dataout, nl10O, ~(n1O1lO));
	and(wire_ni10l_dataout, wire_ni11O_dataout, ~(n1O1lO));
	and(wire_ni10O_dataout, wire_ni1ii_dataout, ~(n1O1lO));
	and(wire_ni11i_dataout, wire_n0OOl_dataout, ~(n1O1lO));
	and(wire_ni11l_dataout, wire_ni11O_dataout, ~(n1O1lO));
	and(wire_ni11O_dataout, nl1ii, ~(n1O1Oi));
	and(wire_ni1ii_dataout, nl1il, ~(n1O1Oi));
	and(wire_ni1il_dataout, nl1ii, ~(n1O1lO));
	and(wire_ni1iO_dataout, wire_ni1ii_dataout, ~(n1O1lO));
	and(wire_ni1li_dataout, wire_ni1ll_dataout, ~(n1O1lO));
	and(wire_ni1ll_dataout, nl1iO, ~(n1O1Oi));
	and(wire_ni1lO_dataout, nl1il, ~(n1O1lO));
	assign		wire_ni1O0i_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[2] : wire_ni1Oll_dataout;
	assign		wire_ni1O0l_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[3] : wire_ni1OlO_dataout;
	assign		wire_ni1O1l_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[0] : wire_ni1Oil_dataout;
	assign		wire_ni1O1O_dataout = (wire_ni1Oii_o[4] === 1'b1) ? wire_ni1O0O_o[1] : wire_ni1OiO_dataout;
	and(wire_ni1Oi_dataout, wire_ni1ll_dataout, ~(n1O1lO));
	and(wire_ni1Oil_dataout, ni1llO, n100iO);
	and(wire_ni1OiO_dataout, ni1lOi, n100iO);
	and(wire_ni1Ol_dataout, wire_ni1OO_dataout, ~(n1O1lO));
	and(wire_ni1Oll_dataout, ni1lOl, n100iO);
	and(wire_ni1OlO_dataout, ni1lOO, n100iO);
	and(wire_ni1OO_dataout, nl1li, ~(n1O1Oi));
	assign		wire_nii0i_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[8] : (~ SYNC_COMP_PAT[0]);
	assign		wire_nii0l_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[9] : (~ SYNC_COMP_PAT[1]);
	assign		wire_nii0O_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[10] : (~ SYNC_COMP_PAT[2]);
	and(wire_nii1i_dataout, wire_niill_dataout, ~(n1O1lO));
	and(wire_nii1l_dataout, wire_niilO_dataout, ~(n1O1lO));
	and(wire_nii1O_dataout, wire_niiOi_dataout, ~(n1O1lO));
	assign		wire_niii1i_dataout = (PMADATAWIDTH === 1'b1) ? n10i0O : n10iii;
	assign		wire_niiii_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[11] : (~ SYNC_COMP_PAT[3]);
	assign		wire_niiil_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[12] : (~ SYNC_COMP_PAT[4]);
	assign		wire_niiiO_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[13] : (~ SYNC_COMP_PAT[5]);
	and(wire_niil0i_dataout, (((~ PMADATAWIDTH) & n1i01l) | (PMADATAWIDTH & n1ii1i)), nii11i);
	and(wire_niil0l_dataout, n10lii, nii11i);
	and(wire_niil0O_dataout, n10liO, nii11i);
	and(wire_niil1l_dataout, ((~ n10iOl) | ((~ n10iOi) | ((~ n10ilO) | ((~ n10ill) | ((~ n10ili) | ((~ n10iiO) | (~ n10iil))))))), nii11i);
	and(wire_niil1O_dataout, (n1il1i | n1iiOO), nii11i);
	assign		wire_niili_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[14] : (~ SYNC_COMP_PAT[6]);
	and(wire_niilii_dataout, ((((~ n10lOO) | (~ n10lOl)) | (~ n10lOi)) | (~ n10llO)), nii11i);
	and(wire_niilil_dataout, ((n1i01l | (~ n10O1i)) | (~ (((~ n1ii1i) | n1i01O) | n1i01l))), nii11i);
	and(wire_niiliO_dataout, niiilO, nii11i);
	assign		wire_niill_dataout = (n1O1Oi === 1'b1) ? SYNC_COMP_PAT[15] : (~ SYNC_COMP_PAT[7]);
	and(wire_niilli_dataout, niiiOi, nii11i);
	and(wire_niilll_dataout, niiiOl, nii11i);
	and(wire_niillO_dataout, niiiOO, nii11i);
	and(wire_niilO_dataout, (~ SYNC_COMP_PAT[8]), ~(n1O1Oi));
	and(wire_niilOi_dataout, n10O1l, nii11i);
	and(wire_niilOl_dataout, n10O0i, nii11i);
	and(wire_niilOO_dataout, ((((~ n10Oli) | (~ n10OiO)) | (~ n10Oil)) | (~ n10Oii)), nii11i);
	and(wire_niiO1i_dataout, ((n1i0ll | (~ n10Oll)) | (~ (((~ n1i0OO) | n1i0Oi) | n1i0ll))), nii11i);
	and(wire_niiOi_dataout, (~ SYNC_COMP_PAT[9]), ~(n1O1Oi));
	and(wire_niiOl_dataout, SYNC_COMP_PAT[7], ~(n1O1lO));
	and(wire_niiOO_dataout, wire_nil1l_dataout, ~(n1O1lO));
	and(wire_niiOOO_dataout, ((~ n10l0O) | ((~ n10l0l) | ((~ n10l0i) | ((~ n10l1O) | ((~ n10l1l) | ((~ n10l1i) | (~ n10iOO))))))), nii11i);
	and(wire_nil10i_dataout, ((((~ n1i10l) | (~ n1i10i)) | (~ n1i11O)) | (~ n1i11l)), nii11i);
	and(wire_nil10l_dataout, ((n1il1l | (~ n1i10O)) | (~ ((n1iO1i | n1il1O) | n1il1l))), nii11i);
	and(wire_nil10O_dataout, niiOll, nii11i);
	and(wire_nil11i_dataout, (((~ PMADATAWIDTH) & n1il1l) | (PMADATAWIDTH & (~ n1iO1i))), nii11i);
	and(wire_nil11l_dataout, n10OlO, nii11i);
	and(wire_nil11O_dataout, n10OOl, nii11i);
	and(wire_nil1i_dataout, wire_nil1O_dataout, ~(n1O1lO));
	and(wire_nil1ii_dataout, niiOlO, nii11i);
	and(wire_nil1il_dataout, niiOOi, nii11i);
	and(wire_nil1iO_dataout, niiOOl, nii11i);
	and(wire_nil1l_dataout, SYNC_COMP_PAT[8], ~(n1O1Oi));
	and(wire_nil1li_dataout, n1i1ii, nii11i);
	and(wire_nil1ll_dataout, n1i1iO, nii11i);
	and(wire_nil1lO_dataout, ((((~ n1i1OO) | (~ n1i1Ol)) | (~ n1i1Oi)) | (~ n1i1lO)), nii11i);
	and(wire_nil1O_dataout, SYNC_COMP_PAT[9], ~(n1O1Oi));
	and(wire_nil1Oi_dataout, ((n1illl | (~ n1i01i)) | (~ (((~ n1ilOO) | n1ilOi) | n1illl))), nii11i);
	assign		wire_nl00i_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl11l : niOOO;
	assign		wire_nl00l_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl11O : nl11i;
	assign		wire_nl00O_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl10i : nl11l;
	assign		wire_nl01i_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOOl : niOlO;
	assign		wire_nl01l_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOOO : niOOi;
	assign		wire_nl01O_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl11i : niOOl;
	assign		wire_nl0ii_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl10l : nl11O;
	assign		wire_nl0il_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl10O : nl10i;
	assign		wire_nl0iO_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1ii : nl10l;
	assign		wire_nl0li_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1il : nl10O;
	assign		wire_nl0ll_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1iO : nl1ii;
	assign		wire_nl0lO_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1li : nl1il;
	assign		wire_nl0Oi_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1ll : nl1iO;
	assign		wire_nl0Ol_dataout = ((~ PMADATAWIDTH) === 1'b1) ? nl1Oi : nl1li;
	assign		wire_nl0OO_dataout = (LP10BEN === 1'b1) ? PUDR[0] : PUDI[0];
	assign		wire_nl1Ol_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOlO : niOli;
	assign		wire_nl1OO_dataout = ((~ PMADATAWIDTH) === 1'b1) ? niOOi : niOll;
	assign		wire_nli0i_dataout = (LP10BEN === 1'b1) ? PUDR[4] : PUDI[4];
	assign		wire_nli0l_dataout = (LP10BEN === 1'b1) ? PUDR[5] : PUDI[5];
	assign		wire_nli0O_dataout = (LP10BEN === 1'b1) ? PUDR[6] : PUDI[6];
	assign		wire_nli1i_dataout = (LP10BEN === 1'b1) ? PUDR[1] : PUDI[1];
	assign		wire_nli1l_dataout = (LP10BEN === 1'b1) ? PUDR[2] : PUDI[2];
	assign		wire_nli1O_dataout = (LP10BEN === 1'b1) ? PUDR[3] : PUDI[3];
	assign		wire_nliii_dataout = (LP10BEN === 1'b1) ? PUDR[7] : PUDI[7];
	assign		wire_nliil_dataout = (LP10BEN === 1'b1) ? PUDR[8] : PUDI[8];
	assign		wire_nliiO_dataout = (LP10BEN === 1'b1) ? PUDR[9] : PUDI[9];
	or(wire_nliOl_dataout, n1O0OO, n1O00O);
	and(wire_nliOO_dataout, n1O0OO, ~(n1O00O));
	and(wire_nll0i_dataout, (~ n1O00O), ~(n1O0OO));
	and(wire_nll1i_dataout, (~ n1O0OO), ~(n1O00O));
	or(wire_nll1l_dataout, n1O00O, n1O0OO);
	and(wire_nll1O_dataout, n1O00O, ~(n1O0OO));
	assign		wire_nlOi0O_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[0] : wire_nlOl1i_dataout;
	assign		wire_nlOiii_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[1] : wire_nlOl1l_dataout;
	assign		wire_nlOiil_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[2] : wire_nlOl1O_dataout;
	assign		wire_nlOiiO_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[3] : wire_nlOl0i_dataout;
	assign		wire_nlOili_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[4] : wire_nlOl0l_dataout;
	assign		wire_nlOill_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[5] : wire_nlOl0O_dataout;
	assign		wire_nlOilO_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[6] : wire_nlOlii_dataout;
	assign		wire_nlOiOi_dataout = (n1l0li === 1'b1) ? SYNC_COMP_PAT[7] : wire_nlOlil_dataout;
	assign		wire_nlOiOl_dataout = (n1l0li === 1'b1) ? nlO10O : wire_nlOliO_dataout;
	and(wire_nlOiOO_dataout, wire_nlOlli_dataout, ~(n1l0li));
	assign		wire_nlOl0i_dataout = (n1l0iO === 1'b1) ? nlO11i : nlO00i;
	assign		wire_nlOl0l_dataout = (n1l0iO === 1'b1) ? nlO11l : nlO00l;
	assign		wire_nlOl0O_dataout = (n1l0iO === 1'b1) ? nlO11O : nlO00O;
	assign		wire_nlOl1i_dataout = (n1l0iO === 1'b1) ? nllOOi : nlO01i;
	assign		wire_nlOl1l_dataout = (n1l0iO === 1'b1) ? nllOOl : nlO01l;
	assign		wire_nlOl1O_dataout = (n1l0iO === 1'b1) ? nllOOO : nlO01O;
	assign		wire_nlOlii_dataout = (n1l0iO === 1'b1) ? nlO10i : nlO0ii;
	assign		wire_nlOlil_dataout = (n1l0iO === 1'b1) ? nlO10l : nlO0il;
	assign		wire_nlOliO_dataout = (n1l0iO === 1'b1) ? nlO10O : nlO0iO;
	and(wire_nlOlli_dataout, nlO0li, ~(n1l0iO));
	assign		wire_nlOlOO_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[0] : nlO1ii;
	assign		wire_nlOO0i_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[4] : nlO1ll;
	assign		wire_nlOO0l_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[5] : nlO1lO;
	assign		wire_nlOO0O_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[6] : nlO1Oi;
	assign		wire_nlOO1i_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[1] : nlO1il;
	assign		wire_nlOO1l_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[2] : nlO1iO;
	assign		wire_nlOO1O_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[3] : nlO1li;
	assign		wire_nlOOii_dataout = (n1l0ll === 1'b1) ? SYNC_COMP_PAT[7] : nlO1Ol;
	oper_add   n01iiO
	( 
	.a({n1Olli, n1Ol0O}),
	.b({1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_n01iiO_o));
	defparam
		n01iiO.sgate_representation = 0,
		n01iiO.width_a = 2,
		n01iiO.width_b = 2,
		n01iiO.width_o = 2;
	oper_add   n1ili
	( 
	.a({n10OO, n10Oi, n10lO, n10li, 1'b1}),
	.b({{3{1'b1}}, 1'b0, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_n1ili_o));
	defparam
		n1ili.sgate_representation = 0,
		n1ili.width_a = 5,
		n1ili.width_b = 5,
		n1ili.width_o = 5;
	oper_add   ni0lOO
	( 
	.a({{2{1'b0}}, (~ n10i0l), RUNDISP_SEL[4:2]}),
	.b({(~ n10i0l), RUNDISP_SEL[4:0]}),
	.cin(1'b0),
	.cout(),
	.o(wire_ni0lOO_o));
	defparam
		ni0lOO.sgate_representation = 0,
		ni0lOO.width_a = 6,
		ni0lOO.width_b = 6,
		ni0lOO.width_o = 6;
	oper_add   ni1O0O
	( 
	.a({wire_ni1OlO_dataout, wire_ni1Oll_dataout, wire_ni1OiO_dataout, wire_ni1Oil_dataout}),
	.b({{3{1'b0}}, 1'b1}),
	.cin(1'b0),
	.cout(),
	.o(wire_ni1O0O_o));
	defparam
		ni1O0O.sgate_representation = 0,
		ni1O0O.width_a = 4,
		ni1O0O.width_b = 4,
		ni1O0O.width_o = 4;
	oper_add   ni1Oii
	( 
	.a({1'b0, wire_ni010O_o, wire_ni010l_o, wire_ni010i_o, wire_ni011O_o}),
	.b({1'b0, wire_ni011i_o, wire_ni1OOO_o, wire_ni1OOl_o, wire_ni1OOi_o}),
	.cin(1'b0),
	.cout(),
	.o(wire_ni1Oii_o));
	defparam
		ni1Oii.sgate_representation = 0,
		ni1Oii.width_a = 5,
		ni1Oii.width_b = 5,
		ni1Oii.width_o = 5;
	oper_less_than   ni0OOl
	( 
	.a({wire_ni0lOl_dataout, wire_ni0lOi_dataout, wire_ni0llO_dataout, wire_ni0lll_dataout, wire_ni0lli_dataout, wire_ni0liO_dataout, wire_ni0lil_dataout, wire_ni0lii_dataout}),
	.b({ni1lOO, ni1lOl, ni1lOi, ni1llO, ni1lll, ni1lli, ni1liO, ni1Oli}),
	.cin(1'b0),
	.o(wire_ni0OOl_o));
	defparam
		ni0OOl.sgate_representation = 0,
		ni0OOl.width_a = 8,
		ni0OOl.width_b = 8;
	oper_mux   n00i0l
	( 
	.data({wire_n00i0O_dataout, 1'b0, n1O1ll, 1'b0}),
	.o(wire_n00i0l_o),
	.sel({n0i1lO, n0i1ll}));
	defparam
		n00i0l.width_data = 4,
		n00i0l.width_sel = 2;
	oper_mux   n00ili
	( 
	.data({wire_n00ill_dataout, 1'b0, n1O11O, 1'b0}),
	.o(wire_n00ili_o),
	.sel({n0i1li, n0i1iO}));
	defparam
		n00ili.width_data = 4,
		n00ili.width_sel = 2;
	oper_mux   n00iOO
	( 
	.data({wire_n00l1i_dataout, 1'b0, n1lOlO, 1'b0}),
	.o(wire_n00iOO_o),
	.sel({n0i1il, n0i1ii}));
	defparam
		n00iOO.width_data = 4,
		n00iOO.width_sel = 2;
	oper_mux   n00l0l
	( 
	.data({wire_n00l0O_dataout, 1'b0, n1lO0i, 1'b0}),
	.o(wire_n00l0l_o),
	.sel({n0i10O, n0i10l}));
	defparam
		n00l0l.width_data = 4,
		n00l0l.width_sel = 2;
	oper_mux   n00lli
	( 
	.data({wire_n00lll_dataout, 1'b0, n1llOi, 1'b0}),
	.o(wire_n00lli_o),
	.sel({n0i10i, n0i11O}));
	defparam
		n00lli.width_data = 4,
		n00lli.width_sel = 2;
	oper_mux   n00lOO
	( 
	.data({wire_n00O1i_dataout, 1'b0, n1llll, 1'b0}),
	.o(wire_n00lOO_o),
	.sel({n0i11l, n0i11i}));
	defparam
		n00lOO.width_data = 4,
		n00lOO.width_sel = 2;
	oper_mux   n00O0l
	( 
	.data({wire_n00O0O_dataout, 1'b0, n1lliO, 1'b0}),
	.o(wire_n00O0l_o),
	.sel({n00OOO, n00OOl}));
	defparam
		n00O0l.width_data = 4,
		n00O0l.width_sel = 2;
	oper_mux   n00Oli
	( 
	.data({wire_n00Oll_dataout, 1'b0, n1llii, 1'b0}),
	.o(wire_n00Oli_o),
	.sel({n00OOi, n00OlO}));
	defparam
		n00Oli.width_data = 4,
		n00Oli.width_sel = 2;
	oper_mux   n100i
	( 
	.data({{6{niOOO}}, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i, nl11l, {6{niOOO}}, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO}),
	.o(wire_n100i_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n100i.width_data = 32,
		n100i.width_sel = 5;
	oper_mux   n100l
	( 
	.data({{6{nl11i}}, {10{n11iO}}, {6{nl11i}}, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i}),
	.o(wire_n100l_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n100l.width_data = 32,
		n100l.width_sel = 5;
	oper_mux   n100O
	( 
	.data({{6{nl11l}}, {10{n11li}}, {6{nl11l}}, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i, nl11l}),
	.o(wire_n100O_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n100O.width_data = 32,
		n100O.width_sel = 5;
	oper_mux   n101i
	( 
	.data({{6{niOlO}}, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, {6{niOlO}}, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO}),
	.o(wire_n101i_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n101i.width_data = 32,
		n101i.width_sel = 5;
	oper_mux   n101l
	( 
	.data({{6{niOOi}}, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, {6{niOOi}}, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi}),
	.o(wire_n101l_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n101l.width_data = 32,
		n101l.width_sel = 5;
	oper_mux   n101O
	( 
	.data({{6{niOOl}}, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl, niOOO, nl11i, {6{niOOl}}, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, niOOl}),
	.o(wire_n101O_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n101O.width_data = 32,
		n101O.width_sel = 5;
	oper_mux   n11lO
	( 
	.data({{6{niOil}}, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, {6{niOil}}, nilOl, nilOO, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil}),
	.o(wire_n11lO_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11lO.width_data = 32,
		n11lO.width_sel = 5;
	oper_mux   n11Oi
	( 
	.data({{6{niOiO}}, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, {6{niOiO}}, nilOO, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO}),
	.o(wire_n11Oi_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11Oi.width_data = 32,
		n11Oi.width_sel = 5;
	oper_mux   n11Ol
	( 
	.data({{6{niOli}}, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, {6{niOli}}, niO1i, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli}),
	.o(wire_n11Ol_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11Ol.width_data = 32,
		n11Ol.width_sel = 5;
	oper_mux   n11OO
	( 
	.data({{6{niOll}}, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll, niOlO, niOOi, {6{niOll}}, niO1l, niO1O, niO0i, niO0l, niO0O, niOii, niOil, niOiO, niOli, niOll}),
	.o(wire_n11OO_o),
	.sel({PMADATAWIDTH, wire_n01ii_dataout, wire_n010O_dataout, wire_n010l_dataout, wire_n010i_dataout}));
	defparam
		n11OO.width_data = 32,
		n11OO.width_sel = 5;
	oper_selector   n0110i
	( 
	.data({1'b0, wire_n01Oii_dataout, wire_n01lOO_dataout}),
	.o(wire_n0110i_o),
	.sel({n11O1i, n001Oi, n001li}));
	defparam
		n0110i.width_data = 3,
		n0110i.width_sel = 3;
	oper_selector   n0110O
	( 
	.data({1'b0, wire_n01Oil_dataout, wire_n01O1i_dataout, wire_n01l1O_dataout}),
	.o(wire_n0110O_o),
	.sel({n11O1l, n001lO, n001iO, n001ll}));
	defparam
		n0110O.width_data = 4,
		n0110O.width_sel = 4;
	oper_selector   n0111l
	( 
	.data({1'b0, wire_n01Oii_dataout, wire_n01lOO_dataout}),
	.o(wire_n0111l_o),
	.sel({n11lOO, n001lO, n001iO}));
	defparam
		n0111l.width_data = 3,
		n0111l.width_sel = 3;
	oper_selector   n011il
	( 
	.data({1'b0, wire_n01Oil_dataout, wire_n01O1i_dataout, wire_n01OiO_dataout}),
	.o(wire_n011il_o),
	.sel({n11O1O, n001Oi, n001li, n001lO}));
	defparam
		n011il.width_data = 4,
		n011il.width_sel = 4;
	oper_selector   n011li
	( 
	.data({(~ n1011i), wire_n01OiO_dataout, 1'b0}),
	.o(wire_n011li_o),
	.sel({n001Ol, n001Oi, n11O0i}));
	defparam
		n011li.width_data = 3,
		n011li.width_sel = 3;
	oper_selector   n011lO
	( 
	.data({n1011i, n11OOl, n11OiO, n11OOl, n11OiO, n11Oil, {5{(~ n0001i)}}, {2{n11OiO}}}),
	.o(wire_n011lO_o),
	.sel({n001Ol, n001Oi, n001li, n001lO, n001iO, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n011lO.width_data = 13,
		n011lO.width_sel = 13;
	oper_selector   n1OllO
	( 
	.data({1'b0, wire_n01i0i_dataout, wire_n010ii_dataout, wire_n01i0i_dataout, wire_n010ii_dataout, wire_n0101O_dataout, wire_n011Oi_dataout}),
	.o(wire_n1OllO_o),
	.sel({n11lii, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OllO.width_data = 7,
		n1OllO.width_sel = 7;
	oper_selector   n1OlOi
	( 
	.data({1'b0, wire_n01i0l_dataout, wire_n010il_dataout, wire_n01i0l_dataout, wire_n010il_dataout, wire_n0100i_dataout, wire_n011Ol_dataout}),
	.o(wire_n1OlOi_o),
	.sel({n11lii, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OlOi.width_data = 7,
		n1OlOi.width_sel = 7;
	oper_selector   n1OlOO
	( 
	.data({n0101l, wire_n01iOO_dataout, {5{wire_n01ill_dataout}}, {2{wire_n0100l_dataout}}}),
	.o(wire_n1OlOO_o),
	.sel({n11lil, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OlOO.width_data = 9,
		n1OlOO.width_sel = 9;
	oper_selector   n1OO0i
	( 
	.data({1'b0, (~ n11OiO), wire_n011OO_dataout}),
	.o(wire_n1OO0i_o),
	.sel({n11liO, n0011O, n1Olll}));
	defparam
		n1OO0i.width_data = 3,
		n1OO0i.width_sel = 3;
	oper_selector   n1OO0O
	( 
	.data({1'b0, wire_n01ilO_dataout}),
	.o(wire_n1OO0O_o),
	.sel({n11lli, (~ n11lli)}));
	defparam
		n1OO0O.width_data = 2,
		n1OO0O.width_sel = 2;
	oper_selector   n1OO1l
	( 
	.data({wire_n01OOO_dataout, wire_n01O0O_dataout, wire_n01lOl_dataout, wire_n01O0O_dataout, wire_n01lOl_dataout, wire_n01l1i_dataout, {5{wire_n01ili_dataout}}, {2{wire_n01lOl_dataout}}}),
	.o(wire_n1OO1l_o),
	.sel({n001Ol, n001Oi, n001li, n001lO, n001iO, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OO1l.width_data = 13,
		n1OO1l.width_sel = 13;
	oper_selector   n1OO1O
	( 
	.data({wire_n0011i_dataout, wire_n01O0l_dataout, wire_n01lOi_dataout, wire_n01O0l_dataout, wire_n01lOi_dataout, {8{(~ n1Ol0i)}}}),
	.o(wire_n1OO1O_o),
	.sel({n001Ol, n001Oi, n001li, n001lO, n001iO, n001ll, n001il, n001ii, n0010O, n0010l, n0010i, n0011O, n1Olll}));
	defparam
		n1OO1O.width_data = 13,
		n1OO1O.width_sel = 13;
	oper_selector   n1OOii
	( 
	.data({1'b0, wire_n01i0O_dataout, wire_n010iO_dataout}),
	.o(wire_n1OOii_o),
	.sel({n11lli, n0010l, n0010i}));
	defparam
		n1OOii.width_data = 3,
		n1OOii.width_sel = 3;
	oper_selector   n1OOiO
	( 
	.data({1'b0, {2{wire_n01ilO_dataout}}, wire_n0101i_dataout}),
	.o(wire_n1OOiO_o),
	.sel({n11lll, n001ii, n0010O, n1Olll}));
	defparam
		n1OOiO.width_data = 4,
		n1OOiO.width_sel = 4;
	oper_selector   n1OOll
	( 
	.data({1'b0, wire_n01i0O_dataout, wire_n010iO_dataout}),
	.o(wire_n1OOll_o),
	.sel({n11llO, n001ii, n0010O}));
	defparam
		n1OOll.width_data = 3,
		n1OOll.width_sel = 3;
	oper_selector   n1OOOi
	( 
	.data({1'b0, wire_n01ilO_dataout, wire_n010li_dataout}),
	.o(wire_n1OOOi_o),
	.sel({n11lOi, n001il, n0010i}));
	defparam
		n1OOOi.width_data = 3,
		n1OOOi.width_sel = 3;
	oper_selector   n1OOOO
	( 
	.data({1'b0, wire_n01l1l_dataout, wire_n01iOi_dataout, wire_n010li_dataout}),
	.o(wire_n1OOOO_o),
	.sel({n11lOl, n001ll, n001il, n0010O}));
	defparam
		n1OOOO.width_data = 4,
		n1OOOO.width_sel = 4;
	oper_selector   ni010i
	( 
	.data({1'b0, niiO0i, wire_ni0i1i_dataout, niii0l, wire_ni000l_dataout}),
	.o(wire_ni010i_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni010i.width_data = 5,
		ni010i.width_sel = 5;
	oper_selector   ni010l
	( 
	.data({1'b0, niiO0l, wire_ni0i1l_dataout, niii0O, wire_ni000O_dataout}),
	.o(wire_ni010l_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni010l.width_data = 5,
		ni010l.width_sel = 5;
	oper_selector   ni010O
	( 
	.data({1'b0, niiO0O, wire_ni0i1O_dataout, niiiii, wire_ni00ii_dataout}),
	.o(wire_ni010O_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni010O.width_data = 5,
		ni010O.width_sel = 5;
	oper_selector   ni011i
	( 
	.data({1'b0, niiOli, ni1lll, niiill}),
	.o(wire_ni011i_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni011i.width_data = 4,
		ni011i.width_sel = 4;
	oper_selector   ni011O
	( 
	.data({1'b0, niiO1O, wire_ni00OO_dataout, niii0i, wire_ni000i_dataout}),
	.o(wire_ni011O_o),
	.sel({n100Ol, n100ll, ni0l1i, n100li, ni1O1i}));
	defparam
		ni011O.width_data = 5,
		ni011O.width_sel = 5;
	oper_selector   ni01iO
	( 
	.data({1'b0, wire_ni00il_dataout}),
	.o(wire_ni01iO_o),
	.sel({n100lO, (~ n100lO)}));
	defparam
		ni01iO.width_data = 2,
		ni01iO.width_sel = 2;
	oper_selector   ni01ll
	( 
	.data({1'b0, {3{wire_ni0i0l_dataout}}, {3{wire_ni00iO_dataout}}}),
	.o(wire_ni01ll_o),
	.sel({n100Ol, ni0l1O, ni0l1l, ni0l1i, ni0iOO, ni0iOl, ni1O1i}));
	defparam
		ni01ll.width_data = 7,
		ni01ll.width_sel = 7;
	oper_selector   ni01Oi
	( 
	.data({1'b0, wire_ni0i0O_dataout}),
	.o(wire_ni01Oi_o),
	.sel({n100Oi, (~ n100Oi)}));
	defparam
		ni01Oi.width_data = 2,
		ni01Oi.width_sel = 2;
	oper_selector   ni01OO
	( 
	.data({1'b0, {3{wire_ni0iii_dataout}}, {3{wire_ni00li_dataout}}}),
	.o(wire_ni01OO_o),
	.sel({n100Ol, ni0l1O, ni0l1l, ni0l1i, ni0iOO, ni0iOl, ni1O1i}));
	defparam
		ni01OO.width_data = 7,
		ni01OO.width_sel = 7;
	oper_selector   ni1OOi
	( 
	.data({1'b0, niiOii, ni1Oli, niiiil}),
	.o(wire_ni1OOi_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni1OOi.width_data = 4,
		ni1OOi.width_sel = 4;
	oper_selector   ni1OOl
	( 
	.data({1'b0, niiOil, ni1liO, niiiiO}),
	.o(wire_ni1OOl_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni1OOl.width_data = 4,
		ni1OOl.width_sel = 4;
	oper_selector   ni1OOO
	( 
	.data({1'b0, niiOiO, ni1lli, niiili}),
	.o(wire_ni1OOO_o),
	.sel({n100Ol, n100ll, n100iO, n100li}));
	defparam
		ni1OOO.width_data = 4,
		ni1OOO.width_sel = 4;
	oper_selector   nlili
	( 
	.data({wire_nll1l_dataout, wire_nliOl_dataout, 1'b0}),
	.o(wire_nlili_o),
	.sel({nlllO, nllli, nllil}));
	defparam
		nlili.width_data = 3,
		nlili.width_sel = 3;
	oper_selector   nlill
	( 
	.data({((n1O01i24 ^ n1O01i23) & wire_nll1O_dataout), ((n1O01l22 ^ n1O01l21) & n1O00O), n0000l}),
	.o(wire_nlill_o),
	.sel({nlllO, nllli, ((n1O01O20 ^ n1O01O19) & nllil)}));
	defparam
		nlill.width_data = 3,
		nlill.width_sel = 3;
	oper_selector   nlilO
	( 
	.data({n1O0OO, wire_nliOO_dataout, 1'b0}),
	.o(wire_nlilO_o),
	.sel({nlllO, ((n1O00i18 ^ n1O00i17) & nllli), nllil}));
	defparam
		nlilO.width_data = 3,
		nlilO.width_sel = 3;
	oper_selector   nliOi
	( 
	.data({wire_nll0i_dataout, wire_nll1i_dataout, (~ n0000l)}),
	.o(wire_nliOi_o),
	.sel({nlllO, ((n1O00l16 ^ n1O00l15) & nllli), nllil}));
	defparam
		nliOi.width_data = 3,
		nliOi.width_sel = 3;
	oper_selector   nlOOil
	( 
	.data({SYNC_COMP_PAT[8], SYNC_COMP_PAT[0], nlO01i}),
	.o(wire_nlOOil_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOil.width_data = 3,
		nlOOil.width_sel = 3;
	oper_selector   nlOOiO
	( 
	.data({SYNC_COMP_PAT[9], SYNC_COMP_PAT[1], nlO01l}),
	.o(wire_nlOOiO_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOiO.width_data = 3,
		nlOOiO.width_sel = 3;
	oper_selector   nlOOli
	( 
	.data({SYNC_COMP_PAT[10], SYNC_COMP_PAT[2], nlO01O}),
	.o(wire_nlOOli_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOli.width_data = 3,
		nlOOli.width_sel = 3;
	oper_selector   nlOOll
	( 
	.data({SYNC_COMP_PAT[11], SYNC_COMP_PAT[3], nlO00i}),
	.o(wire_nlOOll_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOll.width_data = 3,
		nlOOll.width_sel = 3;
	oper_selector   nlOOlO
	( 
	.data({SYNC_COMP_PAT[12], SYNC_COMP_PAT[4], nlO00l}),
	.o(wire_nlOOlO_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOlO.width_data = 3,
		nlOOlO.width_sel = 3;
	oper_selector   nlOOOi
	( 
	.data({SYNC_COMP_PAT[13], SYNC_COMP_PAT[5], nlO00O}),
	.o(wire_nlOOOi_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOOi.width_data = 3,
		nlOOOi.width_sel = 3;
	oper_selector   nlOOOl
	( 
	.data({SYNC_COMP_PAT[14], SYNC_COMP_PAT[6], nlO0ii}),
	.o(wire_nlOOOl_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOOl.width_data = 3,
		nlOOOl.width_sel = 3;
	oper_selector   nlOOOO
	( 
	.data({SYNC_COMP_PAT[15], SYNC_COMP_PAT[7], nlO0il}),
	.o(wire_nlOOOO_o),
	.sel({n1l0Ol, n1l0Oi, (~ n1l0lO)}));
	defparam
		nlOOOO.width_data = 3,
		nlOOOO.width_sel = 3;
	assign
		cg_comma = nlll0O,
		n1000i = ((n101ll & n101li) | (n101lO & n101li)),
		n1000l = (n101ll & n1l00i),
		n1000O = (nlO0iO ^ nlO0ii),
		n1001i = ((~ nlO0il) & nlO0ii),
		n1001l = (((~ wire_n0l0ii_dataout) & n101li) | (wire_n0l0ii_dataout & n1l00i)),
		n1001O = (n101ll & n1l01l),
		n100ii = (nlO0li & (nlO0iO & (nlO0il & nlO0ii))),
		n100il = (((((~ nlO0li) & (nlO0iO & n101Oi)) | (nlO0li & ((~ nlO0iO) & n101Oi))) | (nlO0li & (nlO0iO & ((~ nlO0il) & nlO0ii)))) | (nlO0li & (nlO0iO & (nlO0il & (~ nlO0ii))))),
		n100iO = (ni0l1i | ni1O1i),
		n100li = (ni0iOO | ni0iOl),
		n100ll = (ni0l1O | ni0l1l),
		n100lO = ((((ni0l0l | ni0l0i) | ni0l1O) | ni0l1l) | ni0l1i),
		n100Oi = ((((ni0l0l | ni0l0i) | ni0iOO) | ni0iOl) | ni1O1i),
		n100Ol = (ni0l0l | ni0l0i),
		n100OO = ((~ niii1O) & (~ niii1l)),
		n1010i = (nlO01l & nlO01i),
		n1010l = ((~ nlO01l) & (~ nlO01i)),
		n1010O = (nlO01l & (~ nlO01i)),
		n1011i = ((~ n0001i) | (~ nlll0O)),
		n1011l = (((GE_XAUI_SEL & nlll0O) & n1Ol0i) | nlllil),
		n1011O = ((~ nlllll) & (~ nlllil)),
		n101ii = ((~ nlO01l) & nlO01i),
		n101il = (n1l01O & n101li),
		n101iO = ((~ nlO00i) & ((~ nlO01O) & ((~ nlO01l) & (~ nlO01i)))),
		n101li = (nlO00O & nlO00l),
		n101ll = (nlO00i & (nlO01O & (nlO01l & nlO01i))),
		n101lO = (((((~ nlO00i) & (nlO01O & n1010i)) | (nlO00i & ((~ nlO01O) & n1010i))) | (nlO00i & (nlO01O & ((~ nlO01l) & nlO01i)))) | (nlO00i & (nlO01O & (nlO01l & (~ nlO01i))))),
		n101Oi = (nlO0il & nlO0ii),
		n101Ol = ((~ nlO0il) & (~ nlO0ii)),
		n101OO = (nlO0il & (~ nlO0ii)),
		n10i0i = ((~ niiO1l) & niii1l),
		n10i0l = ((((RUNDISP_SEL[0] | RUNDISP_SEL[1]) | RUNDISP_SEL[2]) | RUNDISP_SEL[3]) | RUNDISP_SEL[4]),
		n10i0O = ((((((((~ wire_ni0lOl_dataout) & (~ wire_ni0lOi_dataout)) & (~ wire_ni0llO_dataout)) & (~ wire_ni0lll_dataout)) & (~ wire_ni0lli_dataout)) & wire_ni0liO_dataout) & (~ wire_ni0lil_dataout)) & (~ wire_ni0lii_dataout)),
		n10i1i = ((~ niii1O) & niii1l),
		n10i1l = (ni1lOO & ni1lOl),
		n10i1O = ((~ niiO1l) & (~ niii1l)),
		n10iii = ((((((((~ wire_ni0lOl_dataout) & (~ wire_ni0lOi_dataout)) & (~ wire_ni0llO_dataout)) & (~ wire_ni0lll_dataout)) & (~ wire_ni0lli_dataout)) & wire_ni0liO_dataout) & (~ wire_ni0lil_dataout)) & wire_ni0lii_dataout),
		n10iil = ((((((((~ PMADATAWIDTH) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10iiO = ((((((((~ PMADATAWIDTH) | (~ niliO)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10ili = ((((((((~ PMADATAWIDTH) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ n1O1O)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10ill = ((((((((PMADATAWIDTH | (~ nilll)) | (~ nilli)) | (~ niliO)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10ilO = ((((((((PMADATAWIDTH | (~ nilli)) | (~ niliO)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10iOi = ((((((((PMADATAWIDTH | (~ niliO)) | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10iOl = ((((((((PMADATAWIDTH | (~ nilil)) | (~ nilii)) | (~ nil0O)) | (~ nil0l)) | (~ nil0i)) | (~ n1O1O)) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10iOO = ((((((((~ PMADATAWIDTH) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10l0i = ((((((((PMADATAWIDTH | nilli) | niliO) | nilil) | nilii) | nil0O) | nil0l) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10l0l = ((((((((PMADATAWIDTH | niliO) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10l0O = ((((((((PMADATAWIDTH | nilil) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10l1i = ((((((((~ PMADATAWIDTH) | niliO) | nilil) | nilii) | nil0O) | nil0l) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10l1l = ((((((((~ PMADATAWIDTH) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10l1O = ((((((((PMADATAWIDTH | nilll) | nilli) | niliO) | nilil) | nilii) | nil0O) | (~ wire_niii1i_dataout)) | (~ nii11i)),
		n10lii = (((((~ n10O1i) | (~ n10lOO)) | (~ n10lOi)) | (~ n10lll)) | n10lil),
		n10lil = (((((((((n1O1O & (~ n1ii1i)) & (~ n1i0li)) & (~ n1i0iO)) & (~ n1i0il)) & (~ n1i0ii)) & (~ n1i00O)) & (~ n1i00l)) & (~ n1i01O)) & (~ n1i01l)),
		n10liO = ((((n1i01l | (~ n10lOO)) | (~ n10lOl)) | (~ n10lll)) | (~ n10lli)),
		n10lli = ((((((((n1ii1i | (~ n1i0li)) | n1i0iO) | n1i0il) | n1i0ii) | n1i00O) | n1i00l) | n1i01O) | n1i01l),
		n10lll = (((((((n1ii1i | (~ n1i0iO)) | n1i0il) | n1i0ii) | n1i00O) | n1i00l) | n1i01O) | n1i01l),
		n10llO = ((((((n1ii1i | (~ n1i0il)) | n1i0ii) | n1i00O) | n1i00l) | n1i01O) | n1i01l),
		n10lOi = (((((n1ii1i | (~ n1i0ii)) | n1i00O) | n1i00l) | n1i01O) | n1i01l),
		n10lOl = ((((n1ii1i | (~ n1i00O)) | n1i00l) | n1i01O) | n1i01l),
		n10lOO = (((n1ii1i | (~ n1i00l)) | n1i01O) | n1i01l),
		n10O0i = ((((n1i0ll | (~ n10Oli)) | (~ n10OiO)) | (~ n10O0O)) | (~ n10O0l)),
		n10O0l = (((((((((~ n1iiOl) | n1iiOi) | n1iilO) | n1iiiO) | n1ii0O) | n1ii1O) | n1i0OO) | n1i0Oi) | n1i0ll),
		n10O0O = ((((((((~ n1iiOi) | n1iilO) | n1iiiO) | n1ii0O) | n1ii1O) | n1i0OO) | n1i0Oi) | n1i0ll),
		n10O1i = ((~ n1i01O) | n1i01l),
		n10O1l = (((((~ n10Oll) | (~ n10Oli)) | (~ n10Oil)) | (~ n10O0O)) | n10O1O),
		n10O1O = ((((((((((n1il1i | n1iiOO) & (~ n1iiOl)) & (~ n1iiOi)) & (~ n1iilO)) & (~ n1iiiO)) & (~ n1ii0O)) & (~ n1ii1O)) & (~ n1i0OO)) & (~ n1i0Oi)) & (~ n1i0ll)),
		n10Oii = (((((((~ n1iilO) | n1iiiO) | n1ii0O) | n1ii1O) | n1i0OO) | n1i0Oi) | n1i0ll),
		n10Oil = ((((((~ n1iiiO) | n1ii0O) | n1ii1O) | n1i0OO) | n1i0Oi) | n1i0ll),
		n10OiO = (((((~ n1ii0O) | n1ii1O) | n1i0OO) | n1i0Oi) | n1i0ll),
		n10Oli = ((((~ n1ii1O) | n1i0OO) | n1i0Oi) | n1i0ll),
		n10Oll = ((~ n1i0Oi) | n1i0ll),
		n10OlO = (((((~ n1i10O) | (~ n1i10l)) | (~ n1i11O)) | (~ n1i11i)) | n10OOi),
		n10OOi = ((((((((((~ n1O1O) & n1iO1i) & n1illi) & n1iliO) & n1ilil) & n1ilii) & n1il0O) & n1il0l) & (~ n1il1O)) & (~ n1il1l)),
		n10OOl = ((((n1il1l | (~ n1i10l)) | (~ n1i10i)) | (~ n1i11i)) | (~ n10OOO)),
		n10OOO = (((((((((~ n1iO1i) | n1illi) | (~ n1iliO)) | (~ n1ilil)) | (~ n1ilii)) | (~ n1il0O)) | (~ n1il0l)) | n1il1O) | n1il1l),
		n11lii = ((((((n001Ol | n001Oi) | n001lO) | n001ll) | n001li) | n001iO) | n001il),
		n11lil = ((((n001Ol | n001Oi) | n001lO) | n001li) | n001iO),
		n11liO = ((((((((((n001Ol | n001Oi) | n001lO) | n001ll) | n001li) | n001iO) | n001il) | n001ii) | n0010O) | n0010l) | n0010i),
		n11lli = ((((((((((n001Ol | n001Oi) | n001lO) | n001ll) | n001li) | n001iO) | n001il) | n001ii) | n0010O) | n0011O) | n1Olll),
		n11lll = (((((((((n001Ol | n001Oi) | n001lO) | n001ll) | n001li) | n001iO) | n001il) | n0010l) | n0010i) | n0011O),
		n11llO = ((((((((((n001Ol | n001Oi) | n001lO) | n001ll) | n001li) | n001iO) | n001il) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11lOi = ((((((((((n001Ol | n001Oi) | n001lO) | n001ll) | n001li) | n001iO) | n001ii) | n0010O) | n0010l) | n0011O) | n1Olll),
		n11lOl = (((((((((n001Ol | n001Oi) | n001lO) | n001li) | n001iO) | n001ii) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11lOO = ((((((((((n001Ol | n001Oi) | n001ll) | n001li) | n001il) | n001ii) | n0010O) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11O0i = ((((((((((n001lO | n001ll) | n001li) | n001iO) | n001il) | n001ii) | n0010O) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11O0l = (((~ n1011l) & n0001i) & (n1Olli & n1Ol0O)),
		n11O0O = (n1011l & n0001i),
		n11O1i = ((((((((((n001Ol | n001lO) | n001ll) | n001iO) | n001il) | n001ii) | n0010O) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11O1l = (((((((((n001Ol | n001Oi) | n001li) | n001il) | n001ii) | n0010O) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11O1O = (((((((((n001Ol | n001ll) | n001iO) | n001il) | n001ii) | n0010O) | n0010l) | n0010i) | n0011O) | n1Olll),
		n11Oii = (n11OOi | n11Oll),
		n11Oil = ((~ n0001i) | n11OOO),
		n11OiO = (n1011l | (~ n0001i)),
		n11Oli = (n0001i & ((~ n1Ol0i) & nlll0O)),
		n11Oll = (n0001i & ((~ GE_XAUI_SEL) & nlll0O)),
		n11OlO = (n0001i & n11OOi),
		n11OOi = (GE_XAUI_SEL & n1011O),
		n11OOl = ((~ n0001i) | n11OOO),
		n11OOO = ((GE_XAUI_SEL & (~ n1011O)) | ((~ GE_XAUI_SEL) & nlllil)),
		n1i00i = ((((((((nilll & nilli) & niliO) & nilil) & nilii) & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i00l = ((((((niliO & nilil) & nilii) & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i00O = (((((nilil & nilii) & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i01i = ((~ n1ilOi) | n1illl),
		n1i01l = ((~ PMADATAWIDTH) & n1i0lO),
		n1i01O = ((~ PMADATAWIDTH) & n1i00i),
		n1i0ii = ((((nilii & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i0il = (((nil0O & nil0l) & nil0i) & n1O1O),
		n1i0iO = ((nil0l & nil0i) & n1O1O),
		n1i0li = (nil0i & n1O1O),
		n1i0ll = ((~ PMADATAWIDTH) & n1i0lO),
		n1i0lO = (((((((((nilOi & nilll) & nilli) & niliO) & nilil) & nilii) & nil0O) & nil0l) & nil0i) & n1O1O),
		n1i0Oi = ((~ PMADATAWIDTH) & n1i0Ol),
		n1i0Ol = ((((((((nilOi & nilll) & nilli) & niliO) & nilil) & nilii) & nil0O) & nil0l) & nil0i),
		n1i0OO = (((~ PMADATAWIDTH) & n1ii1l) | (PMADATAWIDTH & n1ii1i)),
		n1i10i = (((((~ n1iO1i) | n1il0O) | (~ n1il0l)) | n1il1O) | n1il1l),
		n1i10l = ((((~ n1iO1i) | n1il0l) | n1il1O) | n1il1l),
		n1i10O = ((~ n1il1O) | n1il1l),
		n1i11i = ((((((((~ n1iO1i) | n1iliO) | (~ n1ilil)) | (~ n1ilii)) | (~ n1il0O)) | (~ n1il0l)) | n1il1O) | n1il1l),
		n1i11l = (((((((~ n1iO1i) | n1ilil) | (~ n1ilii)) | (~ n1il0O)) | (~ n1il0l)) | n1il1O) | n1il1l),
		n1i11O = ((((((~ n1iO1i) | n1ilii) | (~ n1il0O)) | (~ n1il0l)) | n1il1O) | n1il1l),
		n1i1ii = (((((~ n1i01i) | (~ n1i1OO)) | (~ n1i1Oi)) | (~ n1i1ll)) | n1i1il),
		n1i1il = ((((((((((((~ PMADATAWIDTH) & (~ nilOi)) | (PMADATAWIDTH & (~ nilli))) & (~ n1iOOl)) & (~ n1iOOi)) & (~ n1iOlO)) & (~ n1iOiO)) & (~ n1iO0O)) & (~ n1iO1O)) & (~ n1ilOO)) & (~ n1ilOi)) & (~ n1illl)),
		n1i1iO = ((((n1illl | (~ n1i1OO)) | (~ n1i1Ol)) | (~ n1i1ll)) | (~ n1i1li)),
		n1i1li = (((((((((~ n1iOOl) | n1iOOi) | n1iOlO) | n1iOiO) | n1iO0O) | n1iO1O) | n1ilOO) | n1ilOi) | n1illl),
		n1i1ll = ((((((((~ n1iOOi) | n1iOlO) | n1iOiO) | n1iO0O) | n1iO1O) | n1ilOO) | n1ilOi) | n1illl),
		n1i1lO = (((((((~ n1iOlO) | n1iOiO) | n1iO0O) | n1iO1O) | n1ilOO) | n1ilOi) | n1illl),
		n1i1Oi = ((((((~ n1iOiO) | n1iO0O) | n1iO1O) | n1ilOO) | n1ilOi) | n1illl),
		n1i1Ol = (((((~ n1iO0O) | n1iO1O) | n1ilOO) | n1ilOi) | n1illl),
		n1i1OO = ((((~ n1iO1O) | n1ilOO) | n1ilOi) | n1illl),
		n1ii0i = ((((((nilli & niliO) & nilil) & nilii) & nil0O) & nil0l) & nil0i),
		n1ii0l = ((((((nilOi & nilll) & nilli) & niliO) & nilil) & nilii) & nil0O),
		n1ii0O = (((~ PMADATAWIDTH) & n1iiil) | (PMADATAWIDTH & n1iiii)),
		n1ii1i = (((((((nilli & niliO) & nilil) & nilii) & nil0O) & nil0l) & nil0i) & n1O1O),
		n1ii1l = (((((((nilOi & nilll) & nilli) & niliO) & nilil) & nilii) & nil0O) & nil0l),
		n1ii1O = (((~ PMADATAWIDTH) & n1ii0l) | (PMADATAWIDTH & n1ii0i)),
		n1iiii = (((((nilli & niliO) & nilil) & nilii) & nil0O) & nil0l),
		n1iiil = (((((nilOi & nilll) & nilli) & niliO) & nilil) & nilii),
		n1iiiO = (((~ PMADATAWIDTH) & n1iill) | (PMADATAWIDTH & n1iili)),
		n1iili = ((((nilli & niliO) & nilil) & nilii) & nil0O),
		n1iill = ((((nilOi & nilll) & nilli) & niliO) & nilil),
		n1iilO = (((~ PMADATAWIDTH) & (((nilOi & nilll) & nilli) & niliO)) | (PMADATAWIDTH & (((nilli & niliO) & nilil) & nilii))),
		n1iiOi = (((~ PMADATAWIDTH) & ((nilOi & nilll) & nilli)) | (PMADATAWIDTH & ((nilli & niliO) & nilil))),
		n1iiOl = (((~ PMADATAWIDTH) & (nilOi & nilll)) | (PMADATAWIDTH & (nilli & niliO))),
		n1iiOO = (PMADATAWIDTH & nilli),
		n1il0i = ((((((((nilll | nilli) | niliO) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O),
		n1il0l = ((((((niliO | nilil) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O),
		n1il0O = (((((nilil | nilii) | nil0O) | nil0l) | nil0i) | n1O1O),
		n1il1i = ((~ PMADATAWIDTH) & nilOi),
		n1il1l = ((~ PMADATAWIDTH) & (~ n1illO)),
		n1il1O = ((~ PMADATAWIDTH) & (~ n1il0i)),
		n1ilii = ((((nilii | nil0O) | nil0l) | nil0i) | n1O1O),
		n1ilil = (((nil0O | nil0l) | nil0i) | n1O1O),
		n1iliO = ((nil0l | nil0i) | n1O1O),
		n1illi = (nil0i | n1O1O),
		n1illl = ((~ PMADATAWIDTH) & (~ n1illO)),
		n1illO = (((((((((nilOi | nilll) | nilli) | niliO) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O),
		n1ilOi = ((~ PMADATAWIDTH) & (~ n1ilOl)),
		n1ilOl = ((((((((nilOi | nilll) | nilli) | niliO) | nilil) | nilii) | nil0O) | nil0l) | nil0i),
		n1ilOO = (((~ PMADATAWIDTH) & (~ n1iO1l)) | (PMADATAWIDTH & (~ n1iO1i))),
		n1iO0i = ((((((nilli | niliO) | nilil) | nilii) | nil0O) | nil0l) | nil0i),
		n1iO0l = ((((((nilOi | nilll) | nilli) | niliO) | nilil) | nilii) | nil0O),
		n1iO0O = (((~ PMADATAWIDTH) & (~ n1iOil)) | (PMADATAWIDTH & (~ n1iOii))),
		n1iO1i = (((((((nilli | niliO) | nilil) | nilii) | nil0O) | nil0l) | nil0i) | n1O1O),
		n1iO1l = (((((((nilOi | nilll) | nilli) | niliO) | nilil) | nilii) | nil0O) | nil0l),
		n1iO1O = (((~ PMADATAWIDTH) & (~ n1iO0l)) | (PMADATAWIDTH & (~ n1iO0i))),
		n1iOii = (((((nilli | niliO) | nilil) | nilii) | nil0O) | nil0l),
		n1iOil = (((((nilOi | nilll) | nilli) | niliO) | nilil) | nilii),
		n1iOiO = (((~ PMADATAWIDTH) & (~ n1iOll)) | (PMADATAWIDTH & (~ n1iOli))),
		n1iOli = ((((nilli | niliO) | nilil) | nilii) | nil0O),
		n1iOll = ((((nilOi | nilll) | nilli) | niliO) | nilil),
		n1iOlO = (((~ PMADATAWIDTH) & (~ (((nilOi | nilll) | nilli) | niliO))) | (PMADATAWIDTH & (~ (((nilli | niliO) | nilil) | nilii)))),
		n1iOOi = (((~ PMADATAWIDTH) & (~ ((nilOi | nilll) | nilli))) | (PMADATAWIDTH & (~ ((nilli | niliO) | nilil)))),
		n1iOOl = (((~ PMADATAWIDTH) & (~ (nilOi | nilll))) | (PMADATAWIDTH & (~ (nilli | niliO)))),
		n1iOOO = ((((((((((~ ((~ SYNC_COMP_PAT[0]) ^ nlO01i)) & (~ ((~ SYNC_COMP_PAT[1]) ^ nlO01l))) & (~ ((~ SYNC_COMP_PAT[2]) ^ nlO01O))) & (~ ((~ SYNC_COMP_PAT[3]) ^ nlO00i))) & (~ ((~ SYNC_COMP_PAT[4]) ^ nlO00l))) & (~ ((~ SYNC_COMP_PAT[5]) ^ nlO00O))) & (~ ((~ SYNC_COMP_PAT[6]) ^ nlO0ii))) & (~ ((~ SYNC_COMP_PAT[7]) ^ nlO0il))) & (~ ((~ SYNC_COMP_PAT[8]) ^ nlO0iO))) & (~ ((~ SYNC_COMP_PAT[9]) ^ nlO0li))),
		n1l00i = ((~ nlO00O) & (~ nlO00l)),
		n1l00l = (((((((~ nlO00i) & ((~ nlO01O) & (nlO01l & nlO01i))) | ((~ nlO00i) & (nlO01O & n101ii))) | ((~ nlO00i) & (nlO01O & n1010O))) | (nlO00i & ((~ nlO01O) & n101ii))) | (nlO00i & ((~ nlO01O) & n1010O))) | (nlO00i & (nlO01O & ((~ nlO01l) & (~ nlO01i))))),
		n1l00O = (n1l01O & n1l00i),
		n1l01i = (n101iO & n101li),
		n1l01l = (((~ nlO00O) & nlO00l) | (nlO00O & (~ nlO00l))),
		n1l01O = (((((~ nlO00i) & ((~ nlO01O) & ((~ nlO01l) & nlO01i))) | ((~ nlO00i) & ((~ nlO01O) & (nlO01l & (~ nlO01i))))) | ((~ nlO00i) & (nlO01O & n1010l))) | (nlO00i & ((~ nlO01O) & n1010l))),
		n1l0ii = (n101iO & n1l01l),
		n1l0il = (n101iO & n1l00i),
		n1l0iO = (PMADATAWIDTH & (~ n1l0ll)),
		n1l0li = (n1lli & (PMADATAWIDTH & n1lll)),
		n1l0ll = (n1lll & n1lli),
		n1l0lO = (n1l0Ol | n1l0Oi),
		n1l0Oi = (n1lll & (~ n1lli)),
		n1l0Ol = (n1lll & n1lli),
		n1l10i = ((~ nlO00O) & ((~ nlO00l) & ((~ nlO00i) & ((~ nlO01O) & (nlO01l & nlO01i))))),
		n1l10l = (nlO00O & (nlO00l & (nlO00i & (nlO01O & ((~ nlO01l) & (~ nlO01i)))))),
		n1l10O = ((~ ((IB_INVALID_CODE[0] & ((((~ nlO0il) & n1l10l) & n1000O) | ((nlO0il & n1l10i) & n1000O))) | (IB_INVALID_CODE[1] & ((nlO0iO & (nlO0il & (n1l10l & n1l1il))) | ((~ nlO0iO) & ((~ nlO0il) & (n1l10i & n1l1il))))))) & ((~ ((n1000l | (n1000i | n1001O)) | (n1l01i | (n1l0ii | (n1l0il | n1l00O))))) & (~ (((n100ii | n1l1li) | ((~ (((n1l10l | n1l10i) | n1l11l) | n1l11O)) & ((~ n1001l) & (((~ nlO0ii) & n100il) | (nlO0ii & n1l1ll))))) | ((((~ nlO0li) & n100il) | (nlO0li & n1l1ll)) & (n1l10i | (n1l10l | n1001l))))))),
		n1l11i = ((((((((((~ (SYNC_COMP_PAT[0] ^ nlO01i)) & (~ (SYNC_COMP_PAT[1] ^ nlO01l))) & (~ (SYNC_COMP_PAT[2] ^ nlO01O))) & (~ (SYNC_COMP_PAT[3] ^ nlO00i))) & (~ (SYNC_COMP_PAT[4] ^ nlO00l))) & (~ (SYNC_COMP_PAT[5] ^ nlO00O))) & (~ (SYNC_COMP_PAT[6] ^ nlO0ii))) & (~ (SYNC_COMP_PAT[7] ^ nlO0il))) & (~ (SYNC_COMP_PAT[8] ^ nlO0iO))) & (~ (SYNC_COMP_PAT[9] ^ nlO0li))),
		n1l11l = (nlO00O & ((~ nlO00l) & n1l01O)),
		n1l11O = ((~ nlO00O) & (nlO00l & n101lO)),
		n1l1ii = ((~ DISABLE_RX_DISP) & (((((~ nlll0l) & ((((((n1l0il | n1l0ii) | n1l00O) | (n1l00l & n1l00i)) | (n1l01O & n1l01l)) | n1l01i) | n1l1OO)) | (nlll0l & (n1l1Ol | ((~ nlO00i) & n1l1Oi)))) | ((n1l1lO | (n1l1ll | n1l1li)) & (~ wire_n0l0ii_dataout))) | ((n1l1iO | (nlO0il & (nlO0ii & n1l1il))) & wire_n0l0ii_dataout))),
		n1l1il = (((((((~ nlO0li) & ((~ nlO0iO) & (nlO0il & nlO0ii))) | ((~ nlO0li) & (nlO0iO & n1001i))) | ((~ nlO0li) & (nlO0iO & n101OO))) | (nlO0li & ((~ nlO0iO) & n1001i))) | (nlO0li & ((~ nlO0iO) & n101OO))) | (nlO0li & (nlO0iO & ((~ nlO0il) & (~ nlO0ii))))),
		n1l1iO = (n100il | n100ii),
		n1l1li = ((~ nlO0li) & ((~ nlO0iO) & ((~ nlO0il) & (~ nlO0ii)))),
		n1l1ll = (((((~ nlO0li) & ((~ nlO0iO) & ((~ nlO0il) & nlO0ii))) | ((~ nlO0li) & ((~ nlO0iO) & (nlO0il & (~ nlO0ii))))) | ((~ nlO0li) & (nlO0iO & n101Ol))) | (nlO0li & ((~ nlO0iO) & n101Ol))),
		n1l1lO = ((~ nlO0il) & ((~ nlO0ii) & n1l1il)),
		n1l1Oi = (n101lO & n1l00i),
		n1l1Ol = ((((n1000i | (n1l00l & n101li)) | (n101lO & n1l01l)) | n1001O) | n1000l),
		n1l1OO = (nlO00i & n101il),
		n1li0i = ((((~ n10OO) & (~ n10Oi)) & (~ n10lO)) & (~ n10li)),
		n1li0O = (wire_n1Olii_dataout & (~ (((n1O0Ol & n1O0Oi) & n1O0lO) & (~ n1O0ll)))),
		n1li1l = (PMADATAWIDTH & n1li0i),
		n1li1O = ((~ PMADATAWIDTH) & n1li0i),
		n1liii = (((((((((wire_n01il_dataout | (~ n1ll1i)) | (~ n1liOO)) | (~ n1liOl)) | (~ n1liOi)) | (~ n1lilO)) | (~ n1lill)) | (~ n1lili)) | (~ n1liiO)) | n1liil),
		n1liil = (((((((((wire_n0i1O_dataout & (~ wire_n00OO_dataout)) & (~ wire_n00lO_dataout)) & (~ wire_n00iO_dataout)) & (~ wire_n000O_dataout)) & (~ wire_n001O_dataout)) & (~ wire_n01OO_dataout)) & (~ wire_n01lO_dataout)) & (~ wire_n01li_dataout)) & (~ wire_n01il_dataout)),
		n1liiO = (((((((((~ wire_n00OO_dataout) | wire_n00lO_dataout) | wire_n00iO_dataout) | wire_n000O_dataout) | wire_n001O_dataout) | wire_n01OO_dataout) | wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1lili = ((((((((~ wire_n00lO_dataout) | wire_n00iO_dataout) | wire_n000O_dataout) | wire_n001O_dataout) | wire_n01OO_dataout) | wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1lill = (((((((~ wire_n00iO_dataout) | wire_n000O_dataout) | wire_n001O_dataout) | wire_n01OO_dataout) | wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1lilO = ((((((~ wire_n000O_dataout) | wire_n001O_dataout) | wire_n01OO_dataout) | wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1liOi = (((((~ wire_n001O_dataout) | wire_n01OO_dataout) | wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1liOl = ((((~ wire_n01OO_dataout) | wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1liOO = (((~ wire_n01lO_dataout) | wire_n01li_dataout) | wire_n01il_dataout),
		n1ll0i = ((((((((((~ (wire_ni0iO_dataout ^ wire_n0lll_dataout)) & (~ (wire_ni0li_dataout ^ wire_n0llO_dataout))) & (~ (wire_ni0ll_dataout ^ wire_n0lOi_dataout))) & (~ (wire_ni0lO_dataout ^ wire_n0lOl_dataout))) & (~ (wire_ni0Oi_dataout ^ wire_n0lOO_dataout))) & (~ (wire_ni0Ol_dataout ^ wire_n0O1i_dataout))) & (~ (wire_ni0OO_dataout ^ wire_n0O1l_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0O1O_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0O0i_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0O0l_dataout))),
		n1ll0l = ((((((((((~ (SYNC_COMP_PAT[0] ^ wire_n0lll_dataout)) & (~ (SYNC_COMP_PAT[1] ^ wire_n0llO_dataout))) & (~ (SYNC_COMP_PAT[2] ^ wire_n0lOi_dataout))) & (~ (SYNC_COMP_PAT[3] ^ wire_n0lOl_dataout))) & (~ (SYNC_COMP_PAT[4] ^ wire_n0lOO_dataout))) & (~ (SYNC_COMP_PAT[5] ^ wire_n0O1i_dataout))) & (~ (SYNC_COMP_PAT[6] ^ wire_n0O1l_dataout))) & (~ (wire_niiOl_dataout ^ wire_n0O1O_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0O0i_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0O0l_dataout))),
		n1ll0O = ((((((((((~ (niOll ^ wire_ni0iO_dataout)) & (~ (niOlO ^ wire_ni0li_dataout))) & (~ (niOOi ^ wire_ni0ll_dataout))) & (~ (niOOl ^ wire_ni0lO_dataout))) & (~ (niOOO ^ wire_ni0Oi_dataout))) & (~ (nl11i ^ wire_ni0Ol_dataout))) & (~ (nl11l ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0Oii_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0Oil_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0OiO_dataout))),
		n1ll1i = ((~ wire_n01li_dataout) | wire_n01il_dataout),
		n1ll1l = ((((((((((~ (wire_ni0iO_dataout ^ wire_n0i0O_dataout)) & (~ (wire_ni0li_dataout ^ wire_n0iii_dataout))) & (~ (wire_ni0ll_dataout ^ wire_n0iil_dataout))) & (~ (wire_ni0lO_dataout ^ wire_n0iiO_dataout))) & (~ (wire_ni0Oi_dataout ^ wire_n0ili_dataout))) & (~ (wire_ni0Ol_dataout ^ wire_n0ill_dataout))) & (~ (wire_ni0OO_dataout ^ wire_n0ilO_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0iOi_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0iOl_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0iOO_dataout))),
		n1ll1O = ((((((((((~ (SYNC_COMP_PAT[0] ^ wire_n0i0O_dataout)) & (~ (SYNC_COMP_PAT[1] ^ wire_n0iii_dataout))) & (~ (SYNC_COMP_PAT[2] ^ wire_n0iil_dataout))) & (~ (SYNC_COMP_PAT[3] ^ wire_n0iiO_dataout))) & (~ (SYNC_COMP_PAT[4] ^ wire_n0ili_dataout))) & (~ (SYNC_COMP_PAT[5] ^ wire_n0ill_dataout))) & (~ (SYNC_COMP_PAT[6] ^ wire_n0ilO_dataout))) & (~ (wire_niiOl_dataout ^ wire_n0iOi_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0iOl_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0iOO_dataout))),
		n1llii = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOll)) & (~ (SYNC_COMP_PAT[1] ^ niOlO))) & (~ (SYNC_COMP_PAT[2] ^ niOOi))) & (~ (SYNC_COMP_PAT[3] ^ niOOl))) & (~ (SYNC_COMP_PAT[4] ^ niOOO))) & (~ (SYNC_COMP_PAT[5] ^ nl11i))) & (~ (SYNC_COMP_PAT[6] ^ nl11l))) & (~ (wire_niiOl_dataout ^ wire_n0Oii_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0Oil_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0OiO_dataout))),
		n1llil = ((((((((((~ (niOlO ^ wire_ni0iO_dataout)) & (~ (niOOi ^ wire_ni0li_dataout))) & (~ (niOOl ^ wire_ni0ll_dataout))) & (~ (niOOO ^ wire_ni0lO_dataout))) & (~ (nl11i ^ wire_ni0Oi_dataout))) & (~ (nl11l ^ wire_ni0Ol_dataout))) & (~ (nl11O ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0Oll_dataout))) & (~ (wire_nii1l_dataout ^ wire_n0OlO_dataout))) & (~ (wire_nii1O_dataout ^ wire_n0OOi_dataout))),
		n1lliO = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOlO)) & (~ (SYNC_COMP_PAT[1] ^ niOOi))) & (~ (SYNC_COMP_PAT[2] ^ niOOl))) & (~ (SYNC_COMP_PAT[3] ^ niOOO))) & (~ (SYNC_COMP_PAT[4] ^ nl11i))) & (~ (SYNC_COMP_PAT[5] ^ nl11l))) & (~ (SYNC_COMP_PAT[6] ^ nl11O))) & (~ (wire_niiOl_dataout ^ wire_n0Oll_dataout))) & (~ (wire_niiOO_dataout ^ wire_n0OlO_dataout))) & (~ (wire_nil1i_dataout ^ wire_n0OOi_dataout))),
		n1llli = ((((((((((~ (niOOi ^ wire_ni0iO_dataout)) & (~ (niOOl ^ wire_ni0li_dataout))) & (~ (niOOO ^ wire_ni0ll_dataout))) & (~ (nl11i ^ wire_ni0lO_dataout))) & (~ (nl11l ^ wire_ni0Oi_dataout))) & (~ (nl11O ^ wire_ni0Ol_dataout))) & (~ (nl10i ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_n0OOO_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni11i_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni11l_dataout))),
		n1llll = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOOi)) & (~ (SYNC_COMP_PAT[1] ^ niOOl))) & (~ (SYNC_COMP_PAT[2] ^ niOOO))) & (~ (SYNC_COMP_PAT[3] ^ nl11i))) & (~ (SYNC_COMP_PAT[4] ^ nl11l))) & (~ (SYNC_COMP_PAT[5] ^ nl11O))) & (~ (SYNC_COMP_PAT[6] ^ nl10i))) & (~ (wire_niiOl_dataout ^ wire_n0OOO_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni11i_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni11l_dataout))),
		n1lllO = ((((((((((~ (niOOl ^ wire_ni0iO_dataout)) & (~ (niOOO ^ wire_ni0li_dataout))) & (~ (nl11i ^ wire_ni0ll_dataout))) & (~ (nl11l ^ wire_ni0lO_dataout))) & (~ (nl11O ^ wire_ni0Oi_dataout))) & (~ (nl10i ^ wire_ni0Ol_dataout))) & (~ (nl10l ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_ni10i_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni10l_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni10O_dataout))),
		n1llOi = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOOl)) & (~ (SYNC_COMP_PAT[1] ^ niOOO))) & (~ (SYNC_COMP_PAT[2] ^ nl11i))) & (~ (SYNC_COMP_PAT[3] ^ nl11l))) & (~ (SYNC_COMP_PAT[4] ^ nl11O))) & (~ (SYNC_COMP_PAT[5] ^ nl10i))) & (~ (SYNC_COMP_PAT[6] ^ nl10l))) & (~ (wire_niiOl_dataout ^ wire_ni10i_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni10l_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni10O_dataout))),
		n1lO0i = ((((((((((~ (SYNC_COMP_PAT[0] ^ niOOO)) & (~ (SYNC_COMP_PAT[1] ^ nl11i))) & (~ (SYNC_COMP_PAT[2] ^ nl11l))) & (~ (SYNC_COMP_PAT[3] ^ nl11O))) & (~ (SYNC_COMP_PAT[4] ^ nl10i))) & (~ (SYNC_COMP_PAT[5] ^ nl10l))) & (~ (SYNC_COMP_PAT[6] ^ nl10O))) & (~ (wire_niiOl_dataout ^ wire_ni1il_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni1iO_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni1li_dataout))),
		n1lO1O = ((((((((((~ (niOOO ^ wire_ni0iO_dataout)) & (~ (nl11i ^ wire_ni0li_dataout))) & (~ (nl11l ^ wire_ni0ll_dataout))) & (~ (nl11O ^ wire_ni0lO_dataout))) & (~ (nl10i ^ wire_ni0Oi_dataout))) & (~ (nl10l ^ wire_ni0Ol_dataout))) & (~ (nl10O ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_ni1il_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni1iO_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni1li_dataout))),
		n1lOll = ((((((((((~ (nl11i ^ wire_ni0iO_dataout)) & (~ (nl11l ^ wire_ni0li_dataout))) & (~ (nl11O ^ wire_ni0ll_dataout))) & (~ (nl10i ^ wire_ni0lO_dataout))) & (~ (nl10l ^ wire_ni0Oi_dataout))) & (~ (nl10O ^ wire_ni0Ol_dataout))) & (~ (nl1ii ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_ni1lO_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni1Oi_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni1Ol_dataout))),
		n1lOlO = ((((((((((~ (SYNC_COMP_PAT[0] ^ nl11i)) & (~ (SYNC_COMP_PAT[1] ^ nl11l))) & (~ (SYNC_COMP_PAT[2] ^ nl11O))) & (~ (SYNC_COMP_PAT[3] ^ nl10i))) & (~ (SYNC_COMP_PAT[4] ^ nl10l))) & (~ (SYNC_COMP_PAT[5] ^ nl10O))) & (~ (SYNC_COMP_PAT[6] ^ nl1ii))) & (~ (wire_niiOl_dataout ^ wire_ni1lO_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni1Oi_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni1Ol_dataout))),
		n1O00O = ((n0000l & (~ n1Oi1O)) & (n1O0ii14 ^ n1O0ii13)),
		n1O0ll = (((((~ n1ll1i) | (~ n1liOl)) | (~ n1lilO)) | (~ n1lili)) | n1liil),
		n1O0lO = (((((~ n1liOO) | (~ n1liOl)) | (~ n1lill)) | (~ n1lili)) | (~ n1liii)),
		n1O0Oi = (((((~ n1liOO) | (~ n1liOl)) | (~ n1liOi)) | (~ n1lilO)) | (~ n1liii)),
		n1O0Ol = ((wire_n01il_dataout | (~ n1ll1i)) | (~ n1liii)),
		n1O0OO = ((n0000l & n1Oi1O) & (n1Oi1i10 ^ n1Oi1i9)),
		n1O11l = ((((((((((~ (nl11l ^ wire_ni0iO_dataout)) & (~ (nl11O ^ wire_ni0li_dataout))) & (~ (nl10i ^ wire_ni0ll_dataout))) & (~ (nl10l ^ wire_ni0lO_dataout))) & (~ (nl10O ^ wire_ni0Oi_dataout))) & (~ (nl1ii ^ wire_ni0Ol_dataout))) & (~ (nl1il ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_ni01i_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni01l_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni01O_dataout))),
		n1O11O = ((((((((((~ (SYNC_COMP_PAT[0] ^ nl11l)) & (~ (SYNC_COMP_PAT[1] ^ nl11O))) & (~ (SYNC_COMP_PAT[2] ^ nl10i))) & (~ (SYNC_COMP_PAT[3] ^ nl10l))) & (~ (SYNC_COMP_PAT[4] ^ nl10O))) & (~ (SYNC_COMP_PAT[5] ^ nl1ii))) & (~ (SYNC_COMP_PAT[6] ^ nl1il))) & (~ (wire_niiOl_dataout ^ wire_ni01i_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni01l_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni01O_dataout))),
		n1O1li = ((((((((((~ (nl11O ^ wire_ni0iO_dataout)) & (~ (nl10i ^ wire_ni0li_dataout))) & (~ (nl10l ^ wire_ni0ll_dataout))) & (~ (nl10O ^ wire_ni0lO_dataout))) & (~ (nl1ii ^ wire_ni0Oi_dataout))) & (~ (nl1il ^ wire_ni0Ol_dataout))) & (~ (nl1iO ^ wire_ni0OO_dataout))) & (~ (wire_nii1i_dataout ^ wire_ni00l_dataout))) & (~ (wire_nii1l_dataout ^ wire_ni00O_dataout))) & (~ (wire_nii1O_dataout ^ wire_ni0ii_dataout))),
		n1O1ll = ((((((((((~ (SYNC_COMP_PAT[0] ^ nl11O)) & (~ (SYNC_COMP_PAT[1] ^ nl10i))) & (~ (SYNC_COMP_PAT[2] ^ nl10l))) & (~ (SYNC_COMP_PAT[3] ^ nl10O))) & (~ (SYNC_COMP_PAT[4] ^ nl1ii))) & (~ (SYNC_COMP_PAT[5] ^ nl1il))) & (~ (SYNC_COMP_PAT[6] ^ nl1iO))) & (~ (wire_niiOl_dataout ^ wire_ni00l_dataout))) & (~ (wire_niiOO_dataout ^ wire_ni00O_dataout))) & (~ (wire_nil1i_dataout ^ wire_ni0ii_dataout))),
		n1O1lO = ((~ SYNC_COMP_SIZE[0]) & (~ SYNC_COMP_SIZE[1])),
		n1O1Oi = (SYNC_COMP_SIZE[0] & (~ SYNC_COMP_SIZE[1])),
		n1Oi0i = 1'b1,
		n1Oi1O = ((((n1O0Ol & n1O0Oi) & n1O0lO) & (~ n1O0ll)) & (n1O0iO12 ^ n1O0iO11)),
		n1Oiii = ((((n001li | n001iO) | n0010i) | n0011O) | n1Olll),
		n1Oiil = ((((n001iO | n001il) | n001ii) | n0010O) | n0010l),
		n1OiiO = (((((n001Ol | n001Oi) | n001il) | n001ii) | n0010i) | n0011O),
		n1Oili = (((((n001Oi | n001ll) | n001li) | n001ii) | n0010l) | n0011O),
		n1Ol1l = (ni0OiO | ni0Oil),
		RLV = n1Ol1l,
		RLV_lt = ((((ni0Oii | ni0O0O) | (~ (n1OiOi2 ^ n1OiOi1))) | (DWIDTH & ni0l0O)) | (~ (n1Oill4 ^ n1Oill3))),
		signal_detect_sync = n0001i,
		SUDI = {nllOlO, nllOll, nllOli, nllOiO, nllOil, nllOii, nllO0O, nllO0l, nllO0i, nllO1O, nllO1l, nllO1i, nlllOO},
		SUDI_pre = {nlO0li, nlO0iO, nlO0il, nlO0ii, nlO00O, nlO00l, nlO00i, nlO01O, nlO01l, nlO01i},
		sync_curr_st = {n1Oiii, n1Oiil, (~ n1OiiO), n1Oili},
		sync_status = n0101l;
endmodule //stratixgx_hssi_rx_wal_rtl
//synopsys translate_on
//VALID FILE
//
// STRATIXGX_HSSI_WORD_ALIGNER
//

`timescale 1 ps/1 ps

module stratixgx_hssi_word_aligner 
    (
        datain, 
        clk, 
        softreset, 
        enacdet, 
        bitslip, 
        a1a2size, 
        aligneddata, 
        aligneddatapre, 
        invalidcode, 
        invalidcodepre, 
        syncstatus, 
        syncstatusdeskew, 
        disperr, 
        disperrpre, 
        patterndetectpre,
        patterndetect
    );

input [9:0] datain;
input clk;
input softreset;
input enacdet;
input bitslip;
input a1a2size;

output [9:0] aligneddata;
output [9:0] aligneddatapre;
output invalidcode;
output invalidcodepre;
output syncstatus;
output syncstatusdeskew;
output disperr;
output disperrpre;
output patterndetect;
output patterndetectpre;

parameter channel_width = 10;
parameter align_pattern_length = 10;
parameter infiniband_invalid_code = 0;
parameter align_pattern = "0000000101111100";
parameter synchronization_mode = "XAUI";
parameter use_8b_10b_mode = "true";
parameter use_auto_bit_slip = "true"; 


// input interface

wire         rcvd_clk;
wire         soft_reset;
wire         LP10BEN;
wire         RLV_EN;
wire  [4:0]  RUNDISP_SEL;
wire         PMADATAWIDTH;
wire  [15:0] SYNC_COMP_PAT; 
wire  [1:0]  SYNC_COMP_SIZE;
wire  [1:0]  IB_INVALID_CODE;
wire         AUTOBYTEALIGN_DIS;
wire         SYNC_SM_DIS;
wire         GE_XAUI_SEL;
wire         encdet_prbs;
wire         BITSLIP;
wire         ENCDT;
wire         prbs_en;
wire         DISABLE_RX_DISP;
wire         signal_detect;       // signaldetect from PMA
wire  [9:0]  PUDI;                // from rx serdes
wire  [9:0]  PUDR;                // Loopback data from TX 

wire         A1A2_SIZE;           // PLD signal to select between 
                                  // A1A2 and A1A1A2A2 pattern detection
wire         DWIDTH;

// output interface

wire         cg_comma;            // is patterndetect when J = 10
wire         sync_status;         // from Sync SM to deskew state machine
wire         signal_detect_sync;  // Synchronized signal_detect
wire [12:0]  SUDI;               
wire [9:0]   SUDI_pre;            // to deskew fifo
wire         RLV;
wire         RLV_lt; 
wire [3:0]   sync_curr_st;        // Current state of Sync SM

// function to convert align_pattern to binary
function [15 : 0] pattern_conversion;
    input  [127 : 0] s;
    reg [127 : 0] reg_s;
    reg [15 : 0] digit;
    reg [7 : 0] tmp;
    integer   m;
    begin
      
        reg_s = s;
        for (m = 15; m >= 0; m = m-1 )
        begin
            tmp = reg_s[127 : 120];
            digit[m] = tmp & 8'b00000001;
            reg_s = reg_s << 8;
        end
          
        pattern_conversion = {digit[15], digit[14], digit[13], digit[12], digit[11], digit[10], digit[9], digit[8], digit[7], digit[6], digit[5], digit[4], digit[3], digit[2], digit[1], digit[0]};
    end   
endfunction


// assing input interface

assign RLV_EN      = 1'b0;          // in RX_SERDES
assign RUNDISP_SEL = 4'b1000;       // in RX_SERDES
assign DWIDTH      = 1'b0;          // in RX_SERDES - Only used in run length check
assign LP10BEN     = 1'b0;           // Mux is taken cared in top level
assign DISABLE_RX_DISP = 1'b0;      

assign PMADATAWIDTH   = (align_pattern_length == 16 || align_pattern_length == 8) ? 1'b1 : 1'b0; 
assign SYNC_COMP_PAT  = pattern_conversion(align_pattern);                                       
assign SYNC_COMP_SIZE = (align_pattern_length == 7)  ? 2'b00 : 
                        (align_pattern_length == 16 || align_pattern_length == 8) ? 2'b01 : 2'b10;  
                                  

assign SYNC_SM_DIS = (synchronization_mode == "none" || synchronization_mode == "NONE") ? 1'b1 : 1'b0;
assign GE_XAUI_SEL = (synchronization_mode == "gige" || synchronization_mode == "GIGE") ? 1'b1 : 1'b0;  

assign AUTOBYTEALIGN_DIS = (use_auto_bit_slip == "true" || use_auto_bit_slip == "ON") ? 1'b0 : 1'b1;
       
assign IB_INVALID_CODE = (infiniband_invalid_code == 0) ? 2'b00 :
                         (infiniband_invalid_code == 1) ? 2'b01 : 
                         (infiniband_invalid_code == 2) ? 2'b10 :  2'b11;

assign prbs_en = 1'b0;  
assign encdet_prbs = 1'b0;
assign signal_detect = 1'b1;

assign rcvd_clk   = clk;           
assign soft_reset = softreset;
assign BITSLIP    = bitslip;
assign ENCDT      = enacdet;

// filtering X values that impact state machines (cg_common, cg_invalid, kchar)
assign PUDI[0]    = (datain[0] === 1'b1 || datain[0] === 1'b0) ? datain[0] : 1'b0;
assign PUDI[1]    = (datain[1] === 1'b1 || datain[1] === 1'b0) ? datain[1] : 1'b0;
assign PUDI[2]    = (datain[2] === 1'b1 || datain[2] === 1'b0) ? datain[2] : 1'b0;
assign PUDI[3]    = (datain[3] === 1'b1 || datain[3] === 1'b0) ? datain[3] : 1'b0;
assign PUDI[4]    = (datain[4] === 1'b1 || datain[4] === 1'b0) ? datain[4] : 1'b0;
assign PUDI[5]    = (datain[5] === 1'b1 || datain[5] === 1'b0) ? datain[5] : 1'b0;
assign PUDI[6]    = (datain[6] === 1'b1 || datain[6] === 1'b0) ? datain[6] : 1'b0;
assign PUDI[7]    = (datain[7] === 1'b1 || datain[7] === 1'b0) ? datain[7] : 1'b0;
assign PUDI[8]    = (datain[8] === 1'b1 || datain[8] === 1'b0) ? datain[8] : 1'b0;
assign PUDI[9]    = (datain[9] === 1'b1 || datain[9] === 1'b0) ? datain[9] : 1'b0;

assign A1A2_SIZE  = a1a2size;
assign PUDR       = 10'bxxxxxxxxxx;  // Taken cared in top-level          


// assing output interface

assign aligneddata    = SUDI[9:0];
assign invalidcode    = SUDI[10];
assign syncstatus     = SUDI[11];
assign disperr        = SUDI[12];

// from GIGE/XAUI sync state machine - to XGM dskw SM and Rate Matching
assign syncstatusdeskew = sync_status;

assign patterndetect = cg_comma;    // only for J=10

assign aligneddatapre = SUDI_pre;
assign invalidcodepre = 1'b0;       // unused
assign disperrpre     = 1'b0;       // unused
assign patterndetectpre = 1'b0;     // unused


// instantiating RTL

stratixgx_hssi_rx_wal_rtl m_wal_rtl (
                 .rcvd_clk (rcvd_clk),
                 .soft_reset (soft_reset),
                 .LP10BEN (LP10BEN),
                 .RLV_EN (RLV_EN),
                 .RUNDISP_SEL (RUNDISP_SEL),
                 .PMADATAWIDTH (PMADATAWIDTH),
                 .SYNC_COMP_PAT (SYNC_COMP_PAT),
                 .SYNC_COMP_SIZE (SYNC_COMP_SIZE),
                 .IB_INVALID_CODE (IB_INVALID_CODE),
                 .AUTOBYTEALIGN_DIS (AUTOBYTEALIGN_DIS),
                 .BITSLIP (BITSLIP),
                 .DISABLE_RX_DISP (DISABLE_RX_DISP),
                 .ENCDT (ENCDT),
                 .SYNC_SM_DIS (SYNC_SM_DIS),
                 .prbs_en (prbs_en),
                 .encdet_prbs (encdet_prbs),
                 .GE_XAUI_SEL (GE_XAUI_SEL),
                 .signal_detect (signal_detect),
                 .PUDI (PUDI),
                 .PUDR (PUDR),
                 .cg_comma (cg_comma),
                 .sync_status (sync_status),
                 .signal_detect_sync (signal_detect_sync),
                 .SUDI (SUDI),
                 .SUDI_pre (SUDI_pre),
                 .RLV (RLV),
                 .RLV_lt (RLV_lt),
                 .sync_curr_st (sync_curr_st),
                 .A1A2_SIZE(A1A2_SIZE),
                 .DWIDTH(DWIDTH)
);

endmodule
///////////////////////////////////////////////////////////////////////////////
//
//                            STRATIXGX_COMP_FIFO_CORE
//
///////////////////////////////////////////////////////////////////////////////

module stratixgx_comp_fifo_core
   (
    reset, 
    writeclk, 
    readclk, 
    underflow, 
    overflow,
    errdetectin,
    disperrin,   
    patterndetectin,
    disablefifowrin, 
    disablefifordin, 
    re, 
    we,
    datain,
    datainpre,
    syncstatusin, 
    disperr,
    alignstatus,
    fifordin, 
    fifordout,
    decsync, 
    fifocntlt5, 
    fifocntgt9, 
    done,
    fifoalmostful, 
    fifofull, 
    fifoalmostempty, 
    fifoempty,
    alignsyncstatus, 
    smenable, 
    disablefifordout,
    disablefifowrout, 
    dataout, 
    codevalid,
    errdetectout,
    patterndetect,    
    syncstatus
    );

   parameter     use_rate_match_fifo = "true";
   parameter     rate_matching_fifo_mode = "xaui";
   parameter     use_channel_align = "true";
   parameter     channel_num = 0;
   parameter     for_engineering_sample_device = "true";  // new in 3.0 sp2

   input    reset;
   input    writeclk;
   input    readclk;
   input    underflow;
   input    overflow;
   input    errdetectin;    
   input    disperrin;      
   input    patterndetectin;
   input    disablefifordin;
   input    disablefifowrin;
   wire     ge_xaui_sel;
   input    re;
   input    we;
   input [9:0]  datain;
   input [9:0]  datainpre;
   input    syncstatusin;
   input    alignstatus;
   input    fifordin;
   output   fifordout;
   output   fifoalmostful;
   output   fifofull;
   output   fifoalmostempty;
   output   fifoempty;
   output   decsync;
   output   fifocntlt5;
   output   fifocntgt9;
   output   done;
   output   alignsyncstatus;
   output   smenable;
   output   disablefifordout;
   output   disablefifowrout;
   output [9:0] dataout;
   output    codevalid;
   output    errdetectout;
   output    syncstatus;
   output    patterndetect;
   output    disperr;

   reg       decsync;
   reg       decsync_1;
   wire      alignsyncstatus;
   wire          alignstatus_dly;
   wire          re_dly;
   wire [9:0]    dataout;
   wire      fifocntlt5;
   wire      fifo_cnt_lt_8;
   wire      fifo_cnt_lt_9;
   wire      fifo_cnt_lt_7;
   wire      fifo_cnt_lt_12;
   wire      fifo_cnt_lt_4;
   wire      fifo_cnt_gt_10;
   wire      fifocntgt9;
   wire      fifo_cnt_gt_8;
   wire      fifo_cnt_gt_13;
   wire      fifo_cnt_gt_5;
   wire      fifo_cnt_gt_6;
   wire      done;
   wire      smenable;
   wire      codevalid;
   
   reg       fifoalmostful;
   reg       fifofull;
   reg       fifoalmostempty;
   reg       fifoempty;
   reg       almostfull_1;
   reg       almostfull_sync;
   reg       almostempty_1;
   reg       almostempty_sync;
   reg       full_1;
   reg       full_sync;
   reg       empty_1;
   reg       empty_sync;
   reg       rdenable_sync_1;
   reg       rdenable_sync;
   reg       write_enable_sync;
   reg       write_enable_sync_1;
   reg       fifo_dec_dly;
   reg [3:0]     count;
   reg [1:0]     count_read;
   wire      comp_write_d;
   reg       comp_write_pre;
   wire      comp_write;
   wire      write_detect_d;
   reg       write_detect_pre;
   wire      write_detect;
   wire      comp_read_d;
   reg       comp_read;
   wire      detect_read_d;
   reg       detect_read;
   reg       comp_read_ext;
   wire      disablefifowrout;
   wire      disablefifordout;
   wire      fifordout;
   reg       read_eco;
   wire          read_eco_dly;
   wire      reset_fifo_dec;
   
   reg       read_sync_int_1;
   reg       read_sync_int;
   wire      read_sync;
   reg       fifo_dec;
   reg       done_write;
   reg       done_read;
   reg       underflow_sync_1;
   reg       underflow_sync;
   reg       done_read_sync_1;
   reg       done_read_sync;
   wire      alignsyncstatus_sync;
   reg       alignstatus_sync_1;
   reg       alignstatus_sync;
   reg       syncstatus_sync_1;
   reg       syncstatus_sync;
   
   integer   write_ptr, read_ptr1, read_ptr2;
   integer   i, j, k;
   reg [14*12-1:0] fifo;
   
   wire [10:0]     fifo_data_in;
   wire [11:0]     comp_pat1;
   wire [11:0]     comp_pat2;
   wire [12:0]     fifo_data_in_pre;
   reg [13:0]      fifo_data_out1_sync;
   reg [13:0]      fifo_data_out1_sync_dly;
   reg         fifo_data_out1_sync_valid;
   reg [13:0]      fifo_data_out2_sync;
   reg [13:0]      fifo_data_out1_tmp;
   reg [12:0]      fifo_data_out2_tmp;

   wire [13:0]     fifo_data_out1;
   wire [13:0]     fifo_data_out2;
   reg         genericfifo_sync_clk2_1, genericfifo_sync_clk2, genericfifo_sync_clk1_1, genericfifo_sync_clk1; 

   wire        onechannel;
   wire        deskewenable;
   wire        matchenable;
   wire        menable;
   wire        genericfifo;
   wire        globalenable;
   reg             writeclk_dly;
      
   assign onechannel   = (channel_num == 0) ? 1'b1 : 1'b0;
   assign deskewenable = (use_channel_align == "true") ? 1'b1 : 1'b0;
   assign matchenable  = (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
   assign menable      = matchenable && ~deskewenable;
   assign genericfifo  = (rate_matching_fifo_mode == "none") ? 1'b1 : 1'b0;
   assign globalenable = matchenable && deskewenable;
   assign ge_xaui_sel = (rate_matching_fifo_mode == "gige") ? 1'b1 : 1'b0;
   
   always @ (writeclk)
     begin
   writeclk_dly <= writeclk;
     end
   
   // COMPOSTION WRITE LOGIC
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        comp_write_pre <= 1'b0;
     else if (alignsyncstatus && (write_detect || ~ge_xaui_sel))
        comp_write_pre <= comp_write_d;
          else
         comp_write_pre <= 1'b0;
      end
   
   // WRITE DETECT LOGIC
   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        write_detect_pre <= 1'b0;
     else if (alignsyncstatus && ge_xaui_sel)
        write_detect_pre <= write_detect_d;
          else
         write_detect_pre <= 1'b0;
      end
   
   // CLOCK COMP READ   
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           comp_read <= 1'b0;
           comp_read_ext <= 1'b0;
        end
     else 
        begin
           comp_read_ext <= underflow_sync && comp_read && ge_xaui_sel;
           if (alignsyncstatus_sync && (detect_read || ~ge_xaui_sel))
          comp_read <= comp_read_d & ~fifo_data_out2_sync[10] & ~fifo_data_out2_sync[12];
           else
          comp_read <= 1'b0;
        end
      end
   
   // READ DETECT LOGIC 
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        detect_read <= 1'b0;
     else if (alignsyncstatus_sync && ge_xaui_sel)
        detect_read <= detect_read_d & ~fifo_data_out2_sync[10] & ~fifo_data_out2_sync[12];
          else
         detect_read <= 1'b0;
      end
   
   assign fifo_cnt_lt_4 = (count < 4);
   assign fifocntlt5 = (count < 5);
   assign fifo_cnt_lt_7 = (count < 7);
   assign fifo_cnt_lt_8 = (count < 8);  // added in REV-C
   assign fifo_cnt_lt_9 = (count < 9);
   assign fifo_cnt_lt_12 = (count < 12);
   assign fifo_cnt_gt_5 = (count > 5);
   assign fifo_cnt_gt_6 = (count > 6);  // added in REV-C
   assign fifo_cnt_gt_8 = (count > 8);
   assign fifocntgt9 = (count > 9);
   assign fifo_cnt_gt_10 = (count > 10);
   assign fifo_cnt_gt_13 = (count > 13);

   assign disablefifowrout = (globalenable && !onechannel) ? disablefifowrin : overflow & comp_write & ~done_write;

   // FIFO COUNT LOGIC   
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        count <= 4'b0000;
     else if (genericfifo_sync_clk1)
        begin
           if (write_enable_sync && ~decsync)
          count <= count + 1;
           else if (write_enable_sync && decsync)
          count <= count -2;
            else if (~write_enable_sync && decsync)
               count <= count - 3;
             else
                count <= count;
        end
          else 
         begin
            if (!alignsyncstatus)
               count <= 4'b0000;
            else if (~decsync && ~disablefifowrout)
               count <= count + 1;
             else if (decsync && ~disablefifowrout)
                count <= count -2;
                  else if (~ge_xaui_sel && decsync && disablefifowrout)
                 count <= count - 3;
                   else if (ge_xaui_sel && decsync && disablefifowrout)
                      count <= count - 4;
                    else if (ge_xaui_sel && ~decsync && disablefifowrout)
                       count <= count - 1;
                         else
                        count <= count;
         end
      end
   
   // COMPENSATION DONE LOGIC   
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        done_write <= 1'b0;
     else
        done_write <= overflow && comp_write; 
      end
   
   // FIFO ALMOST FULL   
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        almostfull_1 <= 1'b0;
     else if (almostfull_1)
        almostfull_1 <= ~fifo_cnt_lt_8;
          else 
         almostfull_1 <= fifocntgt9;
      end
   
   // FIFO ALMOST EMPTY LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        almostempty_1 <= 1'b1;
     else if (almostempty_1)
        almostempty_1 <= ~fifo_cnt_gt_6;
          else
         almostempty_1 <= fifocntlt5;
      end
   
   // FIFO FULL LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        full_1 <= 1'b0;
     else if (full_1)
        full_1 <= ~fifo_cnt_lt_12;
          else
         full_1 <= fifo_cnt_gt_13;
      end
   
   // FIFO EMPTY LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        empty_1 <= 1'b1;
     else if (empty_1)
        empty_1 <= ~fifo_cnt_gt_5;
          else
         empty_1 <= fifo_cnt_lt_4;
      end
   
   assign read_sync = (globalenable && !onechannel)? fifordin : fifordout;
   assign fifordout = read_sync_int;

   always @ (posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        read_eco <= 1'b0;
     else if (read_eco && (count <= 4'd2))
        read_eco <= 1'b0;
          else if (!read_eco && (count == 4'd2))
         read_eco <= 1'b1;
      end
   
   assign #1 alignstatus_dly = alignstatus;
   assign #1 read_eco_dly = read_eco;
   assign #1 re_dly = re;

   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           read_sync_int_1 <= 1'b0;
           read_sync_int <= 1'b0;
           underflow_sync_1 <= 1'b0;
           underflow_sync <= 1'b0;
           alignstatus_sync_1 <= 1'b0;
           alignstatus_sync <= 1'b0;
           syncstatus_sync_1 <= 1'b0;
           syncstatus_sync <= 1'b0;
           rdenable_sync_1 <= 1'b0;
           rdenable_sync <= 1'b0;
           fifo_data_out1_sync_valid <= 1'b0;
           fifo_dec_dly <= 1'b0;
           almostfull_sync <= 1'b0;
           almostempty_sync <= 1'b1;
           full_sync <= 1'b0;
           empty_sync <= 1'b1;
           fifoalmostful <= 1'b0;
           fifoalmostempty <= 1'b1;
           fifofull <= 1'b0;
           fifoempty <= 1'b1;
           genericfifo_sync_clk2_1 <= 1'b0;
           genericfifo_sync_clk2   <= 1'b0;
        end
     else
        begin
          read_sync_int_1 <= read_eco_dly & ~genericfifo_sync_clk2;
           read_sync_int <= read_sync_int_1;
           underflow_sync_1 <= underflow;
           underflow_sync <= underflow_sync_1;
          alignstatus_sync_1 <= alignstatus_dly;
           alignstatus_sync <= alignstatus_sync_1;
           syncstatus_sync_1 <= syncstatusin;
           syncstatus_sync <= syncstatus_sync_1;
           rdenable_sync_1 <= (re_dly & genericfifo);
           rdenable_sync <= rdenable_sync_1;
           fifo_data_out1_sync_valid <= (~genericfifo_sync_clk2 & alignsyncstatus_sync & read_sync) |
                        (genericfifo_sync_clk2 & rdenable_sync);
           fifo_dec_dly <= fifo_dec;
           almostfull_sync <= almostfull_1;
           almostempty_sync <= almostempty_1;
           full_sync <= full_1;
           empty_sync <= empty_1;
           fifoalmostful <= almostfull_sync;
           fifoalmostempty <= almostempty_sync;
           fifofull <= full_sync;
           fifoempty <= empty_sync;
           genericfifo_sync_clk2_1 <= genericfifo;
           genericfifo_sync_clk2   <= genericfifo_sync_clk2_1;
        end
      end
   
   // DISABLE READ LOGIC
   assign disablefifordout = (globalenable && !onechannel) ? disablefifordin
                : (underflow_sync & (comp_read | comp_read_ext) & ~done_read);
   
   // 2 BIT COUNTER LOGIC   
   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        count_read <= 2'b00;
     else if (!alignsyncstatus_sync && !genericfifo_sync_clk2)
        count_read <= 2'b00;
          else if ((read_sync && ~disablefifordout) || rdenable_sync)
         if (count_read == 2'b10)
            count_read <= 2'b00;
         else
            count_read <= count_read + 1;
           else
              count_read <= count_read;
      end
   
   // COMPENSATION DONE (READ)   
   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        done_read <= 1'b0;
     else if (underflow_sync && ((comp_read && ~ge_xaui_sel) || (comp_read_ext && ge_xaui_sel))) 
        done_read <= 1'b1;
          else if (~underflow_sync)
         done_read <= 1'b0;
           else
              done_read <= done_read;
      end
   
   //DECREMENT FIFO LOGIC
   assign reset_fifo_dec = (reset | ~(~fifo_dec_dly | readclk));
   always @(posedge reset_fifo_dec or posedge readclk)
      begin
     if (reset_fifo_dec) 
        fifo_dec <= 1'b0;
     else if (count_read == 2'b01 && ( (~disablefifordout && ~genericfifo_sync_clk2) || 
                        (rdenable_sync && genericfifo_sync_clk2) ))
        fifo_dec <= 1'b1;
          else
         fifo_dec <= fifo_dec;
      end
   
   // WRITE CLOCK DELAY LOGIC
   always @(posedge reset or posedge writeclk_dly)
      begin
     if (reset)
        begin
           decsync_1 <= 1'b0;
           decsync <= 1'b0;
           done_read_sync_1 <= 1'b0;
           done_read_sync <= 1'b0;
           write_enable_sync_1 <= 1'b0;
           write_enable_sync <= 1'b0;
           genericfifo_sync_clk1_1 <= 1'b0;
           genericfifo_sync_clk1   <= 1'b0;
        end
     else
        begin
           decsync_1 <= fifo_dec;
           decsync <= decsync_1 && ~decsync;
           done_read_sync_1 <= done_read;
           done_read_sync <= done_read_sync_1;
           write_enable_sync_1 <= (we & genericfifo);
           write_enable_sync <= write_enable_sync_1;
           genericfifo_sync_clk1_1 <= genericfifo;
           genericfifo_sync_clk1   <= genericfifo_sync_clk1_1;
        end
      end

   // FIFO WRITE POINTER LOGIC 
   always @(posedge reset or writeclk_dly)
      begin
     if (reset)
        write_ptr <= 0; 
    if(writeclk_dly)
      begin
         if (!alignsyncstatus && !genericfifo_sync_clk1)
        write_ptr <= 0; 
          else if ( ((write_enable_sync && genericfifo_sync_clk1) || (!disablefifowrout && !genericfifo_sync_clk1)) )
         begin
            if(write_ptr != 11)
               write_ptr <= write_ptr + 1;
            else
               write_ptr <= 0;
         end
           else if (disablefifowrout && ge_xaui_sel && !genericfifo_sync_clk1)
              begin
             if(write_ptr != 0)
                write_ptr <= write_ptr - 1; 
             else
                write_ptr <= 11;
              end 
      end
   end
   
   // FIFO READ POINTER LOGIC
   always @(posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           read_ptr1 <= 0;
           read_ptr2 <= 1;
        end
     else if (!alignsyncstatus_sync && !genericfifo_sync_clk2)
        begin
           read_ptr1 <= 0;
           read_ptr2 <= 1;
        end
          else if ((read_sync && !disablefifordout && !genericfifo_sync_clk2) ||
               (rdenable_sync && genericfifo_sync_clk2))
         begin
            if(read_ptr1 != 11)
               read_ptr1 <= read_ptr1 + 1;
            else
               read_ptr1 <= 0;
            if(read_ptr2 != 11)
               read_ptr2 <= read_ptr2 + 1;
            else
               read_ptr2 <= 0;
         end
      end 
   
   // MAIN FIFO BLOCK
   always @(fifo_data_in or write_ptr or reset or errdetectin or syncstatusin or disperrin or patterndetectin)
      begin
          #1;
          if (reset)
              begin
                  for (i = 0; i < 168; i = i + 1)  // 14*12 = 168
                      fifo[i] = 1'b0;
              end
          else 
              begin
                  for (i = 0; i < 10; i = i + 1)
                      fifo[write_ptr*14+i] = fifo_data_in[i];
                  fifo[write_ptr*14+10] = errdetectin;
                  fifo[write_ptr*14+11] = syncstatusin;
                  fifo[write_ptr*14+12] = disperrin;
                  fifo[write_ptr*14+13] = patterndetectin;
              end
      end 
   
   always @ (posedge writeclk_dly or reset or read_ptr1 or read_ptr2)
      begin
     for (j = 0; j < 14; j = j + 1)
        fifo_data_out1_tmp[j] = fifo[read_ptr1*14+j];
     for (k = 0; k < 13; k = k + 1)
        fifo_data_out2_tmp[k] = fifo[read_ptr2*14+k];
      end 

   assign fifo_data_out1 = fifo_data_out1_tmp;
   assign fifo_data_out2 = fifo_data_out2_tmp;

   // DATAOUT DELAY LOGIC
   always @ (posedge reset or posedge readclk)
      begin
     if (reset)
        begin
           fifo_data_out1_sync <= 'b0;
           fifo_data_out1_sync_dly <= 'b0;
           fifo_data_out2_sync <= 'b0;
        end
     else  
        begin
           if (ge_xaui_sel)
          fifo_data_out1_sync_dly <=  fifo_data_out1_sync;
           else
          fifo_data_out1_sync_dly <= 'b0;
           if (!disablefifordout)
          begin
             fifo_data_out1_sync <= fifo_data_out1;
             fifo_data_out2_sync <= fifo_data_out2;
          end
           else if (ge_xaui_sel)
          fifo_data_out1_sync <= fifo_data_out1_sync_dly;
        end
      end
   
   assign done = done_write || done_read_sync;
   assign smenable = ((menable || (globalenable && onechannel)) && ~genericfifo_sync_clk1) ? 1'b1 : 1'b0;
   assign comp_pat1 = (ge_xaui_sel) ? 10'b1010110110 : 10'b0010111100;
   assign comp_pat2 = (ge_xaui_sel) ? ((for_engineering_sample_device == "true") ? 10'b1010001010 : 10'b1010001001)  : 10'b1101000011;
   assign comp_write_d = (fifo_data_in_pre[9:0] == comp_pat1) || (fifo_data_in_pre[9:0] == comp_pat2) ? 1'b1 : 1'b0;
   assign comp_read_d = (fifo_data_out2_sync[9:0] == comp_pat1) || (fifo_data_out2_sync[9:0] == comp_pat2) ? 1'b1 : 1'b0;
   assign write_detect_d = (fifo_data_in_pre[9:0] == 10'b0101111100) || (fifo_data_in_pre[9:0] == 10'b1010000011) ? 1'b1 : 1'b0;
   assign detect_read_d = (fifo_data_out2_sync[9:0] == 10'b0101111100) || (fifo_data_out2_sync[9:0] == 10'b1010000011) ? 1'b1 : 1'b0;
   assign dataout = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[9:0] : datain;
   assign errdetectout = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[10] : errdetectin; 
   assign syncstatus = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[11] : syncstatusin; 
   assign disperr = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[12] : disperrin;
   assign patterndetect = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync[13]: patterndetectin;
   assign codevalid = (matchenable || genericfifo_sync_clk2) ? fifo_data_out1_sync_valid : (deskewenable) ? alignstatus_dly : syncstatusin;
   assign alignsyncstatus = (~matchenable || genericfifo_sync_clk1) ? 1'b0 : (deskewenable) ? alignstatus_dly : syncstatusin;
   assign alignsyncstatus_sync = (~matchenable || genericfifo_sync_clk2) ? 1'b0 : (deskewenable) ? alignstatus_sync : syncstatus_sync;
   assign fifo_data_in = datain; 
   assign fifo_data_in_pre = datainpre;
   assign comp_write = comp_write_pre & ~errdetectin & ~disperrin; 
   assign write_detect = write_detect_pre & ~errdetectin & ~disperrin; 
   
endmodule

//IP Functional Simulation Model
//VERSION_BEGIN 11.0 cbx_mgl 2011:04:27:21:10:09:SJ cbx_simgen 2011:04:27:21:09:05:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



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

// You may only use these simulation model output files for simulation
// purposes and expressly not for synthesis or any other purposes (in which
// event Altera disclaims all warranties of any kind).


//synopsys translate_off

//synthesis_resources = lut 30 mux21 14 oper_selector 6 
`timescale 1 ps / 1 ps
module  stratixgx_comp_fifo_sm
	( 
	alignsyncstatus,
	decsync,
	done,
	fifocntgt9,
	fifocntlt5,
	overflow,
	reset,
	smenable,
	underflow,
	writeclk) /* synthesis synthesis_clearbox=1 */;
	input   alignsyncstatus;
	input   decsync;
	input   done;
	input   fifocntgt9;
	input   fifocntlt5;
	output   overflow;
	input   reset;
	input   smenable;
	output   underflow;
	input   writeclk;

	reg	n00i15;
	reg	n00i16;
	reg	n00O13;
	reg	n00O14;
	reg	n01i19;
	reg	n01i20;
	reg	n01l17;
	reg	n01l18;
	reg	n0ii11;
	reg	n0ii12;
	reg	n0il10;
	reg	n0il9;
	reg	n0iO7;
	reg	n0iO8;
	reg	n0lO5;
	reg	n0lO6;
	reg	n0OO3;
	reg	n0OO4;
	reg	n1Ol23;
	reg	n1Ol24;
	reg	n1OO21;
	reg	n1OO22;
	reg	ni1O1;
	reg	ni1O2;
	reg	nO;
	reg	nl_clk_prev;
	wire	wire_nl_CLRN;
	reg	ni;
	reg	nil;
	reg	niO;
	reg	nli;
	reg	nll;
	wire	wire_nlO_CLRN;
	wire	wire_n0l_dataout;
	wire	wire_n0O_dataout;
	wire	wire_n1i_dataout;
	wire	wire_n1l_dataout;
	wire	wire_n1O_dataout;
	wire	wire_nlii_dataout;
	wire	wire_nlil_dataout;
	wire	wire_nliO_dataout;
	wire	wire_nlli_dataout;
	wire	wire_nlll_dataout;
	wire	wire_nllO_dataout;
	wire	wire_nlOi_dataout;
	wire	wire_nlOl_dataout;
	wire	wire_nlOO_dataout;
	wire  wire_niOl_o;
	wire  wire_niOO_o;
	wire  wire_nl0i_o;
	wire  wire_nl0l_o;
	wire  wire_nl0O_o;
	wire  wire_nl1l_o;
	wire  n00l;
	wire  n0li;
	wire  n0ll;
	wire  ni1i;

	initial
		n00i15 = 0;
	always @ ( posedge writeclk)
		  n00i15 <= n00i16;
	event n00i15_event;
	initial
		#1 ->n00i15_event;
	always @(n00i15_event)
		n00i15 <= {1{1'b1}};
	initial
		n00i16 = 0;
	always @ ( posedge writeclk)
		  n00i16 <= n00i15;
	initial
		n00O13 = 0;
	always @ ( posedge writeclk)
		  n00O13 <= n00O14;
	event n00O13_event;
	initial
		#1 ->n00O13_event;
	always @(n00O13_event)
		n00O13 <= {1{1'b1}};
	initial
		n00O14 = 0;
	always @ ( posedge writeclk)
		  n00O14 <= n00O13;
	initial
		n01i19 = 0;
	always @ ( posedge writeclk)
		  n01i19 <= n01i20;
	event n01i19_event;
	initial
		#1 ->n01i19_event;
	always @(n01i19_event)
		n01i19 <= {1{1'b1}};
	initial
		n01i20 = 0;
	always @ ( posedge writeclk)
		  n01i20 <= n01i19;
	initial
		n01l17 = 0;
	always @ ( posedge writeclk)
		  n01l17 <= n01l18;
	event n01l17_event;
	initial
		#1 ->n01l17_event;
	always @(n01l17_event)
		n01l17 <= {1{1'b1}};
	initial
		n01l18 = 0;
	always @ ( posedge writeclk)
		  n01l18 <= n01l17;
	initial
		n0ii11 = 0;
	always @ ( posedge writeclk)
		  n0ii11 <= n0ii12;
	event n0ii11_event;
	initial
		#1 ->n0ii11_event;
	always @(n0ii11_event)
		n0ii11 <= {1{1'b1}};
	initial
		n0ii12 = 0;
	always @ ( posedge writeclk)
		  n0ii12 <= n0ii11;
	initial
		n0il10 = 0;
	always @ ( posedge writeclk)
		  n0il10 <= n0il9;
	initial
		n0il9 = 0;
	always @ ( posedge writeclk)
		  n0il9 <= n0il10;
	event n0il9_event;
	initial
		#1 ->n0il9_event;
	always @(n0il9_event)
		n0il9 <= {1{1'b1}};
	initial
		n0iO7 = 0;
	always @ ( posedge writeclk)
		  n0iO7 <= n0iO8;
	event n0iO7_event;
	initial
		#1 ->n0iO7_event;
	always @(n0iO7_event)
		n0iO7 <= {1{1'b1}};
	initial
		n0iO8 = 0;
	always @ ( posedge writeclk)
		  n0iO8 <= n0iO7;
	initial
		n0lO5 = 0;
	always @ ( posedge writeclk)
		  n0lO5 <= n0lO6;
	event n0lO5_event;
	initial
		#1 ->n0lO5_event;
	always @(n0lO5_event)
		n0lO5 <= {1{1'b1}};
	initial
		n0lO6 = 0;
	always @ ( posedge writeclk)
		  n0lO6 <= n0lO5;
	initial
		n0OO3 = 0;
	always @ ( posedge writeclk)
		  n0OO3 <= n0OO4;
	event n0OO3_event;
	initial
		#1 ->n0OO3_event;
	always @(n0OO3_event)
		n0OO3 <= {1{1'b1}};
	initial
		n0OO4 = 0;
	always @ ( posedge writeclk)
		  n0OO4 <= n0OO3;
	initial
		n1Ol23 = 0;
	always @ ( posedge writeclk)
		  n1Ol23 <= n1Ol24;
	event n1Ol23_event;
	initial
		#1 ->n1Ol23_event;
	always @(n1Ol23_event)
		n1Ol23 <= {1{1'b1}};
	initial
		n1Ol24 = 0;
	always @ ( posedge writeclk)
		  n1Ol24 <= n1Ol23;
	initial
		n1OO21 = 0;
	always @ ( posedge writeclk)
		  n1OO21 <= n1OO22;
	event n1OO21_event;
	initial
		#1 ->n1OO21_event;
	always @(n1OO21_event)
		n1OO21 <= {1{1'b1}};
	initial
		n1OO22 = 0;
	always @ ( posedge writeclk)
		  n1OO22 <= n1OO21;
	initial
		ni1O1 = 0;
	always @ ( posedge writeclk)
		  ni1O1 <= ni1O2;
	event ni1O1_event;
	initial
		#1 ->ni1O1_event;
	always @(ni1O1_event)
		ni1O1 <= {1{1'b1}};
	initial
		ni1O2 = 0;
	always @ ( posedge writeclk)
		  ni1O2 <= ni1O1;
	initial
	begin
		nO = 0;
	end
	always @ (writeclk or reset or wire_nl_CLRN)
	begin
		if (reset == 1'b1) 
		begin
			nO <= 1;
		end
		else if  (wire_nl_CLRN == 1'b0) 
		begin
			nO <= 0;
		end
		else 
		if (writeclk != nl_clk_prev && writeclk == 1'b1) 
		begin
			nO <= wire_nl0O_o;
		end
		nl_clk_prev <= writeclk;
	end
	assign
		wire_nl_CLRN = (ni1O2 ^ ni1O1);
	event nO_event;
	initial
		#1 ->nO_event;
	always @(nO_event)
		nO <= 1;
	initial
	begin
		ni = 0;
		nil = 0;
		niO = 0;
		nli = 0;
		nll = 0;
	end
	always @ ( posedge writeclk or  negedge wire_nlO_CLRN)
	begin
		if (wire_nlO_CLRN == 1'b0) 
		begin
			ni <= 0;
			nil <= 0;
			niO <= 0;
			nli <= 0;
			nll <= 0;
		end
		else 
		begin
			ni <= wire_nl0l_o;
			nil <= wire_niOl_o;
			niO <= wire_niOO_o;
			nli <= wire_nl1l_o;
			nll <= wire_nl0i_o;
		end
	end
	assign
		wire_nlO_CLRN = ((n0OO4 ^ n0OO3) & (~ reset));
	and(wire_n0l_dataout, decsync, ~((~ alignsyncstatus)));
	and(wire_n0O_dataout, (~ decsync), ~((~ alignsyncstatus)));
	and(wire_n1i_dataout, n0li, ~((~ alignsyncstatus)));
	assign		wire_n1l_dataout = (n0li === 1'b1) ? fifocntgt9 : nil;
	assign		wire_n1O_dataout = (n0li === 1'b1) ? fifocntlt5 : niO;
	and(wire_nlii_dataout, (~ done), ~((~ alignsyncstatus)));
	and(wire_nlil_dataout, done, ~((~ alignsyncstatus)));
	and(wire_nliO_dataout, wire_nlll_dataout, ~((~ alignsyncstatus)));
	and(wire_nlli_dataout, wire_nllO_dataout, ~((~ alignsyncstatus)));
	and(wire_nlll_dataout, niO, ~(done));
	and(wire_nllO_dataout, nil, ~(done));
	assign		wire_nlOi_dataout = ((~ alignsyncstatus) === 1'b1) ? nil : wire_n1l_dataout;
	assign		wire_nlOl_dataout = ((~ alignsyncstatus) === 1'b1) ? niO : wire_n1O_dataout;
	and(wire_nlOO_dataout, (~ n0li), ~((~ alignsyncstatus)));
	oper_selector   niOl
	( 
	.data({nil, wire_nlOi_dataout, wire_nlli_dataout}),
	.o(wire_niOl_o),
	.sel({n00l, nli, nll}));
	defparam
		niOl.width_data = 3,
		niOl.width_sel = 3;
	oper_selector   niOO
	( 
	.data({niO, ((n1Ol24 ^ n1Ol23) & wire_nlOl_dataout), wire_nliO_dataout}),
	.o(wire_niOO_o),
	.sel({n00l, nli, nll}));
	defparam
		niOO.width_data = 3,
		niOO.width_sel = 3;
	oper_selector   nl0i
	( 
	.data({1'b0, ((n00i16 ^ n00i15) & wire_n1i_dataout), wire_nlii_dataout}),
	.o(wire_nl0i_o),
	.sel({n00l, nli, ((n00O14 ^ n00O13) & nll)}));
	defparam
		nl0i.width_data = 3,
		nl0i.width_sel = 3;
	oper_selector   nl0l
	( 
	.data({n0ll, wire_n0O_dataout, 1'b0, wire_nlil_dataout}),
	.o(wire_nl0l_o),
	.sel({nO, ni, ((n0ii12 ^ n0ii11) & nli), nll}));
	defparam
		nl0l.width_data = 4,
		nl0l.width_sel = 4;
	oper_selector   nl0O
	( 
	.data({((n0il10 ^ n0il9) & (~ n0ll)), ((n0iO8 ^ n0iO7) & (~ alignsyncstatus))}),
	.o(wire_nl0O_o),
	.sel({nO, (~ nO)}));
	defparam
		nl0O.width_data = 2,
		nl0O.width_sel = 2;
	oper_selector   nl1l
	( 
	.data({1'b0, wire_n0l_dataout, ((n1OO22 ^ n1OO21) & wire_nlOO_dataout)}),
	.o(wire_nl1l_o),
	.sel({((n01i20 ^ n01i19) & ((nO | nll) | (~ (n01l18 ^ n01l17)))), ni, nli}));
	defparam
		nl1l.width_data = 3,
		nl1l.width_sel = 3;
	assign
		n00l = (nO | ni),
		n0li = (fifocntlt5 | fifocntgt9),
		n0ll = ((alignsyncstatus & smenable) & (n0lO6 ^ n0lO5)),
		ni1i = 1'b1,
		overflow = nil,
		underflow = niO;
endmodule //stratixgx_comp_fifo_sm
//synopsys translate_on
//VALID FILE
///////////////////////////////////////////////////////////////////////////////
//
//                              STRATIXGX_COMP_FIFO
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

   module stratixgx_comp_fifo
      (
       datain,
       datainpre,
       reset,
       errdetectin, 
       syncstatusin,
       disperrin,   
       patterndetectin,
       errdetectinpre,
       syncstatusinpre,
       disperrinpre,
       patterndetectinpre,
       writeclk,
       readclk,
       re,
       we,
       fifordin,
       disablefifordin,
       disablefifowrin,
       alignstatus,
       dataout,
       errdetectout,
       syncstatus,
       disperr,
       patterndetect,
       codevalid,
       fifofull,
       fifoalmostful,
       fifoempty,
       fifoalmostempty,
       disablefifordout,
       disablefifowrout,
       fifordout
       );

   parameter     use_rate_match_fifo = "true";
   parameter     rate_matching_fifo_mode = "xaui";
   parameter     use_channel_align = "true";
   parameter     channel_num = 0;
   parameter     for_engineering_sample_device = "true";
      
   input [9:0] datain;          // encoded word
   input [9:0] datainpre;       // word or dskw fifo
   input       reset;           // reset state machine
   input       errdetectin;     // from previous module
   input       syncstatusin;    // from previous module
   input       disperrin;       // from previous module
   input       patterndetectin; // from previous module
   input       errdetectinpre;     // from previous module
   input       syncstatusinpre;    // from previous module
   input       disperrinpre;       // from previous module
   input       patterndetectinpre; // from previous module
   input       writeclk;        // write clock to the internal FIFO
   input       readclk;         // read clock to the FIFO
   input       re;              // from core
   input       we;              // from core
   input       fifordin;        // indicates initial state of FIFO read
   input       disablefifordin; // do not move read pointer of FIFO
   input       disablefifowrin; // do not move write pointer of FIFO
   input       alignstatus;     // all channels aligned
   
   output [9:0] dataout;        // compensated output (sync with readclk)
   output    errdetectout;   // straight output from invalidcodein and synchronized with output
   output    syncstatus;     // straight output from syncstatusin and synchronized with output
   output    disperr;        // disperrin
   output        patterndetect;  // from previous module
   output    codevalid;      //indicating data is synchronized and aligned. Also feeding to xgmdatavalid
   output    fifofull;       // FIFO has 13 words
   output    fifoalmostful;  // FIFO contains 10 or more words
   output    fifoempty;      // FIFO has less than 4 words
   output    fifoalmostempty;// FIFO contains less than 7
   output    disablefifordout;// output of RX0
   output    disablefifowrout;// output of RX0
   output    fifordout;      // output of RX0
   
   wire      done;
   wire      fifocntgt9;
   wire      fifocntlt5;
   wire      decsync;
   wire      alignsyncstatus;
   wire      smenable;
   wire      overflow;
   wire      underflow;
   wire      disablefifordin;
   wire      disablefifowrin;
   wire [9:0]    dataout;
   
   stratixgx_comp_fifo_core comp_fifo_core 
      (
       .reset(reset),
       .writeclk(writeclk),
       .readclk(readclk),
       .underflow(underflow),
       .overflow(overflow),
       .errdetectin(errdetectin),
       .disperrin(disperrin),   
       .patterndetectin(patterndetectin),
       .disablefifordin(disablefifordin),
       .disablefifowrin(disablefifowrin),
       .re (re),
       .we (we),
       .datain(datain),
       .datainpre(datainpre),
       .syncstatusin(syncstatusin),
       .disperr(disperr),
       .alignstatus(alignstatus),                        
       .fifordin (fifordin),
       .fifordout (fifordout),
       .fifoalmostful (fifoalmostful), 
       .fifofull (fifofull), 
       .fifoalmostempty (fifoalmostempty), 
       .fifoempty (fifoempty),
       .decsync(decsync),
       .fifocntlt5(fifocntlt5),
       .fifocntgt9(fifocntgt9),
       .done(done),
       .alignsyncstatus(alignsyncstatus),
       .smenable(smenable),
       .disablefifordout(disablefifordout),
       .disablefifowrout(disablefifowrout),
       .dataout(dataout),
       .codevalid (codevalid),
       .errdetectout(errdetectout),
       .patterndetect(patterndetect),
       .syncstatus(syncstatus)
       ); 
   defparam      comp_fifo_core.use_rate_match_fifo = use_rate_match_fifo;
   defparam      comp_fifo_core.rate_matching_fifo_mode = rate_matching_fifo_mode;
   defparam      comp_fifo_core.use_channel_align = use_channel_align;
   defparam      comp_fifo_core.channel_num = channel_num;
   defparam      comp_fifo_core.for_engineering_sample_device = for_engineering_sample_device; // new in 3.0 sp2
   
   stratixgx_comp_fifo_sm comp_fifo_sm 
      (
       .writeclk(writeclk),
       .alignsyncstatus(alignsyncstatus),
       .reset(reset),
       .smenable(smenable),
       .done(done),
       .decsync(decsync),
       .fifocntlt5(fifocntlt5),
       .fifocntgt9(fifocntgt9),
       .underflow(underflow),
       .overflow(overflow)
       );
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                               STRATIXGX_RX_CORE
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps
  module stratixgx_rx_core
    (
     reset,
     writeclk,
     readclk,
     errdetectin,
     patterndetectin, 
     decdatavalid,
     xgmdatain,
     post8b10b,
     datain,
     xgmctrlin,
     ctrldetectin,
     syncstatusin,
     disparityerrin,
     syncstatus, 
     errdetect,  
     ctrldetect, 
     disparityerr, 
     patterndetect, 
     dataout, 
     a1a2sizeout, 
     clkout
     );

   parameter channel_width = 10;
   parameter use_double_data_mode = "false";
   parameter use_channel_align    = "false";
   parameter use_8b_10b_mode      = "true";
   parameter synchronization_mode = "none";
   parameter align_pattern = "0000000101111100";
      
   input     reset;
   input     writeclk;
   input     readclk; 
   input     errdetectin;
   input     patterndetectin; 
   input     decdatavalid;
   input [7:0]   xgmdatain;
   input [9:0]   post8b10b;
   input [9:0]   datain;
   input     xgmctrlin;
   input     ctrldetectin;
   input     syncstatusin;
   input     disparityerrin;
   
   output [1:0]  syncstatus;
   output [1:0]  errdetect;
   output [1:0]  ctrldetect;
   output [1:0]  disparityerr;
   output [1:0]  patterndetect;
   output [19:0] dataout; 
   output [1:0]  a1a2sizeout;
   output    clkout;

   wire [19:0]   dataout;
   wire [1:0]    ctrldetect;
   wire      detect;
   wire [7:0]    xgmxor;
   wire      running_disp;
   
   reg       clkout;
   reg       resync_d;
   reg       disperr_d;
   reg       patterndetect_d;
   reg       syncstatusin_1;
   reg       syncstatusin_2;
   reg       disparityerrin_1;
   reg       disparityerrin_2;
   reg       patterndetectin_1;
   reg       patterndetectin_2;
   reg       writeclk_by2;
   reg [12:0]    data_low_sync;
   reg [12:0]    data_low;
   reg [12:0]    data_high;
   reg [9:0]     data_int;
   reg [19:0]    dataout_tmp;
   reg [1:0]     patterndetect_tmp;
   reg [1:0]     disparityerr_tmp;
   reg [1:0]     syncstatus_tmp;
   reg [1:0]     errdetect_tmp;
   reg [1:0]     ctrldetect_tmp;
   reg [1:0]     a1a2sizeout_tmp;
   reg [19:0]    dataout_sync1;
   reg [1:0]     patterndetect_sync1;
   reg [1:0]     disparityerr_sync1;
   reg [1:0]     syncstatus_sync1;
   reg [1:0]     errdetect_sync1;
   reg [1:0]     ctrldetect_sync1;
   reg [1:0]     a1a2sizeout_sync1;
   reg [19:0]    dataout_sync2;
   reg [1:0]     patterndetect_sync2;
   reg [1:0]     disparityerr_sync2;
   reg [1:0]     syncstatus_sync2;
   reg [1:0]     errdetect_sync2;
   reg [1:0]     ctrldetect_sync2;
   reg [1:0]     a1a2sizeout_sync2;

   wire      doublewidth;
   wire      individual;
   wire      ena8b10b;
   wire      smdisable;

   // A1A2 patterndetect related variables
   reg patterndetect_8b;
   reg patterndetect_1_latch;
   reg patterndetect_2_latch;
   reg patterndetect_3_latch;
   
   wire [15 : 0] align_pattern_int;

// function to convert align_pattern to binary
function [15 : 0] pattern_conversion;
    input  [127 : 0] s;
    reg [127 : 0] reg_s;
    reg [15 : 0] digit;
    reg [7 : 0] tmp;
    integer   m;
    begin

        reg_s = s;
        for (m = 15; m >= 0; m = m-1 )
        begin
            tmp = reg_s[127 : 120];
            digit[m] = tmp & 8'b00000001;
            reg_s = reg_s << 8;
        end

        pattern_conversion = {digit[15], digit[14], digit[13], digit[12], digit[11], digit[10], digit[9], digit[8], digit[7], digit[6], digit[5], digit[4], digit[3], digit[2], digit[1], digit[0]};
    end   
endfunction

   assign align_pattern_int = pattern_conversion(align_pattern);
   assign doublewidth = (use_double_data_mode == "true") ? 1'b1 : 1'b0;
   assign individual  = (use_channel_align != "true") ? 1'b1 : 1'b0;
   assign ena8b10b    = (use_8b_10b_mode == "true") ? 1'b1 : 1'b0;
   assign smdisable   = (synchronization_mode == "none") ? 1'b1 : 1'b0;

   initial
      begin
     writeclk_by2 = 1'b0;
      end
   
   // A1A2 patterndetect block
   always @ (datain or align_pattern_int or patterndetect_1_latch or patterndetect_3_latch)
   begin
      if (datain[8] == 1'b1)
         patterndetect_8b = (datain[7:0] == align_pattern_int[15:8])
                                      && patterndetect_3_latch;
      else 
         patterndetect_8b = (datain[7:0] == align_pattern_int[15:8]) 
                                      && patterndetect_1_latch;                 
   end

   // A1A2 patterndetect latch
   always @(posedge reset or posedge writeclk)
   begin
      if (reset)
      begin
         patterndetect_1_latch <= 1'b0;  // For first A1 match 
         patterndetect_2_latch <= 1'b0;  // For second A1 match
         patterndetect_3_latch <= 1'b0;  // For first A2 match
      end
      else
      begin
         patterndetect_1_latch <= (datain[7:0] == align_pattern_int[7:0]);
         patterndetect_2_latch <= (patterndetect_1_latch) &
                                (datain[7:0] == align_pattern_int[7:0]);  
         patterndetect_3_latch <= (patterndetect_2_latch) &
                                (datain[7:0] == align_pattern_int[15:8]); 
      end
   end
   
   assign running_disp = disparityerrin | errdetectin;
   
   always @ (xgmdatain or datain or xgmctrlin or 
         ctrldetectin or decdatavalid or data_int or 
         syncstatusin or disparityerrin or patterndetectin or
         patterndetect_8b or syncstatusin_2 or disparityerrin_2 or 
         patterndetectin_2 or running_disp)
      begin
     if (ena8b10b)
        if (individual)
           begin
          resync_d <= syncstatusin;
          disperr_d <= disparityerrin;
          if (!decdatavalid && !smdisable)
             begin
            data_int[8:0] <= 9'h19C; 
            data_int[9]   <= 1'b0;   
            patterndetect_d <= 1'b0;
             end
          else 
          begin
         if (channel_width == 10) 
               patterndetect_d     <= patterndetectin;
         else
               patterndetect_d     <= patterndetect_8b;

            if (decdatavalid && !smdisable && running_disp)
               begin
                  data_int[8:0] <= 9'h1FE;
                  data_int[9]   <= running_disp;
               end
            else
               begin
                  data_int[8:0] <= {ctrldetectin, datain[7:0]};
                  data_int[9]   <= running_disp;
               end
             end
           end
        else
           begin
          resync_d        <= syncstatusin_2;
          disperr_d       <= disparityerrin_2;
          patterndetect_d <= patterndetectin_2;
          data_int[8:0]   <= {xgmctrlin, xgmdatain[7:0]};
          data_int[9]     <= xgmctrlin & ~(detect); 
           end
     else
        begin
           resync_d           <= syncstatusin;
           disperr_d          <= disparityerrin;
           data_int           <= datain;
           if (!decdatavalid && !smdisable)
               patterndetect_d <= 1'b0;
           else
             if (channel_width == 10) 
                   patterndetect_d     <= patterndetectin;
             else
                   patterndetect_d     <= patterndetect_8b;
        end
      end

   assign xgmxor = (xgmdatain[7:0]^8'hFE);
   assign detect = 1'b1 ? (xgmxor != 8'b00000000) : 1'b0;
      
   // MAIN FIFO BLOCK
   always @(posedge reset or posedge writeclk)
      begin
     if (reset)
        begin
           writeclk_by2      <= 1'b0;
           data_high         <= 13'h0000;
           data_low          <= 13'h0000;
           data_low_sync     <= 13'h0000;
           syncstatusin_1    <= 1'b0;
           syncstatusin_2    <= 1'b0;
           disparityerrin_1  <= 1'b0;
           disparityerrin_2  <= 1'b0;
           patterndetectin_1 <= 1'b0;
           patterndetectin_2 <= 1'b0;
        end
     else
        begin
           writeclk_by2      <= ~((writeclk_by2 && individual) || (writeclk_by2 && ~individual));
           syncstatusin_1    <= syncstatusin;
           syncstatusin_2    <= syncstatusin_1;
           disparityerrin_1  <= disparityerrin;
           disparityerrin_2  <= disparityerrin_1;
           patterndetectin_1 <= patterndetectin;
           patterndetectin_2 <= patterndetectin_1;
           
           if (doublewidth && !writeclk_by2)
          begin
             data_high[9:0] <= data_int;
             data_high[10]  <= resync_d;
             data_high[11]  <= disperr_d;
             data_high[12]  <= patterndetect_d;          
          end
           if (doublewidth & writeclk_by2)
          begin
             data_low[9:0]  <= data_int;
             data_low[10]   <= resync_d;
             data_low[11]   <= disperr_d;
             data_low[12]   <= patterndetect_d;
          end
           if (!doublewidth)
          begin
             data_low_sync[9:0] <= data_int;
             data_low_sync[10]  <= resync_d;
             data_low_sync[11]  <= disperr_d;
             data_low_sync[12]  <= patterndetect_d;
          end
           else 
          data_low_sync <= data_low;
        end
      end

   // CLOCK OUT BLOCK
   always @(writeclk_by2 or writeclk)
      begin
     if (doublewidth)
        clkout <= ~writeclk_by2; 
     else
        clkout <= ~writeclk;
      end
   
   // READ CLOCK BLOCK
   always @(posedge reset or posedge readclk)
      begin
     if(reset)
        begin
           dataout_tmp       <= 20'b0;
           patterndetect_tmp <= 2'b0;
           disparityerr_tmp  <= 2'b0;
           syncstatus_tmp    <= 2'b0;
           errdetect_tmp     <= 2'b0;
           ctrldetect_tmp    <= 2'b0;
           a1a2sizeout_tmp    <= 2'b0;
           dataout_sync1       <= 20'b0;
           patterndetect_sync1 <= 2'b0;
           disparityerr_sync1  <= 2'b0;
           syncstatus_sync1    <= 2'b0;
           errdetect_sync1     <= 2'b0;
           ctrldetect_sync1    <= 2'b0;
           a1a2sizeout_sync1    <= 2'b0;
           dataout_sync2       <= 20'b0;
           patterndetect_sync2 <= 2'b0;
           disparityerr_sync2  <= 2'b0;
           syncstatus_sync2    <= 2'b0;
           errdetect_sync2     <= 2'b0;
           ctrldetect_sync2    <= 2'b0;
           a1a2sizeout_sync2    <= 2'b0;
        end
     else
        begin
           if (ena8b10b || channel_width == 8 || channel_width == 16)
              dataout_sync1 <= {4'b0000, data_high[7:0], data_low_sync[7:0]};
          else
              dataout_sync1 <= {data_high[9:0], data_low_sync[9:0]};

           patterndetect_sync1 <= {data_high[12], data_low_sync[12]};
           disparityerr_sync1  <= {data_high[11], data_low_sync[11]};
           syncstatus_sync1    <= {data_high[10], data_low_sync[10]};
           errdetect_sync1     <= {data_high[9], data_low_sync[9]};
           ctrldetect_sync1    <= {data_high[8], data_low_sync[8]};
          if (channel_width == 8)
              a1a2sizeout_sync1   <= {data_high[8], data_low_sync[8]};
          else
              a1a2sizeout_sync1   <= 2'b0;
           dataout_sync2       <= dataout_sync1;
           patterndetect_sync2 <= patterndetect_sync1;
           disparityerr_sync2  <= disparityerr_sync1;
           syncstatus_sync2    <= syncstatus_sync1;
           errdetect_sync2     <= errdetect_sync1;
           ctrldetect_sync2    <= ctrldetect_sync1;
           a1a2sizeout_sync2   <= a1a2sizeout_sync1;
           dataout_tmp         <= dataout_sync2;
           patterndetect_tmp   <= patterndetect_sync2;
           disparityerr_tmp    <= disparityerr_sync2;
           syncstatus_tmp      <= syncstatus_sync2;
           errdetect_tmp       <= errdetect_sync2;
           ctrldetect_tmp      <= ctrldetect_sync2;
           a1a2sizeout_tmp     <= a1a2sizeout_sync2;
        end
      end

   assign dataout = dataout_tmp;
   assign a1a2sizeout = a1a2sizeout_tmp;
   assign patterndetect = patterndetect_tmp;
   assign disparityerr = disparityerr_tmp;
   assign syncstatus = syncstatus_tmp;
   assign errdetect = errdetect_tmp;
   assign ctrldetect = ctrldetect_tmp;
      
endmodule // stratixgx_rx_core
 
//
// STRATIXGX_HSSI_RX_SERDES
//

`timescale 1 ps/1 ps

module stratixgx_hssi_rx_serdes 
    (
        cruclk, 
        datain, 
        areset, 
        feedback, 
        fbkcntl, 
        ltr,        // q3.0ll
        ltd,        // q3.0ll
        clkout, 
        dataout, 
        rlv, 
        lock, 
        freqlock, 
        signaldetect 
    );

input datain;
input cruclk;
input areset;
input feedback;
input fbkcntl;
input ltr;
input ltd;

output [9:0] dataout;
output clkout;
output rlv;
output lock;
output freqlock;
output signaldetect;

parameter channel_width = 10;
parameter run_length = 4; 
parameter run_length_enable = "false";
parameter cruclk_period = 5000;
parameter cruclk_multiplier = 4;
parameter use_cruclk_divider = "false"; 
parameter use_double_data_mode = "false"; 
parameter channel_width_max = 10;

parameter init_lock_latency = 9;  // internal used for q3.0ll
integer cruclk_cnt;                
reg freqlock_tmp_dly;             
reg freqlock_tmp_dly1;           
reg freqlock_tmp_dly2;         
reg freqlock_tmp_dly3;        
reg freqlock_tmp_dly4;        

integer i, clk_count, rlv_count;
reg fastclk_last_value, clkout_last_value;
reg cruclk_last_value;
reg [channel_width_max-1:0] deser_data_arr;
reg [channel_width_max-1:0] deser_data_arr_tmp;
reg rlv_flag, rlv_set;
reg clkout_tmp;
reg lock_tmp;
reg freqlock_tmp;
reg signaldetect_tmp;
reg [9:0] dataout_tmp;
wire [9:0] data_out;
reg datain_in;
reg last_datain;
reg data_changed;

// clock generation
reg fastclk1;
reg fastclk;
integer n_fastclk;
integer fastclk_period;
integer rem;
integer my_rem;
integer tmp_fastclk_period;
integer cycle_to_adjust;
integer high_time;
integer low_time;
integer k;
integer sched_time;
reg     sched_val;

// new RLV variables
wire rlv_tmp;
reg rlv_tmp1, rlv_tmp2, rlv_tmp3;
wire min_length;

// wire declarations
wire cruclk_in;
wire datain_buf;
wire fbin_in;
wire fbena_in;
wire areset_in;
wire ltr_in;
wire ltd_in;

buf (cruclk_in, cruclk);
buf (datain_buf, datain);
buf (fbin_in, feedback);
buf (fbena_in, fbkcntl);
buf (areset_in, areset);
buf (ltr_in, ltr);          // q3.0ll
buf (ltd_in, ltd);          // q3.0ll

initial
begin
    i = 0;
    clk_count = channel_width;
    rlv_count = 0;
    fastclk_last_value = 'b0;
    //cruclk_last_value = 'b0;
    clkout_last_value = 'b0;
    clkout_tmp = 'b0;
    rlv_tmp1 = 'b0;
    rlv_tmp2 = 'b0;
    rlv_tmp3 = 'b0;
    rlv_flag = 'b0;
    rlv_set = 'b0;

    lock_tmp = 'b1;             // q3.0ll
    freqlock_tmp = 'b0;         
    cruclk_cnt = 0;            
    freqlock_tmp_dly = 'b0;     
    freqlock_tmp_dly1 = 'b0;     
    freqlock_tmp_dly2 = 'b0;     
    freqlock_tmp_dly3 = 'b0;     
    freqlock_tmp_dly4 = 'b0;    //
      
    signaldetect_tmp = 'b1;
    dataout_tmp = 10'bX;
    last_datain = 'bX;
    data_changed = 'b0;
   for (i = channel_width_max - 1; i >= 0; i = i - 1)
    deser_data_arr[i] = 1'b0;
   for (i = channel_width_max - 1; i >= 0; i = i - 1)
    deser_data_arr_tmp[i] = 1'b0;

   // q4.0 -    
   if (use_cruclk_divider == "false")
       n_fastclk = cruclk_multiplier;
   else
       n_fastclk = cruclk_multiplier / 2;
       
   fastclk_period = cruclk_period / n_fastclk;
   rem = cruclk_period % n_fastclk;
end
        
assign min_length = (channel_width == 8) ? 4 : 5;
        
always @(cruclk_in)
begin
   if ((cruclk_in === 'b1) && (cruclk_last_value === 'b0))
   begin 
       // schedule n_fastclk of clk with period fastclk_period
       sched_time = 0;
       sched_val = 1'b1; // start with rising to match cruclk
       
       k = 1; // used to distribute rem ps to n_fastclk internals
       for (i = 1; i <= n_fastclk; i = i + 1)
       begin
           fastclk1 <= #(sched_time) sched_val; // rising
             
           // wether it needs to add extra ps to the period
           tmp_fastclk_period = fastclk_period;
           if (rem != 0 && k <= rem)
           begin
               cycle_to_adjust = (n_fastclk * k) / rem;
               my_rem = (n_fastclk * k) % rem;
               if (my_rem != 0)
                   cycle_to_adjust = cycle_to_adjust + 1;
                     
               if (cycle_to_adjust == i)
               begin
                   tmp_fastclk_period = tmp_fastclk_period + 1;
                   k = k + 1;
               end
           end
                     
           high_time = tmp_fastclk_period / 2;
           low_time  = tmp_fastclk_period - high_time; 
           sched_val = ~sched_val;
           sched_time = sched_time + high_time;
           fastclk1 <= #(sched_time) sched_val; // falling edge
           sched_time = sched_time + low_time;
           sched_val = ~sched_val;
       end           
   end // rising cruclk
             
   cruclk_last_value <= cruclk_in;
end

always @(fastclk1)
    fastclk <= fastclk1;
      
always @(fastclk or areset_in or fbena_in)
begin

    if (areset_in == 1'b1)
    begin
        dataout_tmp = 10'b0;
        clk_count = channel_width;
        clkout_tmp = 1'b0;
    clkout_last_value = fastclk;
      rlv_tmp1 = 1'b0;
      rlv_tmp2 = 1'b0;
      rlv_tmp3 = 1'b0;
      rlv_flag = 1'b0;
      rlv_set = 1'b0;
      signaldetect_tmp = 1'b1;
      last_datain = 'bX;
      rlv_count = 0;
      data_changed = 'b0;
       for (i = channel_width_max - 1; i >= 0; i = i - 1)
           deser_data_arr[i] = 1'b0;
       for (i = channel_width_max - 1; i >= 0; i = i - 1)
           deser_data_arr_tmp[i] = 1'b0;
    end
   else 
    begin
        if (fbena_in == 1'b1)
            datain_in = fbin_in;
        else
            datain_in = datain_buf;

    if (((fastclk == 'b1) && (fastclk_last_value !== fastclk)) ||
         ((fastclk == 'b0) && (fastclk_last_value !== fastclk)))
       begin
            if (clk_count == channel_width)
            begin
                clk_count = 0;
                clkout_tmp = !clkout_last_value;
            end
            else if (clk_count == channel_width/2)
                clkout_tmp = !clkout_last_value;
            else if (clk_count < channel_width)
                clkout_tmp = clkout_last_value;
          clk_count = clk_count + 1;
       end

        // data loaded on both edges
    if (((fastclk == 'b1) && (fastclk_last_value !== fastclk)) ||
         ((fastclk == 'b0) && (fastclk_last_value !== fastclk)))
    begin
       for (i = 1; i < channel_width_max; i = i + 1)
           deser_data_arr[i - 1] <= deser_data_arr[i];
       deser_data_arr[channel_width_max - 1] <= datain_in;

            if (run_length_enable == "true") //rlv checking
            begin
                if (last_datain !== datain_in)
                begin
                    data_changed = 'b1;
                    last_datain = datain_in;
                    rlv_count = 1;
                    rlv_set = 'b0;
                end
                else //data not changed
                begin
                    rlv_count = rlv_count + 1;
                    data_changed = 'b0;
                end
                if (rlv_count > run_length && rlv_count > min_length)
                begin
                    rlv_flag = 'b1;
                    rlv_set = 'b1;
                end
            end
    end

    clkout_last_value = clkout_tmp;

    end

   fastclk_last_value = fastclk;

end

always @(posedge clkout_tmp)
begin
    deser_data_arr_tmp <= deser_data_arr;

   dataout_tmp[channel_width_max-1:0] <= deser_data_arr_tmp;

    if (run_length_enable == "true") //rlv checking
    begin
        if (rlv_flag == 'b1)
            if (rlv_set == 'b0)
                rlv_flag = 'b0;

        if (rlv_flag == 'b1)
           rlv_tmp1 <= 'b1;
        else
            rlv_tmp1 <= 'b0;

      rlv_tmp2 <= rlv_tmp1;
      rlv_tmp3 <= rlv_tmp2;
    end

end

// q3.0ll - locked and freqlock based on LTR and LTD
always @(posedge areset_in or cruclk_in)
begin
    if (areset_in == 1'b1)
    begin
        cruclk_cnt <= 0;
        lock_tmp <= 1'b1;
        freqlock_tmp <= 1'b0;
        freqlock_tmp_dly <= 1'b0;
        freqlock_tmp_dly1 <= 1'b0;     
        freqlock_tmp_dly2 <= 1'b0;     
        freqlock_tmp_dly3 <= 1'b0;     
        freqlock_tmp_dly4 <= 1'b0;
    end
    else if ((cruclk_in == 1'b1) && (cruclk_last_value == 1'b0))
    begin
        freqlock_tmp_dly <= freqlock_tmp_dly4;
        freqlock_tmp_dly4 <= freqlock_tmp_dly3;
        freqlock_tmp_dly3 <= freqlock_tmp_dly2;
        freqlock_tmp_dly2 <= freqlock_tmp_dly1;
        freqlock_tmp_dly1 <= freqlock_tmp;

        // initial latency
        if (cruclk_cnt < init_lock_latency)
            cruclk_cnt <= cruclk_cnt + 1;
        
        if (cruclk_cnt == init_lock_latency)
        begin
            if (ltd_in == 1'b1)
            begin
                freqlock_tmp <= 1'b1;
            end
            else if (ltr_in == 1'b1)
            begin
                lock_tmp <= 1'b0;
                freqlock_tmp <= 1'b0;
            end
            else     // auto switch
            begin
                lock_tmp <= 1'b0;
                freqlock_tmp <= 1'b1;
            end
        end             
    end // end of cruclk == 1
end
 
assign rlv_tmp = (use_double_data_mode == "true") ? (rlv_tmp1 | rlv_tmp2 | rlv_tmp3) : (rlv_tmp1 | rlv_tmp2);

assign data_out = dataout_tmp;

buf (dataout[0], data_out[0]);
buf (dataout[1], data_out[1]);
buf (dataout[2], data_out[2]);
buf (dataout[3], data_out[3]);
buf (dataout[4], data_out[4]);
buf (dataout[5], data_out[5]);
buf (dataout[6], data_out[6]);
buf (dataout[7], data_out[7]);
buf (dataout[8], data_out[8]);
buf (dataout[9], data_out[9]);

and (rlv, rlv_tmp, 1'b1);
and (lock, lock_tmp, 1'b1);
and (freqlock, freqlock_tmp_dly, 1'b1);      // q3.0ll extra latency on freqlock
and (signaldetect, signaldetect_tmp, 1'b1);
and (clkout, clkout_tmp, 1'b1);

endmodule

// 4 to 1 MULTIPLEXER
module stratixgx_hssi_mux4(Y,I0,I1,I2,I3,C0,C1); 
  input I0,I1,I2,I3,C0,C1; 
  output Y; 
  reg   Y; 
  always@(I0 or I1 or I2 or I3 or C0 or C1) begin 
      case ({C1,C0})  
          2'b00 : Y = I0 ; 
          2'b01 : Y = I1 ; 
          2'b10 : Y = I2 ; 
          2'b11 : Y = I3 ; 
      endcase 
  end 
endmodule // stratixgx_hssi_mux4

// DIVIDE BY TWO LOGIC
module stratixgx_hssi_divide_by_two 
   (
    reset,
    clkin,
    clkout
    );
   parameter divide = "true";

   input     reset;
   input     clkin;
   output    clkout;
   reg       clktmp;

   tri0      reset;

   initial
      begin
     clktmp = 1'b0;
      end

   always@(clkin or posedge reset) 
   begin
    if(divide == "false")
       clktmp <= clkin;
    else if (reset === 1'b1)
       clktmp <= 1'b0;
    else
       if(clkin == 1'b1)
          clktmp <= ~clktmp;
   end 

   assign clkout = clktmp;

endmodule
   

///////////////////////////////////////////////////////////////////////////////
//
//                           STRATIXGX_HSSI_RECEIVER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module stratixgx_hssi_receiver 
   (
    datain,
    cruclk,
    pllclk,
    masterclk,
    coreclk,
    softreset,
    analogreset,
    serialfdbk,
    slpbk,
    bitslip,
    enacdet,
    we,
    re,
    alignstatus,
    disablefifordin,
    disablefifowrin,
    fifordin,
    enabledeskew,
    fiforesetrd,
    xgmctrlin,
    a1a2size,
    locktorefclk,
    locktodata,
    parallelfdbk,
    post8b10b,
    equalizerctrl,
    xgmdatain,
    devclrn,
    devpor,
    syncstatusdeskew,
    adetectdeskew,
    rdalign,
    xgmctrldet,
    xgmrunningdisp,
    xgmdatavalid,
    fifofull,
    fifoalmostfull,
    fifoempty,
    fifoalmostempty,
    disablefifordout,
    disablefifowrout,
    fifordout,
    bisterr,
    bistdone,
    a1a2sizeout,
    signaldetect,
    lock,
    freqlock,
    rlv,
    clkout,
    recovclkout,
    syncstatus,
    patterndetect,
    ctrldetect,
    errdetect,
    disperr,
    dataout,
    xgmdataout
    );
   
parameter channel_num = 1;
parameter channel_width = 20;
parameter deserialization_factor = 10;
parameter run_length = 4; 
parameter run_length_enable = "false"; 
parameter use_8b_10b_mode = "false"; 
parameter use_double_data_mode = "false"; 
parameter use_rate_match_fifo = "false"; 
parameter rate_matching_fifo_mode = "none"; 
parameter use_channel_align = "false"; 
parameter use_symbol_align = "true"; 
parameter use_auto_bit_slip = "true"; 
parameter synchronization_mode = "none"; 
parameter align_pattern = "0000000101111100";
parameter align_pattern_length = 7; 
parameter infiniband_invalid_code = 0; 
parameter disparity_mode = "false";
parameter clk_out_mode_reference = "true";
parameter cruclk_period = 5000;
parameter cruclk_multiplier = 4;
parameter use_cruclk_divider = "false"; 
parameter use_parallel_feedback = "false";
parameter use_post8b10b_feedback = "false";
parameter send_reverse_parallel_feedback = "false";
parameter use_self_test_mode = "false";
parameter self_test_mode = 0;
parameter use_equalizer_ctrl_signal = "false";
parameter enable_dc_coupling = "false";
parameter equalizer_ctrl_setting = 20;
parameter signal_threshold_select = 2;
parameter vco_bypass = "false";
parameter force_signal_detect = "false";
parameter bandwidth_type = "low";
parameter for_engineering_sample_device = "true"; // new in 3.0 sp2
     
input datain;
input cruclk;
input pllclk;
input masterclk;
input coreclk;
input softreset;
input serialfdbk;
input [9 : 0] parallelfdbk;
input [9 : 0] post8b10b;
input slpbk;
input bitslip;
input enacdet;
input we;
input re;
input alignstatus;
input disablefifordin;
input disablefifowrin;
input fifordin;
input enabledeskew;
input fiforesetrd;
input [7 : 0] xgmdatain;
input xgmctrlin;
input devclrn;
input devpor;
input analogreset;
input a1a2size;
input locktorefclk;
input locktodata;
input [2:0] equalizerctrl;
   
   
output [1 : 0] syncstatus;
output [1 : 0] patterndetect;
output [1 : 0] ctrldetect;
output [1 : 0] errdetect;
output [1 : 0] disperr;
output syncstatusdeskew;
output adetectdeskew;
output rdalign;
output [19:0] dataout;
output [7:0] xgmdataout;
output xgmctrldet;
output xgmrunningdisp;
output xgmdatavalid;
output fifofull;
output fifoalmostfull;
output fifoempty;
output fifoalmostempty;
output disablefifordout;
output disablefifowrout;
output fifordout;
output signaldetect;
output lock;
output freqlock;
output rlv;
output clkout;
output recovclkout;
output bisterr;
output bistdone;
output [1 : 0] a1a2sizeout; 
      
assign bisterr = 1'b0;
assign bistdone = 1'b1;

// input buffers
wire datain_in;
wire cruclk_in;
wire pllclk_in;
wire masterclk_in;
wire coreclk_in;
wire softreset_in;
wire serialfdbk_in;
wire analogreset_in;
wire locktorefclk_in;
wire locktodata_in;
   
wire parallelfdbk_in0;
wire parallelfdbk_in1;
wire parallelfdbk_in2;
wire parallelfdbk_in3;
wire parallelfdbk_in4;
wire parallelfdbk_in5;
wire parallelfdbk_in6;
wire parallelfdbk_in7;
wire parallelfdbk_in8;
wire parallelfdbk_in9;

wire post8b10b_in0;
wire post8b10b_in1;
wire post8b10b_in2;
wire post8b10b_in3;
wire post8b10b_in4;
wire post8b10b_in5;
wire post8b10b_in6;
wire post8b10b_in7;
wire post8b10b_in8;
wire post8b10b_in9;

wire slpbk_in;
wire bitslip_in;
wire a1a2size_in;
wire enacdet_in;
wire we_in;
wire re_in;
wire alignstatus_in;
wire disablefifordin_in;
wire disablefifowrin_in;
wire fifordin_in;
wire enabledeskew_in;
wire fiforesetrd_in;

wire xgmdatain_in0;
wire xgmdatain_in1;
wire xgmdatain_in2;
wire xgmdatain_in3;
wire xgmdatain_in4;
wire xgmdatain_in5;
wire xgmdatain_in6;
wire xgmdatain_in7;

wire xgmctrlin_in;
      
// input buffers
buf(datain_in, datain);
buf(cruclk_in, cruclk);
buf(pllclk_in, pllclk);
buf(masterclk_in, masterclk);
buf(coreclk_in, coreclk);
buf(softreset_in, softreset);
buf(serialfdbk_in, serialfdbk);
buf(analogreset_in, analogreset);
buf(locktorefclk_in, locktorefclk);
buf(locktodata_in, locktodata);
   
buf(parallelfdbk_in0, parallelfdbk[0]);
buf(parallelfdbk_in1, parallelfdbk[1]);
buf(parallelfdbk_in2, parallelfdbk[2]);
buf(parallelfdbk_in3, parallelfdbk[3]);
buf(parallelfdbk_in4, parallelfdbk[4]);
buf(parallelfdbk_in5, parallelfdbk[5]);
buf(parallelfdbk_in6, parallelfdbk[6]);
buf(parallelfdbk_in7, parallelfdbk[7]);
buf(parallelfdbk_in8, parallelfdbk[8]);
buf(parallelfdbk_in9, parallelfdbk[9]);

buf(post8b10b_in0, post8b10b[0]);
buf(post8b10b_in1, post8b10b[1]);
buf(post8b10b_in2, post8b10b[2]);
buf(post8b10b_in3, post8b10b[3]);
buf(post8b10b_in4, post8b10b[4]);
buf(post8b10b_in5, post8b10b[5]);
buf(post8b10b_in6, post8b10b[6]);
buf(post8b10b_in7, post8b10b[7]);
buf(post8b10b_in8, post8b10b[8]);
buf(post8b10b_in9, post8b10b[9]);

buf(slpbk_in, slpbk);
buf(bitslip_in, bitslip);
buf(a1a2size_in, a1a2size);
buf(enacdet_in, enacdet);
buf(we_in, we);
buf(re_in, re);
buf(alignstatus_in, alignstatus);
buf(disablefifordin_in, disablefifordin);
buf(disablefifowrin_in, disablefifowrin);
buf(fifordin_in, fifordin);
buf(enabledeskew_in, enabledeskew);
buf(fiforesetrd_in, fiforesetrd);

buf(xgmdatain_in0, xgmdatain[0]);
buf(xgmdatain_in1, xgmdatain[1]);
buf(xgmdatain_in2, xgmdatain[2]);
buf(xgmdatain_in3, xgmdatain[3]);
buf(xgmdatain_in4, xgmdatain[4]);
buf(xgmdatain_in5, xgmdatain[5]);
buf(xgmdatain_in6, xgmdatain[6]);
buf(xgmdatain_in7, xgmdatain[7]);

buf(xgmctrlin_in, xgmctrlin);

//constant signals
wire vcc, gnd;
wire [9 : 0] idle_bus;

//lower lever softreset
wire reset_int;

// internal bus for XGM/post8b10b data
wire [7 : 0] xgmdatain_in;
wire [9 : 0] post8b10b_in;

assign xgmdatain_in = {
                                xgmdatain_in7, xgmdatain_in6,
                                xgmdatain_in5, xgmdatain_in4,
                                xgmdatain_in3, xgmdatain_in2,
                                xgmdatain_in1, xgmdatain_in0
                             };
assign post8b10b_in = {                     post8b10b_in9, post8b10b_in8,
                                post8b10b_in7, post8b10b_in6,
                                post8b10b_in5, post8b10b_in4,
                                post8b10b_in3, post8b10b_in2,
                                post8b10b_in1, post8b10b_in0
                             };

assign reset_int = softreset_in;
assign vcc = 1'b1;
assign gnd = 1'b0;
assign idle_bus = 10'b0000000000;

// serdes output signals
wire serdes_clkout; //receovered clock
wire serdes_rlv;
wire serdes_signaldetect;
wire serdes_lock;
wire serdes_freqlock;
wire [9 : 0] serdes_dataout;

// word aligner input/output signals
wire [9 : 0] wa_datain;
wire wa_clk;
wire wa_enacdet;
wire wa_bitslip;
wire wa_a1a2size;

wire [9 : 0] wa_aligneddata;
wire [9 : 0] wa_aligneddatapre;
wire wa_invalidcode;
wire wa_invalidcodepre;
wire wa_disperr;
wire wa_disperrpre;
wire wa_patterndetect;
wire wa_patterndetectpre;
wire wa_syncstatus;
wire wa_syncstatusdeskew;

// deskew FIFO input/output signals
wire [9:0] dsfifo_datain;     
wire dsfifo_errdetectin;   
wire dsfifo_syncstatusin;  
wire dsfifo_disperrin; 
wire dsfifo_patterndetectin; 
wire dsfifo_writeclock;
wire dsfifo_readclock; 
wire dsfifo_fiforesetrd; 
wire dsfifo_enabledeskew;

wire [9:0] dsfifo_dataout; 
wire [9:0] dsfifo_dataoutpre; 
wire dsfifo_errdetect;   
wire dsfifo_syncstatus; 
wire dsfifo_disperr;    
wire dsfifo_errdetectpre;   
wire dsfifo_syncstatuspre; 
wire dsfifo_disperrpre;    
wire dsfifo_patterndetect; 
wire dsfifo_patterndetectpre; 
wire dsfifo_adetectdeskew;
wire dsfifo_rdalign;     
   
// comp FIFO input/output signals
   
wire [9:0] cmfifo_datain;
wire [9:0] cmfifo_datainpre;
wire cmfifo_invalidcodein; 
wire cmfifo_syncstatusin;
wire cmfifo_disperrin;  
wire cmfifo_patterndetectin;
wire cmfifo_invalidcodeinpre; 
wire cmfifo_syncstatusinpre;
wire cmfifo_disperrinpre;  
wire cmfifo_patterndetectinpre;
wire cmfifo_writeclk;      
wire cmfifo_readclk;      
wire cmfifo_alignstatus;
wire cmfifo_re;
wire cmfifo_we;
wire cmfifo_fifordin;
wire cmfifo_disablefifordin; 
wire cmfifo_disablefifowrin;
   
wire [9:0] cmfifo_dataout; 
wire cmfifo_invalidcode;
wire cmfifo_syncstatus;
wire cmfifo_disperr;
wire cmfifo_patterndetect;
wire cmfifo_datavalid;
wire cmfifo_fifofull;
wire cmfifo_fifoalmostfull;
wire cmfifo_fifoempty;
wire cmfifo_fifoalmostempty;
wire cmfifo_disablefifordout;
wire cmfifo_disablefifowrout;
wire cmfifo_fifordout;

// 8B10B decode input/output signals
wire decoder_clk; 
wire [9 : 0] decoder_datain;   
wire decoder_errdetectin;         
wire decoder_syncstatusin;         
wire decoder_disperrin;         
wire decoder_patterndetectin;         
wire decoder_indatavalid;         
   
wire [7 : 0] decoder_dataout;
wire [9 : 0] decoder_tenBdata; 
wire decoder_valid;         
wire decoder_errdetect;
wire decoder_rderr;         
wire decoder_syncstatus;         
wire decoder_disperr;         
wire decoder_patterndetect;         
wire decoder_decdatavalid;    
wire decoder_ctrldetect;   
wire decoder_xgmdatavalid;
wire decoder_xgmrunningdisp;
wire decoder_xgmctrldet;
wire [7 : 0] decoder_xgmdataout; 

// core interface input/output signals
wire [9:0] core_datain;
wire core_writeclk;
wire core_readclk;
wire core_decdatavalid;
wire [7:0] core_xgmdatain;
wire core_xgmctrlin;
wire [9:0] core_post8b10b;
wire core_syncstatusin;
wire core_errdetectin;
wire core_ctrldetectin;
wire core_disparityerrin;
wire core_patterndetectin;
   
wire [19:0] core_dataout;
wire core_clkout;
wire [1:0]  core_a1a2sizeout; 
wire [1:0]  core_syncstatus;
wire [1:0]  core_errdetect;
wire [1:0]  core_ctrldetect;
wire [1:0]  core_disparityerr;
wire [1:0]  core_patterndetect;

// interconnection variables
wire invalidcode;
wire [19 : 0] dataout_tmp;

// clkout mux output
// - added gfifo
wire clkoutmux_clkout;
wire clkoutmux_clkout_pre;

// wire declarations from lint
wire clk2mux1_c0;
wire  clk2mux1_c1;
wire  rxrdclk_mux1;
wire  rxrdclkmux1_c0;
wire  rxrdclkmux1_c1;
wire  rxrdclk_mux1_by2;
wire  rxrdclkmux2_c0;
wire  rxrdclkmux2_c1;

// MAIN CLOCKS
wire     rcvd_clk;
wire     clk_1;
wire     clk_2;
wire     rx_rd_clk;
wire     clk2_mux1;
wire     rx_rd_clk_mux;
   

specify


    (posedge coreclk => (dataout[0] +: dataout_tmp[0])) = (0, 0);
    (posedge coreclk => (dataout[1] +: dataout_tmp[1])) = (0, 0);
    (posedge coreclk => (dataout[2] +: dataout_tmp[2])) = (0, 0);
    (posedge coreclk => (dataout[3] +: dataout_tmp[3])) = (0, 0);
    (posedge coreclk => (dataout[4] +: dataout_tmp[4])) = (0, 0);
    (posedge coreclk => (dataout[5] +: dataout_tmp[5])) = (0, 0);
    (posedge coreclk => (dataout[6] +: dataout_tmp[6])) = (0, 0);
    (posedge coreclk => (dataout[7] +: dataout_tmp[7])) = (0, 0);
    (posedge coreclk => (dataout[8] +: dataout_tmp[8])) = (0, 0);
    (posedge coreclk => (dataout[9] +: dataout_tmp[9])) = (0, 0);
    (posedge coreclk => (dataout[10] +: dataout_tmp[10])) = (0, 0);
    (posedge coreclk => (dataout[11] +: dataout_tmp[11])) = (0, 0);
    (posedge coreclk => (dataout[12] +: dataout_tmp[12])) = (0, 0);
    (posedge coreclk => (dataout[13] +: dataout_tmp[13])) = (0, 0);
    (posedge coreclk => (dataout[14] +: dataout_tmp[14])) = (0, 0);
    (posedge coreclk => (dataout[15] +: dataout_tmp[15])) = (0, 0);
    (posedge coreclk => (dataout[16] +: dataout_tmp[16])) = (0, 0);
    (posedge coreclk => (dataout[17] +: dataout_tmp[17])) = (0, 0);
    (posedge coreclk => (dataout[18] +: dataout_tmp[18])) = (0, 0);
    (posedge coreclk => (dataout[19] +: dataout_tmp[19])) = (0, 0);

    (posedge coreclk => (syncstatus[0] +: core_syncstatus[0])) = (0, 0);
    (posedge coreclk => (syncstatus[1] +: core_syncstatus[1])) = (0, 0);

    (posedge coreclk => (patterndetect[0] +: core_patterndetect[0])) = (0, 0);
    (posedge coreclk => (patterndetect[1] +: core_patterndetect[1])) = (0, 0);

    (posedge coreclk => (ctrldetect[0] +: core_ctrldetect[0])) = (0, 0);
    (posedge coreclk => (ctrldetect[1] +: core_ctrldetect[1])) = (0, 0);

    (posedge coreclk => (errdetect[0] +: core_errdetect[0])) = (0, 0);
    (posedge coreclk => (errdetect[1] +: core_errdetect[1])) = (0, 0);

    (posedge coreclk => (disperr[0] +: core_disparityerr[0])) = (0, 0);
    (posedge coreclk => (disperr[1] +: core_disparityerr[1])) = (0, 0);

    (posedge coreclk => (a1a2sizeout[0] +: core_a1a2sizeout[0])) = (0, 0);
    (posedge coreclk => (a1a2sizeout[1] +: core_a1a2sizeout[1])) = (0, 0);

    (posedge coreclk => (fifofull +: cmfifo_fifofull)) = (0, 0);
    (posedge coreclk => (fifoempty +: cmfifo_fifoempty)) = (0, 0);
    (posedge coreclk => (fifoalmostfull +: cmfifo_fifoalmostfull)) = (0, 0);
    (posedge coreclk => (fifoalmostempty +: cmfifo_fifoalmostempty)) = (0, 0);
    $setuphold(posedge coreclk, re, 0, 0);


endspecify

// generate internal inut signals

   // generate internal input signals

   // RCVD_CLK LOGIC
   assign rcvd_clk = (use_parallel_feedback == "true") ? pllclk_in : serdes_clkout;

   // CLK_1 LOGIC
   assign clk_1 = (use_parallel_feedback == "true") ? pllclk_in : (use_channel_align == "true") ? masterclk_in : serdes_clkout;
   
   // CLK_2 LOGIC
   // - added gfifo
   assign clk_2 = (clk_out_mode_reference == "false") ? coreclk_in : clk2_mux1;

   // RX_RD_CLK
   // - added gfifo
   assign rx_rd_clk = (clk_out_mode_reference == "false") ? coreclk_in : rx_rd_clk_mux;

   stratixgx_hssi_mux4 clk2mux1 
      (
       .Y(clk2_mux1),
       .I0(serdes_clkout),
       .I1(masterclk_in),
       .I2(1'b0),
       .I3(pllclk_in),
       .C0(clk2mux1_c0),
       .C1(clk2mux1_c1)
       );
   
   assign clk2mux1_c0 = (use_parallel_feedback == "true") | (use_channel_align == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
   assign clk2mux1_c1 = (use_parallel_feedback == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;

   stratixgx_hssi_mux4 rxrdclkmux1 
      (
       .Y(rxrdclk_mux1),
       .I0(serdes_clkout),
       .I1(masterclk_in),
       .I2(1'b0),
       .I3(pllclk_in),
       .C0(rxrdclkmux1_c0),
       .C1(rxrdclkmux1_c1)
       );
   
   assign rxrdclkmux1_c1 = (use_parallel_feedback == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
   assign rxrdclkmux1_c0 = (use_parallel_feedback == "true") | (use_channel_align == "true") | (use_rate_match_fifo == "true") ? 1'b1 : 1'b0;
      
   stratixgx_hssi_mux4 rxrdclkmux2 
      (
       .Y(rx_rd_clk_mux),
       .I0(coreclk_in),
       .I1(1'b0),
       .I2(rxrdclk_mux1_by2),
       .I3(rxrdclk_mux1),
       .C0(rxrdclkmux2_c0),
       .C1(rxrdclkmux2_c1)
       );

   assign rxrdclkmux2_c1 = (send_reverse_parallel_feedback == "true") ? 1'b1 : 1'b0;
   assign rxrdclkmux2_c0 = (use_double_data_mode == "false") && (send_reverse_parallel_feedback == "true") ? 1'b1 : 1'b0;

   stratixgx_hssi_divide_by_two rxrdclkmux_by2 
   (
    .reset(1'b0),
    .clkin(rxrdclk_mux1), 
    .clkout(rxrdclk_mux1_by2)
    );
   defparam rxrdclkmux_by2.divide = use_double_data_mode;
   
   // word_align inputs
   assign wa_datain = (use_parallel_feedback == "true") ? parallelfdbk : serdes_dataout;
   assign wa_clk = rcvd_clk;
   assign wa_enacdet = enacdet_in; 
   assign wa_bitslip = bitslip_in; 
   assign wa_a1a2size = a1a2size_in; 
   
   // deskew FIFO inputs
   assign dsfifo_datain = (use_symbol_align == "true") ? wa_aligneddata : idle_bus;     
   assign dsfifo_errdetectin = (use_symbol_align == "true") ? wa_invalidcode : 1'b0;   
   assign dsfifo_syncstatusin = (use_symbol_align == "true") ? wa_syncstatus : 1'b1;  
   assign dsfifo_disperrin = (use_symbol_align == "true") ? wa_disperr : 1'b0; 
   assign dsfifo_patterndetectin = (use_symbol_align == "true") ? wa_patterndetect : 1'b0; 
   assign dsfifo_writeclock = rcvd_clk;
   assign dsfifo_readclock = clk_1;
   assign dsfifo_fiforesetrd = fiforesetrd_in; 
   assign dsfifo_enabledeskew = enabledeskew_in;

// comp FIFO inputs
assign cmfifo_datain = (use_channel_align == "true") ? dsfifo_dataout : ((use_symbol_align == "true") ? wa_aligneddata : serdes_dataout);

assign cmfifo_datainpre = (use_channel_align == "true") ? dsfifo_dataoutpre : ((use_symbol_align == "true") ? wa_aligneddatapre : idle_bus);

assign cmfifo_invalidcodein = (use_channel_align == "true") ? dsfifo_errdetect : ((use_symbol_align == "true") ? wa_invalidcode : 1'b0);

assign cmfifo_syncstatusin = (use_channel_align == "true") ? dsfifo_syncstatus : ((use_symbol_align == "true") ? wa_syncstatus : 1'b1);

assign cmfifo_disperrin = (use_channel_align == "true") ? dsfifo_disperr : ((use_symbol_align == "true") ? wa_disperr : 1'b1);

assign cmfifo_patterndetectin = (use_channel_align == "true") ? dsfifo_patterndetect : ((use_symbol_align == "true") ? wa_patterndetect : 1'b1);

assign cmfifo_invalidcodeinpre = (use_channel_align == "true") ? dsfifo_errdetectpre : ((use_symbol_align == "true") ? wa_invalidcodepre : 1'b0);

assign cmfifo_syncstatusinpre = (use_channel_align == "true") ? dsfifo_syncstatuspre : ((use_symbol_align == "true") ? wa_syncstatusdeskew : 1'b1);

assign cmfifo_disperrinpre = (use_channel_align == "true") ? dsfifo_disperrpre : ((use_symbol_align == "true") ? wa_disperrpre : 1'b1);

assign cmfifo_patterndetectinpre = (use_channel_align == "true") ? dsfifo_patterndetectpre : ((use_symbol_align == "true") ? wa_patterndetectpre : 1'b1);

assign cmfifo_writeclk = clk_1;
assign cmfifo_readclk = clk_2;
assign cmfifo_alignstatus = alignstatus_in;
assign cmfifo_re = re_in;
assign cmfifo_we = we_in;
assign cmfifo_fifordin = fifordin_in;
assign cmfifo_disablefifordin = disablefifordin_in; 
assign cmfifo_disablefifowrin = disablefifowrin_in;

// 8B10B decoder inputs
assign decoder_clk = clk_2;
assign decoder_datain = (use_rate_match_fifo == "true") ? cmfifo_dataout : (use_channel_align == "true" ? dsfifo_dataout : (use_symbol_align == "true" ? wa_aligneddata : serdes_dataout));   

assign decoder_errdetectin = (use_rate_match_fifo == "true") ? cmfifo_invalidcode : (use_channel_align == "true" ? dsfifo_errdetect : (use_symbol_align == "true" ? wa_invalidcode : 1'b0));   

assign decoder_syncstatusin = (use_rate_match_fifo == "true") ? cmfifo_syncstatus : (use_channel_align == "true" ? dsfifo_syncstatus : (use_symbol_align == "true" ? wa_syncstatus : 1'b1));   

assign decoder_disperrin = (use_rate_match_fifo == "true") ? cmfifo_disperr : (use_channel_align == "true" ? dsfifo_disperr : (use_symbol_align == "true" ? wa_disperr : 1'b0));   

assign decoder_patterndetectin = (use_rate_match_fifo == "true") ? cmfifo_patterndetect : (use_channel_align == "true" ? dsfifo_patterndetect : (use_symbol_align == "true" ? wa_patterndetect : 1'b0));   

assign decoder_indatavalid = (use_rate_match_fifo == "true") ? cmfifo_datavalid : 1'b1;   

// rx_core inputs
assign core_datain          = (use_post8b10b_feedback == "true") ? post8b10b : ((use_8b_10b_mode == "true") ? {2'b00, decoder_dataout} : decoder_tenBdata);
assign core_writeclk        = clk_2;
assign core_readclk         = rx_rd_clk;
assign core_decdatavalid    = (use_8b_10b_mode == "true") ? decoder_decdatavalid : 1'b1;
assign core_xgmdatain       = xgmdatain_in;
assign core_xgmctrlin       = xgmctrlin_in;
assign core_post8b10b       = post8b10b_in;
assign core_syncstatusin    = decoder_syncstatus;
assign core_errdetectin     = decoder_errdetect; 
assign core_ctrldetectin    = decoder_ctrldetect; 
assign core_disparityerrin  = decoder_disperr; 
assign core_patterndetectin = decoder_patterndetect; 

// sub modules
stratixgx_hssi_rx_serdes s_rx_serdes   
  (
   .cruclk(cruclk), 
   .datain(datain), 
   .areset(analogreset_in), 
   .feedback(serialfdbk), 
   .fbkcntl(slpbk), 
   .ltr(locktorefclk),
   .ltd(locktodata),
   .clkout(serdes_clkout), 
   .dataout(serdes_dataout), 
   .rlv(serdes_rlv), 
   .lock(serdes_lock), 
   .freqlock(serdes_freqlock), 
   .signaldetect(serdes_signaldetect) 
   );
   defparam s_rx_serdes.channel_width = deserialization_factor;
   defparam s_rx_serdes.run_length_enable = run_length_enable;
   defparam s_rx_serdes.run_length = run_length; 
   defparam s_rx_serdes.cruclk_period = cruclk_period;
   defparam s_rx_serdes.cruclk_multiplier = cruclk_multiplier;
   defparam s_rx_serdes.use_cruclk_divider = use_cruclk_divider; 
   defparam s_rx_serdes.use_double_data_mode = use_double_data_mode; 

stratixgx_hssi_word_aligner s_wordalign    (   
                                                    .datain(wa_datain), 
                                                    .clk(wa_clk), 
                                                    .softreset(reset_int), 
                                                    .enacdet(wa_enacdet), 
                                                    .bitslip(wa_bitslip), 
                                                    .a1a2size(wa_a1a2size), 
                                                    .aligneddata(wa_aligneddata), 
                                                    .aligneddatapre(wa_aligneddatapre), 
                                                    .invalidcode(wa_invalidcode), 
                                                    .invalidcodepre(wa_invalidcodepre), 
                                                    .syncstatus(wa_syncstatus), 
                                                    .syncstatusdeskew(wa_syncstatusdeskew), 
                                                    .disperr(wa_disperr), 
                                                    .disperrpre(wa_disperrpre), 
                                                    .patterndetect(wa_patterndetect),
                                                    .patterndetectpre(wa_patterndetectpre)
                                                    );
    defparam s_wordalign.channel_width = deserialization_factor;
    defparam s_wordalign.align_pattern_length = align_pattern_length;
    defparam s_wordalign.infiniband_invalid_code = infiniband_invalid_code;
    defparam s_wordalign.align_pattern = align_pattern;
    defparam s_wordalign.synchronization_mode = synchronization_mode;
    defparam s_wordalign.use_auto_bit_slip = use_auto_bit_slip; 

stratixgx_deskew_fifo s_dsfifo (
                                        .datain(dsfifo_datain),
                                        .errdetectin(dsfifo_errdetectin),
                                        .syncstatusin(dsfifo_syncstatusin),
                                        .disperrin(dsfifo_disperrin),   
                                        .patterndetectin(dsfifo_patterndetectin),
                                        .writeclock(dsfifo_writeclock),  
                                        .readclock(dsfifo_readclock),   
                                        .adetectdeskew(dsfifo_adetectdeskew),
                                        .fiforesetrd(dsfifo_fiforesetrd),
                                        .enabledeskew(dsfifo_enabledeskew),
                                        .reset(reset_int),
                                        .dataout(dsfifo_dataout),   
                                        .dataoutpre(dsfifo_dataoutpre),   
                                        .errdetect(dsfifo_errdetect),    
                                        .syncstatus(dsfifo_syncstatus),
                                        .disperr(dsfifo_disperr),
                                        .errdetectpre(dsfifo_errdetectpre),    
                                        .syncstatuspre(dsfifo_syncstatuspre),
                                        .disperrpre(dsfifo_disperrpre),
                                        .patterndetect(dsfifo_patterndetect),
                                        .patterndetectpre(dsfifo_patterndetectpre),
                                        .rdalign(dsfifo_rdalign)
                                        );

stratixgx_comp_fifo s_cmfifo   
   (
    .datain(cmfifo_datain),
    .datainpre(cmfifo_datainpre),
    .reset(reset_int),
    .errdetectin(cmfifo_invalidcodein), 
    .syncstatusin(cmfifo_syncstatusin),
    .disperrin(cmfifo_disperrin),
    .patterndetectin(cmfifo_patterndetectin),
    .errdetectinpre(cmfifo_invalidcodeinpre), 
    .syncstatusinpre(cmfifo_syncstatusinpre),
    .disperrinpre(cmfifo_disperrinpre),
    .patterndetectinpre(cmfifo_patterndetectinpre),
    .writeclk(cmfifo_writeclk),
    .readclk(cmfifo_readclk),
    .re(cmfifo_re),
    .we(cmfifo_we),
    .fifordin(cmfifo_fifordin),
    .disablefifordin(cmfifo_disablefifordin),
    .disablefifowrin(cmfifo_disablefifowrin),
    .alignstatus(cmfifo_alignstatus),
    .dataout(cmfifo_dataout),
    .errdetectout(cmfifo_invalidcode),
    .syncstatus(cmfifo_syncstatus),
    .disperr(cmfifo_disperr),
    .patterndetect(cmfifo_patterndetect),
    .codevalid(cmfifo_datavalid),
    .fifofull(cmfifo_fifofull),
    .fifoalmostful(cmfifo_fifoalmostfull),
    .fifoempty(cmfifo_fifoempty),
    .fifoalmostempty(cmfifo_fifoalmostempty),
    .disablefifordout(cmfifo_disablefifordout),
    .disablefifowrout(cmfifo_disablefifowrout),
    .fifordout(cmfifo_fifordout)
    );
   defparam      s_cmfifo.use_rate_match_fifo = use_rate_match_fifo;
   defparam      s_cmfifo.rate_matching_fifo_mode = rate_matching_fifo_mode;
   defparam      s_cmfifo.use_channel_align = use_channel_align;
   defparam      s_cmfifo.channel_num = channel_num;
   defparam      s_cmfifo.for_engineering_sample_device = for_engineering_sample_device; // new in 3.0 sp2 
      
stratixgx_8b10b_decoder    s_decoder   
  (
   .clk(decoder_clk), 
   .reset(reset_int),  
   .errdetectin(decoder_errdetectin), 
   .syncstatusin(decoder_syncstatusin), 
   .disperrin(decoder_disperrin),
   .patterndetectin(decoder_patterndetectin),
   .datainvalid(decoder_indatavalid), 
   .datain(decoder_datain), 
   .valid(decoder_valid), 
   .dataout(decoder_dataout), 
   .tenBdata(decoder_tenBdata),
   .errdetect(decoder_errdetect),
   .rderr(decoder_rderr),
   .syncstatus(decoder_syncstatus),
   .disperr(decoder_disperr),
   .patterndetect(decoder_patterndetect),
   .kout(decoder_ctrldetect),
   .decdatavalid(decoder_decdatavalid),
   .xgmdatavalid(decoder_xgmdatavalid),
   .xgmrunningdisp(decoder_xgmrunningdisp),
   .xgmctrldet(decoder_xgmctrldet),
   .xgmdataout(decoder_xgmdataout)
   );
      
stratixgx_rx_core s_rx_core    
   (
    .reset(reset_int),
    .datain(core_datain),
    .writeclk(core_writeclk),
    .readclk(core_readclk),
    .decdatavalid(core_decdatavalid),
    .xgmdatain(core_xgmdatain),
    .xgmctrlin(core_xgmctrlin),
    .post8b10b(core_post8b10b),
    .syncstatusin(core_syncstatusin),
    .errdetectin(core_errdetectin),
    .ctrldetectin(core_ctrldetectin),
    .disparityerrin(core_disparityerrin),
    .patterndetectin(core_patterndetectin),
    .dataout(core_dataout),
    .a1a2sizeout(core_a1a2sizeout),
    .syncstatus(core_syncstatus),
    .errdetect(core_errdetect),
    .ctrldetect(core_ctrldetect),
    .disparityerr(core_disparityerr),
    .patterndetect(core_patterndetect),
    .clkout(core_clkout)
    );
   defparam s_rx_core.channel_width        = deserialization_factor;
   defparam s_rx_core.use_double_data_mode = use_double_data_mode;
   defparam s_rx_core.use_channel_align    = use_channel_align;
   defparam s_rx_core.use_8b_10b_mode      = use_8b_10b_mode;
   defparam s_rx_core.synchronization_mode = synchronization_mode;
   defparam s_rx_core.align_pattern        = align_pattern;

// - added gfifo
stratixgx_hssi_divide_by_two s_rx_clkout_mux   
(
   .reset(reset_int),
   .clkin(rxrdclk_mux1), 
   .clkout(clkoutmux_clkout_pre)
);
defparam s_rx_clkout_mux.divide = use_double_data_mode;

// gererate output signals

// outputs from serdes
and (recovclkout, 1'b1, serdes_clkout);
and (rlv, 1'b1, serdes_rlv);
and (lock, serdes_lock, 1'b1);
and (freqlock, serdes_freqlock, 1'b1);
and (signaldetect, serdes_signaldetect, 1'b1);

// outputs from word_aligner
and (syncstatusdeskew, wa_syncstatusdeskew, 1'b1);

// outputs from deskew FIFO
and (adetectdeskew, dsfifo_adetectdeskew, 1'b1);
and (rdalign, dsfifo_rdalign, 1'b1);

// outputs from comp FIFO
and (fifofull, cmfifo_fifofull, 1'b1);
and (fifoalmostfull, cmfifo_fifoalmostfull, 1'b1);
and (fifoempty, cmfifo_fifoempty, 1'b1);
and (fifoalmostempty, cmfifo_fifoalmostempty, 1'b1);
and (fifordout, cmfifo_fifordout, 1'b1);
and (disablefifordout, cmfifo_disablefifordout, 1'b1);
and (disablefifowrout, cmfifo_disablefifowrout, 1'b1);

// outputs from decoder 
and (xgmctrldet, decoder_xgmctrldet, 1'b1);
and (xgmrunningdisp, decoder_xgmrunningdisp, 1'b1);
and (xgmdatavalid, decoder_xgmdatavalid, 1'b1);

buf (xgmdataout[0], decoder_xgmdataout[0]);
buf (xgmdataout[1], decoder_xgmdataout[1]);
buf (xgmdataout[2], decoder_xgmdataout[2]);
buf (xgmdataout[3], decoder_xgmdataout[3]);
buf (xgmdataout[4], decoder_xgmdataout[4]);
buf (xgmdataout[5], decoder_xgmdataout[5]);
buf (xgmdataout[6], decoder_xgmdataout[6]);
buf (xgmdataout[7], decoder_xgmdataout[7]);

// outputs from rx_core
and (syncstatus[0], core_syncstatus[0], 1'b1);
and (syncstatus[1], core_syncstatus[1], 1'b1);

and (patterndetect[0], core_patterndetect[0], 1'b1);
and (patterndetect[1], core_patterndetect[1], 1'b1);

and (ctrldetect[0], core_ctrldetect[0], 1'b1);
and (ctrldetect[1], core_ctrldetect[1], 1'b1);

and (errdetect[0], core_errdetect[0], 1'b1);
and (errdetect[1], core_errdetect[1], 1'b1);

and (disperr[0], core_disparityerr[0], 1'b1);
and (disperr[1], core_disparityerr[1], 1'b1);

and (a1a2sizeout[0], core_a1a2sizeout[0], 1'b1);
and (a1a2sizeout[1], core_a1a2sizeout[1], 1'b1);

assign dataout_tmp = core_dataout;

buf (dataout[0], dataout_tmp[0]);
buf (dataout[1], dataout_tmp[1]);
buf (dataout[2], dataout_tmp[2]);
buf (dataout[3], dataout_tmp[3]);
buf (dataout[4], dataout_tmp[4]);
buf (dataout[5], dataout_tmp[5]);
buf (dataout[6], dataout_tmp[6]);
buf (dataout[7], dataout_tmp[7]);
buf (dataout[8], dataout_tmp[8]);
buf (dataout[9], dataout_tmp[9]);
buf (dataout[10], dataout_tmp[10]);
buf (dataout[11], dataout_tmp[11]);
buf (dataout[12], dataout_tmp[12]);
buf (dataout[13], dataout_tmp[13]);
buf (dataout[14], dataout_tmp[14]);
buf (dataout[15], dataout_tmp[15]);
buf (dataout[16], dataout_tmp[16]);
buf (dataout[17], dataout_tmp[17]);
buf (dataout[18], dataout_tmp[18]);
buf (dataout[19], dataout_tmp[19]);

// output from clkout mux
// - added gfifo
assign clkoutmux_clkout = ((use_parallel_feedback == "false") && clk_out_mode_reference == "false") ? serdes_clkout : clkoutmux_clkout_pre;
and (clkout, 1'b1, clkoutmux_clkout);

endmodule




