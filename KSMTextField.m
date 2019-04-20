//
//  KSMTextField.m
//  Kesupermarket
//
//  Created by Cundy Sunardy on 8/9/16.
//  Copyright © 2016 Weekend Inc. All rights reserved.
//

#import "KSMTextField.h"

@interface KSMTextField() <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textfieldLeadingSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textfieldTrailingSpaceConstraint;
@property (strong, nonatomic) IBOutlet UIView *topSeparatorView;

- (IBAction)textFieldDidChange:(UITextField *)textField;

@end

@implementation KSMTextField


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:[self.class description] owner:self options:nil] firstObject];
        [self addSubview:view];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topSeparatorHeightConstraint.constant = 1.0f/[UIScreen mainScreen].scale;
    self.bottomSeparatorHeightConstraint.constant = 1.0f/[UIScreen mainScreen].scale;
    self.bottomSeparatorView.backgroundColor = [UIColor redColor];
    self.textfieldLeadingSpaceConstraint.constant = 20.0f;
    self.textfieldTrailingSpaceConstraint.constant = 20.0f;
    self.labelXPositionConstraint.constant = 20.0f;

}

#pragma mark - Custom Method
- (IBAction)textFieldDidChange:(UITextField *)textField{
        if(![textField.text isEqualToString:@""]){
            [UIView animateWithDuration:0.2f animations:^{
                self.labelXPositionConstraint.constant = 20.0f;
                self.labelYPositionConstraint.constant = 8.0f;
                self.placeholderLabel.textColor = [UIColor redColor];
                [self layoutIfNeeded];
            }];
            
        }
        else{
            [UIView animateWithDuration:0.2f animations:^{
                self.labelXPositionConstraint.constant = 20.0f;
                self.labelYPositionConstraint.constant = 28.0f;
                self.placeholderLabel.textColor = [UIColor grayColor];
                [self layoutIfNeeded];
            }];
        }
    if([self.delegate respondsToSelector:@selector(ksmTextFieldChange)]) {
        [self.delegate ksmTextFieldChange];
    }
    
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
    [self textFieldDidChange:self.textField];
}

- (void)resetTextField {
    self.textField.text = @"";
    self.labelXPositionConstraint.constant = 20.0f;
    self.labelYPositionConstraint.constant = 28.0f;
}

- (void)showBottomSeparatorView {
    self.bottomSeparatorView.alpha = 1.0f;
}

- (void)hideTopSeparatorView {
    self.topSeparatorView.alpha = 0.0f;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.placeholderLabel.textColor = [UIColor grayColor];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.placeholderLabel.textColor = [UIColor redColor];
    self.bottomSeparatorView.alpha = 0.0f;
}
@end
