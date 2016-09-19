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
boolean mouth_open_small, mouth_open_wide;
int mouthCenterX, mouthCenterY;
int directionX, directionY;


Box2DProcessing box2d;
SynthWidget synth;
SamplerWidget[] sampler = new SamplerWidget[8];
NoiseWidget noise;

ArrayList<Boundary> boundaries;
int clickStart, radius;
boolean clicked = false;
Ball ball;
ArrayList<Ball> balls = new ArrayList<Ball>();
color[] colors = {color(255,51,51,200), color(255,153,51,200), color(255,255,51,200), color(51,255,51,200), color(51,153,255,200), color(51,255,255,200), color(255,51,255,200)};
char[] noteNames = {'C','D','E','F','G','A','B'};
boolean cameraAvailable;

void setup() {
  //fullScreen();
  background(0);
  fill(255);
  textSize(32);
  text("loading...", width/2,height/2);
  text("open your mouth to play music", width/2,height/2);
  size(1280, 720);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    cameraAvailable = false;
  }else
    cameraAvailable = true;
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
  sampler[0] = new SamplerWidget(this, "do.mp3");
  sampler[1] = new SamplerWidget(this, "re.mp3");
  sampler[2] = new SamplerWidget(this, "mi.mp3");
  sampler[3] = new SamplerWidget(this, "fa.mp3");
  sampler[4] = new SamplerWidget(this, "so.mp3");
  sampler[5] = new SamplerWidget(this, "la.mp3");
  sampler[6] = new SamplerWidget(this, "ti.mp3");
  sampler[7] = new SamplerWidget(this, "do_.mp3");
  synth = new SynthWidget(this);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  
  //boundaries = new ArrayList<Boundary>();
  //boundaries.add(new Boundary(0,0,width*2,1));
  //boundaries.add(new Boundary(0,0,1,height*2));
  //boundaries.add(new Boundary(0,height,width*2,1));
  //boundaries.add(new Boundary(width,0,1,height*2));
  
  text('c',width/2,height/2);
  directionX = 1;
  directionY = -1;
}

void draw() {
  if(!cameraAvailable){
    background(0);
    fill(255);
    text("this program uses camera, please turn on your camera.", width/2,height/2);
  }else{
  
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
  if(mouth_open_wide)
    println("mouth is open widely!!!");
  if(mouth_open_small)
    println("mouth is open small!!!");
  
  //box2d.step();
  
  //if(mousePressed){
  //  radius = 10 + (frameCount - clickStart);
  //  fill(colors[radius%42/6]);
  //  ellipse(mouseX,mouseY,radius, radius);
  //}
  if(mouth_open_small && random(1) < 0.2){
    ball = new Ball((mouth.x + mouth.width/2)*4, (mouth.y + mouth.height/6)*4,(int)random(7), (int)random(directionX*10,directionX*20), (int)random(directionY*20,directionY*10), (int)random(40,80));
    balls.add(ball);
  }
  
  //for(Ball ball : balls){
  //  ball.draw();
  //  if(ball.remove())
  //    balls.remove(ball);
  //}
  
  for(int i=0; i<balls.size(); i++){
    balls.get(i).draw();
    if(balls.get(i).remove()){
      balls.remove(i);
    }
  }
    
  //for(Boundary boundary : boundaries)
  //  boundary.display();
  }
}

//void mousePressed(){
//  radius = 10;
//  clickStart = frameCount;
//  clicked = true;
//  println("pressed");
//}

//void mouseReleased(){
//  if(abs(mouseX-pmouseX)/2 < 1 && abs(mouseY-pmouseY)/2 < 1)
//    ball = new Ball(mouseX, mouseY,(int)random(7), radius);
//  else
//    ball = new Ball(mouseX, mouseY,(int)random(7), (mouseX - pmouseX)/2, (mouseY - pmouseY)/2, radius);
//  balls.add(ball);
//  radius = 0;
//  clicked = false;
//  println("released");
//}

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
  
  //println("Mat height = " + grayHist.getMat().height());
  //println("Mat width = " + grayHist.getMat().width());
  for(int i=0; i<threshold; i++){
    num += grayHist.getMat().get(i,0)[0];
  }
  //println(num);
  float mouth_open_rate = (float)(num/mouthImg.pixels.length);
  println(mouth_open_rate);
    
  if(mouth_open_rate > 0.05){
    if(mousePressed){
      mouth_open_wide = true;
      mouth_open_small = false;
    }else{
      mouth_open_small = true;
      mouth_open_wide = false;
    }
    mouthCenterX = (mouth.x + mouth.width/2)*4;
    mouthCenterY = (mouth.y + mouth.height/6)*4;
  }else{
    mouth_open_small = false;
    mouth_open_wide = false;
    if(random(1)<0.5)
      directionX = 1;
    else
      directionX = -1;  
    if(random(1)<0.5)
        directionY = 1;
    else
        directionY = -1;
    
  }
}