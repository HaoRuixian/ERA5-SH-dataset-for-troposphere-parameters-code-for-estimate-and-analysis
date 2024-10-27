clc
clear

%设置爬取时间
start_year       =2022     ;
start_month      =01        ;
start_day        =01        ;
end_year         =2022      ;
end_month        =12        ;
end_day          =31        ;
%读取爬取站点编号
stan = xlsread(strcat(pwd,'\UPAR_GLB_MUL_FTM_STATION.xlsx'));
stan = stan(:,1);
%设置保存文件夹
total_folder = strcat(pwd,'/','sounding_data_2022_old/');
%设置重新载入时间（s）
timeout = 60;

p = parpool(6);
parfor i_stan = 648:numel(stan)  %多站点循环，如果只下载单一站点，修改下一行
    
    station_nu =stan(i_stan,1);
%     have_data = 0;
    for year = start_year:1:end_year
        start_month1=start_month;
        end_month1  = end_month;

        if year > start_year %判断一年中的起止月份
            start_month1 =  1;
        end
        if year < end_year
            end_month1  = 12;
        end

        if ISLEAPYRAR(year) %判断是否为闰年
            months_day=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        else
            months_day=[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        end

        for month = start_month1 : end_month1

            start_day1=start_day;
            end_day1=end_day    ;
            if month > start_month1 %判断一月中的起止日期
                start_day1 =  1;
            end
            if month < end_month1
                end_day1  = months_day(month);
            end

            for day=start_day1:end_day1
                for time = [0,12]
                    folder = [total_folder, num2str(station_nu),'\'];
                    if exist(folder,'dir') == 0 %判断站点文件是否已经存在
                        mkdir(folder);
                    end
                    filename = [folder,num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'),num2str(time,'%02d'),'.txt'];
                    if exist(filename,"file")
                        disp('exist')
                        continue
                    end
                    tic;
                    [sourcefile, status] =urlread( ...
                        sprintf(['http://weather.uwyo.edu/cgi-bin/sounding?region=seasia&TYPE=TEXT%%3ALIST&YEAR=%04d&MONTH=%02d&' ...
                        'FROM=%02d%02d&TO=%02d%02d&STNM=%05d&ICE=1'], ...
                        year,month,day,time,day,time,station_nu),'Timeout',timeout);
                    % new website
%                     [sourcefile, status] =urlread( ...
%                         sprintf('http://weather.uwyo.edu/cgi-bin/bufrraob.py?datetime=%04d-%02d-%02d%%20%02d:00:00&id=%05d&type=TEXT:LIST', ...
%                         year,month,day,time,station_nu),'Timeout',timeout);

                    if ~status
                        itime=1;
                        while (~status)&&(itime<=3)
                            disp(['!!!!  载入失败  stn=',num2str(station_nu,'%05d'),' ,Data ',num2str(year,'%04d'), ...
                                num2str(month,'%02d'),num2str(day,'%02d'),' ,Time ',num2str(time,'%02d'),'尝试重新载入 ',num2str(itime,'%1d次'),' !!']);
                            [sourcefile, status] =urlread( ...
                        sprintf('http://weather.uwyo.edu/cgi-bin/bufrraob.py?datetime=%04d-%02d-%02d%%20%02d:00:00&id=%05d&type=TEXT:LIST', ...
                        year,month,day,time,station_nu),'Timeout',timeout);
                            itime=itime+1;
                        end
                        if itime>3
                            disp(['!!!!  载入失败  stn=',num2str(station_nu,'%05d'),' ,Data ',num2str(year,'%04d'), ...
                                num2str(month,'%02d'),num2str(day,'%02d'),' ,Time ',num2str(time,'%02d'),' !!'])
                        end
                    end

                    %去除sourcefile不相关字符
                    
%                     station_info = sourcefile(strfind(sourcefile,'Station identifier'):strfind(sourcefile,'Description of the')-11);
%                     station_number = num2str(sourcefile(strfind(sourcefile,'Station identifier'):strfind(sourcefile,'Description of the')-11));
%                     station_latiitude = str2double(sourcefile(strfind(sourcefile,'Station latitude: ')+18:strfind(sourcefile,'Station longitude: ')-11-17));
%                     station_longitude = str2double(sourcefile(strfind(sourcefile,'Station longitude: ')+19:strfind(sourcefile,'Station elevation')-11-17));
%                     station_elevation = str2double(sourcefile(strfind(sourcefile,'Station elevation: ')+19:strfind(sourcefile,'Showalter index:')-11-17));
%                     
%                     for old web
                    sourcefile = sourcefile(strfind(sourcefile,'   PRES   HGHT'):strfind(sourcefile,'Station information')-11);
%                     for new web
%                     sourcefile = sourcefile(strfind(sourcefile,'   PRES   HGHT'):strfind(sourcefile,'Interested in')-49);

                    t=toc;
                    if strfind(sourcefile,'   PRES   HGHT') > 0  %判断是否有缺测
                        %保存文件到对应文件夹
                        folder = [total_folder, num2str(station_nu),'\'];
                        if exist(folder,'dir') == 0 %判断站点文件是否已经存在
                            mkdir(folder);
                        end
                        filename = [folder,num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'),num2str(time,'%02d'),'.txt'];
                        fid = fopen(filename,'w');
                        fprintf(fid,'%s',sourcefile);
                        fclose(fid);
                        disp(['**  Finish  stn=',num2str(station_nu,'%05d'),' ,Data ',num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'), ...
                            ' ,Time ',num2str(time,'%02d'),' ,t= ',num2str(t,' %03f'),' **',])
%                         have_data = 1;
                    else
                        disp(['**  cannot get  stn_',num2str(station_nu,'%05d'),' ,Data ',num2str(year,'%04d'), ...
                            num2str(month,'%02d'),num2str(day,'%02d'),' ,Time ',num2str(time,'%02d'),' ,t= ',num2str(t,' %03f'),' **',])
                        
                    end
                    
                    sourcefile = [];
                end
            end
        end
    end
%     station_information(i_stan,:) = [station_nu station_latiitude station_longitude station_elevation have_data];
    
end
delete(p)

function [result] = ISLEAPYRAR(year)

if((rem(year,100)~=0)&&(rem(year,4)==0))
    result=0;
elseif(rem(year,4)==0)
    result=0;
else 
    result=1;
end

end
