function corrcoef_r = cor_analy(x,y)
nanindx = isnan(x);
nanindy = isnan(y);
nanindx(nanindy == 1) = 1;
out_ind = nanindx;
x(out_ind) = [];
y(out_ind) = [];

r = corrcoef(x, y);
corrcoef_r = r(2);
end