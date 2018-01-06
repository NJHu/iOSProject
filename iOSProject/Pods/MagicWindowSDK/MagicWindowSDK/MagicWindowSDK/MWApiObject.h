//
//  MWApiObject.h
//  Created by 刘家飞 on 15/8/27.
//  Copyright (c) 2015年 MagicWindow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum
{
    MWUnknow = 0,           //未知
    MWMale= 1,              //男
    MWFemale = 2            //女
}MWGenderType;

//用户信息
@interface MWUserProfile : NSObject

@property (nonatomic, strong) NSString *mwUserId;       //用户唯一标识
@property (nonatomic, strong) NSString *mwPhone;        //手机号
@property (nonatomic, strong) NSString *mwEmail;        //邮箱
@property (nonatomic, strong) NSString *mwUserName;     //用户名
@property (nonatomic, assign) MWGenderType mwGender;    //性别
@property (nonatomic, strong) NSString *mwBirthday;     //生日
@property (nonatomic, strong) NSString *mwCountry;      //国家
@property (nonatomic, strong) NSString *mwProvince;     //省份
@property (nonatomic, strong) NSString *mwCity;         //城市
@property (nonatomic, retain) NSString *mwUserRank;     //用户等级
@property (nonatomic, strong) NSString *mwRemark;       //备注

@end


//webview导航条左边自定义按钮
@interface MWBarLeftButton : UIButton

@property (nonatomic, assign) CGRect mwframe UI_APPEARANCE_SELECTOR;                //set frame
@property (nonatomic, strong) NSString *title UI_APPEARANCE_SELECTOR;               //set button title
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;             //set button title font
@property (nonatomic, strong) UIColor *titleColorNormal UI_APPEARANCE_SELECTOR;     //set title color for UIControlStateNormal
@property (nonatomic, strong) UIColor *titleColorHighlighted UI_APPEARANCE_SELECTOR;//set title color for UIControlStateHighlighted
@property (nonatomic, strong) UIImage *imageNormal UI_APPEARANCE_SELECTOR;          //set image for UIControlStateNormal
@property (nonatomic, strong) UIImage *imageHighlighted UI_APPEARANCE_SELECTOR;     //set image for UIControlStateHighlighted
@property (nonatomic, strong) UIImage *backgroundImageNormal UI_APPEARANCE_SELECTOR;//set background image for UIControlStateNormal
@property (nonatomic, strong) UIImage *backgroundImageHighlighted UI_APPEARANCE_SELECTOR;//set background image for UIControlStateHighlighted
@property (nonatomic, strong) UIColor *mwTintColor UI_APPEARANCE_SELECTOR;          //set tint color
@property (nonatomic, assign) UIEdgeInsets mwTitleEdgeInsets UI_APPEARANCE_SELECTOR;//set title edgeInsets
@property (nonatomic, assign) UIEdgeInsets mwImageEdgeInsets UI_APPEARANCE_SELECTOR;//set image edgeInsets

@end


//webview导航条右边自定义按钮
@interface MWBarRightButton : UIButton

@property (nonatomic, assign) CGRect mwframe UI_APPEARANCE_SELECTOR;                //set frame
@property (nonatomic, strong) NSString *title UI_APPEARANCE_SELECTOR;               //set button title
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;             //set button title font
@property (nonatomic, strong) UIColor *titleColorNormal UI_APPEARANCE_SELECTOR;     //set title color for UIControlStateNormal
@property (nonatomic, strong) UIColor *titleColorHighlighted UI_APPEARANCE_SELECTOR;//set title color for UIControlStateHighlighted
@property (nonatomic, strong) UIImage *imageNormal UI_APPEARANCE_SELECTOR;          //set image for UIControlStateNormal
@property (nonatomic, strong) UIImage *imageHighlighted UI_APPEARANCE_SELECTOR;     //set image for UIControlStateHighlighted
@property (nonatomic, strong) UIImage *backgroundImageNormal UI_APPEARANCE_SELECTOR;//set background image for UIControlStateNormal
@property (nonatomic, strong) UIImage *backgroundImageHighlighted UI_APPEARANCE_SELECTOR;//set background image for UIControlStateHighlighted
@property (nonatomic, strong) UIColor *mwTintColor UI_APPEARANCE_SELECTOR;          //set tint color
@property (nonatomic, assign) UIEdgeInsets mwTitleEdgeInsets UI_APPEARANCE_SELECTOR;//set title edgeInsets
@property (nonatomic, assign) UIEdgeInsets mwImageEdgeInsets UI_APPEARANCE_SELECTOR;//set image edgeInsets


@end

//webview导航条自定义标题样式
@interface MWBarTitle : UILabel

@property (nonatomic, strong) UIColor *mwTitleColor UI_APPEARANCE_SELECTOR;           //set title color
@property (nonatomic, strong) UIFont *mwTitleFont UI_APPEARANCE_SELECTOR;             //set title font
@property (nonatomic, assign) NSTextAlignment mwTextAlignment UI_APPEARANCE_SELECTOR;//set title alignment

@end

