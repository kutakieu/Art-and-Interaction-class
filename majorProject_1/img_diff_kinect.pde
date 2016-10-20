import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.video.*;
import gab.opencv.*;

Kinect kinect;
//Capture camera;
OpenCV cv, cv1,cv2;
ArrayList<PImage> images;
PImage[] images2 = new PImage[10];
PImage img, img_BW;
PImage pre_img = null;
PImage diff_img, diff_imgBW;
PImage result_img, result_imgBW;
PImage back_img = null, back_imgBW;

//kinect images
PImage depthImg, videoImg;

byte[] byte_back=null, byte_img;

int index = 0;
int counter = 0;
boolean viewer, back_change = false;
int dimension;
void setup(){
  frameRate(20);
  size(1280,960);
  dimension = 640*480;
  img_BW = new PImage(640,480);
  result_img = new PImage(640,480);
  
  //camera = new Capture(this,640,480);
  //camera.start();
  
  images = new ArrayList<PImage>();
  viewer = false;
  
  cv = new OpenCV(this, 640, 480);
  cv1 = new OpenCV(this, 640, 480);
  cv2 = new OpenCV(this, 640, 480);
  
  cv.useGray();
  cv1.useGray();
  cv2.useGray();
  
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  depthImg = new PImage(kinect.width, kinect.height);
  //println(color(0));
  //println(color(255));
  //println(color(255,255,255));
}

void draw(){
  background(0);
  
  //image(kinect.getDepthImage(), 0, 0);
  depthImg = kinect.getDepthImage();
  videoImg = kinect.getVideoImage();
  //int[] depth = kinect.getRawDepth();
  
  //if (camera.available() == true) {
  //  camera.read();
  //  img = camera;
  //}
  if(videoImg!=null){
    //image(videoImg,640,480);
  //byte_img = rgb2grayByte(img);
  //cv2.loadImage(img);
  //cv2.toPImage(cv2.getGray(),img);
  //img = cv2.getSnapshot();
  //img_BW = byte2PImage(byte_img);
  //image(img_BW, 0, 480);
  
  if(mousePressed){
    //back_img = img.get();
    back_img = depthImg.get();
    cv.loadImage(back_img);
    //byte_back = rgb2grayByte(back_img);
    //back_img = byte2PImage(byte_back);
    //back_change = true;
  }
  if(back_img != null){
    image(back_img,640,0);
    image(depthImg,0,480);
    cv.diff(depthImg);
    
    //diff_img = cv.getSnapshot();
    cv1.loadImage(cv.getSnapshot());
    cv1.threshold(100);
    cv1.erode();
    cv1.dilate();
    diff_img = cv1.getSnapshot();
    image(diff_img,0,0);
    result_img.loadPixels();
    for(int i=0; i<dimension; i++){
      //print(i);
      if(diff_img.pixels[i] == #FFFFFF)
        result_img.pixels[i] = videoImg.pixels[i];
      else
        result_img.pixels[i] = #000000;
    }
    result_img.updatePixels();
    //result_img = imgDiff(byte_img, byte_back, 20);
    //diff_img = imgDiff(byte_img, byte_back);
    //image(diff_img,640,480);
    //image(back_img,640,0);
    image(result_img,640,480);
  }
  
  
    
  //if(back_img != null){
  //  image(back_img, 640,0);
  //  //println("here");
  //  cv.loadImage(back_img);
  //  cv.diff(img);
  //  //diff_img = cv.getSnapshot();
  //  //diff_img = cv.getSnapshot();
  //  cv1.loadImage(cv.getSnapshot());
  //  cv1.threshold(100);
  //  //cv1.erode();
  //  //cv1.erode();
  //  //cv1.dilate();
  //  //cv1.dilate();
  //  diff_img = cv1.getSnapshot();
  //  diff_img.loadPixels();
  //  img.loadPixels();
  //  result_img.loadPixels();
  //  image(diff_img, 640,480);
  //  println(img.pixels[0]);
  //  for(int i=0; i<dimension; i++){
  //    //print(i);
  //    if(diff_img.pixels[i] != #000000)
  //      result_img.pixels[i] = img.pixels[i];
  //  }
  //  result_img.updatePixels();
  //  image(result_img, 0, 0);
  //  //image(cv1.getSnapshot(),0,0);
  //  back_change = false;
  //}
  }
  text(frameRate,100,100);
  
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
  int r = 299;
  int g = 587;
  int b = 114;
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
    img.pixels[i] = color(byte_img[i]);
  img.updatePixels();
  return img;
}