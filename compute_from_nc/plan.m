clc
clear 

for year = 2019:2019
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
            path_pwv = strcat("F:/Results/",yearstr,"/",yearstr,monthstr,daystr,".mat");
            load(path_pwv,"pwv_levels")
            path_ellipsoid = strcat("F:/Results/",yearstr,"/","ellipsoid/",yearstr,monthstr,daystr,"ellipsoid.mat");
            load(path_ellipsoid)
            for hour = 1:24
                % Latitude of planing
                for la = 90:20:150
                    %% 
                    ellipsoid_p = elliposoid(:,la,:,hour);
                    pwv_levels_ = pwv_levels(:,la,:,hour);

                    ellipsoid_p = squeeze(ellipsoid_p);
                    ellipsoid_p = ellipsoid_p(:,1:23);
                    pwv_levels_ = squeeze(pwv_levels_);

                    for k = 1:23
                        pwv_levels_p(:,k) = sum(pwv_levels_(:,k:23),2);
                    end
                    h = pcolor( pwv_levels_p.');
                    set(h,'edgecolor','none');
                    hold on
                    contour((ellipsoid_p./1000).','ShowText','on','LineColor','k')
%                     caxis([0,7.5])
                    colormap("cool")
                    xticks([1 60 120 180 240 300 360])
                    xticklabels({'0°','60°E','120°E','180','120°W','60°W','0°'})
                    set(gca,'FontName','Times New Roman','FontSize', 25)
                    c1 = colorbar;
                    set(get(c1,'ylabel'), 'string','PWV (mm)','fontsize',25,'FontName','Times New Roman');
                    ylabel("Layers")
                    
                    date = strcat(yearstr,'-',monthstr,'-',daystr,'-',num2str(hour),':00');
                    title(strcat('EQ',date))
                    hold off
                    %% 
                    
                    data = nan(360,450);
                    for point_r = 1:360
                        for point_c = 1: 20
                            lon = point_r;
                            height = round(2 * round(ellipsoid_p(point_r,point_c)/100 , 2));
                            pwv = pwv_levels_p(point_r,point_c);
                            if height>0
                                data(lon,height+1) = pwv;
                            end
                        end
                        disp(point_r)
                    end

                    h = pcolor( data.');
                    set(h,'edgecolor','none');
%                     caxis([0,7.5])
                    colormap("cool")
                    xticks([1 60 120 180 240 300 360])
                    xticklabels({'0°','60°E','120°E','180','120°W','60°W','0°'})
                    yticks([1 50 100 150 200])
                    yticklabels({'0','2.5','5','7.5','10'})
                    set(gca,'FontName','Times New Roman','FontSize', 25)
                    c1 = colorbar;
                    set(get(c1,'ylabel'), 'string','PWV (mm)','fontsize',25,'FontName','Times New Roman');
                    ylabel('Height(km)')
                    xlim([0,360])
                    ylim([0,200])
                     
                    %% 
                    for i = 1:360
                        data1 = data(90,:);
                        
                        Exponential_fitting(data1)
                        savepath = strcat("F:/picture/pwv_levels/",yearstr,"/",yearstr,monthstr,daystr,num2str(hour),num2str(i),".png");
                        print(gcf, '-dpng', savepath)
                    end
                end
            end
        end
    end
end