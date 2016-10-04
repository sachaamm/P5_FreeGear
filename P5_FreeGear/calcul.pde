
// INITIALISER LES POSITIONS DES NORMALES ET DES CERCLES REFERENTS DU CERCLE TRIGONOMETRIQUE ( MOUSE PRESS POUR VOIR LE CALCUL )
void initialisationTrigonometrie() {


  float firstX, firstY;
  firstX=x-sin(0)*r/2;
  firstY=y-cos(0)*r/2;

  int c = 0;
  int d = 0;

  //divisionDuCercle = 99; et au debut il y a 33 dents


  // divise le cercle par 3 fois le nombre de dents
  // operation realisee 99 fois
  for (float i = 0; i < PI*2; i+= (PI*2/divisionDuCercle)) {

    float currX, currY;

    currX = xCercleTrigo-sin(i)*modelRadius/2;
    currY = yCercleTrigo-cos(i)*modelRadius/2;

    // j => reverse i
    float j = PI*2 - i;
    float invertCurrX, invertCurrY;

    invertCurrX =  xCercleTrigo-sin(j)*modelRadius/2;
    invertCurrY =  yCercleTrigo-cos(j)*modelRadius/2;


    float distX, distY;
    distX = currX-xCercleTrigo;
    distY = currY-yCercleTrigo;


    //normales

    //PREMIERE NORMALE

    if (c==0) {

      normData[0][0] = currX;
      normData[0][1] = currY;
      normData[0][2] = currX + distY * 2 ;
      normData[0][3] = currY - distX*2;

      normData2[0][0] = invertCurrX;
      normData2[0][1] = invertCurrY;
      normData2[0][2] = currX - distY * 2 ;
      normData2[0][3] = currY - distX*2;
    }


    // dessine les 12 derniers cercles
    // calcul des cercles trigonométriques
    if (c<nbInput) {

      float nextX =  xCercleTrigo-sin(i + (PI*2/divisionDuCercle) )*modelRadius/2;
      float nextY =  yCercleTrigo-cos(i + (PI*2/divisionDuCercle) )*modelRadius/2;

      float radius = calculRadiusAvecLePasEtLAddendum(firstX - nextX, firstY - nextY);

      circleData[c][0] = invertCurrX;
      circleData[c][1] = invertCurrY;
      circleData[c][2] = radius;

      circleData2[c][0] = currX;
      circleData2[c][1] = currY;
      circleData2[c][2] = radius;
    }


    //DESSINER LES NORMALES      : pourquoi quand c>divisionDuCercle-(nbInput) ? 
    // calcul des normales incluses dans le cercle trigonometrique

    if (c>divisionDuCercle-(nbInput)) {

      if (d<nbInput-1)d++;

      normData[ nbInput - d ][0]= currX;
      normData[ nbInput - d ][1]= currY;
      normData[ nbInput - d ][2]= currX + distY * 2;
      normData[ nbInput - d ][3]= currY - distX *2;

      normData2[ nbInput - d ][0]= invertCurrX;
      normData2[ nbInput - d ][1]= invertCurrY;
      normData2[ nbInput - d ][2]= invertCurrX - distY*2;
      normData2[ nbInput - d ][3]= invertCurrY - distX*2;
    }


    c++;
  }
}


//////////// // //

//  CALCUL DES INTERSECTION ENTRE LES NORMALES ET LES CERCLES REPRESENTATIF DU CERCLE TRIGONOMETRIQUE 


///*/// * / * / * /

void calculIntersection() {

  ArrayList<float[]> intersections, intersections2;

  intersections = new ArrayList<float[]>();
  intersections2 = new ArrayList<float[]>();

  for (int i = 0; i < nbInput; i++) {

    intersections = 
      getIntersectionCircleAndLine(normData[i][0], normData[i][1], normData[i][2], normData[i][3], 
    circleData[i][0], circleData[i][1], circleData[i][2] );

    intersections2 = 
      getIntersectionCircleAndLine(normData2[i][0], normData2[i][1], normData2[i][2], normData2[i][3], 
    circleData2[i][0], circleData2[i][1], circleData2[i][2] );

    float[] leftPoint = new float[0];
    float[] rightPoint = new float[0];
    float[] base = new float[2];

    if (intersections.size() > 1 ) leftPoint = getLeft( intersections.get(0), intersections.get(1) ) ;
    if (intersections.size() == 1 ) leftPoint = intersections.get(0);

    if (intersections2.size() > 1 )  rightPoint = getRight( intersections2.get(0), intersections2.get(1) );
    if (intersections2.size() == 1 ) rightPoint =  intersections2.get(0);


        curvePoints[i] = leftPoint;
        curvePoints2[i] = rightPoint;

    if (curvePoints.length>i && curvePoints2.length>i) {
      // COURBE GAUCHE ET COURBE DROITE

        curvePoints[i] = leftPoint;
        curvePoints2[i] = rightPoint;
        /*
      if (leftPoint.length < 1 || rightPoint.length < 1) {
        curvePoints[i] = base;
        curvePoints2[i] = base;
      } else {
        curvePoints[i] = leftPoint;
        curvePoints2[i] = rightPoint;
      }*/

      
    }
  }
}



float returnTeethGapHeight(float[][] f) {

  float[] t = new float[f.length];

  for (int i = 0; i < f.length; i++) {
    t[i] = f[i][1];
  }

  float max, min;
  max = max(t);
  min = min(t);

  return max-min;
}

float returnTeethGapWidth(float[][] f, float[][] f2) {

  float[] t = new float[f.length + f2.length];

  for (int i = 0; i < f.length; i++) {
    t[i] = f[i][0];
  }

  for (int i = f.length; i < t.length; i++) {

    t[i] = f2[i-f.length][0];
  }

  float max, min;
  max = max(t);
  min = min(t);

  return max-min;
}



// A QUOI SERT CETTE FONCTION? 
float[][] constrainCurvePointAroundCircleAxis(float[][] points, float yValue) {


  float baseY = points[0][1];

  float[][] initCurve = points;
  float diff = baseY - yValue;

  for (int i = 0; i < points.length; i++) {
    points[i][1] = initCurve[i][1] - diff;
  }

  return points;
}

// REORGANISER VERTEX POUR LES PLACER CORRECTEMENT DANS GEARPOINTS.
void reorder() {

  int mainGap = curvePoints.length * 2 + nbCirclePoints;

  for (int i = curvePoints.length; i < gearPoints.length; i+=mainGap) {

    int c = curvePoints.length-1;
    float[][] storeData = new float[curvePoints.length][2];

    for (int j= 0; j < storeData.length; j++) {
      storeData[j] = gearPoints[i + c];
      c--;
    }

    int dd = curvePoints.length-1;
    for (int k = 0; k < storeData.length; k++) {
      gearPoints[i+k] = storeData[k];
    }
  }
}


// EXTRUDE GEAR COORDS
float[][] extrudeGearCoords(float[][] f, float extrude) {

  float[][] f2 = new float[f.length*2][3];

  for (int i = 0; i < f.length; i++) {

    f2[i] = f[i];
  } 

  for (int i = f.length; i < f.length*2; i++) {
    float[] t = new float[3];
    t[0] = f[i-f.length][0];
    t[1] = f[i-f.length][1];
    t[2] = extrude;
  }

  return f2;
} 




// CALCUL DES DENTS
void calculTeeth() {


  // NBCIRCLEPOINTS = nb de point dans la courbe du cercle


  int enleverDents = 0;

  // ANGLE TO THE NEXT TEETH
  float gapAngle = PI*2 / nbDents;

  int  i = 0;
  //DRAW ALL CURVES

  while (i < curvePoints.length) {


    // PVector centerCircle = new PVector(r/2, 0);
    PVector b = new PVector(curvePoints[i][0]-x, curvePoints[i][1]-y);
    PVector b2 = new PVector(curvePoints2[i][0]-x, curvePoints2[i][1]-y);


    float angle = angle(zeroDegre, b);
    float angle2 = angle(zeroDegre, b2);

    int currentTeeth = 0;

    float currentRadius = calculDiametre(curvePoints[i][0] - x, curvePoints[i][1] - y);

    indexPoint = i;

    int gapInterval = curvePoints.length * 2 + nbCirclePoints;

    float diffAngle = 0;

    PVector rightAngleVector = new PVector(0, 0);

    while (currentTeeth < nbDents - enleverDents ) {

      // f = left Curves // ff = right Curves
      float[] f = getPointRotateAround(curvePoints[i][0], curvePoints[i][1], x, y, angle, currentRadius);
      float[] ff =  getPointRotateAround(curvePoints2[i][0], curvePoints2[i][1], x, y, angle2, currentRadius);

      // Calcul de l'angle
      if (currentTeeth == 1 && i == 0 )     rightAngleVector = new PVector(f[0]-x, f[1] - y  );

      gearPoints[indexPoint] = f;
      gearPoints[indexPoint+curvePoints.length] = ff;

      indexPoint+=gapInterval;

      currentTeeth++;

      angle+=gapAngle;
      angle2+=gapAngle;
    }

    if (i==0) {

      float circleAngle = 0;

      PVector centerCircle = new PVector(r/2, 0);
      PVector bc = new PVector(curvePoints2[0][0]-x, curvePoints2[0][1]-y);

      float addAngle =   PI/2 - angle(bc, centerCircle); 
      float rightAngle = PI/2 - angle(rightAngleVector, centerCircle); 


      circleAngle = angle(centerCircle, bc);
      indexPoint = curvePoints.length*2-1;


      // OPERATION ON EACH TEETH
      int k = 0;
      while ( k < nbDents) {

        // CIRCLE CURVE POINTS
        int j =0;
        while ( j < nbCirclePoints) {
          // pourquoi 9 ? choix arbitraire ?
          float intervalAngle = rightAngle/2 / nbCirclePoints * (j+1) ;


          float[] f = getPointRotateAround(curvePoints2[i][0], curvePoints2[i][1], x, y, circleAngle + intervalAngle, r);

          indexPoint++;
          gearPoints[indexPoint] = f;

          if ( j == nbCirclePoints - 1) {
            // gearPoints[indexPoint] = 0;
          }
          j++;
        }

        indexPoint+= curvePoints.length*2 ;
        circleAngle+=gapAngle;

        k++;
      }
    }



    i++;
  }
}


float[] getGearSize(float[][] f) {

  float[] xvalues = convert2DarrayToArray(f, 0);
  float[] yvalues = convert2DarrayToArray(f, 1);

  float xmin, ymin, ymax, xmax;

  xmin = getMin(xvalues);
  xmax = getMax(xvalues);

  ymin = getMin(yvalues);
  ymax = getMax(yvalues);

  float w = xmax  - xmin;
  float h = ymax  - ymin;

  float[] r = new float[2];
  r[0] = w;
  r[1] = h;

  return r;
}



void calculCenterCircle(float currentCenterAngle) {

  centerCircle = new float[nbDents][2];

  // CALCUL  CENTER CIRCLE
  for (int i = 0; i < centerCircle.length; i++) {
    centerCircle[i][0] = x + sin(currentCenterAngle) * centerCircleRadius;
    centerCircle[i][1] = y + cos(currentCenterAngle) * centerCircleRadius;
    currentCenterAngle+=(PI*2/centerCircle.length);
  }

  // DRAW CENTER CIRCLE
  for (int i = 0; i < centerCircle.length; i++) {
    if (i < centerCircle.length-1) {
      line( centerCircle[i][0], centerCircle[i][1], centerCircle[i+1][0], centerCircle[i+1][1]);
    } else {
      line( centerCircle[i][0], centerCircle[i][1], centerCircle[0][0], centerCircle[0][1]);
    }
  }
}



void calculMiddlePoints() {

  int count = 0;

  for (int i = 0; i < gearPoints.length; i+=nbInput*2 + nbCirclePoints) {

    // VISUEL INTERESSANT
    // line(gearPoints[i][0], gearPoints[i][1], centerCircle[i][0],centerCircle[i][1]);
    float a = gearPoints[i][0];
    float b = gearPoints[i][1];
    float c = centerCircle[nbDents-1 - count][0];
    float d = centerCircle[nbDents-1 - count][1];

    if (mousePressed)line(a, b, c, d);

    float ew = 10;
    float ratioMax = 0.8;
    float ratioMin = 0.3;

    float[] pos = getIntermediaryPos(c, d, a, b, ratioMax);
    float[] pos2 = getIntermediaryPos(c, d, a, b, ratioMin);

    if (count <= middlePointsUp.length - 1) {
      middlePointsUp[count] = pos;
      middlePointsDown[count] = pos2;

      if (mousePressed) {
        pushStyle();
        stroke(255, 0, 0);

        ellipse(pos[0], pos[1], ew, ew);
        ellipse(pos2[0], pos2[1], ew, ew);

        popStyle();
      }
    }
    count++;
  }
}


void reechelonnerNombreDeDents() {

  int saveNbDents = nbDents;

  yCercleTrigo = y;

  r = (int)map(mouseX, 0, width, 100, 600);

  float ratio = r / modelRadius;
  int closestNbOfTeeth = int(initNbTeeth*ratio);

  nbDents =closestNbOfTeeth;

  float f = ((float)closestNbOfTeeth / (float)initNbTeeth);
  r = modelRadius * f;
  yCercleTrigo+= (modelRadius - r)/2;
}
