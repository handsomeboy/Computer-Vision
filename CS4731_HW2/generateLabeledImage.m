function labeled_img = generateLabeledImage(gray_img, threshold)
% only pixels larger than threshold value
bw_img = (gray_img > threshold * 255);

[labels, n] = bwlabel(bw_img);
labeled_img = labels;
end