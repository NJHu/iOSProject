//
//  LMJLineFlowLayout.h
//  自定义流水布局-22
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 NJHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMJLineFlowLayout;

@protocol LMJLineFlowLayoutDelegate <NSObject>
@optional

@end

@interface LMJLineFlowLayout : UICollectionViewFlowLayout

- (instancetype)initWithDelegate:(id<LMJLineFlowLayoutDelegate>)delegate;

+ (instancetype)lineLayoutWithDelegate:(id<LMJLineFlowLayoutDelegate>)delegate;

@end
