//
//  KawalPilpresViewController.m
//  PeSankita
//
//  Created by Admin on 1/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalPilpresViewController.h"
#import "KawalShareViewController.h"
#import "UIUtil.h"
#import "KawalProfileViewController.h"
#import <SignalServiceKit/TSAccountManager.h>
#import "KawalReportPageViewController.h"

@interface KawalPilpresViewController ()
@property (strong, nonatomic) IBOutlet UIView *kawalImageView;
@property (strong, nonatomic) IBOutlet UIImageView *kawalImageImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UILabel *thankyouDescLabel;

@property (strong, nonatomic) IBOutlet UIView *whiteView1;
@property (strong, nonatomic) IBOutlet UIView *whiteView2;
@property (strong, nonatomic) IBOutlet UIView *whiteView3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inviteViewLayoutConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inviteViewBottomLayoutConstraint;

@property (strong, nonatomic) IBOutlet UIView *redView1;
@property (strong, nonatomic) IBOutlet UIView *redView2;
@property (strong, nonatomic) IBOutlet UIView *redView3;
@end

@implementation KawalPilpresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIView animateWithDuration:1.2f animations:^{
        self.kawalImageView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    self.thankyouDescLabel.text = @"Terimakasih Anda telah menjadi Relawan #AyoNyoblos #AyoPantau\n\nKita membutuhkan lebih banyak relawan. Ayo undang teman-teman yang lain.\n\nHarap pastikan auto update App Store diaktifkan untuk aplikasi PeSankita karena kami akan melakukan rilis baru cukup sering selama masa Pilpres";
    
    
    [self.whiteView1.layer setCornerRadius:10.0f];
    [self.whiteView1.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.whiteView1.layer setShadowOpacity:0.8f];
    [self.whiteView1.layer setShadowRadius:1.0f];
    [self.whiteView1.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.whiteView2.layer setCornerRadius:10.0f];
    [self.whiteView2.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.whiteView2.layer setShadowOpacity:0.8f];
    [self.whiteView2.layer setShadowRadius:1.0f];
    [self.whiteView2.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    
    [self.whiteView3.layer setCornerRadius:10.0f];
    [self.whiteView3.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.whiteView3.layer setShadowOpacity:0.8f];
    [self.whiteView3.layer setShadowRadius:1.0f];
    [self.whiteView3.layer setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    
    self.whiteView1.clipsToBounds = YES;
    self.whiteView2.clipsToBounds = YES;
    self.whiteView3.clipsToBounds = YES;
    
    self.redView1.clipsToBounds = YES;
    self.redView2.clipsToBounds = YES;
    self.redView3.clipsToBounds = YES;
    
    self.redView1.layer.cornerRadius = CGRectGetWidth(self.redView1.frame)/2;
    self.redView2.layer.cornerRadius = CGRectGetWidth(self.redView1.frame)/2;
    self.redView3.layer.cornerRadius = CGRectGetWidth(self.redView1.frame)/2;
    
    self.phoneLabel.text = [TSAccountManager localNumber];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    self.nameLabel.text = name;
    
    [self performSelector:@selector(hideInviteFriends) withObject:nil afterDelay:5.f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor ows_materialRedColor];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void) hideInviteFriends {
    [UIView animateWithDuration:0.5f animations:^{
        self.inviteViewLayoutConstraint.constant = -100.0f;
        self.inviteViewBottomLayoutConstraint.constant = 72.0f;
        self.whiteView3.alpha = 0.0f;
    }];
    
}

- (IBAction)inviteFriendButtonTapped:(UIButton *)sender{
    KawalShareViewController *kawalShareViewController = [[KawalShareViewController alloc]init];
    kawalShareViewController.phoneString = [TSAccountManager localNumber];
    [self presentViewController:kawalShareViewController animated:YES completion:nil];
    
}
- (IBAction)profileButtonTapped:(UIButton *)sender{
    KawalProfileViewController *kawalProfileViewController = [[KawalProfileViewController alloc]init];
    kawalProfileViewController.userDictionary = self.userDictionary;
    [self presentViewController:kawalProfileViewController animated:YES completion:nil];
}
- (IBAction)reportButtonTapped:(UIButton *)sender{
    KawalReportPageViewController *kawalReportPageViewController = [[KawalReportPageViewController alloc]init];
    [self.navigationController pushViewController:kawalReportPageViewController animated:YES];
}

- (IBAction)closeButtonDidTapped:(UIButton *)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
