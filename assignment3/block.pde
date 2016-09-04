class Block{
  int X,Y;
  //int size;
  int blockSize = height/16;
  //int pixelSize = blockSize/16; 
  PImage img;
  
  Block(int x, int y, PImage i){
    X = x*blockSize;
    Y = y*blockSize;
    img = i;
    

  }
  
  void draw(){
    image(img, X, Y, blockSize, blockSize);
  }
}