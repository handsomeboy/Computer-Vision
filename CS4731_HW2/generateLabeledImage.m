function labeled_img = generateLabeledImage(gray_img, threshold)
bw_img = im2bw(gray_img, threshold);

[labels, n] = bwlabel(bw_img);
labeled_img = labels;
end