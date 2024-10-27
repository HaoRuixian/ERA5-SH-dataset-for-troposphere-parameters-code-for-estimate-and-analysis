function draw_picture_global(data)
data = data.';
data = [data(:,181:end),data(:,1:180)];

% load shp
worldshp = shaperead("C:\Users\24391\OneDrive - zx2t0\桌面\水汽标高的计算\World\country.shp");
m_proj('miller','lon',[-180 180],'lat',[-90 90]);
lon_world = [worldshp.X];
lat_world = [worldshp.Y];
LN = zeros(181,360);
LN(1,:) = -180:179;

path_geo = "G:\ERA5_data\pressure_level\Geopotential\2020\202001_geopotential_p1.nc";
lat = double(ncread(path_geo,'latitude'));
lon = double(ncread(path_geo,'longitude'));
[~,LT] = meshgrid(lon,lat);
for i = 2:181
    LN(i,:) = LN(1,:);
end
m_pcolor(LN,LT,data);
hold on
m_line(lon_world,lat_world,'color','k');
hold off
m_grid('box','fancy','linestyle',':','gridcolor',[0.5,0.5,0.5],'backcolor',[1,1,1],'fontsize',20);

% colorbar('FontSize',20,'Tag','km')