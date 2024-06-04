% utilising matlabs extract hog features to extract the hog images

function F = blockHOGHistogram(img, blockSize, cellSize)

[rows, columns] = size(img);

numBlockRows = ceil(rows/blockSize);
numBlockColumns = ceil(columns/blockSize);

F = [];
figure;
imshow(img); hold on;

for i = 1:blockSize:rows
    line([1, columns], [i i], "Color", "r");
end 

%Iteration over the block
for i = 1:numBlockRows
    for j = 1:numBlockColumns

        rowIndex = (i-1)*blockSize +1: min(i*blockSize, rows);
        columnIndex = (j-1)*blockSize+1: min(j*blockSize, columns);

        %Extract the block
        block = img(rowIndex,columnIndex);

        blockHOG = extractHOGFeatures(block, "CellSize",cellSize);

        F = [F; blockHOG'];
    end
end
hold off;
end 





