/*****
 * Class: Grid World
 */

class GridWorld {
  // Attributes
  int worldCornerLeftTopX, worldCornerLeftTopY;
  int numOfCellAlongX, numOfCellAlongY;
  int cellWidth, cellHeight, cellSpacing;
  int worldWidth, worldHeight, totalCell; 
  color cellBgColor;
  // Constructor
  GridWorld (
    int gwCornerLeftTopX, int gwCornerLeftTopY, 
    int gwNumOfCellAlongX, int gwNumOfCellAlongY, 
    int gwCellWidth, int gwCellHeight, int gwCellSpacing, 
    color gwCellBgColor) 
    {
      worldCornerLeftTopX = gwCornerLeftTopX;
      worldCornerLeftTopY = gwCornerLeftTopY;
      numOfCellAlongX = gwNumOfCellAlongX;
      numOfCellAlongY = gwNumOfCellAlongY;
      cellWidth = gwCellWidth;
      cellHeight = gwCellHeight;
      cellSpacing = gwCellSpacing;
      cellBgColor = gwCellBgColor;
      worldWidth = numOfCellAlongX * (cellWidth + cellSpacing) + cellSpacing;
      worldHeight = numOfCellAlongY * (cellHeight + cellSpacing) + cellSpacing;
      totalCell = numOfCellAlongX * numOfCellAlongY;
      // Draw grid world cells on screen
      for (int counter = 0; counter < totalCell; counter++) {
        int drawCornerLeftTopX, drawCornerLeftTopY;
        strokeWeight(2);
        stroke(cellBgColor);
        fill(cellBgColor);
        smooth();
        ellipseMode(CORNER);
        if (counter == 0) {
          drawCornerLeftTopX = worldCornerLeftTopX + cellSpacing;
          drawCornerLeftTopY = worldCornerLeftTopY + cellSpacing;
        } else {
          drawCornerLeftTopX = worldCornerLeftTopX + (counter % numOfCellAlongX) * (cellWidth + cellSpacing) + cellSpacing;
          drawCornerLeftTopY = worldCornerLeftTopY + ((counter - (counter % numOfCellAlongX)) / numOfCellAlongX) * (cellHeight + cellSpacing) + cellSpacing;
        } // end if else
        ellipse(drawCornerLeftTopX, drawCornerLeftTopY, cellWidth, cellHeight);
      }// end for
  }// end constructor
}// end class

