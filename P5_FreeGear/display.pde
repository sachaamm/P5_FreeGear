void drawGear(){
  
  for(int i = 0 ; i < gearPoints.length  ; i++){
    
    if(i < gearPoints.length - 1){
      
      line(gearPoints[i][0] , gearPoints[i][1], gearPoints[i+1][0] , gearPoints[i+1][1] );
      
    }else{
      
      line(gearPoints[i][0] , gearPoints[i][1], gearPoints[0][0] , gearPoints[0][1] );
      
      
    }
    
  }
  
  
}


void displayInfo() {

  pushStyle();
  fill(0);
  text("Nb dents:"+nbDents, 20, 20);
  text("Radius gear "+r + " mm", 20, 40);

  float pasDeLaDent = gearPoints[nbInput+1][0] - gearPoints[nbInput][0];
  text("pas de la dent" + (pasDeLaDent/divide) + " mm", 20, 60);

  float firstX = gearPoints[0][0] ;
  float firstY = gearPoints[0][1] ;

  float upX =  gearPoints[nbInput-1][0] ;
  float upY =  gearPoints[nbInput-1][1] ;

  float hauteurDeDent = firstY - upY;
  text("hauteur de la dent "+ (hauteurDeDent/divide) + " mm", 20, 80 );
  //float[] gearSize = getGearSize(gearPoints);
  //text("width " + gearSize[0] + " heighearSize "+gearSize[1],20 , 80);
  noFill();

  text("diametre "+ ((r + hauteurDeDent*2)/divide)+ " mm", 20, 100 );
  text("trou central "+ (centerCircleRadius*2/divide) + " mm", 20, 120 );
  text("epaisseur "+ (epaisseur/divide) + " mm", 20, 140 );
  text("nb Of Center Holes : "+nbOfCenterHoles, 20, 160);
  text("nb Of Brackets : "+nbOfBrackets, 20, 180);
  popStyle();
  
  
  float lineGap = returnTeethGapWidth(curvePoints, curvePoints2) + radiusBetweenTeeth/2;
  fill(0);
  text("teeth width:"+returnTeethGapWidth(curvePoints, curvePoints2), 550, 85);
  text("radiusBetweenTeeth:"+radiusBetweenTeeth, 550, 125);
  text("radiusBetweenTeeth:"+lineGap, 550, 135);

}


void drawCutting() {
  int interval = nbInput*2 + nbCirclePoints;
  int c=centerCircle.length-1;
  for (int i = nbInput; i < gearPoints.length; i+=interval) {
    line(gearPoints[i][0], gearPoints[i][1], centerCircle[c][0], centerCircle[c][1] );
    c--;
  }
}

void drawCirclePoints() {
  int interval = nbInput*2 + nbCirclePoints;
  for (int i = nbInput*2; i < gearPoints.length; i++) {
    if (i % interval >= nbInput * 2) {
      pushStyle();
      strokeWeight(5);
      point(gearPoints[i][0], gearPoints[i][1]);
      popStyle();
    }
  }
}


void drawMiddlePoints() {
  
  nbOfCenterHoles = 0;

  for (int i = 0; i < middlePointsUp.length-1; i+=2) {
    nbOfCenterHoles++;
    line(middlePointsUp[i][0], middlePointsUp[i][1], middlePointsDown[i][0], middlePointsDown[i][1]);

    if (i < middlePointsUp.length -1) {
      line(middlePointsUp[i][0], middlePointsUp[i][1], middlePointsUp[i+1][0], middlePointsUp[i+1][1]);
      line(middlePointsDown[i][0], middlePointsDown[i][1], middlePointsDown[i+1][0], middlePointsDown[i+1][1]);
      line(middlePointsUp[i+1][0], middlePointsUp[i+1][1], middlePointsDown[i+1][0], middlePointsDown[i+1][1]);
    } else {  
      line(middlePointsUp[i][0], middlePointsUp[i][1], middlePointsUp[0][0], middlePointsUp[0][1]);
      line(middlePointsDown[i][0], middlePointsDown[i][1], middlePointsDown[0][0], middlePointsDown[0][1]);
      line(middlePointsUp[i][0], middlePointsUp[i][1], middlePointsDown[0][0], middlePointsDown[0][1]);
    }
  }
}

void displayGrid(){
  
    pushStyle();

    stroke(255, 0, 0);
    strokeWeight(0.5);
    line(width/2, 0, width/2, height);  
    line(0, height/2, width, height/2);    

    popStyle();
  
  
  
}

void drawIntermediaryPositions(){
  
   for(int i = 0 ; i < gearPoints.length ; i+=nbInput*2 + nbCirclePoints){
   float[] middle = getIntermediaryPos( gearPoints[i][0], gearPoints[i][1] , gearPoints[i+nbInput*2-1][0], gearPoints[i+nbInput*2-1][1]  , 0.5 );
   ellipse(middle[0] , middle[1] , 5 , 5 );
  }
  
}


void scaling() {

  if (keyPressed && key=='s') {
    float scal = map(mouseX, 0, width, 1, 4);

    translate(-(width - width/scal), 0);
    scale( scal );
  }
}
