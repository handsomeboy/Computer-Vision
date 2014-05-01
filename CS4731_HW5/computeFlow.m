function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
% for each image point in the first image, take a window of size
% template_radius*2 x template_radius*2 around the point and use it as a template
optical_flow = [];
fh = figure();

% step based on the grid size, points based on the template_radius
for r=1+template_radius:grid_MN(1):size(img1,1)-template_radius
    for c=1+template_radius:grid_MN(2):size(img1,2)-template_radius        
        template = img1(r-template_radius:r+template_radius,c-template_radius:c+template_radius);
        
        % find the same point in the second image, within win_radius*2 x win_radius
        
        % edge cases
        min_r = r - win_radius;
        if min_r < 1+template_radius
            min_r = 1+template_radius;
        end
        max_r = r + win_radius;
        if max_r > size(img2,1)-template_radius
            max_r = size(img2,1)-template_radius;
        end
        min_c = c - win_radius;
        if min_c < 1+template_radius
            min_c = 1+template_radius;
        end
        max_c = c + win_radius;
        if max_c > size(img2,2)-template_radius
            max_c = size(img2,2)-template_radius;
        end
        
        % save the best match (smallest difference metric)
        min_val = -1;
        min_coor = [-1,-1];
        
        % search for corresponding point in second image, within search
        % window from (r,c)
        for i=min_r:max_r
            for j=min_c:max_c
                cur_region = img2(i-template_radius:i+template_radius,j-template_radius:j+template_radius);
                
                % min sum of absolute differences
                cur_val = sum(sum(abs(template-cur_region)));
                
                % update best match
                if min_val < 0 || cur_val < min_val
                    min_val = cur_val;
                    min_coor = [i,j];
                end
            end
        end
        % add this to the flow vectors
        optical_flow = [optical_flow; r c min_coor(1)-r min_coor(2)-c];
    end
end
% display
imshow(img1); hold on;
quiver(optical_flow(:,2), optical_flow(:,1), optical_flow(:,4), optical_flow(:,3));

% save image
result = saveAnnotatedImg(fh);
end