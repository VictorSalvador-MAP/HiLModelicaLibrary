#ifndef STL_LOADER_H
#define STL_LOADER_H

#include <stdint.h>
#include "geometry.h"

// Collection of structures and functions for loading STL files

/**
 * @brief Structure to hold STL mesh data
 */
typedef struct {
    uint32_t num_triangles; // Number of triangles in the mesh
    Triangle *triangles;    // Array of triangles
} Mesh;

/**
 * @brief Load a binary STL file
 * @param filename Path to the STL file
 * @return Pointer to the loaded Mesh structure, or NULL on failure
 */
Mesh* LoadSTLBinary(const char *filename);

/**
 * @brief Free the memory allocated for the mesh
 * @param mesh Pointer to the Mesh structure to free
 * @return void
 */
void FreeMesh(Mesh *mesh);

/**
 * @brief Calculate the volume of the mesh using the divergence theorem
 * @param mesh Pointer to the Mesh structure
 * @return Volume of the mesh in cubic units
 */
float CalculateVolume(Mesh *mesh);

#endif