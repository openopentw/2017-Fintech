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

filters = [0.95 0.99 0.995 1 1.001 1.005 1.01 1.05 1.1];
for filter_id = 1:length(filters)
    filter = filters(filter_id);
    for M = 3:7
        for n = 10:15
            N = n*2;

            % run
            money = 1000;
            hold = 0;
            days = 100;
            for i = 0:days
                j = days-i;
                testData = pastData(1:len-j-1);
                action = testmyStrategy(testData, M, N, filter);
                if hold == 0 && action == 1
                    %'buy:  ' + string(pastData(len-j).Date)
                    hold = money / AdjOpen(len-j);
                    money = 0;
                elseif hold ~= 0 && action == -1
                    %'sell: ' + string(pastData(len-j).Date)
                    money = hold * AdjOpen(len-1-j);
                    hold = 0;
                end
            end

            if hold ~= 0
                money = hold * AdjOpen(len-1);
                hold = 0;
            end

            disp("(" + string(filter) + ", " + string(M) + ", " + string(N) + ") = " + string(money));
        end
    end
end