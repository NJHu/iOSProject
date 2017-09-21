/*!
 *  \~chinese 
 *  @header     EMCursorResult.h
 *  @abstract   分段结果
 *  @author     Hyphenate
 *  @version    3.00
 *
 *  \~english
 *  @header     EMCursorResult.h
 *  @abstract   Subsection result
 *  @author     Hyphenate
 *  @version    3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  分段结果
 *
 *  \~english
 *  Sub-section result
 */
@interface EMCursorResult : NSObject

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
 *  获取下一段结果的游标
 *
 *  \~english
 *  The cursor of next section
 */
@property (nonatomic, copy) NSString *cursor;

/*!
 *  \~chinese
 *  创建实例
 *
 *  @param aList    结果列表<id>
 *  @param aCusror  获取下一段结果的游标
 *
 *  @result 分段结果的实例
 *
 *  \~english
 *  Get result instance
 *
 *  @param aList    Result list<id>
 *  @param aCusror  The cursor of next section
 *
 *  @result An instance of cursor result
 */
+ (instancetype)cursorResultWithList:(NSArray *)aList
                           andCursor:(NSString *)aCusror;

@end
