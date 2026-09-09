#include "wgs84_geodesic_wrapper.h"

#include <cmath>
#include <limits>

#include <GeographicLib/Geodesic.hpp>

int wgs84_direct_from_north_east(
    double origin_latitude_deg,
    double origin_longitude_deg,
    double north_m,
    double east_m,
    double *latitude_deg,
    double *longitude_deg)
{
    //if (latitude_deg == nullptr || longitude_deg == nullptr ||
    //    !std::isfinite(origin_latitude_deg) ||
    //    !std::isfinite(origin_longitude_deg) ||
    //    !std::isfinite(north_m) ||
    //    !std::isfinite(east_m)) {
    //    return 1;
    //}

    const double distance_m = std::hypot(north_m, east_m);

    if (distance_m == 0.0) {
        *latitude_deg = origin_latitude_deg;
        *longitude_deg = origin_longitude_deg;
        return 0;
    }

    constexpr double rad_to_deg = 180.0 / std::acos(-1.0);
    const double azimuth_deg = std::atan2(east_m, north_m) * rad_to_deg;

    try {
        GeographicLib::Geodesic::WGS84().Direct(
            origin_latitude_deg,
            origin_longitude_deg,
            azimuth_deg,
            distance_m,
            *latitude_deg,
            *longitude_deg);
    } catch (...) {
        *latitude_deg = std::numeric_limits<double>::quiet_NaN();
        *longitude_deg = std::numeric_limits<double>::quiet_NaN();
        return 2;
    }

    return 0;
}