class Ball{
  int X, Y;
  int R;
  int speedX, speedY;
  color col;
  Body body;
  
  Ball(int x, int y, color c, int r){
    this(x, y, c, (int)random(-5,5), (int)random(-5,5), r);
  }
  
  Ball(int x, int y, color c, int sX, int sY, int r){
    X = x;    Y = y;
    col = c;
    R = r;
    speedX = sX;    speedY = sY;
    makeBody(x, y, r);
    body.setUserData(this);
  }
  
  void draw(){
    this.update();
    fill(col);
    stroke(col);
    ellipse(X,Y,R,R);
  }
  void update(){
    //speedX *= 0.9999999;
    //speedY *= 0.9999999;
    X += speedX;
    Y += speedY;
    if(X > width){
      X = width - (X - width);
      speedX *= -1;
    }else if(X < 0){
      X *= -1;
      speedX *= -1;
    }
    
    if(Y > height){
      Y = height - (Y - height);
      speedY *= -1;
    }else if(Y < 0){
      Y *= -1;
      speedY *= -1;
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
    line(0, 0, R, 0);
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
    fd.density = 10;
    fd.friction = 1;
    fd.restitution = 0.9;

    // Attach fixture to body
    body.createFixture(fd);
    Vec2 v = new Vec2(speedX, speedY);
    body.setLinearVelocity(v);
    body.setAngularVelocity(random(-10, 10));
    //body.setAngularVelocity(100);
  }
  
}