function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)

s3 = [src_pts_nx2 ones(size(src_pts_nx2,1),1)];

pts = [];
for i=1:size(src_pts_nx2,1)
    % multiply by homography matrix
    x3 = H_3x3 * s3(i,:)';
    % normalize by the z coordinate
    x3 = x3 / x3(3);
    % only need x and y
    pts = [pts; x3(1:2)'];
end
dest_pts_nx2 = pts;