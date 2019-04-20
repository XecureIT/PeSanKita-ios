//
//  DataManager.h


#import <Foundation/Foundation.h>


@interface DataManager : NSObject

+ (BOOL)isResponseSuccess:(NSDictionary *)responseDictionary;

+ (void)callAPILoginWithEmail:(NSString *)email
                  andPassword:(NSString *)password
                      success:(void (^)(NSDictionary *member))success
                      failure:(void (^)(NSError *error))failure;

+ (void)callAPIRegisterWithMsisdn:(NSString *)phone
                         password:(NSString *)password
                             name:(NSString *)name
                         referral:(NSString *)referral
                          success:(void (^)(NSDictionary *activationToken))success
                          failure:(void (^)(NSError *error))failure;

+ (void)callAPIGetSubmisionWithSuccess:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure;

+ (void)callAPIGetProvinsiWithSuccess:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure;

+ (void)callAPIGetKabupatenWithProvinsiID:(NSString *)provinsiID
                                  success:(void (^)(NSDictionary *success))success
                                  failure:(void (^)(NSError *error))failure;

+ (void)callAPIGetKecamatanWithKabupatenID:(NSString *)kabupatenID
                                  success:(void (^)(NSDictionary *success))success
                                  failure:(void (^)(NSError *error))failure;

+ (void)callAPIGetKelurahanWithKecamatanID:(NSString *)kecamatanID
                                  success:(void (^)(NSDictionary *success))success
                                  failure:(void (^)(NSError *error))failure;

+ (void)callAPIGetUploadURLWithAttachmentID:(NSString *)attachmentID
                                    success:(void (^)(NSDictionary *success))success
                                    failure:(void (^)(NSError *error))failure;

+ (void)callAPISubmitFormWithAttachmentID:(NSString *)attachmentID
                                   count1:(NSString *)count1
                                   count2:(NSString *)count2
                                       s1:(NSString *)s1
                                       n1:(NSString *)n1
                                    idkel:(NSString *)idkel
                                    notps:(NSString *)notps
                                    token:(NSString *)token
                                  success:(void (^)(NSDictionary *success))success
                                  failure:(void (^)(NSError *error))failure;

@end
