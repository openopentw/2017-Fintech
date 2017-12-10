% Main program for testing myStrategy02.m
%	Roger Jang, 20171110
%   modified by YJC

close all; clear all;
%% Parameters and data
file='spy.csv';
fprintf('Reading %s...\n', file);
[num, str, raw]=xlsread(file, 'spy');
originAdjClose=num(:,5)';
lenOriginAdjClose=length(originAdjClose);
N=30;
U=0.0005;
D=-0.0005;
%% For loop
pastDay=50;
plotted=0;
for d=0:1
    %% Initial
    capital=1000;	% Initial cash
    adjClose = originAdjClose(1:lenOriginAdjClose-d);
    %% start rolling
    dataCount=length(adjClose);
    suggestedAction=zeros(dataCount,1);	% suggested actions based on sharpe ratio, 1 for buy, -1 for sell
    ratio=zeros(dataCount,1);	% sharpe ratio
    unit=zeros(dataCount,1);	% unit of stock in hand
    total=zeros(dataCount,1);	% total assets
    realAction=zeros(dataCount,1);	% real actions
    total(1)=capital;
    for i=dataCount-30:dataCount
        [suggestedAction(i), ratio(i)]=myStrategy02(adjClose(1:i-1));	% Suggested action
        currPrice=adjClose(i);	% Today's price
        if i>1, unit(i)=unit(i-1); end		% Initial holding from yesterday
        switch suggestedAction(i)
            case 1	% "buy"
                if unit(i)==0
                    unit(i)=capital/currPrice;
                    capital=0;
                    realAction(i)=1;
                end
            case -1	% "sell"
                if unit(i)>0
                    capital=unit(i)*currPrice;
                    unit(i)=0;
                    realAction(i)=-1;
                end
            case 0	% Do nothing
            otherwise
                disp('Unknown action!');
        end
        total(i)=capital+unit(i)*currPrice;
    %	fprintf('%d/%d: suggestedAction=%d, unit=%g, capital=%g, realAction=%d, total=%g\n', i, dataCount, suggestedAction(i), unit(i), capital, realAction(i), total(i));
    end
    fprintf('Count of "buy" = %g\n', sum(realAction==1));
    fprintf('Count of "sell" = %g\n', sum(realAction==-1));
    fprintf('Total assets = %g\n', total(end));
    %% Plotting
    if plotted == 0
        plotted = 1;
        subplot(511); plot(adjClose); title('Adj close'); set(gca, 'xlim', [1, dataCount]);
        subplot(512); plot(ratio); title('Sharpe ratio');  set(gca, 'xlim', [1, dataCount]);
        axisLimit=axis;
        line(axisLimit(1:2), U*[1 1], 'color', 'r');
        hU=text(axisLimit(2), U, sprintf('U=%g', U));
        hD=text(axisLimit(2), D, sprintf('D=%g', D));
        line(axisLimit(1:2), D*[1 1], 'color', 'g');
        color={'g', 'b', 'r'};
        subplot(513); plot(realAction); title('Action'); set(gca, 'xlim', [1, dataCount]);
        for i=1:length(suggestedAction)
            if realAction(i)==0; continue; end
            line(i, realAction(i), 'marker', '.', 'color', color{realAction(i)+2});
        end
        subplot(514); plot(unit); title('Stock holdings'); set(gca, 'xlim', [1, dataCount]);
        subplot(515); plot(total); title('Total asset'); set(gca, 'xlim', [1, dataCount]);
        line(axisLimit(1:2), total(1)*[1 1], 'color', 'r');
        xlabel('Data index');
    end
end