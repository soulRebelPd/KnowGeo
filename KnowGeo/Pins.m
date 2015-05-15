//
//  Pins.m
//  KnowGeo
//
//  Created by Corey Norford on 5/15/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "Pins.h"

@implementation Pins

-(instancetype)initWithMutableArray:(NSMutableArray *)mutableArray{
    self = [super init];
    
    for(Pin *pin in mutableArray){
        [self addObject:pin];
    }
    
    return self;
}


-(void)testLoop{
    for(Pin *pin in self){
        NSLog(@"Pin title is:%@", pin.title);
    }
}

+(Pins *)fetchAllWithContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Pin" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSMutableArray *mutableArray = [objects mutableCopy];
    Pins *pins = [[Pins alloc] initWithMutableArray:mutableArray];
    
    return pins;
    
    //[(Pins *)objects mutableCopy];
}

-(NSUInteger)count{
    if(self != nil){
        return self.count;
    }
    else{
        return 0;
    }
    
}


@end
