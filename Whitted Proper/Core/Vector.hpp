//
// Created by ethan on 9/12/2020.
//

#ifndef WHITTEDPROPER_VECTOR_HPP
#define WHITTEDPROPER_VECTOR_HPP


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

using Vector2f = Vector2<float>;
using Vector2i = Vector2<int>;
using Vector3f = Vector3<float>;
using Vector3i = Vector3<int>;

#endif //WHITTEDPROPER_VECTOR_HPP
