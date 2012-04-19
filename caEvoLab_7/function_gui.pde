/*******
 * GUI related functions
 */

/* 
 * GUI Input 
 */
 
void generateInputControllerSlider (int startDrawControllerX, int startDrawControllerY, int sliderWidth, int sliderHeight, int sliderSpacing) {
  int sliderMaxValue = int(pow(2, ioBitResolution) - 1);
  for (int counter = 0; counter < numOfInputLine; counter++) {
    // Add slider control for each Input
    inputSlider[counter] = guiController.addSlider(
      generateInputSliderName(counter), 0, sliderMaxValue, 
      startDrawControllerX, (startDrawControllerY + counter * (sliderHeight + sliderSpacing)), 
      sliderWidth, sliderHeight);
    inputSlider[counter].setWindow(guiInputWindow);
    inputSlider[counter].setMoveable(false);
    inputSlider[counter].setDecimalPrecision(0);
  } // end for
} // end generateInputControllerSlider

String generateInputSliderName (int sliderCounter) {
  String[] stringArray = {"Input Line", nf(sliderCounter,2)};
  String sliderName = join(stringArray," ");
  return sliderName;
} // end generateSliderName

void readInputSliderValueToInputArray() {
  for (int counter = 0; counter < numOfInputLine; counter++) {
    valueInput[counter] = int(inputSlider[counter].value());
  } // end for
} // end readInputSliderValueToInputArray

/* 
 * GUI Output 
 */
 
void generateOutputControllerSlider (int startDrawControllerX, int startDrawControllerY, int sliderWidth, int sliderHeight, int sliderSpacing) {
  int sliderMaxValue = int(pow(2, ioBitResolution) - 1);
  for (int counter = 0; counter < numOfOutputLine; counter++) {
    // Add slider control for each Input
    outputSlider[counter] = guiController.addSlider
      (
      generateOutputSliderName(counter), 0, sliderMaxValue, 
      startDrawControllerX, (startDrawControllerY + counter * (sliderHeight + sliderSpacing)), 
      sliderWidth, sliderHeight
      );
    outputSlider[counter].setWindow(guiOutputWindow);
    outputSlider[counter].setDecimalPrecision(0);
    outputSlider[counter].setMoveable(false);
    outputSlider[counter].setLock(true);
  } // end for
} // end generateInputControllerSlider

String generateOutputSliderName (int sliderCounter) {
  String[] stringArray = {"Output Line", nf(sliderCounter,2)};
  String sliderName = join(stringArray," ");
  return sliderName;
} // end generateOutputSliderName

void updateOutputSliderValue() {
  for (int counter = 0; counter < numOfOutputLine; counter++) {
    outputSlider[counter].setValue(valueOutput[counter]);
  } // end for
} // end updateOutputSliderValue;
