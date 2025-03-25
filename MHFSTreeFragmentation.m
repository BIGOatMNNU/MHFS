%%% MHFSTreeFragmentation
% create by ZiLng Lin
% 2023-3-20
function [TF_degree, m_end, N_end] = MHFSTreeFragmentation(tree)
    %0-0 Finding the ancestors of leaf nodes
    allNodeArr = sort(tree(:,1),'ascend');
    minInterNode = allNodeArr(2); % begin from interNode:index Bridges leafNodeNumber = 7
    allNodeLen = length(allNodeArr);
    m_arr = zeros(1, allNodeLen);
    for i = minInterNode:allNodeLen
        interNode_index = i;
        interNode_indexArr = find(tree(:,1) == interNode_index);
        interNode_indexArrLen = length(interNode_indexArr);
        m_arr(i) = m_arr(i)+interNode_indexArrLen;
    end
    
    %1 Find the fork tree with intermediate nodes :m and  Total leaf node count :N
    m_arr(end) = []; % delete root Node
    m_arr_deleteEnd = m_arr;
    m = max(m_arr_deleteEnd); % A fork tree with intermediate nodes other than the root node
    N = minInterNode - 1; % Total leaf node count  % Total leaf node count: Bridges leafNodeNumber = 6
    
    %2 TF
    treef = log(N)/log(m);
    
    if(nargout == 1)
        TF_degree = round(treef); % Tree Fragmentation
    else
        m_end = m;
        N_end = N;
        TF_degree = round(treef); % Tree Fragmentation
    end
end