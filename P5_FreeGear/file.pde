void exportGearObj(float extrude, char mode) {


  //////
  //  L E N G H T S

  int firstFaceTotalVerticesLength = gearPoints.length + centerCircle.length;


  //FACE VERTEX           // FACE CENTER V     // FACE QUAD          //FACE CENTER QUAD           //EXTRUDING FACES          //SURROUNDING FACES
  //  int objStringsLength = gearPoints.length*2 +  centerCircle.length*2 +  gearPoints.length   + centerCircle.length      +  nbDents  *2                        ;
  int objStringsLength = firstFaceTotalVerticesLength * 2 + gearPoints.length  + centerCircle.length + nbDents *2;


  String[] objStrings = new String[objStringsLength];

  //   USELESS...
  objStrings[0] = "o Cube";


  //////////////////
  // V E R T I C E S

  ////////////////////


  // FIRST FACE EXTERNAL
  for (int i = 0; i < gearPoints.length; i++) {

    objStrings[i] = "v "+(float)gearPoints[i][0]/divide+" "+(float)gearPoints[i][1]/divide+" 0.000";
  }

  // FIRST FACE INTERNAL
  for (int i = 0; i < centerCircle.length; i++) {

    objStrings[i+gearPoints.length] = "v "+(float)centerCircle[i][0]/divide+" "+(float)centerCircle[i][1]/divide+" 0.000";
  }

  // SECOND FACE EXTERNAL
  for (int i = 0; i < gearPoints.length; i++) {

    objStrings[i+gearPoints.length + centerCircle.length] = "v "+(float)gearPoints[i][0]/divide+" "+(float)gearPoints[i][1]/divide+" "+extrude/divide;
  }

  // SECOND FACE INTERNAL
  for (int i = 0; i < centerCircle.length; i++) {

    objStrings[i+gearPoints.length*2 + centerCircle.length] = "v "+(float)centerCircle[i][0]/divide+" "+(float)centerCircle[i][1]/divide+" "+extrude/divide;
  }



  ////////////////
  //   F A C E S

  ///////////////


  // 
  // EXTRUDING FACES , LINKIN z:0 POS AND z:extrude POS

  // EXTRUDE L'EXTERIEUR ET LE TROU CENTRAL
  for (int i = 1; i < firstFaceTotalVerticesLength + 1; i++) {

    String newFace = "f "+i+" "+(i+firstFaceTotalVerticesLength)+" "+(i+firstFaceTotalVerticesLength+1)+" "+(i+1);
    // SI ON ARRIVE A LA DERNIERE FACE EXTERIEURE , ON NE LINKE PAS LA DERNIERE FACE EXTERIEURE AVEC LA PREMIERE FACE INTERIEURE
    if (i==gearPoints.length) {
      newFace = "f "+(i-1)+" "+(i+firstFaceTotalVerticesLength-1)+" "+(i+firstFaceTotalVerticesLength)+" "+(i);
    }

    //IDEMN POUR LES MIDDLE POINTS  
    if (i==gearPoints.length + centerCircle.length) {
      newFace = "f "+(i-1)+" "+(i+firstFaceTotalVerticesLength-1)+" "+(i+firstFaceTotalVerticesLength)+" "+(i);
    }

    objStrings[firstFaceTotalVerticesLength*2 +i - 1] = newFace;
  }

  // A QUOI CORRESPOND CETTE FACE ?  ---> DERNIERE EXTRUDING FACE
  objStrings[objStrings.length-1 - nbDents*2] = "f "+(gearPoints.length  + centerCircle.length)+" "+((gearPoints.length)*2+ centerCircle.length*2)+" "+((gearPoints.length)*2 + centerCircle.length+1 )+" "+(gearPoints.length+1);


  // HERE ARE WRITTEN THE SURROUNDING FACES.
  for (int i = 1; i < centerCircle.length + 1; i++) {

    // UP FACE ( z : 0 )
    String newFace = "f ";
    // DOWN FACE ( z : extrude ) 
    String newFace2 = "f ";

    
    int modeValue = 0;
    if (mode == 'r')modeValue++;

    // AJOUTE LES POINTS DANS UNE FACE INCLUANT CURVEPOINTS puis CURVEPOINTS2 puis CIRCLEPOINTS
    for (int j = 0; j < nbInput*2 + nbCirclePoints + modeValue; j++) {

      int index = (j+1 + (i-1) * (nbInput*2 + nbCirclePoints) );
      int index2 = (j+1 + (i-1) * (nbInput*2 + nbCirclePoints) + gearPoints.length + centerCircle.length ) ;

      if (mode == 'r') {
        index+= nbInput;
        index2 +=nbInput;

        if (index > gearPoints.length )  index-=gearPoints.length;
        if (index2 > gearPoints.length*2 + centerCircle.length)index2-=gearPoints.length;
      }


      // UP FACE ( z : 0 )
      newFace+= index + " ";
      // DOWN FACE ( z : extrude ) 
      newFace2+= index2 + " ";
    } 

    // PUIS RACCORDEMENT AU CERCLE CENTRAL

    // POUR LA DERNIERE FACE 
    if ( gearPoints.length*3 + centerCircle.length*3 + centerCircle.length  +i - 1  == objStrings.length-1 ) {
      // UP FACE ( z : 0 )
      newFace+=(gearPoints.length + centerCircle.length)+" ";
      // DOWN FACE ( z : extrude ) 
      newFace2+=(gearPoints.length*2 + centerCircle.length*2)+" ";
    } else     // POUR LES AUTRES FACES
    {
      // UP FACE ( z : 0 )
      newFace+=(gearPoints.length + centerCircle.length-i)+" ";
      // DOWN FACE ( z : extrude ) 
      newFace2+=(gearPoints.length*2 + centerCircle.length*2-i)+" ";
    }

    // DERNIER AJOUT : RACCORDEMENT AU CERCLE CENTRAL , INDEX i+1

    // UP FACE ( z : 0 )
    newFace+=(gearPoints.length + centerCircle.length-i+1) +" " ;
    // DOWN FACE ( z : extrude ) 
    newFace2+=(gearPoints.length*2 + centerCircle.length*2-i+1) +" " ;


    objStrings[gearPoints.length*3 + centerCircle.length*3 +i - 1] = newFace;
    objStrings[gearPoints.length*3 + centerCircle.length*4 +i - 1] = newFace2;
  }



  // Writes the strings to a file, each on a separate line
  saveStrings("OBJ/MyGear"+hour()+minute()+second()+".obj", objStrings);
}

void exportLinearObj(float epaisseur, int nbOfTeethInLine){
  
    //////
  //  L E N G H T S

  int firstFaceTotalVerticesLength = linearGear.length ;


  //FACE VERTEX           // FACE CENTER V     // FACE QUAD          //FACE CENTER QUAD           //EXTRUDING FACES          //SURROUNDING FACES
  //  int objStringsLength = gearPoints.length*2 +  centerCircle.length*2 +  gearPoints.length   + centerCircle.length      +  nbDents  *2                        ;
  int objStringsLength = firstFaceTotalVerticesLength * 2 + linearGear.length  + nbOfTeethInLine * 2;

  String[] objStrings = new String[objStringsLength];



// VERTEX
for(int i = 0 ; i < linearGear.length ; i++){
  
   objStrings[i] = "v "+(float)linearGear[i][0]/divide+" "+(float)linearGear[i][1]/divide+" 0.000";

}


for(int i = 0 ; i < linearGear.length ; i++){
  
   objStrings[i+linearGear.length] = "v "+(float)linearGear[i][0]/divide+" "+(float)linearGear[i][1]/divide+" "+epaisseur/divide;

}


  // EXTRUDING FACES
  for (int i = 1; i < firstFaceTotalVerticesLength+1 ; i++) {
    String newFace = "f "+(i+1)+" "+i+" "+(i+firstFaceTotalVerticesLength)+" "+(i+firstFaceTotalVerticesLength+1)+" ";
   
    
    if(i== firstFaceTotalVerticesLength){
    // newFace = "f "+(i+1)+" "+i+" "+(i+firstFaceTotalVerticesLength)+" "+1;
     newFace = "f "+(2)+" "+(i+1)+" "+(i*2)+" "+i;
    
     //newFace += linearGear.length*2 + 1;
    }
    
    
    
    
    objStrings[i +linearGear.length*2 - 1] = newFace;
    
    
    
  }

  //z:0
  for(int i = 0 ; i < nbOfTeethInLine ; i++){
    
    
    String f ="f ";
    
    for(int k = 0; k < nbInput *2 +1; k++){
      f+=(k+1+i*nbInput*2)+" ";
    }
    
    f+= (linearGear.length -  i)+" ";
    
    
     int lastIndex = (linearGear.length-  i + 1);
    
   // if(lastIndex <  linearGear.length )f+= lastIndex+" ";
    if( i != 0 )f+= lastIndex+" ";
    // f+= (linearGear.length -  i + 1)+" ";
    
    
     objStrings[i +linearGear.length*3  ] = f;
  
  }
  
  
  //z : epaisseur
    for(int i = 0 ; i < nbOfTeethInLine ; i++){
    String f ="f ";
    for(int k = 0; k < nbInput *2 +1; k++){
      
      
      f+=(k+1+i*nbInput*2+linearGear.length)+" ";
    }
    
    f+= (linearGear.length*2 -  i)+" ";
    
    int lastIndex = (linearGear.length*2 -  i + 1);
    
       if( i != 0 )f+= lastIndex+" ";
    
     objStrings[i +linearGear.length*3 + nbOfTeethInLine  ] = f;
  
  }
  
 
  

  // Writes the strings to a file, each on a separate line
  saveStrings("OBJ/MyLinearGear"+hour()+minute()+second()+".obj", objStrings);
  
  
}

void exportGearPillar(float rayonRoulement, float rayonTrouRoulement) {

  int nbPillarPoints = 100;
  float[][] pillarPoints = new float[nbPillarPoints][2];

  for (int i = 0; i < pillarPoints.length; i++) {

    pillarPoints[i][0] = x + cos(i) * rayonRoulement;
    pillarPoints[i][1] = y + sin(i) * rayonRoulement;
  }

  /////////

  // PILLAR OBJ TOTAL LENGTH  

  //Vertices                base down face vertices/ base face up vertices/ pillar down face vertices   / pillarUp Face vertices
  int pillarObjFileLength = pillarPoints.length + pillarPoints.length +     pillarPoints.length          + pillarPoints.length    +

    //  Base down face/ base surrounding faces/ base up face (face linking base and pillar )
  1 +       pillarPoints.length +     pillarPoints.length     +
    // pillar surrounding faces / Pillar up face
  pillarPoints.length        + 1;





  String[] pillarObjFile = new String[pillarObjFileLength];

  float currentAngle = 0;
  float gapAngle = PI*2 / pillarPoints.length;

  float baseDownZ = 0;
  float baseUpZ = 10;
  float pillarUpZ = 20;

  // base down face vertices
  for (int i = 0; i < pillarPoints.length; i++) { 
    float currX = x + cos(currentAngle) * rayonRoulement;
    float currY = y + sin(currentAngle) * rayonRoulement;
    pillarObjFile[i] = "v "+(currX/divide)+" "+(currY/divide)+" "+(baseDownZ/divide);
    currentAngle += gapAngle;
  }

  currentAngle = 0;
  // base up face vertices
  for (int i = 0; i < pillarPoints.length; i++) { 
    float currX = x + cos(currentAngle) * rayonRoulement;
    float currY = y + sin(currentAngle) * rayonRoulement;
    pillarObjFile[i+nbPillarPoints] = "v "+(currX/divide)+" "+(currY/divide)+" "+(baseUpZ/divide);
    currentAngle += gapAngle;
  }

  currentAngle = 0;
  // pillar down face vertices
  for (int i = 0; i < pillarPoints.length; i++) { 
    float currX = x + cos(currentAngle) * rayonTrouRoulement;
    float currY = y + sin(currentAngle) * rayonTrouRoulement;
    pillarObjFile[i+nbPillarPoints*2] = "v "+(currX/divide)+" "+(currY/divide)+" "+(baseUpZ/divide);
    currentAngle += gapAngle;
  }

  currentAngle = 0;
  // pillar up face vertices
  for (int i = 0; i < pillarPoints.length; i++) { 
    float currX = x + cos(currentAngle) * rayonTrouRoulement;
    float currY = y + sin(currentAngle) * rayonTrouRoulement;
    pillarObjFile[i+nbPillarPoints*3] = "v "+(currX/divide)+" "+(currY/divide)+" "+(pillarUpZ/divide);
    currentAngle += gapAngle;
  }

  // base down face 
  // for(int i = 0 ; i < pillarPoints.length ; i++){ 
  String globalBaseFace ="f ";

  for (int j = 0; j < pillarPoints.length; j++) {

    globalBaseFace+=j+" ";
  }
  pillarObjFile[nbPillarPoints*4] = globalBaseFace;

  //}


  // base surrouding faces
  for (int i = 0; i < pillarPoints.length; i++) { 
    if (i<pillarPoints.length-1) {
      pillarObjFile[i+nbPillarPoints*4 + 1] = "f "+(i+1)+" "+(i+1+nbPillarPoints)+" "+(i+2+nbPillarPoints)+" "+(i+2);
    } else {  
      pillarObjFile[i+nbPillarPoints*4 + 1] = "f "+(i+1)+" "+(i+1+nbPillarPoints)+" "+(1+nbPillarPoints)+" "+(1);
    }
  }

  // linking base and pillar faces
  for (int i = 0; i < pillarPoints.length; i++) { 

    if (i<pillarPoints.length-1) {
      pillarObjFile[i+nbPillarPoints*5 + 1] = "f "+(i+1+nbPillarPoints)+" "+(i+1+nbPillarPoints*2)+" "+(i+2+nbPillarPoints*2)+" "+(i+2+nbPillarPoints);
    } else {
      pillarObjFile[i+nbPillarPoints*5 + 1] = "f "+(i+1+nbPillarPoints)+" "+(i+1+nbPillarPoints)+" "+(1+nbPillarPoints*2)+" "+(1+nbPillarPoints);
    }
  }

  // pillar surrouding faces
  for (int i = 0; i < pillarPoints.length; i++) { 
    if (i<pillarPoints.length-1) {
      pillarObjFile[i+nbPillarPoints*6 + 1] = "f "+(i+1+nbPillarPoints*2)+" "+(i+1+nbPillarPoints*3)+" "+(i+2+nbPillarPoints*3)+" "+(i+2+nbPillarPoints*2);
    } else {  
      pillarObjFile[i+nbPillarPoints*6 + 1] = "f "+(i+1+nbPillarPoints*2)+" "+(i+1+nbPillarPoints*3)+" "+(1+nbPillarPoints*3)+" "+(1+nbPillarPoints*2);
    }
  }

  // pillar up global face
  // base down face 
  // for(int i = 0 ; i < pillarPoints.length ; i++){ 
  String globalPillarFace ="f ";

  for (int j = 0; j < pillarPoints.length; j++) {

    globalPillarFace+=(j+nbPillarPoints*3)+" ";
  }

  pillarObjFile[nbPillarPoints*7+1] = globalPillarFace;

  // }

  // Writes the strings to a file, each on a separate line
  saveStrings("OBJ/MyPillar"+hour()+minute()+second()+".obj", pillarObjFile);
}


void exportPDF() {
  println("exporting pdf");

  beginRecord(PDF, "PDF/pdfGear"+second()+minute()+day()+month()+year()+".pdf");
}
