%%% MHFSOurerTFHandle
% create by ZiLng Lin
% 2023-3-25
function TFOurer = MHFSOurerTFHandle(treeFragile, treeHigh_max)
    if((treeHigh_max <= 2) && strcmp(treeFragile,'Coarse')) % tree High is 2
        TFOurer = 'Coarse';
    else
        TFOurer = treeFragile;
    end
end