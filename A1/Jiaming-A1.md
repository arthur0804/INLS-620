# INLS 620 Assignment 1
### Jiaming Qu {jiaming AT ad DOT unc DOT edu}
### 1. Dataset Description
1.1 URL: *https://www.kaggle.com/drgilermo/nba-players-stats* 

1.2 This dataset is retrieved from Kaggle, a website where offers great datasets for data science. The dataset was scraped from *https://www.basketball-reference.com/* and uploaded by other users. The dataset was created for data analytics, and it is now free to download. 

### 2. Dataset Overview
2.1 The link above offers three CSV files, and the one used for this course is *Seasons_Stats.csv*. It has 24.7k lines and 53 columns, which are detailed statistics of every NBA players in each season from 1950 to 2017.

2.2 The abstract model for this dataset is tabular data. Each line indicates the year and a player, followed by his detailed statistics in that corresponding season. 

2.3 Just like other tabular data, the serialization format of this dataset is comma-separated values (CSV). The dataset looks like: 

| Index   | Year | Player | Position | Team   | Stats   | ...  | Stats   |
| ------- | ---- | ------ | -------- | ------ | ------- | ---- | ------- |
| Numeric | Date | String | String   | String | Numeric | ...  | Numeric |

in which

| Stats   | ...  | Stats   |
| ------- | ---- | ------- |
| Numeric | ...  | Numeric |

represents 47 columns of all kinds of detailed game statistics.

### 3. Preliminary Ideas
3.1 Convert the CSV file to JSON or XML format for parsing. 

3.2 The data of players and teams could be linked by specifying which team the player was in. 

3.3 The data of players could also be linked by specifying which players played in the same team.