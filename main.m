clear; 
close all;

% Replace this with your relative path
folderPath = '/Users/william/Library/CloudStorage/OneDrive-SwinburneUniversity/Classes/2023 S2/MTH20016/Assigment shit/Second Assigment - Stonks/TimeStonks'; % Change this for the laptop

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
% Needs the absloute path to the excel file (avoids edge cases)
gold = loadExcel("/Users/william/Library/CloudStorage/OneDrive-SwinburneUniversity/Classes/2023 S2/MTH20016/Assigment shit/Second Assigment - Stonks/TimeStonks/data/Historic-Gold-Prices.xlsx", year);


% Mean forecasting model with column 1
y = data(:,1);

fig = figure;
set(fig, 'Name', 'Example Mean Forecasting', 'Position', [10, 10, 1100, 900]);

subplot(4,1,1)
plot(y,'-')
xlim([1, 201]);
title('Time Series Data Column 1')

subplot(4,1,2)
autocorr(y, 10)
ylim([-1,1])
title('ACF')

subplot(4,1,3)
parcorr(y,10);
ylim([-1,1])
title('PACF')

% gessing parameters - based on model (will create seperate function for this)
mu=mean(y);

% finidng residuals - based on model (will create seperate function for this)
e = y-mu;

% getting a approiate number of Lags, round to the neaiest interger
m = round(log(length(y))); 

% validation of model viw the tests
[h, plbq] = lbqtest(e, "Lags", m , "DOF", m-1); % test for white-noice of residuals
[h, psw] = swtest(e); % test for normality of residuals
[h, ptt] = ttest2(e,0); % test for residual mean not different from 0


% Forecasting - based mean model (will create seperate function for this)
p=10;
yf=zeros(p,1);
err=zeros(p,1);
s=std(e);
t=icdf('T',0.975,length(y)-1);
for i=1:p
    yf(i)=mu;
    err(i)=t*s*sqrt(1+1/length(y));
end

subplot(4,1,4)
h1 = plot(y,'o-');
hold on
h2 = plot(length(y)+1:length(y)+10,yf,'b','LineWidth',1);
h3 = plot(length(y)+1:length(y)+10,yf + err,'r:','LineWidth',2);
plot(length(y)+1:length(y)+10,yf - err,'r:','LineWidth',2);
legend([h1 h2 h3],'Observed','Forecast','95% Confidence Interval','Location','SouthWest');
xlim([1, 220]);
title("Forecasts and 95% prediction intervals - Mean Model")