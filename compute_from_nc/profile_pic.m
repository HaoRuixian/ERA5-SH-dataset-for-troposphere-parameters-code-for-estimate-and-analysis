clc
clear

mode = 1;

if mode == 1
    lat = 30;
    lat_indx = 91 - lat;
elseif mode == 2
    lon = 140;
    if lon < 0
        lon_indx = 360 + lon;
    else
        lon_indx = lon +1;
    end
else
    disp('mode setting error!')
end

yearstr = "2022";
monthstr = "01";
daystr = "01";
hour = 1;

varindx = ["PWV", "SVD","Tm","ZTD","ZHD","ZWD"];
tiledlayout(2,3,'TileSpacing','compact');
for d = 1:6
    varstr = varindx(d);

    %% load data
    ground_data_path = strcat("F:/DATASET/",varstr,"/",yearstr,"/",yearstr,monthstr,daystr,varstr,".mat");
    ground_data_all = load(ground_data_path);
    ground_data = ground_data_all.(varstr);
    clear ground_data_all


    SH_data_path = strcat("F:/DATASET/",varstr,"SH/",yearstr,"/",yearstr,monthstr,daystr,varstr,"SH_R.mat");
    if d == 2
        SH_data_path = strcat("F:/DATASET/","WVSH/",yearstr,"/",yearstr,monthstr,daystr,"WVSH_R.mat");
    end
    SH_data_all = load(SH_data_path);
    if d == 2
        SH_data = SH_data_all.("WVSH");
    else
        SH_data = SH_data_all.(strcat(varstr,"SH"));
    end
    clear SH_data_all

    load("DEM.mat")

    if mode == 1
        ground_data_profile = ground_data(:,lat_indx,hour);
        SH_data_profile = SH_data(:,lat_indx,hour);
        DEM_profile = DEM(:,lat_indx);
        clear DEM SH_data ground_data
        indx_num = 360;
    else
        ground_data_profile = ground_data(lon_indx,:,hour);
        SH_data_profile = SH_data(lon_indx,:,hour);
        DEM_profile = DEM(lon_indx,:);
        clear DEM SH_data ground_data
        indx_num = 181;
    end

    %%
    h_interval = 10;
    h_end = 7000;
    levels_num = 800;

    for indx = 1:indx_num
        levels_h =  DEM_profile(indx):h_interval:h_end;
        data_profile = ground_data_profile(indx)*exp((DEM_profile(indx)-levels_h) / (SH_data_profile(indx)*1000));
        profile(:,indx) = padarray(data_profile, [0, levels_num - length(data_profile)], NaN, 'pre');
    end
    profile = flipud(profile);
%     profile(isnan(profile)) = 10000;
    nexttile
    image(profile,'CDataMapping','scaled')
    cmap = colormap("parula");
    cmap(end+1,:) = [1 1 1];
    colormap(flipud(cmap));
    colorbar
    if mode == 1
        xlabel('longtitude')
        xticks(1:30:360);
        xticklabels( {'0°', '30°E', '60°E', '90°E', '120°E', '150°E', '180°', '150°W', '120°W', '90°W', '60°W', '30°W'});
        title(strcat(varstr,yearstr,monthstr,daystr,num2str(hour-1),' latitude=',num2str(lat),'°'))
        set(gca,"YTick",[])
    else
        xlabel('latitude')
    end
end