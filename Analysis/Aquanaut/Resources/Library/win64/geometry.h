#ifndef GEOMETRY_H
#define GEOMETRY_H

// Collection of geometric structures and utility functions for 3D operations with vectors

/**
 * @brief Structure to hold a 3D vector
 */
typedef struct {
    float x, y, z; // Coordinates
} Vec3;

/**
 * @brief Axis-Aligned Bounding Box (AABB) structure
 */
typedef struct {
    Vec3 min;
    Vec3 max;
} AABB;

/**
 * @brief Structure to hold a triangle defined by three vertices and a normal
 */
typedef struct {
    Vec3 normal;     // Normal vector
    Vec3 v1, v2, v3; // Triangle vertices
} Triangle;

/**
 * @brief Compute the cross product of two vectors
 * @param a First vector
 * @param b Second vector
 * @return Cross product vector
 */
Vec3 CrossProduct(Vec3 a, Vec3 b);

/**
 * @brief Compute the dot product of two vectors
 * @param a First vector
 * @param b Second vector
 * @return Dot product scalar
 */
float DotProduct(Vec3 a, Vec3 b);

/**
 * @brief Add two vectors
 * @param a First vector
 * @param b Second vector
 * @return Resulting vector
 */
Vec3 Vec3Add(Vec3 a, Vec3 b);

/**
 * @brief Subtract vector b from vector a
 * @param a First vector
 * @param b Second vector
 * @return Resulting vector
 */
Vec3 Vec3Subtract(Vec3 a, Vec3 b);

/**
 * @brief Scale a vector by a scalar
 * @param v Input vector
 * @param scalar Scaling factor
 * @return Scaled vector
 */
Vec3 Vec3Scale(Vec3 v, float scalar);

/**
 * @brief Compute the length of a vector
 * @param v Input vector
 * @return Length of the vector
 */
float Vec3Length(Vec3 v);

/**
 * @brief Normalize a vector to unit length
 * @param v Input vector
 * @return Normalized vector
 */
Vec3 Vec3Normalize(Vec3 v);

/**
 * @brief Calculate the normal vector of a triangle defined by three vertices
 * @param v1 First vertex
 * @param v2 Second vertex
 * @param v3 Third vertex
 * @return Normal vector of the triangle
 */
Vec3 CalculateTriangleNormal(Vec3 v1, Vec3 v2, Vec3 v3);

#endif