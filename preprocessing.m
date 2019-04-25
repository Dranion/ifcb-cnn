function results = preprocessing(im)
%Image Processing Function. 
% Pads images with grey to put them up to 120 x 120 pixels. Makes sure
% square, makes sure greyscale. Meant to be run by Image Bath Processor or 
% with batchpreprocessing.m
%
% IM      - Input image.
% RESULTS - A scalar structure with the processing results.
%

%%GOAL SIZE: 
goalx = 120;
goaly = 120;

%Calculates how much padding to add. 
xdif = max(goalx - size(im, 1), 0);
ydif = max(goaly - size(im, 2), 0);
%Adds padding so that actual image is centered
im = padarray(im, [xdif, ydif], 200, 'both');
%Resizes image just in case
im = imresize(im,[goalx goaly]);
% Check if RGB, if so convert to grayscale. 
if(size(im,3)==3)
    imgray = rgb2gray(im);
else
    imgray = im;
end


%Return the image! 
results.imgray = imgray;


%--------------------------------------------------------------------------
