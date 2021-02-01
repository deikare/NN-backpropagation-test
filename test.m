clear;
close all

K1 = 2;
K2 = 2;

S = 2;

[W1, W2] = init2(S, K1, K2);

P = [0, 0;
    0, 1;
    1, 0;
    1, 1]';

T = [0;
    1;
    1;
    0;]';

n = 5000;
m = 5000;
eps = 0.001;

[W1po, W2po, iteracjeUczenia] = ucz2(W1, W2, P, T, n, m, eps);