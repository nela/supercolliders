s.quit;
s.boot;

s.meter;
FreqScope.new;

(
  x = {
    // lpf = lpf.clip(20, 20000);
    var sig, lpf, msex, msey;
    var filt_len;
    var freq = 80;

    // msex = MouseX.kr(20, 2000, 1); // .poll;
    // msey = MouseX.kr(freq, 1, 1).poll;
    msex = MouseX.kr(0.001, 8, 1); // .poll;

    // Kanskje bedre med envelop?
    filt_len = SinOsc.kr();

    lpf = SinOsc.kr(msex).range(freq * 3.047, freq * 11.14).poll; //.range(freq * 3.95, freq * 4.05);
    sig = LFSaw.ar([freq, freq + 1]);
    // sig = LFSaw.ar(Array.rand(20, 39, 41));
    sig = BPF.ar(sig, lpf, 0.05);
    msey = MouseY.kr(freq - (freq/2), freq * 17, 1);

    // sig = RHPF.ar(sig, msey, 0.5);

    sig = sig * 0.5;
  }.play
)

x.free;

(
  y = {
    var sig;
    sig = SinOsc.ar(800).range(220,440);
  }.play
)


(
    {
      var sig, trem;
	// range(280,320) for vibrato
      trem = SinOsc.kr(1).range(280,320);
      postln(trem);
      sig = Saw.ar(trem, mul:0.2)!2;
    }.play
)
