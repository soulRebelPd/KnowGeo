//
//  KGCalloutView.m
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGMenuView.h"
#define buttonCornerRadius 4

@implementation KGMenuView

-(void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor kgBrownColor];
    self.warningLabel.textColor = [UIColor kgOrangeColor];
}

- (IBAction)clearPressed:(UIButton *)sender {
    sender.tag = 1;
    [self.delegate menuView:self buttonPressed:sender];
}

- (IBAction)exportPressed:(UIButton *)sender {
    sender.tag = 2;
    [self.delegate menuView:self buttonPressed:sender];
}

-(void)hideLogo{
    self.logo.hidden = YES;
}

-(void)showLogo{
    self.logo.hidden = NO;
}

-(void)enableExportButton{
    if(self.exportButton.enabled == NO){
        self.exportButton.enabled = YES;
    }
}

-(void)disableExportButton{
    if(self.exportButton.enabled == YES){
        self.exportButton.enabled = NO;
    }
}

-(void)enableClearButton{
    if(self.clearButton.enabled == NO){
        self.clearButton.enabled = YES;
    }
}

-(void)disableClearButton{
    if(self.clearButton.enabled == YES){
        self.clearButton.enabled = NO;
    }
}

@end
