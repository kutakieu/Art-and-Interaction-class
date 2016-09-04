class Block{
  int X,Y;
  //int size;
  int blockSize = height/16;
  //int pixelSize = blockSize/16; 
  PImage img;
  
  Block(int x, int y, PImage img){
    X = x*blockSize;
    Y = y*blockSize;
  }
  
  void draw(){
    image(img, X, Y);
  }
}