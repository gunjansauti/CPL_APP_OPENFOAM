#Set OpenFOAM folder
OPEN_FOAM_CASE=openfoam/

#Clean CFD
cd ${OPEN_FOAM_CASE}
./clean.py
rm -f ../log.openfoam
blockMesh
decomposePar -force
cd ../

#Run job
CFD_EXE="CPLSediFOAM"
#cplexec -pv -c 1 "${CFD_EXE} -case ${OPEN_FOAM_CASE} -parallel" -m 1 "./MD_no_particle.py"
mpirun -np 4 CPLSediFOAM -case ./openfoam/ -parallel : -np 4 ./MD_no_particle.py