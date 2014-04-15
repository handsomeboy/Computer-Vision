function runHw4(varargin)
% runHw4 is the "main" interface that lets you execute all the 
% challenges in homework 4. It lists a set of 
% functions corresponding to the problems that need to be solved.
%
% Note that this file also serves as the specifications for the functions 
% you are asked to implement. In some cases, your submissions will be autograded. 
% Thus, it is critical that you adhere to all the specified function signatures.
%
% Before your submssion, make sure you can run runHw4('all') 
% without any error.
%
% Usage:
% runHw4                       : list all the registered functions
% runHw4('function_name')      : execute a specific test
% runHw4('all')                : execute all the registered functions

fun_handles = {@honesty,...
    @challenge1a, @challenge1b, @challenge1c,...
    @challenge1d, @demoSurfaceReconstruction,...
    @challenge2a, @challenge2b};

% Call test harness
runTests(varargin, fun_handles);

%--------------------------------------------------------------------------
% Academic Honesty Policy
%--------------------------------------------------------------------------
%%
function honesty()
% Type your full name and uni (both in string) to state your agreement 
% to the Code of Academic Integrity.
signAcademicHonestyPolicy('Emily Schultz', 'ess2183');

%--------------------------------------------------------------------------
% Tests for Challenge 1: Photometric Stereo
%--------------------------------------------------------------------------

%%
function challenge1a()
% Compute the properties of the sphere

img = im2double(imread('sphere0.png')); 
%figure, imshow(img);
[center, radius] = findSphere(img);
save('sphere_properties', 'center', 'radius');

%%
function challenge1b()
% Compute the directions of light sources

img_cell = cell(5, 1);
for i = 1:5
    img_cell{i} = imread(['sphere' num2str(i) '.png']);
end
data = load('sphere_properties');
center = data.center; radius = data.radius;
light_dirs_5x3 = computeLightDirections(center, radius, img_cell);
save('light_dirs', 'light_dirs_5x3');

%%
function challenge1c()
% Compute the mask of the object

vase_img_cell = cell(5, 1);
for i = 1:5
    vase_img_cell{i} = imread(['vase' num2str(i) '.png']);    
end
mask = computeMask(vase_img_cell);

% Your mask should contain only 0's and 1's. We need to cast the mask 
% to double before saving, so the binary mask is properly preserved
imwrite(double(mask), 'vase_mask.png');

%%
function challenge1d()
% Compute surface normals and albedos of the object

% Load the mask image and cast it back to logical
mask = logical(im2double(imread('vase_mask.png')));
data = load('light_dirs'); light_dirs_5x3 = data.light_dirs_5x3;
vase_img_cell = cell(5, 1);
for i = 1:5
    vase_img_cell{i} = imread(['vase' num2str(i) '.png']);    
end
[normals, albedo_img] =computeNormals(light_dirs_5x3, vase_img_cell, mask);
% normals is a mxnx3 matrix which contains 
% the x-, y-, z- components of the normal of each pixel.

% Visualize the surface normals as a normal map image. 
% Normal maps are images that store normals directly 
% in the RGB values of an image. The mapping is as follows:
% X (-1.0 to +1.0) maps to Red (0-255)
% Y (-1.0 to +1.0) maps to Green (0-255)
% Z (-1.0 to +1.0) maps to Blue (0-255)
% A normal map thumbnail sphere_normal_map.png 
% for a sphere is included for your reference.
normal_map_img = uint8((normals + 1)/2 * 255);

imwrite(normal_map_img, 'vase_normal_map.png');
imwrite(albedo_img, 'vase_albedo.png');
save('normals', 'normals');

%%
function demoSurfaceReconstruction()
% Demo (no submission required)

data = load('normals.mat'); normals = data.normals;
mask = logical(im2double(imread('vase_mask.png')));

% reconstructSurf demonstrates surface reconstruciton 
% using the Frankot-Chellappa algorithm
surf_img = reconstructSurf(normals, mask);
imwrite(surf_img, 'vase_surface.png');

% Use the surf tool to visualize the 3D reconstruction
%figure, surf(im2double(imresize(surf_img, 0.3)));

%--------------------------------------------------------------------------
% Tests for Challenge 2: Refocusing Application
%--------------------------------------------------------------------------

%%
function challenge2a()
% Load the focal stack into memory

focal_stack_dir = 'stack';
[rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir);
% rgb_stack is an mxnx3k matrix, where m and n are the height and width of
% the image, respectively, and 3k is the number of images in a focal stack
% multiplied by 3 (each image contains RGB channels). 
%
% rgb_stack will only be used for the refocusing app viewer (it is not used
% here).
%
% gray_stack is an mxnxk matrix.

% Specify the (half) window size used for focus measure computation
half_window_size = 4;

% Generate an index map, here we will only use the gray-scale images
index_map = generateIndexMap(gray_stack, half_window_size);
imwrite(uint8(index_map), 'index_map.png');

%%
function challenge2b()
focal_stack_dir = 'stack';
[rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir);

index_map = imread('index_map.png');
refocusApp(rgb_stack, index_map);
