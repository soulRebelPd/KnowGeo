//
//  Pins.h
//  KnowGeo
//
//  Created by Corey Norford on 5/7/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pins : NSArray

-(Pins *)getAllPins;
-(Pins *)getPinsFromDisk;
-(void)clear;
-(bool)deleteLine;
-(bool)saveToCloud;
-(void)saveToDisk;

@end


