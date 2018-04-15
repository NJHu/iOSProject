//
//  MOFSDatePicker.h
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/26.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOFSToolView.h"

typedef void (^CommitBlock)(NSDate *date);
typedef void (^CancelBlock)(void);

@interface MOFSDatePicker : UIDatePicker

@property (nonatomic, strong) MOFSToolView *toolBar;
@property (nonatomic, strong) UIView *containerView;

- (void)showMOFSDatePickerViewWithTag:(NSInteger)tag firstDate:(NSDate *)date commit:(CommitBlock)commitBlock cancel:(CancelBlock)cancelBlock;

@end
