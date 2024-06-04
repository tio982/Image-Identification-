%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '/Users/tb/Documents/MATLAB/cwork_basecode_2012/MSRC_ObjCategImageDatabase_v2';
%% Create a folder to hold the results...
OUT_FOLDER = '/Users/tb/Documents/MATLAB/cwork_basecode_2012/descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.

  % OUT_SUBFOLDER='globalRGBHisto';
    % OUT_SUBFOLDER='colourGrid';
  % OUT_SUBFOLDER='blockHOGHistogram';
  OUT_SUBFOLDER='colourEdgeDescriptor';


allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    
    %Image Parameters
    Q = 9;
    blockSize = 43; % Example value, adjust as needed
    cellSize = [25 25];
    numBins = 18;    % Number of bins for histograms


  % F = extractRandom(img, Q);
  % F = blockHOGHistogram(img,blockSize,cellSize)
  % F = colourGrid(img, blockSize ,numBins);
  F = colourEdgeDescriptor(img, blockSize, cellSize,numBins);
    save(fout,'F');
    toc
end


%Good
%Test Class 6_1 with block = 46, cell = [25, 25] and bins = 18 faces
% Test Class 9_1 with block = 43, cell = [25, 25] and bins = 18 bikes
% Test Class 8_15(12/14) and 8_5(100%) with block = 43, cell = [25, 25] and bins = 18
% bikes
% Test Class 5_5 with block = 43, cell = [25, 25] and bins = 18 cows
% Test Class 16_5 with block = 31, cell = [25, 25] and bins = 18 dogs
% Test Class 9_5 with block = 31, cell = [25, 25] and bins = 18 sheep+

%Bad
% Test Class 19_19 and 19_1 with block = 26, cell = [25, 25] and bins = 20 Dispep+
% Test Class 10_19 with block = 30 or 26, cell = [25, 25] and bins = 18 Plane +
% Test Class 10_10 with block = 30 or 26, cell = [25, 25] and bins = 18 Plane +

