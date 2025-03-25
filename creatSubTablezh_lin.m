%%% creatSubTable
% Written by Yu Wang
% Modified by Hong Zhao
% 2017-4-11
% Modified by Lin Zilong
% 2023-2-15
%%% ��ÿ����Ҷ�ӽ�㴴����Ӧ�� ����*��������ӱ�
function [DataMod, LabelMod] = creatSubTablezh_lin(dataset, tree)
    Data = dataset(:,1:end);
    Label = dataset(:,end);
    [numTrain,~] = size(dataset); % numTrain=3020 474
    internalNodes = tree_InternalNodes(tree); % �����м�ڵ�ĸ���
    indexRoot = tree_Root(tree); %The root of the tree
    noLeafNode = [internalNodes;indexRoot]; % ��Ҷ�ӽ��=�м�ڵ�+���ڵ�
    
    for i = 1:length(noLeafNode)
        cur_descendants = tree_Descendant(tree, noLeafNode(i)); % ����28�����е�λ��
        ind_d = 1; %index for id subscript increment id�±���������
        id = []; %data whose labels belong to the descendants of the current nodes
        
        for n = 1:numTrain % ��������
            if (ismember(Label(n), cur_descendants) ~= 0) % ��������ı�ǩ��������index�ͼ���
                id(ind_d) = n;
                ind_d = ind_d +1;
            end
        end
        Label_Uni_Sel = Label(id,:); % ������Щ�����ı�ǩ
        DataSel = Data(id,:); %select relative training data for the current classifier
        
        numTrainSel = size(Label_Uni_Sel,1); % ������Щ�����ı�ǩ�Ĵ�С
        LabelUniSelMod = label_modify_MLNP(Label_Uni_Sel, noLeafNode(i), tree); % ��Label_Uni_Selһ��
        
        %Get the sub-training set containing only relative nodes ��ȡ��������ؽڵ����ѵ����
        ind_tdm = 1;
        index = []; %data whose labels belong to the children of the current nodes
        children_set = get_children_set(tree, noLeafNode(i)); % ��ȡ��ǰ�ڵ��ֱ���ӽڵ� cur_descendants
        
        for ns = 1:numTrainSel % ������ 503������� ������һ��
            if (ismember(LabelUniSelMod(ns), children_set) ~= 0)
                index(ind_tdm) = ns;
                ind_tdm = ind_tdm +1;
            end
        end
        
        % ����Ҫ�������ؽڵ����ѵ����
        DataMod{noLeafNode(i)} = DataSel(index, :); %Find the sub training set of relative to-be-classified nodes
        LabelMod{noLeafNode(i)} = LabelUniSelMod(index, :);

    end
end