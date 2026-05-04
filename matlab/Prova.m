% Metodi del Calcolo Scientifico - Progetto 1
% Hicham Benbouzid 894680
% Le Yang Shi 894536
% Elena Zen 895355

clear; clc; close all;

%matrix_name = "Flan_1565.mat";
%matrix_name = "StocF-1465.mat";
matrix_name = "cfd2.mat";
%matrix_name = "cfd1.mat";
%matrix_name = "G3_circuit.mat";
%matrix_name = "parabolic_fem.mat";
%matrix_name = "apache2.mat";
%matrix_name = "shallow_water1.mat";
%matrix_name = "ex15.mat";

nome_file = fullfile('matrices', matrix_name);
fprintf("Matrice: %-15s | ", strrep(matrix_name, '.mat', ''));

% Controlla se il file esiste
if ~isfile(nome_file)
    warning('File %s non trovato. Salto la matrice.', nome_file);
end

% Caricamento della matrice
data = load(nome_file);
if isfield(data, 'Problem')
    A = data.Problem.A;
else
    campi = fieldnames(data);
    A = data.(campi{1});
end

profile clear % Pulizia eventuali dati precedenti
profile on -memory

N = size(A, 1);

errore = solve(A, N);

profile off
stats = profile('info'); % Estrazione di tutte le statistiche registrate

memoria = stats.FunctionTable(2).PeakMem/1024^2;
tempo = stats.FunctionTable(2).TotalTime;

% Stampa dei risultati intermedi
fprintf("N: %-8d | ", N);
fprintf('Tempo: %8.4f s | Errore: %8.2e | Memoria: %8.4f MB\n', ...
            tempo, errore, memoria);
    
% Pulizia per liberare la RAM prima del ciclo successivo
clear A b x xe data;

