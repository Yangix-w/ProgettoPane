% Generazione dei grafici comparativi da file CSV

clear; clc; close all;

% --- 1. DEFINIZIONE PERCORSI E LETTURA CSV ---
parentFolder = pwd; % Se la cartella results è in quella corrente
folder = fullfile(parentFolder, 'results');

% Assicurati che i file Python siano stati nominati in questo modo
file_mw = fullfile(folder, 'risultati_matlab_windows.csv');
file_ml = fullfile(folder, 'risultati_matlab_linux.csv');
file_pw = fullfile(folder, 'risultati_python_windows.csv');
file_pl = fullfile(folder, 'risultati_python_linux.csv');

% Controllo esistenza file
if ~isfile(file_mw) || ~isfile(file_ml) || ~isfile(file_pw) || ~isfile(file_pl)
    error('Assicurati di avere tutti e 4 i file CSV nella cartella results!');
end

% Lettura tabelle
tab_mw = readtable(file_mw);
tab_ml = readtable(file_ml);
tab_pw = readtable(file_pw);
tab_pl = readtable(file_pl);

% --- 2. ESTRAZIONE DATI ---
% MATLAB Windows
N_mw   = tab_mw.Dimensione_N_;
t_mw   = tab_mw.Tempo_s_;
err_mw = tab_mw.ErroreRelativo;
mem_mw = tab_mw.Memoria_MB_;

% MATLAB Linux
N_ml   = tab_ml.Dimensione_N_;
t_ml   = tab_ml.Tempo_s_;
err_ml = tab_ml.ErroreRelativo;
mem_ml = tab_ml.Memoria_MB_;

% Python Windows
N_pw   = tab_pw.Dimensione_N_;
t_pw   = tab_pw.Tempo_s_;
err_pw = tab_pw.ErroreRelativo;
mem_pw = tab_pw.Memoria_MB_;

% Python Linux
N_pl   = tab_pl.Dimensione_N_;
t_pl   = tab_pl.Tempo_s_;
err_pl = tab_pl.ErroreRelativo;
mem_pl = tab_pl.Memoria_MB_;

% --- 3. STILI GRAFICI ---
st_mw = '-ob'; % MATLAB Windows: Linea blu, cerchi
st_ml = '-sb'; % MATLAB Linux: Linea blu, quadrati
st_pw = '-or'; % Python Windows: Linea rossa, cerchi
st_pl = '-sr'; % Python Linux: Linea rossa, quadrati

dim_figura = [100, 100, 1200, 400]; % Finestra larga per 3 grafici affiancati

% =========================================================================
%% FIGURA 1: MATLAB - Windows vs Linux
% =========================================================================
figure('Name', 'MATLAB: Windows vs Linux', 'Position', dim_figura);
sgtitle('Prestazioni MATLAB: Windows vs Linux', 'FontWeight', 'bold', 'FontSize', 14);

subplot(1, 3, 1);
loglog(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Tempo di Risoluzione'); xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');

subplot(1, 3, 2);
loglog(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Errore Relativo'); xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('Windows', 'Linux', 'Location', 'best');

subplot(1, 3, 3);
loglog(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Incremento Memoria RAM'); xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');


% =========================================================================
%% FIGURA 2: PYTHON - Windows vs Linux
% =========================================================================
figure('Name', 'Python: Windows vs Linux', 'Position', dim_figura + [50, -50, 0, 0]);
sgtitle('Prestazioni Python: Windows vs Linux', 'FontWeight', 'bold', 'FontSize', 14);

subplot(1, 3, 1);
loglog(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
loglog(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Tempo di Risoluzione'); xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');

subplot(1, 3, 2);
loglog(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
loglog(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Errore Relativo'); xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('Windows', 'Linux', 'Location', 'best');

subplot(1, 3, 3);
loglog(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
loglog(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Incremento Memoria RAM'); xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('Windows', 'Linux', 'Location', 'northwest');


% =========================================================================
%% FIGURA 3: LINUX - MATLAB vs Python
% =========================================================================
figure('Name', 'Linux: MATLAB vs Python', 'Position', dim_figura + [100, -100, 0, 0]);
sgtitle('Ambiente Linux: MATLAB vs Python', 'FontWeight', 'bold', 'FontSize', 14);

subplot(1, 3, 1);
loglog(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Tempo di Risoluzione'); xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');

subplot(1, 3, 2);
loglog(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Errore Relativo'); xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('MATLAB', 'Python', 'Location', 'best');

subplot(1, 3, 3);
loglog(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Incremento Memoria RAM'); xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');


% =========================================================================
%% FIGURA 4: WINDOWS - MATLAB vs Python
% =========================================================================
figure('Name', 'Windows: MATLAB vs Python', 'Position', dim_figura + [150, -150, 0, 0]);
sgtitle('Ambiente Windows: MATLAB vs Python', 'FontWeight', 'bold', 'FontSize', 14);

subplot(1, 3, 1);
loglog(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Tempo di Risoluzione'); xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');

subplot(1, 3, 2);
loglog(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Errore Relativo'); xlabel('Dimensione N'); ylabel('Errore'); grid on;
legend('MATLAB', 'Python', 'Location', 'best');

subplot(1, 3, 3);
loglog(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Incremento Memoria RAM'); xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on;
legend('MATLAB', 'Python', 'Location', 'northwest');