function  Bull_eye_Score = Get_BullEyeScore(AllImgDist,AllLabel)

% 时间：2021年2月18日
% 功能：采用Bull-eye Score来评价检索方法的性能
% @author：Chengzhuan Yang
% Parameter：
% INPUT： AllImgDist -> 数据集种每一张图像之间的距离  img_num*img_num
%         AllLabel -> 数据集每一张图像的类别标签
% OUTPUT：Bull_eye_Score：Bull-eye分数

[SortedDist,SortedIndex]=sort(AllImgDist,2);      %对所计算得到的距离进行排序(2 表示按照行的方向 1 表示按照列的方向)

mLengthFiles = size(AllImgDist,1);                 %数据集种所有图像的数量
%ClassCount2 = cell(1,mLengthFiles);
%img_num = zeros(1,mLengthFiles);

BullScore_each = zeros(1,mLengthFiles);
for i=1:mLengthFiles
    disp(i);
    inum = length(find(AllLabel==AllLabel(i)));
    inum2 = 2*inum;

    if(inum2>mLengthFiles)
        inum2 = mLengthFiles;
    end

    cNum=SortedIndex(i,1:inum2);
    ClassCount = zeros(1,inum2);
    for j=1:inum2  
        if(AllLabel(i)==AllLabel(cNum(j)))
                ClassCount(j)=ClassCount(j)+1;
        end  
    end

    ClassCount2{i} = ClassCount;
    img_num(i) = inum;

    %BullScore_each(i) = sum(ClassCount)/inum;
    
    ClassCount = []; %clear
end

GetResult = sum(cell2mat(ClassCount2));

Bull_eye_Score = GetResult/sum(img_num);

%Bull_eye_Score = mean(BullScore_each);
