# importing package
import matplotlib.pyplot as plt

# create data
x = [   [1,'NCW',0,0],
        [2,'NCW',0,0],
        [3,'NCW',0,0],
        [4,'NCW',0,0],
        [5,'NCW',0,0],
        [6,'SSD',0,0],
        [7,'SSD',0,0],
        [8,'SSD',0,0],
        [9,'SSD',0,0],
        [10,'SSD',0,0],
        [11,'NCW',0,0],
        [12,'NCW',0,0],
        [13,'NCW',0,0],
        [14,'NCW',0,0],
        [15,'SSD',0,0],
        [16,'SSD',0,0],
        [17,'SSD',0,0],
        [18,'SSD',0,0],
        [19,'NCW',0,0],
        [20,'NCW',0,0],
        [21,'NCW',0,0],
        [22,'NCW',0,0],
        [23,'SSD',0,0],
        [24,'SSD',0,0],
        [25,'SSD',0,0],
        [26,'SSD',0,0]
    ]

# plot bars in stack manner with column 2 as x and columns 3 and 4 as y
x_labels = [row[1] for row in x]
y1 = [row[2] for row in x]
y2 = [row[3] for row in x]
positions = list(range(len(x_labels)))

plt.bar(positions, y1, color='r', label='y1')
plt.bar(positions, y2, bottom=y1, color='b', label='y2')
plt.xticks(positions, x_labels, rotation=45)
plt.legend()
plt.tight_layout()
plt.show()