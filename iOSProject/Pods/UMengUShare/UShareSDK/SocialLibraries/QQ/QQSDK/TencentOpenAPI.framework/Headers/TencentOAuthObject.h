///
/// \file TencentOAuthObject.h
/// 对开放接口的调用提供参数字典封装的辅助类
///
/// Created by Tencent on 12-12-28.
/// Copyright (c) 2012年 Tencent. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sdkdef.h"


#pragma mark -
#pragma mark TCAddTopicDic

/** 
 * \brief 发表说说的参数字典定义
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCAddTopicDic : TCAPIRequest

/** 
 * 返回一个对象用来进行API参数的填充
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCAddTopicDic *) dictionary;

/** 
 * 发布心情时引用的信息的类型。
 * \note 1表示图片； 2表示网页； 3表示视频
 */
@property (nonatomic, retain) TCOptionalStr paramRichtype;

/**
 * 发布心情时引用的信息的值。有richtype时必须有richval
 *
 * \note
 *       -# 当richtype为图片（即richtype为1，应用场景为发布心情时引用某张图片）时，\n
 *          richval需要传入该图片的相关参数。引用的图片来源分为两种：一种为网站图片，\n
 *          一种为QQ空间相册中的某张图片。
 *             - 当引用的图片来自网站，richval包含下列参数的值：\n
 *               | 参数名称 | 是否必须 | 类型    | 描述              |
 *               | ------ | ------- | ------ | ----------------- |
 *               | url    | 必须     | string | 网站图片的URL      |
 *               | height | 必须     | string | 图片高度，单位： px |
 *               | width  | 必须     | string | 图片宽度，单位： px |
 *               \n
 *               输入时每个值中间用“&”分隔，如下所示：\n
 *               “url=http://qq.com/logo.png&width=25&height=21”
 *
 *             - 当引用的图片来自QQ空间相册，richval包含下列参数的值。\n
 *               这些值都需要通过调用相册OpenAPI来获得。参数意义如下：\n
 *               | 参数名称   | 是否必须 | 类型    | 描述                               |
 *               | --------- | ------ | ------ | ---------------------------------- |
 *               | albumid   | 必须    | string | 图片所属空间相册的ID                  |
 *               | pictureid | 必须    | string | 图片ID                              |
 *               | sloc      | 必须    | string | 小图ID                              |
 *               | pictype   |        | string | 图片类型（JPG = 1；GIF = 2；PNG = 3） |
 *               | picheight |        | string | 图片高度，单位： px                   |
 *               | picwidth  |        | string | 图片宽度，单位： px                   |
 *               输入时每个值中间用逗号分隔，如下所示 ：\n
 *               “albumid,pictureid,sloc,pictype,picheight,picwidth”
 *       -# 当richtype为网页（即richtype为2，应用场景为针对某网页发表评论）时，\n
 *          richval需要传入该网页的URL，发表为feeds时，后台会自动将该URL转换为短URL。
 *       -# 当richtype为视频（即richtype为3，应用场景为针对某视频发表评论）时，\n
 *          richval需要传入该视频的URL，发表为feeds时，后台会对该URL进行解析，\n
 *          在feeds上显示播放器，视频源及缩略图。
 */
@property (nonatomic, retain) TCOptionalStr paramRichval;

/** 
 * 发布的心情的内容。
 */
@property (nonatomic, retain) TCRequiredStr paramCon;

/** 
 * 地址文。例如：广东省深圳市南山区高新科技园腾讯大厦。lbs_nm，lbs_x，lbs_y通常一起使用，来明确标识一个地址。
 */
@property (nonatomic, retain) TCOptionalStr paramLbs_nm;

/** 
 * 经度。-180.0到+180.0，+表示东经。lbs_nm，lbs_x，lbs_y通常一起使用，来明确标识一个地址。
 */
@property (nonatomic, retain) TCOptionalStr paramLbs_x;

/** 
 * 纬度。-90.0到+90.0，+表示北纬。lbs_nm，lbs_x，lbs_y通常一起使用，来明确标识一个地址。
 */
@property (nonatomic, retain) TCOptionalStr paramLbs_y;

/** 
 * 第三方应用的平台类型。
 * \note 1表示QQ空间； 2表示腾讯朋友； 3表示腾讯微博平台； 4表示腾讯Q+平台。
 */
@property (nonatomic, retain) TCOptionalStr paramThirdSource;
@end


#pragma mark -
#pragma mark TCAddOneBlogDic
/**
 * \brief 发表日志的参数字典定义
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCAddOneBlogDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCAddOneBlogDic *) dictionary;

/** 
 * 日志标题（纯文本，最大长度128个字节，utf-8编码）。
 */
@property (nonatomic, retain) TCRequiredStr paramTitle;

/** 
 * content 文章内容（html数据，最大长度100*1024个字节，utf-8编码）
 */
@property (nonatomic, retain) TCRequiredStr paramContent;
@end

#pragma mark -
#pragma mark TCAddAlbumDic
/** 
 * \brief 创建空间相册的参数字典定义
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCAddAlbumDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 *
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCAddAlbumDic *) dictionary;

/** 
 * albumname 必须 string 相册名 不能超过30个字符。
 */
@property (nonatomic, retain) TCRequiredStr paramAlbumname;


/**
 * albumdesc string 相册描述，不能超过200个字符。
 */
@property (nonatomic, retain) TCOptionalStr paramAlbumdesc;

/** 
 * priv string	相册权限
 *
 * \note 其取值含义为： 1=公开；3=只主人可见； 4=QQ好友可见； 5=问答加密。\n
 *       不传则相册默认为公开权限。\n
 *       如果priv取值为5，即相册是问答加密的，则必须包含问题和答案两个参数：\n
 *       - question: 问题，不能超过30个字符。
 *       - answer: 答案，不能超过30个字符。
 */
@property (nonatomic, retain) TCOptionalStr paramPriv;

/**
 * question 问题，不能超过30个字符。
 * \note 如果priv取值为5，必须包含这个参数：
 **/
@property (nonatomic, retain) TCOptionalStr paramQuestion;

/**
 * answer 答案，不能超过30个字符。
 * \note 如果priv取值为5，必须包含这个参数：
 **/
@property (nonatomic, retain) TCOptionalStr paramAnswer;

@end

#pragma mark -
#pragma mark TCUploadPicDic
/**
 * \brief 上传一张照片到QQ空间相册的参数字典定义
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCUploadPicDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCUploadPicDic *) dictionary;

/** 
 * photodesc string 照片描述，注意照片描述不能超过200个字符。
 */
@property (nonatomic, retain) TCOptionalStr paramPhotodesc;
/**	
 * string 照片的命名，必须以.jpg, .gif, .png, .jpeg, .bmp此类后缀结尾。
 */
@property (nonatomic, retain) TCOptionalStr paramTitle;

/**	
 * string 相册id。可不填，不填时则根据“mobile”标识选择默认上传的相册。
 */
@property (nonatomic, retain) TCOptionalStr paramAlbumid;

/** 
 * 标志位
 *
 * \note 0表示PC，1表示手机。用于当不传相册id时（即albumid为空时）控制是否传到手机相册。\n
 *       -# 如果传1，则当albumid为空时，图片会上传到手机相册；
 *       -# 如果不传或传0，则当albumid为空时，图片会上传到贴图相册；
 */
@property (nonatomic, assign) TCOptionalStr paramMobile;

/** 
 * x string 照片拍摄时的地理位置的经度。请使用原始数据（纯经纬度，0-360）。
 */
@property (nonatomic, retain) TCOptionalStr paramX;

/** 
 * y string 照片拍摄时的地理位置的纬度。请使用原始数据（纯经纬度，0-360）。
 */
@property (nonatomic, retain) TCOptionalStr paramY;

/**
 * picture 必须 string 上传照片的文件名以及图片的内容（在发送请求时，图片内容以二进制数据流的形式发送，见下面的请求示例），注意照片名称不能超过30个字符。
 */
@property (nonatomic, retain) TCRequiredImage paramPicture;

/** 
 * needfeed int	 标识上传照片时是否要发feed
 * \note（0：不发feed； 1：发feed）。如果不填则默认为发feed。
 */
@property (nonatomic, assign)TCOptionalStr paramNeedfeed;

/** 
 * successnum int 批量上传照片时，已成功上传的张数，指明上传完成情况。
 * \note 单张上传时可以不填，不填则默认为0。
 */
@property (nonatomic, assign)TCOptionalStr paramSuccessnum;

/** 
 * picnum int 批量上传照片的总张数，如果不填则默认为1。
 * \note
 *       - 如果picnum=1，为单张上传，发送单张上传feed；
 *       - 如果picnum>1，为批量上传，发送批量上传feed。
 *       批量上传方式：picnum为一次上传照片的张数，successnum初始值为0，每调用一次照片上传接口后递增其值。
 *       信息中心中的feed表现形式：批量上传时最新的7张在feed中展示。其中最新上传的一张图片展示为大图，剩下的
 *       六张按从新到旧的顺序展示为小图，其他图片不在feed中展示。
 */
@property (nonatomic, assign)TCOptionalStr paramPicnum;

@end

#pragma mark -
#pragma mark TCAddShareDic
/**
 * \brief 同步分享到QQ空间,腾讯微博的参数字典定义
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCAddShareDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 *
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCAddShareDic *) dictionary;

/** 
 * title 必须 string	 feeds的标题 最长36个中文字，超出部分会被截断。
 */
@property (nonatomic, retain) TCRequiredStr paramTitle;


/**
 * url 必须 string 分享所在网页资源的链接，点击后跳转至第三方网页，对应上文接口说明中2的超链接。请以http://开头。
 */
@property (nonatomic, retain) TCRequiredStr paramUrl;


/**
 * comment string 用户评论内容，也叫发表分享时的分享理由 禁止使用系统生产的语句进行代替。
 * 最长40个中文字，超出部分会被截断。
 */
@property (nonatomic, retain) TCOptionalStr paramComment;


/** 
 * summary string 所分享的网页资源的摘要内容，或者是网页的概要描述 最长80个中文字，超出部分会被截断。
 */
@property (nonatomic, retain) TCOptionalStr paramSummary;

/** 
 * images string 所分享的网页资源的代表性图片链接"，请以http://开头，长度限制255字符。多张图片以竖线（|）分隔，目前只有第一张图片有效，图片规格100*100为佳。
 */
@property (nonatomic, retain) TCOptionalStr paramImages;

/** 
 * type string 分享内容的类型。
 *
 * \note 4表示网页；5表示视频（type=5时，必须传入playurl）
 */
@property (nonatomic, retain) TCOptionalStr paramType;

/** 
 * playurl string 长度限制为256字节。仅在type=5的时候有效，表示视频的swf播放地址。
 */
@property (nonatomic, retain) TCOptionalStr paramPlayurl;

/** 
 * site 必须 string 分享的来源网站名称，请填写网站申请接入时注册的网站名称
 */
@property (nonatomic, retain) TCRequiredStr paramSite;

/** 
 * fromurl 必须 string 分享的来源网站对应的网站地址url 请以http://开头。
 */
@property (nonatomic, retain) TCRequiredStr paramFromurl;

/**
 * nswb string	值为1时，表示分享不默认同步到微博，其他值或者不传此参数表示默认同步到微博。
 */
@property (nonatomic, retain) TCOptionalStr paramNswb;

@end

#pragma mark -
#pragma mark TCCheckPageFansDic
/**
 * \brief 验证是否认证空间粉丝tttyttyyyu的参数字典定义
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCCheckPageFansDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 *
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCCheckPageFansDic *) dictionary;

/** 
 * 表示认证空间的QQ号码
 */
@property (nonatomic, retain) TCRequiredStr paramPage_id;
@end

#pragma mark -
#pragma mark TCSetUserHeadpic
/**
 * \brief 设置用户头像
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCSetUserHeadpic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCSetUserHeadpic *) dictionary;

/** 
 * 设置用户头像的图片
 */
@property (nonatomic, retain) TCRequiredImage paramImage;

/** 
 * 图片的文件名
 */
@property (nonatomic, retain) TCOptionalStr paramFileName;
@end

#pragma mark -
#pragma mark TCListPhotoDic

/**
 * \brief 获取用户QQ空间相册中的照片列表
 *
 * 可以直接填写相应参数后将对象当作参数传入API中
 */
@interface TCListPhotoDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 *
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCListPhotoDic *) dictionary;

/**
 * 表示要获取的照片列表所在的相册ID
 */
@property (nonatomic, retain) TCRequiredStr paramAlbumid;

@end

#pragma mark -
#pragma mark TCSendStoryDic
/**
 * \brief QQ空间定向分享的参数字典定义
 *
 * 该分享支持@到指定好友，最多支持10个好友。
 * 其中第三方应用可预传最多5个指定好友的openid，其余好友由用户自行选择。
 * 该分享形式仅提供跳QZone分享和本地Html5分享两种形式。
 * sendStroy不支持userData参数
 */
@interface TCSendStoryDic : TCAPIRequest

/**
 * 返回一个对象用来进行API参数的填充
 *
 * \note 不用释放，返回的对象是自动释放的
 */
+ (TCSendStoryDic *) dictionary;

/**
 * 分享的标题
 */
@property (nonatomic, retain) TCRequiredStr paramTitle;

/**
 * 故事摘要，最多不超过50个汉字，可以为空
 */
@property (nonatomic, retain) TCOptionalStr paramSummary;

/**
 * 默认展示在输入框里的分享理由，最多120个汉字，可以为空
 */
@property (nonatomic, retain) TCOptionalStr paramDescription;

/**
 * 图片url
 */
@property (nonatomic, retain) TCOptionalStr paramPics;

/**
 * 如果不填，则默认为"进入应用"
 */
@property (nonatomic, retain) TCRequiredStr paramAct;

/**
 * 点击分享的Url
 */
@property (nonatomic, retain) TCOptionalStr paramShareUrl;

@end
