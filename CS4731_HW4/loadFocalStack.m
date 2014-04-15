function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
% rgb_stack is an mxnx3k matrix, where m and n are the height and width of
% the image, respectively, and 3k is the number of images in a focal stack
% multiplied by 3 (each image contains RGB channels). 
%
% rgb_stack will only be used for the refocusing app viewer (it is not used
% here).
%
% gray_stack is an mxnxk matrix.

rgb_stack = [];
gray_stack = [];

% split to get filenames - sorted, one per line
filenames = strsplit(ls('-1s', focal_stack_dir));
i = 1;

for f=4:2:size(filenames,2)
    % convert string cell matrix to char
    fname = char(filenames(f));
    % avoid blank
    if fname
        % read the image into stacks
        img = imread(strcat(focal_stack_dir,'/',fname));
        rgb_stack(:, :, 3*i-2:3*i) = img;
        gray_img = rgb2gray(img);
        gray_stack(:, :, i) = gray_img;
        i = i+1;
    end;
end;
disp('Completed loadFocalStack');