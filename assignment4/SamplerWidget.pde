class SamplerWidget {
  // class variables
  SoundFile sample;
  Env env;

  // constructor method
  SamplerWidget(PApplet p, String filename) {
    // load the audio data from the file
    sample = new SoundFile(p, filename);
    env = new Env(p);
  }

  // methods
  void trigger(float rate) {
    // trigger the "envelope" so we can hear it
    sample.rate(rate);
    sample.loop();
    env.play(sample, .001, .1, .5, 2);
  }
}