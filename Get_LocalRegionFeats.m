function  local_region_feats = Get_LocalRegionFeats(X)

% 时间：2026-6-12
% 功能：提取图像局部区域特征
% 参数说明：
% X：H × W × d dimensional feature image extracted from I
% local_region_feats:   cell structure 

[height,width,numChannels] = size(X);



index = 1;
lamda = 1e-7;
for gridStep = 4:4:24
    gridX = 1:gridStep:width;
    gridY = 1:gridStep:height;
    
    for i = 1:length(gridY)-1
    
        for j = 1:length(gridX)-1
    
             patch_block = X(gridY(i):gridY(i+1)-1,gridX(j):gridX(j+1)-1,:);
        
             vecs = mac_act(patch_block); % get mac per region;

             local_region_feats(:,index) = vecs;
             
             index = index + 1;
                 
             vecs = [];

    
        end
    
    end

end
