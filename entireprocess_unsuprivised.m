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
file_list = imds_all.Files;
filesize = size(file_list);
files{filesize(1)} = [];
for k = 1:filesize
    name = char(file_list(k));
    files{k} = imread(name);
end 
net = selforgmap([8 8]);
[net,tr] = train(net,files);
nntraintool
 