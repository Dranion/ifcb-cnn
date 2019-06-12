MATLAB code for running ifcb images through a cnn. Very much in progress. 

## General workflow 
#### Grabbing images 
This repo assumes that you're working with the [ifcb-analysis toolkit](https://github.com/hsosik/ifcb-analysis) by hsosik and depends on file structure assumed from there. In particular, images are assumed to be kept in a folder with sub-folders indicating their classification. 
```
pngs
└─── classifiation (ie Alexandrium or something)
│   │   img.png
└─── classification 
    │   img.png
```
This is the structure that the [test data with products](https://github.com/hsosik/ifcb-analysis/wiki/Blob-extraction,-feature-extraction,-and-classifier-application#access-to-test-data-and-products) comes with, along with the file structure that [export_png_manual_fromROI.m](https://github.com/hsosik/ifcb-analysis/blob/master/IFCB_tools/export_png_manual_fromROI.m) outputs. 

### Pre-processing and Image Augmentation
Pre-processing is currently done using Matlab's augmentedImageDatastore as a part of entireprocess.m. Nothing special needs to be run to do it. 

### Running the CNN
Its super easy! Just point it at wherever you've output all your processed images. 
'''
entireprocess('C:\Users\holstein\Documents\IFCB Data\mirror\manual\pngs\')
'''
It will then grab the classes from the subdirectory structure, split the images randomly, with half for training and half for validation, and run a rudimentary CNN on them. Then it will output graphs. 

### Determing Outcomes
Every run of entireprocess.m generates a save file containing the net along with the predicated (YPred) and actual classifications (YValidation) of the validation set. This can be used to determine accuracy (# correct / all classifications) along with determine what particular classes the net does well with / suffers in. The net is also saved so it can be trained further or used for classification. 

