clear;
close all

S = 2;
K1 = 2;
K2 = 1;

P = [0, 0;
    0, 1;
    1, 0;
    1, 1]';

T = [0;
    1;
    1;
    0;]';

n = 5000;
m = n;
eps = 0;

%% testy z przykladu z zajec
[W1przed, W2przed] = init2(2, 2, 1)
[~, liczbaDanych] = size(P);
Yprzed = [];
for numerDanej = 1 : liczbaDanych
    [~, y2] = dzialaj2(W1przed, W2przed, P(:, numerDanej));
    Yprzed = [Yprzed, y2];
end
Yprzed

[W1po, W2po, ~, ~] = ucz2(W1przed, W2przed, P, T, n, m, eps)
Ypo = [];
for numerDanej = 1 : liczbaDanych
    [~, y2] = dzialaj2(W1po, W2po, P(:, numerDanej));
    Ypo = [Ypo, y2];
end
Ypo