//
//  SINStatusListService.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINStatusListService.h"
#import "NSDecimalNumber+Extensions.h"
#import "NSDecimalNumber+CalculatingByString.h"
#import "SINDictURL.h"

@interface SINStatusListService ()

/** <#digest#> */
@property (nonatomic, strong) id lastParams;

@end

@implementation SINStatusListService



- (void)getStatusList:(BOOL)isFresh complation:(void(^)(NSError *error, BOOL isEnd))completion
{
    
    NSString *URL = @"https://api.weibo.com/2/statuses/home_timeline.json";
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [SINUserManager sharedManager].accessToken.copy;
    params[@"count"] = @"10";
    
    //    since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    //    max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    if (isFresh) {
        
        params[@"since_id"] = self.statusViewModels.firstObject.status.idstr ?: @"0";
        
    }else
    {
        params[@"max_id"] = self.statusViewModels.lastObject.status.idstr ? SNSub(self.statusViewModels.lastObject.status.idstr, @"1").stringValue : @"0";
    }
    
    
    self.lastParams = params;
    [self GET:URL parameters:params completion:^(LMJBaseResponse *response) {
        if (self.lastParams != params) {
            return ;
        }
        
        
        if (response.error || !response.responseObject) {
            
            completion(response.error, NO);
            
            return ;
        }
        
        NSDictionary *responObj = response.responseObject;
        
        NSLog(@"%@", response.responseObject);
        
        NSMutableArray<SINStatus *> *statuses = [SINStatus mj_objectArrayWithKeyValuesArray:responObj[@"statuses"]];
        
        
        // 下载图片, 才能知道尺寸
        //                completion(nil, (SNCompare(@(self.statusViewModels.count), responObj[@"total_number"])) != LMJXY);
        
        dispatch_group_t downLoadImageGroup = dispatch_group_create();
       __block BOOL downLoadImageGroupSucceed = YES;
        
        
        
        [statuses enumerateObjectsUsingBlock:^(SINStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (!obj.thumbnail_pic.absoluteString.length || obj.pic_urls.count > 1) {
                
            }else
            {
                // 自己的图片
                dispatch_group_enter(downLoadImageGroup);
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:obj.thumbnail_pic options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    
                    if (!error && image && finished) {
                        
                        [obj.pic_urls enumerateObjectsUsingBlock:^(SINDictURL * _Nonnull imageDict, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            imageDict.picSize = image.size;
                            
                        }];
                        
                    }else
                    {
                        downLoadImageGroupSucceed = NO;
                    }
                    
                    dispatch_group_leave(downLoadImageGroup);
                }];
            }
            
            
            
            
            
            // 转发微博的图片
            if (!obj.retweeted_status.thumbnail_pic.absoluteString.length || obj.retweeted_status.pic_urls.count > 1) {
                
            }else
            {
                dispatch_group_enter(downLoadImageGroup);
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:obj.retweeted_status.thumbnail_pic options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    
                    
                    if (!error && image && finished) {
                        
                        [obj.retweeted_status.pic_urls enumerateObjectsUsingBlock:^(SINDictURL * _Nonnull imageDict, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            imageDict.picSize = image.size;
                            
                        }];
                        
                    }else
                    {
                        downLoadImageGroupSucceed = NO;
                    }
                    
                    dispatch_group_leave(downLoadImageGroup);
                }];
            }
            
            
            
        }];
        
        
        
        
        dispatch_group_notify(downLoadImageGroup, dispatch_get_main_queue(), ^{
            
            if (!downLoadImageGroupSucceed) {
                
                completion([NSError errorWithDomain:NSCocoaErrorDomain code:random() userInfo:@{LMJBaseResponseCustomErrorMsgKey : @"图片加载失败"}], NO);
                
                return ;
            }
            
            NSMutableArray<SINStatusViewModel *> *statusViewModels = [NSMutableArray array];
            
            [statuses enumerateObjectsUsingBlock:^(SINStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [statusViewModels addObject:[SINStatusViewModel statusModelWithStatus:obj]];
            }];
            
            
            if (isFresh) {
                
                [self.statusViewModels insertObjects:statusViewModels atIndex:0];
                
            }else
            {
                [self.statusViewModels addObjectsFromArray:statusViewModels];
            }
            
            
            completion(nil, (SNCompare(@(self.statusViewModels.count), responObj[@"total_number"])) != LMJXY);
            
        });
        
        
    }];
    
    
    
    
    
}




- (NSMutableArray<SINStatusViewModel *> *)statusViewModels
{
    if(_statusViewModels == nil)
    {
        _statusViewModels = [NSMutableArray array];
    }
    return _statusViewModels;
}

@end
