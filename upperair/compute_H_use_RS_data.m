clc
clear

start_year       =2022     ;
start_month      =01        ;
start_day        =01        ;
end_year         =2022      ;
end_month        =12        ;
end_day          =31        ;

stan_xls = xlsread("UPAR_GLB_MUL_FTM_STATION.xlsx");
stan = stan_xls(:,1);
%
% p = parpool(6);
for i_stan = 356:365+88%:numel(stan)
    inds = 0;
    station_nu =stan(i_stan,1);
    PWVSH = nan(730,1);
    R_PWVSH = nan(730,1);
    TmSH = nan(730,1);
    R_TmSH = nan(730,1);
    ZTDSH = nan(730,1);
    R_ZTDSH = nan(730,1);
    ZWDSH = nan(730,1);
    R_ZWDSH = nan(730,1);
    ZHDSH = nan(730,1);
    R_ZHDSH = nan(730,1);
    WVSH = nan(730,1);
    R_WVSH = nan(730,1);
    

    Tm = nan(730,1);
    ZTD = nan(730,1);
    ZWD = nan(730,1);  
    ZHD = nan(730,1);
    PWV = nan(730,1);
    p0 = nan(730,1);
    SVD = nan(730,1);
    for year = start_year:1:end_year
        start_month1 = start_month;
        end_month1 = end_month;

        if year > start_year
            start_month1 =  1;
        end
        if year < end_year
            end_month1  = 12;
        end

        if ISLEAPYRAR(year)
            months_day=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        else
            months_day=[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        end

        for month = start_month1:end_month1

            start_day1=start_day;
            end_day1=end_day    ;
            if month > start_month1
                start_day1 =  1;
            end
            if month < end_month1
                end_day1  = months_day(month);
            end

            for day = start_day1:1:end_day1
                for time=[0,12]    %探空时间
                    inds = inds+1;
                    file_name = strcat(pwd, '/', 'sounding_data_2022/', num2str(station_nu), '/', ...
                        num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'),num2str(time,'%02d'),'.txt');
                    %%
                    if exist(file_name,'file')
                        fid = fopen(file_name);
                        sounding_data = [];
                        while ~feof(fid)
                            % 每次读取一行, str是字符串格式
                            str = fgetl(fid);

                            if double(str(7))>=48 && double(str(7))<=57
                                s = regexp(str,'  ','split');
                                s = s(~cellfun('isempty', s));
                                s = str2double(string(char(s)));
                                if numel(s) ~= 11 % 检查变量是否完整
                                    continue
                                end
                                sounding_data = [sounding_data;s'];
                            else
                                continue
                            end
                        end
                        fclose(fid);
                    else % 不存在文件
                        continue
                    end

                    %% preconditioning
                    if numel(sounding_data) == 0
                        continue
                    end
                    height = sounding_data(:,2);
                    pressure = sounding_data(:,1);
                    
                    if max(diff(pressure)) >= 200 | max(diff(height)) >= 2000 | max(height) <= 10000
                        continue
                    end
                    
                    [level,~] = size(sounding_data);
                    if level < 20
                        continue
                    end

                    %% Parameter calculation
                    temperature_C = sounding_data(:,3);
                    relative_humidity = sounding_data(:,5);
                    temperature_K = temperature_C+273.15;
                    level = numel(pressure);

                    % compute es
                    es = [];
                    for k = 1:level
                        if temperature_C(k) > 0
                            es(k,1) = 6.1078 * 10.^(7.5 * temperature_C(k) / (temperature_C(k) + 237.3)) * (relative_humidity(k)/100.0); % hpa
                        else
                            es(k,1) = 6.1078 * 10.^(9.5*temperature_C(k) / (temperature_C(k) + 265.5)) * (relative_humidity(k)/100.0);
                        end
                    end

                    % compute PWV
                    specific_humidity = 622 * es ./ (pressure - 0.378 * es); % g/kg
                    pressure_mid = -diff(pressure);
                    specific_humidity_mid = (specific_humidity(1:end-1) + specific_humidity(2:end)) / 2;
                    p_water = 1; % the density of water
                    pwv_levels = (1/9.80655/p_water) * 0.5 *specific_humidity_mid .* pressure_mid *0.1 ;% mm

                    % compute p0
                    Rv = 461.5;% J/(kg*K)
                    p0 = (es*100)*1000 ./ (Rv * (temperature_C + 273.15));% g/m^3

                    % compute ZTD\ZWD\ZHD
                    height_thickness = diff(height);
                    k1 = 77.689;
                    k2 = 64.79;
                    k3 = 375463;
                    k2w = 71.2952;
                    N = k1*(pressure-es) ./temperature_K +...
                        k2*es./temperature_K +...
                        k3*es./(temperature_K.*temperature_K);
                    Nw = k2w*es./temperature_K +...
                        k3*es./(temperature_K.*temperature_K);
                    Nh = k1*(pressure-es)./temperature_K;

                    ZWD_levels = 1e-6 * 0.5*(Nw(1:end-1)+Nw(2:end)) .* height_thickness;
%                     ZTD_levels = 1e-6 * 0.5*(N(1:end-1)+N(2:end)) .* height_thickness;
                    ZHD_levels = 1e-6 * 0.5*(Nh(1:end-1)+Nh(2:end)) .* height_thickness;
                    ZTD_levels = ZWD_levels + ZHD_levels;

                    % compute Tm
                    T1 = es ./ temperature_K;
                    T2 = es ./ (temperature_K.*temperature_K);
                    denominator = 0.5*height_thickness .* (T2(1:end-1) + T2(2:end));
                    molecule = 0.5*height_thickness .* (T1(1:end-1) + T1(2:end));

                    Tm_t = nan(level-1,1);
                    ZTD_t = nan(level-1,1);
                    ZWD_t = nan(level-1,1);
                    ZHD_t = nan(level-1,1);
                    PWV_t = nan(level-1,1);

                    for k = 1:level-1
                        Tm_t(k,1) = nansum(molecule(k:end)) / nansum(denominator(k:end));
                        ZTD_t(k,1) = nansum(ZTD_levels(k:end));
                        ZWD_t(k,1) = nansum(ZWD_levels(k:end));
                        ZHD_t(k,1) = nansum(ZHD_levels(k:end));
                        PWV_t(k,1) = nansum(pwv_levels(k:end));
                    end


                    % fit
                    if numel(unique(height)) ~= numel(height)
                        continue
                    end

                    for d = 1:6
                        if d == 1
                            data = PWV_t;
                        elseif d == 2
                            data = Tm_t;
                        elseif d == 3
                            data = ZTD_t;
                        elseif d == 4
                            data = ZWD_t;
                        elseif d == 5
                            data = ZHD_t;
                        elseif d == 6
                            data = p0(1:level-1);
                        end

                        heightValid = height(1:level-1);
                        data_pValid = data;

                        x = heightValid;
                        y = data_pValid;
                        if d == 1
                            excludedind = x > 12500;
                            x(excludedind) = [];
                            y(excludedind) = [];
                        end
                        if numel(x)<10 | numel(y)<10
                            continue
                        end
                        fun = @(params, x) params(1) * exp(params(2) * x);

                        options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt');
                        % 初始参数估计
                        params0 = [y(1), -0.0001];
                        try
                            params_fit = lsqnonlin(@(params) fun(params, x) - y, params0,[],[], options);
                        catch
                            warning('something wrong')
                        end
                        a = params_fit(1);
                        b = params_fit(2);
                        SH = -1/ (b*1000);

                        y_fit = fun(params_fit,x);
                        SS_tot = sum((y - mean(y)).^2); % 总平方和
                        SS_res = sum((y - y_fit).^2); % 残差平方和
                        R2 = 1 - SS_res / SS_tot; % 计算R方值

                        if d == 1
                            PWV(inds,1) = PWV_t(1);
                            PWVSH(inds,1) = SH;
                            R_PWVSH(inds,1) = R2;
                        elseif d == 2
                            Tm(inds,1) = Tm_t(1);
                            TmSH(inds,1) = SH;
                            R_TmSH(inds,1) = R2;
                        elseif d == 3
                            ZTD(inds,1) = ZTD_t(1);
                            ZTDSH(inds,1) = SH;
                            R_ZTDSH(inds,1) = R2;
                        elseif d == 4
                            ZWD(inds,1) = ZWD_t(1);
                            ZWDSH(inds,1) = SH;
                            R_ZWDSH(inds,1) = R2;
                        elseif d == 5
                            ZHD(inds,1) = ZHD_t(1);
                            ZHDSH(inds,1) = SH;
                            R_ZHDSH(inds,1) = R2;
                        elseif d == 6
                            SVD(inds,1) = p0(1);
                            WVSH(inds,1) = SH;
                            R_WVSH(inds,1) = R2;
                        end
                    end
                end
            end
        end
    end
    %% save results

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
        if all(isnan(data1)) | all(isnan(data2))
            continue
        end
        path_save = strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/');
        if ~exist(path_save,"dir")
            mkdir(path_save)
        end
        filename = strcat(path_save,'2022',num2str(station_nu),'_',var,'_R.mat');
        parsave_SH_R(filename,data1,data2,var,strcat(var,'_R'))
    end

    % save parameters
    for d = 1:6
        if d == 1
            var = 'PWV';
            data = PWV;
        elseif d == 2
            var = 'Tm';
            data = Tm;
        elseif d == 3
            var = 'ZTD';
            data = ZTD;
        elseif d == 4
            var = 'ZWD';
            data = ZWD;
        elseif d == 5
            var = 'ZHD';
            data = ZHD;
        elseif d == 6
            var = 'SVD';
            data = SVD;
        end
        if all(isnan(data))
            continue
        end
        path_save = strcat(pwd,'/sounding_2022_results/',num2str(station_nu),'/');
        if ~exist(path_save,"dir")
            mkdir(path_save)
        end
        filename = strcat(path_save,'2022',num2str(station_nu),'_',var,'.mat');
        parsave_parameters(filename,data,var)
    end
end
% delete(p)

%% functions
function [result] = ISLEAPYRAR(year)
if((rem(year,100)~=0)&&(rem(year,4)==0))
    result=0;
elseif(rem(year,4)==0)
    result=0;
else
    result=1;
end
end