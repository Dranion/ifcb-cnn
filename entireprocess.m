function [ ] = entireprocess(imagePath)
% testCNN  Runs a basic CNN . 
% net = testCNN(imagePath) create a basic CNN based on already
% pre-processed images 
% 
% Assumes sub-directories indicate classifications. All images must be
% pngs. Runs 4 epochs, CNN is currently based on MATLAB's example code for 
% MINST data set. 

% Puts images into datastore, with the folder names as the labels. 
imds_all = imageDatastore(imagePath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% Get the total number of files in each folder.
T = countEachLabel(imds_all); % Total count in each folder
% See which folders have at least 20 files in them.
goodFolderRows = T.Count >= 20;

goodFolders = T.Label(goodFolderRows);
for i = 1:length(goodFolders)
    temp = string(goodFolders(i));
    goodFolders(i) = strcat(imagePath, temp);
end
strgoodFolders = string(goodFolders);
% Get a new datastore with only those folders with 20 or more files in them.
imds = imageDatastore(strgoodFolders,'IncludeSubfolders',false,'LabelSource','foldernames'); % All Sub folders with its labels. 
%Check # of classes. 
labelCount = countEachLabel(imds);
disp(labelCount)
[min_vals, ~] = min(labelCount{:,2});
disp(min_vals)

        

%catnum = sum([S(~ismember({S.name},{'.','..'})).isdir]); when getting all
%directories
catnum = i; % since only getting specific directories

%Specify Training and Validation Sets. 70/30 split
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,0.3,'randomize');
aug = imageDataAugmenter(...
    'FillValue',200, ...
    'RandXReflection', 1, ...
    'RandYReflection', 1, ...
    'RandScale', [0.9 1.1], ...
    'RandXTranslation', [-5, 5], ...
    'RandYTranslation', [-5, 5] ...
    );
%'RandRotation', [-360, 360], ...
imgsize = [120 120 1]; 
imdsTrain = augmentedImageDatastore(imgsize, imdsTrain, 'DataAugmentation', aug);
imdsValidationBackup = imdsValidation;
imdsValidation = augmentedImageDatastore(imgsize, imdsValidation);
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
options = trainingOptions('adam', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',40, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',100, ...
    'Verbose',true, ...
    'ValidationPatience',30, ...
    'Plots','training-progress');

%Now train the net!
net = trainNetwork(imdsTrain,layers,options);
%Now validate the net! 
YPred = classify(net,imdsValidation);
YValidation = imdsValidationBackup.Labels;
matchingImages = imdsValidationBackup.Files;

% Displays graphs for accuracy. 
accuracy = sum(YPred == YValidation)/numel(YValidation);
disp(accuracy)
savelocation = fullfile("C:\Users\holstein\Documents\ifcbcnn\trainednets\", strcat(datestr(datetime('now'), 30), ".mat"))

save(savelocation, 'net', 'YPred', 'YValidation', 'matchingImages')