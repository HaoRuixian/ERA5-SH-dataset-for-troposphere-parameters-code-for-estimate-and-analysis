tic
pause(4500)
toc
%% save as point
clc
clear
% Store in increments along the longitude
p = parpool(3);
for d = 3:3
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
    elseif d == 7
        datastr = 'ZTD';
    elseif d == 8
        datastr = 'ZWD';
    elseif d == 9
        datastr = 'ZHD';
    elseif d == 10
        datastr = 'PWV';
    elseif d == 11
        datastr = 'SVD';
    elseif d == 12
        datastr = 'Tm';
    end
    parfor year = 2013:2022
        SH_year_all = [];
        R_year_all = [];
        for month = 1:12
            yearstr = num2str(year);
            % daynum
            if month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12
                daynum = 31;
            elseif month==4 || month==6 || month==9 || month==11
                daynum = 30;
            elseif month == 2
                if (mod(year,4)==0 && mod(year,400)~=0) || mod(year,400)==0
                    daynum = 29;
                else
                    daynum = 28;
                end
            end
            if month < 10
                monthstr = strcat('0', num2str(month));
            else
                monthstr = num2str(month);
            end
            for day = 1:daynum
                if day<10
                    daystr = strcat('0',num2str(day));
                else
                    daystr = num2str(day);
                end

                if d >= 7
                    data_path_H = strcat("F:\DATASET\",datastr,'/',yearstr,'\',yearstr,monthstr,daystr,datastr,'.mat');
                    Data = load(data_path_H);
                    SH = Data.(datastr);

                    % reshape to one column
                    SH_series = reshape(SH,360*181,[]);
                    SH_year_all = [SH_year_all, SH_series];
                    SH_series = [];
                else
                    data_path_H = strcat("F:\DATASET\",datastr,'/',yearstr,'\',yearstr,monthstr,daystr,datastr,'_R.mat');
                    Data = load(data_path_H);
                    SH = Data.(datastr);
                    R = Data.(strcat(datastr,'_R'));

                    % reshape to one column
                    SH_series = reshape(SH,360*181,[]);
                    R_series = reshape(R,360*181,[]);

                    SH_year_all = [SH_year_all, SH_series];
                    SH_series = [];
                    R_year_all = [R_year_all, R_series];
                    R_series = [];
                end
            end
        end
        if d >= 7
            path_save = strcat('F:\DATASET\points\',datastr,'/');
            if ~exist(path_save,"dir")
                mkdir(path_save)
            end
            file_H = strcat(path_save,num2str(year),datastr,'.mat');
            parsave_parameters(file_H,SH_year_all,datastr)
        else
            path_save = strcat('F:\DATASET\points\',datastr,'/');
            if ~exist(path_save,"dir")
                mkdir(path_save)
            end
            file_H = strcat(path_save,num2str(year),datastr,'_R.mat');
            parsave_SH_R(file_H,SH_year_all,R_year_all,datastr,strcat(datastr,'_R'))
        end
    end
end


