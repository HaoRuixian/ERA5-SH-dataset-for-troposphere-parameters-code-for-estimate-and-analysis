function [r, vdn] = scatter_density_plot(x, y)
% for epoch = 1:numel(x)
%     doy = floor(epoch/2) + 1;
%     season = calculateSeason(doy);
%     sen(epoch, 1) = string(season);
% end

nanindx = isnan(x);
nanindy = isnan(y);
nanindx(nanindy == 1) = 1;
out_ind = nanindx;
x(out_ind) = [];
y(out_ind) = [];
vdn = numel(x);
r = corrcoef(x,y);
if numel(r) == 1
    r = nan;
    return
end
r = r(2);
% sen(out_ind) = [];
% 绘制散点密度图
try
    scatter(x, y, 5, 'filled' );
    hold on;

    % 绘制线性拟合线
    p = polyfit(x, y, 1);

    % x_fit = linspace(min(x), max(x), 100);
    y_fit = polyval(p, x);
    plot(x, y_fit, 'r-', 'LineWidth', 2);

    text(0.05, 0.95, ['y = ' num2str(p(1)) 'x + ' num2str(p(2))], 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 12);
    % 设置图形属性
    % xlabel('x');
    % ylabel('y');
    R2=1 - (sum((y_fit- y).^2) / sum((y - mean(y)).^2));
    title( strcat("R^2=",num2str(R2)) )
%     title('Scatter Density Plot');
    box on;
    grid on;
    hold off;
catch
    warning('error')
end
end

