//
//  KGCalloutTesterView.m
//  KnowGeo
//
//  Created by Corey Norford on 4/21/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGCalloutTesterView.h"

@implementation KGCalloutTesterView

@synthesize delegate;

- (IBAction)clearStateClicked:(id)sender {
    [self.delegate kGCalloutTesterView:self clearStatePressed:YES];
}

- (IBAction)testRegularLocationAny:(id)sender {
    [self.delegate kGCalloutTesterView:self testRegularLocationAnyPressed:YES];
}

- (IBAction)testRegularLineDropped:(id)sender {
    [self.delegate kGCalloutTesterView:self testRegularLineDroppedPressed:YES];
}

- (IBAction)testDrawingLineDropped:(id)sender {
    [self.delegate kGCalloutTesterView:self testDrawingLineDroppedPressed:YES];
}

- (IBAction)testColoringLineSelected:(id)sender {
    [self.delegate kGCalloutTesterView:self testColoringLineSelectedPressed:YES];
}

- (IBAction)testRegularLineSelected_WithParent:(id)sender {
    [self.delegate kGCalloutTesterView:self testRegularLineSelected_WithParentPressed:YES];
}

- (IBAction)testRegularLineSelected_NoParent:(id)sender {
    [self.delegate kGCalloutTesterView:self testRegularLineSelected_NoParentPressed:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
