#ifndef INTERSECTION_H
#define INTERSECTION_H

#include "geometry.h"
#include "stlLoader.h"
#include "oceanLoader.h"

// Collection of functions for mesh intersection and buoyancy calculations

/**
 * @brief Structure to hold submerged mesh data
 */
typedef struct {
    int num_triangles;
    int capacity;
    Triangle *triangles;
} SubmergedMesh;

/**
 * @brief Structure to hold intersection cap points
 */
typedef struct {
    Vec3 *points;
    int numPoints;
    int capacity;
} CapPoints;

/**
 * @brief Create a new submerged mesh with initial capacity
 * @param initialCapacity Initial capacity for triangles
 * @return Pointer to the created SubmergedMesh structure
 */
SubmergedMesh* CreateSubmergedMesh(int initialCapacity);

/**
 * @brief Add a triangle to the submerged mesh (with dynamic resizing)
 * @param sub Pointer to the SubmergedMesh structure
 * @param tri Triangle to add
 * @return void
 */
void AddTriangleToSubmerged(SubmergedMesh *sub, Triangle tri);

/**
 * @brief Free the memory allocated for the submerged mesh
 * @param sub Pointer to the SubmergedMesh structure to free
 * @return void
 */
void FreeSubmergedMesh(SubmergedMesh *sub);

/**
 * @brief Compute submerged mesh with flat water surface
 * @param mesh Pointer to the Mesh structure
 * @param waterHeight Height of the flat water plane
 * @param inverted If non-zero, consider "below" as above the water plane
 * @return Pointer to the computed SubmergedMesh structure
 */
SubmergedMesh* ComputeSubmergedMeshFlat(Mesh *mesh, float waterHeight, int inverted);

/**
 * @brief Compute submerged mesh with ocean surface (using bilinear interpolation)
 * @param mesh Pointer to the Mesh structure
 * @param ocean Pointer to the OceanPlane structure
 * @param inverted If non-zero, consider "below" as above the ocean surface
 * @return Pointer to the computed SubmergedMesh structure
 */
SubmergedMesh* ComputeSubmergedMeshOceanSTL(Mesh *mesh, OceanSurface *ocean, int inverted);

/**
 * @brief Calculate the submerged volume of the submerged mesh
 * @param sub Pointer to the SubmergedMesh structure
 * @return Submerged volume
 */
float CalculateSubmergedVolume(SubmergedMesh *sub);

/**
 * @brief Calculate the center of buoyancy of the submerged mesh
 * @param sub Pointer to the SubmergedMesh structure
 * @return Center of buoyancy as a Vec3 structure
 */
Vec3 CalculateCenterOfBuoyancy(SubmergedMesh *sub);

/**
 * @brief Get ocean height at position (x, y) using bilinear interpolation
 * @param ocean Pointer to the OceanPlane structure
 * @param x X coordinate
 * @param y Y coordinate
 * @return Interpolated ocean height at (x, y)
 */
float GetOceanHeight(OceanPlane *ocean, float x, float y);

/**
 * @brief Interpolate along an edge between a point below and above the water height
 * @param below Point below the water height
 * @param above Point above the water height
 * @param waterHeight Height of the water plane
 * @return Interpolated point on the edge at the water height
 */
Vec3 InterpolateEdge(Vec3 below, Vec3 above, float waterHeight);

/**
 * @brief Recalculate normals for all triangles in the submerged mesh
 * @param sub Pointer to the SubmergedMesh structure
 * @return void
 */
void RecalculateNormals(SubmergedMesh *sub);

#endif