function [center, radius] = findSphere(img)

[a,b] = find(im2bw(img) == 1);
center = [mean(b), mean(a)];

% Area = pi * r^2 
radius = sqrt(size(a,1)/pi);