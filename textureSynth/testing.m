% Testing
clear all; close all;
%% Image read
 im0 = imread('test.png');
 
[height, width, ~] = size(im0);
Nsc = 3; % Number of scales (Used in texture analysis)
cropLimit = 2^(Nsc+2);   % Crop dimensions (cropWidth, cropHeight) must 
                         % each be a multiple of cropLimit to satisfy 
                         % textureAnalysis requirements
 
 %% Cropping image into 3x3 sections (sections 1-9)
 imSection = cell(3,3); % Sections as a 3x3 array
 
 cropWidth = cropLimit*floor((width/3)/cropLimit);
 cropHeight = cropLimit*floor((height/3)/cropLimit);
 
 for i=1:3
     for j=1:3
         % Setting crop dimensions and coordinates
         xcoord = (i-1)*cropWidth;
         ycoord = (j-1)*cropHeight;
         
         % Dimensions of each section must be even
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
 
 
 %% Analysing and synthesising Textures
close all
textureSection = cell(3,3);
 
% Texture analysis parameters
% Nsc = 2; % Number of scales
Nor = 4; % Number of orientations
Na = 3;  % Spatial neighborhood is Na x Na coefficients

% Texture synthesis parameters
Niter = 5;	% Number of iterations of synthesis loop
Nsx = cropWidth;	% Size of synthetic image is Nsy x Nsx
Nsy = cropHeight;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

for i=1:9
%     if i==4 | i==7 | i==8
%         i=i+1
%     end
    imParams = textureColorAnalysis(imSection{i}, Nsc, Nor, Na);
    textureSection{i} = textureColorSynthesis(imParams, [Nsy Nsx], Niter);
end
% 

%% Manual synthesis
% temp = 9;
% imParams = textureColorAnalysis(imSection{temp}, Nsc, Nor, Na);
% textureSection{temp} = textureColorSynthesis(imParams, [Nsy Nsx], Niter);


%% Concatenating textures together
temprows = cell(1,3);

for i=1:3
    temprows{i} = cat(2,textureSection{3*i-2},textureSection{3*i-1},textureSection{3*i});
end
textureWhole = cat(1,temprows{1},temprows{2},temprows{3});

%% Printing images
close all;

% Displaying original image
figure('Name','Original image');
imshow(im0);
% Displaying cropped sections from original image
figure('Name','Cropped original image');
 for i=1:9
     subplot(3,3,i);
     imshow(imSection{i});
 end
 %%

% Displaying textures generated from original image crops
figure('Name','Synthesised textures from cropped sections');
 for i=1:9
     subplot(3,3,i);
     imshow(textureSection{i});
 end
%%
% Displaying textures cropped back to original dimensions
figure('Name','Synthesised textures stitched together');
imshow(textureWhole);



% %%
% stimuli = cell(3,3);
% imrow = cell(1,3);
% 
% imrow{1} = cat(2,imSection{1},imSection{2},imSection{3});
% imrow{2} = cat(2,imSection{4},imSection{5},imSection{6});
% imrow{3} = cat(2,imSection{7},imSection{8},imSection{9});
% 
% %%
% section = 9;
% tempSynthRow = cat(2,imSection{7},imSection{8},textureSection{9});
% stimuli{section} = cat(1,imrow{1},imrow{2},tempSynthRow);
% 
% % figure;
% % imshow(stimuli{2});
% 
% imwrite(stimuli{section},'/Users/jeddulce/Documents/MATLAB/textureSynth/Images/cong1_1/cong1_1_texture9.png');