function [ ] = rotate_images(imagePath)
rotdeg = [0,90,180,270];
filePattern = fullfile(imagePath,'**\D*.png');
imds = dir(filePattern);
imds_rand = imds(randperm(length(imds)));
for k = 1:(length(imds_rand)/2)
    baseFileName = imds(k).name;
    baseFolder = imds(k).folder;
    fullFileName = fullfile(baseFolder,baseFileName);
    originalImage = imread(fullFileName);
    subplot(1,2,1);
    imshow(originalImage);
    for r = 1:length(rotdeg)
        temprot = rotdeg(r);
        rotatedImage = imrotate(originalImage, temprot);
        subplot(1,2,2);
        imshow(rotatedImage);
        shortImgName = strcat("r", num2str(temprot), "-", baseFileName);
        rotatedImageName = fullfile(baseFolder, shortImgName); 
        imwrite(rotatedImage, rotatedImageName, "png");
    end
    delete fullFileName
end
