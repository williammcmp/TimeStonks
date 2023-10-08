clear; 
close all;

folderPath = '/Users/william/Library/CloudStorage/OneDrive-SwinburneUniversity/Classes/2023 S2/MTH20016/Assigment shit/Second Assigment - Stonks/TimeStonks'; % Change this for the laptop

data = loadText('data/F12.txt', [1, 2, 3]);


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

% gessing parameters - based on model
mu=mean(y);

% finidng residuals - based on model
e = y-mu;

% validation of model
m = round(log(length(y)));

% Running the Tests
[h, plbq] = lbqtest(e, "Lags", m , "DOF", m-1); % test for white-noice of residuals
[h, psw] = swtest(e); % test for normality of residuals
[h, ptt] = ttest2(e,0); % test for residual mean not different from 0


% Forecasting
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