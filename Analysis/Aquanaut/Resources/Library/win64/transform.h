#ifndef TRANSFORM_H
#define TRANSFORM_H

#include "geometry.h"
#include "stlLoader.h"

// Collection of functions for matrix transformations

/**
 * @brief Quaternion structure
 */
typedef struct {
    float w, x, y, z;
} Quaternion;

/**
 * @brief 3x3 Rotation Matrix structure
 */
typedef struct {
    float m[3][3];
} RotationMatrix;

/**
 * @brief Convert Euler angles (in degrees) to a quaternion
 * @param roll_deg Rotation around X axis in degrees
 * @param pitch_deg Rotation around Y axis in degrees
 * @param yaw_deg Rotation around Z axis in degrees
 * @return Corresponding Quaternion
 */
Quaternion EulerToQuaternion(float roll_deg, float pitch_deg, float yaw_deg);

/**
 * @brief Transform a mesh by applying rotation (quaternion) and translation (position)
 * @param original Pointer to the original Mesh structure
 * @param position Translation vector
 * @param rot Rotation matrix
 * @return Pointer to the transformed Mesh structure
 */
Mesh* TransformMesh(Mesh *original, Vec3 position, RotationMatrix rot);

/**
 * @brief Convert quaternion to 3x3 rotation matrix
 * @param q Input quaternion
 * @return RotationMatrix corresponding to the quaternion
 */
RotationMatrix QuaternionToMatrix(Quaternion q);

/**
 * @brief Apply rotation matrix to a vector
 * @param rot Rotation matrix
 * @param v Input vector
 * @return Rotated vector
 */
Vec3 RotateVector(RotationMatrix rot, Vec3 v);

/**
 * @brief Apply full transformation (rotation + translation) to a vector
 * @param v Input vector
 * @param position Translation vector
 * @param rot Rotation matrix
 * @return Transformed vector
 */
Vec3 TransformVector(Vec3 v, Vec3 position, RotationMatrix rot);

/**
 * @brief Normalize a quaternion
 * @param q Input quaternion
 * @return Normalized quaternion
 */
Quaternion NormalizeQuaternion(Quaternion q);

#endif