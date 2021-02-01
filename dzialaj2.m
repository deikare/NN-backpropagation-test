function [Y1, Y2] = dzialaj2(W1, W2, X)
    beta = -5;
    f = @(input) 1 ./ (1 + exp(-beta * input));

    X1 = [-1; X];
    U1 = W1 * X1;
    Y1 = f(U1);
    X2 = [-1; Y1];
    U2 = W2 * X2;
    Y2 = f(U2);
end

