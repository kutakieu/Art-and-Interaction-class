// ID: u5934839 (replace with your own uni ID)
// Name: Taku Ueki (replace with your name)

// make sure you put your name and uni ID in these top two lines
// it's part of the spec and you'll lose marks if you don't!
float h = 1;
float growthX = 0 , growthY = 0;
float treeWidth = 20, treeHeight = 400;
int base = 150;
int firstBranch = 12;
int weight = 5;  //number of generation of brach
ArrayList<Flower> flowers = new ArrayList<Flower>();
float flower_size = 4;
float wind = 2, gravity = 1;
boolean flag_click = true;

Branch [] branch = new Branch[firstBranch];
void setup() {
  frameRate(30);
  size(800, 800);
  background(255);
  // you can add additional setup stuff here if you like
  
  for(int i=0; i<firstBranch; i++){
    branch[i] = new Branch(width/2,random(height - treeHeight - base,550),weight);
  }
  
}

void draw() {
  background(255); // feel free to change or remove this line
  
  fill(0);
  rect(0,height-base, width, base);
  
  if(frameCount < 100){
    h *= 1.07;
    strokeWeight(3);
    ellipse(width/2, h-10, 5, 7);
  }else if(growthX != treeWidth || growthY != treeHeight){
   
   growthX += 0.5;
   growthY += 2.5;
   growthX = growthX < treeWidth ? growthX : treeWidth;
   growthY = growthY < treeHeight ? growthY : treeHeight;
   
  }else{
    for(int i=0; i<firstBranch; i++)
      branch[i].drawBranch();
  }
  fill(0);
  strokeWeight(5);
  triangle(width/2-growthX, height-base, width/2+growthX, height-base, width/2, height-base - growthY);
  
  color c = get(mouseX, mouseY);
  if(c == -16711423){
    for(int i=0; i<20; i++){
      flowers.add(new Flower(mouseX, mouseY));
    }
  }

  if(flag_click){
    for(Flower flower: flowers){
      flower.draw();
    }
  }else{
    
    for(Flower flower: flowers){
      wind = random(-4,4);
      gravity = random(4);
      fill(flower.c);
      stroke(flower.c);
      strokeWeight(1);
      if(flower.Y < flower.fall){
        ellipse(flower.X -= wind, flower.Y += gravity, flower_size, flower_size); 
      }else{
        ellipse(flower.X, flower.Y, flower_size, flower_size);
      }

    }
  }
  // your great drawing code goes here!
}

void mouseClicked(){
  flag_click = !flag_click;
  println(flag_click);
  wind = 2; 
  gravity = 1;
}

class Flower{
  float X, Y;
  float fall;
  float alpha;
  float startTime;
  float R,G,B;
  color c;
  Flower(int x, int y){
    this.alpha = random(120,250);
    X = x + (int)random(-15,15);
    Y = y + (int)random(-15,15);
    R = random(200,255);
    G = random(125,250);
    B = random(200,250);
    c = color(R, G, B, this.alpha);
    fall = random(height-base, height);
    startTime = frameCount;
  }
  void draw(){
    float time = (frameCount-startTime)*2;
    fill(R,G,B,(this.alpha > time ? time:this.alpha));
    stroke(R,G,B,(this.alpha > time ? time:this.alpha));
    strokeWeight(1);
    ellipse(this.X, this.Y, flower_size, flower_size); 
  }
}



class Branch{
  float startX, startY;
  float endX, endY;
  float weight;
  float tempX=1, tempY=1;
  boolean stopGrowthX, stopGrowthY;
  Branch child1, child2;
  Branch(float X, float Y, float W){
    this.stopGrowthX = false;
    this.stopGrowthY = false;
    this.startX = X;
    this.startY = Y;
    this.endX = X + random(-80,80) * (W/2);
    this.endY = Y + random(-50,10) * (W/2);
    this.weight = W;
    
    if(W == 1)return;
    
    child1 = new Branch(this.endX, this.endY, this.weight -1);
    child2 = new Branch((this.startX + this.endX)/2, (this.startY + this.endY)/2, this.weight-1);
  }
  
  void drawBranch(){

   stroke(1);
   strokeWeight(this.weight);
   if(!this.stopGrowthX)this.tempX += (this.startX < this.endX ? 1 : -1);
   if(!this.stopGrowthY)this.tempY += (this.startY < this.endY ? 1 : -1);
   
   if(abs(this.startX + this.tempX - this.endX)<2)this.stopGrowthX = true;
   if(abs(this.startY + this.tempY - this.endY)<2)this.stopGrowthY = true;
   
   triangle(this.startX, this.startY, this.startX-(weight/2), this.startY-(weight/2), this.startX + this.tempX, this.startY + this.tempY); 
   
   if(this.stopGrowthX && stopGrowthY){
     if(this.weight == 1)return;
     child1.drawBranch();
     child2.drawBranch();
   }
  }
}