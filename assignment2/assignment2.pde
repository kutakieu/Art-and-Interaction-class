// ID: u5934839 (replace with your own uni ID)
// Name: Taku Ueki (replace with your name)

// make sure you put your name and uni ID in these top two lines
// it's part of the spec and you'll lose marks if you don't!
float RX, RY, GX, GY, BX, BY, bX, bY;
float boxWidth = 100, colourArea = 250;
color Red = color(255,0,0), Green = color(0,255,0), Blue = color(0,0,255), Black = color(0), White = color(255); 
int count = 1; //the number failed to click color box
String text1, text2, countText;
float lastX, lastY;
void setup() {
  size(800,800);
  background(255);
  frameRate(30);
  textSize(30);
  RX = 100;  RY = 100;
  GX = 200;  GY = 100;
  BX = 300;  BY = 100;
  bX = 400;  bY = 100;
  text1 = "click the boxes to change color.";
  text2 = "";
  countText = "count : ";
}
float noiseScale = 0.02;
void draw() {

  fill(255);
  stroke(255);
  rect(0,0,width,colourArea);
  stroke(0);
  strokeWeight(1);
  fill(Red);
  rect(RX, RY, boxWidth, boxWidth);
  fill(Green);
  rect(GX, GY, boxWidth, boxWidth);
  fill(Blue);
  rect(BX, BY, boxWidth, boxWidth);
  fill(Black);
  rect(bX, bY, boxWidth, boxWidth);
  
  move(frameCount%300);
  strokeWeight(3);
  stroke(0);
  line(0,colourArea,width, colourArea);
  if(count == 6)
    autoDraw(lastX, lastY);
  
  // your great drawing code goes here!
}
void autoDraw(float x, float y){
  lastX = x + random(-10,10);
  lastY = y + random(-10,10);
  stroke(col);
  line(x, y, lastX, lastY);
}

float PmouseX=0, PmouseY=0;
float MouseX, MouseY;
color col = Black;
void mouseDragged(){
  if(mouseY <= colourArea)
    return;
  stroke(col);
  strokeWeight(count);
  MouseX = mouseX+random(0,count*count);
  MouseY = mouseY+random(0,count*count);
  if(PmouseX != 0 && PmouseY != 0)
  line(MouseX, MouseY, PmouseX, PmouseY);
  PmouseX = MouseX;
  PmouseY = MouseY;
  lastX = mouseX;
  lastY = mouseY;
}
void mouseClicked(){
  if(mouseY <= colourArea)
    col = checkColor(col);
}

void mouseReleased(){
  PmouseX = 0;
  PmouseY = 0;
}

float rateXR = 0, rateYR = 1000, rateXG = 2000, rateYG = 3000, rateXB = 4000, rateYB = 5000, rateXb = 6000, rateYb = 7000;
float rate = 0;
void move(int time){
  rate = time/random(1,10);
  //rate = 10;
  
  if(time > 200){
    RX += (RX+(noise(rateXR)*rate-rate/2) < 0 || RX+(noise(rateXR)*rate-rate/2) > width-boxWidth)? 0 : (noise(rateXR)*rate-rate/2);
    RY += (RY+(noise(rateYR)*rate-rate/2) < 0 || RY+(noise(rateYR)*rate-rate/2) > colourArea-boxWidth)? 0 : (noise(rateYR)*rate-rate/2);
    GX += (GX+(noise(rateXG)*rate-rate/2) < 0 || GX+(noise(rateXG)*rate-rate/2) > width-boxWidth)? 0 : (noise(rateXG)*rate-rate/2);
    GY += (GY+(noise(rateYG)*rate-rate/2) < 0 || GY+(noise(rateYG)*rate-rate/2) > colourArea-boxWidth)? 0 : (noise(rateYG)*rate-rate/2);
    BX += (BX+(noise(rateXB)*rate-rate/2) < 0 || BX+(noise(rateXB)*rate-rate/2) > width-boxWidth)? 0 : (noise(rateXB)*rate-rate/2);
    BY += (BY+(noise(rateYB)*rate-rate/2) < 0 || BY+(noise(rateYB)*rate-rate/2) > colourArea-boxWidth)? 0 : (noise(rateYB)*rate-rate/2);
    bX += (bX+(noise(rateXb)*rate-rate/2) < 0 || bX+(noise(rateXb)*rate-rate/2) > width-boxWidth)? 0 : (noise(rateXb)*rate-rate/2);
    bY += (bY+(noise(rateYb)*rate-rate/2) < 0 || bY+(noise(rateYb)*rate-rate/2) > colourArea-boxWidth)? 0 : (noise(rateYb)*rate-rate/2);
    rateXR += 0.1;    rateYR += 0.1;
    rateXG += 0.1;    rateYG += 0.1;
    rateXB += 0.1;    rateYB += 0.1;
    rateXb += 0.1;    rateYb += 0.1;
  } 
  
  text(countText+String.valueOf(6-count), 50,55);
  text(text1,50,25);
}

color checkColor(color col){

  if(mouseX >= RX && mouseX <= RX+boxWidth && mouseY >= RY && mouseY <= RY+boxWidth){
    count = 1;
    return Red;
  }else if(mouseX >= GX && mouseX <= GX+boxWidth && mouseY >= GY && mouseY <= GY+boxWidth){
    count = 1;
    return Green;
  }else if(mouseX >= BX && mouseX <= BX+boxWidth && mouseY >= BY && mouseY <= BY+boxWidth){
    count = 1;
    return Blue;
  }else if(mouseX >= bX && mouseX <= bX+boxWidth && mouseY >= bY && mouseY <= bY+boxWidth){
    count = 1;
    return Black;
  }else{
    if(count<=5)
      count += 1;
    return col;
  }
}