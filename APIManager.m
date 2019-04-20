//
//  APIManager.m
//  
//
//  Created by Ritchie Nathaniel on 8/13/15.
//  Copyright (c) 2015 Ritchie Nathaniel. All rights reserved.
//

#import "APIManager.h"


static NSString * const kAPIBaseURL = @"https://";

@implementation APIManager

#pragma mark - Lifecycle
+ (APIManager *)sharedManager {
    static APIManager *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[APIManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Custom Method
+ (UrlModel *)urlForType:(APIManagerType)type {
    UrlModel *url = [UrlModel new];
    if(type == APIManagerTypeLogin) {
        NSString *apiPath = @"v1/login";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeRegister) {
        NSString *apiPath = @"v1/registration";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeGetSubmision) {
        NSString *apiPath = @"v1/submission";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeGetProvinsi) {
        NSString *apiPath = @"v1/provinsi";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeGetKabupaten) {
        NSString *apiPath = @"v1/kabupaten";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeGetKecamatan) {
        NSString *apiPath = @"v1/kecamatan";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeGetKelurahan) {
        NSString *apiPath = @"v1/kelurahan";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypeGetImageUploadURL) {
        NSString *apiPath = @"v1/submission/c1/url";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    else if(type == APIManagerTypePostSubmision) {
        NSString *apiPath = @"v1/submission";
        
        url.fullUrl = [NSString stringWithFormat:@"%@/%@/", kAPIBaseURL, apiPath];
        url.urlWithoutBaseUrl = [NSString stringWithFormat:@"/%@", apiPath];
        
        return url;
    }
    
    return url;
}

@end
