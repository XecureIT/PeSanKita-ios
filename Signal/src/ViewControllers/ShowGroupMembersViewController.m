//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

#import "ShowGroupMembersViewController.h"
#import "BlockListUIUtils.h"
#import "ContactTableViewCell.h"
#import "ContactsViewHelper.h"
#import "Environment.h"
#import "OWSContactsManager.h"
#import "SignalsViewController.h"
#import "PeSankita-Swift.h"
#import "UIUtil.h"
#import "ViewControllerUtils.h"
#import <AddressBookUI/AddressBookUI.h>
#import <SignalServiceKit/OWSBlockingManager.h>
#import <SignalServiceKit/SignalAccount.h>
#import <SignalServiceKit/TSGroupModel.h>
#import <SignalServiceKit/TSGroupThread.h>

@import ContactsUI;

NS_ASSUME_NONNULL_BEGIN

@interface ShowGroupMembersViewController () <ContactsViewHelperDelegate, ContactEditingDelegate>

@property (nonatomic, readonly) OWSContactsManager *contactsManager;
@property (nonatomic) YapDatabaseConnection *editingDatabaseConnection;
@property (nonatomic, readonly) TSStorageManager *storageManager;
@property (nonatomic, readonly) OWSMessageSender *messageSender;

@property (nonatomic, readonly) TSGroupThread *thread;
@property (nonatomic, readonly) ContactsViewHelper *contactsViewHelper;

@property (nonatomic, nullable) NSSet<NSString *> *memberRecipientIds;

@end

#pragma mark -

@implementation ShowGroupMembersViewController

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }

    [self commonInit];

    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return self;
    }

    [self commonInit];

    return self;
}


- (void)commonInit
{
    _contactsViewHelper = [[ContactsViewHelper alloc] initWithDelegate:self];
    _storageManager = [TSStorageManager sharedManager];
    _contactsManager = [Environment getCurrent].contactsManager;
    _messageSender = [Environment getCurrent].messageSender;

    [self observeNotifications];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(identityStateDidChange:)
                                                 name:kNSNotificationName_IdentityStateDidChange
                                               object:nil];
}

- (void)configWithThread:(TSGroupThread *)thread
{

    _thread = thread;

    OWSAssert(self.thread);
    OWSAssert(self.thread.groupModel);
    OWSAssert(self.thread.groupModel.groupMemberIds);
    
    DDLogDebug(@"Group owner id %@.", self.thread.groupModel.groupOwnerId);

    self.memberRecipientIds = [NSSet setWithArray:self.thread.groupModel.groupMemberIds];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // HACK otherwise CNContactViewController Navbar is shown as black.
    // RADAR rdar://28433898 http://www.openradar.me/28433898
    // CNContactViewController incompatible with opaque navigation bar
    [self.navigationController.navigationBar setTranslucent:YES];

    self.title = _thread.groupModel.groupName;

    [self updateTableContents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // In case we're dismissing a CNContactViewController which requires default system appearance
    [UIUtil applySignalAppearence];
}

#pragma mark - Table Contents

- (void)updateTableContents
{
    OWSAssert(self.thread);

    OWSTableContents *contents = [OWSTableContents new];

    __weak ShowGroupMembersViewController *weakSelf = self;
    ContactsViewHelper *helper = self.contactsViewHelper;

    OWSTableSection *membersSection = [OWSTableSection new];

    // Group Members

    // If there are "no longer verified" members of the group,
    // highlight them in a special section.
    NSArray<NSString *> *noLongerVerifiedRecipientIds = [self noLongerVerifiedRecipientIds];
    if (noLongerVerifiedRecipientIds.count > 0) {
        OWSTableSection *noLongerVerifiedSection = [OWSTableSection new];
        noLongerVerifiedSection.headerTitle = NSLocalizedString(@"GROUP_MEMBERS_SECTION_TITLE_NO_LONGER_VERIFIED",
            @"Title for the 'no longer verified' section of the 'group members' view.");
        membersSection.headerTitle = NSLocalizedString(
            @"GROUP_MEMBERS_SECTION_TITLE_MEMBERS", @"Title for the 'members' section of the 'group members' view.");
        [noLongerVerifiedSection
            addItem:[OWSTableItem disclosureItemWithText:NSLocalizedString(@"GROUP_MEMBERS_RESET_NO_LONGER_VERIFIED",
                                                             @"Label for the button that clears all verification "
                                                             @"errors in the 'group members' view.")
                                         customRowHeight:ContactTableViewCell.rowHeight
                                             actionBlock:^{
                                                 [weakSelf offerResetAllNoLongerVerified];
                                             }]];
        [self addMembers:noLongerVerifiedRecipientIds toSection:noLongerVerifiedSection useVerifyAction:YES];
        [contents addSection:noLongerVerifiedSection];
    }

    NSMutableSet *memberRecipientIds = [self.memberRecipientIds mutableCopy];
    [memberRecipientIds removeObject:[helper localNumber]];
    [self addMembers:memberRecipientIds.allObjects toSection:membersSection useVerifyAction:NO];
    [contents addSection:membersSection];

    self.contents = contents;
}

- (void)addMembers:(NSArray<NSString *> *)recipientIds
          toSection:(OWSTableSection *)section
    useVerifyAction:(BOOL)useVerifyAction
{
    OWSAssert(recipientIds);
    OWSAssert(section);

    __weak ShowGroupMembersViewController *weakSelf = self;
    ContactsViewHelper *helper = self.contactsViewHelper;
    for (NSString *recipientId in [recipientIds sortedArrayUsingSelector:@selector(compare:)]) {
        [section addItem:[OWSTableItem itemWithCustomCellBlock:^{
            ShowGroupMembersViewController *strongSelf = weakSelf;
            OWSCAssert(strongSelf);

            ContactTableViewCell *cell = [ContactTableViewCell new];
            SignalAccount *signalAccount = [helper signalAccountForRecipientId:recipientId];
            OWSVerificationState verificationState =
                [[OWSIdentityManager sharedManager] verificationStateForRecipientId:recipientId];
            BOOL isVerified = verificationState == OWSVerificationStateVerified;
            BOOL isNoLongerVerified = verificationState == OWSVerificationStateNoLongerVerified;
            BOOL isBlocked = [helper isRecipientIdBlocked:recipientId];
            BOOL isOwner   = [self isGroupOwner:recipientId];
            BOOL isAdmin   = [self isGroupAdmin:recipientId];
            
            if (isNoLongerVerified) {
                cell.accessoryMessage = NSLocalizedString(
                    @"CONTACT_CELL_IS_NO_LONGER_VERIFIED", @"An indicator that a contact is no longer verified.");
            } else if (isBlocked) {
                cell.accessoryMessage
                    = NSLocalizedString(@"CONTACT_CELL_IS_BLOCKED", @"An indicator that a contact has been blocked.");
            } else if (isOwner) {
                cell.accessoryMessage
                = NSLocalizedString(@"NEW_GROUP_MEMBER_IS_GROUP_OWNER", @"An indicator that a contact is owner of the current group.");
            } else if (isAdmin) {
                cell.accessoryMessage
                = NSLocalizedString(@"NEW_GROUP_MEMBER_IS_GROUP_ADMIN", @"An indicator that a contact is admin of the current group.");
            }

            if (signalAccount) {
                [cell configureWithSignalAccount:signalAccount contactsManager:helper.contactsManager];
            } else {
                [cell configureWithRecipientId:recipientId contactsManager:helper.contactsManager];
            }

            if (isVerified) {
                cell.subtitle.attributedText = cell.verifiedSubtitle;
            } else {
                cell.subtitle.attributedText = nil;
            }

            return cell;
        }
                             customRowHeight:[ContactTableViewCell rowHeight]
                             actionBlock:^{
                                 if (useVerifyAction) {
                                     [weakSelf showSafetyNumberView:recipientId];
                                 } else {
                                     [weakSelf didSelectRecipientId:recipientId];
                                 }
                             }]];
    }
}

- (BOOL)isGroupOwner:(NSString *)recipientId
{
    return [self.thread.groupModel.groupOwnerId isEqualToString:recipientId];
}

- (BOOL)isGroupAdmin:(NSString *)recipientId
{
    BOOL isAdmin   = FALSE;

    NSMutableArray *groupAdminIdsToSearch = [NSMutableArray arrayWithArray:self.thread.groupModel.groupAdminIds];
    for (NSString *compare in groupAdminIdsToSearch) {
        if ([compare isEqualToString:recipientId]) {
            isAdmin = TRUE;
            break;
        }
    }

    return isAdmin;
}

- (void)offerResetAllNoLongerVerified
{
    OWSAssert([NSThread isMainThread]);

    UIAlertController *actionSheetController = [UIAlertController
        alertControllerWithTitle:nil
                         message:NSLocalizedString(@"GROUP_MEMBERS_RESET_NO_LONGER_VERIFIED_ALERT_MESSAGE",
                                     @"Label for the 'reset all no-longer-verified group members' confirmation alert.")
                  preferredStyle:UIAlertControllerStyleAlert];

    __weak ShowGroupMembersViewController *weakSelf = self;
    UIAlertAction *verifyAction = [UIAlertAction
        actionWithTitle:NSLocalizedString(@"OK", nil)
                  style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *_Nonnull action) {
                    [weakSelf resetAllNoLongerVerified];
                }];
    [actionSheetController addAction:verifyAction];
    [actionSheetController addAction:[OWSAlerts cancelAction]];

    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)resetAllNoLongerVerified
{
    OWSAssert([NSThread isMainThread]);

    OWSIdentityManager *identityManger = [OWSIdentityManager sharedManager];
    NSArray<NSString *> *recipientIds = [self noLongerVerifiedRecipientIds];
    for (NSString *recipientId in recipientIds) {
        OWSVerificationState verificationState = [identityManger verificationStateForRecipientId:recipientId];
        if (verificationState == OWSVerificationStateNoLongerVerified) {
            NSData *identityKey = [identityManger identityKeyForRecipientId:recipientId];
            if (identityKey.length < 1) {
                OWSFail(@"Missing identity key for: %@", recipientId);
                continue;
            }
            [identityManger setVerificationState:OWSVerificationStateDefault
                                     identityKey:identityKey
                                     recipientId:recipientId
                           isUserInitiatedChange:YES];
        }
    }

    [self updateTableContents];
}

// Returns a collection of the group members who are "no longer verified".
- (NSArray<NSString *> *)noLongerVerifiedRecipientIds
{
    NSMutableArray<NSString *> *result = [NSMutableArray new];
    for (NSString *recipientId in self.thread.recipientIdentifiers) {
        if ([[OWSIdentityManager sharedManager] verificationStateForRecipientId:recipientId]
            == OWSVerificationStateNoLongerVerified) {
            [result addObject:recipientId];
        }
    }
    return [result copy];
}

- (void)didSelectRecipientId:(NSString *)recipientId
{
    OWSAssert(recipientId.length > 0);

    ContactsViewHelper *helper = self.contactsViewHelper;
    SignalAccount *signalAccount = [helper signalAccountForRecipientId:recipientId];

    UIAlertController *actionSheetController =
        [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if (self.contactsViewHelper.contactsManager.supportsContactEditing) {
        NSString *contactInfoTitle = signalAccount
            ? NSLocalizedString(@"GROUP_MEMBERS_VIEW_CONTACT_INFO", @"Button label for the 'show contact info' button")
            : NSLocalizedString(
                  @"GROUP_MEMBERS_ADD_CONTACT_INFO", @"Button label to add information to an unknown contact");
        [actionSheetController addAction:[UIAlertAction actionWithTitle:contactInfoTitle
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *_Nonnull action) {
                                                                    [self
                                                                        showContactInfoViewForRecipientId:recipientId];
                                                                }]];
    }

    BOOL isBlocked;
    if (signalAccount) {
        isBlocked = [helper isRecipientIdBlocked:signalAccount.recipientId];
        if (isBlocked) {
            [actionSheetController
                addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"BLOCK_LIST_UNBLOCK_BUTTON",
                                                             @"Button label for the 'unblock' button")
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     [BlockListUIUtils
                                                         showUnblockSignalAccountActionSheet:signalAccount
                                                                          fromViewController:self
                                                                             blockingManager:helper.blockingManager
                                                                             contactsManager:helper.contactsManager
                                                                             completionBlock:^(BOOL ignore) {
                                                                                 [self updateTableContents];
                                                                             }];
                                                 }]];
        } else {
            [actionSheetController
                addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"BLOCK_LIST_BLOCK_BUTTON",
                                                             @"Button label for the 'block' button")
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     [BlockListUIUtils
                                                         showBlockSignalAccountActionSheet:signalAccount
                                                                        fromViewController:self
                                                                           blockingManager:helper.blockingManager
                                                                           contactsManager:helper.contactsManager
                                                                           completionBlock:^(BOOL ignore) {
                                                                               [self updateTableContents];
                                                                           }];
                                                 }]];
        }
    } else {
        isBlocked = [helper isRecipientIdBlocked:recipientId];
        if (isBlocked) {
            [actionSheetController
                addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"BLOCK_LIST_UNBLOCK_BUTTON",
                                                             @"Button label for the 'unblock' button")
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     [BlockListUIUtils
                                                         showUnblockPhoneNumberActionSheet:recipientId
                                                                        fromViewController:self
                                                                           blockingManager:helper.blockingManager
                                                                           contactsManager:helper.contactsManager
                                                                           completionBlock:^(BOOL ignore) {
                                                                               [self updateTableContents];
                                                                           }];
                                                 }]];
        } else {
            [actionSheetController
                addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"BLOCK_LIST_BLOCK_BUTTON",
                                                             @"Button label for the 'block' button")
                                                   style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     [BlockListUIUtils
                                                         showBlockPhoneNumberActionSheet:recipientId
                                                                      fromViewController:self
                                                                         blockingManager:helper.blockingManager
                                                                         contactsManager:helper.contactsManager
                                                                         completionBlock:^(BOOL ignore) {
                                                                             [self updateTableContents];
                                                                         }];
                                                 }]];
        }
    }

    if (!isBlocked) {
        [actionSheetController
            addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GROUP_MEMBERS_SEND_MESSAGE",
                                                         @"Button label for the 'send message to group member' button")
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *_Nonnull action) {
                                                 [self showConversationViewForRecipientId:recipientId];
                                             }]];
        /*[actionSheetController
            addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"GROUP_MEMBERS_CALL",
                                                         @"Button label for the 'call group member' button")
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *_Nonnull action) {
                                                 [self callMember:recipientId];
                                             }]];*/
        [actionSheetController
            addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"VERIFY_PRIVACY",
                                                         @"Label for button or row which allows users to verify the "
                                                         @"safety number of another user.")
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *_Nonnull action) {
                                                 [self showSafetyNumberView:recipientId];
                                             }]];
        if ([self isGroupOwner:[helper localNumber]]) {
            if ([self isGroupAdmin:recipientId]) {
                [actionSheetController
                 addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"REVOKE_AS_GROUP_ADMIN",
                                                                            @"Button label for the 'revoke as group admin' button")
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *_Nonnull action) {
                                                      [self revokeAsGroupAdminWithId:recipientId];
                                                  }]];
            } else {
                [actionSheetController
                 addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"SET_AS_GROUP_ADMIN",
                                                                            @"Button label for the 'set as group admin' button")
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *_Nonnull action) {
                                                      [self setAsGroupAdminWithId:recipientId];
                                                  }]];
            }
        }
    }

    [actionSheetController addAction:[OWSAlerts cancelAction]];

    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)showContactInfoViewForRecipientId:(NSString *)recipientId
{
    OWSAssert(recipientId.length > 0);

    [self.contactsViewHelper presentContactViewControllerForRecipientId:recipientId
                                                     fromViewController:self
                                                        editImmediately:NO];
}

- (void)showConversationViewForRecipientId:(NSString *)recipientId
{
    OWSAssert(recipientId.length > 0);

    [Environment messageIdentifier:recipientId withCompose:YES];
}

/*- (void)callMember:(NSString *)recipientId
{
    [Environment callUserWithIdentifier:recipientId];
}*/

- (void)showSafetyNumberView:(NSString *)recipientId
{
    OWSAssert(recipientId.length > 0);

    [FingerprintViewController presentFromViewController:self recipientId:recipientId];
}

- (void)setAsGroupAdminWithId:(NSString *)recipientId
{
    if (![self isGroupAdmin:recipientId]) {
        NSMutableArray *adm = [[[NSSet setWithArray:_thread.groupModel.groupAdminIds] allObjects] mutableCopy];
        [adm addObject:recipientId];
        _thread.groupModel.groupAdminIds = [[[NSSet setWithArray:adm] allObjects] mutableCopy];
    }
    
    [self updateGroup];
    [self updateTableContents];
}

- (void)revokeAsGroupAdminWithId:(NSString *)recipientId
{
    if ([self isGroupAdmin:recipientId]) {
        NSMutableArray *adm = [[[NSSet setWithArray:_thread.groupModel.groupAdminIds] allObjects] mutableCopy];
        [adm removeObject:recipientId];
        _thread.groupModel.groupAdminIds = [[[NSSet setWithArray:adm] allObjects] mutableCopy];
    }
    
    [self updateGroup];
    [self updateTableContents];
}

- (void)updateGroup
{
    TSGroupModel *groupModel = [[TSGroupModel alloc] initWithTitle:_thread.groupModel.groupName
                                                         memberIds:_thread.groupModel.groupMemberIds
                                                             image:_thread.groupModel.groupImage
                                                           groupId:_thread.groupModel.groupId
                                                           ownerId:_thread.groupModel.groupOwnerId
                                                          adminIds:_thread.groupModel.groupAdminIds];
    
    [self updateGroupModelTo:groupModel successCompletion:nil];
}

- (YapDatabaseConnection *)editingDatabaseConnection
{
    if (!_editingDatabaseConnection) {
        _editingDatabaseConnection = [self.storageManager newDatabaseConnection];
    }
    return _editingDatabaseConnection;
}

- (void)updateGroupModelTo:(TSGroupModel *)newGroupModel successCompletion:(void (^_Nullable)())successCompletion
{
    __block TSGroupThread *groupThread;
    __block TSOutgoingMessage *message;
    
    [self.editingDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        groupThread = [TSGroupThread getOrCreateThreadWithGroupModel:newGroupModel transaction:transaction];
        
        NSString *updateGroupInfo =
        [groupThread.groupModel getInfoStringAboutUpdateTo:newGroupModel contactsManager:self.contactsManager];
        
        groupThread.groupModel = newGroupModel;
        [groupThread saveWithTransaction:transaction];
        message = [[TSOutgoingMessage alloc] initWithTimestamp:[NSDate ows_millisecondTimeStamp]
                                                      inThread:groupThread
                                              groupMetaMessage:TSGroupMessageUpdate];
        [message updateWithCustomMessage:updateGroupInfo transaction:transaction];
    }];
    
    if (newGroupModel.groupImage) {
        [self.messageSender sendAttachmentData:UIImagePNGRepresentation(newGroupModel.groupImage)
                                   contentType:OWSMimeTypeImagePng
                                sourceFilename:nil
                                     inMessage:message
                                       success:^{
                                           DDLogDebug(@"%@ Successfully sent group update with avatar", self.tag);
                                           if (successCompletion) {
                                               successCompletion();
                                           }
                                       }
                                       failure:^(NSError *_Nonnull error) {
                                           DDLogError(@"%@ Failed to send group avatar update with error: %@", self.tag, error);
                                       }];
    } else {
        [self.messageSender sendMessage:message
                                success:^{
                                    DDLogDebug(@"%@ Successfully sent group update", self.tag);
                                    if (successCompletion) {
                                        successCompletion();
                                    }
                                }
                                failure:^(NSError *_Nonnull error) {
                                    DDLogError(@"%@ Failed to send group update with error: %@", self.tag, error);
                                }];
    }
}

#pragma mark - ContactsViewHelperDelegate

- (void)contactsViewHelperDidUpdateContacts
{
    [self updateTableContents];
}

- (BOOL)shouldHideLocalNumber
{
    return YES;
}

#pragma mark - ContactEditingDelegate

- (void)didFinishEditingContact
{
    DDLogDebug(@"%@ %s", self.tag, __PRETTY_FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController
       didCompleteWithContact:(nullable CNContact *)contact
{
    DDLogDebug(@"%@ done editing contact.", self.tag);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notifications

- (void)identityStateDidChange:(NSNotification *)notification
{
    OWSAssert([NSThread isMainThread]);

    [self updateTableContents];
}

#pragma mark - Logging

+ (NSString *)tag
{
    return [NSString stringWithFormat:@"[%@]", self.class];
}

- (NSString *)tag
{
    return self.class.tag;
}

@end

NS_ASSUME_NONNULL_END
