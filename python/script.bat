$urls = @(
  "https://suitesparse-collection-website.herokuapp.com/MM/Janna/Flan_1565.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/Janna/StocF-1465.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/Rothberg/cfd2.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/Rothberg/cfd1.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/AMD/G3_circuit.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/Wissgott/parabolic_fem.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/GHS_psdef/apache2.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/MaxPlanck/shallow_water1.tar.gz",
  "https://suitesparse-collection-website.herokuapp.com/MM/FIDAP/ex15.tar.gz"
)

$dest = "./matrices"

# Crea la cartella (senza errore se esiste)
New-Item -ItemType Directory -Path $dest -Force | Out-Null

foreach ($url in $urls) {
  $fileName = Split-Path $url -Leaf
  $filePath = Join-Path $dest $fileName

  Write-Host "Scarico $fileName..."

  # Download
  curl.exe -L -o $filePath $url

  # Estrazione
  Write-Host "Estraggo $fileName..."
  tar -xzf $filePath -C $dest

  # Eliminazione archivio
  Remove-Item $filePath

  Write-Host "$fileName completato`n"
}
