    
function F = colourGrid(img,blockSize, numBins)

    % Size of the image
    [rows, columns, ~] = size(img);

    % Number of blocks
    numBlockRows = ceil(rows/blockSize);
    numBlockCols = ceil(columns / blockSize);

    % Initialize the feature vector
    F = [];

    % Iteratation over each block
    for i = 1:numBlockRows
        for j = 1:numBlockCols
            % Row and column indices for the current block
            rowInds = (i-1)*blockSize + 1 : min(i*blockSize, rows);
            colInds = (j-1)*blockSize + 1 : min(j*blockSize, columns);

            % Block extraction
            block = img(rowInds, colInds, :);

            % Concatenation the color histogram for the block
            blockHist = newColourHistogram(block, numBins);
            F = [F; blockHist];
        end
    end
end

function blockHistogram = newColourHistogram(block, numBins)
 % Histogram colour computation   
    redHist = imhist(block(:, :, 1), numBins);
    greenHist = imhist(block(:, :, 2), numBins);
    blueHist = imhist(block(:, :, 3), numBins);

 % Normalisation and merging of histograms
    blockHistogram = [redHist; greenHist; blueHist] / numel(block);
end
