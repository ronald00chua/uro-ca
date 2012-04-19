import controlP5.*;

/*******
 * Declaring global variables 
 */

/* GUI controls */
ControlP5 guiController;
ControlWindow guiInputWindow;
ControlWindow guiOutputWindow;
Controller[] inputSlider;
Controller[] outputSlider;

/* Hardware configuration */
int numOfInputLine;
int numOfOutputLine;
int ioBitResolution;
 
/* Draw update timer */
int timeStep;

/* Tables */
// Input and Output table
int[] tableInput, tableOutput, tableAgentCount, valueInput, valueOutput;
// Agents table
int[][] tableAgent;
// Grid worlds
GridWorld input, aLife, output;
// Environment perturbance and rules
int discouragerActionPotentialModifierMin, discouragerActionPotentialModifierMax;
int discouragerLocationModifierMin, discouragerLocationModifierMax;
boolean doExciteSimilarPhaseAgent;

/* Tables sizes */
int numOfCellAlongX, numOfCellAlongY, totalGridWorldCell;
int cellWidth, cellHeight, cellSpacing, gridWorldPadding;
int maxNumOfAgent, maxNumOfAgentInternalParameter;

/* Agents table column index in the 2D array */
int columnAgentLocationCellID, columnAgentActionPotential, columnAgentFiringStatus, columnAgentFixedState;

/* Agents' internal dynamic max values (evolvable values) */
int maxAgentActionPotential;


/*******
 * Function setup() runs on program launch 
 */
void setup() {
  
  // Start at time step 0
  timeStep = 0;
  
  // Set hardware configuration (one of below must be an even number);
  numOfInputLine = 6;
  numOfOutputLine = 4;
  ioBitResolution = 8;
  
  /* These are the evolvable parameters */
  // Grid World size
  numOfCellAlongX = ioBitResolution;
  numOfCellAlongY = numOfInputLine * numOfOutputLine;
  totalGridWorldCell = numOfCellAlongX * numOfCellAlongY; //derived
  // Maximum number of agents
  maxNumOfAgent = int(totalGridWorldCell * 1.5);
  println(maxNumOfAgent);//debug
  // Maximum value of Agents' internal dynamic
  maxAgentActionPotential = 4;
  // Environment perturbance
  discouragerActionPotentialModifierMin = 0;
  discouragerActionPotentialModifierMax = maxAgentActionPotential;
  discouragerLocationModifierMin = 0;
  discouragerLocationModifierMax = totalGridWorldCell;
  
  // Initialize other parameters
  maxNumOfAgentInternalParameter = 4;
  doExciteSimilarPhaseAgent = false;
  
  // World display parameters
  gridWorldPadding = 20;
  cellWidth = 10;
  cellHeight = 10;
  cellSpacing = 0;
  
  // 3 x 1 grid world arrangement
  int totalDisplayWidth = cellWidth * (3 * numOfCellAlongX) + (4 * gridWorldPadding);
  int totalDisplayHeight = cellHeight * numOfCellAlongY + (2 * gridWorldPadding); 
  
  // Set the application window size
  size(totalDisplayWidth, totalDisplayHeight);
  
  // GUI
  guiController = new ControlP5(this);
  guiController.setAutoDraw(true);
  inputSlider = new Controller[numOfInputLine];
  outputSlider = new Controller[numOfOutputLine];
  int startDrawControllerX = 10;
  int startDrawControllerY = 10;
  int sliderWidth = 256;
  int sliderHeight = 15;
  int sliderSpacing = 10;
  int inputLabelWidth = 60;
  int outputLabelWidth = 70;
  int inputWindowWidth = 2 * sliderSpacing + sliderWidth + inputLabelWidth;
  int inputWindowHeight = numOfInputLine * (sliderHeight + sliderSpacing) + sliderSpacing;
  int outputWindowWidth = 2 * sliderSpacing + sliderWidth + outputLabelWidth;
  int outputWindowHeight = numOfOutputLine * (sliderHeight + sliderSpacing) + sliderSpacing;
  guiInputWindow = guiController.addControlWindow("guiInputWindow", 100, 100, inputWindowWidth, inputWindowHeight);
  guiInputWindow.setTitle("Input Controller");
  guiInputWindow.setBackground(color(0));
  guiInputWindow.hideCoordinates();
  guiInputWindow.setUpdateMode(ControlWindow.NORMAL); // update the window continuously
  generateInputControllerSlider(startDrawControllerX, startDrawControllerY, sliderWidth, sliderHeight, sliderSpacing);
  guiOutputWindow = guiController.addControlWindow("guiOutputWindow", 100 + inputWindowWidth, 100, outputWindowWidth, outputWindowHeight);
  guiOutputWindow.setTitle("Output Display");
  guiOutputWindow.setBackground(color(0));
  guiOutputWindow.hideCoordinates();
  guiOutputWindow.setUpdateMode(ControlWindow.NORMAL); // update the window continuously
  generateOutputControllerSlider(startDrawControllerX, startDrawControllerY, sliderWidth, sliderHeight, sliderSpacing);
  
  // Set the number of times the whole draw() loop is executed per second
  frameRate(2);
  
  // Create Input table
  tableInput = new int[numOfCellAlongX * numOfCellAlongY];
  // Create Agents table
  tableAgent = new int[maxNumOfAgent][maxNumOfAgentInternalParameter];
  // Create Output table
  tableOutput = new int[numOfCellAlongX * numOfCellAlongY];
  // Create Agent Count table
  tableAgentCount = new int[maxNumOfAgent];
  // Create array to store Input and Output values
  valueInput = new int[numOfInputLine];
  valueOutput = new int[numOfOutputLine];
  
  /* Agents table column index in the 2D array */
  columnAgentLocationCellID = 0;
  columnAgentActionPotential = 1;
  columnAgentFiringStatus = 2;
  columnAgentFixedState = 3;

  /* Initialization */
  initializeAgentTable();
  clearInputTable();
 
} // end setup


/*******
 * Function draw() is looped throughout
 */
void draw() {
  // Blank display window to white 
  background(255);
  
  // Draw at time step 0, Input as it is and Agent positions before interaction with Input
  if (timeStep == 0) {
    // GUI
    readInputSliderValueToInputArray();
    
    clearInputTable();
    translateInputArrayToInputTable();
    drawAllGridWorlds();
    clearTableAgentCount();
    drawInputTable();
    drawAgentsTable();
    clearTableAgentCount();
    drawOutputTable();
    clearOutputTable();
    timeStep = 1;
  } else { // At time step 1
    // Extract data from and update Agents table
    for (int counter = 0; counter < maxNumOfAgent; counter++) {
      // Execute agent rules sequentially
      executeAgentRulesChain(aLife, counter);
    } // end for
    // Reset global variable modified by executeAgentRulesChain
    doExciteSimilarPhaseAgent = false;
    // Convert current Agent table into Output table
    translateAgentTableToOutputTable();  
    // Draw the same Input cells dimmed and the Agent positions after interaction with Input
    background(255);
    drawInputTable(); // draw before grid world to get dimming effect
    drawAllGridWorlds();
    clearTableAgentCount();
    drawAgentsTable();
    drawOutputTable();
    storeOutputValueToOutputArray();
    clearTableAgentCount();
    timeStep = 0; // Set back time step to 0 for next set   
    // GUI
    updateOutputSliderValue();
  } // end if else
} // end draw


//////////////////////////////////////////////////////////////////////


/*******
 * Miscellaneous functions 
 */

// Initialize Agent table
void initializeAgentTable() {
  int agentLocationCellID = 0;
  for (int agentCounter = 0; agentCounter < maxNumOfAgent; agentCounter++) {
    tableAgent[agentCounter][columnAgentActionPotential] = 0;
    tableAgent[agentCounter][columnAgentFiringStatus] = 0;
    tableAgent[agentCounter][columnAgentFixedState] = 0; 
    tableAgent[agentCounter][columnAgentLocationCellID] = agentLocationCellID;
    agentLocationCellID++;
    if (agentLocationCellID == totalGridWorldCell) {
      agentLocationCellID = 0;
    } else { // do nothing
    } // end if else
  } // end for
} // end initializeAgentTable

// Clear cell Agent count table
void clearTableAgentCount() {
  for (int counter = 0; counter < totalGridWorldCell; counter++) {
    tableAgentCount[counter] = 0;
  }
} // end clearTableAgentCount

// Clear Input table
void clearInputTable() {
  for (int counter = 0; counter < totalGridWorldCell; counter++) {
    tableInput[counter] = 0;
  }
} // end clearInputTable

// Clear Output table
void clearOutputTable() {
  for (int counter = 0; counter < totalGridWorldCell; counter++) {
    tableOutput[counter] = 0;
  }
} // end clearOutputTable


/*******
 * Random stuffs used while developing
 */

// add some control
void keyPressed() {
  char theKey = key;
  switch (theKey) {
    case 's': noLoop(); break; // pause
    case 'a': loop();  break; // continue running
    case 'd': randomPopulateInput(); break;
    case 'f': redraw(); break;
    case 'g': saveFrame(); break;
    case 'e': perturbEncourage(); break;
    case 'r': perturbDiscourage(); break;
    default : break; // do nothing
  } // end switch
} // end keyPressed


void randomPopulateInput() {
  for (int counter = 0; counter < numOfInputLine; counter++) {
    valueInput[counter] = int(random(0,pow(2,ioBitResolution)));
    // read input array into slider
    inputSlider[counter].setValue(valueInput[counter]);
  } // end for
  /* old stuff
  // populating input table with random data for test
  // every row is repeated inversely in its next row
  for (int counterB = 0; counterB < totalGridWorldCell;) {
    for (int counterA = 0; counterA < numOfCellAlongX; counterA++) {
      int cellID = counterB + counterA;
      int randomValue = int(random(0,2));
      tableInput[cellID] = randomValue;
      tableInput[counterB + ((2 * numOfCellAlongX) - 1) - counterA] = randomValue;
     } // end for
     counterB += 2 * numOfCellAlongX;
   } // end for
   */
} // end randomPopulateInput
