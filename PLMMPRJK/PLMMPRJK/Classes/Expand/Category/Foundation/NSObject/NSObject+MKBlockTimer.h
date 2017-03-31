//
//  NSObject+MKBlockTimer.h
//  MKBlockTimerDemo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 4/4/13
//  Copyright (C) 2011-2020 by Steinlogic Consulting And Training Pte Ltd.

//  Uses code from http://stackoverflow.com/questions/741830/getting-the-time-elapsed-objective-c

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

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website
//	2) or crediting me inside the app's credits page
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	if you are re-publishing after editing, please retain the above copyright notices

#import <Foundation/Foundation.h>

@interface NSObject (MKBlockTimer)
-(void) logTimeTakenToRunBlock:(void (^)(void)) block withPrefix:(NSString*) prefixString;
@end
