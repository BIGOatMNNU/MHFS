%%% MHFSCoarseSearchStrategy
% create by ZiLng Lin
% 2023-3-22
function [diffIndex] = MHFSCoarseSearchStrategy(sortDistanceArr, originalIndexArr, uni_Y, treeHigh_max, labelAncestorsArr, label_i)
    % fprintf('use Coarse\n');
    %0 ������Ƚ�� ��ǩ���������Ƚ��
    uniqueLabels = uni_Y{end};
    %0-1 ����м�������� % label_i=3 labelAncestors=[3 7 8]
    labelAncestors = labelAncestorsArr{label_i};
    labelAncestorsNum = length(labelAncestors);
    if (labelAncestorsNum > 2) % �����м���
        intervalLabelIndex = labelAncestors(end-1); % �����������м���
        sameUniqueLabel = uni_Y{intervalLabelIndex}; % ��Щ����ͬ�� [3 5 6]
        diffUniqueLabel = setdiff(uniqueLabels, sameUniqueLabel); % ��Щ�������� [1 2 4]
    else % �������,H=1 && ��Ҷ�ӽ��
        sameUniqueLabel = label_i;
        diffUniqueLabel = setdiff(uniqueLabels, sameUniqueLabel); % ͬ����label_i ����������
    end

    % ³���Կ��� ǰk������
    diff_k = 2;
%     if(treeHigh_max <= 2)
%         diff_k = 2;
%     else
%         diff_k = treeHigh_max;
%     end
    
    %1-1 ����Ѱ��
    diffIndexTemp = 0; % �����������������������index
    for i = 2:length(sortDistanceArr)
        %1-2 ������
        if(ismember(sortDistanceArr(i,2), diffUniqueLabel))
            if(diffIndexTemp == 0)
                diffIndexTemp = originalIndexArr(i);
            else
                diffIndexTemp = [diffIndexTemp, originalIndexArr(i)];
            end
        end
        
        %1-3 ͬ�������Ƿ��Ѿ��ҵ�
        if(length(diffIndexTemp) >= diff_k)
            break;
        else
            continue;
        end
    end
    
    %2 �ҵ����� ����������������������index
    diffIndex = diffIndexTemp;
end