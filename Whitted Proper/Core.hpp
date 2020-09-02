//
// Created by ethan on 8/14/2020.
//

#ifndef SPHEREDEMO_CORE_HPP
#define SPHEREDEMO_CORE_HPP

template<typename T> class Point3;

template<typename T> class Point2{
public:
    T x;
    T y;

    Point2() : x(0), y(0) {};
    Point2(T x, T y) : x(x), y(y) {};

    explicit Point2(const Point3<T> &p) : x(p.x), y(p.y) {};

};

template<typename T> class Point3{
public:
    T x;
    T y;
    T z;

    Point3() : x(0), y(0), z(0) {};
    Point3(T x, T y, T z) : x(x), y(y), z(z) {};

    template<typename U> explicit Point3(const Point3<U> &p) : x((T)p.x), y((T)p.y), z((T)p.z) {};
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
        return Vector2<T>(v.x + x, v.y + y);
    };

    Vector2<T> operator*(T s){
        return Vector2<T>(x * s, y * s);
    };

    Vector2<T> operator/(T s){
        Assert(s != 0);
        return Vector2<T>(x / s, y / s);
    };

    float mag() const {
        return sqrt(pow(x, 2) + pow(y,2));
    };

    float lengthSquared() const{
        return x*x + y*y;
    };

    float length() const {
        return sqrt(lengthSquared());
    };
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

    Vector3<T> operator*(T s){
        return Vector3<T>(x * s, y * s);
    };

    Vector3<T> operator/(T s){
        Assert(s != 0);
        return Vector3<T>(x / s, y / s, z / s);
    };

    float mag() const {
        return sqrt(pow(x, 2) + pow(y,2) + pow(z, 2));
    };

    float lengthSquared() const{
        return x*x + y*y + z*z;
    };

    float length() const {
        return sqrt(lengthSquared());
    };
};

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

using Vector2f = Vector2<float>;
using Vector2i = Vector2<int>;
using Vector3f = Vector3<float>;
using Vector3i = Vector3<int>;
using Point2f = Point2<float>;
using Point2i = Point2<int>;
using Point3f = Point3<float>;
using Point3i = Point3<int>;


#endif //SPHEREDEMO_CORE_HPP
