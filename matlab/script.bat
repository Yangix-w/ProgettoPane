$urls = @(
  "https://suitesparse-collection-website.herokuapp.com/mat/Janna/Flan_1565.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/Janna/StocF-1465.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/Rothberg/cfd2.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/Rothberg/cfd1.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/AMD/G3_circuit.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/Wissgott/parabolic_fem.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/GHS_psdef/apache2.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/MaxPlanck/shallow_water1.mat",
    "https://suitesparse-collection-website.herokuapp.com/mat/FIDAP/ex15.mat"
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
  
  Write-Host "$fileName completato`n"
}
