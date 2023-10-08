function goldPrices = loadExcel(fileName)
    % Inputs:
    %   - fileName: The name of the Excel file to be read.
   

    %% Set up the Import Options and import the data
    opts = spreadsheetImportOptions("NumVariables", 6);
    
    % Specify sheet and range
    opts.Sheet = "Sheet1";
    opts.DataRange = "A1:F13810";
    
    % Specify column names and types
    opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "USDGold", "Price"];
    opts.SelectedVariableNames = ["USDGold", "Price"];
    opts.VariableTypes = ["char", "char", "char", "char", "datetime", "double"];
    
    % Specify variable properties
    opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4"], "EmptyFieldRule", "auto");
    
    % Import the data
    goldPrices = readtable(fileName, opts, "UseExcel", false);
    
    %% Clear temporary variables
    clear opts

end


