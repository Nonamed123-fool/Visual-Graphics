// ========================================================
// DavidSovann Visual Graphics from txet file
// ========================================================

import peasy.*;
import processing.event.*;

// ------------------- D A T A - S T O R A G E -------------------
Table table;
String[] columnHeaders;
ArrayList<Member> members;

// ------------------- C A M E R A - C O N T R O L S -------------------
PeasyCam cam;
float rotX = 0, rotY = 0;
PVector camPos;
float camYaw = 0;
float camPitch = 0;

float gridSize = 2000;
float step = 200;

// ------------------- C O L O R - F O R - Y E A R - O F - B I R T H -------------------
color[] yearColors = { color(60, 130, 240), color(80, 200, 200), color(100, 220, 100),
  color(240, 220, 60), color(240, 150, 50), color(240, 70, 70)
};

// ------------------- T E X T U R E S -------------------
PImage[] textures = new PImage[8];
PImage blendedTex;
boolean[] texActive = new boolean[8];
String[] texNames = {"Checker","Stripes","Noise","Gradient","Dots","Circuit","Marble","Hexagon"};

// ------------------- P N G - T E X T U R E S -------------------
PImage[] pngTextures;
String[] pngTexNames;
int pngTexCount = 0;

// ------------------- H O V E R / S E L E C T I O N -------------------
Member hoveredMember = null;
Member selectedMember = null;
ArrayList<Member> selectedMembers = new ArrayList<Member>();

// ------------------- R O T A T I O N / R E S I Z E  -------------------
char rotAxisKey = ' ';

// ------------------- T O O L B A R -------------------
boolean showLabels = true;
boolean showGenderBars = true;
boolean showGrid = true;
boolean showTextures = true;
boolean showTickLabels = true;
int textureModeState = 0; // 0=Mixed, 1=Checker, 2=Stripes, 3=Noise

// ------------------- S H A P E S & D  R O P - D O W N S -------------------
boolean groupMapOpen = false;
boolean genderDropdownOpen = false;
boolean texDropdownOpen = false;
int genderDisplayMode = 0;
String[] genderModeLabels = {"Bar","Symbol","Both","None"};

// ------------------- G R O U P - S H A P E  -------------------
float levelMinSize = 18.0;
float levelMaxSize = 66.0;
int[] groupShape = {0, 1, 2, 3, 4};
ArrayList<Integer> availableShapes = new ArrayList<Integer>();
ArrayList<Integer> allShapeOptions = new ArrayList<Integer>();

// ------------------- G I F - F R A M E -------------------
int frame = 12;
int shapeCount = 13;
PImage[][] frameCache;
int frameCounter = 0;
int texBlendMode = 0;
String[] blendModeNames = {"Average","Multiply","Screen","Overlay"};

// ------------------- H I G H L I G H T ----------------
color highlightColor = color(100, 255, 200);
boolean highlightPickerOpen = false;
color[] highlightPresets = {
  color(0,255,128), color(255,255,0), color(255,50,50),
  color(255,0,255), color(0,255,255), color(255,255,255)
};
String[] hlNames = {"Green","Yellow","Red","Magenta","Cyan","White"};

// ------------------- B O N U S - F E A T U R E S -----------------
boolean showHelp = false;
boolean showParticleTrails = false;
boolean snapToGrid = false;
float snapGridSize = 50;

boolean autoSpinOn = false;
float worldRotX = 0, worldRotY = 0, worldRotZ = 0;
ArrayList<Member> permanentHighlight = new ArrayList<Member>();

// Y e a r - c o l o u r 
boolean showYearColorEditor = false;
int yearEditDrag = -1;
float legendSliderStartY = 0;
float legendArrowX, legendArrowY;

// L e g e n d  
float genderArrowY = 0;
float genderDropdownStartY = 0;
float groupArrowY = 0;
float groupResetBtnY = 0;
float[] groupItemYs = new float[15];
boolean levelScaleOpen = false;
int selectedLevelRescale = 1;
int selectedLevelGroup = -1;  // -1 = All groups, 0-4 = specific group

// ------------------- P A N E L -------------------
boolean showToolbarPanel = true;
boolean showLegendBox = true;

// ------------------- G E N D E R S E L E C T E D M O D E -------------------
boolean genderOnlySelected = false;   // toolbar button

// ------------------- T O O L B A R B U T T O N S -------------------
float toolbarX, toolbarY;
float btnW = 150, btnH = 32, btnGap = 6;
int numButtons = 23;
String[] btnLabels = {
  "Filled/Wire All", "Filled/Wire (Selected)", "Shape Outline All", "Shape Outline (Selected)",
  "Labels", "Grid", "Tick Marks", "Reset View",
  "Textures", "Tex: Checker", "Tex: Stripes", "Tex: Noise",
  "< PNG Texture >", "Save Scene", "Load Scene",
  "Spin All: OFF", "Spin Shape", "Reset Position", "Highlight", "Scale +", "Scale -",
  "Reset Scale", "Highlight Color"
};

// ------------------- L E G E N D - P O S I T  I O N I N G ---------
float legendLx, legendLy, legendBoxW, legendBoxH;

// ------------------- G E N D E R - C L IC K A B  L E - A R E A S -------------------
float maleSymX, maleSymY, maleSymW = 40, maleSymH = 20;
float femaleSymX, femaleSymY, femaleSymW = 40, femaleSymH = 20;
float showAllGenderBtnX, showAllGenderBtnY, showAllGenderBtnW = 55, showAllGenderBtnH = 16;
float showSelGenderBtnX, showSelGenderBtnY, showSelGenderBtnW = 55, showSelGenderBtnH = 16;
float resetGenderBtnX, resetGenderBtnY, resetGenderBtnW = 38, resetGenderBtnH = 16;

// ------------------- G E N D E R - A L L / S E L - B U T T O N S -------------------
float allMaleBtnX, allMaleBtnY, allMaleBtnW = 52, allMaleBtnH = 16;
float allFemaleBtnX, allFemaleBtnY, allFemaleBtnW = 52, allFemaleBtnH = 16;
float selMaleBtnX, selMaleBtnY, selMaleBtnW = 52, selMaleBtnH = 16;
float selFemaleBtnX, selFemaleBtnY, selFemaleBtnW = 52, selFemaleBtnH = 16;
float showGenderAllBtnX, showGenderAllBtnY, showGenderAllBtnW = 52, showGenderAllBtnH = 16;
float showGenderSelBtnX, showGenderSelBtnY, showGenderSelBtnW = 52, showGenderSelBtnH = 16;

// ------------------- L I G H T I N G - T O G G L E S -------------------
boolean lightPointOn = true;
boolean lightSpotOn = true;
boolean lightSpecOn = true;
boolean lightAmbOn = true;
boolean lightDirOn = true;
float lightPointBtnX, lightPointBtnY, lightBtnW = 72, lightBtnH = 22;
float lightSpotBtnX, lightSpotBtnY;
float lightSpecBtnX, lightSpecBtnY;
float lightAmbBtnX, lightAmbBtnY;
float lightDirBtnX, lightDirBtnY;


// ===================== SETUP =====================
//Creates textures, frame, sets the camera position,
// loads member data from Member.csv, and populates the shape for group
void setup() 
{
  size(1500, 1100, P3D);
  smooth(8);
  textFont(createFont("SansSerif", 14));

  toolbarX = width - btnW - 20;
  toolbarY = 50;

  createTextures();
  loadPngTextures();
  generateAnimFrames();

  camPos = new PVector(0, 0, 1200);
  camYaw = PI;
  camPitch = -0.3;

  cam = new PeasyCam(this, 1200);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1000);
  //cam.setActive(true);

  loadData();
  initShapePool();
}

// Builds the pool of shapes available for group shape 
//   0=Octahedron, 1=Icosahedron, 2=UFO, 3=GlitchOrb, 4=DNA,
//   5=Tesseract, 6=Crystal, 7=Jellyfish, 8=Vortex

void initShapePool() 
{
  allShapeOptions.clear();
  int[] opts = {0, 1, 2, 3, 4, 5, 6, 7, 8};
  for (int v : opts) 
  {
    allShapeOptions.add(v);
  }
  availableShapes.clear();
  for (int v : opts) 
  {
    availableShapes.add(v);
  }
  for (int g = 0; g < 5; g++) 
  {
    availableShapes.remove((Integer)groupShape[g]);  // Remove already assigned shapes from the pool
  }
}

// -------- Resets all 5 groups back to their default shape --------
void resetGroupShapes() 
{
  groupShape = new int[] {0, 1, 2, 3, 4};
  initShapePool();
}

//  -------- Resets group g back to its default shape --------
// If another group currently holds that default shape, the two groups swap shapes
// Otherwise the current shape is returned to the available pool 
void resetSingleGroupShape(int g) 
{
  int current = groupShape[g];      // Shape currently assigned to this group
  if (current == g) 
  {
    return;       
  }
  
  // Check if another group is using this group shape
  int holder = -1;
  for (int i = 0; i < 5; i++) 
  {
    if (groupShape[i] == g) 
    {
      holder = i;
      break;
    }
  }
  
  if (holder != -1)
  {
    // Another group has our default shape
    groupShape[g] = g;
    groupShape[holder] = current;
  } 
  else 
  {
    // Default shape is in the available pool 
    availableShapes.add(current);
    availableShapes.remove((Integer)g);
    groupShape[g] = g;
  }
}

// Create textures used for shape 
// [0] Checker, [1] Stripes, [2] Noise, [3] Radial Gradient,
// [4] Dot Grid, [5] Circuit Board, [6] Marble, [7] Hexagon pattern
void createTextures() 
{
  textureMode(NORMAL);
  textures[0] = createImage(64, 64, RGB);
  textures[0].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++)
    {
      textures[0].pixels[j * 64 + i] = ((i/8) + (j/8)) % 2 == 0 ? color(255) : color(150);
    }
  }
  textures[0].updatePixels();
  textures[1] = createImage(64, 64, RGB);
  textures[1].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++)
    {
      textures[1].pixels[j * 64 + i] = (j/8) % 2 == 0 ? color(255) : color(180);
    }
  }
  textures[1].updatePixels();
  textures[2] = createImage(64, 64, RGB);
  textures[2].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++)
    {
      textures[2].pixels[j * 64 + i] = color(map(noise(i * 0.1, j * 0.1), 0, 1, 100, 255));
    }
  }
  textures[2].updatePixels();
  textures[3] = createImage(64, 64, RGB);
  textures[3].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++) 
    {
      float d = dist(i, j, 32, 32) / 32.0;
      textures[3].pixels[j * 64 + i] = color(map(d, 0, 1, 255, 60));
    }
  }
  textures[3].updatePixels();
  textures[4] = createImage(64, 64, RGB);
  textures[4].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++) 
    {
      float dx = (i % 16) - 8, dy = (j % 16) - 8;
      textures[4].pixels[j * 64 + i] = (sqrt(dx*dx+dy*dy) < 5) ? color(220) : color(100);
    }
  }
  textures[4].updatePixels();
  textures[5] = createImage(64, 64, RGB);
  textures[5].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++)
    {
      boolean line = (i % 12 < 2) || (j % 12 < 2) || (i % 12 == 6 && j % 12 > 4);
      textures[5].pixels[j * 64 + i] = line ? color(180, 220, 255) : color(30, 40, 60);
    }
  }
  textures[5].updatePixels();
  textures[6] = createImage(64, 64, RGB);
  textures[6].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++) 
    {
      float v = sin(i * 0.15 + noise(i * 0.05, j * 0.05) * 10) * 0.5 + 0.5;
      textures[6].pixels[j * 64 + i] = color(map(v, 0, 1, 140, 255), map(v, 0, 1, 130, 250), map(v, 0, 1, 120, 245));
    }
  }
  textures[6].updatePixels();
  textures[7] = createImage(64, 64, RGB);
  textures[7].loadPixels();
  for (int i = 0; i < 64; i++)
  {
    for (int j = 0; j < 64; j++) 
    {
      float hx = i * 0.15, hy = j * 0.15;
      float hv = abs(sin(hx) * cos(hy * 1.15 + hx * 0.5));
      textures[7].pixels[j * 64 + i] = hv > 0.4 ? color(200, 210, 230) : color(80, 90, 110);
    }
  }
  textures[7].updatePixels();

  texActive[0] = true; texActive[1] = false; texActive[2] = false;
  for (int i = 3; i < 8; i++) 
  {
    texActive[i] = false;
  }
  blendedTex = textures[0];
}

// Loads all PNG texture images 
void loadPngTextures()
{
  File dataDir = new File(sketchPath(""));
  File[] allFiles = dataDir.listFiles();
  ArrayList<String> pngFiles = new ArrayList<String>();
  if (allFiles != null)
  {
    for (File f : allFiles)
    {
      String fname = f.getName().toLowerCase();
      if ((fname.endsWith(".png") || fname.endsWith(".jpg") || fname.endsWith(".jpeg") || fname.endsWith(".gif")))
      {
        pngFiles.add(f.getName());
      }
    }
  }
  java.util.Collections.sort(pngFiles);
  pngTexCount = pngFiles.size();
  pngTextures = new PImage[pngTexCount];
  pngTexNames = new String[pngTexCount];
  for (int i = 0; i < pngTexCount; i++)
  {
    pngTexNames[i] = "Texture " + (i + 1);
    PImage img = loadImage(pngFiles.get(i));
    if (img != null) 
    {
      PImage flipped = createImage(img.width, img.height, ARGB);
      img.loadPixels();
      flipped.loadPixels();
      for (int y = 0; y < img.height; y++) 
      {
        for (int x = 0; x < img.width; x++) 
        {
          flipped.pixels[(img.height - 1 - y) * img.width + x] = img.pixels[y * img.width + x];
        }
      }
      flipped.updatePixels();
      pngTextures[i] = flipped;
    } 
    else 
    {
      pngTextures[i] = img;
    }
  }
}

// Texture to apply to a shape, based on current texture mode
// If a texture mode is selected (1-8), returns that texture
PImage getActiveTexture(int memberTexIdx) 
{
  if (textureModeState > 0 && textureModeState <= 8) 
  {
    return textures[textureModeState - 1];
  }
  return textures[memberTexIdx % 8];
}

// -------- Loads member data from Member.csv --------
void loadData() 
{
  members = new ArrayList<Member>();
  table = loadTable("Member2.csv", "header");
  if (table == null) 
  {
    println("ERROR: Could not load Member.csv");
    return;
  }
  columnHeaders = new String[table.getColumnCount()];
  for (int i = 0; i < table.getColumnCount(); i++)
  {
    columnHeaders[i] = table.getColumnTitle(i).trim();
  }
  for (TableRow row : table.rows())
  {
    
    members.add(new Member(row));
  }
}


// -------- DRAW --------
//   1. Clears screen, handles keyboard/mouse input
//   2. Computes camera 
//   3. Draws 3D scene: grid, axis labels, members (shapes), and shadow 
//   4. Finds the closest member to the mouse cursor for hover detection
//   5. Legend, Toolbar, Tooltips
void draw() 
{
  background(10, 10, 15);
  handleWASD();
  handleSelectedTransform();
  if (frameCount % 4 == 0) 
  {
    frameCounter = (frameCounter + 1) % frame;
  }

  float cosPitch = cos(camPitch);
  float sinPitch = sin(camPitch);
  float cosYaw   = cos(camYaw);
  float sinYaw   = sin(camYaw);
  PVector lookDir = new PVector(cosPitch * sinYaw, sinPitch, cosPitch * cosYaw);
  PVector lookAt  = PVector.add(camPos, lookDir);
  camera(camPos.x, camPos.y, camPos.z, lookAt.x, lookAt.y, lookAt.z, 0, 1, 0);

  rotX = -camPitch;
  rotY = camYaw;

  customLightFunction();

  // Apply world rotation
  pushMatrix();
  rotateX(worldRotY);
  rotateY(worldRotX);
  rotateZ(worldRotZ);

  if (showGrid) 
  {
    drawFullGrid();
  }
  drawAxisLabels();
  drawMembers();
  drawAllShadows();
  popMatrix();

  // -------- Hover detection --------
  hoveredMember = null;
  float hoverThreshold = 35;
  float depthCutoff = 0.998;
  float bestD = hoverThreshold;
  float bestZ = Float.MAX_VALUE;

  for (Member m : members) 
  {
    if (m.sz > depthCutoff)
    {
      continue;
    }
    float d = dist(mouseX, mouseY, m.sx, m.sy);
    if (d < bestD && m.sz < bestZ) 
    { 
      bestD = d; 
      bestZ = m.sz; 
      hoveredMember = m; 
    }
  }

  cam.beginHUD();
  drawLegend();
  drawToolbar();
  drawHelpOverlay();
  drawHighlightPicker();
  if (hoveredMember != null) 
  {
    drawTooltip(hoveredMember, mouseX, mouseY);
  }
  else if (selectedMember != null) 
  {
    drawTooltip(selectedMember, selectedMember.sx, selectedMember.sy);
  }
  if (selectedMembers.size() > 1) 
  {
    fill(255,255,100,220); 
    noStroke(); 
    textSize(12); 
    textAlign(LEFT,TOP);
    text("Multi-selected: " + selectedMembers.size() + " items  |  Drag to move group", 20, height - 25);
  }
  cam.endHUD();
}

// Handles movement WASD key
// w/s = forward/backward 
// a/d = strafe left/right Shift+W/S = move vertically up/down
void handleWASD() 
{
  float moveSpeed = 10.0;
  if (!keyPressed) 
  {
    return;
  }
  float cosP = cos(camPitch);
  float cosY = cos(camYaw);
  float sinY = sin(camYaw);
  PVector forward = new PVector(cosP * sinY, 0, cosP * cosY).normalize();
  PVector right   = new PVector(cosY, 0, -sinY).normalize();
  if (key == 'w')
  {
    camPos.add(PVector.mult(forward, moveSpeed));
  }
  if (key == 's') 
  {
    camPos.sub(PVector.mult(forward, moveSpeed));
  }
  if (key == 'a') 
  {
    camPos.add(PVector.mult(right, moveSpeed));
  }
  if (key == 'd') 
  {
    camPos.sub(PVector.mult(right, moveSpeed));
  }
  if (key == 'W') 
  {
    camPos.y -= moveSpeed;
  }
  if (key == 'S')
  {
    camPos.y += moveSpeed;
  }
}

// -------- Arrow keys rotate on X/Y axes, < > rotate on Z, O/I move along the Z axis --------
void handleSelectedTransform() 
{
  ArrayList<Member> targets = getActiveSelection();
  float rotSpeed = 0.03;
  float zMoveSpeed = 10.0;
  if (!keyPressed) return;

  // When no object is selected, rotate the world
  if (targets.size() == 0) 
  {
    if (keyCode == LEFT)   
    { 
      worldRotX += rotSpeed; 
    }
    if (keyCode == RIGHT)  
    {
      worldRotX -= rotSpeed;
    }
    if (keyCode == UP)     
    {
      worldRotY -= rotSpeed; 
    }
    if (keyCode == DOWN)   
    { 
      worldRotY += rotSpeed; 
    }
    if (key == '<' || key == ',')  
    { 
      worldRotZ += rotSpeed;
    }
    if (key == '>' || key == '.') 
    { 
      worldRotZ -= rotSpeed;
    }
    return;
  }

  // When objects are selected, then rotate them 
  for (Member t : targets)
  {
    if (keyCode == LEFT)   
    {
      t.objRotY += rotSpeed;
    }
    if (keyCode == RIGHT)  
    {
      t.objRotY -= rotSpeed;
    }
    if (keyCode == UP)     
    {
      t.objRotX -= rotSpeed;
    }
    if (keyCode == DOWN)  
    {
      t.objRotX += rotSpeed;
    }
    if (key == '<' || key == ',')  
    {
      t.objRotZ += rotSpeed;
    }
    if (key == '>' || key == '.') 
    {
      t.objRotZ -= rotSpeed;
    }
    if (key == 'O' || key == 'o')   
    {
      t.z += zMoveSpeed;
    }
    if (key == 'I' || key == 'i')   
    {
      t.z -= zMoveSpeed;
    }
    t.z = constrain(t.z, 0, 1000);
  }
}

// Mouse drag for 
//   1 Year colour editor 
//   2 XY position dragging of selected shapes 
//   3 Camera rotation when nothing is selected
void mouseDragged() 
{
  if (showYearColorEditor && yearEditDrag != -1)
  {
    int idx = yearEditDrag / 3;
    int ch = yearEditDrag % 3;
    float sliderX = legendLx + 65;
    float sliderW = 100;
    int newVal = int(map(constrain(mouseX, sliderX, sliderX + sliderW), sliderX, sliderX + sliderW, 0, 255));
    color c = yearColors[idx];
    if (ch == 0) 
    {
      c = color(newVal, green(c), blue(c));
    }
    if (ch == 1) 
    {
      c = color(red(c), newVal, blue(c));
    }
    if (ch == 2) 
    {
      c = color(red(c), green(c), newVal);
    }
    yearColors[idx] = c;
    return;
  }
  if (!mousePressed) 
  {
    return;
  }
  float dx = mouseX - pmouseX;
  float dy = mouseY - pmouseY;
  if (rotAxisKey != ' ' && (selectedMember != null || selectedMembers.size() > 0)) 
  {
    float rotSpeed = 0.02;
    ArrayList<Member> targets = getActiveSelection();
    for (Member t : targets) {
      if (rotAxisKey == 'x') 
      {
        t.objRotX += dy * rotSpeed;
      }
      if (rotAxisKey == 'y') 
      {
        t.objRotY += dx * rotSpeed;
      }
      if (rotAxisKey == 'z')
      {
        t.objRotZ += dx * rotSpeed;
      }
    }
    return;
  }
  if (selectedMember != null || selectedMembers.size() > 0) 
  {
    float sensitivity = 0.5;
    ArrayList<Member> targets = getActiveSelection();
    float moveX = dx * sensitivity;
    float moveY = -dy * sensitivity;
    float minX = 1000, maxX = 0, minY = 1000, maxY = 0;
    for (Member t : targets) 
    {
      if (t.x < minX)
      {
        minX = t.x;
      }
      if (t.x > maxX) 
      {
        maxX = t.x;
      }
      if (t.y < minY)
      {
        minY = t.y;
      }
      if (t.y > maxY) 
      {
        maxY = t.y;
      }
    }
    if (minX + moveX < 0)
    {
      moveX = -minX;
    }
    if (maxX + moveX > 1000) 
    {
      moveX = 1000 - maxX;
    }
    if (minY + moveY < 0) 
    {
      moveY = -minY;
    }
    if (maxY + moveY > 1000) 
    {
      moveY = 1000 - maxY;
    }
    for (Member t : targets) 
    {
      t.x += moveX;
      t.y += moveY;
    }
  } 
  else
  {
    float sensitivity = 0.005;
    camYaw   -= dx * sensitivity;
    camPitch += dy * sensitivity;
    camPitch = constrain(camPitch, -HALF_PI + 0.01, HALF_PI - 0.01);
  }
}

// -------- Returns the list of currently selected members --------
ArrayList<Member> getActiveSelection()
{
  ArrayList<Member> list = new ArrayList<Member>();
  if (selectedMembers.size() > 0)
  {
    list.addAll(selectedMembers);
  } 
  else if (selectedMember != null)
  {
    list.add(selectedMember);
  }
  return list;
}

// Scroll wheel zooms the camera forward/backward 
void mouseWheel(MouseEvent event)
{
  float e = event.getCount();

  // -------- forward/backward --------
  float cosP = cos(camPitch);
  float sinY = sin(camYaw);
  float cosY = cos(camYaw);
  PVector lookDir = new PVector(cosP * sinY, sin(camPitch), cosP * cosY);
  camPos.add(PVector.mult(lookDir, -e * 10.0));
}


//  -------- Maps data coordinates (0-1000) to 3D world space (-half +half) --------
// Screen coords (sx, sy, sz) for hover/click detection
// Draws selection/highlight,
// gender, and floating name labels
void drawMembers() 
{
  float half = gridSize / 2;
  float spin = millis() * 0.001;  
  for (Member m : members) 
  {
    float mx = map(m.x, 0, 1000, -half, half);
    float my = map(m.y, 0, 1000, half, -half);
    float mz = map(m.z, 0, 1000, -half, half);
    m.sx = screenX(mx, my, mz);
    m.sy = screenY(mx, my, mz);
    m.sz = screenZ(mx, my, mz);
    float shapeSize = m.getSize();
    color baseColor = m.getColor();

    boolean isSel = (m == selectedMember) || m.isSelected();
    if (isSel)
    {
      baseColor = color(min(red(baseColor)*1.5,255), min(green(baseColor)*1.5,255), min(blue(baseColor)*1.5,255));
    }
    
    color shapeColor = baseColor;

    if (showParticleTrails || m.group >= 5) 
    {
      if (frameCount % 2 == 0) 
      {
        m.trail.add(new PVector(mx, my, mz));
        if (m.trail.size() > 25) 
        {
          m.trail.remove(0);
        }
      }
      if (showParticleTrails && m.trail.size() > 1)
      {
        pushStyle(); 
        noFill();
        strokeWeight(1.5);
        beginShape();
        for (int i = 0; i < m.trail.size(); i++) 
        {
          PVector pt = m.trail.get(i);
          float alpha = map(i, 0, m.trail.size()-1, 0, 180);
          stroke(red(shapeColor), green(shapeColor), blue(shapeColor), alpha);
          vertex(pt.x, pt.y, pt.z);
        }
        endShape(); 
        popStyle();
      }
    }

    pushMatrix();
    translate(mx, my, mz);

    if (permanentHighlight.contains(m))
    {
      pushMatrix(); 
      rotateY(camYaw); 
      rotateX(camPitch);
      noFill();
      stroke(red(highlightColor), green(highlightColor), blue(highlightColor), 220);
      strokeWeight(3.5);
      ellipse(0, 0, shapeSize * 1.6, shapeSize * 1.6);
      stroke(red(highlightColor), green(highlightColor), blue(highlightColor), 60);
      strokeWeight(8);
      ellipse(0, 0, shapeSize * 1.8, shapeSize * 1.8);
      popMatrix();
    }

    if (isSel && !permanentHighlight.contains(m))
    {
      pushMatrix(); 
      rotateY(camYaw); 
      rotateX(camPitch);
      noFill();
      float pulse = 200 + 55 * sin(millis() * 0.008);
      stroke(255, 255, 180, pulse);
      strokeWeight(3.5);
      ellipse(0, 0, shapeSize * 1.5, shapeSize * 1.5);
      stroke(255, 255, 100, pulse * 0.3);
      strokeWeight(8);
      ellipse(0, 0, shapeSize * 1.7, shapeSize * 1.7);
      popMatrix();
    }

    pushMatrix();
    rotateX(m.objRotX); 
    rotateY(m.objRotY); 
    rotateZ(m.objRotZ);
    if (autoSpinOn) 
    {
      rotateY(spin);
    }
    if (m.spinActive) 
    {
      rotateY(spin);
    }
    if (m.isWireframe)
    {
      noFill(); 
      stroke(shapeColor); 
      strokeWeight(1.5);
    } 
    else 
    {
      fill(shapeColor); 
      if (m.isShapeOutline) 
      {
        stroke(0, 120); 
        strokeWeight(1.2);
      } 
      else
      {
        noStroke();
      }
    }
    PImage tex = null;
    if (showTextures && !m.isWireframe) 
    {
      if (m.pngTexIndex >= 0 && m.pngTexIndex < pngTexCount)
      {
        tex = pngTextures[m.pngTexIndex];  // Use PNG texture
      }
      else
      {
        tex = getActiveTexture(m.texIndex);  // Get selected texture
      }
    }
    if (tex != null)
    {
      tint(shapeColor);
    }
    drawShapeByGroup(groupShape[m.group], shapeSize, tex);  // Map group to shapeID
    if (tex != null) 
    {
      noTint();
    }
    popMatrix();

    if (showGenderBars) 
    {
      boolean drawGender = true;
      if (genderOnlySelected) 
      {
        drawGender = (m == selectedMember || m.isSelected());
      }
      if (drawGender)
      {
        if (m.genderDisplayMode == 0 || m.genderDisplayMode == 2)
        {
          drawGenderBar(m, shapeSize);
        }
        if (m.genderDisplayMode == 1 || m.genderDisplayMode == 2) 
        {
          drawGenderSymbol3D(m, shapeSize);
        }
      }
    }
    if (showLabels) 
    {
      drawMemberLabel(m, shapeSize);
    }
    popMatrix();
  }
}

// -------- Draws a small bar below member shape for gender --------
// Blue for Male, Pink for Female
void drawGenderBar(Member m, float shapeSize) 
{
  float barW = 4, barH = shapeSize * 0.8;
  fill(m.gender.equals("Male") ? color(60,160,255) : color(255,100,180));
  stroke(m.gender.equals("Male") ? color(60,160,255) : color(255,100,180));
  strokeWeight(0.5);
  pushMatrix();
  translate(0, shapeSize/2 + barH/2 + 2, 0);
  box(barW, barH, barW);
  popMatrix();
}

// -------- Draws a text label above a member showing name, level, and birth year --------
// -------- Uses rotateY/X + scale(-1,1,1) to always face the camera --------
void drawMemberLabel(Member m, float shapeSize) 
{
  pushMatrix();
  translate(0, -(shapeSize+15), 0);
  rotateY(camYaw); 
  rotateX(camPitch);
  scale(-1,1,1);
  fill(255,240); 
  noStroke();
  textSize(11); 
  textAlign(CENTER, BOTTOM);
  text(m.name, 0, 0);
  fill(200,200,200,180);
  textSize(9);
  text("Lvl:"+m.level+" | "+m.yearOfBirth, 0, 13);
  popMatrix();
}

// -------- Draws the 3D grid on floor, back wall, and left wall --------
// -------- Axis edges are colour: Red=X, Blue=Z, Green=Y --------
void drawFullGrid() 
{
  float half = gridSize/2;
  stroke(255,50); 
  strokeWeight(1);
  for (float i=-half; i<=half; i+=50) 
  {
    line(i,half,-half,i,half,half);
    line(-half,half,i,half,half,i);
    line(i,-half,-half,i,half,-half);
    line(-half,i,-half,half,i,-half);
    line(-half,-half,i,-half,half,i);
    line(-half,i,-half,-half,i,half);
  }
  stroke(255,120); 
  strokeWeight(3);
  for (float i=-half; i<=half; i+=200) 
  {
    line(i,half,-half,i,half,half);
    line(-half,half,i,half,half,i);
    line(i,-half,-half,i,half,-half);
    line(-half,i,-half,half,i,-half);
    line(-half,-half,i,-half,half,i);
    line(-half,i,-half,-half,i,half);
  }
  strokeWeight(5);
  stroke(255,80,80,220); line(-half,half,-half,half,half,-half); line(-half,half,half,half,half,half); line(-half,-half,-half,half,-half,-half);
  stroke(80,130,255,220); line(-half,half,-half,-half,half,half); line(half,half,-half,half,half,half); line(-half,-half,-half,-half,-half,half);
  stroke(80,255,80,220); line(-half,-half,-half,-half,half,-half); line(half,-half,-half,half,half,-half); line(-half,-half,half,-half,half,half);
}

// -------- Draws X, Y, Z axis labels and number --------

void drawAxisLabels() 
{
  float half = gridSize/2;
  textSize(22 * 3);
  pushMatrix(); 
  translate(half+80, half+10, -half); 
  rotateY(camYaw); 
  rotateX(camPitch); 
  scale(-1,1,1);
  fill(255,100,100); 
  noStroke();
  textAlign(CENTER, CENTER);
  text("X", 0, 0); 
  popMatrix();
  pushMatrix(); 
  translate(-half-80, -half, -half); 
  rotateY(camYaw); 
  rotateX(camPitch);
  scale(-1,1,1);
  fill(100,255,100); 
  text("Y", 0, 0);
  popMatrix();
  pushMatrix();
  translate(-half, half+10, half+80); 
  rotateY(camYaw); 
  rotateX(camPitch); 
  scale(-1,1,1);
  fill(100,150,255);
  text("Z", 0, 0);
  popMatrix();

  if (showTickLabels) 
  {
    fill(255); 
    textSize(13 * 3);
    for (float v=0; v<=1000; v+=100) 
    {
      float pos = map(v,0,1000,-half,half);
      float posFlip = map(v,0,1000,half,-half);
      drawTickLabel(int(v), pos, half+30, -half);
      drawTickLabel(int(v), -half-40, posFlip, -half);
      drawTickLabel(int(v), -half-40, half+10, pos);
    }
    fill(180);
    textSize(9 * 3);
    for (float v=0; v<=1000; v+=50) 
    {
      if (v%100==0) 
      {
        continue;
      }
      float pos = map(v,0,1000,-half,half);
      float posFlip = map(v,0,1000,half,-half);
      drawTickLabel(int(v), pos, half+20, -half);
      drawTickLabel(int(v), -half-30, posFlip, -half);
      drawTickLabel(int(v), -half-30, half+5, pos);
    }
  }
}

// -------- Draws a tick mark number --------
void drawTickLabel(int val, float tx, float ty, float tz) 
{
  pushMatrix(); 
  translate(tx, ty, tz); 
  rotateY(camYaw); 
  rotateX(camPitch); 
  scale(-1,1,1);
  noStroke(); 
  textAlign(CENTER, CENTER); 
  text(val, 0, 0);
  popMatrix();
}

// Show coloured shadow dots for each member on the floor (Y), back wall (Z),
// and left wall (X), with connecting lines
// Selected/highlighted members get shadows with highlight-coloured rings
void drawAllShadows() 
{
  noLights(); 
  float half = gridSize / 2;
  for (Member m : members) 
  {
    float mx = map(m.x, 0, 1000, -half, half);
    float my = map(m.y, 0, 1000, half, -half);
    float mz = map(m.z, 0, 1000, -half, half);
    float shapeSize = m.getSize();
    color shapeColor = m.getColor();
    boolean isSel = (m == selectedMember) || m.isSelected() || permanentHighlight.contains(m);
    if (isSel)
    {
      shapeColor = color(min(red(shapeColor)*1.5,255), min(green(shapeColor)*1.5,255), min(blue(shapeColor)*1.5,255));
    }

    float dotSize = max(8, shapeSize * 0.4);
    float shadowAlpha = isSel ? 220 : 80;
    float selMult = isSel ? 2.5 : 1.0;

    // Floor
    pushMatrix(); 
    translate(mx, half, mz); 
    rotateX(HALF_PI);
    noStroke(); 
    fill(red(shapeColor), green(shapeColor), blue(shapeColor), shadowAlpha);
    ellipse(0, 0, dotSize * selMult, dotSize * selMult);
    if (isSel) 
    {
      noFill();
      stroke(red(highlightColor), green(highlightColor), blue(highlightColor), 120);
      strokeWeight(2.5); 
      ellipse(0, 0, dotSize * selMult * 1.4, dotSize * selMult * 1.4);
      stroke(red(highlightColor), green(highlightColor), blue(highlightColor), 50);
      strokeWeight(5); 
      ellipse(0, 0, dotSize * selMult * 1.7, dotSize * selMult * 1.7);
    }
    popMatrix();

    // Back wall
    pushMatrix();
    translate(mx, my, -half);
    noStroke();
    fill(red(shapeColor), green(shapeColor), blue(shapeColor), shadowAlpha);
    ellipse(0, 0, dotSize * selMult, dotSize * selMult);
    if (isSel) 
    {
      noFill();
      stroke(red(highlightColor), green(highlightColor), blue(highlightColor), 120);
      strokeWeight(2); 
      ellipse(0, 0, dotSize * selMult * 1.3, dotSize * selMult * 1.3);
    }
    popMatrix();

    // Left wall
    pushMatrix(); 
    translate(-half, my, mz); 
    rotateY(HALF_PI);
    noStroke(); 
    fill(red(shapeColor), green(shapeColor), blue(shapeColor), shadowAlpha);
    ellipse(0, 0, dotSize * selMult, dotSize * selMult);
    if (isSel) 
    {
      noFill();
      stroke(red(highlightColor), green(highlightColor), blue(highlightColor), 120);
      strokeWeight(2); 
      ellipse(0, 0, dotSize * selMult * 1.3, dotSize * selMult * 1.3);
    }
    popMatrix();
  }
}

// -------- Draws tooltip --------
// Shows name, ID, year/colour, gender symbol, level , group shape ,
// XYZ position, rotation angles, and scale 
void drawTooltip(Member m, float tx, float ty)
{
  float tipX = tx + 20;
  float tipY = ty - 10;
  float tipW = 280;
  float tipH = 300;
  if (tipX + tipW > width - 10) 
  {
    tipX = tx - tipW - 20;
  }
  if (tipY + tipH > height - 10) 
  {
    tipY = height - tipH - 10;
  }
  if (tipY < 45) 
  {
    tipY = 45;
  }

  fill(14, 16, 30, 245);
  stroke(red(m.getColor()), green(m.getColor()), blue(m.getColor()), 200);
  strokeWeight(2.5);
  rect(tipX, tipY, tipW, tipH, 12);
  noStroke();
  fill(red(m.getColor()), green(m.getColor()), blue(m.getColor()), 50);
  rect(tipX + 1, tipY + 1, tipW - 2, 36, 12, 12, 0, 0);

  drawShapeIcon(groupShape[m.group], tipX + 12, tipY + 10);
  fill(255); 
  noStroke();
  textSize(16); 
  textAlign(LEFT, TOP);
  text(m.name, tipX + 34, tipY + 10);
  fill(255, 255, 255, 80); 
  textSize(10);
  text("ID: " + m.id, tipX + tipW - 50, tipY + 14);

  stroke(255, 80); 
  strokeWeight(1);
  line(tipX + 10, tipY + 36, tipX + tipW - 10, tipY + 36);
  float ry = tipY + 44;
  float lineH = 26;
  noStroke();

  fill(m.getColor()); 
  noStroke();
  rect(tipX + 12, ry, 16, 16, 4);
  stroke(255, 80); 
  strokeWeight(1); 
  rect(tipX + 12, ry, 16, 16, 4); 
  noStroke();
  fill(230); 
  textSize(13); 
  textAlign(LEFT, TOP);
  text("Colour / Year:  " + m.yearOfBirth, tipX + 34, ry + 1);
  ry += lineH;

  pushStyle();
  if (m.gender.equals("Male")) 
  {
    drawMaleSymbol(tipX + 20, ry + 8, 20);
  }
  else 
  {
    drawFemaleSymbol(tipX + 20, ry + 8, 20);
  }
  popStyle();
  fill(230); 
  textSize(13); 
  textAlign(LEFT, TOP);
  text("Gender:  " + m.gender, tipX + 34, ry + 1);
  fill(m.gender.equals("Male") ? color(60,160,255) : color(255,100,180));
  noStroke(); 
  rect(tipX + tipW - 40, ry + 3, 25, 12, 3);
  ry += lineH;

  fill(230); 
  textSize(13);
  text("Level:  " + m.level, tipX + 34, ry + 1);
  for (int i = 1; i <= 6; i++) 
  {
    fill(i <= m.level ? color(255, 200, 60) : color(50, 50, 65));
    noStroke(); 
    ellipse(tipX + 130 + i * 18, ry + 9, 12, 12);
    if (i <= m.level) 
    { 
      fill(255, 255, 200, 80);
      ellipse(tipX + 130 + i * 18, ry + 9, 16, 16); 
    }
  }
  ry += lineH;

  drawShapeIcon(groupShape[m.group], tipX + 12, ry);
  fill(230);
  textSize(13);
  textAlign(LEFT, TOP);
  text("Group:  G" + m.group, tipX + 34, ry + 1);
  ry += lineH + 4;

  stroke(100, 140, 200, 80); 
  strokeWeight(1);
  line(tipX + 10, ry, tipX + tipW - 10, ry);
  ry += 10;
  textSize(15); 
  noStroke();
  
  fill(255, 120, 120); 
  text("X: " + nf(m.x,1,1), tipX + 14, ry);
  
  fill(120, 255, 120); 
  text("Y: " + nf(m.y,1,1), tipX + 115, ry);
  
  fill(120, 160, 255); 
  text("Z: " + nf(m.z,1,1), tipX + 216, ry);
  
  ry += lineH + 6;
  textSize(15);
  fill(255, 180, 180);
  text("Rot X: " + nf(degrees(m.objRotX),1,1) + "\u00B0", tipX + 14, ry);
  ry += 24;
  fill(180, 255, 180);
  text("Rot Y: " + nf(degrees(m.objRotY),1,1) + "\u00B0", tipX + 14, ry);
  ry += 24;
  fill(180, 200, 255);
  text("Rot Z: " + nf(degrees(m.objRotZ),1,1) + "\u00B0", tipX + 14, ry);
  ry += lineH + 4;
  fill(200, 255, 200);
  textSize(16);
  text("Scale:  " + nf(m.scaleFactor, 1, 2) + "x", tipX + 14, ry);
}

// -------- saves all member to a text file --------
// Member format: ID|Name|X|Y|Z|YearOfBirth|Gender|Level|Group|TexIndex|
// RotX|RotY|RotZ|Scale|IsWireframe|SpinActive|OrigX|OrigY|OrigZ|OrigGender
void saveSceneFile(File selection) 
{
  if (selection == null) 
  {
    println("Save cancelled."); 
    return; 
  }
  String path = selection.getAbsolutePath();
  if (!path.endsWith(".txt")) 
  {
    path += ".txt";
  }
  PrintWriter pw = createWriter(path);

  // -------- Global settings --------
  pw.println("@levelMinSize=" + levelMinSize);
  pw.println("@levelMaxSize=" + levelMaxSize);
  pw.println("@groupShape=" + groupShape[0] + "," + groupShape[1] + "," + groupShape[2] + "," + groupShape[3] + "," + groupShape[4]);

  String yc = "";
  for (int i = 0; i < yearColors.length; i++) 
  {
    if (i > 0) 
    {
      yc += "|";
    }
    yc += int(red(yearColors[i])) + "," + int(green(yearColors[i])) + "," + int(blue(yearColors[i]));
  }
  pw.println("@yearColors=" + yc);

  pw.println("@genderDisplayMode=" + genderDisplayMode);
  pw.println("@genderOnlySelected=" + (genderOnlySelected ? "1" : "0"));
  pw.println("@showLabels=" + (showLabels ? "1" : "0"));
  pw.println("@showGrid=" + (showGrid ? "1" : "0"));
  pw.println("@showTextures=" + (showTextures ? "1" : "0"));
  pw.println("@textureModeState=" + textureModeState);
  pw.println("@showGenderBars=" + (showGenderBars ? "1" : "0"));
  pw.println("@showTickLabels=" + (showTickLabels ? "1" : "0"));
  pw.println("@autoSpinOn=" + (autoSpinOn ? "1" : "0"));
  pw.println("@showParticleTrails=" + (showParticleTrails ? "1" : "0"));
  pw.println("@camera=" + nf(camPos.x,1,2) + "," + nf(camPos.y,1,2) + "," + nf(camPos.z,1,2) + "," + nf(camYaw,1,4) + "," + nf(camPitch,1,4));
  pw.println("@highlightColor=" + int(red(highlightColor)) + "," + int(green(highlightColor)) + "," + int(blue(highlightColor)));
  pw.println("@lightPointOn=" + (lightPointOn ? "1" : "0"));
  pw.println("@lightSpotOn=" + (lightSpotOn ? "1" : "0"));
  pw.println("@lightSpecOn=" + (lightSpecOn ? "1" : "0"));
  pw.println("@lightAmbOn=" + (lightAmbOn ? "1" : "0"));
  pw.println("@lightDirOn=" + (lightDirOn ? "1" : "0"));
  pw.println("@texBlendMode=" + texBlendMode);

  pw.println("#---");
  pw.println("# Format: ID|Name|X|Y|Z|YearOfBirth|Gender|Level|Group|TexIndex|RotX|RotY|RotZ|Scale|IsWireframe|SpinActive|OrigX|OrigY|OrigZ|OrigGender|PngTexIndex");
  pw.println("#---");

  // -------- Member data --------
  for (Member m : members) 
  {
    pw.println(m.id + "|" + m.name + "|" + nf(m.x,1,2) + "|" + nf(m.y,1,2) + "|" + nf(m.z,1,2) + "|" +
               m.yearOfBirth + "|" + m.gender + "|" + m.level + "|" + m.group + "|" +
               m.texIndex + "|" + nf(m.objRotX,1,4) + "|" + nf(m.objRotY,1,4) + "|" + nf(m.objRotZ,1,4) + "|" +
               nf(m.scaleFactor,1,4) + "|" + (m.isWireframe?"1":"0") + "|" +
               (m.spinActive?"1":"0") + "|" + nf(m.origX,1,2) + "|" + nf(m.origY,1,2) + "|" + nf(m.origZ,1,2) + "|" +
               m.origGender + "|" + m.pngTexIndex);
  }
  pw.flush(); 
  pw.close();
  println("Scene saved to: " + path);
}

// -------- Loads data from the saved file --------
// -------- skips comment (#), loads global settings (@), and replaces the current members list --------
void loadSceneFile(File selection) 
{
  if (selection == null) 
  { 
    println("Load cancelled"); 
    return; 
  }
  String path = selection.getAbsolutePath();
  String[] lines = loadStrings(path);
  if (lines == null || lines.length == 0) 
  { 
    println("ERROR: Could not read file: " + path); 
    return; 
  }
  ArrayList<Member> loaded = new ArrayList<Member>();
  
  for (String line : lines) 
  {
    line = line.trim();
    if (line.startsWith("#") || line.length() == 0) 
    {
      continue;
    }
    
    // Parse global settings
    if (line.startsWith("@")) 
    {
      try 
      {
        int eqIdx = line.indexOf('=');
        if (eqIdx == -1) 
        {
          continue;
        }
        String key = line.substring(1, eqIdx);
        String val = line.substring(eqIdx + 1);
        
        if (key.equals("levelMinSize"))
        {
          levelMinSize = float(val);
        } 
        else if (key.equals("levelMaxSize"))
        {
          levelMaxSize = float(val);
        } 
        else if (key.equals("groupShape"))
        {
          String[] p = val.split(",");
          for (int i=0; i<min(5, p.length); i++) 
          {
            groupShape[i] = int(p[i]);
          }
        } 
        else if (key.equals("yearColors")) 
        {
          String[] p = val.split("\\|");
          for (int i=0; i<min(yearColors.length, p.length); i++) 
          {
            String[] c = p[i].split(",");
            if (c.length == 3) 
            {
              yearColors[i] = color(int(c[0]), int(c[1]), int(c[2]));
            }
          }
        }
        else if (key.equals("genderDisplayMode")) 
        {
          genderDisplayMode = int(val);
        } 
        else if (key.equals("genderOnlySelected"))
        {
          genderOnlySelected = val.equals("1");
        } 
        else if (key.equals("showLabels"))
        {
          showLabels = val.equals("1");
        }
        else if (key.equals("showGrid")) 
        {
          showGrid = val.equals("1");
        } 
        else if (key.equals("showTextures")) 
        {
          showTextures = val.equals("1");
        } 
        else if (key.equals("textureModeState")) 
        {
          textureModeState = int(val);
        } 
        else if (key.equals("showGenderBars"))
        {
          showGenderBars = val.equals("1");
        } 
        else if (key.equals("showTickLabels")) 
        {
          showTickLabels = val.equals("1");
        } 
        else if (key.equals("autoSpinOn")) 
        {
          autoSpinOn = val.equals("1");
        } 
        else if (key.equals("showParticleTrails"))
        {
          showParticleTrails = val.equals("1");
        } 
        else if (key.equals("camera")) 
        {
          String[] p = val.split(",");
          if (p.length == 5) 
          {
            camPos.x = float(p[0]); camPos.y = float(p[1]); camPos.z = float(p[2]);
            camYaw = float(p[3]); camPitch = float(p[4]);
          }
        } 
        else if (key.equals("highlightColor")) 
        {
          String[] c = val.split(",");
          if (c.length == 3)
          {
            highlightColor = color(int(c[0]), int(c[1]), int(c[2]));
          }
        }
        else if (key.equals("lightPointOn")) 
        {
          lightPointOn = val.equals("1");
        } 
        else if (key.equals("lightSpotOn")) 
        {
          lightSpotOn = val.equals("1");
        } 
        else if (key.equals("lightSpecOn")) 
        {
          lightSpecOn = val.equals("1");
        } 
        else if (key.equals("lightAmbOn")) 
        {
          lightAmbOn = val.equals("1");
        } 
        else if (key.equals("lightDirOn")) 
        {
          lightDirOn = val.equals("1");
        } 
        else if (key.equals("texBlendMode")) 
        {
          texBlendMode = int(val);
        }
      } 
      catch (Exception e) 
      {
        println(" Failed to parse setting: " + line);
      }
      continue;
    }
    
    // Parse member data
    String[] parts = line.split("\\|");
    if (parts.length < 13) 
    {
      continue;
    }
    try 
    {
      Member m = new Member();
      m.id = int(parts[0].trim()); 
      m.name = parts[1].trim();
      m.x = float(parts[2].trim());
      m.y = float(parts[3].trim());
      m.z = float(parts[4].trim());
      m.yearOfBirth = int(parts[5].trim());
      m.gender = parts[6].trim(); 
      m.origGender = m.gender;
      m.level = int(parts[7].trim());
      m.group = int(parts[8].trim());
      m.texIndex = int(parts[9].trim()); 
      m.objRotX = float(parts[10].trim());
      m.objRotY = float(parts[11].trim());
      m.objRotZ = float(parts[12].trim());
      
      if (parts.length >= 14) 
      {
        m.scaleFactor = float(parts[13].trim());
      }
      if (parts.length >= 15) 
      {
        m.isWireframe = parts[14].trim().equals("1");
      }
      if (parts.length >= 16)
      {
        m.spinActive = parts[15].trim().equals("1");
      }
      if (parts.length >= 19)
      {
        m.origX = float(parts[16].trim());
        m.origY = float(parts[17].trim());
        m.origZ = float(parts[18].trim());
      }
      if (parts.length >= 20)
      {
        m.origGender = parts[19].trim();
      }
      if (parts.length >= 21)
      {
        m.pngTexIndex = int(parts[20].trim());
      }
      loaded.add(m);
    }
    catch (Exception e) 
    { 
      println("Skipping malformed line: " + line); 
    }
  }
  
  if (loaded.size() > 0) 
  {
    members = loaded;
    selectedMember = null; 
    hoveredMember = null; 
    selectedMembers.clear();
    initShapePool(); 
  } 
}

// -------- Draws help instrustion --------
void drawHelpOverlay() 
{
  if (!showHelp) 
  {
    return;
  }
  fill(0, 0, 0, 200); 
  noStroke(); 
  rect(width/2 - 250, height/2 - 260, 500, 520, 15);
  fill(100, 200, 255); 
  textSize(18); 
  textAlign(CENTER, TOP); 
  text("KEYBOARD & MOUSE ", width/2, height/2 - 205);
  stroke(100, 200, 255, 100); 
  line(width/2 - 220, height/2 - 182, width/2 + 220, height/2 - 182);
  fill(255); 
  textSize(12); 
  textAlign(LEFT, TOP);
  float lx = width/2 - 220, ly = height/2 - 170, lh = 22;
  String[][] shortcuts = {
    {"W/A/S/D", "Move camera (Shift+W/S: up/down)"}, {"Mouse Drag", "Move selected shape / Rotate camera"},
    {"Scroll Wheel", "Zoom in/out"}, {"Shift + Click", "Multi select shapes"}, {"Ctrl + A", "Select all shapes"},
    {"X/Y/Z + Drag", "Moving shape on axis"}, {"Arrow Keys", "Rotate selected shape"}, {"< / >", "Roll shape (Z-axis)"},
    {"O / I", "Move shape forward/backward (Z)"}, {"+ / -", "Scale selected shape up/down"}, {"R", "Reset camera view"},
    {"P", "Save scene to file"}, {"L", "Load scene from file"}, {"H", "Open/Close help menu "}, {"B", "Take screenshot"}
  };
  for (int i = 0; i < shortcuts.length; i++) 
  {
    fill(100, 220, 255); 
    text(shortcuts[i][0], lx, ly + i * lh);
    fill(200); 
    text(shortcuts[i][1], lx + 160, ly + i * lh);
  }
  fill(150); 
  textSize(10); 
  textAlign(CENTER); 
  text("Press H to close", width/2, height/2 + 205);
}

// -------- Draws the highlight colour picker with 6 colour swatches --------
void drawHighlightPicker() 
{
  if (!highlightPickerOpen) 
  {
    return;
  }
  float px = toolbarX - 60;
  float py = toolbarY + 20 + 20 * (btnH + btnGap) + btnH + 8;
  fill(18, 22, 40, 245); 
  stroke(80, 120, 180); 
  strokeWeight(1.5);
  rect(px, py, btnW + 80, 60, 8);
  fill(200, 220, 255); 
  textSize(10); 
  textAlign(LEFT, TOP); 
  noStroke();
  text("HIGHLIGHT COLOUR", px + 8, py + 4);
  float swatchSize = 22;
  for (int i = 0; i < highlightPresets.length; i++) 
  {
    float sx = px + 8 + i * (swatchSize + 6);
    boolean isActive = (highlightColor == highlightPresets[i]);
    if (isActive) 
    { 
      stroke(255); 
      strokeWeight(2.5);
      fill(255, 255, 255, 40); 
      rect(sx - 2, py + 16, swatchSize + 4, swatchSize + 14, 5); 
    }
    fill(highlightPresets[i]); 
    if (!isActive) 
    { 
      stroke(100); 
      strokeWeight(1); 
    }
    rect(sx, py + 18, swatchSize, swatchSize, 5);
    fill(180); 
    noStroke(); 
    textSize(7); 
    textAlign(CENTER); 
    text(hlNames[i], sx + swatchSize/2, py + 42);
  }
}

// -------- Checks if a click at (mx,my) --------
// -------- Updates highlightColor if so and returns true --------
boolean checkHighlightPickerClick(int mx, int my) 
{
  if (!highlightPickerOpen) 
  {
    return false;
  }
  float px = toolbarX - 60;
  float py = toolbarY + 20 + 20 * (btnH + btnGap) + btnH + 8;
  float swatchSize = 22;
  for (int i = 0; i < highlightPresets.length; i++) 
  {
    float sx = px + 8 + i * (swatchSize + 6);
    if (mx >= sx && mx <= sx + swatchSize && my >= py + 18 && my <= py + 18 + swatchSize) 
    {
      highlightColor = highlightPresets[i]; return true;
    }
  }
  return false;
}

// -------- G e n e r a t e - F r a m e --------

void generateAnimFrames() 
{
  frameCache = new PImage[shapeCount][frame];
  for (int shapeIdx = 0; shapeIdx < shapeCount; shapeIdx++) 
  {
    for (int frames = 0; frames < frame; frames++) 
    {
      PImage img = createImage(24, 24, ARGB);
      img.loadPixels();
      float t = (float)frames / frame;
      for (int px = 0; px < 24; px++) 
      {
        for (int py = 0; py < 24; py++) 
        {
          float cx = 12, cy = 12;
          float dx = px - cx, dy = py - cy;
          float dist = sqrt(dx*dx + dy*dy);
          float ang = atan2(dy, dx);
          color pxColor = color(0, 0, 0, 0);
          switch(shapeIdx)
          {
            case 0: 
              float beat = 1.0 + 0.3 * sin(t * TWO_PI);
              if (dist < 8 * beat && dy < 4*beat) 
              {
                pxColor = color(255, 60 + 40*sin(t*TWO_PI), 100, 240);
              }
              break;
            case 1: 
              float fireH = 10 - dist + 3*sin(t*TWO_PI + px*0.3);
              if (dy > -6 && fireH > 0 && abs(dx) < 5 + 2*sin(t*TWO_PI+py*0.5))
              {
                pxColor = color(255, 180 - dist*8, 30, min(255, fireH * 40));
              }
              break;
            case 2: 
              if (abs(dy) < 3 && dist < 10) 
              {
                pxColor = color(180, 200, 230, 220);
              }
              if (abs(dy+2) < 4 && dist < 5) 
              {
                pxColor = color(200, 220, 255, 240);
              }
              break;
            case 3: 
              float gd = dist + (sin(t*TWO_PI*3+py*0.8) > 0.7 ? random(3) : 0);
              if (gd < 9) 
              {
                pxColor = color(160+40*sin(t*TWO_PI), 80, 255, 200);
              }
              break;
            case 4: 
              float strand1 = sin(t*TWO_PI + py * 0.5) * 4;
              float strand2 = -strand1;
              if (abs(dx - strand1) < 2 || abs(dx - strand2) < 2) 
              {
                pxColor = color(100, 200, 255, 230);
              }
              if (py % 4 == 0 && abs(dx) < abs(strand1)) 
              {
                pxColor = color(180, 200, 255, 150);
              }
              break;
            case 5: 
              if (dist < 9) 
              {
                pxColor = color(255, 200, 0, 240);
              }
              if (dist < 7) 
              {
                pxColor = color(255, 150, 0, 240);
              }
              break;
            case 6: 
              if (abs(dx) + abs(dy) < 10 + 2*sin(t*TWO_PI))
              {
                pxColor = color(180, 220, 255, 200+30*sin(t*TWO_PI*2+dist));
              }
              break;
            case 7: 
              float jBob = 2*sin(t*TWO_PI);
              if (dist < 8 && dy+jBob < 2)
              {
                pxColor = color(160, 200, 255, 180);
              }
              if (dy+jBob > 2 && abs(dx) < 6 && (px+frame)%3==0) 
              {
                pxColor = color(150, 180, 255, 120);
              }
              break;
            case 8: 
              if (dist < 5) 
              {
                pxColor = color(255, 200, 60, 230);
              }
              float wingSpread = abs(dx) * (1+0.3*sin(t*TWO_PI));
              if (abs(dy) < 3 && wingSpread < 11 && wingSpread > 3) 
              {
                pxColor = color(255, 150, 30, 180);
              }
              break;
            case 9: 
              float va = ang + t * TWO_PI * 2;
              float spiral = (va + dist * 0.3) % (TWO_PI/5);
              if (dist < 10 && spiral < 0.6)
              {
                pxColor = color(120+dist*10, 100, 255, 200);
              }
              break;
            case 10: 
              float torusR = 6, torusr2 = 2.5;
              float torusDist = sqrt(pow(sqrt(dx*dx + dy*dy) - torusR, 2));
              if (torusDist < torusr2 + sin(t * TWO_PI) * 0.5) 
              {
                pxColor = color(240, 200, 120, 220);
              }
              break;
            case 11: 
              float pyrH = 10 - abs(dx) * 0.8;
              if (dy > -pyrH + 4 && dy < 8 && abs(dx) < 8 - (dy + 4) * 0.4)
              {
                pxColor = color(220, 190 - dist*3, 100, 230);
              }
              if (dist < 2) 
              {
                pxColor = color(255, 220, 100, 200 + 55*sin(t*TWO_PI));
              }
              break;
            case 12: 
              float gearAng = atan2(dy, dx) + t * TWO_PI;
              float gearR = 7 + ((int)(gearAng / (TWO_PI/10)) % 2 == 0 ? 2 : 0);
              if (dist < gearR && dist > 2) 
              {
                pxColor = color(160, 170, 190, 220);
              }
              if (dist <= 2) 
              {
                pxColor = color(50, 55, 70, 240);
              }
              break;
          }
          img.pixels[py * 24 + px] = pxColor;
        }
      }
      img.updatePixels();
      frameCache[shapeIdx][frames] = img;
    }
  }
 
}

// -------- Draws gender symbol --------
void drawGenderSymbol3D(Member m, float shapeSize)
{
  pushMatrix();
  translate(0, shapeSize / 2 + 15, 0); 
  rotateY(camYaw); 
  rotateX(camPitch); 
  scale(-1, 1, 1);
  float symSize = min(shapeSize * 0.6, 20);
  if (m.gender.equals("Male")) 
  {
    drawMaleSymbol(0, 0, symSize);
  }
  else 
  {
    drawFemaleSymbol(0, 0, symSize);
  }
  popMatrix();
}

// -------- Draws blue male symbol --------
void drawMaleSymbol(float cx, float cy, float s) 
{
  noFill(); 
  stroke(60, 160, 255);
  strokeWeight(2);
  float r = s * 0.35; 
  ellipse(cx, cy, r * 2, r * 2);
  float ax = cx + r * cos(-PI/4), ay = cy + r * sin(-PI/4);
  float arrowLen = s * 0.35; float ex = ax + arrowLen * cos(-PI/4), ey = ay + arrowLen * sin(-PI/4);
  line(ax, ay, ex, ey);
  float ahl = arrowLen * 0.35;
  line(ex, ey, ex - ahl * cos(-PI/4 - 0.5), ey - ahl * sin(-PI/4 - 0.5));
  line(ex, ey, ex - ahl * cos(-PI/4 + 0.5), ey - ahl * sin(-PI/4 + 0.5));
}

// -------- Draws pink female symbol --------
void drawFemaleSymbol(float cx, float cy, float s) 
{
  noFill(); 
  stroke(255, 100, 180); 
  strokeWeight(2);
  float r = s * 0.35; 
  ellipse(cx, cy, r * 2, r * 2);
  float crossLen = s * 0.35; 
  line(cx, cy + r, cx, cy + r + crossLen);
  line(cx - crossLen * 0.4, cy + r + crossLen * 0.5, cx + crossLen * 0.4, cy + r + crossLen * 0.5);
}

// Keyboard shortcut handler. Maps keys to actions:
//   R=reset camera, P=save, L=load, H=help, G=cycle blend mode, B=screenshot,
//   X/Y/Z=set rotation axis, +/-=scale, Ctrl+A=select all
void keyPressed() 
{
  if (key=='r' || key=='R') 
  { 
    camPos.set(0,0,1200); 
    camYaw=PI; 
    camPitch=-0.3; 
  }
  if (key=='p' || key=='P') 
  {
    selectOutput("Save scene as:", "saveSceneFile");
  }
  if (key=='l' || key=='L') 
  {
    selectInput("Select a scene file to load:", "loadSceneFile");
  }
  if (key=='h' || key=='H') 
  {
    showHelp = !showHelp;
  }
  if (key=='b' || key=='B') 
  {
    String filename = "screenshot_" + nf(year(),4) + nf(month(),2) + nf(day(),2) + "_" + nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(filename); 
    println("Screenshot saved: " + filename);
  }
  if (key == 'x' || key == 'X') 
  {
    rotAxisKey = 'x';
  }
  if (key == 'y' || key == 'Y') 
  {
    rotAxisKey = 'y';
  }
  if (key == 'z' || key == 'Z') 
  {
    rotAxisKey = 'z';
  }
  if (key == '+' || key == '=') 
  { 
    for (Member t : getActiveSelection()) 
    {
      t.scaleFactor = constrain(t.scaleFactor + 0.1, 0.2, 5.0); 
    }
  }
  if (key == '-' || key == '_') 
  { 
    for (Member t : getActiveSelection()) 
    {
      t.scaleFactor = constrain(t.scaleFactor - 0.1, 0.2, 5.0); 
    }
  }
  if ((key == 1) || (keyCode == 65 && (keyPressed && (key == 1)))) 
  {
    selectedMembers.clear(); selectedMembers.addAll(members);
    if (members.size() > 0) 
    {
      selectedMember = members.get(0);
    }
  }
}

// Mouse click UI :
//   1 Legend arrows (year editor, group mapping, gender dropdown)
//   2 Legend controls (gender symbols, buttons, group shape )
//   3 Toolbar panel buttons
//   4 Member selection with Shift for multiple shape
void mousePressed() 
{
  // -------- Year colour arrow --------
  if (showLegendBox && dist(mouseX, mouseY, legendArrowX, legendArrowY) < 12) 
  {
    showYearColorEditor = !showYearColorEditor;
    return;
  }

  // -------- Group arrow --------
  if (showLegendBox && mouseX >= legendLx + 80 && mouseX <= legendLx + 100 && abs(mouseY - groupArrowY) < 10) 
  {
    groupMapOpen = !groupMapOpen;
    return;
  }

  // -------- Gender arrow --------
  if (showLegendBox && mouseX >= legendLx + 40 && mouseX <= legendLx + 60 && abs(mouseY - genderArrowY) < 10) 
  {
    genderDropdownOpen = !genderDropdownOpen;
    return;
  }

  // -------- Gender dropdown selection --------
  if (showLegendBox && genderDropdownOpen && genderDropdownStartY > 0) 
  {
    for (int i = 0; i < 4; i++) 
    {
      float by = genderDropdownStartY + 3 + i * 24;
      if (mouseX >= legendLx + 6 && mouseX <= legendLx + legendBoxW - 24 && mouseY >= by && mouseY <= by + 22) 
      {
        genderDisplayMode = i;
        // Apply to selected members if any, else all
        ArrayList<Member> targets = getActiveSelection();
        if (targets.size() > 0) 
        {
          for (Member m : targets) 
          {
            m.genderDisplayMode = i;
          }
        } else {
          for (Member m : members) 
          {
            m.genderDisplayMode = i;
          }
        }
        return;
      }
    }
  }

  // -------- Group click --------
  if (showLegendBox && groupMapOpen) 
  {
    if (handleGroupMapClick()) 
    {
      return;
    }
  }

  // -------- Year colour editor --------
  if (showYearColorEditor) 
  {
    float sliderX = legendLx + 60, sliderW = 100;
    float randBtnX = sliderX + sliderW + 40;
    for (int i=0; i<yearColors.length; i++) 
    {
      float rowY = legendSliderStartY + i*36;
      float randBtnY = rowY + 8;
      
      if (mouseX >= randBtnX && mouseX <= randBtnX+35 && mouseY >= randBtnY && mouseY <= randBtnY+14) 
      {
        yearColors[i] = color((int)random(255), (int)random(255), (int)random(255));
        return;
      }
      
      for (int ch=0; ch<3; ch++) 
      {
        float valY = rowY + ch*10 + 6;
        int val = (ch==0)? (int)red(yearColors[i]) : (ch==1)? (int)green(yearColors[i]) : (int)blue(yearColors[i]);
        float knobX = map(val, 0, 255, sliderX, sliderX+sliderW);
        if (dist(mouseX, mouseY, knobX, valY) < 10) 
        { 
          yearEditDrag = i*3 + ch; 
          return; 
        }
      }
    }
  }

  // -------- Highlight --------
  if (highlightPickerOpen && checkHighlightPickerClick(mouseX, mouseY)) 
  {
    return;
  }

  // -------- Gender symbol --------
  if (showLegendBox) 
  {
    // -------- Male symbol --------
    if (mouseX >= maleSymX && mouseX <= maleSymX+maleSymW && mouseY >= maleSymY && mouseY <= maleSymY+maleSymH) 
    {
      setSelectedGender("Male");
      return;
    }
    // -------- Female symbol --------
    if (mouseX >= femaleSymX && mouseX <= femaleSymX+femaleSymW && mouseY >= femaleSymY && mouseY <= femaleSymY+femaleSymH) 
    {
      setSelectedGender("Female");
      return;
    }
    // -------- Lighting toggle buttons --------
    if (mouseX >= lightPointBtnX && mouseX <= lightPointBtnX+lightBtnW && mouseY >= lightPointBtnY && mouseY <= lightPointBtnY+lightBtnH) 
    {
      lightPointOn = !lightPointOn;
      return;
    }
    if (mouseX >= lightSpotBtnX && mouseX <= lightSpotBtnX+lightBtnW && mouseY >= lightSpotBtnY && mouseY <= lightSpotBtnY+lightBtnH) 
    {
      lightSpotOn = !lightSpotOn;
      return;
    }
    if (mouseX >= lightSpecBtnX && mouseX <= lightSpecBtnX+lightBtnW && mouseY >= lightSpecBtnY && mouseY <= lightSpecBtnY+lightBtnH) 
    {
      lightSpecOn = !lightSpecOn;
      return;
    }
    if (mouseX >= lightAmbBtnX && mouseX <= lightAmbBtnX+lightBtnW && mouseY >= lightAmbBtnY && mouseY <= lightAmbBtnY+lightBtnH) 
    {
      lightAmbOn = !lightAmbOn;
      return;
    }
    if (mouseX >= lightDirBtnX && mouseX <= lightDirBtnX+lightBtnW && mouseY >= lightDirBtnY && mouseY <= lightDirBtnY+lightBtnH) 
    {
      lightDirOn = !lightDirOn;
      return;
    }
  }

  // -------- Panel toggles --------
  boolean uiClicked = false;
  if (showToolbarPanel) 
  {
    float ax = toolbarX-20, ay = toolbarY+30;
    if (mouseX>=ax-10 && mouseX<=ax+5 && mouseY>=ay-10 && mouseY<=ay+10) 
    { 
      showToolbarPanel=false; 
      uiClicked=true; 
    }
  } 
  else 
  {
    float ax = width-30, ay = toolbarY+30;
    if (mouseX>=ax-15 && mouseX<=ax+5 && mouseY>=ay-10 && mouseY<=ay+10) 
    { 
      showToolbarPanel=true; 
      uiClicked=true; 
    }
  }
  if (showLegendBox) 
  {
    float ax = legendLx + legendBoxW + 5, ay = legendLy + legendBoxH/2 - 10;
    if (mouseX>=ax-15 && mouseX<=ax+15 && mouseY>=ay-15 && mouseY<=ay+15) 
    { 
      showLegendBox=false; 
      uiClicked=true; 
    }
  } 
  else 
  {
    float ax = 25, ay = height-170;
    if (mouseX>=ax-15 && mouseX<=ax+15 && mouseY>=ay-15 && mouseY<=ay+15) 
    { 
      showLegendBox=true; 
      uiClicked=true; 
    }
  }
  if (showToolbarPanel && !uiClicked) 
  {
    if (checkToolbarClick(mouseX, mouseY)) 
    {
      uiClicked = true;
    }
  }

  if (!uiClicked) 
  {
    Member best = null;
    float minDist=80, minZ=Float.MAX_VALUE;
    float halfGrid = gridSize / 2;
    for (Member m : members) 
    {
      float mx = map(m.x, 0, 1000, -halfGrid, halfGrid);
      float my = map(m.y, 0, 1000, halfGrid, -halfGrid);
      float mz = map(m.z, 0, 1000, -halfGrid, halfGrid);
      if (dist(camPos.x, camPos.y, camPos.z, mx, my, mz) > 2000) 
      {
        continue;
      }
      float d = dist(mouseX, mouseY, m.sx, m.sy);
      if (d<minDist && m.sz<minZ) 
      { 
        minDist=d; 
        minZ=m.sz; 
        best=m; 
      }
    }
    if (keyPressed && keyCode == SHIFT && best != null) 
    {
      if (selectedMembers.size() == 0 && selectedMember != null && !selectedMembers.contains(selectedMember))
      {
        selectedMembers.add(selectedMember);
      }
      if (selectedMembers.contains(best) && selectedMembers.size() > 1) 
      {
        selectedMembers.remove(best);
      }
      else if (!selectedMembers.contains(best)) 
      {
        selectedMembers.add(best);
      }
      selectedMember = best;
    } 
    else
    {
      selectedMembers.clear();
      selectedMember = best;
    }
    cam.setActive(selectedMember==null && selectedMembers.size()==0);
  }
}

// Stops year colour slider drag when the mouse button is released
void mouseReleased() 
{
  yearEditDrag = -1;
}

// Gender functions
// Sets the gender of all selected members to the given value
void setSelectedGender(String newGender) 
{
  ArrayList<Member> targets = getActiveSelection();
  if (targets.size() == 0) 
  {
    return;
  }
  for (Member m : targets) 
  {
    m.gender = newGender;
  }
}

// Set every member gender 
void setAllGender(String newGender)
{
  for (Member m : members) 
  {
    m.gender = newGender;
  }
}

// Restore every member gender to the original value loaded from CSV
void resetAllGenders() 
{
  for (Member m : members) 
  {
    m.gender = m.origGender;
  }
}

// checks if an int array contains the given value (used by toolbar)
boolean contains(int[] arr, int val) 
{
  for (int v : arr) 
  {
    if (v == val) 
    {
      return true;
    }
  }
  return false;
}

PVector lightDir = new PVector(0.5, 0.5, 1).normalize();
color ambientColor = color(80);
color diffuseColor = color(180);
color specularColor = color(255);
PVector viewDir = new PVector(0, 0, 1).normalize();
void customLightFunction() 
{
  noLights();
  
  // --- Specular ---
  if (lightSpecOn) 
  {
    lightSpecular(230, 230, 255);
    shininess(25.0);
  } 
  else 
  {
    lightSpecular(0, 0, 0);
  }
  
  // --- Ambient ---
  if (lightAmbOn) 
  {
    // warm ambient from below, cool from above
    ambientLight(60, 55, 50);     // warm base
    ambientLight(30, 35, 50);     // cool fill 
  } 
  else 
  {
    ambientLight(12, 12, 15);     // near-dark fallback
  }
  
  // --- Directional ---
  if (lightDirOn) 
  {
    // Main light warm white from upper left front
    directionalLight(180, 170, 155, 0.4, 0.6, -0.7);
    // Subtle cool light from behind right for depth
    directionalLight(40, 45, 65, -0.3, -0.2, 0.5);
  }
  
  // --- Point ---
  if (lightPointOn) 
  {
    // warm point light above and in front
    pointLight(220, 200, 170, 200, -400, 600);
    // Subtle cool bounce point light from below
    pointLight(30, 40, 60, -100, 300, 200);
  }
  
  // --- Spot ---
  if (lightSpotOn) 
  {
    // Focused spot from upper front 
    spotLight(255, 245, 230,       // white color
              0, -300, 800,        // position above front
              0, 0.3, -1,          // direction angled down toward center
              PI/6, 4);            // narrow cone, sharp falloff
  }
}
