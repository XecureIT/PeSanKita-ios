//
//  KSMTextField.h
//  Kesupermarket
//
//  Created by Cundy Sunardy on 8/9/16.
//  Copyright © 2016 Weekend Inc. All rights reserved.
//

//#import "BaseView.h"

@protocol KSMTextFieldDelegate <NSObject>

- (void)ksmTextFieldChange;

@end

@interface KSMTextField : UIView

@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelXPositionConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelYPositionConstraint;
@property (strong, nonatomic) IBOutlet UIView *bottomSeparatorView;
@property (weak, nonatomic) id <KSMTextFieldDelegate> delegate;

- (void)showBottomSeparatorView;
- (void)hideTopSeparatorView;
- (void)resetTextField;
- (void)setText:(NSString *)text;

@end
