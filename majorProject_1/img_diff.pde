import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.video.*;
import gab.opencv.*;

Capture camera;
OpenCV cv, cv1,cv2;
ArrayList<PImage> images;
PImage[] images2 = new PImage[10];
PImage img = null, img_BW;
PImage pre_img = null;
PImage diff_img, diff_imgBW;
PImage result_img, result_imgBW;
PImage back_img = null, back_imgBW;

byte[] byte_back=null, byte_img;
int differentPixels=0;

int index = 0;
int counter = 0;
int alpha1 = 255;
int alpha2 = 50;
boolean viewer, back_change = false;
int dimension;
void setup(){
  frameRate(30);
  size(1280,960);
  dimension = 640*480;
  img_BW = new PImage(640,480);
  result_img = new PImage(640,480);
  
  camera = new Capture(this,640,480);
  camera.start();
  
  images = new ArrayList<PImage>();
  viewer = false;
  
  cv = new OpenCV(this, 640, 480);
  cv1 = new OpenCV(this, 640, 480);
  //cv2 = new OpenCV(this, 640, 480);

}

void draw(){
  background(0);
  //println(frameCount);
  tint(255,255);
  if (camera.available() == true) {
    camera.read();
    img = camera;
  }
  if(img != null){
    //println("here");
    if(viewer){
      
      tint(255,alpha1);
    }
    image(img, 0, 0);
    
    images.add(img.get());
    if(images.size()==61 && !viewer)
      images.remove(0);
    if(images.size() > 60 && !viewer){
      alpha1 = 255;
      alpha2 = 0;
      if(!imgDiff(back_img, images.get(index)))
        while(images.size()>60)
          images.remove(0);
    }
  }
  tint(255,255);
  if(mousePressed){
    back_img = img.get();

  }
  
    
  if(back_img != null){
    image(back_img, 640,0);
    //println("here");
    cv.loadImage(back_img);
    cv.diff(img);
    //diff_img = cv.getSnapshot();
    //diff_img = cv.getSnapshot();
    cv.loadImage(cv.getSnapshot());
    cv.threshold(75);
    //cv1.erode();
    cv.erode();
    cv.dilate();
    //cv1.dilate();
    diff_img = cv.getSnapshot();
    diff_img.loadPixels();
    img.loadPixels();
    result_img.loadPixels();
    
    //image(diff_img, 640,480);
    //println(img.pixels[0]);
    differentPixels=0;
    for(int i=0; i<dimension; i++){
      if(diff_img.pixels[i] != #000000){
        differentPixels++;
        result_img.pixels[i] = img.pixels[i];
      }else
        result_img.pixels[i] = #FFFFFF;
    }
    //println(differentPixels);
    result_img.updatePixels();
    if((float)differentPixels/dimension > 0.02)
      viewer = true;
    else 
      viewer = false;
    image(result_img, 0, 480);
    //image(cv1.getSnapshot(),0,0);
    back_change = false;
  }
  
  
  
  fill(255);
  text(frameRate,100,100);
  if(images.size() > 120){
    alpha1 -= alpha1 > 150 ? 1 : 0;
    alpha2 += alpha2 < 150 ? 1 : 0;
    tint(255,alpha2);
    image(images.get(index),0,0);
    //index++;
    images.remove(0);
  }  
  fill(color(255,0,0));
  textSize(30); 
  tint(255,255);
  if(viewer)
    text("VIEWER", 100, 150);
  else
    index=0;
  text((float)differentPixels/dimension,100,200);
  text(images.size(),100,250);
  text(alpha1 + " " + alpha2, 100,300);
}

boolean imgDiff(PImage backImg, PImage img){
  cv1.loadImage(backImg);
  cv1.diff(img);
  cv1.loadImage(cv1.getSnapshot());
  cv1.threshold(75);
  cv1.erode();
  cv1.dilate();
  PImage tmpImg = cv1.getSnapshot();
  int diffs=0;
  for(int i=0; i<dimension; i++)
      if(diff_img.pixels[i] == #FFFFFF)
        diffs++;
  if((float)diffs/dimension > 0.02)
    return true;
  else
    return false;
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

byte[] rgb2grayByte(PImage col){
  byte[] img = new byte[640*480];
  println("step1 " + img.length);
  //col.loadPixels();
  //BW.loadPixels();
  println("step2");
  int R,G,B,gray;
  for(int i=0; i<640*480; i++){
    R = (col.pixels[i] >> 16) & 0xFF;
    G = (col.pixels[i] >> 8) & 0xFF;
    B = col.pixels[i] & 0xFF;
    gray = (299*R + 587*G + 114*B)>>10;
    img[i] = (byte)gray;
    //BW.pixels[i] = gray;
    //if(i==0){
    //  println("color " + col.pixels[i]);
    //  println("R "+R);
    //  println("G "+G);
    //  println("B "+B);
    //  println("gray " + gray);
    //}
  }
  println("step3");
  //BW.updatePixels();
  return img;
}

PImage imgDiff(byte[] img1, byte[] img2, int threshold){
  color b = color(0,0,0);
  color w = color(255,255,255);
  PImage output = new PImage(640,480);
  output.loadPixels();
  for(int i=0; i<img1.length; i++){
    if(abs(img1[i]-img2[i]) > threshold)
      output.pixels[i] = w;
    else
      output.pixels[i] = b;
  }
  return output;
}

PImage imgDiff(byte[] img1, byte[] img2){

  PImage output = new PImage(640,480);
  output.loadPixels();
  for(int i=0; i<img1.length; i++)
      output.pixels[i] = color(abs(img1[i]-img2[i]));
  
  return output;
}

PImage byte2PImage(byte[] byte_img){
  PImage img = new PImage(640,480);
  img.loadPixels();
  for(int i=0; i<dimension; i++)
    img.pixels[i] = color(byte_img[i],byte_img[i],byte_img[i]);
  img.updatePixels();
  return img;
}
