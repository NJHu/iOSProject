//
//  LMJRunTimeViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/13.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJRunTimeViewController.h"
#import "LMJRunTimeTest.h"
#import "LMJRunTimeTest+LMJMethod.h"
#import "LMJRunTimeTest+LMJWork.h"
//#import "UIAlertView+LMJBlock.h"

@interface LMJRunTimeViewController ()
/** <#digest#> */
@property (nonatomic, strong) LMJRunTimeTest *myRunTimeTest;

/** <#digest#> */
@property (nonatomic, strong) UIButton *myButton;

@end

@implementation LMJRunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LMJWeakSelf(self);
    [self setDes];
    self.myRunTimeTest=[[LMJRunTimeTest alloc] init];
    
    //HOCK 注入影响方法里面
    self.myButton = [[UIButton alloc]init];
    self.myButton.backgroundColor = [UIColor blueColor];
    self.myButton.height = 50;
    [self.myButton setTitle:@"方法替换或者交换(UIButton+LMJBlock)" forState:UIControlStateNormal];
    self.tableView.tableHeaderView = self.myButton;
    
    [self.myButton addActionHandler:^(NSInteger tag) {
        [UIAlertController mj_showAlertWithTitle:@"提示" message:@"跟按钮添加了 actoinblock" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionDefaultTitle(@"确认看 UIButto+LMJ");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        }];
    }];
    
    
    self.addItem([LMJWordItem itemWithTitle:@"获取类的信息" subTitle:@"关键字: class_get" itemOperation:^(NSIndexPath *indexPath) {
        
        //类名
        NSString *className = [NSString stringWithFormat:@"class name: %s\n", class_getName([self.myRunTimeTest class])];
        
        // 父类
        NSString *superClassName = [NSString stringWithFormat:@"super class name: %s\n", class_getName(class_getSuperclass([self.myRunTimeTest class]))];
        
        // 是否是元类
        NSString *isMetaClass = [NSString stringWithFormat:@"myRunTimeTest is %@ a meta-class\n", (class_isMetaClass([self.myRunTimeTest class]) ? @"" : @"not")];
        
        // 元类是什么
        Class meta_class = objc_getMetaClass(class_getName([self.myRunTimeTest class]));
        NSString *metaClass = [NSString stringWithFormat:@"%s's meta-class is %s\n", class_getName([LMJRunTimeTest class]), class_getName(meta_class)];
        
        // 变量实例大小
        NSString *instanceSize = [NSString stringWithFormat:@"instance size: %zu\n", class_getInstanceSize([self.myRunTimeTest class])];
        
        NSString *message = [NSString stringWithFormat:@"%@%@%@%@%@", className, superClassName, isMetaClass, metaClass, instanceSize];
        
        [weakself alertTitle:@"获取类的信息" message:message];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"获取类的对应属性" subTitle:@"class_copyPropertyList" itemOperation:^(NSIndexPath *indexPath) {
        
        NSMutableString *strM = [NSMutableString string];
        
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([self.myRunTimeTest class], &count);
        for (unsigned int i=0; i<count; i++) {
            const char *propertyName = property_getName(propertyList[i]);
            NSLog(@"属性名称为---->%@", [NSString stringWithUTF8String:propertyName]);
            [strM appendFormat:@"属性名称为---->%@\n", [NSString stringWithUTF8String:propertyName]];
            NSString *getPropertyNameString = [NSString stringWithCString:property_getAttributes(propertyList[i]) encoding:NSUTF8StringEncoding];
            NSLog(@"属性类型及修饰符为:  %@",getPropertyNameString);
            [strM appendFormat:@"属性类型及修饰符为:  %@\n",getPropertyNameString];
        }
        free(propertyList);
        [strM appendString:@"\n\n\n"];
        
        objc_property_t array = class_getProperty([self.myRunTimeTest class], "name");
        if (array != NULL) {
            NSLog(@"当前存在属性 %s", property_getName(array));
            [strM appendFormat:@"当前存在属性 %s", property_getName(array)];
        }
        
        [weakself alertTitle:@"获取类的对应属性" message:strM];
        
        //******显示内容如下******
        //属性名称为---->workName
        //属性类型及修饰符为:  T@"NSString",C,N
        //属性名称为---->name
        //属性类型及修饰符为:  T@"NSString",C,N,V_name
        // 属性名称为---->age
        // 属性类型及修饰符为:  Tq,N,V_age
        
        //******显示内容如下******
        //当前存在属性 name
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"获取类的成员变量" subTitle:@"class_copyIvarList" itemOperation:^(NSIndexPath *indexPath) {
        
        NSMutableString *strM = [NSMutableString string];
        
        unsigned int count;
        Ivar *ivarList = class_copyIvarList([self.myRunTimeTest class], &count);
        for (unsigned int i = 0; i < count; i++) {
            Ivar myIvar = ivarList[i];
            const char *ivarName = ivar_getName(myIvar);
            NSLog(@"成员变量为---->%@", [NSString stringWithUTF8String:ivarName]);
            
            [strM appendFormat:@"成员变量为---->%@\n", [NSString stringWithUTF8String:ivarName]];
        }
        
        free(ivarList);
        //******显示内容如下******
        //成员变量为---->_school_Name
        //成员变量为---->_userHeight_
        //成员变量为---->_name
        //成员变量为---->_age
        [strM appendString:@"\n\n\n"];
        
        Ivar string = class_getInstanceVariable([self.myRunTimeTest class], "_age");
        if (string != NULL) {
            NSLog(@"当前存在变量 %s", ivar_getName(string));
            [strM appendFormat:@"class_getInstanceVariable\n当前存在变量 %s\n", ivar_getName(string)];
        }
        //******显示内容如下******
        //当前存在变量 _age
        [strM appendString:@"\n\n\n"];
        
        
        //动态修改变量的值
        LMJRunTimeTest *testModel=[[LMJRunTimeTest alloc]init];
        testModel.name=@"njhu";
        
        NSLog(@"当前值没有被修改为：%@",testModel.name);
        [strM appendFormat:@"当前值没有被修改为：%@\n",testModel.name];
        unsigned int myCount = 0;
        Ivar *ivar = class_copyIvarList([testModel class], &myCount);
        for (int i = 0; i<myCount; i++) {
            Ivar var = ivar[i];
            const char *varName = ivar_getName(var);
            NSString *proname = [NSString stringWithUTF8String:varName];
            
            if ([proname isEqualToString:@"_name"]) {   //这里别忘了给属性加下划线
                object_setIvar(testModel, var, @"Good");
                break;
            }
        }
        free(ivar);
        NSLog(@"当前修改后的变量值为：%@",testModel.name);
        [strM appendFormat:@"object_setIvar\n当前修改后的变量值为：%@\n",testModel.name];
        
        //******显示内容如下******
        //可以用来动态改变一些已经存在的值，或者是统一变量处理
        //当前值没有被修改为：
        //当前修改后的变量值为：Good
        
        [weakself alertTitle:@"获取类的成员变量" message:strM];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"获取方法" subTitle:@"class_copyMethodList" itemOperation:^(NSIndexPath *indexPath) {
        
        NSMutableString *strM = [NSMutableString string];
        
        unsigned int count;
        Method *methods = class_copyMethodList([self.myRunTimeTest class], &count);
        for (int i = 0; i < count; i++) {
            Method method = methods[i];
            NSLog(@"实例方法: %@", NSStringFromSelector(method_getName(method)));
            [strM appendFormat:@"实例方法: %@\n", NSStringFromSelector(method_getName(method))];
        }
        
        free(methods);
        
 
        [strM appendFormat:@"\n\n\n"];
        //******显示内容如下******
        //  实例方法: showUserName:
        //实例方法: setWorkName:
        //实例方法: workName
        //实例方法: showUserAge:
        // 实例方法: encodeWithCoder:
        // 实例方法: initWithCoder:
        // 实例方法: setName:
        // 实例方法: name
        // 实例方法: .cxx_destruct
        // 实例方法: setAge:
        // 实例方法: age
        
        unsigned int classcount;
        Method *classmethods = class_copyMethodList(object_getClass([self.myRunTimeTest class]), &classcount);
        for (int i = 0; i < classcount; i++) {
            Method method = classmethods[i];
            NSLog(@"类方法: %@", NSStringFromSelector(method_getName(method)));
            
            [strM appendFormat:@"类方法: %@", NSStringFromSelector(method_getName(method))];
        }
        
        free(classmethods);
        
        //******显示内容如下******
        //注意主要差别是在object_getClass 如果是类方法的获取要object_getClass（Class）
        //类方法:showAddress
        [strM appendFormat:@"\n\n\n"];
        
        
        //判断类实例方法是否存在
        Method method1 = class_getInstanceMethod([self.myRunTimeTest class], @selector(showUserName:));
        if (method1 != NULL) {
            NSLog(@"类实例方法: %@", NSStringFromSelector(method_getName(method1)));
            [strM appendFormat:@"判断类实例方法是否存在\n类实例方法: %@", NSStringFromSelector(method_getName(method1))];
        }
        
        //******显示内容如下******
        //当前存在方法 showUserName:
        [strM appendFormat:@"\n\n\n"];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
        //判断类方法是否存在
        Method classMethod = class_getClassMethod([self.myRunTimeTest class], @selector(showAddress));
        if (classMethod != NULL) {
            NSLog(@"类方法: %@", NSStringFromSelector(method_getName(classMethod)));
            [strM appendFormat:@"判断类方法是否存在\n类方法: %@", NSStringFromSelector(method_getName(classMethod))];
        }
        
        //******显示内容如下******
        //类方法: showAddress
        
        [strM appendFormat:@"\n\n\n"];
#pragma clang diagnostic pop
        
        [weakself alertTitle:@"获取方法" message:strM];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"获取类的协议列表" subTitle:@"class_copyProtocolList" itemOperation:^(NSIndexPath *indexPath) {
        NSMutableString *strM = [NSMutableString string];
        
        unsigned int count;
        Protocol * __unsafe_unretained * protocols = class_copyProtocolList([self.myRunTimeTest class], &count);
        Protocol * protocol;
        for (int i = 0; i < count; i++) {
            protocol = protocols[i];
            NSLog(@"协议名称: %s", protocol_getName(protocol));
            [strM appendFormat:@"协议名称: %s\n", protocol_getName(protocol)];
        }
        
        //******显示内容如下******
        //协议名称: NSCoding
        
        [strM appendFormat:@"\n\n\n"];
        
        NSLog(@"LMJRunTimeTest is%@ responsed to protocol %s", class_conformsToProtocol([self.myRunTimeTest class], protocol) ? @"" : @" not", protocol_getName(protocol));
        
        [strM appendFormat:@"LMJRunTimeTest is%@ responsed to protocol %s", class_conformsToProtocol([self.myRunTimeTest class], protocol) ? @"" : @" not", protocol_getName(protocol)];
        
        //******显示内容如下******
        //LMJRunTimeTest is responsed to protocol NSCoding
        
        [weakself alertTitle:@"获取类的协议列表" message:strM];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"动态增加方法" subTitle:@"class_addMethod" itemOperation:^(NSIndexPath *indexPath) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
        //写在这个中间的代码,都不会被编译器提示-Wundeclared-selector类型的警告
        
        class_addMethod([self.myRunTimeTest class], @selector(guess), (IMP)guessAnswer, "v@:");
        if ([self.myRunTimeTest respondsToSelector:@selector(guess)]) {

            [self.myRunTimeTest performSelector:@selector(guess)];
            
        } else{
            NSLog(@"方法没有增加成功");
        }
        
        [weakself alertTitle:@"动态增加方法" message:@"guess, guessAnswer"];
#pragma clang diagnostic pop
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"分类动态增加属性" subTitle:@"objc_setAssociatedObject" itemOperation:^(NSIndexPath *indexPath) {
        
        LMJRunTimeTest *test=[[LMJRunTimeTest alloc]init];
        [test setWorkName:@"jingdong"];
        
        NSLog(@"当前的公司为：%@",test.workName);
        
        //******显示内容如下******
        //可以为已经存在的类进行分类动态增加属性
        //当前的公司为：XM
        
        [weakself alertTitle:@"分类动态增加属性" message:@"workName"];
    }])
    
    .addItem([LMJWordItem itemWithTitle:@"动态交换两个方法的实现" subTitle:@"method_exchangeImplementations" itemOperation:^(NSIndexPath *indexPath) {
        
        NSMutableString *strM = [NSMutableString string];
        Method m1 = class_getInstanceMethod([self.myRunTimeTest class], @selector(showUserName:));
        Method m2 = class_getInstanceMethod([self.myRunTimeTest class], @selector(showUserAge:));
        
        method_exchangeImplementations(m1, m2);
        
        NSLog(@"%@", [self.myRunTimeTest showUserName:@"njhu"]);
        NSLog(@"%@", [self.myRunTimeTest showUserAge:@"18"]);
        
        //******显示内容如下******
        //注意 如果有参数 记得参数的类型要一样 或者可以进行相应的转换 或者两个方法类型不同会闪退
        //年龄是njhu
        //用户名字是18
        [strM appendFormat:@"showUserName: %@\n", [self.myRunTimeTest showUserName:@"njhu"]];
        [strM appendFormat:@"showUserAge: %@\n", [self.myRunTimeTest showUserAge:@"18"]];
        
        [weakself alertTitle:@"动态交换两个方法的实现" message:strM];
    }]);
    

}

- (void)alertTitle:(NSString *)title message:(NSString *)message
{
    
    [UIAlertController mj_showActionSheetWithTitle:title message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker.addActionDefaultTitle(@"好的");
        
    } actionsBlock:nil];
}




#pragma mark RunTime代码


void guessAnswer(id self,SEL _cmd){
    //一个Objective-C方法是一个简单的C函数，它至少包含两个参数–self和_cmd。所以，我们的实现函数(IMP参数指向的函数)至少需要两个参数
    NSLog(@"我是动态增加的方法响应");
}


#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setDes
{
    UILabel *label = [[UILabel alloc] init];
    label.width = kScreenWidth;
    self.tableView.tableFooterView = label;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    
    label.text = @"***************************************************\n\
    // 获取类的类名\n\
    const char * class_getName ( Class cls );\n\
    \n\
    // 获取类的父类\n\
    Class class_getSuperclass ( Class cls );\n\
    \n\
    // 判断给定的Class是否是一个元类\n\
    BOOL class_isMetaClass ( Class cls );\n\
    \n\
    // 获取实例大小\n\
    size_t class_getInstanceSize ( Class cls );\n\
    \n\
    // 获取类中指定名称实例成员变量的信息\n\
    Ivar class_getInstanceVariable ( Class cls, const char *name );\n\
    \n\
    // 获取类成员变量的信息\n\
    Ivar class_getClassVariable ( Class cls, const char *name );\n\
    \n\
     添加成员变量\n\
    BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );\n\
    \n\
    // 获取整个成员变量列表\n\
    Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );\n\
    \n\
    // 获取指定的属性\n\
    objc_property_t class_getProperty ( Class cls, const char *name );\n\
    \n\
    // 获取属性列表\n\
    objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );\n\
    \n\
    // 为类添加属性\n\
    BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );\n\
    \n\
    // 替换类的属性\n\
    void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );\n\
    \n\
    // 添加方法\n\
    BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );\n\
    \n\
    // 获取实例方法\n\
    Method class_getInstanceMethod ( Class cls, SEL name );\n\
    \n\
    // 获取类方法\n\
    Method class_getClassMethod ( Class cls, SEL name );\n\
    \n\
    // 获取所有方法的数组\n\
    Method * class_copyMethodList ( Class cls, unsigned int *outCount );\n\
    \n\
    // 替代方法的实现\n\
    IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );\n\
    \n\
    // 返回方法的具体实现\n\
    IMP class_getMethodImplementation ( Class cls, SEL name );\n\
    IMP class_getMethodImplementation_stret ( Class cls, SEL name );\n\
    \n\
    // 类实例是否响应指定的selector\n\
    BOOL class_respondsToSelector ( Class cls, SEL sel );\n\
    \n\
    // 添加协议\n\
    BOOL class_addProtocol ( Class cls, Protocol *protocol );\n\
    \n\
    // 返回类是否实现指定的协议\n\
    BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );\n\
    \n\
    // 返回类实现的协议列表\n\
    Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );\n\
    \n\
    // 获取版本号\n\
    int class_getVersion ( Class cls );\n\
    \n\
    // 设置版本号\n\
    void class_setVersion ( Class cls, int version );\n\
    \n\
    ***************************************************\n\
    \n\
    \n\
    \n\
    ***************************************************\n\
    调用指定方法的实现\n\
    id method_invoke ( id receiver, Method m, ... );\n\
    \n\
    // 调用返回一个数据结构的方法的实现\n\
    void method_invoke_stret ( id receiver, Method m, ... );\n\
    \n\
    // 获取方法名\n\
    SEL method_getName ( Method m );\n\
    \n\
    // 返回方法的实现\n\
    IMP method_getImplementation ( Method m );\n\
    \n\
    // 获取描述方法参数和返回值类型的字符串\n\
    const char * method_getTypeEncoding ( Method m );\n\
    \n\
    // 获取方法的返回值类型的字符串\n\
    char * method_copyReturnType ( Method m );\n\
    \n\
    // 获取方法的指定位置参数的类型字符串\n\
    char * method_copyArgumentType ( Method m, unsigned int index );\n\
    \n\
    // 通过引用返回方法的返回值类型字符串\n\
    void method_getReturnType ( Method m, char *dst, size_t dst_len );\n\
    \n\
    // 返回方法的参数的个数\n\
    unsigned int method_getNumberOfArguments ( Method m );\n\
    \n\
    // 通过引用返回方法指定位置参数的类型字符串\n\
    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );\n\
    \n\
    // 返回指定方法的方法描述结构体\n\
    struct objc_method_description * method_getDescription ( Method m );\n\
    \n\
    // 设置方法的实现\n\
    IMP method_setImplementation ( Method m, IMP imp );\n\
    \n\
    // 交换两个方法的实现\n\
    void method_exchangeImplementations ( Method m1, Method m2 );\n\
    \n\
    ***************************************************\n\
    \n\
    \n\
    \n\
    ***************************************************\n\
    方法选择器 SEL\n\
    // 返回给定选择器指定的方法的名称\n\
    const char * sel_getName ( SEL sel );\n\
    \n\
    // 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器\n\
    SEL sel_registerName ( const char *str );\n\
    \n\
    // 在Objective-C Runtime系统中注册一个方法\n\
    SEL sel_getUid ( const char *str );\n\
    \n\
    // 比较两个选择器\n\
    BOOL sel_isEqual ( SEL lhs, SEL rhs );\n\
    \n\
    ***************************************************";
    
    [label sizeToFit];
    
}

@end




#pragma mark RunTime API 说明
/*
***************************************************
// 获取类的类名
const char * class_getName ( Class cls );

// 获取类的父类
Class class_getSuperclass ( Class cls );

// 判断给定的Class是否是一个元类
BOOL class_isMetaClass ( Class cls );

// 获取实例大小
size_t class_getInstanceSize ( Class cls );

// 获取类中指定名称实例成员变量的信息
Ivar class_getInstanceVariable ( Class cls, const char *name );

// 获取类成员变量的信息
Ivar class_getClassVariable ( Class cls, const char *name );

// 添加成员变量
BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );

// 获取整个成员变量列表
Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );

// 获取指定的属性
objc_property_t class_getProperty ( Class cls, const char *name );

// 获取属性列表
objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );

// 为类添加属性
BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

// 替换类的属性
void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

// 添加方法
BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );

// 获取实例方法
Method class_getInstanceMethod ( Class cls, SEL name );

// 获取类方法
Method class_getClassMethod ( Class cls, SEL name );

// 获取所有方法的数组
Method * class_copyMethodList ( Class cls, unsigned int *outCount );

// 替代方法的实现
IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );

// 返回方法的具体实现
IMP class_getMethodImplementation ( Class cls, SEL name );
IMP class_getMethodImplementation_stret ( Class cls, SEL name );

// 类实例是否响应指定的selector
BOOL class_respondsToSelector ( Class cls, SEL sel );

// 添加协议
BOOL class_addProtocol ( Class cls, Protocol *protocol );

// 返回类是否实现指定的协议
BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );

// 返回类实现的协议列表
Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );

// 获取版本号
int class_getVersion ( Class cls );

// 设置版本号
void class_setVersion ( Class cls, int version );

***************************************************



***************************************************
 调用指定方法的实现
    id method_invoke ( id receiver, Method m, ... );

    // 调用返回一个数据结构的方法的实现
    void method_invoke_stret ( id receiver, Method m, ... );

    // 获取方法名
    SEL method_getName ( Method m );

    // 返回方法的实现
    IMP method_getImplementation ( Method m );

    // 获取描述方法参数和返回值类型的字符串
    const char * method_getTypeEncoding ( Method m );

    // 获取方法的返回值类型的字符串
    char * method_copyReturnType ( Method m );

    // 获取方法的指定位置参数的类型字符串
    char * method_copyArgumentType ( Method m, unsigned int index );

    // 通过引用返回方法的返回值类型字符串
    void method_getReturnType ( Method m, char *dst, size_t dst_len );

    // 返回方法的参数的个数
    unsigned int method_getNumberOfArguments ( Method m );

    // 通过引用返回方法指定位置参数的类型字符串
    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );

    // 返回指定方法的方法描述结构体
    struct objc_method_description * method_getDescription ( Method m );

    // 设置方法的实现
    IMP method_setImplementation ( Method m, IMP imp );

    // 交换两个方法的实现
    void method_exchangeImplementations ( Method m1, Method m2 );

***************************************************



***************************************************
方法选择器 SEL
// 返回给定选择器指定的方法的名称
const char * sel_getName ( SEL sel );

// 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
SEL sel_registerName ( const char *str );

// 在Objective-C Runtime系统中注册一个方法
SEL sel_getUid ( const char *str );

// 比较两个选择器
BOOL sel_isEqual ( SEL lhs, SEL rhs );

***************************************************
*/

