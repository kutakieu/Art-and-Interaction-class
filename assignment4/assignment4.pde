// ID: u5934839 (replace with your own uni ID)
// Name: Taku Ueki (replace with your name)
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;


import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
OpenCV opencv, opencv2, opencv3;
Rectangle[] faces, eyes;
Rectangle mouth;
PImage mouthImg;
Capture cam2;
Capture cam;
Histogram grayHist;
boolean mouth_open;


Box2DProcessing box2d;
SynthWidget synth;
SamplerWidget sampler;
NoiseWidget noise;

ArrayList<Boundary> boundaries;
int clickStart, radius;
boolean clicked = false;
Ball ball;
ArrayList<Ball> balls = new ArrayList<Ball>();
color[] colors = {color(255,51,51,200), color(255,153,51,200), color(255,255,51,200), color(51,255,51,200), color(51,153,255,200), color(51,255,255,200), color(255,51,255,200)};
char[] noteNames = {'C','D','E','F','G','A','B'};
void setup() {
  //fullScreen();
  background(0);
  size(1280, 720);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }
  cam = new Capture(this, width, height);
  cam2 = new Capture(this, 320,180);
  cam.start();    
  cam2.start();
  opencv = new OpenCV(this, 320, 180);
  opencv2 = new OpenCV(this, 320, 180);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  opencv2.loadCascade(OpenCV.CASCADE_MOUTH);
     
  grayHist = opencv.findHistogram(opencv.getGray(), 256);
  
  noise = new NoiseWidget(this);
  //sampler = new SamplerWidget(this, "gong.mp3");
  synth = new SynthWidget(this);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  
  //boundaries = new ArrayList<Boundary>();
  //boundaries.add(new Boundary(0,0,width*2,1));
  //boundaries.add(new Boundary(0,0,1,height*2));
  //boundaries.add(new Boundary(0,height,width*2,1));
  //boundaries.add(new Boundary(width,0,1,height*2));
  
  
}

void draw() {
  //background(0);
  
  cam.read();
  cam2.read();

  opencv.loadImage(cam2);
  opencv2.loadImage(cam2);
  //image(cam, 0, 0);
  set(0,0,cam);
  //set(0,0,cam2);
  
  faces = opencv.detect();
  eyes = opencv2.detect();
  noFill();
  strokeWeight(3);
  stroke(0, 255, 0);
  for (int i = 0; i < faces.length; i++){
      rect(faces[i].x*4, faces[i].y*4, faces[i].width*4, faces[i].height*4);
      //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
      
  stroke(0,0,255);
  if(eyes.length > 0)
  for(int i=0; i<eyes.length; i++){
    for (int j = 0; j < faces.length; j++) 
      if(eyes[i].x > faces[j].x && eyes[i].x+eyes[i].width < faces[j].x + faces[j].width && eyes[i].y > faces[j].y+faces[j].height/5*3 && eyes[i].y < faces[j].y+faces[j].height/5*4)
        {
          //rect(eyes[i].x*4, eyes[i].y*4, eyes[i].width*4, eyes[i].height*4);
          mouth = eyes[i];
          rect(mouth.x*4, mouth.y*4, mouth.width*4, mouth.height*4);
          //rect(mouth.x, mouth.y, mouth.width, mouth.height);
          createMouthImg();
          //image(mouthImg,0,0);
          
        }
      //else
      //  mouth_open = false;
  }
  if(mouth_open)
    println("mouth is open!!!");
  
  //box2d.step();
  
  if(mousePressed){
    radius = 10 + (frameCount - clickStart);
    fill(colors[radius%42/6]);
    ellipse(mouseX,mouseY,radius, radius);
  }
  if(mouth_open && random(1)> 0.3){
    ball = new Ball((mouth.x + mouth.width/2)*4, (mouth.y + mouth.height/2)*4,(int)random(7), (int)random(-5,5), (int)random(10,30), (int)random(30,40));
  balls.add(ball);
  }
  
  for(Ball ball : balls)
    ball.draw();
    
  //for(Boundary boundary : boundaries)
  //  boundary.display();
    
  
}

void mousePressed(){
  radius = 10;
  clickStart = frameCount;
  clicked = true;
  println("pressed");
}

void mouseReleased(){
  if(abs(mouseX-pmouseX)/2 < 1 && abs(mouseY-pmouseY)/2 < 1)
    ball = new Ball(mouseX, mouseY,(int)random(7), radius);
  else
    ball = new Ball(mouseX, mouseY,(int)random(7), (mouseX - pmouseX)/2, (mouseY - pmouseY)/2, radius);
  balls.add(ball);
  radius = 0;
  clicked = false;
  println("released");
}

void beginContact(Contact cp) {
  println("collided!!");
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Ball.class){
    Ball p1 = (Ball) o1;
    p1.trigger();
  }
  if(o2.getClass() == Ball.class){
    Ball p2 = (Ball) o2;
    p2.trigger();
  }
}

void createMouthImg(){
  mouthImg = createImage(mouth.width, mouth.height, RGB);
  mouthImg.loadPixels();
  int p = cam2.width*mouth.y + mouth.x;
  cam2.loadPixels();
  for(int i=0; i < mouthImg.pixels.length; i++){
    mouthImg.pixels[i] = cam2.pixels[p + (i/mouth.width * cam2.width) + i%mouth.width];
  }
  opencv3 = new OpenCV(this, mouthImg);
  int threshold = 50;
  float num = 0;
  
  grayHist = opencv.findHistogram(opencv3.getGray(), 256, false);
  
  println("Mat height = " + grayHist.getMat().height());
  println("Mat width = " + grayHist.getMat().width());
  for(int i=0; i<threshold; i++){
    num += grayHist.getMat().get(i,0)[0];
  }
  println(num);
  println(((float)(num/mouthImg.pixels.length)));
    
  if((float)(num/mouthImg.pixels.length) > 0.2)
    mouth_open = true;
  else
    mouth_open = false;
  //fill(125); noStroke();
  //grayHist.draw(width/2, 0, 310, 180);
}