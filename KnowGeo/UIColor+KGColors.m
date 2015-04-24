//
//  UIColor+KGColors.m
//  KnowGeo
//
//  Created by Corey Norford on 4/23/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "UIColor+KGColors.h"

@implementation UIColor (KGColors)

+ (UIColor *)kgBrownColor {
    static UIColor *brownColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        brownColor = [UIColor colorWithRed:14/255 green:7/255 blue:0/255 alpha:1];
    });
    
    return brownColor;
}

+ (UIColor *)kgOrangeColor {
    static UIColor *orangeColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orangeColor = [UIColor colorWithRed:1 green:0.373 blue:0.259 alpha:1];
        //[UIColor colorWithRed:254/255 green:100/255 blue:72/255 alpha:1];
    });
    
    return orangeColor;
}

@end
