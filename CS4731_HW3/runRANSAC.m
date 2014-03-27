function [inliers_id, src_to_dest_H] = runRANSAC(src_pt, dest_pt, ransac_n, ransac_eps)

% keep track of which is best right now
best_M = -1;
best_H = [];
best_inliers = [];

% repeat N times
for round = 1:ransac_n

    % 1. choose random four points 
    p = randperm(size(src_pt));
    s = src_pt(p(1:4),:);
    d = dest_pt(p(1:4),:);
    
    % 2. Fit the model
    H = computeHomography(s,d);
    d_est = applyHomography(H, src_pt);
    
    % 3. compute Euclidean distance for error and compute number of inliers
    % (M)
    errors = sum((d_est - dest_pt).^2,2);
    inliers = find(errors < ransac_eps);
    M = size(inliers, 1);
    
    % check if this is better
    if M > best_M
        best_M = M;
        best_H = H;
        best_inliers = inliers;
    end
end
% 4. choose model with largest number of inliers
inliers_id = best_inliers;
src_to_dest_H = best_H;