function result = evaluate(predictions,mu,sig)
    % predictions N*1 N is the number of test data
    % groundtruths N*1 struct
        % groundtruths.mu(i) is the age
        % groundtruths.sig(i) is the standard deviation
    N = size(predictions,1);
    y = ones(N,1);
    for i=1:N
        y(i) = normal(predictions(i),mu(i),sig(i));
    end
    result = mean(y);
    result
end

function y = normal(x,mu,sig)
    y = 1 - exp(-(x - mu)^2 / (2*sig^2));
end