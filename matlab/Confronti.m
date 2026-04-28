% Metodi del Calcolo Scientifico - Progetto 1
% Generazione dei grafici comparativi da file CSV

clear; clc; close all;

% --- 1. DEFINIZIONE PERCORSI E LETTURA CSV ---
parentFolder = fileparts(pwd);
folder = fullfile(parentFolder, 'results');

% Assicurati che i file Python siano stati nominati in questo modo
file_mw = fullfile(folder, 'risultati_matlab_windows.csv');
file_ml = fullfile(folder, 'risultati_matlab_linux.csv');
file_pw = fullfile(folder, 'risultati_python_windows.csv');
file_pl = fullfile(folder, 'risultati_python_linux.csv');

% Controllo esistenza file (per evitare errori se non li hai ancora generati tutti)
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

% --- 3. CREAZIONE GRAFICI ---

% Stili grafici per mantenere coerenza visiva
st_mw = '-ob'; % MATLAB Windows: Linea blu, cerchi
st_ml = '-sb'; % MATLAB Linux: Linea blu, quadrati
st_pw = '-or'; % Python Windows: Linea rossa, cerchi
st_pl = '-sr'; % Python Linux: Linea rossa, quadrati

%% FIGURA 1: TEMPO DI RISOLUZIONE
figure('Name', 'Confronto Tempi', 'Position', [50, 50, 1000, 800]);
sgtitle('Confronto Tempi di Risoluzione (Scala Logaritmica)', 'FontWeight', 'bold', 'FontSize', 14);

% 1. MATLAB: Windows vs Linux
subplot(2, 2, 1);
loglog(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('MATLAB: Windows vs Linux');
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB Windows', 'MATLAB Linux', 'Location', 'northwest');

% 2. Python: Windows vs Linux
subplot(2, 2, 2);
loglog(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
loglog(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Python: Windows vs Linux');
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('Python Windows', 'Python Linux', 'Location', 'northwest');

% 3. Windows: MATLAB vs Python
subplot(2, 2, 3);
loglog(N_mw, t_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pw, t_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Windows: MATLAB vs Python');
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB Windows', 'Python Windows', 'Location', 'northwest');

% 4. Linux: MATLAB vs Python
subplot(2, 2, 4);
loglog(N_ml, t_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pl, t_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Linux: MATLAB vs Python');
xlabel('Dimensione N'); ylabel('Tempo (s)'); grid on;
legend('MATLAB Linux', 'Python Linux', 'Location', 'northwest');


%% FIGURA 2: ERRORE RELATIVO
figure('Name', 'Confronto Errore', 'Position', [100, 100, 1000, 800]);
sgtitle('Confronto Errore Relativo (Scala Logaritmica)', 'FontWeight', 'bold', 'FontSize', 14);

% 1. MATLAB: Windows vs Linux
subplot(2, 2, 1);
loglog(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('MATLAB: Windows vs Linux');
xlabel('Dimensione N'); ylabel('Errore'); grid on; legend('MATLAB Win', 'MATLAB Lin', 'Location', 'best');

% 2. Python: Windows vs Linux
subplot(2, 2, 2);
loglog(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
loglog(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Python: Windows vs Linux');
xlabel('Dimensione N'); ylabel('Errore'); grid on; legend('Python Win', 'Python Lin', 'Location', 'best');

% 3. Windows: MATLAB vs Python
subplot(2, 2, 3);
loglog(N_mw, err_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pw, err_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Windows: MATLAB vs Python');
xlabel('Dimensione N'); ylabel('Errore'); grid on; legend('MATLAB Win', 'Python Win', 'Location', 'best');

% 4. Linux: MATLAB vs Python
subplot(2, 2, 4);
loglog(N_ml, err_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pl, err_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Linux: MATLAB vs Python');
xlabel('Dimensione N'); ylabel('Errore'); grid on; legend('MATLAB Lin', 'Python Lin', 'Location', 'best');


%% FIGURA 3: MEMORIA
figure('Name', 'Confronto Memoria', 'Position', [150, 150, 1000, 800]);
sgtitle('Confronto Incremento Memoria RAM (Scala Logaritmica)', 'FontWeight', 'bold', 'FontSize', 14);

% 1. MATLAB: Windows vs Linux
subplot(2, 2, 1);
loglog(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('MATLAB: Windows vs Linux');
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on; legend('MATLAB Win', 'MATLAB Lin', 'Location', 'northwest');

% 2. Python: Windows vs Linux
subplot(2, 2, 2);
loglog(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r'); hold on;
loglog(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Python: Windows vs Linux');
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on; legend('Python Win', 'Python Lin', 'Location', 'northwest');

% 3. Windows: MATLAB vs Python
subplot(2, 2, 3);
loglog(N_mw, mem_mw, st_mw, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pw, mem_pw, st_pw, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Windows: MATLAB vs Python');
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on; legend('MATLAB Win', 'Python Win', 'Location', 'northwest');

% 4. Linux: MATLAB vs Python
subplot(2, 2, 4);
loglog(N_ml, mem_ml, st_ml, 'LineWidth', 2, 'MarkerFaceColor', 'b'); hold on;
loglog(N_pl, mem_pl, st_pl, 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Linux: MATLAB vs Python');
xlabel('Dimensione N'); ylabel('Memoria (MB)'); grid on; legend('MATLAB Lin', 'Python Lin', 'Location', 'northwest');