//
//  SINStatusViewModel.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SINStatus.h"


typedef struct SINStatusPicsViewModel {
    
    CGSize picsViewSize;
    NSInteger cols;
    NSInteger lines;
    CGFloat itemWidth;
    CGFloat itemHeight;
    
} SINStatusPicsViewModel;

//快速创建结构体
static inline SINStatusPicsViewModel

SINStatusPicsViewModelMake(CGSize picsViewSize, NSInteger cols, NSInteger lines, CGFloat itemWidth, CGFloat itemHeight)
                      {
                          SINStatusPicsViewModel statusPicsViewModel;
                          statusPicsViewModel.picsViewSize = picsViewSize;
                          statusPicsViewModel.cols = cols;
                          statusPicsViewModel.lines = lines;
                          statusPicsViewModel.itemWidth = itemWidth;
                          statusPicsViewModel.itemHeight = itemHeight;
                          
                          return statusPicsViewModel;
                      }
                      

@interface SINStatusViewModel : NSObject


/** <#digest#> */
@property (nonatomic, assign) CGFloat cellHeight;


/** <#digest#> */
@property (nonatomic, assign) CGFloat postTextHeight;


/** <#digest#> */
@property (nonatomic, strong) UIImage *sin_verified_typeImage;

/** <#digest#> */
@property (nonatomic, strong) UIImage *sin_mbrankImage;

/** <#digest#> */
@property (nonatomic, strong) NSMutableAttributedString *sin_textPost;


@property (nonatomic, copy) NSString *sin_source;

/** <#digest#> */
@property (nonatomic, copy) NSString *sin_creatTime;

/** <#digest#> */
@property (nonatomic, copy) NSString *sin_cmtCount;

/** <#digest#> */
@property (nonatomic, copy) NSString *sin_dingCount;

/** <#digest#> */
@property (nonatomic, copy) NSString *sin_repostCount;

/** <#digest#> */
@property (nonatomic, assign) SINStatusPicsViewModel sin_statusPicsViewModel;

/** <#digest#> */
@property (nonatomic, strong) SINStatusViewModel *sin_retweetStatusViewModel;

/** <#digest#> */
@property (nonatomic, strong) SINStatus *status;

+ (instancetype)statusModelWithStatus:(SINStatus *)status;

@end
