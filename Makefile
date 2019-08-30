OpenFOAM_DIR=`cat CODE_INST_DIR`
OpenFOAM_SRC_DIR=$(OpenFOAM_SRC_DIR)/src
OpenFOAM_ETC_DIR=$(OpenFOAM_ETC_DIR)/etc

.PHONY: all test clean clean-test pstream socket cplicofoam cplsedifoam cplcfddemfoam
all: cplicofoam cplsedifoam cplcfddemfoam

pstream:
	@wmake libso src/CPLPstream

socket: pstream
	@wmake libso src/CPLSocketFOAM

cplicofoam: socket
	@wmake src/solvers/CPLIcoFoam

cplsedifoam: socket
	@wmake src/solvers/CPLSediFoam

cplcfddemfoam: socket
	@wmake src/solvers/CPLCFDDEMFoam

icofoam:
	@wmake src/solvers/IcoFoam

patch-openfoam:
	cp ./config/pref.sh $(OpenFOAM_ETC_DIR)/config/

clean:
	@wclean src/solvers/CPLIcoFoam
	@wclean src/solvers/CPLporousIcoFoam
	@wclean src/solvers/CPLSediFoam
	@wclean src/solvers/CPLCFDDEMFoam
	@wclean src/CPLSocketFOAM
	@wclean src/CPLPstream
	rm -rf bin
	rm -rf lib

clean-test:
	cd test/stressC-P/debug && ./clean.sh
	cd test/velocityP-C/debug && ./clean.sh

test:
	@py.test2 -v ./test

test-hydrostatic:
	pytest -sv ./examples/hydrostatic

test-fcc_dummy:
	pytest -sv ./examples/fcc_dummy

test-couette:
	cd test/pytest_example/coupled_to_pytest && ./run.sh CPLSediFOAM
	cd test/pytest_example/coupled_to_pytest && ./run.sh CPLCFDDEMFoam
	cd test/pytest_example/pytest_runs_subprocess && pytest -v test_couette.py
	cd test/couette_coupled && pytest -v test_couette.py
	cd test/couette_coupled && pytest -v test_couette_parallel.py

test-granular:
	cd test/granular/suzuki && pytest -v test_column.py

#.PHONY: all test clean clean-test
#all: background CPLIcoFOAM CPLporousIcoFoam
#	@echo "Building everything"

#background: 
#	@wmake libso src/CPLPstream
#	@wmake libso src/CPLSocketFOAM

#CPLIcoFOAM:
#	@wmake src/solvers/CPLIcoFoam

#CPLporousIcoFoam:
#	@wmake src/solvers/CPLporousIcoFoam
#	
#patch-openfoam:
#	cp ./config/pref.sh $(OpenFOAM_ETC_DIR)/config/

#clean:
#	@wclean src/CPLSocketFOAM
#	@wclean src/solvers/CPLIcoFoam
#	@wclean src/CPLPstream
#	rm -rf bin
#	rm -rf lib

#clean-test:
#	cd test/stressC-P/debug && ./clean.sh
#	cd test/velocityP-C/debug && ./clean.sh

#test:
#	@py.test -v ./test

#patch-scotch:                                                                                                                                                                                                                                    
#	patch $(FOAM_SRC)/parallel/decompose/ptscotchDecomp/ptscotchDecomp.C ./config/ptscotchDecomp.patch

#patch-pstream:
#	mv $FOAM_LIBBIN/$FOAM_MPI/libPstream.so $FOAM_LIBBIN/$FOAM_MPI/libPstream.so.orig
#	cp lib/libPstream.so $FOAM_LIBBIN/$FOAM_MPI
#	mv $FOAM_LIBBIN/$FOAM_MPI/libPstream.so.orig $FOAM_LIBBIN/$FOAM_MPI/libPstream.so
#	mv lib/libPstream.so $FOAM_LIBBIN/$FOAM_MPI/libPstream.so.cpl

