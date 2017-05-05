//
//  LMJUploadImagesService.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/4.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJBaseRequest.h"

@interface LMJUploadImagesService : LMJBaseRequest

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray;


- (void)uploadWithProgress:(void (^)(NSProgress *))progress completion:(void (^)(LMJBaseResponse *))completion;

@end
