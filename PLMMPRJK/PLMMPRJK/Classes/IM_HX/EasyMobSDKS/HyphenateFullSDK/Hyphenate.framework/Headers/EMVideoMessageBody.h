/*!
 *  \~chinese
 *  @header EMVideoMessageBody.h
 *  @abstract 视频消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMVideoMessageBody.h
 *  @abstract Video message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMFileMessageBody.h"

/*!
 *  \~chinese
 *  视频消息体
 *
 *  \~english
 *  Video message body
 */
@interface EMVideoMessageBody : EMFileMessageBody

/*!
 *  \~chinese
 *  视频时长, 秒为单位
 *
 *  \~english
 *  Video duration, in seconds
 */
@property (nonatomic) int duration;

/*!
 *  \~chinese
 *  缩略图的本地路径
 *
 *  \~english
 *  Local path of thumbnail
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
 *  Secret key of thumbnail, required to download a thumbnail
 */
@property (nonatomic, copy) NSString *thumbnailSecretKey;

/*!
 *  \~chinese
 *  视频缩略图的尺寸
 *
 *  \~english
 *  Size of video thumbnail
 */
@property (nonatomic) CGSize thumbnailSize;

/*!
 *  \~chinese
 *  缩略图下载状态
 *
 *  \~english
 *  Download status of thumbnail
 */
@property (nonatomic)EMDownloadStatus thumbnailDownloadStatus;

@end
