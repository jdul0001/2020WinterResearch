close all
addpath('testImages','textureSamples');
im0 = imread('SquareCongruent_003.jpg');
fovea = imread('SquareCongruent_003_TexturePatch5.jpg');

im0ref = imref2d(size(im0));
fovearef = imref2d(size(fovea));

fovearef.XWorldLimits = im0ref.XWorldLimits;
fovearef.YWorldLimits = im0ref.YWorldLimits;

%%
fused = imfuse(im0,fovea,'blend');

imshow(fused);