/*!
 *  \~chinese
 *  @header EMFileMessageBody.h
 *  @abstract 文件消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMFileMessageBody.h
 *  @abstract File message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*!
 *  \~chinese
 *  附件下载状态
 *
 *  \~english
 *  File downloading status
 */
typedef enum {
    EMDownloadStatusDownloading   = 0,  /*! \~chinese 正在下载 \~english Downloading */
    EMDownloadStatusSucceed,            /*! \~chinese 下载成功 \~english Succeed */
    EMDownloadStatusFailed,             /*! \~chinese 下载失败 \~english Failed */
    EMDownloadStatusPending,            /*! \~chinese 准备下载 \~english Pending */
    EMDownloadStatusSuccessed=EMDownloadStatusSucceed,   /*! \~chinese 旧版 \~english legacy */
} EMDownloadStatus;

/*!
 *  \~chinese
 *  文件消息体
 *
 *  \~english
 *  File message body
 */
@interface EMFileMessageBody : EMMessageBody

/*!
 *  \~chinese
 *  附件的显示名
 *
 *  \~english
 *  Display name of attachment
 */
@property (nonatomic, copy) NSString *displayName;

/*!
 *  \~chinese
 *  附件的本地路径
 *
 *  \~english
 *  Local path of attachment
 */
@property (nonatomic, copy) NSString *localPath;

/*!
 *  \~chinese
 *  附件在服务器上的路径
 *
 *  \~english
 *  Server path of attachment
 */
@property (nonatomic, copy) NSString *remotePath;

/*!
 *  \~chinese
 *  附件的密钥, 下载附件时需要密匙做校验
 *
 *  \~english
 *  Secret key for downloading the message attachment
 */
@property (nonatomic, copy) NSString *secretKey;

/*!
 *  \~chinese
 *  附件的大小, 以字节为单位
 *
 *  \~english
 *  Length of attachment, in bytes
 */
@property (nonatomic) long long fileLength;

/*!
 *  \~chinese
 *  附件的下载状态
 *
 *  \~english
 *  Downloading status of attachment
 */
@property (nonatomic) EMDownloadStatus downloadStatus;

/*!
 *  \~chinese
 *  初始化文件消息体
 *
 *  @param aLocalPath   附件本地路径
 *  @param aDisplayName 附件显示名（不包含路径）
 *
 *  @result 消息体实例
 *
 *  \~english
 *   Initialize a file message body instance
 *
 *  @param aLocalPath   Local path of the attachment
 *  @param aDisplayName Display name of the attachment
 *
 *  @result File message body instance
 */
- (instancetype)initWithLocalPath:(NSString *)aLocalPath
                      displayName:(NSString *)aDisplayName;

/*!
 *  \~chinese
 *  初始化文件消息体
 *
 *  @param aData        附件数据
 *  @param aDisplayName 附件显示名（不包含路径）
 *
 *  @result 消息体实例
 *
 *  \~english
 *  Initialize a file message body instance
 *
 *  @param aData        The data of attachment file
 *  @param aDisplayName Display name of the attachment
 *
 *  @result File message body instance
 */
- (instancetype)initWithData:(NSData *)aData
                 displayName:(NSString *)aDisplayName;


@end
