%% testing script
N=30;
U=0.0005;
D=-0.0005;
capital=1000;	% Initial cash
file='spy.csv';
fprintf('Reading %s...\n', file);
[num, str, raw]=xlsread(file, 'spy');
adjClose=num(:,5)';