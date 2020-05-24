//
// Created by ethan on 5/15/2020.
//

#include "Tracer.hpp"

#ifndef RAY_TRACING_POINTLIGHT_H
#define RAY_TRACING_POINTLIGHT_H

class PointLight {
private:
    coord pos;
    pixel colour;
    float brightness;

public:
    coord getPos();
    PointLight(coord p, float brightness, pixel col);
    PointLight(float x, float y, float z, float bright, unsigned char r, unsigned char g, unsigned char b);
    PointLight(float x, float y, float z, float bright, pixel col);
    PointLight(coord p, float bright, unsigned char r, unsigned char g, unsigned char b);
    pixel bounceLight(coord point, coord normal, bool occluded);
    coord direction2Light(const coord& point) const;
    void setPos(coord p);
};


#endif //RAY_TRACING_POINTLIGHT_H
