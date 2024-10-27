set(0,'defaultAxesFontSize', 16);
set(0,'defaultTextFontSize', 16);
p = parpool(3);
parfor d = 1:6
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
    var_all = [];
    for year = 2013:2022
        yearstr = num2str(year);
        Object = matfile(strcat("G:\DATASET\points\",datastr,"\",yearstr,datastr,"_R.mat"));

        if d == 1
            var = Object.PWVSH_R;
        elseif d == 2
            var = Object.WVSH_R;
        elseif d == 3
            var = Object.TmSH_R;
        elseif d == 4
            var = Object.ZTDSH_R;
        elseif d == 5
            var = Object.ZHDSH_R;
        elseif d == 6
            var = Object.ZWDSH_R;
        end

        var_mean = nanmean(var,2);
        var_all = [var_all var_mean];

    end
    save_path = strcat(pwd,'/',datastr,'_R_year_mean.mat');
    parsave_parameters(save_path,var_all,strcat(datastr,'_R_year_mean'))

%     data = nanmean(var_all,2);
%     data = reshape(data,360,181);
%     subplot(2,3,d)
%     draw_picture_global(data)
end
delete(p)

%% 
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
    save_path = strcat(pwd,'/',datastr,'_year_mean.mat');
    SH = load(save_path);
    var_name = strcat(datastr,'_year_mean');
    data_all = SH.(var_name);
    data = mean(data_all,2);
    %     [~,TFrm] = rmoutliers(data,'grubbs');
    %     data(TFrm) = nan;
%     data = slidingWindowOutlierDetection(data,24);
    data  = reshape(data,360,181);
    nexttile
    draw_picture_global(data);
    if d ~= 6
        delete(findobj(gca,'type','text'));
    end
    c = colorbar;
    c.FontSize = 18;
    c.Label.String = [datastr,'/km'];
    c.Label.FontSize = 20;
%     title(datastr)
end

%% 
% tiledlayout(2,3,"TileSpacing","tight")
% for d = 1:6
%     if d == 1
%         datastr = 'PWVSH';
%     elseif d == 2
%         datastr = 'WVSH';
%     elseif d == 3
%         datastr = 'TmSH';
%     elseif d == 4
%         datastr = 'ZTDSH';
%     elseif d == 5
%         datastr = 'ZHDSH';
%     elseif d == 6
%         datastr = 'ZWDSH';
%     end
%     save_path = strcat('G:\DATASET\',datastr,'\2013\20130101',datastr,'_R.mat');
%     SH = load(save_path);
%     var_name = strcat(datastr);
%     data_all = SH.(var_name);
%     data = data_all(:,:,1);
%     data  = reshape(data,360*181,1);
%     [~,TFrm] = rmoutliers(data,"grubbs");
%     data(TFrm) = nan;
%     data  = reshape(data,360,181);
%     nexttile
%     draw_picture_global(data);
%     if d ~= 6
%         delete(findobj(gca,'type','text'));
%     end
%     c = colorbar;
%     c.FontSize = 18;
%     c.Label.String = [datastr,'/km'];
%     c.Label.FontSize = 20;
% %     title(datastr)
% end
% 
%% 
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
    save_path = strcat(pwd,'/',datastr,'_R_year_mean.mat');
    SH = load(save_path);
    var_name = strcat(datastr,'_R_year_mean');
    data_all = SH.(var_name);
    data = mean(data_all,2);
%     data  = reshape(data,360*181,1);
%     [~,TFrm] = rmoutliers(data,"grubbs");
%     data(TFrm) = nan;
    data  = reshape(data,360,181);
    nexttile
    draw_picture_global(data);
    if d ~= 6
        delete(findobj(gca,'type','text'));
    end

    %     caxis([0.9,1])
    colormap("parula")

    c = colorbar;
%     c.Location = "southoutside";
    c.FontSize = 18;
%     c.Label.String = 'R';
    c.Label.FontSize = 15;
    

    title(datastr)

% colormap("gray")
end