//
// Created by ethan on 8/14/2020.
//

#ifndef SPHEREDEMO_CORE_HPP
#define SPHEREDEMO_CORE_HPP

template<typename T> class Point2{
public:
    T x;
    T y;

    Point2() : x(0), y(0) {};
    Point2(T x, T y) : x(x), y(y) {};
};

template<typename T> class Point3{
public:
    T x;
    T y;
    T z;

    Point3() : x(0), y(0), z(0) {};
    Point3(T x, T y, T z) : x(x), y(y), z(z) {};
};

template<typename T> class Vector2{
public:
    T x;
    T y;

    Vector2() : x(0), y(0) {};
    Vector2(T x, T y) : x(x), y(y) {};
    Vector2(const Point2<T> &p) {
        x = p.x;
        y = p.y;
    };

    T &operator[](int i) {};
    Vector2<T> operator+(const Vector2<T> &v) const {
        Vector2<T> v2 = new Vector2<T>;
        v2.x = v.x + x;
        v2.y = v.y + y;

        return v2;
    };

    float mag() const {
        return sqrt(pow(x, 2) + pow(y,2));
    };
};

template<typename T> class Vector3{
public:
    T x;
    T y;
    T z;

    Vector3() : x(0), y(0), z(0) {};
    Vector3(T x, T y, T z) : x(x), y(y), z(z) {};
    Vector3(const Point3<T> &p) {
        x = p.x;
        y = p.y;
        z = p.z;
    };

    T &operator[](int i) {};
    Vector3<T> operator+(const Vector3<T> &v) const {
        Vector3<T> v2 = new Vector3<T>;
        v2.x = v.x + x;
        v2.y = v.y + y;
        v2.z = v.z + z;

        return v2;
    };

    float mag() const {
        return sqrt(pow(x, 2) + pow(y,2) + pow(z, 2));
    };
};

using Vector2f = Vector2<float>;
using Vector2i = Vector2<int>;
using Vector3f = Vector3<float>;
using Vector3i = Vector3<int>;
using Point2f = Point2<float>;
using Point2i = Point2<int>;
using Point3f = Point3<float>;
using Point3i = Point3<int>;


#endif //SPHEREDEMO_CORE_HPP
