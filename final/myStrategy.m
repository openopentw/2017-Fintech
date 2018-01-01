function action=myStrategy(pastData)
    % action: 1 for buy, -1 for sell, 0 for nothing
    %% read file
    %file='SPY.csv';
    %spyTable = readtable(file);
    %pastData = table2struct(spyTable);
    %% parameters
    % M, N: SMA days
    M = 4;
    N = 25;
    filter = 0.99;
    %% algorithm
    % initial
    len = length(pastData);
    pastData = pastData(len - N: len);
    % calculate
    AdjClose = [pastData.AdjClose];
    Close = [pastData.Close];
    Open = [pastData.Open];
    AdjOpen = Open(2:N+1) + AdjClose(1:N) - Close(1:N);
    AdjOpenSMA_M = mean(AdjOpen(N-M:N));
    AdjOpenSMA_N = mean(AdjOpen(1:N));
    if AdjOpenSMA_M > AdjOpenSMA_N * filter
        action = 1;
    else
        action = -1;
    end
end