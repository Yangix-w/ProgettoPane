function [x, xe] = solve(A, N)
    % Questa funzione isola la risoluzione del sistema lineare per calcolare
    % accuratamente l'aumento di memoria dedicato solo a questa operazione.

    % Creazione del vettore soluzione esatta e termine noto
    xe = ones(N, 1);
    b = A * xe;
    
    % Risoluzione e tempo
    x = A \ b;
end