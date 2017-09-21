/*!
 *  \~chinese
 *  @header EMPageResult.h
 *  @abstract 分段结果
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMPageResult.h
 *  @abstract Subsection result
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese
 *  分段结果
 *
 *  \~english
 *  Sub-section result
 */
@interface EMPageResult : NSObject

/*!
 *  \~chinese
 *  结果列表<id>
 *
 *  \~english
 *  Result list<id>
 */
@property (nonatomic, strong) NSArray *list;

/*!
 *  \~chinese
 *  获取当前列表数目
 *
 *  \~english
 *  The count of current list
 */
@property (nonatomic) NSInteger count;

/*!
 *  \~chinese
 *  创建实例
 *
 *  @param aList    结果列表<id>
 *  @param aCount   获取当前列表数目
 *
 *  @result 分段结果的实例
 *
 *  \~english
 *  Get result instance
 *
 *  @param aList    Result list<id>
 *  @param aCount   The count of current list
 *
 *  @result An instance of cursor result
 */
+ (instancetype)pageResultWithList:(NSArray *)aList
                          andCount:(NSInteger)aCount;

@end
