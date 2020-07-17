close all;
addpath('matlabPyrTools', 'testImages','newCroppedImages');

% Specified directory of images used for synthesis
imageFiles = dir('testImages/*.jpg');


%%
% Cropping image into a 3x3 grid (marked as sections 1-9)
imSection = cell(3,3); % Cropped sections of images as a 3x3 cell array
temprows = cell(1,3);

% Specified directory where textures will be saved to, relative to current
% folder
directory = 'newCroppedImages/';  
tic
% Loop through each image found in specified directory
for currentImage = imageFiles'
    % Image read and constraints
    im0 = imread(currentImage.name);

    
    [height, width, ~] = size(im0);

     % Determining crop dimensions as a multiple of cropLimit
     cropWidth = cropLimit*floor((width/3)/cropLimit);
     cropHeight = cropLimit*floor((height/3)/cropLimit);

     for i=1:3
         for j=1:3
             % Setting up coordinates to crop from
             xcoord = (i-1)*cropWidth;
             ycoord = (j-1)*cropHeight;

             % Ensures that dimensions of each section is even
             if i==1 && j==1
                rect = [xcoord, ycoord, cropWidth, cropHeight];
             elseif i==1 && j~=1
                rect = [xcoord, ycoord, cropWidth, cropHeight-1];
             elseif i~=1 && j==1
                rect = [xcoord, ycoord, cropWidth-1, cropHeight];
             else
                rect = [xcoord, ycoord, cropWidth-1, cropHeight-1];
             end

             % Cropping im0 into 3x3 sections
             imSection{i,j} = imcrop(im0,rect);
         end
     end

    for i=1:3
        temprows{i} = cat(2,imSection{3*i-2},imSection{3*i-1},imSection{3*i});
    end
    imageWhole = cat(1,temprows{1},temprows{2},temprows{3});
    
    % Writing cropped images to folder
    imageName = strcat(currentImage.name(1:end-4),'_recropped.jpg');
    imwrite(imageWhole,strcat(directory,imageName));
end
toc