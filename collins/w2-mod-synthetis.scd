s.quit;
s.boot;

FreqScope.new;

//  Ring Modulation
// Straigh multiplication of two signals
// Ring modulation only includes sidebands without the carrier freq
//  carrier * modulator

(
  k = {
    var carrier, modulator, carrfreq, modfreq;
    carrfreq= MouseX.kr(440,8800,'linear');
    modfreq= MouseY.kr(1,30,'exponential');

    carrfreq = 400;
    // modfreq = 30;
    carrier= SinOsc.ar(carrfreq,0,0.5);
    modulator= SinOsc.ar(modfreq,0,0.5);
    carrier*modulator;
  };
  k.play;
  // k.scope;
  // k.plot(2.0);
  // k.minval = -1;
  // k.maxval = 1;
)

// Amplitude modulation
// Includes both the carrier and the sidebands
(
  k = {
    var carrier, modulator, carrfreq, modfreq;
    carrfreq= MouseX.kr(440,5000,'exponential');
    modfreq= MouseY.kr(1,5000,'exponential');
    carrfreq = 400;
    // modfreq = 30;
    carrier= SinOsc.ar(carrfreq,0,0.5);
    modulator= SinOsc.ar(modfreq,0,0.5, 0.25);
    carrier*modulator;
  };
  k.scope;
  k.plot(2.0);
  k.minval = -1;
  k.maxval = 1;
)

// Gui for AM -> RM
(
  var w, add_slider, m_freq_slider;
  w = Window("add slider", Rect(100, 400, 400, 300));
  w.view.decorator = FlowLayout(w.view.bounds);

  k = {
    arg add = 0.01, m_freq = 1;
    var carrier, modulator, c_freq = 440, mul = 0.5;
    carrier = SinOsc.ar(c_freq, 0, mul);
    modulator = SinOsc.ar(m_freq, 0, mul, add);
    carrier*modulator;
  }.scope;

  m_freq_slider = EZSlider(w, 300@50, "modulation frequency",
    ControlSpec(1, 5000, 'exponential', 1, 1),
    { arg ez; k.set(\m_freq, ez.value); }
  );

  w.view.decorator.nextLine;

  add_slider = EZSlider(w, 300@50, "add slider",
    ControlSpec(0.0, 1.0, 'lin', 0.1, 0),
    { arg ez; k.set(\add, ez.value); }
  );

  w.front;
)

// Frequency modulation
// Carrier Modulator Freq and Modulator depth
(
  var w, carrfreqslider, modfreqslider, moddepthslider, synth;
  w = Window("frequency modulation", Rect(100, 400, 400, 300));
  w.view.decorator = FlowLayout(w.view.bounds);
  synth = {
    arg carrfreq = 440, modfreq = 1, moddepth = 0.01;
    SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)),0,0.25)
  }.scope;

  carrfreqslider = EZSlider(w, 300@50, "carrfreq",
    ControlSpec(20, 5000, 'exponential', 10, 440),
    {
      |ez|  synth.set(\carrfreq, ez.value)
    }
  );

  w.view.decorator.nextLine;
  modfreqslider = EZSlider(w, 300@50, "modfreq",
    ControlSpec(1, 5000, 'exponential', 1, 1),
    {
      |ez|  synth.set(\modfreq, ez.value)
    }
  );
  w.view.decorator.nextLine;
  moddepthslider = EZSlider(w, 300@50, "moddepth",
    ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01),
    {
      |ez|  synth.set(\moddepth, ez.value)
    }
  );
  w.front;
)

// Carrier, Modulator FReq, and Modulation Index
// Index = M depth / M freq
(
  var w, carrfreqslider, modfreqslider, modindexslider, synth;
  w=Window("frequency modulation via modulation index", Rect(100, 400, 400, 300));
  w.view.decorator = FlowLayout(w.view.bounds);

  synth= { arg carrfreq=440, modfreq=1, modindex=0;
    SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)),0,0.25)
  }.scope;

  carrfreqslider= EZSlider(w, 300@50, "carrfreq",
    ControlSpec(20, 5000, 'exponential', 10, 440),
    {|ez|  synth.set(\carrfreq, ez.value)}
  );

  w.view.decorator.nextLine;

  modfreqslider= EZSlider(w, 300@50, "modfreq",
    ControlSpec(1, 5000, 'exponential', 1, 1),
    {|ez|  synth.set(\modfreq, ez.value)}
  );

  w.view.decorator.nextLine;

  modindexslider= EZSlider(w, 300@50, "modindex",
    ControlSpec(0.0, 10, 'linear', 0.01, 0.0),
    {|ez|  synth.set(\modindex, ez.value)}
  );

  w.front;
)

// Phase modulation
(
  var w, carrfreqslider, modfreqslider, modindexslider, synth;
  var conversion= 2pi/(s.sampleRate); //needed to avoid phase being adjusted too wildly

  w = Window("phase modulation via modulation index", Rect(100, 400, 400, 300));
  w.view.decorator = FlowLayout(w.view.bounds);

  synth = {
    arg carrfreq=440, modfreq=1, modindex=0;
    SinOsc.ar(carrfreq, ((modfreq*modindex)*conversion*SinOsc.ar(modfreq)),0.25)
  }.scope;

  carrfreqslider = EZSlider(w, 300@50, "carrfreq",
    ControlSpec(20, 5000, 'exponential', 10, 440),
    {|ez|  synth.set(\carrfreq, ez.value)}
  );

  w.view.decorator.nextLine;

  modfreqslider = EZSlider(w, 300@50, "modfreq",
    ControlSpec(1, 5000, 'exponential', 1, 1),
    {|ez|  synth.set(\modfreq, ez.value)}
  );

  w.view.decorator.nextLine;

  //bigger range since adjusting phase directly and not frequency
  modindexslider = EZSlider(w, 300@50, "modindex",
    ControlSpec(0.0, 100, 'linear', 0.01, 0.0),
    {|ez|  synth.set(\modindex, ez.value)}
  );

  w.front;
)
// with mod depth
(
  var w, carrfreqslider, modfreqslider, moddepthslider, synth;
  var conversion= 2pi/(s.sampleRate); //needed to avoid phase being adjusted too wildly

  w = Window("phase modulation via modulation index", Rect(100, 400, 400, 300));
  w.view.decorator = FlowLayout(w.view.bounds);

  synth = {
    arg carrfreq=440, modfreq=1, moddepth=0;
    SinOsc.ar(carrfreq, (moddepth*SinOsc.ar(modfreq)),0.25)
  }.scope;

  carrfreqslider = EZSlider(w, 300@50, "carrfreq",
    ControlSpec(20, 5000, 'exponential', 10, 440),
    {|ez|  synth.set(\carrfreq, ez.value)}
  );

  w.view.decorator.nextLine;

  modfreqslider = EZSlider(w, 300@50, "modfreq",
    ControlSpec(1, 5000, 'exponential', 1, 1),
    {|ez|  synth.set(\modfreq, ez.value)}
  );

  w.view.decorator.nextLine;
  moddepthslider = EZSlider(w, 300@50, "moddepth",
      ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01),
      {
        |ez|  synth.set(\moddepth, ez.value)
      }
    );

  //bigger range since adjusting phase directly and not frequency
  // modindexslider = EZSlider(w, 300@50, "modindex",
  //   ControlSpec(0.0, 100, 'linear', 0.01, 0.0),
  //   {|ez|  synth.set(\modindex, ez.value)}
  // );

  w.front;
)

//or via mouse control

(
  {
    var modfreq, modindex, conversion;
    modfreq= MouseX.kr(1,1000, 'exponential');
    modindex=MouseY.kr(0.0,100.0);
    conversion= 2pi/(s.sampleRate);

    //Phasor is a UGen which will loop around a given interval, in this case 0 to 2pi, taking us around the waveform of the sinusoid; note that all the action is in the phase input
    SinOsc.ar(0, Phasor.ar(0,440*conversion,0,2pi)+( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)

    //simpler alternative
    //SinOsc.ar(440, ( (modf*ind)*conversion*SinOsc.ar(modf)), 0.25)
  }.scope

)

// Fat Chorus
// I'll use what we've looked at to create a chorusing effect. We make an array of oscillators slightly detuned from one another, mixed to keep them in mono.
{Mix(Saw.ar([440,443,437],0.1))}.scope //chorusing

//more complicated sound combining AM, FM, chorusing and time-variation from Line and XLine

(
  {
  Mix(
  //The Resonz filter has arguments input, freq, rq=bandwidth/centre frequency
  //frequency modulated sawtooth wave with chorusing
  	Resonz.ar(
      Saw.ar([440,443,437] + SinOsc.ar(100,0,100)),
      XLine.kr(10000,10,10), //vary filter bandwidth over time
  		Line.kr(1,0.05, 10), //vary filter rq over time
  		mul: LFSaw.kr(Line.kr(3,17,3),0,0.5,0.5)*Line.kr(1,0,10)  //AM
  	)
  )
  }.scope
)

//richer bell patch
(
  var numpartials, spectrum, amplitudes, modfreqs1, modfreqs2, decaytimes;
  spectrum = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];
  amplitudes= [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];
  numpartials = spectrum.size;
  modfreqs1 = Array.rand(numpartials, 1, 5.0); //vibrato rates from 1 to 5 Hz
  modfreqs2 = Array.rand(numpartials, 0.1, 3.0); //tremolo rates from 0.1 to 3 Hz

  //decay from 2.5 to 7.5 seconds, lower partials longer decay
  decaytimes = Array.fill(numpartials,{|i|  rrand(2.5,2.5+(5*(1.0-(i/numpartials))))});
  {
    Mix.fill(numpartials,
      {
        arg i;
    	  var amp, freq;
    	  freq = (spectrum[i]+(SinOsc.kr(modfreqs1[i],0,0.005)))*500;
    	  amp = 0.1* Line.kr(1,0,decaytimes[i])*(SinOsc.ar(modfreqs2[i],0,0.1,0.9)* amplitudes[i]);
    	  Pan2.ar(SinOsc.ar(freq, 0, amp),1.0.rand2)
     }
    );
  }.scope
)

// Playing around
(
  var freq = [200, 203, 205, 207], modfreq = [200, 300, 400], modindex = 5;

  k = {
    var f = freq + (XLine.kr(0.3, 42, 10) * modfreq * SinOsc.ar(modfreq));
    SinOsc.ar(f * EnvGen.kr(Env.new([0.01, 0.4, 0.27, 0.8], [0.1, 4, 3, 9])), doneaction: Done.freeSelf)
  }.scope;
)
