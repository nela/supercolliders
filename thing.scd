s.quit;
// s.sampleRate = 44100;
s.boot;



s.makewindow;
s.meter;
s.scope;
freqscope.new;
s.plottree;

(
  var f=20;
  var in1, out1, tw1, mod1;
  var in2, out2, tw2, mod2;
  var trem_freq=1, depth=0.25;

	a = {
    tw1 = SinOsc.kr(trem_freq, 0, depth);
    mod1 = (1.0 - depth) + tw1;
    // mod1 = depth + tw1;
    in1 = SinOsc.ar(1000, mul:0.5);
    out1 = in1 * mod1;

    tw2 = SinOsc.kr(trem_freq, phase: pi, mul: depth);
    mod2 = (1.0 - depth) + tw2;
    // mod2 = depth + tw2;
    in2 = SinOsc.ar(1008, phase: pi, mul: 0.5);
    out2 = in2 * mod2;
    (out1 + out2);
    //out1;
	};

  a.play;
  a.plot(2.0);
	a.minval = -1.0;
	a.maxval = 1.0;

  // b.play;
  // b.plot(2.0);
	// b.minval = -1.0;
	// b.maxval = 1.0;
)


(
x = {
  var s1, s2, out;
  s1 = Pulse.kr(1).range(0, 800);
  // s2 = SinOsc.kr(1, phase: pi).range(0, 802.5);
  out = Pulse.ar(s1, mul:0.2)!2;
}.play;
)

x.free;
