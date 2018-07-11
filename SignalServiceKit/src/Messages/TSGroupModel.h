//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

#import "TSYapDatabaseObject.h"
#import "ContactsManagerProtocol.h"

@interface TSGroupModel : TSYapDatabaseObject

@property (nonatomic, strong) NSMutableArray<NSString *> *groupMemberIds;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSData *groupId;
@property (nonatomic, strong) NSString *groupOwnerId;
@property (nonatomic, strong) NSMutableArray *groupAdminIds;

#if TARGET_OS_IOS
@property (nonatomic, strong) UIImage *groupImage;

- (instancetype)initWithTitle:(NSString *)title
                    memberIds:(NSMutableArray<NSString *> *)memberIds
                        image:(UIImage *)image
                      groupId:(NSData *)groupId
                      ownerId:(NSString *)ownerId
                     adminIds:(NSMutableArray *)adminIds;

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToGroupModel:(TSGroupModel *)model;
- (NSString *)getInfoStringAboutUpdateTo:(TSGroupModel *)model contactsManager:(id<ContactsManagerProtocol>)contactsManager;
#endif

@end
