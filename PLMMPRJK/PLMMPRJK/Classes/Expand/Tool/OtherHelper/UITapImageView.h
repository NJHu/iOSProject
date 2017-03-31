//
//  UITapImageView.h
//  zxptUser
//
//  Created by wujunyang on 16/6/8.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView

- (void)addTapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;

@end
