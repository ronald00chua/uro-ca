/*******
 * Ideas...
 */
 
// Randomly selecting a percentage of agents
void randomlySelectPercentageOfAgent() {
  float percentageOfAgent = 0.5; // say 50%
  int numOfAgentInThePercentage = int(percentageOfAgent * maxNumOfAgent);
  int[] randomlySelectedAgent = new int[numOfAgentInThePercentage];
  for (int counter = 0; counter < numOfAgentInThePercentage; counter++) {
    int randomAgentIndex = int(random(0, maxNumOfAgent));
    randomlySelectedAgent[counter] = randomAgentIndex;
    randomSeed(randomAgentIndex); // seed with previous value to ensure no repeat
  } // end for
} // end randomlySelectPercentageOfAgent





/*******
 * Miscellaneous functions 
 */

// Initialize Agent table
void initializeAgentTable() {
  int agentLocationCellID = 0;
  for (int agentCounter = 0; agentCounter < maxNumOfAgent; agentCounter++) {
    tableAgent[agentCounter][columnAgentInertiaDirection] = int(random(0,8));
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
    case 'q': emptyInput(); break;
    case 'f': redraw(); break;
    case 'g': saveFrame(); break;
    case 'w': perturbWorld(); break;
    case 'e': perturbEncourage(); break;
    case 'r': perturbDiscourage(); break;
    default : break; // do nothing
  } // end switch
} // end keyPressed

void emptyInput() {
  for (int counter = 0; counter < numOfInputLine; counter++) {
    valueInput[counter] = 0;
    // read input array into slider
    inputNumberbox[counter].setValue(valueInput[counter]);
  } // end for
} // end emptyInput

void randomPopulateInput() {
  for (int counter = 0; counter < numOfInputLine; counter++) {
    valueInput[counter] = int(random(0,pow(2,ioBitResolution)));
    // read input array into slider
    inputNumberbox[counter].setValue(valueInput[counter]);
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
