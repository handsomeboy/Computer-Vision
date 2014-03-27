function runHw3(varargin)
% runHw3 is the "main" interface that lists a set of 
% functions corresponding to the problems that need to be solved.
%
% Note that this file also serves as the specifications for the functions 
% you are asked to implement. In some cases, your submissions will be autograded. 
% Thus, it is critical that you adhere to all the specified function signatures.
%
% Before your submssion, make sure you can run runHw3('all') 
% without any error.
%
% Usage:
% runHw3                       : list all the registered functions
% runHw3('function_name')      : execute a specific test
% runHw3('all')                : execute all the registered functions

% Settings to make sure images are displayed without borders
orig_imsetting = iptgetpref('ImshowBorder');
iptsetpref('ImshowBorder', 'tight');
temp1 = onCleanup(@()iptsetpref('ImshowBorder', orig_imsetting));

fun_handles = {@honesty,...
    @challenge1a, @challenge1b, @challenge1c,...
    @challenge1d, @challenge1e, @challenge1f,...
    @demoMATLABTricks};

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
% Tests for Challenge 1: Panoramic Photo App
%--------------------------------------------------------------------------

%%
function challenge1a()
% Test homography
warning('off','all');
orig_img = imread('portrait.png'); 
warped_img = imread('portrait_transformed.png');

% Choose 4 corresponding points (use ginput)
% 4 corners
src_pts_nx2  = [159 101; 159 700; 641 700; 641 101];
dest_pts_nx2 = [139 144; 115 595; 661 774; 620 30];

H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2);
% src_pts_nx2 and dest_pts_nx2 are the coordinates of corresponding points 
% of the two images, respectively. src_pts_nx2 and dest_pts_nx2 
% are nx2 matrices, where the first column contains
% the x coodinates and the second column contains the y coordinates.
%
% H, a 3x3 matrix, is the estimated homography that 
% transforms src_pts_nx2 to dest_pts_nx2. 


% Choose another set of points on orig_img for testing.
% test_pts_nx2 should be an nx2 matrix, where n is the number of points, the
% first column contains the x coordinates and the second column contains
% the y coordinates.

% shoulder, ear, nose, button line
test_pts_nx2 = [262 503; 413 312; 386 571; 370 367];

% Apply homography
dest_pts_nx2 = applyHomography(H_3x3, test_pts_nx2);
% test_pts_nx2 and dest_pts_nx2 are the coordinates of corresponding points 
% of the two images, and H is the homography.

% Verify homography
result_img = showCorrespondence(orig_img, warped_img, test_pts_nx2, dest_pts_nx2);

imwrite(result_img, 'homography_result.png');

%%
function challenge1b()
% Test wrapping 

bg_img = im2double(imread('Osaka.png')); %imshow(bg_img);
portrait_img = im2double(imread('portrait_small.png')); %imshow(portrait_img);

% Estimate homography
portrait_pts = [1 1; 327 1; 1 400; 327 400];
bg_pts = [100 18; 276 71; 84 439; 283 423];

H_3x3 = computeHomography(portrait_pts, bg_pts);

dest_canvas_width_height = [size(bg_img, 2), size(bg_img, 1)];

% Warp the portrait image
[mask, dest_img] = backwardWarpImg(portrait_img, inv(H_3x3), dest_canvas_width_height);
% mask should be of the type logical
mask = ~mask;
% Superimpose the image
result = bg_img .* cat(3, mask, mask, mask) + dest_img;
%figure, imshow(result);
imwrite(result, 'Van_Gogh_in_Osaka.png'); imshow(result);

%%  
function challenge1c()
% Test RANSAC -- outlier rejection

imgs = imread('mountain_left.png'); imgd = imread('mountain_center.png');
[xs, xd] = genSIFTMatches(imgs, imgd);
% xs and xd are the centers of matched frames
% xs and xd are nx2 matrices, where the first column contains the x
% coordinates and the second column contains the y coordinates

before_img = showCorrespondence(imgs, imgd, xs, xd);
%figure, imshow(before_img);
imwrite(before_img, 'before_ransac.png');

% Use RANSAC to reject outliers
ransac_n = 10; % Max number of iteractions
ransac_eps = 5; %Acceptable alignment error 

[inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);

after_img = showCorrespondence(imgs, imgd, xs(inliers_id, :), xd(inliers_id, :));
%figure, imshow(after_img);
imwrite(after_img, 'after_ransac.png');

%%
function challenge1d()
% Test image blending

[fish, fish_map, fish_mask] = imread('escher_fish.png');
[horse, horse_map, horse_mask] = imread('escher_horsemen.png');
blended_result = blendImagePair(fish, fish_mask, horse, horse_mask,...
    'blend');
%figure, imshow(blended_result);
imwrite(blended_result, 'blended_result.png');

overlay_result = blendImagePair(fish, fish_mask, horse, horse_mask, 'overlay');
%figure, imshow(overlay_result);
imwrite(overlay_result, 'overlay_result.png');

%%
function challenge1e()
% Test image stitching

% stitch three images
imgc = im2single(imread('mountain_center.png'));
imgl = im2single(imread('mountain_left.png'));
imgr = im2single(imread('mountain_right.png'));

% You are free to change the order of input arguments
stitched_img = stitchImg(imgc, imgl, imgr);
%figure, imshow(stitched_img);
imwrite(stitched_img, 'mountain_panorama.png');

%%
function challenge1f()
% Your own panorama

%--------------------------------------------------------------------------
% Demo (no submission required)
%--------------------------------------------------------------------------
%%
function demoMATLABTricks()
demoMATLABTricksFun;
