/*
Constants and functions defining the number of panels required to reach each level
and various helper functions to access these values
*/

int maxPanels = 100000;

List levelToPanels = [
  0,
  1,
  3,
  8,
  15,
  25,
  37,
  51,
  67,
  87,
  115,
  147,
  185,
  227,
  273,
  325,
  385,
  455,
  535,
  625,
  725,
  845,
  985,
  1130,
  1300,
  1500,
  1800,
  2200,
  2600,
  3400,
  4400,
  5700,
  8000,
  10000,
  20000,
  50000,
  maxPanels
];
// e.g. level 2 (levelToPanels[2]) will return 3 panels
// TODO: find ideal difficulty curve (e^x?) and make this a generator

int panelsToLevel(numPanels) {
  // Function to return the current level given the number of panels
  var currentLevel = 0;
  for (int i = 0; i < levelToPanels.length - 1; i++) {
    if (levelToPanels[i] <= numPanels && numPanels < levelToPanels[i + 1]) {
      currentLevel = i;
      break;
    } else if (numPanels >= maxPanels) {
      currentLevel = levelToPanels.length - 1;
      break;
    }
  }
  return currentLevel;
}
