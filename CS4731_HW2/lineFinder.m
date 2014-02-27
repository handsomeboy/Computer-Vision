function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)

bin_img = (hough_img >= hough_threshold);

% each corresponds to a line in (x,y)
[thetas, rhos] = find(bin_img == 1);

% display the positions and orientations of the objects on orig_img
fh_hough = figure();
imshow(orig_img);

% for each line
for i = 1:size(thetas,1)
    theta_bin = thetas(i);
    rho_bin = rhos(i);
    
    rho_num_bins = 100;
    theta_num_bins = 144;
    rho_max = sqrt(2)*max(size(orig_img));
    t_step = round(360 / theta_num_bins);
    rho_step = round(2*rho_max / rho_num_bins);
    
    % x * sin(theta) - y * cos(theta) + rho = 0
    rho = (rho_bin - 1) * rho_step - rho_max;
    theta = (theta_bin -1) * t_step;
    
    % draw the detected lines (red)
    len = 1000;
    x_start = 1;
    % y = ( x * sin(theta) + rho ) / cos(theta)
    y_start = (x_start * sind(theta) - rho) / cosd(theta);
    
    x_end = x_start + len * cosd(theta);
    y_end = y_start + len * sind(theta);
    hold on; line([x_start x_end], [y_start y_end],'LineWidth',2,'Color',[1,0,0]);

    theta = theta - 180;
    x_start = 1;
    % y = ( x * sin(theta) + rho ) / cos(theta)
    y_start = abs((x_start * sind(theta) - rho) / cosd(theta));
    x_end = x_start + len * cosd(theta);
    y_end = y_start + len * sind(theta);
    while y_end < 0
        len = len - 100;
        x_end = x_start + len * cosd(theta);
        y_end = y_start + len * sind(theta);
    end
    hold on; line([x_start x_end], [y_start y_end],'LineWidth',2,'Color',[1,0,0]);

end

% save the annotated image
line_detected_img = saveAnnotatedImg(fh_hough);
end