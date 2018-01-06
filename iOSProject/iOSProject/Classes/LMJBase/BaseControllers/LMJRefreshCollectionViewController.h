//
//  LMJRefreshCollectionViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCollectionViewController.h"
#import "LMJAutoRefreshFooter.h"
#import "LMJNormalRefreshHeader.h"

@interface LMJRefreshCollectionViewController : LMJCollectionViewController

- (void)loadMore:(BOOL)isMore;

// 结束刷新, 子类请求报文完毕调用
- (void)endHeaderFooterRefreshing;

@end
