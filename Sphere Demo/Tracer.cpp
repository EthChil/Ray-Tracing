//
// Created by ethan on 5/15/2020.
//
//Camera model
//

#include <iostream>
#include "Tracer.hpp"
#include "SphereObj.cpp"
#include "PointLight.cpp"
#include "PlaneObj.hpp"

pixel traceRay(const coord origin, const coord direction, const vector<Sphere>& obj, const vector<PointLight>& lights, const Plane& ground) {
    for(auto objIter : obj){

        float t = objIter.getCollision(origin, direction);

        if(t >= 0){
            pixel tempColor = {0,0,0,0};

            for(auto lightIter : lights){
                coord intersect = {origin.x + t*direction.x, origin.y + t*direction.y, origin.z + t*direction.z};
                //tempColor = lightIter.bounceLight(intersect, coord{0,0,0}, 5);

                if(objIter.getCollision(intersect, lightIter.direction2Light(intersect)) >= -0.0001)
                    tempColor = lightIter.bounceLight(intersect, objIter.getNormal(intersect), true);
                else
                    tempColor = lightIter.bounceLight(intersect, objIter.getNormal(intersect), false);
            }

            return tempColor;
        }
        else
        {
            float t = ground.getCollision(origin, direction);
            //cout << t << endl;

            if(t >= 0){
                pixel tempColor = {0,0,0,0};

                for(auto lightIter : lights){
                    coord intersect = {origin.x + t*direction.x, origin.y + t*direction.y, origin.z + t*direction.z};
                    //tempColor = lightIter.bounceLight(intersect, coord{0,0,0}, 5);

                    if(objIter.getCollision(intersect, lightIter.direction2Light(intersect)) > 0)
                        tempColor = lightIter.bounceLight(intersect, ground.getNormal(), true);
                    else
                        tempColor = lightIter.bounceLight(intersect, ground.getNormal(), false);
                }

                return tempColor;
            } else{
                return pixel {0, 0, 0, 0};
            }
        }
    }
}