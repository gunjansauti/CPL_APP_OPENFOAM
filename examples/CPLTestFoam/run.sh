blockMesh
decomposePar -force
cplc++ minimal_MD.cpp -o MD
#mpiexec -n 4 CPLTestFoam : -n 4 ./MD
mpirun -n 4 CPLTestFoam : -n 4 ./MD
