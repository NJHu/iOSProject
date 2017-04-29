//
//  IFlyContact.h
//  msc
//
//  Created by ypzhao on 13-3-1.
//  Copyright (c) 2013年 IFLYTEK. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  此接口为获取通信录中的联系人
 *    获取联系人是为了在进行语音识别时(sms)能更好的识别出您说的人名,联系人上传是属于个性化的
 *  一部分.
 */
@interface IFlyContact : NSObject

/*!
 *  获取联系人
 *    调用此方法需要添加 AddressBook.framework 到工程中，调用此方法后可以直接将通信录中的联系
 *  人转化为语音云识别的数据结构。您可以将获取的数据通过IFlyDataUploader类，上传到语音云，我们
 *  只获取通信录中的人名
 *
 *  @return  返回联系人信息
 */
- (NSString *) contact;
@end
