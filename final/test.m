% read csv
file='SPY.csv';
spyTable = readtable(file);
pastData = table2struct(spyTable);
len = length(pastData);

% calculate AdjOpen
AdjClose = [pastData.AdjClose];
Close = [pastData.Close];
Open = [pastData.Open];
AdjOpen = Open(2:len) + AdjClose(1:len-1) - Close(1:len-1);

% run
money = 1000;
hold = 0;
days = 365;
for i = 0:days
    j = days-i;
    testData = pastData(1:len-j-1);
    action = myStrategy(testData);
    if hold == 0 && action == 1
        %'buy:  ' + string(pastData(len-j).Date)
        hold = money / AdjOpen(len-j);
        money = 0;
    elseif hold ~= 0 && action == -1
        %'sell: ' + string(pastData(len-j).Date)
        money = hold * AdjOpen(len-j);
        hold = 0;
    end
end

if hold ~= 0
    money = hold * AdjOpen(len-1);
    hold = 0;
end

money