clc
clear
varstr = "ZTDSH";
p = parpool;
for year = 2013:2013
    for month = 1:12
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
        parfor day = 1:daynum
            if month < 10
                monthstr = strcat('0', num2str(month));
            else
                monthstr = num2str(month);
            end
            yearstr = num2str(year);

            if day<10
                daystr = strcat('0',num2str(day));
            else
                daystr = num2str(day);
            end
            path = strcat("F:/DATASET/",varstr,"/",yearstr,"/",yearstr,monthstr,daystr,varstr,"_R.mat");
            data_all = load(path);
            SH = data_all.(varstr);
            R = data_all.(strcat(varstr,"_R"));

            for hourid = 1:24
                
                    data = SH(:,:,hourid);
                    draw_picture_global(data)
                    caxis([6,8])
                    
                    if hourid<=10
                        hourstr = strcat("0",num2str(hourid-1));
                    else
                        hourstr = num2str(hourid-1);
                    end
                    title(strcat(yearstr,monthstr,daystr,hourstr,varstr))
                    savepath = strcat("F:/picture/",varstr,"/",yearstr,"/",yearstr,monthstr,daystr,hourstr,varstr,".png");
                    print(gcf, '-dpng', savepath)

            end
        end
    end
end
delete(p)
%%

clc
clear
varstr = "ZTDSH";
outputFileName = 'ZTDSH2013.gif';
delayTime = 0.1; 

idx = 1;
for year = 2013:2013
    for month = 1:12
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
        for day = 1:daynum
            if month < 10
                monthstr = strcat('0', num2str(month));
            else
                monthstr = num2str(month);
            end
            yearstr = num2str(year);

            if day<10
                daystr = strcat('0',num2str(day));
            else
                daystr = num2str(day);
            end


            for hourid = 1:24
                if hourid<=10
                    hourstr = strcat("0",num2str(hourid-1));
                else
                    hourstr = num2str(hourid-1);
                end
                path = strcat("F:/picture/",varstr,"/",yearstr,"/",yearstr,monthstr,daystr,hourstr,varstr,".png");
                img = imread(path);
                [indexedImg, cmap] = rgb2ind(img, 256);
                if idx == 1
                    imwrite(indexedImg, cmap, outputFileName, 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
                else
                    imwrite(indexedImg, cmap, outputFileName, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
                end
                idx=idx+1;
            end
        end
    end
end