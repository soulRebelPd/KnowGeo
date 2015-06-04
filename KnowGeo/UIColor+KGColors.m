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
        // best to use a website to convert rgb to UIColor
        orangeColor = [UIColor colorWithRed:0.937 green:0.38 blue:0.102 alpha:1];
    });
    
    //255 165 2
    //orangeColor = [UIColor colorWithRed:1 green:0.373 blue:0.259 alpha:1];
    //orangeColor = [UIColor colorWithRed:0.921 green:0.035 blue:0.098 alpha:1];
    
    return orangeColor;
}

+ (UIColor *)kgMediumBrownColor {
    static UIColor *mediumBrownColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediumBrownColor = [UIColor colorWithRed:0.153 green:0.118 blue:0.047 alpha:1]; /*#271e0c*/
    });
    
    return mediumBrownColor;
}

@end
