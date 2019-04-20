//
//  KawalProfileViewController.m
//  PeSankita
//
//  Created by Admin on 2/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalProfileViewController.h"
//#import <SecureNSUserDefaults/NSUserDefaults+SecureAdditions.h>

@interface KawalProfileViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *seePasswordImageView;
@property (strong, nonatomic) IBOutlet UIView *profilepictView;
@property (nonatomic) BOOL isPasswordHide;
@end

@implementation KawalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    self.nameLabel.text = name;
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"msisdn"];
    self.phoneLabel.text = phone;
    NSString *pswd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pswd"];
    self.passwordTextField.text = pswd;
    self.passwordTextField.userInteractionEnabled = NO;
    self.isPasswordHide = YES;
    self.profilepictView.layer.cornerRadius = 40.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSUserDefaults standardUserDefaults] setSecret:@"kawal_pilpres"];
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
    self.passwordTextField.secureTextEntry = self.isPasswordHide;
}

- (IBAction)closeButtonDidTapped:(UIButton *)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)copyButtonDidTapped:(UIButton *)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.passwordTextField.text;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Berhasil"
                                                                             message:@"Password berhasil disalin"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
