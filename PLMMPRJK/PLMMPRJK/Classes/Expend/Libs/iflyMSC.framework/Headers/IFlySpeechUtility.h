//
//  IFlySpeechUtility.h
//  MSCDemo
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iOS_EXCLUSIVE       //iOS平台独占API

@class IFlySpeechError;

/**
 *  引擎模式
 */
typedef NS_ENUM(NSUInteger,IFlyEngineMode){
    /**
     *  云端使用MSC，本地优先使用语音+
     */
    IFlyEngineModeAuto = 0,
    /**
     *  只使用MSC
     */
    IFlyEngineModeMsc,
    /**
     *  本地只使用语音+(受平台限制，云端无法使用语音+）
     */
    IFlyEngineModePlus,
};


/**
 *  服务类型
 */
typedef NS_ENUM(NSUInteger,IFlySpeechPlusServiceType){
    /**
     *  打开语音+主界面
     */
    IFlySpeechPlusServiceTypeNone=0,
    /**
     *  获取合成资源
     */
    IFlySpeechPlusServiceTypeTTS,
    /**
     *  获取识别资源（未开放）
     */
    IFlySpeechPlusServiceTypeISR,
    /**
     *  获取唤醒资源（未开放）
     */
    IFlySpeechPlusServiceTypeIVW,
} ;

/** 语记返回回调
 */
@protocol IFlySpeechplusDelegate <NSObject>

/**
 *  发生错误
 *
 *  @param errorCode 错误码
 */
- (void)onError:(int)errorCode;

/**
 *  服务正常结束
 */
- (void)onCompleted;

@end

/** 
 * 用户配置
 */
@interface IFlySpeechUtility : NSObject

/*!
 *  创建用户语音配置
 *      注册应用请前往语音云开发者网站。<br>
 *  网站：http://www.xfyun.cn
 *
 *  @param params 启动参数，必须保证appid参数传入，示例：appid=123456
 *
 *  @return 语音配置对象
 */
+ (IFlySpeechUtility*) createUtility:(NSString *) params;

/*!
 *  销毁用户配置对象
 *
 *  @return 成功返回YES,失败返回NO
 */
+(BOOL) destroy;

/*!
 *  获取用户配置对象
 *
 *  @return 用户配置对象
 */
+(IFlySpeechUtility *) getUtility;

/*!
 *  设置MSC引擎的状态参数
 *
 *  @param value 参数值
 *  @param key   参数名称
 *
 *  @return 成功返回YES,失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/**
 *  获取MSC引擎状态参数
 *
 *  @param key 参数名
 *
 *  @return 参数值
 */
- (NSString *)parameterForKey:(NSString *)key;

/**
 *  引擎类型
 */
@property (nonatomic, readonly) IFlyEngineMode engineMode;

/**
 *  语记协议委托
 */
@property (nonatomic, assign) id<IFlySpeechplusDelegate> delegate;

@end

/**
 *  讯飞语音+类别
 */
@interface IFlySpeechUtility (SpeechPlus)

/**
 *  检查讯飞语音+是否安装
 *
 *  @return 已安装返回YES，否则返回NO
 */
- (BOOL)checkServiceInstalled;

/**
 *  获取讯飞语音+下载地址进行下载，安装完成后即可使用服务。
 *  下载地址需要通过[[UIApplication sharedApplication] openUrl:]打开
 *
 *  @return 讯飞语音+在App Store下载地址
 */
- (NSString *)componentUrl;


/**
 *  处理语音+使用URL启动第三方应用程序时传递的数据
 *  需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 *
 *  @param url 语音+启动第三方应用程序时传递过来的URL
 *
 *  @return 成功返回YES，失败返回NO。
 */
- (BOOL)handleOpenURL:(NSURL *)url iOS_EXCLUSIVE;

/**
 *  打开讯飞语音+获取相应类型服务，0表示打开主界面
 *
 *  @param serviceType 服务类型
 *
 *  @return 成功打开返回YES，否则返回NO
 */
- (BOOL)openSpeechPlus:(IFlySpeechPlusServiceType)serviceType iOS_EXCLUSIVE;

@end








