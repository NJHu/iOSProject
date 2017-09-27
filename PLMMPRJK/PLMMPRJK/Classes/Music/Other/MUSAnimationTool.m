//
//  MUSAnimationTool.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/27.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "MUSAnimationTool.h"

@implementation MUSAnimationTool

+ (void)animate:(UIView *)view type:(MUSAnimationType)type
{
    
    if (type == MUSAnimationTypeTranslation) {
        
        [view.layer removeAnimationForKey:@"translation"];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        
        animation.values = @[@(YYScreenSize().width), @0];
        
        animation.duration = 1;
        
        [view.layer addAnimation:animation forKey:@"translation"];
        
    }else if (type == MUSAnimationTypeRotation)
    {
        [view.layer removeAnimationForKey:@"rotation"];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.x"];
        
        animation.values = @[@(-M_PI / 4), @0, @(M_PI / 4), @0];
        
        animation.duration = 1;
        
        animation.repeatCount = 2;
        
        [view.layer addAnimation:animation forKey:@"rotation"];
    }

    
    /*
     
     func animation(type: AnimationType)
     {
     
     if type == .Rotation
     {
     self.layer.removeAnimationForKey("rotation")
     
     let animation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
     animation.values = [-M_PI / 4, 0, M_PI / 4, 0]
     animation.duration = 0.5
     animation.repeatCount = 2
     self.layer.addAnimation(animation, forKey: "rotation")
     }
     
     
     if type == .Translation
     {
     self.layer.removeAnimationForKey("translation")
     
     let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
     animation.values = [UIScreen.mainScreen().bounds.width, 0]
     animation.duration = 0.2
     
     self.layer.addAnimation(animation, forKey: "translation")
     }
     
     
     }
     
     */
}

@end
