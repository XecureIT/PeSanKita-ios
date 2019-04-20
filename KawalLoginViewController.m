//
//  KawalLoginViewController.m
//  PeSankita
//
//  Created by Admin on 25/3/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalLoginViewController.h"
#import "KawalRegisterViewController.h"
#import "KSMTextField.h"
#import "UIUtil.h"
#import <SignalServiceKit/TSAccountManager.h>
#import "DataManager.h"
#import "KawalPilpresViewController.h"
//#import <SecureNSUserDefaults/NSUserDefaults+SecureAdditions.h>

@interface KawalLoginViewController ()<KSMTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *kawalImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *kawalImageImageView;
@property (strong, nonatomic) IBOutlet UILabel *loginDescriptionLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBottomLayoutConstraint;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *seePasswordButton;
@property (strong, nonatomic) IBOutlet UIImageView *seePasswordImageView;
@property (strong, nonatomic) IBOutlet KSMTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet KSMTextField *phoneTextField;

@property (nonatomic) BOOL isPasswordHide;
@end

@implementation KawalLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.loginDescriptionLabel.text = @"Kawal Pilpres 2019 mendukung gerakan masyarakat #AyoNyoblos #AyoPantau. \n\nNetral, Obyektif, Berintegritas, Terbuka";
    
    self.passwordTextField.placeholderLabel.text = @"Password";
    self.passwordTextField.textField.text = @"";
    self.passwordTextField.textField.secureTextEntry = YES;
    
    self.phoneTextField.textField.userInteractionEnabled = NO;
    NSString *phoneString = [TSAccountManager localNumber];
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    self.phoneTextField.textField.text = phoneString;
    self.phoneTextField.textField.textColor = [UIColor grayColor];
    self.phoneTextField.placeholderLabel.textColor = [UIColor grayColor];
    self.phoneTextField.placeholderLabel.text = @"No. HP";
    self.phoneTextField.labelXPositionConstraint.constant = 20.0f;
    self.phoneTextField.labelYPositionConstraint.constant = 8.0f;
    
    self.loginButton.layer.cornerRadius = 15.0f;
    
    UIImage * image = [UIImage imageNamed:@"ic_kawal_pilpres"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.kawalImageImageView.image = image;
    [UIView animateWithDuration:1.2f animations:^{
        self.kawalImageView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
    self.isPasswordHide = YES;
//    [[NSUserDefaults standardUserDefaults] setSecret:@"kawal_pilpres"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor ows_materialRedColor];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
#pragma mark - Custom delegate
- (void)ksmTextFieldChange {
    
}

- (IBAction)loginButtonDidTapped:(UIButton *)sender{
    self.passwordView.backgroundColor = [UIColor grayColor];
    if ([self.passwordTextField.textField.text isEqualToString:@""]) {
        self.passwordView.backgroundColor = [UIColor redColor];
    }
    else {
        //hit API
        
        NSURL *url = [NSURL URLWithString: @"https:///v1/login"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
//        NSString *authStr = [NSString stringWithFormat:@"6281281686528:P@ssw0rd"];
//        for testing
        NSString *phoneString = self.phoneTextField.textField.text;
        phoneString = [phoneString stringByReplacingOccurrencesOfString:@"+" withString:@""];
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", phoneString, self.passwordTextField.textField.text];

        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        self.loadingIndicator.alpha = 1.0f;
        [self.loginButton setTitle:@"" forState:UIControlStateNormal];
        self.loginButton.userInteractionEnabled = NO;
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (!error) {
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            NSLog(@"response : %@",responseDictionary);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.loadingIndicator.alpha = 0.0f;
                                [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
                                self.loginButton.userInteractionEnabled = YES;
                                if (responseDictionary == nil) {
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Gagal"
                                                                                                             message:error.localizedDescription
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                       style:UIAlertActionStyleDefault
                                                                                     handler:nil];
                                    [alertController addAction:actionOk];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                }
                                else {
                                    NSDictionary *profile = [responseDictionary objectForKey:@"profile"];
                                    NSString *phone = [profile objectForKey:@"msisdn"];
                                    NSString *name = [profile objectForKey:@"name"];
                                    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"msisdn"];
                                    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isloggedin"];
                                    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.textField.text forKey:@"pswd"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    [self dismissViewControllerAnimated:YES completion:^{
                                        
                                    }];
                                    if ([self.delegate respondsToSelector:@selector(successLoginKawalLoginViewControllerDelegate:)]){
                                        [self.delegate successLoginKawalLoginViewControllerDelegate:responseDictionary];
                                    }
                                }
                            });
                          
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.loadingIndicator.alpha = 0.0f;
                                [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
                                self.loginButton.userInteractionEnabled = YES;
                                NSLog(@"error");
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Gagal"
                                                                                                         message:error.localizedDescription
                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:nil];
                                [alertController addAction:actionOk];
                                [self presentViewController:alertController animated:YES completion:nil];
                            });
                        }
                    }] resume];
    }
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

-(IBAction)closeButtonDidTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButtonDidTapped:(UIButton *)sender{
    KawalRegisterViewController *kawalRegisterViewController = [[KawalRegisterViewController alloc]init];
    [self.navigationController pushViewController:kawalRegisterViewController animated:YES];
}
#pragma mark - Keyboard delegate
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

@end
