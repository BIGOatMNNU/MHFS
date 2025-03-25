clc;
clear All;

%0 load
load ('BridgesTrain.mat');
data_array1 = data_array;
tree1 = tree;

%1 algorithm
delta = 0.2;
sigma = 0.2;
kernelType = 'St';
%TF = 'Coarse'; %Coarse
[allRankFeatures, reducedFeatures, ~, ~, time] = MHFSMain(data_array1, tree1, kernelType, sigma, delta);
allRankFeatures
reducedFeatures