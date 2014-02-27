function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
matched_labels = [];

round_thres = 0.22; 
emin_thres = 1000000;

[img_db, out_img] = compute2DProperties(orig_img, labeled_img);

% compare each item in the img
for label = 1:size(img_db, 2)
    bin_img = (labeled_img == label);
    
    obj_enum = img_db(7, label);
    obj_round = img_db(6, label);
    obj_emin = img_db(4, label);
    
    % to each item in the database
    for item = 1:size(obj_db, 2)
        
        item_enum = obj_db(7, item);
        item_round = obj_db(6, item);
        item_emin = obj_db(4, item);
        
        % must have same euler number
        if item_enum ~= obj_enum
            continue
        end
        % within threshold for roundness
        round_diff = abs(obj_round - item_round);
        if round_diff > round_thres
             continue
        end
        % within threshold for Emin
        emin_diff = abs(obj_emin - item_emin);
        if emin_diff > emin_thres
            continue
        end
        
        disp('MATCH');
        disp(label);
        disp(item);
        disp(emin_diff);
        disp(round_diff);
        matched_labels = [matched_labels; label];
        continue
    end;
    
end
matched_labels
% create the final image
fh10 = figure(10);
imshow(orig_img);

% for each match,
for m = 1:size(matched_labels, 1)
    label = matched_labels(m);
    % plot the centroid on orig_img
    hold on; plot(img_db(3, label), img_db(2, label), 'ws', 'MarkerFaceColor', [1,0,0]);
    
    % draw the orientation line from dot on the image (red)
    len = 50;
    x_start = img_db(3, label);
    y_start = img_db(2, label);
    x_end = x_start + len * cosd(img_db(5, label));
    y_end = y_start + len * sind(img_db(5, label));
    hold on; line([x_start x_end], [y_start y_end],'LineWidth',2,'Color',[1,0,0]);

end;
output_img = saveAnnotatedImg(fh10);
end