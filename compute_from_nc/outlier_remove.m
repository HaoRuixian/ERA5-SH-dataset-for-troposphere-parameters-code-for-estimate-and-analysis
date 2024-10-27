function [outlier_indx] = outlier_remove(data)
[h,l] = size(data);
outlier_indx = nan(h,l);
for p = 1:360*181
    tic
    [~,TFrm] = rmoutliers(data(p,:),"grubbs");
    toc
    outlier_indx(p,:) = TFrm;
end
end