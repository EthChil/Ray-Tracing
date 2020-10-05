//
// Created by ethan on 9/12/2020.
//

#include "Vector.hpp"

#ifndef WHITTEDPROPER_POINT_HPP
#define WHITTEDPROPER_POINT_HPP

template<typename T> class Point3;

template<typename T> class Point2{
public:
    T x;
    T y;

    Point2() : x(0), y(0) {}
    Point2(T x, T y) : x(x), y(y) {}

    explicit Point2(const Point3<T> &p) : x(p.x), y(p.y) {}

};

template<typename T> class Point3{
public:
    T x;
    T y;
    T z;

    Point3() : x(0), y(0), z(0) {}
    Point3(T x, T y, T z) : x(x), y(y), z(z) {}

    template<typename U> explicit Point3(const Point3<U> &p) : x((T)p.x), y((T)p.y), z((T)p.z) {}

    template <typename U> explicit operator Vector3<U>() const {
        return Vector3<U>(x, y, z);
    }

    Point3<T> operator+(const Vector3<T> &v) const {
        return Point3<T>(x + v.x, y + v.y, z + v.z);
    }

    Vector3<T> operator-(const Point3<T> &p) const {
        return Vector3<T>(x - p.x, y - p.y, z - p.z);
    }

    bool HasNaNs() const {
        return isnan(x) || isnan(y) || isnan(z);
    }
};

using Point2f = Point2<float>;
using Point2i = Point2<int>;
using Point3f = Point3<float>;
using Point3i = Point3<int>;

#endif //WHITTEDPROPER_POINT_HPP
