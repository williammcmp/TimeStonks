function naiveModel (data, figureTitle)
    % naiveModel - Fits and validates a naive model to the provided data.
    %
    % This function fits a naive model to the input time series data. The naive
    % model forecasts each step as equal to the previous value. It also calculates
    % residuals, constructs prediction intervals, and performs validation tests
    % to assess the quality of the model.
    %
    % Syntax:
    %   naiveModel(data, figureTitle)
    %
    % Inputs:
    %   data - The time series data to which the naive model will be applied.
    %   figureTitle - The title for the figure and plots.
    %
    % Example:
    %   naiveModel(data, 'Column 2 Data')
    
    % naive model forecasting
    n = length(data);

    % Calculating Residuals
    e = zeros(n, 1); % Residuals

    for i = 2:n % need to keep e(1) = 0
        e(i) = data(i) - data(i - 1); % e(i) = x_i - x_(i-1)
    end

    % Calculting the fitted vales
    data_fitted = zeros(n, 1); % Fitted values 

    data_fitted(1) = data(1); % special case for the first fitted value

    for i = 2:n % need to keep fitted(1) = data(1)
        data_fitted(i) = data(i-1); % Calcuating fitted values
    end

    % Constructing the 95% prediction intervals for 20 steps ahead  
    p = 20; % steps ahead
    data_forecast = zeros(p, 1); % predicited values
    err = zeros(p, 1); % upper bound error

    % Calculate the standard deviation of residuals
    s = std(e); 

    % loop over each step ahead - not needed for this model
    for i = 1:p
         data_forecast(i) = data(n); % calculating forecast values
         err(i) = 1.96*s*sqrt(i); % calculating upper error bound
    end 

    % Plot the time series, fitted, forecast values, 95% prediction intervals for 20 steps ahead.
    fig = figure;
    set(fig, 'Name', " Naive Forecast of " + figureTitle, 'Position', [10, 10, 1100, 900]);

    % Time series data
    h1 = plot(data); 
    hold on

    % Fitted values
    h2 = plot(1:n, data_fitted, 'LineWidth', 2); 

    % Forecasted values
    h3 = plot(n + 1:n + p, data_forecast, 'b', 'LineWidth', 1);

    % 95% prediction interval
    h4 = plot(n + 1:n + p, data_forecast + err,'r:', 'LineWidth', 2); % Upper error bound
    plot(n + 1:n + p, data_forecast - err,'r:', 'LineWidth', 2); % Lower error bound


    legend([h1 h2 h3 h4],figureTitle, 'Fitted', 'Forecast - 20 steps ahead', '95% CI', 'Location', 'NorthWest');
    title(['Fitted naive model to ' + figureTitle])

    m = round(log(n)); % lags of the dataset

    %  --- Validating Tests ---
    % Ljung-Box test    - ACF of residuals is simular to the ACF of a white noise process up-to lag m
    % Shapiro-Wilk test - Normality of the residuals
    % Two Sided test    - Mean of the residuals is significantly different from zero.
    %  ---                   ---

    disp("Validation of the naive model to " + figureTitle)

    % Ljung-Box test
    [h,p] = lbqtest(e, 'Lags', m, 'DOF', m); % 0 parameters were estimated

    if p > 0.05
        disp("Ljung-Box test p-value = " + p + " - ACF of the residuals is NOT significantly different from the ACF of a white noise process")
    else
        disp("Ljung-Box test p-value = " + p + " - ACF of the residuals IS significantly different from the ACF of a white noise process")
    end 

    % Shapiro-Wilk test
    [h,p] = swtest(e);

    if p > 0.05
        disp("Shapiro-Wilk test p-value = " + p + " - distribution ofresiduals are not significantly different from normal.")
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