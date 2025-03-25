%%% MHFSCoarseSearchStrategy
% create by ZiLng Lin
% 2023-3-22
function [diffIndex] = MHFSCoarseSearchStrategy(sortDistanceArr, originalIndexArr, uni_Y, treeHigh_max, labelAncestorsArr, label_i)
    % fprintf('use Coarse\n');
    %0 获得祖先结点 标签的所有祖先结点
    uniqueLabels = uni_Y{end};
    %0-1 获得中间结点的索引 % label_i=3 labelAncestors=[3 7 8]
    labelAncestors = labelAncestorsArr{label_i};
    labelAncestorsNum = length(labelAncestors);
    if (labelAncestorsNum > 2) % 才有中间结点
        intervalLabelIndex = labelAncestors(end-1); % 遍历到最后的中间结点
        sameUniqueLabel = uni_Y{intervalLabelIndex}; % 这些就是同类 [3 5 6]
        diffUniqueLabel = setdiff(uniqueLabels, sameUniqueLabel); % 这些就是异类 [1 2 4]
    else % 根结点下,H=1 && 是叶子结点
        sameUniqueLabel = label_i;
        diffUniqueLabel = setdiff(uniqueLabels, sameUniqueLabel); % 同类是label_i 异类是其他
    end

    % 鲁棒性考虑 前k个异类
    diff_k = 2;
%     if(treeHigh_max <= 2)
%         diff_k = 2;
%     else
%         diff_k = treeHigh_max;
%     end
    
    %1-1 数组寻找
    diffIndexTemp = 0; % 异类样本在排序后距离数组的index
    for i = 2:length(sortDistanceArr)
        %1-2 找异类
        if(ismember(sortDistanceArr(i,2), diffUniqueLabel))
            if(diffIndexTemp == 0)
                diffIndexTemp = originalIndexArr(i);
            else
                diffIndexTemp = [diffIndexTemp, originalIndexArr(i)];
            end
        end
        
        %1-3 同类异类是否都已经找到
        if(length(diffIndexTemp) >= diff_k)
            break;
        else
            continue;
        end
    end
    
    %2 找到树的 最近异类在排序后距离数组的index
    diffIndex = diffIndexTemp;
end