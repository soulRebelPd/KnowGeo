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

-(instancetype)initWithFrame:(CGRect)frame{
    
    return self;
}

-(void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor kgBrownColor];
    self.warningLabel.textColor = [UIColor kgOrangeColor];
    
    
    if(self.dataSource != nil && self.dataSource.count > 0){
        
        //NOTE: is this loop a memory leak?
        NSNumber *counter = [NSNumber numberWithInt:1];
        for(NSString *key in self.dataSource){
            //NOTE: can loop with same nib?
            NSArray *nibContentsForButton = [[NSBundle mainBundle] loadNibNamed:@"KGMenuButton" owner:self options:nil];
            KGMenuButton *button = [nibContentsForButton objectAtIndex:0];
            UIImage *image = [UIImage imageNamed:self.dataSource[key]];
            button.image = image;
            button.title = key;
            
            if([counter isEqual:@1]){
                button.frame = self.menuButton1.frame;
            }
            else if([counter isEqual:@2]){
                button.frame = self.menuButton2.frame;
            }
            else if([counter isEqual:@3]){
                button.frame = self.menuButton3.frame;
            }
            else if([counter isEqual:@4]){
                button.frame = self.menuButton4.frame;
            }
            
            button.delegate = self;
            [self addSubview:button];
            
            int value = [counter intValue];
            counter = [NSNumber numberWithInt:value + 1];
        }
    }
}

-(void)kgMenuButtonTapped:(KGMenuButton *)kgMenuButton{
    [self.delegate menuView:self buttonPressed:kgMenuButton];
}

-(void)layoutSubviews{
}

-(void)buttonAction:(bool)variable{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
