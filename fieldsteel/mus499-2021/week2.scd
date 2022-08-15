s.quit;
s.boot;

s.makeWindow;
s.meter;
s.scope;
FreqScope.new;
s.plotTree;

// Tremolo

(
  {
    var sig, trem;
    // range(280,320) for vibrato
    trem = SinOsc.kr(1).range(0,220);
    postln(trem);
    sig = SinOsc.ar(trem, mul:0.2)!2;
  }.play
)

