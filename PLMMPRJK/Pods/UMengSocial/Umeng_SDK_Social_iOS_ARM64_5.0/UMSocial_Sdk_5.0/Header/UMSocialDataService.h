//
//  UMSocialDataAPI.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-13.
//  Copyright (c) umeng.com All rights reserved.
//
#import <Foundation/Foundation.h>
#import "UMSocialData.h"

/**
 网络请求结果状态码
 
 */
typedef enum {
    UMSResponseCodeSuccess            = 200,        //成功
    UMSREsponseCodeTokenInvalid       = 400,        //授权用户token错误
    UMSResponseCodeBaned              = 505,        //用户被封禁
    UMSResponseCodeFaild              = 510,        //发送失败（由于内容不符合要求或者其他原因）
    UMSResponseCodeArgumentsError     = 522,        //参数错误,提供的参数不符合要求
    UMSResponseCodeEmptyContent       = 5007,       //发送内容为空
    UMSResponseCodeShareRepeated      = 5016,       //分享内容重复
    UMSResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到用户uid
    UMSResponseCodeAccessTokenExpired = 5027,       //token过期
    UMSResponseCodeNetworkError       = 5050,       //网络错误
    UMSResponseCodeGetProfileFailed   = 5051,       //获取账户失败
    UMSResponseCodeCancel             = 5052,        //用户取消授权
    UMSResponseCodeNotLogin           = 5053,       //用户没有登录
    UMSResponseCodeNoApiAuthority     = 100031      //QQ空间应用没有在QQ互联平台上申请上传图片到相册的权限
} UMSResponseCode;

/**
 网络请求类型
 
 */
typedef enum {
	UMSResponseAddComment             = 0,          //添加评论
    UMSResponseAddLike                = 1,          //添加喜欢
    UMSResponseGetCommentList         = 2,          //获取评论列表
    UMSResponseGetSocialData          = 3,          //获取social enitity信息
    UMSResponseShareToSNS             = 4,          //分享到一个微博平台
    UMSResponseShareToMutilSNS        = 5,          //分享到多个微博平台
    UMSResponseBinding                = 6,          //绑定一个账户作为登录账户
    UMSResponseUnBinding              = 7,          //解除绑定账户
    UMSResponseUnOauth                = 8,          //解除授权
    UMSResponseOauth                  = 9,          //授权
    UMSResponseGetAccount             = 10,         //获取账户信息
    UMSResponseGetSnsInfo             = 11,         //获取sns详细信息
    UMSResponseGetFriends             = 12,         //获取朋友列表
    UMSResponseAddFollow              = 13,         //添加关注
    UMSResponseAddCustomAccount       = 14,         //添加自定义账户
    UMSResponseAddSnsAccount          = 15,         //添加已经授权的账户
    UMSResponseGetAppInfo             = 16,         //获取各个sns绑定app 信息
    UMSResponseIsTokenValid           = 17,         //获取各个微博平台的token是否有效
    UMSResponseAnalytics              = 18,
    UMSResponseAddAppInfo             = 19
} UMSResponse;

/**
 页面类型
 
 */
typedef enum{
    UMSViewControllerCommentList,        //评论列表
    UMSViewControllerCommentEdit,        //评论编辑页
    UMSViewControllerShareList,          //分享列表页，包含sdk支持的所有sns平台
    UMSViewControllerShareEdit,          //分享编辑页
    UMSViewControllerAccount,            //个人中心页面
    UMSViewControllerSnsAccount,         //sns账号设置页面
    UMSViewControllerLoginAccount,       //登录账号页面
    UMSViewControllerOauth,              //oath授权页面
    UMSViewControllerLogin,              //登录页面，登录的可选平台为sdk所支持的sns平台
    UMSViewControllerFriendList,         //好友列表页面
    UMSViewControllerActionSheet         //icon平铺排列的分享列表页面
}UMSViewControllerType;


/**
 返回的状态对象，可以通过此对象获取返回类型、返回结果、返回数据等。
 
 */
@interface UMSocialResponseEntity : NSObject

/**
 代表发送结果，UMSResponseCodeSuccess代表成功，参看上面的定义
 
 */
@property (nonatomic, assign) UMSResponseCode responseCode;

/**
 数据类型
 
 */
@property (nonatomic, assign) UMSResponse responseType;

/**
 数据返回`UMViewControllerType`类型,如果是UI的回调函数，表示回调函数所在的页面

 */
@property (nonatomic, assign) UMSViewControllerType viewControllerType;

/**
 错误原因
 
 */
@property (nonatomic, retain) NSString *message;

/**
 返回数据
 
 */
@property (nonatomic, retain) NSDictionary *data;

/**
 客户端发送出现的错误
 
 */
@property (nonatomic, retain) NSError *error;

/**
 把各属性编码成NSString
 
 @return 一个`NSString`对象
 */
-(NSString *)description;
@end


/**
 进行网络请求之后的回调函数，你可以通过返回的`UMSocialResponseEntity`对象的`responseType`类型来对不同的请求来做处理。
 
 @see `UMSocialResponseEntity.h`
 
 */
@protocol UMSocialDataDelegate <NSObject>

/**
 进行网络请求之后得到的回调方法
 
 @param response 回调返回一个`UMSResponseEntity`对象
 
 */
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;

@end

typedef void (^UMSocialDataServiceCompletion)(UMSocialResponseEntity * response);

@class CLLocation;

/**
 底层数据接口对象，用一个`UMSocialData`来初始化，此对象的方法有在直接发送微博、发送评论等。可以通过`socialData`属性来获取分享数、评论数，设置分享内嵌文字等。
 */
@interface UMSocialDataService : NSObject

///---------------------------------------
/// @name 属性
///---------------------------------------

@property (nonatomic, copy) UMSocialDataServiceCompletion completion;

/**
 通过`UMSocialData`对象，可以设置分享文字、图片，并获取到分享数、微博账号等属性
 */
@property (nonatomic, retain) UMSocialData *socialData;

/**
 设置实现了`<UMSocialDataDelegate>`的对象
 */
@property (nonatomic, readonly) id <UMSocialDataDelegate> socialDataDelegate;

///---------------------------------------
/// @name 对象初始化和设置方法
///---------------------------------------


/**
 返回一个以[UMSocialData defaultData]来做初始化参数的`UMSocialDataService`对象
 
 @return `UMSocialDataService`的默认初始化对象
 */
+(UMSocialDataService *)defaultDataService;

/**
 初始化一个`UMSocialDataService`对象
 
 @param socialData 一个`UMSocialData`对象
 
 @return 初始化对象
 */
- (id)initWithUMSocialData:(UMSocialData *)socialData;

/*!
 设置实现了`<UMSocialDataDelegate>`的对象， 如果在此视图设置了delegate，离开此视图的时候要设置为nil
 
 @param delegate 实现了`<UMSocialDataDelegate>`的对象
 
 */
- (void)setUMSocialDelegate:(id <UMSocialDataDelegate>)delegate;

/**
 获取微博分享数、评论数等数据

 @param completion   获取到数据之后执行的block对象，返回数据放在completion.data
 
 */
-(void)requestSocialDataWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 Deprecated APIs
 发送微博内容到多个微博平台
 
 @param platformTypes       分享到的平台，数组的元素是`UMSocialSnsPlatformManager.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
 @param content             分享的文字内容
 @param image               分享的图片
 @param location            分享的地理位置信息
 @param urlResource         图片、音乐、视频等url资源
 @param completion          发送完成执行的block对象
 
 */
- (void)postSNSWithTypes:(NSArray *)platformTypes
                 content:(NSString *)content
                   image:(id)image
                location:(CLLocation *)location
             urlResource:(UMSocialUrlResource *)urlResource
              completion:(UMSocialDataServiceCompletion)completion;

/**
    发送微博内容到多个微博平台

    @param platformTypes    分享到的平台，数组的元素是`UMSocialSnsPlatformManager.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
    @param content          分享的文字内容
    @param image            分享的图片,可以传入UIImage类型或者NSData类型
    @param location         分享的地理位置信息
    @param urlResource      图片、音乐、视频等url资源
    @param completion       发送完成执行的block对象
    @param presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
 
 */
- (void)postSNSWithTypes:(NSArray *)platformTypes
                 content:(NSString *)content
                   image:(id)image
                location:(CLLocation *)location
             urlResource:(UMSocialUrlResource *)urlResource
     presentedController:(UIViewController *)presentedController
              completion:(UMSocialDataServiceCompletion)completion;

/**
 如果当前`UMSocialData`没有喜欢的话，发送喜欢，否则取消喜欢
 
 @param completion 获取到数据之后执行的block对象
 
 */
- (void)postAddLikeOrCancelWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 发送评论
 
 @param content 评论的文字内容
 @param completion 获取到数据之后执行的block对象
 
 */
- (void)postCommentWithContent:(NSString *)content completion:(UMSocialDataServiceCompletion)completion;

/**
 发送评论
 
 @param content 评论的文字内容
 @param image 评论并发送到微博的图片
 @param templateText 评论并发送到微博跟在微博正文后面用//分隔的文字
 @param location 评论的地理位置信息
 @param shareToSNS 评论并分享到微博平台，key为微博名，定义在`UMSocialSnsPlatformManager.h`中的`UMShareToSina`等，值为相应的usid
 @param completion 获取到数据之后执行的block对象
 
 */
-(void)postCommentWithContent:(NSString *)content
                        image:(UIImage *)image
                 templateText:(NSString *)templateText
                     location:(CLLocation *)location
           shareToSNSWithUsid:(NSDictionary *)shareToSNS
                   completion:(UMSocialDataServiceCompletion)completion;

/**
 获取评论
 
 @param lastCommentTime 如果要获取最新的评论数，设置为-1，如果获取指定评论，传入评论在这之前的时间戳
 @param completion 获取到数据之后执行的block对象，此block对象的形参内带有请求的评论数据
 
 */
- (void)requestCommentList:(long long)lastCommentTime completion:(UMSocialDataServiceCompletion)completion;

///---------------------------------------
/// @name 用户账户信息相关网络请求
///---------------------------------------

/**
 请求获取用户微博账号的数据，获取到的用户数据在回调函数获得，也可以通过已经保存在本地并且更新的`socialData`属性的`socialAccount`属性来获得
 @param completion 获取到数据之后执行的block对象，此block对象的形参带啊有请求的用户账号数据
 
 */
- (void)requestSocialAccountWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 请求解除授权
 
 @param platformType 要解除授权的微博平台
 @param completion 请求之后执行的block对象
 
 */
- (void)requestUnOauthWithType:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求绑定账号
 
 @param platformType 要绑定账号的微博平台
 @param completion 请求之后执行的block对象
 
 */
- (void)requestBindToSnsWithType:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求解除绑定账号
 @param completion 请求之后执行的block对象
 
 */
- (void)requestUnBindToSnsWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 请求获取用户微博账号的详细数据,获取返回数据和其他方法一样，在<UMSocialDataDelegate>中的`didFinishGetUMSocialDataResponse`返回的`UMSocialResponseEntity`对象，数据部分是`data`属性，为`NSDictionary`类型
 
 @param platformType 要获取微博信息的微博平台
 @param completion 请求之后执行的block对象
 
 */
- (void)requestSnsInformation:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求获取用户微博账号的朋友列表,获取返回数据和其他方法一样，在<UMSocialDataDelegate>中的`didFinishGetUMSocialDataResponse`返回的`UMSocialResponseEntity`对象，数据部分是`data`属性，为`NSDictionary`类型
 
 @param platformType 要获取微博信息的微博平台
 @param completion 请求之后执行的block对象,block对象的形参内带有请求的好友数据
 
 */
- (void)requestSnsFriends:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求添加关注
 
 @param platformType 要添加关注的微博平台，目前添加关注功能只支持新浪微博和腾讯微博
 
 @param usids 被关注的usid号
 
 @param completion 请求之后执行的block对象
 
 */
- (void)requestAddFollow:(NSString *)platformType followedUsid:(NSArray *)usids completion:(UMSocialDataServiceCompletion)completion;

/**
 检测用户在各个开放平台上的token是否有效，失效的情况包括token过期，用户手动解除授权，用户修改密码等情况
 
 @param snsArray 微博平台数组，只支持传入支持授权的平台，包括新浪微博、腾讯微博、QQ空间等。不支持微信等平台。
 
 @return completion 返回结果
 */
- (void)requestIsTokenValid:(NSArray *)snsArray completion:(UMSocialDataServiceCompletion)completion;
@end

