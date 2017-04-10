//
//  NSManagedObject+KRDictionaryExport
//
//  Created by Kishyr Ramdial on 2012/08/21.
//  Copyright (c) 2012 Kishyr Ramdial. All rights reserved.
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


// https://github.com/kishyr/KRDictionaryExport

// A category for NSManagedObject which exports a CoreData object into an NSDictionary, including all its relationships. The NSDictionary created is formatted for easy JSON-conversion using something like JSONKit or NSJSONSerialization.

#import <CoreData/CoreData.h>

@interface NSManagedObject (DictionaryExport)

- (NSDictionary *)asDictionary;
//http://stackoverflow.com/questions/5664423/storing-nsmanagedobject-in-a-dictionary-nsdictionary
- (NSDictionary *)Dictionary;
@end
