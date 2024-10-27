clc
clear

for var = ["TmSH","ZTDSH","ZHDSH","ZWDSH"]

    data = load(strcat("G:/DATASET/points/",var,"/2020",var,"_R.mat"),var);
    data = data.(var);
    data = reshape(data,360,181,[]);

    data_path = strcat("G:/DATASET/open_dataset/2020_",var,".mat");
    parsave(data_path,data,var)
end

function parsave(path, data, dataname)
eval([char(dataname) ' = data;']);
save(path, dataname,'-v7.3')
end