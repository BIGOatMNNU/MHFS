%%% MHFSMain
% create by ZiLng Lin
% 2023-3-20
%%% input 
%   kernelType = 'St' or 'TheTa_sigma';
%   treeFragile = 'Coarse' or 'Fine'
function [allRankFeatures, reducedFeatures, otherRankFeatures, irrelevantFeatures, time] = MHFSMain(dataMatrix, tree, kernelType, sigma, delta, treeFragile)
    %0-0 Create hierarchically unique Labels
    hierarchy_Y = creatSubTableLin(dataMatrix, tree);
    unique_Y = hierarchy_Y; % Unique labels for each level of the hierarchy
    uniqueLabels = unique_Y{end}; % true label
    
    %0-1 the nodes of the ancestors of each label
    labelAncestorsArrNum = uniqueLabels(end);
    labelAncestorsArr = cell(1, labelAncestorsArrNum);
    for i = 1:labelAncestorsArrNum %%par
        labelAncestorsArr{i} = tree_Ancestor(tree, i, 1);
    end
    
    %0-2 Calculate tree maximum height
    treeHigh_max = max(tree(:,2));
    
    %0-3 Calculate treeFragile
    if(nargin > 5) % have treeFragile
        TF = MHFSOurerTFHandle(treeFragile, treeHigh_max);
    else
        TF = MHFSTFHandle(tree, treeHigh_max);
    end
    
    % [2 9 6 7 1 3 4 5 8 10 11] -> [2 9 4 8 6 3]
    [~, featuresAndLabel] = size(dataMatrix); % samples
    samplesMatrix = dataMatrix(:, 1:end-1);
    features = featuresAndLabel-1; % How many features are there in total
    originalFeaturesArr = 1:features; % festure array
    labels = dataMatrix(:, featuresAndLabel);
    
    tic; % time begin
    %1 Calculate Total γC .Fixed value. Root node.Dependency of total feature
    %%%new C-B%%%1
    allFeaturesDepend = MHFSImportance(samplesMatrix, labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF, originalFeaturesArr);
    
    %1-1 Parallel computing of each feature a γ A value
    featureNumber = length(originalFeaturesArr);
    featuresDependArr = zeros(1, featureNumber); % Storage Feature Dependency γ Array of
    parfor j = 1:featureNumber %%par
        featureAndLabel_j = originalFeaturesArr(j);
        depend_j = MHFSImportance(samplesMatrix, labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF, featureAndLabel_j);
        featuresDependArr(j) = depend_j;
    end
    
    %1-2 sort γa. no root node. % sortFeaturesDependArr
    [sortFeaturesDependArr, sortOriginalIndex] = sort(featuresDependArr, 'descend'); % Sort in descending order by column 1
    sortOriginalIndex
    %1-3 Remove features with a total number of features * 30%
    deleteLength = round(length(sortOriginalIndex) * (0.1)); % Directly take the percentage at the end of the array
    irrelevantFeatures = sortOriginalIndex(:, featureNumber-deleteLength+1:featureNumber);
    sortOriginalIndex = sortOriginalIndex(:, 1:featureNumber-deleteLength);
    
    %%%new C-B%%%2
    sortFeaturesDependArr = sortFeaturesDependArr(:, 1:featureNumber-deleteLength);
    originalFeaturesArr = intersect(originalFeaturesArr, sortOriginalIndex); % intersect
    
    %2 γC - γB < δ (δ = δ*(Node number sample/Total Samples))
    reducedFeaturesB = sortOriginalIndex(1); % features of final reduction
    originalFeaturesArr = setdiff(originalFeaturesArr, reducedFeaturesB);
    %%%new C-B%%%3
    reducedFeaturesDepB = sortFeaturesDependArr(1); % 最后约简的特征数组B的依赖度
%     importance_C_B = allFeaturesDepend - reducedFeaturesDepB;
    
    %2-0 equation1 (importance_C_B)
    %%%new C-B%%%4
    while(length(originalFeaturesArr) > 1) % importance_C_B > 0 &&
        %2-1 max(B and a)
        curentFeatureNumber = length(originalFeaturesArr); % Number of existing features
        curentFeaturesDependArr = zeros(1, curentFeatureNumber); % This is the storage feature dependency γ Array of.
        parfor k = 1:curentFeatureNumber %%par
            index = originalFeaturesArr(k); % original feature index
            importance_B_a = MHFSImportance(samplesMatrix, labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF, reducedFeaturesB, index);
            curentFeaturesDependArr(k) = importance_B_a;
        end
        [maxFeaturesImport, maxOriginalIndex] = max(curentFeaturesDependArr); % sortrow by 1 row 
        
        %2-2 Equation2 max(B and a) > 0
        %%%new C-B%%%5
        if(maxFeaturesImport(1) > 0 && (allFeaturesDepend - reducedFeaturesDepB) > delta) % && (allFeaturesDepend - reducedFeaturesDepB) > delta
            %2-1-1 B <- a;C delete a
            reducedFeaturesB = [reducedFeaturesB, originalFeaturesArr(maxOriginalIndex)];
            
            %originalFeaturesArr = setdiff(originalFeaturesArr, originalFeaturesArr(maxOriginalIndex));
            %otherRankFeatures = originalFeaturesArr;
            
            for ii = 1:length(reducedFeaturesB)
                sortOriginalIndex(sortOriginalIndex == reducedFeaturesB(ii)) = [];
            end
            originalFeaturesArr = sortOriginalIndex;
            otherRankFeatures = sortOriginalIndex;
            
            reducedFeaturesB
            
            %%%new C-B%%%6
            reducedFeaturesDepB = MHFSImportance(samplesMatrix, labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF, reducedFeaturesB);
%             importance_C_B = allFeaturesDepend - reducedFeaturesDepB; %%% importance_C_B < δ
        else
            originalFeaturesArr = []; %%% There are no important features left blank
        end
    end
    
    %3 Attribute Set B Output
	reducedFeatures = reducedFeaturesB; % features of final reduction
    allRankFeatures = [reducedFeaturesB, otherRankFeatures, irrelevantFeatures];
    time = toc;
end