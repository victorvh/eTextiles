// returns an interpolated version an input array of values
int[] interpolate(int[] values) {
  int[] result = {values[0]};

  for (int i = 1; i < values.length; i++) {
    int a = values[i - 1];
    int b = values[i];
    result = append(result, (a + b) / 2);
    result = append(result, b);
  }

  return result;
}

// smooths out noise when no pressure is applied and paints boxes in the blobs threshold green
color getColor(int value, int initialValue) {
  if (value <= threshold) {
    return color(0, 255, 0);
  }

  return color(map(value, 0, initialValue, 0, 255));
}

int renderLayer(int[] layer, int[] initialValues, int y, int boxHeight, int boxWidth, int layerNumber) {
  Blob blob = new Blob();
  int layerWidth = boxWidth * layer.length;
  int layerMargin = (width - layerWidth) / 2;

  // draw the layer and add items under threshold to the blob
  for (int i = 0; i < layer.length; i++) {
    int boxX = boxWidth * i + layerMargin;

    fill(getColor(layer[i], initialValues[i]));
    rect(boxX, y, boxWidth, boxHeight);

    blob.addTo(layer[i], boxX + boxWidth / 2, threshold);
  }

  // draw center of mass of blob
  if (blob.exists()) {
    fill(255, 0, 255);
    ellipse(blob.centerOfMass(), y + boxHeight / 2, 10, 10);
  }

  // static width
  return (width - 100) / ((layer.length * 2) - 1);

  // dynamic width
  //return boxWidth / 2;
}

void printListToFile(ArrayList<int[]> list, PrintWriter output) {
  for (int i = 0; i < list.size(); i++) {
    output.print(i + ": ");

    int[] arr = list.get(i);
    for (int j = 0; j < arr.length; j++) {
      if (j == arr.length - 1) {
        output.print(arr[j]);
      } else {
        output.print(arr[j] + ", ");
      }
    }

    output.println();
  }
  output.println("@");
}

void printArrayToFile(int[] list, PrintWriter output) {

  for (int i = 0; i < list.length; i++) {

    if (i == list.length - 1) {
      output.print(list[i]);
    } else {
      output.print(list[i] + ", ");
    }
  }

  output.println();
}


void closeOutput(PrintWriter output) {
  output.flush();
  output.close();
}