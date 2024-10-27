clc
clear 

% location = [1,90];
lon_lim = [1,360];
lat_lim = [45,60];
%% load data
H_all = [];
PWV_all = [];
p0_all = [];

for year = 2016:2019
    for month = 1:12
        % daynum
        if month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12
            daynum = 31;
        elseif month==4 || month==6 || month==9 || month==11
            daynum = 30;
        elseif month == 2
            if (mod(year,4)==0 && mod(year,400)~=0) || mod(year,400)==0
                daynum = 29;
            else
                daynum = 28;
            end
        end
        
        for day = 1:daynum
            if month < 10
                monthstr = strcat('0', num2str(month));
            else
                monthstr = num2str(month);
            end
            yearstr = num2str(year);

            if day<10
                daystr = strcat('0',num2str(day));
            else
                daystr = num2str(day);
            end
           
            path = strcat("F:/Results/",yearstr,"/",yearstr,monthstr,daystr,".mat");
            load(path,"H","PWV");
            
            for hour = 1:24
                H_r = H(lon_lim(1):lon_lim(2) , lat_lim(1):lat_lim(2) , hour);
                H_r(H_r > 6.5) = nan;
                H_m = nanmean(nanmean(H_r));
                H_all = [H_all, H_m];

                PWV_r = PWV(lon_lim(1):lon_lim(2) , lat_lim(1):lat_lim(2) , hour);
                PWV_m = nanmean(nanmean(PWV_r));
                PWV_all = [PWV_all, PWV_m];
%                 ind = (year-2016)*24 + (year-2016)*365*24 + (month-1)*daynum*24 + (day-1)*24 + hour;
%                 H_all = [H_all H(location(1),location(2),hour)];
%                 PWV_all = [PWV_all PWV(location(1),location(2),hour)];
%                 p0_all = [p0_all p0(location(1),location(2),hour)];
            end
            
        end
        
    end
end
%% 
H_all = H_series;
H_all = slidingWindowOutlierDetection(H_all,24*15);
PWV_all = slidingWindowOutlierDetection(PWV_all,24*15);
% p0_all = remove_outliers(p0_all);
%% draw the picture    
H_all(H_all == 0) = nan;
% PWV_all(PWV_all == 0) = nan;
H_all(H_all > 4 | H_all < 0) = nan;
set(gca,'FontWeight','bold');
set(gca,'FontName','Times');
grid on
box on
epoch = 1: numel(H_all);
plot(H_all, 'color','k')
xlabel("epoch")
ylabel("H/km")
xlim([1,numel(epoch)])
title("H Time series")


%% model fitting
[data_fit, residuals] = model_fit(epoch.',H_all);
model_fit(epoch,PWV_all)
model_fit(epoch,p0_all)
%% 
plotPowerSpectrum(PWV_all)

%% 
% residuals_s = slidingWindowOutlierDetection(residuals,24*15);
% residuals_indx = residuals<-0.45 | residuals>0.45;
% residuals_s = residuals;
% residuals_s(residuals_indx) = nan;
scatter_density_plot(PWV_all,residuals)