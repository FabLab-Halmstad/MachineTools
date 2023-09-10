%
(1001)
(OP1)
(Machine)
(  vendor: Raptor)
(  model: 1200/S20)
(  description: RaptorX-SL)
N10 G90 G94
N15 G17
N20 G21
(Comment)
N25 M00
N30 M01
(Measure current tool)
N35 PRINT"Measuring current tool"
N40 G79
(Verify)
N45 G90 G53 G00 Z0.0
N50 ASKBOOL"Verify work area"
(Clean)
N55 G90 G53 G00 Z0.0
N60 G90 G53 G00 X1000.0 Y1000.0
N65 ASKBOOL"Clean work area"
(Measure all tools in magazine)
N70 PRINT"Measuring all tools"
N75 T1 M06
N80 G79
N85 T2 M06
N90 G79
N95 T3 M06
N100 G79
N105 T4 M06
N110 G79
N115 T5 M06
N120 G79
N125 T6 M06
N130 G79
N135 PRINT"Printed message"
N140 ASKBOOL"Displayed Message"
N145 ASKBOOL"ALERT!"
N150 T6 M06
N155 M9
N160 G53 G0 X0 Y0
N165 M30
%
