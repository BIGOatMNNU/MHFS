%%% MHFSFineSearchStrategy
% create by ZiLng Lin
% 2023-3-23
function [diffIndex] = MHFSFineSearchStrategy(sortDistanceArr, originalIndexArr, uni_Y, tree, label_i)
    % fprintf('use Fine\n');
    %0 获得祖先结点 标签的所有祖先结点
    uniqueLabels = uni_Y{end};
    
    %0-2 找同类和异类的标签 % 1有兄弟 i_label = 1 异类[2,4] % 2无兄弟 i_label = 1 异类[2,3,4,5,6]
    label_diff_sibAll = find( tree(label_i,2) == tree(:,2) );
    label_diff_sib = intersect(label_diff_sibAll,uniqueLabels);
    label_tureDiff_sib = setdiff(label_diff_sib,label_i);
    label_tureDiff_sibLen = length(label_tureDiff_sib);
    
    if(label_tureDiff_sibLen > 0)
        %0-2-1 有兄弟结点 [2,4]
        diffUniqueLabel = label_tureDiff_sib;
    else
        %0-2-2 无兄弟结点 排他策略 [3]
        diffUniqueLabels = setdiff(uniqueLabels, label_i); % 这些就是异类 [1 2 4 5 6]
        diffUniqueLabelsLen = length(diffUniqueLabels);
        diffUniqueLabelRand = randperm(diffUniqueLabelsLen); % 然后随机一个数据
        diffUniqueLabel = diffUniqueLabels(diffUniqueLabelRand(1));
    end
    
    % 鲁棒性考虑 前k个异类,此时是细粒度层次,因此不考虑太多异类
    diff_k = 1;
    
    %1-1 数组寻找优化
    deleteSelf = 1; % 自己的位置要删除 从index = 2开始算
    sortIndexNums = size(sortDistanceArr,1);
    sortDistanceIndex = sortDistanceArr(1+deleteSelf:sortIndexNums,2);
    diffIndexArr = [];
    for i = 1:length(diffUniqueLabel)
        index_i = diffUniqueLabel(i);
        diffIndex_i = find(sortDistanceIndex == index_i);
        diffIndexArr = union(diffIndexArr,diffIndex_i);
    end
    diffIndexLen = length(diffIndexArr);
    if(diffIndexLen > diff_k)
        diffIndexSortTemp = diffIndexArr(1:diff_k);
    else
        diffIndexSortTemp = diffIndexArr;
    end
    diffIndexTemp = originalIndexArr(diffIndexSortTemp+deleteSelf);
    
    %2 找到树的 最近异类在排序后距离数组的index
    diffIndex = diffIndexTemp;
end