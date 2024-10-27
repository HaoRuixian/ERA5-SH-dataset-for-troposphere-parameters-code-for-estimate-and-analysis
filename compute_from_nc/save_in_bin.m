clc
clear

load("G:\DATASET\PWVSH\2022\20220101PWVSH_R.mat")
fid=fopen('G:\DATASET\PWVSH\2022\test.dat','wb');
fwrite(fid,PWVSH,'double')
fclose(fid);