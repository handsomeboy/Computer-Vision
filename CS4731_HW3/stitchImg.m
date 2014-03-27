function stitched_img = stitchImg(varargin)

result = varargin{1};
% result=padarray(result, 100,0);
% result=padarray(result, [0 500], 0, 'post');
% mask = result(:,:,1) > 0;

for i=2:nargin
    % stitch this one onto the previous img
    disp(strcat('stitch ', int2str(i), ' to result'));
    imgd = varargin{i};
    
    % find points of correspondence
    [xs, xd] = genSIFTMatches(result, imgd);
    %showCorrespondence(result,imgd,xs, xd);
    [inliers_id, H] = runRANSAC(xs, xd, 10, 15);
    %showCorrespondence(result, imgd, xs(inliers_id, :), xd(inliers_id, :));
    
    % stitch together
    dest_canvas_width_height = [size(result, 2), size(result, 1)];
    [maskd, dest_img] = backwardWarpImg(imgd, inv(H), dest_canvas_width_height);
    masks = ones(size(result,1), size(result,2));
    maskd = maskd(1:dest_canvas_width_height(2),1:dest_canvas_width_height(1));
    
    %blend together
    result = blendImagePair(result, masks, imgd, maskd, 'blend');
end
stitched_img = result;
imshow(stitched_img);