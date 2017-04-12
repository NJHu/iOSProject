//
//  CFPExpandHeader.h
//
//
//

#import <Foundation/Foundation.h>
#import "CFPExpandImageView.h"

@interface CFPExpandHeader : NSObject <UIScrollViewDelegate>

#pragma mark - 类方法 
/**
 *  生成一个CFPExpandHeader实例
 *
 *  @param scrollView
 *  @param expandView 可以伸展的背景View
 *
 *  @return CFPExpandHeader 对象
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

/**
 *  监听scrollViewDidScroll方法
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

/** 头部视图 */
@property (weak, nonatomic, readonly) UIView *headerView;

@end
