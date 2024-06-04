% function dst=cvpr_compare(F1, F2)
% 
%  x = F1 - F2;
%  x = x.^2;
%  x = sum(x,"all"); 
%  dst = sqrt(x);


function dst = cvpr_compare(F1, F2, eigenModel)

    F1 = reshape(F1,[],1);
    F2 = reshape(F2,[],1);

    xsub1 = F1 - eigenModel.org;
    xsub2 = F2 - eigenModel.org;

    threshold = 0.00005;
    %Find actual indices 

     % Filter out zero or near-zero eigenvalues
    validIndices = eigenModel.val > threshold;
    
    %Find actual indices 
    V = diag(eigenModel.val(validIndices));
    U = eigenModel.vct(:, validIndices);

    % Compute Mahalanobis Distance
    diff = xsub1 - xsub2;
    dstSquared = diff' * U * inv(V) * U' * diff;
    dst = sqrt(dstSquared);


   
% function dst = hammingDistance(F1, F2)
%     dst = sum(F1 ~= F2);
% 
% end

