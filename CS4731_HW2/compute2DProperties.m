function [db, out_img] = compute2DProperties(gray_img, labeled_img)
% display the positions and orientations of the objects on gray_img
fh = figure();
imshow(gray_img);

% compute properties for each labeled object in the image
prop_db = [];
for label = 1:max(labeled_img(:))
    % object label
    prop_vec = [double(label)];
    bin_img = double(labeled_img == label);
    
    % row and column position of the center
    [r, c] = find(bin_img == 1);
    cen_r = mean(r);
    cen_c = mean(c);
    prop_vec = [prop_vec; cen_r; cen_c];

    % calculate a, b, and c of axis of min moment of inertia    
    [rows,cols] = size(bin_img);
    c_mat = repmat(1:cols, rows, 1);
    r_mat = repmat((1:rows)', 1, cols);
    
    a_mat = bin_img .* (c_mat - cen_c).^2;
    a = sum(a_mat(:));
    
    b_mat = bin_img .* (c_mat - cen_c) .* (r_mat - cen_r);
    b = 2*sum(b_mat(:));
    
    c_mat = bin_img .* (r_mat - cen_r).^2;
    c = sum(c_mat(:));
    
    % orientation - in degrees
    theta = atan2(b, a-c) / 2;
    deg_theta = theta * 180 / pi;
    
    % E moment of inertia (min and max)
    E_one = a*sin(theta).^2  - b*sin(theta)*cos(theta)   + c*cos(theta).^2;
    theta_2 = theta + (pi/2);
    E_two = a*sin(theta_2).^2 - b*sin(theta_2)*cos(theta_2) + c*cos(theta_2).^2;
    
    % roundedness
    %if E_one < E_two
        round = E_one/E_two;
        E_min = E_one;
%     else
%         round = E_two/E_one;
%         E_min = E_one;
%         deg_theta = -deg_theta;
%     end;
    
    % compute Euler Number
    e_num = bweuler(bin_img);
    
    % update properties
    prop_vec = [prop_vec; E_min; deg_theta; round; e_num];
    
    % add this labels' properties to the database
    prop_db = [prop_db prop_vec];
    
    % draw the orientation line from dot on the image (red)
    len = 50;
    x_start = cen_c;
    y_start = cen_r;
    x_end = x_start + len * cosd(deg_theta);
    y_end = y_start + len * sind(deg_theta);
    hold on; line([x_start x_end], [y_start y_end],'LineWidth',2,'Color',[1,0,0]);
end

% color the center points (red)
hold on; plot(prop_db(3, :), prop_db(2, :), 'ws', 'MarkerFaceColor', [1,0,0]);

db = prop_db;
out_img = saveAnnotatedImg(fh);
end