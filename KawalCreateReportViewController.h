//
//  KawalCreateReportViewController.h
//  PeSankita
//
//  Created by Admin on 4/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KawalCreateReportViewControllerType) {
    KawalCreateReportViewControllerTypeDefault = 0,
    KawalCreateReportViewControllerTypePreview = 1
    
};

@interface KawalCreateReportViewController : UIViewController
@property (nonatomic) KawalCreateReportViewControllerType type;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSDictionary *filledDictionary;
@end

NS_ASSUME_NONNULL_END
