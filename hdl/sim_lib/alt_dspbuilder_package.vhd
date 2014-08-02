-- Copyright (C) 1991-2011 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.
-- Quartus II 11.0 Build 157 04/27/2011
--------------------------------------------------------------------------------------------
-- DSP Builder (Version 7.2)
-- Quartus II development tool and MATLAB/Simulink Interface
--------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package  alt_dspbuilder_package  is

	constant M_MAX             : NATURAL 	:= 64;
	constant MAXROM            : positive 	:= 4096;
	constant altversion        : string 	:= "DSP Builder - Quartus II development tool and MATLAB/Simulink Interface - Version 7.2";
	constant DSPBuilderQTB     : string  	:= "on";
	constant DSPBuilderVersion : string  	:= "7.2";
	constant DSPBuilderProduct : string  	:= "DSP Builder";

	Subtype max_vector is Std_Logic_Vector(M_MAX downto 0);
	type vector_2D is array(NATURAL RANGE <>) of max_vector;
	type STD_LOGIC_2DSPBUILDER is array (NATURAL RANGE <>, NATURAL RANGE <>)of std_logic  ;
	
	type STD_LOGIC_3D is array (NATURAL RANGE <>, NATURAL RANGE <>,NATURAL RANGE <>) of std_logic;
	type integer_2D is array(NATURAL RANGE <>) of integer;
	type LogicalOperator is (AltAND, AltOR, AltXOR, AltNAND, ALtNOR, AltNOT, AltShiftLeft, AltShiftRight, AltRotateRight, AltRotateLeft); 
	type CompareOperator is (Altaeb, Altaneb, Altagb, Altageb, Altalb, Altaleb); 
	type AddSubOperator is (AddAdd, AddSub, SubAdd, SubSub); 
	type BusArithm is (BusIsSigned, BusIsUnsigned, RoundLsb ,TruncateLsb, SaturMsb, TruncateMsb); 
	type RegisterStructure is (None, DataInputs, MultiplierOutput, DataInputsandMultiplier, 
								NoRegister, InputsOnly, MultiplierOnly, AdderOnly, InputsandMultiplier,
								InputsandAdder,MultiplierandAdder,InputsMultiplierandAdder);

	function nbitnecessary(value: integer) 					return integer;
	function Nstd_bitnecessary(DSigned : std_logic_vector) 	return integer;
	function nSignbitnecessary(value: integer) 				return integer;
	function int2ustd(value : integer; width : integer) 	return std_logic_vector;
	function bitvec2std(bv : bit_vector)					return std_logic_vector;
	function int2sstd(value : integer; width : integer) 	return std_logic_vector;
	function int2bit(value : integer) 						return std_logic;
	function cal_width_lpm_mult(b: boolean ; w : integer) 	return positive;
	function integer_is_even(i: integer ) 					return boolean;
	function  ceil_divide(i:integer;d:integer) 				return integer;
	function floor_divide(i:integer;d:integer) 				return integer;
	function ToNatural(i:integer) 							return integer;
	function To_String (Value: Integer) 					return STRING;
	function To_String (Value: Std_logic_vector) 			return String;
	function To_Character (Value: Std_logic) 				return Character;
	function cp_str(s1: string; s2: string) 				return boolean;
	function StdPowerOfTwo(DSigned : std_logic_vector) 		return integer; --  return -1 if not power of tow otherwisse return power of two

	component alt_dspbuilder_SBF
		generic 	(     
				width_inl	: natural  ;
				width_inr	: natural  ;
				width_outl	: natural  ;
				width_outr	: natural  ;
				round		: natural  ;
				satur		: natural  ;
				lpm_signed	: BusArithm
				);
		port 	( 
				xin			: in std_logic_vector(width_inl+width_inr-1 downto 0);
				yout		: out  std_logic_vector(width_outl+width_outr-1 downto 0)
				);	
	end component ;

	component alt_dspbuilder_SRED
		generic 	(     
				widthin		:	natural ;
				widthout	:	natural ;
				msb			:	natural ;
				lsb			:	natural ;
				round		:	natural ;
				satur		: 	natural ;
				lpm_signed	: 	BusArithm
				);
		port 		( 
				xin			: in std_logic_vector(widthin-1 downto 0);
				yout		: out std_logic_vector(widthout-1 downto 0)
				);	
	end component ;


	component alt_dspbuilder_SDelay
		generic 	(     
				lpm_width		:	positive ;
				lpm_delay		:	positive ;
				SequenceLength	:	positive ;
				SequenceValue	: 	std_logic_vector
				);
		port 		( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				clock		: in std_logic ;
				ena			: in std_logic 	;
				aclr        : in std_logic ;
                user_aclr   : in std_logic ;
                sclr		: in std_logic	;
				result		: out std_logic_vector(lpm_width-1 downto 0)
				);	
	end component ;

	component alt_dspbuilder_SInitDelay
		generic 	(     
				lpm_width	:	positive ;
				lpm_delay	:	positive ;
				SequenceLength	:	positive ;
				SequenceValue	: 	std_logic_vector;
				ResetValue	: 	std_logic_vector
				);
		port 		( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				clock		: in std_logic;
				ena		: in std_logic;
				aclr        	: in std_logic;
                		user_aclr	: in std_logic;
                		sclr		: in std_logic;
				result		: out std_logic_vector(lpm_width-1 downto 0)
				);	
	end component ;


	component alt_dspbuilder_sAltrPropagate
		generic (     
				WIDTH		    : positive ;
				QTB 			: string;
				QTB_PRODUCT 	: string;
				QTB_VERSION     : string
				);
		port 	( 
				d		: in std_logic_vector(WIDTH-1 downto 0);
				r		: out std_logic_vector(WIDTH-1 downto 0)
				);	
	end component ;


	component alt_dspbuilder_sAltrBitPropagate
		generic (     
				QTB 			: string;
				QTB_PRODUCT 	: string;
				QTB_VERSION     : string
				);
		port 	( 
				d		: in std_logic;
				r		: out std_logic
				);
	end component ;


	component alt_dspbuilder_UpsampleAltr 
		generic 	(     
				lpm_width	:	positive ;
				SamplingFactor : 	positive  
				);
		port 	( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				clock		: in std_logic ;
                aclr        : in std_logic ;
                user_aclr   : in std_logic ;
				sclr		: in std_logic ;					
				result		: out std_logic_vector(lpm_width-1 downto 0)
				);	
	end component;

	component alt_dspbuilder_SDownSampleAltr 
		generic 	(     
				lpm_width		:	positive ;
				SamplingFactor 	: 	positive  
				);
		port 	( 
				dataa			: in std_logic_vector(lpm_width-1 downto 0);
				clock			: in std_logic ;	
                aclr            : in std_logic ;
                user_aclr       : in std_logic ;				
				sclr			: in std_logic ;					
				result			: out std_logic_vector(lpm_width-1 downto 0)
				);	
	end component;

	component alt_dspbuilder_sBin2BcdAltr
		port
		(
			d		: in std_logic_vector (3 downto 0);
			r		: out std_logic_vector (6 downto 0)
		);
	end component;


	component alt_dspbuilder_SBitLogical 
		generic (     
				lpm_width	: positive 	     ;
				lop			: LogicalOperator		
				);
		port 	( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				result		: out std_logic 
				);	
	end component;

	component alt_dspbuilder_SBusLogical 
		generic (     
				lpm_width		:	positive 	 ;
				lop				:	LogicalOperator	;
				mask			: 	natural;	
				valmask		  	:   std_logic_vector;
				sgnext_rshift	: 	natural
				);
		port 		( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				result		: out std_logic_vector(lpm_width-1 downto 0) 
				);	
	end component ;
	
	component alt_dspbuilder_AltiMult
		generic (    
				lpm_widtha		:	positive 		;
				lpm_widthb		:	positive 		;
				dspb_widthr		:	positive 		;
				lpm_hint		:	string			;
				cst_val			:	std_logic_vector ;
				one_input		:	integer 		;
				pipeline		: 	natural			;
		 	 	SequenceLength	:	positive 		;
				SequenceValue	: 	std_logic_vector;
				lpm				:	natural 	);					
		port 		( 
				dataa			: 	in std_logic_vector(lpm_widtha-1 downto 0);
				datab			: 	in std_logic_vector(lpm_widthb-1 downto 0) :=(others=>'0');
				clock			: 	in std_logic	;
				ena				: 	in std_logic	;
                aclr		    : 	in std_logic    ;
				user_aclr	    : 	in std_logic    ;
				part_sclr		: 	in std_logic := '0';
				result			: 	out std_logic_vector(dspb_widthr-1 downto 0)
				);
	end component ;
	
	
	component alt_dspbuilder_BEXT
		generic ( 
				delay               : integer ;
				widthin				: positive;
				widthout			: positive
				);
		port 	( 
				din			: in std_logic_vector(widthin-1 downto 0);
				clock       : in std_logic;
				aclr        : in std_logic;
                sclr        : in std_logic;
				ena         : in std_logic;
				dout		: out std_logic_vector(widthout-1 downto 0)
				);
	end component;

	component alt_dspbuilder_nBEXT
		generic ( 
				delay               : integer ;
				widthin				: positive;
				widthout			: positive
				);
		port 	( 
				din			: in std_logic_vector(widthin-1 downto 0);
				clock       : in std_logic;
				aclr        : in std_logic;
                sclr        : in std_logic;
				ena         : in std_logic;
				dout		: out std_logic_vector(widthout-1 downto 0)
				);
	end component;

	
	component alt_dspbuilder_IncDecAltr	
		generic 	( 
		 	 	lpm_width 			: positive 	;
		 	 	cst_val				: std_logic_vector	;
		 	 	direction			: integer	;
		 	 	lpm					: natural 	;
		 	 	SequenceLength		: positive ;
				SequenceValue		: std_logic_vector ;
		  		Isunsigned			: natural 	
			  	);	  
			port 	( 
				clock 	: in std_logic :='0';
				ena 		: in std_logic :='1';
                aclr		: in std_logic :='0';
                user_aclr	: in std_logic :='0';
				sclr 		: in std_logic :='0';
				result    	: out std_logic_vector(lpm_width-1 downto 0)
				);
	end component ;

	component alt_dspbuilder_AROUND
		generic 	(     
				widthin		:	natural ;
				widthout		:	natural 
				);
		port 		( 
				xin		: in std_logic_vector(widthin-1 downto 0);
				yout		: out std_logic_vector(widthout-1 downto 0)
				);	
	end component ;

	component alt_dspbuilder_SAdderSub	
		generic ( 
		 	 	lpm_width 			: positive 	; -- input bus width 
		  		pipeline				: natural 	;
				SequenceLength		: positive 	;
				SequenceValue		: std_logic_vector 	;
		  		AddSubVal			: AddSubOperator 	:=AddAdd 	 -- SubSub is illegal
			  	);		  
		port 	( 
				dataa    	: in std_logic_vector(lpm_width-1 downto 0) ;
				datab    	: in std_logic_vector(lpm_width-1 downto 0) ;
				clock 		: in std_logic ;
				ena			: in std_logic ;
                aclr		: in std_logic ;
                user_aclr	: in std_logic ;
				seq_sclr	: in std_logic := '0';
				result    	: out std_logic_vector(lpm_width downto 0) 
				);
	end component;

	component alt_dspbuilder_ASAT
		generic 	(     
				widthin		:	natural ;
				widthout		:	natural ;
				lpm_signed	: 	BusArithm 
				);
		port 		
				( 
				xin			: in std_logic_vector(widthin-1 downto 0);
				yout		: out std_logic_vector(widthout-1 downto 0)
				);	
	end component ;

		
	component alt_dspbuilder_comparatorAltr
		generic (     
				lpm_width		:	natural ;
				direction		:	CompareOperator ;
				lpm				: 	integer 
				);
		port 	( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				datab		: in std_logic_vector(lpm_width-1 downto 0);
				result		: out std_logic
				);
	end component ;


	component alt_dspbuilder_vecseq
		generic (     
				SequenceLength		:	positive ;
				SequenceValue		: 	std_logic_vector
				);
		port 	( 
				clock		: in std_logic ;
				ena			: in std_logic ;
                aclr			: in std_logic ;	
				sclr			: in std_logic ;	
				yout			: out std_logic 
				);	
	end component ;


	component alt_dspbuilder_seq
		generic (     
				SequenceLength		:	positive ;
				SequenceValue		: 	positive
				);
		port 	( 
				clock		: in std_logic ;
				ena			: in std_logic ;
                aclr			: in std_logic ;	
				sclr			: in std_logic ;			
				yout			: out std_logic 
				);	
	end component ;

	component alt_dspbuilder_sync_dpram_single_clock
	    generic (
	        lpm_widthad :    integer ;
	        lpm_width :    integer
	        );
	    port (
	        wraddress     	: in std_logic_vector(lpm_widthad-1 downto 0);
	        rdaddress     	: in std_logic_vector(lpm_widthad-1 downto 0);
	        data 			: in  std_logic_vector(lpm_width-1 downto 0);
	        q 				: out std_logic_vector(lpm_width-1 downto 0);
	        wr  			: in std_logic ;
	        rden  			: in std_logic ;
	        clock 			: in std_logic
	        );
	end component;

	component alt_dspbuilder_SDpram
		generic 	(     
				LPM_WIDTH		:	positive ;
				LPM_WIDTHAD		:	positive ;
				ram_block_type	: 	STRING ;
				SequenceLength	:	positive ;
				SequenceValue	: 	std_logic_vector 
				);
		port 		( 
				data				:	in std_logic_vector(lpm_width-1 downto 0);
				rdaddress		:	in std_logic_vector(LPM_WIDTHAD-1 downto 0);
				wraddress		:	in std_logic_vector(LPM_WIDTHAD-1 downto 0);
				clock			:	in std_logic ;
				wren				:	in std_logic ;
				sclr				: 	in std_logic ;
                aclr				: 	in std_logic ;
                user_aclr			: 	in std_logic ;
				q				:	out std_logic_vector(lpm_width-1 downto 0)
				);	
	end component ;


	component alt_dspbuilder_SLRom_AltSyncRam
		generic
		(
			width_a 		       : natural ;
			widthad_a 		       : natural ;			
			register_output        : string  ;
			intended_device_family : string  ;
			init_file              : string             
		);	
		port
		(
			address		: in std_logic_vector (widthad_a-1 downto 0);
			aclr		: in std_logic                              ;
            user_aclr	: in std_logic                              ;
			clken		: in std_logic                              ;		
			clock		: in std_logic                              ;
			q			: out std_logic_vector (width_a-1 downto 0)
		);
	end component;

	component alt_dspbuilder_SLRom
		generic 	(     
				LPM_WIDTH			    : positive;
				LPM_WIDTHAD		        : positive;
				SequenceLength          : positive;
				SequenceValue	        : std_logic_vector;
				XFILE			        : string;
     			intended_device_family  : string;
     			stratix_type            : natural;
		  		is_unsigned				: natural  
				);
		port 	( 
				address			: in std_logic_vector(LPM_WIDTHAD-1 downto 0);
				clock			: in std_logic ;
                aclr			: in std_logic ;
                user_aclr		: in std_logic ;
				ena				: in std_logic :='1';
				q				: out std_logic_vector(lpm_width+is_unsigned-1 downto 0)
				);	
	end component ;

	component alt_dspbuilder_SUsgn
		generic 	(  
				LPM_WIDTHL			:	positive ;
				LPM_WIDTHR			:	positive 
				);
		port 		( 
				data			: in std_logic_vector(LPM_WIDTHL+LPM_WIDTHR-1 downto 0);
				q			: out std_logic_vector(LPM_WIDTHL downto 0)
				);	
	end component ;

	component alt_dspbuilder_SShiftTap
		generic (     
				width				:	positive ;
				number_of_taps		:	positive ;
				use_dedicated_circuitry : natural;
				lpm_hint			: string ;
				tap_distance		:	positive 
				);
		port 	( 
				data		: in std_logic_vector(width-1 downto 0);
				clock		: in std_logic;
                aclr        : in std_logic;
                user_aclr   : in std_logic;
				sclr		: in std_logic;
				ena			: in std_logic;
				taps		: out std_logic_vector(width*number_of_taps-1 downto 0);
				shiftout	: out std_logic_vector(width-1 downto 0)
				);
	end component ;

	component alt_dspbuilder_AltiSMac
		generic 	(     
						width_a			:	positive ;
						width_b			:	positive ;
						width_result	: 	positive ;
						use_dedicated_circuitry :   natural ;
						RegStruct		: 	RegisterStructure					
					);
		port 		( 
						dataa		: IN STD_LOGIC_VECTOR (width_a-1 DOWNTO 0);
						datab		: IN STD_LOGIC_VECTOR (width_b-1 DOWNTO 0);
						addnsub		: IN STD_LOGIC  := '1';
						accum_sload	: IN STD_LOGIC  := '0';
						clock		: IN STD_LOGIC  := '1';
						ena			: IN STD_LOGIC  := '1';
						aclr		: IN STD_LOGIC  := '0';
						result		: out STD_LOGIC_VECTOR (width_result-1 DOWNTO 0);
						overflow	: OUT STD_LOGIC 
					);	
	end component ;

	component alt_dspbuilder_AltiSMacMF
		generic 	(     
						width_a			:	positive ;
						width_b			:	positive ;
						width_result	: 	positive ;
						RegStruct		: 	RegisterStructure					
					);
		port 		( 
						dataa		: IN STD_LOGIC_VECTOR (width_a-1 DOWNTO 0);
						datab		: IN STD_LOGIC_VECTOR (width_b-1 DOWNTO 0);
						addnsub		: IN STD_LOGIC  := '1';
						accum_sload	: IN STD_LOGIC  := '0';
						clock		: IN STD_LOGIC  := '1';
						ena			: IN STD_LOGIC  := '1';
						aclr		: IN STD_LOGIC  := '0';
						result		: out STD_LOGIC_VECTOR (width_result-1 DOWNTO 0);
						overflow	: OUT STD_LOGIC 
					);	
	end component ;


	component alt_dspbuilder_AltiSMacUsg
		generic 	(     
						width_a			:	positive ;
						width_b			:	positive ;
						width_result	: 	positive ;
						use_dedicated_circuitry :   natural ;
						RegStruct		: 	RegisterStructure					
					);
		port 		( 
						dataa		: IN STD_LOGIC_VECTOR (width_a-1 DOWNTO 0);
						datab		: IN STD_LOGIC_VECTOR (width_b-1 DOWNTO 0);
						addnsub		: IN STD_LOGIC  := '1';
						accum_sload	: IN STD_LOGIC  := '0';
						clock		: IN STD_LOGIC  := '1';
						ena			: IN STD_LOGIC  := '1';
						aclr		: IN STD_LOGIC  := '0';
                        user_aclr	: IN STD_LOGIC  := '0';
						result		: out STD_LOGIC_VECTOR (width_result-1 DOWNTO 0);
						overflow	: OUT STD_LOGIC 
					);	
	end component ;


	component alt_dspbuilder_CST_MULT is 
		GENERIC (
			      widthin      : positive ;    
			      widthcoef    : positive ;    
			      widthr       : positive ;    
			      cst          : std_logic_vector  ;
			      lpm_hint	   : string   ;
			      pipeline     : natural  );
		PORT (
					clock		: in std_logic;
					aclr		: in std_logic;
                    part_sclr    : in std_logic := '0';
					ena     	: in std_logic;
					data		: in std_logic_vector  (widthin-1 DOWNTO 0);
					result		: out std_logic_vector (widthr-1 DOWNTO 0)
		      );
		      
	end component ;

	component alt_dspbuilder_MultAdd
		generic 	(     
						width_a					:	positive ;
						width_r					:	positive ;
						direction				:   AddSubOperator ;
						nMult					:   positive ;
						intended_device_family	:	string;
						use_dedicated_circuitry :   natural ;
						representation			:   string ;
						regstruct				: 	registerstructure 					
					);
		port 		( 
						dat1aa		: in std_logic_vector (width_a-1 downto 0);
						dat1ab		: in std_logic_vector (width_a-1 downto 0);
						dat2aa		: in std_logic_vector (width_a-1 downto 0);
						dat2ab		: in std_logic_vector (width_a-1 downto 0);
						dat3aa		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						dat3ab		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						dat4aa		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						dat4ab		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						clock		: in std_logic  := '1';
						ena			: in std_logic  := '1';
						part_sclr	: in std_logic  := '0';
						aclr		: in std_logic	:= '0';
						user_aclr	: in std_logic  := '0';
						result		: out std_logic_vector (width_r-1 downto 0)
					);	
	end component ;


	component alt_dspbuilder_MultAddMF
		generic 	(     
						width_a					:	positive ;
						width_r					:	positive ;
						direction				:   AddSubOperator ;
						nMult					:   positive ;
						intended_device_family	:	string ;
						representation			:   string ;						
						regstruct				: 	registerstructure 					
					);
		port 		( 
						dat1aa		: in std_logic_vector (width_a-1 downto 0);
						dat1ab		: in std_logic_vector (width_a-1 downto 0);
						dat2aa		: in std_logic_vector (width_a-1 downto 0);
						dat2ab		: in std_logic_vector (width_a-1 downto 0);
						dat3aa		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						dat3ab		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						dat4aa		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						dat4ab		: in std_logic_vector (width_a-1 downto 0):=(others=>'0');
						clock		: in std_logic  := '1';
						ena			: in std_logic  := '1';
						aclr		: in std_logic  := '0';
						result		: out std_logic_vector (width_r-1 downto 0)
					);	
	end component ;

	component alt_dspbuilder_signaltapunit
		generic (upper_limit: integer ;
				 lower_limit: integer );
		port(
			data_in		: in	std_logic_vector(upper_limit downto lower_limit);
			data_out	: out	std_logic_vector(upper_limit downto lower_limit));
	end component ;

	component alt_dspbuilder_CplxMult
		generic 	(     
						width			:	positive
					);
		port 		( 
						dataareal		: in std_logic_vector (width-1 downto 0);
						dataaimag		: in std_logic_vector (width-1 downto 0);
						databreal		: in std_logic_vector (width-1 downto 0);
						databimag		: in std_logic_vector (width-1 downto 0);
						resultreal		: out std_logic_vector (2*width downto 0):=(others=>'0');
						resultimag		: out std_logic_vector (2*width downto 0):=(others=>'0')
					);	
	end component ;


	component alt_dspbuilder_AltMultConst
		generic 	(     
						CA				:	std_logic_vector ;
						CB				:	std_logic_vector ;
						CC				:	std_logic_vector ;
						CD				:	std_logic_vector ;
						width_a			:	positive ;
						width_r			:	positive ;					
						regstruct		: 	registerstructure :=NoRegister					
					);
		port 		( 
						datain			: in std_logic_vector (width_a-1 downto 0);
						datbin			: in std_logic_vector (width_a-1 downto 0);
						datcin			: in std_logic_vector (width_a-1 downto 0);
						datdin			: in std_logic_vector (width_a-1 downto 0);
						dataout			: out std_logic_vector (width_r-1 downto 0);
						clock			: in std_logic  := '1';
						ena				: in std_logic  := '1';
						sclr			: in std_logic  := '0';
						aclr			: in std_logic  := '0';
                        user_aclr		: in std_logic  := '0'
					);
	end component ;

	component alt_dspbuilder_Par2Ser
		generic (     
			msbfirst	: boolean ;
			repeatlastbit	: boolean ;
			widthin		: natural 
		);
		port ( 
			xin	: in std_logic_vector(widthin-1 downto 0):=(others=>'0');
			ena	: in std_logic :='1';
			load	: in std_logic :='0';
			clock	: in std_logic;
			aclr	: in std_logic :='0';
			sclr	: in std_logic :='0';
                    	sout	: out std_logic
		);	
	end component;

	component alt_dspbuilder_Ser2Par
		generic (     
			msbfirst	: boolean ;
			widthin		: natural 
		);
		port ( 
			sin	: in std_logic :='0';
			clock	: in std_logic ;
			ena	: in std_logic :='1';
			sclr	: in std_logic :='0';
                    	aclr	: in std_logic :='0';
			xout	: out std_logic_vector(widthin-1 downto 0)
		);
	end component ;

	component alt_dspbuilder_dividerAltr
		generic (     
					widthin		: natural;
					isunsigned	: natural ;
					pipeline	: natural
				);
		port
		(
			clock		: in std_logic := '0';
            aclr		: in std_logic := '0';
            user_aclr	: in std_logic := '0';
			clken		: in std_logic := '1';
			numer		: in std_logic_vector (widthin-1 downto 0);
			denom		: in std_logic_vector (widthin-1 downto 0);
			quotient	: out std_logic_vector (widthin-1 downto 0);
			remain		: out std_logic_vector (widthin-1 downto 0)
		);
	end component ;

	component alt_dspbuilder_butterflyAltr
		generic 	(     
						WidthIn					: positive ;
						WidthOut				: positive ;
						WidthOutLsb				: natural ;
						pipeline 				: natural;
						W_is_constant 			: natural;
						W_real 					: std_logic_vector;
						W_imag 					: std_logic_vector;
						lpm_hint				: string;
						DecimationInTime 		: natural 
					);
		port 		( 
						clock		: in std_logic:= '0';
                        aclr		: in std_logic:= '0'  ;
						user_aclr   : in std_logic:= '0'  ;
                        ena			: in std_logic:= '1'  ;
						part_sclr	: in std_logic:= '0'  ;
						areal		: in std_logic_vector (WidthIn-1 downto 0);
						aimag		: in std_logic_vector (WidthIn-1 downto 0);
						breal		: in std_logic_vector (WidthIn-1 downto 0);
						bimag		: in std_logic_vector (WidthIn-1 downto 0);
						wreal		: in std_logic_vector (WidthIn-1 downto 0);
						wimag		: in std_logic_vector (WidthIn-1 downto 0);
						rAreal		: out std_logic_vector (WidthOut-1 downto 0);
						rAimag		: out std_logic_vector (WidthOut-1 downto 0);
						rBreal		: out std_logic_vector (WidthOut-1 downto 0);
						rBimag		: out std_logic_vector (WidthOut-1 downto 0)
					);	
	end component ;

	component alt_dspbuilder_sLpmAddSub
		generic
		(
			width	   : positive;
			isunsigned : natural;	
			pipeline   : natural	
		);
		port
		(
			add_sub		: in std_logic ;
			dataa		: in std_logic_vector (width-1 downto 0);
			datab		: in std_logic_vector (width-1 downto 0);
			cin			: in std_logic :='0';
			clock		: in std_logic :='0';
			aclr		: in std_logic :='0';
            user_aclr	: in std_logic :='0';
			clken		: in std_logic :='1';
			result		: out std_logic_vector (width-1 downto 0);
			cout		: out std_logic 
		);
	end component;

	component alt_dspbuilder_sLpmCount
		GENERIC
		(
			width		: NATURAL ;
			modulus		: NATURAL 
		);
		PORT
		(
			data	: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			sload	: IN STD_LOGIC ;
			updown	: IN STD_LOGIC ;
			clk_en	: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			clock	: IN STD_LOGIC ;
            aclr		: IN STD_LOGIC ;
            user_aclr	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
		);
	END component;


	component alt_dspbuilder_sIntegratorAltr
		GENERIC
		(
			width		: natural ;
			depth		: positive 
		);
		PORT
		(
			data	: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			clk_en	: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			clock	: IN STD_LOGIC ;
            aclr        : IN STD_LOGIC ;
            user_aclr   : IN STD_LOGIC ;
			q	    : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
		);
	END component;

	component alt_dspbuilder_sdecoderaltr
		GENERIC
		(
			width		: NATURAL ; 
			pipeline	: NATURAL ; 
			decode		: std_logic_vector 
		);
		PORT
		(
			clock   : in std_logic;
			aclr        : IN STD_LOGIC ;
            user_aclr   : IN STD_LOGIC ;
            sclr        : IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			dec		: OUT STD_LOGIC
		);
	end component;

	component alt_dspbuilder_sDifferentiatorAltr
		GENERIC
		(
			width		: natural ;
			depth		: positive 
		);
		PORT
		(
			data	: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			clk_en	: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			clock	: IN STD_LOGIC ;
            aclr        : IN STD_LOGIC ;
            user_aclr   : IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)
		);
	END component;

	component alt_dspbuilder_sFir4TapCoefSerialAltr
		GENERIC
		(
			representation	: STRING;
			width			: NATURAL
		);
		PORT
		(
			clock0		: IN STD_LOGIC  ;
			dataa_0		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0) ;
			aclr		: IN STD_LOGIC  ;
            user_aclr	: IN STD_LOGIC  ;
			datab_0		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			ena0		: IN STD_LOGIC  ;
			shiftouta	: OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			shiftoutb	: OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (2*width+1 DOWNTO 0)
		);
	end component;

	component alt_dspbuilder_sFir4TapCoefParAltr
		GENERIC
		(
			representation	: STRING;
			Ntap			: NATURAL;
			width			: NATURAL
		);
		PORT
		(
			clock		: IN STD_LOGIC  ;
			aclr		: IN STD_LOGIC  ;
            user_aclr	: IN STD_LOGIC  ;
			ena			: IN STD_LOGIC  ;
			dataa		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			coef_0		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0) ;
			coef_1		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0) ;
			coef_2		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			coef_3		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			sout	: OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (2*width+1 DOWNTO 0)
		);
	end component;


	component alt_dspbuilder_sFir2TapCoefParAltr
		GENERIC
		(
			representation	: STRING;
			Ntap			: NATURAL;
			width			: NATURAL
		);
		PORT
		(
			clock		: IN STD_LOGIC  ;
			aclr		: IN STD_LOGIC  ;
            user_aclr	: IN STD_LOGIC  ;
			ena			: IN STD_LOGIC  ;
			dataa		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			coef_0		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0) ;
			coef_1		: IN STD_LOGIC_VECTOR (width-1 DOWNTO 0) ;
			sout	: OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (2*width DOWNTO 0)
		);
	end component;


	component alt_dspbuilder_DFFEALTR	
		GENERIC
		(
			width			: NATURAL
		);
		PORT
		(
			d		: IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
			clock   : IN STD_LOGIC;
			ena		: IN STD_LOGIC;
			prn		: IN STD_LOGIC;
			clrn	: IN STD_LOGIC;
			q		: OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0)
		);
	END component;

	component alt_dspbuilder_TFFEALTR	
		GENERIC
		(
			width			: NATURAL
		);
		PORT
		(
			t	: IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
			clock   : IN STD_LOGIC;
			ena	: IN STD_LOGIC;
			prn	: IN STD_LOGIC;
			clrn	: IN STD_LOGIC;
			q		: OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0)
		);
	END component;

	component alt_dspbuilder_sCFifoAltr
		generic
		(
			width			: natural ; 
			widthud			: natural ; 
			numwords		: natural ; 
			lpm_hint		: string ;
			intended_device_family	: string ;
			showahead_mode		: string ;
			use_eab			: string
		);	
		port
		(
			data	: in std_logic_vector (width-1 downto 0);
			wrreq	: in std_logic ;
			rdreq	: in std_logic ;
			clock	: in std_logic ;
			aclr	: in std_logic ;		
            user_aclr	: in std_logic ;		
			sclr	: in std_logic ;			
			q	: out std_logic_vector (width-1 downto 0);
			full	: out std_logic ;
			empty	: out std_logic ;
			usedw	: out std_logic_vector (widthud-1 downto 0)
		);
	end component;


	component alt_dspbuilder_sRounderAltr
		generic (     
				widthin		: natural; 
				widthout	: natural ; 
				bround		: natural ;
				pipeline	: natural ;
				lpm_representation: string
				);
		port 	( 
				clock	: in std_logic;
                aclr	: in std_logic;
                user_aclr : in std_logic;
				sclr	: in std_logic;
				xin		: in std_logic_vector(widthin-1 downto 0);
				yout	: out std_logic_vector(widthout-1 downto 0)
				);	
	end component;

	component alt_dspbuilder_ASATPIPE
		generic (
			     widthin		: natural          ;
			     widthout	    : natural          ; 
			     bsat		    : natural          ;
			     lpm_signed	    : BusArithm        ;
			     pipeline	    : natural          ;
			     UseCustomValue	: natural          ;
			     UpperValue	    : std_logic_vector ;
			     LowerValue	    : std_logic_vector 
				);
		port 	( 
				clock	: in std_logic;
                aclr    : in std_logic;
                user_aclr : in std_logic;
                ena 	:	in std_logic;
				sclr	: in std_logic;
				xin		: in std_logic_vector(widthin-1 downto 0);
				sat_flag : out std_logic;
				yout	: out std_logic_vector(widthout-1 downto 0)
				);	
	end component;

	component alt_dspbuilder_BarrelShiftAltr
		generic (     
					widthin		: natural ;
					widthd		: natural ;
					pipeline	: natural ;
					ndirection	: natural ;
					use_dedicated_circuitry : natural
				);
		port 	( 
					xin			: in std_logic_vector(widthin-1 downto 0);
					distance	: in std_logic_vector(widthd-1 downto 0);
					sclr		: in std_logic;
					ena			: in std_logic;
					clock		: in std_logic;
                    aclr		: in std_logic;
					direction	: in std_logic;
					yout		: out std_logic_vector(widthin-1 downto 0)
				);
	end component;

	component alt_dspbuilder_BarrelShiftAltrUsg
		generic (     
					widthin		: natural ;
					widthd		: natural ;
					pipeline	: natural ;
					ndirection	: natural ;
					use_dedicated_circuitry : natural
				);
		port 	( 
					xin			: in std_logic_vector(widthin-1 downto 0);
					distance	: in std_logic_vector(widthd-1 downto 0);
					sclr		: in std_logic;
					clock		: in std_logic;
                    aclr		: in std_logic;
                    user_aclr	: in std_logic;
					direction	: in std_logic;
					yout		: out std_logic_vector(widthin-1 downto 0)
				);
	end component;

	component alt_dspbuilder_sLFSRAltr
		generic (     
					width						: natural ;
					LFSRPrimPoly				: std_logic_vector ;
					RegisterInitialValuesBin	: std_logic_vector ;
					LFSRstructure				: natural;
					XorType						: natural				 
				);
		port 	( 
					sclr		: in std_logic;
					clock		: in std_logic;
                    aclr		: in std_logic;
                    user_aclr	: in std_logic;
					ena			: in std_logic;
					sout		: out std_logic;
					pout		: out std_logic_vector(width-1 downto 0)
				);
	end component;

	component alt_dspbuilder_sMultiBitAddSub
		generic ( 
				NumberOfInputBits	: positive ;
				dspb_widthr			: positive ;
				pipeline			: natural ;
				lpm_widthcoef		: positive ;
				coef0				: std_logic_vector ;
				coef1				: std_logic_vector ;
				coef2				: std_logic_vector ;
				coef3				: std_logic_vector ;
				coef4				: std_logic_vector ;
				coef5				: std_logic_vector ;
				coef6				: std_logic_vector ;
				coef7				: std_logic_vector
				);
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic;
                aclr		: in std_logic;
				sclr		: in std_logic;
				dataa		: in std_logic_vector(NumberOfInputBits-1 downto 0);
				result		: out std_logic_vector(dspb_widthr-1 downto 0)
				);
	end component;

	component alt_dspbuilder_sDAMultAddAltr
		generic ( 
				nTap			: positive ;
				widthdata		: positive ;
				widthrbit		: positive ;
				widthr			: positive ;
				widtho			: positive ;
				vlsb			: natural ;
				pipeline		: natural ;
				widthcoef		: positive ;
				lpm_hint		: string ;
				coef0			: std_logic_vector ;
				coef1			: std_logic_vector ;
				coef2			: std_logic_vector ;
				coef3			: std_logic_vector ;
				coef4			: std_logic_vector ;
				coef5			: std_logic_vector ;
				coef6			: std_logic_vector ;
				coef7			: std_logic_vector
				);
		port 	( 
				clock		: in std_logic:='0';
				ena			: in std_logic:='1';
                user_aclr	: in std_logic:='0';
                aclr		: in std_logic:='0';
				part_sclr	: in std_logic:='0';
				dataa0		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa1		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa2		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa3		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa4		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa5		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa6		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				dataa7		: in std_logic_vector(widthdata-1 downto 0):=(others=>'0');
				result		: out std_logic_vector(widtho-vlsb-1 downto 0)
				);
	end component;


	component alt_dspbuilder_sMultAltr
		generic ( 
				lpm_widtha			: positive ;
				lpm_widthb			: positive ;
				lpm_representation	: string ;
				lpm_hint			: string ;
				OutputMsb			: natural ;
				OutputLsb			: natural ;
				pipeline			: natural 
				);
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic;
                aclr		: in std_logic;
                user_aclr	: in std_logic;
				dataa		: in std_logic_vector(lpm_widtha-1 downto 0);
				datab		: in std_logic_vector(lpm_widthb-1 downto 0);
				result		: out std_logic_vector(OutputMsb-OutputLsb downto 0)
				);
	end component;

	component alt_dspbuilder_sBitWiseBusOpaltr
		generic ( 
				lpm_width			: positive ;
				Lop					: LogicalOperator 
				);
		port 	( 
				dataa		: in std_logic_vector(lpm_width-1 downto 0);
				datab		: in std_logic_vector(lpm_width-1 downto 0);
				result		: out std_logic_vector(lpm_width-1 downto 0)
				);
	end component;

	component alt_dspbuilder_sPaddAltr
		generic ( 
				width			: positive ;
				size			: positive ;
				pipeline		: natural ;
				SequenceLength	: positive ;
				SequenceValue	: std_logic_vector ;				
				widthr			: positive
				);
		port 	(
				dataa		: in std_logic_vector(width*size-1 downto 0);
				clock		: in std_logic;
				ena			: in std_logic;
				sclr		: in std_logic;
                aclr		: in std_logic;
                user_aclr	: in std_logic;
				result		: out std_logic_vector(widthr-1 downto 0)
				);
	end component;

	component alt_dspbuilder_sMuxAltr
		generic ( 	lpm_pipeline	: NATURAL:=0;
					lpm_size		: positive;
					lpm_widths		: positive;
					lpm_width		: positive;
					SelOneHot		: natural);
		PORT	(	clock		: in std_logic ;
                    aclr		: in std_logic  := '0';
                    user_aclr	: in std_logic  := '0';
					ena			: in std_logic  := '1';
					data		: in std_logic_vector (lpm_width*lpm_size-1 downto 0);
					sel			: in std_logic_vector (lpm_widths-1 downto 0);
					result		: out std_logic_vector (lpm_width-1 downto 0));
	end component;
	
	component alt_dspbuilder_ClkDivAltr
		GENERIC
		(
			widthcnt		: NATURAL 
		);
		PORT
		(
			aclr		: IN STD_LOGIC;
			clock		: IN STD_LOGIC ;
			clock_out	: out STD_LOGIC
		);
	end component;


	COMPONENT alt_dspbuilder_parallel_add_db
		GENERIC (
			width		: NATURAL;
			representation		: STRING;
			size		: NATURAL;
			msw_subtract		: STRING;
			pipeline		: NATURAL;
			result_alignment		: STRING;
			widthr		: NATURAL;
			shift		: NATURAL
		);
		PORT (
				clken	: IN STD_LOGIC ;
				clock	: IN STD_LOGIC ;
				aclr	: IN STD_LOGIC ;
				data	: IN STD_LOGIC_2DSPBUILDER (size-1 DOWNTO 0, width-1 DOWNTO 0);
				result	: OUT STD_LOGIC_VECTOR (widthr-1 DOWNTO 0)
		);
	END COMPONENT;


	component alt_dspbuilder_SDemuxAltr
		generic 	(     
				width		:	natural ;
				widthsel	:	natural ;
				size		:	natural 
				);
		port 	( 
				din		: in std_logic_vector(width-1 downto 0);
				sel		: in  std_logic_vector(widthsel-1 downto 0);
				clock	: in std_logic;
				ena		: in std_logic;
				sclr	: in std_logic;
                aclr	: in std_logic;
                user_aclr	: in std_logic;
				result	: out std_logic_vector(size*width-1 downto 0)				
				);	
	end component ;

	component alt_dspbuilder_sDcFifoAltr 
		generic (
				intended_device_family	: STRING;
				lpm_width				: NATURAL;
				lpm_numwords			: NATURAL;
				lpm_hint                : STRING;
				clocks_are_synchronized : STRING;
				lpm_widthu				: NATURAL);
		port 	(data	: in STD_LOGIC_VECTOR (lpm_width-1 downto 0);
				wrclk	: in STD_LOGIC ;
                aclr	: in STD_LOGIC ;
                user_aclr : in STD_LOGIC ;
				rdreq	: in STD_LOGIC ;
				wrreq	: in STD_LOGIC ;
				rdclk	: in STD_LOGIC ;
				rdfull	: out STD_LOGIC ;
				rdempty	: out STD_LOGIC ;
				wrusedw	: out STD_LOGIC_VECTOR (lpm_widthu-1 downto 0):=(others=>'0');
				wrfull	: out STD_LOGIC ;
				wrempty	: out STD_LOGIC ;
				q		: out STD_LOGIC_VECTOR (lpm_width-1 downto 0);				
				rdusedw	: out STD_LOGIC_VECTOR (lpm_widthu-1 downto 0):=(others=>'0'));
	end component;


	component alt_dspbuilder_sSqrAltr 
	generic ( 	lpm_width		: positive;
		  		q_port_width	: positive;
		  		r_port_width	: positive;
		  		pipeline		: NATURAL);
	port 	( 	radical			: in STD_LOGIC_VECTOR (lpm_width-1 downto 0);
		  		clock			: in STD_LOGIC;
		  		aclr			: in STD_LOGIC;
                user_aclr		: in STD_LOGIC;
		  		ena				: in STD_LOGIC;
		  		q     			: out STD_LOGIC_VECTOR (q_port_width-1 downto 0);
		  		remainder    	: out STD_LOGIC_VECTOR (r_port_width-1 downto 0));
	end component;


	component alt_dspbuilder_sStepAltr
		generic 	(     
				StepDelay	:	positive ;
				direction	:	natural 
				);
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic;
				sclr		: in std_logic;
                aclr		: in std_logic;
                user_aclr	: in std_logic;
				q		    : out std_logic
				);	 
	end component ;

	component alt_dspbuilder_sImpulse11Altr
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic :='1';
				sclr		: in std_logic :='0';
                aclr		: in std_logic :='0';
				q		   : out std_logic
				);	
	end component ;

	component alt_dspbuilder_sImpulse1nAltr
		generic (     
				Impulsewidth	:	positive 
				);
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic :='1';
				sclr		: in std_logic :='0';
                aclr		: in std_logic :='0';
				q		   : out std_logic
				);	
	end component ;

	component alt_dspbuilder_sImpulsen1Altr
		generic (     
				Impulsedelay	:	positive 
				);
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic :='1';
				sclr		: in std_logic :='0';
                aclr		: in std_logic :='0';
				q		   : out std_logic
				);	
	end component ;

	component alt_dspbuilder_sImpulsennAltr
		generic (     
				Impulsedelay	:	positive ;
				Impulsewidth	:	positive 
				);
		port 	( 
				clock		: in std_logic ;
				ena			: in std_logic ;
				sclr		: in std_logic ;
                aclr		: in std_logic :='0';
				q		   : out std_logic
				);	
	end component ;

	component alt_dspbuilder_sImpulseAltr
		generic 	(     
				Impulsedelay	:	positive ;
				Impulsewidth	:	positive 
				);
		port 	( 
				clock		: in std_logic;
				ena			: in std_logic;
				sclr		: in std_logic;
                aclr		: in std_logic;
                user_aclr	: in std_logic;
				q		    : out std_logic
				);	
	end component ;

	component alt_dspbuilder_jtag_node is
		generic (
				width			: positive := 8;
					-- Node Info ID that uniquely identifies a instance of the node.
					-- MFG ID:		110 (0x6E)
					-- NODE ID:		6 (0x6) (HIL)
					-- Version:		0 (0x0)
					-- Instance ID:		0 (0x0)
				sld_node_info	: positive := 3173888); -- 0x00306E00
		port (
			-- Shared JTAG ports
				raw_tck			: in std_logic;		-- JTAG test clock
				raw_tms			: in std_logic;		-- JTAG test mode select signal
				tdi				: in std_logic;		-- JTAG test data input, comes LSB first
				jtag_state_tlr	: in std_logic;		-- Signals that the JSM  is in the Test_Logic_Reset state
				jtag_state_rti	: in std_logic;		-- Signals that the JSM is in the Run_Test/Idle state
				jtag_state_sdrs	: in std_logic;		-- Signals that the JSM is in the Select_DR_Scan state
				jtag_state_cdr	: in std_logic;		-- Signals that the JSM is in the Capture_DR state
				jtag_state_sdr	: in std_logic;		-- Signals that the JSM is in the Shift_DR state
				jtag_state_e1dr	: in std_logic;		-- Signals that the JSM is in the Exit1_DR state
				jtag_state_pdr	: in std_logic;		-- Signals that the JSM is in the Pause_DR state
				jtag_state_e2dr	: in std_logic;		-- Signals that the JSM is in the Exit2_DR state
				jtag_state_udr	: in std_logic;		-- Signals that the JSM is in the Update_DR state
				jtag_state_sirs	: in std_logic;		-- Signals that the JSM is in the Select_IR_Scan state
				jtag_state_cir	: in std_logic;		-- Signals that the JSM is in the Capture_IR state
				jtag_state_sir	: in std_logic;		-- Signals that the JSM is in the Shift_IR state
				jtag_state_e1ir	: in std_logic;		-- Signals that the JSM is in the Exit1_IR state
				jtag_state_pir	: in std_logic;		-- Signals that the JSM is in the Pause_IR state
				jtag_state_e2ir	: in std_logic;		-- Signals that the JSM is in the Exit2_IR state
				jtag_state_uir	: in std_logic;		-- Signals that the JSM is in the Update_IR state
				usr1			: in std_logic;		-- Signals that the current instruction in the JSM is the USER1 instruction
				clrn			: in std_logic;		-- Asynchronous clear
				
			-- Node-specific JTAG ports
				ena				: in std_logic;		-- Indicates that the current instruction in the Hub is for Node i  
				ir_in			: in std_logic_vector(width-1 downto 0);	-- Node i IR
				tdo				: out std_logic;							-- Node i JTAG test data out
				ir_out			: out std_logic_vector(width-1 downto 0);	-- Node i IR capture port

			-- Interface to node
    			user_clk		: in std_logic;
				user_tck		: out std_logic;
				node_state_uir	: out std_logic;
				node_state_sdr	: out std_logic;
				user_tdi		: out std_logic;
				user_tdo		: out std_logic;
				user_IRin		: out std_logic_vector(width-1 downto 0);
				user_IRout		: in std_logic_vector(width-1 downto 0);
				user_cir		: out std_logic;	-- Capture IR
				user_sir		: out std_logic;	-- Shift IR
				user_uir		: out std_logic;	-- Update IR
				user_cdr		: out std_logic;	-- Capture DR
				user_sdr		: out std_logic;	-- Shift DR
				user_udr		: out std_logic);	-- Update DR
	end component;
	
	component alt_dspbuilder_clock_crossing_enable is
		port (
				source_clk	: in std_logic;
				source_ena	: in std_logic;
				dest_clk	: in std_logic;
				dest_ena	: out std_logic);
	end component;


end alt_dspbuilder_package ;


package body alt_dspbuilder_package is

	function nbitnecessary(value: integer) return integer is
	-- return the number of bit necessary to code the positive value-1 
	variable inc: integer ;
	variable tmp: integer ;
	begin
		tmp := value-1;
		inc := 0;
		if (tmp>0) then 
			for i in 0 to value+1 loop
				if (tmp > 0 )  then 	
					tmp := tmp / 2;	
					inc := inc +1;
				end if ;
			end loop ;
		else
			inc :=0;
		end if ;			
		return inc;
	end nbitnecessary;

	function nSignbitnecessary(value: integer) return integer is
	-- return the number of bit necessary to code value-1 
	variable inc: integer ;
	variable ttmp: integer ;
	variable tmp: integer ;
	begin
		if (value<0) then
			ttmp:=-value;
		else
			ttmp:=value;
		end if;
		tmp := ttmp;
		inc := 0;
		if (ttmp>0) then 
			for i in 0 to ttmp+2 loop
				if (tmp > 0 )  then 	
					tmp := tmp / 2;	
					inc := inc +1;
				end if ;
			end loop ;
		else
			inc :=1;
		end if ;			
		return inc+1;
	end nSignbitnecessary;

	function Nstd_bitnecessary(DSigned : std_logic_vector) return integer is
	-- return the number of bit necessary for teh signed inpt constant 
	-- of type std_logic_vector
		constant w : integer :=DSigned'Length; 
		variable r : integer :=w;
		variable d : integer :=w-2;
		constant svec : std_logic_vector(w-1 downto 0):=DSigned; 
		begin
			if (d>0) then
				if (svec(w-1)='0') then
					while (svec(d)='0' and d>0) loop
						d:=d-1;						
					end loop;
				else
					while (svec(d)='1' and d>0) loop
						d:=d-1;
					end loop;
				end if;
				d:=d+2; 
				if (d<r) then
					r := d;
				end if;
			end if;
			return r;
	end Nstd_bitnecessary;	



	function StdPowerOfTwo(DSigned : std_logic_vector) 		return integer is --  return 0 if not power of tow otherwisse return power of two

		constant w  : integer :=DSigned'Length; 
		variable r  : integer :=0;		
		variable p  : integer :=0;
		variable np : integer :=0;
		constant svec : std_logic_vector(w-1 downto 0):=DSigned; 
		
		begin
			for i in 0 to w-1 loop
				if svec(i) = '1' then
					p:=i;
					np:=np+1;
				end if;	
			end loop;
			if (np=1) then
				r:= p;
			end if;
			return r;	
		end;

	function int2ustd(value : integer; width : integer) return std_logic_vector is 
	-- convert integer to unsigned std_logicvector 
	begin
	return conv_std_logic_vector(CONV_UNSIGNED(value, width ), width);
	end int2ustd;

	function int2sstd(value : integer; width : integer) return std_logic_vector is 
	-- convert integer to signed std_logicvector 			
	begin
		if (value<0) then 
			return conv_std_logic_vector(CONV_UNSIGNED(((2**(width))+value), width ), width);
		else
			return conv_std_logic_vector(CONV_UNSIGNED(value, width ), width);
		end if;
	end int2sstd;

	function int2bit(value : integer) return std_logic is 
	-- convert integer to signed std_logicvector 			
	begin
		if (value>0) then 
			return '1';
		else
			return '0';
		end if;
	end int2bit;

	function bitvec2std(bv : bit_vector) return std_logic_vector 	is
	-- convert bit_vector to std_logic_vector 
	variable s : std_logic_vector(bv'length-1 downto 0) :=(others=>'0');
	begin
		for i in 0 to bv'length-1 loop
			if '1'=bv(i) then 
				s(i) :='1';
			else
				s(i) :='0';
			end if;
		end loop;
		return s;
	end bitvec2std;
	
	function cal_width_lpm_mult(b: boolean ; w : integer) return positive is
	-- Check if the multipler reach the max negative number
		variable i : positive;
		begin
			if b then 
				i := w-1;
			else	
				i := w;
			end if;	
			return i;
		end cal_width_lpm_mult;

	function integer_is_even(i: integer ) return boolean is
		variable even 	: boolean;
		begin
			even:= ((i+1)/2) = (i/2);
			return even;
		end integer_is_even;		


	function  ceil_divide(i:integer;d:integer) return integer is
		variable res : integer;
		begin
			if d/=0 then
				if ((i rem d)>0) then 
					res := i/d+1;
				else
					res := i/d;
				end if ;
			else
				res :=0;
			end if ;			
			return res;			 
		end ;		

	function  floor_divide(i:integer;d:integer) return integer is
		begin
			if d/=0 then 
				return i/d; 
			else
				return 0;
			end if ;			
		end ;


	function ToNatural(i:integer) return integer is
		variable inc: integer ;
		begin
			if (i<0) then 
				inc := 0;
			else
				inc :=i;
			end if ;			
			return inc;
		end ;
		
	function To_String (Value: Integer) return String is
	  variable V: Integer;
	  variable Result: String(1 to 11);
	  variable Width: Natural := 0;
	begin
	  V := abs Value;
	  for I in Result'Reverse_range loop
	    case V mod 10 is
	    when 0 => Result(I) := '0';
	    when 1 => Result(I) := '1';
	    when 2 => Result(I) := '2';
	    when 3 => Result(I) := '3';
	    when 4 => Result(I) := '4';
	    when 5 => Result(I) := '5';
	    when 6 => Result(I) := '6';
	    when 7 => Result(I) := '7';
	    when 8 => Result(I) := '8';
	    when 9 => Result(I) := '9';
	    when others =>
	              Result(I) := '?';
	    end case;
	    if V > 0 then
	       Width := Width + 1;
	    end if;
	    V := V / 10;
	  end loop;
	  if Width = 0 then
	    Width := 1;
	  end if;
	  if Value < 0 then
	    Result(Result'Length - Width) := '-';
	    Width := Width + 1;
	  end if;
	  return Result(Result'Length - Width + 1 to Result'Length);
	end To_String;

	function To_Character (Value: Std_logic) return Character is
	begin
	  case Value is
	  when 'U' => return 'U';
	  when 'X' => return 'X';
	  when '0' => return '0';
	  when '1' => return '1';
	  when 'W' => return 'W';
	  when 'L' => return 'L';
	  when 'H' => return 'H';
	  when 'Z' => return 'Z';
	  when '-' => return '-';
	  end case;    
	end To_Character;
		
	function To_String (Value: Std_logic_vector) return String is
	  constant V: Std_logic_vector(1 to Value'Length) := Value;
	  variable Result: String(1 to Value'Length);
	begin
	  for I in Result'Range loop
	    Result(I) := To_character(V(I));
	  end loop;
	  return Result;
	end To_String;


	function cp_str(s1: string; s2: string) 	return boolean is
		variable b : boolean :=false;
		begin
			if (s1'Length=s2'Length) then 
				if s1=s2 then 
					b:=true;
				end if;
			end  if;
			return b;
		end cp_str;
		
end alt_dspbuilder_package;


