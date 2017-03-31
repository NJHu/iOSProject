///
/**
 *  @author wujunyang, 16-07-13 10:07:40
 *
 *  @brief  针对数组增加、查询、插入为空的统一处理，防止这类问题闪退的情况
 *  使用可以在AppDelegate的didFinishLaunchingWithOptions中调用下面的方法callSafeCategory;如：[SYSafeCategory callSafeCategory];
 
    就可以避免下面的闪退：
    NSMutableArray* array  =[NSMutableArray array];

    [array addObject:nil];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:nil forKey:nil];
    id item1,item2;
    [NSArray arrayWithObjects:item1,item2,nil];
 
 
 
 *  @return
 */
#import <Foundation/Foundation.h>

@interface SYSafeCategory : NSObject
+(void)callSafeCategory;
@end
