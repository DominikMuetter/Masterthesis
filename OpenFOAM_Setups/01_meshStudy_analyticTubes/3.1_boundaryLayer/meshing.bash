#!/usr/bin/bash

source /usr/lib/openfoam/openfoam2506/etc/bashrc

blockMesh

stitchMesh -perfect -overwrite OUT_FR IN_MAIN
stitchMesh -perfect -overwrite OUT_MAIN IN_T

rm -rf 0

snappyHexMesh -overwrite

checkMesh -allGeometry -allTopology -allRegions -constant | tee -a checkMesh.log

renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee