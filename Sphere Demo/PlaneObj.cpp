//
// Created by ethan on 5/17/2020.
//

#include "PlaneObj.hpp"
#include "Tracer.hpp"
#include <cmath>
#include <iostream>

using namespace std;

float Plane::getCollision(const coord& origin, const coord& direction) const{
    float t = (-1*(norm.x * (origin.x + height.x) + norm.y * (origin.y + height.y) + norm.z * (origin.z + height.z)))
            /(norm.x * direction.x + norm.y * direction.y + norm.z * direction.z);
    return t;
}

coord Plane::getNormal() const{
    return norm;
}