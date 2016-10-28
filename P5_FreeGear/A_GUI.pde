void buildGUI() {


  cp5 = new ControlP5(this);


  int teethMin = 8;
  int teethMax = 50;


  // GENERAL PARAMETER

  nbTeethLabel = cp5.addTextlabel("teethLabel")
    .setText("Number of Teeths:")
      .setPosition(xGeneralParamater, 50)
        .setColorValue(0x000000)
          .setFont(createFont("BirchStd", parameterFontSize))
            ;



  cp5.addSlider("teethSlider")
    .setPosition(xGeneralParameterSlider, 50)
      .setSize(parameterSliderWidth, parameterSliderHeight)
        .setValue(33)
          .setRange(teethMin, teethMax)
            .setNumberOfTickMarks(teethMax-teethMin+1)   
              ;       


  cp5.addTextlabel("CentralHoleDiameter")
    .setText("Central Hole Diameter:")
      .setPosition(xGeneralParamater, 90)
        .setColorValue(0x000000)
          .setFont(createFont("BirchStd", parameterFontSize))
            ;   

  cp5.addTextfield("centralHoleValue")
    .setPosition(xGeneralParameterSlider, 90)
      .setSize(parameterSliderWidth, parameterSliderHeight)
        .setValue(""+(centerCircleRadius*2/divide))
          .setFont(createFont("arial", 20))
            .setAutoClear(false)
              ;

  nbTeethLabel = cp5.addTextlabel("removeTeethLabel")
    .setText("Number of Teeths:")
      .setPosition(xGeneralParamater, 140)
        .setColorValue(0x000000)
          .setFont(createFont("BirchStd", parameterFontSize))
            ;



  cp5.addSlider("removeTeethSlider")
    .setPosition(xGeneralParameterSlider, 140)
      .setSize(parameterSliderWidth, parameterSliderHeight)
        .setValue(0)
          .setRange(0, nbDents-1)
            .setNumberOfTickMarks(nbDents)   
              ;      


   cp5.addTextlabel("divideMetricRatio")
    .setText("Divide Metric Ratio:")
      .setPosition(xGeneralParamater, 180)
        .setColorValue(0x000000)
          .setFont(createFont("BirchStd", parameterFontSize))
            ;



  cp5.addSlider("divideMetricRatioSlider")
    .setPosition(xGeneralParameterSlider, 180)
      .setSize(parameterSliderWidth, parameterSliderHeight)
        .setValue(7)
          .setRange(0.1, 100)
          //  .setNumberOfTickMarks(nbDents)   
              ;      



  // gear info




  cp5.addTextlabel("gearDiameter")
    .setText("Gear Diameter:    " + ((r + hauteurDeDent*2)/divide)+ " mm")
      .setPosition(xGUIInfo, 40)
        .setColorValue(0x000000)
          .setFont(createFont("BirchStd", infoFontSize))
            ;    

  cp5.addTextlabel("centralHoleDiameter")
    .setText("CentralHole Diameter:    " + ((r + hauteurDeDent*2)/divide)+ " mm")
      .setPosition(xGUIInfo, 90)
        .setColorValue(0x000000)
          .setFont(createFont("BirchStd", infoFontSize))
            ;


  //Gear Mode
  RadioButton r1;

  r1=cp5.addRadioButton("gearMode")
    .setPosition(xGUIModes, 80)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255, 0, 0))
            .setColorLabel(color(255, 0, 0))
              .setItemsPerRow(3)
                .setSpacingColumn(50)
                  .addItem("Spur", 1)
                    .addItem("Reversed", 2)
                      .addItem("Linear", 3)

                        ;



  // EXPORT



  cp5.addBang("exportToGearObj")
    .setPosition(xExportParameter, 150)
      .setColorLabel(0)
        .setSize(180, 30)
          .setTriggerEvent(Bang.RELEASE)
            .setLabel("Export to Obj")
              ;


  cp5.addBang("exportToGearPDF")
    .setPosition(xExportParameter, 210)
      .setColorLabel(0)
        .setSize(180, 30)
          .setTriggerEvent(Bang.RELEASE)
            .setLabel("Export to PDf")
              ;
}

public void centralHoleValue(String theText) {
  // automatically receives results from controller input

    float parseResult = parseFloat(theText);


  if (parseResult != parseResult) {
    println("error : "+parseResult);
  } else {
    //println("a textfield event for controller 'input' : "+parseResult);
    centerCircleRadius = parseResult * divide / 2 ;
  }

  buildGear();
}

public void setGearMode(char c) {
  // automatically receives results from controller input

  gearMode = c;
  println("mode "+c);

  if (c == 's')reverse = false;
  if (c == 'r')reverse = true;
  if (c == 'l')reverse = false;

  if (!reverse)centerCircleRadius = 50;

  buildGear();
}


public void divideMetricRatioSlider() {
  // automatically receives results from controller input

  divide = cp5.getController("divideMetricRatioSlider").getValue();
  println("divide " +divide);
  
}


void gearMode(int a) {
  // println("a radio Button event: "+a);
  if (a == 1)setGearMode('s');
  if (a == 2)setGearMode('r');
  if (a == 3)setGearMode('l');
}



void teethSlider() {
  // myColor = color(theColor);
  // println("a slider event. setting background to ");
  //println(cp5.getController("teethSlider").getValue());

  buildGear();


  int nTeeth = (int)cp5.getController("teethSlider").getValue();
  changeNbTeeth(nTeeth);
}

void removeTeethSlider() {
  // myColor = color(theColor);
  // println("a slider event. setting background to ");
  //println(cp5.getController("teethSlider").getValue());
  int nTeeth = (int)cp5.getController("removeTeethSlider").getValue();
  enleverDents = nTeeth;

  buildGear();
}



public void exportToGearObj() {
  //int theColor = (int)random(255);
  //myColorBackground = color(theColor);
  println("OBJ Export");
  exportGearObj(epaisseur, gearMode);
}

public void exportToGearPDF() {
  //int theColor = (int)random(255);
  //myColorBackground = color(theColor);
  println("PDF Export");
  saveOneFrame = true;
}



void scalingXSlider() {

  scalingX = cp5.getController("scalingXSlider").getValue();
}

void scalingYSlider() {

  scalingY = cp5.getController("scalingYSlider").getValue();
}



/*
void controlEvent(ControlEvent theEvent) {
 
 if(theEvent.isAssignableFrom(Textfield.class)) {
 println("controlEvent: accessing a string from controller '"
 +theEvent.getName()+"': "
 +theEvent.getStringValue()
 );
 
 
 }
 }
 */
