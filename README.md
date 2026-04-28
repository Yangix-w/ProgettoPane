# Analisi Comparativa del Metodo di Choleski per Matrici Sparse
### Membri: Benbouzid Hicham, Shi Le Yang, Zen Elena

Questo progetto nasce dall'esigenza aziendale di valutare l'efficienza di diverse soluzioni software per la risoluzione di sistemi lineari di grandi dimensioni, caratterizzati da matrici sparse, simmetriche e definite positive. L'obiettivo principale è confrontare le prestazioni di **MATLAB** con una **libreria open source** a scelta su due diversi sistemi operativi: **Windows** e **Linux**.

# Obiettivi del Progetto
Il lavoro si focalizza sullo studio del metodo di **Choleski** applicato a matrici sparse provenienti dalla *SuiteSparse Matrix Collection*. Il confronto deve evidenziare:

- **Tempo di calcolo**: Velocità nella risoluzione del sistema $Ax=b$.
- **Accuratezza**: Calcolo dell'errore relativo rispetto alla soluzione esatta $x_e = [1, 1, \dots, 1]^T$.
- **Occupazione di memoria**: Incremento della memoria utilizzata durante la fase di risoluzione.
- **Usabilità**: Facilità d'uso e qualità della documentazione delle librerie utilizzate.

L'errore relativo è calcolato tramite la norma euclidea: 

$$\text{errore relativo} = \frac{||x-x_e||_{2}}{||x_e||_{2}}$$

## Matrici usate

Le matrici utilizzate per i test derivano da problemi reali (ingegneria, fluidodinamica, grafi) e sono reperibili su *Sparse SuiteSparse*:
- `Flan 1565`
- `StocF-1465`
- `cfd2`
- `cfd1`
- `G3 circuit`
- `parabolic fem`
- `apache2`
- `shallow water1`
- `ex15`

Le matrici sono scaricabili attraverso i script all'interno delle cartelle `matlab` e `python`.

## Concetti chiavi
- **Fill-in**: L'implementazione deve prevedere una permutazione preliminare di righe e colonne per minimizzare la generazione di nuovi elementi non nulli durante la fattorizzazione.
- **Algoritmi Specifici**: A differenza di MATLAB, le librerie open source richiedono spesso l'esplicita selezione di algoritmi per matrici simmetriche e definite positive per evitare prestazioni degradate. 

# Ambiente di test
I test sono stati eseguiti sulla stessa macchina fisica per garantire l'imparzialità dei dati.

Softeware usati: 
- **MATLab**
- **Python** con la libreria [Scikit-Sparse](https://github.com/scikit-sparse/scikit-sparse) (`CHOLMOD`)
- OS: **Windows** e **Linux**

## Installazione e attivazione della libreria `Scikit-Sparse`
### Setup con Conda (Windows + Linux)

**Perché Conda?** Fornisce scikit-sparse precompilato con tutte le librerie C++ necessarie (CHOLMOD/SuiteSparse), evitando compilazioni complesse.

Installa Miniconda da: https://docs.conda.io/en/latest/miniconda.html

**Windows:**
```powershell

# Inizializza conda
conda init powershell

# Chiudi e riapri il terminale

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
