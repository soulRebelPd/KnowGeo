//
//  DummyPins.h
//  KnowGeo
//
//  Created by Corey Norford on 5/13/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "Pin.h"

@interface SBPin : NSObject

@property (nonatomic, retain) NSNumber * isCloudSaved;
@property (nonatomic, retain) NSNumber * isLocallySaved;
@property (nonatomic, retain) NSNumber * locationTypeId;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * subtypeId;
@property (nonatomic, retain) NSNumber * isExported;

-(void)delete;

@end
