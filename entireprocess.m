function [ ] = testCNN(imagePath)
% testCNN  Runs a basic CNN . 
% net = testCNN(imagePath) create a basic CNN based on already
% pre-processed images 
% 
% Assumes sub-directories indicate classifications. All images must be
% pngs. Runs 4 epochs, CNN is currently based on MATLAB's example code for 
% MINST data set. 

% Puts images into datastore, with the folder names as the labels. 
imds = imageDatastore(imagePath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
 
%Check # of classes. 
labelCount = countEachLabel(imds);
disp(labelCount)
[min_vals, ~] = min(labelCount{:,2});
disp(min_vals)

%Check # of categories.  
S = dir(imagePath);

catnum = sum([S(~ismember({S.name},{'.','..'})).isdir]);

%Specify Training and Validation Sets. 80/20 split
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,0.2,'randomize');
aug = imageDataAugmenter(...
    'FillValue',200, ...
    'RandXReflection', 1, ...
    'RandYReflection', 1, ...
    'RandRotation', [-360, 360], ...
    'RandScale', [0.9 1.1], ...
    'RandXTranslation', [-5, 5], ...
    'RandYTranslation', [-5, 5] ...
    );
imgsize = [120 120 1];
imdsTrain = augmentedImageDatastore(imgsize, imdsTrain, 'DataAugmentation', aug);
imdsValidation = augmentedImageDatastore(imgsize, imdsValidation)
minibatch = read(imdsTrain);
imshow(imtile(minibatch.input))
%Define Network Architecture. Not optimized at all 
layers = [
    imageInputLayer(imgsize)
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(max(catnum, 2))
    softmaxLayer
    classificationLayer];

%Specify training options. Not optimized at all. 
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',true, ...
    'Plots','training-progress');

%Now train the net!
net = trainNetwork(imdsTrain,layers,options);
%Now validate the net! 
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

% Displays graphs for accuracy. 
accuracy = sum(YPred == YValidation)/numel(YValidation);
disp(accuracy)