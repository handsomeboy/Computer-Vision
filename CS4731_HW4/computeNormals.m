function [normals, albedo_img] = computeNormals(light_dirs, img_cell, mask)
% normals is a mxnx3 matrix which contains 
% the x-, y-, z- components of the normal of each pixel.
[M,N] = size(mask);
normals = zeros(M, N, 3);
albedo_img = zeros(M, N);

%ignore non object points
[row,col]=find(mask==1);

max_I = zeros(size(img_cell));

for i=1:size(row)
    % point is row(i), col(i)
    r = row(i);
    c = col(i);
    
    % find three images where brightness is highest here
    for j=1:size(img_cell)
        bright(j) = img_cell{j}(r,c);
        % fill the max irradiance array
        if i==1
            max_I(j) = max(max(img_cell{j}));
        end
    end
    [sortedValues,sortIndex] = sort(bright(:),'descend');
    if ~ismember(0, sortedValues(1:3))
        % otherwise skip it
        maxIndices = sortIndex(1:3);
        
        I = [img_cell{maxIndices(1)}(r,c); img_cell{maxIndices(2)}(r,c); img_cell{maxIndices(3)}(r,c)];
        % adjust for different brightnesses
        I2 = double(I)./max_I(maxIndices);
        
        % get the source vectors
        S = light_dirs(maxIndices,:);
        
        % solve the system
        big_n = inv(S)*I2;
        
        % unit normal
        n = big_n / norm(big_n);
        normals(r,c,:) = n;
        
        % albedo calculation
        albedo = norm(big_n)*pi;
        albedo_img(r,c) = albedo;
    end
end

% scale to between 0 and 1
max_alb = max(max(albedo_img));
min_alb = min(min(albedo_img));
albedo_img = (albedo_img - min_alb)/(max_alb - min_alb);