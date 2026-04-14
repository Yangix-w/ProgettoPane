$dest = "matrices"

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

New-Item -ItemType Directory -Force -Path $dest | Out-Null

foreach ($u in $urls) {
    $file = Split-Path $u -Leaf
    $out = Join-Path $dest $file

    Write-Host "Scarico $file..."
    curl.exe -L -o $out $u
}