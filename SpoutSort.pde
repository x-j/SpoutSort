
/*
  SpoutSort
  xj | 2018 | @try_miga
  
  based on:
    ASDF Pixel Sort
    Kim Asendorf | 2010 | kimasendorf.com
    
  many thanks to folks at spout.zeal.co for being nice

 */
 
String brag = "(ɔ) xj 2019 all rights reversed et caetera";

import spout.*;
import processing.video.*;



//DECLARING ALL THE SPOUT STUFF HERE
Spout spout;
String senderName = "SpoutSort";

String[] controlName = new String[3];
int[] controlType = new int[3];
float[] controlValue = new float[3];
String[] controlText = new String[3];

//FILE OPENING STUFF HERE
boolean fileSelected;
String filename;
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
  fileSelected = false;
  
  //SPOUT STUFF NOW
  spout = new Spout(this);
  spout.createSender(senderName, width, height);
  spout.createSpoutControl("Sorting mode", "float", 0, 3, 1);
  spout.createSpoutControl("Threshold value", "float", 0, 100, 90);
  spout.createSpoutControl("Direction", "float", 0, 2, 0);
  
  spout.openSpoutControls(senderName);

  frameRate(30); // :)
}


void draw() {
  // get inputs from spout controls
  int nControls = spout.checkSpoutControls(controlName, controlType, controlValue, controlText);
  //print("nControls = " + nControls + "\n");
  if (nControls > 0) {
    for (int i = 0; i < nControls; i++) {
      //print("(" + i + ") : [" + controlName[i] + "] : Type [" + controlType[i] + "] : Value [" + controlValue[i] + "] : Text [" + controlText[i] + "]" + "\n");
      if (controlName[i].equals("Sorting mode")) {
          mode = (int)controlValue[i];
      }
      if (controlName[i].equals("Threshold value")) {
         threshold = (int)controlValue[i];
      }
      if(controlName[i].equals("Direction")){
          direction = (int)controlValue[i];
      }
    }
  }
  //file opening
  if(!fileSelected){
     selectInput("Select a file to process:", "selectFile");
     while(!fileSelected){
       delay(200); 
     }
     movie = new Movie(this, filename);
     movie.loop();
     movie.frameRate(30);
  }

  
  if(movie.available())
   movie.read();
  img.resize(movie.width, movie.height);
  img.copy(movie, 0,0, movie.width, movie.height, 0,0, movie.width, movie.height);
  // background(0, 100);
  spout.resizeFrame();
 
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
    text(brag.subSequence(0,6).toString()+brag.substring(7).toUpperCase(), width - 444, height - 25, width, height);
  }
  spout.sendTexture(img);
}

void blackSort(){
  // loop through columns
  if(direction % 2 ==0){
    while(column < img.width-1) {
      //println("Sorting Column " + column);
      
      sortBlackColumn();
      column++;
      
    }
  }
  // loop through rows
  if(direction >= 1){
    while(row < img.height-1) {
      //println("Sorting Row " + column);
      sortBlackRow();
      row++;
    } 
  }
}

void brightSort(){
  // loop through columns
  if(direction % 2 ==0){
    while(column < img.width-1) {
      //println("Sorting Column " + column);
      sortBrightColumn();
      column++;
    }
  }
  if(direction >= 1){
    // loop through rows
    while(row < img.height-1) {
      //println("Sorting Row " + column);
       
      sortBrightRow();
      
      row++;
    }
  }
}

void whiteSort(){
  if(direction % 2 == 0){
 // loop through columns
        while(column < img.width-1) {
          //println("Sorting Column " + column);
           
          sortWhiteColumn();
          column++;
          
        }
  }
      // loop through rows
  if(direction >= 1){
        while(row < img.height-1) {
          //println("Sorting Row " + column);
           
          sortWhiteRow();
          
          row++;
        }
  }
}

void sortThisRow(int x, int xend, int y){
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

void sortThisColumn(int x, int y, int yend){
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

void sortBlackRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    x = getFirstNotBlackX(x, y);
    xend = getNextBlackX(x, y);
    
    if(x < 0) break;
    
    sortThisRow(x, xend, y);
    
    x = xend+1;
  }
}

void sortBlackColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
      y = getFirstNotBlackY(x, y);
      yend = getNextBlackY(x, y);
    
    if(y < 0) break;
    
    sortThisColumn(x, y, yend);
    
    y = yend+1;
  }
}

void sortBrightRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    x = getFirstBrightX(x, y);
    xend = getNextDarkX(x, y);
    
    if(x < 0) break;
    
    sortThisRow(x, xend, y);
    x = xend + 1;
  }
}

void sortBrightColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
      y = getFirstBrightY(x, y);
      yend = getNextDarkY(x, y);
    
    if(y < 0) break;
    
    sortThisColumn(x, y, yend);
    
    y = yend+1;
  }
}

void sortWhiteRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    x = getFirstNotWhiteX(x, y);
    xend = getNextWhiteX(x, y);
    
    if(x < 0) break;
    
    sortThisRow(x, xend, y);
    
    x = xend+1;
  }
}

void sortWhiteColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0;
  
  while(yend < img.height-1) {
      y = getFirstNotWhiteY(x, y);
      yend = getNextWhiteY(x, y);
    
    if(y < 0) break;
    
    sortThisColumn(x, y, yend);
    
    y = yend+1;
  }
}



// black x
int getFirstNotBlackX(int x, int y) {
  
  while(img.pixels[x + y * img.width] < blackValue) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  
  return x;
}

int getNextBlackX(int x, int y) {
  x++;
  
  while(img.pixels[x + y * img.width] > blackValue) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  
  return x-1;
}

// brightness x
int getFirstBrightX(int x, int y) {
  
  while(brightness(img.pixels[x + y * img.width]) < threshold) {
    x++;
    if(x >= img.width)
      return -1;
  }
  
  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  
  while(brightness(img.pixels[x + y * img.width]) > threshold) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// white x
int getFirstNotWhiteX(int x, int y) {

  while(img.pixels[x + y * img.width] > threshold) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;

  while(img.pixels[x + y * img.width] < threshold) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  return x-1;
}


// black y
int getFirstNotBlackY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] < threshold) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextBlackY(int x, int y) {
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
int getFirstBrightY(int x, int y) {

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) < threshold) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextDarkY(int x, int y) {
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
int getFirstNotWhiteY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > threshold) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextWhiteY(int x, int y) {
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

void selectFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");       
  } else {
    println("User selected " + selection.getAbsolutePath());
    filename = selection.getAbsolutePath();
    fileSelected = true;
  }
}


// SELECT A SPOUT SENDER
// void mousePressed() {
//   // RH click to select a sender
//   if (mouseButton == RIGHT) {
//     // Bring up a dialog to select a sender.
//     // Spout installation required
//     spout.selectSender();
//   }
// }
//CHANGE VIDEO:
void mousePressed(){
 //RH click to change video
 if(mouseButton == RIGHT)
   fileSelected = false;
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
    
  if(key == ' ' && looping){
    looping = false;
    noLoop();
  }
  else if(key == ' ' && !looping){
    looping = true;
    loop();
  }
  
}