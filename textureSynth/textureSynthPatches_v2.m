% Image texture synthesiser v2
%
% Author: Jonathan Dulce
% Last updated: 19 July 2020
%
% Texture synthesis is conducted using the Portilla & Simoncelli (2000) 
% parametric texture model (https://www.cns.nyu.edu/~lcv/texture/)
close all; clear all;
%% Preparing directories, files, and analysis variables
addpath('matlabPyrTools', 'testImages2','textureSamples2');

% Specified directory of images used for synthesis
imageFiles = dir('testImages2/*.jpg');

% Texture analysis parameters
Nsc = 3; % Number of scales (Used in texture analysis)
Nor = 5; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients

% Texture synthesis parameters
Niter = 10;	% Number of iterations of synthesis loop


cropLimit = 2^(Nsc+2);   % Crop dimensions (cropWidth, cropHeight) must 
                         % each be a multiple of cropLimit to satisfy 
                         % textureAnalysis requirements

%%
% Cropping image into a 3x3 grid (marked as sections 1-9)
imSection = cell(3,3); % Cropped sections of images as a 3x3 cell array
textureSection = cell(3,3); % Synthesised textures as a 3x3 cell array
temprows = cell(1,3);

% Specified directory where textures will be saved to, relative to current
% folder
directory = 'textureSamples2/';  
tic
% Loop through each image found in specified directory
for currentImage = imageFiles'
    fprintf('\n\n\n\n\n-------- Synthesising textures for image: %s --------\n',currentImage.name);
    
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

    % Set dimensions of synthesised image textures
    Nsx = cropWidth;	% Size of synthetic image is Nsy x Nsx
    Nsy = cropHeight;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

    close all
    % Loop through each image section/crop (1-9)
    for i=1:9
        try
            % Analyse the image crop
            imParams = textureColorAnalysis(imSection{i}, Nsc, Nor, Na);
            % Synthesise a texture based on the analysis above
            textureSection{i} = textureColorSynthesis(imParams, [Nsy Nsx], Niter);
        catch
            % If texture is unable to be synthesised, skip failed section
            fprintf('Error: Texture synthesis failed on section %g\n',i);
            % Make this particular section blank
            textureSection{i} = uint8(rand(Nsy,Nsx,3));
        end
    end
    
    % Stitching textures together
    for i=1:3
    temprows{i} = cat(2,textureSection{3*i-2},textureSection{3*i-1},textureSection{3*i});
    end
    imageWhole = cat(1,temprows{1},temprows{2},temprows{3});

    % Writing cropped images to folder
    imageName = strcat('imtexture',currentImage.name(3:end));
    imwrite(imageWhole,strcat(directory,imageName));
end
close all
fprintf('\n\n\n\n\n-------- Texture Synthesis Complete --------\n');
toc