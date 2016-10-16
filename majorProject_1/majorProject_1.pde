import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.video.*;
import gab.opencv.*;

Capture camera;
OpenCV cv;
ArrayList<PImage> images;
PImage[] images2 = new PImage[10];
PImage img;
PImage pre_img = null;
int index = 0;
int counter = 0;
boolean viewer;
void setup(){
  frameRate(30);
  size(640,480);
  camera = new Capture(this,640,480);
  camera.start();
  images = new ArrayList<PImage>();
  viewer = false;
  
}

void draw(){
  background(0);
  
  if (camera.available() == true) {
    camera.read();
  }
  //camera.read();
  if(mousePressed){

    img = camera;
    images.add(img.get());

    counter++;
  }else if(images.size()>0){

    tint(255,200);
    image(images.get(index%images.size()), 0, 0);
  }
  
  if(pre_img != null){
    
  }
  
  tint(255,100);
  image(camera,0,0);
  if(index!=0)
    index+= (int)(random(-2,4));
  else
    index++;
  text(frameRate,100,100);
  pre_img = img.get();
}

void mousePressed(){
  counter = 0;
  index=0;
  println(images.size());
  images.clear();
}

void mouseReleased(){
  //images.get(10).save("aaa.jpg");
}