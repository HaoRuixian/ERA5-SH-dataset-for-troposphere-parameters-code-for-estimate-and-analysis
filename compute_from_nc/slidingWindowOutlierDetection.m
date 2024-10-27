function filtered_data = slidingWindowOutlierDetection(data, window_size)
    
    filtered_data = data;
    half_window = floor(window_size / 2);
    
    % 获取时间序列的长度
    data_length = length(data);
    
    % 遍历时间序列数据
    for i = 1:data_length
        % 确保窗口不超出序列范围
        window_start = max(1, i - half_window);
        window_end = min(data_length, i + half_window);
        
        % 提取窗口内的数据
        window_data = data(window_start:window_end);
        
        q1 = quantile(window_data, 0.25); % 第一四分位数
        q3 = quantile(window_data, 0.75); % 第三四分位数
        IQR = q3 - q1;
        range = [q1-3*IQR , q3+3*IQR];
        % 判断当前数据是否为离群值
        if data(i) > range(2) || data(i) < range(1)
            
            filtered_data(i) = NaN;
        end
    end
end
