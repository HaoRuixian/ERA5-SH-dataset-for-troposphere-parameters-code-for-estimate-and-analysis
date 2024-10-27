function nc_all = nc_cat(var, month,startpath,read_num,yearstr)
startpath(4) = (startpath(4)+1)/2;
read_num(4) = 12;
if var == 1
    variable_name = 'r';
    name1 = strcat("Relative_humidity_data\",yearstr,'\',yearstr);
    name2 = "_rh";
elseif var == 2
    variable_name = 'q';
    name1 = strcat("Specific_humidity_data\",yearstr,'\',yearstr);
    name2 = "_sh";
elseif var == 3
    variable_name = 't';
    name1 = strcat("temperature_data\",yearstr,'\',yearstr);
    name2 = "_temperature";
elseif var == 4
    variable_name = 'z';
    name1 = strcat("Geopotential_data\",yearstr,'\',yearstr);
    name2 = "_geopotential";
end
path = "F:\ERA5_data\pressure_level\";

if month < 10
    monthstr = strcat('0', num2str(month));
else
    monthstr = num2str(month);
end
file1 = strcat(path, name1, monthstr, name2,"_p1.nc");
file2 = strcat(path, name1, monthstr, name2,"_p2.nc");
nc1 = ncread(file1,variable_name,startpath,read_num);
nc2 = ncread(file2,variable_name,startpath,read_num);

nc_all = nan(360,181,37,24);
nc_all(:,:,:,1:2:23) = nc1;
nc_all(:,:,:,2:2:24) = nc2;
clear nc1 nc2
end

