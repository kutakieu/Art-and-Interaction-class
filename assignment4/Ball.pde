class Ball{
  int X, Y;
  int R;
  int speedX, speedY;
  color col;
  int note;
  Body body;
  int octave;
  char noteName;
  
  Ball(int x, int y, int c, int r){
    this(x, y, c, (int)random(-5,5), (int)random(-5,5), r);
  }
  
  Ball(int x, int y, int c, int sX, int sY, int r){
    X = x;    Y = y;
    col = colors[c];
    noteName = noteNames[c];
    octave = 9 - r/20;
    if(octave<=0)
      octave = 1;
    note = colorToNote(c);
    R = r;
    speedX = sX;    speedY = sY;
    makeBody(x, y, r);
    body.setUserData(this);
      
    println(octave);
  }
  
  void draw(){
    this.update();
    fill(col);
    stroke(col);
    strokeWeight(1);
    ellipse(X,Y,R,R);
    fill(0);
    textSize(32);
    text(noteName,X,Y);
  }
  void update(){
    //speedX *= 0.9999999;
    //speedY *= 0.9999999;
    X += speedX;
    Y += speedY;
    if(X > width){
      X = width - (X - width);
      speedX *= -1;
      trigger();
    }else if(X < 0){
      X *= -1;
      speedX *= -1;
      trigger();
    }
    
    if(Y > height){
      Y = height - (Y - height);
      speedY *= -1;
      trigger();
    }else if(Y < 0){
      Y *= -1;
      speedY *= -1;
      trigger();
    }
  }
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    //rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    //rect(0,0,w,h);
    ellipse(0,0,R,R);
    //line(0, 0, R, 0);
    //fill(0);
    //textSize(32);
    //text("A",0,0);
    popMatrix();
  }
  
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r/2);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);
    Vec2 v = new Vec2(speedX, speedY);
    body.setLinearVelocity(v);
    //body.setAngularVelocity(random(-10, 10));
    //body.setAngularVelocity(100);
  }
  
  int colorToNote(int c){
    int _key = octave * 12;;
    if(c == 0)
      return _key;
    else if(c == 1)
      return _key+2;
    else if(c == 2)
      return _key+4;
    else if(c == 3)
      return _key+5;
    else if(c == 4)
      return _key+7;
    else if(c == 5)
      return _key+9;
    else
      return _key+11;
  }
  
  void trigger(){
    synth.trigger(note);
  }
}