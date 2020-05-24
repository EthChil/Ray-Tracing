//
// Created by ethan on 5/15/2020.
//

#include <cstdint>
#include "PointLight.hpp"
#include "Tracer.hpp"
#include <cmath>
#include <iostream>
#include "stdlib.h"

using namespace std;

PointLight::PointLight(coord p, float bright, pixel col) : pos(p), brightness(bright), colour(col){}

PointLight::PointLight(float x, float y, float z, float bright, unsigned char r, unsigned char g, unsigned char b) : brightness(bright) {
    pos.x = x;
    pos.y = y;
    pos.z = z;

    colour.R = r;
    colour.G = g;
    colour.B = b;
    colour.A = 255;
}

PointLight::PointLight(float x, float y, float z, float bright, pixel col) : brightness(bright), colour(col){
    pos.x = x;
    pos.y = y;
    pos.z = z;
}

PointLight::PointLight(coord p, float bright, unsigned char r, unsigned char g, unsigned char b) : brightness(bright), pos(p){
    colour.R = r;
    colour.G = g;
    colour.B = b;
    colour.A = 255;
}

coord PointLight::getPos(){
    return pos;
}

pixel PointLight::bounceLight(coord point, coord normal, bool occluded){
    coord directionLight = {pos.x - point.x,pos.y - point.y, pos.z - point.z};

    if(occluded)
        return pixel{0,0,0,255};
    else{
        float dis = sqrt(pow(directionLight.x, 2) + pow(directionLight.y, 2) + pow(directionLight.z, 2));
        float angle = (directionLight.x * normal.x + directionLight.y * normal.y + directionLight.z * normal.z)/
                      (sqrt(pow(directionLight.x, 2) + pow(directionLight.y, 2) + pow(directionLight.z, 2)) * sqrt(pow(normal.x, 2) + pow(normal.y, 2) + pow(normal.z, 2)));
        float difIrradiance = (brightness * abs(angle)) / (4 * 3.14159265 * dis);
        //cout << "I " << difIrradiance << endl;

        return pixel{uint8_t (colour.R * difIrradiance), uint8_t(colour.G * difIrradiance), uint8_t(colour.B * difIrradiance), 255};
    }
}

coord PointLight::direction2Light(const coord& point) const{
    return coord{pos.x - point.x,pos.y - point.y, pos.z - point.z};
}

void PointLight::setPos(coord p){
    pos.x = p.x;
    pos.y = p.y;
    pos.z = p.z;
}