//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)

+ (UIColor *)startColor {
    
    
    return [UIColor redColor];
}

+ (UIColor *)centerColor {
    
    return [UIColor greenColor];
}

+ (UIColor *)endColor {
    return [UIColor blueColor];
}

+ (UIColor *)backgroundColor {
    
    return [UIColor colorWithRed:38.0 / 255.0 green:130.0 / 255.0 blue:213.0 / 255.0 alpha:0.5];
}

+ (CGFloat)lineWidth {
    
    return 20;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-220);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(40);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
