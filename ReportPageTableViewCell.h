//
//  ReportPageTableViewCell.h
//  PeSankita
//
//  Created by Admin on 5/4/19.
//  Copyright © 2019 Open Whisper Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportPageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tpsLabel;
@property (strong, nonatomic) IBOutlet UILabel *paslon1Label;
@property (strong, nonatomic) IBOutlet UILabel *paslon2Label;
@property (strong, nonatomic) IBOutlet UILabel *eligibleLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@end

NS_ASSUME_NONNULL_END
