//
// Created by ethan on 9/12/2020.
//

#include "Vector.hpp"

#ifndef WHITTEDPROPER_NORMAL_HPP
#define WHITTEDPROPER_NORMAL_HPP

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

#endif //WHITTEDPROPER_NORMAL_HPP
