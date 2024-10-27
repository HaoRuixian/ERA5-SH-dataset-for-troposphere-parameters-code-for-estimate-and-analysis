function [SH, R_SH] = fit_SHs(data, ellipsoid,d)
tic
SH = nan(360,181);
R_SH = nan(360,181);
for i = 1:181*360     %point
    lat = ceil(i/360);
    lon = mod(i,360);
    if lon == 0
        lon = 360;
    end
    data_p = squeeze(data(lon,lat,:));
    height = squeeze(ellipsoid(lon,lat,1:36));

    validIndices = ~isnan(height) & (~isnan(data_p) & data_p>0);
    heightValid = height(validIndices);
    data_pValid = data_p(validIndices);
    if isnan(data_p) | isnan(height)
        SH(lon,lat) = nan;
        R_SH(lon,lat) = nan;
        continue
    end
    if numel(heightValid)<10 | numel(data_pValid)<10
        SH(lon,lat) = nan;
        R_SH(lon,lat) = nan;
        continue
    end

    x = heightValid;
    y = data_pValid;
    if d == 6
        excludedind = x > 7000;
        x(excludedind) = [];
        y(excludedind) = [];
    end
%     if numel(x)<10 | numel(y)<10
%         SH(lon,lat) = nan;
%         R_SH(lon,lat) = nan;
%         continue
%     end
    fun = @(params, x) params(1) * exp(params(2) * x);

    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt');
    % 初始参数估计
    params0 = [y(1), -0.0001];
    params_fit = lsqnonlin(@(params) fun(params, x) - y, params0,[],[], options);

    a = params_fit(1);
    b = params_fit(2);

    y_fit = fun(params_fit,x);
    SS_tot = sum((y - mean(y)).^2); % 总平方和
    SS_res = sum((y - y_fit).^2); % 残差平方和
    R2 = 1 - SS_res / SS_tot; % 计算R方值

    %     opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    %
    %     ft = fittype( 'exp1' );
    %     tic
    %     [fitResult, gof] = fit(heightValid, data_pValid, ft, opts);
    %     toc
    %     r2 = gof.rsquare;
    SH(lon,lat) = -1/ (b*1000);
    R_SH(lon,lat) = R2;
    %     SH(lon,lat) = -1/ (b*1000);
    %     R_SH(lon,lat) = R_squared;
end

t = toc;
end