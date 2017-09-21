/*!
 *  \~chinese
 *  @header EMImageMessageBody.h
 *  @abstract 图片消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMImageMessageBody.h
 *  @abstract Image message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMFileMessageBody.h"

/*!
 *  \~chinese
 *  通过创建的消息体的图片
 *  -(instancetype)initWithData:displayName: 
 *  or
 *  -(instancetype)initWithData:thumbnailData:
 *  Note: 图片消息体，SDK会根据压缩率compressRatio來发送消息
 *
 *  \~english
 *  Image message body
 *  -(instancetype)initWithData:displayName:
 *  or
 *  -(instancetype)initWithData:thumbnailData:
 *  Note: SDK will compress the image based on the attribute compressRatio when delivering the image
 */
@interface EMImageMessageBody : EMFileMessageBody

/*!
 *  \~chinese
 *  图片附件的尺寸
 *
 *  \~english
 *  Resolution of the image
 */
@property (nonatomic) CGSize size;

/*!
 *  \~chinese
 *  SDK会根据压缩率compressRatio來发送消息
 *  设置发送图片消息时的压缩率。1.0表示发送原图不压缩。默认值是0.6，压缩的倍数是0.6倍。如果设置了小于等于0的值，则使用默认值
 *
 *  \~english
 *  SDK will compress the image based on the attribute compressRatio when delivering the image
 *  Image compression ratio. 1.0x is original image without compression , default value is 0.6x (60% compression). SDK uses the default value if the given value is less than zero.
 */
@property (nonatomic) CGFloat compressionRatio;

/*!
 *  \~chinese
 *  缩略图的显示名
 *
 *  \~english
 *  Display name of thumbnail
 */
@property (nonatomic, copy) NSString *thumbnailDisplayName;

/*!
 *  \~chinese
 *  缩略图的本地路径
 *  UIImage *image = [UIImage imageWithContentsOfFile:thumbnailLocalPath];
 *
 *  \~english
 *  Local path of thumbnail
 *  UIImage *image = [UIImage imageWithContentsOfFile:thumbnailLocalPath];
 */
@property (nonatomic, copy) NSString *thumbnailLocalPath;

/*!
 *  \~chinese
 *  缩略图在服务器的路径
 *
 *  \~english
 *  Server url path of thumbnail
 */
@property (nonatomic, copy) NSString *thumbnailRemotePath;

/*!
 *  \~chinese
 *  缩略图的密钥, 下载缩略图时需要密匙做校验
 *
 *  \~english
 *  Secret key for downloading thumbnail image
 */
@property (nonatomic, copy) NSString *thumbnailSecretKey;

/*!
 *  \~chinese
 *  缩略图的尺寸
 *
 *  \~english
 *  Resolution of the thumbnail
 */
@property (nonatomic) CGSize thumbnailSize;

/*!
 *  \~chinese
 *  缩略图文件的大小, 以字节为单位
 *
 *  \~english
 *  File length of a thumbnail, in bytes
 */
@property (nonatomic) long long thumbnailFileLength;

/*!
 *  \~chinese
 *  缩略图下载状态
 *
 *  \~english
 *  Download status of a thumbnail
 */
@property (nonatomic)EMDownloadStatus thumbnailDownloadStatus;

/*!
 *  \~chinese
 *  初始化图片消息体
 *  接收方的Thumbnail是服务器根据发送方的aData生成，生成大小可以在console的
 *  "Thumbnail Size" 配置，配置时有两个参数，分别是width和height，单位是px。为等比缩放，举例如下：
 *
 *  aData的分别率为 200 x 400 (1：2), 配置的width，height为 200 x 200,则生成的缩略图为 100 x 200
 *  aData的分别率为 600 x 300 (2：1), 配置的width，height为 200 x 200,则生成的缩略图为 200 x 100
 *
 *  发送方可以通过 thumbnailLocalPath 得到缩略图。
 *  接受消息时，接收方会自动根据thumbnailRemotePath下载缩略图，存储到本地，下载失败还可以通过方法
 *  downloadMessageThumbnail:progress:completion:
 *
 *  @param aData          图片数据
 *  @param aThumbnailData 缩略图数据。不会上传到服务器，只是用于本地展示使用。
 *
 *  @result 图片消息体实例
 *
 *  \~english
 *  Initialize an image message body instance
 *
 *  Image receiver will receive object thumbnail that generated based on sender's aData object.
 *  Adjust thumbnail resolution on Hyphenate conosle -> "Thumbnail Size" -> width and height. Unit in px.
 *  ex. aData resolution 200 x 400 (1：2), thumbnail resolution setting (width x height) 200 x 200, then will generate thumbnail in 100 x 200
 *  ex. aData resolution 600 x 300 (2：1), thumbnail resolution setting (width x height) 200 x 200, then will generate thumbnail in 200 x 100
 *
 *  Image sender can obtain thumbnail from thumbnailLocalPath
 *  Image receiver will get thumbnail stored under thumbnailRemotePath after a successful download automatically.
 *  However, if the automatic downloading failed, use the following method,
 *  downloadMessageThumbnail:progress:completion:
 *
 *  @param aData            original image object in NSData format
 *  @param aThumbnailData   Thumbnail in NSData format. Will not push to server, but only for local usage
 *
 *  @result An image message body instance
 */
- (instancetype)initWithData:(NSData *)aData
               thumbnailData:(NSData *)aThumbnailData;

#pragma mark - EM_DEPRECATED_IOS < 3.2.3

/*!
 *  \~chinese
 *  设置发送图片消息时的压缩率，1.0时不压缩，默认值是0.6，如果设置了小于等于0的值，则使用默认值
 *
 *  \~english
 *  Image compression ratio. 1.0 without compression, default value is 0.6. SDK uses the default value if the given value is less than zero.
 */
@property (nonatomic) CGFloat compressRatio __deprecated_msg("Use - compressionRatio");

@end
