#iOS PickerView整合，一行代码调用（省市区三级联动+日期选择+普通选择）

支持CocoaPods安装，

pod 'MOFSPickerManager'即可

# 预览图

![image](https://github.com/memoriesofsnows/MOFSPickerManagerDemo/blob/master/images/tap9.gif)

# 用法
1.日期选择器调用（有多种调用方式，看demo即可）

    [[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {

    } cancelBlock:^{

    }];

参数说明

* @param title : 中间标题，一般为nil

* @param cancelTitle : 左边标题 “取消”

* @param commitTitle : 右边标题 “确定”

* @param firstDate :第一次点击的时候显示的日期

* @param minDate : 可选择的最小日期，不限制则为nil

* @param maxDate : 可选择的最大日期，不限制则为nil

* @param tag ： 同一个界面显示多个日期选择器的时候，能够记住每一个选择器最后选择的日期（注意：不要使用相同的tag值）

* @param model : UIDatePickerMode 日期模式，有四种 UIDatePickerModeTime,   UIDatePickerModeDate, UIDatePickerModeDateAndTime, UIDatePickerModeCountDownTimer

2.普通选择器调用

    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:@[@"疾风剑豪",@"刀锋意志",@"诡术妖姬",@"狂战士"] tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {

    } cancelBlock:^{

    }];

3.地址选择器调用

    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {

    } cancelBlock:^{

    }];

地址选择器附带根据地址查询区域码或者根据区域码查询地址功能：

用法：

【注意：一定要用“-”间隔，可查询省份例如传参"450000"；或者省份+城市例如"450000-450900"；也可以查省+市+区例如"450000-450900-450921"
。根据地址查区域码以此类推。】

①根据区域码查询地址

    [[MOFSPickerManager shareManger] searchAddressByZipcode:@"450000-450900-450921" block:^(NSString *address) {

    NSLog(@"%@",address);

    }];

②根据地址查询区域码

    [[MOFSPickerManager shareManger] searchZipCodeByAddress:@"河北省-石家庄市-长安区" block:^(NSString *zipcode) {

    NSLog(@"%@",zipcode);

    }];
    
    
#详情请查看http://www.jianshu.com/p/578065eab5ab
    
    
如果发现有bug，call me！

晚上睡不着？？ call me！

come on！ touch me！！！

luoyuant@163.com
