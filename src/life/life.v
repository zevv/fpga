module life(rst, clk, en_out, dout);
	input rst;
	input clk;
	input en_out;
	output dout;
	reg [63:0] cel = 64'b1000010110000010101000010110011010100010000001100000110100010000;


	reg [15:0] num;
	
	always @(posedge clk) if(en_out) num=num+1; else num=0;
	assign dout = cel[num];

	wire [2:0] sum_0_to_2__0;
	assign sum_0_to_2__0 = cel[0] + cel[1] + cel[2];

	wire [2:0] sum_1_to_3__0;
	assign sum_1_to_3__0 = cel[1] + cel[2] + cel[3];

	wire [2:0] sum_2_to_4__0;
	assign sum_2_to_4__0 = cel[2] + cel[3] + cel[4];

	wire [2:0] sum_3_to_5__0;
	assign sum_3_to_5__0 = cel[3] + cel[4] + cel[5];

	wire [2:0] sum_4_to_6__0;
	assign sum_4_to_6__0 = cel[4] + cel[5] + cel[6];

	wire [2:0] sum_5_to_7__0;
	assign sum_5_to_7__0 = cel[5] + cel[6] + cel[7];

	wire [2:0] sum_6_to_0__0;
	assign sum_6_to_0__0 = cel[6] + cel[7] + cel[0];

	wire [2:0] sum_7_to_1__0;
	assign sum_7_to_1__0 = cel[7] + cel[0] + cel[1];

	wire [2:0] sum_0_to_2__1;
	assign sum_0_to_2__1 = cel[8] + cel[9] + cel[10];

	wire [2:0] sum_1_to_3__1;
	assign sum_1_to_3__1 = cel[9] + cel[10] + cel[11];

	wire [2:0] sum_2_to_4__1;
	assign sum_2_to_4__1 = cel[10] + cel[11] + cel[12];

	wire [2:0] sum_3_to_5__1;
	assign sum_3_to_5__1 = cel[11] + cel[12] + cel[13];

	wire [2:0] sum_4_to_6__1;
	assign sum_4_to_6__1 = cel[12] + cel[13] + cel[14];

	wire [2:0] sum_5_to_7__1;
	assign sum_5_to_7__1 = cel[13] + cel[14] + cel[15];

	wire [2:0] sum_6_to_0__1;
	assign sum_6_to_0__1 = cel[14] + cel[15] + cel[8];

	wire [2:0] sum_7_to_1__1;
	assign sum_7_to_1__1 = cel[15] + cel[8] + cel[9];

	wire [2:0] sum_0_to_2__2;
	assign sum_0_to_2__2 = cel[16] + cel[17] + cel[18];

	wire [2:0] sum_1_to_3__2;
	assign sum_1_to_3__2 = cel[17] + cel[18] + cel[19];

	wire [2:0] sum_2_to_4__2;
	assign sum_2_to_4__2 = cel[18] + cel[19] + cel[20];

	wire [2:0] sum_3_to_5__2;
	assign sum_3_to_5__2 = cel[19] + cel[20] + cel[21];

	wire [2:0] sum_4_to_6__2;
	assign sum_4_to_6__2 = cel[20] + cel[21] + cel[22];

	wire [2:0] sum_5_to_7__2;
	assign sum_5_to_7__2 = cel[21] + cel[22] + cel[23];

	wire [2:0] sum_6_to_0__2;
	assign sum_6_to_0__2 = cel[22] + cel[23] + cel[16];

	wire [2:0] sum_7_to_1__2;
	assign sum_7_to_1__2 = cel[23] + cel[16] + cel[17];

	wire [2:0] sum_0_to_2__3;
	assign sum_0_to_2__3 = cel[24] + cel[25] + cel[26];

	wire [2:0] sum_1_to_3__3;
	assign sum_1_to_3__3 = cel[25] + cel[26] + cel[27];

	wire [2:0] sum_2_to_4__3;
	assign sum_2_to_4__3 = cel[26] + cel[27] + cel[28];

	wire [2:0] sum_3_to_5__3;
	assign sum_3_to_5__3 = cel[27] + cel[28] + cel[29];

	wire [2:0] sum_4_to_6__3;
	assign sum_4_to_6__3 = cel[28] + cel[29] + cel[30];

	wire [2:0] sum_5_to_7__3;
	assign sum_5_to_7__3 = cel[29] + cel[30] + cel[31];

	wire [2:0] sum_6_to_0__3;
	assign sum_6_to_0__3 = cel[30] + cel[31] + cel[24];

	wire [2:0] sum_7_to_1__3;
	assign sum_7_to_1__3 = cel[31] + cel[24] + cel[25];

	wire [2:0] sum_0_to_2__4;
	assign sum_0_to_2__4 = cel[32] + cel[33] + cel[34];

	wire [2:0] sum_1_to_3__4;
	assign sum_1_to_3__4 = cel[33] + cel[34] + cel[35];

	wire [2:0] sum_2_to_4__4;
	assign sum_2_to_4__4 = cel[34] + cel[35] + cel[36];

	wire [2:0] sum_3_to_5__4;
	assign sum_3_to_5__4 = cel[35] + cel[36] + cel[37];

	wire [2:0] sum_4_to_6__4;
	assign sum_4_to_6__4 = cel[36] + cel[37] + cel[38];

	wire [2:0] sum_5_to_7__4;
	assign sum_5_to_7__4 = cel[37] + cel[38] + cel[39];

	wire [2:0] sum_6_to_0__4;
	assign sum_6_to_0__4 = cel[38] + cel[39] + cel[32];

	wire [2:0] sum_7_to_1__4;
	assign sum_7_to_1__4 = cel[39] + cel[32] + cel[33];

	wire [2:0] sum_0_to_2__5;
	assign sum_0_to_2__5 = cel[40] + cel[41] + cel[42];

	wire [2:0] sum_1_to_3__5;
	assign sum_1_to_3__5 = cel[41] + cel[42] + cel[43];

	wire [2:0] sum_2_to_4__5;
	assign sum_2_to_4__5 = cel[42] + cel[43] + cel[44];

	wire [2:0] sum_3_to_5__5;
	assign sum_3_to_5__5 = cel[43] + cel[44] + cel[45];

	wire [2:0] sum_4_to_6__5;
	assign sum_4_to_6__5 = cel[44] + cel[45] + cel[46];

	wire [2:0] sum_5_to_7__5;
	assign sum_5_to_7__5 = cel[45] + cel[46] + cel[47];

	wire [2:0] sum_6_to_0__5;
	assign sum_6_to_0__5 = cel[46] + cel[47] + cel[40];

	wire [2:0] sum_7_to_1__5;
	assign sum_7_to_1__5 = cel[47] + cel[40] + cel[41];

	wire [2:0] sum_0_to_2__6;
	assign sum_0_to_2__6 = cel[48] + cel[49] + cel[50];

	wire [2:0] sum_1_to_3__6;
	assign sum_1_to_3__6 = cel[49] + cel[50] + cel[51];

	wire [2:0] sum_2_to_4__6;
	assign sum_2_to_4__6 = cel[50] + cel[51] + cel[52];

	wire [2:0] sum_3_to_5__6;
	assign sum_3_to_5__6 = cel[51] + cel[52] + cel[53];

	wire [2:0] sum_4_to_6__6;
	assign sum_4_to_6__6 = cel[52] + cel[53] + cel[54];

	wire [2:0] sum_5_to_7__6;
	assign sum_5_to_7__6 = cel[53] + cel[54] + cel[55];

	wire [2:0] sum_6_to_0__6;
	assign sum_6_to_0__6 = cel[54] + cel[55] + cel[48];

	wire [2:0] sum_7_to_1__6;
	assign sum_7_to_1__6 = cel[55] + cel[48] + cel[49];

	wire [2:0] sum_0_to_2__7;
	assign sum_0_to_2__7 = cel[56] + cel[57] + cel[58];

	wire [2:0] sum_1_to_3__7;
	assign sum_1_to_3__7 = cel[57] + cel[58] + cel[59];

	wire [2:0] sum_2_to_4__7;
	assign sum_2_to_4__7 = cel[58] + cel[59] + cel[60];

	wire [2:0] sum_3_to_5__7;
	assign sum_3_to_5__7 = cel[59] + cel[60] + cel[61];

	wire [2:0] sum_4_to_6__7;
	assign sum_4_to_6__7 = cel[60] + cel[61] + cel[62];

	wire [2:0] sum_5_to_7__7;
	assign sum_5_to_7__7 = cel[61] + cel[62] + cel[63];

	wire [2:0] sum_6_to_0__7;
	assign sum_6_to_0__7 = cel[62] + cel[63] + cel[56];

	wire [2:0] sum_7_to_1__7;
	assign sum_7_to_1__7 = cel[63] + cel[56] + cel[57];

	


	/* (0,0) = cell 0 */

	wire [3:0] count0;
	assign count0 = sum_7_to_1__7 + sum_7_to_1__0 + sum_7_to_1__1;
	always @(posedge clk) cel[0] <= (count0 == 3) || (cel[0] & (count0 == 4));

	/* (1,0) = cell 1 */

	wire [3:0] count1;
	assign count1 = sum_0_to_2__7 + sum_0_to_2__0 + sum_0_to_2__1;
	always @(posedge clk) cel[1] <= (count1 == 3) || (cel[1] & (count1 == 4));

	/* (2,0) = cell 2 */

	wire [3:0] count2;
	assign count2 = sum_1_to_3__7 + sum_1_to_3__0 + sum_1_to_3__1;
	always @(posedge clk) cel[2] <= (count2 == 3) || (cel[2] & (count2 == 4));

	/* (3,0) = cell 3 */

	wire [3:0] count3;
	assign count3 = sum_2_to_4__7 + sum_2_to_4__0 + sum_2_to_4__1;
	always @(posedge clk) cel[3] <= (count3 == 3) || (cel[3] & (count3 == 4));

	/* (4,0) = cell 4 */

	wire [3:0] count4;
	assign count4 = sum_3_to_5__7 + sum_3_to_5__0 + sum_3_to_5__1;
	always @(posedge clk) cel[4] <= (count4 == 3) || (cel[4] & (count4 == 4));

	/* (5,0) = cell 5 */

	wire [3:0] count5;
	assign count5 = sum_4_to_6__7 + sum_4_to_6__0 + sum_4_to_6__1;
	always @(posedge clk) cel[5] <= (count5 == 3) || (cel[5] & (count5 == 4));

	/* (6,0) = cell 6 */

	wire [3:0] count6;
	assign count6 = sum_5_to_7__7 + sum_5_to_7__0 + sum_5_to_7__1;
	always @(posedge clk) cel[6] <= (count6 == 3) || (cel[6] & (count6 == 4));

	/* (7,0) = cell 7 */

	wire [3:0] count7;
	assign count7 = sum_6_to_0__7 + sum_6_to_0__0 + sum_6_to_0__1;
	always @(posedge clk) cel[7] <= (count7 == 3) || (cel[7] & (count7 == 4));

	/* (0,1) = cell 8 */

	wire [3:0] count8;
	assign count8 = sum_7_to_1__0 + sum_7_to_1__1 + sum_7_to_1__2;
	always @(posedge clk) cel[8] <= (count8 == 3) || (cel[8] & (count8 == 4));

	/* (1,1) = cell 9 */

	wire [3:0] count9;
	assign count9 = sum_0_to_2__0 + sum_0_to_2__1 + sum_0_to_2__2;
	always @(posedge clk) cel[9] <= (count9 == 3) || (cel[9] & (count9 == 4));

	/* (2,1) = cell 10 */

	wire [3:0] count10;
	assign count10 = sum_1_to_3__0 + sum_1_to_3__1 + sum_1_to_3__2;
	always @(posedge clk) cel[10] <= (count10 == 3) || (cel[10] & (count10 == 4));

	/* (3,1) = cell 11 */

	wire [3:0] count11;
	assign count11 = sum_2_to_4__0 + sum_2_to_4__1 + sum_2_to_4__2;
	always @(posedge clk) cel[11] <= (count11 == 3) || (cel[11] & (count11 == 4));

	/* (4,1) = cell 12 */

	wire [3:0] count12;
	assign count12 = sum_3_to_5__0 + sum_3_to_5__1 + sum_3_to_5__2;
	always @(posedge clk) cel[12] <= (count12 == 3) || (cel[12] & (count12 == 4));

	/* (5,1) = cell 13 */

	wire [3:0] count13;
	assign count13 = sum_4_to_6__0 + sum_4_to_6__1 + sum_4_to_6__2;
	always @(posedge clk) cel[13] <= (count13 == 3) || (cel[13] & (count13 == 4));

	/* (6,1) = cell 14 */

	wire [3:0] count14;
	assign count14 = sum_5_to_7__0 + sum_5_to_7__1 + sum_5_to_7__2;
	always @(posedge clk) cel[14] <= (count14 == 3) || (cel[14] & (count14 == 4));

	/* (7,1) = cell 15 */

	wire [3:0] count15;
	assign count15 = sum_6_to_0__0 + sum_6_to_0__1 + sum_6_to_0__2;
	always @(posedge clk) cel[15] <= (count15 == 3) || (cel[15] & (count15 == 4));

	/* (0,2) = cell 16 */

	wire [3:0] count16;
	assign count16 = sum_7_to_1__1 + sum_7_to_1__2 + sum_7_to_1__3;
	always @(posedge clk) cel[16] <= (count16 == 3) || (cel[16] & (count16 == 4));

	/* (1,2) = cell 17 */

	wire [3:0] count17;
	assign count17 = sum_0_to_2__1 + sum_0_to_2__2 + sum_0_to_2__3;
	always @(posedge clk) cel[17] <= (count17 == 3) || (cel[17] & (count17 == 4));

	/* (2,2) = cell 18 */

	wire [3:0] count18;
	assign count18 = sum_1_to_3__1 + sum_1_to_3__2 + sum_1_to_3__3;
	always @(posedge clk) cel[18] <= (count18 == 3) || (cel[18] & (count18 == 4));

	/* (3,2) = cell 19 */

	wire [3:0] count19;
	assign count19 = sum_2_to_4__1 + sum_2_to_4__2 + sum_2_to_4__3;
	always @(posedge clk) cel[19] <= (count19 == 3) || (cel[19] & (count19 == 4));

	/* (4,2) = cell 20 */

	wire [3:0] count20;
	assign count20 = sum_3_to_5__1 + sum_3_to_5__2 + sum_3_to_5__3;
	always @(posedge clk) cel[20] <= (count20 == 3) || (cel[20] & (count20 == 4));

	/* (5,2) = cell 21 */

	wire [3:0] count21;
	assign count21 = sum_4_to_6__1 + sum_4_to_6__2 + sum_4_to_6__3;
	always @(posedge clk) cel[21] <= (count21 == 3) || (cel[21] & (count21 == 4));

	/* (6,2) = cell 22 */

	wire [3:0] count22;
	assign count22 = sum_5_to_7__1 + sum_5_to_7__2 + sum_5_to_7__3;
	always @(posedge clk) cel[22] <= (count22 == 3) || (cel[22] & (count22 == 4));

	/* (7,2) = cell 23 */

	wire [3:0] count23;
	assign count23 = sum_6_to_0__1 + sum_6_to_0__2 + sum_6_to_0__3;
	always @(posedge clk) cel[23] <= (count23 == 3) || (cel[23] & (count23 == 4));

	/* (0,3) = cell 24 */

	wire [3:0] count24;
	assign count24 = sum_7_to_1__2 + sum_7_to_1__3 + sum_7_to_1__4;
	always @(posedge clk) cel[24] <= (count24 == 3) || (cel[24] & (count24 == 4));

	/* (1,3) = cell 25 */

	wire [3:0] count25;
	assign count25 = sum_0_to_2__2 + sum_0_to_2__3 + sum_0_to_2__4;
	always @(posedge clk) cel[25] <= (count25 == 3) || (cel[25] & (count25 == 4));

	/* (2,3) = cell 26 */

	wire [3:0] count26;
	assign count26 = sum_1_to_3__2 + sum_1_to_3__3 + sum_1_to_3__4;
	always @(posedge clk) cel[26] <= (count26 == 3) || (cel[26] & (count26 == 4));

	/* (3,3) = cell 27 */

	wire [3:0] count27;
	assign count27 = sum_2_to_4__2 + sum_2_to_4__3 + sum_2_to_4__4;
	always @(posedge clk) cel[27] <= (count27 == 3) || (cel[27] & (count27 == 4));

	/* (4,3) = cell 28 */

	wire [3:0] count28;
	assign count28 = sum_3_to_5__2 + sum_3_to_5__3 + sum_3_to_5__4;
	always @(posedge clk) cel[28] <= (count28 == 3) || (cel[28] & (count28 == 4));

	/* (5,3) = cell 29 */

	wire [3:0] count29;
	assign count29 = sum_4_to_6__2 + sum_4_to_6__3 + sum_4_to_6__4;
	always @(posedge clk) cel[29] <= (count29 == 3) || (cel[29] & (count29 == 4));

	/* (6,3) = cell 30 */

	wire [3:0] count30;
	assign count30 = sum_5_to_7__2 + sum_5_to_7__3 + sum_5_to_7__4;
	always @(posedge clk) cel[30] <= (count30 == 3) || (cel[30] & (count30 == 4));

	/* (7,3) = cell 31 */

	wire [3:0] count31;
	assign count31 = sum_6_to_0__2 + sum_6_to_0__3 + sum_6_to_0__4;
	always @(posedge clk) cel[31] <= (count31 == 3) || (cel[31] & (count31 == 4));

	/* (0,4) = cell 32 */

	wire [3:0] count32;
	assign count32 = sum_7_to_1__3 + sum_7_to_1__4 + sum_7_to_1__5;
	always @(posedge clk) cel[32] <= (count32 == 3) || (cel[32] & (count32 == 4));

	/* (1,4) = cell 33 */

	wire [3:0] count33;
	assign count33 = sum_0_to_2__3 + sum_0_to_2__4 + sum_0_to_2__5;
	always @(posedge clk) cel[33] <= (count33 == 3) || (cel[33] & (count33 == 4));

	/* (2,4) = cell 34 */

	wire [3:0] count34;
	assign count34 = sum_1_to_3__3 + sum_1_to_3__4 + sum_1_to_3__5;
	always @(posedge clk) cel[34] <= (count34 == 3) || (cel[34] & (count34 == 4));

	/* (3,4) = cell 35 */

	wire [3:0] count35;
	assign count35 = sum_2_to_4__3 + sum_2_to_4__4 + sum_2_to_4__5;
	always @(posedge clk) cel[35] <= (count35 == 3) || (cel[35] & (count35 == 4));

	/* (4,4) = cell 36 */

	wire [3:0] count36;
	assign count36 = sum_3_to_5__3 + sum_3_to_5__4 + sum_3_to_5__5;
	always @(posedge clk) cel[36] <= (count36 == 3) || (cel[36] & (count36 == 4));

	/* (5,4) = cell 37 */

	wire [3:0] count37;
	assign count37 = sum_4_to_6__3 + sum_4_to_6__4 + sum_4_to_6__5;
	always @(posedge clk) cel[37] <= (count37 == 3) || (cel[37] & (count37 == 4));

	/* (6,4) = cell 38 */

	wire [3:0] count38;
	assign count38 = sum_5_to_7__3 + sum_5_to_7__4 + sum_5_to_7__5;
	always @(posedge clk) cel[38] <= (count38 == 3) || (cel[38] & (count38 == 4));

	/* (7,4) = cell 39 */

	wire [3:0] count39;
	assign count39 = sum_6_to_0__3 + sum_6_to_0__4 + sum_6_to_0__5;
	always @(posedge clk) cel[39] <= (count39 == 3) || (cel[39] & (count39 == 4));

	/* (0,5) = cell 40 */

	wire [3:0] count40;
	assign count40 = sum_7_to_1__4 + sum_7_to_1__5 + sum_7_to_1__6;
	always @(posedge clk) cel[40] <= (count40 == 3) || (cel[40] & (count40 == 4));

	/* (1,5) = cell 41 */

	wire [3:0] count41;
	assign count41 = sum_0_to_2__4 + sum_0_to_2__5 + sum_0_to_2__6;
	always @(posedge clk) cel[41] <= (count41 == 3) || (cel[41] & (count41 == 4));

	/* (2,5) = cell 42 */

	wire [3:0] count42;
	assign count42 = sum_1_to_3__4 + sum_1_to_3__5 + sum_1_to_3__6;
	always @(posedge clk) cel[42] <= (count42 == 3) || (cel[42] & (count42 == 4));

	/* (3,5) = cell 43 */

	wire [3:0] count43;
	assign count43 = sum_2_to_4__4 + sum_2_to_4__5 + sum_2_to_4__6;
	always @(posedge clk) cel[43] <= (count43 == 3) || (cel[43] & (count43 == 4));

	/* (4,5) = cell 44 */

	wire [3:0] count44;
	assign count44 = sum_3_to_5__4 + sum_3_to_5__5 + sum_3_to_5__6;
	always @(posedge clk) cel[44] <= (count44 == 3) || (cel[44] & (count44 == 4));

	/* (5,5) = cell 45 */

	wire [3:0] count45;
	assign count45 = sum_4_to_6__4 + sum_4_to_6__5 + sum_4_to_6__6;
	always @(posedge clk) cel[45] <= (count45 == 3) || (cel[45] & (count45 == 4));

	/* (6,5) = cell 46 */

	wire [3:0] count46;
	assign count46 = sum_5_to_7__4 + sum_5_to_7__5 + sum_5_to_7__6;
	always @(posedge clk) cel[46] <= (count46 == 3) || (cel[46] & (count46 == 4));

	/* (7,5) = cell 47 */

	wire [3:0] count47;
	assign count47 = sum_6_to_0__4 + sum_6_to_0__5 + sum_6_to_0__6;
	always @(posedge clk) cel[47] <= (count47 == 3) || (cel[47] & (count47 == 4));

	/* (0,6) = cell 48 */

	wire [3:0] count48;
	assign count48 = sum_7_to_1__5 + sum_7_to_1__6 + sum_7_to_1__7;
	always @(posedge clk) cel[48] <= (count48 == 3) || (cel[48] & (count48 == 4));

	/* (1,6) = cell 49 */

	wire [3:0] count49;
	assign count49 = sum_0_to_2__5 + sum_0_to_2__6 + sum_0_to_2__7;
	always @(posedge clk) cel[49] <= (count49 == 3) || (cel[49] & (count49 == 4));

	/* (2,6) = cell 50 */

	wire [3:0] count50;
	assign count50 = sum_1_to_3__5 + sum_1_to_3__6 + sum_1_to_3__7;
	always @(posedge clk) cel[50] <= (count50 == 3) || (cel[50] & (count50 == 4));

	/* (3,6) = cell 51 */

	wire [3:0] count51;
	assign count51 = sum_2_to_4__5 + sum_2_to_4__6 + sum_2_to_4__7;
	always @(posedge clk) cel[51] <= (count51 == 3) || (cel[51] & (count51 == 4));

	/* (4,6) = cell 52 */

	wire [3:0] count52;
	assign count52 = sum_3_to_5__5 + sum_3_to_5__6 + sum_3_to_5__7;
	always @(posedge clk) cel[52] <= (count52 == 3) || (cel[52] & (count52 == 4));

	/* (5,6) = cell 53 */

	wire [3:0] count53;
	assign count53 = sum_4_to_6__5 + sum_4_to_6__6 + sum_4_to_6__7;
	always @(posedge clk) cel[53] <= (count53 == 3) || (cel[53] & (count53 == 4));

	/* (6,6) = cell 54 */

	wire [3:0] count54;
	assign count54 = sum_5_to_7__5 + sum_5_to_7__6 + sum_5_to_7__7;
	always @(posedge clk) cel[54] <= (count54 == 3) || (cel[54] & (count54 == 4));

	/* (7,6) = cell 55 */

	wire [3:0] count55;
	assign count55 = sum_6_to_0__5 + sum_6_to_0__6 + sum_6_to_0__7;
	always @(posedge clk) cel[55] <= (count55 == 3) || (cel[55] & (count55 == 4));

	/* (0,7) = cell 56 */

	wire [3:0] count56;
	assign count56 = sum_7_to_1__6 + sum_7_to_1__7 + sum_7_to_1__0;
	always @(posedge clk) cel[56] <= (count56 == 3) || (cel[56] & (count56 == 4));

	/* (1,7) = cell 57 */

	wire [3:0] count57;
	assign count57 = sum_0_to_2__6 + sum_0_to_2__7 + sum_0_to_2__0;
	always @(posedge clk) cel[57] <= (count57 == 3) || (cel[57] & (count57 == 4));

	/* (2,7) = cell 58 */

	wire [3:0] count58;
	assign count58 = sum_1_to_3__6 + sum_1_to_3__7 + sum_1_to_3__0;
	always @(posedge clk) cel[58] <= (count58 == 3) || (cel[58] & (count58 == 4));

	/* (3,7) = cell 59 */

	wire [3:0] count59;
	assign count59 = sum_2_to_4__6 + sum_2_to_4__7 + sum_2_to_4__0;
	always @(posedge clk) cel[59] <= (count59 == 3) || (cel[59] & (count59 == 4));

	/* (4,7) = cell 60 */

	wire [3:0] count60;
	assign count60 = sum_3_to_5__6 + sum_3_to_5__7 + sum_3_to_5__0;
	always @(posedge clk) cel[60] <= (count60 == 3) || (cel[60] & (count60 == 4));

	/* (5,7) = cell 61 */

	wire [3:0] count61;
	assign count61 = sum_4_to_6__6 + sum_4_to_6__7 + sum_4_to_6__0;
	always @(posedge clk) cel[61] <= (count61 == 3) || (cel[61] & (count61 == 4));

	/* (6,7) = cell 62 */

	wire [3:0] count62;
	assign count62 = sum_5_to_7__6 + sum_5_to_7__7 + sum_5_to_7__0;
	always @(posedge clk) cel[62] <= (count62 == 3) || (cel[62] & (count62 == 4));

	/* (7,7) = cell 63 */

	wire [3:0] count63;
	assign count63 = sum_6_to_0__6 + sum_6_to_0__7 + sum_6_to_0__0;
	always @(posedge clk) cel[63] <= (count63 == 3) || (cel[63] & (count63 == 4));
endmodule
