#!/usr/bin/bash

source /usr/lib/openfoam/openfoam2506/etc/bashrc

blockMesh

changeDictionary -constant

checkMesh -allGeometry -allTopology -allRegions -constant

renumberMesh -overwrite -constant -renumber-method reverseCuthillMcKee