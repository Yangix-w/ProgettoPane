function [error] = solve(A, N)
    % Questa funzione isola la risoluzione del sistema lineare per calcolare
    % accuratamente l'aumento di memoria dedicato solo a questa operazione.

    % Creazione del vettore soluzione esatta e termine noto
    xe = ones(N, 1);
    b = A * xe;
    
    % Risoluzione e tempo
    x = A \ b;

    error = norm(x - xe, 2) / norm(xe, 2);
end