%%% creatSubTableLin
% create by ZiLng Lin
% 2023-2-15
%%% 给每个非叶子结点创建对应的 唯一类别子表
function hierarchy_Y = creatSubTableLin(dataMatrix, tree)
    %0 给每个非叶子结点创建对应的 样本*类别数的子表
    [dataCell, ~] = creatSubTablezh_lin(dataMatrix, tree);
    
    %1 每个中间结点的真实结点
    data_len = length(dataCell);
    uniqueLabels = unique(dataCell{end}(:, end))';
    % uniqueLab_len = length(uniqueLabels); % 总的标签数量 可能存在空标签
    maxTrueLabel = uniqueLabels(end);
    dataUniqueCell = cell(1, data_len);
    for i = maxTrueLabel+1:data_len
        cell_i = dataCell{i};
        if(size(cell_i,1) == 0) % 中间结点的样本为空
            continue;
        else  % 中间结点有样本
            cell_i_label = cell_i(:,end)';
            cell_uniqueLabel = unique(cell_i_label);
            dataUniqueCell{i} = cell_uniqueLabel;
        end
    end
    hierarchy_Y = dataUniqueCell;
end