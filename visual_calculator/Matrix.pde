
class Matrix {
  int row;
  int col;
  //float det;

  float[][] matrix;

  Matrix(int c, int r) {
    row = r;
    col = c;

    matrix = new float[row][col];
  }

  void equal(float[][] mat) {
    matrix = mat;
  }

  void multiply1(float num) {
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        matrix[i][j] *= num;
      }
    }
  }

  //void addCol(char c, float num) {
  //  float[][] mat = matrix;
  //  matrix = new float[mat.length][mat[0].length + 1];
  //  for (int i = 0; i < mat.length; i++) {

  //  }
  //}

  void multiplyMatrix(float[][] mat) {

    float[][] n = new float[matrix.length][matrix[0].length];

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[0].length; j++) {
        n[i][j] = matrix[i][j];
      }
    }
    for (int i = 0; i < n.length; i++) {
      for (int k = 0; k < matrix[i].length; k++) {
        float num = 0;
        for (int j = 0; j < n[i].length; j++) {
          num += n[i][j] * mat[j][k];
        }
        matrix[i][k] = num;
      }
    }
  }

  void flip() {
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (i - j > 0) {
          float num = matrix[i][j];
          matrix[i][j] = matrix[j][i];
          matrix[j][i] = num;
        }
      }
    }
  }

  void randomize(float a, float b) {
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        matrix[i][j] = random(a, b);
      }
    }
  }
}

float[][] array2mat(float[] n, int num) {
  float[][] mat = new float[num][num];

  for (int i = 0; i < num; i++) {
    for (int j = 0; j < num; j++) {
      mat[i][j] = n[i * num + j];
    }
  }
  return mat;
}

float calDet2(float[][] mat) {
  float det = mat[0][0] * mat[1][1] - mat[1][0] * mat[0][1];
  return det;
}

void printMat(float[][] mat) {
  for (int i = 0; i < mat.length; i++) {
    for (int j = 0; j < mat[i].length; j++) {
      print(mat[i][j], " ");
      //print(array2mat(n, 3)[i][j]," ");
    }
    println();
  }
}

float[] mutiplyMat1D(float[] m1, float[][] m2) {

  float[] mat = new float[m2.length];

  for (int i = 0; i < m2.length; i++) {
    float sum = 0;
    for (int j = 0; j < m1.length; j++) {
      sum += m1[j] * m2[i][j];
    }
    mat[i] = sum;
  }
  return mat;
}

float[][] inverse(float[][] matrix) {
  float[][] mat = new float[matrix.length][matrix[0].length];

  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      mat[i][j] = matrix[i][j];
    }
  }

  if (matrix.length == 2 && matrix[0].length == 2) {
    mat[0][0] = matrix[1][1];
    mat[1][1] = matrix[0][0];
    mat[1][0] = -mat[1][0];
    mat[0][1] = -mat[0][1];

    mat = multiply1(mat, 1 / calDet(matrix));
  } else {
    float det = calDet(mat);
    float[][] n = new float[mat.length * mat[0].length][(mat.length - 1) * (mat[0].length - 1)];
    for (int l = 0; l < mat.length; l++) {
      for (int k = 0; k < mat[0].length; k++) {
        int num = 0;
        for (int i = 0; i < mat.length; i++) {
          for (int j = 0; j < mat[i].length; j++) {
            if (!(j == k || i == l)) {
              n[l * mat.length + k][num] = mat[i][j];
              num++;
            }
          }
        }
      }
    }
    float a = 1;
    for (int i = 0; i < mat.length; i++) {
      for (int j = 0; j < mat[i].length; j++) {
        mat[i][j] = a * calDet(array2mat(n[i * mat.length + j], mat.length - 1));
        a = -a;
      }
    }
    mat = flipR(mat);
    mat = multiply1(mat, 1/det);
  }

  return mat;
}

float[][] multiply1(float[][] matrix, float num) {

  float[][] mat = new float[matrix.length][matrix[0].length];

  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      mat[i][j] = matrix[i][j];
    }
  }

  for (int i = 0; i < mat.length; i++) {
    for (int j = 0; j < mat[i].length; j++) {
      mat[i][j] *= num;
    }
  }
  return mat;
}

float calDet(float[][] mat) {
  float det = 0;
  if (mat.length == 2) {
    return calDet2(mat);
  } else {
    float[][] n = new float[mat[0].length][(mat.length - 1) * (mat[0].length - 1)];
    for (int k = 0; k < mat[0].length; k++) {
      int num = 0;
      for (int i = 0; i < mat.length; i++) {
        for (int j = 0; j < mat[i].length; j++) {
          if (!(j == k || i == 0)) {
            n[k][num] = mat[i][j];
            num++;
          }
        }
      }
    }
    float a = 1;
    for (int i = 0; i < n.length; i++) {
      det += a * calDet(array2mat(n[i], mat.length - 1)) * mat[0][i];
      //println(a * calDet(array2mat(n[i], mat.length - 1)) * mat[0][i]);
      a = -a;
    }
  }
  return det;
}

float[][] flipR(float[][] mat) {
  float[][] matrix = new float[mat.length][mat[0].length];
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      matrix[i][j] = mat[i][j];
    }
  }
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      if (i - j > 0) {
        float num = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = num;
      }
    }
  }
  return matrix;
}

void flip(float[][] matrix) {
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      if (i - j > 0) {
        float num = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = num;
      }
    }
  }
}

float[] solveEquation(float[][] input, float[] sums) {
  float[] sol = new float[sums.length];
  sol = mutiplyMat1D(sums, inverse(input)); 
  return sol;
}


class Vector {
  float[] vector;
}


void addV(float[] a, float[] b) {
  for (int i = 0; i < a.length; i++) {
    a[i] += b[i];
  }
}

float[] addR(float[] a, float[] b) {
  float[] c = new float[a.length];
  for (int i = 0; i < a.length; i++) {
    c[i] = a[i] + b[i];
  }
  return c;
}

float[] substract(float[] a, float[] b) {
  float[] c = new float[a.length];

  for (int i = 0; i < a.length; i++) {
    c[i] = a[i] - b[i];
  }
  return c;
}
