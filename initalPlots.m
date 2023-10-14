

function initalPlots(dataColumn, figureTitle)
    % initalPlots - Plots the initial visualizations for the provided column data.
    %
    % This function creates a figure with three subplots to visualize the raw
    % time series data, the Autocorrelation Function (ACF), and the Partial
    % Autocorrelation Function (PACF). These plots help identify the underlying
    % processes needed for data analysis.
    %
    % Syntax:
    %   initalPlots(dataColumn, figureTitle)
    %
    % Inputs:
    %   dataColumn - The time series data to be visualized.
    %   figureTitle - The title for the figure and plots.
    %
    % Example:
    %   initalPlots(data, 'Time Series Analysis')

    % Create a figure with a specified title and position
    fig = figure;
    set(fig, 'Name', figureTitle, 'Position', [10, 10, 1100, 900]);
    
    % Plot the raw time series data in the first subplot
    subplot(3,1,1)
    plot(dataColumn,'-')
    xlim([1, 201]); % Set the x-axis limit to the first 201 data points
    title(figureTitle)
    
    % Plot the Autocorrelation Function (ACF) in the second subplot
    subplot(3,1,2)
    autocorr(dataColumn, 10) % Calculate and plot ACF for lag 0 to 10
    ylim([-1,1]) % Set the y-axis limits to -1 and 1
    title('ACF')
    
    % Plot the Partial Autocorrelation Function (PACF) in the third subplot
    subplot(3,1,3)
    parcorr(dataColumn, 10); % Calculate and plot PACF for lag 0 to 10
    ylim([-1,1]) % Set the y-axis limits to -1 and 1
    title('PACF')
end
