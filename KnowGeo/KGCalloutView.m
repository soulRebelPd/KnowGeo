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

@synthesize trianglePlaceholder;

#pragma mark Setup

-(void)awakeFromNib{
    self.typePickerView.dataSource = self;
    self.typePickerView.delegate = self;
    
    self.subtypePickerView.dataSource = self;
    self.subtypePickerView.delegate = self;
    
    self.titleField.delegate = self;
    self.titleField.backgroundColor = [UIColor kgMediumBrownColor];
    
    [self.layer setCornerRadius:10.0f];
    self.backgroundColor = [UIColor kgBrownColor];
    
    self.titleField.text = _title;
    
    [self addTail];
    
    self.typePickerView.alpha = 0;
    self.subtypePickerView.alpha = 0;
    self.titleField.alpha = 0;
    self.closeButton.alpha = 0;
    self.deleteButton.alpha = 0;
    self.shapeView.alpha = 0;

    [self expandOpen];
}

-(void)layoutSubviews{
    [self setSubviewColors];
    [self moveToStateRegularLocationAny];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

#pragma mark Animations

-(void)expandOpen{
    CGFloat originalX = self.frame.origin.x;
    CGFloat originalY = self.frame.origin.y;
    
    CGRect tempBounds = CGRectMake(self.frame.origin.x + 150, self.frame.origin.y + 137.5, 0, 0);
    [self setBounds:tempBounds];
    
    [UIView beginAnimations:@"expandOpen" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    CGRect newBounds = CGRectMake(originalX, originalY, 300, 275);
    [self setBounds:newBounds];
    
    [UIView setAnimationDidStopSelector:@selector(fadeInControls)];
    [UIView commitAnimations];
}

-(void)fadeInControls{
    [UIView beginAnimations:@"fadeInControls" context:nil];
    [UIView setAnimationDuration:0.001];
    [UIView setAnimationDelegate:self];
    
    self.typePickerView.alpha = 1;
    self.subtypePickerView.alpha = 1;
    self.titleField.alpha = 1;
    self.closeButton.alpha = 1;
    self.deleteButton.alpha = 1;
    self.shapeView.alpha = 1;
    
    [UIView commitAnimations];
}

-(void)fadeOutControls{
    [UIView beginAnimations:@"fadeOutControls" context:nil];
    [UIView setAnimationDuration:0.001];
    [UIView setAnimationDelegate:self];
    
    self.typePickerView.alpha = 0;
    self.subtypePickerView.alpha = 0;
    self.titleField.alpha = 0;
    self.closeButton.alpha = 0;
    self.deleteButton.alpha = 0;
    self.shapeView.alpha = 0;
    
    [UIView setAnimationDidStopSelector:@selector(contractClosed)];
    [UIView commitAnimations];
}

-(void)contractClosed{
    [UIView beginAnimations:@"contractClosed" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    CGRect rect = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
    [self setBounds:rect];
    
    [UIView setAnimationDidStopSelector:@selector(contractComplete)];
    [UIView commitAnimations];
}

#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        UIColor *color = [UIColor kgOrangeColor];
        tView.textColor = color;
        tView.textAlignment = NSTextAlignmentCenter;
    }
    
    NSString *title;
    if(pickerView.tag == 1){
        title = self.types[row];
    }
    else{
        title = self.subTypes[row];
    }
    
    if([title isEqualToString:@"Select Type"] || [title isEqualToString:@"Select Subtype"]){
        tView.font = [UIFont boldSystemFontOfSize:16.0];
    }
    
    tView.text = title;
    
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (40.0);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSNumber *number = [NSNumber numberWithInt:1];
    return [number integerValue];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 1){
        return self.types.count;
    }
    else{
        return self.subTypes.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        [self.delegate kgCalloutView:self typeChanged:[NSNumber numberWithInteger:row]];
    }
    else{
        [self.delegate kgCalloutView:self subtypeChanged:[NSNumber numberWithInteger:row]];
    }
}

#pragma mark UI Events

- (IBAction)deletePin:(id)sender {
    [self.delegate kgCalloutView:self deleteButtonPressed:YES];
}

- (IBAction)closeCallout:(id)sender {
    [self fadeOutControls];
}

- (IBAction)titleFieldEditingDidEnd:(id)sender {
    [self.delegate kgCalloutView:self titleChanged:self.titleField.text];
}

- (IBAction)titleFieldEditingDidBegin:(id)sender {
    NSString *defaultTitle = [Pin defaultTitle];
    if([self.titleField.text isEqualToString:defaultTitle]){
        self.titleField.text = @"";
    }
}

-(void)contractComplete{
    [self.delegate kgCalloutView:self closeButtonPressed:YES];
}

#pragma mark Other

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleField.text = title;
}

-(void)setSubtype:(NSNumber *)subtype{
    _subtype = subtype;
    
    NSInteger rowNumber = [subtype integerValue];
    [self.subtypePickerView selectRow:rowNumber inComponent:0 animated:YES];
}

-(void)setType:(NSNumber *)type{
    _type = type;
    
    NSInteger rowNumber = [type integerValue];
    [self.typePickerView selectRow:rowNumber inComponent:0 animated:YES];
}

-(void)removeFromSuperview2{
    [self removeFromSuperview];
}

-(void)addTail{
    KGCalloutTail *calloutTail = [[KGCalloutTail alloc] initWithFrame: CGRectMake(self.trianglePlaceholder.frame.origin.x, self.trianglePlaceholder.frame.origin.y, 250, 250)];
    calloutTail.backgroundColor = [UIColor clearColor];
    self.shapeView = calloutTail;
    [self addSubview:self.shapeView];
}

- (void)setSubviewColors{
    self.titleField.textColor = [UIColor kgOrangeColor];
    
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

#pragma mark States

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
    
    //    self.chooseTypeLabel.hidden = YES;
    //    self.isLinePinLabel.hidden = YES;
    //    self.isLinePinSwitch.hidden = YES;
    //    self.startLineButton.hidden = YES;
    //    self.selectParentButton.hidden = YES;
    //    self.endLineButton.hidden = YES;
    //    self.startLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLocationAny{
    self.titleField.hidden = NO;
    self.typePickerView.hidden = NO;
    
    //    self.chooseTypeLabel.hidden = YES;
    //    self.isLinePinLabel.hidden = NO;
    //    self.isLinePinSwitch.hidden = NO;
    //    self.startLineButton.hidden = YES;
    //    self.selectParentButton.hidden = YES;
    //    self.endLineButton.hidden = YES;
    //    self.startLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLineDropped{
    //    self.titleField.hidden = YES;
    //    self.chooseTypeLabel.hidden = YES;
    //    self.typePickerView.hidden = YES;
    //    self.isLinePinLabel.hidden = YES;
    //    self.isLinePinSwitch.hidden = YES;
    //
    //    self.startLineButton.hidden = NO;
    //    self.selectParentButton.hidden = NO;
    //    self.endLineButton.hidden = YES;
    //    self.startLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = YES;
}

-(void)moveToStateDrawingLineDropped{
    //    self.titleField.hidden = YES;
    //    self.chooseTypeLabel.hidden = YES;
    //    self.typePickerView.hidden = YES;
    //    self.isLinePinLabel.hidden = YES;
    //    self.isLinePinSwitch.hidden = YES;
    //
    //    self.startLineButton.hidden = YES;
    //    self.selectParentButton.hidden = YES;
    //    self.endLineButton.hidden = NO;
    //    self.startLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLineSelected_NoParent{
    //    self.titleField.hidden = YES;
    //    self.chooseTypeLabel.hidden = YES;
    //    self.typePickerView.hidden = YES;
    //    self.isLinePinLabel.hidden = NO;
    //    self.isLinePinSwitch.hidden = NO;
    //
    //    self.startLineButton.hidden = YES;
    //    self.selectParentButton.hidden = YES;
    //    self.endLineButton.hidden = YES;
    //    self.startLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = YES;
}

-(void)moveToStateRegularLineSelected_WithParent{
    //    self.titleField.hidden = YES;
    //    self.chooseTypeLabel.hidden = YES;
    //    self.typePickerView.hidden = YES;
    //    self.isLinePinLabel.hidden = YES;
    //    self.isLinePinSwitch.hidden = YES;
    //
    //    self.startLineButton.hidden = YES;
    //    self.selectParentButton.hidden = YES;
    //    self.endLineButton.hidden = YES;
    //    self.startLineColoring.hidden = NO;
    //    self.endLineColoring.hidden = YES;
}

-(void)moveToStateColoringLineSelected{
    //    self.titleField.hidden = YES;
    //    self.chooseTypeLabel.hidden = YES;
    //    self.typePickerView.hidden = YES;
    //    self.isLinePinLabel.hidden = YES;
    //    self.isLinePinSwitch.hidden = YES;
    //    
    //    self.startLineButton.hidden = YES;
    //    self.selectParentButton.hidden = YES;
    //    self.endLineButton.hidden = YES;
    //    self.startLineColoring.hidden = YES;
    //    self.endLineColoring.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
