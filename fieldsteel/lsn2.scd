s.quit;
s.boot;

x = { SinOsc.ar(440, 0, 0.85)}.play;
x.free;

(
z = {
	arg freq = 440, phase = 1, amp = 0.8;
	var sig;
	sig = SinOsc.ar(freq, phase) * amp;
}.play;
)

z.set(\phase, 0.9);
z.free;

t = { LFNoise0.ar(4, 1, 0) }.play;

t.free;

(
m = {
	// noiseHz is the frequency at which the LFNoise0 will output values
	arg noiseHz = 8;
	var freq, sig, amp;
	// LFNoise0.kr(8, 400, 600) = LFNoise0.kr(8).range(200, 1000)
	freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
	//freq.postnsc;
	amp = LFNoise1.kr(16).exprange(0.02, 0.9);
	sig = SinOsc.ar(freq) * amp;
}.play;
)

m.set(\noiseHz, 16);

m.free;

/****Lesson 3****/

(
SynthDef.new(\sineTest, {
	arg noiseHz = 8;
	var freq, sig, amp;
	// LFNoise0.kr(8, 400, 600) = LFNoise0.kr(8).range(200, 1000)
	freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
	amp = LFNoise1.kr(16).exprange(0.02, 0.9);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\sineTest, [\noiseHz, 32]);

x.set(\noiseHz, 12);

x.free;


(
SynthDef.new(\pulseTest, {

})
)

/** Lesson 4***/

// donaAction frees the synth once its line is complete

(
{
	var sig, env, freq;
	// XLine is a exponential Line
	env = XLine.kr(1, 0.01, 1, doneAction: 2);
	freq = XLine.kr(880, 110, 1, doneAction: 0);
	sig = Pulse.ar(freq) * env;
}.play;
)

// gate functions as a trigger gate here, setting the tone when > 0
// t_{var} sets the trigger and turns off the env
// doneaction frees the synth from the server
(
x = {
	arg t_gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0, 1, 0.2, 0],
		[0.5, 1, 2],
		[3, -3, 0]), t_gate, doneAction: 2);
	sig = Pulse.ar(ExpRand(30,60)) * env;
}.play;
)

x.set(\t_gate, 1);

// in order to use exp 0's must be edited to small positive numbers. cannot have 0 values on exp curve
Env.new([0.01, 1, 0.2, 0.01], [0.5, 1, 2], \exp).plot;

// or use array to specify curvature
Env.new([0.01, 1, 0.2, 0.01], [0.5, 1, 2], [3, -3, 0]).plot;

(
b = {
	arg gate = 0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
	sig = Pulse.ar(ExpRand(30,60)) * env;
}.play;
)

b.set(\gate, 0);

// Multichannel exp
s.meter;

x = {SinOsc.ar([300,500])}.play
x.free;

(
x = {
	var sig, amp;
	amp = SinOsc.kr([7, 1, 4 ,5 , 2]).exprange(0.001,0.9);
	sig = SinOsc.ar([300, 500, 200, 400, 60]);
	sig = sig * amp;
	// Ugen that mixes the ugen array of discrete signals to a single channel
	// Mix.new(sig);
	// Or apply multi channel expansion to a mixed signal
	Mix.new(sig).dup(2) * 0.25;

	// Splay spreads an arbitrarily large array of channels across a stereo field.


}.play;
)

x.free;


"hello".dup(2);
"hello"!2

(
SynthDef.new(\multi, {
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new([0, 1, 0], [10, 10], [1, -1]),
		doneAction: 2
	);
	// exprand chooses values when the Synth is compiled, while ExpRand chooses values when a synth is created
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0, 1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);

}).add;
)

x = Synth.new(\multi);
x.free;

// Iteration
(
SynthDef.new(\iter, {
	arg freq = 40;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction: 2
	);
	// do is the iteration
	10.do{
		// Make 10 stereo Varsaws
		temp = VarSaw.ar(
			// Randomize the freq x 2
			freq * {Rand(0.99, 1.02)}!2,
			// Randomize the phase in order to get rid of onset clip
			{Rand(0.0, 1.0)}!2,
			// Randomize the duty cycle
			{ExpRand(0.005, 0.05)}!2
		);
		sum = sum + temp;
	};
	sum = sum * 0.05 * env;
	Out.ar(0, sum);
}).add;
)


Synth.new(\iter);


Synth.new(\iter, [\freq, 66.midicps]);
s.meter;

(
SynthDef.new(\iter2, {
	arg freq = 200, dev = 1.02;
	var temp, sum;
	sum = 0;
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev)
		);
		// amplitude flucutation
		temp = temp * LFNoise1.kr({Rand(0.5, 8)}!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter2);
x.free;

a = { 10.rand. }; b = a.reciprocal; b.value;

//################## Lesson 7. Server busses

s.options.numAudioBusChannels; // num of audio bus channels
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

(
SynthDef.new(\blip, {
	arg out;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	// Create a pannin -> Multi channel signal
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)

~reverbBus1 = Bus.audio(s, 1);
~reverbBus1.index;
// bus for a multichannel signal
~reverbBus2 = Bus.audio(s, 2);

y = Synth.new(\reverb, [\in, ~reverbBus2]);
x = Synth.new(\blip, [\out, ~reverbBus2]);

x.free;
y.free;
s.plotTree;

// Buffers
// ~b0 = Buffer.read(s, "/abs-path/to/file.aiff");
~b0 = Buffer.read(s, "/Users/nela/supercolliders/fieldsteel/Cow_Moo-Mike_Koenig-42670858.wav")


// FRAMES - corresponds to the length of the buffer
// ~b0.numFrames;
// Channels - 2 if the soundtype is stereo etc
// ~b0.numChannels;

// Read from one channel
~b1 = Buffer.readChannel(s, "/Users/nela/supercolliders/fieldsteel/Hoot Owl-SoundBible.com-267010188.wav", channels:[1]);
// Here we only see and hear one channel from the audio
~b1.play;
~b1.free;

// numSamples = numChannels * numFrames;

// Important to be aware of how many Channels you are dealing with, because
// buffer UGens will not work correctly if you are inconsistent with the number
// of Channels you are working with

// Every buffer has a specific bufnum
~b0.bufnum;

// Buffer sample rate - all soundfiles are recorded and exorted at the
// specific sample rate
// See fundamental attributes of a buffer
~b0.query;
s.sampleRate;

// Loading a part of the file into a Buffer

// The head end of the sound file
~b0_part0 = Buffer.read(s, "/Users/nela/supercolliders/fieldsteel/Cow_Moo-Mike_Koenig-42670858.wav", 0, s.sampleRate/2);
~b0_part0.play;
// The tail end
~b0_part1 = Buffer.read(s, "/Users/nela/supercolliders/fieldsteel/Cow_Moo-Mike_Koenig-42670858.wav", 29000, ~b0.numFrames - 29001);
~b0_part1.play

// Load several files
// ~sounds = Array.new;
// ~folder = PathName.new("/abs/path/to/folder");
// (
// ~folder.entries.do({
//    arg path;
//    ~sounds = ~sounds.add(Buffer.read(s, path.fullPath));
// });
// )
// ~sounds.at(0).play;
// ~sounds[0].play;

// // number of buffers. Several more buffers can be loaded by setting value to
// this variable
s.options.numBuffers;

// Ugens commonl used for buffer playbacu PlayBuf and BufRd
(
  SynthDef(\playbuf_test, { |x|

  }).add;
)
