function scatter_density_plot(x, y)
nanindx = isnan(x);
nanindy = isnan(y);
nanindx(nanindy == 1) = 1;
out_ind = nanindx;
x(out_ind) = [];
y(out_ind) = [];
% 绘制散点密度图
scatterhist(x, y, 'Group',2,'Kernel', 'on', 'Location', 'SouthEast', 'Direction', 'out',  'MarkerSize', 3);
hold on;

% 计算相关系数
r = corrcoef(x, y);
title(num2str(r(2)))
% 绘制线性拟合线
p = polyfit(x, y, 1);
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(p, x_fit);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);

text(0.05, 0.95, ['y = ' num2str(p(1)) 'x + ' num2str(p(2))], 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 12);
% 设置图形属性
xlabel('x');
ylabel('y');
% title('Scatter Density Plot');
box on;
grid on;
hold off;
end
