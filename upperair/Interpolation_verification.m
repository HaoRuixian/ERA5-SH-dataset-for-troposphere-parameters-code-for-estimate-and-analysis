clc
clear

addpath('E:\桌面\水汽标高的计算\ERA5')
start_year       =2022;
start_month      =01;
start_day        =01;
end_year         =2022;
end_month        =12;
end_day          =31;

stan_xls = xlsread('UPAR_GLB_MUL_FTM_STATION.xlsx');
stan = stan_xls(:,1);
lon = stan_xls(:,3);
lat = stan_xls(:,4);
h = stan_xls(:,5);
sta_num = numel(stan);
verify_info = nan(sta_num,6);
for d = 6:6
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

    file_path = strcat('G:\DATASET\points\',datastr,'\2022',datastr,'_R.mat');
    data_era5_o = load(file_path,datastr);% load era5 data
    data_era5 = data_era5_o.(datastr);
    clear data_era5_o

    data_era5 = reshape(data_era5, 360,181,[]);
    data_era5 = data_era5(:,:,1:12:end);

%     p = parpool(6);
    %%
    for i_stan = 1:sta_num

        station_nu = stan(i_stan,1);
%         if ~station_nu == 83378
%             continue
%         end
        station_lat = lat(i_stan,1);
        station_lon = lon(i_stan,1);
        station_h = h(i_stan,1);
        interpolated_data = [];
        interpolated_H_model = [];

        if isnan(station_lon) || isnan(station_lat)
            disp('Latitude or longitude data are missing')
            continue
        end
        % switch to grid
        if station_lon < 0
            station_lon = 360 + station_lon;
        end
        if station_lat <= 0
            station_lat = 90 + abs(station_lat);
        elseif station_lat > 0
            station_lat = 90 - station_lat;
        end
        if exist(strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/'),"dir")
            data_sounding = load(strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/2022',num2str(station_nu),'_',datastr,'_R.mat'),datastr); % load sounding data
            data_sounding = data_sounding.(datastr);
            data_sounding_R = load(strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/2022',num2str(station_nu),'_',datastr,'_R.mat'),strcat(datastr,'_R')); % load sounding data
            data_sounding_R = data_sounding_R.(strcat(datastr,'_R'));
            data_sounding(data_sounding_R < 0.985) = nan;
        else
            continue
        end
        % four points info
        lon1 = floor(station_lon)+1;
        lon2 = lon1 + 1;
        lat1 = floor(station_lat)+1;
        if lat1 == 181
            lat2 = lat1;
        else
            lat2 = lat1 + 1;
        end
        data1 = squeeze(data_era5(lon1,lat1,:));
        data2 = squeeze(data_era5(lon2,lat1,:));
        data3 = squeeze(data_era5(lon1,lat2,:));
        data4 = squeeze(data_era5(lon2,lat2,:));
        % Calculated weight
        wlon = station_lon - (lon1-1);
        wlat = station_lat - (lat1-1);

        % Bilinear interpolation
        interpolated_data = (1 - wlon) * (1 - wlat) * data1 + wlon * (1 - wlat) * data2 + (1 - wlon) * wlat * data3 + wlon * wlat * data4;

        %% get rid of outliers
        [~,TFrm] = rmoutliers(data_sounding,"grubbs");
        data_sounding(TFrm) = nan;
        [~,TFrm] = rmoutliers(interpolated_data,"grubbs");
        interpolated_data(TFrm) = nan;

        % compute rmse and bias
        [rrmse_value, rmse_value, bias_value, r, vdn] = calculate_rmse_and_bias(data_sounding(1:730), interpolated_data);
        if r>0.98 && vdn>600
            figure
            tiledlayout(1,7,"TileSpacing","tight")
            set(gcf,"Position",[1,1,1392,560])
            nexttile([1,4])
            scatter(1:730,data_sounding(1:730),15,'r*','DisplayName','Radiosonde-SH')
            hold on
            plot(1:730,interpolated_data,'Color','#4DBEEE','DisplayName','ERA5-SH')
            plot(1:730,data_sounding(1:730),'r')
            legend('Radiosonde-SH','ERA5-SH','FontSize',20)
            box on
            ylabel([datastr,'/km'],'FontWeight','bold','FontName','times new roman');
            xlabel('Epoch','FontWeight','bold','FontName','times new roman');
            set(gca,'FontName','times new roman','FontSize',20,...
                'FontWeight','bold');
            xlim([0,730])
            hold off
            %         save_pic_path = strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/2022',num2str(station_nu),'_',datastr,'.png');
            %         ax = gca;
            %         exportgraphics(ax,save_pic_path,'Resolution',300)

            nexttile([1,3])
            %         [r, vdn] = scatter_density_plot(data_sounding,interpolated_data);
            CData = density2C(data_sounding,interpolated_data,min(interpolated_data):0.01:max(interpolated_data),min(interpolated_data):0.1:max(interpolated_data));
            set(gcf,'Color',[1 1 1]);
            scatter(data_sounding,interpolated_data,50,'filled','CData',CData);
            xlim([min(interpolated_data),max(interpolated_data)])
            ylim([min(interpolated_data),max(interpolated_data)])
            box on
            ylabel('ERA5-SH(km)','FontWeight','bold','FontSize',20,'FontName','times new roman');
            xlabel('Radiosonde-SH(km)','FontWeight','bold','FontSize',20,'FontName','times new roman');
            hold on
            x = data_sounding;
            y = interpolated_data;
            nanindx = isnan(x);
            nanindy = isnan(y);
            nanindx(nanindy == 1) = 1;
            out_ind = nanindx;
            x(out_ind) = [];
            y(out_ind) = [];
            p = polyfit(x, y, 1);
            y_fit = polyval(p, x);
            plot(x, y_fit, 'r-', 'LineWidth', 2);
            text(2,1.5, ['y = ' num2str(round(p(1),3)) 'x + ' num2str(round(p(2),3))], ...
                'HorizontalAlignment', 'left', 'VerticalAlignment','top','FontWeight','bold','FontSize',20,...
                'FontName','times new roman');
            annotation(gcf,'textbox',...
                [0.8 0.15 0.1 0.1],...
                'String',['R^2=',num2str(r)],'FontWeight','bold', 'FontSize',20,...
                'FontName','Times New Roman',...
                'FitBoxToText','off',...
                'EdgeColor','none');

            colorbar
            set(gca,'FontName','times new roman','FontSize',20,...
                'FontWeight','bold');
            hold off
            %         save_pic_path = strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/2022',num2str(station_nu),'_',datastr,'scatter.png');
            save_pic_path = ['E:\桌面\ERA5_WVSH\lecture\picture\test\',num2str(station_nu),'_',datastr,'.jpg'];
            print(gcf,save_pic_path,'-djpeg','-r600')
        end
        verify_info(i_stan,:) = [rrmse_value, rmse_value, bias_value,r,vdn,d];

    end
    verify_info_sp = strcat(pwd,'/',datastr,'2022_verify_info.mat');
    parsave_parameters(verify_info_sp,verify_info,'verify_info')
    delete(p)
end

%% -------------------------functions--------------------------------------
function [CData,h,XMesh,YMesh,ZMesh,colorList]=density2C(X,Y,XList,YList,colorList)
[XMesh,YMesh]=meshgrid(XList,YList);
XYi=[XMesh(:) YMesh(:)];
F=ksdensity([X,Y],XYi);
ZMesh=zeros(size(XMesh));
ZMesh(1:length(F))=F;

h=interp2(XMesh,YMesh,ZMesh,X,Y);
if nargin<5
    colorList=[0.2700         0    0.3300
        0.2700    0.2300    0.5100
        0.1900    0.4100    0.5600
        0.1200    0.5600    0.5500
        0.2100    0.7200    0.4700
        0.5600    0.8400    0.2700
        0.9900    0.9100    0.1300];
end
colorFunc=colorFuncFactory(colorList);
CData=colorFunc((h-min(h))./(max(h)-min(h)));
colorList=colorFunc(linspace(0,1,100)');

    function colorFunc=colorFuncFactory(colorList)
        x=(0:size(colorList,1)-1)./(size(colorList,1)-1);
        y1=colorList(:,1);y2=colorList(:,2);y3=colorList(:,3);
        colorFunc=@(X)[interp1(x,y1,X,'pchip'),interp1(x,y2,X,'pchip'),interp1(x,y3,X,'pchip')];
    end
end

function [rrmse_value, rmse_value, bias_value, r, vdn] = calculate_rmse_and_bias(true_values, predicted_values)
indnan1 = isnan(true_values);
indnan2 = isnan(predicted_values);
nan_all = indnan1==1 | indnan2==1;
true_values(nan_all) = [];
predicted_values(nan_all) = [];
vdn = numel(true_values);
% diff^2
diff_squared = (true_values - predicted_values).^2;
% rmse
rmse_value  = sqrt(mean(diff_squared));
rrmse_value = sqrt(mean(diff_squared))/mean(abs(true_values));
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
