//
// Created by ethan on 9/12/2020.
//

#include "Normal.hpp"

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