#!/bin/bash

urls=(
  "https://suitesparse-collection-website.herokuapp.com/MM/Janna/Flan_1565.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Janna/StocF-1465.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Rothberg/cfd2.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Rothberg/cfd1.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/AMD/G3_circuit.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/Wissgott/parabolic_fem.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/GHS_psdef/apache2.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/MaxPlanck/shallow_water1.tar.gz"
    "https://suitesparse-collection-website.herokuapp.com/MM/FIDAP/ex15.tar.gz"
)

dest="./matrices"

# Crea la cartella (senza errore se esiste)
mkdir -p "$dest"

for url in "${urls[@]}"; do
  file=$(basename "$url")
  path="$dest/$file"

  echo "Scarico $file..."

  # Download
  curl -L -o "$path" "$url"

  echo "Estraggo $file..."

  # Estrazione
  tar -xzf "$path" -C "$dest" --strip-components=1

  # Eliminazione archivio
  rm "$path"

  echo "$file completato"
  echo
done
