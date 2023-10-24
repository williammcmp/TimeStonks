function meanModel (data, figureTitle)
    % meanModel - Calculates and visualizes a mean model for the provided data.
    %
    % This function calculates the mean model for the input data, including
    % forecasting, residuals, and the construction of 95% prediction intervals.
    % It also performs validation tests to assess the quality of the model.
    %
    % Syntax:
    %   meanModel(data, figureTitle)
    %
    % Inputs:
    %   data - The time series data to which the mean model will be applied.
    %   figureTitle - The title for the figure and plots.
    %
    % Example:
    %   meanModel(data, 'Column 1 Data')

    
    % Estimate the parameters - 1 parm
    mu = mean(data); % average
    disp(mu)
    
    % mean model forecasting
    n = length(data);

    % Calculating Residuals
    e = zeros(n,1); % Residuals

    for i = 1:n
        e(i) = data(i) - mu; % observed - fitted
    end

    % Calculting the fitted vales
    data_fitted = zeros(n, 1); % Fitted values 

    for i = 1:n
        data_fitted(i) = mu; % Calculating fitted values
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
    set(fig, 'Name', " Mean Forecast of " + figureTitle, 'Position', [10, 10, 1100, 900]);

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
    title(['Fitted mean model to ' + figureTitle])

    % Validation of the model

    
    %  --- Validating Tests ---
    % Ljung-Box test    - ACF of residuals is simular to the ACF of a white noise process up-to lag m
    % Shapiro-Wilk test - Normality of the residuals
    % Two Sided test    - Mean of the residuals is significantly different from zero.
    %  ---                   ---
    
    disp("Validation of the Mean model to " + figureTitle)

    m = round(log(n)); % lags of the dataset
    
    % Ljung-Box test
    [h,p] = lbqtest(e, 'Lags', m, 'DOF', m-1 ); % 1 parameter was estimated (mu)

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

    % plotting the ACF and histogram of the residuals (not needed for assignment)
    m=floor(log(n));
    fig = figure
    set(fig, 'Name', "Histogram and ACF of residuals from Mean Forecast of " + figureTitle);
    subplot(2,1,1)
    autocorr(e,m)
    subplot(2,1,2)
    h = histogram(e);
    hold on
    h.Normalization = 'pdf';
    xx=-5:0.01:5;
    yy=pdf('Normal',xx,mean(e),std(e));
    plot(xx,yy)
    title('Histogram of residuals')

end