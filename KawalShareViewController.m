//
//  KawalShareViewController.m
//  PeSankita
//
//  Created by Admin on 3/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalShareViewController.h"

@interface KawalShareViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIImageView *kawalImageView;
@end

@implementation KawalShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.descLabel.text =  [NSString stringWithFormat:@"Saya sudah bergabung di Gerakan Relawan #AyoNyoblos #AyoPantau yang #NetralBerintegritasTerbuka\n\nAyo kita berpartisipasi aktif menyukseskan Pilpres 2019.\n\nIkuti petunjuk berikut:\n 1. Install dan aktifkan aplikasi PeSankita Indonesia https://s.id/PeSanKita;\n 2.Daftar KawalPilpres, klik icon KawalPilpres di bagian kanan bawah; \n 3. Undang teman yang lain.\n\nKode Referensi unik dari saya untuk Anda: %@\n\n Harap gunakan Kode Referensi Anda sendiri untuk mengundang temang yang lain.\n\n Harap pastikan aplikasi PesanKita di ponsel anda selalu terkinikan (update) karena akan terus dilakukan pembaruan aplikasi KawalPilpres.\n Terimakasih atas kesediaan Anda bersama mengawal Pilpres 2019.",self.phoneString];
    UIImage *image = [UIImage imageNamed:@"ic_kawal_pilpres"];
    self.kawalImageView.tintColor = [UIColor whiteColor];
    self.kawalImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.shareButton.layer.cornerRadius = 20.0f;
    self.bgView.layer.cornerRadius = 4.0f;
}

- (IBAction)shareButtonDidTapped:(id)sender{
    //create a message
    NSString *theMessage =  [NSString stringWithFormat:@"DIBUTUHKAN SUKARELAWAN KawalPilpres2019.id\n\nApakah Anda simpatisan pilpres, berintegritas, peduli, anti hoax, dan mau mengawal perhitungan suara Pilpres 2019?\n\nAyo bergabung bersama saya menjadi sukarelawan KawalPilpres2019 yang #NetralBerintegritasTerbuka dalam Gerakan #AyoNyoblos #AyoPantau.\nTugas sukarelawan melaporkan hasil perhitungan di TPS ke sistem KawalPilpres2019.\n\nCaranya mudah:\n\n 1.Install dan aktifkan aplikasi PeSankita Indonesia https://pesan.kita.id;\n\n 2.Daftar KawalPilpres (icon KawalPilpres di bagian kanan bawah) dengan kode Referensi unik: %@\n\n 3.Gunakan fungsi Undang Teman untuk merekrut sukarelawan lainnya dengan Kode Ref. dari Anda dan coba simulasi pelaporan.\n\nHarap pastikan aplikasi PeSankita di ponsel Anda selalu terkinikan (update) karena akan terus dilakukan pembaruan aplikasi mikro KawalPilpres.\nInfo lebih lanjut di kawalpilpres2019.id",self.phoneString];
    NSArray *items = @[theMessage];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
        }
        else {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

- (IBAction)closeButtonDidTapped:(UIButton *)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -100){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
