import os
import sys
import gc

from scipy.io import mmread
from scipy.sparse import csc_matrix
from sksparse.cholmod import cholesky
import numpy as np
import matplotlib.pyplot as plt
import psutil
import time
import csv

# STEP 0 (Fix per Windows): aggiungi DLL di SuiteSparse al PATH
if sys.platform == 'win32' and 'conda' in sys.executable.lower():
    conda_env = os.path.dirname(sys.executable)
    dll_dir = os.path.join(conda_env, 'Library', 'bin')
    if os.path.exists(dll_dir):
        os.environ["PATH"] = dll_dir + os.pathsep + os.environ.get("PATH", "")
        os.add_dll_directory(dll_dir)

def get_mem_mb():
    """Memoria RSS del processo in MB, dopo aver liberato memoria inutilizzata."""
    gc.collect()
    return psutil.Process(os.getpid()).memory_info().rss / (1024**2)

def check_symmetry_sparse(A, tol=1e-10):
    diff = A - A.T
    return diff.nnz == 0 or np.allclose(diff.data, 0, atol=tol)

def plot_results(results, metric, label, subplot_pos):
    plt.subplot(1, 3, subplot_pos)
    if metric != 're':
        plt.plot([r['shape'] for r in results], [float(r[metric].split()[0]) for r in results], marker='o')
    else:
        plt.plot([r['shape'] for r in results], [float(r[metric]) for r in results], marker='o')
    plt.yscale('log')
    plt.ylabel(label)
    plt.xlabel('Dimensione matrice')
    plt.title(f'{label}')
    plt.grid(True, alpha=0.3)
    plt.ticklabel_format(style='plain', axis='x')
    plt.xticks(rotation=45)
    

def solve_matrix(mtx_file):
    results = {'matrix': os.path.splitext(os.path.basename(mtx_file))[0]}

    # STEP 1: Lettura da file MTX
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    mtx_path = os.path.join(BASE_DIR, mtx_file)
    if os.path.exists(mtx_path):
        A = csc_matrix(mmread(mtx_path))
        n = A.shape[0]
        xe = np.ones(n)
        b = A @ xe 

        print(f"Matrice: {mtx_file} - {A.shape}")
        results['shape'] = A.shape[0]
    else:
        print("No matrix file found. Please provide a .mtx file or modify the code to generate a matrix.")
        return results

    # STEP 2: Verifica simmetria
    if not check_symmetry_sparse(A):
        print(" Errore: matrice NON simmetrica")
        results['error'] = 'non simmetrica'
        return results

    # STEP 3: Decomposizione di Choleski + risoluzione sistema A*x = b
    print("Inizio decomposizione di Choleski")

    try:
        mem_before = get_mem_mb()
        t0 = time.perf_counter()
        factor = cholesky(A)
        x = factor(b)

        time_ms = (time.perf_counter() - t0)
        relative_error = np.linalg.norm(x - xe) / np.linalg.norm(xe)
        mem_after = get_mem_mb()

        delta_mem = mem_after - mem_before
        results['memory_increase_MB'] = f"{delta_mem:.6f}"

        results['time'] = f"{time_ms:.6f}"
        results['relative_error'] = f"{relative_error:.2e}"
        
        return results

        
    except Exception as e:
        print(f"    ERRORE: {e}")
        results['error'] = str(e)

matrix_files = [
    "./matrices/ex15.mtx",
    "./matrices/cfd1.mtx",
    "./matrices/shallow_water1.mtx",
    "./matrices/cfd2.mtx",
    "./matrices/parabolic_fem.mtx",
    "./matrices/apache2.mtx",
    "./matrices/G3_circuit.mtx",
    "./matrices/StocF-1465.mtx",
    "./matrices/Flan_1565.mtx"
]

toPlot = []
matrix_ordered = []
shapes = {}

for f in matrix_files:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    mtx_path = os.path.join(BASE_DIR, f)
    if os.path.exists(mtx_path):
        A = csc_matrix(mmread(mtx_path))
        shapes[f] = A.shape
    else:
        print(f"File {f} non trovato.")
        shapes[f] = (0, 0)

matrix_ordered = sorted(matrix_files, key=lambda x: shapes[x][0])

csv_file = os.path.join(BASE_DIR, 'choleski_results_python.csv')

for f in matrix_ordered:
    result = solve_matrix(f)
    print(result)
    toPlot.append({'shape': result['shape'], 'time': result['time'], 're': result['relative_error'], 'mem_mb': result['memory_increase_MB']})
    with open(csv_file, 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        if os.stat(csv_file).st_size == 0:
            writer.writerow(['Matrice', 'Dimensione (N)', 'Tempo (s)', 'Errore Relativo', 'Memoria (MB)'])
        writer.writerow([result['matrix'], result.get('shape', ''), result.get('time', ''), result.get('relative_error', ''), result.get('memory_increase_MB', '')])

plt.figure(figsize=(15, 5))
plot_results(toPlot, 'time', 'Tempo (s)', 1)
plot_results(toPlot, 're', 'Errore Relativo', 2)
plot_results(toPlot, 'mem_mb', 'Aumento Memoria (MB)', 3)
plt.suptitle('Decomposizione di Choleski - Risultati', fontsize=14)
plt.tight_layout()
plt.show()