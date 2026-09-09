#ifndef WGS84_GEODESIC_WRAPPER_H
#define WGS84_GEODESIC_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

int wgs84_direct_from_north_east(
    double origin_latitude_deg,
    double origin_longitude_deg,
    double north_m,
    double east_m,
    double *latitude_deg,
    double *longitude_deg);

#ifdef __cplusplus
}
#endif

#endif