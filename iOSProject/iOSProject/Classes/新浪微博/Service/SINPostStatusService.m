//
//  SINPostStatusService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINPostStatusService.h"
#import "SIN.h"

@implementation SINPostStatusService


- (void)retweetText:(NSString *)postText images:(NSArray<UIImage *> *)images completion:(void(^)(BOOL isSucceed))completion
{
    // 大家不要发这个微博了
    if (![SINUserManager sharedManager].isLogined || [LMJThirdSDKSinaAppKey isEqualToString:@"4061770881"]) {
        NSLog(@"没有登录没有登录没有登录没有登录没有登录");
        completion(NO);
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [SINUserManager sharedManager].accessToken.copy;
    params[@"status"] = postText.copy;
    
    if (images.count == 0) {
        
       NSString *urlString = @"https://api.weibo.com/2/statuses/update.json";
        
        
        [self POST:urlString parameters:params completion:^(LMJBaseResponse *response) {
            
            if (!response.error) {
                completion(YES);
            }else
            {
                completion(NO);
            }
            
        }];
        
        
        
    }else
    {
        NSString *urlString = @"https://api.weibo.com/2/statuses/upload.json";
        
        
        [[LMJRequestManager sharedManager] upload:urlString parameters:params formDataBlock:^NSDictionary<NSData *,LMJDataName *> *(id<AFMultipartFormData> formData, NSMutableDictionary<NSData *,LMJDataName *> *needFillDataDict) {
            
            //  data 图片对应的二进制数据
            //  name 服务端需要参数
            //  fileName 图片对应名字,一般服务不会使用,因为服务端会直接根据你上传的图片随机产生一个唯一的图片名字
            //  mimeType 资源类型
            //  不确定参数类型 可以这个 octet-stream 类型, 二进制流
            
            [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
//                [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.6) name:@"pic" fileName:[NSString stringWithFormat:@"pic_%zd", idx] mimeType:@"application/octet-stream"];
                needFillDataDict[UIImageJPEGRepresentation(obj, 0.6)] = @"pic";
            }];
            
            return needFillDataDict;
            
        } progress:^(NSProgress *progress) {
            
            
        } completion:^(LMJBaseResponse *response) {
            
            
            if (!response.error) {
                completion(YES);
            }else
            {
                completion(NO);
            }
            
        }];
        
    }
    
    
}


@end
