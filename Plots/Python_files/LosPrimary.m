% Create data using a cell array to handle mixed data types (numbers and strings)
% DATA: Participant Number,Display,THD,TLD
hdg = {
    1,'NCW',1,1;
    2,'NCW',4,4;
    3,'NCW',4,0;
    4,'NCW',0,2;
    5,'NCW',2,2;
    6,'SSD',5,2;
    7,'SSD',4,6;
    8,'SSD',1,3;
    9,'SSD',6,4;
    10,'SSD',7,3;
    11,'NCW',5,2;
    12,'NCW',2,4;
    13,'NCW',3,2;
    14,'NCW',3,4;
    15,'SSD',3,4;
    16,'SSD',4,3;
    17,'SSD',2,3;
    18,'SSD',3,3;
    19,'NCW',6,5;
    20,'NCW',4,2;
    21,'NCW',4,1;
    22,'NCW',3,3;
    23,'SSD',3,4;
    24,'SSD',2,4;
    25,'SSD',4,2;
    26,'SSD',4,4
};

spd = {
    1,'NCW',1,0;
    2,'NCW',0,0;
    3,'NCW',0,0;
    4,'NCW',0,0;
    5,'NCW',0,0;
    6,'SSD',0,0;
    7,'SSD',0,0;
    8,'SSD',1,0;
    9,'SSD',0,0;
    10,'SSD',0,0;
    11,'NCW',0,0;
    12,'NCW',0,0;
    13,'NCW',0,0;
    14,'NCW',0,0;
    15,'SSD',1,3;
    16,'SSD',2,3;
    17,'SSD',2,1;
    18,'SSD',1,3;
    19,'NCW',0,0;
    20,'NCW',0,0;
    21,'NCW',0,0;
    22,'NCW',0,0;
    23,'SSD',1,1;
    24,'SSD',2,1;
    25,'SSD',2,1;
    26,'SSD',2,3
};


% Extract columns 
% (Note: MATLAB indexing starts at 1, so column 2 is x_labels, 3 is y1, 4 is y2)
hdg_systems = hdg(:, 2);
labels = {'SSD', 'NCW'};
yhdgH = cell2mat(hdg(:, 3)); % Convert the numeric cell column to a standard matrix
yhdgL = cell2mat(hdg(:, 4)); 

spd_systems = spd(:, 2);
yspdH = cell2mat(spd(:, 3)); % Convert the numeric cell column to a standard matrix
yspdL = cell2mat(spd(:, 4)); 

% Add all values
ySSDh = 0; yNCWh = 0; ySSDl= 0; yNCWl = 0;
for i = 1:length(hdg_systems)
    if hdg_systems(i) == "SSD"
        ySSDh = ySSDh + yhdgH(i);
        ySSDl = ySSDl + yhdgL(i);
    elseif hdg_systems(i) == "NCW"
        yNCWh = yNCWh + yhdgH(i);
        yNCWl = yNCWl + yhdgL(i);
    end
    if spd_systems(i) == "SSD"
        ySSDh = ySSDh + yspdH(i);
        ySSDl = ySSDl + yspdL(i);
    elseif spd_systems(i) == "NCW"
        yNCWh = yNCWh + yspdH(i);
        yNCWl = yNCWl + yspdL(i);
    end
end


% Combine yH and yL into an N-by-2 matrix for the stacked bar chart
Y_combined = [ySSDl, ySSDh; 
              yNCWl, yNCWh];

% -----------------------------------------------------------

% Create the figure and plot bars in a stacked manner FOR NCW
figure;
b = bar(Y_combined, 'stacked');

% Now 'b' contains 2 objects (b(1) is the bottom stack, b(2) is the top stack)
b(1).FaceColor = '#FF6666'; % Light Red for TLD
b(2).FaceColor = '#ADD8E6'; % Light Blue for THD

% Set x-axis ticks, labels, and rotation
xticks(1:length(labels));
xticklabels(labels);
xtickangle(45);

% Add legend
legend('TLD', 'THD');