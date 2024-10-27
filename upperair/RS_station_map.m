clc

set(0,'defaultAxesFontSize', 16);
set(0,'defaultTextFontSize', 16);

data = readtable("UPAR_GLB_MUL_FTM_STATION.xlsx");
shp = shaperead("E:\桌面\水汽标高的计算\World\country.shp");
for z = 1:3
    figure
    tiledlayout(2,3,"TileSpacing","tight")
    for d = 1:6
        if d == 1
            datastr = 'PWVSH';
        elseif d == 2
            datastr = 'WVSH';
        elseif d == 3
            datastr = 'TmSH';
        elseif d == 4
            datastr = 'ZTDSH';
        elseif d == 5
            datastr = 'ZHDSH';
        elseif d == 6
            datastr = 'ZWDSH';
        end
        load(strcat(datastr,'2022_verify_info.mat'))
        dis_data = verify_info(:,z+1);
        vnum = verify_info(:,end-1);
        indv = vnum<20;
        dis_data(indv,:)=nan;
        [~,TFrm] = rmoutliers(dis_data,"grubbs");
        dis_data(TFrm) = nan;
        latitude = table2array(data(:,4));
        longtitude = table2array(data(:,3));
        m_proj('Miller Cylindrical');
        %分别获取经纬度信息
        [X,Y] = m_ll2xy(longtitude, latitude);
        lon_ = [shp.X];
        lat_ = [shp.Y];
        addpath 'E:\桌面\ERA5_WVSH'
        load("DEM.mat")
        DEM = DEM.';
        DEM = [DEM(:,181:end),DEM(:,1:180)];
        path_geo = "G:\ERA5_data\pressure_level\Geopotential\2020\202001_geopotential_p1.nc";
        LN = zeros(181,360);
        LN(1,:) = -180:179;
        lat = double(ncread(path_geo,'latitude'));
        lon = double(ncread(path_geo,'longitude'));
        [~,LT] = meshgrid(lon,lat);
        for i = 2:181
            LN(i,:) = LN(1,:);
        end

        nexttile
        m_pcolor(LN,LT,DEM);
        shading interp
        colormap(othercolor('Greys9'))
        freezeColors;
        % freezeColors(jicolorbar);
        %         caxis([0 8000])
        hold on
        m_line(lon_,lat_,'linewidth',0.5,'color','black');
        m_scatter(longtitude,latitude,15,dis_data,'filled');
        colormap("cool")
        caxis auto
        colorbar

        m_grid('linestyle',':','gridcolor',[0.5,0.5,0.5],'backcolor',[1,1,1]);
        if z == 1
            title(strcat(datastr,'-','RMSE(km)'))
        elseif z == 2
            title(strcat(datastr,'-','Bias(km)'))
        elseif z == 3
            title(strcat(datastr,'-','R'))
        end
        hold off
    end
end

