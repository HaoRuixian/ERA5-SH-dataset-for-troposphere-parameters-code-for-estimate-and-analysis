function parsave_parameters(path, data, dataname)
eval([char(dataname) ' = data;']);
save(path, dataname,'-v7.3')
end