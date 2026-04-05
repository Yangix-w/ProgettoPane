# Metodi del Calcolo Scientifico - Progetto 1: Algebra lineare numerica 
## Sistemi lineari con matrici sparse simmetriche e definite positive

Algoritmi numerici per matrici sparse molto grandi con decomposizione di Cholesky.
Implementazione in Python con libreria scikit-sparse (CHOLMOD)

### Setup (Windows + Linux)

### Metodo 1: Conda (RACCOMANDATO - funziona su Windows e Linux)

```bash
# Installa Miniconda da: https://docs.conda.io/en/latest/miniconda.html

# Crea ambiente
conda env create -f environment.yml

# Attiva ambiente
conda activate mcs-sparse

# Verifica installazione
python -c "from sksparse.cholmod import cholesky; print('✓ scikit-sparse OK')"
```

### Metodo 2: Solo Linux/WSL

```bash
# Installa dipendenze di sistema
sudo apt-get install libsuitesparse-dev

# Installa pacchetti Python
pip install numpy scipy scikit-sparse
```

### Metodo 3: Windows con WSL

```powershell
# Installa WSL2
wsl --install

# Segui poi il Metodo 2 dentro WSL
```

## Libreria utilizzata: scikit-sparse

- **CHOLMOD**: Cholesky ottimizzato per matrici sparse (parte di SuiteSparse)
- **Performance**: Gestisce matrici con milioni di elementi su 16GB RAM
- **Cross-platform**: Funziona su Windows (via conda) e Linux

## Uso

### Lettura da file Matrix Market (MTX)

```python
import os, sys

# Fix per Windows conda: aggiungi DLL di SuiteSparse al PATH
if sys.platform == 'win32' and 'conda' in sys.executable.lower():
    conda_env = os.path.dirname(sys.executable)
    dll_dir = os.path.join(conda_env, 'Library', 'bin')
    if os.path.exists(dll_dir):
        os.environ["PATH"] = dll_dir + os.pathsep + os.environ.get("PATH", "")
        os.add_dll_directory(dll_dir)

from scipy.io import mmread
from scipy.sparse import csc_matrix
from sksparse.cholmod import cholesky
import numpy as np

# Leggi matrice da file MTX
A = mmread("matrice.mtx")
A = csc_matrix(A)  # Converti in CSC (formato ottimale per Cholesky)

# Cholesky decomposition
factor = cholesky(A)

# Risolvi A*x = b
b = np.ones(A.shape[0])
x = factor(b)
```

