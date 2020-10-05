//
// Created by ethan on 9/12/2020.
//

#include "Vector.hpp"

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
