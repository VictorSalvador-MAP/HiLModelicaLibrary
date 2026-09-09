#ifndef STL_WRITER_H
#define STL_WRITER_H

#include "geometry.h"
#include "stlLoader.h"
#include "oceanLoader.h"
#include "intersection.h"

// Collection of functions for mesh writing (solely for debugging)

/**
 * @brief Write triangles to binary STL file
 * @param filename Path to the output STL file
 * @param triangles Array of triangles to write
 * @param num_triangles Number of triangles in the array
 * @return 1 on success, 0 on failure
 */
int WriteSTLBinary(const char *filename, Triangle *triangles, int num_triangles);

/**
 * @brief Export submerged mesh to STL
 * @param filename Path to the output STL file
 * @param sub Pointer to the SubmergedMesh structure
 * @return 1 on success, 0 on failure
 */
int ExportSubmergedMeshSTL(const char *filename, SubmergedMesh *sub);

/**
 * @brief Export ocean surface to STL
 * @param filename Path to the output STL file
 * @param ocean Pointer to the OceanPlane structure
 * @return 1 on success, 0 on failure
 */
int ExportOceanSurfaceSTL(const char *filename, OceanPlane *ocean);

#endif