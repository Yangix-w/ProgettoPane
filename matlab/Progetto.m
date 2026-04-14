% Metodi del Calcolo Scientifico - Progetto 1
% Hicham Benbouzid 894680
% Le Yang Shi 894536
% Elena Zen 895355

clear; clc; close all;

% Elenco delle matrici
matrici_names = {'cfd2.mat', 'cfd1.mat', ...
                 'G3_circuit.mat', 'parabolic_fem.mat', 'apache2.mat', ...
                 'shallow_water1.mat', 'ex15.mat'};

% Elenco delle matrici
%matrici_names = {'apache2.mat', 'shallow_water1.mat', 'ex15.mat'};

num_matrici = length(matrici_names);

% Inizializzazione degli array per salvare i risultati
N_vals = zeros(num_matrici, 1);
tempi = zeros(num_matrici, 1);
errori = zeros(num_matrici, 1);
memorie = zeros(num_matrici, 1);

fprintf('Inizio analisi di tutte le matrici...\n');
fprintf('--------------------------------------------------\n');

for i = 1:num_matrici
    nome_file = fullfile('matrices', matrici_names{i});
    
    % Controlla se il file esiste
    if ~isfile(nome_file)
        warning('File %s non trovato. Salto la matrice.', nome_file);
        continue;
    end
    
    % Caricamento della matrice
    data = load(nome_file);
    if isfield(data, 'Problem')
        A = data.Problem.A;
    else
        campi = fieldnames(data);
        A = data.(campi{1}); 
    end
    
    N = size(A, 1);
    N_vals(i) = N;
    
    % Creazione del vettore soluzione esatta e termine noto
    xe = ones(N, 1);
    b = A * xe;
    
    % --- MISURAZIONE MEMORIA INIZIALE ---
    if ispc 
        % Windows
        mem_info_start = memory;
        mem_start = mem_info_start.MemUsedMATLAB / (1024^2); % MB
    else
        % Linux
        pid = feature('getpid');
        [~, cmd_out] = system(sprintf('ps -o rss= -p %d', pid));
        mem_start = str2double(cmd_out) / 1024; % Conversione da KB a MB
    end
    
    % --- RISOLUZIONE E MISURAZIONE TEMPO ---
    tic;
    x = A \ b; 
    tempi(i) = toc;
    
    % --- MISURAZIONE MEMORIA FINALE ---
    if ispc
        % Windows
        mem_info_end = memory;
        mem_end = mem_info_end.MemUsedMATLAB / (1024^2); % MB
    else
        % Linux
        pid = feature('getpid');
        [~, cmd_out] = system(sprintf('ps -o rss= -p %d', pid));
        mem_end = str2double(cmd_out) / 1024;
    end
    
    % Incremento di memoria
    memorie(i) = max(0, mem_end - mem_start); 
    
    % --- CALCOLO ERRORE RELATIVO ---
    errori(i) = norm(x - xe, 2) / norm(xe, 2);
    
    % Stampa dei risultati intermedi
    fprintf('Matrice: %-15s | N: %-8d | Tempo: %8.4f s | Errore: %8.2e | Memoria: %8.2f MB\n', ...
            strrep(matrici_names{i}, '.mat', ''), N, tempi(i), errori(i), memorie(i));
            
    % Pulizia per liberare la RAM prima del ciclo successivo
    clear A b x xe data;
end

fprintf('--------------------------------------------------\n');
fprintf('Analisi completata. Generazione dei grafici...\n');

% Ordinamento dei dati in base alla dimensione N per avere un grafico leggibile (linea continua da N piccolo a N grande)
[N_vals_sorted, idx] = sort(N_vals);
tempi_sorted = tempi(idx);
errori_sorted = errori(idx);
memorie_sorted = memorie(idx);

% Esclusione eventuali file saltati perché non trovati (N = 0)
valid_idx = N_vals_sorted > 0;
N_vals_sorted = N_vals_sorted(valid_idx);
tempi_sorted = tempi_sorted(valid_idx);
errori_sorted = errori_sorted(valid_idx);
memorie_sorted = memorie_sorted(valid_idx);

% --- CREAZIONE DEI GRAFICI ---
figure('Name', 'Prestazioni MATLAB: Cholesky su Matrici Sparse', 'Position', [100, 100, 1200, 400]);

% Grafico 1: Tempo
subplot(1, 3, 1);
loglog(N_vals_sorted, tempi_sorted, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Tempo di Risoluzione');
xlabel('Dimensione matrice (N)');
ylabel('Tempo (secondi)');
%grid on;

% Grafico 2: Errore Relativo
subplot(1, 3, 2);
loglog(N_vals_sorted, errori_sorted, '-s', 'LineWidth', 2, 'MarkerFaceColor', 'r', 'Color', 'r');
title('Errore Relativo');
xlabel('Dimensione matrice (N)');
ylabel('Errore relativo');
%grid on;

% Grafico 3: Memoria
subplot(1, 3, 3);
loglog(N_vals_sorted, memorie_sorted, '-^', 'LineWidth', 2, 'MarkerFaceColor', 'g', 'Color', 'g');
title('Incremento di Memoria RAM');
xlabel('Dimensione matrice (N)');
ylabel('Memoria (MB)');
%grid on;