void shuffle_int(int[] a)
{
  int temp;
  int pick;

  for (int i=0; i<a.length; i++)
  {
    temp = a[i];
    pick  = (int)random(a.length);
    a[i] = a[pick];
    a[pick]= temp;
  }
}

void shuffle_float(float[] a)
{
  float temp;
  int pick;

  for (int i = 0; i < a.length; i++)
  {
    temp = a[i];
    pick  = int(random(a.length));
    a[i] = a[pick];
    a[pick]= temp;
  }
}

void shuffle_training_data(training_data[] a)
{
  training_data temp;
  int pick;

  for (int i = 0; i < a.length; i++)
  {
    temp = a[i];
    pick  = int(random(a.length));
    a[i] = a[pick];
    a[pick]= temp;
  }
}

int array_max_index(float[] array) {
  float max = -9999999;
  int max_num = -1;
  for (int i = 0; i < array.length; i++) {
    if (array[i] > max) {
      max = array[i];
      max_num = i;
    }
  }
  return max_num;
}

float[] map_array(float[] array, float start, float end, float map_start, float map_end) {
  float[] mapped_array = new float[array.length];
  for (int i = 0; i < array.length; i++) {
    mapped_array[i] = map(array[i], start, end, map_start, map_end);
  }
  return mapped_array;
}

float[] red_pixels(color[] p) {
  float[] red = new float[p.length];

  for (int i = 0; i < p.length; i++) {
    red[i] = red(p[i]);
  }

  return red;
}

void nn_evolve(int num, NeuralNetwork2[] nn, training_data[] test) {
  float[] bs = new float[num]; 
  float[] scores = new float[nn.length];
  NeuralNetwork2[] nn2 = new NeuralNetwork2[nn.length];

  for (int i = 0; i < nn2.length; i++) {
    nn2[i] = new NeuralNetwork2(nn[i].inum, nn[i].h_num, nn[i].hn_num, nn[i].ol);
  }

  for (int i = 0; i < nn.length; i++) {
    scores[i] = nn[i].test(test);
  }
  scores = sort(scores);
  println(scores);
  for (int i = 0; i < bs.length; i++) {
    bs[i] = scores[scores.length - 1 - i];
  }
  println(".......///////////////.......");

  println(bs);
  int count = 1;
  for (int  i = 0; i < nn.length; i++) {
    for (int j = 0; j < bs.length; j++) {
      if (nn[i].score == bs[j]) {
        bs[j] = -99;
        for (int k = ((count - 1) * nn.length) / num; k < (count * nn.length) / num; k++) {
          nn2[k].weights(nn[i]);
        }
        count++;
      }
    }
  }
  for (int i = 0; i < nn2.length; i++) {
    nn2[i].mutate(0.5);
    nn[i].weights(nn2[i]);
  }
}


byte[] floatToByteArray(float value) {
  int intBits =  Float.floatToIntBits(value);
  return new byte[] {
    (byte) (intBits >> 24), (byte) (intBits >> 16), (byte) (intBits >> 8), (byte) (intBits) };
}

float byteArrayToFloat(byte[] bytes) {
  int intBits = 
    bytes[0] << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | (bytes[3] & 0xFF);
  return Float.intBitsToFloat(intBits);
}

PImage kernelFilter(PImage image, float[][] kernel, float multiplier) {
  PImage returnImage = createImage(image.width, image.height, ALPHA);
  PImage image2 = createImage(image.width + kernel[0].length - 1, image.height + kernel.length - 1, ALPHA);

  image.loadPixels();
  returnImage.loadPixels();
  image2.loadPixels();

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int loc = x + image.width * y;
      int loc2 = x + ((kernel[0].length - 1) / 2) + image2.width * (((kernel[0].length - 1) / 2) + y);
      image2.pixels[loc2] = image.pixels[loc];
    }
  }

  for (int y = 0; y < image2.height - kernel.length; y++) {
    for (int x = 0; x < image2.width -  kernel[0].length; x++) {
      int loc = x + y * image2.width; 
      float sum = 0; 
      float sum2 = 0; 

      for (int y2 = 0; y2 < kernel.length; y2++) {
        for (int x2 = 0; x2 < kernel[0].length; x2++) {
          int loc2 = x2 + image2.width * y2; 
          float a = (red(image2.pixels[loc + loc2]) +
            red(image2.pixels[loc + loc2]) + 
            red(image2.pixels[loc + loc2])) / 3; 
          sum += (kernel[y2][x2]) * a * multiplier; 
          //sum2 += -(filter[y2][x2] + filter2[y2][x2]) * a * multiplier;
        }
      }
      returnImage.pixels[x + y * returnImage.width] = color(abs(sum));
    }
  }
  image.updatePixels();
  returnImage.updatePixels();
  image2.updatePixels();


  return returnImage;
}


PImage maxPool(PImage img, int size) {
  PImage image = createImage(img.width / size, img.height / size, ALPHA);
  image.loadPixels();
  img.loadPixels();
  for (int y = 0; y < img.height; y += size) {
    for (int x = 0; x < img.width; x += size) {
      int loc = x + y * img.width;
      float max = 0;
      for (int y2 = 0; y2 < size; y2++) {
        for (int x2 = 0; x2 < size; x2++) {
          int loc2 = x2 + img.width * y2;
          if (red(img.pixels[loc + loc2]) > max) {
            max = red(img.pixels[loc + loc2]);
          }
        }
      }
      image.pixels[(x / size) + y * image.width / size] = color(max);
    }
  }

  return image;
}
