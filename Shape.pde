// ==== S H A P E - D R A W I N G - F U N C T I O N S ====
void drawShapeByGroup(int shapeIndex, float size, PImage tex) 
{
  float time = millis() * 0.001;  // time in seconds, used for animations
  switch (shapeIndex) 
  {
    
    case 0: drawOctahedron(size*0.55, tex); break;       // diamond shape
    case 1: drawIcosahedron(size*0.6, tex); break;       // sphere-like
    case 2: drawUFOShape(size, tex); break;        // flying UFO
    case 3: drawGlitchOrb(size, time, tex); break;       // sphere with random vertex glitch
    case 4: drawDNA(size, time); break;              // DNA
    case 5: drawTesseractShape(size, time, tex); break;  // 4D cube
    case 6: drawCrystalShape(size, time, tex); break;    // crystal 
    case 7: drawJellyfishShape(size, time, tex); break;  // jellyfish
    case 8: drawVortexShape(size, time, tex); break;     
    default: drawTesseractShape(size, time, tex); break;  
  }
}

void drawTexturedBox(float s, PImage tex) 
{
  float d = s/2;
  beginShape(QUADS);
  if (tex != null) 
  {
    texture(tex);
  }
  vertex(-d,-d, d,0,0); vertex( d,-d, d,1,0); vertex( d, d, d,1,1); vertex(-d, d, d,0,1);
  vertex( d,-d,-d,0,0); vertex(-d,-d,-d,1,0); vertex(-d, d,-d,1,1); vertex( d, d,-d,0,1);
  vertex(-d, d, d,0,0); vertex( d, d, d,1,0); vertex( d, d,-d,1,1); vertex(-d, d,-d,0,1);
  vertex(-d,-d,-d,0,0); vertex( d,-d,-d,1,0); vertex( d,-d, d,1,1); vertex(-d,-d, d,0,1);
  vertex( d,-d, d,0,0); vertex( d,-d,-d,1,0); vertex( d, d,-d,1,1); vertex( d, d, d,0,1);
  vertex(-d,-d,-d,0,0); vertex(-d,-d, d,1,0); vertex(-d, d, d,1,1); vertex(-d, d,-d,0,1);
  endShape();
}

// Draws a 8 triangular faces
void drawOctahedron(float size, PImage tex) 
{
  float d = size;
  beginShape(TRIANGLE_FAN);
  if (tex!=null) 
  {
    texture(tex);
  }
  vertex(0,d,0,0.5,1);
  vertex(-d,0,d,0,0); vertex(d,0,d,1,0); vertex(d,0,-d,1,1); vertex(-d,0,-d,0,1); vertex(-d,0,d,0,0);
  endShape(CLOSE);
  beginShape(TRIANGLE_FAN);
  if (tex!=null) 
  {
    texture(tex);
  }
  vertex(0,-d,0,0.5,0);
  vertex(d,0,d,1,0); vertex(-d,0,d,0,0); vertex(-d,0,-d,0,1); vertex(d,0,-d,1,1); vertex(d,0,d,1,0);
  endShape(CLOSE);
}

// Draws a 20 triangular faces 
void drawIcosahedron(float r, PImage tex) 
{
  float t = (1+sqrt(5))/2;
  PVector[] v = new PVector[12];
  v[0]=new PVector(-1,t,0); v[1]=new PVector(1,t,0); v[2]=new PVector(-1,-t,0); v[3]=new PVector(1,-t,0);
  v[4]=new PVector(0,-1,t); v[5]=new PVector(0,1,t); v[6]=new PVector(0,-1,-t); v[7]=new PVector(0,1,-t);
  v[8]=new PVector(t,0,-1); v[9]=new PVector(t,0,1); v[10]=new PVector(-t,0,-1); v[11]=new PVector(-t,0,1);
  for (PVector p : v) 
  { 
    p.normalize(); p.mult(r); 
  }
  int[][] faces = {{0,11,5},{0,5,1},{0,1,7},{0,7,10},{0,10,11},{1,5,9},{5,11,4},{11,10,2},{10,7,6},
                   {7,1,8},{3,9,4},{3,4,2},{3,2,6},{3,6,8},{3,8,9},{4,9,5},{2,4,11},{6,2,10},{8,6,7},{9,8,1}};
  beginShape(TRIANGLES);
  if (tex!=null) 
  {
    texture(tex);
  }
  for (int[] tri : faces)
  {
    for (int i : tri) 
     {
       PVector pt = v[i];
       float u = 0.5+atan2(pt.z,pt.x)/TWO_PI, vv = 0.5-asin(pt.y/r)/PI;
       vertex(pt.x,pt.y,pt.z,u,vv);
     }
  }
  endShape();
}

// Converts sphere coordinates (theta, phi, radius) to 3D 
// Used by drawGlitchOrb to generate sphere vertices
PVector spherical(float theta, float phi, float r) 
{
  return new PVector(r*sin(phi)*cos(theta), r*cos(phi), r*sin(phi)*sin(theta));
}

// Draws UFO 
void drawUFOShape(float size, PImage tex)
{
  float s = size * 0.45;
  int seg = 24;
  // Disc body
  beginShape(TRIANGLE_STRIP);
  if (tex != null) 
  { 
    texture(tex);
  }
  for (int i = 0; i <= seg; i++) 
  {
    float a = TWO_PI * i / seg;
    float r = s;
    vertex(cos(a) * r, 0, sin(a) * r, (float) i / seg, 0.5);
    vertex(cos(a) * r * 0.3, -s * 0.4, sin(a) * r * 0.3, (float) i / seg, 0);
  }
  endShape();
  // Bottom dome
  beginShape(TRIANGLE_STRIP);
  if (tex != null) 
  {
    texture(tex);
  }
  for (int i = 0; i <= seg; i++) 
  {
    float a = TWO_PI * i / seg;
    vertex(cos(a) * s, 0, sin(a) * s, (float) i / seg, 0.5);
    vertex(cos(a) * s * 0.5, s * 0.25, sin(a) * s * 0.5, (float) i / seg, 1);
  }
  endShape();
}

// Draws a glitching sphere with random corruption effect
void drawGlitchOrb(float size, float time, PImage tex) 
{
  float s = size * 0.45;
  int res = 16;
  beginShape(TRIANGLES);
  if (tex != null) 
  {
    texture(tex);
  }
  for (int i = 0; i < res; i++) 
  {
    for (int j = 0; j < res; j++) 
    {
      float u0 = TWO_PI * i / res, u1 = TWO_PI * (i + 1) / res;
      float v0 = PI * j / res, v1 = PI * (j + 1) / res;
      float glitch = (random(1) > 0.92) ? random(-0.3, 0.3) * s : 0;
      float pulse = 1.0 + 0.08 * sin(time * 6 + i * 0.5 + j * 0.3);
      PVector p00 = PVector.mult(spherical(u0, v0, s * pulse + glitch), 1);
      PVector p10 = PVector.mult(spherical(u1, v0, s * pulse), 1);
      PVector p01 = PVector.mult(spherical(u0, v1, s * pulse), 1);
      PVector p11 = PVector.mult(spherical(u1, v1, s * pulse + glitch * 0.5), 1);
      float tu0 = (float) i / res, tu1 = (float)(i+1) / res;
      float tv0 = (float) j / res, tv1 = (float)(j+1) / res;
      vertex(p00.x, p00.y, p00.z, tu0, tv0);
      vertex(p10.x, p10.y, p10.z, tu1, tv0);
      vertex(p01.x, p01.y, p01.z, tu0, tv1);
      vertex(p01.x, p01.y, p01.z, tu0, tv1);
      vertex(p10.x, p10.y, p10.z, tu1, tv0);
      vertex(p11.x, p11.y, p11.z, tu1, tv1);
    }
  }
  endShape();
}

// Draws DNA 
void drawDNA(float size, float time) 
{
  float s = size * 0.35;
  int steps = 40;
  float helixH = s * 3;
  pushStyle();
  for (int i = 0; i < steps; i++) 
  {
    float t = (float) i / steps;
    float y = map(t, 0, 1, -helixH / 2, helixH / 2);
    float ang = t * TWO_PI * 3 + time * 4;
    float r = s * 0.5;
    float ax = cos(ang) * r, az = sin(ang) * r;
    float bx = cos(ang + PI) * r, bz = sin(ang + PI) * r;
    float sphereR = s * 0.08 + s * 0.02 * sin(time * 3 + i);
    
    pushMatrix(); 
    translate(ax, y, az); 
    sphere(sphereR); 
    popMatrix();
    
    pushMatrix(); 
    translate(bx, y, bz); 
    sphere(sphereR); 
    popMatrix();
    if (i % 4 == 0) 
    {
      stroke(200, 200, 255, 180);
      strokeWeight(1.5);
      line(ax, y, az, bx, y, bz);
      noStroke();
    }
  }
  popStyle();
}

// Draws tesseract 4D cude 
void drawTesseractShape(float size, float time, PImage tex) 
{
  float s = size * 0.35;
  float innerScale = 0.4 + 0.1 * sin(time * 2);
  float s2 = s * innerScale;
  
  pushMatrix();
  rotateY(time * 0.5);
  rotateX(time * 0.3);
  rotateZ(time * 0.4);

  pushStyle();
  stroke(0, 200, 255, 180);
  strokeWeight(1.5);
  noFill();
  
  PVector[] vOuter = new PVector[8];
  PVector[] vInner = new PVector[8];
  
  float[] r1 = {s,s,s, -s,s,s, -s,-s,s, s,-s,s, s,s,-s, -s,s,-s, -s,-s,-s, s,-s,-s};
  float[] r2 = {s2,s2,s2, -s2,s2,s2, -s2,-s2,s2, s2,-s2,s2, s2,s2,-s2, -s2,s2,-s2, -s2,-s2,-s2, s2,-s2,-s2};
  
  for (int i=0; i<8; i++) 
  {
    vOuter[i] = new PVector(r1[i*3], r1[i*3+1], r1[i*3+2]);
    vInner[i] = new PVector(r2[i*3], r2[i*3+1], r2[i*3+2]);
  }
  
  int[][] edges = 
  {
    {0,1}, {1,2}, {2,3}, {3,0},
    {4,5}, {5,6}, {6,7}, {7,4},
    {0,4}, {1,5}, {2,6}, {3,7}
  };
  
  for (int[] e : edges) 
  {
    line(vOuter[e[0]].x, vOuter[e[0]].y, vOuter[e[0]].z, vOuter[e[1]].x, vOuter[e[1]].y, vOuter[e[1]].z);
    line(vInner[e[0]].x, vInner[e[0]].y, vInner[e[0]].z, vInner[e[1]].x, vInner[e[1]].y, vInner[e[1]].z);
  }
  
  for (int i=0; i<8; i++) 
  {
    line(vOuter[i].x, vOuter[i].y, vOuter[i].z, vInner[i].x, vInner[i].y, vInner[i].z);
  }
  
  noStroke();
  if (tex != null) 
  {
    textureMode(NORMAL);
    fill(255, 100);
  } 
  else 
  {
    fill(0, 200, 255, 50);
  }
  
  int[][] faces = 
  {
    {0,1,2,3}, {4,5,6,7}, {0,1,5,4}, {2,3,7,6}, {1,2,6,5}, {0,3,7,4}
  };
  
  beginShape(QUADS);
  if (tex != null)
  {
    texture(tex);
  }
  for (int[] f : faces) 
  {
    vertex(vInner[f[0]].x, vInner[f[0]].y, vInner[f[0]].z, 0, 0);
    vertex(vInner[f[1]].x, vInner[f[1]].y, vInner[f[1]].z, 1, 0);
    vertex(vInner[f[2]].x, vInner[f[2]].y, vInner[f[2]].z, 1, 1);
    vertex(vInner[f[3]].x, vInner[f[3]].y, vInner[f[3]].z, 0, 1);
  }
  endShape();
  
  popStyle();
  popMatrix();
}

// Draws a hexagonal crystal
void drawCrystalShape(float size, float time, PImage tex) 
{
  float s = size * 0.4;
  float grow = 1.0 + 0.08 * sin(time * 3);
  int sides = 6;
  beginShape(TRIANGLE_FAN);
  if (tex != null)
  {
    texture(tex);
  }
  vertex(0, -s * 1.5 * grow, 0, 0.5, 0);
  for (int i = 0; i <= sides; i++) 
  {
    float a = TWO_PI * i / sides + time * 0.5;
    float shimmer = 1.0 + 0.05 * sin(time * 6 + i * 2);
    vertex(cos(a) * s * 0.5 * shimmer, 0, sin(a) * s * 0.5 * shimmer, (float)i/sides, 0.5);
  }
  endShape();
  beginShape(TRIANGLE_FAN);
  if (tex != null) 
  {
    texture(tex);
  }
  vertex(0, s * 0.8 * grow, 0, 0.5, 1);
  for (int i = 0; i <= sides; i++) 
  {
    float a = TWO_PI * i / sides + time * 0.5;
    float shimmer = 1.0 + 0.05 * sin(time * 6 + i * 2);
    vertex(cos(a) * s * 0.5 * shimmer, 0, sin(a) * s * 0.5 * shimmer, (float)i/sides, 0.5);
  }
  endShape();
  pushStyle(); 
  noStroke();
  for (int i = 0; i < 4; i++) 
  {
    float pa = time * 2 + i * HALF_PI;
    float pr = s * 0.7;
    float py = -s * 0.5 + s * sin(time * 4 + i);
    fill(200, 230, 255, 150 + 100 * sin(time * 8 + i));
    pushMatrix(); 
    translate(cos(pa)*pr, py, sin(pa)*pr);
    sphere(2 + sin(time * 6 + i));
    popMatrix();
  }
  popStyle();
}

// Draws jellyfish 
void drawJellyfishShape(float size, float time, PImage tex) 
{
  float s = size * 0.4;
  int seg = 20;
  float bob = sin(time * 2) * s * 0.15;
  beginShape(TRIANGLE_STRIP);
  if (tex != null) 
  {
    texture(tex);
  }
  for (int j = 0; j < 8; j++) 
  {
    float v0 = PI * 0.5 * j / 8, v1 = PI * 0.5 * (j+1) / 8;
    for (int i = 0; i <= seg; i++) 
    {
      float a = TWO_PI * i / seg;
      float pulse = 1.0 + 0.06 * sin(time * 4 + a * 2);
      float r0 = s * sin(v0) * pulse, y0 = -s * cos(v0) * 0.6 + bob;
      float r1 = s * sin(v1) * pulse, y1 = -s * cos(v1) * 0.6 + bob;
      vertex(cos(a)*r0, y0, sin(a)*r0, (float)i/seg, (float)j/8);
      vertex(cos(a)*r1, y1, sin(a)*r1, (float)i/seg, (float)(j+1)/8);
    }
  }
  endShape();
  pushStyle(); 
  noFill();
  for (int t = 0; t < 8; t++) 
  {
    float ta = TWO_PI * t / 8;
    stroke(180, 200, 255, 120);
    strokeWeight(1.5);
    beginShape();
    for (int k = 0; k < 12; k++)
    {
      float fy = bob + k * s * 0.15;
      float wave = sin(time * 3 + k * 0.5 + t) * s * 0.15;
      float fr = s * 0.4 * (1.0 - k * 0.06);
      vertex(cos(ta) * fr + wave, fy, sin(ta) * fr);
    }
    endShape();
  }
  popStyle();
}


// Draws a vortex shape 
void drawVortexShape(float size, float time, PImage tex) 
{
  float s = size * 0.4;
  int arms = 5, pts = 20;
  pushStyle();
  for (int a = 0; a < arms; a++) 
  {
    float baseAng = TWO_PI * a / arms + time * 2;
    beginShape(TRIANGLE_STRIP);
    if (tex != null) 
    {
      texture(tex);
    }
    else 
    {
      noStroke(); 
      fill(120 + a*25, 100, 255, 200); 
    }
    for (int p = 0; p < pts; p++) 
    {
      float t = (float)p / pts;
      float spiralAng = baseAng + t * TWO_PI * 1.5;
      float r = s * 0.1 + t * s * 0.8;
      float y = map(t, 0, 1, -s * 0.6, s * 0.6);
      float wobble = 1 + 0.1 * sin(time * 5 + p);
      float thickness = s * 0.06 * (1.0 - t * 0.5);
      vertex(cos(spiralAng)*r*wobble, y - thickness, sin(spiralAng)*r*wobble, t, 0);
      vertex(cos(spiralAng)*r*wobble, y + thickness, sin(spiralAng)*r*wobble, t, 1);
    }
    endShape();
  }
  noStroke(); 
  fill(200, 180, 255, 220);
  sphere(s * 0.12 * (1 + 0.2 * sin(time * 6)));
  popStyle();
}
