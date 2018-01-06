//
//  IFlyUserWords.h
//  MSC
//
//  Created by ypzhao on 13-2-26.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  用户词表类
 *    获取用户词表是为了更好的语音识别(iat)，用户词表也属于个性化的一部分.
 */
@interface IFlyUserWords  : NSObject

/*!
 *  初始化对象
 *     在进行初始化时，需要传入的格式如下：
 *  <pre><code>{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"科大讯飞\",
 *  \"云平台\",\"用户词条\",\"开始上传词条\"]}]}</code></pre>
 *
 *  @param json 初始化时传入的数据
 *
 *  @return IFlyUserWords对象
 */
- (id) initWithJson:(NSString *)json;

/*!
 *  将数据转化为上传的数据格式
 *
 *  @return 没有数据或者格式不对时返回nil
 */
- (NSString *) toString;

/*!
 *  返回key对应的数据
 *
 *  @param key  在putword:value中设置的key
 *
 *  @return key对应的数组
 */
- (NSArray *) getWords: (NSString *) key;

/*!
 *  添加一条用户词数据
 *
 *  @param key   用户词对应的key
 *  @param value 上传的用户词数据
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL) putWord: (NSString *) key value:(NSString *)value;

/*!
 *  添加一组数据
 *
 *  @param key   用户词对应的key
 *  @param words 上传的用户词数据
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL) putwords: (NSString *) key words:(NSArray *)words;

/*!
 *  是否包含key对应的用户词数据
 *
 *  @param key 用户词对应的key
 *
 *  @return 成功返回YES,失败返回NO
 */
- (BOOL) containsKey: (NSString *) key;
@end
