import processing.serial.*;

Serial arduinoPort;
Serial CNCPort;

CNCMachine CNC;

// Arduino serial port dump
String rawIncomingValues; 

int[] incomingValues = { 0, 0, 0, 0, 0 };     

// 10 is the linefeed number in ASCII
int token = 10;
// you can replace it with whatever symbol marks the end of your line (http://www.ascii-code.com/)
boolean connectionEstablished = false;

// this is the function that receives and parses the data
// it executes whenever data is received 
void serialEvent(Serial serialPort) { 
  if (serialPort == arduinoPort) {
    if (started) {
      // we read the incoming data until we have found our token (its defined at the top, but can be any character)
      rawIncomingValues = serialPort.readStringUntil(token);
      // if there actually is a valid incoming value, we use the splitTokens
      // this splits the incoming string into an array of integers that is easy to work with
      if (rawIncomingValues != null) {
        incomingValues = int(splitTokens(rawIncomingValues, ", "));

        connectionEstablished = true;

        CNC.step(stepLength, stepAmount, rowAmount, pressureDepth[pressureNumber], subset(incomingValues, 0, 5), valueOutput);
      }
      CNC.write("?");
    }
  } else if (serialPort == CNCPort) {
    String s = serialPort.readStringUntil('\n').trim();

    if (started && s.length() > 50) {
      if (s.substring(1, 5).equals("Idle")) {
        idleCount++;
      }
    }

    if (idleCount > 20) {
      idleCount = 0;
      arduinoPort.write("A");
    } else {
      CNC.write("?");
    }
    //println(subset(incomingValues, 0, 5)[0]);
    //println(s);
  }
} 


void setup() {
  size(200, 200); 

  //------------here we specify which port our program should listen to

  // List all the available serial ports
  println("these are the available ports: ");
  printArray(Serial.list());


  //chose your serial port, by putting the correct number in the square brackets 
  //you might need to just trial and error this, the first time you do it
  String serialPort = Serial.list()[1];
  String SerialCNCPort = Serial.list()[2];

  delay(1000);
  //check if you are using the port you think you are using
  println("You are using this port: " + serialPort);

  // Open the port with the same baud rate you set in your arduino
  arduinoPort = new Serial(this, serialPort, 9600);
  CNCPort = new Serial(this, SerialCNCPort, 115200);

  // Data to 
  initialValueOutput = createWriter("test.txt");

  valueOutput = createWriter("test" + str(pressureNumber + 1) + ".txt");

  // Setup of the CNC machine
  CNCPort.bufferUntil('\n');

  CNC = new CNCMachine(CNCPort);

  delay(2000);
  CNC.write("$X\n");
  CNC.write("G21\n");
}
// CNC config start
PVector startPosition = new PVector(13.0, 45.0, -66.5);
float[] pressureDepth = {-1, -1.4, -3.0};

int pressureNumber = 0;

PrintWriter valueOutput;

float stepLength = 2.0;

int stepAmount = 27;
int rowAmount = 14;

boolean started = false;
int idleCount = 0;
// CNC config end


PrintWriter initialValueOutput;

int threshold = 300;

ArrayList<int[]> initialValuesList = new ArrayList<int[]>();
ArrayList<int[]> interpolatedValuesList = new ArrayList<int[]>();

int numberOfLayers = 1;
int numberOfReadings = 0;

void draw() {

  /*
  // incomingValues will have the length of 5 instead of 6 
   // if the arduino haven't sent the data to processing yet
   if (incomingValues.length <= 5) return;
   
   // might cause ArrayIndexOutOfBOundsException. Close program and run again
   int[] values = subset(incomingValues, 0, 5);
   
   if (initialValuesList.size() == 0) {
   initialValuesList.add(values);
   
   for (int i = 1; i <= numberOfLayers; i++) {
   initialValuesList.add(interpolate(initialValuesList.get(i - 1)));
   }
   }
   
   interpolatedValuesList.clear();
   interpolatedValuesList.add(values);
   //println(interpolatedValuesList.get(0)[0]);
   //CNCPort.write("?");
   
   for (int i = 1; i < numberOfLayers; i++) {
   interpolatedValuesList.add(interpolate(interpolatedValuesList.get(i - 1)));
   }
   
   int boxWidth = (width - 100) / 5;
   for (int i = 0; i < numberOfLayers; i++) {
   boxWidth = renderLayer(interpolatedValuesList.get(i), initialValuesList.get(i), i * 70, 60, boxWidth, i);
   }*/
}