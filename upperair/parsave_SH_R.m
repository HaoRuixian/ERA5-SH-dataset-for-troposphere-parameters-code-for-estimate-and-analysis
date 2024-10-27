function parsave_SH_R(path, data1, data2, dataname1, dataname2)
eval([char(dataname1) ' = data1;']);
eval([char(dataname2) ' = data2;']);
save(path, dataname1, dataname2)
end