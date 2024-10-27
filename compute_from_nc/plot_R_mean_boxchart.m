clc
clear

figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
set(groot, 'DefaultLineLineWidth', 0.5);
set(groot, 'DefaultAxesFontName', 'Times New Roman');
set(groot, 'DefaultAxesFontSize', 25);
set(groot, 'DefaultTextFontName', 'Times New Roman');
tiledlayout(6,5,"TileSpacing","tight")
for d = 1:6
    if d == 1
        datastr = 'PWVSH';
    elseif d == 2
        datastr = 'WVSH';
    elseif d == 3
        datastr = 'TmSH';
    elseif d == 4
        datastr = 'ZTDSH';
    elseif d == 5
        datastr = 'ZHDSH';
    elseif d == 6
        datastr = 'ZWDSH';
    end

    R_file = [datastr,'_R_year_mean.mat'];
    Data = load(R_file);
    data = Data.([datastr,'_R_year_mean']);
    clear Data

    nexttile([1,4])
%     data = rmoutliers(data,'median');
    colormap("hsv")
    colorb = [
        0.2, 0.4, 0.6;  % Deeper blue
        0.4, 0.5, 0.4;  % Darker green
        0.6, 0.5, 0.4;  % Dark beige
        0.5, 0.5, 0.7;  % Dark lavender
        0.4, 0.4, 0.5;  % Dark grayish blue
        0.5, 0.4, 0.4;  % Deep muted rose
        ];
    colors = [
        0.4, 0.6, 0.8;  % Medium blue
        0.6, 0.7, 0.6;  % Soft green
        0.8, 0.7, 0.6;  % Warm beige
        0.7, 0.7, 0.9;  % Soft lavender
        0.6, 0.6, 0.7;  % Grayish blue
        0.7, 0.6, 0.6;  % Muted rose
        ];
    hold on;

    b = boxchart(data, 'BoxFaceColor', colorb(d, :),'MarkerColor',colorb(d, :));
    b.JitterOutliers = 'on';
    b.MarkerStyle = '.';
    b.MarkerSize  = 0.009;

    box on
    text(0.01, 0.95, datastr, 'Units', 'normalized', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
        'FontSize',15,'FontWeight','bold');
    if d == 3
        ylabel('R^2','FontWeight','bold')
    end
    set(gca, TickLength = [0.002, 0])
    ax = gca;
    yticks = ax.YTick;
    ax.YTickLabel = arrayfun(@(y) sprintf('%.4f', y), yticks, 'UniformOutput', false);
    if d ~=6
        set(gca, 'XTick' ,[])
    else
        set(gca,'XTickLabel',2013:2022)
        xlabel('Year')
    end

    nexttile([1,1])
    data = reshape(data,1,[]);
    data(isinf(data)) = [];
    data = rmoutliers(data);

    h = histfit(data, 50, 'normal');
    h(1).FaceColor = colors(d, :);
    h(1).EdgeColor = [1,1,1];
    mu = mean(data);
    sigma = std(data);
    hold on;
    xline(mu, '--r', 'LineWidth', 2);
    text(mu, max(ylim)*0.9, sprintf('Mean:%.4f', mu),    'Color', 'r', 'FontSize', 25, 'HorizontalAlignment', 'right');
    text(mu, max(ylim)*0.65, sprintf('STD :%.4f', sigma), 'Color', 'b', 'FontSize', 25, 'HorizontalAlignment', 'right');

    set(gca, 'YAxisLocation','right');
    ax = gca;
    yticks = ax.YTick;
    newYTicks = yticks * 0.0001;
    ax.YTick = yticks;
    ax.YTickLabel = arrayfun(@(v) sprintf('%.2f', v), newYTicks, 'UniformOutput', false);

    xlim([-inf,1])
    if d == 3
        ylabel('Number(10^4)','FontWeight','bold')
    end
    if d ==6
        xlabel('R^2')
    end
    hold off;


end