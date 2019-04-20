//
//  DataManager.m
//

#import "DataManager.h"
#import "APIManager.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
//#import "Base64.h"

@interface DataManager ()

+ (void)logErrorStringFromError:(NSError *)error;
+ (BOOL)isResponseSuccess:(NSDictionary *)responseDictionary;

@end

@implementation DataManager

#pragma mark - Lifecycle


#pragma mark - Custom Method
+ (void)logErrorStringFromError:(NSError *)error {
    NSString *dataString = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
#if DEBUG
    NSLog(@"Error Response: %@", dataString);
#endif
}

+ (BOOL)isResponseSuccess:(NSDictionary *)responseDictionary {
//    NSDictionary *errorDictionary = responseDictionary;
//
//    if(errorDictionary == nil || [errorDictionary allKeys].count == 0) {
//        return YES;
//    }
    
    NSInteger errorCode = [[responseDictionary valueForKeyPath:@"code"] integerValue];
    
    if(errorCode == 4001) {
        //Error with message

        return NO;
    }
    if(errorCode == 200) {
        //Success
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)isDataEmpty:(NSDictionary *)responseDictionary {
    NSDictionary *dataDictionary = [responseDictionary objectForKey:@"data"];
    
    if(dataDictionary == nil || [dataDictionary allKeys].count == 0) {
        return YES;
    }
    
    NSInteger errorCode = [[responseDictionary valueForKeyPath:@"error.code"] integerValue];
    
    if(errorCode == 204) {
        return YES;
    }
    
    return NO;
}

+ (void)callAPILoginWithEmail:(NSString *)email
                  andPassword:(NSString *)password
                      success:(void (^)(NSDictionary *member))success
                      failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypeLogin].fullUrl;
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:email forKey:@"username"];
    [parameterDictionary setObject:password forKey:@"password"];

    
    [[NetworkManager sharedManager]post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    }
    success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        NSLog(@"LOGIN RESPONSE --- %@", responseObject);
        
        if(![self isResponseSuccess:responseObject]) {
//            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
//            if(errorCode == 401 || errorCode == 406 || errorCode == 402) {
//
//                [DataManager callAPIRefreshTokenOrSessionIdWithErrorCode:errorCode Success:^(NSDictionary *responseObject) {
//                    [DataManager callAPILoginWithEmail:email andPassword:password success:^(Member *member) {
//                        success(member);
//                    } failure:^(NSError *error) {
//                        failure(error);
//                    }];
//                } failure:^(NSError *error) {
//                    failure(error);
//                }];
//                return;
//            }
            NSError *error = [NSError errorWithDomain:[[responseObject valueForKeyPath:@"message"] firstObject] code:[[responseObject valueForKeyPath:@"code"] integerValue] userInfo:@{@"message":[ [responseObject valueForKeyPath:@"message"] firstObject]}];
            failure(error);
            return ;
        }
        
        NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];

       
        
        success(dataDictionary);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        [DataManager logErrorStringFromError:error];
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(localizedError);
    }];
    
}

+ (void)callAPIRegisterWithMsisdn:(NSString *)phone
                         password:(NSString *)password
                             name:(NSString *)name
                         referral:(NSString *)referral
                          success:(void (^)(NSDictionary *activationToken))success
                          failure:(void (^)(NSError *error))failure{
    NSString *requestURL = [APIManager urlForType:APIManagerTypeRegister].fullUrl;
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",phone] forKey:@"msisdn"];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",name] forKey:@"name"];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",password] forKey:@"password"];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",referral] forKey:@"referral"];
    
    [[NetworkManager sharedManager]post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}
+ (void)callAPIGetSubmisionWithSuccess:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure {
    NSString *requestURL = [APIManager urlForType:APIManagerTypeGetSubmision].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    
    [[NetworkManager sharedManager] get:requestURL parameters:parameterDictionary progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject); 
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

+ (void)callAPIGetProvinsiWithSuccess:(void (^)(NSDictionary *success))success
                              failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypeGetProvinsi].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    
    [[NetworkManager sharedManager] get:requestURL parameters:parameterDictionary progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

+ (void)callAPIGetKabupatenWithProvinsiID:(NSString *)provinsiID
                                  success:(void (^)(NSDictionary *success))success
                                  failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypeGetKabupaten].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:provinsiID forKey:@"p"];
    
    [[NetworkManager sharedManager] get:requestURL parameters:parameterDictionary progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

+ (void)callAPIGetKecamatanWithKabupatenID:(NSString *)kabupatenID
                                   success:(void (^)(NSDictionary *success))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypeGetKecamatan].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:kabupatenID forKey:@"p"];
    
    [[NetworkManager sharedManager] get:requestURL parameters:parameterDictionary progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

+ (void)callAPIGetKelurahanWithKecamatanID:(NSString *)kecamatanID
                                   success:(void (^)(NSDictionary *success))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypeGetKelurahan].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:kecamatanID forKey:@"p"];
    
    [[NetworkManager sharedManager] get:requestURL parameters:parameterDictionary progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject); 
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

+ (void)callAPIGetUploadURLWithAttachmentID:(NSString *)attachmentID
                                    success:(void (^)(NSDictionary *success))success
                                    failure:(void (^)(NSError *error))failure{
    NSString *requestURL = [APIManager urlForType:APIManagerTypeGetImageUploadURL].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:attachmentID forKey:@"attachmentId"];
    [parameterDictionary setObject:@"image/jpeg" forKey:@"ctype"];
    
    [[NetworkManager sharedManager] get:requestURL parameters:parameterDictionary progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject); 
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

+ (void)callAPISubmitFormWithAttachmentID:(NSString *)attachmentID
                                   count1:(NSString *)count1
                                   count2:(NSString *)count2
                                       s1:(NSString *)s1
                                       n1:(NSString *)n1
                                    idkel:(NSString *)idkel
                                    notps:(NSString *)notps
                                    token:(NSString *)token
                                  success:(void (^)(NSDictionary *success))success
                                  failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypePostSubmision].fullUrl;
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:attachmentID forKey:@"attachmentId"];
    [parameterDictionary setObject:[NSNumber numberWithInt:[count1 integerValue]]  forKey:@"count1"];
    [parameterDictionary setObject:[NSNumber numberWithInt:[count2 integerValue]] forKey:@"count2"];
    [parameterDictionary setObject:[NSNumber numberWithInt:[s1 integerValue]] forKey:@"s1"];
    [parameterDictionary setObject:[NSNumber numberWithInt:[n1 integerValue]] forKey:@"n1"];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@", idkel] forKey:@"idkel"];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@", notps] forKey:@"notps"];
    [parameterDictionary setObject:token forKey:@"token"];
    
    [[NetworkManager sharedManager] post:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"Kami mengalami kegagalan koneksi ke server, silakan coba beberapa saat lagi...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"gagal untuk terhubung ke server, silakan coba beberapa saat lagi...", @"")}];
        failure(error);
    }];
}

@end
