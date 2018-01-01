function action=testmyStrategy(pastData, M, N, filter)
    % action: 1 for buy, -1 for sell, 0 for nothing
    %% read file
    %file='SPY.csv';
    %spyTable = readtable(file);
    %pastData = table2struct(spyTable);
    %% parameters
    % N, M: SMA days
    %N = 20;
    %M = 5;
    %% algorithm
    % initial
    len = length(pastData);
    pastData = pastData(len - N: len);
    % calculate
    AdjClose = [pastData.AdjClose];
    Close = [pastData.Close];
    Open = [pastData.Open];
    AdjOpen = Open(2:N+1) + AdjClose(1:N) - Close(1:N);
    AdjOpenSMA_5 = mean(AdjOpen(N-M:N));
    AdjOpenSMA_20 = mean(AdjOpen(1:N));
    if AdjOpenSMA_5 > AdjOpenSMA_20 * filter
    %if AdjOpenSMA_5 > AdjOpenSMA_20 * 0.999
    %if AdjOpenSMA_5 > AdjOpenSMA_20
        action = 1;
    else
        action = -1;
    end
end