%  ------   Setup   ------
%    Loading data files
%  ------------------------
clear; 
close all;

% Replace this with your relative path
% folderPath = 'E:\Users\William\Uni\Swinburne OneDrive\OneDrive - Swinburne University\Classes\2023 S2\MTH20016\Assigment shit\Second Assigment - Stonks\TimeStonks'; % PC plath
folderPath = '/Users/william/Library/CloudStorage/OneDrive-SwinburneUniversity/Classes/2023 S2/MTH20016/Assigment shit/Second Assigment - Stonks/TimeStonks' % latop path

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
% gold = loadExcel("E:\Users\William\Uni\Swinburne OneDrive\OneDrive - Swinburne University\Classes\2023 S2\MTH20016\Assigment shit\Second Assigment - Stonks\TimeStonks\data\Historic-Gold-Prices.xlsx", year); % PC path
gold = loadExcel("/Users/william/Library/CloudStorage/OneDrive-SwinburneUniversity/Classes/2023 S2/MTH20016/Assigment shit/Second Assigment - Stonks/TimeStonks/data/Historic-Gold-Prices.xlsx", year); % laptop path



%  ------   Part 1   ------
%  Guess and fit the process
%  ------------------------

% Plots each of the colums of data to establish what process to model with - random walk, or an AR(1), or a white noise process (?)
% initalPlots(process1, "Column 1 Time Series Data") % white noise
% initalPlots(process2, "Column 2 Time Series Data") % random walk
% initalPlots(process3, "Column 3 Time Series Data") % AR(1) process

% --- What process to use??? ---
% white noise   ->  mean  model
% Random Walk   ->  naive model
% AR(1)         ->  AR(1) mdoel
% ---                        ---

% Each model function/script will output the validating tests allowing 
% you to know if the model is appropiate for use with the provided time-series.

% meanModel(process1, "Column 1 Data")

% naiveModel(process2, "Column 2 Data")

% AR1Model(process3, "Column 3 Data")


%  ------   Part 2   ------
%    Fit the MA(1) model
%  ------------------------

% initalPlots(MA1process, "Column 4 - Time Series Data - MA(1) process") % known to be a MA(1) process
% MA1Model(MA1process, "Column 4 Data"); % Will also plot the S(a) vs a to estimate params



%  ------   Part 3   ------
%         Gold Stonks
%  ------------------------

% Take the data for the first 100 days in the specified year and find an optimal ARIMA model. 
% Use the model to predict the price of gold for the next 20 days. 
% Compare your prediction with the actual data.

gold100 = gold.Price(1:100); % the first 100 days of gold prices

% initalPlots(gold100, "Price of Gold in 2008 - AUD (first 100 days)")
ARIMAModel(gold.Price, "2008 daily Gold Price")











