

import processing.pdf.*;
boolean saveOneFrame = false;


import controlP5.*;


/////////
//  VARIABLE TRIGONOMETRIQUES

// 84 // 111 // 99 //120 // 90

int divisionDuCercle = 99;

int nbDents = divisionDuCercle / 3;
//nbDents = 30;
int initNbTeeth = nbDents;

float r = 0; // radius
float x, y; // position
float xCercleTrigo, yCercleTrigo;


float[][] circleData, circleData2, normData, normData2;


int nbInput = 8;//nb Of Points for a Teeth.

float[][] gearPoints ;
int nbCirclePoints = 4;
int indexPoint = 0;     // INDEX POINT IS USE IN CALCUL TEETH
//GEAR SHAPE
PShape sh;



float[][] curvePoints, curvePoints2;

//Reference du cercle trigonométrique
PVector zeroDegre ; // Chaque engrenage aura sa réference trigonométrique.

float modelRadius = 0;
boolean reverse = false;

float scalingX, scalingY;

// radius between teeth
float radiusBetweenTeeth=0;



float[][] centerCircle;
int centerPointNumber = nbDents;


/////////////
// DIMENSIONS
float divide = 7;  // divide reality factor

float epaisseur = 7 * divide ;
float centerCircleRadius = 13 * divide / 2 ;


///////
//  MIDDLE POINTS

float[][] middlePointsUp = new float[nbDents][2];
float[][] middlePointsDown = new float[nbDents][2];


int nbOfCenterHoles = 0;   // number of center holes is number of brackets we desire, number of brackets is number we can get
int nbOfBrackets = 0;

///////////////


///////
//  LINEAR GEAR

float[][] linearGear;
int nbOfTeethInLine = 14;
float xL = 200;  //x start for Linear Gear


/////////////////////

// 84 // 111 // 99 //120 // 90


int[] divisionDuCerclePossible;


ControlP5 cp5;

Textlabel nbTeethLabel;

float hauteurDeDent = 0;


//GUI

//GENERAL PARAMETER
float xGeneralParamater = 50;
float xGeneralParameterSlider = 200;
int parameterFontSize = 25;
//float yGeneralParameterOffset = 40;
int parameterSliderWidth = 120;
int parameterSliderHeight = 20;


float xGUIInfo = 400;
int guiInfoSize = 20;

int infoFontSize = 20;

float xExportParameter = 850;



float xGUIModes = 600;

char gearMode = 's';







 int enleverDents = 0;
 
void setup() {

  size(displayHeight, displayHeight, OPENGL);
  smooth();

  r = width/2;
  modelRadius = r;

  x = width/2;
  y = height/2;

  centerCircle = new float[centerPointNumber][3];

  circleData = new float[nbInput][3];
  normData = new float[nbInput][4];

  circleData2 = new float[nbInput][3];
  normData2 = new float[nbInput][4];

  curvePoints = new float[nbInput][2];
  curvePoints2 = new float[nbInput][2];

  // reference du Cercle Trigonométrique
  zeroDegre = new PVector(width/2, 0);

  xCercleTrigo = x;
  yCercleTrigo = y;

  scalingX = 1;
  scalingY = 0.7;

  initialisationTrigonometrie();

  // CALCUL DES INTERSECTIONS
  calculIntersection();

  gearPoints = new float[curvePoints.length*2*nbDents + nbCirclePoints*nbDents][3];

  calculTeeth();

  radiusBetweenTeeth = calculDiametre(gearPoints[1][0] - gearPoints[2][0], gearPoints[1][1] - gearPoints[2][1] );

  sh = createShape();


  buildGUI();
  
  
  buildGear();
  
  
  
}


void draw() {

  background(255);

  cp5.get(Textlabel.class, "gearDiameter")
    .setText("Gear Diameter:          " + ((r + hauteurDeDent*2)/divide)+ " mm");

  cp5.get(Textlabel.class, "centralHoleDiameter")
    .setText("Central Hole Diameter:          " + (centerCircleRadius*2/divide) + " mm" );


  if (saveOneFrame) {
    background(255);
    drawGear();
    exportPDF();
  }
  






  linearGear =  calculLinearGear(nbOfTeethInLine);
  







  if (gearMode =='s' || gearMode=='r') { 


  displayCenterCircle();
  
  }



  // shape(sh);
  if (gearMode =='s' || gearMode=='r') { 

    drawGear(); 
    //Création des position du trou central
  } else {

    drawLinear(-200,-200);
  }
  
  


  // STOP PDF EXPORTING
  if (saveOneFrame == true) {
    endRecord();
    saveOneFrame = false;
  }










  // GRILLE DE REPERE
  if (mousePressed) displayGrid();


  // modify radius of the center circle.
  if (keyPressed && key == 'g') centerCircleRadius = r * map(mouseX, 0, width, 0.005, 0.42);

  // modifier l' epaisseur de la pièce
  if (keyPressed && key == 'a') epaisseur = map(mouseX, 0, width, 20, 50); 



  // DIVISION DU CERCLE    // 84 // 111 // 99 //120 // 90
  if (keyPressed && key == 'x')  divisionDuCercle = 3 * (int)map(mouseX, 0, width, 1, 66);

  // PROFILE TEETH.
  if (keyPressed && key=='q')  setScaling('y');
  if (keyPressed && key=='w')  setScaling('x');
// drawCirclePoints();
  //drawIntermediaryPositions();
  
  
  // informations sur l'engrenage
  //displayInfo();





}


void keyPressed() {


  if ( key =='u') exportLinearObj(epaisseur, nbOfTeethInLine);

  // EXPORT PILLAR OBJ
  if ( key =='p')  exportGearPillar(centerCircleRadius, centerCircleRadius / 2);


  // EXPORT GEAR OBJ
  if ( key =='l') {
    if (reverse) {
      exportGearObj(epaisseur, 'r');
    } else {
      exportGearObj(epaisseur, 's');
    }
  }


  // REECHELONNER NOMBRE DE DENTS ET RADIUS
  if ( key=='e')  reechelonnerNombreDeDents();



  // REVERSE MODE
  if (key=='r') {
    reverse = !reverse;
    if (!reverse)centerCircleRadius = 50;
  }

  // EXPORT PDF
  if (key=='k') saveOneFrame = true;
}



