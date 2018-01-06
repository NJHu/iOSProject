//
//  TDTouchID.h
//  TDTouchID
//
//  Created by imtudou on 2016/11/19.
//  Copyright © 2016年 TuDou. All rights reserved.
//


#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  TouchID 状态
 */
typedef NS_ENUM(NSUInteger, TDTouchIDState){
    
    /**
     *  当前设备不支持TouchID
     */
    TDTouchIDStateNotSupport = 0,
    /**
     *  TouchID 验证成功
     */
    TDTouchIDStateSuccess = 1,
    
    /**
     *  TouchID 验证失败
     */
    TDTouchIDStateFail = 2,
    /**
     *  TouchID 被用户手动取消
     */
    TDTouchIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID,选择手动输入密码
     */
    TDTouchIDStateInputPassword = 4,
    /**
     *  TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    TDTouchIDStateSystemCancel = 5,
    /**
     *  TouchID 无法启动,因为用户没有设置密码
     */
    TDTouchIDStatePasswordNotSet = 6,
    /**
     *  TouchID 无法启动,因为用户没有设置TouchID
     */
    TDTouchIDStateTouchIDNotSet = 7,
    /**
     *  TouchID 无效
     */
    TDTouchIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)
     */
    TDTouchIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    TDTouchIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    TDTouchIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID (必须高于iOS 8.0才能使用)
     */
    TDTouchIDStateVersionNotSupport = 12
};



@interface TDTouchID : LAContext

typedef void (^StateBlock)(TDTouchIDState state,NSError *error);


/**
 启动TouchID进行验证

 @param desc Touch显示的描述
 @param block 回调状态的block
 */

-(void)td_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;


@end
