function encoding_features=GetVLADEncoding2(feats)

% 时间:2020年5月20日
% Function: 采用VLAD进行特征编码
% 参数说明：
% feats: 需要编码的局部特征(比如许多图像的SIFT特征)  cell结构   cell结构中每一个特征为一个矩阵  dim*numFeatures(维度*特征的数量)
% encoding_features：编码之后的特征

feats_all = single(cell2mat(feats));

% num_rad = randperm(length(feats),2000);
% feats_all = single(cell2mat(feats(num_rad)));

% k-means cluster
num_cluster = 256;
[codebook, assign] = vl_kmeans(feats_all, num_cluster);


for iter1 = 1:numel(feats)  
    if ~mod(iter1, 50)
        fprintf('.\n');
    else
        fprintf('.');
    end
    
    feat_sc=feats{iter1};
    
    % 先采用kd-tree进行量化kd-tree for quantization:
    kdtree = vl_kdtreebuild(codebook);
    
    nn = vl_kdtreequery(kdtree, double(codebook), feat_sc) ;     %feat_sc：d*N（d表示特征的维度，N表示一张图像总共提取的特征）
    
    % 下面创建一个分布矩阵 create an assignment matrix:
    assignments = zeros(num_cluster,size(feat_sc,2));
    assignments(sub2ind(size(assignments), double(nn), 1:length(nn))) = 1;

    % 下面采用VLAD进行编码
    enc = vl_vlad(feat_sc,double(codebook),assignments);     %在调用的时候数据类型要一致。如都为double或者都为single类型。
    
    sc_fea(:, iter1) = enc;
    
end

 clear codebook feats_all ;

 % 下面进行Power Normalized与L2范数归一化。从而提高improved Fisher Vector的分类性能
 for i=1:numel(feats)  
     fea_PN=(abs(sc_fea(:,i)).^0.2).*sign(sc_fea(:,i));       %进行Power Normalized
     
     sc_fea(:,i)=fea_PN./norm(fea_PN);                         %L2范数归一化
 end
 
 % 采用pca进行降维
 coeff = pca(sc_fea','NumComponents',128);     %降到特征维度为512

sc_fea2=sc_fea'*coeff;

%sc_fea2=sc_fea2';

clear sc_fea coeff;


encoding_features=sc_fea2;
