#!/bin/bash

#SBATCH --job-name=my_cpl_test
#SBATCH --time=0:10:0
#SBATCH --exclusive
#SBATCH --export=none

# you will need to change the account code
#SBATCH --account=t42
#SBATCH --partition=standard
#SBATCH --qos=standard

# at least two nodes are required, as each application coupled requires at least one node each
#SBATCH --nodes=2

# single thread export overriders any declaration in srun
export OMP_NUM_THREADS=1

# once again load the modules
module load other-software
module load cpl-openfoam/2106
# source the SOURCEME.sh files
source $CPL_PATH/SOURCEME.sh
source $CPL_APP_OPENFOAM_PATH/SOURCEME.sh

# return to the cwd
cd /work/t42/t42/gavin/CPLTestSocketFoam

# run blockMesh and decompasePar
# NB these are both serial codes and should only be run within a parallel job if
# they are short and the parallel jobs does not employ a high core count
blockMesh
decomposePar -force

# set SHARED_ARGS environment variable
SHARED_ARGS="--distribution=block:block --hint=nomultithread"

# srun the MD executable and the CPLTestScoketFoam executable in a shared
# MD is copied from the y23 project, but can be built locally
# CPLTestSocketFoam is not copied but its location resides in the users PATH
srun ${SHARED_ARGS} --het-group=0 --nodes=1 --tasks-per-node=2 MD : --het-group=1 --nodes=1 --tasks-per-node=2 CPLTestSocketFoam -parallel



