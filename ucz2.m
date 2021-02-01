function [W1po , W2po, iteracjeUczenia] = ucz2(W1przed , W2przed , P , T , n, m, e)
%%T - żądane wyjście, P - wejście, n - liczba iteracji uczenia
    beta = -5;
    f = @(input) 1 ./ (1 + exp(-beta * input));
    fprim = @(input) beta * ((1 - f(input)) .* f(input));
    
    liczbaPrzykladow = size(P, 2);
    
    W1 = W1przed;
    W2 = W2przed;
    
    wspUcz = 0.1;
    
    for i = 1 : n
        nrPrzykladu = randi(liczbaPrzykladow);
        Y2_wzorcowe = T(:, nrPrzykladu);
        
        X = P(:, nrPrzykladu);
        X1 = [-1; X];
        
        [Y1, Y2] = dzialaj2(W1, W2, X);
        X2 = [-1; Y1];
        
        D2 = Y2_wzorcowe - Y2;
        E2 = beta * D2 .* Y2 .* (1 - Y2);
        D1 = W2(2 : end, :) * E2;
        E1 = beta * D1 .* Y1 .* (1 - Y1);
        
        
        
        dW2 = wspUcz * X2 * E2';
        W2 = W2 + dW2;
        
        dW1 = wspUcz * X1 * E1';
        W1 = W1 + dW1;
        
        blad_srKw2 = bladsredniokw(D2);
        blad_srKw1 = bladsredniokw(D1);
        
        iteracjeUczenia(i).D2 = D2;
        iteracjeUczenia(i).E2 = E2;
        iteracjeUczenia(i).D1 = D1;
        iteracjeUczenia(i).E1 = E1;
        iteracjeUczenia(i).dW2 = dW2;
        iteracjeUczenia(i).dW1 = dW1;
        iteracjeUczenia(i).W2 = W2;
        iteracjeUczenia(i).W1 = W1;
        iteracjeUczenia(i).blad_srKw1DlaUczacych = blad_srKw1;
        iteracjeUczenia(i).blad_srKw2DlaUczacych = blad_srKw2;
        
        [bladCalkowityWarstwa1, bladCalkowityWarstwa2] = bledyCalkowite(W1, W2, P, T);
        iteracjeUczenia(i).bladCalkowityWarstwa1 = bladCalkowityWarstwa1;
        iteracjeUczenia(i).bladCalkowityWarstwa2 = bladCalkowityWarstwa2;
        
        if blad_srKw2 <= e
            break
        end
        
        if i >= m
            break
        end
    end
    
    W1po = W1;
    W2po = W2;
    
    fig = plotter(iteracjeUczenia);
end

function blad = bladsredniokw(roznicaWektorow)
    bledy = (roznicaWektorow) .^ 2;
    blad = sum(bledy);
end

function fig = plotter(iteracjeUczenia)
    fig = figure;
    
    bledy1dlaUczacych = [iteracjeUczenia.blad_srKw1DlaUczacych];
    bledy2dlaUczacych = [iteracjeUczenia.blad_srKw2DlaUczacych];
    
    bledy1dlaWszystkich = [iteracjeUczenia.bladCalkowityWarstwa1];
    bledy2dlaWszystkich = [iteracjeUczenia.bladCalkowityWarstwa2];
    
    tiledlayout(3, 1);
    
    nexttile;
    plot(bledy1dlaUczacych);
    hold on
    plot(bledy1dlaWszystkich);
    title('blad 1');
    hold off
    
    nexttile;
    plot(bledy2dlaUczacych);
    hold on
    plot(bledy2dlaWszystkich);
    title('blad 2');
    hold off
end

function [bladCalkowityWarstwa1, bladCalkowityWarstwa2] = bledyCalkowite(W1, W2, P, T)
    [~, liczbaDanych] = size(P);
    beta = 5;
    
    bladCalkowityWarstwa1 = 0;
    bladCalkowityWarstwa2 = 0;
    
    for numerDanej = 1 : liczbaDanych
        X = P(:, numerDanej);
        X1 = [-1; X];
        Y2_wzorcowe = T(:, numerDanej);
        
        [Y1, Y2] = dzialaj2(W1, W2, X);
        X2 = [-1; Y1];
        
        D2 = Y2_wzorcowe - Y2;
        E2 = beta * D2 .* Y2 .* (1 - Y2);
        D1 = W2(2 : end, :) * E2;
        E1 = beta * D1 .* Y1 .* (1 - Y1);
        
        bladCalkowityWarstwa2 = bladCalkowityWarstwa2 + bladsredniokw(D2);
        bladCalkowityWarstwa1 = bladCalkowityWarstwa1 + bladsredniokw(D1);
    end
end

%%TODO - dodać błędy dla każdej danej uczącej w obliczeniach, ja prdl xD i
%%zamienić errory z deltami i odwrotnie, ja prdl2


