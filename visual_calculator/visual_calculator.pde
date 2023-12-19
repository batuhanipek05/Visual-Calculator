PImage image, img, img2;

ArrayList<Blob> blobs = new ArrayList<Blob>();

ArrayList<PImage> dataImages = new ArrayList<PImage>();

PImage image5;
PImage image2;

int dataNum = 100;
int outputNum = 13;

byte[][] data = new byte[outputNum][];
byte[][] target = new byte[outputNum][];
float[][] ftarget = new float[outputNum * dataNum][outputNum];

//int[][] iTarget = new int[outputNum][dataNum];
//int[][] iData = new int[outputNum][dataNum];

NeuralNetwork2 nn;

PImage[][] images = new PImage[outputNum][dataNum];
float[][][] tData = new float[outputNum][dataNum][1600];

float[][] testData = new float[64][1600];
float[][] testTarget = new float[64][outputNum];

byte[][] testDataByte = new byte[64][];

training_data[] td = new training_data[dataNum * outputNum];
training_data[] testdata = new training_data[64];

PImage[] images2 = new PImage[64];

int num = 0;





void setup() {
  size(1920, 1080);

  for (int i = 0; i < outputNum; i++) {
    data[i] = loadBytes(str(i) + "data.bin");
    target[i] = loadBytes(str(i) + "target.bin");
  }

  for (int i = 0; i < 64; i++) {
    testDataByte[i] = loadBytes("testdata/data" + str(i) + ".bin");
  }

  for (int i = 0; i < 64; i++) {
    images2[i] = createImage(40, 40, ALPHA);
    images2[i].loadPixels();
    for (int j = 0; j < outputNum; j++) {
      if (int(testDataByte[i][testDataByte[i].length - 1]) == j) {
        testTarget[i][j] = 1;
      } else {
        testTarget[i][j] = 0;
      }
    }

    for (int j = 0; j < 1600; j++) {
      testData[i][j] = int(testDataByte[i][j]);
      images2[i].pixels[j] = color(int(testDataByte[i][j]));
    }
  }

  for (int i = 0; i < testdata.length; i++) {
    testdata[i] = new training_data();
    testdata[i].set_data(testData[i], testTarget[i]);
  }

  nn = new NeuralNetwork2(1600, 256, outputNum, 3);

  for (int i = 0; i < td.length; i++) {
    td[i] = new training_data();
  }

  for (int i = 0; i < target.length; i++) {
    for (int y = 0; y < dataNum; y++) {
      for (int j = 0; j < outputNum; j++) {
        if (j == int(target[i][y])) {
          ftarget[i * dataNum + y][j] = 1;
        } else {
          ftarget[i * dataNum + y][j] = 0;
        }
      }
    }
  }



  for (int n = 0; n < outputNum; n++) {
    for (int i = 0; i < dataNum; i++) {
      images[n][i] = createImage(40, 40, ALPHA);
      images[n][i].loadPixels();
      // float[] tData = new float[images[n][i].pixels.length];
      for (int ii = 0; ii < images[n][i].pixels.length; ii++) {
        images[n][i].pixels[ii] = color(int(data[n][i * data[n].length / dataNum + ii]));
      }
      images[n][i].updatePixels();
    }
  }

  for (int i = 0; i < images.length; i++) {
    for (int ii = 0; ii < images[i].length; ii++) {
      for (int iii = 0; iii < images[i][ii].pixels.length; iii++) {
        tData[i][ii][iii] = red(images[i][ii].pixels[iii]);
      }
      td[i * images[i].length + ii].set_data(tData[i][ii], ftarget[i * images[i].length + ii]);
    }
  }

  nn.layers[0].setActivationFunction(2);
  nn.layers[1].setActivationFunction(2);
  nn.loadWeights("inputWieghts.bin", "hiddenWieghts.bin", "ouputWieghts.bin");

  //println(nn.test(td), nn.test(testdata));

  image = loadImage("test.JPG");
  //println(image.height);
  image.resize(960, 540);
  img = createImage(image.width, image.height, ALPHA);
  img2 = createImage(image.width, image.height, ALPHA);
  image2 = createImage(img.width, img.height, ALPHA);


  image.loadPixels();
  img.loadPixels();


  for (int i = 0; i < image.pixels.length; i++) {
    float r = red(image.pixels[i]);
    float g = green(image.pixels[i]);
    float b = blue(image.pixels[i]);

    float a = (r + g + b) / 3;

    image.pixels[i] = color(a);
  }

  float treshold = 16;
  for (int y = 1; y < img.height-1; y++) {
    for (int x = 1; x < img.width-1; x++) {
      int loc = x + y * img.width;
      if (abs(red(image.pixels[loc]) - red(image.pixels[loc + 1])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc - 1])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc + image.width])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc - image.width])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc + image.width + 1])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc + image.width - 1])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc - image.width + 1])) > treshold ||
        abs(red(image.pixels[loc]) - red(image.pixels[loc - image.width - 1])) > treshold) {
        img.pixels[loc] = color(255);
      } else {
        img.pixels[loc] = color(0);
      }
    }
  }
  for (int y = 1; y < img.height-1; y++) {
    for (int x = 1; x < img.width-1; x++) {
      int loc = x + y * img.width;
      if (abs(red(img.pixels[loc]) - red(image.pixels[loc + 1])) == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc - 1]))  == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc + img.width]))  == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc - img.width]))  == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc + img.width + 1]))  == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc + img.width - 1]))  == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc - img.width + 1]))  == 0 &&
        abs(red(image.pixels[loc]) - red(image.pixels[loc - img.width - 1]))  == 0) {
        img.pixels[loc] = color(0);
      }
    }
  }

  float multiplier = 1.0/165;

  float[][] filter4 = {
    {1, 4, 7, 4, 1}, 
    {4, 16, 26, 16, 4}, 
    {7, 26, 41, 26, 7}, 
    {4, 16, 26, 16, 4}, 
    {1, 4, 7, 4, 1}, };


  multiplier = 1.0 / 180;

  image2 = kernelFilter(img, filter4, multiplier);

  image5 = kernelFilter(img, filter4, multiplier);

  image2.loadPixels();
  image5.loadPixels();
  float colorTreshold = 100;
  float distTreshold = 10;

  for (int y = 0; y < image5.height; y++) {
    for (int x = 0; x < image5.width; x++) {
      int loc = x + y * image5.width;
      if (red(image5.pixels[loc]) > colorTreshold) {
        blobs.add(new Blob(x, y));
        image5.pixels[loc] = color(0);
        PVector[] dots = checkCorners(image5, x, y, colorTreshold);
        for (int i = 0; i < dots.length; i++) {
          blobs.get(blobs.size() -1).add(dots[i].x, dots[i].y);
        }
      }
    }
  }


  for (int i = 0; i < blobs.size(); i++) {
    Blob b = blobs.get(i);
    if (b.w <= 12 && b.h <= 12) {
      blobs.remove(i);
    }
  }

  image5.loadPixels();
  for (Blob b : blobs) {
    if (!(b.w <= 12 && b.h <= 12)) {
      PImage blobImage = createImage(int(b.w), int(b.h), ALPHA);
      blobImage.loadPixels();
      for (int y = int(b.y); y < int(b.y + b.h); y++) {
        for (int x = int(b.x); x < int(b.x + b.w); x++) {
          int loc = y * image5.width + x;
          int loc2 = (y - int(b.y)) * blobImage.width + (x-int(b.x));
          blobImage.pixels[loc2] = (image2.pixels[loc]);
        }
      }
      blobImage.updatePixels();
      image5.updatePixels();
      dataImages.add(resize2(blobImage, 40));
    }
  }
  // println(nn.test(td));
}


void draw() {
  background(120);

  image.updatePixels(); 
  img.updatePixels(); 
  image(image, 0, 0, image.width, image.height); 
  image(image2, 0, image.height);
  image(image5, image.width, image.height, image.width, image.height );
  image(dataImages.get(nume), image.width, 0, dataImages.get(nume).width*3, dataImages.get(nume).height*3);


  //println(array_max_index(nn.guess(datat)), nume);

  int aa = 0;
  for (int i = 0; i < blobs.size(); i++) {
    Blob b = blobs.get(i);
    if (!(b.w <= 12 && b.h <= 12)) {
      b.show();
      PImage blobimage = dataImages.get(aa);
      blobimage.loadPixels();
      float[] datat = new float[blobimage.pixels.length];
      for (int j = 0; j < blobimage.pixels.length; j++) {
        datat[j] = int(red(dataImages.get(aa).pixels[j]));
      }
      fill(255);
      textSize(16);
      blobs.get(i).setVal(array_max_index(nn.guess(datat)));
      text(str(array_max_index(nn.guess(datat))), b.x + b.w/2, b.y + b.h + b.h / 2);
      aa++;
      //println(aa);
    }
  }

  String s = "";
  for (int i = 0; i < image.width; i++) {
    for (Blob b : blobs) {
      if (!(b.w <= 12 && b.h <= 12)) {
        if (b.x == i) {
          s+=b.val;
          break;
        }
      }
    }
  }

  println(s + " = " + str(calculateString(s)));

  //String string;
  //int stringNum;
  //for (int i = 0; i < s.length(); i++) {
  //  if(s.charAt(i) == '+' || s.charAt(i) == '-' || s.charAt(i) == 'x'){
  //    for(int j = 0; j < i){

  //    }
  //  }
  //}

  noLoop();
} 

int nume = 0;
int a = 0;
void mousePressed() {
  a++;
  if (a == outputNum) {
    a = 0;
  }
}

void keyPressed() {
  nume++;
  if (nume == dataImages.size()) {
    nume = 0;
  }
}

PVector[] checkCorners(PImage img, int x, int y, float ct) {
  ArrayList<PVector> locations = new ArrayList<PVector>();
  img.loadPixels();
  for (int _y = -1; _y < 2; _y++) {
    for (int _x = -1; _x < 2; _x++) {
      int loc = x + _x + (y + _y) * img.width;
      if (y + _y < img.height - 1 && y + _y > -1 && 
        x + _x < img.width && x + _x > -1 && 
        x !=0 && y != 0 && red(img.pixels[loc]) > ct) {
        locations.add(new PVector(x + _x, y + _y));
        img.pixels[loc] = 0;
        PVector[] lcs = checkCorners(img, x + _x, y + _y, ct);
        for (int i = 0; i < lcs.length; i++) {
          locations.add(lcs[i]);
        }
      }
    }
  }

  PVector[] locs = new PVector[locations.size()]; 
  for (int i = 0; i < locations.size(); i++) {
    locs[i] = locations.get(i);
  }
  return locs;
}

PImage resize2(PImage img, int s) {
  int maxSize = max(img.width, img.height);
  PImage img2 = createImage(maxSize, maxSize, ALPHA); 
  img.loadPixels();
  img2.loadPixels();
  for (int y = 0; y < img2.height; y++) {
    for (int x = 0; x < img2.width; x++) {
      int loc = x + y * img2.width;
      img2.pixels[loc] = color(0);
    }
  }
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int loc1 = x + y * img.width;
      int loc2 = ((img2.width - img.width) / 2) + x + (((img2.height - img.height) / 2) + y) * img2.width;
      img2.pixels[loc2] = img.pixels[loc1];
    }
  }

  img.updatePixels();
  img2.updatePixels();
  img2.resize(s, s);
  return img2;
}

float calculateString(String str) {
  String string = " " + str + " ";
  char[] ops = {'+', '-', ' '};

  boolean foundX = true;
  String num1 = "", num2 = "", fnum = "", lnum = "";
  float n1 = 1, n2 = 1;
  while (foundX) {
    num1 = ""; 
    num2 = ""; 
    fnum = ""; 
    lnum = "";
    foundX = false;
    for (int i = 0; i < string.length(); i++) {
      if (string.charAt(i) == 'x') {
        foundX = true;
        for (int j = i - 1; j > -1; j--) {
          boolean f = false;
          for (int k = 0; k < ops.length; k++) {
            if (string.charAt(j) == ops[k]) {

              num1 = new StringBuilder(num1).reverse().toString();
              if (string.charAt(j) == '-') {
                n1 = -float(num1);
              } else {
                n1 = float(num1);
              }
              f = true;
              for (int l = j; l > -1; l--) {
                fnum += string.charAt(l);
              }
              fnum = new StringBuilder(fnum).reverse().toString();
              j = -1;            
              break;
            }
          }
          if (!f) {
            num1 += string.charAt(j);
          }
        }
        for (int j = i + 1; j < string.length(); j++) {
          boolean f = false;
          for (int k = 0; k < ops.length; k++) {
            int multiplier = 1;
            if (string.charAt(j) == ops[k] && string.charAt(i + 1) != '-') {
              n2 = multiplier * float(num2);
              f = true;
              for (int l = j; l < string.length(); l++) {
                lnum += string.charAt(l);
              }
              j = string.length();
              break;
            }
            if(string.charAt(i + 1) == '-'){
               multiplier = -1;
            }else{
               multiplier = 1;
            }
          }
          if (!f) {
            num2 += string.charAt(j);
          }
        }

        string = fnum + str(n1 * n2) + lnum;
      }
    }
  }


  boolean foundsum = true;
  while (foundsum) {
    num1 = ""; 
    num2 = ""; 
    fnum = ""; 
    lnum = "";
    foundsum = false;
    for (int i = 0; i < string.length(); i++) {
      if (string.charAt(i) == '+' || string.charAt(i) == '-') {
        foundsum = true;
        for (int j = i - 1; j > -1; j--) {
          boolean f = false;
          for (int k = 0; k < ops.length; k++) {
            if (string.charAt(j) == ops[k]) {
              num1 = new StringBuilder(num1).reverse().toString();
              n1 = float(num1);
              f = true;
              for (int l = j; l > -1; l--) {
                fnum += string.charAt(l);
              }
              fnum = new StringBuilder(fnum).reverse().toString();
              j = -1;            
              break;
            }
          }
          if (!f) {
            num1 += string.charAt(j);
          }
        }
        for (int j = i + 1; j < string.length(); j++) {
          boolean f = false;
          for (int k = 0; k < ops.length; k++) {
            if (string.charAt(j) == ops[k]) {
              n2 = float(num2);
              f = true;
              for (int l = j; l < string.length(); l++) {
                lnum += string.charAt(l);
              }
              j = string.length();
              break;
            }
          }
          if (!f) {
            num2 += string.charAt(j);
          }
        }

        if (string.charAt(i) == '+') {
          string = fnum + str(n1 + n2) + lnum;
        } else if (string.charAt(i) == '-') {
          string = fnum + str(n1 - n2) + lnum;
        }
      }
    }
    //println(string);
  }
  return float(string);
}
