
/*
  SpoutlessSort
  xj | 2019 | @try_miga
  
  based on:
    ASDF Pixel Sort
    Kim Asendorf | 2010 | kimasendorf.com
    
  many thanks to folks at spout.zeal.co for being nice

 */
 
String f_brag = "(ɔ) xj 2019 all rights reversed et caetera";

import processing.video.*;


//FILE OPENING STUFF HERE
boolean f_fileSelected;
String f_filename;
Movie movie;

//processing image stuff
PGraphics pgr;
PImage img;

// sorting modes: 0 = RED  1 = brightness  2 = GREEN 3 = KURWA HEX :DDDDD TODO: zrobi sie potem
int mode = 1;
int TOTAL_NUM_OF_MODES = 4; //this is used for Spout controls

// 0 = vertical  1 = horizontal 2 = both?! TODO: change to Left, Right, Up, Down
int direction = 0;

int threshold = 80;
int maxThreshold = 100; //this is used for Spout controls

//THIS WAS DEBUGGING:::
// threshold values to determine sorting start and end pixels
//starting values:
int blackStartV = 0;
int whiteStartV = 50;
int brightnessStartV = 50;

//a sine oscillator will be scaled by the vars below and then added to current threshold value
int blackValueFlux = -100;
int whiteValueFlux = 50;
int brightnessValueFlux = 50;

int blackValue;
int whiteValue;
int brightnessValue;

int row;
int column;

boolean displayWords;

boolean looping = true;
long currTime, prevTime;
long elapsedTime;

void setup() {  
  // use only numbers (not variables) for the size() command, Processing 3
  size(1280, 720, P3D);
  noSmooth(); //who the korva needs anti-aliasing
  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  textureMode(NORMAL);

  pgr = createGraphics(width,height, PConstants.P2D);
  img = createImage(width, height, ARGB);
  
  displayWords = true;
  
   //file opening stuff
  f_fileSelected = false;
  
  frameRate(30); // :)
}


void draw() {
  //file opening
  if(!f_fileSelected){
     selectInput("Select a file to process:", "f_selectFile");
     while(!f_fileSelected){
       delay(200); 
     }
     movie = new Movie(this, f_filename);
     movie.loop();
     movie.frameRate(30);
  }

  
  if(movie.available())
   movie.read();
  img.resize(movie.width, movie.height);
  img.copy(movie, 0,0, movie.width, movie.height, 0,0, movie.width, movie.height);
  // background(0, 100);
 
  // img = spout.receivePixels(img);
  
  row = 0;
  column = 0;
  
  //change tresholds:
  //brightnessValue = brightnessStartV + int(sin(radians(frameCount)) * brightnessValueFlux);
  //blackValue = blackStartV + int(sin(radians(frameCount)) * blackValueFlux);
  //whiteValue = whiteStartV + int(sin(radians(frameCount)) * whiteValueFlux);
    brightnessValue = threshold;
  blackValue = threshold;
  whiteValue = threshold;
  
  String trueWords = "current mode: ";
  img.loadPixels();
  switch(mode) {
    case 0:
      trueWords += " black.\n current threshold: "+blackValue;
      blackSort();
      break;

    case 1:
      trueWords += "brightness.\n current threshold: "+brightnessValue;
      brightSort();
      break;

    case 2:
      trueWords += "white.\n current threshold: "+whiteValue;
      whiteSort();
      break;

    default:
      break;
  }
  img.updatePixels();
  if(displayWords){
    trueWords +="   ";
    trueWords += direction == 0 ? "|||" : direction == 1 ? "===" : "///";
    
    trueWords += "\n\nprocessed frames: "+frameCount;
    trueWords += "\nfps: "+frameRate;
    textSize(20);
  }
  image(img, 0,0, width, height);
  if(displayWords){
    text(trueWords, 10, 10, 350, 380);
    text(f_brag.subSequence(0,6).toString()+f_brag.substring(7).toUpperCase(), width - 444, height - 25, width, height);
  }
}

void blackSort(){
  // loop through columns
  if(direction % 2 ==0){
    while(column < img.width-1) {
      //println("Sorting Column " + column);
      
      f_sortBlackColumn();
      column++;
      
    }
  }
  // loop through rows
  if(direction >= 1){
    while(row < img.height-1) {
      //println("Sorting Row " + column);
      f_sortBlackRow();
      row++;
    } 
  }
}

void brightSort(){
  // loop through columns
  if(direction % 2 ==0){
    while(column < img.width-1) {
      //println("Sorting Column " + column);
      f_sortBrightColumn();
      column++;
    }
  }
  if(direction >= 1){
    // loop through rows
    while(row < img.height-1) {
      //println("Sorting Row " + column);
       
      f_sortBrightRow();
      
      row++;
    }
  }
}

void whiteSort(){
  if(direction % 2 == 0){
 // loop through columns
        while(column < img.width-1) {
          //println("Sorting Column " + column);
           
          f_sortWhiteColumn();
          column++;
          
        }
  }
      // loop through rows
  if(direction >= 1){
        while(row < img.height-1) {
          //println("Sorting Row " + column);
           
          f_sortWhiteRow();
          
          row++;
        }
  }
}

void f_sortThisRow(int x, int xend, int y){
  int sortLength = xend-x;
    
  color[] unsorted = new color[sortLength];
  color[] sorted = new color[sortLength];
  
  for(int i=0; i<sortLength; i++) {
    unsorted[i] = img.pixels[x + i + y * img.width];
  }
  
  sorted = sort(unsorted);
  
  for(int i=0; i<sortLength; i++) {
    img.pixels[x + i + y * img.width] = sorted[i];      
  }
}

void f_sortThisColumn(int x, int y, int yend){
  int sortLength = yend-y;
      
  color[] unsorted = new color[sortLength];
  color[] sorted = new color[sortLength];
  
  for(int i=0; i<sortLength; i++) {
    unsorted[i] = img.pixels[x + (y+i) * img.width];
  }
  
  sorted = sort(unsorted);
  
  for(int i=0; i<sortLength; i++) {
    img.pixels[x + (y+i) * img.width] = sorted[i];
  }
}

void f_sortBlackRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    x = f_getFirstNotBlackX(x, y);
    xend = f_getNextBlackX(x, y);
    
    if(x < 0) break;
    
    f_sortThisRow(x, xend, y);
    
    x = xend+1;
  }
}

void f_sortBlackColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
      y = f_getFirstNotBlackY(x, y);
      yend = f_getNextBlackY(x, y);
    
    if(y < 0) break;
    
    f_sortThisColumn(x, y, yend);
    
    y = yend+1;
  }
}

void f_sortBrightRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    x = f_getFirstBrightX(x, y);
    xend = f_getNextDarkX(x, y);
    
    if(x < 0) break;
    
    f_sortThisRow(x, xend, y);
    x = xend + 1;
  }
}

void f_sortBrightColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
      y = f_getFirstBrightY(x, y);
      yend = f_getNextDarkY(x, y);
    
    if(y < 0) break;
    
    f_sortThisColumn(x, y, yend);
    
    y = yend+1;
  }
}

void f_sortWhiteRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    x = f_getFirstNotWhiteX(x, y);
    xend = f_getNextWhiteX(x, y);
    
    if(x < 0) break;
    
    f_sortThisRow(x, xend, y);
    
    x = xend+1;
  }
}

void f_sortWhiteColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
      y = f_getFirstNotWhiteY(x, y);
      yend = f_getNextWhiteY(x, y);
    
    if(y < 0) break;
    
    f_sortThisColumn(x, y, yend);
    
    y = yend+1;
  }
}



// black x
int f_getFirstNotBlackX(int x, int y) {
  
  while(img.pixels[x + y * img.width] < blackValue) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  
  return x;
}

int f_getNextBlackX(int x, int y) {
  x++;
  
  while(img.pixels[x + y * img.width] > blackValue) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  
  return x-1;
}

// brightness x
int f_getFirstBrightX(int x, int y) {
  
  while(brightness(img.pixels[x + y * img.width]) < threshold) {
    x++;
    if(x >= img.width)
      return -1;
  }
  
  return x;
}

int f_getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  
  while(brightness(img.pixels[x + y * img.width]) > threshold) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// white x
int f_getFirstNotWhiteX(int x, int y) {

  while(img.pixels[x + y * img.width] > threshold) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  return x;
}

int f_getNextWhiteX(int x, int y) {
  x++;

  while(img.pixels[x + y * img.width] < threshold) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  return x-1;
}


// black y
int f_getFirstNotBlackY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] < threshold) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int f_getNextBlackY(int x, int y) {
  y++;

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > threshold) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  
  return y-1;
}

// brightness y
int f_getFirstBrightY(int x, int y) {

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) < threshold) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int f_getNextDarkY(int x, int y) {
  y++;

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) > threshold) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}

// white y
int f_getFirstNotWhiteY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > threshold) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int f_getNextWhiteY(int x, int y) {
  y++;
  
  if(y < img.height) {
    while(img.pixels[x + y * img.width] < threshold) {
      y++;
      if(y >= img.height) 
        return img.height-1;
    }
  }
  
  return y-1;
}

void f_selectFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");       
  } else {
    println("User selected " + selection.getAbsolutePath());
    f_filename = selection.getAbsolutePath();
    f_fileSelected = true;
  }
}


 //SELECT A SPOUT SENDER
 //void mousePressed() {
 //  // RH click to select a sender
 //  if (mouseButton == RIGHT) {
 //    // Bring up a dialog to select a sender.
 //    // Spout installation required
 //    spout.selectSender();
 //  }
 //}
//CHANGE VIDEO:
void mousePressed(){
 //RH click to change video
 if(mouseButton == RIGHT)
   f_fileSelected = false;
}
//CHANGE MODE:
void keyPressed(){
  if(key == '1')
    mode = 1;
  if(key == '2')
    mode = 2;
  if(key == '3')
    mode = 0;
  if(key == '4')
    direction = 0;
  if(key == '5')
    direction = 1;
  if(key == '6')
    direction = 2;
  if(key == '0')
    displayWords = !displayWords;
   
  if(key == '-')
    threshold -= 1;
  if(key == '=')
    threshold += 1;
  if(key == '_')
    threshold -= 10;
  if(key == '+')
    threshold += 10;
    
  if(key == ' ' && looping){
    looping = false;
    noLoop();
  }
  else if(key == ' ' && !looping){
    looping = true;
    loop();
  }
  
}
