s.quit;
s.boot;

(
  SynthDef.new(\test, { |out, freq, amp, t_gate|
    var env, env_sig;
    t_gate = 1;
    freq = 400;
    amp = 0.9;
    env = Env(
      levels: [0, 0.5, 0.1, 0.8, 0.2, 1],
      times: [1, 3, 5, 5, 5],
      curve: \lin,
    );
    env_sig = EnvGen.kr(env, gate: t_gate);
    out =  SinOsc.ar(freq)!2 * amp * env_sig;
    Out.ar(0, out);
  }).add;
)


(
  SynthDef(\test2, { |out, freq = 440, amp = 0.75|
    out = SinOsc.ar(freq)!2 * amp;
    Out.ar(0, out)
  }).add;
)

x = Synth.new(\test2);
x.free;

