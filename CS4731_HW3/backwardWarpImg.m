function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)

% make blank initially (black)
result_img = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1),3);
mask = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1));

%each point in the destination image
for i=1:dest_canvas_width_height(1)
    for j=1:dest_canvas_width_height(2)
        % find it's closest point in the new image
        x3 = resultToSrc_H * [j;i;1];
        x3 = x3 / x3(3);
        x2 = round(x3(1:2));
        % check if within bounds of src image
        if x2(2) < size(src_img,1) & x2(1) < size(src_img,2) & x2(1) > 0 & x2(2) > 0
            % update resulting img
            result_img(i,j,:) = src_img(x2(2), x2(1),:);
            % update mask
            mask(i,j) = 1;
        end
    end
end
