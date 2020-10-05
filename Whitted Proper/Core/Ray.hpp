//
// Created by ethan on 9/12/2020.
//

#include "Point.hpp"
#include "Vector.hpp"
#include <cmath>
#include <limits>

#ifndef WHITTEDPROPER_RAY_HPP
#define WHITTEDPROPER_RAY_HPP

static constexpr float MaxFloat = std::numeric_limits<float>::max();
static constexpr float Infinity = std::numeric_limits<float>::infinity();

class Ray {
public:
    Point3f o;
    Vector3f d;
    mutable float tMax;
    float time;
    const Medium *medium; //TODO

    Ray() : tMax(Infinity), time(0.f), medium(nullptr){};
    Ray(const Point3f &o, const Vector3f &d, float tMax = Infinity, float time = 0.f, const Medium *medium = nullptr)
            : o(o), d(d), tMax(tMax), time(time), medium(medium) {}
    Point3f operator()(float t) const { return o + d*t;}
    bool HasNaNs() const {
        return (o.HasNaNs() || d.HasNaNs() || std::isnan(tMax));
    }


};

//Used to handle antialiasing, casts additional rays which are averaged
class RayDifferential : public Ray {
    bool hasDifferentials;
    Point3f rxOrigin, ryOrigin;
    Vector3f rxDirection, ryDirection;

    RayDifferential() {hasDifferentials = false;}
    RayDifferential(const Point3f &o, const Vector3f &d, float tMax = Infinity, float time = 0.f, const Medium *medium = nullptr):
            Ray(o, d, tMax, time, medium) {
        hasDifferentials = false;
    }
    RayDifferential(const Ray &r) : Ray(r){
        hasDifferentials = false;
    }
    bool HasNaNs() const {
        return Ray::HasNaNs() ||
               (hasDifferentials && (rxDirection.HasNaNs() || ryDirection.HasNaNs() || rxOrigin.HasNaNs() || ryOrigin.HasNaNs()));
    }
    void ScaleDifferentials(float s) {
        rxOrigin = o + (rxOrigin - o) * s;
        ryOrigin = o + (ryOrigin - o) * s;
        rxDirection = d + (rxDirection - d) * s;
        ryDirection = d + (ryDirection - d) * s;
    }
};

#endif //WHITTEDPROPER_RAY_HPP
