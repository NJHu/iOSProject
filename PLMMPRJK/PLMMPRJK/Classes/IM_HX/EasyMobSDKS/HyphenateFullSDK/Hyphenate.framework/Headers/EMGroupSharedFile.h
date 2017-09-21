/*!
 *  \~chinese
 *  @header EMGroupSharedFile.h
 *  @abstract 群组共享文件
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMGroupSharedFile.h
 *  @abstract Group share file
 *  @author Hyphenate
 *  @version 3.00
 */
#import <Foundation/Foundation.h>

@interface EMGroupSharedFile : NSObject

/*!
 *  \~chinese
 *  文件的唯一标识符
 *
 *  \~english
 *  Unique identifier of File
 */
@property (nonatomic, copy, readonly) NSString *fileId;

/*!
 *  \~chinese
 *  文件名称
 *
 *  \~english
 *  Name of File
 */
@property (nonatomic, copy, readonly) NSString *fileName;

/*!
 *  \~chinese
 *  文件发布者
 *
 *  \~english
 *  Owner of File
 */
@property (nonatomic, copy, readonly) NSString *fileOwner;

/*!
 *  \~chinese
 *  文件创建时间
 *
 *  \~english
 *  Create Time of File
 */
@property (nonatomic) long long createTime;

/*!
 *  \~chinese
 *  文件大小
 *
 *  \~english
 *  Size of File
 */
@property (nonatomic) long long fileSize;

/*!
 *  \~chinese
 *  获取群共享实例
 *
 *  @param aFileId    文件ID
 *
 *  @result 群共享实例
 *
 *  \~english
 *  Get Share file instance
 *
 *  @param aFileId  file id
 *
 *  @result Share file instance
 */
+ (instancetype)sharedFileWithId:(NSString*)aFileId;

@end
