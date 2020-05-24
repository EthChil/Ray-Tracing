//
// Created by ethan on 5/15/2020.
//

#include "SphereObj.hpp"
#include "Tracer.hpp"
#include <iostream>
#include <math.h>

using namespace std;

Sphere::Sphere(float x_, float y_, float z_, float r){
    radius = r;
    pos.x = x_;
    pos.y = y_;
    pos.z = z_;
}

Sphere::Sphere(coord p, float r){
    radius = r;
    pos = p;
}

float Sphere::getCollision(coord origin, coord direction){
    origin.x -= pos.x;
    origin.y -= pos.y;
    origin.z -= pos.z;

    float a = (pow(direction.x, 2) + pow(direction.y, 2) + pow(direction.z, 2));
    float b = (2 * origin.x * direction.x) + (2 * origin.y * direction.y) + (2 * origin.z * direction.z);
    float c = (pow(origin.x, 2) + pow(origin.y, 2) + pow(origin.z, 2) - pow(radius, 2));

    if((pow(b, 2) - 4 * a * c) < 0)
        return -1;
    else{
        //cout << "a " << a << " b " << b << " c " << c << endl;
        float sol1 = ((-1 * b) + sqrt(pow(b, 2) - (4 * a * c)))/(2*a);
        float sol2 = ((-1 * b) - sqrt(pow(b, 2) - (4 * a * c)))/(2*a);

        //cout << "sol1 " << sol1 << "sol2 " << sol2 << endl;

        if(sol1 <= sol2)
            return sol1;
        else
            return sol2;
    }
}

coord Sphere::getNormal(const coord& point) const{
    return coord {point.x - pos.x,point.y - pos.y,point.z - pos.z};
}