function [W1po , W2po, iteracjeUczenia] = ucz2(W1przed , W2przed , P , T , n, m, eps)
%%T - żądane wyjście, P - wejście, n - liczba iteracji uczenia
    beta = -5;
    f = @(input) 1 ./ (1 + exp(-beta * input));
    fprim = @(input) beta * ((1 - f(input)) .* f(input));
    
    liczbaPrzykladow = size(P, 2);
    
    W1 = W1przed;
    W2 = W2przed;
    
    wspUcz = 0.1;
    
    for i = 1 : n
        if i > m
            break
        end
        nrPrzykladu = randi(liczbaPrzykladow);
        
        X = P(:, nrPrzykladu);
        X1 = [-1; X];
        [Y1, Y2] = dzialaj2(W1, W2, X);
        X2 = [-1; Y1];
        
        blad_sredniokwadratowy2 = bladsredniokw(Y2, T(:, nrPrzykladu));
        if blad_sredniokwadratowy2 <= eps
            break
        end
        
        Error2 = T(:, nrPrzykladu) - Y2;
        Delta2 = fprim(Y2) .* Error2;
        
        Error1 = W2(:, 2 : end)' * Delta2;
        Delta1 = fprim(Y1) .* Error1;
        
        dW2 = wspUcz * Delta2 * X2';
        W2 = W2 + dW2;
        
        dW1 = wspUcz * Delta1 * X1';
        W1 = W1 + dW1;
        
        blad_sredniokwadratowy1 = sum(Error1 .^2);
        
        iteracjeUczenia(i).Error2 = Error2;
        iteracjeUczenia(i).Delta2 = Delta2;
        iteracjeUczenia(i).Error1 = Error1;
        iteracjeUczenia(i).Delta1 = Delta1;
        iteracjeUczenia(i).blad_sredniokwadratowy2 = blad_sredniokwadratowy2;
        iteracjeUczenia(i).blad_sredniokwadratowy1 = blad_sredniokwadratowy1;
    end
    
    W1po = W1;
    W2po = W2;
    
    fig = plotter(iteracjeUczenia);
end

function blad = bladsredniokw(wektorRzeczywisty, wektorPorownywany)
    bledy = (wektorRzeczywisty - wektorPorownywany) .^ 2;
    blad = sum(bledy);
end

function fig = plotter(iteracjeUczenia)
    fig = figure;
    
    bledy1 = [iteracjeUczenia.blad_sredniokwadratowy1];
    bledy2 = [iteracjeUczenia.blad_sredniokwadratowy2];
    
    tiledlayout(3, 1);
    
    nexttile;
    plot(bledy1);
    title('blad 1');
    
    nexttile;
    plot(bledy2);
    title('blad 2');
end

%%TODO - dodać błędy dla każdej danej uczącej w obliczeniach, ja prdl xD i
%%zamienić errory z deltami i odwrotnie, ja prdl2


