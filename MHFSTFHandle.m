%%% MHFSTFHandle
% create by ZiLng Lin
% 2023-3-25
function TF = MHFSTFHandle(tree, treeHigh_max)
    TF_degree = MHFSTreeFragmentation(tree);
    %0-3-1 TF task
    if(treeHigh_max <= 2) % tree High is2
        if (TF_degree <= 1)
            inerTF = 'Fine'; % TF_degree = 1;
        else
            inerTF = 'Coarse'; % TF_degree = 2;
        end
    else % tree High >= 3
        if (TF_degree <= 1)
            inerTF = 'Fine'; % TF_degree = 1;
        else
            inerTF = 'Coarse'; % TF_degree = 2;
        end
    end
    TF = inerTF;
end