/*****
 * Draw functions
 */

/* Draw all Grid Worlds listed in the function */
void drawAllGridWorlds() {
    input = new GridWorld(gridWorldPadding, gridWorldPadding, numOfCellAlongX, numOfCellAlongY, cellWidth, cellHeight, cellSpacing, color(230, 230, 230, 100));
  aLife = new GridWorld((2 * gridWorldPadding) + input.worldWidth, gridWorldPadding, numOfCellAlongX, numOfCellAlongY, cellWidth, cellHeight, cellSpacing, color(230, 230, 230, 100));
  output = new GridWorld((3 * gridWorldPadding) + input.worldWidth + aLife.worldWidth, gridWorldPadding, numOfCellAlongX, numOfCellAlongY, cellWidth, cellHeight, cellSpacing, color(230, 230, 230, 100));
//  input = new GridWorld(gridWorldPadding, gridWorldPadding, numOfCellAlongX, numOfCellAlongY, cellWidth, cellHeight, cellSpacing, color(0, 102, 255, 80));
//  aLife = new GridWorld((2 * gridWorldPadding) + input.worldWidth, gridWorldPadding, numOfCellAlongX, numOfCellAlongY, cellWidth, cellHeight, cellSpacing, color(255, 0, 102, 80));
//  output = new GridWorld((3 * gridWorldPadding) + input.worldWidth + aLife.worldWidth, gridWorldPadding, numOfCellAlongX, numOfCellAlongY, cellWidth, cellHeight, cellSpacing, color(0, 212, 0, 80));
} // end drawAllGridWorlds

/* Read and draw data from Input table */
void drawInputTable() {
  for (int counter = 0; counter < totalGridWorldCell; counter++) {
    if (tableInput[counter] == 1) {
      drawBits (input, counter, color(255,255,0,255));
    } // end if
  } // end for
} // end drawInputTable

/* Read and draw data from Output table */
void drawOutputTable() {
  for (int counter = 0; counter < totalGridWorldCell; counter++) {
    if (tableOutput[counter] == 1) {
      drawBits (output, counter, color(0,0,255,255));
    } // end if
  } // end for
} // end drawOutputTable

/* Read and draw data from Agents table */
void drawAgentsTable() {
  for (int counter = 0; counter < maxNumOfAgent; counter++) {
    int cellID, agentCount;
    boolean agentFiringStatus = false;
    boolean agentFixedState = false;
    cellID = tableAgent[counter][columnAgentLocationCellID];
    // Update agent count in that cell
    tableAgentCount[cellID] = tableAgentCount[cellID] + 1;
    agentCount = tableAgentCount[cellID]; 
    if (tableAgent[counter][columnAgentFiringStatus] == 1) {
      agentFiringStatus = true;
    } else {
      agentFiringStatus = false;
    } // end if else
    if (tableAgent[counter][columnAgentFixedState] == 1) {
      agentFixedState = true;
    } else {
      agentFixedState = false;
    } // end if else
    drawAgent (aLife, counter, cellID, agentCount, agentFiringStatus, agentFixedState);
  } // end for
} // end drawAgentsTable

/* Draw Agents in the grid world */
void drawAgent (GridWorld gwName, int agentID, int cellID, int agentCount, boolean agentFiringStatus, boolean agentFixedState) {
  int cellCenterX, cellCenterY, agentWidth, agentHeight;
  // Colors
  colorMode(RGB, 255, 255, 255, 255);
  int colorIntensity = 50 + int((float(tableAgent[agentID][columnAgentActionPotential]) / float(maxAgentActionPotential)) * 200);
  color agentColor = color(0, 255, 0, colorIntensity);
  color agentRingColor = color(0, 200, 0, colorIntensity);
  color firingAgentColor = color(255, 0, 0, 255);
  color fixedAgentColor = color(0, 0, 255, colorIntensity);
  color fixedAgentFiringColor = color(0, 0, 0, 255);
  // Note: cellID index begins at 0
  // Get the cell center XY coordinate
  cellCenterX = gwName.worldCornerLeftTopX + (cellID % gwName.numOfCellAlongX) * (gwName.cellWidth + gwName.cellSpacing) + gwName.cellSpacing + (gwName.cellWidth / 2);
  cellCenterY = gwName.worldCornerLeftTopY + ((cellID - (cellID % gwName.numOfCellAlongX)) / gwName.numOfCellAlongX) * (gwName.cellHeight + gwName.cellSpacing) + gwName.cellSpacing + (gwName.cellHeight / 2);
  if (agentCount == 1) {
    strokeWeight(1);
    stroke(100, 100, 100, 255);
    if (agentFixedState == true && agentFiringStatus == true) {
      fill(fixedAgentFiringColor);
    } else if (agentFixedState == true) {
      fill(fixedAgentColor);
    } else if (agentFiringStatus == true) {
      fill(firingAgentColor);
    } else {
      fill(agentColor);
    } // end if else
    agentWidth = gwName.cellWidth;
    agentHeight = gwName.cellHeight;
  } else {
    // Draw numerous agent sharing a cell as incrementing outline
    strokeWeight(1);
    if (agentFixedState == true && agentFiringStatus == true) {
      stroke(fixedAgentFiringColor);
    } else if (agentFixedState == true) {
      stroke(fixedAgentColor);
    } else if (agentFiringStatus == true) {
      stroke(firingAgentColor);
    } else {
      stroke(agentRingColor);
    } // end if else
    noFill();
    agentWidth = agentCount * gwName.cellWidth;
    agentHeight = agentCount * gwName.cellHeight;
  } // end if else
  ellipseMode(CENTER);
  ellipse(cellCenterX, cellCenterY, agentWidth, agentHeight);
} // end drawAgent

/* Draw active bits in the binary grid world */
void drawBits (GridWorld gwName, int cellID, color bitColor) {
  // Note: cellID index begins at 0
  // Get the cell center XY coordinate
  int cellCenterX, cellCenterY, bitWidth, bitHeight;
  cellCenterX = gwName.worldCornerLeftTopX + (cellID % gwName.numOfCellAlongX) * (gwName.cellWidth + gwName.cellSpacing) + gwName.cellSpacing + (gwName.cellWidth / 2);
  cellCenterY = gwName.worldCornerLeftTopY + ((cellID - (cellID % gwName.numOfCellAlongX)) / gwName.numOfCellAlongX) * (gwName.cellHeight + gwName.cellSpacing) + gwName.cellSpacing + (gwName.cellHeight / 2);
  // Draw Bit as circle
  ellipseMode(CENTER);
  fill(bitColor);
  stroke(120, 120, 120, 255);
  strokeWeight(1);
  bitWidth = gwName.cellWidth;
  bitHeight = gwName.cellHeight;
  ellipse(cellCenterX, cellCenterY, bitWidth, bitHeight);
} // end drawAgent
