function trackingTester(data_params, tracking_params)

% for boxes - red with 3 thickness
rgb = [255,0,0];
thickness = 3;

win_rad = tracking_params.search_half_window_size;
bin_n = tracking_params.bin_n;
mkdir(data_params.out_dir);

% iterate through images
for i=1:size(data_params.frame_ids,2)

    % open current image
    frame = data_params.frame_ids(i);
    disp(frame);
    fname = data_params.genFname(frame);
    img = imread(strcat(data_params.data_dir, '/', fname));
    
    % first image - get info from rect
    if i==1
        box = tracking_params.rect;
        
        % bounds of the box
        start_row = box(2);
        start_col = box(1);
        end_row = start_row + box(3) - 1;
        end_col = start_col + box(4) - 1;
        c_width = box(4);
        r_width = box(3);
        
        subset = img(start_row:end_row,start_col:end_col,:);
        [X, map] = rgb2ind(subset, bin_n);
        
    else
        % find the closest match in this to the original tracking box hist
        min_coor = [-1 -1];
        min_sum = -1;
        
        % edge cases
        min_r = start_row - win_rad;
        if min_r < 1
            min_r = 1;
        end
        min_c = start_col - win_rad;
        if min_c < 1
            min_c = 1;
        end
        max_r = start_row + win_rad - 1;
        if max_r > size(img,1) - r_width
            max_r = size(img,1) - r_width;
        end
        max_c = start_col + win_rad - 1;
        if max_c > size(img,2) - c_width;
            max_c = size(img,2) - c_width;
        end
        
        % compare image to first color hist - use search window
        for r=min_r:max_r
            for c=min_c:max_c
                % get box-sized part of the image
                subset = img(r:r+r_width-1, c:c+c_width-1,:);
                
                % use the same color map to get index image
                Y = rgb2ind(subset, map);
                
                % compute and compare histogram
                hist_diff = hist(double(X), bin_n) - hist(double(Y), bin_n);
                % use the sum of absolute differences metric.
                cur_val = sum(sum(abs(hist_diff)));

                % update min
                if min_sum < 0 || cur_val < min_sum
                    min_sum = cur_val;
                    min_coor = [r c];

                end
            end
        end
        
        % box to draw on this image
        box = [min_coor(2) min_coor(1) r_width c_width];
    end
    
    
    % draw box on image and save it to out directory
    out_img = drawBox(img, box, rgb, thickness);
    imwrite(out_img, strcat(data_params.out_dir, '/', fname));
    
end



end