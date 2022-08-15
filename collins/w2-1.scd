s.quit;
s.boot;

FreqScope.new;

//////////
///// Subtractive Synthesis
//////////

{WhiteNoise.ar(0.1)}.scope;

{LPF.ar(WhiteNoise.ar(0.1),1000)}.scope

Line.kr(10000,1000,10) // take ten seconds to go from 10000 to 1000: inputs to Line are start, end, duration
//So instead of the fixed value 1000, the Line UGen goes in that second slot


{LPF.ar(WhiteNoise.ar(0.1),Line.kr(10000,1000,10))}.scope;


// Example of plugging one source into a filter:
{Resonz.ar(LFNoise0.ar(400),1000,0.1)}.scope;

// Again using the Line generator to change the filter centre frequency over time
{Resonz.ar(LFNoise0.ar(400),Line.kr(10000,1000,10),0.1)}.scope;

(
  {
    var source, line, filter; 	//local variables to hold objects as we build the patch up
    source=LFNoise0.ar(400);
    line=Line.kr(10000,1000,10);
    filter=Resonz.ar(source,line,0.1); //the filtered output is the input source filtered by Resonz with a line control for the resonant frequency
    filter // last thing is returned from function in curly brackets, i.e. this is the final sound we hear
    }.scope;
)
////////////////////
///Additive synthesis
////////////////////

// In additive synthesis, if we know a recipe for the spectrum (frequency content) of a sound,
// we can synthesise it by adding up sine tones for each component frequency.


// Sawtooth wave: Add up n harmonics with amplitude falling off as 1/harmonicnumber, sign alternates between +1 and -1
(
  {
  	var n = 10;
  	var wave = Mix.fill(10, {
          |i|
      	  var mult= ((-1)**i)*(0.5/((i+1)));
          mult.postln;
      	  SinOsc.ar(440*(i+1))*mult;
      });

  	Pan2.ar(wave/n,0.0); //stereo, panned centre
  }.scope;
)

(
  var n = 10;
  {
    Mix(SinOsc.ar(250*(1..n),0,1/n))
  }.scope;
)

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1))}.scope;
{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope //bell spectra, different volumes for partials
