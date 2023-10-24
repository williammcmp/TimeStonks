function ARIMAModel (data, figureTitle)

    data100 = data(1:100);

    % Finds the best model
    [bestModel, p, d, q] = findBestModel(data100);

    % use the best model for forceasting and more...
    mdl = bestModel;
    disp(mdl)
    fit = estimate(mdl, data100);
    res=infer(fit,data100);
    forecastedValues = forecast(fit, 20, data100); % Calcualting forecasted values

    fig = figure;
    arimaType = "ARIAM (" + p + ", " + d + ", " + q + ")";
    tit = arimaType + " of " + figureTitle;
    set(fig, 'Name', tit, 'Position', [10, 10, 1100, 900]);

    subplot(3,1,1)
    plot(data, '-'); 
    title("Time series of " + figureTitle)
    
    subplot(3,1,2)
    % comparing fitted values
    h1 = plot(data100, '-');
    hold on
    h2 = plot(data100 - res, '-');
    h3 = plot([101:100+length(forecastedValues)], forecastedValues)

    legend([h1 h2, h3],figureTitle + " - first 100 Days", arimaType + ' - Fitted values', arimaType + ' - Forecasted values');
    title(['Fitted and forecast ' + arimaType + ' model to ' + figureTitle])

    subplot(3,1,3)
    % Comparing forecasted values
    h1 = plot(data(101:121), '-'); % Known futuer values
    hold on 
    h2 = plot(forecastedValues, '-');
    legend([h1 h2],figureTitle + " - Days 101 - 121", arimaType + ' - Forecasted values');
    title(['Forcecasting ' + arimaType + ' model 20 days ahead.'])
    

    % Validation of the model

    m = floor(log(100)); % lags of the dataset

    %  --- Validating Tests ---
    % Ljung-Box test    - ACF of residuals is simular to the ACF of a white noise process up-to lag m
    % Shapiro-Wilk test - Normality of the residuals
    % Two Sided test    - Mean of the residuals is significantly different from zero.
    %  ---                   ---

    disp("Validation of the " + arimaType + " model to " + figureTitle)

    % Ljung-Box test
    [h,p] = lbqtest(res, 'Lags', m, 'DOF', m-(p+d) );

    if p > 0.05
        disp("Ljung-Box test p-value = " + p + " - ACF of the residuals is NOT significantly different from the ACF of a white noise process")
    else
        disp("Ljung-Box test p-value = " + p + " - ACF of the residuals IS significantly different from the ACF of a white noise process")
    end 

    % Shapiro-Wilk test
    [h,p] = swtest(res);

    if p > 0.05
        disp("Shapiro-Wilk test p-value = " + p + " - distribution of residuals are not significantly different from normal.")
    else
        disp("Shapiro-Wilk test p-value = " + p + " - distribution of residuals are significantly different from normal")
    end 

    % Two Sided test - using student T 
    p = 2 * (1 - cdf('T', abs(mean(res) * sqrt(100) / std(res)), length(res)-1) ); % df = n - 1

    if p > 0.05
        disp("Two Sided test p-value = " + p + " - residual mean is not significantly different from zero")
    else
        disp("Two Sided test p-value = " + p + " - residual mean is significantly different from zero")
    end 

    % plotting the ACF and histogram of the residuals (not needed for assignment)
    m=floor(log(100));
    fig = figure;
    set(fig, 'Name', "Histogram and ACF of residuals from Mean Forecast of " + figureTitle);
    subplot(2,1,1)
    autocorr(res,m)
    subplot(2,1,2)
    h = histogram(res);
    hold on
    h.Normalization = 'pdf';
    xx=-5:0.01:5;
    yy=pdf('Normal',xx,mean(res),std(res));
    plot(xx,yy)
    title('Histogram of residuals')

end


function [bestModel, p, d, q] = findBestModel(data)
    % Set up to hold best values
    bestModel = [];
    minESum = Inf;
    bestD = 0;
    bestP = 0;
    bestQ = 0;

    % calcuate the ARIMA model over various values
    % Will take the smallest sum(residauls^2) as the best fitting model
    for d = 0:2
        for p = 1:4
            for q = 0:4
                % the try is here to catch any errors in the ARIMA modeling process
                % doc state that it can be unstable under certain conditions.
                try
                    if p+d < 4 % The number due to lags avaliable from the data set
                        % makes the ARIMA(p,d,q) model
                        mdl = arima('Constant', NaN, 'ARLags',[(1:p)],'MALags',[(1:q)],'D',d);
                        
                        % Fits it to the data - finding the constants
                        fit = estimate(mdl, data);
                        
                        % Gets the residuals from the fitted model
                        res=infer(fit,data);

                        % squares and sums the residuals
                        eSum = sum(pow2(res));

                        % If the current residuals squared and sum is smaller then nother eSums, 
                        % then assume is a better fit the the data than previouslly found. 
                        % assuming -> min S(a) is best
                        if eSum < minESum
                            % Updating the best values 
                            bestModel = mdl;
                            minESum = eSum;
                            bestD = d;
                            bestP = p;
                            bestQ = q;
                        end   
                    end
                catch
                    continue;
                end
            end
        end
    end
    d = bestD;
    p = bestP;
    q = bestQ;
end 