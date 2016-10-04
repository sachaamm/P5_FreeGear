boolean lineIntersect( float Ax, float Ay, float Bx, float By, float Cx, float Cy, float Dx, float Dy   ) {

  float Ix, Iy, Jx, Jy; 
  Ix =Bx - Ax;
  Iy = By - Ay ;

  Jx = Dx - Cx;
  Jy = Dy - Cy;

  float m, k;

  m = -(-Ix*Ay+Ix*Cy+Iy*Ax-Iy*Cx)/(Ix*Jy-Iy*Jx);
  k = -(Ax*Jy-Cx*Jy-Jx*Ay+Jx*Cy)/(Ix*Jy-Iy*Jx);

  if (m>0 && m<1 && k>0 && k<1)return true;

  return false;
}


float[][] ajoutTableau(float[][] f, float a, float b) {

  float[][] n = new float[f.length+1][2];

  for (int i = 0; i < f.length; i++) {
    n[i] = f[i];
  }

  n[n.length-1][0] = a;
  n[n.length-1][1] = b;

  return n;
}


float[][] agrandirTableau(float[][] f, float[][] n) {

  float[][] a = new float[f.length + n.length][2];

  for (int i = 0; i < f.length; i++) {

    a[i] = f[i];
  }

  for (int i = 0; i < n.length; i++) {

    a[i + f.length ] = n[i];
  }

  return a;
}

float[][] supprimerIndex(float[][] f, int ind) {

  float[][] n = new float[f.length-1][2];

  for (int i = 0; i < ind; i++) {
    n[i] = f[i];
  }

  for (int i = ind; i < f.length-1; i++) {
    n[i] = f[i+1];
  }


  return n;
}



float[] getPointIntersectTwoLines(float Ax, float Ay, float Bx, float By, float Cx, float Cy, float Dx, float Dy   ) {

  float Ix, Iy, Jx, Jy; 
  Ix =Bx - Ax;
  Iy = By - Ay ;

  Jx = Dx - Cx;
  Jy = Dy - Cy;

  float m, k;

  m = -(-Ix*Ay+Ix*Cy+Iy*Ax-Iy*Cx)/(Ix*Jy-Iy*Jx);
  k = -(Ax*Jy-Cx*Jy-Jx*Ay+Jx*Cy)/(Ix*Jy-Iy*Jx);

  if (m>0 && m<1 && k>0 && k<1) {
  } else {
    return null;
  }

  float Px = Ax + k*Ix;
  float Py = Ay + k*Iy;

  float[] f = new float[2];

  f[0] = Px;
  f[1] = Py;

  return f;
}

ArrayList<float[]>  getIntersectionCircleAndLine(float xl, float yl, float xl2, float yl2, float xC, float yC, float r) {

  int c=-1;

  ArrayList<float[]> intersections = new ArrayList<float[]>();
  int precision = 121;
  float[][] pointLines = new float[precision][4];

  for (float i = 0; i < PI*2; i += (PI*2/precision) ) {

    float currX = xC + cos(i) * r/2 ;
    float currY = yC + sin(i) * r/2 ;

    float nextX = xC + cos(i+(PI*2/precision)) * r/2 ;
    float nextY = yC + sin(i+(PI*2/precision)) * r/2 ;

    if (c<pointLines.length-1) c++;

    pointLines[ c ][0] = currX;
    pointLines[ c ][1] = currY;
    pointLines[ c ][2] = nextX;
    pointLines[ c ][3] = nextY;
  }

  int nbIntersections = 0;

  for (int i = 0; i < pointLines.length; i++) {

    if (lineIntersect(xl, yl, xl2, yl2, pointLines[i][0], pointLines[i][1], pointLines[i][2], pointLines[i][3])) {
      float[] p = new float[2];
      p = getPointIntersectTwoLines(xl, yl, xl2, yl2, pointLines[i][0], pointLines[i][1], pointLines[i][2], pointLines[i][3]);

      nbIntersections++;
      intersections.add( p );
    }
  }

  return intersections;
}


float[] getLeft ( float[] f, float[] f2 ) {

  if (f[0]<f2[0]) {
    return f;
  } else {
    return f2;
  }
}

float[] getRight ( float[] f, float[] f2 ) {

  if (f[0]>f2[0]) {
    return f;
  } else {
    return f2;
  }
}


float calculRadiusAvecLePasEtLAddendum( float taillePas, float addendum) {

  float distInconnue = sqrt( sq(taillePas) + sq(addendum));

  return distInconnue*2;
}



float calculDiametre( float taillePas, float addendum) {

  float distInconnue = sqrt( sq(taillePas) + sq(addendum));

  return distInconnue*2;
}



float[] getPointRotateAround( float xR, float yR, float x, float y, float angle, float radius) {

  float[] f = new float[2];

  float pas = xR - x;
  float addendum = yR-y; 
  f[0] = x + cos(angle) * radius/2;
  f[1] = y + sin(angle) * radius/2;

  return f;
}


float[] getIntermediaryPos(float xa, float ya, float xb, float yb, float ratio) {

  float[] f = new float[2];

  float xc = xa - (xa-xb) * ratio;
  float yc = ya - (ya-yb) * ratio;

  f[0] = xc;
  f[1] = yc;

  return f;
}

// returns the angle from v1 to v2 in clockwise direction
// range: [0..TWO_PI]
float angle(PVector v1, PVector v2) {
  float a = atan2(v2.y, v2.x) - atan2(v1.y, v1.x);
  if (a < 0) a += TWO_PI;
  return a;
}


float[][] reversePoints(float[][] points) {

  float[][] newpoints = new float[points.length][2];
  float[][] initPoints, distances;
  float baseX, baseY;
  initPoints = new float[points.length-1][2];
  distances = new float[points.length-1][2];

  for (int i = 0; i < initPoints.length; i++) {

    initPoints[i][0] = points[i+1][0];
    initPoints[i][1] = points[i+1][1];
  }

  baseX = points[0][0];
  baseY = points[0][1];

  for (int i = 0; i < distances.length; i++) {
    // 4 = 6 - 2
    // 6 = 4 +2
    distances[i][0] = initPoints[i][0] - baseX;
    distances[i][1] = initPoints[i][1] - baseY;
  }




  for (int i = 1; i < points.length; i++) {

    // points[i][0] = baseX + distances[i-1][0] * scalingX;
    points[i][1] = baseY - distances[i-1][1];
  }

  newpoints = points;

  return newpoints;
}

void setScaling(char arg) {

  if(arg=='x')scalingX  = map(mouseX,0,width,0,1.4) ;
  if(arg=='y')scalingY =  map(mouseY, 0, height, 1.4, 0.1) ;
}


float[][] scalePoints(float[][] points) {

  float baseX, baseY;
  float[][] distances = new float[points.length-1][2];

  baseX = points[0][0];
  baseY = points[0][1];


  for (int i = 0; i < distances.length; i++) {
    // 4 = 6 - 2
    // 6 = 4 +2
    distances[i][0] = points[i+1][0] - baseX;
    distances[i][1] = points[i+1][1] - baseY;
  }



  for (int i = 1; i < points.length; i++) {

    points[i][0] = baseX + distances[i-1][0] * scalingX;
    points[i][1] = baseY + distances[i-1][1] * scalingY;
  }

  return points;
}


float[] convert2DarrayToArray(float[][] f, int v) {

  float[] ff = new float[f.length];

  for (int i = 0; i < f.length; i++) {
    ff[i] = f[i][v];
  }

  return ff;
}

float getMin(float[] f) {
  float fmin = 0;
  for (int i = 0; i < f.length; i++) {
    if (f[i] < fmin) fmin = f[i];
  }

  return fmin;
}

float getMax(float[] f) {
  float fmax = 0;
  for (int i = 0; i < f.length; i++) {
    if (f[i] > fmax) fmax = f[i];
  }

  return fmax;
}

float[] getXvalues(float[][] f) {

  float[] n = new float[f.length];

  for (int i = 0; i < f.length; i++) {

    n[i] = f[i][0];
  }
  return n;
}
