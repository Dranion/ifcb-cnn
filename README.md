# ifcb-cnn
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

### Pre-processing
Batch-preprocessing was generated using MATLAB's Batch Image app. Simply specify the in and out directory for the images. It runs the preprocessing function, also included here. This will pad images up to 120 x 120 pixels, square them just in case they're larger than that, and then make sure they're grey scale. 

### Pre-processing cont: Convolution Edition
To make the dataset bigger and more accurate I'm trying a couple things. Currently, all that I'm running is rotate_images. You should put it at the folder you output the pre-processed images into, and it create and write copies of the image at 90, 180, and 270 degrees. This makes our dataset bigger. 

### Running the CNN
Its super easy! Just point it at wherever you've output all your processed images. It will then grab the classes from the subdirectory structure, split the images randomly, with half for training and half for validation, and run a rudimentary CNN on them. Then it will output graphs. 

### Interpreting Graphs
[ ] Write this 

# TO DO 
##Short term 
- [ ] Create documentation for existing code 
- [ ] Validate on a non-rotated validation set 

##Long Term 
- [ ] Classify more things 
- [ ] Prepare for passing on project 
