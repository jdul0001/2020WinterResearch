close all;
addpath('matlabPyrTools', 'newCroppedImages','newCroppedImagesTextures');

% Specified directory of images used for synthesis
imageFiles = dir('newCroppedImages/*.jpg');

% Texture analysis parameters
Nsc = 3; % Number of scales (Used in texture analysis)
Nor = 5; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients

% Texture synthesis parameters
Niter = 10;	% Number of iterations of synthesis loop

%%

% Specified directory where textures will be saved to, relative to current
% folder
directory = 'newCroppedImagesTextures/';  
tic
% Loop through each image found in specified directory
for currentImage = imageFiles'
    % Image read and constraints
    im0 = imread(currentImage.name);
    [height, width, ~] = size(im0);
    Nsx = width;	% Size of synthetic image is Nsy x Nsx
    Nsy = height;
        try
            % Analyse the image crop
            imParams = textureColorAnalysis(im0, Nsc, Nor, Na);
            % Synthesise a texture based on the analysis above
            imTexture = textureColorSynthesis(imParams, [Nsy Nsx], Niter);
            
            % Writing synthesised texture patches to folder
            textureName = strcat(currentImage.name(1:end-4),'_Texture.jpg');
            imwrite(imTexture,strcat(directory,textureName));
        catch
            % If texture is unable to be synthesised, skip failed section
            fprintf('Error: Texture synthesis failed on image %s\n',currentImage.name);
        end
end
close all
toc