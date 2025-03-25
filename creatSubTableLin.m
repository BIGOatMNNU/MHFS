%%% creatSubTableLin
% create by ZiLng Lin
% 2023-2-15
%%% ��ÿ����Ҷ�ӽ�㴴����Ӧ�� Ψһ����ӱ�
function hierarchy_Y = creatSubTableLin(dataMatrix, tree)
    %0 ��ÿ����Ҷ�ӽ�㴴����Ӧ�� ����*��������ӱ�
    [dataCell, ~] = creatSubTablezh_lin(dataMatrix, tree);
    
    %1 ÿ���м������ʵ���
    data_len = length(dataCell);
    uniqueLabels = unique(dataCell{end}(:, end))';
    % uniqueLab_len = length(uniqueLabels); % �ܵı�ǩ���� ���ܴ��ڿձ�ǩ
    maxTrueLabel = uniqueLabels(end);
    dataUniqueCell = cell(1, data_len);
    for i = maxTrueLabel+1:data_len
        cell_i = dataCell{i};
        if(size(cell_i,1) == 0) % �м��������Ϊ��
            continue;
        else  % �м���������
            cell_i_label = cell_i(:,end)';
            cell_uniqueLabel = unique(cell_i_label);
            dataUniqueCell{i} = cell_uniqueLabel;
        end
    end
    hierarchy_Y = dataUniqueCell;
end