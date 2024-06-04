% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
% 
% cvpr_visualsearch.m
% Skeleton code provided as part of the coursework assessment
% 
% This code will load in all descriptors pre-computed (by the
% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
% 
% It will pick a descriptor at random and compare all other descriptors to
% it - by calling cvpr_compare.  In doing so it will rank the images by
% similarity to the randomly picked descriptor.  Note that initially the
% function cvpr_compare returns a random number - you need to code it
% so that it returns the Euclidean distance or some other distance metric
% between the two descriptors it is passed.
% 
% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
% Centre for Vision Speech and Signal Processing (CVSSP)
% University of Surrey, United Kingdom
% 
% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
% cvpr_visualsearch.m
% ... (other comments)

clear queryimg;
rng('shuffle');
close all;
clear all;

% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = '/Users/tb/Documents/MATLAB/cwork_basecode_2012/MSRC_ObjCategImageDatabase_v2';
% Folder that holds the results...
DESCRIPTOR_FOLDER = '/Users/tb/Documents/MATLAB/cwork_basecode_2012/descriptors';
% and within that folder, another folder to hold the descriptors
% we are interested in working with
DESCRIPTOR_SUBFOLDER='colourEdgeDescriptor';
% DESCRIPTOR_SUBFOLDER='globalRGBHisto';
% DESCRIPTOR_SUBFOLDER='colourGrid';
% DESCRIPTOR_SUBFOLDER='blockHOGHistogram';


% 
% 1) Load all the descriptors into "ALLFEAT"
% each row of ALLFEAT is a descriptor (is an image)
ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));

target_image = '6_1_s.bmp'; % find 9 instead of 8 with implementation of normalisation
queryImageIndex = 0; % Initialize index for the target image

for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
     if strcmp(fname, target_image)
        queryImageIndex = filenum; % Save the index when the target image is found
     end

    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    imageClassLabels{ctr} =strtok(fname, "_") % used to extract the class label from the 20 classes
    ctr=ctr+1;
end

eigenModel = computePCA(ALLFEAT');

% 2) Pick an image at random to be the query
    % NIMG=size(ALLFEAT,1); % number of images in collection
    NIMG = length(allfiles);
    % queryimg=floor(rand()*(NIMG-1))+1;    % index of a random image
    queryimg = queryImageIndex;

queryImageName = allfiles(queryimg).name;
queryIdentification = strtok(queryImageName,"_");
preciseList = find(startsWith({allfiles.name}, [queryIdentification "_"]));



% 3) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);

   % thedst=cvpr_compare(query,candidate); %All other distance metric 
   thedst=cvpr_compare(query,candidate, eigenModel); %PCA 

    dst=[dst ; [thedst i]];
end

dst = sortrows(dst, 1);%sort the arrays, fixes error where flowers would show when troubleshooting bugs

%4 Precision and Recall
labels = zeros(NIMG,1);
labels(preciseList) = 1; %precise images should get positive rating
% scores = -dst(:,1); %negative distance used as scores, higher scores = better matches
orderedIndices = dst(:,2);
orderedLabels = labels(orderedIndices);
%Score system logic for precision recall
elementAmount = numel(orderedLabels);
truePositive = zeros(1,elementAmount);

%TPV(true positive values)
for i = 1:elementAmount
    truePositive(i) = sum(orderedLabels(1:i));
end
%Precision
precision = zeros(1,elementAmount);
for i = 1:elementAmount;
    precision(i) = truePositive(i)/i;
end 
%Recall
recall = zeros(1, elementAmount);
totalMatches = sum(labels);
for i = 1:elementAmount
    recall(i) = truePositive(i)/totalMatches
end


% 4) Visualise the results
% These may be a little hard to see using imgshow
% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=15; % Show top 10 results
dst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(dst,1)
   img=imread(ALLFILES{dst(i,2)});
   img=img(1:2:end,1:2:end,:); % make image a quarter size
   img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
   outdisplay=[outdisplay img];
end
imshow(outdisplay);
axis off;

figure;
plot(recall, precision, '-o', 'LineWidth', 2);
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
grid on;
axis([0 1 0 1]);

function eigenModel = computePCA(pt)
    % Mean
    org = mean(pt, 2);
    % Centered points
    ptsub = pt - repmat(org, 1, size(pt, 2));
    % Covariance matrix
    C = (ptsub * ptsub') / size(pt, 2);
    % Eigen decomposition
    [vct, val] = eig(C);

   % Sorted eigenvalues and eigenvectors
    [sortedVal, sortIndex] = sort(diag(val), 'descend');
    sortedVct = vct(:, sortIndex);

    % EigenModel
    eigenModel.org = org;
    eigenModel.vct = sortedVct;
    eigenModel.val = sortedVal;
    eigenModel.C = C;
end
