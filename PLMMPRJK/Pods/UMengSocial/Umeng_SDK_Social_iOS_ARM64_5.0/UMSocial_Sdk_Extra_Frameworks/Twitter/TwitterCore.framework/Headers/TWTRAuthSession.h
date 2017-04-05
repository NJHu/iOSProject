//
//  TWTRAuthSession.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Encapsulates the authorization details of an OAuth Session.
 */
@protocol TWTRAuthSession <NSObject>

@property (nonatomic, readonly, copy) NSString *authToken;
@property (nonatomic, readonly, copy) NSString *authTokenSecret;
@property (nonatomic, readonly, copy) NSString *userID;

@end
