function [W1po , W2po, iteracjeUczenia, fig] = ucz2(W1przed , W2przed , P , T , n, m, e)
%%T - żądane wyjście, P - wejście, n - liczba iteracji uczenia
    beta = -5;
    alfa = 0.5;
    
    liczbaPrzykladow = size(P, 2);
    
    W1 = W1przed;
    W2 = W2przed;
    
    wspUcz = 0.1;
    
    dW1poprz = 0 * W1; %%inicjalizacja poprzednich dw1, dw2 do momentum
    dW2poprz = 0 * W2;
    
    ro_d = 0.7;%% inicjalizacja do adaptacyjnego współczynnika uczenia
    ro_i = 1.05;
    kw = 1.04;
    error_n_mniej_1 = 0;
    wspUczPoprzedni = wspUcz; %%inicjalizacja poprzedniego wspołczynnika uczenia
    
    for i = 1 : n
        nrPrzykladu = randi(liczbaPrzykladow);
        Y2_wzorcowe = T(:, nrPrzykladu);
        
        X = P(:, nrPrzykladu);
        X1 = [-1; X];
        
        [Y1, Y2] = dzialaj2(W1, W2, X);
        X2 = [-1; Y1];
        
        D2 = Y2_wzorcowe - Y2;
        E2 = beta * D2 .* Y2 .* (1 - Y2);
        D1 = W2(2 : end, :) * E2; %%propagujemy błąd wstecz z pominięciem -1
        E1 = beta * D1 .* Y1 .* (1 - Y1);
        
        dW2biezace = X2 * E2';
        dW1biezace = X1 * E1';
        
        blad_srKw2dlaUczacych = bladsredniokw(D2);
        blad_srKw1dlaUczacych = bladsredniokw(D1);
        [bladCalkowityWarstwa1, bladCalkowityWarstwa2] = bledyCalkowiteWIteracji(W1, W2, P, T);
        
        % adaptacja współczynnika uczenia
        [wspUcz, wspUczPoprzedni, error_n_mniej_1] = zaktualizujWspUczenia(wspUczPoprzedni, ro_d, ro_i, bladCalkowityWarstwa2, error_n_mniej_1, kw);

        % momentum
        dW2 = wspUcz * dW2biezace + alfa * dW2poprz;
        W2 = W2 + dW2;
        
        dW1 = wspUcz * dW1biezace + alfa * dW1poprz;
        W1 = W1 + dW1;
        
        dW2poprz = dW2;
        dW1poprz = dW1;

        iteracjeUczenia(i).blad_srKw1DlaUczacych = blad_srKw1dlaUczacych;
        iteracjeUczenia(i).blad_srKw2DlaUczacych = blad_srKw2dlaUczacych;
        
        iteracjeUczenia(i).bladCalkowityWarstwa1 = bladCalkowityWarstwa1;
        iteracjeUczenia(i).bladCalkowityWarstwa2 = bladCalkowityWarstwa2;
        
        if bladCalkowityWarstwa2 <= e
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

function [wspUczAktualny, wspUczPoprzedni, error_n_mniej_1] = zaktualizujWspUczenia(wspUczPoprzedni, ro_d, ro_i, error_n, error_n_mniej_1, kw)    
    if error_n > kw * error_n_mniej_1
        wspUczAktualny = wspUczPoprzedni * ro_d;
    else
        wspUczAktualny = wspUczPoprzedni * ro_i;
    end
    
    wspUczPoprzedni = wspUczAktualny;
    error_n_mniej_1 = error_n;
end

function fig = plotter(iteracjeUczenia)
    bledy1dlaUczacych = [iteracjeUczenia.blad_srKw1DlaUczacych];
    bledy2dlaUczacych = [iteracjeUczenia.blad_srKw2DlaUczacych];
    
    bledy1dlaWszystkich = [iteracjeUczenia.bladCalkowityWarstwa1];
    bledy2dlaWszystkich = [iteracjeUczenia.bladCalkowityWarstwa2];
        
    fig = figure;
    tiledlayout(2, 1);
    
    nexttile;
    plot(bledy1dlaUczacych);
    hold on
    plot(bledy1dlaWszystkich);
    title('błąd 1szej warstwy');
    legend('Dla danych uczących', 'Dla wszystkich danych');
    xlabel('numer iteracji');
    ylabel('wartość błędu');
    hold off
    
    nexttile;
    plot(bledy2dlaUczacych);
    hold on
    plot(bledy2dlaWszystkich);
    title('błąd 2giej warstwy');
    legend('Dla danych uczących', 'Dla wszystkich danych');
    xlabel('numer iteracji');
    ylabel('wartość błędu');
    hold off
end

function [bladCalkowityWarstwa1, bladCalkowityWarstwa2] = bledyCalkowiteWIteracji(W1, W2, P, T)
    [~, liczbaDanych] = size(P);
    beta = 5;
    
    bladCalkowityWarstwa1 = 0;
    bladCalkowityWarstwa2 = 0;
    
    for numerDanej = 1 : liczbaDanych
        X = P(:, numerDanej);
        Y2_wzorcowe = T(:, numerDanej);
        
        [~, Y2] = dzialaj2(W1, W2, X);
        
        D2 = Y2_wzorcowe - Y2;
        E2 = beta * D2 .* Y2 .* (1 - Y2);
        D1 = W2(2 : end, :) * E2;
        
        bladCalkowityWarstwa2 = bladCalkowityWarstwa2 + bladsredniokw(D2);
        bladCalkowityWarstwa1 = bladCalkowityWarstwa1 + bladsredniokw(D1);
    end
end




