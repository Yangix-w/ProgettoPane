#!/bin/bash
DIR="./matrices"
mkdir -p $DIR
curl -L -o $DIR/Flan_1565.mat https://suitesparse-collection-website.herokuapp.com/mat/Janna/Flan_1565.mat

curl -L -o $DIR/StocF-1465.mat https://suitesparse-collection-website.herokuapp.com/mat/Janna/StocF-1465.mat

curl -L -o $DIR/cfd2.mat https://suitesparse-collection-website.herokuapp.com/mat/Rothberg/cfd2.mat

curl -L -o $DIR/cfd1.mat https://suitesparse-collection-website.herokuapp.com/mat/Rothberg/cfd1.mat

curl -L -o $DIR/G3_circuit.mat https://suitesparse-collection-website.herokuapp.com/mat/AMD/G3_circuit.mat

curl -L -o $DIR/parabolic_fem.mat https://suitesparse-collection-website.herokuapp.com/mat/Wissgott/parabolic_fem.mat

curl -L -o $DIR/apache2.mat https://suitesparse-collection-website.herokuapp.com/mat/GHS_psdef/apache2.mat

curl -L -o $DIR/shallow_water1.mat https://suitesparse-collection-website.herokuapp.com/mat/MaxPlanck/shallow_water1.mat

curl -L -o $DIR/ex15.mat https://suitesparse-collection-website.herokuapp.com/mat/FIDAP/ex15.mat
