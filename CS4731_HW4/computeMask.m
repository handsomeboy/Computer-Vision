function mask = computeMask(img_cell)
mask = zeros(size(img_cell{1}));

for r=1:size(mask,1)
    for c=1:size(mask,2)
        for i=1:size(img_cell)
            if img_cell{i}(r,c) ~= 0
                mask(r,c) = 1;
            end;
        end;
    end;
end;