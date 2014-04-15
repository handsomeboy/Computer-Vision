function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)

% 5x3 matrix where row i contains the x y z components of the normal vector
light_dirs_5x3 = zeros(5,3);

% for each image
for i=1:size(img_cell,1)
    % find spot of maximum brightness
    max_b = max(img_cell{i}(:));
    [r,c] = find(img_cell{i} == max_b);

    %imshow(img_cell{i}); hold on; plot(c,r,'r.');
    %hold on;
    %plot(mean(c), mean(r), 'b.');

    % choose center of blob of points with max to be max
    x = mean(c);
    y = mean(r);

    % compute z_coordinate in 3D space
    x_3d = x-center(1);
    y_3d = y-center(2);
    % assuming center z coordinate is zero
    z_3d = sqrt(radius^2 - x_3d^2 - y_3d^2);

    % unit normal vector from center of sphere to point in 3d
    n = [x_3d, y_3d, z_3d]./radius;

    % scale the direction vector so its length equals max brightness
    light_dirs_5x3(i,:) = double(max_b)*n;
end