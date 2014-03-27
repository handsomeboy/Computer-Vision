function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
% src_pts_nx2 and dest_pts_nx2 are the coordinates of corresponding points 
% of the two images, respectively. src_pts_nx2 and dest_pts_nx2 
% are nx2 matrices, where the first column contains
% the x coodinates and the second column contains the y coordinates.
%
% H, a 3x3 matrix, is the estimated homography that 
% transforms src_pts_nx2 to dest_pts_nx2. 

s3 = [src_pts_nx2 ones(size(src_pts_nx2, 1),1)];

% first column of A matrix
B = permute(reshape(s3, size(s3,2), 1, []), [2 1 3]);
p = size(B,3);
C = [B; zeros(1, size(s3,2), p)];
col1 = reshape(C(:,:), [], size(s3,2), 1);

% second column of A matrix
C = [zeros(1, size(s3,2), p); B];
col2 = reshape(C(:,:), [], size(s3,2), 1);

% third column of A matrix
col3 = [];
for i=1:size(src_pts_nx2,1)
    xd = dest_pts_nx2(i,1);
    yd = dest_pts_nx2(i,2);

    mat=[xd .* -s3(i,:);
         yd .* -s3(i,:)];
    
    col3 = [col3; mat];
end
A = [col1 col2 col3];

% solve for smallest eigenvalue's eigenvector (Ah=0)
[v,d] = eigs(A'*A,1,'sm');
H_3x3 = reshape(v(:,end),3,3)';

end
