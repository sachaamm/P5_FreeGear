PShape buildSh(float[][] p){
  
  PShape sh = createShape();
  sh.beginShape();
  
  for(int i = 0 ; i < p.length ; i++){
    sh.vertex(p[i][0],p[i][1],0);  
  }
  
  sh.endShape();
    
  return sh;
 
}

PShape buildShExtruded(float[][] p,float extrude){
   
  PShape sh = createShape();
  sh.beginShape();
  sh.fill(255);
    for(int i = 0 ; i < p.length ; i++){
    sh.vertex(p[i][0],p[i][1]);  
  }
  
  /*
  for(int i = 0 ; i < p.length ; i++){
    sh.vertex(p[i][0],p[i][1],extrude);
    
    
    
  }*/
  
  sh.endShape();
  
  
  return sh;
  
  
  
  
}
