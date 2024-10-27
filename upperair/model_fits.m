function [data_fit, residuals, bias, rmse, a_fit] = model_fits(epoch, data)
% Construct model function
model = @(a, x) a(1) + a(2)*cos(2*pi*x/365.25) + a(3)*sin(2*pi*x/365.25) + a(4)*cos(4*pi*x/365.25) + a(5)*sin(4*pi*x/365.25); %
data = fillmissing(data, 'pchip');

% Initialize the fitting coefficient
a0 = mean(data);
a1 = std(data);
a2 = std(data);
a3 = std(data);
a4 = std(data);
a_init = [a0, a1, a2, a3, a4];

% fitting
options = optimoptions('lsqcurvefit', 'Display', 'off');
[a_fit, resnorm, residuals] = lsqcurvefit(model,a_init, epoch, data, [], [], options);

% Fitted values, residuals and RMSE
data_fit = model(a_fit, epoch);
bias = mean(abs(residuals));
rmse = sqrt(resnorm / numel(epoch));
end