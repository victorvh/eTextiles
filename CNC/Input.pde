void keyPressed() {
  if (key == 'S' || key == 's') {
    printListToFile(initialValuesList, initialValueOutput);
    println("initial reading done");
  }
  
  
  if (key == 'C' || key == 'c') {
    //closeOutput(initialValueOutput);
    closeOutput(valueOutput);

    println("closed files");
  }

  if (key == 'R' || key == 'r') {
    arduinoPort.write("A");
    started = true;
  }

  if (key == 'H' || key == 'h') {
    CNC.write("$H\n");
  }

  if (key == 'P' || key == 'p') {
    CNCPort.write("G91\nG0\nX" + str(startPosition.x) + "\nY" + str(startPosition.y) + "\nZ" + str(startPosition.z) + "\n");
  }

  if (key == 32) {
    started = true;
    CNC.write("?");
  }

  if (keyCode == 33) {
    CNC.moveMachine(0, 0, 0.1);
  }

  if (keyCode == 34) {
    CNC.moveMachine(0, 0, -0.1);
  }

  if (keyCode == 37) {
    CNC.moveMachine(-0.1, 0, 0);
  }

  if (keyCode == 38) {
    CNC.moveMachine(0, 0.1, 0);
  }

  if (keyCode == 39) {
    CNC.moveMachine(0.1, 0, 0);
  }

  if (keyCode == 40) {
    CNC.moveMachine(0, -0.1, 0);
  }
}