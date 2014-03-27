function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
% display the two side by side
fh=figure();
imshow([orig_img warped_img]); hold on;

% draw lines of correspondence
i1_width = size(orig_img, 2);
for i=1:size(src_pts_nx2,1)
    x1 = src_pts_nx2(i,1);
    x2 = dest_pts_nx2(i,1) + i1_width;
    y1 = src_pts_nx2(i,2);
    y2 = dest_pts_nx2(i,2);
    hold on; line([x1 x2],[y1,y2],'LineWidth',2,'Color',[1,0,0]);
end
result_img = saveAnnotatedImg(fh);