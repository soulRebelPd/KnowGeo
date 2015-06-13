//
//  KGCalloutView.h
//  KnowGeo
//
//  Created by Corey Norford on 4/17/15.
//  Copyright (c) 2015 Ten Pandas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "UIColor+KGColors.h"
#import "KGCalloutTail.h"
#import "Pin.h"

IB_DESIGNABLE

@class KGCalloutView;

@protocol KGCalloutViewDelegate <NSObject>
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView deleteButtonPressed:(BOOL)variable;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView typeChanged:(NSNumber *)newTypeId;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView subtypeChanged:(NSNumber *)newSubtypeId;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView titleChanged:(NSString *)newTitle;
-(void)kgCalloutView:(KGCalloutView *)kGCalloutView closeButtonPressed:(BOOL)variable;
@end

@interface KGCalloutView : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UIPickerView *typePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *subtypePickerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *trianglePlaceholder;
@property (strong, nonatomic) IBOutlet KGCalloutView *view;

@property (nonatomic) IBInspectable NSString *title;
@property (strong, nonatomic) NSNumber *subtype;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSArray *subTypes;
@property (weak, nonatomic) NSObject <KGCalloutViewDelegate> *delegate;
@property (strong, nonatomic) KGCalloutTail *shapeView;

- (void)moveToState:(NSString *)state;
- (void)removeFromSuperview2;
-(void)contractClosed;

- (IBAction)deletePin:(id)sender;
- (IBAction)closeCallout:(id)sender;
- (IBAction)titleFieldEditingDidEnd:(id)sender;
- (IBAction)titleFieldEditingDidBegin:(id)sender;

@end


//@property (weak, nonatomic) IBOutlet UILabel *chooseTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *pinTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *isLinePinLabel;
//@property (weak, nonatomic) IBOutlet UISwitch *isLinePinSwitch;
//@property (weak, nonatomic) IBOutlet UIButton *startLineButton;
//@property (weak, nonatomic) IBOutlet UIButton *selectParentButton;
//@property (weak, nonatomic) IBOutlet UIButton *endLineButton;
//@property (weak, nonatomic) IBOutlet UIButton *startLineColoring;
//@property (weak, nonatomic) IBOutlet UIButton *endLineColoring;



