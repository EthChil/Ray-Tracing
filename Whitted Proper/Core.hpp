//
// Created by ethan on 8/14/2020.
//

/*
#ifndef SPHEREDEMO_CORE_HPP
#define SPHEREDEMO_CORE_HPP

#include <limits>
#include <cmath>

using namespace std;

static constexpr float MaxFloat = std::numeric_limits<float>::max();
static constexpr float Infinity = std::numeric_limits<float>::infinity();

template<typename T> class Point3;
template<typename T> class Normal3;
template<typename T> class Vector3;

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

template<typename T> class Vector2{
public:
    T x;
    T y;

    Vector2() : x(0), y(0) {}
    Vector2(T x, T y) : x(x), y(y) {}
    Vector2(const Point2<T> &p) {
        x = p.x;
        y = p.y;
    }

    T &operator[](int i) {}

    Vector2<T> operator+(const Vector2<T> &v) const {
        return Vector2<T>(v.x + x, v.y + y);
    }

    Vector2<T> operator*(T s){
        return Vector2<T>(x * s, y * s);
    }

    Vector2<T> operator/(T s){
        Assert(s != 0);
        return Vector2<T>(x / s, y / s);
    }

    float mag() const {
        return sqrt(pow(x, 2) + pow(y,2));
    }

    float lengthSquared() const{
        return x*x + y*y;
    }

    float length() const {
        return sqrt(lengthSquared());
    }
};

//TODO: what does inline do and could this be written inside the object block above

template<typename T> inline Vector2<T>
    operator*(T s, const Vector2<T> &v){
        return v * s;
    };

template<typename T> Vector2<T> Abs(const Vector2<T> &v) {
    return Vector2<T>(abs(v.x), abs(v.y), abs(v.z));
};

template<typename T> inline T Dot(const Vector2<T> &v1, const Vector2<T> &v2) {
    return v1.x * v2.x + v1.y * v2.y;
}

template<typename T> inline T AbsDot(const Vector2<T> &v1, const Vector2<T> &v2) {
    return Abs(Dot(v1, v2));
}

template<typename T> inline Vector2<T> Normalize(const Vector2<T> &v) {
    return v / v.length();
}


template<typename T> class Vector3{
public:
    T x;
    T y;
    T z;

    Vector3() : x(0), y(0), z(0) {}

    Vector3(T x, T y, T z) : x(x), y(y), z(z) {}

//    Vector3(const Point3<T> &p) {
//        x = p.x;
//        y = p.y;
//        z = p.z;
//    }

    T &operator[](int i) {};

    Vector3<T> operator+(const Vector3<T> &v) const {
        Vector3<T> v2 = new Vector3<T>;
        v2.x = v.x + x;
        v2.y = v.y + y;
        v2.z = v.z + z;

        return v2;
    }

    Vector3<T> operator*(T s) const {
        return Vector3<T>(x * s, y * s, z * s);
    }

    Vector3<T> operator/(T s){
        Assert(s != 0);
        return Vector3<T>(x / s, y / s, z / s);
    }

    Vector3<T> operator-(const Vector3<T> &v) const {
        return Vector3<T>(x - v.x, y - v.y, z - v.z);
    }

    float mag() const {
        return sqrt(pow(x, 2) + pow(y,2) + pow(z, 2));
    }

    float lengthSquared() const{
        return x*x + y*y + z*z;
    }

    float length() const {
        return sqrt(lengthSquared());
    }

    bool HasNaNs() const {
        return isnan(x) || isnan(y) || isnan(z);
    }

    explicit Vector3(const Point3<T> &p);
    explicit Vector3(const Normal3<T> &n);
};

//vector and point types
using Vector2f = Vector2<float>;
using Vector2i = Vector2<int>;
using Vector3f = Vector3<float>;
using Vector3i = Vector3<int>;
using Point2f = Point2<float>;
using Point2i = Point2<int>;
using Point3f = Point3<float>;
using Point3i = Point3<int>;

//NORMALS
template<typename T> class Normal3 {
public:
    T x, y, z;

    Normal3():x(0),y(0),z(0) {};
    Normal3(T xx, T yy, T zz):x(xx),y(yy),z(zz) {};
    explicit Normal3<T>(Vector3<T> &v) : x(v.x), y(v.y), z(v.z){
        Assert(!v.HasNaNs());
    }

    Normal3<T> operator-() const {
        return Normal3(-x, -y, -z);
    }

    Normal3<T> operator+(const Normal3<T> &n) const {
        return Normal3<T>(x + n.x, y + n.y, z + n.z);
    }

    Normal3<T> operator+=(const Normal3<T> &n) {
        x += n.x;
        y += n.y;
        z += n.z;
        return *this;
    }

    Normal3<T> operator-(const Normal3<T> &n) const {
        return Normal3<T>(x - n.x, y - n.y, z - n.z);
    }

    Normal3<T> operator-=(const Normal3<T> &n) {
        x -= n.x;
        y -= n.y;
        z -= n.z;
        return *this;
    }

    bool HasNaNs() const {
        return isnan(x) || isnan(y) || isnan(z);
    }

    Normal3<T> operator*(T f) const {
        return Normal3<T>(x * f, y * f, z * f);
    }

    Normal3<T> operator*=(T f) {
        x *= f;
        y *= f;
        z *= f;
        return *this;
    }

    Normal3<T> operator/(T f) const {
        Assert(f != 0);
        return Normal3<T>(x/f, y/f, z/f);
    }

    Normal3<T> operator/=(T f) {
        Assert(f != 0);
        x /= f;
        y /= f;
        z /= f;
        return *this;
    }

    float LengthSquared() const {return x*x + y*y + z*z;}
    float length() const {sqrt(LengthSquared());}
};

using Normal3f = Normal3<float>;

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
        return (o.HasNaNs() || d.HasNaNs() || isnan(tMax));
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



#endif //SPHEREDEMO_CORE_HPP

/**/