clear; 
close all;

% Replace this with your relative path
folderPath = 'E:\Users\William\Uni\Swinburne OneDrive\OneDrive - Swinburne University\Classes\2023 S2\MTH20016\Assigment shit\Second Assigment - Stonks\TimeStonks'; 

% Loads dta from text file
% Change this for you exact file number (all are included in the data folder)
data = loadText('data/F12.txt', [1, 2, 3, 4]);

% Unknown Process 1
process1 = data(:,1);

% Unknown Process 2
process2 = data(:,2);

% Unknown Process 3
process3 = data(:,3);

% known MA(1) Process
MA1process = data(:,4);

% The year of gold that you have been assigned
year = 2008;

% Loads data from excel file
% Needs the absloute path to the excel file (avoids edge cases - sorry)
gold = loadExcel("E:\Users\William\Uni\Swinburne OneDrive\OneDrive - Swinburne University\Classes\2023 S2\MTH20016\Assigment shit\Second Assigment - Stonks\TimeStonks\data\Historic-Gold-Prices.xlsx", year);


% Plot each of the colums of data to establish what process to model with
initalPlots(process1, "Column 1 Time Series Data")
initalPlots(process2, "Column 2 Time Series Data")
initalPlots(process3, "Column 3 Time Series Data")
initalPlots(MA1process, "Column 4 - Time Series Data - MA(1) process")
