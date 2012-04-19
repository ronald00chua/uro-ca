import controlP5.*;

/*******
 * Declaring global variables 
 */

/* GUI controls */
ControlP5 guiController;
ControlWindow guiInputWindow;
ControlWindow guiOutputWindow;
Slider[] inputSlider;
Slider[] outputSlider;
Numberbox[] inputNumberbox;

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
float encouragerActionPotentialModifier;
int discouragerActionPotentialModifierMin, discouragerActionPotentialModifierMax;
int discouragerLocationModifierMin, discouragerLocationModifierMax;
boolean doExciteSimilarPhaseAgent;

/* Tables sizes */
int numOfCellAlongX, numOfCellAlongY, totalGridWorldCell;
int cellWidth, cellHeight, cellSpacing, gridWorldPadding;
int maxNumOfAgent, maxNumOfAgentInternalParameter;

/* Agents table column index in the 2D array */
int columnAgentLocationCellID, columnAgentActionPotential, columnAgentFiringStatus, columnAgentFixedState, columnAgentInertiaDirection;

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
  ioBitResolution = 10;
  
  /* These are the evolvable parameters */
  // Grid World size
  numOfCellAlongX = ioBitResolution;
  numOfCellAlongY = numOfInputLine * numOfOutputLine;
  totalGridWorldCell = numOfCellAlongX * numOfCellAlongY; //derived
  // Maximum number of agents
  maxNumOfAgent = totalGridWorldCell;
  // Maximum value of Agents' internal dynamic
  maxAgentActionPotential = 4;
  // Environment perturbance
  encouragerActionPotentialModifier = 0.5;
  discouragerActionPotentialModifierMin = 0;
  discouragerActionPotentialModifierMax = maxAgentActionPotential - 1;
  discouragerLocationModifierMin = 0;
  discouragerLocationModifierMax = totalGridWorldCell;
  
  // Initialize other parameters
  maxNumOfAgentInternalParameter = 5;
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
  inputNumberbox = new Numberbox[numOfInputLine];
  inputSlider = new Slider[numOfInputLine];
  outputSlider = new Slider[numOfOutputLine];
  int startDrawControllerX = 10;
  int startDrawControllerY = 10;
  int numberboxWidth = 30;
  int numberboxSpacing = 5;
  int sliderWidth = 256;
  int sliderHeight = 15;
  int sliderSpacing = 10;
  int inputLabelWidth = 60;
  int outputLabelWidth = 70;
  int inputWindowWidth = 2 * sliderSpacing + numberboxSpacing + numberboxWidth + sliderWidth + inputLabelWidth;
  int inputWindowHeight = numOfInputLine * (sliderHeight + sliderSpacing) + sliderSpacing;
  int outputWindowWidth = 2 * sliderSpacing + sliderWidth + outputLabelWidth;
  int outputWindowHeight = numOfOutputLine * (sliderHeight + sliderSpacing) + sliderSpacing;
  guiInputWindow = guiController.addControlWindow("guiInputWindow", 100, 100, inputWindowWidth, inputWindowHeight);
  guiInputWindow.setTitle("Input Controller");
  guiInputWindow.setBackground(color(0));
  guiInputWindow.hideCoordinates();
  guiInputWindow.setUpdateMode(ControlWindow.NORMAL); // update the window continuously
  generateInputControllerSlider(startDrawControllerX + numberboxWidth + numberboxSpacing, startDrawControllerY, sliderWidth, sliderHeight, sliderSpacing);
  generateInputControllerNumberbox(startDrawControllerX, startDrawControllerY, numberboxWidth, sliderHeight, sliderSpacing);
  guiOutputWindow = guiController.addControlWindow("guiOutputWindow", 100 + inputWindowWidth, 100, outputWindowWidth, outputWindowHeight);
  guiOutputWindow.setTitle("Output Display");
  guiOutputWindow.setBackground(color(0));
  guiOutputWindow.hideCoordinates();
  guiOutputWindow.setUpdateMode(ControlWindow.NORMAL); // update the window continuously
  generateOutputControllerSlider(startDrawControllerX, startDrawControllerY, sliderWidth, sliderHeight, sliderSpacing);
  
  // Set the number of times the whole draw() loop is executed per second
  frameRate(20);
  
  // Create Input table
  tableInput = new int[totalGridWorldCell];
  // Create Agents table
  tableAgent = new int[maxNumOfAgent][maxNumOfAgentInternalParameter];
  // Create Output table
  tableOutput = new int[totalGridWorldCell];
  // Create Agent Count table
  tableAgentCount = new int[totalGridWorldCell];
  // Create array to store Input and Output values
  valueInput = new int[numOfInputLine];
  valueOutput = new int[numOfOutputLine];
  
  /* Agents table column index in the 2D array */
  columnAgentLocationCellID = 0;
  columnAgentActionPotential = 1;
  columnAgentFiringStatus = 2;
  columnAgentFixedState = 3;
  columnAgentInertiaDirection = 4;

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
    readInputNumberboxValueToInputArray();
    updateInputSliderValue();
    
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
