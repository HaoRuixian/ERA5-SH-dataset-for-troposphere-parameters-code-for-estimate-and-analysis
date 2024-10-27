function computue_parameters(app, sounding_dir, save_dir, parameters, version, height_lim, levels_lim, stan_compute, start_date, end_date)

fig = app.UIFigure;
d = uiprogressdlg(fig,'Title','计算进度');

starttime = datevec(start_date);
endtime = datevec(end_date);
start_year = starttime(1);
start_month = starttime(2);
start_day = starttime(3);
end_year = endtime(1);
end_month = endtime(2);
end_day = endtime(3);

% station list
stan = stan_compute;

% Determine which parameter to calculate
calculate_PWV = parameters(1);
calculate_Tm = parameters(2);
calculate_H = parameters(3);
calculate_wvd = parameters(4);

% the web version, with the different var number
if version == 1
    var_num = 13;
elseif version == 2
    var_num = 11;
end

num = 0;
for i_stan = 1:numel(stan)
    d.Title = strcat('计算进度：正在计算第',num2str(i_stan),'个测站，共',num2str(numel(stan)),'个');
    d.Value = (i_stan-1) / numel(stan);

    station_nu = stan(i_stan,1);
    H_all = [];
    PWV_all = [];
    Tm_all = [];
    wvd_all = [];
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
            months_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        else
            months_day = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        end

        for month = start_month1:end_month1

            start_day1 = start_day;
            end_day1 = end_day;
            if month > start_month1
                start_day1 = 1;
            end
            if month < end_month1
                end_day1  = months_day(month);
            end

            for day = start_day1:1:end_day1
                for time = [0,12]    % sounding time
                    num = num + 1;
                    file_name = strcat(sounding_dir,'\', num2str(station_nu), '\', ...
                        num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'),num2str(time,'%02d'),'.txt');

                    %% read the sounding file
                    if exist(file_name,'file')
                        fid = fopen(file_name);
                        sounding_data = [];
                        while ~feof(fid)
                            str = fgetl(fid);

                            if double(str(7))>=48 && double(str(7))<=57
                                s = regexp(str,'  ','split');
                                s = s(~cellfun('isempty', s));
                                s = str2double(string(char(s)));
                                if numel(s) ~= var_num % Check whether the variable is complete
                                    continue
                                end
                                sounding_data = [sounding_data;s'];
                            else
                                continue
                            end
                        end
                        fclose(fid);
                    else % No file exists and the point-in-time data is assigned to nan
                        [PWV_all, Tm_all, H_all, wvd_all, height_all] = give_the_nan(PWV_all, Tm_all, H_all, wvd_all, height_all, num);
                        continue
                    end

                    %% Quality control
                    if numel(sounding_data) == 0
                        [PWV_all, Tm_all, H_all, wvd_all, height_all] = give_the_nan(PWV_all, Tm_all, H_all, wvd_all, height_all, num);
                        continue
                    end

                    if sounding_data(:,2) <= height_lim
                        [PWV_all, Tm_all, H_all, wvd_all, height_all] = give_the_nan(PWV_all, Tm_all, H_all, wvd_all, height_all, num);
                        continue
                    end

                    [level,~] = size(sounding_data);
                    if level < levels_lim
                        [PWV_all, Tm_all, H_all, wvd_all, height_all] = give_the_nan(PWV_all, Tm_all, H_all, wvd_all, height_all, num);
                        continue
                    end

                    nan_out = any(isnan(sounding_data), 2);
                    sounding_data(nan_out,:) = [];

                    %% Parameter calculation
                    height = sounding_data(:,2);
                    pressure = sounding_data(:,1);
                    temperature_C = sounding_data(:,3);
                    if version == 1
                        relative_humidity = sounding_data(:,6);
                    elseif version == 2
                        relative_humidity = sounding_data(:,5);
                    end
                    level = numel(pressure);

                    % compute es
                    for k = 1:level
                        if temperature_C(k) > 0
                            es(k) = 6.1078 * 10.^(7.5 * temperature_C(k) / (temperature_C(k) + 237.3)) * (relative_humidity(k)/100.0); % hpa
                        else
                            es(k) = 6.1078 * 10.^(9.5*temperature_C(k) / (temperature_C(k) + 265.5)) * (relative_humidity(k)/100.0);
                        end
                    end
                    es = es';

                    if calculate_PWV == 1
                        % compute PWV
                        specific_humidity = 622 * es ./ (pressure - 0.378 * es); % g/kg
                        pressure_mid = -diff(pressure);
                        specific_humidity_mid = (specific_humidity(1:end-1) + specific_humidity(2:end)) / 2;
                        p_water = 1; % the density of water
                        pwv_levels = (1/9.80655/p_water) * 0.5 *specific_humidity_mid .* pressure_mid *0.1 ;% mm
                        
                        for k = 1:level-1
                            pwv_levels(k) = sum(pwv_levels(k:end));
                        end

                        PWV_all(num).data = pwv_levels;
                    end

                    if calculate_Tm == 1
                        % compute Tm
                        height_thickness = diff(height);
                        T1 = es ./ temperature_C;
                        T2 = es ./ (temperature_C.*temperature_C);
                        denominator = sum(0.5*height_thickness .* (T2(1:end-1) + T2(2:end)));
                        molecule = sum(0.5*height_thickness .* (T1(1:end-1) + T1(2:end)));
                        Tm = molecule / denominator;

                        Tm_all = [Tm_all, Tm];
                    end

                    if calculate_wvd == 1
                        % compute wvd
                        Rv = 461.5;% J/(kg*K)
                        wvd = (es*100)*1000 ./ (Rv * (temperature_C + 273.15));% g/m^3

                        wvd_all(num).data = wvd;
                    end

                    if calculate_H == 1
                        % compute PWV frist
                        specific_humidity = 622 * es ./ (pressure - 0.378 * es); % g/kg
                        pressure_mid = -diff(pressure);
                        specific_humidity_mid = (specific_humidity(1:end-1) + specific_humidity(2:end)) / 2;
                        p_water = 1; % the density of water
                        pwv_levels = (1/9.80655/p_water) * 0.5 *specific_humidity_mid .* pressure_mid *0.1 ;% mm
                        pwv_all = sum(pwv_levels);

                        % compute p0 next
                        Rv = 461.5;% J/(kg*K)
                        p0 = (es*100)*1000 ./ (Rv * (temperature_C + 273.15));% g/m^3

                        % compute H
                        H = pwv_all*999 / p0(1) / 1000; % km

                        H_all(num) = H;
                    end

                    es = [];

                    % store height
                    height_all(num).data = height;

                end
            end
        end
    end

    %% save results
    if exist(strcat(sounding_dir,'/', num2str(station_nu)))
        Time_period = strcat(datestr(start_date),'_to_',datestr(end_date));
        if calculate_H == 1
            save_H_file = strcat(save_dir,'/',num2str(station_nu),'_',Time_period,'_H.mat');
            save(save_H_file,"H_all")
        end
        if calculate_PWV == 1
            save_PWV_file = strcat(save_dir,'/',num2str(station_nu),'_',Time_period,'_PWV.mat');
            save(save_PWV_file,"PWV_all")
        end
        if calculate_Tm == 1
            save_Tm_file = strcat(save_dir,'/',num2str(station_nu),'_',Time_period,'_Tm.mat');
            save(save_Tm_file,"Tm_all")
        end
        if calculate_wvd == 1
            save_wvd_file = strcat(save_dir,'/',num2str(station_nu),'_',Time_period,'_wvd.mat');
            save(save_wvd_file,"wvd_all")
        end
        save_height_file = strcat(save_dir,'/',num2str(station_nu),'_',Time_period,'_height.mat');
        save(save_height_file,"height_all")
    else
        continue
    end

end

    function [result] = ISLEAPYRAR(year)
        if((rem(year,100)~=0)&&(rem(year,4)==0))
            result=0;
        elseif(rem(year,4)==0)
            result=0;
        else
            result=1;
        end
    end

    function [PWV_all, Tm_all, H_all, wvd_all, height_all] = give_the_nan(PWV_all, Tm_all, H_all, wvd_all, height_all, num)
        if calculate_PWV == 1
            PWV_all(num).data = nan;
        end
        if calculate_Tm == 1
            Tm = nan;
            Tm_all = [Tm_all, Tm];
        end
        if calculate_H == 1
            H = nan;
            H_all(num) = H;
        end
        if calculate_wvd == 1
            wvd_all(num).data = nan;
        end
        height_all(num).data = nan;
    end
end