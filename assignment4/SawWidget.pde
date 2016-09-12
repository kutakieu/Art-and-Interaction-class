class SawWidget {
  // class variables
  SawOsc saw;
  Env env;

  // constructor method
  SawWidget(PApplet p) {
    // set up the sine object (whose class is SinOsc)
    saw = new SawOsc(p);
    env = new Env(p);
    saw.amp(.5);
  }

  // methods
  float midi2ToFrequency(int midiPitch) {
    return 440 * pow(2, float(midiPitch - 69)/12);
  }

  void trigger(int pitch) {
    // trigger the "envelope" so we can hear it
    saw.freq(midi2ToFrequency(pitch));
    saw.play();
    env.play(saw, .01, .1, .5, .5);
  }
}