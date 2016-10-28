



void drawLinear(float x,float y) {

  pushStyle();
  strokeWeight(1);
  for (int i = 0; i < linearGear.length; i++) {
    //point(linearGear[i][0], linearGear[i][1]) ;
    line(x + linearGear[i][0],y + linearGear[i][1], x + linearGear[(i+1)%linearGear.length][0], y + linearGear[(i+1)%linearGear.length][1]);
    
  }
  popStyle();

}



float[][] calculLinearGear(int nbOfTeethInLine) {


  float yL = -r - returnTeethGapHeight(curvePoints)*1.5;

  float lineGap = returnTeethGapWidth(curvePoints, curvePoints2) + radiusBetweenTeeth/2;

  float diffX =gearPoints[nbInput * 2 + nbCirclePoints][0]  -  gearPoints[nbInput * 2 -1][0];

  float[][] linearGear;

  linearGear = new float[0][2];
  int c = 0;

  for (int j = 0; j < nbOfTeethInLine; j++) {

    for (int i = 0; i < curvePoints.length; i++) {

      if (i==0) {

        for (int x = 0; x < nbInput; x++) {

          float currXl = -xL + curvePoints[x][0] + j * (lineGap + diffX);
          float currYl = -yL + curvePoints[x][1];

          linearGear = ajoutTableau(linearGear, currXl, currYl);
        }

        for (int x = 0; x < nbInput; x++) {

          float currXl2 = -xL + curvePoints2[nbInput-1-x][0] + j * (lineGap + diffX);
          float currYl2 = -yL + curvePoints2[nbInput-1-x][1];

          linearGear = ajoutTableau(linearGear, currXl2, currYl2);
        }
      }
    }
  }


  float linearHeight = 30;

  float[] first = new float[2];
  first[0] = linearGear[0][0];
  first[1] = linearGear[0][1] + linearHeight;

  float[] last = new float[2]; 
  last[1] = linearGear[linearGear.length-1][1] + linearHeight;
  last[0] = linearGear[linearGear.length-1][0];
     
 float maxX = getMax(getXvalues(linearGear));
   maxX = linearGear[linearGear.length-nbInput*2][0];
    
float ratio = (float)1 / (float)(nbOfTeethInLine-1);
float valueRatio = 1;

  linearGear = ajoutTableau(linearGear, last[0], last[1]);



for(int i = 0 ; i < nbOfTeethInLine; i++){
 
  float[] middle = getIntermediaryPos(first[0] , first[1] , maxX, last[1] , valueRatio);
  linearGear = ajoutTableau(linearGear, middle[0], middle[1]);
  valueRatio -= ratio;
}

 
 
 
  return linearGear;
}

void drawLinearGear() {


  if (keyPressed && key == 'f') xL =mouseX;

  float yL = -r - returnTeethGapHeight(curvePoints)*1.5;


  float lineGap = returnTeethGapWidth(curvePoints, curvePoints2) + radiusBetweenTeeth/2;


  float diffX =gearPoints[nbInput * 2 + nbCirclePoints][0]  -  gearPoints[nbInput * 2 -1][0];
  
  pushStyle();
  noFill();
  ellipse(gearPoints[nbInput * 2 -1][0], gearPoints[nbInput * 2 - 1][1], 10, 10 );
  ellipse(gearPoints[nbInput * 2 + nbCirclePoints][0], gearPoints[nbInput * 2 + nbCirclePoints][1], 10, 10 );
  popStyle();


  for (int j = 0; j < nbOfTeethInLine; j++) {

    for (int i = 0; i < curvePoints.length; i++) {

      float currXl = -xL + curvePoints[i][0] + j * (lineGap + diffX);
      float currYl = -yL + curvePoints[i][1];

      pushStyle();
      stroke(i*30, 0, 0);
      strokeWeight(3);
      point(currXl, currYl);
      popStyle();

      currXl = -xL + curvePoints2[i][0] + j * (lineGap + diffX);
      currYl = -yL + curvePoints2[i][1];

      pushStyle();
      stroke(i*30, 0, 0);
      strokeWeight(3);
      point(currXl, currYl);
      popStyle();
    }
  }
}


void drawBrackets(int nbOfBrackets, float ratioBracketAngle, float ratioBracketRadius, float ratioCenterBracketRadius) {

  float angleBrackets, angleBetweenBrackets;
  float bracketGap, betweenBracketsGap;

  angleBrackets = PI*2 / ratioBracketAngle ;
  angleBetweenBrackets = PI*2 - angleBrackets;

  float currentBracketAngle = 0;
  float bracketRadius = r / ratioBracketRadius;
  float bracketRadius2 = bracketRadius / ratioCenterBracketRadius;
  //int nbOfBrackets = 3;

  for (int i = 0; i < nbOfBrackets * 2; i++) {

    pushStyle();
    if (mousePressed)strokeWeight(5);
    float currentX, currentY, currentX2, currentY2;

    currentX = x+cos(currentBracketAngle)*bracketRadius;
    currentY = y+sin(currentBracketAngle)*bracketRadius;

    currentX2 = x+cos(currentBracketAngle)*bracketRadius2;
    currentY2 = y+sin(currentBracketAngle)*bracketRadius2;

    if (i%2==0) {
      stroke(255, 0, 0);
      line(currentX, currentY, currentX2, currentY2);

      currentBracketAngle+= angleBrackets / nbOfBrackets;
    } else {

      line(currentX, currentY, currentX2, currentY2);
      currentBracketAngle+= angleBetweenBrackets / nbOfBrackets;

      float angleBracketDiff = angleBrackets /nbOfBrackets ; 
      int e = 0;

      for (float j= currentBracketAngle; j < angleBracketDiff + currentBracketAngle; j+= angleBracketDiff / 10) {
        float bracketX = x + cos(j)*bracketRadius;
        float bracketY = y + sin(j)*bracketRadius;

        float nextBracketX = x + cos(j+angleBracketDiff/10)*bracketRadius;
        float nextBracketY = y + sin(j+angleBracketDiff/10)*bracketRadius;

        float nextBracketX2 = x + cos(j+angleBracketDiff/10)*bracketRadius2;
        float nextBracketY2 = y + sin(j+angleBracketDiff/10)*bracketRadius2;

        float bracketX2 = x + cos(j)*bracketRadius2;
        float bracketY2 = y + sin(j)*bracketRadius2;
        point(bracketX, bracketY);
        point(bracketX2, bracketY2);
        e++;

        boolean b = false;
        if (e>=11)b=true;

        if (!b) {
          line(bracketX, bracketY, nextBracketX, nextBracketY);
          line(bracketX2, bracketY2, nextBracketX2, nextBracketY2);
        }

        pushStyle();
        strokeWeight(1);
        popStyle();
      }
    }

    point(currentX, currentY );
    point(currentX2, currentY2);

    popStyle();
  }
}
