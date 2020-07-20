close all;
addpath('shinji images','shinji images square');

% Specified directory of images used for synthesis
imageFiles = dir('shinji images/*.jpg');

Nsc = 3;
cropLimit = 2^(Nsc+2);   % Crop dimensions (cropWidth, cropHeight) must 
                         % each be a multiple of cropLimit to satisfy 
                         % textureAnalysis requirements
%%
% Specified directory where textures will be saved to, relative to current
% folder
directory = 'shinji images square/';  
tic
% Loop through each image found in specified directory
for currentImage = imageFiles'
    % Image read and constraints
    im0 = imread(currentImage.name);
    
    [height, width, ~] = size(im0);

     % Determining crop dimensions as a multiple of cropLimit
     cropHeight = 3*cropLimit*floor((height/3)/cropLimit);
     cropWidth = cropHeight;
     
     xCoord = 0.5*width-0.5*cropWidth;
     yCoord = 0;
     rect = [xCoord, yCoord, cropWidth-1, cropHeight];
     im0Cropped = imcrop(im0,rect);

    % Writing cropped images to folder
    imwrite(im0Cropped,strcat(directory,currentImage.name));
end
toc