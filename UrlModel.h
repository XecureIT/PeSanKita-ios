//
//  UrlModel.h
//  Pergi
//
//  Created by Kristian on 01/02/18.
//  Copyright © 2018 Pergi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlModel : NSObject
@property (strong, nonatomic) NSString *fullUrl;
@property (strong, nonatomic) NSString *urlWithoutBaseUrl;

@end
