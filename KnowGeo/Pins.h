//
//  Pins.h
//  KnowGeo
//
//  Created by Corey Norford on 5/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Pin.h"

@interface Pins : NSMutableArray

-(NSUInteger)count;

+(Pins *)fetchAllWithContext:(NSManagedObjectContext *)context;

@end
