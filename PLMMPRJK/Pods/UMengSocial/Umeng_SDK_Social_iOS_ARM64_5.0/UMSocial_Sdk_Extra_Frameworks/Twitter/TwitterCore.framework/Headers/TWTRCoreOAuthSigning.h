//
//  TWTRCoreOAuthSigning.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const TWTROAuthEchoRequestURLStringKey;
FOUNDATION_EXPORT NSString * const TWTROAuthEchoAuthorizationHeaderKey;

@protocol TWTRCoreOAuthSigning <NSObject>

/**
 *  @name OAuth Echo
 */

/**
 *  OAuth Echo is a means to securely delegate OAuth authorization to a third party while interacting with an API.
 *  For example, you may wish to verify a user's credentials from your app's server (the third party) rather than your app.
 *  This method provides you with the OAuth signature to add to the third party's request to `URLString`, as well as the formed
 *  URL with the query string to send that request to.
 *  This is equivalent to calling `-URLRequestWithMethod:URL:parameters:error:` and getting the URL and the `Authorization` HTTP header out of the request.
 *
 *  @param method       Request method, GET, POST, PUT, DELETE, etc.
 *  @param URLString    The full URL of the Twitter endpoint you plan to send a request to. E.g. https://api.twitter.com/1.1/account/verify_credentials.json
 *  @param parameters   Request parameters.
 *  @param error        Error in the `TWTRErrorDomain` domain. The code will be `TWTRErrorCodeInvalidURL` if the `URLString`'s host is not api.twitter.com
 *
 *  @return `nil` if there's an error or a missing required parameter, or a dictionary with the fully formed request URL under `TWTROAuthEchoRequestURLStringKey` (`NSString`), and the `Authorization` header in `TWTROAuthEchoAuthorizationHeaderKey` (`NSString`), to be used to sign the request.
 *
 *  @see More information about OAuth Echo: https://dev.twitter.com/oauth/echo
 */
- (NSDictionary *)OAuthEchoHeadersForRequestMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError **)error __attribute__((nonnull(1, 2)));

/**
 *  This method provides you with the OAuth signature, as well as the formed URL with the query string, to send a request to `verify_credentials`.
 *
 *  @return A dictionary with the fully formed Request URL under `TWTROAuthEchoRequestURLStringKey` (`NSString`), and the `Authorization` header in `TWTROAuthEchoAuthorizationHeaderKey` (`NSString`), to be used to sign the request.
 *
 *  @see More information about OAuth Echo: https://dev.twitter.com/oauth/echo
 *  @see More information about Verify Credentials: https://dev.twitter.com/rest/reference/get/account/verify_credentials
 */
- (NSDictionary *)OAuthEchoHeadersToVerifyCredentials;

@end
