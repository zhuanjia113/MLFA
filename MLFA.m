
% Time: 2026-6-12
% Function: Multi-scale Local-Region Feature Aggregation Method

clear;clc;close all;

addpath('include/vlfeat-0.9.20/toolbox/');
addpath('include/rmac-master/');



vl_setup;

vl_version  verbose;

tic;

% 1.Load and Explore the Image Data

dataPath = 'data/SoyCultivar200_Lower';

digitData = imageDatastore(dataPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');


img_num = length(digitData.Files);              % the number of images


% load the deep nerual network model
net = vgg16;

% 2. Extract the local region convolutional feature

[LocalConv,class_label] = GetImg_RegionFeature(net,digitData);

VLADConv_feats = GetVLADEncoding(LocalConv);


% 3. Compute the distance

dist_vlad = pdist(VLADConv_feats,'cosine');
dist_vlad_m = squareform(dist_vlad);

dist_vlad_m_norm = dist_vlad_m./max(dist_vlad_m,[],2);

dist = dist_vlad_m_norm;

% 4. Evaluate the retrieval Performance

disp('the Bulleye Score ......');
Bull_eye_Score = Get_BullEyeScore(dist,class_label);
fprintf('Bull_Score =  %.4f \n', Bull_eye_Score);

toc;
