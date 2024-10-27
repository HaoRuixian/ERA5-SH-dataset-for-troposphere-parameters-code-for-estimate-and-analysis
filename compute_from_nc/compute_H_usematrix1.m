% tic
% pause(1000)
% toc

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

for year = 2013:2022
    
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
%         p = parpool(3);
        for day = 1:daynum
            WVSH_all = nan(360,181,1,0);
            R_all = nan(360,181,1,0);
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
            path_sh = strcat(path,'Specific_humidity_data\',yearstr,'\',yearstr,monthstr,'_sh.nc');
            path_temperature = strcat(path,'Temperature_data\',yearstr,'\',yearstr,monthstr,'_temperature.nc');
            path_rh = strcat(path,'Relative_humidity_data\',yearstr,'\',yearstr,monthstr,'_rh.nc');

            % data
            startpath = [1,1,1,start_time];
            read_num = [360,181,37,24];
            if exist(path_rh,"file")
                relative_humidity = ncread(path_rh,'r',startpath,read_num);
            else
                relative_humidity = nc_cat(1, month, startpath,read_num,yearstr);
            end
            relative_humidity = relative_humidity(:,:,end:-1:1,:);
            
            if exist(path_sh,"file")
                specific_humidity = ncread(path_sh,'q',startpath,read_num);
            else
                specific_humidity = nc_cat(2, month, startpath,read_num,yearstr);
            end
            specific_humidity = specific_humidity(:,:,end:-1:1,:);

            if exist(path_temperature,"file")
                temperature_K = ncread(path_temperature,'t',startpath,read_num); 
            else
                temperature_K = nc_cat(3, month, startpath,read_num,yearstr);
            end
            temperature_K = temperature_K(:,:,end:-1:1,:);

            if exist(path_geo,"file")
                geo = ncread(path_geo, 'z',startpath,read_num);
                latitude = double(ncread(path_geo, 'latitude'));
                longitude = double(ncread(path_geo, 'longitude'));
                pre = ncread(path_geo,'level');
            else
                geo = nc_cat(4, month, startpath,read_num,yearstr);
                elsedata_path = strcat(path,'Geopotential_data\',yearstr,'\',yearstr,monthstr,'_geopotential_p1.nc');
                latitude = double(ncread(elsedata_path, 'latitude'));
                longitude = double(ncread(elsedata_path, 'longitude'));
                pre = ncread(elsedata_path,'level');
            end

            path_ground = strcat("E:\ERA5_data\single_Geopotential\201601",'_single_Geopotential.nc');
            geo_ground = ncread(path_ground,'z',[1,1,start_time],[360,181,24]);

            % Load the relevant fields from the data file
            geo = double(geo); % Geopotential height in meters
            geo_ground  = double(geo_ground);
            time = 24;
            geo = geo(:,:,end:-1:1,:)/9.80665;
            geo_ground = geo_ground/9.80665;
            
            pre = pre(end:-1:1,:);
            pre = single(pre);
            
            %% 计算正高
            geoid = nan(360,181,37,24);
            geoid_ground = nan(360,181,24);
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
                            % 地面层
                            geoid_ground(i4,i3,i1) = geo_ground(i4,i3,i1) / 1000*r_ls*9.80665 / (g_ls*r_ls - geo_ground(i4,i3,i1)/1000*9.80665) * 1000;
                        end
                    end
                end
            end

            %% read latitude longitude geoid ellipsoid pressure
            ellipsoid = nan(360,181,37,24);
            ellipsoid_ground = nan(360,181,24);
            for lon_indx = 1:360
                for lat_indx = 1:181
                    if lon_indx > 180
                        lon_h = (lon_indx-1)*-1;
                    else
                        lon_h = lon_indx;
                    end
                    lat_h = 91-lat_indx;
                    ellipsoid(lon_indx,lat_indx,:,:) = geoid(lon_indx,lat_indx,:,:) + geoidheight_EGM2008(lon_indx,lat_indx);%不同气压层的大地高
                    ellipsoid_ground(lon_indx,lat_indx,:) = geoid_ground(lon_indx,lat_indx,:) + geoidheight_EGM2008(lon_indx,lat_indx);% 地面的大地高
                end
            end
            temK = temperature_K;
            rh = relative_humidity;
            sh = specific_humidity;
            % clear vars
            temperature_K = [];
            relative_humidity = [];
            specific_humidity = [];
            
            %% Meteorological elements at ground points are interpolated
            
            [pressure,temK,rh,ellipsoid] = inter_to_ground_mex(ellipsoid,temK,rh,sh,pre,ellipsoid_ground,time);
       
            %% compute H
            pwv_levels = zeros(360, 181, 36, 24);
            PWV = zeros(360, 181, 36, 24);
            ZTD_levels = zeros(360, 181, 36, 24);
            ZTD = zeros(360, 181, 36, 24);
            ZWD_levels = zeros(360, 181, 36, 24);
            ZWD = zeros(360, 181, 36, 24);
            ZHD_levels = zeros(360, 181, 36, 24);
            ZHD = zeros(360, 181, 36, 24);
            Tm_levels = zeros(360, 181, 36, 24);
            Tm = zeros(360, 181, 36, 24);
            es = zeros(360, 181, 1, 24);
            H = zeros(360, 181, 1, 24);
            p0 = zeros(360, 181, 36, 24);

            WVSH = zeros(360,181,1,24);
            R_WVSH = zeros(360,181,1,24);
            PWVSH = zeros(360,181,1,24);
            R_PWVSH = zeros(360,181,1,24);
            ZTDSH = zeros(360,181,1,24);
            R_ZTDSH = zeros(360,181,1,24);
            ZWDSH = zeros(360,181,1,24);
            R_ZWDSH = zeros(360,181,1,24);
            ZHDSH = zeros(360,181,1,24);
            R_ZHDSH = zeros(360,181,1,24);
            TmSH = zeros(360,181,1,24);
            R_TmSH = zeros(360,181,1,24);

            temK(temK>333 | temK<185) = nan;
            temc = temK - 273.15; % change to °C
            for j = 1:time
                for k = 1:37
                    % compute es

                    es_tem = nan(360,181);
                    % temperature >=0
                    ind_tem1 = temc(:,:,k,j) >= 0;
                    es_tem1 = 6.1078 * 10.^(7.5 * temc(:,:,k,j) ./ (temc(:,:,k,j) + 237.3)) .* (rh(:,:,k,j)/100.0); % hpa
                    es_tem(ind_tem1) = es_tem1(ind_tem1);
                    ind_tem2 = temc(:,:,k,j) < 0;
                    es_tem2 = 6.1078 * 10.^(9.5*temc(:,:,k,j) ./ (temc(:,:,k,j) + 265.5)) .* (rh(:,:,k,j)/100.0);
                    es_tem(ind_tem2) = es_tem1(ind_tem2);
                    es(:,:,k,j) = es_tem;
                    
                    % compute sh
                    sh(:,:,k,j) = 622 * es(:,:,k,j) ./ (pressure(:,:,k,j) - 0.378* es(:,:,k,j));% g/kg
                end
                % compute PWV
                p_water = 1;
                mid_sh = 0.5 * (sh(:,:,1:end-1,j) + sh(:,:,2:end,j));
                dif_pre = -diff(pressure(:,:,1:37,j),1,3);
                pwv_levels(:,:,:,j) = (1/9.80655/p_water) * mid_sh .* dif_pre *0.1 ;% mm

                % compute ZTD\ZWD\ZHD
                height_thickness = diff(ellipsoid(:,:,1:37,j),1,3);
                k1 = 77.689;
                k2 = 64.79;
                k3 = 375463;
                k2w = 71.2952;
                N = k1*(pressure(:,:,1:37,j)-es(:,:,1:37,j))./temK(:,:,1:37,j) +...
                    k2*es(:,:,1:37,j)./temK(:,:,1:37,j) +...
                    k3*es(:,:,1:37,j)./(temK(:,:,1:37,j).*temK(:,:,1:37,j));
                Nw = k2w*es(:,:,1:37,j)./temK(:,:,1:37,j) +...
                    k3*es(:,:,1:37,j)./(temK(:,:,1:37,j).*temK(:,:,1:37,j));
                %                 Nh = 1 + k1*pressure(:,:,1:37,j)./temK(:,:,1:37,j);

                Nh = k1*(pressure(:,:,1:37,j)-es(:,:,1:37,j))./temK(:,:,1:37,j);
                ZWD_levels = 1e-6 * 0.5*(Nw(:,:,1:end-1)+Nw(:,:,2:end)) .* height_thickness;
%                 ZTD_levels = 1e-6 * 0.5*(N(:,:,1:end-1)+N(:,:,2:end)) .* height_thickness;
                ZHD_levels = 1e-6 * 0.5*(Nh(:,:,1:end-1)+Nh(:,:,2:end)) .* height_thickness;
                ZTD_levels = ZHD_levels+ZWD_levels;

                % compute Tm
                T1 = es(:,:,1:37,j) ./ temK(:,:,1:37,j);
                T2 = es(:,:,1:37,j) ./ (temK(:,:,1:37,j).*temK(:,:,1:37,j));
                denominator = 0.5*height_thickness .* (T2(:,:,1:end-1) + T2(:,:,2:end));
                molecule = 0.5*height_thickness .* (T1(:,:,1:end-1) + T1(:,:,2:end));

                for m = 1:36
                    Tm(:,:,m,j) = nansum(molecule(:,:,m:end),3) ./ nansum(denominator(:,:,m:end),3);
                    PWV(:,:,m,j) = nansum(pwv_levels(:,:,m:end,j),3);
                    ZTD(:,:,m,j) = nansum(ZTD_levels(:,:,m:end),3);
                    ZWD(:,:,m,j) = nansum(ZWD_levels(:,:,m:end),3);
                    ZHD(:,:,m,j) = nansum(ZHD_levels(:,:,m:end),3);
                end


                % compute p0
                Rv = 461.5;% J/(kg*K)
                p0(:,:,:,j) = ((es(:,:,1:36,j)*100)*1000 ./ (Rv * temK(:,:,1:36,j)));% g/m^3
                % compute H
                H(:,:,1,j) = PWV(:,:,1,j)*1000 ./ p0(:,:,1,j) / 1000;% km

                % fitting
                for d = 1:6
                    if d == 1
                        data = p0;
                    elseif d == 2
                        data = PWV;
                    elseif d == 3
                        data = ZTD;
                    elseif d == 4
                        data = ZWD;
                    elseif d == 5
                        data = ZHD;
                    elseif d == 6
                        data = Tm;
                    end

                    [SH, R_SH] = fit_SHs_mex(data(:,:,:,j), ellipsoid(:,:,:,j),d);
                    if d == 1
                        WVSH(:,:,1,j) = SH;
                        R_WVSH(:,:,1,j) = R_SH;
                    elseif d == 2
                        PWVSH(:,:,1,j) = SH;
                        R_PWVSH(:,:,1,j) = R_SH;
                    elseif d == 3
                        ZTDSH(:,:,1,j) = SH;
                        R_ZTDSH(:,:,1,j) = R_SH;
                    elseif d == 4
                        ZWDSH(:,:,1,j) = SH;
                        R_ZWDSH(:,:,1,j) = R_SH;
                    elseif d == 5
                        ZHDSH(:,:,1,j) = SH;
                        R_ZHDSH(:,:,1,j) = R_SH;
                    elseif d == 6
                        TmSH(:,:,1,j) = SH;
                        R_TmSH(:,:,1,j) = R_SH;
                    end

                end
%                 disp(strcat('time:',num2str(j)))
            end

            %% save data
            % save scale height
%             disp('saving')
            for d = 1:6
                if d == 1
                    var = 'WVSH';
                    data1 = WVSH;
                    data2 = R_WVSH;
                elseif d == 2
                    var = 'PWVSH';
                    data1 = PWVSH;
                    data2 = R_PWVSH;
                elseif d == 3
                    var = 'ZTDSH';
                    data1 = ZTDSH;
                    data2 = R_ZTDSH;
                elseif d == 4
                    var = 'ZWDSH';
                    data1 = ZWDSH;
                    data2 = R_ZWDSH;
                elseif d == 5
                    var = 'ZHDSH';
                    data1 = ZHDSH;
                    data2 = R_ZHDSH;
                elseif d == 6
                    var = 'TmSH';
                    data1 = TmSH;
                    data2 = R_TmSH;
                end
                path_save = strcat("F:\DATASET\",var,'\',yearstr,'\');
                if ~exist(path_save,"dir")
                    mkdir(path_save)
                end
                filename = strcat(path_save,yearstr,monthstr,daystr,var,'_R.mat');
                parsave_SH_R(filename,squeeze(data1),squeeze(data2),var,strcat(var,'_R'))
            end

            % save parameters
            for d = 1:6
                if d == 1
                    var = 'PWV';
                    data = squeeze(PWV(:,:,1,:));
                elseif d == 2
                    var = 'Tm';
                    data = squeeze(Tm(:,:,1,:));
                elseif d == 3
                    var = 'ZTD';
                    data = squeeze(ZTD(:,:,1,:));
                elseif d == 4
                    var = 'ZWD';
                    data = squeeze(ZWD(:,:,1,:));
                elseif d == 5
                    var = 'ZHD';
                    data = squeeze(ZHD(:,:,1,:));
                elseif d == 6
                    var = 'SVD';
                    data = squeeze(p0(:,:,1,:));
                end
                path_save = strcat("F:\DATASET\",var,'\',yearstr,'\');
                if ~exist(path_save,"dir")
                    mkdir(path_save)
                end
                filename = strcat(path_save,yearstr,monthstr,daystr,var,'.mat');
                parsave_parameters(filename,data,var)
            end

%             disp('save over!')


            h=[];
            p0=[];
            ellipsoid=[];
            temK=[];
            pre=[];  
            geo=[];
            PWV=[];
            pwv_levels=[];
            toc

        end
        delete(p)
    end
    
end
