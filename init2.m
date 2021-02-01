function [W1, W2] = init2(S, K1, K2)
    delta_w = 0.2;
    w0 = -0.1;
    W1 = w0 + delta_w * rand(K1, S + 1);
    W2 = w0 + delta_w * rand(K2, K1 + 1);
end

