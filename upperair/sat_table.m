for d = 1:6
    if d == 1
        datastr = 'PWVSH';
    elseif d == 2
        datastr = 'WVSH';
    elseif d == 3
        datastr = 'TmSH';
    elseif d == 4
        datastr = 'ZTDSH';
    elseif d == 5
        datastr = 'ZHDSH';
    elseif d == 6
        datastr = 'ZWDSH';
    end
    load(strcat(pwd,'/',datastr,'2022_verify_info.mat'));
    data = verify_info(verify_info(:,5)>400 & verify_info(:,4)>0.5,:);
    rmse_max = max(data(:, 2));
    rmse_min = min(data(:, 2));
    rmse_mean = nanmean(data(:, 2));

    bias_max = max(data(:, 3));
    bias_min = min(data(:, 3));
    bias_mean = nanmean(data(:, 3));

    r_max = max(data(:, 4));
    r_min = min(data(:, 4));
    r_mean = nanmean(data(:, 4));

    rrmse_mean = nanmean(data(:, 1));
    rrmse_max = max(data(:, 1));
    rrmse_min = min(data(:, 1));

    % 填入结果表格
    result_table(d, :) = [rmse_max, rmse_min, rmse_mean, ...
        rrmse_max*100, rrmse_min*100, rrmse_mean*100, ...
        bias_max, bias_min, bias_mean, ...
        r_max, r_min, r_mean, ...
        ]; 
end