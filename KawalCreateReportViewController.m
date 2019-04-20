//
//  KawalCreateReportViewController.m
//  PeSankita
//
//  Created by Admin on 4/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import "KawalCreateReportViewController.h"
#import "KSMTextField.h"
#import "DataManager.h"
#import "PickerViewController.h"
@interface KawalCreateReportViewController ()<PickerViewControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollviewBottomLayoutConstraint;

@property (strong, nonatomic) IBOutlet KSMTextField *tpsNumberTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *total1TextField;
@property (strong, nonatomic) IBOutlet KSMTextField *total2TextField;
@property (strong, nonatomic) IBOutlet KSMTextField *totalEligibleTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *totalErrorTextField;

@property (strong, nonatomic) IBOutlet KSMTextField *provinsiTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *kabupatenTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *kecamatanTextField;
@property (strong, nonatomic) IBOutlet KSMTextField *kelurahanTextField;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *provinsiIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *kabupatenIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *kecamatanIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *kelurahanIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *sendIndicator;

@property (strong, nonatomic) IBOutlet UIButton *provinsiButton;
@property (strong, nonatomic) IBOutlet UIButton *kabupateButton;
@property (strong, nonatomic) IBOutlet UIButton *kecamatanButton;
@property (strong, nonatomic) IBOutlet UIButton *kelurahanButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteImageButton;

@property (strong, nonatomic) IBOutlet UIImageView *cameraIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *galleryIconImageView;
@property (strong, nonatomic) IBOutlet UIView *cameraIconImageViewBG;
@property (strong, nonatomic) IBOutlet UIView *galleryIconImageViewBG;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UIView *previewMiniView;
@property (strong, nonatomic) IBOutlet UIView *takeView;
@property (strong, nonatomic) IBOutlet UIImageView *closeImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *previewImageTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *takeImageTopConstraint;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIImage *tpsPhoto;

@property (strong, nonatomic) NSArray *provinsiArray;
@property (strong, nonatomic) NSArray *kabupateArray;
@property (strong, nonatomic) NSArray *kecamatanArray;
@property (strong, nonatomic) NSArray *kelurahanArray;

@property (strong, nonatomic) NSString *selectedProvinsiString;
@property (strong, nonatomic) NSString *selectedKabupatenString;
@property (strong, nonatomic) NSString *selectedKecamatanString;
@property (strong, nonatomic) NSString *selectedKelurahanString;

@property (strong, nonatomic) NSString *selectedProvinsiID;
@property (strong, nonatomic) NSString *selectedKabupatenID;
@property (strong, nonatomic) NSString *selectedKecamatanID;
@property (strong, nonatomic) NSString *selectedKelurahanID;

@property (strong, nonatomic) NSString *attachmentID;

@property (nonatomic) BOOL isProvinsiDoneLoading;
@property (nonatomic) BOOL isKabupatenDoneLoading;
@property (nonatomic) BOOL isKecamatanDoneLoading;
@property (nonatomic) BOOL isKelurahanDoneLoading;

@end

@implementation KawalCreateReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if(self.type == KawalCreateReportViewControllerTypePreview){
        self.provinsiButton.userInteractionEnabled = NO;
        self.kabupateButton.userInteractionEnabled = NO;
        self.kecamatanButton.userInteractionEnabled = NO;
        self.kelurahanButton.userInteractionEnabled = NO;
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.alpha = 0.0f;
        self.closeImageView.alpha = 0.0f;
        self.deleteImageButton.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.previewImageTopConstraint.constant = 20.0f;
            self.previewMiniView.alpha = 1.0f;
            
            self.takeImageTopConstraint.constant = -58.0f;
            self.takeView.alpha = 0.0f;
        }];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
        self.previewImageView.image = [UIImage imageWithData:imageData];
        self.imageView.image = [UIImage imageWithData:imageData];
        
        self.tpsNumberTextField.placeholderLabel.text = @"No TPS";
        self.tpsNumberTextField.textField.text = [self.filledDictionary objectForKey:@"notps"];
        self.tpsNumberTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.tpsNumberTextField.textField.userInteractionEnabled = NO;
        self.tpsNumberTextField.textField.textColor = [UIColor grayColor];
        self.tpsNumberTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.tpsNumberTextField.labelXPositionConstraint.constant = 20.0f;
        self.tpsNumberTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.total1TextField.placeholderLabel.text = @"Jumlah Suara Paslon 01";
        self.total1TextField.textField.text = [NSString stringWithFormat:@"%@",[self.filledDictionary objectForKey:@"count1"]];
        self.total1TextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.total1TextField.textField.userInteractionEnabled = NO;
        self.total1TextField.textField.textColor = [UIColor grayColor];
        self.total1TextField.placeholderLabel.textColor = [UIColor grayColor];
        self.total1TextField.labelXPositionConstraint.constant = 20.0f;
        self.total1TextField.labelYPositionConstraint.constant = 8.0f;
        
        self.total2TextField.placeholderLabel.text = @"Jumlah Suara Paslon 02";
        self.total2TextField.textField.text = [NSString stringWithFormat:@"%@",[self.filledDictionary objectForKey:@"count2"]];
        self.total2TextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.total2TextField.textField.userInteractionEnabled = NO;
        self.total2TextField.textField.textColor = [UIColor grayColor];
        self.total2TextField.placeholderLabel.textColor = [UIColor grayColor];
        self.total2TextField.labelXPositionConstraint.constant = 20.0f;
        self.total2TextField.labelYPositionConstraint.constant = 8.0f;
        
        self.totalEligibleTextField.placeholderLabel.text = @"Jumlah Suara Sah";
        self.totalEligibleTextField.textField.text = [NSString stringWithFormat:@"%@",[self.filledDictionary objectForKey:@"s1"]];
        self.totalEligibleTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.totalEligibleTextField.textField.userInteractionEnabled = NO;
        self.totalEligibleTextField.textField.textColor = [UIColor grayColor];
        self.totalEligibleTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.totalEligibleTextField.labelXPositionConstraint.constant = 20.0f;
        self.totalEligibleTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.totalErrorTextField.placeholderLabel.text = @"Jumlah Suara Tidak Sah";
        self.totalErrorTextField.textField.text = [NSString stringWithFormat:@"%@",[self.filledDictionary objectForKey:@"n1"]];
        self.totalErrorTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.totalErrorTextField.textField.userInteractionEnabled = NO;
        self.totalErrorTextField.textField.textColor = [UIColor grayColor];
        self.totalErrorTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.totalErrorTextField.labelXPositionConstraint.constant = 20.0f;
        self.totalErrorTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.provinsiTextField.placeholderLabel.text = @"Provinsi";
        self.provinsiTextField.textField.text = [self.filledDictionary objectForKey:@"nmprov"];
        self.provinsiTextField.textField.userInteractionEnabled = NO;
        self.provinsiTextField.textField.textColor = [UIColor grayColor];
        self.provinsiTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.provinsiTextField.labelXPositionConstraint.constant = 20.0f;
        self.provinsiTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.kabupatenTextField.placeholderLabel.text = @"Kabupaten";
        self.kabupatenTextField.textField.text = [self.filledDictionary objectForKey:@"nmkab"];
        self.kabupatenTextField.textField.userInteractionEnabled = NO;
        self.kabupatenTextField.textField.textColor = [UIColor grayColor];
        self.kabupatenTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.kabupatenTextField.labelXPositionConstraint.constant = 20.0f;
        self.kabupatenTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.kecamatanTextField.placeholderLabel.text = @"Kecamatan";
        self.kecamatanTextField.textField.text = [self.filledDictionary objectForKey:@"nmkec"];
        self.kecamatanTextField.textField.userInteractionEnabled = NO;
        self.kecamatanTextField.textField.textColor = [UIColor grayColor];
        self.kecamatanTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.kecamatanTextField.labelXPositionConstraint.constant = 20.0f;
        self.kecamatanTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.kelurahanTextField.placeholderLabel.text = @"Kelurahan";
        self.kelurahanTextField.textField.text = [self.filledDictionary objectForKey:@"nmkel"];
        self.kelurahanTextField.textField.userInteractionEnabled = NO;
        self.kelurahanTextField.textField.textColor = [UIColor grayColor];
        self.kelurahanTextField.placeholderLabel.textColor = [UIColor grayColor];
        self.kelurahanTextField.labelXPositionConstraint.constant = 20.0f;
        self.kelurahanTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.titleLabel.text = @"Peninjauan Laporan";
    }
    else {
        self.titleLabel.text = @"Pembuatan Laporan";
        _isProvinsiDoneLoading = NO;
        _isKabupatenDoneLoading = NO;
        _isKecamatanDoneLoading = NO;
        _isKelurahanDoneLoading = NO;
        [self checkButtonTapped];
        
        _selectedProvinsiString = @"";
        _selectedKabupatenString = @"";
        _selectedKecamatanString = @"";
        _selectedKelurahanString = @"";
        
        _selectedProvinsiID = @"";
        _selectedKabupatenID = @"";
        _selectedKecamatanID = @"";
        _selectedKelurahanID = @"";
        
        self.tpsNumberTextField.placeholderLabel.text = @"No TPS";
        self.tpsNumberTextField.textField.text = @"";
        self.tpsNumberTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.total1TextField.placeholderLabel.text = @"Jumlah Suara Paslon 01";
        self.total1TextField.textField.text = @"";
        self.total1TextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.total2TextField.placeholderLabel.text = @"Jumlah Suara Paslon 02";
        self.total2TextField.textField.text = @"";
        self.total2TextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.totalEligibleTextField.placeholderLabel.text = @"Jumlah Suara Sah";
        self.totalEligibleTextField.textField.text = @"";
        self.totalEligibleTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.totalErrorTextField.placeholderLabel.text = @"Jumlah Tidak Suara Sah";
        self.totalErrorTextField.textField.text = @"";
        self.totalErrorTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.provinsiTextField.placeholderLabel.text = @"Provinsi";
        self.provinsiTextField.textField.text = @"";
        self.provinsiTextField.textField.userInteractionEnabled = NO;
        
        self.kabupatenTextField.placeholderLabel.text = @"Kabupaten";
        self.kabupatenTextField.textField.text = @"";
        self.kabupatenTextField.textField.userInteractionEnabled = NO;
        
        self.kecamatanTextField.placeholderLabel.text = @"Kecamatan";
        self.kecamatanTextField.textField.text = @"";
        self.kecamatanTextField.textField.userInteractionEnabled = NO;
        
        self.kelurahanTextField.placeholderLabel.text = @"Kelurahan";
        self.kelurahanTextField.textField.text = @"";
        self.kelurahanTextField.textField.userInteractionEnabled = NO;
        
        CGFloat pageWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.previewImageTopConstraint.constant = -((pageWidth / 4 * 3) + 16);
        self.previewMiniView.alpha = 0.0f;
        self.closeImageView.layer.cornerRadius = 10.0f;
        self.closeImageView.clipsToBounds = YES;
        
        UIImage *image = [UIImage imageNamed:@"add_photo"];
        self.galleryIconImageView.tintColor = [UIColor whiteColor];
        self.galleryIconImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.cameraIconImageViewBG.layer.cornerRadius = 25.0f;
        self.galleryIconImageViewBG.layer.cornerRadius = 25.0f;
        
        self.provinsiIndicator.alpha = 1.0f;
        [DataManager callAPIGetProvinsiWithSuccess:^(NSDictionary *success) {
            self.provinsiArray = [success objectForKey:@"data"];
            self.isProvinsiDoneLoading = YES;
            self.provinsiIndicator.alpha = 0.0f;
            [self checkButtonTapped];
            
        } failure:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Gagal"
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

-(void)checkButtonTapped{
    self.provinsiButton.userInteractionEnabled = self.isProvinsiDoneLoading;
    self.kabupateButton.userInteractionEnabled = self.isKabupatenDoneLoading;
    self.kecamatanButton.userInteractionEnabled = self.isKecamatanDoneLoading;
    self.kelurahanButton.userInteractionEnabled = self.isKelurahanDoneLoading;
}
- (IBAction)closeButtonDidTapped:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)provinsiButtonDidTapped:(id)sender{
    
    PickerViewController *picker = [[PickerViewController alloc] init];
    picker.masterArray = self.provinsiArray;
    picker.type = PickerViewControllerTypeProvinsi;
    picker.titleString = @"Provinsi";
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

    _selectedProvinsiString = @"";
    _selectedKabupatenString = @"";
    _selectedKecamatanString = @"";
    _selectedKelurahanString = @"";
    
    _selectedProvinsiID = @"";
    _selectedKabupatenID = @"";
    _selectedKecamatanID = @"";
    _selectedKelurahanID = @"";
    
    _kabupateArray = nil;
    _kecamatanArray = nil;
    _kelurahanArray = nil;
    
    self.kabupatenTextField.placeholderLabel.text = @"Kabupaten";
    self.kabupatenTextField.textField.text = @"";
    self.kabupatenTextField.labelYPositionConstraint.constant = 28.0f;
    self.kabupatenTextField.textField.userInteractionEnabled = NO;
    
    self.kecamatanTextField.placeholderLabel.text = @"Kecamatan";
    self.kecamatanTextField.textField.text = @"";
    self.kecamatanTextField.labelYPositionConstraint.constant = 28.0f;
    self.kecamatanTextField.textField.userInteractionEnabled = NO;
    
    self.kelurahanTextField.placeholderLabel.text = @"Kelurahan";
    self.kelurahanTextField.textField.text = @"";
    self.kecamatanTextField.labelYPositionConstraint.constant = 28.0f;
    self.kelurahanTextField.textField.userInteractionEnabled = NO;
}

-(IBAction)kabupatenButtonDidTapped:(id)sender{
    PickerViewController *picker = [[PickerViewController alloc] init];
    picker.masterArray = self.kabupateArray;
    picker.type = PickerViewControllerTypeKabupaten;
    picker.titleString = @"Kabupaten";
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

    _selectedKabupatenString = @"";
    _selectedKecamatanString = @"";
    _selectedKelurahanString = @"";
    
    _selectedKabupatenID = @"";
    _selectedKecamatanID = @"";
    _selectedKelurahanID = @"";
    
    _kecamatanArray = nil;
    _kelurahanArray = nil;
    
    self.kecamatanTextField.placeholderLabel.text = @"Kecamatan";
    self.kecamatanTextField.textField.text = @"";
    self.kecamatanTextField.labelYPositionConstraint.constant = 28.0f;
    self.kecamatanTextField.textField.userInteractionEnabled = NO;
    
    self.kelurahanTextField.placeholderLabel.text = @"Kelurahan";
    self.kelurahanTextField.textField.text = @"";
    self.kecamatanTextField.labelYPositionConstraint.constant = 28.0f;
    self.kelurahanTextField.textField.userInteractionEnabled = NO;
}

-(IBAction)kecamatanButtonDidTapped:(id)sender{
    PickerViewController *picker = [[PickerViewController alloc] init];
    picker.masterArray = self.kecamatanArray;
    picker.type = PickerViewControllerTypeKecamatan;
    picker.titleString = @"Kecamatan";
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

    _selectedKecamatanString = @"";
    _selectedKelurahanString = @"";
    _selectedKecamatanID = @"";
    _selectedKelurahanID = @"";
    _kelurahanArray = nil;
    
    self.kelurahanTextField.placeholderLabel.text = @"Kelurahan";
    self.kelurahanTextField.textField.text = @"";
    self.kecamatanTextField.labelYPositionConstraint.constant = 28.0f;
    self.kelurahanTextField.textField.userInteractionEnabled = NO;
}

-(IBAction)kelurahanButtonDidTapped:(id)sender{
    PickerViewController *picker = [[PickerViewController alloc] init];
    picker.masterArray = self.kelurahanArray;
    picker.type = PickerViewControllerTypeKelurahan;
    picker.titleString = @"Kelurahan";
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

    _selectedKelurahanString = @"";
    _selectedKelurahanID = @"";
}

- (void)itemTappedPickerViewControllerDelegate:(PickerViewControllerType)type pickedID:(NSString *)pickedID pickedName:(NSString *)pickedName {
    if(type == PickerViewControllerTypeProvinsi){
        self.selectedProvinsiString = pickedName;
        self.selectedProvinsiID = pickedID;
        self.provinsiTextField.textField.text = self.selectedProvinsiString;
        self.provinsiTextField.labelYPositionConstraint.constant = 8.0f;

        self.isKabupatenDoneLoading = NO;
        self.kabupatenIndicator.alpha = 1.0f;
        [self checkButtonTapped];
        [DataManager callAPIGetKabupatenWithProvinsiID:pickedID success:^(NSDictionary *success) {
            self.kabupateArray = [success objectForKey:@"data"];
            self.isKabupatenDoneLoading = YES;
            self.kabupatenIndicator.alpha = 0.0f;
            [self checkButtonTapped];
        } failure:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Gagal"
                                                                                     message:error.localizedDescription
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    else if(type == PickerViewControllerTypeKabupaten){
        self.selectedKabupatenString = pickedName;
        self.selectedKabupatenID = pickedID;
        self.kabupatenTextField.textField.text = self.selectedKabupatenString;
        self.kabupatenTextField.labelYPositionConstraint.constant = 8.0f;

        self.isKecamatanDoneLoading = NO;
        self.kecamatanIndicator.alpha = 1.0f;
        [self checkButtonTapped];
        [DataManager callAPIGetKecamatanWithKabupatenID:pickedID success:^(NSDictionary *success) {
            self.kecamatanArray = [success objectForKey:@"data"];
            self.isKecamatanDoneLoading = YES;
            self.kecamatanIndicator.alpha = 0.0f;
            [self checkButtonTapped];
        } failure:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Gagal"
                                                                                     message:[NSString stringWithFormat:@"Error code : %li",error.code]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    else if(type == PickerViewControllerTypeKecamatan){
        self.selectedKecamatanString = pickedName;
        self.selectedKecamatanID = pickedID;
        self.kecamatanTextField.textField.text = self.selectedKecamatanString;
        self.kecamatanTextField.labelYPositionConstraint.constant = 8.0f;
        
        self.isKelurahanDoneLoading = NO;
        self.kelurahanIndicator.alpha = 1.0f;
        [self checkButtonTapped];
        [DataManager callAPIGetKelurahanWithKecamatanID:pickedID success:^(NSDictionary *success) {
            self.kelurahanArray = [success objectForKey:@"data"];
            self.isKelurahanDoneLoading = YES;
            self.kelurahanIndicator.alpha = 0.0f;
            [self checkButtonTapped];
        } failure:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Gagal"
                                                                                     message:error.localizedDescription
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    else if(type == PickerViewControllerTypeKelurahan){
        self.selectedKelurahanString = pickedName;
        self.selectedKelurahanID = pickedID;
        self.kelurahanTextField.textField.text = self.selectedKelurahanString;
        self.kelurahanTextField.labelYPositionConstraint.constant = 8.0f;
    }
}

-(IBAction)photoDidTapped:(id)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)galleryDidTapped:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing =  NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)deleteImageDidTapped:(id)sender{
    self.imageView.image = nil;
    self.previewImageView.image = nil;
    self.tpsPhoto = nil;
    
    [UIView animateWithDuration:0.2f animations:^{
        CGFloat pageWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.previewImageTopConstraint.constant = -(pageWidth / 4 * 3) - 16;
        self.previewMiniView.alpha = 0.0f;
        
        self.takeImageTopConstraint.constant = 8.0f;
        self.takeView.alpha = 1.0f;
    }];
}

-(IBAction)openImageDidTapped:(id)sender{
    self.previewView.alpha = 1.0f;
}

-(IBAction)closeImageDidTapped:(id)sender{
    self.previewView.alpha = 0.0f;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [UIView animateWithDuration:0.2f animations:^{
        self.previewImageTopConstraint.constant = 20.0f;
        self.previewMiniView.alpha = 1.0f;
        
        self.takeImageTopConstraint.constant = -58.0f;
        self.takeView.alpha = 0.0f;
    }];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    self.previewImageView.image = chosenImage;
    self.tpsPhoto = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

-(IBAction)submitButtonDidTapped:(id)sender{
    BOOL isProvinsiFilled = NO;
    BOOL isKabupatenFilled = NO;
    BOOL isKecamatanFilled = NO;
    BOOL isKelurahanFilled = NO;
    
    BOOL isTPSFilled = NO;
    BOOL is01Filled = NO;
    BOOL is02Filled = NO;
    BOOL isEligibleFilled = NO;
    BOOL isErrorFilled = NO;
    
    BOOL isImageFilled = NO;
    BOOL isTotalCorrect = NO;
    
    self.tpsNumberTextField.bottomSeparatorView.alpha = 0.0f;
    self.tpsNumberTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.total1TextField.bottomSeparatorView.alpha = 0.0f;
    self.total1TextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.total2TextField.bottomSeparatorView.alpha = 0.0f;
    self.total2TextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.totalEligibleTextField.bottomSeparatorView.alpha = 0.0f;
    self.totalEligibleTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.totalErrorTextField.bottomSeparatorView.alpha = 0.0f;
    self.totalErrorTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.provinsiTextField.bottomSeparatorView.alpha = 0.0f;
    self.provinsiTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.kabupatenTextField.bottomSeparatorView.alpha = 0.0f;
    self.kabupatenTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.kecamatanTextField.bottomSeparatorView.alpha = 0.0f;
    self.kecamatanTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.kelurahanTextField.bottomSeparatorView.alpha = 0.0f;
    self.kelurahanTextField.bottomSeparatorView.backgroundColor = [UIColor lightGrayColor];
    
    self.takeView.layer.borderColor = [UIColor clearColor].CGColor;
    self.takeView.layer.borderWidth = 0.0f;

//Location
    if([self.selectedProvinsiString isEqualToString:@""]){
        isProvinsiFilled = NO;
        self.provinsiTextField.bottomSeparatorView.alpha = 1.0f;
        self.provinsiTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isProvinsiFilled = YES;
    }
    
    if([self.selectedKabupatenString isEqualToString:@""]){
        isKabupatenFilled = NO;
        self.kabupatenTextField.bottomSeparatorView.alpha = 1.0f;
        self.kabupatenTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isKabupatenFilled = YES;
    }
    
    if([self.selectedKecamatanString isEqualToString:@""]){
        isKecamatanFilled = NO;
        self.kecamatanTextField.bottomSeparatorView.alpha = 1.0f;
        self.kecamatanTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isKecamatanFilled = YES;
    }
    
    if([self.selectedKelurahanString isEqualToString:@""]){
        isKelurahanFilled = NO;
        self.kelurahanTextField.bottomSeparatorView.alpha = 1.0f;
        self.kelurahanTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isKelurahanFilled = YES;
    }
    
    
//TPS
    if([self.tpsNumberTextField.textField.text isEqualToString:@""]){
        isTPSFilled = NO;
        self.tpsNumberTextField.bottomSeparatorView.alpha = 1.0f;
        self.tpsNumberTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isTPSFilled = YES;
    }
    
    if([self.total1TextField.textField.text isEqualToString:@""]){
        is01Filled = NO;
        self.total1TextField.bottomSeparatorView.alpha = 1.0f;
        self.total1TextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        is01Filled = YES;
    }
    
    if([self.total2TextField.textField.text isEqualToString:@""]){
        is02Filled = NO;
        self.total2TextField.bottomSeparatorView.alpha = 1.0f;
        self.total2TextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        is02Filled = YES;
    }
    
    if([self.totalEligibleTextField.textField.text isEqualToString:@""]){
        isEligibleFilled = NO;
        self.totalEligibleTextField.bottomSeparatorView.alpha = 1.0f;
        self.totalEligibleTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isEligibleFilled = YES;
    }
    
    if([self.totalErrorTextField.textField.text isEqualToString:@""]){
        isErrorFilled = NO;
        self.totalErrorTextField.bottomSeparatorView.alpha = 1.0f;
        self.totalErrorTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    else {
        isErrorFilled = YES;
    }
    
    if(self.tpsPhoto == nil){
        isImageFilled = NO;
        self.takeView.layer.borderColor = [UIColor redColor].CGColor;
        self.takeView.layer.borderWidth = 1.0f;
    }
    else {
        isImageFilled = YES;
    }
    
    if([self.total1TextField.textField.text integerValue] + [self.total2TextField.textField.text integerValue] == [self.totalEligibleTextField.textField.text integerValue]){
        isTotalCorrect = YES;
    }
    else {
        isTotalCorrect = NO;
        self.total1TextField.bottomSeparatorView.alpha = 1.0f;
        self.total1TextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
        self.total2TextField.bottomSeparatorView.alpha = 1.0f;
        self.total2TextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
        self.totalEligibleTextField.bottomSeparatorView.alpha = 1.0f;
        self.totalEligibleTextField.bottomSeparatorView.backgroundColor = [UIColor redColor];
    }
    

    if(isProvinsiFilled && isKabupatenFilled && isKecamatanFilled && isKelurahanFilled && isTPSFilled && is01Filled && is02Filled && isEligibleFilled && isErrorFilled && isImageFilled && isTotalCorrect){
        NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyymmdd"];
        
        NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hhmmss"];
        
        _attachmentID = [NSString stringWithFormat:@"C1_%@_%@_%@_%@",self.tpsNumberTextField.textField.text,identifier,[dateFormatter stringFromDate:[NSDate date]],[timeFormatter stringFromDate:[NSDate date]] ];
        
        NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
        // 1555502400 is timeIntervalSince1970 of 17 April 2019 12.00.00
        // 1555506000 is timeIntervalSince1970 of 17 April 2019 13.00.00
        if (timeInSeconds > 1555502400 && timeInSeconds < 1555506000){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pembuatan Laporan Gagal"
                                                                                     message:@"awal mulai lapor adalah jam 13.00"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                             }];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            self.sendButton.userInteractionEnabled = NO;
            [self.sendButton setTitle:@"" forState:UIControlStateNormal];
            self.sendIndicator.alpha = 1;
            [DataManager callAPIGetUploadURLWithAttachmentID:self.attachmentID success:^(NSDictionary *success) {
                NSString *urlString = [success objectForKey:@"url"];
                NSData *imageData = UIImageJPEGRepresentation(self.tpsPhoto, 0.8f);

                NSURL *url = [NSURL URLWithString: urlString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                [request setValue:[self contentTypeForImageData:imageData] forHTTPHeaderField:@"Content-Type"];
                [request setHTTPMethod:@"PUT"];
                [request setHTTPBody:imageData];
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error){
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        NSLog(@"response : %@",responseDictionary);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [DataManager callAPISubmitFormWithAttachmentID:self.attachmentID count1:self.total1TextField.textField.text count2:self.total2TextField.textField.text s1:self.totalEligibleTextField.textField.text n1:self.totalErrorTextField.textField.text idkel:self.selectedKelurahanID notps:self.tpsNumberTextField.textField.text token:@"" success:^(NSDictionary *success) {
                                self.sendButton.userInteractionEnabled = YES;
                                [self.sendButton setTitle:@"KIRIM" forState:UIControlStateNormal];
                                self.sendIndicator.alpha = 0;

                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pembuatan Laporan Sukses"
                                                                                                         message:@"Pembuatan laporan sukses"
                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                                 }];
                                [alertController addAction:actionOk];
                                [self presentViewController:alertController animated:YES completion:nil];
                            } failure:^(NSError *error) {
                                self.sendButton.userInteractionEnabled = YES;
                                [self.sendButton setTitle:@"KIRIM" forState:UIControlStateNormal];
                                self.sendIndicator.alpha = 0;
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pembuatan Laporan Gagal"
                                                                                                         message:error.localizedDescription
                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:nil];
                                [alertController addAction:actionOk];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }];
                        });
                    } else {
                        // process error
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.sendButton.userInteractionEnabled = YES;
                            [self.sendButton setTitle:@"KIRIM" forState:UIControlStateNormal];
                            self.sendIndicator.alpha = 0;

                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pembuatan Laporan Gagal"
                                                                                                     message:error.localizedDescription
                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:nil];
                            [alertController addAction:actionOk];
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    }
                }];
                [postDataTask resume];
       
            } failure:^(NSError *error) {
                self.sendButton.userInteractionEnabled = YES;
                [self.sendButton setTitle:@"KIRIM" forState:UIControlStateNormal];
                self.sendIndicator.alpha = 0;

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pembuatan Laporan Gagal"
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
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

@end
