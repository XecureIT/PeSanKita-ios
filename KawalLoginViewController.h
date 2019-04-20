//
//  KawalLoginViewController.h
//  PeSankita
//
//  Created by Admin on 25/3/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KawalLoginViewControllerDelegate <NSObject>

- (void)successLoginKawalLoginViewControllerDelegate:(NSDictionary *)responseDictionary;

@end
NS_ASSUME_NONNULL_BEGIN

@interface KawalLoginViewController : UIViewController
@property (nonatomic, weak) id <KawalLoginViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
