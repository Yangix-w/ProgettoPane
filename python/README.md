# Metodi del Calcolo Scientifico - Progetto 1: Algebra lineare numerica 
## Sistemi lineari con matrici sparse simmetriche e definite positive

Algoritmi numerici per matrici sparse molto grandi con decomposizione di Cholesky.
Implementazione in Python con libreria scikit-sparse (CHOLMOD)

### Setup con Conda (Windows + Linux)

**Perché Conda?** Fornisce scikit-sparse precompilato con tutte le librerie C++ necessarie (CHOLMOD/SuiteSparse), evitando compilazioni complesse.

Installa Miniconda da: https://docs.conda.io/en/latest/miniconda.html

**Windows:**
```powershell

# Inizializza conda
conda init powershell

# Crea ambiente dalla cartella python/
conda env create -f environment.yml

# Attiva ambiente
conda activate mcs-sparse

# Avvio script
python choleski.py
```

**Linux:**
```bash

# Crea ambiente dalla cartella python/
conda env create -f environment.yml

# Inizializza conda
conda init

# Chiudi e riapri il terminale

# Attiva ambiente
conda activate mcs-sparse

# Avvio script
python choleski.py
```

## Librerie Python utilizzate

### 1. **SciPy** (scipy.sparse + scipy.io)
- **Documentazione**: https://docs.scipy.org/doc/scipy/
- **Caratteristiche**:
  - Lettura/scrittura matrici sparse formato Matrix Market (`.mtx`)
  - Supporto multipli formati sparse: CSC, CSR, COO, LIL, DOK
  - Operazioni algebriche ottimizzate per matrici sparse
  - Parte dell'ecosistema scientifico Python (NumPy/SciPy stack)
- **Manutenzione**: Progetto maturo con rilasci regolari, comunità attiva

### 2. **scikit-sparse** (sksparse.cholmod)
- **Wrapper Python per CHOLMOD** (parte di SuiteSparse di Tim Davis)
- **Documentazione**: https://scikit-sparse.readthedocs.io/
- **Caratteristiche**:
  - Decomposizione di Cholesky ottimizzata per matrici sparse molto grandi
  - Riordinamento automatico per minimizzare fill-in (AMD, COLAMD, METIS)
  - Analisi simbolica + fattorizzazione numerica separate
  - Supporto supernodi per efficienza cache
  - Gestisce matrici con milioni di elementi
- **Performance**: CHOLMOD è lo standard de-facto per Cholesky sparse
- **Manutenzione**: SuiteSparse attivamente sviluppato (v7.x), wrapper scikit-sparse stabile

### 3. **NumPy**
- **Documentazione**: https://numpy.org/doc/
- **Uso nel progetto**: Vettori densi, calcolo norme, operazioni algebriche
- **Manutenzione**: Progetto fondamentale dell'ecosistema Python, rilasci frequenti

### 4. **psutil**
- **Documentazione**: https://psutil.readthedocs.io/
- **Uso**: Monitoraggio memoria processo (RSS - Resident Set Size)
- **Caratteristiche**: Cross-platform, misura memoria fisica effettiva
- **Manutenzione**: Libreria matura e ben mantenuta

## Formati di memorizzazione matrici sparse
Le matrici sparse vengono memorizzate solo con gli elementi **non-zero**, riducendo drasticamente l'occupazione di memoria.

### Formato CSC (Compressed Sparse Column) - Usato in questo progetto

**Struttura dati:**
- `data[]`: valori degli elementi non-zero (array di float64)
- `indices[]`: indici di riga per ogni elemento (array di int32/int64)
- `indptr[]`: puntatori alle colonne (array di int32/int64, lunghezza n+1)

**Esempio:**
```
Matrice 4x4 con 6 elementi non-zero:
 2  0  0  3
 0  5  0  0
 0  1  4  0
 6  0  0  7

CSC:
data    = [2, 6, 5, 1, 4, 3, 7]
indices = [0, 3, 1, 2, 2, 0, 3]
indptr  = [0, 2, 4, 5, 7]
        col 0→  col 1→  col 2→  col 3→
```

**Occupazione memoria:** 
- Per matrice n×n con nnz elementi non-zero:
- Memoria ≈ `8·nnz + 4·nnz + 4·(n+1)` bytes
- Esempio: matrice 10000×10000 con 100000 elementi → ~1.6 MB (vs ~800 MB se densa)

### Fill-in durante Cholesky

Durante la fattorizzazione A = L·L^T, il fattore L può avere **più elementi non-zero** di A:
- **Fill-in**: Nuovi elementi non-zero creati durante la decomposizione
- CHOLMOD usa **riordinamento** (AMD/COLAMD) per minimizzare fill-in
- La memoria aumenta proporzionalmente al fill-in del fattore L

