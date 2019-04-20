//
//  PickerViewController.h
//  PeSankita
//
//  Created by Admin on 8/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PickerViewControllerType) {
    PickerViewControllerTypeProvinsi,
    PickerViewControllerTypeKabupaten,
    PickerViewControllerTypeKecamatan,
    PickerViewControllerTypeKelurahan,
};

@protocol PickerViewControllerDelegate <NSObject>

- (void)itemTappedPickerViewControllerDelegate:(PickerViewControllerType)type pickedID:(NSString*)pickedID pickedName:(NSString*)pickedName;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PickerViewController : UIViewController
@property (strong, nonatomic) NSArray *masterArray;
@property (strong, nonatomic) NSString *titleString;
@property (nonatomic) PickerViewControllerType type;
@property (weak, nonatomic) id<PickerViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
