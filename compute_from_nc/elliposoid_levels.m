clc
clear

%% calculates the geoid height using the EGM2008 Geopotential Model
for lon_indx = 1:360
    for lat_indx = 1:181
        if lon_indx > 180
            lon_h = (lon_indx-1)*-1;
        else
            lon_h = lon_indx;
        end
        lat_h = 91-lat_indx;
        geoidheight_EGM2008(lat_indx, lon_indx) = geoidheight(lat_h,lon_h,'EGM2008','None');%不同气压层的大地高
    end
end
geoidheight_EGM2008 = geoidheight_EGM2008';
%%
% The matrix dimensions are: longitude, latitude, levels from low to high,
% time in hours
for year = 2019:2019
    
    for month = 6:12
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
        p =  parpool(6);
        parfor day = 1:daynum
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
            start_time = day*24 -23;%hour
            %%  read data

            % path setting
            tic
            path = "F:\ERA5_data\pressure_level\";
            path_geo = strcat(path,'Geopotential_data\',yearstr,'\',yearstr,monthstr,'_geopotential.nc');

            % data
            startpath = [1,1,1,start_time];
            read_num = [360,181,37,24];

            geo = ncread(path_geo, 'z',startpath,read_num);

            path_ground = strcat("F:\ERA5_data\single_Geopotential\2016",monthstr,'_single_Geopotential.nc');
            geo_ground = ncread(path_ground,'z',[1,1,start_time],[360,181,24]);

            % Load the relevant fields from the data file
            geo = double(geo); % Geopotential height in meters
            geo_ground  = double(geo_ground);
            time = 24;
            geo = geo(:,:,end:-1:1,:)/9.80655;
            geo_ground = geo_ground/9.80655;
            latitude = double(ncread(path_geo, 'latitude'));
            longitude = double(ncread(path_geo, 'longitude'));
            

            %% 计算正高
            
            geoid = nan(360,181,37,24);
            geoid_ground = nan(360,181,37,24);
            for i1 = 1:time%time
                for i2 = 1:37%pressure
                    for i3=1:181%latitude
                        for i4=1:360%longitude
                            sinf2 = sin(latitude(i3,1) * pi/180) * sin(latitude(i3,1) * pi/180);
                            sinf22 = sin(latitude(i3,1)) * sin(latitude(i3,1));
                            % 大地水准面半径，单位km  6378.137是地球的平均半径，0.003352811和0.003449787是地球椭球体的偏心率
                            r_ls = 6378.137 / (1 + 0.003352811 + 0.003449787 - 2*0.003352811*sinf2);
                            g_ls = 9.7803253359 * ( (1+0.001931853*sinf2) / sqrt(1-0.081819*0.081819*sinf2) ); %单位ms-2  该点重力加速度
                            geoid(i4,i3,i2,i1) = geo(i4,i3,i2,i1) / 1000*r_ls*9.80665 / (g_ls*r_ls - geo(i4,i3,i2,i1)/1000*9.80665);
                            geoid(i4,i3,i2,i1) = geoid(i4,i3,i2,i1)*1000;% 正高 最后的结果单位是m
                            % 地面层大地高
                            geoid_ground(i4,i3,i1) = geo_ground(i4,i3,i1) / 1000*r_ls*9.80665 / (g_ls*r_ls - geo_ground(i4,i3,i1)/1000*9.80665) * 1000;
                        end
                    end
                end
            end

            %% read latitude longitude geoid ellipsoid pressure
            
            ellipsoid = nan(360,181,37,24);
            for lon_indx = 1:360
                for lat_indx = 1:181
                    if lon_indx > 180
                        lon_h = (lon_indx-1)*-1;
                    else
                        lon_h = lon_indx;
                    end
                    lat_h = 91-lat_indx;
                    ellipsoid(lon_indx,lat_indx,:,:) = geoid(lon_indx,lat_indx,:,:) + geoidheight_EGM2008(lon_indx,lat_indx);%不同气压层的大地高
                end
            end
            %%
            for i = 1:181*360       %point
                lat = ceil(i/360);
                lon = mod(i,360);
                if lon == 0
                    lon = 360;
                end
                for j = 1:time      %time
                    %判断地面位置与气压层的位置关系，后据此确定内插还是外推
                    for k = 1:37
                        if geoid_ground(lon,lat,j) < ellipsoid(lon,lat,k,j)
                            break;
                        end
                    end

                    level_num = numel(unique(ellipsoid(lon,lat,:,j)));
                    di = squeeze(diff(ellipsoid(lon,lat,:,j)));
                    wrong = length( find(di==0) );
                    if level_num < 37 && wrong > 1  % find wrong data

                        continue
                    end
                    % 外推
                    if k == 1
                        % hum和tem都是直接线性外推
                        % 剔除0
                        ellipsoid_linear = squeeze(ellipsoid(lon,lat,:,j));
                        ellipsoid_linear(ellipsoid_linear == 0) = [];

                        ellipsoid_temp = [geoid_ground(lon,lat,j);ellipsoid_linear];
                        size = numel(ellipsoid(lon,lat,:,j));
                        if size < numel(ellipsoid_temp)
                            ellipsoid(lon,lat,size+1,j) = nan;       % 扩大矩阵维度加入外推数据
                        end
                        ellipsoid(lon,lat,:,j) = reshape( ellipsoid_temp, [1,1,numel(ellipsoid_temp),1]);

                    else %内插

                        ellipsoid_linear = squeeze(ellipsoid(lon,lat,:,j));
                        ellipsoid_linear(ellipsoid_linear == 0) = [];

                        ellipsoid_temp = [geoid_ground(lon,lat,j);squeeze(ellipsoid(lon,lat,k:end,j))];
                        ellipsoid_temp = padarray(ellipsoid_temp,numel(ellipsoid(lon,lat,:,j))-numel(ellipsoid_temp),nan,'post');
                        ellipsoid(lon,lat,:,j) = ellipsoid_temp;

                    end
                end
            end
%% 

            path_save = strcat("F:\Results\",yearstr,"\ellipsoid\");
            filename = strcat(path_save,yearstr,monthstr,daystr,'ellipsoid.mat');
            parsavee(filename,ellipsoid)
            disp(filename)
        end
        delete(p)
    end
end
