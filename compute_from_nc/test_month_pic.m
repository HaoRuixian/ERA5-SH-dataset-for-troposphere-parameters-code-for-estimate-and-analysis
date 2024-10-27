clc
clear
for year = 2023:2023

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

            load(strcat('F:\Results\2023\2023', monthstr, daystr,'p0_ellipsoid.mat'))
            %% 
            for j = 1:24
                for i = 1000:181*360       %point
                    lat = ceil(i/360);
                    lon = mod(i,360);

                    if lon == 0
                        lon = 360;
                    end
                    
                    p0_p = squeeze(p0(lon,lat,:,j));
                    height = squeeze(ellipsoid(lon,lat,1:37,j));
                    validIndices = ~isnan(height) & ~isnan(p0_p);
                    heightValid = height(validIndices);
                    p0_pValid = p0_p(validIndices);
                    p0_end = p0_pValid(1) * 0.367879;
                    ind = p0_pValid < p0_end;

                    WVSH(lon,lat,1,j) = -1/ (fitResult.b*1000);
                end
                draw_picture_global(squeeze(WVSH(:,:,1,j)))
            end
            
        end
    end
end