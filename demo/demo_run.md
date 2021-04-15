# demo_driver.py #

## Overview ##
 This is a demo driver programs that takes compiled 3 compartment breast data
 extracts compositional features from regions of interest (ROI), scales them
 appropriately, and uses a neural network to predict a probability of maligancy

### Files ###
1. patient_data.py - contains class and class functions for 3CB data structures
2. ROI.py - contain class and functions for region of interest data

 ### Input ###
 There are two 3CB demo inputs. Note, derivation of 3CB images require our calibration
 database and proprietary phantoms and software (not included). Therefore, example
 outputs from that program are provided in the demo_data/ directory. Example of the case
 presentaion and 3CB images are in demo_data/ dir suffixed .png.

 #### Files ####
1. fa_deid.mat - compiled 3CB data for a patient with a fibroadenoma
2. idc_deid.mat - compiled 3CB data for a patient with an invasive mass

#### arguments ####
* -i = path to input database
* -n = path to neural network and scaler models
* -o = path where outputs will be saved

### Output ###
Expected output files:
1. raw_3cb_feats.csv - 108 features extracted from 3CB data, raw values
2. scaled_3cb_feats.csv - Normalized and scaled 108 features extracted from 3CB data
3. nn_predictions.csv - Predictions with filename and biopsy pathology

### Run Example ###
```shellscript
python demo_driver.py -i demo_data/ -n ../neural_network/ -o outputs/
```
Refer to repo README for dependencies
