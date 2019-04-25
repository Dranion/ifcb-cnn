function [ ] = rotate_images(imagePath)
%Rotates the images given (imagePath) by rotdeg (currently 90,180, and 270 deg)
% and then outputs them, pre-pending the deg rotated to the file name. 

% The degrees to rotate by. Feel free to change this to whatever. 
rotdeg = [90,180,270];
% Assumed file pattern. D*.png makes it so it won't rotate already rotated
% files. 
filePattern = fullfile(imagePath,'**\D*.png');
imds = dir(filePattern);

%for every image....
for k = 1:length(imds)
    baseFileName = imds(k).name;
    baseFolder = imds(k).folder;
    %compiles original name of image
    fullFileName = fullfile(baseFolder,baseFileName);
    originalImage = imread(fullFileName);
    subplot(1,2,1);
    imshow(originalImage);
    %for every degree in rotdeg...
    for r = 1:length(rotdeg)
        temprot = rotdeg(r);
        %rotate the image 
        rotatedImage = imrotate(originalImage, temprot);
        subplot(1,2,2);
        %display the image
        imshow(rotatedImage);
        %save the image
        shortImgName = strcat("r", num2str(temprot), "-", baseFileName);
        rotatedImageName = fullfile(baseFolder, shortImgName); 
        imwrite(rotatedImage, rotatedImageName, "png");
    end
end
