#ifndef MODELICA_INTERFACE_H
#define MODELICA_INTERFACE_H

#if defined(_WIN32) || defined(__CYGWIN__)
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT
#endif

/**
 * @brief Get submerged properties of a hull in a wave defined by STL files
 * @param hullFilename Path to the hull STL file
 * @param wavePrefix Prefix for the wave STL files (e.g., "waveFrame_x")
 * @param simulationTime Current simulation time
 * @param timeStep Time step between wave frames
 * @param posX X position of the hull
 * @param posY Y position of the hull
 * @param posZ Z position of the hull
 * @param rotationMatrix Pointer to a 3x3 rotation matrix (row-major order)
 * @param outTotalVolume Pointer to output total hull volume
 * @param outSubmergedVolume Pointer to output submerged volume
 * @param outPercentage Pointer to output submerged percentage
 * @param outCoBX Pointer to output center of buoyancy X coordinate
 * @param outCoBY Pointer to output center of buoyancy Y coordinate
 * @param outCoBZ Pointer to output center of buoyancy Z coordinate
 * @param exportSTL Flag to indicate if submerged and ocean STL files should be exported
 * @param outputDirectory Directory to save exported STL files (if exportSTL is true)
 */
DLL_EXPORT void GetSubmergedPropertiesFromWave(
    const char* hullFilename,
    const char* wavePrefix,
    double simulationTime,
    double timeStep,
    double posX,
    double posY,
    double posZ,
    const double* rotationMatrix,
    double* outTotalVolume,
    double* outSubmergedVolume,
    double* outPercentage,
    double* outCoBX,
    double* outCoBY,
    double* outCoBZ,
    int exportSTL,
    const char* outputDirectory
);

#endif // MODELICA_INTERFACE_H