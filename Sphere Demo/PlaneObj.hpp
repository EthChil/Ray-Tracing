//
// Created by ethan on 5/17/2020.
//

#include "Tracer.hpp"

#ifndef SPHEREDEMO_PLANEOBJ_HPP
#define SPHEREDEMO_PLANEOBJ_HPP

class Plane {
private:
    coord norm;
    coord height;
    pixel colour;
public:
    Plane(const coord pos, const coord norm, const pixel colour) : colour(colour), height(pos), norm(norm) {};
    Plane() : colour(pixel{0,0,0,0}), height(coord{0,0,0}), norm(coord{0,0,0}) {};
    float getCollision(const coord& origin, const coord& direction) const;
    coord getNormal() const;
};

#endif //SPHEREDEMO_PLANEOBJ_HPP
