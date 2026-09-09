#ifndef OCEAN_LOADER_H
#define OCEAN_LOADER_H

#include "geometry.h"
#include "stlLoader.h"

// Collection of structures and functions for loading ocean plane data

/**
 * @brief Structure to hold ocean plane data
 */
typedef struct {
    int n;
    int m;
    int total_points;
    Vec3 *points;
} OceanPlane;

/**
 * @brief Node structure for the Bounding Volume Hierarchy (BVH)
 */ 
typedef struct BVHNode {
    AABB bounds;
    struct BVHNode *left;
    struct BVHNode *right;
    int triangleIndex; // -1 if internal, >= 0 if leaf
} BVHNode;

/**
 * @brief Extended OceanSurface structure with acceleration data
 */
typedef struct {
    Mesh *mesh;
    BVHNode *root;
    float x_min, x_max;
    float y_min, y_max;
    float z_min, z_max;
} OceanSurface;

/**
 * @brief Load ocean surface from STL file
 * @param filename Path to the ocean STL file
 * @return Pointer to the loaded OceanSurface structure, or NULL on failure
 */
OceanSurface* LoadOceanSTL(const char *filename);

/**
 * @brief Free the memory allocated for the ocean surface
 * @param ocean Pointer to the OceanSurface structure to free
 * @return void
 */
void FreeOceanSurface(OceanSurface *ocean);

/**
 * @brief Get the ocean height at position (x, y) using bilinear interpolation from STL surface
 * @param ocean Pointer to the OceanSurface structure
 * @param x X coordinate
 * @param y Y coordinate
 * @return Interpolated Z coordinate (ocean height) at (x, y)
 */
float GetOceanHeightSTL(OceanSurface *ocean, float x, float y);

/**
 * @brief Get the ocean height at position (x, y) using bilinear interpolation from STL surface
 * @param ocean Pointer to the OceanSurface structure
 * @param x X coordinate
 * @param y Y coordinate
 * @return Interpolated Z coordinate (ocean height) at (x, y)
 */
float GetOceanHeightSTL_BHV(OceanSurface *ocean, float x, float y);

/**
 * @brief Load ocean plane from text file
 * @param filename Path to the ocean plane text file
 * @return Pointer to the loaded OceanPlane structure, or NULL on failure
 */
OceanPlane* LoadOceanPlane(const char *filename);

/**
 * @brief Free the memory allocated for the ocean plane
 * @param plane Pointer to the OceanPlane structure to free
 * @return void
 */
void FreeOceanPlane(OceanPlane *plane);

/**
 * @brief Get the ocean point at specified grid indices
 * @param plane Pointer to the OceanPlane structure
 * @param row Row index (0 to m-1)
 * @param col Column index (0 to n-1)
 * @return Vec3 structure representing the point at (row, col)
 */
Vec3 GetOceanPoint(OceanPlane *plane, int row, int col);

/**
 * @brief Recursively builds a BVH tree for the ocean mesh
 * @param mesh Pointer to the ocean STL mesh
 * @param indices Array of triangle indices to be partitioned
 * @param count Number of indices in the current partition
 * @return Pointer to the root BVHNode
 */
BVHNode* BuildBVH(Mesh *mesh, int *indices, int count);

/**
 * @brief Traverses the BVH to find the water height at (x, y)
 * @param node Current BVH node being inspected
 * @param mesh Pointer to the ocean mesh for vertex data
 * @param x Target X coordinate
 * @param y Target Y coordinate
 * @return Interpolated Z height, or -FLT_MAX if no intersection found
 */
float TraverseBVH(BVHNode *node, Mesh *mesh, float x, float y);

/**
 * @brief Recursively frees memory allocated for BVH nodes
 * @param node Root or current node to free
 */
void FreeBVHNode(BVHNode *node);

/**
 * @brief Checks if a point (x, y) is inside a 2D projection of an AABB
 * @param x Coordinate X
 * @param y Coordinate Y
 * @param box The AABB to check against
 * @return 1 if inside, 0 otherwise
 */
int PointInAABB2D(float x, float y, AABB box);

#endif