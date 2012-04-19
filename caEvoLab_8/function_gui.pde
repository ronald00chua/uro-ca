/*******
 * GUI related functions
 */

/* 
 * GUI Input 
 */

void generateInputControllerNumberbox (int startDrawControllerX, int startDrawControllerY, int numberboxWidth, int numberboxHeight, int numberboxSpacing) {
  int numberboxMaxValue = int(pow(2, ioBitResolution) - 1);
  for (int counter = 0; counter < numOfInputLine; counter++) {
    // Add numberbox control for each Input
    inputNumberbox[counter] = guiController.addNumberbox(
      generateInputNumberboxName(counter),
      startDrawControllerX, (startDrawControllerY + counter * (numberboxHeight + numberboxSpacing)), 
      numberboxWidth, numberboxHeight);
    inputNumberbox[counter].setWindow(guiInputWindow);
    inputNumberbox[counter].setMoveable(false);
    inputNumberbox[counter].setDecimalPrecision(0);
    inputNumberbox[counter].setMin(0);
    inputNumberbox[counter].setMax(numberboxMaxValue);
    inputNumberbox[counter].setDirection(Controller.HORIZONTAL);
    inputNumberbox[counter].setValueLabel(">>>");
    inputNumberbox[counter].setLabel("");
  } // end for
} // end generateInputControllerSlider
 
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
    inputSlider[counter].setLock(true);
    inputSlider[counter].setDecimalPrecision(0);
    inputSlider[counter].setColorValueLabel(color(0));
  } // end for
} // end generateInputControllerSlider

String generateInputSliderName (int sliderCounter) {
  String[] stringArray = {"Input Line", nf(sliderCounter,2)};
  String sliderName = join(stringArray," ");
  return sliderName;
} // end generateSliderName

String generateInputNumberboxName (int numberboxCounter) {
  String[] stringArray = {"Input ", nf(numberboxCounter,2)};
  String numberboxName = join(stringArray," ");
  return numberboxName;
} // end generateSliderName

void readInputNumberboxValueToInputArray() {
  for (int counter = 0; counter < numOfInputLine; counter++) {
    valueInput[counter] = int(inputNumberbox[counter].value());
  } // end for
} // end readInputSliderValueToInputArray

void updateInputSliderValue() {
  for (int counter = 0; counter < numOfInputLine; counter++) {
    inputSlider[counter].setValue(valueInput[counter]);
  } // end for
} // end updateOutputSliderValue;

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
