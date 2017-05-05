//
//  LMJUploadImagesService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJUploadImagesService.h"

@implementation LMJUploadImagesService

- (NSDictionary *)requestParameters:(LMJBaseRequest *)request
{
    return @{@"username" : @"NJHu"};
}

- (NSString *)requestURL:(LMJBaseRequest *)request
{
    return [LMJBaseRequestURL stringByAppendingPathComponent:@"upload"];
}

- (void)uploadWithProgress:(void (^)(NSProgress *))progress completion:(void (^)(LMJBaseResponse *))completion
{
    NSString *mineType = @"application/octet-stream";
    NSString *name = @"file";
    
    [[LMJRequestManager sharedManager] upload:[self requestURL:self] parameters:[self requestParameters:self] formDataBlock:^(id<AFMultipartFormData> formData) {
        
        [self.imagesArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.9) name:name fileName:@"test.png" mimeType:mineType];
            
        }];
        
        
    } progress:progress completion:completion];
}

@end
