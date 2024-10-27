function Exponential_fitting(data)
%  v_data = nanmean(data);
% v_data = v_data(1:230);
v_data = data(1:230);

hi = 1:numel(v_data);
for i = 1:numel(v_data)
    if ~isnan(v_data(i))
        StartPoint = [i,v_data(i)];
        break
    end
end

data_fit = v_data(~isnan(v_data));
x = hi(~isnan(v_data));

scatter(x, data_fit,50,"filled")
hold on

% Set up fittype and options.
ft = fittype( 'a * exp(b*x)','independent','x','coefficients',{'a','b'} );

% Fit model to data.
[fitresult, gof] = fit( x', data_fit', ft, 'Lower',[0,-10],'Upper',[100,0],'StartPoint',StartPoint);

% Plot fit with data.
h = plot( x, fitresult(x));
set(h,'linewidth', 2.2);
legend('PWV Data', 'Exponential fitting curve' );
% Label axes
ylabel("PWV(mm)")
xlabel("Height(km)")
xticks([0  40 80 120 160 200 240])
xticklabels({'0','2','4','6','8','10','12'})
set(gca,'FontName','Times New Roman','FontSize', 25)
box on
grid on
hold off
