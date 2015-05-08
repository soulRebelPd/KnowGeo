//
//  KGCalloutView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+KGColors.h"

IB_DESIGNABLE

@interface KGCalloutView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
//displays option to Delete or Choose Parent or Clear Parent or Drop A Child Pin

@property (nonatomic) IBInspectable NSString *title;
@property NSArray *pickerData;
@property (strong, nonatomic) IBOutlet KGCalloutView *view;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *pinTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseTypeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (weak, nonatomic) IBOutlet UILabel *isLinePinLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isLinePinSwitch;
@property (weak, nonatomic) IBOutlet UIButton *startLineButton;
@property (weak, nonatomic) IBOutlet UIButton *selectParentButton;
@property (weak, nonatomic) IBOutlet UIButton *endLineButton;
@property (weak, nonatomic) IBOutlet UIButton *startLineColoring;
@property (weak, nonatomic) IBOutlet UIButton *endLineColoring;

-(void)moveToState:(NSString *)state;

-(void)didSetName;
-(void)didSetLocationType;
-(bool)deletePin;
-(void)changeToState;

@end


