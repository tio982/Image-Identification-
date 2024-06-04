function F = extractRandom(img, Q)
    
    % Quantisation of image
    qimg = floor(img .* Q);
    bin = qimg(:,:,1) * Q^2 + qimg(:,:,2) * Q + qimg(:,:,3);
    vals = reshape(bin, 1, numel(bin));

    % Histogram colour computation and normalisation
    F = imhist(vals, Q^3);
    F = F ./ sum(F);
    F = F';
end