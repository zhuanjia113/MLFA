function Local_ConvFeats = GetImageLocal_ConvFeats(net,im_raw)

% Time: 2026-6-12
% Function: Get the local Convolutional Feature of an image


% Some images may be grayscale. Replicate the image 3 times to
% create an RGB image.
if ismatrix(im_raw)
    img_rgb = single(cat(3,im_raw,im_raw,im_raw));
else
    img_rgb = im_raw;
end



img1 = imresize(img_rgb,[1232,1232]);


convFeat1 = activations(net,img1,'pool3');

Local_ConvFeats = Get_LocalRegionFeats(convFeat1);



