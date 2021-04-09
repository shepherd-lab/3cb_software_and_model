# 3CB Software and Neural Network

This repo contains the three compartment breast (3CB) software and
final trained neural network model used in the manuscript entitled "Dual-energy
three compartment breast imaging (3CB) for novel compositional biomarkers to
improve detection of malignant lesions", submitted to Nature publications in q1 2021.


[![DOI](https://zenodo.org/badge/348485528.svg)](https://zenodo.org/badge/latestdoi/348485528)


The 3CB software converts fully registered high and low energy mammograms to lipid, water, and protein compositional thickness maps. Base software is written for Matlab 2016.


The neural network model takes 3CB derived features and CAD predicted probability of malignancy and outputs a new probability of malignancy.

---
## Requirements

### Hardware requirements

#### 3CB imaging ####
* Aluminum X-ray filter
* [SXA Paddle Phantom](documentation/sxa_paddle_phanotm.png)
* [3CB Calbiration Phantom](documentation/calibration-phantom_3cb.png)

#### Minimum computational hardware ####
* 4 core CPU
* 8 gb of RAM
* Cuda enabled GPU (optional)

  Runtimes:
  * 3CB software installation: < 1 minute
  * 3CB thickness map generation: < 1 minute per patient
  * neural network prediction: < 10 seconds per 1000 ROIs  

### 3CB software
* Microsoft SQL Server Management Studio
* MATLAB 2016b

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

### 3CB
* 00_DB_SQL: Database initialization and run code
* 01_TD_SXA: Thickness and density maps calculation code
* 02_3C_SXA_DXA: 3-component maps generation code

### Neural Network
* nn_model: final trained model referenced in manuscript
    * *tracked via git-lfs

---

## 3CB Run Overview

Processing occurs in two major stages: 1) generate thickness and density maps and 2) generate 3-component maps.
Stage 1 results are used to get stage 2 results. Stage 1 can be run using Single Energy X-ray Absorptiometry (SXA)
to get thickness and density maps alone.

Acquisition DICOMs must be pre-processed and a database must be initialized.

Stage 1 is run in two modes - calibration and validation. First, calibration is run followed by validation using
a calibration phantom subject. Subject images are processed in the validation mode.


### Database Init
1. [Database initialization](documentation/setup.md)
2. Database population <link>

### Processing
1. Pre-process DICOMs <link>
2. Generate thickness and density maps (a.k.a., SXA) <link>
3. Generate 3-component maps (a.k.a., SXA DXA 3CB) <link>

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
Notes:
- current 3cb version merged from shepherd-lab/3cb, "beta_bh" branch
