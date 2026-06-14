// ========================================================
// LEGEND & DROPDOWNS 
// ========================================================
// Draws the bottom-left legend panel:
//   - Year of Birth colour bar +  RGB editor
//   - Level (Size)
//   - Group (Shape) 
//   - Gender display with symbols 


void drawLegend()
{
  if (!showLegendBox) 
  { 
    drawArrowButton(25, height - 170, true); 
    return;
  }  // Hidden fuction just show  arrow

  legendLx = 25;
  legendBoxW = 260;
  float topGap = 10;
  float curY = 0;
  float startY = topGap + 8;

  float titleH = 22;
  float sectionTitleH = 16;
  float smallGap = 4;
  float medGap = 10;

  // Height calculation
  float neededHeight = startY;
  neededHeight += titleH + medGap;
  neededHeight += sectionTitleH;
  neededHeight += 14 + 18;
  neededHeight += medGap + 4;
  neededHeight += sectionTitleH;
  neededHeight += 30;
  if (levelScaleOpen) 
  {
    neededHeight += 130;
  }
  neededHeight += medGap + 4;
  neededHeight += sectionTitleH;
  neededHeight += 5 * 18 + 4;
  if (groupMapOpen) 
  {
    neededHeight += 5 * 26 + 20;
  }
  neededHeight += smallGap;
  neededHeight += sectionTitleH;
  neededHeight += 22;
  neededHeight += 20;
  neededHeight += 20;   // buttons row
  if (genderDropdownOpen) 
  {
    neededHeight += 4 * 20 + 12;
  }
  if (showYearColorEditor) 
  {
    neededHeight += (6 * 36) + 24 + 20;
  }
  neededHeight += 10 + 16 + 20 + 20; // lighting section
  neededHeight += 15;

  legendBoxH = max(220, neededHeight);
  legendLy = height - legendBoxH - 25;

  // -------- Background --------
  fill(30,30,45,235);
  stroke(255,60);
  strokeWeight(1.5);
  rect(legendLx-10, legendLy-10, legendBoxW, legendBoxH, 15);
  stroke(255,30);
  line(legendLx, legendLy+22, legendLx+legendBoxW-20, legendLy+22);

  fill(255);
  textSize(14); 
  textAlign(LEFT, TOP);
  text("LEGEND", legendLx, legendLy+8);

  curY = legendLy + startY + titleH + medGap;

  // ---------- Year of Birth ----------
  fill(220); textSize(11); text("Year of Birth", legendLx, curY);
  curY += 14;
  float barW = legendBoxW - 40, segW = barW/yearColors.length;
  for (int i=0; i<yearColors.length; i++) 
  {
    fill(yearColors[i]);
    noStroke();
    rect(legendLx + i*segW, curY, segW, 10);
  }
  fill(255,180); 
  textSize(9); 
  textAlign(CENTER);
  for (int i=0; i<yearColors.length; i++)
  {
    text(str(2000+i), legendLx + i*segW + segW/2, curY+20);
  }

  float arrowX = legendLx + legendBoxW - 30;
  float arrowY = curY + 5;
  legendArrowX = arrowX;
  legendArrowY = arrowY;
  drawSmallArrow(arrowX, arrowY, !showYearColorEditor);

  curY += 14 + 18 + smallGap + 4;

  // ---------- Level ----------
  float levelHeaderY = curY;
  fill(220); 
  textSize(11); 
  textAlign(LEFT);
  text("Level (Size)", legendLx, curY);
  if (mousePressed && mouseX >= legendLx && mouseX <= legendLx+textWidth("Level (Size)") &&
      mouseY >= levelHeaderY && mouseY <= levelHeaderY+12) 
  {
    levelScaleOpen = !levelScaleOpen;
    delay(100);
  }
  curY += 14;
  for (int i=1; i<=6; i++) 
  {
    float s = map(i,1,6,8,20);
    fill(180,180,210); 
    noStroke();
    ellipse(legendLx + (i-1)*38 + 12, curY + 8, s, s);
  }
  fill(255,180);
  textSize(9); 
  textAlign(CENTER);
  for (int i=1; i<=6; i++)
  {
    text(str(i), legendLx + (i-1)*38 + 12, curY + 30);
  }
  curY += 36 + smallGap + 4;

  // -------- Scale --------
  if (levelScaleOpen)
  {
  
    fill(20,25,40,230); 
    noStroke();
    rect(legendLx, curY, legendBoxW-30, 85, 5);
    fill(200,220,255); 
    textSize(10); 
    textAlign(LEFT);
    text("Rescale Level " + selectedLevelRescale + "  |  Group " + selectedLevelGroup, legendLx+5, curY+12);
    fill(80,100,180); 
    rect(legendLx+5, curY+22, 22, 14, 3);
    fill(255); 
    textSize(9);
    textAlign(CENTER); 
    text("-", legendLx+16, curY+31);
    if (mousePressed && mouseX>=legendLx+5 && mouseX<=legendLx+27 && mouseY>=curY+22 && mouseY<=curY+36)
    {
      for (Member m : members) 
      {
        if (m.level == selectedLevelRescale && (selectedLevelGroup == -1 || m.group == selectedLevelGroup)) 
        {
          m.scaleFactor = max(0.2, m.scaleFactor - 0.1);
        }
      }
      delay(100);
    }
    fill(80,100,180); 
    rect(legendLx+35, curY+22, 22, 14, 3);
    fill(255); 
    text("+", legendLx+46, curY+31);
    if (mousePressed && mouseX>=legendLx+35 && mouseX<=legendLx+57 && mouseY>=curY+22 && mouseY<=curY+36)
    {
      for (Member m : members) 
      {
        if (m.level == selectedLevelRescale && (selectedLevelGroup == -1 || m.group == selectedLevelGroup)) 
        {
          m.scaleFactor = min(5.0, m.scaleFactor + 0.1);
        }
      }
      delay(100);
    }
    fill(80,100,180); 
    rect(legendLx+65, curY+22, 35, 14, 3);
    fill(255); 
    text("Reset", legendLx+82.5, curY+31);
    if (mousePressed && mouseX>=legendLx+65 && mouseX<=legendLx+100 && mouseY>=curY+22 && mouseY<=curY+36) 
    {
      for (Member m : members) 
      {
        if (m.level == selectedLevelRescale && (selectedLevelGroup == -1 || m.group == selectedLevelGroup)) 
        {
          m.scaleFactor = 1.0;
        }
      }
      delay(100);
    }
    fill(100,120,180); 
    rect(legendLx+120, curY+8, 12, 12, 2);
    fill(255); 
    text("<", legendLx+126, curY+17);
    if (mousePressed && mouseX>=legendLx+120 && mouseX<=legendLx+132 && mouseY>=curY+8 && mouseY<=curY+20) 
    {
      selectedLevelRescale = max(1, selectedLevelRescale-1);
      delay(100);
    }
    fill(100,120,180);
    rect(legendLx+138, curY+8, 12, 12, 2);
    fill(255);
    text(">", legendLx+144, curY+17);
    if (mousePressed && mouseX>=legendLx+138 && mouseX<=legendLx+150 && mouseY>=curY+8 && mouseY<=curY+20) 
    {
      selectedLevelRescale = min(6, selectedLevelRescale+1);
      delay(100);
    }

    // Group selector row
    float groupRowY = curY + 45;
    fill(200,220,255); 
    textSize(10); 
    textAlign(LEFT);
    text("Group:", legendLx+5, groupRowY+10);

    // "All" button
    boolean allActive = (selectedLevelGroup == -1);
    fill(allActive ? color(50,140,80,200) : color(50,70,120));
    noStroke();
    rect(legendLx+45, groupRowY+2, 28, 14, 3);
    fill(255); 
    textSize(8); 
    textAlign(CENTER, CENTER);
    text("All", legendLx+59, groupRowY+9);
    if (mousePressed && mouseX>=legendLx+45 && mouseX<=legendLx+73 && mouseY>=groupRowY+2 && mouseY<=groupRowY+16)
    {
      selectedLevelGroup = -1;
      delay(100);
    }

    // G0-G4 buttons
    for (int g = 0; g < 5; g++)
    {
      float gx = legendLx + 78 + g * 28;
      boolean gActive = (selectedLevelGroup == g);
      fill(gActive ? color(50,140,80,200) : color(50,70,120));
      noStroke();
      rect(gx, groupRowY+2, 24, 14, 3);
      fill(255); 
      textSize(8); 
      textAlign(CENTER, CENTER);
      text("G" + g, gx+12, groupRowY+9);
      if (mousePressed && mouseX>=gx && mouseX<=gx+24 && mouseY>=groupRowY+2 && mouseY<=groupRowY+16)
      {
        selectedLevelGroup = g;
        delay(100);
      }
    }

    // Global Base Size Ranges
    fill(200,220,255); 
    text("Base Size Min: " + nf(levelMinSize,1,1), legendLx+5, curY+65);
    fill(80,100,180); 
    rect(legendLx+5, curY+75, 22, 14, 3);
    fill(255); 
    text("-", legendLx+16, curY+84);
    if (mousePressed && mouseX>=legendLx+5 && mouseX<=legendLx+27 && mouseY>=curY+75 && mouseY<=curY+89) 
    {
      levelMinSize = max(5, levelMinSize - 0.5); delay(50);
    }
    fill(80,100,180); 
    rect(legendLx+35, curY+75, 22, 14, 3);
    fill(255); 
    text("+", legendLx+46, curY+84);
    if (mousePressed && mouseX>=legendLx+35 && mouseX<=legendLx+57 && mouseY>=curY+75 && mouseY<=curY+89) 
    {
      levelMinSize = min(levelMaxSize, levelMinSize + 0.5); delay(50);
    }
    
    fill(200,220,255); 
    text("Base Size Max: " + nf(levelMaxSize,1,1), legendLx+70, curY+65);
    fill(80,100,180); 
    rect(legendLx+70, curY+75, 22, 14, 3);
    fill(255); 
    text("-", legendLx+81, curY+84);
    if (mousePressed && mouseX>=legendLx+70 && mouseX<=legendLx+92 && mouseY>=curY+75 && mouseY<=curY+89) 
    {
      levelMaxSize = max(levelMinSize, levelMaxSize - 0.5); delay(50);
    }
    fill(80,100,180); 
    rect(legendLx+100, curY+75, 22, 14, 3);
    fill(255);
    text("+", legendLx+111, curY+84);
    if (mousePressed && mouseX>=legendLx+100 && mouseX<=legendLx+122 && mouseY>=curY+75 && mouseY<=curY+89) 
    {
      levelMaxSize = min(200, levelMaxSize + 0.5); delay(50);
    }

    curY += 130;
  }

  // ---------- Group ----------
  curY += 10;
  fill(220); 
  textSize(11); 
  textAlign(LEFT);
  text("Group (Shape)", legendLx, curY);
  groupArrowY = curY - 4;
  drawSmallArrow(legendLx + 90, groupArrowY, !groupMapOpen);
  curY += 8;

  for (int g = 0; g < 5; g++) 
  {
    groupItemYs[g] = curY;
    int shapeId = groupShape[g];
    drawShapeIcon(shapeId, legendLx + 2, curY);
    fill(190,190,220); 
    textSize(10);
    textAlign(LEFT);
    text("G" + g, legendLx + 22, curY + 10);
    curY += 18;
  }

  if (groupMapOpen) 
  {  // Shape editor with <, >, and Reset buttons per group
    stroke(100, 200, 255, 60); 
    strokeWeight(1);
    line(legendLx, curY + 2, legendLx + legendBoxW - 40, curY + 2);
    noStroke();
    fill(100, 200, 255, 200); 
    textSize(10); 
    textAlign(LEFT);
    text("Shape ", legendLx + 2, curY + 8);
    
    groupResetBtnY = curY + 2;
    fill(120, 120, 120, 200);
    rect(legendLx + legendBoxW - 85, groupResetBtnY, 35, 14, 3);
    fill(255); 
    textSize(9); 
    textAlign(CENTER, CENTER);
    text("Reset All", legendLx + legendBoxW - 67.5, groupResetBtnY + 7);

    curY += 18;

    for (int g = 0; g < 5; g++)
    {
      float rowX = legendLx + 2;
      float rowY = curY;
      boolean hoverLeft  = mouseX >= rowX && mouseX <= rowX+14 && mouseY >= rowY && mouseY <= rowY+22;
      boolean hoverRight = mouseX >= rowX+legendBoxW-68 && mouseX <= rowX+legendBoxW-54 && mouseY >= rowY && mouseY <= rowY+22;
      boolean hoverReset = mouseX >= rowX+legendBoxW-50 && mouseX <= rowX+legendBoxW-25 && mouseY >= rowY && mouseY <= rowY+22;

      fill(40, 45, 70, 220); 
      noStroke();
      rect(rowX, rowY, legendBoxW - 22, 22, 3);

      fill(hoverLeft ? color(80,120,200) : color(50,70,120));
      rect(rowX, rowY+2, 14, 18, 2);
      fill(255); 
      textSize(9);
      textAlign(CENTER, CENTER);
      text("<", rowX+7, rowY+11);

      fill(200,220,255); 
      textSize(10); 
      textAlign(LEFT);
      text("G" + g, rowX+18, rowY+15);
      drawShapeIcon(groupShape[g], rowX+42, rowY+4);

      fill(hoverRight ? color(80,120,200) : color(50,70,120));
      rect(rowX+legendBoxW-68, rowY+2, 14, 18, 2);
      fill(255);
      textSize(9);
      textAlign(CENTER, CENTER);
      text(">", rowX+legendBoxW-61, rowY+11);
      
      fill(hoverReset ? color(180,80,80) : color(120,50,50));
      rect(rowX+legendBoxW-50, rowY+2, 25, 18, 2);
      fill(255); 
      textSize(9); 
      textAlign(CENTER, CENTER);
      text("Rst", rowX+legendBoxW-37.5, rowY+11);

      groupItemYs[g] = rowY;
      curY += 24;
    }
    curY += 8;
  }

  // ---------- Gender ----------
  curY += 10;
  fill(220); 
  textSize(11); 
  textAlign(LEFT);
  text("Gender", legendLx, curY);
  genderArrowY = curY - 4;
  drawSmallArrow(legendLx + 50, genderArrowY, !genderDropdownOpen);
  curY += 12;

  // --- Male button ---
  maleSymX = legendLx + 6;
  maleSymY = curY;
  maleSymW = 110;
  maleSymH = 26;
  boolean maleHover = mouseX >= maleSymX && mouseX <= maleSymX+maleSymW && mouseY >= maleSymY && mouseY <= maleSymY+maleSymH;
  // Pill background with glow
  if (maleHover) 
  {
    noStroke();
    fill(60, 140, 255, 30);
    rect(maleSymX-2, maleSymY-2, maleSymW+4, maleSymH+4, 15);
  }
  fill(maleHover ? color(50, 100, 180, 220) : color(35, 60, 120, 200));
  stroke(80, 140, 255, maleHover ? 200 : 100);
  strokeWeight(1);
  rect(maleSymX, maleSymY, maleSymW, maleSymH, 13);
  noStroke();
  noStroke();
  fill(200, 220, 255);
  textSize(10);
  textAlign(CENTER, CENTER);
  text("Male", maleSymX + maleSymW/2, maleSymY + maleSymH/2);

  // --- Female button ---
  femaleSymX = legendLx + 6 + maleSymW + 8;
  femaleSymY = curY;
  femaleSymW = 110;
  femaleSymH = 26;
  boolean femaleHover = mouseX >= femaleSymX && mouseX <= femaleSymX+femaleSymW && mouseY >= femaleSymY && mouseY <= femaleSymY+femaleSymH;
  if (femaleHover) 
  {
    noStroke();
    fill(255, 100, 180, 30);
    rect(femaleSymX-2, femaleSymY-2, femaleSymW+4, femaleSymH+4, 15);
  }
  fill(femaleHover ? color(160, 50, 100, 220) : color(120, 35, 75, 200));
  stroke(255, 100, 180, femaleHover ? 200 : 100);
  strokeWeight(1);
  rect(femaleSymX, femaleSymY, femaleSymW, femaleSymH, 13);
  noStroke();
  noStroke();
  fill(255, 200, 230);
  textSize(10);
  textAlign(CENTER, CENTER);
  text("Female", femaleSymX + femaleSymW/2, femaleSymY + femaleSymH/2);

  curY += 32;

  //  Gender dropdown for selection mode
  if (genderDropdownOpen)
  {
    genderDropdownStartY = curY;
    fill(30, 33, 50, 245); 
    stroke(70, 70, 110, 180); 
    strokeWeight(1);
    rect(legendLx + 6, curY, legendBoxW - 30, 4 * 24 + 6, 8);
    noStroke();
    for (int i = 0; i < 4; i++) 
    {
      float by = curY + 3 + i * 24;
      boolean isActive = (genderDisplayMode == i);
      boolean isHover = mouseX >= legendLx + 6 && mouseX <= legendLx + legendBoxW - 24 && mouseY >= by && mouseY <= by + 22;
      
      if (isActive) 
      {
        fill(40, 130, 90, 220);
      } 
      else if (isHover) 
      {
        fill(55, 65, 95, 220);
      } 
      else 
      {
        fill(38, 40, 58, 200);
      }
      rect(legendLx + 9, by, legendBoxW - 36, 22, 6);
      // Active check mark
      if (isActive) 
      {
        fill(140, 255, 180);
        textSize(11);
        textAlign(LEFT, CENTER);
        text("\u2713", legendLx + 14, by + 11);
      }
      fill(isActive ? color(200, 255, 220) : color(210, 210, 230)); 
      textSize(10); 
      textAlign(LEFT, CENTER);
      text(genderModeLabels[i], legendLx + (isActive ? 28 : 18), by + 11);
    }
    // Show target indicator
    float labelY = curY + 3 + 4 * 24;
    fill(180, 180, 220, 180);
    textSize(8);
    textAlign(LEFT, CENTER);
    if (getActiveSelection().size() > 0) 
    {
      text("Applies to: Selected (" + getActiveSelection().size() + ")", legendLx + 12, labelY);
    } 
    else 
    {
      text("Applies to: All", legendLx + 12, labelY);
    }
    curY += 4 * 24 + 20;
  } 
  else
  {
    genderDropdownStartY = -1;
  }
  curY += smallGap;

  // ---------- Year colour editor ----------
  if (showYearColorEditor) 
  {
    legendSliderStartY = curY;
    for (int i=0; i<yearColors.length; i++) 
    {
      float rowY = curY + i*36;
      fill(255); textSize(9); 
      textAlign(LEFT, CENTER);
      text(str(2000+i), legendLx+2, rowY+18);
      fill(yearColors[i]);
      noStroke();
      rect(legendLx+30, rowY+6, 16, 14, 2);

      float sliderX = legendLx+60;
      float sliderW = 100;
      for (int ch=0; ch<3; ch++)
      {
        float valY = rowY + ch*10 + 6;
        int val = (ch==0)? (int)red(yearColors[i]) : (ch==1)? (int)green(yearColors[i]) : (int)blue(yearColors[i]);
        color trackColor = (ch==0) ? color(255,80,80) : (ch==1) ? color(80,255,80) : color(80,80,255);
        stroke(trackColor, 220); 
        strokeWeight(2);
        line(sliderX, valY, sliderX+sliderW, valY);
        float knobX = map(val, 0, 255, sliderX, sliderX+sliderW);
        noStroke(); 
        fill(255,230);
        ellipse(knobX, valY, 10, 10);
        fill(255,230); 
        textSize(8);
        textAlign(LEFT, CENTER);
        text((ch==0?"R":ch==1?"G":"B") + " " + val, sliderX+sliderW + 8, valY);
      }
      
      
      float randBtnX = sliderX + sliderW + 40;
      float randBtnY = rowY + 8;
      fill(100, 150, 200); 
      rect(randBtnX, randBtnY, 35, 14, 2);
      fill(255); 
      textSize(8); 
      textAlign(CENTER, CENTER); 
      text("Rand", randBtnX+17.5, randBtnY+7);
    }
    curY += yearColors.length * 36;

    fill(80,100,160);
    rect(legendLx, curY, 60, 15, 3);
    fill(255); 
    textSize(9); 
    textAlign(CENTER, CENTER); 
    text("Random All", legendLx+30, curY+7.5);
    if (mouseX>=legendLx && mouseX<=legendLx+60 && mouseY>=curY && mouseY<=curY+15 && mousePressed) 
    {
      for (int i=0; i<yearColors.length; i++)
      {
        yearColors[i] = color((int)random(255), (int)random(255), (int)random(255));
      }
      delay(150);
    }

    fill(160,80,80); 
    rect(legendLx+70, curY, 60, 15, 3);
    fill(255); 
    text("Defaults", legendLx+100, curY+7.5);
    if (mouseX>=legendLx+70 && mouseX<=legendLx+130 && mouseY>=curY && mouseY<=curY+15 && mousePressed) 
    {
      yearColors = new color[] {
        color(60,130,240), color(80,200,200), color(100,220,100),
        color(240,220,60), color(240,150,50), color(240,70,70)
      };
      delay(150);
    }
    curY += 24;

    fill(255); 
    textSize(9); 
    textAlign(LEFT); 
    text("Presets:", legendLx, curY+8);
    color[] presets = {
      color(255,0,0), color(0,255,0), color(0,0,255),
      color(255,255,0), color(255,0,255), color(0,255,255)
    };
    float px = legendLx + 60;
    for (int i=0; i<presets.length; i++) 
    {
      fill(presets[i]);
      noStroke(); 
      rect(px, curY, 12, 12, 2);
      if (mouseX>=px && mouseX<=px+12 && mouseY>=curY && mouseY<=curY+12 && mousePressed)
      {
        for (int j=0; j<yearColors.length; j++) 
        {
          yearColors[j] = presets[i];
        }
        delay(150);
      }
      px += 16;
    }
    curY += 20;
  }

  // ---------- Lighting ----------
  curY += 10;
  fill(220); 
  textSize(11); 
  textAlign(LEFT);
  text("Lighting", legendLx, curY);
  curY += 14;
  
  float lbW = 72;  
  float lbH = 22;  
  float lbGap = 6;
  
  // ---- Row 1: Point, Spot, Specular ----
  // Point Light button
  lightPointBtnX = legendLx + 6;
  lightPointBtnY = curY;
  boolean ptHover = mouseX >= lightPointBtnX && mouseX <= lightPointBtnX+lbW && mouseY >= lightPointBtnY && mouseY <= lightPointBtnY+lbH;
  if (ptHover) 
  {
    noStroke(); 
    fill(lightPointOn ? color(60,200,120,30) : color(200,60,60,30)); 
    rect(lightPointBtnX-1, lightPointBtnY-1, lbW+2, lbH+2, 12); 
  }
  fill(lightPointOn ? color(40, 120, 75, 230) : color(70, 40, 45, 220));
  stroke(lightPointOn ? color(80, 200, 130, ptHover?220:140) : color(180, 70, 70, ptHover?180:100));
  strokeWeight(1);
  rect(lightPointBtnX, lightPointBtnY, lbW, lbH, 11);
  noStroke();
  fill(lightPointOn ? color(220,255,230) : color(170,150,150));
  textSize(9); 
  textAlign(CENTER, CENTER);
  text("Point", lightPointBtnX + lbW/2, lightPointBtnY + lbH/2);
  
  // Spot Light button
  lightSpotBtnX = lightPointBtnX + lbW + lbGap;
  lightSpotBtnY = curY;
  boolean spHover = mouseX >= lightSpotBtnX && mouseX <= lightSpotBtnX+lbW && mouseY >= lightSpotBtnY && mouseY <= lightSpotBtnY+lbH;
  if (spHover) 
  { 
    noStroke(); 
    fill(lightSpotOn ? color(60,200,120,30) : color(200,60,60,30)); 
    rect(lightSpotBtnX-1, lightSpotBtnY-1, lbW+2, lbH+2, 12); 
  }
  fill(lightSpotOn ? color(40, 120, 75, 230) : color(70, 40, 45, 220));
  stroke(lightSpotOn ? color(80, 200, 130, spHover?220:140) : color(180, 70, 70, spHover?180:100));
  strokeWeight(1);
  rect(lightSpotBtnX, lightSpotBtnY, lbW, lbH, 11);
  noStroke();
  fill(lightSpotOn ? color(220,255,230) : color(170,150,150));
  textSize(9); textAlign(CENTER, CENTER);
  text("Spot", lightSpotBtnX + lbW/2, lightSpotBtnY + lbH/2);
  
  // Specular Light button
  lightSpecBtnX = lightSpotBtnX + lbW + lbGap;
  lightSpecBtnY = curY;
  boolean scHover = mouseX >= lightSpecBtnX && mouseX <= lightSpecBtnX+lbW && mouseY >= lightSpecBtnY && mouseY <= lightSpecBtnY+lbH;
  if (scHover) 
  { 
    noStroke(); 
    fill(lightSpecOn ? color(60,200,120,30) : color(200,60,60,30)); 
    rect(lightSpecBtnX-1, lightSpecBtnY-1, lbW+2, lbH+2, 12); 
  }
  fill(lightSpecOn ? color(40, 120, 75, 230) : color(70, 40, 45, 220));
  stroke(lightSpecOn ? color(80, 200, 130, scHover?220:140) : color(180, 70, 70, scHover?180:100));
  strokeWeight(1);
  rect(lightSpecBtnX, lightSpecBtnY, lbW, lbH, 11);
  noStroke();
  fill(lightSpecOn ? color(220,255,230) : color(170,150,150));
  textSize(9); 
  textAlign(CENTER, CENTER);
  text("Specular", lightSpecBtnX + lbW/2, lightSpecBtnY + lbH/2);
  
  curY += lbH + 5;
  
  // ---- Row 2: Ambient, Directional ----
  // Ambient Light button
  lightAmbBtnX = legendLx + 6;
  lightAmbBtnY = curY;
  boolean amHover = mouseX >= lightAmbBtnX && mouseX <= lightAmbBtnX+lbW && mouseY >= lightAmbBtnY && mouseY <= lightAmbBtnY+lbH;
  if (amHover) 
  { 
    noStroke(); 
    fill(lightAmbOn ? color(60,200,120,30) : color(200,60,60,30)); 
    rect(lightAmbBtnX-1, lightAmbBtnY-1, lbW+2, lbH+2, 12); 
  }
  fill(lightAmbOn ? color(40, 120, 75, 230) : color(70, 40, 45, 220));
  stroke(lightAmbOn ? color(80, 200, 130, amHover?220:140) : color(180, 70, 70, amHover?180:100));
  strokeWeight(1);
  rect(lightAmbBtnX, lightAmbBtnY, lbW, lbH, 11);
  noStroke();
  fill(lightAmbOn ? color(220,255,230) : color(170,150,150));
  textSize(9); 
  textAlign(CENTER, CENTER);
  text("Ambient", lightAmbBtnX + lbW/2, lightAmbBtnY + lbH/2);
  
  // Directional Light button
  lightDirBtnX = lightAmbBtnX + lbW + lbGap;
  lightDirBtnY = curY;
  boolean drHover = mouseX >= lightDirBtnX && mouseX <= lightDirBtnX+lbW && mouseY >= lightDirBtnY && mouseY <= lightDirBtnY+lbH;
  if (drHover) 
  { 
    noStroke();
    fill(lightDirOn ? color(60,200,120,30) : color(200,60,60,30)); 
    rect(lightDirBtnX-1, lightDirBtnY-1, lbW+2, lbH+2, 12); 
  }
  fill(lightDirOn ? color(40, 120, 75, 230) : color(70, 40, 45, 220));
  stroke(lightDirOn ? color(80, 200, 130, drHover?220:140) : color(180, 70, 70, drHover?180:100));
  strokeWeight(1);
  rect(lightDirBtnX, lightDirBtnY, lbW, lbH, 11);
  noStroke();
  fill(lightDirOn ? color(220,255,230) : color(170,150,150));
  textSize(9); 
  textAlign(CENTER, CENTER);
  text("Direct", lightDirBtnX + lbW/2, lightDirBtnY + lbH/2);
  
  curY += lbH + 8;

  drawArrowButton(legendLx + legendBoxW + 5, legendLy + legendBoxH/2 - 10, false);
}

// Draws a small arrow used for legend hidden function
// pointingDown=true shows arrow down , false shows arrow up
void drawSmallArrow(float x, float y, boolean pointingDown) 
{
  fill(255, 200);
  noStroke();
  float hs = 5;
  if (pointingDown)
  {
    triangle(x - hs, y - hs, x + hs, y - hs, x, y + hs);
  }
  else
  {
    triangle(x - hs, y + hs, x + hs, y + hs, x, y - hs);
  }
}

// -------- Draws a small 2D icon in the legend/tooltip --------
// Each ID matches to drawShapeByGroup() in Shape.pde:
//   0=Octahedron, 1=Icosahedron, 2=UFO, 3=GlitchOrb, 4=DNA,
//   5=Tesseract, 6=Crystal, 7=Jellyfish, 8=Vortex
void drawShapeIcon(int shapeId, float x, float y) 
{
  pushStyle();
  float s = 12;           // Icon size 
  float cx = x + s/2;     // Centre X of the icon  
  float cy = y + s/2;     // Centre Y of the icon  
  fill(200); noStroke();
  switch(shapeId) 
  {
    case 0: 
      beginShape();
      vertex(cx, y);
      vertex(x + s, cy);
      vertex(cx, y + s);
      vertex(x, cy);
      endShape(CLOSE);
      break;
    case 1: 
      beginShape();
      vertex(cx, y);
      vertex(x + s, y + s);
      vertex(x, y + s);
      endShape(CLOSE);
      break;
    case 2: 
      fill(180, 200, 220); 
      ellipse(cx, cy, s*0.8, s*0.3);
      fill(200, 220, 255); 
      arc(cx, cy - s*0.05, s*0.4, s*0.35, PI, TWO_PI);
      break;
    case 3: 
      ellipse(cx, cy, s*0.8, s*0.8);
      break;
    case 4: 
      fill(100, 200, 255);
      for (int i = 0; i < 5; i++) 
      {
        float yy = cy - s*0.3 + i * s * 0.15;
        float xOff = sin(millis()*0.003 + i)*s*0.2;
        ellipse(cx + xOff, yy, 3, 3);
        ellipse(cx - xOff, yy, 3, 3);
      }
      break;
    case 5: 
      stroke(0, 200, 255);
      strokeWeight(1.5);
      noFill();
      float outS = s * 0.4;
      float inS = s * 0.15;
      rectMode(CENTER);
      rect(cx, cy, outS * 2, outS * 2);
      rect(cx, cy, inS * 2, inS * 2);
      line(cx - outS, cy - outS, cx - inS, cy - inS);
      line(cx + outS, cy - outS, cx + inS, cy - inS);
      line(cx - outS, cy + outS, cx - inS, cy + inS);
      line(cx + outS, cy + outS, cx + inS, cy + inS);
      rectMode(CORNER);
      break;
    case 6: 
      fill(180, 220, 255);
      beginShape();
      vertex(cx, cy-s*0.4); 
      vertex(cx+s*0.25, cy);
      vertex(cx, cy+s*0.25); 
      vertex(cx-s*0.25, cy);
      endShape(CLOSE);
      break;
    case 7: 
      fill(160, 200, 255, 200);
      arc(cx, cy-s*0.1, s*0.6, s*0.4, PI, TWO_PI);
      stroke(150,180,255,120); 
      strokeWeight(1);
      for (int i=-1; i<=1; i++) 
      {
        line(cx+i*s*0.12, cy, cx+i*s*0.12+sin(millis()*0.003+i)*2, cy+s*0.3);
      }
      noStroke();
      break;
    case 8: 
      fill(140, 100, 255, 180);
      for (int i=0; i<3; i++)
      {
        float va = millis()*0.003 + i*TWO_PI/3;
        ellipse(cx+cos(va)*s*0.2, cy+sin(va)*s*0.2, s*0.2, s*0.2);
      }
      break;
    default:
      rect(x, y, s, s);
      break;
  }
  popStyle();
}

// -------- Mouse clicks inside the group shape --------
boolean handleGroupMapClick() 
{
  if (!showLegendBox || !groupMapOpen) 
  {
    return false;
  }
  
  if (mouseX >= legendLx + legendBoxW - 85 && mouseX <= legendLx + legendBoxW - 50 && mouseY >= groupResetBtnY && mouseY <= groupResetBtnY + 14)
  {
    resetGroupShapes();
    return true;
  }
  
  for (int g = 0; g < 5; g++) 
  {
    if (groupItemYs[g] > 0 && mouseY >= groupItemYs[g] && mouseY <= groupItemYs[g] + 22)
    {
      float rowX = legendLx + 2;
      float leftBtnX = rowX;
      float rightBtnX = rowX + legendBoxW - 68;
      float resetBtnX = rowX + legendBoxW - 50;
      if (mouseX >= leftBtnX && mouseX <= leftBtnX+14 && mouseY >= groupItemYs[g] && mouseY <= groupItemYs[g]+22)
      {
        cycleShape(g, -1);
        return true;
      }
      else if (mouseX >= rightBtnX && mouseX <= rightBtnX+14 && mouseY >= groupItemYs[g] && mouseY <= groupItemYs[g]+22) 
      {
        cycleShape(g, 1);
        return true;
      }
      else if (mouseX >= resetBtnX && mouseX <= resetBtnX+25 && mouseY >= groupItemYs[g] && mouseY <= groupItemYs[g]+22)
      {
        resetSingleGroupShape(g);
        return true;
      }
    }
  }
  return false;
}

// When a new shape is selected:
//   - The old shape is returned to the available pool
//   - The new shape is removed from the available pool
void cycleShape(int g, int dir) 
{
  // Build list
  ArrayList<Integer> options = new ArrayList<Integer>();
  options.add(groupShape[g]);
  options.addAll(availableShapes);
  
  int idx = 0;
  for (int i = 0; i < options.size(); i++)
  {
    if (options.get(i).equals(groupShape[g])) 
    {
      idx = i; 
      break; 
    }
  }
  
  // Wrap around cycle
  idx = (idx + dir + options.size()) % options.size();
  int newShape = options.get(idx);
  
  // Swap return old shape to pool, take new shape from pool
  if (newShape != groupShape[g]) 
  {
    availableShapes.add(groupShape[g]);       // Return old shape
    availableShapes.remove((Integer)newShape); // Claim new shape
    groupShape[g] = newShape;                  // Assign to group
  }
}
