/*color histograms or bins 16×16×16 */
import processing.video.*; 
import java.util.*;
//import java.util.LinkedList.*;
Capture video;

PImage pFrame, /* video previous frame */ 
       cFrame, /* video current frame */
       inFrame, /* video current frame (no modifications applied) */
       bFrame; /* video background frame */
PGraphics outFrame; /* the out frame with tracked pedestrians on it */
PGraphics rectangles;

/* reason to make it float -- see below  */
int[] mR;
int[] mB;
int[] mG;

int[] mGRAY;

int[] binaryImage;
boolean [] binaryVisited;

/* several threshold valuescan be used for different colors */
int threshold = 50; /* this one should be adjust put it as an input parameter somehow */

/* objects greater than 6*6 will be considered as moving objects */
int thresholdObj = 6*6; 

boolean flagAverage = true;

final int BINSIZE = 16;
final int EPS = 50; 

int backgroundIdx = 0;  /* index to count the frames for background */
int backgroundN = 45; /* number of frames to get the background */

// ArrayList<Pedestrian> pedestrians = new ArrayList<Pedestrian>();

void setup(){
  size(640, 480);
  video = new Capture(this, width, height, 30); /* fps = 30 */
  video.start();
  bFrame = createImage(video.width, video.height, RGB);
  pFrame = createImage(video.width, video.height, RGB);
  cFrame = createImage(video.width, video.height, RGB);
  inFrame = createImage(video.width, video.height, RGB);
  outFrame = createGraphics(video.width, video.height);
  rectangles =  createGraphics(video.width, video.height);
  frameRate(30);
  
  mR = new int [video.width*video.height];
  mG = new int [video.width*video.height];
  mB = new int [video.width*video.height];
  mGRAY = new int [video.width*video.height];
  
  binaryImage = new int [video.width*video.height];
  binaryVisited = new boolean [video.width*video.height]; 

  initialize();

}

void draw(){
  if (video.available()) {
    inFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
    video.read();
    /* set current frame */
    cFrame.copy(inFrame, 0, 0, width, height, 0, 0, width, height);
    cFrame.filter(GRAY);
    
    if (frameCount < backgroundN){ /* wait seconds for camera to start */
      /* dummy to prevent errors */
      rectangles.beginDraw();
      rectangles.endDraw();
      /* accumulate background colors */
      //accColors(cFrame);
      accColorsGray(cFrame);
      ++backgroundIdx;
      // outFrame.loadPixels();
      // outFrame.copy(cFrame, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
      // outFrame.updatePixels();  
      println(backgroundIdx);
      
    }
    else{
      if (flagAverage) {
        //avgColors(cFrame, backgroundIdx);
        avgColorsGray(cFrame, backgroundIdx);
        flagAverage = !flagAverage;  
      }
      //resetBinaryImage(); /* ?redundant? check the way the function below is written */
      //subtractFrames(cFrame);
      //resetBinaryVisited();
      resetBinaryImage(); /* ?redundant? check the way the function below is written */
      subtractFramesGray(cFrame);
      resetBinaryVisited();
      // findClusters();
      findInitialObjects();
      /* at this point we know the number of objects */
      
      
      /* DEBUG */
      if (frameCount == 55) {
        bFrame.loadPixels();
        for (int i = 0; i < height; ++i)
          for (int j = 0; j < width; ++j)
            bFrame.pixels[i*width + j] = binaryImage[i*width + j] == 1 ? 0xffffff : 0x000000;
        bFrame.updatePixels(); 
        bFrame.save("data/out.jpg");
        saveFrame("data/output-######.png");
      }
      /*-------*/
      
      // track();
      // outFrame.loadPixels();
      // outFrame.copy(cFrame, 0, 0, video.width, video.height, 0, 0, video.width, video.height); 
      // outFrame.updatePixels();  
  }
      pushMatrix();
        scale(-1, 1);
        translate(-width, 0);
        image(cFrame, 0,0);
        image(rectangles, 0, 0);
      popMatrix();
      /* copy last image */
      pFrame.copy(cFrame, 0, 0, width, height, 0, 0, width, height);
      rectangles.clear();
    
  }
}


/* TODO: There is a better formula for this one 
   SEE: Handwritings */
/* subtracts incoming image from the background 
   we use all colors for accuracy but tot speed up the process 
   we could use only gray scale */
void subtractFrames(PImage inImage){
  inImage.loadPixels();
  for (int i =0; i < inImage.height; ++i){
    for (int j =0; j < inImage.width; ++j){
      if (abs((inImage.pixels[i*inImage.width + j] >> 16 & 0xff)  - mR[i*inImage.width + j]) > threshold |
          abs((inImage.pixels[i*inImage.width + j] >>  8 & 0xff)  - mG[i*inImage.width + j]) > threshold |
          abs((inImage.pixels[i*inImage.width + j]       & 0xff)  - mB[i*inImage.width + j]) > threshold)
        binaryImage[i*inImage.width + j] = 1;
      else 
        binaryImage[i*inImage.width + j] = 0;
    }
  }
}

void subtractFramesGray(PImage inImage){
  inImage.loadPixels();
  for (int i =0; i < inImage.height; ++i){
    for (int j =0; j < inImage.width; ++j){
      if (abs((inImage.pixels[i*inImage.width + j] & 0xff)  - mGRAY[i*inImage.width + j]) > threshold)
        binaryImage[i*inImage.width + j] = 1;
      else 
        binaryImage[i*inImage.width + j] = 0;
    }
  }
}

/* this function takes into account the light update*/
void subtractFrames2(PImage inImage){
  float beta = 0.1;
  inImage.loadPixels();
  for (int i =0; i < inImage.height; ++i){
    for (int j =0; j < inImage.width; ++j){
      /*Extra step -- light update */
      mR[i*inImage.width + j] = int( beta*(inImage.pixels[i*inImage.width + j] >> 16 & 0xff)  + (1 - beta)*mR[i*inImage.width + j]);
      mG[i*inImage.width + j] = int( beta*(inImage.pixels[i*inImage.width + j] >>  8 & 0xff)  + (1 - beta)*mG[i*inImage.width + j]);
      mB[i*inImage.width + j] = int( beta*(inImage.pixels[i*inImage.width + j]       & 0xff)  + (1 - beta)*mB[i*inImage.width + j]);
        
      if (abs((inImage.pixels[i*inImage.width + j] >> 16 & 0xff)  - mR[i*inImage.width + j]) > threshold |
          abs((inImage.pixels[i*inImage.width + j] >>  8 & 0xff)  - mG[i*inImage.width + j]) > threshold |
          abs((inImage.pixels[i*inImage.width + j]       & 0xff)  - mB[i*inImage.width + j]) > threshold)
        binaryImage[i*inImage.width + j] = 1;
      else 
        binaryImage[i*inImage.width + j] = 0;
    }
  }
}

void resetBinaryImage(){
  for (int i = 0; i < binaryImage.length; ++i)
    binaryImage[i] = 0;
}

void resetBinaryVisited(){
  for (int i = 0; i < binaryVisited.length; ++i)
    binaryVisited[i] = false;
} 

void findInitialObjects(){
  int objNum = 0;
  int[] params = new int[4];
  /*[0] - xMin 
    [1] - yMin 
    [2] - xMax
    [3] - yMax
    []*/
  rectangles.beginDraw();
  rectangles.rectMode(CORNERS); /* put in setup */
  rectangles.stroke(255, 0, 0);
  rectangles.noFill();
  for(int i = 0; i < cFrame.height; ++i){
    for (int j = 0; j < cFrame.width; ++j){
      if (!binaryVisited[i*cFrame.width + j]){ /* wasn't visited */
        binaryVisited[i*cFrame.width + j] = true;  // ??? // 
        if (binaryImage[i*cFrame.width + j] != 0){
       
          /* if we are here we have one pixel object at least*/
          params[0] = j;
          params[1] = i;
          params[2] = j;
          params[3] = i;
          
          //dfs(i, j, params);
          bfs(i, j, params);
          ++objNum;
          
          rectMode(CORNERS);
          /*Skip small objects */
         
          if ((params[2] - params[0])*(params[3] - params[1]) > thresholdObj){
            // println((params[2] - params[0])*(params[3] - params[1]));
            rectangles.rect(params[0], params[1], params[2], params[3]);
          }
          // println(params[0], params[1], params[2], params[3]);
        }
      }
    }
  }
  rectangles.endDraw();
  //println(objNum);
}

void bfs(int i, int j, int[] params){
   Queue<Integer> qX = new LinkedList();
   Queue<Integer> qY = new LinkedList();
   
   qX.add(j);
   qY.add(i);
   binaryVisited[i*cFrame.width + j] = true; /* visited current node */
   
   /* length(qX) == length(qY)*/
   while (!qX.isEmpty()){
     int jC = qX.poll();
     int iC = qY.poll();
     
     if (jC - 1 > 0)
        if (!binaryVisited[iC*cFrame.width + (jC - 1)]){
          if (binaryImage[iC*cFrame.width + (jC - 1)] != 0){ /* TODO: this one should be better checked */
            if (params[0] > jC - 1)
              params[0] = jC - 1;
            qX.add(jC - 1);
            qY.add(iC);
            binaryVisited[iC*cFrame.width + (jC - 1)] = true; 
          }
        }
      if(iC - 1 > 0)  
        if (!binaryVisited[(iC - 1)*cFrame.width + jC]){
          if (binaryImage[(iC - 1)*cFrame.width + jC] != 0) { /* TODO: this one should be better checked */
            if (params[1] > iC - 1)
              params[1] = iC - 1;
            qX.add(jC);
            qY.add(iC - 1);
            binaryVisited[(iC - 1)*cFrame.width + jC] = true; 
          } 
        }
      if (jC + 1 < cFrame.width)
        if (!binaryVisited[iC*cFrame.width + (jC + 1)]){
          if (binaryImage[iC*cFrame.width + (jC + 1)] != 0){ /* TODO: this one should be better checked */
            if (params[2] < jC + 1)
              params[2] = jC + 1;
            qX.add(jC + 1);
            qY.add(iC);
            binaryVisited[iC*cFrame.width + (jC + 1)] = true; 
          }
        }
      if(iC + 1 < cFrame.height)  
        if (!binaryVisited[(iC + 1)*cFrame.width + jC]){
          if (binaryImage[(iC + 1)*cFrame.width + jC] != 0) { /* TODO: this one should be better checked */
            if (params[3] < iC + 1)
              params[3] = iC + 1;
            qX.add(jC);
            qY.add(iC + 1);
            binaryVisited[(iC + 1)*cFrame.width + jC] = true; 
          } 
        }
     
   } 
}


void getInititalObjects(){
  
}



void track2(){
  pFrame.loadPixels();
  cFrame.loadPixels();
  outFrame.loadPixels();
  // outFrame.beginDraw();
  // outFrame.noStroke();
  for (int i = 0; i < height; ++i)
    for (int j = 0; j < width; ++j){
      //println(hex(outFrame.pixels[i*width + j]), hex(pFrame.pixels[i*width + j]));
      // if (abs(cFrame.pixels[i*width + j] - pFrame.pixels[i*width + j]) < 10)
      if (isSameG(i, j))
        outFrame.pixels[i*width + j] = cFrame.pixels[i*width + j];
      else 
        outFrame.pixels[i*width + j] = color(255, 0, 0);
  }
  // outFrame.endDraw();
  outFrame.updatePixels();
}


/* returns red matrix */
void getMR(){
  for (int i =0; i < bFrame.height; ++i){
    for (int j =0; j < bFrame.width; ++j){
      mR[i*bFrame.width + j] = (bFrame.pixels[i*bFrame.width + j] >> 16) & 0xff;
    }
  }
}


void initialize(){
  for (int i =0; i < bFrame.height*bFrame.width; ++i){
    mR[i] = 0;
    mG[i] = 0;
    mB[i] = 0; 
    mGRAY[i] = 0; /* WATCH OUT!*/
  }
}

/* accumulate colors of the bacground*/
void accColors(PImage img){
  img.loadPixels();
  for (int i =0; i < img.height; ++i){
      for (int j =0; j < img.width; ++j){
        mR[i*img.width + j] += img.pixels[i*img.width + j] >> 16 & 0xff;
        mG[i*img.width + j] += img.pixels[i*img.width + j] >> 8 & 0xff;
        mB[i*img.width + j] += img.pixels[i*img.width + j]  & 0xff;
      }
    }
}

void accColorsGray(PImage img){
  img.loadPixels();
  for (int i =0; i < img.height; ++i){
      for (int j =0; j < img.width; ++j){
        mGRAY[i*img.width + j] += img.pixels[i*img.width + j] & 0xff; /* >> 16 and >> 8 are also fine*/
      }
    }
}

void avgColors(PImage img, int num){
  for (int i =0; i < img.height; ++i){
    for (int j =0; j < img.width; ++j){
      mR[i*img.width + j] /= num;
      mG[i*img.width + j] /= num;
      mB[i*img.width + j] /= num;
    }
   } 
}

void avgColorsGray(PImage img, int num){
  for (int i =0; i < img.height; ++i){
    for (int j =0; j < img.width; ++j){
      mGRAY[i*img.width + j] /= num;
    }
   } 
}

/* returns green matrix */
void getMG(){
  for (int i =0; i < bFrame.height; ++i){
    for (int j =0; j < bFrame.width; ++j){
      mG[i*bFrame.width + j] = bFrame.pixels[i*bFrame.width + j] >> 8 & 0xff;
    }
  }
}

/* returns blue matrix */
void getMB(){
  for (int i =0; i < bFrame.height; ++i){
    for (int j =0; j < bFrame.width; ++j){
      mB[i*bFrame.width + j] = bFrame.pixels[i*bFrame.width + j]  & 0xff;
    }
  }
}

boolean isSameG(int i, int j){
  int c = cFrame.pixels[i*width + j];
  int p = pFrame.pixels[i*width + j];
  return abs(c & 0xff - p & 0xff) < EPS;
}

boolean isSame(int i, int j){
  int c = cFrame.pixels[i*width + j];
  int p = pFrame.pixels[i*width + j];
  /* maybe it is more useful to check each color separetly ?*/
  return (abs(c >> 16 & 0xff - p >> 16 & 0xff) < EPS &&
          abs(c >> 8 & 0xff - p >> 8 & 0xff) < EPS && 
          abs(c & 0xff - p & 0xff) < EPS);
  
  /* check if colors are close to each other */
  //return dist(c >> 16 & 0xff, p >> 16 & 0xff, c >> 8 & 0xff, p >> 8 & 0xff, c & 0xff, p & 0xff) < EPS; 
}

void mouseClicked(){
  save("data/output-#####.png");
  rectangles.clear();
}

void keyPressed(){
  if (keyCode == 's' || keyCode == 'S')
    saveFrame("data/output-######.png");
}