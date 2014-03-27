function out_img = blendImagePair(img1, mask1, img2, mask2, mode)
% mode is either 'overlay' or 'blend'

if strcmp(mode,'overlay')
    % copy img2 over img1 wherever mask2 applies
    
    result = img1;
    for r=1:size(img1,1)
        for c=1:size(img1,2)
            if mask2(r,c) ~= 0
                result(r,c,:) = img2(r,c,:);
            end
        end
    end
    out_img = result;
    
elseif strcmp(mode,'blend')
    result = zeros(size(img2));

    mask2=logical(mask2);
    mask1=logical(mask1);
    w2 = cat(3,mask2,mask2,mask2);
    w1 = cat(3,mask1,mask1,mask1);
    
    a = w2 .* im2double(img2) + w1 .* im2double(img1);
    a = a ./ (w1+w2);
    out_img=a;
    
else
    disp('incorrect value for mode');
end