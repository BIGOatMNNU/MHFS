function dataHanled = MHFS_DataHandle(data_array)
    %%% ֻ��û�й�һ�������ݽ��� ��һ��
    if(~isempty(data_array(data_array(:,1:end-1) < 0)))
        data_X = data_array(:, 1:end-1);
        data_Y = data_array(:, end);
        data_X = mapminmax(data_X, 0, 1);
        dataHanled = [data_X, data_Y];
    else
        dataHanled = data_array;
    end
end