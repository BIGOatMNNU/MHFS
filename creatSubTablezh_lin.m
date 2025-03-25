%%% creatSubTable
% Written by Yu Wang
% Modified by Hong Zhao
% 2017-4-11
% Modified by Lin Zilong
% 2023-2-15
%%% 给每个非叶子结点创建对应的 样本*类别数的子表
function [DataMod, LabelMod] = creatSubTablezh_lin(dataset, tree)
    Data = dataset(:,1:end);
    Label = dataset(:,end);
    [numTrain,~] = size(dataset); % numTrain=3020 474
    internalNodes = tree_InternalNodes(tree); % 返回中间节点的个数
    indexRoot = tree_Root(tree); %The root of the tree
    noLeafNode = [internalNodes;indexRoot]; % 非叶子结点=中间节点+根节点
    
    for i = 1:length(noLeafNode)
        cur_descendants = tree_Descendant(tree, noLeafNode(i)); % 返回28在树中的位置
        ind_d = 1; %index for id subscript increment id下标增量索引
        id = []; %data whose labels belong to the descendants of the current nodes
        
        for n = 1:numTrain % 样本个数
            if (ismember(Label(n), cur_descendants) ~= 0) % 是这里面的标签的样本的index就加入
                id(ind_d) = n;
                ind_d = ind_d +1;
            end
        end
        Label_Uni_Sel = Label(id,:); % 所有这些样本的标签
        DataSel = Data(id,:); %select relative training data for the current classifier
        
        numTrainSel = size(Label_Uni_Sel,1); % 所有这些样本的标签的大小
        LabelUniSelMod = label_modify_MLNP(Label_Uni_Sel, noLeafNode(i), tree); % 和Label_Uni_Sel一样
        
        %Get the sub-training set containing only relative nodes 获取仅包含相关节点的子训练集
        ind_tdm = 1;
        index = []; %data whose labels belong to the children of the current nodes
        children_set = get_children_set(tree, noLeafNode(i)); % 获取当前节点的直接子节点 cur_descendants
        
        for ns = 1:numTrainSel % 遍历这 503这个样本 和上面一样
            if (ismember(LabelUniSelMod(ns), children_set) ~= 0)
                index(ind_tdm) = ns;
                ind_tdm = ind_tdm +1;
            end
        end
        
        % 查找要分类的相关节点的子训练集
        DataMod{noLeafNode(i)} = DataSel(index, :); %Find the sub training set of relative to-be-classified nodes
        LabelMod{noLeafNode(i)} = LabelUniSelMod(index, :);

    end
end