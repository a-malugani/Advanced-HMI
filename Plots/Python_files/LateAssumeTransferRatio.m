% Define the two files you uploaded
filenames = {'LateAssumeRatio.csv', 'LateTransferRatio.csv'};

% 1. Create ONE Figure to hold all 4 split violins
figure('Name', 'Combined Ratios', 'Color', 'w', 'Position', [100, 100, 900, 500]);
hold on;

% X-axis positions for the 4 split violins
% 1 and 2 for "Late Assume", 4 and 5 for "Late Transfer" (creates a visual gap at 3)
base_x_positions = [1, 2, 4, 5]; 

% Colors (RGB Triplets)
color_TLD = [0.4, 0.6, 0.8];  % Soft Blue
color_THD = [0.9, 0.4, 0.4];  % Soft Red

max_violin_width = 0.35; % Controls how wide the violins can get

% 2. Loop through both files and plot them on the same axis
for f_idx = 1:2
    % Read the data
    data = readtable(filenames{f_idx});
    
    % Extract the data into the 4 cases based on 'Display'
    ncw_mask = strcmp(data.Display, 'NCW');
    ssd_mask = strcmp(data.Display, 'SSD');
    
    NCW_TLD = data.TLD(ncw_mask);
    NCW_THD = data.THD(ncw_mask);
    SSD_TLD = data.TLD(ssd_mask);
    SSD_THD = data.THD(ssd_mask);
    
    % Grouping: {NCW_TLD, NCW_THD, SSD_TLD, SSD_THD}
    dataList = {NCW_TLD, NCW_THD, SSD_TLD, SSD_THD};
    
    % Determine exact X positions for this specific file's data
    if f_idx == 1
        x_pos = [base_x_positions(1), base_x_positions(1), base_x_positions(2), base_x_positions(2)];
    else
        x_pos = [base_x_positions(3), base_x_positions(3), base_x_positions(4), base_x_positions(4)];
    end
    
    sides = [-1, 1, -1, 1]; % -1 (left) for TLD, 1 (right) for THD
    colors = {color_TLD, color_THD, color_TLD, color_THD};
    
    % 3. Calculate density and draw shapes for the current file
    for i = 1:4
        y = dataList{i};
        
        % Check if all values are identical (e.g. all zeros) to prevent ksdensity errors
        if range(y) == 0
            % Create a manual tiny spread if all values are exactly the same
            xi = linspace(y(1) - 0.05, y(1) + 0.05, 100);
            f = normpdf(xi, y(1), 0.01);
        else
            % Calculate normal kernel density estimation
            [f, xi] = ksdensity(y);
        end
        
        % Normalize the density to the maximum width desired
        f = max_violin_width * (f / max(f));
        
        % Create the X and Y coordinates for the polygon (patch)
        if sides(i) == -1 % Left side (TLD)
            x_patch = [x_pos(i) - f, fliplr(x_pos(i) * ones(1, length(f)))];
        else              % Right side (THD)
            x_patch = [x_pos(i) + f, fliplr(x_pos(i) * ones(1, length(f)))];
        end
        y_patch = [xi, fliplr(xi)];
        
        % Draw the half-violin
        patch(x_patch, y_patch, colors{i}, 'FaceAlpha', 0.6, 'EdgeColor', 'w', 'LineWidth', 1.5);
        
        % Add semi-transparent scatter points for the actual raw data
        jitter = sides(i) * (rand(size(y)) * 0.1 + 0.05);
        scatter(x_pos(i) + jitter, y, 15, 'k', 'filled', 'MarkerFaceAlpha', 0.3);
        
        % Add horizontal line for the Mean of each group
        plot([x_pos(i), x_pos(i) + sides(i)*max_violin_width], ...
             [mean(y), mean(y)], 'k-', 'LineWidth', 2);
    end
end

% 4. Formatting and Aesthetics for the combined chart
set(gca, 'FontSize', 17);
xticks(base_x_positions);
xticklabels({'    Assume NCW', '    Assume SSD', '    Transfer NCW', '    Transfer SSD'});
xlim([0.2, 5.8]);
ylabel('Ratio', 'FontWeight', 'bold', 'FontSize', 17);
%title('Late Assume and Late Transfer Ratios (TLD vs THD)', 'FontWeight', 'bold');
grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5);

% Draw a subtle vertical line to visually separate the Assume and Transfer groups
plot([3, 3], ylim, 'k--', 'Color', [0.7 0.7 0.7]);

% 5. Custom Legend using dummy plots
h1 = plot(NaN, NaN, 's', 'MarkerFaceColor', color_TLD, 'MarkerEdgeColor', 'none', 'MarkerSize', 10);
h2 = plot(NaN, NaN, 's', 'MarkerFaceColor', color_THD, 'MarkerEdgeColor', 'none', 'MarkerSize', 10);
legend([h1, h2], {'TLD (Left)', 'THD (Right)'}, 'Location', 'northeast', 'FontSize', 15);

hold off;