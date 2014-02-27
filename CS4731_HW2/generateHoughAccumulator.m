function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)

% create an accumulator array and initialize to zero
accum_array = zeros(theta_num_bins + 1, rho_num_bins + 1);

rho_max = sqrt(2)*max(size(img));
t_step = round(360 / theta_num_bins);
rho_step = round(2*rho_max / rho_num_bins);

[row,col] = find(img == 255);
for i = 1:size(row,1)
    % points (x,y) = (c,r)
    r = row(i);
    c = col(i);
    
    for t = 0:t_step:179
        % x * sin(theta) - y * cos(theta) + rho = 0
        rho = c*sind(t) - r*cosd(t);
        
        rho_bin = round((rho + rho_max) / rho_step);
        theta_bin = t/t_step;
        rho_bin = rho_bin + 1;
        theta_bin = theta_bin + 1;
        accum_array(theta_bin, rho_bin) = 1 + accum_array(theta_bin, rho_bin);
    end
end

% scale the bins to be between 0 and 255
scaled_accum = (accum_array - min(accum_array(:))) ./ (max(accum_array(:) - min(accum_array(:)))) * 255;

hough_img = scaled_accum;
end