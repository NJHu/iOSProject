//
//  MOFSAddressPickerView.h
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/31.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOFSToolView.h"
#import "AddressModel.h"

typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeAddress = 0,
    SearchTypeZipcode = 1,
    SearchTypeAddressIndex = 2,
    SearchTypeZipcodeIndex = 3,
};

@interface MOFSAddressPickerView : UIPickerView

@property (nonatomic, assign) NSInteger showTag;
@property (nonatomic, strong) MOFSToolView *toolBar;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) NSInteger numberOfSection;

- (void)showMOFSAddressPickerCommitBlock:(void(^)(NSString *address, NSString *zipcode))commitBlock cancelBlock:(void(^)(void))cancelBlock;

- (void)searchType:(SearchType)searchType key:(NSString *)key block:(void(^)(NSString *result))block;

@end
