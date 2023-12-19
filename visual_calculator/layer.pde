class Layer {

  Neuron[] neurons;

  activation_functions af;

  float lr = 0.1;
  float[] outputs;
  float[] inputs;
  float[] errors;
  float[] b_errors;

  float[][] dw;

  int back_num;

  int num;
  int i_num;

  Layer(int inum, int nm) {
    num = nm;
    i_num = inum;

    //float[][][] changes;

    outputs = new float[num];
    inputs = new float[inum];
    errors = new float[num];

    dw = new float[num][inum];

    af = new activation_functions();

    neurons = new Neuron[num];
    for (int i = 0; i < num; i++) {
      neurons[i] = new Neuron(i_num);
    }
  }
  float[] guess(float[] inps) {
    for (int i = 0; i < outputs.length; i++) {
      outputs[i] = neurons[i].think(inps);
    }
    return outputs;
  }

  void train(float[] input_array, float[] error_array) {
    b_errors = new float[input_array.length];
    float[] target = new float[error_array.length];
    float[] err = new float[error_array.length];

    for (int i = 0; i < neurons.length; i++) {
      outputs[i] = neurons[i].think(input_array);
    }

    // println(outputs.length, error_array.length);
    target = addR(outputs, error_array);

    //for (int i = 0; i < error_array.length; i++) {
    //  target[i] = outputs[i] + error_array[i];
    //}

    for (int a = 0; a < neurons.length; a++) {
      for (int j = 0; j < neurons[a].w.length; j++) {
        neurons[a].w[j] += error_array[a] * 
          af.der(outputs[a]) * 
          neurons[a].i[j] * lr;
      }
    }

    for (int i = 0; i < neurons.length; i++) {
      outputs[i] = neurons[i].think(input_array);
    }

    err = substract(target, outputs);

    for (int a = 0; a < b_errors.length; a++) {
      b_errors[a] = 0;
      for (int j = 0; j < neurons.length; j++) {
        b_errors[a] += err[j] * 
          af.der(outputs[j]) * 
          neurons[j].w[a] * lr;
      }
      b_errors[a] = b_errors[a] / neurons.length - 1;
    }
  }

  void trainTarget(float[] input_array, float[] target_array) {
    b_errors = new float[input_array.length];
    float[] err = new float[target_array.length];

    for (int i = 0; i < neurons.length; i++) {
      outputs[i] = neurons[i].think(input_array);
    }

    err = substract(target_array, outputs);

    for (int a = 0; a < neurons.length; a++) {
      for (int j = 0; j < neurons[a].w.length; j++) {
        neurons[a].w[j] += err[a] * 
          af.der(outputs[a]) * 
          neurons[a].i[j] * lr;
      }
    }

    for (int i = 0; i < neurons.length; i++) {
      outputs[i] = neurons[i].think(input_array);
    }

    err = substract(target_array, outputs);

    for (int a = 0; a < b_errors.length; a++) {
      b_errors[a] = 0;
      for (int j = 0; j < neurons.length; j++) {
        b_errors[a] += err[j] * 
          af.der(outputs[j]) * 
          neurons[j].w[a] * lr;
      }
      b_errors[a] = b_errors[a] / neurons.length - 1;
    }
  }

  void train(float[] error_array) {
    for (int a = 0; a < neurons.length; a++) {
      for (int j = 0; j < neurons[a].w.length; j++) {
        neurons[a].w[j] += error_array[a] * 
          af.der(outputs[a]) * 
          neurons[a].i[j] * lr;
      }
    }
  }

  void calError(float[] input_array, float[] error_array) {
    b_errors = new float[input_array.length];
    for (int a = 0; a < b_errors.length; a++) {
      b_errors[a] = 0;
      for (int j = 0; j < neurons.length; j++) {
        b_errors[a] += error_array[j] * 
          af.der(outputs[j]) * 
          neurons[j].w[a] * lr;
      }
      b_errors[a] = b_errors[a] / neurons.length;
    }
  }

  void setActivationFunction(int a) {
    af.setFunction(a);
  }

  //void train2(float[] input_array, float[] error_array, int bn) {
  //  b_errors = new float[bn];
  //  float[] target = new float[error_array.length];
  //  float[] err = new float[error_array.length];

  //  for (int i = 0; i < neurons.length; i++) {
  //    outs[i] = neurons[i].think(input_array);
  //  }

  //  for (int i = 0; i < error_array.length; i++) {
  //    target[i] = outs[i] + error_array[i];
  //  }

  //  for (int a = 0; a < dw.length; a++) {
  //    for (int j = 0; j < dw[a].length; j++) {
  //      dw[a][j] += error_array[a] * 
  //        af.d_sigmoid1(outs[a]) * 
  //        neurons[a].i[j] * lr;
  //    }
  //  }

  //  for (int i = 0; i < neurons.length; i++) {
  //    outs[i] = neurons[i].think(input_array);
  //  }

  //  for (int i = 0; i < error_array.length; i++) {
  //    err[i] = target[i] - outs[i];
  //  }

  //  for (int a = 0; a < b_errors.length; a++) {
  //    b_errors[a] = 0;
  //    for (int j = 0; j < neurons.length; j++) {
  //      b_errors[a] += error_array[j] * 
  //        af.d_sigmoid1(outs[j]) * 
  //        neurons[j].w[a] * lr;
  //    }
  //    b_errors[a] = b_errors[a] / neurons.length;
  //  }
  //}
  //void inputTrain(float[] input_array, float[] error_array, int bn) {
  //  b_errors = new float[input_array.length];

  //  for (int i = 0; i < neurons.length; i++) {
  //    outs[i] = neurons[i].think(input_array);
  //  }
  //  for (int a = 0; a < b_errors.length; a++) {
  //    b_errors[a] = 0;
  //    for (int j = 0; j < neurons.length; j++) {
  //      b_errors[a] += error_array[j] * 
  //        af.d_sigmoid1(outs[j]) * 
  //        neurons[j].w[a] * lr;
  //    }
  //    b_errors[a] = b_errors[a] / neurons.length;
  //  }
  //}
}
