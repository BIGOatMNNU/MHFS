%%% MHFSMain
% create by ZiLng Lin
% 2023-3-20
function dependence = MHFSDependence(data, labels, labelAncestorsArr, hierarchy_Y, kernelType, sigma, tree, treeHigh_max, TF)
    samplesNum = size(data, 1);
    %originalFeatureIndex = 1:samplesNum; % ”–Œ Ã‚
    dependenceArr = zeros(1,samplesNum);
    
    %1 get sample distance
    dataTemp = data;
    sampleDis = pdist(dataTemp, 'euclidean');
    sampleDistance = squareform(sampleDis); % samplesNum * samplesNum
    
    distanceArrAll = [sampleDistance, labels];
    
    %2 use Search Strategy find different and same Labels
    parfor i = 1:samplesNum %%par
        %label_i = labels(originalFeatureIndex(i));
        label_i = labels(i); % the label of sample_i
        %distanceArr = [sampleDistance(:,i), labels]; % the label of sample_i and feature
        distanceArr = getDistanceArr(distanceArrAll, i);
        
        %2-1 sortrows and use Search Strategy
        [sortDistanceArr, originalIndexArr] = sortrows(distanceArr, 1); % sortrows
        switch TF %'Coarse' or 'Fine'
            case 'Coarse'
                [diffIndex] = MHFSCoarseSearchStrategy(sortDistanceArr, originalIndexArr, hierarchy_Y, treeHigh_max, labelAncestorsArr, label_i);
            case 'Fine'
                [diffIndex] = MHFSFineSearchStrategy(sortDistanceArr, originalIndexArr, hierarchy_Y, tree, label_i);
        end
        
        %2-2 use Gaussian kernel function to calculate ¶√
        %x_y_distance = sampleDistance(diffIndex,i);
        x_y_distance = get_x_y_distance(sampleDistance,diffIndex,i);
        x_y_distanceSqrt = x_y_distance.^2;
        x_y_distanceNum = length(x_y_distanceSqrt);
        switch kernelType % 'St' or 'TheTa_sigma'
            case 'St'
                kernels = sum( ones(size(x_y_distanceSqrt)) - exp( -x_y_distanceSqrt / (2*sigma^2) ) );
            case 'TheTa_sigma'
		x_y_distanceSqrt = abs(x_y_distance);
                kernels = sqrt( sum( ones(size(x_y_distanceSqrt)) - (exp( -x_y_distanceSqrt / (2*sigma) )).^2 ) );
        end
        dependenceArr(i) = kernels / x_y_distanceNum;
    end
    
    %3 dependence of the feature ¶√
    dependence = sum(dependenceArr)/samplesNum;
end

function distanceArr = getDistanceArr(data, index)
    distanceArr = data(:,[index,end]);
end

function x_y_distance = get_x_y_distance(data, diffIndex, index)
    x_y_distance = data(diffIndex,index);
end