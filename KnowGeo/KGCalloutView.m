//
//  KGCalloutView.m
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import "KGCalloutView.h"
#define buttonCornerRadius 4

@implementation KGCalloutView

-(void)layoutSubviews{
    [self.layer setCornerRadius:10.0f];
    self.backgroundColor = [UIColor kgBrownColor];
    
    self.titleField.text = _title;
    self.titleField.textColor = [UIColor kgOrangeColor];

    self.pickerData = @[@"Select Type", @"Bar", @"Bait", @"Charters", @"Dock", @"Hospital", @"Pier", @"Restaurant"];
    self.typePickerView.dataSource = self;
    self.typePickerView.delegate = self;
    
    [self moveToStateRegularLocationAny];
    
    //    self.pinTypeLabel.textColor = [UIColor kgOrangeColor];
    //    self.chooseTypeLabel.textColor = [UIColor kgOrangeColor];
    
    //    self.isLinePinLabel.textColor = [UIColor kgOrangeColor];
    //
    //    self.startLineButton.layer.cornerRadius = buttonCornerRadius;
    //    self.startLineButton.backgroundColor = [UIColor kgOrangeColor];
    //
    //    self.selectParentButton.layer.cornerRadius = buttonCornerRadius;
    //    self.selectParentButton.backgroundColor = [UIColor kgOrangeColor];
    //
    //    self.endLineButton.layer.cornerRadius = buttonCornerRadius;
    //    self.endLineButton.backgroundColor = [UIColor kgOrangeColor];
    //
    //    self.startLineColoring.layer.cornerRadius = buttonCornerRadius;
    //    self.startLineColoring.backgroundColor = [UIColor kgOrangeColor];
    //
    //    self.endLineColoring.layer.cornerRadius = buttonCornerRadius;
    //    self.endLineColoring.backgroundColor = [UIColor kgOrangeColor];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        
        UIColor *color = [UIColor kgOrangeColor];
        tView.textColor = color;
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    
    NSString *title = self.pickerData[row];
    
    if([title isEqualToString:@"Select Type"]){
        tView.font = [UIFont boldSystemFontOfSize:17.0];
    }
    
    tView.text = title;
    
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (40.0);
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
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
    self.typePickerView.hidden = YES;
    
    self.chooseTypeLabel.hidden = YES;
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
    self.typePickerView.hidden = NO;
    
    self.chooseTypeLabel.hidden = YES;
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

-(void)didSetName{
}

-(void)didSetLocationType{
}

-(bool)deletePin{
    return YES;
}

-(void)changeToState{
    //“Regular - Drop - Location Pin”
    //“Regular - Select - Location Pin” / same as “Regular - Dropped - Location Pin”
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//    }
//
//    return self;
//}

//BOOL _initialize;

//- (void)awakeFromNib {
//    @synchronized(self) {
//        if (!_initialize) {
//            _initialize = YES;
//            [[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil];
//            [self.view setFrame:[self bounds]];
//            [self addSubview:self.view];
//        }
//    }
//}


//- (void)awakeFromNib {
//    if ([[NSBundle mainBundle] loadNibNamed:@"KGCalloutView" owner:self options:nil]) {
//        [self.view setFrame:[self bounds]];
//        [self addSubview:self.view];
//    }
//}

//-(void)prepareForInterfaceBuilder{
//}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect myFrame = self.bounds;
//    CGContextSetLineWidth(context, _lineWidth);
//    CGRectInset(myFrame, 5, 5);
//    [_fillColor set];
//    UIRectFrame(myFrame);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
