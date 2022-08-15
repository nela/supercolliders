s.quit;
s.boot;
// Mul  and add
//

s.freqscope;
{SinOsc.ar(mul:MouseY.kr(1.0,0.1))}.scope;

{SinOsc.ar(mul:MouseX.kr(0.1,1.0), add:MouseY.kr(0.9,-0.9))}.scope;

// Careful  wtih this one, it is very loud and disturbing
(
  {
  	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700
  	var cutoff = 	SinOsc.ar(.1)};
  k.scope;
  k.plot(2.0);
  k.minval = -1 ; k.maxval = 1;
)
