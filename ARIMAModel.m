function ARIMAModel (data, figureTitle)

    data100 = data(1:100);

    % Finds the best model
    [bestModel, p, d, q] = findBestModel(data100);

    % use the best model for forceasting and more...
    mdl = bestModel;
    fit = estimate(mdl, data100);
    res=infer(fit,data100);
    

    fig = figure;
    arimaType = "ARIAM(" + p + ", " + d + ", " + q + ")";
    tit = arimaType + " of " + figureTitle;
    set(fig, 'Name', tit, 'Position', [10, 10, 1100, 900]);

    subplot(3,1,1)
    % comparing fitted values
    plot(data, '-'); 
    title("Time series of " + figureTitle)

    subplot(3,1,2)
    h1 = plot(data100, '-');
    hold on
    h2 = plot(data100 - res, '_');
    legend([h1 h2],figureTitle + "First 100 Days", arimaType + ' - Fitted values');
    title(['Fitted ' + arimaType + ' model to ' + figureTitle])





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
    for d = 0:4
        for p = 0:4
            for q = 0:4
                % the try is here to catch any errors in the ARIMA modeling process
                % doc state that it can be unstable under certain conditions.
                try
                    % makes the ARIMA(p,d,q) model
                    mdl = arima('Constant',NaN,'ARLags',[(1:p)],'MALags',[(1:q)],'D',d);
                    
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