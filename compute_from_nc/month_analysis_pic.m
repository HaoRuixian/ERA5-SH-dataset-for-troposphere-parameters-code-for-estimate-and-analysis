clc
clear



lat = 30;
lat_indx = 91 - lat;

lon = 120;
if lon < 0
    lon_indx = 360 + lon;
else
    lon_indx = lon +1;
end
load("DEM.mat")
h = DEM(lon_indx,lat_indx);
%% load data
for d = 5:6
    if d == 1
        datastr = 'PWVSH';
        varstr = 'PWV';
    elseif d == 2
        datastr = 'WVSH';
        varstr = 'SVD';
    elseif d == 3
        datastr = 'TmSH';
        varstr = 'Tm';
    elseif d == 4
        datastr = 'ZTDSH';
        varstr = 'ZTD';
    elseif d == 5
        datastr = 'ZHDSH';
        varstr = 'ZHD';
    elseif d == 6
        datastr = 'ZWDSH';
        varstr = 'ZWD';
    end
    SH_all = [];
    data_all = [];

    for year = 2013:2022
        yearstr = num2str(year);
        SHObject = matfile(strcat("F:\DATASET\points\",datastr,"\",yearstr,datastr,"_R.mat"));
        dataObject = matfile(strcat("F:\DATASET\points\",varstr,"\",yearstr,varstr,".mat"));

        if d == 1
            SHvar = SHObject.PWVSH((lon_indx-1)*181+lat_indx,:);
            datavar = dataObject.PWV((lon_indx-1)*181+lat_indx,:);
        elseif d == 2
            SHvar = SHObject.WVSH((lon_indx-1)*181+lat_indx,:);
            datavar = dataObject.SVD((lon_indx-1)*181+lat_indx,:);
        elseif d == 3
            SHvar = SHObject.TmSH((lon_indx-1)*181+lat_indx,:);
            datavar = dataObject.Tm((lon_indx-1)*181+lat_indx,:);
        elseif d == 4
            SHvar = SHObject.ZTDSH((lon_indx-1)*181+lat_indx,:);
            datavar = dataObject.ZTD((lon_indx-1)*181+lat_indx,:);
        elseif d == 5
            SHvar = SHObject.ZHDSH((lon_indx-1)*181+lat_indx,:);
            datavar = dataObject.ZHD((lon_indx-1)*181+lat_indx,:);
        elseif d == 6
            SHvar = SHObject.ZWDSH((lon_indx-1)*181+lat_indx,:);
            datavar = dataObject.ZWD((lon_indx-1)*181+lat_indx,:);
        end

        SH_all = [SH_all SHvar];
        data_all = [data_all datavar];
    end

    %%
    % 创建日期时间向量
    startDate = datetime(2012, 12, 31, 24,0,0); % 开始日期
    endDate = datetime(2022, 12, 31, 23,0,0); % 结束日期
    dateTimeVector = startDate:hours(1):endDate;

    % 按月份分解数据

    months = month(dateTimeVector);
    monthsUnique = unique(months);
    dataByMonth = splitapply(@(x) {x}, SH_all, months);

    % 将数据存储在一个cell数组中，每个单元格包含一个月份的数据
    dataCellArray = cell(1, 12);
    for i = 1:length(monthsUnique)
        dataCellArray{i} = dataByMonth{monthsUnique(i)};
    end

    figure
    hold on
    for mon = 1:12
        data_mon = dataCellArray{mon};
        [~,out_indx] = rmoutliers(data_mon,"grubbs");
        data_mon(out_indx) = nan;
        plot(data_mon,"DisplayName",strcat('month:',num2str(mon)))
        
    end
    legend
    box on
    xlabel('epoch')
    ylabel([datastr,'(km)'])
    hold off

%     figure
%     hold on
%     for mon = 1:3:12
%         data_mon = mean(cell2mat(dataCellArray{mon:mon+2}));
%         plot(data_mon)
%         
%     end
%     hold off
    %%
    start_date = datetime(2013, 1, 1);
    colors = [
        1 0 0;     % 红色
        0 0 1;     % 蓝色
        0 1 0;     % 绿色
        1 1 0;     % 黄色
        0.5 0 0.5; % 紫色
        1 0.5 0;   % 橙色
        0 1 1;     % 青色
        1 0 1;     % 品红
        0.6 0.4 0.2;% 棕色
        1 0.75 0.8;% 粉色
        0 0.5 0.5; % 水鸭蓝
        0.5 0.5 0.5;% 灰色
        ];
    figure
    hold on
    h_levels = h:350:30000;
    for t = 1:numel(SH_all)
        t_day = floor(t/24);
        target_date = start_date + t_day;
        t_mon = month(target_date);

        if t_mon == 10
            disp('stop')
        end

        data_sur = data_all(t);
        SH = SH_all(t);
        data_levels = data_sur * exp(-(h_levels-h)/(SH*1000));
        plot(data_levels, h_levels, 'Color',colors(t_mon,:))
    end
    xlabel(varstr)
    ylabel('ellipsoid height(m)')
    hold off


    
end