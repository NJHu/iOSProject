//
//  NSURL+Query.h
//  NSURL+Query
//
//  Created by Jon Crooke on 10/12/2013.
//  Copyright (c) 2013 Jonathan Crooke. All rights reserved.
//
// https://github.com/itsthejb/NSURL-QueryDictionary
#import <Foundation/Foundation.h>

@interface NSURL (UQ_URLQuery)

/**
 *  @return URL's query component as keys/values
 *  Returns nil for an empty query
 */
- (NSDictionary*) uq_queryDictionary;

/**
 *  @return URL with keys values appending to query string
 *  @param queryDictionary Query keys/values
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @warning If keys overlap in receiver and query dictionary,
 *  behaviour is undefined.
 */
- (NSURL*) uq_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary
                             withSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSURL*) uq_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary;

/**
 *  @return Copy of URL with its query component replaced with
 *  the specified dictionary.
 *  @param queryDictionary A new query dictionary
 *  @param sortedKeys      Whether or not to sort the query keys
 */
- (NSURL*) uq_URLByReplacingQueryWithDictionary:(NSDictionary*) queryDictionary
                                 withSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSURL*) uq_URLByReplacingQueryWithDictionary:(NSDictionary*) queryDictionary;

/** @return Receiver with query component completely removed */
- (NSURL*) uq_URLByRemovingQuery;

@end

#pragma mark -

@interface NSString (UQ_URLQuery)

/**
 *  @return If the receiver is a valid URL query component, returns
 *  components as key/value pairs. If couldn't split into *any* pairs,
 *  returns nil.
 */
- (NSDictionary*) uq_URLQueryDictionary;

@end

#pragma mark -

@interface NSDictionary (UQ_URLQuery)

/**
 *  @return URL query string component created from the keys and values in
 *  the dictionary. Returns nil for an empty dictionary.
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @see cavetas from the main `NSURL` category as well.
 */
- (NSString*) uq_URLQueryStringWithSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSString*) uq_URLQueryString;

@end
