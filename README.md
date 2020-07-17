2020WinterResearch - Jonathan Dulce

Repository includes all 2020 winter research intern working files for Jonathan Dulce.

textureSynth Folder: Includes scripts necessary for texture synthesis, which includes source code from Portilla&Simoncelli as well as my own scripts.
  * Folders within textureSynth
    * Images: misc. images for testing
    * newCroppedImages: cropped images that suit dimensions restrictions required for texture synthesis, using *crop_with_restraints.m*
    * newCroppedImagesTextures: synthesised textures based off images from newCroppedImages, using *croppedimage_texturesynth.m*
    * testImages: Original cropped images for use of stimuli, from *Qianchen_Liad_Natural_Scene experiment codes google drive*
    * textureSamples: Image textures from testImages folders, using *textureSynthPatches_JonathanDulce.m*
  * Created MATLAB files within textureSynth
    * *textureSynthPatches_JonathanDulce.m*: Crops images into 3x3 grid patches, and then synthesises 9 new textures from each patch.
    * *crop_with_restraints.m*: Crops images into max. suitable dimensions for texture synthesis
    * *croppedimage_texturesynth.m*: Synthesises textures from cropped images with suitable dimensions
    * *testing.m*: Miscellaneous code for testing
  * All other files in the textureSynth folder are Portilla&Simoncelli source code for texture synthesis *https://www.cns.nyu.edu/~lcv/texture/*


  
