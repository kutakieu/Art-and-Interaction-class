class BulletBill{
  int X,Y;
  //int size;
  int blockSize = height/16;
  //int pixelSize = blockSize/16; 
  int direction;
  int speed = 24;
  PImage img;
  
  BulletBill(int x, int y, PImage i, int d){
    X = x*blockSize;
    Y = y*blockSize;
    img = i;
    direction = d;
  }
  
  void draw(){
    X += speed * direction;
    image(img, X, Y, blockSize, blockSize);
  }
}