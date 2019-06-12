function [ ] = entireprocess(imagePath)
% entireprocess  Runs a basic CNN on raw pngs  
% 
% Assumes sub-directories indicate classifications. All images must be
% pngs. Runs 4 epochs, ignores sub-directors with less than 20 files in
% them. See commented code for customization. 
%
% Example: entireprocess('C:\Users\holstein\Documents\IFCB Data\mirror\manual\pngs\')


%% SELECTING IMAGES 
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

        
catnum = i; % number of classes
%% CHOOSING NET AND IMAGE VALUES

%Specify Training and Validation Sets. 70/30 split currently. 
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,0.1,'randomize');

%This defines how the images will be modified. By randomly applying
%changes like shifting the image to the right, it helps prevent
%overfitting. 
aug = imageDataAugmenter(...
    'FillValue',200, ... % What color the image will be filled with when re-sized
    'RandXReflection', 1, ... % If the images will be randomly reflected over x axis 
    'RandYReflection', 1, ... % If the images will be randomly reflected over y axis 
    'RandScale', [0.9 1.1], ... % The range of vals to randomly increase/decrease the image size by before resizing
    'RandXTranslation', [-5, 5], ... % The range of vals to randomly move the image from left/right  
    'RandYTranslation', [-5, 5] ... % The range of vals to randomly move the image down/up 
    );

%imgsize sets how large the image is. Smaller images will train and
%classify faster, but may loose details 
imgsize = [120 120 1]; 

%Sets up the training versus validation sets. 
imdsTrain = augmentedImageDatastore(imgsize, imdsTrain, 'DataAugmentation', aug); %applies the aug modifcations to the training set
imdsValidationBackup = imdsValidation; %backing up imdsValidation as a list like this allows it to be checked later
imdsValidation = augmentedImageDatastore(imgsize, imdsValidation); % resizes the validation set to imgsize, too
minibatch = read(imdsTrain);
imshow(imtile(minibatch.input)) % Shows a random sampling of the images. 

%Define Network Architecture. Not optimized. 
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
    'InitialLearnRate',0.01, ... %How fast the data trains. 
    'MaxEpochs',40, ... %How long the training will go. 
    'Shuffle','every-epoch', ... %Keep this every-epoch
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',100, ...%How often to validate the data. 
    'Verbose',true, ... %Whether to print out batch data. Probably should turn off when not debugging. 
    'ValidationPatience',30, ... %If validation gets really good, stop training early 
    'Plots','training-progress');

%% ACTUAL COMMANDS FOR RUNNING/TRAINING NET

%Now train the net!
net = trainNetwork(imdsTrain,layers,options);

%Now validate the net! 
YPred = classify(net,imdsValidation); % This is how you would classify regularly too. 
YValidation = imdsValidationBackup.Labels;
matchingImages = imdsValidationBackup.Files;

% Displays graphs for accuracy. 
accuracy = sum(YPred == YValidation)/numel(YValidation); 
disp(accuracy)
savelocation = fullfile("C:\Users\holstein\Documents\ifcbcnn\trainednets\", strcat(datestr(datetime('now'), 30), ".mat"));

save(savelocation, 'net', 'YPred', 'YValidation', 'matchingImages')