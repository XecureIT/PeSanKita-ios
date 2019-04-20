//
//  APIManager.h
//
//
//  Created by Ritchie Nathaniel on 8/13/15.
//  Copyright (c) 2015 Ritchie Nathaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlModel.h"
typedef NS_ENUM(NSInteger, APIManagerType) {
    APIManagerTypeExample,
    APIManagerTypeLogin,
    APIManagerTypeRegister,
    APIManagerTypeGetSubmision,
    APIManagerTypeGetProvinsi,
    APIManagerTypeGetKabupaten,
    APIManagerTypeGetKelurahan,
    APIManagerTypeGetKecamatan,
    APIManagerTypeGetImageUploadURL,
    APIManagerTypePostSubmision,
};

@interface APIManager : NSObject

+ (APIManager *)sharedManager;
+ (UrlModel *)urlForType:(APIManagerType)type;

@end
