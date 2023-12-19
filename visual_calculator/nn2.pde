class NeuralNetwork2 {
  int inum;
  int h_num;
  int hn_num;
  int ol;

  float[][] layer_outs;
  float[] outputs;
  float[] inputs;
  float[] errors;

  float score;

  float lr = 0.1;

  float[] TrainInputs;

  Layer[] layers;

  activation_functions af;

  NeuralNetwork2(int i_layer, int hidden_neuron, int o_layer, int hidden_num) {
    inum = i_layer;
    h_num = hidden_num;
    hn_num = hidden_neuron;
    ol = o_layer;
    layer_outs = new float[hidden_num][hn_num];

    errors = new float[ol];
    outputs = new float[ol];
    inputs = new float[inum];
    TrainInputs = new float[inum];

    for (int i = 0; i < TrainInputs.length; i++) {
      TrainInputs[i] = random(0, 1);
    }


    layers = new Layer[hidden_num];
    if (h_num == 1) {
      layers[0] = new Layer(inum, o_layer);
    } else {
      layers[0] = new Layer(inum, hidden_neuron);
      if (h_num > 2) {
        for (int i = 1; i < layers.length - 1; i++) {
          layers[i] = new Layer(hidden_neuron, hidden_neuron);
        }
      }
      layers[layers.length - 1] = new Layer(hidden_neuron, ol);
    }
    //println(layers[1].b_errors.length, layers[0].neurons.length);

    af = new activation_functions();
    //println(layers.length);
  }

  float[] guess(float[] input_array) {
    layers[0].guess(input_array);
    if (layers.length > 1) {
      for (int i = 1; i < layers.length; i++) {
        layers[i].guess(layers[i - 1].outputs);
      }
    }
    return layers[layers.length - 1].outputs;
  }

  void setLearningRate(float a) {
    lr = a;
  }

  //void train(float[] input_array, float[] target_array) {
  //  layers[0].guess(input_array);
  //  if (layers.length > 1) {
  //    for (int i = 1; i < layers.length; i++) {
  //      layers[i].guess(layers[i - 1].outputs);
  //    }
  //  }

  //  outputs = layers[layers.length - 1].outputs;

  //  errors = substract(target_array, outputs);

  //  // println(layers[0].outputs);
  //  if (layers.length == 1) {
  //    layers[0].train(input_array, errors);
  //  } else if (layers.length == 2) {
  //    layers[1].train(layers[0].outputs, errors);
  //    layers[0].train(input_array, layers[1].b_errors);
  //  } else {
  //    // layers[layers.length - 1].train(layers[layers.length - 2].outputs, errors);
  //    // for (int i = layers.length - 2; i > 0; i--) {
  //    //   layers[i].train(layers[i - 1].outputs, layers[i + 1].b_errors);
  //    // }
  //    // layers[0].train(input_array, layers[1].b_errors);
  //  }
  //} 

  void train(float[] input_array, float[] target_array) {
    layers[0].guess(input_array);
    if (layers.length > 1) {
      for (int i = 1; i < layers.length; i++) {
        layers[i].guess(layers[i - 1].outputs);
      }
    }

    outputs = layers[layers.length - 1].outputs;

    errors = substract(target_array, outputs);

    // println(layers[0].outputs);
    if (layers.length == 1) {
      layers[0].train(input_array, errors);
    } else if (layers.length == 2) {
      layers[1].calError(layers[0].outputs, errors);
      layers[0].train(input_array, layers[1].b_errors);
      layers[1].trainTarget(layers[0].outputs, target_array);
    } else {
      layers[layers.length - 1].calError(layers[layers.length - 2].outputs, errors);
      for (int i = layers.length - 2; i > 0; i--) {
        layers[i].calError(layers[i - 1].outputs, layers[i + 1].b_errors);
      }

      layers[0].train(input_array, layers[1].b_errors);

      for (int i = 1; i < layers.length; i++) {
        layers[i].guess(layers[i - 1].outputs);
      }

      outputs = layers[layers.length - 1].outputs;
      errors = substract(target_array, outputs);

      for (int i = 1; i < layers.length - 1; i++) {
        layers[layers.length - 1].calError(layers[layers.length - 2].outputs, errors);
        for (int j = layers.length - 2; j > i - 1; j--) {
          layers[j].calError(layers[j - 1].outputs, layers[j + 1].b_errors);
        }

        layers[i].train(layers[i - 1].outputs, layers[i + 1].b_errors);

        for (int j = i + 1; j < layers.length; j++) {
          layers[j].guess(layers[j - 1].outputs);
        }

        outputs = layers[layers.length - 1].outputs;
        errors = substract(target_array, outputs);
      }
      layers[layers.length - 1].trainTarget(layers[layers.length - 2].outputs, target_array);
    }
  }

  void saveWeights() {
    byte[] inputWeights = new byte[layers[0].neurons.length * layers[0].neurons[0].w.length * 4];
    //println(inputWeights.length, (layers[0].neurons.length - 1) * layers[0].neurons[0].w.length * 4 + (layers[0].neurons[0].w.length - 1) * 4 + 3 );
    for (int i = 0; i < layers[0].neurons.length; i++) {
      for (int j = 0; j < layers[0].neurons[i].w.length; j++) {
        byte[] a = floatToByteArray(layers[0].neurons[i].w[j]);
        for (int k = 0; k < 4; k++) {
          inputWeights[i * layers[0].neurons[0].w.length * 4 + j * 4 + k] = a[k];
        }
      }
    }
    saveBytes("inputWieghts.bin", inputWeights);
    if (layers.length > 2) {
      byte[] hiddenWeights = new byte[(layers.length-2) * layers[1].neurons.length * layers[1].neurons[0].w.length * 4];
      for (int i = 1; i < layers.length - 1; i++) {
        for (int j = 0; j < layers[i].neurons.length; j++) {
          for (int k = 0; k < layers[i].neurons[j].w.length; k++) {
            byte[] a = floatToByteArray(layers[i].neurons[j].w[k]);
            for (int l = 0; l < 4; l++) {
              hiddenWeights[(i - 1) * layers[i].neurons.length * layers[i].neurons[j].w.length * 4 +
              j * layers[i].neurons[j].w.length * 4 + k * 4 + l] = a[l];
            }
          }
        }
      }
      saveBytes("hiddenWieghts.bin", hiddenWeights);
    }
    byte[] outputWeights = new byte[layers[layers.length - 1].neurons.length * layers[layers.length - 1].neurons[0].w.length * 4];
    for (int i = 0; i < layers[layers.length - 1].neurons.length; i++) {
      for (int j = 0; j < layers[layers.length - 1].neurons[i].w.length; j++) {
        byte[] a = floatToByteArray(layers[layers.length - 1].neurons[i].w[j]);
        for (int k = 0; k < 4; k++) {
          outputWeights[i * layers[layers.length - 1].neurons[0].w.length * 4 + j * 4 + k] = a[k];
        }
      }
    }
    saveBytes("ouputWieghts.bin", outputWeights);
  }

  void loadWeights(String iWeights, String hWeights, String oWeights) {

    byte[] inputWeights = loadBytes(iWeights);
    for (int i = 0; i < layers[0].neurons.length; i++) {
      for (int j = 0; j < layers[0].neurons[i].w.length; j++) {
        float a;
        byte[] b = new byte[4];
        for (int k = 0; k < b.length; k++) {
          b[k] = inputWeights[i * layers[0].neurons[i].w.length * 4 + j * 4 + k];
        }
        a = byteArrayToFloat(b);
        layers[0].neurons[i].w[j] = a;
      }
    }

    if (layers.length > 2) {
      byte[] hiddenWeights = loadBytes(hWeights);
      for (int i = 1; i < layers.length - 1; i++) {
        for (int j = 0; j < layers[i].neurons.length; j++) {
          for (int k = 0; k < layers[i].neurons[j].w.length; k++) {
            float a;
            byte[] b = new byte[4];
            for (int l = 0; l < b.length; l++) {
              b[l] = hiddenWeights[(i - 1) * layers[i].neurons.length * layers[i].neurons[j].w.length * 4 
                + j * layers[i].neurons[j].w.length * 4
                + k * 4 + l];
            }
            a = byteArrayToFloat(b);
            layers[i].neurons[j].w[k] = a;
          }
        }
      }
    }
    byte[] outputWeights = loadBytes(oWeights);
    for (int i = 0; i < layers[layers.length - 1].neurons.length; i++) {
      for (int j = 0; j < layers[layers.length - 1].neurons[layers.length - 1].w.length; j++) {
        float a;
        byte[] b = new byte[4];
        for (int k = 0; k < b.length; k++) {
          b[k] = outputWeights[i * layers[layers.length - 1].neurons[i].w.length * 4 + j * 4 + k];
        }
        a = byteArrayToFloat(b);
        layers[layers.length - 1].neurons[i].w[j] = a;
      }
    }
  }

  float test(training_data[] td) {
    float sum = 0;
    for (int tt = 0; tt < td.length; tt++) {
      layers[0].guess(td[tt].data);
      if (layers.length > 1) {
        for (int i = 1; i < layers.length; i++) {
          layers[i].guess(layers[i - 1].outputs);
        }
      }
      outputs = layers[layers.length - 1].outputs;
      if (array_max_index(outputs) == array_max_index(td[tt].target)) {
        sum++;
      }
    }
    float rate = sum / td.length;
    score = rate;
    return rate;
  }

  void mutate(float rate) {
    for (int k = 0; k < layers.length; k++) {
      for (int i = 0; i < layers[k].neurons.length; i++) {
        for (int j = 0; j < layers[k].neurons[i].w.length; j++) {
          if (random(0, 1) < rate) {
            layers[k].neurons[i].w[j] += random(-0.05, 0.05);
          }
        }
      }
    }
  }

  void mutateInput(float rate) {
    for (int i = 0; i < inum; i++) {
      if (random(0, 1) < rate) {
        TrainInputs[i] += random(-0.05, 0.05);
      }
    }
  }

  void weights(NeuralNetwork2 nn) {
    for (int i = 0; i < nn.layers.length; i++) {
      for (int j = 0; j < nn.layers[i].neurons.length; j++) {
        for (int k = 0; k < nn.layers[i].neurons[j].w.length; k++) {
          layers[i].neurons[j].w[k] = nn.layers[i].neurons[j].w[k];
        }
      }
    }
  }
}
class activation_functions {
  float sum;
  float num = 0;
  void setFunction(int nm) {
    num = nm;
  }

  float activate(float input) {
    if (num == 0) {
      sum = 1 / (1 + exp(-input));
      return sum;
    } else if (num == 1) {
      if (input < 0) {
        return 0;
      } else return input;
    } else if (num == 2) {
      if (input < 0) {
        return input * 0.01;
      } else return input;
    } else return sum;
  }
  float der(float input) {
    if (num == 0) {
      sum = input * (1 - input); 
      return sum;
    } else if (num == 1) {
      if (input > 0) {
        return 1;
      } else return 0;
    } else if (sum == 2) {
      if (input > 0) {
        return 1;
      } else return input * 0.01;
    } else return sum;
  }

  float sigmoid(float input) {
    sum = 1 / (1 + exp(-input));
    return sum;
  }
  float d_sigmoid1(float input) {
    sum = input * (1 - input); 
    return sum;
  }
  float i_sigmoid(float n) {
    return -log((1.0/n) - 1);
  }
  float reLU(float input) {
    if (input < 0) {
      return 0;
    } else return input;
  }
  float d_reLu(float input) {
    if (input > 0) {
      return 1;
    } else return 0;
  }
}
class Neuron {
  float[] w;
  float[] i;
  float bias = 1;
  int num;
  float ws;
  float as;

  activation_functions af;

  Neuron(int nm) {
    num = nm;
    w = new float[num + 1];
    i = new float[num + 1];

    af = new activation_functions();

    for (int a = 0; a < num; a++) {
      w[a] = random(-1, 1);
    }
  }
  float think(float[] inputs) {
    ws = 0;

    for (int a = 0; a < inputs.length; a++) {
      i[a] = inputs[a];
    }
    i[num] = bias;
    for (int a = 0; a < num; a++) {
      ws += w[a] * i[a];
    }
    as = af.sigmoid(ws);
    return as;
  }
}


class training_data {
  float[] data;
  float[] target;
  void set_data(float[] dt, float[] target_array) {
    data = new float[dt.length];
    target = new float[target_array.length];
    for (int i = 0; i < dt.length; i++) {
      data[i] = dt[i];
    }
    for (int i = 0; i < target_array.length; i++) {
      target[i] = target_array[i];
    }
  }
}
