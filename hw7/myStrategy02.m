function action=myStrategy02(pastData)
    % action: 1 for buy, -1 for sell, 0 for nothing 
    % pastData: a vector of past adj. close price, with the most recent data being appended at the end of the vector 

    %% parameters
    % N: length for computing mean and variance
    % U: upper bound
    % D: lower bound
    N = 30;
    U=0.0025;
    D=0.0005;

    %% algorithm
    len = length(pastData);
    if len < N+1
        action = 0;
    else
        % initial
        pastData = pastData(len - N: len);
        delta = pastData(2:N+1) - pastData(1:N);
        % calculate mean
        data_mean = mean(delta ./ pastData(1:N));
        % calculate sigma
        data_variance = sum((delta ./ pastData(1:N) - data_mean) .^ 2);
        data_variance = sqrt(data_variance / (N-1));
        % calculate sharp_ratio
        sharp_ratio = data_mean / data_variance;
        ratio = sharp_ratio;
        if sharp_ratio > U
            action = 1;
        elseif sharp_ratio < D
            action = -1;
        else
            action = 0;
        end
    end
    action = 1;
end