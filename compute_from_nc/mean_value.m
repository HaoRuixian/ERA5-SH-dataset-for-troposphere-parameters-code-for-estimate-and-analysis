clc
clear

%% compute mean value (yearly monthly daily)
H_year_mean = nan(360,181,1);
PWV_year_mean = nan(360,181,1);
% p = parpool(3);
for year = 2023:2023
    H_month_mean = nan(360,181,12);
    PWV_month_mean = nan(360,181,12);
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
        H_day_mean = nan(360,181,daynum,12);
        PWV_day_mean = nan(360,181,daynum,12);
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
            H = load(path,"H");
            H = H.H;

            for hour = 1:24
                if hour<10
                    hourstr = strcat('0',num2str(hour));
                else
                    hourstr = num2str(hour);
                end
                data = H(:,:,hour);

                draw_picture_global(data)
                caxis([1,6])
                title(strcat(yearstr,'//',monthstr,'//',daystr,'//',hourstr))
%                 disp(sum(sum(data(data>10))))
%                 disp(numel(data(data>10)))
                savepath = strcat(pwd,"/2021_pic/",yearstr,monthstr,daystr,hourstr,".png");
                print(gcf, '-dpng', savepath)
            end
            % compute the mean value for one day
%             H_day_mean(:,:,day,month) = nanmean(H, 3);
%             PWV_day_mean(:,:,day,month) = nanmean(PWV, 3);
%             p0_day_mean(:,:,day) = nanmean(p0, 3);
%             temk_day_mean(:,:,day) = nanmean(tem_k, 3);

        end

        % compute the mean value for one month
%         H_month_mean(:,:,month) = nanmean(H_day_mean(:,:,:,month), 3);
%         PWV_month_mean(:,:,month) = nanmean(PWV_day_mean(:,:,:,month), 3);
    end
    % compute the mean value for one year
%     H_year_mean(:,:,year-2015) = nanmean(H_month_mean, 3);
%     PWV_year_mean(:,:,year-2015) = nanmean(PWV_month_mean, 3);
end
H_mean = nanmean(H_year_mean, 3);
PWV_mean = nanmean(PWV_year_mean, 3);
%% draw the picture
H_mean(H_mean<0) =nan;
draw_picture_global(H_mean)
c1 = colorbar;
% caxis([0,6])
set( c1, 'fontsize',15 ,'ticklabels',{'<1',(1.5:0.5:5.5),'>6'});
set(get(c1,'ylabel'), 'string','The Water Vapor Scale Height (km)','fontsize',20,'FontName','Times New Roman');
set(gca,'FontName','Times New Roman')
%% 
H_month_mean(H_month_mean<0) =nan;
t = tiledlayout(2,6,'TileSpacing','Compact','Padding','Compact');
for month = 1:12
    nexttile
    data = H_month_mean(:,:,month);

    draw_picture_global(data)
%     c1 = colorbar;
    caxis([1,6])
    set( c1, 'fontsize',7 ,'ticklabels',{'<1',(1.5:0.5:5.5),'>6'});
    set(get(c1,'ylabel'), 'string','The Water Vapor Scale Height (km)','fontsize',7,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman')
end
