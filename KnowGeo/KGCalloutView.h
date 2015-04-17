//
//  KGCalloutView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KGCalloutView : UIView

@property (nonatomic) IBInspectable NSInteger lineWidth;
@property (nonatomic) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable NSString *title;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *pinTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseTypeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (weak, nonatomic) IBOutlet UILabel *isLinePinLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isLinePinSwitch;

-(void)moveToState:(NSString *)state;


@end
