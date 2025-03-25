function dataHanled = MHFS_DataHandle(data_array)
    %%% 只有没有归一化的数据进行 归一化
    if(~isempty(data_array(data_array(:,1:end-1) < 0)))
        data_X = data_array(:, 1:end-1);
        data_Y = data_array(:, end);
        data_X = mapminmax(data_X, 0, 1);
        dataHanled = [data_X, data_Y];
    else
        dataHanled = data_array;
    end
end