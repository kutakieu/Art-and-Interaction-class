// ID: u5934839 (replace with your own uni ID)
// Name: Taku Ueki (replace with your name)

int blockSize = height/16;
int pixelSize = blockSize/16;
PImage blockImg, marioRight, marioLeft, marioJumpRight, marioJumpLeft; 
PImage marioWalkLeft1, marioWalkLeft2, marioWalkLeft3;
PImage marioWalkRight1, marioWalkRight2, marioWalkRight3;
Block block;
ArrayList<Block> blocks = new ArrayList<Block>();
Mario mario;

void setup() {
  //fullScreen();
  frameRate(30);
  size(1024,768);
  background(51,153,255);
  // you can add additional setup stuff here if you like
  blockImg = loadImage("img/base2.png");

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
  //if(keyCode == UP)
  //  System.out.print("UP ");
  //if(keyCode == DOWN)
  //  System.out.println("down");
  ////System.out.println("aaaaaa");
}

void keyPressed(){
  if(key == CODED)
    switch(keyCode){
      case RIGHT:
        mario.walk(1);
        break;
      case LEFT:
        mario.walk(-1);
        break;
      case UP:
        mario.jump();
        break;
      default:
        break;
    }
  //if(keyCode == UP)
  //  System.out.print("UP ");
  //if(keyCode == DOWN)
  //  System.out.println("down");
  //System.out.println();
}
void keyReleased(){
  if(key == CODED)
    switch(keyCode){
      case RIGHT:
        //mario.walk(1);
        print(keyCode);
        break;
      case LEFT:
        print(keyCode);
        //mario.walk(-1);
        break;
      case UP:
        print(keyCode);
        //mario.jump();
        break;
      default:
        break;
    }
}
