//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class TSGroupModel;

@protocol OWSConversationSettingsViewDelegate <NSObject>

- (void)groupWasUpdated:(TSGroupModel *)groupModel;

- (void)groupWasUpdated:(TSGroupModel *)groupModel withRevoked:(NSMutableArray<NSString *> *)revokedIds;

- (void)popAllConversationSettingsViews;

@end

NS_ASSUME_NONNULL_END
