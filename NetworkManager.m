//
//  NetworkManager.m
//  Moselo
//
//  Created by Ritchie Nathaniel on 3/9/17.
//  Copyright © 2017 Moselo. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPSessionManager.h"
#import "Base64.h"
static const NSInteger kAPITimeOut = 300;

@interface NetworkManager ()

- (AFHTTPSessionManager *)defaultManager;
- (NSString *)urlEncodeForString:(NSString *)stringToEncode;

@end

@implementation NetworkManager

#pragma mark - Lifecycle
+ (NetworkManager *)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if(self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"Connected via mobile network");
                    break;
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"Connected via Wifi");
                    break;
                    case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"Disconnected");
                    break;
                default:
                    break;
            }
        }];
    }
    
    return self;
}

#pragma mark - Custom Method
- (AFHTTPSessionManager *)defaultManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:kAPITimeOut];
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"msisdn"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pswd"];
    
    NSString *phoneString = phone;
    phoneString = [phoneString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", phoneString, pswd];

    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isloggedin"]) {
        [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    return manager;
}

- (void)get:(NSString *)urlString
 parameters:(NSDictionary *)parameters
   progress:(void (^)(NSProgress *))progress
    success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
//    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
//        //No internet connection notification
//        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
//        
//        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
//        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
//        
//        failure (nil, error);
//    }
    
    [[self defaultManager] GET:urlString
                    parameters:parameters
                      progress:^(NSProgress * _Nonnull downloadProgress) {
                          progress(downloadProgress);
                      }
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(task, (NSDictionary *)responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(task, error);
                       }];
}

- (void)post:(NSString *)urlString
  parameters:(NSDictionary *)parameters
    progress:(void (^)(NSProgress *))progress
     success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] POST:urlString
                     parameters:parameters
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           progress(uploadProgress);
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            success(task, (NSDictionary *)responseObject);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            failure(task, error);
                        }];
}

- (void)put:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] PUT:urlString
                    parameters:parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(task, (NSDictionary *)responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(task, error);
                       }];
}

- (void)delete:(NSString *)urlString
    parameters:(NSDictionary *)parameters
       success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] DELETE:urlString
                       parameters:parameters
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              success(task, (NSDictionary *)responseObject);
    }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              failure(task, error);
    }];
}

- (NSString *)urlEncodedStringFromDictionary:(NSDictionary *)parameterDictionary {
    NSMutableString *parameterString = [NSMutableString stringWithString:@""];
    
    NSArray *parameterKeyArray = [parameterDictionary allKeys];
    
    for(NSInteger count = 0; count < [parameterKeyArray count]; count++) {
        NSString *parameterKey = [parameterKeyArray objectAtIndex:count];
        
        if(count > 0) {
            [parameterString appendString:@"&"];
        }
        
        NSString *parameterValue = [parameterDictionary objectForKey:parameterKey];
        NSString *encodedParameterValue = [self urlEncodeForString:parameterValue];
        
        [parameterString appendFormat:@"%@=%@", parameterKey, encodedParameterValue];
    }
    
    return parameterString;
}

- (NSString *)urlEncodeForString:(NSString *)stringToEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[stringToEncode UTF8String];
    
    NSInteger sourceLen = strlen((const char *)source);
    
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}


@end
