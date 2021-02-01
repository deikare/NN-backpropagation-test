function [W1, W2] = init2(S, K1, K2)
    delta_w = 0.2;
    w0 = -0.1;
    W1 = w0 + delta_w * rand(S + 1, K1);
    W2 = w0 + delta_w * rand(K1 + 1, K2);
end

