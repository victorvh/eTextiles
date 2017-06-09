class CNCMachine {
  Serial CNCPort;
  int count = 0;
  int stepCase;
  int stepNumber;
  int rowNumber;

  CNCMachine(Serial init_CNCPort) {
    CNCPort = init_CNCPort;
    stepCase = 0;
    stepNumber = 0;
    rowNumber = 0;
  }

  void moveMachine(float x, float y, float z) {
    CNCPort.write("G91\nG0\nX" + str(x) + "\nY" + str(y) + "\nZ" + str(z) + "\n");
  }

  void write(String str) {
    CNCPort.write(str);
  }

  void nextStep() {
    stepCase++;
    stepCase = stepCase % 5;
  }

  void step(float stepLength, int stepAmount, int rowAmount, float stepDepth, int[] measurements, PrintWriter output) {
    switch(stepCase) {
    case 0:
      nextStep();
      stepDown(stepDepth);
      break;
    case 1:
      nextStep();
      measure(measurements, output);
      break;
    case 2:
      nextStep();
      stepUp(stepDepth);
      break;
    case 3:
      nextStep();
      sideStep(stepLength);
      stepNumber++;
      break;
    case 4:
      nextStep();
      moveRow(stepLength, stepAmount, rowAmount, output);
      break;
    }
  }

  void stepDown(float stepDepth) {
    moveMachine(0, 0, stepDepth);
  }

  void measure(int[] measurements, PrintWriter output) {
    println("reading " + str(++count) + " out of " + str((stepAmount + 1) * (rowAmount + 1)));
    printArrayToFile(measurements, output);
    moveMachine(0, 0, 0);
  }

  void stepUp( float stepDepth) {
    moveMachine(0, 0, -stepDepth);
  }

  void sideStep(float stepLength) {
    moveMachine(stepLength, 0, 0);
  }

  void moveRow(float stepLength, int stepAmount, int rowAmount, PrintWriter output) {
    if (stepNumber > stepAmount) {
      stepNumber = 0;
      rowNumber++;
      moveMachine(-(stepLength * (stepAmount + 1)), stepLength, 0);
    }

    if (rowNumber > rowAmount) {
      closeOutput(output);
      exit();
    }
  }
}