class NoiseWidget {
  // class variables
  PinkNoise noise;
  Env env;

  // constructor method
  NoiseWidget(PApplet p) {
    // set up the sine object (whose class is SinOsc)
    noise = new PinkNoise(p);
    env = new Env(p);
    noise.amp(.5);
  }

  void trigger() {
    // trigger the "envelope" so we can hear it
    noise.play();
    env.play(noise, .01, .1, .5, 3);
  }
}
