//
//  WeiboUser.h
//  WeiboSDK
//
//  Created by DannionQiu on 14-9-23.
//  Copyright (c) 2014年 SINA iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/*@
    You can get the latest WeiboUser field description on http://open.weibo.com/wiki/2/friendships/friends/en .
*/
@interface WeiboUser : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)paraDict;
+ (instancetype)userWithDictionary:(NSDictionary*)paraDict;

// Validate the dictionary to be converted.
+ (BOOL)isValidForDictionary:(NSDictionary *)dict;

- (BOOL)updateWithDictionary:(NSDictionary*)paraDict;


@property(readwrite, strong, nonatomic) NSString* userID;
@property(readwrite, strong, nonatomic) NSString* userClass;
@property(readwrite, strong, nonatomic) NSString* screenName;
@property(readwrite, strong, nonatomic) NSString* name;
@property(readwrite, strong, nonatomic) NSString* province;
@property(readwrite, strong, nonatomic) NSString* city;
@property(readwrite, strong, nonatomic) NSString* location;
@property(readwrite, strong, nonatomic) NSString* userDescription;
@property(readwrite, strong, nonatomic) NSString* url;
@property(readwrite, strong, nonatomic) NSString* profileImageUrl;
@property(readwrite, strong, nonatomic) NSString* coverImageUrl;
@property(readwrite, strong, nonatomic) NSString* coverImageForPhoneUrl;
@property(readwrite, strong, nonatomic) NSString* profileUrl;
@property(readwrite, strong, nonatomic) NSString* userDomain;
@property(readwrite, strong, nonatomic) NSString* weihao;
@property(readwrite, strong, nonatomic) NSString* gender;
@property(readwrite, strong, nonatomic) NSString* followersCount;
@property(readwrite, strong, nonatomic) NSString* friendsCount;
@property(readwrite, strong, nonatomic) NSString* pageFriendsCount;
@property(readwrite, strong, nonatomic) NSString* statusesCount;
@property(readwrite, strong, nonatomic) NSString* favouritesCount;
@property(readwrite, strong, nonatomic) NSString* createdTime;
@property(readwrite, assign, nonatomic) BOOL isFollowingMe;
@property(readwrite, assign, nonatomic) BOOL isFollowingByMe;
@property(readwrite, assign, nonatomic) BOOL isAllowAllActMsg;
@property(readwrite, assign, nonatomic) BOOL isAllowAllComment;
@property(readwrite, assign, nonatomic) BOOL isGeoEnabled;
@property(readwrite, assign, nonatomic) BOOL isVerified;
@property(readwrite, strong, nonatomic) NSString* verifiedType;
@property(readwrite, strong, nonatomic) NSString* remark;
@property(readwrite, strong, nonatomic) NSString* statusID;
@property(readwrite, strong, nonatomic) NSString* ptype;
@property(readwrite, strong, nonatomic) NSString* avatarLargeUrl;
@property(readwrite, strong, nonatomic) NSString* avatarHDUrl;
@property(readwrite, strong, nonatomic) NSString* verifiedReason;
@property(readwrite, strong, nonatomic) NSString* verifiedTrade;
@property(readwrite, strong, nonatomic) NSString* verifiedReasonUrl;
@property(readwrite, strong, nonatomic) NSString* verifiedSource;
@property(readwrite, strong, nonatomic) NSString* verifiedSourceUrl;
@property(readwrite, strong, nonatomic) NSString* verifiedState;
@property(readwrite, strong, nonatomic) NSString* verifiedLevel;
@property(readwrite, strong, nonatomic) NSString* onlineStatus;
@property(readwrite, strong, nonatomic) NSString* biFollowersCount;
@property(readwrite, strong, nonatomic) NSString* language;
@property(readwrite, strong, nonatomic) NSString* star;
@property(readwrite, strong, nonatomic) NSString* mbtype;
@property(readwrite, strong, nonatomic) NSString* mbrank;
@property(readwrite, strong, nonatomic) NSString* block_word;
@property(readwrite, strong, nonatomic) NSString* block_app;
@property(readwrite, strong, nonatomic) NSString* credit_score;
@property(readwrite, strong, nonatomic) NSDictionary* originParaDict;

@end
