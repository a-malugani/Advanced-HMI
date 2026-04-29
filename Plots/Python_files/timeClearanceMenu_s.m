% 1. Read the data from the CSV file
opts = detectImportOptions('timeClearanceMenu_s.csv');
data = readtable('timeClearanceMenu_s.csv', opts);

% 2. Extract the data into the 4 cases based on 'Display' and variables
ncw_mask = strcmp(data.Display, 'NCW');
ssd_mask = strcmp(data.Display, 'SSD');

NCW_TLD = data.TLD(ncw_mask);
NCW_THD = data.THD(ncw_mask);
SSD_TLD = data.TLD(ssd_mask);
SSD_THD = data.THD(ssd_mask);

% 3. Setup groups for the loop
% Grouping: {NCW_TLD, NCW_THD, SSD_TLD, SSD_THD}
dataList = {NCW_TLD, NCW_THD, SSD_TLD, SSD_THD};

% X-axis positions: 1 for NCW, 2 for SSD
x_positions = [1, 1, 2, 2]; 

% Plot sides: -1 (left side) for TLD, 1 (right side) for THD
sides = [-1, 1, -1, 1]; 

% Colors (RGB Triplets)
color_TLD = [0.4, 0.6, 0.8];  % Soft Blue
color_THD = [0.9, 0.4, 0.4];  % Soft Red
colors = {color_TLD, color_THD, color_TLD, color_THD};

% 4. Create the Figure
figure('Name', 'Stacked Violin Plots', 'Color', 'w', 'Position', [100, 100, 800, 500]);
hold on;

% 5. Loop through the 4 cases to calculate density and draw shapes
max_violin_width = 0.35; % Adjust this to make violins wider or narrower

for i = 1:4
    y = dataList{i};
    
    % Calculate kernel density estimation
    % xi contains the Y-axis values, f contains the density (width)
    [f, xi] = ksdensity(y);
    
    % Normalize the density to the maximum width desired
    f = max_violin_width * (f / max(f));
    
    % Create the X and Y coordinates for the polygon (patch)
    if sides(i) == -1 % Left side (TLD)
        x_patch = [x_positions(i) - f, fliplr(x_positions(i) * ones(1, length(f)))];
    else              % Right side (THD)
        x_patch = [x_positions(i) + f, fliplr(x_positions(i) * ones(1, length(f)))];
    end
    y_patch = [xi, fliplr(xi)];
    
    % Draw the half-violin
    patch(x_patch, y_patch, colors{i}, 'FaceAlpha', 0.6, 'EdgeColor', 'w', 'LineWidth', 1.5);
    
    % Optional: Add scatter points for the actual raw data
    % We add a slight random "jitter" to the X position so points don't overlap completely
    jitter = sides(i) * (rand(size(y)) * 0.1 + 0.05);
    scatter(x_positions(i) + jitter, y, 15, 'k', 'filled', 'MarkerFaceAlpha', 0.3);
    
    % Add horizontal lines for the Mean of each group
    plot([x_positions(i), x_positions(i) + sides(i)*max_violin_width], ...
         [mean(y), mean(y)], 'k-', 'LineWidth', 2);
end

% 6. Formatting and Aesthetics
set(gca, 'FontSize', 17);
xticks([1, 2]);
xticklabels({'NCW', 'SSD'});
xlim([0.2, 2.8]);
ylabel('Time in the Clearance Menu (s)', 'FontWeight', 'bold', 'FontSize', 17);
%title('Conflict Detection Time by Display (TLD vs THD)', 'FontWeight', 'bold');
grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5);

% 7. Custom Legend
% Since we used patches in a loop, the cleanest way to do a legend is with dummy plots
h1 = plot(NaN, NaN, 's', 'MarkerFaceColor', color_TLD, 'MarkerEdgeColor', 'none', 'MarkerSize', 10);
h2 = plot(NaN, NaN, 's', 'MarkerFaceColor', color_THD, 'MarkerEdgeColor', 'none', 'MarkerSize', 10);
legend([h1, h2], {'TLD (Left)', 'THD (Right)'}, 'Location', 'best','FontSize', 15);

hold off;