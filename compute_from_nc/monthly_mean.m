clc
clear

region_mean_all = nan(6,12,6);
i = 0;
tiledlayout(6,1,"TileSpacing","compact")
for var = ["PWVSH","WVSH","TmSH","ZTDSH","ZHDSH","ZWDSH"]

    data = load(strcat("G:/DATASET/points/",var,"/2020",var,"_R.mat"),var);
    data = data.(var);

    days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    hours_in_month = days_in_month * 24;

    monthly_avg = zeros(181*360, 12);

    start_hour = 1;
    for month = 1:12
        end_hour = start_hour + hours_in_month(month) - 1;
        monthly_avg(:, month) = nanmean(data(:, start_hour:end_hour), 2);
        start_hour = end_hour + 1;
    end

    global_mean = reshape(monthly_avg,360,181,[]);

    region_mean = nan(6,12);
    for m = 1:12
        data_month = reshape(global_mean(:,1:180,m),360,30,6);
        for r = 1:6
            region_mean(r,m) = nanmean(nanmean(data_month(:,:,r),2),1);
        end
    end
    nexttile
    imagesc(region_mean)
    title(var)
    i = i+1;
    region_mean_all(:,:,i) = region_mean;
end

%%
i = 0;
load("region_mean.mat")
tiledlayout(2,3,"TileSpacing","compact")
for var = ["PWVSH","WVSH","TmSH","ZTDSH","ZHDSH","ZWDSH"]

    nexttile
    i = i+1;
    region_mean = region_mean_all(:,:,i);
    imagesc(region_mean)
    colormap(othercolor('YlGnBu9'))
    colorbar
    cb = colorbar;
    ylabel(cb, strcat(var,"/km"),"FontWeight","bold");
    if i<4
        xticks([]);
    else
        xticks(1:12);
        xticklabels({'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'});
    end
    yticks(1:6);
    %     yticklabels({'90°N', '60°N', '30°N', '50°', '30°S', '60°S'});
    if mod(i,3) == 1
        yticklabels({'R1', 'R2', 'R3', 'R4', 'R5', 'R6'});
    else
        yticks([])
    end

    set(gca, 'YDir', 'reverse');
    set(gca, 'TickDir', 'out','TickLength',[0,0]);

end