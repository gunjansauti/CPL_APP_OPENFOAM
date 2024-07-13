blockMesh
decomposePar -force
cplc++ 	minimal_MD.cpp -o MD
mpirun -n 4 CPLTestFoam : -n 4 ./MD

