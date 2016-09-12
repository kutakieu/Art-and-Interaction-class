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

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;
int clickStart, radius;
boolean clicked = false;
Ball ball;
ArrayList<Ball> balls = new ArrayList<Ball>();
color[] colors = {color(255,51,51), color(255,153,51), color(255,255,51), color(51,255,51), color(51,153,255), color(51,255,255), color(255,51,255)};

void setup() {
  fullScreen();
  background(0);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  
  boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(0,0,width*2,1));
  boundaries.add(new Boundary(0,0,1,height*2));
  boundaries.add(new Boundary(0,height,width*2,1));
  boundaries.add(new Boundary(width,0,1,height*2));
  
  
}

void draw() {
  background(0);
  box2d.step();
  
  if(mousePressed){
    radius = 10 + (frameCount - clickStart);
    fill(colors[radius%42/6]);
    ellipse(mouseX,mouseY,radius, radius);
  }
  
  for(Ball ball : balls)
    ball.display();
    
  for(Boundary boundary : boundaries)
    boundary.display();
}

//void mouseClicked() {
//  clickStart = frameCount;
//  println("clicked");
//}

void mousePressed(){
  radius = 10;
  clickStart = frameCount;
  clicked = true;
  println("pressed");
}

void mouseReleased(){
  if(abs(mouseX-pmouseX)/2 < 1 && abs(mouseY-pmouseY)/2 < 1)
    ball = new Ball(mouseX, mouseY,colors[(int)random(7)], radius);
  else
    ball = new Ball(mouseX, mouseY,colors[(int)random(7)], (mouseX - pmouseX)/2, (mouseY - pmouseY)/2, radius);
  balls.add(ball);
  radius = 0;
  clicked = false;
  println("released");
}

void keyPressed() {
}

void swellBall(){
  
}

void beginContact(Contact cp) {
  println("collided!!");
}