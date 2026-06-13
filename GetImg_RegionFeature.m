function [dataFeatures,dataLabels]=GetImg_RegionFeature(net,digitData)

% time:2025-7-6
% Function: Compute the image convolutional feature
% Parameters:
% INPUT: digitData: need to calculate the image feature   datastore type
% OUTPUT:
% dataFeatures：all image features  
% dataLabels: the labels of all images

img_num = length(digitData.Files);              % the number of images
dataLabels = grp2idx(digitData.Labels);         % convet categorial type to double type


LocalConv = cell(1,img_num);                   

for m = 1:img_num
    %disp(m);
    fprintf('handle %d of %d\n', m , img_num);
    img_raw = readimage(digitData,m);

    Lc_conv1= GetImageLocal_ConvFeats(net,img_raw);

    LocalConv{m} = double(Lc_conv1);

    Lc_conv1 = [];
end

dataFeatures = LocalConv;