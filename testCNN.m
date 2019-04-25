function [ ] = testCNN(imagePath)

% imagePath = manualPath + "pngs\"
% export_png_manual_fromROI(manualPath, imagePath, roipath)
imds = imageDatastore(imagePath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
%Display some of the images to check
% figure;
% perm = randperm(10000,20);
% for i = 1:20
%     subplot(4,5,i);
%     imshow(imds.Files{perm(i)});
% end

%Trying to add rotated sets

%     
%Check # of classes
labelCount = countEachLabel(imds);
disp(labelCount)
[min_vals, ~] = min(labelCount{:,2});
disp(min_vals)
%Check # of categories 
S = dir(imagePath);

catnum = sum([S(~ismember({S.name},{'.','..'})).isdir]);

%Check img size 
img = readimage(imds,1);
size(img)

%Specify Training and Validation Sets
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.5,0.5,'randomize');

%Define Network Architecture 
layers = [
    imageInputLayer(size(img))
    
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
%Specify training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',true, ...
    'Plots','training-progress');
%Now train!
net = trainNetwork(imdsTrain,layers,options);
%Now validate! 
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation);
disp(accuracy)