function extractedData = loadText(fileName, columnNumbers)
    % Inputs:
    %   - fileName: The name of the text file to be read.
    %   - columnNumbers: A vector of column numbers to extract.

    % Check if the file exists
    if ~exist(fileName, 'file')
        error('File not found: %s', fileName);
    end
    
    % Read the data from the text file
    data = importdata(fileName); % Use 'readtable' if your data is in a table formate
    
    % Extract the specified columns
    extractedData = data(:, columnNumbers);
end

