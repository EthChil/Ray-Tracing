//
// Created by ethan on 5/15/2020.
//

#include "Tracer.hpp"

#ifndef RAY_TRACING_SPHEREOBJ_H
#define RAY_TRACING_SPHEREOBJ_H

class Sphere {
private:
    coord pos; //xyz
    float radius;
    pixel colour = {235, 174, 52, 255};
public:
    Sphere(coord pos, float radius);
    Sphere(float x, float y, float z, float radius);
    float getCollision(coord origin, coord direction);
    coord getNormal(const coord& point) const;
};

#endif //RAY_TRACING_SPHEREOBJ_H
