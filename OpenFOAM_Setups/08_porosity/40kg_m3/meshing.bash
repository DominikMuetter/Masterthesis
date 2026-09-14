source /usr/lib/openfoam/openfoam2506/etc/bashrc

rm -rf 0

surfaceFeatureExtract

blockMesh
stitchMesh -perfect -overwrite OUT_FR IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_T

rm -rf 0

decomposePar
mpirun -np 6 snappyHexMesh -overwrite -parallel
reconstructParMesh -constant

mpirun -np 6 checkMesh -parallel -allGeometry -allTopology -allRegions -constant | tee checkMesh.log
mpirun -np 6 checkMesh -parallel -constant | tee checkMesh_lessChecks.log

renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee
