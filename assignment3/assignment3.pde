// ID: u5934839 (replace with your own uni ID)
// Name: Taku Ueki (replace with your name)
int blockSize = height/16;
int pixelSize = blockSize/16;
PImage blockImg;
PImage BulletBillRight, BulletBillLeft;
Block block;
ArrayList<Block> blocks = new ArrayList<Block>();
BulletBill bulletBill;
ArrayList<BulletBill> bulletBills = new ArrayList<BulletBill>();
Mario mario;

void setup() {
  //fullScreen();
  frameRate(25);
  size(1024,768);
  background(51,153,255);
  // you can add additional setup stuff here if you like
  blockImg = loadImage("img/base2.png");
  BulletBillRight = loadImage("img/BulletBillRight.png");
  BulletBillLeft = loadImage("img/BulletBillLeft.png");

  mario = new Mario(2,13);
  
  for(int i=0; i<22; i++)
    for(int j=14; j<16; j++){
      block = new Block(i,j,blockImg);
      blocks.add(block);
    }
  mario.setStage(blocks);
}

void draw() {
  // your great drawing code goes here!
  //Block block = new Block(0,15,blockImage);
  background(51,153,255);
  for(Block block : blocks)
    block.draw();
  
  if(keyPressed == false && !mario.jumping)
    mario.stand();
    
  mario.draw();
  attack();
  //print(width);
  for(BulletBill bulletBill : bulletBills)
    bulletBill.draw();

}

void keyPressed(){
  if(key == CODED)
    switch(keyCode){
      case RIGHT:
        //mario.walk(1);
        mario.right = true;
        break;
      case LEFT:
        //mario.walk(-1);
        mario.left = true;
        break;
      case UP:
        mario.jump();
        mario.jump = true;
        break;
      default:
        break;
    }
}
void keyReleased(){
  if(key == CODED)
    switch(keyCode){
      case RIGHT:
        mario.right = false;
        mario.direction = 1;
        break;
      case LEFT:
        mario.left = false;
        mario.direction = -1;
        break;
      case UP:
        mario.jump = false;
        break;
      default:
        break;
    }
}

void attack(){
  if(frameCount % 3 == 0)
  if(random(30) > 28){
    if(random(1) > 0.5){    //right
      bulletBill = new BulletBill(0, (int)random(10, 14), BulletBillRight, 1);
    }else{    //left
      bulletBill = new BulletBill(20, (int)random(10, 14), BulletBillLeft, -1);
    }
    bulletBills.add(bulletBill);
  }
    
}
