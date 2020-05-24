//
// Created by ethan on 5/15/2020.
//
//Overview of setup
//main instantiates other functions
//
//Sphere object handles
//position
//colour
//reflectivity
//takes a ray equation in and computes the resultant ray
//
//Point light object handles
//position
//brightness
//colour
//Takes a ray equation in and determines if it hits the light
//
//Tracer handles camera ray generation and checking ray collisions

#include "Libraries/lodepng.cpp"
#include <iostream>
#include <cmath>
#include "Tracer.hpp"
#include "SphereObj.hpp"
#include "PointLight.hpp"
#include "PlaneObj.hpp"

using namespace std;

int main(){
    //pixel size of detector
    //HD 1920 x 1080
    //4k
    //
    //
    //
    int detectorW = 1920;//16k
    int detectorH = 1080;//16k

    //film width (used to determine origin point
    float filmWidth = 10;
    //distance of eye to film center
    float eyeToFilm = 20;

    //eye lies behind film
    coord eyePoint = {-20,0,0};

    vector<std::uint8_t> PngBuffer(detectorW * 4 * detectorH);

    vector<Sphere> objects = {Sphere(40, 0, 0, 5)};
    vector<PointLight> lights = {PointLight(45, 20, 0, 175, 255, 255, 255)};
    Plane ground(coord{0,0, -10},coord{0,0,1}, pixel{0,255,125,255});

    for(int i = 0; i < 365; i++){
        lights[0].setPos(coord{float(sin((3.14159265 / 180.0) * float(i)) * 20) + 40, float(cos((3.14159265 / 180.0) * float(i))* 20),  float(cos((3.14159265 / 180.0) * float(i))* -5)});
        cout << lights[0].getPos().x << endl;
        cout << lights[0].getPos().y << endl;
        //lights[0].setPos(coord{20, 10, -10});

        //For now assume the camera is always poining in the direction of the x-axis
        //Iterate over each pixel on frame
        for(int h = 0; h < detectorH; h++){
            for(int w = 0; w < detectorW; w++){
                coord rayOrigin = {eyePoint.x + eyeToFilm, eyePoint.y + (((filmWidth * w) / detectorW) - (filmWidth / 2)), eyePoint.z + (((filmWidth * h) / detectorW) - (((filmWidth * detectorH) / detectorW) / 2))};
                coord rayDirection = {rayOrigin.x - eyePoint.x, rayOrigin.y - eyePoint.y, rayOrigin.z - eyePoint.z};
                //coord rayDirection = {1,0,0};

                //cout << "w " << rayOrigin.y << endl;
                //cout << "h " << rayOrigin.z << endl;

                pixel p = traceRay(rayOrigin, rayDirection, objects, lights, ground);

                PngBuffer[(w * 4) + (h * detectorW * 4)] = p.R;
                PngBuffer[(w * 4) + 1 + (h * detectorW * 4)] = p.G;
                PngBuffer[(w * 4) + 2 + (h * detectorW * 4)] = p.B;
                PngBuffer[(w * 4) + 3 + (h * detectorW * 4)] = p.A;
            }
        }


        unsigned error = lodepng::encode("tony" + to_string(i) + ".png", PngBuffer, detectorW, detectorH);
        cout << lodepng_error_text(error) << endl;
        cout << "frame #" << i << endl;
    }

    return 0;
}
