function AR1Model (data, figureTitle)
    % AR1Model - Fits and validates an AR(1) model to the provided data.
    %
    % This function fits an AR(1) model to the input time series data, performs
    % parameter estimation, calculates residuals, constructs prediction intervals,
    % and conducts validation tests to assess the quality of the model.
    %
    % Syntax:
    %   AR1Model(data, figureTitle)
    %
    % Inputs:
    %   data - The time series data to which the AR(1) model will be applied.
    %   figureTitle - The title for the figure and plots.
    %
    % Example:
    %   AR1Model(data, 'Column 3 Data')

    % AR(1) model forecasting
    n = length(data);

    % Estimate the parameters - 2 parms
    mu = mean(data); % Average

    % a = ACF of raw data at lag 1
    h = autocorr(data);
    a = h(2); % coefficent - a

    % Calculating Residuals
    e = zeros(n,1); % Residuals

    for i = 2:n % e(1) = 0
        e(i) = data(i) - mu - a * (data(i-1) - mu); % observed - fitted
    end

    % Calculting the fitted vales
    data_fitted = zeros(n, 1); % Fitted values 

    data_fitted(1) = data(1); 

    for i = 2:n % to keep fitted(1) = data(1)
        data_fitted(i) = mu * (1 - a) + a * data(i - 1); % Calculating fitted values
    end    

    % Constructing the 95% prediction intervals for 20 steps ahead  
    p = 20; % steps ahead
    lower = zeros(p,1); % Lower bound error
    upper = zeros(p,1); % upper bound error
    data_forecast = zeros(p, 1); % predicited values
 
    % Calculate the standard deviation of residuals
    s = std(e); 

    % loop over each step ahead
    for i=1:p
        lower(i) = mu + a^i * (data(n) - mu) - 1.96 * s * sqrt((1 - a^(2 * i)) / (1 - a^2));
        upper(i)= mu + a^i * (data(n) - mu) + 1.96 * s * sqrt((1 - a^(2 * i)) / (1 - a^2));
        data_forecast(i) = mu + a^i * (data(n) - mu);
    end

    % Plot the time series, fitted, forecast values, 95% prediction intervals for 20 steps ahead.
    fig = figure;
    set(fig, 'Name', " AR(1) Forecast of " + figureTitle, 'Position', [10, 10, 1100, 900]);

    % Time series data
    h1 = plot(data); 
    hold on

    % Fitted values
    h2 = plot(1:n, data_fitted, 'LineWidth', 2); 

    % Forecasted values
    h3 = plot(n + 1:n + p, data_forecast, 'b', 'LineWidth', 1);

    % 95% prediction interval
    h4 = plot(n + 1:n + p, upper,'r:', 'LineWidth', 2); % Upper error bound
    plot(n + 1:n + p, lower,'r:', 'LineWidth', 2); % Lower error bound


    legend([h1 h2 h3 h4],figureTitle, 'Fitted', 'Forecast - 20 steps ahead', '95% CI', 'Location', 'NorthWest');
    title(['Fitted AR(1) model to ' + figureTitle])

    % Validation of the model

    m = round(log(n)); % lags of the dataset

    %  --- Validating Tests ---
    % Ljung-Box test    - ACF of residuals is simular to the ACF of a white noise process up-to lag m
    % Shapiro-Wilk test - Normality of the residuals
    % Two Sided test    - Mean of the residuals is significantly different from zero.
    %  ---                   ---

    disp("Validation of the AR(1) model to " + figureTitle)

    % Ljung-Box test
    [h,p] = lbqtest(e, 'Lags', m, 'DOF', m-2 ); % 2 parameter was estimated (mu)

    if p > 0.05
        disp("Ljung-Box test p-value = " + p + " - ACF of the residuals is NOT significantly different from the ACF of a white noise process")
    else
        disp("Ljung-Box test p-value = " + p + " - ACF of the residuals IS significantly different from the ACF of a white noise process")
    end 

    % Shapiro-Wilk test
    [h,p] = swtest(e);

    if p > 0.05
        disp("Shapiro-Wilk test p-value = " + p + " - distribution of residuals are not significantly different from normal.")
    else
        disp("Shapiro-Wilk test p-value = " + p + " - distribution of residuals are significantly different from normal")
    end 

    % Two Sided test - using student T 
    p = 2 * (1 - cdf('T', abs(mean(e) * sqrt(n) / std(e)), length(e)-1) ); % df = n - 1

    if p > 0.05
        disp("Two Sided test p-value = " + p + " - residual mean is not significantly different from zero")
    else
        disp("Two Sided test p-value = " + p + " - residual mean is significantly different from zero")
    end 


end