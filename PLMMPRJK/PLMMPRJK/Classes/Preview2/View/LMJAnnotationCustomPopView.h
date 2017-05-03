//
//  LMJAnnotationCustomPopView.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/3.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMJAnnotationCustomPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoButton;

+ (instancetype)popView;

@end
