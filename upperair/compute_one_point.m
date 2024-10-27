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
% p = parpool(6);
WVSH_all = nan(360,181,1,0);
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
            start_time = day*24 -23;%hour
            %%  read data

            lons = 138;
            lats = 124;
            % path setting
            tic
            path = "F:\ERA5_data\pressure_level\";
            path_geo = strcat(path,'Geopotential_data\',yearstr,'\',yearstr,monthstr,'_geopotential.nc');
            path_sh = strcat(path,'Specific_humidity_data\',yearstr,'\',yearstr,monthstr,'_sh.nc');
            path_temperature = strcat(path,'Temperature_data\',yearstr,'\',yearstr,monthstr,'_temperature.nc');
            path_rh = strcat(path,'Relative_humidity_data\',yearstr,'\',yearstr,monthstr,'_rh.nc');

            % data
            startpath = [lons,lats,1,start_time];
            read_num = [2,2,37,24];
            if exist(path_rh,"file")
                relative_humidity = ncread(path_rh,'r',startpath,read_num);
            else
                relative_humidity = nc_cat(1, month, startpath,read_num);
            end
            relative_humidity = relative_humidity(:,:,end:-1:1,:);
            
            if exist(path_sh,"file")
                specific_humidity = ncread(path_sh,'q',startpath,read_num);
            else
                specific_humidity = nc_cat(2, month, startpath,read_num);
            end
            specific_humidity = specific_humidity(:,:,end:-1:1,:);

            if exist(path_temperature,"file")
                temperature_K = ncread(path_temperature,'t',startpath,read_num); 
            else
                temperature_K = nc_cat(3, month, startpath,read_num);
            end
            temperature_K = temperature_K(:,:,end:-1:1,:);
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
            pre = ncread(path_geo,'level');
            pre = pre(end:-1:1,:);
            pre = single(pre);
            
            relative_humidity_n = nan(360,181,37,24);
            specific_humidity_n = nan(360,181,37,24);
            temperature_K_n = nan(360,181,37,24);
            geo_n = nan(360,181,37,24);

            relative_humidity_n(lons:lons+1, lats:lats+1, :,:) = relative_humidity;
            clear relative_humidity
            relative_humidity = relative_humidity_n;
            specific_humidity_n(lons:lons+1, lats:lats+1, :,:) = specific_humidity;
            clear specific_humidity
            specific_humidity = specific_humidity_n;
            temperature_K_n(lons:lons+1, lats:lats+1, :,:) = temperature_K;
            clear temperature_K
            temperature_K = temperature_K_n;
            geo_n(lons:lons+1, lats:lats+1, :,:) = geo;
            clear geo
            geo = geo_n;

            %% 计算正高
            geoid = nan(360,181,37,24);
            geoid_ground = nan(360,181,37,24);
            for i1 = 1:6:time%time
                for i2 = 1:37%pressure
                    for i3 = lats:181%latitude
                        for i4 = lons:360%longitude
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
            temK = temperature_K;
            rh = relative_humidity;
            sh = specific_humidity;
            % clear vars
            temperature_K = [];
            relative_humidity = [];
            specific_humidity = [];
            
            %% 内插地面点各项气象元素
            pressure = nan(360,181,37,24);
            for i = 1:4%181*360       %point
                %                 lat = ceil(i/360);
                %                 lon = mod(i,360);
                %                 if lon == 0
                %                     lon = 360;
                %                 end

                if i == 1
                    lon = lons;
                    lat = lats;
                elseif i == 2
                    lon = lons+1;
                    lat = lats;
                elseif i == 3
                    lon = lons;
                    lat = lats+1;
                elseif i == 4
                    lon = lons+1;
                    lat = lats+1;
                end

                for j = 1:12:time      %time
                    %判断地面位置与气压层的位置关系，后据此确定内插还是外推
                    for k = 1:37
                        if geoid_ground(lon,lat,j) < ellipsoid(lon,lat,k,j)
                            break;
                        end
                    end

                    level_num = numel(unique(ellipsoid(lon,lat,:,j)));
                    di = squeeze(diff(ellipsoid(lon,lat,:,j)));
                    wrong = length( find(di==0) );
                    diz = di(1:36);
                    wrong2 = length(find(diz<0));
                    if level_num < 37 || wrong > 1 || wrong2 ~= 0 % find wrong data
                        pressure(lon,lat,:,j) = nan;
                        temK(lon,lat,:,j) = nan;
                        rh(lon,lat,:,j) = nan;
                        continue
                    end
                    % 外推
                    if k == 1
                        % hum和tem都是直接线性外推
                        ellipsoid_linear = squeeze(ellipsoid(lon,lat,:,j));
                        temk_linear = squeeze(temK(lon,lat,:,j));
                        rh_linear = squeeze(rh(lon,lat,:,j));

                        temK_ls = interp1(ellipsoid_linear, temk_linear, geoid_ground(lon,lat,j), 'linear','extrap');
                        rh_ls = interp1(ellipsoid_linear, rh_linear, geoid_ground(lon,lat,j), 'linear','extrap');
                        % 只取37层
                        temk_temp = [temK_ls; temk_linear];
                        temk_temp = temk_temp(1:37);
                        temK(lon,lat,:,j) = reshape( temk_temp, [1,1,37,1]);

                        rh_temp = [rh_ls;rh_linear];
                        rh_temp = rh_temp(1:37);
                        rh(lon,lat,:,j) = reshape( rh_temp, [1,1,37,1]);

                        ellipsoid_temp = [geoid_ground(lon,lat,j);ellipsoid_linear];
                        ellipsoid_temp = ellipsoid_temp(1:37);
                        ellipsoid(lon,lat,:,j) = reshape( ellipsoid_temp, [1,1,37,1]);

                        %pre特殊，需要指数外推。指数的系数是根据virtual temperature。
                        %根据gpt2w代码中的公式求取。其实后续也不会用到pre
                        vt = temK(lon,lat,2,j)*(1+0.6077*sh(lon,lat,1,j));%virtual temperature, 需要比湿
                        ec1 = 9.80665*0.028965/(8.3143*vt);
                        dif_height_ls = geoid_ground(lon,lat,j) - ellipsoid(lon,lat,2,j);%值为负
                        pre_ls = pre(k,1)*exp(-ec1*dif_height_ls);
                        preassure_temp = [pre_ls; pre];
                        preassure_temp = preassure_temp(1:37);
                        pressure(lon,lat,:,j) = reshape( preassure_temp, [1,1,37,1]);
                    
                    %内插    
                    else 
                        %pre的内插，ec直接用相邻俩个气压层的比值
                        dif_height = ellipsoid(lon,lat,k,j) - ellipsoid(lon,lat,k-1,j); %两个气压层之间的高度差
                        dif_pre = pre(k,1)/pre(k-1,1);                                  %两层气压之间的比值
                        ec2 = log(dif_pre)/dif_height;                                  %结果已经是负值，后续不用加负号
                        dif_height_ls = geoid_ground(lon,lat,j) - ellipsoid(lon,lat,k-1,j);
                        pre_ls = pre(k-1,1) * exp(ec2 * dif_height_ls);
                        
                        pre_temp = [pre_ls.'; pre(k:end,1)];
                        num = numel(pre_temp);
%                         pre_temp = padarray(pre_temp,numel(pressure(lon,lat,:,j))-numel(pre_temp),nan,'post');
                        pressure(lon,lat,1:num,j)= pre_temp;

                        % hum和tem都是直接线性内插
                        ellipsoid_linear = squeeze(ellipsoid(lon,lat,:,j));
                        temk_linear = squeeze(temK(lon,lat,:,j));
                        rh_linear = squeeze(rh(lon,lat,:,j));

                        temK_ls = interp1(ellipsoid_linear , temk_linear,geoid_ground(lon,lat,j), 'linear','extrap');
                        rh_ls = interp1(ellipsoid_linear , rh_linear,geoid_ground(lon,lat,j), 'linear','extrap');

                        temk_temp = [temK_ls; squeeze(temK(lon,lat,k:end,j))];
                        num = numel(temk_temp);
                        temK(lon,lat,1:num,j) = temk_temp;
                        
                        rh_temp = [rh_ls;  squeeze(rh(lon,lat,k:end,j))];
                        num = numel(rh_temp);
                        rh(lon,lat,1:num,j) = rh_temp;
                        
                        ellipsoid_temp = [geoid_ground(lon,lat,j); squeeze(ellipsoid(lon,lat,k:end,j))];
                        num = numel(ellipsoid_temp);
                        ellipsoid(lon,lat,1:num,j) = ellipsoid_temp;

                    end
                end
            end
       
            %% compute H
            pwv_levels = zeros(360, 181, 36, 24);
            PWV = zeros(360, 181, 1, 24);
            es = zeros(360, 181, 1, 24);
            H = zeros(360, 181, 1, 24);
            p0 = zeros(360, 181, 37, 24);
            WVSH = zeros(360,181,1,24);
            temc = temK - 273.15; % change to °C
            for j = 1:12:time
                for k = 1:37
                    % compute es
                    if temc(:,:,k,j) > 0
                        es(:,:,k,j) = 6.1078 * 10.^(7.5 * temc(:,:,k,j) ./ (temc(:,:,k,j) + 237.3)) .* (rh(:,:,k,j)/100.0); % hpa
                    else
                        es(:,:,k,j) = 6.1078 * 10.^(9.5*temc(:,:,k,j) ./ (temc(:,:,k,j) + 265.5)) .* (rh(:,:,k,j)/100.0);
                    end
                    % compute PWV
                    sh(:,:,k,j) = 622 * es(:,:,k,j) ./ (pressure(:,:,k,j) - 0.378* es(:,:,k,j));% g/kg
                end
                % compute PWV
                p_water = 1;
                mid_sh = 0.5 * (sh(:,:,1:end-1,j) + sh(:,:,2:end,j));
                dif_pre = -diff(pressure(:,:,1:37,j),1,3);
                pwv_levels(:,:,:,j) = (1/9.80655/p_water) * mid_sh .* dif_pre *0.1 ;% mm
                PWV(:,:,1,j) = nansum(pwv_levels(:,:,:,j),3);

                % compute p0
                Rv = 461.5;% J/(kg*K)
                p0(:,:,:,j) = ((es(:,:,1:37,j)*100)*1000 ./ (Rv * temK(:,:,1:37,j)));% g/m^3
                % compute H
                H(:,:,1,j) = PWV(:,:,1,j)*1000 ./ p0(:,:,1,j) / 1000;% km


                for i = 1:4%181*360       %point
                    %                     lat = ceil(i/360);
                    %                     lon = mod(i,360);
                    %                     if lon == 0
                    %                         lon = 360;
                    %                     end
                    if i == 1
                        lon = lons;
                        lat = lats;
                    elseif i == 2
                        lon = lons+1;
                        lat = lats;
                    elseif i == 3
                        lon = lons;
                        lat = lats+1;
                    elseif i == 4
                        lon = lons+1;
                        lat = lats+1;
                    end

                    p0_p = squeeze(p0(lon,lat,:,j));
                    height = squeeze(ellipsoid(lon,lat,1:37,j));
                    validIndices = ~isnan(height) & (~isnan(p0_p) & p0_p>0);
                    heightValid = height(validIndices);
                    p0_pValid = p0_p(validIndices);
                    if isnan(p0_p) | isnan(height)
                        WVSH(lon,lat,1,j) = nan;
                        continue
                    end
                    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
                    ft = fittype( 'exp1' );
                    [fitResult, gof] = fit(heightValid, p0_pValid, ft, opts);
                    
                    r2 = gof.rsquare;
                    if r2 > 0.9
                        H2 = -1 / (fitResult.b*1000);
                    else
                        H2 = nan;
                    end
                    if H2 < 0 
                        disp('error')
                    end
                    WVSH(lon,lat,1,j) = H2;
                end
            end

            %% save data
            WVSH_all = cat(4,WVSH_all,WVSH);
%             H = squeeze(H);
%             p0 = squeeze(p0);                % 地面水汽密度
%             tem_K = squeeze(temK(:,:,1,:));  % 地面温度
%             pre = squeeze(pre(:,:,1,:));     % 地面气压
%             PWV = squeeze(PWV);
%             
%             path_save = strcat("F:\Results\",yearstr,"\");
%             filename = strcat(path_save,yearstr,monthstr,daystr,'p0_ellipsoid.mat');
%             parsave(filename,p0,ellipsoid)

            h=[];
            p0=[];
            ellipsoid=[];
            temK=[];
            pre=[]; 
            geo=[];
            PWV=[];
            pwv_levels=[];
%             disp(filename)
            toc

        end
        
    end
    delete(p)
end
