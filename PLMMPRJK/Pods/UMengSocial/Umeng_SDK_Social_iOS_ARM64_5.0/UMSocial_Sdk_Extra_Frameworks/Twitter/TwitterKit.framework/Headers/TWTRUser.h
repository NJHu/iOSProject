//
//  TWTRUser.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Represents a user on Twitter.
 */
@interface TWTRUser : NSObject <NSCoding, NSCopying>

# pragma mark - Properties

/**
 *  The ID of the Twitter User.
 */
@property (nonatomic, copy, readonly) NSString *userID;

/**
 *  The user's name as it appears on their profile.
 *
 *  @warning This can be modified by the user at any time.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  The user's username on Twitter.
 *
 *  @warning This can be modified by the user at any time.
 */
@property (nonatomic, copy, readonly) NSString *screenName;

/**
 *  Whether the user has been verified by Twitter.
 */
@property (nonatomic, assign, readonly) BOOL isVerified;

/**
 *  Whether the user is protected.
 */
@property (nonatomic, assign, readonly) BOOL isProtected;

/**
 *  The HTTPS URL of the user's profile image.
 */
@property (nonatomic, copy, readonly) NSString *profileImageURL;

/**
 *  The URL of a smaller version of the user's profile image.
 */
@property (nonatomic, copy, readonly) NSString *profileImageMiniURL;

/**
 *  The URL of a larger version of the user's profile image.
 */
@property (nonatomic, copy, readonly) NSString *profileImageLargeURL;

/**
 *  The formatted version of the user's `screenName` with the `@` sign for display purposes.
 */
@property (nonatomic, copy, readonly) NSString *formattedScreenName;

# pragma mark - Init

/**
 *  Creates a Twitter user object from the dictionary of Twitter API JSON response.
 *
 *  @param dictionary A parsed dictionary of a single Twitter Tweet API JSON response.
 *
 *  @return An initialized TWTRUser instance.
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;

/**
 *  Creates an array of Twitter User instances from the array of Twitter API JSON response.
 *
 *  @param array A parsed array of Twitter User API JSON responses.
 *
 *  @return An array of initialized TWTRTweet instances.
 */
+ (NSArray *)usersWithJSONArray:(NSArray *)array;

@end