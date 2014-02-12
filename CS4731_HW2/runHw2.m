function runHw2(varargin)
% runHw2 is the "main" interface that lets you execute all the 
% walkthroughs and challenges in homework 2. It lists a set of 
% functions corresponding to the problems that need to be solved.
%
% This file also serves as specifications for the functions 
% you are asked to implement. In some cases, your submissions will be autograded. 
% Thus, it is critical that you adhere to all the specified function signatures.
%
% Before your submssion, make sure you can run runHw2('all') 
% without any error.
%
% Usage:
% runHw2                       : list all the registered functions
% runHw2('function_name')      : execute a specific test
% runHw2('all')                : execute all the registered functions

% Settings to make sure images are displayed without borders.
orig_imsetting = iptgetpref('ImshowBorder');
iptsetpref('ImshowBorder', 'tight');
temp1 = onCleanup(@()iptsetpref('ImshowBorder', orig_imsetting));

fun_handles = {@honesty, @walkthrough1, @walkthrough2...
    @challenge1a, @challenge1b, @challenge1c1, @challenge1c2,...
    @challenge2a, @challenge2b, @challenge2c, @challenge2d,...
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
signAcademicHonestyPolicy('Peter Parker', 'pp117');

%--------------------------------------------------------------------------
% Test for Walkthrough 1: Morphological operations
%--------------------------------------------------------------------------

%%
function walkthrough1()
hw2_walkthrough1;

%--------------------------------------------------------------------------
% Tests for Challenge 1: 2D binary object recognition
%--------------------------------------------------------------------------

%%
function challenge1a()
img_list = {'two_objects', 'many_objects_1', 'many_objects_2'};
%threshold_list = [???, ???, ???];

for i = 1:length(img_list)
    orig_img = imread([img_list{i} '.png']);
    labeled_img = generateLabeledImage(orig_img, threshold_list(i));
    % labeled_img should contain labels only from 0-255    
    % Cast labeled_img to unit8 so integer labels are preserved
    imwrite(uint8(labeled_img), ['labeled_' img_list{i} '.png']);
    
    % Assign a unique color to each integer label so the labeled_img can be
    % easily examined. 
    rgb_img = label2rgb(labeled_img, 'jet', 'k');
    imwrite(rgb_img, ['rgb_labeled_' img_list{i} '.png']);
end

%%
function challenge1b()
labeled_two_obj = imread('labeled_two_objects.png');
orig_img = imread('two_objects.png');
[obj_db, out_img] = compute2DProperties(orig_img, labeled_two_obj);
imwrite(out_img, 'annotated_two_objects.png');
save('obj_db.mat', 'obj_db');

%%
function challenge1c1()
mat_struct = load('obj_db.mat');
obj_db = mat_struct.obj_db;
img_list = {'many_objects_1', 'many_objects_2'};

for i = 1:length(img_list)
    labeled_img = imread(['labeled_' img_list{i} '.png']);
    orig_img = imread([img_list{i} '.png']);
    output_img = recognizeObjects(orig_img, labeled_img, obj_db);
    imwrite(output_img, ['testing1c1_' img_list{i} '.png']);
end

%%
function challenge1c2()
db_img = 'many_objects_1';
labeled_img = imread(['labeled_' db_img '.png']);
orig_img = imread([db_img '.png']);
[obj_db, out_img] = compute2DProperties(orig_img, labeled_img);
img_list = {'two_objects', 'many_objects_2'};

for i = 1:length(img_list)
    labeled_img = imread(['labeled_' img_list{i} '.png']);
    orig_img = imread([img_list{i} '.png']);
    output_img = recognizeObjects(orig_img, labeled_img, obj_db);
    imwrite(output_img, ['testing1c2_' img_list{i} '.png']);
end

%--------------------------------------------------------------------------
% Tests for Walkthrough 2: Image processing
%--------------------------------------------------------------------------
%%
function walkthrough2()
hw2_walkthrough2;

%--------------------------------------------------------------------------
% Tests for Challenge 2: Hough transform
%--------------------------------------------------------------------------
%%
function challenge2a()
img_list = {'hough_1', 'hough_2', 'hough_3'};
for i = 1:length(img_list)
    img = imread([img_list{i} '.png']);
    %edge_img = edge(??);
    
        
    % Note: The output from edge is an image of logical type.
    % Here we cast it to double before saving it.
    imwrite(im2double(edge_img), ['edge_' img_list{i} '.png']);
end

%%
function challenge2b()
img_list = {'hough_1', 'hough_2', 'hough_3'};

% rho_num_bins = ??;
% theta_num_bins = ??;
for i = 1:length(img_list)
    img = imread(['edge_' img_list{i} '.png']);
    hough_accumulator = generateHoughAccumulator(img,...
        theta_num_bins, rho_num_bins);
    
    % We'd like to save the hough accumulator array as an image to
    % visualize it. The values should be between 0 and 255 and the
    % data type should be uint8.
    imwrite(uint8(hough_accumulator), ['accumulator_' img_list{i} '.png']);
end

%%
function challenge2c()

img_list = {'hough_1', 'hough_2', 'hough_3'};
%hough_threshold = [?? ?? ??];

for i = 1:length(img_list)
    orig_img = imread([img_list{i} '.png']);
    hough_img = imread(['accumulator_' img_list{i} '.png']);
    line_img = lineFinder(orig_img, hough_img, hough_threshold(i));
    
    % The values of line_img should be between 0 and 255 and the
    % data type should be uint8.
    %
    % Here we cast line_img to uint8 if you have not done so, otherwise
    % imwrite will treat line_img as a double image and save it to an
    % incorrect result.    
    imwrite(uint8(line_img), ['line_' img_list{i} '.png']);
end

%%
function challenge2d()

img_list = {'hough_1', 'hough_2', 'hough_3'};
%hough_threshold = [?? ?? ??];

for i = 1:length(img_list)
    orig_img = imread([img_list{i} '.png']);
    hough_img = imread(['accumulator_' img_list{i} '.png']);
    line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold(i));
    
    % Note: The values of line_img should be between 0 and 255 and the
    % data type should be uint8.
    %
    % Here we cast line_img to uint8 if you have not done so, otherwise
    % imwrite will treat line_img as a double image and save it to an
    % incorrect result.        
    imwrite(uint8(line_img), ['croppedline_' img_list{i} '.png']);
end

%--------------------------------------------------------------------------
% Demo (no submission required)
%--------------------------------------------------------------------------
%%
function demoMATLABTricks()
demoMATLABTricksFun;
