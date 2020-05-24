//
// Created by ethan on 5/15/2020.
//

#ifndef RAY_TRACING_TRACER_H
#define RAY_TRACING_TRACER_H

#include <vector>

using namespace std;

struct pixel {
    unsigned char R;
    unsigned char G;
    unsigned char B;
    unsigned char A;
};

struct coord {
    float x;
    float y;
    float z;
};

#include "SphereObj.hpp"
#include "PointLight.hpp"
#include "PlaneObj.hpp"

pixel traceRay(const coord origin, const coord direction, const vector<Sphere>& obj, const vector<PointLight>& lights, const Plane& ground);

#endif //RAY_TRACING_TRACER_H
