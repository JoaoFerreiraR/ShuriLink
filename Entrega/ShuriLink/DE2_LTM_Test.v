// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 LTM  Test
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            		:| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang ,Johnny Fan   :| 07/04/12  :| Initial Revision
//   V1.1 :| ben                    :| 11/03/14  :| Quartus 10.1 sp1
// --------------------------------------------------------------------

module DE2_LTM_Test
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,								//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,								//	Seven Segment Digit 0
		HEX1,								//	Seven Segment Digit 1
		HEX2,								//	Seven Segment Digit 2
		HEX3,								//	Seven Segment Digit 3
		HEX4,								//	Seven Segment Digit 4
		HEX5,								//	Seven Segment Digit 5
		HEX6,								//	Seven Segment Digit 6
		HEX7,								//	Seven Segment Digit 7
		////////////////////////	LED		////////////////////////
		LEDG,								//	LED Green[8:0]
		LEDR,								//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Receiver
		////////////////////////	IRDA	////////////////////////
		IRDA_TXD,						//	IRDA Transmitter
		IRDA_RXD,						//	IRDA Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,							//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,							//	FLASH Address bus 22 Bits
		FL_WE_N,							//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,							//	FLASH Output Enable
		FL_CE_N,							//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,							//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_DATA,						//	ISP1362 Data bus 16 Bits
		OTG_ADDR,						//	ISP1362 Address 2 Bits
		OTG_CS_N,						//	ISP1362 Chip Select
		OTG_RD_N,						//	ISP1362 Write
		OTG_WR_N,						//	ISP1362 Read
		OTG_RST_N,						//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		OTG_INT0,						//	ISP1362 Interrupt 0
		OTG_INT1,						//	ISP1362 Interrupt 1
		OTG_DREQ0,						//	ISP1362 DMA Request 0
		OTG_DREQ1,						//	ISP1362 DMA Request 1
		OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,							//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	    TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,							//	PS2 Data
		PS2_CLK,							//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  							//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_DATA,						//	DM9000A DATA bus 16Bits
		ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		ENET_CS_N,						//	DM9000A Chip Select
		ENET_WR_N,						//	DM9000A Write
		ENET_RD_N,						//	DM9000A Read
		ENET_RST_N,						//	DM9000A Reset
		ENET_INT,						//	DM9000A Interrupt
		ENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,							//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1,							//	GPIO Connection 1
	);
//===========================================================================
// PORT declarations
//===========================================================================                      

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;						//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;					//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output	[17:0]LEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
output		UART_TXD;				//	UART Transmitter
input			UART_RXD;				//	UART Receiver
////////////////////////////	IRDA	////////////////////////////
output		IRDA_TXD;				//	IRDA Transmitter
input			IRDA_RXD;				//	IRDA Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;					//	SDRAM Data bus 16 Bits
output[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout		[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output	[21:0]FL_ADDR;					//	FLASH Address bus 22 Bits
output			FL_WE_N;					//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;					//	FLASH Output Enable
output			FL_CE_N;					//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[15:0]	SRAM_DQ;					//	SRAM Data bus 16 Bits
output[17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask 
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	[15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
output[1:0]		OTG_ADDR;				//	ISP1362 Address 2 Bits
output			OTG_CS_N;				//	ISP1362 Chip Select
output			OTG_RD_N;				//	ISP1362 Write
output			OTG_WR_N;				//	ISP1362 Read
output			OTG_RST_N;				//	ISP1362 Reset
output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input				OTG_INT0;				//	ISP1362 Interrupt 0
input				OTG_INT1;				//	ISP1362 Interrupt 1
input				OTG_DREQ0;				//	ISP1362 DMA Request 0
input				OTG_DREQ1;				//	ISP1362 DMA Request 1
output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout		[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
inout				SD_DAT;					//	SD Card Data
inout				SD_DAT3;					//	SD Card Data 3
inout				SD_CMD;					//	SD Card Command Signal
output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout				I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 		PS2_DAT;					//	PS2 Data
input				PS2_CLK;					//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;						// CPLD -> FPGA (data in)
input  			TCK;						// CPLD -> FPGA (clk)
input  			TCS;						// CPLD -> FPGA (CS)
output 			TDO;						// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			ENET_CS_N;				//	DM9000A Chip Select
output			ENET_WR_N;				//	DM9000A Write
output			ENET_RD_N;				//	DM9000A Read
output			ENET_RST_N;				//	DM9000A Reset
input				ENET_INT;				//	DM9000A Interrupt
output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
inout				AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input				AUD_ADCDAT;				//	Audio CODEC ADC Data
inout				AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout				AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;					//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input		[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input				TD_HS;					//	TV Decoder H_SYNC
input				TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1

assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ			=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA		=	16'hzzzz;
assign	LCD_DATA		=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK		=	1'bz;
assign	GPIO_1		=	36'hzzzzzzzzz;
//=============================================================================
// REG/WIRE declarations
//=============================================================================
// Touch panel signal //
wire	[7:0]	ltm_r;		//	LTM Red Data 8 Bits
wire	[7:0]	ltm_g;		//	LTM Green Data 8 Bits
wire	[7:0]	ltm_b;		//	LTM Blue Data 8 Bits
wire			ltm_nclk;	//	LTM Clcok
wire			ltm_hd;		
wire			ltm_vd;		
wire			ltm_den;
wire			ltm_grst;
// lcd 3wire interface//
wire			ltm_sclk;		
wire			ltm_sda;		
wire			ltm_scen;
wire 			ltm_3wirebusy_n;	
// Touch Screen Digitizer ADC	
wire 			adc_dclk;
wire 			adc_cs;
wire 			adc_penirq_n;
wire 			adc_busy;
wire 			adc_din;
wire 			adc_dout;
wire 			adc_ltm_sclk;		

wire	[11:0] 	x_coord;
wire	[11:0] 	y_coord;
wire			new_coord;	
wire	[1:0]	display_mode;
reg 	[31:0] 	div;

////////////// GPIO_O //////////////////
assign	adc_penirq_n  =GPIO_0[0];
assign	adc_dout    =GPIO_0[1];
assign	adc_busy    =GPIO_0[2];
assign	GPIO_0[3]	=adc_din;
assign	GPIO_0[4]	=adc_ltm_sclk;
assign	GPIO_0[5]	=ltm_b[3];
assign	GPIO_0[6]	=ltm_b[2];
assign	GPIO_0[7]	=ltm_b[1];
assign	GPIO_0[8]	=ltm_b[0];
assign	GPIO_0[9]	=ltm_nclk;
assign	GPIO_0[10]	=ltm_den;
assign	GPIO_0[11]	=ltm_hd;
assign	GPIO_0[12]	=ltm_vd;
assign	GPIO_0[13]	=ltm_b[4];
assign	GPIO_0[14]	=ltm_b[5];
assign	GPIO_0[15]	=ltm_b[6];
assign	GPIO_0[16]	=ltm_b[7];
assign	GPIO_0[17]	=ltm_g[0];
assign	GPIO_0[18]	=ltm_g[1];
assign	GPIO_0[19]	=ltm_g[2];
assign	GPIO_0[20]	=ltm_g[3];
assign	GPIO_0[21]	=ltm_g[4];
assign	GPIO_0[22]	=ltm_g[5];
assign	GPIO_0[23]	=ltm_g[6];
assign	GPIO_0[24]	=ltm_g[7];
assign	GPIO_0[25]	=ltm_r[0];
assign	GPIO_0[26]	=ltm_r[1];
assign	GPIO_0[27]	=ltm_r[2];
assign	GPIO_0[28]	=ltm_r[3];
assign	GPIO_0[29]	=ltm_r[4];
assign	GPIO_0[30]	=ltm_r[5];
assign	GPIO_0[31]	=ltm_r[6];
assign	GPIO_0[32]	=ltm_r[7];
assign	GPIO_0[33]	=ltm_grst;
assign	GPIO_0[34]	=ltm_scen;
assign	GPIO_0[35]	=ltm_sda;

assign adc_ltm_sclk	= ( adc_dclk & ltm_3wirebusy_n )  |  ( ~ltm_3wirebusy_n & ltm_sclk );
assign ltm_nclk = div[0]; // 25 Mhz
assign ltm_grst = KEY[0];
always @(posedge CLOCK_50)
	begin
		div <= div+1;
	end

SEG7_LUT_8 		u1	(	
					.oSEG0(HEX0),			
					.oSEG1(HEX1),	
					.oSEG2(HEX2),	
					.oSEG3(HEX3),	
					.oSEG4(HEX4),	
					.oSEG5(HEX5),	
					.oSEG6(HEX6),	
					.oSEG7(HEX7),	
					.iDIG({ 4'h0 , x_coord , 4'h0 , y_coord }),
					.ON_OFF(8'b01110111) 
					);

// lcd 3 wire interface configuration  //
lcd_spi_cotroller	u2	(	
					// Host Side
					.iCLK(CLOCK_50),
					.iRST_n(DLY0),
					// 3wire Side
					.o3WIRE_SCLK(ltm_sclk),
					.io3WIRE_SDAT(ltm_sda),
					.o3WIRE_SCEN(ltm_scen),
					.o3WIRE_BUSY_n(ltm_3wirebusy_n)
					);	

// system reset  //
Reset_Delay		u3  (.iCLK(CLOCK_50),
					.iRST(KEY[0]),
					.oRST_0(DLY0),
					.oRST_1(DLY1),
					.oRST_2(DLY2)
					);
// Touch Screen Digitizer ADC configuration //
adc_spi_controller		u4	(
					.iCLK(CLOCK_50),
					.iRST_n(DLY0),
					.oADC_DIN(adc_din),
					.oADC_DCLK(adc_dclk),
					.oADC_CS(adc_cs),
					.iADC_DOUT(adc_dout),
					.iADC_BUSY(adc_busy),
					.iADC_PENIRQ_n(adc_penirq_n),
					.oTOUCH_IRQ(touch_irq),
					.oX_COORD(x_coord),
					.oY_COORD(y_coord),
					.oNEW_COORD(new_coord),
					);

touch_irq_detector	u5	(
					.iCLK(CLOCK_50),
					.iRST_n(DLY0),
					.iTOUCH_IRQ(touch_irq),
					.iX_COORD(x_coord),
					.iY_COORD(y_coord),
					.iNEW_COORD(new_coord),
					.oDISPLAY_MODE(display_mode),
					);

lcd_timing_controller		u6  ( 
					.iCLK(ltm_nclk),
					.iRST_n(DLY2),
					// lcd side
					.oLCD_R(ltm_r),
					.oLCD_G(ltm_g),
					.oLCD_B(ltm_b), 
					.oHD(ltm_hd),
					.oVD(ltm_vd),
					.oDEN(ltm_den),
					.iDISPLAY_MODE(display_mode),	
					);

endmodule