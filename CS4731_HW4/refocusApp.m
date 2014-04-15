function refocusApp(rgb_stack, depth_map)
% start with random index
i = randi(size(rgb_stack,3)/3,1);
while(true)
    % 1) display an image in the focal stack
    imshow(uint8(rgb_stack(:,:,3*i-2:3*i)));

    % 2) ask a user to choose a scene point
    [x,y] = ginput(1);
    x = round(x);
    y = round(y);

    if x > size(rgb_stack, 2) || x < 1 || y < 1 || y > size(rgb_stack,2)
        break;
    end;

    % 3) refocus the image s.t. the scene point is focused
    i = depth_map(y,x);

end
