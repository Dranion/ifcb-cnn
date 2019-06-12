# About Net Save Files 

These are different neural networks that I've trained as I test different options, etc. As of 6/12/19, they are saved using:
> save(savelocation, 'net', 'YPred', 'YValidation', 'matchingImages')

Where net, YPred, YValidation, and matchingImages are saved. The net should contain info on the settings that went into training the net, whereas YPred and YValidation contain the net's classifications and the manual classifications respectively. This allows calculating accuracy, etc. matchingImages indicates the file location of the images that the net was run on. 

You can load these files back into Matlab using OPEN, and the variables should appear in the workspace. You could then use the net to classify more images, etc. 
