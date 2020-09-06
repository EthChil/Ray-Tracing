//
// Created by ethan on 9/5/2020.
//

#ifndef WHITTEDPROPER_SHAPE_HPP
#define WHITTEDPROPER_SHAPE_HPP

class Shape {
public:
    Shape(const Transform *ObjectToWorld, const Transform *WorldToObject,
            bool reverseOrientation);
    virtual ~Shape();
    virtual Bounds3f


};

#endif //WHITTEDPROPER_SHAPE_HPP
