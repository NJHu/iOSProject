//
//  NSHTTPCookieStorage+FreezeDry.h
//
//  Created by Maciej Swic on 19/08/13.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

/*
    Persists UIWebView cookies to disk. To send the cookies with an initial NSURLRequest you must do the following after loading the cookies:
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:yourURL];
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [request setAllHTTPHeaderFields:headers];
*/
#import <Foundation/Foundation.h>

@interface NSHTTPCookieStorage (FreezeDry)
/**
 *  @brief 存储 UIWebView cookies到磁盘目录
 */
- (void)save;
/**
 *  @brief 读取UIWebView cookies从磁盘目录
 */
- (void)load;

@end
