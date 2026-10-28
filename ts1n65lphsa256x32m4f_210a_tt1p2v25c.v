//////////////////////////////////////////////////////////////////////////////////////
//*                                                                              */
//*STATEMENT OF USE                                                              */
//*                                                                              */
//*This information contains confidential and proprietary information of TSMC.   */
//*No part of this information may be reproduced, transmitted, transcribed,      */
//*stored in a retrieval system, or translated into any human or computer        */
//*language, in any form or by any means, electronic, mechanical, magnetic,      */
//*optical, chemical, manual, or otherwise, without the prior written permission */
//*of TSMC. This information was prepared for informational purpose and is for   */
//*use by TSMC's customers only. TSMC reserves the right to make changes in the  */
//*information at any time and without notice.                                   */
//*                                                                              */
///*******************************************************************************/
//*                                                                              */
//*      Usage Limitation: PLEASE READ CAREFULLY FOR CORRECT USAGE               */
//*                                                                              */
//* The model doesn't support the control enable, data and address signals       */
//* transition at positive clock edge.                                           */
//* Please have some timing delays between control/data/address and clock signals*/
//* to ensure the correct behavior.                                              */
//*                                                                              */
//* Please be careful when using non 2^n  memory.                                */
//* In a non-fully decoded array, a write cycle to a nonexistent address location*/
//* does not change the memory array contents and output remains the same.       */
//* In a non-fully decoded array, a read cycle to a nonexistent address location */
//* does not change the memory array contents but the output becomes unknown.    */
//*                                                                              */
//* In the verilog model, the behavior of unknown clock will corrupt the         */
//* memory data and make output unknown regardless of CEB signal.  But in the    */
//* silicon, the unknown clock at CEB high, the memory and output data will be   */
//* held. The verilog model behavior is more conservative in this condition.     */
//*                                                                              */
//* The model doesn't identify physical column and row address                   */
//*                                                                              */
//* The verilog model provides UNIT_DELAY mode for the fast function simulation. */
//* All timing values in the specification are not checked in the UNIT_DELAY mode*/
//* simulation.                                                                  */
//*                                                                              */
//* Template Version : S_01_33101                                                */
//****************************************************************************** */
//*      Macro Usage       : (+define[MACRO] for Verilog compiliers)             */
//* +TSMC_UNIT_DELAY : Enable fast function simulation.                          */
//* +TSMC_NO_WARNING : Disable all runtime warning messages from this model.     */
//* +TSMC_INITIALIZE_MEM : Initialize the memory data in verilog format.         */
//* +TSMC_INITIALIZE_FAULT : Initialize the memory fault data in verilog format. */
//* +TSMC_NO_TESTPINS_WARNING : Disable the wrong test pins connection error     */
//*                             message if necessary.                            */
//****************************************************************************** */
//*        Software         : TSMC MEMORY COMPILER 2010.02.00.a
//*        Technology       : 65 nm CMOS LOGIC Low Power 1P9M 1.2V
//*        Memory Type      : TSMC 65nm Low Power High Performance Single Port SRAM
//*        Library Name     : ts1n65lphsa256x32m4f (user specify : TS1N65LPHSA256X32M4F)
//*        Library Version  : 210a
//*        Generated Time   : 2026/08/28, 23:05:04
//*******************************************************************************
`celldefine

`ifdef TSMC_UNIT_DELAY
    `define SRAM_DELAY 0.001000
`endif





module TS1N65LPHSA256X32M4F(
    A,
    D,
    BWEB,
    WEB,
    CEB,
    CLK,
    RTSEL,
    WTSEL,

    BIST,
    
    AM,
    DM,
    BWEBM,
    WEBM,
    CEBM,
    AWT,



    Q
);

// Parameter declarations
parameter N  = 32;                                      // word width
parameter W  = 256;                                    // word depth
parameter M  = 8;                                      // address width
parameter ADR_WIDTH_COL = 2;                            // column address width
parameter ADR_WIDTH_ROW = M - ADR_WIDTH_COL;            // row address width
parameter MUX = 4;                                     // column mux width


input [M - 1:0] A;         // write address bus
input [N - 1:0] D;          // input data bus
input [N - 1:0] BWEB;       // active-low bit-wise write-enable bus
input WEB;                  // active-low write-enable
input CEB;                  // active-low chip select
input CLK;                 // write clock


input BIST;                // bist mode enable
input [M - 1:0] AM;         // write address bus
input [N - 1:0] DM;          // input data bus
input [N - 1:0] BWEBM;       // active-low bit-wise write-enable bus
input WEBM;                  // active-low write-enable
input CEBM;                  // acitve-low read-enable
input AWT;                  // asynchronus write-through


output [N - 1:0] Q;

// Test Mode
input [1:0] RTSEL;
input [2:0] WTSEL;

wire [1:0] RTSEL_i;
wire [2:0] WTSEL_i;

wire [N - 1:0] b_D;
wire [N - 1:0] b_BWEB;
wire [M - 1:0] b_A;

wire b_WEB;
wire b_CEB;

wire b_BIST;
wire [N - 1:0] b_DM;
wire [N - 1:0] b_BWEBM;
wire [M - 1:0] b_AM;

wire b_WEBM;
wire b_CEBM;

wire b_CLK;

wire b_AWT;

reg [N - 1:0] Q_n;
reg [N - 1:0] Q_mux;


wire PRIME = ~AWT;
wire NOR = ~AWT & ~BIST;
wire NORM = ~AWT & BIST;
wire CE = ~AWT & ~BIST & ~CEB;
wire CEM = ~AWT & BIST & ~CEBM;
wire WE = ~AWT & ~BIST & ~CEB & ~WEB;
wire WEM = ~AWT & BIST & ~CEBM & ~WEBM;
// Register File  Control Signal Buffers
//      Normal

buf iD0 (b_D[0], D[0]);
buf iD1 (b_D[1], D[1]);
buf iD2 (b_D[2], D[2]);
buf iD3 (b_D[3], D[3]);
buf iD4 (b_D[4], D[4]);
buf iD5 (b_D[5], D[5]);
buf iD6 (b_D[6], D[6]);
buf iD7 (b_D[7], D[7]);
buf iD8 (b_D[8], D[8]);
buf iD9 (b_D[9], D[9]);
buf iD10 (b_D[10], D[10]);
buf iD11 (b_D[11], D[11]);
buf iD12 (b_D[12], D[12]);
buf iD13 (b_D[13], D[13]);
buf iD14 (b_D[14], D[14]);
buf iD15 (b_D[15], D[15]);
buf iD16 (b_D[16], D[16]);
buf iD17 (b_D[17], D[17]);
buf iD18 (b_D[18], D[18]);
buf iD19 (b_D[19], D[19]);
buf iD20 (b_D[20], D[20]);
buf iD21 (b_D[21], D[21]);
buf iD22 (b_D[22], D[22]);
buf iD23 (b_D[23], D[23]);
buf iD24 (b_D[24], D[24]);
buf iD25 (b_D[25], D[25]);
buf iD26 (b_D[26], D[26]);
buf iD27 (b_D[27], D[27]);
buf iD28 (b_D[28], D[28]);
buf iD29 (b_D[29], D[29]);
buf iD30 (b_D[30], D[30]);
buf iD31 (b_D[31], D[31]);

buf iBWEB0 (b_BWEB[0], BWEB[0]);
buf iBWEB1 (b_BWEB[1], BWEB[1]);
buf iBWEB2 (b_BWEB[2], BWEB[2]);
buf iBWEB3 (b_BWEB[3], BWEB[3]);
buf iBWEB4 (b_BWEB[4], BWEB[4]);
buf iBWEB5 (b_BWEB[5], BWEB[5]);
buf iBWEB6 (b_BWEB[6], BWEB[6]);
buf iBWEB7 (b_BWEB[7], BWEB[7]);
buf iBWEB8 (b_BWEB[8], BWEB[8]);
buf iBWEB9 (b_BWEB[9], BWEB[9]);
buf iBWEB10 (b_BWEB[10], BWEB[10]);
buf iBWEB11 (b_BWEB[11], BWEB[11]);
buf iBWEB12 (b_BWEB[12], BWEB[12]);
buf iBWEB13 (b_BWEB[13], BWEB[13]);
buf iBWEB14 (b_BWEB[14], BWEB[14]);
buf iBWEB15 (b_BWEB[15], BWEB[15]);
buf iBWEB16 (b_BWEB[16], BWEB[16]);
buf iBWEB17 (b_BWEB[17], BWEB[17]);
buf iBWEB18 (b_BWEB[18], BWEB[18]);
buf iBWEB19 (b_BWEB[19], BWEB[19]);
buf iBWEB20 (b_BWEB[20], BWEB[20]);
buf iBWEB21 (b_BWEB[21], BWEB[21]);
buf iBWEB22 (b_BWEB[22], BWEB[22]);
buf iBWEB23 (b_BWEB[23], BWEB[23]);
buf iBWEB24 (b_BWEB[24], BWEB[24]);
buf iBWEB25 (b_BWEB[25], BWEB[25]);
buf iBWEB26 (b_BWEB[26], BWEB[26]);
buf iBWEB27 (b_BWEB[27], BWEB[27]);
buf iBWEB28 (b_BWEB[28], BWEB[28]);
buf iBWEB29 (b_BWEB[29], BWEB[29]);
buf iBWEB30 (b_BWEB[30], BWEB[30]);
buf iBWEB31 (b_BWEB[31], BWEB[31]);

buf iA0 (b_A[0], A[0]);
buf iA1 (b_A[1], A[1]);
buf iA2 (b_A[2], A[2]);
buf iA3 (b_A[3], A[3]);
buf iA4 (b_A[4], A[4]);
buf iA5 (b_A[5], A[5]);
buf iA6 (b_A[6], A[6]);
buf iA7 (b_A[7], A[7]);

buf iWEB (b_WEB, WEB);
buf iCEB (b_CEB, CEB);

//      Bist mode
buf iBIST (b_BIST, BIST);

buf iDM0 (b_DM[0], DM[0]);
buf iDM1 (b_DM[1], DM[1]);
buf iDM2 (b_DM[2], DM[2]);
buf iDM3 (b_DM[3], DM[3]);
buf iDM4 (b_DM[4], DM[4]);
buf iDM5 (b_DM[5], DM[5]);
buf iDM6 (b_DM[6], DM[6]);
buf iDM7 (b_DM[7], DM[7]);
buf iDM8 (b_DM[8], DM[8]);
buf iDM9 (b_DM[9], DM[9]);
buf iDM10 (b_DM[10], DM[10]);
buf iDM11 (b_DM[11], DM[11]);
buf iDM12 (b_DM[12], DM[12]);
buf iDM13 (b_DM[13], DM[13]);
buf iDM14 (b_DM[14], DM[14]);
buf iDM15 (b_DM[15], DM[15]);
buf iDM16 (b_DM[16], DM[16]);
buf iDM17 (b_DM[17], DM[17]);
buf iDM18 (b_DM[18], DM[18]);
buf iDM19 (b_DM[19], DM[19]);
buf iDM20 (b_DM[20], DM[20]);
buf iDM21 (b_DM[21], DM[21]);
buf iDM22 (b_DM[22], DM[22]);
buf iDM23 (b_DM[23], DM[23]);
buf iDM24 (b_DM[24], DM[24]);
buf iDM25 (b_DM[25], DM[25]);
buf iDM26 (b_DM[26], DM[26]);
buf iDM27 (b_DM[27], DM[27]);
buf iDM28 (b_DM[28], DM[28]);
buf iDM29 (b_DM[29], DM[29]);
buf iDM30 (b_DM[30], DM[30]);
buf iDM31 (b_DM[31], DM[31]);
buf iBWEBM0 (b_BWEBM[0], BWEBM[0]);
buf iBWEBM1 (b_BWEBM[1], BWEBM[1]);
buf iBWEBM2 (b_BWEBM[2], BWEBM[2]);
buf iBWEBM3 (b_BWEBM[3], BWEBM[3]);
buf iBWEBM4 (b_BWEBM[4], BWEBM[4]);
buf iBWEBM5 (b_BWEBM[5], BWEBM[5]);
buf iBWEBM6 (b_BWEBM[6], BWEBM[6]);
buf iBWEBM7 (b_BWEBM[7], BWEBM[7]);
buf iBWEBM8 (b_BWEBM[8], BWEBM[8]);
buf iBWEBM9 (b_BWEBM[9], BWEBM[9]);
buf iBWEBM10 (b_BWEBM[10], BWEBM[10]);
buf iBWEBM11 (b_BWEBM[11], BWEBM[11]);
buf iBWEBM12 (b_BWEBM[12], BWEBM[12]);
buf iBWEBM13 (b_BWEBM[13], BWEBM[13]);
buf iBWEBM14 (b_BWEBM[14], BWEBM[14]);
buf iBWEBM15 (b_BWEBM[15], BWEBM[15]);
buf iBWEBM16 (b_BWEBM[16], BWEBM[16]);
buf iBWEBM17 (b_BWEBM[17], BWEBM[17]);
buf iBWEBM18 (b_BWEBM[18], BWEBM[18]);
buf iBWEBM19 (b_BWEBM[19], BWEBM[19]);
buf iBWEBM20 (b_BWEBM[20], BWEBM[20]);
buf iBWEBM21 (b_BWEBM[21], BWEBM[21]);
buf iBWEBM22 (b_BWEBM[22], BWEBM[22]);
buf iBWEBM23 (b_BWEBM[23], BWEBM[23]);
buf iBWEBM24 (b_BWEBM[24], BWEBM[24]);
buf iBWEBM25 (b_BWEBM[25], BWEBM[25]);
buf iBWEBM26 (b_BWEBM[26], BWEBM[26]);
buf iBWEBM27 (b_BWEBM[27], BWEBM[27]);
buf iBWEBM28 (b_BWEBM[28], BWEBM[28]);
buf iBWEBM29 (b_BWEBM[29], BWEBM[29]);
buf iBWEBM30 (b_BWEBM[30], BWEBM[30]);
buf iBWEBM31 (b_BWEBM[31], BWEBM[31]);
buf iAM0 (b_AM[0], AM[0]);
buf iAM1 (b_AM[1], AM[1]);
buf iAM2 (b_AM[2], AM[2]);
buf iAM3 (b_AM[3], AM[3]);
buf iAM4 (b_AM[4], AM[4]);
buf iAM5 (b_AM[5], AM[5]);
buf iAM6 (b_AM[6], AM[6]);
buf iAM7 (b_AM[7], AM[7]);

buf iWEBM (b_WEBM, WEBM);
buf iCEBM (b_CEBM, CEBM);

buf iCLK (b_CLK, CLK);

buf iAWT (b_AWT, AWT);
nmos iQ0 (Q[0], Q_mux[0], 1'b1);
nmos iQ1 (Q[1], Q_mux[1], 1'b1);
nmos iQ2 (Q[2], Q_mux[2], 1'b1);
nmos iQ3 (Q[3], Q_mux[3], 1'b1);
nmos iQ4 (Q[4], Q_mux[4], 1'b1);
nmos iQ5 (Q[5], Q_mux[5], 1'b1);
nmos iQ6 (Q[6], Q_mux[6], 1'b1);
nmos iQ7 (Q[7], Q_mux[7], 1'b1);
nmos iQ8 (Q[8], Q_mux[8], 1'b1);
nmos iQ9 (Q[9], Q_mux[9], 1'b1);
nmos iQ10 (Q[10], Q_mux[10], 1'b1);
nmos iQ11 (Q[11], Q_mux[11], 1'b1);
nmos iQ12 (Q[12], Q_mux[12], 1'b1);
nmos iQ13 (Q[13], Q_mux[13], 1'b1);
nmos iQ14 (Q[14], Q_mux[14], 1'b1);
nmos iQ15 (Q[15], Q_mux[15], 1'b1);
nmos iQ16 (Q[16], Q_mux[16], 1'b1);
nmos iQ17 (Q[17], Q_mux[17], 1'b1);
nmos iQ18 (Q[18], Q_mux[18], 1'b1);
nmos iQ19 (Q[19], Q_mux[19], 1'b1);
nmos iQ20 (Q[20], Q_mux[20], 1'b1);
nmos iQ21 (Q[21], Q_mux[21], 1'b1);
nmos iQ22 (Q[22], Q_mux[22], 1'b1);
nmos iQ23 (Q[23], Q_mux[23], 1'b1);
nmos iQ24 (Q[24], Q_mux[24], 1'b1);
nmos iQ25 (Q[25], Q_mux[25], 1'b1);
nmos iQ26 (Q[26], Q_mux[26], 1'b1);
nmos iQ27 (Q[27], Q_mux[27], 1'b1);
nmos iQ28 (Q[28], Q_mux[28], 1'b1);
nmos iQ29 (Q[29], Q_mux[29], 1'b1);
nmos iQ30 (Q[30], Q_mux[30], 1'b1);
nmos iQ31 (Q[31], Q_mux[31], 1'b1);
//      Repair



// Test Mode
buf (RTSEL_i[0], RTSEL[0]);
buf (RTSEL_i[1], RTSEL[1]);
buf (WTSEL_i[0], WTSEL[0]);
buf (WTSEL_i[1], WTSEL[1]);
buf (WTSEL_i[2], WTSEL[2]);

// M-by-N core memory
reg [N - 1:0] mem[W - 1:0];
reg [N - 1:0] mem_sa0[W - 1:0];
reg [N - 1:0] mem_sa1[W - 1:0];






// latched input signal
reg [M - 1:0] AL;
reg WEBL;
reg CEBL;
reg [N - 1:0] DL;
reg [N - 1:0] BWEBL;


`ifdef TSMC_UNIT_DELAY
`else
// Timing Check notifiers
reg notifier_CLK;      // notifier for clock CLK timing violations.
reg notifier_D0;         // notifier for D and DM timing violations.
reg notifier_D1;         // notifier for D and DM timing violations.
reg notifier_D2;         // notifier for D and DM timing violations.
reg notifier_D3;         // notifier for D and DM timing violations.
reg notifier_D4;         // notifier for D and DM timing violations.
reg notifier_D5;         // notifier for D and DM timing violations.
reg notifier_D6;         // notifier for D and DM timing violations.
reg notifier_D7;         // notifier for D and DM timing violations.
reg notifier_D8;         // notifier for D and DM timing violations.
reg notifier_D9;         // notifier for D and DM timing violations.
reg notifier_D10;         // notifier for D and DM timing violations.
reg notifier_D11;         // notifier for D and DM timing violations.
reg notifier_D12;         // notifier for D and DM timing violations.
reg notifier_D13;         // notifier for D and DM timing violations.
reg notifier_D14;         // notifier for D and DM timing violations.
reg notifier_D15;         // notifier for D and DM timing violations.
reg notifier_D16;         // notifier for D and DM timing violations.
reg notifier_D17;         // notifier for D and DM timing violations.
reg notifier_D18;         // notifier for D and DM timing violations.
reg notifier_D19;         // notifier for D and DM timing violations.
reg notifier_D20;         // notifier for D and DM timing violations.
reg notifier_D21;         // notifier for D and DM timing violations.
reg notifier_D22;         // notifier for D and DM timing violations.
reg notifier_D23;         // notifier for D and DM timing violations.
reg notifier_D24;         // notifier for D and DM timing violations.
reg notifier_D25;         // notifier for D and DM timing violations.
reg notifier_D26;         // notifier for D and DM timing violations.
reg notifier_D27;         // notifier for D and DM timing violations.
reg notifier_D28;         // notifier for D and DM timing violations.
reg notifier_D29;         // notifier for D and DM timing violations.
reg notifier_D30;         // notifier for D and DM timing violations.
reg notifier_D31;         // notifier for D and DM timing violations.
reg notifier_BWEB0;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB1;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB2;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB3;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB4;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB5;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB6;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB7;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB8;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB9;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB10;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB11;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB12;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB13;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB14;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB15;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB16;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB17;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB18;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB19;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB20;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB21;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB22;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB23;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB24;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB25;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB26;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB27;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB28;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB29;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB30;         // notifier for BWEB and BWEBM timing violations.
reg notifier_BWEB31;         // notifier for BWEB and BWEBM timing violations.
reg notifier_WEB;       // notifier for WEB & BWEB timing violations.
reg notifier_CEB;       // notifier for CEB & CEBM timing violations.
reg notifier_A;        // notifier for A & AM timing violations.
reg notifier_BIST;        // notifier for BIST violations.
`endif
integer i;


`ifdef TSMC_UNIT_DELAY
`else
specify
    specparam PATHPULSE$ = ( 0, 0.001 );


specparam tckl = 0.324;
specparam tckh = 0.268;
specparam tcyc = 1.199;

specparam tas = 0.220;
specparam tah = 0.043;
specparam tds = 0.190;
specparam tdh = 0.074;
specparam tcebs = 0.324;
specparam tcebh = 0.028;
specparam twebs = 0.217;
specparam twebh = 0.019;
specparam tbwebs = 0.201;
specparam tbwebh = 0.001;
specparam tbists = 0.220;
specparam tbisth = 0.000;
specparam tams = 0.220;
specparam tamh = 0.043;
specparam tdms = 0.190;
specparam tdmh = 0.074;
specparam tcebms = 0.324;
specparam tcebmh = 0.028;
specparam twebms = 0.217;
specparam twebmh = 0.019;
specparam tbwebms = 0.201;
specparam tbwebmh = 0.001;




// CLK-2-Q
specparam tcd = 0.735;
specparam thold = 0.711;

// AWT(AWT)
specparam tawtq = 0.346;
specparam tawtqh = 0.177;
// AWT(BWEB)
specparam tbwq = 0.346;
specparam tbwqh = 0.177;
// AWT(D)
specparam tdq = 0.526;
specparam tdqh = 0.259;



  
  $width(negedge CLK &&& PRIME, tckl, 0, notifier_CLK);
  $width(posedge CLK &&& PRIME, tckh, 0, notifier_CLK);
  $period(posedge CLK &&& PRIME, tcyc, notifier_CLK);
  
  $setuphold(posedge CLK &&& NOR, posedge CEB, tcebs, tcebh, notifier_CEB);
  $setuphold(posedge CLK &&& NOR, negedge CEB, tcebs, tcebh, notifier_CEB);
  
  $setuphold (posedge CLK, posedge BIST, tbists, tbisth, notifier_BIST);
  $setuphold (posedge CLK, negedge BIST, tbists, tbisth, notifier_BIST);
  
  $setuphold (posedge CLK &&& NORM, posedge CEBM, tcebms, tcebmh, notifier_CEB);
  $setuphold (posedge CLK &&& NORM, negedge CEBM, tcebms, tcebmh, notifier_CEB);
  
  
  $setuphold(posedge CLK &&& CE, posedge WEB, twebs, twebh, notifier_WEB);
  $setuphold(posedge CLK &&& CE, negedge WEB, twebs, twebh, notifier_WEB);

  $setuphold(posedge CLK &&& CE, posedge A[0], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[0], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[1], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[1], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[2], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[2], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[3], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[3], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[4], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[4], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[5], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[5], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[6], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[6], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, posedge A[7], tas, tah, notifier_A);
  $setuphold(posedge CLK &&& CE, negedge A[7], tas, tah, notifier_A);

  $setuphold(posedge CLK &&& WE, posedge D[0], tds, tdh, notifier_D0);
  $setuphold(posedge CLK &&& WE, negedge D[0], tds, tdh, notifier_D0);
  $setuphold(posedge CLK &&& WE, posedge D[1], tds, tdh, notifier_D1);
  $setuphold(posedge CLK &&& WE, negedge D[1], tds, tdh, notifier_D1);
  $setuphold(posedge CLK &&& WE, posedge D[2], tds, tdh, notifier_D2);
  $setuphold(posedge CLK &&& WE, negedge D[2], tds, tdh, notifier_D2);
  $setuphold(posedge CLK &&& WE, posedge D[3], tds, tdh, notifier_D3);
  $setuphold(posedge CLK &&& WE, negedge D[3], tds, tdh, notifier_D3);
  $setuphold(posedge CLK &&& WE, posedge D[4], tds, tdh, notifier_D4);
  $setuphold(posedge CLK &&& WE, negedge D[4], tds, tdh, notifier_D4);
  $setuphold(posedge CLK &&& WE, posedge D[5], tds, tdh, notifier_D5);
  $setuphold(posedge CLK &&& WE, negedge D[5], tds, tdh, notifier_D5);
  $setuphold(posedge CLK &&& WE, posedge D[6], tds, tdh, notifier_D6);
  $setuphold(posedge CLK &&& WE, negedge D[6], tds, tdh, notifier_D6);
  $setuphold(posedge CLK &&& WE, posedge D[7], tds, tdh, notifier_D7);
  $setuphold(posedge CLK &&& WE, negedge D[7], tds, tdh, notifier_D7);
  $setuphold(posedge CLK &&& WE, posedge D[8], tds, tdh, notifier_D8);
  $setuphold(posedge CLK &&& WE, negedge D[8], tds, tdh, notifier_D8);
  $setuphold(posedge CLK &&& WE, posedge D[9], tds, tdh, notifier_D9);
  $setuphold(posedge CLK &&& WE, negedge D[9], tds, tdh, notifier_D9);
  $setuphold(posedge CLK &&& WE, posedge D[10], tds, tdh, notifier_D10);
  $setuphold(posedge CLK &&& WE, negedge D[10], tds, tdh, notifier_D10);
  $setuphold(posedge CLK &&& WE, posedge D[11], tds, tdh, notifier_D11);
  $setuphold(posedge CLK &&& WE, negedge D[11], tds, tdh, notifier_D11);
  $setuphold(posedge CLK &&& WE, posedge D[12], tds, tdh, notifier_D12);
  $setuphold(posedge CLK &&& WE, negedge D[12], tds, tdh, notifier_D12);
  $setuphold(posedge CLK &&& WE, posedge D[13], tds, tdh, notifier_D13);
  $setuphold(posedge CLK &&& WE, negedge D[13], tds, tdh, notifier_D13);
  $setuphold(posedge CLK &&& WE, posedge D[14], tds, tdh, notifier_D14);
  $setuphold(posedge CLK &&& WE, negedge D[14], tds, tdh, notifier_D14);
  $setuphold(posedge CLK &&& WE, posedge D[15], tds, tdh, notifier_D15);
  $setuphold(posedge CLK &&& WE, negedge D[15], tds, tdh, notifier_D15);
  $setuphold(posedge CLK &&& WE, posedge D[16], tds, tdh, notifier_D16);
  $setuphold(posedge CLK &&& WE, negedge D[16], tds, tdh, notifier_D16);
  $setuphold(posedge CLK &&& WE, posedge D[17], tds, tdh, notifier_D17);
  $setuphold(posedge CLK &&& WE, negedge D[17], tds, tdh, notifier_D17);
  $setuphold(posedge CLK &&& WE, posedge D[18], tds, tdh, notifier_D18);
  $setuphold(posedge CLK &&& WE, negedge D[18], tds, tdh, notifier_D18);
  $setuphold(posedge CLK &&& WE, posedge D[19], tds, tdh, notifier_D19);
  $setuphold(posedge CLK &&& WE, negedge D[19], tds, tdh, notifier_D19);
  $setuphold(posedge CLK &&& WE, posedge D[20], tds, tdh, notifier_D20);
  $setuphold(posedge CLK &&& WE, negedge D[20], tds, tdh, notifier_D20);
  $setuphold(posedge CLK &&& WE, posedge D[21], tds, tdh, notifier_D21);
  $setuphold(posedge CLK &&& WE, negedge D[21], tds, tdh, notifier_D21);
  $setuphold(posedge CLK &&& WE, posedge D[22], tds, tdh, notifier_D22);
  $setuphold(posedge CLK &&& WE, negedge D[22], tds, tdh, notifier_D22);
  $setuphold(posedge CLK &&& WE, posedge D[23], tds, tdh, notifier_D23);
  $setuphold(posedge CLK &&& WE, negedge D[23], tds, tdh, notifier_D23);
  $setuphold(posedge CLK &&& WE, posedge D[24], tds, tdh, notifier_D24);
  $setuphold(posedge CLK &&& WE, negedge D[24], tds, tdh, notifier_D24);
  $setuphold(posedge CLK &&& WE, posedge D[25], tds, tdh, notifier_D25);
  $setuphold(posedge CLK &&& WE, negedge D[25], tds, tdh, notifier_D25);
  $setuphold(posedge CLK &&& WE, posedge D[26], tds, tdh, notifier_D26);
  $setuphold(posedge CLK &&& WE, negedge D[26], tds, tdh, notifier_D26);
  $setuphold(posedge CLK &&& WE, posedge D[27], tds, tdh, notifier_D27);
  $setuphold(posedge CLK &&& WE, negedge D[27], tds, tdh, notifier_D27);
  $setuphold(posedge CLK &&& WE, posedge D[28], tds, tdh, notifier_D28);
  $setuphold(posedge CLK &&& WE, negedge D[28], tds, tdh, notifier_D28);
  $setuphold(posedge CLK &&& WE, posedge D[29], tds, tdh, notifier_D29);
  $setuphold(posedge CLK &&& WE, negedge D[29], tds, tdh, notifier_D29);
  $setuphold(posedge CLK &&& WE, posedge D[30], tds, tdh, notifier_D30);
  $setuphold(posedge CLK &&& WE, negedge D[30], tds, tdh, notifier_D30);
  $setuphold(posedge CLK &&& WE, posedge D[31], tds, tdh, notifier_D31);
  $setuphold(posedge CLK &&& WE, negedge D[31], tds, tdh, notifier_D31);
  $setuphold(posedge CLK &&& WE, posedge BWEB[0], tbwebs, tbwebh, notifier_BWEB0);
  $setuphold(posedge CLK &&& WE, negedge BWEB[0], tbwebs, tbwebh, notifier_BWEB0);
  $setuphold(posedge CLK &&& WE, posedge BWEB[1], tbwebs, tbwebh, notifier_BWEB1);
  $setuphold(posedge CLK &&& WE, negedge BWEB[1], tbwebs, tbwebh, notifier_BWEB1);
  $setuphold(posedge CLK &&& WE, posedge BWEB[2], tbwebs, tbwebh, notifier_BWEB2);
  $setuphold(posedge CLK &&& WE, negedge BWEB[2], tbwebs, tbwebh, notifier_BWEB2);
  $setuphold(posedge CLK &&& WE, posedge BWEB[3], tbwebs, tbwebh, notifier_BWEB3);
  $setuphold(posedge CLK &&& WE, negedge BWEB[3], tbwebs, tbwebh, notifier_BWEB3);
  $setuphold(posedge CLK &&& WE, posedge BWEB[4], tbwebs, tbwebh, notifier_BWEB4);
  $setuphold(posedge CLK &&& WE, negedge BWEB[4], tbwebs, tbwebh, notifier_BWEB4);
  $setuphold(posedge CLK &&& WE, posedge BWEB[5], tbwebs, tbwebh, notifier_BWEB5);
  $setuphold(posedge CLK &&& WE, negedge BWEB[5], tbwebs, tbwebh, notifier_BWEB5);
  $setuphold(posedge CLK &&& WE, posedge BWEB[6], tbwebs, tbwebh, notifier_BWEB6);
  $setuphold(posedge CLK &&& WE, negedge BWEB[6], tbwebs, tbwebh, notifier_BWEB6);
  $setuphold(posedge CLK &&& WE, posedge BWEB[7], tbwebs, tbwebh, notifier_BWEB7);
  $setuphold(posedge CLK &&& WE, negedge BWEB[7], tbwebs, tbwebh, notifier_BWEB7);
  $setuphold(posedge CLK &&& WE, posedge BWEB[8], tbwebs, tbwebh, notifier_BWEB8);
  $setuphold(posedge CLK &&& WE, negedge BWEB[8], tbwebs, tbwebh, notifier_BWEB8);
  $setuphold(posedge CLK &&& WE, posedge BWEB[9], tbwebs, tbwebh, notifier_BWEB9);
  $setuphold(posedge CLK &&& WE, negedge BWEB[9], tbwebs, tbwebh, notifier_BWEB9);
  $setuphold(posedge CLK &&& WE, posedge BWEB[10], tbwebs, tbwebh, notifier_BWEB10);
  $setuphold(posedge CLK &&& WE, negedge BWEB[10], tbwebs, tbwebh, notifier_BWEB10);
  $setuphold(posedge CLK &&& WE, posedge BWEB[11], tbwebs, tbwebh, notifier_BWEB11);
  $setuphold(posedge CLK &&& WE, negedge BWEB[11], tbwebs, tbwebh, notifier_BWEB11);
  $setuphold(posedge CLK &&& WE, posedge BWEB[12], tbwebs, tbwebh, notifier_BWEB12);
  $setuphold(posedge CLK &&& WE, negedge BWEB[12], tbwebs, tbwebh, notifier_BWEB12);
  $setuphold(posedge CLK &&& WE, posedge BWEB[13], tbwebs, tbwebh, notifier_BWEB13);
  $setuphold(posedge CLK &&& WE, negedge BWEB[13], tbwebs, tbwebh, notifier_BWEB13);
  $setuphold(posedge CLK &&& WE, posedge BWEB[14], tbwebs, tbwebh, notifier_BWEB14);
  $setuphold(posedge CLK &&& WE, negedge BWEB[14], tbwebs, tbwebh, notifier_BWEB14);
  $setuphold(posedge CLK &&& WE, posedge BWEB[15], tbwebs, tbwebh, notifier_BWEB15);
  $setuphold(posedge CLK &&& WE, negedge BWEB[15], tbwebs, tbwebh, notifier_BWEB15);
  $setuphold(posedge CLK &&& WE, posedge BWEB[16], tbwebs, tbwebh, notifier_BWEB16);
  $setuphold(posedge CLK &&& WE, negedge BWEB[16], tbwebs, tbwebh, notifier_BWEB16);
  $setuphold(posedge CLK &&& WE, posedge BWEB[17], tbwebs, tbwebh, notifier_BWEB17);
  $setuphold(posedge CLK &&& WE, negedge BWEB[17], tbwebs, tbwebh, notifier_BWEB17);
  $setuphold(posedge CLK &&& WE, posedge BWEB[18], tbwebs, tbwebh, notifier_BWEB18);
  $setuphold(posedge CLK &&& WE, negedge BWEB[18], tbwebs, tbwebh, notifier_BWEB18);
  $setuphold(posedge CLK &&& WE, posedge BWEB[19], tbwebs, tbwebh, notifier_BWEB19);
  $setuphold(posedge CLK &&& WE, negedge BWEB[19], tbwebs, tbwebh, notifier_BWEB19);
  $setuphold(posedge CLK &&& WE, posedge BWEB[20], tbwebs, tbwebh, notifier_BWEB20);
  $setuphold(posedge CLK &&& WE, negedge BWEB[20], tbwebs, tbwebh, notifier_BWEB20);
  $setuphold(posedge CLK &&& WE, posedge BWEB[21], tbwebs, tbwebh, notifier_BWEB21);
  $setuphold(posedge CLK &&& WE, negedge BWEB[21], tbwebs, tbwebh, notifier_BWEB21);
  $setuphold(posedge CLK &&& WE, posedge BWEB[22], tbwebs, tbwebh, notifier_BWEB22);
  $setuphold(posedge CLK &&& WE, negedge BWEB[22], tbwebs, tbwebh, notifier_BWEB22);
  $setuphold(posedge CLK &&& WE, posedge BWEB[23], tbwebs, tbwebh, notifier_BWEB23);
  $setuphold(posedge CLK &&& WE, negedge BWEB[23], tbwebs, tbwebh, notifier_BWEB23);
  $setuphold(posedge CLK &&& WE, posedge BWEB[24], tbwebs, tbwebh, notifier_BWEB24);
  $setuphold(posedge CLK &&& WE, negedge BWEB[24], tbwebs, tbwebh, notifier_BWEB24);
  $setuphold(posedge CLK &&& WE, posedge BWEB[25], tbwebs, tbwebh, notifier_BWEB25);
  $setuphold(posedge CLK &&& WE, negedge BWEB[25], tbwebs, tbwebh, notifier_BWEB25);
  $setuphold(posedge CLK &&& WE, posedge BWEB[26], tbwebs, tbwebh, notifier_BWEB26);
  $setuphold(posedge CLK &&& WE, negedge BWEB[26], tbwebs, tbwebh, notifier_BWEB26);
  $setuphold(posedge CLK &&& WE, posedge BWEB[27], tbwebs, tbwebh, notifier_BWEB27);
  $setuphold(posedge CLK &&& WE, negedge BWEB[27], tbwebs, tbwebh, notifier_BWEB27);
  $setuphold(posedge CLK &&& WE, posedge BWEB[28], tbwebs, tbwebh, notifier_BWEB28);
  $setuphold(posedge CLK &&& WE, negedge BWEB[28], tbwebs, tbwebh, notifier_BWEB28);
  $setuphold(posedge CLK &&& WE, posedge BWEB[29], tbwebs, tbwebh, notifier_BWEB29);
  $setuphold(posedge CLK &&& WE, negedge BWEB[29], tbwebs, tbwebh, notifier_BWEB29);
  $setuphold(posedge CLK &&& WE, posedge BWEB[30], tbwebs, tbwebh, notifier_BWEB30);
  $setuphold(posedge CLK &&& WE, negedge BWEB[30], tbwebs, tbwebh, notifier_BWEB30);
  $setuphold(posedge CLK &&& WE, posedge BWEB[31], tbwebs, tbwebh, notifier_BWEB31);
  $setuphold(posedge CLK &&& WE, negedge BWEB[31], tbwebs, tbwebh, notifier_BWEB31);






  $setuphold (posedge CLK &&& CEM, posedge WEBM, twebms, twebmh, notifier_WEB);
  $setuphold (posedge CLK &&& CEM, negedge WEBM, twebms, twebmh, notifier_WEB);

  $setuphold (posedge CLK &&& CEM, posedge AM[0], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[0], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[1], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[1], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[2], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[2], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[3], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[3], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[4], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[4], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[5], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[5], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[6], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[6], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, posedge AM[7], tams, tamh, notifier_A);
  $setuphold (posedge CLK &&& CEM, negedge AM[7], tams, tamh, notifier_A);

  $setuphold (posedge CLK &&& WEM, posedge DM[0], tdms, tdmh, notifier_D0);
  $setuphold (posedge CLK &&& WEM, negedge DM[0], tdms, tdmh, notifier_D0);
  $setuphold (posedge CLK &&& WEM, posedge DM[1], tdms, tdmh, notifier_D1);
  $setuphold (posedge CLK &&& WEM, negedge DM[1], tdms, tdmh, notifier_D1);
  $setuphold (posedge CLK &&& WEM, posedge DM[2], tdms, tdmh, notifier_D2);
  $setuphold (posedge CLK &&& WEM, negedge DM[2], tdms, tdmh, notifier_D2);
  $setuphold (posedge CLK &&& WEM, posedge DM[3], tdms, tdmh, notifier_D3);
  $setuphold (posedge CLK &&& WEM, negedge DM[3], tdms, tdmh, notifier_D3);
  $setuphold (posedge CLK &&& WEM, posedge DM[4], tdms, tdmh, notifier_D4);
  $setuphold (posedge CLK &&& WEM, negedge DM[4], tdms, tdmh, notifier_D4);
  $setuphold (posedge CLK &&& WEM, posedge DM[5], tdms, tdmh, notifier_D5);
  $setuphold (posedge CLK &&& WEM, negedge DM[5], tdms, tdmh, notifier_D5);
  $setuphold (posedge CLK &&& WEM, posedge DM[6], tdms, tdmh, notifier_D6);
  $setuphold (posedge CLK &&& WEM, negedge DM[6], tdms, tdmh, notifier_D6);
  $setuphold (posedge CLK &&& WEM, posedge DM[7], tdms, tdmh, notifier_D7);
  $setuphold (posedge CLK &&& WEM, negedge DM[7], tdms, tdmh, notifier_D7);
  $setuphold (posedge CLK &&& WEM, posedge DM[8], tdms, tdmh, notifier_D8);
  $setuphold (posedge CLK &&& WEM, negedge DM[8], tdms, tdmh, notifier_D8);
  $setuphold (posedge CLK &&& WEM, posedge DM[9], tdms, tdmh, notifier_D9);
  $setuphold (posedge CLK &&& WEM, negedge DM[9], tdms, tdmh, notifier_D9);
  $setuphold (posedge CLK &&& WEM, posedge DM[10], tdms, tdmh, notifier_D10);
  $setuphold (posedge CLK &&& WEM, negedge DM[10], tdms, tdmh, notifier_D10);
  $setuphold (posedge CLK &&& WEM, posedge DM[11], tdms, tdmh, notifier_D11);
  $setuphold (posedge CLK &&& WEM, negedge DM[11], tdms, tdmh, notifier_D11);
  $setuphold (posedge CLK &&& WEM, posedge DM[12], tdms, tdmh, notifier_D12);
  $setuphold (posedge CLK &&& WEM, negedge DM[12], tdms, tdmh, notifier_D12);
  $setuphold (posedge CLK &&& WEM, posedge DM[13], tdms, tdmh, notifier_D13);
  $setuphold (posedge CLK &&& WEM, negedge DM[13], tdms, tdmh, notifier_D13);
  $setuphold (posedge CLK &&& WEM, posedge DM[14], tdms, tdmh, notifier_D14);
  $setuphold (posedge CLK &&& WEM, negedge DM[14], tdms, tdmh, notifier_D14);
  $setuphold (posedge CLK &&& WEM, posedge DM[15], tdms, tdmh, notifier_D15);
  $setuphold (posedge CLK &&& WEM, negedge DM[15], tdms, tdmh, notifier_D15);
  $setuphold (posedge CLK &&& WEM, posedge DM[16], tdms, tdmh, notifier_D16);
  $setuphold (posedge CLK &&& WEM, negedge DM[16], tdms, tdmh, notifier_D16);
  $setuphold (posedge CLK &&& WEM, posedge DM[17], tdms, tdmh, notifier_D17);
  $setuphold (posedge CLK &&& WEM, negedge DM[17], tdms, tdmh, notifier_D17);
  $setuphold (posedge CLK &&& WEM, posedge DM[18], tdms, tdmh, notifier_D18);
  $setuphold (posedge CLK &&& WEM, negedge DM[18], tdms, tdmh, notifier_D18);
  $setuphold (posedge CLK &&& WEM, posedge DM[19], tdms, tdmh, notifier_D19);
  $setuphold (posedge CLK &&& WEM, negedge DM[19], tdms, tdmh, notifier_D19);
  $setuphold (posedge CLK &&& WEM, posedge DM[20], tdms, tdmh, notifier_D20);
  $setuphold (posedge CLK &&& WEM, negedge DM[20], tdms, tdmh, notifier_D20);
  $setuphold (posedge CLK &&& WEM, posedge DM[21], tdms, tdmh, notifier_D21);
  $setuphold (posedge CLK &&& WEM, negedge DM[21], tdms, tdmh, notifier_D21);
  $setuphold (posedge CLK &&& WEM, posedge DM[22], tdms, tdmh, notifier_D22);
  $setuphold (posedge CLK &&& WEM, negedge DM[22], tdms, tdmh, notifier_D22);
  $setuphold (posedge CLK &&& WEM, posedge DM[23], tdms, tdmh, notifier_D23);
  $setuphold (posedge CLK &&& WEM, negedge DM[23], tdms, tdmh, notifier_D23);
  $setuphold (posedge CLK &&& WEM, posedge DM[24], tdms, tdmh, notifier_D24);
  $setuphold (posedge CLK &&& WEM, negedge DM[24], tdms, tdmh, notifier_D24);
  $setuphold (posedge CLK &&& WEM, posedge DM[25], tdms, tdmh, notifier_D25);
  $setuphold (posedge CLK &&& WEM, negedge DM[25], tdms, tdmh, notifier_D25);
  $setuphold (posedge CLK &&& WEM, posedge DM[26], tdms, tdmh, notifier_D26);
  $setuphold (posedge CLK &&& WEM, negedge DM[26], tdms, tdmh, notifier_D26);
  $setuphold (posedge CLK &&& WEM, posedge DM[27], tdms, tdmh, notifier_D27);
  $setuphold (posedge CLK &&& WEM, negedge DM[27], tdms, tdmh, notifier_D27);
  $setuphold (posedge CLK &&& WEM, posedge DM[28], tdms, tdmh, notifier_D28);
  $setuphold (posedge CLK &&& WEM, negedge DM[28], tdms, tdmh, notifier_D28);
  $setuphold (posedge CLK &&& WEM, posedge DM[29], tdms, tdmh, notifier_D29);
  $setuphold (posedge CLK &&& WEM, negedge DM[29], tdms, tdmh, notifier_D29);
  $setuphold (posedge CLK &&& WEM, posedge DM[30], tdms, tdmh, notifier_D30);
  $setuphold (posedge CLK &&& WEM, negedge DM[30], tdms, tdmh, notifier_D30);
  $setuphold (posedge CLK &&& WEM, posedge DM[31], tdms, tdmh, notifier_D31);
  $setuphold (posedge CLK &&& WEM, negedge DM[31], tdms, tdmh, notifier_D31);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[0], tbwebms, tbwebmh, notifier_BWEB0);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[0], tbwebms, tbwebmh, notifier_BWEB0);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[1], tbwebms, tbwebmh, notifier_BWEB1);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[1], tbwebms, tbwebmh, notifier_BWEB1);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[2], tbwebms, tbwebmh, notifier_BWEB2);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[2], tbwebms, tbwebmh, notifier_BWEB2);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[3], tbwebms, tbwebmh, notifier_BWEB3);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[3], tbwebms, tbwebmh, notifier_BWEB3);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[4], tbwebms, tbwebmh, notifier_BWEB4);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[4], tbwebms, tbwebmh, notifier_BWEB4);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[5], tbwebms, tbwebmh, notifier_BWEB5);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[5], tbwebms, tbwebmh, notifier_BWEB5);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[6], tbwebms, tbwebmh, notifier_BWEB6);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[6], tbwebms, tbwebmh, notifier_BWEB6);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[7], tbwebms, tbwebmh, notifier_BWEB7);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[7], tbwebms, tbwebmh, notifier_BWEB7);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[8], tbwebms, tbwebmh, notifier_BWEB8);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[8], tbwebms, tbwebmh, notifier_BWEB8);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[9], tbwebms, tbwebmh, notifier_BWEB9);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[9], tbwebms, tbwebmh, notifier_BWEB9);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[10], tbwebms, tbwebmh, notifier_BWEB10);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[10], tbwebms, tbwebmh, notifier_BWEB10);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[11], tbwebms, tbwebmh, notifier_BWEB11);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[11], tbwebms, tbwebmh, notifier_BWEB11);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[12], tbwebms, tbwebmh, notifier_BWEB12);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[12], tbwebms, tbwebmh, notifier_BWEB12);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[13], tbwebms, tbwebmh, notifier_BWEB13);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[13], tbwebms, tbwebmh, notifier_BWEB13);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[14], tbwebms, tbwebmh, notifier_BWEB14);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[14], tbwebms, tbwebmh, notifier_BWEB14);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[15], tbwebms, tbwebmh, notifier_BWEB15);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[15], tbwebms, tbwebmh, notifier_BWEB15);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[16], tbwebms, tbwebmh, notifier_BWEB16);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[16], tbwebms, tbwebmh, notifier_BWEB16);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[17], tbwebms, tbwebmh, notifier_BWEB17);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[17], tbwebms, tbwebmh, notifier_BWEB17);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[18], tbwebms, tbwebmh, notifier_BWEB18);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[18], tbwebms, tbwebmh, notifier_BWEB18);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[19], tbwebms, tbwebmh, notifier_BWEB19);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[19], tbwebms, tbwebmh, notifier_BWEB19);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[20], tbwebms, tbwebmh, notifier_BWEB20);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[20], tbwebms, tbwebmh, notifier_BWEB20);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[21], tbwebms, tbwebmh, notifier_BWEB21);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[21], tbwebms, tbwebmh, notifier_BWEB21);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[22], tbwebms, tbwebmh, notifier_BWEB22);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[22], tbwebms, tbwebmh, notifier_BWEB22);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[23], tbwebms, tbwebmh, notifier_BWEB23);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[23], tbwebms, tbwebmh, notifier_BWEB23);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[24], tbwebms, tbwebmh, notifier_BWEB24);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[24], tbwebms, tbwebmh, notifier_BWEB24);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[25], tbwebms, tbwebmh, notifier_BWEB25);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[25], tbwebms, tbwebmh, notifier_BWEB25);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[26], tbwebms, tbwebmh, notifier_BWEB26);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[26], tbwebms, tbwebmh, notifier_BWEB26);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[27], tbwebms, tbwebmh, notifier_BWEB27);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[27], tbwebms, tbwebmh, notifier_BWEB27);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[28], tbwebms, tbwebmh, notifier_BWEB28);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[28], tbwebms, tbwebmh, notifier_BWEB28);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[29], tbwebms, tbwebmh, notifier_BWEB29);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[29], tbwebms, tbwebmh, notifier_BWEB29);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[30], tbwebms, tbwebmh, notifier_BWEB30);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[30], tbwebms, tbwebmh, notifier_BWEB30);
  $setuphold (posedge CLK &&& WEM, posedge BWEBM[31], tbwebms, tbwebmh, notifier_BWEB31);
  $setuphold (posedge CLK &&& WEM, negedge BWEBM[31], tbwebms, tbwebmh, notifier_BWEB31);










if (!AWT) (posedge CLK => (Q[0] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[1] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[2] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[3] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[4] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[5] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[6] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[7] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[8] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[9] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[10] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[11] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[12] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[13] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[14] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[15] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[16] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[17] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[18] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[19] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[20] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[21] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[22] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[23] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[24] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[25] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[26] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[27] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[28] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[29] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[30] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (!AWT) (posedge CLK => (Q[31] +: 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if (AWT) (posedge AWT => (Q[0] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[0] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[1] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[1] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[2] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[2] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[3] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[3] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[4] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[4] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[5] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[5] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[6] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[6] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[7] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[7] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[8] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[8] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[9] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[9] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[10] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[10] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[11] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[11] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[12] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[12] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[13] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[13] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[14] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[14] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[15] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[15] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[16] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[16] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[17] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[17] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[18] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[18] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[19] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[19] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[20] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[20] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[21] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[21] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[22] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[22] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[23] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[23] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[24] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[24] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[25] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[25] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[26] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[26] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[27] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[27] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[28] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[28] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[29] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[29] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[30] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[30] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (posedge AWT => (Q[31] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT) (negedge AWT => (Q[31] +: 1'bx)) = (tawtq,tawtq,tawtqh,tawtq,tawtqh,tawtq);
if (AWT & !BIST) (posedge BWEB[0]  => (Q[0] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[0]  => (Q[0] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[1]  => (Q[1] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[1]  => (Q[1] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[2]  => (Q[2] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[2]  => (Q[2] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[3]  => (Q[3] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[3]  => (Q[3] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[4]  => (Q[4] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[4]  => (Q[4] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[5]  => (Q[5] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[5]  => (Q[5] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[6]  => (Q[6] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[6]  => (Q[6] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[7]  => (Q[7] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[7]  => (Q[7] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[8]  => (Q[8] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[8]  => (Q[8] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[9]  => (Q[9] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[9]  => (Q[9] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[10]  => (Q[10] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[10]  => (Q[10] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[11]  => (Q[11] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[11]  => (Q[11] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[12]  => (Q[12] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[12]  => (Q[12] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[13]  => (Q[13] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[13]  => (Q[13] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[14]  => (Q[14] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[14]  => (Q[14] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[15]  => (Q[15] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[15]  => (Q[15] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[16]  => (Q[16] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[16]  => (Q[16] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[17]  => (Q[17] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[17]  => (Q[17] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[18]  => (Q[18] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[18]  => (Q[18] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[19]  => (Q[19] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[19]  => (Q[19] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[20]  => (Q[20] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[20]  => (Q[20] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[21]  => (Q[21] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[21]  => (Q[21] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[22]  => (Q[22] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[22]  => (Q[22] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[23]  => (Q[23] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[23]  => (Q[23] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[24]  => (Q[24] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[24]  => (Q[24] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[25]  => (Q[25] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[25]  => (Q[25] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[26]  => (Q[26] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[26]  => (Q[26] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[27]  => (Q[27] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[27]  => (Q[27] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[28]  => (Q[28] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[28]  => (Q[28] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[29]  => (Q[29] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[29]  => (Q[29] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[30]  => (Q[30] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[30]  => (Q[30] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge BWEB[31]  => (Q[31] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (negedge BWEB[31]  => (Q[31] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & !BIST) (posedge D[0]  => (Q[0] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[0]  => (Q[0] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[1]  => (Q[1] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[1]  => (Q[1] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[2]  => (Q[2] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[2]  => (Q[2] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[3]  => (Q[3] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[3]  => (Q[3] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[4]  => (Q[4] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[4]  => (Q[4] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[5]  => (Q[5] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[5]  => (Q[5] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[6]  => (Q[6] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[6]  => (Q[6] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[7]  => (Q[7] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[7]  => (Q[7] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[8]  => (Q[8] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[8]  => (Q[8] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[9]  => (Q[9] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[9]  => (Q[9] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[10]  => (Q[10] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[10]  => (Q[10] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[11]  => (Q[11] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[11]  => (Q[11] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[12]  => (Q[12] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[12]  => (Q[12] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[13]  => (Q[13] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[13]  => (Q[13] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[14]  => (Q[14] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[14]  => (Q[14] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[15]  => (Q[15] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[15]  => (Q[15] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[16]  => (Q[16] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[16]  => (Q[16] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[17]  => (Q[17] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[17]  => (Q[17] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[18]  => (Q[18] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[18]  => (Q[18] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[19]  => (Q[19] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[19]  => (Q[19] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[20]  => (Q[20] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[20]  => (Q[20] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[21]  => (Q[21] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[21]  => (Q[21] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[22]  => (Q[22] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[22]  => (Q[22] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[23]  => (Q[23] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[23]  => (Q[23] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[24]  => (Q[24] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[24]  => (Q[24] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[25]  => (Q[25] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[25]  => (Q[25] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[26]  => (Q[26] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[26]  => (Q[26] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[27]  => (Q[27] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[27]  => (Q[27] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[28]  => (Q[28] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[28]  => (Q[28] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[29]  => (Q[29] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[29]  => (Q[29] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[30]  => (Q[30] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[30]  => (Q[30] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (posedge D[31]  => (Q[31] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & !BIST) (negedge D[31]  => (Q[31] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge BWEBM[0]  => (Q[0] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[0]  => (Q[0] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[1]  => (Q[1] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[1]  => (Q[1] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[2]  => (Q[2] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[2]  => (Q[2] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[3]  => (Q[3] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[3]  => (Q[3] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[4]  => (Q[4] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[4]  => (Q[4] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[5]  => (Q[5] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[5]  => (Q[5] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[6]  => (Q[6] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[6]  => (Q[6] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[7]  => (Q[7] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[7]  => (Q[7] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[8]  => (Q[8] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[8]  => (Q[8] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[9]  => (Q[9] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[9]  => (Q[9] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[10]  => (Q[10] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[10]  => (Q[10] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[11]  => (Q[11] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[11]  => (Q[11] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[12]  => (Q[12] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[12]  => (Q[12] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[13]  => (Q[13] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[13]  => (Q[13] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[14]  => (Q[14] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[14]  => (Q[14] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[15]  => (Q[15] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[15]  => (Q[15] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[16]  => (Q[16] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[16]  => (Q[16] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[17]  => (Q[17] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[17]  => (Q[17] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[18]  => (Q[18] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[18]  => (Q[18] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[19]  => (Q[19] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[19]  => (Q[19] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[20]  => (Q[20] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[20]  => (Q[20] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[21]  => (Q[21] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[21]  => (Q[21] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[22]  => (Q[22] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[22]  => (Q[22] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[23]  => (Q[23] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[23]  => (Q[23] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[24]  => (Q[24] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[24]  => (Q[24] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[25]  => (Q[25] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[25]  => (Q[25] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[26]  => (Q[26] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[26]  => (Q[26] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[27]  => (Q[27] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[27]  => (Q[27] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[28]  => (Q[28] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[28]  => (Q[28] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[29]  => (Q[29] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[29]  => (Q[29] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[30]  => (Q[30] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[30]  => (Q[30] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge BWEBM[31]  => (Q[31] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (negedge BWEBM[31]  => (Q[31] +: 1'bx)) = (tbwq,tbwq,tbwqh,tbwq,tbwqh,tbwq);
if (AWT & BIST) (posedge DM[0]  => (Q[0] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[0]  => (Q[0] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[1]  => (Q[1] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[1]  => (Q[1] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[2]  => (Q[2] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[2]  => (Q[2] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[3]  => (Q[3] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[3]  => (Q[3] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[4]  => (Q[4] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[4]  => (Q[4] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[5]  => (Q[5] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[5]  => (Q[5] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[6]  => (Q[6] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[6]  => (Q[6] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[7]  => (Q[7] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[7]  => (Q[7] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[8]  => (Q[8] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[8]  => (Q[8] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[9]  => (Q[9] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[9]  => (Q[9] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[10]  => (Q[10] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[10]  => (Q[10] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[11]  => (Q[11] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[11]  => (Q[11] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[12]  => (Q[12] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[12]  => (Q[12] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[13]  => (Q[13] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[13]  => (Q[13] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[14]  => (Q[14] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[14]  => (Q[14] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[15]  => (Q[15] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[15]  => (Q[15] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[16]  => (Q[16] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[16]  => (Q[16] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[17]  => (Q[17] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[17]  => (Q[17] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[18]  => (Q[18] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[18]  => (Q[18] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[19]  => (Q[19] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[19]  => (Q[19] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[20]  => (Q[20] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[20]  => (Q[20] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[21]  => (Q[21] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[21]  => (Q[21] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[22]  => (Q[22] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[22]  => (Q[22] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[23]  => (Q[23] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[23]  => (Q[23] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[24]  => (Q[24] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[24]  => (Q[24] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[25]  => (Q[25] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[25]  => (Q[25] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[26]  => (Q[26] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[26]  => (Q[26] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[27]  => (Q[27] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[27]  => (Q[27] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[28]  => (Q[28] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[28]  => (Q[28] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[29]  => (Q[29] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[29]  => (Q[29] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[30]  => (Q[30] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[30]  => (Q[30] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (posedge DM[31]  => (Q[31] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);
if (AWT & BIST) (negedge DM[31]  => (Q[31] +: 1'bx)) = (tdq,tdq,tdqh,tdq,tdqh,tdq);


endspecify
`endif


initial begin
    for ( i = 0; i < W; i = i + 1) begin
        mem_sa0[i] = {N{1'b1}};
        mem_sa1[i] = {N{1'b0}};
    end
end

`ifndef TSMC_NO_TESTPINS_WARNING
always @(b_CLK or RTSEL_i) begin
    if (RTSEL_i !== 2'b00 && $realtime !=0) begin
        $display("\tError %m : input RTSEL should be set to 2'b00 at simulation time %.1f\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the RTSEL setting in the different segment and mux configuration\n");
        corrupt_mem;
        Q_n= {N{1'bx}}; 
    end
end

always @(b_CLK or WTSEL_i) begin
    if (WTSEL_i !== 3'b000 && $realtime !=0) begin
        $display("\tError %m : input WTSEL should be set to 3'b000 at simulation time %.1f\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the WTSEL setting in the different segment and mux configuration\n");
        corrupt_mem;
        Q_n= {N{1'bx}}; 
    end
end
`endif






`ifndef TSMC_UNIT_DELAY
always @(notifier_BIST) begin
    corrupt_mem;
    Q_mux = {N{1'bx}};
end

always @(notifier_CEB) begin
    corrupt_mem;
    if (b_AWT === 1'b0) begin
        Q_n = {N{1'bx}};
    end
end
always @(notifier_A) begin
    corrupt_mem;
    if(WEBL === 1'b1) begin
        Q_n = {N{1'bx}};
    end
end

always @(notifier_BWEB0) begin
    mem[AL][0] = 1'bx;
end
always @(notifier_BWEB1) begin
    mem[AL][1] = 1'bx;
end
always @(notifier_BWEB2) begin
    mem[AL][2] = 1'bx;
end
always @(notifier_BWEB3) begin
    mem[AL][3] = 1'bx;
end
always @(notifier_BWEB4) begin
    mem[AL][4] = 1'bx;
end
always @(notifier_BWEB5) begin
    mem[AL][5] = 1'bx;
end
always @(notifier_BWEB6) begin
    mem[AL][6] = 1'bx;
end
always @(notifier_BWEB7) begin
    mem[AL][7] = 1'bx;
end
always @(notifier_BWEB8) begin
    mem[AL][8] = 1'bx;
end
always @(notifier_BWEB9) begin
    mem[AL][9] = 1'bx;
end
always @(notifier_BWEB10) begin
    mem[AL][10] = 1'bx;
end
always @(notifier_BWEB11) begin
    mem[AL][11] = 1'bx;
end
always @(notifier_BWEB12) begin
    mem[AL][12] = 1'bx;
end
always @(notifier_BWEB13) begin
    mem[AL][13] = 1'bx;
end
always @(notifier_BWEB14) begin
    mem[AL][14] = 1'bx;
end
always @(notifier_BWEB15) begin
    mem[AL][15] = 1'bx;
end
always @(notifier_BWEB16) begin
    mem[AL][16] = 1'bx;
end
always @(notifier_BWEB17) begin
    mem[AL][17] = 1'bx;
end
always @(notifier_BWEB18) begin
    mem[AL][18] = 1'bx;
end
always @(notifier_BWEB19) begin
    mem[AL][19] = 1'bx;
end
always @(notifier_BWEB20) begin
    mem[AL][20] = 1'bx;
end
always @(notifier_BWEB21) begin
    mem[AL][21] = 1'bx;
end
always @(notifier_BWEB22) begin
    mem[AL][22] = 1'bx;
end
always @(notifier_BWEB23) begin
    mem[AL][23] = 1'bx;
end
always @(notifier_BWEB24) begin
    mem[AL][24] = 1'bx;
end
always @(notifier_BWEB25) begin
    mem[AL][25] = 1'bx;
end
always @(notifier_BWEB26) begin
    mem[AL][26] = 1'bx;
end
always @(notifier_BWEB27) begin
    mem[AL][27] = 1'bx;
end
always @(notifier_BWEB28) begin
    mem[AL][28] = 1'bx;
end
always @(notifier_BWEB29) begin
    mem[AL][29] = 1'bx;
end
always @(notifier_BWEB30) begin
    mem[AL][30] = 1'bx;
end
always @(notifier_BWEB31) begin
    mem[AL][31] = 1'bx;
end

always @(notifier_D0) begin
    mem[AL][0] = 1'bx;
end
always @(notifier_D1) begin
    mem[AL][1] = 1'bx;
end
always @(notifier_D2) begin
    mem[AL][2] = 1'bx;
end
always @(notifier_D3) begin
    mem[AL][3] = 1'bx;
end
always @(notifier_D4) begin
    mem[AL][4] = 1'bx;
end
always @(notifier_D5) begin
    mem[AL][5] = 1'bx;
end
always @(notifier_D6) begin
    mem[AL][6] = 1'bx;
end
always @(notifier_D7) begin
    mem[AL][7] = 1'bx;
end
always @(notifier_D8) begin
    mem[AL][8] = 1'bx;
end
always @(notifier_D9) begin
    mem[AL][9] = 1'bx;
end
always @(notifier_D10) begin
    mem[AL][10] = 1'bx;
end
always @(notifier_D11) begin
    mem[AL][11] = 1'bx;
end
always @(notifier_D12) begin
    mem[AL][12] = 1'bx;
end
always @(notifier_D13) begin
    mem[AL][13] = 1'bx;
end
always @(notifier_D14) begin
    mem[AL][14] = 1'bx;
end
always @(notifier_D15) begin
    mem[AL][15] = 1'bx;
end
always @(notifier_D16) begin
    mem[AL][16] = 1'bx;
end
always @(notifier_D17) begin
    mem[AL][17] = 1'bx;
end
always @(notifier_D18) begin
    mem[AL][18] = 1'bx;
end
always @(notifier_D19) begin
    mem[AL][19] = 1'bx;
end
always @(notifier_D20) begin
    mem[AL][20] = 1'bx;
end
always @(notifier_D21) begin
    mem[AL][21] = 1'bx;
end
always @(notifier_D22) begin
    mem[AL][22] = 1'bx;
end
always @(notifier_D23) begin
    mem[AL][23] = 1'bx;
end
always @(notifier_D24) begin
    mem[AL][24] = 1'bx;
end
always @(notifier_D25) begin
    mem[AL][25] = 1'bx;
end
always @(notifier_D26) begin
    mem[AL][26] = 1'bx;
end
always @(notifier_D27) begin
    mem[AL][27] = 1'bx;
end
always @(notifier_D28) begin
    mem[AL][28] = 1'bx;
end
always @(notifier_D29) begin
    mem[AL][29] = 1'bx;
end
always @(notifier_D30) begin
    mem[AL][30] = 1'bx;
end
always @(notifier_D31) begin
    mem[AL][31] = 1'bx;
end

always @(notifier_WEB or notifier_CLK) begin
    corrupt_mem;
    Q_n = {N{1'bx}};
end
`endif

always @(b_CLK) begin
    if (b_CLK === 1'bx) begin
        corrupt_mem;    //update
        Q_n= {N{1'bx}}; //update
`ifndef TSMC_NO_WARNING
        $display("Warning! Unknown violation %m \tinput CLK unknown/high-Z at simulation time %.3f\n", $realtime);
`endif
    end
end


always @(b_AWT or Q_n or b_D or b_DM or b_BIST or b_BWEB or b_BWEBM) begin
    if (b_AWT === 1'bx) begin
        Q_mux = {N{1'bx}};
`ifndef TSMC_NO_WARNING
        $display("Warning! Unknown violation %m \tinput AWT unknown/high-Z at simulation time %.3f\n", $realtime);
`endif
    end
    else if(b_AWT === 1'b0) begin
        Q_mux = Q_n;
    end
    else begin
        if (b_BIST === 1'bx) begin
            Q_mux = {N{1'bx}};
        end
        else if (b_BIST === 1'b0) begin
            Q_mux = b_D ^ b_BWEB;
        end
        else begin
            Q_mux = b_DM ^ b_BWEBM;
        end
    end
end

always @(posedge b_CLK) begin
    if ((b_CLK === 1'bx) || (b_BIST === 1'bx)) begin

        corrupt_mem;

        Q_n= {N{1'bx}};
`ifndef TSMC_NO_WARNING
        if (b_BIST === 1'bx) begin
            $display("Warning! Unknown violation %m \tinput BIST unknown/high-Z at simulation time %.3f\n", $realtime);
        end
`endif
    end
    else if (b_AWT == 1'b0) begin

        if (b_BIST === 1'b0) begin
            AL = b_A;
            WEBL = b_WEB;
            CEBL = b_CEB;
            DL = b_D;
            BWEBL = b_BWEB;
        end
        else begin
            AL = b_AM;
            WEBL = b_WEBM;
            CEBL = b_CEBM;
            DL = b_DM;
            BWEBL = b_BWEBM;
        end

        if (CEBL === 1'bx) begin

`ifndef TSMC_NO_WARNING
            if(b_BIST === 1'b0) begin
                $display("Warning! Unknown violation %m \tinput CEB unknown/high-Z at simulation time %.3f\n", $realtime);
            end
            else if(b_BIST === 1'b1) begin
                $display("Warning! Unknown violation %m \tinput CEBM unknown/high-Z at simulation time %.3f\n", $realtime);
            end
`endif

            corrupt_mem;
            Q_n = {N{1'bx}};
        end
        else if (CEBL === 1'b0) begin
            if (WEBL === 1'bx ) begin
`ifndef TSMC_NO_WARNING
                if (b_BIST === 1'b0) begin
                    $display("Warning! Unknown violation %m \tinput WEB unknown/high-Z at simulation time %.3f\n", $realtime);
                end
                else begin
                    $display("Warning! Unknown violation %m \tinput WEBM unknown/high-Z at simulation time %.3f\n", $realtime);
                end

`endif
        

                corrupt_mem;
                Q_n = {N{1'bx}};

            end
            else if (WEBL === 1'b0) begin

                if(^AL === 1'bx) begin
                    corrupt_mem;
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Unknown violation %m \tinput A unknown/high-Z at simulation time %.3f\n", $realtime);
                    end 
                    else begin
                        $display("Warning! Unknown violation %m \tinput AM unknown/high-Z at simulation time %.3f\n", $realtime);
                    end
`endif
                end
                else if(AL > W - 1) begin
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Out of range access to %m \tinput A cannot be decoded to a valid address at simulation time %.3f\n", $realtime);
                    end
                    else begin
                        $display("Warning! Out of range access to %m \tinput AM cannot be decoded to a valid address at simulation time %.3f\n", $realtime);
                    end
`endif

                end
                
                else if(^BWEBL === 1'bx) begin
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Unknown violation %m \tinput BWEB unknown/high-Z at simulation time %.3f\n", $realtime);
                    end
                    else begin
                        $display("Warning! Unknown violation %m \tinput BWEBM unknown/high-Z at simulation time %.3f\n", $realtime);
                    end

`endif
                    for(i=0; i<N; i=i+1) begin
                        mem[AL][i] = 1'bx;
                    end
                end
                else if(^DL === 1'bx) begin
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Unknown violation %m \tinput D unknown/high-Z at simulation time %.3f\n", $realtime);
                    end
                    else begin
                        $display("Warning! Unknown violation %m \tinput DM unknown/high-Z at simulation time %.3f\n", $realtime);
                    end

`endif
                    mem[AL] = (DL & (~BWEBL)) ^ (mem[AL] & BWEBL);
                end

        
        
                else begin
                    mem[AL] = (DL & (~BWEBL)) ^ (mem[AL] & BWEBL);
                end
            end
            else if (WEBL === 1'b1) begin
                if(^AL === 1'bx) begin
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Unknown violation %m \tinput A unknown/high-Z at simulation time %.3f\n", $realtime);
                    end 
                    else begin
                        $display("Warning! Unknown violation %m \tinput AM unknown/high-Z at simulation time %.3f\n", $realtime);
                    end

`endif
                    Q_n = {N{1'bx}};
                end
                else if(AL > W - 1) begin
        `ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Out of range access to %m \tinput A cannot be decoded to a valid address at simulation time %.3f\n", $realtime);
                    end
                    else begin
                        $display("Warning! Out of range access to %m \tinput AM cannot be decoded to a valid address at simulation time %.3f\n", $realtime);
                    end
        `endif
                end
                else if(^BWEBL === 1'bx) begin
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Unknown violation %m \tinput BWEB unknown/high-Z at simulation time %.3f\n", $realtime);
                    end
                    else begin
                        $display("Warning! Unknown violation %m \tinput BWEBM unknown/high-Z at simulation time %.3f\n", $realtime);
                    end

`endif
                end
                else if(^DL === 1'bx) begin
`ifndef TSMC_NO_WARNING
                    if (b_BIST === 1'b0) begin
                        $display("Warning! Unknown violation %m \tinput D unknown/high-Z at simulation time %.3f\n", $realtime);
                    end
                    else begin
                        $display("Warning! Unknown violation %m \tinput DM unknown/high-Z at simulation time %.3f\n", $realtime);
                    end

`endif
                end



    `ifdef TSMC_UNIT_DELAY
                #(`SRAM_DELAY);
                Q_n = (mem[AL] & mem_sa0[AL]) | mem_sa1[AL];
    `else
                Q_n = {N{1'bx}};
                #0.001
                Q_n = (mem[AL] & mem_sa0[AL]) | mem_sa1[AL];
    `endif

            end
        end // end of if (CEBL === 1'b0)
    end
end


task corrupt_mem;   // USAGE: call this task to set core memory to unknown.
    integer i;
    begin 
        for (i = 0; i < W; i = i + 1) begin	 
            mem[i]	= {N{1'bx}};
        end
    end 
endtask

// Task for Loading a perdefined set of data from an external file.
task PreloadData;   // USAGE: initial inst.loadLP2PRF ("file_name");
    input [W*N:1] infile;  // Max 256 character File Name
    begin
        $display ("%m: Reading file, %0s, into the register file", infile);
        $readmemh (infile, mem, 0, W-1);
    end
endtask







task InjectSA;     // USAGE: inst.InjectSA(address, index, redundancy);
    input [M - 1:0] address;
    input [4:0] index;
    input redundancy;
    integer sum;
    integer i;
    reg sa1;
    reg sa0;
    begin 
        if (redundancy === 1'b0) begin
            mem_sa0[address][index] = 1'b0;
            mem_sa1[address][index] = 1'b0;
            sum = 0;
            for (i = 0; i < N; i = i + 1) begin
                if (~mem_sa0[address][i] == 1'b1) begin
                    sum = sum +1 ;
                end
                if (mem_sa1[address][i] == 1'b1) begin
                    sum = sum +1 ;
                end
            end
            $display ("A s-a-0 error injected at address location %d = %b, current SA errors in this address is %d", address, ({N{1'bx}} &
            mem_sa0[address]) | mem_sa1[address], sum);
        end 
        else if (redundancy === 1'b1) begin
            mem_sa1[address][index] = 1'b1;
            mem_sa0[address][index] = 1'b1;
            sum = 0;
            for (i = 0; i < N; i = i + 1) begin
                if (~mem_sa0[address][i] == 1'b1) begin
                    sum = sum +1 ;
                end
                if (mem_sa1[address][i] == 1'b1) begin
                    sum = sum +1 ;
                end
            end
            $display ("A s-a-1 error injected at address location %d = %b, current SA errors in this address is %d", address, ({N{1'bx}} &
            mem_sa0[address]) | mem_sa1[address], sum);
        end
    end 
endtask

// Task for printing the memory between specified addresses..
task PrintMemoryFromTo;     // USAGE: inst.PrintMemoryFromTo(from, to);
    input [M - 1:0] from;   // memory content are printed, start from this address.
    input [M - 1:0] to;     // memory content are printed, end at this address.
    integer i;
    begin 
        $display ("Dumping register file...");
        $display("@    Address, content-----");
        for (i = from; i <= to; i = i + 1) begin
            if(i<W) begin
                $display("@%d, %b", i, mem[i]);
            end
            else begin
                $display("Warning! task PrintMemoryFromTo out of range (A = %d)!\n", i);
            end
        end 
    end
endtask

// Task for printing entire memory, including normal array and redundancy array.
task PrintMemory;   // USAGE: inst.PrintMemory;
    integer i;
    begin
        $display ("Dumping register file...");
        $display("@    Address, content-----");
        for (i = 0; i < W; i = i + 1) begin
            $display("@%d, %b", i, mem[i]);
        end 
    end
endtask

endmodule

`endcelldefine
