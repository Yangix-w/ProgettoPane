import os
import sys

# STEP 0 (Fix per Windows): aggiungi DLL di SuiteSparse al PATH
if sys.platform == 'win32' and 'conda' in sys.executable.lower():
    conda_env = os.path.dirname(sys.executable)
    dll_dir = os.path.join(conda_env, 'Library', 'bin')
    if os.path.exists(dll_dir):
        os.environ["PATH"] = dll_dir + os.pathsep + os.environ.get("PATH", "")
        os.add_dll_directory(dll_dir)

from scipy.io import mmread
from scipy.sparse import csc_matrix, coo_matrix
from sksparse.cholmod import cholesky
import numpy as np

# STEP 1: Lettura da file MTX
# TODO: inserire matrici da risolvere
MTX_FILE = "matrice_100.mtx"  # MATRICE DI PROVA

if os.path.exists(MTX_FILE):
    print(f"\nLettura matrice da file MTX: {MTX_FILE}")
    A = mmread(MTX_FILE)
    A = csc_matrix(A)  # Converti in CSC per Cholesky
    print(f"Matrice caricata: {A.shape}, {A.nnz} elementi non-zero")
    
    # Crea vettore b
    n = A.shape[0]
    b = np.ones(n)
    print(f"Vettore b: ones({n})")

else:
    print("No matrix file found. Please provide a .mtx file or modify the code to generate a matrix.")

# STEP 2: Verifica simmetria
print("\nVerifica proprietà matrice...")
if A.shape[0] <= 1000:  # Solo per matrici non troppo grandi
    if np.allclose(A.toarray(), A.toarray().T):
        print("  - Matrice simmetrica: SI")
    else:
        print("  - ATTENZIONE: Matrice NON simmetrica (Cholesky richiede simmetria)")

# STEP 3: Decomposizione di Cholesky
# TODO: inserire calcolo spazio e errore relativo
print("Decomposizione di Cholesky sparse...")

try:
    import time
    t0 = time.time()
    factor = cholesky(A)
    t_factor = (time.time() - t0) * 1000
    print(f"Decomposizione completata in {t_factor:.2f} ms")
    
    # RISOLUZIONE SISTEMA A*x = b
    print("\nRisoluzione sistema A*x = b...")
    t0 = time.time()
    x = factor(b)
    t_solve = (time.time() - t0) * 1000
    print(f"Sistema risolto in {t_solve:.2f} ms")
    
    # Mostra soluzione (primi elementi), serve?
    if len(x) <= 10:
        print(f"Soluzione x = {x}")
    else:
        print(f"Soluzione x[0:5] = {x[:5]}")
        print(f"          x[-5:] = {x[-5:]}")
    
    # VERIFICA ACCURATEZZA TODO verificare se giusto come ha detto il prof
    residuo = np.linalg.norm(A @ x - b)
    print(f"\nVerifica accuratezza:")
    print(f"  ||A*x - b|| = {residuo:.2e}")
    
    if residuo < 1e-10:
        print("*** SUCCESSO! Soluzione accurata trovata ***")
    else:
        print(f"\n  ATTENZIONE: residuo elevato ({residuo})")
    
    # INFORMAZIONI AGGIUNTIVE boh per ora le tengo
    print(f"\nStatistiche:")
    print(f"  - Dimensione matrice: {A.shape}")
    print(f"  - Elementi non-zero: {A.nnz}")
    print(f"  - Densità: {A.nnz / (A.shape[0]**2) * 100:.2f}%")
    print(f"  - Tempo decomposizione: {t_factor:.2f} ms")
    print(f"  - Tempo risoluzione: {t_solve:.2f} ms")
    
except Exception as e:
    print(f"\nERRORE durante Cholesky: {e}")
    print("\nPossibili cause:")
    print("  - Matrice non simmetrica")
    print("  - Matrice non definita positiva")
    print("  - Matrice singolare")
    import traceback
    traceback.print_exc()