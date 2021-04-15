# 3CB Software and Neural Network

This repo contains the three compartment breast (3CB) 
final trained neural network model used in the manuscript entitled "Dual-energy
three compartment breast imaging (3CB) for novel compositional biomarkers to
improve detection of malignant lesions", submitted to Nature publications in q1 2021.


[![DOI](https://zenodo.org/badge/348485528.svg)](https://zenodo.org/badge/latestdoi/348485528)


The neural network model takes 3CB derived features and CAD predicted probability of malignancy and outputs a new probability of malignancy.

---
## Requirements

### Hardware requirements

#### Minimum computational hardware ####
* 4 core CPU
* 8 gb of RAM
* Cuda enabled GPU (optional)

  Runtimes:
  * neural network prediction: < 10 seconds per 1000 ROIs  
  * demo runtime: < 1 minute

### Neural Network Model
- Python 3.6+, with recent versions of the following python packages:
    - cv2
    - matplotlib
    - numpy
    - pandas
    - scipy
    - seaborn
    - Keras
    - Tensorflow

### DICOM viewer
* Fiji/Imagej (optional)

---
## Repository folders

### Neural Network
* nn_model: final trained model referenced in manuscript
    * *tracked via git-lfs

### Demo ###
* example data and driver program to extract 3CB features and run NN predictions
---
## Neural Network Run Overview
```python:
# load scaler
sc=load('path to scaler *.bin')

# load and use model
from keras.models import Sequential, load_model
model=load_model("path to model *.h5")

```

---
## Contact

- Lambert Leong: [lambert3@hawaii.edu](lambertleong.com)
- Thomas Wolfgruber: [tomwolf@hawaii.edu](tomwolf@hawaii.edu)
- John Shepherd: [johnshep@hawaii.edu ](johnshep@hawaii.edu )

---
