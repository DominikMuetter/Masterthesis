#!/usr/bin/python3

# generate_stls.py

import trimesh
import numpy as np
import os 
from tqdm import tqdm # for a progress bar during creation

def transformation_matrix(scale=1.0, rotation_deg=(0,0,0), translation=(0,0,0)):
    sx, sy, sz = scale if isinstance(scale, (tuple, list, np.ndarray)) else (scale, scale, scale)
    rx, ry, rz = np.radians(rotation_deg)

    # Skalierung
    S = np.diag([sx, sy, sz, 1])

    # Rotation um X-Achse
    Rx = np.array([
        [1, 0,          0,           0],
        [0, np.cos(rx), -np.sin(rx), 0],
        [0, np.sin(rx),  np.cos(rx), 0],
        [0, 0,          0,           1]
    ])

    # Rotation um Y-Achse
    Ry = np.array([
        [ np.cos(ry), 0, np.sin(ry), 0],
        [ 0,          1, 0,          0],
        [-np.sin(ry), 0, np.cos(ry), 0],
        [ 0,          0, 0,          1]
    ])

    # Rotation um Z-Achse
    Rz = np.array([
        [np.cos(rz), -np.sin(rz), 0, 0],
        [np.sin(rz),  np.cos(rz), 0, 0],
        [0,           0,          1, 0],
        [0,           0,          0, 1]
    ])

    # Gesamte Rotation: Rz * Ry * Rx (Reihenfolge wichtig)
    R = Rz @ Ry @ Rx

    # Translation
    T = np.eye(4)
    T[:3, 3] = translation

    # Gesamttransformation: Translation * Rotation * Skalierung
    M = T @ R @ S
    return M

def create_random_points(n, xmin, xmax, ymin, ymax, zmin, zmax):
    x = np.random.uniform(xmin, xmax, n)
    y = np.random.uniform(ymin, ymax, n)
    z = np.random.uniform(zmin, zmax, n)
    points = np.vstack((x, y, z)).T
    return points

def create_random_orientations(n, deg_xmin, deg_xmax, deg_ymin, deg_ymax, deg_zmin, deg_zmax):
    rx = np.random.uniform(deg_xmin, deg_xmax, n)
    ry = np.random.uniform(deg_ymin, deg_ymax, n)
    rz = np.random.uniform(deg_zmin, deg_zmax, n)
    orientations = np.vstack((rx, ry, rz)).T
    return orientations

if __name__ == "__main__" : 
    # approximate number of tubes in 0.7 x 0.15 x 0.1 [m]:
    # rho [kg/m^3] nTubes 
    #       10      3272
    #       20      6543
    #       30      9815
    #       40      13087
    #       50      16358
    #       60      19630
    # Use "inside_outside_boundingBox_volume.py" to determine correction factor.
    # Correction is approx. 1.17 (17% outside of boundingbox)
    n = 7650 #6543
    
    # properties
    diameter = 0.00086
    radius = diameter / 2.0
    surfaceResolution = 20 # if too large, the cylinder is not closed

    # length distribution parameters
    mean_length = 0.085
    std_dev_length = 0.015
    min_length = 0.06
    max_length = 0.13

    # spatial boundaries
    xmin, xmax, ymin, ymax, zmin, zmax = 0.0,0.7,-0.075,0.075,0.0,0.1
    deg_xmin, deg_xmax, deg_ymin, deg_ymax, deg_zmin, deg_zmax = 0, 180, 0, 180, 0, 180

    # generate arrays
    points = create_random_points(n, xmin, xmax, ymin, ymax, zmin, zmax)
    orientations = create_random_orientations(n, deg_xmin, deg_xmax, deg_ymin, deg_ymax, deg_zmin, deg_zmax)
    
    # sample Gaussian distribution for lengths and clip to specified strict bounds
    lengths = np.random.normal(loc=mean_length, scale=std_dev_length, size=n)
    lengths = np.clip(lengths, min_length, max_length)
    
    path = "zylinder_stls"
    os.makedirs(path, exist_ok=True)

    for i in tqdm(range(0, n)):

        M = transformation_matrix(
            scale=1, 
            rotation_deg=(orientations[i,0], orientations[i,1], orientations[i,2]), 
            translation=(points[i,0], points[i,1], points[i,2])
        )
        
        # apply the independent length scalar to the height parameter
        cylinder = trimesh.creation.cylinder(radius=radius, height=lengths[i], sections=surfaceResolution)
        
        cylinder.apply_transform(M)

        if not cylinder.is_watertight:
            print(f"Warning: cylinder {i} is not watertight")
        
        cylinder.export(os.path.join(path, 'zylinder_' + str(i) + '.stl'))