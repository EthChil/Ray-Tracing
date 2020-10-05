//
// Created by ethan on 9/12/2020.
//

#include <algorithm>
#include "Point.hpp"
#include "limits"
#include "Ray.hpp"

#ifndef WHITTEDPROPER_BOUND_HPP
#define WHITTEDPROPER_BOUND_HPP

template<typename T> class Bounds2 {
public:
    Point2<T> pMin, pMax;

    Bounds2() {
        T minNum = std::numeric_limits<T>::lowest();
        T maxNum = std::numeric_limits<T>::max();
        pMax = Point2<T>(minNum, minNum);
        pMin = Point2<T>(maxNum, maxNum);
    }
    Bounds2(const Point2<T> &p) : pMin(p), pMax(p){};
    Bounds2(const Point2<T> &p1, const Point2<T> &p2): pMax(std::max(p1, p2)), pMin(std::min(p1, p2)){}

    template<typename U> explicit operator Bounds2<U>() const {
        return Bounds2<U>((Point2<U>)pMin, (Point2<U>)pMax);
    }

    Vector2<T> Diagonal() const {
        return pMax - pMin;
    }

    T Area() const {
        Vector2<T> d = Diagonal();
        return d.x * d.y;
    }

    int MaximumExtent() const {
        Vector2<T> diag = Diagonal();
        if(diag.x > diag.y)
            return 0;
        else
            return 1;
    }

    inline const Point2<T> & operator[](int i) const {
        Assert(i == 0 || i == 1);
        return (i == 0) ? pMin : pMax;
    }

    bool operator==(const Bounds2<T> &b) const {
        return b.pMin == pMin && b.pMax == pMax;
    }

    bool operator!=(const Bounds2<T> &b) const {
        return b.pMin != pMin || b.pMax != pMax;
    }

    Point2<T> Lerp(const Point2f &t) const {
        return Point2<T>(Lerp(t.x, pMin.x, pMax.x), Lerp(t.y, pMin.y, pMax.y));
    }

    Vector2<T> Offset(const Point2<T> &p) const {
        Vector2<T> o = p - pMin;
        if (pMax.x > pMin.x) o.x /= pMax.x - pMin.x;
        if (pMax.y > pMin.y) o.y /= pMax.y - pMin.y;
        return o;
    }

    void BoundingSphere(Point2<T> *c, float *rad) const {
        *c = (pMin + pMax) / 2;
        *rad = Inside(*c, *this) ? Distance(*c, pMax) : 0;
    }
};

template<typename T> class Bounds3 {
public:
    Point3<T> pMin, pMax;

    Bounds3() {
        T minNum = std::numeric_limits<T>::lowest();
        T maxNum = std::numeric_limits<T>::max();
        pMax = Point3<T>(minNum, minNum, minNum);
        pMin = Point3<T>(maxNum, maxNum, maxNum);
    }

    Bounds3(const Point3<T> &p) : pMin(p), pMax(p) {}
    Bounds3(const Point3<T> &p1, const Point3<T> &p2) :
        pMin(std::min(p1.x, p2.x), std::min(p1.y, p2.y), std::min(p1.z, p2.z)),
        pMax(std::max(p1.x, p2.x), std::max(p1.y, p2.y), std::max(p1.z, p2.z)) {}

    const Point3<T> &operator[](int i) const;
    Point3<T> &operator[](int i);

    bool operator==(const Bounds3<T> &b) const {
        return b.pMin == pMin && b.pMax == pMax;
    }

    bool operator!=(const Bounds3<T> &b) const {
        return b.pMin != pMin || b.pMax != pMax;
    }

    Point3<T> Corner(int corner) const {
        return Point3<T>((*this)[(corner & 1)].x,
                         (*this)[(corner & 2) ? 1 : 0].y,
                         (*this)[(corner & 4) ? 1 : 0].z);
    }

    Vector3<T> Diagonal() const { return pMax - pMin; }

    T SurfaceArea() const {
        Vector3<T> d = Diagonal();
        return 2 * (d.x * d.y + d.x * d.z + d.y * d.z);
    }

    T Volume() const {
        Vector3<T> d = Diagonal();
        return d.x * d.y * d.z;
    }

    int MaximumExtent() const {
        Vector3<T> d = Diagonal();
        if (d.x > d.y && d.x > d.z)
            return 0;
        else if (d.y > d.z)
            return 1;
        else
            return 2;
    }

    Point3<T> Lerp(const Point3f &t) const {
        return Point3<T>(Lerp(t.x, pMin.x, pMax.x),
                         Lerp(t.y, pMin.y, pMax.y),
                         Lerp(t.z, pMin.z, pMax.z));
    }

    Vector3<T> Offset(const Point3<T> &p) const {
        Vector3<T> o = p - pMin;
        if (pMax.x > pMin.x) o.x /= pMax.x - pMin.x;
        if (pMax.y > pMin.y) o.y /= pMax.y - pMin.y;
        if (pMax.z > pMin.z) o.z /= pMax.z - pMin.z;
        return o;
    }

    void BoundingSphere(Point3<T> *center, float *radius) const {
        *center = (pMin + pMax) / 2;
        *radius = Inside(*center, *this) ? Distance(*center, pMax) : 0;
    }

    template <typename U> explicit operator Bounds3<U>() const {
        return Bounds3<U>((Point3<U>)pMin, (Point3<U>)pMax);
    }

    bool IntersectP(const Ray &ray, float *hitt0 = nullptr, float *hitt1 = nullptr) const;
    inline bool IntersectP(const Ray &ray, const Vector3f &invDir,
                           const int dirIsNeg[3]) const;

};

#endif //WHITTEDPROPER_BOUND_HPP
