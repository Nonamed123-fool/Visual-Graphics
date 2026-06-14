// ==== T O O L B A R ====
// Draws the right-side control panel with buttons:
//   - RENDER MODE: Filled/Wireframe toggles
//   - VIEW TOGGLES: Labels, Gender bars, Grid on/off
//   - TEXTURES: Texture mode selection
//   - Save/Load: 
//   - TRANSFORMS: Spin, position reset, scale, highlight colour
//   - The top instruction bar 

boolean stateFilledWireAll = true;
boolean stateFilledWireSel = true;
boolean stateOutlineAll = false;
boolean stateOutlineSel = false;

void drawToolbar() 
{
  fill(18,20,32,230); 
  noStroke(); 
  rect(0,0,width,45);
  fill(255); 
  textSize(12); 
  textAlign(LEFT,CENTER);
  text("WASD:Move | Drag:XY | Shift+Click:Multi |I & O: Z| UP & DOWN arrow: Rotate Y | LEFT & RIGHT arrow: Rotate X | < & >: Rotate Z ", 20, 22);

  if (showToolbarPanel) 
  {
    float panelH = numButtons * (btnH + btnGap) + 190;
    fill(14,16,28,245); 
    stroke(60,80,120,150); 
    strokeWeight(1.5);
    rect(toolbarX - 20, toolbarY - 15, btnW + 40, panelH, 12);
    fill(200, 220, 255); 
    textSize(15); 
    textAlign(CENTER, TOP);
    text("CONTROLS", toolbarX + btnW/2, toolbarY - 5);
    stroke(60, 80, 120, 100); 
    line(toolbarX - 10, toolbarY + 15, toolbarX + btnW + 10, toolbarY + 15);

    // Button order: 0=Filled/Wire All, 1=Filled/Wire(Sel), 2=Shape Wire,
    //   3=Labels, 4=Grid, 5=Reset View,
    //   6=Textures, 7=Tex:Mixed, 8=Tex:Checker, 9=Tex:Stripes, 10=Tex:Noise,
    //   11=Tick Marks, 12=Save, 13=Load,
    //   14=Spin All, 15=Spin Shape, 16=Reset Position, 17=Highlight, 18=Scale+, 19=Scale-,
    //   20=Reset Scale, 21=Highlight Color

    

    boolean[] states = { 
      stateFilledWireAll, stateFilledWireSel, stateOutlineAll, stateOutlineSel, showLabels, showGrid, showTickLabels, false,
      showTextures, textureModeState==1, textureModeState==2, textureModeState==3, false,
      false, false, autoSpinOn, false, false, false, false, false, false, highlightPickerOpen
    };

    String pngLabel = "< PNG Texture >";
    if (getActiveSelection().size() > 0 && pngTexCount > 0) 
    {
       Member firstSel = getActiveSelection().get(0);
       if (firstSel.pngTexIndex >= 0 && firstSel.pngTexIndex < pngTexCount) 
       {
         pngLabel = "< " + pngTexNames[firstSel.pngTexIndex] + " >";
       } 
       else 
       {
         pngLabel = "< Procedural >";
       }
    } 
    else if (getActiveSelection().size() == 0) 
    {
       pngLabel = "< Select Shape >";
    }

    String[] labels = {"Filled/Wire All", "Filled/Wire (Selected)",
                       "Shape Outline All", "Shape Outline (Selected)",
                       showLabels?"Labels: ON":"Labels: OFF",
                       showGrid?"Grid: ON":"Grid: OFF",
                       showTickLabels?"Tick Marks: ON":"Tick Marks: OFF",
                       "Reset View",
                       showTextures?"Textures: ON":"Textures: OFF",
                       "Tex: Checker","Tex: Stripes","Tex: Noise",
                       pngLabel,
                       "Save Scene", "Load Scene",
                       autoSpinOn?"Spin All: ON":"Spin All: OFF",
                       "Spin Shape", "Reset Position", "Highlight", "Scale +", "Scale -",
                       "Reset Scale", "Highlight Color"};

    float curY = toolbarY + 45;
    for (int i=0; i<numButtons; i++)
    {
      if (i == 0) 
      { 
        fill(100, 150, 255); 
        textSize(10); 
        textAlign(LEFT, TOP); 
        text("RENDER MODE", toolbarX - 10, curY);
        curY += 16; 
      }
      else if (i == 4) 
      { 
        curY += 8; 
        fill(100, 150, 255); 
        textSize(10); 
        textAlign(LEFT, TOP); 
        text("VIEW TOGGLES", toolbarX - 10, curY); 
        curY += 16; 
      }
      else if (i == 8) 
      {
        curY += 8; 
        fill(100, 150, 255); 
        textSize(10); 
        textAlign(LEFT, TOP); 
        text("TEXTURES", toolbarX - 10, curY);
        curY += 16; 
      }
      else if (i == 13)  
      { 
        curY += 8; 
        fill(100, 150, 255); 
        textSize(10); 
        textAlign(LEFT, TOP); 
        text("Save/Load", toolbarX - 10, curY); 
        curY += 16; 
      }
      else if (i == 15)
      {
        curY += 8; 
        fill(100, 150, 255); 
        textSize(10); 
        textAlign(LEFT, TOP); 
        text("TRANSFORMS", toolbarX - 10, curY); 
        curY += 16; 
      }

      float bx = toolbarX, by = curY;
      boolean hover = mouseX>=bx && mouseX<=bx+btnW && mouseY>=by && mouseY<=by+btnH;

      // Action-only buttons (no on/off state) - blue style
      if (i==7 || i==12 || i==13 || i==14 || i==16 || i==17 || i==19 || i==20 || i==21 || i==22)
      {
        fill(hover?color(80,120,200):color(50,70,120), 220);
      } 
      else if (i == 18) 
      {
        fill(hover?color(180,100,200):color(140,60,160), 220);
      } 
      else 
      {
        // Toggle buttons green=ON, red=OFF
        if (states[i]) 
        {
          fill(hover?color(60,200,120):color(40,160,90), 220);
        }
        else 
        {
          fill(hover?color(220,80,80):color(180,60,60), 220);
        }
      }
      stroke(255, hover ? 150 : 40); 
      strokeWeight(1);
      rect(bx, by, btnW, btnH, 5);
      fill(255); 
      textSize(11); 
      textAlign(CENTER,CENTER);
      text(labels[i], bx+btnW/2, by+btnH/2 - 1);
      curY += btnH + btnGap;
    }
    stroke(60, 80, 120, 100);
    line(toolbarX - 10, curY + 5, toolbarX + btnW + 10, curY + 5);
    drawArrowButton(toolbarX-20, toolbarY+30, true);
  } 
  else
  {
    drawArrowButton(width-30, toolbarY+30, false);
  }
}

// Processes a mouse click at (mx, my) 
// Returns true if a button was clicked, false otherwise
boolean checkToolbarClick(int mx, int my) 
{
  float curY = toolbarY + 45;
  int[] extraBefore = {0, 4, 8, 13, 15};
  for (int i=0; i<numButtons; i++) 
  {
    if (contains(extraBefore, i))
    {
      if (i == 0) 
      {
        curY += 16;
      }
      else 
      {
        curY += 24;
      }
    }
    float bx = toolbarX, by = curY;
    if (mx>=bx && mx<=bx+btnW && my>=by && my<=by+btnH) 
    {
      switch(i) 
      {
        case 0: 
         // Filled/Wire All
         stateFilledWireAll = !stateFilledWireAll;
         for (Member m : members)
         {
           m.isWireframe = !stateFilledWireAll;
         }
         break;
         case 1: 
         // Filled/Wire (Selected)
         stateFilledWireSel = !stateFilledWireSel;
         for (Member m : getActiveSelection()) 
         {
           m.isWireframe = !stateFilledWireSel; 
         }
         break;
         case 2: 
         // Shape Outline All
         stateOutlineAll = !stateOutlineAll;
         for (Member m : members) 
         {
           m.isShapeOutline = stateOutlineAll;
         }
         break;
         case 3: 
         // Shape Outline (Selected)
         stateOutlineSel = !stateOutlineSel;
         for (Member m : getActiveSelection()) 
         {
           m.isShapeOutline = stateOutlineSel;
         }
         break;
         case 4: showLabels=!showLabels; break;
         case 5: showGrid=!showGrid; break;
         case 6: showTickLabels=!showTickLabels; break;
         case 7: camPos.set(0,0,1200); camYaw=PI; camPitch=-0.3f; worldRotX=0; worldRotY=0; worldRotZ=0; break;
         case 8: showTextures=!showTextures; break;
         case 9: 
           if (getActiveSelection().size() > 0) 
           {
             for (Member m : getActiveSelection())
             { 
               m.texIndex = 0;
               m.pngTexIndex = -1; 
             }
             textureModeState = 1;
           } 
           else 
           {
             textureModeState = 1;
             for (Member m : members) 
             {
               m.texIndex = 0; 
               m.pngTexIndex = -1; 
             }
           }
           break;
         case 10: 
           if (getActiveSelection().size() > 0) 
           {
             for (Member m : getActiveSelection()) 
             {
               m.texIndex = 1; 
               m.pngTexIndex = -1; 
             }
             textureModeState = 2;
           } 
           else 
           {
             textureModeState = 2;
             for (Member m : members) 
             { 
               m.texIndex = 1; 
               m.pngTexIndex = -1; 
             }
           }
           break;
         case 11: 
           if (getActiveSelection().size() > 0) 
           {
             for (Member m : getActiveSelection()) 
             { 
               m.texIndex = 2;
               m.pngTexIndex = -1; 
             }
             textureModeState = 3;
           } 
           else 
           {
             textureModeState = 3;
             for (Member m : members) 
             { 
               m.texIndex = 2; 
               m.pngTexIndex = -1; 
             }
           }
           break;
         case 12: 
           if (pngTexCount > 0 && getActiveSelection().size() > 0) 
           {
             boolean clickLeft = mx < bx + btnW/2;
             int dir = clickLeft ? -1 : 1;
             for (Member m : getActiveSelection()) 
             {
                 if (m.pngTexIndex == -1)
                 {
                     m.pngTexIndex = clickLeft ? pngTexCount - 1 : 0;
                 } 
                 else 
                 {
                     m.pngTexIndex = (m.pngTexIndex + dir + pngTexCount) % pngTexCount;
                 }
             }
           }
           break;
         case 13: selectOutput("Save scene as:", "saveSceneFile"); 
         break;
         case 14: selectInput("Select a scene file to load:", "loadSceneFile"); 
         break;
         case 15: autoSpinOn = !autoSpinOn; 
         break;
         case 16: 
         if (getActiveSelection().size() > 0) 
         {
           for (Member m : getActiveSelection()) 
           {
             m.spinActive = !m.spinActive; 
           }
         }
         else
         {
           for (Member m : members) 
           {
             m.spinActive = !m.spinActive; 
           }
         }
         break;
         case 17:
         if (getActiveSelection().size() > 0)
         {
           for (Member m : getActiveSelection()) 
           {
             m.x = m.origX; m.y = m.origY; m.z = m.origZ; 
           }
         }
         else
         {
           for (Member m : members) 
           {
             m.x = m.origX; m.y = m.origY; m.z = m.origZ; 
           }
         }
         break;
         case 18: 
         if (selectedMembers.size() > 0) 
         { 
           for (Member m : selectedMembers) 
           { 
             if (permanentHighlight.contains(m)) 
             { 
               permanentHighlight.remove(m);
             }
             else 
             {
               permanentHighlight.add(m);
             }
           } 
         }
         else if (selectedMember != null) 
         { 
            if (permanentHighlight.contains(selectedMember)) 
            {
               permanentHighlight.remove(selectedMember);
            }
            else 
            {
              permanentHighlight.add(selectedMember); 
            }
         } break;
         case 19:
         if (getActiveSelection().size() > 0)
         {
           for (Member m : getActiveSelection()) 
           {
             m.scaleFactor = min(5.0, m.scaleFactor + 0.04); 
           }
         }
         else
         {
           for (Member m : members) 
           {
             m.scaleFactor = min(5.0, m.scaleFactor + 0.04); 
           }
         }
         break;
         case 20: 
         if (getActiveSelection().size() > 0)
         {
           for (Member m : getActiveSelection()) m.scaleFactor = max(0.2, m.scaleFactor - 0.04);
         }
         else
         {
           for (Member m : members) m.scaleFactor = max(0.2, m.scaleFactor - 0.04);
         }
         break;
         case 21: 
         if (getActiveSelection().size() > 0)
         {
           for (Member m : getActiveSelection()) m.scaleFactor = 1.0;
         }
         else
         {
           for (Member m : members) m.scaleFactor = 1.0;
         }
         break;
         case 22: highlightPickerOpen = !highlightPickerOpen; break;
      }
      return true;
    }
    curY += btnH + btnGap;
  }
  return false;
}

// Draws a small triangle arrow used to hidde the toolbar and legend panel
// pointingRight=true draws >, pointingRight=false draws <
void drawArrowButton(float x, float y, boolean pointingRight)
{
  float size = 18;
  fill(255,255,255,200); 
  noStroke();
  if (pointingRight) 
  {
    triangle(x, y-size/2, x, y+size/2, x+size, y);
  }
  else 
  {
    triangle(x, y-size/2, x, y+size/2, x-size, y);
  }
}
