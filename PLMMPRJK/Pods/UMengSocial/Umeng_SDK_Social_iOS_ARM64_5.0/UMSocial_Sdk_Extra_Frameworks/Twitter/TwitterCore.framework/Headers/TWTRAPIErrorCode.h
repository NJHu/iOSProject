//
//  TWTRAPIErrorCode.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The NSError domain of errors surfaced by the Twitter API.
 */
FOUNDATION_EXPORT NSString * const TWTRAPIErrorDomain;

/**
 *  Error codes surfaced by the Twitter API.
 *  @see https://dev.twitter.com/docs/error-codes-responses
 */
typedef NS_ENUM(NSUInteger, TWTRAPIErrorCode) {
    /**
     *  Your call could not be completed as dialed.
     */
    TWTRAPIErrorCodeCouldNotAuthenticate = 32,

    /**
     *  Corresponds with an HTTP 404 - the specified resource was not found.
     */
    TWTRAPIErrorCodePageNotExist = 34,

    /**
     *  Not authorized to use this endpoint.
     */
    TWTRAPIErrorCodeNotAuthorizedForEndpoint = 37,

    /**
     *  Corresponds with an HTTP 403 — the access token being used belongs to a suspended user and they can't complete the action you're trying to take
     */
    TWTRAPIErrorCodeAccountSuspended = 64,

    /**
     *  Corresponds to a HTTP request to a retired v1-era URL.
     */
    TWTRAPIErrorCodeAPIVersionRetired = 68,

    /**
     *  The request limit for this resource has been reached for the current rate limit window.
     */
    TWTRAPIErrorCodeRateLimitExceeded = 88,

    /**
     *  The access token used in the request is incorrect or has expired. Used in API v1.1.
     */
    TWTRAPIErrorCodeInvalidOrExpiredToken = 89,

    /**
     *  Only SSL connections are allowed in the API, you should update your request to a secure connection. See [how to connect using SSL](https://dev.twitter.com/docs/security/using-ssl).
     */
    TWTRAPIErrorCodeSSLInvalid = 92,

    /**
     *  Corresponds with an HTTP 503 - Twitter is temporarily over capacity.
     */
    TWTRAPIErrorCodeOverCapacity = 130,

    /**
     *  Corresponds with an HTTP 500 - An unknown internal error occurred.
     */
    TWTRAPIErrorCodeInternalError = 131,

    /**
     *  Corresponds with a HTTP 401 - it means that your oauth_timestamp is either ahead or behind our acceptable range.
     */
    TWTRAPIErrorCodeCouldNotAuthenticateTimestampOutOfRange = 135,

    /**
     *  You have already favorited this status.
     */
    TWTRAPIErrorCodeAlreadyFavorited = 139,

    /**
     *  Corresponds with HTTP 403 — returned when a user cannot follow another user due to some kind of limit.
     */
    TWTRAPIErrorCodeCannotFollowOverLimit = 161,

    /**
     *  Corresponds with HTTP 403 — returned when a Tweet cannot be viewed by the authenticating user, usually due to the Tweet's author having protected their Tweets.
     */
    TWTRAPIErrorCodeNotAuthorizedToSeeStatus = 179,

    /**
     *  Corresponds with HTTP 403 — returned when a Tweet cannot be posted due to the user having no allowance remaining to post. Despite the text in the error message indicating that this error is only returned when a daily limit is reached, this error will be returned whenever a posting limitation has been reached. Posting allowances have roaming windows of time of unspecified duration.
     */
    TWTRAPIErrorCodeOverDailyStatusUpdateLimit = 185,

    /**
     *  The status text has been Tweeted already by the authenticated account.
     */
    TWTRAPIErrorCodeStatusIsDuplicate = 187,

    /**
     *  Typically sent with 1.1 responses with HTTP code 400. The method requires authentication but it was not presented or was wholly invalid.
     */
    TWTRAPIErrorCodeBadAuthenticationData = 215,

    /**
     *  We constantly monitor and adjust our filters to block spam and malicious activity on the Twitter platform. These systems are tuned in real-time. If you get this response our systems have flagged the Tweet or DM as possibly fitting this profile. If you feel that the Tweet or DM you attempted to create was flagged in error, please report the details around that to us by filing a ticket at https://support.twitter.com/forms/platform
     */
    TWTRAPIErrorCodeRequestIsAutomated = 226,

    /**
     *  Returned as a challenge in xAuth when the user has login verification enabled on their account and needs to be directed to twitter.com to [generate a temporary password](https://twitter.com/settings/applications).
     */
    TWTRAPIErrorCodeUserMustVerifyLogin = 231,

    /**
     *  "Bad guest token." The token has probably expired. Try calling `-[Twitter logInGuestWithCompletion:]` again later.
     */
    TWTRAPIErrorCodeBadGuestToken = 239,

    /**
     *  Corresponds to a HTTP request to a retired URL.
     */
    TWTRAPIErrorCodeEndpointRetired = 251,

    /**
     *  Corresponds with HTTP 403 — returned when the application is restricted from POST, PUT, or DELETE actions. See [How to appeal application suspension and other disciplinary actions](https://support.twitter.com/articles/72585).
     */
    TWTRAPIErrorCodeApplicationCannotPerformWriteAction = 261,

    /**
     *  Corresponds with HTTP 403. The authenticated user account cannot mute itself.
     */
    TWTRAPIErrorCodeCannotMuteSelf = 271,

    /**
     *  Corresponds with HTTP 403. The authenticated user account is not muting the account a call is attempting to unmute.
     */
    TWTRAPIErrorCodeCannotMuteSpecifiedUser = 272,

    /**
     *  You have already retweeted this tweet.
     */
    TWTRAPIErrorCodeAlreadyRetweeted = 327,

    /**
     *  Returned in API v1.1 when a request cannot be served due to the application's rate limit having been exhausted for the resource. See [Rate Limiting in API v1.1](https://dev.twitter.com/docs/rate-limiting/1.1).
     */
    TWTRAPIErrorCodeTooManyRequests = 429
};