
# Introduction

 
This README contains the MATLAB scripts developed for the Computer Vision and Pattern Recognition (CVPR) coursework. The scripts form part of a project aimed at implementing image search within a given image collection, particularly focusing on the MSRCv2 dataset. The project involves extracting descriptors from images and employing these descriptors to rank images based on their similarity to a query image.

# Script Descriptions


## cvpr_computedescriptors.m
- Purpose: Iterates through each image in the MSRCv2 dataset and extracts a descriptor using the specified function.
## Key Functions: 
- extractRandom 
- blockHOGHistogram 
- colourGrid -
- colourEdgeDescriptor.

# Parameters:
- DATASET_FOLDER: Path to the unzipped MSRCv2 dataset.
- OUT_FOLDER: Folder for storing results.
- OUT_SUBFOLDER: Subfolder for storing specific descriptors.
- imgfname_full, fout: 
- Full file names for input images and output files.
- Descriptor parameters like Q, blockSize, cellSize, numBins.
- Output: Descriptor files saved in .mat format.

## cvpr_visualsearch.m

- Purpose: Loads pre-computed descriptors, selects a query image, and ranks all images based on their similarity to the query.
## Key Components:
- Loading descriptors into ALLFEAT.
- Random selection or specific choice of a query image.
- Computation of similarity using cvpr_compare.
- Visualization of top-ranked images.
- Calculation and plotting of precision-recall curve.
## Parameters:
- DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR_SUBFOLDER: Paths for dataset and descriptor folders.
- target_image: Specific image to be used as the query.
- queryImageIndex: Index of the query image.
- Output: Displays the top-ranked images and precision-recall curve.

# Usage

- Ensure the MSRCv2 dataset is correctly unzipped in the specified DATASET_FOLDER.
- Run cvpr_computedescriptors.m to generate descriptors for each image.
- Execute cvpr_visualsearch.m to perform visual search using a chosen descriptor.

# Notes

Modify the OUT_SUBFOLDER in cvpr_computedescriptors.m to select the desired descriptor type.
Adjust parameters like blockSize, cellSize, and numBins as needed for different descriptors.
The cvpr_compare function needs to be adapted to compute the actual similarity measure between descriptors.

# Acknowledgements

Code developed by Tioluwani Babayemi.
# Image-Identification-
