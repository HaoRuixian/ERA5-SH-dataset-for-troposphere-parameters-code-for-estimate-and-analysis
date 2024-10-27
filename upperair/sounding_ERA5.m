clc
clear

load('F:/DATASET/points/ZTD/2020ZTD.mat')
data_era5 = reshape(ZTD,360,181,[]);
load('F:/DATASET/points/ZTDSH/2020ZTDSH_R.mat','ZTDSH')
data_SH = reshape(ZTDSH,360,181,[]);
clear ZTD ZYDSH
addpath 'E:\桌面\ERA5_WVSH'
load("DEM.mat")
load("3ZTDnew1zhibiao.mat")
station_num = numel(ZTD_2020);
verify_info = nan(station_num,4);
%%
for sta = 1:station_num
    station_info = ZTD_2020(sta);
    lon = station_info.lon;
    lat = station_info.lat;
    h = station_info.h;
    ngl_ztd = station_info.NGL_ZTD1;
    ngl_ztd=ngl_ztd/1000;
    if lat <= 0
        lat_id = 90 + abs(lat);
    elseif lat > 0
        lat_id = 90 - lat;
    end
   

    % four points info
    lon1 = floor(lon)+1;
    lon2 = lon1 + 1;
    if lon2 > 360
        lon2 = 1;
    end
    lat1 = floor(lat_id)+1;
    if lat1 == 181
        lat2 = lat1;
    else
        lat2 = lat1 + 1;
    end
    data1 = squeeze(data_era5(lon1,lat1,:));
    data2 = squeeze(data_era5(lon2,lat1,:));
    data3 = squeeze(data_era5(lon1,lat2,:));
    data4 = squeeze(data_era5(lon2,lat2,:));

    h1_diff = h - DEM(lon1,lat1);
    h2_diff = h - DEM(lon2,lat1);
    h3_diff = h - DEM(lon1,lat2);
    h4_diff = h - DEM(lon2,lat2);

    SH1 = squeeze(data_SH(lon1,lat1,:));
    SH2 = squeeze(data_SH(lon2,lat1,:));
    SH3 = squeeze(data_SH(lon1,lat2,:));
    SH4 = squeeze(data_SH(lon2,lat2,:));

    %     SH1 = 7;
    %     SH2 = 7;
    %     SH3 = 7;
    %     SH4 = 7;

    % Calculated weight
    wlon = lon - (lon1-1);
    wlat = lat_id - (lat1-1);

    lon_sh = round(lon)+1;
    lat_sh = round(lat_id)+1;
    SH = squeeze(data_SH(lon_sh,lat_sh,:));
    h_diff = h - DEM(lon_sh,lat_sh);
    % Bilinear interpolation
    interpolated_value = (1 - wlon) * (1 - wlat) * data1 + wlon * (1 - wlat) * data2 + (1 - wlon) * wlat * data3 + wlon * wlat * data4;
    interpolated_value_correction = interpolated_value .* exp(-h_diff./SH/1000);

    data1_correction = data1 .* exp(-h1_diff./SH1/1000);
    data2_correction = data2 .* exp(-h2_diff./SH2/1000);
    data3_correction = data3 .* exp(-h3_diff./SH3/1000);
    data4_correction = data4 .* exp(-h4_diff./SH4/1000);
    % Bilinear interpolation
    interpolated_value = (1 - wlon) * (1 - wlat) * data1_correction + wlon * (1 - wlat) * data2_correction + (1 - wlon) * wlat * data3_correction + wlon * wlat * data4_correction;

    [rmse_value, bias_value, r, vdn] = calculate_rmse_and_bias(ngl_ztd, interpolated_value_correction);
    if rmse_value > 0.05
        disp('stop')
    end
    verify_info(sta,:) = [rmse_value, bias_value, r, vdn];
end

%% draw_picture
clc

set(0,'defaultAxesFontSize', 16);
set(0,'defaultTextFontSize', 16);

shp = shaperead("E:\桌面\水汽标高的计算\World\country.shp");
dis_data = verify_info(:,1)*100;
vnum = verify_info(:,end);
indv = vnum<200*12;
dis_data(indv,:)=nan;

latitude = [ZTD_2020.lat].';
longtitude = [ZTD_2020.lon].';
longtitude(longtitude>180) = -1*(360-longtitude(longtitude>180));
m_proj('Miller Cylindrical');
%分别获取经纬度信息
[X,Y] = m_ll2xy(longtitude, latitude);
lon_ = [shp.X];
lat_ = [shp.Y];

load("DEM.mat")
DEM = DEM.';
DEM = [DEM(:,181:end),DEM(:,1:180)];
path_geo = "F:\ERA5_data\pressure_level\Geopotential_data\2020\202001_geopotential_p1.nc";
LN = zeros(181,360);
LN(1,:) = -180:179;
lat = double(ncread(path_geo,'latitude'));
lon = double(ncread(path_geo,'longitude'));
[~,LT] = meshgrid(lon,lat);
for i = 2:181
    LN(i,:) = LN(1,:);
end
addpath 'E:\桌面\ERA5_WVSH\upperair'
m_pcolor(LN,LT,DEM);
shading interp
colormap(othercolor('Greys9'))
freezeColors;
freezeColors(jicolorbar);
caxis([0 8000])
hold on
m_line(lon_,lat_,'linewidth',0.5,'color','black');
m_scatter(longtitude,latitude,2.5,dis_data,'filled');
colormap("cool")
freezeColors(colorbar);
caxis([0,5])

m_grid('linestyle',':','gridcolor',[0.5,0.5,0.5],'backcolor',[1,1,1]);
hold off



%% function
function [rmse_value, bias_value, r, vdn] = calculate_rmse_and_bias(true_values, predicted_values)
indnan1 = isnan(true_values);
indnan2 = isnan(predicted_values);
nan_all = indnan1==1 | indnan2==1;
true_values(nan_all) = [];
predicted_values(nan_all) = [];
vdn = numel(true_values);
% diff^2
diff_squared = (true_values - predicted_values).^2;
% rmse
rmse_value = sqrt(mean(diff_squared));
% bias
bias_value = mean(predicted_values - true_values);
% r
r = corrcoef(true_values,predicted_values);
if numel(r) == 1
    r = nan;
else
    r = r(2);
end
end