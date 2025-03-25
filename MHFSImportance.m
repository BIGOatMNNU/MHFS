%%% MHFSImportance
% create by ZiLng Lin
% 2023-3-21
function importOrDepend = MHFSImportance(samplesMatrix, labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF, current_B_index, current_a_index)
    if(nargin > 10) % calculate import = ¦Ã(B¡Èa) - ¦Ã(B)
        %2-3 MHFSDependence.m
        denpenBAnda = MHFSDependence(samplesMatrix(:, [current_B_index, current_a_index]), labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF);
        denpenB = MHFSDependence(samplesMatrix(:, current_B_index), labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF);

        importOrDepend = (denpenBAnda - denpenB);
    else % calculate denpendence ¦Ã(B)
        denpendence = MHFSDependence(samplesMatrix(:, current_B_index), labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF);
        
        importOrDepend = denpendence;
    end
end