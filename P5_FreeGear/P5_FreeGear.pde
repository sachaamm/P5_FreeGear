

import processing.pdf.*;
boolean saveOneFrame = false;


/////////
//  VARIABLE TRIGONOMETRIQUES
int divisionDuCercle = 99;

int nbDents = divisionDuCercle / 3;
int initNbTeeth = nbDents;

float r = 0; // radius
float x, y; // position
float xCercleTrigo, yCercleTrigo;


float[][] circleData,circleData2,normData,normData2;


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
}


void draw() {

  background(255);

  scaling();

  initialisationTrigonometrie();

  // CALCUL DES INTERSECTIONS
  calculIntersection();
  
  
  
  // informations sur l'engrenage
  displayInfo();
  
  
  

  // DIVISION DU CERCLE    // 84 // 111 // 99 //120 // 90
  if (keyPressed && key == 'x')  divisionDuCercle = 3 * (int)map(mouseX, 0, width, 1, 66);

  // PROFILE TEETH.
  if (keyPressed && key=='q')  setScaling('y');
   if (keyPressed && key=='w')  setScaling('x');
  
  
  curvePoints = constrainCurvePointAroundCircleAxis(curvePoints, y - r/2);
  curvePoints2 = constrainCurvePointAroundCircleAxis(curvePoints2, y - r/2);

  curvePoints = scalePoints(curvePoints);
  curvePoints2 = scalePoints(curvePoints2);

  //

  gearPoints = new float[curvePoints.length*2*nbDents + nbCirclePoints*nbDents][3];
  calculTeeth();

//println(curvePoints.length);
  //////

  if (keyPressed && key =='k' && saveOneFrame){
    background(255);
    exportPDF();
  }

  // REORDER GEAR POINTS
  reorder();

  float currentCenterAngle = PI;

  // ADAPT CENTER CIRCLE RADIUS TO REVERSE MODE
  if (reverse) { 
    centerCircleRadius = r*0.6;  
    currentCenterAngle = PI  + PI*2/nbDents ;
  }

  // modify radius of the center circle.
  if (keyPressed && key == 'g') centerCircleRadius = r * map(mouseX, 0, width, 0.005, 0.42);

  // modifier l' epaisseur de la pièce
  if (keyPressed && key == 'a') epaisseur = map(mouseX, 0, width, 20, 50); 

  //Création des position du trou central  
  calculCenterCircle(currentCenterAngle);

  // créer des espaces vides pour optimiser la consommation
  int nbMiddlePoints = nbDents - nbDents %2;
  middlePointsUp = new float[nbMiddlePoints][2];
  middlePointsDown = new float[nbMiddlePoints][2];


  calculMiddlePoints();
  // drawMiddlePoints();
  // drawCutting();
  
  
  //drawCirclePoints();

  nbOfBrackets = nbDents - nbOfCenterHoles;

  if(keyPressed && key == 'z'){
    
  int enleverDents = 1;
  
  enleverDents= (int)map(mouseX,0,width,1, 10);
  int interval = nbInput * 2 + nbCirclePoints;
  
   for(int i = gearPoints.length - interval   ; i >= gearPoints.length  - (enleverDents * interval)  ; i-=interval){
    
    for(int k = 0 ; k < nbInput*2  ; k++){
      
      gearPoints[i + k] = gearPoints[i];
    }
    println(i);
    
  }
  
  }
  

  // création de la forme de l'engrenage ou sont stockées les positions des points.
  sh = buildShExtruded(gearPoints, epaisseur);
 // shape(sh);
 drawGear();


  // STOP PDF EXPORTING
  if (saveOneFrame == true) {
    endRecord();
    saveOneFrame = false;
  }

  // GRILLE DE REPERE
  if (mousePressed) displayGrid();

  linearGear =  calculLinearGear(nbOfTeethInLine);
  drawLinear();
  
  
 
  
  
  /*
  drawIntermediaryPositions();
 */
  
  
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
