function meanModel (data, figureTitle)
    % calcuated mean model to the provided data

    % mean model forecasting
    n = length(data);

    % Estimate the parameters
    mu = mean(data);

    % Calculating Residuals
    e = zeros(n,1); % Residuals

    for i = 1:n
        e(i) = data(i) - mu; % observed - fitted
    end

    % Calculting the fitted vales
    data_fitted = zeros(n, 1); % Fitted values 

    for i = 1:n
        data_fitted(i) = mu; % Calcuating fitted values
    end

    % Constructing the 95% prediction intervals for 20 steps ahead - sigma is unknown    
    p = 20; % steps ahead
    data_forecast = zeros(p, 1); % predicited values
    err = zeros(p, 1); % upper bound error

    % Calculate the standard deviation of residuals
    s = std(e); 

    % Calculate the quantiles - df = n - 1
    t = icdf('T', 0.975, n-1); 

    % loop over each step ahead - not needed for this model (Forecasted values are constant)
    for i = 1:p
        data_forecast(i) = mu; % calculating forecast values
        err(i) = t*s*sqrt(1+1/n); % calculating upper error bound
    end 

    % Plot the time series, fitted, forecast values, 95% prediction intervals for 20 steps ahead.
    fig = figure;
    set(fig, 'Name', figureTitle, 'Position', [10, 10, 1100, 900]);

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


    legend([h1 h2 h3 h4],figureTitle, 'Fitted', 'Forecast', '95% CI', 'Location', 'NorthWest');
    title(['Fitted mean model to ' + figureTitle])

    % Validation of the model

    m = round(log(n)); % lags of the dataset

    %  --- Validating Tests ---
    % Ljung-Box test    - ACF of residuals is simular to the ACF of a white noise process up-to lag m
    % Shapiro-Wilk test - Normality of the residuals
    % Two Sided test    - Mean of the residuals is significantly different from zero.
    %  ---                   ---

    disp("Validation of the Mean model to " + figureTitle)

    % Ljung-Box test
    [h,p] = lbqtest(e, 'Lags', m, 'DOF', m-1 ); % 1 parameter was estimated (mu)

    disp ("Ljung-Box test p-value = " + p)
    if p > 0.05
        disp("The residuals from fitting the Mean Model to " + figureTitle + " is not significantly different from a white noise process")
    else
        disp("The residuals from fitting the Mean Model to " + figureTitle + " is significantly different from a white noise process")
    end 

    % Shapiro-Wilk test
    [h,p] = swtest(e);

    disp ("Shapiro-Wilk test p-value = " + p)
    if p > 0.05
        disp("The distribution of the residuals from fitting the Mean Model to " + figureTitle + " is not significantly different from normal.")
    else
        disp("The distribution of the residuals from fitting the Mean Model to " + figureTitle + " is significantly different from normal")
    end 

    % Two Sided test
    p = 2 * (1 - cdf('T', abs(mean(e) * sqrt(n) / std(e)), length(e)-1) ); % df = n - 1

    disp ("Two Sided test p-value = " + p)
    if p > 0.05
        disp("The mean of the residuals from fitting the Mean Model to " + figureTitle + " is not significantly different from zero")
    else
        disp("The mean of the residuals from fitting the Mean Model to " + figureTitle + " is significantly different from zero")
    end 


end