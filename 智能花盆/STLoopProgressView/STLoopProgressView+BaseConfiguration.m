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
//    return [UIColor colorWithRed:236.0/255.0 green:86.0/255.0 blue:114.0/255.0 alpha:1];
    return [UIColor colorWithRed:232.0/255.0 green:40.0/255.0 blue:39.0/255.0 alpha:1];
}

+ (UIColor *)centerColor {
//    return [UIColor colorWithRed:109.0/255.0 green:190.0/255.0 blue:128.0/255.0 alpha:1];
    return [UIColor colorWithRed:149.0/255.0 green:202.0/255.0 blue:62.0/255.0 alpha:1];
}

+ (UIColor *)endColor {
//    return [UIColor colorWithRed:139.0/255.0 green:163.0/255.0 blue:208.0/255.0 alpha:1];
    return [UIColor colorWithRed:39.0/255.0 green:189.0/255.0 blue:224.0/255.0 alpha:1];
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
