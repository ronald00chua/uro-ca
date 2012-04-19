/*******
 * Agent Rules functions  
 */

// Execute the chain of Agent rules
void executeAgentRulesChain (GridWorld gwAgentLayer, int agentID) {
  /* Rule 1: Move */
  // Agent moves based on its Inertia direction if it is not "fixed"
  if (tableAgent[agentID][columnAgentFixedState] == 0) {
    moveAgent(gwAgentLayer, agentID);
  } else { // do nothing
  } // end if else
  // If after movement Agent is above an active Input cell its Action Potential increases
  if (checkForActiveInputCellBelow(agentID) == true) {
    increaseAgentActionPotential(agentID);
  } else { // its Action Potential decreases
    decreaseAgentActionPotential(agentID);
  } // end if else
  
  /* Rule 2: Action Potential */
  // Check if Agent is already firing, if yes reset its Action Potential
  if (tableAgent[agentID][columnAgentFiringStatus] == 1) {
    resetAgentActionPotential(agentID);
  } else { // do nothing
  } // end if else
  // When Agent is at its maximum Action Potential, Agent "fires" up all its Action Potential
  boolean rule02_maxAgentActionPotential = checkIfAgentAtMaxActionPotential(agentID);
  if (rule02_maxAgentActionPotential == true) {
    markAgentAsFiring(agentID);
    if (doExciteSimilarPhaseAgent == false) {
      // When an agent fires, it excites other Agents in similar firing phase
      exciteSimilarPhaseAgent();
      doExciteSimilarPhaseAgent = true;
    } else { // do nothing
    } // end if else
  } else {
    markAgentAsNotFiring(agentID);
  } // end if else 
} // end executeAgentRulesChain


/* 
 * "Move" functions 
 */
 
// Move Agent in the direction its Inertia value indicates
void moveAgent (GridWorld gwAgentLayer, int agentID) {
  int agentLocationCellID = tableAgent[agentID][columnAgentLocationCellID];
  int maxNumOfCell = gwAgentLayer.numOfCellAlongX * gwAgentLayer.numOfCellAlongY;
  int neighborN, neighborNE, neighborE, neighborSE, neighborS, neighborSW, neighborW, neighborNW;
  int agentFixedState = tableAgent[agentID][columnAgentFixedState];
  // Directional coding scheme
    /* NW  N  NE       7 0 1
        W  C  E        6   2
       SW  S  SE       5 4 3 */
  // Get neighbor Cell ID values with top-bottom left-right border wrapping, illustrated below
    /* 35   30 31 32 33 34 35   30

        5    0  1  2  3  4  5    0
       11    6  7  8  9 10 11    6
       17   12 13 14 15 16 17   12
       23   18 19 20 21 22 23   18
       29   24 25 26 27 28 29   24
       35   30 31 32 33 34 35   30

        5    0  1  2  3  4  5    0 */
  // Border wrap top-to-bottom
  if ((0 <= agentLocationCellID) && (agentLocationCellID < gwAgentLayer.numOfCellAlongX)) {
    neighborN = agentLocationCellID + maxNumOfCell - gwAgentLayer.numOfCellAlongX;
  } else {
    neighborN = agentLocationCellID - gwAgentLayer.numOfCellAlongX;
  } // end if else
  // Border wrap bottom-to-top
  if (((maxNumOfCell - gwAgentLayer.numOfCellAlongX) <= agentLocationCellID) && (agentLocationCellID < maxNumOfCell)) {
    neighborS = agentLocationCellID % gwAgentLayer.numOfCellAlongX;
  } else {
    neighborS = agentLocationCellID + gwAgentLayer.numOfCellAlongX;
  } // end if else
  // Border wrap left-to-right
  if ((agentLocationCellID % gwAgentLayer.numOfCellAlongX) == 0) {
    neighborW = agentLocationCellID + gwAgentLayer.numOfCellAlongX - 1;
  } else {
    neighborW = agentLocationCellID -1;
  } // end if else
  // Border wrap right-to-left
  if ((agentLocationCellID % gwAgentLayer.numOfCellAlongX) == (gwAgentLayer.numOfCellAlongX - 1)) {
    neighborE = agentLocationCellID - gwAgentLayer.numOfCellAlongX + 1;
  } else {
    neighborE = agentLocationCellID +1;
  } // end if else
  // Border wrap NW corner
  if (agentLocationCellID == 0) {
    neighborNW = maxNumOfCell - 1;
  } else {
    neighborNW = neighborN - 1;
    if ((neighborNW < 0) || (neighborNW > (maxNumOfCell - 1))) {
      neighborNW = neighborW - gwAgentLayer.numOfCellAlongX;
    } else { // do nothing
    } // end if else
  } // end if else
  // Border wrap NE corner
  if (agentLocationCellID == (gwAgentLayer.numOfCellAlongX - 1)) {
    neighborNE = maxNumOfCell - gwAgentLayer.numOfCellAlongX;
  } else {
    neighborNE = neighborN + 1;
    if ((neighborNE < 0) || (neighborNE > (maxNumOfCell - 1))) {
      neighborNE = neighborE - gwAgentLayer.numOfCellAlongX;
    } else { // do nothing
    } // end if else
  } // end if else
  // Border wrap SW corner
  if (agentLocationCellID == (maxNumOfCell - gwAgentLayer.numOfCellAlongX)) {
    neighborSW = gwAgentLayer.numOfCellAlongX - 1;
  } else {
    neighborSW = neighborS - 1;
    if ((neighborSW < 0) || (neighborSW > (maxNumOfCell - 1))) {
      neighborSW = neighborW + gwAgentLayer.numOfCellAlongX;
    } else { // do nothing
    } // end if else
  } // end if else  
  // Border wrap SE corner
  if (agentLocationCellID == (maxNumOfCell - 1)) {
    neighborSE = 0;
  } else {
    neighborSE = neighborS + 1;
    if ((neighborSE < 0) || (neighborSE > (maxNumOfCell - 1))) {
      neighborSE = neighborE + gwAgentLayer.numOfCellAlongX;
    } else { // do nothing
    } // end if else
  } // end if else    
  
  // Move Agent based on its Inertia direction 
  if (tableAgent[agentID][columnAgentInertiaDirection] == 0) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborN;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 1) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborNE;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 2) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborE;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 3) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborSE;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 4) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborS;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 5) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborSW;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 6) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborW;
  } else if (tableAgent[agentID][columnAgentInertiaDirection] == 7) {    
    tableAgent[agentID][columnAgentLocationCellID] = neighborNW;
  } else { // do nothing
  } // end if else
} // end moveAgent

/* Check for active Input cell below */
boolean checkForActiveInputCellBelow (int agentID) {
  int agentLocationCellID = tableAgent[agentID][columnAgentLocationCellID];
  if (tableInput[agentLocationCellID] == 1) {
    return true;
  } else {
    return false;
  }
} // end checkForActiveInputCellBelow


/* 
 * "Action Potential" functions 
 */
 
// Agent Action Potential increases when "touching" active neighbor cell
void increaseAgentActionPotential (int agentID) {
  // If Agent Action potential is not full yet, add to it
  if (tableAgent[agentID][columnAgentActionPotential] < maxAgentActionPotential) {
    tableAgent[agentID][columnAgentActionPotential]++;
  } else { // do nothing
  } // end if else
} // end exciteAgent

// At each turn, if Agent does not touch an active Input cell, its Action Potential leaks away
void decreaseAgentActionPotential (int agentID) {
  // If Agent Action potential is not already empty, decrease it
  if (tableAgent[agentID][columnAgentActionPotential] > 0) {
    tableAgent[agentID][columnAgentActionPotential]--;
  } else { // do nothing
  } // end if else
} // end exciteAgent

// Check if Agent at maximum Action Patential
boolean checkIfAgentAtMaxActionPotential (int agentID) {
  boolean agentAtMaxActionPotential = false;
  // If Agent Action Potential is equal to given max potential, agent fires
  if (tableAgent[agentID][columnAgentActionPotential] == maxAgentActionPotential) {
    agentAtMaxActionPotential = true;
  } else {
    agentAtMaxActionPotential = false;
  } // end if else
  return agentAtMaxActionPotential;
} // end evaluateAgentActionPotential

// Mark Agent as firing
void markAgentAsFiring (int agentID) {
  tableAgent[agentID][columnAgentFiringStatus] = 1;
} // end markAgentAsFiring

// Mark Agent as not firing
void markAgentAsNotFiring (int agentID) {
  tableAgent[agentID][columnAgentFiringStatus] = 0;
} // end markAgentAsFiring

// Reset Agent Action Potential after it fires
void resetAgentActionPotential (int agentID) {
  tableAgent[agentID][columnAgentActionPotential] = 0;
} // end markAgentAsFiring

// Give other Agent in similar Action Potential excitation phase a boost
void exciteSimilarPhaseAgent() {
  for (int counter = 0; counter < maxNumOfAgent; counter++) {
    if (tableAgent[counter][columnAgentActionPotential] == maxAgentActionPotential - 1 || tableAgent[counter][columnAgentActionPotential] == 0) {
      tableAgent[counter][columnAgentActionPotential]++;
    } else { // do nothing
    } // end if else
  } // end for
} // end exciteSimilarPhaseAgent
