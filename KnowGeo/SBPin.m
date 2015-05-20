//
//  DummyPins.m
//  KnowGeo
//
//  Created by Corey Norford on 5/13/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "SBPin.h"

@implementation SBPin

-(void)delete{
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    if ([key isEqualToString:@"title"]) {
        return NO;
    }
    else{
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

@end
