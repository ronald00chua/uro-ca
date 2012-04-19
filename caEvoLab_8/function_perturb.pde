/*******
 * Agent environment perturbance functions
 */

void perturbEncourage() {
  for (int counter = 0; counter < maxNumOfAgent; counter++) {
    if (tableAgent[counter][columnAgentFiringStatus] == 1) {
      tableAgent[counter][columnAgentFixedState] = 1;
      tableAgent[counter][columnAgentActionPotential] = int(encouragerActionPotentialModifier * maxAgentActionPotential);
      println(tableAgent[counter][columnAgentActionPotential]);
    } else { // do nothing
    } // end if else
  } // end for
  println("Encouraged");
} // end perturbEncourage

void perturbDiscourage() {
  for (int counter = 0; counter < maxNumOfAgent; counter++) {
    if (tableAgent[counter][columnAgentFiringStatus] == 1) {
      tableAgent[counter][columnAgentInertiaDirection] = int(random(0,8));
      tableAgent[counter][columnAgentActionPotential] = int(random(discouragerActionPotentialModifierMin, discouragerActionPotentialModifierMax));
      tableAgent[counter][columnAgentLocationCellID] = int(random(discouragerLocationModifierMin, discouragerLocationModifierMax));
      tableAgent[counter][columnAgentFiringStatus] = 0;
      tableAgent[counter][columnAgentFixedState] = 0;
    } else { // do nothing
    } // end if else
  } // end for
  println("Discouraged");
} // end perturbDiscourage

void perturbWorld() {
  for (int counter = 0; counter < maxNumOfAgent; counter++) {
    if (tableAgent[counter][columnAgentFixedState] == 0) {
      tableAgent[counter][columnAgentInertiaDirection] = int(random(0,8));
      tableAgent[counter][columnAgentActionPotential] = int(random(discouragerActionPotentialModifierMin, discouragerActionPotentialModifierMax));
      tableAgent[counter][columnAgentLocationCellID] = int(random(discouragerLocationModifierMin, discouragerLocationModifierMax));
    } else { // do nothing
    } // end if else
  } // end for
} // end perturbWorld
