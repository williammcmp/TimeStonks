function ARIMAModel (data)

    % Finds the best model
    bestModel = findBestModel(data);

    % use the best model for forceasting and more...
    mdl = bestModel;
    fit = estimate(mdl, gold100);
    res=infer(fit,gold100);

    

end


function bestModel = findBestModel(data)
    % Set up to hold best values
    bestModel = [];
    minESum = Inf;

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

                    end
                catch
                    continue;
                end
            end
        end
    end
end 