
function F = colourEdgeDescriptor(img, blockSize, cellSize, numBins)

    % Size of image 
    [rows, columns, ~] = size(img);

    % Padding Calculations
    padRows = ceil(rows / blockSize) * blockSize - rows;
    padCols = ceil(columns / blockSize) * blockSize - columns;

    % Image padding
    imgPadded = padarray(img, [padRows, padCols, 0], 'replicate', 'post');

    % Updated number of blocks
    [paddedRows, paddedCols, ~] = size(imgPadded);
    numBlockRows = ceil(paddedRows / blockSize);
    numBlockColumns = ceil(paddedCols / blockSize);


    testBlock = rand(blockSize, blockSize, 3);
    testHOG = extractHOGFeatures(testBlock, "CellSize",cellSize)
    lengthHOG = length(testHOG);

    %Colour Histogram Size
    histogramSize = numBins*3;

    %Combined descriptor size
    combinedSize = lengthHOG + histogramSize;

    %Initiliasation of feature vector
    F = zeros(numBlockRows * numBlockColumns, combinedSize);

    for i =  1:numBlockRows
        for j = 1:numBlockColumns
            
            rowIndex = (i-1)*(blockSize) +1: min(i*blockSize, paddedRows);
            columnIndex = (j-1)*(blockSize) + 1: min(j*blockSize, paddedCols);
            block = imgPadded(rowIndex, columnIndex, :);

            %HOG features from block
            blockHOG = extractHOGFeatures(block, "CellSize", cellSize);

            %Colour histogram from block
            blockColourHistogram = newColourHistogram(block, numBins);

            % Combined Feature
            combinedFeatures = [blockHOG, blockColourHistogram];
            vectorIndex = (i-1) * numBlockColumns + j;
            F(vectorIndex, :) = combinedFeatures;
            end
        end
    end

function blockHistogram = newColourHistogram(block, numBins)
    % Histogram colour computation
    redHist = imhist(block(:, :, 1), numBins);
    greenHist = imhist(block(:, :, 2), numBins);
    blueHist = imhist(block(:, :, 3), numBins);

    % Normalisation and merging of histograms
    blockHistogram = [redHist',greenHist', blueHist'] / numel(block);
end

