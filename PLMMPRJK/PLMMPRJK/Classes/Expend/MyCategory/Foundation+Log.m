

#import <UIKit/UIKit.h>







/**
 *  字典和数组自定义打印
 */
@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendString:@"\n{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [strM appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    
    [strM appendString:@"\t}"];
    
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    
    if(range.location != NSNotFound)
    {
        [strM deleteCharactersInRange:range];
    }
    
    return strM;
}

@end


@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendString:@"[\n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@,", obj];
    }];
    
    
    [strM appendString:@"\n]\n"];
    
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    
    if(range.location != NSNotFound)
    {
        [strM deleteCharactersInRange:range];
    }
    
    return strM;
    
}

@end