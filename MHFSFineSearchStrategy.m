%%% MHFSFineSearchStrategy
% create by ZiLng Lin
% 2023-3-23
function [diffIndex] = MHFSFineSearchStrategy(sortDistanceArr, originalIndexArr, uni_Y, tree, label_i)
    % fprintf('use Fine\n');
    %0 ������Ƚ�� ��ǩ���������Ƚ��
    uniqueLabels = uni_Y{end};
    
    %0-2 ��ͬ�������ı�ǩ % 1���ֵ� i_label = 1 ����[2,4] % 2���ֵ� i_label = 1 ����[2,3,4,5,6]
    label_diff_sibAll = find( tree(label_i,2) == tree(:,2) );
    label_diff_sib = intersect(label_diff_sibAll,uniqueLabels);
    label_tureDiff_sib = setdiff(label_diff_sib,label_i);
    label_tureDiff_sibLen = length(label_tureDiff_sib);
    
    if(label_tureDiff_sibLen > 0)
        %0-2-1 ���ֵܽ�� [2,4]
        diffUniqueLabel = label_tureDiff_sib;
    else
        %0-2-2 ���ֵܽ�� �������� [3]
        diffUniqueLabels = setdiff(uniqueLabels, label_i); % ��Щ�������� [1 2 4 5 6]
        diffUniqueLabelsLen = length(diffUniqueLabels);
        diffUniqueLabelRand = randperm(diffUniqueLabelsLen); % Ȼ�����һ������
        diffUniqueLabel = diffUniqueLabels(diffUniqueLabelRand(1));
    end
    
    % ³���Կ��� ǰk������,��ʱ��ϸ���Ȳ��,��˲�����̫������
    diff_k = 1;
    
    %1-1 ����Ѱ���Ż�
    deleteSelf = 1; % �Լ���λ��Ҫɾ�� ��index = 2��ʼ��
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
    
    %2 �ҵ����� ����������������������index
    diffIndex = diffIndexTemp;
end