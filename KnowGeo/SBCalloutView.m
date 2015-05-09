//
//  SBCalloutView.m
//  KnowGeo
//
//  Created by Corey Norford on 5/8/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "SBCalloutView.h"

@implementation SBCalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    tap.numberOfTapsRequired = 1; //user needs to press for half a second.
    [self addGestureRecognizer:tap];
    return self;
}

-(void)handleLongPress{
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.frame = CGRectMake(0, 0, 40, 40);
    self.backgroundColor = [UIColor redColor];
    self.canShowCallout = YES;
}

//- (void)drawRect:(CGRect)rect
//{
//    //// Oval Drawing
//    CGRect imageBox = CGRectMake(5, 5, 25, 25);
//    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:imageBox];
//    [[UIColor blueColor] setFill];
//    [ovalPath fill];
//    [[UIColor blueColor] setStroke];
//    ovalPath.lineWidth = 6;
//    [ovalPath stroke];
//    
//    //CGFloat radius = imageBox.size.width / 2;
//    //UIImage *img = [UIView rasterizedStatusImageForCheckpoint:self.checkpoint withSize:imageBox.size];
//    //img = [img makeRoundedImage:img radius:radius];
//    //[img drawInRect:imageBox];
//}

@end
