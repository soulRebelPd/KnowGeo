//
//  KGMenuButton.m
//  KnowGeo
//
//  Created by Corey Norford on 4/22/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGMenuButton.h"
#import "UIColor+KGColors.h"

@implementation KGMenuButton

@synthesize delegate;

-(instancetype)init{
    self.tapGestureRecognizer.delegate = self;

    return self;
}

-(void)layoutSubviews{
    self.titleLabel.text = _title;
    self.titleLabel.textColor = [UIColor kgOrangeColor];
    
    self.iconImageView.image = _image;
}

- (IBAction)tapped:(id)sender {
    self.iconImageView.opaque = YES;
    self.iconImageView.alpha = 0.5;
    self.titleLabel.opaque = YES;
    self.titleLabel.alpha = 0.5;
    
    [self.delegate kgMenuButtonTapped:self];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(ticked:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)ticked:(bool)variable{
    self.iconImageView.alpha = 1.0;
    self.titleLabel.alpha = 1.0;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
