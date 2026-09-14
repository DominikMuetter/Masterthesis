#!/bin/bash

rm -rf 0
blockMesh | tee meshing.log
surfaceFeatureExtract | tee -a meshing.log
stitchMesh -perfect -overwrite OUT_FORERUNNING IN_MAIN | tee -a meshing.log
stitchMesh -perfect -overwrite OUT_MAIN IN_TAILING | tee -a meshing.log
rm -rf 0
decomposePar -force
mpirun -np 4 snappyHexMesh -overwrite -parallel | tee -a meshing.log
reconstructParMesh -constant | tee -a meshing.log
checkMesh -allGeometry -allTopology -allRegions -constant | tee checkMesh.log
renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee | tee -a meshing.log