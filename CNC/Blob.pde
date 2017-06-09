class Blob {
  IntList values;
  IntList xValues;
  
  Blob() {
    values = new IntList();
    xValues = new IntList();
  }
  
  void addTo(int value, int xValue, int threshold) {
    if (value <= threshold || threshold == -1) {
      values.append(value); 
      xValues.append(xValue);
    }
  }
  
  int centerOfMass() {
    int massTimesX = 0;
    int mass = 0;
    
    for(int i = 0; i < values.size(); i++) {
      int blobValue = (threshold + 1 - values.get(i));
      massTimesX += blobValue * xValues.get(i);
      mass += blobValue;
    }
    
    return massTimesX / mass;
  }
  
  boolean exists() {
    if (values.size() == 0) {
      return false;
    }

    return true;
  }
}