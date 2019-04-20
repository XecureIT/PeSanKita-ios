//
//  KawalRegisterViewController.m
//  PeSankita
//
//  Created by Admin on 25/3/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalRegisterViewController.h"
#import "KSMTextField.h"
#import <SignalServiceKit/TSAccountManager.h>
#import "DataManager.h"
#import "AFHTTPSessionManager.h"
@interface KawalRegisterViewController ()<KSMTextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBottomLayoutConstraint;
@property (strong, nonatomic) IBOutlet KSMTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *fullnameTextField;

@property (strong, nonatomic) IBOutlet KSMTextField *phoneReferTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *passwordTextField;

@property (strong, nonatomic) IBOutlet KSMTextField *retypePasswordTextField;

@property (strong, nonatomic) IBOutlet UIView *fullnameView;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *retypePasswordView;

@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *seePasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *seeRePasswordButton;
@property (strong, nonatomic) IBOutlet UIImageView *seePasswordImageView;
@property (strong, nonatomic) IBOutlet UIImageView *seeRePasswordImageView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic) BOOL isPasswordHide;
@property (nonatomic) BOOL isRePasswordHide;
@end

@implementation KawalRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor redColor]];
    self.registerButton.layer.cornerRadius = 15.0f;
    
    self.phoneTextField.textField.userInteractionEnabled = NO;
    NSString *phoneString = [TSAccountManager localNumber];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    self.phoneTextField.textField.text = phoneString;
    self.phoneTextField.textField.textColor = [UIColor grayColor];
    self.phoneTextField.placeholderLabel.textColor = [UIColor grayColor];
    self.phoneTextField.placeholderLabel.text = @"No. HP";
    self.phoneTextField.labelXPositionConstraint.constant = 32.0f;
    self.phoneTextField.labelYPositionConstraint.constant = 8.0f;
    
    self.fullnameTextField.placeholderLabel.text = @"Nama Lengkap";
    self.fullnameTextField.textField.text = @"";
    [self.fullnameTextField.textField becomeFirstResponder];
    
    self.phoneReferTextField.placeholderLabel.text = @"Kode Referensi (jika ada)";
    self.phoneReferTextField.textField.text = @"";
    
    self.passwordTextField.placeholderLabel.text = @"Password";
    self.passwordTextField.textField.text = @"";
    self.passwordTextField.textField.secureTextEntry = YES;
    
    self.retypePasswordTextField.placeholderLabel.text = @"Re-Type Password";
    self.retypePasswordTextField.textField.text = @"";
    self.retypePasswordTextField.textField.secureTextEntry = YES;
    
    self.isRePasswordHide = YES;
    self.isPasswordHide = YES;
    
    self.title = @"Registrasi";
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"_arrow_button"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonDidTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


- (IBAction)seePasswordDidTapped:(UIButton *)sender{
    if (self.isPasswordHide) {
        self.isPasswordHide = NO;
        self.seePasswordImageView.image = [UIImage imageNamed: @"icons8-eye-30"];
    }
    else {
        self.isPasswordHide = YES;
        self.seePasswordImageView.image = [UIImage imageNamed: @"icons8-invisible-30"];
    }
    self.passwordTextField.textField.secureTextEntry = self.isPasswordHide;
}

- (IBAction)seeRePasswordDidTapped:(UIButton *)sender{
    if (self.isRePasswordHide) {
        self.isRePasswordHide = NO;
        self.seeRePasswordImageView.image = [UIImage imageNamed: @"icons8-eye-30"];
    }
    else {
        self.isRePasswordHide = YES;
        self.seeRePasswordImageView.image = [UIImage imageNamed: @"icons8-invisible-30"];
    }
    self.retypePasswordTextField.textField.secureTextEntry = self.isRePasswordHide;
}

- (IBAction)registerButtonDidTapped:(UIButton *)sender{
    BOOL isFullnameFilled = NO;
    BOOL isReferFilled = YES;
    BOOL isPasswordFilled = NO;
    BOOL isRePasswordFilled = NO;
    BOOL isSameRePassword = NO;
    
    self.fullnameView.backgroundColor = [UIColor grayColor];
    self.passwordView.backgroundColor = [UIColor grayColor];
    self.retypePasswordView.backgroundColor = [UIColor grayColor];
    
    if ([self.fullnameTextField.textField.text isEqualToString:@""]) {
        self.fullnameView.backgroundColor = [UIColor redColor];
    }
    else {
        isFullnameFilled = YES;
    }
    
    if (![self.phoneReferTextField.textField.text isEqualToString:@""]) {
        if([self.phoneReferTextField.textField.text hasPrefix:@"62"]) {
            isReferFilled = YES;
        }
        else {
            isReferFilled = NO;
        }
    }
    
    if ([self.passwordTextField.textField.text isEqualToString:@""]) {
        self.passwordView.backgroundColor = [UIColor redColor];
    }
    else {
        if ([self.passwordTextField.textField.text length] < 8) {
            self.passwordView.backgroundColor = [UIColor redColor];
        }
        else {
            isPasswordFilled = YES;
        }
    }
    
    if ([self.retypePasswordTextField.textField.text isEqualToString:@""]) {
        self.retypePasswordView.backgroundColor = [UIColor redColor];
    }
    else {
        if ([self.retypePasswordTextField.textField.text length] < 8) {
            self.retypePasswordView.backgroundColor = [UIColor redColor];
        }
        else {
            isRePasswordFilled = YES;
        }
        
    }
    
    if ([self.retypePasswordTextField.textField.text isEqualToString:self.passwordTextField.textField.text]) {
        isSameRePassword = YES;
    }
    else {
        //alert (?)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Password dan ReTypePassword tidak sama"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    if (isPasswordFilled && isPasswordFilled && isPasswordFilled && isPasswordFilled && isPasswordFilled && isSameRePassword && isReferFilled){
        //hit API
        NSString *phoneString = self.phoneTextField.textField.text;
        phoneString = [phoneString stringByReplacingOccurrencesOfString:@"+" withString:@""];
        self.loadingIndicator.alpha = 1.0f;
        [self.registerButton setTitle:@"" forState:UIControlStateNormal];
        self.registerButton.userInteractionEnabled = NO;
        

   
        [DataManager callAPIRegisterWithMsisdn:phoneString password:self.passwordTextField.textField.text name:self.fullnameTextField.textField.text referral:self.phoneReferTextField.textField.text success:^(NSDictionary *activationToken) {
            self.loadingIndicator.alpha = 0.0f;
            [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
            self.registerButton.userInteractionEnabled = YES;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Berhasil"
                                                                                     message:@"Registrasi Berhasil"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self backButtonDidTapped];
                                                             }];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } failure:^(NSError *error) {
           self.loadingIndicator.alpha = 0.0f;
            [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
            self.registerButton.userInteractionEnabled = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Registrasi Gagal"
                                                                                     message:error.localizedDescription
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self keyboardWillShowWithHeight:keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self keyboardWillHideWithHeight:keyboardHeight];
}
- (void)keyboardWillShowWithHeight:(CGFloat)keyboardHeight {
    self.scrollviewBottomLayoutConstraint.constant = keyboardHeight;
}

- (void)keyboardWillHideWithHeight:(CGFloat)keyboardHeight {
    self.scrollviewBottomLayoutConstraint.constant = 0.0f;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void) backButtonDidTapped {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
