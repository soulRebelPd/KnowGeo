//
//  KGCalloutView.m
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGCalloutView.h"

@implementation KGCalloutView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = self.bounds;
    CGContextSetLineWidth(context, _lineWidth);
    CGRectInset(myFrame, 5, 5);
    [_fillColor set];
    UIRectFrame(myFrame);
}

-(void)prepareForInterfaceBuilder{
}

-(void)layoutSubviews{
    self.titleField.text = _title;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleField.text = title;
}

-(void)moveToState:(NSString *)state{
    if([state isEqualToString:@"Empty"]){
        [self moveToStateEmpy];
    }
    else if([state isEqualToString:@"Regular-Location-Dropped"]
       || [state isEqualToString:@"Regular-Location-Selected"]){
        [self moveToStateRegularLocationAny];
    }
    else if([state isEqualToString:@"Regular-Line-Dropped"]){
        [self moveToStateRegularLineDropped];
    }
    else if([state isEqualToString:@"Drawing-Line-Dropped"]){
        [self moveToStateDrawingLineDropped];
    }
    else if([state isEqualToString:@"Regular-Line-Selected_NoParent"]){
        [self moveToStateRegularLineSelected_NoParent];
    }
    else if([state isEqualToString:@"Regular-Line-Selected_WithParent"]){
        [self moveToStateRegularLineSelected_WithParent];
    }
    else if([state isEqualToString:@"Coloring-Line-Selected"]){
        [self moveToStateColoringLineSelected];
    }
}

-(void)moveToStateEmpy{
    self.titleField.hidden = YES;
    self.pinTypeLabel.hidden = YES;
    self.chooseTypeLabel.hidden = YES;
    self.typePickerView.hidden = YES;
    self.isLinePinLabel.hidden = YES;
    self.isLinePinSwitch.hidden = YES;
    
    self.startLineButton.hidden = YES;
    self.selectParentButton.hidden = YES;
    self.endLineButton.hidden = YES;
    self.startLineColoring.hidden = YES;
    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLocationAny{
    self.titleField.hidden = NO;
    self.pinTypeLabel.hidden = NO;
    self.chooseTypeLabel.hidden = NO;
    self.typePickerView.hidden = NO;
    self.isLinePinLabel.hidden = NO;
    self.isLinePinSwitch.hidden = NO;
    
    self.startLineButton.hidden = YES;
    self.selectParentButton.hidden = YES;
    self.endLineButton.hidden = YES;
    self.startLineColoring.hidden = YES;
    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLineDropped{
    self.titleField.hidden = YES;
    self.pinTypeLabel.hidden = YES;
    self.chooseTypeLabel.hidden = YES;
    self.typePickerView.hidden = YES;
    self.isLinePinLabel.hidden = YES;
    self.isLinePinSwitch.hidden = YES;
    
    self.startLineButton.hidden = NO;
    self.selectParentButton.hidden = NO;
    self.endLineButton.hidden = YES;
    self.startLineColoring.hidden = YES;
    self.endLineColoring.hidden = YES;
}

-(void)moveToStateDrawingLineDropped{
    self.titleField.hidden = YES;
    self.pinTypeLabel.hidden = YES;
    self.chooseTypeLabel.hidden = YES;
    self.typePickerView.hidden = YES;
    self.isLinePinLabel.hidden = YES;
    self.isLinePinSwitch.hidden = YES;
    
    self.startLineButton.hidden = YES;
    self.selectParentButton.hidden = YES;
    self.endLineButton.hidden = NO;
    self.startLineColoring.hidden = YES;
    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLineSelected_NoParent{
    self.titleField.hidden = YES;
    self.pinTypeLabel.hidden = YES;
    self.chooseTypeLabel.hidden = YES;
    self.typePickerView.hidden = YES;
    self.isLinePinLabel.hidden = NO;
    self.isLinePinSwitch.hidden = NO;
    
    self.startLineButton.hidden = YES;
    self.selectParentButton.hidden = YES;
    self.endLineButton.hidden = YES;
    self.startLineColoring.hidden = YES;
    self.endLineColoring.hidden = YES;
    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLineSelected_WithParent{
    self.titleField.hidden = YES;
    self.pinTypeLabel.hidden = YES;
    self.chooseTypeLabel.hidden = YES;
    self.typePickerView.hidden = YES;
    self.isLinePinLabel.hidden = YES;
    self.isLinePinSwitch.hidden = YES;
    
    self.startLineButton.hidden = YES;
    self.selectParentButton.hidden = YES;
    self.endLineButton.hidden = YES;
    self.startLineColoring.hidden = NO;
    self.endLineColoring.hidden = YES;
}

-(void)moveToStateColoringLineSelected{
    self.titleField.hidden = YES;
    self.pinTypeLabel.hidden = YES;
    self.chooseTypeLabel.hidden = YES;
    self.typePickerView.hidden = YES;
    self.isLinePinLabel.hidden = YES;
    self.isLinePinSwitch.hidden = YES;
    
    self.startLineButton.hidden = YES;
    self.selectParentButton.hidden = YES;
    self.endLineButton.hidden = YES;
    self.startLineColoring.hidden = YES;
    self.endLineColoring.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
