class SynthWidget {
  // class variables
  SinOsc sine;
  Env env;

  // constructor method
  SynthWidget(PApplet p) {
    // set up the sine object (whose class is SinOsc)
    sine = new SinOsc(p);
    env = new Env(p);
    sine.amp(.5);
  }

  // methods
  float midi2ToFrequency(int midiPitch) {
    return 440 * pow(2, float(midiPitch - 69)/12);
  }

  void trigger(int pitch) {
    // trigger the "envelope" so we can hear it
    sine.freq(midi2ToFrequency(pitch));
    sine.play();
    env.play(sine, .01, .1, .5, .5);
  }
}