//
// Created by ethan on 8/14/2020.
//

/*
#include "Core.hpp"
#include <iostream>

using namespace std;


template<typename T> inline Vector3<T>
operator*(T s, const Vector3<T> &v){
    return v * s;
}

template<typename T> Vector3<T> Abs(const Vector3<T> &v) {
    return Vector3<T>(abs(v.x), abs(v.y), abs(v.z));
}

template<typename T> inline T Dot(const Vector3<T> &v1, const Vector3<T> &v2) {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
}

template<typename T> inline T AbsDot(const Vector3<T> &v1, const Vector3<T> &v2) {
    return Abs(Dot(v1, v2));
}

template<typename T> inline Vector3<T> Cross(const Vector3<T> &v1, const Vector3<T> &v2){
    return Vector3<T>((v1.y * v2.z) - (v1.z * v2.y),
                      (v1.z * v2.x) - (v1.x * v2.z)
                              (v1.x * v2.y) - (v1.y * v2.x));
}

template<typename T> inline Vector3<T> Normalize(const Vector3<T> &v) {
    return v / v.length();
}

template<typename T> inline void
CoordinateSystem(const Vector3<T> &v1, Vector3<T> &v2, Vector3<T> &v3){
    if (abs(v1.x) > abs(v1.y))
        *v2 = Vector3<T>(-v1.z, 0, v1.x) /
              sqrt(v1.x * v1.x + v1.z * v1.z);
    else
        *v2 = Vector3<T>(0, v1.z, -v1.y) /
              sqrt(v1.y * v1.y + v1.z * v1.z);
    *v3 = Cross(v1, *v2);
}

//Normalizes the normal (length 1)
template<typename T> inline Normal3<T>
Normalize(const Normal3<T> &n)
{
    return n / n.length();
}

template<typename T> inline
std::ostream& operator<<(std::ostream &os, const Normal3<T> &n) {
    os << "[" << n.x << ", " << n.y << ", " << n.z << "]";
    return os;
}

template <typename T> inline
Normal3<T> Faceforward(const Normal3<T> &n, const Vector3<T> &v) {
    return (Dot(n, v) < 0.f) ? -n : n;
}

template<typename T> inline
std::ostream& operator<<(std::ostream &os, const Vector3<T> &v) {
    os << "[" << v.x << ", " << v.y << ", " << v.z << "]";
    return os;
}

template<typename T> inline
std::ostream& operator<<(std::ostream &os, const Point3<T> &p) {
    os << "[" << p.x << ", " << p.y << ", " << p.z << "]";
    return os;
}

std::ostream& operator<<(std::ostream &os, const Ray &r) {
    os << "[o=" << r.o << ", d=" << r.d << ", tMax="
       << r.tMax << ", time=" << r.time << "]";
    return os;
}

/**/