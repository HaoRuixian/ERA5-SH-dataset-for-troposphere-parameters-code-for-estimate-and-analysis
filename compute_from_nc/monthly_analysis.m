%% save as point
clc
clear

H_series = [];
PWV_series = [];
% Store in increments along the longitude
for year = 2010:2019
    H_series_y = [];
    PWV_series_y = [];
    yearstr = num2str(year);


    path_data = strcat("F:\Results\monthly",yearstr,'.mat');
    load(path_data)
    % reshape to one column
    H_series_y = reshape(H,360*181,[]);
    PWV_series_y = reshape(PWV,360*181,[]);


    H_series = [H_series, H_series_y];
    PWV_series = [PWV_series, PWV_series_y];

end

file_H = 'F:\Dataset\point\H_monthly.mat';
file_PWV = 'F:\Dataset\point\PWV_monthly.mat';
save(file_H,"H_series",'-v7.3');
save(file_PWV,"PWV_series",'-v7.3');
%%
a_model = nan(65160,5);
% par = parpool(6);
for p = 1:360*181
    x = H_series(p,:);
    epoch = 1: numel(x);
    y = PWV_series(p,:);
    [~, residual, bias, rmse, a_fit] = model_fits(epoch, x);

    r1 = cor_analy(y,x);
    corrcoef_H_PWV(p) = r1;
    r2 = cor_analy(y,residual);
    corrcoef_Hresid_PWV(p) = r2;

    bias_all(p) = bias;
    rmse_all(p) = rmse;
    a_model(p,:) = a_fit;
    A_amplitude(p) = sqrt(a_fit(2)^2 + a_fit(3)^2);
    S_amplitude(p) = sqrt(a_fit(4)^2 + a_fit(5)^2);
end
delete(par)
save("2010_2019_results","a_model","A_amplitude","S_amplitude","corrcoef_H_PWV","rmse_all","corrcoef_Hresid_PWV","bias_all");
%%
corrcoef_Hresid_PWV = reshape(corrcoef_Hresid_PWV,360,181);
corrcoef_Hresid_PWV_abs = abs(corrcoef_Hresid_PWV);
corrcoef_H_PWV = reshape(corrcoef_H_PWV,360,181);
corrcoef_H_PWV_abs = abs(corrcoef_H_PWV);
bias_all = reshape(bias_all,360,181);
rmse_all  = reshape(rmse_all,360,181);
A_amplitude = reshape(A_amplitude,360,181);
S_amplitude = reshape(S_amplitude,360,181);
A_amplitude(A_amplitude > 6) = nan;
S_amplitude(S_amplitude > 6) = nan;
rmse_all(rmse_all>10) = nan;
bias_all(bias_all>0.1e-6 | bias_all<0) = nan;
%% draw the picture

draw_picture_global(bias_all)
c1 = colorbar;
caxis([-1,3])
set( c1, 'fontsize',20 );
%%
function monthly_pic(H)
H(H<0) =nan;
tiledlayout(2,6,'TileSpacing','Compact','Padding','Compact');
for month = 1:12
    nexttile
    data = H(:,:,month);

    draw_picture_global(data)
    c1 = colorbar;
    caxis([1,6])
    set( c1, 'fontsize',7 ,'ticklabels',{'<1',(1.5:0.5:5.5),'>6'});
    set(get(c1,'ylabel'), 'string','The Water Vapor Scale Height (km)','fontsize',7,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman')
end
end