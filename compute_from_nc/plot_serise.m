set(0,'defaultAxesFontSize', 13);
set(0,'defaultTextFontSize', 13);

tiledlayout(6,6,"TileSpacing","tight");
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
    var_all = [];
   
    for year = 2013:2022
        yearstr = num2str(year);
        Object = matfile(strcat("G:\DATASET\points\",datastr,"\",yearstr,datastr,"_R.mat"));

        if d == 1
            var = Object.PWVSH(0*181+91,:);
        elseif d == 2
            var = Object.WVSH(0*181+91,:);
        elseif d == 3
            var = Object.TmSH(0*181+91,:);
        elseif d == 4
            var = Object.ZTDSH(0*181+91,:);
        elseif d == 5
            var = Object.ZHDSH(0*181+91,:);
        elseif d == 6
            var = Object.ZWDSH(0*181+91,:);
        end

        var_all = [var_all var];

    end
    startDate = datenum('01-01-2013');
    endDate = datenum('12-31-2022');
    time = linspace(startDate,endDate,(365*10+2)*24);


%     filtered_data = slidingWindowOutlierDetection(var_all, 24*15);
[~,TFrm] = rmoutliers(var_all,"grubbs");
var_all(TFrm) = nan;
filtered_data = var_all;
% filtered_data = var_all;
    SH_data.(datastr) = filtered_data;

    nexttile([1,5])
    s = scatter(time,filtered_data,2,'filled');
    s.MarkerEdgeColor = [0.75 0.75 0.75];
    s.MarkerFaceColor = [0.75 0.75 0.75];
    hold on
    [data_fit, residuals, bias, rmse, a_fit] = model_fits(time, filtered_data);
    p = plot(time, data_fit,LineWidth=3);
    p.Color = 'r';

    mean_value = nanmean(filtered_data);
    yline(mean_value,'-',sprintf(' mean: %.2fkm', mean_value),'Color','blue','FontSize',20);
    ylabel(strcat(datastr,"/km"),"FontSize",20)
    datetick('x','yyyy')
    xlim([startDate,endDate])
    ylim([nanmin(filtered_data),nanmax(filtered_data)])
%     yticks(gcf,"FontSize",20)
    if d < 6
        set(gca,"XTick",[])
    else 
        xlabel("Time","FontSize",20)
    end
    set(gca,'FontWeight','bold');
    set(gca,'FontName','Times');
    box on
    grid on
    hold off

    nexttile([1,1])
    boxchart(filtered_data)
    quartiles = quantile(filtered_data, [0.25, 0.75]);
    median_value = nanmedian(filtered_data);


    % 在图中标注上下四分位数、中位数和均值
    hold on;
    text(1.1, quartiles(1), sprintf(' Q1: %.2f', quartiles(1)), 'VerticalAlignment', 'top','FontSize',20); % 下四分位数
    text(1.1, quartiles(2), sprintf(' Q3: %.2f', quartiles(2)), 'VerticalAlignment', 'bottom','FontSize',20); % 上四分位数
    text(1.1, median_value, sprintf(' Median: %.2f', median_value), 'VerticalAlignment', 'middle','FontSize',20); % 中位数
    % 隐藏y轴刻度
    ylim([nanmin(filtered_data),nanmax(filtered_data)])
    set(gca,'YTick',[],'XTick',[]);
    box on
    hold off;
end

%%
figure
boxchart(SH_data.ZTDSH)

%%

% 假设你已经有了以下变量：
% original_time_series: 原始时间序列
% fitted_time_series: 拟合后的序列
% rmse: RMSE
% bias: 偏差
% confidence_interval: 95% 置信区间

% 绘制原始时间序列
original_time_series = filtered_data;
plot(original_time_series, 'b', 'LineWidth', 1.5);
hold on;

% 绘制拟合后的序列
fitted_time_series = data_fit;
plot(fitted_time_series, 'r', 'LineWidth', 1.5);

% % 绘制误差条 (RMSE)
% errorbar(1:length(rmse), fitted_time_series, rmse, 'g', 'LineStyle', 'none', 'LineWidth', 1.5);
%
% % 绘制误差条 (偏差)
% errorbar(1:length(bias), fitted_time_series, bias, 'm', 'LineStyle', 'none', 'LineWidth', 1.5);

% 绘制置信区间
fill([1:length(fitted_time_series), fliplr(1:length(fitted_time_series))], ...
    [fitted_time_series - confidence_interval, fliplr(fitted_time_series + confidence_interval)], ...
    'y', 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% 设置图例
legend('Original Time Series', 'Fitted Time Series', 'RMSE', 'Bias', '95% Confidence Interval');

% 添加标题和标签
title('Fitted Time Series with Error Bars and 95% Confidence Interval');
xlabel('Time');
ylabel('Value');

% 显示图形
hold off;