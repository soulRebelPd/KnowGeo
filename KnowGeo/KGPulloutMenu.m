//
//  KGPulloutMenu.m
//  KnowGeo
//
//  Created by Corey Norford on 6/2/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGPulloutMenu.h"

@implementation KGPulloutMenu

-(void)awakeFromNib{
    [self moveToLowPosition:NO];
    [self.menuView.layer setCornerRadius:10.0f];
}

-(void)moveToLowPosition:(bool)animated{
    CGFloat centerX = 0;
    CGFloat hiddenY = 0;

    CGFloat width = 300;
    CGFloat height = 275;

    CGRect newFrame = CGRectMake(centerX, hiddenY, width, height);

    if(animated == YES){
        [UIView beginAnimations:@"hide" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];

        [self.menuView setFrame:newFrame];

        [UIView commitAnimations];
    }
    else{
        [self.menuView setFrame:newFrame];
    }
    
    self.menuInHighPosition = NO;
}

-(void)moveToHighPosition:(bool)animated{
    CGFloat centerX = 0;
    CGFloat visibleY = -275;
    
    CGFloat width = 300;
    CGFloat height = 275;
    
    CGRect newFrame = CGRectMake(centerX, visibleY, width, height);
    
    if(animated == YES){
        [UIView beginAnimations:@"show" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        [self.menuView setFrame:newFrame];
        
        [UIView commitAnimations];
    }
    else{
        [self setFrame:newFrame];
    }
    
    self.menuInHighPosition = YES;
}

- (IBAction)pulled:(id)sender {
    if(self.menuInHighPosition == NO){
        [self moveToHighPosition:YES];
    }
    else{
        [self moveToLowPosition:YES];
    }
}

@end
