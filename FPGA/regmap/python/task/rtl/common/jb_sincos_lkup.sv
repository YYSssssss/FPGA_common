   ///////////////////////////////////////////////////////////////////////////////////
    ////  File Name : jb_nco.sv
    ///// Author    : Shehanaj Begum
    ///// Date      : 1/04/2019
    ///// Description  : This module does the nco    
    ////////////////////////////////////////////////////////////////////////////////////


module jb_sincos_lkup #(
	    parameter NCO_QUAD_LKUP_TBL_ENTRIES_BW = 10,
            parameter PRECISION =16
) (
   input clk,
   input resetn,

   input [NCO_QUAD_LKUP_TBL_ENTRIES_BW-1:0] ptr,

   output logic signed [PRECISION-1 :0] curr_sin,
   output logic signed [PRECISION-1 :0] curr_cos,
   output logic signed [PRECISION-1 :0] next_sin,
   output logic signed [PRECISION-1 :0] next_cos
   

  );
  

     logic signed [PRECISION-1 :0] curr_sin_lkup;
     logic signed [PRECISION-1 :0] curr_cos_lkup;
     logic signed [PRECISION-1 :0] next_sin_lkup;
     logic signed [PRECISION-1 :0] next_cos_lkup;
     
    always @(posedge clk) begin
      if (!resetn) begin
	 curr_sin <= 0;
	 curr_cos <= 0;
	 next_sin <= 0;
	 next_cos <= 0;
      end
      else begin
	 curr_sin <= curr_sin_lkup;
	 curr_cos <= curr_cos_lkup;
	 next_sin <= next_sin_lkup;
	 next_cos <= next_cos_lkup;
      end     end // always @ (posedge clk) 
  
 always @(ptr) begin
  case(ptr)
    0    : begin
             curr_sin_lkup=0;
             curr_cos_lkup=32767;
             next_sin_lkup=50;
             next_cos_lkup=32767;
           end
    1    : begin
             curr_sin_lkup=50;
             curr_cos_lkup=32767;
             next_sin_lkup=100;
             next_cos_lkup=32767;
           end
    2    : begin
             curr_sin_lkup=100;
             curr_cos_lkup=32767;
             next_sin_lkup=150;
             next_cos_lkup=32767;
           end
    3    : begin
             curr_sin_lkup=150;
             curr_cos_lkup=32767;
             next_sin_lkup=201;
             next_cos_lkup=32767;
           end
    4    : begin
             curr_sin_lkup=201;
             curr_cos_lkup=32767;
             next_sin_lkup=251;
             next_cos_lkup=32767;
           end
    5    : begin
             curr_sin_lkup=251;
             curr_cos_lkup=32767;
             next_sin_lkup=301;
             next_cos_lkup=32766;
           end
    6    : begin
             curr_sin_lkup=301;
             curr_cos_lkup=32766;
             next_sin_lkup=351;
             next_cos_lkup=32766;
           end
    7    : begin
             curr_sin_lkup=351;
             curr_cos_lkup=32766;
             next_sin_lkup=402;
             next_cos_lkup=32765;
           end
    8    : begin
             curr_sin_lkup=402;
             curr_cos_lkup=32765;
             next_sin_lkup=452;
             next_cos_lkup=32764;
           end
    9    : begin
             curr_sin_lkup=452;
             curr_cos_lkup=32764;
             next_sin_lkup=502;
             next_cos_lkup=32764;
           end
    10   : begin
             curr_sin_lkup=502;
             curr_cos_lkup=32764;
             next_sin_lkup=552;
             next_cos_lkup=32763;
           end
    11   : begin
             curr_sin_lkup=552;
             curr_cos_lkup=32763;
             next_sin_lkup=603;
             next_cos_lkup=32762;
           end
    12   : begin
             curr_sin_lkup=603;
             curr_cos_lkup=32762;
             next_sin_lkup=653;
             next_cos_lkup=32761;
           end
    13   : begin
             curr_sin_lkup=653;
             curr_cos_lkup=32761;
             next_sin_lkup=703;
             next_cos_lkup=32760;
           end
    14   : begin
             curr_sin_lkup=703;
             curr_cos_lkup=32760;
             next_sin_lkup=753;
             next_cos_lkup=32759;
           end
    15   : begin
             curr_sin_lkup=753;
             curr_cos_lkup=32759;
             next_sin_lkup=804;
             next_cos_lkup=32758;
           end
    16   : begin
             curr_sin_lkup=804;
             curr_cos_lkup=32758;
             next_sin_lkup=854;
             next_cos_lkup=32756;
           end
    17   : begin
             curr_sin_lkup=854;
             curr_cos_lkup=32756;
             next_sin_lkup=904;
             next_cos_lkup=32755;
           end
    18   : begin
             curr_sin_lkup=904;
             curr_cos_lkup=32755;
             next_sin_lkup=954;
             next_cos_lkup=32754;
           end
    19   : begin
             curr_sin_lkup=954;
             curr_cos_lkup=32754;
             next_sin_lkup=1005;
             next_cos_lkup=32752;
           end
    20   : begin
             curr_sin_lkup=1005;
             curr_cos_lkup=32752;
             next_sin_lkup=1055;
             next_cos_lkup=32750;
           end
    21   : begin
             curr_sin_lkup=1055;
             curr_cos_lkup=32750;
             next_sin_lkup=1105;
             next_cos_lkup=32749;
           end
    22   : begin
             curr_sin_lkup=1105;
             curr_cos_lkup=32749;
             next_sin_lkup=1155;
             next_cos_lkup=32747;
           end
    23   : begin
             curr_sin_lkup=1155;
             curr_cos_lkup=32747;
             next_sin_lkup=1206;
             next_cos_lkup=32745;
           end
    24   : begin
             curr_sin_lkup=1206;
             curr_cos_lkup=32745;
             next_sin_lkup=1256;
             next_cos_lkup=32743;
           end
    25   : begin
             curr_sin_lkup=1256;
             curr_cos_lkup=32743;
             next_sin_lkup=1306;
             next_cos_lkup=32741;
           end
    26   : begin
             curr_sin_lkup=1306;
             curr_cos_lkup=32741;
             next_sin_lkup=1356;
             next_cos_lkup=32739;
           end
    27   : begin
             curr_sin_lkup=1356;
             curr_cos_lkup=32739;
             next_sin_lkup=1407;
             next_cos_lkup=32737;
           end
    28   : begin
             curr_sin_lkup=1407;
             curr_cos_lkup=32737;
             next_sin_lkup=1457;
             next_cos_lkup=32735;
           end
    29   : begin
             curr_sin_lkup=1457;
             curr_cos_lkup=32735;
             next_sin_lkup=1507;
             next_cos_lkup=32733;
           end
    30   : begin
             curr_sin_lkup=1507;
             curr_cos_lkup=32733;
             next_sin_lkup=1557;
             next_cos_lkup=32730;
           end
    31   : begin
             curr_sin_lkup=1557;
             curr_cos_lkup=32730;
             next_sin_lkup=1607;
             next_cos_lkup=32728;
           end
    32   : begin
             curr_sin_lkup=1607;
             curr_cos_lkup=32728;
             next_sin_lkup=1658;
             next_cos_lkup=32726;
           end
    33   : begin
             curr_sin_lkup=1658;
             curr_cos_lkup=32726;
             next_sin_lkup=1708;
             next_cos_lkup=32723;
           end
    34   : begin
             curr_sin_lkup=1708;
             curr_cos_lkup=32723;
             next_sin_lkup=1758;
             next_cos_lkup=32720;
           end
    35   : begin
             curr_sin_lkup=1758;
             curr_cos_lkup=32720;
             next_sin_lkup=1808;
             next_cos_lkup=32718;
           end
    36   : begin
             curr_sin_lkup=1808;
             curr_cos_lkup=32718;
             next_sin_lkup=1858;
             next_cos_lkup=32715;
           end
    37   : begin
             curr_sin_lkup=1858;
             curr_cos_lkup=32715;
             next_sin_lkup=1909;
             next_cos_lkup=32712;
           end
    38   : begin
             curr_sin_lkup=1909;
             curr_cos_lkup=32712;
             next_sin_lkup=1959;
             next_cos_lkup=32709;
           end
    39   : begin
             curr_sin_lkup=1959;
             curr_cos_lkup=32709;
             next_sin_lkup=2009;
             next_cos_lkup=32706;
           end
    40   : begin
             curr_sin_lkup=2009;
             curr_cos_lkup=32706;
             next_sin_lkup=2059;
             next_cos_lkup=32703;
           end
    41   : begin
             curr_sin_lkup=2059;
             curr_cos_lkup=32703;
             next_sin_lkup=2109;
             next_cos_lkup=32700;
           end
    42   : begin
             curr_sin_lkup=2109;
             curr_cos_lkup=32700;
             next_sin_lkup=2159;
             next_cos_lkup=32696;
           end
    43   : begin
             curr_sin_lkup=2159;
             curr_cos_lkup=32696;
             next_sin_lkup=2210;
             next_cos_lkup=32693;
           end
    44   : begin
             curr_sin_lkup=2210;
             curr_cos_lkup=32693;
             next_sin_lkup=2260;
             next_cos_lkup=32689;
           end
    45   : begin
             curr_sin_lkup=2260;
             curr_cos_lkup=32689;
             next_sin_lkup=2310;
             next_cos_lkup=32686;
           end
    46   : begin
             curr_sin_lkup=2310;
             curr_cos_lkup=32686;
             next_sin_lkup=2360;
             next_cos_lkup=32682;
           end
    47   : begin
             curr_sin_lkup=2360;
             curr_cos_lkup=32682;
             next_sin_lkup=2410;
             next_cos_lkup=32679;
           end
    48   : begin
             curr_sin_lkup=2410;
             curr_cos_lkup=32679;
             next_sin_lkup=2460;
             next_cos_lkup=32675;
           end
    49   : begin
             curr_sin_lkup=2460;
             curr_cos_lkup=32675;
             next_sin_lkup=2510;
             next_cos_lkup=32671;
           end
    50   : begin
             curr_sin_lkup=2510;
             curr_cos_lkup=32671;
             next_sin_lkup=2560;
             next_cos_lkup=32667;
           end
    51   : begin
             curr_sin_lkup=2560;
             curr_cos_lkup=32667;
             next_sin_lkup=2611;
             next_cos_lkup=32663;
           end
    52   : begin
             curr_sin_lkup=2611;
             curr_cos_lkup=32663;
             next_sin_lkup=2661;
             next_cos_lkup=32659;
           end
    53   : begin
             curr_sin_lkup=2661;
             curr_cos_lkup=32659;
             next_sin_lkup=2711;
             next_cos_lkup=32655;
           end
    54   : begin
             curr_sin_lkup=2711;
             curr_cos_lkup=32655;
             next_sin_lkup=2761;
             next_cos_lkup=32651;
           end
    55   : begin
             curr_sin_lkup=2761;
             curr_cos_lkup=32651;
             next_sin_lkup=2811;
             next_cos_lkup=32647;
           end
    56   : begin
             curr_sin_lkup=2811;
             curr_cos_lkup=32647;
             next_sin_lkup=2861;
             next_cos_lkup=32642;
           end
    57   : begin
             curr_sin_lkup=2861;
             curr_cos_lkup=32642;
             next_sin_lkup=2911;
             next_cos_lkup=32638;
           end
    58   : begin
             curr_sin_lkup=2911;
             curr_cos_lkup=32638;
             next_sin_lkup=2961;
             next_cos_lkup=32633;
           end
    59   : begin
             curr_sin_lkup=2961;
             curr_cos_lkup=32633;
             next_sin_lkup=3011;
             next_cos_lkup=32629;
           end
    60   : begin
             curr_sin_lkup=3011;
             curr_cos_lkup=32629;
             next_sin_lkup=3061;
             next_cos_lkup=32624;
           end
    61   : begin
             curr_sin_lkup=3061;
             curr_cos_lkup=32624;
             next_sin_lkup=3111;
             next_cos_lkup=32619;
           end
    62   : begin
             curr_sin_lkup=3111;
             curr_cos_lkup=32619;
             next_sin_lkup=3161;
             next_cos_lkup=32615;
           end
    63   : begin
             curr_sin_lkup=3161;
             curr_cos_lkup=32615;
             next_sin_lkup=3211;
             next_cos_lkup=32610;
           end
    64   : begin
             curr_sin_lkup=3211;
             curr_cos_lkup=32610;
             next_sin_lkup=3261;
             next_cos_lkup=32605;
           end
    65   : begin
             curr_sin_lkup=3261;
             curr_cos_lkup=32605;
             next_sin_lkup=3311;
             next_cos_lkup=32600;
           end
    66   : begin
             curr_sin_lkup=3311;
             curr_cos_lkup=32600;
             next_sin_lkup=3361;
             next_cos_lkup=32595;
           end
    67   : begin
             curr_sin_lkup=3361;
             curr_cos_lkup=32595;
             next_sin_lkup=3411;
             next_cos_lkup=32589;
           end
    68   : begin
             curr_sin_lkup=3411;
             curr_cos_lkup=32589;
             next_sin_lkup=3461;
             next_cos_lkup=32584;
           end
    69   : begin
             curr_sin_lkup=3461;
             curr_cos_lkup=32584;
             next_sin_lkup=3511;
             next_cos_lkup=32579;
           end
    70   : begin
             curr_sin_lkup=3511;
             curr_cos_lkup=32579;
             next_sin_lkup=3561;
             next_cos_lkup=32573;
           end
    71   : begin
             curr_sin_lkup=3561;
             curr_cos_lkup=32573;
             next_sin_lkup=3611;
             next_cos_lkup=32568;
           end
    72   : begin
             curr_sin_lkup=3611;
             curr_cos_lkup=32568;
             next_sin_lkup=3661;
             next_cos_lkup=32562;
           end
    73   : begin
             curr_sin_lkup=3661;
             curr_cos_lkup=32562;
             next_sin_lkup=3711;
             next_cos_lkup=32557;
           end
    74   : begin
             curr_sin_lkup=3711;
             curr_cos_lkup=32557;
             next_sin_lkup=3761;
             next_cos_lkup=32551;
           end
    75   : begin
             curr_sin_lkup=3761;
             curr_cos_lkup=32551;
             next_sin_lkup=3811;
             next_cos_lkup=32545;
           end
    76   : begin
             curr_sin_lkup=3811;
             curr_cos_lkup=32545;
             next_sin_lkup=3861;
             next_cos_lkup=32539;
           end
    77   : begin
             curr_sin_lkup=3861;
             curr_cos_lkup=32539;
             next_sin_lkup=3911;
             next_cos_lkup=32533;
           end
    78   : begin
             curr_sin_lkup=3911;
             curr_cos_lkup=32533;
             next_sin_lkup=3961;
             next_cos_lkup=32527;
           end
    79   : begin
             curr_sin_lkup=3961;
             curr_cos_lkup=32527;
             next_sin_lkup=4011;
             next_cos_lkup=32521;
           end
    80   : begin
             curr_sin_lkup=4011;
             curr_cos_lkup=32521;
             next_sin_lkup=4061;
             next_cos_lkup=32515;
           end
    81   : begin
             curr_sin_lkup=4061;
             curr_cos_lkup=32515;
             next_sin_lkup=4110;
             next_cos_lkup=32509;
           end
    82   : begin
             curr_sin_lkup=4110;
             curr_cos_lkup=32509;
             next_sin_lkup=4160;
             next_cos_lkup=32502;
           end
    83   : begin
             curr_sin_lkup=4160;
             curr_cos_lkup=32502;
             next_sin_lkup=4210;
             next_cos_lkup=32496;
           end
    84   : begin
             curr_sin_lkup=4210;
             curr_cos_lkup=32496;
             next_sin_lkup=4260;
             next_cos_lkup=32489;
           end
    85   : begin
             curr_sin_lkup=4260;
             curr_cos_lkup=32489;
             next_sin_lkup=4310;
             next_cos_lkup=32483;
           end
    86   : begin
             curr_sin_lkup=4310;
             curr_cos_lkup=32483;
             next_sin_lkup=4360;
             next_cos_lkup=32476;
           end
    87   : begin
             curr_sin_lkup=4360;
             curr_cos_lkup=32476;
             next_sin_lkup=4409;
             next_cos_lkup=32469;
           end
    88   : begin
             curr_sin_lkup=4409;
             curr_cos_lkup=32469;
             next_sin_lkup=4459;
             next_cos_lkup=32463;
           end
    89   : begin
             curr_sin_lkup=4459;
             curr_cos_lkup=32463;
             next_sin_lkup=4509;
             next_cos_lkup=32456;
           end
    90   : begin
             curr_sin_lkup=4509;
             curr_cos_lkup=32456;
             next_sin_lkup=4559;
             next_cos_lkup=32449;
           end
    91   : begin
             curr_sin_lkup=4559;
             curr_cos_lkup=32449;
             next_sin_lkup=4609;
             next_cos_lkup=32442;
           end
    92   : begin
             curr_sin_lkup=4609;
             curr_cos_lkup=32442;
             next_sin_lkup=4658;
             next_cos_lkup=32435;
           end
    93   : begin
             curr_sin_lkup=4658;
             curr_cos_lkup=32435;
             next_sin_lkup=4708;
             next_cos_lkup=32427;
           end
    94   : begin
             curr_sin_lkup=4708;
             curr_cos_lkup=32427;
             next_sin_lkup=4758;
             next_cos_lkup=32420;
           end
    95   : begin
             curr_sin_lkup=4758;
             curr_cos_lkup=32420;
             next_sin_lkup=4808;
             next_cos_lkup=32413;
           end
    96   : begin
             curr_sin_lkup=4808;
             curr_cos_lkup=32413;
             next_sin_lkup=4857;
             next_cos_lkup=32405;
           end
    97   : begin
             curr_sin_lkup=4857;
             curr_cos_lkup=32405;
             next_sin_lkup=4907;
             next_cos_lkup=32398;
           end
    98   : begin
             curr_sin_lkup=4907;
             curr_cos_lkup=32398;
             next_sin_lkup=4957;
             next_cos_lkup=32390;
           end
    99   : begin
             curr_sin_lkup=4957;
             curr_cos_lkup=32390;
             next_sin_lkup=5006;
             next_cos_lkup=32383;
           end
    100  : begin
             curr_sin_lkup=5006;
             curr_cos_lkup=32383;
             next_sin_lkup=5056;
             next_cos_lkup=32375;
           end
    101  : begin
             curr_sin_lkup=5056;
             curr_cos_lkup=32375;
             next_sin_lkup=5106;
             next_cos_lkup=32367;
           end
    102  : begin
             curr_sin_lkup=5106;
             curr_cos_lkup=32367;
             next_sin_lkup=5155;
             next_cos_lkup=32359;
           end
    103  : begin
             curr_sin_lkup=5155;
             curr_cos_lkup=32359;
             next_sin_lkup=5205;
             next_cos_lkup=32351;
           end
    104  : begin
             curr_sin_lkup=5205;
             curr_cos_lkup=32351;
             next_sin_lkup=5255;
             next_cos_lkup=32343;
           end
    105  : begin
             curr_sin_lkup=5255;
             curr_cos_lkup=32343;
             next_sin_lkup=5304;
             next_cos_lkup=32335;
           end
    106  : begin
             curr_sin_lkup=5304;
             curr_cos_lkup=32335;
             next_sin_lkup=5354;
             next_cos_lkup=32327;
           end
    107  : begin
             curr_sin_lkup=5354;
             curr_cos_lkup=32327;
             next_sin_lkup=5403;
             next_cos_lkup=32319;
           end
    108  : begin
             curr_sin_lkup=5403;
             curr_cos_lkup=32319;
             next_sin_lkup=5453;
             next_cos_lkup=32311;
           end
    109  : begin
             curr_sin_lkup=5453;
             curr_cos_lkup=32311;
             next_sin_lkup=5503;
             next_cos_lkup=32302;
           end
    110  : begin
             curr_sin_lkup=5503;
             curr_cos_lkup=32302;
             next_sin_lkup=5552;
             next_cos_lkup=32294;
           end
    111  : begin
             curr_sin_lkup=5552;
             curr_cos_lkup=32294;
             next_sin_lkup=5602;
             next_cos_lkup=32285;
           end
    112  : begin
             curr_sin_lkup=5602;
             curr_cos_lkup=32285;
             next_sin_lkup=5651;
             next_cos_lkup=32276;
           end
    113  : begin
             curr_sin_lkup=5651;
             curr_cos_lkup=32276;
             next_sin_lkup=5701;
             next_cos_lkup=32268;
           end
    114  : begin
             curr_sin_lkup=5701;
             curr_cos_lkup=32268;
             next_sin_lkup=5750;
             next_cos_lkup=32259;
           end
    115  : begin
             curr_sin_lkup=5750;
             curr_cos_lkup=32259;
             next_sin_lkup=5800;
             next_cos_lkup=32250;
           end
    116  : begin
             curr_sin_lkup=5800;
             curr_cos_lkup=32250;
             next_sin_lkup=5849;
             next_cos_lkup=32241;
           end
    117  : begin
             curr_sin_lkup=5849;
             curr_cos_lkup=32241;
             next_sin_lkup=5898;
             next_cos_lkup=32232;
           end
    118  : begin
             curr_sin_lkup=5898;
             curr_cos_lkup=32232;
             next_sin_lkup=5948;
             next_cos_lkup=32223;
           end
    119  : begin
             curr_sin_lkup=5948;
             curr_cos_lkup=32223;
             next_sin_lkup=5997;
             next_cos_lkup=32214;
           end
    120  : begin
             curr_sin_lkup=5997;
             curr_cos_lkup=32214;
             next_sin_lkup=6047;
             next_cos_lkup=32205;
           end
    121  : begin
             curr_sin_lkup=6047;
             curr_cos_lkup=32205;
             next_sin_lkup=6096;
             next_cos_lkup=32195;
           end
    122  : begin
             curr_sin_lkup=6096;
             curr_cos_lkup=32195;
             next_sin_lkup=6146;
             next_cos_lkup=32186;
           end
    123  : begin
             curr_sin_lkup=6146;
             curr_cos_lkup=32186;
             next_sin_lkup=6195;
             next_cos_lkup=32176;
           end
    124  : begin
             curr_sin_lkup=6195;
             curr_cos_lkup=32176;
             next_sin_lkup=6244;
             next_cos_lkup=32167;
           end
    125  : begin
             curr_sin_lkup=6244;
             curr_cos_lkup=32167;
             next_sin_lkup=6294;
             next_cos_lkup=32157;
           end
    126  : begin
             curr_sin_lkup=6294;
             curr_cos_lkup=32157;
             next_sin_lkup=6343;
             next_cos_lkup=32148;
           end
    127  : begin
             curr_sin_lkup=6343;
             curr_cos_lkup=32148;
             next_sin_lkup=6392;
             next_cos_lkup=32138;
           end
    128  : begin
             curr_sin_lkup=6392;
             curr_cos_lkup=32138;
             next_sin_lkup=6442;
             next_cos_lkup=32128;
           end
    129  : begin
             curr_sin_lkup=6442;
             curr_cos_lkup=32128;
             next_sin_lkup=6491;
             next_cos_lkup=32118;
           end
    130  : begin
             curr_sin_lkup=6491;
             curr_cos_lkup=32118;
             next_sin_lkup=6540;
             next_cos_lkup=32108;
           end
    131  : begin
             curr_sin_lkup=6540;
             curr_cos_lkup=32108;
             next_sin_lkup=6589;
             next_cos_lkup=32098;
           end
    132  : begin
             curr_sin_lkup=6589;
             curr_cos_lkup=32098;
             next_sin_lkup=6639;
             next_cos_lkup=32088;
           end
    133  : begin
             curr_sin_lkup=6639;
             curr_cos_lkup=32088;
             next_sin_lkup=6688;
             next_cos_lkup=32078;
           end
    134  : begin
             curr_sin_lkup=6688;
             curr_cos_lkup=32078;
             next_sin_lkup=6737;
             next_cos_lkup=32067;
           end
    135  : begin
             curr_sin_lkup=6737;
             curr_cos_lkup=32067;
             next_sin_lkup=6786;
             next_cos_lkup=32057;
           end
    136  : begin
             curr_sin_lkup=6786;
             curr_cos_lkup=32057;
             next_sin_lkup=6835;
             next_cos_lkup=32047;
           end
    137  : begin
             curr_sin_lkup=6835;
             curr_cos_lkup=32047;
             next_sin_lkup=6884;
             next_cos_lkup=32036;
           end
    138  : begin
             curr_sin_lkup=6884;
             curr_cos_lkup=32036;
             next_sin_lkup=6934;
             next_cos_lkup=32025;
           end
    139  : begin
             curr_sin_lkup=6934;
             curr_cos_lkup=32025;
             next_sin_lkup=6983;
             next_cos_lkup=32015;
           end
    140  : begin
             curr_sin_lkup=6983;
             curr_cos_lkup=32015;
             next_sin_lkup=7032;
             next_cos_lkup=32004;
           end
    141  : begin
             curr_sin_lkup=7032;
             curr_cos_lkup=32004;
             next_sin_lkup=7081;
             next_cos_lkup=31993;
           end
    142  : begin
             curr_sin_lkup=7081;
             curr_cos_lkup=31993;
             next_sin_lkup=7130;
             next_cos_lkup=31982;
           end
    143  : begin
             curr_sin_lkup=7130;
             curr_cos_lkup=31982;
             next_sin_lkup=7179;
             next_cos_lkup=31971;
           end
    144  : begin
             curr_sin_lkup=7179;
             curr_cos_lkup=31971;
             next_sin_lkup=7228;
             next_cos_lkup=31960;
           end
    145  : begin
             curr_sin_lkup=7228;
             curr_cos_lkup=31960;
             next_sin_lkup=7277;
             next_cos_lkup=31949;
           end
    146  : begin
             curr_sin_lkup=7277;
             curr_cos_lkup=31949;
             next_sin_lkup=7326;
             next_cos_lkup=31938;
           end
    147  : begin
             curr_sin_lkup=7326;
             curr_cos_lkup=31938;
             next_sin_lkup=7375;
             next_cos_lkup=31927;
           end
    148  : begin
             curr_sin_lkup=7375;
             curr_cos_lkup=31927;
             next_sin_lkup=7424;
             next_cos_lkup=31915;
           end
    149  : begin
             curr_sin_lkup=7424;
             curr_cos_lkup=31915;
             next_sin_lkup=7473;
             next_cos_lkup=31904;
           end
    150  : begin
             curr_sin_lkup=7473;
             curr_cos_lkup=31904;
             next_sin_lkup=7522;
             next_cos_lkup=31892;
           end
    151  : begin
             curr_sin_lkup=7522;
             curr_cos_lkup=31892;
             next_sin_lkup=7571;
             next_cos_lkup=31881;
           end
    152  : begin
             curr_sin_lkup=7571;
             curr_cos_lkup=31881;
             next_sin_lkup=7620;
             next_cos_lkup=31869;
           end
    153  : begin
             curr_sin_lkup=7620;
             curr_cos_lkup=31869;
             next_sin_lkup=7669;
             next_cos_lkup=31857;
           end
    154  : begin
             curr_sin_lkup=7669;
             curr_cos_lkup=31857;
             next_sin_lkup=7717;
             next_cos_lkup=31846;
           end
    155  : begin
             curr_sin_lkup=7717;
             curr_cos_lkup=31846;
             next_sin_lkup=7766;
             next_cos_lkup=31834;
           end
    156  : begin
             curr_sin_lkup=7766;
             curr_cos_lkup=31834;
             next_sin_lkup=7815;
             next_cos_lkup=31822;
           end
    157  : begin
             curr_sin_lkup=7815;
             curr_cos_lkup=31822;
             next_sin_lkup=7864;
             next_cos_lkup=31810;
           end
    158  : begin
             curr_sin_lkup=7864;
             curr_cos_lkup=31810;
             next_sin_lkup=7913;
             next_cos_lkup=31798;
           end
    159  : begin
             curr_sin_lkup=7913;
             curr_cos_lkup=31798;
             next_sin_lkup=7961;
             next_cos_lkup=31785;
           end
    160  : begin
             curr_sin_lkup=7961;
             curr_cos_lkup=31785;
             next_sin_lkup=8010;
             next_cos_lkup=31773;
           end
    161  : begin
             curr_sin_lkup=8010;
             curr_cos_lkup=31773;
             next_sin_lkup=8059;
             next_cos_lkup=31761;
           end
    162  : begin
             curr_sin_lkup=8059;
             curr_cos_lkup=31761;
             next_sin_lkup=8108;
             next_cos_lkup=31749;
           end
    163  : begin
             curr_sin_lkup=8108;
             curr_cos_lkup=31749;
             next_sin_lkup=8156;
             next_cos_lkup=31736;
           end
    164  : begin
             curr_sin_lkup=8156;
             curr_cos_lkup=31736;
             next_sin_lkup=8205;
             next_cos_lkup=31723;
           end
    165  : begin
             curr_sin_lkup=8205;
             curr_cos_lkup=31723;
             next_sin_lkup=8254;
             next_cos_lkup=31711;
           end
    166  : begin
             curr_sin_lkup=8254;
             curr_cos_lkup=31711;
             next_sin_lkup=8302;
             next_cos_lkup=31698;
           end
    167  : begin
             curr_sin_lkup=8302;
             curr_cos_lkup=31698;
             next_sin_lkup=8351;
             next_cos_lkup=31685;
           end
    168  : begin
             curr_sin_lkup=8351;
             curr_cos_lkup=31685;
             next_sin_lkup=8400;
             next_cos_lkup=31673;
           end
    169  : begin
             curr_sin_lkup=8400;
             curr_cos_lkup=31673;
             next_sin_lkup=8448;
             next_cos_lkup=31660;
           end
    170  : begin
             curr_sin_lkup=8448;
             curr_cos_lkup=31660;
             next_sin_lkup=8497;
             next_cos_lkup=31647;
           end
    171  : begin
             curr_sin_lkup=8497;
             curr_cos_lkup=31647;
             next_sin_lkup=8545;
             next_cos_lkup=31634;
           end
    172  : begin
             curr_sin_lkup=8545;
             curr_cos_lkup=31634;
             next_sin_lkup=8594;
             next_cos_lkup=31620;
           end
    173  : begin
             curr_sin_lkup=8594;
             curr_cos_lkup=31620;
             next_sin_lkup=8642;
             next_cos_lkup=31607;
           end
    174  : begin
             curr_sin_lkup=8642;
             curr_cos_lkup=31607;
             next_sin_lkup=8691;
             next_cos_lkup=31594;
           end
    175  : begin
             curr_sin_lkup=8691;
             curr_cos_lkup=31594;
             next_sin_lkup=8739;
             next_cos_lkup=31581;
           end
    176  : begin
             curr_sin_lkup=8739;
             curr_cos_lkup=31581;
             next_sin_lkup=8788;
             next_cos_lkup=31567;
           end
    177  : begin
             curr_sin_lkup=8788;
             curr_cos_lkup=31567;
             next_sin_lkup=8836;
             next_cos_lkup=31554;
           end
    178  : begin
             curr_sin_lkup=8836;
             curr_cos_lkup=31554;
             next_sin_lkup=8884;
             next_cos_lkup=31540;
           end
    179  : begin
             curr_sin_lkup=8884;
             curr_cos_lkup=31540;
             next_sin_lkup=8933;
             next_cos_lkup=31526;
           end
    180  : begin
             curr_sin_lkup=8933;
             curr_cos_lkup=31526;
             next_sin_lkup=8981;
             next_cos_lkup=31513;
           end
    181  : begin
             curr_sin_lkup=8981;
             curr_cos_lkup=31513;
             next_sin_lkup=9029;
             next_cos_lkup=31499;
           end
    182  : begin
             curr_sin_lkup=9029;
             curr_cos_lkup=31499;
             next_sin_lkup=9078;
             next_cos_lkup=31485;
           end
    183  : begin
             curr_sin_lkup=9078;
             curr_cos_lkup=31485;
             next_sin_lkup=9126;
             next_cos_lkup=31471;
           end
    184  : begin
             curr_sin_lkup=9126;
             curr_cos_lkup=31471;
             next_sin_lkup=9174;
             next_cos_lkup=31457;
           end
    185  : begin
             curr_sin_lkup=9174;
             curr_cos_lkup=31457;
             next_sin_lkup=9223;
             next_cos_lkup=31443;
           end
    186  : begin
             curr_sin_lkup=9223;
             curr_cos_lkup=31443;
             next_sin_lkup=9271;
             next_cos_lkup=31429;
           end
    187  : begin
             curr_sin_lkup=9271;
             curr_cos_lkup=31429;
             next_sin_lkup=9319;
             next_cos_lkup=31414;
           end
    188  : begin
             curr_sin_lkup=9319;
             curr_cos_lkup=31414;
             next_sin_lkup=9367;
             next_cos_lkup=31400;
           end
    189  : begin
             curr_sin_lkup=9367;
             curr_cos_lkup=31400;
             next_sin_lkup=9415;
             next_cos_lkup=31386;
           end
    190  : begin
             curr_sin_lkup=9415;
             curr_cos_lkup=31386;
             next_sin_lkup=9463;
             next_cos_lkup=31371;
           end
    191  : begin
             curr_sin_lkup=9463;
             curr_cos_lkup=31371;
             next_sin_lkup=9512;
             next_cos_lkup=31357;
           end
    192  : begin
             curr_sin_lkup=9512;
             curr_cos_lkup=31357;
             next_sin_lkup=9560;
             next_cos_lkup=31342;
           end
    193  : begin
             curr_sin_lkup=9560;
             curr_cos_lkup=31342;
             next_sin_lkup=9608;
             next_cos_lkup=31327;
           end
    194  : begin
             curr_sin_lkup=9608;
             curr_cos_lkup=31327;
             next_sin_lkup=9656;
             next_cos_lkup=31312;
           end
    195  : begin
             curr_sin_lkup=9656;
             curr_cos_lkup=31312;
             next_sin_lkup=9704;
             next_cos_lkup=31298;
           end
    196  : begin
             curr_sin_lkup=9704;
             curr_cos_lkup=31298;
             next_sin_lkup=9752;
             next_cos_lkup=31283;
           end
    197  : begin
             curr_sin_lkup=9752;
             curr_cos_lkup=31283;
             next_sin_lkup=9800;
             next_cos_lkup=31268;
           end
    198  : begin
             curr_sin_lkup=9800;
             curr_cos_lkup=31268;
             next_sin_lkup=9848;
             next_cos_lkup=31253;
           end
    199  : begin
             curr_sin_lkup=9848;
             curr_cos_lkup=31253;
             next_sin_lkup=9896;
             next_cos_lkup=31237;
           end
    200  : begin
             curr_sin_lkup=9896;
             curr_cos_lkup=31237;
             next_sin_lkup=9944;
             next_cos_lkup=31222;
           end
    201  : begin
             curr_sin_lkup=9944;
             curr_cos_lkup=31222;
             next_sin_lkup=9991;
             next_cos_lkup=31207;
           end
    202  : begin
             curr_sin_lkup=9991;
             curr_cos_lkup=31207;
             next_sin_lkup=10039;
             next_cos_lkup=31192;
           end
    203  : begin
             curr_sin_lkup=10039;
             curr_cos_lkup=31192;
             next_sin_lkup=10087;
             next_cos_lkup=31176;
           end
    204  : begin
             curr_sin_lkup=10087;
             curr_cos_lkup=31176;
             next_sin_lkup=10135;
             next_cos_lkup=31161;
           end
    205  : begin
             curr_sin_lkup=10135;
             curr_cos_lkup=31161;
             next_sin_lkup=10183;
             next_cos_lkup=31145;
           end
    206  : begin
             curr_sin_lkup=10183;
             curr_cos_lkup=31145;
             next_sin_lkup=10230;
             next_cos_lkup=31129;
           end
    207  : begin
             curr_sin_lkup=10230;
             curr_cos_lkup=31129;
             next_sin_lkup=10278;
             next_cos_lkup=31114;
           end
    208  : begin
             curr_sin_lkup=10278;
             curr_cos_lkup=31114;
             next_sin_lkup=10326;
             next_cos_lkup=31098;
           end
    209  : begin
             curr_sin_lkup=10326;
             curr_cos_lkup=31098;
             next_sin_lkup=10374;
             next_cos_lkup=31082;
           end
    210  : begin
             curr_sin_lkup=10374;
             curr_cos_lkup=31082;
             next_sin_lkup=10421;
             next_cos_lkup=31066;
           end
    211  : begin
             curr_sin_lkup=10421;
             curr_cos_lkup=31066;
             next_sin_lkup=10469;
             next_cos_lkup=31050;
           end
    212  : begin
             curr_sin_lkup=10469;
             curr_cos_lkup=31050;
             next_sin_lkup=10517;
             next_cos_lkup=31034;
           end
    213  : begin
             curr_sin_lkup=10517;
             curr_cos_lkup=31034;
             next_sin_lkup=10564;
             next_cos_lkup=31018;
           end
    214  : begin
             curr_sin_lkup=10564;
             curr_cos_lkup=31018;
             next_sin_lkup=10612;
             next_cos_lkup=31001;
           end
    215  : begin
             curr_sin_lkup=10612;
             curr_cos_lkup=31001;
             next_sin_lkup=10659;
             next_cos_lkup=30985;
           end
    216  : begin
             curr_sin_lkup=10659;
             curr_cos_lkup=30985;
             next_sin_lkup=10707;
             next_cos_lkup=30969;
           end
    217  : begin
             curr_sin_lkup=10707;
             curr_cos_lkup=30969;
             next_sin_lkup=10754;
             next_cos_lkup=30952;
           end
    218  : begin
             curr_sin_lkup=10754;
             curr_cos_lkup=30952;
             next_sin_lkup=10802;
             next_cos_lkup=30936;
           end
    219  : begin
             curr_sin_lkup=10802;
             curr_cos_lkup=30936;
             next_sin_lkup=10849;
             next_cos_lkup=30919;
           end
    220  : begin
             curr_sin_lkup=10849;
             curr_cos_lkup=30919;
             next_sin_lkup=10897;
             next_cos_lkup=30902;
           end
    221  : begin
             curr_sin_lkup=10897;
             curr_cos_lkup=30902;
             next_sin_lkup=10944;
             next_cos_lkup=30886;
           end
    222  : begin
             curr_sin_lkup=10944;
             curr_cos_lkup=30886;
             next_sin_lkup=10991;
             next_cos_lkup=30869;
           end
    223  : begin
             curr_sin_lkup=10991;
             curr_cos_lkup=30869;
             next_sin_lkup=11039;
             next_cos_lkup=30852;
           end
    224  : begin
             curr_sin_lkup=11039;
             curr_cos_lkup=30852;
             next_sin_lkup=11086;
             next_cos_lkup=30835;
           end
    225  : begin
             curr_sin_lkup=11086;
             curr_cos_lkup=30835;
             next_sin_lkup=11133;
             next_cos_lkup=30818;
           end
    226  : begin
             curr_sin_lkup=11133;
             curr_cos_lkup=30818;
             next_sin_lkup=11181;
             next_cos_lkup=30801;
           end
    227  : begin
             curr_sin_lkup=11181;
             curr_cos_lkup=30801;
             next_sin_lkup=11228;
             next_cos_lkup=30784;
           end
    228  : begin
             curr_sin_lkup=11228;
             curr_cos_lkup=30784;
             next_sin_lkup=11275;
             next_cos_lkup=30766;
           end
    229  : begin
             curr_sin_lkup=11275;
             curr_cos_lkup=30766;
             next_sin_lkup=11322;
             next_cos_lkup=30749;
           end
    230  : begin
             curr_sin_lkup=11322;
             curr_cos_lkup=30749;
             next_sin_lkup=11369;
             next_cos_lkup=30732;
           end
    231  : begin
             curr_sin_lkup=11369;
             curr_cos_lkup=30732;
             next_sin_lkup=11416;
             next_cos_lkup=30714;
           end
    232  : begin
             curr_sin_lkup=11416;
             curr_cos_lkup=30714;
             next_sin_lkup=11464;
             next_cos_lkup=30697;
           end
    233  : begin
             curr_sin_lkup=11464;
             curr_cos_lkup=30697;
             next_sin_lkup=11511;
             next_cos_lkup=30679;
           end
    234  : begin
             curr_sin_lkup=11511;
             curr_cos_lkup=30679;
             next_sin_lkup=11558;
             next_cos_lkup=30661;
           end
    235  : begin
             curr_sin_lkup=11558;
             curr_cos_lkup=30661;
             next_sin_lkup=11605;
             next_cos_lkup=30644;
           end
    236  : begin
             curr_sin_lkup=11605;
             curr_cos_lkup=30644;
             next_sin_lkup=11652;
             next_cos_lkup=30626;
           end
    237  : begin
             curr_sin_lkup=11652;
             curr_cos_lkup=30626;
             next_sin_lkup=11699;
             next_cos_lkup=30608;
           end
    238  : begin
             curr_sin_lkup=11699;
             curr_cos_lkup=30608;
             next_sin_lkup=11746;
             next_cos_lkup=30590;
           end
    239  : begin
             curr_sin_lkup=11746;
             curr_cos_lkup=30590;
             next_sin_lkup=11793;
             next_cos_lkup=30572;
           end
    240  : begin
             curr_sin_lkup=11793;
             curr_cos_lkup=30572;
             next_sin_lkup=11839;
             next_cos_lkup=30554;
           end
    241  : begin
             curr_sin_lkup=11839;
             curr_cos_lkup=30554;
             next_sin_lkup=11886;
             next_cos_lkup=30535;
           end
    242  : begin
             curr_sin_lkup=11886;
             curr_cos_lkup=30535;
             next_sin_lkup=11933;
             next_cos_lkup=30517;
           end
    243  : begin
             curr_sin_lkup=11933;
             curr_cos_lkup=30517;
             next_sin_lkup=11980;
             next_cos_lkup=30499;
           end
    244  : begin
             curr_sin_lkup=11980;
             curr_cos_lkup=30499;
             next_sin_lkup=12027;
             next_cos_lkup=30480;
           end
    245  : begin
             curr_sin_lkup=12027;
             curr_cos_lkup=30480;
             next_sin_lkup=12073;
             next_cos_lkup=30462;
           end
    246  : begin
             curr_sin_lkup=12073;
             curr_cos_lkup=30462;
             next_sin_lkup=12120;
             next_cos_lkup=30443;
           end
    247  : begin
             curr_sin_lkup=12120;
             curr_cos_lkup=30443;
             next_sin_lkup=12167;
             next_cos_lkup=30425;
           end
    248  : begin
             curr_sin_lkup=12167;
             curr_cos_lkup=30425;
             next_sin_lkup=12213;
             next_cos_lkup=30406;
           end
    249  : begin
             curr_sin_lkup=12213;
             curr_cos_lkup=30406;
             next_sin_lkup=12260;
             next_cos_lkup=30387;
           end
    250  : begin
             curr_sin_lkup=12260;
             curr_cos_lkup=30387;
             next_sin_lkup=12307;
             next_cos_lkup=30368;
           end
    251  : begin
             curr_sin_lkup=12307;
             curr_cos_lkup=30368;
             next_sin_lkup=12353;
             next_cos_lkup=30350;
           end
    252  : begin
             curr_sin_lkup=12353;
             curr_cos_lkup=30350;
             next_sin_lkup=12400;
             next_cos_lkup=30331;
           end
    253  : begin
             curr_sin_lkup=12400;
             curr_cos_lkup=30331;
             next_sin_lkup=12446;
             next_cos_lkup=30312;
           end
    254  : begin
             curr_sin_lkup=12446;
             curr_cos_lkup=30312;
             next_sin_lkup=12493;
             next_cos_lkup=30292;
           end
    255  : begin
             curr_sin_lkup=12493;
             curr_cos_lkup=30292;
             next_sin_lkup=12539;
             next_cos_lkup=30273;
           end
    256  : begin
             curr_sin_lkup=12539;
             curr_cos_lkup=30273;
             next_sin_lkup=12586;
             next_cos_lkup=30254;
           end
    257  : begin
             curr_sin_lkup=12586;
             curr_cos_lkup=30254;
             next_sin_lkup=12632;
             next_cos_lkup=30235;
           end
    258  : begin
             curr_sin_lkup=12632;
             curr_cos_lkup=30235;
             next_sin_lkup=12678;
             next_cos_lkup=30215;
           end
    259  : begin
             curr_sin_lkup=12678;
             curr_cos_lkup=30215;
             next_sin_lkup=12725;
             next_cos_lkup=30196;
           end
    260  : begin
             curr_sin_lkup=12725;
             curr_cos_lkup=30196;
             next_sin_lkup=12771;
             next_cos_lkup=30176;
           end
    261  : begin
             curr_sin_lkup=12771;
             curr_cos_lkup=30176;
             next_sin_lkup=12817;
             next_cos_lkup=30156;
           end
    262  : begin
             curr_sin_lkup=12817;
             curr_cos_lkup=30156;
             next_sin_lkup=12864;
             next_cos_lkup=30137;
           end
    263  : begin
             curr_sin_lkup=12864;
             curr_cos_lkup=30137;
             next_sin_lkup=12910;
             next_cos_lkup=30117;
           end
    264  : begin
             curr_sin_lkup=12910;
             curr_cos_lkup=30117;
             next_sin_lkup=12956;
             next_cos_lkup=30097;
           end
    265  : begin
             curr_sin_lkup=12956;
             curr_cos_lkup=30097;
             next_sin_lkup=13002;
             next_cos_lkup=30077;
           end
    266  : begin
             curr_sin_lkup=13002;
             curr_cos_lkup=30077;
             next_sin_lkup=13048;
             next_cos_lkup=30057;
           end
    267  : begin
             curr_sin_lkup=13048;
             curr_cos_lkup=30057;
             next_sin_lkup=13094;
             next_cos_lkup=30037;
           end
    268  : begin
             curr_sin_lkup=13094;
             curr_cos_lkup=30037;
             next_sin_lkup=13140;
             next_cos_lkup=30017;
           end
    269  : begin
             curr_sin_lkup=13140;
             curr_cos_lkup=30017;
             next_sin_lkup=13186;
             next_cos_lkup=29997;
           end
    270  : begin
             curr_sin_lkup=13186;
             curr_cos_lkup=29997;
             next_sin_lkup=13232;
             next_cos_lkup=29977;
           end
    271  : begin
             curr_sin_lkup=13232;
             curr_cos_lkup=29977;
             next_sin_lkup=13278;
             next_cos_lkup=29956;
           end
    272  : begin
             curr_sin_lkup=13278;
             curr_cos_lkup=29956;
             next_sin_lkup=13324;
             next_cos_lkup=29936;
           end
    273  : begin
             curr_sin_lkup=13324;
             curr_cos_lkup=29936;
             next_sin_lkup=13370;
             next_cos_lkup=29915;
           end
    274  : begin
             curr_sin_lkup=13370;
             curr_cos_lkup=29915;
             next_sin_lkup=13416;
             next_cos_lkup=29895;
           end
    275  : begin
             curr_sin_lkup=13416;
             curr_cos_lkup=29895;
             next_sin_lkup=13462;
             next_cos_lkup=29874;
           end
    276  : begin
             curr_sin_lkup=13462;
             curr_cos_lkup=29874;
             next_sin_lkup=13508;
             next_cos_lkup=29854;
           end
    277  : begin
             curr_sin_lkup=13508;
             curr_cos_lkup=29854;
             next_sin_lkup=13554;
             next_cos_lkup=29833;
           end
    278  : begin
             curr_sin_lkup=13554;
             curr_cos_lkup=29833;
             next_sin_lkup=13599;
             next_cos_lkup=29812;
           end
    279  : begin
             curr_sin_lkup=13599;
             curr_cos_lkup=29812;
             next_sin_lkup=13645;
             next_cos_lkup=29791;
           end
    280  : begin
             curr_sin_lkup=13645;
             curr_cos_lkup=29791;
             next_sin_lkup=13691;
             next_cos_lkup=29770;
           end
    281  : begin
             curr_sin_lkup=13691;
             curr_cos_lkup=29770;
             next_sin_lkup=13736;
             next_cos_lkup=29749;
           end
    282  : begin
             curr_sin_lkup=13736;
             curr_cos_lkup=29749;
             next_sin_lkup=13782;
             next_cos_lkup=29728;
           end
    283  : begin
             curr_sin_lkup=13782;
             curr_cos_lkup=29728;
             next_sin_lkup=13828;
             next_cos_lkup=29707;
           end
    284  : begin
             curr_sin_lkup=13828;
             curr_cos_lkup=29707;
             next_sin_lkup=13873;
             next_cos_lkup=29686;
           end
    285  : begin
             curr_sin_lkup=13873;
             curr_cos_lkup=29686;
             next_sin_lkup=13919;
             next_cos_lkup=29664;
           end
    286  : begin
             curr_sin_lkup=13919;
             curr_cos_lkup=29664;
             next_sin_lkup=13964;
             next_cos_lkup=29643;
           end
    287  : begin
             curr_sin_lkup=13964;
             curr_cos_lkup=29643;
             next_sin_lkup=14010;
             next_cos_lkup=29621;
           end
    288  : begin
             curr_sin_lkup=14010;
             curr_cos_lkup=29621;
             next_sin_lkup=14055;
             next_cos_lkup=29600;
           end
    289  : begin
             curr_sin_lkup=14055;
             curr_cos_lkup=29600;
             next_sin_lkup=14100;
             next_cos_lkup=29578;
           end
    290  : begin
             curr_sin_lkup=14100;
             curr_cos_lkup=29578;
             next_sin_lkup=14146;
             next_cos_lkup=29557;
           end
    291  : begin
             curr_sin_lkup=14146;
             curr_cos_lkup=29557;
             next_sin_lkup=14191;
             next_cos_lkup=29535;
           end
    292  : begin
             curr_sin_lkup=14191;
             curr_cos_lkup=29535;
             next_sin_lkup=14236;
             next_cos_lkup=29513;
           end
    293  : begin
             curr_sin_lkup=14236;
             curr_cos_lkup=29513;
             next_sin_lkup=14282;
             next_cos_lkup=29491;
           end
    294  : begin
             curr_sin_lkup=14282;
             curr_cos_lkup=29491;
             next_sin_lkup=14327;
             next_cos_lkup=29469;
           end
    295  : begin
             curr_sin_lkup=14327;
             curr_cos_lkup=29469;
             next_sin_lkup=14372;
             next_cos_lkup=29447;
           end
    296  : begin
             curr_sin_lkup=14372;
             curr_cos_lkup=29447;
             next_sin_lkup=14417;
             next_cos_lkup=29425;
           end
    297  : begin
             curr_sin_lkup=14417;
             curr_cos_lkup=29425;
             next_sin_lkup=14462;
             next_cos_lkup=29403;
           end
    298  : begin
             curr_sin_lkup=14462;
             curr_cos_lkup=29403;
             next_sin_lkup=14507;
             next_cos_lkup=29381;
           end
    299  : begin
             curr_sin_lkup=14507;
             curr_cos_lkup=29381;
             next_sin_lkup=14552;
             next_cos_lkup=29359;
           end
    300  : begin
             curr_sin_lkup=14552;
             curr_cos_lkup=29359;
             next_sin_lkup=14598;
             next_cos_lkup=29336;
           end
    301  : begin
             curr_sin_lkup=14598;
             curr_cos_lkup=29336;
             next_sin_lkup=14642;
             next_cos_lkup=29314;
           end
    302  : begin
             curr_sin_lkup=14642;
             curr_cos_lkup=29314;
             next_sin_lkup=14687;
             next_cos_lkup=29291;
           end
    303  : begin
             curr_sin_lkup=14687;
             curr_cos_lkup=29291;
             next_sin_lkup=14732;
             next_cos_lkup=29269;
           end
    304  : begin
             curr_sin_lkup=14732;
             curr_cos_lkup=29269;
             next_sin_lkup=14777;
             next_cos_lkup=29246;
           end
    305  : begin
             curr_sin_lkup=14777;
             curr_cos_lkup=29246;
             next_sin_lkup=14822;
             next_cos_lkup=29223;
           end
    306  : begin
             curr_sin_lkup=14822;
             curr_cos_lkup=29223;
             next_sin_lkup=14867;
             next_cos_lkup=29201;
           end
    307  : begin
             curr_sin_lkup=14867;
             curr_cos_lkup=29201;
             next_sin_lkup=14912;
             next_cos_lkup=29178;
           end
    308  : begin
             curr_sin_lkup=14912;
             curr_cos_lkup=29178;
             next_sin_lkup=14956;
             next_cos_lkup=29155;
           end
    309  : begin
             curr_sin_lkup=14956;
             curr_cos_lkup=29155;
             next_sin_lkup=15001;
             next_cos_lkup=29132;
           end
    310  : begin
             curr_sin_lkup=15001;
             curr_cos_lkup=29132;
             next_sin_lkup=15046;
             next_cos_lkup=29109;
           end
    311  : begin
             curr_sin_lkup=15046;
             curr_cos_lkup=29109;
             next_sin_lkup=15090;
             next_cos_lkup=29086;
           end
    312  : begin
             curr_sin_lkup=15090;
             curr_cos_lkup=29086;
             next_sin_lkup=15135;
             next_cos_lkup=29062;
           end
    313  : begin
             curr_sin_lkup=15135;
             curr_cos_lkup=29062;
             next_sin_lkup=15180;
             next_cos_lkup=29039;
           end
    314  : begin
             curr_sin_lkup=15180;
             curr_cos_lkup=29039;
             next_sin_lkup=15224;
             next_cos_lkup=29016;
           end
    315  : begin
             curr_sin_lkup=15224;
             curr_cos_lkup=29016;
             next_sin_lkup=15269;
             next_cos_lkup=28993;
           end
    316  : begin
             curr_sin_lkup=15269;
             curr_cos_lkup=28993;
             next_sin_lkup=15313;
             next_cos_lkup=28969;
           end
    317  : begin
             curr_sin_lkup=15313;
             curr_cos_lkup=28969;
             next_sin_lkup=15357;
             next_cos_lkup=28946;
           end
    318  : begin
             curr_sin_lkup=15357;
             curr_cos_lkup=28946;
             next_sin_lkup=15402;
             next_cos_lkup=28922;
           end
    319  : begin
             curr_sin_lkup=15402;
             curr_cos_lkup=28922;
             next_sin_lkup=15446;
             next_cos_lkup=28898;
           end
    320  : begin
             curr_sin_lkup=15446;
             curr_cos_lkup=28898;
             next_sin_lkup=15491;
             next_cos_lkup=28875;
           end
    321  : begin
             curr_sin_lkup=15491;
             curr_cos_lkup=28875;
             next_sin_lkup=15535;
             next_cos_lkup=28851;
           end
    322  : begin
             curr_sin_lkup=15535;
             curr_cos_lkup=28851;
             next_sin_lkup=15579;
             next_cos_lkup=28827;
           end
    323  : begin
             curr_sin_lkup=15579;
             curr_cos_lkup=28827;
             next_sin_lkup=15623;
             next_cos_lkup=28803;
           end
    324  : begin
             curr_sin_lkup=15623;
             curr_cos_lkup=28803;
             next_sin_lkup=15667;
             next_cos_lkup=28779;
           end
    325  : begin
             curr_sin_lkup=15667;
             curr_cos_lkup=28779;
             next_sin_lkup=15712;
             next_cos_lkup=28755;
           end
    326  : begin
             curr_sin_lkup=15712;
             curr_cos_lkup=28755;
             next_sin_lkup=15756;
             next_cos_lkup=28731;
           end
    327  : begin
             curr_sin_lkup=15756;
             curr_cos_lkup=28731;
             next_sin_lkup=15800;
             next_cos_lkup=28707;
           end
    328  : begin
             curr_sin_lkup=15800;
             curr_cos_lkup=28707;
             next_sin_lkup=15844;
             next_cos_lkup=28682;
           end
    329  : begin
             curr_sin_lkup=15844;
             curr_cos_lkup=28682;
             next_sin_lkup=15888;
             next_cos_lkup=28658;
           end
    330  : begin
             curr_sin_lkup=15888;
             curr_cos_lkup=28658;
             next_sin_lkup=15932;
             next_cos_lkup=28634;
           end
    331  : begin
             curr_sin_lkup=15932;
             curr_cos_lkup=28634;
             next_sin_lkup=15976;
             next_cos_lkup=28609;
           end
    332  : begin
             curr_sin_lkup=15976;
             curr_cos_lkup=28609;
             next_sin_lkup=16019;
             next_cos_lkup=28585;
           end
    333  : begin
             curr_sin_lkup=16019;
             curr_cos_lkup=28585;
             next_sin_lkup=16063;
             next_cos_lkup=28560;
           end
    334  : begin
             curr_sin_lkup=16063;
             curr_cos_lkup=28560;
             next_sin_lkup=16107;
             next_cos_lkup=28535;
           end
    335  : begin
             curr_sin_lkup=16107;
             curr_cos_lkup=28535;
             next_sin_lkup=16151;
             next_cos_lkup=28511;
           end
    336  : begin
             curr_sin_lkup=16151;
             curr_cos_lkup=28511;
             next_sin_lkup=16195;
             next_cos_lkup=28486;
           end
    337  : begin
             curr_sin_lkup=16195;
             curr_cos_lkup=28486;
             next_sin_lkup=16238;
             next_cos_lkup=28461;
           end
    338  : begin
             curr_sin_lkup=16238;
             curr_cos_lkup=28461;
             next_sin_lkup=16282;
             next_cos_lkup=28436;
           end
    339  : begin
             curr_sin_lkup=16282;
             curr_cos_lkup=28436;
             next_sin_lkup=16325;
             next_cos_lkup=28411;
           end
    340  : begin
             curr_sin_lkup=16325;
             curr_cos_lkup=28411;
             next_sin_lkup=16369;
             next_cos_lkup=28386;
           end
    341  : begin
             curr_sin_lkup=16369;
             curr_cos_lkup=28386;
             next_sin_lkup=16413;
             next_cos_lkup=28361;
           end
    342  : begin
             curr_sin_lkup=16413;
             curr_cos_lkup=28361;
             next_sin_lkup=16456;
             next_cos_lkup=28335;
           end
    343  : begin
             curr_sin_lkup=16456;
             curr_cos_lkup=28335;
             next_sin_lkup=16499;
             next_cos_lkup=28310;
           end
    344  : begin
             curr_sin_lkup=16499;
             curr_cos_lkup=28310;
             next_sin_lkup=16543;
             next_cos_lkup=28285;
           end
    345  : begin
             curr_sin_lkup=16543;
             curr_cos_lkup=28285;
             next_sin_lkup=16586;
             next_cos_lkup=28259;
           end
    346  : begin
             curr_sin_lkup=16586;
             curr_cos_lkup=28259;
             next_sin_lkup=16630;
             next_cos_lkup=28234;
           end
    347  : begin
             curr_sin_lkup=16630;
             curr_cos_lkup=28234;
             next_sin_lkup=16673;
             next_cos_lkup=28208;
           end
    348  : begin
             curr_sin_lkup=16673;
             curr_cos_lkup=28208;
             next_sin_lkup=16716;
             next_cos_lkup=28183;
           end
    349  : begin
             curr_sin_lkup=16716;
             curr_cos_lkup=28183;
             next_sin_lkup=16759;
             next_cos_lkup=28157;
           end
    350  : begin
             curr_sin_lkup=16759;
             curr_cos_lkup=28157;
             next_sin_lkup=16802;
             next_cos_lkup=28131;
           end
    351  : begin
             curr_sin_lkup=16802;
             curr_cos_lkup=28131;
             next_sin_lkup=16846;
             next_cos_lkup=28106;
           end
    352  : begin
             curr_sin_lkup=16846;
             curr_cos_lkup=28106;
             next_sin_lkup=16889;
             next_cos_lkup=28080;
           end
    353  : begin
             curr_sin_lkup=16889;
             curr_cos_lkup=28080;
             next_sin_lkup=16932;
             next_cos_lkup=28054;
           end
    354  : begin
             curr_sin_lkup=16932;
             curr_cos_lkup=28054;
             next_sin_lkup=16975;
             next_cos_lkup=28028;
           end
    355  : begin
             curr_sin_lkup=16975;
             curr_cos_lkup=28028;
             next_sin_lkup=17018;
             next_cos_lkup=28002;
           end
    356  : begin
             curr_sin_lkup=17018;
             curr_cos_lkup=28002;
             next_sin_lkup=17061;
             next_cos_lkup=27976;
           end
    357  : begin
             curr_sin_lkup=17061;
             curr_cos_lkup=27976;
             next_sin_lkup=17104;
             next_cos_lkup=27949;
           end
    358  : begin
             curr_sin_lkup=17104;
             curr_cos_lkup=27949;
             next_sin_lkup=17146;
             next_cos_lkup=27923;
           end
    359  : begin
             curr_sin_lkup=17146;
             curr_cos_lkup=27923;
             next_sin_lkup=17189;
             next_cos_lkup=27897;
           end
    360  : begin
             curr_sin_lkup=17189;
             curr_cos_lkup=27897;
             next_sin_lkup=17232;
             next_cos_lkup=27870;
           end
    361  : begin
             curr_sin_lkup=17232;
             curr_cos_lkup=27870;
             next_sin_lkup=17275;
             next_cos_lkup=27844;
           end
    362  : begin
             curr_sin_lkup=17275;
             curr_cos_lkup=27844;
             next_sin_lkup=17317;
             next_cos_lkup=27817;
           end
    363  : begin
             curr_sin_lkup=17317;
             curr_cos_lkup=27817;
             next_sin_lkup=17360;
             next_cos_lkup=27791;
           end
    364  : begin
             curr_sin_lkup=17360;
             curr_cos_lkup=27791;
             next_sin_lkup=17403;
             next_cos_lkup=27764;
           end
    365  : begin
             curr_sin_lkup=17403;
             curr_cos_lkup=27764;
             next_sin_lkup=17445;
             next_cos_lkup=27737;
           end
    366  : begin
             curr_sin_lkup=17445;
             curr_cos_lkup=27737;
             next_sin_lkup=17488;
             next_cos_lkup=27711;
           end
    367  : begin
             curr_sin_lkup=17488;
             curr_cos_lkup=27711;
             next_sin_lkup=17530;
             next_cos_lkup=27684;
           end
    368  : begin
             curr_sin_lkup=17530;
             curr_cos_lkup=27684;
             next_sin_lkup=17573;
             next_cos_lkup=27657;
           end
    369  : begin
             curr_sin_lkup=17573;
             curr_cos_lkup=27657;
             next_sin_lkup=17615;
             next_cos_lkup=27630;
           end
    370  : begin
             curr_sin_lkup=17615;
             curr_cos_lkup=27630;
             next_sin_lkup=17658;
             next_cos_lkup=27603;
           end
    371  : begin
             curr_sin_lkup=17658;
             curr_cos_lkup=27603;
             next_sin_lkup=17700;
             next_cos_lkup=27576;
           end
    372  : begin
             curr_sin_lkup=17700;
             curr_cos_lkup=27576;
             next_sin_lkup=17742;
             next_cos_lkup=27548;
           end
    373  : begin
             curr_sin_lkup=17742;
             curr_cos_lkup=27548;
             next_sin_lkup=17784;
             next_cos_lkup=27521;
           end
    374  : begin
             curr_sin_lkup=17784;
             curr_cos_lkup=27521;
             next_sin_lkup=17827;
             next_cos_lkup=27494;
           end
    375  : begin
             curr_sin_lkup=17827;
             curr_cos_lkup=27494;
             next_sin_lkup=17869;
             next_cos_lkup=27466;
           end
    376  : begin
             curr_sin_lkup=17869;
             curr_cos_lkup=27466;
             next_sin_lkup=17911;
             next_cos_lkup=27439;
           end
    377  : begin
             curr_sin_lkup=17911;
             curr_cos_lkup=27439;
             next_sin_lkup=17953;
             next_cos_lkup=27411;
           end
    378  : begin
             curr_sin_lkup=17953;
             curr_cos_lkup=27411;
             next_sin_lkup=17995;
             next_cos_lkup=27384;
           end
    379  : begin
             curr_sin_lkup=17995;
             curr_cos_lkup=27384;
             next_sin_lkup=18037;
             next_cos_lkup=27356;
           end
    380  : begin
             curr_sin_lkup=18037;
             curr_cos_lkup=27356;
             next_sin_lkup=18079;
             next_cos_lkup=27329;
           end
    381  : begin
             curr_sin_lkup=18079;
             curr_cos_lkup=27329;
             next_sin_lkup=18121;
             next_cos_lkup=27301;
           end
    382  : begin
             curr_sin_lkup=18121;
             curr_cos_lkup=27301;
             next_sin_lkup=18163;
             next_cos_lkup=27273;
           end
    383  : begin
             curr_sin_lkup=18163;
             curr_cos_lkup=27273;
             next_sin_lkup=18204;
             next_cos_lkup=27245;
           end
    384  : begin
             curr_sin_lkup=18204;
             curr_cos_lkup=27245;
             next_sin_lkup=18246;
             next_cos_lkup=27217;
           end
    385  : begin
             curr_sin_lkup=18246;
             curr_cos_lkup=27217;
             next_sin_lkup=18288;
             next_cos_lkup=27189;
           end
    386  : begin
             curr_sin_lkup=18288;
             curr_cos_lkup=27189;
             next_sin_lkup=18330;
             next_cos_lkup=27161;
           end
    387  : begin
             curr_sin_lkup=18330;
             curr_cos_lkup=27161;
             next_sin_lkup=18371;
             next_cos_lkup=27133;
           end
    388  : begin
             curr_sin_lkup=18371;
             curr_cos_lkup=27133;
             next_sin_lkup=18413;
             next_cos_lkup=27105;
           end
    389  : begin
             curr_sin_lkup=18413;
             curr_cos_lkup=27105;
             next_sin_lkup=18454;
             next_cos_lkup=27076;
           end
    390  : begin
             curr_sin_lkup=18454;
             curr_cos_lkup=27076;
             next_sin_lkup=18496;
             next_cos_lkup=27048;
           end
    391  : begin
             curr_sin_lkup=18496;
             curr_cos_lkup=27048;
             next_sin_lkup=18537;
             next_cos_lkup=27020;
           end
    392  : begin
             curr_sin_lkup=18537;
             curr_cos_lkup=27020;
             next_sin_lkup=18579;
             next_cos_lkup=26991;
           end
    393  : begin
             curr_sin_lkup=18579;
             curr_cos_lkup=26991;
             next_sin_lkup=18620;
             next_cos_lkup=26963;
           end
    394  : begin
             curr_sin_lkup=18620;
             curr_cos_lkup=26963;
             next_sin_lkup=18662;
             next_cos_lkup=26934;
           end
    395  : begin
             curr_sin_lkup=18662;
             curr_cos_lkup=26934;
             next_sin_lkup=18703;
             next_cos_lkup=26905;
           end
    396  : begin
             curr_sin_lkup=18703;
             curr_cos_lkup=26905;
             next_sin_lkup=18744;
             next_cos_lkup=26877;
           end
    397  : begin
             curr_sin_lkup=18744;
             curr_cos_lkup=26877;
             next_sin_lkup=18785;
             next_cos_lkup=26848;
           end
    398  : begin
             curr_sin_lkup=18785;
             curr_cos_lkup=26848;
             next_sin_lkup=18826;
             next_cos_lkup=26819;
           end
    399  : begin
             curr_sin_lkup=18826;
             curr_cos_lkup=26819;
             next_sin_lkup=18868;
             next_cos_lkup=26790;
           end
    400  : begin
             curr_sin_lkup=18868;
             curr_cos_lkup=26790;
             next_sin_lkup=18909;
             next_cos_lkup=26761;
           end
    401  : begin
             curr_sin_lkup=18909;
             curr_cos_lkup=26761;
             next_sin_lkup=18950;
             next_cos_lkup=26732;
           end
    402  : begin
             curr_sin_lkup=18950;
             curr_cos_lkup=26732;
             next_sin_lkup=18991;
             next_cos_lkup=26703;
           end
    403  : begin
             curr_sin_lkup=18991;
             curr_cos_lkup=26703;
             next_sin_lkup=19032;
             next_cos_lkup=26674;
           end
    404  : begin
             curr_sin_lkup=19032;
             curr_cos_lkup=26674;
             next_sin_lkup=19073;
             next_cos_lkup=26645;
           end
    405  : begin
             curr_sin_lkup=19073;
             curr_cos_lkup=26645;
             next_sin_lkup=19113;
             next_cos_lkup=26615;
           end
    406  : begin
             curr_sin_lkup=19113;
             curr_cos_lkup=26615;
             next_sin_lkup=19154;
             next_cos_lkup=26586;
           end
    407  : begin
             curr_sin_lkup=19154;
             curr_cos_lkup=26586;
             next_sin_lkup=19195;
             next_cos_lkup=26557;
           end
    408  : begin
             curr_sin_lkup=19195;
             curr_cos_lkup=26557;
             next_sin_lkup=19236;
             next_cos_lkup=26527;
           end
    409  : begin
             curr_sin_lkup=19236;
             curr_cos_lkup=26527;
             next_sin_lkup=19276;
             next_cos_lkup=26498;
           end
    410  : begin
             curr_sin_lkup=19276;
             curr_cos_lkup=26498;
             next_sin_lkup=19317;
             next_cos_lkup=26468;
           end
    411  : begin
             curr_sin_lkup=19317;
             curr_cos_lkup=26468;
             next_sin_lkup=19358;
             next_cos_lkup=26438;
           end
    412  : begin
             curr_sin_lkup=19358;
             curr_cos_lkup=26438;
             next_sin_lkup=19398;
             next_cos_lkup=26409;
           end
    413  : begin
             curr_sin_lkup=19398;
             curr_cos_lkup=26409;
             next_sin_lkup=19439;
             next_cos_lkup=26379;
           end
    414  : begin
             curr_sin_lkup=19439;
             curr_cos_lkup=26379;
             next_sin_lkup=19479;
             next_cos_lkup=26349;
           end
    415  : begin
             curr_sin_lkup=19479;
             curr_cos_lkup=26349;
             next_sin_lkup=19519;
             next_cos_lkup=26319;
           end
    416  : begin
             curr_sin_lkup=19519;
             curr_cos_lkup=26319;
             next_sin_lkup=19560;
             next_cos_lkup=26289;
           end
    417  : begin
             curr_sin_lkup=19560;
             curr_cos_lkup=26289;
             next_sin_lkup=19600;
             next_cos_lkup=26259;
           end
    418  : begin
             curr_sin_lkup=19600;
             curr_cos_lkup=26259;
             next_sin_lkup=19640;
             next_cos_lkup=26229;
           end
    419  : begin
             curr_sin_lkup=19640;
             curr_cos_lkup=26229;
             next_sin_lkup=19681;
             next_cos_lkup=26199;
           end
    420  : begin
             curr_sin_lkup=19681;
             curr_cos_lkup=26199;
             next_sin_lkup=19721;
             next_cos_lkup=26169;
           end
    421  : begin
             curr_sin_lkup=19721;
             curr_cos_lkup=26169;
             next_sin_lkup=19761;
             next_cos_lkup=26138;
           end
    422  : begin
             curr_sin_lkup=19761;
             curr_cos_lkup=26138;
             next_sin_lkup=19801;
             next_cos_lkup=26108;
           end
    423  : begin
             curr_sin_lkup=19801;
             curr_cos_lkup=26108;
             next_sin_lkup=19841;
             next_cos_lkup=26077;
           end
    424  : begin
             curr_sin_lkup=19841;
             curr_cos_lkup=26077;
             next_sin_lkup=19881;
             next_cos_lkup=26047;
           end
    425  : begin
             curr_sin_lkup=19881;
             curr_cos_lkup=26047;
             next_sin_lkup=19921;
             next_cos_lkup=26016;
           end
    426  : begin
             curr_sin_lkup=19921;
             curr_cos_lkup=26016;
             next_sin_lkup=19961;
             next_cos_lkup=25986;
           end
    427  : begin
             curr_sin_lkup=19961;
             curr_cos_lkup=25986;
             next_sin_lkup=20001;
             next_cos_lkup=25955;
           end
    428  : begin
             curr_sin_lkup=20001;
             curr_cos_lkup=25955;
             next_sin_lkup=20040;
             next_cos_lkup=25925;
           end
    429  : begin
             curr_sin_lkup=20040;
             curr_cos_lkup=25925;
             next_sin_lkup=20080;
             next_cos_lkup=25894;
           end
    430  : begin
             curr_sin_lkup=20080;
             curr_cos_lkup=25894;
             next_sin_lkup=20120;
             next_cos_lkup=25863;
           end
    431  : begin
             curr_sin_lkup=20120;
             curr_cos_lkup=25863;
             next_sin_lkup=20159;
             next_cos_lkup=25832;
           end
    432  : begin
             curr_sin_lkup=20159;
             curr_cos_lkup=25832;
             next_sin_lkup=20199;
             next_cos_lkup=25801;
           end
    433  : begin
             curr_sin_lkup=20199;
             curr_cos_lkup=25801;
             next_sin_lkup=20239;
             next_cos_lkup=25770;
           end
    434  : begin
             curr_sin_lkup=20239;
             curr_cos_lkup=25770;
             next_sin_lkup=20278;
             next_cos_lkup=25739;
           end
    435  : begin
             curr_sin_lkup=20278;
             curr_cos_lkup=25739;
             next_sin_lkup=20318;
             next_cos_lkup=25708;
           end
    436  : begin
             curr_sin_lkup=20318;
             curr_cos_lkup=25708;
             next_sin_lkup=20357;
             next_cos_lkup=25677;
           end
    437  : begin
             curr_sin_lkup=20357;
             curr_cos_lkup=25677;
             next_sin_lkup=20396;
             next_cos_lkup=25645;
           end
    438  : begin
             curr_sin_lkup=20396;
             curr_cos_lkup=25645;
             next_sin_lkup=20436;
             next_cos_lkup=25614;
           end
    439  : begin
             curr_sin_lkup=20436;
             curr_cos_lkup=25614;
             next_sin_lkup=20475;
             next_cos_lkup=25583;
           end
    440  : begin
             curr_sin_lkup=20475;
             curr_cos_lkup=25583;
             next_sin_lkup=20514;
             next_cos_lkup=25551;
           end
    441  : begin
             curr_sin_lkup=20514;
             curr_cos_lkup=25551;
             next_sin_lkup=20553;
             next_cos_lkup=25520;
           end
    442  : begin
             curr_sin_lkup=20553;
             curr_cos_lkup=25520;
             next_sin_lkup=20592;
             next_cos_lkup=25488;
           end
    443  : begin
             curr_sin_lkup=20592;
             curr_cos_lkup=25488;
             next_sin_lkup=20631;
             next_cos_lkup=25457;
           end
    444  : begin
             curr_sin_lkup=20631;
             curr_cos_lkup=25457;
             next_sin_lkup=20671;
             next_cos_lkup=25425;
           end
    445  : begin
             curr_sin_lkup=20671;
             curr_cos_lkup=25425;
             next_sin_lkup=20709;
             next_cos_lkup=25393;
           end
    446  : begin
             curr_sin_lkup=20709;
             curr_cos_lkup=25393;
             next_sin_lkup=20748;
             next_cos_lkup=25361;
           end
    447  : begin
             curr_sin_lkup=20748;
             curr_cos_lkup=25361;
             next_sin_lkup=20787;
             next_cos_lkup=25330;
           end
    448  : begin
             curr_sin_lkup=20787;
             curr_cos_lkup=25330;
             next_sin_lkup=20826;
             next_cos_lkup=25298;
           end
    449  : begin
             curr_sin_lkup=20826;
             curr_cos_lkup=25298;
             next_sin_lkup=20865;
             next_cos_lkup=25266;
           end
    450  : begin
             curr_sin_lkup=20865;
             curr_cos_lkup=25266;
             next_sin_lkup=20904;
             next_cos_lkup=25234;
           end
    451  : begin
             curr_sin_lkup=20904;
             curr_cos_lkup=25234;
             next_sin_lkup=20942;
             next_cos_lkup=25201;
           end
    452  : begin
             curr_sin_lkup=20942;
             curr_cos_lkup=25201;
             next_sin_lkup=20981;
             next_cos_lkup=25169;
           end
    453  : begin
             curr_sin_lkup=20981;
             curr_cos_lkup=25169;
             next_sin_lkup=21020;
             next_cos_lkup=25137;
           end
    454  : begin
             curr_sin_lkup=21020;
             curr_cos_lkup=25137;
             next_sin_lkup=21058;
             next_cos_lkup=25105;
           end
    455  : begin
             curr_sin_lkup=21058;
             curr_cos_lkup=25105;
             next_sin_lkup=21097;
             next_cos_lkup=25073;
           end
    456  : begin
             curr_sin_lkup=21097;
             curr_cos_lkup=25073;
             next_sin_lkup=21135;
             next_cos_lkup=25040;
           end
    457  : begin
             curr_sin_lkup=21135;
             curr_cos_lkup=25040;
             next_sin_lkup=21173;
             next_cos_lkup=25008;
           end
    458  : begin
             curr_sin_lkup=21173;
             curr_cos_lkup=25008;
             next_sin_lkup=21212;
             next_cos_lkup=24975;
           end
    459  : begin
             curr_sin_lkup=21212;
             curr_cos_lkup=24975;
             next_sin_lkup=21250;
             next_cos_lkup=24943;
           end
    460  : begin
             curr_sin_lkup=21250;
             curr_cos_lkup=24943;
             next_sin_lkup=21288;
             next_cos_lkup=24910;
           end
    461  : begin
             curr_sin_lkup=21288;
             curr_cos_lkup=24910;
             next_sin_lkup=21326;
             next_cos_lkup=24877;
           end
    462  : begin
             curr_sin_lkup=21326;
             curr_cos_lkup=24877;
             next_sin_lkup=21365;
             next_cos_lkup=24845;
           end
    463  : begin
             curr_sin_lkup=21365;
             curr_cos_lkup=24845;
             next_sin_lkup=21403;
             next_cos_lkup=24812;
           end
    464  : begin
             curr_sin_lkup=21403;
             curr_cos_lkup=24812;
             next_sin_lkup=21441;
             next_cos_lkup=24779;
           end
    465  : begin
             curr_sin_lkup=21441;
             curr_cos_lkup=24779;
             next_sin_lkup=21479;
             next_cos_lkup=24746;
           end
    466  : begin
             curr_sin_lkup=21479;
             curr_cos_lkup=24746;
             next_sin_lkup=21517;
             next_cos_lkup=24713;
           end
    467  : begin
             curr_sin_lkup=21517;
             curr_cos_lkup=24713;
             next_sin_lkup=21555;
             next_cos_lkup=24680;
           end
    468  : begin
             curr_sin_lkup=21555;
             curr_cos_lkup=24680;
             next_sin_lkup=21592;
             next_cos_lkup=24647;
           end
    469  : begin
             curr_sin_lkup=21592;
             curr_cos_lkup=24647;
             next_sin_lkup=21630;
             next_cos_lkup=24614;
           end
    470  : begin
             curr_sin_lkup=21630;
             curr_cos_lkup=24614;
             next_sin_lkup=21668;
             next_cos_lkup=24580;
           end
    471  : begin
             curr_sin_lkup=21668;
             curr_cos_lkup=24580;
             next_sin_lkup=21706;
             next_cos_lkup=24547;
           end
    472  : begin
             curr_sin_lkup=21706;
             curr_cos_lkup=24547;
             next_sin_lkup=21743;
             next_cos_lkup=24514;
           end
    473  : begin
             curr_sin_lkup=21743;
             curr_cos_lkup=24514;
             next_sin_lkup=21781;
             next_cos_lkup=24480;
           end
    474  : begin
             curr_sin_lkup=21781;
             curr_cos_lkup=24480;
             next_sin_lkup=21818;
             next_cos_lkup=24447;
           end
    475  : begin
             curr_sin_lkup=21818;
             curr_cos_lkup=24447;
             next_sin_lkup=21856;
             next_cos_lkup=24414;
           end
    476  : begin
             curr_sin_lkup=21856;
             curr_cos_lkup=24414;
             next_sin_lkup=21893;
             next_cos_lkup=24380;
           end
    477  : begin
             curr_sin_lkup=21893;
             curr_cos_lkup=24380;
             next_sin_lkup=21931;
             next_cos_lkup=24346;
           end
    478  : begin
             curr_sin_lkup=21931;
             curr_cos_lkup=24346;
             next_sin_lkup=21968;
             next_cos_lkup=24313;
           end
    479  : begin
             curr_sin_lkup=21968;
             curr_cos_lkup=24313;
             next_sin_lkup=22005;
             next_cos_lkup=24279;
           end
    480  : begin
             curr_sin_lkup=22005;
             curr_cos_lkup=24279;
             next_sin_lkup=22042;
             next_cos_lkup=24245;
           end
    481  : begin
             curr_sin_lkup=22042;
             curr_cos_lkup=24245;
             next_sin_lkup=22080;
             next_cos_lkup=24211;
           end
    482  : begin
             curr_sin_lkup=22080;
             curr_cos_lkup=24211;
             next_sin_lkup=22117;
             next_cos_lkup=24177;
           end
    483  : begin
             curr_sin_lkup=22117;
             curr_cos_lkup=24177;
             next_sin_lkup=22154;
             next_cos_lkup=24144;
           end
    484  : begin
             curr_sin_lkup=22154;
             curr_cos_lkup=24144;
             next_sin_lkup=22191;
             next_cos_lkup=24109;
           end
    485  : begin
             curr_sin_lkup=22191;
             curr_cos_lkup=24109;
             next_sin_lkup=22228;
             next_cos_lkup=24075;
           end
    486  : begin
             curr_sin_lkup=22228;
             curr_cos_lkup=24075;
             next_sin_lkup=22265;
             next_cos_lkup=24041;
           end
    487  : begin
             curr_sin_lkup=22265;
             curr_cos_lkup=24041;
             next_sin_lkup=22301;
             next_cos_lkup=24007;
           end
    488  : begin
             curr_sin_lkup=22301;
             curr_cos_lkup=24007;
             next_sin_lkup=22338;
             next_cos_lkup=23973;
           end
    489  : begin
             curr_sin_lkup=22338;
             curr_cos_lkup=23973;
             next_sin_lkup=22375;
             next_cos_lkup=23939;
           end
    490  : begin
             curr_sin_lkup=22375;
             curr_cos_lkup=23939;
             next_sin_lkup=22412;
             next_cos_lkup=23904;
           end
    491  : begin
             curr_sin_lkup=22412;
             curr_cos_lkup=23904;
             next_sin_lkup=22448;
             next_cos_lkup=23870;
           end
    492  : begin
             curr_sin_lkup=22448;
             curr_cos_lkup=23870;
             next_sin_lkup=22485;
             next_cos_lkup=23835;
           end
    493  : begin
             curr_sin_lkup=22485;
             curr_cos_lkup=23835;
             next_sin_lkup=22521;
             next_cos_lkup=23801;
           end
    494  : begin
             curr_sin_lkup=22521;
             curr_cos_lkup=23801;
             next_sin_lkup=22558;
             next_cos_lkup=23766;
           end
    495  : begin
             curr_sin_lkup=22558;
             curr_cos_lkup=23766;
             next_sin_lkup=22594;
             next_cos_lkup=23732;
           end
    496  : begin
             curr_sin_lkup=22594;
             curr_cos_lkup=23732;
             next_sin_lkup=22631;
             next_cos_lkup=23697;
           end
    497  : begin
             curr_sin_lkup=22631;
             curr_cos_lkup=23697;
             next_sin_lkup=22667;
             next_cos_lkup=23662;
           end
    498  : begin
             curr_sin_lkup=22667;
             curr_cos_lkup=23662;
             next_sin_lkup=22703;
             next_cos_lkup=23627;
           end
    499  : begin
             curr_sin_lkup=22703;
             curr_cos_lkup=23627;
             next_sin_lkup=22740;
             next_cos_lkup=23593;
           end
    500  : begin
             curr_sin_lkup=22740;
             curr_cos_lkup=23593;
             next_sin_lkup=22776;
             next_cos_lkup=23558;
           end
    501  : begin
             curr_sin_lkup=22776;
             curr_cos_lkup=23558;
             next_sin_lkup=22812;
             next_cos_lkup=23523;
           end
    502  : begin
             curr_sin_lkup=22812;
             curr_cos_lkup=23523;
             next_sin_lkup=22848;
             next_cos_lkup=23488;
           end
    503  : begin
             curr_sin_lkup=22848;
             curr_cos_lkup=23488;
             next_sin_lkup=22884;
             next_cos_lkup=23453;
           end
    504  : begin
             curr_sin_lkup=22884;
             curr_cos_lkup=23453;
             next_sin_lkup=22920;
             next_cos_lkup=23417;
           end
    505  : begin
             curr_sin_lkup=22920;
             curr_cos_lkup=23417;
             next_sin_lkup=22956;
             next_cos_lkup=23382;
           end
    506  : begin
             curr_sin_lkup=22956;
             curr_cos_lkup=23382;
             next_sin_lkup=22992;
             next_cos_lkup=23347;
           end
    507  : begin
             curr_sin_lkup=22992;
             curr_cos_lkup=23347;
             next_sin_lkup=23027;
             next_cos_lkup=23312;
           end
    508  : begin
             curr_sin_lkup=23027;
             curr_cos_lkup=23312;
             next_sin_lkup=23063;
             next_cos_lkup=23276;
           end
    509  : begin
             curr_sin_lkup=23063;
             curr_cos_lkup=23276;
             next_sin_lkup=23099;
             next_cos_lkup=23241;
           end
    510  : begin
             curr_sin_lkup=23099;
             curr_cos_lkup=23241;
             next_sin_lkup=23134;
             next_cos_lkup=23205;
           end
    511  : begin
             curr_sin_lkup=23134;
             curr_cos_lkup=23205;
             next_sin_lkup=23170;
             next_cos_lkup=23170;
           end
    512  : begin
             curr_sin_lkup=23170;
             curr_cos_lkup=23170;
             next_sin_lkup=23205;
             next_cos_lkup=23134;
           end
    513  : begin
             curr_sin_lkup=23205;
             curr_cos_lkup=23134;
             next_sin_lkup=23241;
             next_cos_lkup=23099;
           end
    514  : begin
             curr_sin_lkup=23241;
             curr_cos_lkup=23099;
             next_sin_lkup=23276;
             next_cos_lkup=23063;
           end
    515  : begin
             curr_sin_lkup=23276;
             curr_cos_lkup=23063;
             next_sin_lkup=23312;
             next_cos_lkup=23027;
           end
    516  : begin
             curr_sin_lkup=23312;
             curr_cos_lkup=23027;
             next_sin_lkup=23347;
             next_cos_lkup=22992;
           end
    517  : begin
             curr_sin_lkup=23347;
             curr_cos_lkup=22992;
             next_sin_lkup=23382;
             next_cos_lkup=22956;
           end
    518  : begin
             curr_sin_lkup=23382;
             curr_cos_lkup=22956;
             next_sin_lkup=23417;
             next_cos_lkup=22920;
           end
    519  : begin
             curr_sin_lkup=23417;
             curr_cos_lkup=22920;
             next_sin_lkup=23453;
             next_cos_lkup=22884;
           end
    520  : begin
             curr_sin_lkup=23453;
             curr_cos_lkup=22884;
             next_sin_lkup=23488;
             next_cos_lkup=22848;
           end
    521  : begin
             curr_sin_lkup=23488;
             curr_cos_lkup=22848;
             next_sin_lkup=23523;
             next_cos_lkup=22812;
           end
    522  : begin
             curr_sin_lkup=23523;
             curr_cos_lkup=22812;
             next_sin_lkup=23558;
             next_cos_lkup=22776;
           end
    523  : begin
             curr_sin_lkup=23558;
             curr_cos_lkup=22776;
             next_sin_lkup=23593;
             next_cos_lkup=22740;
           end
    524  : begin
             curr_sin_lkup=23593;
             curr_cos_lkup=22740;
             next_sin_lkup=23627;
             next_cos_lkup=22703;
           end
    525  : begin
             curr_sin_lkup=23627;
             curr_cos_lkup=22703;
             next_sin_lkup=23662;
             next_cos_lkup=22667;
           end
    526  : begin
             curr_sin_lkup=23662;
             curr_cos_lkup=22667;
             next_sin_lkup=23697;
             next_cos_lkup=22631;
           end
    527  : begin
             curr_sin_lkup=23697;
             curr_cos_lkup=22631;
             next_sin_lkup=23732;
             next_cos_lkup=22594;
           end
    528  : begin
             curr_sin_lkup=23732;
             curr_cos_lkup=22594;
             next_sin_lkup=23766;
             next_cos_lkup=22558;
           end
    529  : begin
             curr_sin_lkup=23766;
             curr_cos_lkup=22558;
             next_sin_lkup=23801;
             next_cos_lkup=22521;
           end
    530  : begin
             curr_sin_lkup=23801;
             curr_cos_lkup=22521;
             next_sin_lkup=23835;
             next_cos_lkup=22485;
           end
    531  : begin
             curr_sin_lkup=23835;
             curr_cos_lkup=22485;
             next_sin_lkup=23870;
             next_cos_lkup=22448;
           end
    532  : begin
             curr_sin_lkup=23870;
             curr_cos_lkup=22448;
             next_sin_lkup=23904;
             next_cos_lkup=22412;
           end
    533  : begin
             curr_sin_lkup=23904;
             curr_cos_lkup=22412;
             next_sin_lkup=23939;
             next_cos_lkup=22375;
           end
    534  : begin
             curr_sin_lkup=23939;
             curr_cos_lkup=22375;
             next_sin_lkup=23973;
             next_cos_lkup=22338;
           end
    535  : begin
             curr_sin_lkup=23973;
             curr_cos_lkup=22338;
             next_sin_lkup=24007;
             next_cos_lkup=22301;
           end
    536  : begin
             curr_sin_lkup=24007;
             curr_cos_lkup=22301;
             next_sin_lkup=24041;
             next_cos_lkup=22265;
           end
    537  : begin
             curr_sin_lkup=24041;
             curr_cos_lkup=22265;
             next_sin_lkup=24075;
             next_cos_lkup=22228;
           end
    538  : begin
             curr_sin_lkup=24075;
             curr_cos_lkup=22228;
             next_sin_lkup=24109;
             next_cos_lkup=22191;
           end
    539  : begin
             curr_sin_lkup=24109;
             curr_cos_lkup=22191;
             next_sin_lkup=24144;
             next_cos_lkup=22154;
           end
    540  : begin
             curr_sin_lkup=24144;
             curr_cos_lkup=22154;
             next_sin_lkup=24177;
             next_cos_lkup=22117;
           end
    541  : begin
             curr_sin_lkup=24177;
             curr_cos_lkup=22117;
             next_sin_lkup=24211;
             next_cos_lkup=22080;
           end
    542  : begin
             curr_sin_lkup=24211;
             curr_cos_lkup=22080;
             next_sin_lkup=24245;
             next_cos_lkup=22042;
           end
    543  : begin
             curr_sin_lkup=24245;
             curr_cos_lkup=22042;
             next_sin_lkup=24279;
             next_cos_lkup=22005;
           end
    544  : begin
             curr_sin_lkup=24279;
             curr_cos_lkup=22005;
             next_sin_lkup=24313;
             next_cos_lkup=21968;
           end
    545  : begin
             curr_sin_lkup=24313;
             curr_cos_lkup=21968;
             next_sin_lkup=24346;
             next_cos_lkup=21931;
           end
    546  : begin
             curr_sin_lkup=24346;
             curr_cos_lkup=21931;
             next_sin_lkup=24380;
             next_cos_lkup=21893;
           end
    547  : begin
             curr_sin_lkup=24380;
             curr_cos_lkup=21893;
             next_sin_lkup=24414;
             next_cos_lkup=21856;
           end
    548  : begin
             curr_sin_lkup=24414;
             curr_cos_lkup=21856;
             next_sin_lkup=24447;
             next_cos_lkup=21818;
           end
    549  : begin
             curr_sin_lkup=24447;
             curr_cos_lkup=21818;
             next_sin_lkup=24480;
             next_cos_lkup=21781;
           end
    550  : begin
             curr_sin_lkup=24480;
             curr_cos_lkup=21781;
             next_sin_lkup=24514;
             next_cos_lkup=21743;
           end
    551  : begin
             curr_sin_lkup=24514;
             curr_cos_lkup=21743;
             next_sin_lkup=24547;
             next_cos_lkup=21706;
           end
    552  : begin
             curr_sin_lkup=24547;
             curr_cos_lkup=21706;
             next_sin_lkup=24580;
             next_cos_lkup=21668;
           end
    553  : begin
             curr_sin_lkup=24580;
             curr_cos_lkup=21668;
             next_sin_lkup=24614;
             next_cos_lkup=21630;
           end
    554  : begin
             curr_sin_lkup=24614;
             curr_cos_lkup=21630;
             next_sin_lkup=24647;
             next_cos_lkup=21592;
           end
    555  : begin
             curr_sin_lkup=24647;
             curr_cos_lkup=21592;
             next_sin_lkup=24680;
             next_cos_lkup=21555;
           end
    556  : begin
             curr_sin_lkup=24680;
             curr_cos_lkup=21555;
             next_sin_lkup=24713;
             next_cos_lkup=21517;
           end
    557  : begin
             curr_sin_lkup=24713;
             curr_cos_lkup=21517;
             next_sin_lkup=24746;
             next_cos_lkup=21479;
           end
    558  : begin
             curr_sin_lkup=24746;
             curr_cos_lkup=21479;
             next_sin_lkup=24779;
             next_cos_lkup=21441;
           end
    559  : begin
             curr_sin_lkup=24779;
             curr_cos_lkup=21441;
             next_sin_lkup=24812;
             next_cos_lkup=21403;
           end
    560  : begin
             curr_sin_lkup=24812;
             curr_cos_lkup=21403;
             next_sin_lkup=24845;
             next_cos_lkup=21365;
           end
    561  : begin
             curr_sin_lkup=24845;
             curr_cos_lkup=21365;
             next_sin_lkup=24877;
             next_cos_lkup=21326;
           end
    562  : begin
             curr_sin_lkup=24877;
             curr_cos_lkup=21326;
             next_sin_lkup=24910;
             next_cos_lkup=21288;
           end
    563  : begin
             curr_sin_lkup=24910;
             curr_cos_lkup=21288;
             next_sin_lkup=24943;
             next_cos_lkup=21250;
           end
    564  : begin
             curr_sin_lkup=24943;
             curr_cos_lkup=21250;
             next_sin_lkup=24975;
             next_cos_lkup=21212;
           end
    565  : begin
             curr_sin_lkup=24975;
             curr_cos_lkup=21212;
             next_sin_lkup=25008;
             next_cos_lkup=21173;
           end
    566  : begin
             curr_sin_lkup=25008;
             curr_cos_lkup=21173;
             next_sin_lkup=25040;
             next_cos_lkup=21135;
           end
    567  : begin
             curr_sin_lkup=25040;
             curr_cos_lkup=21135;
             next_sin_lkup=25073;
             next_cos_lkup=21097;
           end
    568  : begin
             curr_sin_lkup=25073;
             curr_cos_lkup=21097;
             next_sin_lkup=25105;
             next_cos_lkup=21058;
           end
    569  : begin
             curr_sin_lkup=25105;
             curr_cos_lkup=21058;
             next_sin_lkup=25137;
             next_cos_lkup=21020;
           end
    570  : begin
             curr_sin_lkup=25137;
             curr_cos_lkup=21020;
             next_sin_lkup=25169;
             next_cos_lkup=20981;
           end
    571  : begin
             curr_sin_lkup=25169;
             curr_cos_lkup=20981;
             next_sin_lkup=25201;
             next_cos_lkup=20942;
           end
    572  : begin
             curr_sin_lkup=25201;
             curr_cos_lkup=20942;
             next_sin_lkup=25234;
             next_cos_lkup=20904;
           end
    573  : begin
             curr_sin_lkup=25234;
             curr_cos_lkup=20904;
             next_sin_lkup=25266;
             next_cos_lkup=20865;
           end
    574  : begin
             curr_sin_lkup=25266;
             curr_cos_lkup=20865;
             next_sin_lkup=25298;
             next_cos_lkup=20826;
           end
    575  : begin
             curr_sin_lkup=25298;
             curr_cos_lkup=20826;
             next_sin_lkup=25330;
             next_cos_lkup=20787;
           end
    576  : begin
             curr_sin_lkup=25330;
             curr_cos_lkup=20787;
             next_sin_lkup=25361;
             next_cos_lkup=20748;
           end
    577  : begin
             curr_sin_lkup=25361;
             curr_cos_lkup=20748;
             next_sin_lkup=25393;
             next_cos_lkup=20709;
           end
    578  : begin
             curr_sin_lkup=25393;
             curr_cos_lkup=20709;
             next_sin_lkup=25425;
             next_cos_lkup=20671;
           end
    579  : begin
             curr_sin_lkup=25425;
             curr_cos_lkup=20671;
             next_sin_lkup=25457;
             next_cos_lkup=20631;
           end
    580  : begin
             curr_sin_lkup=25457;
             curr_cos_lkup=20631;
             next_sin_lkup=25488;
             next_cos_lkup=20592;
           end
    581  : begin
             curr_sin_lkup=25488;
             curr_cos_lkup=20592;
             next_sin_lkup=25520;
             next_cos_lkup=20553;
           end
    582  : begin
             curr_sin_lkup=25520;
             curr_cos_lkup=20553;
             next_sin_lkup=25551;
             next_cos_lkup=20514;
           end
    583  : begin
             curr_sin_lkup=25551;
             curr_cos_lkup=20514;
             next_sin_lkup=25583;
             next_cos_lkup=20475;
           end
    584  : begin
             curr_sin_lkup=25583;
             curr_cos_lkup=20475;
             next_sin_lkup=25614;
             next_cos_lkup=20436;
           end
    585  : begin
             curr_sin_lkup=25614;
             curr_cos_lkup=20436;
             next_sin_lkup=25645;
             next_cos_lkup=20396;
           end
    586  : begin
             curr_sin_lkup=25645;
             curr_cos_lkup=20396;
             next_sin_lkup=25677;
             next_cos_lkup=20357;
           end
    587  : begin
             curr_sin_lkup=25677;
             curr_cos_lkup=20357;
             next_sin_lkup=25708;
             next_cos_lkup=20318;
           end
    588  : begin
             curr_sin_lkup=25708;
             curr_cos_lkup=20318;
             next_sin_lkup=25739;
             next_cos_lkup=20278;
           end
    589  : begin
             curr_sin_lkup=25739;
             curr_cos_lkup=20278;
             next_sin_lkup=25770;
             next_cos_lkup=20239;
           end
    590  : begin
             curr_sin_lkup=25770;
             curr_cos_lkup=20239;
             next_sin_lkup=25801;
             next_cos_lkup=20199;
           end
    591  : begin
             curr_sin_lkup=25801;
             curr_cos_lkup=20199;
             next_sin_lkup=25832;
             next_cos_lkup=20159;
           end
    592  : begin
             curr_sin_lkup=25832;
             curr_cos_lkup=20159;
             next_sin_lkup=25863;
             next_cos_lkup=20120;
           end
    593  : begin
             curr_sin_lkup=25863;
             curr_cos_lkup=20120;
             next_sin_lkup=25894;
             next_cos_lkup=20080;
           end
    594  : begin
             curr_sin_lkup=25894;
             curr_cos_lkup=20080;
             next_sin_lkup=25925;
             next_cos_lkup=20040;
           end
    595  : begin
             curr_sin_lkup=25925;
             curr_cos_lkup=20040;
             next_sin_lkup=25955;
             next_cos_lkup=20001;
           end
    596  : begin
             curr_sin_lkup=25955;
             curr_cos_lkup=20001;
             next_sin_lkup=25986;
             next_cos_lkup=19961;
           end
    597  : begin
             curr_sin_lkup=25986;
             curr_cos_lkup=19961;
             next_sin_lkup=26016;
             next_cos_lkup=19921;
           end
    598  : begin
             curr_sin_lkup=26016;
             curr_cos_lkup=19921;
             next_sin_lkup=26047;
             next_cos_lkup=19881;
           end
    599  : begin
             curr_sin_lkup=26047;
             curr_cos_lkup=19881;
             next_sin_lkup=26077;
             next_cos_lkup=19841;
           end
    600  : begin
             curr_sin_lkup=26077;
             curr_cos_lkup=19841;
             next_sin_lkup=26108;
             next_cos_lkup=19801;
           end
    601  : begin
             curr_sin_lkup=26108;
             curr_cos_lkup=19801;
             next_sin_lkup=26138;
             next_cos_lkup=19761;
           end
    602  : begin
             curr_sin_lkup=26138;
             curr_cos_lkup=19761;
             next_sin_lkup=26169;
             next_cos_lkup=19721;
           end
    603  : begin
             curr_sin_lkup=26169;
             curr_cos_lkup=19721;
             next_sin_lkup=26199;
             next_cos_lkup=19681;
           end
    604  : begin
             curr_sin_lkup=26199;
             curr_cos_lkup=19681;
             next_sin_lkup=26229;
             next_cos_lkup=19640;
           end
    605  : begin
             curr_sin_lkup=26229;
             curr_cos_lkup=19640;
             next_sin_lkup=26259;
             next_cos_lkup=19600;
           end
    606  : begin
             curr_sin_lkup=26259;
             curr_cos_lkup=19600;
             next_sin_lkup=26289;
             next_cos_lkup=19560;
           end
    607  : begin
             curr_sin_lkup=26289;
             curr_cos_lkup=19560;
             next_sin_lkup=26319;
             next_cos_lkup=19519;
           end
    608  : begin
             curr_sin_lkup=26319;
             curr_cos_lkup=19519;
             next_sin_lkup=26349;
             next_cos_lkup=19479;
           end
    609  : begin
             curr_sin_lkup=26349;
             curr_cos_lkup=19479;
             next_sin_lkup=26379;
             next_cos_lkup=19439;
           end
    610  : begin
             curr_sin_lkup=26379;
             curr_cos_lkup=19439;
             next_sin_lkup=26409;
             next_cos_lkup=19398;
           end
    611  : begin
             curr_sin_lkup=26409;
             curr_cos_lkup=19398;
             next_sin_lkup=26438;
             next_cos_lkup=19358;
           end
    612  : begin
             curr_sin_lkup=26438;
             curr_cos_lkup=19358;
             next_sin_lkup=26468;
             next_cos_lkup=19317;
           end
    613  : begin
             curr_sin_lkup=26468;
             curr_cos_lkup=19317;
             next_sin_lkup=26498;
             next_cos_lkup=19276;
           end
    614  : begin
             curr_sin_lkup=26498;
             curr_cos_lkup=19276;
             next_sin_lkup=26527;
             next_cos_lkup=19236;
           end
    615  : begin
             curr_sin_lkup=26527;
             curr_cos_lkup=19236;
             next_sin_lkup=26557;
             next_cos_lkup=19195;
           end
    616  : begin
             curr_sin_lkup=26557;
             curr_cos_lkup=19195;
             next_sin_lkup=26586;
             next_cos_lkup=19154;
           end
    617  : begin
             curr_sin_lkup=26586;
             curr_cos_lkup=19154;
             next_sin_lkup=26615;
             next_cos_lkup=19113;
           end
    618  : begin
             curr_sin_lkup=26615;
             curr_cos_lkup=19113;
             next_sin_lkup=26645;
             next_cos_lkup=19073;
           end
    619  : begin
             curr_sin_lkup=26645;
             curr_cos_lkup=19073;
             next_sin_lkup=26674;
             next_cos_lkup=19032;
           end
    620  : begin
             curr_sin_lkup=26674;
             curr_cos_lkup=19032;
             next_sin_lkup=26703;
             next_cos_lkup=18991;
           end
    621  : begin
             curr_sin_lkup=26703;
             curr_cos_lkup=18991;
             next_sin_lkup=26732;
             next_cos_lkup=18950;
           end
    622  : begin
             curr_sin_lkup=26732;
             curr_cos_lkup=18950;
             next_sin_lkup=26761;
             next_cos_lkup=18909;
           end
    623  : begin
             curr_sin_lkup=26761;
             curr_cos_lkup=18909;
             next_sin_lkup=26790;
             next_cos_lkup=18868;
           end
    624  : begin
             curr_sin_lkup=26790;
             curr_cos_lkup=18868;
             next_sin_lkup=26819;
             next_cos_lkup=18826;
           end
    625  : begin
             curr_sin_lkup=26819;
             curr_cos_lkup=18826;
             next_sin_lkup=26848;
             next_cos_lkup=18785;
           end
    626  : begin
             curr_sin_lkup=26848;
             curr_cos_lkup=18785;
             next_sin_lkup=26877;
             next_cos_lkup=18744;
           end
    627  : begin
             curr_sin_lkup=26877;
             curr_cos_lkup=18744;
             next_sin_lkup=26905;
             next_cos_lkup=18703;
           end
    628  : begin
             curr_sin_lkup=26905;
             curr_cos_lkup=18703;
             next_sin_lkup=26934;
             next_cos_lkup=18662;
           end
    629  : begin
             curr_sin_lkup=26934;
             curr_cos_lkup=18662;
             next_sin_lkup=26963;
             next_cos_lkup=18620;
           end
    630  : begin
             curr_sin_lkup=26963;
             curr_cos_lkup=18620;
             next_sin_lkup=26991;
             next_cos_lkup=18579;
           end
    631  : begin
             curr_sin_lkup=26991;
             curr_cos_lkup=18579;
             next_sin_lkup=27020;
             next_cos_lkup=18537;
           end
    632  : begin
             curr_sin_lkup=27020;
             curr_cos_lkup=18537;
             next_sin_lkup=27048;
             next_cos_lkup=18496;
           end
    633  : begin
             curr_sin_lkup=27048;
             curr_cos_lkup=18496;
             next_sin_lkup=27076;
             next_cos_lkup=18454;
           end
    634  : begin
             curr_sin_lkup=27076;
             curr_cos_lkup=18454;
             next_sin_lkup=27105;
             next_cos_lkup=18413;
           end
    635  : begin
             curr_sin_lkup=27105;
             curr_cos_lkup=18413;
             next_sin_lkup=27133;
             next_cos_lkup=18371;
           end
    636  : begin
             curr_sin_lkup=27133;
             curr_cos_lkup=18371;
             next_sin_lkup=27161;
             next_cos_lkup=18330;
           end
    637  : begin
             curr_sin_lkup=27161;
             curr_cos_lkup=18330;
             next_sin_lkup=27189;
             next_cos_lkup=18288;
           end
    638  : begin
             curr_sin_lkup=27189;
             curr_cos_lkup=18288;
             next_sin_lkup=27217;
             next_cos_lkup=18246;
           end
    639  : begin
             curr_sin_lkup=27217;
             curr_cos_lkup=18246;
             next_sin_lkup=27245;
             next_cos_lkup=18204;
           end
    640  : begin
             curr_sin_lkup=27245;
             curr_cos_lkup=18204;
             next_sin_lkup=27273;
             next_cos_lkup=18163;
           end
    641  : begin
             curr_sin_lkup=27273;
             curr_cos_lkup=18163;
             next_sin_lkup=27301;
             next_cos_lkup=18121;
           end
    642  : begin
             curr_sin_lkup=27301;
             curr_cos_lkup=18121;
             next_sin_lkup=27329;
             next_cos_lkup=18079;
           end
    643  : begin
             curr_sin_lkup=27329;
             curr_cos_lkup=18079;
             next_sin_lkup=27356;
             next_cos_lkup=18037;
           end
    644  : begin
             curr_sin_lkup=27356;
             curr_cos_lkup=18037;
             next_sin_lkup=27384;
             next_cos_lkup=17995;
           end
    645  : begin
             curr_sin_lkup=27384;
             curr_cos_lkup=17995;
             next_sin_lkup=27411;
             next_cos_lkup=17953;
           end
    646  : begin
             curr_sin_lkup=27411;
             curr_cos_lkup=17953;
             next_sin_lkup=27439;
             next_cos_lkup=17911;
           end
    647  : begin
             curr_sin_lkup=27439;
             curr_cos_lkup=17911;
             next_sin_lkup=27466;
             next_cos_lkup=17869;
           end
    648  : begin
             curr_sin_lkup=27466;
             curr_cos_lkup=17869;
             next_sin_lkup=27494;
             next_cos_lkup=17827;
           end
    649  : begin
             curr_sin_lkup=27494;
             curr_cos_lkup=17827;
             next_sin_lkup=27521;
             next_cos_lkup=17784;
           end
    650  : begin
             curr_sin_lkup=27521;
             curr_cos_lkup=17784;
             next_sin_lkup=27548;
             next_cos_lkup=17742;
           end
    651  : begin
             curr_sin_lkup=27548;
             curr_cos_lkup=17742;
             next_sin_lkup=27576;
             next_cos_lkup=17700;
           end
    652  : begin
             curr_sin_lkup=27576;
             curr_cos_lkup=17700;
             next_sin_lkup=27603;
             next_cos_lkup=17658;
           end
    653  : begin
             curr_sin_lkup=27603;
             curr_cos_lkup=17658;
             next_sin_lkup=27630;
             next_cos_lkup=17615;
           end
    654  : begin
             curr_sin_lkup=27630;
             curr_cos_lkup=17615;
             next_sin_lkup=27657;
             next_cos_lkup=17573;
           end
    655  : begin
             curr_sin_lkup=27657;
             curr_cos_lkup=17573;
             next_sin_lkup=27684;
             next_cos_lkup=17530;
           end
    656  : begin
             curr_sin_lkup=27684;
             curr_cos_lkup=17530;
             next_sin_lkup=27711;
             next_cos_lkup=17488;
           end
    657  : begin
             curr_sin_lkup=27711;
             curr_cos_lkup=17488;
             next_sin_lkup=27737;
             next_cos_lkup=17445;
           end
    658  : begin
             curr_sin_lkup=27737;
             curr_cos_lkup=17445;
             next_sin_lkup=27764;
             next_cos_lkup=17403;
           end
    659  : begin
             curr_sin_lkup=27764;
             curr_cos_lkup=17403;
             next_sin_lkup=27791;
             next_cos_lkup=17360;
           end
    660  : begin
             curr_sin_lkup=27791;
             curr_cos_lkup=17360;
             next_sin_lkup=27817;
             next_cos_lkup=17317;
           end
    661  : begin
             curr_sin_lkup=27817;
             curr_cos_lkup=17317;
             next_sin_lkup=27844;
             next_cos_lkup=17275;
           end
    662  : begin
             curr_sin_lkup=27844;
             curr_cos_lkup=17275;
             next_sin_lkup=27870;
             next_cos_lkup=17232;
           end
    663  : begin
             curr_sin_lkup=27870;
             curr_cos_lkup=17232;
             next_sin_lkup=27897;
             next_cos_lkup=17189;
           end
    664  : begin
             curr_sin_lkup=27897;
             curr_cos_lkup=17189;
             next_sin_lkup=27923;
             next_cos_lkup=17146;
           end
    665  : begin
             curr_sin_lkup=27923;
             curr_cos_lkup=17146;
             next_sin_lkup=27949;
             next_cos_lkup=17104;
           end
    666  : begin
             curr_sin_lkup=27949;
             curr_cos_lkup=17104;
             next_sin_lkup=27976;
             next_cos_lkup=17061;
           end
    667  : begin
             curr_sin_lkup=27976;
             curr_cos_lkup=17061;
             next_sin_lkup=28002;
             next_cos_lkup=17018;
           end
    668  : begin
             curr_sin_lkup=28002;
             curr_cos_lkup=17018;
             next_sin_lkup=28028;
             next_cos_lkup=16975;
           end
    669  : begin
             curr_sin_lkup=28028;
             curr_cos_lkup=16975;
             next_sin_lkup=28054;
             next_cos_lkup=16932;
           end
    670  : begin
             curr_sin_lkup=28054;
             curr_cos_lkup=16932;
             next_sin_lkup=28080;
             next_cos_lkup=16889;
           end
    671  : begin
             curr_sin_lkup=28080;
             curr_cos_lkup=16889;
             next_sin_lkup=28106;
             next_cos_lkup=16846;
           end
    672  : begin
             curr_sin_lkup=28106;
             curr_cos_lkup=16846;
             next_sin_lkup=28131;
             next_cos_lkup=16802;
           end
    673  : begin
             curr_sin_lkup=28131;
             curr_cos_lkup=16802;
             next_sin_lkup=28157;
             next_cos_lkup=16759;
           end
    674  : begin
             curr_sin_lkup=28157;
             curr_cos_lkup=16759;
             next_sin_lkup=28183;
             next_cos_lkup=16716;
           end
    675  : begin
             curr_sin_lkup=28183;
             curr_cos_lkup=16716;
             next_sin_lkup=28208;
             next_cos_lkup=16673;
           end
    676  : begin
             curr_sin_lkup=28208;
             curr_cos_lkup=16673;
             next_sin_lkup=28234;
             next_cos_lkup=16630;
           end
    677  : begin
             curr_sin_lkup=28234;
             curr_cos_lkup=16630;
             next_sin_lkup=28259;
             next_cos_lkup=16586;
           end
    678  : begin
             curr_sin_lkup=28259;
             curr_cos_lkup=16586;
             next_sin_lkup=28285;
             next_cos_lkup=16543;
           end
    679  : begin
             curr_sin_lkup=28285;
             curr_cos_lkup=16543;
             next_sin_lkup=28310;
             next_cos_lkup=16499;
           end
    680  : begin
             curr_sin_lkup=28310;
             curr_cos_lkup=16499;
             next_sin_lkup=28335;
             next_cos_lkup=16456;
           end
    681  : begin
             curr_sin_lkup=28335;
             curr_cos_lkup=16456;
             next_sin_lkup=28361;
             next_cos_lkup=16413;
           end
    682  : begin
             curr_sin_lkup=28361;
             curr_cos_lkup=16413;
             next_sin_lkup=28386;
             next_cos_lkup=16369;
           end
    683  : begin
             curr_sin_lkup=28386;
             curr_cos_lkup=16369;
             next_sin_lkup=28411;
             next_cos_lkup=16325;
           end
    684  : begin
             curr_sin_lkup=28411;
             curr_cos_lkup=16325;
             next_sin_lkup=28436;
             next_cos_lkup=16282;
           end
    685  : begin
             curr_sin_lkup=28436;
             curr_cos_lkup=16282;
             next_sin_lkup=28461;
             next_cos_lkup=16238;
           end
    686  : begin
             curr_sin_lkup=28461;
             curr_cos_lkup=16238;
             next_sin_lkup=28486;
             next_cos_lkup=16195;
           end
    687  : begin
             curr_sin_lkup=28486;
             curr_cos_lkup=16195;
             next_sin_lkup=28511;
             next_cos_lkup=16151;
           end
    688  : begin
             curr_sin_lkup=28511;
             curr_cos_lkup=16151;
             next_sin_lkup=28535;
             next_cos_lkup=16107;
           end
    689  : begin
             curr_sin_lkup=28535;
             curr_cos_lkup=16107;
             next_sin_lkup=28560;
             next_cos_lkup=16063;
           end
    690  : begin
             curr_sin_lkup=28560;
             curr_cos_lkup=16063;
             next_sin_lkup=28585;
             next_cos_lkup=16019;
           end
    691  : begin
             curr_sin_lkup=28585;
             curr_cos_lkup=16019;
             next_sin_lkup=28609;
             next_cos_lkup=15976;
           end
    692  : begin
             curr_sin_lkup=28609;
             curr_cos_lkup=15976;
             next_sin_lkup=28634;
             next_cos_lkup=15932;
           end
    693  : begin
             curr_sin_lkup=28634;
             curr_cos_lkup=15932;
             next_sin_lkup=28658;
             next_cos_lkup=15888;
           end
    694  : begin
             curr_sin_lkup=28658;
             curr_cos_lkup=15888;
             next_sin_lkup=28682;
             next_cos_lkup=15844;
           end
    695  : begin
             curr_sin_lkup=28682;
             curr_cos_lkup=15844;
             next_sin_lkup=28707;
             next_cos_lkup=15800;
           end
    696  : begin
             curr_sin_lkup=28707;
             curr_cos_lkup=15800;
             next_sin_lkup=28731;
             next_cos_lkup=15756;
           end
    697  : begin
             curr_sin_lkup=28731;
             curr_cos_lkup=15756;
             next_sin_lkup=28755;
             next_cos_lkup=15712;
           end
    698  : begin
             curr_sin_lkup=28755;
             curr_cos_lkup=15712;
             next_sin_lkup=28779;
             next_cos_lkup=15667;
           end
    699  : begin
             curr_sin_lkup=28779;
             curr_cos_lkup=15667;
             next_sin_lkup=28803;
             next_cos_lkup=15623;
           end
    700  : begin
             curr_sin_lkup=28803;
             curr_cos_lkup=15623;
             next_sin_lkup=28827;
             next_cos_lkup=15579;
           end
    701  : begin
             curr_sin_lkup=28827;
             curr_cos_lkup=15579;
             next_sin_lkup=28851;
             next_cos_lkup=15535;
           end
    702  : begin
             curr_sin_lkup=28851;
             curr_cos_lkup=15535;
             next_sin_lkup=28875;
             next_cos_lkup=15491;
           end
    703  : begin
             curr_sin_lkup=28875;
             curr_cos_lkup=15491;
             next_sin_lkup=28898;
             next_cos_lkup=15446;
           end
    704  : begin
             curr_sin_lkup=28898;
             curr_cos_lkup=15446;
             next_sin_lkup=28922;
             next_cos_lkup=15402;
           end
    705  : begin
             curr_sin_lkup=28922;
             curr_cos_lkup=15402;
             next_sin_lkup=28946;
             next_cos_lkup=15357;
           end
    706  : begin
             curr_sin_lkup=28946;
             curr_cos_lkup=15357;
             next_sin_lkup=28969;
             next_cos_lkup=15313;
           end
    707  : begin
             curr_sin_lkup=28969;
             curr_cos_lkup=15313;
             next_sin_lkup=28993;
             next_cos_lkup=15269;
           end
    708  : begin
             curr_sin_lkup=28993;
             curr_cos_lkup=15269;
             next_sin_lkup=29016;
             next_cos_lkup=15224;
           end
    709  : begin
             curr_sin_lkup=29016;
             curr_cos_lkup=15224;
             next_sin_lkup=29039;
             next_cos_lkup=15180;
           end
    710  : begin
             curr_sin_lkup=29039;
             curr_cos_lkup=15180;
             next_sin_lkup=29062;
             next_cos_lkup=15135;
           end
    711  : begin
             curr_sin_lkup=29062;
             curr_cos_lkup=15135;
             next_sin_lkup=29086;
             next_cos_lkup=15090;
           end
    712  : begin
             curr_sin_lkup=29086;
             curr_cos_lkup=15090;
             next_sin_lkup=29109;
             next_cos_lkup=15046;
           end
    713  : begin
             curr_sin_lkup=29109;
             curr_cos_lkup=15046;
             next_sin_lkup=29132;
             next_cos_lkup=15001;
           end
    714  : begin
             curr_sin_lkup=29132;
             curr_cos_lkup=15001;
             next_sin_lkup=29155;
             next_cos_lkup=14956;
           end
    715  : begin
             curr_sin_lkup=29155;
             curr_cos_lkup=14956;
             next_sin_lkup=29178;
             next_cos_lkup=14912;
           end
    716  : begin
             curr_sin_lkup=29178;
             curr_cos_lkup=14912;
             next_sin_lkup=29201;
             next_cos_lkup=14867;
           end
    717  : begin
             curr_sin_lkup=29201;
             curr_cos_lkup=14867;
             next_sin_lkup=29223;
             next_cos_lkup=14822;
           end
    718  : begin
             curr_sin_lkup=29223;
             curr_cos_lkup=14822;
             next_sin_lkup=29246;
             next_cos_lkup=14777;
           end
    719  : begin
             curr_sin_lkup=29246;
             curr_cos_lkup=14777;
             next_sin_lkup=29269;
             next_cos_lkup=14732;
           end
    720  : begin
             curr_sin_lkup=29269;
             curr_cos_lkup=14732;
             next_sin_lkup=29291;
             next_cos_lkup=14687;
           end
    721  : begin
             curr_sin_lkup=29291;
             curr_cos_lkup=14687;
             next_sin_lkup=29314;
             next_cos_lkup=14642;
           end
    722  : begin
             curr_sin_lkup=29314;
             curr_cos_lkup=14642;
             next_sin_lkup=29336;
             next_cos_lkup=14598;
           end
    723  : begin
             curr_sin_lkup=29336;
             curr_cos_lkup=14598;
             next_sin_lkup=29359;
             next_cos_lkup=14552;
           end
    724  : begin
             curr_sin_lkup=29359;
             curr_cos_lkup=14552;
             next_sin_lkup=29381;
             next_cos_lkup=14507;
           end
    725  : begin
             curr_sin_lkup=29381;
             curr_cos_lkup=14507;
             next_sin_lkup=29403;
             next_cos_lkup=14462;
           end
    726  : begin
             curr_sin_lkup=29403;
             curr_cos_lkup=14462;
             next_sin_lkup=29425;
             next_cos_lkup=14417;
           end
    727  : begin
             curr_sin_lkup=29425;
             curr_cos_lkup=14417;
             next_sin_lkup=29447;
             next_cos_lkup=14372;
           end
    728  : begin
             curr_sin_lkup=29447;
             curr_cos_lkup=14372;
             next_sin_lkup=29469;
             next_cos_lkup=14327;
           end
    729  : begin
             curr_sin_lkup=29469;
             curr_cos_lkup=14327;
             next_sin_lkup=29491;
             next_cos_lkup=14282;
           end
    730  : begin
             curr_sin_lkup=29491;
             curr_cos_lkup=14282;
             next_sin_lkup=29513;
             next_cos_lkup=14236;
           end
    731  : begin
             curr_sin_lkup=29513;
             curr_cos_lkup=14236;
             next_sin_lkup=29535;
             next_cos_lkup=14191;
           end
    732  : begin
             curr_sin_lkup=29535;
             curr_cos_lkup=14191;
             next_sin_lkup=29557;
             next_cos_lkup=14146;
           end
    733  : begin
             curr_sin_lkup=29557;
             curr_cos_lkup=14146;
             next_sin_lkup=29578;
             next_cos_lkup=14100;
           end
    734  : begin
             curr_sin_lkup=29578;
             curr_cos_lkup=14100;
             next_sin_lkup=29600;
             next_cos_lkup=14055;
           end
    735  : begin
             curr_sin_lkup=29600;
             curr_cos_lkup=14055;
             next_sin_lkup=29621;
             next_cos_lkup=14010;
           end
    736  : begin
             curr_sin_lkup=29621;
             curr_cos_lkup=14010;
             next_sin_lkup=29643;
             next_cos_lkup=13964;
           end
    737  : begin
             curr_sin_lkup=29643;
             curr_cos_lkup=13964;
             next_sin_lkup=29664;
             next_cos_lkup=13919;
           end
    738  : begin
             curr_sin_lkup=29664;
             curr_cos_lkup=13919;
             next_sin_lkup=29686;
             next_cos_lkup=13873;
           end
    739  : begin
             curr_sin_lkup=29686;
             curr_cos_lkup=13873;
             next_sin_lkup=29707;
             next_cos_lkup=13828;
           end
    740  : begin
             curr_sin_lkup=29707;
             curr_cos_lkup=13828;
             next_sin_lkup=29728;
             next_cos_lkup=13782;
           end
    741  : begin
             curr_sin_lkup=29728;
             curr_cos_lkup=13782;
             next_sin_lkup=29749;
             next_cos_lkup=13736;
           end
    742  : begin
             curr_sin_lkup=29749;
             curr_cos_lkup=13736;
             next_sin_lkup=29770;
             next_cos_lkup=13691;
           end
    743  : begin
             curr_sin_lkup=29770;
             curr_cos_lkup=13691;
             next_sin_lkup=29791;
             next_cos_lkup=13645;
           end
    744  : begin
             curr_sin_lkup=29791;
             curr_cos_lkup=13645;
             next_sin_lkup=29812;
             next_cos_lkup=13599;
           end
    745  : begin
             curr_sin_lkup=29812;
             curr_cos_lkup=13599;
             next_sin_lkup=29833;
             next_cos_lkup=13554;
           end
    746  : begin
             curr_sin_lkup=29833;
             curr_cos_lkup=13554;
             next_sin_lkup=29854;
             next_cos_lkup=13508;
           end
    747  : begin
             curr_sin_lkup=29854;
             curr_cos_lkup=13508;
             next_sin_lkup=29874;
             next_cos_lkup=13462;
           end
    748  : begin
             curr_sin_lkup=29874;
             curr_cos_lkup=13462;
             next_sin_lkup=29895;
             next_cos_lkup=13416;
           end
    749  : begin
             curr_sin_lkup=29895;
             curr_cos_lkup=13416;
             next_sin_lkup=29915;
             next_cos_lkup=13370;
           end
    750  : begin
             curr_sin_lkup=29915;
             curr_cos_lkup=13370;
             next_sin_lkup=29936;
             next_cos_lkup=13324;
           end
    751  : begin
             curr_sin_lkup=29936;
             curr_cos_lkup=13324;
             next_sin_lkup=29956;
             next_cos_lkup=13278;
           end
    752  : begin
             curr_sin_lkup=29956;
             curr_cos_lkup=13278;
             next_sin_lkup=29977;
             next_cos_lkup=13232;
           end
    753  : begin
             curr_sin_lkup=29977;
             curr_cos_lkup=13232;
             next_sin_lkup=29997;
             next_cos_lkup=13186;
           end
    754  : begin
             curr_sin_lkup=29997;
             curr_cos_lkup=13186;
             next_sin_lkup=30017;
             next_cos_lkup=13140;
           end
    755  : begin
             curr_sin_lkup=30017;
             curr_cos_lkup=13140;
             next_sin_lkup=30037;
             next_cos_lkup=13094;
           end
    756  : begin
             curr_sin_lkup=30037;
             curr_cos_lkup=13094;
             next_sin_lkup=30057;
             next_cos_lkup=13048;
           end
    757  : begin
             curr_sin_lkup=30057;
             curr_cos_lkup=13048;
             next_sin_lkup=30077;
             next_cos_lkup=13002;
           end
    758  : begin
             curr_sin_lkup=30077;
             curr_cos_lkup=13002;
             next_sin_lkup=30097;
             next_cos_lkup=12956;
           end
    759  : begin
             curr_sin_lkup=30097;
             curr_cos_lkup=12956;
             next_sin_lkup=30117;
             next_cos_lkup=12910;
           end
    760  : begin
             curr_sin_lkup=30117;
             curr_cos_lkup=12910;
             next_sin_lkup=30137;
             next_cos_lkup=12864;
           end
    761  : begin
             curr_sin_lkup=30137;
             curr_cos_lkup=12864;
             next_sin_lkup=30156;
             next_cos_lkup=12817;
           end
    762  : begin
             curr_sin_lkup=30156;
             curr_cos_lkup=12817;
             next_sin_lkup=30176;
             next_cos_lkup=12771;
           end
    763  : begin
             curr_sin_lkup=30176;
             curr_cos_lkup=12771;
             next_sin_lkup=30196;
             next_cos_lkup=12725;
           end
    764  : begin
             curr_sin_lkup=30196;
             curr_cos_lkup=12725;
             next_sin_lkup=30215;
             next_cos_lkup=12678;
           end
    765  : begin
             curr_sin_lkup=30215;
             curr_cos_lkup=12678;
             next_sin_lkup=30235;
             next_cos_lkup=12632;
           end
    766  : begin
             curr_sin_lkup=30235;
             curr_cos_lkup=12632;
             next_sin_lkup=30254;
             next_cos_lkup=12586;
           end
    767  : begin
             curr_sin_lkup=30254;
             curr_cos_lkup=12586;
             next_sin_lkup=30273;
             next_cos_lkup=12539;
           end
    768  : begin
             curr_sin_lkup=30273;
             curr_cos_lkup=12539;
             next_sin_lkup=30292;
             next_cos_lkup=12493;
           end
    769  : begin
             curr_sin_lkup=30292;
             curr_cos_lkup=12493;
             next_sin_lkup=30312;
             next_cos_lkup=12446;
           end
    770  : begin
             curr_sin_lkup=30312;
             curr_cos_lkup=12446;
             next_sin_lkup=30331;
             next_cos_lkup=12400;
           end
    771  : begin
             curr_sin_lkup=30331;
             curr_cos_lkup=12400;
             next_sin_lkup=30350;
             next_cos_lkup=12353;
           end
    772  : begin
             curr_sin_lkup=30350;
             curr_cos_lkup=12353;
             next_sin_lkup=30368;
             next_cos_lkup=12307;
           end
    773  : begin
             curr_sin_lkup=30368;
             curr_cos_lkup=12307;
             next_sin_lkup=30387;
             next_cos_lkup=12260;
           end
    774  : begin
             curr_sin_lkup=30387;
             curr_cos_lkup=12260;
             next_sin_lkup=30406;
             next_cos_lkup=12213;
           end
    775  : begin
             curr_sin_lkup=30406;
             curr_cos_lkup=12213;
             next_sin_lkup=30425;
             next_cos_lkup=12167;
           end
    776  : begin
             curr_sin_lkup=30425;
             curr_cos_lkup=12167;
             next_sin_lkup=30443;
             next_cos_lkup=12120;
           end
    777  : begin
             curr_sin_lkup=30443;
             curr_cos_lkup=12120;
             next_sin_lkup=30462;
             next_cos_lkup=12073;
           end
    778  : begin
             curr_sin_lkup=30462;
             curr_cos_lkup=12073;
             next_sin_lkup=30480;
             next_cos_lkup=12027;
           end
    779  : begin
             curr_sin_lkup=30480;
             curr_cos_lkup=12027;
             next_sin_lkup=30499;
             next_cos_lkup=11980;
           end
    780  : begin
             curr_sin_lkup=30499;
             curr_cos_lkup=11980;
             next_sin_lkup=30517;
             next_cos_lkup=11933;
           end
    781  : begin
             curr_sin_lkup=30517;
             curr_cos_lkup=11933;
             next_sin_lkup=30535;
             next_cos_lkup=11886;
           end
    782  : begin
             curr_sin_lkup=30535;
             curr_cos_lkup=11886;
             next_sin_lkup=30554;
             next_cos_lkup=11839;
           end
    783  : begin
             curr_sin_lkup=30554;
             curr_cos_lkup=11839;
             next_sin_lkup=30572;
             next_cos_lkup=11793;
           end
    784  : begin
             curr_sin_lkup=30572;
             curr_cos_lkup=11793;
             next_sin_lkup=30590;
             next_cos_lkup=11746;
           end
    785  : begin
             curr_sin_lkup=30590;
             curr_cos_lkup=11746;
             next_sin_lkup=30608;
             next_cos_lkup=11699;
           end
    786  : begin
             curr_sin_lkup=30608;
             curr_cos_lkup=11699;
             next_sin_lkup=30626;
             next_cos_lkup=11652;
           end
    787  : begin
             curr_sin_lkup=30626;
             curr_cos_lkup=11652;
             next_sin_lkup=30644;
             next_cos_lkup=11605;
           end
    788  : begin
             curr_sin_lkup=30644;
             curr_cos_lkup=11605;
             next_sin_lkup=30661;
             next_cos_lkup=11558;
           end
    789  : begin
             curr_sin_lkup=30661;
             curr_cos_lkup=11558;
             next_sin_lkup=30679;
             next_cos_lkup=11511;
           end
    790  : begin
             curr_sin_lkup=30679;
             curr_cos_lkup=11511;
             next_sin_lkup=30697;
             next_cos_lkup=11464;
           end
    791  : begin
             curr_sin_lkup=30697;
             curr_cos_lkup=11464;
             next_sin_lkup=30714;
             next_cos_lkup=11416;
           end
    792  : begin
             curr_sin_lkup=30714;
             curr_cos_lkup=11416;
             next_sin_lkup=30732;
             next_cos_lkup=11369;
           end
    793  : begin
             curr_sin_lkup=30732;
             curr_cos_lkup=11369;
             next_sin_lkup=30749;
             next_cos_lkup=11322;
           end
    794  : begin
             curr_sin_lkup=30749;
             curr_cos_lkup=11322;
             next_sin_lkup=30766;
             next_cos_lkup=11275;
           end
    795  : begin
             curr_sin_lkup=30766;
             curr_cos_lkup=11275;
             next_sin_lkup=30784;
             next_cos_lkup=11228;
           end
    796  : begin
             curr_sin_lkup=30784;
             curr_cos_lkup=11228;
             next_sin_lkup=30801;
             next_cos_lkup=11181;
           end
    797  : begin
             curr_sin_lkup=30801;
             curr_cos_lkup=11181;
             next_sin_lkup=30818;
             next_cos_lkup=11133;
           end
    798  : begin
             curr_sin_lkup=30818;
             curr_cos_lkup=11133;
             next_sin_lkup=30835;
             next_cos_lkup=11086;
           end
    799  : begin
             curr_sin_lkup=30835;
             curr_cos_lkup=11086;
             next_sin_lkup=30852;
             next_cos_lkup=11039;
           end
    800  : begin
             curr_sin_lkup=30852;
             curr_cos_lkup=11039;
             next_sin_lkup=30869;
             next_cos_lkup=10991;
           end
    801  : begin
             curr_sin_lkup=30869;
             curr_cos_lkup=10991;
             next_sin_lkup=30886;
             next_cos_lkup=10944;
           end
    802  : begin
             curr_sin_lkup=30886;
             curr_cos_lkup=10944;
             next_sin_lkup=30902;
             next_cos_lkup=10897;
           end
    803  : begin
             curr_sin_lkup=30902;
             curr_cos_lkup=10897;
             next_sin_lkup=30919;
             next_cos_lkup=10849;
           end
    804  : begin
             curr_sin_lkup=30919;
             curr_cos_lkup=10849;
             next_sin_lkup=30936;
             next_cos_lkup=10802;
           end
    805  : begin
             curr_sin_lkup=30936;
             curr_cos_lkup=10802;
             next_sin_lkup=30952;
             next_cos_lkup=10754;
           end
    806  : begin
             curr_sin_lkup=30952;
             curr_cos_lkup=10754;
             next_sin_lkup=30969;
             next_cos_lkup=10707;
           end
    807  : begin
             curr_sin_lkup=30969;
             curr_cos_lkup=10707;
             next_sin_lkup=30985;
             next_cos_lkup=10659;
           end
    808  : begin
             curr_sin_lkup=30985;
             curr_cos_lkup=10659;
             next_sin_lkup=31001;
             next_cos_lkup=10612;
           end
    809  : begin
             curr_sin_lkup=31001;
             curr_cos_lkup=10612;
             next_sin_lkup=31018;
             next_cos_lkup=10564;
           end
    810  : begin
             curr_sin_lkup=31018;
             curr_cos_lkup=10564;
             next_sin_lkup=31034;
             next_cos_lkup=10517;
           end
    811  : begin
             curr_sin_lkup=31034;
             curr_cos_lkup=10517;
             next_sin_lkup=31050;
             next_cos_lkup=10469;
           end
    812  : begin
             curr_sin_lkup=31050;
             curr_cos_lkup=10469;
             next_sin_lkup=31066;
             next_cos_lkup=10421;
           end
    813  : begin
             curr_sin_lkup=31066;
             curr_cos_lkup=10421;
             next_sin_lkup=31082;
             next_cos_lkup=10374;
           end
    814  : begin
             curr_sin_lkup=31082;
             curr_cos_lkup=10374;
             next_sin_lkup=31098;
             next_cos_lkup=10326;
           end
    815  : begin
             curr_sin_lkup=31098;
             curr_cos_lkup=10326;
             next_sin_lkup=31114;
             next_cos_lkup=10278;
           end
    816  : begin
             curr_sin_lkup=31114;
             curr_cos_lkup=10278;
             next_sin_lkup=31129;
             next_cos_lkup=10230;
           end
    817  : begin
             curr_sin_lkup=31129;
             curr_cos_lkup=10230;
             next_sin_lkup=31145;
             next_cos_lkup=10183;
           end
    818  : begin
             curr_sin_lkup=31145;
             curr_cos_lkup=10183;
             next_sin_lkup=31161;
             next_cos_lkup=10135;
           end
    819  : begin
             curr_sin_lkup=31161;
             curr_cos_lkup=10135;
             next_sin_lkup=31176;
             next_cos_lkup=10087;
           end
    820  : begin
             curr_sin_lkup=31176;
             curr_cos_lkup=10087;
             next_sin_lkup=31192;
             next_cos_lkup=10039;
           end
    821  : begin
             curr_sin_lkup=31192;
             curr_cos_lkup=10039;
             next_sin_lkup=31207;
             next_cos_lkup=9991;
           end
    822  : begin
             curr_sin_lkup=31207;
             curr_cos_lkup=9991;
             next_sin_lkup=31222;
             next_cos_lkup=9944;
           end
    823  : begin
             curr_sin_lkup=31222;
             curr_cos_lkup=9944;
             next_sin_lkup=31237;
             next_cos_lkup=9896;
           end
    824  : begin
             curr_sin_lkup=31237;
             curr_cos_lkup=9896;
             next_sin_lkup=31253;
             next_cos_lkup=9848;
           end
    825  : begin
             curr_sin_lkup=31253;
             curr_cos_lkup=9848;
             next_sin_lkup=31268;
             next_cos_lkup=9800;
           end
    826  : begin
             curr_sin_lkup=31268;
             curr_cos_lkup=9800;
             next_sin_lkup=31283;
             next_cos_lkup=9752;
           end
    827  : begin
             curr_sin_lkup=31283;
             curr_cos_lkup=9752;
             next_sin_lkup=31298;
             next_cos_lkup=9704;
           end
    828  : begin
             curr_sin_lkup=31298;
             curr_cos_lkup=9704;
             next_sin_lkup=31312;
             next_cos_lkup=9656;
           end
    829  : begin
             curr_sin_lkup=31312;
             curr_cos_lkup=9656;
             next_sin_lkup=31327;
             next_cos_lkup=9608;
           end
    830  : begin
             curr_sin_lkup=31327;
             curr_cos_lkup=9608;
             next_sin_lkup=31342;
             next_cos_lkup=9560;
           end
    831  : begin
             curr_sin_lkup=31342;
             curr_cos_lkup=9560;
             next_sin_lkup=31357;
             next_cos_lkup=9512;
           end
    832  : begin
             curr_sin_lkup=31357;
             curr_cos_lkup=9512;
             next_sin_lkup=31371;
             next_cos_lkup=9463;
           end
    833  : begin
             curr_sin_lkup=31371;
             curr_cos_lkup=9463;
             next_sin_lkup=31386;
             next_cos_lkup=9415;
           end
    834  : begin
             curr_sin_lkup=31386;
             curr_cos_lkup=9415;
             next_sin_lkup=31400;
             next_cos_lkup=9367;
           end
    835  : begin
             curr_sin_lkup=31400;
             curr_cos_lkup=9367;
             next_sin_lkup=31414;
             next_cos_lkup=9319;
           end
    836  : begin
             curr_sin_lkup=31414;
             curr_cos_lkup=9319;
             next_sin_lkup=31429;
             next_cos_lkup=9271;
           end
    837  : begin
             curr_sin_lkup=31429;
             curr_cos_lkup=9271;
             next_sin_lkup=31443;
             next_cos_lkup=9223;
           end
    838  : begin
             curr_sin_lkup=31443;
             curr_cos_lkup=9223;
             next_sin_lkup=31457;
             next_cos_lkup=9174;
           end
    839  : begin
             curr_sin_lkup=31457;
             curr_cos_lkup=9174;
             next_sin_lkup=31471;
             next_cos_lkup=9126;
           end
    840  : begin
             curr_sin_lkup=31471;
             curr_cos_lkup=9126;
             next_sin_lkup=31485;
             next_cos_lkup=9078;
           end
    841  : begin
             curr_sin_lkup=31485;
             curr_cos_lkup=9078;
             next_sin_lkup=31499;
             next_cos_lkup=9029;
           end
    842  : begin
             curr_sin_lkup=31499;
             curr_cos_lkup=9029;
             next_sin_lkup=31513;
             next_cos_lkup=8981;
           end
    843  : begin
             curr_sin_lkup=31513;
             curr_cos_lkup=8981;
             next_sin_lkup=31526;
             next_cos_lkup=8933;
           end
    844  : begin
             curr_sin_lkup=31526;
             curr_cos_lkup=8933;
             next_sin_lkup=31540;
             next_cos_lkup=8884;
           end
    845  : begin
             curr_sin_lkup=31540;
             curr_cos_lkup=8884;
             next_sin_lkup=31554;
             next_cos_lkup=8836;
           end
    846  : begin
             curr_sin_lkup=31554;
             curr_cos_lkup=8836;
             next_sin_lkup=31567;
             next_cos_lkup=8788;
           end
    847  : begin
             curr_sin_lkup=31567;
             curr_cos_lkup=8788;
             next_sin_lkup=31581;
             next_cos_lkup=8739;
           end
    848  : begin
             curr_sin_lkup=31581;
             curr_cos_lkup=8739;
             next_sin_lkup=31594;
             next_cos_lkup=8691;
           end
    849  : begin
             curr_sin_lkup=31594;
             curr_cos_lkup=8691;
             next_sin_lkup=31607;
             next_cos_lkup=8642;
           end
    850  : begin
             curr_sin_lkup=31607;
             curr_cos_lkup=8642;
             next_sin_lkup=31620;
             next_cos_lkup=8594;
           end
    851  : begin
             curr_sin_lkup=31620;
             curr_cos_lkup=8594;
             next_sin_lkup=31634;
             next_cos_lkup=8545;
           end
    852  : begin
             curr_sin_lkup=31634;
             curr_cos_lkup=8545;
             next_sin_lkup=31647;
             next_cos_lkup=8497;
           end
    853  : begin
             curr_sin_lkup=31647;
             curr_cos_lkup=8497;
             next_sin_lkup=31660;
             next_cos_lkup=8448;
           end
    854  : begin
             curr_sin_lkup=31660;
             curr_cos_lkup=8448;
             next_sin_lkup=31673;
             next_cos_lkup=8400;
           end
    855  : begin
             curr_sin_lkup=31673;
             curr_cos_lkup=8400;
             next_sin_lkup=31685;
             next_cos_lkup=8351;
           end
    856  : begin
             curr_sin_lkup=31685;
             curr_cos_lkup=8351;
             next_sin_lkup=31698;
             next_cos_lkup=8302;
           end
    857  : begin
             curr_sin_lkup=31698;
             curr_cos_lkup=8302;
             next_sin_lkup=31711;
             next_cos_lkup=8254;
           end
    858  : begin
             curr_sin_lkup=31711;
             curr_cos_lkup=8254;
             next_sin_lkup=31723;
             next_cos_lkup=8205;
           end
    859  : begin
             curr_sin_lkup=31723;
             curr_cos_lkup=8205;
             next_sin_lkup=31736;
             next_cos_lkup=8156;
           end
    860  : begin
             curr_sin_lkup=31736;
             curr_cos_lkup=8156;
             next_sin_lkup=31749;
             next_cos_lkup=8108;
           end
    861  : begin
             curr_sin_lkup=31749;
             curr_cos_lkup=8108;
             next_sin_lkup=31761;
             next_cos_lkup=8059;
           end
    862  : begin
             curr_sin_lkup=31761;
             curr_cos_lkup=8059;
             next_sin_lkup=31773;
             next_cos_lkup=8010;
           end
    863  : begin
             curr_sin_lkup=31773;
             curr_cos_lkup=8010;
             next_sin_lkup=31785;
             next_cos_lkup=7961;
           end
    864  : begin
             curr_sin_lkup=31785;
             curr_cos_lkup=7961;
             next_sin_lkup=31798;
             next_cos_lkup=7913;
           end
    865  : begin
             curr_sin_lkup=31798;
             curr_cos_lkup=7913;
             next_sin_lkup=31810;
             next_cos_lkup=7864;
           end
    866  : begin
             curr_sin_lkup=31810;
             curr_cos_lkup=7864;
             next_sin_lkup=31822;
             next_cos_lkup=7815;
           end
    867  : begin
             curr_sin_lkup=31822;
             curr_cos_lkup=7815;
             next_sin_lkup=31834;
             next_cos_lkup=7766;
           end
    868  : begin
             curr_sin_lkup=31834;
             curr_cos_lkup=7766;
             next_sin_lkup=31846;
             next_cos_lkup=7717;
           end
    869  : begin
             curr_sin_lkup=31846;
             curr_cos_lkup=7717;
             next_sin_lkup=31857;
             next_cos_lkup=7669;
           end
    870  : begin
             curr_sin_lkup=31857;
             curr_cos_lkup=7669;
             next_sin_lkup=31869;
             next_cos_lkup=7620;
           end
    871  : begin
             curr_sin_lkup=31869;
             curr_cos_lkup=7620;
             next_sin_lkup=31881;
             next_cos_lkup=7571;
           end
    872  : begin
             curr_sin_lkup=31881;
             curr_cos_lkup=7571;
             next_sin_lkup=31892;
             next_cos_lkup=7522;
           end
    873  : begin
             curr_sin_lkup=31892;
             curr_cos_lkup=7522;
             next_sin_lkup=31904;
             next_cos_lkup=7473;
           end
    874  : begin
             curr_sin_lkup=31904;
             curr_cos_lkup=7473;
             next_sin_lkup=31915;
             next_cos_lkup=7424;
           end
    875  : begin
             curr_sin_lkup=31915;
             curr_cos_lkup=7424;
             next_sin_lkup=31927;
             next_cos_lkup=7375;
           end
    876  : begin
             curr_sin_lkup=31927;
             curr_cos_lkup=7375;
             next_sin_lkup=31938;
             next_cos_lkup=7326;
           end
    877  : begin
             curr_sin_lkup=31938;
             curr_cos_lkup=7326;
             next_sin_lkup=31949;
             next_cos_lkup=7277;
           end
    878  : begin
             curr_sin_lkup=31949;
             curr_cos_lkup=7277;
             next_sin_lkup=31960;
             next_cos_lkup=7228;
           end
    879  : begin
             curr_sin_lkup=31960;
             curr_cos_lkup=7228;
             next_sin_lkup=31971;
             next_cos_lkup=7179;
           end
    880  : begin
             curr_sin_lkup=31971;
             curr_cos_lkup=7179;
             next_sin_lkup=31982;
             next_cos_lkup=7130;
           end
    881  : begin
             curr_sin_lkup=31982;
             curr_cos_lkup=7130;
             next_sin_lkup=31993;
             next_cos_lkup=7081;
           end
    882  : begin
             curr_sin_lkup=31993;
             curr_cos_lkup=7081;
             next_sin_lkup=32004;
             next_cos_lkup=7032;
           end
    883  : begin
             curr_sin_lkup=32004;
             curr_cos_lkup=7032;
             next_sin_lkup=32015;
             next_cos_lkup=6983;
           end
    884  : begin
             curr_sin_lkup=32015;
             curr_cos_lkup=6983;
             next_sin_lkup=32025;
             next_cos_lkup=6934;
           end
    885  : begin
             curr_sin_lkup=32025;
             curr_cos_lkup=6934;
             next_sin_lkup=32036;
             next_cos_lkup=6884;
           end
    886  : begin
             curr_sin_lkup=32036;
             curr_cos_lkup=6884;
             next_sin_lkup=32047;
             next_cos_lkup=6835;
           end
    887  : begin
             curr_sin_lkup=32047;
             curr_cos_lkup=6835;
             next_sin_lkup=32057;
             next_cos_lkup=6786;
           end
    888  : begin
             curr_sin_lkup=32057;
             curr_cos_lkup=6786;
             next_sin_lkup=32067;
             next_cos_lkup=6737;
           end
    889  : begin
             curr_sin_lkup=32067;
             curr_cos_lkup=6737;
             next_sin_lkup=32078;
             next_cos_lkup=6688;
           end
    890  : begin
             curr_sin_lkup=32078;
             curr_cos_lkup=6688;
             next_sin_lkup=32088;
             next_cos_lkup=6639;
           end
    891  : begin
             curr_sin_lkup=32088;
             curr_cos_lkup=6639;
             next_sin_lkup=32098;
             next_cos_lkup=6589;
           end
    892  : begin
             curr_sin_lkup=32098;
             curr_cos_lkup=6589;
             next_sin_lkup=32108;
             next_cos_lkup=6540;
           end
    893  : begin
             curr_sin_lkup=32108;
             curr_cos_lkup=6540;
             next_sin_lkup=32118;
             next_cos_lkup=6491;
           end
    894  : begin
             curr_sin_lkup=32118;
             curr_cos_lkup=6491;
             next_sin_lkup=32128;
             next_cos_lkup=6442;
           end
    895  : begin
             curr_sin_lkup=32128;
             curr_cos_lkup=6442;
             next_sin_lkup=32138;
             next_cos_lkup=6392;
           end
    896  : begin
             curr_sin_lkup=32138;
             curr_cos_lkup=6392;
             next_sin_lkup=32148;
             next_cos_lkup=6343;
           end
    897  : begin
             curr_sin_lkup=32148;
             curr_cos_lkup=6343;
             next_sin_lkup=32157;
             next_cos_lkup=6294;
           end
    898  : begin
             curr_sin_lkup=32157;
             curr_cos_lkup=6294;
             next_sin_lkup=32167;
             next_cos_lkup=6244;
           end
    899  : begin
             curr_sin_lkup=32167;
             curr_cos_lkup=6244;
             next_sin_lkup=32176;
             next_cos_lkup=6195;
           end
    900  : begin
             curr_sin_lkup=32176;
             curr_cos_lkup=6195;
             next_sin_lkup=32186;
             next_cos_lkup=6146;
           end
    901  : begin
             curr_sin_lkup=32186;
             curr_cos_lkup=6146;
             next_sin_lkup=32195;
             next_cos_lkup=6096;
           end
    902  : begin
             curr_sin_lkup=32195;
             curr_cos_lkup=6096;
             next_sin_lkup=32205;
             next_cos_lkup=6047;
           end
    903  : begin
             curr_sin_lkup=32205;
             curr_cos_lkup=6047;
             next_sin_lkup=32214;
             next_cos_lkup=5997;
           end
    904  : begin
             curr_sin_lkup=32214;
             curr_cos_lkup=5997;
             next_sin_lkup=32223;
             next_cos_lkup=5948;
           end
    905  : begin
             curr_sin_lkup=32223;
             curr_cos_lkup=5948;
             next_sin_lkup=32232;
             next_cos_lkup=5898;
           end
    906  : begin
             curr_sin_lkup=32232;
             curr_cos_lkup=5898;
             next_sin_lkup=32241;
             next_cos_lkup=5849;
           end
    907  : begin
             curr_sin_lkup=32241;
             curr_cos_lkup=5849;
             next_sin_lkup=32250;
             next_cos_lkup=5800;
           end
    908  : begin
             curr_sin_lkup=32250;
             curr_cos_lkup=5800;
             next_sin_lkup=32259;
             next_cos_lkup=5750;
           end
    909  : begin
             curr_sin_lkup=32259;
             curr_cos_lkup=5750;
             next_sin_lkup=32268;
             next_cos_lkup=5701;
           end
    910  : begin
             curr_sin_lkup=32268;
             curr_cos_lkup=5701;
             next_sin_lkup=32276;
             next_cos_lkup=5651;
           end
    911  : begin
             curr_sin_lkup=32276;
             curr_cos_lkup=5651;
             next_sin_lkup=32285;
             next_cos_lkup=5602;
           end
    912  : begin
             curr_sin_lkup=32285;
             curr_cos_lkup=5602;
             next_sin_lkup=32294;
             next_cos_lkup=5552;
           end
    913  : begin
             curr_sin_lkup=32294;
             curr_cos_lkup=5552;
             next_sin_lkup=32302;
             next_cos_lkup=5503;
           end
    914  : begin
             curr_sin_lkup=32302;
             curr_cos_lkup=5503;
             next_sin_lkup=32311;
             next_cos_lkup=5453;
           end
    915  : begin
             curr_sin_lkup=32311;
             curr_cos_lkup=5453;
             next_sin_lkup=32319;
             next_cos_lkup=5403;
           end
    916  : begin
             curr_sin_lkup=32319;
             curr_cos_lkup=5403;
             next_sin_lkup=32327;
             next_cos_lkup=5354;
           end
    917  : begin
             curr_sin_lkup=32327;
             curr_cos_lkup=5354;
             next_sin_lkup=32335;
             next_cos_lkup=5304;
           end
    918  : begin
             curr_sin_lkup=32335;
             curr_cos_lkup=5304;
             next_sin_lkup=32343;
             next_cos_lkup=5255;
           end
    919  : begin
             curr_sin_lkup=32343;
             curr_cos_lkup=5255;
             next_sin_lkup=32351;
             next_cos_lkup=5205;
           end
    920  : begin
             curr_sin_lkup=32351;
             curr_cos_lkup=5205;
             next_sin_lkup=32359;
             next_cos_lkup=5155;
           end
    921  : begin
             curr_sin_lkup=32359;
             curr_cos_lkup=5155;
             next_sin_lkup=32367;
             next_cos_lkup=5106;
           end
    922  : begin
             curr_sin_lkup=32367;
             curr_cos_lkup=5106;
             next_sin_lkup=32375;
             next_cos_lkup=5056;
           end
    923  : begin
             curr_sin_lkup=32375;
             curr_cos_lkup=5056;
             next_sin_lkup=32383;
             next_cos_lkup=5006;
           end
    924  : begin
             curr_sin_lkup=32383;
             curr_cos_lkup=5006;
             next_sin_lkup=32390;
             next_cos_lkup=4957;
           end
    925  : begin
             curr_sin_lkup=32390;
             curr_cos_lkup=4957;
             next_sin_lkup=32398;
             next_cos_lkup=4907;
           end
    926  : begin
             curr_sin_lkup=32398;
             curr_cos_lkup=4907;
             next_sin_lkup=32405;
             next_cos_lkup=4857;
           end
    927  : begin
             curr_sin_lkup=32405;
             curr_cos_lkup=4857;
             next_sin_lkup=32413;
             next_cos_lkup=4808;
           end
    928  : begin
             curr_sin_lkup=32413;
             curr_cos_lkup=4808;
             next_sin_lkup=32420;
             next_cos_lkup=4758;
           end
    929  : begin
             curr_sin_lkup=32420;
             curr_cos_lkup=4758;
             next_sin_lkup=32427;
             next_cos_lkup=4708;
           end
    930  : begin
             curr_sin_lkup=32427;
             curr_cos_lkup=4708;
             next_sin_lkup=32435;
             next_cos_lkup=4658;
           end
    931  : begin
             curr_sin_lkup=32435;
             curr_cos_lkup=4658;
             next_sin_lkup=32442;
             next_cos_lkup=4609;
           end
    932  : begin
             curr_sin_lkup=32442;
             curr_cos_lkup=4609;
             next_sin_lkup=32449;
             next_cos_lkup=4559;
           end
    933  : begin
             curr_sin_lkup=32449;
             curr_cos_lkup=4559;
             next_sin_lkup=32456;
             next_cos_lkup=4509;
           end
    934  : begin
             curr_sin_lkup=32456;
             curr_cos_lkup=4509;
             next_sin_lkup=32463;
             next_cos_lkup=4459;
           end
    935  : begin
             curr_sin_lkup=32463;
             curr_cos_lkup=4459;
             next_sin_lkup=32469;
             next_cos_lkup=4409;
           end
    936  : begin
             curr_sin_lkup=32469;
             curr_cos_lkup=4409;
             next_sin_lkup=32476;
             next_cos_lkup=4360;
           end
    937  : begin
             curr_sin_lkup=32476;
             curr_cos_lkup=4360;
             next_sin_lkup=32483;
             next_cos_lkup=4310;
           end
    938  : begin
             curr_sin_lkup=32483;
             curr_cos_lkup=4310;
             next_sin_lkup=32489;
             next_cos_lkup=4260;
           end
    939  : begin
             curr_sin_lkup=32489;
             curr_cos_lkup=4260;
             next_sin_lkup=32496;
             next_cos_lkup=4210;
           end
    940  : begin
             curr_sin_lkup=32496;
             curr_cos_lkup=4210;
             next_sin_lkup=32502;
             next_cos_lkup=4160;
           end
    941  : begin
             curr_sin_lkup=32502;
             curr_cos_lkup=4160;
             next_sin_lkup=32509;
             next_cos_lkup=4110;
           end
    942  : begin
             curr_sin_lkup=32509;
             curr_cos_lkup=4110;
             next_sin_lkup=32515;
             next_cos_lkup=4061;
           end
    943  : begin
             curr_sin_lkup=32515;
             curr_cos_lkup=4061;
             next_sin_lkup=32521;
             next_cos_lkup=4011;
           end
    944  : begin
             curr_sin_lkup=32521;
             curr_cos_lkup=4011;
             next_sin_lkup=32527;
             next_cos_lkup=3961;
           end
    945  : begin
             curr_sin_lkup=32527;
             curr_cos_lkup=3961;
             next_sin_lkup=32533;
             next_cos_lkup=3911;
           end
    946  : begin
             curr_sin_lkup=32533;
             curr_cos_lkup=3911;
             next_sin_lkup=32539;
             next_cos_lkup=3861;
           end
    947  : begin
             curr_sin_lkup=32539;
             curr_cos_lkup=3861;
             next_sin_lkup=32545;
             next_cos_lkup=3811;
           end
    948  : begin
             curr_sin_lkup=32545;
             curr_cos_lkup=3811;
             next_sin_lkup=32551;
             next_cos_lkup=3761;
           end
    949  : begin
             curr_sin_lkup=32551;
             curr_cos_lkup=3761;
             next_sin_lkup=32557;
             next_cos_lkup=3711;
           end
    950  : begin
             curr_sin_lkup=32557;
             curr_cos_lkup=3711;
             next_sin_lkup=32562;
             next_cos_lkup=3661;
           end
    951  : begin
             curr_sin_lkup=32562;
             curr_cos_lkup=3661;
             next_sin_lkup=32568;
             next_cos_lkup=3611;
           end
    952  : begin
             curr_sin_lkup=32568;
             curr_cos_lkup=3611;
             next_sin_lkup=32573;
             next_cos_lkup=3561;
           end
    953  : begin
             curr_sin_lkup=32573;
             curr_cos_lkup=3561;
             next_sin_lkup=32579;
             next_cos_lkup=3511;
           end
    954  : begin
             curr_sin_lkup=32579;
             curr_cos_lkup=3511;
             next_sin_lkup=32584;
             next_cos_lkup=3461;
           end
    955  : begin
             curr_sin_lkup=32584;
             curr_cos_lkup=3461;
             next_sin_lkup=32589;
             next_cos_lkup=3411;
           end
    956  : begin
             curr_sin_lkup=32589;
             curr_cos_lkup=3411;
             next_sin_lkup=32595;
             next_cos_lkup=3361;
           end
    957  : begin
             curr_sin_lkup=32595;
             curr_cos_lkup=3361;
             next_sin_lkup=32600;
             next_cos_lkup=3311;
           end
    958  : begin
             curr_sin_lkup=32600;
             curr_cos_lkup=3311;
             next_sin_lkup=32605;
             next_cos_lkup=3261;
           end
    959  : begin
             curr_sin_lkup=32605;
             curr_cos_lkup=3261;
             next_sin_lkup=32610;
             next_cos_lkup=3211;
           end
    960  : begin
             curr_sin_lkup=32610;
             curr_cos_lkup=3211;
             next_sin_lkup=32615;
             next_cos_lkup=3161;
           end
    961  : begin
             curr_sin_lkup=32615;
             curr_cos_lkup=3161;
             next_sin_lkup=32619;
             next_cos_lkup=3111;
           end
    962  : begin
             curr_sin_lkup=32619;
             curr_cos_lkup=3111;
             next_sin_lkup=32624;
             next_cos_lkup=3061;
           end
    963  : begin
             curr_sin_lkup=32624;
             curr_cos_lkup=3061;
             next_sin_lkup=32629;
             next_cos_lkup=3011;
           end
    964  : begin
             curr_sin_lkup=32629;
             curr_cos_lkup=3011;
             next_sin_lkup=32633;
             next_cos_lkup=2961;
           end
    965  : begin
             curr_sin_lkup=32633;
             curr_cos_lkup=2961;
             next_sin_lkup=32638;
             next_cos_lkup=2911;
           end
    966  : begin
             curr_sin_lkup=32638;
             curr_cos_lkup=2911;
             next_sin_lkup=32642;
             next_cos_lkup=2861;
           end
    967  : begin
             curr_sin_lkup=32642;
             curr_cos_lkup=2861;
             next_sin_lkup=32647;
             next_cos_lkup=2811;
           end
    968  : begin
             curr_sin_lkup=32647;
             curr_cos_lkup=2811;
             next_sin_lkup=32651;
             next_cos_lkup=2761;
           end
    969  : begin
             curr_sin_lkup=32651;
             curr_cos_lkup=2761;
             next_sin_lkup=32655;
             next_cos_lkup=2711;
           end
    970  : begin
             curr_sin_lkup=32655;
             curr_cos_lkup=2711;
             next_sin_lkup=32659;
             next_cos_lkup=2661;
           end
    971  : begin
             curr_sin_lkup=32659;
             curr_cos_lkup=2661;
             next_sin_lkup=32663;
             next_cos_lkup=2611;
           end
    972  : begin
             curr_sin_lkup=32663;
             curr_cos_lkup=2611;
             next_sin_lkup=32667;
             next_cos_lkup=2560;
           end
    973  : begin
             curr_sin_lkup=32667;
             curr_cos_lkup=2560;
             next_sin_lkup=32671;
             next_cos_lkup=2510;
           end
    974  : begin
             curr_sin_lkup=32671;
             curr_cos_lkup=2510;
             next_sin_lkup=32675;
             next_cos_lkup=2460;
           end
    975  : begin
             curr_sin_lkup=32675;
             curr_cos_lkup=2460;
             next_sin_lkup=32679;
             next_cos_lkup=2410;
           end
    976  : begin
             curr_sin_lkup=32679;
             curr_cos_lkup=2410;
             next_sin_lkup=32682;
             next_cos_lkup=2360;
           end
    977  : begin
             curr_sin_lkup=32682;
             curr_cos_lkup=2360;
             next_sin_lkup=32686;
             next_cos_lkup=2310;
           end
    978  : begin
             curr_sin_lkup=32686;
             curr_cos_lkup=2310;
             next_sin_lkup=32689;
             next_cos_lkup=2260;
           end
    979  : begin
             curr_sin_lkup=32689;
             curr_cos_lkup=2260;
             next_sin_lkup=32693;
             next_cos_lkup=2210;
           end
    980  : begin
             curr_sin_lkup=32693;
             curr_cos_lkup=2210;
             next_sin_lkup=32696;
             next_cos_lkup=2159;
           end
    981  : begin
             curr_sin_lkup=32696;
             curr_cos_lkup=2159;
             next_sin_lkup=32700;
             next_cos_lkup=2109;
           end
    982  : begin
             curr_sin_lkup=32700;
             curr_cos_lkup=2109;
             next_sin_lkup=32703;
             next_cos_lkup=2059;
           end
    983  : begin
             curr_sin_lkup=32703;
             curr_cos_lkup=2059;
             next_sin_lkup=32706;
             next_cos_lkup=2009;
           end
    984  : begin
             curr_sin_lkup=32706;
             curr_cos_lkup=2009;
             next_sin_lkup=32709;
             next_cos_lkup=1959;
           end
    985  : begin
             curr_sin_lkup=32709;
             curr_cos_lkup=1959;
             next_sin_lkup=32712;
             next_cos_lkup=1909;
           end
    986  : begin
             curr_sin_lkup=32712;
             curr_cos_lkup=1909;
             next_sin_lkup=32715;
             next_cos_lkup=1858;
           end
    987  : begin
             curr_sin_lkup=32715;
             curr_cos_lkup=1858;
             next_sin_lkup=32718;
             next_cos_lkup=1808;
           end
    988  : begin
             curr_sin_lkup=32718;
             curr_cos_lkup=1808;
             next_sin_lkup=32720;
             next_cos_lkup=1758;
           end
    989  : begin
             curr_sin_lkup=32720;
             curr_cos_lkup=1758;
             next_sin_lkup=32723;
             next_cos_lkup=1708;
           end
    990  : begin
             curr_sin_lkup=32723;
             curr_cos_lkup=1708;
             next_sin_lkup=32726;
             next_cos_lkup=1658;
           end
    991  : begin
             curr_sin_lkup=32726;
             curr_cos_lkup=1658;
             next_sin_lkup=32728;
             next_cos_lkup=1607;
           end
    992  : begin
             curr_sin_lkup=32728;
             curr_cos_lkup=1607;
             next_sin_lkup=32730;
             next_cos_lkup=1557;
           end
    993  : begin
             curr_sin_lkup=32730;
             curr_cos_lkup=1557;
             next_sin_lkup=32733;
             next_cos_lkup=1507;
           end
    994  : begin
             curr_sin_lkup=32733;
             curr_cos_lkup=1507;
             next_sin_lkup=32735;
             next_cos_lkup=1457;
           end
    995  : begin
             curr_sin_lkup=32735;
             curr_cos_lkup=1457;
             next_sin_lkup=32737;
             next_cos_lkup=1407;
           end
    996  : begin
             curr_sin_lkup=32737;
             curr_cos_lkup=1407;
             next_sin_lkup=32739;
             next_cos_lkup=1356;
           end
    997  : begin
             curr_sin_lkup=32739;
             curr_cos_lkup=1356;
             next_sin_lkup=32741;
             next_cos_lkup=1306;
           end
    998  : begin
             curr_sin_lkup=32741;
             curr_cos_lkup=1306;
             next_sin_lkup=32743;
             next_cos_lkup=1256;
           end
    999  : begin
             curr_sin_lkup=32743;
             curr_cos_lkup=1256;
             next_sin_lkup=32745;
             next_cos_lkup=1206;
           end
    1000 : begin
             curr_sin_lkup=32745;
             curr_cos_lkup=1206;
             next_sin_lkup=32747;
             next_cos_lkup=1155;
           end
    1001 : begin
             curr_sin_lkup=32747;
             curr_cos_lkup=1155;
             next_sin_lkup=32749;
             next_cos_lkup=1105;
           end
    1002 : begin
             curr_sin_lkup=32749;
             curr_cos_lkup=1105;
             next_sin_lkup=32750;
             next_cos_lkup=1055;
           end
    1003 : begin
             curr_sin_lkup=32750;
             curr_cos_lkup=1055;
             next_sin_lkup=32752;
             next_cos_lkup=1005;
           end
    1004 : begin
             curr_sin_lkup=32752;
             curr_cos_lkup=1005;
             next_sin_lkup=32754;
             next_cos_lkup=954;
           end
    1005 : begin
             curr_sin_lkup=32754;
             curr_cos_lkup=954;
             next_sin_lkup=32755;
             next_cos_lkup=904;
           end
    1006 : begin
             curr_sin_lkup=32755;
             curr_cos_lkup=904;
             next_sin_lkup=32756;
             next_cos_lkup=854;
           end
    1007 : begin
             curr_sin_lkup=32756;
             curr_cos_lkup=854;
             next_sin_lkup=32758;
             next_cos_lkup=804;
           end
    1008 : begin
             curr_sin_lkup=32758;
             curr_cos_lkup=804;
             next_sin_lkup=32759;
             next_cos_lkup=753;
           end
    1009 : begin
             curr_sin_lkup=32759;
             curr_cos_lkup=753;
             next_sin_lkup=32760;
             next_cos_lkup=703;
           end
    1010 : begin
             curr_sin_lkup=32760;
             curr_cos_lkup=703;
             next_sin_lkup=32761;
             next_cos_lkup=653;
           end
    1011 : begin
             curr_sin_lkup=32761;
             curr_cos_lkup=653;
             next_sin_lkup=32762;
             next_cos_lkup=603;
           end
    1012 : begin
             curr_sin_lkup=32762;
             curr_cos_lkup=603;
             next_sin_lkup=32763;
             next_cos_lkup=552;
           end
    1013 : begin
             curr_sin_lkup=32763;
             curr_cos_lkup=552;
             next_sin_lkup=32764;
             next_cos_lkup=502;
           end
    1014 : begin
             curr_sin_lkup=32764;
             curr_cos_lkup=502;
             next_sin_lkup=32764;
             next_cos_lkup=452;
           end
    1015 : begin
             curr_sin_lkup=32764;
             curr_cos_lkup=452;
             next_sin_lkup=32765;
             next_cos_lkup=402;
           end
    1016 : begin
             curr_sin_lkup=32765;
             curr_cos_lkup=402;
             next_sin_lkup=32766;
             next_cos_lkup=351;
           end
    1017 : begin
             curr_sin_lkup=32766;
             curr_cos_lkup=351;
             next_sin_lkup=32766;
             next_cos_lkup=301;
           end
    1018 : begin
             curr_sin_lkup=32766;
             curr_cos_lkup=301;
             next_sin_lkup=32767;
             next_cos_lkup=251;
           end
    1019 : begin
             curr_sin_lkup=32767;
             curr_cos_lkup=251;
             next_sin_lkup=32767;
             next_cos_lkup=201;
           end
    1020 : begin
             curr_sin_lkup=32767;
             curr_cos_lkup=201;
             next_sin_lkup=32767;
             next_cos_lkup=150;
           end
    1021 : begin
             curr_sin_lkup=32767;
             curr_cos_lkup=150;
             next_sin_lkup=32767;
             next_cos_lkup=100;
           end
    1022 : begin
             curr_sin_lkup=32767;
             curr_cos_lkup=100;
             next_sin_lkup=32767;
             next_cos_lkup=50;
           end
    1023 : begin
             curr_sin_lkup=32767;
             curr_cos_lkup=50;
             next_sin_lkup=32767;
             next_cos_lkup=0;
           end
  endcase
 end // always @ (*)
endmodule
