//
//  SINPublishToolBar.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/15.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SINPublishToolBar.h"

@implementation SINPublishToolBar

- (IBAction)addPics:(UIBarButtonItem *)sender {
    
    !self.selectInput ?: self.selectInput(SINPublishToolBarClickTypePics);
}

- (IBAction)addEmos:(UIBarButtonItem *)sender {
    
    !self.selectInput ?: self.selectInput(SINPublishToolBarClickTypeEmos);
    
}
- (IBAction)editWords:(UIBarButtonItem *)sender {
    !self.selectInput ?: self.selectInput(SINPublishToolBarClickTypeKeyboard);
}


+ (instancetype)publishToolBar
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end
