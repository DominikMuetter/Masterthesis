#!/usr/bin/python3

import trimesh
import numpy as np
import os
import glob
import logging

# Configure logging for discrete terminal output
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

def create_bounding_box(xmin, xmax, ymin, ymax, zmin, zmax):
    """
    Constructs an exact 3D bounding box mesh based on coordinate limits.
    """
    extents = [xmax - xmin, ymax - ymin, zmax - zmin]
    
    # Calculate geometric centroid
    center_x = (xmax + xmin) / 2.0
    center_y = (ymax + ymin) / 2.0
    center_z = (zmax + zmin) / 2.0
    
    # Construct 4x4 translation matrix
    transform = np.eye(4)
    transform[:3, 3] = [center_x, center_y, center_z]
    
    # Generate AABB
    aabb = trimesh.creation.box(extents=extents, transform=transform)
    return aabb

def quantify_volume_ratio(stl_directory, xmin, xmax, ymin, ymax, zmin, zmax):
    """
    Iterates through STLs, computes intersections, and aggregates volume data.
    """
    if not os.path.exists(stl_directory):
        logging.error(f"Target directory '{stl_directory}' does not exist.")
        return

    # Initialize AABB
    bounding_box = create_bounding_box(xmin, xmax, ymin, ymax, zmin, zmax)
    
    # Fetch all STL files in directory
    search_pattern = os.path.join(stl_directory, "*.stl")
    stl_files = glob.glob(search_pattern)
    
    if not stl_files:
        logging.warning("No STL files located in the specified directory.")
        return

    total_volume_global = 0.0
    inside_volume_global = 0.0

    # Ensure robust boolean engine is utilized if available
    logging.getLogger('trimesh').setLevel(logging.ERROR)

    for idx, filepath in enumerate(stl_files):
        try:
            # Load mesh
            mesh = trimesh.load_mesh(filepath)
            
            if not mesh.is_watertight:
                logging.warning(f"Mesh {filepath} is non-manifold/not watertight. Volume calculations may contain high variance.")

            vol_total = mesh.volume
            total_volume_global += vol_total

            # Execute Boolean Intersection
            intersection_mesh = mesh.intersection(bounding_box, engine='manifold') # Requires manifold3d pip package
            
            # Extract internal volume; handle empty intersections (mesh fully outside)
            if intersection_mesh.is_empty:
                vol_inside = 0.0
            else:
                vol_inside = intersection_mesh.volume
            
            inside_volume_global += vol_inside

        except Exception as e:
            logging.error(f"Boolean operation failed for {filepath}. Exception: {e}")
            continue

    # Post-processing analytics
    outside_volume_global = total_volume_global - inside_volume_global
    
    if total_volume_global == 0:
        logging.error("Total volume equals 0.0. Terminating analytical ratio calculation.")
        return

    ratio_inside = inside_volume_global / total_volume_global
    ratio_outside = outside_volume_global / total_volume_global

    # Data formatting and output
    print("\n--- Volume Quantification Diagnostics ---")
    print(f"Total Cylinders Processed: {len(stl_files)}")
    print(f"Global Volume (Total):   {total_volume_global:.8e} m^3")
    print(f"Global Volume (Inside):  {inside_volume_global:.8e} m^3")
    print(f"Global Volume (Outside): {outside_volume_global:.8e} m^3")
    print(f"Ratio (Inside / Total):  {ratio_inside:.4%}")
    print(f"Ratio (Outside / Total): {ratio_outside:.4%}")
    print(f"Ratio (Inside : Outside): {inside_volume_global}:{outside_volume_global}")

if __name__ == "__main__":
    # Spatial boundaries parameterization
    X_MIN, X_MAX = 0.0, 0.7
    Y_MIN, Y_MAX = -0.075, 0.075
    Z_MIN, Z_MAX = 0.0, 0.1
    
    # Target path containing geometries (adjust if your pipeline uses a different path)
    TARGET_PATH = "zylinder_stls"

    quantify_volume_ratio(
        stl_directory=TARGET_PATH,
        xmin=X_MIN, xmax=X_MAX,
        ymin=Y_MIN, ymax=Y_MAX,
        zmin=Z_MIN, zmax=Z_MAX
    )