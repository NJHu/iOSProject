//
//  LMJExpandHeader.h
//
//
//

#import <Foundation/Foundation.h>
#import "LMJExpandImageView.h"

@interface LMJExpandHeader : NSObject

#pragma mark - 类方法 
/**
 *  生成一个LMJExpandHeader实例
 *
 *  @param scrollView
 *  @param expandView 可以伸展的背景View
 *
 *  @return LMJExpandHeader 对象
 */
+ (instancetype)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;


#pragma mark - 成员方法
/**
 *
 *
 *  @param scrollView
 *  @param expandView
 */
- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView;


/** 头部视图 */
@property (weak, nonatomic, readonly) UIView *headerView;

@end
