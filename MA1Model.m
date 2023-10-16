function MA1Model (data, figureTitle)
    % MA1Model - Fit an MA(1) model to a time series data set and visualize the results.
    %
    %   MA1Model(data, figureTitle) fits an MA(1) model to the provided time series data and
    %   generates plots to visualize the model, including the 95% prediction intervals for 20 steps
    %   ahead. The function estimates the model parameters and validates the model.
    %
    %   Parameters:
    %     data - The time series data to be analyzed using an MA(1) model.
    %     figureTitle - A title for the generated plots and figures.
    %
    %   The MA(1) model is defined as: x_i = c + a * n_(i-1) + n_i, where 'a' is the parameter to be
    %   estimated and 'c' is the mean of the data. The function uses conditional least squares to
    %   estimate the 'a' parameter.
    %
    %   The function generates a plot showing the MA(1) model forecast, 95% prediction intervals, and
    %   the original time series data. It also performs model validation using the Ljung-Box test,
    %   Shapiro-Wilk test, and Two-Sided test.
    %
    %   Example:
    %     data = randn(100, 1); % Simulated MA(1) data
    %     figureTitle = "Example MA(1) Model";
    %     MA1Model(data, figureTitle);

    % will plot the S(a) vs a plot used to get best guess of a

    % MA(1) model forecasting
    n = length(data);

    % x_i = c + a * n_(i-1) + n_i
    % Estimate the parameters - 2 parms
    mu = mean(data); % average (contant C in model)
    a = bestGuessA(data); % use conditional least squares to find a

    % Calculating Residuals
    e = zeros(n,1); % Residuals

    for i = 2:n % e(1) = 0
        e(i) = (data(i) - (mu + a * e(i - 1))); % observed - fitted
    end

    % Constructing the 95% prediction intervals for 20 steps ahead  
    p = 20; % steps ahead
    lower = zeros(p,1); % Lower bound error
    upper = zeros(p,1); % upper bound error
    data_forecast = zeros(p, 1); % predicited values
 
    % Calculate the standard deviation of residuals
    s = std(e); 

    % The first values
    data_forecast(1) = mu + a * e(n);
    lower(1) = mu - 1.96 * s + a * e(n);
    upper(1) = mu + 1.96 * s + a * e(n);
    
    % loop over each step ahead
    for i=2:p
        lower(i) = mu - 1.96 * s * sqrt(1 - a^2);
        upper(i)= mu + 1.96 * s * sqrt(1 - a^2);
        data_forecast(i) = mu;
    end

    % Plot the time series, fitted, forecast values, 95% prediction intervals for 20 steps ahead.
    fig = figure;
    set(fig, 'Name', " MA(1) Forecast of " + figureTitle, 'Position', [10, 10, 1100, 900]);

    % Time series data
    h1 = plot(data); 
    hold on

    % Forecasted values
    h3 = plot(n + 1:n + p, data_forecast, 'b', 'LineWidth', 1);

    % 95% prediction interval
    h4 = plot(n + 1:n + p, upper,'r:', 'LineWidth', 2); % Upper error bound
    plot(n + 1:n + p, lower,'r:', 'LineWidth', 2); % Lower error bound


    legend([h1 h3 h4],figureTitle, 'Forecast - 20 steps ahead', '95% CI', 'Location', 'NorthWest');
    title(['Fitted MA(1) model to ' + figureTitle])

    % Validation of the model

    m = floor(log(n)); % lags of the dataset

    %  --- Validating Tests ---
    % Ljung-Box test    - ACF of residuals is simular to the ACF of a white noise process up-to lag m
    % Shapiro-Wilk test - Normality of the residuals
    % Two Sided test    - Mean of the residuals is significantly different from zero.
    %  ---                   ---

    disp("Validation of the MA(1) model to " + figureTitle)

    % Ljung-Box test
    [h,p] = lbqtest(e, 'Lags', m, 'DOF', m-2 ); % 2 parameter was estimated (mu, a)

    if p > 0.05
        disp("Ljung-Box test p-value = " + p + " - residuals are not significantly different from a white noise process")
    else
        disp("Ljung-Box test p-value = " + p + " - residuals are significantly different from a white noise process")
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


function bestA = bestGuessA(data)
    % bestGuessA - Estimate the best value of the parameter 'a' for an MA(1) process.
    %
    %   bestA = bestGuessA(data) estimates the best value of 'a' for a given MA(1) process.
    %   It searches for the 'a' value that minimizes the sum of squared residuals.
    %
    %   Parameters:
    %     data - The time series data for which 'a' needs to be estimated.
    %
    %   Returns:
    %     bestA - The best estimated value of 'a' for the MA(1) process.
    %
    %   The function iterates through a range of 'a' values and calculates the sum
    %   of squared residuals for each 'a'. The 'a' value that minimizes this sum
    %   is considered the best estimate.
    %
    %   Example:
    %     data = randn(100, 1); % Simulated MA(1) data
    %     bestA = bestGuessA(data);
    %     disp(['Best estimated value of a: ' num2str(bestA)]);

    % Setting up the parameters
    bins = 100; % number of guesses of a - higher values will give more accurate result
    n = length(data);
    mu = mean(data);

    eSum = zeros(bins, 1); % Will store the sum for each guessed a value 
    aRange = linspace(-1, 1, bins); % Range of a values

    % Calculating the best sigma value
    for j = 1:length(aRange)
        a = aRange(j);
        e = zeros(n, 1); % an empty array for the residuals
        for i = 2:length(data)
            e(i) = (data(i) - (mu + a * e(i - 1)))^2; % calcuate the residual ^ 2
        end
        eSum(j) = sum(e); % sum the residuals^2
    end

    [eMin, index] = min(eSum); % find the min of the S(a)
    bestA = aRange(index); % the best gess for the a value

    % Plot a vs eSum
    fig = figure;
    set(fig, 'Name', "Estimating a for the MA(1) process", 'Position', [10, 10, 800, 500]);

    h1 = plot(aRange, eSum, 'DisplayName', "S(a)=\Sigma e^2"); % various vals of S(a) over a
    hold on
    h2 = plot(bestA, eMin, 'r*', 'DisplayName', "Best value of a = " + bestA); % the best a value
    legend();
    xlabel("a")
    ylabel("S(a)=\Sigma e^2")
    title(["Estimating a for MA(1) processe"]);
end