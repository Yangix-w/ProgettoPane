import os
import sys

from scipy.io import mmread
from scipy.sparse import csc_matrix, coo_matrix
from sksparse.cholmod import cholesky
import numpy as np
import psutil

# STEP 0 (Fix per Windows): aggiungi DLL di SuiteSparse al PATH
if sys.platform == 'win32' and 'conda' in sys.executable.lower():
    conda_env = os.path.dirname(sys.executable)
    dll_dir = os.path.join(conda_env, 'Library', 'bin')
    if os.path.exists(dll_dir):
        os.environ["PATH"] = dll_dir + os.pathsep + os.environ.get("PATH", "")
        os.add_dll_directory(dll_dir)

# STEP 1: Lettura da file MTX
# TODO: inserire matrici da risolvere
#MTX_FILE = "matrice_100.mtx"  # MATRICE DI PROVA
MTX_FILE = "../matrices/ex15.mtx"  # MATRICE REALE (da testare)
#MTX_FILE = "../matrices/StocF-1465.mtx" 
results = {}
process = psutil.Process(os.getpid())

results['matrix'] = MTX_FILE

if os.path.exists(MTX_FILE):
    A = mmread(MTX_FILE)
    A = csc_matrix(A)  # Converti in CSC per Cholesky
    print(f"Matrice caricata: {A.shape}, {A.nnz} elementi non-zero")
    results['shape'] = A.shape
    results['nnz'] = A.nnz
    
    # Crea vettore b
    n = A.shape[0]
    xe = np.ones(n)
    b = A @ xe 
else:
    print("No matrix file found. Please provide a .mtx file or modify the code to generate a matrix.")

mem_after_load = process.memory_info().rss / (1024**2)  # MB

# STEP 2: Verifica simmetria
print("\nVerifica proprietà matrice...")
if A.shape[0] <= 1000:  # Solo per matrici non troppo grandi
    if not np.allclose(A.toarray(), A.toarray().T):
        print("  - ATTENZIONE: Matrice NON simmetrica (Cholesky richiede simmetria)")

# STEP 3: Decomposizione di Cholesky + risoluzione sistema A*x = b
# TODO: inserire calcolo spazio e errore relativo
print("Decomposizione di Cholesky sparse...")

try:
    import time
    t0 = time.time()
    factor = cholesky(A)
    x = factor(b)

    t_solve = (time.time() - t0) * 1000
    relative_error = np.linalg.norm(x - xe) / np.linalg.norm(xe)
    mem_after_solve = process.memory_info().rss / (1024**2)

    delta_mem = mem_after_solve - mem_after_load
    results['memory_increase_MB'] = f"{delta_mem:.2f} MB"

    results['time'] = f"{t_solve:.2f} ms"
    results['relative_error'] = f"{relative_error:.2e}"
    
    print(results)
    
except Exception as e:
    print(f"\nERRORE durante Cholesky: {e}")
    print("\nPossibili cause:")
    print("  - Matrice non simmetrica")
    print("  - Matrice non definita positiva")
    print("  - Matrice singolare")
    import traceback
    traceback.print_exc()